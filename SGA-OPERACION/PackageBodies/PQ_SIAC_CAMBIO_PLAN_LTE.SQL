CREATE OR REPLACE PACKAGE BODY OPERACION.PQ_SIAC_CAMBIO_PLAN_LTE IS

  /**********************************************************************************************************************************
   NOMBRE:     OPERACION.PQ_SIAC_CAMBIO_PLAN_LTE
   PROPOSITO:  GENERACION DE CAMBIO DE PLAN LTE

   REVISIONES:
    VERSION   FECHA          AUTOR                  SOLICITADO POR             DESCRIPCION
    -------- ----------  ------------------------   ------------------------   -------------------------------------------------------
    1.0      21/10/2015  Dorian Sucasaca            Hector Huaman              PROY-20152: IDEA-24390 Proyecto LTE - 3Play inalámbrico
    2.0      15/12/2015  Dorian Sucasaca            Hector Huaman              PQT-247649-TSK-76965
    3.0      01/06/2017  Dorian Sucasaca
    4.0      21/06/2017  Luis Guzman                Tito Huerta                PROY-27792 IDEA-34954 - Proyecto LTE
    5.0      03/07/2018  Luis Flores                Luis Flores                [IDEA-40758/PROY-32581-Postventa LTE/HFC] - [Cambio Plan]
    6.0      13/08/2018  Yajaira Gastaniadui        Luis Flores                [IDEA-40758/PROY-32581-Postventa LTE/HFC] - [Cambio Plan]
    7.0      06/12/2018  Luis Flores                Luis Flores                [IDEA-40758/PROY-32581-Postventa LTE/HFC] - [Cambio Plan]
    8.0      10/12/2018  Luis Flores                Luis Flores                [IDEA-40758/PROY-32581-Postventa LTE/HFC] - [Cambio Plan]
    9.0      17/01/2019  Luis Flores                Luis Flores                [IDEA-40758/PROY-32581-Postventa LTE/HFC] - [Cambio Plan]
    10.0     24/01/2019  Luis Flores                Luis Flores                [IDEA-40758/PROY-32581-Postventa LTE/HFC] - [Cambio Plan]
    11.0     24/01/2019  Luis Flores                Luis Flores                [IDEA-40758/PROY-32581-Postventa LTE/HFC] - [Cambio Plan]
    12.0     11/02/2019  Luis Flores                Luis Flores                [IDEA-40758/PROY-32581-Postventa LTE/HFC] - [Cambio Plan]
    13.0     12/03/2019  Luis Flores                Luis Flores                [IDEA-40758/PROY-32581-Postventa LTE/HFC] - [Cambio Plan]
    14.0     14/03/2019  Luis Flores                Luis Flores                [IDEA-40758/PROY-32581-Postventa LTE/HFC] - [Cambio Plan]
    15.0     18/03/2019  Luis Flores                Luis Flores                [IDEA-40758/PROY-32581-Postventa LTE/HFC] - [Cambio Plan]
    16.0     26/03/2019  Luis Flores                Luis Flores                [IDEA-40758/PROY-32581-Postventa LTE/HFC] - [Cambio Plan]
    17.0     03/04/2019  Luis Flores                Luis Flores                [IDEA-40758/PROY-32581-Postventa LTE/HFC] - [Cambio Plan]
/***********************************************************************************************************************************/

  PROCEDURE EXECUTE_MAIN(P_IDPROCESS  SIAC_POSTVENTA_PROCESO.IDPROCESS%TYPE,
                         P_CUSTOMERID OPERACION.SOLOT.CUSTOMER_ID%TYPE,
                         P_ID         SALES.SISACT_POSTVENTA_DET_SERV_LTE.IDINTERACCION%TYPE,
                         P_COD_ID     SALES.SOT_SISACT.COD_ID%TYPE,
                         P_PRECON     PRECON_TYPE) IS

    L_SERVICES  SERVICES_TYPE;
    L_SERVICIOS SERVICIOS_TYPE;
    L_IDLINEA   SALES.PQ_INT_SISACT_SGA_LTE.IDLINEAS_TYPE;
    L_IDX       NUMBER := 0;

    LV_ID SALES.SISACT_POSTVENTA_DET_SERV_LTE.IDINTERACCION%TYPE;

    lv_msgerror operacion.postventasiac_log.msgerror%type;

    CURSOR SERVICIOS(PP_ID SALES.SISACT_POSTVENTA_DET_SERV_LTE.IDINTERACCION%TYPE) IS
      SELECT T.*
        FROM SALES.SISACT_POSTVENTA_DET_SERV_LTE T
       WHERE T.IDINTERACCION = PP_ID;

  BEGIN
    -- INI 3.0
    G_COD_ID       := P_COD_ID;
    G_CUSTOMERID   := P_CUSTOMERID;
    G_PROCESO      := 'SIAC CAMBIO PLAN LTE';
    G_CODSOLOT_OLD := OPERACION.PQ_SGA_IW.F_MAX_SOT_X_COD_ID(TO_NUMBER(P_COD_ID));

    LV_ID := trim(P_ID);

    FOR SRV IN SERVICIOS(LV_ID) LOOP

      L_IDX := L_IDX + 1;
      L_SERVICIOS(L_IDX).SERVICIO := SRV.SERVICIO;
      L_SERVICIOS(L_IDX).IDGRUPO_PRINCIPAL := SRV.IDGRUPO_PRINCIPAL;
      L_SERVICIOS(L_IDX).IDGRUPO := SRV.IDGRUPO;
      L_SERVICIOS(L_IDX).CANTIDAD_INSTANCIA := SRV.CANTIDAD_INSTANCIA;
      L_SERVICIOS(L_IDX).DSCSRV := SRV.DSCSRV;
      L_SERVICIOS(L_IDX).BANDWID := SRV.BANDWID;
      L_SERVICIOS(L_IDX).FLAG_LC := TRIM(SRV.FLAG_LC);
      L_SERVICIOS(L_IDX).CANTIDAD_IDLINEA := SRV.CANTIDAD_IDLINEA;

      IF TRIM(SRV.TIPEQU) = '0' OR LENGTH(TRIM(SRV.TIPEQU)) = 0 THEN
        L_SERVICIOS(L_IDX).TIPEQU := NULL;
      ELSE
        L_SERVICIOS(L_IDX).TIPEQU := SRV.TIPEQU;
      END IF;

      IF TRIM(SRV.CODTIPEQU) = '0' OR LENGTH(TRIM(SRV.CODTIPEQU)) = 0 THEN
        L_SERVICIOS(L_IDX).CODTIPEQU := NULL;
      ELSE
        L_SERVICIOS(L_IDX).CODTIPEQU := SRV.CODTIPEQU;
      END IF;

      L_SERVICIOS(L_IDX).CANTIDAD := SRV.CANTIDAD;
      L_SERVICIOS(L_IDX).DSCEQU := SRV.DSCEQU;
      L_SERVICIOS(L_IDX).CODIGO_EXT := SRV.CODIGO_EXT;
      L_SERVICIOS(L_IDX).SNCODE := SRV.SNCODE;

    END LOOP;

    IF L_IDX = 0 THEN
      lv_msgerror := 'ID : '||P_ID|| ' - ' || 'Generacion de SOT: No se Encontro Productos Para Realizar el Cambio de Plan !!!' ||
                     ' - Linea (' || dbms_utility.format_error_backtrace || ')';
      OPERACION.PQ_SIAC_CAMBIO_PLAN.p_insert_log_post_siac(p_cod_id,
                                                         0,
                                                         'EXECUTE_MAIN',
                                                         lv_msgerror);

      RAISE_APPLICATION_ERROR(-20000,
                              lv_msgerror); -- 3.0
      -- FIN 3.0
    END IF;

    G_IDPROCESS := P_IDPROCESS;
    /***** Validamos Contrato *****/
    OPERACION.PQ_SIAC_POSTVENTA.P_VALIDA_TRANS_CO_ID(P_COD_ID);
    /***** Registro de Servicios en un Tipo de Dato Array *****/
    L_SERVICES := OPERACION.PQ_SIAC_CAMBIO_PLAN_LTE.FNC_GET_SERVICES(L_SERVICIOS);

    /***** Registro de Bouquets *****/
    OPERACION.PQ_SIAC_CAMBIO_PLAN_LTE.SP_SET_BOUQUET(L_SERVICIOS,
                                                     L_IDLINEA);
    /***** Registro de Venta Menor  *****/
    OPERACION.PQ_SIAC_CAMBIO_PLAN_LTE.SP_CREATE_REGVTAMENTAB(P_COD_ID);
    /***** Registro de Detalles de Venta Menor *****/
    OPERACION.PQ_SIAC_CAMBIO_PLAN_LTE.SP_CREATE_SALES_DETAIL(L_SERVICES);
    /***** Registro de Proyecto *****/
    OPERACION.PQ_SIAC_CAMBIO_PLAN_LTE.SP_GENERAR_SEF(G_NUMREGISTRO);
    /***** Registro de Detalles de Venta *****/
    OPERACION.PQ_SIAC_CAMBIO_PLAN_LTE.SP_GENERAR_PTOENL_CAMBIO(G_NUMREGISTRO,
                                                               G_NUMSLC_NEW,
                                                               P_PRECON);
    /***** Actualizacion de Datos de Venta *****/
    OPERACION.PQ_SIAC_CAMBIO_PLAN_LTE.SP_UPDATE_NUMSLC_NEW();
    /***** Creacion de Registros de Baja *****/
    OPERACION.PQ_SIAC_CAMBIO_PLAN_LTE.SGASS_REGINSPRDBAJA(G_NUMSLC_OLD,
                                                          G_COD_ID); -- 3.0
    /***** Registro de Informacion de Paquete *****/
    OPERACION.PQ_SIAC_CAMBIO_PLAN_LTE.SP_LOAD_INSTANCIA_CAMBIO(G_NUMSLC_NEW);
    /***** Registro de Interfaz de SEF y Contrato *****/
    OPERACION.PQ_SIAC_CAMBIO_PLAN_LTE.SP_CREATE_VTATABPRECON(G_NUMSLC_NEW,
                                                             P_PRECON);
    /***** Validaciones de Solucion *****/
    OPERACION.PQ_SIAC_CAMBIO_PLAN_LTE.SP_VALIDAR_TIPOSOLUCION(G_NUMSLC_NEW);
    /***** Validaciones de Proyecto *****/

    IF FNC_VALIDAR_CHECKPROY(G_NUMSLC_NEW) <> 'OK' THEN
      lv_msgerror := 'ID : '||P_ID|| ' - ' || 'Generacion de SOT: Error !!!' ||
                     ' - Linea (' || dbms_utility.format_error_backtrace || ')';
      OPERACION.PQ_SIAC_CAMBIO_PLAN.p_insert_log_post_siac(p_cod_id,
                                                         0,
                                                         'EXECUTE_MAIN',
                                                         lv_msgerror);
      RAISE_APPLICATION_ERROR(-20000, 'Generacion de SOT: Error !!!'); -- 3.0
    ELSE
      UPDATE vtatabslcfac SET ESTSOLFAC = '03' WHERE numslc = G_NUMSLC_NEW;
    END IF;

    /***** Proceso Principal:
    -       Generacion de SOT y Detalle
    -       Generacion de Instancias.
    -       Ejecucion de WF y Tareas ( si esta Configurado en Automatico *****/
    BEGIN
      OPERACION.PQ_INT_PRYOPE.P_EXE_INT_PRYOPE(g_numslc_new,
                                               null,
                                               null,
                                               11,
                                               null);
      select s.codsolot into g_codsolot from solot s
      where s.numslc = g_numslc_new;

    EXCEPTION
      WHEN OTHERS THEN
        lv_msgerror := 'ERROR:.' || SQLERRM || ' Linea (' ||
                  dbms_utility.format_error_backtrace || ')';
        ROLLBACK;
        OPERACION.PQ_SIAC_CAMBIO_PLAN.p_insert_log_post_siac(p_cod_id, 0, g_proceso,lv_msgerror);
        RAISE_APPLICATION_ERROR(-20000,
                              'ERROR EN LA INTERFAZ VENTAS/OPERACIONES');
    END;

    SP_SET_INSTANCE('SOT', G_CODSOLOT);
    /***** Actualizacion de SOT *****/
    OPERACION.PQ_SIAC_CAMBIO_PLAN_LTE.SP_SET_SOLOT(P_CUSTOMERID,
                                                   G_CODSOLOT);

    /***** Actualizacion de SISACT_POSTVENTA_DET_SERV_LTE  *****/
    OPERACION.PQ_SIAC_CAMBIO_PLAN_LTE.SP_SET_DET_SERV_LTE(LV_ID,
                                                          G_CODSOLOT);

    COMMIT;

  EXCEPTION
    WHEN OTHERS THEN
      lv_msgerror := $$plsql_unit || '.' || 'EXECUTE_MAIN: ' || sqlerrm ||
                     ' - Linea (' || dbms_utility.format_error_backtrace || ')';

      OPERACION.PQ_SIAC_CAMBIO_PLAN.p_insert_log_post_siac(p_cod_id,
                                                           0,
                                                           g_proceso,
                                                           lv_msgerror);

      RAISE_APPLICATION_ERROR(-20000,
                              $$plsql_unit || '.' ||
                              'OPERACION.PQ_SIAC_CAMBIO_PLAN_LTE.EXECUTE_MAIN: ' ||
                              sqlerrm);
      --Fin 13.0
  END;

  PROCEDURE SP_CREATE_REGVTAMENTAB(P_COD_ID OPERACION.SOLOT.COD_ID%TYPE) IS
    L_INSSRV INSSRV%ROWTYPE;
    L_CNTCLI VTATABCNTCLI%ROWTYPE;
    L_SLCFAC VTATABSLCFAC%ROWTYPE;
    L_REGMEN REGVTAMENTAB%ROWTYPE;

  BEGIN
    G_COD_ID                := P_COD_ID;
    L_INSSRV                := FNC_GET_INSSRV(G_COD_ID);
    L_CNTCLI                := FNC_GET_CNTCLI(G_COD_ID);
    L_SLCFAC                := FNC_GET_SLCFAC(G_COD_ID);
    G_NUMSLC_OLD            := L_SLCFAC.NUMSLC;
    L_REGMEN.CODCLI         := L_INSSRV.CODCLI;
    L_REGMEN.FECPEDSOL      := SYSDATE;
    L_REGMEN.CODSOL         := '00035885';
    L_REGMEN.SRVPRI         := 'PYMES - Servicios Complementarios';
    L_REGMEN.OBSSOLFAC      := 'Tipo de Venta: Cambio de Plan LTE';
    L_REGMEN.CODSUCORI      := L_INSSRV.CODSUC;
    L_REGMEN.DESCPTOORI     := L_INSSRV.DESCRIPCION;
    L_REGMEN.DIRPTOORI      := L_INSSRV.DIRECCION;
    L_REGMEN.UBIPTOORI      := L_INSSRV.CODUBI;
    L_REGMEN.CODCNT         := L_CNTCLI.CODCNT;
    L_REGMEN.NOMCNT         := L_CNTCLI.NOMCNT;
    L_REGMEN.TIPCNT         := L_CNTCLI.TIPCNT;
    L_REGMEN.IDPAQ          := L_INSSRV.IDPAQ;
    L_REGMEN.TIPSRV         := L_SLCFAC.TIPSRV;
    L_REGMEN.MONEDA_ID      := L_SLCFAC.MONEDA_ID;
    L_REGMEN.PLAZO_SRV      := L_SLCFAC.PLAZO_SRV;
    L_REGMEN.IDSOLUCION     := L_SLCFAC.IDSOLUCION;
    L_REGMEN.IDCAMPANHA     := L_SLCFAC.IDCAMPANHA;
    L_REGMEN.PREC_REC       := 0.0000;
    L_REGMEN.PREC_NOREC     := 0.0000;
    L_REGMEN.NUMSLC_ORI     := L_SLCFAC.NUMSLC;
    L_REGMEN.TIPSRV_DES     := L_SLCFAC.TIPSRV;
    L_REGMEN.IDSOLUCION_DES := L_SLCFAC.IDSOLUCION;
    L_REGMEN.IDCAMPANHA_DES := L_SLCFAC.IDCAMPANHA;
    L_REGMEN.FLG_AGENDA     := FNC_GET_AGENDA(G_IDPROCESS);
    --DEFAULT
    L_REGMEN.CODUSU              := USER;
    L_REGMEN.FECUSU              := SYSDATE;
    L_REGMEN.IDPRIORIDAD         := 3;
    L_REGMEN.TIPPRO              := 0;
    L_REGMEN.FLGCATEGORIA        := 0;
    L_REGMEN.FLGPRYESP           := 0;
    L_REGMEN.TIPO                := 0;
    L_REGMEN.FLGCBAN             := 0;
    L_REGMEN.FLGCEQU             := 0;
    L_REGMEN.DERIVADO            := 0;
    L_REGMEN.FLGCOVE             := 0;
    L_REGMEN.GENFACPEX           := '1';
    L_REGMEN.GENFACPIN           := '1';
    L_REGMEN.PCFLG_TRANSFERENCIA := '0';
    L_REGMEN.GENFACTEL           := '0';
    L_REGMEN.GENFACISP           := '0';

    G_NUMREGISTRO := FNC_INSERT_REGVTAMENTAB(L_REGMEN);
    SP_SET_INSTANCE('NUMREGISTRO', G_NUMREGISTRO);
    OPERACION.PQ_SIAC_CAMBIO_PLAN.P_INSERT_LOG_POST_SIAC(G_COD_ID,
                                                         G_CUSTOMERID,
                                                         G_PROCESO,
                                                         'Generacion de Venta Menor: OK');
  EXCEPTION
    -- INI 3.0
    WHEN OTHERS THEN
      G_MSJ_ERR := 'ERROR AL EJECUTAR SP: ' || $$PLSQL_UNIT ||
                   '.SP_CREATE_REGVTAMENTAB, ' || CHR(13) ||
                   'MENSAJE DE ERROR: ' || TO_CHAR(SQLERRM); -- 3.0
      OPERACION.PQ_SIAC_CAMBIO_PLAN.P_INSERT_LOG_POST_SIAC(G_COD_ID,
                                                           G_CUSTOMERID,
                                                           G_PROCESO,
                                                           G_MSJ_ERR ||
                                                           CHR(13) ||
                                                           ' TRAZA DE ERROR:   ' ||
                                                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE); -- 3.0
      RAISE_APPLICATION_ERROR(-20000, G_MSJ_ERR); -- 3.0
  END;

  PROCEDURE SP_SET_INSTANCE(P_TIPO_INSTANCIA OPERACION.SIAC_INSTANCIA.TIPO_INSTANCIA%TYPE,
                            P_INSTANCIA      OPERACION.SIAC_INSTANCIA.INSTANCIA%TYPE) IS
    L_INSTANCIA OPERACION.SIAC_INSTANCIA%ROWTYPE;

  BEGIN
    L_INSTANCIA.IDPROCESS      := G_IDPROCESS;
    L_INSTANCIA.TIPO_POSTVENTA := 'CAMBIO DE PLAN';
    L_INSTANCIA.TIPO_INSTANCIA := P_TIPO_INSTANCIA;
    L_INSTANCIA.INSTANCIA      := P_INSTANCIA;
    L_INSTANCIA.USUREG         := USER;
    L_INSTANCIA.FECREG         := SYSDATE;

    INSERT INTO OPERACION.SIAC_INSTANCIA VALUES L_INSTANCIA;
  EXCEPTION
    WHEN OTHERS THEN
      G_MSJ_ERR := 'ERROR AL EJECUTAR SP: ' || $$PLSQL_UNIT ||
                   '.SP_SET_INSTANCE, ' || CHR(13) || 'P_TIPO_INSTANCIA: ' ||
                   TO_CHAR(P_TIPO_INSTANCIA) || CHR(13) || 'P_INSTANCIA: ' ||
                   TO_CHAR(P_INSTANCIA) || CHR(13) || 'MENSAJE DE ERROR: ' ||
                   TO_CHAR(SQLERRM); -- 3.0
      OPERACION.PQ_SIAC_CAMBIO_PLAN.P_INSERT_LOG_POST_SIAC(G_COD_ID,
                                                           G_CUSTOMERID,
                                                           G_PROCESO,
                                                           G_MSJ_ERR ||
                                                           CHR(13) ||
                                                           ' TRAZA DE ERROR:   ' ||
                                                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE); -- 3.0
      RAISE_APPLICATION_ERROR(-20000, G_MSJ_ERR); -- 3.0
  END;

  PROCEDURE SP_SET_SOLOT(P_CUSTOMERID OPERACION.SOLOT.CUSTOMER_ID%TYPE,
                         P_SOLOT      OPERACION.SOLOT.CODSOLOT%TYPE) IS
    LN_MOTOT  OPERACION.MOTOT.CODMOTOT%TYPE; -- 3.0
    LN_TIPTRA OPERACION.SOLOT.TIPTRA%TYPE; -- 3.0
    LN_COD_ID operacion.siac_postventa_proceso.COD_ID%TYPE; -- 3.0
    LN_AREA   OPERACION.SOLOT.AREASOL%TYPE; --4.0

  BEGIN
    -- INI 3.0
    SELECT L.CODMOTOT, L.COD_ID, L.TIPTRA
      INTO LN_MOTOT, LN_COD_ID, LN_TIPTRA
      FROM operacion.siac_postventa_proceso L
     WHERE L.IDPROCESS = G_IDPROCESS;

    -- INI 4.0
    BEGIN
      SELECT op.codigon
        INTO LN_AREA
        FROM opedd op
       WHERE op.abreviacion = 'AREA_CPLAN'
         AND op.tipopedd =
             (SELECT tipopedd
                FROM operacion.tipopedd b
               WHERE B.ABREV = 'CONF_WLLSIAC_CP');
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        SELECT AREASOL INTO LN_AREA FROM SOLOT WHERE CODSOLOT = P_SOLOT;
    END;
    -- FIN 4.0

    UPDATE SOLOT
       SET CUSTOMER_ID = P_CUSTOMERID,
           CODMOTOT    = LN_MOTOT,
           COD_ID_OLD  = LN_COD_ID,
           AREASOL     = LN_AREA,
           TIPTRA      = LN_TIPTRA
     WHERE CODSOLOT = P_SOLOT;
    -- FIN 3.0
  EXCEPTION
    WHEN OTHERS THEN
      G_MSJ_ERR := 'ERROR AL EJECUTAR SP: ' || $$PLSQL_UNIT ||
                   '.SP_SET_SOLOT, ' || CHR(13) || 'MENSAJE DE ERROR: ' ||
                   TO_CHAR(SQLERRM); -- 3.0
      OPERACION.PQ_SIAC_CAMBIO_PLAN.P_INSERT_LOG_POST_SIAC(G_COD_ID,
                                                           G_CUSTOMERID,
                                                           G_PROCESO,
                                                           G_MSJ_ERR ||
                                                           CHR(13) ||
                                                           ' TRAZA DE ERROR:   ' ||
                                                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE); -- 3.0
      RAISE_APPLICATION_ERROR(-20000, G_MSJ_ERR); -- 3.0
  END;

  PROCEDURE SP_SET_BOUQUET(P_SERVICIOS   SERVICIOS_TYPE,
                           P_IDLINEA_VTA OUT SALES.PQ_INT_SISACT_SGA_LTE.IDLINEAS_TYPE) IS

    L_CODSRV   SALES.TYSTABSRV.CODSRV%TYPE;
    L_IDLINEA  SALES.LINEA_PAQUETE.IDLINEA%TYPE;
    L_SERVICIO SALES.PQ_SERVICIO_SISACT_LTE.SERVICIO_TYPE;
    L_IDGRUPO  SALES.TYS_TABSRVXBOUQUET_REL.IDGRUPO%TYPE;
    L_CABLE    NUMBER;

  BEGIN
    FOR IDX IN P_SERVICIOS.FIRST .. P_SERVICIOS.LAST LOOP
      IF FNC_SERVICIO_PRINCIPAL(P_SERVICIOS(IDX).IDGRUPO) OR
         FNC_SERVICIO_ADICIONAL(P_SERVICIOS(IDX).IDGRUPO) THEN
        L_CABLE                      := 0;
        L_CODSRV                     := SALES.PQ_INT_SISACT_SGA_LTE_UTL.GET_CODSRV(P_SERVICIOS(IDX)
                                                                                   .SERVICIO);
        L_SERVICIO.SERVICIO          := P_SERVICIOS(IDX).SERVICIO;
        L_SERVICIO.DSCSRV            := P_SERVICIOS(IDX).DSCSRV;
        L_SERVICIO.BANDWID           := P_SERVICIOS(IDX).BANDWID;
        L_SERVICIO.IDGRUPO           := P_SERVICIOS(IDX).IDGRUPO;
        L_SERVICIO.IDGRUPO_PRINCIPAL := P_SERVICIOS(IDX).IDGRUPO_PRINCIPAL;
        L_SERVICIO.FLAG_LC           := P_SERVICIOS(IDX).FLAG_LC;
        L_SERVICIO.CODIGO_EXT        := P_SERVICIOS(IDX).CODIGO_EXT;

        L_IDLINEA := SALES.PQ_INT_SISACT_SGA_LTE_UTL.GET_IDLINEA_SRV(L_CODSRV);
        P_IDLINEA_VTA(IDX).IDLINEA := L_IDLINEA;
        P_IDLINEA_VTA(IDX).SERVICIO_SGA := L_CODSRV;
        P_IDLINEA_VTA(IDX).CANTIDAD_INSTANCIA := P_SERVICIOS(IDX).CANTIDAD;

        SELECT COUNT(*)
          INTO L_CABLE
          FROM SALES.CRMDD D, SALES.TIPCRMDD C
         WHERE D.TIPCRMDD = C.TIPCRMDD
           AND C.ABREV = 'CONF_GRP_LTE'
           AND D.CODIGOC = P_SERVICIOS(IDX).IDGRUPO_PRINCIPAL
           AND D.CODIGON = 3;

        IF L_CABLE > 0 THEN
          IF TRIM(P_SERVICIOS(IDX).CODIGO_EXT) IS NOT NULL THEN
            L_IDGRUPO := SALES.PQ_INT_SISACT_SGA_LTE_UTL.GET_IDGRUPO(P_IDLINEA_VTA(IDX)
                                                                     .SERVICIO_SGA);
            IF L_IDGRUPO IS NULL THEN
              SALES.PQ_SERVICIO_SISACT_LTE.CREATE_BOUQUET(L_SERVICIO,
                                                          P_IDLINEA_VTA(IDX)
                                                          .SERVICIO_SGA);
            ELSE
              SALES.PQ_SERVICIO_SISACT_LTE.INSERT_BOUQUET_DET(L_IDGRUPO,
                                                              P_SERVICIOS(IDX)
                                                              .CODIGO_EXT);
            END IF;
          END IF;
        END IF;
      END IF;
    END LOOP;
  EXCEPTION
    WHEN OTHERS THEN
      G_MSJ_ERR := 'ERROR AL EJECUTAR SP: ' || $$PLSQL_UNIT ||
                   '.SP_SET_BOUQUET, ' || CHR(13) || 'MENSAJE DE ERROR: ' ||
                   TO_CHAR(SQLERRM); -- 3.0
      OPERACION.PQ_SIAC_CAMBIO_PLAN.P_INSERT_LOG_POST_SIAC(G_COD_ID,
                                                           G_CUSTOMERID,
                                                           G_PROCESO,
                                                           G_MSJ_ERR ||
                                                           CHR(13) ||
                                                           ' TRAZA DE ERROR:   ' ||
                                                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE); -- 3.0
      RAISE_APPLICATION_ERROR(-20000, G_MSJ_ERR); -- 3.0
  END;

  PROCEDURE SP_SET_DET_SERV_LTE(P_ID    SALES.SISACT_POSTVENTA_DET_SERV_LTE.IDINTERACCION%TYPE,
                                P_SOLOT OPERACION.SOLOT.CODSOLOT%TYPE) IS
  BEGIN
    UPDATE SALES.SISACT_POSTVENTA_DET_SERV_LTE
       SET CODSOLOT = P_SOLOT
     WHERE IDINTERACCION = P_ID;
  EXCEPTION
    WHEN OTHERS THEN
      G_MSJ_ERR := 'ERROR AL EJECUTAR SP: ' || $$PLSQL_UNIT ||
                   '.SP_SET_DET_SERV_LTE, ' || CHR(13) || 'P_ID: ' ||
                   TO_CHAR(P_ID) || CHR(13) || 'MENSAJE DE ERROR: ' ||
                   TO_CHAR(SQLERRM); -- 3.0
      OPERACION.PQ_SIAC_CAMBIO_PLAN.P_INSERT_LOG_POST_SIAC(G_COD_ID,
                                                           G_CUSTOMERID,
                                                           G_PROCESO,
                                                           G_MSJ_ERR ||
                                                           CHR(13) ||
                                                           ' TRAZA DE ERROR:   ' ||
                                                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE); -- 3.0
      RAISE_APPLICATION_ERROR(-20000, G_MSJ_ERR); -- 3.0
  END;

  PROCEDURE SP_CREATE_SALES_DETAIL(P_SERVICES SERVICES_TYPE) IS
    L_INSSRV      INSSRV%ROWTYPE;
    L_IDSECUENCIA INSTANCIA_PAQUETE_CAMBIO.IDSECUENCIA%TYPE;
    L_NUMPTO      VTADETPTOENL.NUMPTO%TYPE;
    L_IDINSXPAQ   INSTANCIA_PAQUETE_CAMBIO.IDINSXPAQ%TYPE;

  BEGIN
    L_INSSRV    := FNC_GET_INSSRV(G_COD_ID);
    L_IDINSXPAQ := FNC_GET_IDINSXPAQ();

    FOR IDX IN P_SERVICES.FIRST .. P_SERVICES.LAST LOOP
      BEGIN
        L_IDSECUENCIA := FNC_CREATE_INST_PAQ_CAMBIO(L_IDINSXPAQ,
                                                    P_SERVICES(IDX).IDLINEA,
                                                    G_NUMREGISTRO,
                                                    L_INSSRV.CODSUC);
      EXCEPTION
        WHEN OTHERS THEN
          G_MSJ_ERR := 'ERROR AL EJECUTAR SP: ' || $$PLSQL_UNIT ||
                       '.SP_CREATE_SALES_DETAIL, ' || CHR(13) ||
                       'MENSAJE DE ERROR: ' || TO_CHAR(SQLERRM); -- 3.0
          OPERACION.PQ_SIAC_CAMBIO_PLAN.P_INSERT_LOG_POST_SIAC(G_COD_ID,
                                                               G_CUSTOMERID,
                                                               G_PROCESO,
                                                               G_MSJ_ERR ||
                                                               CHR(13) ||
                                                               ' TRAZA DE ERROR:   ' ||
                                                               DBMS_UTILITY.FORMAT_ERROR_BACKTRACE); -- 3.0
          RAISE_APPLICATION_ERROR(-20000, G_MSJ_ERR); -- 3.0
      END;
      BEGIN
        L_NUMPTO := LPAD(IDX, 5, '0');
        SP_CREATE_REGDETPTOENLCAMBIO(L_IDSECUENCIA,
                                     P_SERVICES   (IDX).IDLINEA,
                                     P_SERVICES   (IDX).CANTIDAD,
                                     P_SERVICES   (IDX).TIPO,
                                     L_NUMPTO,
                                     L_IDINSXPAQ);
      EXCEPTION
        WHEN OTHERS THEN
          G_MSJ_ERR := 'ERROR AL EJECUTAR SP: ' || $$PLSQL_UNIT || '.' ||
                       'SP_CREATE_SALES_DETAIL, ' || CHR(13) ||
                       'MENSAJE DE ERROR: ' || TO_CHAR(SQLERRM); -- 3.0
          OPERACION.PQ_SIAC_CAMBIO_PLAN.P_INSERT_LOG_POST_SIAC(G_COD_ID,
                                                               G_CUSTOMERID,
                                                               G_PROCESO,
                                                               G_MSJ_ERR ||
                                                               CHR(13) ||
                                                               ' TRAZA DE ERROR:   ' ||
                                                               DBMS_UTILITY.FORMAT_ERROR_BACKTRACE); -- 3.0
          RAISE_APPLICATION_ERROR(-20000, G_MSJ_ERR); -- 3.0
      END;
    END LOOP;
    OPERACION.PQ_SIAC_CAMBIO_PLAN.P_INSERT_LOG_POST_SIAC(G_COD_ID,
                                                         G_CUSTOMERID,
                                                         G_PROCESO,
                                                         'Generacion de Detalle Venta Menor: OK');
  END;

  PROCEDURE SP_CREATE_REGDETPTOENLCAMBIO(P_IDSECUENCIA INSTANCIA_PAQUETE_CAMBIO.IDSECUENCIA%TYPE,
                                         P_IDLINEA     LINEA_PAQUETE.IDLINEA%TYPE,
                                         P_CANTIDAD    SALES.VTADETPTOENL.CANTIDAD%TYPE,
                                         P_TIPO        NUMBER,
                                         P_PUNTO       VTADETPTOENL.NUMPTO%TYPE,
                                         P_IDINSXPAQ   REGDETPTOENLCAMBIO.IDINSXPAQ%TYPE) IS
    L_SERVICIO DETALLE_SERVICIO_TYPE;
    L_DETALLE  REGDETPTOENLCAMBIO%ROWTYPE;
    L_INSSRV   INSSRV%ROWTYPE;

  BEGIN
    L_SERVICIO           := FNC_GET_DETALLE_SERVICIO(P_IDLINEA);
    L_INSSRV             := FNC_GET_INSSRV(G_COD_ID);
    L_DETALLE.FLGSRV_PRI := L_SERVICIO.FLGPRINCIPAL;
    L_DETALLE.IDPRODUCTO := L_SERVICIO.IDPRODUCTO;
    L_DETALLE.CODSRV     := L_SERVICIO.CODSRV;
    L_DETALLE.CODEQUCOM  := L_SERVICIO.CODEQUCOM;
    L_DETALLE.IDPRECIO   := L_SERVICIO.IDPRECIO;
    IF P_CANTIDAD IS NULL THEN
      L_DETALLE.CANTIDAD := 1;
    ELSE
      L_DETALLE.CANTIDAD := P_CANTIDAD;
    END IF;

    L_DETALLE.MONEDA_ID     := L_SERVICIO.MONEDA_ID;
    L_DETALLE.IDPAQ         := L_SERVICIO.IDPAQ;
    L_DETALLE.IDDET         := L_SERVICIO.IDDET;
    L_DETALLE.PAQUETE       := L_SERVICIO.PAQUETE;
    L_DETALLE.TIPO          := 1;
    L_DETALLE.BANWID        := L_SERVICIO.BANWID;
    L_DETALLE.NUMREGISTRO   := G_NUMREGISTRO;
    L_DETALLE.NUMPTO        := P_PUNTO;
    L_DETALLE.DESCPTO       := L_INSSRV.DESCRIPCION;
    L_DETALLE.DIRPTO        := L_INSSRV.DIRECCION;
    L_DETALLE.UBIPTO        := L_INSSRV.CODUBI;
    L_DETALLE.CODSUC        := L_INSSRV.CODSUC;
    L_DETALLE.TIPO_VTA      := P_TIPO;
    L_DETALLE.CREPTO        := '1';
    L_DETALLE.ESTCTS        := '0';
    L_DETALLE.ESTCSE        := '0';
    L_DETALLE.PRELIS_SRV    := 0.00;
    L_DETALLE.PRELIS_INS    := 0.00;
    L_DETALLE.DESC_SRV      := 0.00;
    L_DETALLE.DESC_INS      := 0.00;
    L_DETALLE.MONTO_SRV     := 0.00;
    L_DETALLE.MONTO_INS     := 0.00;
    L_DETALLE.PORCIMP_SRV   := FNC_GET_IMPUESTO(1);
    L_DETALLE.PORCIMP_INS   := FNC_GET_IMPUESTO(1);
    L_DETALLE.MONTO_SRV_IMP := 0.00;
    L_DETALLE.MONTO_INS_IMP := 0.00;
    L_DETALLE.FLGREDUN      := 0;
    L_DETALLE.PREUNI_SRV    := 0.00;
    L_DETALLE.PREUNI_INS    := 0.00;
    L_DETALLE.IDINSXPAQ     := P_IDINSXPAQ;
    L_DETALLE.IDSECUENCIA   := P_IDSECUENCIA;
    L_DETALLE.ESTMT         := 0;
    L_DETALLE.FLGPOST       := 0;
    INSERT INTO REGDETPTOENLCAMBIO VALUES L_DETALLE;
  EXCEPTION
    WHEN OTHERS THEN
      G_MSJ_ERR := 'ERROR AL EJECUTAR SP: ' || $$PLSQL_UNIT || '.' ||
                   'SP_CREATE_REGDETPTOENLCAMBIO, ' || CHR(13) ||
                   'P_IDSECUENCIA: ' || TO_CHAR(P_IDSECUENCIA) || CHR(13) ||
                   'P_IDLINEA: ' || TO_CHAR(P_IDLINEA) || CHR(13) ||
                   'MENSAJE DE ERROR: ' || TO_CHAR(SQLERRM); -- 3.0
      OPERACION.PQ_SIAC_CAMBIO_PLAN.P_INSERT_LOG_POST_SIAC(G_COD_ID,
                                                           G_CUSTOMERID,
                                                           G_PROCESO,
                                                           G_MSJ_ERR ||
                                                           CHR(13) ||
                                                           ' TRAZA DE ERROR:   ' ||
                                                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE); -- 3.0
      RAISE_APPLICATION_ERROR(-20000, G_MSJ_ERR); -- 3.0
  END;

  PROCEDURE SP_GENERAR_SEF(P_NUMREGISTRO REGVTAMENTAB.NUMREGISTRO%TYPE) IS
    L_REGVTAMEN           REGVTAMENTAB%ROWTYPE;
    L_IDSOLUCION          REGVTAMENTAB.IDSOLUCION%TYPE;
    L_CONT_PAQUETE_CAMBIO NUMBER;
    L_FOUND               BOOLEAN := FALSE;
    L_FLG_CEHFC           NUMBER;
    L_TIP_CR              NUMBER;
    L_NUMSLC              VTATABSLCFAC.NUMSLC%TYPE;
    L_VENTA               VTATABSLCFAC%ROWTYPE;

  BEGIN
    SELECT *
      INTO L_REGVTAMEN
      FROM REGVTAMENTAB
     WHERE NUMREGISTRO = P_NUMREGISTRO;

    L_REGVTAMEN.FECPEDSOL := SYSDATE;
    L_REGVTAMEN.ESTSOLFAC := '00';
    L_REGVTAMEN.FLGESTCOM := 0;

    SELECT COUNT(*)
      INTO L_CONT_PAQUETE_CAMBIO
      FROM INSTANCIA_PAQUETE_CAMBIO
     WHERE NUMREGISTRO = P_NUMREGISTRO;

    FOR X IN (SELECT *
                FROM OPEDD O
               WHERE O.ABREVIACION = 'SOL_CEHFC'
                 AND O.CODIGOC = L_REGVTAMEN.TIPSRV) LOOP
      L_FOUND     := TRUE;
      L_FLG_CEHFC := 1;
      EXIT;
    END LOOP;

    IF NOT L_FOUND THEN
      L_FLG_CEHFC := 0;
    END IF;

    SELECT COUNT(*)
      INTO L_TIP_CR
      FROM INSTANCIA_PAQUETE_CAMBIO
     WHERE FLG_TIPO_VM = 'CR'
       AND NUMREGISTRO = P_NUMREGISTRO;

    IF L_TIP_CR > 0 THEN
      L_IDSOLUCION           := L_REGVTAMEN.IDSOLUCION_DES;
      L_REGVTAMEN.IDSOLUCION := L_IDSOLUCION;
    END IF;

    L_VENTA.CODCLI              := L_REGVTAMEN.CODCLI;
    L_VENTA.FECPEDSOL           := L_REGVTAMEN.FECPEDSOL;
    L_VENTA.ESTSOLFAC           := L_REGVTAMEN.ESTSOLFAC;
    L_VENTA.CODSOL              := L_REGVTAMEN.CODSOL;
    L_VENTA.SRVPRI              := L_REGVTAMEN.SRVPRI;
    L_VENTA.OBSSOLFAC           := L_REGVTAMEN.OBSSOLFAC;
    L_VENTA.FECAPR              := L_REGVTAMEN.FECAPR;
    L_VENTA.TIPSRV              := L_REGVTAMEN.TIPSRV_DES;
    L_VENTA.CODDPT              := L_REGVTAMEN.CODDPT;
    L_VENTA.CODSOLOT            := L_REGVTAMEN.CODSOLOT;
    L_VENTA.CODSRV              := L_REGVTAMEN.CODSRV;
    L_VENTA.CLIINT              := L_REGVTAMEN.CLIINT;
    L_VENTA.CODSOCIO            := L_REGVTAMEN.CODSOCIO;
    L_VENTA.IDVENDEA            := L_REGVTAMEN.IDVENDEA;
    L_VENTA.FLGESTCOM           := L_REGVTAMEN.FLGESTCOM;
    L_VENTA.CODUSUAPR           := L_REGVTAMEN.CODUSUAPR;
    L_VENTA.FECESTCOM           := L_REGVTAMEN.FECESTCOM;
    L_VENTA.FLGCATEGORIA        := L_REGVTAMEN.FLGCATEGORIA;
    L_VENTA.MONEDA_ID           := L_REGVTAMEN.MONEDA_ID;
    L_VENTA.NTICKET             := L_REGVTAMEN.NTICKET;
    L_VENTA.PLAZO_SRV           := L_REGVTAMEN.PLAZO_SRV;
    L_VENTA.ON_NET              := L_REGVTAMEN.ON_NET;
    L_VENTA.FLG_PRICING         := L_REGVTAMEN.FLG_PRICING;
    L_VENTA.IDSOLUCION          := L_REGVTAMEN.IDSOLUCION_DES;
    L_VENTA.AREA                := L_REGVTAMEN.AREA;
    L_VENTA.NUMSLC_LSG          := L_REGVTAMEN.NUMSLC_LSG;
    L_VENTA.IDCAMPANHA          := L_REGVTAMEN.IDCAMPANHA_DES;
    L_VENTA.PCFLG_TRANSFERENCIA := L_REGVTAMEN.PCFLG_TRANSFERENCIA;
    L_VENTA.PCIDPLANTILLA       := L_REGVTAMEN.PCIDPLANTILLA;
    L_VENTA.PCIDPROYECTO        := L_REGVTAMEN.PCIDPROYECTO;
    L_VENTA.IDPRIORIDAD         := L_REGVTAMEN.IDPRIORIDAD;
    L_VENTA.FLG_CEHFC_CP        := L_FLG_CEHFC;
    L_VENTA.FLG_AGENDA          := L_REGVTAMEN.FLG_AGENDA;
    --DEFAULT
    L_VENTA.CODUSU    := USER;
    L_VENTA.FECUSU    := SYSDATE;
    L_VENTA.TIPO      := 0;
    L_VENTA.DERIVADO  := 0;
    L_VENTA.TIPPRO    := 0;
    L_VENTA.FLGPRYESP := 0;
    L_VENTA.FLGCOVE   := 0;
    L_VENTA.FLGCBAN   := 0;
    L_VENTA.FLGCEQU   := 0;
    L_VENTA.GENFACPIN := '1';
    L_VENTA.GENFACPEX := '1';
    L_VENTA.GENFACISP := '0';
    L_VENTA.GENFACTEL := '0';

    INSERT INTO VTATABSLCFAC VALUES L_VENTA RETURNING NUMSLC INTO L_NUMSLC;

    G_NUMSLC_NEW := L_NUMSLC;
    SP_SET_INSTANCE('PROYECTO DE POSTVENTA', G_NUMSLC_NEW);
    OPERACION.PQ_SIAC_CAMBIO_PLAN.P_INSERT_LOG_POST_SIAC(G_COD_ID,
                                                         G_CUSTOMERID,
                                                         G_PROCESO,
                                                         'Generacion de Proyecto: OK');
  EXCEPTION
    WHEN OTHERS THEN
      G_MSJ_ERR := 'ERROR AL EJECUTAR SP: ' || $$PLSQL_UNIT || '.' ||
                   'SP_GENERAR_SEF, ' || CHR(13) || 'MENSAJE DE ERROR: ' ||
                   TO_CHAR(SQLERRM); -- 3.0
      OPERACION.PQ_SIAC_CAMBIO_PLAN.P_INSERT_LOG_POST_SIAC(G_COD_ID,
                                                           G_CUSTOMERID,
                                                           G_PROCESO,
                                                           G_MSJ_ERR ||
                                                           CHR(13) ||
                                                           ' TRAZA DE ERROR:   ' ||
                                                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE); -- 3.0
      RAISE_APPLICATION_ERROR(-20000, G_MSJ_ERR); -- 3.0
  END;

  PROCEDURE SP_GENERAR_PTOENL_CAMBIO(P_NUMREGISTRO REGVTAMENTAB.NUMREGISTRO%TYPE,
                                     P_NUMSLC      VTATABSLCFAC.NUMSLC%TYPE,
                                     P_PRECON_TYPE PRECON_TYPE) IS
  BEGIN
    SP_ACTUALIZAR_PTO_PRI_CAMBIO(P_NUMREGISTRO);
    SP_LOAD_DETALLE_CAMBIO(P_NUMREGISTRO, P_NUMSLC);
    SALES.P_ACTUALIZA_PTO_PRI(P_NUMSLC);
    SP_ACTUALIZAR_GRUPO_CAMBIO(P_NUMSLC);
    SALES.P_ACTUALIZAR_GRUPO_DETPTOENL(P_NUMSLC);
    PQ_INT_VENTAS_OPE.P_ACTUALIZA_BANWID_ACCESO(P_NUMSLC);
    SP_GENERAR_DES_CAMBIO(P_NUMREGISTRO, P_NUMSLC, P_PRECON_TYPE);
  EXCEPTION
    WHEN OTHERS THEN
      G_MSJ_ERR := 'ERROR AL EJECUTAR SP: ' || $$PLSQL_UNIT || '.' ||
                   'SP_GENERAR_PTOENL_CAMBIO, ' || CHR(13) ||
                   'MENSAJE DE ERROR: ' || TO_CHAR(SQLERRM); -- 3.0
      OPERACION.PQ_SIAC_CAMBIO_PLAN.P_INSERT_LOG_POST_SIAC(G_COD_ID,
                                                           G_CUSTOMERID,
                                                           G_PROCESO,
                                                           G_MSJ_ERR ||
                                                           CHR(13) ||
                                                           ' TRAZA DE ERROR:   ' ||
                                                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE); -- 3.0
      RAISE_APPLICATION_ERROR(-20000, G_MSJ_ERR); -- 3.0
  END;

  PROCEDURE SP_ACTUALIZAR_PTO_PRI_CAMBIO(P_NUMREGISTRO REGVTAMENTAB.NUMREGISTRO%TYPE) IS

    CURSOR C_ACTUALIZA_PTO IS
      SELECT TIPO_VTA, PAQUETE
        FROM REGDETPTOENLCAMBIO
       WHERE NUMREGISTRO = P_NUMREGISTRO
       GROUP BY TIPO_VTA, PAQUETE
       ORDER BY TIPO_VTA, PAQUETE;

    L_NUMPTO REGDETPTOENLCAMBIO.NUMPTO%TYPE;

  BEGIN
    FOR R_CURSOR IN C_ACTUALIZA_PTO LOOP
      SELECT NUMPTO
        INTO L_NUMPTO
        FROM REGDETPTOENLCAMBIO
       WHERE NUMREGISTRO = P_NUMREGISTRO
         AND PAQUETE = R_CURSOR.PAQUETE
         AND FLGSRV_PRI = '1';

      UPDATE REGDETPTOENLCAMBIO
         SET NUMPTO_PRIN = L_NUMPTO
       WHERE NUMREGISTRO = P_NUMREGISTRO
         AND PAQUETE = R_CURSOR.PAQUETE;
    END LOOP;

  EXCEPTION
    WHEN OTHERS THEN
      G_MSJ_ERR := 'ERROR AL EJECUTAR SP: ' || $$PLSQL_UNIT ||
                   '.SP_ACTUALIZAR_PTO_PRI_CAMBIO, ' || CHR(13) ||
                   'MENSAJE DE ERROR: ' || TO_CHAR(SQLERRM); -- 3.0
      OPERACION.PQ_SIAC_CAMBIO_PLAN.P_INSERT_LOG_POST_SIAC(G_COD_ID,
                                                           G_CUSTOMERID,
                                                           G_PROCESO,
                                                           G_MSJ_ERR ||
                                                           CHR(13) ||
                                                           ' TRAZA DE ERROR:   ' ||
                                                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE); -- 3.0
      RAISE_APPLICATION_ERROR(-20000, G_MSJ_ERR); -- 3.0
  END;

  PROCEDURE SP_LOAD_DETALLE_CAMBIO(P_NUMREGISTRO REGVTAMENTAB.NUMREGISTRO%TYPE,
                                   P_NUMSLC      VTATABSLCFAC.NUMSLC%TYPE) IS

    CURSOR CUR_DET IS
      SELECT *
        FROM REGDETPTOENLCAMBIO
       WHERE NUMREGISTRO = P_NUMREGISTRO
       ORDER BY NUMPTO;

    CURSOR CUR_PRM(AAGRUPADOR NUMBER, AIDDET NUMBER) IS
      SELECT A.IDDET,
             A.IDPROM,
             B.DSCPROM DESCRIPCION,
             B.PORCENTAJE,
             B.AFECTACR,
             B.AFECTACNR,
             B.FLG_PROM_EN_LINEA
        FROM INSTANCIA_PROMOCION A, PROMOCION B
       WHERE A.AGRUPADOR = AAGRUPADOR
         AND A.IDPROM = B.IDPROM
         AND A.FLGESTADO = 0
         AND A.TIPOVTA = 2
         AND A.IDDET = AIDDET;

    L_NUMSLC    VTATABSLCFAC.NUMSLC%TYPE;
    L_REGVTAMEN REGVTAMENTAB%ROWTYPE;
    L_TIPSRV    REGVTAMENTAB.TIPSRV%TYPE;
    L_TIPTRA    VTADETPTOENL.TIPTRA%TYPE;
    L_OPCION    NUMBER(2);
    L_ERROR     VARCHAR2(500);
    L_NUM_CR    NUMBER(5);
    L_AGRUPADOR INSTANCIA_PROMOCION.AGRUPADOR%TYPE;
    L_VTADET    VTADETPTOENL%ROWTYPE;

  BEGIN
    L_NUMSLC := P_NUMSLC;
    L_OPCION := 6;

    SELECT A.TIPSRV
      INTO L_TIPSRV
      FROM REGVTAMENTAB A
     WHERE NUMREGISTRO = P_NUMREGISTRO;

    SELECT COUNT(*)
      INTO L_NUM_CR
      FROM REGVTAMENTAB R, INSTANCIA_PAQUETE_CAMBIO I
     WHERE R.NUMREGISTRO = I.NUMREGISTRO
       AND I.FLG_TIPO_VM = 'CR'
       AND R.NUMREGISTRO = P_NUMREGISTRO;

    IF L_NUM_CR > 0 THEN
      SELECT B.CODIGON
        INTO L_TIPTRA
        FROM TIPCRMDD A, CRMDD B
       WHERE A.TIPCRMDD = B.TIPCRMDD
         AND A.ABREV = 'CXC_TIPTRA'
         AND CODIGOC = (SELECT IDCAMPANHA
                          FROM REGVTAMENTAB
                         WHERE NUMREGISTRO = P_NUMREGISTRO);
    ELSE
      SELECT F_OBT_TIPTRAXTIPSRV(L_TIPSRV, L_OPCION)
        INTO L_TIPTRA
        FROM DUAL;
    END IF;

    SELECT NVL(A.AGRUPADOR_PROM_CP, ' ')
      INTO L_AGRUPADOR
      FROM REGVTAMENTAB A
     WHERE NUMREGISTRO = P_NUMREGISTRO;

    FOR C_DET IN CUR_DET LOOP
      BEGIN
        L_VTADET.NUMSLC        := L_NUMSLC;
        L_VTADET.NUMPTO        := C_DET.NUMPTO;
        L_VTADET.DESCPTO       := C_DET.DESCPTO;
        L_VTADET.DIRPTO        := C_DET.DIRPTO;
        L_VTADET.UBIPTO        := C_DET.UBIPTO;
        L_VTADET.CODSUC        := C_DET.CODSUC;
        L_VTADET.TIPO_VTA      := C_DET.TIPO;
        L_VTADET.PAQUETE       := C_DET.PAQUETE;
        L_VTADET.FLGSRV_PRI    := C_DET.FLGSRV_PRI;
        L_VTADET.IDPRODUCTO    := C_DET.IDPRODUCTO;
        L_VTADET.CODSRV        := C_DET.CODSRV;
        L_VTADET.CODEQUCOM     := C_DET.CODEQUCOM;
        L_VTADET.CREPTO        := '1';
        L_VTADET.ESTCTS        := C_DET.ESTCTS;
        L_VTADET.ESTCSE        := C_DET.ESTCSE;
        L_VTADET.BANWID        := C_DET.BANWID;
        L_VTADET.TIPTRA        := L_TIPTRA;
        L_VTADET.IDPRECIO      := C_DET.IDPRECIO;
        L_VTADET.PRELIS_SRV    := C_DET.PRELIS_SRV;
        L_VTADET.PRELIS_INS    := C_DET.PRELIS_INS;
        L_VTADET.DESC_SRV      := C_DET.DESC_SRV;
        L_VTADET.DESC_INS      := C_DET.DESC_INS;
        L_VTADET.MONTO_SRV     := C_DET.MONTO_SRV;
        L_VTADET.MONTO_INS     := C_DET.MONTO_INS;
        L_VTADET.PORCIMP_SRV   := C_DET.PORCIMP_SRV;
        L_VTADET.PORCIMP_INS   := C_DET.PORCIMP_INS;
        L_VTADET.MONTO_SRV_IMP := C_DET.MONTO_SRV_IMP;
        L_VTADET.MONTO_INS_IMP := C_DET.MONTO_INS_IMP;
        L_VTADET.CANTIDAD      := C_DET.CANTIDAD;
        L_VTADET.CODINSSRV     := C_DET.CODINSSRV_ORIG;
        L_VTADET.OBSERVACION   := C_DET.OBSERVACION;
        L_VTADET.PREUNI_SRV    := C_DET.PREUNI_SRV;
        L_VTADET.PREUNI_INS    := C_DET.PREUNI_INS;
        L_VTADET.MONEDA_ID     := C_DET.MONEDA_ID;
        L_VTADET.IDINSXPAQ     := C_DET.IDINSXPAQ;
        L_VTADET.IDPAQ         := C_DET.IDPAQ;
        L_VTADET.PID           := C_DET.PID;
        L_VTADET.PID_OLD       := C_DET.PID;
        L_VTADET.IDDET         := C_DET.IDDET;
        --DEFAULT
        L_VTADET.CODUSU        := USER;
        L_VTADET.FECUSU        := SYSDATE;
        L_VTADET.ON_NET        := 1;
        L_VTADET.ESTSER        := '00';
        L_VTADET.FLGPOST       := 0;
        L_VTADET.IDMODO_ACCESO := 0;
        L_VTADET.FLGREDUN      := 0;
        L_VTADET.FLGMNT        := 0;
        L_VTADET.FLGN_WIRELESS := 0;
        L_VTADET.RESERVA       := 0;
        L_VTADET.ESTMT         := 0;
        L_VTADET.FLGUPG        := 0;

        INSERT INTO VTADETPTOENL VALUES L_VTADET;

        -- PROMOCIONES POR PUNTO
        FOR C_PRM IN CUR_PRM(L_AGRUPADOR, C_DET.IDDET) LOOP
          BEGIN

            INSERT INTO VTADETPRMCOM
              (NUMSLC,
               NUMPTO,
               IDPROM,
               DESCRIPCION,
               PORCENTAJE,
               AFECTACNR,
               AFECTACR,
               FLGOBLIGATORIO,
               FLG_PROMLINEA)
            VALUES
              (L_NUMSLC,
               C_DET.NUMPTO,
               C_PRM.IDPROM,
               C_PRM.DESCRIPCION,
               C_PRM.PORCENTAJE,
               C_PRM.AFECTACNR,
               C_PRM.AFECTACR,
               0,
               C_PRM.FLG_PROM_EN_LINEA);

            UPDATE INSTANCIA_PROMOCION
               SET FLGESTADO   = 2,
                   NUMSLC      = L_NUMSLC,
                   NUMREGISTRO = P_NUMREGISTRO,
                   NUMPTO      = C_DET.NUMPTO
             WHERE IDDET = C_DET.IDDET
               AND IDPROM = C_PRM.IDPROM
               AND AGRUPADOR = L_AGRUPADOR
               AND TIPOVTA = 2;

          EXCEPTION
            WHEN OTHERS THEN
              UPDATE INSTANCIA_PROMOCION
                 SET FLGESTADO   = 1,
                     NUMSLC      = L_NUMSLC,
                     NUMREGISTRO = P_NUMREGISTRO,
                     NUMPTO      = C_DET.NUMPTO
               WHERE IDDET = C_DET.IDDET
                 AND IDPROM = C_PRM.IDPROM
                 AND AGRUPADOR = L_AGRUPADOR
                 AND TIPOVTA = 2;
          END;
        END LOOP;

        UPDATE INSTANCIA_PAQUETE_CAMBIO
           SET FLGCONTROL = 2, NUMPTO = C_DET.NUMPTO
         WHERE NUMREGISTRO = C_DET.NUMREGISTRO
           AND IDSECUENCIA = C_DET.IDSECUENCIA;

      EXCEPTION
        WHEN OTHERS THEN
          L_ERROR := SQLERRM;
          UPDATE INSTANCIA_PAQUETE_CAMBIO
             SET FLGCONTROL = 1
           WHERE NUMREGISTRO = C_DET.NUMREGISTRO
             AND NUMPTO = C_DET.IDSECUENCIA;
      END;
    END LOOP;

    UPDATE VTADETPTOENL A
       SET A.CODINSSRV =
           (SELECT DISTINCT B.CODINSSRV
              FROM VTADETPTOENL B
             WHERE A.NUMSLC = B.NUMSLC
               AND A.PAQUETE = B.PAQUETE
               AND B.CODINSSRV IS NOT NULL
               AND A.NUMPTO_PRIN = B.NUMPTO_PRIN
               AND B.NUMSLC = L_NUMSLC)
     WHERE A.NUMSLC = L_NUMSLC
       AND A.CODINSSRV IS NULL;

    SELECT *
      INTO L_REGVTAMEN
      FROM REGVTAMENTAB
     WHERE NUMREGISTRO = P_NUMREGISTRO;

    INSERT INTO VTADETCNTSLC
      (NUMSLC, CODCNT, NOMCNT, TIPCNT, FLG_PRINC)
    VALUES
      (L_NUMSLC,
       L_REGVTAMEN.CODCNT,
       L_REGVTAMEN.NOMCNT,
       L_REGVTAMEN.TIPCNT,
       L_REGVTAMEN.FLG_PRICNT);
    OPERACION.PQ_SIAC_CAMBIO_PLAN.P_INSERT_LOG_POST_SIAC(G_COD_ID,
                                                         G_CUSTOMERID,
                                                         G_PROCESO,
                                                         'Generacion de Detalle de Proyecto: OK');
  EXCEPTION
    WHEN OTHERS THEN
      G_MSJ_ERR := 'ERROR AL EJECUTAR SP: ' || $$PLSQL_UNIT ||
                   '.SP_LOAD_DETALLE_CAMBIO, ' || CHR(13) ||
                   'MENSAJE DE ERROR: ' || TO_CHAR(SQLERRM); -- 3.0
      OPERACION.PQ_SIAC_CAMBIO_PLAN.P_INSERT_LOG_POST_SIAC(G_COD_ID,
                                                           G_CUSTOMERID,
                                                           G_PROCESO,
                                                           G_MSJ_ERR ||
                                                           CHR(13) ||
                                                           ' TRAZA DE ERROR:   ' ||
                                                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE); -- 3.0
      RAISE_APPLICATION_ERROR(-20000, G_MSJ_ERR); -- 3.0
  END;

  PROCEDURE SP_ACTUALIZAR_GRUPO_CAMBIO(P_NUMSLC VTATABSLCFAC.NUMSLC%TYPE) IS
    L_COUNT PLS_INTEGER;

  BEGIN
    SELECT COUNT(*)
      INTO L_COUNT
      FROM INSTANCIA_PAQUETE_CAMBIO
     WHERE NUMSLC = P_NUMSLC
       AND FLG_TIPO_VM IN ('CP', 'CR');

    IF L_COUNT > 0 THEN
      UPDATE VTADETPTOENL SET GRUPO = 1 WHERE NUMSLC = P_NUMSLC;
    END IF;

    UPDATE VTADETPTOENL A
       SET A.CODINSSRV =
           (SELECT DISTINCT B.CODINSSRV
              FROM VTADETPTOENL B
             WHERE A.NUMSLC = B.NUMSLC
               AND A.PAQUETE = B.PAQUETE
               AND B.CODINSSRV IS NOT NULL
               AND A.NUMPTO_PRIN = B.NUMPTO_PRIN
               AND B.NUMSLC = P_NUMSLC)
     WHERE A.NUMSLC = P_NUMSLC
       AND A.CODINSSRV IS NULL;
  EXCEPTION
    -- INI 3.0
    WHEN OTHERS THEN
      G_MSJ_ERR := 'ERROR AL EJECUTAR SP: ' || $$PLSQL_UNIT || '.' ||
                   'SP_ACTUALIZAR_GRUPO_CAMBIO, ' || CHR(13) ||
                   'MENSAJE DE ERROR: ' || TO_CHAR(SQLERRM); -- 3.0
      OPERACION.PQ_SIAC_CAMBIO_PLAN.P_INSERT_LOG_POST_SIAC(G_COD_ID,
                                                           G_CUSTOMERID,
                                                           G_PROCESO,
                                                           G_MSJ_ERR ||
                                                           CHR(13) ||
                                                           ' TRAZA DE ERROR:   ' ||
                                                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE); -- 3.0
      RAISE_APPLICATION_ERROR(-20000, G_MSJ_ERR); -- 3.0
  END;

  PROCEDURE SP_GENERAR_DES_CAMBIO(P_NUMREGISTRO REGVTAMENTAB.NUMREGISTRO%TYPE,
                                  P_NUMSLC      VTATABSLCFAC.NUMSLC%TYPE,
                                  P_PRECON_TYPE PRECON_TYPE) IS
    L_NUMSLC_OLD   VTATABSLCFAC.NUMSLC%TYPE;
    L_OBS          VTATABSLCFAC.OBSSOLFAC%TYPE;
    L_SOLUCION_OLD SOLUCIONES%ROWTYPE;
    L_SOLUCION_NEW SOLUCIONES%ROWTYPE;
    L_LINEA_OLD    VARCHAR2(50);
    L_LINEA_NEW    VARCHAR2(50);
    L_FAX_OLD      VARCHAR2(50);
    L_FAX_NEW      VARCHAR2(50);
    L_REC          NUMBER;
    L_OBS_LTE      VARCHAR2(200); --3.0
    L_OBS_CASO     VARCHAR2(50); --3.0

  BEGIN
    SELECT NUMSLC_ORI
      INTO L_NUMSLC_OLD
      FROM REGVTAMENTAB
     WHERE NUMREGISTRO = P_NUMREGISTRO;

    SELECT DISTINCT LOWER((SELECT SOLUCION
                            FROM SOLUCIONES
                           WHERE IDSOLUCION = A.IDSOLUCION))
      INTO L_SOLUCION_NEW.SOLUCION
      FROM VTATABSLCFAC A, VTADETPTOENL B
     WHERE A.NUMSLC = B.NUMSLC
       AND A.NUMSLC = P_NUMSLC;

    SELECT DISTINCT LOWER((SELECT SOLUCION
                            FROM SOLUCIONES
                           WHERE IDSOLUCION = A.IDSOLUCION))
      INTO L_SOLUCION_OLD.SOLUCION
      FROM VTATABSLCFAC A, VTADETPTOENL B
     WHERE A.NUMSLC = B.NUMSLC
       AND A.NUMSLC = L_NUMSLC_OLD;

    SELECT ' con ' || NVL(SUM(A.CANTIDAD), 0) || ' lineas'
      INTO L_LINEA_NEW
      FROM VTADETPTOENL A, PRODUCTO B
     WHERE A.IDPRODUCTO = B.IDPRODUCTO
       AND B.IDTIPINSTSERV = 3
       AND A.NUMSLC = P_NUMSLC
       AND A.IDPRODUCTO <> 702;

    SELECT ' con ' || NVL(SUM(A.CANTIDAD), 0) || ' lineas'
      INTO L_LINEA_OLD
      FROM VTADETPTOENL A, PRODUCTO B
     WHERE A.IDPRODUCTO = B.IDPRODUCTO
       AND B.IDTIPINSTSERV = 3
       AND A.NUMSLC = L_NUMSLC_OLD
       AND A.IDPRODUCTO <> 702;

    SELECT ' y ' || NVL(SUM(A.CANTIDAD), 0) || ' fax server'
      INTO L_FAX_NEW
      FROM VTADETPTOENL A
     WHERE A.NUMSLC = P_NUMSLC
       AND IDPRODUCTO = 702;

    SELECT ' y ' || NVL(SUM(A.CANTIDAD), 0) || ' fax server'
      INTO L_FAX_OLD
      FROM VTADETPTOENL A
     WHERE A.NUMSLC = L_NUMSLC_OLD
       AND IDPRODUCTO = 702;

    BEGIN
      SELECT DECODE(FLG_TIPO_VM,
                    'TE',
                    'Traslado Externo',
                    'TER',
                    'Traslado Externo',
                    'TI',
                    'Traslado Interno',
                    'TIR',
                    'Traslado Interno',
                    'SC',
                    'Servicios Complementarios',
                    NULL)
        INTO L_OBS
        FROM REGDETSRVMEN
       WHERE NUMREGISTRO = P_NUMREGISTRO;

    EXCEPTION
      WHEN OTHERS THEN
        L_OBS := '';
    END;

    IF L_OBS IS NULL THEN
      SELECT COUNT(*)
        INTO L_REC
        FROM INSTANCIA_PAQUETE_CAMBIO
       WHERE NUMREGISTRO = P_NUMREGISTRO
         AND FLG_TIPO_VM = 'CR';

      IF L_REC > 0 THEN
        L_OBS := 'Cambio de Recaudacion';
      ELSE
        SELECT DECODE(COUNT(*), 1, 'Migracion', 'Cambio de Plan LTE')
          INTO L_OBS
          FROM REGVTAMENTAB
         WHERE NUMREGISTRO = P_NUMREGISTRO
           AND TIPSRV <> TIPSRV_DES;
      END IF;

      -- INI 3.0
      SELECT 'NUMERO DE CASO ' ||
             DECODE(TO_CHAR(RECLAMO_CASO), NULL, '0', TO_CHAR(RECLAMO_CASO))
        INTO L_OBS_CASO
        FROM OPERACION.SIAC_POSTVENTA_PROCESO
       WHERE idprocess = G_IDPROCESS;

      L_OBS_LTE := 'INTERFAZ SIAC UNICO' || ' - ' || L_OBS_CASO;
      -- FIN 3.0

      L_OBS := L_OBS_LTE || CHR(13) || CHR(10) || 'Tipo de Venta: ' ||
               L_OBS || CHR(13) || CHR(10) || 'De: ' || -- 3.0
               L_SOLUCION_OLD.SOLUCION || L_LINEA_OLD || L_FAX_OLD ||
               CHR(13) || CHR(10) || 'A: ';
      L_OBS := L_OBS || L_SOLUCION_NEW.SOLUCION || L_LINEA_NEW || L_FAX_NEW;
      L_OBS := P_PRECON_TYPE.OBSAPROFE || ' - ' || L_OBS;

      UPDATE VTATABSLCFAC SET OBSSOLFAC = L_OBS WHERE NUMSLC = P_NUMSLC;

      UPDATE REGVTAMENTAB
         SET NUMSLC = P_NUMSLC, OBSSOLFAC = L_OBS
       WHERE NUMREGISTRO = P_NUMREGISTRO;
    ELSE
      L_OBS := 'Tipo de Venta: ' || L_OBS;
      L_OBS := P_PRECON_TYPE.OBSAPROFE || ' - ' || L_OBS;
      DBMS_OUTPUT.PUT_LINE(L_OBS);
    END IF;
  EXCEPTION
    -- INI 3.0
    WHEN OTHERS THEN
      G_MSJ_ERR := 'ERROR AL EJECUTAR SP: ' || $$PLSQL_UNIT || '.' ||
                   'SP_GENERAR_DES_CAMBIO, ' || CHR(13) ||
                   'MENSAJE DE ERROR: ' || TO_CHAR(SQLERRM); -- 3.0
      OPERACION.PQ_SIAC_CAMBIO_PLAN.P_INSERT_LOG_POST_SIAC(G_COD_ID,
                                                           G_CUSTOMERID,
                                                           G_PROCESO,
                                                           G_MSJ_ERR ||
                                                           CHR(13) ||
                                                           ' TRAZA DE ERROR:   ' ||
                                                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE); -- 3.0
      RAISE_APPLICATION_ERROR(-20000, G_MSJ_ERR); -- 3.0
  END;

  PROCEDURE SP_UPDATE_NUMSLC_NEW IS
  BEGIN
    UPDATE REGVTAMENTAB
       SET NUMSLC = G_NUMSLC_NEW
     WHERE NUMREGISTRO = G_NUMREGISTRO;

    UPDATE INSTANCIA_PAQUETE_CAMBIO
       SET NUMSLC = G_NUMSLC_NEW
     WHERE NUMREGISTRO = G_NUMREGISTRO;

    UPDATE REGDETPTOENLCAMBIO
       SET NUMSLC = G_NUMSLC_NEW
     WHERE NUMREGISTRO = G_NUMREGISTRO;
  END;

  PROCEDURE SP_LOAD_INSTANCIA_CAMBIO(P_NUMSLC VTATABSLCFAC.NUMSLC%TYPE) IS
    L_IDPAQ  NUMBER;
    L_CNT    NUMBER;
    L_INSPAQ INSTANCIA_PAQUETE%ROWTYPE;

    CURSOR CUR_PAQ IS
      SELECT * FROM INSTANCIA_PAQUETE_CAMBIO I WHERE I.NUMSLC = P_NUMSLC;

  BEGIN
    FOR C_PAQ IN CUR_PAQ LOOP
      L_INSPAQ.IDINSXPAQ      := C_PAQ.IDINSXPAQ;
      L_INSPAQ.NUMSLC         := C_PAQ.NUMSLC;
      L_INSPAQ.IDPAQ          := C_PAQ.IDPAQ;
      L_INSPAQ.IDPRODUCTO     := C_PAQ.IDPRODUCTO;
      L_INSPAQ.FLGOBLIGATORIO := C_PAQ.FLGOBLIGATORIO;
      L_INSPAQ.FLGPRINCIPAL   := C_PAQ.FLGPRINCIPAL;
      L_INSPAQ.CANTIDAD       := C_PAQ.CANTIDAD;
      L_INSPAQ.PAQUETE        := C_PAQ.PAQUETE;
      L_INSPAQ.NUMERO         := C_PAQ.NUMERO;
      L_INSPAQ.DESCRIPCION    := C_PAQ.DESCRIPCION;
      L_INSPAQ.CODINSSRV      := C_PAQ.CODINSSRV;
      L_INSPAQ.CODSRV         := C_PAQ.CODSRV;
      L_INSPAQ.DSCSRV         := C_PAQ.DSCSRV;
      L_INSPAQ.ESTCSE         := C_PAQ.ESTCSE;
      L_INSPAQ.PRELIS_INS     := C_PAQ.PRELIS_INS;
      L_INSPAQ.DESC_INS       := C_PAQ.DESC_INS;
      L_INSPAQ.PORCIMP_INS    := C_PAQ.PORCIMP_INS;
      L_INSPAQ.MONTO_INS      := C_PAQ.MONTO_INS;
      L_INSPAQ.MONTO_INS_IMP  := C_PAQ.MONTO_INS_IMP;
      L_INSPAQ.ESTCTS         := C_PAQ.ESTCTS;
      L_INSPAQ.PRELIS_SRV     := C_PAQ.PRELIS_SRV;
      L_INSPAQ.DESC_SRV       := C_PAQ.DESC_SRV;
      L_INSPAQ.PORCIMP_SRV    := C_PAQ.PORCIMP_SRV;
      L_INSPAQ.MONTO_SRV      := C_PAQ.MONTO_SRV;
      L_INSPAQ.MONTO_SRV_IMP  := C_PAQ.MONTO_SRV_IMP;
      L_INSPAQ.CODSUC         := C_PAQ.CODSUC;
      L_INSPAQ.DESCPTO        := C_PAQ.DESCPTO;
      L_INSPAQ.DIRPTO         := C_PAQ.DIRPTO;
      L_INSPAQ.NOMDST         := C_PAQ.NOMDST;
      L_INSPAQ.UBIPTO         := C_PAQ.UBIPTO;
      L_INSPAQ.OBSERVACION    := C_PAQ.OBSERVACION;
      L_INSPAQ.CODEQUCOM      := C_PAQ.CODEQUCOM;
      L_INSPAQ.IDPRECIO       := C_PAQ.IDPRECIO;
      L_INSPAQ.PREUNI_INS     := C_PAQ.PREUNI_INS;
      L_INSPAQ.PREUNI_SRV     := C_PAQ.PREUNI_SRV;
      L_INSPAQ.NRO_SERV       := C_PAQ.NRO_SERV;
      L_INSPAQ.MONEDA_ID      := C_PAQ.MONEDA_ID;
      L_INSPAQ.DSCEQU         := C_PAQ.DSCEQU;
      L_INSPAQ.BANWID         := C_PAQ.BANWID;
      L_INSPAQ.IDTIPO_PTO     := C_PAQ.IDTIPO_PTO;
      L_INSPAQ.IDSITE         := C_PAQ.IDSITE;
      L_INSPAQ.IDDET          := C_PAQ.IDDET;
      L_INSPAQ.NUMPTO         := C_PAQ.NUMPTO;
      --DEFAULT
      L_INSPAQ.FECUSU     := SYSDATE;
      L_INSPAQ.CODUSU     := USER;
      L_INSPAQ.FLGCONTROL := 0;

      INSERT INTO INSTANCIA_PAQUETE VALUES L_INSPAQ;
    END LOOP;

    SELECT IDPAQ
      INTO L_IDPAQ
      FROM VTADETPTOENL
     WHERE NUMSLC = P_NUMSLC
       AND ROWNUM = 1;

    SELECT COUNT(*)
      INTO L_CNT
      FROM INSTANCIA_PAQUETE_CAMBIO
     WHERE FLG_TIPO_VM = 'CR'
       AND NUMSLC = P_NUMSLC;

    IF L_CNT = 0 THEN
      UPDATE VTATABSLCFAC
         SET IDSOLUCION =
             (SELECT IDSOLUCION FROM PAQUETE_VENTA WHERE IDPAQ = L_IDPAQ)
       WHERE NUMSLC = P_NUMSLC;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      G_MSJ_ERR := 'ERROR AL EJECUTAR SP: ' || $$PLSQL_UNIT || '.' ||
                   'SP_LOAD_INSTANCIA_CAMBIO, ' || CHR(13) ||
                   'MENSAJE DE ERROR: ' || TO_CHAR(SQLERRM); -- 3.0
      OPERACION.PQ_SIAC_CAMBIO_PLAN.P_INSERT_LOG_POST_SIAC(G_COD_ID,
                                                           G_CUSTOMERID,
                                                           G_PROCESO,
                                                           G_MSJ_ERR ||
                                                           CHR(13) ||
                                                           ' TRAZA DE ERROR:   ' ||
                                                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE); -- 3.0
      RAISE_APPLICATION_ERROR(-20000, G_MSJ_ERR); -- 3.0
  END;

  PROCEDURE SP_CREATE_VTATABPRECON(P_NUMSLC VTATABSLCFAC.NUMSLC%TYPE,
                                   P_PRECON PRECON_TYPE) IS
    -- ini 2.0
    L_PRECON          VTATABPRECON%ROWTYPE;
    C_PERU            VTATABPRECON.CODPAI%TYPE;
    C_CANALES_AGENTES VTATABMOTIVO_VENTA.CODMOTIVO%TYPE;
    C_CAMBIO_DE_PLAN  VTATABMOTIVO_VENTA.CODMOTIVO%TYPE;
    C_BCP             VTATABPRECON.CODBAN%TYPE;
    C_GRABACION       VTATIPDOCOFE.TIPDOC%TYPE;
    -- fin 2.0
  BEGIN

    -- ini 2.0
    SELECT VALOR
      INTO C_PERU
      FROM CONSTANTE
     WHERE CONSTANTE = 'CONF_PAIS_LTE';
    SELECT VALOR
      INTO C_CANALES_AGENTES
      FROM CONSTANTE
     WHERE CONSTANTE = 'CONF_LV_LTE';
    SELECT VALOR
      INTO C_CAMBIO_DE_PLAN
      FROM CONSTANTE
     WHERE CONSTANTE = 'CONF_TC_LTE';
    SELECT VALOR
      INTO C_BCP
      FROM CONSTANTE
     WHERE CONSTANTE = 'CONF_CODBAN_LTE';
    SELECT VALOR
      INTO C_GRABACION
      FROM CONSTANTE
     WHERE CONSTANTE = 'CONF_TIPDOC_LTE';
    -- fin 2.0

    L_PRECON.NUMSLC            := P_NUMSLC;
    L_PRECON.NRODOC            := P_NUMSLC;
    L_PRECON.TIPDOC            := C_GRABACION;
    L_PRECON.FECACE            := SYSDATE;
    L_PRECON.FECREC            := SYSDATE;
    L_PRECON.FECAPLCOM         := SYSDATE;
    L_PRECON.CODMODELO         := 0;
    L_PRECON.CODPAI            := C_PERU;
    L_PRECON.FLAG_FACTXSEGUNDO := 0;
    L_PRECON.FLAG_FACTXMINUTO  := 1;
    L_PRECON.CODSUCFAC         := '';
    L_PRECON.CODMOTIVO         := 1;
    L_PRECON.CODCLI            := FNC_GET_CODCLI();
    L_PRECON.CODMOTIVO_LV      := C_CANALES_AGENTES;
    L_PRECON.CODMOTIVO_TC      := C_CAMBIO_DE_PLAN;
    L_PRECON.CODBAN            := C_BCP;
    L_PRECON.OBSAPROFE         := P_PRECON.OBSAPROFE;
    L_PRECON.CARTA             := P_PRECON.CARTA;
    L_PRECON.CARRIER           := P_PRECON.CARRIER;
    L_PRECON.PRESUSC           := P_PRECON.PRESUSC;
    L_PRECON.PUBLICAR          := P_PRECON.PUBLICAR;
    --DEFAULT
    L_PRECON.CODUSU      := USER;
    L_PRECON.FECUSU      := SYSDATE;
    L_PRECON.FECCODEMAIL := SYSDATE;
    L_PRECON.FLG_PRESUSC := 0;

    INSERT INTO VTATABPRECON VALUES L_PRECON;
  EXCEPTION
    WHEN OTHERS THEN
      G_MSJ_ERR := 'ERROR AL EJECUTAR SP: ' || $$PLSQL_UNIT || '.' ||
                   'SP_CREATE_VTATABPRECON, ' || CHR(13) ||
                   'MENSAJE DE ERROR: ' || TO_CHAR(SQLERRM); -- 3.0
      OPERACION.PQ_SIAC_CAMBIO_PLAN.P_INSERT_LOG_POST_SIAC(G_COD_ID,
                                                           G_CUSTOMERID,
                                                           G_PROCESO,
                                                           G_MSJ_ERR ||
                                                           CHR(13) ||
                                                           ' TRAZA DE ERROR:   ' ||
                                                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE); -- 3.0
      RAISE_APPLICATION_ERROR(-20000, G_MSJ_ERR); -- 3.0
  END;

  PROCEDURE SP_VALIDAR_TIPOSOLUCION(P_PARAMETRO VARCHAR2) IS
    L_VALIDA    NUMBER;
    L_RESULTADO NUMBER;

    CURSOR C_VALIDA IS
      SELECT IDTIPOSOLUCION FROM TIPOSOLUCION WHERE ESTADO = 1;

  BEGIN
    L_VALIDA := 0;

    FOR VAL IN C_VALIDA LOOP
      -- BUSCAMOS TIPO DE SOLUCION - MATRIZ
      L_VALIDA := PQ_PROYECTO.F_VALIDAR_TIPOSMATRIZ(VAL.IDTIPOSOLUCION,
                                                    TRIM(P_PARAMETRO));

      IF L_VALIDA > 0 THEN
        L_RESULTADO := VAL.IDTIPOSOLUCION;

        -- ACTUALIZAMOS TIPO SOLUCION
        UPDATE VTATABSLCFAC
           SET IDTIPOSOLUCION = L_RESULTADO
         WHERE NUMSLC = TRIM(P_PARAMETRO);
      END IF;

    END LOOP;
  END;

  PROCEDURE SP_INSERT_SERVICIOS(P_SERVICIOS SERVICIOS_TYPE,
                                P_IDLINEA   OUT IDLINEAS_TYPE) IS
    L_CODSRV            SALES.TYSTABSRV.CODSRV%TYPE;
    L_SERVICIO          SALES.PQ_SERVICIO_SISACT_CP_LTE.SERVICIO_TYPE;
    L_COMODATO          SALES.PQ_COMODATO_SISACT_CP_LTE.COMODATO_TYPE;
    L_IDLINEA_GENERADO  SALES.LINEA_PAQUETE.IDLINEA%TYPE;
    L_SERVICIO_GENERADO SALES.TYSTABSRV.CODSRV%TYPE;

  BEGIN
    FOR IDX IN P_SERVICIOS.FIRST .. P_SERVICIOS.LAST LOOP

      IF FNC_SERVICIO_PRINCIPAL(P_SERVICIOS(IDX).IDGRUPO) OR
         FNC_SERVICIO_ADICIONAL(P_SERVICIOS(IDX).IDGRUPO) THEN

        L_SERVICIO.SERVICIO          := P_SERVICIOS(IDX).SERVICIO;
        L_SERVICIO.DSCSRV            := P_SERVICIOS(IDX).DSCSRV;
        L_SERVICIO.BANDWID           := P_SERVICIOS(IDX).BANDWID;
        L_SERVICIO.IDGRUPO           := P_SERVICIOS(IDX).IDGRUPO;
        L_SERVICIO.IDGRUPO_PRINCIPAL := P_SERVICIOS(IDX).IDGRUPO_PRINCIPAL;
        L_SERVICIO.FLAG_LC           := P_SERVICIOS(IDX).FLAG_LC;
        L_SERVICIO.CODIGO_EXT        := P_SERVICIOS(IDX).CODIGO_EXT;
        SALES.PQ_SERVICIO_SISACT_CP_LTE.CREATE_SERVICIO(L_SERVICIO,
                                                        L_IDLINEA_GENERADO,
                                                        L_SERVICIO_GENERADO);
        P_IDLINEA(IDX).IDLINEA := L_IDLINEA_GENERADO;
        P_IDLINEA(IDX).IDDET := FNC_GET_IDDET_SGA(L_IDLINEA_GENERADO);
        P_IDLINEA(IDX).SERVICIO_SGA := L_SERVICIO_GENERADO;
        P_IDLINEA(IDX).CANTIDAD_INSTANCIA := P_SERVICIOS(IDX)
                                             .CANTIDAD_INSTANCIA;
        P_IDLINEA(IDX).CANTIDAD := P_SERVICIOS(IDX).CANTIDAD;

      END IF;

      IF FNC_SERVICIO_COMODATO(P_SERVICIOS(IDX).IDGRUPO,
                               P_SERVICIOS(IDX).IDGRUPO_PRINCIPAL) OR
         FNC_SERVICIO_ALQUILER(P_SERVICIOS(IDX).IDGRUPO,
                               P_SERVICIOS(IDX).IDGRUPO_PRINCIPAL) THEN

        L_CODSRV := FNC_GET_CODSRV_COMODATO(P_SERVICIOS(IDX).IDGRUPO);
        L_COMODATO.IDGRUPO := P_SERVICIOS(IDX).IDGRUPO;
        L_COMODATO.IDGRUPO_PRINCIPAL := P_SERVICIOS(IDX).IDGRUPO_PRINCIPAL;
        L_COMODATO.CODTIPEQU := P_SERVICIOS(IDX).CODTIPEQU;
        L_COMODATO.TIPEQU := P_SERVICIOS(IDX).TIPEQU;
        L_COMODATO.DSCEQU := P_SERVICIOS(IDX).DSCEQU;

        --QUITAR
        OPERACION.PQ_SIAC_CAMBIO_PLAN.P_INSERT_LOG_POST_SIAC(G_COD_ID,
                                                           G_CUSTOMERID,
                                                           G_PROCESO,
                                                           'L_CODSRV: '||L_CODSRV ||
                                                           ' - L_COMODATO.IDGRUPO: '||L_COMODATO.IDGRUPO ||
                                                           'L_COMODATO.IDGRUPO_PRINCIPAL: '||L_COMODATO.IDGRUPO_PRINCIPAL
                                                           ||' - L_COMODATO.CODTIPEQU: '||L_COMODATO.CODTIPEQU||
                                                           ' - L_COMODATO.TIPEQU: '|| L_COMODATO.TIPEQU||
                                                           ' - L_COMODATO.DSCEQU: '||L_COMODATO.DSCEQU);

        L_IDLINEA_GENERADO := SALES.PQ_COMODATO_SISACT_CP_LTE.CONFIGURE_COMODATO(L_COMODATO);
        P_IDLINEA(IDX).IDLINEA := L_IDLINEA_GENERADO;
        P_IDLINEA(IDX).IDDET := FNC_GET_IDDET_SGA(L_IDLINEA_GENERADO);
        P_IDLINEA(IDX).SERVICIO_SGA := L_CODSRV;
        P_IDLINEA(IDX).CANTIDAD_INSTANCIA := P_SERVICIOS(IDX)
                                             .CANTIDAD_INSTANCIA;
        P_IDLINEA(IDX).CODTIPEQU := P_SERVICIOS(IDX).CODTIPEQU;
        P_IDLINEA(IDX).CANTIDAD := P_SERVICIOS(IDX).CANTIDAD;

      END IF;

    END LOOP;
  EXCEPTION
    -- INI 3.0
    WHEN OTHERS THEN
      G_MSJ_ERR := 'ERROR AL EJECUTAR SP: ' || $$PLSQL_UNIT || '.' ||
                   'SP_INSERT_SERVICIOS, ' || CHR(13) ||
                   'MENSAJE DE ERROR: ' || TO_CHAR(SQLERRM); -- 3.0
      OPERACION.PQ_SIAC_CAMBIO_PLAN.P_INSERT_LOG_POST_SIAC(G_COD_ID,
                                                           G_CUSTOMERID,
                                                           G_PROCESO,
                                                           G_MSJ_ERR ||
                                                           CHR(13) ||
                                                           ' TRAZA DE ERROR:   ' ||
                                                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE); -- 3.0
      RAISE_APPLICATION_ERROR(-20000, G_MSJ_ERR); -- 3.0
  END;

  PROCEDURE ACTUALIZA_CO_ID(G_NUMSLC_NEW VTATABSLCFAC.NUMSLC%TYPE,
                            P_COD_ID     INSSRV.CO_ID%TYPE) IS

  BEGIN
    UPDATE INSSRV SET CO_ID = P_COD_ID WHERE NUMSLC = G_NUMSLC_NEW;
  END;

  PROCEDURE SP_ASIGNAR_PLATAFORMA(P_NUMSLC  VTATABSLCFAC.NUMSLC%TYPE,
                                  P_RETORNA OUT NUMBER,
                                  P_TEXTO   OUT VARCHAR2) IS
    L_IDCAMPANHA   VTATABSLCFAC.IDCAMPANHA%TYPE;
    L_IDSOLUCION   VTATABSLCFAC.IDSOLUCION%TYPE;
    L_IDPLATAFORMA TYS_PLATAFORMASICORP_DET.IDPLATAFORMA%TYPE;

    CURSOR C_PTOENL IS
      SELECT * FROM VTADETPTOENL V WHERE V.NUMSLC = P_NUMSLC;

    CURSOR C_PTOENL_PRI IS
      SELECT *
        FROM VTADETPTOENL V
       WHERE V.NUMSLC = P_NUMSLC
         AND V.FLGSRV_PRI = 1;

  BEGIN
    BEGIN
      SELECT V.IDCAMPANHA, V.IDSOLUCION
        INTO L_IDCAMPANHA, L_IDSOLUCION
        FROM VTATABSLCFAC V
       WHERE V.NUMSLC = P_NUMSLC;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
        P_RETORNA := 3;
        P_TEXTO   := 'No existe proyecto (numslc): ' || TO_CHAR(P_NUMSLC) || ' ' ||
                     SQLERRM;
        G_MSJ_ERR := 'ERROR AL EJECUTAR SP: ' || $$PLSQL_UNIT || '.' ||
                     'SP_ASIGNAR_PLATAFORMA, ' || CHR(13) ||
                     'MENSAJE DE ERROR: ' || TO_CHAR(P_TEXTO); -- 3.0
        OPERACION.PQ_SIAC_CAMBIO_PLAN.P_INSERT_LOG_POST_SIAC(G_COD_ID,
                                                             G_CUSTOMERID,
                                                             G_PROCESO,
                                                             G_MSJ_ERR ||
                                                             CHR(13) ||
                                                             ' TRAZA DE ERROR:   ' ||
                                                             DBMS_UTILITY.FORMAT_ERROR_BACKTRACE); -- 3.0
    END;

    FOR R_PTOENL IN C_PTOENL LOOP
      L_IDPLATAFORMA := NULL;
      BEGIN
        SELECT IDPLATAFORMA
          INTO L_IDPLATAFORMA
          FROM TYS_MATRIZPLATAFORMA_MAE VP
         WHERE NVL(VP.IDSOLUCION, 0) = NVL(L_IDSOLUCION, 0)
           AND NVL(VP.IDCAMPANHA, 0) = NVL(L_IDCAMPANHA, 0)
           AND NVL(VP.IDPRODUCTO, 0) = NVL(R_PTOENL.IDPRODUCTO, 0);
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;

      BEGIN
        UPDATE VTADETPTOENL V
           SET V.IDPLATAFORMA = L_IDPLATAFORMA
         WHERE V.NUMSLC = P_NUMSLC
           AND V.NUMPTO = R_PTOENL.NUMPTO;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
          P_RETORNA := 3;
          P_TEXTO   := 'No se puede actualizar Medio de Acceso' || P_NUMSLC || ' ' ||
                       R_PTOENL.NUMPTO || ' ' || L_IDPLATAFORMA || ' ' ||
                       SQLERRM;
          G_MSJ_ERR := 'ERROR AL EJECUTAR SP: ' || $$PLSQL_UNIT || '.' ||
                       'SP_ASIGNAR_PLATAFORMA, ' || CHR(13) ||
                       'MENSAJE DE ERROR: ' || TO_CHAR(P_TEXTO); -- 3.0
          OPERACION.PQ_SIAC_CAMBIO_PLAN.P_INSERT_LOG_POST_SIAC(G_COD_ID,
                                                               G_CUSTOMERID,
                                                               G_PROCESO,
                                                               G_MSJ_ERR ||
                                                               CHR(13) ||
                                                               ' TRAZA DE ERROR:   ' ||
                                                               DBMS_UTILITY.FORMAT_ERROR_BACKTRACE); -- 3.0
      END;
    END LOOP;

    FOR R_PTOENL_PRI IN C_PTOENL_PRI LOOP
      BEGIN
        UPDATE VTADETPTOENL V
           SET V.IDPLATAFORMA = R_PTOENL_PRI.IDPLATAFORMA
         WHERE V.NUMSLC = P_NUMSLC
           AND V.NUMPTO_PRIN = R_PTOENL_PRI.NUMPTO_PRIN
           AND V.IDPLATAFORMA IS NULL;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
          P_RETORNA := 3;
          P_TEXTO   := 'No se puede actualizar Medio de Acceso' || P_NUMSLC || ' ' ||
                       R_PTOENL_PRI.NUMPTO || ' ' ||
                       R_PTOENL_PRI.IDPLATAFORMA || ' ' || SQLERRM;
          G_MSJ_ERR := 'ERROR AL EJECUTAR SP: ' || $$PLSQL_UNIT || '.' ||
                       'SP_ASIGNAR_PLATAFORMA, ' || CHR(13) ||
                       'MENSAJE DE ERROR: ' || TO_CHAR(P_TEXTO); -- 3.0
          OPERACION.PQ_SIAC_CAMBIO_PLAN.P_INSERT_LOG_POST_SIAC(G_COD_ID,
                                                               G_CUSTOMERID,
                                                               G_PROCESO,
                                                               G_MSJ_ERR ||
                                                               CHR(13) ||
                                                               ' TRAZA DE ERROR:   ' ||
                                                               DBMS_UTILITY.FORMAT_ERROR_BACKTRACE); -- 3.0
      END;
    END LOOP;
  END;

  /*FUNCTION FNC_VALIDAR_CHECKPROY(P_NUMSLC VTATABSLCFAC.NUMSLC%TYPE)
    RETURN VARCHAR2 IS
    L_CUENTA         NUMBER;
    L_CONTA          NUMBER;
    L_VALIDA         NUMBER;
    L_TOTAL          NUMBER;
    L_PROY_TPI       NUMBER;
    L_PROY_PYM       NUMBER;
    L_CAMP_PYM       NUMBER;
    L_PROY_BOD       NUMBER;
    L_CAMP_BOD       NUMBER;
    L_BUSCA          NUMBER;
    L_MENSAJE        VARCHAR2(100);
    L_PROY_VENTA_EQU NUMBER;

  BEGIN
    -- BUSCAMOS EL PROYECTO PYMES
    SELECT F_VERIFICA_PROYECTO_PYMES(P_NUMSLC) INTO L_PROY_PYM FROM DUAL;

    -- BUSCAMOS SI EL PROYECTO ES TPI
    SELECT F_VERIFICA_PROYECTO_TPI(P_NUMSLC) INTO L_PROY_TPI FROM DUAL;

    -- VERIFICA SI EL PROYECTO ES BOD
    SELECT F_VERIFICA_PROYECTO_BOD(P_NUMSLC) INTO L_PROY_BOD FROM DUAL;

    -- VERIFICA SI LA CAMPANHA ES BOD
    SELECT F_VERIFICA_CAMPANHA_BOD(P_NUMSLC) INTO L_CAMP_BOD FROM DUAL;

    -- VERIFICA SI EL PROYECTO TIENE LOS CAMPOS COMPLETOS
    SELECT F_VTAEVALUA_DATOSCOMPLETOS(P_NUMSLC) INTO L_CUENTA FROM DUAL;

    -- VERIFICA EL PROYECTO VENTA DE EQUIPOS
    SELECT F_VERIFICA_PROYECTO_VE(P_NUMSLC)
      INTO L_PROY_VENTA_EQU
      FROM DUAL;

    IF L_CUENTA = 0 THEN
      -- VALIDAMOS PRODUCTOS SLA
      SELECT FNC_VALIDAR_PRODUCTO_SLA(P_NUMSLC) INTO L_VALIDA FROM DUAL;

      IF L_VALIDA <> 0 THEN
        IF L_VALIDA = 1 THEN
          G_MSJ_ERR := 'ERROR AL EJECUTAR FNC: ' || $$PLSQL_UNIT || '.'  || 'FNC_VALIDAR_CHECKPROY, ' || CHR(13) ||
                       'MENSAJE DE ERROR: '      || 'NO SE ENCUENTRA EL DOCUMENTO ASOCIADO AL PRODUCTO SLA'; -- 3.O
          OPERACION.PQ_SIAC_CAMBIO_PLAN.P_INSERT_LOG_POST_SIAC(G_COD_ID,
                                                               G_CUSTOMERID,
                                                               G_PROCESO,
                                                               G_MSJ_ERR || CHR(13) || ' TRAZA DE ERROR:   '|| DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ); -- 3.0
          RETURN('No se encuentra el documento asociado al producto SLA');
        ELSIF L_VALIDA = 2 THEN
          G_MSJ_ERR := 'ERROR AL EJECUTAR FNC: ' || $$PLSQL_UNIT || '.'  || 'FNC_VALIDAR_CHECKPROY, ' || CHR(13) ||
                       'MENSAJE DE ERROR: '      || 'EXISTE MAS DE UN DOCUMENTO ASOCIADO AL PRODUCTO SLA';   -- 3.0
          OPERACION.PQ_SIAC_CAMBIO_PLAN.P_INSERT_LOG_POST_SIAC(G_COD_ID,
                                                               G_CUSTOMERID,
                                                               G_PROCESO,
                                                               G_MSJ_ERR || CHR(13) || ' TRAZA DE ERROR:   '|| DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ); -- 3.0
          RETURN('Existe mas de un documento asociado al producto SLA');
        END IF;
      ELSE
        -- BUSCAMOS LA CAMPANHA PYMES
        SELECT F_VERIFICA_CAMPANHA_PYMES(P_NUMSLC)
          INTO L_CAMP_PYM
          FROM DUAL;

        IF (L_PROY_PYM = 1 AND L_CAMP_PYM = 1) OR L_PROY_VENTA_EQU = 1 THEN
          -- BUSCAMOS EL PRODUCTO
          SELECT COUNT(A.NUMSLC)
            INTO L_CONTA
            FROM VTADETPTOENL A,
                 PRODUCTO B
           WHERE A.NUMSLC          = P_NUMSLC
             AND A.IDPRODUCTO      = B.IDPRODUCTO
             AND A.CREPTO          = '1'
             AND B.IDGRUPOPRODUCTO IS NULL
             AND A.IDPRODUCTO      = 524;

          IF L_CONTA > 0 THEN
            -- BUSCAMOS SI TIENE SERVICIO DE EMAIL
            SELECT COUNT(A.NUMSLC)
              INTO L_TOTAL
              FROM VTADETNUMPTO A,
                   VTADETPTOENL B
             WHERE A.NUMSLC     = B.NUMSLC
               AND A.NUMPTO     = B.NUMPTO
               AND B.IDPRODUCTO = 524
               AND A.NUMSLC     = P_NUMSLC;
            L_TOTAL := 1;

            IF L_TOTAL = 0 THEN
              G_MSJ_ERR := 'ERROR AL EJECUTAR FNC: ' || $$PLSQL_UNIT || '.'  || 'FNC_VALIDAR_CHECKPROY, ' || CHR(13) ||
                           'MENSAJE DE ERROR: '      || 'NO SE HA GENERADO EMAILS PARA EL PAQUETE X-PLOR@';       -- 3.0
              OPERACION.PQ_SIAC_CAMBIO_PLAN.P_INSERT_LOG_POST_SIAC(G_COD_ID,
                                                                   G_CUSTOMERID,
                                                                   G_PROCESO,
                                                                   G_MSJ_ERR || CHR(13) || ' TRAZA DE ERROR:   '|| DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ); -- 3.0
              RETURN('No se ha generado emails para el paquete X-plor@');
            END IF;
          END IF;
        END IF;

        -- BUSCAMOS TIPO SOLUCION
        SELECT COUNT(A.NUMSLC)
          INTO L_BUSCA
          FROM VTATABSLCFAC A
         WHERE A.NUMSLC = P_NUMSLC
           AND A.IDTIPOSOLUCION IS NOT NULL;

        IF L_BUSCA = 0 THEN
          -- BUSCAMOS SI TIENE OFERTA COMERCIAL
          SELECT COUNT(NUMSLC)
            INTO L_BUSCA
            FROM VTATABPSPCLI
           WHERE NUMSLC = P_NUMSLC;

          IF L_BUSCA = 0 THEN
            G_MSJ_ERR := 'ERROR AL EJECUTAR FNC: ' || $$PLSQL_UNIT || '.'  || 'FNC_VALIDAR_CHECKPROY, ' || CHR(13) ||
                         'MENSAJE DE ERROR: '      || 'ERROR CONSULTAR LA TABLA VTATABPSPCLI, NO SE GENERO LA OFERTA COMERCIAL.'; -- 3.0
            OPERACION.PQ_SIAC_CAMBIO_PLAN.P_INSERT_LOG_POST_SIAC(G_COD_ID,
                                                                 G_CUSTOMERID,
                                                                 G_PROCESO,
                                                                 G_MSJ_ERR || CHR(13) || ' TRAZA DE ERROR:   '|| DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ); -- 3.0
            RETURN('No se ha generado Oferta Comercial');
          END IF;
        END IF;

        -- ACTUALIZAMOS FLAG ESTUDIO COMPLETO
        UPDATE VTATABSLCFAC SET FLGESTCOM = 1 WHERE NUMSLC = P_NUMSLC;
      END IF;
    ELSE
      -- BUSCAMOS MENSAJE
      BEGIN
        SELECT MENSAJE
          INTO L_MENSAJE
          FROM CONTROL_MENSAJE
         WHERE TIPO      = 'SEF'
           AND IDMENSAJE = L_CUENTA;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          G_MSJ_ERR := 'ERROR AL EJECUTAR FNC: ' || $$PLSQL_UNIT || '.'  || 'FNC_VALIDAR_CHECKPROY, ' || CHR(13) ||
                       'MENSAJE DE ERROR: '      || TO_CHAR(SQLERRM); -- 3.0
          OPERACION.PQ_SIAC_CAMBIO_PLAN.P_INSERT_LOG_POST_SIAC(G_COD_ID,
                                                               G_CUSTOMERID,
                                                               G_PROCESO,
                                                               G_MSJ_ERR || CHR(13) || ' TRAZA DE ERROR:   '|| DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ); -- 3.0
          RETURN('Verificar la tabla control_mensaje F_VTAEVALUA_DATOSCOMPLETOS');
      END;
      RETURN(L_MENSAJE);
    END IF;

    RETURN 'OK';
  END;*/

  FUNCTION FNC_VALIDAR_CHECKPROY(p_numslc vtatabslcfac.numslc%TYPE)
    RETURN VARCHAR2 IS
    l_cuenta         NUMBER;
    l_conta          NUMBER;
    l_valida         NUMBER;
    l_total          NUMBER;
    l_proy_tpi       NUMBER;
    l_proy_pym       NUMBER;
    l_camp_pym       NUMBER;
    l_proy_bod       NUMBER;
    l_camp_bod       NUMBER;
    l_busca          NUMBER;
    l_mensaje        VARCHAR2(100);
    l_proy_venta_equ NUMBER;

    lv_msgerror operacion.postventasiac_log.msgerror%type;

  BEGIN
    -- buscamos el proyecto pymes
    SELECT f_verifica_proyecto_pymes(p_numslc) INTO l_proy_pym FROM dual;

    -- buscamos si el proyecto es tpi
    SELECT f_verifica_proyecto_tpi(p_numslc) INTO l_proy_tpi FROM dual;

    -- verifica si el proyecto es bod
    SELECT f_verifica_proyecto_bod(p_numslc) INTO l_proy_bod FROM dual;

    -- verifica si la campanha es bod
    SELECT f_verifica_campanha_bod(p_numslc) INTO l_camp_bod FROM dual;

    -- verifica si el proyecto tiene los campos completos
    commit;
    SELECT f_vtaevalua_datoscompletos(p_numslc) INTO l_cuenta FROM dual;

    -- verifica el proyecto venta de equipos
    SELECT f_verifica_proyecto_ve(p_numslc)
      INTO l_proy_venta_equ
      FROM DUAL;

    IF l_cuenta = 0 THEN
      -- validamos productos sla
      SELECT FNC_VALIDAR_PRODUCTO_SLA(p_numslc) INTO l_valida FROM DUAL;

      IF l_valida <> 0 THEN
        IF l_valida = 1 THEN
          RETURN('No se encuentra el documento asociado al producto SLA');
        ELSIF l_valida = 2 THEN
          RETURN('Existe mas de un documento asociado al producto SLA');
        END IF;
      ELSE
        -- buscamos la campanha pymes
        SELECT f_verifica_campanha_pymes(p_numslc)
          INTO l_camp_pym
          FROM dual;

        IF (l_proy_pym = 1 AND l_camp_pym = 1) OR l_proy_venta_equ = 1 THEN
          -- buscamos el producto
          SELECT COUNT(a.numslc)
            INTO l_conta
            FROM vtadetptoenl a, producto b
           WHERE a.numslc = p_numslc
             AND a.idproducto = b.idproducto
             AND a.crepto = '1'
             AND b.idgrupoproducto IS NULL
             AND a.idproducto = 524;

          IF l_conta > 0 THEN
            -- buscamos si tiene servicio de email
            SELECT COUNT(a.numslc)
              INTO l_total
              FROM vtadetnumpto a, vtadetptoenl b
             WHERE a.numslc = b.numslc
               AND a.numpto = b.numpto
               AND b.idproducto = 524
               AND a.numslc = p_numslc;
            l_total := 1;

            IF l_total = 0 THEN
              RETURN('No se ha generado emails para el paquete X-plor@');
            END IF;
          END IF;
        END IF;

        -- buscamos tipo solucion
        SELECT COUNT(a.numslc)
          INTO l_busca
          FROM vtatabslcfac a
         WHERE a.numslc = p_numslc
           AND a.idtiposolucion IS NOT NULL;

        IF l_busca = 0 THEN
          -- buscamos si tiene oferta comercial
          SELECT COUNT(numslc)
            INTO l_busca
            FROM vtatabpspcli
           WHERE numslc = p_numslc;

          IF l_busca = 0 THEN
            RETURN('No se ha generado Oferta Comercial');
          END IF;
        END IF;

        -- actualizamos flag estudio completo
        UPDATE vtatabslcfac SET flgestcom = 1 WHERE numslc = p_numslc;
      END IF;
    ELSE
      -- buscamos mensaje
      BEGIN
        SELECT mensaje
          INTO l_mensaje
          FROM control_mensaje
         WHERE tipo = 'SEF'
           AND idmensaje = l_cuenta;
      EXCEPTION
        WHEN no_data_found THEN
          RETURN('Verificar la tabla control_mensaje F_VTAEVALUA_DATOSCOMPLETOS');
      END;
      RETURN(l_mensaje);
    END IF;

    RETURN 'OK';
    --ini 13.0
  EXCEPTION
    WHEN OTHERS THEN
      lv_msgerror := $$plsql_unit || '.' || 'VALIDAR_CHECKPROY: ' ||
                     sqlerrm || ' - Linea (' ||
                     dbms_utility.format_error_backtrace || ')';

      OPERACION.PQ_SIAC_CAMBIO_PLAN.p_insert_log_post_siac(g_cod_id,
                                                           0,
                                                           g_proceso,
                                                           lv_msgerror);
      RAISE_APPLICATION_ERROR(-20000,
                              $$plsql_unit || '.' ||
                              'OPERACION.PQ_SIAC_CAMBIO_PLAN.validar_checkproy: ' ||
                              sqlerrm);
      --Fin 13.0
  END;

  FUNCTION FNC_PROYECTO_PREVENTA(P_NUMSLC VTATABSLCFAC.NUMSLC%TYPE)
    RETURN NUMBER IS
    L_FLGESTCOM      NUMBER;
    L_APRUEBA        NUMBER;
    L_PROY_TPI       NUMBER;
    L_PROY_PYM       NUMBER;
    L_CAMP_PYM       NUMBER;
    L_ESTSOLFAC      CHAR(2);
    L_MENSAJE        VARCHAR2(100);
    L_IDFLUJO        NUMBER;
    L_TIPSRV         CHAR(4);
    L_RETORNA        NUMBER;
    L_TEXTO          VARCHAR2(1000);
    L_PROY_VENTA_EQU NUMBER;
    L_CANT           NUMBER;

  BEGIN
    -- BUSCAMOS LA CAMPANHA PYMES
    SELECT F_VERIFICA_CAMPANHA_PYMES(P_NUMSLC) INTO L_CAMP_PYM FROM DUAL;

    -- BUSCAMOS EL PROYECTO PYMES
    SELECT F_VERIFICA_PROYECTO_PYMES(P_NUMSLC) INTO L_PROY_PYM FROM DUAL;

    -- BUSCAMOS SI EL PROYECTO ES TPI
    SELECT F_VERIFICA_PROYECTO_TPI(P_NUMSLC) INTO L_PROY_TPI FROM DUAL;

    -- BUSCAMOS SI EL PROYECTO ES VENTA EQUIPOS
    SELECT F_VERIFICA_PROYECTO_VE(P_NUMSLC)
      INTO L_PROY_VENTA_EQU
      FROM DUAL;

    -- ASIGANACION DE PLATAFORMA DE ACCESO
    SP_ASIGNAR_PLATAFORMA(P_NUMSLC, L_RETORNA, L_TEXTO);

    -- BUSCAMOS LOS ESTADOS DEL PROYECTO
    SELECT ESTSOLFAC, FLGESTCOM, TIPSRV
      INTO L_ESTSOLFAC, L_FLGESTCOM, L_TIPSRV
      FROM VTATABSLCFAC
     WHERE NUMSLC = P_NUMSLC;

    IF L_ESTSOLFAC = '00' THEN
      L_APRUEBA := 1;
    END IF;

    IF L_PROY_PYM = 1 AND L_CAMP_PYM = 1 OR L_PROY_TPI = 1 OR
       L_PROY_VENTA_EQU = 1 THEN
      L_APRUEBA := 1;

      IF L_APRUEBA = 1 THEN
        -- BUSCAMOS TIPO DE FLUJO
        SELECT IDFLUJO
          INTO L_IDFLUJO
          FROM TIPOSOL_PLANTILLA A, VTAFLUJOESTADO B, VTATABSLCFAC C
         WHERE A.IDPLANTILLA = B.IDPLANTILLA
           AND A.IDTIPOSOLUCION = C.IDTIPOSOLUCION
           AND C.NUMSLC = P_NUMSLC
           AND B.TABEST = '00'
           AND B.CODEST_OLD = '00'
           AND B.CODEST_NEW = '01';

        SELECT COUNT(*)
          INTO L_CANT
          FROM VTADETPRMCOM
         WHERE NUMSLC = P_NUMSLC;

        -- EJECUTAMOS LOS FLUJOS DE ESTADO
        PQ_PROYECTO.P_EJECUTA_FLUJO_AUTOMATICO(P_NUMSLC, '01', L_IDFLUJO);

        SELECT COUNT(*)
          INTO L_CANT
          FROM VTADETPRMCOM
         WHERE NUMSLC = P_NUMSLC;
      END IF;

      -- ACTUALIZAMOS FLAG ESTUDIO COMPLETO
      UPDATE VTATABSLCFAC SET FLGESTCOM = 1 WHERE NUMSLC = P_NUMSLC;

      G_CODSOLOT := FNC_GET_CODSOLOT();
      SP_SET_INSTANCE('SOT', G_CODSOLOT);

      RETURN 1;
    ELSE
      BEGIN
        -- EJECUTAMOS EL AUTOPRUEBA
        PQ_AUTO_APRUEBA.P_AUTO_APRUEBA(L_FLGESTCOM,
                                       L_ESTSOLFAC,
                                       P_NUMSLC,
                                       L_MENSAJE);
      EXCEPTION
        WHEN OTHERS THEN
          G_MSJ_ERR := 'ERROR AL EJECUTAR SP: ' ||
                       'SALES.PQ_AUTO_APRUEBA.P_AUTO_APRUEBA, ' || CHR(13) ||
                       'MENSAJE DE ERROR: ' || TO_CHAR(SQLERRM); -- 3.0
          OPERACION.PQ_SIAC_CAMBIO_PLAN.P_INSERT_LOG_POST_SIAC(G_COD_ID,
                                                               G_CUSTOMERID,
                                                               G_PROCESO,
                                                               G_MSJ_ERR ||
                                                               CHR(13) ||
                                                               ' TRAZA DE ERROR:   ' ||
                                                               DBMS_UTILITY.FORMAT_ERROR_BACKTRACE); -- 3.0
          RETURN 0;
      END;

      IF L_MENSAJE <> 'OK' THEN
        RETURN 2;
      ELSE
        RETURN 1;
      END IF;
    END IF;
    G_CODSOLOT := FNC_GET_CODSOLOT();
    SP_SET_INSTANCE('SOT', G_CODSOLOT);
  EXCEPTION
    -- INI 3.0
    WHEN OTHERS THEN
      G_MSJ_ERR := 'ERROR AL EJECUTAR FNC: ' || $$PLSQL_UNIT || '.' ||
                   'FNC_PROYECTO_PREVENTA, ' || CHR(13) ||
                   'MENSAJE DE ERROR: ' || TO_CHAR(SQLERRM); -- 3.0
      OPERACION.PQ_SIAC_CAMBIO_PLAN.P_INSERT_LOG_POST_SIAC(G_COD_ID,
                                                           G_CUSTOMERID,
                                                           G_PROCESO,
                                                           G_MSJ_ERR ||
                                                           CHR(13) ||
                                                           ' TRAZA DE ERROR:   ' ||
                                                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE); -- 3.0
      RETURN 0;
  END;

  FUNCTION FNC_INSERT_REGVTAMENTAB(P_REGMEN REGVTAMENTAB%ROWTYPE)
    RETURN REGVTAMENTAB.NUMREGISTRO%TYPE IS
    L_NUMREGISTRO REGVTAMENTAB.NUMREGISTRO%TYPE;

  BEGIN
    INSERT INTO REGVTAMENTAB
    VALUES P_REGMEN
    RETURNING NUMREGISTRO INTO L_NUMREGISTRO;

    RETURN L_NUMREGISTRO;
  EXCEPTION
    WHEN OTHERS THEN
      G_MSJ_ERR := 'ERROR AL EJECUTAR FNC: ' || $$PLSQL_UNIT || '.' ||
                   'FNC_INSERT_REGVTAMENTAB, ' || CHR(13) ||
                   'MENSAJE DE ERROR: ' || TO_CHAR(SQLERRM); -- 3.0
      OPERACION.PQ_SIAC_CAMBIO_PLAN.P_INSERT_LOG_POST_SIAC(G_COD_ID,
                                                           G_CUSTOMERID,
                                                           G_PROCESO,
                                                           G_MSJ_ERR ||
                                                           CHR(13) ||
                                                           ' TRAZA DE ERROR:   ' ||
                                                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE); -- 3.0
      RAISE_APPLICATION_ERROR(-20000, G_MSJ_ERR); -- 3.0
  END;

  FUNCTION FNC_GET_SERVICES(P_SERVICIOS SERVICIOS_TYPE) RETURN SERVICES_TYPE IS
    L_FIRST_SERVICIO PLS_INTEGER;
    L_COUNT_SRV      PLS_INTEGER;
    L_COUNT_NEW_SRV  PLS_INTEGER;
    L_IDLINEA        SALES.LINEA_PAQUETE.IDLINEA%TYPE;
    L_CODSRV         SALES.LINEA_PAQUETE.CODSRV%TYPE;
    L_IDDET          SALES.LINEA_PAQUETE.IDDET%TYPE;
    L_NEW_SERVICES   SERVICIOS_TYPE;
    L_SERVICES       SERVICES_TYPE;

  BEGIN
    L_COUNT_SRV      := 0;
    L_COUNT_NEW_SRV  := 0;
    L_FIRST_SERVICIO := TO_NUMBER(P_SERVICIOS.FIRST);

    IF L_FIRST_SERVICIO IS NOT NULL OR L_FIRST_SERVICIO > 0 THEN
      FOR L IN P_SERVICIOS.FIRST .. P_SERVICIOS.LAST LOOP
        L_IDLINEA := FNC_GET_LINEA(P_SERVICIOS(L));
        L_CODSRV  := FNC_GET_CODSRV(P_SERVICIOS(L));
        L_IDDET   := FNC_GET_IDDET(P_SERVICIOS(L));

        IF L_IDLINEA IS NOT NULL THEN
          L_SERVICES(L_COUNT_SRV).IDLINEA := L_IDLINEA;
          L_SERVICES(L_COUNT_SRV).CODSRV := L_CODSRV;
          L_SERVICES(L_COUNT_SRV).IDDET := L_IDDET;
          L_SERVICES(L_COUNT_SRV).CANTIDAD := P_SERVICIOS(L).CANTIDAD;
          L_COUNT_SRV := L_COUNT_SRV + 1;
        END IF;

        IF L_IDLINEA IS NULL THEN
          L_COUNT_NEW_SRV := L_COUNT_NEW_SRV + 1;
          L_NEW_SERVICES(L_COUNT_NEW_SRV) := P_SERVICIOS(L);
        END IF;
      END LOOP;
    END IF;

    IF L_NEW_SERVICES.FIRST > 0 THEN
      L_SERVICES := FNC_FILL_NEW_SERVICES(L_SERVICES, L_NEW_SERVICES);
    END IF;
    RETURN L_SERVICES;
  EXCEPTION
    -- INI 3.0
    WHEN OTHERS THEN
      G_MSJ_ERR := 'ERROR AL EJECUTAR FNC: ' || $$PLSQL_UNIT || '.' ||
                   'FNC_GET_SERVICES, ' || CHR(13) || 'MENSAJE DE ERROR: ' ||
                   TO_CHAR(SQLERRM); -- 3.0
      OPERACION.PQ_SIAC_CAMBIO_PLAN.P_INSERT_LOG_POST_SIAC(G_COD_ID,
                                                           G_CUSTOMERID,
                                                           G_PROCESO,
                                                           G_MSJ_ERR ||
                                                           CHR(13) ||
                                                           ' TRAZA DE ERROR:   ' ||
                                                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE); -- 3.0
      RAISE_APPLICATION_ERROR(-20000, G_MSJ_ERR); -- 3.0
  END;

  FUNCTION FNC_FILL_NEW_SERVICES(P_SERVICES      SERVICES_TYPE,
                                 P_NEW_SERVICIOS SERVICIOS_TYPE)
    RETURN SERVICES_TYPE IS
    L_COUNT_SRV PLS_INTEGER;
    L_SERVICES  SERVICES_TYPE;
    L_LINEAS    IDLINEAS_TYPE;

  BEGIN
    SP_INSERT_SERVICIOS(P_NEW_SERVICIOS, L_LINEAS);

    L_SERVICES  := P_SERVICES;
    L_COUNT_SRV := TO_NUMBER(L_SERVICES.LAST) + 1;

    FOR L IN L_LINEAS.FIRST .. L_LINEAS.LAST LOOP
      L_SERVICES(L_COUNT_SRV).IDLINEA := L_LINEAS(L).IDLINEA;
      L_SERVICES(L_COUNT_SRV).CANTIDAD := L_LINEAS(L).CANTIDAD;
      L_SERVICES(L_COUNT_SRV).CODSRV := L_LINEAS(L).SERVICIO_SGA;
      L_SERVICES(L_COUNT_SRV).IDDET := L_LINEAS(L).IDDET;
      L_SERVICES(L_COUNT_SRV).TIPO := FNC_GET_ACCION_CP(P_SERVICES(L).TIPO,
                                                        'SGA');
      L_COUNT_SRV := L_COUNT_SRV + 1;
    END LOOP;

    RETURN L_SERVICES;
  END;

  FUNCTION FNC_GET_LINEA(P_SERVICIO SERVICIO_TYPE)
    RETURN SALES.LINEA_PAQUETE.IDLINEA%TYPE IS
    L_IDLINEA SALES.LINEA_PAQUETE.IDLINEA%TYPE;

  BEGIN
    IF P_SERVICIO.TIPEQU IS NOT NULL AND P_SERVICIO.IDGRUPO IS NOT NULL THEN
      L_IDLINEA := FNC_GET_IDLINEA_EQUIPO(P_SERVICIO.TIPEQU,
                                          P_SERVICIO.IDGRUPO);
    END IF;
    IF P_SERVICIO.TIPEQU IS NULL THEN
      L_IDLINEA := FNC_GET_IDLINEA_SERVICE(P_SERVICIO.SERVICIO);
    END IF;
    RETURN L_IDLINEA;
  END;

  FUNCTION FNC_GET_IDLINEA_EQUIPO(P_TIPEQU  TIPEQU.TIPEQU%TYPE,
                                  P_IDGRUPO SALES.GRUPO_SISACT_LTE.IDGRUPO_SISACT%TYPE)
    RETURN LINEA_PAQUETE.IDLINEA%TYPE IS
    L_IDLINEA LINEA_PAQUETE.IDLINEA%TYPE;

  BEGIN

    SELECT T.IDLINEA
      INTO L_IDLINEA
      FROM SALES.EQUIPO_SISACT T
     WHERE T.TIPEQU = P_TIPEQU
       AND T.GRUPO = P_IDGRUPO;

    RETURN L_IDLINEA;

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      G_MSJ_ERR := 'ERROR AL EJECUTAR FNC: ' || $$PLSQL_UNIT || '.' ||
                   'FNC_GET_IDLINEA_EQUIPO, ' || CHR(13) || 'P_TIPEQU: ' ||
                   TO_CHAR(P_TIPEQU) || CHR(13) || 'P_IDGRUPO: ' ||
                   TO_CHAR(P_IDGRUPO) || CHR(13) || 'MENSAJE DE ERROR: ' ||
                   TO_CHAR(SQLERRM); -- 3.0
      OPERACION.PQ_SIAC_CAMBIO_PLAN.P_INSERT_LOG_POST_SIAC(G_COD_ID,
                                                           G_CUSTOMERID,
                                                           G_PROCESO,
                                                           G_MSJ_ERR ||
                                                           CHR(13) ||
                                                           ' TRAZA DE ERROR:   ' ||
                                                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE); -- 3.0
      RETURN NULL;
    WHEN OTHERS THEN
      G_MSJ_ERR := 'ERROR AL EJECUTAR FNC: ' || $$PLSQL_UNIT || '.' ||
                   'FNC_GET_IDLINEA_EQUIPO, ' || CHR(13) || 'P_TIPEQU: ' ||
                   TO_CHAR(P_TIPEQU) || CHR(13) || 'P_IDGRUPO: ' ||
                   TO_CHAR(P_IDGRUPO) || CHR(13) || 'MENSAJE DE ERROR: ' ||
                   TO_CHAR(SQLERRM); -- 3.0
      OPERACION.PQ_SIAC_CAMBIO_PLAN.P_INSERT_LOG_POST_SIAC(G_COD_ID,
                                                           G_CUSTOMERID,
                                                           G_PROCESO,
                                                           G_MSJ_ERR ||
                                                           CHR(13) ||
                                                           ' TRAZA DE ERROR:   ' ||
                                                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE); -- 3.0
  END;

  FUNCTION FNC_GET_IDLINEA_SERVICE(P_SERVICEID_SISACT SALES.SERVICIO_SISACT.IDSERVICIO_SISACT%TYPE)
    RETURN LINEA_PAQUETE.IDLINEA%TYPE IS
    L_SERVICEID SALES.SERVICIO_SISACT.IDSERVICIO_SISACT%TYPE;
    L_IDLINEA   LINEA_PAQUETE.IDLINEA%TYPE;

  BEGIN
    L_SERVICEID := UPPER(TRIM(P_SERVICEID_SISACT));

    SELECT LP.IDLINEA
      INTO L_IDLINEA
      FROM SALES.SERVICIO_SISACT S, LINEA_PAQUETE LP, TYSTABSRV T
     WHERE S.IDSERVICIO_SISACT = L_SERVICEID
       AND S.CODSRV = LP.CODSRV
       AND LP.CODSRV = T.CODSRV
       AND T.FLG_SISACT_SGA = 2;

    RETURN L_IDLINEA;

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      G_MSJ_ERR := 'ERROR AL EJECUTAR FNC: ' || $$PLSQL_UNIT || '.' ||
                   'FNC_GET_IDLINEA_SERVICE, ' || CHR(13) ||
                   'P_SERVICEID_SISACT: ' || TO_CHAR(P_SERVICEID_SISACT) ||
                   CHR(13) || 'MENSAJE DE ERROR: ' || TO_CHAR(SQLERRM); -- 3.0
      OPERACION.PQ_SIAC_CAMBIO_PLAN.P_INSERT_LOG_POST_SIAC(G_COD_ID,
                                                           G_CUSTOMERID,
                                                           G_PROCESO,
                                                           G_MSJ_ERR ||
                                                           CHR(13) ||
                                                           ' TRAZA DE ERROR:   ' ||
                                                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE); -- 3.0
      RETURN NULL;
    WHEN OTHERS THEN
      G_MSJ_ERR := 'ERROR AL EJECUTAR FNC: ' || $$PLSQL_UNIT || '.' ||
                   'FNC_GET_IDLINEA_SERVICE, ' || CHR(13) ||
                   'P_SERVICEID_SISACT: ' || TO_CHAR(P_SERVICEID_SISACT) ||
                   CHR(13) || 'MENSAJE DE ERROR: ' || TO_CHAR(SQLERRM); -- 3.0
      OPERACION.PQ_SIAC_CAMBIO_PLAN.P_INSERT_LOG_POST_SIAC(G_COD_ID,
                                                           G_CUSTOMERID,
                                                           G_PROCESO,
                                                           G_MSJ_ERR ||
                                                           CHR(13) ||
                                                           ' TRAZA DE ERROR:   ' ||
                                                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE); -- 3.0
  END;

  FUNCTION FNC_GET_CODSRV(P_SERVICIO SERVICIO_TYPE)
    RETURN SALES.LINEA_PAQUETE.CODSRV%TYPE IS
    L_CODSRV SALES.LINEA_PAQUETE.CODSRV%TYPE;

  BEGIN
    IF P_SERVICIO.TIPEQU IS NOT NULL AND P_SERVICIO.IDGRUPO IS NOT NULL THEN
      L_CODSRV := FNC_GET_CODSRV_EQUIPO(P_SERVICIO.TIPEQU,
                                        P_SERVICIO.IDGRUPO);
    END IF;
    IF P_SERVICIO.TIPEQU IS NULL THEN
      L_CODSRV := FNC_GET_CODSRV_SERVICE(P_SERVICIO.SERVICIO);
    END IF;
    RETURN L_CODSRV;
  END;

  FUNCTION FNC_GET_CODSRV_EQUIPO(P_TIPEQU  TIPEQU.TIPEQU%TYPE,
                                 P_IDGRUPO SALES.GRUPO_SISACT_LTE.IDGRUPO_SISACT%TYPE)
    RETURN LINEA_PAQUETE.CODSRV%TYPE IS
    L_CODSRV LINEA_PAQUETE.CODSRV%TYPE;

  BEGIN

    SELECT L.CODSRV
      INTO L_CODSRV
      FROM SALES.EQUIPO_SISACT T, LINEA_PAQUETE L, TYSTABSRV S
     WHERE T.IDLINEA = L.IDLINEA
       AND L.CODSRV = S.CODSRV
       AND T.TIPEQU = P_TIPEQU
       AND T.GRUPO = P_IDGRUPO
       AND S.FLG_SISACT_SGA = 2;

    RETURN L_CODSRV;

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      G_MSJ_ERR := 'ERROR AL EJECUTAR FNC: ' || $$PLSQL_UNIT || '.' ||
                   'FNC_GET_CODSRV_EQUIPO, ' || CHR(13) || 'P_TIPEQU: ' ||
                   TO_CHAR(P_TIPEQU) || CHR(13) || 'P_IDGRUPO: ' ||
                   TO_CHAR(P_IDGRUPO) || CHR(13) || 'MENSAJE DE ERROR: ' ||
                   TO_CHAR(SQLERRM); -- 3.0
      OPERACION.PQ_SIAC_CAMBIO_PLAN.P_INSERT_LOG_POST_SIAC(G_COD_ID,
                                                           G_CUSTOMERID,
                                                           G_PROCESO,
                                                           G_MSJ_ERR ||
                                                           CHR(13) ||
                                                           ' TRAZA DE ERROR:   ' ||
                                                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE); -- 3.0
      RETURN NULL;
    WHEN OTHERS THEN
      G_MSJ_ERR := 'ERROR AL EJECUTAR FNC: ' || $$PLSQL_UNIT || '.' ||
                   'FNC_GET_CODSRV_EQUIPO, ' || CHR(13) || 'P_TIPEQU: ' ||
                   TO_CHAR(P_TIPEQU) || CHR(13) || 'P_IDGRUPO: ' ||
                   TO_CHAR(P_IDGRUPO) || CHR(13) || 'MENSAJE DE ERROR: ' ||
                   TO_CHAR(SQLERRM); -- 3.0
      OPERACION.PQ_SIAC_CAMBIO_PLAN.P_INSERT_LOG_POST_SIAC(G_COD_ID,
                                                           G_CUSTOMERID,
                                                           G_PROCESO,
                                                           G_MSJ_ERR ||
                                                           CHR(13) ||
                                                           ' TRAZA DE ERROR:   ' ||
                                                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE); -- 3.0
  END;

  FUNCTION FNC_GET_CODSRV_SERVICE(P_SERVICEID_SISACT SALES.SERVICIO_SISACT.IDSERVICIO_SISACT%TYPE)
    RETURN LINEA_PAQUETE.CODSRV%TYPE IS
    L_SERVICEID SALES.SERVICIO_SISACT.IDSERVICIO_SISACT%TYPE;
    L_CODSRV    LINEA_PAQUETE.CODSRV%TYPE;

  BEGIN
    L_SERVICEID := UPPER(TRIM(P_SERVICEID_SISACT));

    SELECT LP.CODSRV
      INTO L_CODSRV
      FROM SALES.SERVICIO_SISACT S, LINEA_PAQUETE LP, TYSTABSRV T
     WHERE S.IDSERVICIO_SISACT = L_SERVICEID
       AND S.CODSRV = LP.CODSRV
       AND LP.CODSRV = T.CODSRV
       AND T.FLG_SISACT_SGA = 2;

    RETURN L_CODSRV;

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      G_MSJ_ERR := 'ERROR AL EJECUTAR FNC: ' || $$PLSQL_UNIT || '.' ||
                   'FNC_GET_CODSRV_SERVICE, ' || CHR(13) ||
                   'P_SERVICEID_SISACT: ' || TO_CHAR(P_SERVICEID_SISACT) ||
                   CHR(13) || 'MENSAJE DE ERROR: ' || TO_CHAR(SQLERRM); -- 3.0
      OPERACION.PQ_SIAC_CAMBIO_PLAN.P_INSERT_LOG_POST_SIAC(G_COD_ID,
                                                           G_CUSTOMERID,
                                                           G_PROCESO,
                                                           G_MSJ_ERR ||
                                                           CHR(13) ||
                                                           ' TRAZA DE ERROR:   ' ||
                                                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE); -- 3.0
      RETURN NULL;
    WHEN OTHERS THEN
      G_MSJ_ERR := 'ERROR AL EJECUTAR FNC: ' || $$PLSQL_UNIT || '.' ||
                   'FNC_GET_CODSRV_SERVICE, ' || CHR(13) ||
                   'P_SERVICEID_SISACT: ' || TO_CHAR(P_SERVICEID_SISACT) ||
                   CHR(13) || 'MENSAJE DE ERROR: ' || TO_CHAR(SQLERRM); -- 3.0
      OPERACION.PQ_SIAC_CAMBIO_PLAN.P_INSERT_LOG_POST_SIAC(G_COD_ID,
                                                           G_CUSTOMERID,
                                                           G_PROCESO,
                                                           G_MSJ_ERR ||
                                                           CHR(13) ||
                                                           ' TRAZA DE ERROR:   ' ||
                                                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE); -- 3.0
  END;

  FUNCTION FNC_GET_IDDET(P_SERVICIO SERVICIO_TYPE)
    RETURN SALES.LINEA_PAQUETE.IDDET%TYPE IS
    L_IDDET SALES.LINEA_PAQUETE.IDDET%TYPE;

  BEGIN
    IF P_SERVICIO.TIPEQU IS NOT NULL AND P_SERVICIO.IDGRUPO IS NOT NULL THEN
      L_IDDET := FNC_GET_IDDET_EQUIPO(P_SERVICIO.TIPEQU, P_SERVICIO.IDGRUPO);
    END IF;

    IF P_SERVICIO.TIPEQU IS NULL THEN
      L_IDDET := FNC_GET_IDDET_SERVICE(P_SERVICIO.SERVICIO);
    END IF;
    RETURN L_IDDET;
  END;

  FUNCTION FNC_GET_IDDET_EQUIPO(P_TIPEQU  TIPEQU.TIPEQU%TYPE,
                                P_IDGRUPO SALES.GRUPO_SISACT_LTE.IDGRUPO_SISACT%TYPE)
    RETURN LINEA_PAQUETE.IDDET%TYPE IS
    L_IDDET LINEA_PAQUETE.IDDET%TYPE;

  BEGIN

    SELECT L.IDDET
      INTO L_IDDET
      FROM SALES.EQUIPO_SISACT T, LINEA_PAQUETE L, TYSTABSRV S
     WHERE T.IDLINEA = L.IDLINEA
       AND L.CODSRV = S.CODSRV
       AND T.TIPEQU = P_TIPEQU
       AND T.GRUPO = P_IDGRUPO
       AND S.FLG_SISACT_SGA = 2;

    RETURN L_IDDET;

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      G_MSJ_ERR := 'ERROR AL EJECUTAR FNC: ' || $$PLSQL_UNIT || '.' ||
                   'FNC_GET_IDDET_EQUIPO, ' || CHR(13) || 'P_TIPEQU: ' ||
                   TO_CHAR(P_TIPEQU) || CHR(13) || 'P_IDGRUPO: ' ||
                   TO_CHAR(P_IDGRUPO) || CHR(13) || 'MENSAJE DE ERROR: ' ||
                   TO_CHAR(SQLERRM); -- 3.0
      OPERACION.PQ_SIAC_CAMBIO_PLAN.P_INSERT_LOG_POST_SIAC(G_COD_ID,
                                                           G_CUSTOMERID,
                                                           G_PROCESO,
                                                           G_MSJ_ERR ||
                                                           CHR(13) ||
                                                           ' TRAZA DE ERROR:   ' ||
                                                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE); -- 3.0
      RETURN NULL;
    WHEN OTHERS THEN
      G_MSJ_ERR := 'ERROR AL EJECUTAR FNC: ' || $$PLSQL_UNIT || '.' ||
                   'FNC_GET_IDDET_EQUIPO, ' || CHR(13) || 'P_TIPEQU: ' ||
                   TO_CHAR(P_TIPEQU) || CHR(13) || 'P_IDGRUPO: ' ||
                   TO_CHAR(P_IDGRUPO) || CHR(13) || 'MENSAJE DE ERROR: ' ||
                   TO_CHAR(SQLERRM); -- 3.0
      OPERACION.PQ_SIAC_CAMBIO_PLAN.P_INSERT_LOG_POST_SIAC(G_COD_ID,
                                                           G_CUSTOMERID,
                                                           G_PROCESO,
                                                           G_MSJ_ERR ||
                                                           CHR(13) ||
                                                           ' TRAZA DE ERROR:   ' ||
                                                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE); -- 3.0
  END;

  FUNCTION FNC_GET_IDDET_SERVICE(P_SERVICEID_SISACT SALES.SERVICIO_SISACT.IDSERVICIO_SISACT%TYPE)
    RETURN LINEA_PAQUETE.IDDET%TYPE IS
    L_SERVICEID SALES.SERVICIO_SISACT.IDSERVICIO_SISACT%TYPE;
    L_IDDET     LINEA_PAQUETE.IDDET%TYPE;

  BEGIN
    L_SERVICEID := UPPER(TRIM(P_SERVICEID_SISACT));

    SELECT LP.IDDET
      INTO L_IDDET
      FROM SALES.SERVICIO_SISACT S, LINEA_PAQUETE LP, TYSTABSRV T
     WHERE S.IDSERVICIO_SISACT = L_SERVICEID
       AND S.CODSRV = LP.CODSRV
       AND LP.CODSRV = T.CODSRV
       AND T.FLG_SISACT_SGA = 2;

    RETURN L_IDDET;

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      G_MSJ_ERR := 'ERROR AL EJECUTAR FNC: ' || $$PLSQL_UNIT || '.' ||
                   'FNC_GET_IDDET_SERVICE, ' || CHR(13) ||
                   'P_SERVICEID_SISACT: ' || TO_CHAR(P_SERVICEID_SISACT) ||
                   CHR(13) || 'MENSAJE DE ERROR: ' || TO_CHAR(SQLERRM); -- 3.0
      OPERACION.PQ_SIAC_CAMBIO_PLAN.P_INSERT_LOG_POST_SIAC(G_COD_ID,
                                                           G_CUSTOMERID,
                                                           G_PROCESO,
                                                           G_MSJ_ERR ||
                                                           CHR(13) ||
                                                           ' TRAZA DE ERROR:   ' ||
                                                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE); -- 3.0
      RETURN NULL;
    WHEN OTHERS THEN
      G_MSJ_ERR := 'ERROR AL EJECUTAR FNC: ' || $$PLSQL_UNIT || '.' ||
                   'FNC_GET_IDDET_SERVICE, ' || CHR(13) ||
                   'P_SERVICEID_SISACT: ' || TO_CHAR(P_SERVICEID_SISACT) ||
                   CHR(13) || 'MENSAJE DE ERROR: ' || TO_CHAR(SQLERRM); -- 3.0
      OPERACION.PQ_SIAC_CAMBIO_PLAN.P_INSERT_LOG_POST_SIAC(G_COD_ID,
                                                           G_CUSTOMERID,
                                                           G_PROCESO,
                                                           G_MSJ_ERR ||
                                                           CHR(13) ||
                                                           ' TRAZA DE ERROR:   ' ||
                                                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE); -- 3.0
  END;

  FUNCTION FNC_GET_IDDET_SGA(P_IDLINEA SALES.LINEA_PAQUETE.IDLINEA%TYPE)
    RETURN LINEA_PAQUETE.IDDET%TYPE IS
    L_IDDET LINEA_PAQUETE.IDDET%TYPE;

  BEGIN

    SELECT LP.IDDET
      INTO L_IDDET
      FROM LINEA_PAQUETE LP
     WHERE LP.IDLINEA = P_IDLINEA;

    RETURN L_IDDET;

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      G_MSJ_ERR := 'ERROR AL EJECUTAR FNC: ' || $$PLSQL_UNIT || '.' ||
                   'FNC_GET_IDDET_SGA, ' || CHR(13) || 'P_IDLINEA: ' ||
                   TO_CHAR(P_IDLINEA) || CHR(13) || 'MENSAJE DE ERROR: ' ||
                   TO_CHAR(SQLERRM); -- 3.0
      OPERACION.PQ_SIAC_CAMBIO_PLAN.P_INSERT_LOG_POST_SIAC(G_COD_ID,
                                                           G_CUSTOMERID,
                                                           G_PROCESO,
                                                           G_MSJ_ERR ||
                                                           CHR(13) ||
                                                           ' TRAZA DE ERROR:   ' ||
                                                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE); -- 3.0
      RETURN NULL;
    WHEN OTHERS THEN
      G_MSJ_ERR := 'ERROR AL EJECUTAR FNC: ' || $$PLSQL_UNIT || '.' ||
                   'FNC_GET_IDDET_SGA, ' || CHR(13) || 'P_IDLINEA: ' ||
                   TO_CHAR(P_IDLINEA) || CHR(13) || 'MENSAJE DE ERROR: ' ||
                   TO_CHAR(SQLERRM); -- 3.0
      OPERACION.PQ_SIAC_CAMBIO_PLAN.P_INSERT_LOG_POST_SIAC(G_COD_ID,
                                                           G_CUSTOMERID,
                                                           G_PROCESO,
                                                           G_MSJ_ERR ||
                                                           CHR(13) ||
                                                           ' TRAZA DE ERROR:   ' ||
                                                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE); -- 3.0
  END;

  FUNCTION FNC_GET_ACCION_CP(P_ACCION OPERACION.INSPRD.CODSRV%TYPE,
                             P_TIPO   VARCHAR2) RETURN NUMBER IS
    L_ACC_SGA  SALES.REGDETPTOENLCAMBIO.TIPO%TYPE;
    L_ACC_BSCS NUMBER;
  BEGIN
    SELECT CODIGON, CODIGON_AUX
      INTO L_ACC_SGA, L_ACC_BSCS
      FROM OPERACION.OPEDD O, OPERACION.TIPOPEDD T
     WHERE O.TIPOPEDD = T.TIPOPEDD
       AND T.ABREV = 'CONF_LTE_ACCION'
       AND O.CODIGOC = P_ACCION;

    IF P_TIPO = 'SGA' THEN
      RETURN L_ACC_SGA;
    ELSIF P_TIPO = 'BSCS' THEN
      RETURN L_ACC_BSCS;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      IF P_TIPO = 'SGA' THEN
        L_ACC_SGA := 1;
        RETURN L_ACC_SGA;
      ELSIF P_TIPO = 'BSCS' THEN
        L_ACC_BSCS := 5;
        RETURN L_ACC_BSCS;
      END IF;
  END;

  FUNCTION FNC_GET_INSSRV(P_COD_ID OPERACION.SOLOT.COD_ID%TYPE)
    RETURN INSSRV%ROWTYPE IS
    L_INSSRV INSSRV%ROWTYPE;

  BEGIN

    SELECT I.*
      INTO L_INSSRV
      FROM SALES.V_SALES_POSTVENTA_SIAC S, INSSRV I, VTATABSLCFAC V
     WHERE S.COD_ID = P_COD_ID
       AND S.NUMSLC = V.NUMSLC
       AND V.IDSOLUCION = (SELECT SO.IDSOLUCION
                             FROM SOLUCIONES SO
                            WHERE SO.FLG_SISACT_SGA = 2)
       AND S.NUMSLC = I.NUMSLC
       AND S.CODSOLOT = G_CODSOLOT_OLD
       AND ROWNUM = 1; -- 3.0

    RETURN L_INSSRV;
  EXCEPTION
    WHEN OTHERS THEN
      G_MSJ_ERR := 'ERROR AL EJECUTAR FNC: ' || $$PLSQL_UNIT || '.' ||
                   'FNC_GET_INSSRV, ' || CHR(13) || 'P_COD_ID: ' ||
                   TO_CHAR(P_COD_ID) || CHR(13) || 'MENSAJE DE ERROR: ' ||
                   TO_CHAR(SQLERRM) || --; -- 3.0
                   'SOT ANTIGUA: ' || TO_CHAR(G_CODSOLOT_OLD); -- 3.0
      OPERACION.PQ_SIAC_CAMBIO_PLAN.P_INSERT_LOG_POST_SIAC(G_COD_ID,
                                                           G_CUSTOMERID,
                                                           G_PROCESO,
                                                           G_MSJ_ERR ||
                                                           CHR(13) ||
                                                           ' TRAZA DE ERROR:   ' ||
                                                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE); -- 3.0
      RAISE_APPLICATION_ERROR(-20000, G_MSJ_ERR); -- 3.0
  END;

  FUNCTION FNC_EXISTE_TRASLADO(P_COD_ID OPERACION.SOLOT.COD_ID%TYPE)
    RETURN BOOLEAN IS
    L_COUNT PLS_INTEGER;

  BEGIN
    SELECT COUNT(1)
      INTO L_COUNT
      FROM SALES.SOT_SISACT T, SOLOT S, SOLOT SS
     WHERE T.COD_ID = P_COD_ID
       AND T.CODSOLOT = S.CODSOLOT
       AND S.CODCLI = SS.CODCLI
       AND SS.TIPTRA IN
           (SELECT P.CODIGON
              FROM TIPOPEDD T, OPEDD P
             WHERE T.ABREV = 'TIPO_TRASLADOS'
               AND T.TIPOPEDD = P.TIPOPEDD
               AND P.ABREVIACION = 'TIPO_TRASLADO');

    RETURN L_COUNT > 0;

  EXCEPTION
    WHEN OTHERS THEN
      G_MSJ_ERR := 'ERROR AL EJECUTAR FNC: ' || $$PLSQL_UNIT || '.' ||
                   'FNC_EXISTE_TRASLADO, ' || CHR(13) || 'P_COD_ID: ' ||
                   TO_CHAR(P_COD_ID) || CHR(13) || 'MENSAJE DE ERROR: ' ||
                   TO_CHAR(SQLERRM); -- 3.0
      OPERACION.PQ_SIAC_CAMBIO_PLAN.P_INSERT_LOG_POST_SIAC(G_COD_ID,
                                                           G_CUSTOMERID,
                                                           G_PROCESO,
                                                           G_MSJ_ERR ||
                                                           CHR(13) ||
                                                           ' TRAZA DE ERROR:   ' ||
                                                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE); -- 3.0
      RAISE_APPLICATION_ERROR(-20000, G_MSJ_ERR); -- 3.0
  END;

  FUNCTION FNC_GET_DATOS_TRASLADO(P_COD_ID OPERACION.SOLOT.COD_ID%TYPE)
    RETURN INSSRV%ROWTYPE IS
    L_INSSRV INSSRV%ROWTYPE;

  BEGIN

    SELECT I.*
      INTO L_INSSRV
      FROM SALES.V_SALES_POSTVENTA_SIAC S,
           SOLOT                        L,
           INSSRV                       I,
           VTATABSLCFAC                 V
     WHERE S.COD_ID = P_COD_ID
       AND S.CODSOLOT = L.CODSOLOT
       AND L.NUMSLC = V.NUMSLC
       AND V.IDSOLUCION = (SELECT SO.IDSOLUCION
                             FROM SOLUCIONES SO
                            WHERE SO.FLG_SISACT_SGA = 2)
       AND L.NUMSLC = I.NUMSLC
       AND I.ESTINSSRV = 1
       AND L.TIPTRA IN (SELECT P.CODIGON
                          FROM TIPOPEDD T, OPEDD P
                         WHERE T.ABREV = 'tipo_traslados'
                           AND T.TIPOPEDD = P.TIPOPEDD
                           AND P.ABREVIACION = 'tipo_traslado')
       AND ROWNUM < 2; -- 3.0

    RETURN L_INSSRV;

  EXCEPTION
    WHEN OTHERS THEN
      G_MSJ_ERR := 'ERROR AL EJECUTAR FNC: ' || $$PLSQL_UNIT || '.' ||
                   'FNC_GET_DATOS_TRASLADO, ' || CHR(13) || 'P_COD_ID: ' ||
                   TO_CHAR(P_COD_ID) || CHR(13) || 'MENSAJE DE ERROR: ' ||
                   TO_CHAR(SQLERRM); -- 3.0
      OPERACION.PQ_SIAC_CAMBIO_PLAN.P_INSERT_LOG_POST_SIAC(G_COD_ID,
                                                           G_CUSTOMERID,
                                                           G_PROCESO,
                                                           G_MSJ_ERR ||
                                                           CHR(13) ||
                                                           ' TRAZA DE ERROR:   ' ||
                                                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE); -- 3.0
      RAISE_APPLICATION_ERROR(-20000, G_MSJ_ERR); -- 3.0
  END;

  FUNCTION FNC_GET_CNTCLI(P_COD_ID OPERACION.SOLOT.COD_ID%TYPE)
    RETURN VTATABCNTCLI%ROWTYPE IS
    L_CNTCLI VTATABCNTCLI%ROWTYPE;

  BEGIN
    SELECT C.*
      INTO L_CNTCLI
      FROM SALES.V_SALES_POSTVENTA_SIAC S, VTATABCNTCLI C
     WHERE S.COD_ID = P_COD_ID
       AND S.CODCLI = C.CODCLI
       AND ROWNUM = 1; -- 3.0
    RETURN L_CNTCLI;

  EXCEPTION
    WHEN OTHERS THEN
      G_MSJ_ERR := 'ERROR AL EJECUTAR FNC: ' || $$PLSQL_UNIT || '.' ||
                   'FNC_GET_CNTCLI, ' || CHR(13) || 'P_COD_ID: ' ||
                   TO_CHAR(P_COD_ID) || CHR(13) || 'MENSAJE DE ERROR: ' ||
                   TO_CHAR(SQLERRM); -- 3.0
      OPERACION.PQ_SIAC_CAMBIO_PLAN.P_INSERT_LOG_POST_SIAC(G_COD_ID,
                                                           G_CUSTOMERID,
                                                           G_PROCESO,
                                                           G_MSJ_ERR ||
                                                           CHR(13) ||
                                                           ' TRAZA DE ERROR:   ' ||
                                                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE); -- 3.0
      RAISE_APPLICATION_ERROR(-20000, G_MSJ_ERR); -- 3.0
  END;

  FUNCTION FNC_GET_SLCFAC(P_COD_ID OPERACION.SOLOT.COD_ID%TYPE)
    RETURN VTATABSLCFAC%ROWTYPE IS
    L_SLCFAC VTATABSLCFAC%ROWTYPE;
  BEGIN

    SELECT T.*
      INTO L_SLCFAC
      FROM SALES.V_SALES_POSTVENTA_SIAC S, VTATABSLCFAC T
     WHERE S.COD_ID = P_COD_ID
       AND S.CODSOLOT = G_CODSOLOT_OLD -- 3.0
       AND S.NUMSLC = T.NUMSLC;

    RETURN L_SLCFAC;
  EXCEPTION
    -- INI 3.0
    WHEN TOO_MANY_ROWS THEN
      G_MSJ_ERR := 'ERROR AL EJECUTAR FNC: ' || $$PLSQL_UNIT || '.' ||
                   'FNC_GET_SLCFAC, ' || CHR(13) || 'P_COD_ID: ' ||
                   TO_CHAR(P_COD_ID) || CHR(13) || 'MENSAJE DE ERROR: ' ||
                   TO_CHAR(SQLERRM); -- 3.0
      OPERACION.PQ_SIAC_CAMBIO_PLAN.P_INSERT_LOG_POST_SIAC(G_COD_ID,
                                                           G_CUSTOMERID,
                                                           G_PROCESO,
                                                           G_MSJ_ERR ||
                                                           CHR(13) ||
                                                           ' TRAZA DE ERROR:   ' ||
                                                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE); -- 3.0

      SELECT T.*
        INTO L_SLCFAC
        FROM SALES.V_SALES_POSTVENTA_SIAC S, VTATABSLCFAC T
       WHERE S.COD_ID = P_COD_ID
         AND S.CODSOLOT = G_CODSOLOT_OLD
         AND S.NUMSLC = T.NUMSLC
         AND ROWNUM = 1;

      RETURN L_SLCFAC;

    WHEN OTHERS THEN
      G_MSJ_ERR := 'ERROR AL EJECUTAR FNC: ' || $$PLSQL_UNIT || '.' ||
                   'FNC_GET_SLCFAC, ' || CHR(13) || 'P_COD_ID: ' ||
                   TO_CHAR(P_COD_ID) || CHR(13) || 'MENSAJE DE ERROR: ' ||
                   TO_CHAR(SQLERRM); -- 3.0
      OPERACION.PQ_SIAC_CAMBIO_PLAN.P_INSERT_LOG_POST_SIAC(G_COD_ID,
                                                           G_CUSTOMERID,
                                                           G_PROCESO,
                                                           G_MSJ_ERR ||
                                                           CHR(13) ||
                                                           ' TRAZA DE ERROR:   ' ||
                                                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE); -- 3.0
      RAISE_APPLICATION_ERROR(-20000, G_MSJ_ERR); -- 3.0
  END;

  FUNCTION FNC_GET_CODSOLOT RETURN SOLOT.CODSOLOT%TYPE IS
    L_CODSOLOT SOLOT.CODSOLOT%TYPE;

  BEGIN
    SELECT T.CODSOLOT
      INTO L_CODSOLOT
      FROM SOLOT T
     WHERE T.NUMSLC = G_NUMSLC_NEW;

    RETURN L_CODSOLOT;
  END;

  FUNCTION FNC_CREATE_INST_PAQ_CAMBIO(P_IDINSXPAQ   REGDETPTOENLCAMBIO.IDINSXPAQ%TYPE,
                                      P_IDLINEA     LINEA_PAQUETE.IDLINEA%TYPE,
                                      P_NUMREGISTRO REGVTAMENTAB.NUMREGISTRO%TYPE,
                                      P_CODSUC      VTASUCCLI.CODSUC%TYPE)
    RETURN INSTANCIA_PAQUETE_CAMBIO.IDSECUENCIA%TYPE IS
    L_SERVICIO    DETALLE_SERVICIO_TYPE;
    L_SUCURSAL    VTASUCCLI%ROWTYPE;
    L_INSPAQ      INSTANCIA_PAQUETE_CAMBIO%ROWTYPE;
    L_IDSECUENCIA INSTANCIA_PAQUETE_CAMBIO.IDSECUENCIA%TYPE;

  BEGIN
    L_SERVICIO             := FNC_GET_DETALLE_SERVICIO(P_IDLINEA);
    L_SUCURSAL             := FNC_GET_SUCURSAL(P_CODSUC);
    L_INSPAQ.FLGPRINCIPAL  := L_SERVICIO.FLGPRINCIPAL;
    L_INSPAQ.IDPRODUCTO    := L_SERVICIO.IDPRODUCTO;
    L_INSPAQ.CODSRV        := L_SERVICIO.CODSRV;
    L_INSPAQ.CODEQUCOM     := L_SERVICIO.CODEQUCOM;
    L_INSPAQ.IDPRECIO      := L_SERVICIO.IDPRECIO;
    L_INSPAQ.CANTIDAD      := L_SERVICIO.CANTIDAD;
    L_INSPAQ.MONEDA_ID     := L_SERVICIO.MONEDA_ID;
    L_INSPAQ.IDPAQ         := L_SERVICIO.IDPAQ;
    L_INSPAQ.IDDET         := L_SERVICIO.IDDET;
    L_INSPAQ.PAQUETE       := L_SERVICIO.PAQUETE;
    L_INSPAQ.BANWID        := L_SERVICIO.BANWID;
    L_INSPAQ.IDINSXPAQ     := P_IDINSXPAQ;
    L_INSPAQ.NUMREGISTRO   := P_NUMREGISTRO;
    L_INSPAQ.ESTCSE        := 0.00;
    L_INSPAQ.ESTCTS        := 0.00;
    L_INSPAQ.PRELIS_INS    := 0.00;
    L_INSPAQ.DESC_INS      := 0.00;
    L_INSPAQ.PORCIMP_INS   := FNC_GET_IMPUESTO(1);
    L_INSPAQ.MONTO_INS     := 0.00;
    L_INSPAQ.MONTO_INS_IMP := 0.00;
    L_INSPAQ.PRELIS_SRV    := 0.00;
    L_INSPAQ.DESC_SRV      := 0.00;
    L_INSPAQ.PORCIMP_SRV   := FNC_GET_IMPUESTO(1);
    L_INSPAQ.MONTO_SRV     := 0.00;
    L_INSPAQ.MONTO_SRV_IMP := 0.00;
    L_INSPAQ.CODSUC        := L_SUCURSAL.CODSUC;
    L_INSPAQ.DESCPTO       := L_SUCURSAL.NOMSUC;
    L_INSPAQ.DIRPTO        := L_SUCURSAL.DIRSUC;
    L_INSPAQ.UBIPTO        := L_SUCURSAL.UBISUC;
    L_INSPAQ.PREUNI_INS    := 0.00;
    L_INSPAQ.PREUNI_SRV    := 0.00;
    L_INSPAQ.FLG_TIPO_VM   := 'CP';
    --DEFAULT
    L_INSPAQ.FECUSU     := SYSDATE;
    L_INSPAQ.CODUSU     := USER;
    L_INSPAQ.FLGCONTROL := 2;

    INSERT INTO INSTANCIA_PAQUETE_CAMBIO
    VALUES L_INSPAQ
    RETURNING IDSECUENCIA INTO L_IDSECUENCIA;

    RETURN L_IDSECUENCIA;
  EXCEPTION
    WHEN OTHERS THEN
      G_MSJ_ERR := 'ERROR AL EJECUTAR FNC: ' || $$PLSQL_UNIT || '.' ||
                   'FNC_CREATE_INST_PAQ_CAMBIO, ' || CHR(13) ||
                   'P_IDINSXPAQ: ' || TO_CHAR(P_IDINSXPAQ) || CHR(13) ||
                   'P_IDLINEA: ' || TO_CHAR(P_IDLINEA) || CHR(13) ||
                   'P_NUMREGISTRO: ' || TO_CHAR(P_NUMREGISTRO) || CHR(13) ||
                   'P_CODSUC: ' || TO_CHAR(P_CODSUC) || CHR(13) ||
                   'CODIGO DE ERROR: ' || TO_CHAR(SQLCODE) || CHR(13) ||
                   'MENSAJE DE ERROR: ' || TO_CHAR(SQLERRM); -- 3.0
      OPERACION.PQ_SIAC_CAMBIO_PLAN.P_INSERT_LOG_POST_SIAC(G_COD_ID,
                                                           G_CUSTOMERID,
                                                           G_PROCESO,
                                                           G_MSJ_ERR); -- 3.0
      RAISE_APPLICATION_ERROR(-20000,
                              G_MSJ_ERR || CHR(13) || ' TRAZA DE ERROR:   ' ||
                              DBMS_UTILITY.FORMAT_ERROR_BACKTRACE); -- 3.0
  END;

  FUNCTION FNC_GET_DETALLE_SERVICIO(P_IDLINEA LINEA_PAQUETE.IDLINEA%TYPE)
    RETURN DETALLE_SERVICIO_TYPE IS
    L_SERVICIO DETALLE_SERVICIO_TYPE;

  BEGIN
    SELECT A.FLGPRINCIPAL,
           A.IDPRODUCTO,
           B.CODSRV,
           B.CODEQUCOM,
           C.IDPRECIO,
           B.CANTIDAD,
           C.MONEDA_ID,
           A.IDPAQ,
           A.IDDET,
           A.PAQUETE,
           S.BANWID
      INTO L_SERVICIO.FLGPRINCIPAL,
           L_SERVICIO.IDPRODUCTO,
           L_SERVICIO.CODSRV,
           L_SERVICIO.CODEQUCOM,
           L_SERVICIO.IDPRECIO,
           L_SERVICIO.CANTIDAD,
           L_SERVICIO.MONEDA_ID,
           L_SERVICIO.IDPAQ,
           L_SERVICIO.IDDET,
           L_SERVICIO.PAQUETE,
           L_SERVICIO.BANWID
      FROM LINEA_PAQUETE B, DETALLE_PAQUETE A, TYSTABSRV S, DEFINE_PRECIO C
     WHERE B.IDLINEA = P_IDLINEA
       AND B.FLGESTADO = 1
       AND B.IDDET = A.IDDET
       AND B.CODSRV = C.CODSRV
       AND B.CODSRV = S.CODSRV
       AND A.IDPAQ IN (SELECT X.IDPAQ
                         FROM PAQUETE_VENTA X, SOLUCIONES Y
                        WHERE X.IDSOLUCION = Y.IDSOLUCION
                          AND Y.FLG_SISACT_SGA = 2)
       AND C.PLAZO = 11
       AND C.TIPO = 1
       AND A.FLGESTADO = 1;

    RETURN L_SERVICIO;
  EXCEPTION
    WHEN OTHERS THEN
      G_MSJ_ERR := 'ERROR AL EJECUTAR FNC: ' || $$PLSQL_UNIT || '.' ||
                   'FNC_GET_DETALLE_SERVICIO, ' || CHR(13) || 'P_IDLINEA: ' ||
                   TO_CHAR(P_IDLINEA) || CHR(13) || 'CODIGO DE ERROR: ' ||
                   TO_CHAR(SQLCODE) || CHR(13) || 'MENSAJE DE ERROR: ' ||
                   TO_CHAR(SQLERRM); -- 3.0
      OPERACION.PQ_SIAC_CAMBIO_PLAN.P_INSERT_LOG_POST_SIAC(G_COD_ID,
                                                           G_CUSTOMERID,
                                                           G_PROCESO,
                                                           G_MSJ_ERR); -- 3.0
      RAISE_APPLICATION_ERROR(-20000,
                              G_MSJ_ERR || CHR(13) || ' TRAZA DE ERROR:   ' ||
                              DBMS_UTILITY.FORMAT_ERROR_BACKTRACE); -- 3.0
  END;

  FUNCTION FNC_GET_IMPUESTO(P_IDIMPUESTO IMPUESTO.IDIMPUESTO%TYPE)
    RETURN NUMBER IS
    L_PORCENTAJE IMPUESTO.PORCENTAJE%TYPE;

  BEGIN
    SELECT PORCENTAJE
      INTO L_PORCENTAJE
      FROM IMPUESTO
     WHERE IDIMPUESTO = P_IDIMPUESTO;

    RETURN L_PORCENTAJE;
  END;

  FUNCTION FNC_GET_CODINSSRV_CP(P_CODSRV OPERACION.INSPRD.CODSRV%TYPE,
                                P_IDDET  OPERACION.INSPRD.IDDET%TYPE)
    RETURN OPERACION.INSPRD.CODINSSRV%TYPE IS
    L_CODINSSRV OPERACION.INSPRD.CODINSSRV%TYPE;

  BEGIN
    IF FNC_EXISTE_TRASLADO(G_COD_ID) THEN
      SELECT I.CODINSSRV
        INTO L_CODINSSRV
        FROM SALES.SOT_SISACT   S,
             OPERACION.SOLOT    L,
             OPERACION.INSPRD   P,
             OPERACION.INSSRV   I,
             SALES.VTATABSLCFAC V
       WHERE S.COD_ID = G_COD_ID
         AND S.CODSOLOT = L.CODSOLOT
         AND L.NUMSLC = V.NUMSLC
         AND V.IDSOLUCION = (SELECT SO.IDSOLUCION
                               FROM SOLUCIONES SO
                              WHERE SO.FLG_SISACT_SGA = 2)
         AND L.NUMSLC = I.NUMSLC
         AND I.CODINSSRV = P.CODINSSRV
         AND P.CODSRV = P_CODSRV
         AND P.IDDET = P_IDDET
         AND P.ESTINSPRD IN (G_ACTIVO, G_SUSPENDIDO, G_PENDIENTE_X_ACTIVAR)
         AND I.FECFIN IS NULL;
      RETURN L_CODINSSRV;
    ELSE

      SELECT I.CODINSSRV
        INTO L_CODINSSRV
        FROM SALES.SOT_SISACT   S,
             OPERACION.INSSRV   I,
             OPERACION.INSPRD   P,
             SALES.VTATABSLCFAC V
       WHERE S.COD_ID = G_COD_ID
         AND S.NUMSLC = V.NUMSLC
         AND V.IDSOLUCION IN (SELECT SO.IDSOLUCION
                                FROM SOLUCIONES SO
                               WHERE SO.FLG_SISACT_SGA = 2)
         AND S.NUMSLC = I.NUMSLC
         AND I.CODINSSRV = P.CODINSSRV
         AND P.CODSRV = P_CODSRV
         AND P.IDDET = P_IDDET
         AND P.ESTINSPRD IN (G_ACTIVO, G_SUSPENDIDO, G_PENDIENTE_X_ACTIVAR)
         AND P.FECFIN IS NULL;
      RETURN L_CODINSSRV;
    END IF;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      BEGIN
        SELECT I.CODINSSRV
          INTO L_CODINSSRV
          FROM SALES.SOT_SIAC     S,
               OPERACION.SOLOT    L,
               OPERACION.INSPRD   P,
               OPERACION.INSSRV   I,
               SALES.VTATABSLCFAC V
         WHERE S.COD_ID = G_COD_ID
           AND S.CODSOLOT = L.CODSOLOT
           AND L.NUMSLC = V.NUMSLC
           AND V.IDSOLUCION IN
               (SELECT SO.IDSOLUCION
                  FROM SOLUCIONES SO
                 WHERE SO.FLG_SISACT_SGA = 2)
           AND L.NUMSLC = I.NUMSLC
           AND I.CODINSSRV = P.CODINSSRV
           AND P.CODSRV = P_CODSRV
           AND P.IDDET = P_IDDET
           AND P.ESTINSPRD IN
               (G_ACTIVO, G_SUSPENDIDO, G_PENDIENTE_X_ACTIVAR)
           AND I.FECFIN IS NULL;

        RETURN L_CODINSSRV;
      EXCEPTION
        WHEN OTHERS THEN
          L_CODINSSRV := NULL;
          RETURN L_CODINSSRV;
      END;
    WHEN OTHERS THEN
      L_CODINSSRV := NULL;
      RETURN L_CODINSSRV;
  END;

  FUNCTION FNC_GET_PID_CP(P_CODSRV OPERACION.INSPRD.CODSRV%TYPE,
                          P_IDDET  OPERACION.INSPRD.IDDET%TYPE)
    RETURN OPERACION.INSPRD.PID%TYPE IS
    L_PID OPERACION.INSPRD.PID%TYPE;
  BEGIN
    IF FNC_EXISTE_TRASLADO(G_COD_ID) THEN
      SELECT P.PID
        INTO L_PID
        FROM SALES.SOT_SISACT   S,
             OPERACION.SOLOT    L,
             OPERACION.INSPRD   P,
             OPERACION.INSSRV   I,
             SALES.VTATABSLCFAC V
       WHERE S.COD_ID = G_COD_ID
         AND S.CODSOLOT = L.CODSOLOT
         AND L.NUMSLC = V.NUMSLC
         AND V.IDSOLUCION = (SELECT SO.IDSOLUCION
                               FROM SOLUCIONES SO
                              WHERE SO.FLG_SISACT_SGA = 2)
         AND L.NUMSLC = I.NUMSLC
         AND I.CODINSSRV = P.CODINSSRV
         AND P.CODSRV = P_CODSRV
         AND P.IDDET = P_IDDET
         AND P.ESTINSPRD IN (G_ACTIVO, G_SUSPENDIDO, G_PENDIENTE_X_ACTIVAR)
         AND I.FECFIN IS NULL;
      RETURN L_PID;
    ELSE

      SELECT P.PID
        INTO L_PID
        FROM SALES.SOT_SISACT   S,
             OPERACION.INSSRV   I,
             OPERACION.INSPRD   P,
             SALES.VTATABSLCFAC V
       WHERE S.COD_ID = G_COD_ID
         AND S.NUMSLC = V.NUMSLC
         AND V.IDSOLUCION IN (SELECT SO.IDSOLUCION
                                FROM SOLUCIONES SO
                               WHERE SO.FLG_SISACT_SGA = 2)
         AND S.NUMSLC = I.NUMSLC
         AND I.CODINSSRV = P.CODINSSRV
         AND P.CODSRV = P_CODSRV
         AND P.IDDET = P_IDDET
         AND P.ESTINSPRD IN (G_ACTIVO, G_SUSPENDIDO, G_PENDIENTE_X_ACTIVAR)
         AND P.FECFIN IS NULL;
      RETURN L_PID;
    END IF;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      BEGIN
        SELECT P.PID
          INTO L_PID
          FROM SALES.SOT_SIAC     S,
               OPERACION.SOLOT    L,
               OPERACION.INSPRD   P,
               OPERACION.INSSRV   I,
               SALES.VTATABSLCFAC V
         WHERE S.COD_ID = G_COD_ID
           AND S.CODSOLOT = L.CODSOLOT
           AND L.NUMSLC = V.NUMSLC
           AND V.IDSOLUCION IN
               (SELECT SO.IDSOLUCION
                  FROM SOLUCIONES SO
                 WHERE SO.FLG_SISACT_SGA = 2)
           AND L.NUMSLC = I.NUMSLC
           AND I.CODINSSRV = P.CODINSSRV
           AND P.CODSRV = P_CODSRV
           AND P.IDDET = P_IDDET
           AND P.ESTINSPRD IN
               (G_ACTIVO, G_SUSPENDIDO, G_PENDIENTE_X_ACTIVAR)
           AND I.FECFIN IS NULL;

        RETURN L_PID;
      EXCEPTION
        WHEN OTHERS THEN
          L_PID := NULL;
          RETURN L_PID;
      END;
    WHEN OTHERS THEN
      L_PID := NULL;
      RETURN L_PID;
  END;

  FUNCTION FNC_LIST_SERVICIOS(P_SERVICES_TYPE SERVICES_TYPE) RETURN VARCHAR2 IS
    L_FNC_LIST_SERVICIOS VARCHAR2(200);
    L_COUNT_LINEAS       PLS_INTEGER;
    L_FIRST_SRV          BOOLEAN;
    /* *********************************/
    FUNCTION IS_SERVICIO(P_IDLINEA SALES.LINEA_PAQUETE.IDLINEA%TYPE)
      RETURN BOOLEAN IS
      L_COUNT_SRV PLS_INTEGER;

    BEGIN
      SELECT COUNT(*)
        INTO L_COUNT_SRV
        FROM SALES.LINEA_PAQUETE L
       INNER JOIN SALES.SERVICIO_SISACT S
          ON L.CODSRV = S.CODSRV
         AND L.IDLINEA = P_IDLINEA;

      IF L_COUNT_SRV > 0 THEN
        RETURN TRUE;
      END IF;

      RETURN FALSE;
    END;
    /* *********************************/
    FUNCTION GET_IDSERVICIO_SISACT(P_IDLINEA SALES.LINEA_PAQUETE.IDLINEA%TYPE)

     RETURN SALES.SERVICIO_SISACT.IDSERVICIO_SISACT%TYPE IS

      L_IDSERVICIO_SISACT SALES.SERVICIO_SISACT.IDSERVICIO_SISACT%TYPE;

    BEGIN
      SELECT S.IDSERVICIO_SISACT
        INTO L_IDSERVICIO_SISACT
        FROM SALES.LINEA_PAQUETE L
       INNER JOIN SALES.SERVICIO_SISACT S
          ON L.CODSRV = S.CODSRV
         AND L.IDLINEA = P_IDLINEA;

      RETURN L_IDSERVICIO_SISACT;
    END;
    /* *********************************/
  BEGIN
    L_COUNT_LINEAS := P_SERVICES_TYPE.FIRST;
    L_FIRST_SRV    := TRUE;

    IF L_COUNT_LINEAS < 1 THEN
      RETURN NULL;
    END IF;

    FOR IDX IN P_SERVICES_TYPE.FIRST .. P_SERVICES_TYPE.LAST LOOP
      IF IS_SERVICIO(P_SERVICES_TYPE(IDX).IDLINEA) THEN
        IF L_FIRST_SRV THEN
          L_FNC_LIST_SERVICIOS := GET_IDSERVICIO_SISACT(P_SERVICES_TYPE(IDX)
                                                        .IDLINEA);
          L_FIRST_SRV          := FALSE;
        ELSE
          L_FNC_LIST_SERVICIOS := L_FNC_LIST_SERVICIOS || ';' ||
                                  GET_IDSERVICIO_SISACT(P_SERVICES_TYPE(IDX)
                                                        .IDLINEA);
        END IF;
      END IF;
    END LOOP;

    RETURN L_FNC_LIST_SERVICIOS;
  END;

  FUNCTION FNC_LIST_EQUIPOS(P_SERVICES_TYPE SERVICES_TYPE) RETURN VARCHAR2 IS
    L_FNC_LIST_EQUIPOS VARCHAR2(200);
    L_COUNT_LINEAS     PLS_INTEGER;
    L_FIRST_EQU        BOOLEAN;
    /* *********************************/
    FUNCTION IS_EQUIPO(P_IDLINEA SALES.LINEA_PAQUETE.IDLINEA%TYPE)
      RETURN BOOLEAN IS
      L_COUNT_EQU PLS_INTEGER;

    BEGIN
      SELECT COUNT(*)
        INTO L_COUNT_EQU
        FROM SALES.LINEA_PAQUETE L
       INNER JOIN SALES.EQUIPO_SISACT E
          ON L.IDLINEA = E.IDLINEA
         AND L.IDLINEA = P_IDLINEA;

      IF L_COUNT_EQU > 0 THEN
        RETURN TRUE;
      END IF;

      RETURN FALSE;
    END;
    /* *********************************/
    FUNCTION GET_TIPEQU_GRUPO(P_IDLINEA SALES.LINEA_PAQUETE.IDLINEA%TYPE)
      RETURN VARCHAR2 IS
      L_TIPEQU_GRUPO VARCHAR2(200);
      L_TIPEQU       SALES.EQUIPO_SISACT.TIPEQU%TYPE;
      L_GRUPO        SALES.EQUIPO_SISACT.GRUPO%TYPE;

    BEGIN
      SELECT E.TIPEQU, E.GRUPO
        INTO L_TIPEQU, L_GRUPO
        FROM SALES.LINEA_PAQUETE L
       INNER JOIN SALES.EQUIPO_SISACT E
          ON L.IDLINEA = E.IDLINEA
         AND L.IDLINEA = P_IDLINEA;

      L_TIPEQU_GRUPO := L_TIPEQU || '|' || L_GRUPO;

      RETURN L_TIPEQU_GRUPO;
    END;
    /* *********************************/
  BEGIN
    L_COUNT_LINEAS := P_SERVICES_TYPE.FIRST;
    L_FIRST_EQU    := TRUE;

    IF L_COUNT_LINEAS < 1 THEN
      RETURN NULL;
    END IF;

    FOR IDX IN P_SERVICES_TYPE.FIRST .. P_SERVICES_TYPE.LAST LOOP
      IF IS_EQUIPO(P_SERVICES_TYPE(IDX).IDLINEA) THEN
        IF L_FIRST_EQU THEN
          L_FNC_LIST_EQUIPOS := GET_TIPEQU_GRUPO(P_SERVICES_TYPE(IDX)
                                                 .IDLINEA);
          L_FIRST_EQU        := FALSE;
        ELSE
          L_FNC_LIST_EQUIPOS := L_FNC_LIST_EQUIPOS || ';' ||
                                GET_TIPEQU_GRUPO(P_SERVICES_TYPE(IDX)
                                                 .IDLINEA);
        END IF;
      END IF;
    END LOOP;

    RETURN L_FNC_LIST_EQUIPOS;
  END;

  FUNCTION FNC_GET_CODCLI RETURN VTATABCLI.CODCLI%TYPE IS
    L_CODCLI VTATABCLI.CODCLI%TYPE;
  BEGIN
    SELECT DISTINCT V.CODCLI
      INTO L_CODCLI
      FROM SALES.V_SALES_POSTVENTA_SIAC T, VTATABCLI V
     WHERE T.COD_ID = G_COD_ID
       AND T.CODCLI = V.CODCLI; -- 3.0

    RETURN L_CODCLI;
  EXCEPTION
    -- INI 3.0
    WHEN OTHERS THEN
      G_MSJ_ERR := 'ERROR AL EJECUTAR FNC: ' || $$PLSQL_UNIT || '.' ||
                   'FNC_GET_CODCLI, ' || CHR(13) || 'CODIGO DE ERROR: ' ||
                   TO_CHAR(SQLCODE) || CHR(13) || 'MENSAJE DE ERROR: ' ||
                   TO_CHAR(SQLERRM); -- 3.0
      OPERACION.PQ_SIAC_CAMBIO_PLAN.P_INSERT_LOG_POST_SIAC(G_COD_ID,
                                                           G_CUSTOMERID,
                                                           G_PROCESO,
                                                           G_MSJ_ERR); -- 3.0
      RAISE_APPLICATION_ERROR(-20000,
                              G_MSJ_ERR || CHR(13) || ' TRAZA DE ERROR:   ' ||
                              DBMS_UTILITY.FORMAT_ERROR_BACKTRACE); -- 3.0
  END;

  FUNCTION FNC_GET_IDINSXPAQ RETURN NUMBER IS
    L_IDINSXPAQ INSTANCIA_PAQUETE_CAMBIO.IDINSXPAQ%TYPE;

  BEGIN
    SELECT MAX(IDINSXPAQ) + 1
      INTO L_IDINSXPAQ
      FROM INSTANCIA_PAQUETE_CAMBIO;

    RETURN L_IDINSXPAQ;
  EXCEPTION
    -- INI 3.0
    WHEN OTHERS THEN
      G_MSJ_ERR := 'ERROR AL EJECUTAR FNC: ' || $$PLSQL_UNIT || '.' ||
                   'FNC_GET_IDINSXPAQ, ' || CHR(13) || 'CODIGO DE ERROR: ' ||
                   TO_CHAR(SQLCODE) || CHR(13) || 'MENSAJE DE ERROR: ' ||
                   TO_CHAR(SQLERRM); -- 3.0
      OPERACION.PQ_SIAC_CAMBIO_PLAN.P_INSERT_LOG_POST_SIAC(G_COD_ID,
                                                           G_CUSTOMERID,
                                                           G_PROCESO,
                                                           G_MSJ_ERR); -- 3.0
      RAISE_APPLICATION_ERROR(-20000,
                              G_MSJ_ERR || CHR(13) || ' TRAZA DE ERROR:   ' ||
                              DBMS_UTILITY.FORMAT_ERROR_BACKTRACE); -- 3.0
  END;

  FUNCTION FNC_GET_SUCURSAL(P_CODSUC VTASUCCLI.CODSUC%TYPE)
    RETURN VTASUCCLI%ROWTYPE IS
    L_SUCURSAL VTASUCCLI%ROWTYPE;

  BEGIN
    SELECT * INTO L_SUCURSAL FROM VTASUCCLI WHERE CODSUC = P_CODSUC;

    RETURN L_SUCURSAL;
  EXCEPTION
    -- INI 3.0
    WHEN OTHERS THEN
      G_MSJ_ERR := 'ERROR AL EJECUTAR FNC: ' || $$PLSQL_UNIT || '.' ||
                   'FNC_GET_SUCURSAL, ' || CHR(13) || 'P_CODSUC: ' ||
                   TO_CHAR(P_CODSUC) || CHR(13) || 'CODIGO DE ERROR: ' ||
                   TO_CHAR(SQLCODE) || CHR(13) || 'MENSAJE DE ERROR: ' ||
                   TO_CHAR(SQLERRM); -- 3.0
      OPERACION.PQ_SIAC_CAMBIO_PLAN.P_INSERT_LOG_POST_SIAC(G_COD_ID,
                                                           G_CUSTOMERID,
                                                           G_PROCESO,
                                                           G_MSJ_ERR); -- 3.0
      RAISE_APPLICATION_ERROR(-20000,
                              G_MSJ_ERR || CHR(13) || ' TRAZA DE ERROR:   ' ||
                              DBMS_UTILITY.FORMAT_ERROR_BACKTRACE); -- 3.0
  END;

  FUNCTION FNC_VALIDAR_PRODUCTO_SLA(P_NUMSLC VTATABSLCFAC.NUMSLC%TYPE)
    RETURN NUMBER IS
    L_VALIDA NUMBER;
    L_DOCUM  NUMBER;
    L_CUENTA NUMBER;

    -- BUSCAMOS LOS PRODUCTOS
    CURSOR C_VAL_PRD IS
      SELECT UNIQUE A.IDPRODUCTO || '|' || A.CODSRV AS PRODUCTO
        FROM SALES.VTADETPTOENL A, BILLCOLPER.PRODUCTO B
       WHERE A.NUMSLC = P_NUMSLC
         AND A.IDPRODUCTO = B.IDPRODUCTO
         AND A.CREPTO = '1'
         AND B.IDGRUPOPRODUCTO IS NULL;

    -- BUSCAMOS TIPO DOCUMENTO
    CURSOR C_VAL_DOC IS
      SELECT UNIQUE IDTIPDOC FROM PROYECTO_DOC WHERE NUMSLC = P_NUMSLC;

  BEGIN
    L_VALIDA := 0;

    FOR LX IN C_VAL_PRD LOOP
      -- VALIDAMOS SLA
      SELECT PQ_VALIDA.F_VALIDA('VALIDACIONSLA', LX.PRODUCTO)
        INTO L_VALIDA
        FROM DUAL;

      IF L_VALIDA = 1 THEN
        L_DOCUM := 0;

        FOR LI IN C_VAL_DOC LOOP
          -- BUSCAMOS DOCUMENTOS SLA
          SELECT PQ_VALIDA.F_VALIDA('DOCUMENTOSLA', LI.IDTIPDOC)
            INTO L_CUENTA
            FROM DUAL;

          IF L_CUENTA = 1 THEN
            L_DOCUM := L_DOCUM + 1;
          END IF;
        END LOOP;

        IF L_DOCUM = 1 THEN
          L_VALIDA := 0;
        ELSIF L_DOCUM > 1 THEN
          L_VALIDA := 2;
        ELSE
          L_VALIDA := 1;
        END IF;
        RETURN(L_VALIDA);
      END IF;
    END LOOP;
    RETURN L_VALIDA;
  END;

  FUNCTION FNC_SERVICIO_PRINCIPAL(P_IDGRUPO SALES.GRUPO_SISACT_LTE.IDGRUPO_SISACT%TYPE)
    RETURN BOOLEAN IS
    L_CNT NUMBER;
  BEGIN
    SELECT COUNT(*)
      INTO L_CNT
      FROM SALES.CRMDD D, SALES.TIPCRMDD C
     WHERE D.TIPCRMDD = C.TIPCRMDD
       AND C.ABREV = 'CONF_GRP_LTE'
       AND D.ABREVIACION = 'GRP_PRI'
       AND D.CODIGOC = P_IDGRUPO;

    IF L_CNT > 0 THEN
      RETURN TRUE;
    ELSE
      RETURN FALSE;
    END IF;
  END;

  FUNCTION FNC_SERVICIO_ADICIONAL(P_IDGRUPO SALES.GRUPO_SISACT_LTE.IDGRUPO_SISACT%TYPE)
    RETURN BOOLEAN IS
    L_CNT NUMBER;
  BEGIN
    SELECT COUNT(*)
      INTO L_CNT
      FROM SALES.CRMDD D, SALES.TIPCRMDD C
     WHERE D.TIPCRMDD = C.TIPCRMDD
       AND C.ABREV = 'CONF_GRP_LTE'
       AND D.ABREVIACION = 'GRP_ADI'
       AND D.CODIGOC = P_IDGRUPO;

    IF L_CNT > 0 THEN
      RETURN TRUE;
    ELSE
      RETURN FALSE;
    END IF;
  END;

  FUNCTION FNC_GET_CODSRV_COMODATO(P_IDGRUPO SALES.GRUPO_SISACT_LTE.IDGRUPO_SISACT%TYPE)
    RETURN SALES.TYSTABSRV.CODSRV%TYPE IS
    L_TIPO_SERVICIO BILLCOLPER.PRODUCTO.TIPSRV%TYPE;
  BEGIN
    SELECT B.TIPSRV
      INTO L_TIPO_SERVICIO
      FROM SALES.GRUPO_SISACT_LTE A, BILLCOLPER.PRODUCTO B
     WHERE A.IDPRODUCTO = B.IDPRODUCTO
       AND A.IDGRUPO_SISACT = P_IDGRUPO;

    RETURN SALES.PQ_COMODATO_SISACT_CP_LTE.GET_CODSRV_COMODATO(L_TIPO_SERVICIO);
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN NULL;
  END;

  FUNCTION FNC_SERVICIO_COMODATO(P_IDGRUPO           SALES.GRUPO_SISACT_LTE.IDGRUPO_SISACT%TYPE,
                                 P_IDGRUPO_PRINCIPAL SALES.GRUPO_SISACT_LTE.IDGRUPO_SISACT%TYPE)
    RETURN BOOLEAN IS
    L_CNT NUMBER;
  BEGIN

    SELECT COUNT(*)
      INTO L_CNT
      FROM SALES.CRMDD D, SALES.TIPCRMDD C
     WHERE D.TIPCRMDD = C.TIPCRMDD
       AND C.ABREV = 'CONF_GRP_LTE'
       AND D.ABREVIACION = 'GRP_COM'
       AND D.CODIGOC = P_IDGRUPO;

    IF L_CNT > 0 AND FNC_SERVICIO_PRINCIPAL(P_IDGRUPO_PRINCIPAL) THEN
      RETURN TRUE;
    ELSE
      RETURN FALSE;
    END IF;
  END;

  FUNCTION FNC_SERVICIO_ALQUILER(P_IDGRUPO           SALES.GRUPO_SISACT_LTE.IDGRUPO_SISACT%TYPE,
                                 P_IDGRUPO_PRINCIPAL SALES.GRUPO_SISACT_LTE.IDGRUPO_SISACT%TYPE)
    RETURN BOOLEAN IS
    L_CNT NUMBER;
  BEGIN

    SELECT COUNT(*)
      INTO L_CNT
      FROM SALES.CRMDD D, SALES.TIPCRMDD C
     WHERE D.TIPCRMDD = C.TIPCRMDD
       AND C.ABREV = 'CONF_GRP_LTE'
       AND D.ABREVIACION = 'GRP_ALQ'
       AND D.CODIGOC = P_IDGRUPO;

    IF L_CNT > 0 AND FNC_SERVICIO_PRINCIPAL(P_IDGRUPO_PRINCIPAL) THEN
      RETURN TRUE;
    ELSE
      RETURN FALSE;
    END IF;
  END;

  FUNCTION FNC_GET_AGENDA(ID_SIAC OPERACION.SIAC_POSTVENTA_PROCESO.IDPROCESS%TYPE)
    RETURN NUMBER IS
    L_FLG_AGENDA CHAR(1);
  BEGIN
    SELECT DECODE(FLAG_ACT_DIR_FACT, NULL, '0', FLAG_ACT_DIR_FACT) -- 3.0
      INTO L_FLG_AGENDA
      FROM OPERACION.SIAC_POSTVENTA_PROCESO
     WHERE IDPROCESS = ID_SIAC;

    IF L_FLG_AGENDA = '1' THEN
      RETURN 1;
    ELSE
      RETURN 0;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN 1;
  END;

  FUNCTION FNC_VALIDA_AGENDA_LTE(P_CODSOLOT OPERACION.SOLOT.CODSOLOT%TYPE)
    RETURN NUMBER IS
    L_GEN_AGE NUMBER;
  BEGIN
    -- ini 2.0
    -- PROYECTOS LTE
    SELECT COUNT(1)
      INTO L_GEN_AGE
      FROM SALES.VTATABSLCFAC       A,
           INSTANCIA_PAQUETE_CAMBIO I,
           OPERACION.SOLOT          B
     WHERE A.NUMSLC = B.NUMSLC
       AND B.NUMSLC = I.NUMSLC
       AND B.CODSOLOT = P_CODSOLOT
       AND A.FLG_AGENDA = 1
       AND I.FLG_TIPO_VM = 'CP'
       AND A.IDSOLUCION IN (SELECT SO.IDSOLUCION
                              FROM SOLUCIONES SO
                             WHERE SO.FLG_SISACT_SGA = 2);

    IF L_GEN_AGE > 0 THEN
      RETURN 1; -- PROYECTOS LTE GENERA AGENDA.
    ELSE
      RETURN 0; -- PROYECTOS LTE NO GENERA AGENDA.
    END IF;
    -- FIN 2.0
  EXCEPTION
    WHEN OTHERS THEN
      G_MSJ_ERR := 'ERROR AL EJECUTAR FNC: ' || $$PLSQL_UNIT || '.' ||
                   'FNC_VALIDA_AGENDA_LTE, ' || CHR(13) || 'P_CODSOLOT: ' ||
                   TO_CHAR(P_CODSOLOT) || CHR(13) || 'CODIGO DE ERROR: ' ||
                   TO_CHAR(SQLCODE) || CHR(13) || 'MENSAJE DE ERROR: ' ||
                   TO_CHAR(SQLERRM); -- 3.0
      OPERACION.PQ_SIAC_CAMBIO_PLAN.P_INSERT_LOG_POST_SIAC(G_COD_ID,
                                                           G_CUSTOMERID,
                                                           G_PROCESO,
                                                           G_MSJ_ERR); -- 3.0
      RAISE_APPLICATION_ERROR(-20000,
                              G_MSJ_ERR || CHR(13) || ' TRAZA DE ERROR:   ' ||
                              DBMS_UTILITY.FORMAT_ERROR_BACKTRACE); -- 3.0
  END;

  -- INI 2.0
  FUNCTION FNC_VALIDA_CP_LTE(P_CODSOLOT OPERACION.SOLOT.CODSOLOT%TYPE)
    RETURN NUMBER IS
    L_VAL_LTE NUMBER;
  BEGIN
    SELECT COUNT(1)
      INTO L_VAL_LTE
      FROM SALES.VTATABSLCFAC       A,
           INSTANCIA_PAQUETE_CAMBIO I,
           OPERACION.SOLOT          B
     WHERE A.NUMSLC = B.NUMSLC
       AND B.NUMSLC = I.NUMSLC
       AND B.CODSOLOT = P_CODSOLOT
       AND I.FLG_TIPO_VM = 'CP'
       AND A.IDSOLUCION IN (SELECT SO.IDSOLUCION
                              FROM SOLUCIONES SO
                             WHERE SO.FLG_SISACT_SGA = 2);

    IF L_VAL_LTE > 0 THEN
      RETURN 1; -- PROYECTOS LTE CP
    ELSE
      RETURN 0; -- PROYECTOS NO LTE CP
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      G_MSJ_ERR := 'ERROR AL EJECUTAR FNC: ' || $$PLSQL_UNIT || '.' ||
                   'FNC_VALIDA_CP_LTE, ' || CHR(13) || 'P_CODSOLOT: ' ||
                   TO_CHAR(P_CODSOLOT) || CHR(13) || 'CODIGO DE ERROR: ' ||
                   TO_CHAR(SQLCODE) || CHR(13) || 'MENSAJE DE ERROR: ' ||
                   TO_CHAR(SQLERRM); -- 3.0
      OPERACION.PQ_SIAC_CAMBIO_PLAN.P_INSERT_LOG_POST_SIAC(G_COD_ID,
                                                           G_CUSTOMERID,
                                                           G_PROCESO,
                                                           G_MSJ_ERR); -- 3.0
      RAISE_APPLICATION_ERROR(-20000,
                              G_MSJ_ERR || CHR(13) || ' TRAZA DE ERROR:   ' ||
                              DBMS_UTILITY.FORMAT_ERROR_BACKTRACE); -- 3.0
  END;
  -- FIN 2.0

   FUNCTION FNC_GET_DATOS_CP(P_NUMSLC OPERACION.SOLOT.NUMSLC%TYPE,
                            P_TIPEQU OPERACION.SOLOTPTOEQU.TIPEQU%TYPE,
                            P_TIPSRV SALES.TYSTABSRV.TIPSRV%TYPE,
                            P_TIPO   VARCHAR2) RETURN VARCHAR2 IS

    L_NUMSLC_ORI  SALES.REGVTAMENTAB.NUMSLC_ORI%TYPE;
    l_codsolot_cp OPERACION.SOLOT.CODSOLOT%TYPE;
    L_COD_ID      OPERACION.SOLOT.COD_ID_OLD%TYPE;
    L_CUSTOMER    OPERACION.SOLOT.CUSTOMER_ID%TYPE;
    L_NUMSERIE    OPERACION.SOLOTPTOEQU.NUMSERIE%TYPE;
    L_SIMCARD     OPERACION.SOLOTPTOEQU.NUMSERIE%TYPE;
    L_MAC         OPERACION.SOLOTPTOEQU.MAC%TYPE;
    lv_tipo       tipequ.tipo%type;

  BEGIN

    SELECT vta.NUMSLC_ORI, s.codsolot
      INTO L_NUMSLC_ORI, l_codsolot_cp
      FROM SALES.REGVTAMENTAB vta, solot s
     WHERE vta.numslc = s.numslc
       and vta.NUMSLC = P_NUMSLC;

  SELECT DISTINCT /*S.CODSOLOT,*/ S.CUSTOMER_ID, S.COD_ID
      INTO /*L_SOLOT_ORI,*/ L_CUSTOMER, L_COD_ID
      FROM OPERACION.SOLOT S, SOLOT SOLD
     WHERE S.NUMSLC = L_NUMSLC_ORI
       AND OPERACION.PQ_SGA_IW.F_MAX_SOT_X_COD_ID(SOLD.COD_ID_OLD) = S.CODSOLOT
       AND SOLD.CODSOLOT = l_codsolot_cp;

    if p_tipsrv in ('0006', '0004') then
      select ti.tipo
        into lv_tipo
        from tipequ ti
       where ti.tipequ = P_TIPEQU;

      SELECT DISTINCT s.mac numero,
                      s.numserie sim_card,
                      (SELECT DISTINCT a.numserie
                         FROM solotptoequ                  a,
                              operacion.tabequipo_material bb
                        WHERE a.numserie = bb.numero_serie
                          AND bb.tipo = 4
                          AND a.codsolot =
                              (select max(sot.codsolot)
                                 from solot                        sot,
                                      solotptoequ                  equ,
                                      operacion.tabequipo_material tem
                                where sot.codsolot = equ.codsolot
                                  and tem.numero_serie = equ.numserie
                                  and sot.estsol in (12, 29)
                                  and sot.customer_id = sl.customer_id
                                  and equ.estado != 12
                                  and tem.tipo = 4)
                          AND A.ESTADO != 12) numserie
        INTO L_MAC, L_SIMCARD, L_NUMSERIE
        FROM solotptoequ                  s,
             tipequ                       ti,
             almtabmat                    m,
             operacion.tabequipo_material d,
             operacion.solotpto           b,
             inssrv                       i,
             solot                        sl
       WHERE sl.cod_id = L_COD_ID
         AND sl.customer_id = L_CUSTOMER
         AND s.codsolot = sl.codsolot
         AND s.tipequ = ti.tipequ
         AND m.codmat = ti.codtipequ
         AND s.numserie = d.numero_serie
         AND s.codsolot = b.codsolot
         AND b.codinssrv = i.codinssrv
         and sl.estsol in (12, 29)
         and S.ESTADO != 12
         AND d.tipo = 3
         AND sl.codsolot = (select max(sot.codsolot)
                              from solot                        sot,
                                   solotptoequ                  equ,
                                   operacion.tabequipo_material tem
                             where sot.codsolot = equ.codsolot
                               and tem.numero_serie = equ.numserie
                               and sot.estsol in (12, 29)
                               and sot.customer_id = sl.customer_id
                               and sot.cod_id = sl.cod_id
                               and equ.estado != 12
                               and tem.tipo = 3);

      IF P_TIPO = 'NUMSERIE' THEN
        IF lv_tipo = 'SMART CARD' THEN
          RETURN L_SIMCARD;
        ELSE
          RETURN L_NUMSERIE;
        END IF;
      ELSIF P_TIPO = 'MAC' THEN
        RETURN L_MAC;
      END IF;
    else
      select distinct x.numserieequ, x.mac
        INTO L_NUMSERIE, L_MAC
        from (select distinct equ.tipequ, equ.numserie numserieequ, equ.mac
                from solotptoequ                  equ,
                     solot                        s,
                     operacion.tabequipo_material tm
               where s.codsolot = equ.codsolot
                 and equ.numserie = tm.numero_serie
                 and s.cod_id = L_COD_ID
                 and s.estsol in (12, 29)
                 and tm.tipo in (1, 2) -- Decodificadores, Tarjeta
                 and equ.estado in (4, 15)
                 and not exists
               (select 1
                        from solotptoequ equb, solot sb
                       where equb.codsolot = sb.codsolot
                         and sb.cod_id = s.cod_id
                         and equb.numserie = tm.numero_serie
                         and equb.estado = 12
                         and sb.estsol in (12, 29))) x
       where x.tipequ = P_TIPEQU
         and not exists (select 1
                from solotptoequ equnew
               where equnew.codsolot = l_codsolot_cp
                 and x.numserieequ = equnew.numserie)
         and rownum = 1;

      IF P_TIPO = 'NUMSERIE' THEN
        RETURN L_NUMSERIE;
      ELSIF P_TIPO = 'MAC' THEN
        RETURN L_MAC;
      END IF;

    end if;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN NULL;
  END;

  FUNCTION GET_POSTVENTA_CODSOLOT(P_IDPROCESS SIAC_POSTVENTA_PROCESO.IDPROCESS%TYPE)
    RETURN SOLOT.CODSOLOT%TYPE IS
    L_CODSOLOT SOLOT.CODSOLOT%TYPE;
  BEGIN

    SELECT A.CODSOLOT
      INTO L_CODSOLOT
      FROM OPERACION.SIAC_POSTVENTA_PROCESO A
     WHERE A.IDPROCESS = P_IDPROCESS;

    RETURN L_CODSOLOT;

  EXCEPTION
    WHEN OTHERS THEN
      G_MSJ_ERR := 'ERROR AL EJECUTAR SP: ' || $$PLSQL_UNIT || '.' ||
                   'GET_POSTVENTA_CODSOLOT, ' || CHR(13) ||
                   'CODIGO DE ERROR: ' || TO_CHAR(SQLCODE) || CHR(13) ||
                   'MENSAJE DE ERROR: ' || TO_CHAR(SQLERRM); -- 3.0
      OPERACION.PQ_SIAC_CAMBIO_PLAN.P_INSERT_LOG_POST_SIAC(G_COD_ID,
                                                           G_CUSTOMERID,
                                                           G_PROCESO,
                                                           G_MSJ_ERR); -- 3.0
      RAISE_APPLICATION_ERROR(-20000,
                              G_MSJ_ERR || CHR(13) || ' TRAZA DE ERROR:   ' ||
                              DBMS_UTILITY.FORMAT_ERROR_BACKTRACE); -- 3.0
  END;
  -- Ini 3.0
  PROCEDURE SGASS_REGINSPRDBAJA(P_NUMSLC VTATABSLCFAC.NUMSLC%TYPE,
                                P_COD_ID SALES.SOT_SISACT.COD_ID%TYPE) IS

  BEGIN
    INSERT INTO SALES.REGINSPRDBAJA
      (PID, NUMREGISTRO, NUMSLC, CODINSSRV)
      SELECT DISTINCT P.PID, G_NUMREGISTRO, P_NUMSLC, P.CODINSSRV
        FROM OPERACION.INSSRV S, OPERACION.INSPRD P, OPERACION.SOLOTPTO PTO
       WHERE S.CODINSSRV = P.CODINSSRV
         AND PTO.CODINSSRV = S.CODINSSRV
         AND S.NUMSLC = P_NUMSLC
         AND PTO.CODSOLOT =
             OPERACION.PQ_SIAC_POSTVENTA.F_MAX_SOT_SIAC_SISACT(P_COD_ID)
         AND P.ESTINSPRD IN (G_ACTIVO, G_SUSPENDIDO, G_PENDIENTE_X_ACTIVAR)
         AND P.FECFIN IS NULL;
  EXCEPTION
    WHEN OTHERS THEN
      G_MSJ_ERR := $$PLSQL_UNIT || '.' || 'SP_REGINSPRDBAJA: ' || SQLERRM ||
                   ' - Linea (' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ')';
      OPERACION.PQ_SIAC_CAMBIO_PLAN.P_INSERT_LOG_POST_SIAC(G_COD_ID,
                                                           G_CUSTOMERID,
                                                           G_PROCESO,
                                                           G_MSJ_ERR);
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.' || 'SP_REGINSPRDBAJA: ' ||
                              SQLERRM);

  END;

  PROCEDURE SGASP_REGLA_LTE(p_customer_id IN operacion.solot.customer_id%TYPE,
                            p_lista       IN OUT gc_lista,
                            p_resp        OUT NUMBER,
                            p_mens        OUT VARCHAR2) IS
  BEGIN
    SGASP_EQU_RECUP(p_customer_id, p_lista, p_resp, p_mens);

  END SGASP_REGLA_LTE;

  PROCEDURE SGASP_EQU_RECUP(p_customer_id IN operacion.solot.customer_id%TYPE,
                            p_lista       IN gc_lista,
                            p_resp        OUT NUMBER,
                            p_mens        OUT VARCHAR2) IS

    wn_tot_dec_act NUMBER;
    wn_tipequ      operacion.tipequ.tipequ%type;
    wn_codtipequ   operacion.tipequ.codtipequ%type;
    wv_descripcion operacion.tipequ.descripcion%type;
    wv_equipo      varchar2(300);
    wn_cant_equipo number;
  BEGIN
    p_resp := 1;

    loop
      fetch p_lista
        into wn_tipequ,
             wn_codtipequ,
             wv_descripcion,
             wv_equipo,
             wn_cant_equipo;
      exit when p_lista%notfound;
      null;
    end loop;
    close p_lista;

    select count(*)
      into wn_tot_dec_act
      from tipequ b,
           operacion.solotptoequ a,
           (select codsolot
              from tiptrabajo v, operacion.solot s
             where v.tiptrs = 1
               and v.tiptra = s.tiptra
               and s.estsol in (12, 29)
               and s.customer_id = p_customer_id) x
     where exists (select x.*
              from opedd x, tipopedd y
             where x.tipopedd = y.tipopedd
               and y.abrev in ('TIPEQU_RECUPERABLE_HFC')
               and x.codigon = b.tipequ)
       and b.tipequ = a.tipequ
       and a.codsolot = x.codsolot;

    IF wn_tot_dec_act = 0 THEN
      p_resp := 1;
    END IF;

  EXCEPTION
    WHEN no_data_found THEN
      p_resp := 0;
    WHEN OTHERS THEN
      p_resp := -1;
      p_mens := SQLERRM;
  END SGASP_EQU_RECUP;
  -- Fin 3.0
  --ini 4.0
  FUNCTION SGAFUN_VALIDA_CB_PLAN(P_CODSOLOT OPERACION.SOLOT.CODSOLOT%TYPE)
    RETURN NUMBER IS
    LN_TIPTRA     NUMBER;
    LN_TIPTRA_SOT NUMBER;
    LV_MSJ_ERR    VARCHAR2(4000);
  BEGIN

    SELECT A.CODIGON
      INTO LN_TIPTRA
      FROM OPERACION.OPEDD A, OPERACION.TIPOPEDD B
     WHERE A.TIPOPEDD = B.TIPOPEDD
       AND B.ABREV IN ('TIPTRA_HFC_LTE_CP')
       AND A.ABREVIACION IN ('LTE_SIAC_CPLAN');

    SELECT S.TIPTRA
      INTO LN_TIPTRA_SOT
      FROM OPERACION.SOLOT S
     WHERE S.CODSOLOT = P_CODSOLOT;

    IF LN_TIPTRA_SOT = LN_TIPTRA THEN
      RETURN 1; -- SOT - LTE CAMBIO DE PLAN
    ELSE
      RETURN 0; -- SOT - NO ES LTE CAMBIO DE PLAN
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      LV_MSJ_ERR := 'ERROR AL EJECUTAR FNC: ' || $$PLSQL_UNIT || '.' ||
                    'SGAFUN_VALIDA_CB_PLAN, ' || CHR(13) || 'P_CODSOLOT: ' ||
                    TO_CHAR(P_CODSOLOT) || CHR(13) || 'CODIGO DE ERROR: ' ||
                    TO_CHAR(SQLCODE) || CHR(13) || 'MENSAJE DE ERROR: ' ||
                    TO_CHAR(SQLERRM); -- 3.0
      OPERACION.PQ_SIAC_CAMBIO_PLAN.P_INSERT_LOG_POST_SIAC(G_COD_ID,
                                                           G_CUSTOMERID,
                                                           G_PROCESO,
                                                           LV_MSJ_ERR);
      RAISE_APPLICATION_ERROR(-20000,
                              LV_MSJ_ERR || CHR(13) ||
                              ' TRAZA DE ERROR:   ' ||
                              DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
  END;

  FUNCTION SGAFUN_VALIDA_CB_PLAN_VISITA(P_CODSOLOT OPERACION.SOLOT.CODSOLOT%TYPE)
    RETURN NUMBER IS
    LN_TIPTRA       NUMBER;
    LN_TIPTRA_SOT   NUMBER;
    LN_CODMOTOT     NUMBER;
    LN_CODMOTOT_PAR NUMBER;
    LV_MSJ_ERR      VARCHAR2(4000);
  BEGIN

    SELECT A.CODIGON
      INTO LN_TIPTRA
      FROM OPERACION.OPEDD A, OPERACION.TIPOPEDD B
     WHERE A.TIPOPEDD = B.TIPOPEDD
       AND B.ABREV IN ('TIPTRA_HFC_LTE_CP')
       AND A.ABREVIACION IN ('LTE_SIAC_CPLAN');

    SELECT S.TIPTRA, S.CODMOTOT
      INTO LN_TIPTRA_SOT, LN_CODMOTOT
      FROM OPERACION.SOLOT S
     WHERE S.CODSOLOT = P_CODSOLOT;

    SELECT T.CODIGON
      INTO LN_CODMOTOT_PAR
      FROM OPERACION.OPEDD T
     WHERE T.ABREVIACION = 'LTE_SI_VISTA'
       AND T.TIPOPEDD =
           (SELECT TP.TIPOPEDD
              FROM OPERACION.TIPOPEDD TP
             WHERE TP.ABREV = 'TIPO_MOT_HFC_LTE_VIS');

    IF LN_TIPTRA_SOT = LN_TIPTRA AND LN_CODMOTOT = LN_CODMOTOT_PAR THEN
      RETURN 1; -- SOT - LTE CAMBIO DE PLAN SIN VISITA (NO GENERA AGENDA)
    ELSE
      RETURN 0; -- SOT - LTE CAMBIO DE PLAN CON VISITA (GENERA AGENDA)
    END IF;

  EXCEPTION
    WHEN OTHERS THEN
      LV_MSJ_ERR := 'ERROR AL EJECUTAR FNC: ' || $$PLSQL_UNIT || '.' ||
                    'SGAFUN_VALIDA_CB_PLAN_VISITA, ' || CHR(13) ||
                    'P_CODSOLOT: ' || TO_CHAR(P_CODSOLOT) || CHR(13) ||
                    'CODIGO DE ERROR: ' || TO_CHAR(SQLCODE) || CHR(13) ||
                    'MENSAJE DE ERROR: ' || TO_CHAR(SQLERRM);
      OPERACION.PQ_SIAC_CAMBIO_PLAN.P_INSERT_LOG_POST_SIAC(G_COD_ID,
                                                           G_CUSTOMERID,
                                                           G_PROCESO,
                                                           LV_MSJ_ERR);
      RAISE_APPLICATION_ERROR(-20000,
                              LV_MSJ_ERR || CHR(13) ||
                              ' TRAZA DE ERROR:   ' ||
                              DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
  END;

  PROCEDURE SGASI_CARGA_EQUDTH_LTE_CP(a_codsolot solot.codsolot%type) is

    ln_coid_old   operacion.solot.cod_id_old%type;
    raise_cod_null  exception;
    RAISE_TELEFONIA EXCEPTION;
    lv_mensaje      varchar2(4000);
    ln_codsolot_old solot.codsolot%type;
    lv_codcli       solot.codcli%type;
    v_error         number;
    v_mensaje       varchar2(4000);
    ln_valida       number;

    cursor c_equ_dth is
      select x.numserie,
           x.idequipo,
           x.imei_esn_ua nro_serie_deco,
           (select distinct tma.idequipo
              from operacion.tabequipo_material tma
             where tma.numero_serie = x.nro_serie_tarjeta) idtarjeta,
           x.nro_serie_tarjeta
      from (select distinct equ.numserie,
                            tm.idequipo,
                            tm.imei_esn_ua,
                            (select distinct d.nro_serie_tarjeta
                               from operacion.tabequipo_material c,
                                    operacion.tarjeta_deco_asoc  d,
                                    solot                        sl
                              where sl.codcli = s.codcli
                                and sl.cod_id = s.cod_id_old
                                and sl.estsol in (12, 29)
                                and c.numero_serie = tm.numero_serie
                                and c.imei_esn_ua = tm.imei_esn_ua
                                and sl.codsolot = d.codsolot
                                and d.nro_serie_deco = c.imei_esn_ua
                                and c.tipo = 2
                                and not exists
                              (select 1
                                       from solot                        sot,
                                            solotptoequ                  ptoequ,
                                            operacion.tabequipo_material tem
                                      where sot.codsolot = ptoequ.codsolot
                                        and ptoequ.numserie = tem.numero_serie
                                        and tem.tipo = 2
                                        and sot.estsol in (12, 29)
                                        and sot.cod_id = sl.cod_id
                                        and ptoequ.numserie = c.numero_serie
                                        and ptoequ.estado = 12)) nro_serie_tarjeta
              from solotptoequ                  equ,
                   solot                        s,
                   tipequ                       te,
                   operacion.tabequipo_material tm
             where s.codsolot = equ.codsolot
               and te.tipequ = equ.tipequ
               and equ.numserie = tm.numero_serie
               and s.codsolot = a_codsolot
               and tm.tipo = 2
               and equ.estado in (4, 15)) x;
  begin

    if operacion.pq_siac_cambio_plan_lte.sgafun_valida_cb_plan(a_codsolot) != 1 then
      return;
    end if;

    select s.cod_id_old,
           operacion.pq_sga_iw.f_max_sot_x_cod_id(s.cod_id_old),
           s.codcli
      into ln_coid_old, ln_codsolot_old, lv_codcli
      from operacion.solot s
     where s.codsolot = a_codsolot;

    if ln_coid_old is null then
      raise raise_cod_null;
    end if;

    --ASOCIAR EQUIPOS - Inserto la asociacion de la sot Anterior
    --DECOS
    for e in c_equ_dth loop

      Begin

        select count(1)
          into ln_valida
          from operacion.tarjeta_deco_asoc td
         where td.codsolot = a_codsolot
           and td.nro_serie_deco = e.nro_serie_deco
           and td.nro_serie_tarjeta = e.nro_serie_tarjeta;

        if ln_valida = 0 then

          insert into operacion.tarjeta_deco_asoc
            (CODSOLOT,
             IDDET_DECO,
             NRO_SERIE_DECO,
             IDDET_TARJETA,
             NRO_SERIE_TARJETA)
          values
            (a_codsolot,
             e.idequipo,
             e.nro_serie_deco,
             e.idtarjeta,
             e.nro_serie_tarjeta);
        end if;

      Exception
        when others then
          RAISE_APPLICATION_ERROR(-20500,
                                  'Al asociar los datos de la tarjeta y deco, Serie Tarjeta: ');
      End;
    end loop;

    --INI 15.0  Actualizamos todos equipos a Refrescar
    begin
      update operacion.solotptoequ se
         set se.estado = 15
       where se.codsolot = a_codsolot;
    exception
      when others then
        null;
    end;
    --FIN 15.0

  Exception
    when raise_cod_null then
      RAISE_APPLICATION_ERROR(-20500,
                              'Error al encontrar el contrato anterior, SOT: ' ||
                              a_codsolot);
    WHEN OTHERS THEN
      OPERACION.PQ_3PLAY_INALAMBRICO.P_LOG_3PLAYI(a_codsolot,
                                                            'SGASI_CARGA_EQUDTH_LTE_CP',
                                                            LV_MENSAJE,
                                                            'SGASI_CARGA_EQUDTH_LTE_CP',
                                                            V_ERROR,
                                                            V_MENSAJE);

      RAISE_APPLICATION_ERROR(-20500, LV_MENSAJE);
  END;

  FUNCTION SGAFUN_GET_COD_ID_ANT(P_CUSTOMER_ID IN OPERACION.SOLOT.CUSTOMER_ID%TYPE)
    RETURN NUMBER IS
    LN_CO_ID NUMBER;
  BEGIN

    SELECT T.CO_ID
      INTO LN_CO_ID
      FROM TIM.LTE_INFO_COMERCIAL@DBL_BSCS_BF T
     WHERE T.CUSTOMER_ID = P_CUSTOMER_ID
       AND T.SEQ = (SELECT MAX(V.SEQ) - 1
                      FROM TIM.LTE_INFO_COMERCIAL@DBL_BSCS_BF V
                     WHERE V.CUSTOMER_ID = T.CUSTOMER_ID);

    RETURN LN_CO_ID;

  END;

  FUNCTION SGAFUN_GET_NUMERO_TELF_ACT(P_CO_ID IN OPERACION.SOLOT.COD_ID%TYPE)
    RETURN NUMBER IS
    LN_NUMERO_TELF NUMBER;
    LN_CODSOLOT    NUMBER;
  BEGIN
    BEGIN
      SELECT MAX(S.CODSOLOT)
        INTO LN_CODSOLOT
        FROM OPERACION.SOLOT S, OPERACION.SOLOTPTOEQU SE
       WHERE S.CODSOLOT = SE.CODSOLOT
         AND SE.MAC IS NOT NULL
         AND SE.TIPEQU = 16308
         AND S.COD_ID = P_CO_ID;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        LN_CODSOLOT := NULL;
    END;

    IF LN_CODSOLOT IS NULL THEN
      LN_NUMERO_TELF := NULL;
    ELSE
      SELECT SE.MAC
        INTO LN_NUMERO_TELF
        FROM OPERACION.SOLOT S, OPERACION.SOLOTPTOEQU SE
       WHERE S.CODSOLOT = SE.CODSOLOT
         AND SE.MAC IS NOT NULL
         AND SE.TIPEQU = 16308
         AND S.COD_ID = P_CO_ID
         AND S.CODSOLOT = LN_CODSOLOT;
    END IF;

    RETURN LN_NUMERO_TELF;

  END;

  PROCEDURE SGASS_CONTROL_SERVICIOS(p_codsolot     IN NUMBER,
                                    p_tip_serv     OUT VARCHAR2,
                                    p_codigo_resp  OUT NUMBER,
                                    p_mensaje_resp OUT VARCHAR2)

   IS

    ln_count_cb NUMBER;
    ln_count_te NUMBER;
    ln_count_it NUMBER;
    ln_cod_id   number;

  BEGIN

    p_codigo_resp := 1;

    --VALIDACION DE CONTRATO
    BEGIN
      SELECT S.COD_ID
        INTO ln_cod_id
        FROM OPERACION.SOLOT S
       WHERE S.CODSOLOT = p_codsolot;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        ln_cod_id := null;
    END;

    IF ln_cod_id IS NULL THEN
      p_codigo_resp  := -1;
      p_mensaje_resp := 'No tiene contratado asociado';
      RETURN;
    END IF;

    --VALIDACION DEL LOS SERVICIOS CONTRATADOS - CABLE
    SELECT COUNT(1)
      INTO ln_count_cb
      FROM OPERACION.INSSRV I
     WHERE I.CODINSSRV IN (SELECT SP.CODINSSRV
                             FROM OPERACION.SOLOTPTO SP
                            WHERE SP.CODSOLOT = p_codsolot)
       AND I.TIPSRV IN (SELECT C.VALOR
                          FROM OPERACION.CONSTANTE C
                         WHERE CONSTANTE IN ('FAM_CABLE'));

    --VALIDACION DEL LOS SERVICIOS CONTRATADOS - TELEFONIA
    SELECT COUNT(1)
      INTO ln_count_te
      FROM OPERACION.INSSRV I
     WHERE I.CODINSSRV IN (SELECT SP.CODINSSRV
                             FROM OPERACION.SOLOTPTO SP
                            WHERE SP.CODSOLOT = P_CODSOLOT)
       AND I.TIPSRV IN (SELECT C.VALOR
                          FROM OPERACION.CONSTANTE C
                         WHERE CONSTANTE IN ('FAM_TELEF'));

    --VALIDACION DEL LOS SERVICIOS CONTRATADOS - INTERNET
    SELECT COUNT(1)
      INTO ln_count_it
      FROM OPERACION.INSSRV I
     WHERE I.CODINSSRV IN (SELECT SP.CODINSSRV
                             FROM OPERACION.SOLOTPTO SP
                            WHERE SP.CODSOLOT = P_CODSOLOT)
       AND I.TIPSRV IN (SELECT C.VALOR
                          FROM OPERACION.CONSTANTE C
                         WHERE CONSTANTE IN ('FAM_INTERNET'));

    IF ln_count_cb > 0 AND ln_count_te > 0 AND ln_count_it > 0 THEN
      p_tip_serv := 'TP'; --AMBOS SERVICIOS (CABLE, TELEFONIA Y INTERNET)
    ELSIF ln_count_cb > 0 AND ln_count_it > 0 THEN
      p_tip_serv := 'CI'; --SOLO CABLE Y INTERNET
    ELSIF ln_count_cb > 0 AND ln_count_te > 0 THEN
      p_tip_serv := 'TP'; --SOLO CABLE Y TELEFONO INTERNET
    ELSIF ln_count_te > 0 AND ln_count_it > 0 THEN
      p_tip_serv := 'IJ'; --SOLO TELEFONO Y/O INTERNET
    ELSIF ln_count_cb > 0 THEN
      p_tip_serv := 'CX'; --SOLO CABLE
    ELSIF ln_count_te > 0 THEN
      p_tip_serv := 'IJ'; --SOLO TELEFONO
    ELSIF ln_count_it > 0 THEN
      p_tip_serv := 'IL'; --SOLO INTERNET
    ELSE
      p_tip_serv     := null;
      p_codigo_resp  := -1;
      p_mensaje_resp := 'No tiene ningun servicio contratado';
      RETURN;
    END IF;

  END;

  PROCEDURE SGASS_REGISTRO_ESTADO_LTE(p_codsolot       IN NUMBER,
                                      p_tipo_operacion IN VARCHAR2,
                                      p_codigo_resp    OUT NUMBER,
                                      p_mensaje_resp   OUT VARCHAR2) IS
    pragma autonomous_transaction;

    ln_customer_id number;
    ln_cod_id      number;
    lv_codcli      char(8);
    lv_descrip     varchar2(100);
    ln_tiempo_act  number;
    ln_tiempo_ree  number;
    ln_numero_ree  number;
    ln_count       number;

  BEGIN

    p_codigo_resp := 1;

    BEGIN
      select s.customer_id, s.cod_id, s.codcli
        into ln_customer_id, ln_cod_id, lv_codcli
        from operacion.solot s
       where s.codsolot = p_codsolot;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        p_codigo_resp  := -1;
        p_mensaje_resp := 'No existe la SOT';
        RETURN;
    END;

    IF ln_customer_id IS NULL THEN
      p_codigo_resp  := -1;
      p_mensaje_resp := 'No existe datos de la Customer ID';
      RETURN;
    END IF;

    IF ln_cod_id IS NULL THEN
      p_codigo_resp  := -1;
      p_mensaje_resp := 'No existe datos de la COD ID';
      RETURN;
    END IF;

    IF lv_codcli IS NULL THEN
      p_codigo_resp  := -1;
      p_mensaje_resp := 'No existe datos de la Cod. Cliente';
      RETURN;
    END IF;

    BEGIN
      select b.descripcion
        into lv_descrip
        from operacion.tipopedd a, operacion.opedd b
       where a.tipopedd = b.tipopedd
         and a.abrev = 'EST_GEST_PROV'
         and b.abreviacion = 'NPRV';
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        p_codigo_resp  := -1;
        p_mensaje_resp := 'No existe el estado en la tabla de parametros';
        RETURN;
    END;

    operacion.pq_3play_inalambrico.sgass_parametros('CONFG_TIP_PROV',
                                                    ln_tiempo_act,
                                                    ln_tiempo_ree,
                                                    ln_numero_ree,
                                                    p_codigo_resp,
                                                    p_mensaje_resp);

    IF p_codigo_resp = -1 THEN
      RETURN;
    END IF;

    IF p_tipo_operacion = 'TP' OR p_tipo_operacion = 'CX' OR
       p_tipo_operacion = 'CI' THEN

      select count(1)
        into ln_count
        from operacion.psgat_estservicio e
       where e.essen_cod_solot = p_codsolot
         and e.essev_cod_operacion = 'CX';

      IF ln_count = 0 THEN
        insert into operacion.psgat_estservicio
          (essev_cod_operacion,
           essen_cod_solot,
           essev_customer_id,
           essen_co_id,
           essen_cod_cli,
           essev_mensaje,
           essev_descripcion,
           essev_operacion,
           essev_estado,
           essen_n_reenvio,
           essen_n_reenvio_max)
        values
          ('CX',
           p_codsolot,
           ln_customer_id,
           ln_cod_id,
           lv_codcli,
           null,
           'Proceso de Conax',
           lv_descrip,
           'NPRV',
           0,
           ln_numero_ree);

        operacion.pq_3play_inalambrico.sgasi_logaprov(p_codsolot,
                                                      'NPRV',
                                                      'CX',
                                                      'INS',
                                                      null,
                                                      p_codigo_resp,
                                                      p_mensaje_resp);
      END IF;

    END IF;

    IF p_tipo_operacion = 'TP' OR p_tipo_operacion = 'IJ' OR
       p_tipo_operacion = 'CI' OR p_tipo_operacion = 'IL' THEN

      select count(1)
        into ln_count
        from operacion.psgat_estservicio e
       where e.essen_cod_solot = p_codsolot
         and e.essev_cod_operacion = 'IL';

      IF ln_count = 0 THEN
        insert into operacion.psgat_estservicio
          (essev_cod_operacion,
           essen_cod_solot,
           essev_customer_id,
           essen_co_id,
           essen_cod_cli,
           essev_mensaje,
           essev_descripcion,
           essev_operacion,
           essev_estado,
           essen_n_reenvio,
           essen_n_reenvio_max)
        values
          ('IL',
           p_codsolot,
           ln_customer_id,
           ln_cod_id,
           lv_codcli,
           null,
           'Proceso de IL',
           lv_descrip,
           'NPRV',
           0,
           ln_numero_ree);

        operacion.pq_3play_inalambrico.sgasi_logaprov(p_codsolot,
                                                      'NPRV',
                                                      'IL',
                                                      'INS',
                                                      null,
                                                      p_codigo_resp,
                                                      p_mensaje_resp);

      END IF;

      IF p_tipo_operacion <> 'IL' THEN

        select count(1)
          into ln_count
          from operacion.psgat_estservicio e
         where e.essen_cod_solot = p_codsolot
           and e.essev_cod_operacion = 'JN';

        IF ln_count = 0 THEN
          insert into operacion.psgat_estservicio
            (essev_cod_operacion,
             essen_cod_solot,
             essev_customer_id,
             essen_co_id,
             essen_cod_cli,
             essev_mensaje,
             essev_descripcion,
             essev_operacion,
             essev_estado,
             essen_n_reenvio,
             essen_n_reenvio_max)
          values
            ('JN',
             p_codsolot,
             ln_customer_id,
             ln_cod_id,
             lv_codcli,
             null,
             'Proceso de Janus',
             lv_descrip,
             'NPRV',
             0,
             ln_numero_ree);

          operacion.pq_3play_inalambrico.sgasi_logaprov(p_codsolot,
                                                        'NPRV',
                                                        'JN',
                                                        'INS',
                                                        null,
                                                        p_codigo_resp,
                                                        p_mensaje_resp);

        END IF;
      END IF;

    END IF;

    COMMIT;

  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      p_codigo_resp  := -1;
      p_mensaje_resp := 'Error al update operacion.psgat_estservicio: ' ||
                        SQLERRM || 'Linea ('||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE||')';

  END;

  PROCEDURE SGASS_ACTUALIZA_ESTADO_LTE(p_codsolot       IN NUMBER,
                                       p_tipo_operacion IN VARCHAR2,
                                       p_mensaje        IN VARCHAR2,
                                       p_estado         IN VARCHAR2,
                                       p_codigo_resp    OUT NUMBER,
                                       p_mensaje_resp   OUT VARCHAR2) IS
    pragma autonomous_transaction;

    lv_descrip     varchar2(100);
    ln_reg_log_act number;

  BEGIN

    p_codigo_resp  := 1;
    ln_reg_log_act := 0;

    BEGIN
      select b.descripcion
        into lv_descrip
        from operacion.tipopedd a, operacion.opedd b
       where a.tipopedd = b.tipopedd
         and a.abrev = 'EST_GEST_PROV'
         and b.abreviacion = p_estado;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        p_codigo_resp  := -1;
        p_mensaje_resp := 'No existe el estado en la tabla de parametros';
        RETURN;
    END;

    IF p_tipo_operacion = 'TP' THEN
      update operacion.psgat_estservicio se
         set se.essev_estado    = p_estado,
             se.essev_mensaje   = substr(p_mensaje, 1, 499), --11.0
             se.essev_operacion = lv_descrip
       where se.essen_cod_solot = p_codsolot;

      operacion.pq_3play_inalambrico.sgasi_logaprov(p_codsolot,
                                                    p_estado,
                                                    'TP',
                                                    'UPD',
                                                    p_mensaje,
                                                    p_codigo_resp,
                                                    p_mensaje_resp);

    ELSE

      select count(1)
        into ln_reg_log_act
        from operacion.sgat_logaprovlte lg
       where lg.logan_codsolot = p_codsolot
         and lg.logav_tipo_trans = p_tipo_operacion
         and lg.logav_est_log = '1';

      IF ln_reg_log_act = 0 THEN

        update operacion.psgat_estservicio se
           set se.essev_estado        = p_estado,
               se.essev_mensaje       = substr(p_mensaje, 1, 499), --11.0,
               se.essev_operacion     = lv_descrip,
               se.essen_n_reenvio     = decode(p_estado,
                                               'NPRV1',
                                               0,
                                               se.essen_n_reenvio + 1),
               se.essed_ult_fec_reenv = sysdate
         where se.essen_cod_solot = p_codsolot
           and se.essev_cod_operacion = p_tipo_operacion;

        operacion.pq_3play_inalambrico.sgasi_logaprov(p_codsolot,
                                                      p_estado,
                                                      p_tipo_operacion,
                                                      'INS',
                                                      p_mensaje,
                                                      p_codigo_resp,
                                                      p_mensaje_resp);

      ELSE

        update operacion.psgat_estservicio se
           set se.essev_estado    = p_estado,
               se.essev_mensaje   = substr(p_mensaje, 1, 499), --11.0,
               se.essev_operacion = lv_descrip
         where se.essen_cod_solot = p_codsolot
           and se.essev_cod_operacion = p_tipo_operacion;

        operacion.pq_3play_inalambrico.sgasi_logaprov(p_codsolot,
                                                      p_estado,
                                                      p_tipo_operacion,
                                                      'UPD',
                                                      p_mensaje,
                                                      p_codigo_resp,
                                                      p_mensaje_resp);

      END IF;
    END IF;

    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      p_codigo_resp  := -1;
      p_mensaje_resp := 'Error al update operacion.psgat_estservicio: ' ||
                        SQLERRM || 'Linea ('||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE||')';

  END;
  PROCEDURE SGASI_REG_PLAN_COMERCIAL(K_IDTAREAWF IN NUMBER,
                                     K_IDWF      IN NUMBER,
                                     K_TAREA     IN NUMBER,
                                     K_TAREADEF  IN NUMBER) IS

    v_mensaje  VARCHAR2(2000);
    v_codsolot operacion.solot.codsolot%TYPE;
    v_cod_id     operacion.solot.cod_id%TYPE;
    v_cod_id_old operacion.solot.cod_id_old%TYPE;
    V_ERROR      NUMBER;
    V_MSG        VARCHAR2(4000);
    v_cur_error EXCEPTION;

    V_SEQ INTEGER;

    V_CUSTOMER_ID   operacion.solot.customer_id%TYPE;
    V_TIPO_PLAN     TIM.LTE_INFO_COMERCIAL.TIPO_PLAN@DBL_BSCS_BF%TYPE;
    V_COD_PLAN      TIM.LTE_INFO_COMERCIAL.COD_PLAN@DBL_BSCS_BF%TYPE;
    V_TMCODE        TIM.LTE_INFO_COMERCIAL.TMCODE@DBL_BSCS_BF%TYPE;
    V_FEC_VENTA     TIM.LTE_INFO_COMERCIAL.FEC_VENTA@DBL_BSCS_BF%TYPE;
    V_USUARIO       TIM.LTE_INFO_COMERCIAL.USUARIO@DBL_BSCS_BF%TYPE;
    V_TIPO_EQUIPO   TIM.LTE_INFO_COMERCIAL.TIPO_EQUIPO@DBL_BSCS_BF%TYPE;
    V_MODELO_EQUIPO TIM.LTE_INFO_COMERCIAL.MODELO_EQUIPO@DBL_BSCS_BF%TYPE;

    V_ID_DET    INTEGER;
    V_TELEFONIA VARCHAR2(50) := 'TELEFONIA';
    EXC_GENERAL EXCEPTION;
    lv_tipserv_nue   varchar2(10);
    ln_cod_er       NUMBER;
    lv_resul_er     VARCHAR2(4000);
    LN_SIN_TLF      NUMBER:= 0;
    V_ESTADO_EQU    VARCHAR2(2);

    CURSOR C_DETALLE IS
      SELECT DISTINCT (SELECT O.ABREVIACION
                         FROM TIPOPEDD T, OPEDD O
                        WHERE T.TIPOPEDD = O.TIPOPEDD
                          AND T.ABREV = 'GRUPOSISACTLTE'
                          AND O.CODIGOC = D.IDGRUPO_PRINCIPAL) PRODUCTO,
                      D.SNCODE,
                      D.SPCODE,
                      NVL((SELECT O.DESCRIPCION
                            FROM TIPOPEDD T, OPEDD O
                           WHERE T.TIPOPEDD = O.TIPOPEDD
                             AND T.ABREV = 'GRUPOSISACTLTE'
                             AND O.CODIGOC = D.IDGRUPO),
                          'ADICIONAL') TIPO_SERV,
                      D.TIPEQU
        FROM SALES.SISACT_POSTVENTA_DET_SERV_LTE D
       WHERE CODSOLOT = V_CODSOLOT;

    CURSOR CUR_LSTSN IS
      SELECT ps.co_id, ps.sncode, ssh.status, sph.spcode, sn.des
        FROM profile_service@DBL_BSCS_BF     ps,
             pr_serv_status_hist@DBL_BSCS_BF ssh,
             pr_serv_spcode_hist@DBL_BSCS_BF sph,
             mpusntab@DBL_BSCS_BF            sn
       WHERE ps.co_id = ssh.co_id
         AND ps.sncode = ssh.sncode
         AND ps.status_histno = ssh.histno
         and ps.co_id = sph.co_id
         and ps.sncode = sph.sncode
         and ps.spcode_histno = sph.histno
         AND ps.co_id = V_COD_ID
         AND ssh.status IN ('O', 'A')
         and sn.sncode = ps.sncode
         AND NOT EXISTS (SELECT ic.co_id, ic.sncode
                FROM tim.lte_info_com_det@DBL_BSCS_BF ic
               WHERE ic.co_id = V_COD_ID
                 AND ic.seq = V_SEQ
                 AND ic.sncode = ps.sncode);
  BEGIN
    V_ERROR := 0;
    V_MSG   := 'OK';

    SELECT W.codsolot,
           S.COD_ID,
           S.CUSTOMER_ID,
           S.COD_ID_OLD,
           S.FECUSU,
           SP.TMCODE
      INTO V_CODSOLOT,
           V_COD_ID,
           V_CUSTOMER_ID,
           V_COD_ID_OLD,
           V_FEC_VENTA,
           V_TMCODE
      FROM wf W, SOLOT S, OPERACION.SIAC_POSTVENTA_PROCESO SP
     WHERE W.CODSOLOT = S.CODSOLOT
       AND S.CODSOLOT = SP.CODSOLOT
       AND W.idwf = K_IDWF
       AND W.VALIDO = 1;

    BEGIN
      OPERACION.PQ_SIAC_CAMBIO_PLAN_LTE.SGASS_CONTROL_SERVICIOS(V_CODSOLOT, lv_tipserv_nue, ln_cod_er, lv_resul_er);
      IF lv_tipserv_nue = 'CI' OR lv_tipserv_nue = 'IL'
        OR lv_tipserv_nue = 'CX' THEN
        LN_SIN_TLF := 1;
      END IF;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;

    --ini 16.0
    operacion.pq_3play_inalambrico.p_log_3playi(V_CODSOLOT,
                                                'SGASI_REG_PLAN_COMERCIAL',
                                                'Inicio del Proceso',
                                                'Registro del Plan Comercial BSCS',  --7.0
                                                V_ERROR,
                                                V_MSG);
    --fin 16.0

    BEGIN
      select distinct v.codplansisact into V_TIPO_PLAN
        from operacion.sga_visita_tecnica_siac v
       where v.co_id = V_COD_ID_OLD;
    EXCEPTION
      WHEN OTHERS THEN
         V_TIPO_PLAN     := 1657;
    END;

    V_COD_PLAN      := '3PLAY';
    V_USUARIO       := 'USRSGA';
    V_TIPO_EQUIPO   := NULL;
    V_MODELO_EQUIPO := NULL;

    SELECT COUNT(1) + 1
      INTO V_SEQ
      FROM TIM.LTE_INFO_COMERCIAL@DBL_BSCS_BF LTE
     WHERE LTE.CUSTOMER_ID = V_CUSTOMER_ID;

    BEGIN
      INSERT INTO TIM.LTE_INFO_COMERCIAL@DBL_BSCS_BF
        (CUSTOMER_ID,
         co_id,
         seq,
         tipo_plan,
         cod_plan,
         tmcode,
         fec_venta,
         usuario,
         tipo_equipo,
         modelo_equipo)
      VALUES
        (V_CUSTOMER_ID,
         V_COD_ID,
         V_SEQ,
         V_TIPO_PLAN,
         V_COD_PLAN,
         V_TMCODE,
         V_FEC_VENTA,
         V_USUARIO,
         V_TIPO_EQUIPO,
         V_MODELO_EQUIPO);
    EXCEPTION
      WHEN OTHERS THEN
        V_ERROR := -1;
        V_MSG   := 'ERROR, INGRESO PLAN COMERCIAL';
    END;

    FOR x IN C_DETALLE LOOP

      --REGISTRAMOS SERVICIOS.
      SELECT COUNT(1) + 1
        INTO V_ID_DET
        FROM TIM.LTE_INFO_COM_DET@DBL_BSCS_BF
       WHERE CUSTOMER_ID = V_CUSTOMER_ID
         AND SEQ = V_SEQ;

      INSERT INTO TIM.LTE_INFO_COM_DET@DBL_BSCS_BF
        (CUSTOMER_ID,
         CO_ID,
         SEQ,
         PRODUCTO,
         SNCODE,
         SP_CODE,
         TIPO_SERV,
         ESTADO_RECURSO,
         TIPO_EQUIPO,
         ID_DET)
      VALUES
        (V_CUSTOMER_ID,
         V_COD_ID,
         V_SEQ,
         x.producto,
         x.SNCODE,
         x.SPCODE,
         x.TIPO_SERV,
         'P',
         x.TIPEQU,
         V_ID_DET);

    END LOOP;

    FOR L IN CUR_LSTSN LOOP
      SELECT COUNT(1) + 1
        INTO v_id_det
        FROM tim.lte_info_com_det@DBL_BSCS_BF
       WHERE customer_id = v_customer_id
         AND seq = v_seq;

      IF L.SNCODE = C_SNCODE_TELFIJ_LTE THEN

        IF LN_SIN_TLF = 1 THEN
           V_TELEFONIA:= V_TELEFONIA||'*';
           V_ESTADO_EQU := 'D';
        ELSE
          V_ESTADO_EQU := 'P';
          V_TELEFONIA := 'TELEFONIA';
        END IF;

        INSERT INTO TIM.LTE_INFO_COM_DET@DBL_BSCS_BF
          (CUSTOMER_ID,
           CO_ID,
           SEQ,
           PRODUCTO,
           SNCODE,
           SP_CODE,
           TIPO_SERV,
           ESTADO_RECURSO,
           TIPO_EQUIPO,
           ID_DET)
        VALUES
          (V_CUSTOMER_ID,
           V_COD_ID,
           V_SEQ,
           V_TELEFONIA,
           L.SNCODE,
           L.SPCODE,
           'CORE',
           V_ESTADO_EQU,
           '',
           V_ID_DET);
      END IF;
    END LOOP;

    --ini 16.0
    operacion.pq_3play_inalambrico.p_log_3playi(V_CODSOLOT,
                                                'SGASI_REG_PLAN_COMERCIAL',
                                                'Fin del Proceso',
                                                'Registro del Plan Comercial BSCS',  --7.0
                                                V_ERROR,
                                                V_MSG);
    --fin 16.0

  EXCEPTION
    WHEN EXC_GENERAL THEN
      operacion.pq_3play_inalambrico.p_log_3playi(V_CODSOLOT,
                                                  'SGASI_REG_PLAN_COMERCIAL',
                                                  'Error : ' || V_ERROR ||
                                                  ' - Mensaje : ' || v_msg,
                                                  'Registro de Informacion Comercial en BSCS',
                                                  V_ERROR,
                                                  V_MENSAJE);
    WHEN OTHERS THEN
      V_MENSAJE := 'ERROR AL EJECUTAR PROC: ' || $$PLSQL_UNIT || '.' ||
                   'SGASI_REG_PLAN_COMERCIAL, ' || CHR(13) || 'CODSOLOT: ' ||
                   TO_CHAR(V_CODSOLOT) || CHR(13) || 'PI_IDTAREAWF: ' ||
                   TO_CHAR(K_IDTAREAWF) || CHR(13) || 'PI_IDWF: ' ||
                   TO_CHAR(K_IDWF) || CHR(13) || 'PI_TAREA: ' ||
                   TO_CHAR(K_TAREA) || CHR(13) || 'PI_TAREADEF: ' ||
                   TO_CHAR(K_TAREADEF) || CHR(13) || 'CODIGO DE ERROR: ' ||
                   TO_CHAR(SQLCODE) || CHR(13) || 'MENSAJE DE ERROR: ' ||
                   TO_CHAR(SQLERRM) || ' Linea : (' ||
                   DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ')';

      --ini 16.0
      operacion.pq_3play_inalambrico.p_log_3playi(V_CODSOLOT,
                                                  'SGASI_REG_PLAN_COMERCIAL',
                                                  substr(V_MENSAJE, 1, 3999),
                                                  'Registro del Plan Comercial BSCS',  --7.0
                                                  V_ERROR,
                                                  V_MSG);
      --fin 16.0
  END;

  /******************************************************************
  '* Nombre SP : SGAFUN_VAL_SIMCARD
  '* Propósito : Funcionalidad para actualizar equipos de servicios Fija
  '* Input : SOT de Alta
  '* Output : <PO_ERROR> - <PO_MENSAJE>
  '* Creado por :
  '* Fec Creación : 18/03/2019
  '* Fec Actualización :
  '*****************************************************************/
  FUNCTION SGAFUN_VAL_SIMCARD(AN_CODSOLOT SOLOT.CODSOLOT%TYPE,
                              AN_CANT_DIG NUMBER) RETURN NUMBER IS
    LV_VALOR NUMBER;
  BEGIN
    SELECT COUNT(DISTINCT S.SM_SERIALNUM)
      INTO LV_VALOR
      FROM STORAGE_MEDIUM@DBL_BSCS_BF S,
           PORT@DBL_BSCS_BF           P,
           CONTR_DEVICES@DBL_BSCS_BF  CD,
           (select distinct rpad(se.numserie, AN_CANT_DIG) NUMSERIE, s.cod_id, s.codsolot
              from solotptoequ se,
                   solot s,
                   solotpto sp,
                   inssrv i,
                   tipequ t,
                   almtabmat a,
                   (select a.codigon tipequ, codigoc grupo
                      from opedd a, tipopedd b
                     where a.tipopedd = b.tipopedd
                       and b.abrev = 'TIPEQU_LTE_TLF') equ_conax
             where se.codsolot = s.codsolot
               and s.codsolot = sp.codsolot
               and se.punto = sp.punto
               and sp.codinssrv = i.codinssrv
               and t.tipequ = se.tipequ
               and a.codmat = t.codtipequ
               and se.codsolot = AN_CODSOLOT
               and t.tipequ = equ_conax.tipequ
               and equ_conax.grupo = '3'
               and se.estado in (4, 15)) X
     WHERE S.SM_ID = P.SM_ID
       AND CD.PORT_ID = P.PORT_ID
       AND CD.CO_ID = X.COD_ID
       and X.CODSOLOT = AN_CODSOLOT
       and S.SM_SERIALNUM =  X.NUMSERIE ;

    RETURN LV_VALOR;
  EXCEPTION
    WHEN OTHERS THEN
      LV_VALOR := 0;
      RETURN LV_VALOR;
  END;

  PROCEDURE SGASS_PROVISION_LTE_CP_CX(p_codsolot       IN OPERACION.SOLOT.CODSOLOT%TYPE,
                                      p_idtareawf      IN OPEWF.TAREAWF.IDTAREAWF%TYPE,
                                      p_tipo_operacion IN VARCHAR2,
                                      p_cod            OUT NUMBER,
                                      p_mensaje        OUT VARCHAR2) IS

    ln_val_ns     NUMBER;
    ln_cod_er     NUMBER;
    lv_resul_er   VARCHAR2(4000);
    ln_val_cable  NUMBER;
    P_COD_ERR     VARCHAR2(100);
    k_NUMREGISTRO OPERACION.OPE_SRV_RECARGA_CAB.NUMREGISTRO%TYPE;
    ln_valctv_old number;--12.0
    LN_CODSOLOT_MAX number; --12.0
    ln_cont_ba_ctv  number; --17.0
  BEGIN
    p_cod     := 0;
    p_mensaje := 'OK';
    ln_cont_ba_ctv := 0; --17.0

    --VALIDACION DEL LOS SERVICIOS CONTRATADOS - CABLE
    SELECT COUNT(1)
      INTO ln_val_cable
      FROM OPERACION.INSSRV I
     WHERE I.CODINSSRV IN (SELECT SP.CODINSSRV
                             FROM OPERACION.SOLOTPTO SP
                            WHERE SP.CODSOLOT = p_codsolot)
       AND I.TIPSRV IN (SELECT C.VALOR
                          FROM OPERACION.CONSTANTE C
                         WHERE CONSTANTE IN ('FAM_CABLE')); --11.0

    --ini 12.0
    SELECT OPERACION.PQ_SGA_IW.F_MAX_SOT_X_COD_ID(S.COD_ID_OLD)
      INTO LN_CODSOLOT_MAX
      FROM SOLOT S
     WHERE S.CODSOLOT = p_codsolot;

    ln_valctv_old := OPERACION.PQ_VISITA_SGA_SIAC.SGAFUN_val_tipsrv_old(LN_CODSOLOT_MAX, '0062');
    --fin 12.0
    if ln_val_cable > 0 or ln_valctv_old > 0 then
       ln_cont_ba_ctv := 1; --17.0
       OPERACION.PQ_SIAC_CAMBIO_PLAN_LTE.SGASS_REGISTRO_ESTADO_LTE(p_codsolot, p_tipo_operacion, ln_cod_er, lv_resul_er); --10.0
    else
      p_cod     := -1;
      p_mensaje := 'La SOT ' ||to_char(p_codsolot) || ' no tiene el servicio de Cable para Activar/Desactivar';
      return;
    end if; --11.0

    operacion.pq_3play_inalambrico.p_log_3playi(p_codsolot,
                                                'SGASS_PROVISION_LTE_CP_CX', --7.0
                                                'Inicio del proceso de Provision Contego-LTE',  --7.0
                                                'Provision Contego',  --7.0
                                                ln_cod_er,
                                                lv_resul_er);

    -- Ejecutando la Provision de CONTEGO
    if ln_cont_ba_ctv > 0 and
       (p_tipo_operacion = 'TP' or p_tipo_operacion = 'CX' or
       p_tipo_operacion = 'CI') then
    --7.0 Fin

    -- Validando si se ingresaron Numeros de Series para DTH
    SELECT COUNT(1)
      INTO ln_val_ns
      FROM SOLOTPTOEQU SE,
           SOLOT S,
           SOLOTPTO SP,
           INSSRV I,
           TIPEQU T,
           ALMTABMAT A,
           (SELECT A.CODIGON TIPEQU, CODIGOC GRUPO
              FROM OPEDD A, TIPOPEDD B
             WHERE A.TIPOPEDD = B.TIPOPEDD
               AND B.ABREV = 'TIPEQU_DTH_CONAX') EQU_CONAX
     WHERE SE.CODSOLOT = S.CODSOLOT
       AND S.CODSOLOT = SP.CODSOLOT
       AND SE.PUNTO = SP.PUNTO
       AND SP.CODINSSRV = I.CODINSSRV
       AND T.TIPEQU = SE.TIPEQU
       AND A.CODMAT = T.CODTIPEQU
       AND SE.CODSOLOT = P_CODSOLOT
       AND TRIM(SE.NUMSERIE) IS NULL
       AND T.TIPEQU = EQU_CONAX.TIPEQU;

      if ln_val_ns > 0 then
        p_cod     := -1;
        p_mensaje := 'Hay equipos que le falta asignar Numero de Serie - DTH, no se pudo provisionar los servicios';

        OPERACION.PQ_SIAC_CAMBIO_PLAN_LTE.SGASS_ACTUALIZA_ESTADO_LTE(p_codsolot,
                                   p_tipo_operacion, --10.0
                                   p_mensaje,
                                   'ERRO',
                                   ln_cod_er,
                                   lv_resul_er);
        return;
      end if;

      begin
        SELECT NUMREGISTRO
          INTO k_NUMREGISTRO
          FROM OPERACION.OPE_SRV_RECARGA_CAB
         WHERE CODSOLOT = p_codsolot;

        OPERACION.PKG_CONTEGO.SGASS_DECOS_CONTEGO_CP(k_NUMREGISTRO,
                                                     p_codsolot,
                                                     P_COD_ERR,
                                                     p_mensaje);

        if P_COD_ERR != 'OK' then
          p_cod     := -1;
          p_mensaje := 'Error en el proceso SGASS_DECOS_CONTEGO_CP : ' ||
                       p_mensaje;
          OPERACION.PQ_SIAC_CAMBIO_PLAN_LTE.SGASS_ACTUALIZA_ESTADO_LTE(p_codsolot,
                                     p_tipo_operacion,--10.0
                                     p_mensaje,
                                     'ERRO',
                                     ln_cod_er,
                                     lv_resul_er);
        else

          OPERACION.PQ_SIAC_CAMBIO_PLAN_LTE.SGASS_ACTUALIZA_ESTADO_LTE(p_codsolot,
                                     p_tipo_operacion,--10.0
                                     'Se Registro la Provision Correctamente',--10.0
                                     'EPLA',
                                     ln_cod_er,
                                     lv_resul_er);

          p_cod     := 0;
          p_mensaje := 'OK : ' || p_mensaje;
        end if;

        operacion.pq_3play_inalambrico.p_log_3playi(p_codsolot,
                                                    'SGASS_DECOS_CONTEGO_CP', --7.0
                                                    'Fin del proceso de Provision Contego-LTE : '||p_mensaje,
                                                    'Provision Contego',  --7.0
                                                    ln_cod_er,
                                                    lv_resul_er);

      exception
        when others then
          p_cod     := -99;
          p_mensaje := 'ERROR: ' || TO_CHAR(SQLCODE) || CHR(13) || SQLERRM ||
                       ' Linea (' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ')'; --7.0
          OPERACION.PQ_SIAC_CAMBIO_PLAN_LTE.SGASS_ACTUALIZA_ESTADO_LTE(p_codsolot,
                                     p_tipo_operacion,--10.0
                                     null,
                                     'ERRO',
                                     ln_cod_er,
                                     lv_resul_er);
          operacion.pq_3play_inalambrico.p_log_3playi(p_codsolot,
                                                      'SGASS_PROVISION_LTE_CP', --7.0
                                                      'ERROR : '||p_mensaje,
                                                      'Provision Contego',  --7.0
                                                      ln_cod_er,
                                                      lv_resul_er);
          return;
      end;
    end if;

  EXCEPTION
    WHEN OTHERS THEN
      p_cod     := -99;
      p_mensaje := 'ERROR: ' || TO_CHAR(SQLCODE) || CHR(13) || SQLERRM ||
                   ' Linea (' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ')' ||
                   ' - ID_Tareawf :'|| p_idtareawf; --8.0
      operacion.pq_3play_inalambrico.p_log_3playi(p_codsolot,
                                                  'SGASS_PROVISION_LTE_CP',  --7.0
                                                  p_mensaje,
                                                  'Provision Contego Cambio de Plan LTE',  --7.0
                                                  ln_cod_er,
                                                  lv_resul_er);
  END;

  PROCEDURE SGASS_PROVISION_LTE_CP_IL_JN(p_codsolot       IN OPERACION.SOLOT.CODSOLOT%TYPE,
                                         p_idtareawf      IN OPEWF.TAREAWF.IDTAREAWF%TYPE,
                                         p_tipo_operacion IN VARCHAR2,
                                         p_cod            OUT NUMBER,
                                         p_mensaje        OUT VARCHAR2) IS

    ln_customer_id  OPERACION.SOLOT.CUSTOMER_ID%TYPE;
    ln_cod_id       OPERACION.SOLOT.COD_ID%TYPE;
    ln_cod_id_old   OPERACION.SOLOT.COD_ID_OLD%TYPE;
    ln_codsolot_old OPERACION.SOLOT.CODSOLOT%TYPE; --17.0
    ln_val_ns       NUMBER;
    ln_cod_er       NUMBER;
    lv_resul_er     VARCHAR2(4000);
    ln_val_bajaalta number;
    ln_request_lte  number;
    ln_cambioimsi   number;
    ln_valrefresco  number;
    exc_general     exception;  --8.0
    LN_VAL_INFO_COM number;
    ln_count_it     number; --11.0
    ln_count_prov   number; --11.0
    ln_prov_il      number; --11.0
    ln_cant_dig_chip NUMBER;
    LN_VAL_SIMCARD   NUMBER;
    LN_IDWF          NUMBER;
    ln_reintento     NUMBER; --15.0

    lv_tipserv_nue   varchar2(10); --17.0
    lv_tipserv_old   varchar2(10); --17.0
    LN_APLICA_BA     NUMBER; --17.0
  BEGIN
    p_cod     := 0;
    p_mensaje := 'OK';

    --8.0 Ini
    SELECT S.CUSTOMER_ID, s.cod_id, s.cod_id_old, operacion.pq_sga_iw.f_max_sot_x_cod_id(s.cod_id_old) --17.0
          INTO ln_customer_id, ln_cod_id, ln_cod_id_old, ln_codsolot_old --17.0
          FROM SOLOT S
         WHERE S.CODSOLOT = p_codsolot;
    --8.0 Fin

  --ini 11.0
    --VALIDACION DEL LOS SERVICIOS CONTRATADOS - INTERNET
    SELECT COUNT(1)
      INTO ln_count_it
      FROM OPERACION.INSSRV I
     WHERE I.CODINSSRV IN (SELECT SP.CODINSSRV
                             FROM OPERACION.SOLOTPTO SP
                            WHERE SP.CODSOLOT = P_CODSOLOT)
       AND I.TIPSRV IN (SELECT C.VALOR
                          FROM OPERACION.CONSTANTE C
                         WHERE CONSTANTE IN ('FAM_INTERNET', 'FAM_TELEF'));

    --ini 12.0
    select count(1)
      into ln_count_prov
      from operacion.psgat_estservicio e
     where e.essen_cod_solot = p_codsolot
       and e.essev_cod_operacion = p_tipo_operacion;

    select count(1)
      into ln_prov_il
      from tim.lte_control_prov@dbl_bscs_bf l
     where l.co_id = ln_cod_id
     and l.action_id in (select o.codigon from opedd o, tipopedd t
                          where o.tipopedd = t.tipopedd
                          and t.abrev = 'ACTIONID_CP_ACT_LTE');

    if ln_count_prov > 0 and ln_prov_il > 0 then

      operacion.pq_3play_inalambrico.p_log_3playi(p_codsolot,
                                                'SGASS_PROVISION_LTE_CP',
                                                'Ya existe Provision IL en Proceso para el Contrato',
                                                'Provision IL',  --7.0
                                                ln_cod_er,
                                                lv_resul_er);
      return;
    end if;
    --fin 12.0

    if ln_count_it > 0 then
       OPERACION.PQ_SIAC_CAMBIO_PLAN_LTE.SGASS_REGISTRO_ESTADO_LTE(p_codsolot, p_tipo_operacion, ln_cod_er, lv_resul_er); --10.0
    else
      p_cod     := -1;
      p_mensaje := 'La SOT ' ||to_char(p_codsolot) || ' no tiene el servicio de Internet/Telefonia para Activar';
      return;
    end if;

    --fin 11.0
    operacion.pq_3play_inalambrico.p_log_3playi(p_codsolot,
                                                'SGASS_PROVISION_LTE_CP',
                                                'Inicio del Proceso',
                                                'Provision IL',  --7.0
                                                ln_cod_er,
                                                lv_resul_er);

    -- Validando si se ingresaron Numeros de Series
    SELECT COUNT(1)
      INTO ln_val_ns
      FROM SOLOTPTOEQU SE,
           SOLOT S,
           SOLOTPTO SP,
           INSSRV I,
           TIPEQU T,
           ALMTABMAT A,
           (SELECT A.CODIGON TIPEQU, CODIGOC GRUPO
              FROM OPEDD A, TIPOPEDD B
             WHERE A.TIPOPEDD = B.TIPOPEDD
               AND B.ABREV = 'TIPEQU_LTE_TLF') EQU_CONAX
     WHERE SE.CODSOLOT = S.CODSOLOT
       AND S.CODSOLOT = SP.CODSOLOT
       AND SE.PUNTO = SP.PUNTO
       AND SP.CODINSSRV = I.CODINSSRV
       AND T.TIPEQU = SE.TIPEQU
       AND A.CODMAT = T.CODTIPEQU
       AND SE.CODSOLOT = p_codsolot
       AND TRIM(SE.NUMSERIE) IS NULL
       AND T.TIPEQU = EQU_CONAX.TIPEQU;

    if ln_val_ns > 0 then
      p_cod     := -1;
      p_mensaje := 'Hay equipos que le falta asignar Numero de Serie LTE - TLF, no se pudo provisionar los servicios';
      OPERACION.PQ_SIAC_CAMBIO_PLAN_LTE.SGASS_ACTUALIZA_ESTADO_LTE(p_codsolot,
                                 p_tipo_operacion,--10.0
                                 p_mensaje,
                                 'ERRO',
                                 ln_cod_er,
                                 lv_resul_er);
      return;
    end if;

    SELECT COUNT(T.CO_ID)
      INTO LN_VAL_INFO_COM
      FROM TIM.LTE_INFO_COMERCIAL@DBL_BSCS_BF T,
           TIM.LTE_INFO_COM_DET@DBL_BSCS_BF   D
     WHERE T.CO_ID = D.CO_ID
       AND T.CUSTOMER_ID = D.CUSTOMER_ID
       AND T.CO_ID = LN_COD_ID;

    LN_REINTENTO := OPERACION.PQ_SGA_JANUS.F_GET_CONSTANTE_CONF('REIN_REGCOMLTE');

    IF LN_REINTENTO = 1 AND LN_VAL_INFO_COM = 0 THEN
      BEGIN
        SELECT W.IDWF
          INTO LN_IDWF
          FROM WF W
         WHERE W.CODSOLOT = P_CODSOLOT
           AND W.VALIDO = 1;

        SGASI_REG_PLAN_COMERCIAL(NULL, LN_IDWF, NULL, NULL);
      EXCEPTION
        WHEN OTHERS THEN
          p_mensaje := 'ERROR al cargar informacion comercial en BSCS para el Contrato : '||to_char(ln_cod_id); --7.0
          operacion.pq_3play_inalambrico.p_log_3playi(p_codsolot,
                                                    'VAL_INFO_COMERCIAL',
                                                    'Error : '||p_mensaje,
                                                    'Validacion Comercial en BSCS',
                                                    ln_cod_er,
                                                    lv_resul_er);
      END;
    END IF;

    SELECT COUNT(T.CO_ID)
      INTO LN_VAL_INFO_COM
      FROM TIM.LTE_INFO_COMERCIAL@dbl_bscs_bf T, TIM.LTE_INFO_COM_DET@dbl_bscs_bf D
     WHERE T.CO_ID = D.CO_ID
       AND T.CUSTOMER_ID = D.CUSTOMER_ID
       AND T.CO_ID = ln_cod_id;

    IF LN_VAL_INFO_COM = 0 THEN
      p_cod     := -1;
      p_mensaje := 'No existe informacion comercial registrada en BSCS para el Contrato : '||to_char(ln_cod_id); --7.0
      operacion.pq_3play_inalambrico.p_log_3playi(p_codsolot,
                                                    'VAL_INFO_COMERCIAL',
                                                    'Error : '||p_mensaje,
                                                    'Validacion Comercial en BSCS',
                                                    ln_cod_er,
                                                    lv_resul_er);
      OPERACION.PQ_SIAC_CAMBIO_PLAN_LTE.SGASS_ACTUALIZA_ESTADO_LTE(p_codsolot,
                                 p_tipo_operacion,--10.0
                                 p_mensaje,
                                 'ERRO',
                                 ln_cod_er,
                                 lv_resul_er);
      return;
    END IF;

    -- Ejecutando la Provision de IL Y JANUS
    if ln_count_it > 0 and
       (p_tipo_operacion = 'TP' or p_tipo_operacion = 'IL' or
       p_tipo_operacion = 'IJ' or p_tipo_operacion = 'CI') then

       ln_cant_dig_chip := OPERACION.PQ_SGA_JANUS.F_GET_CONSTANTE_CONF('CANDIGCHIPLTE');

      begin
       --8.0 Ini
       operacion.pq_3play_inalambrico.p_log_3playi(p_codsolot,
                                                    'SGASI_REG_IMSI_MSISDN',
                                                    'Inicio del Proceso',
                                                    'Registro de Información en BSCS',
                                                    ln_cod_er,
                                                    lv_resul_er);
       --8.0 Fin

        operacion.pq_siac_cambio_plan_lte.sgasi_reg_imsi_msisdn(p_codsolot,
                                                                ln_cod_id,
                                                                ln_cod_id_old,
                                                                ln_cod_er,
                                                                lv_resul_er);

       --8.0 Ini
       if ln_cod_er = 0 then
          commit;
          lv_resul_er := 'Fin del Proceso : ' ||lv_resul_er;
          operacion.pq_3play_inalambrico.p_log_3playi(p_codsolot,
                                                    'SGASI_REG_IMSI_MSISDN',
                                                    'Fin del Proceso - Resultado :'||lv_resul_er,
                                                    'Registro de Información en BSCS',
                                                    ln_cod_er,
                                                    lv_resul_er);
       else
         p_cod := ln_cod_er;
         p_mensaje := 'Error al Asociar el IMSI con el Contrato - ' || lv_resul_er;
     --ini 10.0
         OPERACION.PQ_SIAC_CAMBIO_PLAN_LTE.SGASS_ACTUALIZA_ESTADO_LTE(p_codsolot,
                                 p_tipo_operacion,
                                 p_mensaje,
                                 'ERRO',
                                 ln_cod_er,
                                 lv_resul_er);
        --fin 10.0
         return;
       end if;
       --8.0 Fin

      exception
        when others then
          p_cod     := -99;
          p_mensaje := 'Error al Asociar el IMSI : ' || TO_CHAR(SQLCODE) || CHR(13) || SQLERRM || --14.0
                       ' Linea(' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ')';  --7.0

          operacion.pq_3play_inalambrico.p_log_3playi(p_codsolot,
                                                      'SGASI_REG_IMSI_MSISDN',
                                                      'Fin del Proceso - Resultado :' ||p_mensaje,
                                                      'Registro de Información en BSCS', --7.0
                                                      ln_cod_er,
                                                      lv_resul_er);
          return;
      end;
      --ini 15.0
      LN_REINTENTO := OPERACION.PQ_SGA_JANUS.F_GET_CONSTANTE_CONF('REIN_SIMCARDLTE');
      IF LN_REINTENTO = 1 THEN
        LN_VAL_SIMCARD := SGAFUN_VAL_SIMCARD(p_codsolot, ln_cant_dig_chip);
        IF LN_VAL_SIMCARD = 0 THEN
          begin
            operacion.pq_siac_cambio_plan_lte.sgasi_reg_imsi_msisdn(p_codsolot,
                                                                    ln_cod_id,
                                                                    ln_cod_id_old,
                                                                    ln_cod_er,
                                                                    lv_resul_er);
          exception
            when others then
              null;
          end;
        END IF;
      END IF;
      --fin 15.0

      --Validacion de IMSI
      LN_VAL_SIMCARD := SGAFUN_VAL_SIMCARD(p_codsolot, ln_cant_dig_chip); --15.0

      IF LN_VAL_SIMCARD = 0 THEN
        p_cod     := -1;
        p_mensaje := 'El SIMCARD no se encuentra asociado al Contrato en BSCS, por favor revisar'; --7.0
        operacion.pq_3play_inalambrico.p_log_3playi(p_codsolot,
                                                    'SGASS_PROVISION_LTE_CP',
                                                    'Registro de IMSI : ' ||
                                                    p_mensaje,
                                                    'Provision IL',
                                                    ln_cod_er,
                                                    lv_resul_er);
        return;
      END IF;

      begin
        operacion.pq_3play_inalambrico.p_log_3playi(p_codsolot,
                                                    'SGASS_PROVISION_LTE_CP', --7.0
                                                    'Inicio del Proceso de Activacion', --8.0
                                                    'Provision IL', --7.0
                                                    ln_cod_er,
                                                    lv_resul_er);

        -- Valida si existe un refreso de Internet
        select count(1)
          into ln_valrefresco
          from solotptoequ se,
               solot s,
               solotpto sp,
               inssrv i,
               tipequ t,
               almtabmat a,
               (select a.codigon tipequ, codigoc grupo
                  from opedd a, tipopedd b
                 where a.tipopedd = b.tipopedd
                   and b.abrev = 'TIPEQU_LTE_TLF') equ_conax
         where se.codsolot = s.codsolot
           and s.codsolot = sp.codsolot
           and se.punto = sp.punto
           and sp.codinssrv = i.codinssrv
           and t.tipequ = se.tipequ
           and a.codmat = t.codtipequ
           and se.codsolot = p_codsolot
           and t.tipequ = equ_conax.tipequ
           and equ_conax.grupo = '3'
           and se.estado = 15;
        --ini 17.0
        OPERACION.PQ_SIAC_CAMBIO_PLAN_LTE.SGASS_CONTROL_SERVICIOS(p_codsolot, lv_tipserv_nue, ln_cod_er, lv_resul_er);
        OPERACION.PQ_SIAC_CAMBIO_PLAN_LTE.SGASS_CONTROL_SERVICIOS(ln_codsolot_old, lv_tipserv_old, ln_cod_er, lv_resul_er);

        --Validamos de 2play a 1play y 1play a 2play aplican baja y alta
        IF lv_tipserv_nue = 'IJ' and lv_tipserv_old = 'IL' THEN
          LN_APLICA_BA := 1;
        ELSIF lv_tipserv_nue = 'IL' and lv_tipserv_old = 'IJ' then
          LN_APLICA_BA := 1;
        ELSE
          LN_APLICA_BA := 0;
        END IF;
        --fin 17.0

        -- Valida si es con Visita o sin Visita --> O solo refresco de Internet
        if (operacion.pq_siac_cambio_plan_lte.sgafun_valida_cb_plan_visita(p_codsolot) = 1 or
           ln_valrefresco > 0) and LN_APLICA_BA = 0 then --7.0
          begin
            OPERACION.PQ_3PLAY_INALAMBRICO.P_LOG_3PLAYI(p_codsolot,
                                                          'SGASI_PROV_INTERNET',  --7.0
                                                          'Inicio del Proceso',
                                                          'Provision IL',  --7.0
                                                          ln_cod_er,
                                                          lv_resul_er);

            operacion.pq_siac_cambio_plan_lte.sgasi_prov_internet(p_codsolot,
                                                                  p_cod,
                                                                  p_mensaje);

            OPERACION.PQ_3PLAY_INALAMBRICO.P_LOG_3PLAYI(p_codsolot,
                                                          'SGASI_PROV_INTERNET',  --7.0
                                                          'Fin del Proceso : ' ||p_mensaje,
                                                          'Provision IL',  --7.0
                                                          ln_cod_er,
                                                          lv_resul_er);

          exception
            when others then
              --7.0 Ini
              p_cod     := -3;  --8.0
              p_mensaje := 'Error en el Proceso de Provision IL : ' || SQLERRM || ' Linea(' || --14.0
                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ')';
              --7.0 Fin
              OPERACION.PQ_3PLAY_INALAMBRICO.P_LOG_3PLAYI(p_codsolot,
                                                          'SGASI_PROV_INTERNET',  --7.0
                                                          'Error :' ||p_mensaje,
                                                          'Provision IL',  --7.0
                                                          ln_cod_er,
                                                          lv_resul_er);
             return;
          end;
      --10.0
          if p_cod = 0 then
            commit;
            OPERACION.PQ_SIAC_CAMBIO_PLAN_LTE.SGASS_ACTUALIZA_ESTADO_LTE(p_codsolot,
                                       p_tipo_operacion,
                                       'Se registro correctamente la Provision IL',
                                       'EPLA',
                                       ln_cod_er,
                                       lv_resul_er);
          else
            rollback;
            OPERACION.PQ_SIAC_CAMBIO_PLAN_LTE.SGASS_ACTUALIZA_ESTADO_LTE(p_codsolot,
                                       p_tipo_operacion,
                                       p_mensaje,
                                       'ERRO',
                                       ln_cod_er,
                                       lv_resul_er);
          end if;
          --fin 10.0
        else

          ln_val_bajaalta := operacion.pq_sga_janus.f_get_constante_conf('BAJAALTALTECP');

          if ln_val_bajaalta = 0 then
            OPERACION.PQ_3PLAY_INALAMBRICO.P_LOG_3PLAYI(p_codsolot,
                                                          'SIACSU_CAMBIO_PLAN',  --7.0
                                                          'Inicio del Proceso',
                                                          'Provision IL',  --7.0
                                                          ln_cod_er,
                                                          lv_resul_er);
            tim.pp004_siac_lte.siacsu_cambio_plan@dbl_bscs_bf(ln_customer_id,
                                                              ln_cod_id_old,
                                                              ln_cod_id,
                                                              'USRSGA',
                                                              p_cod,
                                                              p_mensaje);
           OPERACION.PQ_3PLAY_INALAMBRICO.P_LOG_3PLAYI(p_codsolot,
                                                          'SIACSU_CAMBIO_PLAN',  --7.0
                                                          'Fin del Proceso: '||p_mensaje,
                                                          'Provision IL',  --7.0
                                                          ln_cod_er,
                                                          lv_resul_er);
          else
            OPERACION.PQ_3PLAY_INALAMBRICO.P_LOG_3PLAYI(p_codsolot,
                                                          'SIACSI_ALTA_BAJA',  --7.0
                                                          'Inicio del Proceso',
                                                          'Provision IL',  --7.0
                                                          ln_cod_er,
                                                          lv_resul_er);
            tim.pp004_siac_lte.SIACSI_ALTA_BAJA@dbl_bscs_bf(ln_cod_id,
                                                            ln_cod_id_old,
                                                            p_codsolot,
                                                            'SGA',
                                                            p_cod,
                                                            p_mensaje);
            OPERACION.PQ_3PLAY_INALAMBRICO.P_LOG_3PLAYI(p_codsolot,
                                                          'SIACSI_ALTA_BAJA',  --7.0
                                                          'Fin del Proceso : '||p_mensaje,
                                                          'Provision IL',  --7.0
                                                          ln_cod_er,
                                                          lv_resul_er);
          end if;
      --ini 10.0
          if p_cod = 0 then
            commit;
            OPERACION.PQ_SIAC_CAMBIO_PLAN_LTE.SGASS_ACTUALIZA_ESTADO_LTE(p_codsolot,
                                       p_tipo_operacion,
                                       'Se registro correctamente la Provision IL',
                                       'EPLA',
                                       ln_cod_er,
                                       lv_resul_er);
            OPERACION.PQ_SIAC_CAMBIO_PLAN_LTE.SGASS_ACTUALIZA_ESTADO_LTE(p_codsolot,
                                       'JN',
                                       'Se registro correctamente la Provision JANUS',
                                       'EPLA',
                                       ln_cod_er,
                                       lv_resul_er);
          else
            rollback;
            OPERACION.PQ_SIAC_CAMBIO_PLAN_LTE.SGASS_ACTUALIZA_ESTADO_LTE(p_codsolot,
                                       p_tipo_operacion,
                                       p_mensaje,
                                       'ERRO',
                                       ln_cod_er,
                                       lv_resul_er);
            OPERACION.PQ_SIAC_CAMBIO_PLAN_LTE.SGASS_ACTUALIZA_ESTADO_LTE(p_codsolot,
                                       'JN',
                                       p_mensaje,
                                       'ERRO',
                                       ln_cod_er,
                                       lv_resul_er);
          end if;
          --fin 10.0

        end if;

        operacion.pq_3play_inalambrico.p_log_3playi(p_codsolot,
                                                    'SGASS_PROVISION_LTE_CP',  --7.0
                                                    'Fin del Proceso de Activacion :' ||
                                                    p_mensaje, --7.0
                                                    'Provision IL',  --7.0
                                                    ln_cod_er,
                                                    lv_resul_er);
        -- Valida si Existe un Cambio de IMSI
        select count(1)
          into ln_cambioimsi
          from solotptoequ se,
               solot s,
               solotpto sp,
               inssrv i,
               tipequ t,
               almtabmat a,
               (select a.codigon tipequ, codigoc grupo
                  from opedd a, tipopedd b
                 where a.tipopedd = b.tipopedd
                   and b.abrev = 'TIPEQU_LTE_TLF') equ_conax
         where se.codsolot = s.codsolot
           and s.codsolot = sp.codsolot
           and se.punto = sp.punto
           and sp.codinssrv = i.codinssrv
           and t.tipequ = se.tipequ
           and a.codmat = t.codtipequ
           and se.codsolot = p_codsolot
           and t.tipequ = equ_conax.tipequ
           and equ_conax.grupo = '3'
           and se.estado in (12, 4);

        if ln_cambioimsi > 0 then
          OPERACION.PQ_SIAC_CAMBIO_PLAN_LTE.SGASS_REGISTRO_ESTADO_LTE(p_codsolot, 'JN', ln_cod_er, lv_resul_er);

          begin
            select l.request
              into ln_request_lte
              from tim.lte_control_prov@dbl_bscs_bf l
             where l.co_id = ln_cod_id
               and l.request = (select min(ll.request)
                                  from tim.lte_control_prov@dbl_bscs_bf ll
                                 where ll.co_id = l.co_id);
          exception
            when others then
              ln_request_lte := null;
          end;
          --7.0 Ini
          operacion.pq_3play_inalambrico.p_log_3playi(p_codsolot,
                                                      'BSCSSI_INS_JANUS_CAMBIO_IMSI',
                                                      'Inicio Proceso - Cambio de IMSI Janus',
                                                      'Provision JANUS',
                                                      ln_cod_er,
                                                      lv_resul_er);
          --7.0 Fin

          --EJECUTANDO EL CAMBIO DE IMSI EN JANUS
          TIM.PP021_VENTA_LTE.BSCSSI_INS_JANUS_CAMBIO_IMSI@DBL_BSCS_BF(ln_request_lte,
                                                                       ln_cod_er,
                                     lv_resul_er);
          --ini 10.0
          OPERACION.PQ_SIAC_CAMBIO_PLAN_LTE.SGASS_ACTUALIZA_ESTADO_LTE(p_codsolot,
                                     'JN',
                                     lv_resul_er,
                                     'EPLA',
                                     ln_cod_er,
                                     lv_resul_er);
          --7.0 Ini
          operacion.pq_3play_inalambrico.p_log_3playi(p_codsolot,
                                                      'BSCSSI_INS_JANUS_CAMBIO_IMSI',
                                                      'Inicio Proceso - Cambio de IMSI Janus - ' ||
                                                      lv_resul_er,
                                                      'Provision JANUS',
                                                      ln_cod_er,
                                                      lv_resul_er);
          --7.0 Fin

        end if;

        -- Provision JANUS
        BEGIN
          SELECT W.IDWF
            INTO LN_IDWF
            FROM WF W
           WHERE W.CODSOLOT = p_codsolot
             AND W.VALIDO = 1;
          OPERACION.PQ_SIAC_CAMBIO_PLAN_LTE.SGASI_PROV_JANUS(NULL,
                                                             LN_IDWF,
                                                             NULL,
                                                             NULL);
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
      exception
        when others then
          p_cod     := -99;
          p_mensaje := 'ERROR: ' || TO_CHAR(SQLCODE) || CHR(13) || SQLERRM ||
                       ' Linea (' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ')'; --7.0

          OPERACION.PQ_SIAC_CAMBIO_PLAN_LTE.SGASS_ACTUALIZA_ESTADO_LTE(p_codsolot,
                                     p_tipo_operacion,
                                     p_mensaje,
                                     'ERRO',
                                     ln_cod_er,
                                     lv_resul_er);
          OPERACION.PQ_SIAC_CAMBIO_PLAN_LTE.SGASS_ACTUALIZA_ESTADO_LTE(p_codsolot,
                                     'JN',
                                     p_mensaje,
                                     'ERRO',
                                     ln_cod_er,
                                     lv_resul_er);
          operacion.pq_3play_inalambrico.p_log_3playi(p_codsolot,
                                                      'SGASS_PROVISION_LTE_CP',
                                                      p_mensaje,
                                                      'Provision IL - JANUS',  --7.0
                                                      ln_cod_er,
                                                      lv_resul_er);
      end;
    end if;

  EXCEPTION
    WHEN OTHERS THEN
      p_cod     := -99;
      p_mensaje := 'ERROR: ' || TO_CHAR(SQLCODE) || CHR(13) || SQLERRM ||
                   ' Linea (' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ')'||
                   ' - ID_Tareawf :'|| p_idtareawf;  --8.0

      operacion.pq_3play_inalambrico.p_log_3playi(p_codsolot,
                                                  'SGASS_PROVISION_LTE_CP',  --7.0
                                                  p_mensaje,
                                                  'Provision IL - JANUS',  --7.0
                                                  ln_cod_er,
                                                  lv_resul_er);
  END;

  PROCEDURE SGASS_PROVISION_LTE_CP_AUTO(p_solot     OPERACION.SOLOT.CODSOLOT%TYPE,
                                        p_idtareawf OPEWF.TAREAWF.IDTAREAWF%TYPE,
                                        p_cod_resp  OUT NUMBER,
                                        p_msj_resp  OUT VARCHAR2) IS
    ln_tip_serv VARCHAR2(10);
    ln_resp     NUMBER;
    ls_msj      VARCHAR2(4000);
    ln_count    NUMBER;
  BEGIN

    -- Validacion de Servicios
    operacion.pq_3play_inalambrico.p_log_3playi(p_solot,
                                                'SGASS_PROVISION_LTE_CP_AUTO',
                                                'Inicio del Proceso',
                                                'Provision Automatica - CP LTE',
                                                ln_resp,
                                                ls_msj);
    SGASS_CONTROL_SERVICIOS(p_solot, ln_tip_serv, p_cod_resp, p_msj_resp);

    if p_cod_resp = 1 then

      -- Registrar Log de Servicios
      operacion.pq_3play_inalambrico.p_log_3playi(p_solot,
                                                  'SGASS_PROVISION_LTE_CP_AUTO',
                                                  'Inicio',
                                                  'Registro de Estado LTE',
                                                  ln_resp,
                                                  ls_msj);
      SGASS_REGISTRO_ESTADO_LTE(p_solot,
                                ln_tip_serv,
                                p_cod_resp,
                                p_msj_resp);
      if p_cod_resp = 1 then

        -- Actualizar Estado Log de Servicios.
        operacion.pq_3play_inalambrico.p_log_3playi(p_solot,
                                                    'SGASS_PROVISION_LTE_CP_AUTO',
                                                    'INICIO',
                                                    'PROVISION LTE SIN VISITA TECNICA: SGASS_ACTUALIZA_ESTADO_LTE',
                                                    ln_resp,
                                                    ls_msj);
        SGASS_ACTUALIZA_ESTADO_LTE(p_solot,
                                   'TP',
                                   NULL,
                                   'PROC',
                                   p_cod_resp,
                                   p_msj_resp);
        if p_cod_resp = 1 then

          -- Provisionar Cambio de Plan LTE.
          operacion.pq_3play_inalambrico.p_log_3playi(p_solot,
                                                      'SGASS_PROVISION_LTE_CP_AUTO',
                                                      'INICIO',
                                                      'PROVISION LTE SIN VISITA TECNICA: SGASS_PROVISION_LTE_CP',
                                                      ln_resp,
                                                      ls_msj);
          SELECT COUNT(1)
            INTO ln_count
            FROM OPERACION.PSGAT_ESTSERVICIO E
           WHERE E.ESSEN_COD_SOLOT = p_solot;
          if ln_count = 0 then
            if ln_tip_serv = 'TP' or ln_tip_serv = 'CX' or
               ln_tip_serv = 'CI' then
              SGASS_PROVISION_LTE_CP_CX(p_solot,
                                        p_idtareawf,
                                        ln_tip_serv,
                                        p_cod_resp,
                                        p_msj_resp);
              if p_cod_resp < 0 then
                p_cod_resp := -99;
                operacion.pq_3play_inalambrico.p_log_3playi(p_solot,
                                                            'SGASS_PROVISION_LTE_CP_AUTO',
                                                            p_msj_resp,
                                                            'PROVISION LTE SIN VISITA TECNICA: SGASS_PROVISION_LTE_CP',
                                                            ln_resp,
                                                            ls_msj);
                return;
              end if;
            end if;

            if ln_tip_serv = 'TP' or ln_tip_serv = 'IL' or
               ln_tip_serv = 'IJ' or ln_tip_serv = 'CI' then
              SGASS_PROVISION_LTE_CP_CX(p_solot,
                                        p_idtareawf,
                                        ln_tip_serv,
                                        p_cod_resp,
                                        p_msj_resp);
              if p_cod_resp < 0 then
                p_cod_resp := -99;
                operacion.pq_3play_inalambrico.p_log_3playi(p_solot,
                                                            'SGASS_PROVISION_LTE_CP_AUTO',
                                                            p_msj_resp,
                                                            'PROVISION LTE SIN VISITA TECNICA: SGASS_PROVISION_LTE_CP',
                                                            ln_resp,
                                                            ls_msj);
                return;
              end if;
            end if;

            -- Actualizacion de Estado de la Provision
            operacion.pq_3play_inalambrico.p_log_3playi(p_solot,
                                                        'SGASS_PROVISION_LTE_CP_AUTO',
                                                        'INICIO',
                                                        'PROVISION LTE SIN VISITA TECNICA: SGASS_PROCESA_EST_PROV',
                                                        ln_resp,
                                                        ls_msj);
            SGASS_PROCESA_EST_PROV(p_solot, p_cod_resp, p_msj_resp);
            if p_cod_resp = 1 then
              p_msj_resp := 'OK';
              operacion.pq_3play_inalambrico.p_log_3playi(p_solot,
                                                          'SGASS_PROVISION_LTE_CP_AUTO',
                                                          p_msj_resp,
                                                          'PROVISION LTE SIN VISITA TECNICA: SGASS_PROVISION_LTE_CP_AUTO',
                                                          ln_resp,
                                                          ls_msj);
            else
              p_cod_resp := -99;
              operacion.pq_3play_inalambrico.p_log_3playi(p_solot,
                                                          'SGASS_PROVISION_LTE_CP_AUTO',
                                                          p_msj_resp,
                                                          'PROVISION LTE SIN VISITA TECNICA: SGASS_PROVISION_LTE_CP',
                                                          ln_resp,
                                                          ls_msj);
            end if;
          else
            --REENVIO PARA PROCESOS SIN VISITA
            SELECT COUNT(1)
              INTO ln_count
              FROM OPERACION.PSGAT_ESTSERVICIO E
             WHERE E.ESSEN_COD_SOLOT = p_solot
               AND E.ESSEV_ESTADO = 'ERRO'
               AND E.ESSEV_COD_OPERACION = 'CX';

            if ln_count > 0 then
              SGASS_PROVISION_LTE_CP_CX(p_solot,
                                        p_idtareawf,
                                        'CX',
                                        p_cod_resp,
                                        p_msj_resp);
              if p_cod_resp <> 0 then
                p_cod_resp := -99;
                operacion.pq_3play_inalambrico.p_log_3playi(p_solot,
                                                            'SGASS_PROVISION_LTE_CP_AUTO',
                                                            p_msj_resp,
                                                            'PROVISION LTE SIN VISITA TECNICA: SGASS_PROVISION_LTE_CP',
                                                            ln_resp,
                                                            ls_msj);
                return;
              end if;
            end if;

            SELECT COUNT(1)
              INTO ln_count
              FROM OPERACION.PSGAT_ESTSERVICIO E
             WHERE E.ESSEN_COD_SOLOT = p_solot
               AND E.ESSEV_ESTADO = 'ERRO'
               AND E.ESSEV_COD_OPERACION = 'IL';

            if ln_count > 0 then
              null;
              --SP DE REENVIO DE IL
            end if;

            SELECT COUNT(1)
              INTO ln_count
              FROM OPERACION.PSGAT_ESTSERVICIO E
             WHERE E.ESSEN_COD_SOLOT = p_solot
               AND E.ESSEV_ESTADO = 'ERRO'
               AND E.ESSEV_COD_OPERACION = 'JN';

            if ln_count > 0 then
              null;
              --SP DE REENVIO DE IL
            end if;

            -- Actualizacion de Estado de la Provision
            operacion.pq_3play_inalambrico.p_log_3playi(p_solot,
                                                        'SGASS_PROVISION_LTE_CP_AUTO',
                                                        'INICIO',
                                                        'PROVISION LTE SIN VISITA TECNICA: SGASS_PROCESA_EST_PROV',
                                                        ln_resp,
                                                        ls_msj);
            SGASS_PROCESA_EST_PROV(p_solot, p_cod_resp, p_msj_resp);
            if p_cod_resp = 1 then
              p_msj_resp := 'OK';
              operacion.pq_3play_inalambrico.p_log_3playi(p_solot,
                                                          'SGASS_PROVISION_LTE_CP_AUTO',
                                                          p_msj_resp,
                                                          'PROVISION LTE SIN VISITA TECNICA: SGASS_PROVISION_LTE_CP_AUTO',
                                                          ln_resp,
                                                          ls_msj);
            else
              p_cod_resp := -99;
              operacion.pq_3play_inalambrico.p_log_3playi(p_solot,
                                                          'SGASS_PROVISION_LTE_CP_AUTO',
                                                          p_msj_resp,
                                                          'PROVISION LTE SIN VISITA TECNICA: SGASS_PROVISION_LTE_CP',
                                                          ln_resp,
                                                          ls_msj);
            end if;

          end if;
        else
          p_cod_resp := -99;
          operacion.pq_3play_inalambrico.p_log_3playi(p_solot,
                                                      'SGASS_PROVISION_LTE_CP_AUTO',
                                                      p_msj_resp,
                                                      'PROVISION LTE SIN VISITA TECNICA: SGASS_ACTUALIZA_ESTADO_LTE',
                                                      ln_resp,
                                                      ls_msj);
        end if;
      else
        p_cod_resp := -99;
        operacion.pq_3play_inalambrico.p_log_3playi(p_solot,
                                                    'SGASS_PROVISION_LTE_CP_AUTO',
                                                    p_msj_resp,
                                                    'PROVISION LTE SIN VISITA TECNICA: SGASS_REGISTRO_ESTADO_LTE',
                                                    ln_resp,
                                                    ls_msj);
      end if;
    else
      p_cod_resp := -99;
      operacion.pq_3play_inalambrico.p_log_3playi(p_solot,
                                                  'SGASS_PROVISION_LTE_CP_AUTO',
                                                  p_msj_resp,
                                                  'PROVISION LTE SIN VISITA TECNICA: SGASS_CONTROL_SERVICIOS',
                                                  ln_resp,
                                                  ls_msj);
    end if;
  EXCEPTION
    WHEN OTHERS THEN
      p_cod_resp := -99;
      p_msj_resp := '-CODIGO  DE ERROR: ' || TO_CHAR(SQLCODE) || CHR(13) ||
                    '-TRAZA DE ERROR:   ' ||
                    DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      operacion.pq_3play_inalambrico.p_log_3playi(p_solot,
                                                  'SGASS_PROVISION_LTE_CP_AUTO',
                                                  p_msj_resp,
                                                  'PROVISION LTE SIN VISITA TECNICA',
                                                  ln_resp,
                                                  ls_msj);
  END;

  PROCEDURE SGASS_ACTUALIZA_ESTADO_PROV(p_codsolot       IN NUMBER,
                                        p_tipo_operacion IN VARCHAR2,
                                        p_codigo_resp    OUT NUMBER,
                                        p_mensaje_resp   OUT VARCHAR2) IS

    ln_estado      NUMBER;
    lv_mensaje     VARCHAR2(4000); --11.0
    lv_cod_msj     VARCHAR2(50); --11.0
    ln_cod_id      NUMBER;
    ln_est_janus   VARCHAR2(10);
    ln_cod_er      NUMBER;
    lv_resul_er    VARCHAR2(4000);

  BEGIN
    p_codigo_resp := 1;
    ln_estado     := 0;
    p_mensaje_resp:= 'OK';

    select s.cod_id
          into ln_cod_id
          from operacion.solot s
         where s.codsolot = p_codsolot;

    CASE p_tipo_operacion
      WHEN 'CX' THEN
        operacion.pkg_contego.sgass_valprovision(p_codsolot, lv_cod_msj, p_mensaje_resp);

        IF lv_cod_msj <> 'OK' THEN
          SGASS_ACTUALIZA_ESTADO_LTE(p_codsolot,
                                     p_tipo_operacion,
                                     p_mensaje_resp,
                                     'ERRO',
                                     ln_cod_er,
                                     lv_resul_er);
          RETURN;
        ELSE
          ln_estado := 1;
        END IF;


      WHEN 'IL' THEN

        SGASS_ESTADO_PROV_IL(ln_cod_id, ln_cod_er, lv_resul_er);
        --( 0 = Proceso Satisfactorio, -1 = Error o Cancelado, -2 = No Existe, -3 = Pendiente)

        IF ln_cod_er = 0 THEN
          ln_estado := 1;
        ELSIF ln_cod_er = -1 or ln_cod_er = -2 THEN
          ln_estado := 2;
        END IF;

      WHEN 'JN' THEN
        SGASS_ESTADO_PROV_JN(ln_cod_id, ln_cod_er, lv_resul_er);
        --(2 = ESTADO POR PROCESAR , 3 = INCONSISTENCIA, 4 = EN PROCESO DE PROVISION,  5 = PROVISION EXITOSA, 6 = ERROR DE PROVISIÓN, -99=NO EXISTE REGISTRO)

        IF ln_cod_er <> 0 THEN
          SGASS_ACTUALIZA_ESTADO_LTE(p_codsolot,
                                     p_tipo_operacion,
                                     p_mensaje_resp,
                                     'ERRO',
                                     ln_cod_er,
                                     lv_resul_er);
          RETURN;
        END IF;

        IF ln_est_janus = 5 THEN
          ln_estado := 1;
        ELSIF ln_est_janus = 3 OR ln_est_janus = 6 OR ln_est_janus = -99 THEN
          ln_estado := 2;
        ELSE
          ln_estado := 3;
        END IF;

        lv_mensaje := lv_resul_er;

    END CASE;

    --PROCESO DE ACTUALIZACION DE ESTADOS
    CASE ln_estado
      WHEN 1 THEN
        SGASS_ACTUALIZA_ESTADO_LTE(p_codsolot,
                                   p_tipo_operacion,
                                   null,
                                   'PROV',
                                   ln_cod_er,
                                   lv_resul_er);
      WHEN 2 THEN
        SGASS_ACTUALIZA_ESTADO_LTE(p_codsolot,
                                   p_tipo_operacion,
                                   lv_mensaje,
                                   'ERRO',
                                   ln_cod_er,
                                   lv_resul_er);
      WHEN 3 THEN
        SGASS_ACTUALIZA_ESTADO_LTE(p_codsolot,
                                   p_tipo_operacion,
                                   lv_mensaje,
                                   'EPLA',
                                   ln_cod_er,
                                   lv_resul_er);
      ELSE
        RETURN;
    END CASE;
  EXCEPTION
    WHEN OTHERS THEN
      p_codigo_resp  := -99;
      p_mensaje_resp := '-CODIGO  DE ERROR: ' || TO_CHAR(SQLCODE) ||
                        CHR(13) || '-TRAZA DE ERROR:   ' ||
                        DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      operacion.pq_3play_inalambrico.p_log_3playi(p_codsolot,
                                                  'SGASS_ACTUALIZA_ESTADO_PROV',
                                                  p_mensaje_resp,
                                                  'Cambio de Plan LTE',
                                                  ln_cod_er,
                                                  lv_resul_er);
  END;

  PROCEDURE SGASS_ESTADO_PROV_IL(p_co_id        IN INTEGER,
                                 p_codigo_resp  OUT INTEGER,
                                 p_mensaje_resp OUT VARCHAR2) IS
  BEGIN
    p_codigo_resp := 0;
    TIM.PP004_SIAC_LTE.SIACSU_ESTADO_PROV_IL@DBL_BSCS_BF(p_co_id,
                                                         p_codigo_resp,
                                                         p_mensaje_resp);

  EXCEPTION
    WHEN OTHERS THEN
      p_codigo_resp  := -1;
      p_mensaje_resp := 'Error al consultar el estado de IL';
  END;

  PROCEDURE SGASS_ESTADO_PROV_JN(p_co_id        IN INTEGER,
                                 p_codigo_resp  OUT INTEGER,
                                 p_mensaje_resp OUT VARCHAR2) IS
  BEGIN
    p_codigo_resp := 0;
    TIM.PP004_SIAC_LTE.SIACSU_CONS_APROVJA@DBL_BSCS_BF(p_co_id,
                                                       p_codigo_resp,
                                                       p_mensaje_resp);

  EXCEPTION
    WHEN OTHERS THEN
      p_codigo_resp  := -1;
      p_mensaje_resp := 'Error al consultar el estado de JANUS';
  END;

  PROCEDURE SGASS_PROCESA_EST_PROV(p_codsolot     IN NUMBER,
                                   p_codigo_resp  OUT INTEGER,
                                   p_mensaje_resp OUT VARCHAR2) IS

    CURSOR cur_est_prov is
      SELECT E.ESSEV_COD_OPERACION -- 12.0
        FROM OPERACION.PSGAT_ESTSERVICIO E
       WHERE E.ESSEN_COD_SOLOT = p_codsolot
         AND E.ESSEV_ESTADO <> 'PROV';

  BEGIN
    p_codigo_resp  := 1;
    p_mensaje_resp := 'OK';

    FOR c_est_prov IN cur_est_prov LOOP
      SGASS_ACTUALIZA_ESTADO_PROV(p_codsolot,
                                  c_est_prov.ESSEV_COD_OPERACION, --12.0
                                  p_codigo_resp,
                                  p_mensaje_resp);
    END LOOP;

  EXCEPTION
    WHEN OTHERS THEN
      p_codigo_resp  := -1;
      p_mensaje_resp := 'Error la procesar los estados de la provisión '|| '- TRAZA DE ERROR:   ' ||
                        DBMS_UTILITY.FORMAT_ERROR_BACKTRACE; --12.0
  END;

  PROCEDURE SGASS_VALIDA_PROV_3PLAY(a_idtareawf IN NUMBER,
                                    a_idwf      IN NUMBER,
                                    a_tarea     IN NUMBER,
                                    a_tareadef  IN NUMBER) IS

    PRAGMA AUTONOMOUS_TRANSACTION;

    ln_codsolot SOLOT.CODSOLOT%TYPE;
    raise_error EXCEPTION;
    ln_count    NUMBER;
    ln_cod_err  NUMBER;
    lv_resp_err VARCHAR2(4000);
    lv_mensaje  VARCHAR2(4000);

  BEGIN

    SELECT S.CODSOLOT
      INTO ln_codsolot
      FROM OPEWF.WF F, OPERACION.SOLOT S
     WHERE F.CODSOLOT = S.CODSOLOT
       AND F.VALIDO = 1
       AND IDWF = a_idwf;

    operacion.pq_3play_inalambrico.p_log_3playi(ln_codsolot,
                                                'SGASS_VALIDA_PROV_3PLAY',
                                                'Inicio del Proceso',
                                                'Cierre de Act. de Serv. Inalámbricos - Cambio de Plan',
                                                ln_cod_err,
                                                lv_resp_err);
    SGASS_PROCESA_EST_PROV(ln_codsolot, ln_cod_err, lv_resp_err);

    operacion.pq_3play_inalambrico.p_log_3playi(ln_codsolot,
                                                'SGASS_PROCESA_EST_PROV',
                                                'Fin del Proceso - '||lv_resp_err,
                                                'Cierre de Act. de Serv. Inalámbricos - Cambio de Plan',
                                                ln_cod_err,
                                                lv_resp_err);

    SELECT COUNT(1)
      INTO ln_count
      FROM OPERACION.PSGAT_ESTSERVICIO E
     WHERE E.ESSEN_COD_SOLOT = ln_codsolot
       AND E.ESSEV_ESTADO <> 'PROV'
       AND E.ESSEV_COD_OPERACION <> 'JN';

    if ln_count > 0 then
      raise raise_error;
    end if;
    operacion.pq_3play_inalambrico.p_log_3playi(ln_codsolot,
                                                'SGASS_VALIDA_PROV_3PLAY',
                                                'OK',
                                                'Cierre de Act. de Serv. Inalámbricos - Cambio de Plan',
                                                ln_cod_err,
                                                lv_resp_err);

    COMMIT;
  EXCEPTION
    WHEN raise_error THEN
      lv_mensaje := 'Algunos servicios no se encuentran provisionados, no se puede cerrar la tarea';
      operacion.pq_3play_inalambrico.p_log_3playi(ln_codsolot,
                                                  'SGASS_VALIDA_PROV_3PLAY',
                                                  lv_mensaje,
                                                  'Cierre de Act. de Serv. Inalámbricos - Cambio de Plan',
                                                  ln_cod_err,
                                                  lv_resp_err);
      rollback;
      raise_application_error(-20500, lv_mensaje);
    WHEN OTHERS THEN
      lv_mensaje := 'ERROR AL EJECUTAR PROC: ' || $$PLSQL_UNIT || '.' ||
                    'SGASS_VALIDA_PROV_3PLAY, ' || CHR(13) || ' PI_IDTAREAWF: ' ||
                    TO_CHAR(A_IDTAREAWF) || CHR(13) || ' PI_IDWF: ' ||
                    TO_CHAR(A_IDWF) || CHR(13) || ' PI_TAREA: ' ||
                    TO_CHAR(A_TAREA) || CHR(13) || ' PI_TAREADEF: ' ||
                    TO_CHAR(A_TAREADEF) || CHR(13) || ' CODIGO DE ERROR: ' ||
                    TO_CHAR(SQLCODE) || CHR(13) || ' MENSAJE DE ERROR: ' ||
                    TO_CHAR(SQLERRM) || ' Linea : (' ||
                    DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ')';
      operacion.pq_3play_inalambrico.p_log_3playi(ln_codsolot,
                                                  'SGASS_VALIDA_PROV_3PLAY',
                                                  lv_mensaje,
                                                  'Cierre de Act. de Serv. Inalámbricos - Cambio de Plan',
                                                  ln_cod_err,
                                                  lv_resp_err);
      rollback;
      raise_application_error(-20001,
                              'Error al activar servicio 3play inalámbrico  : ' ||
                              SQLERRM);

  END;

  PROCEDURE SGASS_ACTUALIZA_CNT_BSCS(a_idtareawf IN NUMBER,
                                     a_idwf      IN NUMBER,
                                     a_tarea     IN NUMBER,
                                     a_tareadef  IN NUMBER) IS

    ln_resp     NUMERIC := 0;
    lv_mensaje  VARCHAR2(4000);
    ln_codsolot NUMBER;
    ln_cod_id   NUMBER;
    lv_idtrs    VARCHAR2(30);
    ln_cod_err  NUMBER;
    lv_resp_err VARCHAR2(4000);

  BEGIN

     --8.0 Ini
     SELECT W.CODSOLOT, A.COD_ID
      INTO ln_codsolot, ln_cod_id
      FROM OPEWF.WF W, SOLOT A
     WHERE A.CODSOLOT = W.CODSOLOT
       AND W.IDWF = a_idwf
       AND W.VALIDO = 1;

    IF ln_cod_id IS NOT NULL THEN
    --8.0 Fin
      operacion.pq_3play_inalambrico.p_log_3playi(ln_codsolot,
                                                  'SGASS_ACTUALIZA_CNT_BSCS',  --8.0
                                                  'Inicio',
                                                  'Validación de Serv. Inalámbricos - Cambio de Plan',
                                                  ln_cod_err,
                                                  lv_resp_err);

      webservice.pq_datos_webservice.actualizar_contrato(ln_cod_id,
                                                         '2', -- Estado: Activo
                                                         '1', -- Razon: Activacion
                                                         lv_idtrs, -- Id. de Transaccion a devolver
                                                         ln_resp,
                                                         lv_mensaje);

      operacion.pq_3play_inalambrico.p_reg_cbscs_lte(ln_codsolot,
                                                     lv_idtrs,
                                                     ln_cod_err,
                                                     lv_resp_err);

      operacion.pq_3play_inalambrico.p_log_3playi(ln_codsolot,
                                                  'SGASS_ACTUALIZA_CNT_BSCS',  --8.0
                                                  lv_mensaje,
                                                  'Validación de Serv. Inalámbricos - Cambio de Plan',
                                                  ln_cod_err,
                                                  lv_resp_err);

      IF ln_resp <> 0 THEN
        raise_application_error(-20500, lv_mensaje);
      END IF;
    ELSE
      raise_application_error(-20500,
                              'La SOT no tiene asociado un Contrato en BSCS.');
    END IF;

  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20001,
                              'Error al actualizar Contrato bscs : ' ||
                              sqlerrm || ' IDTareawf : ' || a_idtareawf ||
                              ' - Idwf : ' || a_idwf || ' - Tarea : ' ||
                              a_tarea || ' - Tareadef : ' || a_tareadef);  --8.0
  END;

  PROCEDURE SGASS_REENVIAR_CONT_BSCS(p_codsolot     IN NUMBER,
                                     p_codigo_resp  OUT INTEGER,
                                     p_mensaje_resp OUT VARCHAR2) IS

    ln_valida_sot NUMBER;
    lv_estado     VARCHAR2(5);

  BEGIN

    select operacion.pq_sga_janus.f_val_status_contrato_bscs(s.cod_id)
      into lv_estado
      from solot s
     where s.codsolot = p_codsolot;

    if lv_estado = 'o' then
      SELECT operacion.pq_sga_iw.f_valida_envio_res_act_iw(p_codsolot)
        INTO ln_valida_sot
        FROM DUAL;

      if ln_valida_sot = 1 then
        p_codigo_resp  := -1;
        p_mensaje_resp := 'No se puede Relanzar cuando la SOT esta en estado Rechazado o Anulado';
        return;
      end if;

      OPERACION.PQ_SGA_JANUS.p_relanza_co_id_bscs_lte(p_codsolot,
                                                      p_codigo_resp,
                                                      p_mensaje_resp);

      if p_codigo_resp <> 1 then
        p_codigo_resp := -1;
        return;
      end if;
    end if;

    p_codigo_resp  := 1;
    p_mensaje_resp := 'OK';

  EXCEPTION
    WHEN OTHERS THEN
      p_codigo_resp  := -1;
      p_mensaje_resp := 'Error al actualizar Contrato bscs : ' || sqlerrm;

  END;

  -------------------------------------------------------------------------------

  PROCEDURE SGASS_VALIDA_SERV_3PLAY(a_idtareawf in number,
                                    a_idwf      in number,
                                    a_tarea     in number,
                                    a_tareadef  in number) is
    ln_cod_id     NUMBER;
    ln_cod_id_old NUMBER;
    ln_codsot     NUMBER;
    ln_estsol     SOLOT.ESTSOL%type;
    ln_cont       NUMBER;
    ln_cod_err    NUMBER;
    lv_resul_err  VARCHAR2(4000);
    lv_estbscs    VARCHAR2(100);
    lv_simcard    VARCHAR2(25);
    lv_numtel     VARCHAR2(20);
    ln_codnumtel  NUMBER;
    ln_request    NUMBER;
    ln_resp       NUMERIC := 0;
    lv_mensaje    VARCHAR2(3000);
    --16.0
    ln_val_onhold NUMBER;
    v_error      NUMBER;
    v_mensaje    VARCHAR2(4000);
    lv_idtrs     VARCHAR2(30);
    --16.0
    cursor c_pid is
      select sp.pid
        from operacion.solotpto sp
       where sp.codsolot = ln_codsot;

    cursor c_inssrv is
      select i.codinssrv, i.tipsrv
        from operacion.inssrv i
       where i.codinssrv in (SELECT sp.codinssrv
                               FROM operacion.solotpto sp
                              where sp.codsolot = ln_codsot);
    cursor c_equ_bscs is
      select a.nro_serie_deco,
             a.nro_serie_tarjeta,
             a.tipo_equipo,
             a.modelo_equipo
        from (select distinct asoc.nro_serie_deco,
                              asoc.nro_serie_tarjeta,
                              (select distinct nvl(crm.abreviacion, '')
                                 from sales.crmdd crm
                                where se.tipequ = to_number(crm.codigon)) tipo_equipo,
                              (select distinct nvl(crm.descripcion, '')
                                 from sales.crmdd crm
                                where se.tipequ = to_number(crm.codigon)) modelo_equipo
                from operacion.tarjeta_deco_asoc asoc,
                     operacion.solotptoequ       se,
                     operacion.tipequ            tieq
               where asoc.codsolot = se.codsolot
                 and se.mac = asoc.nro_serie_deco
                 and se.tipequ = to_number(tieq.tipequ)
                 and (se.tipequ) in
                     (select crm.codigon
                        from sales.crmdd crm
                       where crm.tipcrmdd in
                             (select TIP.TIPCRMDD
                                from SALES.TIPCRMDD TIP
                               where tip.abrev = 'DTHPOSTEQU'))
                 and asoc.codsolot = ln_codsot
                 and se.estado in (15, 4)) a;

    cursor c_equ_bscs_eli is
      select a.nro_serie_deco,
             a.nro_serie_tarjeta,
             a.tipo_equipo,
             a.modelo_equipo
        from (select distinct asoc.nro_serie_deco,
                              asoc.nro_serie_tarjeta,
                              (select distinct nvl(crm.abreviacion, '')
                                 from sales.crmdd crm
                                where se.tipequ = to_number(crm.codigon)) tipo_equipo,
                              (select distinct nvl(crm.descripcion, '')
                                 from sales.crmdd crm
                                where se.tipequ = to_number(crm.codigon)) modelo_equipo
                from operacion.tarjeta_deco_asoc asoc,
                     operacion.solotptoequ       se,
                     operacion.tipequ            tieq
               where asoc.codsolot = se.codsolot
                 and se.mac = asoc.nro_serie_deco
                 and se.tipequ = to_number(tieq.tipequ)
                 and (se.tipequ) in
                     (select crm.codigon
                        from sales.crmdd crm
                       where crm.tipcrmdd in
                             (select TIP.TIPCRMDD
                                from SALES.TIPCRMDD TIP
                               where tip.abrev = 'DTHPOSTEQU'))
                 and asoc.codsolot = ln_codsot
                 and se.estado in (12)) a;

    cursor c_solotpequ is
      select spe.numserie
        from operacion.solotptoequ spe
       where spe.codsolot = ln_codsot
         and spe.numserie is not null;

  BEGIN

    SELECT S.CODSOLOT, S.COD_ID, S.ESTSOL, S.COD_ID_OLD
      INTO ln_codsot, ln_cod_id, ln_estsol, ln_cod_id_old
      FROM OPEWF.WF F, OPERACION.SOLOT S
     WHERE F.CODSOLOT = S.CODSOLOT
       AND F.VALIDO = 1
       AND IDWF = a_idwf;

    SELECT count(1)
      INTO ln_cont
      FROM operacion.inssrv i
     WHERE i.codinssrv in (SELECT sp.codinssrv
                             FROM operacion.solotpto sp
                            where sp.codsolot = ln_codsot);

    IF ln_cont > 0 THEN
      --ini 16.0
      --Relanzamos la Preactivacion del contrato
      select operacion.pq_anulacion_bscs.f_valida_bscs(ln_cod_id)
      into ln_val_onhold
      from dual;

      if ln_val_onhold = 1 then

        operacion.pq_3play_inalambrico.p_log_3playi(ln_codsot,
                                                    'SGASS_VALIDA_SERV_3PLAY',
                                                    'Relanzando la Pre-Activacion del Contrato ' ||
                                                    to_char(ln_cod_id),
                                                    'Cierre de Valid. de Serv. Inalámbricos - Cambio de Plan',
                                                    ln_cod_err,
                                                    lv_resul_err);

        webservice.pq_datos_webservice.actualizar_contrato(ln_cod_id,
                                                           '2', -- Estado: Activo
                                                           '1', -- Razon: Activacion
                                                           lv_idtrs, -- Id. de Transaccion a devolver
                                                           v_error,
                                                           v_mensaje);
      end if;
      --fin 16.0

      operacion.pq_3play_inalambrico.p_log_3playi(ln_codsot,
                                                  'TIM.PP021_VENTA_LTE.F_ESTADO_CO_ID',
                                                  'Inicio del Proceso',
                                                  'Cierre de Valid. de Serv. Inalámbricos - Cambio de Plan',
                                                  ln_cod_err,
                                                  lv_resul_err);

      lv_estbscs := tim.pp021_venta_lte.f_estado_co_id@dbl_bscs_bf(ln_cod_id);

      operacion.pq_3play_inalambrico.p_log_3playi(ln_codsot,
                                                  'TIM.PP021_VENTA_LTE.F_ESTADO_CO_Id',
                                                  'Fin del Proceso : ' ||
                                                  lv_estbscs,
                                                  'Cierre de Valid. de Serv. Inalámbricos - Cambio de Plan',
                                                  ln_cod_err,
                                                  lv_resul_err);

      if lv_estbscs <> 'ax' then
        raise_application_error(-20500,
                                'El estado del contrato no se encuentra en activo con pendiente : ' ||
                                lv_estbscs);
      end if;

      -- Iniciar la Facturacion
      operacion.pq_3play_inalambrico.p_log_3playi(ln_codsot,
                                                  'SGASI_INICIA_FACT',
                                                  'Inicio del Proceso ',
                                                  'Cierre de Valid. de Serv. Inalámbricos - Cambio de Plan',
                                                  ln_cod_err,
                                                  lv_resul_err);

      operacion.pq_siac_cambio_plan_lte.sgasi_inicia_fact(ln_codsot,
                                                          ln_resp,
                                                          lv_mensaje);

      operacion.pq_3play_inalambrico.p_log_3playi(ln_codsot,
                                                  'SGASI_INICIA_FACT',
                                                  'Fin del Proceso - Resultado : ' ||
                                                  lv_mensaje,
                                                  'Cierre de Valid. de Serv. Inalámbricos - Cambio de Plan',
                                                  ln_cod_err,
                                                  lv_resul_err);

      -- Si hay un error en el Inicio de Facturacion
      IF ln_resp <> 0 THEN
        raise_application_error(-20500,
                                'Error en el Inicio de Facturacion (SGASI_INICIA_FACT): ' ||
                                lv_mensaje);
      END IF;

      -- Actualizar Insprd de SGA
      for cx in c_pid loop
        UPDATE OPERACION.INSPRD
           SET ESTINSPRD = 1, FECINI = SYSDATE
         WHERE PID = cx.pid; --8.0
      end loop;

      -- Actualizar Servicios de SGA
      for c1 in c_inssrv loop

        UPDATE OPERACION.INSSRV
           SET ESTINSSRV = 1, FECINI = SYSDATE --8.0
         wHERE CODINSSRV = C1.CODINSSRV;

        if c1.tipsrv = '0062' then
          SELECT REQUEST
            INTO ln_request
            FROM OPERACION.OPE_SRV_RECARGA_DET
           WHERE TIPSRV = '0062'
             AND NUMREGISTRO =
                 (SELECT T.NUMREGISTRO
                    FROM OPERACION.OPE_SRV_RECARGA_CAB T
                   WHERE T.CODSOLOT = ln_codsot);

          -- Actualizar Request de TV
          operacion.pq_3play_inalambrico.p_log_3playi(ln_codsot,
                                                      'SGASU_ACT_REQUEST_PEND',
                                                      'Inicio del Proceso ',
                                                      'Cierre de Valid. de Serv. Inalámbricos - Cambio de Plan',
                                                      ln_cod_err,
                                                      lv_resul_err);
          SGASU_ACT_REQUEST_PEND(ln_request,
                                 '100',
                                 0,
                                 NULL,
                                 NULL,
                                 ln_resp,
                                 lv_mensaje);

          operacion.pq_3play_inalambrico.p_log_3playi(ln_codsot,
                                                      'SGASU_ACT_REQUEST_PEND',
                                                      'Fin del Proceso - Resultado : ' ||
                                                      lv_mensaje,
                                                      'Cierre de Valid. de Serv. Inalámbricos - Cambio de Plan',
                                                      ln_cod_err,
                                                      lv_resul_err);

          if ln_resp <> 0 then
            raise_application_error(-20500,
                                    'Error en el Proceso SGASU_ACT_REQUEST_PEND: ' ||
                                    lv_mensaje);
          end if;

          -- Eliminar Equipos en BSCS
          for c1 in c_equ_bscs_eli loop
            operacion.pq_3play_inalambrico.p_log_3playi(ln_codsot,
                                                        'SGASU_ELIMINA_DECO_LTE',
                                                        'Inicio del Proceso',
                                                        'Cierre de Valid. de Serv. Inalámbricos - Cambio de Plan',
                                                        ln_cod_err,
                                                        lv_resul_err);
            SGASU_ELIMINA_DECO_LTE(ln_cod_id,
                                   c1.nro_serie_deco,
                                   c1.nro_serie_tarjeta,
                                   c1.tipo_equipo,
                                   c1.modelo_equipo,
                                   ln_resp,
                                   lv_mensaje);

            operacion.pq_3play_inalambrico.p_log_3playi(ln_codsot,
                                                        'SGASU_ELIMINA_DECO_LTE',
                                                        'Fin del Proceso - Resultado : ' ||
                                                        lv_mensaje,
                                                        'Cierre de Valid. de Serv. Inalámbricos - Cambio de Plan',
                                                        ln_cod_err,
                                                        lv_resul_err);

            IF ln_resp <> 0 THEN
              raise_application_error(-20500,
                                      'Error en el Proceso (SGASU_REGIS_DECO_LTE): ' ||
                                      lv_mensaje);
            END IF;
          end loop;

          -- Insertar Equipos en BSCS
          for c1 in c_equ_bscs loop
            operacion.pq_3play_inalambrico.p_log_3playi(ln_codsot,
                                                        'SGASU_REGIS_DECO_LTE',
                                                        'Inicio del Proceso',
                                                        'Cierre de Valid. de Serv. Inalámbricos - Cambio de Plan',
                                                        ln_cod_err,
                                                        lv_resul_err);

            SGASU_REGISTRA_DECO_LTE(ln_cod_id,
                                    c1.nro_serie_deco,
                                    c1.nro_serie_tarjeta,
                                    c1.tipo_equipo,
                                    c1.modelo_equipo,
                                    ln_resp,
                                    lv_mensaje);

            operacion.pq_3play_inalambrico.p_log_3playi(ln_codsot,
                                                        'SGASU_REGIS_DECO_LTE',
                                                        'Fin del Proceso - Resultado : ' ||
                                                        lv_mensaje,
                                                        'Cierre de Valid. de Serv. Inalámbricos - Cambio de Plan',
                                                        ln_cod_err,
                                                        lv_resul_err);

            IF ln_resp <> 0 THEN
              raise_application_error(-20500,
                                      'Error en el Proceso (SGASU_REGIS_DECO_LTE): ' ||
                                      lv_mensaje);
            END IF;
          end loop;

        end if;

        if c1.tipsrv = '0004' then
          -- Actualizar Estados de Numeros Telefonicos
          SELECT DISTINCT n.numero, r.codnumtel, n.simcard
            INTO lv_numtel, ln_codnumtel, lv_simcard
            FROM telefonia.reservatel r, telefonia.numtel n
           WHERE r.codnumtel = n.codnumtel
             AND r.numslc = (SELECT sp.numslc
                               FROM operacion.solot sp
                              where sp.codsolot = ln_codsot);

          --modificar para cuando ya tiene numero
          -- Actualizar estado de numero en Sans a Asignado
          operacion.pq_3play_inalambrico.p_log_3playi(ln_codsot,
                                                      'CAMBIAR_STATUS_SANS',
                                                      'Inicio del Proceso',
                                                      'Cierre de Valid. de Serv. Inalámbricos - Cambio de Plan',
                                                      ln_cod_err,
                                                      lv_resul_err);

          webservice.PQ_DATOS_WEBSERVICE.cambiar_status_sans(lpad(lv_numtel,
                                                                  15,
                                                                  '0'),
                                                             '016',
                                                             ln_resp,
                                                             lv_mensaje);
          operacion.pq_3play_inalambrico.p_log_3playi(ln_codsot,
                                                      'CAMBIAR_STATUS_SANS',
                                                      'Fin del Proceso - Resultado : ' ||
                                                      lv_mensaje,
                                                      'Cierre de Valid. de Serv. Inalámbricos - Cambio de Plan',
                                                      ln_cod_err,
                                                      lv_resul_err);

          IF ln_resp <> 0 THEN
            raise_application_error(-20500,
                                    'Error en el Proceso (CAMBIAR_STATUS_SANS): ' ||
                                    lv_mensaje);
          END IF;

          -- Actualizacion de numtel
          UPDATE TELEFONIA.NUMTEL
             SET ESTNUMTEL = 2, CODINSSRV = c1.codinssrv
           WHERE NUMERO = lv_numtel;

          -- Actualizacion de reservatel
          UPDATE TELEFONIA.RESERVATEL
             SET ESTNUMTEL = 2
           WHERE CODNUMTEL = ln_codnumtel;

          -- Actualizacion de SimCard y numero en inssrv
          UPDATE OPERACION.INSSRV
             SET NUMERO = lv_numtel, SIMCARD = lv_simcard
           WHERE codinssrv = c1.codinssrv;
        end if;

      end loop;

      -- Actualizar Los numeros de Serie de los Equipos
      for c1 in c_solotpequ loop
        UPDATE OPERACION.TABEQUIPO_MATERIAL TM
           SET TM.ESTADO = 1
         WHERE TRIM(TM.NUMERO_SERIE) = TRIM(c1.numserie);
      end loop;

      -- Verificando el Estado de SOT para cambiar a Atendido
      if ln_estsol <> 29 then
        operacion.pq_solot.p_chg_estado_solot(ln_codsot,
                                              29,
                                              ln_estsol,
                                              null);
      end if;

      -- ini 15.0
      begin
        operacion.pq_siac_cambio_plan_lte.sgai_carga_equipo_post(ln_codsot, ln_cod_err, lv_resul_err);
      exception
        when others then
          null;
      end;
      -- fin 15.0

    else
      raise_application_error(-20001,
                              'Error al validar servicio 3play inalámbrico : Se debe de tener Servicios Asociados');
    end if;
  EXCEPTION
    when others then
      lv_mensaje := 'ERROR AL EJECUTAR PROC: ' || $$PLSQL_UNIT || '.' ||
                    'SGASS_VALIDA_SERV_3PLAY, ' || CHR(13) ||
                    ' P_CODSOLOT: ' || TO_CHAR(ln_codsot) || CHR(13) ||
                    ' PI_IDTAREAWF: ' || TO_CHAR(A_IDTAREAWF) || CHR(13) ||
                    ' PI_IDWF: ' || TO_CHAR(A_IDWF) || CHR(13) ||
                    ' PI_TAREA: ' || TO_CHAR(A_TAREA) || CHR(13) ||
                    ' PI_TAREADEF: ' || TO_CHAR(A_TAREADEF) || CHR(13) ||
                    ' CODIGO DE ERROR: ' || TO_CHAR(SQLCODE) || CHR(13) ||
                    ' MENSAJE DE ERROR: ' || TO_CHAR(SQLERRM) ||
                    ' Linea : (' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ')';

      operacion.pq_3play_inalambrico.p_log_3playi(ln_codsot,
                                                  'P_VALIDAR_SERVICIO_3PLAYI',
                                                  lv_mensaje,
                                                  'Cierre de Valid. de Serv. Inalámbricos - Cambio de Plan',
                                                  ln_cod_err,
                                                  lv_resul_err);
      raise_application_error(-20001,
                              'Error al validar servicio 3play inalámbrico  : ' ||
                              sqlerrm|| ' Linea : (' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ')');
  END SGASS_VALIDA_SERV_3PLAY;

  PROCEDURE SGASU_ACT_REQUEST_PEND(p_request    IN NUMBER,
                                   p_estado     IN VARCHAR2,
                                   p_errcode    IN INTEGER,
                                   p_errmsg     IN VARCHAR2,
                                   p_nrorequest IN NUMBER,
                                   p_resul      OUT NUMBER,
                                   p_mensaje    OUT VARCHAR2) IS
  BEGIN

    tim.pp021_venta_lte.sp_upd_pend_req@DBL_BSCS_BF(p_request,
                                                    p_estado,
                                                    p_errcode,
                                                    p_errmsg,
                                                    p_nrorequest,
                                                    p_resul,
                                                    p_mensaje);

  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20001,
                              'Error en p_upd_pend_req  : ' || sqlerrm);
  END;

  PROCEDURE SGASU_REGISTRA_DECO_LTE(p_cod_id    in varchar2,
                                    p_seriedeco in varchar2,
                                    p_serietarj in varchar2,
                                    p_tipequipo in varchar2,
                                    p_tipdeco   in varchar2,
                                    p_resultado out integer,
                                    p_msgerr    out varchar2) IS
  BEGIN

    tim.pp021_venta_lte.sp_registra_deco_lte@DBL_BSCS_BF(P_COD_ID,
                                                         P_SERIEDECO,
                                                         P_SERIETARJ,
                                                         P_TIPEQUIPO,
                                                         P_TIPDECO,
                                                         P_RESULTADO,
                                                         P_MSGERR);

  END;

  PROCEDURE SGASU_ELIMINA_DECO_LTE(p_cod_id    in varchar2,
                                   p_seriedeco in varchar2,
                                   p_serietarj in varchar2,
                                   p_tipequipo in varchar2,
                                   p_tipdeco   in varchar2,
                                   p_resultado out integer,
                                   p_msgerr    out varchar2) IS
  BEGIN

    tim.pp021_venta_lte.SP_ELIMINA_DECO_LTE@DBL_BSCS_BF(P_COD_ID,
                                                        P_SERIEDECO,
                                                        P_SERIETARJ,
                                                        P_TIPEQUIPO,
                                                        P_TIPDECO,
                                                        P_RESULTADO,
                                                        P_MSGERR);

  END;

  PROCEDURE SGASS_VISITA_TECNICA(p_oper VARCHAR2) IS

    ln_cod_rep       NUMBER;
    ls_msj_resp      VARCHAR2(1000);
    ln_tiptra        OPERACION.TIPTRABAJO.TIPTRA%TYPE;
    LN_CIERRE_JANUS  NUMBER;
    LN_SERVTELEFONIA NUMBER;
    LN_CIERRE_PROV   NUMBER; --9.0
    CURSOR C_CONF_lTE(K_CODSOLOT NUMBER) IS
      SELECT TW.IDTAREAWF,
             TW.IDWF,
             TW.TAREA,
             TW.TAREADEF,
             XX.CODIGOC,
             XX.CODIGON_AUX,
             XX.DESCRIPCION
        FROM OPEWF.TAREAWF TW,
             OPEWF.WF W,
             (SELECT B.CODIGOC, B.CODIGON, B.CODIGON_AUX, B.DESCRIPCION
                FROM OPERACION.TIPOPEDD A, OPERACION.OPEDD B
               WHERE A.TIPOPEDD = B.TIPOPEDD
                 AND A.ABREV = 'CONF_CP_CIERRE_SVT'
                 AND B.ABREVIACION = P_OPER) XX
       WHERE W.IDWF = TW.IDWF
         AND W.CODSOLOT = K_CODSOLOT
         AND TW.TAREADEF = XX.CODIGON
         AND W.VALIDO = 1
         AND TW.ESTTAREA = 1;

    CURSOR C_SOT_SVT IS
      SELECT S.CODSOLOT, S.COD_ID, S.COD_ID_OLD
        FROM OPERACION.SOLOT S
       WHERE S.TIPTRA = LN_TIPTRA
         AND S.CODMOTOT =
             OPERACION.PQ_VISITA_SGA_SIAC.SGAFUN_GET_CODMOTOT_VISIT('LTE',
                                                                    'LTE_SI_VISTA')
         AND S.ESTSOL = 17
         AND S.COD_ID IS NOT NULL
         AND EXISTS (SELECT 1
                FROM WF F
               WHERE F.CODSOLOT = S.CODSOLOT
                 AND F.VALIDO = 1)
       ORDER BY S.CODSOLOT DESC;

  BEGIN

    SELECT A.CODIGON
      INTO LN_TIPTRA
      FROM OPERACION.OPEDD A, OPERACION.TIPOPEDD B
     WHERE A.TIPOPEDD = B.TIPOPEDD
       AND B.ABREV IN ('TIPTRA_HFC_LTE_CP')
       AND A.ABREVIACION IN ('LTE_SIAC_CPLAN');

    FOR C_SVT IN C_SOT_SVT LOOP
      BEGIN
        FOR C_TAREAS IN C_CONF_lTE(C_SVT.CODSOLOT) LOOP

          CASE C_TAREAS.CODIGOC
            WHEN 'AUTO' THEN
              OPERACION.PQ_SIAC_CAMBIO_PLAN.SGASS_CIERRE_TAREA(c_tareas.idtareawf,
                                                               c_tareas.codigon_aux,
                                                               ln_cod_rep,
                                                               ls_msj_resp);

              if ln_cod_rep = 0 then
                OPERACION.PQ_3PLAY_INALAMBRICO.P_LOG_3PLAYI(c_svt.codsolot,
                                                            'SGASS_VISITA_TECNICA',
                                                            ls_msj_resp,
                                                            c_tareas.descripcion,
                                                            c_svt.cod_id,
                                                            ln_cod_rep);
              else
                OPERACION.PQ_3PLAY_INALAMBRICO.P_LOG_3PLAYI(c_svt.codsolot,
                                                            'SGASS_VISITA_TECNICA',
                                                            ls_msj_resp,
                                                            c_tareas.descripcion,
                                                            c_svt.cod_id,
                                                            ln_cod_rep);
                GOTO SOT;
              end if;

            WHEN 'JANUS' THEN

              OPERACION.PQ_SIAC_CAMBIO_PLAN_LTE.SGASI_CAMBIO_PLAN_JANUS(C_SVT.CODSOLOT,
                                                                        LN_COD_REP,
                                                                        LS_MSJ_RESP);

              -- Cuando no cambia el plan base y opcional se coloca la tarea en No-Interviene
              if LN_COD_REP = -5 then
                OPERACION.PQ_SIAC_CAMBIO_PLAN.SGASS_CIERRE_TAREA(C_TAREAS.IDTAREAWF,
                                                                 8,
                                                                 LN_COD_REP,
                                                                 LS_MSJ_RESP);
              elsif LN_COD_REP = 0 then
                OPERACION.PQ_SIAC_CAMBIO_PLAN.SGASS_CIERRE_TAREA(c_tareas.idtareawf,
                                                                 c_tareas.codigon_aux,
                                                                 ln_cod_rep,
                                                                 ls_msj_resp);
              else
                OPERACION.PQ_3PLAY_INALAMBRICO.P_LOG_3PLAYI(c_svt.codsolot,
                                                            'SGASI_CAMBIO_PLAN_JANUS',
                                                            ls_msj_resp,
                                                            c_tareas.descripcion,
                                                            c_svt.cod_id,
                                                            ln_cod_rep);
                GOTO SOT;
              end if;

              OPERACION.PQ_3PLAY_INALAMBRICO.P_LOG_3PLAYI(c_svt.codsolot,
                                                          'SGASI_CAMBIO_PLAN_JANUS',
                                                          ls_msj_resp,
                                                          c_tareas.descripcion,
                                                          c_svt.cod_id,
                                                          ln_cod_rep);

            WHEN 'INIFACT' THEN

              LN_SERVTELEFONIA := OPERACION.PQ_SGA_JANUS.F_VAL_SERV_TLF_SOT(C_SVT.CODSOLOT);

              IF LN_SERVTELEFONIA = 1 THEN

                SELECT COUNT(TW.IDTAREAWF)
                  INTO LN_CIERRE_JANUS
                  FROM OPEWF.TAREAWF TW,
                       OPEWF.WF W,
                       (SELECT B.CODIGOC, B.CODIGON
                          FROM OPERACION.TIPOPEDD A, OPERACION.OPEDD B
                         WHERE A.TIPOPEDD = B.TIPOPEDD
                           AND A.ABREV = 'CONF_CP_CIERRE_SVT'
                           AND B.ABREVIACION = P_OPER
                           AND B.CODIGOC = 'JANUS') XX
                 WHERE W.IDWF = TW.IDWF
                   AND W.CODSOLOT = C_SVT.CODSOLOT
                   AND TW.TAREADEF = XX.CODIGON
                   AND W.VALIDO = 1
                   AND TW.ESTTAREA = 1;

                IF OPERACION.PQ_SGA_JANUS.F_VAL_PROV_JANUS_PEND(C_SVT.COD_ID) != 0 OR
                   LN_CIERRE_JANUS > 0 THEN

                  GOTO SOT;

                END IF;

              END IF;

              --ini 9.0
              SGASS_PROCESA_EST_PROV(C_SVT.CODSOLOT, ln_cod_rep, LS_MSJ_RESP);

              operacion.pq_3play_inalambrico.p_log_3playi(C_SVT.CODSOLOT,
                                                          'SGASS_PROCESA_EST_PROV',
                                                          'Fin del Proceso - '||LS_MSJ_RESP,
                                                          'Cierre de Act. de Serv. Inalámbricos - Cambio de Plan',
                                                          ln_cod_rep,
                                                          LS_MSJ_RESP);

              SELECT COUNT(1)
                INTO LN_CIERRE_PROV
                FROM OPERACION.PSGAT_ESTSERVICIO E
               WHERE E.ESSEN_COD_SOLOT = C_SVT.CODSOLOT
                 AND E.ESSEV_ESTADO <> 'PROV'
                 AND E.ESSEV_COD_OPERACION <> 'JN';

              if LN_CIERRE_PROV > 0 then

                operacion.pq_3play_inalambrico.p_log_3playi(C_SVT.CODSOLOT,
                                                          'SGASS_PROCESA_EST_PROV',
                                                          'Existe Provision Pendiente de Procesar',
                                                          'Cierre de Act. de Serv. Inalámbricos - Cambio de Plan',
                                                          ln_cod_rep,
                                                          LS_MSJ_RESP);
                GOTO SOT;
              end if;
              --fin 9.0

              OPERACION.PQ_SIAC_CAMBIO_PLAN_LTE.SGASI_INICIA_FACT(C_SVT.CODSOLOT,
                                                                  LN_COD_REP,
                                                                  LS_MSJ_RESP);

              IF LN_COD_REP = 0 THEN
                OPERACION.PQ_SIAC_CAMBIO_PLAN.SGASS_CIERRE_TAREA(c_tareas.idtareawf,
                                                                 c_tareas.codigon_aux,
                                                                 ln_cod_rep,
                                                                 ls_msj_resp);
                OPERACION.PQ_3PLAY_INALAMBRICO.P_LOG_3PLAYI(c_svt.codsolot,
                                                            'SGASS_INICIA_FACT',
                                                            ls_msj_resp,
                                                            c_tareas.descripcion,
                                                            c_svt.cod_id,
                                                            ln_cod_rep);
              ELSE
                OPERACION.PQ_3PLAY_INALAMBRICO.P_LOG_3PLAYI(c_svt.codsolot,
                                                            'SGASS_INICIA_FACT',
                                                            ls_msj_resp,
                                                            c_tareas.descripcion,
                                                            c_svt.cod_id,
                                                            ln_cod_rep);
                GOTO SOT;

              END IF;

            WHEN 'PROV' THEN

              OPERACION.PQ_SIAC_CAMBIO_PLAN_LTE.SGASS_PROVISION_LTE_CP_CX(c_svt.codsolot,
                                                                          c_tareas.idtareawf,
                                                                          'CX',
                                                                          ln_cod_rep,
                                                                          ls_msj_resp);
              if ln_cod_rep = 0 then
                OPERACION.PQ_SIAC_CAMBIO_PLAN_LTE.SGASS_PROVISION_LTE_CP_IL_JN(c_svt.codsolot,
                                                                               c_tareas.idtareawf,
                                                                               'IL',
                                                                               ln_cod_rep,
                                                                               ls_msj_resp);
                if ln_cod_rep = 0 then
                  OPERACION.PQ_SIAC_CAMBIO_PLAN.SGASS_CIERRE_TAREA(c_tareas.idtareawf,
                                                                   c_tareas.codigon_aux,
                                                                   ln_cod_rep,
                                                                   ls_msj_resp);
                  if ln_cod_rep = 0 then
                    OPERACION.PQ_3PLAY_INALAMBRICO.P_LOG_3PLAYI(c_svt.codsolot,
                                                                'SGASS_CIERRE_TAREA',
                                                                ls_msj_resp,
                                                                c_tareas.descripcion,
                                                                c_svt.cod_id,
                                                                ln_cod_rep);
                  else
                    OPERACION.PQ_3PLAY_INALAMBRICO.P_LOG_3PLAYI(c_svt.codsolot,
                                                                'SGASS_CIERRE_TAREA',
                                                                ls_msj_resp,
                                                                c_tareas.descripcion,
                                                                c_svt.cod_id,
                                                                ln_cod_rep);
                    GOTO SOT;
                  end if;
                else
                  OPERACION.PQ_3PLAY_INALAMBRICO.P_LOG_3PLAYI(c_svt.codsolot,
                                                              'SGASS_PROVISION_LTE_CP_IL_JN',
                                                              ls_msj_resp,
                                                              c_tareas.descripcion,
                                                              c_svt.cod_id,
                                                              ln_cod_rep);
                  GOTO SOT;
                end if;
              else
                OPERACION.PQ_3PLAY_INALAMBRICO.P_LOG_3PLAYI(c_svt.codsolot,
                                                            'SGASS_PROVISION_LTE_CP_CX',
                                                            ls_msj_resp,
                                                            c_tareas.descripcion,
                                                            c_svt.cod_id,
                                                            ln_cod_rep);
                GOTO SOT;
              end if;
              -- PENDIENTE --
            WHEN 'BSCS' THEN
              -- Proceso que asocia el CHIP LTE
              OPERACION.PQ_SIAC_CAMBIO_PLAN.SGASS_CIERRE_TAREA(c_tareas.idtareawf,
                                                               c_tareas.codigon_aux,
                                                               ln_cod_rep,
                                                               ls_msj_resp);
            WHEN 'VALIDA' THEN

              SGASS_REENVIAR_CONT_BSCS(c_svt.codsolot,
                                       ln_cod_rep,
                                       ls_msj_resp);
              if ln_cod_rep = 1 then

                if ln_cod_rep = 0 then
                  OPERACION.PQ_3PLAY_INALAMBRICO.P_LOG_3PLAYI(c_svt.codsolot,
                                                              'SGASS_PROVISION_LTE_CP_CX',
                                                              ls_msj_resp,
                                                              c_tareas.descripcion,
                                                              c_svt.cod_id,
                                                              ln_cod_rep);
                else
                  OPERACION.PQ_3PLAY_INALAMBRICO.P_LOG_3PLAYI(c_svt.codsolot,
                                                              'SGASS_PROVISION_LTE_CP_CX',
                                                              ls_msj_resp,
                                                              c_tareas.descripcion,
                                                              c_svt.cod_id,
                                                              ln_cod_rep);
                  GOTO SOT;
                end if;
              else
                OPERACION.PQ_3PLAY_INALAMBRICO.P_LOG_3PLAYI(c_svt.codsolot,
                                                            'SGASS_PROVISION_LTE_CP_CX',
                                                            ls_msj_resp,
                                                            c_tareas.descripcion,
                                                            c_svt.cod_id,
                                                            ln_cod_rep);
                GOTO SOT;
              end if;

          END CASE;

          <<SOT>>
          LN_COD_REP := 0;
        END LOOP;

        COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
          LN_COD_REP  := SQLERRM;
          LS_MSJ_RESP := 'MENSAJE DE ERROR: ' || TO_CHAR(SQLERRM) ||
                         CHR(13) || '- TRAZA DE ERROR:   Linea (' ||
                         DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ')';

          OPERACION.PQ_3PLAY_INALAMBRICO.P_LOG_3PLAYI(c_svt.codsolot,
                                                      'SGASS_VISITA_TECNICA',
                                                      ls_msj_resp,
                                                      'Proceso de Atencion de SOT Automatica',
                                                      ln_cod_rep,
                                                      LS_MSJ_RESP);
      END;
    END LOOP;
  END;

  -- Crear un SP para que se invocado desde la Tarea "Cambio de Plan JANUS-LTE"
  PROCEDURE SGASI_CAMBIO_PLAN_JANUS(AN_CODSOLOT IN NUMBER,
                                    K_ERROR     OUT NUMBER,
                                    K_MENSAJE   OUT VARCHAR2) IS

    V_ERROR   NUMBER;
    V_MENSAJE VARCHAR2(4000);

    LN_CUSTOMER NUMBER;
    LV_NUMERO   VARCHAR2(20);

    LN_COD_ID           SOLOT.COD_ID%TYPE;
    LN_COD_ID_OLD       SOLOT.COD_ID_OLD%TYPE;
    LN_MAX_CODSOLOT_OLD SOLOT.CODSOLOT%TYPE;
    LN_FLG_TLF_NEW      NUMBER;
    LN_FLG_TLF_OLD      NUMBER;
    ERROR_GENERAL EXCEPTION;
    LV_TARFIF_PROV_NEW VARCHAR2(200);
    LV_TARFIF_PROV_OLD VARCHAR2(200);
    LN_EXI_JANUS       NUMBER;
    error_general_log exception;
    ln_tmcode     NUMBER;
    ln_sncode     NUMBER;
    LV_NUMERO_OLD INSSRV.NUMERO%TYPE;
  BEGIN

    K_ERROR   := 0;
    K_MENSAJE := 'Exito';

    SELECT S.COD_ID_OLD,
           S.COD_ID,
           S.CUSTOMER_ID,
           OPERACION.PQ_SGA_IW.F_MAX_SOT_X_COD_ID(S.COD_ID_OLD), -- Obtener la ultima SOT del contrato anterior
           OPERACION.PQ_SGA_JANUS.F_VAL_SERV_TLF_SOT(S.CODSOLOT), -- Validar si la SOT tiene el servicio de Telefonia
           (SELECT distinct INS.NUMERO
              FROM SOLOTPTO PTO, INSSRV INS
             WHERE PTO.CODINSSRV = INS.CODINSSRV
               AND PTO.CODSOLOT = S.CODSOLOT
               AND INS.TIPINSSRV = 3) -- Obtener el Numero Telefonico Actual
      INTO LN_COD_ID_OLD,
           LN_COD_ID,
           LN_CUSTOMER,
           LN_MAX_CODSOLOT_OLD,
           LN_FLG_TLF_NEW,
           LV_NUMERO
      FROM SOLOT S
     WHERE S.CODSOLOT = AN_CODSOLOT;

    LN_FLG_TLF_OLD := OPERACION.PQ_SGA_JANUS.F_VAL_SERV_TLF_SOT(LN_MAX_CODSOLOT_OLD);
    --ini 5.0
    -- Plan Antiguo (Telefonia Si) --> Plan Nuevo(Telefonia Si)
    IF LN_FLG_TLF_NEW = LN_FLG_TLF_OLD AND LN_FLG_TLF_NEW != 0 THEN

      LN_EXI_JANUS := OPERACION.PQ_SGA_JANUS.F_VAL_EXIS_LINEA_JANUS(LV_NUMERO);

      IF LN_EXI_JANUS = 1 THEN

        LV_TARFIF_PROV_NEW := OPERACION.PQ_SGA_BSCS.F_GET_TARFIF_PROV_TLF_LTE(LN_COD_ID);

        LV_TARFIF_PROV_OLD := OPERACION.PQ_SGA_BSCS.F_GET_TARFIF_PROV_TLF_LTE(LN_COD_ID_OLD);

        IF LV_TARFIF_PROV_NEW != LV_TARFIF_PROV_OLD THEN
          OPERACION.PQ_SGA_JANUS.p_cambio_plan_janus_hfc(AN_CODSOLOT,
                                                         V_ERROR,
                                                         V_MENSAJE);

          IF V_ERROR != 1 THEN
            K_ERROR   := V_ERROR;
            K_MENSAJE := V_MENSAJE;
          END IF;
        ELSE
          K_ERROR   := -5;
          K_MENSAJE := 'Mismo Tarrift_ID';
        END IF;

      ELSE
        ln_tmcode := tim.pp021_venta_lte.f_get_plan@dbl_bscs_bf(ln_cod_id);
        ln_sncode := tim.pp021_venta_lte.f_get_serv_tel@dbl_bscs_bf(ln_cod_id);

        operacion.pq_3play_inalambrico.p_provision_janus(ln_cod_id,
                                                         LN_CUSTOMER,
                                                         ln_tmcode,
                                                         ln_sncode,
                                                         'A',
                                                         v_error,
                                                         V_MENSAJE);
        IF V_ERROR <> 0 THEN
          K_MENSAJE := V_MENSAJE;
          raise error_general;
        END IF;

        K_ERROR   := 0;
        K_MENSAJE := 'Se genero programo provision de Alta Janus porque la linea no esta Registrada';

      END IF;
    -- Plan Antiguo (Telefonia Si) --> Plan Nuevo(Telefonia No)
    ELSIF LN_FLG_TLF_NEW = 0 AND LN_FLG_TLF_OLD = 1 THEN
      -- Baja en JANUS
      BEGIN
        SELECT DISTINCT INS.NUMERO --14.0
          INTO LV_NUMERO_OLD
          FROM SOLOTPTO PTO, INSSRV INS
         WHERE PTO.CODINSSRV = INS.CODINSSRV
           AND PTO.CODSOLOT = LN_MAX_CODSOLOT_OLD
           AND INS.TIPINSSRV = 3;
      EXCEPTION
        WHEN OTHERS THEN
          LV_NUMERO_OLD := NULL;
      END;

      IF LV_NUMERO_OLD IS NOT NULL THEN
        OPERACION.PQ_SGA_JANUS.SGASI_BAJA_JANUS_TLFCLI(lv_numero_old,
                                                       LN_CUSTOMER,
                                                       ln_cod_id,
                                                       V_ERROR,
                                                       V_MENSAJE);
        if V_ERROR = 1 then
          K_ERROR   := 0;
          K_MENSAJE := V_MENSAJE;
        else
          K_ERROR   := V_ERROR;
          K_MENSAJE := V_MENSAJE;
        end if;
      ELSE
        K_MENSAJE := 'No tiene Asignado Numero Telefonico en la INSSRV';
        raise error_general;
      END IF;

      -- Bajar en SANZDB
      -- Bajar en SGA
    -- Plan Antiguo (Telefonia No) --> Plan Nuevo(Telefonia Si)
    ELSIF LN_FLG_TLF_NEW = 1 AND LN_FLG_TLF_OLD = 0 THEN
       ln_tmcode := tim.pp021_venta_lte.f_get_plan@dbl_bscs_bf(ln_cod_id);
       ln_sncode := tim.pp021_venta_lte.f_get_serv_tel@dbl_bscs_bf(ln_cod_id);

        operacion.pq_3play_inalambrico.p_provision_janus(ln_cod_id,
                                                         LN_CUSTOMER,
                                                         ln_tmcode,
                                                         ln_sncode,
                                                         'A',
                                                         v_error,
                                                         V_MENSAJE);
        IF V_ERROR <> 0 THEN
          K_MENSAJE := V_MENSAJE;
          raise error_general;
        END IF;

        K_ERROR   := 0;
        K_MENSAJE := 'Se programo provision de Alta Janus porque antes no tenía el servicio de telefonia';

    ELSE
      K_ERROR   := 0;
      K_MENSAJE := 'Cliente no tiene servicio de Telefonia';
    END IF;
    --fin 5.0
  EXCEPTION
    when error_general then
      K_ERROR := -10;
    WHEN OTHERS THEN
      K_ERROR   := -10;
      K_MENSAJE := 'SGASI_CAMBIO_PLAN_JANUS : Error en el Proceso ' ||
                   ' Linea : (' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ')';

  END SGASI_CAMBIO_PLAN_JANUS;

  PROCEDURE SGASI_INICIA_FACT(K_CODSOLOT IN NUMBER,
                              K_ERROR    OUT NUMBER,
                              K_MENSAJE  OUT VARCHAR2) IS

    V_CODSOLOT   operacion.solot.codsolot%TYPE;
    v_error      NUMBER;
    v_mensaje    VARCHAR2(4000);
    v_cod_id     operacion.solot.cod_id%TYPE;
    v_cod_id_old operacion.solot.cod_id%TYPE;
    lv_numslc    operacion.solot.numslc%TYPE;
    ln_tiptra    operacion.solot.tiptra%TYPE;
    lv_numregistro regvtamentab.numregistro%type;
    ln_codsolot_cambio operacion.solot.codsolot%TYPE;
    v_tiptra_cp  NUMBER;
    v_val_onhold NUMBER;
    error_general exception;
    lv_idtrs     VARCHAR2(30);
    ln_cod_err   number;
    lv_resul_err varchar2(4000);
   --ini 11.0
    ln_cant_dig_chip number;
    V_SM_ID          number;
    V_PORT_ID        number;
    ln_reason        number; --12.0
    cursor c_alta is
      select distinct rpad(se.numserie, ln_cant_dig_chip) as iccid, --8.0
                      se.mac as msisdn,
                      decode(se.estado, 15, 'CP', 4, 'AN', 'OTRO') accion_bscs
        from solotptoequ se,
             solot s,
             solotpto sp,
             inssrv i,
             tipequ t,
             almtabmat a,
             (select a.codigon tipequ, codigoc grupo
                from opedd a, tipopedd b
               where a.tipopedd = b.tipopedd
                 and b.abrev = 'TIPEQU_LTE_TLF') equ_conax
       where se.codsolot = s.codsolot
         and s.codsolot = sp.codsolot
         and se.punto = sp.punto
         and sp.codinssrv = i.codinssrv
         and t.tipequ = se.tipequ
         and a.codmat = t.codtipequ
         and se.codsolot = K_CODSOLOT
         and t.tipequ = equ_conax.tipequ
         and equ_conax.grupo = '3';
     --fin 11.0
  BEGIN
    v_codsolot := k_codsolot;
    ln_cant_dig_chip := OPERACION.PQ_SGA_JANUS.F_GET_CONSTANTE_CONF('CANDIGCHIPLTE'); --11.0

    k_error   := 0;
    k_mensaje := 'Exito en el Proceso';

    select s.cod_id, s.cod_id_old, s.tiptra, s.numslc
      into v_cod_id, v_cod_id_old, ln_tiptra, lv_numslc
      from solot s
     where s.codsolot = v_codsolot;

    select operacion.pq_anulacion_bscs.f_valida_bscs(v_cod_id)
      into v_val_onhold
      from dual;

    if v_val_onhold = 1 then
      operacion.pq_3play_inalambrico.p_log_3playi(v_codsolot,
                                                  'SGASI_INICIA_FACT',
                                                  'Relanzando la Pre-Activacion del Contrato ' ||
                                                  to_char(v_cod_id),
                                                  'Cierre de Valid. de Serv. Inalámbricos - Cambio de Plan',
                                                  ln_cod_err,
                                                  lv_resul_err);
      webservice.pq_datos_webservice.actualizar_contrato(v_cod_id,
                                                         '2', -- Estado: Activo
                                                         '1', -- Razon: Activacion
                                                         lv_idtrs, -- Id. de Transaccion a devolver
                                                         v_error,
                                                         v_mensaje);
    end if;

    select operacion.pq_sga_bscs.f_get_is_cp_hfc(v_codsolot)
      into v_tiptra_cp
      from dual;

    -- desactivacion de contrario anterior
    if v_tiptra_cp > 0 then
      operacion.pq_3play_inalambrico.p_log_3playi(v_codsolot,
                                                  'SGASI_INICIA_FACT',
                                                  '(Inicio) Desactivando Contrato Anterior ' ||
                                                  to_char(v_cod_id_old),
                                                  'Cierre de Valid. de Serv. Inalámbricos - Cambio de Plan',
                                                  ln_cod_err,
                                                  lv_resul_err);
      --ini 12.0
      select a.codigon
        into ln_reason
        from opedd a, tipopedd b, solot s
       where a.tipopedd = b.tipopedd
         and b.abrev = 'SGAREASONTIPMOTOT'
         and a.codigon_aux = s.tiptra
         and s.codsolot = v_codsolot
         and a.codigoc = '1';
      --fin 12.0

      OPERACION.PQ_SIAC_CAMBIO_PLAN_LTE.SGASS_DESACTIVA_CONTRATO_BSCS(v_cod_id_old,
                                                                      ln_reason,
                                                                      v_error,
                                                                      v_mensaje);

      operacion.pq_3play_inalambrico.p_log_3playi(v_codsolot,
                                                  'SGASI_INICIA_FACT',
                                                  '(Fin) Desactivando Contrato Anterior ' ||
                                                  to_char(v_cod_id_old) ||
                                                  ' - Mensaje: ' ||
                                                  v_mensaje,
                                                  'Cierre de Valid. de Serv. Inalámbricos - Cambio de Plan',
                                                  ln_cod_err,
                                                  lv_resul_err);

      if v_error <> 1 then
        rollback;
        v_mensaje := 'Error en la Desactivacion del Contrato Anterior por Cambio de Plan : ' ||
                     v_mensaje;
        raise error_general;
      end if;
    end if;

    select operacion.pq_anulacion_bscs.f_valida_bscs(v_cod_id)
      into v_val_onhold
      from dual;

    if v_val_onhold = 1 then
      v_error   := -1;
      v_mensaje := 'El Contrato se encuentra en OnHold : ';
      raise error_general;
    end if;

    operacion.pq_3play_inalambrico.p_log_3playi(v_codsolot,
                                                'SGASI_INICIA_FACT',
                                                'Inicio del Proceso de Facturacion del Contrato ' ||
                                                to_char(v_cod_id),
                                                'Cierre de Valid. de Serv. Inalámbricos - Cambio de Plan',
                                                ln_cod_err,
                                                lv_resul_err);

  --ini 11.0
    begin
      for c in c_alta loop
        if c.msisdn is not null and c.iccid is not null then
          BEGIN
              SELECT S.SM_ID,P.PORT_ID
              INTO V_SM_ID , V_PORT_ID
              FROM STORAGE_MEDIUM@DBL_BSCS_BF S,PORT@DBL_BSCS_BF P
              WHERE S.SM_ID =P.SM_ID
              and S.SM_SERIALNUM = c.iccid;
          EXCEPTION
             WHEN OTHERS THEN
                V_SM_ID := null;
                V_PORT_ID := null;
          END;

          if V_PORT_ID is not null then
            -- ASIGNAMOS IMSI
            UPDATE PORT@DBL_BSCS_BF P
               SET P.PORT_STATUS       = 'a',
                   P.PORT_STATUSMODDAT = SYSDATE,
                   P.PORT_MODDATE      = SYSDATE
             WHERE P.PORT_ID = V_PORT_ID;
          end if;

          if V_SM_ID is not null then
            -- ASIGNAMOS ICCID
            UPDATE STORAGE_MEDIUM@DBL_BSCS_BF P
               SET P.SM_STATUS          = 'a',
                   P.SM_STATUS_MOD_DATE = SYSDATE,
                   P.SM_MODDATE         = SYSDATE
             WHERE P.SM_ID = V_SM_ID;
           end if;
        end if;
      end loop;
    exception
      when others then
       v_mensaje := 'Error en la actualizacion del SIMCARD : ' || sqlerrm;
       operacion.pq_3play_inalambrico.p_log_3playi(v_codsolot,
                                                    'ACTUALIZACION_SIMCARD_IMSI',
                                                    'Error : ' || v_mensaje,
                                                    'Actualizacion de SIMCARD e IMSI',
                                                    ln_cod_err,
                                                    lv_resul_err);
    end;
    --fin 11.0

    operacion.pq_3play_inalambrico.p_inicia_fact(v_cod_id,
                                                 sysdate,
                                                 v_error,
                                                 v_mensaje);

    operacion.pq_3play_inalambrico.p_log_3playi(v_codsolot,
                                                'SGASI_INICIA_FACT',
                                                'Fin del Proceso de Facturacion del Contrato ' ||
                                                to_char(v_cod_id) ||
                                                ' - Mensaje: ' || v_mensaje,
                                                'Cierre de Valid. de Serv. Inalámbricos - Cambio de Plan',
                                                ln_cod_err,
                                                lv_resul_err);
    if v_error <> 0 then
      v_mensaje := 'Error en el Inicio de Facturacion del Contrato : ' ||
                   v_mensaje;
      raise error_general;
    else
      BEGIN
        OPERACION.PQ_SGA_BSCS.P_LIBERA_REQUEST_CO_ID(v_cod_id,
                                                     v_error,
                                                     v_mensaje);
    operacion.pq_3play_inalambrico.p_log_3playi(v_codsolot,
                                                    'LIBERA_REQUEST_CP_LTE',
                                                    'Mensaje : ' || v_mensaje,
                                                    'Liberacion de Request CP LTE',
                                                    ln_cod_err,
                                                    lv_resul_err);
      EXCEPTION
        WHEN OTHERS THEN
          v_mensaje := 'Error : ' || sqlerrm || ' Linea (' ||
                            DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ')';
          operacion.pq_3play_inalambrico.p_log_3playi(v_cod_id,
                                                      'SGASS_DESACTIVA_CONTRATO_BSCS',
                                                      'Error en el Proceso ' ||
                                                      ' - Mensaje : ' ||
                                                      v_mensaje,
                                                      'Cierre de Valid. de Serv. Inalámbricos - Cambio de Plan',
                                                      ln_cod_err,
                                                      lv_resul_err);
      END;
    end if;

    --Generacion de SOT de Baja
    begin
      operacion.pq_3play_inalambrico.p_log_3playi(v_codsolot,
                                                  'GENERA_SOT_BAJA',
                                                  'iinicio del Proceso',
                                                  'Generacion de SOT de Baja por CP',
                                                  ln_cod_err,
                                                  lv_resul_err);
      select distinct numregistro
        into lv_numregistro
        from regvtamentab
       where numslc = lv_numslc;

      sales.p_autogenerar_solot_baja(lv_numregistro,
                                     v_codsolot,
                                     ln_tiptra,
                                     ln_codsolot_cambio);

      operacion.pq_solot.p_ejecutar_solot(ln_codsolot_cambio);
      commit;
  exception
      when others then
        v_mensaje := 'Error en la generacion SOT de Baja : ' || sqlerrm;
        operacion.pq_3play_inalambrico.p_log_3playi(v_codsolot,
                                                    'GENERA_SOT_BAJA_CP',
                                                    'Error : ' || v_mensaje,
                                                    'Generacion de SOT de Baja por CP',
                                                    ln_cod_err,
                                                    lv_resul_err);
    end;

    operacion.pq_3play_inalambrico.p_log_3playi(v_codsolot,
                                                'SGASI_INICIA_FACT',
                                                'Inicio Proceso Tope Consumo (SGASU_ACT_TOPE_CONSUMO)',
                                                'Cierre de Valid. de Serv. Inalámbricos - Cambio de Plan',
                                                ln_cod_err,
                                                lv_resul_err);
    --INI 5.0
    OPERACION.PQ_SIAC_CAMBIO_PLAN_LTE.SGASU_ACT_TOPE_CONSUMO(v_codsolot,
                                                             v_error,
                                                             v_mensaje);

    operacion.pq_3play_inalambrico.p_log_3playi(v_codsolot,
                                                'SGASI_INICIA_FACT',
                                                'Fin Proceso Tope Consumo (SGASU_ACT_TOPE_CONSUMO)' ||
                                                ' - Mensaje : ' ||
                                                v_mensaje,
                                                'Cierre de Valid. de Serv. Inalámbricos - Cambio de Plan',
                                                ln_cod_err,
                                                lv_resul_err);
    if v_error <> 0 then
      v_mensaje := 'Error en la activación de Tope de Consumo : ' ||
                   v_mensaje;
      raise error_general;
    end if;
    --FIN 5.0
  exception
    when error_general then
      k_error   := v_error;
      k_mensaje := v_mensaje;
    when others then
      k_error   := -1;
      k_mensaje := 'ERROR AL EJECUTAR FNC: ' || $$PLSQL_UNIT || '.' ||
                   'SGASI_INICIA_FACT, ' || CHR(13) || 'P_CODSOLOT: ' ||
                   TO_CHAR(V_CODSOLOT) || CHR(13) || 'CODIGO DE ERROR: ' ||
                   TO_CHAR(SQLCODE) || CHR(13) || 'MENSAJE DE ERROR: ' ||
                   TO_CHAR(SQLERRM) || ' Linea : (' ||
                   DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ')';
  END;

  PROCEDURE SGASS_DESACTIVA_CONTRATO_BSCS(p_co_id        IN INTEGER,
                                          p_reason       IN INTEGER,
                                          p_codigo_resp  OUT INTEGER,
                                          p_mensaje_resp OUT VARCHAR2) IS
    lv_request_id NUMBER;
    ln_coderror   number;
    lv_resul_err  varchar2(4000);
  BEGIN
    p_codigo_resp := 1;
    p_mensaje_resp:= 'Ok';

    -- Cambiar SP debido a que este SP envia la baja total a IL
    TIM.TIM111_PKG_ACCIONES_SGA.SP_CONTR_DESACTIVA_CP@DBL_BSCS_BF(p_co_id,
                                                                  p_reason, --12.0
                                                                  'USRSGA',
                                                                  lv_request_id,
                                                                  p_mensaje_resp);

    BEGIN
      OPERACION.PQ_SGA_BSCS.P_LIBERA_REQUEST_CO_ID(p_co_id,
                                                   ln_coderror,
                                                   p_mensaje_resp);
    EXCEPTION
      WHEN OTHERS THEN
        p_mensaje_resp := 'Error : ' || sqlerrm || ' Linea (' ||
                          DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ')';
        operacion.pq_3play_inalambrico.p_log_3playi(p_co_id,
                                                    'SGASS_DESACTIVA_CONTRATO_BSCS',
                                                    'Error en el Proceso ' ||
                                                    ' - Mensaje : ' ||
                                                    p_mensaje_resp,
                                                    'Cierre de Valid. de Serv. Inalámbricos - Cambio de Plan',
                                                    ln_coderror,
                                                    lv_resul_err);
    END;
  EXCEPTION
    WHEN OTHERS THEN
      p_codigo_resp  := -1;
      p_mensaje_resp := 'Error al consultar el estado de IL : Linea (' ||
                        DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ')';
  END;

  PROCEDURE SGASI_ASIGNAR_NUMERO(k_codsolot IN NUMBER,
                                 k_numero   IN VARCHAR2,
                                 k_mensaje  IN OUT VARCHAR2,
                                 k_error    IN OUT NUMBER) IS

    n_error     NUMBER;
    v_mensaje   VARCHAR2(1000);
    v_numslc    vtadetptoenl.numslc%TYPE;
    n_codnumtel numtel.codnumtel%TYPE;
    n_codinssrv inssrv.codinssrv%TYPE;
    v_codcli    solot.codcli%TYPE;
    n_cod_id    solot.cod_id%TYPE;
    n_idtrs     OPERACION.TRS_INTERFACE_IW.IDTRS%TYPE;
    n_estinssrv NUMBER;
    n_estsol    NUMBER;

  BEGIN
    SELECT estsol, codcli, numslc, cod_id
      INTO n_estsol, v_codcli, v_numslc, n_cod_id
      FROM operacion.solot
     WHERE codsolot = k_codsolot;

    SELECT a.estinssrv, a.codinssrv
      INTO n_estinssrv, n_codinssrv
      FROM operacion.inssrv a, operacion.solotpto b, operacion.insprd c
     WHERE a.codinssrv = b.codinssrv
       AND b.codsolot = k_codsolot
       AND b.pid = c.pid
       AND tipinssrv = 3
       AND c.flgprinc = 1;

    IF n_estsol = 17 AND n_estinssrv = 4 THEN
      SELECT codnumtel
        INTO n_codnumtel
        FROM telefonia.numtel
       WHERE numero = k_numero;

      DELETE FROM telefonia.reservatel
       WHERE codcli = v_codcli
         AND numslc = v_numslc;

      UPDATE operacion.inssrv
         SET numero = k_numero
       WHERE codinssrv = n_codinssrv;

      UPDATE telefonia.numtel
         SET estnumtel = 2, codinssrv = n_codinssrv, fecasg = SYSDATE
       WHERE codnumtel = n_codnumtel;

      INSERT INTO telefonia.reservatel
        (codnumtel, numslc, numpto, valido, estnumtel, codcli, publicar)
      VALUES
        (n_codnumtel, v_numslc, '00002', 1, 2, v_codcli, 0);
      n_error := 0;
    ELSE
      v_mensaje := 'Validar si la SOT se encuentra en Ejecucion o el Estado del Servicio es invalido.';
      n_error   := -2;
    END IF;
    k_mensaje := v_mensaje;
    k_error   := n_error;
  EXCEPTION
    WHEN OTHERS THEN
      k_mensaje := 'ERROR AL EJECUTAR FNC: ' || $$PLSQL_UNIT || '.' ||
                   'SGASI_ASIGNA_NRO_LTE, ' || CHR(13) || 'P_CODSOLOT: ' ||
                   TO_CHAR(k_codsolot) || CHR(13) || 'CODIGO DE ERROR: ' ||
                   TO_CHAR(SQLCODE) || CHR(13) || 'MENSAJE DE ERROR: ' ||
                   TO_CHAR(SQLERRM); -- 3.0

      k_error := SQLCODE;
      IF k_error < 0 THEN
        OPERACION.PQ_IW_SGA_BSCS.p_reg_log(v_codcli,
                                           NULL,
                                           n_idtrs,
                                           k_codsolot,
                                           NULL,
                                           k_error,
                                           k_mensaje,
                                           n_cod_id,
                                           'Asignar Numero Telefonico');
      END IF;
      RAISE_APPLICATION_ERROR(-20000,
                              k_mensaje || CHR(13) || ' TRAZA DE ERROR:   ' ||
                              DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
  END;

  PROCEDURE SGASS_OBTIENE_NROANT(K_CODSOLOT IN NUMBER, K_NUMERO OUT NUMBER) IS
    v_customer_id operacion.solot.customer_id%TYPE;
    v_cod_id_ant  NUMBER;
    v_numero      NUMBER;
  BEGIN
    SELECT s.customer_id
      INTO v_customer_id
      FROM operacion.solot s
     WHERE s.codsolot = K_CODSOLOT;

    v_cod_id_ant := SGAFUN_GET_COD_ID_ANT(v_customer_id);
    v_numero     := SGAFUN_GET_NUMERO_TELF_ACT(v_cod_id_ant);

    k_numero := v_numero;
  EXCEPTION
    WHEN OTHERS THEN
      k_numero := NULL;
  END;

  PROCEDURE SGASI_ASIGNA_NRO_LTE(a_idtareawf IN NUMBER,
                                 a_idwf      IN NUMBER,
                                 a_tarea     IN NUMBER,
                                 a_tareadef  IN NUMBER) IS

    v_codsolot     operacion.solot.codsolot%TYPE;
    v_numero       NUMBER;
    v_error        NUMBER;
    v_mensaje      VARCHAR2(4000);
    v_msg_error      VARCHAR2(4000);
    v_codsolot_old operacion.solot.codsolot%TYPE;
    LN_FLG_TLF_OLD NUMBER;
    LN_FLG_TLF_new NUMBER;

  BEGIN
    SELECT s.codsolot, OPERACION.PQ_SGA_IW.F_MAX_SOT_X_COD_ID(S.COD_ID_OLD)
      INTO v_codsolot, v_codsolot_old
      FROM wf f, solot s
     WHERE f.codsolot = s.codsolot
       AND f.valido = 1
       AND idwf = a_idwf;
    --ini 5.0
    --- SGASS_OBTIENE_NROANT(v_codsolot, v_numero);
    LN_FLG_TLF_OLD := OPERACION.PQ_SGA_JANUS.F_VAL_SERV_TLF_SOT(v_codsolot_old);
    LN_FLG_TLF_new := OPERACION.PQ_SGA_JANUS.F_VAL_SERV_TLF_SOT(v_codsolot);

    if LN_FLG_TLF_OLD = LN_FLG_TLF_new and LN_FLG_TLF_new != 0 then
      SELECT DISTINCT INS.NUMERO
        into v_numero
        FROM INSSRV INS
       WHERE INS.CODINSSRV IN
             (SELECT PTO.CODINSSRV
                FROM SOLOTPTO PTO
               WHERE PTO.CODSOLOT = v_codsolot_old)
         AND INS.TIPINSSRV = 3;
      --fin 5.0
      SGASI_ASIGNAR_NUMERO(v_codsolot, v_numero, v_mensaje, v_error);

      IF v_error < -1 THEN

        RAISE_APPLICATION_ERROR(-20001,
                                v_mensaje || CHR(13) ||
                                ' TRAZA DE ERROR:   ' ||
                                DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
      END IF;
    end if;
  EXCEPTION
    WHEN OTHERS THEN
      v_msg_error := 'ERROR AL EJECUTAR PROC: ' || $$PLSQL_UNIT || '.' ||
                   'SGASI_ASIGNA_NRO_LTE, ' || CHR(13) || ' P_CODSOLOT: ' ||
                   TO_CHAR(v_codsolot) || CHR(13) || ' PI_IDTAREAWF: ' ||
                   TO_CHAR(A_IDTAREAWF) || CHR(13) || ' PI_IDWF: ' ||
                   TO_CHAR(A_IDWF) || CHR(13) || ' PI_TAREA: ' ||
                   TO_CHAR(A_TAREA) || CHR(13) || ' PI_TAREADEF: ' ||
                   TO_CHAR(A_TAREADEF) || CHR(13) || ' CODIGO DE ERROR: ' ||
                   TO_CHAR(SQLCODE) || CHR(13) || ' MENSAJE DE ERROR: ' ||
                   TO_CHAR(SQLERRM) || ' Linea : (' ||
                   DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ')';

      operacion.pq_3play_inalambrico.p_log_3playi(v_codsolot,
                                                  'SGASS_VALIDA_PROV_3PLAY',
                                                  v_msg_error,
                                                  'Cierre de Act. de Serv. Inalámbricos - Cambio de Plan',
                                                  v_error,
                                                  v_mensaje);
      RAISE_APPLICATION_ERROR(-20000,
                              v_msg_error || CHR(13) || ' Linea Error :   ' ||
                              DBMS_UTILITY.FORMAT_ERROR_BACKTRACE); -- 3.0
  END SGASI_ASIGNA_NRO_LTE;

  FUNCTION SIACFUN_GET_PARAMETER(K_CAMPO VARCHAR2,
                                 K_TRAMA sales.siact_util_trama.TRAMV_TRAMA%TYPE)
    RETURN VARCHAR2 IS
    K_TRAMA2 sales.siact_util_trama.TRAMV_TRAMA%TYPE;
    P_TMP    sales.siact_util_trama.TRAMV_TRAMA%TYPE;
    V_VALUE  VARCHAR2(100);

  BEGIN
    IF substr(K_CAMPO, LENgth(K_CAMPO)) = ':' AND
       INSTR(K_TRAMA, K_CAMPO) > 0 THEN

      SELECT SUBSTR(K_TRAMA, INSTR(K_TRAMA, K_CAMPO) + length(K_CAMPO))
        INTO K_TRAMA2
        FROM DUAL;

      SELECT SUBSTR(K_TRAMA,
                    INSTR(K_TRAMA, K_CAMPO) + length(K_CAMPO),
                    INSTR(K_TRAMA2, '|') - 1)
        INTO V_VALUE
        FROM DUAL;

      P_TMP := SIACFUN_GET_PARAMETER(K_CAMPO, K_TRAMA2);
      IF LENGTH(P_TMP) > 0 THEN
        V_VALUE := V_VALUE || ',' || P_TMP;
      END IF;
    ELSE
      RETURN '';
    END IF;
    RETURN V_VALUE;
  END;



  PROCEDURE SGASU_ROLLBACK_CP(k_codsolot IN NUMBER,
                              k_error    IN OUT NUMBER,
                              k_mensaje  IN OUT VARCHAR2) IS

    lv_customerid OPERACION.SOLOT.CUSTOMER_ID%TYPE;
    ln_tiptra     OPERACION.TIPTRABAJO.TIPTRA%TYPE;
    lv_count      NUMBER;

  BEGIN

    k_error   := 0;
    k_mensaje := 'OK';

    BEGIN

      SELECT A.CODIGON
        INTO ln_tiptra
        FROM OPERACION.OPEDD A, OPERACION.TIPOPEDD B
       WHERE A.TIPOPEDD = B.TIPOPEDD
         AND B.ABREV IN ('TIPTRA_HFC_LTE_CP')
         AND A.ABREVIACION IN ('LTE_SIAC_CPLAN');
    EXCEPTION
      WHEN OTHERS THEN
        ln_tiptra := NULL;
    END;

    IF ln_tiptra IS NOT NULL THEN
      SELECT COUNT(*)
        INTO lv_count
        FROM OPERACION.SOLOT S
       WHERE S.CODSOLOT = k_codsolot
         AND S.TIPTRA = ln_tiptra
         AND S.ESTSOL = 17;
    ELSE
      lv_count := 0;
    END IF;

    IF lv_count > 0 THEN

      SELECT S.CUSTOMER_ID
        INTO lv_customerid
        FROM OPERACION.SOLOT S
       WHERE S.CODSOLOT = k_codsolot
         AND S.TIPTRA = ln_tiptra;

      TIM.PP004_SIAC_LTE.SIACSU_ROLLBACK@dbl_bscs_bf(lv_customerid,
                                                     'USRSGA',
                                                     k_error,
                                                     k_mensaje);

    END IF;
  END;

  /****************************************************************
  '* Nombre SP : SGASP_EST_SOLOT
  '* Propósito : Cambio de estado de SOLOT
  '* Input  : p_codsolot    - Codigo de SOLOT
              p_estsol      - Estado de SOLOT de cambio
              p_observacion - Observacion del cambio de estado de SOLOT
  '* Output : p_resp        - Valor devuelto por el SP
                            - 1 - Ok
                            - 0 - SOLOT no existe
                            - -1 - Error en BD
              p_mens        - Mensaje devuelto por el SP
                            - NULL - Ok
                            - SOLOT No existe en SGA
                            - Error de BD
  '* Creado por : Jorge Rivas
  '* Fec Creación : 14/06/2017
  '* Fec Actualización :
  '****************************************************************/
  PROCEDURE SGASP_EST_SOLOT(p_codsolot    operacion.solot.codsolot%type,
                            p_estsol      operacion.solot.estsol%type,
                            p_observacion operacion.solot.observacion%type,
                            p_resp        OUT NUMBER,
                            p_mens        OUT VARCHAR2) is
    wn_estsol operacion.solot.estsol%TYPE;
  BEGIN
    p_resp := 1;

    SELECT estsol
      INTO wn_estsol
      FROM operacion.solot
     WHERE codsolot = p_codsolot;

    operacion.pq_solot.p_chg_estado_solot(p_codsolot,
                                          p_estsol,
                                          wn_estsol,
                                          p_observacion);
    COMMIT;
  EXCEPTION
    WHEN no_data_found THEN
      p_resp := 0;
      p_mens := 'SOLOT: ' || p_codsolot ||
                ', no se encuentra registrado en SGA';
      ROLLBACK;
    WHEN OTHERS THEN
      p_resp := -1;
      p_mens := SQLERRM;
      ROLLBACK;
  END SGASP_EST_SOLOT;

  PROCEDURE SGASS_CONSULTA_EQU(av_customer_id IN VARCHAR2,
                               av_cod_id      IN VARCHAR2,
                               ac_equ_cur     OUT sales.pq_postventa_unificada.gc_salida,
                               an_resultado   OUT NUMBER,
                               av_mensaje     OUT VARCHAR2) IS
    l_equ_cur       sales.pq_postventa_unificada.gc_salida;
    l_codsolot      NUMBER;
    l_resultado     NUMBER;
    l_mensaje       VARCHAR2(900);
    ex_error EXCEPTION;

    ln_cod_id operacion.solot.cod_id%TYPE;

  BEGIN
    l_resultado := 0;
    l_mensaje   := 'Exito';

    ln_cod_id  := to_number(av_cod_id);
    l_codsolot := operacion.pq_sga_iw.f_max_sot_x_cod_id(ln_cod_id);

    IF nvl(l_codsolot, 0) = 0 THEN
      l_resultado := 1;
      l_mensaje   := 'No existe SOT.';
      RAISE ex_error;
    END IF;

    OPEN l_equ_cur FOR
      SELECT 0 idtransaccion,
             tm.codmat codigo_material,
             tm.cod_sap codigo_sap,
             pe.numserie numero_serie,
             pe.mac macaddress,
             tm.desmat descripcion_material,
             tm.abrmat abrev_material,
             tm.estado estado_material,
             tm.preprm_usd precio_almacen,
             tm.codcta codigo_cuenta,
             tm.componente,
             ms.centro centro,
             ms.idalm idalm,
             ms.almacen almacen,
             (SELECT descripcion FROM tipequ WHERE codtipequ = tm.codmat) tipo_equipo,
             NULL idproducto,
             (SELECT customer_id FROM solot WHERE codsolot = pe.codsolot) id_cliente,
             NULL modelo,
             pe.fecusu fecusu,
             pe.codusu codusu,
             CASE
               WHEN iv.tipsrv = '0004' THEN
                'mta'
               WHEN iv.tipsrv = '0006' THEN
                'cmodem'
               WHEN iv.tipsrv = '0062' THEN
                'ctv'
             END convertertype,
             NULL Servicio_Principal,
             CASE
               WHEN iv.tipsrv = '0062' THEN
                'VES_DSP'
               ELSE
                NULL
             END headend,
             NULL EPHOMEEXCHANGE,
             NULL numero
        FROM maestro_series_equ ms,
             solotptoequ        pe,
             almtabmat          tm,
             solotpto           sp,
             inssrv             iv
       WHERE ms.nroserie = pe.numserie
         AND TRIM(tm.cod_sap) = ms.cod_sap
         AND sp.codsolot = pe.codsolot
         AND sp.punto = pe.punto
         AND sp.codinssrv = iv.codinssrv
         AND pe.codsolot = l_codsolot;

    ac_equ_cur := l_equ_cur;

    l_resultado  := 0;
    l_mensaje    := 'Exito';
    an_resultado := l_resultado;
    av_mensaje   := l_mensaje;

  EXCEPTION
    WHEN ex_error THEN
      an_resultado := l_resultado;
      av_mensaje   := l_mensaje;
    WHEN OTHERS THEN
      an_resultado := -1;
      av_mensaje   := 'Error BD: Al consultar equipo ' || SQLCODE || ' ' ||
                      SQLERRM || ' Linea (' ||
                      dbms_utility.format_error_backtrace || ')';
  END;
  --fin 4.0
  --INI 5.0
/******************************************************************
'* Nombre SP : SGASU_ACT_TOPE_CONSUMO
'* Propósito : Funcionalidad de tope de consumo y OCC
'* Input : <PI_CODSOLOT>
'* Output : <PO_ERROR> - <PO_MENSAJE>
'* Creado por : Yajaira Gastaniadui
'* Fec Creación : 16/07/2018
'* Fec Actualización :
'*****************************************************************/
  PROCEDURE SGASU_ACT_TOPE_CONSUMO(PI_CODSOLOT IN NUMBER,
                                   PO_ERROR    OUT NUMBER,
                                   PO_MENSAJE  OUT VARCHAR2) IS

    LN_FLG_TLF    NUMBER;
    LN_FLG_PROV    NUMBER;
    LV_NUMERO     VARCHAR2(20);
    LN_EXI_JANUS  NUMBER;
    V_TOPE        NUMBER;
    V_FLAG_LC     NUMBER;
    V_USU_REG     VARCHAR2(15);
    V_CUSTOMER_ID VARCHAR2(15);
    V_CODOCC      NUMBER;
    V_NUM_CUOTA   NUMBER;
    V_COMENT      VARCHAR2(2000);
    V_MONTO_OCC   NUMBER;
    V_CO_SER_TOPEC NUMBER;
    V_FLAG_TOPEMENOR NUMBER;
    V_CODSOLOT   operacion.solot.codsolot%TYPE;
    V_COD_ID     NUMBER;
    V_ERROR      NUMBER;
    V_MENSAJE    VARCHAR2(4000);
    V_ERROR_GENERAL exception;

     BEGIN
        V_CODSOLOT := PI_CODSOLOT;
        V_ERROR   := 0;
        V_MENSAJE := 'Exito en el Proceso';

        LN_FLG_TLF := OPERACION.PQ_SGA_JANUS.F_VAL_SERV_TLF_SOT(V_CODSOLOT);

        IF LN_FLG_TLF = 1 THEN


           BEGIN
              SELECT DISTINCT INS.NUMERO INTO LV_NUMERO FROM SOLOTPTO PTO
               INNER JOIN INSSRV INS ON PTO.CODINSSRV = INS.CODINSSRV
               WHERE PTO.CODSOLOT = V_CODSOLOT AND INS.TIPINSSRV = 3;
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                PO_ERROR   := -1;
                PO_MENSAJE := 'NO EXISTE NUMERO TELEFONICO';
                RETURN;
            END;

           LN_EXI_JANUS := OPERACION.PQ_SGA_JANUS.F_VAL_EXIS_LINEA_JANUS(LV_NUMERO);
           LN_FLG_PROV := operacion.pq_sga_janus.f_val_prov_janus_pend(V_CODSOLOT);

           IF LN_EXI_JANUS = 1 AND LN_FLG_PROV = 0 THEN

             SELECT TOPE,    FLAG_LC,   USUREG,    CUSTOMER_ID,   CODOCC,   NUM_CUOTA,  COMENT,   MONTO,      CO_SER,         FLAG_TOPEMENOR
               INTO V_TOPE,  V_FLAG_LC, V_USU_REG, V_CUSTOMER_ID, V_CODOCC, V_NUM_CUOTA,V_COMENT, V_MONTO_OCC, V_CO_SER_TOPEC, V_FLAG_TOPEMENOR
               FROM OPERACION.SIAC_POSTVENTA_PROCESO
               WHERE CODSOLOT=v_codsolot;

             SELECT COD_ID INTO V_COD_ID FROM operacion.SOLOT WHERE CODSOLOT = V_CODSOLOT;

             V_COMENT:= REPLACE(V_COMENT,'{IdContrato}',V_COD_ID);

             TIM.PKG_CATALOGO_SERVICIOS.SP_recordTopeHFC@DBL_BSCS_BF(LV_NUMERO,--numero de fono
                                                                     TO_CHAR(V_COD_ID),-- ContratoID se saca de la solot
                                                                     V_CO_SER_TOPEC,--srtCodServicioTope
                                                                     'A',--Tipo de registro
                                                                     V_TOPE,
                                                                     V_FLAG_TOPEMENOR,
                                                                     V_FLAG_LC,
                                                                     V_USU_REG,
                                                                     V_ERROR,
                                                                     V_MENSAJE);
              if V_ERROR < 0 then
                V_MENSAJE := 'Error al registrar el tope de consumo : ' || NVL(V_MENSAJE,'');
                raise V_ERROR_GENERAL;
              end if;

              TIM.PP005_SIAC_TRX.SP_INSERT_OCC@DBL_BSCS_BF (  V_CUSTOMER_ID,
                                                              V_CODOCC,
                                                              TO_CHAR(sysdate, 'YYYYMMDD'),
                                                              V_NUM_CUOTA,
                                                              V_MONTO_OCC,
                                                              V_COMENT,
                                                              V_ERROR );
              if V_ERROR < 0 then
                V_MENSAJE := 'Error al registrar el monto OCC : ' || NVL(V_MENSAJE,'');
                raise V_ERROR_GENERAL;
              end if;

              ELSIF LN_EXI_JANUS = 0 THEN
                       V_MENSAJE := 'No existe linea en JANUS, no se agrego TC';

              ELSIF LN_FLG_PROV = 1 THEN
                       V_MENSAJE := 'Tiene provision pendiente en JANUS, no se agrego TC';

           END IF;

        ELSE
            V_MENSAJE := 'No tiene servicio de Telefonia, no se agrego TC';
        END IF;
        PO_ERROR   := V_ERROR;
        PO_MENSAJE := V_MENSAJE;
     EXCEPTION
       WHEN V_ERROR_GENERAL then
        PO_ERROR   := V_ERROR;
        PO_MENSAJE := V_MENSAJE;
       WHEN OTHERS THEN
        PO_ERROR   := -1;
        PO_MENSAJE := 'ERROR AL EJECUTAR PROC: ' || $$PLSQL_UNIT || '.' ||
                     'SGASU_ACT_TOPE_CONSUMO, ' || CHR(13) || 'P_CODSOLOT: ' ||
                     TO_CHAR(V_CODSOLOT) || CHR(13) || 'CODIGO DE ERROR: ' ||
                     TO_CHAR(SQLCODE) || CHR(13) || 'MENSAJE DE ERROR: ' ||
                     TO_CHAR(SQLERRM) || ' Linea : (' ||
                     DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ')';
       END;



--FIN 5.0
  /****************************************************************
  '* Nombre SP : SGASS_DET_EQUIPO_LTE
  '* Propósito : Retorna un cursoR con los equipos actuales del cliente Y CAMPOS ADICIONALES
  '* Input  : K_COD_ID - Codigo de SOT
  '* Output : K_CURSOR - Cursor de retorno
              K_ERROR   - Codigo de error
                        -1 : error
                        0  : OK
              K_MENSAJE - Descripcion del error
  '* Creado por : -
  '* Fec Creación : 10/07/2018
  '* Fec Actualización :
  '****************************************************************/
 PROCEDURE SGASS_DET_EQUIPO_LTE(K_COD_ID  operacion.solot.cod_id%TYPE,
                                K_CURSOR  OUT SYS_REFCURSOR,
                                K_ERROR   OUT NUMBER,
                                K_MENSAJE OUT VARCHAR2) IS

   v_impuesto NUMBER;

 BEGIN
   K_ERROR   := 1;
   K_MENSAJE := 'Ok';

   SELECT T.PORCENTAJE
     INTO v_impuesto
     FROM BILLCOLPER.IMPUESTO T
    WHERE T.ESDEFAULT = 1;

   OPEN k_cursor FOR
     SELECT X.dscequ,
            CASE
              WHEN X.tipsrv = '0004' THEN
               'TELEFONO'
              WHEN X.tipsrv = '0006' THEN
               'INTERNET'
              WHEN X.tipsrv = '0062' THEN
               'CABLE'
            END tipsrv,
            X.codsrv,
            X.TIPO TIPO_SRV,
            SUM((SELECT TIM.TFUN115_CARGOFIJO_X_SERV@DBL_BSCS_BF(k_cod_id,
                                                                 sis.servv_id_bscs) *
                        ((v_impuesto + 100) / 100)
                   FROM sales.servicio_sisact               ses,
                        usrpvu.sisact_ap_servicio@dbl_pvudb sis
                  WHERE sis.servv_codigo = ses.idservicio_sisact
                    AND ses.codsrv = X.codsrv) * X.cantidad) cargo_fijo,
            SUM(X.cantidad) cantidad,
            DECODE(X.tipsrv,
                   '0062',
                   DECODE(TE.TIPO_ABREV, NULL, TE.TIPO, TE.TIPO_ABREV),
                   TE.TIPO) TIPO
       FROM (SELECT DISTINCT (SELECT ve.dscequ
                                FROM vtaequcom ve
                               WHERE ve.codequcom = ip.codequcom) dscequ,
                             IV.TIPSRV,
                             (SELECT DECODE(SER.TIPSRV,
                                            '0050',
                                            'INCLUIDO',
                                            '0015',
                                            'ADICIONAL',
                                            'SERVICIO')
                                FROM VTADETPTOENL D,
                                     PRODUCTO     P,
                                     TYSTABSRV    SER
                               WHERE D.IDPRODUCTO = P.IDPRODUCTO
                                 AND D.CODSRV = SER.CODSRV
                                 AND D.NUMSLC = IP.NUMSLC
                                 AND D.CODSRV = IP.CODSRV
                                 AND D.NUMPTO = IP.NUMPTO) TIPO,
                             iv.codsrv,
                             ip.pid,
                             IP.codequcom,
                             ip.cantidad
               FROM solot s, solotpto sp, insprd ip, inssrv iv
              WHERE s.codsolot = sp.codsolot
                AND sp.codinssrv = iv.codinssrv
                AND ip.codinssrv = iv.codinssrv
                AND s.Codsolot =
                    operacion.pq_sga_iw.f_max_sot_x_cod_id(k_cod_id)
                AND ip.estinsprd IN (1, 2)
                AND iv.tipsrv IN ('0004', '0006', '0062')
                and nvl(ip.codequcom, 'X') != 'X') X,
            vtaequcom eq,
            EQUCOMXOPE v,
            TIPEQU TE
      WHERE X.CODEQUCOM = eq.CODEQUCOM
        AND eq.CODEQUCOM = v.CODEQUCOM
        AND v.CODTIPEQU = TE.CODTIPEQU
      GROUP BY X.dscequ, X.tipsrv, X.codsrv, x.tipo, te.tipo, TE.TIPO_ABREV;

 END;
  -- FUNCION PARA OBTENER EL TIPO DE SERVICIO CORE O ADICIONAL
  FUNCTION SGAFUN_TIPSRV (PI_CODSRV OPERACION.inssrv.CODSRV%TYPE)
    RETURN VARCHAR2 IS
  tipo_srv VARCHAR2(10);
  BEGIN
    SELECT (SELECT DECODE(UPPER(s.snind), 'Y', 'CORE', 'N', 'ADICIONAL')
              FROM sysadm.mpusntab@dbl_bscs_bf s
             WHERE s.sncode = sis.servv_id_bscs) into tipo_srv
      FROM usrpvu.sisact_ap_servicio@dbl_pvudb sis,
           sales.servicio_sisact               ses
     WHERE sis.servv_codigo = ses.idservicio_sisact
       AND ses.codsrv = PI_CODSRV;

  RETURN tipo_srv;
  EXCEPTION
    WHEN OTHERS THEN
      tipo_srv := '';
      RETURN tipo_srv;
  END ;

  /******************************************************************
  '* Nombre SP : SGASI_PROV_JANUS
  '* Propósito : Funcionalidad para la IL VOZ
  '* Input : <PI_IDTAREAWF>- <PI_IDWF>- <PI_TAREA>- <PI_TAREADEF>
  '* Output : <PO_ERROR> - <PO_MENSAJE>
  '* Creado por :
  '* Fec Creación : 30/07/2018
  '* Fec Actualización :
  '*****************************************************************/
   PROCEDURE SGASI_PROV_JANUS(PI_IDTAREAWF IN NUMBER,
                              PI_IDWF      IN NUMBER,
                              PI_TAREA     IN NUMBER,
                              PI_TAREADEF  IN NUMBER) IS

     V_CODSOLOT NUMBER;
     V_ERROR    NUMBER;
     V_MENSAJE  VARCHAR2(4000);
   BEGIN

     V_ERROR   := 0;
     V_MENSAJE := 'Exito en el Proceso';

     SELECT CODSOLOT
       INTO V_CODSOLOT
       FROM WF
      WHERE VALIDO = 1
        AND IDWF = PI_IDWF;

     OPERACION.PQ_SIAC_CAMBIO_PLAN_LTE.SGASS_REGISTRO_ESTADO_LTE(V_CODSOLOT, 'JN', V_ERROR, V_MENSAJE);

     OPERACION.PQ_SIAC_CAMBIO_PLAN_LTE.SGASI_CAMBIO_PLAN_JANUS(V_CODSOLOT,
                                                               V_ERROR,
                                                               V_MENSAJE);
     if V_ERROR < 0 AND V_ERROR != -5 then --15.0
       V_MENSAJE := 'Error al registrar IL-VOZ : ' || NVL(V_MENSAJE, '');

       OPERACION.PQ_3PLAY_INALAMBRICO.P_LOG_3PLAYI(V_CODSOLOT,
                                                   'SGASI_PROV_JANUS',
                                                   V_MENSAJE,
                                                   'SGASI_PROV_JANUS',
                                                   V_ERROR,
                                                   V_MENSAJE);

       OPERACION.PQ_SIAC_CAMBIO_PLAN_LTE.SGASS_ACTUALIZA_ESTADO_LTE(V_CODSOLOT,
                                                                    'JN',
                                                                     V_MENSAJE,
                                                                     'ERRO',
                                                                     V_ERROR,
                                                                     V_MENSAJE);
    else
      --ini 15.0
      IF V_ERROR = -5 THEN
        V_MENSAJE := 'Provision OK : Se tiene el mismo Plan Tarifario para ambos Contratos';
        OPERACION.PQ_SIAC_CAMBIO_PLAN_LTE.SGASS_ACTUALIZA_ESTADO_LTE(V_CODSOLOT,
                                                                    'JN',
                                                                     V_MENSAJE,
                                                                     'PROV',
                                                                     V_ERROR,
                                                                     V_MENSAJE);
      ELSE
        --fin 15.0
         V_MENSAJE := 'Provision JANUS : '|| V_MENSAJE;
         OPERACION.PQ_SIAC_CAMBIO_PLAN_LTE.SGASS_ACTUALIZA_ESTADO_LTE(V_CODSOLOT,
                                                                    'JN',
                                                                     V_MENSAJE,
                                                                     'EPLA',
                                                                     V_ERROR,
                                                                     V_MENSAJE);
      END IF;
    end if;

   EXCEPTION
     WHEN OTHERS THEN
       V_ERROR   := -1;
       V_MENSAJE := 'ERROR AL EJECUTAR PROC: ' || $$PLSQL_UNIT || '.' ||
                    'SGASU_PROV_IL_VOZ, ' || CHR(13) || 'PI_IDTAREAWF: ' ||
                    TO_CHAR(PI_IDTAREAWF) || CHR(13) || 'PI_IDWF: ' ||
                    TO_CHAR(PI_IDWF) || CHR(13) || 'PI_TAREA: ' ||
                    TO_CHAR(PI_TAREA) || CHR(13) || 'PI_TAREADEF: ' ||
                    TO_CHAR(PI_TAREADEF) || CHR(13) || 'CODIGO DE ERROR: ' ||
                    TO_CHAR(SQLCODE) || CHR(13) || 'MENSAJE DE ERROR: ' ||
                    TO_CHAR(SQLERRM) || ' Linea : (' ||
                    DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ')';

       OPERACION.PQ_3PLAY_INALAMBRICO.P_LOG_3PLAYI(V_CODSOLOT,
                                                   'SGASI_PROV_JANUS',
                                                   V_MENSAJE,
                                                   'SGASI_PROV_JANUS',
                                                   V_ERROR,
                                                   V_MENSAJE);

   END SGASI_PROV_JANUS;


   /******************************************************************
'* Nombre SP : SGASI_PROV_CONTEGO_SV
'* Propósito : Funcionalidad para obtener e insertar en la tabla trx_contego los canales para la reconexion y  suspension
'* Input : <PI_CODSOLOT> -<PI_NUMSERIE>
'* Output : <PO_ERROR> - <PO_MENSAJE>
'* Creado por :
'* Fec Creación : 31/07/2018
'* Fec Actualización :
'*****************************************************************/
  PROCEDURE SGASI_PROV_CONTEGO_SV(PI_CODSOLOT IN operacion.solot.codsolot%type,
                                  PI_NUMSERIE IN operacion.solotptoequ.numserie%type,
                                  PO_ERROR    OUT NUMBER,
                                  PO_MENSAJE  OUT VARCHAR2) IS

    V_CODSOLOT         NUMBER;
    V_COD_ID_OLD       NUMBER;
    V_IDSOL            NUMBER;
    V_CODSOLOT_ANTIGUA NUMBER;
    V_NUMSLC           CHAR(10);
    V_IDLOTE           NUMBER(10);
    V_ERROR            NUMBER;
    V_MENSAJE          VARCHAR2(4000);
    V_NUMSERIE         VARCHAR2(2000);
    V_MENSAJE_GENERAL  VARCHAR2(4000);
    V_RESPUESTA        VARCHAR2(30);
    V_ERROR_GENERAL EXCEPTION;
    CURSOR CUR_CANALES_SOT_RECONEXION(VA_NUMSLC IN VARCHAR2) IS
      SELECT --DECODE(V.FLGSRV_PRI, 1, 'PRINCIPAL', 'ADICIONAL') CLASE,
       DECODE(V.FLGSRV_PRI, 1, 1, 0) CLASE,
       R.IDGRUPO,
       TO_CHAR(TO_NUMBER(OPD.CODBOUQUET)) AS COD_BOUQUET
        FROM VTADETPTOENL           V,
             TYSTABSRV              T,
             TYS_TABSRVXBOUQUET_REL R,
             OPE_GRUPO_BOUQUET_CAB  OPE,
             OPE_GRUPO_BOUQUET_DET  OPD
       WHERE V.NUMSLC = VA_NUMSLC
         AND V.CODSRV = T.CODSRV
         AND T.CODSRV = R.CODSRV
         AND R.ESTBOU = 1
         AND R.STSRVB = 1
         AND OPE.IDGRUPO = OPD.IDGRUPO
         AND OPE.IDGRUPO = R.IDGRUPO
      UNION ALL
      SELECT DISTINCT 0 CLASE, GB.IDGRUPO, B.DESCRIPCION
        FROM FAC_PROM_DETALLE_VENTA_MAE PV,
             OPE_GRUPO_BOUQUET_DET      GB,
             OPE_BOUQUET_MAE            B
       WHERE PV.NUMSLC = VA_NUMSLC
         AND PV.IDGRUPO = GB.IDGRUPO
         AND GB.CODBOUQUET = B.CODBOUQUET
         AND GB.FLG_ACTIVO = 1
         AND B.FLG_ACTIVO = 1
         AND B.DESCRIPCION IS NOT NULL;

    CURSOR CUR_CANALES_SOT_SUSPENSION(VA_CODSOLOT1 IN NUMBER,
                                      VA_CODSOLOT2 IN NUMBER) is
      SELECT *
        FROM (SELECT DECODE(V.FLGSRV_PRI, 1, 1, 0) CLASE, --1:principal,0:adicional
                     R.IDGRUPO,
                     TO_CHAR(TO_NUMBER(OPD.CODBOUQUET)) AS COD_BOUQUET
                FROM VTADETPTOENL           V,
                     TYSTABSRV              T,
                     TYS_TABSRVXBOUQUET_REL R,
                     SOLOT                  S,
                     OPE_GRUPO_BOUQUET_CAB  OPE,
                     OPE_GRUPO_BOUQUET_DET  OPD
               WHERE V.NUMSLC = S.NUMSLC
                 AND S.CODSOLOT = VA_CODSOLOT1
                 AND V.CODSRV = T.CODSRV
                 AND T.CODSRV = R.CODSRV
                 AND R.ESTBOU = 1
                 AND R.STSRVB = 1
                 AND OPE.IDGRUPO = OPD.IDGRUPO
                 AND OPE.IDGRUPO = R.IDGRUPO
              MINUS
              SELECT DECODE(V.FLGSRV_PRI, 1, 1, 0) CLASE,
                     R.IDGRUPO,
                     TO_CHAR(TO_NUMBER(OPD.CODBOUQUET)) AS COD_BOUQUET
                FROM VTADETPTOENL           V,
                     TYSTABSRV              T,
                     TYS_TABSRVXBOUQUET_REL R,
                     SOLOT                  S,
                     OPE_GRUPO_BOUQUET_CAB  OPE,
                     OPE_GRUPO_BOUQUET_DET  OPD
               WHERE V.NUMSLC = S.NUMSLC
                 AND S.CODSOLOT = VA_CODSOLOT2
                 AND V.CODSRV = T.CODSRV
                 AND T.CODSRV = R.CODSRV
                 AND R.ESTBOU = 1
                 AND R.STSRVB = 1
                 AND OPE.IDGRUPO = OPD.IDGRUPO
                 AND OPE.IDGRUPO = R.IDGRUPO)
       ORDER BY IDGRUPO;

  BEGIN

    V_ERROR           := 0;
    V_RESPUESTA       := 'OK';
    V_MENSAJE         := '';
    V_MENSAJE_GENERAL := 'Exito en el Proceso.';
    V_CODSOLOT        := PI_CODSOLOT;
    V_NUMSERIE        := PI_NUMSERIE;
    BEGIN
      SELECT COD_ID_OLD, NUMSLC, OPERACION.PQ_SGA_IW.F_MAX_SOT_X_COD_ID(COD_ID_OLD) --14.0
        INTO V_COD_ID_OLD, V_NUMSLC, V_CODSOLOT_ANTIGUA --14.0
        FROM SOLOT
       WHERE CODSOLOT = V_CODSOLOT;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        V_ERROR      := -2;
        V_MENSAJE    := 'NO SE REGISTRO SOT PARA EL CODIGO DE SOT: ' ||
                        TO_CHAR(V_CODSOLOT);
        RAISE V_ERROR_GENERAL;
    END;

    --**********************INICIO RECONEXION******************
    --CABECERA
    SELECT OPERACION.OPE_TVSAT_LOTE_SLTD_AUX_IDLOTE.NEXTVAL
      INTO V_IDLOTE
      FROM DUMMY_OPE;
    SELECT SQ_OPE_TVSAT_SLTD_CAB_IDSOL.NEXTVAL INTO V_IDSOL FROM DUMMY_OPE;

    INSERT INTO OPERACION.OPE_TVSAT_SLTD_CAB
      (CODSOLOT, TIPOSOLICITUD, ESTADO, FLG_RECARGA, IDSOL, IDLOTE)
    VALUES
      (V_CODSOLOT, 2, 1, 1, V_IDSOL, V_IDLOTE);

    --DETALLE
    FOR C_EQUIP_SOT IN (SELECT DISTINCT SE.NUMSERIE
                          FROM OPERACION.TIPOPEDD TP
                         INNER JOIN OPERACION.OPEDD O
                            ON O.TIPOPEDD = TP.TIPOPEDD
                         INNER JOIN SOLOTPTOEQU SE
                            ON SE.TIPEQU = O.CODIGON
                         WHERE TP.ABREV = 'TIPEQU_DTH_CONAX'
                           AND O.DESCRIPCION = 'Tarjeta'
                           AND SE.CODSOLOT = V_CODSOLOT
                           AND (NVL(V_NUMSERIE, '0') = '0' OR
                               SE.NUMSERIE = NVL(V_NUMSERIE, '0'))) LOOP
      INSERT INTO OPERACION.OPE_TVSAT_SLTD_DET
        (IDSOL, SERIE)
      VALUES
        (V_IDSOL, C_EQUIP_SOT.NUMSERIE);

      --BOUQUET DETALLE
      FOR C_CANAL IN CUR_CANALES_SOT_RECONEXION(V_NUMSLC) LOOP
        INSERT INTO OPERACION.OPE_TVSAT_SLTD_BOUQUETE_DET
          (IDSOL, SERIE, BOUQUETE, TIPO)
        VALUES
          (V_IDSOL,
           C_EQUIP_SOT.NUMSERIE,
           LPAD(TO_CHAR(C_CANAL.COD_BOUQUET), 8, 0),
           TO_NUMBER(C_CANAL.CLASE));
      END LOOP;

    END LOOP;
    V_MENSAJE_GENERAL := V_MENSAJE_GENERAL || CHR(13) ||
                         'Se genero la reconexion con Lote: ' ||
                         TO_CHAR(V_IDLOTE) || '.';
    OPERACION.PKG_CONTEGO.SGASS_RECONEXION_LTE(V_IDLOTE,
                                               V_RESPUESTA,
                                               V_MENSAJE);

    IF V_RESPUESTA != 'OK' THEN
      V_MENSAJE_GENERAL := 'Error al registrar la reconexion con Lote: ' ||
                           TO_CHAR(V_IDLOTE) || '.' || NVL(V_MENSAJE, '');
      V_ERROR           := -3;
      RAISE V_ERROR_GENERAL;
    ELSE
      V_MENSAJE_GENERAL := V_MENSAJE_GENERAL || CHR(13) ||
                           'Se genero la reconexion con Lote: ' ||
                           TO_CHAR(V_IDLOTE) || '.';
    END IF;
    --**********************FIN RECONEXION******************

    --**********************INICIO SUSPENSION***************
    --CABECERA
    SELECT OPERACION.OPE_TVSAT_LOTE_SLTD_AUX_IDLOTE.NEXTVAL
      INTO V_IDLOTE
      FROM DUMMY_OPE;
    SELECT SQ_OPE_TVSAT_SLTD_CAB_IDSOL.NEXTVAL INTO V_IDSOL FROM DUMMY_OPE;
    INSERT INTO OPERACION.OPE_TVSAT_SLTD_CAB --TIPO SOLICITUD
      (CODSOLOT, TIPOSOLICITUD, ESTADO, FLG_RECARGA, IDSOL, IDLOTE)
    VALUES
      (V_CODSOLOT, 1, 1, 1, V_IDSOL, V_IDLOTE);

    --DETALLE
    FOR C_EQUIP_SOT IN (SELECT DISTINCT SE.NUMSERIE
                          FROM OPERACION.TIPOPEDD TP
                         INNER JOIN OPERACION.OPEDD O
                            ON O.TIPOPEDD = TP.TIPOPEDD
                         INNER JOIN SOLOTPTOEQU SE
                            ON SE.TIPEQU = O.CODIGON
                         WHERE TP.ABREV = 'TIPEQU_DTH_CONAX'
                           AND O.DESCRIPCION = 'Tarjeta'
                           AND SE.CODSOLOT = V_CODSOLOT) LOOP
      INSERT INTO OPERACION.OPE_TVSAT_SLTD_DET
        (IDSOL, SERIE)
      VALUES
        (V_IDSOL, C_EQUIP_SOT.NUMSERIE);
      --BOUQUET DETALLE
      FOR C_CANAL IN CUR_CANALES_SOT_SUSPENSION(V_CODSOLOT_ANTIGUA,
                                                V_CODSOLOT) LOOP
        INSERT INTO OPERACION.OPE_TVSAT_SLTD_BOUQUETE_DET
          (IDSOL, SERIE, BOUQUETE, TIPO)
        VALUES
          (V_IDSOL,
           C_EQUIP_SOT.NUMSERIE,
           LPAD(TO_CHAR(C_CANAL.COD_BOUQUET), 8, 0),
           TO_NUMBER(C_CANAL.CLASE));
      END LOOP;

    END LOOP;
    V_MENSAJE_GENERAL := V_MENSAJE_GENERAL || CHR(13) ||
                         'Se genero la suspension con Lote: ' ||
                         TO_CHAR(V_IDLOTE) || '.';
    OPERACION.PKG_CONTEGO.SGASS_SUSPENSION_LTE(V_IDLOTE,
                                               V_RESPUESTA,
                                               V_MENSAJE);

    IF V_RESPUESTA != 'OK' THEN
      V_MENSAJE_GENERAL := 'Error al registrar la suspension con Lote: ' ||
                           TO_CHAR(V_IDLOTE) || '.' || NVL(V_MENSAJE, '');
      V_ERROR           := -4;
      RAISE V_ERROR_GENERAL;
    ELSE
      V_MENSAJE_GENERAL := V_MENSAJE_GENERAL || CHR(13) ||
                           'Se genero la suspension con Lote: ' ||
                           TO_CHAR(V_IDLOTE) || '.';
    END IF;
    --**********************FIN SUSPENSION******************

    PO_MENSAJE := V_MENSAJE_GENERAL;
    PO_ERROR   := V_ERROR;
  EXCEPTION
    WHEN V_ERROR_GENERAL THEN
      PO_ERROR   := V_ERROR;
      PO_MENSAJE := V_MENSAJE;

    WHEN OTHERS THEN

      PO_ERROR   := -1;
      PO_MENSAJE := 'ERROR AL EJECUTAR PROC: ' || $$PLSQL_UNIT || '.' ||
                    'SGASI_PROV_CONTEGO_SV, ' || CHR(13) || 'PI_CODSOLOT: ' ||
                    TO_CHAR(PI_CODSOLOT) || CHR(13) || 'CODIGO DE ERROR: ' ||
                    TO_CHAR(SQLCODE) || CHR(13) || 'MENSAJE DE ERROR: ' ||
                    TO_CHAR(SQLERRM) || ' Linea : (' ||
                    DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ')';

  END;

  /******************************************************************
  '* Nombre SP : SGASI_PROV_INTERNET
  '* Propósito : Funcionalidad para insertar en la tabla LTE_CONTROL_PROV, el cual actua como tb intermedia para la modificacion del servicio de internet
  '* Input : <PI_CODSOLOT>
  '* Output : <PO_ERROR> - <PO_MENSAJE>
  '* Creado por :
  '* Fec Creación : 06/08/2018
  '* Fec Actualización :
  '*****************************************************************/
  PROCEDURE SGASI_PROV_INTERNET(PI_CODSOLOT IN NUMBER,
                                PO_ERROR    OUT NUMBER,
                                PO_MENSAJE  OUT VARCHAR2) IS

    V_CODSOLOT      operacion.solot.codsolot%TYPE;
    V_COD_ID        NUMBER;
    V_CUSTOMER_ID   NUMBER;
    V_SNCODE        NUMBER;
    V_ERROR         NUMBER;
    V_ACTION_ID     NUMBER := 4;
    V_TIPO_PRODUCTO VARCHAR2(100);
    V_MENSAJE       VARCHAR2(4000);
    V_ERROR_GENERAL EXCEPTION;
    
    V_TIPO_PROD_TV   VARCHAR2(20) := 'TV';
    V_TIPO_PROD_INT_TELF VARCHAR2(20) := 'TEL+INT';
    V_TIPO_PROD_INT  VARCHAR2(20) := 'INTERNET';
    V_TIPO_PROD_TELF VARCHAR2(20) := 'TELEFONIA';
    V_FLAG_INT       INTEGER;
    V_FLAG_CTV       INTEGER;
    V_FLAG_TEL       INTEGER;
         
  BEGIN
    V_CODSOLOT := PI_CODSOLOT;
    V_ERROR    := 0;
    V_MENSAJE  := 'Exito en el Proceso';

    BEGIN
      SELECT VALOR
        INTO V_TIPO_PRODUCTO
        FROM CONSTANTE
       WHERE CONSTANTE = 'INTLTEPROV';
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        V_TIPO_PRODUCTO := '';
        V_ERROR         := -2;
        V_MENSAJE       := 'NO EXISTE TIPO DE PRODUCTO EN CONSTANTES DE INTLTEPROV';
        RAISE V_ERROR_GENERAL;
    END; 
    
    BEGIN
      SELECT COD_ID, CUSTOMER_ID
        INTO V_COD_ID, V_CUSTOMER_ID
        FROM SOLOT
       WHERE CODSOLOT = V_CODSOLOT;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        V_COD_ID  := '';
        V_ERROR   := -3;
        V_MENSAJE := 'NO SE REGISTRO SOT PARA EL SIGUIENTE CODIGO: ' ||
                     TO_CHAR(V_CODSOLOT);
        RAISE V_ERROR_GENERAL;
    END;
    
    SELECT COUNT(1)
      INTO V_FLAG_INT
      FROM TIM.LTE_INFO_COM_DET@DBL_BSCS_BF PI
     WHERE PI.CO_ID = V_COD_ID
       AND PI.PRODUCTO = 'INTERNET';
   
   SELECT COUNT(1)
      INTO V_FLAG_TEL
      FROM TIM.LTE_INFO_COM_DET@DBL_BSCS_BF PI
     WHERE PI.CO_ID = V_COD_ID
       AND PI.PRODUCTO = 'TELEFONIA'; 
   
   SELECT COUNT(1)
      INTO V_FLAG_CTV
      FROM TIM.LTE_INFO_COM_DET@DBL_BSCS_BF PI
     WHERE PI.CO_ID = V_COD_ID
       AND PI.PRODUCTO = 'TV';
    
    IF V_FLAG_TEL > 0 AND V_FLAG_INT > 0 THEN
      V_TIPO_PRODUCTO := V_TIPO_PROD_INT_TELF;
    ELSIF V_FLAG_TEL = 0 AND V_FLAG_INT > 0 THEN
      V_TIPO_PRODUCTO := V_TIPO_PROD_INT;
    ELSIF V_FLAG_TEL > 0 AND V_FLAG_INT = 0 THEN
      V_TIPO_PRODUCTO := V_TIPO_PROD_TELF;
    END IF;
    
    BEGIN
      SELECT DISTINCT ps.sncode --14.0
        INTO V_SNCODE
        FROM sysadm.profile_service@DBL_BSCS_BF ps
       INNER JOIN sysadm.pr_serv_status_hist@DBL_BSCS_BF sh
          ON sh.co_id = ps.co_id
         AND sh.histno = ps.status_histno
         AND sh.profile_id = ps.profile_id
         AND sh.status in ('O','A') --8.0
       INNER JOIN sysadm.mpusntab@DBL_BSCS_BF m
          ON m.sncode = ps.sncode
       WHERE ps.co_id = V_COD_ID
         AND EXISTS (SELECT 1
                FROM tim.lte_gmd_serv@DBL_BSCS_BF gs
               WHERE gs.sncode = ps.sncode
                 AND UPPER(gs.code) LIKE '%IN%');
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        V_SNCODE  := 0;
        V_ERROR   := -4;
        V_MENSAJE := 'NO EXISTE SERVICIO DE INTERNET ACTIVO PARA EL CONTRATO: ' || --8.0
                     TO_CHAR(V_COD_ID);
        RAISE V_ERROR_GENERAL;

    END;

    TIM.PP004_SIAC_LTE.SIACSI_PROVISION_IL@DBL_BSCS_BF(V_COD_ID,
                                                       V_CUSTOMER_ID,
                                                       'USRSGA',
                                                       V_TIPO_PRODUCTO,
                                                       V_ACTION_ID,
                                                       V_SNCODE,
                                                       V_ERROR,
                                                       V_MENSAJE);

    IF V_ERROR < 0 THEN
      V_MENSAJE := 'ERROR AL REGISTRAR LA PROVISION DE INTERNET: ' ||
                   NVL(V_MENSAJE, '');
      RAISE V_ERROR_GENERAL;
    ELSE
      V_MENSAJE := 'EXITO EN EL PROCESO CON COD DE REQUEST:' ||
                   NVL(V_MENSAJE, '');
    END IF;

    PO_ERROR   := V_ERROR;
    PO_MENSAJE := V_MENSAJE;

  EXCEPTION

    WHEN V_ERROR_GENERAL THEN
      PO_ERROR   := V_ERROR;
      PO_MENSAJE := V_MENSAJE;

    WHEN OTHERS THEN
      PO_ERROR   := -1;
      PO_MENSAJE := 'ERROR AL EJECUTAR PROC: ' || $$PLSQL_UNIT || '.' ||
                    'SGASI_PROV_INTERNET, ' || CHR(13) || 'PI_CODSOLOT: ' ||
                    TO_CHAR(V_CODSOLOT) || CHR(13) || 'CODIGO DE ERROR: ' ||
                    TO_CHAR(SQLCODE) || CHR(13) || 'MENSAJE DE ERROR: ' ||
                    TO_CHAR(SQLERRM) || ' Linea : (' ||
                    DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ')';
  END;

  /******************************************************************
  '* Nombre SP : SGASI_REG_IMSI_MSISDN
  '* Propósito : Funcionalidad para asociar el IMSI para
  '* Input : <PI_CODSOLOT>
  '* Output : <PO_ERROR> - <PO_MENSAJE>
  '* Creado por :
  '* Fec Creación : 22/08/2018
  '* Fec Actualización :
  '*****************************************************************/
  PROCEDURE SGASI_REG_IMSI_MSISDN(PI_CODSOLOT   IN SOLOT.CODSOLOT%TYPE,
                                  PI_COD_ID     IN SOLOT.COD_ID%TYPE,
                                  PI_COD_ID_OLD IN SOLOT.COD_ID_OLD%TYPE,
                                  PO_ERROR      OUT NUMBER,
                                  PO_MENSAJE    OUT VARCHAR2) IS
    ln_cant_dig_chip number;
    ln_cod_rep       number;
    LS_MSJ_RESP      VARCHAR2(4000);
    EXCEP_PROCESO EXCEPTION; --8.0
    LN_CONTINUA  NUMBER; --11.0
    LN_VAL_ICCID NUMBER; --11.0
    LV_VALOR     VARCHAR2(2000); --15.0
    ln_cod_er       NUMBER; --15.0
    lv_resul_er     VARCHAR2(4000); --15.0

    cursor c_alta is
      select distinct rpad(se.numserie, ln_cant_dig_chip) as iccid, --8.0
                      se.mac as msisdn,
                      decode(se.estado, 15, 'CP', 4, 'AN', 'OTRO') accion_bscs
        from solotptoequ se,
             solot s,
             solotpto sp,
             inssrv i,
             tipequ t,
             almtabmat a,
             (select a.codigon tipequ, codigoc grupo
                from opedd a, tipopedd b
               where a.tipopedd = b.tipopedd
                 and b.abrev = 'TIPEQU_LTE_TLF') equ_conax
       where se.codsolot = s.codsolot
         and s.codsolot = sp.codsolot
         and se.punto = sp.punto
         and sp.codinssrv = i.codinssrv
         and t.tipequ = se.tipequ
         and a.codmat = t.codtipequ
         and se.codsolot = pi_codsolot
         and t.tipequ = equ_conax.tipequ
         and equ_conax.grupo = '3';

  BEGIN

    PO_ERROR         := 0;
    PO_MENSAJE       := 'OK';
    LN_CONTINUA      := 0;
    ln_cant_dig_chip := OPERACION.PQ_SGA_JANUS.F_GET_CONSTANTE_CONF('CANDIGCHIPLTE');

    if ln_cant_dig_chip = -10 then
      ln_cant_dig_chip := 19; -- Solo por contingencia
    end if;

    for c in c_alta loop
      IF c.msisdn IS NOT NULL AND c.iccid IS NOT NULL THEN
        LV_VALOR := 'Parametros (MSISDN : '|| c.msisdn || ' - ICCID : ' ||c.iccid||')';
        operacion.pq_3play_inalambrico.p_log_3playi(PI_CODSOLOT,
                                                    'SGASI_REG_IMSI_MSISDN',
                                                    LV_VALOR,
                                                    'Registro de Información en BSCS',
                                                    ln_cod_er,
                                                    lv_resul_er);
        SELECT COUNT(S.SM_ID)
          INTO LN_VAL_ICCID
          FROM STORAGE_MEDIUM@DBL_BSCS_BF S,
               PORT@DBL_BSCS_BF           P,
               CONTR_DEVICES@DBL_BSCS_BF  CD
         WHERE S.SM_ID = P.SM_ID
           AND P.PORT_ID = CD.PORT_ID
           and S.SM_SERIALNUM = c.iccid
           AND CD.CO_ID = PI_COD_ID;

        IF LN_VAL_ICCID > 0 THEN
          LN_CONTINUA := 1; -- Ya tiene asignado el recurso
        END IF;
        --fin 11.0

        IF LN_CONTINUA = 0 THEN
          TIM.PP004_SIAC_LTE.BSCSI_REG_IMSI_MSISDN_CP@DBL_BSCS_BF(PI_COD_ID,
                                                                  PI_COD_ID_OLD,
                                                                  c.msisdn,
                                                                  c.iccid,
                                                                  c.accion_bscs,
                                                                  PO_ERROR,
                                                                  PO_MENSAJE);

          LV_VALOR := 'Respuesta del Proceso (Codigo : '||to_char(PO_ERROR) || ' - Mensaje : '||PO_MENSAJE||')';
          operacion.pq_3play_inalambrico.p_log_3playi(PI_CODSOLOT,
                                                    'SGASI_REG_IMSI_MSISDN',
                                                    LV_VALOR,
                                                    'Registro de Información en BSCS',
                                                    ln_cod_er,
                                                    lv_resul_er);

          --8.0 Ini
          IF PO_ERROR <> 0 THEN
            RAISE EXCEP_PROCESO;
          ELSE
            COMMIT;
          END IF;
          --8.0 Fin
        END IF;
      end if;
    end loop;

  EXCEPTION
    --8.0 Ini
    WHEN EXCEP_PROCESO THEN
      PO_ERROR   := -5;
      PO_MENSAJE := 'Error en la Asociacion de IMSI en BSCS - ' ||
                    PO_MENSAJE;
      OPERACION.PQ_3PLAY_INALAMBRICO.P_LOG_3PLAYI(PI_CODSOLOT,
                                                  'SGASI_REG_IMSI_MSISDN',
                                                  PO_MENSAJE,
                                                  'Registro de Información en BSCS',
                                                  ln_cod_rep,
                                                  LS_MSJ_RESP);
      --8.0 Fin
    WHEN OTHERS THEN
      PO_ERROR   := -5;
      PO_MENSAJE := 'Error en la Asociacion de IMSI en BSCS - ' || --8.0
                    SQLERRM || ' Linea (' ||
                    DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ')';
      OPERACION.PQ_3PLAY_INALAMBRICO.P_LOG_3PLAYI(PI_CODSOLOT,
                                                  'SGASI_REG_IMSI_MSISDN',
                                                  PO_MENSAJE,
                                                  'Registro de Información en BSCS', --8.0
                                                  ln_cod_rep,
                                                  LS_MSJ_RESP);
  END;
  /******************************************************************
  '* Nombre SP : SGASI_INSERTA_EQUIPO_FIJA
  '* Propósito : Funcionalidad para actualizar equipos de servicios Fija
  '* Input : Lista de Equipos de Fija
  '* Output : <PO_ERROR> - <PO_MENSAJE>
  '* Creado por :
  '* Fec Creación : 12/03/2019
  '* Fec Actualización :
  '*****************************************************************/
  PROCEDURE SGASI_INSERTA_EQUIPO_FIJA(AR_EQUIPO IN OPERACION.SGAT_EQUIPO_SERVICIO_FIJA%ROWTYPE,
                                      AN_ERROR  OUT NUMBER,
                                      AV_ERROR  OUT VARCHAR2) IS
    PRAGMA AUTONOMOUS_TRANSACTION;
    LN_VALIDA NUMBER;

  BEGIN
    AN_ERROR := 0;
    AV_ERROR := 'Ok';

    SELECT COUNT(1)
      INTO LN_VALIDA
      FROM OPERACION.SGAT_EQUIPO_SERVICIO_FIJA T
     WHERE T.SGAN_CUSTOMER_ID = AR_EQUIPO.SGAN_CUSTOMER_ID
       AND T.SGAV_NUMEROSERIE = AR_EQUIPO.SGAV_NUMEROSERIE;

    IF LN_VALIDA = 0 THEN

      INSERT INTO OPERACION.SGAT_EQUIPO_SERVICIO_FIJA VALUES AR_EQUIPO;

    ELSE

      UPDATE OPERACION.SGAT_EQUIPO_SERVICIO_FIJA T
         SET T.SGAN_CO_ID         = AR_EQUIPO.SGAN_CO_ID,
             T.SGAV_CODCLI        = AR_EQUIPO.SGAV_CODCLI,
             T.SGAN_CODSOLOT      = AR_EQUIPO.SGAN_CODSOLOT,
             T.SGAN_CODSOLOT_B_CE = AR_EQUIPO.SGAN_CODSOLOT_B_CE,
             T.SGAV_NUMEROSERIE   = AR_EQUIPO.SGAV_NUMEROSERIE,
             T.SGAV_IMEI_ESN_UA   = AR_EQUIPO.SGAV_IMEI_ESN_UA,
             T.SGAV_TECNOLOGIA    = AR_EQUIPO.SGAV_TECNOLOGIA,
             T.SGAN_CODINSSRV     = AR_EQUIPO.SGAN_CODINSSRV,
             T.SGAN_PID           = AR_EQUIPO.SGAN_PID,
             T.SGAV_TIPSRV        = AR_EQUIPO.SGAV_TIPSRV,
             T.SGAV_CODEQUCOM     = AR_EQUIPO.SGAV_CODEQUCOM,
             T.SGAN_TIPEQU        = AR_EQUIPO.SGAN_TIPEQU,
             T.SGAV_TIPO_EQUIPO   = AR_EQUIPO.SGAV_TIPO_EQUIPO,
             T.SGAV_CODTIPEQU     = AR_EQUIPO.SGAV_CODTIPEQU,
             T.SGAV_ESTADO        = AR_EQUIPO.SGAV_ESTADO
       WHERE T.SGAN_CUSTOMER_ID = AR_EQUIPO.SGAN_CUSTOMER_ID
         AND T.SGAV_NUMEROSERIE = AR_EQUIPO.SGAV_NUMEROSERIE;

    END IF;

    COMMIT;

  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      AN_ERROR := -1;
      AV_ERROR := 'Error : ' || SQLERRM || ' - Linea (' ||
                  DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ')';
  END SGASI_INSERTA_EQUIPO_FIJA;

  /******************************************************************
  '* Nombre SP : SGAI_CARGA_EQUIPO_POST
  '* Propósito : Funcionalidad para actualizar equipos de servicios Fija
  '* Input : SOT de Alta
  '* Output : <PO_ERROR> - <PO_MENSAJE>
  '* Creado por :
  '* Fec Creación : 18/03/2019
  '* Fec Actualización :
  '*****************************************************************/
 PROCEDURE SGAI_CARGA_EQUIPO_POST(AN_CODSOLOT IN SOLOT.CODSOLOT%TYPE,
                                  AN_ERROR    OUT NUMBER,
                                  AV_ERROR    OUT VARCHAR2) IS

   lr_equipo operacion.sgat_equipo_servicio_fija%rowtype;

   cursor c_equipos is
     select distinct s.cod_id,
                     s.customer_id,
                     s.codcli,
                     s.codsolot,
                     se.numserie,
                     se.mac,
                     'LTE' tecnologia,
                     i.codinssrv,
                     i.tipsrv,
                     se.codequcom,
                     se.tipequ,
                     t.tipo,
                     t.codtipequ,
                     decode(se.estado,
                            4,
                            'ACTIVO',
                            12,
                            'INACTIVO',
                            15,
                            'ACTIVO') Estado
       from solotptoequ se,
            solot s,
            solotpto sp,
            inssrv i,
            tipequ t,
            almtabmat a,
            (select a.codigon tipequ, to_number(codigoc) grupo
               from opedd a, tipopedd b
              where a.tipopedd = b.tipopedd
                and b.abrev in ('TIPEQU_DTH_CONAX', 'TIPEQU_LTE_TLF')) equ_conax
      where se.codsolot = s.codsolot
        and s.codsolot = sp.codsolot
        and se.punto = sp.punto
        and sp.codinssrv = i.codinssrv
        and t.tipequ = se.tipequ
        and a.codmat = t.codtipequ
        and se.codsolot IN (an_codsolot)
        and t.tipequ = equ_conax.tipequ;
 begin
   an_error := 0;
   av_error := 'Ok';

   for equ in c_equipos loop

     lr_equipo.sgan_co_id       := equ.cod_id;
     lr_equipo.sgan_customer_id := equ.customer_id;
     lr_equipo.sgav_codcli      := equ.codcli;
     if equ.estado = 'ACTIVO' then
       lr_equipo.sgan_codsolot := equ.codsolot;
     end if;
     lr_equipo.sgan_codsolot_b_ce := equ.codsolot;
     lr_equipo.sgav_numeroserie   := equ.numserie;
     lr_equipo.sgav_imei_esn_ua   := equ.mac;
     lr_equipo.sgav_tecnologia    := equ.tecnologia;
     lr_equipo.sgan_codinssrv     := equ.codinssrv;
     lr_equipo.sgan_pid           := null;
     lr_equipo.sgav_tipsrv        := equ.tipsrv;
     lr_equipo.sgav_codequcom     := equ.codequcom;
     lr_equipo.sgan_tipequ        := equ.tipequ;
     lr_equipo.sgav_tipo_equipo   := equ.tipo;
     lr_equipo.sgav_codtipequ     := equ.codtipequ;
     lr_equipo.sgav_estado        := equ.estado;
     lr_equipo.sgav_usureg        := user;
     lr_equipo.sgad_fecreg        := sysdate;

     operacion.pq_siac_cambio_plan_lte.sgasi_inserta_equipo_fija(lr_equipo,
                                                                 an_error,
                                                                 av_error);
   end loop;

 exception
   when others then
     an_error := -99;
     av_error := 'Ocurrió un error al ejecutar la carga de Equipos.' ||
                 sqlerrm;
 end;
END;
/