CREATE OR REPLACE PACKAGE BODY OPERACION.PKG_CONSULTA_UNIFICADA_SGA IS
  /****************************************************************************************
  REVISIONES:
  Version    Fecha        Autor           Solicitado por          Descripcion
  --------   ------       -------         ---------------         ------------
  1.0        26/02/2020   Team Dev                                INICIATIVA-476  Reingeniería de Venta y PostVenta Fija - SGA
  2.0        13/03/2020   Team Dev                                INICIATIVA-476  Reingeniería de Venta y PostVenta Fija - SGA
  3.0        31/03/2020   Team Dev                                INICIATIVA-519  Reingeniería de Venta y PostVenta Fija - SGA
  /****************************************************************************************/
  
  /*'****************************************************************
  '* Nombre SP : SGASS_CONS_SERV_EQU_PRI
  '* Proposito : Lista los Servicios y Equipos Principales .
  '* Input :   <P_COD_ID>      - Codigo de Contrato del BSCS.
               <P_CUSTOMER_ID> - Codigo del Cliente del BSCS.
  '* Output :  <P_COD_RESP>    - Codigo de Respuesta del SP.
               <P_MSJ_RESP>    - Mensaje de la Respuesta del SP.
               <P_DAT_SERV>    - Cursor con los Datos de Servicios y Equipos Principales.
  '* Creado por                : Team Dev
  '* Fecha de Creacion         : 25/02/2020.
  '* Actualizado por           : Team Dev
  '* Fecha de Actualizacion    : 02/03/2020
  '*****************************************************************/

  PROCEDURE SGASS_CONS_SERV_EQU_PRI(P_COD_ID      IN OPERACION.SOLOT.COD_ID%TYPE,
                                    P_CUSTOMER_ID IN OPERACION.SOLOT.CUSTOMER_ID%TYPE,
                                    P_COD_RESP    OUT NUMBER,
                                    P_MSJ_RESP    OUT VARCHAR2,
                                    P_TECNOLOGIA  OUT NUMBER, -- 3.0
                                    P_CODPLAN     OUT NUMBER, -- 3.0
                                    P_DAT_SERV    OUT TCUR_SER_EQU_PRI) IS
  BEGIN
    /*INICIO BLOQUE DE VALIDACIONES DE DATOS*/
    IF P_COD_ID IS NULL THEN
      P_COD_RESP := -3;
      P_MSJ_RESP := 'EL CODIGO DE CONTRATO(COD_ID) ES UN CAMPO OBLIGATORIO PARA REALIZAR LA CONSULTA, FAVOR INGRESAR EL VALOR SOLICITADO.';
      RETURN;
    ELSIF P_COD_ID <= 0 THEN
      P_COD_RESP := -3;
      P_MSJ_RESP := 'EL CODIGO DE CONTRATO(COD_ID) DEBE SER MAYOR A 0, FAVOR INGRESAR EL VALOR CORRECTO.';
      RETURN;
    END IF;
    IF P_CUSTOMER_ID IS NULL THEN
      P_COD_RESP := -3;
      P_MSJ_RESP := 'EL CODIGO DE CLIENTE(CUSTOMER_ID) ES UN CAMPO OBLIGATORIO PARA REALIZAR LA CONSULTA, FAVOR INGRESAR EL VALOR SOLICITADO.';
      RETURN;
    ELSIF P_CUSTOMER_ID <= 0 THEN
      P_COD_RESP := -3;
      P_MSJ_RESP := 'EL CODIGO DE CLIENTE(CUSTOMER_ID) DEBE SER MAYOR A 0, FAVOR INGRESAR EL VALOR CORRECTO.';
      RETURN;
    END IF;
    /*FIN   BLOQUE DE VALIDACIONES DE DATOS*/
    -- INI 3.0
    OPEN P_DAT_SERV FOR
      SELECT DISTINCT (CASE I.TIPSRV
                        WHEN CV_TELEFONIA THEN
                         'Telefonia'
                        WHEN CV_INTERNET THEN
                         'Internet'
                        WHEN CV_CABLE THEN
                         'Cable'
                      END) AS NOMBRE_SERVICIO,
                      (SELECT NVL(ABREV, DSCSRV)
                         FROM SALES.TYSTABSRV 
                        WHERE CODSRV = I.CODSRV) AS DESCRIPCION_SERVICIO,
                      TI.DESCRIPCION AS NOMBRE_EQUIPO,
                      (SELECT DISTINCT DESCRIPCION
                         FROM SALES.CRMDD 
                        WHERE CODIGON = S.TIPEQU
                          AND TIPCRMDD IN
                              (SELECT TIPCRMDD 
                                 FROM SALES.TIPCRMDD 
                                WHERE ABREV = 'DTHPOSTEQU')) AS MODELO_EQUIPO,
                      A.NRO_SERIE_TARJETA AS SERIE_EQUIPO,
                      NVL((SELECT TEC.PVTCN_CODTEC
                            FROM SALES.LINEA_PAQUETE           LP,
                                 SALES.SGAT_PAQVTA_TECNOLOGIA  TEC
                           WHERE LP.PVTCN_CODTEC = TEC.PVTCN_CODTEC
                             AND LP.IDDET = IP.IDDET
                             AND LP.CODSRV = IP.CODSRV),
                          '0') AS TECNOLOGIA
        FROM OPERACION.SOLOTPTOEQU         S,
             OPERACION.SOLOTPTO            B,
             OPERACION.INSPRD              IP,
             OPERACION.TIPEQU              TI,
             ALMTABMAT                     M,
             OPERACION.TABEQUIPO_MATERIAL  D,
             OPERACION.TARJETA_DECO_ASOC   A,
             OPERACION.INSSRV              I,
             OPERACION.SOLOT               SL
       WHERE S.CODSOLOT       = B.CODSOLOT
         AND B.CODSOLOT       = SL.CODSOLOT
         AND SL.CODSOLOT      = A.CODSOLOT
         AND B.CODINSSRV      = I.CODINSSRV
         AND I.CODINSSRV      = IP.CODINSSRV
         AND B.PID            = IP.PID
         AND TRIM(S.TIPEQU)   = TRIM(TI.TIPEQU)
         AND M.CODMAT         = TI.CODTIPEQU
         AND S.NUMSERIE       = D.NUMERO_SERIE
         AND A.NRO_SERIE_DECO = D.IMEI_ESN_UA
         AND D.NUMERO_SERIE   = S.NUMSERIE
         AND IP.IDDET         = S.IDDET
         AND IP.CODEQUCOM     = S.CODEQUCOM
         AND SL.COD_ID        = P_COD_ID
         AND SL.CUSTOMER_ID   = P_CUSTOMER_ID
         AND I.TIPSRV         = CV_CABLE
         AND TI.TIPO          = 'DECODIFICADOR'
         AND D.TIPO           = 2
         AND B.TIPO           = 1
         AND S.ESTADO         != 12
         AND SL.ESTSOL        IN (12, 29)
         AND IP.ESTINSPRD     IN (1, 2)
      UNION ALL
      SELECT DISTINCT (CASE I.TIPSRV
                        WHEN CV_TELEFONIA THEN
                         'Telefonia'
                        WHEN CV_INTERNET THEN
                         'Internet'
                        WHEN CV_CABLE THEN
                         'Cable'
                      END) AS NOMBRE_SERVICIO,
                      (SELECT NVL(ABREV, DSCSRV)
                         FROM SALES.TYSTABSRV 
                        WHERE CODSRV = I.CODSRV) AS DESCRIPCION_SERVICIO,
                      TI.DESCRIPCION AS NOMBRE_EQUIPO,
                      TI.ABREV AS MODELO_EQUIPO,
                      S.NUMSERIE AS SERIE_EQUIPO,
                      NVL((SELECT TEC.PVTCN_CODTEC
                            FROM SALES.LINEA_PAQUETE           LP,
                                 SALES.SGAT_PAQVTA_TECNOLOGIA  TEC
                           WHERE LP.PVTCN_CODTEC = TEC.PVTCN_CODTEC
                             AND LP.IDDET = IP.IDDET
                             AND LP.CODSRV = IP.CODSRV),
                          '0') AS TECNOLOGIA
        FROM OPERACION.SOLOTPTOEQU         S,
             OPERACION.SOLOTPTO            B,
             OPERACION.INSPRD              IP,
             OPERACION.INSSRV              I,
             OPERACION.TIPEQU              TI,
             ALMTABMAT                     M,
             OPERACION.TABEQUIPO_MATERIAL  D,
             OPERACION.SOLOT               SL
       WHERE S.CODSOLOT     = B.CODSOLOT
         AND B.CODSOLOT     = SL.CODSOLOT
         AND B.CODINSSRV    = I.CODINSSRV
         AND I.CODINSSRV    = IP.CODINSSRV
         AND B.PID          = IP.PID
         AND TRIM(S.TIPEQU) = TRIM(TI.TIPEQU)
         AND M.CODMAT       = TI.CODTIPEQU
         AND S.NUMSERIE     = D.NUMERO_SERIE
         AND SL.COD_ID      = P_COD_ID
         AND SL.CUSTOMER_ID = P_CUSTOMER_ID
         AND I.TIPSRV       = CV_TELEFONIA
         AND TI.TIPO        = 'SMART CARD'
         AND S.ESTADO       != 12
         AND D.TIPO         = 3
         AND B.TIPO         = 1
         AND SL.ESTSOL      IN (12, 29)
         AND IP.ESTINSPRD   IN (1, 2)
         AND IP.CODEQUCOM   IS NOT NULL
      UNION ALL
      SELECT DISTINCT (CASE I.TIPSRV
                        WHEN CV_TELEFONIA THEN
                         'Telefonia'
                        WHEN CV_INTERNET THEN
                         'Internet'
                        WHEN CV_CABLE THEN
                         'Cable'
                      END) AS NOMBRE_SERVICIO,
                      (SELECT NVL(ABREV, DSCSRV)
                         FROM SALES.TYSTABSRV 
                        WHERE CODSRV = I.CODSRV) AS DESCRIPCION_SERVICIO,
                      TI.DESCRIPCION AS NOMBRE_EQUIPO,
                      TI.ABREV AS MODELO_EQUIPO,
                      S.NUMSERIE AS SERIE_EQUIPO,
                      NVL((SELECT TEC.PVTCN_CODTEC
                            FROM SALES.LINEA_PAQUETE           LP,
                                 SALES.SGAT_PAQVTA_TECNOLOGIA  TEC
                           WHERE LP.PVTCN_CODTEC = TEC.PVTCN_CODTEC
                             AND LP.IDDET = IP.IDDET
                             AND LP.CODSRV = IP.CODSRV),
                          '0') AS TECNOLOGIA
        FROM OPERACION.SOLOTPTOEQU         S,
             OPERACION.SOLOTPTO            B,
             OPERACION.INSPRD              IP,
             OPERACION.INSSRV              I,
             OPERACION.TIPEQU              TI,
             ALMTABMAT                     M,
             OPERACION.TABEQUIPO_MATERIAL  D,
             OPERACION.SOLOT               SL
       WHERE S.CODSOLOT     = B.CODSOLOT
         AND B.CODSOLOT     = SL.CODSOLOT
         AND B.CODINSSRV    = I.CODINSSRV
         AND I.CODINSSRV    = IP.CODINSSRV
         AND B.PID          = IP.PID
         AND IP.IDDET       = S.IDDET
         AND IP.CODEQUCOM   = S.CODEQUCOM
         AND TRIM(S.TIPEQU) = TRIM(TI.TIPEQU)
         AND M.CODMAT       = TI.CODTIPEQU
         AND S.NUMSERIE     = D.NUMERO_SERIE
         AND SL.COD_ID      = P_COD_ID
         AND SL.CUSTOMER_ID = P_CUSTOMER_ID
         AND I.TIPSRV       = CV_INTERNET
         AND TI.TIPO        != 'SMART CARD'
         AND S.ESTADO       != 12
         AND D.TIPO         = 4
         AND B.TIPO         = 1
         AND SL.ESTSOL      IN (12, 29)
         AND IP.ESTINSPRD   IN (1, 2)
      UNION ALL
      SELECT DISTINCT (CASE I.TIPSRV
                        WHEN CV_TELEFONIA THEN
                         'Telefonia'
                        WHEN CV_INTERNET THEN
                         'Internet'
                        WHEN CV_CABLE THEN
                         'Cable'
                      END) AS NOMBRE_SERVICIO,
                      (SELECT NVL(ABREV, DSCSRV)
                         FROM SALES.TYSTABSRV 
                        WHERE CODSRV = I.CODSRV) AS DESCRIPCION_SERVICIO,
                      NVL((SELECT DISTINCT A.DESMAT
                            FROM OPERACION.MAESTRO_SERIES_EQU  M,
                                 ALMTABMAT                     A,
                                 OPERACION.TIPEQU              T
                           WHERE M.NROSERIE = P.SERIAL_NUMBER
                             AND M.COD_SAP = A.COD_SAP
                             AND TRIM(A.CODMAT) = TRIM(T.CODTIPEQU)),
                          ((CASE I.TIPSRV
                            WHEN CV_TELEFONIA THEN
                             (SELECT DISTINCT UPPER(V.DSCEQU)
                                FROM SALES.VTAEQUCOM   V,
                                     OPERACION.INSPRD  R,
                                     OPERACION.INSSRV  S
                               WHERE R.CODINSSRV = S.CODINSSRV
                                 AND R.CODEQUCOM = V.CODEQUCOM
                                 AND S.ESTINSSRV IN (1, 2)
                                 AND R.ESTINSPRD IN (1, 2)
                                 AND R.CODINSSRV =
                                     (SELECT DISTINCT Y.CODINSSRV
                                        FROM SOLOTPTO  X,
                                             INSSRV    Y
                                       WHERE X.CODINSSRV = Y.CODINSSRV
                                         AND X.CODSOLOT = S.CODSOLOT
                                         AND Y.ESTINSSRV IN (1, 2)
                                         AND Y.TIPSRV = CV_INTERNET)
                                 AND V.TIP_EQ NOT IN
                                     (SELECT CODIGOC
                                        FROM OPERACION.OPEDD  O
                                       WHERE O.TIPOPEDD =
                                             (SELECT TIPOPEDD
                                                FROM OPERACION.TIPOPEDD 
                                               WHERE ABREV = 'CVE_CP')
                                         AND ABREVIACION = 'NO_EQU'))
                            WHEN CV_INTERNET THEN
                             (SELECT DISTINCT UPPER(V.DSCEQU)
                                FROM SALES.VTAEQUCOM   V,
                                     OPERACION.INSPRD  R,
                                     OPERACION.INSSRV  S
                               WHERE R.CODINSSRV = S.CODINSSRV
                                 AND R.CODEQUCOM = V.CODEQUCOM
                                 AND S.ESTINSSRV IN (1, 2)
                                 AND R.ESTINSPRD IN (1, 2)
                                 AND R.CODINSSRV =
                                     (SELECT DISTINCT Y.CODINSSRV
                                        FROM SOLOTPTO  X,
                                             INSSRV    Y
                                       WHERE X.CODINSSRV = Y.CODINSSRV
                                         AND X.CODSOLOT = S.CODSOLOT
                                         AND Y.ESTINSSRV IN (1, 2)
                                         AND Y.TIPSRV = CV_INTERNET)
                                 AND V.TIP_EQ NOT IN
                                     (SELECT CODIGOC
                                        FROM OPERACION.OPEDD  O
                                       WHERE O.TIPOPEDD =
                                             (SELECT TIPOPEDD
                                                FROM OPERACION.TIPOPEDD 
                                               WHERE ABREV = 'CVE_CP')
                                         AND ABREVIACION = 'NO_EQU'))
                            ELSE
                             (NVL((SELECT DISTINCT UPPER(V.DSCEQU)
                                    FROM SALES.VTAEQUCOM   V,
                                         OPERACION.INSPRD  R
                                   WHERE R.CODEQUCOM = V.CODEQUCOM
                                     AND R.CODINSSRV = IP.CODINSSRV
                                     AND V.CODEQUCOM = IP.CODEQUCOM
                                     AND R.ESTINSPRD IN (1, 2)
                                     AND V.TIP_EQ NOT IN
                                         (SELECT CODIGOC
                                            FROM OPERACION.OPEDD  O
                                           WHERE O.TIPOPEDD =
                                                 (SELECT TIPOPEDD
                                                    FROM OPERACION.TIPOPEDD 
                                                   WHERE ABREV = 'CVE_CP')
                                             AND ABREVIACION = 'NO_EQU')),
                                  (SELECT DISTINCT UPPER(V.DSCEQU)
                                     FROM SALES.VTAEQUCOM   V,
                                          OPERACION.INSPRD  R
                                    WHERE R.CODEQUCOM = V.CODEQUCOM
                                      AND R.CODINSSRV = IP.CODINSSRV
                                      AND R.CODEQUCOM = IP.CODEQUCOM
                                      AND R.ESTINSPRD IN (1, 2)
                                      AND V.TIP_EQ NOT IN
                                          (SELECT CODIGOC
                                             FROM OPERACION.OPEDD  O
                                            WHERE O.TIPOPEDD =
                                                  (SELECT TIPOPEDD
                                                     FROM OPERACION.TIPOPEDD 
                                                    WHERE ABREV = 'CVE_CP')
                                              AND ABREVIACION = 'NO_EQU'))))
                          END))) AS NOMBRE_EQUIPO,
                      NVL((SELECT DISTINCT T.DESCRIPCION
                            FROM OPERACION.MAESTRO_SERIES_EQU  M,
                                 ALMTABMAT                     A,
                                 TIPEQU                        T
                           WHERE M.NROSERIE = P.SERIAL_NUMBER
                             AND M.COD_SAP = A.COD_SAP
                             AND TRIM(A.CODMAT) = TRIM(T.CODTIPEQU)),
                          (CASE I.TIPSRV
                            WHEN CV_TELEFONIA THEN
                             (SELECT DISTINCT UPPER(V.TIP_EQ)
                                FROM SALES.VTAEQUCOM   V,
                                     OPERACION.INSPRD  R,
                                     OPERACION.INSSRV  S
                               WHERE R.CODINSSRV = S.CODINSSRV
                                 AND R.CODEQUCOM = V.CODEQUCOM
                                 AND R.ESTINSPRD IN (1, 2)
                                 AND R.CODINSSRV =
                                     (SELECT DISTINCT Y.CODINSSRV
                                        FROM SOLOTPTO  X,
                                             INSSRV    Y
                                       WHERE X.CODINSSRV = Y.CODINSSRV
                                         AND X.CODSOLOT = S.CODSOLOT
                                         AND Y.ESTINSSRV IN (1, 2)
                                         AND Y.TIPSRV = CV_INTERNET)
                                 AND V.TIP_EQ NOT IN
                                     (SELECT CODIGOC
                                        FROM OPERACION.OPEDD  O
                                       WHERE O.TIPOPEDD =
                                             (SELECT TIPOPEDD
                                                FROM OPERACION.TIPOPEDD 
                                               WHERE ABREV = 'CVE_CP')
                                         AND ABREVIACION = 'NO_EQU'))
                            WHEN CV_INTERNET THEN
                             (SELECT DISTINCT UPPER(V.TIP_EQ)
                                FROM SALES.VTAEQUCOM   V,
                                     OPERACION.INSPRD  R,
                                     OPERACION.INSSRV  S
                               WHERE R.CODINSSRV = S.CODINSSRV
                                 AND R.CODEQUCOM = V.CODEQUCOM
                                 AND R.ESTINSPRD IN (1, 2)
                                 AND R.CODINSSRV =
                                     (SELECT DISTINCT Y.CODINSSRV
                                        FROM SOLOTPTO  X,
                                             INSSRV    Y
                                       WHERE X.CODINSSRV = Y.CODINSSRV
                                         AND X.CODSOLOT = S.CODSOLOT
                                         AND Y.ESTINSSRV IN (1, 2)
                                         AND Y.TIPSRV = CV_INTERNET)
                                 AND V.TIP_EQ NOT IN
                                     (SELECT CODIGOC
                                        FROM OPERACION.OPEDD  O
                                       WHERE O.TIPOPEDD =
                                             (SELECT TIPOPEDD
                                                FROM OPERACION.TIPOPEDD 
                                               WHERE ABREV = 'CVE_CP')
                                         AND ABREVIACION = 'NO_EQU'))
                            ELSE
                             (SELECT DISTINCT UPPER(V.TIP_EQ)
                                FROM SALES.VTAEQUCOM   V,
                                     OPERACION.INSPRD  R
                               WHERE R.CODEQUCOM = V.CODEQUCOM
                                 AND R.CODINSSRV = IP.CODINSSRV
                                 AND R.CODEQUCOM = IP.CODEQUCOM
                                 AND R.ESTINSPRD IN (1, 2)
                                 AND V.TIP_EQ NOT IN
                                     (SELECT CODIGOC
                                        FROM OPERACION.OPEDD  O
                                       WHERE O.TIPOPEDD =
                                             (SELECT TIPOPEDD
                                                FROM OPERACION.TIPOPEDD 
                                               WHERE ABREV = 'CVE_CP')
                                         AND ABREVIACION = 'NO_EQU'))
                          END)) AS MODELO_EQUIPO,
                      P.SERIAL_NUMBER AS SERIE_EQUIPO,
                      NVL((SELECT TEC.PVTCN_CODTEC
                            FROM SALES.LINEA_PAQUETE           LP,
                                 SALES.SGAT_PAQVTA_TECNOLOGIA  TEC
                           WHERE LP.PVTCN_CODTEC = TEC.PVTCN_CODTEC
                             AND LP.IDDET = IP.IDDET
                             AND LP.CODSRV = IP.CODSRV),
                          '0') AS TECNOLOGIA
        FROM OPERACION.SOLOTPTO        SP,
             OPERACION.INSPRD          IP,
             OPERACION.INSSRV          I,
             OPERACION.TAB_EQUIPOS_IW  P,
             OPERACION.SOLOT           S
       WHERE SP.CODSOLOT   = S.CODSOLOT
         AND S.CODSOLOT    = P.CODSOLOT
         AND SP.CODINSSRV  = I.CODINSSRV
         AND I.CODINSSRV   = IP.CODINSSRV
         AND SP.PID        = IP.PID
         AND S.COD_ID      = P_COD_ID
         AND S.CUSTOMER_ID = P_CUSTOMER_ID
         AND ((I.TIPSRV = CV_INTERNET  AND P.TIPO_SERVICIO = CV_INT) OR
              (I.TIPSRV = CV_TELEFONIA AND P.TIPO_SERVICIO = CV_TEL) OR
              (I.TIPSRV = CV_CABLE     AND P.TIPO_SERVICIO = CV_CTV))
         AND IP.ESTINSPRD IN (1, 2)
         AND S.ESTSOL     IN (12, 29)
         AND IP.CODEQUCOM IS NULL;

    BEGIN
      SELECT DISTINCT I.IDPAQ,
                      (SELECT TEC.PVTCN_CODTEC
                         FROM SALES.LINEA_PAQUETE          LP,
                              SALES.SGAT_PAQVTA_TECNOLOGIA TEC
                        WHERE LP.PVTCN_CODTEC = TEC.PVTCN_CODTEC
                          AND LP.IDDET = IP.IDDET
                          AND LP.CODSRV = IP.CODSRV)
        INTO P_CODPLAN, P_TECNOLOGIA
        FROM OPERACION.SOLOTPTO       SP,
             OPERACION.INSPRD         IP,
             OPERACION.INSSRV         I,
             OPERACION.TAB_EQUIPOS_IW P,
             OPERACION.SOLOT          S
       WHERE SP.CODSOLOT   = S.CODSOLOT
         AND S.CODSOLOT    = P.CODSOLOT
         AND SP.CODINSSRV  = I.CODINSSRV
         AND I.CODINSSRV   = IP.CODINSSRV
         AND SP.PID        = IP.PID
         AND SP.CODSOLOT   = OPERACION.PQ_SGA_IW.F_MAX_SOT_X_COD_ID(P_COD_ID)
         AND ((I.TIPSRV = CV_INTERNET  AND P.TIPO_SERVICIO = CV_INT) OR
              (I.TIPSRV = CV_TELEFONIA AND P.TIPO_SERVICIO = CV_TEL) OR
              (I.TIPSRV = CV_CABLE     AND P.TIPO_SERVICIO = CV_CTV))
         AND IP.ESTINSPRD IN (1, 2)
         AND S.ESTSOL     IN (12, 29)
         AND IP.CODEQUCOM IS NULL
         AND I.IDPAQ      IS NOT NULL
         AND (SELECT TEC.PVTCN_CODTEC
                FROM SALES.LINEA_PAQUETE LP,
                     SALES.SGAT_PAQVTA_TECNOLOGIA TEC
               WHERE LP.PVTCN_CODTEC = TEC.PVTCN_CODTEC
                 AND LP.IDDET        = IP.IDDET
                 AND LP.CODSRV       = IP.CODSRV) > 0
         AND ROWNUM = 1;
    EXCEPTION
      WHEN OTHERS THEN
        BEGIN
          SELECT DISTINCT I.IDPAQ,
                          (SELECT TEC.PVTCN_CODTEC
                             FROM SALES.LINEA_PAQUETE          LP,
                                  SALES.SGAT_PAQVTA_TECNOLOGIA TEC
                            WHERE LP.PVTCN_CODTEC = TEC.PVTCN_CODTEC
                              AND LP.IDDET        = IP.IDDET
                              AND LP.CODSRV       = IP.CODSRV)
            INTO P_CODPLAN, P_TECNOLOGIA
            FROM OPERACION.SOLOTPTOEQU        S,
                 OPERACION.SOLOTPTO           B,
                 OPERACION.INSPRD             IP,
                 OPERACION.INSSRV             I,
                 OPERACION.TIPEQU             TI,
                 ALMTABMAT                    M,
                 OPERACION.TABEQUIPO_MATERIAL D,
                 OPERACION.SOLOT              SL
           WHERE S.CODSOLOT     = B.CODSOLOT
             AND B.CODSOLOT     = SL.CODSOLOT
             AND B.CODINSSRV    = I.CODINSSRV
             AND I.CODINSSRV    = IP.CODINSSRV
             AND B.PID          = IP.PID
             AND TRIM(S.TIPEQU) = TRIM(TI.TIPEQU)
             AND M.CODMAT       = TI.CODTIPEQU
             AND S.NUMSERIE     = D.NUMERO_SERIE
             AND SL.COD_ID      = P_COD_ID
             AND SL.CUSTOMER_ID = P_CUSTOMER_ID
             AND B.TIPO         = 1
             AND SL.ESTSOL      IN (12, 29)
             AND IP.ESTINSPRD   IN (1, 2)
             AND IP.CODEQUCOM   IS NOT NULL
             AND I.IDPAQ        IS NOT NULL
             AND (SELECT TEC.PVTCN_CODTEC
                    FROM SALES.LINEA_PAQUETE          LP,
                         SALES.SGAT_PAQVTA_TECNOLOGIA TEC
                   WHERE LP.PVTCN_CODTEC = TEC.PVTCN_CODTEC
                     AND LP.IDDET        = IP.IDDET
                     AND LP.CODSRV       = IP.CODSRV) > 0
             AND ROWNUM = 1;
        EXCEPTION
          WHEN OTHERS THEN
            P_TECNOLOGIA := 0;
            P_CODPLAN    := 0;
        END;
    END;

    -- FIN 2.0
    P_COD_RESP := 0;
    P_MSJ_RESP := 'SE EJECUTO EL SP: SGASS_CONS_SERV_EQU_PRI CORRECTAMENTE.';

  EXCEPTION
    WHEN OTHERS THEN
      P_COD_RESP := -1;
      P_MSJ_RESP := 'ERROR AL EJECUTAR SP SGASS_CONS_SERV_EQU_PRI: ' ||
                    TO_CHAR(SQLCODE) || ' ' || SQLERRM;
  END;

  /*'****************************************************************
  '* Nombre SP : SGASS_CONS_SERV_EQU_ADI
  '* Proposito : Lista los Servicios y Equipos Adicionales .
  '* Input :   <P_COD_ID>      - Codigo de Contrato del BSCS.
               <P_CUSTOMER_ID> - Codigo del Cliente del BSCS.
  '* Output :  <P_COD_RESP>    - Codigo de Respuesta del SP.
               <P_MSJ_RESP>    - Mensaje de la Respuesta del SP.
               <P_DAT_SERV>    - Cursor con los Datos de Servicios y Equipos Adicionales.
  '* Creado por                : Team Dev
  '* Fecha de Creacion         : 25/02/2020.
  '* Actualizado por           : Team Dev
  '* Fecha de Actualizacion    : 02/03/2020
  '*****************************************************************/
  PROCEDURE SGASS_CONS_SERV_EQU_ADI(P_COD_ID      IN OPERACION.SOLOT.COD_ID%TYPE,
                                    P_CUSTOMER_ID IN OPERACION.SOLOT.CUSTOMER_ID%TYPE,
                                    P_COD_RESP    OUT NUMBER,
                                    P_MSJ_RESP    OUT VARCHAR2,
                                    P_DAT_SERV    OUT TCUR_SER_EQU_ADI) IS
  BEGIN

    /*INICIO BLOQUE DE VALIDACIONES DE DATOS*/
    IF P_COD_ID IS NULL THEN
      P_COD_RESP := -3;
      P_MSJ_RESP := 'EL CODIGO DE CONTRATO(COD_ID) ES UN CAMPO OBLIGATORIO PARA REALIZAR LA CONSULTA, FAVOR INGRESAR EL VALOR SOLICITADO.';
      RETURN;
    ELSIF P_COD_ID <= 0 THEN
      P_COD_RESP := -3;
      P_MSJ_RESP := 'EL CODIGO DE CONTRATO(COD_ID) DEBE SER MAYOR A 0, FAVOR INGRESAR EL VALOR CORRECTO.';
      RETURN;
    END IF;
    IF P_CUSTOMER_ID IS NULL THEN
      P_COD_RESP := -3;
      P_MSJ_RESP := 'EL CODIGO DE CLIENTE(CUSTOMER_ID) ES UN CAMPO OBLIGATORIO PARA REALIZAR LA CONSULTA, FAVOR INGRESAR EL VALOR SOLICITADO.';
      RETURN;
    ELSIF P_CUSTOMER_ID <= 0 THEN
      P_COD_RESP := -3;
      P_MSJ_RESP := 'EL CODIGO DE CLIENTE(CUSTOMER_ID) DEBE SER MAYOR A 0, FAVOR INGRESAR EL VALOR CORRECTO.';
      RETURN;
    END IF;
    /*FIN   BLOQUE DE VALIDACIONES DE DATOS*/
    -- INI 3.0
    OPEN P_DAT_SERV FOR
      SELECT DISTINCT (CASE I.TIPSRV WHEN CV_TELEFONIA THEN 'Telefonia'
                                     WHEN CV_INTERNET  THEN 'Internet'
                                     WHEN CV_CABLE     THEN 'Cable' END) AS NOMBRE_SERVICIO,
                      (SELECT NVL(ABREV,DSCSRV)
                         FROM SALES.TYSTABSRV 
                        WHERE CODSRV = I.CODSRV)             AS DESCRIPCION_SERVICIO,
                      TI.DESCRIPCION                         AS NOMBRE_EQUIPO,
                      (SELECT DISTINCT DESCRIPCION
                         FROM SALES.CRMDD 
                        WHERE CODIGON = S.TIPEQU
                          AND TIPCRMDD IN
                              (SELECT TIPCRMDD
                                 FROM SALES.TIPCRMDD 
                                WHERE ABREV = 'DTHPOSTEQU')) AS MODELO_EQUIPO,
                      A.NRO_SERIE_TARJETA                    AS SERIE_EQUIPO,
                      NVL((SELECT TEC.PVTCN_CODTEC
                             FROM SALES.LINEA_PAQUETE  LP,
                                  SALES.SGAT_PAQVTA_TECNOLOGIA  TEC
                            WHERE LP.PVTCN_CODTEC = TEC.PVTCN_CODTEC
                              AND LP.IDDET        = IP.IDDET
                              AND LP.CODSRV       = IP.CODSRV),'0') AS TECNOLOGIA,
                      0 AS CARGO_FIJO_PROMOCION,
                      SGAFUN_GET_SRVSNCODE(SL.COD_ID, IP.CODSRV) AS CARGO_FIJO
        FROM OPERACION.SOLOTPTOEQU         S,
             OPERACION.SOLOTPTO            B,
             OPERACION.INSPRD              IP,
             OPERACION.SOLOT               SL,
             OPERACION.INSSRV              I,
             OPERACION.TIPEQU              TI,
             ALMTABMAT                     M,
             OPERACION.TABEQUIPO_MATERIAL  D,
             OPERACION.TARJETA_DECO_ASOC   A
       WHERE S.CODSOLOT       = B.CODSOLOT
         AND B.CODSOLOT       = SL.CODSOLOT
         AND SL.CODSOLOT      = A.CODSOLOT
         AND B.CODINSSRV      = I.CODINSSRV
         AND I.CODINSSRV      = IP.CODINSSRV
         AND B.PID            = IP.PID
         AND S.TIPEQU         = TI.TIPEQU
         AND TRIM(M.CODMAT)   = TRIM(TI.CODTIPEQU)
         AND S.NUMSERIE       = D.NUMERO_SERIE
         AND B.CODINSSRV      = I.CODINSSRV
         AND I.CODINSSRV      = IP.CODINSSRV
         AND B.PID            = IP.PID
         AND A.NRO_SERIE_DECO = D.IMEI_ESN_UA
         AND D.NUMERO_SERIE   = S.NUMSERIE
         AND IP.IDDET         = S.IDDET
         AND IP.CODEQUCOM     = S.CODEQUCOM
         AND SL.COD_ID        = P_COD_ID
         AND SL.CUSTOMER_ID   = P_CUSTOMER_ID
         AND TI.TIPO          = 'DECODIFICADOR'
         AND D.TIPO           = 2
         AND B.TIPO           = 6
         AND I.TIPSRV         = CV_CABLE
         AND S.ESTADO         != 12
         AND IP.ESTINSPRD     IN (1, 2)
         AND I.ESTINSSRV      IN (1,2)
         AND SL.ESTSOL        IN (12, 29)
      UNION ALL
      SELECT DISTINCT (CASE I.TIPSRV WHEN CV_TELEFONIA THEN 'Telefonia'
                                     WHEN CV_INTERNET  THEN 'Internet'
                                     WHEN CV_CABLE     THEN 'Cable' END) AS NOMBRE_SERVICIO,
                      (SELECT NVL(ABREV,DSCSRV)
                         FROM SALES.TYSTABSRV 
                        WHERE CODSRV = I.CODSRV) AS DESCRIPCION_SERVICIO,
                      TI.DESCRIPCION             AS NOMBRE_EQUIPO,
                      TI.ABREV                   AS MODELO_EQUIPO,
                      S.NUMSERIE                 AS SERIE_EQUIPO,
                      NVL((SELECT TEC.PVTCN_CODTEC
                             FROM SALES.LINEA_PAQUETE  LP,
                                  SALES.SGAT_PAQVTA_TECNOLOGIA  TEC
                            WHERE LP.PVTCN_CODTEC = TEC.PVTCN_CODTEC
                              AND LP.IDDET        = IP.IDDET
                              AND LP.CODSRV       = IP.CODSRV),'0') AS TECNOLOGIA,
                      0 AS CARGO_FIJO_PROMOCION,
                      SGAFUN_GET_SRVSNCODE(SL.COD_ID, IP.CODSRV) AS CARGO_FIJO
        FROM OPERACION.SOLOTPTOEQU         S,
             OPERACION.SOLOTPTO            B,
             OPERACION.INSPRD              IP,
             OPERACION.SOLOT               SL,
             OPERACION.INSSRV              I,
             OPERACION.TIPEQU              TI,
             ALMTABMAT                     M,
             OPERACION.TABEQUIPO_MATERIAL  D
       WHERE S.CODSOLOT     = B.CODSOLOT
         AND B.CODSOLOT     = SL.CODSOLOT
         AND B.CODINSSRV    = I.CODINSSRV
         AND I.CODINSSRV    = IP.CODINSSRV
         AND S.TIPEQU       = TI.TIPEQU
         AND TRIM(M.CODMAT) = TRIM(TI.CODTIPEQU)
         AND S.NUMSERIE     = D.NUMERO_SERIE
         AND B.PID          = IP.PID
         AND IP.IDDET       = S.IDDET
         AND IP.CODEQUCOM   = S.CODEQUCOM
         AND SL.COD_ID      = P_COD_ID
         AND SL.CUSTOMER_ID = P_CUSTOMER_ID
         AND S.ESTADO       != 12
         AND D.TIPO         = 3
         AND I.TIPSRV       = CV_TELEFONIA
         AND B.TIPO         = 6
         AND SL.ESTSOL      IN (12, 29)
         AND I.ESTINSSRV IN (1,2)     
         AND IP.ESTINSPRD   IN (1, 2)
      UNION ALL
      SELECT DISTINCT (CASE I.TIPSRV WHEN CV_TELEFONIA THEN 'Telefonia'
                                     WHEN CV_INTERNET  THEN 'Internet'
                                     WHEN CV_CABLE     THEN 'Cable' END) AS NOMBRE_SERVICIO,
                      (SELECT NVL(ABREV,DSCSRV) FROM TYSTABSRV  WHERE CODSRV = I.CODSRV) AS DESCRIPCION_SERVICIO,
                      TI.DESCRIPCION                                         AS NOMBRE_EQUIPO,
                      TI.ABREV                                               AS MODELO_EQUIPO,
                      S.NUMSERIE                                             AS SERIE_EQUIPO,
                      NVL((SELECT TEC.PVTCN_CODTEC
                             FROM SALES.LINEA_PAQUETE  LP,
                                  SALES.SGAT_PAQVTA_TECNOLOGIA  TEC
                            WHERE LP.PVTCN_CODTEC = TEC.PVTCN_CODTEC
                              AND LP.IDDET        = IP.IDDET
                              AND LP.CODSRV       = IP.CODSRV),'0') AS TECNOLOGIA,
                      0 AS CARGO_FIJO_PROMOCION,
                      SGAFUN_GET_SRVSNCODE(SL.COD_ID, IP.CODSRV) AS CARGO_FIJO
        FROM SOLOTPTOEQU                   S,
             OPERACION.SOLOTPTO            B,
             OPERACION.INSPRD              IP,
             OPERACION.SOLOT               SL,
             OPERACION.INSSRV              I,
             TIPEQU                        TI,
             ALMTABMAT                     M,
             OPERACION.TABEQUIPO_MATERIAL  D
       WHERE S.CODSOLOT     = B.CODSOLOT
         AND B.CODSOLOT     = SL.CODSOLOT
         AND B.CODINSSRV    = I.CODINSSRV
         AND I.CODINSSRV    = IP.CODINSSRV
         AND B.PID          = IP.PID
         AND IP.IDDET       = S.IDDET
         AND S.TIPEQU       = TI.TIPEQU
         AND TRIM(M.CODMAT) = TRIM(TI.CODTIPEQU)
         AND S.NUMSERIE     = D.NUMERO_SERIE
         AND IP.CODEQUCOM   = S.CODEQUCOM
         AND SL.COD_ID      = P_COD_ID
         AND SL.CUSTOMER_ID = P_CUSTOMER_ID
         AND IP.FLGPRINC    = 0
         AND S.ESTADO       != 12
         AND D.TIPO         = 4
         AND I.TIPSRV       = CV_INTERNET
         AND B.TIPO         = 6
         AND SL.ESTSOL      IN (12, 29)
         AND I.ESTINSSRV    IN (1,2)
         AND IP.ESTINSPRD   IN (1, 2)
      UNION ALL
      SELECT DISTINCT (CASE I.TIPSRV WHEN CV_TELEFONIA THEN 'Telefonia'
                                     WHEN CV_INTERNET  THEN 'Internet'
                                     WHEN CV_CABLE     THEN 'Cable' END) AS NOMBRE_SERVICIO,
                      (SELECT NVL(ABREV, DSCSRV)
                         FROM SALES.TYSTABSRV  
                        WHERE CODSRV = I.CODSRV) AS DESCRIPCION_SERVICIO,
                      NVL((SELECT A.DESMAT
                            FROM MAESTRO_SERIES_EQU   M,
                                 ALMTABMAT            A,
                                 OPERACION.TIPEQU     T
                           WHERE M.COD_SAP = A.COD_SAP
                             AND A.CODMAT = T.CODTIPEQU
                             AND M.NROSERIE = SPE.NUMSERIE
                             AND T.TIPO = 'DECODIFICADOR'),
                          (SELECT DSCEQU
                             FROM VTAEQUCOM  
                            WHERE CODEQUCOM = IP.CODEQUCOM)) AS NOMBRE_EQUIPO,
                      NVL((SELECT T.DESCRIPCION
                            FROM MAESTRO_SERIES_EQU   M,
                                 ALMTABMAT            A,
                                 OPERACION.TIPEQU     T
                           WHERE M.COD_SAP = A.COD_SAP
                             AND A.CODMAT = T.CODTIPEQU
                             AND M.NROSERIE = SPE.NUMSERIE
                             AND T.TIPO = 'DECODIFICADOR'),
                          (SELECT MODELOEQUITW
                             FROM VTAEQUCOM  
                            WHERE CODEQUCOM = IP.CODEQUCOM)) AS MODELO_EQUIPO,
                      SPE.NUMSERIE AS SERIE_EQUIPO,
                      NVL((SELECT TEC.PVTCN_CODTEC
                            FROM SALES.LINEA_PAQUETE            LP,
                                 SALES.SGAT_PAQVTA_TECNOLOGIA   TEC
                           WHERE LP.PVTCN_CODTEC = TEC.PVTCN_CODTEC
                             AND LP.IDDET = IP.IDDET
                             AND LP.CODSRV = IP.CODSRV),
                          '0') AS TECNOLOGIA,
                      0 AS CARGO_FIJO_PROMOCION,
                      SGAFUN_GET_SRVSNCODE(S.COD_ID, IP.CODSRV) AS CARGO_FIJO
        FROM OPERACION.SOLOTPTOEQU   SPE,
             OPERACION.SOLOTPTO      SP,
             OPERACION.SOLOT         S,
             OPERACION.INSSRV        I,
             OPERACION.INSPRD        IP
       WHERE SPE.CODSOLOT  = SP.CODSOLOT
         AND SP.CODSOLOT   = S.CODSOLOT
         AND SP.CODINSSRV  = I.CODINSSRV
         AND I.CODINSSRV   = IP.CODINSSRV
         AND SP.PID        = IP.PID
         AND S.COD_ID      = P_COD_ID
         AND S.CUSTOMER_ID = P_CUSTOMER_ID
         AND I.TIPSRV      = CV_CABLE
         AND IP.FLGPRINC   = 0
         AND SPE.ESTADO    != 12
         AND I.ESTINSSRV   IN (1,2)
         AND S.ESTSOL      IN (12, 29)
         AND SPE.NUMSERIE  IS NOT NULL
         AND IP.CODEQUCOM  IS NOT NULL
         AND NOT EXISTS (SELECT 1
                FROM OPERACION.TAB_EQUIPOS_IW  
               WHERE COD_ID        = S.COD_ID
                 AND CUSTOMER_ID   = S.CUSTOMER_ID
                 AND SERIAL_NUMBER = SPE.NUMSERIE)
      UNION ALL
      SELECT DISTINCT (CASE I.TIPSRV WHEN CV_TELEFONIA THEN 'Telefonia'
                                     WHEN CV_INTERNET  THEN 'Internet'
                                     WHEN CV_CABLE     THEN 'Cable' END) AS NOMBRE_SERVICIO,
                      (SELECT NVL(ABREV,DSCSRV)
                         FROM SALES.TYSTABSRV 
                        WHERE CODSRV = IP.CODSRV) AS DESCRIPCION_SERVICIO,
                      ''                          AS NOMBRE_EQUIPO,
                      ''                          AS MODELO_EQUIPO,
                      ''                          AS SERIE_EQUIPO,
                      NVL((SELECT TEC.PVTCN_CODTEC
                             FROM SALES.LINEA_PAQUETE  LP,
                                  SALES.SGAT_PAQVTA_TECNOLOGIA  TEC
                            WHERE LP.PVTCN_CODTEC = TEC.PVTCN_CODTEC
                              AND LP.IDDET        = IP.IDDET
                              AND LP.CODSRV       = IP.CODSRV),'0') AS TECNOLOGIA,
                      0 AS CARGO_FIJO_PROMOCION,
                      SGAFUN_GET_SRVSNCODE(S.COD_ID, IP.CODSRV) AS CARGO_FIJO
        FROM OPERACION.SOLOTPTO   SP,
             OPERACION.SOLOT      S,
             OPERACION.INSSRV     I,
             OPERACION.INSPRD     IP,
             SALES.TYSTABSRV      SRV
       WHERE SP.CODSOLOT   = S.CODSOLOT
         AND SP.CODINSSRV  = I.CODINSSRV
         AND I.CODINSSRV   = IP.CODINSSRV
         AND SP.PID        = IP.PID
         AND SRV.CODSRV    = IP.CODSRV
         AND SRV.TIPSRV    = I.TIPSRV
         AND S.COD_ID      = P_COD_ID
         AND S.CUSTOMER_ID = P_CUSTOMER_ID
         AND IP.FLGPRINC   = 0
         AND I.ESTINSSRV IN (1,2)
         AND IP.ESTINSPRD  IN (1, 2)
         AND S.ESTSOL      IN (12, 29)
         AND IP.CODEQUCOM  IS NULL;
    -- INI 3.0
    P_COD_RESP := 0;
    P_MSJ_RESP := 'SE EJECUTO EL SP: SGASS_CONS_SERV_EQU_ADI CORRECTAMENTE.';

  EXCEPTION
    WHEN OTHERS THEN
      P_COD_RESP := -1;
      P_MSJ_RESP := 'ERROR AL EJECUTAR SP SGASS_CONS_SERV_EQU_ADI: ' ||
                    TO_CHAR(SQLCODE) || ' ' || SQLERRM;
  END;


  /*'****************************************************************
  '* Nombre SP : SGASS_CONS_EQU_CABLE
  '* Proposito : Lista los Equipos de Cable.
  '* Input :   <P_COD_ID>      - Codigo de Contrato del BSCS.
               <P_CUSTOMER_ID> - Codigo del Cliente del BSCS.
  '* Output :  <P_COD_RESP>    - Codigo de Respuesta del SP.
               <P_MSJ_RESP>    - Mensaje de la Respuesta del SP.
               <P_DAT_SERV>    - Cursor con equipos de Cable.
  '* Creado por                : Team Dev
  '* Fecha de Creacion         : 25/02/2020.
  '* Actualizado por           : Team Dev
  '* Fecha de Actualizacion    : 02/03/2020
  '*****************************************************************/
  PROCEDURE SGASS_CONS_EQU_CABLE(P_COD_ID      IN OPERACION.SOLOT.COD_ID%TYPE,
                                 P_CUSTOMER_ID IN OPERACION.SOLOT.CUSTOMER_ID%TYPE,
                                 P_COD_RESP    OUT NUMBER,
                                 P_MSJ_RESP    OUT VARCHAR2,
                                 P_DAT_EQUI    OUT TCUR_EQU_CABLE) IS
  BEGIN

    /*INICIO BLOQUE DE VALIDACIONES DE DATOS*/
    IF P_COD_ID IS NULL THEN
      P_COD_RESP := -3;
      P_MSJ_RESP := 'EL CODIGO DE CONTRATO(COD_ID) ES UN CAMPO OBLIGATORIO PARA REALIZAR LA CONSULTA, FAVOR INGRESAR EL VALOR SOLICITADO.';
      RETURN;
    ELSIF P_COD_ID <= 0 THEN
      P_COD_RESP := -3;
      P_MSJ_RESP := 'EL CODIGO DE CONTRATO(COD_ID) DEBE SER MAYOR A 0, FAVOR INGRESAR EL VALOR CORRECTO.';
      RETURN;
    END IF;
    IF P_CUSTOMER_ID IS NULL THEN
      P_COD_RESP := -3;
      P_MSJ_RESP := 'EL CODIGO DE CLIENTE(CUSTOMER_ID) ES UN CAMPO OBLIGATORIO PARA REALIZAR LA CONSULTA, FAVOR INGRESAR EL VALOR SOLICITADO.';
      RETURN;
    ELSIF P_CUSTOMER_ID <= 0 THEN
      P_COD_RESP := -3;
      P_MSJ_RESP := 'EL CODIGO DE CLIENTE(CUSTOMER_ID) DEBE SER MAYOR A 0, FAVOR INGRESAR EL VALOR CORRECTO.';
      RETURN;
    END IF;
    /*FIN   BLOQUE DE VALIDACIONES DE DATOS*/

    OPEN P_DAT_EQUI FOR
      SELECT DISTINCT (CASE I.TIPSRV WHEN '0004' THEN 'Telefonia'
                                     WHEN '0006' THEN 'Internet'
                                     WHEN '0062' THEN 'Cable' END) AS NOMBRE_SERVICIO,
                      (SELECT NVL(ABREV,DSCSRV)
                         FROM SALES.TYSTABSRV
                        WHERE CODSRV = I.CODSRV)            AS DESCRIPCION_SERVICIO,
                      TI.DESCRIPCION                        AS NOMBRE_EQUIPO,
                      (SELECT DISTINCT DESCRIPCION
                         FROM SALES.CRMDD
                        WHERE CODIGON = S.TIPEQU
                          AND TIPCRMDD IN
                              (SELECT TIPCRMDD
                                 FROM SALES.TIPCRMDD
                                WHERE ABREV = 'DTHPOSTEQU')) AS MODELO_EQUIPO,
                      A.NRO_SERIE_TARJETA                    AS SERIE_EQUIPO,
                      NVL((SELECT TEC.PVTCV_DESTECNOLOGIA
                             FROM SALES.LINEA_PAQUETE LP,
                                  SALES.SGAT_PAQVTA_TECNOLOGIA TEC
                            WHERE LP.PVTCN_CODTEC = LP.PVTCN_CODTEC
                              AND LP.IDDET        = IP.IDDET
                              AND LP.CODSRV       = IP.CODSRV),'Sin Definir') AS TECNOLOGIA
        FROM OPERACION.SOLOTPTOEQU        S,
             OPERACION.SOLOTPTO           B,
             OPERACION.INSPRD             IP,
             OPERACION.TIPEQU             TI,
             ALMTABMAT                    M,
             OPERACION.TABEQUIPO_MATERIAL D,
             OPERACION.TARJETA_DECO_ASOC  A,
             OPERACION.INSSRV             I,
             OPERACION.SOLOT              SL
       WHERE S.CODSOLOT       = B.CODSOLOT
         AND B.CODSOLOT       = SL.CODSOLOT
         AND SL.CODSOLOT      = A.CODSOLOT
         AND B.CODINSSRV      = I.CODINSSRV
         AND I.CODINSSRV      = IP.CODINSSRV
         AND B.PID            = IP.PID
         AND S.TIPEQU         = TI.TIPEQU
         AND TRIM(M.CODMAT)   = TRIM(TI.CODTIPEQU)
         AND S.NUMSERIE       = D.NUMERO_SERIE
         AND A.NRO_SERIE_DECO = D.IMEI_ESN_UA
         AND D.NUMERO_SERIE   = S.NUMSERIE
         AND IP.IDDET         = S.IDDET
         AND IP.CODEQUCOM     = S.CODEQUCOM
         AND SL.COD_ID        = P_COD_ID
         AND SL.CUSTOMER_ID   = P_CUSTOMER_ID
         AND I.TIPSRV         = '0062'
         AND TI.TIPO          = 'DECODIFICADOR'
         AND D.TIPO           = 2
         AND B.TIPO           = 1
         AND S.ESTADO         != 12
         AND SL.ESTSOL        IN (12, 29)
         AND IP.ESTINSPRD     IN (1, 2)
      UNION ALL
      SELECT DISTINCT (CASE I.TIPSRV WHEN '0004' THEN 'Telefonia'
                                     WHEN '0006' THEN 'Internet'
                                     WHEN '0062' THEN 'Cable' END) AS NOMBRE_SERVICIO,
                      (SELECT NVL(ABREV,DSCSRV)
                         FROM SALES.TYSTABSRV
                        WHERE CODSRV = I.CODSRV)                 AS DESCRIPCION_SERVICIO,
                      NVL(P.MODELO,
                          NVL((SELECT A.DESMAT
                                FROM OPERACION.MAESTRO_SERIES_EQU M,
                                     ALMTABMAT                    A,
                                     OPERACION.TIPEQU             T
                               WHERE M.NROSERIE    = P.SERIAL_NUMBER
                                 AND M.COD_SAP     = A.COD_SAP
                                 AND TRIM(A.CODMAT)= TRIM(T.CODTIPEQU)),
                              (SELECT DSCEQU
                                 FROM VTAEQUCOM
                                WHERE CODEQUCOM = IP.CODEQUCOM))) AS NOMBRE_EQUIPO,
                      NVL(P.MODELO,
                          NVL((SELECT T.DESCRIPCION
                                FROM OPERACION.MAESTRO_SERIES_EQU M,
                                     ALMTABMAT                    A,
                                     OPERACION.TIPEQU             T
                               WHERE M.NROSERIE    = P.SERIAL_NUMBER
                                 AND M.COD_SAP     = A.COD_SAP
                                 AND TRIM(A.CODMAT)= TRIM(T.CODTIPEQU)),
                              (SELECT DSCEQU
                                 FROM VTAEQUCOM
                                WHERE CODEQUCOM = IP.CODEQUCOM))) AS MODELO_EQUIPO,
                      P.SERIAL_NUMBER                             AS SERIE_EQUIPO,
                      NVL((SELECT TEC.PVTCV_DESTECNOLOGIA
                             FROM SALES.LINEA_PAQUETE LP,
                                  SALES.SGAT_PAQVTA_TECNOLOGIA TEC
                            WHERE LP.PVTCN_CODTEC = LP.PVTCN_CODTEC
                              AND LP.IDDET        = IP.IDDET
                              AND LP.CODSRV       = IP.CODSRV),'Sin Definir') AS TECNOLOGIA
        FROM OPERACION.SOLOTPTO       SP,
             OPERACION.INSPRD         IP,
             OPERACION.TAB_EQUIPOS_IW P,
             OPERACION.INSSRV         I,
             OPERACION.SOLOT          S
       WHERE SP.CODSOLOT      = S.CODSOLOT
         AND S.CODSOLOT       = P.CODSOLOT
         AND SP.CODINSSRV     = I.CODINSSRV
         AND I.CODINSSRV      = IP.CODINSSRV
         AND SP.PID           = IP.PID
         AND S.COD_ID         = P_COD_ID
         AND S.CUSTOMER_ID    = P_CUSTOMER_ID
         AND I.TIPSRV         = '0062'
         AND P.TIPO_SERVICIO  = 'CTV'
         AND IP.ESTINSPRD     IN (1, 2)
         AND S.ESTSOL         IN (12, 29)
         AND IP.CODEQUCOM IS NOT NULL
      UNION ALL
      SELECT DISTINCT (CASE I.TIPSRV WHEN '0004' THEN 'Telefonia'
                                     WHEN '0006' THEN 'Internet'
                                     WHEN '0062' THEN 'Cable' END) AS NOMBRE_SERVICIO,
                      (SELECT NVL(ABREV,DSCSRV)
                         FROM SALES.TYSTABSRV
                        WHERE CODSRV = I.CODSRV)             AS DESCRIPCION_SERVICIO,
                      TI.DESCRIPCION                         AS NOMBRE_EQUIPO,
                      (SELECT DISTINCT DESCRIPCION
                         FROM SALES.CRMDD
                        WHERE CODIGON = S.TIPEQU
                          AND TIPCRMDD IN
                              (SELECT TIPCRMDD
                                 FROM SALES.TIPCRMDD
                                WHERE ABREV = 'DTHPOSTEQU')) AS MODELO_EQUIPO,
                      A.NRO_SERIE_TARJETA                    AS SERIE_EQUIPO,
                      NVL((SELECT TEC.PVTCV_DESTECNOLOGIA
                             FROM SALES.LINEA_PAQUETE LP,
                                  SALES.SGAT_PAQVTA_TECNOLOGIA TEC
                            WHERE LP.PVTCN_CODTEC = LP.PVTCN_CODTEC
                              AND LP.IDDET        = IP.IDDET
                              AND LP.CODSRV       = IP.CODSRV),'Sin Definir') AS TECNOLOGIA
        FROM OPERACION.SOLOTPTOEQU        S,
             OPERACION.SOLOTPTO           B,
             OPERACION.INSPRD             IP,
             OPERACION.SOLOT              SL,
             OPERACION.INSSRV             I,
             OPERACION.TIPEQU             TI,
             ALMTABMAT                    M,
             OPERACION.TABEQUIPO_MATERIAL D,
             OPERACION.TARJETA_DECO_ASOC  A
       WHERE S.CODSOLOT       = B.CODSOLOT
         AND B.CODSOLOT       = SL.CODSOLOT
         AND SL.CODSOLOT      = A.CODSOLOT
         AND B.CODINSSRV      = I.CODINSSRV
         AND I.CODINSSRV      = IP.CODINSSRV
         AND B.PID            = IP.PID
         AND S.TIPEQU         = TI.TIPEQU
         AND TRIM(M.CODMAT)   = TRIM(TI.CODTIPEQU)
         AND S.NUMSERIE       = D.NUMERO_SERIE
         AND B.CODINSSRV      = I.CODINSSRV
         AND I.CODINSSRV      = IP.CODINSSRV
         AND B.PID            = IP.PID
         AND A.NRO_SERIE_DECO = D.IMEI_ESN_UA
         AND D.NUMERO_SERIE   = S.NUMSERIE
         AND IP.IDDET         = S.IDDET
         AND IP.CODEQUCOM     = S.CODEQUCOM
         AND SL.COD_ID        = P_COD_ID
         AND SL.CUSTOMER_ID   = P_CUSTOMER_ID
         AND TI.TIPO          = 'DECODIFICADOR'
         AND D.TIPO           = 2
         AND B.TIPO           = 6
         AND I.TIPSRV         = '0062'
         AND S.ESTADO         != 12
         AND IP.ESTINSPRD     IN (1, 2)
         AND SL.ESTSOL        IN (12, 29)
      UNION ALL
      SELECT DISTINCT (CASE I.TIPSRV WHEN '0004' THEN 'Telefonia'
                                     WHEN '0006' THEN 'Internet'
                                     WHEN '0062' THEN 'Cable' END) AS NOMBRE_SERVICIO,
                      (SELECT NVL(ABREV,DSCSRV)
                         FROM SALES.TYSTABSRV
                        WHERE CODSRV = I.CODSRV) AS DESCRIPCION_SERVICIO,
                      A.DESMAT                   AS NOMBRE_EQUIPO,
                      T.DESCRIPCION              AS MODELO_EQUIPO,
                      SPE.NUMSERIE               AS SERIE_EQUIPO,
                      NVL((SELECT TEC.PVTCV_DESTECNOLOGIA
                             FROM SALES.LINEA_PAQUETE LP,
                                  SALES.SGAT_PAQVTA_TECNOLOGIA TEC
                            WHERE LP.PVTCN_CODTEC = LP.PVTCN_CODTEC
                              AND LP.IDDET        = IP.IDDET
                              AND LP.CODSRV       = IP.CODSRV),'Sin Definir') AS TECNOLOGIA
        FROM OPERACION.SOLOTPTOEQU SPE,
             OPERACION.SOLOTPTO    SP,
             OPERACION.SOLOT       S,
             OPERACION.INSSRV      I,
             OPERACION.INSPRD      IP,
             MAESTRO_SERIES_EQU    M,
             ALMTABMAT             A,
             TIPEQU                T
       WHERE SPE.CODSOLOT   = SP.CODSOLOT
         AND SP.CODSOLOT    = S.CODSOLOT
         AND SP.CODINSSRV   = I.CODINSSRV
         AND I.CODINSSRV    = IP.CODINSSRV
         AND SP.PID         = IP.PID
         AND M.COD_SAP      = A.COD_SAP
         AND A.CODMAT       = T.CODTIPEQU
         AND M.NROSERIE     = SPE.NUMSERIE
         AND S.COD_ID       = P_COD_ID
         AND S.CUSTOMER_ID  = P_CUSTOMER_ID
         AND I.TIPSRV       = '0062'
         AND T.TIPO         = 'DECODIFICADOR'
         AND IP.FLGPRINC    = 0
         AND SPE.ESTADO     != 12
         AND IP.ESTINSPRD   IN (1, 2)
         AND S.ESTSOL       IN (12, 29)
         AND SPE.NUMSERIE   NOT IN (SELECT SERIAL_NUMBER
                                      FROM OPERACION.TAB_EQUIPOS_IW
                                     WHERE COD_ID      = S.COD_ID
                                       AND CUSTOMER_ID = S.CUSTOMER_ID);

    P_COD_RESP := 0;
    P_MSJ_RESP := 'SE EJECUTO EL SP: SGASS_CONS_EQU_CABLE CORRECTAMENTE.';

  EXCEPTION
    WHEN OTHERS THEN
      P_COD_RESP := -1;
      P_MSJ_RESP := 'ERROR AL EJECUTAR SP SGASS_CONS_EQU_CABLE: ' ||
                    TO_CHAR(SQLCODE) || ' ' || SQLERRM;
  END;
  /* INICIO 1.0 */
  
  /*'****************************************************************
  '* Nombre SP : SGASS_CONS_VIS_TEC
  '* Proposito : Procedimiento Principal que evalua la Visita Tecnica.
  '* Input :   <P_COD_ID>      - Codigo de Contrato del BSCS.
               <P_CUSTOMER_ID> - Codigo del Cliente del BSCS.
               <P_TRAMA>       - Lista de los servicios Seleccionados desde el Front.
  '* Output :  <P_TIPTRA>      - Tipo de Trabajo Asignado por el SP
               <P_SUBTIPO>     - Sub Tipo de Trabajo Asignado por el SP
               <P_MOTOT>       - Codigo de Motot Asignado por el SP
               <P_ANOTAC>      - Tipo de Trabajo Asignado por el SP
               <P_FLG_VT>      - Flag de Visita Tecnica: 1- GEnera Visita Tecnica, 0- No Genera Visita Tecnica
               <P_COD_RESP>    - Codigo de Respuesta del SP.
               <P_MSJ_RESP>    - Mensaje de la Respuesta del SP.
  '* Creado por                : Team Dev
  '* Fecha de Creacion         : 02/03/2020.
  '* Actualizado por           : ----
  '* Fecha de Actualizacion    : ----
  '*****************************************************************/
  PROCEDURE SGASS_CONS_VIS_TEC(P_COD_ID      IN OPERACION.SOLOT.COD_ID%TYPE,
                               P_CUSTOMER_ID IN OPERACION.SOLOT.CUSTOMER_ID%TYPE,
                               P_TRAMA       IN VARCHAR2,
                               P_TIPTRA      OUT OPERACION.SOLOT.TIPTRA%TYPE,
                               P_SUBTIPO     OUT VARCHAR2,
                               P_MOTOT       OUT OPERACION.MOTOT.CODMOTOT%TYPE,
                               P_ANOTAC      OUT VARCHAR2,
                               P_FLG_VT      OUT NUMBER,
                               P_COD_RESP    OUT NUMBER,
                               P_MSJ_RESP    OUT VARCHAR2) IS

    LN_CODSOLOT     OPERACION.SOLOT.CODSOLOT%TYPE;
    LN_COD_RESP     NUMBER;
    LV_MSJ_RES      VARCHAR2(4000);
    LV_TIPO         VARCHAR2(50);
    TN_SERV         VALORES_SRV;
    LN_VAL_TIP_EQU  NUMBER;
    LN_VAL_VEL_INT  NUMBER;
    LN_FLAG_VTEC    NUMBER;
    LN_TOT_SERV_OLD NUMBER;
    LN_TOT_SERV_NEW NUMBER;
    ERROR_PROC      EXCEPTION;
    ERROR_FUNC      EXCEPTION;
    ERROR_CAMP      EXCEPTION;
  BEGIN
    P_FLG_VT := 0; -- Se inicializa vairable
    /* Inicio Validaciones Iniciales */
    IF (P_COD_ID IS NULL) OR (P_CUSTOMER_ID IS NULL) OR (P_TRAMA IS NULL) THEN
      RAISE ERROR_CAMP;
    END IF;

    /* Fin    Validaciones Iniciales */
    /* INCIO CARGA DE INFORMACION EN LA TABLA SGAT_TRS_VISITA_TECNICA */
    SGASI_TRS_VIS_TEC(P_COD_ID, P_CUSTOMER_ID, P_TRAMA, LN_COD_RESP, LV_MSJ_RES);
    IF LN_COD_RESP <> 0 THEN
      RAISE ERROR_PROC;
    END IF;
    /* INCIO CARGA DE INFORMACION EN LA TABLA SGAT_TRS_VISITA_TECNICA */

    /* INICIO CONSULTA DE SOT, TIPO DE TRABAJO Y TECNOLOGIA */
    SGASS_CONS_SOT_MAX(P_COD_ID, LN_CODSOLOT, LN_COD_RESP, LV_MSJ_RES);
    IF LN_COD_RESP <> 0 THEN
      RAISE ERROR_PROC;
    END IF;
    /* FIN CONSULTA DE SOT, TIPO DE TRABAJO Y TECNOLOGIA */

    /* INICIO CARGA INICIAL DE DATOS */
    TN_SERV         := SGAFUN_INICIA_VALORES(LN_CODSOLOT, P_COD_ID);
    LN_VAL_TIP_EQU  := SGAFUN_VAL_TIPDECO(LN_CODSOLOT, P_COD_ID);
    LN_TOT_SERV_OLD := TN_SERV.LN_VAL_INT_OLD + TN_SERV.LN_VAL_TLF_OLD + TN_SERV.LN_VAL_CTV_OLD;
    LN_TOT_SERV_NEW := TN_SERV.LN_VAL_INT_NEW + TN_SERV.LN_VAL_TLF_NEW + TN_SERV.LN_VAL_CTV_NEW;
    /* FIN    CARGA INICIAL DE DATOS */

    /* INICIO MEDICION DE VELOCIDAD DE INTERNET */
    IF TN_SERV.LN_VAL_INT_OLD != 0 AND TN_SERV.LN_VAL_INT_NEW != 0 THEN
      LN_FLAG_VTEC := OPERACION.PQ_SGA_JANUS.F_GET_CONSTANTE_CONF('VAL_VISITA_TEC');
      IF LN_FLAG_VTEC = 1 THEN
        CASE
          WHEN TN_SERV.LN_TEC_INT_NEW = 'HFC' THEN
            SGASS_VELOCIDAD_HFC(P_COD_ID, LN_CODSOLOT, LN_VAL_VEL_INT, LN_COD_RESP, LV_MSJ_RES);
            --'LTE_SIAC_CPLAN'
            IF LN_VAL_VEL_INT < 0 THEN
              RAISE ERROR_PROC;
            END IF;
          WHEN TN_SERV.LN_TEC_INT_NEW = 'LTE' THEN
            SGASS_VELOCIDAD_LTE(P_COD_ID, LN_CODSOLOT, LN_VAL_VEL_INT, LN_COD_RESP, LV_MSJ_RES);
            IF LN_VAL_VEL_INT < 0 THEN
              RAISE ERROR_PROC;
            END IF;
          ELSE
            SGASS_VELOCIDAD_HFC(P_COD_ID, LN_CODSOLOT, LN_VAL_VEL_INT, LN_COD_RESP, LV_MSJ_RES);
            IF LN_VAL_VEL_INT < 0 THEN
              RAISE ERROR_PROC;
            END IF;
        END CASE;
      END IF;
    END IF;
    /* FIN    MEDICION DE VELOCIDAD DE INTERNET */

    /* Inicio Proceso Principal de Verificacion de Visita Tecnica */
    IF LN_TOT_SERV_OLD < LN_TOT_SERV_NEW THEN
      -- Servicios y Equipos nuevos Mayorea a Servicios y Equipos Actuales
      P_FLG_VT := 1;
      GOTO SALTO;
    ELSIF LN_TOT_SERV_OLD > LN_TOT_SERV_NEW THEN
      -- Servicios y Equipos Actuales Mayorea a Servicios y Equipos Nuevos
      IF LN_TOT_SERV_OLD >= 3 THEN
        -- Validacion de Servicios de Cable
        IF TN_SERV.LN_CNT_CTV_NEW > 0 AND TN_SERV.LN_VAL_INT_NEW > 0 THEN
          IF (TN_SERV.LN_CNT_CTV_OLD <> TN_SERV.LN_CNT_CTV_NEW) OR LN_VAL_TIP_EQU > 0 THEN
            P_FLG_VT := 1;
            GOTO SALTO;
          ELSE
            P_FLG_VT := 0;
          END IF;
          -- GOTO SALTO;
        END IF;


        IF TN_SERV.LN_CNT_CTV_NEW > 0 AND TN_SERV.LN_VAL_INT_NEW > 0 THEN
          P_FLG_VT := 0;
          IF TN_SERV.LN_CNT_CTV_OLD <> TN_SERV.LN_CNT_CTV_NEW OR LN_VAL_TIP_EQU > 0 THEN
            P_FLG_VT := 1;
          ELSIF TN_SERV.LN_CNT_CTV_OLD = TN_SERV.LN_CNT_CTV_NEW AND LN_VAL_TIP_EQU = 0 AND TN_SERV.LN_VAL_TLF_OLD = 1 THEN
            IF SGAFUN_VAL_RECUPERABLE(LN_CODSOLOT, CV_TELEFONIA) = 1 THEN
              P_FLG_VT := 1;
            ELSE
              P_FLG_VT := 0;
            END IF;
          ELSE
            P_FLG_VT := 0;
          END IF;
          GOTO SALTO;
        END IF;

        IF TN_SERV.LN_VAL_INT_NEW > 0 AND TN_SERV.LN_VAL_TLF_OLD > 0 THEN
          IF SGAFUN_VAL_RECUPERABLE(LN_CODSOLOT, CV_CABLE) = 1 THEN
            P_FLG_VT := 1;
          ELSE
            P_FLG_VT := 0;
          END IF;
          GOTO SALTO;
        END IF;

        IF TN_SERV.LN_CNT_CTV_NEW > 0 THEN
          IF SGAFUN_VAL_RECUPERABLE(LN_CODSOLOT, CV_INTERNET) = 1 THEN
            P_FLG_VT := 1;
          ELSE
            P_FLG_VT := 0;
          END IF;
          GOTO SALTO;
        END IF;

        IF TN_SERV.LN_VAL_INT_NEW > 0 THEN
          IF SGAFUN_VAL_RECUPERABLE(LN_CODSOLOT, CV_CABLE) = 1 THEN
            P_FLG_VT := 1;
          ELSE
            P_FLG_VT := 0;
          END IF;
          GOTO SALTO;
        END IF;

        IF TN_SERV.LN_VAL_TLF_NEW != 0 THEN
          IF SGAFUN_VAL_RECUPERABLE(LN_CODSOLOT, CV_CABLE) = 1 OR SGAFUN_VAL_RECUPERABLE(LN_CODSOLOT, CV_INTERNET) = 1 THEN
            P_FLG_VT := 1;
          ELSE
            P_FLG_VT := 0;
          END IF;
        END IF;
        GOTO SALTO;
      END IF;

      IF TN_SERV.LN_VAL_CTV_OLD > 0 AND TN_SERV.LN_VAL_INT_OLD > 0 THEN
        IF TN_SERV.LN_VAL_TLF_NEW > 0 OR TN_SERV.LN_VAL_INT_NEW > 0 THEN
          IF SGAFUN_VAL_RECUPERABLE(LN_CODSOLOT, CV_CABLE) = 1 THEN
            P_FLG_VT := 1;
          ELSE
            P_FLG_VT := 0;
          END IF;
          GOTO SALTO;
        END IF;

        IF TN_SERV.LN_VAL_CTV_NEW > 0 THEN
          IF SGAFUN_VAL_RECUPERABLE(LN_CODSOLOT, CV_INTERNET) = 1 THEN
            P_FLG_VT := 1;
          ELSE
            P_FLG_VT := 0;
          END IF;
        END IF;
        GOTO SALTO;
      END IF;

      IF TN_SERV.LN_VAL_CTV_OLD > 0 AND TN_SERV.LN_VAL_TLF_OLD > 0 THEN
        IF TN_SERV.LN_VAL_TLF_NEW != 0 OR TN_SERV.LN_VAL_INT_NEW != 0 THEN
          IF SGAFUN_VAL_RECUPERABLE(LN_CODSOLOT, CV_CABLE) = 1 THEN
            P_FLG_VT := 1;
          ELSE
            P_FLG_VT := 0;
          END IF;
          GOTO SALTO;
        END IF;

        IF TN_SERV.LN_VAL_CTV_NEW != 0 THEN
          IF SGAFUN_VAL_RECUPERABLE(LN_CODSOLOT, CV_INTERNET) = 1 THEN
            P_FLG_VT := 1;
          ELSE
            P_FLG_VT := 0;
          END IF;
          GOTO SALTO;
        END IF;
      END IF;

      IF TN_SERV.LN_VAL_INT_OLD != 0 AND TN_SERV.LN_VAL_TLF_OLD != 0 THEN
        IF TN_SERV.LN_VAL_CTV_NEW != 0 THEN
          IF SGAFUN_VAL_RECUPERABLE(LN_CODSOLOT, CV_INTERNET) = 1 THEN
            P_FLG_VT := 1;
          ELSE
            P_FLG_VT := 0;
          END IF;
          GOTO SALTO;
        END IF;
        IF TN_SERV.LN_VAL_INT_NEW != 0 THEN
          IF SGAFUN_VAL_RECUPERABLE(LN_CODSOLOT, CV_TELEFONIA) = 1 THEN
            P_FLG_VT := 1;
          ELSE
            P_FLG_VT := 0;
          END IF;
          GOTO SALTO;
        END IF;
        IF TN_SERV.LN_VAL_TLF_NEW != 0 THEN
          P_FLG_VT := 0;
          GOTO SALTO;
        END IF;
      END IF;
    ELSIF LN_TOT_SERV_OLD = LN_TOT_SERV_NEW AND LN_TOT_SERV_OLD = 3 THEN
      -- Servicios y Equipos Actuales Mayorea a Servicios y Equipos Nuevos, 3play
      IF LN_VAL_VEL_INT <> 2 THEN -- cambio 0
        P_FLG_VT := 1;
      ELSIF TN_SERV.LN_CNT_CTV_OLD <> TN_SERV.LN_CNT_CTV_NEW OR LN_VAL_TIP_EQU > 0 THEN
        P_FLG_VT := 1;
      ELSE
        P_FLG_VT := 0;
      END IF;
      GOTO SALTO;
    ELSIF LN_TOT_SERV_OLD = LN_TOT_SERV_NEW AND LN_TOT_SERV_OLD = 2 THEN
      -- Servicios y Equipos Actuales Mayorea a Servicios y Equipos Nuevos, 2 play
      IF (TN_SERV.LN_VAL_CTV_NEW > 0 AND TN_SERV.LN_VAL_INT_NEW > 0) AND (TN_SERV.LN_VAL_CTV_OLD > 0 AND TN_SERV.LN_VAL_INT_OLD > 0) THEN
        IF LN_VAL_VEL_INT <> 0 THEN -- cambio 0
          P_FLG_VT := 1;
        ELSIF TN_SERV.LN_CNT_CTV_OLD <> TN_SERV.LN_CNT_CTV_NEW OR LN_VAL_TIP_EQU > 0 THEN
          P_FLG_VT := 1;
        ELSE
          P_FLG_VT := 0;
        END IF;
        GOTO SALTO;
      END IF;
      IF (TN_SERV.LN_VAL_CTV_NEW > 0 AND TN_SERV.LN_VAL_TLF_NEW > 0) AND
         (TN_SERV.LN_VAL_CTV_OLD > 0 AND TN_SERV.LN_VAL_TLF_OLD > 0) THEN
        IF TN_SERV.LN_CNT_CTV_OLD <> TN_SERV.LN_CNT_CTV_NEW OR
           LN_VAL_TIP_EQU > 0 THEN
          P_FLG_VT := 1;
        ELSE
          P_FLG_VT := 0;
        END IF;
        GOTO SALTO;
      END IF;
      IF (TN_SERV.LN_VAL_INT_NEW > 0 AND TN_SERV.LN_VAL_TLF_NEW > 0) AND (TN_SERV.LN_VAL_INT_OLD > 0 AND TN_SERV.LN_VAL_TLF_OLD > 0) THEN
        IF LN_VAL_VEL_INT > 0 THEN
          P_FLG_VT := 1;
        ELSE
          P_FLG_VT := 0;
        END IF;
        GOTO SALTO;
      END IF;
    ELSIF LN_TOT_SERV_OLD = LN_TOT_SERV_NEW AND LN_TOT_SERV_OLD = 1 THEN
      -- Servicios y Equipos Actuales Mayorea a Servicios y Equipos Nuevos, 1 play
      -- Inicio Validacion Servicios de Internet
      IF TN_SERV.LN_VAL_INT_NEW > 0 AND TN_SERV.LN_VAL_INT_NEW = TN_SERV.LN_VAL_INT_OLD THEN
        IF LN_VAL_VEL_INT <> 2 THEN -- cambio 0
          P_FLG_VT := 1;
        ELSE
          P_FLG_VT := 0;
        END IF;
        GOTO SALTO;
      END IF;
      -- Fin    Validacion Servicios de Internet
      -- Inicio Validacion Servicios de Telefonia
      IF TN_SERV.LN_VAL_TLF_NEW > 0 AND TN_SERV.LN_VAL_TLF_NEW = TN_SERV.LN_VAL_TLF_OLD THEN
        P_FLG_VT := 0;
        GOTO SALTO;
      END IF;
      IF TN_SERV.LN_VAL_TLF_NEW > 0 AND TN_SERV.LN_VAL_TLF_OLD = 0 THEN
        P_FLG_VT := 1;
        GOTO SALTO;
      END IF;
      -- Fin    Validacion Servicios de Telefonia
      -- Inicio Validacion Servicios de Cable
      IF TN_SERV.LN_VAL_CTV_NEW > 0 AND TN_SERV.LN_VAL_CTV_NEW = TN_SERV.LN_VAL_CTV_OLD THEN
        IF (TN_SERV.LN_CNT_CTV_OLD <> TN_SERV.LN_CNT_CTV_NEW OR LN_VAL_TIP_EQU > 0) AND
           (TN_SERV.LN_CNT_CTV_OLD > 0 AND TN_SERV.LN_CNT_CTV_NEW > 0) THEN
          P_FLG_VT := 1;
        ELSE
          P_FLG_VT := 0;
        END IF;
        GOTO SALTO;
      END IF;
      IF TN_SERV.LN_VAL_CTV_NEW > 0 AND TN_SERV.LN_VAL_CTV_OLD = 0 THEN
        P_FLG_VT := 1;
        GOTO SALTO;
      ELSE
        P_FLG_VT := 0;
      END IF;
      -- Fin    Validacion Servicios de Cable
    END IF;
    /* Fin    Proceso Principal de Verificacion de Visita Tecnica */
    <<SALTO>>
    LV_TIPO    := SGAFUN_GET_TIPO(LN_CODSOLOT);
    P_TIPTRA   := SGAFUN_GET_TIPTRA(LN_CODSOLOT);
    P_MOTOT    := SGAFUN_GET_CODMOTOT(LV_TIPO, P_FLG_VT);
    IF P_FLG_VT = 1 THEN
      P_SUBTIPO  := SGAFUN_GET_SUBTIPO(LN_CODSOLOT, P_COD_ID, P_TIPTRA);
      P_ANOTAC   := SGAFUN_GET_ANOTACION(LN_CODSOLOT, P_COD_ID);
    END IF;
    P_COD_RESP := 0;
    P_MSJ_RESP := 'Se Ejecuto el SP SGASS_CONS_VIS_TEC Correctamente.';
  EXCEPTION
    WHEN ERROR_CAMP THEN
      P_FLG_VT   := 0;
      P_COD_RESP := -2;
      P_MSJ_RESP := 'Los campos (COD_ID|CUSTOMER_ID|TRAMA) son Obligatorios, favor ingresar todos los campos para Continuar con el Proceso...';
    WHEN ERROR_PROC THEN
      P_FLG_VT   := 0;
      P_COD_RESP := LN_COD_RESP;
      P_MSJ_RESP := LV_MSJ_RES;
    WHEN ERROR_FUNC THEN
      P_FLG_VT   := 0;
      P_COD_RESP := LN_COD_RESP;
      P_MSJ_RESP := LV_MSJ_RES;
    WHEN OTHERS THEN
      P_FLG_VT   := 0;
      P_COD_RESP := -1;
      LV_MSJ_RES := $$PLSQL_UNIT || '.SGASS_CONS_VIS_TEC: ';
      LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(-) P_COD_ID =        ' || TO_CHAR(P_COD_ID);
      LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(-) P_CUSTOMER_ID =   ' || TO_CHAR(P_CUSTOMER_ID);
      LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(-) P_TRAMA =         ' || TO_CHAR(P_TRAMA);
      LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(*) Codigo de Error:  ' || TO_CHAR(SQLCODE);
      LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(*) Linea de Error:   ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(*) Mensaje de Error: ' || SQLERRM;
      P_COD_RESP := -1;
      P_MSJ_RESP := LV_MSJ_RES;
  END;

  /*'****************************************************************
  '* Nombre SP : SGASS_CONS_SOT_MAX
  '* Proposito : Procedimiento que devuelve  la Ultima Sot Generada Valida de acuerdo a los tipos de trabajo configurados en tipos y estados 
  '* Input :   <P_COD_ID>      - Codigo de Contrato del BSCS.
  '* Output :  <P_CODSOLOT>    - Codigo de SOLOT
               <P_COD_RESP>    - Codigo de Respuesta del SP.
               <P_MSJ_RESP>    - Mensaje de la Respuesta del SP.
  '* Creado por                : Team Dev
  '* Fecha de Creacion         : 02/03/2020.
  '* Actualizado por           : ----
  '* Fecha de Actualizacion    : ----
  '*****************************************************************/
  PROCEDURE SGASS_CONS_SOT_MAX(P_COD_ID   IN OPERACION.SOLOT.COD_ID%TYPE,
                               P_CODSOLOT OUT OPERACION.SOLOT.CODSOLOT%TYPE,
                               P_COD_RESP OUT NUMBER,
                               P_MSJ_RESP OUT VARCHAR2) IS
    LV_MSJ_RES VARCHAR2(4000);
  BEGIN
    /* Inicio Consulta de SOT */
    SELECT NVL(MAX(S.CODSOLOT), 0)
      INTO P_CODSOLOT
      FROM OPERACION.SOLOT    S,
           OPERACION.SOLOTPTO PTO,
           OPERACION.INSSRV   INS
     WHERE S.CODSOLOT    = PTO.CODSOLOT
       AND PTO.CODINSSRV = INS.CODINSSRV
       AND INS.ESTINSSRV IN (1, 2, 3)
       AND EXISTS (SELECT 1
                     FROM OPERACION.TIPOPEDD T,
                          OPERACION.OPEDD O
                    WHERE T.TIPOPEDD    = O.TIPOPEDD
                      AND T.ABREV       = 'CONFSERVADICIONAL'
                      AND O.ABREVIACION = 'ESTSOL_MAXALTA'
                      AND O.CODIGON     = S.ESTSOL)
       AND EXISTS (SELECT 1
                     FROM OPERACION.TIPOPEDD T,
                          OPERACION.OPEDD O
                    WHERE T.TIPOPEDD = O.TIPOPEDD
                      AND T.ABREV    = 'TIPREGCONTIWSGABSCS'
                      AND O.CODIGON  = S.TIPTRA)
       AND S.COD_ID = P_COD_ID;
    /* Fin Consulta de SOT */
    P_COD_RESP := 0;
    P_MSJ_RESP := 'Se Ejecuto el SP SGASS_CONS_SOT_MAX Correctamente.';
  EXCEPTION
    WHEN OTHERS THEN
      P_CODSOLOT := 0;
      LV_MSJ_RES := $$PLSQL_UNIT || '.SGASS_CONS_SOT_MAX: ';
      LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(-) P_COD_ID =        ' || TO_CHAR(P_COD_ID);
      LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(*) Codigo de Error:  ' || TO_CHAR(SQLCODE);
      LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(*) Linea de Error:   ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(*) Mensaje de Error: ' || SQLERRM;
      P_COD_RESP := -1;
      P_MSJ_RESP := LV_MSJ_RES;
  END;

  /*'****************************************************************
  '* Nombre SP : SGASS_CONS_SUBTIPO
  '* Proposito : 
  '* Input :   <P_TIPTRABAJO>   - Tipo de Trabajo.
               <P_FLAG_CE>      - flag
  '* Output :  <P_CUR_SUBTIP>   - Datos del Sub tipo
               <P_COD_RESP>     - Codigo de Respuesta del SP.
               <P_MSJ_RESP>     - Mensaje de la Respuesta del SP.
  '* Creado por                : Team Dev
  '* Fecha de Creacion         : 02/03/2020.
  '* Actualizado por           : ----
  '* Fecha de Actualizacion    : ----
  '*****************************************************************/
  PROCEDURE SGASS_CONS_SUBTIPO(P_TIPTRABAJO IN NUMBER,
                               P_FLAG_CE    IN NUMBER,
                               P_CUR_SUBTIP OUT SYS_REFCURSOR,
                               P_COD_RESP   OUT NUMBER,
                               P_MSJ_RESP   OUT VARCHAR2) IS

    LN_RESP          NUMBER := 0;
    LV_RESP          VARCHAR2(3000) := 'EJECUCION DE SGASS_CONS_SUBTIPO REALIZADA CON EXITO';
    LN_TIPO_ORDEN    TIPTRABAJO.ID_TIPO_ORDEN%TYPE;
    LN_TIPO_ORDEN_CE TIPTRABAJO.ID_TIPO_ORDEN_CE%TYPE;
  BEGIN
    BEGIN
      SELECT ID_TIPO_ORDEN_CE, ID_TIPO_ORDEN
        INTO LN_TIPO_ORDEN_CE, LN_TIPO_ORDEN
        FROM TIPTRABAJO
       WHERE TIPTRA = P_TIPTRABAJO;

      IF P_FLAG_CE > 0 THEN
        IF LN_TIPO_ORDEN_CE IS NULL THEN
          LN_RESP := -1;
          LV_RESP := 'SGASS_CONS_SUBTIPO: NO SE ENCONTRO EL TIPO DE ORDEN CE';
        END IF;
        OPEN P_CUR_SUBTIP FOR
          SELECT COD_SUBTIPO_ORDEN, DESCRIPCION
            FROM OPERACION.SUBTIPO_ORDEN_ADC
           WHERE ID_TIPO_ORDEN = LN_TIPO_ORDEN_CE
           ORDER BY DESCRIPCION;
      ELSE
        IF LN_TIPO_ORDEN IS NULL THEN
          LN_RESP := -1;
          LV_RESP := 'SGASS_CONS_SUBTIPO: NO SE ENCONTRO EL TIPO DE ORDEN';
        END IF;
        OPEN P_CUR_SUBTIP FOR
          SELECT COD_SUBTIPO_ORDEN, DESCRIPCION
            FROM OPERACION.SUBTIPO_ORDEN_ADC
           WHERE ID_TIPO_ORDEN = LN_TIPO_ORDEN
           ORDER BY DESCRIPCION;
      END IF;
    EXCEPTION
      WHEN OTHERS THEN
        LN_RESP := -1;
        LV_RESP := 'SGASS_CONS_SUBTIPO: EL TIPTRABAJO NO EXISTE';
    END;
    P_COD_RESP := LN_RESP;
    P_MSJ_RESP := LV_RESP;
  END;

  /*'****************************************************************
  '* Nombre SP : SGASS_VELOCIDAD_HFC
  '* Proposito : El SP se encarga de Validar de acuerdo a las Velocidades si la trama de Internet Requiere Visita Tecnica.
  '* Input :   <P_COD_ID>       - Codigo de Contrato del BSCS.
               <P_CODSOLOT>     - Codigo de SOLOT
  '* Output :  <P_VEL_INT>      - Flag Indica la Velocidad
               <P_COD_RESP>     - Codigo de Respuesta del SP.
               <P_MSJ_RESP>     - Mensaje de la Respuesta del SP.
  '* Creado por                : Team Dev
  '* Fecha de Creacion         : 02/03/2020.
  '* Actualizado por           : ----
  '* Fecha de Actualizacion    : ----
  '*****************************************************************/  
  PROCEDURE SGASS_VELOCIDAD_HFC(P_COD_ID   OPERACION.SOLOT.COD_ID%TYPE,
                                P_CODSOLOT OPERACION.SOLOT.CODSOLOT%TYPE,
                                P_VEL_INT  OUT NUMBER,
                                P_COD_RESP OUT NUMBER,
                                P_MSJ_RESP OUT VARCHAR2) IS
    LN_PORTADORA     NUMBER;
    LN_CONVERT_MB_KB NUMBER := 0;
    LN_VELOCIDAD     SALES.TYSTABSRV.BANWID%TYPE;
    LV_MSJ_RES       VARCHAR2(4000);
  BEGIN
    LN_CONVERT_MB_KB := SGAFUN_CONVERT_MB_KB('CON_MB_KB');

    /*Inicio Consulta de Nueva Velocidad */
    SELECT DISTINCT SER.BANWID
      INTO LN_VELOCIDAD
      FROM SALES.TYSTABSRV SER,
           OPERACION.SGAT_TRS_VISITA_TECNICA VT
     WHERE SER.CODSRV       = VT.TRSV_CODSRV
       AND VT.TRSV_TIPO_SRV = CV_INT
       AND VT.TRSN_COD_ID   = P_COD_ID;
    /*Fin   Consulta de Nueva Velocidad */

    LN_VELOCIDAD := LN_VELOCIDAD / LN_CONVERT_MB_KB;

    /*Inicio Consulta de Id_Portadora */
    SELECT DISTINCT V.SGAN_ID_PORTADORA
      INTO LN_PORTADORA
      FROM (SELECT DISTINCT IP.PID, IP.CODEQUCOM, IP.CANTIDAD
              FROM OPERACION.SOLOT    S,
                   OPERACION.SOLOTPTO SP,
                   OPERACION.INSPRD   IP,
                   OPERACION.INSSRV   IV
             WHERE S.CODSOLOT   = SP.CODSOLOT
               AND SP.CODINSSRV = IV.CODINSSRV
               AND IP.CODINSSRV = IV.CODINSSRV
               AND S.CODSOLOT   = P_CODSOLOT) X,
           SALES.VTAEQUCOM                    V,
           OPERACION.EQUCOMXOPE               EQ,
           OPERACION.TIPEQU                   TE
     WHERE NVL(X.CODEQUCOM, 'X') != 'X'
       AND X.CODEQUCOM  = V.CODEQUCOM
       AND V.CODEQUCOM  = EQ.CODEQUCOM
       AND EQ.CODTIPEQU = TE.CODTIPEQU
       AND TE.TIPO      IN ('EMTA', 'CPE')
       AND V.TIP_EQ     IS NOT NULL;
    /*Fin   Consulta de Id_Portadora */

    P_VEL_INT  := SGAFUN_VAL_MATRIZ_CP(LN_VELOCIDAD, LN_PORTADORA);
    P_COD_RESP := 0;
    P_MSJ_RESP := 'Se Ejecuto el SP SGASS_VELOCIDAD_HFC Correctamente.';
  EXCEPTION
    WHEN OTHERS THEN
      LV_MSJ_RES := $$PLSQL_UNIT || '.SGASS_VELOCIDAD_HFC: ';
      LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(-) P_COD_ID =        ' || TO_CHAR(P_COD_ID);
      LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(-) P_CODSOLOT =      ' || TO_CHAR(P_CODSOLOT);
      LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(*) Codigo de Error:  ' || TO_CHAR(SQLCODE);
      LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(*) Linea de Error:   ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(*) Mensaje de Error: ' || SQLERRM;
      P_VEL_INT  := -1;
      P_COD_RESP := -1;
      P_MSJ_RESP := LV_MSJ_RES;
  END;

  /*'****************************************************************
  '* Nombre SP : SGASS_VELOCIDAD_LTE
  '* Proposito : El SP se encarga de Validar de acuerdo a las Velocidades si la trama de Internet Requiere Visita Tecnica.
  '* Input :   <P_COD_ID>       - Codigo de Contrato del BSCS.
               <P_CODSOLOT>     - Codigo de SOLOT
  '* Output :  <P_VEL_INT>      - Flag Indica la Velocidad
               <P_COD_RESP>     - Codigo de Respuesta del SP.
               <P_MSJ_RESP>     - Mensaje de la Respuesta del SP.
  '* Creado por                : Team Dev
  '* Fecha de Creacion         : 02/03/2020.
  '* Actualizado por           : ----
  '* Fecha de Actualizacion    : ----
  '*****************************************************************/ 
  PROCEDURE SGASS_VELOCIDAD_LTE(P_COD_ID   OPERACION.SOLOT.COD_ID%TYPE,
                                P_CODSOLOT OPERACION.SOLOT.CODSOLOT%TYPE,
                                P_VEL_INT  OUT NUMBER,
                                P_COD_RESP OUT NUMBER,
                                P_MSJ_RESP OUT VARCHAR2) IS
    LV_VEL_CONF      NUMBER;
    LV_VAL_CFG       NUMBER;
    LN_VELOCIDAD     NUMBER;
    LV_CODEQUCOM     SALES.VTAEQUCOM.CODEQUCOM%TYPE;
    LV_CODEQUCOM_NEW SALES.VTAEQUCOM.CODEQUCOM%TYPE;
    LV_CODSRV        OPERACION.SGAT_TRS_VISITA_TECNICA.TRSV_CODSRV%TYPE;
    LN_TIPO_MAT_ANT  SALES.VTAEQUCOM.TIP_EQ%TYPE;
    LN_TIPO_MAT_NEW  SALES.VTAEQUCOM.TIP_EQ%TYPE;
    LN_CONVERT_MB_KB NUMBER;
    LN_VELOCIDAD_ACT NUMBER;
    EXC_PROC_ERR     EXCEPTION;
    EXC_PROC_EXT     EXCEPTION;
    LN_COD_RESP      NUMBER;
    LV_MSJ_RES       VARCHAR2(4000);
  BEGIN
    LV_VEL_CONF := OPERACION.PQ_SGA_JANUS.F_GET_CONSTANTE_CONF('CVELINT_VISITEC');
    LV_VAL_CFG  := OPERACION.PQ_VISITA_SGA_SIAC.SGAFUN_VAL_CFG_VAL('CVEC_INT');

    /* Inicio Consulta Tabla de Transacciones */
    BEGIN
      SELECT S.TRSV_CODEQUCOM, S.TRSV_CODSRV
        INTO lV_CODEQUCOM_NEW, LV_CODSRV
        FROM OPERACION.SGAT_TRS_VISITA_TECNICA S
       WHERE S.TRSN_COD_ID   = P_COD_ID
         AND S.TRSV_TIPO_SRV = CV_INT;
    EXCEPTION
      WHEN OTHERS THEN
        LN_COD_RESP := -2;
        LV_MSJ_RES  := 'Error al Ejecutar la Consulta a la Tabla OPERACION.SGAT_TRS_VISITA_TECNICA: ';
        RAISE EXC_PROC_ERR;
    END;
    /* Fin Consulta Tabla de Transacciones */

    /* Inicio Proceso Principal */
    IF LV_VAL_CFG = 1 THEN
      /* Inicio Consulta de Velocidad Actual */
      BEGIN
        SELECT DISTINCT A.BANWID
          INTO LN_VELOCIDAD_ACT
          FROM OPERACION.INSSRV I,
               SALES.TYSTABSRV  A,
               OPERACION.INSPRD IP
         WHERE A.CODSRV    = IP.CODSRV
           AND I.CODINSSRV = IP.CODINSSRV
           AND I.CODINSSRV IN (SELECT DISTINCT S.CODINSSRV
                                 FROM OPERACION.SOLOTPTO S
                                WHERE S.CODSOLOT = P_CODSOLOT)
           AND IP.FLGPRINC = 1
           AND A.TIPSRV    = CV_INTERNET
           AND IP.ESTINSPRD IN (1, 2);
      EXCEPTION
        WHEN OTHERS THEN
          LN_COD_RESP := -2;
          LV_MSJ_RES  := 'Error al Ejecutar la Consultas para obtener la Velocidad Actual.';
          RAISE EXC_PROC_ERR;
      END;
      /* Fin   Consulta de Velocidad Actual */

      /* Inicio Consulta de Nueva Velocidad */
      BEGIN
        SELECT DISTINCT SER.BANWID
          INTO LN_VELOCIDAD
          FROM SALES.TYSTABSRV SER
         WHERE SER.CODSRV = LV_CODSRV;
      EXCEPTION
        WHEN OTHERS THEN
          LN_COD_RESP := -2;
          LV_MSJ_RES  := 'Error al Ejecutar la Consultas para obtener la Nueva Velocidad.';
          RAISE EXC_PROC_ERR;
      END;
      /* Fin   Consulta de Nueva Velocidad */

      IF LN_VELOCIDAD <= LN_VELOCIDAD_ACT THEN
        P_VEL_INT := 0;
        GOTO SALTO;
      ELSE
        /* Inicio Consulta de Codigo de Equipo Actual */
        BEGIN
          SELECT DISTINCT V.CODEQUCOM
            INTO LV_CODEQUCOM
            FROM (SELECT DISTINCT IP.PID, IP.CODEQUCOM, IP.CANTIDAD
                    FROM OPERACION.SOLOT    S,
                         OPERACION.SOLOTPTO SP,
                         OPERACION.INSPRD   IP,
                         OPERACION.INSSRV   IV
                   WHERE S.CODSOLOT   = SP.CODSOLOT
                     AND SP.CODINSSRV = IV.CODINSSRV
                     AND IP.CODINSSRV = IV.CODINSSRV
                     AND S.CODSOLOT   = P_CODSOLOT) X,
                 SALES.VTAEQUCOM                    V,
                 OPERACION.EQUCOMXOPE               EQ,
                 OPERACION.TIPEQU                   TE
           WHERE NVL(X.CODEQUCOM, 'X') != 'X'
             AND X.CODEQUCOM      = V.CODEQUCOM
             AND V.CODEQUCOM      = EQ.CODEQUCOM
             AND EQ.CODTIPEQU     = TE.CODTIPEQU
             AND TE.TIPO          IN ('EMTA', 'CPE')
             AND V.TIP_EQ         IS NOT NULL;
        EXCEPTION
          WHEN OTHERS THEN
            LN_COD_RESP := -2;
            LV_MSJ_RES  := 'Error al Ejecutar la Consultas para obtener el codigo de equipo actual.';
            RAISE EXC_PROC_ERR;
        END;
        /* Fin   Consulta de Codigo de Equipo Actual */

        IF LV_CODEQUCOM_NEW = LV_CODEQUCOM THEN
          P_VEL_INT := 0;
          GOTO SALTO;
        END IF;
        IF SGAFUN_VAL_CFG_CODEQUCOM(LV_CODEQUCOM_NEW, LV_CODEQUCOM) = 1 THEN
          P_VEL_INT := 1;
          GOTO SALTO;
        ELSE
          P_VEL_INT := 0;
          GOTO SALTO;
        END IF;
      END IF;
    ELSE
      /* Inicio Consulta de Tipo de Material Actual */
      BEGIN
        SELECT DISTINCT V.TIP_EQ
          INTO LN_TIPO_MAT_ANT
          FROM (SELECT DISTINCT IP.PID, IP.CODEQUCOM, IP.CANTIDAD
                  FROM OPERACION.SOLOT    S,
                       OPERACION.SOLOTPTO SP,
                       OPERACION.INSPRD   IP,
                       OPERACION.INSSRV   IV
                 WHERE S.CODSOLOT   = SP.CODSOLOT
                   AND SP.CODINSSRV = IV.CODINSSRV
                   AND IP.CODINSSRV = IV.CODINSSRV
                   AND S.CODSOLOT   = P_CODSOLOT) X,
               SALES.VTAEQUCOM                    V,
               OPERACION.EQUCOMXOPE               EQ,
               OPERACION.TIPEQU                   TE
         WHERE NVL(X.CODEQUCOM, 'X') != 'X'
           AND X.CODEQUCOM  = V.CODEQUCOM
           AND V.CODEQUCOM  = EQ.CODEQUCOM
           AND EQ.CODTIPEQU = TE.CODTIPEQU
           AND TE.TIPO      IN ('EMTA', 'CPE')
           AND V.TIP_EQ     IS NOT NULL;
      EXCEPTION
        WHEN OTHERS THEN
          LN_COD_RESP := -2;
          LV_MSJ_RES  := 'Error al Ejecutar la Consultas del Tipo de Material Actual.';
          RAISE EXC_PROC_ERR;
      END;
      /* Fin    Consulta de Tipo de Material Actual */
      /* Inicio Consulta de Tipo de Material Nuevo */
      BEGIN
        SELECT DISTINCT V.TIP_EQ
          INTO LN_TIPO_MAT_NEW
          FROM SALES.VTAEQUCOM V
         WHERE V.CODEQUCOM = LV_CODEQUCOM_NEW;
      EXCEPTION
        WHEN OTHERS THEN
          LN_COD_RESP := -2;
          LV_MSJ_RES  := 'Error al Ejecutar la Consultas del Tipo de Material Nuevo.';
          RAISE EXC_PROC_ERR;
      END;
      /* Fin    Consulta de Tipo de Material Nuevo */
      /* Inicio Consulta de Nueva Velocidad */
      BEGIN
        SELECT DISTINCT SER.BANWID
          INTO LN_VELOCIDAD
          FROM SALES.TYSTABSRV SER
         WHERE SER.CODSRV = LV_CODSRV;
      EXCEPTION
        WHEN OTHERS THEN
          LN_COD_RESP := -2;
          LV_MSJ_RES  := 'Error al Ejecutar la Consultas para obtener la Nueva Velocidad.';
          RAISE EXC_PROC_ERR;
      END;
      /* Inicio Consulta de Nueva Velocidad  */

      LN_CONVERT_MB_KB := SGAFUN_CONVERT_MB_KB('CON_MB_KB');
      IF LN_CONVERT_MB_KB = 0 OR LN_CONVERT_MB_KB IS NULL THEN
        LN_COD_RESP := -2;
        LV_MSJ_RES  := 'Error al Ejecutar la Conversion de MB. ';
        RAISE EXC_PROC_ERR;
      END IF;
      LN_VELOCIDAD := LN_VELOCIDAD / LN_CONVERT_MB_KB;

      IF LN_TIPO_MAT_ANT <> LN_TIPO_MAT_NEW THEN
        P_VEL_INT := 1;
        GOTO SALTO;
      END IF;

      IF LN_TIPO_MAT_ANT <> 'DOCSIS3' AND LN_VELOCIDAD >= LV_VEL_CONF THEN
        P_VEL_INT := 1;
        GOTO SALTO;
      ELSE
        P_VEL_INT := 0;
        GOTO SALTO;
      END IF;
    END IF;
    /* Fin    Proceso Principal */
    <<SALTO>>
    P_COD_RESP := 0;
    P_MSJ_RESP := 'Se ejecuto el SP SGASS_VELOCIDAD_LTE, Correctamente.';
  EXCEPTION
    WHEN EXC_PROC_ERR THEN
      P_VEL_INT  := -1;
      P_COD_RESP := LN_COD_RESP;
      P_MSJ_RESP := LV_MSJ_RES;
    WHEN OTHERS THEN
      P_VEL_INT  := -1;
      LV_MSJ_RES := $$PLSQL_UNIT || '.SGASS_VELOCIDAD_LTE: ';
      LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(-) P_COD_ID =        ' || TO_CHAR(P_COD_ID);
      LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(-) P_CODSOLOT =      ' || TO_CHAR(P_CODSOLOT);
      LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(*) Codigo de Error:  ' || TO_CHAR(SQLCODE);
      LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(*) Linea de Error:   ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(*) Mensaje de Error: ' || SQLERRM;
      P_COD_RESP := -1;
      P_MSJ_RESP := LV_MSJ_RES;
  END;

  /*'****************************************************************
  '* Nombre SP : SGASS_DESC_INTERNET
  '* Proposito : El SP se encarga de validar la trama de Internet y verificar si la Operación es de Upgrade o Downgrade
  '* Input :   <P_CODSOLOT>     - Codigo de SOLOT
               <P_CODSRV>       - Codigo del Servicio en el SGA
  '* Output :  <P_FLAG>         - Flag Indica la Operacion
               <P_COD_RESP>     - Codigo de Respuesta del SP.
               <P_MSJ_RESP>     - Mensaje de la Respuesta del SP.
  '* Creado por                : Team Dev
  '* Fecha de Creacion         : 02/03/2020.
  '* Actualizado por           : ----
  '* Fecha de Actualizacion    : ----
  '*****************************************************************/ 
  PROCEDURE SGASS_DESC_INTERNET(P_CODSOLOT OPERACION.SOLOT.CODSOLOT%TYPE,
                                P_CODSRV   SALES.TYSTABSRV.CODSRV%TYPE,
                                P_FLAG     OUT NUMBER,
                                P_COD_RESP OUT NUMBER,
                                P_MSJ_RESP OUT VARCHAR2) IS

    LN_VELOCIDAD     NUMBER;
    LN_VELOCIDAD_ACT NUMBER;
    LV_MSJ_RES       VARCHAR2(4000);
    EXC_ERR_PROC EXCEPTION;
  BEGIN
    /* Inicio Consulta de Velocidad Actual */
    BEGIN
      SELECT DISTINCT A.BANWID
        INTO LN_VELOCIDAD_ACT
        FROM OPERACION.INSSRV I,
             SALES.TYSTABSRV  A,
             OPERACION.INSPRD IP
       WHERE A.CODSRV    = IP.CODSRV
         AND I.CODINSSRV = IP.CODINSSRV
         AND I.CODINSSRV IN (SELECT DISTINCT S.CODINSSRV
                               FROM OPERACION.SOLOTPTO S
                              WHERE S.CODSOLOT = P_CODSOLOT)
         AND IP.FLGPRINC = 1
         AND A.TIPSRV    = CV_INTERNET
         AND IP.ESTINSPRD IN (1, 2);
    EXCEPTION
      WHEN OTHERS THEN
        LV_MSJ_RES := 'Error la SOT ' || TO_CHAR(P_CODSOLOT) ||' No tiene el Servicio de Internet Activo/Suspendido.';
        RAISE EXC_ERR_PROC;
    END;
    /* Fin   Consulta de Velocidad Actual */

    /* Inicio Consulta de Nueva Velocidad */
    BEGIN
      SELECT DISTINCT SER.BANWID
        INTO LN_VELOCIDAD
        FROM SALES.TYSTABSRV SER
       WHERE SER.CODSRV = P_CODSRV;
    EXCEPTION
      WHEN OTHERS THEN
        LV_MSJ_RES := 'Error el Servicio ' || P_CODSRV ||' no esta Correctamente Configurado.';
        RAISE EXC_ERR_PROC;
    END;
    /* Fin   Consulta de Nueva Velocidad */

    IF LN_VELOCIDAD <= LN_VELOCIDAD_ACT THEN
      P_FLAG := 0; ---DOWNGRADE
      RETURN;
    ELSE
      P_FLAG := 1; ---UPGRADE
      RETURN;
    END IF;
  EXCEPTION
    WHEN EXC_ERR_PROC THEN
      P_FLAG     := -1;
      P_COD_RESP := -1;
      P_MSJ_RESP := LV_MSJ_RES;
    WHEN OTHERS THEN
      LV_MSJ_RES := $$PLSQL_UNIT || '.SGASS_DESC_INTERNET: ';
      LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(-) P_CODSOLOT =      ' || TO_CHAR(P_CODSOLOT);
      LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(-) P_CODSRV =        ' || P_CODSRV;
      LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(*) Codigo de Error:  ' || TO_CHAR(SQLCODE);
      LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(*) Linea de Error:   ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(*) Mensaje de Error: ' || SQLERRM;
      P_FLAG     := -1;
      P_COD_RESP := -1;
      P_MSJ_RESP := LV_MSJ_RES;
  END;

  /*'****************************************************************
  '* Nombre SP : SGASI_TRS_VIS_TEC
  '* Proposito : El SP se encarga de Almacenar la Informacion de las tramas de los servicios seleccionados 
                 el en front para realizar las validaciones correspondientes en el flujo de visita técnica
  '* Input :   <P_COD_ID>      - Codigo de Contrato del BSCS.
               <P_CUSTOMER_ID> - Codigo del Cliente del BSCS.
               <P_TRAMA>       - Lista de los servicios Seleccionados desde el Front.
  '* Output :  <P_COD_RESP>     - Codigo de Respuesta del SP.
               <P_MSJ_RESP>     - Mensaje de la Respuesta del SP.
  '* Creado por                : Team Dev
  '* Fecha de Creacion         : 02/03/2020.
  '* Actualizado por           : ----
  '* Fecha de Actualizacion    : ----
  '*****************************************************************/ 
	PROCEDURE SGASI_TRS_VIS_TEC(P_COD_ID      IN OPERACION.SOLOT.COD_ID%TYPE,
	                            P_CUSTOMER_ID IN OPERACION.SOLOT.CUSTOMER_ID%TYPE,
	                            P_TRAMA       IN VARCHAR2,
	                            P_COD_RESP    OUT NUMBER,
	                            P_MSJ_RESP    OUT VARCHAR2) IS
	  LN_CONT      NUMBER;
	  LN_ROWS      NUMBER;
	  LN_DELIMITER NUMBER;
	  LN_POINTER   NUMBER;
	  LV_RECORD    VARCHAR2(32767);
	  LV_STRING    VARCHAR2(32767);
      LV_CARACTER  VARCHAR2(1);
	  LR_TABLA     OPERACION.SGAT_TRS_VISITA_TECNICA%ROWTYPE;
	  LN_LINEA     SALES.LINEA_PAQUETE.IDLINEA%TYPE;
	  ERR_SRV      EXCEPTION;
	  ERR_REG      EXCEPTION;
	  LV_MSJ_RES   VARCHAR2(4000);
	BEGIN
	
	  DELETE FROM OPERACION.SGAT_TRS_VISITA_TECNICA V
	   WHERE V.TRSN_COD_ID = P_COD_ID;
	  COMMIT;

	  SELECT SUBSTR(P_TRAMA, LENGTH(P_TRAMA) )  
	    INTO LV_CARACTER FROM DUAL;
	  
	  IF LV_CARACTER <> ';' THEN 
	    RAISE ERR_REG;
	  END IF;
	
	  BEGIN
	   LN_ROWS := SGAFUN_COUNT_ROWS(P_TRAMA) - 1;
	  EXCEPTION
	    WHEN OTHERS THEN
	      RAISE ERR_REG;
	  END;
	
	  LV_STRING                 := REPLACE(P_TRAMA, ' ', '');
	  LN_POINTER                := 1;
	  LN_CONT                   := 0;
	  LR_TABLA.TRSN_COD_ID      := P_COD_ID;
	  LR_TABLA.TRSN_CUSTOMER_ID := P_CUSTOMER_ID;
	
	  FOR IDX IN 1 .. LN_ROWS LOOP
	    LN_DELIMITER := INSTR(LV_STRING, ';', 1, IDX);
	    LV_RECORD    := SUBSTR(LV_STRING,
	                           LN_POINTER,
	                           (LN_DELIMITER - LN_POINTER));
	
	    LN_LINEA                   := SGAFUN_DIVIDE_CADENA(LV_RECORD);
	    LR_TABLA.TRSV_CANTIDAD_EQU := SGAFUN_DIVIDE_CADENA(LV_RECORD);
	
	    BEGIN
		  SELECT DECODE(DET_PAQ.PAQUETE,
						1,
						'TLF',
						2,
						'INT',
						3,
						'CTV',
						4,
						'CTV') ,
				 LIN_PAQ.CODSRV,
				 LIN_PAQ.CODEQUCOM,
				 NVL((SELECT DECODE(TEC_SRV.PVTCN_CODTEC,
								   3,
								   'DTH',
								   5,
								   'HFC',
								   8,
								   'LTE',
								   9,
								   'FTTH')
					   FROM SALES.SGAT_PAQVTA_TECNOLOGIA TEC_SRV
					  WHERE PVTCN_CODTEC = LIN_PAQ.PVTCN_CODTEC),
					 'HFC')
			INTO LR_TABLA.TRSV_TIPO_SRV,
				 LR_TABLA.TRSV_CODSRV,
				 LR_TABLA.TRSV_CODEQUCOM,
				 LR_TABLA.TRSV_TECNOLOGIA
			FROM SALES.PAQUETE_VENTA   PAQ,
				 SALES.DETALLE_PAQUETE DET_PAQ,
				 SALES.LINEA_PAQUETE   LIN_PAQ,
				 SALES.TYSTABSRV       SRV_PRO
		   WHERE PAQ.IDPAQ = DET_PAQ.IDPAQ
			 AND DET_PAQ.IDDET = LIN_PAQ.IDDET
			 AND LIN_PAQ.CODSRV = SRV_PRO.CODSRV
			 AND LIN_PAQ.IDLINEA = LN_LINEA;
	    EXCEPTION
	      WHEN OTHERS THEN
	           RAISE ERR_SRV;
	    END;
	    IF LR_TABLA.TRSV_CANTIDAD_EQU > 0 AND
	       LR_TABLA.TRSV_CODEQUCOM IS NOT NULL THEN
	      SELECT E.TIPEQU, E.CODTIPEQU
	        INTO LR_TABLA.TRSV_TIPEQU, LR_TABLA.TRSV_CODTIPEQU
	        FROM SALES.LINEA_PAQUETE LP, OPERACION.EQUCOMXOPE E
	       WHERE LP.CODEQUCOM = E.CODEQUCOM
	         AND LP.IDLINEA = LN_LINEA;
	    ELSE
	      LR_TABLA.TRSV_TIPEQU    := NULL;
	      LR_TABLA.TRSV_CODTIPEQU := NULL;
	    END IF;
	    LR_TABLA.TRSV_TRANSACCION  := 'MIGRACION';
	    LR_TABLA.TRSV_USUREG       := USER;
	    LR_TABLA.TRSD_FECREG       := SYSDATE;
	    LR_TABLA.TRSV_IPAPLICACION := SYS_CONTEXT('USERENV', 'IP_ADDRESS');
	    LR_TABLA.TRSV_PCAPLICACION := SYS_CONTEXT('USERENV', 'TERMINAL');
	
	    INSERT INTO OPERACION.SGAT_TRS_VISITA_TECNICA VALUES LR_TABLA;
	    LN_CONT    := LN_CONT + 1;
	    LN_POINTER := LN_DELIMITER + 1;
	  END LOOP;
	  IF LN_CONT = 0 THEN
	     RAISE ERR_REG;
	  END IF;
	  COMMIT;
	  P_COD_RESP := 0;
	  P_MSJ_RESP := 'Se ejecuto el SP SGASI_TRS_VIS_TEC, Correctamente.';
	EXCEPTION
	  WHEN ERR_SRV THEN
	    LV_MSJ_RES := $$PLSQL_UNIT || '.SGASI_TRS_VIS_TEC: ';
	    LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(-) P_COD_ID =        ' || TO_CHAR(P_COD_ID);
	    LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(-) P_CUSTOMER_ID =   ' || TO_CHAR(P_CUSTOMER_ID);
	    LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(-) LINEA =           ' || LN_LINEA;
	    LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(*) Codigo de Error:  ' || TO_CHAR(SQLCODE);
	    LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(*) Linea de Error:   ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
	    LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(*) Mensaje de Error: ' || 'Servicios/Equipos no registrado, Revisar Configuracion...';
	    P_COD_RESP := -1;
	    P_MSJ_RESP := TRIM(LV_MSJ_RES);
	    ROLLBACK;
	  WHEN ERR_REG THEN
	    LV_MSJ_RES := $$PLSQL_UNIT || '.SGASI_TRS_VIS_TEC: ';
	    LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(-) P_COD_ID =        ' || TO_CHAR(P_COD_ID);
	    LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(-) P_CUSTOMER_ID =   ' || TO_CHAR(P_CUSTOMER_ID);
	    LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(-) P_TRAMA =         ' || P_TRAMA;
	    LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(*) Codigo de Error:  ' || TO_CHAR(SQLCODE);
	    LV_MSJ_RES :=
	    +LV_MSJ_RES || CHR(13) || '(*) Linea de Error:   ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
	    LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(*) Mensaje de Error: ' || 'Lista de Servicios/Equipos no valido, es un Campo Obligatorio, Revisar el Formato que se esta enviando en la trama';
	    P_COD_RESP := -1;
	    P_MSJ_RESP := TRIM(LV_MSJ_RES);
	    ROLLBACK;
	  WHEN OTHERS THEN
	    LV_MSJ_RES := $$PLSQL_UNIT || '.SGASI_TRS_VIS_TEC: ';
	    LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(-) P_COD_ID =        ' || TO_CHAR(P_COD_ID);
	    LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(-) P_CUSTOMER_ID =   ' || TO_CHAR(P_CUSTOMER_ID);
	    LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(*) Codigo de Error:  ' || TO_CHAR(SQLCODE);
	    LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(*) Linea de Error:   ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
	    LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(*) Mensaje de Error: ' || SQLERRM;
	    P_COD_RESP := -1;
	    P_MSJ_RESP := TRIM(LV_MSJ_RES);
	    ROLLBACK;
	END;

  /*'****************************************************************
  '* Nombre FUN: SGAFUN_INICIA_VALORES
  '* Proposito : La Funcion se encarga de cargar los valores de los arrays para determinar la cantidad de servicios y tipos 
                 de servicios Ingresados en las tramas. Devuelve el array de tipo record.
  '* Input :   <P_CODSOLOT>    - Codigo de SOLOT.
               <P_COD_ID>      - Codigo del Contrato del BSCS.
  '* Output :  <VALORES_SRV>   - Arrays con Informacion de los Servicios nuevos y actuales..
  '* Creado por                : Team Dev
  '* Fecha de Creacion         : 02/03/2020.
  '* Actualizado por           : ----
  '* Fecha de Actualizacion    : ----
  '*****************************************************************/ 
  FUNCTION SGAFUN_INICIA_VALORES(P_CODSOLOT IN OPERACION.SOLOT.CODSOLOT%TYPE,
                                 P_COD_ID   IN OPERACION.SGAT_TRS_VISITA_TECNICA.TRSN_COD_ID%TYPE)
    RETURN VALORES_SRV IS
    SERVICIOS_VAL VALORES_SRV;
    LV_MSJ_RES    VARCHAR2(4000);
  BEGIN

    SERVICIOS_VAL.LN_VAL_INT_OLD := SGAFUN_TIPSRV_OLD(P_CODSOLOT, CV_INTERNET);
    SERVICIOS_VAL.LN_VAL_TLF_OLD := SGAFUN_TIPSRV_OLD(P_CODSOLOT, CV_TELEFONIA);
    SERVICIOS_VAL.LN_VAL_CTV_OLD := SGAFUN_TIPSRV_OLD(P_CODSOLOT, CV_CABLE);
    SERVICIOS_VAL.LN_CNT_CTV_OLD := SGAFUN_CANTEQU_OLD(P_CODSOLOT, CV_CABLE);
    SERVICIOS_VAL.LN_DES_CTV_OLD := SGAFUN_DES_TIPSRV_OLD(P_CODSOLOT, CV_CABLE);
    SERVICIOS_VAL.LN_DES_TLF_OLD := SGAFUN_DES_TIPSRV_OLD(P_CODSOLOT, CV_TELEFONIA);
    SERVICIOS_VAL.LN_DES_INT_OLD := SGAFUN_DES_TIPSRV_OLD(P_CODSOLOT,CV_INTERNET);

    SERVICIOS_VAL.LN_VAL_INT_NEW := SGAFUN_TIPSRV_NEW(P_COD_ID, CV_INT);
    SERVICIOS_VAL.LN_VAL_TLF_NEW := SGAFUN_TIPSRV_NEW(P_COD_ID,CV_TEL);
    SERVICIOS_VAL.LN_VAL_CTV_NEW := SGAFUN_TIPSRV_NEW(P_COD_ID, CV_CTV);
    SERVICIOS_VAL.LN_TEC_INT_NEW := SGAFUN_GET_TECNOLOGIA(P_COD_ID, CV_INT);
    SERVICIOS_VAL.LN_TEC_TLF_NEW := SGAFUN_GET_TECNOLOGIA(P_COD_ID, CV_TEL);
    SERVICIOS_VAL.LN_TEC_CTV_NEW := SGAFUN_GET_TECNOLOGIA(P_COD_ID, CV_CTV);
    SERVICIOS_VAL.LN_CNT_CTV_NEW := SGAFUN_CANTEQU_NEW(P_COD_ID, CV_CTV);
    SERVICIOS_VAL.LN_DES_CTV_NEW := SGAFUN_DES_TIPSRV_NEW(P_COD_ID, CV_CTV);
    SERVICIOS_VAL.LN_DES_TLF_NEW := SGAFUN_DES_TIPSRV_NEW(P_COD_ID, CV_TEL);
    SERVICIOS_VAL.LN_DES_INT_NEW := SGAFUN_DES_TIPSRV_NEW(P_COD_ID, CV_INT);
    RETURN SERVICIOS_VAL;
  EXCEPTION
    WHEN OTHERS THEN
      LV_MSJ_RES := $$PLSQL_UNIT || '.SGAFUN_INICIA_VALORES: ';
      LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(-) P_CODSOLOT =      ' || TO_CHAR(P_CODSOLOT);
      LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(-) P_COD_ID =        ' || TO_CHAR(P_COD_ID);
      LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(*) Codigo de Error:  ' || TO_CHAR(SQLCODE);
      LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(*) Linea de Error:   ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(*) Mensaje de Error: ' || SQLERRM;
      RAISE_APPLICATION_ERROR(-20000, LV_MSJ_RES);
  END;

  /*'****************************************************************
  '* Nombre FUN: SGAFUN_CANTEQU_OLD
  '* Proposito : La función se encarga de realizar la Consulta de los Equipos contratados actualmente 
                 (Telefonia, Internet, Cable). Devuelve la cantidad de equipos.
  '* Input :   <P_CODSOLOT>    - Codigo de SOLOT.
               <P_TIPSRV>      - Codigo de Tipo de Servicio 0004 Telefonia, 0006: Internet, 0062: Cable
  '* Output :  <LN_COUNT>      - Cantidad de Equipos Actuales.
  '* Creado por                : Team Dev
  '* Fecha de Creacion         : 02/03/2020.
  '* Actualizado por           : ----
  '* Fecha de Actualizacion    : ----
  '*****************************************************************/ 
  FUNCTION SGAFUN_CANTEQU_OLD(P_CODSOLOT OPERACION.SOLOT.CODSOLOT%TYPE,
                              P_TIPSRV   TYSTIPSRV.TIPSRV%TYPE) RETURN NUMBER IS
    LN_COUNT NUMBER;
  BEGIN
    SELECT SUM(X.CANTIDAD)
      INTO LN_COUNT
      FROM (SELECT DISTINCT IP.PID, IP.CODEQUCOM, IP.CANTIDAD
              FROM OPERACION.SOLOT    S,
                   OPERACION.SOLOTPTO SP,
                   OPERACION.INSPRD   IP,
                   OPERACION.INSSRV   IV,
                   SALES.VTAEQUCOM    VT
             WHERE S.CODSOLOT   = SP.CODSOLOT
               AND SP.CODINSSRV = IV.CODINSSRV
               AND IP.CODINSSRV = IV.CODINSSRV
               AND VT.CODEQUCOM = IP.CODEQUCOM
               AND NOT EXISTS (SELECT 1
                                 FROM OPERACION.OPEDD O
                                WHERE O.TIPOPEDD = (SELECT TIPOPEDD
                                                      FROM OPERACION.TIPOPEDD
                                                     WHERE ABREV = 'CVE_CP')
                                 AND ABREVIACION = 'NO_EQU'
                                 AND CODIGOC = VT.TIP_EQ)
               AND S.CODSOLOT   = P_CODSOLOT
               AND IV.TIPSRV    = P_TIPSRV
               AND IP.ESTINSPRD IN (1, 2)) X
     WHERE NVL(X.CODEQUCOM, 'X') != 'X';
    RETURN LN_COUNT;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN 0;
  END;

  /*'****************************************************************
  '* Nombre FUN: SGAFUN_TIPSRV_OLD
  '* Proposito : La función se encarga de realizar la consulta de los servicios contratados Actualmente 
                 (Telefonia, Internet, Cable). Devuelve la cantidad de servicios.
  '* Input :   <P_CODSOLOT>    - Codigo de SOLOT.
               <P_TIPSRV>      - Codigo de Tipo de Servicio 0004 Telefonia, 0006: Internet, 0062: Cable
  '* Output :  <LN_RETURN>      - Cantidad de Servicios.
  '* Creado por                : Team Dev
  '* Fecha de Creacion         : 02/03/2020.
  '* Actualizado por           : ----
  '* Fecha de Actualizacion    : ----
  '*****************************************************************/ 
  FUNCTION SGAFUN_TIPSRV_OLD(P_CODSOLOT OPERACION.SOLOT.CODSOLOT%TYPE,
                             P_TIPSRV   TYSTIPSRV.TIPSRV%TYPE) RETURN NUMBER IS
    LN_RETURN NUMBER;
  BEGIN
    SELECT COUNT(DISTINCT I.TIPSRV)
      INTO LN_RETURN
      FROM OPERACION.SOLOT    S,
           OPERACION.SOLOTPTO PTO,
           OPERACION.INSSRV   I,
           OPERACION.INSPRD   P,
           SALES.TYSTABSRV    T
     WHERE S.CODSOLOT    = PTO.CODSOLOT
       AND PTO.CODINSSRV = I.CODINSSRV
       AND I.CODINSSRV   = P.CODINSSRV
       AND P.CODSRV      = T.CODSRV
       AND S.CODSOLOT    = P_CODSOLOT
       AND I.TIPSRV      = P_TIPSRV
       AND P.ESTINSPRD   IN (1, 2);
    RETURN LN_RETURN;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN 0;
  END;

  /*'****************************************************************
  '* Nombre FUN: SGAFUN_DES_TIPSRV_OLD
  '* Proposito : La función se encarga de realizar la consulta de los servicios contratados actualmente 
                 (Telefonia, Internet, Cable). Devuelve la descripción del servicio.
  '* Input :   <P_CODSOLOT>    - Codigo de SOLOT.
               <P_TIPSRV>      - Codigo de Tipo de Servicio 0004 Telefonia, 0006: Internet, 0062: Cable
  '* Output :  <LN_RETURN>      - Descripcion del Servicio.
  '* Creado por                : Team Dev
  '* Fecha de Creacion         : 02/03/2020.
  '* Actualizado por           : ----
  '* Fecha de Actualizacion    : ----
  '*****************************************************************/ 
  FUNCTION SGAFUN_DES_TIPSRV_OLD(P_CODSOLOT OPERACION.SOLOT.CODSOLOT%TYPE,
                                 P_TIPSRV   TYSTIPSRV.TIPSRV%TYPE)
    RETURN VARCHAR2 IS
    LN_RETURN VARCHAR2(300);
  BEGIN
    SELECT DISTINCT T.DSCSRV
      INTO LN_RETURN
      FROM OPERACION.SOLOTPTO PTO,
           OPERACION.INSSRV I,
           SALES.TYSTABSRV T
     WHERE PTO.CODINSSRV = I.CODINSSRV
       AND I.CODSRV      = T.CODSRV
       AND PTO.CODSOLOT  = P_CODSOLOT
       AND I.TIPSRV      = P_TIPSRV
       AND I.ESTINSSRV   IN (1, 2);
    RETURN LN_RETURN;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN NULL;
  END;

  /*'****************************************************************
  '* Nombre FUN: SGAFUN_CANTEQU_NEW
  '* Proposito : La función se encarga de realizar la Consulta de los Equipos seleccionados en el Front 
                 (Telefonia, Internet, Cable). Devuelve la cantidad de equipos.
  '* Input :   <P_COD_ID>       - Codigo de Contrato del BSCS.
               <P_SRV>          - Tipo del Servicio por Contratar INT: Internet, TLF: Telefonia, CTV: Cable
  '* Output :  <LN_RETURN>      - Cantidad de Equipos.
  '* Creado por                : Team Dev
  '* Fecha de Creacion         : 02/03/2020.
  '* Actualizado por           : ----
  '* Fecha de Actualizacion    : ----
  '*****************************************************************/ 
  FUNCTION SGAFUN_CANTEQU_NEW(P_COD_ID OPERACION.SOLOT.COD_ID%TYPE,
                              P_SRV    VARCHAR2) RETURN NUMBER IS
    LN_COUNT NUMBER;
  BEGIN
    SELECT SUM(V.TRSV_CANTIDAD_EQU)
      INTO LN_COUNT
      FROM OPERACION.SGAT_TRS_VISITA_TECNICA V
     WHERE V.TRSN_COD_ID   = P_COD_ID
       AND V.TRSV_TIPO_SRV = P_SRV;
    RETURN LN_COUNT;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN 0;
  END;

  /*'****************************************************************
  '* Nombre FUN: SGAFUN_TIPSRV_NEW
  '* Proposito : La función se encarga de realizar la consulta de los servicios seleccionados en el Front 
                 (Telefonia, Internet, Cable). Devuelve la cantidad de servicios.
  '* Input :   <P_COD_ID>       - Codigo de Contrato del BSCS.
               <P_TIPO_SRV>     - Tipo del Servicio por Contratar INT: Internet, TLF: Telefonia, CTV: Cable
  '* Output :  <LN_RETURN>      - Cantidad de Servicios.
  '* Creado por                : Team Dev
  '* Fecha de Creacion         : 02/03/2020.
  '* Actualizado por           : ----
  '* Fecha de Actualizacion    : ----
  '*****************************************************************/ 
  FUNCTION SGAFUN_TIPSRV_NEW(P_COD_ID   OPERACION.SGAT_TRS_VISITA_TECNICA.TRSN_COD_ID%TYPE,
                             P_TIPO_SRV OPERACION.SGAT_TRS_VISITA_TECNICA.TRSV_TIPO_SRV%TYPE)
    RETURN NUMBER IS
    LN_RETURN NUMBER;
  BEGIN
    SELECT COUNT(DISTINCT T.TIPSRV)
      INTO LN_RETURN
      FROM SALES.TYSTABSRV T,
           OPERACION.SGAT_TRS_VISITA_TECNICA SER
     WHERE SER.TRSV_CODSRV = T.CODSRV
       AND SER.TRSN_COD_ID   = P_COD_ID
       AND SER.TRSV_TIPO_SRV = P_TIPO_SRV;

    RETURN LN_RETURN;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN 0;
  END;

  /*'****************************************************************
  '* Nombre FUN: SGAFUN_DES_TIPSRV_NEW
  '* Proposito : La función se encarga de realizar la consulta de los servicios selecciondos en el front 
     (Telefonia, Internet, Cable). Devuelve la descripción del servicio.
  '* Input :   <P_COD_ID>       - Codigo de Contrato del BSCS.
               <P_TIPO_SRV>     - Tipo del Servicio por Contratar INT: Internet, TLF: Telefonia, CTV: Cable
  '* Output :  <LN_RETURN>      - Descripcion del Servicio.
  '* Creado por                : Team Dev
  '* Fecha de Creacion         : 02/03/2020.
  '* Actualizado por           : ----
  '* Fecha de Actualizacion    : ----
  '*****************************************************************/ 
  FUNCTION SGAFUN_DES_TIPSRV_NEW(P_COD_ID   OPERACION.SGAT_TRS_VISITA_TECNICA.TRSN_COD_ID%TYPE,
                                 P_TIPO_SRV OPERACION.SGAT_TRS_VISITA_TECNICA.TRSV_TIPO_SRV%TYPE)
    RETURN VARCHAR2 IS
    LN_RETURN VARCHAR2(300);
  BEGIN
    SELECT T.DSCSRV
      INTO LN_RETURN
      FROM SALES.TYSTABSRV T,
          OPERACION.SGAT_TRS_VISITA_TECNICA SER
     WHERE T.CODSRV        = SER.TRSV_CODSRV
       AND SER.TRSN_COD_ID   = P_COD_ID
       AND SER.TRSV_TIPO_SRV = P_TIPO_SRV
     GROUP BY T.DSCSRV;
    RETURN LN_RETURN;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN NULL;
  END;

  /*'****************************************************************
  '* Nombre FUN: SGAFUN_COUNT_ROWS
  '* Proposito : La función se encargar de realizar la Consulta de la cantidad de registros 
                 seleccionados en el Front y que fueron registrados.
  '* Input :   <P_STRING>       - Trama.
  '* Output :  <LN_RETURN>      - Cantidad de Registros.
  '* Creado por                : Team Dev
  '* Fecha de Creacion         : 02/03/2020.
  '* Actualizado por           : ----
  '* Fecha de Actualizacion    : ----
  '*****************************************************************/ 
  FUNCTION SGAFUN_COUNT_ROWS(P_STRING VARCHAR2) RETURN NUMBER IS
    LN_COUNT   NUMBER := 0;
    LV_VALUE   VARCHAR2(1);
    LN_LENGTH  NUMBER;
  BEGIN
    LN_LENGTH := LENGTH(P_STRING);
    FOR IDX IN 1 .. LN_LENGTH LOOP
      LV_VALUE := SUBSTR(P_STRING, IDX, 1);
      IF LV_VALUE = ';' THEN
        LN_COUNT := LN_COUNT + 1;
      END IF;
    END LOOP;
    RETURN LN_COUNT + 1;
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000, SQLERRM);
  END;

  /*'****************************************************************
  '* Nombre FUN: SGAFUN_DIVIDE_CADENA
  '* Proposito : La Funcion se encarga de extraer cada uno de los campos enviados en la trama 
                 seleccionados en el Front y que fueron registrados.
  '* Input :   <P_CADENA>       - Trama.
  '* Output :  <LN_RETURN>      - campo.
  '* Creado por                : Team Dev
  '* Fecha de Creacion         : 02/03/2020.
  '* Actualizado por           : ----
  '* Fecha de Actualizacion    : ----
  '*****************************************************************/ 
  FUNCTION SGAFUN_DIVIDE_CADENA(P_CADENA IN OUT VARCHAR2) RETURN VARCHAR2 IS
    V_LONGITUD INTEGER;
    V_VALOR    VARCHAR2(100);
  BEGIN

    SELECT DECODE(INSTR(P_CADENA, '|', 1, 1),
                  0,
                  LENGTH(P_CADENA),
                  INSTR(P_CADENA, '|', 1, 1) - 1)
      INTO V_LONGITUD
      FROM DUAL;

    SELECT SUBSTR(P_CADENA, 1, V_LONGITUD),
           SUBSTR(P_CADENA, V_LONGITUD + 2)
      INTO V_VALOR, P_CADENA
      FROM DUAL;

    RETURN V_VALOR;
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000, SQLERRM);
  END;

  /*'****************************************************************
  '* Nombre FUN: SGAFUN_VAL_RECUPERABLE
  '* Proposito : La función se encarga de realizar la consulta de los servicios contratados actualmente 
                 (Telefonia, Internet, Cable). Devuelve si el quipos es recuperable o no.
  '* Input :   <P_CODSOLOT>     - Codigo de SOLOT
               <P_TIPSRV>       - Tipo del Servicio.
  '* Output :  <LN_RETURN>      - Flag.
  '* Creado por                : Team Dev
  '* Fecha de Creacion         : 02/03/2020.
  '* Actualizado por           : ----
  '* Fecha de Actualizacion    : ----
  '*****************************************************************/ 
  FUNCTION SGAFUN_VAL_RECUPERABLE(P_CODSOLOT OPERACION.SOLOT.CODSOLOT%TYPE,
                                  P_TIPSRV   SALES.TYSTIPSRV.TIPSRV%TYPE)
    RETURN NUMBER IS
    LN_VAL_RECUPERABLE NUMBER;
    LV_MSJ_RES         VARCHAR2(4000);

    CURSOR C_EQU_SGA IS
      SELECT DISTINCT EQ.TIP_EQ, EQ.FLG_RECUPERABLE
        FROM (SELECT DISTINCT IP.PID, IP.CODEQUCOM, IP.CANTIDAD
                FROM OPERACION.SOLOT    S,
                     OPERACION.SOLOTPTO SP,
                     OPERACION.INSPRD   IP,
                     OPERACION.INSSRV   IV
               WHERE S.CODSOLOT   = SP.CODSOLOT
                 AND SP.CODINSSRV = IV.CODINSSRV
                 AND IP.CODINSSRV = IV.CODINSSRV
                 AND S.CODSOLOT   = P_CODSOLOT
                 AND IV.TIPSRV    = P_TIPSRV
                 AND IP.ESTINSPRD IN (1, 2)) X,
             SALES.VTAEQUCOM EQ
       WHERE NVL(X.CODEQUCOM, 'X') != 'X'
         AND EQ.CODEQUCOM          = X.CODEQUCOM;
  BEGIN

    LN_VAL_RECUPERABLE := 0;
    FOR R IN C_EQU_SGA LOOP
      IF R.FLG_RECUPERABLE = 'SI' THEN
        LN_VAL_RECUPERABLE := LN_VAL_RECUPERABLE + 1;
      END IF;
    END LOOP;
    IF LN_VAL_RECUPERABLE > 0 THEN
      RETURN 1;
    ELSE
      RETURN 0;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      LV_MSJ_RES := $$PLSQL_UNIT || '.SGAFUN_VAL_RECUPERABLE: ';
      LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(-) P_CODSOLOT =      ' || TO_CHAR(P_CODSOLOT);
      LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(-) P_TIPSRV =        ' || P_TIPSRV;
      LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(*) Codigo de Error:  ' || TO_CHAR(SQLCODE);
      LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(*) Linea de Error:   ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(*) Mensaje de Error: ' || SQLERRM;
      RAISE_APPLICATION_ERROR(-20000, LV_MSJ_RES);
  END;

  /*'****************************************************************
  '* Nombre FUN: SGAFUN_CONVERT_MB_KB
  '* Proposito : La función se encarga de consultar las configuraciones en tipos y estados y devuelve el valor de conversión.
  '* Input :   <P_ABREV>        - Descripcion del Estado
               <P_TIPSRV>       - Tipo del Servicio.
  '* Output :  <LN_RETURN>      - Valor de conversion.
  '* Creado por                : Team Dev
  '* Fecha de Creacion         : 02/03/2020.
  '* Actualizado por           : ----
  '* Fecha de Actualizacion    : ----
  '*****************************************************************/ 
  FUNCTION SGAFUN_CONVERT_MB_KB(P_ABREV OPERACION.TIPOPEDD.ABREV%TYPE)
    RETURN NUMBER IS
    LN_CONVERT_MB_KB NUMBER := 0;
  BEGIN
    SELECT OP.CODIGON
      INTO LN_CONVERT_MB_KB
      FROM OPERACION.TIPOPEDD TP,
           OPERACION.OPEDD OP
     WHERE TP.TIPOPEDD    = OP.TIPOPEDD
       AND TP.DESCRIPCION = 'Conversion de MB a KB'
       AND TP.ABREV       = P_ABREV
       AND OP.DESCRIPCION = 'Valor de equivalencia en Kb'
       AND OP.ABREVIACION = 'Valor Kb';

    RETURN LN_CONVERT_MB_KB;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN 0;
  END;

  /*'****************************************************************
  '* Nombre FUN: SGAFUN_VAL_MATRIZ_CP
  '* Proposito : La función consulta si de acuerdo  a las velocidades ingresadas le corresponde realizar la visita técnica
  '* Input :   <P_VELOCIDAD>    - Num Velocidad
               <P_PORTADORA>    - id Portadora.
  '* Output :  <LN_RETURN>      - flag.
  '* Creado por                : Team Dev
  '* Fecha de Creacion         : 02/03/2020.
  '* Actualizado por           : ----
  '* Fecha de Actualizacion    : ----
  '*****************************************************************/ 
  FUNCTION SGAFUN_VAL_MATRIZ_CP(P_VELOCIDAD SALES.TYSTABSRV.BANWID%TYPE,
                                P_PORTADORA SALES.SGAT_PORTADORA.SGAN_ID_PORTADORA%TYPE)
    RETURN NUMBER IS
    LN_FLAG NUMBER := 0;
  BEGIN

    SELECT SGAN_FLAG_VISITA
      INTO LN_FLAG
      FROM SALES.SGAT_MATRIZ_VT_CP
     WHERE SGAN_IDPORTADORA = P_PORTADORA
       AND P_VELOCIDAD BETWEEN SGAN_VELOC_MIN AND SGAN_VELOC_MAX;
    RETURN LN_FLAG;
  EXCEPTION
    WHEN OTHERS THEN
      LN_FLAG := 2;
      RETURN LN_FLAG;
  END;

  /*'****************************************************************
  '* Nombre FUN: SGAFUN_VAL_TIPDECO
  '* Proposito : La funcion evalua el Tipo de Deco
  '* Input :   <P_CODSOLOT>    - Codigo de Solot
               <P_COD_ID>      - Codigo del Contrato en BSCS.
  '* Output :  <LN_RETURN>      - flag.
  '* Creado por                : Team Dev
  '* Fecha de Creacion         : 02/03/2020.
  '* Actualizado por           : ----
  '* Fecha de Actualizacion    : ----
  '*****************************************************************/ 
  FUNCTION SGAFUN_VAL_TIPDECO(P_CODSOLOT OPERACION.SOLOT.CODSOLOT%TYPE,
                              P_COD_ID   OPERACION.SOLOT.COD_ID%TYPE)
    RETURN NUMBER IS
    LV_VAL_TIPEQU NUMBER;
    LV_VAL_CFG    NUMBER;

    CURSOR C_EQU_SGA_CP IS
      SELECT EQ.TIP_EQ, EQ.CODEQUCOM, SUM(X.CANTIDAD) CANTIDAD
        FROM (SELECT DISTINCT IP.PID, IP.CODEQUCOM, IP.CANTIDAD
                FROM OPERACION.SOLOT    S,
                     OPERACION.SOLOTPTO SP,
                     OPERACION.INSPRD   IP,
                     OPERACION.INSSRV   IV
               WHERE S.CODSOLOT   = SP.CODSOLOT
                 AND SP.CODINSSRV = IV.CODINSSRV
                 AND IP.CODINSSRV = IV.CODINSSRV
                 AND S.CODSOLOT   = P_CODSOLOT
                 AND IV.TIPSRV    = CV_CABLE
                 AND IP.ESTINSPRD IN (1,2)) X,
             SALES.VTAEQUCOM EQ,
             OPERACION.EQUCOMXOPE V,
             OPERACION.TIPEQU TE
       WHERE NVL(X.CODEQUCOM, 'X') != 'X'
         AND X.CODEQUCOM  = EQ.CODEQUCOM
         AND EQ.CODEQUCOM = V.CODEQUCOM
         AND V.CODTIPEQU  = TE.CODTIPEQU
         AND TE.TIPO      = 'DECODIFICADOR'
       GROUP BY EQ.TIP_EQ, EQ.CODEQUCOM;

    CURSOR C_EQU_PVU_CP IS
      SELECT X.TIP_EQ, X.CODEQUCOM_NEW, SUM(X.CANTIDAD) CANTIDAD
        FROM (SELECT T.TIP_EQ,
                     O.TRSV_CODEQUCOM    CODEQUCOM_NEW,
                     O.TRSV_CANTIDAD_EQU CANTIDAD
                FROM OPERACION.SGAT_TRS_VISITA_TECNICA O,
                     SALES.VTAEQUCOM T
               WHERE T.CODEQUCOM     = O.TRSV_CODEQUCOM
                 AND O.TRSN_COD_ID   = P_COD_ID
                 AND O.TRSV_TIPO_SRV = CV_CTV) X
       GROUP BY X.TIP_EQ, X.CODEQUCOM_NEW;

    CURSOR C_EQU_SGA IS
      SELECT EQ.TIP_EQ, SUM(X.CANTIDAD) CANTIDAD
        FROM (SELECT DISTINCT IP.PID, IP.CODEQUCOM, IP.CANTIDAD
                FROM OPERACION.SOLOT    S,
                     OPERACION.SOLOTPTO SP,
                     OPERACION.INSPRD   IP,
                     OPERACION.INSSRV   IV
               WHERE S.CODSOLOT   = SP.CODSOLOT
                 AND SP.CODINSSRV = IV.CODINSSRV
                 AND IP.CODINSSRV = IV.CODINSSRV
                 AND S.CODSOLOT   = P_CODSOLOT
                 AND IV.TIPSRV    = CV_CABLE
                 AND IP.ESTINSPRD IN (1, 2)) X,
             SALES.VTAEQUCOM             EQ,
             OPERACION.EQUCOMXOPE        V,
             OPERACION.TIPEQU            TE
       WHERE NVL(X.CODEQUCOM, 'X') != 'X'
         AND EQ.CODEQUCOM = X.CODEQUCOM
         AND EQ.CODEQUCOM = V.CODEQUCOM
         AND V.CODTIPEQU  = TE.CODTIPEQU
         AND TE.TIPO      = 'DECODIFICADOR'
       GROUP BY EQ.TIP_EQ
       ORDER BY EQ.TIP_EQ DESC;

    CURSOR C_EQU_PVU IS
      SELECT T.TIP_EQ, SUM(O.TRSV_CANTIDAD_EQU) CANTIDAD
        FROM OPERACION.SGAT_TRS_VISITA_TECNICA O,
             SALES.VTAEQUCOM T
       WHERE T.CODEQUCOM     = O.TRSV_CODEQUCOM
         AND O.TRSN_COD_ID   = P_COD_ID
         AND O.TRSV_TIPO_SRV = CV_CTV
       GROUP BY T.TIP_EQ
       ORDER BY T.TIP_EQ DESC;

    LN_CONT_EQU_OLD NUMBER;
    LN_CONT_EQU_NEW NUMBER;

  BEGIN
    LN_CONT_EQU_OLD := 0;
    LN_CONT_EQU_NEW := 0;
    LV_VAL_TIPEQU   := 0;

    LV_VAL_CFG := SGAFUN_VAL_CFG_VAL('CVEC_CTV');
    IF LV_VAL_CFG = 1 THEN
      FOR XX IN C_EQU_SGA_CP LOOP
        LN_CONT_EQU_OLD := LN_CONT_EQU_OLD + XX.CANTIDAD;
        LN_CONT_EQU_NEW := 0;
        FOR C IN C_EQU_PVU_CP LOOP
          LN_CONT_EQU_NEW := LN_CONT_EQU_NEW + C.CANTIDAD;
          IF XX.TIP_EQ = C.TIP_EQ THEN
            IF XX.CANTIDAD = C.CANTIDAD THEN
              IF SGAFUN_VAL_CFG_CODEQUCOM(C.CODEQUCOM_NEW, XX.CODEQUCOM) = 1 THEN
                LV_VAL_TIPEQU := 1;
              ELSE
                LV_VAL_TIPEQU := 0;
              END IF;
            ELSE
              LV_VAL_TIPEQU := 1;
            END IF;
          END IF;
        END LOOP;
      END LOOP;
      IF LN_CONT_EQU_NEW = LN_CONT_EQU_OLD AND LV_VAL_TIPEQU = 0 THEN
        RETURN 0;
      ELSE
        RETURN 1;
      END IF;
    ELSE
      FOR X IN C_EQU_SGA LOOP
        LN_CONT_EQU_OLD := LN_CONT_EQU_OLD + X.CANTIDAD;
        LN_CONT_EQU_NEW := 0;
        FOR C IN C_EQU_PVU LOOP
          LN_CONT_EQU_NEW := LN_CONT_EQU_NEW + C.CANTIDAD;
          IF X.TIP_EQ = C.TIP_EQ THEN
            IF X.CANTIDAD = C.CANTIDAD THEN
              LV_VAL_TIPEQU := 0;
            ELSE
              LV_VAL_TIPEQU := 1;
            END IF;
          END IF;
        END LOOP;
      END LOOP;
      IF LN_CONT_EQU_NEW = LN_CONT_EQU_OLD AND LV_VAL_TIPEQU = 0 THEN
        RETURN 0;
      ELSE
        RETURN 1;
      END IF;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN 0;
  END;

  /*'****************************************************************
  '* Nombre FUN: SGAFUN_VAL_CFG_CODEQUCOM
  '* Proposito : La función se encarga de realizar las comparaciones entre los equipos actuales y los nuevos equipos. 
                 Y determina si aplica o no la visita técnica.
  '* Input :   <P_CODEQUCOM_NEW>    - Codigo del Nuevo Equipo
               <P_CODEQUCOM_OLD>    - Codigo del Equipo Actual.
  '* Output :  <LN_RETURN>      - flag.
  '* Creado por                : Team Dev
  '* Fecha de Creacion         : 02/03/2020.
  '* Actualizado por           : ----
  '* Fecha de Actualizacion    : ----
  '*****************************************************************/ 
  FUNCTION SGAFUN_VAL_CFG_CODEQUCOM(P_CODEQUCOM_NEW VARCHAR2,
                                    P_CODEQUCOM_OLD VARCHAR2) RETURN NUMBER IS
    LN_RETURN NUMBER;
  BEGIN
    SELECT CEC.FLAG_APLICA
      INTO LN_RETURN
      FROM OPERACION.CONFIG_EQUCOM_CP CEC
     WHERE CEC.CODEQUCOM_NEW = P_CODEQUCOM_NEW
       AND CEC.CODEQUCOM_OLD = P_CODEQUCOM_OLD;

    RETURN LN_RETURN;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN 1;
    WHEN OTHERS THEN
      RETURN 1;
  END;

  /*'****************************************************************
  '* Nombre FUN: SGAFUN_VAL_CFG_VAL
  '* Proposito : La función realiza una consulta a la tabla de tipos y estados y devueve el valor de validación de equipos.
  '* Input :   <P_PARAM>        - Abreviacion de la tabla estados
  '* Output :  <LN_RETURN>      - flag.
  '* Creado por                : Team Dev
  '* Fecha de Creacion         : 02/03/2020.
  '* Actualizado por           : ----
  '* Fecha de Actualizacion    : ----
  '*****************************************************************/ 
  FUNCTION SGAFUN_VAL_CFG_VAL(P_PARAM VARCHAR2) RETURN NUMBER IS
    LN_RETURN  NUMBER;
    LV_MSJ_RES VARCHAR2(4000);
  BEGIN
    SELECT O.CODIGON
      INTO LN_RETURN
      FROM OPERACION.OPEDD O
     WHERE O.TIPOPEDD = (SELECT TIPOPEDD
                           FROM OPERACION.TIPOPEDD
                          WHERE ABREV = 'CVE_CP')
       AND O.ABREVIACION = P_PARAM;
    RETURN LN_RETURN;
  EXCEPTION
    WHEN OTHERS THEN
      LV_MSJ_RES := $$PLSQL_UNIT || '.SGAFUN_VAL_CFG_VAL: ';
      LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(-) P_PARAM =         ' || P_PARAM;
      LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(*) Codigo de Error:  ' || TO_CHAR(SQLCODE);
      LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(*) Linea de Error:   ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(*) Mensaje de Error: ' || SQLERRM;
      RAISE_APPLICATION_ERROR(-20000, LV_MSJ_RES);
  END;

  /*'****************************************************************
  '* Nombre FUN: SGAFUN_GET_TECNOLOGIA
  '* Proposito : La función se encarga de consultar el tipo de tecnología de cada uno se los servicios seleccionados en el front.
  '* Input :   <P_COD_ID>        - Codigo del Contrato en BSCS.
               <P_SERV>          - Tipo del Servicio por Contratar INT: Internet, TLF: Telefonia, CTV: Cable
  '* Output :  <LN_RETURN>       - tecnologia.
  '* Creado por                : Team Dev
  '* Fecha de Creacion         : 02/03/2020.
  '* Actualizado por           : ----
  '* Fecha de Actualizacion    : ----
  '*****************************************************************/ 
  FUNCTION SGAFUN_GET_TECNOLOGIA(P_COD_ID IN OPERACION.SOLOT.COD_ID%TYPE,
                                 P_SERV   IN VARCHAR2) RETURN VARCHAR2 IS
    LV_TECNO VARCHAR2(100);
  BEGIN
    SELECT DISTINCT TRS.TRSV_TECNOLOGIA
      INTO LV_TECNO
      FROM OPERACION.SGAT_TRS_VISITA_TECNICA TRS
     WHERE TRS.TRSN_COD_ID   = P_COD_ID
       AND TRS.TRSV_TIPO_SRV = P_SERV;
    RETURN LV_TECNO;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN NULL;
  END;

  /*'****************************************************************
  '* Nombre FUN: SGAFUN_GET_TIPO
  '* Proposito : La función se encarga de consultar el tipo de tecnología de los servicios contratados actualmente.
  '* Input :   <P_CODSOLOT>      - Codigo de SOLOT.
  '* Output :  <LN_RETURN>       - tecnologia.
  '* Creado por                : Team Dev
  '* Fecha de Creacion         : 02/03/2020.
  '* Actualizado por           : ----
  '* Fecha de Actualizacion    : ----
  '*****************************************************************/ 
  FUNCTION SGAFUN_GET_TIPO(P_CODSOLOT OPERACION.SOLOT.CODSOLOT%TYPE)
    RETURN VARCHAR2 IS
    LN_TECNOLOGIA  VARCHAR2(20);
    LV_MSJ_RES     VARCHAR2(4000);
  BEGIN

    SELECT CONF.CODIGOC
      INTO LN_TECNOLOGIA
      FROM OPERACION.SOLOT S,
           (SELECT O.CODIGON, O.CODIGOC
              FROM TIPOPEDD T, OPEDD O
             WHERE T.TIPOPEDD = O.TIPOPEDD
               AND T.ABREV = 'CONF_TIPTRA_TRAN') CONF
     WHERE S.TIPTRA   = CONF.CODIGON
       AND S.CODSOLOT = P_CODSOLOT;
    RETURN LN_TECNOLOGIA;
  EXCEPTION
    WHEN OTHERS THEN
      LV_MSJ_RES := $$PLSQL_UNIT || '.SGAFUN_GET_TIPO: ';
      LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(-) P_CODSOLOT =      ' || TO_CHAR(P_CODSOLOT);
      LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(*) Codigo de Error:  ' || TO_CHAR(SQLCODE);
      LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(*) Linea de Error:   ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(*) Mensaje de Error: ' || SQLERRM;
      RAISE_APPLICATION_ERROR(-20000, LV_MSJ_RES);
  END;

  /*'****************************************************************
  '* Nombre FUN: SGAFUN_GET_TIPTRA
  '* Proposito : La función devuelve el tipo de  trabajo configurado para la transacción de Migracion de Plan.
  '* Input :   <P_CODSOLOT>      - Codigo de SOLOT.
  '* Output :  <LN_RETURN>       - tipo de trabajo.
  '* Creado por                : Team Dev
  '* Fecha de Creacion         : 02/03/2020.
  '* Actualizado por           : ----
  '* Fecha de Actualizacion    : ----
  '*****************************************************************/ 
  FUNCTION SGAFUN_GET_TIPTRA(P_CODSOLOT OPERACION.SOLOT.CODSOLOT%TYPE) RETURN NUMBER IS
    LN_TIPTRA       OPERACION.TIPTRABAJO.TIPTRA%TYPE;
    LN_TECNOLOGIA   VARCHAR2(20);
    LV_MSJ_RES      VARCHAR2(4000);
  BEGIN
    SELECT CONF.CODIGOC
      INTO LN_TECNOLOGIA
      FROM OPERACION.SOLOT S,
           (SELECT O.CODIGON, O.CODIGOC
              FROM OPERACION.TIPOPEDD T,
                   OPERACION.OPEDD O
             WHERE T.TIPOPEDD = O.TIPOPEDD
               AND T.ABREV = 'CONF_TIPTRA_TRAN') CONF
     WHERE S.TIPTRA   = CONF.CODIGON
       AND S.CODSOLOT = P_CODSOLOT;

    SELECT O.CODIGON
      INTO LN_TIPTRA
      FROM OPERACION.TIPOPEDD T,
           OPERACION.OPEDD O
     WHERE T.TIPOPEDD    = O.TIPOPEDD
       AND T.ABREV       = 'CONF_TIPTRA_UNIF'
       AND O.ABREVIACION = 'MIGRACION'
       AND O.CODIGOC     = LN_TECNOLOGIA;
    RETURN LN_TIPTRA;
  EXCEPTION
    WHEN OTHERS THEN
      LV_MSJ_RES := $$PLSQL_UNIT || '.SGAFUN_GET_TIPTRA: ';
      LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(-) P_CODSOLOT    =   ' || P_CODSOLOT;
      LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(*) Codigo de Error:  ' || TO_CHAR(SQLCODE);
      LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(*) Linea de Error:   ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(*) Mensaje de Error: ' || SQLERRM;
      RAISE_APPLICATION_ERROR(-20000, LV_MSJ_RES);
  END;

  /*'****************************************************************
  '* Nombre FUN: SGAFUN_GET_CODMOTOT
  '* Proposito : La función devuelve el código de Motot configurado para la transacción de Migracion de Plan.
  '* Input :   <P_TIPO>        - Tecnologia.
               <P_OPCION>      - Flag de Visita Tecnica.
  '* Output :  <LN_RETURN>     - codigo de Motot.
  '* Creado por                : Team Dev
  '* Fecha de Creacion         : 02/03/2020.
  '* Actualizado por           : ----
  '* Fecha de Actualizacion    : ----
  '*****************************************************************/ 
  FUNCTION SGAFUN_GET_CODMOTOT(P_TIPO VARCHAR2, P_OPCION NUMBER)
    RETURN NUMBER IS
    LN_CODMOTOT         NUMBER;
    LV_MSJ_RES          VARCHAR2(4000);
  BEGIN

    SELECT O.CODIGON
      INTO LN_CODMOTOT
      FROM OPERACION.OPEDD O,
           OPERACION.TIPOPEDD T
     WHERE O.TIPOPEDD    = T.TIPOPEDD
       AND T.ABREV       = 'CONF_MOTOT_UNIF'
       AND O.CODIGOC     = P_TIPO
       AND O.CODIGON_AUX = P_OPCION;

    RETURN LN_CODMOTOT;
  EXCEPTION
    WHEN OTHERS THEN
      LV_MSJ_RES := $$PLSQL_UNIT || '.SGAFUN_GET_CODMOTOT: ';
      LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(-) P_TIPO =          ' || P_TIPO;
      LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(-) P_OPCION =        ' || P_OPCION;
      LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(*) Codigo de Error:  ' || TO_CHAR(SQLCODE);
      LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(*) Linea de Error:   ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(*) Mensaje de Error: ' || SQLERRM;
      RAISE_APPLICATION_ERROR(-20000, LV_MSJ_RES);
  END;

  /*'****************************************************************
  '* Nombre FUN: SGAFUN_GET_SUBTIPO
  '* Proposito : La función devuelve el subtipo de trabajo de acuerdo a las validaciones realizadas y a las configuraciones.
  '* Input :   <P_CODSOLOT>    - Codigo de Solot.
               <P_COD_ID>      - Codigo del Contrato en BSCS.
               <P_TIPTRA>      - Tipo de Trabajo.
  '* Output :  <LN_RETURN>     - Sub tipo.
  '* Creado por                : Team Dev
  '* Fecha de Creacion         : 02/03/2020.
  '* Actualizado por           : ----
  '* Fecha de Actualizacion    : ----
  '*****************************************************************/ 
  FUNCTION SGAFUN_GET_SUBTIPO(P_CODSOLOT OPERACION.SOLOT.CODSOLOT%TYPE,
                              P_COD_ID   OPERACION.SOLOT.COD_ID%TYPE,
                              P_TIPTRA   OPERACION.TIPTRABAJO.TIPTRA%TYPE)
    RETURN VARCHAR2 IS

    LV_TMP               VARCHAR2(4000);
    LN_GCNT_CTV_OLD      NUMBER;
    LV_CODEQUCOM_OLD     SALES.VTAEQUCOM.CODEQUCOM%TYPE;
    LV_CODEQUCOM_NEW     SALES.VTAEQUCOM.CODEQUCOM%TYPE;
    LV_RETIRA_DECO       VARCHAR2(100) := 'RDECO'; --'RETIRAR DECOS';
    LV_INSTALA_M2_DECO   VARCHAR2(100) := 'IM2D'; --'INSTALAR MAYOR A 02 DECOS';
    LV_INSTALA_H2_DECO   VARCHAR2(100) := 'IH2D'; --'INSTALAR HASTA 02 DECOS';
    LV_RETIRA_TELEFONIA  VARCHAR2(100) := 'RTLF'; --'RETIRAR TELEFONIA';
    LV_INSTALA_TELEFONIA VARCHAR2(100) := 'ITLF'; --'INSTALAR TELEFONIA';
    LV_RETIRA_INTERNET   VARCHAR2(100) := 'RINT'; --'RETIRAR INTERNET';
    LV_INSTALA_INTERNET  VARCHAR2(100) := 'IINT'; --'INSTALAR INTERNET';
    LV_CEMTA             VARCHAR2(100) := 'CEMTA'; --'CAMBIO EMTA';
    LV_UNION             VARCHAR2(10) := '_'; --' + ';
    LV_CADENA_DECO_INS   VARCHAR2(100);
    LV_CADENA_DECO_DES   VARCHAR2(100);
    LV_CADENA_DECO       VARCHAR2(100);
    LV_CADENA_INT        VARCHAR2(100);
    LV_CADENA_TLF        VARCHAR2(100);
    LV_SUBTIPO           VARCHAR2(1000);
    CNT_EQU_INSTALA      NUMBER;
    TN_SERV              VALORES_SRV;
    LV_MSJ_RES           VARCHAR2(4000);
    ERROR_SUBTIPO        EXCEPTION;
    EXC_INTERNET         EXCEPTION;
    EXC_CODEQUCOM_NEW    EXCEPTION;

    CURSOR C_SUBTIPO IS
      SELECT COD_SUBTIPO_ORDEN
        FROM OPERACION.SUBTIPO_ORDEN_ADC
       WHERE ID_TIPO_ORDEN =
             (SELECT ID_TIPO_ORDEN FROM TIPTRABAJO WHERE TIPTRA = P_TIPTRA)
         AND UPPER(TRIM(COD_ALTERNO)) LIKE '%' || LV_CADENA_INT || '%'
      UNION
      SELECT COD_SUBTIPO_ORDEN
        FROM OPERACION.SUBTIPO_ORDEN_ADC
       WHERE ID_TIPO_ORDEN =
             (SELECT ID_TIPO_ORDEN FROM TIPTRABAJO WHERE TIPTRA = P_TIPTRA)
         AND UPPER(TRIM(COD_ALTERNO)) LIKE '%' || LV_CADENA_DECO || '%';

    CURSOR C_EQU_RETIRA IS
      SELECT EQ.TIP_EQ TIPO_EQUIPO, SUM(X.CANTIDAD) CANTIDAD
        FROM (SELECT DISTINCT IP.PID, IP.CODEQUCOM, IP.CANTIDAD
                FROM OPERACION.SOLOT    S,
                     OPERACION.SOLOTPTO SP,
                     OPERACION.INSPRD   IP,
                     OPERACION.INSSRV   IV
               WHERE S.CODSOLOT   = SP.CODSOLOT
                 AND SP.CODINSSRV = IV.CODINSSRV
                 AND IP.CODINSSRV = IV.CODINSSRV
                 AND S.CODSOLOT   = P_CODSOLOT
                 AND IV.TIPSRV    = CV_CABLE
                 AND IP.ESTINSPRD IN (1, 2)) X,
             SALES.VTAEQUCOM             EQ,
             OPERACION.EQUCOMXOPE        V,
             OPERACION.TIPEQU            TE
       WHERE NVL(X.CODEQUCOM, 'X') != 'X'
         AND X.CODEQUCOM  = EQ.CODEQUCOM
         AND EQ.CODEQUCOM = V.CODEQUCOM
         AND V.CODTIPEQU  = TE.CODTIPEQU
         AND TE.TIPO      = 'DECODIFICADOR'
       GROUP BY EQ.TIP_EQ
      MINUS
      SELECT X.TIP_EQ TIPO_EQUIPO, SUM(X.CANTIDAD) CANTIDAD
        FROM (SELECT DISTINCT EQ.TIP_EQ, SV.TRSV_CANTIDAD_EQU AS CANTIDAD
                FROM OPERACION.SGAT_TRS_VISITA_TECNICA SV,
                     OPERACION.TIPEQU                  TE,
                     SALES.VTAEQUCOM                   EQ,
                     OPERACION.EQUCOMXOPE              V
               WHERE TE.TIPEQU          = SV.TRSV_TIPEQU
                 AND TRIM(TE.CODTIPEQU) = SV.TRSV_CODTIPEQU
                 AND SV.TRSN_COD_ID     = P_COD_ID
                 AND EQ.CODEQUCOM       = V.CODEQUCOM
                 AND V.CODTIPEQU        = TE.CODTIPEQU
                 AND V.TIPEQU           = SV.TRSV_TIPEQU
                 AND TE.TIPO            = 'DECODIFICADOR') X
       GROUP BY X.TIP_EQ;

    CURSOR C_EQU_INSTALA IS
      SELECT X.TIP_EQ TIPO_EQUIPO, SUM(X.CANTIDAD) CANTIDAD
        FROM (SELECT DISTINCT EQ.TIP_EQ, SV.TRSV_CANTIDAD_EQU AS CANTIDAD
                FROM OPERACION.SGAT_TRS_VISITA_TECNICA SV,
                     OPERACION.TIPEQU                  TE,
                     SALES.VTAEQUCOM                   EQ,
                     OPERACION.EQUCOMXOPE              V
               WHERE TE.TIPEQU         = SV.TRSV_TIPEQU
                 AND TRIM(TE.CODTIPEQU) = SV.TRSV_CODTIPEQU
                 AND SV.TRSN_COD_ID     = P_COD_ID
                 AND EQ.CODEQUCOM       = V.CODEQUCOM
                 AND V.CODTIPEQU        = TE.CODTIPEQU
                 AND V.TIPEQU           = SV.TRSV_TIPEQU
                 AND TE.TIPO            = 'DECODIFICADOR') X
       GROUP BY X.TIP_EQ
      MINUS
      SELECT EQ.TIP_EQ, SUM(X.CANTIDAD) CANTIDAD
        FROM (SELECT DISTINCT IP.PID, IP.CODEQUCOM, IP.CANTIDAD
                FROM OPERACION.SOLOT    S,
                     OPERACION.SOLOTPTO SP,
                     OPERACION.INSPRD   IP,
                     OPERACION.INSSRV   IV
               WHERE S.CODSOLOT   = SP.CODSOLOT
                 AND SP.CODINSSRV = IV.CODINSSRV
                 AND IP.CODINSSRV = IV.CODINSSRV
                 AND S.CODSOLOT   = P_CODSOLOT
                 AND IV.TIPSRV    = CV_CABLE
                 AND IP.ESTINSPRD IN (1, 2)) X,
             SALES.VTAEQUCOM EQ,
             OPERACION.EQUCOMXOPE V,
             OPERACION.TIPEQU TE
       WHERE NVL(X.CODEQUCOM, 'X') != 'X'
         AND X.CODEQUCOM  = EQ.CODEQUCOM
         AND EQ.CODEQUCOM = V.CODEQUCOM
         AND V.CODTIPEQU  = TE.CODTIPEQU
         AND TE.TIPO      = 'DECODIFICADOR'
       GROUP BY EQ.TIP_EQ;

  BEGIN

    TN_SERV := SGAFUN_INICIA_VALORES(P_CODSOLOT, P_COD_ID);

    -- INI VALIDACIONES INT
    IF TN_SERV.LN_VAL_INT_NEW > 0 AND TN_SERV.LN_VAL_INT_OLD = 0 AND TN_SERV.LN_VAL_TLF_OLD = 0 THEN
      LV_CADENA_INT := LV_INSTALA_INTERNET;
    ELSIF TN_SERV.LN_VAL_INT_NEW = 0 AND TN_SERV.LN_VAL_INT_OLD > 0 AND TN_SERV.LN_VAL_TLF_NEW = 0 THEN
      LV_CADENA_INT := LV_RETIRA_INTERNET;
    ELSIF TN_SERV.LN_VAL_INT_NEW > 0 AND TN_SERV.LN_VAL_INT_OLD > 0 THEN
      LV_CODEQUCOM_OLD := SGAFUN_GET_CODEQU_OLD(P_CODSOLOT);

      SELECT S.TRSV_CODEQUCOM
        INTO LV_CODEQUCOM_NEW
        FROM OPERACION.SGAT_TRS_VISITA_TECNICA S,
             OPERACION.TIPEQU T
       WHERE S.TRSN_COD_ID   = P_COD_ID
         AND S.TRSV_TIPEQU   = T.TIPEQU
         AND S.TRSV_TIPO_SRV = CV_INT
         AND T.TIPO          != 'SMART CARD';

      IF SGAFUN_VAL_CFG_CODEQUCOM(NVL(LV_CODEQUCOM_NEW, 'X'), NVL(LV_CODEQUCOM_OLD, 'X')) = 1 AND
         LV_CODEQUCOM_NEW != LV_CODEQUCOM_OLD THEN
         LV_CADENA_INT    := LV_CEMTA;
      END IF;
    END IF;
    -- FIN VALIDACIONES INT

    -- INI VALIDACIONES TLF
    IF TN_SERV.LN_VAL_TLF_NEW > 0 AND TN_SERV.LN_VAL_TLF_OLD = 0 THEN
      LV_CADENA_TLF := LV_INSTALA_TELEFONIA;
    ELSIF TN_SERV.LN_VAL_TLF_NEW = 0 AND TN_SERV.LN_VAL_TLF_OLD > 0 THEN
      LV_CADENA_TLF := LV_RETIRA_TELEFONIA;
    END IF;
    -- FIN VALIDACIONES TLF

    -- CANTIDAD DE EQUIPOS SERV ANTERIOR CTV
    SELECT SUM(X.CANTIDAD)
      INTO LN_GCNT_CTV_OLD
      FROM (SELECT DISTINCT IP.PID, IP.CODEQUCOM, IP.CANTIDAD
              FROM OPERACION.SOLOT    S,
                   OPERACION.SOLOTPTO SP,
                   OPERACION.INSPRD   IP,
                   OPERACION.INSSRV   IV
             WHERE S.CODSOLOT   = SP.CODSOLOT
               AND SP.CODINSSRV = IV.CODINSSRV
               AND IP.CODINSSRV = IV.CODINSSRV
               AND S.CODSOLOT   = P_CODSOLOT
               AND IV.TIPSRV    = CV_CABLE
               AND IP.ESTINSPRD IN (1, 2)) X
     WHERE NVL(X.CODEQUCOM, 'X') != 'X';

    -- INI DECO
    -- SRV NEW NO TIENE SRV OLD TIENE -> RETIRO NO COMPARO CANTIDAD
    IF (TN_SERV.LN_CNT_CTV_NEW > 0 AND TN_SERV.LN_CNT_CTV_OLD > 0) THEN
      IF TN_SERV.LN_VAL_CTV_OLD > 0 AND TN_SERV.LN_VAL_CTV_NEW = 0 THEN
        LV_CADENA_DECO := LV_RETIRA_DECO;
      ELSIF TN_SERV.LN_VAL_CTV_OLD = 0 AND TN_SERV.LN_VAL_CTV_NEW > 0 THEN
        IF (NVL(TN_SERV.LN_CNT_CTV_NEW, 0)) > 2 THEN
          LV_CADENA_DECO := LV_INSTALA_M2_DECO;
        ELSE
          LV_CADENA_DECO := LV_INSTALA_H2_DECO;
        END IF;
      ELSIF TN_SERV.LN_VAL_CTV_OLD > 0 AND TN_SERV.LN_VAL_CTV_NEW > 0 THEN
        -- ARMANDO CADENA DECOS INSTALA
        CNT_EQU_INSTALA := 0;
        FOR C IN C_EQU_INSTALA LOOP
          CNT_EQU_INSTALA := CNT_EQU_INSTALA + C.CANTIDAD;
        END LOOP;
        IF (NVL(CNT_EQU_INSTALA, 0)) > 2 THEN
          LV_CADENA_DECO_INS := LV_INSTALA_M2_DECO;
        ELSE
          LV_CADENA_DECO_INS := LV_INSTALA_H2_DECO;
        END IF;
        FOR R IN C_EQU_RETIRA LOOP
          IF (NVL(R.CANTIDAD, 0)) > 0 THEN
            LV_CADENA_DECO_DES := LV_RETIRA_DECO;
          END IF;
        END LOOP;
        IF NVL(LV_CADENA_DECO_INS, 'X') != 'X' THEN
          IF NVL(LV_CADENA_DECO_DES, 'X') != 'X' THEN
            LV_CADENA_DECO := LV_CADENA_DECO_INS || LV_UNION || LV_CADENA_DECO_DES;
          ELSE
            LV_CADENA_DECO := LV_CADENA_DECO_INS;
          END IF;
        END IF;
      END IF;
    END IF;
    -- FIN DECO
    -- ARMANDO LA DESCRIPCION
    IF NVL(LV_CADENA_DECO, 'X') != 'X' THEN
      IF NVL(LV_CADENA_INT, 'X') != 'X' THEN
        IF NVL(LV_CADENA_TLF, 'X') != 'X' THEN
          LV_TMP := LV_CADENA_DECO || LV_UNION || LV_CADENA_INT || LV_UNION || LV_CADENA_TLF;
        ELSE
          LV_TMP := LV_CADENA_DECO || LV_UNION || LV_CADENA_INT;
        END IF;
      ELSE
        LV_TMP := LV_CADENA_DECO;
      END IF;
    END IF;
    -- CREAR UN FUNCION QUE DEVUELVA EL SUBTIPO ORDEN
    --SGASI_LOG_POST_SIAC(AV_COD_ID, NULL, 'SUBTIPO_ALTERNO_VISIT_CP', LV_TMP);
    -----
    BEGIN
      SELECT COD_SUBTIPO_ORDEN
        INTO LV_SUBTIPO
        FROM OPERACION.SUBTIPO_ORDEN_ADC
       WHERE COD_ALTERNO   = LV_TMP
         AND ID_TIPO_ORDEN = (SELECT ID_TIPO_ORDEN
                                FROM OPERACION.TIPTRABAJO
                               WHERE TIPTRA = P_TIPTRA);
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        FOR REG IN C_SUBTIPO LOOP
          IF NVL(LV_SUBTIPO, 'X') != 'X' THEN
            LV_SUBTIPO := LV_SUBTIPO || '|' || REG.COD_SUBTIPO_ORDEN;
          ELSE
            LV_SUBTIPO := REG.COD_SUBTIPO_ORDEN;
          END IF;
        END LOOP;
      WHEN OTHERS THEN
        LV_SUBTIPO := '';
    END;
    RETURN LV_SUBTIPO;
  EXCEPTION
    WHEN OTHERS THEN
      LV_MSJ_RES := $$PLSQL_UNIT || '.SGAFUN_GET_SUBTIPO: ';
      LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(-) P_CODSOLOT =      ' || TO_CHAR(P_CODSOLOT);
      LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(-) P_COD_ID =        ' || TO_CHAR(P_COD_ID);
      LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(-) P_TIPTRA =        ' || TO_CHAR(P_TIPTRA);
      LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(*) Codigo de Error:  ' || TO_CHAR(SQLCODE);
      LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(*) Linea de Error:   ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(*) Mensaje de Error: ' || SQLERRM;
      RAISE_APPLICATION_ERROR(-20000, LV_MSJ_RES);
  END;

  /*'****************************************************************
  '* Nombre FUN: SGAFUN_GET_ANOTACION
  '* Proposito : La Funcion devuelve las especificaciones de los trabajos que se van a 
                 realizar de acuerdo a los servicios o equipos seleccionados.
  '* Input :   <P_CODSOLOT>    - Codigo de Solot.
               <P_COD_ID>      - Codigo del Contrato en BSCS.
  '* Output :  <LN_RETURN>     - Anotacion.
  '* Creado por                : Team Dev
  '* Fecha de Creacion         : 02/03/2020.
  '* Actualizado por           : ----
  '* Fecha de Actualizacion    : ----
  '*****************************************************************/ 
  FUNCTION SGAFUN_GET_ANOTACION(P_CODSOLOT OPERACION.SOLOT.CODSOLOT%TYPE,
                                P_COD_ID   OPERACION.SOLOT.COD_ID%TYPE)
    RETURN VARCHAR2 IS

    LN_VAL_VEL_INT NUMBER;
    LN_COD_RESP    NUMBER;
    LV_MSJ_RES     VARCHAR2(4000);
    ERROR_GENERAL EXCEPTION;

    CURSOR C_EQU_SGA_CP IS
      SELECT EQ.TIP_EQ, SUM(X.CANTIDAD) CANTIDAD
        FROM (SELECT DISTINCT IP.PID, IP.CODEQUCOM, IP.CANTIDAD
                FROM OPERACION.SOLOT    S,
                     OPERACION.SOLOTPTO SP,
                     OPERACION.INSPRD   IP,
                     OPERACION.INSSRV   IV
               WHERE S.CODSOLOT   = SP.CODSOLOT
                 AND SP.CODINSSRV = IV.CODINSSRV
                 AND IP.CODINSSRV = IV.CODINSSRV
                 AND S.CODSOLOT   = P_CODSOLOT
                 AND IV.TIPSRV    = CV_CABLE
                 AND IP.ESTINSPRD IN (1, 2)) X,
             SALES.VTAEQUCOM             EQ,
             OPERACION.EQUCOMXOPE        V,
             OPERACION.TIPEQU            TE
       WHERE NVL(X.CODEQUCOM, 'X') != 'X'
         AND X.CODEQUCOM  = EQ.CODEQUCOM
         AND EQ.CODEQUCOM = V.CODEQUCOM
         AND V.CODTIPEQU  = TE.CODTIPEQU
         AND TE.TIPO      = 'DECODIFICADOR'
       GROUP BY EQ.TIP_EQ
       ORDER BY EQ.TIP_EQ;

    CURSOR C_EQU_PVU IS
      SELECT X.TIP_EQ TIP_EQ_NEW, SUM(X.CANTIDAD) CANTIDAD
        FROM (SELECT T.TIP_EQ,
                     O.TRSV_CODEQUCOM    CODEQUCOM_NEW,
                     O.TRSV_CANTIDAD_EQU CANTIDAD
                FROM OPERACION.SGAT_TRS_VISITA_TECNICA O,
                     SALES.VTAEQUCOM T
               WHERE T.CODEQUCOM     = O.TRSV_CODEQUCOM
                 AND O.TRSN_COD_ID   = P_COD_ID
                 AND O.TRSV_TIPO_SRV = CV_CTV) X
       GROUP BY X.TIP_EQ;

    CURSOR C_SERV_V IS
      SELECT V.TRSV_CANTIDAD_EQU, V.TRSV_CODSRV
        FROM OPERACION.SGAT_TRS_VISITA_TECNICA V
       WHERE V.TRSN_COD_ID   = P_COD_ID
         AND V.TRSV_TIPO_SRV = CV_INT;

    LV_CODEQUCOM_OLD SALES.VTAEQUCOM.CODEQUCOM%TYPE;
    LV_CODEQUCOM_NEW SALES.VTAEQUCOM.CODEQUCOM%TYPE;
    EXC_INTERNET      EXCEPTION;
    EXC_CODEQUCOM_NEW EXCEPTION;
    LV_INSTALAR       VARCHAR2(4000);
    LV_DESINSTALAR    VARCHAR2(4000);
    LV_CADENA         VARCHAR2(4000);
    L_CADENA          VARCHAR(4000);
    L_CADENA2         VARCHAR(4000);
    FLG_IGUAL         NUMBER;
    LN_SERVICIOS      VALORES_SRV;
    LV_UPGRADE        VARCHAR2(4000);
    LV_DOWNGRADE      VARCHAR2(4000);
    LV_SERVICIOS      VARCHAR2(4000);
    LV_UPGRADE_CAD    VARCHAR2(4000);
    LV_DOWNGRADE_CAD  VARCHAR2(4000);
    LN_FLAG_VISIT_TEC NUMBER;

  BEGIN
    /* Inicio Carga Inicial de Datos */
    LN_SERVICIOS := SGAFUN_INICIA_VALORES(P_CODSOLOT, P_COD_ID);
    /* Fin    Carga Inicial de Datos */
    IF LN_SERVICIOS.LN_VAL_INT_NEW > 0 AND LN_SERVICIOS.LN_VAL_INT_OLD = 0 AND LN_SERVICIOS.LN_VAL_TLF_OLD = 0 THEN
      LV_INSTALAR := SGAFUN_GET_NOMBRE_EQU(SGAFUN_GET_CODEQU_NEW(P_COD_ID));
    ELSIF LN_SERVICIOS.LN_VAL_INT_NEW = 0 AND LN_SERVICIOS.LN_VAL_INT_OLD > 0 AND LN_SERVICIOS.LN_VAL_TLF_NEW = 0 THEN
      LV_DESINSTALAR := SGAFUN_GET_NOMBRE_EQU(SGAFUN_GET_CODEQU_OLD(P_CODSOLOT));
    ELSIF LN_SERVICIOS.LN_VAL_INT_NEW > 0 AND LN_SERVICIOS.LN_VAL_INT_OLD > 0 THEN
      LN_FLAG_VISIT_TEC := OPERACION.PQ_SGA_JANUS.F_GET_CONSTANTE_CONF('VAL_VISITA_TEC');
      IF LN_FLAG_VISIT_TEC > 0 AND LN_SERVICIOS.LN_TEC_INT_NEW = TEC_HFC THEN
        SGASS_VELOCIDAD_HFC(P_COD_ID, P_CODSOLOT, LN_VAL_VEL_INT, LN_COD_RESP, LV_MSJ_RES);
        IF LN_VAL_VEL_INT > 0 THEN
          LV_INSTALAR    := SGAFUN_GET_NOMBRE_EQU(SGAFUN_GET_CODEQU_NEW(P_COD_ID));
          LV_DESINSTALAR := SGAFUN_GET_NOMBRE_EQU(SGAFUN_GET_CODEQU_OLD(P_CODSOLOT));
        END IF;
        IF LN_VAL_VEL_INT = 2 THEN
          --Registra en el Log
          NULL;
        END IF;
      ELSE
        LV_CODEQUCOM_OLD := SGAFUN_GET_CODEQU_OLD(P_CODSOLOT);
        LV_CODEQUCOM_NEW := SGAFUN_GET_CODEQU_NEW(P_COD_ID);
        IF SGAFUN_VAL_CFG_CODEQUCOM(NVL(LV_CODEQUCOM_NEW, 'X'), NVL(LV_CODEQUCOM_OLD, 'X')) = 1 AND LV_CODEQUCOM_NEW != LV_CODEQUCOM_OLD THEN
          LV_INSTALAR    := SGAFUN_GET_NOMBRE_EQU(SGAFUN_GET_CODEQU_NEW(P_COD_ID));
          LV_DESINSTALAR := SGAFUN_GET_NOMBRE_EQU(SGAFUN_GET_CODEQU_OLD(P_CODSOLOT));
        END IF;
      END IF;
    END IF;

    L_CADENA  := '';
    L_CADENA2 := '';
    FLG_IGUAL := 0;
    IF LN_SERVICIOS.LN_CNT_CTV_NEW > 0 AND LN_SERVICIOS.LN_CNT_CTV_OLD > 0 THEN
      IF LN_SERVICIOS.LN_VAL_CTV_NEW > 0 THEN
        FOR C IN C_EQU_PVU LOOP
          FOR X IN C_EQU_SGA_CP LOOP
            IF C.TIP_EQ_NEW = X.TIP_EQ THEN
              IF (C.CANTIDAD - X.CANTIDAD) > 0 THEN
                L_CADENA2 := SGAFUN_FORMAT_VACIO(L_CADENA2) ||
                             (C.CANTIDAD - X.CANTIDAD) || ' ' || SGAFUN_CHANGE_CADENA(C.TIP_EQ_NEW,  CV_ABUSCAR, CV_AREEMPLAZAR);
              END IF;
              FLG_IGUAL := 1;
            END IF;
          END LOOP;

          IF FLG_IGUAL != 1 THEN
            L_CADENA := SGAFUN_FORMAT_VACIO(L_CADENA) || C.CANTIDAD || ' ' || SGAFUN_CHANGE_CADENA(C.TIP_EQ_NEW, CV_ABUSCAR, CV_AREEMPLAZAR);
          END IF;
          FLG_IGUAL := 0;
        END LOOP;
        LV_INSTALAR := SGAFUN_FORMAT_VACIO(LV_INSTALAR) || L_CADENA || L_CADENA2;
      END IF;

      L_CADENA  := '';
      L_CADENA2 := '';
      FLG_IGUAL := 0;

      IF LN_SERVICIOS.LN_VAL_CTV_OLD > 0 THEN
        FOR C IN C_EQU_SGA_CP LOOP
          FOR X IN C_EQU_PVU LOOP
            IF C.TIP_EQ = X.TIP_EQ_NEW THEN
              IF (C.CANTIDAD - X.CANTIDAD) > 0 THEN
                L_CADENA2 := SGAFUN_FORMAT_VACIO(L_CADENA2) ||
                             (C.CANTIDAD - X.CANTIDAD) || ' ' || SGAFUN_CHANGE_CADENA(C.TIP_EQ, CV_ABUSCAR, CV_AREEMPLAZAR);
              END IF;
              FLG_IGUAL := 1;
            END IF;
          END LOOP;
          IF FLG_IGUAL != 1 THEN
            L_CADENA := SGAFUN_FORMAT_VACIO(L_CADENA) || C.CANTIDAD || ' ' || SGAFUN_CHANGE_CADENA(C.TIP_EQ, CV_ABUSCAR, CV_AREEMPLAZAR);
          END IF;
          FLG_IGUAL := 0;
        END LOOP;
        LV_DESINSTALAR := SGAFUN_FORMAT_VACIO(LV_DESINSTALAR) || L_CADENA || L_CADENA2;
      END IF;
    END IF;
    IF LENGTH(LV_DESINSTALAR) > 0 THEN
      LV_DESINSTALAR := 'RETIRAR: ' || LV_DESINSTALAR || '; ' || CHR(13);
    END IF;
    IF LENGTH(LV_INSTALAR) > 0 THEN
      LV_INSTALAR := 'INSTALAR: ' || LV_INSTALAR || '; ' || CHR(13);
    END IF;
    LV_CADENA := LV_DESINSTALAR || LV_INSTALAR;
    IF LN_SERVICIOS.LN_VAL_INT_NEW > 0 AND LN_SERVICIOS.LN_VAL_INT_OLD > 0 THEN
      FOR IDX IN C_SERV_V LOOP
        SGASS_DESC_INTERNET(P_CODSOLOT, IDX.TRSV_CODSRV, LN_VAL_VEL_INT, LN_COD_RESP, LV_MSJ_RES);
        IF LN_COD_RESP != 0 THEN
          RAISE ERROR_GENERAL;
        END IF;
        IF LN_VAL_VEL_INT > 0 THEN
          LV_UPGRADE := 'UPGRADE: ' || TO_CHAR(LN_SERVICIOS.LN_DES_INT_OLD) ||
                        ' - A - ' || TO_CHAR(LN_SERVICIOS.LN_DES_INT_NEW) || '; ' ||
                        CHR(13);
        ELSE
          LV_DOWNGRADE := 'DOWNGRADE: ' ||
                          TO_CHAR(LN_SERVICIOS.LN_DES_INT_OLD) || ' - A - ' ||
                          TO_CHAR(LN_SERVICIOS.LN_DES_INT_NEW) || '; ' || CHR(13);
        END IF;
        LV_UPGRADE_CAD   := LV_UPGRADE_CAD || LV_UPGRADE;
        LV_DOWNGRADE_CAD := LV_DOWNGRADE_CAD || LV_DOWNGRADE;
      END LOOP;
    END IF;
    LV_SERVICIOS := LV_UPGRADE_CAD || LV_DOWNGRADE_CAD;
    LV_CADENA    := LV_DESINSTALAR || LV_INSTALAR || LV_SERVICIOS;
    RETURN LV_CADENA;
  EXCEPTION
    WHEN ERROR_GENERAL THEN
      LV_MSJ_RES := $$PLSQL_UNIT || '.SGAFUN_GET_ANOTACION: ';
      LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(-) P_CODSOLOT =      ' || TO_CHAR(P_CODSOLOT);
      LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(-) P_COD_ID =        ' || TO_CHAR(P_COD_ID);
      LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(*) Codigo de Error:  ' || TO_CHAR(SQLCODE);
      LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(*) Linea de Error:   ' || TRIM(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
      LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(*) Mensaje de Error: ' || SQLERRM;
      RAISE_APPLICATION_ERROR(-20000, LV_MSJ_RES);
    WHEN OTHERS THEN
      LV_MSJ_RES := $$PLSQL_UNIT || '.SGAFUN_GET_ANOTACION: ';
      LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(-) P_CODSOLOT =      ' || TO_CHAR(P_CODSOLOT);
      LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(-) P_COD_ID =        ' || TO_CHAR(P_COD_ID);
      LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(*) Codigo de Error:  ' || TO_CHAR(SQLCODE);
      LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(*) Linea de Error:   ' || TRIM(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
      LV_MSJ_RES := LV_MSJ_RES || CHR(13) || '(*) Mensaje de Error: ' || SQLERRM;
      RAISE_APPLICATION_ERROR(-20000, LV_MSJ_RES);
  END;

  /*'****************************************************************
  '* Nombre FUN: SGAFUN_GET_CODEQU_OLD
  '* Proposito : La función devuelve el código de equipo de los  servicios contratados actualmente.
  '* Input :   <P_CODSOLOT>    - Codigo de Solot.
  '* Output :  <LN_RETURN>     - Codigo del Equipo Actusl.
  '* Creado por                : Team Dev
  '* Fecha de Creacion         : 02/03/2020.
  '* Actualizado por           : ----
  '* Fecha de Actualizacion    : ----
  '*****************************************************************/ 
  FUNCTION SGAFUN_GET_CODEQU_OLD(P_CODSOLOT OPERACION.SOLOT.CODSOLOT%TYPE)
    RETURN VARCHAR2 IS
    LV_CODEQUCOM_OLD SALES.VTAEQUCOM.CODEQUCOM%TYPE;
  BEGIN
    SELECT DISTINCT V.CODEQUCOM
      INTO LV_CODEQUCOM_OLD
      FROM (SELECT DISTINCT IP.PID, IP.CODEQUCOM, IP.CANTIDAD
              FROM OPERACION.SOLOT    S,
                   OPERACION.SOLOTPTO SP,
                   OPERACION.INSPRD   IP,
                   OPERACION.INSSRV   IV
             WHERE S.CODSOLOT   = SP.CODSOLOT
               AND SP.CODINSSRV = IV.CODINSSRV
               AND IP.CODINSSRV = IV.CODINSSRV
               AND S.CODSOLOT   = P_CODSOLOT) X,
           SALES.VTAEQUCOM             V,
           OPERACION.EQUCOMXOPE        EQ,
           OPERACION.TIPEQU            TE
     WHERE NVL(X.CODEQUCOM, 'X') != 'X'
       AND X.CODEQUCOM  = V.CODEQUCOM
       AND V.CODEQUCOM  = EQ.CODEQUCOM
       AND EQ.CODTIPEQU = TE.CODTIPEQU
       AND TE.TIPO      IN ('EMTA', 'CPE')
       AND V.TIP_EQ     IS NOT NULL;

    RETURN LV_CODEQUCOM_OLD;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN NULL;
  END;

  /*'****************************************************************
  '* Nombre FUN: SGAFUN_GET_NOMBRE_EQU
  '* Proposito : La función devuelve la descripción del equipo.
  '* Input :   <P_CODEQUCOM>    - Codigo de Equipo.
  '* Output :  <LN_RETURN>     - Descripcion del Equipo.
  '* Creado por                : Team Dev
  '* Fecha de Creacion         : 02/03/2020.
  '* Actualizado por           : ----
  '* Fecha de Actualizacion    : ----
  '*****************************************************************/ 
  FUNCTION SGAFUN_GET_NOMBRE_EQU(P_CODEQUCOM SALES.VTAEQUCOM.CODEQUCOM%TYPE)
    RETURN SALES.VTAEQUCOM.DSCEQU%TYPE IS
    LV_DESCEQU VTAEQUCOM.DSCEQU%TYPE;
  BEGIN
    SELECT V.DSCEQU
      INTO LV_DESCEQU
      FROM SALES.VTAEQUCOM V
     WHERE V.CODEQUCOM = P_CODEQUCOM;
    RETURN LV_DESCEQU;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN NULL;
  END;

  /*'****************************************************************
  '* Nombre FUN: SGAFUN_GET_CODEQU_NEW
  '* Proposito : La función devuelve el código de equipo de los  servicios seleccionados en el front.
  '* Input :   <P_COD_ID>      - Codigo del Contrato en BSCS.
  '* Output :  <LN_RETURN>     - Codigo del Equipo.
  '* Creado por                : Team Dev
  '* Fecha de Creacion         : 02/03/2020.
  '* Actualizado por           : ----
  '* Fecha de Actualizacion    : ----
  '*****************************************************************/ 
  FUNCTION SGAFUN_GET_CODEQU_NEW(P_COD_ID OPERACION.SOLOT.COD_ID%TYPE)
    RETURN VARCHAR2 IS
    LV_CODEQUCOM OPERACION.SGAT_TRS_VISITA_TECNICA.TRSV_CODEQUCOM%TYPE;
  BEGIN
    SELECT S.TRSV_CODEQUCOM
      INTO LV_CODEQUCOM
      FROM OPERACION.SGAT_TRS_VISITA_TECNICA S,
           OPERACION.TIPEQU T
     WHERE S.TRSV_TIPEQU   = T.TIPEQU
       AND S.TRSN_COD_ID   = P_COD_ID
       AND S.TRSV_TIPO_SRV = CV_INT
       AND T.TIPO          != 'SMART CARD';
    RETURN LV_CODEQUCOM;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN NULL;
  END;

  /*'****************************************************************
  '* Nombre FUN: SGAFUN_GET_SRVSNCODE
  '* Proposito : La función consulta el sncode en la tabla de servicios y además consulta un dblink a 
                 una función del bscs que devuelve el cargo fijo del servicio.
  '* Input :   <P_COD_ID>      - Codigo del Contrato en BSCS.
               <P_CODSRV>      - Codigo del Servicio.
  '* Output :  <LN_RETURN>     - Cargo del Servicio.
  '* Creado por                : Team Dev
  '* Fecha de Creacion         : 02/03/2020.
  '* Actualizado por           : ----
  '* Fecha de Actualizacion    : ----
  '*****************************************************************/ 
  FUNCTION SGAFUN_GET_SRVSNCODE(P_COD_ID OPERACION.SOLOT.COD_ID%TYPE,
                                P_CODSRV SALES.TYSTABSRV.CODSRV%TYPE)
    RETURN FLOAT IS
    LF_CARGO FLOAT;
  BEGIN
    SELECT TIM.TFUN115_CARGOFIJO_X_SERV@DBL_BSCS_BF(P_COD_ID, T.TYSTV_SNCODE)
      INTO LF_CARGO
      FROM SALES.TYSTABSRV T
     WHERE T.CODSRV = P_CODSRV;
    RETURN LF_CARGO;

  EXCEPTION
    WHEN OTHERS THEN
      RETURN 0;
  END;

  /*'****************************************************************
  '* Nombre FUN: SGAFUN_FORMAT_VACIO
  '* Proposito : La función es utilizada para trabajar con las Cadenas genera un espacio en blanco.
  '* Input :   <LV_CAD>        - Cadena.
  '* Output :  <LN_RETURN>     - Cadena.
  '* Creado por                : Team Dev
  '* Fecha de Creacion         : 02/03/2020.
  '* Actualizado por           : ----
  '* Fecha de Actualizacion    : ----
  '*****************************************************************/   
  FUNCTION SGAFUN_FORMAT_VACIO(LV_CAD VARCHAR2) RETURN VARCHAR2 IS
  BEGIN
    IF LENGTH(LV_CAD) > 0 THEN
      RETURN LV_CAD || ' + ';
    ELSE
      RETURN LV_CAD;
    END IF;
  END;
 
  /*'****************************************************************
  '* Nombre FUN: SGAFUN_FORMAT_VACIO
  '* Proposito : La función es utilizada para trabajar con las Cadenas reemplaza una cadena dentro de otra
  '* Input :   <PI_CADENA>     - Cadena Principal.
               <PI_A_BUSCAR>   - Cadena a Buscar.
               <PI_A_CAMBIAR>  - Cadena a Remmplazar.
  '* Output :  <LN_RETURN>     - Cadena.
  '* Creado por                : Team Dev
  '* Fecha de Creacion         : 02/03/2020.
  '* Actualizado por           : ----
  '* Fecha de Actualizacion    : ----
  '*****************************************************************/   
  FUNCTION SGAFUN_CHANGE_CADENA(PI_CADENA    VARCHAR2,
                                PI_A_BUSCAR  VARCHAR2,
                                PI_A_CAMBIAR VARCHAR2) RETURN VARCHAR2 IS
  BEGIN
    IF LENGTH(PI_CADENA) > 0 THEN
      IF INSTR(PI_CADENA, PI_A_BUSCAR, 1) > 0 THEN
        RETURN TRIM(REPLACE(PI_CADENA, PI_A_BUSCAR, PI_A_CAMBIAR));
      ELSE
        RETURN PI_CADENA;
      END IF;
    ELSE
      RETURN '';
    END IF;
  END;
  /* FIN    1.0 */
  
