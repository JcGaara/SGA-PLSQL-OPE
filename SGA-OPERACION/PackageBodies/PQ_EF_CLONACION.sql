CREATE OR REPLACE PACKAGE BODY OPERACION.PQ_EF_CLONACION AS
/******************************************************************************
   NAME:       PQ_EF_CLONACION
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        21/12/2005             1. Created this package.
   2.0        21/12/2005  Jorge Armas.  RQIT 164919 - IDEA-15668 - Proyecto de Renovación en SGA
******************************************************************************/


/**********************************************************************
Copia los puntos de un ef origen a un ef destino
**********************************************************************/
   --<ini 2.0>modif
  PROCEDURE p_clonar_ef(a_codef_origen in number, a_codsolot_origen in number ,
                        a_codef_destino in number, a_codsolot_destino in number)
  IS
  BEGIN
        p_clonar_puntos(a_codef_origen,a_codsolot_origen, a_codef_destino,a_codsolot_destino); --2.0

        p_clonar_etapas(a_codef_origen, a_codef_destino);

        p_clonar_actividades(a_codef_origen, a_codef_destino);

        p_clonar_materiales(a_codef_origen, a_codef_destino);

        p_clonar_formulas(a_codef_origen, a_codef_destino);

        p_clonar_datos(a_codef_origen, a_codef_destino);

        p_clonar_informes(a_codef_origen, a_codef_destino);

        p_clonar_metrados(a_codef_origen, a_codef_destino);

        p_clonar_solxarea_ef_rnv(a_codef_origen,a_codef_destino); --2.0

        p_act_ef_rnv(a_codef_origen,a_codef_destino); --2.0

        -- Registrando clonacion
        p_registro_clonacion(a_codef_origen,a_codef_destino,a_codsolot_origen,a_codsolot_destino); --2.0

  exception
        when others then
          RAISE_APPLICATION_ERROR (-20900, sqlcode ||'-'||sqlerrm ||' No se pudo clonar  ef_origen ' ||
                                    to_char(a_codef_origen) || ',solot_origen ' || to_char(a_codef_destino));
  END;
   --<fin 2.0>modif


