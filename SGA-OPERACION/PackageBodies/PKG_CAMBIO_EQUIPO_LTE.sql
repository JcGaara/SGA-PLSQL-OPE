CREATE OR REPLACE PACKAGE BODY OPERACION.PKG_CAMBIO_EQUIPO_LTE IS
  /************************************************************************************************
  NOMBRE:     OPERACION.PKG_CAMBIO_EQUIPO_LTE
  PROPOSITO:  Proceso de Cambio de Equipo y Reposicion de Equipos LTE

  REVISIONES: 0908
   Version   Fecha          Autor            Solicitado por      Descripcion
   -------- ----------  ------------------   -----------------   ------------------------
   1.0      22/06/2018   Justiniano Condori/ Justiniano Condori   [IDEA-40758/PROY-32581-Postventa LTE/HFC] - [Cambio de Equipo LTE]
                         Jose Arriola
   2.0    13/08/2018     Jose Arriola        Justiniano Condori    Complemento/Mejoras de la version 1.0
   3.0    20/11/2018     Luis Flores         Luis Flores           Mejoras de la version 1.0
   4.0    06/12/2018     Luis Flores         Luis Flores           Mejoras de la version 1.0
   5.0    22/01/2019     Luis Flores         Luis Flores           IDEA-40758/PROY-32581-Postventa LTE/HFC] - [Cambio de Equipo LTE]
   6.0    03/02/2019     Luis Flores         Luis Flores           IDEA-40758/PROY-32581-Postventa LTE/HFC] - [Cambio de Equipo LTE]
   7.0    11/02/2019     Luis Flores         Luis Flores           IDEA-40758/PROY-32581-Postventa LTE/HFC] - [Cambio de Equipo LTE]
   8.0    07/03/2019     Luis Flores         Luis Flores           IDEA-40758/PROY-32581-Postventa LTE/HFC] - [Cambio de Equipo LTE]
   9.0    18/03/2019     Luis Flores         Luis Flores           IDEA-40758/PROY-32581-Postventa LTE/HFC] - [Cambio de Equipo LTE]
   10.0   29/03/2019     Luis Flores         Luis Flores           IDEA-40758/PROY-32581-Postventa LTE/HFC] - [Cambio de Equipo LTE]
  /************************************************************************************************/
  PROCEDURE SGASI_SOLOTPTO(PI_CODSOLOT IN NUMBER,
                           PI_CO_ID    IN NUMBER,
                           PO_COD      OUT NUMBER,
                           PO_MSJ      OUT VARCHAR2) IS
    V_NUMSLC   VARCHAR2(10);
    V_PUNTO    NUMBER;
    R_SOLOTPTO OPERACION.SOLOTPTO%ROWTYPE;
    R_INSSRV   OPERACION.INSSRV%ROWTYPE;
	AN_CODSOLOT solot.codsolot%type;
    CURSOR CUR_DETALLE IS
      SELECT I.CODINSSRV,
             I.CODSRV,
             I.BW,
             I.CID,
             I.DESCRIPCION,
             I.DIRECCION,
             I.CODUBI,
             I.CODPOSTAL
        FROM OPERACION.INSSRV I
       WHERE I.NUMSLC = V_NUMSLC;
  BEGIN

    PO_COD := 0;
    PO_MSJ := 'EXITO';

    BEGIN
	
	AN_CODSOLOT := OPERACION.PQ_SGA_IW.f_max_sot_x_cod_id(PI_CO_ID);
	
      SELECT NUMSLC 
        INTO V_NUMSLC
        FROM OPERACION.SOLOT
       WHERE CODSOLOT = AN_CODSOLOT;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        SELECT L.NUMSLC
          INTO V_NUMSLC
          FROM SALES.SOT_SIAC S, OPERACION.SOLOT L
         WHERE TRIM(S.COD_ID) = TRIM(PI_CO_ID)
           AND L.ESTSOL IN (29, 12)
           AND S.CODSOLOT = L.CODSOLOT;
    END;

    FOR R_CURSOR1 IN CUR_DETALLE LOOP
      IF R_CURSOR1.CODINSSRV IS NOT NULL THEN
        SELECT I.*
          INTO R_INSSRV
          FROM OPERACION.INSSRV I
         WHERE I.CODINSSRV = R_CURSOR1.CODINSSRV;
        R_SOLOTPTO.CODSOLOT    := PI_CODSOLOT;
        R_SOLOTPTO.PUNTO       := NULL;
        R_SOLOTPTO.TIPTRS      := NULL;
        R_SOLOTPTO.CODSRVNUE   := R_CURSOR1.CODSRV;
        R_SOLOTPTO.BWNUE       := R_INSSRV.BW;
        R_SOLOTPTO.CODINSSRV   := R_INSSRV.CODINSSRV;
        R_SOLOTPTO.CID         := R_INSSRV.CID;
        R_SOLOTPTO.DESCRIPCION := R_INSSRV.DESCRIPCION;
        R_SOLOTPTO.DIRECCION   := R_INSSRV.DIRECCION;
        R_SOLOTPTO.TIPO        := 2;
        R_SOLOTPTO.ESTADO      := 1;
        R_SOLOTPTO.VISIBLE     := 1;
        R_SOLOTPTO.CODUBI      := R_CURSOR1.CODUBI;
        R_SOLOTPTO.CANTIDAD    := 1;
        R_SOLOTPTO.CODPOSTAL   := R_INSSRV.CODPOSTAL;
        OPERACION.PQ_SOLOT.P_INSERT_SOLOTPTO(R_SOLOTPTO, V_PUNTO);
      END IF;
    END LOOP;

  EXCEPTION
    WHEN OTHERS THEN
      PO_COD := -1;
      PO_MSJ := 'SGASI_SOLOTPTO(P_COD_ID => ' || PI_CO_ID || ') ' ||
                SQLERRM || ')';
  END;

  FUNCTION SGAFUN_REG_SOT(PI_IDPROCESS    IN NUMBER,
                          PI_COD_ID       IN NUMBER,
                          PI_CUSTOMER_ID  IN NUMBER,
                          PI_TIPTRA       IN NUMBER,
                          PI_TIPPOSTVENTA IN VARCHAR2) RETURN NUMBER IS
    L_CODSOLOT NUMBER;
  BEGIN

    INSERT INTO OPERACION.SOLOT
      (TIPTRA,
       ESTSOL,
       TIPSRV,
       CODCLI,
       CODMOTOT,
       AREASOL,
       FECCOM,
       CUSTOMER_ID,
       COD_ID,
       OBSERVACION)-- 2.0
    VALUES
      (PI_TIPTRA,
       10,
       '0077',
       (SELECT S.CODCLI
          FROM SOLOT S
         WHERE S.CODSOLOT =
               OPERACION.PQ_DECO_ADICIONAL_LTE.F_MAX_SOT_X_COD_ID(PI_COD_ID)),
       (SELECT SPP.CODMOTOT
          FROM OPERACION.SIAC_POSTVENTA_PROCESO SPP
         WHERE SPP.IDPROCESS = PI_IDPROCESS),
       325,
       SYSDATE,
       PI_CUSTOMER_ID,
       PI_COD_ID,
       (SELECT SPP.OBSERVACION
          FROM OPERACION.SIAC_POSTVENTA_PROCESO SPP
         WHERE SPP.IDPROCESS = PI_IDPROCESS))--2.0
    returning CODSOLOT into L_CODSOLOT;

    OPERACION.PQ_SIAC_POSTVENTA.SET_SIAC_INSTANCIA(PI_IDPROCESS,
                                                   PI_TIPPOSTVENTA,
                                                   'SOT',
                                                   L_CODSOLOT);

    OPERACION.PQ_SIAC_POSTVENTA.SET_INT_NEGOCIO_INSTANCIA(PI_IDPROCESS,
                                                          'SOT',
                                                          L_CODSOLOT);

    RETURN L_CODSOLOT;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT ||
                              '.SGAFUN_REG_SOT(P_IDPROCESS => ' ||
                              PI_IDPROCESS || ', P_COD_ID => ' || PI_COD_ID || ') ' ||
                              SQLERRM);
  END;
  PROCEDURE SGAFUN_CAMB_EQU(PI_ID_PROCESS  IN NUMBER,
                            PI_TIPTRA      IN NUMBER,
                            PI_COD_ID      IN NUMBER,
                            PI_CUSTOMER_ID IN NUMBER,
                            PO_CODSOLOT    OUT NUMBER,
                            PO_COD         OUT NUMBER,
                            PO_MSJ         OUT VARCHAR2) IS
    C_TIPPOSTVENTA constant varchar2(50) := 'CAMBIO EQUIPO';
  BEGIN
    PO_COD := 0;
    PO_MSJ := 'EXITO';
    --GENERACION DE SOT
    PO_CODSOLOT := SGAFUN_REG_SOT(PI_ID_PROCESS,
                                  PI_COD_ID,
                                  PI_CUSTOMER_ID,
                                  PI_TIPTRA,
                                  C_TIPPOSTVENTA);
    --GENERACION DE SOLOTPTO
    SGASI_SOLOTPTO(PO_CODSOLOT, PI_COD_ID, PO_COD, PO_MSJ);
  EXCEPTION
    WHEN OTHERS THEN
      PO_COD := -99;
      PO_MSJ := 'ERROR: ' || SQLCODE || ' ' || SQLERRM || ' LINEA (' ||
                DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ')';
  END;

  PROCEDURE SGASI_REENVIO(PI_CODSOLOT IN OPERACION.SOLOT.CODSOLOT%TYPE,
                          PI_TIPO_OPE IN VARCHAR2,
                          PO_COD      OUT NUMBER,
                          PO_MSJ      OUT VARCHAR2) IS
    EX_ERROR EXCEPTION;
    V_COUNT       NUMBER;
    V_VAL_STATUS  NUMBER;
    V_CO_ID       NUMBER;
    V_COD         NUMBER;
    V_MSJ         VARCHAR2(4000);
    V_ACTION      NUMBER;

  BEGIN
    --TOMAR CO_ID Y CUSTOMER_ID
    SELECT S.COD_ID
      INTO V_CO_ID
      FROM OPERACION.SOLOT S
     WHERE S.CODSOLOT = PI_CODSOLOT;

    SELECT COUNT(1)
      INTO V_COUNT
      FROM OPERACION.PSGAT_ESTSERVICIO E
     WHERE E.ESSEN_COD_SOLOT = PI_CODSOLOT
       AND E.ESSEV_COD_OPERACION = PI_TIPO_OPE;

    IF V_COUNT = 0 THEN
      SGASI_ESTADO_PROV(PI_CODSOLOT, PI_TIPO_OPE, PO_COD, PO_MSJ);
      IF PO_COD <> 0 THEN
        RAISE EX_ERROR;
      END IF;
    END IF;

    IF PI_TIPO_OPE = C_TP_CONAX THEN
      V_COUNT := 0;
      FOR I IN (SELECT DISTINCT C.TRXV_SERIE_TARJETA NUM_SERIE, C.TRXN_ACTION_ID
                  FROM OPERACION.SGAT_TRXCONTEGO C
                 WHERE C.TRXN_CODSOLOT = PI_CODSOLOT
                UNION ALL
                SELECT DISTINCT C.TRXV_SERIE_TARJETA NUM_SERIE, C.TRXN_ACTION_ID
                  FROM OPERACION.SGAT_TRXCONTEGO_HIST C
                 WHERE C.TRXN_CODSOLOT = PI_CODSOLOT) LOOP
        SELECT CASE
                 WHEN I.TRXN_ACTION_ID IN (101, 103) THEN 0 ELSE 1
               END
          INTO V_ACTION
          FROM DUAL;

        IF SGAFUN_VALPROV_CONTEGO(PI_CODSOLOT, I.NUM_SERIE, V_ACTION) <> 0 THEN

        UPDATE OPERACION.SGAT_TRXCONTEGO A
        SET A.TRXC_ESTADO = C_EST_CONTEGO_INI,
            A.TRXV_MSJ_ERR = C_MSG_CANCELADO,
            A.TRXN_PRIORIDAD = OPERACION.PKG_CONTEGO.SGAFUN_PARAM_CONTEGO('CONF_CONTEGO_ACT','CONF_ACT','ALTA-CONTEGO','AU')
        WHERE A.TRXN_CODSOLOT = PI_CODSOLOT
        AND A.TRXV_SERIE_TARJETA = I.NUM_SERIE
        AND A.TRXC_ESTADO NOT IN (1,2);

        IF SQL%ROWCOUNT <> 0 THEN
            PO_COD := 0;
            PO_MSJ := 'CONTEGO: SE REENVIO A PROVISION';
            SGASU_SERV_X_CLIENTE(PI_CODSOLOT, C_TP_CONAX, PO_MSJ, 'RPRO', V_COD, V_MSJ);
        ELSE
            PO_MSJ := 'CONTEGO: SE ENCUENTRA EN PROCESO DE PROVISION';
            PO_COD := 0;
            SGASU_SERV_X_CLIENTE(PI_CODSOLOT, C_TP_CONAX, PO_MSJ, 'RPRO', V_COD, V_MSJ);
        END IF;

        ELSE
          PO_COD := 0;
          PO_MSJ := 'CONTEGO PROVISIONADO CORRECTAMENTE';
          SGASU_SERV_X_CLIENTE(PI_CODSOLOT, C_TP_CONAX, PO_MSJ, 'PROV', V_COD, V_MSJ);
        END IF;
        V_COUNT := V_COUNT +1 ;
      END LOOP;

      IF V_COUNT = 0 THEN
        PO_COD := -1;
        PO_MSJ := 'CONTEGO: NO EXISTE REGISTRO EN TABLA PROVISION';
        SGASU_SERV_X_CLIENTE(PI_CODSOLOT, C_TP_CONAX, PO_MSJ, 'ERRO', V_COD, V_MSJ);
        RETURN;
      ELSE
        PO_COD := 0;
        PO_MSJ := 'CONTEGO: SE REENVIO A PROVISION';
        RETURN;
      END IF;

    ELSIF PI_TIPO_OPE = C_TP_PASSW THEN
      V_VAL_STATUS := SGAFUN_VALIDA_PROVLTE(PI_CODSOLOT, 12);
      IF V_VAL_STATUS IN (7, 100) THEN
        PO_COD := 0;
        PO_MSJ := 'CAMBIO DE PASSWORD PROVISIONADO CORRECTAMENTE';
        SGASU_SERV_X_CLIENTE(PI_CODSOLOT, C_TP_PASSW, PO_MSJ, 'PROV', V_COD, V_MSJ);
        RETURN;
      ELSIF V_VAL_STATUS IN (2) THEN
        PO_COD := 0;
        PO_MSJ := 'EL CAMBIO DE PASSWORD SE ENCUENTRA EN PROCESO DE PROVISION';
        SGASU_SERV_X_CLIENTE(PI_CODSOLOT,C_TP_PASSW,PO_MSJ,'EPLA',V_COD,V_MSJ);
        RETURN;
      ELSE
        UPDATE TIM.LTE_CONTROL_PROV@DBL_BSCS_BF L
           SET L.STATUS = 2
         WHERE L.CO_ID = V_CO_ID
           AND L.SOT = PI_CODSOLOT
           AND L.ACTION_ID = 12;

       IF SQL%ROWCOUNT = 0 THEN
            PO_COD := -1;
            PO_MSJ := 'CAMBIO DE PASSWORD: NO EXISTE REGISTRO EN TABLA PROVISION';
            SGASU_SERV_X_CLIENTE(PI_CODSOLOT, C_TP_PASSW, PO_MSJ, 'ERRO', V_COD, V_MSJ);
            RETURN;
        END IF;

        PO_COD := 0;
        PO_MSJ := 'SE VOLVIO A ENVIAR PROVISION PARA CAMBIO DE PASSWORD';
        SGASU_SERV_X_CLIENTE(PI_CODSOLOT,C_TP_PASSW,PO_MSJ,'RPRO',V_COD,V_MSJ);
        RETURN;
      END IF;
    ELSIF PI_TIPO_OPE = C_TP_CHIP THEN
      V_VAL_STATUS := SGAFUN_VALIDA_PROVLTE(PI_CODSOLOT, 7);
      IF V_VAL_STATUS IN (7, 100) THEN
        PO_COD := 0;
        PO_MSJ := 'CAMBIO DE CHIP PROVISIONADO CORRECTAMENTE';
        SGASU_SERV_X_CLIENTE(PI_CODSOLOT,C_TP_CHIP,PO_MSJ,'PROV',V_COD,V_MSJ);
        RETURN;
      ELSIF V_VAL_STATUS IN (2) THEN
        PO_COD := 0;
        PO_MSJ := 'EL CAMBIO DE CHIP SE ENCUENTRA EN PROCESO DE PROVISION';
        SGASU_SERV_X_CLIENTE(PI_CODSOLOT,C_TP_CHIP,PO_MSJ,'EPLA',V_COD,V_MSJ);
        RETURN;
      ELSE
        UPDATE TIM.LTE_CONTROL_PROV@DBL_BSCS_BF L
           SET L.STATUS = 2
         WHERE L.CO_ID = V_CO_ID
           AND L.SOT = PI_CODSOLOT
           AND L.ACTION_ID = 7;

       IF SQL%ROWCOUNT = 0 THEN
            PO_COD := -1;
            PO_MSJ := 'CAMBIO DE CHIP: NO EXISTE REGISTRO EN TABLA PROVISION';
            SGASU_SERV_X_CLIENTE(PI_CODSOLOT, C_TP_CHIP, PO_MSJ, 'ERRO', V_COD, V_MSJ);
            RETURN;
        END IF;

        PO_COD := 0;
        PO_MSJ := 'SE VOLVIO A ENVIAR PROVISION PARA CAMBIO DE CHIP';
        SGASU_SERV_X_CLIENTE(PI_CODSOLOT,C_TP_CHIP,PO_MSJ,'RPRO',V_COD,V_MSJ);
        RETURN;
      END IF;
    END IF;
  EXCEPTION
    WHEN EX_ERROR THEN
      PO_COD := -1;
    WHEN OTHERS THEN
      PO_COD := -1;
      PO_MSJ :=  SQLCODE || ' ' || SQLERRM;
  END;

  PROCEDURE SGASI_ESTADO_PROV(PI_CODSOLOT IN OPERACION.SOLOT.CODSOLOT%TYPE,
                              PI_TIPO_OPE IN VARCHAR2,
                              PO_COD      OUT NUMBER,
                              PO_MSJ      OUT VARCHAR2) IS
    EX_ERROR EXCEPTION;
    V_CUSTOMER_ID OPERACION.SOLOT.CUSTOMER_ID%TYPE;
    V_CO_ID       OPERACION.SOLOT.COD_ID%TYPE;
    V_CODCLI      OPERACION.SOLOT.CODCLI%TYPE;
    V_DESC_TIPO   VARCHAR2(50);
    V_DESCRIP     OPERACION.OPEDD.DESCRIPCION%TYPE;
    ln_tiempo_act number;
    ln_tiempo_ree number;
    ln_numero_ree number;
  BEGIN
   PO_COD := 0;--2.0
   PO_MSJ := 'OK';

    BEGIN
      CASE
        WHEN PI_TIPO_OPE = C_TP_CONAX THEN
          V_DESC_TIPO := 'CONAX';
        WHEN PI_TIPO_OPE = C_TP_PASSW THEN
          V_DESC_TIPO := 'CAMBIO DE PASSWORD';
        WHEN PI_TIPO_OPE = C_TP_CHIP THEN
          V_DESC_TIPO := 'CAMBIO DE CHIP';
      END CASE;
    EXCEPTION
      WHEN CASE_NOT_FOUND THEN
        PO_MSJ := PI_TIPO_OPE || ' ES UN TIPO DE OPERACION INVALIDO';
        RAISE EX_ERROR;
    END;

    operacion.pq_3play_inalambrico.sgass_parametros('CONFG_TIP_PROV',
                                                    ln_tiempo_act,
                                                    ln_tiempo_ree,
                                                    ln_numero_ree,
                                                    PO_COD,
                                                    PO_MSJ);
    IF PO_COD = -1 THEN
      RAISE EX_ERROR;
    END IF;

    BEGIN
      SELECT S.CUSTOMER_ID, S.COD_ID, S.CODCLI
        INTO V_CUSTOMER_ID, V_CO_ID, V_CODCLI
        FROM OPERACION.SOLOT S
       WHERE S.CODSOLOT = PI_CODSOLOT;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        PO_MSJ := 'NO EXISTE LA SOT';
        RAISE EX_ERROR;
    END;
    IF V_CUSTOMER_ID IS NULL THEN
      PO_MSJ := 'NO EXISTE DATOS DE LA CUSTOMER ID';
      RAISE EX_ERROR;
    END IF;

    IF V_CO_ID IS NULL THEN
      PO_MSJ := 'NO EXISTE DATOS DE LA COD ID';
      RAISE EX_ERROR;
    END IF;

    IF V_CODCLI IS NULL THEN
      PO_MSJ := 'NO EXISTE DATOS DE LA COD. CLIENTE';
      RAISE EX_ERROR;
    END IF;

    BEGIN
      SELECT B.DESCRIPCION
        INTO V_DESCRIP
        FROM TIPOPEDD A, OPEDD B
       WHERE A.TIPOPEDD = B.TIPOPEDD
         AND A.ABREV = 'EST_GEST_PROV'
         AND B.ABREVIACION = 'NPRV';
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        PO_MSJ := 'NO EXISTE EL ESTADO EN LA TABLA DE PARAMETROS';
        RAISE EX_ERROR;
    END;

    INSERT INTO OPERACION.PSGAT_ESTSERVICIO
      (ESSEV_COD_OPERACION,
       ESSEN_COD_SOLOT,
       ESSEV_CUSTOMER_ID,
       ESSEN_CO_ID,
       ESSEN_COD_CLI,
       ESSEV_MENSAJE,
       ESSEV_DESCRIPCION,
       ESSEV_OPERACION,
       ESSEV_ESTADO,
       ESSEN_N_REENVIO,
       ESSEN_N_REENVIO_MAX)
    VALUES
      (PI_TIPO_OPE,
       PI_CODSOLOT,
       V_CUSTOMER_ID,
       V_CO_ID,
       V_CODCLI,
       NULL,
       'PROCESO DE ' || V_DESC_TIPO,
       V_DESCRIP,
       'NPRV',
       0,
       ln_numero_ree);
  EXCEPTION
    WHEN EX_ERROR THEN
      PO_COD := -1;
    WHEN OTHERS THEN
      PO_COD := -1;
      PO_MSJ := SQLCODE || ' ' || SQLERRM || ' ' ||
                DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
  END;

  PROCEDURE SGASI_ACTIVACION(PI_IDTAREAWF IN NUMBER,
                             PI_IDWF      IN NUMBER,
                             PI_TAREA     IN NUMBER,
                             PI_TAREADEF  IN NUMBER) IS

    V_CODSOLOT      NUMBER;
    V_CO_ID         NUMBER;
    V_CODCLI        VARCHAR2(10);
    V_TIP_DOCU      VARCHAR2(20);
    V_NRO_DOCU      VARCHAR2(20);
    V_CODUSU        VARCHAR2(50);
    V_NRO_TLF       VARCHAR2(50);
    V_CUSTOMER_ID   NUMBER;
    V_VAL_CHIP      NUMBER;
    V_VAL_PWD       NUMBER;
    V_IP            VARCHAR2(50);
    V_IDINTERACCION VARCHAR2(50);
    V_ICCID_NEW     VARCHAR2(20);
    V_ICCID_OLD     VARCHAR2(20);
    V_REQUEST_LTE   NUMBER;
    V_REQUEST_PADRE NUMBER;
    V_CD_SEQNO      NUMBER;
    V_COD_LOG       NUMBER;
    V_MSJ_LOG       VARCHAR2(4000);
    V_COD           NUMBER;
    V_MSJ           VARCHAR2(4000);
    V_MSJ2          VARCHAR2(4000);
    EX_ERROR EXCEPTION;
    V_DESC_ERROR  VARCHAR2(200);
    V_COD_ERROR   VARCHAR2(5);
    ln_cant_dig_chip number; --5.0
    V_CODSOLOT_MAX   SOLOT.CODSOLOT%TYPE;  --4.0
    --Ini 5.0
    LV_ACCION        VARCHAR2(100);
    V_RES_ERROR      VARCHAR2(500);
    LN_IDDET_DECO    OPERACION.TABEQUIPO_MATERIAL.IDEQUIPO%TYPE;
    LV_DECO          OPERACION.TABEQUIPO_MATERIAL.NUMERO_SERIE%TYPE;
    LN_IDDET_TARJETA OPERACION.TABEQUIPO_MATERIAL.IDEQUIPO%TYPE;
    LV_TARJETA       OPERACION.TABEQUIPO_MATERIAL.NUMERO_SERIE%TYPE;
    LN_VAL_ASOC      NUMBER;
    V_CONTEGO        OPERACION.SGAT_TRXCONTEGO%ROWTYPE;
    V_BOUQUET        VARCHAR2(10000);
    V_MSJ_ERROR      VARCHAR2(2000);
    LN_VAL_CE_DECO   NUMBER;

    CURSOR C_BAJA_DECO(LN_ASOC NUMBER) IS
      SELECT SE.CODSOLOT, SE.NUM_SERIE NUMSERIE, SE.FLAG_ACCION, SE.ASOC
        FROM SALES.SISACT_POSTVENTA_DET_SERV_LTE SE,
             OPERACION.TABEQUIPO_MATERIAL TM,
             TIPEQU TE,
             (SELECT A.CODIGON TIPEQU, CODIGOC GRUPO
                FROM OPEDD A, TIPOPEDD B
               WHERE A.TIPOPEDD = B.TIPOPEDD
                 AND B.ABREV IN ('TIPEQU_DTH_CONAX')) EQU_CONAX
       WHERE SE.CODSOLOT = V_CODSOLOT
         AND SE.NUM_SERIE = TM.NUMERO_SERIE
         AND TE.TIPEQU = SE.TIPEQU
         AND TRIM(EQU_CONAX.GRUPO) = '1'
         AND TE.TIPEQU = EQU_CONAX.TIPEQU
         AND SE.FLAG_ACCION = C_BAJA
         AND SE.ASOC = LN_ASOC;

    CURSOR C_EQUIPO_ALTA(LN_ASOC NUMBER) IS
      SELECT DISTINCT SE.CODSOLOT, --8.0
             SE.NUM_SERIE NUMSERIE,
             T.NRO_SERIE_DECO,
             T.NRO_SERIE_TARJETA
        FROM SALES.SISACT_POSTVENTA_DET_SERV_LTE SE,
             OPERACION.TABEQUIPO_MATERIAL TM,
             TIPEQU TE,
             OPERACION.TARJETA_DECO_ASOC T,
             (SELECT A.CODIGON TIPEQU, CODIGOC GRUPO
                FROM OPEDD A, TIPOPEDD B
               WHERE A.TIPOPEDD = B.TIPOPEDD
                 AND B.ABREV IN ('TIPEQU_DTH_CONAX')) EQU_CONAX
       WHERE SE.CODSOLOT = V_CODSOLOT
         AND SE.NUM_SERIE = TM.NUMERO_SERIE
         AND TE.TIPEQU = SE.TIPEQU
         AND TRIM(EQU_CONAX.GRUPO) = '2'
         AND T.CODSOLOT = SE.CODSOLOT --10.0
         AND TE.TIPEQU = EQU_CONAX.TIPEQU
         AND TM.IMEI_ESN_UA = T.NRO_SERIE_DECO
         AND SE.FLAG_ACCION IN (C_ALTA, C_CA) --8.0
         AND SE.ASOC = LN_ASOC;

    CURSOR C_ASOC(LN_ASOC NUMBER) IS
      SELECT S.CODSOLOT,
             S.TIPEQU,
             S.FLAG_ACCION,
             S.NUM_SERIE,
             S.ASOC,
             TM.TIPO,
             TM.IMEI_ESN_UA MAC,
             TM.IDEQUIPO    IDDET
        FROM SALES.SISACT_POSTVENTA_DET_SERV_LTE S,
             OPERACION.TABEQUIPO_MATERIAL        TM
       WHERE S.CODSOLOT = V_CODSOLOT
         AND S.NUM_SERIE = TM.NUMERO_SERIE
         AND S.FLAG_ACCION IN (C_ALTA, C_CA)
         AND S.ASOC = LN_ASOC;

    CURSOR C_ACCION IS
      SELECT X.*,
             (SELECT COUNT(DISTINCT TT.NUM_SERIE)
                FROM TIPEQU TE, SALES.SISACT_POSTVENTA_DET_SERV_LTE TT
               WHERE TE.TIPEQU = TT.TIPEQU
                 AND TT.CODSOLOT = X.CODSOLOT
                 AND TE.TIPO = 'DECODIFICADOR'
                 AND TT.FLAG_ACCION = C_ALTA
                 AND TT.ASOC = X.ASOC) FLG_ACTIVA_DECO,
             (SELECT COUNT(DISTINCT TT.NUM_SERIE)
                FROM TIPEQU TE, SALES.SISACT_POSTVENTA_DET_SERV_LTE TT
               WHERE TE.TIPEQU = TT.TIPEQU
                 AND TT.CODSOLOT = X.CODSOLOT
                 AND TE.TIPO = 'DECODIFICADOR'
                 AND TT.FLAG_ACCION = C_BAJA
                 AND TT.ASOC = X.ASOC) FLG_BAJA_DECO,
             (SELECT COUNT(DISTINCT TT.NUM_SERIE)
                FROM TIPEQU TE, SALES.SISACT_POSTVENTA_DET_SERV_LTE TT
               WHERE TE.TIPEQU = TT.TIPEQU
                 AND TT.CODSOLOT = X.CODSOLOT
                 AND TE.TIPO = 'DECODIFICADOR'
                 AND TT.FLAG_ACCION = C_CA
                 AND TT.ASOC = X.ASOC) FLG_CA_DECO,
             (SELECT COUNT(DISTINCT TT.NUM_SERIE)
                FROM TIPEQU TE, SALES.SISACT_POSTVENTA_DET_SERV_LTE TT
               WHERE TE.TIPEQU = TT.TIPEQU
                 AND TT.CODSOLOT = X.CODSOLOT
                 AND TE.TIPO = 'SMART CARD'
                 AND TT.FLAG_ACCION = C_ALTA
                 AND TT.ASOC = X.ASOC) FLG_ACTIVA_TARJETA,
             (SELECT COUNT(DISTINCT TT.NUM_SERIE)
                FROM TIPEQU TE, SALES.SISACT_POSTVENTA_DET_SERV_LTE TT
               WHERE TE.TIPEQU = TT.TIPEQU
                 AND TT.CODSOLOT = X.CODSOLOT
                 AND TE.TIPO = 'SMART CARD'
                 AND TT.FLAG_ACCION = C_BAJA
                 AND TT.ASOC = X.ASOC) FLG_BAJA_TARJETA,
             (SELECT COUNT(DISTINCT TT.NUM_SERIE)
                FROM TIPEQU TE, SALES.SISACT_POSTVENTA_DET_SERV_LTE TT
               WHERE TE.TIPEQU = TT.TIPEQU
                 AND TT.CODSOLOT = X.CODSOLOT
                 AND TE.TIPO = 'SMART CARD'
                 AND TT.FLAG_ACCION = C_CA
                 AND TT.ASOC = X.ASOC) FLG_CA_TARJETA
        FROM (SELECT DISTINCT T.IDINTERACCION, S.CODSOLOT, T.ASOC
                FROM SALES.SISACT_POSTVENTA_DET_SERV_LTE T, SOLOT S
               WHERE S.CODSOLOT = T.CODSOLOT
                 AND T.CODSOLOT = V_CODSOLOT) X;

   --Fin 5.0

  BEGIN
    V_ICCID_NEW := null;

    --CONSULTA DE SOT
    SELECT W.CODSOLOT, S.COD_ID, S.CUSTOMER_ID, S.CODUSU, S.CODCLI, VTC.NTDIDE,
             (SELECT VTD.DESCINT
                FROM MARKETING.VTATIPDID VTD
               WHERE VTD.TIPDIDE = VTC.TIPDIDE), OPERACION.PQ_SGA_IW.f_max_sot_x_cod_id(S.COD_ID) --4.0
      INTO V_CODSOLOT, V_CO_ID, V_CUSTOMER_ID, V_CODUSU, V_CODCLI, V_NRO_DOCU, V_TIP_DOCU, V_CODSOLOT_MAX --4.0
      FROM OPEWF.WF W, OPERACION.SOLOT S, MARKETING.VTATABCLI VTC
     WHERE W.IDWF = PI_IDWF
       AND W.CODSOLOT = S.CODSOLOT
       AND VTC.CODCLI = S.CODCLI
       AND W.VALIDO = 1;

    --TOMANDO IDINTERACCION
    select DISTINCT SPP.IDINTERACCION
      INTO V_IDINTERACCION
      from OPERACION.SIAC_POSTVENTA_PROCESO SPP
     WHERE SPP.CODSOLOT = V_CODSOLOT;

    --VALIDANDO CAMBIO DE CHIP
    SELECT COUNT(1)
      INTO V_VAL_CHIP
      FROM SALES.SISACT_POSTVENTA_DET_SERV_LTE SPD,
           OPERACION.TABEQUIPO_MATERIAL        TM
     WHERE SPD.IDINTERACCION = V_IDINTERACCION
       AND SPD.NUM_SERIE = TM.NUMERO_SERIE
       AND TM.TIPO = 3
       AND SPD.FLAG_ACCION = C_ALTA;

    ln_cant_dig_chip := OPERACION.PQ_SGA_JANUS.F_GET_CONSTANTE_CONF('CANDIGCHIPLTE');

    --ENVIANDO EL CAMBIO DE CHIP
    IF V_VAL_CHIP > 0 THEN
      --BUSCANDO EL NUEVO ICCID
      SELECT SPD.NUM_SERIE
        INTO V_ICCID_NEW
        FROM SALES.SISACT_POSTVENTA_DET_SERV_LTE SPD
       WHERE SPD.IDINTERACCION = V_IDINTERACCION
         AND SPD.TIPEQU = 16308
         AND SPD.FLAG_ACCION = C_ALTA;

      --BUSCANDO EL ANTIGUO ICCID
      SELECT SPD.NUM_SERIE
        INTO V_ICCID_OLD
        FROM SALES.SISACT_POSTVENTA_DET_SERV_LTE SPD
       WHERE SPD.IDINTERACCION = V_IDINTERACCION
         AND SPD.TIPEQU = 16308
         AND SPD.FLAG_ACCION = C_BAJA;

      --BUSCANDO EL IP
      V_IP := SYS_CONTEXT('USERENV', 'IP_ADDRESS');
      --BUSCANDO NRO TELEFONO
      V_NRO_TLF:=tim.tfun051_get_dnnum_from_coid@dbl_bscs_bf(V_CO_ID);

      --CAMBIO DE CHIP EN BSCS
      TIM.PP021_VENTA_LTE.BSCSSU_ACT_CAMBIO_IMSI@DBL_BSCS_BF(V_CO_ID, --IN
                                                             trim(lpad(V_ICCID_NEW,ln_cant_dig_chip)),--IN
                                                             V_CODSOLOT, --IN
                                                             V_REQUEST_LTE, --OUT
                                                             V_CD_SEQNO, --OUT
                                                             V_COD, --OUT
                                                             V_MSJ); --OUT

       OPERACION.PQ_3PLAY_INALAMBRICO.P_LOG_3PLAYI(V_CODSOLOT, 'BSCSSU_ACT_CAMBIO_IMSI',
                                                      'Ejecutando proceso : ' || V_MSJ || ' - Codigo : '|| V_COD,
                                                      'OPERACION.PKG_CAMBIO_EQUIPO_LTE.SGASI_ACTIVACION',
                                                      V_COD_LOG,
                                                      V_MSJ_LOG);
      IF V_COD <> 0 THEN
        V_DESC_ERROR := V_MSJ;
        RAISE EX_ERROR;
      END IF;

      --EJECUTANDO EL CAMBIO DE IMSI EN JANUS
      TIM.PP021_VENTA_LTE.BSCSSI_INS_JANUS_CAMBIO_IMSI@DBL_BSCS_BF(V_REQUEST_LTE,
                                                                   V_COD,
                                                                   V_MSJ);

      OPERACION.PQ_3PLAY_INALAMBRICO.P_LOG_3PLAYI(V_CODSOLOT, 'BSCSSI_INS_JANUS_CAMBIO_IMSI',
                                                      'Ejecutando proceso : ' || V_MSJ || ' - Codigo : '|| V_COD,
                                                      'OPERACION.PKG_CAMBIO_EQUIPO_LTE.SGASI_ACTIVACION',
                                                      V_COD_LOG,
                                                      V_MSJ_LOG);
      IF V_COD <> 0 THEN
        V_DESC_ERROR := V_MSJ;
        RAISE EX_ERROR;
      END IF;

      BEGIN
        --ENVIANDO INFORMACION A COBSDB
        USRSIAC.PCK_CHIPREPUESTO.SP_REGISTRO_CAMBIO_CHIP_LTE@DBL_COBSDB(V_IDINTERACCION,
                                                                        V_IP,
                                                                        'USRSGA',
                                                                        V_CODUSU,
                                                                        V_TIP_DOCU,
                                                                        V_NRO_DOCU,
                                                                        V_NRO_TLF,
                                                                        V_CUSTOMER_ID,
                                                                        V_CO_ID,
                                                                        V_ICCID_OLD,
                                                                        V_ICCID_NEW,
                                                                        V_CODSOLOT,
                                                                        1, --ESTADO_ENVIO_COBRO_SGA
                                                                        0, --COBRO --IN
                                                                        V_MSJ, --RESULTADO DEL REGISTRO DE BSCS
                                                                        V_CD_SEQNO, --IN
                                                                        V_REQUEST_LTE, --IN
                                                                        V_COD, --OUT
                                                                        V_MSJ2); --OUT
      EXCEPTION
        WHEN OTHERS THEN
          OPERACION.PQ_3PLAY_INALAMBRICO.P_LOG_3PLAYI(V_CODSOLOT, 'SGASI_ACTIVACION',  --4.0
                                                      ('>> Cerrar SOT: Error durante la Ejecucion del SP' ||
                                                      chr(13) || '   Codigo Error: ' || to_char(sqlcode) || chr(13) ||
                                                      '   Mensaje Error: ' || to_char(sqlerrm) || chr(13) ||
                                                      '   Mensaje de Error Proc: ' || V_MSJ2 || chr(13) ||
                                                      '   Linea Error: ' || dbms_utility.format_error_backtrace),
                                                      'OPERACION.PKG_CAMBIO_EQUIPO_LTE.SGASI_ACTIVACION -1',
                                                      V_COD_LOG,
                                                      V_MSJ_LOG);
      END;

    SGASI_ESTADO_PROV(V_CODSOLOT, C_TP_CHIP, V_COD_ERROR, V_DESC_ERROR);--2.0

      IF V_COD <> 0 THEN
         V_DESC_ERROR := V_MSJ2;
         SGASU_SERV_X_CLIENTE(V_CODSOLOT, C_TP_CHIP, V_MSJ2, 'NPRV', V_COD, V_MSJ);--2.0
         V_DESC_ERROR := V_DESC_ERROR || ' - NPRV - ' ||V_MSJ;
         RAISE EX_ERROR;
      ELSE --2.0
          SGASU_SERV_X_CLIENTE(V_CODSOLOT, C_TP_CHIP, C_MSG_PROCESANDO, 'PROC', V_COD_ERROR, V_DESC_ERROR);
          V_DESC_ERROR := V_MSJ;
      END IF;
    END IF;

    --VALIDANDO CAMBIO DE PWD
    SELECT COUNT(1)
      INTO V_VAL_PWD
      FROM SALES.SISACT_POSTVENTA_DET_SERV_LTE SPD,
           OPERACION.TABEQUIPO_MATERIAL        TM
     WHERE SPD.IDINTERACCION = V_IDINTERACCION
       AND SPD.NUM_SERIE = TM.NUMERO_SERIE
       AND TM.TIPO = 4
       AND SPD.FLAG_ACCION = C_ALTA;

    IF V_VAL_PWD > 0 THEN
      --CAMBIO DE PWD
      V_REQUEST_PADRE := V_REQUEST_LTE;

      --4.0 Ini
      BEGIN
        select distinct equ.numserie
               into V_ICCID_OLD
          from solotptoequ                  equ,
               solot                        sl,
               operacion.tabequipo_material tm
         where sl.codsolot = equ.codsolot
           and equ.numserie = tm.numero_serie
           and sl.cod_id = v_co_id
           and sl.estsol in (12, 29)
           and tm.tipo = 3
           and equ.estado in (4, 15)
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

      EXCEPTION
        WHEN OTHERS THEN
          V_ICCID_OLD := NULL;
      END;

      IF V_ICCID_OLD IS NOT NULL THEN

        if NVL(V_ICCID_NEW, 'X') != 'X' THEN
          V_ICCID_OLD := V_ICCID_NEW;
        END IF;

      --4.0 Fin
      SGASI_CAMBIO_PWD(V_CO_ID,
                       trim(lpad(V_ICCID_OLD,ln_cant_dig_chip)),
                       trim(lpad(V_ICCID_NEW,ln_cant_dig_chip)),
                       V_CODSOLOT,
                       V_REQUEST_LTE, --out
                       V_REQUEST_PADRE, --out
                       V_COD, --out
                       V_MSJ); --out

        OPERACION.PQ_3PLAY_INALAMBRICO.P_LOG_3PLAYI(V_CODSOLOT, 'SGASI_CAMBIO_PWD',  --4.0
                                                      'Ejecutando proceso : ' || V_MSJ || ' - Codigo : '|| V_COD,
                                                      'OPERACION.PKG_CAMBIO_EQUIPO_LTE.SGASI_ACTIVACION',
                                                      V_COD_LOG,
                                                      V_MSJ_LOG);

      SGASI_ESTADO_PROV(V_CODSOLOT, C_TP_PASSW, V_COD_ERROR, V_DESC_ERROR);--2.0

      IF V_COD <> 0 THEN
         V_DESC_ERROR := V_MSJ;
         SGASU_SERV_X_CLIENTE(V_CODSOLOT, C_TP_PASSW, V_MSJ2, 'NPRV', V_COD, V_MSJ);
         V_DESC_ERROR := V_DESC_ERROR || ' - NPRV - ' || V_MSJ;
         RAISE EX_ERROR;
      ELSE--2.0
        SGASU_SERV_X_CLIENTE(V_CODSOLOT, C_TP_PASSW, C_MSG_PROCESANDO, 'PROC', V_COD_ERROR, V_DESC_ERROR);
        V_DESC_ERROR := V_MSJ;
      END IF;

      --Actualizamos temporalmente
      OPERACION.PKG_CAMBIO_EQUIPO_LTE.SGASU_UPDATE_PREACTIVA(V_CO_ID,'ACTIVACION',V_COD_ERROR, V_DESC_ERROR);

      END IF;  --4.0

    END IF;

    /*Verificamos si el registro tiene una asociacion en la tabla
    SALES.SISACT_POSTVENTA_DET_SERV_LTE, y si la tiene actualizamos la
    tabla OPERACION.TARJETA_DECO_ASOC */
    SELECT COUNT(te.tipo)
      INTO LN_VAL_CE_DECO
    FROM TIPEQU TE,
         SALES.SISACT_POSTVENTA_DET_SERV_LTE TT,
         (SELECT A.CODIGON TIPEQU, TO_NUMBER(CODIGOC) GRUPO
            FROM OPEDD A, TIPOPEDD B
           WHERE A.TIPOPEDD = B.TIPOPEDD
             AND B.ABREV IN ('TIPEQU_DTH_CONAX')) EQU_CONAX --7.0
   WHERE TE.TIPEQU = TT.TIPEQU
     AND TE.TIPEQU = EQU_CONAX.TIPEQU
     AND TT.CODSOLOT = V_CODSOLOT;

    --Ini 5.0
    IF LN_VAL_CE_DECO > 0 THEN

      OPERACION.PQ_3PLAY_INALAMBRICO.P_LOG_3PLAYI(V_CODSOLOT, 'Proceso de Cambio DTH',
                                                      'Iniciando Proceso',
                                                      'OPERACION.PKG_CAMBIO_EQUIPO_LTE.SGASI_ACTIVACION',
                                                      V_COD_LOG,
                                                      V_MSJ_LOG);

      SGASI_ESTADO_PROV(V_CODSOLOT, C_TP_CONAX, V_COD_ERROR, V_DESC_ERROR);

      V_BOUQUET := OPERACION.PQ_DECO_ADICIONAL_LTE.SGAFUN_OBT_BOUQUET_ACT(V_CO_ID);

      FOR C IN C_ACCION LOOP
        IF (C.FLG_ACTIVA_DECO = 1 AND C.FLG_BAJA_DECO = 1 AND
           C.FLG_ACTIVA_TARJETA = 1 AND C.FLG_BAJA_TARJETA = 1) OR
           (C.FLG_ACTIVA_DECO = 1 AND C.FLG_BAJA_DECO = 0 AND
           C.FLG_ACTIVA_TARJETA = 1 AND C.FLG_BAJA_TARJETA = 0) OR
           (C.FLG_ACTIVA_DECO = 0 AND C.FLG_BAJA_DECO = 1 AND
           C.FLG_ACTIVA_TARJETA = 0 AND C.FLG_BAJA_TARJETA = 1)  THEN -- 8.0

          LV_ACCION := 'BAJA_ALTA'; -- Baja deco actual + tarjeta; Alta de nuevo deco + tarjeta

        END IF;

        IF C.FLG_ACTIVA_DECO = 1 AND C.FLG_BAJA_DECO = 1 AND
           C.FLG_CA_DECO = 0 AND C.FLG_ACTIVA_TARJETA = 0 AND
           C.FLG_BAJA_TARJETA = 0 AND C.FLG_CA_TARJETA = 1 THEN

          LV_ACCION := 'PAREO_TAR_ACTUAL'; -- Baja de Deco actual y Alta Nuevo deco manteniendo la tarjeta actual
        END IF;

        IF C.FLG_ACTIVA_DECO = 0 AND C.FLG_BAJA_DECO = 0 AND
           C.FLG_CA_DECO = 1 AND C.FLG_ACTIVA_TARJETA = 1 AND
           C.FLG_BAJA_TARJETA = 1 AND C.FLG_CA_TARJETA = 0 THEN

          LV_ACCION := 'PAREO_TAR_NUEVA'; -- Activacion de Tarjeta nueva y desactivacion de Tarjeta actual manteniendo el Deco
        END IF;

        -- Proceso de Asociacion DECO + TARJETA
        FOR CA IN C_ASOC(C.ASOC) LOOP

          IF CA.TIPO = 1 THEN
            LN_IDDET_TARJETA := CA.IDDET;
            LV_TARJETA       := CA.NUM_SERIE;
          ELSIF CA.TIPO = 2 THEN
            LN_IDDET_DECO := CA.IDDET;
            LV_DECO       := CA.MAC;
          END IF;

          IF LV_DECO IS NOT NULL AND LV_TARJETA IS NOT NULL THEN

            SELECT COUNT(1)
              INTO LN_VAL_ASOC
              FROM OPERACION.TARJETA_DECO_ASOC TDA
             WHERE TDA.CODSOLOT = C.CODSOLOT
               AND TDA.IDDET_DECO = LN_IDDET_DECO;

            IF LN_VAL_ASOC = 0 THEN
              INSERT INTO OPERACION.TARJETA_DECO_ASOC
                (CODSOLOT,
                 IDDET_DECO,
                 NRO_SERIE_DECO,
                 IDDET_TARJETA,
                 NRO_SERIE_TARJETA)
              VALUES
                (C.CODSOLOT,
                 LN_IDDET_DECO,
                 LV_DECO,
                 LN_IDDET_TARJETA,
                 LV_TARJETA);

              --Limpiamos Variables
              LN_IDDET_TARJETA := NULL;
              LN_IDDET_DECO    := NULL;
              LV_DECO          := NULL;
              LV_TARJETA       := NULL;
            END IF;
          END IF;

        END LOOP;



        FOR C_LINE IN C_EQUIPO_ALTA(C.ASOC) LOOP

          OPERACION.PQ_3PLAY_INALAMBRICO.P_LOG_3PLAYI(V_CODSOLOT, 'Proceso de Cambio DTH',
                                                      'Ejecutando proceso - DECO : ' || C_LINE.NRO_SERIE_DECO || ' - TARJETA : '|| C_LINE.NRO_SERIE_TARJETA || ' - ACCION : '||LV_ACCION,
                                                      'OPERACION.PKG_CAMBIO_EQUIPO_LTE.SGASI_ACTIVACION',
                                                      V_COD_LOG,
                                                      V_MSJ_LOG);

          IF LV_ACCION = 'PAREO_TAR_ACTUAL' or LV_ACCION = 'BAJA_ALTA' OR
             LV_ACCION = 'PAREO_TAR_NUEVA' THEN

            V_CONTEGO.TRXV_TIPO := OPERACION.PKG_CONTEGO.SGAFUN_ES_PAREO(C_LINE.NUMSERIE);

            IF V_CONTEGO.TRXV_TIPO = 'PAREO' THEN
              V_CONTEGO.TRXN_ACTION_ID := OPERACION.PKG_CONTEGO.SGAFUN_PARAM_CONTEGO('CONF_CONTEGO_ACT',
                                                                                     'CONF_ACT',
                                                                                     'PAREO-CONTEGO',
                                                                                     'N');
              V_CONTEGO.TRXN_PRIORIDAD := OPERACION.PKG_CONTEGO.SGAFUN_PARAM_CONTEGO('CONF_CONTEGO_ACT',
                                                                                     'CONF_ACT',
                                                                                     'PAREO-CONTEGO',
                                                                                     'AU');
            ELSIF V_CONTEGO.TRXV_TIPO = 'DESPAREO' THEN
              V_CONTEGO.TRXN_ACTION_ID := OPERACION.PKG_CONTEGO.SGAFUN_PARAM_CONTEGO('CONF_CONTEGO_ACT',
                                                                                     'CONF_ACT',
                                                                                     'DESPAREO-CONTEGO',
                                                                                     'N');
              V_CONTEGO.TRXN_PRIORIDAD := OPERACION.PKG_CONTEGO.SGAFUN_PARAM_CONTEGO('CONF_CONTEGO_ACT',
                                                                                     'CONF_ACT',
                                                                                     'DESPAREO-CONTEGO',
                                                                                     'AU');
            END IF;

            V_CONTEGO.TRXN_CODSOLOT      := V_CODSOLOT;
            V_CONTEGO.TRXV_BOUQUET       := V_BOUQUET;
            V_CONTEGO.TRXV_SERIE_TARJETA := C_LINE.NRO_SERIE_TARJETA;
            V_CONTEGO.TRXV_SERIE_DECO    := C_LINE.NRO_SERIE_DECO;
            -- Registro la Asociacion 101
            OPERACION.PKG_CONTEGO.SGASI_REGCONTEGO(V_CONTEGO, V_RES_ERROR);

            IF V_RES_ERROR = 'ERROR' THEN
              V_MSJ_ERROR := 'ERROR: AL GRABAR LAS TRANSACCIONES DE PAREO EN LA TABLA OPERACION.SGAT_TRXCONTEGO.';
              OPERACION.PKG_CAMBIO_EQUIPO_LTE.SGASU_SERV_X_CLIENTE(V_CODSOLOT,
                                                                    'CX',
                                                                    V_MSJ_ERROR,
                                                                    'NPRV',
                                                                    V_COD,
                                                                    V_MSJ);
              EXIT;
            END IF;

            IF LV_ACCION = 'BAJA_ALTA' OR LV_ACCION = 'PAREO_TAR_NUEVA' THEN --10.0
              -- Registro la Activacion 103
              V_CONTEGO.TRXV_TIPO       := NULL;
              V_CONTEGO.TRXV_SERIE_DECO := NULL; --4.0
              V_CONTEGO.TRXN_ACTION_ID  := OPERACION.PKG_CONTEGO.SGAFUN_PARAM_CONTEGO('CONF_CONTEGO_ACT',
                                                                                      'CONF_ACT',
                                                                                      'ALTA-CONTEGO',
                                                                                      'N');
              V_CONTEGO.TRXN_PRIORIDAD  := OPERACION.PKG_CONTEGO.SGAFUN_PARAM_CONTEGO('CONF_CONTEGO_ACT',
                                                                                      'CONF_ACT',
                                                                                      'ALTA-CONTEGO',
                                                                                      'AU');
              OPERACION.PKG_CONTEGO.SGASI_REGCONTEGO(V_CONTEGO,
                                                     V_RES_ERROR);
              IF V_RES_ERROR = 'ERROR' THEN
                V_MSJ_ERROR := 'ERROR: AL GRABAR LAS TRANSACCIONES DE ACTIVACION EN LA TABLA OPERACION.SGAT_TRXCONTEGO.';
                OPERACION.PKG_CAMBIO_EQUIPO_LTE.SGASU_SERV_X_CLIENTE(V_CODSOLOT,
                                                                    'CX',
                                                                    V_MSJ_ERROR,
                                                                    'NPRV',
                                                                    V_COD,
                                                                    V_MSJ);
                EXIT;
              END IF;

            END IF;
          END IF;
          OPERACION.PQ_3PLAY_INALAMBRICO.P_LOG_3PLAYI(V_CODSOLOT, 'Proceso de Cambio DTH',
                                                      'Fin del proceso - DECO : ' || C_LINE.NRO_SERIE_DECO || ' - TARJETA : '|| C_LINE.NRO_SERIE_TARJETA || ' - ACCION : '||LV_ACCION,
                                                      'OPERACION.PKG_CAMBIO_EQUIPO_LTE.SGASI_ACTIVACION',
                                                      V_COD_LOG,
                                                      V_MSJ_LOG);

        END LOOP;

        -- Baja de Deco
        IF LV_ACCION = 'PAREO_TAR_NUEVA' OR LV_ACCION = 'BAJA_ALTA' THEN

          FOR B IN C_BAJA_DECO(C.ASOC) LOOP

            OPERACION.PQ_DECO_ADICIONAL_LTE.SGASU_BAJA_DECO_CONTEGO(V_CODSOLOT,
                                                                    B.NUMSERIE,
                                                                    V_COD_ERROR,
                                                                    V_DESC_ERROR);
            IF V_COD_ERROR <> 'OK' THEN
              OPERACION.PKG_CAMBIO_EQUIPO_LTE.SGASU_SERV_X_CLIENTE(V_CODSOLOT,
                                                                   'CX',
                                                                   V_DESC_ERROR,
                                                                   'NPRV',
                                                                   V_COD,
                                                                   V_MSJ); --2.0
              RAISE EX_ERROR;
            END IF;


          END LOOP;
        END IF;

      END LOOP;

      OPERACION.PQ_3PLAY_INALAMBRICO.P_LOG_3PLAYI(V_CODSOLOT, 'Proceso de Cambio DTH',
                                                      'Fin del proceso de Cambio de Equipo DTH',
                                                      'OPERACION.PKG_CAMBIO_EQUIPO_LTE.SGASI_ACTIVACION',
                                                      V_COD_LOG,
                                                      V_MSJ_LOG);
    END IF;
    --Fin 5.0
  EXCEPTION
    WHEN EX_ERROR THEN
      --cambia a estado Generado
      opewf.pq_wf.p_chg_status_tareawf(PI_IDTAREAWF, 1, 1, 0, sysdate, sysdate);
      OPERACION.PQ_3PLAY_INALAMBRICO.p_log_3playi(V_CODSOLOT,
                                                  'ACTIVACION',
                                                  ('>> Cerrar SOT: Error durante la Ejecucion del SP' || chr(13) ||
                                                  '   Codigo Error: '  || to_char(sqlcode)           || chr(13) ||
                                                  '   Mensaje Error: ' || to_char(sqlerrm)           || chr(13) ||
                                                  '   Mensaje de Error Proc: ' || V_DESC_ERROR || chr(13) ||
                                                  '   Linea Error: '   || dbms_utility.format_error_backtrace),
                                                  'OPERACION.PKG_CAMBIO_EQUIPO_LTE.SGASI_ACTIVACION -1',
                                                  V_COD_LOG,
                                                  V_MSJ_LOG);

    WHEN OTHERS THEN
      opewf.pq_wf.p_chg_status_tareawf(PI_IDTAREAWF, 1, 1, 0, sysdate, sysdate);
      OPERACION.PQ_3PLAY_INALAMBRICO.p_log_3playi(V_CODSOLOT,
                                                  'ACTIVACION',
                                                  ('>> Cerrar SOT: Error durante la Ejecucion del SP' || chr(13) ||
                                                  '   Codigo Error: '  || to_char(sqlcode)           || chr(13) ||
                                                  '   Mensaje Error: ' || to_char(sqlerrm)           || chr(13) ||
                                                  '   Linea Error: '   || dbms_utility.format_error_backtrace),
                                                  'OPERACION.PKG_CAMBIO_EQUIPO_LTE.SGASI_ACTIVACION -99',
                                                  V_COD_LOG,
                                                  V_MSJ_LOG);
  END;

  PROCEDURE SGASS_VALIDACION(PI_IDTAREAWF IN NUMBER,
                             PI_IDWF      IN NUMBER,
                             PI_TAREA     IN NUMBER,
                             PI_TAREADEF  IN NUMBER) IS
    V_CODSOLOT OPEWF.WF.CODSOLOT%TYPE;
    EX_ERROR EXCEPTION;
    --V_TIPSRV        OPERACION.SOLOT.TIPSRV%TYPE;
    V_DESC_ERROR    VARCHAR2(500);
    V_COD_RPTA      NUMBER;
    V_DES_RPTA      VARCHAR2(500);
    V_IDINTERACCION OPERACION.SIAC_POSTVENTA_PROCESO.IDINTERACCION%TYPE;
    V_VAL_STATUS    NUMBER;
    V_VAL_CHIP      NUMBER;
    V_VAL_PWD       NUMBER;
    V_CO_ID         OPERACION.SOLOT.COD_ID%TYPE;
    V_DECO          SALES.SISACT_POSTVENTA_DET_SERV_LTE.NUM_SERIE%TYPE;
    V_TIPO_EQUIPO   VARCHAR2(10) := 'DECO';
    V_ESTADO        VARCHAR2(20);--2.0
    LN_BA_CE_LTE    NUMBER; --6.0
    V_COD_LOG       NUMBER;
    V_MSJ_LOG       VARCHAR2(4000);

  BEGIN
    --CONSULTA DE SOT
    SELECT W.CODSOLOT, S.COD_ID  --3.0
      INTO V_CODSOLOT, V_CO_ID   --3.0
      FROM OPEWF.WF W, OPERACION.SOLOT S --3.0
     WHERE W.IDWF = PI_IDWF
       AND W.CODSOLOT = S.CODSOLOT  --3.0
       AND W.VALIDO = 1;

    --TOMANDO IDINTERACCION
    select DISTINCT SPP.IDINTERACCION
      INTO V_IDINTERACCION
      from OPERACION.SIAC_POSTVENTA_PROCESO SPP
     WHERE SPP.CODSOLOT = V_CODSOLOT;

    LN_BA_CE_LTE     := OPERACION.PQ_SGA_JANUS.F_GET_CONSTANTE_CONF('BA_CEQU_LTE'); --6.0

    --VALIDANDO ALTA DE CAMBIO EQUIPO
    FOR I IN (SELECT TM.NUMERO_SERIE
                FROM SALES.SISACT_POSTVENTA_DET_SERV_LTE SPD,
                     OPERACION.TABEQUIPO_MATERIAL        TM
               WHERE SPD.IDINTERACCION = V_IDINTERACCION
                 AND SPD.NUM_SERIE = TM.NUMERO_SERIE
                 AND TM.TIPO = 1
                 AND SPD.FLAG_ACCION IN (C_ALTA, C_CA)) LOOP

      V_COD_RPTA := SGAFUN_VALPROV_CONTEGO(V_CODSOLOT, I.NUMERO_SERIE, 0); --Validamos alta
      IF V_COD_RPTA <> 0 THEN
      --INI 2.0
        IF SGAFUN_CONTEGOERRO(V_CODSOLOT, I.NUMERO_SERIE) > 0 THEN
          V_DESC_ERROR := 'EL ALTA PARA CAMBIO DE EQUIPO PRIVISIONO CON ERROR';
          SGASU_SERV_X_CLIENTE(V_CODSOLOT, C_TP_CONAX, V_DESC_ERROR, 'ERRO', V_COD_RPTA, V_DES_RPTA);
          RAISE EX_ERROR;
        ELSE
          V_DESC_ERROR := 'EL ALTA PARA CAMBIO DE EQUIPO ESTA EN PROCESO DE PROVISION';
          SGASU_SERV_X_CLIENTE(V_CODSOLOT, C_TP_CONAX, V_DESC_ERROR, 'PROC', V_COD_RPTA, V_DES_RPTA);
        END IF;
    --FIN 2.0
      ELSE
        SGASU_EQUIPO_MAT(C_ALTA, I.NUMERO_SERIE, V_COD_RPTA, V_DES_RPTA);
        IF V_COD_RPTA <> 0 THEN
          V_DESC_ERROR := V_DES_RPTA;
          RAISE EX_ERROR;
        END IF;
        SGASU_SERV_X_CLIENTE(V_CODSOLOT, C_TP_CONAX, V_DESC_ERROR, 'PROV', V_COD_RPTA, V_DES_RPTA);--2.0
      END IF;
    END LOOP;

    --VALIDANDO BAJA DE CAMBIO EQUIPO
    FOR J IN (SELECT TM.NUMERO_SERIE,
                     SPD.ASOC,
                     (SELECT CRM.DESCRIPCION
                        FROM SALES.CRMDD CRM
                       WHERE CRM.TIPCRMDD IN
                             (SELECT TIP.TIPCRMDD
                                FROM SALES.TIPCRMDD TIP
                               WHERE TIP.ABREV = 'DTHPOSTEQU')
                         AND CODIGON = SPD.TIPEQU) TIPO_DECO
                FROM SALES.SISACT_POSTVENTA_DET_SERV_LTE SPD,
                     OPERACION.TABEQUIPO_MATERIAL        TM
               WHERE SPD.IDINTERACCION = V_IDINTERACCION
                 AND SPD.NUM_SERIE = TM.NUMERO_SERIE
                 AND TM.TIPO = 1
                 AND SPD.FLAG_ACCION IN (C_BAJA)
               ORDER BY SPD.ASOC) LOOP

      V_COD_RPTA := SGAFUN_VALPROV_CONTEGO(V_CODSOLOT, J.NUMERO_SERIE, 1); --Validamos baja
      IF V_COD_RPTA <> 0 THEN
      --INI 2.0
        IF SGAFUN_CONTEGOERRO(V_CODSOLOT, J.NUMERO_SERIE) > 0 THEN
          V_DESC_ERROR := 'LA BAJA PARA CAMBIO DE EQUIPO PRIVISIONO CON ERROR';
          SGASU_SERV_X_CLIENTE(V_CODSOLOT, C_TP_CONAX, V_DESC_ERROR, 'ERRO', V_COD_RPTA, V_DES_RPTA);
          RAISE EX_ERROR;
        ELSE
          V_DESC_ERROR := 'LA BAJA PARA CAMBIO DE EQUIPO ESTA EN PROCESO DE PROVISION';
          SGASU_SERV_X_CLIENTE(V_CODSOLOT, C_TP_CONAX, V_DESC_ERROR, 'PROC', V_COD_RPTA, V_DES_RPTA);
        END IF;
    --FIN 2.0
      ELSE
        SGASU_EQUIPO_MAT(C_BAJA, J.NUMERO_SERIE, V_COD_RPTA, V_DES_RPTA);
        IF V_COD_RPTA <> 0 THEN
          V_DESC_ERROR := V_DES_RPTA;
          SGASU_SERV_X_CLIENTE(V_CODSOLOT, C_TP_CONAX, V_DESC_ERROR, 'PROV', V_COD_RPTA, V_DES_RPTA);
          RAISE EX_ERROR;
        END IF;
        --A traves del campo ASOC obtenemos por descarte el decodificador
        BEGIN
          SELECT DISTINCT A.NUM_SERIE
            INTO V_DECO
            FROM SALES.SISACT_POSTVENTA_DET_SERV_LTE A,
                 OPERACION.TABEQUIPO_MATERIAL        TM
           WHERE A.IDINTERACCION = V_IDINTERACCION
             AND A.NUM_SERIE = TM.NUMERO_SERIE
             AND A.ASOC = 2
             AND TM.TIPO = 2
             AND A.FLAG_ACCION = C_BAJA;
        EXCEPTION
          WHEN OTHERS THEN
            V_DESC_ERROR := 'No existe numero de Serie del Deco de Baja';
            RAISE EX_ERROR;
        END; -- 8.0

        TIM.PP021_VENTA_LTE.SP_ELIMINA_DECO_LTE@DBL_BSCS_BF(V_CO_ID,
                                                            V_DECO,
                                                            J.NUMERO_SERIE,
                                                            V_TIPO_EQUIPO,
                                                            J.TIPO_DECO,
                                                            V_COD_RPTA,
                                                            V_DES_RPTA);
        IF V_COD_RPTA <> 0 THEN
          V_DESC_ERROR := V_DES_RPTA;
          RAISE EX_ERROR;
        END IF;
        SGASU_SERV_X_CLIENTE(V_CODSOLOT, C_TP_CONAX, V_DESC_ERROR, 'PROV', V_COD_RPTA, V_DES_RPTA);
      END IF;
    END LOOP;

    --VALIDANDO CAMBIO DE CHIP
    SELECT COUNT(1)
      INTO V_VAL_CHIP
      FROM SALES.SISACT_POSTVENTA_DET_SERV_LTE SPD,
           OPERACION.TABEQUIPO_MATERIAL        TM
     WHERE SPD.IDINTERACCION = V_IDINTERACCION
       AND SPD.NUM_SERIE = TM.NUMERO_SERIE
       AND TM.TIPO = 3
       AND SPD.FLAG_ACCION = C_ALTA;
    --ENVIANDO EL CAMBIO DE CHIP
    IF V_VAL_CHIP > 0 THEN
      V_VAL_STATUS := SGAFUN_VALIDA_PROVLTE(V_CODSOLOT, 7);
      IF V_VAL_STATUS NOT IN (7, 100) THEN
        V_DESC_ERROR := 'NO SE ENCUENTRA PROVISIONADO EN IL PARA CAMBIO DE CHIP (ESTADO = '||TO_CHAR(V_VAL_STATUS)||')';
        SELECT CASE WHEN V_VAL_STATUS = 11 THEN 'ERRO' ELSE 'PROC' END INTO V_ESTADO FROM DUAL;--2.0
        SGASU_SERV_X_CLIENTE(V_CODSOLOT, C_TP_CHIP, V_DESC_ERROR, V_ESTADO, V_COD_RPTA, V_DES_RPTA);--2.0
        RAISE EX_ERROR;
      ELSE--2.0
        SGASU_SERV_X_CLIENTE(V_CODSOLOT, C_TP_CHIP, NULL, 'PROV', V_COD_RPTA, V_DES_RPTA);
      END IF;
    END IF;
    --ini 6.0
    IF LN_BA_CE_LTE = 1 THEN
       V_VAL_STATUS := SGAFUN_VALIDA_PROVLTE(V_CODSOLOT, 1);
        IF V_VAL_STATUS NOT IN (7, 100) THEN
          SELECT CASE WHEN V_VAL_STATUS = 11 THEN 'ERRO' ELSE 'PROC' END INTO V_ESTADO FROM DUAL;--2.0
          V_DESC_ERROR := 'NO SE ENCUENTRA PROVISIONADO EN IL PARA CAMBIO DE PASSWORD (ESTADO = '||TO_CHAR(V_VAL_STATUS)||')';
          SGASU_SERV_X_CLIENTE(V_CODSOLOT, C_TP_PASSW, V_DESC_ERROR, V_ESTADO, V_COD_RPTA, V_DES_RPTA);--2.0
          RAISE EX_ERROR;
        ELSE
          SGASU_SERV_X_CLIENTE(V_CODSOLOT, C_TP_PASSW, NULL, 'PROV', V_COD_RPTA, V_DES_RPTA);--2.0
        END IF;
    ELSE
    --fin 6.0
      --VALIDANDO CAMBIO DE PWD
      SELECT COUNT(1)
        INTO V_VAL_PWD
        FROM SALES.SISACT_POSTVENTA_DET_SERV_LTE SPD,
             OPERACION.TABEQUIPO_MATERIAL        TM
       WHERE SPD.IDINTERACCION = V_IDINTERACCION
         AND SPD.NUM_SERIE = TM.NUMERO_SERIE
         AND TM.TIPO = 4
         AND SPD.FLAG_ACCION = C_ALTA;

      IF V_VAL_PWD > 0 THEN
        V_VAL_STATUS := SGAFUN_VALIDA_PROVLTE(V_CODSOLOT, 12);
        IF V_VAL_STATUS NOT IN (7, 100) THEN
          SELECT CASE WHEN V_VAL_STATUS = 11 THEN 'ERRO' ELSE 'PROC' END INTO V_ESTADO FROM DUAL;--2.0
          V_DESC_ERROR := 'NO SE ENCUENTRA PROVISIONADO EN IL PARA CAMBIO DE PASSWORD (ESTADO = '||TO_CHAR(V_VAL_STATUS)||')';
          SGASU_SERV_X_CLIENTE(V_CODSOLOT, C_TP_PASSW, V_DESC_ERROR, V_ESTADO, V_COD_RPTA, V_DES_RPTA);--2.0
          RAISE EX_ERROR;
        ELSE
          SGASU_SERV_X_CLIENTE(V_CODSOLOT, C_TP_PASSW, NULL, 'PROV', V_COD_RPTA, V_DES_RPTA);--2.0
        END IF;
      END IF;
    END IF; --6.0
    --Regresamos al estado original
    OPERACION.PKG_CAMBIO_EQUIPO_LTE.SGASU_UPDATE_PREACTIVA(V_CO_ID,'VALIDACION',V_COD_RPTA, V_DES_RPTA);

  -- ini 9.0
    begin
      operacion.pq_siac_cambio_plan_lte.sgai_carga_equipo_post(V_CODSOLOT, V_COD_RPTA, V_DES_RPTA);
    exception
      when others then
        null;
    end;
    -- fin 9.0

  EXCEPTION
    WHEN EX_ERROR THEN
      OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(PI_IDTAREAWF, 1, 1, 0, SYSDATE, SYSDATE);
      OPERACION.PQ_3PLAY_INALAMBRICO.p_log_3playi(V_CODSOLOT,
                                                  'VALIDACION',
                                                  ('>> Cerrar SOT: Error durante la Ejecucion del SP' || chr(13) ||
                                                  '   Codigo Error: '  || to_char(sqlcode)           || chr(13) ||
                                                  '   Mensaje Error: ' || V_DESC_ERROR           || chr(13) ||
                                                  '   Linea Error: '   || dbms_utility.format_error_backtrace),
                                                  'OPERACION.PKG_CAMBIO_EQUIPO_LTE.SGASS_VALIDACION',
                                                  V_COD_LOG,
                                                  V_MSJ_LOG);
      RAISE_APPLICATION_ERROR(-20001,
                              'ERROR EN LA VALIDACION: ' || V_DESC_ERROR);
    WHEN OTHERS THEN
       OPERACION.PQ_3PLAY_INALAMBRICO.p_log_3playi(V_CODSOLOT,
                                                  'VALIDACION',
                                                  ('>> Cerrar SOT: Error durante la Ejecucion del SP' || chr(13) ||
                                                  '   Codigo Error: '  || to_char(sqlcode)           || chr(13) ||
                                                  '   Mensaje Error: ' || to_char(sqlerrm)           || chr(13) ||
                                                  '   Linea Error: '   || dbms_utility.format_error_backtrace),
                                                  'OPERACION.PKG_CAMBIO_EQUIPO_LTE.SGASS_VALIDACION',
                                                  V_COD_LOG,
                                                  V_MSJ_LOG);
      RAISE_APPLICATION_ERROR(-20001,
                              'ERROR EN LA VALIDACION: ' || SQLERRM || ' Linea (' ||
                              dbms_utility.format_error_backtrace || ')'); --8.0
  END;
  PROCEDURE SGASI_CAMBIO_PWD(PI_CO_ID         IN VARCHAR2,
                             PI_ICCID_OLD     IN VARCHAR2,
                             PI_ICCID_NEW     IN VARCHAR2,
                             PI_SOT           IN INTEGER,
                             PO_REQUEST       OUT INTEGER,
                             PO_REQUEST_PADRE IN OUT INTEGER,
                             PO_RESULTADO     OUT INTEGER,
                             PO_MSGERR        OUT VARCHAR2) IS
    V_CUSTOMER_ID  NUMBER;
    V_ACTION_CPASS NUMBER := 12;
    V_STATUS       NUMBER := 2;
    V_PRIORITY     NUMBER := 2;
    V_MSISDN       VARCHAR2(50);
    V_IMSI_OLD     VARCHAR2(50);
    V_IMSI_NEW     VARCHAR2(50);
    V_TIPO_PROD_INT_TELF CONSTANT VARCHAR2(20) := 'TEL+INT';
    V_ORIGEN_PROV    VARCHAR2(50) := 'SIAC';
    V_USERNAME       VARCHAR2(50) := 'SYSADM';
    V_FECHA_CREACION DATE := SYSDATE;
    LN_BA_CE_LTE     NUMBER; --6.0
    LN_VAL_CCHIP     NUMBER; --6.0
  BEGIN
    PO_RESULTADO := 0;
    PO_MSGERR    := 'PROCESO SATISFACTORIO';
    --VALIDACIONES
    IF PI_CO_ID IS NULL THEN
      PO_RESULTADO := 1;
      PO_MSGERR    := 'DEBE INGRESAR EL CO_ID';
      RETURN;
    ELSIF PI_ICCID_OLD IS NULL THEN
      PO_RESULTADO := 2;
      PO_MSGERR    := 'DEBE INGRESAR EL ICCID ANTERIOR';
      RETURN;
    END IF;

    --ini 6.0
    LN_BA_CE_LTE     := OPERACION.PQ_SGA_JANUS.F_GET_CONSTANTE_CONF('BA_CEQU_LTE');

    IF LN_BA_CE_LTE = 1 THEN
      tim.pp004_siac_lte.siacsi_alta_baja@dbl_bscs_bf(pi_co_id,
                                                      pi_co_id,
                                                      pi_sot,
                                                      'SGA',
                                                      PO_RESULTADO,
                                                      PO_MSGERR);

      --Actualizamos el Cambio de CHIP en el caso exista Registro
      SELECT COUNT(1)
        INTO LN_VAL_CCHIP
        FROM TIM.LTE_CONTROL_PROV@dbl_bscs_bf T
       WHERE T.CO_ID = pi_co_id
         AND T.ACTION_ID = 7;

      IF LN_VAL_CCHIP > 0 THEN
        UPDATE TIM.LTE_CONTROL_PROV@dbl_bscs_bf T
           SET T.REQUEST_PADRE =
               (SELECT DISTINCT TT.REQUEST_PADRE
                  FROM TIM.LTE_CONTROL_PROV@dbl_bscs_bf TT
                 WHERE TT.ACTION_ID = 1
                   AND TT.CO_ID = pi_co_id
                   AND ROWNUM = 1)
         WHERE T.CO_ID = pi_co_id
           AND T.ACTION_ID = 7;

        commit;

      END IF;
    ELSE
      --fin 6.0
      V_MSISDN := TIM.TFUN051_GET_DNNUM_FROM_COID@DBL_BSCS_BF(PI_CO_ID);
      --CONSULTA DE CUSTOMER_ID
      SELECT CUSTOMER_ID
        INTO V_CUSTOMER_ID
        FROM CONTRACT_ALL@DBL_BSCS_BF
       WHERE CO_ID = PI_CO_ID;
      --CONSULTA DE IMSI OLD
      SELECT P.PORT_NUM
        INTO V_IMSI_OLD
        FROM SYSADM.STORAGE_MEDIUM@DBL_BSCS_BF SM
       INNER JOIN SYSADM.PORT@DBL_BSCS_BF P
          ON (SM.SM_ID = P.SM_ID)
       WHERE SM.SM_SERIALNUM = PI_ICCID_OLD;
      --VALIDANDO INGRESO DE ICCID NEW
      IF PI_ICCID_NEW IS NOT NULL THEN
        --CONSULTA DE IMSI NEW
        SELECT P.PORT_NUM
          INTO V_IMSI_NEW
          FROM SYSADM.STORAGE_MEDIUM@DBL_BSCS_BF SM
         INNER JOIN SYSADM.PORT@DBL_BSCS_BF P
            ON (SM.SM_ID = P.SM_ID)
         WHERE SM.SM_SERIALNUM = PI_ICCID_NEW;
      END IF;

      SELECT TIM.LTE_PROV_SEQNO.NEXTVAL@DBL_BSCS_BF
        INTO PO_REQUEST
        FROM DUAL;

      IF PO_REQUEST_PADRE IS NULL THEN
        SELECT TIM.LTE_PADRE_PROV_SEQNO.NEXTVAL@DBL_BSCS_BF
          INTO PO_REQUEST_PADRE
          FROM DUAL;
      END IF;

      -- CAMBIO DE PASSWORD
      INSERT INTO TIM.LTE_CONTROL_PROV@DBL_BSCS_BF
        (REQUEST,
         REQUEST_PADRE,
         CUSTOMER_ID,
         CO_ID,
         ACTION_ID,
         STATUS,
         TIPO_PROD,
         MSISDN_OLD,
         IMSI_OLD,
         IMSI_NEW,
         ORIGEN_PROV,
         PRIORITY,
         INSERT_DATE,
         LTEV_USUCREACION,
         LTED_FECHA_CREACION,
         SOT)
      VALUES
        (PO_REQUEST, --TIM.LTE_PROV_SEQNO.NEXTVAL@DBL_BSCS_BF,
         PO_REQUEST_PADRE, --TIM.LTE_PADRE_PROV_SEQNO.NEXTVAL@DBL_BSCS_BF,
         V_CUSTOMER_ID,
         PI_CO_ID,
         V_ACTION_CPASS,
         V_STATUS,
         V_TIPO_PROD_INT_TELF,
         V_MSISDN,
         V_IMSI_OLD,
         V_IMSI_NEW,
         V_ORIGEN_PROV,
         V_PRIORITY,
         V_FECHA_CREACION,
         V_USERNAME,
         V_FECHA_CREACION,
         PI_SOT);
      --RETURNING REQUEST, REQUEST_PADRE INTO PO_REQUEST, PO_REQUEST_PADRE;
      END IF; --6.0
  EXCEPTION
    WHEN OTHERS THEN
      PO_RESULTADO := -99;
      PO_MSGERR    := TO_CHAR(SQLCODE) || ': ' || SQLERRM || ' Linea (' ||
                      dbms_utility.format_error_backtrace || ')';
  END;

  FUNCTION SGAFUN_VALIDA_PROVLTE(PI_CODSOLOT OPERACION.SOLOT.CODSOLOT%TYPE,
                                 PI_ACTION   NUMBER) RETURN NUMBER IS
    V_TIPO_PROD_TELF     CONSTANT VARCHAR2(20) := 'TELEFONIA';
    V_TIPO_PROD_INT      CONSTANT VARCHAR2(20) := 'INTERNET';
    V_TIPO_PROD_INT_TELF CONSTANT VARCHAR2(20) := 'TEL+INT';
    V_STATUS NUMBER;
    EX_ERROR EXCEPTION;
  BEGIN
    BEGIN
      SELECT LCP.STATUS
        INTO V_STATUS
        FROM TIM.LTE_CONTROL_PROV@DBL_BSCS_BF LCP
       WHERE LCP.SOT = PI_CODSOLOT
         AND LCP.TIPO_PROD IN
             (V_TIPO_PROD_TELF, V_TIPO_PROD_INT, V_TIPO_PROD_INT_TELF)
         AND LCP.REQUEST =
             (SELECT MAX(AA.REQUEST)
                FROM TIM.LTE_CONTROL_PROV@DBL_BSCS_BF AA
               WHERE AA.SOT = LCP.SOT
                 AND AA.CO_ID = LCP.CO_ID
                 AND AA.ACTION_ID = LCP.ACTION_ID)
         AND LCP.ACTION_ID = PI_ACTION;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        BEGIN
          SELECT A.STATUS
            INTO V_STATUS
            FROM TIM.LTE_CONTROL_PROV_HIST@DBL_BSCS_BF A
           WHERE A.SOT = PI_CODSOLOT
             AND A.TIPO_PROD IN
                 (V_TIPO_PROD_TELF, V_TIPO_PROD_INT, V_TIPO_PROD_INT_TELF)
             AND A.REQUEST =
                 (SELECT MAX(AA.REQUEST)
                    FROM TIM.LTE_CONTROL_PROV_HIST@DBL_BSCS_BF AA
                   WHERE AA.SOT = A.SOT
                     AND AA.CO_ID = A.CO_ID
                     AND AA.ACTION_ID = A.ACTION_ID)
             AND A.ACTION_ID = PI_ACTION;
        EXCEPTION
          WHEN OTHERS THEN
            RAISE EX_ERROR;
        END;
      WHEN OTHERS THEN
        RAISE EX_ERROR;
    END;

    RETURN V_STATUS;
  EXCEPTION
    WHEN EX_ERROR THEN
      RETURN -1;
    WHEN TOO_MANY_ROWS THEN
      RETURN -2;
    WHEN NO_DATA_FOUND THEN
      RETURN -3;
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('ERROR EN SGAFUN_VALIDA_PROVLTE - ' ||
                           TO_CHAR(SQLCODE) || ' - ' || SQLERRM || ' Linea (' ||
                           dbms_utility.format_error_backtrace || ')'); --8.0;
  END;

  FUNCTION SGAFUN_VALPROV_CONTEGO(PI_CODSOLOT OPERACION.SGAT_TRXCONTEGO.TRXN_CODSOLOT%TYPE,
                                  PI_NUMSERIE OPERACION.SGAT_TRXCONTEGO.TRXV_SERIE_TARJETA%TYPE,
                                  PI_ACTION   NUMBER) RETURN NUMBER IS
    EX_ERROR EXCEPTION;
    V_ESTADO VARCHAR2(50);
    V_RPTA   NUMBER;
  BEGIN

    IF PI_ACTION = 0 THEN
      --ALTA
      BEGIN
        SELECT DISTINCT ESTADO --8.0
          INTO V_ESTADO
          FROM (SELECT DISTINCT S.TRXC_ESTADO ESTADO
                  FROM OPERACION.SGAT_TRXCONTEGO S
                 WHERE S.TRXN_CODSOLOT = PI_CODSOLOT
                   AND S.TRXV_SERIE_TARJETA = PI_NUMSERIE
                   AND S.TRXC_ESTADO NOT IN (5, 6)
                   AND S.TRXN_ACTION_ID IN (101, 103)
                union all
                SELECT DISTINCT SH.TRXC_ESTADO ESTADO
                  FROM OPERACION.SGAT_TRXCONTEGO_HIST SH
                 WHERE SH.TRXN_CODSOLOT = PI_CODSOLOT
                   AND SH.TRXV_SERIE_TARJETA = PI_NUMSERIE
                   AND SH.TRXC_ESTADO NOT IN (5, 6)
                   AND SH.TRXN_ACTION_ID IN (101, 103));
        IF V_ESTADO = 3 THEN
          V_RPTA := 0;
        ELSE
          V_RPTA := -1;
        END IF;
      EXCEPTION
        WHEN TOO_MANY_ROWS THEN
          RETURN - 1;
      END;
    ELSIF PI_ACTION = 1 THEN
      --BAJA
      BEGIN
        SELECT DISTINCT ESTADO --8.0
          INTO V_ESTADO
          FROM (SELECT DISTINCT S.TRXC_ESTADO ESTADO
                  FROM OPERACION.SGAT_TRXCONTEGO S
                 WHERE S.TRXN_CODSOLOT = PI_CODSOLOT
                   AND S.TRXV_SERIE_TARJETA = PI_NUMSERIE
                   AND S.TRXC_ESTADO IN (3)
                   AND S.TRXN_ACTION_ID IN (105)
                union all
                SELECT DISTINCT SH.TRXC_ESTADO ESTADO
                  FROM OPERACION.SGAT_TRXCONTEGO_HIST SH
                 WHERE SH.TRXN_CODSOLOT = PI_CODSOLOT
                   AND SH.TRXV_SERIE_TARJETA = PI_NUMSERIE
                   AND SH.TRXC_ESTADO IN (3)
                   AND SH.TRXN_ACTION_ID IN (105));
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          RETURN - 1;
      END;
      V_RPTA := 0;
    END IF;

    RETURN V_RPTA;

  END;

  PROCEDURE SGASU_EQUIPO_MAT(PI_ACTION   IN SALES.SISACT_POSTVENTA_DET_SERV_LTE.FLAG_ACCION%TYPE,
                             PI_NUMSERIE IN SALES.SISACT_POSTVENTA_DET_SERV_LTE.NUM_SERIE%TYPE,
                             PO_COD_RPTA OUT NUMBER,
                             PO_DES_RPTA OUT VARCHAR2) IS
  BEGIN
    PO_COD_RPTA := 0;
    PO_DES_RPTA := 'OK';

    UPDATE OPERACION.TABEQUIPO_MATERIAL T
       SET T.ESTADO = CASE
                        WHEN PI_ACTION = C_BAJA THEN
                         0
                        WHEN PI_ACTION = C_ALTA THEN
                         1
                      END
     WHERE T.NUMERO_SERIE = PI_NUMSERIE
       AND T.TIPO IN (1, 2)
       AND T.ESTADO <> CASE
             WHEN PI_ACTION = C_BAJA THEN
              0
             WHEN PI_ACTION = C_ALTA THEN
              1
           END;
  EXCEPTION
    WHEN OTHERS THEN
      PO_COD_RPTA := -1;
      PO_DES_RPTA := TO_CHAR(SQLCODE) || ': ' || SQLERRM;
  END;

  PROCEDURE SGASS_DATOSXSOLOT(K_CODSOLOT IN OPERACION.SOLOT.CODSOLOT%TYPE,
                              K_DATOS    OUT SYS_REFCURSOR) IS
  BEGIN
    OPEN K_DATOS FOR
      SELECT S.CODCLI, S.CUSTOMER_ID, S.COD_ID, S.CODSOLOT
        FROM OPERACION.SOLOT S
       WHERE S.CODSOLOT = K_CODSOLOT;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      OPEN K_DATOS FOR
        SELECT NULL, NULL, NULL, NULL FROM DUAL;
  END;

  PROCEDURE SGASS_PROVLTE(K_CODSOLOT IN OPERACION.SOLOT.CODSOLOT%TYPE,
                          K_DATOS    OUT SYS_REFCURSOR) IS
  BEGIN
    OPEN K_DATOS FOR
      SELECT EST.ESSEV_COD_OPERACION,
             EST.ESSEN_COD_SOLOT,
             EST.ESSEV_CUSTOMER_ID,
             EST.ESSEN_CO_ID,
             EST.ESSEN_COD_CLI,
             EST.ESSEV_MENSAJE,
             EST.ESSEV_DESCRIPCION,
             EST.ESSEV_OPERACION,
             EST.ESSEV_ESTADO,
             DECODE(EST.ESSEV_COD_OPERACION, C_TP_CONAX, 1, C_TP_CHIP, 2, 3) ORDEN,
             (SELECT COUNT(1)
                FROM OPERACION.SGAT_LOGAPROVLTE LTE
               WHERE LTE.LOGAN_CODSOLOT = EST.ESSEN_COD_SOLOT
                 AND LTE.LOGAV_ESTADO IN ('ERRO', 'PROV')) CUENTA_LOG,
             EST.ESSEN_N_REENVIO,
             EST.ESSEN_N_REENVIO_MAX
        FROM OPERACION.PSGAT_ESTSERVICIO EST
       WHERE EST.ESSEN_COD_SOLOT = K_CODSOLOT
     AND EST.ESSEV_COD_OPERACION IN (C_TP_CONAX, C_TP_PASSW, C_TP_CHIP);
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
      OPEN K_DATOS FOR
        SELECT '' ESSEV_COD_OPERACION, NULL ESSEN_COD_SOLOT, NULL ESSEV_CUSTOMER_ID,
        NULL ESSEN_CO_ID, '' ESSEN_COD_CLI, '' ESSEV_MENSAJE, '' ESSEV_DESCRIPCION,
        '' ESSEV_OPERACION, '' ESSEV_ESTADO, 1 ORDEN, 0 CUENTA_LOG, 0 ESSEN_N_REENVIO,
        0 ESSEN_N_REENVIO_MAX FROM DUAL;
  END;

  PROCEDURE SGASS_EQCABTLIN(K_CODSOLOT IN OPERACION.SOLOT.CODSOLOT%TYPE,
                            K_TIPO     IN NUMBER,
                            K_DATOS    OUT SYS_REFCURSOR) IS
  BEGIN
    OPEN K_DATOS FOR
      SELECT equ_conax.grupo codigo,
             t.descripcion,
             se.numserie,
             se.mac,
             se.cantidad,
             i.codinssrv,
             se.codsolot,
             se.punto,
             se.orden,
             se.tipequ,
             se.estado,
             decode(opm.tipo,
                    1,
                    'TARJETA',
                    2,
                    'DECO',
                    3,
                    'SIMCARD',
                    4,
                    'CPE',
                    opm.tipo) tipo,
             post.flag_accion,
             post.asoc
        FROM solotptoequ se
       INNER JOIN solot s
          ON se.codsolot = s.codsolot
       INNER JOIN solotpto sp
          ON s.codsolot = sp.codsolot
         and se.punto = sp.punto
       INNER JOIN inssrv i
          ON sp.codinssrv = i.codinssrv
       INNER JOIN tipequ t
          ON se.tipequ = t.tipequ
       INNER JOIN almtabmat a
          ON t.codtipequ = a.codmat
       INNER JOIN (select a.codigon tipequ, to_number(codigoc) grupo
                     from opedd a, tipopedd b
                    where a.tipopedd = b.tipopedd
                      and b.abrev in ('TIPEQU_LTE_TLF', 'TIPEQU_DTH_CONAX')) equ_conax
          ON t.tipequ = equ_conax.tipequ
       INNER JOIN operacion.tabequipo_material opm
          ON se.numserie = opm.numero_serie
        LEFT JOIN sales.sisact_postventa_det_serv_lte post
          ON se.codsolot = post.codsolot
         and se.numserie = post.num_serie
         and (case K_TIPO
               when 4 then
                'A'
               when 12 then
                'B'
               else
                ''
             end) = post.flag_accion
       WHERE se.codsolot = K_CODSOLOT
         and se.estado = K_TIPO
       ORDER BY post.asoc ASC;
  END;