/****************************************************************
* Versión          : 1.0
* Nombre SP        : SGASS_CONS_CENTRO_POBLADO
* Propósito        : Consulta de los centros poblados que existen en un distrito.
* Input            :
                    ** iv_ubigeo             : Ubigeo
                    ** iv_idpoblado          : ID Poblado
* Input - Output   : -
* Output           :
                    ** oc_cen_poblados       : Cursor de centros poblados
                    ** on_codResp            : Código de respuesta
                    ** ov_msjResp            : Mensaje de respuesta
* Creado por       : Freddy Dick Salazar Valverde
* Fec Creación     : 26/02/2020
* Fec Actualización: -
'****************************************************************/

  
  procedure sgass_cons_centro_poblado(iv_ubigeo          in  varchar2,--ubigeo
                                      iv_idpoblado       in  varchar2,--poblado
                                      oc_cen_poblados    out sys_refcursor,
                                      on_codResp         out number,
                                      ov_msjResp         out varchar2) is
  ln_cant       number;
  begin
    open oc_cen_poblados for
      select trim(tp.idpoblado) idpoblado,trim(tp.idubigeo) ubigeo,trim(tp.codclasificacion) codclasificacion,tp.clasificacion,
             trim(tp.codcategoria) codcategoria,tp.categoria,tp.nombre,tp.poblacion,tp.cobertura,tp.cobertura_lte
      from pvt.tabpoblado@DBL_PVTDB tp
      where (trim(tp.idubigeo) = trim(iv_ubigeo) and trim(tp.idpoblado) = trim(iv_idpoblado)--ubigeo,poblado
            and iv_ubigeo is not null and iv_idpoblado is not null)
      or (trim(tp.idubigeo) = trim(iv_ubigeo)--ubigeo
            and iv_ubigeo is not null and iv_idpoblado is null)
      or (iv_ubigeo is null and iv_idpoblado is null)
      order by tp.nombre;
    
    select count(tp.idpoblado)
    into ln_cant
    from pvt.tabpoblado@DBL_PVTDB tp
      where (trim(tp.idubigeo) = trim(iv_ubigeo) and trim(tp.idpoblado) = trim(iv_idpoblado)--ubigeo,poblado
            and iv_ubigeo is not null and iv_idpoblado is not null)
      or (trim(tp.idubigeo) = trim(iv_ubigeo)--ubigeo
            and iv_ubigeo is not null and iv_idpoblado is null)
      or (iv_ubigeo is null and iv_idpoblado is null);
    
    if ln_cant > 0 then
      on_codResp := 0;
      ov_msjResp := 'OK';
    else
      on_codResp := 1;
      ov_msjResp := '[PKG_CONSULTA_UNIFICADA_SGA][SGASS_CONS_CENTRO_POBLADO] - No se encontraron registros para UBIGEO, IDPOBLADO: '||iv_ubigeo||', '||iv_idpoblado;
    end if;
    exception
       when others then
          on_codResp := -1;
          ov_msjResp := '[PKG_CONSULTA_UNIFICADA_SGA][SGASS_CONS_CENTRO_POBLADO] - Error al ejecutar procedimiento: '||sqlcode||': '||sqlerrm;
  end;
  
  