/**********************************************************************
Copia los puntos de un ef origen a un ef destino
**********************************************************************/
  --<ini 2.0>modif
  PROCEDURE p_clonar_puntos(a_codef_origen in number,a_codsolot_origen in number, a_codef_destino in number,a_codsolot_destino in number)
  IS
  l_cnt     number(2);
  BEGIN
    delete from operacion.efptoequcmp epe where epe.codef=a_codef_destino;
    delete from operacion.efptoequ epe where epe.codef=a_codef_destino;
    delete from operacion.efptoetaact epe where epe.codef=a_codef_destino;
    delete from operacion.efptoetadat epe where epe.codef=a_codef_destino;
    delete from operacion.efptoetafor epe where epe.codef=a_codef_destino;
    delete from operacion.efptoetainf epe where epe.codef=a_codef_destino;
    delete from operacion.efptoetamat epe where epe.codef=a_codef_destino;

    delete from operacion.efptoeta epe where epe.codef=a_codef_destino;
    delete from operacion.efptomet met where met.codef=a_codef_destino;
    delete from operacion.efpto ep where ep.codef=a_codef_destino;
    

    insert into efpto(codef, punto, descripcion, codinssrv, codsuc, codubi,
                      pop, direccion, codsrv, bw, cosmo, cosmat, cosequ, cosmocli, cosmatcli,
                      fecini, numdiapla, fecfin, observacion, coordx1, coordy1, coordx2,
                      coordy2,tiptra, nrolineas, nrofacrec, nrohung, nroigual, cosmo_s,
                      cosmat_s, codtipfibra, lonfibra, nrocanal, tiptraef, tiprechazo_ope,
                      tiprechazo_fnz, codcon, fecconasig, fecconfin, login, dominio)
    select  a_codef_destino, punto, descripcion, codinssrv, codsuc, codubi,
            pop, direccion, codsrv, bw, cosmo, cosmat, cosequ, cosmocli, cosmatcli,
            fecini, numdiapla, fecfin, observacion, coordx1, coordy1, coordx2,
            coordy2, tiptra, nrolineas, nrofacrec, nrohung, nroigual, cosmo_s,
            cosmat_s, codtipfibra, lonfibra, nrocanal, tiptraef, tiprechazo_ope,
            tiprechazo_fnz, codcon, fecconasig, fecconfin, login, dominio
    from  efpto where  codef = a_codef_origen;

    insert into efptoequ(codef,punto,orden,codtipequ,tipprp,observacion,costear,
                         cantidad,costo,codequcom,fecusu,codusu,tipequ,
                         codeta,idspcab)
    select a_codef_destino,epeq.punto,epeq.orden,epeq.codtipequ,epeq.tipprp,epeq.observacion,epeq.costear,
           epeq.cantidad,epeq.costo,epeq.codequcom,epeq.fecusu,epeq.codusu,epeq.tipequ,
           epeq.codeta,epeq.idspcab
    from operacion.efptoequ epeq where epeq.codef=a_codef_origen;

    insert into efptoequcmp(codef,punto,orden,ordencmp,observacion,cantidad,codtipequ,costo,
                            codusu,tipequ,costear,codeta,idspcab)
    select a_codef_destino,punto,orden,ordencmp,observacion,cantidad,codtipequ,costo,
           codusu,tipequ,costear,codeta,idspcab
    from operacion.efptoequcmp epeq where epeq.codef=a_codef_origen;
    -- Verificamos la SOLOTPTO
    SELECT COUNT(*)
      INTO l_cnt
      FROM operacion.solotpto sp
     WHERE sp.codsolot = a_codsolot_destino;
    IF  l_cnt = 0 THEN
        insert into operacion.solotpto (codsolot,punto,tiptrs,codsrvant,bwant,codsrvnue,bwnue,
                                        codusu,fecusu,codinssrv,cid,descripcion,direccion,tipo,estado,
                                        visible,puerta,pop,codubi,fecini,fecfin,fecinisrv,feccom,tiptraef,
                                        tipotpto,efpto,pid,pid_old,cantidad,codpostal,flgmt,codinssrv_tra,mediotx,
                                        provenlace,flg_agenda,cintillo,ncos_old,ncos_new,idplataforma,idplano,codincidence,
                                        segment_name,cell_id)
        select a_codsolot_destino,sp.punto,sp.tiptrs,sp.codsrvant,sp.bwant,sp.codsrvnue,sp.bwnue,
               sp.codusu,sp.fecusu, sp.codinssrv, sp.cid,sp.descripcion,sp.direccion,sp.tipo,sp.estado,
               sp.visible,sp.puerta,sp.pop,sp.codubi,sp.fecini,sp.fecfin,sp.fecinisrv,sp.feccom,sp.tiptraef,
               sp.tipotpto,sp.efpto,sp.pid,sp.pid_old,sp.cantidad,sp.codpostal,sp.flgmt,sp.codinssrv_tra,sp.mediotx,
               sp.provenlace,sp.flg_agenda,sp.cintillo,sp.ncos_old,sp.ncos_new,sp.idplataforma,sp.idplano,sp.codincidence,
               sp.segment_name,sp.cell_id
        from operacion.solotpto sp where sp.codsolot=a_codsolot_origen;
    END IF;  
    -- Verificamos la solotptoequ
    SELECT COUNT(*)
    INTO l_cnt
    FROM operacion.solotptoequ sp
    WHERE sp.codsolot = a_codsolot_destino;
    IF  l_cnt = 0 THEN   
        insert into operacion.solotptoequ
          (codsolot, punto, orden, tipequ, cantidad, tipprp, costo, numserie, fecins, instalado, 
           estado, codequcom, tipo, flginv, fecinv, tipcompra, observacion, codusu, fecusu, codot, 
           enacta, pccodtarea, pctipgasto, pcidorggasto, flgsol, flgreq, codeta, codalmacen, 
           flg_ventas, codalmof, fecfins, fecfdis, id_sol, tran_solmat, codusudis, nro_res, 
           nro_res_l, pep, pep_leasing, mac, fecgenreserva, usugenreserva, flg_ingreso, centrosap, 
           almacensap, flg_despacho, valida_almacen, trans_despacho, imsi, nro_pin, flg_recuperacion, 
           recuperable, aplica_cliente, idagenda, codsolot_recuperacion, acta, idspcab, iddet, 
           pep_pe05, pepleasing_pe05, centrosap_pe05, canliq, estadoequ, fec_recupero, fec_almacen, 
           codmotivo_averia, sptoc_est_despacho, spton_dctosap)
        SELECT a_codsolot_destino, punto, orden, tipequ, cantidad, tipprp, costo, numserie, fecins, instalado, 
          estado, codequcom, tipo, flginv, fecinv, tipcompra, observacion, codusu, fecusu, codot, 
          enacta, pccodtarea, pctipgasto, pcidorggasto, flgsol, flgreq, codeta, codalmacen, 
          flg_ventas, codalmof, fecfins, fecfdis, id_sol, tran_solmat, codusudis, nro_res, 
          nro_res_l, pep, pep_leasing, mac, fecgenreserva, usugenreserva, flg_ingreso, centrosap, 
          almacensap, flg_despacho, valida_almacen, trans_despacho, imsi, nro_pin, flg_recuperacion, 
          recuperable, aplica_cliente, idagenda, codsolot_recuperacion, acta, idspcab, iddet, 
          pep_pe05, pepleasing_pe05, centrosap_pe05, canliq, estadoequ, fec_recupero, fec_almacen, 
          codmotivo_averia, sptoc_est_despacho, spton_dctosap
        FROM operacion.solotptoequ
        where codsolot = a_codsolot_origen;
    END IF;
    -- Verificamos la solotptoequcmp
    SELECT COUNT(*)
    INTO l_cnt
    FROM operacion.solotptoequcmp sp
    WHERE sp.codsolot = a_codsolot_destino;
    
    IF  l_cnt = 0 THEN          
        insert into operacion.solotptoequcmp
            (codsolot, punto, orden, ordencmp, tipequ, cantidad, costo, numserie, fecins, instalado, 
             estado, observacion, codusu, fecusu, flgsol, flgreq, id_sol, codeta, tran_solmat, nro_res, 
             nro_res_l, pep, pep_leasing, fecgenreserva, usugenreserva, flg_recuperacion, pep_pe05, 
             pepleasing_pe05, idspcab)
        SELECT a_codsolot_destino, punto, orden, ordencmp, tipequ, cantidad, costo, numserie, fecins, 
               instalado, estado, observacion, codusu, fecusu, flgsol, flgreq, id_sol, codeta, tran_solmat, 
               nro_res, nro_res_l, pep, pep_leasing, fecgenreserva, usugenreserva, flg_recuperacion, pep_pe05, 
               pepleasing_pe05, idspcab
        FROM operacion.solotptoequcmp
        where codsolot = a_codsolot_origen;        
    END IF;    
  -- commit;
 --<fin 2.0>modif
  exception
        when others then
          RAISE_APPLICATION_ERROR (-20900, sqlcode ||'-'||sqlerrm || 'No se pudo clonar los puntos del ef ' ||
                                    to_char(a_codef_origen) || ' al ef ' || to_char(a_codef_destino));
  END;



/**********************************************************************
Copia las etapas de un ef origen a un ef destino
**********************************************************************/
  PROCEDURE p_clonar_etapas(a_codef_origen in number, a_codef_destino in number)
  IS
  BEGIN
      insert into efptoeta(codef, punto, codeta, fecini, fecfin, cosmo,
                           cosmocli, cosmat, cosmatcli, cosmo_s, cosmat_s, pccodtarea)
      select a_codef_destino, punto, codeta, fecini, fecfin, cosmo,
             cosmocli, cosmat, cosmatcli, cosmo_s, cosmat_s, pccodtarea
      from efptoeta where codef = a_codef_origen;

     -- commit; --2.0

  exception
        when others then
              RAISE_APPLICATION_ERROR (-20900, sqlcode ||'-'||sqlerrm || 'No se pudo clonar las etapas del ef ' || to_char(a_codef_origen) || ' al ef ' || to_char(a_codef_destino));
  END;


/**********************************************************************
Copia las actividades de un ef origen a un ef destino
**********************************************************************/
  PROCEDURE p_clonar_actividades(a_codef_origen in number, a_codef_destino in number)
  IS
  BEGIN
       insert into efptoetaact(codef, punto, codeta, codact, costo, cantidad,
                               observacion, moneda, moneda_id, codprec)
       select a_codef_destino, punto, codeta, codact, costo, cantidad,
              observacion, moneda, moneda_id, codprec
       from efptoetaact where codef = a_codef_origen;

     -- commit; --2.0

  exception
       when others then
         RAISE_APPLICATION_ERROR (-20900, sqlcode || 'No se pudo clonar las actividades del ef ' || to_char(a_codef_origen) || ' al ef ' || to_char(a_codef_destino));
  END;


