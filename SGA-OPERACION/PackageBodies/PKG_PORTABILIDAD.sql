CREATE OR REPLACE PACKAGE BODY OPERACION.PKG_PORTABILIDAD IS
  /************************************************************************************************************
    PROPOSITO:

    REVISIONES:
      Version  Fecha       Autor            Solicitado por      Descripcion
      -------  -----       -----            --------------      -----------
      1.0      2014-05-29  Jeny Valencia   Jose Varillas     Portabilidad Numerica
    2.0      2018-11-16  Hitss                   Portabilidad Numerica
    3.0      2018-12-03  Hitss                   Portabilidad Numerica
    4.0      2018-12-11  Hitss                   Portabilidad Numerica
    5.0      2019-05-30  Hitss                   Portabilidad Numerica
    6.0      2019-06-25  Hitss                   Portabilidad Numerica
    7.0      2019-10-29  Hitss                   Portabilidad Numerica
/************************************************************************************************************
  * NOMBRE SP            : P_PORTIN_VALID_MATERIAL
  * PROPOSITO            : VALIDA EXISTENCIA DE CODIGO DE MATERIAL
  * INPUT                : AV_CODMAT CODIGO DE MATERIAL
  * OUTPUT               : AN_MSJ    MENSAJE DE VALIDACION
  * CREACION             : 20/07/2018 JOSE VARILLAS
  '************************************************************************************************************/
  PROCEDURE SGASS_PORTIN_VALID_MATERIAL(PI_CODMAT IN VARCHAR2,
                                        PO_MSJ    OUT NUMBER) IS
    LN_VAL NUMBER;
  BEGIN
    SELECT COUNT(1)
      INTO LN_VAL
      FROM SANS.ZNS_DESCRIP_PROD@DBL_SANDB DP
     WHERE DP.MATNR = PI_CODMAT;
    IF LN_VAL = 0 THEN
      PO_MSJ := -1;
    ELSE
      PO_MSJ := 0;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      PO_MSJ := -1;
  END;
  /*************************************************************************************************************/
  PROCEDURE SGASU_PORTIN_ASOC_LINEA(PI_NSOT    IN NUMBER,
                                    PI_VLINEA  IN VARCHAR2,
                                    PI_VSERIE  IN VARCHAR2,
                                    PI_VCODMAT IN VARCHAR2,
                                    PO_NMSJ    OUT NUMBER,
                                    PO_VMSJ    OUT VARCHAR2) IS
    LN_ERROR     NUMBER;
    LV_ERROR     VARCHAR2(3000);
    LN_EXISTE    NUMBER;
    LV_NRO_TELEF VARCHAR2(100);
    LV_TELEF_LEN VARCHAR2(10);
    LV_IDREGION  VARCHAR2(100);
    TYPE LV_REGVAL IS TABLE OF VARCHAR2(50) INDEX BY BINARY_INTEGER;
    LV_CODREG         VARCHAR2(100);
    LN_CANTREG        NUMBER;
    LN_VAR            NUMBER;
    LV_REGION         VARCHAR2(100);
    LV_HLRS           VARCHAR2(100);
    LV_HLR            VARCHAR2(100);
    LN_VALHLR         NUMBER;
    LV_IDCLASIFRED    VARCHAR2(100);
    LV_IDHLR          VARCHAR2(100);
    LV_IDHLRS         VARCHAR2(100);
    LV_IDTIPONROTEL   VARCHAR2(100);
    LV_TIPO_NRO_TELEF VARCHAR2(100);
    LV_TIPO_CLIENTE   VARCHAR2(100);
    LV_TIPOCLIENTE    VARCHAR2(100);
    LV_IDDESCRIP_PROD VARCHAR2(100);
    LV_IDTIPOCLIENTE  VARCHAR2(100);
    LV_CLASIF_RED     VARCHAR2(100);
    LV_SERIE          VARCHAR2(100);
    LN_VALTLF         NUMBER;
    LN_NUMSEC         NUMBER;
    ERROR_GENERAL EXCEPTION;
    LA_REGVAL LV_REGVAL;
  BEGIN

    PO_NMSJ := 0;
    PO_VMSJ := 'OK';

    SGASS_PORTIN_VALID_NUMSEC(PI_NSOT,
                              LN_NUMSEC ,
                              LN_ERROR,
                              LV_ERROR) ;

    IF LN_ERROR = -1 THEN
       RAISE ERROR_GENERAL;
    END IF;

    SELECT COUNT(1)
      INTO LN_VALTLF
      FROM NUMTEL
     WHERE NUMERO = PI_VLINEA
       AND ESTNUMTEL = 1;

    --EVALUAMOS LA DISPONIBILIDAD DE LA LINEA
    IF LN_VALTLF = 0 THEN
      LV_ERROR := 'EL NUMERO TELEFONICO NO SE ENCUENTRA DISPONIBLE';
      RAISE ERROR_GENERAL;
    END IF;

    SELECT COUNT(1)
      INTO LN_EXISTE
      FROM SANS.ZNS_NRO_SIMCARDS@DBL_SANDB NS
     WHERE NS.NRO_TELEF = LPAD(TRIM(PI_VLINEA), 15, 0);

    SELECT OP.CODIGOC
      INTO LV_TELEF_LEN
      FROM OPEDD OP, TIPOPEDD TIP
     WHERE OP.TIPOPEDD = TIP.TIPOPEDD
       AND TIP.ABREV = 'PORT_IN'
       AND OP.ABREVIACION = 'LEN_TLF';

    SELECT OP.CODIGOC
      INTO LV_CODREG
      FROM OPEDD OP, TIPOPEDD TIP
     WHERE OP.TIPOPEDD = TIP.TIPOPEDD
       AND TIP.ABREV = 'PORT_IN'
       AND OP.ABREVIACION = 'COD_REG';

    SELECT OP.CODIGOC
      INTO LV_IDHLR
      FROM OPEDD OP, TIPOPEDD TIP
     WHERE OP.TIPOPEDD = TIP.TIPOPEDD
       AND TIP.ABREV = 'PORT_IN'
       AND OP.ABREVIACION = 'HLR';

    SELECT OP.CODIGOC
      INTO LV_TIPO_NRO_TELEF
      FROM OPEDD OP, TIPOPEDD TIP
     WHERE OP.TIPOPEDD = TIP.TIPOPEDD
       AND TIP.ABREV = 'PORT_IN'
       AND OP.ABREVIACION = 'TIPO_TLF';

    SELECT OP.CODIGOC
      INTO LV_CLASIF_RED
      FROM OPEDD OP, TIPOPEDD TIP
     WHERE OP.TIPOPEDD = TIP.TIPOPEDD
       AND TIP.ABREV = 'PORT_IN'
       AND OP.ABREVIACION = 'CLASF_RED';

    --PENDIENTE EVALUACION SI EL CLIENTE DEBE SER MOVIL
    SELECT A.SOPOC_CODIGO_CEDENTE
      INTO LV_TIPOCLIENTE
      FROM USRPVU.PORTT_SOLICITUDES_PORTA@DBL_PVUDB A
     INNER JOIN USRPVU.PORTT_PARAMETROS@DBL_PVUDB B
        ON A.SOPOC_CODIGO_CEDENTE = B.PK_PARAT_PARAC_COD
     WHERE A.SOPON_SOLIN_CODIGO = LN_NUMSEC
       AND ROWNUM = 1;

    --EVALUAMOS LA REGION
    LV_SERIE        := SUBSTR(PI_VSERIE, 1, 18);
    LV_HLR          := SUBSTR(PI_VSERIE, 6, 2);
    LN_CANTREG      := LENGTH(LV_CODREG) - LENGTH(replace(LV_CODREG, '|'));
    LV_TIPO_CLIENTE := NVL(LPAD(TRIM(LV_TIPOCLIENTE), 3, '0'), '');

    FOR LN_VAR IN 1 .. (LN_CANTREG - 1) LOOP
      LA_REGVAL(LN_VAR) := SUBSTR(LV_CODREG,
                                  INSTR(LV_CODREG, '|', 1, LN_VAR) + 1,
                                  (INSTR(LV_CODREG, '|', 1, LN_VAR + 1) - 2) -
                                  (INSTR(LV_CODREG, '|', 1, LN_VAR) - 1));
    END LOOP;

    FOR LN_VAR IN 1 .. (LN_CANTREG - 1) LOOP
      LV_REGION := SUBSTR(LA_REGVAL(LN_VAR),
                          1,
                          INSTR(LA_REGVAL(LN_VAR), ';') - 1);
      LV_HLRS   := SUBSTR(LA_REGVAL(LN_VAR),
                          INSTR(LA_REGVAL(LN_VAR), ';') + 1,
                          LENGTH(LA_REGVAL(LN_VAR)));
      LN_VALHLR := INSTR(LV_HLRS, LV_HLR);

      EXIT WHEN LN_VALHLR > 0;

    END LOOP;

    LV_NRO_TELEF := NVL(LPAD(TRIM(PI_VLINEA), LV_TELEF_LEN, '0'), '');

    SELECT MAX(TT.TATAI_IDTABLA)
      INTO LV_IDREGION
      FROM SANS.ZNS_COD_NACIONAL@DBL_SANDB R
     INNER JOIN SANS.GEN_TABLA_TABLA@DBL_SANDB TT
        ON R.TATAI_IDTABLA = TT.TATAI_IDTABLA
     WHERE TT.TATAV_CODIGO = LV_REGION;
    IF LV_IDREGION IS NULL THEN
      LV_ERROR := 'LA REGION ASOCIADA AL NUMERO NO ES VALIDA';
      RAISE ERROR_GENERAL;
    END IF;

    SELECT MAX(D.CLREI_IDCLASIF_RED)
      INTO LV_IDCLASIFRED
      FROM SANS.ZNS_CLASIF_RED@DBL_SANDB D
     WHERE D.CODIG = LV_CLASIF_RED
       AND D.CLREI_ELIMINADO = 0;
    IF LV_IDCLASIFRED IS NULL THEN
      LV_ERROR := 'NO EXISTE LA CLASIFICACION DE RED DEL NUMERO';
      RAISE ERROR_GENERAL;
    END IF;

    SELECT MAX(HLRI_IDHLR)
      INTO LV_IDHLRS
      FROM SANS.ZNS_HLR@DBL_SANDB
     WHERE CODIG = LV_IDHLR;
    IF LV_IDHLRS IS NULL THEN
      LV_ERROR := 'EL HLR NO ES VALIDO';
      RAISE ERROR_GENERAL;
    END IF;

    SELECT MAX(T.TINRI_IDTIPO_NRO_TEL)
      INTO LV_IDTIPONROTEL
      FROM SANS.ZNS_TIPO_NRO_TEL@DBL_SANDB T
     WHERE T.CODIG = LV_TIPO_NRO_TELEF
       AND T.TINRI_ELIMINADO = 0;
    IF LV_IDTIPONROTEL IS NULL THEN
      LV_ERROR := 'EL TIPO DE NUMERO DE TELEFONO NO ES VALIDO';
      RAISE ERROR_GENERAL;
    END IF;

    SELECT MAX(DP.DEPRI_IDDESCRIP_PROD)
      INTO LV_IDDESCRIP_PROD
      FROM SANS.ZNS_DESCRIP_PROD@DBL_SANDB DP
     WHERE DP.MATNR = PI_VCODMAT;

    SELECT TC.TICLI_IDTIPO_CLIENTE
      INTO LV_IDTIPOCLIENTE
      FROM SANS.ZNS_TIPO_CLIENTE@DBL_SANDB TC
     WHERE TC.CODIG = LV_TIPO_CLIENTE;

    IF LN_EXISTE = 0 THEN

      SANS.PKG_SANS_SIST_COMERCIALES.USP_ZNS_ASOC_LINEA_SGA@DBL_SANDB(LV_NRO_TELEF,
                                                                      LV_IDREGION,
                                                                      LV_IDCLASIFRED,
                                                                      LV_IDHLRS,
                                                                      LV_IDTIPONROTEL,
                                                                      LV_IDTIPOCLIENTE,
                                                                      LV_SERIE,
                                                                      LV_IDDESCRIP_PROD,
                                                                      LN_ERROR,
                                                                      LV_ERROR);

      IF LN_ERROR <> 0 THEN
        PO_VMSJ := LV_ERROR;
      END IF;

    ELSE
      OPERACION.PQ_SGA_WIMAX_LTE.P_ASOC_WIMAX_LTE(PI_VLINEA,
                                                  PI_VSERIE,
                                                  PI_VCODMAT,
                                                  PI_NSOT,
                                                  LN_ERROR,
                                                  LV_ERROR);
      IF LN_ERROR = 1 THEN
        LV_ERROR := 'LA LINEA (' || PI_VLINEA || ') SE ASOCIO CON EXITO';
      ELSE
        LV_ERROR := 'NO SE PUDO ASOCIAR LA LINEA: ' || PI_VLINEA || '(' ||
                    LV_ERROR || ')';
        RAISE ERROR_GENERAL;
      END IF;
    END IF;
    COMMIT;
  EXCEPTION
    WHEN ERROR_GENERAL THEN
      PO_NMSJ := -1;
      PO_VMSJ := LV_ERROR;
    WHEN OTHERS THEN
      PO_NMSJ := -1;
      PO_VMSJ := 'ERROR EN LA EJECUCION DEL PROCESO P_PORTIN_ASOC_LINEA';
  END;
  /************************************************************************************************************************/
  FUNCTION SGAFUN_OBT_EST_SOL_PORTA(PI_NUMSEC IN NUMBER) RETURN VARCHAR2 IS
    V_EST VARCHAR2(30);
  BEGIN

    SELECT SOPOC_ESTA_PROCESO
      INTO V_EST
      FROM USRPVU.PORTT_SOLICITUDES_PORTA@DBL_PVUDB PSP
     WHERE PSP.SOPON_SOLIN_CODIGO = PI_NUMSEC;
    RETURN V_EST;
  END SGAFUN_OBT_EST_SOL_PORTA;
  /************************************************************************************************************************/
  FUNCTION SGAFUN_OBT_FECH_SOL_PORTA(PI_NUMSEC IN NUMBER) RETURN VARCHAR2 IS
    V_FECH VARCHAR2(30);
  BEGIN

    SELECT SOPOD_FEC_ACTIVACION
      INTO V_FECH
      FROM USRPVU.PORTT_SOLICITUDES_PORTA@DBL_PVUDB PSP
     WHERE PSP.SOPON_SOLIN_CODIGO = PI_NUMSEC;
    RETURN V_FECH;
  END SGAFUN_OBT_FECH_SOL_PORTA;
  /************************************************************************************************************************/
  PROCEDURE SGASS_VALID_PORT_FECH(PO_CURSOR OUT SYS_REFCURSOR) IS

    LV_HFC VARCHAR2(2);
    LV_LTE VARCHAR2(2);
  BEGIN

    SELECT OP.CODIGOC
      INTO LV_HFC
      FROM OPEDD OP, TIPOPEDD TIP
     WHERE OP.TIPOPEDD = TIP.TIPOPEDD
       AND TIP.ABREV = 'PORT_IN'
       AND OP.ABREVIACION = 'TECN_HFC';

    SELECT OP.CODIGOC
      INTO LV_LTE
      FROM OPEDD OP, TIPOPEDD TIP
     WHERE OP.TIPOPEDD = TIP.TIPOPEDD
       AND TIP.ABREV = 'PORT_IN'
       AND OP.ABREVIACION = 'TECN_LTE';

    OPEN PO_CURSOR FOR
      SELECT DISTINCT S.CODSOLOT SOT,
                      S.COD_ID,
                      S.CUSTOMER_ID,
                      NVL(S.NUMSEC, INS.NUMSEC) NUMSEC,
                      (SELECT V.NOMEST
                         FROM V_UBICACIONES V
                        WHERE V.CODUBI = INS.CODUBI) DEPARTAMENTO,
                      (SELECT TIP.DSCDID
                         FROM VTATIPDID TIP
                        WHERE TIP.TIPDIDE = CLI.TIPDIDE) TIPO_DOCUMENTO,
                      CLI.NTDIDE NRO_DOCUMENTO,
                      INS.NUMERO NRO_TELEFONO_PORTABLE,
                      (SELECT CON.NOMBRE
                         FROM CONTRATA CON
                        WHERE CON.CODCON = A.CODCON) CONTRATISTA,
                      A.FECAGENDA FECPROGRAMACION,
                      T.DESCRIPCION DESC_TIP_TRABAJO,
                      (SELECT SOLID_ENVIO_CP
                        FROM USRPVU.SISACT_SEC_DATOS@DBL_PVUDB
                        WHERE SOLIN_CODIGO = NVL(S.NUMSEC, INS.NUMSEC)) AS FECH
        FROM SOLOT        S,
             VTATABSLCFAC V,
             SOLOTPTO     PTO,
             INSSRV       INS,
             AGENDAMIENTO A,
             SOLUCIONES   SOL,
             VTATABCLI    CLI,
             TIPTRABAJO   T
       WHERE S.CODSOLOT = PTO.CODSOLOT
         AND S.NUMSLC = V.NUMSLC
         AND PTO.CODINSSRV = INS.CODINSSRV
         AND S.CODSOLOT = A.CODSOLOT
         AND V.IDSOLUCION = SOL.IDSOLUCION
         AND T.TIPTRA = S.TIPTRA
         AND S.CODCLI = CLI.CODCLI
         AND INS.TIPINSSRV = 3 -- NUMERO TELEFONICO
         AND SOL.FLG_SISACT_SGA IN (LV_HFC, LV_LTE) -- SOLUCIONES SISACT (1:HFC / 2: LTE)
         AND V.FLG_PORTABLE = 1 -- INDICA PORTABILIDAD
         AND S.ESTSOL = 17 -- ESTADO DE LA SOT (EN EJECUCION)
         AND TRUNC(A.FECAGENDA) = TRUNC(SYSDATE)
         AND NVL(S.NUMSEC, INS.NUMSEC) > 0;
  END;
  /************************************************************************************************************************/
  PROCEDURE SGASS_VALID_PEND_PORTA(PO_CURSOR OUT SYS_REFCURSOR) IS

    LV_LTE VARCHAR2(2);
  BEGIN
    SELECT OP.CODIGOC
      INTO LV_LTE
      FROM OPEDD OP, TIPOPEDD TIP
     WHERE OP.TIPOPEDD = TIP.TIPOPEDD
       AND TIP.ABREV = 'PORT_IN'
       AND OP.ABREVIACION = 'TECN_LTE';

    OPEN PO_CURSOR FOR
      SELECT DISTINCT S.CODSOLOT SOT,
                      S.COD_ID,
                      S.CUSTOMER_ID,
                      NVL(S.NUMSEC, INS.NUMSEC) NUMSEC
        FROM SOLOT        S,
             VTATABSLCFAC V,
             SOLOTPTO     PTO,
             INSSRV       INS,
             SOLUCIONES   SOL
       WHERE S.CODSOLOT = PTO.CODSOLOT
         AND S.NUMSLC = V.NUMSLC
         AND PTO.CODINSSRV = INS.CODINSSRV
         AND V.IDSOLUCION = SOL.IDSOLUCION
         AND INS.TIPINSSRV = 3 -- NUMERO TELEFONICO
         AND SOL.FLG_SISACT_SGA = LV_LTE -- SOLUCIONES SISACT (1: HFC / 2: LTE)
         AND V.FLG_PORTABLE = 1 -- INDICA PORTABILIDAD
         AND S.ESTSOL = 9 -- ESTADO DE LA SOT (PENDIENTE DE PORTABILIDAD)
         AND NVL(S.NUMSEC, INS.NUMSEC) > 0;
  END;
  /************************************************************************************************************************/
  PROCEDURE SGASU_PORTIN_CHG_EST_SOT(PI_IDTAREAWF IN NUMBER,
                                     PI_IDWF      IN NUMBER,
                                     PI_TAREA     IN NUMBER,
                                     PI_TAREADEF  IN NUMBER) IS

    L_CODSOLOT    SOLOT.CODSOLOT%TYPE;
    L_VAL         NUMBER;
    L_NUMERO      VARCHAR2(20);
    L_MENSAJE     VARCHAR2(50);
    L_COD_ID      INT;
    L_CUSTOMER_ID INT;
    LV_NUM        VARCHAR(15);
    L_EXCP        EXCEPTION;
  BEGIN

    SELECT CODSOLOT INTO L_CODSOLOT FROM WF WHERE IDWF = PI_IDWF;
    SELECT CUSTOMER_ID, COD_ID
      INTO L_CUSTOMER_ID, L_COD_ID
      FROM SOLOT
     WHERE CODSOLOT = L_CODSOLOT;

   --7.0 Ini
    BEGIN
      SELECT DISTINCT INS.NUMERO
      INTO L_NUMERO
      FROM INSSRV INS
     INNER JOIN SOLOTPTO PTO
        ON PTO.CODINSSRV = INS.CODINSSRV
       WHERE PTO.CODSOLOT = L_CODSOLOT
       AND INS.TIPINSSRV = 3;
    EXCEPTION
      WHEN OTHERS THEN
        L_NUMERO := NULL;
    END;
    --7.0 Fin
    -- Valida provision
    -- Telefonia
    SELECT COUNT(1)
      INTO L_VAL
      FROM TIM.LTE_CONTROL_PROV@DBL_BSCS_BF
     WHERE CO_ID = L_COD_ID
       AND CUSTOMER_ID = L_CUSTOMER_ID
       AND ACTION_ID = 1
     AND TIPO_PROD IN ('TEL+INT','INTERNET','TELEFONIA')
       AND STATUS <> 7;

    IF L_VAL > 0 THEN
      INSERT INTO TAREAWFSEG
        (IDTAREAWF, OBSERVACION)
      VALUES
        (PI_IDTAREAWF, 'Servicio de Telefonia Pendiente de Provision');
      COMMIT;
      RAISE L_EXCP;
    END IF;

    -- TV
    SELECT COUNT(1)
      INTO L_VAL
      FROM OPERACION.SGAT_TRXCONTEGO
     WHERE TRXN_CODSOLOT = L_CODSOLOT
       AND TRXN_ACTION_ID IN (101, 103)
       AND TRXC_ESTADO <> 3;

    IF L_VAL > 0 THEN
      INSERT INTO TAREAWFSEG
        (IDTAREAWF, OBSERVACION)
      VALUES
        (PI_IDTAREAWF, 'Servicio de TV Pendiente de Provision');
      COMMIT;
      RAISE L_EXCP;
    END IF;

    -- Validamos linea JANUS
    LV_NUM := '0051' || L_NUMERO;
    OPERACION.PQ_CONT_REGULARIZACION.P_VALIDA_LINEA_JANUS(LV_NUM,
                                                          L_VAL,
                                                          L_MENSAJE);
    IF L_VAL = 0 THEN
      INSERT INTO TAREAWFSEG
        (IDTAREAWF, OBSERVACION)
      VALUES
        (PI_IDTAREAWF, 'LA LINEA NO SE ENCUENTRA ASIGNADA EN IWAY');
      COMMIT;
      RAISE L_EXCP;
    END IF;

    UPDATE SOLOT SET ESTSOL = 9 WHERE CODSOLOT = L_CODSOLOT;

    OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(PI_IDTAREAWF,
                                     4,
                                     4,
                                     4,
                                     SYSDATE,
                                     SYSDATE);

  EXCEPTION
    WHEN L_EXCP THEN
      raise_application_error(-20001,
                              'Revisar Historico de Cambio de Estado de Tareas');
    WHEN OTHERS THEN
      raise_application_error(-20001,
                              'Error al realizar el cambio de Estado de la SOT');
  END;
  /************************************************************************************************************************/
  PROCEDURE SGASS_VAL_PROC_PORTIN(PI_NUMSEC             IN NUMBER,
                                  PI_SOT                IN NUMBER,
                                  PI_NRO_SOL_PORTA      IN NUMBER,
                                  PI_SOPOC_ESTA_PROCESO IN VARCHAR2,
                                  PI_ESTADO             IN VARCHAR2,
                                  PO_ERR                OUT NUMBER,
                                  PO_MSJ                OUT VARCHAR2) IS
  
    L_SOPOC_ESTA_PROCESO VARCHAR2(100);
    L_ESTADO             VARCHAR2(100);
    L_IDTAREAWF          NUMBER;
    L_TAREADEF           NUMBER;
    L_IDWF               NUMBER;
  
  BEGIN
  
    SELECT O.CODIGOC
      INTO L_SOPOC_ESTA_PROCESO
      FROM OPEDD O, TIPOPEDD T
     WHERE T.TIPOPEDD = O.TIPOPEDD
       AND T.ABREV = 'PORT_IN'
       AND O.ABREVIACION = 'VAL_PORTIN_COD';
  
    SELECT O.CODIGOC
      INTO L_ESTADO
      FROM OPEDD O, TIPOPEDD T
     WHERE T.TIPOPEDD = O.TIPOPEDD
       AND T.ABREV = 'PORT_IN'
       AND O.ABREVIACION = 'VAL_PORTIN_MSJ';
  
    BEGIN
    
      SELECT F.IDTAREAWF, E.TAREADEF, W.IDWF
        INTO L_IDTAREAWF, L_TAREADEF, L_IDWF
        FROM WF W, TAREAWF F, TAREADEF E , SOLOT S
       WHERE W.IDWF = F.IDWF
         AND F.TAREADEF = E.TAREADEF
         AND W.CODSOLOT = S.CODSOLOT
         AND W.VALIDO = 1
         AND F.ESTTAREA NOT IN (4, 8)
         AND E.TAREADEF =
             (SELECT OP.CODIGOC
                FROM OPEDD OP, TIPOPEDD TIP
               WHERE OP.TIPOPEDD = TIP.TIPOPEDD
                 AND TIP.ABREV = 'PORT_IN'
                 AND OP.ABREVIACION = 'TAREADEF_CTRL')
         AND S.ESTSOL = 9
         AND W.CODSOLOT IN (PI_SOT);
    
      IF L_SOPOC_ESTA_PROCESO = PI_SOPOC_ESTA_PROCESO AND
         L_ESTADO = PI_ESTADO THEN
      
        UPDATE SOLOT SET ESTSOL = 17 WHERE CODSOLOT = PI_SOT;
      
        OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(L_IDTAREAWF,
                                         4,
                                         4,
                                         NULL,
                                         SYSDATE,
                                         SYSDATE);
      
      ELSE
      
        OPERACION.P_ENVIO_OBS_TAREAWFSEG(L_TAREADEF,
                                         'Proceso Port-In pendiente de procesar: ' ||
                                         'NUMSEC: ' || PI_NUMSEC ||
                                         ', SOT: ' || PI_SOT ||
                                         ', NRO_SOL_PORTA: ' ||
                                         PI_NRO_SOL_PORTA ||
                                         ', CODIGO_RPTA: ' ||
                                         PI_SOPOC_ESTA_PROCESO ||
                                         ', MENSAJE_RPTA: ' || PI_ESTADO,
                                         L_IDWF);
      
      END IF;
    
    EXCEPTION
      WHEN OTHERS THEN
        PO_ERR := -1;
        PO_MSJ := 'La sot no se encuentra en un estado de Validacion Pendiente de Portar';
    END;
  
  EXCEPTION
    WHEN OTHERS THEN
      PO_ERR := -1;
      PO_MSJ := 'Error al obtener la Informacion de Configuracion';
  END;
  /************************************************************************************************************
  * NOMBRE SP            : SGASI_PORTOUT_SOT_ALTA
  * PROPOSITO            : GENERA SOT DE ALTA PORTOUT PARA HFC O LTE
  * INPUT                : PI_CUSTOMERID  CODIGO DE USUARIO BSCS
                           PI_CODID_OLD   CODIGO DE CONTRATO BSCS
                           PI_TECN        TECNOLOGIA HFC O LTE
  * OUTPUT               :
                           PO_ERR         CODIGO DE ERROR
                           PO_MSJ         MENSAJE DE ERROR
  * CREACION             : 28/08/2018 JOSE VARILLAS
  '************************************************************************************************************/
  PROCEDURE SGASI_PORTOUT_SOT_ALTA(PI_CUSTOMERID IN NUMBER,
                                   PI_CODID_OLD  IN NUMBER,
                                   PI_TECN       IN VARCHAR2,
                                   PO_ERR        OUT NUMBER,
                                   PO_MSJ        OUT VARCHAR2) IS
    LN_ERR        NUMBER;
    LV_MSJ        VARCHAR2(3000);
    LN_IDPROCESS  NUMBER;
    LN_PROCESO_ID NUMBER;
    LV_EXCP       EXCEPTION;
    LN_VAL          NUMBER;
    LV_VENTA        VARCHAR2(32000);  --4.0
    P_VENTA_OUT     VARCHAR2(3000);
    P_ERROR_CODE    NUMBER;
    P_ERROR_MSG     VARCHAR2(3000);
    LV_SQL          VARCHAR2(32000);  --4.0
    LV_SQL_AUX      VARCHAR2(32000);  --4.0
    LN_VAL_SERV     NUMBER := 0;
    LN_ROW          NUMBER;
    LV_TRAMA        VARCHAR2(100);
    LV_SERVICIO     SYS_REFCURSOR;
    LN_SOT_ORI      NUMBER;
    LV_SOT_ALTA     VARCHAR2(100);
    LV_SOT_ALTA_GEN VARCHAR2(100);
    LN_SOT_ALTA     NUMERIC;
    LV_TELEF        VARCHAR2(100);

    CURSOR CAB_LTE IS
      SELECT COLUMN_NAME, COLUMN_LENGTH
        FROM SALES.TRAMA_LTE C, SALES.TRAMA_DET_LTE D
       WHERE C.TRAMAID = D.TRAMAID
         AND C.TRAMAID = 1
       ORDER BY D.ORDEN;

    CURSOR DET_LTE IS
      SELECT COLUMN_NAME, COLUMN_LENGTH
        FROM SALES.TRAMA_LTE C, SALES.TRAMA_DET_LTE D
       WHERE C.TRAMAID = D.TRAMAID
         AND C.TRAMAID = 2
       ORDER BY D.ORDEN;

    CURSOR CAB_HFC IS
      SELECT TRIM(COLUMN_NAME) COLUMN_NAME, COLUMN_LENGTH  --4.0
        FROM SALES.TRAMA C, SALES.TRAMA_DET D  --4.0
       WHERE C.TRAMAID = D.TRAMAID
         AND C.TRAMAID = 1
       ORDER BY D.ORDEN;

    CURSOR DET_HFC IS
      SELECT TRIM(COLUMN_NAME) COLUMN_NAME, COLUMN_LENGTH  --4.0
        FROM SALES.TRAMA C, SALES.TRAMA_DET D  --4.0
       WHERE C.TRAMAID = D.TRAMAID
         AND C.TRAMAID = 2
       ORDER BY D.ORDEN;

    CURSOR DET_GRUPO IS
      SELECT INTS.IDGRUPO_PRINCIPAL
        FROM SALES.INT_PORTABILIDAD_DET INTS
       WHERE INTS.SOT_ORI = LN_SOT_ORI
         AND INTS.IDGRUPO_PRINCIPAL IN
             (SELECT CODIGOC
                FROM OPEDD
               WHERE TIPOPEDD IN
                     (SELECT TIPOPEDD
                        FROM TIPOPEDD
                       WHERE ABREV = 'CONF_ALTA_PORTOUT')
                 AND ABREVIACION = 'GRUPO_PRINC')
       GROUP BY INTS.IDGRUPO_PRINCIPAL
       ORDER BY INTS.IDGRUPO_PRINCIPAL;

  BEGIN
    LN_ERR := 0;
    LV_MSJ := 'OK';

    SELECT MAX(PROCESO_ID)
      INTO LN_PROCESO_ID
      FROM SALES.INT_PORTABILIDAD
     WHERE CUSTOMER_ID = PI_CUSTOMERID
       AND COD_ID = PI_CODID_OLD;

    SELECT VALOR
      INTO LV_TELEF
      FROM OPERACION.CONSTANTE
     WHERE CONSTANTE = 'FAM_TELEF';

    -- VALIDA DETALLE
    UPDATE SALES.INT_PORTABILIDAD_DET DET
       SET FLG_ESTADO = -1, OBSERVACION = 'No se ingreso codigo de Equipo'  --4.0
     WHERE COD_ID = NVL(PI_CODID_OLD, COD_ID)
    AND DET.TIPSRV NOT IN (LV_TELEF)
    AND (SELECT NVL(TY.FLGEQU,0) FROM TYSTABSRV TY
       WHERE DET.CODSRV = TY.CODSRV)= 1
    AND (TIPEQU IS NULL OR CODTIPEQU IS NULL);
    COMMIT;

    SELECT COUNT(1)
      INTO LN_VAL
      FROM SALES.INT_PORTABILIDAD T1
     WHERE T1.COD_ID = PI_CODID_OLD
       AND T1.TECN = PI_TECN
       AND T1.CUSTOMER_ID = PI_CUSTOMERID
       AND T1.PROCESO_ID = LN_PROCESO_ID
       AND T1.ESTADO = 1;

    IF LN_VAL = 0 THEN
      LN_ERR := -1;
      LV_MSJ := 'La SOT no se encuentra en el estado Indicado';
      RAISE LV_EXCP;
    END IF;

    SELECT SOT_ORI
      INTO LN_SOT_ORI
      FROM SALES.INT_PORTABILIDAD T1
     WHERE T1.COD_ID = PI_CODID_OLD
       AND T1.TECN = PI_TECN
       AND T1.CUSTOMER_ID = PI_CUSTOMERID
       AND T1.PROCESO_ID = LN_PROCESO_ID
       AND T1.ESTADO = 1;

    SELECT IDPROCESS
      INTO LN_IDPROCESS
      FROM SALES.INT_NEGOCIO_INSTANCIA
     WHERE INSTANCIA = 'SOT'
       AND IDINSTANCIA = LN_SOT_ORI;

    IF PI_TECN = 'LTE' THEN
      --DATOS VENTA LTE
      LN_VAL := 0;
      LV_SQL := '';
      LN_ROW := SALES.PQ_TRAMA_LTE.GET_COUNT_REG(1);  --4.0

      FOR C1 IN CAB_LTE LOOP -- CABECERA LTE
        LN_VAL := LN_VAL + 1;

        IF LN_VAL = 1 THEN
          LV_SQL := 'SELECT REPLACE(' || 'LPAD(NVL(TO_CHAR(TRIM(INTS.' ||
                    C1.COLUMN_NAME || ')), ''#''),' || C1.COLUMN_LENGTH ||
                    ', ''#'') || ''|'' ||' || CHR(13);
        ELSIF LN_ROW > LN_VAL THEN
          BEGIN
            SELECT CODIGOC
              INTO LV_TRAMA
              FROM OPEDD
             WHERE TIPOPEDD IN
                   (SELECT TIPOPEDD
                      FROM TIPOPEDD
                     WHERE ABREV = 'CONF_ALTA_PORTOUT')
               AND DESCRIPCION = C1.COLUMN_NAME;
          EXCEPTION
            WHEN OTHERS THEN
              IF C1.COLUMN_NAME = 'NUMERO_PORTABLE' THEN
                LV_TRAMA := '100';
              ELSE
                LV_TRAMA := 'INTS.' || C1.COLUMN_NAME;
              END IF;
          END;
          LV_SQL := LV_SQL || 'LPAD(NVL(TO_CHAR(TRIM(' || LV_TRAMA ||
                    ')), ''#''),' || C1.COLUMN_LENGTH ||
                    ', ''#'') || ''|'' ||' || CHR(13);

        ELSIF LN_ROW = LN_VAL THEN
          LV_SQL := LV_SQL || 'LPAD(NVL(TO_CHAR(TRIM(INTS.' ||
                    C1.COLUMN_NAME || ')), ''#''),' || C1.COLUMN_LENGTH ||
                    ', ''#'') , ''#'','' '') ' || CHR(13) ||
                    'FROM SALES.INT_NEGOCIO_PROCESO INTS' || CHR(13) ||
                    'WHERE INTS.IDPROCESS = ' || LN_IDPROCESS || '';
        END IF;
      END LOOP;

      BEGIN
        EXECUTE IMMEDIATE LV_SQL
          INTO LV_VENTA;
      EXCEPTION
        WHEN OTHERS THEN
          LV_MSJ := 'ERROR AL  GENERAR TRAMA VENTA LTE '||SQLERRM ||
          ' - Linea ('||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE||')';
          RAISE LV_EXCP;
      END;

      --GRUPO LTE
      FOR LDET_GRUPO IN DET_GRUPO LOOP
        LN_VAL      := 0;
        LV_SQL      := '';
        LN_VAL_SERV := LN_VAL_SERV + 1;

        LN_ROW := SALES.PQ_TRAMA_LTE.GET_COUNT_REG(2);  --4.0

        -- SERVICIOS LTE
        FOR C2 IN DET_LTE LOOP

          LN_VAL := LN_VAL + 1;

          IF LN_VAL = 1 THEN
            LV_SQL := 'SELECT REPLACE(' ;
          END IF;

          IF LN_ROW <> LN_VAL THEN
            BEGIN
              SELECT CODIGOC
                INTO LV_TRAMA
                FROM OPEDD
               WHERE TIPOPEDD IN
                     (SELECT TIPOPEDD
                        FROM TIPOPEDD
                       WHERE ABREV = 'CONF_ALTA_PORTOUT')
                 AND DESCRIPCION = C2.COLUMN_NAME;
            EXCEPTION
              WHEN OTHERS THEN
                LV_TRAMA := 'INTS.' || C2.COLUMN_NAME;
            END;
            LV_SQL := LV_SQL || 'LPAD(NVL(TO_CHAR(TRIM(' || LV_TRAMA ||
                      ')), ''#''),' || C2.COLUMN_LENGTH ||
                      ', ''#'') || ''|'' ||' || CHR(13);

          ELSE
            LV_SQL := LV_SQL || 'LPAD(NVL(TO_CHAR(TRIM(INTS.' ||
                      C2.COLUMN_NAME || ')), ''#''),' || C2.COLUMN_LENGTH ||
                      ', ''#'') || '';'' , ''#'','' '') ' || CHR(13) ||
                      'FROM  SALES.INT_PORTABILIDAD_DET INTS' || CHR(13) ||
                      'WHERE NVL(FLG_ESTADO,0)=0 AND INTS.SOT_ORI = ' || LN_SOT_ORI ||
                      CHR(13) || 'AND INTS.IDGRUPO_PRINCIPAL = ' ||
                      LDET_GRUPO.IDGRUPO_PRINCIPAL || '';
          END IF;

        END LOOP; -- SERVICIOS LTE

        BEGIN
          OPEN LV_SERVICIO FOR LV_SQL;
          LV_SQL := '';
        EXCEPTION
          WHEN OTHERS THEN
            LV_MSJ := 'ERROR AL GENERAR TRAMA SERVICIOS LTE '||SQLERRM||
            ' - Linea ('||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE||')';
            RAISE LV_EXCP;
        END;

        LOOP
          FETCH LV_SERVICIO
            INTO LV_SQL_AUX;
          EXIT WHEN LV_SERVICIO%NOTFOUND;

          LV_SQL := LV_SQL || LV_SQL_AUX;
        END LOOP;
        CLOSE LV_SERVICIO;

        LV_SQL_AUX := SUBSTR(LV_SQL, 1, LENGTH(LV_SQL) - 1);

        BEGIN
          SALES.PQ_TRAMA_LTE.EXECUTE_MAIN(LV_VENTA,
                                          LV_SQL_AUX,
                                          P_VENTA_OUT,
                                          P_ERROR_CODE,
                                          P_ERROR_MSG);
        EXCEPTION
          WHEN OTHERS THEN
            LV_MSJ := 'ERROR EN SALES.PQ_TRAMA_LTE.EXECUTE_MAIN '||SQLERRM||
            ' - Linea ('||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE||')';
            RAISE LV_EXCP;
        END;

        -- ACTUALIZAR SOT_ALTA LTE
        LV_SOT_ALTA := SGAFUN_CAMPO_ARRAY(P_VENTA_OUT, 3, 'CODSOLOT');

        IF LV_SOT_ALTA IS NULL THEN
          LV_MSJ := 'ERROR AL GENERAR SOT ALTA - LTE:' || ' ' ||SQLERRM||P_ERROR_MSG;
          LN_ERR := P_ERROR_CODE;
          RAISE LV_EXCP;
        END IF;

        LN_SOT_ALTA     := TO_NUMBER(LV_SOT_ALTA);
        LV_SOT_ALTA_GEN := LV_SOT_ALTA_GEN || LV_SOT_ALTA;

        SGASU_PORTOUT_INTPORT(LN_SOT_ORI, LN_SOT_ALTA);
        COMMIT;
      END LOOP; -- GRUPO LTE
    END IF;  -- PI_TECN LTE

    IF PI_TECN = 'HFC' THEN
      --DATOS VENTA HFC
      LV_SQL := '';
      LN_VAL := 0;
      LN_ROW := SALES.PQ_TRAMA.GET_COUNT_REG(1);  --4.0

      FOR C3 IN CAB_HFC LOOP
        -- VENTA HFC
        LN_VAL := LN_VAL + 1;

        IF LN_VAL = 1 THEN
          LV_SQL := 'SELECT REPLACE(' || 'LPAD(NVL(TO_CHAR(TRIM(INTS.' ||
                    C3.COLUMN_NAME || ')), ''#''),' || C3.COLUMN_LENGTH ||
                    ', ''#'') || ''|'' ||' || CHR(13);

        ELSIF LN_ROW > LN_VAL THEN  --4.0
          BEGIN
            SELECT CODIGOC
              INTO LV_TRAMA
              FROM OPEDD
             WHERE TIPOPEDD IN
                   (SELECT TIPOPEDD
                      FROM TIPOPEDD
                     WHERE ABREV = 'CONF_ALTA_PORTOUT')
               AND DESCRIPCION = C3.COLUMN_NAME;
          EXCEPTION
            WHEN OTHERS THEN
             -- INI 5.0
              IF C3.COLUMN_NAME = 'NUMERO_PORTABLE' THEN
                LV_TRAMA := '100';
              ELSE
              LV_TRAMA := 'INTS.' || C3.COLUMN_NAME;
              END IF;
             -- FIN 5.0
          END;
            LV_SQL := LV_SQL || 'LPAD(NVL(TO_CHAR(TRIM(' || LV_TRAMA ||
                      ')), ''#''),' || C3.COLUMN_LENGTH ||
                      ', ''#'') || ''|'' ||' || CHR(13);

        ELSIF LN_ROW = LN_VAL THEN  --4.0
          LV_SQL := LV_SQL || 'LPAD(NVL(TO_CHAR(TRIM(INTS.' ||
                    C3.COLUMN_NAME || ')), ''#''),' || C3.COLUMN_LENGTH ||
                    ', ''#'') , ''#'','' '') ' || CHR(13) ||
                    'FROM SALES.INT_NEGOCIO_PROCESO INTS' || CHR(13) ||
                    'WHERE INTS.IDPROCESS = ' || LN_IDPROCESS || ' ';  --4.0

        END IF;
      END LOOP; -- VENTA HFC

      BEGIN
        EXECUTE IMMEDIATE LV_SQL
          INTO LV_VENTA;
      EXCEPTION
        WHEN OTHERS THEN
          LV_MSJ := 'ERROR AL  GENERAR TRAMA VENTA HFC' || SQLERRM ||
                    ' - Linea (' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ')';  --4.0
          RAISE LV_EXCP;
      END;

      --GRUPO HFC
      FOR LDET_GRUPO IN DET_GRUPO LOOP
        LN_VAL      := 0;
        LV_SQL      := '';
        LN_VAL_SERV := LN_VAL_SERV + 1;

        LN_ROW := SALES.PQ_TRAMA.GET_COUNT_REG(2);  --4.0

        FOR C4 IN DET_HFC LOOP
          -- SERVICIOS HFC

          LN_VAL := LN_VAL + 1;

          IF LN_VAL = 1 THEN
            --4.0 Ini
            LV_SQL := 'SELECT REPLACE(';

            BEGIN
              SELECT CODIGOC
                INTO LV_TRAMA
                FROM OPEDD
               WHERE TIPOPEDD IN
                     (SELECT TIPOPEDD
                        FROM TIPOPEDD
                       WHERE ABREV = 'CONF_ALTA_PORTOUT')
                 AND DESCRIPCION = C4.COLUMN_NAME;
            EXCEPTION
              WHEN OTHERS THEN
                LV_TRAMA := 'INTS.' || C4.COLUMN_NAME;
            END;

            LV_SQL := LV_SQL || 'LPAD(NVL(TO_CHAR(TRIM(' || LV_TRAMA ||
                      ')), ''#''),' || C4.COLUMN_LENGTH ||
                      ', ''#'') || ''|'' ||' || CHR(13);

          ELSIF LN_ROW > LN_VAL THEN
          --4.0 Fin
            BEGIN
              SELECT CODIGOC
                INTO LV_TRAMA
                FROM OPEDD
               WHERE TIPOPEDD IN
                     (SELECT TIPOPEDD
                        FROM TIPOPEDD
                       WHERE ABREV = 'CONF_ALTA_PORTOUT')
                 AND DESCRIPCION = C4.COLUMN_NAME;
            EXCEPTION
              WHEN OTHERS THEN
                LV_TRAMA := 'INTS.' || C4.COLUMN_NAME;
            END;
            LV_SQL := LV_SQL || 'LPAD(NVL(TO_CHAR(TRIM(' || LV_TRAMA ||
                      ')), ''#''),' || C4.COLUMN_LENGTH ||
                      ', ''#'') || ''|'' ||' || CHR(13);

          ELSE
            LV_SQL := LV_SQL || 'LPAD(NVL(TO_CHAR(TRIM(INTS.' ||
                      C4.COLUMN_NAME || ')), ''#''),' || C4.COLUMN_LENGTH ||
                      ', ''#'') || '';'' , ''#'','' '') ' || CHR(13) ||
                      'FROM SALES.INT_PORTABILIDAD_DET INTS' || CHR(13) ||
                      'WHERE NVL(FLG_ESTADO,0)=0 AND INTS.SOT_ORI = ' || LN_SOT_ORI ||
                      CHR(13) || 'AND INTS.IDGRUPO_PRINCIPAL = ' ||
                      LDET_GRUPO.IDGRUPO_PRINCIPAL || '';
          END IF;
        END LOOP; -- SERVICIOS HFC

        BEGIN
          OPEN LV_SERVICIO FOR LV_SQL;
          LV_SQL := '';
        EXCEPTION
          WHEN OTHERS THEN
            LV_MSJ := 'ERROR AL  GENERAR TRAMA SERVICIOS HFC: '||SQLERRM || ' - Linea ('||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE||')';
            RAISE LV_EXCP;
        END;

        LOOP
          FETCH LV_SERVICIO
            INTO LV_SQL_AUX;
          EXIT WHEN LV_SERVICIO%NOTFOUND;

          LV_SQL := LV_SQL || LV_SQL_AUX;
        END LOOP;
        CLOSE LV_SERVICIO;

        SELECT SUBSTR(LV_SQL, 1, LENGTH(LV_SQL) - 1)
          INTO LV_SQL_AUX
          FROM DUAL;

        BEGIN
          SALES.PQ_TRAMA.EXECUTE_MAIN(LV_VENTA,
                                          LV_SQL_AUX,
                                          P_VENTA_OUT,
                                          P_ERROR_CODE,
                                          P_ERROR_MSG);
        EXCEPTION
          WHEN OTHERS THEN
            LV_MSJ := 'ERROR EN SALES.PQ_TRAMA.EXECUTE_MAIN: '||SQLERRM ||
            ' - Linea ('||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE||')';
            RAISE LV_EXCP;
        END;

        LV_SOT_ALTA := SGAFUN_CAMPO_ARRAY(P_VENTA_OUT, 3, 'CODSOLOT');

        IF LV_SOT_ALTA IS NULL THEN
          LV_MSJ := 'ERROR AL GENERAR SOT ALTA - HFC:' || ' ' ||SQLERRM||P_ERROR_MSG;
          LN_ERR := P_ERROR_CODE;
          RAISE LV_EXCP;
        END IF;

        LN_SOT_ALTA     := TO_NUMBER(LV_SOT_ALTA);
        LV_SOT_ALTA_GEN := LV_SOT_ALTA_GEN || LV_SOT_ALTA;
        SGASU_PORTOUT_INTPORT(LN_SOT_ORI, LN_SOT_ALTA);
        COMMIT;
        END LOOP; -- GRUPO HFC
      END IF;-- FIN PI_TECN = 'HFC'

      IF LN_VAL_SERV = 0 THEN
        LN_ERR := -1;
        LV_MSJ := 'NO SE ENCONTRARON SERVICIOS DE INTERNET O TV PARA GENERAR ALTA';
        RAISE LV_EXCP;
      END IF;

  EXCEPTION
    WHEN LV_EXCP THEN
      PO_ERR := LN_ERR;
      PO_MSJ := 'Generacion de SOT de Alta: '||LV_MSJ||' '||SQLERRM||
      ' - Linea ('||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE||')';
      SGASI_GENERA_LOG(
                      'PROCESO_ID:'  ||TO_CHAR(LN_PROCESO_ID)||
                      CHR(13)||'CUSTOMER_ID: '||TO_CHAR(PI_CUSTOMERID)||
                      CHR(13)||'SOT ORIGEN: ' ||TO_CHAR(LN_SOT_ORI),
                      'SGASS_SOT_ALTA',
                      LN_ERR,
                      PO_MSJ);

    WHEN OTHERS THEN
      PO_ERR := -1;
      PO_MSJ := 'Generacion de SOT de Alta: '||SQLERRM ||
             ' - Linea ('||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE||')';
      SGASI_GENERA_LOG(
                      'PROCESO_ID:'  ||TO_CHAR(LN_PROCESO_ID)||
                      CHR(13)||'CUSTOMER_ID: '||TO_CHAR(PI_CUSTOMERID)||
                      CHR(13)||'SOT ORIGEN: ' ||TO_CHAR(LN_SOT_ORI),
                      'SGASS_SOT_ALTA',
                      SQLCODE,
                      PO_MSJ);
  END;
  /* *********************************************************************************************************
  * NOMBRE SP            : SGASI_PORTOUT_SOT_BAJA
  * PROPOSITO            : GENERAR SOT BAJA
  * INPUT                : PI_CO_ID       CODIGO DE CONTRATO
                           PI_TECN        TIPO DE TECNOLOGIA (HFC,LTE)
                           PI_NUMERO      NUMERO PORTOUT
  * OUTPUT               : PO_RESULTADO   RESULTADO
                           PO_MENSAJE     MENSAJE DE VALIDACION
  * CREACION             : 03/08/2018     JENY VALENCIA
    ACTUALIZACION        : 17/09/2018     JENY VALENCIA
                           11/10/2018     1.0 JENY VALENCIA
  '***********************************************************************************************************/
  PROCEDURE SGASI_PORTOUT_SOT_BAJA(PI_CO_ID     OPERACION.SOLOT.COD_ID%TYPE,
                                   PI_TECN      VARCHAR2,
                                   PI_NUMERO    NUMBER,
                                   PO_RESULTADO OUT NUMBER,
                                   PO_MENSAJE   OUT VARCHAR2) IS
    LN_SOT         NUMBER;
    LN_SOT_ANT     NUMBER;
    LN_TITRA       OPERACION.SOLOT.TIPTRA%TYPE;
    LN_MOTIVO      OPERACION.SOLOT.CODMOTOT%TYPE;
    LV_CODCLI      OPERACION.SOLOT.CODCLI%TYPE;
    LN_TIPSRV      OPERACION.SOLOT.TIPSRV%TYPE;
    LV_AREASOL     OPERACION.SOLOT.AREASOL%TYPE;
    LN_CUSTOMER_ID OPERACION.SOLOT.CUSTOMER_ID%TYPE;
    LN_CTRL_SOT    INTEGER;
    LV_SOT_PEN     VARCHAR2(2000);
    L_WF           CUSBRA.BR_SEL_WF.WFDEF%TYPE;
    L_PROCESO_ID   NUMBER := 0;
    LN_SOT_PEN     NUMBER := 0;
    LS_CABLE       VARCHAR2(100);
    LS_INTERNET    VARCHAR2(100);
    LV_MENSAJE     VARCHAR2(2000);
    EXC_BAJA       EXCEPTION;
    LV_PARAMETROS  VARCHAR2(2000);

  BEGIN
    PO_RESULTADO := 0;
    PO_MENSAJE   := 'OK'; --4.0

    SELECT NVL(MAX(PROCESO_ID),0)
      INTO L_PROCESO_ID
      FROM SALES.INT_PORTABILIDAD T1
     WHERE T1.COD_ID = PI_CO_ID
       AND T1.TECN = PI_TECN
       AND T1.NUMERO = PI_NUMERO
       AND T1.ESTADO = 0;

    IF L_PROCESO_ID = 0 THEN
      LV_MENSAJE   := 'Linea no se encuentra en estado respectivo.';
      RAISE EXC_BAJA;
    END IF;

    SELECT VALOR
      INTO LS_CABLE
      FROM OPERACION.CONSTANTE
     WHERE CONSTANTE = 'FAM_CABLE';

    SELECT VALOR
      INTO LS_INTERNET
      FROM OPERACION.CONSTANTE
     WHERE CONSTANTE = 'FAM_INTERNET';

    -- INICIO CONTROL GESTION DE SOT

    BEGIN
      SELECT COUNT(1)
        INTO LN_CTRL_SOT
        FROM OPERACION.SOLOT S
       WHERE S.COD_ID = PI_CO_ID
         AND S.ESTSOL IN (SELECT ESTSOL
                            FROM OPERACION.ESTSOL
                           WHERE TIPESTSOL IN (1, 2, 3, 6))
         AND S.ESTSOL <> 29;

      IF LN_CTRL_SOT > 0 THEN
        LV_SOT_PEN := NULL;
        FOR C_VAL_SOT IN (SELECT CODSOLOT
                            FROM OPERACION.SOLOT S
                           WHERE S.COD_ID = PI_CO_ID
                             AND S.ESTSOL IN
                                 (SELECT ESTSOL
                                    FROM OPERACION.ESTSOL
                                   WHERE TIPESTSOL IN (1, 2, 3, 6))

                             AND S.ESTSOL <> 29
                           GROUP BY CODSOLOT) LOOP

          IF LV_SOT_PEN IS NULL THEN
            LV_SOT_PEN := C_VAL_SOT.CODSOLOT;
          ELSE
            IF LN_SOT_PEN < 14 THEN
              LV_SOT_PEN := LV_SOT_PEN || ',' || C_VAL_SOT.CODSOLOT;
              LN_SOT_PEN := LN_SOT_PEN + 1;
            END IF;
          END IF;
        END LOOP;
      END IF;
    EXCEPTION
      WHEN OTHERS THEN
        LN_CTRL_SOT := 0;
    END;

    IF LN_CTRL_SOT > 0 THEN
      LV_MENSAJE   := 'Se Encuentran SOT con estado Pendiente de Cierre. ' ||
                      CHR(13) || '   SOT Pendiente(s):' ||
                      TO_CHAR(LV_SOT_PEN);
      RAISE EXC_BAJA;
    END IF;
    -- FIN CONTROL GESTION DE SOT

    --- CONSULTA CONFIGURACIONES: TIPO DE TAREA, MOTIVO
    BEGIN
      IF PI_TECN = 'HFC' THEN
        SELECT D.CODIGON, CODIGON_AUX
          INTO LN_TITRA, LN_MOTIVO
          FROM TIPOPEDD C, OPEDD D
         WHERE C.ABREV = 'TIPTRABAJO'
           AND C.TIPOPEDD = D.TIPOPEDD
           AND D.ABREVIACION = 'SISACT_BAJA_HFC';
      END IF;
      IF PI_TECN = 'LTE' THEN
        SELECT D.CODIGON, CODIGON_AUX
          INTO LN_TITRA, LN_MOTIVO
          FROM TIPOPEDD C, OPEDD D
         WHERE C.ABREV = 'TIPTRABAJO'
           AND C.TIPOPEDD = D.TIPOPEDD
           AND D.ABREVIACION = 'SISACT_BAJA_LTE';
      END IF;
    EXCEPTION
      WHEN OTHERS THEN
        LV_MENSAJE   := 'Error al Recuperar los Datos de las Configuraciones.';
        RAISE EXC_BAJA;
    END;
    --- FIN CONSULTA DE CONFIGURACIONES

    --- INICIO GENERACION DE SOT
    BEGIN
      LN_SOT_ANT := OPERACION.PQ_SGA_IW.F_MAX_SOT_X_COD_ID(PI_CO_ID);

      IF LN_SOT_ANT= 0 OR LN_SOT_ANT IS NULL THEN
        LV_MENSAJE   := 'No se encontro SOT de Origen';
        RAISE EXC_BAJA;
      END IF;

      SELECT S.CODCLI, S.TIPSRV, S.AREASOL, S.CUSTOMER_ID
        INTO LV_CODCLI, LN_TIPSRV, LV_AREASOL, LN_CUSTOMER_ID
        FROM OPERACION.SOLOT S
       WHERE S.CODSOLOT = LN_SOT_ANT;

      SGASI_PORTOUT_SOT(LV_CODCLI,
                        LN_TITRA,
                        LN_TIPSRV,
                        LN_MOTIVO,
                        LV_AREASOL,
                        PI_CO_ID,
                        LN_CUSTOMER_ID,
                        LN_SOT);

      BEGIN
      SGASI_PORTOUT_SOLOTPTO(LN_SOT, LN_SOT_ANT);
      EXCEPTION
        WHEN OTHERS THEN
          LV_MENSAJE   := 'Error durante la ejecucion de SGASI_PORTOUT_SOLOTPTO';
          RAISE EXC_BAJA;
      END;

      BEGIN
        INSERT INTO SALES.INT_PORTABILIDAD_DET
          (PROCESO_ID,
           SOT_ORI,
           COD_ID,
           TIPSRV,
           CODSRV,
           DSCSRV,
           CODINSSRV,
           PID,
           FLGPRINC,
           CODEQUCOM,
           IDSRV_SISACT,
           IDGRUPO_PRINCIPAL,
           IDGRUPO,
           CANTIDAD,
           DSCSRV_SISACT,
           BANDWID,
           FLAG_LC,
           TIPEQU,
           CODTIPEQU,
           DSCEQU,
           CODIGO_EXT
           )
          (SELECT DISTINCT
                L_PROCESO_ID,
                LN_SOT_ANT,
                S.COD_ID,
                (CASE WHEN TY.TIPSRV = LS_CABLE OR TY.TIPSRV = LS_INTERNET THEN
                      TY.TIPSRV ELSE I.TIPSRV END) TIPSRV,
                TY.CODSRV,
                TY.DSCSRV,
                I.CODINSSRV,
                PTO.PID,
                  p.flgprinc,
                  p.codequcom,
                  (SELECT sis.idservicio_sisact
                   FROM SALES.SERVICIO_SISACT SIS
                    WHERE SIS.CODSRV = PTO.CODSRVNUE) as idservicio_sisact,
                (SELECT CODIGOC
                FROM OPEDD
                WHERE TIPOPEDD IN
                     (SELECT TIPOPEDD
                        FROM TIPOPEDD
                       WHERE ABREV = 'CONF_ALTA_PORTOUT')
                 AND ABREVIACION = 'GRUPO_PRINC'
                 AND DESCRIPCION = PI_TECN -- 5.0
                 AND CODIGON_AUX = TO_NUMBER( (CASE WHEN TY.TIPSRV = LS_CABLE OR TY.TIPSRV = LS_INTERNET THEN
                                   TY.TIPSRV ELSE I.TIPSRV END))) IDGRUPO_PRINCIPAL,
                -- 5.0
                CASE 
                  WHEN PI_TECN = 'LTE' THEN 
                  (   SELECT IDGRUPO_SISACT
                      FROM SALES.GRUPO_SISACT_LTE P
                      WHERE IDPRODUCTO = TY.IDPRODUCTO ) 
                  WHEN PI_TECN = 'HFC' THEN 
                    (   SELECT IDGRUPO_SISACT
                      FROM SALES.GRUPO_SISACT P
                      WHERE IDPRODUCTO = TY.IDPRODUCTO ) 
                  END IDGRUPO,
                 --5.0
                  PTO.CANTIDAD CANTIDAD,
                  ( CASE WHEN P.CODEQUCOM IS NULL THEN TY.DSCSRV ELSE NULL END ) DSCSRV_SISACT,
                TY.BANWID,
                TY.FLAG_LC,
                (SELECT MIN(TIPEQU) FROM EQUCOMXOPE
                WHERE EQUCOMXOPE.CODEQUCOM = VT.CODEQUCOM  ) TIPEQU,
                (SELECT MIN(CODTIPEQU) FROM EQUCOMXOPE
                WHERE EQUCOMXOPE.CODEQUCOM = VT.CODEQUCOM  ) CODTIPEQU,
                VT.DSCEQU,
                SUBSTR(TY.CODIGO_EXT,1,50)
          FROM SOLOT S
          INNER JOIN SOLOTPTO PTO
             ON S.CODSOLOT = PTO.CODSOLOT
          INNER JOIN TYSTABSRV TY
             ON TY.CODSRV = PTO.CODSRVNUE
          INNER JOIN INSPRD P
             ON P.PID = PTO.PID
          INNER JOIN INSSRV I
             ON PTO.CODINSSRV = I.CODINSSRV
          LEFT JOIN VTAEQUCOM VT
             ON P.CODEQUCOM = VT.CODEQUCOM
           WHERE PTO.CODSOLOT = LN_SOT
           --4.0 Ini
           AND P.ESTINSPRD IN (SELECT O.CODIGON
                              FROM OPEDD O, TIPOPEDD T
                             WHERE O.TIPOPEDD = T.TIPOPEDD
                               AND T.ABREV = 'ESTSERV_PORTOUT'
                               AND O.CODIGON_AUX = 1));
           --4.0 Fin

          COMMIT;
       EXCEPTION
        WHEN OTHERS THEN
          LV_MENSAJE   := 'Error durante la generacion de SALES.INT_PORTABILIDAD_DET';
          RAISE EXC_BAJA;
      END;
    EXCEPTION
      WHEN OTHERS THEN
        RAISE EXC_BAJA;
    END;
    --- FIN GENERACION DE SOT

    --4.0 Ini
     BEGIN
      UPDATE SALES.INT_PORTABILIDAD T
         SET T.SOT_BAJA = LN_SOT, T.ESTADO = 1, T.SOT_ORI = LN_SOT_ANT
       WHERE NUMERO = PI_NUMERO
         AND T.PROCESO_ID = L_PROCESO_ID;
       COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
          LV_MENSAJE   := 'Error durante la actualizacion de SALES.INT_PORTABILIDAD';
          RAISE EXC_BAJA;
     END;

     COMMIT;
     --4.0 Fin
    --- ASIGNACION DE SERVICIO BSCS
    SGASU_PORTOUT_SERV_BSCS(L_PROCESO_ID,
                                   PI_CO_ID,
                                   PO_RESULTADO,
                                   PO_MENSAJE);


    --- INICIO ASIGNACION DE WF
    BEGIN
      SELECT CUSBRA.F_BR_SEL_WF(LN_SOT) INTO L_WF FROM DUAL; --4.0

      IF L_WF IS NOT NULL THEN  --4.0
      OPERACION.PQ_SOLOT.P_ASIG_WF(LN_SOT, L_WF);
      END IF;  --4.0

      COMMIT;

    EXCEPTION
      WHEN OTHERS THEN
        LV_MENSAJE   := 'Error Durante la Asignacion de WF.';
        RAISE EXC_BAJA;
    END;
    --- FIN ASIGNACION DE WF
    COMMIT;

    PO_MENSAJE := TO_CHAR(LN_SOT);

  EXCEPTION
    WHEN EXC_BAJA THEN
      PO_RESULTADO := -1;
      LV_PARAMETROS:= 'NUMERO: '     ||TO_CHAR(PI_NUMERO)||
                      CHR(13)||'CUSTOMER_ID: '||TO_CHAR(LN_CUSTOMER_ID)||
                      CHR(13)||'COD_ID: '     ||TO_CHAR(PI_CO_ID)||
                      CHR(13)||'SOT ORIGEN: ' ||TO_CHAR(LN_SOT_ANT)||
                      CHR(13)||'SOT BAJA: '   ||TO_CHAR(LN_SOT);
      PO_MENSAJE   := '>> Generacion de SOT de Baja:' ||
                      CHR(13)||LV_PARAMETROS||' '||
                      CHR(13)||LV_MENSAJE||
                      CHR(13)||'Linea Error:'||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE||
                      CHR(13)||SQLERRM;

      ROLLBACK;

      UPDATE SALES.INT_PORTABILIDAD T
         SET T.OBSERVACION = LV_MENSAJE
       WHERE NUMERO = PI_NUMERO
         AND T.PROCESO_ID = L_PROCESO_ID;
      COMMIT;

      SGASI_GENERA_LOG(
                      LV_PARAMETROS,
                      'SGASI_PORTOUT_SOT_BAJA',
                      PO_RESULTADO,
                      LV_MENSAJE);

    WHEN OTHERS THEN
      PO_RESULTADO := -1;
      LV_MENSAJE := 'Error en la generacion de SOT de Baja: ';
      LV_PARAMETROS:= 'NUMERO: '     ||TO_CHAR(PI_NUMERO)||
                      CHR(13)||'CUSTOMER_ID: '||TO_CHAR(LN_CUSTOMER_ID)||
                      CHR(13)||'COD_ID: '     ||TO_CHAR(PI_CO_ID)||
                      CHR(13)||'SOT ORIGEN: ' ||TO_CHAR(LN_SOT_ANT)||
                      CHR(13)||'SOT BAJA: '   ||TO_CHAR(LN_SOT);
      PO_MENSAJE   := '>> Generacion de SOT de Baja: ' ||
                      CHR(13)||LV_PARAMETROS||' '||
                      CHR(13)||LV_MENSAJE||
                      CHR(13)||'Linea Error:'||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE||
                      CHR(13)||SQLERRM;
      ROLLBACK;

      UPDATE SALES.INT_PORTABILIDAD T
         SET T.OBSERVACION = LV_MENSAJE
       WHERE NUMERO = PI_NUMERO
         AND T.PROCESO_ID = L_PROCESO_ID;
      COMMIT;

      SGASI_GENERA_LOG(
                      LV_PARAMETROS,
                      'SGASI_PORTOUT_SOT_BAJA',
                      PO_RESULTADO,
                      LV_MENSAJE);
  END;

  /************************************************************************************************************
  * NOMBRE SP            : SGASI_PORTOUT_SOT
  * PROPOSITO            : INSERTA SOT
  * INPUT                : PI_CODCLI   CODIGO DE CLIENTE
                           PI_TIPTRA   TIPO DE TRABAJO
                           PI_TIPSRV   TIPO DE SERVICIO
                           PI_MOTIVO   CODIGO DE MOTIVO
                           PI_AREASOL  AREA
  * OUTPUT               : PO_CODSOLOT CODIGO DE SOT
  * CREACION             : 03/08/2018 JENY VALENCIA
  '*************************************************************************************************************/
  PROCEDURE SGASI_PORTOUT_SOT(PI_CODCLI      IN OPERACION.SOLOT.CODCLI%TYPE,
                              PI_TIPTRA      IN OPERACION.SOLOT.TIPTRA%TYPE,
                              PI_TIPSRV      IN OPERACION.SOLOT.TIPSRV%TYPE,
                              PI_MOTIVO      IN OPERACION.SOLOT.CODMOTOT%TYPE,
                              PI_AREASOL     IN OPERACION.SOLOT.AREASOL%TYPE,
                              PI_COD_ID      IN OPERACION.SOLOT.COD_ID%TYPE,
                              PI_CUSTOMER_ID IN OPERACION.SOLOT.CUSTOMER_ID%TYPE,
                              PO_CODSOLOT    OUT NUMBER) IS
  BEGIN
    PO_CODSOLOT := F_GET_CLAVE_SOLOT();
    BEGIN
      INSERT INTO SOLOT
        (CODSOLOT,
         CODCLI,
         ESTSOL,
         TIPTRA,
         TIPSRV,
         CODMOTOT,
         AREASOL,
         COD_ID,
         CUSTOMER_ID)
      VALUES
        (PO_CODSOLOT,
         PI_CODCLI,
         10,
         PI_TIPTRA,
         PI_TIPSRV,
         PI_MOTIVO,
         PI_AREASOL,
         PI_COD_ID,
         PI_CUSTOMER_ID);

    EXCEPTION
      WHEN OTHERS THEN
           SGASI_GENERA_LOG(
                        CHR(13)||'CUSTOMER_ID: '||TO_CHAR(PI_CUSTOMER_ID)||
                        CHR(13)||'COD_ID: '     ||TO_CHAR(PI_COD_ID)||
                        CHR(13)||'SOT BAJA: '   ||TO_CHAR(PO_CODSOLOT),
                       'SGASI_PORTOUT_SOT',
                       SQLCODE,
                       '>> Generacion de SOT de Baja: ' ||'ERROR AL INSERTAR SOT: '||SQLERRM);
    END;
  END;
  /*************************************************************************************************************
  * NOMBRE SP            : SGASI_PORTOUT_SOLOTPTO
  * PROPOSITO            : INSERTA SOLOTPTO
  * INPUT                : PI_CODSOLOT  CODIGO DE SOT
                           PI_COD_ID    CODIGO DE CONTRATO
  * OUTPUT               :
  * CREACION             : 03/08/2018 JENY VALENCIA
  '*************************************************************************************************************/
  PROCEDURE SGASI_PORTOUT_SOLOTPTO(PI_CODSOLOT       IN SOLOT.CODSOLOT%TYPE,
                                   PI_CODSOLOT_ORI   IN SOLOT.CODSOLOT%TYPE) IS

    LN_SOLOTPTO   OPERACION.SOLOTPTO%ROWTYPE;
    LN_VAL_DET    NUMBER;
    LN_PUNTO      NUMBER;
    EXC           EXCEPTION;

    CURSOR C_SERVICIOS IS
      SELECT DISTINCT PTO.CODSOLOT, PTO.PUNTO, PTO.CODINSSRV, PTO.PID
      FROM SOLOT S
      INNER JOIN SOLOTPTO PTO
       ON S.CODSOLOT = PTO.CODSOLOT
      AND S.ESTSOL IN
          (select o.codigon
             from tipopedd t, opedd o
            where t.tipopedd = o.tipopedd
              and t.abrev = 'CONFSERVADICIONAL'
              and o.abreviacion = 'ESTSOL_MAXALTA')
      AND S.TIPTRA IN (select o.codigon
              from tipopedd t, opedd o
             where t.tipopedd = o.tipopedd
               and t.abrev = 'TIPREGCONTIWSGABSCS')
      INNER JOIN TYSTABSRV TY
       ON TY.CODSRV = PTO.CODSRVNUE
      INNER JOIN INSSRV I
       ON PTO.CODINSSRV = I.CODINSSRV
         --4.0 Ini
         AND I.ESTINSSRV IN (SELECT O.CODIGON
                              FROM OPEDD O, TIPOPEDD T
                             WHERE O.TIPOPEDD = T.TIPOPEDD
                               AND T.ABREV = 'ESTSERV_PORTOUT'
                               AND O.CODIGON_AUX = 1)
         --4.0
      INNER JOIN INSPRD P
       ON P.PID = PTO.PID
         --4.0 Ini
         AND P.ESTINSPRD IN (SELECT O.CODIGON
                              FROM OPEDD O, TIPOPEDD T
                             WHERE O.TIPOPEDD = T.TIPOPEDD
                               AND T.ABREV = 'ESTSERV_PORTOUT'
                               AND O.CODIGON_AUX = 1)
         --4.0 Fin
      WHERE S.CODSOLOT IN
            (SELECT DISTINCT PT.CODSOLOT  --4.0
             FROM SOLOTPTO PT
            INNER JOIN INSSRV INS
               ON INS.CODINSSRV = PT.CODINSSRV
              AND PT.CODINSSRV IN
                    (SELECT PTOP.CODINSSRV  --4.0
                       FROM SOLOTPTO PTOP   --4.0
                      WHERE PTOP.CODSOLOT = PI_CODSOLOT_ORI)) --4.0
      ORDER BY PTO.CODSOLOT, PTO.PUNTO;
  BEGIN
    FOR C_SERV IN C_SERVICIOS LOOP
      LN_VAL_DET := 0;

      SELECT COUNT(1)
        INTO LN_VAL_DET
        FROM SOLOTPTO
       WHERE CODSOLOT = PI_CODSOLOT
         AND CODINSSRV = C_SERV.CODINSSRV
         AND PID = C_SERV.PID;

      IF LN_VAL_DET = 0  THEN

        SELECT *
          INTO LN_SOLOTPTO
          FROM SOLOTPTO
         WHERE CODSOLOT = C_SERV.CODSOLOT
           AND PUNTO = C_SERV.PUNTO;

        LN_SOLOTPTO.CODSOLOT := PI_CODSOLOT;
        LN_SOLOTPTO.PUNTO    := NULL;
        OPERACION.PQ_SOLOT.P_INSERT_SOLOTPTO(LN_SOLOTPTO, LN_PUNTO);
      END IF;
    END LOOP;
    COMMIT;

    EXCEPTION
      WHEN OTHERS THEN
           SGASI_GENERA_LOG('SOT ORIGEN: '||TO_CHAR(PI_CODSOLOT_ORI),
                       'SGASI_PORTOUT_SOLOTPTO',
                       SQLCODE,
                       '>> Generacion de SOT de Baja: ' ||'ERROR AL INSERTAR SOLOTPTO: '||SQLERRM);
  END;
  /************************************************************************************************************
  * NOMBRE SP            : SGASI_PORTOUT_CARGA
  * PROPOSITO            : REGISTRA Y EVALUA NUMEROS PORT OUT.
                           PI_TRAMA_LINEA.
  * INPUT                : PI_TRAMA_LINEA NUMEROS PORT OUT CONCATENADOS MEDIANTE "|".
  * OUTPUT               : PO_TRAMA_EVAL  CURSOR CON LOS SIGUIENTE CAMPOS:
                                          * COD_ID      CODIGO DE CONTRATO
                                          * NUMERO      NUMERO PORTOUT
                                          * TECN        TECNOLOGIA
                                          * ESTADO      RESULTADO EVALUACION.
                                          * OBSERVACION DETALLE DE EVALUCION.
  * CREACION             : 31/07/2018 JENY VALENCIA
  * ACTUALIZACION        : 03/08/2018 JOSE VARILLAS
                         : 18/09/2018 JENY VALENCIA
  '************************************************************************************************************/
  PROCEDURE SGASI_PORTOUT_CARGA(PI_TRAMA_LINEA IN VARCHAR2,
                                PO_TRAMA_EVAL  OUT SYS_REFCURSOR) IS
    LN_STB        VARCHAR2(32000);
    L_NUMEROS     NUMEROS_TYPE;
    L_NUMERO      NUMERO_TYPE;
    L_FILAS       NUMBER := 0;
    L_TECNOLOGIA  VARCHAR2(50);
    L_CODSOLOT    NUMBER := 0;
    L_VAL         NUMBER;
    L_PROCESO_ID  NUMBER := 0;
    L_COD_ID      NUMBER;
    L_EST         NUMBER;
    L_OBSV        SALES.INT_PORTABILIDAD.OBSERVACION%TYPE;  --4.0
    L_CUSTOMER_ID NUMBER;
    L_EXCP EXCEPTION;
    L_VAL_DET NUMBER := 0;
    L_ESTADO  NUMBER := 0;
    L_MENSAJE     SALES.INT_PORTABILIDAD_LOG.MENSAJE%TYPE; --4.0

  BEGIN
    LN_STB    := PI_TRAMA_LINEA;
    L_NUMEROS := SGAFUN_CARGAR_ARRAY(LN_STB);
    L_FILAS   := L_NUMEROS.COUNT;

    SELECT SALES.SQ_PORTABILIDAD.NEXTVAL INTO L_PROCESO_ID FROM DUAL;

    IF L_FILAS > 0 THEN
      FOR IDX IN 1 .. L_FILAS LOOP
        L_NUMERO   := L_NUMEROS(IDX);
        L_CODSOLOT := 0;
        L_VAL      := 0;
        L_VAL_DET  := 0;
        L_ESTADO   := 0;

        BEGIN
          SELECT COUNT(1)
            INTO L_VAL
            FROM SALES.INT_PORTABILIDAD
           WHERE NUMERO = L_NUMERO.NUMERO;

          IF L_VAL <> 0 THEN
            SELECT ESTADO
              INTO L_ESTADO
              FROM SALES.INT_PORTABILIDAD
             WHERE NUMERO = L_NUMERO.NUMERO;

            IF L_ESTADO IN (0, -1) THEN
              UPDATE SALES.INT_PORTABILIDAD
                 SET PROCESO_ID = L_PROCESO_ID
               WHERE NUMERO = L_NUMERO.NUMERO;
            END IF;
          ELSE
            INSERT INTO SALES.INT_PORTABILIDAD
              (PROCESO_ID, NUMERO, ESTADO, OBSERVACION)
            VALUES
              (L_PROCESO_ID, L_NUMERO.NUMERO, 0, 'LINEA LISTA PARA PORTAR');
          END IF;

        EXCEPTION
          WHEN OTHERS THEN
               SGASI_GENERA_LOG(
                           'PROCESO_ID:'  ||TO_CHAR(L_PROCESO_ID)||
                            CHR(13)||'NUMERO: '||TO_CHAR(L_NUMERO.NUMERO),
                           'SGASI_PORTOUT_CARGA',
                            SQLCODE,
                           'ERROR AL INSERTAR NUMERO EN INT_PORTABILIDAD: '||SQLERRM);
        END;

        IF L_ESTADO IN (0, -1) THEN
          BEGIN -- 6.0
          SGASS_VALIDA_NUM_PORT(L_NUMERO.NUMERO,
                                L_CODSOLOT,
                                L_COD_ID,
                                L_TECNOLOGIA,
                                L_CUSTOMER_ID,
                                L_EST,
                                L_OBSV);

          UPDATE SALES.INT_PORTABILIDAD
             SET SOT_ORI     = L_CODSOLOT,
                 TECN        = L_TECNOLOGIA,
                 COD_ID      = L_COD_ID,
                 CUSTOMER_ID = L_CUSTOMER_ID,
                 ESTADO      = L_EST,
                 OBSERVACION = L_OBSV
           WHERE NUMERO = L_NUMERO.NUMERO
             AND PROCESO_ID = L_PROCESO_ID;
          -- INI 6.0
          EXCEPTION
            WHEN OTHERS THEN
                 L_MENSAJE := SUBSTR('Error : '||SQLERRM ||' - Linea ('|| DBMS_UTILITY.FORMAT_ERROR_BACKTRACE||')',1,4000);
                 SGASI_GENERA_LOG(
                             'PROCESO_ID:'  ||TO_CHAR(L_PROCESO_ID)||
                              CHR(13)||'NUMERO: '||TO_CHAR(L_NUMERO.NUMERO),
                             'SGASI_PORTOUT_CARGA',
                              SQLCODE,
                             'ERROR AL VALIDAR NUMERO EN INT_PORTABILIDAD: '||L_MENSAJE);
          END;
          -- FIN 6.0
        END IF;
      END LOOP;
    END IF;
    COMMIT;

    OPEN PO_TRAMA_EVAL FOR
      SELECT T1.COD_ID, T1.NUMERO, T1.TECN, T1.ESTADO, T1.OBSERVACION
        FROM SALES.INT_PORTABILIDAD T1
       WHERE PROCESO_ID = L_PROCESO_ID;

  EXCEPTION
    WHEN OTHERS THEN
     L_MENSAJE := SUBSTR('Error : '||SQLERRM ||' - Linea ('|| DBMS_UTILITY.FORMAT_ERROR_BACKTRACE||')',
     1,4000); --4.0
     SGASI_GENERA_LOG(
                 'PROCESO_ID: '||TO_CHAR(L_PROCESO_ID),
                 'SGASI_PORTOUT_CARGA',
                 SQLCODE,
                 L_MENSAJE);  --4.0
  END;
  /***********************************************************************************************************
  * NOMBRE P             : SGAFUN_CARGAR_ARRAY
  * PROPOSITO            : INSERTA LOS NUMEROS CONCATENADOS EN UNA TABLA RECORD.
  * INPUT                : PI_STRING     NUMEROS PORT OUT CONCATENADOS MEDIANTE "|".
  * OUTPUT               : NUMEROS_TYPE  TABLA CON LOS SIGUIENTES CAMPOS:
                                         * NUMERO      NUMERO PORTOUT
  * CREACION             : 31/07/2018 JENY VALENCIA
  '**********************************************************************************************************/
  FUNCTION SGAFUN_CARGAR_ARRAY(PI_STRING VARCHAR2) RETURN NUMEROS_TYPE IS
    L_DELIMITER NUMBER;
    L_POINTER   NUMBER;
    L_STRING    VARCHAR2(32767);
    L_ROWS      NUMBER := 0;
    L_VALUE     VARCHAR2(1);
    L_LENGTH    NUMBER;
    L_NUMEROS   NUMEROS_TYPE;
    L_NUMERO    NUMERO_TYPE;

  BEGIN

    L_STRING := PI_STRING;

    IF SUBSTR(PI_STRING, LENGTH(L_STRING), 1) <> '|' THEN
      L_STRING := L_STRING || '|';
    END IF;
    IF SUBSTR(L_STRING, 1, 1) = '|' THEN
      L_STRING := SUBSTR(L_STRING, 2, LENGTH(L_STRING) - 1);
    END IF;

    L_POINTER := 1;
    L_LENGTH  := LENGTH(L_STRING);

    FOR IDX IN 1 .. L_LENGTH LOOP
      L_VALUE := SUBSTR(L_STRING, IDX, 1);
      IF L_VALUE = '|' THEN
        L_ROWS := L_ROWS + 1;
      END IF;
    END LOOP;

    FOR IDX IN 1 .. L_ROWS LOOP
      L_DELIMITER := INSTR(L_STRING, '|', 1, IDX);
      L_NUMERO.NUMERO := SUBSTR(L_STRING,
                                L_POINTER,
                                L_DELIMITER - L_POINTER);
      L_NUMEROS(IDX) := L_NUMERO;
      L_POINTER := L_DELIMITER + 1;
    END LOOP;

    RETURN L_NUMEROS;

  EXCEPTION
    WHEN OTHERS THEN
     SGASI_GENERA_LOG(
                 NULL,
                 'SGAFUN_CARGAR_ARRAY',
                 SQLCODE,
                 SUBSTR(PI_STRING,1,2000)||' '||SQLERRM);

  END;
  /*************************************************************************************************************
  * NOMBRE SP            : SGASS_VALIDA_NUM_PORT
  * PROPOSITO            : VALIDA LINEAS PORT OUT
  * INPUT                : PI_NUM          NUMERO PORT OUT
  * OUTPUT               : PO_SOT          NUMERO DE SOT
                           PO_CODID        CODIGO DE CONTRATO
                           PO_TECNOLOGIA   TIPO DE TECNOLOGIA ( HFC, LTE )
                           PO_CODERR       CODIGO DE ERROR
                           PO_MSJERR       MENSAJE DE ERROR
  * CREACION             : 31/07/2018 JENY VALENCIA
  * ACTUALIZACION        : 03/08/2018 JOSE VARILLAS
                           11/10/2018 JENY VALENCIA
  '***********************************************************************************************************/
  PROCEDURE SGASS_VALIDA_NUM_PORT(PI_NUM         IN VARCHAR2,
                                  PO_SOT         OUT NUMBER,
                                  PO_CODID       OUT NUMBER,
                                  PO_TECNOLOGIA  OUT VARCHAR2,
                                  PO_CUSTOMER_ID OUT NUMBER,
                                  PO_CODERR      OUT NUMBER,
                                  PO_MSJERR      OUT VARCHAR2) IS

    L_VAL    NUMBER;
    L_CODERR NUMBER;
    L_MSJERR VARCHAR2(100);
    L_EXCEPT EXCEPTION;
 
    L_STATUS_CONTRATO NUMBER;--6.0

  BEGIN
    PO_CODERR := 0;
    PO_MSJERR := 'LINEA LISTA PARA PORTAR';
    --VALIDAMOS REGISTRO EN LA NUMTEL
    SELECT COUNT(1) INTO L_VAL FROM NUMTEL WHERE NUMERO = PI_NUM;

    IF L_VAL = 0 THEN
      L_CODERR := -1;
      L_MSJERR := 'LA LINEA NO SE ENCUENTRA REGISTRADA EN SGA';
      RAISE L_EXCEPT;
    END IF;
    --VALIDAMOS ASOCIACION DE LA LINEA CON SERVICIO ACTIVO
    SELECT COUNT(1)
      INTO L_VAL
      FROM NUMTEL N, INSSRV INS
     WHERE INS.CODINSSRV = N.CODINSSRV
       AND N.NUMERO = INS.NUMERO
       AND N.NUMERO = PI_NUM
       AND INS.ESTINSSRV = 1;

    IF L_VAL = 0 THEN
      L_CODERR := -1;
      L_MSJERR := 'LA LINEA NO TIENE UN SERVICIO ACTIVO ASOCIADO';
      RAISE L_EXCEPT;
    END IF;
    --VALIDAMOS QUE LA LINEA SE ENCUENTRE EN UN CONTRATO ACTIVO
    BEGIN
      SELECT DISTINCT S.COD_ID
        INTO PO_CODID
        FROM INSSRV INS
       INNER JOIN NUMTEL NTL
          ON INS.NUMERO = NTL.NUMERO
         AND INS.CODINSSRV = NTL.CODINSSRV
       INNER JOIN SOLOTPTO PTO
          ON PTO.CODINSSRV = INS.CODINSSRV
       INNER JOIN SOLOT S
          ON PTO.CODSOLOT = S.CODSOLOT
       WHERE INS.NUMERO = PI_NUM
         AND INS.ESTINSSRV = 1
         AND NTL.ESTNUMTEL = 2
         AND S.COD_ID IS NOT NULL;

      PO_SOT := OPERACION.PQ_SGA_IW.F_MAX_SOT_X_COD_ID(PO_CODID);

      SELECT CUSTOMER_ID
        INTO PO_CUSTOMER_ID
        FROM SOLOT
       WHERE CODSOLOT = PO_SOT;

    EXCEPTION
      WHEN OTHERS THEN
        PO_SOT   := NULL;
        PO_CODID := NULL;
        L_CODERR := -1;
        L_MSJERR := 'NO SE ENCONTRO CONTRATO ACTIVO PARA LA LINEA';
        RAISE L_EXCEPT;
    END;
    --INI 6.0
     L_STATUS_CONTRATO := OPERACION.PQ_SGA_IW.F_VAL_STATUS_CONTRATO(PO_CODID);

     IF L_STATUS_CONTRATO = 0 THEN
        L_CODERR := -1;
        L_MSJERR := 'EL CONTRATO SE ENCUENTRA EN ESTADO ONHOLD O ACTIVO CON PENDIENTE';
        RAISE L_EXCEPT;
     ELSIF L_STATUS_CONTRATO = 2 OR L_STATUS_CONTRATO = 3 THEN
        L_CODERR := -1;
        L_MSJERR := 'EL CONTRATO SE ENCUENTRA EN ESTADO SUSPENDIDO';
        RAISE L_EXCEPT;
     ELSIF L_STATUS_CONTRATO = 4 OR L_STATUS_CONTRATO = 5 THEN
        L_CODERR := -1;
        L_MSJERR := 'EL CONTRATO SE ENCUENTRA EN ESTADO DESACTIVO';
        RAISE L_EXCEPT;
     END IF;
    --FIN 6.0

    --2.0 Ini
    --VALIDAMOS LINEA EN BSCS
    OPERACION.PQ_CONT_REGULARIZACION.p_valida_linea_bscs(PI_NUM, L_CODERR, L_MSJERR);

    if L_CODERR = 0 then
       L_CODERR  := -1;
       RAISE L_EXCEPT;
    end if;

    --VALIDAMOS LINEA EN JANUS
    L_CODERR := OPERACION.PQ_SGA_JANUS.f_val_exis_linea_janus(PI_NUM);

    if L_CODERR = 0 then
    L_CODERR     := -1;
    RAISE L_EXCEPT;
    end if;
    --2.0 Fin

   SELECT TECNOLOGIA
   INTO PO_TECNOLOGIA
   FROM (SELECT 'HFC' AS TECNOLOGIA
           FROM SYSADM.CONTRACT_ALL@DBL_BSCS_BF     CA,
                SYSADM.CONTRACT_HISTORY@DBL_BSCS_BF CH,
                SYSADM.CUSTOMER_ALL@DBL_BSCS_BF     CC
          WHERE CA.CO_ID = CH.CO_ID
            AND CA.SCCODE = 6
            AND CA.CUSTOMER_ID = CC.CUSTOMER_ID
            AND CH.CH_SEQNO = (SELECT MAX(CH_SEQNO)
                                 FROM SYSADM.CONTRACT_HISTORY@DBL_BSCS_BF C
                                WHERE CO_ID = CH.CO_ID)
                AND UPPER(CH.CH_STATUS) IN ('A')
            AND CA.CO_ID = PO_CODID
         UNION
         SELECT 'LTE' AS TECNOLOGIA
           FROM SYSADM.CONTRACT_ALL@DBL_BSCS_BF     CA1,
                SYSADM.CONTRACT_HISTORY@DBL_BSCS_BF CH1,
                SYSADM.CUSTOMER_ALL@DBL_BSCS_BF     CC1
          WHERE CA1.CO_ID = CH1.CO_ID
            AND CA1.CUSTOMER_ID = CC1.CUSTOMER_ID
            AND CA1.TMCODE IN
                (select codigon
                   from opedd o, tipopedd t
                  where o.tipopedd = t.tipopedd
                    and t.abrev = 'CONF_ALTA_PORTOUT'
                    and o.abreviacion = 'TMCODE')
            AND CH1.CH_SEQNO =
                (SELECT MAX(CH_SEQNO)
                   FROM SYSADM.CONTRACT_HISTORY@DBL_BSCS_BF
                  WHERE CO_ID = CH1.CO_ID)
                AND UPPER(CH1.CH_STATUS) IN ('A')
            AND CA1.CO_ID = PO_CODID) C
  GROUP BY TECNOLOGIA;

  EXCEPTION
    WHEN L_EXCEPT THEN
      PO_CODERR := L_CODERR;
      PO_MSJERR := L_MSJERR;

      SGASI_GENERA_LOG(
                'NUMERO: '||TO_CHAR(PI_NUM)||
                CHR(13)||'CUSTOMER_ID: '||TO_CHAR(PO_CUSTOMER_ID)||
                CHR(13)||'COD_ID: '     ||TO_CHAR(PO_CODID)||
                CHR(13)||'SOT ORIGEN: ' ||TO_CHAR(PO_SOT),
                 'SGASS_VALIDA_NUM_PORT',
                 SQLCODE,
                 L_MSJERR||': '||CHR(13)||'Linea Error: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE||NVL(SQLERRM,''));
  END;
  /*************************************************************************************************************
  * NOMBRE SP            : SGASU_PORTOUT_CIERRE_SOT
  * PROPOSITO            : CIERRE DE SOT DE BAJA PENDIENTES SEGUN SALES.INT_PORTABILIDAD
  * INPUT                :
  * OUTPUT               : PO_CURSOR    CURSOR CON LOS SIGUIENTES CAMPOS:
                                       SOT_BAJA    : NUMERO DE SOT DE BAJA
                                       COD_ID      : CODIGO DE CONTRATO
                                       NUMERO      : NUMERO DE LINEA
                                       ESTADO      : ESTADO DE SOLICITUD PORT OUT
                                       OBSERVACION : OBSERVACION DE PORT OUT
                           PO_CODERROR  CODIGO DE ERROR
                           PO_MSJERROR  MENSAJE DE ERROR
  * CREACION             : 03/08/2018 JOSE VARILLAS
  '************************************************************************************************************/
  PROCEDURE SGASU_PORTOUT_CIERRE_SOT(PO_CODERROR OUT NUMBER,
                                     PO_MSJERROR OUT VARCHAR2) IS
    L_VAL NUMBER;
    L_SOT NUMBER;
    L_EXCEPT EXCEPTION;
    V_COD NUMBER;
    V_MSJ VARCHAR2(50); 

    CURSOR C1 IS
      SELECT * FROM SALES.INT_PORTABILIDAD T1 WHERE T1.ESTADO = 2;

    CURSOR C2 IS
      SELECT T2.IDTAREAWF
        FROM WF T1, TAREAWF T2
       WHERE T2.IDWF = T2.IDWF
         AND T1.CODSOLOT = L_SOT;

  BEGIN
    PO_CODERROR := 0;
    PO_MSJERROR := 'SE COMPLETO EL PROCESO DE CIERRE DE SOTS';

    FOR LC1 IN C1 LOOP
      BEGIN
        SELECT DISTINCT T1.SOT_ALTA
          INTO L_SOT
          FROM SALES.INT_PORTABILIDAD_DET T1
         WHERE T1.PROCESO_ID = LC1.PROCESO_ID
           AND T1.COD_ID = LC1.COD_ID;

        FOR LC2 IN C2 LOOP

          SGASU_PORTOUT_CIERRE_TAREA(L_SOT, V_COD, V_MSJ);

          SELECT ESTSOL INTO L_VAL FROM SOLOT WHERE CODSOLOT = L_SOT;

          IF L_VAL = 12 OR V_COD = -1 THEN
            PO_CODERROR := V_COD;
            PO_MSJERROR := V_MSJ;
            EXIT;
          END IF;

        END LOOP;

        SELECT ESTSOL INTO L_VAL FROM SOLOT WHERE CODSOLOT = L_SOT;

        IF L_VAL <> 12 OR L_VAL <> 29 THEN

          UPDATE SALES.INT_PORTABILIDAD
             SET OBSERVACION = 'NO SE PUDO COMPLETAR EL CIERRE AUTOMATICO'
           WHERE NUMERO = LC1.NUMERO
             AND PROCESO_ID = LC1.PROCESO_ID
             AND ESTADO = 2;
        ELSE
          UPDATE SALES.INT_PORTABILIDAD
             SET ESTADO = 3
           WHERE NUMERO = LC1.NUMERO
             AND PROCESO_ID = LC1.PROCESO_ID
             AND ESTADO = 2;
        END IF;

      EXCEPTION
        WHEN OTHERS THEN

          UPDATE SALES.INT_PORTABILIDAD
             SET OBSERVACION = 'NO SE PUDO COMPLETAR EL CIERRE AUTOMATICO'
           WHERE NUMERO = LC1.NUMERO
             AND PROCESO_ID = LC1.PROCESO_ID
             AND ESTADO = 2;
          COMMIT;
      END;
    END LOOP;

    SGASU_PORTOUT_SET_CONTR(V_COD, V_MSJ);
    IF V_COD <> 0 THEN 
       PO_CODERROR := V_COD;
       PO_MSJERROR := V_MSJ; 
       RETURN; 
    END IF;

  EXCEPTION
    WHEN OTHERS THEN
      PO_CODERROR := -1;
      PO_MSJERROR := 'ERROR EN LA EJECUCION DE CIERRE DE SOTS DE BAJA: '||SQLERRM;

      SGASI_GENERA_LOG(NULL,
                   'SGASU_PORTOUT_CIERRE_SOT',
                   SQLCODE,
                   PO_MSJERROR);

      RAISE_APPLICATION_ERROR(-20001, PO_MSJERROR);

  END;
  /************************************************************************************************************
  * NOMBRE SP            : SGASU_PORTOUT_CIERRE_TAREA
  * PROPOSITO            : CIERRE DE TAREA DE SOT DE BAJA PENDIENTES SEGUN SALES.INT_PORTABILIDAD
  * INPUT                : SOT    : NUMERO DE SOT
  * OUTPUT               :
                           PO_CODERROR  CODIGO DE ERROR
                           PO_MSJERROR  MENSAJE DE ERROR
  * CREACION             : 03/08/2018 JOSE VARILLAS
  '************************************************************************************************************/
  PROCEDURE SGASU_PORTOUT_CIERRE_TAREA(PI_CODSOLOT IN OPERACION.SOLOT.CODSOLOT%TYPE,
                                       PO_CODERROR OUT NUMBER,
                                       PO_MSJERROR OUT VARCHAR2) IS
    L_SOT NUMBER;
    L_EXCEPT EXCEPTION;
    L_TARADF NUMBER;

    CURSOR C1 IS
      SELECT DECODE(E.TAREADEF, 779, NULL, 299, 'ACTIV', 'TAREA') SENTENCIA,
             F.IDTAREAWF,
             E.TAREADEF
        FROM WF W, TAREAWF F, TAREADEF E, ESTTAREA T, SOLOT S
       WHERE W.IDWF = F.IDWF
         AND F.TAREADEF = E.TAREADEF
         AND F.ESTTAREA = T.ESTTAREA
         AND W.VALIDO = 1
         AND F.ESTTAREA NOT IN (4, 8)
         AND W.CODSOLOT = S.CODSOLOT
         AND W.CODSOLOT IN (PI_CODSOLOT);

  BEGIN
    PO_CODERROR := 0;
    PO_MSJERROR := 'SE COMPLETO EL CIERRE DE LA TAREA';

    FOR LC1 IN C1 LOOP
      BEGIN
        L_SOT := PI_CODSOLOT;
        IF LC1.SENTENCIA = 'ACTIV' THEN
          OPERACION.P_EJECUTA_ACTIV_DESACTIV(L_SOT, 299, SYSDATE);
        ELSIF LC1.SENTENCIA = 'TAREA' THEN
          IF LC1.TAREADEF = 667 THEN
            L_TARADF := 8;
          ELSIF LC1.TAREADEF = 668 THEN
            L_TARADF := 8;
          ELSE
            L_TARADF := 4;
          END IF;
          OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(LC1.IDTAREAWF,
                                           4,
                                           L_TARADF,
                                           NULL,
                                           SYSDATE,
                                           SYSDATE);
        END IF;

      EXCEPTION
        WHEN OTHERS THEN
          PO_CODERROR := -1;
          PO_MSJERROR := 'ERROR EN LA EJECUCION DE CIERRE DE SOTS';
      END;

    END LOOP;

  EXCEPTION
    WHEN OTHERS THEN
      PO_CODERROR := -1;
      PO_MSJERROR := 'ERROR EN LA EJECUCION DE CIERRE DE TAREAS, SOT DE BAJA: '||SQLERRM;

      SGASI_GENERA_LOG(NULL,
                   'SGASU_PORTOUT_CIERRE_TAREA',
                   SQLCODE,
                   PO_MSJERROR);

      RAISE_APPLICATION_ERROR(-20001, PO_MSJERROR);
  END;
  /***********************************************************************************************************
  * NOMBRE SP            : SGASU_WF_ACT_DES_JANUS
  * PROPOSITO            : DESACTIVA LINEA JANUS
  * INPUT                : PI_IDTAREAWF  ID TAREA WORKFLOW SOT
                           PI_IDWF       ID WORKFLOW SOT
                           PI_TAREA      NUMERO DE TAREA WORKFLOW
                           PI_TAREADEF   NUMERO DE TAREADEF
  * OUTPUT               :
  * CREACION             : 03/08/2018 JOSE VARILLAS
  '************************************************************************************************************/
  PROCEDURE SGASU_WF_ACT_DES_JANUS(PI_IDTAREAWF IN NUMBER,
                                   PI_IDWF      IN NUMBER,
                                   PI_TAREA     IN NUMBER,
                                   PI_TAREADEF  IN NUMBER) IS
    L_CODSOLOT    SOLOT.CODSOLOT%TYPE;
    L_MENSAJE     VARCHAR2(4000);
    L_ERROR       NUMBER;
    LV_TECNOLOGIA SALES.INT_PORTABILIDAD.TECN%TYPE;
    L_EXCEPT EXCEPTION;
  BEGIN
 
    SELECT CODSOLOT INTO L_CODSOLOT FROM WF WHERE IDWF = PI_IDWF;
 
    SELECT DISTINCT P.TECN
      INTO LV_TECNOLOGIA
      FROM SALES.INT_PORTABILIDAD P
     WHERE P.SOT_BAJA = L_CODSOLOT;
 
    IF LV_TECNOLOGIA = 'HFC' THEN
 
      OPERACION.PQ_SGA_JANUS.P_BAJA_JANUS(L_CODSOLOT, L_ERROR, L_MENSAJE);
 
    ELSIF LV_TECNOLOGIA = 'LTE' THEN
      OPERACION.PQ_SGA_JANUS.P_BAJA_LINEA_JANUS_LTE(L_CODSOLOT,
                                                    L_ERROR,
                                                    L_MENSAJE);
    END IF;
 
    IF L_ERROR = -1 THEN
      RAISE L_EXCEPT;
    END IF;
 
  EXCEPTION
    WHEN L_EXCEPT THEN
      OPERACION.PKG_PORTABILIDAD.SGASI_GENERA_LOG('SOT BAJA: ' ||
                                                  TO_CHAR(L_CODSOLOT) ||
                                                  CHR(13) ||
                                                  'Linea Error: ' ||
                                                  DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                                  'SGASU_WF_ACT_DES_JANUS',
                                                  SQLCODE,
                                                  'ERROR AL REALIZAR ACT/DES JANUS: ' ||
                                                  L_MENSAJE);
      RAISE_APPLICATION_ERROR(-20001, L_MENSAJE);
    WHEN OTHERS THEN
      OPERACION.PKG_PORTABILIDAD.SGASI_GENERA_LOG('SOT BAJA: ' ||
                                                  TO_CHAR(L_CODSOLOT)||
                                                  CHR(13) ||
                                                  'Linea Error: ' ||
                                                  DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                                  'SGASU_WF_ACT_DES_JANUS',
                                                  SQLCODE,
                                                  'ERROR AL REALIZAR ACT/DES JANUS: ' ||
                                                  SQLERRM);
      RAISE_APPLICATION_ERROR(-20001, SQLERRM);
  END;
  /***********************************************************************************************************
  * NOMBRE SP            : SGASU_PORTOUT_DESH_NUM
  * PROPOSITO            : DESHABILITA NUMERO POR OUT ACTUALIZANDO ESTADO EN NUMTEL
  * INPUT                : PI_CODSOLOT  NUMERO DE SOT
  * OUTPUT               : PO_RESULTADO RESULTADO
                           PO_MENSAJE   MENSAJE
  * CREACION             : 08/08/2018 JENY VALENCIA
  '***********************************************************************************************************/
  PROCEDURE SGASU_PORTOUT_DESH_NUM(PI_CODSOLOT  IN NUMBER,
                                   PO_RESULTADO OUT NUMBER,
                                   PO_MENSAJE   OUT VARCHAR2) IS

    C_RESERVA_PORTOUT CONSTANT NUMTEL.ESTNUMTEL%TYPE := 12;
    L_NUMERO   NUMTEL.NUMERO%TYPE;
    L_PORTABLE NUMBER;
  BEGIN

    SELECT NUMERO
      INTO L_NUMERO
      FROM SALES.INT_PORTABILIDAD
     WHERE SOT_BAJA = PI_CODSOLOT;

    SELECT FLG_PORTABLE
      INTO L_PORTABLE
      FROM NUMTEL
     WHERE NUMERO = L_NUMERO;

    IF L_PORTABLE = 1 THEN
      DELETE FROM NUMTEL WHERE NUMERO = L_NUMERO;
    ELSE
      UPDATE NUMTEL T
         SET T.ESTNUMTEL = C_RESERVA_PORTOUT
       WHERE T.NUMERO = L_NUMERO;
    END IF;

  EXCEPTION
    WHEN OTHERS THEN
      PO_RESULTADO := -1;
      PO_MENSAJE   := SQLERRM;

      SGASI_GENERA_LOG(
                'NUMERO: '     ||TO_CHAR(L_NUMERO)||
                CHR(13)||'SOT ORIGEN: ' ||TO_CHAR(PI_CODSOLOT)||
                CHR(13)||'Linea Error: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                 'SGASU_PORTOUT_DESH_NUM',
                 SQLCODE,
                 'WF de SOT de Baja: ' ||'ERROR AL DESHABILITAR NUMERO: '||SQLERRM);

      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.SGASU_POROUT_DESC_NUM(): ' ||
                              SQLERRM);
  END;
  /************************************************************************************************************
  * NOMBRE SP            : SGASU_WF_ACT_DES_IL
  * PROPOSITO            : INSERTA SOLICITUD DE DESACTIVACION IL.
  * INPUT                : PI_IDTAREAWF  ID TAREA WORKFLOW SOT
                           PI_IDWF       ID WORKFLOW SOT
                           PI_TAREA      NUMERO DE TAREA WORKFLOW
                           PI_TAREADEF   NUMERO DE TAREADEF
  * CREACION             : 02/08/2018 JOSE VARILLAS
  '***********************************************************************************************************/
  PROCEDURE SGASU_WF_ACT_DES_IL(PI_IDTAREAWF IN NUMBER,
                                PI_IDWF      IN NUMBER,
                                PI_TAREA     IN NUMBER,
                                PI_TAREADEF  IN NUMBER) IS
    L_CODSOLOT SOLOT.CODSOLOT%TYPE;
    L_EXCEPT EXCEPTION;
    LV_NCOS        NUMBER;
    P_CO_ID        NUMBER;
    V_REQUEST      NUMBER;
    LV_CUSTOMER_ID NUMBER;

  BEGIN

    SELECT CODSOLOT INTO L_CODSOLOT FROM WF WHERE IDWF = PI_IDWF;

    SELECT COD_ID, CUSTOMER_ID
      INTO P_CO_ID, LV_CUSTOMER_ID
      FROM SOLOT
     WHERE CODSOLOT = L_CODSOLOT;
    BEGIN

      SELECT GS.NCOS
        INTO LV_NCOS
        FROM SYSADM.PROFILE_SERVICE@DBL_BSCS_BF PS
       INNER JOIN SYSADM.PR_SERV_STATUS_HIST@DBL_BSCS_BF SH
          ON PS.CO_ID = SH.CO_ID
         AND PS.SNCODE = SH.SNCODE
         AND PS.STATUS_HISTNO = SH.HISTNO
       INNER JOIN TIM.LTE_GMD_SERV@DBL_BSCS_BF GS
          ON PS.SNCODE = GS.SNCODE
       WHERE PS.CO_ID = P_CO_ID
         AND SH.STATUS = 'A'
         AND GS.NCOS IS NOT NULL;
    EXCEPTION
      WHEN OTHERS THEN
        LV_NCOS := NULL;
    END;

    SELECT TIM.LTE_PROV_SEQNO.NEXTVAL@DBL_BSCS_BF INTO V_REQUEST FROM DUAL;

    IF V_REQUEST > 0 THEN
      INSERT INTO TIM.LTE_CONTROL_PROV@DBL_BSCS_BF
        (REQUEST,
         REQUEST_PADRE,
         ACTION_ID,
         TIPO_PROD,
         PRIORITY,
         CO_ID,
         CUSTOMER_ID,
         INSERT_DATE,
         STATUS,
         NCOS,
         LTEV_USUCREACION,
         LTED_FECHA_CREACION)
      VALUES
        (V_REQUEST,
        V_REQUEST,
         2,
         'TEL',
         2,
         P_CO_ID,
         LV_CUSTOMER_ID,
         SYSDATE,
         '2',
         LV_NCOS,
         user,
         sysdate);
     END IF;

     EXCEPTION
      WHEN OTHERS THEN
           SGASI_GENERA_LOG(
                      CHR(13)||'CUSTOMER_ID: '||TO_CHAR(LV_CUSTOMER_ID)||
                      CHR(13)||'COD_ID: '     ||TO_CHAR(P_CO_ID)||
                      CHR(13)||'SOT ORIGEN: ' ||TO_CHAR(L_CODSOLOT)||
                      CHR(13)||'Linea Error: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ,
                       'SGASU_WF_ACT_DES_IL',
                       SQLCODE,
                       'ERROR AL REALIZAR ACT/DES IL: '||SQLERRM);
          RAISE_APPLICATION_ERROR(-20001, SQLERRM);
  END;
  /*********************************************************************************************************
  * NOMBRE SP            : SGASU_WF_VALIDA_DESINS
  * PROPOSITO            : VALIDA DESISTALACION DE LINEAS PORT OUT
  * INPUT                : PI_IDTAREAWF  ID TAREA WORKFLOW SOT
                           PI_IDWF       ID WORKFLOW SOT
                           PI_TAREA      NUMERO DE TAREA WORKFLOW
                           PI_TAREADEF   NUMERO DE TAREADEF
  * OUTPUT               :
  * CREACION             : 03/08/2018 JOSE VARILLAS
  '********************************************************************************************************/
  PROCEDURE SGASU_WF_VALIDA_DESINS(PI_IDTAREAWF IN NUMBER,
                                   PI_IDWF      IN NUMBER,
                                   PI_TAREA     IN NUMBER,
                                   PI_TAREADEF  IN NUMBER) IS

    C_TIPO_CONSULTA CONSTANT INTEGER := 2;
    LN_SOT         NUMBER;
    LV_NUMERO      NUMBER;
    LN_RESULTADO   NUMBER;
    LV_MENSAJE     VARCHAR2(1000);
    EXC_VAL        EXCEPTION;
    LV_CUSTOMER_ID VARCHAR2(50);
    LN_CODPLAN     NUMBER;
    LV_PRODUCTO    VARCHAR2(50);
    LD_FECINI      DATE;
    LV_ESTADO      VARCHAR2(50);
    LV_CICLO       VARCHAR2(100);
    LN_STATUS      NUMBER;
    LV_TECN        VARCHAR2(5);
    LN_CUSTOMER_ID NUMBER;
    A_IDERR        NUMBER;
    A_MENS         VARCHAR2(3000);
    C_MENSAJE      SYS_REFCURSOR;

  BEGIN
    SELECT CODSOLOT INTO LN_SOT FROM WF WHERE IDWF = PI_IDWF;

    BEGIN
      SELECT NUMERO, TECN, CUSTOMER_ID
        INTO LV_NUMERO, LV_TECN,LN_CUSTOMER_ID
        FROM SALES.INT_PORTABILIDAD
       WHERE SOT_BAJA = LN_SOT;
    EXCEPTION
    WHEN OTHERS THEN
          LV_MENSAJE := 'ERROR AL CONSULTAR SOT';
          RAISE EXC_VAL;
    END;

    --VALIDACION DE DESINSTALACION JANUS
    OPERACION.PQ_SGA_JANUS.P_CONS_LINEA_JANUS(LV_NUMERO,
                                              C_TIPO_CONSULTA,
                                              LN_RESULTADO,
                                              LV_MENSAJE,
                                              LV_CUSTOMER_ID,
                                              LN_CODPLAN,
                                              LV_PRODUCTO,
                                              LD_FECINI,
                                              LV_ESTADO,
                                              LV_CICLO);

    IF LN_RESULTADO <> 0 THEN
      IF LN_RESULTADO > 0 THEN
        LV_MENSAJE := 'NO SE COMPLETO DESINSTALACION JANUS';
      ELSIF LN_RESULTADO < 0 THEN
        LV_MENSAJE := 'ERROR AL VALIDAR DESINSTALACION JANUS';
      END IF;
      RAISE EXC_VAL;
    END IF;

    IF LV_TECN = 'LTE' THEN
      --VALIDACION DE DESINSTALACION IL
      LN_STATUS := TIM.BSCSFUN_PROVLTE@DBL_BSCS_BF(LN_SOT);

      IF LN_STATUS <> 7 AND LN_STATUS <> 100 THEN
        LV_MENSAJE := 'NO SE COMPLETO DESINSTALACION IL';
        RAISE EXC_VAL;
      END IF;
    END IF;

    IF LV_TECN = 'HFC' THEN
      INTRAWAY.PQ_MIGRASAC.P_TRAE_ALLVOICE(LN_CUSTOMER_ID,
                                           A_IDERR,
                                           A_MENS,
                                           C_MENSAJE);
      IF A_IDERR <> 0 THEN
        LV_MENSAJE := 'NO SE COMPLETO DESINSTALACION IC';
        RAISE EXC_VAL;
      END IF;
    END IF;

    -- DESHABILITA NUMERO
    SGASU_PORTOUT_DESH_NUM(LN_SOT, LN_RESULTADO, LV_MENSAJE);
   IF LN_RESULTADO < 0 THEN
      RAISE EXC_VAL;
    END IF;

    -- DESACTIVA CONTRATO
    SGASU_PORTOUT_DES_CONT(LN_SOT, LN_RESULTADO, LV_MENSAJE);
   IF LN_RESULTADO < 0 THEN
      RAISE EXC_VAL;
    END IF;

  EXCEPTION
    WHEN EXC_VAL THEN
       SGASI_GENERA_LOG(
                  'NUMERO: '     ||TO_CHAR(LV_NUMERO)||
                  CHR(13)||'CUSTOMER_ID: '||TO_CHAR(LN_CUSTOMER_ID)||
                  CHR(13)||'SOT BAJA: '   ||TO_CHAR(LN_SOT)||
                  CHR(13)||'Linea Error: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                   'SGASU_WF_VALIDA_DESINS',
                   SQLCODE,
                   'ERROR AL VALIDAR DESINSTALACION: '||LV_MENSAJE);
      RAISE_APPLICATION_ERROR(-20001, LV_MENSAJE||': '||SQLERRM);

    WHEN OTHERS THEN
      SGASI_GENERA_LOG(
                  'NUMERO: '     ||TO_CHAR(LV_NUMERO)||
                  CHR(13)||'CODSOLOT: '   ||TO_CHAR(LN_SOT)||
                  CHR(13)||'CUSTOMER_ID: '||TO_CHAR(LN_CUSTOMER_ID)||
                  CHR(13)||'SOT BAJA: '   ||TO_CHAR(LN_SOT)||
                  CHR(13)||'Linea Error: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                   'SGASU_WF_VALIDA_DESINS',
                   SQLCODE,
                   'ERROR AL VALIDAR DESINSTALACION: '||SQLERRM);
 
      RAISE_APPLICATION_ERROR(-20411, 'ERROR AL VALIDAR DESINSTALACION: '||SQLERRM);

  END;
  /************************************************************************************************************
  * NOMBRE SP            : SGASU_PORTOUT_DES_CONT
  * PROPOSITO            : DESACTIVAR CONTRATO REGISTRADO EN SISACT
  * INPUT                : PI_CODSOLOT  NUMERO DE SOT
  * OUTPUT               : PO_RESULTADO RESULTADO
                           PO_MENSAJE   MENSAJE
  * CREACION             : 08/08/2018 JENY VALENCIA
  '************************************************************************************************************/
  PROCEDURE SGASU_PORTOUT_DES_CONT(PI_CODSOLOT  IN NUMBER,
                                   PO_RESULTADO OUT NUMBER,
                                   PO_MENSAJE   OUT NUMBER) IS
    N_COD_ID     NUMBER;
    N_REQUEST_ID NUMBER;
    L_SOT_ORI    NUMBER;
    N_REASON     NUMBER;
    N_ACTION_ID  NUMBER;
    V_USUARIO    VARCHAR2(20);
  BEGIN

    SELECT SOT_ORI
      INTO L_SOT_ORI
      FROM SALES.INT_PORTABILIDAD
     WHERE SOT_BAJA = PI_CODSOLOT;

    SELECT COD_ID INTO N_COD_ID FROM SOLOT WHERE CODSOLOT = L_SOT_ORI;

    -- OBTENEMOS PARAMETROS DE DESACTIVACION
    SELECT A.CODIGON
      INTO N_REASON
      FROM OPEDD A, TIPOPEDD B
     WHERE A.TIPOPEDD = B.TIPOPEDD
       AND B.ABREV = 'BSCS_CONTRATO_DES'
       AND A.ABREVIACION = 'REASON';

    SELECT A.CODIGON
      INTO N_ACTION_ID
      FROM OPEDD A, TIPOPEDD B
     WHERE A.TIPOPEDD = B.TIPOPEDD
       AND B.ABREV = 'BSCS_CONTRATO_DES'
       AND A.ABREVIACION = 'ACTION_ID';

    SELECT A.CODIGOC
      INTO V_USUARIO
      FROM OPEDD A, TIPOPEDD B
     WHERE A.TIPOPEDD = B.TIPOPEDD
       AND B.ABREV = 'BSCS_CONTRATO_DES'
       AND A.ABREVIACION = 'USUARIO';

    BEGIN

      TIM.TIM111_PKG_ACCIONES.SP_CONTRACT_DEACTIVATION@DBL_BSCS_BF(N_COD_ID,
                                                                   N_REASON,
                                                                   V_USUARIO,
                                                                   N_REQUEST_ID);

    EXCEPTION
      WHEN OTHERS THEN

      PO_RESULTADO := -1;
      PO_MENSAJE   := SQLERRM;

      SGASI_GENERA_LOG(
                  'PROCESO_ID:'  ||TO_CHAR(N_COD_ID)||
                  CHR(13)||'SOT ORIGEN: ' ||TO_CHAR(L_SOT_ORI)||
                  CHR(13)||'Linea Error: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                   'SGASU_PORTOUT_DES_CONT',
                   SQLCODE,
                   'WF de SOT de Baja: ' ||'ERROR AL DESACTIVAR CONTRATO: '||SQLERRM);

       RAISE_APPLICATION_ERROR(-20000,
                                $$PLSQL_UNIT || '.SGASU_PORTOUT_DES_CONT: ' ||
                                SQLERRM);
    END;
  END;
  /************************************************************************************************************
  * NOMBRE SP            : SGASS_PORTOUT_PARM_COID
  * PROPOSITO            : LISTAR PARAMETROS PARA LA GENERACION DE CONTRATO SEGUN EQUIVALENCIA BSCS
  * OUTPUT               : PO_TRAMA_EVAL   CURSOR CON LOS DATOS EQUIVALENTES.
  * CREACION             : 08/08/2018 JENY VALENCIA
  '***********************************************************************************************************/
  PROCEDURE SGASS_PORTOUT_PARM_COID(PO_TRAMA_EVAL OUT SYS_REFCURSOR
                                   ,PO_RESULTADO  OUT NUMBER
                                   ,PO_MENSAJE    OUT VARCHAR2) IS
    LN_IDSUBMERCADO         NUMBER;
    LN_RED                  NUMBER;
    LV_ESTADOUMBRAL         VARCHAR(10);
    LN_CANTIDADUMBRAL       NUMBER;
    LV_ARCHIVOLLAMADAS      VARCHAR(10);
    LN_ESTADO               NUMBER;
    LN_RAZON                NUMBER;
    LN_PROFILEID            NUMBER;
    LV_TIPOCOSTOSERVICIO    VARCHAR(10);
    LN_PERIODOCOSTOSERVICIO NUMBER;
    LS_CABLE                VARCHAR(10);
    LS_INTERNET             VARCHAR(10);
    LN_TIPODISPOSITIVO      NUMBER;
    EXC_PARAM               EXCEPTION;
  BEGIN

    PO_RESULTADO := 0;
    PO_MENSAJE   := 'OK';

    SGASS_SOT_ALTA_MASIVA(PO_RESULTADO,PO_MENSAJE);

    -- OBTENEMOS PARAMETROS

    SELECT VALOR
      INTO LS_CABLE
      FROM OPERACION.CONSTANTE
     WHERE CONSTANTE = 'FAM_CABLE';

    SELECT VALOR
      INTO LS_INTERNET
      FROM OPERACION.CONSTANTE
     WHERE CONSTANTE = 'FAM_INTERNET';


    BEGIN
      SELECT D.CODIGON
        INTO LN_IDSUBMERCADO
        FROM OPEDD D, TIPOPEDD C
       WHERE D.TIPOPEDD = C.TIPOPEDD
         AND C.ABREV = 'BSCS_CONTRATO'
         AND D.ABREVIACION = 'IDSUBMERCADO'
     AND D.CODIGON_AUX = 1;

      SELECT D.CODIGON
        INTO LN_RED
        FROM OPEDD D, TIPOPEDD C
       WHERE D.TIPOPEDD = C.TIPOPEDD
         AND C.ABREV = 'BSCS_CONTRATO'
         AND D.ABREVIACION = 'RED_LTE'
     AND D.CODIGON_AUX = 1;

      SELECT D.CODIGOC
        INTO LV_ESTADOUMBRAL
        FROM OPEDD D, TIPOPEDD C
       WHERE D.TIPOPEDD = C.TIPOPEDD
         AND C.ABREV = 'BSCS_CONTRATO'
         AND D.ABREVIACION = 'ESTADOUMBRAL'
     AND D.CODIGON_AUX = 1;

      SELECT D.CODIGON
        INTO LN_CANTIDADUMBRAL
        FROM OPEDD D, TIPOPEDD C
       WHERE D.TIPOPEDD = C.TIPOPEDD
         AND C.ABREV = 'BSCS_CONTRATO'
         AND D.ABREVIACION = 'CANTIDADUMBRAL'
     AND D.CODIGON_AUX = 1;

      SELECT D.CODIGOC
        INTO LV_ARCHIVOLLAMADAS
        FROM OPEDD D, TIPOPEDD C
       WHERE D.TIPOPEDD = C.TIPOPEDD
         AND C.ABREV = 'BSCS_CONTRATO'
         AND D.ABREVIACION = 'ARCHIVOLLAMADAS'
     AND D.CODIGON_AUX = 1;

      SELECT D.CODIGON
        INTO LN_ESTADO
        FROM OPEDD D, TIPOPEDD C
       WHERE D.TIPOPEDD = C.TIPOPEDD
         AND C.ABREV = 'BSCS_CONTRATO'
         AND D.ABREVIACION = 'ESTADO'
     AND D.CODIGON_AUX = 1;

      SELECT D.CODIGON
        INTO LN_RAZON
        FROM OPEDD D, TIPOPEDD C
       WHERE D.TIPOPEDD = C.TIPOPEDD
         AND C.ABREV = 'BSCS_CONTRATO'
         AND D.ABREVIACION = 'RAZON'
     AND D.CODIGON_AUX = 1;

      SELECT D.CODIGON
        INTO LN_PROFILEID
        FROM OPEDD D, TIPOPEDD C
       WHERE D.TIPOPEDD = C.TIPOPEDD
         AND C.ABREV = 'BSCS_CONTRATO'
         AND D.ABREVIACION = 'PROFILEID'
     AND D.CODIGON_AUX = 1;

      SELECT D.CODIGOC
        INTO LV_TIPOCOSTOSERVICIO
        FROM OPEDD D, TIPOPEDD C
       WHERE D.TIPOPEDD = C.TIPOPEDD
         AND C.ABREV = 'BSCS_CONTRATO'
         AND D.ABREVIACION = 'TIPOCOSTOSERVICIO'
     AND D.CODIGON_AUX = 1;

      SELECT D.CODIGON
        INTO LN_PERIODOCOSTOSERVICIO
        FROM OPEDD D, TIPOPEDD C
       WHERE D.TIPOPEDD = C.TIPOPEDD
         AND C.ABREV = 'BSCS_CONTRATO'
         AND D.ABREVIACION = 'PERIODOCOSTOSERVICIO'
     AND D.CODIGON_AUX = 1;

      SELECT D.CODIGON
        INTO LN_TIPODISPOSITIVO
        FROM OPEDD D, TIPOPEDD C
       WHERE D.TIPOPEDD = C.TIPOPEDD
         AND C.ABREV = 'BSCS_CONTRATO'
         AND D.ABREVIACION = 'TIPODISPOSITIVO'
     AND D.CODIGON_AUX = 1;
    EXCEPTION
      WHEN OTHERS THEN
        RAISE EXC_PARAM;
    END;

    OPEN PO_TRAMA_EVAL FOR
      SELECT DISTINCT PC.CUSTOMER_ID,
                      PD.TMCODE PLANTARIFARIO,
                      SISACT.PRDC_CODIGO TIPOPRODUCTO,
                      LN_IDSUBMERCADO AS IDSUBMERCADO,
                      LN_IDSUBMERCADO AS IDMERCADO,
                      LN_RED AS RED,
                      LV_ESTADOUMBRAL AS ESTADOUMBRAL,
                      LN_CANTIDADUMBRAL AS CANTIDADUMBRAL,
                      LV_ARCHIVOLLAMADAS AS ARCHIVOLLAMADAS,
                      LN_ESTADO AS ESTADO,
                      LN_RAZON AS RAZON,
                      (SELECT CSCLIMIT
                         FROM SYSADM.CUSTOMER_ALL@DBL_BSCS_BF C
                        WHERE C.CUSTOMER_ID = PC.CUSTOMER_ID) AS LIMITECREDITO,
                      NULL AS COID,
                      PD.SNCODE,
                      PD.SPCODE,
                      LN_PROFILEID AS PROFILEID,
                      LV_TIPOCOSTOSERVICIO AS TIPOCOSTOSERVICIOAVANZADO,
                      PD.CF_SISACT AS COSTOSERVICIOAVANZADO,
                      LN_PERIODOCOSTOSERVICIO AS PERIODOCOSTOSERVICIOAVANZADO,
                      LV_TIPOCOSTOSERVICIO AS TIPOCOSTOSERVICIO,
                      PD.CF_SISACT AS COSTOSERVICIO,
                      LN_PERIODOCOSTOSERVICIO AS PERIODOCOSTOSERVICIO,
                      LN_TIPODISPOSITIVO AS TIPODISPOSITIVO,
                      PC.COD_ID AS COD_ID_OLD,
                      SOT_ALTA
        FROM SALES.INT_PORTABILIDAD_DET PD
       INNER JOIN TYSTABSRV T
          ON PD.CODSRV = T.CODSRV
         AND NVL(T.FLGEQU, 0) = 0
       INNER JOIN SALES.INT_PORTABILIDAD PC
          ON PD.PROCESO_ID = PC.PROCESO_ID
         AND PD.SOT_ORI = PC.SOT_ORI
       INNER JOIN USRPVU.SISACT_AP_SERVICIO@DBL_PVUDB SISACT
          ON PD.IDSRV_SISACT = SISACT.SERVV_CODIGO
       WHERE PC.ESTADO = 2
         AND PD.SOT_ALTA > 0
         AND NOT EXISTS
       (SELECT (1)
                FROM SALES.INT_PORTABILIDAD_DET PD_2
               WHERE PD.SOT_ORI = PD_2.SOT_ORI
                 AND PD_2.IDSRV_SISACT > 0
                 AND PD_2.SOT_ALTA > 0
                 AND (PD_2.SNCODE IS NULL OR PD_2.SPCODE IS NULL OR
                     PD_2.TMCODE IS NULL
                     OR PD_2.CF_SISACT IS NULL
                     ))
       ORDER BY PC.CUSTOMER_ID;

  EXCEPTION
    WHEN EXC_PARAM THEN
      PO_RESULTADO := -1;
      PO_MENSAJE   := 'No se encontraron los parametros necesarios: ';

      SGASI_GENERA_LOG(NULL,
                 'SGASS_PORTOUT_PARM_COID',
                 SQLCODE,
                 'Generacion de Contrato:' ||PO_MENSAJE||SQLERRM);

    WHEN OTHERS THEN
      SGASI_GENERA_LOG(NULL,
                   'SGASS_PORTOUT_PARM_COID',
                   SQLCODE,
                   'Generacion de Contrato: '||SQLERRM);
  END;
  /************************************************************************************************************
  * NOMBRE SP            : SGASU_ACT_EQU_LTE
  * PROP0SITO            : ACTUALIZA EQUIPOS LTE
  * INPUT                : PI_IDTAREAWF  ID TAREA WORKFLOW SOT
                           PI_IDWF       ID WORKFLOW SOT
                           PI_TAREA      NUMERO DE TAREA WORKFLOW
                           PI_TAREADEF   NUMERO DE TAREADEF
  * CREACION             : 08/08/2018 JOSE VARILLAS
  '***********************************************************************************************************/
  PROCEDURE SGASU_ACT_EQU_LTE(PI_IDTAREAWF IN NUMBER,
                              PI_IDWF      IN NUMBER,
                              PI_TAREA     IN NUMBER,
                              PI_TAREADEF  IN NUMBER) IS
    LN_SOLOT     NUMBER;
    LN_TV        NUMBER;
    LN_INT       NUMBER;
    LN_SOT_ORI   NUMBER;
    LN_CODINSSRV NUMBER;
    LN_SOT_AUX   NUMBER;
    LN_PUNTO_AUX NUMBER;
    LS_INTERNET  VARCHAR2(100);
    LS_CABLE     VARCHAR2(100);

    CURSOR C_TARJ_DECO IS
      SELECT *
        FROM OPERACION.TARJETA_DECO_ASOC
       WHERE CODSOLOT IN
             (SELECT CODSOLOT
                FROM SOLOTPTO
               WHERE CODINSSRV IN
                     (SELECT CODINSSRV
                        FROM SOLOTPTO
                       WHERE CODSOLOT = LN_SOT_ORI));

    CURSOR C_SRV IS
      SELECT DISTINCT PTO.PUNTO, S.CODSOLOT
        FROM SOLOTPTO PTO
       INNER JOIN SOLOT S
          ON PTO.CODSOLOT = S.CODSOLOT
           AND S.TIPTRA IN (SELECT O.CODIGON
                            FROM OPERACION.OPEDD O, OPERACION.TIPOPEDD T
                            WHERE
                            T.ABREV = 'CONF_ALTA_PORTOUT' AND
                            T.TIPOPEDD = O.TIPOPEDD
                            AND O.ABREVIACION = 'TIPTRA')
         AND PTO.CODINSSRV = LN_CODINSSRV;

    CURSOR C_SOLOTPTOEQU IS
      SELECT *
        FROM SOLOTPTOEQU
       WHERE CODSOLOT = LN_SOT_AUX
         AND PUNTO = LN_PUNTO_AUX
         AND (NUMSERIE IS NOT NULL OR MAC IS NOT NULL);

  BEGIN

    SELECT VALOR
      INTO LS_CABLE
      FROM OPERACION.CONSTANTE
     WHERE CONSTANTE = 'FAM_CABLE';

    SELECT VALOR
      INTO LS_INTERNET
      FROM OPERACION.CONSTANTE
     WHERE CONSTANTE = 'FAM_INTERNET';

    SELECT CODSOLOT INTO LN_SOLOT FROM WF WHERE IDWF = PI_IDWF;

    SELECT DISTINCT SOT_ORI
      INTO LN_SOT_ORI
      FROM SALES.INT_PORTABILIDAD_DET
     WHERE SOT_ALTA = LN_SOLOT;

    --ACTUALIZACION EQUIPOS DE RED SGA
    SELECT COUNT(1)
      INTO LN_TV
      FROM SOLOTPTO PTO, TYSTABSRV TY
     WHERE PTO.CODSRVNUE = TY.CODSRV
       AND TY.TIPSRV = LS_CABLE
       AND PTO.CODSOLOT = LN_SOLOT;
    SELECT COUNT(1)
      INTO LN_INT
      FROM SOLOTPTO PTO, TYSTABSRV TY
     WHERE PTO.CODSRVNUE = TY.CODSRV
       AND TY.TIPSRV = LS_INTERNET
       AND PTO.CODSOLOT = LN_SOLOT;
    --INTERNET
    IF LN_INT > 0 THEN

      SELECT PTO.CODINSSRV
        INTO LN_CODINSSRV
        FROM SOLOTPTO PTO
       INNER JOIN TYSTABSRV TY
          ON TY.CODSRV = PTO.CODSRVNUE
         AND TY.TIPSRV = LS_INTERNET
         AND PTO.CODSOLOT = LN_SOT_ORI;

      FOR LC1 IN C_SRV LOOP
        LN_SOT_AUX   := LC1.CODSOLOT;
        LN_PUNTO_AUX := LC1.PUNTO;

        FOR LC2 IN C_SOLOTPTOEQU LOOP

          UPDATE SOLOTPTOEQU
             SET NUMSERIE = LC2.NUMSERIE, MAC = LC2.MAC
           WHERE CODSOLOT = LN_SOLOT
             AND TIPEQU = LC2.TIPEQU
             AND CODEQUCOM = LC2.CODEQUCOM
             AND ROWNUM = 1
             AND (NUMSERIE IS NULL OR MAC IS NULL);

        END LOOP;

      END LOOP;
    END IF;
    --TV
    IF LN_TV > 0 THEN

      SELECT PTO.CODINSSRV
        INTO LN_CODINSSRV
        FROM SOLOTPTO PTO
       INNER JOIN TYSTABSRV TY
          ON TY.CODSRV = PTO.CODSRVNUE
         AND TY.TIPSRV = LS_CABLE
         AND PTO.CODSOLOT = LN_SOT_ORI;

      FOR LC1 IN C_SRV LOOP
        LN_SOT_AUX   := LC1.CODSOLOT;
        LN_PUNTO_AUX := LC1.PUNTO;

        FOR LC2 IN C_SOLOTPTOEQU LOOP

          UPDATE SOLOTPTOEQU
             SET NUMSERIE = LC2.NUMSERIE, MAC = LC2.MAC
           WHERE CODSOLOT = LN_SOLOT
             AND TIPEQU = LC2.TIPEQU
             AND CODEQUCOM = LC2.CODEQUCOM
             AND ROWNUM = 1
             AND (NUMSERIE IS NULL OR MAC IS NULL);

        END LOOP;

      END LOOP;

      FOR LC3 IN C_TARJ_DECO LOOP

        INSERT INTO OPERACION.TARJETA_DECO_ASOC T
          (T.CODSOLOT,
           T.IDDET_DECO,
           T.NRO_SERIE_DECO,
           T.IDDET_TARJETA,
           T.NRO_SERIE_TARJETA)
        VALUES
          (LN_SOLOT,
           LC3.IDDET_DECO,
           LC3.NRO_SERIE_DECO,
           LC3.IDDET_TARJETA,
           LC3.NRO_SERIE_TARJETA);

      END LOOP;

    END IF;

  EXCEPTION
    WHEN OTHERS THEN
      SGASI_GENERA_LOG(
                   'SOT ORIGEN: ' ||TO_CHAR(LN_SOT_ORI),
                   'SGASU_ACT_EQU_LTE',
                   SQLCODE,
                   SQLERRM);

      RAISE_APPLICATION_ERROR(-20001, SQLERRM);
  END;
  /***********************************************************************************************************
  * NOMBRE SP            : SGASS_CONSULTA_SINGLES
  * PROPOSITO            : LISTAR SOT DE ALTA
  * OUTPUT               : PO_TRAMA_EVAL   CURSOR CON LOS SIGUIENTE CAMPOS:
                                           * SOT_ALTA SOT GENERADA
                                           * PLAN,        NOMBRE DE PLAN
                                           * TIPSRV       TIPO DE SERVICIO
                                           * NUMERO       NUMERO DE LINEA
                                           * ESTADO       ESTADO
                                           * OBSERVACION  OBSERVACION
  * CREACION             : 18/09/2018 JOSE VARILLAS
  '***********************************************************************************************************/
  PROCEDURE SGASS_CONSULTA_SINGLES(PO_TRAMA_EVAL OUT SYS_REFCURSOR) IS
    LS_CABLE    VARCHAR(10);
    LS_INTERNET VARCHAR(10);
  BEGIN

    SELECT VALOR
      INTO LS_CABLE
      FROM OPERACION.CONSTANTE
     WHERE CONSTANTE = 'FAM_CABLE';

    SELECT VALOR
      INTO LS_INTERNET
      FROM OPERACION.CONSTANTE
     WHERE CONSTANTE = 'FAM_INTERNET';

    OPEN PO_TRAMA_EVAL FOR
     SELECT DISTINCT T2.CUSTOMER_ID,
                T1.SOT_ALTA,
                T1.COD_ID_ALTA,
                T2.SOT_BAJA,
                T2.COD_ID COD_ID_ANTERIOR,
                '1 PLAY ' ||
                DECODE(T1.TIPSRV, '0062', 'CABLE', '0006', 'INTERNET') AS PLAN,
                T1.TIPSRV,
                T2.NUMERO,
                T2.ESTADO,
                T2.OBSERVACION,
                TRUNC(T2.FECH_REG) FECHAREG
  FROM SALES.INT_PORTABILIDAD_DET T1,
       SALES.INT_PORTABILIDAD     T2
 WHERE T1.PROCESO_ID = T2.PROCESO_ID
   AND TRUNC(T2.FECH_REG) = TRUNC(SYSDATE);

  EXCEPTION
    WHEN OTHERS THEN
      SGASI_GENERA_LOG(NULL,
                   'SGASS_CONSULTA_SINGLES',
                   SQLCODE,
                   SQLERRM);

      RAISE_APPLICATION_ERROR(-20001, SQLERRM);
  END;
  /***********************************************************************************************************
  * NOMBRE FUNCION       : SGAFUN_CAMPO_ARRAY
  * PROPOSITO            : DEVUELVE CAMPO ESPECIFICO SEGUN TRAMA INGRESADA.
  * INPUT                : PI_STRING   TRAMA.
                           PI_TRAMA_ID ID DE TRAMA.
                           PI_COLUMN   ID DE COLUMNA.
  * OUTPUT               : DESCRIPCION DE CAMPO.
  * CREACION             : 31/07/2018 JENY VALENCIA
  '**********************************************************************************************************/
  FUNCTION SGAFUN_CAMPO_ARRAY(PI_STRING   VARCHAR2,
                              PI_TRAMA_ID NUMBER,
                              PI_COLUMN   VARCHAR2) RETURN VARCHAR2 IS
    L_ORDEN NUMBER;
    L_VENTA NUMEROS_TYPE;
    L_CAMPO VARCHAR2(100);

  BEGIN
    IF PI_STRING IS NULL THEN
      RETURN NULL;
    END IF;

    SELECT ORDEN
      INTO L_ORDEN
      FROM SALES.TRAMA_LTE C, SALES.TRAMA_DET_LTE D
     WHERE C.TRAMAID = D.TRAMAID
       AND C.TRAMAID = PI_TRAMA_ID
       AND D.COLUMN_NAME = PI_COLUMN;

    L_VENTA := SGAFUN_CARGAR_ARRAY(PI_STRING);
    L_CAMPO := RTRIM(L_VENTA(L_ORDEN).NUMERO);

    IF LENGTH(L_CAMPO) = 0 THEN
      L_CAMPO := NULL;
    END IF;
    RETURN L_CAMPO;

  EXCEPTION
    WHEN OTHERS THEN
      SGASI_GENERA_LOG(NULL,
                   'SGAFUN_CAMPO_ARRAY',
                   SQLCODE,
                   SQLERRM);

      RAISE_APPLICATION_ERROR(-20001, SQLERRM);

  END;
  /************************************************************************************************************
  * NOMBRE P             : SGASU_PORTOUT_INTPORT
  * PROPOSITO            : ACTUALIZA SOT DE ALTA EN INT_PORTABILIDAD_DET
  * INPUT                : PI_SOT_ORI   : SOT ORIGEN
                           PI_SOT_ALTA  : SOT ALTA
  * OUTPUT               :
  * CREACION             : 31/07/2018 JENY VALENCIA
  '************************************************************************************************************/
  PROCEDURE SGASU_PORTOUT_INTPORT(PI_SOT_ORI NUMBER, PI_SOT_ALTA NUMBER) IS
    L_PROCESO_ID     NUMBER;
    L_TELEF          VARCHAR2(100);
    LN_REGISTROS_DET NUMBER;
    LN_REGISTROS_SOT NUMBER;
  BEGIN
    IF PI_SOT_ALTA IS NULL OR PI_SOT_ALTA = 0 THEN
      RETURN;
    END IF;

    SELECT VALOR
      INTO L_TELEF
      FROM OPERACION.CONSTANTE
     WHERE CONSTANTE = 'FAM_TELEF';

    -- OBTENEMOS PROCESO_ID
    SELECT MAX(P.PROCESO_ID)
      INTO L_PROCESO_ID
      FROM SALES.INT_PORTABILIDAD_DET P
     WHERE P.SOT_ORI = PI_SOT_ORI;

    -- ACTUALIZA LA SOT DE ALTA, SI LOS SERVICIOS COINDICEN EN TIPO Y CANTIDAD
    UPDATE SALES.INT_PORTABILIDAD_DET PD
       SET SOT_ALTA = PI_SOT_ALTA, OBSERVACION = NULL
     WHERE PD.SOT_ORI = PI_SOT_ORI
       AND PD.PROCESO_ID = L_PROCESO_ID
       AND PD.TIPSRV <> L_TELEF
       AND (SELECT COUNT(1)
              FROM SOLOTPTO PTO
             INNER JOIN TYSTABSRV S
                ON PTO.CODSRVNUE = S.CODSRV
             INNER JOIN INSSRV I
                ON PTO.CODINSSRV = I.CODINSSRV
             WHERE PTO.CODSOLOT = PI_SOT_ALTA
               AND I.TIPSRV = PD.TIPSRV) =
           (SELECT COUNT(1)
              FROM SALES.INT_PORTABILIDAD_DET PD_2
             WHERE PD_2.SOT_ORI = PD.SOT_ORI
               AND PD_2.TIPSRV = PD.TIPSRV
               AND PD_2.PROCESO_ID = PD.PROCESO_ID);

    -- ACTUALIZA OBSERVACION, SI LOS SERVICIOS NO COINCIDEN EN CANTIDAD
    UPDATE SALES.INT_PORTABILIDAD_DET PD
       SET OBSERVACION = TO_CHAR(PI_SOT_ALTA) ||
                         ' LA CANTIDAD DE SERVICIOS NO COINCIDE CON LA SOT ORIGEN'
     WHERE PD.SOT_ORI = PI_SOT_ORI
       AND PD.PROCESO_ID = L_PROCESO_ID
       AND PD.TIPSRV <> L_TELEF
       AND PD.SOT_ALTA IS NULL
       AND (SELECT COUNT(1)
              FROM SOLOTPTO PTO
             INNER JOIN TYSTABSRV S
                ON PTO.CODSRVNUE = S.CODSRV
             INNER JOIN INSSRV I
                ON PTO.CODINSSRV = I.CODINSSRV
             WHERE PTO.CODSOLOT = PI_SOT_ALTA
               AND I.TIPSRV = PD.TIPSRV
               AND (PTO.CODSRVNUE = PD.CODSRV OR S.DSCSRV = PD.DSCSRV)) <>
           (SELECT COUNT(1)
              FROM SALES.INT_PORTABILIDAD_DET PD_2
             WHERE PD_2.SOT_ORI = PD.SOT_ORI
               AND PD_2.TIPSRV = PD.TIPSRV
               AND PD_2.PROCESO_ID = PD.PROCESO_ID
               AND PD_2.CODSRV = PD.CODSRV);
    COMMIT;

    SELECT COUNT(1)
      INTO LN_REGISTROS_DET
      FROM SALES.INT_PORTABILIDAD_DET PD
     WHERE PD.SOT_ORI = PI_SOT_ORI
       AND PD.PROCESO_ID = L_PROCESO_ID
       AND PD.TIPSRV <> L_TELEF;

    SELECT COUNT(1)
      INTO LN_REGISTROS_SOT
      FROM SALES.INT_PORTABILIDAD_DET PD
     WHERE PD.SOT_ORI = PI_SOT_ORI
       AND PD.PROCESO_ID = L_PROCESO_ID
       AND PD.TIPSRV <> L_TELEF
       AND PD.SOT_ALTA > 0;

    IF LN_REGISTROS_DET = LN_REGISTROS_SOT THEN
      UPDATE SALES.INT_PORTABILIDAD
         SET ESTADO = 2
       WHERE SOT_ORI = PI_SOT_ORI
         AND PROCESO_ID = L_PROCESO_ID;

      COMMIT;
    END IF;

    EXCEPTION
      WHEN OTHERS THEN
      SGASI_GENERA_LOG(NULL,
                   'SGASU_PORTOUT_INTPORT',
                   SQLCODE,
                   SQLERRM);

      RAISE_APPLICATION_ERROR(-20001, SQLERRM);
  END;
  /***********************************************************************************************************
  * NOMBRE SP            : SGAFUN_PORTOUT_ES_ALTA
  * PROPOSITO            : VALIDA SOT DE ALTA
  * INPUT                : PI_CODSOLOT         NUMERO DE SOT
  * OUTPUT               :
  * CREACION             : 13/08/2018 JENY VALENCIA
  '**********************************************************************************************************/
  FUNCTION SGAFUN_PORTOUT_ES_ALTA(PI_CODSOLOT IN SOLOT.CODSOLOT%TYPE)
    RETURN NUMBER IS
    L_POROUT_ES_ALTA NUMBER;
    L_TIPTRA         NUMBER;
  BEGIN
    SELECT TIPTRA
      INTO L_TIPTRA
      FROM OPERACION.SOLOT
     WHERE SOLOT.CODSOLOT = PI_CODSOLOT;

    SELECT COUNT(1)
      INTO L_POROUT_ES_ALTA
      FROM TIPOPEDD C
     INNER JOIN OPEDD D
        ON C.TIPOPEDD = D.TIPOPEDD
     WHERE C.ABREV = 'TIPTRABAJO'
       AND D.ABREVIACION IN ('SISACT_ALTA_LTE', 'SISACT_ALTA_HFC')
       AND D.CODIGON = L_TIPTRA;

    RETURN L_POROUT_ES_ALTA;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.SGAFUN_PORTOUT_ES_ALTA(): ' ||
                              SQLERRM);
  END;
  /******************.***************************************************************************************
  * NOMBRE SP            : SGAFUN_PORTOUT_ES_VTAALT
  * PROPOSITO            : VALIDA VENTA PORT OUT ALTA
  * INPUT                : PI_NUMSLC
  * OUTPUT               :
  * CREACION             : 13/08/2018 JENY VALENCIA
  '**********************************************************************************************************/
  FUNCTION SGAFUN_PORTOUT_ES_VTAALT(PI_NUMSLC IN VARCHAR2) RETURN BOOLEAN IS
    L_ALTA       NUMERIC := 0;
    L_VAL_SINGLE VARCHAR(30);
  BEGIN
    SELECT CODIGOC
      INTO L_VAL_SINGLE
      FROM OPEDD O
     INNER JOIN TIPOPEDD T
        ON O.TIPOPEDD = T.TIPOPEDD
     WHERE T.ABREV = 'PORT_OUT'
       AND O.ABREVIACION = 'VAL_SINGLE_PORTOUT';

    SELECT NVL(COUNT(1), 0)
      INTO L_ALTA
      FROM SALES.INT_NEGOCIO_INSTANCIA I, SALES.INT_NEGOCIO_PROCESO P
     WHERE I.INSTANCIA = 'PROYECTO DE VENTA'
       AND I.IDINSTANCIA = PI_NUMSLC
       AND I.IDPROCESS = P.IDPROCESS
       AND P.NUMERO_PORTABLE = L_VAL_SINGLE;

    RETURN L_ALTA > 0;
  END;
  /*********************************************************************************************************
  * NOMBRE SP            : ES_PORTABILIDAD_SOT
  * PROPOSITO            : VALIDA SOT PORTABILIDAD
  * INPUT                : PI_CODSOLOT         NUMERO DE SOT
  * OUTPUT               :
  * CREACION             : 13/08/2018 JENY VALENCIA
  '*********************************************************************************************************/
  PROCEDURE ES_PORTABILIDAD_SOT(P_CODSOLOT        SOLOT.CODSOLOT%TYPE,
                                A_NUMERO_PORTABLE OUT NUMBER) IS
  BEGIN
    SELECT COUNT(1)
      INTO A_NUMERO_PORTABLE
      FROM SALES.INT_NEGOCIO_INSTANCIA I, SALES.INT_NEGOCIO_PROCESO P
     WHERE I.INSTANCIA = 'PROYECTO DE VENTA'
       AND I.IDINSTANCIA =
           (SELECT NUMSLC FROM SOLOT WHERE CODSOLOT = P_CODSOLOT)
       AND I.IDPROCESS = P.IDPROCESS
       AND P.NUMERO_PORTABLE IS NOT NULL;
  END;
  /*********************************************************************************************************
  * NOMBRE SP            : SGASU_PORTOUT_SET_CONTR
  * PROPOSITO            : ACTUALIZA CONTRATO GENERADO EN SOT ORIGEN
  * INPUT                :
  * OUTPUT               :
  * CREACION             : 16/08/2018 JENY VALENCIA
  '********************************************************************************************************/
  PROCEDURE SGASU_PORTOUT_SET_CONTR(PO_RESULTADO OUT NUMERIC,
                                    PO_MENSAJE   OUT VARCHAR2) IS
    LN_SOT_ALTA    NUMERIC;
    LN_COD_ID_ALTA NUMERIC;

    CURSOR C1 IS
      SELECT *
        FROM SALES.INT_PORTABILIDAD_DET T1
       WHERE T1.COD_ID_ALTA IS NULL
         AND T1.SOT_ALTA IS NOT NULL;

  BEGIN
  PO_RESULTADO :=  0;
  PO_MENSAJE := 'OK'; 
    FOR LC1 IN C1 LOOP
      LN_SOT_ALTA := LC1.SOT_ALTA;

      SELECT COD_ID
        INTO LN_COD_ID_ALTA
        FROM SOLOT
       WHERE CODSOLOT = LN_SOT_ALTA;

      IF LN_COD_ID_ALTA > 0 THEN
        UPDATE SALES.INT_PORTABILIDAD_DET
           SET COD_ID_ALTA = LN_COD_ID_ALTA
         WHERE SOT_ALTA = LN_SOT_ALTA;
      END IF;
    END LOOP;

  EXCEPTION
    WHEN OTHERS THEN
      PO_RESULTADO := SQLCODE;
      PO_MENSAJE := 'ERROR EN LA ACTUALIZACION DE SINGLE GENERADO: '||SQLERRM;

      SGASI_GENERA_LOG(NULL,
                   'SGASU_PORTOUT_SET_CONTR',
                   SQLCODE,
                   PO_MENSAJE);

      RAISE_APPLICATION_ERROR(-20001, PO_MENSAJE);
  END;
  /***********************************************************************************************************
  * NOMBRE SP            : SGASS_SOT_ALTA_MASIVA
  * PROPOSITO            : Generacion de SOT'S Pendientes
  * OUTPUT               : PO_RESULTADO  Resultado
                           PO_MENSAJE    Mensaje de respuesta
  * CREACION             : 18/09/2018 JOSE VARILLAS
  '***********************************************************************************************************/
  PROCEDURE SGASS_SOT_ALTA_MASIVA(PO_RESULTADO OUT NUMBER,
                                  PO_MENSAJE   OUT VARCHAR2) IS

    CURSOR SOT_PENDIENTE IS
      SELECT CUSTOMER_ID, COD_ID, TECN, NUMERO  --4.0
        FROM SALES.INT_PORTABILIDAD
       WHERE ESTADO = 1
       ORDER BY CUSTOMER_ID;

    LN_RESULTADO NUMBER;
    LV_MENSAJE VARCHAR2(100);

  BEGIN
    PO_RESULTADO := 0;
    PO_MENSAJE := 'OK';

    FOR C1 IN SOT_PENDIENTE LOOP
      BEGIN  --4.0
        OPERACION.PKG_PORTABILIDAD.SGASI_PORTOUT_SOT_ALTA(C1.CUSTOMER_ID,  --4.0
                             C1.COD_ID,
                             C1.TECN,
                             LN_RESULTADO,
                             LV_MENSAJE);
      --4.0 Ini
      EXCEPTION
        WHEN OTHERS THEN
          UPDATE SALES.INT_PORTABILIDAD T
             SET T.OBSERVACION = 'Error al Generar SOT de Alta'
           WHERE T.NUMERO = C1.NUMERO
             AND T.COD_ID = C1.COD_ID
             AND T.CUSTOMER_ID = C1.CUSTOMER_ID
             AND T.TECN = C1.TECN;
             COMMIT;
      END;
      --4.0 Fin
    END LOOP;

  EXCEPTION
    WHEN OTHERS THEN
      PO_RESULTADO := -1;
      PO_MENSAJE := 'ERROR AL GENERAR LISTADO DE SOT PENDIENTES';

      SGASI_GENERA_LOG(NULL,
                   'SGASS_SOT_ALTA_MASIVA',
                   SQLCODE,
                   'Generacion de SOT de Alta: '||SQLERRM);

  END;
    /*****************************************************************************************************
  * Nombre SP            : SGASU_WF_ACT_DES_IC
  * Proposito            : Desactiva Numero IW
  * Input                : PI_NUMERO    Numero de Linea
                           PI_COD_ID    Codigo de Contrato
                           PI_CODSOLOT  Numero de SOT
  * Output               : PO_COD_RPT   Codigo de Validacion
                           PO_RPT       Mensaje de Validacion
  * Creacion             : 03/08/2018 Jose Varillas
  '******************************************************************************************************/
  PROCEDURE SGASU_WF_ACT_DES_IC(PI_IDTAREAWF IN NUMBER,
                                PI_IDWF      IN NUMBER,
                                PI_TAREA     IN NUMBER,
                                PI_TAREADEF  IN NUMBER) IS

    LN_VAL_NUM NUMBER;

    A_CLIENTE           SOLOT.CUSTOMER_ID%TYPE;
    A_PIDORIGEN         NUMBER;
    A_PIDACTUAL         NUMBER;
    A_PRODUCTO_PADRE    NUMBER;
    A_NROENDPOINT       NUMBER;
    A_NROTELEFONO       NUMTEL.NUMERO%TYPE;
    A_HOMEEXCHANGECRMID VARCHAR2(3000);
    A_PROCESO           INT_MENSAJE_INTRAWAY.PROCESO%TYPE;
    A_CODSOLOT          SOLOT.CODSOLOT%TYPE;
    A_CODINSSRV         INSSRV.CODINSSRV%TYPE;
    O_RESULTADO         VARCHAR2(3000);
    O_MENSAJE           VARCHAR2(3000);
    O_ERROR             NUMBER;
    A_iderr             NUMBER;
    A_mens              VARCHAR2(3000);
    C_mensaje           SYS_REFCURSOR;
    A_IDPRODUCTO        VARCHAR2(3000);
    A_IDPRODUCTOPADRE   VARCHAR2(3000);
    A_IDVENTA           VARCHAR2(3000);
    A_IDVENTAPADRE      VARCHAR2(3000);
    A_MTAPORT           VARCHAR2(3000);
    A_NRO_TLF           VARCHAR2(3000);
    A_HOMEEXCHANGE      VARCHAR2(3000);
    A_CMSCRMID          VARCHAR2(3000);
    A_CANT_NROTLF       NUMBER := 0;
    L_TIPTRA            NUMBER;
    L_TIPO              VARCHAR2(1);
    L_NUMERO            NUMBER;
    L_COD_ID            NUMBER;
    L_CODSOLOT          NUMBER;
    L_COD_RPT           NUMBER;
    L_RPT               VARCHAR2(200);
  BEGIN


    SELECT CODSOLOT INTO L_CODSOLOT FROM WF WHERE IDWF = PI_IDWF;

    SELECT NUMERO,COD_ID INTO L_NUMERO,L_COD_ID
    FROM SALES.INT_PORTABILIDAD
    WHERE SOT_BAJA = L_CODSOLOT;  --4.0

    -- VALIDA EXISTENCIA DE NUMERO EN Bscs
    LN_VAL_NUM := OPERACION.PKG_SIAC_CAMBIO_NUMERO.SIACFUN_VALIDA_NUM(L_NUMERO,
                                                                      L_COD_ID);

    SELECT CUSTOMER_ID, TIPTRA
      INTO A_CLIENTE, L_TIPTRA
      FROM SOLOT
     WHERE CODSOLOT = L_CODSOLOT;

    -- TIPO DE PORTABILIDAD
    SELECT D.CODIGOC
      INTO L_TIPO
      FROM TIPOPEDD C, OPEDD D
     WHERE C.ABREV = 'TIPTRABAJO'
       AND C.TIPOPEDD = D.TIPOPEDD
       AND D.CODIGON = L_TIPTRA;

    IF L_TIPO = 2 THEN
      -- ESTADO DE NUMERO
      IF LN_VAL_NUM > 0 THEN
        --<Ini 3.0 >
       --4.0 Ini
       SELECT OPERACION.PQ_IW_SGA_BSCS.F_GET_NCOS(A.CODSOLOT, P.CODSRV, 3),
             B.CODINSSRV
        INTO A_HOMEEXCHANGECRMID, A_CODINSSRV
        FROM SOLOTPTO A, INSSRV B, INSPRD P
       WHERE A.CODINSSRV = B.CODINSSRV
         AND B.CODINSSRV = P.CODINSSRV
         AND A.CODSOLOT = OPERACION.PQ_SGA_IW.F_MAX_SOT_X_COD_ID(L_COD_ID)
         AND P.FLGPRINC = 1
         AND A.PID = P.PID
         AND B.TIPSRV = '0004';
        --4.0 Fin

        Begin
          intraway.pq_migrasac.P_TRAE_ALLVOICE(A_CLIENTE,
                                               A_iderr,
                                               A_mens,
                                               C_mensaje);
          loop
            fetch C_mensaje
              into A_IDPRODUCTO,
                   A_IDPRODUCTOPADRE,
                   A_IDVENTA,
                   A_IDVENTAPADRE,
                   A_MTAPORT,
                   A_NRO_TLF,
                   A_HOMEEXCHANGE,
                   A_CMSCRMID;
            exit when C_mensaje%notfound;

            A_CANT_NROTLF    := A_CANT_NROTLF + 1;
            A_PIDORIGEN      := TO_NUMBER(A_IDPRODUCTO);
            A_PRODUCTO_PADRE := A_IDPRODUCTOPADRE;
          end loop;
        EXCEPTION
          WHEN OTHERS THEN
            L_COD_RPT := -1;
            L_RPT := 'ERROR AL EXTRAER INFORMACION DE INCOGNITO';
        End;

        --<Fin 3.0> -- NUMERO NUEVO -- ESTADO ASIGNADO

        IF A_CANT_NROTLF = 1 THEN

          A_PIDACTUAL   := A_PIDORIGEN;
          A_NROENDPOINT := 1;
          A_NROTELEFONO := L_NUMERO;
          A_PROCESO     := 4;
          A_CODSOLOT    := L_CODSOLOT;

          --BAJA NUMERO TELEFONICO ANTIGUO
          INTRAWAY.PQ_INTRAWAY.P_MTA_EP_ADMINISTRACION(0,
                                                       A_CLIENTE,
                                                       A_PIDORIGEN,
                                                       A_PIDACTUAL,
                                                       A_PRODUCTO_PADRE,
                                                       A_NROENDPOINT,
                                                       A_NROTELEFONO,
                                                       A_HOMEEXCHANGECRMID,
                                                       A_PROCESO,
                                                       A_CODSOLOT,
                                                       A_CODINSSRV,
                                                       O_RESULTADO,
                                                       O_MENSAJE,
                                                       O_ERROR,
                                                       1);

          IF NOT O_ERROR = 0 THEN
            L_COD_RPT := -1;
            L_RPT := 'BAJA DEL NUMERO TELEFONICO INCOMPLETA :' ||
                      O_MENSAJE;
          END IF;
        ELSIF A_CANT_NROTLF > 1 THEN
          L_COD_RPT := -1;
          L_RPT := 'SE ENCONTRO MAS DE UN NUMERO TELEFONICO EN INCOGNITO';
        ELSIF A_CANT_NROTLF = 0 THEN
          L_COD_RPT := -1;
          L_RPT := 'NO SE ENCONTRARON NUMEROS TELEFONICOS EN INCOGNITO';
        END IF;
      ELSE
        L_COD_RPT := -1;
        L_RPT := 'NO SE ENCONTRO EL NUMERO ' || L_NUMERO ||

                  ' PARA EL CONTRATO ' || L_COD_ID;
      END IF;
    END IF;
    --4.0 Ini
    SGASI_GENERA_LOG(
                      'NUMERO: '     ||TO_CHAR(L_NUMERO)||
                      CHR(13)||'COD_ID: '     ||TO_CHAR(L_COD_ID)||
                      CHR(13)||'SOT BAJA: '   ||TO_CHAR(A_CODSOLOT),
                       'SGASU_WF_ACT_DES_IC',
                       L_COD_RPT,
                       L_RPT);
    --4.0 Fin
    EXCEPTION
      WHEN OTHERS THEN
           SGASI_GENERA_LOG(
                      'NUMERO: '     ||TO_CHAR(L_NUMERO)||
                      CHR(13)||'COD_ID: '     ||TO_CHAR(L_COD_ID)||
                      CHR(13)||'SOT BAJA: '   ||TO_CHAR(A_CODSOLOT)||
                      CHR(13)||'Linea Error: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                       'SGASU_WF_ACT_DES_IC',
                       SQLCODE,
                       'WF de SOT de Baja: ' ||'ERROR AL REALIZAR ACT/DES DE NUMERO: '||SQLERRM);
          RAISE_APPLICATION_ERROR(-20001, SQLERRM);
  END;
  /********************************************************************************************************
  * NOMBRE SP            : SGASU_ACT_EQU_HFC
  * PROPOSITO            : ACTUALIZA EQUIPOS HFC
  * INPUT                : PI_IDTAREAWF  ID TAREA WORKFLOW SOT
                           PI_IDWF       ID WORKFLOW SOT
                           PI_TAREA      NUMERO DE TAREA WORKFLOW
                           PI_TAREADEF   NUMERO DE TAREADEF
  * CREACION             : 08/08/2018 JOSE VARILLAS
  '********************************************************************************************************/
  PROCEDURE SGASU_ACT_EQU_HFC(PI_IDTAREAWF IN NUMBER,
                              PI_IDWF      IN NUMBER,
                              PI_TAREA     IN NUMBER,
                              PI_TAREADEF  IN NUMBER) IS
    LN_SOLOT     NUMBER;
    LN_TV        NUMBER;
    LN_INT       NUMBER;
    LN_SOT_ORI   NUMBER;
    LN_COD_ID    NUMBER;
    LN_COID_ORI  NUMBER;
    LS_INTERNET  VARCHAR2(100);
    LS_CABLE     VARCHAR2(100);
    LN_IDINTRF   NUMBER;
    LN_IDP       NUMBER;

    CURSOR C_SRV IS
      SELECT *
        FROM OPERACION.TRS_INTERFACE_IW IW
       WHERE IW.ID_INTERFASE = LN_IDINTRF
         AND IW.COD_ID = LN_COID_ORI;

  BEGIN

    SELECT VALOR
      INTO LS_CABLE
      FROM OPERACION.CONSTANTE
     WHERE CONSTANTE = 'FAM_CABLE';

    SELECT VALOR
      INTO LS_INTERNET
      FROM OPERACION.CONSTANTE
     WHERE CONSTANTE = 'FAM_INTERNET';

    --ACTUALIZACION EQUIPOS DE RED SGA
    SELECT COUNT(1)
      INTO LN_TV
      FROM SOLOTPTO PTO, TYSTABSRV TY
     WHERE PTO.CODSRVNUE = TY.CODSRV
       AND TY.TIPSRV = LS_CABLE;

    SELECT COUNT(1)
      INTO LN_INT
      FROM SOLOTPTO PTO, TYSTABSRV TY
     WHERE PTO.CODSRVNUE = TY.CODSRV
       AND TY.TIPSRV = LS_INTERNET;

    SELECT CODSOLOT INTO LN_SOLOT FROM WF WHERE IDWF = PI_IDWF;
    SELECT COD_ID INTO LN_COD_ID FROM SOLOT WHERE CODSOLOT = LN_SOLOT;

    SELECT DISTINCT SOT_ORI, COD_ID
      INTO LN_SOT_ORI, LN_COID_ORI
      FROM SALES.INT_PORTABILIDAD_DET
     WHERE SOT_ALTA = LN_SOLOT;

    --INTERNET
    IF LN_INT > 0 THEN
      LN_IDINTRF := 620;
      FOR LC_SRV IN C_SRV LOOP

        UPDATE OPERACION.TRS_INTERFACE_IW IW
           SET IW.MODELO            = LC_SRV.MODELO,
               IW.MAC_ADDRESS       = LC_SRV.MAC_ADDRESS,
               IW.UNIT_ADDRESS      = LC_SRV.UNIT_ADDRESS,
               IW.ID_PRODUCTO       = LC_SRV.ID_PRODUCTO,
               IW.ID_PRODUCTO_PADRE = LC_SRV.ID_PRODUCTO_PADRE,
               IW.ID_SERVICIO_PADRE = LC_SRV.ID_SERVICIO_PADRE,
               IW.ID_SERVICIO       = LC_SRV.ID_SERVICIO,
               IW.CODACTIVACION     = LC_SRV.CODACTIVACION
         WHERE IW.ID_INTERFASE = LC_SRV.ID_INTERFASE
           AND IW.CODSOLOT = LN_SOLOT;

      END LOOP;
    END IF;
    --TV
    IF LN_TV > 0 THEN
      LN_IDINTRF := 2020;
      FOR LC_SRV IN C_SRV LOOP

        SELECT MAX(ID_PRODUCTO)
          INTO LN_IDP
          FROM OPERACION.TRS_INTERFACE_IW IW
         WHERE IW.CODSOLOT = LN_SOLOT
           AND IW.ID_INTERFASE = LN_IDINTRF
           AND ID_PRODUCTO NOT IN
               (SELECT ID_PRODUCTO
                  FROM OPERACION.TRS_INTERFACE_IW
                 WHERE CODSOLOT = LN_SOT_ORI);

        UPDATE OPERACION.TRS_INTERFACE_IW IW
           SET IW.MODELO            = LC_SRV.MODELO,
               IW.MAC_ADDRESS       = LC_SRV.MAC_ADDRESS,
               IW.UNIT_ADDRESS      = LC_SRV.UNIT_ADDRESS,
               IW.ID_PRODUCTO       = LC_SRV.ID_PRODUCTO,
               IW.ID_PRODUCTO_PADRE = LC_SRV.ID_PRODUCTO_PADRE,
               IW.ID_SERVICIO_PADRE = LC_SRV.ID_SERVICIO_PADRE,
               IW.ID_SERVICIO       = LC_SRV.ID_SERVICIO,
               IW.CODACTIVACION     = LC_SRV.CODACTIVACION
         WHERE IW.ID_INTERFASE = LC_SRV.ID_INTERFASE
           AND IW.CODSOLOT = LN_SOLOT
           AND IW.ID_PRODUCTO = LN_IDP;

      END LOOP;

      LN_IDINTRF := 2030;
      FOR LC_SRV IN C_SRV LOOP

        SELECT MAX(ID_PRODUCTO)
          INTO LN_IDP
          FROM OPERACION.TRS_INTERFACE_IW IW
         WHERE IW.CODSOLOT = LN_SOLOT
           AND IW.ID_INTERFASE = LN_IDINTRF
           AND ID_PRODUCTO NOT IN
               (SELECT ID_PRODUCTO
                  FROM OPERACION.TRS_INTERFACE_IW
                 WHERE CODSOLOT = LN_SOT_ORI);

        UPDATE OPERACION.TRS_INTERFACE_IW IW
           SET IW.MODELO            = LC_SRV.MODELO,
               IW.MAC_ADDRESS       = LC_SRV.MAC_ADDRESS,
               IW.UNIT_ADDRESS      = LC_SRV.UNIT_ADDRESS,
               IW.ID_PRODUCTO       = LC_SRV.ID_PRODUCTO,
               IW.ID_PRODUCTO_PADRE = LC_SRV.ID_PRODUCTO_PADRE,
               IW.ID_SERVICIO_PADRE = LC_SRV.ID_SERVICIO_PADRE,
               IW.ID_SERVICIO       = LC_SRV.ID_SERVICIO,
               IW.CODACTIVACION     = LC_SRV.CODACTIVACION
         WHERE IW.ID_INTERFASE = LC_SRV.ID_INTERFASE
           AND IW.CODSOLOT = LN_SOLOT
           AND IW.ID_PRODUCTO = LN_IDP;

      END LOOP;

      LN_IDINTRF := 2050;
      FOR LC_SRV IN C_SRV LOOP

        SELECT MAX(ID_PRODUCTO)
          INTO LN_IDP
          FROM OPERACION.TRS_INTERFACE_IW IW
         WHERE IW.CODSOLOT = LN_SOLOT
           AND IW.ID_INTERFASE = LN_IDINTRF
           AND ID_PRODUCTO NOT IN
               (SELECT ID_PRODUCTO
                  FROM OPERACION.TRS_INTERFACE_IW
                 WHERE CODSOLOT = LN_SOT_ORI);

        UPDATE OPERACION.TRS_INTERFACE_IW IW
           SET IW.MODELO            = LC_SRV.MODELO,
               IW.MAC_ADDRESS       = LC_SRV.MAC_ADDRESS,
               IW.UNIT_ADDRESS      = LC_SRV.UNIT_ADDRESS,
               IW.ID_PRODUCTO       = LC_SRV.ID_PRODUCTO,
               IW.ID_PRODUCTO_PADRE = LC_SRV.ID_PRODUCTO_PADRE,
               IW.ID_SERVICIO_PADRE = LC_SRV.ID_SERVICIO_PADRE,
               IW.ID_SERVICIO       = LC_SRV.ID_SERVICIO,
               IW.CODACTIVACION     = LC_SRV.CODACTIVACION
         WHERE IW.ID_INTERFASE = LC_SRV.ID_INTERFASE
           AND IW.CODSOLOT = LN_SOLOT
           AND IW.ID_PRODUCTO = LN_IDP;

      END LOOP;
    END IF;
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      SGASI_GENERA_LOG(
                  CHR(13)||'COD_ID: '     ||TO_CHAR(LN_COD_ID)||
                  CHR(13)||'SOT ORIGEN: ' ||TO_CHAR(LN_SOT_ORI)||
                  CHR(13)||'Linea Error: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE   ,
                   'SGASU_ACT_EQU_HFC',
                   SQLCODE,
                   SQLERRM);

      RAISE_APPLICATION_ERROR(-20001, SQLERRM);
  END;
  /**********************************************************************************************************
  * NOMBRE SP            : SGASS_PORTIN_VALID_NUMSEC
  * PROPOSITO            : VALIDA REGISTRO DE NUMSEC EN SOT
  * OUTPUT               :
  * CREACION             : 15/10/2018 JENY VALENCIA
  '*********************************************************************************************************/
  PROCEDURE SGASS_PORTIN_VALID_NUMSEC(PI_NSOT    IN NUMBER,
                                    PO_NUMSEC OUT NUMBER,
                                    PO_NMSJ    OUT NUMBER,
                                    PO_VMSJ    OUT VARCHAR2) IS
  BEGIN

    PO_NMSJ := 0;
    PO_VMSJ := 'OK';

    SELECT NUMSEC
      INTO PO_NUMSEC
      FROM SOLOT
     WHERE CODSOLOT = PI_NSOT;

    IF PO_NUMSEC IS NULL THEN
      SELECT DISTINCT I.NUMSEC
      INTO PO_NUMSEC
      FROM SOLOT S
      INNER JOIN SOLOTPTO PTO
        ON S.CODSOLOT = PTO.CODSOLOT
      INNER JOIN INSSRV I
        ON PTO.CODINSSRV = I.CODINSSRV
      WHERE S.CODSOLOT = PI_NSOT
        AND I.NUMSEC IS NOT NULL;
    END IF;

    IF PO_NUMSEC IS NULL THEN
        PO_NMSJ := -1;
        PO_VMSJ := 'NO SE ENCONTRO NUMSEC PARA LA SOT INDICADA';
    END IF;

  EXCEPTION
    WHEN OTHERS THEN
      PO_NMSJ := -1;
      PO_VMSJ := 'ERROR EN LA VALIDACION DE NUMSEC';
  END;
  /* *********************************************************************************************************
  * NOMBRE SP            : SGASU_PORTOUT_SERV_BSCS
  * PROPOSITO            :
  * INPUT                : PI_PROCESO_ID  ID DE PROCESO
                           PI_CO_ID       CODIGO DE CONTRATO
  * OUTPUT               : PO_RESULTADO   RESULTADO
                           PO_MENSAJE     MENSAJE DE VALIDACION
  * CREACION             : 11/10/2018     JENY VALENCIA
  '***********************************************************************************************************/
  PROCEDURE SGASU_PORTOUT_SERV_BSCS(PI_PROCESO_ID  NUMBER,
                                  PI_CO_ID        NUMBER,
                                    PO_RESULTADO    OUT NUMBER,
                                    PO_MENSAJE      OUT VARCHAR2) IS

    LN_TMCODE   NUMBER;
    LN_SPCODE   NUMBER;
    LN_SNCODE   NUMBER;
    LN_CFSISACT NUMBER(9, 2);
    LS_CABLE    VARCHAR2(100);
    LS_INTERNET VARCHAR2(100);
    LV_OBS      VARCHAR2(255);
    LN_RESULTADO  NUMBER;
    LV_MENSAJE  VARCHAR2(100);
    LN_VAL_INT  NUMBER;
    EXC_VAL     EXCEPTION;

    CURSOR C_DET IS
      SELECT *
        FROM SALES.INT_PORTABILIDAD_DET
       WHERE PROCESO_ID = NVL(PI_PROCESO_ID,PROCESO_ID)
         AND COD_ID = NVL(PI_CO_ID,COD_ID)
         AND IDSRV_SISACT IS NOT NULL
         AND TIPSRV IN (LS_CABLE, LS_INTERNET)
         AND CODEQUCOM IS NULL
         AND (SNCODE IS NULL OR
              TMCODE IS NULL OR
              SPCODE IS NULL )
       ORDER BY SOT_ORI,TIPSRV,FLGPRINC DESC;

    CURSOR C_DET2 IS
      SELECT *
        FROM SALES.INT_PORTABILIDAD_DET
       WHERE PROCESO_ID = NVL(PI_PROCESO_ID,PROCESO_ID)
         AND COD_ID = NVL(PI_CO_ID,COD_ID)
         AND IDSRV_SISACT IS NULL
         AND TIPSRV IN (LS_CABLE, LS_INTERNET)
         AND CODEQUCOM IS NULL
         AND (SNCODE IS NULL OR
              TMCODE IS NULL OR
              SPCODE IS NULL )
       ORDER BY SOT_ORI,TIPSRV,FLGPRINC DESC;

  BEGIN
    PO_RESULTADO := 0;
    PO_MENSAJE   := 'OK';

    SELECT VALOR
      INTO LS_CABLE
      FROM OPERACION.CONSTANTE
     WHERE CONSTANTE = 'FAM_CABLE';

    SELECT VALOR
      INTO LS_INTERNET
      FROM OPERACION.CONSTANTE
     WHERE CONSTANTE = 'FAM_INTERNET';

    UPDATE SALES.INT_PORTABILIDAD_DET DET
    SET IDSRV_SISACT =  (SELECT sis.idservicio_sisact
                           FROM SALES.SERVICIO_SISACT SIS
                          WHERE SIS.CODSRV = DET.CODSRV)
    WHERE IDSRV_SISACT IS NULL;
    COMMIT;

    FOR LC_DET2 IN C_DET2 LOOP
        SGASU_PORTOUT_BSCS_ALT(  LC_DET2.CODSRV
                               , LC_DET2.DSCSRV
                               , LC_DET2.TIPSRV
                               , LN_SNCODE
                               , LN_SPCODE
                               , LN_TMCODE
                               , LN_RESULTADO
                               , LV_MENSAJE);
    END LOOP;

    FOR LC_DET IN C_DET LOOP
      LN_SNCODE   := NULL;
      LN_TMCODE   := NULL;
      LN_SPCODE   := NULL;
      LN_CFSISACT := NULL;
      LV_OBS      := NULL;
      LN_VAL_INT  := 0;

      IF LC_DET.IDSRV_SISACT IS NULL THEN
         LV_OBS := 'NO SE ENCONTRO IDSRV_SISACT RELACIONADO';
      END IF;

      BEGIN
        SELECT SERVV_ID_BSCS
          INTO LN_SNCODE
          FROM USRPVU.SISACT_AP_SERVICIO@DBL_PVUDB
         WHERE SERVV_CODIGO = LC_DET.IDSRV_SISACT;
      EXCEPTION
        WHEN OTHERS THEN
          IF LV_OBS IS NULL THEN
            LV_OBS := 'NO SE ENCONTRO SNCODE RELACIONADO';
          END IF;
      END;

      BEGIN
        SELECT TMCODE, SPCODE
          INTO LN_TMCODE, LN_SPCODE
          FROM SYSADM.MPULKTMB@DBL_BSCS_BF T1
         WHERE TMCODE IN
               (SELECT D.Codigon
                  FROM OPEDD D, TIPOPEDD C
                 WHERE D.TIPOPEDD = C.TIPOPEDD
                   AND C.ABREV = 'BSCS_CONTRATO'
                   AND D.ABREVIACION = 'PLAN'
           AND D.CODIGON_AUX = 1)
           AND VSCODE = (SELECT MAX(VSCODE)
                           FROM SYSADM.MPULKTMB@DBL_BSCS_BF
                          WHERE TMCODE = T1.TMCODE
                            AND SNCODE = T1.SNCODE)
           AND SNCODE = LN_SNCODE;
      EXCEPTION
        WHEN OTHERS THEN
            SGASU_PORTOUT_BSCS_ALT(  LC_DET.CODSRV
                                   , LC_DET.DSCSRV
                                   , LC_DET.TIPSRV
                                   , LN_SNCODE
                                   , LN_SPCODE
                                   , LN_TMCODE
                                   , LN_RESULTADO
                                   , LV_MENSAJE);
           IF LN_RESULTADO = -1 THEN
            IF LV_OBS IS NULL THEN
              LV_OBS := 'NO SE ENCONTRO TMCODE, SPCODE RELACIONADO';
            END IF;
           END IF;
      END;

      BEGIN
        select T1.PSRVN_CARGO_FIJO
          INTO LN_CFSISACT
          FROM USRPVU.SISACT_AP_PLAN_SERV@DBL_PVUDB T1
         inner join USRPVU.SISACT_AP_SERVICIO@DBL_PVUDB T2
            ON T2.SERVV_CODIGO = T1.SERVV_CODIGO
           AND T2.SERVV_ID_BSCS = LN_SNCODE
           AND T1.plnv_codigo IN
               (SELECT TO_CHAR(D.Codigon)
                  FROM OPEDD D, TIPOPEDD C
                 WHERE D.TIPOPEDD = C.TIPOPEDD
                   AND C.ABREV = 'BSCS_CONTRATO'
                   AND D.ABREVIACION = 'PLAN_LTE_SISACT'
           AND D.CODIGON_AUX = 1);
      EXCEPTION
        WHEN OTHERS THEN
          IF LV_OBS IS NULL THEN
            LV_OBS := 'NO SE ENCONTRO CFSISACT RELACIONADO';
          END IF;
      END;

      UPDATE SALES.INT_PORTABILIDAD_DET
      SET TMCODE      = LN_TMCODE,
       SPCODE      = LN_SPCODE,
       SNCODE      = LN_SNCODE,
       CF_SISACT   = LN_CFSISACT,
       OBSERVACION = LV_OBS
      WHERE PROCESO_ID = LC_DET.PROCESO_ID
        AND TIPSRV = LC_DET.TIPSRV
        AND COD_ID = LC_DET.COD_ID
        AND CODSRV = LC_DET.CODSRV;
      COMMIT;
    END LOOP;

    -- ASIGNA SERVICIO BSCS DECO
    SGASU_PORTOUT_DECO_BSCS(  PI_PROCESO_ID
                            , PI_CO_ID
                            , LN_RESULTADO
                            , LV_MENSAJE);
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
  END;
  /**********************************************************************************************************
  * NOMBRE SP            : SGASU_PORTOUT_DECO_BSCS
  * PROPOSITO            : ASIGNA SERVICIO BSCS DECO
  * OUTPUT               :
  * CREACION             : 15/10/2018 JENY VALENCIA
  '*********************************************************************************************************/
  PROCEDURE SGASU_PORTOUT_DECO_BSCS(PI_PROCESO_ID  OPERACION.SOLOT.COD_ID%TYPE,
                                   PI_CO_ID        NUMBER,
                                   PO_RESULTADO    OUT NUMBER,
                                   PO_MENSAJE      OUT VARCHAR2) IS

    LN_TMCODE   NUMBER;
    LN_SPCODE   NUMBER;
    LN_SNCODE   NUMBER;
    LN_IDSRV_SISACT NUMBER;
    LN_CFSISACT NUMBER(9, 2);
    LS_CABLE    VARCHAR2(100);
    LV_OBS      VARCHAR2(255);
    LN_VAL_INT  NUMBER;
    EXC_VAL     EXCEPTION;

    CURSOR C_DET IS
      SELECT  DET.SOT_ORI
             ,DET.TIPSRV
             ,DET.COD_ID
             ,DET.CODEQUCOM
             ,DET.CODSRV
             ,DET.PROCESO_ID
             ,VT.TIP_EQ,
              (row_number()
              OVER (PARTITION BY  DET.SOT_ORI,VT.TIP_EQ ORDER BY DET.SOT_ORI,TIP_EQ)) NUM_DECO
        FROM   SALES.INT_PORTABILIDAD_DET DET
             , VTAEQUCOM VT
             , TYSTABSRV TY
       WHERE PROCESO_ID =  NVL(PI_PROCESO_ID,PROCESO_ID)
         AND DET.CODEQUCOM = VT.CODEQUCOM
         AND VT.TIP_EQ LIKE '%DECO%'
         AND DET.CODSRV = TY.CODSRV
         AND COD_ID = NVL(PI_CO_ID,COD_ID)
         AND DET.TIPSRV IN (LS_CABLE)
         AND NVL(TY.FLGEQU,0) = 0
         AND DET.SNCODE IS NULL
       ORDER BY SOT_ORI,FLGPRINC DESC;

  BEGIN
    PO_RESULTADO := 0;
    PO_MENSAJE   := 'OK';
    SELECT VALOR
      INTO LS_CABLE
      FROM OPERACION.CONSTANTE
    WHERE CONSTANTE = 'FAM_CABLE';

    FOR LC_DET IN C_DET LOOP
      LN_SNCODE   := NULL;
      LN_TMCODE   := NULL;
      LN_SPCODE   := NULL;
      LN_CFSISACT := NULL;
      LV_OBS      := NULL;
      LN_IDSRV_SISACT := NULL;
      LN_VAL_INT  := 0;

      -- SNCODE
      BEGIN
        SELECT D.CODIGON
        INTO LN_SNCODE
        FROM OPEDD D, TIPOPEDD C
        WHERE D.TIPOPEDD = C.TIPOPEDD
        AND C.ABREV       = 'BSCS_CONTRATO'
        AND D.ABREVIACION = 'SNCODE_DECO'
        AND D.CODIGOC     = LC_DET.TIP_EQ
        AND D.CODIGON_AUX = LC_DET.NUM_DECO;
      EXCEPTION
        WHEN OTHERS THEN
          LV_OBS := NVL(LV_OBS,'NO SE ENCONTRO SNCODE RELACIONADO');
      END;

       -- IDSRV_SISACT
      BEGIN
        SELECT MAX(SERVV_CODIGO)
        INTO LN_IDSRV_SISACT
        FROM USRPVU.SISACT_AP_SERVICIO@DBL_PVUDB SISACT
        WHERE SERVV_ID_BSCS = LN_SNCODE;
      EXCEPTION
        WHEN OTHERS THEN
           LV_OBS := NVL(LV_OBS,'NO SE ENCONTRO IDSRV_SISACT RELACIONADO');
      END;

      -- TMCODE
      BEGIN
        SELECT TMCODE, SPCODE
          INTO LN_TMCODE, LN_SPCODE
          FROM SYSADM.MPULKTMB@DBL_BSCS_BF T1
         WHERE TMCODE IN
               (SELECT D.Codigon
                  FROM OPEDD D, TIPOPEDD C
                 WHERE D.TIPOPEDD = C.TIPOPEDD
                   AND C.ABREV = 'BSCS_CONTRATO'
                   AND D.ABREVIACION = 'PLAN'
           AND D.CODIGON_AUX = 1)
           AND VSCODE = (SELECT MAX(VSCODE)
                           FROM SYSADM.MPULKTMB@DBL_BSCS_BF
                          WHERE TMCODE = T1.TMCODE
                            AND SNCODE = T1.SNCODE)
           AND SNCODE = LN_SNCODE;
      EXCEPTION
        WHEN OTHERS THEN
          IF LV_OBS IS NULL THEN
            LV_OBS := 'NO SE ENCONTRO TMCODE, SPCODE RELACIONADO';
          END IF;
      END;

      -- CFSISACT
      BEGIN
        select T1.PSRVN_CARGO_FIJO
          INTO LN_CFSISACT
          from USRPVU.SISACT_AP_PLAN_SERV@DBL_PVUDB T1
         inner join USRPVU.SISACT_AP_SERVICIO@DBL_PVUDB T2
            ON T2.SERVV_CODIGO = T1.SERVV_CODIGO
           AND T2.SERVV_ID_BSCS = LN_SNCODE
           AND T1.plnv_codigo IN
               (SELECT TO_CHAR(D.Codigon)
                  FROM OPEDD D, TIPOPEDD C
                 WHERE D.TIPOPEDD = C.TIPOPEDD
                   AND C.ABREV = 'BSCS_CONTRATO'
                   AND D.ABREVIACION = 'PLAN_LTE_SISACT'
           AND D.CODIGON_AUX = 1);
      EXCEPTION
        WHEN OTHERS THEN
          IF LV_OBS IS NULL THEN
            LV_OBS := 'NO SE ENCONTRO CFSISACT RELACIONADO';
          END IF;
      END;

      UPDATE SALES.INT_PORTABILIDAD_DET
      SET TMCODE      = LN_TMCODE,
          SPCODE      = LN_SPCODE,
          SNCODE      = LN_SNCODE,
          IDSRV_SISACT= LN_IDSRV_SISACT,
          CF_SISACT   = LN_CFSISACT,
          OBSERVACION = LV_OBS
      WHERE PROCESO_ID = LC_DET.PROCESO_ID
        AND TIPSRV = LC_DET.TIPSRV
        AND COD_ID = LC_DET.COD_ID
        AND CODSRV = LC_DET.CODSRV
        AND CODEQUCOM = LC_DET.CODEQUCOM;

      COMMIT;
    END LOOP;

  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
  END;
  /**********************************************************************************************************
  * NOMBRE SP            : SGASU_PORTOUT_BSCS_ALT
  * PROPOSITO            : ASIGNA SERVICIO BSCS ALTERNATIVO
  * OUTPUT               :
  * CREACION             : 15/10/2018 JENY VALENCIA
  '*********************************************************************************************************/
  PROCEDURE SGASU_PORTOUT_BSCS_ALT(PI_CODSRV       IN  VARCHAR2,
                                   PI_DSCSRV       IN  VARCHAR2,
                                   PI_TIPO         IN  VARCHAR2,
                                   PO_SNCODE       OUT NUMBER,
                                   PO_SPCODE       OUT NUMBER,
                                   PO_TMCODE       OUT NUMBER,
                                   PO_RESULTADO    OUT NUMBER,
                                   PO_MENSAJE      OUT VARCHAR2) IS
    LN_IDSERVICIO  NUMBER;
    LV_CODSRVNUE VARCHAR2(50);
    LS_INTERNET VARCHAR2(100);

  BEGIN
    PO_RESULTADO := 0;
    PO_MENSAJE := 'OK';

    SELECT VALOR
      INTO LS_INTERNET
      FROM OPERACION.CONSTANTE
     WHERE CONSTANTE = 'FAM_INTERNET';

    BEGIN
      SELECT    T.CODSRV
              , SIS.IDSERVICIO_SISACT
              , BSCS.SNCODE
              , BSCS.SPCODE
              , BSCS.TMCODE

      INTO      LV_CODSRVNUE
              , LN_IDSERVICIO
              , PO_SNCODE
              , PO_SPCODE
              , PO_TMCODE
      FROM SALES.SERVICIO_SISACT SIS
      INNER JOIN TYSTABSRV T
      ON  SIS.CODSRV = T.CODSRV
      INNER JOIN USRPVU.SISACT_AP_SERVICIO@DBL_PVUDB PVU
      ON PVU.SERVV_CODIGO = SIS.IDSERVICIO_SISACT
      INNER JOIN SYSADM.MPULKTMB@DBL_BSCS_BF BSCS
      ON BSCS.SNCODE = PVU.SERVV_ID_BSCS
      WHERE UPPER(REPLACE(DSCSRV,' ','')) = UPPER(REPLACE(PI_DSCSRV,' ',''))
      AND TMCODE IN
           (SELECT D.CODIGON
              FROM OPEDD D, TIPOPEDD C
             WHERE D.TIPOPEDD = C.TIPOPEDD
               AND C.ABREV = 'BSCS_CONTRATO'
               AND D.ABREVIACION = 'PLAN'
         AND D.CODIGON_AUX = 1)
       AND ROWNUM = 1;
    EXCEPTION
      WHEN OTHERS THEN
       PO_TMCODE := 0;
    END;

   IF PO_TMCODE =  0 AND PI_TIPO = LS_INTERNET THEN
     BEGIN
      SELECT    T.CODSRV
              , SIS.IDSERVICIO_SISACT
              , BSCS.SNCODE
              , BSCS.SPCODE
              , BSCS.TMCODE

      INTO      LV_CODSRVNUE
              , LN_IDSERVICIO
              , PO_SNCODE
              , PO_SPCODE
              , PO_TMCODE
      FROM SALES.SERVICIO_SISACT SIS
      INNER JOIN TYSTABSRV T
      ON  SIS.CODSRV = T.CODSRV
      INNER JOIN USRPVU.SISACT_AP_SERVICIO@DBL_PVUDB PVU
      ON PVU.SERVV_CODIGO = SIS.IDSERVICIO_SISACT
      INNER JOIN SYSADM.MPULKTMB@DBL_BSCS_BF BSCS
      ON BSCS.SNCODE = PVU.SERVV_ID_BSCS
      WHERE  UPPER(REPLACE(PI_DSCSRV,' ','')) LIKE UPPER(REPLACE(DSCSRV,' ',''))||'%'
      AND TMCODE IN
           (SELECT D.CODIGON
              FROM OPEDD D, TIPOPEDD C
             WHERE D.TIPOPEDD = C.TIPOPEDD
               AND C.ABREV = 'BSCS_CONTRATO'
               AND D.ABREVIACION = 'PLAN'
         AND D.CODIGON_AUX = 1)
      AND ROWNUM = 1;
     EXCEPTION
        WHEN OTHERS THEN
         PO_TMCODE := 0;
     END;
   END IF;

   IF PO_TMCODE > 0 THEN
      UPDATE SALES.INT_PORTABILIDAD_DET DET
      SET IDSRV_SISACT = LN_IDSERVICIO,
          CODSRVNUE = LV_CODSRVNUE
      WHERE CODSRV = PI_CODSRV
            AND TMCODE IS NULL;
      COMMIT;
   END IF;

   IF PO_TMCODE =  0 THEN
     PO_TMCODE := NULL;
     PO_RESULTADO := -1;
   END IF;
  END;
  /**********************************************************************************************************
  * NOMBRE SP            : SGASI_GENERA_LOG
  * PROPOSITO            : GENERA LOG
  * OUTPUT               :
  * CREACION             : 15/10/2018 JENY VALENCIA
  '*********************************************************************************************************/
  PROCEDURE SGASI_GENERA_LOG(PI_PARAMETROS   IN VARCHAR2,
                      PI_SUBPROCESO  IN VARCHAR2,
                      PI_MSGCODE     IN NUMBER,
                      PI_MENSAJE     IN VARCHAR2) IS

  PRAGMA AUTONOMOUS_TRANSACTION;  --4.0

  LV_MENSAJE VARCHAR2(2000);
  BEGIN
    INSERT INTO SALES.INT_PORTABILIDAD_LOG
      (PARAMETROS,SUBPROCESO,MSGCODE, MENSAJE)  --4.0
    VALUES
       (PI_PARAMETROS, PI_SUBPROCESO, PI_MSGCODE, PI_MENSAJE);  --4.0
    COMMIT;

  EXCEPTION
    WHEN OTHERS THEN
      LV_MENSAJE := SQLERRM ||' - Linea ('||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE||')';
      ROLLBACK;
  END;
--3.0 Ini
  PROCEDURE SGASS_VAL_CONTRATO_FIJA(PI_CODSOLOT  IN operacion.solot.codsolot%TYPE,
                                    PO_RESULTADO OUT NUMBER,
                                    PO_MENSAJE   OUT VARCHAR2) IS

  V_CONT NUMBER := 0;

  BEGIN

    PO_RESULTADO := 0;
    PO_MENSAJE   := 'NO Tiene Contrato Asociado';

    -- Verficamos si la SOT tiene contrato asociado.
    SELECT COUNT(*)
    INTO V_CONT
    FROM OPERACION.SOLOT S
    WHERE S.CODSOLOT = PI_CODSOLOT AND S.COD_ID IS NOT NULL;

    IF V_CONT > 0 THEN
        PO_MENSAJE   := 'Tiene Contrato Asociado';
    END IF;

    PO_RESULTADO := V_CONT;

  EXCEPTION
    WHEN OTHERS THEN
      PO_RESULTADO := -1;
      PO_MENSAJE   := 'SGASS_VAL_CONTRATO_FIJA: Error al validar contrato. ' ||
                      SQLERRM || '.';

  END;
--3.0 Fin
END;
/