/****************************************************************
* Versión          : 1.0
* Nombre SP        : SGASS_CONS_UBICACION
* Propósito        : Consulta de los departamentos, provincias y distritos que existen
* Input            :
                    ** iv_codpai        : Código País (Si es nulo por defecto Perú)
* Input - Output   : -
* Output           :
                    ** oc_ubicaciones        : Cursor que contiene información de los distritos del país
                    ** on_codResp            : Código de respuesta
                    ** ov_msjResp            : Mensaje de respuesta
* Creado por       : Freddy Dick Salazar Valverde
* Fec Creación     : 26/02/2020
* Fec Actualización: -
'****************************************************************/
  
  procedure sgass_cons_ubicacion(iv_codpai          in  varchar2,--pais
                                 oc_ubicaciones     out sys_refcursor,
                                 on_codResp         out number,
                                 ov_msjResp         out varchar2)is
  ln_cant       number;
  begin
    open oc_ubicaciones for
      select trim(pa.codpai) codpai,trim(pa.abrev) abrev_pai,pa.nompai,trim(es.codest) codest,trim(es.nomabr) abrev_est,es.nomest,
      trim(pr.codpvc) codpvc,trim(pr.abrev) abrev_pvc,pr.nompvc,trim(di.coddst) coddst,di.nomdst,di.dist_desc,
      trim(di.codubi) codubi,trim(di.ubigeo) ubigeo,di.codpos,di.codpos2
      from marketing.vtatabpai pa, marketing.vtatabest es, marketing.vtatabpvc pr, marketing.vtatabdst di
      where trim(pa.codpai) = trim(es.codpai) and trim(pa.codpai) = trim(pr.codpai) and trim(pa.codpai) = trim(di.codpai)
      and trim(es.codest) = trim(pr.codest) and trim(es.codest) = trim(di.codest)
      and trim(pr.codpvc) = trim(di.codpvc)
      and ((trim(pa.codpai) 
      in (
      select distinct o.codigoc
      from tipopedd tp, opedd o
      where tp.abrev = 'TU_TIPO_PAISES'
      and tp.tipopedd = o.tipopedd
      and o.codigon = 1--estado
      ) and iv_codpai is null) or (trim(pa.codpai) = trim(iv_codpai) and iv_codpai is not null))
      order by pa.nompai,es.nomest,pr.nompvc,di.nomdst;
    
    select count(di.coddst)
    into ln_cant
    from marketing.vtatabpai pa, marketing.vtatabest es, marketing.vtatabpvc pr, marketing.vtatabdst di
    where trim(pa.codpai) = trim(es.codpai) and trim(pa.codpai) = trim(pr.codpai) and trim(pa.codpai) = trim(di.codpai)
    and trim(es.codest) = trim(pr.codest) and trim(es.codest) = trim(di.codest)
    and trim(pr.codpvc) = trim(di.codpvc)
    and ((trim(pa.codpai) 
    in (
    select distinct o.codigoc
    from tipopedd tp, opedd o
    where tp.abrev = 'TU_TIPO_PAISES'
    and tp.tipopedd = o.tipopedd
    and o.codigon = 1--estado
    ) and iv_codpai is null) or (trim(pa.codpai) = trim(iv_codpai) and iv_codpai is not null));
    
    if ln_cant > 0 then
      on_codResp := 0;
      ov_msjResp := 'OK';
    else
      on_codResp := 1;
      ov_msjResp := '[PKG_CONSULTA_UNIFICADA_SGA][SGASS_CONS_UBICACION] - No se encontraron registros para CODPAI: '||iv_codpai;
    end if;
    exception
       when others then
          on_codResp := -1;
          ov_msjResp := '[PKG_CONSULTA_UNIFICADA_SGA][SGASS_CONS_UBICACION] - Error al ejecutar procedimiento: '||sqlcode||': '||sqlerrm;
  end;