/**********************************************************************
Copia los materiales de un ef origen a un ef destino
**********************************************************************/
  PROCEDURE p_clonar_materiales(a_codef_origen in number, a_codef_destino in number)
  IS
  BEGIN
       insert into efptoetamat(codef, punto, codeta, codmat, costo, cantidad)
       select a_codef_destino, punto, codeta, codmat, costo, cantidad
       from efptoetamat where codef = a_codef_origen;

     -- commit; --2.0

  exception
      when others then
        RAISE_APPLICATION_ERROR (-20900, sqlcode || 'No se pudo clonar los materiales del ef ' || to_char(a_codef_origen) || ' al ef ' || to_char(a_codef_destino));
  END;


/**********************************************************************
Copia las formulas de un ef origen a un ef destino
**********************************************************************/
  PROCEDURE p_clonar_formulas(a_codef_origen in number, a_codef_destino in number)
  IS
  BEGIN
      insert into efptoetafor(codef, punto, codeta, codfor, cantidad/*,
                              flgmo, flgmat, flgtipequ, flgejecutar*/)
      select a_codef_destino, punto, codeta, codfor, cantidad/*,
             flgmo, flgmat, flgtipequ, flgejecutar*/
      from efptoetafor where codef = a_codef_origen;

     -- commit; --2.0

  exception
       when others then
         RAISE_APPLICATION_ERROR (-20900, sqlcode || 'No se pudo clonar las formulas del ef ' || to_char(a_codef_origen) || ' al ef ' || to_char(a_codef_destino));
  END;


/**********************************************************************
Copia los datos de un ef origen a un ef destino
**********************************************************************/
  PROCEDURE p_clonar_datos(a_codef_origen in number, a_codef_destino in number)
  IS
  BEGIN
    insert into efptoetadat(codef, punto, codeta, tipdatef, dato)
    select a_codef_destino, punto, codeta, tipdatef, dato
    from efptoetadat where codef = a_codef_origen;

    -- commit; --2.0

  exception
      when others then
         RAISE_APPLICATION_ERROR (-20900, sqlcode || 'No se pudo clonar los datos del ef ' || to_char(a_codef_origen) || ' al ef ' || to_char(a_codef_destino));
  END;


/**********************************************************************
Copia los informes de un ef origen a un ef destino
**********************************************************************/
  PROCEDURE p_clonar_informes(a_codef_origen in number, a_codef_destino in number)
  IS
  BEGIN
       insert into efptoetainf(codef, punto, codeta, orden,
                               tipinfef,fecini, fecfin, observacion)
       select a_codef_destino, punto, codeta, orden,
              tipinfef,fecini, fecfin, observacion
       from efptoetainf where codef = a_codef_origen;

    -- commit; --2.0

  exception
      when others then
         RAISE_APPLICATION_ERROR (-20900, sqlcode || 'No se pudo clonar los informes del ef ' || to_char(a_codef_origen) || ' al ef ' || to_char(a_codef_destino));
  END;


/**********************************************************************
Copia los metrados de un ef origen a un ef destino
**********************************************************************/
  PROCEDURE p_clonar_metrados(a_codef_origen in number, a_codef_destino in number)
  IS
  BEGIN
       insert into efptomet(codef, punto, orden, tipmetef, codubi, cantidad, observacion)
       select a_codef_destino, punto, orden, tipmetef, codubi, cantidad, observacion
       from efptomet where codef = a_codef_origen;

    -- commit; --2.0

  exception
       when others then
         RAISE_APPLICATION_ERROR (-20900, sqlcode || 'No se pudo clonar los metrados del ef ' || to_char(a_codef_origen) || ' al ef ' || to_char(a_codef_destino));
  END;


/**********************************************************************
Valida si un EF puede ser clonado
**********************************************************************/

  FUNCTION f_valida_clonar_ef(a_codef_origen in number, a_codef_destino in number) return number
  IS
  l_valida number;
  l_cont number;

  cursor cur_ef_destino is
  select vtadetptoenl.numpto, vtadetptoenl.codsrv from vtadetptoenl, ef
  where  vtadetptoenl.numslc = ef.numslc and ef.codef = a_codef_destino
  order  by vtadetptoenl.numpto;

  BEGIN
       l_valida := 1;
       for cef in cur_ef_destino loop
          select count(*) into l_cont from vtadetptoenl, ef
       where  vtadetptoenl.numslc = ef.numslc  and ef.codef = a_codef_origen
       and     vtadetptoenl.numpto = cef.numpto and vtadetptoenl.codsrv = cef.codsrv;

       if l_cont = 0 then
           l_valida := 0;
       end if;
     end loop;

       return l_valida;
  END;


