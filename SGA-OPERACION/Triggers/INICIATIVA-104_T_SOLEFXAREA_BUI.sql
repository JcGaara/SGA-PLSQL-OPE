CREATE OR REPLACE TRIGGER OPERACION.T_SOLEFXAREA_BUI
  BEFORE INSERT OR UPDATE ON operacion.solefxarea
  REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW
DECLARE
  ls_texto VARCHAR2(1000);
  CURSOR cur_correo IS
    SELECT a.email
      FROM envcorreo a
     WHERE a.area = :new.area
           AND a.tipo = 4;
  ln_num       NUMBER;
  ln_estef     NUMBER;
  lc_codcli    vtatabcli.codcli%TYPE;
  lc_tipsrv    vtatabslcfac.tipsrv%TYPE;
  ln_tipsolef  vtatabslcfac.tipsolef%TYPE;
  lc_cliint    vtatabslcfac.cliint%TYPE;
  ln_prioridad NUMBER(3);
  ln_idlog     NUMBER;
  ln_codcon    NUMBER;

  ls_destino     VARCHAR2(1000);
  l_cliente      vtatabcli.nomcli%TYPE;
  l_tiposervicio tystipsrv.dsctipsrv%TYPE;
  l_area         areaope.descripcion%TYPE;

  ls_codcli CHAR(8); --JMAP

  /******************************************************************************
  
  Date        Author           Description
  ----------  ---------------  ------------------------------------
  15/03/2005  Victor Valqui     Se controla un log cada vez que el EF de cada area se pase a generado.
  12/06/2005  Victor Valqui     Se elimina la opcion para que no se considere al momento de actualizar
                    por ventas.
  11/11/2006  Luis Olarte      Req 44386 Cambio de estado por contratista.
     1.0    06/10/2010                      REQ.139588 Cambio de Marca
  
  ******************************************************************************/