/****************************************************************
* Versión          : 1.0
* Nombre SP        : SGASS_CONS_TIP_URB
* Propósito        : Consulta de los tipos de urbanización que existen
* Input            :
                    ** iv_idtipurb           : Identificador del tipo de urbanizacion (Si es nulo consulta todos)
* Input - Output   : -
* Output           :
                    ** oc_tip_urbs           : Cursor de tipos de urbanizaciones
                    ** on_codResp            : Código de respuesta
                    ** ov_msjResp            : Mensaje de respuesta
* Creado por       : Freddy Dick Salazar Valverde
* Fec Creación     : 26/02/2020
* Fec Actualización: -
'****************************************************************/

  procedure sgass_cons_tip_urb(iv_idtipurb        in  number,
                               oc_tip_urbs        out sys_refcursor,
                               on_codResp         out number,
                               ov_msjResp         out varchar2)is
  ln_cant       number;
  begin
    open oc_tip_urbs for
      select tu.idtipurb,tu.descripcion
      from marketing.vtatipurb tu
      where (tu.estado = '1' and iv_idtipurb is null)
      or (tu.idtipurb = iv_idtipurb and iv_idtipurb is not null)
      order by tu.descripcion;
    
    select count(1)
    into ln_cant
    from marketing.vtatipurb tu
    where (tu.estado = '1' and iv_idtipurb is null)
    or (tu.idtipurb = iv_idtipurb and iv_idtipurb is not null);
    
    if ln_cant > 0 then
      on_codResp := 0;
      ov_msjResp := 'OK';
    else
      on_codResp := 1;
      ov_msjResp := '[PKG_CONSULTA_UNIFICADA_SGA][SGASS_CONS_TIP_URB] - No se encontraron registros para IDTIPURB: '||iv_idtipurb;
    end if;
    exception
       when others then
          on_codResp := -1;
          ov_msjResp := '[PKG_CONSULTA_UNIFICADA_SGA][SGASS_CONS_TIP_URB] - Error al ejecutar procedimiento: '||sqlcode||': '||sqlerrm;
  end;