/**********************************************************************
Copia un punto de un ef origen a un punto de un ef destino
**********************************************************************/
  PROCEDURE p_clonar_punto(a_codef_origen in number, a_codef_destino in number, a_punto_origen in number, a_punto_destino in number)
  IS
  l_pop efpto.pop%type;
  l_numdiapla efpto.numdiapla%type;
  l_tiptra efpto.tiptra%type;
  l_codtipfibra efpto.codtipfibra%type;
  l_lonfibra efpto.lonfibra%type;
  l_tiptraef efpto.tiptraef%type;
  l_tiprechazo_ope efpto.tiprechazo_ope%type;
  l_tiprechazo_fnz efpto.tiprechazo_fnz%type;
  l_codcon efpto.codcon%type;
  l_fecconasig efpto.fecconasig%type;
  l_fecconfin efpto.fecconfin%type;
  l_login efpto.login%type;
  l_dominio efpto.dominio%type;
  BEGIN
       delete from efptoequcmp where  codef = a_codef_destino  and  punto = a_punto_destino;
     commit;
     delete from efptoequ where  codef = a_codef_destino  and  punto = a_punto_destino;
     delete from efptomet where  codef = a_codef_destino  and  punto = a_punto_destino;
     commit;

     delete from efptoetainf where  codef = a_codef_destino  and  punto = a_punto_destino;
     delete from efptoetadat where  codef = a_codef_destino  and  punto = a_punto_destino;
     delete from efptoetafor where  codef = a_codef_destino  and  punto = a_punto_destino;
     delete from efptoetamat where  codef = a_codef_destino  and  punto = a_punto_destino;
     delete from efptoetaact where  codef = a_codef_destino  and  punto = a_punto_destino;
     commit;

     delete from efptoeta where  codef = a_codef_destino  and  punto = a_punto_destino;
     commit;

     select pop, numdiapla, tiptra, codcon, codtipfibra, lonfibra, tiptraef,
            tiprechazo_ope, tiprechazo_fnz, fecconasig, fecconfin, login, dominio
     into   l_pop, l_numdiapla, l_tiptra, l_codcon, l_codtipfibra, l_lonfibra, l_tiptraef,
            l_tiprechazo_ope, l_tiprechazo_fnz, l_fecconasig, l_fecconfin, l_login, l_dominio
     from    efpto
        where  codef = a_codef_origen  and  punto = a_punto_origen;

     update efpto
     set    pop = l_pop, numdiapla = l_numdiapla, tiptra = l_tiptra, codcon = l_codcon,
        codtipfibra = l_codtipfibra, lonfibra = l_lonfibra, tiptraef = l_tiptraef,
        tiprechazo_ope = l_tiprechazo_ope, tiprechazo_fnz = l_tiprechazo_fnz,
        fecconasig = l_fecconasig, fecconfin = l_fecconfin, login = l_login, dominio = l_dominio
     where  codef = a_codef_destino  and  punto = a_punto_destino;

     commit;

     p_clonar_etapas_x_punto(a_codef_origen, a_codef_destino, a_punto_origen, a_punto_destino);

     p_clonar_actividades_x_punto(a_codef_origen, a_codef_destino, a_punto_origen, a_punto_destino);

     p_clonar_materiales_x_punto(a_codef_origen, a_codef_destino, a_punto_origen, a_punto_destino);

     p_clonar_formulas_x_punto(a_codef_origen, a_codef_destino, a_punto_origen, a_punto_destino);

     p_clonar_datos_x_punto(a_codef_origen, a_codef_destino, a_punto_origen, a_punto_destino);

     p_clonar_informes_x_punto(a_codef_origen, a_codef_destino, a_punto_origen, a_punto_destino);

     p_clonar_metrados_x_punto(a_codef_origen, a_codef_destino, a_punto_origen, a_punto_destino);

        p_clonar_equipos_x_punto(a_codef_origen, a_codef_destino, a_punto_origen, a_punto_destino);

        p_clonar_componentes_x_punto(a_codef_origen, a_codef_destino, a_punto_origen, a_punto_destino);

     p_act_costo_ef(a_codef_destino);

     commit;

      exception
           when others then
            RAISE_APPLICATION_ERROR (-20900, sqlcode || 'No se pudo clonar el punto del ef ' || to_char(a_codef_origen) || ' al ef ' || to_char(a_codef_destino));
  END;

  procedure p_clonar_punto_fil_eta(a_codef_origen in number,
                                   a_codef_destino in number,
                                   a_punto_origen in number,
                                   a_punto_destino in number)
  is
    ln_count number;
  begin
    -- selecciona las etapas
    for rrow in (select codeta
                 from efptoeta
                 where codeta in(select codeta
                                 from etapaxarea
                                 where area in(select area
                                               from usuarioope
                                               where usuario = user))
                 and codef = a_codef_origen
                 and punto = a_punto_origen)
    loop
      delete from efptoetainf where  codef = a_codef_destino  and  punto = a_punto_destino and codeta = rrow.codeta;
      delete from efptoetadat where  codef = a_codef_destino  and  punto = a_punto_destino and codeta = rrow.codeta;
      delete from efptoetafor where  codef = a_codef_destino  and  punto = a_punto_destino and codeta = rrow.codeta;
      delete from efptoetamat where  codef = a_codef_destino  and  punto = a_punto_destino and codeta = rrow.codeta;
      delete from efptoetaact where  codef = a_codef_destino  and  punto = a_punto_destino and codeta = rrow.codeta;
      delete from efptoeta where  codef = a_codef_destino  and  punto = a_punto_destino and codeta = rrow.codeta;

      --etapas por punto
      begin
        insert into efptoeta(codef,punto,codeta,fecini,fecfin,
                             cosmo,cosmocli,cosmat,cosmatcli,cosmo_s,
                             cosmat_s,pccodtarea)
        select a_codef_destino,a_punto_destino,codeta,fecini,fecfin,
               cosmo,cosmocli,cosmat,cosmatcli,cosmo_s,
               cosmat_s, pccodtarea
        from  efptoeta
        where  codef = a_codef_origen
        and  punto = a_punto_origen
        and codeta = rrow.codeta;

      exception when others then
        raise_application_error (-20900, sqlcode || 'No se pudo clonar las etapas del ef ' || to_char(a_codef_origen) || ' al ef ' || to_char(a_codef_destino));
      end;

      -- actividades por punto
      begin
        insert into efptoetaact(codef,punto,codeta,codact,costo,
                                cantidad,observacion,moneda,moneda_id,codprec)
        select a_codef_destino,a_punto_destino,codeta,codact,costo,
               cantidad,observacion,moneda,moneda_id,codprec
        from    efptoetaact
        where  codef = a_codef_origen
        and  punto = a_punto_origen
        and codeta = rrow.codeta;

       exception when others then
        raise_application_error(-20900, sqlcode || 'No se pudo clonar las actividades del ef ' || to_char(a_codef_origen) || ' al ef ' || to_char(a_codef_destino));
      end;

      -- materiales por punto
      begin
        insert into efptoetamat(codef,punto,codeta,codmat,costo,
                                cantidad)
        select a_codef_destino,a_punto_destino,codeta,codmat,costo,
               cantidad
        from    efptoetamat
        where  codef = a_codef_origen
        and  punto = a_punto_origen
        and codeta = rrow.codeta;

       exception when others then
        raise_application_error(-20900, sqlcode || 'No se pudo clonar los materiales del ef ' || to_char(a_codef_origen) || ' al ef ' || to_char(a_codef_destino));
      end;

      -- formulas por punto
      begin
        insert into efptoetafor(codef,punto,codeta,codfor,cantidad)
        select a_codef_destino,a_punto_destino,codeta,codfor,cantidad
        from    efptoetafor
        where  codef = a_codef_origen
        and  punto = a_punto_origen
        and codeta = rrow.codeta;

       exception when others then
        raise_application_error(-20900, sqlcode || 'No se pudo clonar las formulas del ef ' || to_char(a_codef_origen) || ' al ef ' || to_char(a_codef_destino));
      end;


      -- datos por punto
      begin
        insert into efptoetadat(codef,punto,codeta,tipdatef,dato)
        select a_codef_destino,a_punto_destino,codeta,tipdatef,dato
        from    efptoetadat
        where  codef = a_codef_origen
        and  punto = a_punto_origen
        and codeta = rrow.codeta;

       exception when others then
        raise_application_error(-20900, sqlcode || 'No se pudo clonar los datos del ef ' || to_char(a_codef_origen) || ' al ef ' || to_char(a_codef_destino));
      end;

      --informes por punto
      begin
        insert into efptoetainf(codef,punto,codeta,orden,tipinfef,
                                fecini,fecfin,observacion)
        select a_codef_destino,a_punto_destino,codeta,orden,tipinfef,
               fecini,fecfin,observacion
        from  efptoetainf
        where codef = a_codef_origen
        and  punto = a_punto_origen
        and codeta = rrow.codeta;

       exception when others then
        raise_application_error(-20900, sqlcode || 'No se pudo clonar los informes del ef ' || to_char(a_codef_origen) || ' al ef ' || to_char(a_codef_destino));
      end;
  /*
      -- metrados por punto
      begin
        select count(*)
        into ln_count
        from efptomet
        where codef = a_codef_origen
        and  punto = a_punto_origen;

        if ln_count = 0 then
          insert into efptomet(codef,punto,orden,tipmetef,codubi,
                               cantidad,observacion)
          select a_codef_destino,a_punto_destino,orden,tipmetef,codubi,
                 cantidad,observacion
          from   efptomet
          where  codef = a_codef_origen
          and  punto = a_punto_origen;
        end if;

      exception when others then
        raise_application_error(-20900, sqlcode || 'No se pudo clonar los metrados del ef ' || to_char(a_codef_origen) || ' al ef ' || to_char(a_codef_destino));
      end;

      -- equipos por punto
      begin
        select count(*)
        into ln_count
        from efptoequ
        where codef = a_codef_origen
        and  punto = a_punto_origen;

        if ln_count = 0 then
          insert into efptoequ(codef,punto,orden,codtipequ,tipprp,
                               costear,cantidad,observacion,costo,codequcom,
                                tipequ)
          select a_codef_destino,a_punto_destino,orden,codtipequ,tipprp,
                 costear,cantidad,observacion,costo,codequcom,
                 tipequ
          from  efptoequ
          where  codef = a_codef_origen
          and  punto = a_punto_origen;
        end if;

      exception when others then
        raise_application_error(-20900, sqlcode || 'No se pudo clonar los equipos del ef ' || to_char(a_codef_origen) || ' al ef ' || to_char(a_codef_destino));
      end;

       -- componentes por punto
      begin
        select count(*)
        into ln_count
        from efptoequcmp
        where codef = a_codef_origen
        and  punto = a_punto_origen;

        if ln_count = 0 then
          insert into efptoequcmp(codef,punto,orden,codtipequ,ordencmp,
                                  costear,cantidad,observacion,costo,tipequ)
          select a_codef_destino,a_punto_destino,orden,codtipequ,ordencmp,
                 costear,cantidad,observacion,costo,tipequ
          from  efptoequcmp
          where  codef = a_codef_origen
          and  punto = a_punto_origen;
        end if;

      exception when others then
        raise_application_error(-20900, sqlcode || 'No se pudo clonar los equipos del ef ' || to_char(a_codef_origen) || ' al ef ' || to_char(a_codef_destino));
      end;
    */
      p_act_costo_ef(a_codef_destino);
    end loop;
   exception when others then
    raise_application_error(-20900, sqlcode || 'No se pudo clonar el punto del ef ' || to_char(a_codef_origen) || ' al ef ' || to_char(a_codef_destino));
  end;

  procedure p_clonar_something_x_punto(an_tipo number, a_codef_origen in number, a_codef_destino in number, a_punto_origen in number, a_punto_destino in number) is
  /*
    an_tipo = 1 metrado
              2 equipo
  */
  contador3 number;
  begin
    if an_tipo = 1 then
      -- metrados por punto
      begin
        delete from efptomet
        where  codef = a_codef_destino
        and  punto = a_punto_destino;

        insert into efptomet(codef,punto,orden,tipmetef,codubi,
                             cantidad,observacion)
        select a_codef_destino,a_punto_destino,orden,tipmetef,codubi,
               cantidad,observacion
        from   efptomet
        where  codef = a_codef_origen
        and  punto = a_punto_origen;

         p_act_costo_ef(a_codef_destino);
      exception when others then
        raise_application_error(-20900, sqlcode || 'No se pudo clonar los metrados del ef ' || to_char(a_codef_origen) || ' al ef ' || to_char(a_codef_destino));
      end;
    elsif an_tipo = 2 then
      begin
        delete from efptoequcmp where  codef = a_codef_destino  and  punto = a_punto_destino;
        delete from efptoequ where  codef = a_codef_destino  and  punto = a_punto_destino;
        --20070221 Se agrego codeta
        --Validamos que exista data para clonar
        select count(*) into contador3
        from  efptoequ
        where  codef = a_codef_origen
        and  punto = a_punto_origen;

        if contador3 > 0 then
        insert into efptoequ(codef,punto,orden,codtipequ,tipprp,
                                 costear,cantidad,observacion,costo,codequcom,
                                  tipequ, codeta)
        select a_codef_destino,a_punto_destino,orden,codtipequ,tipprp,
               costear,cantidad,observacion,costo,codequcom,
               tipequ, codeta
        from  efptoequ
        where  codef = a_codef_origen
        and  punto = a_punto_origen;
        end if;
        --20070221 Se agrego codeta
        select count(*) into contador3
        from  efptoequcmp
        where  codef = a_codef_origen
        and  punto = a_punto_origen;
        if contador3 > 0 then
        insert into efptoequcmp(codef,punto,orden,codtipequ,ordencmp,
                                    costear,cantidad,observacion,costo,tipequ,codeta)
        select a_codef_destino,a_punto_destino,orden,codtipequ,ordencmp,
               costear,cantidad,observacion,costo,tipequ,codeta
        from  efptoequcmp
        where  codef = a_codef_origen
        and  punto = a_punto_origen;
        end if;
        p_act_costo_ef(a_codef_destino);
      exception when others then
        raise_application_error(-20900, sqlcode || 'No se pudo clonar los equipos del ef ' || to_char(a_codef_origen) || ' al ef ' || to_char(a_codef_destino));
      end;
    end if;
  end;

