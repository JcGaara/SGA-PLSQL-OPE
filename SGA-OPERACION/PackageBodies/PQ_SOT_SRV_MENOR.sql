CREATE OR REPLACE PACKAGE BODY OPERACION.pq_sot_srv_menor is
  procedure p_baja_cambioplan(a_idtareawf in number, a_idwf in number, a_tarea in number, a_tareadef in number) is
    n_codsolot solot.codsolot%type; --<1.0>
    --vreg       reginsprdbaja%rowtype; <1.0>
    n_fecfin   date;
  begin
  select codsolot into n_codsolot from wf where idwf = a_idwf;
  --<1.0
    /*
    select distinct numregistro
      into vreg.numregistro
      from reginsprdbaja
     where codsolot = n_codsolot;

    select distinct numslc
      into vreg.numslc
      from regvtamentab
     where numregistro = vreg.numregistro;


    select nvl(fecini, trunc(sysdate)) - 1
      into vreg.fecusu
      from insprd
     where numslc = vreg.numslc
       and fecini is not null
       and rownum = 1;*/
    select trunc(sysdate)-1 into n_fecfin from dual;
       --1.0>
    --operacion.p_ejecuta_activ_desactiv(n_codsolot, 299, vreg.fecusu); <1.0>
    operacion.p_ejecuta_activ_desactiv(n_codsolot, 299, n_fecfin);
  end;
  procedure p_interviene_tarea(a_idtareawf in number, a_idwf in number, a_tarea in number, a_tareadef in number) is
            n_codsolot solot.codsolot%type;
            ls_numslcold vtatabslcfac.numslc%type;
            vreg vtatabslcfac%rowtype;
            ln_tiponew number;
            ln_tipoold number;
            ln_agenda number;
  begin
  ln_agenda := 0;
  begin
    select codsolot into n_codsolot from wf where idwf = a_idwf;
    select a.numslc_ori,b.numslc
      into ls_numslcold,vreg.numslc
      from regvtamentab a, solot b
     where a.numslc=b.numslc
     and b.codsolot = n_codsolot;
   exception
    when no_data_found then
      return;
  end;
  -- validac si pasa de analogico a digital.
  select distinct b.tipo
  into ln_tipoold
  from vtadetptoenl a,paquete_venta b
  where a.idpaq=b.idpaq
  and a.numslc=ls_numslcold;

  select distinct b.tipo
  into ln_tiponew
  from vtadetptoenl a,paquete_venta b
  where a.idpaq=b.idpaq
  and a.numslc=vreg.numslc;

  if ln_tiponew <> ln_tipoold then
     ln_agenda:=1;
     OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a_idtareawf,4,8,0,SYSDATE,SYSDATE);
  end if;

  if ln_agenda = 0 then

    select count(distinct b.tipsrv)
    into ln_tiponew
    from vtadetptoenl a,producto b
    where a.idproducto=b.idproducto
    and b.tipsrv in('0004','0006','0062')
    and a.numslc=ls_numslcold;

    select count(distinct b.tipsrv)
    into ln_tipoold
    from vtadetptoenl a,producto b
    where a.idproducto=b.idproducto
    and b.tipsrv in('0004','0006','0062')
    and a.numslc=vreg.numslc;

      if ln_tiponew <> ln_tipoold then
         OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a_idtareawf,4,8,0,SYSDATE,SYSDATE);
      end if;
  end if;
  end;
  procedure p_interviene_ri(a_idtareawf in number, a_idwf in number, a_tarea in number, a_tareadef in number) is
            n_codsolot solot.codsolot%type;
            ls_numslc_ori vtatabslcfac.numslc%type;
            vreg vtatabslcfac%rowtype;
            ls_codigold tystabsrv.codigo_ext%type;
            ls_codignew tystabsrv.codigo_ext%type;
            ln_ri number;
  begin
  ln_ri := 0;
  select codsolot into n_codsolot from wf where idwf = a_idwf;
  select a.numslc_ori,b.numslc
    into ls_numslc_ori,vreg.numslc
    from regvtamentab a, solot b
   where a.numslc=b.numslc
   and b.codsolot = n_codsolot;

  select distinct b.codigo_ext
  into ls_codigold
  from vtadetptoenl a,tystabsrv b
  where a.codsrv=b.codsrv
  and a.numslc = ls_numslc_ori;

  select distinct b.codigo_ext
  into ls_codignew
  from vtadetptoenl a,tystabsrv b
  where a.codsrv=b.codsrv
  and a.numslc = vreg.numslc;

  if ls_codignew <> ls_codigold and ls_codignew = 'TMXCNT' then
    ln_ri := 1;
  end if;

  end;

  procedure p_baja_totalservicio(a_idtareawf in number, a_idwf in number, a_tarea in number, a_tareadef in number) is
   n_codsolot solot.codsolot%type;
   vreg       solot%rowtype;
  --3.0
  l_idtareawf tareawf.idtareawf%type;

    cursor c_trssolot is
      select codtrs, fectrs, esttrs
        from trssolot
       where codsolot = n_codsolot;
 --3.0
  begin
    select codsolot into n_codsolot from wf where idwf = a_idwf;

    select * into vreg from solot where codsolot=n_codsolot;

     if vreg.feccom is not null then
     --<3.0
      --operacion.p_ejecuta_activ_desactiv(n_codsolot, 299, vreg.feccom); --<3.0>
              OPERACION.pq_solot.p_crear_trssolot(4,
                                                  n_codsolot,
                                                  null,
                                                  null,
                                                  null,
                                                  null);
              for lc_trssolot in c_trssolot loop
                operacion.pq_solot.p_exe_trssolot(lc_trssolot.codtrs,
                                                  2,
                                                  vreg.feccom);
              end loop;
      --3.0>
     end if;
  end;
end pq_sot_srv_menor;
/