/****************************************************************
* Versión          : 1.0
* Nombre SP        : SGASS_CONS_TIP_VIA
* Propósito        : Consulta de los tipos de vía que existen
* Input            :
                    ** iv_codvia             : Código de Vía (Si es nulo consulta todos)
* Input - Output   : -
* Output           :
                    ** oc_cen_poblados       : Cursor de tipos de vías
                    ** on_codResp            : Código de respuesta
                    ** ov_msjResp            : Mensaje de respuesta
* Creado por       : Freddy Dick Salazar Valverde
* Fec Creación     : 26/02/2020
* Fec Actualización: -
'****************************************************************/

  procedure sgass_cons_tip_via(iv_codvia          in  number,
                               oc_tip_vias        out sys_refcursor,
                               on_codResp         out number,
                               ov_msjResp         out varchar2)is
  ln_cant       number;
  begin
    open oc_tip_vias for
      select trim(tv.codvia) codvia,tv.desvia,tv.abrvia
      from produccion.pertipvia tv
      where iv_codvia is null
      or (trim(tv.codvia) = to_char(iv_codvia) and iv_codvia is not null)
      order by tv.desvia;
    
    select count(1)
    into ln_cant
    from produccion.pertipvia tv
    where iv_codvia is null
    or (trim(tv.codvia) = to_char(iv_codvia) and iv_codvia is not null);
    
    if ln_cant > 0 then
      on_codResp := 0;
      ov_msjResp := 'OK';
    else
      on_codResp := 1;
      ov_msjResp := '[PKG_CONSULTA_UNIFICADA_SGA][SGASS_CONS_TIP_VIA] - No se encontraron registros para CODVIA: '||iv_codvia;
    end if;
    exception
       when others then
          on_codResp := -1;
          ov_msjResp := '[PKG_CONSULTA_UNIFICADA_SGA][SGASS_CONS_TIP_VIA] - Error al ejecutar procedimiento: '||sqlcode||': '||sqlerrm;
  end;