PROCEDURE SGASU_SERV_X_CLIENTE(p_codsolot       IN NUMBER,
                               p_tipo_operacion IN VARCHAR2,
                               p_mensaje        IN VARCHAR2,
                               p_estado         IN VARCHAR2,
                               p_codigo_resp    OUT NUMBER,
                               p_mensaje_resp   OUT VARCHAR2) IS
 -- pragma autonomous_transaction;
  lv_descrip     varchar2(100);
BEGIN

  p_codigo_resp  := 0;
  p_mensaje_resp := 'OK';

  BEGIN
    select b.descripcion
      into lv_descrip
      from tipopedd a, opedd b
     where a.tipopedd = b.tipopedd
       and a.abrev = 'EST_GEST_PROV'
       and b.abreviacion = p_estado;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      p_codigo_resp  := -1;
      p_mensaje_resp := 'No existe el estado en la tabla de parametros';
      RETURN;
  END;
  update operacion.psgat_estservicio se
     set se.essev_estado    = p_estado,
         se.essev_mensaje   = p_mensaje,
         se.essev_operacion = lv_descrip
   where se.essen_cod_solot = p_codsolot
     and se.essev_cod_operacion = p_tipo_operacion;

 -- COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    p_codigo_resp  := -1;
    p_mensaje_resp := 'Error al update operacion.psgat_estservicio: ' ||
                      SQLERRM;

