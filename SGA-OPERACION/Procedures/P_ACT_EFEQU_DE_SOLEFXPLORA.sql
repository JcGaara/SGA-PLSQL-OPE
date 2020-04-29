CREATE OR REPLACE PROCEDURE OPERACION.P_ACT_EFEQU_DE_SOLEFXPLORA(an_codef ef.codef%type) IS
  ls_numslcori vtatabslcfac.numslc%type;
    cursor cur_equipos_xplora is
    SELECT vtadetslcfacequ.numpto punto,
           rownum orden,
           tipequ.codtipequ codtipequ,
           tipequ.tipequ tipequ,
           vtadetslcfacequ.cantidad * equipoxetapa.costo costo,
           vtadetslcfacequ.cantidad * equcomxope.cantidad cantidad,
           decode(producto.IDGRUPOPRODUCTO, 1, 1, 2, 2, 1) tipprp,
           vtadetslcfacequ.codequcom codequcom,
           instancia_paquete.idinsxpaq,
           instancia_paquete.idpaq idpaq,
           instancia_paquete.iddet,
           instancia_paquete.numpto,
           equipoxetapa.codeta
      FROM (select rr.numslc,
                   yy.idsolucion,
                   numpto_prin numpto,
                   codequcom,
                   IDPRODUCTO,
                   idinsxpaq,
                   numpto numptoori,
                   cantidad
              from vtadetptoenl rr, vtatabslcfac yy
             where rr.numslc = yy.numslc
               and rr.numslc = lpad(an_codef, 10, 0)
               and codequcom is not null) vtadetslcfacequ,
           equcomxope,
           tipequ,
           producto,
           ef,
           instancia_paquete,
           equipoxetapa
     WHERE vtadetslcfacequ.codequcom = equcomxope.codequcom
       and tipequ.tipequ = equcomxope.tipequ
       and vtadetslcfacequ.numslc = ef.numslc
       and vtadetslcfacequ.idproducto = producto.idproducto(+)
       and vtadetslcfacequ.idsolucion = equipoxetapa.idsolucion
       and ef.codef = an_codef
       and 1 = 1
       and equcomxope.esparte = 0
       AND TO_NUMBER(vtadetslcfacequ.numpto) IN
           (SELECT PUNTO FROM EFPTO WHERE CODEF = an_codef)
       and vtadetslcfacequ.idinsxpaq = instancia_paquete.idinsxpaq
       and vtadetslcfacequ.numslc = instancia_paquete.numslc
       and vtadetslcfacequ.numptoori = instancia_paquete.numpto
       and instancia_paquete.idpaq = equipoxetapa.idpaq
       and instancia_paquete.iddet = equipoxetapa.iddet
       and vtadetslcfacequ.codequcom = equipoxetapa.codequcom
       and instancia_paquete.codequcom = equipoxetapa.codequcom
       and equipoxetapa.tipequ is null
       and equipoxetapa.codeta is not null;

  cursor cur_equipos_xplora2 is
    SELECT vtadetslcfacequ.numpto punto,
           rownum orden,
           tipequ.codtipequ codtipequ,
           tipequ.tipequ tipequ,
           vtadetslcfacequ.cantidad * equipoxetapa.costo costo,
           vtadetslcfacequ.cantidad * equcomxope.cantidad cantidad,
           decode(producto.IDGRUPOPRODUCTO, 1, 1, 2, 2, 1) tipprp,
           vtadetslcfacequ.codequcom codequcom,
           instancia_paquete.idinsxpaq,
           instancia_paquete.idpaq idpaq,
           instancia_paquete.iddet,
           instancia_paquete.numpto,
           equipoxetapa.codeta
      FROM (select rr.numslc,
                   yy.idsolucion,
                   numpto_prin numpto,
                   codequcom,
                   IDPRODUCTO,
                   idinsxpaq,
                   numpto numptoori,
                   cantidad
              from vtadetptoenl rr, vtatabslcfac yy
             where rr.numslc = yy.numslc
               and rr.numslc = lpad(an_codef, 10, 0)
               and codequcom is not null
               and codequcom not in
                   (select codequcom
                      from vtadetptoenl rr, vtatabslcfac yy
                     where rr.numslc = yy.numslc
                       and rr.numslc = ls_numslcori
                       and codequcom is not null)) vtadetslcfacequ,
           equcomxope,
           tipequ,
           producto,
           ef,
           instancia_paquete,
           equipoxetapa
     WHERE vtadetslcfacequ.codequcom = equcomxope.codequcom
       and tipequ.tipequ = equcomxope.tipequ
       and vtadetslcfacequ.numslc = ef.numslc
       and vtadetslcfacequ.idproducto = producto.idproducto(+)
       and vtadetslcfacequ.idsolucion = equipoxetapa.idsolucion
       and ef.codef = an_codef
       and 1 = 1
       and equcomxope.esparte = 0
       AND TO_NUMBER(vtadetslcfacequ.numpto) IN
           (SELECT PUNTO FROM EFPTO WHERE CODEF = an_codef)
       and vtadetslcfacequ.idinsxpaq = instancia_paquete.idinsxpaq
       and vtadetslcfacequ.numslc = instancia_paquete.numslc
       and vtadetslcfacequ.numptoori = instancia_paquete.numpto
       and instancia_paquete.idpaq = equipoxetapa.idpaq
       and instancia_paquete.iddet = equipoxetapa.iddet
       and vtadetslcfacequ.codequcom = equipoxetapa.codequcom
       and instancia_paquete.codequcom = equipoxetapa.codequcom
       and equipoxetapa.tipequ is null
       and equipoxetapa.codeta is not null;

  cursor cur_act_xplora is
    select numslc, min(numpto_prin) punto -- Agregado 02/08/2007
      from vtadetptoenl ve
     where numslc = LPAD(an_codef, 10, '0')
       and codequcom is not null
     group by numslc;

  -- Fin Eliminado 02/08/2007
  max_orden      efptoequ.orden%type;
  row_equ_xplora cur_equipos_xplora%rowtype;
  ln_count       number;
  ln_count1     number;
  ls_tipsrv tystipsrv.tipsrv%type;
  vreg efptoetaact%rowtype;

