CREATE OR REPLACE TRIGGER OPERACION.T_SOLOT_AU
AFTER UPDATE
ON OPERACION.SOLOT
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW

DECLARE
  ls_texto     VARCHAR2(4000);
  ls_estado    CHAR(2);
  ls_tipsrv    CHAR(4);
  ls_codcli    CHAR(8);
  ls_codect    CHAR(8);
  ls_dsctipsrv VARCHAR2(50);
  ls_nomcli    VARCHAR2(150);
  ls_nomect    sales.vtatabect.nomect%type;--7.0
  ls_nrodia    VARCHAR2(4);
  --ls_codsrv CHAR(4);
  --ls_dscsrv VARCHAR2(50);
  ls_valor  VARCHAR2(07);
  ls_valor2 VARCHAR2(30);
  ls_titpsp VARCHAR2(100);
  -- CAMBIO GUSTAVO ORMEÑO
  ls_nomabr varchar2(20);
  -- CAMBIO ROY CONCEPCIÓN
  --ll_count_sot NUMBER;
  v_bloqueodesbloqueo tiptrabajo.bloqueo_desbloqueo%type;
  ls_codigoc          varchar2(30);
  l_idtransori        number;
  l_count             number;
  --<Ini 3.0>
  ln_cantidad        number;
  lc_transaccion     atccorp.atc_parametro_sot.transaccion%type;
  ln_tiptra_asigna   number;
  ln_area_asigna     number;
  ln_codmotot_asigna number;
  ln_dias_vigencia   number;
  v_resultado        number;
  v_mensaje          varchar2(3000);
  --<Fin 3.0>
  --<5.0
  ln_id_lotecliente NUMBER;
  lr_atc_promocion  atccorp.atc_trx_promocion%ROWTYPE;
  ln_coderror       NUMBER;
  ls_descerror      VARCHAR2(3000);
  --5.0>

  /*****************************************************************************************************************
     NAME:       T_SOLOT_BU
  
     REVISIONS:
     Ver        Date        Author           Description
     ---------  ----------  ---------------  ------------------------------------
     1.0        02/08/2004  Victor Valqui     Se agrego el motivo de rechazo en el correo cuando es rechazado una SOLOT.
     1.0        12/08/2004  Victor Valqui     Correcion para jalar el ultimo motivo.
     2.0        30/06/2009  Hector Huaman M   REQ.96409  Se adiciona lógica para que las suspensiones, cortes y reconexiones manuales, cancelen las transacciones cuando se anula y rechaza por el usuario las SOTs generadas por el sistema
     3.0        14/08/2012  Juan Pablo Ramos  Proy. Claro Club: Solicitado por Elver Ramirez
     4.0        05/10/2012  Juan Pablo Ramos  REQ.163439 Soluciones Post Venta BAM-BAF
     5.0        23/01/2014  Alfonso Perez     REQ-164485: Creacion
     6.0        20/05/2014  César Quispe      REQ-165004 Creación Interface de compra servicios SVA 
     7.0        20/12/2018  Max Mendoza       INC000001396344: NO GENERA SOT - DEMO
  ******************************************************************************************************************/

  CURSOR cur_correo IS
    SELECT a.email
      FROM envcorreo a
     WHERE a.tipo = 2
       AND area = :new.areasol;
  -- aprobacion de demo elty
  CURSOR cur_correo1 IS
    SELECT a.email
      FROM envcorreo a
     WHERE a.tipo = 5
       AND area = :NEW.areasol;
  --hasta aqui elty
  -- Inicio Daniel Arakaki 20/09/2002 Req 004157
  CURSOR cur_correo_rechazo IS
    SELECT a.email
      FROM envcorreo a
     WHERE a.tipo = 5
       AND trim(a.coddpt) = '0087';
  -- Fin Daniel Arakaki 20/09/2002
  l_observacion solotchgest.observacion%TYPE;