/**********************************************************************
Copia las etapas de un punto de un ef origen a un punto de un ef destino
**********************************************************************/
  PROCEDURE p_clonar_etapas_x_punto(a_codef_origen in number, a_codef_destino in number, a_punto_origen in number, a_punto_destino in number)
  IS
  BEGIN
       insert into efptoeta(codef, punto, codeta, fecini, fecfin, cosmo,
           cosmocli, cosmat, cosmatcli, cosmo_s, cosmat_s, pccodtarea)
     select a_codef_destino, a_punto_destino, codeta, fecini, fecfin, cosmo,
           cosmocli, cosmat, cosmatcli, cosmo_s, cosmat_s, pccodtarea
       from    efptoeta where  codef = a_codef_origen  and  punto = a_punto_origen;

     commit;

      exception
           when others then
            RAISE_APPLICATION_ERROR (-20900, sqlcode || 'No se pudo clonar las etapas del ef ' || to_char(a_codef_origen) || ' al ef ' || to_char(a_codef_destino));
  END;


/**********************************************************************
Copia las actividades de un punto de un ef origen a un punto de un ef destino
**********************************************************************/
  PROCEDURE p_clonar_actividades_x_punto(a_codef_origen in number, a_codef_destino in number, a_punto_origen in number, a_punto_destino in number)
  IS
  BEGIN
       insert into efptoetaact(codef, punto, codeta, codact, costo, cantidad,
           observacion, moneda, moneda_id, codprec)
     select a_codef_destino, a_punto_destino, codeta, codact, costo, cantidad,
           observacion, moneda, moneda_id, codprec
       from    efptoetaact where  codef = a_codef_origen  and  punto = a_punto_origen;

     commit;

      exception
           when others then
            RAISE_APPLICATION_ERROR (-20900, sqlcode || 'No se pudo clonar las actividades del ef ' || to_char(a_codef_origen) || ' al ef ' || to_char(a_codef_destino));
  END;


