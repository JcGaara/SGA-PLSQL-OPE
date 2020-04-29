CREATE OR REPLACE PACKAGE BODY OPERACION.PQ_UPGRADE_SERVICIO_MAS IS

  /*******************************************************************************
  PROPOSITO: Generacion de SOT por Updagre de servicio
  *******************************************************************************/
  PROCEDURE P_JOB_GENERA_SOT IS
    CURSOR C_PROCESA IS
      SELECT DISTINCT T.COD_ID
        FROM SALES.MIGRA_UPGRADE_MASIVO T
       WHERE T.FLG_PROCESA = 0
         AND NVL(CF_ACTUAL, 0) = 0;--<2.0>
  BEGIN
    FOR C IN C_PROCESA LOOP
      BEGIN
        IF OPERACION.PQ_SGA_IW.F_VAL_STATUS_CONTRATO(C.COD_ID) = 1 THEN
          P_GENERA_TRANS_UPGRADE(C.COD_ID);
        END IF;
      EXCEPTION
        WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE('ERROR : ' || SQLERRM || ' CO_ID : ' ||
                               C.COD_ID || ' - Linea (' ||
                               DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ')');
      END;
    END LOOP;
  END;

  PROCEDURE P_GENERA_TRANS_UPGRADE(P_COD_ID OPERACION.SOLOT.COD_ID%TYPE) IS
    L_CODSOLOT      SOLOT.CODSOLOT%TYPE;
    L_WFDEF         WF.WFDEF%TYPE;
    LN_CODSOLOT_MAX NUMBER;
    AN_ERROR        NUMBER;
    AV_ERROR        VARCHAR2(4000);
  BEGIN
    LN_CODSOLOT_MAX := OPERACION.PQ_SGA_IW.F_MAX_SOT_X_COD_ID(P_COD_ID);
    L_CODSOLOT      := REGISTRAR_SOLOT(P_COD_ID,
                                       LN_CODSOLOT_MAX);
    REGISTRAR_SOLOTPTO(P_COD_ID,
                       L_CODSOLOT,
                       LN_CODSOLOT_MAX);

    P_ACT_VTADETPTOENL(p_COD_ID); --4.0

    --ini 2.0
    L_WFDEF := CUSBRA.F_BR_SEL_WF(L_CODSOLOT);
    PQ_SOLOT.P_ASIG_WF(L_CODSOLOT,
                       L_WFDEF);
    --fin 2.0
  EXCEPTION
    WHEN OTHERS THEN
      AV_ERROR := SQLERRM || ' Linea (' ||
                  DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ')';
      P_REG_LOG(NULL,
                LN_CODSOLOT_MAX,
                NULL,
                L_CODSOLOT,
                NULL,
                AN_ERROR,
                AV_ERROR,
                P_COD_ID,
                'P_ACT_DESACT_SERV_BSCS');
  END;

  FUNCTION REGISTRAR_SOLOT(P_COD_ID   OPERACION.SOLOT.COD_ID%TYPE,
                           P_CODSOLOT OPERACION.SOLOT.CODSOLOT%TYPE)
    RETURN SOLOT.CODSOLOT%TYPE IS
    L_CODSOLOT SOLOT.CODSOLOT%TYPE;
    L_TIPTRA   TIPTRABAJO.TIPTRA%TYPE;
    AN_ERROR   NUMBER;
    AV_ERROR   VARCHAR2(4000);
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
             'IDEA-43470 - Realizar upgrade HFC',
             SS.CODCLI,
             SS.NUMSLC,
             SS.CODMOTOT,
             SS.AREASOL,
             SYSDATE,
             SS.CUSTOMER_ID,
             SS.COD_ID
        FROM SOLOT SS
       WHERE SS.CODSOLOT = P_CODSOLOT;
    RETURN L_CODSOLOT;
  EXCEPTION
    WHEN OTHERS THEN
      AV_ERROR := SQLERRM || ' Linea (' ||
                  DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ')';
      P_REG_LOG(NULL,
                P_CODSOLOT,
                NULL,
                L_CODSOLOT,
                NULL,
                AN_ERROR,
                AV_ERROR,
                P_COD_ID,
                'REGISTRAR_SOLOT');
      RETURN 0;
  END;

  PROCEDURE REGISTRAR_SOLOTPTO(P_COD_ID       SOLOT.COD_ID%TYPE,
                               P_CODSOLOT     SOLOT.CODSOLOT%TYPE,
                               P_CODSOLOT_ANT SOLOT.CODSOLOT%TYPE) IS
    --ini 3.0
    AN_ERROR   NUMBER;
    AV_ERROR   VARCHAR2(4000); 
    --fin 3.0                              
    --ini 2.0
    CURSOR INSPRDS_NEWS IS
      SELECT T.COD_ID,
             T.CODSRV_OLD,
             T.CODSRV_NEW,
             T.SNCODE_ACTUAL,
             T.CF_ACTUAL,
             T.SNCODE_NEW,
             T.CF_NEW,
             T.TIPO_SERVICIO,
             T.TIPO_PRODUCTO,
             T.SEQ
        FROM SALES.MIGRA_UPGRADE_MASIVO T
       WHERE T.COD_ID = P_COD_ID
         AND T.FLG_PROCESA = 0
         AND T.SNCODE_NEW IS NOT NULL;
    LV_TIPSRV    INSSRV.TIPSRV%TYPE;
    LN_CODINSSRV INSSRV.CODINSSRV%TYPE;
    LR_INSPRD    INSPRD%ROWTYPE;
    L_PID        INSPRD.PID%TYPE;
    L_IDDET      INSPRD.IDDET%TYPE;
  BEGIN
    FOR C IN INSPRDS_NEWS LOOP
      IF C.TIPO_PRODUCTO = 'TELEFONIA' THEN
        LV_TIPSRV := CN_TIPSV_TLF;
      ELSIF C.TIPO_PRODUCTO = 'INTERNET' THEN
        LV_TIPSRV := CN_TIPSV_INT;
      ELSIF C.TIPO_PRODUCTO = 'CABLE' THEN
        LV_TIPSRV := CN_TIPSV_CABLE;
      END IF;
      --LV_TIPSRV    := F_GET_TIPO_PRODUCTO(C.CODSRV_NEW);
      LN_CODINSSRV := GET_CODINSSRV(P_CODSOLOT_ANT,
                                    LV_TIPSRV);
      SELECT SQ_ID_INSPRD.NEXTVAL INTO L_PID FROM DUAL;
      SELECT PID.*
        INTO LR_INSPRD
        FROM INSPRD PID
       WHERE PID.CODINSSRV = LN_CODINSSRV
         AND PID.FLGPRINC = 1
         AND PID.ESTINSPRD IN (1,
                               2);
      BEGIN
        SELECT (SELECT LP.IDDET
                  FROM LINEA_PAQUETE LP, DETALLE_PAQUETE DP
                 WHERE LP.CODSRV = SER.CODSRV
                   AND LP.IDDET = DP.IDDET
                   AND DP.IDPAQ = 4005)
          INTO L_IDDET
          FROM SALES.SERVICIO_SISACT SER
         WHERE SER.CODSRV = C.CODSRV_NEW;
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
         C.CODSRV_NEW,
         LR_INSPRD.CODINSSRV,
         LR_INSPRD.CANTIDAD,
         LR_INSPRD.NUMSLC,
         LR_INSPRD.NUMPTO,
         LR_INSPRD.CODEQUCOM,
         L_IDDET,
         7,
         DECODE(C.TIPO_SERVICIO,
                'CORE',
                1,
                0));
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
         C.CODSRV_NEW,
         0,
         LR_INSPRD.CODINSSRV,
         LR_INSPRD.DESCRIPCION,
         1,
         1,
         1,
         L_PID,
         NULL);
      UPDATE SALES.MIGRA_UPGRADE_MASIVO T
         SET T.PID_OLD     = LR_INSPRD.PID,
             T.PID_NEW     = L_PID,
             T.FLG_PROCESA = 1,
             T.CODSOLOT    = P_CODSOLOT_ANT,
             T.CODSOLOT_UP = P_CODSOLOT
       WHERE T.COD_ID = C.COD_ID
         AND T.FLG_PROCESA = 0
         AND T.SEQ = C.SEQ;
    END LOOP;
    --fin 2.0
  EXCEPTION
    WHEN OTHERS THEN
      --ini 3.0
      AV_ERROR := SQLERRM || ' Linea (' ||
                  DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ')';
      P_REG_LOG(NULL,
                P_CODSOLOT_ANT,
                NULL,
                P_CODSOLOT,
                NULL,
                AN_ERROR,
                AV_ERROR,
                P_COD_ID,
                'REGISTRAR_SOLOTPTO');
      --fin 3.0                
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || SQLERRM);
  END;

  FUNCTION GET_CODINSSRV(P_CODSOLOT OPERACION.SOLOT.CODSOLOT%TYPE,
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
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || SQLERRM);
  END;

  FUNCTION F_GET_TIPO_PRODUCTO(AV_CODSRV SALES.MIGRA_UPGRADE_MASIVO.CODSRV_OLD%TYPE)
    RETURN INSSRV.TIPSRV%TYPE IS
    LV_TIPSRV INSSRV.TIPSRV%TYPE;
  BEGIN
    SELECT DISTINCT T.TIPSRV
      INTO LV_TIPSRV
      FROM TYSTABSRV T
     WHERE T.CODSRV = AV_CODSRV;
    RETURN LV_TIPSRV;
  END;

  PROCEDURE P_REG_LOG(AC_CODCLI      OPERACION.SOLOT.CODCLI%TYPE,
                      AN_CUSTOMER_ID NUMBER,
                      AN_IDTRS       NUMBER,
                      AN_CODSOLOT    NUMBER,
                      AN_IDINTERFACE NUMBER,
                      AN_ERROR       NUMBER,
                      AV_TEXTO       VARCHAR2,
                      AN_COD_ID      NUMBER DEFAULT 0,
                      AV_PROCESO     VARCHAR DEFAULT '') IS
    PRAGMA AUTONOMOUS_TRANSACTION;
  K_ID INTEGER;
  BEGIN
    --ini 2.0
     SELECT NVL(MAX(M.SGAN_FLG_CAMBPREC),0) + 1 INTO K_ID FROM SALES.SGAT_MIGRA_UPGRADE_MASIVO_HIST M
      WHERE NVL(M.SGAN_CF_ACTUAL, 0) = 0 AND TRUNC(M.SGAD_FEC_REG) = TRUNC(SYSDATE); 
      G_ID:= K_ID;
   --fin 2.0    
  
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
      ('000111333',
       G_ID,
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
    P_REG_LOG(NULL,
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
      P_REG_LOG(NULL,
                N_CUSTOMER_ID,
                NULL,
                N_CODSOLOT,
                NULL,
                AN_ERROR,
                AV_ERROR,
                N_COD_ID,
                'P_EJE_UPGRADE_INCOGNITO');
  END P_EJE_UPGRADE_INCOGNITO;

  PROCEDURE P_CAMBIO_JANUS(AN_CODSOLOT NUMBER) IS
    LN_TLF         NUMBER;
    LN_COD_ID      NUMBER;
    LN_CUSTOMER_ID NUMBER;
    LN_ERROR       NUMBER;
    LV_ERROR       VARCHAR2(4000);
    ERROR_GENERAL EXCEPTION;
    AN_ERROR       NUMBER;
    AV_ERROR       VARCHAR2(4000);
    V_SPCODE       NUMBER;
    A_SNCODE       TIM.PP017_SIAC_MIGRACIONES.ARR_SERVICIOS@DBL_BSCS_BF;
    A_SPCODE       TIM.PP017_SIAC_MIGRACIONES.ARR_SERVICIOS@DBL_BSCS_BF;
    V_RPT          NUMBER;
    LN_ORDERID     NUMBER;
    LN_ORDERID_OLD NUMBER;
    LN_ORDERID_CP  NUMBER;
    LN_CONT        NUMBER;
    LN_SNCODE_NEW  NUMBER;
    LN_SNCODE_OLD  NUMBER;
    LV_VALORES     VARCHAR2(1000);
    CURSOR C_TLF_BAJA IS
      SELECT PS.CO_ID,
             P.COD_PROD1 ACTION_ID,
             PS.SNCODE,
             SPH.SPCODE,
             P.COD_PROD3 TARIFF_ID,
             CA.TMCODE
        FROM PROFILE_SERVICE@DBL_BSCS_BF       PS,
             PR_SERV_STATUS_HIST@DBL_BSCS_BF   SSH,
             PR_SERV_SPCODE_HIST@DBL_BSCS_BF   SPH,
             TIM.PF_HFC_PARAMETROS@DBL_BSCS_BF P,
             CONTRACT_ALL@DBL_BSCS_BF          CA
       WHERE PS.CO_ID = LN_COD_ID
         AND PS.CO_ID = CA.CO_ID
         AND PS.CO_ID = SSH.CO_ID
         AND PS.SNCODE = SSH.SNCODE
         AND PS.STATUS_HISTNO = SSH.HISTNO
         AND SSH.STATUS IN ('O',
                            'A')
         AND P.CAMPO = 'SERV_ADICIONAL'
         AND P.COD_PROD2 = PS.SNCODE
         AND PS.CO_ID = SPH.CO_ID
         AND PS.SNCODE = SPH.SNCODE
         AND PS.SPCODE_HISTNO = SPH.HISTNO;
    --ini 2.0
    CURSOR C_TLF_ALTA IS
      SELECT T.SNCODE_NEW  SNCODE,
             T.COD_ID,
             T.CUSTOMER_ID,
             CA.TMCODE,
             T.CF_NEW      CF,
             T.SEQ
        FROM SALES.MIGRA_UPGRADE_MASIVO T, CONTRACT_ALL@DBL_BSCS_BF CA
       WHERE T.COD_ID = CA.CO_ID
         AND T.CODSOLOT_UP = AN_CODSOLOT
         AND T.FLG_PROCESA_JANUS = 0
         AND T.TIPO_SERVICIO = 'ADICIONALES'
         AND T.TIPO_PRODUCTO = 'TELEFONIA';
    --fin 2.0
  BEGIN
    LN_TLF         := OPERACION.PQ_SGA_JANUS.F_VAL_SERV_TLF_SOT(AN_CODSOLOT);
    LN_ORDERID_CP  := NULL;
    LN_ORDERID_OLD := NULL;
    IF LN_TLF != 0 THEN
      LN_CONT := 0;
      SELECT DISTINCT T.COD_ID,
                      T.CUSTOMER_ID,
                      T.SNCODE_ACTUAL,
                      T.SNCODE_NEW
        INTO LN_COD_ID, LN_CUSTOMER_ID, LN_SNCODE_OLD, LN_SNCODE_NEW
        FROM SOLOT S, SALES.MIGRA_UPGRADE_MASIVO T, TYSTABSRV SER
       WHERE S.CODSOLOT = AN_CODSOLOT
         AND S.COD_ID = T.COD_ID
         AND S.CODSOLOT = T.CODSOLOT_UP
         AND T.CODSRV_OLD = SER.CODSRV
         AND SER.TIPSRV = CN_TIPSV_TLF;
      TIM.PP004_SIAC_LTE.SIACSI_PROV_JANUS_CP@DBL_BSCS_BF(LN_COD_ID,
                                                          LN_CUSTOMER_ID,
                                                          'HFC',
                                                          LN_SNCODE_NEW,
                                                          LN_SNCODE_OLD,
                                                          LV_VALORES,
                                                          LN_ERROR,
                                                          LV_ERROR);
      BEGIN
        SELECT PR.ORD_ID
          INTO LN_ORDERID_CP
          FROM TIM.RP_PROV_BSCS_JANUS@DBL_BSCS_BF PR
         WHERE PR.CO_ID = LN_COD_ID
           AND PR.ORD_ID = (SELECT MAX(F.ORD_ID)
                              FROM TIM.RP_PROV_BSCS_JANUS@DBL_BSCS_BF F
                             WHERE F.CO_ID = PR.CO_ID
                               AND F.ACTION_ID = 16);
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          LN_ORDERID_CP := NULL;
      END;
      FOR C IN C_TLF_BAJA LOOP
        A_SNCODE(1) := C.SNCODE;
        A_SPCODE(1) := C.SPCODE;
        V_RPT := TIM.TFUN108_REG_SERVICIOS_HFC@DBL_BSCS_BF(LN_COD_ID,
                                                           A_SNCODE,
                                                           A_SPCODE,
                                                           'D');
        IF V_RPT != 0 THEN
          AN_ERROR := V_RPT;
          AV_ERROR := 'Error al Desactivar el SNCODE :' || C.SNCODE;
          RAISE ERROR_GENERAL;
        END IF;
        SP_PROV_ADIC_JANUS(LN_COD_ID,
                           LN_CUSTOMER_ID,
                           C.TMCODE,
                           C.SNCODE,
                           'D',
                           AN_ERROR,
                           AV_ERROR,
                           LN_ORDERID);
        IF LN_CONT = 0 THEN
          UPDATE TIM.RP_PROV_BSCS_JANUS@DBL_BSCS_BF
             SET ORD_ID_ANT = LN_ORDERID_CP
           WHERE ORD_ID = LN_ORDERID;
        ELSE
          BEGIN
            SELECT PR.ORD_ID
              INTO LN_ORDERID_OLD
              FROM TIM.RP_PROV_BSCS_JANUS@DBL_BSCS_BF PR
             WHERE PR.CO_ID = LN_COD_ID
               AND PR.ORD_ID = (SELECT MAX(F.ORD_ID)
                                  FROM TIM.RP_PROV_BSCS_JANUS@DBL_BSCS_BF F
                                 WHERE F.CO_ID = PR.CO_ID
                                   AND F.ORD_ID != LN_ORDERID);
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              LN_ORDERID_OLD := NULL;
          END;
          UPDATE TIM.RP_PROV_BSCS_JANUS@DBL_BSCS_BF
             SET ORD_ID_ANT = LN_ORDERID_OLD
           WHERE ORD_ID = LN_ORDERID;
        END IF;
        LN_CONT := LN_CONT + 1;
      END LOOP;
      COMMIT;
      LN_CONT := 0;
      FOR C IN C_TLF_ALTA LOOP
        SELECT TMB.SPCODE
          INTO V_SPCODE
          FROM MPULKTMB@DBL_BSCS_BF TMB
         WHERE TMB.TMCODE = C.TMCODE
           AND TMB.VSCODE = (SELECT MAX(RV.VSCODE)
                               FROM RATEPLAN_VERSION@DBL_BSCS_BF RV
                              WHERE RV.TMCODE = TMB.TMCODE
                                AND RV.VSDATE <= SYSDATE
                                AND RV.STATUS = 'P')
           AND TMB.SNCODE = C.SNCODE;
        A_SNCODE(1) := C.SNCODE;
        A_SPCODE(1) := V_SPCODE;
        V_RPT := TIM.TFUN108_REG_SERVICIOS_HFC@DBL_BSCS_BF(LN_COD_ID,
                                                           A_SNCODE,
                                                           A_SPCODE,
                                                           'A');
        IF V_RPT != 0 THEN
          AN_ERROR := V_RPT;
          AV_ERROR := 'Error al Desactivar el SNCODE :' || C.SNCODE;
          RAISE ERROR_GENERAL;
        END IF;
        UPDATE SYSADM.PROFILE_SERVICE@DBL_BSCS_BF PS
           SET PS.ACCESSFEE      = C.CF,
               PS.OVW_ADV_CHARGE = 'A',
               PS.ADV_CHARGE     = C.CF,
               PS.OVW_ACCESS     = 'A',
               OVW_ACC_PRD       = -1,
               ADV_CHARGE_PRD    = -1
         WHERE PS.CO_ID = C.COD_ID
           AND PS.SNCODE = C.SNCODE
           AND PS.STATUS_HISTNO =
               (SELECT MAX(P.HISTNO)
                  FROM SYSADM.PR_SERV_STATUS_HIST@DBL_BSCS_BF P
                 WHERE P.CO_ID = PS.CO_ID
                   AND P.SNCODE = PS.SNCODE);
        SP_PROV_ADIC_JANUS(LN_COD_ID,
                           LN_CUSTOMER_ID,
                           C.TMCODE,
                           C.SNCODE,
                           'A',
                           AN_ERROR,
                           AV_ERROR,
                           LN_ORDERID);
        IF LN_CONT = 0 THEN
          UPDATE TIM.RP_PROV_BSCS_JANUS@DBL_BSCS_BF
             SET ORD_ID_ANT = NVL(LN_ORDERID_OLD,
                                  LN_ORDERID_CP)
           WHERE ORD_ID = LN_ORDERID;
        ELSE
          BEGIN
            SELECT PR.ORD_ID
              INTO LN_ORDERID_OLD
              FROM TIM.RP_PROV_BSCS_JANUS@DBL_BSCS_BF PR
             WHERE PR.CO_ID = LN_COD_ID
               AND PR.ORD_ID = (SELECT MAX(F.ORD_ID)
                                  FROM TIM.RP_PROV_BSCS_JANUS@DBL_BSCS_BF F
                                 WHERE F.CO_ID = PR.CO_ID
                                   AND F.ORD_ID != LN_ORDERID);
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              LN_ORDERID_OLD := NULL;
          END;
          UPDATE TIM.RP_PROV_BSCS_JANUS@DBL_BSCS_BF
             SET ORD_ID_ANT = LN_ORDERID_OLD
           WHERE ORD_ID = LN_ORDERID;
        END IF;
        --ini 2.0
        UPDATE SALES.MIGRA_UPGRADE_MASIVO T
           SET T.FLG_PROCESA_JANUS = 1
         WHERE T.SNCODE_NEW = C.SNCODE
           AND T.CODSOLOT_UP = AN_CODSOLOT
           AND T.SEQ = C.SEQ;
        --fin 2.0
        LN_CONT := LN_CONT + 1;
      END LOOP;
      COMMIT;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      AN_ERROR := -1;
      AV_ERROR := SQLERRM || ' - LINEA : ' ||
                  DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      P_REG_LOG(NULL,
                LN_CUSTOMER_ID,
                NULL,
                AN_CODSOLOT,
                NULL,
                AN_ERROR,
                AV_ERROR,
                LN_COD_ID,
                'P_CAMBIO_JANUS');
  END P_CAMBIO_JANUS;

  PROCEDURE SP_PROV_ADIC_JANUS(P_CO_ID       IN INTEGER,
                               P_CUSTOMER_ID IN INTEGER,
                               P_TMCODE      IN INTEGER,
                               P_SNCODE      IN INTEGER,
                               P_ACCION      IN VARCHAR2,
                               P_RESULTADO   OUT INTEGER,
                               P_MSGERR      OUT VARCHAR2,
                               P_ORDID       OUT NUMBER) IS
    V_REG    INTEGER;
    LN_ORDID NUMBER;
    CURSOR CUR_LINEAS IS
      SELECT CSC.CO_ID,
             DN.DN_NUM,
             'IMSI' || DN.DN_NUM IMSI,
             DN.DN_NUM NRO_CORTO
        FROM CONTR_SERVICES_CAP@DBL_BSCS_BF CSC,
             DIRECTORY_NUMBER@DBL_BSCS_BF   DN
       WHERE CSC.CO_ID = P_CO_ID
         AND CSC.DN_ID = DN.DN_ID
         AND CSC.CS_DEACTIV_DATE IS NULL;

    CURSOR CUR_PROD_COMP(PC_CO_ID INTEGER) IS
      SELECT PS.CO_ID,
             P.COD_PROD1 ACTION_ID,
             PS.SNCODE,
             SPH.SPCODE,
             P.COD_PROD3 TARIFF_ID
        FROM PROFILE_SERVICE@DBL_BSCS_BF       PS,
             PR_SERV_STATUS_HIST@DBL_BSCS_BF   SSH,
             PR_SERV_SPCODE_HIST@DBL_BSCS_BF   SPH,
             TIM.PF_HFC_PARAMETROS@DBL_BSCS_BF P
       WHERE PS.CO_ID = PC_CO_ID
         AND PS.CO_ID = SSH.CO_ID
         AND PS.SNCODE = SSH.SNCODE
         AND PS.SNCODE = P_SNCODE
         AND PS.STATUS_HISTNO = SSH.HISTNO
         AND SSH.STATUS IN ('O',
                            'A')
         AND P.CAMPO = 'SERV_ADICIONAL'
         AND P.COD_PROD2 = PS.SNCODE
         AND PS.CO_ID = SPH.CO_ID
         AND PS.SNCODE = SPH.SNCODE
         AND PS.SPCODE_HISTNO = SPH.HISTNO;

  BEGIN
    P_RESULTADO := 0;
    P_MSGERR    := 'PROCESO SATISFACTORIO';
    -- VALIDAMOS DATOS INGRESADOS
    IF P_CO_ID IS NULL OR P_CUSTOMER_ID IS NULL OR P_TMCODE IS NULL OR
       P_SNCODE IS NULL OR P_ACCION IS NULL THEN
      P_RESULTADO := -1;
      P_MSGERR    := 'DATOS INVALIDOS';
      RETURN;
    END IF;
    LN_ORDID := NULL;
    --VALIDAMOS QUE SERVICIO ESTE ASOCIADO A PLAN
    SELECT COUNT(1)
      INTO V_REG
      FROM MPULKTMB@DBL_BSCS_BF TMB
     WHERE TMB.TMCODE = P_TMCODE
       AND TMB.SNCODE = P_SNCODE
       AND TMB.VSCODE = (SELECT MAX(V.VSCODE)
                           FROM RATEPLAN_VERSION@DBL_BSCS_BF V
                          WHERE V.TMCODE = TMB.TMCODE
                            AND V.VSDATE <= SYSDATE
                            AND V.STATUS = 'P');
    IF V_REG = 0 THEN
      P_RESULTADO := -2;
      P_MSGERR    := 'PRODUCTOS TELEFONIA NO ASOCIADO A PLAN TARIFARIO';
      RETURN;
    END IF;
    -- REGISTRAMOS DATOS PARA PROVISION.
    IF P_ACCION = 'A' THEN
      FOR TL IN CUR_LINEAS LOOP
        FOR CC IN CUR_PROD_COMP(TL.CO_ID) LOOP
          IF CC.ACTION_ID = 501 THEN
            -- PROVISION DEL SERVICIO ADICIONAL
            SELECT TIM.RP_JANUS_ORD_ID.NEXTVAL@DBL_BSCS_BF
              INTO LN_ORDID
              FROM DUAL;
            INSERT INTO TIM.RP_PROV_BSCS_JANUS@DBL_BSCS_BF
              (ORD_ID,
               ACTION_ID,
               PRIORITY,
               CUSTOMER_ID,
               CO_ID,
               SNCODE,
               SPCODE,
               STATUS,
               FECHA_INSERT,
               ESTADO_PRV,
               VALORES)
            VALUES
              (LN_ORDID,
               501,
               5,
               P_CUSTOMER_ID,
               CC.CO_ID,
               CC.SNCODE,
               CC.SPCODE,
               'A',
               SYSDATE,
               '0',
               TL.DN_NUM || '|' || CC.TARIFF_ID || '|' || 100);
            P_ORDID := LN_ORDID;
          END IF;
        END LOOP;
      END LOOP;
    ELSIF P_ACCION = 'D' THEN
      FOR TL IN CUR_LINEAS LOOP
        FOR CC IN CUR_PROD_COMP(TL.CO_ID) LOOP
          IF CC.ACTION_ID = 501 THEN
            -- PROVISION DEL SERVICIO ADICIONAL
            SELECT TIM.RP_JANUS_ORD_ID.NEXTVAL@DBL_BSCS_BF
              INTO LN_ORDID
              FROM DUAL;
            INSERT INTO TIM.RP_PROV_BSCS_JANUS@DBL_BSCS_BF
              (ORD_ID,
               ACTION_ID,
               PRIORITY,
               CUSTOMER_ID,
               CO_ID,
               SNCODE,
               SPCODE,
               STATUS,
               FECHA_INSERT,
               ESTADO_PRV,
               VALORES)
            VALUES
              (LN_ORDID,
               501,
               5,
               P_CUSTOMER_ID,
               CC.CO_ID,
               CC.SNCODE,
               CC.SPCODE,
               'D',
               SYSDATE,
               '0',
               TL.DN_NUM || '|' || CC.TARIFF_ID || '|' || 100);
            P_ORDID := LN_ORDID;
          END IF;
        END LOOP;
      END LOOP;
    ELSE
      P_RESULTADO := -3;
      P_MSGERR    := 'TIPO DE ACCION NO SOPORTADA';
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      P_RESULTADO := -99;
      P_MSGERR    := 'ERROR ' || TO_CHAR(SQLCODE) || ' : ' || SQLERRM;
      P_REG_LOG(NULL,
                P_CUSTOMER_ID,
                NULL,
                P_CO_ID,
                NULL,
                P_RESULTADO,
                P_MSGERR,
                P_CO_ID,
                'SP_PROV_ADIC_JANUS');
  END SP_PROV_ADIC_JANUS;

  PROCEDURE P_ACT_DESACT_SERV_BSCS(A_IDTAREAWF IN NUMBER,
                                   A_IDWF      IN NUMBER,
                                   A_TAREA     IN NUMBER,
                                   A_TAREADEF  IN NUMBER) IS
    N_CODSOLOT    OPERACION.SOLOT.CODSOLOT%TYPE;
    N_COD_ID      OPERACION.SOLOT.COD_ID%TYPE;
    N_CUSTOMER_ID OPERACION.SOLOT.CUSTOMER_ID%TYPE;
    ERROR_GENERAL EXCEPTION;
    AN_ERROR NUMBER;
    AV_ERROR VARCHAR2(4000);

    --ini 2.0
    CURSOR C_DESACT IS
      SELECT T.COD_ID,
             T.SNCODE_ACTUAL,
             (SELECT PSH.SPCODE
                FROM PR_SERV_SPCODE_HIST@DBL_BSCS_BF PSH
               WHERE PSH.CO_ID = T.COD_ID
                 AND PSH.SNCODE = T.SNCODE_ACTUAL) SPCODE
        FROM SALES.MIGRA_UPGRADE_MASIVO T
       WHERE T.COD_ID = N_COD_ID
         AND T.Sncode_Actual IS not NULL;

    CURSOR C_ACT IS
      SELECT T.COD_ID, T.SNCODE_NEW, T.CF_NEW
        FROM SALES.MIGRA_UPGRADE_MASIVO T
       WHERE T.COD_ID = N_COD_ID
         AND T.CODSOLOT_UP = N_CODSOLOT
         AND T.FLG_FACTURAR = 0
         AND T.SNCODE_NEW IS NOT NULL;
    --fin 2.0
    A_SNCODE  TIM.PP017_SIAC_MIGRACIONES.ARR_SERVICIOS@DBL_BSCS_BF;
    A_SPCODE  TIM.PP017_SIAC_MIGRACIONES.ARR_SERVICIOS@DBL_BSCS_BF;
    V_RPT     NUMBER;
    V_RPT2    NUMBER;
    V_SPCODE  NUMBER;
    LN_TMCODE NUMBER;
  BEGIN
    null;
  EXCEPTION
    WHEN ERROR_GENERAL THEN
      P_REG_LOG(NULL,
                N_CUSTOMER_ID,
                NULL,
                N_CODSOLOT,
                NULL,
                AN_ERROR,
                AV_ERROR,
                N_COD_ID,
                'P_ACT_DESACT_SERV_BSCS');
    WHEN OTHERS THEN
      AN_ERROR := -1;
      AV_ERROR := SQLERRM || ' - LINEA : ' ||
                  DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      P_REG_LOG(NULL,
                N_CUSTOMER_ID,
                NULL,
                N_CODSOLOT,
                NULL,
                AN_ERROR,
                AV_ERROR,
                N_COD_ID,
                'P_ACT_DESACT_SERV_BSCS');
  END P_ACT_DESACT_SERV_BSCS;

  PROCEDURE P_ACT_DESACT_SERV_SGA(A_IDTAREAWF IN NUMBER,
                                  A_IDWF      IN NUMBER,
                                  A_TAREA     IN NUMBER,
                                  A_TAREADEF  IN NUMBER) IS
    N_CODSOLOT    NUMBER;
    N_COD_ID      NUMBER;
    LV_CODIGO_EXT CONFIGURACION_ITW.CODIGO_EXT%TYPE;
    --ini 2.0
    CURSOR C_SOT_DESACT IS
      SELECT T.PID_OLD
        FROM SALES.MIGRA_UPGRADE_MASIVO T
       WHERE T.COD_ID = N_COD_ID
         AND T.SNCODE_NEW IS NULL;
    CURSOR C_SOT_ACT IS
      SELECT T.PID_OLD,
             T.PID_NEW,
             T.CODSRV_OLD,
             T.CODSRV_NEW,
             SER.TIPSRV,
             T.TIPO_SERVICIO,
             T.TIPO_PRODUCTO
        FROM SALES.MIGRA_UPGRADE_MASIVO T, TYSTABSRV SER
       WHERE T.COD_ID = N_COD_ID
         AND T.CODSOLOT_UP = N_CODSOLOT
         AND T.CODSRV_NEW = SER.CODSRV
         AND T.FLG_FACTURAR = 1
         AND T.SNCODE_NEW IS NOT NULL;
    --fin 2.0
  BEGIN
    SELECT A.CODSOLOT, B.COD_ID
      INTO N_CODSOLOT, N_COD_ID
      FROM WF A, SOLOT B
     WHERE A.CODSOLOT = B.CODSOLOT
       AND A.IDWF = A_IDWF
       AND VALIDO = 1;
    --ini2.0
    FOR C IN C_SOT_DESACT LOOP
      UPDATE INSPRD P
         SET P.ESTINSPRD = 3, P.FECFIN = SYSDATE
       WHERE P.PID = C.PID_OLD;
    END LOOP;
    FOR C IN C_SOT_ACT LOOP
      UPDATE INSPRD P
         SET P.ESTINSPRD = 1, P.FECINI = SYSDATE
       WHERE P.PID = C.PID_NEW;
      IF C.TIPO_SERVICIO = 'CORE' THEN
        UPDATE INSSRV INS
           SET INS.CODSRV = C.CODSRV_NEW
         WHERE INS.CODSRV = C.CODSRV_OLD
           AND INS.CODINSSRV = (SELECT PID.CODINSSRV
                                  FROM INSPRD PID
                                 WHERE PID.PID = C.PID_NEW);
        IF C.TIPO_PRODUCTO = 'INTERNET' THEN
          --fin 2.0
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
          IF LV_CODIGO_EXT IS NOT NULL THEN
            UPDATE TIM.PF_HFC_DATOS_SERV@DBL_BSCS_BF T
               SET T.CAMPO01 = LV_CODIGO_EXT
             WHERE T.TIPO_SERV = 'INT'
               AND T.CO_ID = N_COD_ID;
          END IF;
        END IF;
        --ini 2.0
        IF C.TIPO_PRODUCTO = 'TELEFONIA' THEN
          BEGIN
            SELECT CI.CODIGO_EXT
              INTO LV_CODIGO_EXT
              FROM CONFIGURACION_ITW CI, SOLOTPTO SO, TYSTABSRV T
             WHERE SO.CODSRVNUE = T.CODSRV
               AND T.CODIGO_EXT = TO_CHAR(CI.IDCONFIGITW)
               AND CI.ESTADO = 1
               AND CI.TIPOSERVICIOITW = 1 --
               AND SO.CODSOLOT = N_CODSOLOT;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              LV_CODIGO_EXT := NULL;
          END;
          IF LV_CODIGO_EXT IS NOT NULL THEN
            UPDATE TIM.PF_HFC_DATOS_SERV@DBL_BSCS_BF T
               SET T.CAMPO01 = LV_CODIGO_EXT
             WHERE T.TIPO_SERV = 'TEP' --
               AND T.CO_ID = N_COD_ID;
          END IF;
        END IF;
        --fin 2.0
      END IF;

    END LOOP;


  END P_ACT_DESACT_SERV_SGA;

  PROCEDURE P_ACT_VTADETPTOENL(P_COD_ID SOLOT.COD_ID%TYPE) IS
    LV_TIPSRV       INSSRV.TIPSRV%TYPE;
    LN_CODSOLOT_MAX NUMBER;
    LV_NUMSLC       SOLOT.NUMSLC%TYPE;
    LR_VTDETPTO     VTADETPTOENL%ROWTYPE;
    LV_NUMPTO       VTADETPTOENL.NUMPTO%TYPE;
    CURSOR C_UPGRADE IS
      SELECT T.*
        FROM SALES.MIGRA_UPGRADE_MASIVO T, SOLOT S
       WHERE S.CODSOLOT = T.CODSOLOT_UP
         AND S.TIPTRA = 814
         AND T.COD_ID = P_COD_ID;

  BEGIN
    FOR C IN C_UPGRADE LOOP

      LN_CODSOLOT_MAX := OPERACION.PQ_SGA_IW.F_MAX_SOT_X_COD_ID(C.COD_ID);

      SELECT S.NUMSLC
        INTO LV_NUMSLC
        FROM SOLOT S
       WHERE S.CODSOLOT = LN_CODSOLOT_MAX;

      IF C.TIPO_PRODUCTO = 'TELEFONIA' THEN
        LV_TIPSRV := CN_TIPSV_TLF;
      ELSIF C.TIPO_PRODUCTO = 'INTERNET' THEN
        LV_TIPSRV := CN_TIPSV_INT;
      ELSIF C.TIPO_PRODUCTO = 'CABLE' THEN
        LV_TIPSRV := CN_TIPSV_CABLE;
      END IF;

      IF C.TIPO_SERVICIO = 'CORE' THEN
        UPDATE VTADETPTOENL DET
           SET DET.CODSRV = C.CODSRV_NEW
         WHERE DET.NUMSLC = LV_NUMSLC
           AND DET.CODSRV = C.CODSRV_OLD
           AND DET.FLGSRV_PRI = '1';
      END IF;

      IF C.TIPO_SERVICIO = 'ADICIONALES' AND C.SNCODE_NEW IS NOT NULL THEN
        -- Todo lo que activo se registra en la VTADETPTOENL
        SELECT *
          INTO LR_VTDETPTO
          FROM VTADETPTOENL V
         WHERE V.NUMSLC = LV_NUMSLC
           AND EXISTS (SELECT *
                  FROM TYSTABSRV SER
                 WHERE SER.CODSRV = V.CODSRV
                   AND SER.TIPSRV = LV_TIPSRV)
           AND ROWNUM = 1;

        SELECT LPAD(VALOR, 5, '0')
          INTO LV_NUMPTO
          FROM (SELECT MAX(NUMPTO) + 1 AS VALOR
                  FROM VTADETPTOENL
                 WHERE NUMSLC = LV_NUMSLC) X;

        SELECT DISTINCT SER.IDPRODUCTO, LP.IDDET
          INTO LR_VTDETPTO.IDPRODUCTO, LR_VTDETPTO.IDDET
          FROM TYSTABSRV SER, LINEA_PAQUETE LP, DETALLE_PAQUETE DP
         WHERE SER.CODSRV = LP.CODSRV
           AND DP.IDDET = LP.IDDET
           AND SER.CODSRV = C.CODSRV_NEW
           AND DP.IDPAQ = 4005
           AND ROWNUM = 1;

        LR_VTDETPTO.CODSRV     := C.CODSRV_NEW;
        LR_VTDETPTO.NUMPTO     := LV_NUMPTO;
        LR_VTDETPTO.FLGSRV_PRI := '0';

        INSERT INTO VTADETPTOENL VALUES LR_VTDETPTO;

      END IF;

      IF C.TIPO_SERVICIO = 'ADICIONALES' AND C.SNCODE_ACTUAL IS NOT NULL THEN
        -- Se elimina todo lo que el usuario envia en la base
        DELETE FROM VTADETPTOENL V
         WHERE V.NUMSLC = LV_NUMSLC
           AND V.CODSRV = C.CODSRV_OLD;
      END IF;
    END LOOP;
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000, $$PLSQL_UNIT || SQLERRM);
  END;

  PROCEDURE P_JOB_ATIENDE_SOT_UP IS
    LN_COD_REP       NUMBER;
    LS_MSJ_RESP      VARCHAR2(1000);
    V_FECHA          VARCHAR2(50);
    V_LENGTH         NUMBER;
    LN_SERVTELEFONIA NUMBER;
    CURSOR C_SOT_SVT IS
      SELECT S.CODSOLOT CPN_SOLOT, S.COD_ID, S.CUSTOMER_ID, S.CODCLI
        FROM OPERACION.SOLOT S
       WHERE S.TIPTRA = 814
         AND S.ESTSOL = 17
         AND S.COD_ID IS NOT NULL
         AND S.CUSTOMER_ID IS NOT NULL;
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
                 AND A.ABREV = 'CIERREAUTOUP') XX
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
              P_REG_LOG(C_SVT.CODCLI,
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
                  P_REG_LOG(C_SVT.CODCLI,
                            C_SVT.CUSTOMER_ID,
                            NULL,
                            C_SVT.CPN_SOLOT,
                            NULL,
                            LN_COD_REP,
                            LS_MSJ_RESP,
                            C_SVT.COD_ID,
                            'P_JOB_ATIENDE_SOT_UP');
                  GOTO SOT;
                END IF;

                P_REG_LOG(C_SVT.CODCLI,
                            C_SVT.CUSTOMER_ID,
                            NULL,
                            C_SVT.CPN_SOLOT,
                            NULL,
                            LN_COD_REP,
                            LS_MSJ_RESP,
                            C_SVT.COD_ID,
                            'P_JOB_ATIENDE_SOT_UP');

              EXCEPTION
                WHEN OTHERS THEN
                  LN_COD_REP  := -2020;
                  LS_MSJ_RESP := 'P_JOB_ATIENDE_SOT_UP :' || SQLERRM;
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
                                                  'P_JOB_ATIENDE_SOT_UP');
                  GOTO SOT;
              END;
              OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(C_TAREAS.IDTAREAWF,
                                               4,
                                               C_TAREAS.CODIGON_AUX,
                                               0,
                                               SYSDATE,
                                               SYSDATE);
            WHEN 'JANUS' THEN
              LN_SERVTELEFONIA := OPERACION.PQ_SGA_JANUS.F_VAL_SERV_TLF_SOT(C_SVT.CPN_SOLOT);
              IF LN_SERVTELEFONIA = 1 THEN
                -- Proceso de JANUS
                P_CAMBIO_JANUS(C_SVT.CPN_SOLOT);
                OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(C_TAREAS.IDTAREAWF,
                                                 4,
                                                 C_TAREAS.CODIGON_AUX,
                                                 0,
                                                 SYSDATE,
                                                 SYSDATE);
              ELSE
                OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(C_TAREAS.IDTAREAWF,
                                                 4,
                                                 8,
                                                 0,
                                                 SYSDATE,
                                                 SYSDATE);
              END IF;
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
          P_REG_LOG(C_SVT.CODCLI,
                    C_SVT.CUSTOMER_ID,
                    NULL,
                    C_SVT.CPN_SOLOT,
                    NULL,
                    LN_COD_REP,
                    LS_MSJ_RESP,
                    C_SVT.COD_ID,
                    'P_JOB_ATIENDE_SOT_UP');
      END;
    END LOOP;
  END;
 /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        28/05/2019  Luigi Sipion     Genera SOTs para la Desactivacion de Bonos
  ******************************************************************************/
  PROCEDURE P_JOB_GENERA_SOT_DESAC IS
    CURSOR C_PROCESA IS
      SELECT DISTINCT T.COD_ID
        FROM SALES.MIGRA_UPGRADE_MASIVO T
       WHERE T.FLG_PROCESA = 0
         AND T.CF_ACTUAL   = 1; --- IDENTIFICA DESACTIVACIONES
  BEGIN
    FOR C IN C_PROCESA LOOP
      BEGIN
        IF OPERACION.PQ_SGA_IW.F_VAL_STATUS_CONTRATO(C.COD_ID) = 4 THEN
          P_GENERA_TRANS_UPGRADE(C.COD_ID);
        END IF;
      EXCEPTION
        WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE('ERROR : ' || SQLERRM || ' CO_ID : ' ||
                               C.COD_ID || ' - Linea (' ||
                               DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ')');
      END;
    END LOOP;
  END;

END;
/
