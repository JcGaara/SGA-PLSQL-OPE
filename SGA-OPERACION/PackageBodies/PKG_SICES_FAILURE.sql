CREATE OR REPLACE PACKAGE BODY OPERACION.PKG_SICES_FAILURE IS

  /* *************************************************************
  Nombre SP          : SICESS_JANUS
  Proposito          : Consulta servicios por codigo de sursal
  Input              : PI_V_SUCURSAL - Codigo de la sucursal
                       PI_GEPACODE - Codigo del parametro
                       PI_GEPAVALUE - Codigo del item
  Output             : PO_CODIGO_SALIDA - Codigo para validar el resultado de salida
                       PO_MENSAJE_SALIDA - Mensaje correspondiente al codigo de salida
                       PO_CURSOR_EQUIPO - Contiene el resultado de la consulta
  Creado por         : Everis
  Fec Creacion       : 20-02-2017
  Fec Actualizacion  : 20-02-2017
  ************************************************************* */
  PROCEDURE SICESS_JANUS(PI_V_SUCURSAL     IN VARCHAR2,
                         PI_GEPACODE       IN USRSICES.SICET_GENERICPARAMETER.C_GEPACODE%TYPE,
                         PI_GEPAVALUE      IN USRSICES.SICET_GENERICPARAMETER.I_GEPAVALUE%TYPE,
                         PO_CODE_RESULT    OUT INTEGER,
                         PO_MESSAGE_RESULT OUT VARCHAR2,
                         PO_CURSOR         OUT SYS_REFCURSOR) IS
    C_QUERY varchar2(32767);
    V_NUMERO VARCHAR2(30);
    n_valida number default 0;
  BEGIN

    PO_CODE_RESULT := 0;
    begin
      select distinct '0051' || A.NUMERO into V_NUMERO
      from OPERACION.inssrv a, SALES.vtatabslcfac b,OPERACION.solot c
      where a.codsuc=PI_V_SUCURSAL and a.numslc=b.numslc and b.numslc=c.numslc 
      AND estinssrv in (1,2) AND A.TIPINSSRV=3 AND ROWNUM=1 AND A.NUMERO IS NOT NULL;
    exception
      when no_data_found then
        n_valida := 1;
    end;    
    if n_valida=0 then --Si encuentra un numero valido
      SELECT G.D_NOTES
        INTO C_QUERY
        from USRSICES.SICET_GENERICPARAMETER G
       WHERE G.C_GEPACODE = PI_GEPACODE
         AND G.I_GEPAVALUE = PI_GEPAVALUE;
      C_QUERY := REPLACE(C_QUERY, '@PI_NRO', V_NUMERO);

      OPEN PO_CURSOR FOR C_QUERY;

      PO_CODE_RESULT    := '0';
      PO_MESSAGE_RESULT := 'EXITO';
    else--Si no encuentra ningun numero
      OPEN PO_CURSOR FOR
        SELECT '' numero,
               '' customer_id,
               '' codplan,
               '' producto,
               '' tipoplan,
               '' fecini,
               '' flg_estado,
               '' estado,
               '' ciclo
          FROM DUAL
         WHERE ROWNUM < 1;
        PO_CODE_RESULT    := '0';
        PO_MESSAGE_RESULT := 'NO ENCUENTRA NUMERO';
         
    end if;
  EXCEPTION
    WHEN OTHERS THEN
      PO_CODE_RESULT    := '-1';
      PO_MESSAGE_RESULT := SUBSTR(SQLERRM, 1, 200);

      OPEN PO_CURSOR FOR
        SELECT '' numero,
               '' customer_id,
               '' codplan,
               '' producto,
               '' tipoplan,
               '' fecini,
               '' flg_estado,
               '' estado,
               '' ciclo
          FROM DUAL
         WHERE ROWNUM < 1;

  END SICESS_JANUS;

  PROCEDURE SICESS_DETALLE_SERVICIO_SGA(PI_COD_SUCURSAL    IN VARCHAR2,
                                      PI_CUSTOMERID      IN VARCHAR2,
                                      PO_ESTADO_SERVICIO OUT VARCHAR2,
                                      PO_MOTIVO_SERVICIO OUT VARCHAR2,
                                      PO_CODERROR        OUT NUMBER,
                                      PO_DESCERROR       OUT VARCHAR2)
IS
BEGIN

PO_MOTIVO_SERVICIO:='';

SELECT E.DESCRIPCION
  INTO PO_ESTADO_SERVICIO
  FROM SOLOT S, SOLOTPTO SP, INSSRV I, INSPRD IP, ESTINSSRV E
 WHERE S.CUSTOMER_ID = PI_CUSTOMERID
   AND S.CODSOLOT = SP.CODSOLOT
   AND SP.CODINSSRV = I.CODINSSRV
   AND IP.CODINSSRV = I.CODINSSRV
   AND IP.FLGPRINC = 1
   AND I.ESTINSSRV = E.ESTINSSRV
   AND I.CODSUC = PI_COD_SUCURSAL
   AND ROWNUM = 1;

PO_CODERROR := 0;
PO_DESCERROR := 'OK';
exception
  when NO_DATA_FOUND then 
    PO_ESTADO_SERVICIO:='';
    PO_CODERROR := -1;
    PO_DESCERROR := 'No se encontro registros';
    return;
  
  when others then
    PO_CODERROR := SQLCODE;
    PO_DESCERROR := SUBSTR(SQLERRM, 1, 250);