/****************************************************************
* Versión          : 1.0
* Nombre SP        : SGASS_CONS_PLANO
* Propósito        : Consulta de los planos que existen en una determinada ubicación
* Input            :
                    ** iv_codubi            : Código de ubicación
* Input - Output   : -
* Output           :
                    ** oc_planos             : Cursor de planos
                    ** on_codResp            : Código de respuesta
                    ** ov_msjResp            : Mensaje de respuesta
* Creado por       : Freddy Dick Salazar Valverde
* Fec Creación     : 26/02/2020
* Fec Actualización: -
'****************************************************************/

  procedure sgass_cons_plano(iv_codubi          in  varchar2,
                             oc_planos          out sys_refcursor,
                             on_codResp         out number,
                             ov_msjResp         out varchar2)is
  ln_cant       number;
  begin
    open oc_planos for
      select trim(gr.codubi) codubi,gr.idplano,gr.descripcion,di.nomdst,di.dist_desc
      from marketing.vtatabgeoref gr, marketing.vtatabdst di
      where (iv_codubi is null
      or (trim(gr.codubi) = trim(iv_codubi) and iv_codubi is not null))
      and gr.estado = 1
      and trim(di.codubi) = trim(gr.codubi)
      order by gr.descripcion;
    
    select count(gr.codubi)
    into ln_cant
    from marketing.vtatabgeoref gr, marketing.vtatabdst di
    where (iv_codubi is null
    or (trim(gr.codubi) = trim(iv_codubi) and iv_codubi is not null))
    and gr.estado = 1
    and trim(di.codubi) = trim(gr.codubi);
    
    if ln_cant > 0 then
      on_codResp := 0;
      ov_msjResp := 'OK';
    else
      on_codResp := 1;
      ov_msjResp := '[PKG_CONSULTA_UNIFICADA_SGA][SGASS_CONS_PLANO] - No se encontraron registros para CODUBI: '||iv_codubi;
    end if;
    exception
       when others then
          on_codResp := -1;
          ov_msjResp := '[PKG_CONSULTA_UNIFICADA_SGA][SGASS_CONS_PLANO] - Error al ejecutar procedimiento: '||sqlcode||': '||sqlerrm;
  end;
