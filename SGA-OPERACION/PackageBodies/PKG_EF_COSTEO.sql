CREATE OR REPLACE PACKAGE BODY OPERACION.PKG_EF_COSTEO IS
  /******************************************************************************************
    VERSION   FECHA       AUTOR             SOLICITADO POR  DESCRIPCION.
    --------  ----------  ---------------   --------------  ---------------------------------
      1.0     27/09/2019  ANDRES ARIAS      MARIO HIDALGO   CALCULAR COSTOS PINT Y PEXT DE UN EF
      2.0     05/11/2019  ANDRES ARIAS      MARIO HIDALGO   REVISIONES PARA ESCENARIO CDS
      3.0     14/11/2019  ANDRES ARIAS      MANUEL MENDOZA  REVISION EN SP: SGAFUN_GET_CANTIDAD
                                                            Y SGASI_INSERTAR_COSTEO_PEXT
  *******************************************************************************************/

  -- PRIVATE CONSTANT DECLARATIONS
  COD_EXITO                    CONSTANT PLS_INTEGER  := 0;       --
  COD_ERROR_VALIDACION         CONSTANT PLS_INTEGER  := 1;       --
  COD_ERROR_PROCESO            CONSTANT PLS_INTEGER  := 2;       --
  COD_ERROR_EXCEPTION_INTERNO  CONSTANT PLS_INTEGER  := -100;    --
  MENSAJE_EXITO                CONSTANT VARCHAR(100) := 'OK';    --
  MENSAJE_SIN_DATOS            CONSTANT VARCHAR(100) := 'SIN DATOS';    --

  -- PRIVATE TYPE DECLARATIONS
  TYPE T_PEXT_REC IS RECORD(
    EFESC_CODACT      OPERACION.SGAT_EF_ETAPA_SRVC.EFESC_CODACT%TYPE,
    EFESN_CODETA      OPERACION.SGAT_EF_ETAPA_SRVC.EFESN_CODETA%TYPE,
    EFESC_TIPPRC      OPERACION.SGAT_EF_ETAPA_SRVC.EFESC_TIPPRC%TYPE,
    EFECV_CODPAR      OPERACION.SGAT_EF_ETAPA_CNFG.EFECV_CODPAR%TYPE,
    EFECN_CANTIDAD    OPERACION.SGAT_EF_ETAPA_CNFG.EFECN_CANTIDAD%TYPE,
    EFECN_COSTO       OPERACION.SGAT_EF_ETAPA_CNFG.EFECN_COSTO%TYPE,
    EFECN_COSTO_PROV  OPERACION.SGAT_EF_ETAPA_CNFG.EFECN_COSTO_PROV%TYPE,
    MONEDA_ID         PRODUCCION.CTBTABMON.MONEDA_ID%TYPE,
    CODPREC           OPERACION.ACTXPRECIARIO.CODPREC%TYPE);

  -- PRIVATE VARIABLE DECLARATIONS
  TYPE T_PEXT          IS TABLE OF T_PEXT_REC;

  TYPE T_REGLA_PINT    IS TABLE OF OPERACION.SGAT_EF_REGLACOSTEO_PINT%ROWTYPE;
  TYPE T_EQUIPOS_PINT  IS TABLE OF OPERACION.SGAT_EF_EQUIPO_CNFG.EFQCV_CODMAT%TYPE;
  TYPE T_ETAPAS_PEXT   IS TABLE OF OPERACION.SGAT_EF_ETAPA_SRVC.EFESN_CODETA%TYPE;


  ----- FUNCIONES Y PROCEDIMIENTOS PRIVADOS --------------------
  --------------------------------------------------------------
  FUNCTION SGAFUN_GEF_EF(K_SEF       SALES.VTATABSLCFAC.NUMSLC%TYPE,
                         K_CODIGO    OUT PLS_INTEGER,
                         K_MENSAJE   OUT VARCHAR2)
     RETURN OPERACION.EF.CODEF%TYPE IS

     C_EF OPERACION.EF.CODEF%TYPE;
  BEGIN
     -- ENCONTRANDO CODIGO EF DE SEF
     SELECT A.CODEF INTO C_EF FROM OPERACION.EF A WHERE A.NUMSLC = K_SEF;

     K_CODIGO  := COD_EXITO;
     K_MENSAJE := MENSAJE_EXITO;
     RETURN C_EF;

  EXCEPTION
     WHEN OTHERS THEN
        K_CODIGO  := COD_ERROR_EXCEPTION_INTERNO;
        K_MENSAJE := 'SGAFUN_GEF_EF. SQLCODE: ' || TO_CHAR(SQLCODE) || ' - SQLERRM: ' || SQLERRM;
        RETURN NULL;
  END;

  --------------------------------------------------------------
  FUNCTION SGAFUN_GET_ANCHOBANDA(K_SEF     SALES.VTATABSLCFAC.NUMSLC%TYPE,
                                 K_SUC     SALES.VTADETPTOENL.CODSUC%TYPE,
                                 K_CODIGO  OUT PLS_INTEGER,
                                 K_MENSAJE OUT VARCHAR2)
     RETURN T_ANCHO_BANDA IS

     V_AB_T T_ANCHO_BANDA;
  BEGIN
     SELECT NUMPTO,
            CODSUC,
            BANWID,
            ROUND((BANWID + 300) / 1024, 2)
      BULK COLLECT INTO V_AB_T
      FROM SALES.VTADETPTOENL
      WHERE NUMSLC LIKE '' || K_SEF || ''
        AND CODSUC LIKE '' || K_SUC || ''
        AND BANWID > 0
        AND TIPTRA IN (1, 80)
        AND FLGSRV_PRI = 1;

     IF V_AB_T.COUNT < 1 THEN
        K_CODIGO  := COD_ERROR_PROCESO;
        K_MENSAJE := MENSAJE_SIN_DATOS;
     ELSE
        K_CODIGO  := COD_EXITO;
        K_MENSAJE := MENSAJE_EXITO;
     END IF;

     RETURN V_AB_T;

  EXCEPTION
     WHEN OTHERS THEN
        K_CODIGO  := COD_ERROR_EXCEPTION_INTERNO;
        K_MENSAJE := 'SGAFUN_GET_ANCHOBANDA. SQLCODE: ' || TO_CHAR(SQLCODE) || ' - SQLERRM: ' || SQLERRM;
        RETURN NULL;
  END;

  --------------------------------------------------------------
  FUNCTION SGAFUN_GET_ID_ANCHOBANDA(K_AB_MB   NUMBER,
                                    K_CODIGO  OUT PLS_INTEGER,
                                    K_MENSAJE OUT VARCHAR2)
     RETURN VARCHAR2 IS

     V_ANCHOBANDA  VARCHAR2(100);

     CURSOR C_CUR IS
      SELECT EFEPN_ID
        FROM OPERACION.SGAT_EF_ETAPA_PRM T
       WHERE T.EFEPN_ID_PADRE IN
             (SELECT EFEPN_ID
                FROM OPERACION.SGAT_EF_ETAPA_PRM
               WHERE EFEPV_TRANSACCION = 'REGLAS_NEGOCIO'
                 AND EFEPV_DESCRIPCION = 'ANCHO DE BANDA')
         AND T.EFEPN_ESTADO = 1
         AND T.EFEPN_CODN <= K_AB_MB
         AND T.EFEPN_CODN2 > K_AB_MB;

  BEGIN
     IF K_AB_MB < 0 OR K_AB_MB IS NULL THEN
        K_CODIGO  := COD_ERROR_VALIDACION;
        K_MENSAJE := MENSAJE_SIN_DATOS;
        RETURN NULL;
     END IF;

     FOR CUR IN C_CUR LOOP
        V_ANCHOBANDA := V_ANCHOBANDA || CUR.EFEPN_ID || ',';
     END LOOP;

     V_ANCHOBANDA   := SUBSTR(V_ANCHOBANDA, 1, LENGTH(V_ANCHOBANDA) - 1);

     K_CODIGO  := COD_EXITO;
     K_MENSAJE := MENSAJE_EXITO;
     RETURN V_ANCHOBANDA;

  EXCEPTION
     WHEN OTHERS THEN
        K_CODIGO  := COD_ERROR_EXCEPTION_INTERNO;
        K_MENSAJE := 'SGAFUN_GET_ID_ANCHOBANDA. SQLCODE: ' || TO_CHAR(SQLCODE) || ' - SQLERRM: ' || SQLERRM;
        RETURN NULL;
  END;

  --------------------------------------------------------------
  FUNCTION SGAFUN_GET_EQUIPOCOMP(K_SEF     SALES.VTATABSLCFAC.NUMSLC%TYPE,
                                 K_SUC     SALES.VTADETPTOENL.CODSUC%TYPE,
                                 K_CODIGO  OUT PLS_INTEGER,
                                 K_MENSAJE OUT VARCHAR2)
     RETURN T_EQUIPOCOMP IS

     V_EQUIPOCOMP_T T_EQUIPOCOMP;
  BEGIN
     SELECT V.NUMPTO PUNTO,
            ROWNUM ORDEN,
            T.CODTIPEQU CODTIPEQU,
            T.TIPEQU TIPEQU,
            T.COSTO COSTO,
            EQ.CANTIDAD CANTIDAD,
            DECODE(P.IDGRUPOPRODUCTO, 1, 1, 2, 2, 1) TIPPRP,
            V.CODEQUCOM CODEQUCOM
       BULK COLLECT INTO V_EQUIPOCOMP_T
       FROM (SELECT NUMSLC,
                    CODSUC,
                    NUMPTO_PRIN NUMPTO,
                    CODEQUCOM,
                    IDPRODUCTO
               FROM SALES.VTADETPTOENL
              WHERE NUMSLC = LPAD(K_SEF, 10, '0')
                AND CODSUC = K_SUC
                AND CODEQUCOM IS NOT NULL) V,
            OPERACION.EQUCOMXOPE EQ,
            OPERACION.TIPEQU T,
            BILLCOLPER.PRODUCTO P,
            OPERACION.EF EF,
            PRODUCCION.ALMTABMAT A
      WHERE V.CODEQUCOM = EQ.CODEQUCOM
        AND T.TIPEQU = EQ.TIPEQU
        AND V.NUMSLC = EF.NUMSLC
        AND V.IDPRODUCTO = P.IDPRODUCTO(+)
        AND T.CODTIPEQU  = A.CODMAT (+)
        AND EF.CODEF = TO_NUMBER(K_SEF)
        AND 1 = 1
        AND EQ.ESPARTE = 0
        --AND A.INDREC = 'S'
        AND TO_NUMBER(V.NUMPTO) IN
            (SELECT PUNTO
               FROM OPERACION.EFPTO
              WHERE CODEF = TO_NUMBER(K_SEF)
                AND CODSUC = K_SUC);

     IF V_EQUIPOCOMP_T.COUNT < 1 THEN
        K_CODIGO  := COD_ERROR_PROCESO;
        K_MENSAJE := MENSAJE_SIN_DATOS;
     ELSE
        K_CODIGO  := COD_EXITO;
        K_MENSAJE := MENSAJE_EXITO;
     END IF;

     RETURN V_EQUIPOCOMP_T;

  EXCEPTION
     WHEN OTHERS THEN
        K_CODIGO  := COD_ERROR_EXCEPTION_INTERNO;
        K_MENSAJE := 'SGAFUN_GET_EQUIPOCOMP. SQLCODE: ' || TO_CHAR(SQLCODE) || ' - SQLERRM: ' || SQLERRM;
        RETURN NULL;
  END;

  --------------------------------------------------------------
  FUNCTION SGAFUN_GET_EQUIPORED(K_POP_GIS    METASOLV.UBIRED.UBIRV_CODUBIRED_GIS%TYPE,
                                K_ANCHOBANDA VARCHAR2,
                                K_CODIGO     OUT PLS_INTEGER,
                                K_MENSAJE    OUT VARCHAR2)
     RETURN T_EQUIPO IS

     V_EQUIPO T_EQUIPO;
     V_SQL    VARCHAR2(700);
  BEGIN

     V_SQL := '
        SELECT DISTINCT A.CODUBIRED,
                        A.CODUBI,
                        B.TGER_CODTIPO,
                        C.TGER_NOMTIPO
          FROM METASOLV.UBIRED A
         INNER JOIN METASOLV.EQUIPORED B
            ON A.CODUBIRED = B.CODUBIRED
         INNER JOIN METASOLV.SGAT_TIPAGR_EQUIPORED C
            ON B.TGER_CODTIPO = C.TGER_CODTIPO
         INNER JOIN OPERACION.SGAT_EF_REGLACOSTEO_PINT D
            ON B.TGER_CODTIPO = D.EFRCN_TIP_EQUIPO
         WHERE A.ESTADO = 1
           AND A.UBIRV_CODUBIRED_GIS = ''' || K_POP_GIS || '''
           AND B.ESTADO = 1
           AND C.TGER_ESTADO = 1
           AND D.EFRCN_AB_ID IN (' || K_ANCHOBANDA || ')'; -- 5: < 80MB, 6: > 80MB

     EXECUTE IMMEDIATE V_SQL BULK COLLECT
        INTO V_EQUIPO;

     IF V_EQUIPO.COUNT < 1 THEN
        K_CODIGO  := COD_ERROR_PROCESO;
        K_MENSAJE := MENSAJE_SIN_DATOS;
     ELSE
        K_CODIGO  := COD_EXITO;
        K_MENSAJE := MENSAJE_EXITO;
     END IF;

     RETURN V_EQUIPO;

  EXCEPTION
     WHEN OTHERS THEN
        K_CODIGO  := COD_ERROR_EXCEPTION_INTERNO;
        K_MENSAJE := 'SGAFUN_GET_EQUIPORED. SQLCODE: ' || TO_CHAR(SQLCODE) || ' - SQLERRM: ' || SQLERRM;
        RETURN NULL;
  END;

  --------------------------------------------------------------
  FUNCTION SGAFUN_GET_TARJETA(K_POP_GIS    METASOLV.UBIRED.UBIRV_CODUBIRED_GIS%TYPE,
                              K_ANCHOBANDA VARCHAR2,
                              K_CODIGO     OUT PLS_INTEGER,
                              K_MENSAJE    OUT VARCHAR2)
     RETURN T_TARJETA IS

     V_TARJETA T_TARJETA;
     V_SQL     VARCHAR2(1300);
  BEGIN
     V_SQL := '
        SELECT DISTINCT X.TGER_CODTIPO,
                        X.TGER_NOMTIPO,
                        CASE NVL(E.CODTIPTARJ, 0)
                           WHEN 0 THEN
                            0
                           ELSE
                            1
                        END AS TARJETA
          FROM (SELECT DISTINCT A.UBIRV_CODUBIRED_GIS,
                                A.CODUBIRED,
                                A.DESCRIPCION         AS DESCRIPCION_UBIRED,
                                A.CODUBI,
                                A.CODSITE,
                                B.CODEQUIPO,
                                B.DESCRIPCION         AS DESCRIPCION_EQUIPORED,
                                B.TGER_CODTIPO,
                                C.TGER_NOMTIPO
                  FROM METASOLV.UBIRED A
                 INNER JOIN METASOLV.EQUIPORED B
                    ON A.CODUBIRED = B.CODUBIRED
                 INNER JOIN METASOLV.SGAT_TIPAGR_EQUIPORED C
                    ON B.TGER_CODTIPO = C.TGER_CODTIPO
                 INNER JOIN OPERACION.SGAT_EF_REGLACOSTEO_PINT D
                    ON B.TGER_CODTIPO = D.EFRCN_TIP_EQUIPO
                 WHERE A.ESTADO = 1
                   AND A.UBIRV_CODUBIRED_GIS = ''' || K_POP_GIS || '''
                   AND B.ESTADO = 1
                   AND C.TGER_ESTADO = 1
                   AND D.EFRCN_AB_ID IN (' || K_ANCHOBANDA || ')
                   AND D.EFRCV_CONCEPTO = 8) X
         INNER JOIN METASOLV.TARJETAXEQUIPO E
            ON X.CODEQUIPO = E.CODEQUIPO
         WHERE E.ESTADO = 0
           AND X.TGER_CODTIPO IS NOT NULL
         ORDER BY 1 DESC, 3 DESC';

     EXECUTE IMMEDIATE V_SQL BULK COLLECT
        INTO V_TARJETA;

     IF V_TARJETA.COUNT < 1 THEN
        K_CODIGO  := COD_ERROR_PROCESO;
        K_MENSAJE := MENSAJE_SIN_DATOS;
     ELSE
        K_CODIGO  := COD_EXITO;
        K_MENSAJE := MENSAJE_EXITO;
     END IF;

     RETURN V_TARJETA;

  EXCEPTION
     WHEN OTHERS THEN
        K_CODIGO  := COD_ERROR_EXCEPTION_INTERNO;
        K_MENSAJE := 'SGAFUN_GET_TARJETA. SQLCODE: ' || TO_CHAR(SQLCODE) || ' - SQLERRM: ' || SQLERRM;
        RETURN NULL;
  END;

  --------------------------------------------------------------
  FUNCTION SGAFUN_VAL_ESCENARIO(K_ESCENARIO OPERACION.EFPTO.EFPTV_ESCENARIO%TYPE,
                                K_CODIGO    OUT PLS_INTEGER,
                                K_MENSAJE   OUT VARCHAR2)
    RETURN PLS_INTEGER IS

    V_NUM  PLS_INTEGER := 0;
  BEGIN
     K_MENSAJE := 'SGAFUN_VAL_ESCENARIO. ';

     SELECT COUNT(EFEPV_CODV)
        INTO V_NUM
        FROM OPERACION.SGAT_EF_ETAPA_PRM DTP
       WHERE DTP.EFEPN_ID_PADRE =
             (SELECT CBP.EFEPN_ID
                FROM OPERACION.SGAT_EF_ETAPA_PRM CBP
               WHERE NVL(CBP.EFEPN_ID_PADRE, 0) = 0
                 AND CBP.EFEPV_TRANSACCION = 'REGLAS_NEGOCIO'
                 AND CBP.EFEPV_DESCRIPCION = 'ESCENARIOS')
         AND DTP.EFEPV_CODV = K_ESCENARIO;

     IF V_NUM <> 1 THEN
        K_CODIGO  := COD_ERROR_VALIDACION;

        IF V_NUM < 1 THEN
           K_MENSAJE := K_MENSAJE || 'NO EXISTE ESCENARIO ' || K_ESCENARIO || ' CONFIGURADO EN REGLAS DE PARAMETROS.';
        END IF;

        IF V_NUM > 1 THEN
           K_MENSAJE := K_MENSAJE || 'EXISTE MAS DE UN ESCENARIO ' || K_ESCENARIO || ' CONFIGURADO EN REGLAS DE PARAMETROS.';
        END IF;
     ELSE
        K_CODIGO  := COD_EXITO;
        K_MENSAJE := MENSAJE_EXITO;
     END IF;

     RETURN V_NUM;

   EXCEPTION
      WHEN OTHERS THEN
         K_CODIGO  := COD_ERROR_EXCEPTION_INTERNO;
         K_MENSAJE := K_MENSAJE || 'SQLCODE: ' || TO_CHAR(SQLCODE) || ' - SQLERRM: ' || SQLERRM;
         RETURN NULL;
  END;

  --------------------------------------------------------------
  PROCEDURE SGASS_GET_EQUIPO_PINT (K_SEF            SALES.VTATABSLCFAC.NUMSLC%TYPE,
                                  K_SUC             SALES.VTADETPTOENL.CODSUC%TYPE,
                                  K_POP_GIS         METASOLV.UBIRED.UBIRV_CODUBIRED_GIS%TYPE,
                                  K_ANCHOBANDA_ID   VARCHAR2,
                                  K_HILOS           CLOB,
                                  K_DIST_POPCLIENTE OPERACION.EFPTO.LONFIBRA%TYPE,
                                  K_ESCENARIO       OPERACION.EFPTO.EFPTV_ESCENARIO%TYPE,
                                  K_EQUIPO_T        T_EQUIPO,
                                  K_EQUIPO_PINT     OUT OPERACION.SGAT_EF_REGLACOSTEO_PINT.EFRCN_PINT%TYPE,
                                  K_TIPOFIBRA       OUT VARCHAR2,
                                  K_CODIGO          OUT PLS_INTEGER,
                                  K_MENSAJE         OUT VARCHAR2) IS

     V_REGLA_PINT_T         T_REGLA_PINT;
     V_TARJETA_T            T_TARJETA;
     C_HILO                 METASOLV.SGAT_PEX_FIBRA.FIBRN_CODFIBRA%TYPE;
     C_TIPO_CABLE           METASOLV.PEX_TIPCABLE.TIPO%TYPE;
     C_MARCA_EQUIPO_VTA     SALES.VTAEQUCOM.IDMARCAEQUIPO%TYPE;
     C_MARCA_EQUIPO         OPERACION.SGAT_EF_EQUIPO_SRVC.EFEQN_MARCA%TYPE;
     ERROR_EX               EXCEPTION;
     LC_HILOS               SYS_REFCURSOR;
     V_TIENE_TIPOEQUIPO     PLS_INTEGER;
     V_TIENE_DETEQUIPO      PLS_INTEGER;
     V_NUM_SLOTS_DISP       PLS_INTEGER;
     V_NUM_FIBRA_DISP       PLS_INTEGER;
     V_TIENE_DISTANCIA      PLS_INTEGER;
     V_CONTINUAR_TIPOEQUIPO PLS_INTEGER;
     V_NUM                  PLS_INTEGER;
     V_CONTINUAR_TIPOFIBRA  VARCHAR2(4);
     V_NUM_FLUJO2           PLS_INTEGER;
     V_BOOL_TIPOEQUIPO      BOOLEAN;
     V_BOOL_TIPOFIBRA       BOOLEAN;
     V_FIBRA_ENCONTRADA     BOOLEAN;
     V_REGLA_ENCONTRADA     BOOLEAN := FALSE;
     V_SQL                  VARCHAR2(300);
  BEGIN
     K_EQUIPO_PINT := NULL;
     K_TIPOFIBRA   := '';

     BEGIN
        V_SQL := '
           SELECT T.*
             FROM OPERACION.SGAT_EF_REGLACOSTEO_PINT T
            WHERE T.EFRCN_AB_ID IN (' || K_ANCHOBANDA_ID || ')
            ORDER BY T.EFRCN_PRIORIDAD ASC';

        EXECUTE IMMEDIATE V_SQL BULK COLLECT
           INTO V_REGLA_PINT_T;

     EXCEPTION
        WHEN OTHERS THEN
           K_CODIGO      := COD_ERROR_EXCEPTION_INTERNO;
           K_MENSAJE     := 'SGASS_GET_EQUIPO_PINT. SQLCODE: ' || TO_CHAR(SQLCODE) || ' - SQLERRM: ' || SQLERRM;
           RAISE ERROR_EX;
     END;

     IF V_REGLA_PINT_T.COUNT < 1 THEN
        K_CODIGO      := COD_ERROR_VALIDACION;
        K_MENSAJE     := 'NO HAY REGISTROS EN REGLAS DE COSTEO PINT.';
        RETURN;
     END IF;

     -- CONSEGUIR EQUIPO ROUTER DE LA VENTA
     BEGIN
         SELECT MIN(IDMARCAEQUIPO)
         INTO C_MARCA_EQUIPO_VTA
           FROM SALES.VTADETPTOENL V
          INNER JOIN SALES.VTAEQUCOM E
             ON V.CODEQUCOM = E.CODEQUCOM
          WHERE V.NUMSLC = K_SEF
            AND V.CODSUC = K_SUC
            --AND V.FLGSRV_PRI = 1
            AND V.CODEQUCOM IS NOT NULL;
     EXCEPTION
        WHEN OTHERS THEN
           K_CODIGO      := COD_ERROR_EXCEPTION_INTERNO;
           K_MENSAJE     := 'SGASS_GET_EQUIPO_PINT. SQLCODE: ' || TO_CHAR(SQLCODE) || ' - SQLERRM: ' || SQLERRM;
           RAISE ERROR_EX;
     END;

     --------------------------
     V_CONTINUAR_TIPOEQUIPO := V_REGLA_PINT_T(1).EFRCN_TIP_EQUIPO;
     V_CONTINUAR_TIPOFIBRA  := V_REGLA_PINT_T(1).EFRCV_TIP_FIBRA;

     V_BOOL_TIPOEQUIPO := FALSE;
     V_BOOL_TIPOFIBRA  := FALSE;

     FOR I IN V_REGLA_PINT_T.FIRST .. V_REGLA_PINT_T.LAST LOOP
        K_EQUIPO_PINT      := -100;
        V_TIENE_TIPOEQUIPO := 0;
        V_TIENE_DETEQUIPO  := 0;
        V_NUM_SLOTS_DISP   := 0;
        V_NUM_FIBRA_DISP   := 0;
        V_TIENE_DISTANCIA  := 0;
        V_FIBRA_ENCONTRADA := FALSE;

        -- EXAMINANDO CONDICIONALES DE FLUJOS
        IF V_BOOL_TIPOEQUIPO AND
           V_CONTINUAR_TIPOEQUIPO <> V_REGLA_PINT_T(I).EFRCN_TIP_EQUIPO THEN
           GOTO CONTINUAR;
        ELSE
           V_BOOL_TIPOEQUIPO := FALSE;
        END IF;

        IF V_BOOL_TIPOFIBRA AND
           V_CONTINUAR_TIPOFIBRA <> V_REGLA_PINT_T(I).EFRCV_TIP_FIBRA AND
           (V_REGLA_PINT_T(V_NUM_FLUJO2).EFRCN_TIP_EQUIPO = V_REGLA_PINT_T(I).EFRCN_TIP_EQUIPO AND
           V_REGLA_PINT_T(V_NUM_FLUJO2).EFRCC_COND_1 = V_REGLA_PINT_T(I).EFRCC_COND_1 AND
           V_REGLA_PINT_T(V_NUM_FLUJO2).EFRCV_CONCEPTO = V_REGLA_PINT_T(I).EFRCV_CONCEPTO AND
           V_REGLA_PINT_T(V_NUM_FLUJO2).EFRCC_COND_2 = V_REGLA_PINT_T(I).EFRCC_COND_2) THEN
           GOTO CONTINUAR;
        ELSE
           V_BOOL_TIPOFIBRA := FALSE;
        END IF;

        ------------------------------------------------------
        -- EXAMINANDO TIPO DE EQUIPO
        FOR J IN K_EQUIPO_T.FIRST .. K_EQUIPO_T.LAST LOOP
           IF K_EQUIPO_T(J).TGER_CODTIPO = V_REGLA_PINT_T(I).EFRCN_TIP_EQUIPO THEN
              V_TIENE_TIPOEQUIPO := 1;
           END IF;
        END LOOP;

        IF V_REGLA_PINT_T(I).EFRCC_COND_1 <> V_TIENE_TIPOEQUIPO THEN
           GOTO CONTINUAR;
        END IF;

        -- EXAMINANDO REGLA DE CONDICION: DETALLE DE EQUIPO
        ----------------------------------------------------
        -- TARJETA INSTALADA
        IF V_REGLA_PINT_T(I).EFRCV_CONCEPTO = 8 THEN
           V_TARJETA_T := SGAFUN_GET_TARJETA(K_POP_GIS,
                                             K_ANCHOBANDA_ID,
                                             K_CODIGO,
                                             K_MENSAJE);

           IF K_CODIGO = COD_EXITO THEN
              FOR J IN V_TARJETA_T.FIRST .. V_TARJETA_T.LAST LOOP
                 IF V_TARJETA_T(J).TGER_CODTIPO = V_REGLA_PINT_T(I).EFRCN_TIP_EQUIPO AND
                    V_TARJETA_T(J).TARJETA = V_REGLA_PINT_T(I).EFRCC_COND_2 THEN
                    V_TIENE_DETEQUIPO := 1;
                 END IF;
              END LOOP;

              IF V_TIENE_DETEQUIPO = 0 THEN
                 GOTO CONTINUAR;
              END IF;
           END IF;
        END IF;

        -- SLOTS DISPONIBLES (PUERTOS DISPONIBLES)
        IF V_REGLA_PINT_T(I).EFRCV_CONCEPTO = 7 THEN
           BEGIN
              SELECT COUNT(CODPUERTO) NUMPUERTODISPONIBLE
                INTO V_NUM_SLOTS_DISP
                FROM METASOLV.UBIRED U
               INNER JOIN METASOLV.EQUIPORED E
                  ON U.CODUBIRED = E.CODUBIRED
               INNER JOIN METASOLV.TARJETAXEQUIPO TXE
                  ON TXE.CODEQUIPO = E.CODEQUIPO
               INNER JOIN METASOLV.PUERTOXEQUIPO PXE
                  ON TXE.CODTARJETA = PXE.CODTARJETA
                 AND TXE.CODEQUIPO = PXE.CODEQUIPO
                 AND PXE.ESTADO = 0
               WHERE U.UBIRV_CODUBIRED_GIS = K_POP_GIS
                 AND E.TGER_CODTIPO = V_REGLA_PINT_T(I).EFRCN_TIP_EQUIPO
               GROUP BY U.UBIRV_CODUBIRED_GIS;
           EXCEPTION
              WHEN OTHERS THEN
                 K_CODIGO      := COD_ERROR_EXCEPTION_INTERNO;
                 K_MENSAJE     := 'SGASS_GET_EQUIPO_PINT. SQLCODE: ' || TO_CHAR(SQLCODE) || ' - SQLERRM: ' || SQLERRM;
                 RAISE ERROR_EX;
           END;

           IF V_NUM_SLOTS_DISP > 0 THEN
              V_NUM_SLOTS_DISP := 1;
           END IF;

           IF V_REGLA_PINT_T(I).EFRCC_COND_2 <> V_NUM_SLOTS_DISP THEN
              GOTO CONTINUAR;
           END IF;
        END IF;

        -- TIPO DE FIBRA (DISPONIBILIDAD DE HILOS)
        IF K_ESCENARIO = 'CDS' AND
           UPPER(V_REGLA_PINT_T(I).EFRCV_TIP_FIBRA) <> 'MO' THEN
           GOTO CONTINUAR;
        END IF;

        IF UPPER(K_ESCENARIO) = 'SA' OR UPPER(K_ESCENARIO) = 'MMC' THEN
           IF V_REGLA_PINT_T(I).EFRCV_TIP_FIBRA <> '00' AND V_REGLA_PINT_T(I).EFRCV_TIP_FIBRA IS NOT NULL THEN
                OPEN LC_HILOS FOR DBMS_LOB.SUBSTR(K_HILOS, 32000, 1);
              LOOP
                 FETCH LC_HILOS
                    INTO C_HILO;
                 EXIT WHEN LC_HILOS%NOTFOUND;

                 BEGIN
                    SELECT COUNT(F.FIBRN_CODFIBRA) NUMHILODISPONIBLE
                      INTO V_NUM_FIBRA_DISP
                      FROM METASOLV.UBIRED U
                     INNER JOIN METASOLV.EQUIPORED E
                        ON U.CODUBIRED = E.CODUBIRED
                     INNER JOIN METASOLV.PEX_CABLE C
                        ON U.CODUBIRED = C.CODUBIRED_ORI
                     INNER JOIN METASOLV.PEX_TIPCABLE G
                        ON G.CODTIPCAB = C.CODTIPCAB
                     INNER JOIN METASOLV.PEX_CAJTER CT
                        ON CT.CODCABLE = C.CODCABLE
                     INNER JOIN METASOLV.SGAT_PEX_FIBRA F
                        ON F.FIBRN_CODCABLE = C.CODCABLE
                       AND F.FIBRN_CODCAJTER = CT.CODCAJTER
                       AND F.FIBRN_CODESTFIBRA = 5
                       AND F.FIBRN_CODINSSRV IS NULL
                     WHERE U.UBIRV_CODUBIRED_GIS = K_POP_GIS -- '2514', '2541'
                       AND E.TGER_CODTIPO = V_REGLA_PINT_T(I).EFRCN_TIP_EQUIPO
                       AND UPPER(G.TIPO) = UPPER(V_REGLA_PINT_T(I).EFRCV_TIP_FIBRA)
                       AND F.FIBRN_CODFIBRA = C_HILO;
                 EXCEPTION
                    WHEN OTHERS THEN
                       K_CODIGO      := COD_ERROR_EXCEPTION_INTERNO;
                       K_MENSAJE     := 'SGASS_GET_EQUIPO_PINT. SQLCODE: ' || TO_CHAR(SQLCODE) || ' - SQLERRM: ' || SQLERRM;
                       RAISE ERROR_EX;
                 END;

                 IF V_NUM_FIBRA_DISP > 0 THEN
                    V_FIBRA_ENCONTRADA := TRUE;
                 END IF;
              END LOOP;
              CLOSE LC_HILOS;

              IF NOT V_FIBRA_ENCONTRADA THEN
                 GOTO CONTINUAR;
              END IF;
           END IF;
        END IF;

        -- EXAMINANDO DISTANCIA
        IF V_REGLA_PINT_T(I).EFRCN_DIST_ID <> 0 AND V_REGLA_PINT_T(I).EFRCN_DIST_ID IS NOT NULL THEN
           BEGIN
              SELECT COUNT(T.EFEPN_ID)
                INTO V_TIENE_DISTANCIA
                FROM OPERACION.SGAT_EF_ETAPA_PRM T
               WHERE T.EFEPN_ID = V_REGLA_PINT_T(I).EFRCN_DIST_ID
                 AND T.EFEPN_ESTADO = 1
                 AND T.EFEPN_CODN <= K_DIST_POPCLIENTE
                 AND T.EFEPN_CODN2 > K_DIST_POPCLIENTE;
           EXCEPTION
              WHEN OTHERS THEN
                 K_CODIGO      := COD_ERROR_EXCEPTION_INTERNO;
                 K_MENSAJE     := 'SGASS_GET_EQUIPO_PINT. SQLCODE: ' || TO_CHAR(SQLCODE) || ' - SQLERRM: ' || SQLERRM;
                 RAISE ERROR_EX;
           END;

           IF V_TIENE_DISTANCIA < 1 THEN
              GOTO CONTINUAR;
           END IF;
        END IF;

        -- EXAMINANDO FLUJO: CONTINUAR
        IF V_REGLA_PINT_T(I).EFRCN_CONTINUAR > 0 THEN
           V_CONTINUAR_TIPOEQUIPO := V_REGLA_PINT_T(I).EFRCN_CONTINUAR;
           V_BOOL_TIPOEQUIPO      := TRUE;

           GOTO CONTINUAR;
        END IF;

        -- EXAMINANDO FLUJO: CONTINUAR2
        IF V_REGLA_PINT_T(I).EFRCV_CONTINUAR2 <> '00' AND V_REGLA_PINT_T(I).EFRCV_CONTINUAR2 IS NOT NULL THEN
           V_CONTINUAR_TIPOFIBRA := V_REGLA_PINT_T(I).EFRCV_CONTINUAR2;
           V_BOOL_TIPOFIBRA      := TRUE;
           V_NUM_FLUJO2          := I;

           IF V_CONTINUAR_TIPOFIBRA = 'MO' THEN
              K_EQUIPO_PINT := -20;
              K_TIPOFIBRA   := UPPER(V_REGLA_PINT_T(I).EFRCV_TIP_FIBRA);
              K_CODIGO      := COD_ERROR_PROCESO;
              K_MENSAJE     := 'CAMBIAR A HILO MONOMODO';
              RETURN;
           END IF;

           GOTO CONTINUAR;
        END IF;

        -- BUSCANDO EQUIPO ROUTER
        SELECT NVL(EFEQN_MARCA, 0)
        INTO C_MARCA_EQUIPO
        FROM OPERACION.SGAT_EF_EQUIPO_SRVC E
        WHERE E.EFEQN_ID = V_REGLA_PINT_T(I).EFRCN_PINT;

        IF C_MARCA_EQUIPO > 0 AND C_MARCA_EQUIPO <> C_MARCA_EQUIPO_VTA THEN
           GOTO CONTINUAR;
        END IF;

        -- EXAMINANDO RESULTADO
        V_REGLA_ENCONTRADA := TRUE;
        K_EQUIPO_PINT      := V_REGLA_PINT_T(I).EFRCN_PINT;
        K_TIPOFIBRA        := UPPER(V_REGLA_PINT_T(I).EFRCV_TIP_FIBRA);
        K_CODIGO           := COD_EXITO;
        K_MENSAJE          := MENSAJE_EXITO || ' - ID REGLA: ' || V_REGLA_PINT_T(I).EFRCN_ID;

        IF K_EQUIPO_PINT = -1 THEN
           K_CODIGO  := COD_ERROR_PROCESO;
           K_MENSAJE := 'COORDINAR CON RED AMPLIACION.';
        END IF;

        IF K_EQUIPO_PINT = 0 OR K_EQUIPO_PINT < -1 OR K_EQUIPO_PINT IS NULL THEN
           K_CODIGO  := COD_ERROR_PROCESO;
           K_MENSAJE := 'ERROR AL PROCESAR REGLAS PINT. (REGLA: ' || V_REGLA_PINT_T(I).EFRCN_ID || ' - PRIORIDAD: ' || V_REGLA_PINT_T(I).EFRCN_PRIORIDAD || ')';
        END IF;

        EXIT;
        <<CONTINUAR>>
        NULL;
     END LOOP;

     -- LLEGA A ESTE PUNTO CUANDO NO ENCONTRO NINGUNA REGLA QUE SATISFAGA LA CONDICIONES DADAS.
     IF NOT V_REGLA_ENCONTRADA THEN
           BEGIN
              SELECT COUNT(G.TIPO)
                INTO V_NUM
                FROM METASOLV.PEX_CABLE C
               INNER JOIN METASOLV.PEX_TIPCABLE G
                  ON G.CODTIPCAB = C.CODTIPCAB
               INNER JOIN METASOLV.PEX_CAJTER CT
                  ON CT.CODCABLE = C.CODCABLE
               INNER JOIN METASOLV.SGAT_PEX_FIBRA F
                  ON F.FIBRN_CODCABLE = C.CODCABLE
                 AND F.FIBRN_CODCAJTER = CT.CODCAJTER
               WHERE F.FIBRN_CODFIBRA = C_HILO;

              IF V_NUM > 0 THEN
                 SELECT DISTINCT G.TIPO
                   INTO C_TIPO_CABLE
                   FROM METASOLV.PEX_CABLE C
                  INNER JOIN METASOLV.PEX_TIPCABLE G
                     ON G.CODTIPCAB = C.CODTIPCAB
                  INNER JOIN METASOLV.PEX_CAJTER CT
                     ON CT.CODCABLE = C.CODCABLE
                  INNER JOIN METASOLV.SGAT_PEX_FIBRA F
                     ON F.FIBRN_CODCABLE = C.CODCABLE
                    AND F.FIBRN_CODCAJTER = CT.CODCAJTER
                  WHERE F.FIBRN_CODFIBRA = C_HILO;
             END IF;

            EXCEPTION
              WHEN OTHERS THEN
                 K_CODIGO      := COD_ERROR_EXCEPTION_INTERNO;
                 K_MENSAJE     := 'SGASS_GET_EQUIPO_PINT. SQLCODE: ' || TO_CHAR(SQLCODE) || ' - SQLERRM: ' || SQLERRM;
                 RAISE ERROR_EX;
            END;

        K_CODIGO  := COD_ERROR_PROCESO;
        K_MENSAJE := 'NO SE ENCONTRO REGLAS PINT PARA LOS PARAMETROS ENVIADOS. (HILO: ' || C_HILO || ' - TIPO_CABLE: ' || C_TIPO_CABLE || ')';
     END IF;

  EXCEPTION
     WHEN ERROR_EX THEN
        K_MENSAJE     := 'SGASS_GET_EQUIPO_PINT. ' || K_MENSAJE;
     WHEN OTHERS THEN
        K_CODIGO      := COD_ERROR_EXCEPTION_INTERNO;
        K_MENSAJE     := 'SGASS_GET_EQUIPO_PINT. SQLCODE: ' || TO_CHAR(SQLCODE) || ' - SQLERRM: ' || SQLERRM;
  END;

  --------------------------------------------------------------
  FUNCTION SGAFUN_GET_POLITICAS(K_SUC       SALES.VTADETPTOENL.CODSUC%TYPE,
                                K_ESCENARIO OPERACION.EFPTO.EFPTV_ESCENARIO%TYPE,
                                K_DISTANCIA OPERACION.EFPTO.EFPTN_LONFIBRA_PROY%TYPE,
                                K_CODIGO    OUT PLS_INTEGER,
                                K_MENSAJE   OUT VARCHAR2)
     RETURN VARCHAR2 IS

     V_RESULT OPERACION.EFPTO.EFPTV_POLITICA%TYPE;
     V_DATO   OPERACION.SGAT_EF_ETAPA_PRM.EFEPN_CODN%TYPE;
  BEGIN
     V_RESULT := '';

     IF K_ESCENARIO = 'SA' THEN
        V_RESULT := 'TIPO 0';
     ELSE
        BEGIN
            SELECT COUNT(P.EFEPN_CODN)
              INTO V_DATO
            FROM MARKETING.VTASUCCLI S
             INNER JOIN OPERACION.SGAT_EF_ETAPA_PRM P
               ON S.UBISUC = P.EFEPV_CODV
               AND P.EFEPN_ESTADO = 1
               AND P.EFEPN_ID_PADRE IN
                   (SELECT A.EFEPN_ID
                      FROM OPERACION.SGAT_EF_ETAPA_PRM A
                     WHERE EFEPV_TRANSACCION = 'REGLAS_POLITICA'
                       AND EFEPV_DESCRIPCION = 'TIPO 1')
            WHERE CODSUC = K_SUC
               AND S.TIPVIAP = P.EFEPV_CODV2
               AND UPPER(S.NOMVIA) = P.EFEPV_CODV3
               AND (CASE OPERACION.IS_NUMBER(S.NUMVIA) WHEN 0 THEN '0' ELSE S.NUMVIA END) >= P.EFEPN_CODN * 100
               AND (CASE OPERACION.IS_NUMBER(S.NUMVIA) WHEN 0 THEN '0' ELSE S.NUMVIA END) < (P.EFEPN_CODN2 + 1) * 100;

        EXCEPTION
           WHEN OTHERS THEN
              K_CODIGO  := COD_ERROR_EXCEPTION_INTERNO;
              K_MENSAJE := 'SGAFUN_GET_POLITICAS. SQLCODE: ' || TO_CHAR(SQLCODE) || ' - SQLERRM: ' || SQLERRM;
              RETURN NULL;
        END;

        IF V_DATO > 0 THEN
           V_RESULT := 'TIPO 1';
        ELSE
           BEGIN
              SELECT P.EFEPN_CODN
                INTO V_DATO
                FROM MARKETING.VTASUCCLI S
                LEFT JOIN OPERACION.SGAT_EF_ETAPA_PRM P
                  ON S.UBISUC = P.EFEPV_CODV
                 AND P.EFEPN_ESTADO = 1
                 AND P.EFEPN_ID_PADRE IN
                   (SELECT A.EFEPN_ID
                      FROM OPERACION.SGAT_EF_ETAPA_PRM A
                     WHERE EFEPV_TRANSACCION = 'REGLAS_POLITICA'
                       AND EFEPV_DESCRIPCION = 'TIPO 2')
               WHERE CODSUC = K_SUC;

           EXCEPTION
              WHEN OTHERS THEN
                 K_CODIGO  := COD_ERROR_EXCEPTION_INTERNO;
                 K_MENSAJE := 'SGAFUN_GET_POLITICAS. SQLCODE: ' || TO_CHAR(SQLCODE) || ' - SQLERRM: ' || SQLERRM;
                 RETURN NULL;
           END;

           IF K_DISTANCIA <= V_DATO AND V_DATO IS NOT NULL THEN
              V_RESULT := 'TIPO 2';
           ELSE
              V_RESULT := 'TIPO 3';
           END IF;
        END IF;
     END IF;

     K_CODIGO  := COD_EXITO;
     K_MENSAJE := MENSAJE_EXITO;
     RETURN V_RESULT;

  EXCEPTION
     WHEN OTHERS THEN
        K_CODIGO  := COD_ERROR_EXCEPTION_INTERNO;
        K_MENSAJE := 'SGAFUN_GET_POLITICAS. SQLCODE: ' || TO_CHAR(SQLCODE) || ' - SQLERRM: ' || SQLERRM;
        RETURN NULL;
  END;

  --------------------------------------------------------------
  PROCEDURE SGASS_GET_PARTIDAS(K_ID_RECOSTEO OPERACION.SGAT_EF_PARTIDA_CAB.EFPCN_ID%TYPE,
                               K_PARTIDA_LS  OUT T_PARTIDA_LS,
                               K_CODIGO      OUT PLS_INTEGER,
                               K_MENSAJE     OUT VARCHAR2) IS

     C_PARTIDA   OPERACION.SGAT_EF_ETAPA_CNFG.EFECV_CODPAR%TYPE;
     C_CANTIDAD  OPERACION.SGAT_EF_ETAPA_CNFG.EFECN_CANTIDAD%TYPE;
     LC_PARTIDAS SYS_REFCURSOR;
     V_NUM       PLS_INTEGER := 0;
  BEGIN
     OPEN LC_PARTIDAS FOR
        SELECT EFPDV_CODPAR, EFPDN_CANTIDAD
          FROM OPERACION.SGAT_EF_PARTIDA_DET P
         WHERE EFPDN_ID = K_ID_RECOSTEO
          AND P.EFPDV_CODPAR LIKE 'RN%';
     LOOP
        FETCH LC_PARTIDAS
           INTO C_PARTIDA, C_CANTIDAD;
        EXIT WHEN LC_PARTIDAS%NOTFOUND;

        V_NUM := V_NUM + 1;
        K_PARTIDA_LS(V_NUM).PARTIDA := C_PARTIDA;
        K_PARTIDA_LS(V_NUM).CANT := C_CANTIDAD;
     END LOOP;
     CLOSE LC_PARTIDAS;

     K_CODIGO  := COD_EXITO;
     K_MENSAJE := MENSAJE_EXITO;

  EXCEPTION
     WHEN OTHERS THEN
        K_CODIGO  := COD_ERROR_EXCEPTION_INTERNO;
        K_MENSAJE := 'SGASS_GEF_PARTIDAS. SQLCODE: ' || TO_CHAR(SQLCODE) || ' - SQLERRM: ' || SQLERRM;
  END;

  --------------------------------------------------------------
  FUNCTION SGAFUN_GET_CANTIDAD(K_CODACT        OPERACION.SGAT_EF_ETAPA_SRVC.EFESC_CODACT%TYPE,
                               K_CANTIDAD      OPERACION.SGAT_EF_ETAPA_CNFG.EFECN_CANTIDAD%TYPE,
                               K_CANALIZADO1   PLS_INTEGER,
                               K_PANDUIT       PLS_INTEGER,
                               K_INPUT         PLS_INTEGER,
                               K_PERM_MUNIC    PLS_INTEGER,
                               K_AUT_MINCULT   PLS_INTEGER,
                               K_ZONA_LIMA     PLS_INTEGER,
                               K_CONTRATA_LOC  PLS_INTEGER,
                               K_CANALIZADO2   NUMBER,
                               K_TENDIDO_C     NUMBER,
                               K_TENDIDO_A     NUMBER,
                               K_CAMARA        PLS_INTEGER,
                               K_POSTE         PLS_INTEGER,
                               K_POSTE_T       PLS_INTEGER,
                               K_CODIGO        OUT PLS_INTEGER,
                               K_MENSAJE       OUT VARCHAR2)
     RETURN NUMBER IS

     C_CANTIDAD OPERACION.SGAT_EF_ETAPA_CNFG.EFECN_CANTIDAD%TYPE;

  BEGIN
     C_CANTIDAD := 0;

     CASE K_CODACT
        WHEN 'MA001' THEN
             C_CANTIDAD := K_CANTIDAD;

        WHEN 'MA002' THEN
             C_CANTIDAD := OPERACION.PKG_EF_COSTEO_FORMULA.SGAFUN_002_IMPEXPEDGESMUN(K_PERM_MUNIC,
                                                                                     K_CANALIZADO1,
                                                                                     K_CANALIZADO2,
                                                                                     K_CAMARA,
                                                                                     K_ZONA_LIMA);

        WHEN 'MA003' THEN
             C_CANTIDAD := OPERACION.PKG_EF_COSTEO_FORMULA.SGAFUN_003_PLANSENALDESVIO(K_PERM_MUNIC,
                                                                                     K_CANALIZADO1,
                                                                                     K_CANALIZADO2,
                                                                                     K_CAMARA);

        WHEN 'MA004' THEN
             C_CANTIDAD := OPERACION.PKG_EF_COSTEO_FORMULA.SGAFUN_004_POSTEACTIVIDAD(K_POSTE);

        WHEN 'MA005' THEN
             C_CANTIDAD := OPERACION.PKG_EF_COSTEO_FORMULA.SGAFUN_005_FIBREDAERCANAL(K_TENDIDO_A,
                                                                                     K_TENDIDO_C);

        WHEN 'MA006' THEN
             C_CANTIDAD := OPERACION.PKG_EF_COSTEO_FORMULA.SGAFUN_006_CABLEFIBROPTIPROY(K_TENDIDO_A,
                                                                                        K_TENDIDO_C,
                                                                                        K_INPUT);

        WHEN 'MA007' THEN
             C_CANTIDAD := OPERACION.PKG_EF_COSTEO_FORMULA.SGAFUN_007_OTROSTENDIDO(K_TENDIDO_A,
                                                                                   K_TENDIDO_C);

        WHEN 'MA008' THEN
             C_CANTIDAD := OPERACION.PKG_EF_COSTEO_FORMULA.SGAFUN_008_POSTEMATERIAL(K_POSTE);

        WHEN 'MA009' THEN
             C_CANTIDAD := OPERACION.PKG_EF_COSTEO_FORMULA.SGAFUN_009_MATPANDUITFUSION(K_PANDUIT);

        WHEN 'MA010' THEN
             C_CANTIDAD := OPERACION.PKG_EF_COSTEO_FORMULA.SGAFUN_010_CABLEFIBROPT96FSM(K_TENDIDO_A,
                                                                                        K_TENDIDO_C);

        WHEN 'MA011' THEN
             C_CANTIDAD := OPERACION.PKG_EF_COSTEO_FORMULA.SGAFUN_011_FIBREDAERCANAL96FSM(K_TENDIDO_A,
                                                                                          K_TENDIDO_C);

        WHEN 'MA012' THEN
             C_CANTIDAD := OPERACION.PKG_EF_COSTEO_FORMULA.SGAFUN_012_POSTEMPRELECTRICA(K_POSTE_T);

        WHEN 'MA013' THEN
             C_CANTIDAD := OPERACION.PKG_EF_COSTEO_FORMULA.SGAFUN_013_MATINPUT(K_INPUT);

        WHEN 'MA014' THEN
             C_CANTIDAD := OPERACION.PKG_EF_COSTEO_FORMULA.SGAFUN_014_PAGOMINCULTURA(K_AUT_MINCULT);

        WHEN 'MA015' THEN
             C_CANTIDAD := OPERACION.PKG_EF_COSTEO_FORMULA.SGAFUN_015_PAGOGESTPERMISO(K_PERM_MUNIC);

        WHEN 'MA016' THEN
             C_CANTIDAD := OPERACION.PKG_EF_COSTEO_FORMULA.SGAFUN_016_CANAPROY1VIA(K_CANALIZADO1);

        WHEN 'MA017' THEN
             C_CANTIDAD := OPERACION.PKG_EF_COSTEO_FORMULA.SGAFUN_017_CANAPROYMAS1VIA(K_CANALIZADO2);

        WHEN 'MA018' THEN
             C_CANTIDAD := OPERACION.PKG_EF_COSTEO_FORMULA.SGAFUN_018_CAMARAPROYECTA(K_CAMARA);

        WHEN 'MA019' THEN
             C_CANTIDAD := OPERACION.PKG_EF_COSTEO_FORMULA.SGAFUN_019_OTROSCANA1VIA(K_CANALIZADO1,
                                                                                    K_CANALIZADO2);

        WHEN 'MA020' THEN
             C_CANTIDAD := OPERACION.PKG_EF_COSTEO_FORMULA.SGAFUN_020_OTROSCANAMAS1VIA(K_CANALIZADO2);

        WHEN 'MA021' THEN
             C_CANTIDAD := OPERACION.PKG_EF_COSTEO_FORMULA.SGAFUN_021_CANAL_MARCOTAPCAM(K_CAMARA);

        WHEN 'MA022' THEN
             C_CANTIDAD := OPERACION.PKG_EF_COSTEO_FORMULA.SGAFUN_022_LIQUIDAPERMISO(K_PERM_MUNIC,
                                                                                     K_CANALIZADO1,
                                                                                     K_CANALIZADO2,
                                                                                     K_TENDIDO_A,
                                                                                     K_TENDIDO_C);

        WHEN 'MA023' THEN
             C_CANTIDAD := OPERACION.PKG_EF_COSTEO_FORMULA.SGAFUN_023_FLETE(K_CONTRATA_LOC);

        WHEN 'MA024' THEN
             C_CANTIDAD := OPERACION.PKG_EF_COSTEO_FORMULA.SGAFUN_024_PASAJE(K_CONTRATA_LOC);

        WHEN 'MA025' THEN
             C_CANTIDAD := OPERACION.PKG_EF_COSTEO_FORMULA.SGAFUN_025_HOSPEDA_ALIMEN(K_CONTRATA_LOC);

        WHEN 'MA026' THEN
             C_CANTIDAD := OPERACION.PKG_EF_COSTEO_FORMULA.SGAFUN_026_MATFERINSTFOAEREA(K_TENDIDO_A);

        WHEN 'MA027' THEN
             C_CANTIDAD := 0;

        WHEN 'MA028' THEN
             C_CANTIDAD := 0;

        ELSE
             C_CANTIDAD := 0;
     END CASE;

     IF C_CANTIDAD IS NULL THEN
        K_CODIGO  := COD_ERROR_PROCESO;
        K_MENSAJE := MENSAJE_SIN_DATOS;
     ELSE
        K_CODIGO  := COD_EXITO;
        K_MENSAJE := MENSAJE_EXITO;
     END IF;

     RETURN C_CANTIDAD;

  EXCEPTION
     WHEN OTHERS THEN
        K_CODIGO  := COD_ERROR_EXCEPTION_INTERNO;
        K_MENSAJE := 'SGAFUN_GEF_CANTIDAD. SQLCODE: ' || TO_CHAR(SQLCODE) || ' - SQLERRM: ' || SQLERRM;
        RETURN NULL;
  END;

  --------------------------------------------------------------
  PROCEDURE SGASI_INSERTAR_COSTEO_PINT(K_EF           OPERACION.EF.CODEF%TYPE,
                                       K_REGLA_PINT   OPERACION.SGAT_EF_REGLACOSTEO_PINT.EFRCN_PINT%TYPE,
                                       K_EQUIPOCOMP_T T_EQUIPOCOMP,
                                       K_PUNTO        OPERACION.EFPTOEQU.PUNTO%TYPE,
                                       K_CODIGO       OUT PLS_INTEGER,
                                       K_MENSAJE      OUT VARCHAR2) IS

     V_EQUIPOS_PINT_T T_EQUIPOS_PINT;
     V_CODTIPEQU      OPERACION.TIPEQU.CODTIPEQU%TYPE;
     V_COSTO          OPERACION.TIPEQU.COSTO%TYPE;
     V_ORDEN          PLS_INTEGER;
     V_SQL            VARCHAR2(2000);
  BEGIN
     BEGIN
        SELECT B.EFQCV_CODMAT
        BULK COLLECT INTO V_EQUIPOS_PINT_T
          FROM OPERACION.SGAT_EF_EQUIPO_SRVC A
         INNER JOIN OPERACION.SGAT_EF_EQUIPO_CNFG B
            ON A.EFEQN_ID = B.EFEQN_ID
         WHERE A.EFEQN_ID = K_REGLA_PINT
           AND A.EFEQN_ESTADO = 1;
     EXCEPTION
        WHEN OTHERS THEN
           K_CODIGO  := COD_ERROR_EXCEPTION_INTERNO;
           K_MENSAJE := 'SGASI_INSERTAR_COSTEO_PINT. SQLCODE: ' || TO_CHAR(SQLCODE) || ' - SQLERRM: ' || SQLERRM;
           RETURN;
     END;

     IF V_EQUIPOS_PINT_T.COUNT < 1 THEN
        K_CODIGO  := COD_ERROR_VALIDACION;
        K_MENSAJE := 'NO SE ENCONTRO PARTIDAS DE EQUIPOS PARA CALCULAR COSTO PINT';
        RETURN;
     END IF;

     -- INSERTANDO REGISTROS PARA PARTIDAS DE EQUIPOS - COSTO PINT
     BEGIN
        SELECT NVL(MAX(ORDEN), 0)
          INTO V_ORDEN
          FROM OPERACION.EFPTOEQU
         WHERE CODEF = K_EF
           AND PUNTO = K_PUNTO;
     EXCEPTION
        WHEN OTHERS THEN
           K_CODIGO  := COD_ERROR_EXCEPTION_INTERNO;
           K_MENSAJE := 'SGASI_INSERTAR_COSTEO_PINT. SQLCODE: ' || TO_CHAR(SQLCODE) || ' - SQLERRM: ' || SQLERRM;
           RETURN;
     END;

     FOR Z IN V_EQUIPOS_PINT_T.FIRST .. V_EQUIPOS_PINT_T.LAST LOOP
        BEGIN
           V_SQL := '
                 SELECT A.CODTIPEQU, A.COSTO
                 FROM  OPERACION.TIPEQU A,
                        PRODUCCION.ALMTABMAT B,
                        FINANCIAL.Z_PS_VAL_BUSQUEDA_DET C
                  WHERE B.CODMAT (+) = A.CODTIPEQU
                        AND C.VALOR(+) = NVL(B.COMPONENTE,''@'')
                        AND A.ESTEQU = 1
                        AND A.TIPEQU LIKE ' || V_EQUIPOS_PINT_T(Z) ||
                    ' AND C.CODIGO(+) = ''TIPO_COMP''';

           EXECUTE IMMEDIATE V_SQL
              INTO V_CODTIPEQU, V_COSTO;

           INSERT INTO OPERACION.EFPTOEQU
              (CODEF,
               PUNTO,
               ORDEN,
               CODTIPEQU,
               TIPPRP,
               OBSERVACION,
               COSTEAR,
               CANTIDAD,
               COSTO,
               CODEQUCOM,
               TIPEQU,
               CODETA,
               IDSPCAB,
               FLGSOLMEDIDA,
               CODPROVINSTALACION,
               CODPROVMANTENIM,
               SLA)
           VALUES
              (K_EF,
               K_PUNTO,
               V_ORDEN + Z,
               V_CODTIPEQU,
               0,
               NULL,
               1,
               1,
               V_COSTO,
               NULL,
               V_EQUIPOS_PINT_T(Z),
               647,
               NULL,
               NULL,
               NULL,
               NULL,
               '4');

        EXCEPTION
           WHEN OTHERS THEN
              K_CODIGO  := COD_ERROR_EXCEPTION_INTERNO;
              K_MENSAJE := 'SGASI_INSERTAR_COSTEO_PINT. SQLCODE: ' || TO_CHAR(SQLCODE) || ' - SQLERRM: ' || SQLERRM;
              RETURN;
        END;
     END LOOP;

     -- INSERTANDO REGISTROS PARA EQUIPOS ROUTER - COSTO PINT
     IF K_EQUIPOCOMP_T.COUNT > 0 THEN
        BEGIN
           -- SE BORRA LOS EQUIPOS DE LOS PUNTOS QUE NO ENCUENTREN EN EL PRY
           DELETE OPERACION.EFPTOEQU
            WHERE CODEF = K_EF
              AND PUNTO NOT IN
                  (SELECT PUNTO FROM OPERACION.EFPTO WHERE CODEF = K_EF);

           -- SE BORRA TODO LO QUE SEA CISCO Y MOTOROLA, EL RESTO QUEDA
           DELETE OPERACION.EFPTOEQU
            WHERE CODEF = K_EF
              AND TIPEQU IN
                  (SELECT TIPEQU FROM OPERACION.TIPEQU WHERE GRPTIPEQU IN (1, 6));
        EXCEPTION
           WHEN OTHERS THEN
              K_CODIGO  := COD_ERROR_EXCEPTION_INTERNO;
              K_MENSAJE := 'SGASI_INSERTAR_COSTEO_PINT. SQLCODE: ' || TO_CHAR(SQLCODE) || ' - SQLERRM: ' || SQLERRM;
              RETURN;
        END;

        -- SE INSERTAN LOS EQUIPOS
        FOR Z IN K_EQUIPOCOMP_T.FIRST .. K_EQUIPOCOMP_T.LAST LOOP
           BEGIN
              SELECT NVL(MAX(ORDEN), 0) + 1
                INTO V_ORDEN
                FROM OPERACION.EFPTOEQU
               WHERE CODEF = K_EF
                 AND PUNTO = K_EQUIPOCOMP_T(Z).PUNTO;

              INSERT INTO OPERACION.EFPTOEQU
                 (CODEF,
                  PUNTO,
                  ORDEN,
                  CODTIPEQU,
                  TIPEQU,
                  TIPPRP,
                  CANTIDAD,
                  CODEQUCOM,
                  COSTO,
                  CODETA,
                  SLA)
              VALUES
                 (K_EF,
                  K_EQUIPOCOMP_T(Z).PUNTO,
                  V_ORDEN,
                  K_EQUIPOCOMP_T(Z).CODTIPEQU,
                  K_EQUIPOCOMP_T(Z).TIPEQU,
                  K_EQUIPOCOMP_T(Z).TIPPRP,
                  K_EQUIPOCOMP_T(Z).CANTIDAD,
                  K_EQUIPOCOMP_T(Z).CODEQUCOM,
                  K_EQUIPOCOMP_T(Z).COSTO,
                  647,
                  '4');

              -- SE INSERTAN LOS COMPONENTES
              INSERT INTO OPERACION.EFPTOEQUCMP
                 (CODEF,
                  PUNTO,
                  ORDEN,
                  ORDENCMP,
                  CANTIDAD,
                  CODTIPEQU,
                  TIPEQU,
                  COSTO,
                  CODETA)
                 SELECT K_EF,
                        K_EQUIPOCOMP_T(Z).PUNTO,
                        V_ORDEN,
                        ROWNUM,
                        A.CANTIDAD,
                        A.CODTIPEQU,
                        A.TIPEQU,
                        B.COSTO,
                        647
                   FROM OPERACION.EQUCOMXOPE A
                   INNER JOIN OPERACION.TIPEQU B
                   ON A.CODEQUCOM = K_EQUIPOCOMP_T(Z).CODEQUCOM
                    AND A.TIPEQU = B.TIPEQU
                    AND A.ESPARTE = 1;

           EXCEPTION
              WHEN OTHERS THEN
                 K_CODIGO  := COD_ERROR_EXCEPTION_INTERNO;
                 K_MENSAJE := 'SGASI_INSERTAR_COSTEO_PINT. SQLCODE: ' || TO_CHAR(SQLCODE) || ' - SQLERRM: ' || SQLERRM;
                 RETURN;
           END;
        END LOOP;
     END IF;

     K_CODIGO  := COD_EXITO;
     K_MENSAJE := MENSAJE_EXITO;

  EXCEPTION
     WHEN OTHERS THEN
        K_CODIGO  := COD_ERROR_EXCEPTION_INTERNO;
        K_MENSAJE := 'SGASI_INSERTAR_COSTEO_PINT. SQLCODE: ' || TO_CHAR(SQLCODE) || ' - SQLERRM: ' || SQLERRM;
  END;

  --------------------------------------------------------------
  PROCEDURE SGASI_INSERTAR_COSTEO_PEXT(K_SEF         SALES.VTATABSLCFAC.NUMSLC%TYPE,
                                       K_SUC         SALES.VTADETPTOENL.CODSUC%TYPE,
                                       K_EF          OPERACION.EF.CODEF%TYPE,
                                       K_PUNTO       NUMBER,
                                       K_ESCENARIO   OPERACION.EFPTO.EFPTV_ESCENARIO%TYPE,
                                       K_POLITICA    OPERACION.EFPTO.EFPTV_POLITICA%TYPE,
                                       K_ID_RECOSTEO OPERACION.SGAT_EF_PARTIDA_CAB.EFPCN_ID%TYPE,
                                       K_CODIGO      OUT PLS_INTEGER,
                                       K_MENSAJE     OUT VARCHAR2) IS

     V_ETAPAS_PEXT_T T_ETAPAS_PEXT;
     V_PEXT_T        T_PEXT;
     V_PARTIDA_LS    T_PARTIDA_LS;
     ERROR_EX        EXCEPTION;
     V_SQL           VARCHAR2(2000);
     V_SQL2          VARCHAR2(1000);
     V_COND2         VARCHAR2(100);

     V_CANALIZADO1   PLS_INTEGER;
     V_PANDUIT       PLS_INTEGER;
     V_INPUT         PLS_INTEGER;
     V_PERM_MUNIC    PLS_INTEGER;
     V_AUT_MINCULT   PLS_INTEGER;
     V_ZONA_LIMA     PLS_INTEGER;
     V_CONTRATA_LOCAL PLS_INTEGER;

     V_CANALIZADO2   NUMBER(7,2) := 0;
     V_CAMARA        PLS_INTEGER := 0;
     V_TENDIDO_A     NUMBER(7,2) := 0;
     V_TENDIDO_C     NUMBER(7,2) := 0;
     V_POSTE         PLS_INTEGER := 0;
     V_POSTE_T       PLS_INTEGER := 0;

     C_COSTO         OPERACION.SGAT_EF_ETAPA_CNFG.EFECN_COSTO%TYPE;
     C_CANTIDAD      OPERACION.SGAT_EF_ETAPA_CNFG.EFECN_CANTIDAD%TYPE;
     C_COSTO_F22     OPERACION.SGAT_EF_ETAPA_CNFG.EFECN_COSTO%TYPE;

     V_MONEDA        CHAR(1);
  BEGIN
     K_CODIGO := 0;

      SGASS_GET_PARTIDAS(K_ID_RECOSTEO,
                         V_PARTIDA_LS,
                         K_CODIGO,
                         K_MENSAJE);

     IF K_CODIGO <> COD_EXITO THEN
        RETURN;
     END IF;

     --INSERTAR EN OPERACION.EFPTOETA
     V_COND2 := '';
     IF K_POLITICA <> 'TIPO 2' THEN
        V_COND2 := 'AND SRVC.EFESC_TIPPRC = ''N''';
     END IF;

     V_SQL := '
       SELECT DISTINCT SRVC.EFESN_CODETA
       FROM OPERACION.SGAT_EF_ETAPA_SRVC SRVC
       WHERE SRVC.EFESN_ESTADO = 1 ' || V_COND2 || '';

     EXECUTE IMMEDIATE V_SQL BULK COLLECT
        INTO V_ETAPAS_PEXT_T;

     IF V_ETAPAS_PEXT_T.COUNT < 1 THEN
        K_CODIGO  := COD_ERROR_PROCESO;
        K_MENSAJE := 'NO SE ENCONTRO ETAPAS PARA CALCULAR COSTO PEXT - POLITICA: ' || K_POLITICA;
        RETURN;
     END IF;

     FOR I IN V_ETAPAS_PEXT_T.FIRST .. V_ETAPAS_PEXT_T.LAST LOOP
     BEGIN
        INSERT INTO OPERACION.EFPTOETA
           (CODEF,
            PUNTO,
            CODETA,
            FECINI,
            FECFIN,
            COSMO,
            COSMOCLI,
            COSMAT,
            COSMATCLI,
            COSMO_S,
            COSMAT_S,
            PCCODTAREA)
        VALUES
           (K_EF,
            K_PUNTO,
            V_ETAPAS_PEXT_T(I),
            SYSDATE,
            SYSDATE,
            0,
            0,
            0,
            0,
            0,
            0,
            NULL);
     EXCEPTION
        WHEN OTHERS THEN
           K_CODIGO  := COD_ERROR_EXCEPTION_INTERNO;
           K_MENSAJE := 'SGASI_INSERTAR_COSTEO_PEXT. SQLCODE: ' || TO_CHAR(SQLCODE) || ' - SQLERRM: ' || SQLERRM;
           RETURN;
     END;
     END LOOP;

     --
     IF V_PARTIDA_LS.COUNT > 0 THEN
             FOR I IN V_PARTIDA_LS.FIRST .. V_PARTIDA_LS.LAST LOOP
           IF TRIM(V_PARTIDA_LS(I).PARTIDA) = 'RN0001' THEN
              V_CANALIZADO2 := V_PARTIDA_LS(I).CANT;
           END IF;

           IF TRIM(V_PARTIDA_LS(I).PARTIDA) = 'RN0002' THEN
              V_TENDIDO_C := V_PARTIDA_LS(I).CANT;
           END IF;

           IF TRIM(V_PARTIDA_LS(I).PARTIDA) = 'RN0003' THEN
              V_TENDIDO_A := V_PARTIDA_LS(I).CANT;
           END IF;

           IF TRIM(V_PARTIDA_LS(I).PARTIDA) = 'RN0004' THEN
              V_CAMARA := V_PARTIDA_LS(I).CANT;
           END IF;

           IF TRIM(V_PARTIDA_LS(I).PARTIDA) = 'RN0006' THEN
              V_POSTE := V_PARTIDA_LS(I).CANT;
           END IF;

           IF TRIM(V_PARTIDA_LS(I).PARTIDA) = 'RN0008' THEN
              V_POSTE_T := V_PARTIDA_LS(I).CANT;
           END IF;
        END LOOP;
     END IF;

     -- INSERTAR EN OPERACION.EFPTOETAACT - ACTIVIDADES
     V_COND2 := 'SRVC.EFESC_TIPPRC = ''N''';
     V_SQL2  := ' ';

     IF K_POLITICA = 'TIPO 2' THEN
        V_COND2 := 'SRVC.EFESC_TIPPRC = ''P''';

        IF V_CANALIZADO2 = 0 THEN
           V_COND2 := V_COND2 || ' AND SRVC.EFESC_CODACT NOT IN (''MA023'', ''MA024'', ''MA025'')';
        END IF;

        V_SQL2  := '

             UNION ALL

             SELECT DISTINCT
                    EFESC_CODACT, SRVC.EFESN_CODETA, SRVC.EFESC_TIPPRC, CNFG.EFECV_CODPAR, CNFG.EFECN_CANTIDAD, CNFG.EFECN_COSTO, CNFG.EFECN_COSTO_PROV
             FROM OPERACION.SGAT_EF_ETAPA_SRVC SRVC
             INNER JOIN OPERACION.SGAT_EF_ETAPA_CNFG CNFG
             ON SRVC.EFESN_ID = CNFG.EFESN_ID
             WHERE
                SRVC.EFESC_TIPPRC = ''N''
                AND SRVC.EFESN_ESTADO = 1
                AND CNFG.EFECN_TIPASG = 0
                AND (EFESC_CODACT || EFECV_CODPAR) NOT IN (SELECT (EFESC_CODACT || EFECV_CODPAR)
                                                          FROM OPERACION.SGAT_EF_ETAPA_SRVC SRVC
                                                          INNER JOIN OPERACION.SGAT_EF_ETAPA_CNFG CNFG
                                                          ON SRVC.EFESN_ID = CNFG.EFESN_ID
                                                          WHERE
                                                             ' || V_COND2 ||
                                                             ' AND SRVC.EFESN_ESTADO = 1
                                                             AND CNFG.EFECN_TIPASG = 0)';
     END IF;

     V_SQL := '
         SELECT
             EFESC_CODACT, EFESN_CODETA, EFESC_TIPPRC, EFECV_CODPAR, EFECN_CANTIDAD, EFECN_COSTO, EFECN_COSTO_PROV,
             (SELECT MONEDA_ID FROM PRODUCCION.CTBTABMON WHERE SBLMON = OPERACION.F_GET_MONEDAP(EFECV_CODPAR)) MONEDA_ID,
             PACT.CODPREC
         FROM
             (SELECT DISTINCT
                    EFESC_CODACT, SRVC.EFESN_CODETA, SRVC.EFESC_TIPPRC, CNFG.EFECV_CODPAR, CNFG.EFECN_CANTIDAD, CNFG.EFECN_COSTO, CNFG.EFECN_COSTO_PROV
             FROM OPERACION.SGAT_EF_ETAPA_SRVC SRVC
             INNER JOIN OPERACION.SGAT_EF_ETAPA_CNFG CNFG
             ON SRVC.EFESN_ID = CNFG.EFESN_ID
             WHERE '
                || V_COND2 ||
                ' AND SRVC.EFESN_ESTADO = 1
                AND CNFG.EFECN_TIPASG = 0 '
             || V_SQL2 || '
              ) S
          INNER JOIN OPERACION.ACTXPRECIARIO PACT
          ON S.EFECV_CODPAR = PACT.CODACT
          WHERE
             PACT.ACTIVO = 1
          ORDER BY EFESC_CODACT ASC';

     --DBMS_OUTPUT.PUT_LINE(V_SQL);

     EXECUTE IMMEDIATE V_SQL BULK COLLECT
        INTO V_PEXT_T;

     IF V_PEXT_T.COUNT > 0 THEN
        V_CANALIZADO1    := SGAFUN_GET_PARAM_REGNEGO('CANALIZACION_PROYECTADA_VIA', K_ESCENARIO, K_CODIGO, K_MENSAJE);
        V_PANDUIT        := SGAFUN_GET_PARAM_REGNEGO('MATERIAL_PANDUIT_FUSION', K_ESCENARIO, K_CODIGO, K_MENSAJE);
        V_INPUT          := SGAFUN_GET_PARAM_REGNEGO('MATERIAL_INPUT', K_ESCENARIO, K_CODIGO, K_MENSAJE);
        V_PERM_MUNIC     := SGAFUN_PERMISOMUNICIPAL(K_SUC, K_CODIGO, K_MENSAJE);
        V_AUT_MINCULT    := SGAFUN_AUTORIZA_MINCULTURA(K_SUC, K_CODIGO, K_MENSAJE);
        V_ZONA_LIMA      := SGAFUN_ZONALIMA(K_SUC, K_CODIGO, K_MENSAJE);
        V_CONTRATA_LOCAL := SGAFUN_CONTRATA_LOCALIA(K_SUC, K_CODIGO, K_MENSAJE);

        C_COSTO_F22      := 0;

        FOR I IN V_PEXT_T.FIRST .. V_PEXT_T.LAST LOOP
           C_CANTIDAD := SGAFUN_GET_CANTIDAD( V_PEXT_T     (I).EFESC_CODACT,
                                              V_PEXT_T     (I).EFECN_CANTIDAD,
                                              V_CANALIZADO1,
                                              V_PANDUIT,
                                              V_INPUT,
                                              V_PERM_MUNIC,
                                              V_AUT_MINCULT,
                                              V_ZONA_LIMA,
                                              V_CONTRATA_LOCAL,
                                              V_CANALIZADO2,
                                              V_TENDIDO_C,
                                              V_TENDIDO_A,
                                              V_CAMARA,
                                              V_POSTE,
                                              V_POSTE_T,
                                              K_CODIGO,
                                              K_MENSAJE);

           IF K_CODIGO <> COD_EXITO THEN
              RETURN;
           END IF;

           C_COSTO := V_PEXT_T(I).EFECN_COSTO;
           IF V_ZONA_LIMA = 0 THEN
              C_COSTO := V_PEXT_T(I).EFECN_COSTO_PROV;
           END IF;

           ---- PRECIO PARA FORMULA 22 ----
           IF V_PEXT_T(I).EFESC_CODACT <> 'MA022' AND V_PEXT_T(I).EFESC_CODACT NOT IN ('MA001','MA002','MA003','MA014','MA015') THEN
              C_COSTO_F22 := C_COSTO_F22 + C_CANTIDAD * C_COSTO;
           END IF;

           IF V_PEXT_T(I).EFESC_CODACT = 'MA022' THEN
              IF C_COSTO_F22 > C_COSTO * 10 THEN
                 C_COSTO := C_COSTO_F22 * 0.1;
              END IF;
           END IF;
           -- FIN PRECIO FORMULA 22 -----

           IF V_PEXT_T(I).MONEDA_ID = 1 THEN
              V_MONEDA := 'S';
           END IF;

           IF V_PEXT_T(I).MONEDA_ID = 2 THEN
              V_MONEDA := 'D';
           END IF;

           ------------------------------------
           BEGIN
              INSERT INTO OPERACION.EFPTOETAACT
                 (CODEF,
                  PUNTO,
                  CODETA,
                  CODACT,
                  COSTO,
                  CANTIDAD,
                  OBSERVACION,
                  FECUSU,
                  CODUSU,
                  MONEDA,
                  MONEDA_ID,
                  CODPREC)
              VALUES
                 (K_EF,
                  K_PUNTO,
                  V_PEXT_T   (I).EFESN_CODETA,
                  V_PEXT_T   (I).EFECV_CODPAR,
                  C_COSTO,
                  C_CANTIDAD,
                  NULL,
                  SYSDATE,
                  USER,
                  V_MONEDA,
                  V_PEXT_T   (I).MONEDA_ID,
                  V_PEXT_T   (I).CODPREC);
           EXCEPTION
              WHEN OTHERS THEN
                 K_CODIGO  := COD_ERROR_EXCEPTION_INTERNO;
                 K_MENSAJE := 'SGASI_INSERTAR_COSTEO_PEXT. SQLCODE: ' || TO_CHAR(SQLCODE) || ' - SQLERRM: ' || SQLERRM;
                 RETURN;
           END;
        END LOOP;
     END IF;

  EXCEPTION
     WHEN NO_DATA_FOUND THEN
        K_CODIGO  := COD_ERROR_EXCEPTION_INTERNO;
        K_MENSAJE := 'SGASI_INSERTAR_COSTEO_PEXT. SQLCODE: ' || TO_CHAR(SQLCODE) || ' - SQLERRM: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

     WHEN OTHERS THEN
        K_CODIGO  := COD_ERROR_EXCEPTION_INTERNO;
        K_MENSAJE := 'SGASI_INSERTAR_COSTEO_PEXT. SQLCODE: ' || TO_CHAR(SQLCODE) || ' - SQLERRM: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
  END;

  ----- PROCEDIMIENTOS PUBLICOS --------------------
  --------------------------------------------------
  PROCEDURE SGASS_MUFA_REGLA_PINT(K_SEF             SALES.VTATABSLCFAC.NUMSLC%TYPE,
                                  K_SUC             SALES.VTADETPTOENL.CODSUC%TYPE,
                                  K_POP_GIS         METASOLV.UBIRED.UBIRV_CODUBIRED_GIS%TYPE,
                                  K_HILO            METASOLV.SGAT_PEX_FIBRA.FIBRN_CODFIBRA%TYPE,
                                  K_DIST_POPCLIENTE OPERACION.EFPTO.LONFIBRA%TYPE,
                                  K_ESCENARIO       OPERACION.EFPTO.EFPTV_ESCENARIO%TYPE,
                                  K_CODIGO          OUT PLS_INTEGER,
                                  K_MENSAJE         OUT VARCHAR2) IS

    V_ANCHOBANDA_T    T_ANCHO_BANDA;
    V_EQUIPO_T        T_EQUIPO;
    C_EQUIPO_PINT     OPERACION.SGAT_EF_REGLACOSTEO_PINT.EFRCN_PINT%TYPE;
    V_KILO            CLOB;
    V_TIPOFIBRA       VARCHAR2(5);
    V_NUM             PLS_INTEGER := 0;
    V_ANCHO_BANDA     VARCHAR2(100);
  BEGIN
    IF K_HILO IS NULL THEN
       K_CODIGO  := COD_ERROR_VALIDACION;
       K_MENSAJE := 'HILO NO PUEDE SER NULO';
       RETURN;
    END IF;

    SELECT TO_CLOB(' SELECT ' || K_HILO || ' NUM_HILO FROM DUAL ')
      INTO V_KILO
      FROM DUAL;

    V_ANCHOBANDA_T := SGAFUN_GET_ANCHOBANDA(K_SEF, K_SUC, K_CODIGO, K_MENSAJE);

    IF K_CODIGO <> COD_EXITO THEN
       IF V_ANCHOBANDA_T.COUNT < 1 THEN
            K_CODIGO  := COD_ERROR_VALIDACION;
            K_MENSAJE := 'SEF NO TIENE ANCHO DE BANDA PARA LA SUCURSAL ' || K_SUC;
       END IF;

       RETURN;
    END IF;

    V_ANCHO_BANDA := SGAFUN_GET_ID_ANCHOBANDA(V_ANCHOBANDA_T(1).BANWID_MB, K_CODIGO, K_MENSAJE);

    IF K_CODIGO <> COD_EXITO THEN
       RETURN;
    END IF;

    V_EQUIPO_T := SGAFUN_GET_EQUIPORED(K_POP_GIS, V_ANCHO_BANDA, K_CODIGO, K_MENSAJE);

    IF K_CODIGO <> COD_EXITO THEN
       IF V_EQUIPO_T.COUNT < 1 THEN
            K_CODIGO  := COD_ERROR_VALIDACION;
            K_MENSAJE := 'NO SE ENCONTRO EQUIPO DE RED PARA COSTEAR PINT';
       END IF;

       RETURN;
    END IF;

    V_NUM := SGAFUN_VAL_ESCENARIO(K_ESCENARIO, K_CODIGO, K_MENSAJE);

    --IF K_CODIGO <> COD_EXITO THEN
    IF V_NUM <> 1 THEN
       RETURN;
    END IF;

    SGASS_GET_EQUIPO_PINT (K_SEF,
                          K_SUC,
                          K_POP_GIS,
                          V_ANCHO_BANDA,
                          V_KILO,
                          NVL(K_DIST_POPCLIENTE, 0),
                          K_ESCENARIO,
                          V_EQUIPO_T,
                          C_EQUIPO_PINT,
                          V_TIPOFIBRA,
                          K_CODIGO, K_MENSAJE);

    IF K_CODIGO <> COD_EXITO THEN
      IF K_CODIGO <> COD_ERROR_EXCEPTION_INTERNO THEN
         IF C_EQUIPO_PINT = -20 THEN
           K_CODIGO := -20;
         ELSE
           K_CODIGO := COD_ERROR_PROCESO;
         END IF;
      END IF;

      RETURN;
    END IF;

    K_CODIGO  := COD_EXITO;
    K_MENSAJE := 'MUFA CUMPLE CONDICIONES DE REGLA PINT (REGLA: ' || C_EQUIPO_PINT || ' )';

  EXCEPTION
    WHEN OTHERS THEN
      K_CODIGO  := COD_ERROR_EXCEPTION_INTERNO;
      K_MENSAJE := 'SGASS_MUFA_REGLA_PINT. SQLCODE: ' || TO_CHAR(SQLCODE) || ' - SQLERRM: ' || SQLERRM;
  END;

  --------------------------------------------------------------
   PROCEDURE SGASI_EF_COSTEO(K_SEF              SALES.VTATABSLCFAC.NUMSLC%TYPE,
                             K_SUC              SALES.VTADETPTOENL.CODSUC%TYPE,
                             K_ESCENARIO        OPERACION.EFPTO.EFPTV_ESCENARIO%TYPE,
                             K_PARTIDAS         CLOB,
                             K_RFS_GIS          OPERACION.EFPTO.EFPTV_RFS_GIS%TYPE,
                             K_POP_GIS          METASOLV.UBIRED.UBIRV_CODUBIRED_GIS%TYPE,
                             K_HILOS            CLOB,
                             K_DIST_POPCLIENTE  OPERACION.EFPTO.LONFIBRA%TYPE,
                             K_DIST_OBRACLIENTE OPERACION.EFPTO.EFPTN_LONFIBRA_PROY%TYPE,
                             K_PUNTO            OUT OPERACION.EFPTO.PUNTO%TYPE,
                             K_POLITICA         OUT OPERACION.EFPTO.EFPTV_POLITICA%TYPE,
                             K_EQUIPO_PINT      OUT OPERACION.SGAT_EF_REGLACOSTEO_PINT.EFRCN_PINT%TYPE,
                             K_TIPOFIBRA        OUT VARCHAR2,
                             K_CODIGO           OUT PLS_INTEGER,
                             K_MENSAJE          OUT VARCHAR2) IS

      V_ANCHOBANDA_T  T_ANCHO_BANDA;
      V_EQUIPOCOMP_T  T_EQUIPOCOMP;
      V_EQUIPO_T      T_EQUIPO;
      C_EQUIPO_PINT   OPERACION.SGAT_EF_REGLACOSTEO_PINT.EFRCN_PINT%TYPE;
      C_EF            OPERACION.EF.CODEF%TYPE;
      C_DISTANCIA     OPERACION.EFPTO.LONFIBRA%TYPE;
      C_POLITICA      OPERACION.EFPTO.EFPTV_POLITICA%TYPE;
      C_ID_RECOSTEO   OPERACION.SGAT_EF_PARTIDA_CAB.EFPCN_ID%TYPE;
      ERROR_EX        EXCEPTION;
      V_NUM           PLS_INTEGER := 0;
      V_ANCHO_BANDA   VARCHAR2(100);
   BEGIN
      K_CODIGO       := COD_EXITO;
      C_EQUIPO_PINT  := 0;

      -- VERIFICAR PARAMETROS
      IF K_SEF IS NULL THEN
         K_CODIGO  := COD_ERROR_VALIDACION;
         K_MENSAJE := 'SEF NO PUEDE TENER VALOR NULO';
         RETURN;
      END IF;

      IF K_SUC IS NULL THEN
         K_CODIGO  := COD_ERROR_VALIDACION;
         K_MENSAJE := 'SUCURSAL NO PUEDE TENER VALOR NULO';
         RETURN;
      END IF;

      -- VALIDAR QUE ESCENARIO SEA CORRECTO
      V_NUM := SGAFUN_VAL_ESCENARIO(K_ESCENARIO, K_CODIGO, K_MENSAJE);

      IF K_CODIGO <> COD_EXITO THEN
          RAISE ERROR_EX;
      END IF;

      -- VERIFICAR QUE SUCURSAL PERTENECE A SEF
      SELECT COUNT(DISTINCT CODSUC)
      INTO V_NUM
      FROM SALES.VTADETPTOENL
      WHERE NUMSLC = K_SEF
       AND CODSUC = K_SUC;

      IF V_NUM < 1 THEN
         K_CODIGO  := COD_ERROR_VALIDACION;
         K_MENSAJE := 'SUCURSAL INCORRECTA PARA SEF';
         RETURN;
      END IF;

      -- CONSEGUIR CODIGO EF DE SEF
      C_EF := SGAFUN_GEF_EF(K_SEF, K_CODIGO, K_MENSAJE);

       IF K_CODIGO <> COD_EXITO THEN
           RAISE ERROR_EX;
       END IF;

      -- CONSEGUIR ANCHO DE BANDA
      V_ANCHOBANDA_T := SGAFUN_GET_ANCHOBANDA(K_SEF, K_SUC, K_CODIGO, K_MENSAJE);

      IF K_CODIGO <> COD_EXITO THEN
          IF V_ANCHOBANDA_T.COUNT < 1 THEN
               K_CODIGO  := COD_ERROR_VALIDACION;
               K_MENSAJE := 'SEF NO TIENE ANCHO DE BANDA PARA LA SUCURSAL ' || K_SUC;
          END IF;

          RAISE ERROR_EX;
      END IF;

      -- CONSEGUIR EQUIPOS COMPONENTES (ROUTER)
      V_EQUIPOCOMP_T := SGAFUN_GET_EQUIPOCOMP(K_SEF,
                                              K_SUC,
                                              K_CODIGO,
                                              K_MENSAJE);

      -- BORRAR DATOS DE COSTEO ANTERIOR
      BEGIN
         IF V_EQUIPOCOMP_T.COUNT > 0 THEN
            DELETE FROM OPERACION.EFPTOEQUCMP C
             WHERE CODEF = C_EF
               AND PUNTO = V_EQUIPOCOMP_T(1).PUNTO;
            DELETE FROM OPERACION.EFPTOEQU C
             WHERE CODEF = C_EF
               AND PUNTO = V_EQUIPOCOMP_T(1).PUNTO;
         END IF;

         DELETE FROM OPERACION.EFPTOEQU C
          WHERE CODEF = C_EF
            AND PUNTO = V_ANCHOBANDA_T(1).NUMPTO;
         DELETE FROM OPERACION.EFPTOETAACT C
          WHERE CODEF = C_EF
            AND PUNTO = V_ANCHOBANDA_T(1).NUMPTO;
         DELETE FROM OPERACION.EFPTOETAMAT C
          WHERE CODEF = C_EF
            AND PUNTO = V_ANCHOBANDA_T(1).NUMPTO;
         DELETE FROM OPERACION.EFPTOETA C
          WHERE CODEF = C_EF
            AND PUNTO = V_ANCHOBANDA_T(1).NUMPTO;

         UPDATE OPERACION.EFPTO T
            SET POP                 = NULL,
                LONFIBRA            = NULL,
                EFPTV_ESCENARIO     = NULL,
                EFPTV_TIPO_COSTEO   = NULL,
                EFPTN_LONFIBRA_PROY = NULL,
                EFPTV_RFS_GIS       = NULL,
                EFPTV_POLITICA      = NULL,
                EFPTN_EQUIPOPINT    = NULL,
                MEDIOTX             = NULL,
                CODTIPFIBRA         = NULL,
                ACTCAD              = NULL,
                NUMDIAPLA           = NULL,
                COSMO               = 0.0,
                COSMAT              = 0.0,
                COSEQU              = 0.0,
                COSMOCLI            = 0.0,
                COSMATCLI           = 0.0,
                COSMO_S             = 0.0,
                COSMAT_S            = 0.0
          WHERE CODEF = C_EF
            AND PUNTO = V_ANCHOBANDA_T(1).NUMPTO;

         UPDATE OPERACION.EF T
            SET COSMO     = 0.0,
                COSMAT    = 0.0,
                COSEQU    = 0.0,
                COSMOCLI  = 0.0,
                COSMATCLI = 0.0,
                COSMO_S   = 0.0,
                COSMAT_S  = 0.0
          WHERE CODEF = C_EF;

      EXCEPTION
         WHEN OTHERS THEN
            K_CODIGO  := COD_ERROR_EXCEPTION_INTERNO;
            K_MENSAJE := 'ERROR AL BORRAR DATOS DE COSTEO ANTERIOR';
            RAISE ERROR_EX;
      END;

      --FOR J IN V_ANCHOBANDA_T.FIRST..V_ANCHOBANDA_T.LAST
      FOR J IN V_ANCHOBANDA_T.FIRST .. 1 LOOP
         -- CONSEGUIR ID DE ANCHO DE BANDA DE LA TABLA DE PARAMETROS
         V_ANCHO_BANDA := SGAFUN_GET_ID_ANCHOBANDA(V_ANCHOBANDA_T(1).BANWID_MB, K_CODIGO, K_MENSAJE);

         IF K_CODIGO <> COD_EXITO THEN
            RAISE ERROR_EX;
         END IF;

         -- CONSEGUIR EQUIPO DE RED
         V_EQUIPO_T := SGAFUN_GET_EQUIPORED(K_POP_GIS,
                                            V_ANCHO_BANDA,
                                            K_CODIGO,
                                            K_MENSAJE);

         IF K_CODIGO <> COD_EXITO THEN
            IF V_EQUIPO_T.COUNT < 1 THEN
               K_CODIGO  := COD_ERROR_VALIDACION;
               K_MENSAJE := 'NO SE ENCONTRO EQUIPO DE RED PARA COSTEAR PINT';
            END IF;

            RAISE ERROR_EX;
         END IF;

         C_DISTANCIA := NVL(K_DIST_POPCLIENTE, 0) + NVL(K_DIST_OBRACLIENTE, 0);

         -- ENCONTRANDO REGLA DE COSTEO PINT
         SGASS_GET_EQUIPO_PINT (K_SEF,
                                K_SUC,
                                K_POP_GIS,
                                V_ANCHO_BANDA,
                                K_HILOS,
                                C_DISTANCIA,
                                K_ESCENARIO,
                                V_EQUIPO_T,
                                C_EQUIPO_PINT,
                                K_TIPOFIBRA,
                                K_CODIGO,
                                K_MENSAJE);

          IF K_CODIGO <> COD_EXITO THEN
            RAISE ERROR_EX;
          END IF;

         -- INSERTANDO COSTO PINT PARA EF
         IF C_EQUIPO_PINT > 0 THEN
            SGASI_INSERTAR_COSTEO_PINT(C_EF,
                                       C_EQUIPO_PINT,
                                       V_EQUIPOCOMP_T,
                                       J,
                                       K_CODIGO,
                                       K_MENSAJE);

             IF K_CODIGO <> COD_EXITO THEN
               RAISE ERROR_EX;
             END IF;
         END IF;

         -- IDENTIFICANDO TIPO DE POLITICA
         K_POLITICA := SGAFUN_GET_POLITICAS(K_SUC,
                                            K_ESCENARIO,
                                            NVL(K_DIST_OBRACLIENTE, 0),
                                            K_CODIGO,
                                            K_MENSAJE);
          IF K_CODIGO <> COD_EXITO THEN
            RAISE ERROR_EX;
          END IF;

         C_POLITICA := K_POLITICA;
         IF C_POLITICA = 'TIPO 1' THEN
            C_POLITICA := 'TIPO 2';
         END IF;

         -- INSERTANDO PARTIDAS COMO CARGA INICIAL EN TABLA: SGAT_EF_PARTIDA_CAB Y SGAT_EF_PARTIDA_DET
         SGASI_GESTIONAR_EF_PARTIDA(K_RFS_GIS,
                                    K_PARTIDAS,
                                    5,
                                    K_CODIGO,
                                    K_MENSAJE);

         IF K_CODIGO <> COD_EXITO THEN
            RAISE ERROR_EX;
         END IF;

         BEGIN
            SELECT A.EFPCN_ID
              INTO C_ID_RECOSTEO
              FROM OPERACION.SGAT_EF_PARTIDA_CAB A
             WHERE A.EFPCN_ESTADO = 5 -- CARGA INICIAL
               AND A.EFPCN_ID =
                   (SELECT MAX(B.EFPCN_ID)
                      FROM OPERACION.SGAT_EF_PARTIDA_CAB B
                     WHERE B.EFPCV_RFS_GIS = A.EFPCV_RFS_GIS)
               AND A.EFPCV_RFS_GIS = K_RFS_GIS;

         EXCEPTION
            WHEN OTHERS THEN
               K_CODIGO  := COD_ERROR_EXCEPTION_INTERNO;
               K_MENSAJE := 'SQLCODE: ' || TO_CHAR(SQLCODE) || ' - SQLERRM: ' || SQLERRM;
               RAISE ERROR_EX;
         END;

         -- INSERTANDO COSTO PEXT PARA EF
         SGASI_INSERTAR_COSTEO_PEXT(K_SEF,
                                    K_SUC,
                                    C_EF,
                                    TO_NUMBER(V_ANCHOBANDA_T(J).NUMPTO),
                                    K_ESCENARIO,
                                    C_POLITICA,
                                    C_ID_RECOSTEO,
                                    K_CODIGO,
                                    K_MENSAJE);

         IF K_CODIGO <> COD_EXITO THEN
            RAISE ERROR_EX;
         END IF;

         -- ACTUALIZANDO TOTALES EN EF
         OPERACION.P_ACT_COSTO_EF(C_EF);

         K_PUNTO       := TO_NUMBER(V_ANCHOBANDA_T(J).NUMPTO);
         K_EQUIPO_PINT := C_EQUIPO_PINT;
         K_CODIGO      := COD_EXITO;
         K_MENSAJE     := 'SEF COSTEADA CORRECTAMENTE.';

         RETURN;
      END LOOP;

   EXCEPTION
      WHEN ERROR_EX THEN
         K_MENSAJE := 'SGASI_EF_COSTEO: ' || K_MENSAJE || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      WHEN OTHERS THEN
         K_CODIGO  := COD_ERROR_EXCEPTION_INTERNO;
         K_MENSAJE := 'SGASI_EF_COSTEO: ' || K_MENSAJE || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
   END;

  --------------------------------------------------------------
  PROCEDURE SGASU_ACT_EF(K_SEF              SALES.VTATABSLCFAC.NUMSLC%TYPE,
                         K_SUC              SALES.VTADETPTOENL.CODSUC%TYPE,
                         K_PUNTO            OPERACION.EFPTO.PUNTO%TYPE,
                         K_ESCENARIO        OPERACION.EFPTO.EFPTV_ESCENARIO%TYPE,
                         K_POP_GIS          METASOLV.UBIRED.UBIRV_CODUBIRED_GIS%TYPE,
                         K_DIST_POPCLIENTE  OPERACION.EFPTO.LONFIBRA%TYPE,
                         K_DIST_OBRACLIENTE OPERACION.EFPTO.EFPTN_LONFIBRA_PROY%TYPE,
                         K_RFS_GIS          OPERACION.EFPTO.EFPTV_RFS_GIS%TYPE,
                         K_POLITICA         OPERACION.EFPTO.EFPTV_POLITICA%TYPE,
                         K_EQUIPO_PINT      OPERACION.SGAT_EF_REGLACOSTEO_PINT.EFRCN_PINT%TYPE,
                         K_TIPOFIBRA        VARCHAR2,
                         K_CODIGO           OUT PLS_INTEGER,
                         K_MENSAJE          OUT VARCHAR2) IS

    C_EF         OPERACION.EF.CODEF%TYPE;
    C_POP        METASOLV.UBIRED.CODUBIRED%TYPE;
	 C_ESCENARIO  OPERACION.EFPTO.EFPTV_ESCENARIO%TYPE;
    V_DISTANCIA  OPERACION.EFPTO.LONFIBRA%TYPE;
    V_ACTUALIZAR BOOLEAN := FALSE;
    V_ID_FIBRA   PLS_INTEGER := 2; -- MO
	 
  BEGIN
    -- ENCONTRANDO CODIGO EF DE SEF
    C_EF := SGAFUN_GEF_EF(K_SEF, K_CODIGO, K_MENSAJE);

    IF K_TIPOFIBRA = 'MU' THEN
      V_ID_FIBRA := 11;
    END IF;

    C_ESCENARIO := K_ESCENARIO;
	 
    IF UPPER(K_ESCENARIO) = 'FM' OR UPPER(K_ESCENARIO) = 'DNG' THEN
      UPDATE OPERACION.EFPTO
         SET POP                 = NULL,
             LONFIBRA            = NULL,
             EFPTV_ESCENARIO     = K_ESCENARIO,
             EFPTV_TIPO_COSTEO   = 'A',
             EFPTN_LONFIBRA_PROY = NULL,
             EFPTV_POLITICA      = NULL,
             EFPTV_RFS_GIS       = NULL,
             EFPTN_EQUIPOPINT    = NULL
       WHERE CODEF = C_EF
         AND CODSUC = K_SUC;

      V_ACTUALIZAR := TRUE;
    END IF;

    V_DISTANCIA := NVL(K_DIST_POPCLIENTE, 0) + NVL(K_DIST_OBRACLIENTE, 0);

    IF UPPER(K_ESCENARIO) = 'SFO' THEN
      UPDATE OPERACION.EFPTO
         SET POP                 = NULL,
             LONFIBRA            = V_DISTANCIA,
             EFPTV_ESCENARIO     = K_ESCENARIO,
             EFPTV_TIPO_COSTEO   = 'A',
             EFPTN_LONFIBRA_PROY = K_DIST_OBRACLIENTE,
             EFPTV_POLITICA      = NULL,
             EFPTV_RFS_GIS       = NULL,
             EFPTN_EQUIPOPINT    = NULL
       WHERE CODEF = C_EF
         AND CODSUC = K_SUC;

      V_ACTUALIZAR := TRUE;
    END IF;

    IF UPPER(K_ESCENARIO) = 'SA' OR UPPER(K_ESCENARIO) = 'MMC' OR
       UPPER(K_ESCENARIO) = 'CDS' THEN
		 
      IF K_PUNTO IS NULL OR K_PUNTO < 1 THEN
			C_ESCENARIO := 'FM';
			
			UPDATE OPERACION.EFPTO
				SET POP                 = NULL,
					 LONFIBRA            = NULL,
					 EFPTV_ESCENARIO     = C_ESCENARIO,
					 EFPTV_TIPO_COSTEO   = 'A',
					 EFPTN_LONFIBRA_PROY = NULL,
					 EFPTV_POLITICA      = NULL,
					 EFPTV_RFS_GIS       = NULL,
					 EFPTN_EQUIPOPINT    = NULL
			 WHERE CODEF = C_EF
				AND CODSUC = K_SUC;
      ELSE
			IF K_POP_GIS IS NULL THEN
				K_CODIGO  := COD_ERROR_VALIDACION;
				K_MENSAJE := 'CODIGO DE POP NO PUEDE SER NULO';
				RETURN;
			END IF;

			SELECT CODUBIRED
			  INTO C_POP
			  FROM METASOLV.UBIRED
			 WHERE UBIRV_CODUBIRED_GIS = K_POP_GIS;

			UPDATE OPERACION.EFPTO
				SET POP                 = C_POP,
					 LONFIBRA            = V_DISTANCIA,
					 EFPTV_ESCENARIO     = K_ESCENARIO,
					 EFPTV_TIPO_COSTEO   = 'A',
					 EFPTN_LONFIBRA_PROY = K_DIST_OBRACLIENTE,
					 EFPTV_POLITICA      = K_POLITICA,
					 EFPTN_EQUIPOPINT    = K_EQUIPO_PINT,
					 MEDIOTX             = 3,
					 CODTIPFIBRA         = V_ID_FIBRA,
					 ACTCAD              = 1,
					 NUMDIAPLA          =
					 (SELECT SUM(NVL(NUMDIAPLA, 0))
						 FROM OPERACION.SOLEFXAREA
						WHERE CODEF = C_EF)
			 WHERE CODEF = C_EF
				AND PUNTO = K_PUNTO;

			UPDATE OPERACION.EFPTO
				SET EFPTV_RFS_GIS = K_RFS_GIS
			 WHERE CODEF = C_EF
				AND CODSUC = K_SUC;
      END IF;
      
		V_ACTUALIZAR := TRUE;
    END IF;

    IF NOT V_ACTUALIZAR THEN
      K_CODIGO  := -100;
      K_MENSAJE := 'NO SE ENCONTRO ESCENARIO PARA ACTUALIZAR.';

      RETURN;
    END IF;

    K_CODIGO  := COD_EXITO;
    K_MENSAJE := 'ACTUALIZACION CORRECTA. ' || C_ESCENARIO;

  EXCEPTION
    WHEN OTHERS THEN
      K_CODIGO  := COD_ERROR_EXCEPTION_INTERNO;
      K_MENSAJE := 'SGASU_ACT_EF.' || ' SQLCODE: ' || TO_CHAR(SQLCODE) || ' - SQLERRM: ' || SQLERRM;
  END;

  --------------------------------------------------------------
  PROCEDURE SGASI_GESTIONAR_EF_PARTIDA(K_RFS_GIS  IN OPERACION.EFPTO.EFPTV_RFS_GIS%TYPE,
                                       K_PARTIDAS IN CLOB,
                                       K_ESTADO   IN PLS_INTEGER,
                                       K_CODIGO   OUT PLS_INTEGER,
                                       K_MENSAJE  OUT VARCHAR2) IS

     C_PARTIDA      OPERACION.SGAT_EF_ETAPA_CNFG.EFECV_CODPAR%TYPE;
     C_CANTIDAD     OPERACION.SGAT_EF_ETAPA_CNFG.EFECN_CANTIDAD%TYPE;
     R_PARTIDA_CAB  OPERACION.SGAT_EF_PARTIDA_CAB%ROWTYPE;
     R_PARTIDA_DET  OPERACION.SGAT_EF_PARTIDA_DET%ROWTYPE;
     K_EFPCN_ID_OUT OPERACION.SGAT_EF_PARTIDA_CAB.EFPCN_ID%TYPE;
     ERROR_EX       EXCEPTION;
     LC_PARTIDAS    SYS_REFCURSOR;
     K_CODIGO_OUT   PLS_INTEGER;
     K_MENSAJE_OUT  VARCHAR2(2000);
  BEGIN
     /*INICIALIZAMOS VARIABLES*/
     K_CODIGO  := COD_EXITO;
     K_MENSAJE := 'OK';

     IF K_RFS_GIS IS NULL OR LENGTH(TRIM(K_RFS_GIS)) = 0 THEN
        K_CODIGO_OUT  := -1;
        K_MENSAJE_OUT := 'CODIGO RFS NO PUEDE SER NULO';
        RAISE ERROR_EX;
     END IF;

     /*INSERTAMOS EN CABECERA DE PARTIDA*/
     R_PARTIDA_CAB.EFPCV_RFS_GIS := K_RFS_GIS;
     R_PARTIDA_CAB.EFPCN_ESTADO  := K_ESTADO;

     SGASI_INSERTAR_EF_PARTIDA_CAB(R_PARTIDA_CAB,
                                   K_EFPCN_ID_OUT,
                                   K_CODIGO_OUT,
                                   K_MENSAJE_OUT);

     IF K_CODIGO_OUT <> COD_EXITO THEN
        RAISE ERROR_EX;
     END IF;

     OPEN LC_PARTIDAS FOR DBMS_LOB.SUBSTR(K_PARTIDAS, 32000, 1);
     LOOP
        FETCH LC_PARTIDAS
           INTO C_PARTIDA, C_CANTIDAD;
        EXIT WHEN LC_PARTIDAS%NOTFOUND;
        /*PROCESO DE DATOS*/
        R_PARTIDA_DET.EFPDN_ID       := K_EFPCN_ID_OUT;
        R_PARTIDA_DET.EFPDV_CODPAR   := C_PARTIDA;
        R_PARTIDA_DET.EFPDN_CANTIDAD := C_CANTIDAD;

        /*INSERTAMOS EN DETALLE DE PARTIDAS*/
        SGASI_INSERTAR_EF_PARTIDA_DET(R_PARTIDA_DET,
                                      K_CODIGO_OUT,
                                      K_MENSAJE_OUT);

        IF K_CODIGO_OUT <> COD_EXITO THEN
           RAISE ERROR_EX;
        END IF;
     END LOOP;
     CLOSE LC_PARTIDAS;

  EXCEPTION
     WHEN ERROR_EX THEN
        K_CODIGO  := -1;
        K_MENSAJE := ' CODIGO: ' || TO_CHAR(K_CODIGO_OUT) || ' ' ||
                     K_MENSAJE_OUT;
     WHEN OTHERS THEN
        K_CODIGO  := 99;
        K_MENSAJE := ' SQLCODE: ' || TO_CHAR(SQLCODE) || ' - SQLERRM: ' ||
                     SQLERRM;
  END;

  --------------------------------------------------------------
  PROCEDURE SGASI_INSERTAR_EF_PARTIDA_CAB(R_PARTIDA_CAB IN OPERACION.SGAT_EF_PARTIDA_CAB%ROWTYPE,
                                          K_EFPCN_ID    OUT OPERACION.SGAT_EF_PARTIDA_CAB.EFPCN_ID%TYPE,
                                          K_CODIGO      OUT PLS_INTEGER,
                                          K_MENSAJE     OUT VARCHAR2) IS
  BEGIN
    K_CODIGO  := COD_EXITO;
    K_MENSAJE := 'OK';

    INSERT INTO OPERACION.SGAT_EF_PARTIDA_CAB
      (EFPCV_RFS_GIS, EFPCN_ESTADO)
    VALUES
      (R_PARTIDA_CAB.EFPCV_RFS_GIS, R_PARTIDA_CAB.EFPCN_ESTADO)
    RETURNING EFPCN_ID INTO K_EFPCN_ID;

  EXCEPTION
    WHEN OTHERS THEN
      K_CODIGO  := 99;
      K_MENSAJE := 'SGASI_INSERTAR_EF_PARTIDA_CAB-SQLCODE: ' ||
                   TO_CHAR(SQLCODE) || ' - SQLERRM: ' || SQLERRM;
  END;

  --------------------------------------------------------------
  PROCEDURE SGASI_INSERTAR_EF_PARTIDA_DET(R_PARTIDA_DET IN OPERACION.SGAT_EF_PARTIDA_DET%ROWTYPE,
                                          K_CODIGO      OUT PLS_INTEGER,
                                          K_MENSAJE     OUT VARCHAR2) IS
  BEGIN
    K_CODIGO  := COD_EXITO;
    K_MENSAJE := 'OK';

    INSERT INTO OPERACION.SGAT_EF_PARTIDA_DET
      (EFPDN_ID, EFPDV_CODPAR, EFPDN_CANTIDAD)
    VALUES
      (R_PARTIDA_DET.EFPDN_ID,
       R_PARTIDA_DET.EFPDV_CODPAR,
       R_PARTIDA_DET.EFPDN_CANTIDAD);

  EXCEPTION
    WHEN OTHERS THEN
      K_CODIGO  := 99;
      K_MENSAJE := 'SGASI_INSERTAR_EF_PARTIDA_DET-SQLCODE: ' ||
                   TO_CHAR(SQLCODE) || ' - SQLERRM: ' || SQLERRM;
  END;

  --------------------------------------------------------------
  PROCEDURE SGASS_LISTADO_RECOSTEO(K_ID_RECOSTEO IN OPERACION.SGAT_EF_PARTIDA_CAB.EFPCN_ID%TYPE,
                                   K_CURSOR      OUT SYS_REFCURSOR,
                                   K_CODIGO      OUT PLS_INTEGER,
                                   K_MENSAJE     OUT VARCHAR2) IS

  PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    BEGIN
      UPDATE OPERACION.SGAT_EF_PARTIDA_CAB A
         SET A.EFPCN_ESTADO = 4
       WHERE A.EFPCN_ID < (SELECT MAX(B.EFPCN_ID)
                             FROM OPERACION.SGAT_EF_PARTIDA_CAB B
                            WHERE B.EFPCV_RFS_GIS = A.EFPCV_RFS_GIS)
         AND A.EFPCN_ESTADO = 0;

      COMMIT;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
       NULL;
    END;

    IF (K_ID_RECOSTEO IS NULL OR K_ID_RECOSTEO = 0) THEN
       OPEN K_CURSOR FOR
       SELECT A.EFPCN_ID
         FROM OPERACION.SGAT_EF_PARTIDA_CAB A
        WHERE A.EFPCN_ESTADO = 0 -- PENDIENTE A RECOSTEAR
          AND A.EFPCN_ID =
              (SELECT MAX(B.EFPCN_ID)
                 FROM OPERACION.SGAT_EF_PARTIDA_CAB B
                WHERE B.EFPCV_RFS_GIS = A.EFPCV_RFS_GIS)
        ORDER BY A.EFPCN_ID;
    ELSE
       OPEN K_CURSOR FOR
       SELECT A.EFPCN_ID
         FROM OPERACION.SGAT_EF_PARTIDA_CAB A
        WHERE A.EFPCN_ESTADO = 0 -- PENDIENTE A RECOSTEAR
          AND A.EFPCN_ID =
              (SELECT MAX(B.EFPCN_ID)
                 FROM OPERACION.SGAT_EF_PARTIDA_CAB B
                WHERE B.EFPCV_RFS_GIS = A.EFPCV_RFS_GIS)
          AND A.EFPCN_ID = K_ID_RECOSTEO
        ORDER BY A.EFPCN_ID;
    END IF;

    K_CODIGO  := COD_EXITO;
    K_MENSAJE := 'EJECUCION CORRECTA';

  EXCEPTION
       WHEN OTHERS THEN
         K_CODIGO  := COD_ERROR_EXCEPTION_INTERNO;
         K_MENSAJE := 'SGASS_LISTADO_RECOSTEO. SQLCODE: ' || TO_CHAR(SQLCODE) ||
                      ' - SQLERRM: ' || SQLERRM;
         ROLLBACK;

  END;

  --------------------------------------------------------------
  PROCEDURE SGASU_ACT_ESTADO_RECOSTEO( K_ID_RECOSTEO  IN  OPERACION.SGAT_EF_PARTIDA_CAB.EFPCN_ID%TYPE,
                                       K_RC_ESTADO    IN  OPERACION.SGAT_EF_PARTIDA_CAB.EFPCN_ESTADO%TYPE,
                                       K_CODIGO       OUT PLS_INTEGER,
                                       K_MENSAJE      OUT VARCHAR2) IS
  PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
     UPDATE OPERACION.SGAT_EF_PARTIDA_CAB
        SET EFPCN_ESTADO = K_RC_ESTADO
      WHERE EFPCN_ID = K_ID_RECOSTEO;
     COMMIT;

     K_CODIGO  := COD_EXITO;
     K_MENSAJE := 'EJECUCION CORRECTA';

  EXCEPTION
    WHEN OTHERS THEN
      K_CODIGO  := COD_ERROR_EXCEPTION_INTERNO;
      K_MENSAJE := 'SGASU_ACT_ESTADO_RECOSTEO. SQLCODE: ' ||TO_CHAR(SQLCODE) || ' - SQLERRM: ' || SQLERRM;
      ROLLBACK;
  END;

  --------------------------------------------------------------
  PROCEDURE SGASI_EF_RECOSTEO(K_ID_RECOSTEO    OPERACION.SGAT_EF_PARTIDA_CAB.EFPCN_ID%TYPE,
                              K_CODIGO         OUT PLS_INTEGER,
                              K_MENSAJE        OUT VARCHAR2) IS

     C_EF           OPERACION.EFPTO.CODEF%TYPE;
     C_PUNTO        OPERACION.EFPTO.PUNTO%TYPE;
     C_RFS_GIS      OPERACION.SGAT_EF_PARTIDA_CAB.EFPCV_RFS_GIS%TYPE;
     C_ESCENARIO    OPERACION.EFPTO.EFPTV_ESCENARIO%TYPE;
     C_POLITICA     OPERACION.EFPTO.EFPTV_POLITICA%TYPE;
     ERROR_EX       EXCEPTION;
     V_CODIGO       PLS_INTEGER;
     V_MENSAJE      VARCHAR2(1000);
  BEGIN
     K_CODIGO := COD_EXITO;

     -- CAMBIAR ESTADO A 3 (EN EJECUCION)
     SGASU_ACT_ESTADO_RECOSTEO(K_ID_RECOSTEO, 3, V_CODIGO, V_MENSAJE);

     -- OBTENIENDO VALORES NECESARIOS PARA RECOSTEAR
     BEGIN
        SELECT P.CODEF, P.PUNTO, P.EFPTV_RFS_GIS, P.EFPTV_ESCENARIO, P.EFPTV_POLITICA
          INTO C_EF, C_PUNTO, C_RFS_GIS, C_ESCENARIO, C_POLITICA
          FROM OPERACION.SGAT_EF_PARTIDA_CAB C
          INNER JOIN OPERACION.EFPTO P
          ON C.EFPCV_RFS_GIS = P.EFPTV_RFS_GIS
          WHERE C.EFPCN_ID = K_ID_RECOSTEO
             AND P.EFPTV_ESCENARIO IS NOT NULL
             AND P.EFPTV_POLITICA IS NOT NULL;

     EXCEPTION
          WHEN NO_DATA_FOUND THEN
             K_CODIGO  := COD_ERROR_VALIDACION;
             K_MENSAJE := 'NO EXISTE RFS_GIS ASOCIADA A UN ESTUDIO DE FACTIBILIDAD PARA EL ID: ' || K_ID_RECOSTEO;
             RAISE ERROR_EX;
          WHEN OTHERS THEN
             K_CODIGO  := COD_ERROR_EXCEPTION_INTERNO;
             K_MENSAJE := ' SQLCODE: ' ||TO_CHAR(SQLCODE) || ' - SQLERRM: ' || SQLERRM;
             RAISE ERROR_EX;
     END;

     -- BORRAR DATOS DE COSTEO ANTERIOR
     BEGIN
          DELETE FROM OPERACION.EFPTOETAACT C
          WHERE CODEF = C_EF
          AND PUNTO = C_PUNTO;
          DELETE FROM OPERACION.EFPTOETAMAT C
          WHERE CODEF = C_EF
          AND PUNTO = C_PUNTO;
          DELETE FROM OPERACION.EFPTOETA C
          WHERE CODEF = C_EF
          AND PUNTO = C_PUNTO;

          UPDATE OPERACION.EFPTO T
          SET COSMO              = 0.0,
             COSMAT              = 0.0,
             COSEQU              = 0.0,
             COSMOCLI            = 0.0,
             COSMATCLI           = 0.0,
             COSMO_S             = 0.0,
             COSMAT_S            = 0.0
          WHERE CODEF = C_EF
          AND PUNTO = C_PUNTO;

          UPDATE OPERACION.EF T
          SET COSMO     = 0.0,
             COSMAT    = 0.0,
             COSEQU    = 0.0,
             COSMOCLI  = 0.0,
             COSMATCLI = 0.0,
             COSMO_S   = 0.0,
             COSMAT_S  = 0.0
          WHERE CODEF = C_EF;

     EXCEPTION
       WHEN OTHERS THEN
          K_CODIGO  := COD_ERROR_EXCEPTION_INTERNO;
          K_MENSAJE := ' SQLCODE: ' ||TO_CHAR(SQLCODE) || ' - SQLERRM: ' || SQLERRM;
          RAISE ERROR_EX;
     END;

      -- INSERTANDO COSTO PEXT PARA EF
      SGASI_INSERTAR_COSTEO_PEXT('',
                                 '',
                                 C_EF,
                                 C_PUNTO,
                                 C_ESCENARIO,
                                 C_POLITICA,
                                 K_ID_RECOSTEO,
                                 K_CODIGO, K_MENSAJE);

      IF K_CODIGO <> COD_EXITO THEN
         RAISE ERROR_EX;
      END IF;

      -- ACTUALIZANDO TOTALES EN EF
      OPERACION.P_ACT_COSTO_EF(C_EF);

      K_CODIGO  := COD_EXITO;
      K_MENSAJE := 'PROYECTO RECOSTEADO CORRECTAMENTE';

      -- CAMBIAR ESTADO A 1 (PROCESADO)
      SGASU_ACT_ESTADO_RECOSTEO(K_ID_RECOSTEO, 1, V_CODIGO, V_MENSAJE);

  EXCEPTION
    WHEN ERROR_EX THEN
       K_MENSAJE := 'SGASI_EF_RECOSTEO:' || K_MENSAJE;
       -- CAMBIAR ESTADO A 2 (CON ERROR)
       SGASU_ACT_ESTADO_RECOSTEO(K_ID_RECOSTEO, 2, V_CODIGO, V_MENSAJE);

    WHEN OTHERS THEN
       K_CODIGO  := COD_ERROR_EXCEPTION_INTERNO;
       K_MENSAJE := 'SGASI_EF_RECOSTEO: SQLCODE: ' ||TO_CHAR(SQLCODE) || ' - SQLERRM: ' || SQLERRM;
       SGASU_ACT_ESTADO_RECOSTEO(K_ID_RECOSTEO, 2, V_CODIGO, V_MENSAJE);
  END;

  --------------------------------------------------------------
  FUNCTION SGAFUN_PERMISOMUNICIPAL(K_CODSUC    MARKETING.VTASUCCLI.CODSUC%TYPE,
                                   K_CODIGO    OUT PLS_INTEGER,
                                   K_MENSAJE   OUT VARCHAR2)
  RETURN PLS_INTEGER IS
  V_VALIDA  PLS_INTEGER := 0;
  BEGIN
    K_MENSAJE := 'SGAFUN_PERMISOMUNICIPAL. ';

    SELECT COUNT(1)
      INTO V_VALIDA
      FROM MARKETING.VTASUCCLI SUC,
           OPERACION.SGAT_EF_ETAPA_PRM CBP,
           OPERACION.SGAT_EF_ETAPA_PRM DTP
     WHERE CBP.EFEPV_DESCRIPCION = 'PERMISOS_MUNICIPALES'
       AND CBP.EFEPV_TRANSACCION = 'REGLAS_POLITICA'
       AND NVL(CBP.EFEPN_ID_PADRE, 0) = 0
       AND DTP.EFEPN_ID_PADRE = CBP.EFEPN_ID
       AND DTP.EFEPV_CODV = SUC.UBISUC
       AND SUC.CODSUC = K_CODSUC;

     IF V_VALIDA >= 1 THEN
        V_VALIDA := 1;
     END IF;
     K_CODIGO  := COD_EXITO;
     K_MENSAJE := MENSAJE_EXITO;

    RETURN V_VALIDA;

  EXCEPTION
    WHEN OTHERS THEN
      K_CODIGO  := COD_ERROR_EXCEPTION_INTERNO;
      K_MENSAJE := K_MENSAJE || 'SQLCODE: ' || TO_CHAR(SQLCODE) || ' - SQLERRM: ' || SQLERRM;
      RETURN NULL;
  END;

  --------------------------------------------------------------
 FUNCTION SGAFUN_AUTORIZA_MINCULTURA(K_CODSUC    MARKETING.VTASUCCLI.CODSUC%TYPE,
                                     K_CODIGO    OUT PLS_INTEGER,
                                     K_MENSAJE   OUT VARCHAR2)
  RETURN PLS_INTEGER IS
  V_VALIDA  PLS_INTEGER := 0;
  C_NUMVIA  MARKETING.VTASUCCLI.NUMVIA%TYPE;
  C_CODN    OPERACION.SGAT_EF_ETAPA_PRM.EFEPN_CODN%TYPE;
  C_CODN2   OPERACION.SGAT_EF_ETAPA_PRM.EFEPN_CODN2%TYPE;
  N_NUMVIA   OPERACION.SGAT_EF_ETAPA_PRM.EFEPN_CODN%TYPE;
  BEGIN
    K_MENSAJE := 'SGAFUN_AUTORIZA_MINCULTURA. ';

    BEGIN
     SELECT SUC.NUMVIA, DTP.EFEPN_CODN*100, (DTP.EFEPN_CODN2 + 1)*100
       INTO C_NUMVIA, C_CODN, C_CODN2
      FROM MARKETING.VTASUCCLI SUC,
           OPERACION.SGAT_EF_ETAPA_PRM CBP,
           OPERACION.SGAT_EF_ETAPA_PRM DTP
     WHERE CBP.EFEPV_DESCRIPCION = 'AUTORIZACION_MINISTERIO_CULTURA'
       AND CBP.EFEPV_TRANSACCION = 'REGLAS_POLITICA'
       AND NVL(CBP.EFEPN_ID_PADRE, 0) = 0
       AND DTP.EFEPN_ID_PADRE = CBP.EFEPN_ID
       AND DTP.EFEPV_CODV = SUC.UBISUC
       AND SUC.CODSUC = K_CODSUC;

       N_NUMVIA := TO_NUMBER(C_NUMVIA);
       IF N_NUMVIA>=C_CODN AND N_NUMVIA<C_CODN2 THEN
         V_VALIDA := 1;
       ELSE
         V_VALIDA := 0;
       END IF;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        V_VALIDA := 0;
      WHEN VALUE_ERROR THEN
        V_VALIDA := 0;
    END;

     K_CODIGO  := COD_EXITO;
     K_MENSAJE := MENSAJE_EXITO;

    RETURN V_VALIDA;

  EXCEPTION
    WHEN OTHERS THEN
      K_CODIGO  := COD_ERROR_EXCEPTION_INTERNO;
      K_MENSAJE := K_MENSAJE || 'SQLCODE: ' || TO_CHAR(SQLCODE) || ' - SQLERRM: ' || SQLERRM;
      RETURN 0;
  END;

  --------------------------------------------------------------
  FUNCTION SGAFUN_ZONALIMA(K_CODSUC    MARKETING.VTASUCCLI.CODSUC%TYPE,
                           K_CODIGO    OUT PLS_INTEGER,
                           K_MENSAJE   OUT VARCHAR2)
  RETURN PLS_INTEGER IS
  V_VALIDA  PLS_INTEGER := 0;
  BEGIN
    K_MENSAJE := 'SGAFUN_ZONALIMA. ';

    SELECT COUNT(1)
      INTO V_VALIDA
      FROM MARKETING.VTASUCCLI SUC,
           OPERACION.SGAT_EF_ETAPA_PRM CBP,
           OPERACION.SGAT_EF_ETAPA_PRM DTP
     WHERE CBP.EFEPV_DESCRIPCION = 'ZONA_LIMA'
       AND CBP.EFEPV_TRANSACCION = 'REGLAS_POLITICA'
       AND NVL(CBP.EFEPN_ID_PADRE, 0) = 0
       AND DTP.EFEPN_ID_PADRE = CBP.EFEPN_ID
       AND DTP.EFEPV_CODV = SUC.UBISUC
       AND SUC.CODSUC = K_CODSUC;

     IF V_VALIDA >= 1 THEN
        V_VALIDA := 1;
     END IF;
     K_CODIGO  := COD_EXITO;
     K_MENSAJE := MENSAJE_EXITO;

    RETURN V_VALIDA;

  EXCEPTION
    WHEN OTHERS THEN
      K_CODIGO  := COD_ERROR_EXCEPTION_INTERNO;
      K_MENSAJE := K_MENSAJE || 'SQLCODE: ' || TO_CHAR(SQLCODE) || ' - SQLERRM: ' || SQLERRM;
      RETURN NULL;
  END;

  --------------------------------------------------------------
  FUNCTION SGAFUN_CONTRATA_LOCALIA(K_CODSUC    MARKETING.VTASUCCLI.CODSUC%TYPE,
                                   K_CODIGO    OUT PLS_INTEGER,
                                   K_MENSAJE   OUT VARCHAR2)
  RETURN PLS_INTEGER IS
  V_VALIDA  PLS_INTEGER := 0;
  BEGIN
    K_MENSAJE := 'SGAFUN_CONTRATA_LOCALIA. ';

    SELECT COUNT(1)
      INTO V_VALIDA
      FROM MARKETING.VTASUCCLI SUC,
           OPERACION.SGAT_EF_ETAPA_PRM CBP,
           OPERACION.SGAT_EF_ETAPA_PRM DTP
     WHERE CBP.EFEPV_DESCRIPCION = 'CONTRATA_LOCALIA'
       AND CBP.EFEPV_TRANSACCION = 'REGLAS_POLITICA'
       AND NVL(CBP.EFEPN_ID_PADRE, 0) = 0
       AND DTP.EFEPN_ID_PADRE = CBP.EFEPN_ID
       AND DTP.EFEPV_CODV = SUC.UBISUC
       AND SUC.CODSUC = K_CODSUC;

     IF V_VALIDA >= 1 THEN
        V_VALIDA := 1;
     END IF;
     K_CODIGO  := COD_EXITO;
     K_MENSAJE := MENSAJE_EXITO;

    RETURN V_VALIDA;

  EXCEPTION
    WHEN OTHERS THEN
      K_CODIGO  := COD_ERROR_EXCEPTION_INTERNO;
      K_MENSAJE := K_MENSAJE || 'SQLCODE: ' || TO_CHAR(SQLCODE) || ' - SQLERRM: ' || SQLERRM;
      RETURN NULL;
  END;

  --------------------------------------------------------------
  FUNCTION SGAFUN_GET_PARAM_REGNEGO(K_REGLA      OPERACION.SGAT_EF_ETAPA_PRM.EFEPV_TRANSACCION%TYPE,
                                    K_VALOR      OPERACION.SGAT_EF_ETAPA_PRM.EFEPV_DESCRIPCION%TYPE,
                                    K_CODIGO     OUT PLS_INTEGER,
                                    K_MENSAJE    OUT VARCHAR2)
  RETURN OPERACION.SGAT_EF_ETAPA_PRM.EFEPN_CODN%TYPE IS
  V_VALIDA      OPERACION.SGAT_EF_ETAPA_PRM.EFEPN_CODN%TYPE := 0;
  C_EXCEPTION   EXCEPTION;
  BEGIN
    K_MENSAJE := 'SGAFUN_GET_PARAM_REGNEGO. ';

    IF K_REGLA IS NULL OR LENGTH(K_REGLA) = 0 THEN
       K_CODIGO  := COD_ERROR_VALIDACION;
       K_MENSAJE := 'INGRESE TIPO DE TRANSACCION';
       RAISE C_EXCEPTION;
    END IF;
    IF K_VALOR IS NULL OR LENGTH(K_VALOR) = 0 THEN
       K_CODIGO  := COD_ERROR_VALIDACION;
       K_MENSAJE := 'INGRESE VALOR PARA FILTRAR';
       RAISE C_EXCEPTION;
    END IF;

    SELECT NVL(DTP.EFEPN_CODN,0)
      INTO V_VALIDA
      FROM OPERACION.SGAT_EF_ETAPA_PRM CBP,
           OPERACION.SGAT_EF_ETAPA_PRM DTP
     WHERE CBP.EFEPV_DESCRIPCION = K_REGLA
       AND CBP.EFEPV_TRANSACCION = 'REGLAS_NEGOCIO'
       AND NVL(CBP.EFEPN_ID_PADRE, 0) = 0
       AND DTP.EFEPN_ID_PADRE = CBP.EFEPN_ID
       AND DTP.EFEPV_DESCRIPCION = K_VALOR;

     K_CODIGO  := COD_EXITO;
     K_MENSAJE := MENSAJE_EXITO;

    RETURN V_VALIDA;

  EXCEPTION
    WHEN C_EXCEPTION THEN
      RETURN 0;
    WHEN NO_DATA_FOUND THEN
      K_CODIGO  := COD_ERROR_EXCEPTION_INTERNO;
      K_MENSAJE := 'NO SE ENCUENTRA CONFIGURACION PARA LA TRANSACCION '|| K_REGLA||' Y ESCENARIO: '|| K_VALOR;
      RETURN 0;
    WHEN OTHERS THEN
      K_CODIGO  := COD_ERROR_EXCEPTION_INTERNO;
      K_MENSAJE := K_MENSAJE || 'SQLCODE: ' || TO_CHAR(SQLCODE) || ' - SQLERRM: ' || SQLERRM;
      RETURN 0;
  END;

  PROCEDURE SGASS_PARAM_RESUMEN_COSTEO(K_CODSUC          OPERACION.EFPTO.CODSUC%TYPE,
                                       K_ESCENARIO       OPERACION.EFPTO.EFPTV_ESCENARIO%TYPE,
                                       K_RFS             OPERACION.EFPTO.EFPTV_RFS_GIS%TYPE,
                                       K_CANALIZADO1     OUT OPERACION.SGAT_EF_ETAPA_PRM.EFEPN_CODN%TYPE,
                                       K_CANALIZADO2     OUT OPERACION.SGAT_EF_PARTIDA_DET.EFPDN_CANTIDAD%TYPE,
                                       K_CAMARA          OUT OPERACION.SGAT_EF_PARTIDA_DET.EFPDN_CANTIDAD%TYPE,
                                       K_TENDIDO_A       OUT OPERACION.SGAT_EF_PARTIDA_DET.EFPDN_CANTIDAD%TYPE,
                                       K_TENDIDO_C       OUT OPERACION.SGAT_EF_PARTIDA_DET.EFPDN_CANTIDAD%TYPE,
                                       K_POSTE_P         OUT OPERACION.SGAT_EF_PARTIDA_DET.EFPDN_CANTIDAD%TYPE,
                                       K_POSTE_T         OUT OPERACION.SGAT_EF_PARTIDA_DET.EFPDN_CANTIDAD%TYPE,
                                       K_PANDUIT         OUT OPERACION.SGAT_EF_ETAPA_PRM.EFEPN_CODN%TYPE,
                                       K_INPUT           OUT  OPERACION.SGAT_EF_ETAPA_PRM.EFEPN_CODN%TYPE,
                                       K_PERM_MUNIC      OUT NUMBER,
                                       K_AUT_MINCULT     OUT NUMBER,
                                       K_ZONA_LIMA       OUT NUMBER,
                                       K_CONTRATA_LOCAL  OUT NUMBER,
                                       K_FLETE           OUT NUMBER,
                                       K_CANT_PERSONAL   OUT NUMBER,
                                       K_COSTO_PASAJE    OUT NUMBER,
                                       K_DIA_PERMANE     OUT NUMBER,
                                       K_HOSPE_ALIME     OUT NUMBER,
                                       K_CODIGO          OUT NUMBER,
                                       K_MENSAJE         OUT VARCHAR2) IS

  V_IDRFS        NUMBER;

  BEGIN
    SELECT MAX(EFPCN_ID)
      INTO V_IDRFS
      FROM OPERACION.SGAT_EF_PARTIDA_CAB
     WHERE EFPCV_RFS_GIS = K_RFS;

    K_CANALIZADO1    := OPERACION.PKG_EF_COSTEO.SGAFUN_GET_PARAM_REGNEGO('CANALIZACION_PROYECTADA_VIA', K_ESCENARIO, K_CODIGO, K_MENSAJE);

    SELECT EFPDN_CANTIDAD
      INTO K_CANALIZADO2
      FROM OPERACION.SGAT_EF_PARTIDA_DET P
     WHERE EFPDN_ID = V_IDRFS
       AND EFPDV_CODPAR = 'RN0001';

    SELECT EFPDN_CANTIDAD
      INTO K_CAMARA
      FROM OPERACION.SGAT_EF_PARTIDA_DET P
     WHERE EFPDN_ID = V_IDRFS
       AND EFPDV_CODPAR = 'RN0004';

    SELECT EFPDN_CANTIDAD
      INTO K_TENDIDO_A
      FROM OPERACION.SGAT_EF_PARTIDA_DET P
     WHERE EFPDN_ID = V_IDRFS
       AND EFPDV_CODPAR = 'RN0003';

    SELECT EFPDN_CANTIDAD
      INTO K_TENDIDO_C
      FROM OPERACION.SGAT_EF_PARTIDA_DET P
     WHERE EFPDN_ID = V_IDRFS
       AND EFPDV_CODPAR = 'RN0002';

    SELECT EFPDN_CANTIDAD
      INTO K_POSTE_P
      FROM OPERACION.SGAT_EF_PARTIDA_DET P
     WHERE EFPDN_ID = V_IDRFS
       AND EFPDV_CODPAR = 'RN0008';

    SELECT EFPDN_CANTIDAD
      INTO K_POSTE_T
      FROM OPERACION.SGAT_EF_PARTIDA_DET P
     WHERE EFPDN_ID = V_IDRFS
       AND EFPDV_CODPAR = 'RN0006';

    K_PANDUIT        := OPERACION.PKG_EF_COSTEO.SGAFUN_GET_PARAM_REGNEGO('MATERIAL_PANDUIT_FUSION', K_ESCENARIO, K_CODIGO, K_MENSAJE);
    K_INPUT          := OPERACION.PKG_EF_COSTEO.SGAFUN_GET_PARAM_REGNEGO('MATERIAL_INPUT', K_ESCENARIO, K_CODIGO, K_MENSAJE);
    K_PERM_MUNIC     := OPERACION.PKG_EF_COSTEO.SGAFUN_PERMISOMUNICIPAL(K_CODSUC, K_CODIGO, K_MENSAJE);
    K_AUT_MINCULT    := OPERACION.PKG_EF_COSTEO.SGAFUN_AUTORIZA_MINCULTURA(K_CODSUC, K_CODIGO, K_MENSAJE);
    K_ZONA_LIMA      := OPERACION.PKG_EF_COSTEO.SGAFUN_ZONALIMA(K_CODSUC, K_CODIGO, K_MENSAJE);
    K_CONTRATA_LOCAL := OPERACION.PKG_EF_COSTEO.SGAFUN_CONTRATA_LOCALIA(K_CODSUC, K_CODIGO, K_MENSAJE);

    K_FLETE         := OPERACION.PKG_EF_COSTEO.SGAFUN_GET_PARAM_REGNEGO('ZONA_PROVINCIA', 'FLETE', K_CODIGO, K_MENSAJE);
    K_CANT_PERSONAL := OPERACION.PKG_EF_COSTEO.SGAFUN_GET_PARAM_REGNEGO('ZONA_PROVINCIA', 'CANTIDAD_PERSONAL', K_CODIGO, K_MENSAJE);
    K_COSTO_PASAJE  := OPERACION.PKG_EF_COSTEO.SGAFUN_GET_PARAM_REGNEGO('ZONA_PROVINCIA', 'COSTO_PASAJES',  K_CODIGO, K_MENSAJE);
    K_DIA_PERMANE   := OPERACION.PKG_EF_COSTEO.SGAFUN_GET_PARAM_REGNEGO('ZONA_PROVINCIA', 'DIAS_PERMANENCIA',  K_CODIGO, K_MENSAJE);
    K_HOSPE_ALIME   := OPERACION.PKG_EF_COSTEO.SGAFUN_GET_PARAM_REGNEGO('ZONA_PROVINCIA', 'HOSPEDA_ALIMENTA', K_CODIGO, K_MENSAJE);

    K_CODIGO  := COD_EXITO;
    K_MENSAJE := MENSAJE_EXITO;

  EXCEPTION
     WHEN OTHERS THEN
        K_CODIGO  := COD_ERROR_EXCEPTION_INTERNO;
        K_MENSAJE := 'SGASS_PARAM_RESUMEN_COSTEO. SQLCODE: ' || TO_CHAR(SQLCODE) || ' - SQLERRM: ' || SQLERRM;
  END;

END PKG_EF_COSTEO;
/