END;      

  /****************************************************************
  '* Nombre SP           :  SICESS_VALIDATESERVICE
  '* Proposito           :  EL SIGUIENTE SP VALIDA EL SERVICIO DE UN CLIENTE MEDIANTE REGLAS
  '* Inputs              :  PI_CUSTOMERID - Codigo del cliente
                            PI_CODID - Codigo del contrato
                            PI_CODSOLOT - Codigo de SOT  de trabajo
                            PI_TELEFONO - Numero de telefono
                            PI_CICLOOAC - Ciclo de facturacion OAC
                            PI_RULERS - Reglas a evaluar
  '* Output              :  PO_CODE_RESULT - Codigo de Resultado:
                            PO_MESSAGE_RESULT - Mensaje de Resultado.
                            PO_CURSOR_RULERS - Resultado de validacion de reglas
                              RULER - Identificador de regla
                              1  -> Planes telefonia BSCS vs Jannus
                              2  -> Planes internet/TV BSCS vs Incognito
                              3  -> Ciclo facturacion BSCS vs OAC
                              4  -> Nro telefono BSCS vs Incognito
                              5  -> MAC telefonia SGA vs Incognito
                              6  -> MAC internet SGA vs Incognito
                              7  -> NumeroSerie TV SGA vs Incognito
                              8  -> Validar NCOS3
                              RESULT
                              0  -> DESALINEADO
                              1  -> ALINEADO
                              2  -> SERVICIO NO ENCONTRADO
                              -1 -> ERROR DE ORACLE
  '* Creado por          :  Hitss
  '* Fec Creacion        :  28/01/2019
  '* Fec Actualizacion   :  28/01/2019
  '****************************************************************/
  PROCEDURE SICESS_VALIDATESERVICE(PI_CUSTOMERID     IN VARCHAR2,
                                   PI_COID           IN VARCHAR2,
                                   PI_CODSOLOT       IN OPERACION.SOLOT.CODSOLOT%TYPE,
                                   PI_TELEFONO       IN VARCHAR2,
                                   PI_CICLOOAC       IN VARCHAR2,
                                   PI_RULERS         IN VARCHAR2,
                                   PO_CODE_RESULT    OUT INTEGER,
                                   PO_MESSAGE_RESULT OUT VARCHAR2,
                                   PO_CURSOR_RULERS  OUT SYS_REFCURSOR) IS
    T_INT         VARCHAR2(50) DEFAULT NULL;
    V_INT         VARCHAR(5) := 'INT';
    T_CTV         VARCHAR2(50) DEFAULT NULL;
    V_CTV         VARCHAR(5) := 'CTV';
    V_CANTSGA     INTEGER;
    V_CANTINC     INTEGER;
    T_VALIDA      INTEGER;
    T_RULER       INTEGER;
    V_RULER       INTEGER;
    V_PLANJANNUS  INTEGER;
    V_PLANBSCS    INTEGER;
    V_CICLOBSCS   INTEGER;
    E_INT         INTEGER;
    E_TLF         INTEGER;
    E_CTV         INTEGER;
    V_DELIMITER   VARCHAR2(1) := '|';
    T_PLANJANNUS  VARCHAR2(30) DEFAULT NULL;
    T_PLANBSCS    VARCHAR2(30) DEFAULT NULL;
    T_CICLOBSCS   VARCHAR2(3) DEFAULT NULL;
    T_TELEPHONE   VARCHAR2(30) := '';
    T_VAL_RULER   VARCHAR2(300) := 'SELECT @RULER AS RULER, @RESULT AS RESULT, ''@DETAIL'' AS DETAIL FROM DUAL';
    T_UNION       VARCHAR2(30) := ' UNION ALL ';
    T_ORDERBY     VARCHAR2(30) := ' ORDER BY 1 ASC';
    T_TOTAL_RULER VARCHAR(5000) := '';
    V_DETAIL      VARCHAR(1000) := '';
    V_CURSOR_INC  SYS_REFCURSOR;
    TYPE I_ROW IS RECORD(
      TIP_INTERFASE          VARCHAR2(5),
      MAC_ADDRESS_SERIAL     VARCHAR2(40),
      SERVICENAME            VARCHAR2(100));
    I_REC        I_ROW;
    V_CURSOR_SGA SYS_REFCURSOR;
    TYPE S_ROW IS RECORD(
      TIP_INTERFASE        VARCHAR2(3),
      CODIGO_EXTERNO       VARCHAR2(100),
      DSCSRV               VARCHAR2(100),
      ANCHO_BANDA_INTERNET VARCHAR2(15));
    S_REC         S_ROW;
    V_CODE_SGA    INTEGER DEFAULT - 1;
    V_MESSAGE_SGA VARCHAR2(500) DEFAULT NULL;
    V_CODE_INC    INTEGER DEFAULT - 1;
    V_MESSAGE_INC VARCHAR2(500) DEFAULT NULL;
    WE_EXCEPTION EXCEPTION;
  BEGIN
    IF PI_RULERS IS NOT NULL THEN
    SELECT DISTINCT USRSICES.PKG_SICES_FAILURE.SICEFUN_COUNTSERVICES(I.CODSUC, '0006', I.CODCLI) AS INTERNET,
                    USRSICES.PKG_SICES_FAILURE.SICEFUN_COUNTSERVICES(I.CODSUC, '0004', I.CODCLI) AS TELEFONIA,
                    USRSICES.PKG_SICES_FAILURE.SICEFUN_COUNTSERVICES(I.CODSUC, '0062', I.CODCLI) AS CABLE
      INTO E_INT, E_TLF, E_CTV
      FROM OPERACION.SOLOT S, SALES.VTATABSLCFAC P, OPERACION.INSSRV I
     WHERE S.NUMSLC = P.NUMSLC
       AND P.NUMSLC = I.NUMSLC
       AND I.ESTINSSRV IN (1, 2) -- ACTIVOS Y SUSPENDIDOS
       AND S.ESTSOL IN (12, 29)
       AND S.CUSTOMER_ID = PI_CUSTOMERID
       AND EXISTS (SELECT 1
              FROM TIPOPEDD TT, OPEDD OO
             WHERE TT.TIPOPEDD = OO.TIPOPEDD
               AND TT.ABREV IN ('TIPREGCONTIWSGABSCS')
               AND OO.CODIGON = S.TIPTRA);
      --VALIDA REGLA 1 - VALIDA PLAN DE TELEFONiA JANNUS VS BSCS
    T_RULER     := 1;
      SELECT COUNT(1)
        INTO V_RULER
        FROM TABLE(USRSICES.PKG_SICES_FAILURE.SICEFUN_SPLIT(TRIM(PI_RULERS), V_DELIMITER))
       WHERE COLUMN_VALUE = T_RULER;
      IF E_TLF = 1 AND V_RULER > 0 THEN
    T_TELEPHONE := '0051' || PI_TELEFONO;
    BEGIN
      SELECT DISTINCT TRIM(PC.EXTERNAL_PAYER_ID_V) || TRIM(PT.TARIFF_ID_N)
        INTO T_PLANJANNUS
        FROM JANUS_PROD_PE.CONNECTIONS@DBL_JANUS              C,
             JANUS_PROD_PE.CONNECTION_ACCOUNTS@DBL_JANUS      CA,
             JANUS_PROD_PE.PAYER_TARIFFS@DBL_JANUS            PT,
             JANUS_PROD_PE.TARIFF_MASTER@DBL_JANUS            TM,
             JANUS_PROD_PE.PAYERS@DBL_JANUS                   P,
             JANUS_PROD_PE.PAYERS@DBL_JANUS                   PC,
             JANUS_PROD_PE.PAYER_BILL_CYCLE_DETAILS@DBL_JANUS PB
       WHERE C.ACCOUNT_ID_N = CA.ACCOUNT_ID_N
         AND C.START_DATE_DT = (SELECT MAX(START_DATE_DT)
                                  FROM JANUS_PROD_PE.CONNECTIONS@DBL_JANUS
                                 WHERE CONNECTION_ID_V = C.CONNECTION_ID_V)
         AND CA.START_DATE_DT = (SELECT MAX(START_DATE_DT)
                                   FROM JANUS_PROD_PE.CONNECTION_ACCOUNTS@DBL_JANUS
                                  WHERE ACCOUNT_ID_N = CA.ACCOUNT_ID_N)
         AND CA.PAYER_ID_0_N = P.PAYER_ID_N
         AND CA.PAYER_ID_0_N = PT.PAYER_ID_N
         AND P.PAYER_ID_N = PB.PAYER_ID_N
         AND PT.TARIFF_ID_N = TM.TARIFF_ID_N
         AND PT.START_DATE_DT = (SELECT MAX(START_DATE_DT)
                                   FROM JANUS_PROD_PE.PAYER_TARIFFS@DBL_JANUS
                                  WHERE TARIFF_ID_N = PT.TARIFF_ID_N
                                    AND PAYER_ID_N = PT.PAYER_ID_N)
         AND PT.STATUS_N = 1
         AND CA.PAYER_ID_3_N = PC.PAYER_ID_N
         AND TM.TARIFF_TYPE_V = 'B' -- Solo plan base
         AND C.CONNECTION_ID_V = T_TELEPHONE;
      V_PLANJANNUS := 1;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        V_PLANJANNUS := 2;
      WHEN OTHERS THEN
        V_PLANJANNUS := -1;
    END;
    BEGIN
      SELECT DISTINCT TRIM(P.CUSTOMER_ID) || TRIM(SERV.CODPLAN)
        INTO T_PLANBSCS
        FROM CONTRACT_ALL@DBL_BSCS_BF P,
             CUSTOMER_ALL@DBL_BSCS_BF CU,
             (SELECT SSH.CO_ID,
                     PLJ.PARAM1 CODPLAN,
                     RP.DES DESC_PLAN,
                     OPERACION.PQ_CONT_REGULARIZACION.F_VAL_TIPO_SERVICIO_BSCS(SSH.SNCODE) TIPO_SERVICIO
                FROM PR_SERV_STATUS_HIST@DBL_BSCS_BF   SSH,
                     PROFILE_SERVICE@DBL_BSCS_BF       PS,
                     MPUSNTAB@DBL_BSCS_BF              SN,
                     CONTRACT_ALL@DBL_BSCS_BF          CA,
                     RATEPLAN@DBL_BSCS_BF              RP,
                     TIM.PF_HFC_PARAMETROS@DBL_BSCS_BF PLJ
               WHERE SSH.SNCODE = SN.SNCODE
                 AND SSH.STATUS IN ('A', 'O', 'S')
                 AND PS.STATUS_HISTNO = SSH.HISTNO
                 AND SSH.SNCODE = PS.SNCODE
                 AND SSH.CO_ID = PS.CO_ID
                 AND SSH.CO_ID = CA.CO_ID
                 AND CA.CO_ID = PI_COID
                 AND CA.TMCODE = RP.TMCODE
                 AND SSH.SNCODE = PLJ.COD_PROD1
                 AND PLJ.CAMPO = 'SERV_TELEFONIA'
                 AND SN.SNCODE NOT IN (SELECT O.CODIGON
                                         FROM TIPOPEDD T, OPEDD O
                                        WHERE T.TIPOPEDD = O.TIPOPEDD
                                          AND T.ABREV = 'SNCODENOHFC_BSCS')) SERV
       WHERE P.SCCODE = 6
         AND P.CO_ID = SERV.CO_ID
         AND CU.CUSTOMER_ID = P.CUSTOMER_ID
         AND SERV.TIPO_SERVICIO = 'TLF'
         AND P.CO_ID = PI_COID;
      V_PLANBSCS := 1;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        V_PLANBSCS := 2;
      WHEN OTHERS THEN
        V_PLANBSCS := -1;
    END;
    IF V_PLANBSCS = 1 AND V_PLANJANNUS = 1 THEN
      IF T_PLANJANNUS != T_PLANBSCS THEN
        T_VALIDA := 0; -- Desalineado
      ELSE
        T_VALIDA := 1; -- Alineado
      END IF;
    ELSIF V_PLANBSCS = -1 OR V_PLANJANNUS = -1 THEN
      T_VALIDA := -1;
    ELSIF V_PLANBSCS = 2 AND V_PLANJANNUS = 2 THEN
      T_VALIDA := 2;
    ELSE
      T_VALIDA := 0;
    END IF;
      V_DETAIL      := T_PLANBSCS || ',' || T_PLANJANNUS;
      T_TOTAL_RULER := REPLACE(REPLACE(REPLACE(T_VAL_RULER, '@RULER', T_RULER), '@RESULT', T_VALIDA),
                               '@DETAIL',
                               V_DETAIL) || '/';
    END IF;
    --VALIDA REGLA 2 - VALIDA EL SERVICIO DE TV/INTERNET DE SGA VS INCOGNITO
    T_RULER := 2;
    V_DETAIL := '';
      SELECT COUNT(1)
        INTO V_RULER
        FROM TABLE(USRSICES.PKG_SICES_FAILURE.SICEFUN_SPLIT(TRIM(PI_RULERS), V_DELIMITER))
       WHERE COLUMN_VALUE = T_RULER;
      IF E_INT = 1 AND V_RULER > 0 THEN
    BEGIN
      INTRAWAY.PKG_SICES_FAILURE.SICESS_EQUIPMENTINC(PI_CUSTOMERID     => PI_CUSTOMERID,
                                                     PI_INTERFASE      => V_INT,
                                                     PO_CANTIDAD       => V_CANTINC,
                                                     PO_CODIGO_SALIDA  => V_CODE_INC,
                                                     PO_MENSAJE_SALIDA => V_MESSAGE_INC,
                                                     PO_CURSOR_EQUIPO  => V_CURSOR_INC);
      OPERACION.PKG_SICES_FAILURE.SICESS_SERVICIOSGA(PI_CODSOLOT       => PI_CODSOLOT,
                                                     PI_INTERFASE      => V_INT,
                                                     PO_CANTIDAD       => V_CANTSGA,
                                                     PO_CODE_RESULT    => V_CODE_SGA,
                                                     PO_MESSAGE_RESULT => V_MESSAGE_SGA,
                                                     PO_CURSORSGA      => V_CURSOR_SGA);
    EXCEPTION
      WHEN OTHERS THEN
        T_VALIDA := -1;
    END;
    IF V_CODE_INC = -1 OR V_CODE_SGA = -1 THEN
      T_VALIDA := -1;
    ELSIF V_CANTSGA = 0 AND V_CANTINC = 0 THEN
      T_VALIDA := 2;
      ELSE
      T_VALIDA := 1;
      LOOP
        FETCH V_CURSOR_INC
          INTO I_REC;
        EXIT WHEN V_CURSOR_INC%NOTFOUND;
        T_INT := TRIM(I_REC.SERVICENAME);
        IF T_VALIDA = 1 THEN
          LOOP
            FETCH V_CURSOR_SGA
              INTO S_REC;
            EXIT WHEN V_CURSOR_SGA%NOTFOUND;
              V_DETAIL := V_DETAIL || T_INT || ',' || TRIM(S_REC.CODIGO_EXTERNO) || '|';
            IF T_INT = TRIM(S_REC.CODIGO_EXTERNO) THEN
              T_VALIDA := 1;
            ELSE
              T_VALIDA := 0;
            END IF;
            EXIT WHEN T_VALIDA = 1;
          END LOOP;
        END IF;
      END LOOP;
    END IF;
    END IF;
      IF E_CTV = 1 AND V_RULER > 0 THEN
    BEGIN
      INTRAWAY.PKG_SICES_FAILURE.SICESS_EQUIPMENTINC(PI_CUSTOMERID     => PI_CUSTOMERID,
                                                     PI_INTERFASE      => V_CTV,
                                                     PO_CANTIDAD       => V_CANTINC,
                                                     PO_CODIGO_SALIDA  => V_CODE_INC,
                                                     PO_MENSAJE_SALIDA => V_MESSAGE_INC,
                                                     PO_CURSOR_EQUIPO  => V_CURSOR_INC);
      OPERACION.PKG_SICES_FAILURE.SICESS_SERVICIOSGA(PI_CODSOLOT       => PI_CODSOLOT,
                                                     PI_INTERFASE      => V_CTV,
                                                     PO_CANTIDAD       => V_CANTSGA,
                                                     PO_CODE_RESULT    => V_CODE_SGA,
                                                     PO_MESSAGE_RESULT => V_MESSAGE_SGA,
                                                     PO_CURSORSGA      => V_CURSOR_SGA);
    EXCEPTION
      WHEN OTHERS THEN
        T_VALIDA := -1;
    END;
    IF V_CODE_INC = -1 OR V_CODE_SGA = -1 THEN
      T_VALIDA := -1;
    ELSIF V_CANTSGA = 0 AND V_CANTINC = 0 THEN
      T_VALIDA := 2;
      ELSE
      T_VALIDA := 1;
      LOOP
        FETCH V_CURSOR_INC
          INTO I_REC;
        EXIT WHEN V_CURSOR_INC%NOTFOUND;
        T_CTV := TRIM(I_REC.SERVICENAME);
        IF T_VALIDA = 1 THEN
          LOOP
            FETCH V_CURSOR_SGA
              INTO S_REC;
            EXIT WHEN V_CURSOR_SGA%NOTFOUND;
              V_DETAIL := V_DETAIL || T_CTV || ',' || TRIM(S_REC.CODIGO_EXTERNO) || '|';
            IF T_CTV = TRIM(S_REC.CODIGO_EXTERNO) THEN
              T_VALIDA := 1;
            ELSE
              T_VALIDA := 0;
            END IF;
            EXIT WHEN T_VALIDA = 1;
          END LOOP;
        END IF;
      END LOOP;
    END IF;
    END IF;
      IF (E_INT = 1 AND V_RULER > 0) OR (E_CTV = 1 AND V_RULER > 0) THEN
      T_VAL_RULER   := 'SELECT @RULER AS RULER, @RESULT AS RESULT, ''@DETAIL'' AS DETAIL FROM DUAL';
      T_TOTAL_RULER := T_TOTAL_RULER ||
                       REPLACE(REPLACE(REPLACE(T_VAL_RULER, '@RULER', T_RULER), '@RESULT', T_VALIDA),
                               '@DETAIL',
                               RTRIM(V_DETAIL, '|')) || '/';
    END IF;
      --VALIDA REGLA 3 - VALIDA CICLO DE FACTURACIoN BSCS VS OAC
    T_RULER := 3;
      SELECT COUNT(1)
        INTO V_RULER
        FROM TABLE(USRSICES.PKG_SICES_FAILURE.SICEFUN_SPLIT(TRIM(PI_RULERS), V_DELIMITER))
       WHERE COLUMN_VALUE = T_RULER;
      IF V_RULER > 0 THEN
    BEGIN
      SELECT CU.BILLCYCLE
        INTO T_CICLOBSCS
        FROM CUSTOMER_ALL@DBL_BSCS_BF CU, CONTRACT_ALL@DBL_BSCS_BF CO
       WHERE CU.CUSTOMER_ID = CO.CUSTOMER_ID
         AND CO_ID = PI_COID;
      V_CICLOBSCS := 1;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        V_CICLOBSCS := 2;
      WHEN OTHERS THEN
        V_CICLOBSCS := -1;
    END;
    IF V_CICLOBSCS = 1 AND PI_CICLOOAC IS NOT NULL THEN
      IF T_CICLOBSCS = PI_CICLOOAC THEN
        T_VALIDA := 1;
      ELSE
        T_VALIDA := 0;
      END IF;
    ELSIF V_CICLOBSCS = 2 AND PI_CICLOOAC IS NULL THEN
      T_VALIDA := 2;
    ELSIF V_CICLOBSCS = -1 THEN
      T_VALIDA := -1;
    ELSE
      T_VALIDA := 0;
    END IF;
    V_DETAIL      := T_CICLOBSCS || ',' || PI_CICLOOAC;
    T_VAL_RULER   := 'SELECT @RULER AS RULER, @RESULT AS RESULT, ''@DETAIL'' AS DETAIL FROM DUAL';
    T_TOTAL_RULER := T_TOTAL_RULER ||
                     REPLACE(REPLACE(REPLACE(T_VAL_RULER, '@RULER', T_RULER), '@RESULT', T_VALIDA),
                             '@DETAIL',
                                 V_DETAIL) || '/';
      END IF;
      IF T_TOTAL_RULER IS NULL THEN
        T_TOTAL_RULER := 'SELECT '''' AS IDRULER, '''' AS RESULT, '''' AS DETAIL FROM DUAL WHERE ROWNUM < 1';
      END IF;
      T_TOTAL_RULER := REPLACE(RTRIM(T_TOTAL_RULER, '/'), '/', T_UNION) || T_ORDERBY;
    OPEN PO_CURSOR_RULERS FOR T_TOTAL_RULER;
    PO_CODE_RESULT    := 0;
    PO_MESSAGE_RESULT := 'OK';
    ELSE
      RAISE WE_EXCEPTION;
    END IF;
  EXCEPTION
    WHEN WE_EXCEPTION THEN
      PO_CODE_RESULT    := -1;
      PO_MESSAGE_RESULT := 'ERROR: PARAMETRO PI_RULERS VACIO: ' || SUBSTR(SQLERRM, 1, 200);
      OPEN PO_CURSOR_RULERS FOR
        SELECT '' AS IDRULER, '' AS RESULT, '' AS DETAIL FROM DUAL WHERE ROWNUM < 1;
    WHEN OTHERS THEN
      PO_CODE_RESULT    := -1;
      PO_MESSAGE_RESULT := 'ERROR EN OPERACION.SICESS_VALIDATESERVICE: ' || SUBSTR(SQLERRM, 1, 200);
      OPEN PO_CURSOR_RULERS FOR
        SELECT '' AS IDRULER, '' AS RESULT, '' AS DETAIL FROM DUAL WHERE ROWNUM < 1;
  END SICESS_VALIDATESERVICE;

  /****************************************************************
  '* Nombre SP           :  SICESS_SERVICIOSGA
  '* Proposito           :  EL SIGUIENTE SP CONSULTA EL SERVICIO DE UN CLIENTE EN SGA
  '* Inputs              :  PI_CODSOLOT - Codigo de la orden de trabajo
                            PI_INTERFASE - Interfaz del equipo (INT, TLF, CTV)
  '* Output              :  PO_CANTIDAD - Cantidad de servicios
                            PO_CODIGO_SALIDA - Codigo para validar el resultado de salida
                            PO_MENSAJE_SALIDA - Mensaje correspondiente al codigo de salida
                            PO_CURSOR_EQUIPO - Contiene el resultado de la consulta
  '* Creado por          :  Hitss
  '* Fec Creacion        :  30/01/2019
  '* Fec Actualizacion   :  30/01/2019
  '****************************************************************/
  PROCEDURE SICESS_SERVICIOSGA(PI_CODSOLOT       IN OPERACION.SOLOT.CODSOLOT%TYPE,
                               PI_INTERFASE      IN VARCHAR2,
                               PO_CANTIDAD       OUT INTEGER,
                               PO_CODE_RESULT    OUT INTEGER,
                               PO_MESSAGE_RESULT OUT VARCHAR2,
                               PO_CURSORSGA      OUT SYS_REFCURSOR) IS
    WE_EXCEPTION EXCEPTION;
  BEGIN
    SELECT COUNT(1)
      INTO PO_CANTIDAD
      FROM (SELECT DISTINCT DECODE(B.TIPSRV, '0006', 'INT', '0004', 'TLF', '0062', 'CTV') AS TIP_INTERFASE,
                            OPERACION.PQ_IW_SGA_BSCS.F_GET_NCOS(A.CODSOLOT, P.CODSRV, 3) AS CODIGO_EXTERNO,
                            SER.DSCSRV,
                            (SER.BANWID / 1024) AS ANCHO_BANDA_INTERNET
              FROM OPERACION.SOLOTPTO A, OPERACION.INSSRV B, OPERACION.INSPRD P, SALES.TYSTABSRV SER
             WHERE A.CODINSSRV = B.CODINSSRV
               AND B.CODINSSRV = P.CODINSSRV
               AND P.CODSRV = SER.CODSRV
               AND A.CODSOLOT = PI_CODSOLOT
               AND A.PID = P.PID
               AND P.FLGPRINC = 1) X
     WHERE (NVL(PI_INTERFASE, NULL) IS NULL OR X.TIP_INTERFASE = PI_INTERFASE);
    IF PO_CANTIDAD > 0 THEN
      OPEN PO_CURSORSGA FOR
        SELECT *
          FROM (SELECT DISTINCT DECODE(B.TIPSRV, '0006', 'INT', '0004', 'TLF', '0062', 'CTV') AS TIP_INTERFASE,
                                OPERACION.PQ_IW_SGA_BSCS.F_GET_NCOS(A.CODSOLOT, P.CODSRV, 3) AS CODIGO_EXTERNO,
                                SER.DSCSRV,
                                (SER.BANWID / 1024) AS ANCHO_BANDA_INTERNET
                  FROM OPERACION.SOLOTPTO A, OPERACION.INSSRV B, OPERACION.INSPRD P, SALES.TYSTABSRV SER
                 WHERE A.CODINSSRV = B.CODINSSRV
                   AND B.CODINSSRV = P.CODINSSRV
                   AND P.CODSRV = SER.CODSRV
                   AND A.CODSOLOT = PI_CODSOLOT
                   AND A.PID = P.PID
                   AND P.FLGPRINC = 1) X
         WHERE (NVL(PI_INTERFASE, NULL) IS NULL OR X.TIP_INTERFASE = PI_INTERFASE);
      PO_CODE_RESULT  := 0;
      PO_MESSAGE_RESULT := 'OK';
    ELSE
      RAISE WE_EXCEPTION;
    END IF;
  EXCEPTION
    WHEN WE_EXCEPTION THEN
      PO_CODE_RESULT  := 2;
      PO_MESSAGE_RESULT := 'NO SE ENCONTRO EL SERVICIO' || ' : ' || SUBSTR(SQLERRM, 1, 200);
      OPEN PO_CURSORSGA FOR
        SELECT '' TIP_INTERFASE, '' CODIGO_EXTERNO, '' DSCSRV, '' ANCHO_BANDA_INTERNET
          FROM DUAL
         WHERE ROWNUM < 1;
    WHEN OTHERS THEN
      PO_CODE_RESULT    := -1;
      PO_MESSAGE_RESULT := 'ERROR EN USRSICES.SICESS_SERVICIOSGA: ' || SUBSTR(SQLERRM, 1, 200);
      OPEN PO_CURSORSGA FOR
        SELECT '' TIP_INTERFASE, '' CODIGO_EXTERNO, '' DSCSRV, '' ANCHO_BANDA_INTERNET
          FROM DUAL
         WHERE ROWNUM < 1;
  END SICESS_SERVICIOSGA;

  /* *************************************************************
  Nombre SP         : SICESS_SUBSIDIARYIFI
  Proposito         : Obtener la direccion de un servicio IFI
  Input             : PI_CUSTOMER_ID - Indica el codigo de cliente
  Output            : PO_CODIGO_SALIDA - Codigo para validar el resultado de salida
                      PO_MENSAJE_SALIDA - Mensaje correspondiente al codigo de salida
                      PO_CURSOR - Contiene el resultado de la consulta
  Creado por        : Hitss
  Fec Creacion      : 08-03-2019
  Fec Actualizacion : 08-03-2019
  ************************************************************* */
  PROCEDURE SICESS_SUBSIDIARYIFI(PI_CUSTOMER_ID    IN VARCHAR2,
                                 PO_CODIGO_SALIDA  OUT INTEGER,
                                 PO_MENSAJE_SALIDA OUT VARCHAR2,
                                 PO_CURSOR         OUT SYS_REFCURSOR) IS
  BEGIN
    OPEN PO_CURSOR FOR
      SELECT X.COD_DEPARTAMENTO,
             X.COD_PROVINCIA,
             X.COD_DISTRITO,
             TRIM(X.TIPVIA) AS TIPVIA,
             TRIM(X.NOMVIA) AS NOMVIA,
             ROUND((SELECT X.NUMVIA FROM DUAL WHERE REGEXP_LIKE(X.NUMVIA, '^[[:digit:]]+$')) / 100) AS NUMCUADRA,
             (SELECT X.NUMVIA FROM DUAL WHERE REGEXP_LIKE(X.NUMVIA, '^[[:digit:]]+$')) AS NUMVIA,
             TRIM(X.NOMURB) AS NOMURB,
             TRIM(X.MANZANA) AS MANZANA,
             TRIM(X.LOTE) AS LOTE
        FROM (SELECT SUBSTR(U.UBIGEO, 1, 2) AS COD_DEPARTAMENTO,
                     SUBSTR(U.UBIGEO, 1, 4) AS COD_PROVINCIA,
                     U.UBIGEO AS COD_DISTRITO,
                     SUBSTR(C.CCADDR1, 1, INSTR(C.CCADDR1, ' ') - 1) AS TIPVIA,
                     SUBSTR(C.CCADDR1,
                            INSTR(C.CCADDR1, ' ') + 1,
                            INSTR(C.CCADDR1, ' ', -1) - INSTR(C.CCADDR1, ' ') - 1) AS NOMVIA,
                     SUBSTR(C.CCADDR1, (INSTR(C.CCADDR1, ' ', -1) - LENGTH(C.CCADDR1))) AS NUMVIA,
                     CASE
                       WHEN INSTR(C.CCADDR2, 'URB') > 0 THEN
                        (SUBSTR(C.CCADDR2, INSTR(C.CCADDR2, ' ') + 1))
                       ELSE
                        ''
                     END NOMURB,
                     CASE
                       WHEN INSTR(C.CCADDR1, 'MZ') > 0 THEN
                        SUBSTR(C.CCADDR1, INSTR(C.CCADDR1, 'MZ') + 3, 2)
                       ELSE
                        ''
                     END MANZANA,
                     CASE
                       WHEN INSTR(C.CCADDR1, 'LT') > 0 THEN
                        SUBSTR(C.CCADDR1, INSTR(C.CCADDR1, 'LT') + 3, 2)
                       ELSE
                        ''
                     END LOTE
                FROM SYSADM.CCONTACT_ALL@DBL_BSCS_BF C, MARKETING.VTATABDST U
               WHERE TRIM(U.NOMDEPA) = C.CCCITY
                 AND TRIM(U.NOMPROV) = C.CCLINE4
                 AND TRIM(U.NOMDST) = C.CCADDR3
                 AND C.CUSTOMER_ID = PI_CUSTOMER_ID
                 AND C.CCBILL = 'X') X;
    PO_CODIGO_SALIDA  := 0;
    PO_MENSAJE_SALIDA := 'OK';
  EXCEPTION
    WHEN OTHERS THEN
      PO_CODIGO_SALIDA  := -1;
      PO_MENSAJE_SALIDA := 'ERROR EN SICESS_SUBSIDIARYIFI: ' || TO_CHAR(SQLCODE) || ' ' || SQLERRM;
      OPEN PO_CURSOR FOR
        SELECT '' COD_DEPARTAMENTO,
               '' COD_PROVINCIA,
               '' COD_DISTRITO,
               '' TIPVIA,
               '' NOMVIA,
               '' NUMCUADRA,
               '' NUMVIA,
               '' NOMURB,
               '' MANZANA,
               '' LOTE
          FROM DUAL
         WHERE ROWNUM < 1;
  END SICESS_SUBSIDIARYIFI;

  /****************************************************************
  '* Nombre SP           :  SICESS_ACTIVARBOUQUET
  '* Proposito           :  EL SIGUIENTE SP REALIZA LA ACTIVACION DE BOUQUETS PARA UNA TARJETA
  '* Inputs              :  PI_CODSOLOT - Codigo de la orden de trabajo
                            PI_NUMSERIE_TARJETA - Numero de serie de la tarjeta del deco
  '* Output              :  PO_BOUQUET - Bouquets activados
                            PO_RESPUESTA - Respuesta de salida
                            PO_MENSAJE - Mensaje de salida
  '* Creado por          :  Hitss
  '* Fec Creacion        :  08/07/2019
  '* Fec Actualizacion   :  23/08/2019
  '****************************************************************/
  PROCEDURE SICESS_ACTIVARBOUQUET(PI_CODSOLOT         IN OPERACION.SOLOT.CODSOLOT%TYPE,
                                  PI_NUMSERIE_TARJETA IN OPERACION.SOLOTPTOEQU.NUMSERIE%TYPE,
                                  PO_BOUQUET          OUT OPERACION.SGAT_TRXCONTEGO.TRXV_BOUQUET%TYPE,
                                  PO_RESPUESTA        OUT VARCHAR2,
                                  PO_MENSAJE          OUT VARCHAR2) IS
    V_CONTEGO  OPERACION.SGAT_TRXCONTEGO%ROWTYPE;
    V_COD_ID   OPERACION.SOLOT.COD_ID%TYPE;
    V_BOUQUET  OPERACION.SGAT_TRXCONTEGO.TRXV_BOUQUET%TYPE;
    V_NUMSERIE OPERACION.SOLOTPTOEQU.NUMSERIE%TYPE;
    WE_ERROR EXCEPTION;
  BEGIN
    BEGIN
      SELECT S.COD_ID INTO V_COD_ID FROM OPERACION.SOLOT S WHERE S.CODSOLOT = PI_CODSOLOT;
    EXCEPTION
      WHEN OTHERS THEN
        PO_RESPUESTA := 'ERROR';
        PO_MENSAJE   := 'ERROR: NO SE ENCUENTRA LA ORDEN DE TRABAJO (SOT)';
        RAISE WE_ERROR;
    END;
    IF V_COD_ID IS NULL THEN
      V_COD_ID := OPERACION.PKG_CAMBIO_CICLO_FACT.F_OTIENE_COD_ID(PI_CODSOLOT);
      IF V_COD_ID IS NULL THEN
        PO_RESPUESTA := 'ERROR';
        PO_MENSAJE   := 'ERROR: NO SE ENCUENTRA EL CONTRATO PARA OBTENER LOS BOUQUETS';
        RAISE WE_ERROR;
      END IF;
    END IF;
    BEGIN
      SELECT DISTINCT NUMSERIE
        INTO V_NUMSERIE
        FROM OPERACION.SOLOTPTOEQU
       WHERE CODSOLOT = PI_CODSOLOT
         AND NUMSERIE = PI_NUMSERIE_TARJETA
         AND TIPEQU IN (SELECT A.CODIGON TIPEQUOPE
                          FROM OPERACION.OPEDD A, OPERACION.TIPOPEDD B
                         WHERE A.TIPOPEDD = B.TIPOPEDD
                           AND B.ABREV = 'TIPEQU_DTH_CONAX'
                           AND CODIGOC = '1');
    EXCEPTION
      WHEN OTHERS THEN
        PO_RESPUESTA := 'ERROR';
        PO_MENSAJE   := 'ERROR: SOLO SE SOPORTA TIPO DE TARJETA: SMART CARD CONAX';
        RAISE WE_ERROR;
    END;
    V_BOUQUET := OPERACION.PQ_DECO_ADICIONAL_LTE.SGAFUN_OBT_BOUQUET_ACT(V_COD_ID);
    IF V_BOUQUET IS NULL THEN
      PO_RESPUESTA := 'ERROR';
      PO_MENSAJE   := 'ERROR: NO SE ENCUENTRA LOS BOUQUETS PARA REALIZAR LA ACTIVACION';
      RAISE WE_ERROR;
    END IF;
    V_CONTEGO.TRXN_CODSOLOT      := PI_CODSOLOT;
    V_CONTEGO.TRXN_ACTION_ID     := OPERACION.PKG_CONTEGO.SGAFUN_PARAM_CONTEGO('CONF_CONTEGO_ACT',
                                                                               'CONF_ACT',
                                                                               'ALTA-CONTEGO',
                                                                               'N');
    V_CONTEGO.TRXV_SERIE_TARJETA := V_NUMSERIE;
    V_CONTEGO.TRXV_BOUQUET       := V_BOUQUET;
    V_CONTEGO.TRXN_PRIORIDAD     := OPERACION.PKG_CONTEGO.SGAFUN_PARAM_CONTEGO('CONF_CONTEGO_ACT',
                                                                               'CONF_ACT',
                                                                               'ALTA-CONTEGO',
                                                                               'AU');
    OPERACION.PKG_CONTEGO.SGASI_REGCONTEGO(V_CONTEGO, PO_RESPUESTA);
    IF PO_RESPUESTA = 'ERROR' THEN
      PO_MENSAJE := 'ERROR: AL GRABAR LA TRANSACCION DE ACTIVACION EN LA TABLA OPERACION.SGAT_TRXCONTEGO.';
      RAISE WE_ERROR;
    ELSE
      PO_RESPUESTA := 'OK';
      PO_MENSAJE   := 'PROCESO TERMINADO SATISFACTORIAMENTE';
      PO_BOUQUET := V_BOUQUET;
      COMMIT;
    END IF;
  EXCEPTION
    WHEN WE_ERROR THEN
      OPERACION.PKG_CONTEGO.SGASP_LOGERR('SICESS_ACTIVARBOUQUET', '', PI_CODSOLOT, PO_RESPUESTA, PO_MENSAJE);
      ROLLBACK;
    WHEN OTHERS THEN
      PO_RESPUESTA := 'ERROR';
      PO_MENSAJE   := 'ERROR: AL GRABAR LAS TRANSACIONES DE ACTIVACION' || SQLCODE || ' ' || SQLERRM || ' ' ||
                      DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      OPERACION.PKG_CONTEGO.SGASP_LOGERR('SICESS_ACTIVARBOUQUET', '', PI_CODSOLOT, PO_RESPUESTA, PO_MENSAJE);
      ROLLBACK;
  END SICESS_ACTIVARBOUQUET;

  /****************************************************************
  '* Nombre SP           :  SICESS_PAREODECO
  '* Proposito           :  EL SIGUIENTE SP GENERA INFORMACION PARA EL PROCESO DEL PAREO
  '* Inputs              :  PI_CODSOLOT - Numero de orden de trabajo
                            PI_NRO_UA_DECO - Numero UA del decodificador
                            PI_NRO_SERIE_TARJETA - Numero de serie de la tarjeta del deco
  '* Output              :  PO_RESPUESTA - Respuesta de salida
                            PO_MENSAJE - Mensaje de salida
  '* Creado por          :  Hitss
  '* Fec Creacion        :  25/10/2019
  '* Fec Actualizacion   :  25/10/2019
  ****************************************************************/
  PROCEDURE SICESS_PAREODECO(PI_CODSOLOT          OPERACION.SOLOT.CODSOLOT%TYPE,
                             PI_NRO_UA_DECO       OPERACION.TABEQUIPO_MATERIAL.IMEI_ESN_UA%TYPE,
                             PI_NRO_SERIE_TARJETA OPERACION.TARJETA_DECO_ASOC.NRO_SERIE_TARJETA%TYPE,
                             PO_RESPUESTA         IN OUT VARCHAR2,
                             PO_MENSAJE           IN OUT VARCHAR2) IS
    V_CONTEGO     OPERACION.SGAT_TRXCONTEGO%ROWTYPE;
    V_COD_ID      OPERACION.SOLOT.COD_ID%TYPE;
    V_BOUQUET     OPERACION.SGAT_TRXCONTEGO.TRXV_BOUQUET%TYPE;
    V_NRO_UA_DECO OPERACION.TABEQUIPO_MATERIAL.IMEI_ESN_UA%TYPE;
    WE_ERROR EXCEPTION;
  BEGIN
    BEGIN
      SELECT S.COD_ID INTO V_COD_ID FROM OPERACION.SOLOT S WHERE S.CODSOLOT = PI_CODSOLOT;
    EXCEPTION
      WHEN OTHERS THEN
        PO_RESPUESTA := 'ERROR';
        PO_MENSAJE   := 'ERROR: NO SE ENCUENTRA LA ORDEN DE TRABAJO (SOT)';
        RAISE WE_ERROR;
    END;
    IF V_COD_ID IS NULL THEN
      V_COD_ID := OPERACION.PKG_CAMBIO_CICLO_FACT.F_OTIENE_COD_ID(PI_CODSOLOT);
      IF V_COD_ID IS NULL THEN
        PO_RESPUESTA := 'ERROR';
        PO_MENSAJE   := 'ERROR: NO SE ENCUENTRA EL CONTRATO PARA OBTENER LOS BOUQUETS';
        RAISE WE_ERROR;
      END IF;
    END IF;
    BEGIN
      SELECT M.IMEI_ESN_UA
        INTO V_NRO_UA_DECO
        FROM OPERACION.TABEQUIPO_MATERIAL M
       WHERE M.IMEI_ESN_UA = PI_NRO_UA_DECO
         AND (SELECT COUNT(1)
                FROM OPERACION.OPEDD A, OPERACION.TIPOPEDD B
               WHERE A.TIPOPEDD = B.TIPOPEDD
                 AND B.ABREV = 'PREFIJO_DECO'
                 AND INSTR(UPPER(M.NUMERO_SERIE), UPPER(TRIM(A.CODIGOC))) = 1) > 0;
    EXCEPTION
      WHEN OTHERS THEN
        PO_RESPUESTA := 'ERROR';
        PO_MENSAJE   := 'ERROR: PREFIJO DEL NUMERO DE SERIE DEL DECODIFICADOR NO ES SOPORTADO';
        RAISE WE_ERROR;
    END;
    V_BOUQUET := OPERACION.PQ_DECO_ADICIONAL_LTE.SGAFUN_OBT_BOUQUET_ACT(V_COD_ID);
    IF V_BOUQUET IS NULL THEN
      PO_RESPUESTA := 'ERROR';
      PO_MENSAJE   := 'ERROR: NO SE ENCUENTRA LOS BOUQUETS PARA REALIZAR LA ACTIVACION';
      RAISE WE_ERROR;
    END IF;
    V_CONTEGO.TRXN_CODSOLOT      := PI_CODSOLOT;
    V_CONTEGO.TRXN_ACTION_ID     := OPERACION.PKG_CONTEGO.SGAFUN_PARAM_CONTEGO('CONF_CONTEGO_ACT',
                                                                               'CONF_ACT',
                                                                               'PAREO-CONTEGO',
                                                                               'N');
    V_CONTEGO.TRXV_TIPO          := 'PAREO';
    V_CONTEGO.TRXV_BOUQUET       := V_BOUQUET;
    V_CONTEGO.TRXV_SERIE_TARJETA := PI_NRO_SERIE_TARJETA;
    V_CONTEGO.TRXV_SERIE_DECO    := V_NRO_UA_DECO;
    V_CONTEGO.TRXN_PRIORIDAD     := OPERACION.PKG_CONTEGO.SGAFUN_PARAM_CONTEGO('CONF_CONTEGO_ACT',
                                                                               'CONF_ACT',
                                                                               'PAREO-CONTEGO',
                                                                               'AU');
    OPERACION.PKG_CONTEGO.SGASI_REGCONTEGO(V_CONTEGO, PO_RESPUESTA);
    IF PO_RESPUESTA = 'ERROR' THEN
      PO_MENSAJE := 'ERROR: AL GRABAR LAS TRANSACCIONES DE PAREO EN LA TABLA OPERACION.SGAT_TRXCONTEGO.';
      RAISE WE_ERROR;
    ELSE
      PO_RESPUESTA := 'OK';
      PO_MENSAJE   := 'PROCESO TERMINADO SATISFACTORIAMENTE';
      COMMIT;
    END IF;
  EXCEPTION
    WHEN WE_ERROR THEN
      OPERACION.PKG_CONTEGO.SGASP_LOGERR('SICESS_PAREODECO', '', PI_CODSOLOT, PO_RESPUESTA, PO_MENSAJE);
      ROLLBACK;
    WHEN OTHERS THEN
      PO_RESPUESTA := 'ERROR';
      PO_MENSAJE   := 'ERROR: AL GRABAR LAS TRANSACIONES DE PAREO ' || SQLCODE || ' ' || SQLERRM || ' ' ||
                      DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      OPERACION.PKG_CONTEGO.SGASP_LOGERR('SICESS_PAREODECO', '', PI_CODSOLOT, PO_RESPUESTA, PO_MENSAJE);
      ROLLBACK;
  END;

  /****************************************************************
  '* Nombre SP           :  SICESS_SERVICESGA
  '* Proposito           :  EL SIGUIENTE SP CONSULTA EL SERVICIO DE UN CLIENTE EN SGA
  '* Inputs              :  PI_NUMSLC - Código de proyecto
                            PI_CODCLI - Codigo de cliente
  '* Output              :  PO_CODIGO_SALIDA - Codigo para validar el resultado de salida
                            PO_MENSAJE_SALIDA - Mensaje correspondiente al codigo de salida
                            PO_CURSOR - Contiene el resultado de la consulta
  '* Creado por          :  Hitss
  '* Fec Creacion        :  25/02/2020
  '* Fec Actualizacion   :  25/02/2020
  '****************************************************************/
  PROCEDURE SICESS_SERVICESGA(PI_NUMSLC         IN SALES.VTATABSLCFAC.NUMSLC%TYPE,
                              PI_CODCLI         IN MARKETING.VTATABCLI.CODCLI%TYPE,
                              PO_CODE_RESULT    OUT INTEGER,
                              PO_MESSAGE_RESULT OUT VARCHAR2,
                              PO_CURSOR         OUT SYS_REFCURSOR) IS
  BEGIN
    OPEN PO_CURSOR FOR
      SELECT T.DSCSRV AS SERVICIO,
             (SELECT DESCRIPCION FROM OPERACION.ESTINSPRD WHERE ESTINSPRD = P.ESTINSPRD) AS ESTADO,
             CASE
               WHEN I.TIPSRV = '0004' THEN
                'TLF'
               WHEN I.TIPSRV = '0062' THEN
                'CTV'
               WHEN I.TIPSRV = '0006' THEN
                'INT'
               ELSE
                'OTROS'
             END TIPO_SERVICIO,
             (SELECT MAX(FECTRS)
                FROM OPERACION.TRSSOLOT
               WHERE CODINSSRV = I.CODINSSRV
                 AND ESTTRS = 2) AS VALIDO_DESDE,
             CASE
               WHEN V.MONTOCR IS NOT NULL AND V.MONTOCNR IS NOT NULL THEN
                ROUND(V.MONTOCR + V.MONTOCNR, 2)
               WHEN V.MONTOCR IS NULL AND V.MONTOCNR IS NULL THEN
                0
               ELSE
                ROUND(NVL(V.MONTOCR, V.MONTOCNR), 2)
             END CARGO_FIJO
        FROM OPERACION.INSSRV I
       INNER JOIN OPERACION.INSPRD P
          ON P.CODINSSRV = I.CODINSSRV
       INNER JOIN SALES.TYSTABSRV T
          ON P.CODSRV = T.CODSRV
        LEFT JOIN BILLCOLPER.INSTXPRODUCTO V
          ON (P.PID = V.PID AND T.IDPRODUCTO = V.IDPRODUCTO AND P.ESTINSPRD IN (1, 2))
       WHERE I.NUMSLC = PI_NUMSLC
         AND I.CODCLI = PI_CODCLI
         AND NOT EXISTS (SELECT 1
                FROM BILLCOLPER.CNR
               WHERE CODCLI = I.CODCLI
                 AND IDINSTPROD = V.IDINSTPROD)
       ORDER BY 1 ASC;
    PO_CODE_RESULT    := 0;
    PO_MESSAGE_RESULT := 'OK';
  EXCEPTION
    WHEN OTHERS THEN
      PO_CODE_RESULT    := -1;
      PO_MESSAGE_RESULT := 'ERROR EN USRSICES.SICESS_SERVICESGA: ' || SUBSTR(SQLERRM, 1, 200);
      OPEN PO_CURSOR FOR
        SELECT '' SERVICIO, '' ESTADO, '' TIPO_SERVICIO, '' VALIDO_DESDE, '' CARGO_FIJO
          FROM DUAL
         WHERE ROWNUM < 1;
  END SICESS_SERVICESGA;

  /* *************************************************************
  Nombre SP         : SICESS_ACCOUNT_SGA
  Proposito         : Obtener el estado de cuenta de un cliente/sucursal en SGA
  Input             : PI_CODCLI - Codigo de cliente
                      PI_NUMSLC - Codigo de proyecto
  Output            : PO_CODIGO_SALIDA - Codigo para validar el resultado de salida
                      PO_MENSAJE_SALIDA - Mensaje correspondiente al codigo de salida
                      PO_CURSOR_CUENTA - Contiene el resultado de la consulta
  Creado por        : Hitss
  Fec Creacion      : 02-03-2020
  Fec Actualizacion : 02-03-2020
  ************************************************************* */
  PROCEDURE SICESS_ACCOUNT_SGA(PI_CODCLI         IN MARKETING.VTATABCLI.CODCLI%TYPE,
                               PI_NUMSLC         IN OPERACION.INSSRV.NUMSLC%TYPE,
                               PO_CODIGO_SALIDA  OUT INTEGER,
                               PO_MENSAJE_SALIDA OUT VARCHAR2,
                               PO_CURSOR_CUENTA  OUT SYS_REFCURSOR) IS
  BEGIN
    OPEN PO_CURSOR_CUENTA FOR
      SELECT DISTINCT C.TIPDOC AS TIPO_DOCUMENTO, C.IDFAC, C.SERSUT || C.NUMSUT AS NRODOCUMENTO, C.IDCON
        FROM COLLECTIONS.CXCTABFAC    C,
             BILLCOLPER.BILFAC        B,
             BILLCOLPER.CR            F,
             BILLCOLPER.INSTXPRODUCTO I,
             OPERACION.INSPRD         P,
             OPERACION.INSSRV         T
       WHERE B.IDFACCXC = C.IDFAC
         AND B.IDBILFAC = F.IDBILFAC
         AND F.IDINSTPROD = I.IDINSTPROD
         AND I.PID = P.PID
         AND P.CODINSSRV = T.CODINSSRV
         AND C.CODCLI = PI_CODCLI
         AND C.TIPDOC = 'REC'
         AND T.NUMSLC = PI_NUMSLC;
    PO_CODIGO_SALIDA  := 0;
    PO_MENSAJE_SALIDA := 'OK';
  EXCEPTION
    WHEN OTHERS THEN
      PO_CODIGO_SALIDA  := -1;
      PO_MENSAJE_SALIDA := 'ERROR EN SICESS_ACCOUNT_SGA: ' || TO_CHAR(SQLCODE) || ' ' || SQLERRM;
      OPEN PO_CURSOR_CUENTA FOR
        SELECT '' TIPO_DOCUMENTO, '' IDFAC, '' NRODOCUMENTO, '' IDCON FROM DUAL WHERE ROWNUM < 1;
  END SICESS_ACCOUNT_SGA;

  /* *************************************************************
  Nombre SP         : SICESS_ACCOUNT_STATUS
  Proposito         : Obtener el estado de cuenta de un cliente/sucursal en SGA
  Input             : PI_CODCLI - Codigo de cliente
                      PI_NUMSLC - Codigo de proyecto
  Output            : PO_CODIGO_SALIDA - Codigo para validar el resultado de salida
                      PO_MENSAJE_SALIDA - Mensaje correspondiente al codigo de salida
                      PO_DEUDA_VENCIDA - Monto deuda vencida
                      PO_DEUDA_NO_VENCIDA - Monto deuda no vencida
                      PO_CURSOR_CUENTA - Contiene el resultado de la consulta
  Creado por        : Hitss
  Fec Creacion      : 02-03-2020
  Fec Actualizacion : 02-03-2020
  ************************************************************* */
  PROCEDURE SICESS_ACCOUNT_STATUS(PI_CODCLI           IN MARKETING.VTATABCLI.CODCLI%TYPE,
                                  PI_NUMSLC           IN OPERACION.INSSRV.NUMSLC%TYPE,
                                  PO_CODIGO_SALIDA    OUT INTEGER,
                                  PO_MENSAJE_SALIDA   OUT VARCHAR2,
                                  PO_DEUDA_VENCIDA    OUT NUMBER,
                                  PO_DEUDA_NO_VENCIDA OUT NUMBER,
                                  PO_CURSOR_CUENTA    OUT SYS_REFCURSOR) IS
    I                  NUMBER := 0;
    V_DEUDA_VENCIDA    NUMBER := 0;
    V_DEUDA_NO_VENCIDA NUMBER := 0;
    --VARIABLES TABLA
    TYPE FACTURA_ROW IS RECORD(
      TIPO_DOCUMENTO CHAR(4),
      IDFAC          CHAR(10),
      NRODOCUMENTO   VARCHAR2(30),
      IDCON          NUMBER);
    T_TBL_FACTURA FACTURA_ROW;
    TYPE T_FACTURA IS TABLE OF FACTURA_ROW;
    TYPE PAGO_ROW IS RECORD(
      FORMA_PAGO       VARCHAR2(240),
      DES_PAGO         VARCHAR2(240),
      ID_PAGO          VARCHAR2(30),
      TIPO_MONEDA      VARCHAR2(10),
      MONTO_PAGO       NUMBER,
      MONTO_PAGO_SOLES NUMBER,
      FECHA_REGISTRO   DATE,
      FECHA_PAGO       DATE,
      TIPO_DOCUMENTO   VARCHAR2(20),
      NRO_DOCUMENTO    VARCHAR2(20),
      ID_PAGO_OAC      NUMBER(15),
      USUARIO          VARCHAR2(100));
    T_TBL_PAGO PAGO_ROW;
    TYPE DEUDA_ROW IS RECORD(
      TIPO_DOCUMENTO      VARCHAR2(20),
      SERIE_DOCUMENTO     VARCHAR2(5),
      NRO_DOCUMENTO       VARCHAR2(20),
      DESCRIP_DOCUMENTO   VARCHAR2(240),
      ESTADO_DOCUMENTO    VARCHAR2(50),
      FECHA_REGISTRO      DATE,
      FECHA_EMISION       DATE,
      FECHA_VENCIMIENTO   DATE,
      TIPO_MONEDA         VARCHAR2(5),
      MONTO_DOCUMENTO     NUMBER(18, 4),
      MONTO_FCO           NUMBER(18, 4),
      MONTO_FINAN         NUMBER(18, 4),
      SALDO_DOCUMENTO     NUMBER(18, 4),
      SALDO_FCO           NUMBER(18, 4),
      SALDO_FINAN         NUMBER(18, 4),
      MONTO_SOLES         NUMBER(18, 4),
      MONTO_DOLARES       NUMBER(18, 4),
      CARGO               NUMBER(18, 4),
      ABONO               NUMBER(18, 4),
      SALDO_CUENTA        NUMBER(18, 4),
      NRO_OPERACION_PAGO  VARCHAR2(30),
      FECHA_PAGO          DATE,
      FORMA_PAGO          VARCHAR2(15),
      ANIO_EMISION        VARCHAR2(4),
      MES_EMISION         VARCHAR2(2),
      ANIO_VENCIMIENTO    VARCHAR2(4),
      MES_VENCIMIENTO     VARCHAR2(2),
      FLAG_CARGO_CUENTA   VARCHAR2(1),
      NRO_TICKET          VARCHAR2(30),
      MONTO_RECLAMADO     NUMBER(18, 4),
      TELEFONO            VARCHAR2(30),
      USUARIO             VARCHAR2(100),
      ID_DOC_SISTEMA_ORIG VARCHAR2(150),
      DESCRIP_EXTEND      VARCHAR2(150),
      ID_DOC_OAC          NUMBER,
      DEUDA_TOTAL_SOLES   NUMBER(18, 4),
      DEUDA_TOTAL_DOLARES NUMBER(18, 4),
      PLATAFORMA          VARCHAR2(20));
    T_TBL_DEUDA          DEUDA_ROW;
    LISTA_FACTURAS       T_FACTURA;
    LISTA_DETALLE_CUENTA T_FACTURA;
    LISTA_ESTADO_CUENTA  OPERACION.T_TBL_DETALLE_CUENTA := OPERACION.T_TBL_DETALLE_CUENTA();
    --VARIABLES CURSOR
    CUR_FACTURAS SYS_REFCURSOR;
    CUR_PAGOS    SYS_REFCURSOR;
    CUR_DEUDAS   SYS_REFCURSOR;
    --VARIABLES EXCEPTION
    EXCEPT_FACTURA  EXCEPTION;
    EXCEPT_PAGO     EXCEPTION;
    EXCEPT_DEUDA    EXCEPTION;
    EXCEPT_NOTFOUND EXCEPTION;
    EXCEPT_PARAM    EXCEPTION;
  BEGIN
    IF PI_CODCLI IS NULL OR PI_NUMSLC IS NULL THEN
      RAISE EXCEPT_PARAM;
    END IF;
    LISTA_FACTURAS       := T_FACTURA();
    LISTA_DETALLE_CUENTA := T_FACTURA();
    --OBTENER FACTURAS
    BEGIN
      OPERACION.PKG_SICES_FAILURE.SICESS_ACCOUNT_SGA(PI_CODCLI         => PI_CODCLI,
                                                     PI_NUMSLC         => PI_NUMSLC,
                                                     PO_CODIGO_SALIDA  => PO_CODIGO_SALIDA,
                                                     PO_MENSAJE_SALIDA => PO_MENSAJE_SALIDA,
                                                     PO_CURSOR_CUENTA  => CUR_FACTURAS);
    EXCEPTION
      WHEN OTHERS THEN
        RAISE EXCEPT_FACTURA;
    END;
    IF PO_CODIGO_SALIDA = 0 THEN
      LOOP
        FETCH CUR_FACTURAS
          INTO T_TBL_FACTURA;
        EXIT WHEN CUR_FACTURAS%NOTFOUND;
        LISTA_FACTURAS.EXTEND;
        LISTA_DETALLE_CUENTA.EXTEND;
        I := I + 1;
        LISTA_FACTURAS(I).NRODOCUMENTO := T_TBL_FACTURA.NRODOCUMENTO;
        LISTA_DETALLE_CUENTA(I).TIPO_DOCUMENTO := T_TBL_FACTURA.TIPO_DOCUMENTO;
        LISTA_DETALLE_CUENTA(I).IDFAC := T_TBL_FACTURA.IDFAC;
        LISTA_DETALLE_CUENTA(I).NRODOCUMENTO := T_TBL_FACTURA.NRODOCUMENTO;
        LISTA_DETALLE_CUENTA(I).IDCON := T_TBL_FACTURA.IDCON;
      END LOOP;
      --OBTENER PAGOS
      IF LISTA_FACTURAS.COUNT > 0 THEN
        FOR J IN LISTA_FACTURAS.FIRST .. LISTA_FACTURAS.LAST LOOP
          BEGIN
            ATCCORP.P_CONSULTA_PAGO_OAC(AS_USUARIO           => NULL,
                                        AS_COD_CUENTA        => PI_CODCLI,
                                        AS_TIPO_DOCUMENTO    => NULL,
                                        AS_NRO_DOCUMENTO     => LISTA_FACTURAS(J).NRODOCUMENTO,
                                        OV_DETALLE_DOCUMENTO => CUR_PAGOS);
          EXCEPTION
            WHEN OTHERS THEN
              RAISE EXCEPT_PAGO;
          END;
          LOOP
            FETCH CUR_PAGOS
              INTO T_TBL_PAGO;
            EXIT WHEN CUR_PAGOS%NOTFOUND;
            LISTA_DETALLE_CUENTA.EXTEND;
            I := I + 1;
            LISTA_DETALLE_CUENTA(I).TIPO_DOCUMENTO := 'PAGO';
            LISTA_DETALLE_CUENTA(I).NRODOCUMENTO := T_TBL_PAGO.ID_PAGO;
          END LOOP;
        END LOOP;
        --OBTENER MONTOS DEUDA
        BEGIN
          ATCCORP.P_OBT_SALDO_CUENTA_OAC(P_CODCLI => PI_CODCLI, P_SALDO_CUENTA => CUR_DEUDAS);
        EXCEPTION
          WHEN OTHERS THEN
            RAISE EXCEPT_DEUDA;
        END;
        LOOP
          FETCH CUR_DEUDAS
            INTO T_TBL_DEUDA;
          EXIT WHEN CUR_DEUDAS%NOTFOUND;
          FOR L IN LISTA_FACTURAS.FIRST .. LISTA_FACTURAS.LAST LOOP
            IF LISTA_FACTURAS(L).NRODOCUMENTO = T_TBL_DEUDA.SERIE_DOCUMENTO || T_TBL_DEUDA.NRO_DOCUMENTO AND
                T_TBL_DEUDA.FECHA_VENCIMIENTO < TRUNC(SYSDATE) THEN
              IF T_TBL_DEUDA.TIPO_MONEDA = 'MN' THEN
                V_DEUDA_VENCIDA := V_DEUDA_VENCIDA + T_TBL_DEUDA.DEUDA_TOTAL_SOLES;
              ELSIF T_TBL_DEUDA.TIPO_MONEDA = 'US' THEN
                V_DEUDA_VENCIDA := V_DEUDA_VENCIDA + T_TBL_DEUDA.DEUDA_TOTAL_DOLARES;
              END IF;
            ELSIF LISTA_FACTURAS(L).NRODOCUMENTO = T_TBL_DEUDA.SERIE_DOCUMENTO || T_TBL_DEUDA.NRO_DOCUMENTO AND
                   T_TBL_DEUDA.FECHA_VENCIMIENTO > TRUNC(SYSDATE) THEN
              IF T_TBL_DEUDA.TIPO_MONEDA = 'MN' THEN
                V_DEUDA_NO_VENCIDA := V_DEUDA_NO_VENCIDA + T_TBL_DEUDA.DEUDA_TOTAL_SOLES;
              ELSIF T_TBL_DEUDA.TIPO_MONEDA = 'US' THEN
                V_DEUDA_NO_VENCIDA := V_DEUDA_NO_VENCIDA + T_TBL_DEUDA.DEUDA_TOTAL_DOLARES;
              END IF;
            END IF;
          END LOOP;
        END LOOP;
        --UNIR ESTADO DE CUENTA
        IF LISTA_DETALLE_CUENTA.COUNT > 0 THEN
          LISTA_ESTADO_CUENTA.EXTEND(LISTA_DETALLE_CUENTA.COUNT);
          FOR K IN LISTA_DETALLE_CUENTA.FIRST .. LISTA_DETALLE_CUENTA.LAST LOOP
            LISTA_ESTADO_CUENTA(K) := OPERACION.T_OBJ_DETALLE_CUENTA(LISTA_DETALLE_CUENTA(K).TIPO_DOCUMENTO,
                                                                     LISTA_DETALLE_CUENTA(K).IDFAC,
                                                                     LISTA_DETALLE_CUENTA(K).NRODOCUMENTO,
                                                                     LISTA_DETALLE_CUENTA(K).IDCON);
          END LOOP;
          OPEN PO_CURSOR_CUENTA FOR
            SELECT * FROM TABLE(LISTA_ESTADO_CUENTA);
          PO_DEUDA_VENCIDA    := ROUND(V_DEUDA_VENCIDA, 2);
          PO_DEUDA_NO_VENCIDA := ROUND(V_DEUDA_NO_VENCIDA, 2);
          PO_CODIGO_SALIDA    := 0;
          PO_MENSAJE_SALIDA   := 'OK';
          COMMIT;
        END IF;
      ELSE
        RAISE EXCEPT_NOTFOUND;
      END IF;
    ELSE
      RAISE EXCEPT_FACTURA;
    END IF;
  EXCEPTION
    WHEN EXCEPT_PARAM THEN
      PO_CODIGO_SALIDA  := -1;
      PO_MENSAJE_SALIDA := 'TODOS LOS PARAMETROS SON OBLIGATORIOS: ' || SQLERRM;
      OPEN PO_CURSOR_CUENTA FOR
        SELECT '' TIPO_DOCUMENTO, '' IDFAC, '' NRODOCUMENTO, '' IDCON FROM DUAL WHERE ROWNUM < 1;
    WHEN EXCEPT_NOTFOUND THEN
      PO_CODIGO_SALIDA  := -1;
      PO_MENSAJE_SALIDA := 'NO SE ENCONTRARON FACTURAS: ' || SQLERRM;
      OPEN PO_CURSOR_CUENTA FOR
        SELECT '' TIPO_DOCUMENTO, '' IDFAC, '' NRODOCUMENTO, '' IDCON FROM DUAL WHERE ROWNUM < 1;
    WHEN EXCEPT_DEUDA THEN
      PO_CODIGO_SALIDA  := -1;
      PO_MENSAJE_SALIDA := 'ERROR AL OBTENER LAS DEUDAS OAC: ' || SQLERRM;
      OPEN PO_CURSOR_CUENTA FOR
        SELECT '' TIPO_DOCUMENTO, '' IDFAC, '' NRODOCUMENTO, '' IDCON FROM DUAL WHERE ROWNUM < 1;
    WHEN EXCEPT_PAGO THEN
      PO_CODIGO_SALIDA  := -1;
      PO_MENSAJE_SALIDA := 'ERROR AL OBTENER LOS PAGOS OAC: ' || SQLERRM;
      OPEN PO_CURSOR_CUENTA FOR
        SELECT '' TIPO_DOCUMENTO, '' IDFAC, '' NRODOCUMENTO, '' IDCON FROM DUAL WHERE ROWNUM < 1;
    WHEN EXCEPT_FACTURA THEN
      PO_CODIGO_SALIDA  := -1;
      PO_MENSAJE_SALIDA := 'ERROR AL OBTENER LAS FACTURAS SGA: ' || PO_MENSAJE_SALIDA || ' | ' || SQLERRM;
      OPEN PO_CURSOR_CUENTA FOR
        SELECT '' TIPO_DOCUMENTO, '' IDFAC, '' NRODOCUMENTO, '' IDCON FROM DUAL WHERE ROWNUM < 1;
    WHEN OTHERS THEN
      PO_CODIGO_SALIDA  := -1;
      PO_MENSAJE_SALIDA := 'ERROR EN SICESS_ACCOUNT_STATUS: ' || TO_CHAR(SQLCODE) || ' ' || SQLERRM;
      OPEN PO_CURSOR_CUENTA FOR
        SELECT '' TIPO_DOCUMENTO, '' IDFAC, '' NRODOCUMENTO, '' IDCON FROM DUAL WHERE ROWNUM < 1;
  END SICESS_ACCOUNT_STATUS;
    
  /**************************************************************
  Nombre SP         : SICEFUN_GET_COIDSTATUS
  Proposito         : Obtiene el estado de un contratoi
  Input             : PI_CO_ID - Codigo de contrato
  Output            : Estado del contrato (a, s, d)
  Creado por        : HITSS
  Fec Creacion      : 28-01-2019
  Fec Actualizacion : 28-01-2019
  **************************************************************/
  FUNCTION SICEFUN_GET_COIDSTATUS(PI_CO_ID NUMBER) RETURN VARCHAR2 IS
    STATUS VARCHAR2(1);
  BEGIN
    SELECT CH_STATUS INTO STATUS FROM CURR_CO_STATUS@DBL_BSCS_BF S WHERE S.CO_ID = PI_CO_ID;
    RETURN STATUS;
  END;

END PKG_SICES_FAILURE;
/