/**********************************************************************
Copia los materiales de un punto de un ef origen a un punto de un ef destino
**********************************************************************/
  PROCEDURE p_clonar_materiales_x_punto(a_codef_origen in number, a_codef_destino in number, a_punto_origen in number, a_punto_destino in number)
  IS
  BEGIN
       insert into efptoetamat(codef, punto, codeta, codmat, costo, cantidad)
     select a_codef_destino, a_punto_destino, codeta, codmat, costo, cantidad
       from    efptoetamat where  codef = a_codef_origen  and  punto = a_punto_origen;

     commit;

      exception
           when others then
            RAISE_APPLICATION_ERROR (-20900, sqlcode || 'No se pudo clonar los materiales del ef ' || to_char(a_codef_origen) || ' al ef ' || to_char(a_codef_destino));
  END;


/**********************************************************************
Copia las formulas de un punto de un ef origen a un punto de un ef destino
**********************************************************************/
  PROCEDURE p_clonar_formulas_x_punto(a_codef_origen in number, a_codef_destino in number, a_punto_origen in number, a_punto_destino in number)
  IS
  BEGIN
       insert into efptoetafor(codef, punto, codeta, codfor, cantidad/*,
           flgmo, flgmat, flgtipequ, flgejecutar*/)
     select a_codef_destino, a_punto_destino, codeta, codfor, cantidad/*,
           flgmo, flgmat, flgtipequ, flgejecutar*/
       from    efptoetafor where  codef = a_codef_origen  and  punto = a_punto_origen;

     commit;

      exception
           when others then
            RAISE_APPLICATION_ERROR (-20900, sqlcode || 'No se pudo clonar las formulas del ef ' || to_char(a_codef_origen) || ' al ef ' || to_char(a_codef_destino));
  END;


/**********************************************************************
Copia los datos de un punto de un ef origen a un punto de un ef destino
**********************************************************************/
  PROCEDURE p_clonar_datos_x_punto(a_codef_origen in number, a_codef_destino in number, a_punto_origen in number, a_punto_destino in number)
  IS
  BEGIN
       insert into efptoetadat(codef, punto, codeta, tipdatef, dato)
     select a_codef_destino, a_punto_destino, codeta, tipdatef, dato
       from    efptoetadat where  codef = a_codef_origen  and  punto = a_punto_origen;

     commit;

      exception
           when others then
            RAISE_APPLICATION_ERROR (-20900, sqlcode || 'No se pudo clonar los datos del ef ' || to_char(a_codef_origen) || ' al ef ' || to_char(a_codef_destino));
  END;


/**********************************************************************
Copia los informes de un punto de un ef origen a un punto de un ef destino
**********************************************************************/
  PROCEDURE p_clonar_informes_x_punto(a_codef_origen in number, a_codef_destino in number, a_punto_origen in number, a_punto_destino in number)
  IS
  BEGIN
       insert into efptoetainf(codef, punto, codeta, orden,
           tipinfef,fecini, fecfin, observacion)
     select a_codef_destino, a_punto_destino, codeta, orden,
           tipinfef,fecini, fecfin, observacion
       from    efptoetainf where  codef = a_codef_origen  and  punto = a_punto_origen;

     commit;

      exception
           when others then
            RAISE_APPLICATION_ERROR (-20900, sqlcode || 'No se pudo clonar los informes del ef ' || to_char(a_codef_origen) || ' al ef ' || to_char(a_codef_destino));
  END;


/**********************************************************************
Copia los metrados de un punto de un ef origen a un punto de un ef destino
**********************************************************************/
  PROCEDURE p_clonar_metrados_x_punto(a_codef_origen in number, a_codef_destino in number, a_punto_origen in number, a_punto_destino in number)
  IS
  BEGIN
       insert into efptomet(codef, punto, orden, tipmetef, codubi, cantidad, observacion)
     select a_codef_destino, a_punto_destino, orden, tipmetef, codubi, cantidad, observacion
       from    efptomet where  codef = a_codef_origen  and  punto = a_punto_origen;

     commit;

      exception
           when others then
            RAISE_APPLICATION_ERROR (-20900, sqlcode || 'No se pudo clonar los metrados del ef ' || to_char(a_codef_origen) || ' al ef ' || to_char(a_codef_destino));
  END;


/**********************************************************************
Copia los equipos de un punto de un ef origen a un punto de un ef destino
**********************************************************************/
  PROCEDURE p_clonar_equipos_x_punto(a_codef_origen in number, a_codef_destino in number, a_punto_origen in number, a_punto_destino in number)
  IS
  BEGIN --20070221 Se agrego codeta
       insert into efptoequ(codef, punto, orden, codtipequ, tipprp, costear, cantidad, observacion, costo, codequcom, tipequ, codeta)
     select a_codef_destino, a_punto_destino, orden, codtipequ, tipprp, costear, cantidad, observacion, costo, codequcom, tipequ, codeta
       from    efptoequ where  codef = a_codef_origen  and  punto = a_punto_origen;

     commit;

      exception
           when others then
            RAISE_APPLICATION_ERROR (-20900, sqlcode || 'No se pudo clonar los equipos del ef ' || to_char(a_codef_origen) || ' al ef ' || to_char(a_codef_destino));
  END;


/**********************************************************************
Copia los equipos de un punto de un ef origen a un punto de un ef destino
**********************************************************************/
  PROCEDURE p_clonar_componentes_x_punto(a_codef_origen in number, a_codef_destino in number, a_punto_origen in number, a_punto_destino in number)
  IS
  BEGIN --20070221 Se agrego codeta
       insert into efptoequcmp(codef, punto, orden, codtipequ, ordencmp, costear, cantidad, observacion, costo, tipequ, codeta)
     select a_codef_destino, a_punto_destino, orden, codtipequ, ordencmp, costear, cantidad, observacion, costo, tipequ, codeta
       from    efptoequcmp where  codef = a_codef_origen  and  punto = a_punto_origen;

     commit;

      exception
           when others then
            RAISE_APPLICATION_ERROR (-20900, sqlcode || 'No se pudo clonar los equipos del ef ' || to_char(a_codef_origen) || ' al ef ' || to_char(a_codef_destino));
  END;