END;

PROCEDURE SGASS_VALPROVXOPE(PI_CODSOLOT IN OPERACION.SOLOT.CODSOLOT%TYPE,
                            PI_TIPO_OPE IN VARCHAR2,
                            PO_COD      OUT NUMBER,
                            PO_MSJ      OUT VARCHAR2) IS
    EX_ERROR EXCEPTION;
    V_COUNT       NUMBER;
    V_VAL_STATUS  NUMBER;
    V_CO_ID       NUMBER;
    V_COD         NUMBER;
    V_MSJ         VARCHAR2(4000);
    V_ACTION      NUMBER;
    V_CANT_CONTEGO          NUMBER;
    V_LST_CONTEGO VARCHAR2(500);
    V_STATE       VARCHAR2(20);
    V_ERRO        NUMBER:=0;

  BEGIN
    --TOMAR CO_ID Y CUSTOMER_ID
    SELECT S.COD_ID
      INTO V_CO_ID
      FROM OPERACION.SOLOT S
     WHERE S.CODSOLOT = PI_CODSOLOT;

    SELECT COUNT(1)
      INTO V_COUNT
      FROM OPERACION.PSGAT_ESTSERVICIO E
     WHERE E.ESSEN_COD_SOLOT = PI_CODSOLOT
       AND E.ESSEV_COD_OPERACION = PI_TIPO_OPE;

    IF V_COUNT = 0 THEN
      SGASI_ESTADO_PROV(PI_CODSOLOT, PI_TIPO_OPE, PO_COD, PO_MSJ);
      IF PO_COD <> 0 THEN
        RAISE EX_ERROR;
      END IF;
    END IF;

    IF PI_TIPO_OPE = C_TP_CONAX THEN
      V_COUNT :=0;
      FOR I IN (SELECT DISTINCT C.TRXV_SERIE_TARJETA NUM_SERIE, C.TRXN_ACTION_ID
                  FROM OPERACION.SGAT_TRXCONTEGO C
                 WHERE C.TRXN_CODSOLOT = PI_CODSOLOT
                UNION ALL
                SELECT DISTINCT C.TRXV_SERIE_TARJETA NUM_SERIE, C.TRXN_ACTION_ID
                  FROM OPERACION.SGAT_TRXCONTEGO_HIST C
                 WHERE C.TRXN_CODSOLOT = PI_CODSOLOT) LOOP
        SELECT CASE
                 WHEN I.TRXN_ACTION_ID IN (101, 103) THEN 0 ELSE 1 END
          INTO V_ACTION
          FROM DUAL;

        IF SGAFUN_VALPROV_CONTEGO(PI_CODSOLOT, I.NUM_SERIE, V_ACTION) = 0 THEN
          PO_COD := 0;
          PO_MSJ := 'CONTEGO PROVISIONADO CORRECTAMENTE';
          SGASU_SERV_X_CLIENTE(PI_CODSOLOT, C_TP_CONAX, PO_MSJ, 'PROV', V_COD, V_MSJ);
        ELSE
        SELECT COUNT(1) INTO V_CANT_CONTEGO FROM(
          SELECT 1 FROM OPERACION.SGAT_TRXCONTEGO A
          WHERE A.TRXN_CODSOLOT = PI_CODSOLOT
          AND A.TRXV_SERIE_TARJETA = I.NUM_SERIE
          AND A.TRXN_ACTION_ID IN (103,105)
          AND A.TRXC_ESTADO = C_EST_CONTEGO_ERR
          UNION ALL
          SELECT 1 FROM OPERACION.SGAT_TRXCONTEGO_HIST B
          WHERE B.TRXN_CODSOLOT = PI_CODSOLOT
          AND B.TRXV_SERIE_TARJETA = I.NUM_SERIE
          AND B.TRXN_ACTION_ID IN (103,105)
          AND B.TRXC_ESTADO = C_EST_CONTEGO_ERR);
          IF V_CANT_CONTEGO > 0 THEN
            PO_COD := 0;
            PO_MSJ := 'ERROR EN PROVISION CONTEGO';
            SGASU_SERV_X_CLIENTE(PI_CODSOLOT,C_TP_CONAX,PO_MSJ,'ERRO',V_COD,V_MSJ);
            V_ERRO := -1;
          ELSE
             PO_MSJ := 'CONTEGO EN PROCESO DE PROVISION';
          END IF;

        SELECT CASE
          WHEN PO_MSJ = 'ERROR EN PROVISION CONTEGO' THEN  'ERROR'
          WHEN PO_MSJ = 'CONTEGO EN PROCESO DE PROVISION' THEN 'EN PROCESO'
         END
         INTO V_STATE
         FROM DUAL;

        IF V_COUNT = 0  THEN
        V_LST_CONTEGO := 'NUMSERIE ' || I.NUM_SERIE|| ': ' || V_STATE ||'; ';
        ELSE
        V_LST_CONTEGO := V_LST_CONTEGO || 'NUMSERIE ' || I.NUM_SERIE|| ': ' || V_STATE ||'; ';
        END IF;
        END IF;

         V_COUNT := V_COUNT +1 ;
      END LOOP;

      IF V_COUNT = 0 THEN
        PO_COD := -1;
        PO_MSJ := 'CONTEGO: NO EXISTE REGISTRO EN CONTEGO';
        SGASU_SERV_X_CLIENTE(PI_CODSOLOT, C_TP_CONAX, PO_MSJ, 'ERRO', V_COD, V_MSJ);
        RETURN;
      ELSE
         PO_COD := V_ERRO;
         PO_MSJ := NVL(V_LST_CONTEGO,'CONTEGO PROVISIONADO CORRECTAMENTE');
         RETURN;
      END IF;

    ELSIF PI_TIPO_OPE = C_TP_PASSW THEN
      V_VAL_STATUS := SGAFUN_VALIDA_PROVLTE(PI_CODSOLOT, 12);
      IF V_VAL_STATUS IN (7, 100) THEN
        PO_COD := 0;
        PO_MSJ := 'CAMBIO DE PASSWORD PROVISIONADO CORRECTAMENTE';
        SGASU_SERV_X_CLIENTE(PI_CODSOLOT, C_TP_PASSW, PO_MSJ, 'PROV', V_COD, V_MSJ);
        RETURN;
      ELSIF V_VAL_STATUS IN (11) THEN
        PO_COD := 0;
        PO_MSJ := 'ERROR EN PROVISION CAMBIO DE PASSWORD';
        SGASU_SERV_X_CLIENTE(PI_CODSOLOT,C_TP_PASSW,PO_MSJ,'ERRO',V_COD,V_MSJ);
        RETURN;
      END IF;
    ELSIF PI_TIPO_OPE = C_TP_CHIP THEN
      V_VAL_STATUS := SGAFUN_VALIDA_PROVLTE(PI_CODSOLOT, 7);
      IF V_VAL_STATUS IN (7, 100) THEN
        PO_COD := 0;
        PO_MSJ := 'CAMBIO DE CHIP PROVISIONADO CORRECTAMENTE';
        SGASU_SERV_X_CLIENTE(PI_CODSOLOT,C_TP_CHIP,PO_MSJ,'PROV',V_COD,V_MSJ);
        RETURN;
      ELSIF V_VAL_STATUS IN (11) THEN
        PO_COD := 0;
        PO_MSJ := 'ERROR EN PROVISION CAMBIO DE CHIP';
        SGASU_SERV_X_CLIENTE(PI_CODSOLOT,C_TP_CHIP,PO_MSJ,'ERRO',V_COD,V_MSJ);
        RETURN;
      END IF;
    END IF;
  EXCEPTION
    WHEN EX_ERROR THEN
      PO_COD := -1;
    WHEN OTHERS THEN
      PO_COD := -1;
      PO_MSJ :=  SQLCODE || ' ' || SQLERRM;
  END;

  PROCEDURE SGASU_AT_SERVICIO(PI_CODSOLOT IN OPERACION.SOLOT.CODSOLOT%TYPE,
                               PI_TIPO_OPE IN VARCHAR2,
                               PI_NUM_REENVIO IN NUMBER) IS

  LV_COUNT NUMBER;
  BEGIN
      LV_COUNT := 0;

      SELECT COUNT(1) INTO LV_COUNT FROM OPERACION.PSGAT_ESTSERVICIO EST
      WHERE EST.ESSEN_COD_SOLOT = PI_CODSOLOT AND EST.ESSEV_COD_OPERACION = PI_TIPO_OPE;

      IF LV_COUNT > 0 THEN
         UPDATE OPERACION.PSGAT_ESTSERVICIO
         SET ESSEN_N_REENVIO = NVL(ESSEN_N_REENVIO,0) + 1
         WHERE ESSEN_COD_SOLOT = PI_CODSOLOT AND ESSEV_COD_OPERACION = PI_TIPO_OPE
         AND NVL(ESSEN_N_REENVIO,0) < PI_NUM_REENVIO;
      END IF;

  END;

  FUNCTION SGAFUN_CONTEGOERRO(K_CODSOLOT IN OPERACION.SGAT_TRXCONTEGO.TRXN_CODSOLOT%TYPE,
                              K_NUMSERIE IN OPERACION.SGAT_TRXCONTEGO.TRXV_SERIE_TARJETA%TYPE)
    RETURN NUMBER IS
    V_RESPUESTA NUMBER := 0;
  BEGIN
    SELECT COUNT(1)
      INTO V_RESPUESTA
      FROM OPERACION.SGAT_TRXCONTEGO A
     WHERE A.TRXN_CODSOLOT = K_CODSOLOT
       AND A.TRXV_SERIE_TARJETA = K_NUMSERIE
       AND A.TRXC_ESTADO = C_EST_CONTEGO_ERR;
    RETURN V_RESPUESTA;
  END;

  PROCEDURE SGASS_DETALLEXEQUIPO(K_ABREV IN OPERACION.TIPOPEDD.ABREV%TYPE,
                                 K_DATOS OUT SYS_REFCURSOR) IS
  BEGIN
    OPEN K_DATOS FOR
      select a.Codigon precio, a.descripcion, a.codigon_aux tipo, a.abreviacion servicio, a.codigoc
        from operacion.opedd a
       WHERE A.TIPOPEDD =
             (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = K_ABREV);
  EXCEPTION
    WHEN OTHERS THEN
      OPEN K_DATOS FOR
      select null, null, null, null, null from dual;
  END;

  PROCEDURE SGASU_UPDATE_PREACTIVA(AN_COD_ID IN SOLOT.COD_ID%TYPE,
                                   AV_TIPO   IN VARCHAR2,
                                   AN_ERROR  OUT NUMBER,
                                   AV_ERROR  OUT VARCHAR2) IS
    LN_FLAG NUMBER;
  BEGIN
    LN_FLAG := OPERACION.PQ_SGA_JANUS.F_GET_CONSTANTE_CONF('VAL_CEQU_LTE');
    IF LN_FLAG = 1 THEN
      IF AV_TIPO = 'ACTIVACION' THEN

        UPDATE TIM.LTE_INFO_COM_DET@DBL_BSCS_BF T
           SET T.PRODUCTO = T.PRODUCTO || '1'
         WHERE T.CO_ID = AN_COD_ID;

      ELSIF AV_TIPO = 'VALIDACION' THEN

        UPDATE TIM.LTE_INFO_COM_DET@DBL_BSCS_BF T
           SET T.PRODUCTO = DECODE(SUBSTR(T.PRODUCTO,
                                          LENGTH(T.PRODUCTO),
                                          LENGTH(T.PRODUCTO)),
                                   '1',
                                   SUBSTR(T.PRODUCTO,
                                          0,
                                          LENGTH(T.PRODUCTO) - 1),
                                   T.PRODUCTO)
         WHERE T.CO_ID = AN_COD_ID;
      END IF;
    END IF;

    AN_ERROR := 0;
    AV_ERROR := 'OK';

  EXCEPTION
    WHEN OTHERS THEN
      AN_ERROR := -1;
      AV_ERROR := 'Error : ' || sqlerrm || ' - Linea (' ||
                  DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ')';
  END;
--5.0 Ini
  PROCEDURE SGASS_SUBTIPORDEN_TP(PI_TIPTRA   OPERACION.TIPTRABAJO.TIPTRA%TYPE,
                                 PO_DATO     out sys_refcursor
  ) IS
  nError        number;
  vError        varchar2(20);
  BEGIN

    OPERACION.pq_adm_cuadrilla.SGASS_SUBTIPO_TRABAJO(PI_TIPTRA,
                                     PO_DATO,
                                     nError,
                                     vError);

  END;
--5.0 Fin
END;
/