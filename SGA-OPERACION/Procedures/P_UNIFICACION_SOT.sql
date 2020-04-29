CREATE OR REPLACE PROCEDURE OPERACION.P_UNIFICACION_SOT IS
/******************************************************************************
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        20/06/2008  Hector Huaman M. Procedimiento que agrupa las SOt, del mismo proyecto, direccion , tipo de trabajo y con mismo POP
   2.0        27/07/2009  Hector Huaman M. REQ 98231.se modifico procedimiento para que la unificacion tome como base la SOT de instalacion.
   3.0        23/01/2014  Miriam Mandujano REQ se modifico procedimiento para que la unificacion distribuya los numeros adicionales en todas las sot
******************************************************************************/
    l_codsolot solot.codsolot%type;
    l_tiptra solot.tiptra%type;
    l_codubi solotpto.codubi%type;
    l_numslc solot.numslc%type;
    l_valida number;
    l_cnt_trs number;
    l_pop solotpto.pop%type;
    l_popsolot solotpto.pop%type;

    CURSOR c1 IS
      select
         distinct solot_1.numslc
        from solot solot_1,
        solot solot_2
        where
        solot_1.numslc=solot_2.numslc
        and solot_1.codsolot<>solot_2.codsolot
        and ( (solot_1.tiptra=solot_2.tiptra and (solot_1.tiptra not in(1) and solot_2.tiptra not in(1) ))
        or ((solot_1.tiptra in(1) and solot_2.tiptra in(170)) or (solot_1.tiptra in(170) and solot_2.tiptra in(1)) )  )
        and solot_1.estsol=11
        and solot_2.estsol=11
        and solot_1.fecusu >=TO_DATE('01/06/2008','dd/mm/yyyy hh24:mi:ss')
       -- no considerad clientes internos
       and solot_1.codcli not in ('00385487','00099172','00591831','00577343','00580366','00017603',
       '00329691','00006932','00003653','00385533','00088224','00380908','00022812','00452313')
        order by solot_1.numslc desc;

--Diferentes Direccion en una mismo proyecto y igual tip de sot
     CURSOR c_direc_tip IS
      select
      distinct sp.codubi
      from
      solot s,
      solotpto sp
      where
      s.numslc=l_numslc
      and sp.codinssrv_tra is null
      and s.codsolot=sp.codsolot
      and s.tiptra=l_tiptra;
--Sot con misma direccion
    CURSOR c_direc IS
        select
        distinct s2.codsolot
        from solot s1,
        solotpto sp1,
        solot s2,
        solotpto sp2
        where
        s1.numslc=s2.numslc
        --and s1.tiptra=s2.tiptra
        and ((s1.tiptra=s2.tiptra)
        or (s1.tiptra in(1,170) and s2.tiptra in(1,170)))
        and s1.codsolot=sp1.codsolot
        and s2.codsolot=sp2.codsolot
        and sp1.direccion=sp2.direccion
        and sp1.descripcion=sp1.descripcion
        and (sp1.codinssrv_tra is null and sp2.codinssrv_tra is null)
        and ( (sp1.cid=sp2.cid) or (sp1.cid is null and sp2.cid is null))
        and sp1.codubi=l_codubi
        and s1.tiptra < s2.tiptra --<2.0>
        and s1.estsol=11
        and s2.estsol=11
        and s1.codsolot=l_codsolot
        and s1.codsolot<>s2.codsolot
        --<ini 3.0>
        and rownum =1 order by 1;  
        --<fin 3.0>
     --Diferentes tipos de Sot
     CURSOR c_tiptra IS
        select distinct tiptra
        from solot
        where
        numslc = l_numslc
        and  estsol = 11
       ;

    CURSOR c_solot is
    select distinct s.codsolot  --<3.0>
   -- into l_codsolot
    from solot s,
    solotpto sp
    where
    sp.codubi=l_codubi
    and sp.codsolot=s.codsolot
    and sp.codinssrv_tra is null
    and estsol=11
    and numslc=l_numslc
    and tiptra=l_tiptra
    order by 1;--<3.0>
   -- and rownum=1


BEGIN
  for au in c1 loop

  l_numslc:=au.numslc;

  for az in c_tiptra loop
    l_tiptra:=az.tiptra;

    for au in c_direc_tip loop
    l_codubi:=au.codubi;

    for a1 in c_solot loop
    l_codsolot:=a1.codsolot;

    for aw in c_direc loop

      select count(*)
        into l_valida
        from solot s1, solot s2, solotpto p1, solotpto p2
       where s1.codsolot = l_codsolot
         and s2.codsolot = aw.codsolot
         and p1.direccion = p2.direccion
         and s1.codsolot = p1.codsolot
         and s2.codsolot = p2.codsolot
         ;

     ---verifica si tiene pop
BEGIN
      select efpto.pop
      into  l_popsolot
      from efpto,solotpto
      where efpto.codef = to_number(l_numslc)
      and efpto.punto = solotpto.efpto
      and solotpto.codsolot=l_codsolot
      and efpto.pop is not null
      and rownum=1;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        l_popsolot := NULL;
        END;


      BEGIN
      select efpto.pop
      into  l_pop
      from efpto,solotpto
      where efpto.codef = to_number(l_numslc)
      and efpto.punto = solotpto.efpto
      and solotpto.codsolot=aw.codsolot
      and efpto.pop is not null
      and rownum=1;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        l_pop := NULL;
        END;
    if (l_pop is null and l_popsolot is null ) or (l_pop=l_popsolot)then

     ---Que no tenga transacciones generadas
     select count(*) into l_cnt_trs from trssolot
     where codsolot = aw.codsolot;

      if l_valida >= 0 and l_cnt_trs=0 then
        P_ASOCIAR_SOLOT(l_codsolot, aw.codsolot);
        update tmp_solot_codigo set estado=4 where codsolot=aw.codsolot;
      end if;

      end if;
      end loop;

    end loop;

    end loop;
  end loop;

  end loop;

END;
/