BEGIN
  IF UPDATING('ESTSOL') THEN
    IF :OLD.estsol <> :NEW.estsol AND :NEW.estsol = 11 THEN
      ls_texto := 'Fue aprobada por ' || USER || ' Fecha: ' ||
                  TO_CHAR(SYSDATE, 'dd/mm/yyyy hh24:mi:ss') || CHR(13);
      IF :NEW.numslc IS NOT NULL THEN
        ls_texto := ls_texto || 'Proyecto: ' || :NEW.numslc;
      END IF;
      FOR ls_correo IN cur_correo LOOP
        PRODUCCION.P_ENVIA_CORREO_DE_TEXTO_ATT('Solicitud de Orden de Trabajo ' ||
                                               TO_CHAR(:NEW.codsolot),
                                               ls_correo.email,
                                               ls_texto);
      END LOOP;
      --Envia mail al aprobar una demo elty
      IF :NEW.numslc IS NOT NULL THEN
        BEGIN
          SELECT a.codcli,
                 a.tipsrv,
                 a.codect,
                 a.estpspcli,
                 DECODE(a.nrodia, NULL, '', TO_CHAR(a.nrodia)),
                 a.titpsp
            INTO ls_codcli,
                 ls_tipsrv,
                 ls_codect,
                 ls_estado,
                 ls_nrodia,
                 ls_titpsp
            FROM vtatabpspcli_v a, vtatabslcfac b
           WHERE a.numslc = b.numslc
             AND a.numslc = :NEW.numslc;
        
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            ls_codcli := '';
            ls_tipsrv := '';
            ls_codect := '';
            ls_estado := '';
            ls_nrodia := '';
            --ls_codsrv:='';
        END;
      
        IF (ls_estado = '05') THEN
          ls_valor  := '';
          ls_valor2 := CHR(13) || 'Dias de duracion: ' || ls_nrodia;
          BEGIN
            SELECT NVL(dsctipsrv, 'No definido')
              INTO ls_dsctipsrv
              FROM tystipsrv
             WHERE tipsrv = ls_tipsrv;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              ls_dsctipsrv := 'No definido';
          END;
          /*                 begin
             select nvl(dscsrv,'No definido') into ls_dscsrv from tystabsrv where codsrv= ls_codsrv;
          exception when NO_DATA_FOUND then ls_dscsrv :='No definido';
          end;*/
          BEGIN
            SELECT NVL(nomcli, 'No definido')
              INTO ls_nomcli
              FROM vtatabcli
             WHERE codcli = ls_codcli;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              ls_nomcli := 'No definido';
          END;
          BEGIN
            SELECT NVL(nomect, 'No definido')
              INTO ls_nomect
              FROM vtatabect
             WHERE codect = ls_codect;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              ls_nomect := 'No definido';
          END;
          IF :NEW.tiptra = 108 THEN
            ls_valor  := 'FIN DE ';
            ls_valor2 := '';
          END IF;
          ls_texto := 'Aprobacion de SOLOT para ' || ls_valor || 'DEMO' ||
                      CHR(13) || ls_texto || CHR(13) || 'Cliente: ' ||
                      ls_nomcli || CHR(13) || 'Tipo de Servicio: ' ||
                      ls_dsctipsrv || CHR(13) || 'Servicio: ' || ls_titpsp ||
                      CHR(13) || 'Ejecutivo: ' || ls_nomect || ls_valor2;
          FOR ls_correo1 IN cur_correo1 LOOP
            P_ENVIA_CORREO_DE_TEXTO_ATT('Solicitud de Orden de Trabajo ' ||
                                        TO_CHAR(:NEW.codsolot),
                                        ls_correo1.email,
                                        ls_texto);
          END LOOP;
        END IF;
      
      END IF;
      --Hasta aqui elty
    END IF;
    --Inicio Actualizado Daniel Arakaki 20/09/2002
    IF :OLD.estsol <> :NEW.estsol AND :NEW.estsol IN (13, 14, 15) THEN
      ls_texto := 'Fue ' || PRODUCCION.F_GET_DESC_ESTSOLOT(:NEW.estsol) ||
                  ' por usuario: ' || USER || ' Fecha: ' ||
                  TO_CHAR(SYSDATE, 'dd/mm/yyyy hh24:mi:ss') || CHR(13);
      --Cliente
      ls_texto := ls_texto || 'Cliente: ' ||
                  PRODUCCION.F_GET_NOMCLI(:NEW.codcli) || CHR(13);
      --Codcli
      ls_texto := ls_texto || 'Codigo de Cliente: ' ||
                  PRODUCCION.F_GET_NOMCLI(:NEW.codcli) || CHR(13);
      --Proyecto
      IF :NEW.numslc IS NOT NULL THEN
        ls_texto := ls_texto || 'Proyecto: ' || :NEW.numslc || CHR(13);
      ELSE
        ls_texto := ls_texto || 'No es un Proyecto ' || CHR(13);
      END IF;
      --Tipo de servicio
      ls_texto := ls_texto || 'Tipo de Servicio: ' ||
                  PRODUCCION.F_GET_DSCTIPSRV_NUMSLC(:NEW.numslc) || CHR(13);
      --Usuario q genera la Sol OT
      ls_texto := ls_texto || 'Usuario que genera Sol OT: ' || :NEW.codusu ||
                  CHR(13);
      --Fecha de Generacion de Sol OT
      ls_texto := ls_texto || 'Fecha de Generacion de Sol OT: ' ||
                  :NEW.fecusu || CHR(13);
      --Consultor Asociado
      IF :NEW.numslc IS NOT NULL THEN
        ls_codect := PRODUCCION.F_GET_CODSOL_NUMSLC(:NEW.numslc);
        ls_texto  := ls_texto || 'Consultor Asociado: ' ||
                     F_GET_NOMBRE_CODECT(ls_codect) || CHR(13);
      END IF;
      --Motivo del rechazo del proyecto
      SELECT NVL(observacion, '<Null>')
        INTO l_observacion
        FROM solotchgest
       WHERE codsolot = :NEW.codsolot
         AND idseq = (SELECT MAX(idseq)
                        FROM solotchgest
                       WHERE codsolot = :NEW.codsolot);
    
      ls_texto := ls_texto || 'Motivo: ' || (l_observacion) || CHR(13);
      --
      FOR ls_correo IN cur_correo_rechazo LOOP
        PRODUCCION.P_ENVIA_CORREO_DE_TEXTO_ATT('Solicitud de Orden de Trabajo ' ||
                                               TO_CHAR(:NEW.codsolot),
                                               ls_correo.email ||
                                               F_GET_MAIL_CODECT(ls_codect),
                                               ls_texto);
        NULL;
      END LOOP;
    END IF;
    --Fin Actualizado Daniel Arakaki 20/09/2002
    --Inicio Actualizado Gustavo Ormeño 09/01/2008
    IF :NEW.estsol = 11 and ((:NEW.tiptra = 3 and :NEW.codmotot = 892) or
       (:NEW.tiptra = 349 and :NEW.codmotot = 892) or
       (:NEW.tiptra = 4 and :NEW.codmotot = 892)) THEN
      for c in (select codinssrv
                  from solotpto
                 where codsolot = :NEW.CODSOLOT) loop
        select numero
          into ls_nomabr
          from inssrv
         where codinssrv = c.codinssrv;
        if :NEW.tiptra = 3 and :NEW.codmotot = 892 then
          update transacciones t
             set t.codsolot = :NEW.CODSOLOT,
                 t.esttrans = 'MANUAL',
                 t.fecini   = :NEW.fecapr
           where t.codcli = :NEW.codcli
             and t.nomabr = ls_nomabr
             and t.fecfin is null
             and t.esttrans = 'PENDIENTE'
             and t.transaccion = 'SUSPENSION';
        end if;
        if :NEW.tiptra = 349 and :NEW.codmotot = 892 then
          update transacciones t
             set t.codsolot = :NEW.CODSOLOT,
                 t.esttrans = 'MANUAL',
                 t.fecini   = :NEW.fecapr
           where t.codcli = :NEW.codcli
             and t.nomabr = ls_nomabr
             and t.fecfin is null
             and t.esttrans = 'PENDIENTE'
             and t.transaccion = 'CORTE';
        end if;
        if :NEW.tiptra = 4 and :NEW.codmotot = 892 then
          update transacciones t
             set t.codsolot = :NEW.CODSOLOT,
                 t.esttrans = 'MANUAL',
                 t.fecini   = :NEW.fecapr
           where t.codcli = :NEW.codcli
             and t.nomabr = ls_nomabr
             and t.fecfin is null
             and t.esttrans = 'PENDIENTE'
             and t.transaccion = 'ACTIVACION';
        end if;
      end loop;
    END IF;
    -- Se adiciona lógica para que las suspensiones, cortes y reconexiones manuales, cancelen las transacciones de telefonía fija
    IF :NEW.estsol = 11 and ((:NEW.tiptra = 3 and :NEW.codmotot = 13) or
       (:NEW.tiptra = 349 and :NEW.codmotot = 13) or
       (:NEW.tiptra = 4 and :NEW.codmotot = 126)) THEN
      for c in (select codinssrv
                  from solotpto
                 where codsolot = :NEW.CODSOLOT) loop
        select numero
          into ls_nomabr
          from inssrv
         where codinssrv = c.codinssrv;
        if :NEW.tiptra = 3 and :NEW.codmotot = 13 then
          update transacciones t
             set t.codsolot = :NEW.CODSOLOT,
                 t.esttrans = 'MANUAL',
                 t.fecini   = :NEW.fecapr
           where t.codcli = :NEW.codcli
             and t.nomabr = ls_nomabr
             and t.fecfin is null
             and t.esttrans = 'PENDIENTE'
             and t.transaccion = 'SUSPENSION';
        end if;
        if :NEW.tiptra = 349 and :NEW.codmotot = 13 then
          update transacciones t
             set t.codsolot = :NEW.CODSOLOT,
                 t.esttrans = 'MANUAL',
                 t.fecini   = :NEW.fecapr
           where t.codcli = :NEW.codcli
             and t.nomabr = ls_nomabr
             and t.fecfin is null
             and t.esttrans = 'PENDIENTE'
             and t.transaccion = 'CORTE';
        end if;
        if :NEW.tiptra = 4 and (:NEW.codmotot = 126 or :NEW.codmotot = 13) then
          update transacciones t
             set t.codsolot = :NEW.CODSOLOT,
                 t.esttrans = 'MANUAL',
                 t.fecini   = :NEW.fecapr
           where t.codcli = :NEW.codcli
             and t.nomabr = ls_nomabr
             and t.fecfin is null
             and t.esttrans = 'PENDIENTE'
             and t.transaccion = 'ACTIVACION';
        end if;
      end loop;
    END IF;
    --Fin Actualizado Gustavo Ormeño 09/01/2008
    --Inicio Actualizado Juan Carlos Lara 06/02/2008
    /*   IF (:NEW.estsol = 11) and ((:NEW.tiptra = 117) or (:NEW.tiptra = 370) or (:NEW.tiptra = 371))  THEN
       insert into operacion.tmp_solot_codigo (codsolot, estado, usuario, fecharegistro, fechaejecucion, estsolot, observacion)
       values (:NEW.codsolot, 3, :NEW.codusu, sysdate, null, null, null);
    END IF;*/
    --Fin Actualizado Juan Carlos Lara 06/02/2008
  
    --Inicio Actualizado Roy Concepcion 13/08/2008
    IF :NEW.estsol = 17 THEN
    
      SELECT A.BLOQUEO_DESBLOQUEO
        INTO v_bloqueodesbloqueo
        FROM TIPTRABAJO A
       WHERE A.TIPTRA = :OLD.TIPTRA;
      IF v_bloqueodesbloqueo IN ('B', 'D') THEN
        UPDATE OPERACION.TMP_SOLOT_CODIGO
           SET ESTADO = 6
         WHERE CODSOLOT = :NEW.CODSOLOT;
        -- INSERT INTO OPERACION.TMP_SOLOT_CODIGO(CODSOLOT,ESTADO)
        -- VALUES(:NEW.CODSOLOT,6);
      END IF;
    
    END IF;
  
    --<2.0
    select count(*)
      into l_count --Configuracion de los tipos de trabajo en el Mantenimiento de Tipos y Estado en el Módulo de Operaciones
      from OPEDD
     where CODIGON = :NEW.tiptra
       and TIPOPEDD = 220;
  
    IF (l_count > 0) THEN
      IF (:NEW.estsol in (13, 15) and :old.estsol in (11, 17)) then
        for c in (select codinssrv
                    from solotpto
                   where codsolot = :NEW.CODSOLOT) loop
          BEGIN
            select CODIGOC
              into ls_codigoc --Configuracion de los tipos de trabajo en el Mantenimiento de Tipos y Estado en el Módulo de Operaciones
              from OPEDD
             where CODIGON = :NEW.tiptra
               and TIPOPEDD = 220;
          EXCEPTION
            WHEN no_data_found THEN
              ls_codigoc := '';
          END;
          BEGIN
            select numero
              into ls_nomabr
              from inssrv
             where codinssrv = c.codinssrv;
          EXCEPTION
            WHEN no_data_found THEN
              ls_nomabr := '';
          END;
        
          IF ls_codigoc = 'TR' THEN
            begin
              select idtransori
                into l_idtransori
                from transacciones
               where codcli = :NEW.codcli
                 and codsolot = :NEW.codsolot
                 and nomabr = ls_nomabr;
            exception
              when no_data_found then
                l_idtransori := '';
            end;
            update transacciones
               set fecfin = sysdate, esttrans = 'CANCELADA'
             where codcli = :NEW.codcli
               and codsolot = :NEW.codsolot
               and nomabr = ls_nomabr
               and fecfin is null;
            update transacciones
               set fecfin = null
             where idtrans = l_idtransori;
          END IF;
          IF ls_codigoc = 'TC' THEN
            begin
              select idtransori
                into l_idtransori
                from transacciones_cable
               where codcli = :NEW.codcli
                 and codsolot = :NEW.codsolot
                 and nomabr = ls_nomabr;
            exception
              when no_data_found then
                l_idtransori := '';
            end;
            update transacciones_cable
               set fecfin = sysdate
             where codcli = :NEW.codcli
               and codsolot = :NEW.codsolot
               and nomabr = ls_nomabr
               and fecfin is null;
            update transacciones_cable
               set fecfin = null
             where idtrans = l_idtransori;
          END IF;
        end loop;
      END IF;
    END IF;
    --2.0>
    --<Ini 3.0>
    IF :NEW.estsol = 12 THEN
      --PARA ALTA
      select count(1)
        into ln_cantidad
        from atccorp.atc_transcanje_cab a
       where a.estado = 1
         and a.transferido = 1
         and a.fecini_alta is null
         and a.fecfin_alta is null
         and a.transaccion = 'A'
         and a.codsolot = :NEW.CODSOLOT;
    
      IF ln_cantidad > 0 THEN
        update atccorp.atc_transcanje_det d
           set d.estado = 2
         where d.idtranscanjecab =
               (select idtranscanjecab
                  from atccorp.atc_transcanje_cab
                 where codsolot = :NEW.CODSOLOT
                   and estado = 1
                   and transferido = 1
                   and fecini_alta is null
                   and fecfin_alta is null
                   and transaccion = 'A')
           and d.estado = 1
           and d.transferido = 1;
      
        update atccorp.atc_transcanje_cab c
           set c.estado      = 2,
               c.fecini_alta = sysdate,
               c.fecfin_alta =
               (sysdate + c.dias_vigencia)
         where c.codsolot = :NEW.CODSOLOT
           and c.estado = 1
           and c.transferido = 1
           and c.fecini_alta is null
           and c.fecfin_alta is null
           and c.transaccion = 'A';
      END IF;
    
      --<Ini 5.0>
      SELECT COUNT(1)
        INTO ln_cantidad
        FROM atccorp.atc_trx_promocion a
       WHERE a.estado = 2
         AND a.fecprogbaja IS NULL
         AND a.codsolot_alta = :NEW.CODSOLOT;
    
      IF ln_cantidad > 0 THEN
        UPDATE atccorp.atc_trx_promocion a
           SET a.estado      = 3,
               a.fecatensot  = SYSDATE,
               a.fecprogbaja =
               (SYSDATE + a.diasprom)
         WHERE a.codsolot_alta = :NEW.CODSOLOT
           AND a.estado = 2
           AND a.fecprogbaja IS NULL;
        BEGIN
          SELECT MAX(T.ID_LOTECLIENTE)
            INTO ln_id_lotecliente
            FROM atccorp.atc_trx_promocion T
           WHERE T.CODSOLOT_ALTA = :NEW.CODSOLOT;
        
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            ln_id_lotecliente := NULL;
        END;
        IF ln_id_lotecliente IS NOT NULL THEN
          SELECT *
            INTO lr_atc_promocion
            FROM atccorp.atc_trx_promocion
           WHERE id_lotecliente = ln_id_lotecliente;
          BEGIN
          
            ATCCORP.PQ_LOTEPROM_ATC.P_ACTUALIZA_ALTAPROM(SYSDATE,
                                                         (SYSDATE +
                                                         lr_atc_promocion.diasprom),
                                                         'SOT de Alta atendido',
                                                         0,
                                                         lr_atc_promocion.Id_Lotecliente,
                                                         USER,
                                                         ln_coderror,
                                                         ls_descerror);
          EXCEPTION
            WHEN OTHERS THEN
              ln_id_lotecliente := NULL;
          END;
        END IF;
      
      END IF;
    
      --Baja de Promocion
      SELECT COUNT(1)
        INTO ln_cantidad
        FROM atccorp.atc_trx_promocion a
       WHERE a.estado = 5
         AND a.tipo_trx = 'B'
         AND a.FECGENSOT_BAJA IS NOT NULL
         AND a.CODSOLOT_BAJA = :NEW.CODSOLOT;
    
      IF ln_cantidad > 0 THEN
      
        BEGIN
          SELECT MAX(T.ID_LOTECLIENTE)
            INTO ln_id_lotecliente
            FROM atccorp.atc_trx_promocion T
           WHERE T.CODSOLOT_BAJA = :NEW.CODSOLOT;
        
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            ln_id_lotecliente := NULL;
        END;
      
        IF ln_id_lotecliente IS NOT NULL THEN
          SELECT *
            INTO lr_atc_promocion
            FROM atccorp.atc_trx_promocion
           WHERE id_lotecliente = ln_id_lotecliente;
          BEGIN
            ATCCORP.PQ_LOTEPROM_ATC.P_ACTUALIZA_BAJAPROM(SYSDATE,
                                                         'SOT de Baja atendida',
                                                         lr_atc_promocion.reintentos + 1,
                                                         0,
                                                         lr_atc_promocion.Id_Lotecliente,
                                                         USER,
                                                         ln_coderror,
                                                         ls_descerror);
          EXCEPTION
            WHEN OTHERS THEN
              ln_id_lotecliente := NULL;
          END;
        END IF;
        --<fin 5.0>
      END IF;
      --PARA BAJA
      select count(1)
        into ln_cantidad
        from atccorp.atc_transcanje_cab a
       where a.estado = 1
         and a.transferido = 1
         and a.fecini_baja is not null
         and a.fecfin_baja is null
         and a.transaccion = 'B'
         and a.codsolot = :NEW.CODSOLOT;
    
      IF ln_cantidad > 0 THEN
        update atccorp.atc_transcanje_det d
           set d.estado = 3
         where d.idtranscanjecab =
               (select idtranscanjecab
                  from atccorp.atc_transcanje_cab
                 where codsolot = :NEW.CODSOLOT
                   and estado = 1
                   and transferido = 1
                   and fecini_baja is not null
                   and fecfin_baja is null
                   and transaccion = 'B')
           and d.estado = 1
           and d.transferido = 1;
      
        update atccorp.atc_transcanje_cab c
           set c.estado = 3, c.fecfin_baja = sysdate
         where c.codsolot = :NEW.CODSOLOT
           and c.estado = 1
           and c.transferido = 1
           and c.fecini_baja is not null
           and c.fecfin_baja is null
           and c.transaccion = 'B';
      END IF;
      --<Ini 4.0>
      select count(1)
        into ln_cantidad
        from atccorp.transacciones_pv
       where codsolot = :NEW.CODSOLOT
         and estado = 2;
      IF ln_cantidad > 0 THEN
        update atccorp.transacciones_pv
           set estado = 3
         where codsolot = :NEW.CODSOLOT
           and estado = 2;
      END IF;
      --<Fin 4.0>
      --<Ini 5.0>
      SELECT COUNT(1)
        INTO ln_cantidad
        FROM atccorp.atc_trx_promocion a
       WHERE a.estado = 5
         AND a.codsolot_baja = :NEW.CODSOLOT;
    
      IF ln_cantidad > 0 THEN
        UPDATE atccorp.atc_trx_promocion a
           SET a.estado = 6
         WHERE a.codsolot_baja = :NEW.CODSOLOT
           AND a.estado = 5;
        --Actualizar SYSFIR
        BEGIN
          SELECT MAX(T.ID_LOTECLIENTE)
            INTO ln_id_lotecliente
            FROM atccorp.atc_trx_promocion T
           WHERE T.CODSOLOT_BAJA = :NEW.CODSOLOT;
        
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            ln_id_lotecliente := NULL;
        END;
        IF ln_id_lotecliente IS NOT NULL THEN
          SELECT *
            INTO lr_atc_promocion
            FROM atccorp.atc_trx_promocion
           WHERE id_lotecliente = ln_id_lotecliente;
          BEGIN
            ATCCORP.PQ_LOTEPROM_ATC.P_ACTUALIZA_BAJAPROM(SYSDATE,
                                                         'SOT de Baja atendida',
                                                         lr_atc_promocion.reintentos + 1,
                                                         0,
                                                         lr_atc_promocion.Id_Lotecliente,
                                                         USER,
                                                         ln_coderror,
                                                         ls_descerror);
          EXCEPTION
            WHEN OTHERS THEN
              ln_id_lotecliente := NULL;
          END;
        END IF;
      END IF;
      --<Fin 5.0>
    END IF;
    --<Fin 3.0>
    
    --<Ini 6.0>
    IF :NEW.Estsol <> :OLD.Estsol and :NEW.estsol = 15 and
       :NEW.Tiptra in (412, 427) THEN
      operacion.pq_serv_valor_agregado.p_revierte_envio_sva(:new.codsolot);
    END IF;
    --<Fin 6.0>
  END IF;
END;
/