CREATE OR REPLACE PACKAGE BODY OPERACION.PKG_UPGRADE_SERV_CORP IS

  PROCEDURE SGASS_PROCESAR_SOT IS

    CURSOR C_PROCESA IS
      SELECT DISTINCT T.SGAN_CODSOLOT
        FROM SALES.SGAT_MIGRA_UP_CORP T WHERE T.SGAN_FLG_PROCESA = 0;
       
  BEGIN
  
    FOR C IN C_PROCESA LOOP
      
      SGASI_GENERAR_SOT(C.SGAN_CODSOLOT);
      
    END LOOP;
     
  END;

  PROCEDURE SGASI_GENERAR_SOT(PI_CODSOLOT OPERACION.SOLOT.CODSOLOT%TYPE) IS
    L_CODSOLOT       SOLOT.CODSOLOT%TYPE;
    vCOD_ID          NUMBER;
    vERROR           VARCHAR2(100);
    
  BEGIN
  
    L_CODSOLOT := SGAFUN_REGISTRAR_SOLOT(PI_CODSOLOT);
    
    IF L_CODSOLOT > 0 THEN
       SGASI_REGISTRAR_SOLOTPTO(L_CODSOLOT, PI_CODSOLOT);
    END IF;
    
    SGASU_ACT_VTADETPTOENL(PI_CODSOLOT);
 
  EXCEPTION
    WHEN OTHERS THEN
      
     vERROR:= SQLERRM;
     SELECT S.COD_ID INTO vCOD_ID FROM SOLOT S WHERE S.CODSOLOT = PI_CODSOLOT;
     
     SGASI_REG_LOG(NULL,
                    PI_CODSOLOT,
                    NULL,
                    L_CODSOLOT,
                    NULL,
                    NULL,
                    vERROR,
                    vCOD_ID,
                    'SGASI_GENERAR_SOT');
 
  END;

  FUNCTION SGAFUN_REGISTRAR_SOLOT(PI_CODSOLOT OPERACION.SOLOT.CODSOLOT%TYPE)
    RETURN                       SOLOT.CODSOLOT%TYPE IS
    
    L_CODSOLOT                   SOLOT.CODSOLOT%TYPE;
    L_TIPTRA                     TIPTRABAJO.TIPTRA%TYPE;
    vCOD_ID                      NUMBER;
    
  BEGIN
    
    L_TIPTRA := OPERACION.PQ_SGA_JANUS.F_GET_CONSTANTE_CONF('TIPTRUPSERMAS');
    
    SELECT SQ_SOLOT.NEXTVAL INTO L_CODSOLOT FROM DUAL;
    
    INSERT INTO SOLOT
      (CODSOLOT,
       TIPTRA,
       ESTSOL,
       TIPSRV,
       OBSERVACION,
       CODCLI,
       NUMSLC,
       CODMOTOT,
       AREASOL,
       FECCOM,
       CUSTOMER_ID,
       COD_ID)
      SELECT L_CODSOLOT,
             L_TIPTRA,
             10,
             SS.TIPSRV,
             'Activación Bono Full Claro CORP.',
             SS.CODCLI,
             SS.NUMSLC,
             SS.CODMOTOT,
             SS.AREASOL,
             SYSDATE,
             SS.CUSTOMER_ID,
             SS.COD_ID
        FROM SOLOT SS
       WHERE SS.CODSOLOT = PI_CODSOLOT;  
    RETURN L_CODSOLOT;
  EXCEPTION
    WHEN OTHERS THEN
      SELECT S.COD_ID INTO vCOD_ID FROM SOLOT S WHERE S.CODSOLOT = PI_CODSOLOT;
     
      SGASI_REG_LOG(NULL,
                    L_CODSOLOT,
                    NULL,
                    PI_CODSOLOT,
                    NULL,
                    NULL,
                    SQLERRM,
                    vCOD_ID,
                    'SGAFUN_REGISTRAR_SOLOT');
      RETURN 0;
  END;

  PROCEDURE SGASI_REGISTRAR_SOLOTPTO(P_CODSOLOT    SOLOT.CODSOLOT%TYPE,
                                    P_CODSOLOT_ANT SOLOT.CODSOLOT%TYPE) IS

    CURSOR INSPRDS_NEWS IS
      SELECT T.SGAN_CODSOLOT,
             T.SGAV_CODSRV_OLD,
             T.SGAV_CODSRV_NEW,
             T.SGAV_TIPO_SERVICIO,
             T.SGAV_TIPO_PRODUCTO,
             T.SGAN_SEQ
        FROM SALES.SGAT_MIGRA_UP_CORP T
       WHERE T.SGAN_CODSOLOT = P_CODSOLOT_ANT
         AND T.SGAN_FLG_PROCESA = 0;
         
    LV_TIPSRV    INSSRV.TIPSRV%TYPE;
    LN_CODINSSRV INSSRV.CODINSSRV%TYPE;
    LR_INSPRD    INSPRD%ROWTYPE;
    L_PID        INSPRD.PID%TYPE;
    L_IDDET      INSPRD.IDDET%TYPE;
    
  BEGIN
    
    FOR C IN INSPRDS_NEWS LOOP
      IF C.SGAV_TIPO_PRODUCTO = 'TELEFONIA' THEN
        LV_TIPSRV := CN_TIPSV_TLF;
      ELSIF C.SGAV_TIPO_PRODUCTO = 'INTERNET' THEN
        LV_TIPSRV := CN_TIPSV_INT;
      ELSIF C.SGAV_TIPO_PRODUCTO = 'CABLE' THEN
        LV_TIPSRV := CN_TIPSV_CABLE;
      END IF;
    
      LN_CODINSSRV := SGAFUN_GET_CODINSSRV(P_CODSOLOT_ANT, LV_TIPSRV);
                                          
      SELECT SQ_ID_INSPRD.NEXTVAL INTO L_PID FROM DUAL;
      
      SELECT PID.* INTO LR_INSPRD
        FROM INSPRD PID
       WHERE PID.CODINSSRV = LN_CODINSSRV
         AND PID.FLGPRINC = 1
         AND PID.ESTINSPRD IN (1,2);
         
      BEGIN
        SELECT (SELECT LP.IDDET
                  FROM LINEA_PAQUETE LP, DETALLE_PAQUETE DP
                 WHERE LP.CODSRV = SER.CODSRV
                   AND LP.IDDET = DP.IDDET
                   AND DP.IDPAQ = 4005)
          INTO L_IDDET
          FROM SALES.SERVICIO_SISACT SER
         WHERE SER.CODSRV = C.SGAV_CODSRV_NEW;
      EXCEPTION
        WHEN OTHERS THEN
          L_IDDET := NULL;
      END;
      
      INSERT INTO INSPRD
        (PID,
         ESTINSPRD,
         CODSRV,
         CODINSSRV,
         CANTIDAD,
         NUMSLC,
         NUMPTO,
         CODEQUCOM,
         IDDET,
         IDPLATAFORMA,
         FLGPRINC)
      VALUES
        (L_PID,
         4,
         C.SGAV_CODSRV_NEW,
         LR_INSPRD.CODINSSRV,
         LR_INSPRD.CANTIDAD,
         LR_INSPRD.NUMSLC,
         LR_INSPRD.NUMPTO,
         LR_INSPRD.CODEQUCOM,
         L_IDDET,
         7,
         DECODE(C.SGAV_TIPO_SERVICIO,
                'CORE',1,0));
                
      INSERT INTO SOLOTPTO
        (CODSOLOT,
         CODSRVNUE,
         BWNUE,
         CODINSSRV,
         DESCRIPCION,
         TIPO,
         ESTADO,
         VISIBLE,
         PID,
         PID_OLD)
      VALUES
        (P_CODSOLOT,
         C.SGAV_CODSRV_NEW,
         0,
         LR_INSPRD.CODINSSRV,
         LR_INSPRD.DESCRIPCION,
         1,
         1,
         1,
         L_PID,
         NULL);
         
      UPDATE SALES.SGAT_MIGRA_UP_CORP T
         SET T.SGAN_PID_OLD     = LR_INSPRD.PID,
             T.SGAN_PID_NEW     = L_PID,
             T.SGAN_FLG_PROCESA = 1,
             T.SGAD_FECMOD = SYSDATE,
             T.SGAN_CODSOLOT_UP = P_CODSOLOT
       WHERE T.SGAN_CODSOLOT = C.SGAN_CODSOLOT
         AND T.SGAN_FLG_PROCESA = 0
         AND T.SGAN_SEQ = C.SGAN_SEQ;
         COMMIT;
    END LOOP;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
  END;

  FUNCTION SGAFUN_GET_CODINSSRV(P_CODSOLOT OPERACION.SOLOT.CODSOLOT%TYPE,
                               P_TIPSRV   INSSRV.TIPSRV%TYPE)
    RETURN INSSRV.CODINSSRV%TYPE IS
    L_CODINSSRV INSSRV.CODINSSRV%TYPE;
    
  BEGIN
    SELECT DISTINCT INS.CODINSSRV
      INTO L_CODINSSRV
      FROM INSSRV INS
     WHERE INS.TIPSRV = P_TIPSRV
       AND INS.CODINSSRV IN
           (SELECT CODINSSRV FROM SOLOTPTO WHERE CODSOLOT = P_CODSOLOT);
    RETURN L_CODINSSRV;
  END;

  FUNCTION F_GET_TIPO_PRODUCTO(AV_CODSRV SALES.SGAT_MIGRA_UP_CORP.SGAV_CODSRV_OLD%TYPE)
    RETURN INSSRV.TIPSRV%TYPE IS
    LV_TIPSRV INSSRV.TIPSRV%TYPE;
  BEGIN
    SELECT DISTINCT T.TIPSRV
      INTO LV_TIPSRV
      FROM TYSTABSRV T
     WHERE T.CODSRV = AV_CODSRV;
    RETURN LV_TIPSRV;
  END;

  PROCEDURE SGASI_REG_LOG(AC_CODCLI      OPERACION.SOLOT.CODCLI%TYPE,
                      AN_CUSTOMER_ID NUMBER,
                      AN_IDTRS       NUMBER,
                      AN_CODSOLOT    NUMBER,
                      AN_IDINTERFACE NUMBER,
                      AN_ERROR       NUMBER,
                      AV_TEXTO       VARCHAR2,
                      AN_COD_ID      NUMBER DEFAULT 0,
                      AV_PROCESO     VARCHAR DEFAULT '') IS
    PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    INSERT INTO OPERACION.LOG_TRS_INTERFACE_IW
      (CODCLI,
       IDTRS,
       CODSOLOT,
       IDINTERFACE,
       ERROR,
       TEXTO,
       CUSTOMER_ID,
       COD_ID,
       PROCESO)
    VALUES
      (AC_CODCLI,
       AN_IDTRS,
       AN_CODSOLOT,
       AN_IDINTERFACE,
       AN_ERROR,
       AV_TEXTO,
       AN_CUSTOMER_ID,
       AN_COD_ID,
       AV_PROCESO);
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
  END;

  PROCEDURE P_EJE_UPGRADE_INCOGNITO(A_IDTAREAWF IN NUMBER,
                                    A_IDWF      IN NUMBER,
                                    A_TAREA     IN NUMBER,
                                    A_TAREADEF  IN NUMBER) IS
    N_CODSOLOT    NUMBER;
    N_COD_ID      NUMBER;
    N_CUSTOMER_ID NUMBER;
    AN_ERROR      NUMBER;
    AV_ERROR      VARCHAR2(4000);
  BEGIN
    SELECT A.CODSOLOT, B.COD_ID, B.CUSTOMER_ID
      INTO N_CODSOLOT, N_COD_ID, N_CUSTOMER_ID
      FROM WF A, SOLOT B
     WHERE A.CODSOLOT = B.CODSOLOT
       AND A.IDWF = A_IDWF
       AND VALIDO = 1;
    INTRAWAY.PQ_UPD_IW_SGA.P_ICG_MODSERV(N_CODSOLOT,
                                         AN_ERROR,
                                         AV_ERROR);
    SGASI_REG_LOG(NULL,
              N_CUSTOMER_ID,
              NULL,
              N_CODSOLOT,
              NULL,
              AN_ERROR,
              AV_ERROR,
              N_COD_ID,
              'P_EJE_UPGRADE_INCOGNITO');
  EXCEPTION
    WHEN OTHERS THEN
      SGASI_REG_LOG(NULL,
                N_CUSTOMER_ID,
                NULL,
                N_CODSOLOT,
                NULL,
                AN_ERROR,
                AV_ERROR,
                N_COD_ID,
                'P_EJE_UPGRADE_INCOGNITO');
  END P_EJE_UPGRADE_INCOGNITO;

  PROCEDURE SGASU_ACT_DESACT_SERV_SGA(A_IDTAREAWF IN NUMBER,
                                  A_IDWF      IN NUMBER,
                                  A_TAREA     IN NUMBER,
                                  A_TAREADEF  IN NUMBER) IS
    N_CODSOLOT    NUMBER;
    N_COD_ID      NUMBER;
    LV_CODIGO_EXT CONFIGURACION_ITW.CODIGO_EXT%TYPE;
    --ini 2.0
    CURSOR C_SOT_DESACT IS
      SELECT T.SGAN_PID_OLD
        FROM SALES.SGAT_MIGRA_UP_CORP T
       WHERE T.SGAN_CODSOLOT = N_CODSOLOT;
       
    CURSOR C_SOT_ACT IS
      SELECT T.SGAN_PID_OLD,
             T.SGAN_PID_NEW,
             T.SGAV_CODSRV_OLD,
             T.SGAV_CODSRV_NEW,
             SER.TIPSRV,
             T.SGAV_TIPO_SERVICIO,
             T.SGAV_TIPO_PRODUCTO
        FROM SALES.SGAT_MIGRA_UP_CORP T, TYSTABSRV SER
       WHERE T.SGAN_CODSOLOT_UP = N_CODSOLOT
         AND T.SGAV_CODSRV_NEW = SER.CODSRV;
    
  BEGIN
    SELECT A.CODSOLOT, B.COD_ID
      INTO N_CODSOLOT, N_COD_ID
      FROM WF A, SOLOT B
     WHERE A.CODSOLOT = B.CODSOLOT
       AND A.IDWF = A_IDWF
       AND VALIDO = 1;
    
    FOR C IN C_SOT_DESACT LOOP
      UPDATE INSPRD P
         SET P.ESTINSPRD = 3, P.FECFIN = SYSDATE
       WHERE P.PID = C.SGAN_PID_OLD;
    END LOOP;
    FOR C IN C_SOT_ACT LOOP
      UPDATE INSPRD P
         SET P.ESTINSPRD = 1, P.FECINI = SYSDATE
       WHERE P.PID = C.SGAN_PID_NEW;
      IF C.SGAV_TIPO_SERVICIO = 'CORE' THEN
        UPDATE INSSRV INS
           SET INS.CODSRV = C.SGAV_CODSRV_NEW
         WHERE INS.CODSRV = C.SGAV_CODSRV_OLD
           AND INS.CODINSSRV = (SELECT PID.CODINSSRV
                                  FROM INSPRD PID
                                 WHERE PID.PID = C.SGAN_PID_NEW);
        IF C.SGAV_TIPO_PRODUCTO = 'INTERNET' THEN
         
          BEGIN
            SELECT CI.CODIGO_EXT
              INTO LV_CODIGO_EXT
              FROM CONFIGURACION_ITW CI, SOLOTPTO SO, TYSTABSRV T
             WHERE SO.CODSRVNUE = T.CODSRV
               AND T.CODIGO_EXT = TO_CHAR(CI.IDCONFIGITW)
               AND CI.ESTADO = 1
               AND CI.TIPOSERVICIOITW = 4
               AND SO.CODSOLOT = N_CODSOLOT;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              LV_CODIGO_EXT := NULL;
          END;

        END IF;

      END IF;

    END LOOP;


  END SGASU_ACT_DESACT_SERV_SGA;

  PROCEDURE SGASU_ACT_VTADETPTOENL(P_CODSOLOT SOLOT.CODSOLOT%TYPE) IS
    LV_TIPSRV       INSSRV.TIPSRV%TYPE;
    LV_NUMSLC       SOLOT.NUMSLC%TYPE;
    
    CURSOR C_UPGRADE IS
      SELECT T.*
        FROM SALES.SGAT_MIGRA_UP_CORP T, SOLOT S
       WHERE S.CODSOLOT = T.SGAN_CODSOLOT_UP
         AND S.TIPTRA = 814
         AND T.SGAN_CODSOLOT = P_CODSOLOT;

  BEGIN
    FOR C IN C_UPGRADE LOOP

      SELECT S.NUMSLC
        INTO LV_NUMSLC
        FROM SOLOT S
       WHERE S.CODSOLOT = P_CODSOLOT;

      IF C.SGAV_TIPO_PRODUCTO = 'TELEFONIA' THEN
        LV_TIPSRV := CN_TIPSV_TLF;
      ELSIF C.SGAV_TIPO_PRODUCTO = 'INTERNET' THEN
        LV_TIPSRV := CN_TIPSV_INT;
      ELSIF C.SGAV_TIPO_PRODUCTO = 'CABLE' THEN
        LV_TIPSRV := CN_TIPSV_CABLE;
      END IF;

      IF C.SGAV_TIPO_SERVICIO = 'CORE' THEN
        UPDATE VTADETPTOENL DET
           SET DET.CODSRV = C.SGAV_CODSRV_NEW
         WHERE DET.NUMSLC = LV_NUMSLC
           AND DET.CODSRV = C.SGAV_CODSRV_OLD
           AND DET.FLGSRV_PRI = '1';
      END IF;
      COMMIT;
    END LOOP;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
  END;

  PROCEDURE SGASI_JOB_ATIENDE_SOT_UP IS
    LN_COD_REP       NUMBER;
    LS_MSJ_RESP      VARCHAR2(1000);
    V_FECHA          VARCHAR2(50);
    V_LENGTH         NUMBER;
    
    CURSOR C_SOT_SVT IS
      SELECT S.CODSOLOT CPN_SOLOT, S.COD_ID, S.CUSTOMER_ID, S.CODCLI
        FROM OPERACION.SOLOT S
       WHERE S.TIPTRA = 814
         AND S.ESTSOL = 17;
    CURSOR C_TAREA_SOT(K_CODSOLOT NUMBER) IS
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
                 AND A.ABREV = 'CIERAUTUPCRP') XX
       WHERE W.IDWF = TW.IDWF
         AND W.CODSOLOT = K_CODSOLOT
         AND TW.TAREADEF = XX.CODIGON
         AND W.VALIDO = 1
         AND TW.ESTTAREA = 1;
  BEGIN
    FOR C_SVT IN C_SOT_SVT LOOP
      BEGIN
        FOR C_TAREAS IN C_TAREA_SOT(C_SVT.CPN_SOLOT) LOOP
          CASE C_TAREAS.CODIGOC
            WHEN 'AUTO' THEN
              OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(C_TAREAS.IDTAREAWF,
                                               4,
                                               C_TAREAS.CODIGON_AUX,
                                               0,
                                               SYSDATE,
                                               SYSDATE);
              SGASI_REG_LOG(C_SVT.CODCLI,
                        C_SVT.CUSTOMER_ID,
                        NULL,
                        C_SVT.CPN_SOLOT,
                        NULL,
                        LN_COD_REP,
                        LS_MSJ_RESP,
                        C_SVT.COD_ID,
                        'SGASS_CIERRE_TAREA-' || C_TAREAS.DESCRIPCION);

              IF LN_COD_REP = 0 THEN
                DBMS_OUTPUT.PUT_LINE(V_FECHA || RPAD(' Tarea: ' ||
                                                     C_TAREAS.DESCRIPCION,
                                                     V_LENGTH + 8,
                                                     ' ') ||
                                     ' > Se cerro correctamente');
              ELSE
                DBMS_OUTPUT.PUT_LINE(V_FECHA || RPAD(' Tarea: ' ||
                                                     C_TAREAS.DESCRIPCION,
                                                     V_LENGTH + 8,
                                                     ' ') || ' > Error: ' ||
                                     LS_MSJ_RESP);
                GOTO SOT;
              END IF;
            WHEN 'PROV' THEN
              LN_COD_REP := 0;
              BEGIN
                INTRAWAY.PQ_UPD_IW_SGA.P_ICG_MODSERV(C_SVT.CPN_SOLOT,
                                                     LN_COD_REP,
                                                     LS_MSJ_RESP,
                                                     0);

                 IF LN_COD_REP = 1 THEN
                   INTRAWAY.PQ_EJECUTA_MASIVO.P_CARGA_INFO_INT_ENVIO(C_SVT.CPN_SOLOT);
                 END IF;

                IF LN_COD_REP <> 1 THEN
                  DBMS_OUTPUT.PUT_LINE(V_FECHA || RPAD(' Tarea: ' ||
                                                       C_TAREAS.DESCRIPCION,
                                                       V_LENGTH + 8,
                                                       ' ') ||
                                       ' > Error: ' || LS_MSJ_RESP);
                  SGASI_REG_LOG(C_SVT.CODCLI,
                            C_SVT.CUSTOMER_ID,
                            NULL,
                            C_SVT.CPN_SOLOT,
                            NULL,
                            LN_COD_REP,
                            LS_MSJ_RESP,
                            C_SVT.COD_ID,
                            'SGASI_JOB_ATIENDE_SOT_UP');
                  GOTO SOT;
                END IF;

                SGASI_REG_LOG(C_SVT.CODCLI,
                            C_SVT.CUSTOMER_ID,
                            NULL,
                            C_SVT.CPN_SOLOT,
                            NULL,
                            LN_COD_REP,
                            LS_MSJ_RESP,
                            C_SVT.COD_ID,
                            'SGASI_JOB_ATIENDE_SOT_UP');

              EXCEPTION
                WHEN OTHERS THEN
                  LN_COD_REP  := -2020;
                  LS_MSJ_RESP := 'SGASI_JOB_ATIENDE_SOT_UP :' || SQLERRM;
                  DBMS_OUTPUT.PUT_LINE(V_FECHA || RPAD(' Tarea: ' ||
                                                       C_TAREAS.DESCRIPCION,
                                                       V_LENGTH + 8,
                                                       ' ') ||
                                       ' > Error: ' || LS_MSJ_RESP);
                  OPERACION.PQ_SGA_BSCS.P_REG_LOG(C_SVT.CODCLI,
                                                  C_SVT.CUSTOMER_ID,
                                                  NULL,
                                                  C_SVT.CPN_SOLOT,
                                                  NULL,
                                                  LN_COD_REP,
                                                  LS_MSJ_RESP,
                                                  C_SVT.COD_ID,
                                                  'SGASI_JOB_ATIENDE_SOT_UP');
                  GOTO SOT;
              END;
              OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(C_TAREAS.IDTAREAWF,
                                               4,
                                               C_TAREAS.CODIGON_AUX,
                                               0,
                                               SYSDATE,
                                               SYSDATE);
           WHEN 'INIFAC' THEN
              OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(C_TAREAS.IDTAREAWF,
                                               4,
                                               C_TAREAS.CODIGON_AUX,
                                               0,
                                               SYSDATE,
                                               SYSDATE);
            ELSE
              DBMS_OUTPUT.PUT_LINE(V_FECHA || RPAD('No existe configuracion para la Tarea: ' ||
                                                   C_TAREAS.DESCRIPCION,
                                                   V_LENGTH + 8,
                                                   ' '));
          END CASE;
          <<SOT>>
          LN_COD_REP := 0;
        END LOOP;
        COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
          ROLLBACK;
          LN_COD_REP  := -9;
          LS_MSJ_RESP := 'MENSAJE DE ERROR: ' || TO_CHAR(SQLERRM) ||
                         CHR(13) || '-TRAZA DE ERROR:   ' ||
                         DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
          SGASI_REG_LOG(C_SVT.CODCLI,
                    C_SVT.CUSTOMER_ID,
                    NULL,
                    C_SVT.CPN_SOLOT,
                    NULL,
                    LN_COD_REP,
                    LS_MSJ_RESP,
                    C_SVT.COD_ID,
                    'SGASI_JOB_ATIENDE_SOT_UP');
      END;
    END LOOP;
  END;

END;
/