/****************************************************************
* Versión          : 1.0
* Nombre SP        : SGASS_CONS_EDIFICIO
* Propósito        : Consulta de los edificios que existen en una determinada ubicación
* Input            :
                    ** iv_codubi           : Código de ubicación
                    ** iv_idplano          : Identificador del plano
* Input - Output   : -
* Output           :
                    ** oc_edificios          : Cursor de edificios
                    ** on_codResp            : Código de respuesta
                    ** ov_msjResp            : Mensaje de respuesta
* Creado por       : Freddy Dick Salazar Valverde
* Fec Creación     : 26/02/2020
* Fec Actualización: -
'****************************************************************/

  procedure sgass_cons_edificio(iv_codubi          in  varchar2,
                                iv_idplano         in  varchar2,
                                oc_edificios       out sys_refcursor,
                                on_codResp         out number,
                                ov_msjResp         out varchar2)is
  ln_cant       number;
  begin
    open oc_edificios for
      select trim(di.codest) codest,di.nomdepa,trim(di.codpvc) codpvc,di.nomprov,trim(di.coddst) coddst,di.nomdst,
      di.dist_desc,trim(ed.codubi) codubi,trim(di.ubigeo),di.codpos,di.codpos2,trim(ed.codigo) codedi,ed.idplano,ed.nombre,di.nomdst,di.dist_desc,
      trim(ed.tipviap) tipviap,tv.desvia destipvia,ed.nomvia,ed.numvia,ed.nomurb,ed.pisos,ed.administrador,
      ed.telefono,ed.referencia,ed.complemento
      from marketing.edificio ed, marketing.vtatabdst di, produccion.pertipvia tv
      where ((trim(ed.codubi) = trim(iv_codubi) and iv_codubi is not null and iv_idplano is null)--codubi
      or (trim(ed.idplano) = trim(iv_idplano) and iv_codubi is null and iv_idplano is not null)--idplano
      or (iv_codubi is null and iv_idplano is null)--
      or (trim(ed.idplano) = trim(iv_idplano) and trim(ed.codubi) = trim(iv_codubi)
          and iv_codubi is not null and iv_idplano is not null))--codubi,idplano
      and trim(ed.codubi) = trim(di.codubi) and trim(tv.codvia) = trim(ed.tipviap)
      order by ed.nombre,ed.nomvia,ed.nomurb;
    
    select count(ed.codubi)
    into ln_cant
    from marketing.edificio ed, marketing.vtatabdst di, produccion.pertipvia tv
    where ((trim(ed.codubi) = trim(iv_codubi) and iv_codubi is not null and iv_idplano is null)--codubi
    or (trim(ed.idplano) = trim(iv_idplano) and iv_codubi is null and iv_idplano is not null)--idplano
    or (iv_codubi is null and iv_idplano is null)--
    or (trim(ed.idplano) = trim(iv_idplano) and trim(ed.codubi) = trim(iv_codubi)
        and iv_codubi is not null and iv_idplano is not null))--codubi,idplano
    and trim(ed.codubi) = trim(di.codubi) and trim(tv.codvia) = trim(ed.tipviap);
    
    if ln_cant > 0 then
      on_codResp := 0;
      ov_msjResp := 'OK';
    else
      on_codResp := 1;
      ov_msjResp := '[PKG_CONSULTA_UNIFICADA_SGA][SGASS_CONS_EDIFICIO] - No se encontraron registros para CODUBI, IDPLANO: '||iv_codubi||', '||iv_idplano;
    end if;
    exception
       when others then
          on_codResp := -1;
          ov_msjResp := '[PKG_CONSULTA_UNIFICADA_SGA][SGASS_CONS_EDIFICIO] - Error al ejecutar procedimiento: '||sqlcode||': '||sqlerrm;
  end;