procedure p_clonar_punto_fil_eta2(a_codef_origen in number,
                                   a_codef_destino in number,
                                   a_punto_origen in number,
                                   a_punto_destino in number)
  is
    ln_count number;
  begin
    -- selecciona las etapas
    for rrow in (select codeta
                 from efptoeta
                 where codef = a_codef_origen
                 and punto = a_punto_origen)
    loop
      delete from efptoetainf where  codef = a_codef_destino  and  punto = a_punto_destino and codeta = rrow.codeta;
      delete from efptoetadat where  codef = a_codef_destino  and  punto = a_punto_destino and codeta = rrow.codeta;
      delete from efptoetafor where  codef = a_codef_destino  and  punto = a_punto_destino and codeta = rrow.codeta;
      delete from efptoetamat where  codef = a_codef_destino  and  punto = a_punto_destino and codeta = rrow.codeta;
      delete from efptoetaact where  codef = a_codef_destino  and  punto = a_punto_destino and codeta = rrow.codeta;
      delete from efptoeta where  codef = a_codef_destino  and  punto = a_punto_destino and codeta = rrow.codeta;

      --etapas por punto
      begin
        insert into efptoeta(codef,punto,codeta,fecini,fecfin,
                             cosmo,cosmocli,cosmat,cosmatcli,cosmo_s,
                             cosmat_s,pccodtarea)
        select a_codef_destino,a_punto_destino,codeta,fecini,fecfin,
               cosmo,cosmocli,cosmat,cosmatcli,cosmo_s,
               cosmat_s, pccodtarea
        from  efptoeta
        where  codef = a_codef_origen
        and  punto = a_punto_origen
        and codeta = rrow.codeta;

      exception when others then
        raise_application_error (-20900, sqlcode || 'No se pudo clonar las etapas del ef ' || to_char(a_codef_origen) || ' al ef ' || to_char(a_codef_destino));
      end;

      -- actividades por punto
      begin
        insert into efptoetaact(codef,punto,codeta,codact,costo,
                                cantidad,observacion,moneda,moneda_id,codprec)
        select a_codef_destino,a_punto_destino,codeta,codact,costo,
               cantidad,observacion,moneda,moneda_id,codprec
        from    efptoetaact
        where  codef = a_codef_origen
        and  punto = a_punto_origen
        and codeta = rrow.codeta;

       exception when others then
        raise_application_error(-20900, sqlcode || 'No se pudo clonar las actividades del ef ' || to_char(a_codef_origen) || ' al ef ' || to_char(a_codef_destino));
      end;

      -- materiales por punto
      begin
        insert into efptoetamat(codef,punto,codeta,codmat,costo,
                                cantidad)
        select a_codef_destino,a_punto_destino,codeta,codmat,costo,
               cantidad
        from    efptoetamat
        where  codef = a_codef_origen
        and  punto = a_punto_origen
        and codeta = rrow.codeta;

       exception when others then
        raise_application_error(-20900, sqlcode || 'No se pudo clonar los materiales del ef ' || to_char(a_codef_origen) || ' al ef ' || to_char(a_codef_destino));
      end;

      -- formulas por punto
      begin
        insert into efptoetafor(codef,punto,codeta,codfor,cantidad)
        select a_codef_destino,a_punto_destino,codeta,codfor,cantidad
        from    efptoetafor
        where  codef = a_codef_origen
        and  punto = a_punto_origen
        and codeta = rrow.codeta;

       exception when others then
        raise_application_error(-20900, sqlcode || 'No se pudo clonar las formulas del ef ' || to_char(a_codef_origen) || ' al ef ' || to_char(a_codef_destino));
      end;


      -- datos por punto
      begin
        insert into efptoetadat(codef,punto,codeta,tipdatef,dato)
        select a_codef_destino,a_punto_destino,codeta,tipdatef,dato
        from    efptoetadat
        where  codef = a_codef_origen
        and  punto = a_punto_origen
        and codeta = rrow.codeta;

       exception when others then
        raise_application_error(-20900, sqlcode || 'No se pudo clonar los datos del ef ' || to_char(a_codef_origen) || ' al ef ' || to_char(a_codef_destino));
      end;

      --informes por punto
      begin
        insert into efptoetainf(codef,punto,codeta,orden,tipinfef,
                                fecini,fecfin,observacion)
        select a_codef_destino,a_punto_destino,codeta,orden,tipinfef,
               fecini,fecfin,observacion
        from  efptoetainf
        where codef = a_codef_origen
        and  punto = a_punto_origen
        and codeta = rrow.codeta;

       exception when others then
        raise_application_error(-20900, sqlcode || 'No se pudo clonar los informes del ef ' || to_char(a_codef_origen) || ' al ef ' || to_char(a_codef_destino));
      end;
      p_act_costo_ef(a_codef_destino);
    end loop;
   exception when others then
    raise_application_error(-20900, sqlcode || 'No se pudo clonar el punto del ef ' || to_char(a_codef_origen) || ' al ef ' || to_char(a_codef_destino));
  end;