BEGIN
  IF updating THEN
    /********** temporal *********************************/
    IF updating('AREA') THEN
      IF :old.area IS NULL THEN
        RETURN;
      END IF;
      /*      --JMAP
      update operacion.estsolef_dias_utiles set codarea = :new.area
      where codef = :old.codef and codarea = :old.area;
      --JMAP  */
    
    END IF;
  
    IF updating('CODDPT') THEN
      SELECT area INTO :new.area FROM areaope WHERE coddpt = :new.coddpt;
    END IF;
    /********** Fin temporal *********************************/
  
    --Registrar un log de cada area cada vez que se pase a Generado.
    IF :new.estsolef = 1 AND :old.estsolef IN (2, 3) THEN
    
      SELECT nvl(MAX(id_log), 0) + 1 INTO ln_idlog FROM solefxarea_log;
    
      INSERT INTO solefxarea_log
        (id_log,
         codef,
         area,
         fecini,
         fecfin,
         numdiapla,
         observacion,
         fecapr,
         numdiaval)
      VALUES
        (ln_idlog,
         :old.codef,
         :old.area,
         :old.fecini,
         :old.fecfin,
         :old.numdiapla,
         :old.observacion,
         :old.fecapr,
         :old.numdiaval);
    END IF;
    --Fin de codigo.
  
    IF updating('ESTSOLEF') AND updating('FECAPR') AND updating('FECINI') AND
       nvl(:old.fecapr, SYSDATE) = nvl(:new.fecapr, SYSDATE) AND
       NOT updating('FECFIN') AND NOT updating('NUMDIAPLA') AND
       NOT updating('OBSERVACION') AND :new.estsolef = 1 THEN
      -- Se esta cambiando a Actualizar Datos, entonces se permite que se actualize
      RETURN;
    END IF;
  
    IF updating('ESTSOLEF') AND :new.estsolef = 1 THEN
      SELECT nvl(idprioridad, 0)
        INTO ln_prioridad
        FROM vtatabslcfac
       WHERE numslc = :new.numslc;
    
      ls_texto := 'Fue Actualizado por ' || USER || ' Fecha: ' ||
                  to_char(SYSDATE, 'dd/mm/yyyy hh24:mi:ss') || chr(13);
      ls_texto := ls_texto || 'Proyecto: ' || :new.numslc || chr(13) ||
                  'PRIORIDAD ' || ln_prioridad;
      FOR ls_correo IN cur_correo LOOP
        p_envia_correo_de_texto_att('PRIORIDAD ' || ln_prioridad ||
                                    ' Estudio de Factibilidad ' ||
                                    to_char(:new.codef),
                                    ls_correo.email,
                                    ls_texto);
      END LOOP;
    END IF;
  
    -- Cuando se tenga que actualizar el estudio
    IF updating('ESTSOLEF') AND NOT updating('FECINI') AND
       NOT updating('FECFIN') AND NOT updating('NUMDIAPLA') AND
       NOT updating('OBSERVACION') AND :new.estsolef = 1 THEN
      SELECT estef INTO ln_estef FROM ef WHERE numslc = :new.numslc;
      IF ln_estef IN (3, 5) THEN
        -- Se esta cambiando a Actualizar Datos, entonces se permite que se actualize
        RETURN;
      END IF;
    END IF;
  
    SELECT COUNT(*)
      INTO ln_num
      FROM accusudpt
     WHERE area = :new.area
           AND codusu = USER
           AND tipo = 3
           AND aprob = 1;
  
    --   if ln_num = 0 and :new.estsolef <> 6 then  -- Requerimiento 32804
    IF ln_num = 0 AND :new.estsolef <> 3 THEN
      -- Requerimiento 39320
      raise_application_error(-20500,
                              'No tiene privilegios para concluir el estudio');
    END IF;
  
    --***********************Req 44386
    SELECT MAX(codcon)
      INTO ln_codcon
      FROM usuarioope u
     WHERE u.usuario = TRIM(USER);
  
    IF (ln_codcon IS NOT NULL AND :new.estsolef <> 7) THEN
      ls_texto   := 'EF Concluido por Contrata: ' || to_char(:new.codef) ||
                    chr(13) || chr(10) || 'Proyecto: ' || :new.numslc ||
                    chr(13) || chr(10);
      ls_texto   := ls_texto || 'Cliente: ' || l_cliente || chr(13) ||
                    chr(10) || 'Tipo de Servicio: ' || l_tiposervicio ||
                    chr(13) || chr(10);
      ls_texto   := ls_texto ||
                    'Observación indicada por el Contratista de ' || l_area || ': ' ||
                    :new.observacion || chr(13) || chr(10);
      ls_destino := 'william.ojeda@claro.com.pe'; --1.0
    
      p_envia_correo_de_texto_att('EF Concluido por Contrata: ' ||
                                  to_char(:new.codef),
                                  ls_destino,
                                  ls_texto);
      opewf.pq_send_mail_job.p_send_mail('EF Concluido por Contrata: ' ||
                                         to_char(:new.codef),
                                         ls_destino,
                                         ls_texto,
                                         'SGA@Sistema_de_Operaciones');
    
      raise_application_error(-20500,
                              'El unico estado valido es Concluído por Contratista');
    END IF;
    --************************
  
    -- Se actualiza la fecha en que se aprueba el estudio
    IF updating('ESTSOLEF') THEN
      IF :new.estsolef IN (2, 4) THEN
        :new.fecapr := SYSDATE;
      ELSIF :new.estsolef = 3 THEN
        SELECT cli.nomcli
          INTO l_cliente
          FROM vtatabcli cli, vtatabslcfac slc
         WHERE cli.codcli = slc.codcli
               AND slc.numslc = :new.numslc;
        SELECT srv.dsctipsrv
          INTO l_tiposervicio
          FROM tystipsrv srv, vtatabslcfac slc
         WHERE srv.tipsrv = slc.tipsrv
               AND slc.numslc = :new.numslc;
        SELECT descripcion INTO l_area FROM areaope WHERE area = :new.area;
      
        ls_texto := 'EF rechazado: ' || to_char(:new.codef) || chr(13) ||
                    chr(10) || 'Proyecto: ' || :new.numslc || chr(13) ||
                    chr(10);
        ls_texto := ls_texto || 'Cliente: ' || l_cliente || chr(13) ||
                    chr(10) || 'Tipo de Servicio: ' || l_tiposervicio ||
                    chr(13) || chr(10);
        --  ls_texto:= ls_texto || 'Observación indicada por el Area de ' || l_area  || ': ' || :new.observacion || chr(13) || chr(10);
        ls_destino := 'illich.izarra@claro.com.pe,william.ojeda@claro.com.pe'; --1.0
      
        --P_ENVIA_CORREO_DE_TEXTO_ATT('EF rechazado: ' || to_char(:new.codef), ls_destino, ls_texto);
        -- opewf.pq_send_mail_job.p_send_mail ('EF rechazado: ' || to_char(:new.codef), ls_destino, ls_texto, 'SGA@Sistema_de_Operaciones');
      END IF;
    
    END IF;
  
  END IF;
  IF inserting THEN
    /***************** Temporal *********************/
    -- se actualiza temporalmente el campo area para las OT
  
    IF :new.area IS NULL THEN
      SELECT area INTO :new.area FROM areaope WHERE coddpt = :new.coddpt;
    END IF;
    /***************** fin Temporal *********************/
  
    SELECT COUNT(*)
      INTO ln_num
      FROM ef
     WHERE numslc = :new.numslc
           OR codef = :new.codef;
    IF ln_num = 0 THEN
      --ln_num := F_GET_CLAVE_EF;
      SELECT codcli, tipsrv, tipsolef, cliint
        INTO lc_codcli, lc_tipsrv, ln_tipsolef, lc_cliint
        FROM vtatabslcfac
       WHERE numslc = :new.numslc;
      IF lc_tipsrv IS NULL OR lc_tipsrv = '0000' THEN
        SELECT MAX(tipsrv)
          INTO lc_tipsrv
          FROM vtatabpspcli
         WHERE numslc = :new.numslc;
      END IF;
      INSERT INTO ef
        (codef, numslc, codcli, estef, tipsrv, tipsolef, cliint)
      VALUES
        (:new.codef,
         :new.numslc,
         lc_codcli,
         1,
         lc_tipsrv,
         ln_tipsolef,
         lc_cliint);
    
      --LLenado de Puntos Automatico al momento de generarse el EF
      p_act_ef_de_sol(:new.codef);
      
      OPERACION.PKG_FACTIBILIDAD.SGASI_TRAZA_FACT(:new.codef);
    
    END IF;
  
    /*  --JMAP
    if :new.area <> :old.area  or :old.area is null  then
        select codcli into ls_codcli from vtatabslcfac where numslc = :new.numslc;
        insert into operacion.estsolef_dias_utiles(codef,codcli,codarea,estsolef,fechaini)
        values(:new.codef,ls_codcli,:new.area,:new.estsolef,sysdate);
    
    end if;
    --JMAP*/
  END IF;

END;
/