/****************************************************************
* Versión          : 1.0
* Nombre SP        : SGASS_CONS_TIPO
* Propósito        : Consulta de los tipos de zona, interior y manzana que existen
* Input            :
                    ** iv_tipo               : Tipo (Si es nulo devuelve todos los tipos)
* Input - Output   : -
* Output           :
                    ** oc_lista_tipo         : Cursor de tipos
                    ** on_codResp            : Código de respuesta
                    ** ov_msjResp            : Mensaje de respuesta
* Creado por       : Freddy Dick Salazar Valverde
* Fec Creación     : 26/02/2020
* Fec Actualización: -
'****************************************************************/

  procedure sgass_cons_tipo(iv_tipo            in  varchar2,
                            oc_lista_tipo      out sys_refcursor,
                            on_codResp         out number,
                            ov_msjResp         out varchar2)is
  ln_cant       number;
  begin
    open oc_lista_tipo for
      select distinct tp.abrev tipo, to_number(o.codigoc) idtipo,o.descripcion,o.abreviacion, o.codigon estado
      from tipopedd tp, opedd o
      where ((tp.abrev in ('TU_TIPO_ZONA','TU_TIPO_INTERIOR','TU_TIPO_MANZANA') and iv_tipo is null) 
      or (tp.abrev = iv_tipo and iv_tipo is not null))--TU_TIPO_ZONA--TU_TIPO_INTERIOR--TU_TIPO_MANZANA
      and tp.tipopedd = o.tipopedd
      and o.codigon = 1--estado
      order by tp.abrev,o.descripcion;
    
    select count(o.codigoc)
    into ln_cant
    from tipopedd tp, opedd o
    where ((tp.abrev in ('TU_TIPO_ZONA','TU_TIPO_INTERIOR','TU_TIPO_MANZANA') and iv_tipo is null) 
    or (tp.abrev = iv_tipo and iv_tipo is not null))--TU_TIPO_ZONA--TU_TIPO_INTERIOR--TU_TIPO_MANZANA
    and tp.tipopedd = o.tipopedd
    and o.codigon = 1;--estado
    
    if ln_cant > 0 then
      on_codResp := 0;
      ov_msjResp := 'OK';
    else
      on_codResp := 1;
      ov_msjResp := '[PKG_CONSULTA_UNIFICADA_SGA][SGASS_CONS_TIPO] - No se encontraron registros para TIPO: '||iv_tipo;
    end if;
    exception
       when others then
          on_codResp := -1;
          ov_msjResp := '[PKG_CONSULTA_UNIFICADA_SGA][SGASS_CONS_TIPO] - Error al ejecutar procedimiento: '||sqlcode||': '||sqlerrm;
  end;
  
END;
/