/**********************************************************************
Valida si un punto de un EF puede ser clonado
**********************************************************************/

  FUNCTION f_valida_clonar_efpto(a_codef_origen in number, a_codef_destino in number, a_punto_origen in number, a_punto_destino in number) return number
  IS
  l_valida number;
  l_cont number;

  cursor cur_ef_destino is
  select vtadetptoenl.descpto, vtadetptoenl.codsrv from vtadetptoenl, ef
  where  vtadetptoenl.numslc = ef.numslc and ef.codef = a_codef_destino
  and   vtadetptoenl.numpto = a_punto_destino order  by vtadetptoenl.numpto;

  BEGIN
       l_valida := 1;
       for cef in cur_ef_destino loop
          select count(*) into l_cont from vtadetptoenl, ef
       where  vtadetptoenl.numslc = ef.numslc
       and     ef.codef = a_codef_origen
       and     vtadetptoenl.numpto = a_punto_origen
       and     vtadetptoenl.descpto = cef.descpto
       and     vtadetptoenl.codsrv = cef.codsrv;

       if l_cont = 0 then
           l_valida := 0;
       end if;
     end loop;

       return l_valida;
  END;

  --<ini 2.0>
  PROCEDURE p_clonar_solxarea_ef_rnv(a_codef_origen in number, a_codef_destino in number)
  IS
  BEGIN

     delete from operacion.solefxarea sxa where sxa.codef=a_codef_destino;
     insert into solefxarea(codef, numslc, estsolef, esresponsable, fecini,fecfin,numdiapla,observacion,
                            fecusu,codusu,fecapr,numdiaval,area,tipproyecto)
     select a_codef_destino,sxa.numslc,sxa.estsolef,sxa.esresponsable,sxa.fecini,sxa.fecfin,sxa.numdiapla,sxa.observacion,
            sxa.fecusu,sxa.codusu,sxa.fecapr,sxa.numdiaval,sxa.area,sxa.tipproyecto
       from operacion.solefxarea sxa
      where sxa.codef = a_codef_origen;

  exception
         when others then
            RAISE_APPLICATION_ERROR (-20900, sqlcode || 'No se pudo clonar el Estudio de Factibilidad asociado al área, del ef  ' || to_char(a_codef_origen) || ' al ef ' || to_char(a_codef_destino));
  END;

  procedure p_act_ef_rnv(a_codef_origen in number,a_codef_destino in number)
  is
  begin

    update efptoeta set
    cosmat = 0,
    cosmo = 0,
    cosmat_s = 0,
    cosmo_s = 0
    where codef = a_codef_destino;

    update efptoeta set
    cosmat = (select efptoeta.cosmat + nvl(sum(a.costo * a.cantidad),0)
        FROM efptoetamat a
       WHERE a.codef = efptoeta.codef AND
             a.punto = efptoeta.punto AND
             a.codeta = efptoeta.codeta  ),
    cosmo =  (select efptoeta.cosmo + nvl(sum(a.costo * a.cantidad),0)
        FROM efptoetaact a
       WHERE a.codef = efptoeta.codef AND
             a.punto = efptoeta.punto AND
             a.codeta = efptoeta.codeta  and
             a.moneda_id = 2 ),
    cosmo_s =  (select efptoeta.cosmo + nvl(sum(a.costo * a.cantidad),0)
        FROM efptoetaact a
       WHERE a.codef = efptoeta.codef AND
             a.punto = efptoeta.punto AND
             a.codeta = efptoeta.codeta and
             a.moneda_id = 1 )
    where codef = a_codef_destino;

    update efpto set
    cosmat = (select nvl(sum(a.cosmat),0)
        from efptoeta a
       where   a.codef = efpto.codef  and
              a.punto = efpto.punto),
    cosmo = (select nvl(sum(a.cosmo),0)
        from efptoeta a
       where a.codef = efpto.codef  and
             a.punto = efpto.punto),
    cosmat_s = (select nvl(sum(a.cosmat_S),0)
        from efptoeta a
       where  a.codef = efpto.codef  and
             a.punto = efpto.punto),
    cosmo_s = (select nvl(sum(a.cosmo_S),0)
        from efptoeta a
       where a.codef = efpto.codef  and
             a.punto = efpto.punto),
    cosequ = (select nvl(sum(b.costo * b.cantidad * a.cantidad),0)
        from efptoequ a, efptoequcmp b
       where a.codef = efpto.codef  and
             a.punto = efpto.punto and
         b.costear = 1 and
         a.codef = b.codef  and
             a.punto = b.punto and
         a.orden = b.orden )
    where codef = a_codef_destino;

    update efpto set
    cosequ = (select nvl(sum(a.costo * a.cantidad),0) + cosequ
        from efptoequ a
       where a.codef = efpto.codef  and
             a.punto = efpto.punto and
         a.costear = 1 )
    where codef = a_codef_destino;

    update ef set
    cosmat = (select nvl(sum(a.cosmat),0)
        from efpto a
       where  a.codef = ef.codef ),
    cosmo = (select nvl(sum(a.cosmo),0)
        from efpto a
       where a.codef = ef.codef  ),
    cosmat_s = (select nvl(sum(a.cosmat_s),0)
        from efpto a
       where a.codef = ef.codef  ),
    cosmo_s = (select nvl(sum(a.cosmo_s),0)
        from efpto a
       where a.codef = ef.codef  ),
    cosequ = (select nvl(sum(a.cosequ),0)
        from efpto a
       where a.codef = ef.codef  ),
    estef = (select e.estef
        from ef e
       where e.codef=a_codef_origen),
    numdiapla = (select e.numdiapla
        from ef e
       where e.codef=a_codef_origen),
    fecfin = (select e.fecfin
        from operacion.ef e
       where e.codef=a_codef_origen),
    fecusu = (select e.fecusu
        from operacion.ef e
       where e.codef=a_codef_origen),
    observacion = (select e.observacion
        from operacion.ef e
       where e.codef=a_codef_origen),
    frr = (select e.frr
        from operacion.ef e
       where e.codef=a_codef_origen),
    req_ar = (select e.req_ar
        from operacion.ef e
       where e.codef=a_codef_origen)
    where codef = a_codef_destino;

    update sales.vtatabslcfac set
       fecapr = (select vts.fecapr
       from sales.vtatabslcfac vts
      where vts.numslc=(select e.numslc
       from operacion.ef e
      where e.codef=a_codef_origen))
    where numslc=(select numslc from operacion.ef e where e.codef=a_codef_destino);

    delete from operacion.estsolef_dias_utiles edu
          where edu.codef=a_codef_destino;

    insert into operacion.estsolef_dias_utiles edu
      (codef,codcli,codarea,estsolef,fechaini,fechafin,
       codusu,dias,flg_valido)
    select a_codef_destino,edu.codcli,edu.codarea,edu.estsolef,edu.fechaini,edu.fechafin,
           edu.codusu,edu.dias,edu.flg_valido
      from operacion.estsolef_dias_utiles edu
     where edu.codef = a_codef_origen
       and edu.flg_valido=1;

   exception
             when others then
              RAISE_APPLICATION_ERROR (-20900, sqlcode || 'No se pudo terminar p_act_ef_rnv, en codef_origen' ||
                                 to_char(a_codef_origen) || ' al ef ' || to_char(a_codef_destino));

  end;

  procedure p_registro_clonacion(a_codef_origen in number,a_codef_destino in number,
                                 a_codsolot_origen in number ,a_codsolot_destino in number)
  is
  begin

       insert into operacion.efclon
       values(operacion.sq_efclon.nextval,(trim(to_char(a_codef_origen,'0000000000'))),
         a_codef_origen,(trim(to_char(a_codef_destino,'0000000000'))),a_codef_destino,
         user,current_date );

   exception
             when others then
              RAISE_APPLICATION_ERROR (-20900, sqlcode ||'-'||sqlerrm || ' p_registro_clonacion, en codef_origen' ||
                                to_char(a_codef_origen) || ' al ef ' || to_char(a_codef_destino));
  end;

  --<fin 2.0>

END PQ_EF_CLONACION;
/