BEGIN

  delete efptoequ where codef = an_codef;
  delete efptoequcmp where codef = an_codef;
  delete efptoetaact where codef = an_codef;
  delete efptoeta where codef = an_codef;

  --agregado para ventas complementarias.
  select count(*)
    into ln_count
    from INSTANCIA_PAQUETE_CAMBIO
   where numslc = lpad(an_codef, 10, 0);

   select count(*)
    into ln_count1
    from regvtamentab
   where numslc = lpad(an_codef, 10, 0);

   if ln_count1 > 0 then
      select numslc_ori
        into ls_numslcori
        from regvtamentab
       where numslc = lpad(an_codef, 10, 0);
   end if;

  if ln_count = 0 then
    OPEN cur_equipos_xplora;
  end if;
  if ln_count > 0 then
    OPEN cur_equipos_xplora2;
  end if;

  loop

    if ln_count = 0 then
      fetch cur_equipos_xplora
        into row_equ_xplora;
    end if;
    if ln_count = 0 then
      exit when cur_equipos_xplora%notfound;
    end if;
    if ln_count > 0 then
      fetch cur_equipos_xplora2
        into row_equ_xplora;
    end if;
    if ln_count > 0 then
      exit when cur_equipos_xplora2%notfound;
    end if;

    -- Se obtiene el max orden para evitar dup de PK
    select nvl(max(orden), 0) + 1
      into max_orden
      from efptoequ
     where codef = an_codef
       and punto = row_equ_xplora.punto;

    insert into efptoequ
      (codef, punto, orden, codtipequ, tipequ, tipprp, cantidad, codequcom, costo, codeta)
    values
      (an_codef,
       row_equ_xplora.punto,
       max_orden, --         + row_equ.orden,
       row_equ_xplora.codtipequ,
       row_equ_xplora.tipequ,
       row_equ_xplora.tipprp,
       row_equ_xplora.cantidad,
       row_equ_xplora.codequcom,
       row_equ_xplora.costo,
       row_equ_xplora.codeta);

    insert into efptoequcmp
      (codef, punto, orden, ordencmp, cantidad, codtipequ, tipequ, costo, codeta)
      select an_codef,
             row_equ_xplora.punto,
             max_orden,
             rownum,
             equipoxetapa.cantidad,
             equcomxope.codtipequ,
             equipoxetapa.tipequ,
             equipoxetapa.costo,
             equipoxetapa.codeta
        from equipoxetapa, equcomxope
       where equipoxetapa.idpaq = row_equ_xplora.idpaq
         and equipoxetapa.CODEQUCOM = row_equ_xplora.codequcom
         and equipoxetapa.codequcom = equcomxope.codequcom
         and equipoxetapa.tipequ is not null
         and equcomxope.tipequ = equipoxetapa.tipequ
         and equcomxope.esparte = 1;

  END LOOP;

  if ln_count = 0 then
    close cur_equipos_xplora;
  end if;
  if ln_count > 0 then
    close cur_equipos_xplora2;
  end if;

  for row_act_xplora in cur_act_xplora loop
    select tipsrv
      into ls_tipsrv
      from vtatabslcfac
     where numslc = lpad(an_codef, 10, 0);

    if ls_tipsrv = '0058' then
           vreg.costo := 0;
           vreg.moneda := 'D';
           vreg.codact :=4162;
           vreg.codprec :=2;
     end if;

    if ls_tipsrv = '0061' then
           vreg.costo := 80;
           vreg.moneda := 'S';
           vreg.codact :=11791;
           vreg.codprec :=7;
    end if;

    if vreg.moneda = 'D'  then
            vreg.moneda_id := 2;
    else vreg.moneda_id:=1;
    end if;

    if ls_tipsrv = '0058' or ls_tipsrv = '0061' then
            insert into efptoeta (codef, punto, codeta, cosmo)
            values (an_codef, row_act_xplora.punto, 645, vreg.costo);

            insert into efptoetaact (codef, punto, codeta, codact, costo, cantidad, moneda, moneda_id, codprec)
            values (an_codef, row_act_xplora.punto, 645, vreg.codact, vreg.costo, 1, vreg.moneda, vreg.moneda_id, vreg.codprec);
    end if;

  end loop;
END;
/


