CREATE OR REPLACE PACKAGE BODY OPERACION.PKG_SOT_UNIFICADA IS

  /************************************************************************************************
  NOMBRE:     OPERACION.PKG_SOT_UNIFICADA
  PROPOSITO:  Generación unificada de SOT
  
  REVISIONES:
   Version   Fecha          Autor            Solicitado por      Descripcion
   -------- ----------  ------------------   -----------------   ------------------------
   1.0      23/01/2020  Felipe Maguiña       Dante Sunohara      INICIATIVA-193 Reingeniería de Venta y PostVenta Fija   
  /************************************************************************************************/

  PROCEDURE SGASS_GENERA_SOT(P_IDPROCESS NUMBER,
                             P_ERROR     OUT NUMBER,
                             P_MENSAJE   OUT VARCHAR2) IS
    V_QUERY_STR   VARCHAR2(2500);
    V_CONDIC_TYPE T_COND_TYPE;
    V_PRODUCTO    VARCHAR2(20) := 'HFC';
    V_TRANSAC     VARCHAR2(20) := 'CP';
    N_IDTRS       NUMBER;
    V_ERROR       NUMBER;
    V_MSJERR      VARCHAR2(3000);
    V_VAL         BOOLEAN;
    V_CODSOLOT    VARCHAR2(20);
    L_EXCEPTION EXCEPTION;
    CURSOR C_FLUJO(P_IDTRS NUMBER) IS
      SELECT A.TRSCN_IDFLUJO,
             B.TRSDN_ORDEN,
             C.PROCV_ABREV,
             C.PROCV_RUTA,
             D.FLUDN_IDCONDICION,
             B.TRSDC_PARAMENVIO
        FROM OPERACION.SGAT_DF_TRANSACCION_CAB A
       INNER JOIN OPERACION.SGAT_DF_TRANSACCION_DET B
          ON A.TRSCN_IDTRS = B.TRSDN_IDTRS
       INNER JOIN OPERACION.SGAT_DF_PROCESO_CAB C
          ON B.TRSDN_IDPROCESO = C.PROCN_IDPROCESO
       INNER JOIN OPERACION.SGAT_DF_FLUJO_DET D
          ON A.TRSCN_IDFLUJO = D.FLUDN_IDFLUJO
         AND B.TRSDN_IDPROCESO = D.FLUDN_IDPROCESO
       WHERE A.TRSCN_IDTRS = P_IDTRS
       ORDER BY B.TRSDN_ORDEN;
  
  BEGIN
  
    V_VAL := TRUE;
  
    --Obtener Id del listado de SP
    SGASS_GENERA_FLUJO(N_IDTRS, V_ERROR, V_MSJERR);
    IF N_IDTRS IS NULL THEN
      RAISE L_EXCEPTION;
    END IF;
  
    FOR X IN C_FLUJO(N_IDTRS) LOOP
      --validar condicional
      SELECT V_PRODUCTO, V_TRANSAC INTO V_CONDIC_TYPE FROM DUAL;
      IF SGAFUN_VALIDA_CONDICION(X.FLUDN_IDCONDICION, V_CONDIC_TYPE) THEN
      
        --ejecutar SP
        IF X.PROCV_RUTA IS NOT NULL THEN
          V_QUERY_STR := 'begin ' || X.PROCV_RUTA ||
                         ' ( :1, :2, :3 ); End; ';
          EXECUTE IMMEDIATE V_QUERY_STR
            USING P_IDPROCESS, OUT V_ERROR, OUT V_MSJERR;
        
          SGASU_ACT_TRS_RESPUESTA(N_IDTRS,
                                  X.TRSDN_ORDEN,
                                  V_ERROR,
                                  V_MSJERR);
          IF V_ERROR <> 0 THEN
            V_VAL := FALSE;
          END IF;
        END IF;
      END IF;
    END LOOP;
    IF V_VAL THEN
      COMMIT;
      P_ERROR := 0;
      --Obtener el valor de la SOT generado
      SGASS_OBTENER_DATO(P_IDPROCESS,
                         'CODSOLOT',
                         'POSTV',
                         V_CODSOLOT,
                         V_ERROR,
                         V_MSJERR);
      --Actualizar Codsolot en TRS
      SGASU_ACT_TRS_CODSOLOT(N_IDTRS, TO_NUMBER(V_CODSOLOT));
      P_MENSAJE := V_CODSOLOT;
    ELSE
      V_ERROR  := -2;
      V_MSJERR := 'ERROR: No se ejecutó correctamente la generación de SOT';
      RAISE L_EXCEPTION;
    END IF;
  EXCEPTION
    WHEN L_EXCEPTION THEN
      ROLLBACK;
      P_ERROR   := V_ERROR;
      P_MENSAJE := 'ERROR: OPERACION.PKG_SOT_UNIFICADA.P_GENERA_SOT => ' ||
                   V_MSJERR;
    WHEN OTHERS THEN
      ROLLBACK;
      P_ERROR   := -1;
      P_MENSAJE := 'ERROR: OPERACION.PKG_SOT_UNIFICADA.P_GENERA_SOT => ' ||
                   TO_CHAR(SQLERRM);
  END;

  FUNCTION SGAFUN_VALIDA_CONDICION(P_IDCOND NUMBER, P_CONDIC T_COND_TYPE)
    RETURN BOOLEAN IS
    N_VALCOND NUMBER;
    B_VALIDA  BOOLEAN := TRUE;
  
    CURSOR C_CONDICION IS
      SELECT *
        FROM OPERACION.SGAT_DF_CONDICION_DET A
       WHERE A.CONDN_IDCONDICION = P_IDCOND;
  BEGIN
  
    FOR X IN C_CONDICION LOOP
      CASE
        WHEN X.CONDV_PARAMETRO = 'PRODUCTO' THEN
          N_VALCOND := SGAFUN_VALIDA_EXISTE(P_CONDIC.PRODUCTO,
                                            X.CONDV_VALOR);
        WHEN X.CONDV_PARAMETRO = 'TRANSACCION' THEN
          N_VALCOND := SGAFUN_VALIDA_EXISTE(P_CONDIC.TRANSAC, X.CONDV_VALOR);
        ELSE
          N_VALCOND := 1;
      END CASE;
    
      IF N_VALCOND = 0 THEN
        B_VALIDA := FALSE;
      END IF;
    END LOOP;
  
    RETURN B_VALIDA;
  
  END;

  FUNCTION SGAFUN_VALIDA_EXISTE(P_BUSCA VARCHAR2, P_TEXTO VARCHAR2)
    RETURN NUMBER IS
    N_VALIDA NUMBER;
    N_EXISTE NUMBER;
  BEGIN
    SELECT INSTR(P_TEXTO, P_BUSCA) INTO N_EXISTE FROM DUAL;
  
    IF N_EXISTE = 0 THEN
      N_VALIDA := 0;
    ELSE
      N_VALIDA := 1;
    END IF;
  
    RETURN N_VALIDA;
  END;

  PROCEDURE SGASI_ACT_PARAMETRO(P_ABREV     VARCHAR2,
                                P_IDPROCESS NUMBER,
                                P_ATRIBUTO  VARCHAR2,
                                P_VALOR     VARCHAR2) IS
    V_ORDEN    NUMBER;
    V_TABLA    NUMBER;
    V_IDTABLA  VARCHAR2(35);
    V_NOMTABLA VARCHAR2(35);
    N_EXISTE   NUMBER;
    V_SQL      VARCHAR2(200);
  BEGIN
    SELECT B.TPOSTD_ORDEN,
           B.TPOSTD_FLG_TABLE,
           A.TRPOSTV_TABLA_PINC,
           A.TRPOSTV_IDENTIFICADOR
      INTO V_ORDEN, V_TABLA, V_NOMTABLA, V_IDTABLA
      FROM OPERACION.SGAT_TRAMA_POSTV A
     INNER JOIN OPERACION.SGAT_TRAMA_POSTV_DET B
        ON A.TRPOSTV_TRAMAID = B.TPOSTD_TRAMAID
     WHERE A.TRPOSTV_ABREV = P_ABREV
       AND B.TPOSTD_COLUMN_NAME = P_ATRIBUTO;
  
    IF V_TABLA = 1 THEN
      V_SQL := 'UPDATE ' || V_NOMTABLA || ' SET ' || P_ATRIBUTO || ' = ''' ||
               P_VALOR || ''' WHERE ' || V_IDTABLA || ' = ' || P_IDPROCESS;
      EXECUTE IMMEDIATE V_SQL;
    ELSIF V_TABLA = 0 THEN
      SELECT COUNT(1)
        INTO N_EXISTE
        FROM OPERACION.SGAT_POSTV_EXT T
       WHERE T.IDPROCESS = P_IDPROCESS
         AND T.POSTN_ORDEN = V_ORDEN;
    
      IF N_EXISTE = 0 THEN
        INSERT INTO OPERACION.SGAT_POSTV_EXT
          (IDPROCESS, POSTN_ORDEN, POSTV_ATRIBUTO, POSTV_VALOR)
        VALUES
          (P_IDPROCESS, V_ORDEN, P_ATRIBUTO, P_VALOR);
      ELSE
        UPDATE OPERACION.SGAT_POSTV_EXT
           SET POSTV_VALOR = P_VALOR
         WHERE IDPROCESS = P_IDPROCESS
           AND POSTN_ORDEN = V_ORDEN;
      END IF;
    END IF;
  END;

  PROCEDURE SGASS_OBTENER_DATO(P_ID        IN VARCHAR2,
                               P_CAMP      IN VARCHAR2,
                               P_ABREV     IN VARCHAR2,
                               P_RSULT     OUT VARCHAR2, --CLOB
                               P_COD_ERROR OUT NUMBER,
                               P_MEN_ERROR OUT VARCHAR2) IS
  
    V_ERR_EXCEPTION EXCEPTION;
    V_SQL    VARCHAR2(32000); --CLOB
    V_ERROR  NUMBER;
    V_MSJERR VARCHAR2(3000);
  
  BEGIN
  
    SGASS_OBTENER_VALOR(P_ID, P_CAMP, P_ABREV, V_SQL, V_ERROR, V_MSJERR);
  
    IF V_ERROR = -1 THEN
      SGASS_OBTENER_VALOR_EXT(P_ID,
                              P_CAMP,
                              P_ABREV,
                              V_SQL,
                              V_ERROR,
                              V_MSJERR);
    
      IF V_ERROR = -1 THEN
        RAISE V_ERR_EXCEPTION;
      END IF;
    END IF;
    P_RSULT := V_SQL;
  EXCEPTION
    WHEN V_ERR_EXCEPTION THEN
      P_COD_ERROR := V_ERROR;
      P_MEN_ERROR := V_MSJERR;
  END;

  PROCEDURE SGASS_OBTENER_VALOR(P_ID        IN VARCHAR2,
                                P_CAMP      IN VARCHAR2,
                                P_ABREV     IN VARCHAR2,
                                P_RSULT     OUT VARCHAR2, --CLOB
                                P_COD_ERROR OUT NUMBER,
                                P_MEN_ERROR OUT VARCHAR2) IS
    V_VAL        NUMBER;
    V_ERROR      NUMBER;
    V_MSJERR     VARCHAR2(3000);
    V_TABLE_NAME VARCHAR2(100);
    V_SQL        VARCHAR2(32000); --CLOB
    V_ID_NAME    VARCHAR2(100);
    V_ERR_EXCEPTION EXCEPTION;
    V_CAB CONSTANT VARCHAR2(300) := 'OPERACION.PKG_SOT_UNIFICADA.OBTENER_DATO';
  BEGIN
    BEGIN
      SELECT T.TRPOSTV_TABLA_PINC, T.TRPOSTV_IDENTIFICADOR
        INTO V_TABLE_NAME, V_ID_NAME
        FROM OPERACION.SGAT_TRAMA_POSTV T
       WHERE T.TRPOSTV_ABREV = P_ABREV
         AND T.TRPOSTV_TABLA_PINC IS NOT NULL
         AND T.TRPOSTV_IDENTIFICADOR IS NOT NULL;
    EXCEPTION
      WHEN OTHERS THEN
        V_ERROR  := -1;
        V_MSJERR := V_CAB || ': No se encontro valor(P_ABREV)  Válido';
        RAISE V_ERR_EXCEPTION;
    END;
  
    SELECT COUNT(1)
      INTO V_VAL
      FROM OPERACION.SGAT_TRAMA_POSTV A
     INNER JOIN OPERACION.SGAT_TRAMA_POSTV_DET B
        ON A.TRPOSTV_TRAMAID = B.TPOSTD_TRAMAID
     WHERE B.TPOSTD_ESTADO = 1
       AND TRIM(A.TRPOSTV_ABREV) = P_ABREV
       AND TRIM(B.TPOSTD_COLUMN_NAME) = P_CAMP
       AND B.TPOSTD_FLG_TABLE = 1;
  
    IF V_VAL = 0 THEN
      V_ERROR  := -1;
      V_MSJERR := V_CAB || ': No Existe Configuración';
      RAISE V_ERR_EXCEPTION;
    END IF;
  
    V_SQL := 'SELECT COUNT(1) FROM ' || V_TABLE_NAME || ' WHERE ' ||
             V_ID_NAME || ' = ' || P_ID;
  
    EXECUTE IMMEDIATE V_SQL
      INTO V_VAL;
  
    IF V_VAL = 0 THEN
      V_ERROR  := -1;
      V_MSJERR := V_CAB || ': No Existe Registro';
      RAISE V_ERR_EXCEPTION;
    END IF;
  
    V_SQL := 'SELECT ' || P_CAMP || ' FROM ' || V_TABLE_NAME || ' WHERE ' ||
             V_ID_NAME || ' = ' || P_ID;
  
    EXECUTE IMMEDIATE V_SQL
      INTO P_RSULT;
  
  EXCEPTION
    WHEN V_ERR_EXCEPTION THEN
      P_COD_ERROR := V_ERROR;
      P_MEN_ERROR := V_MSJERR;
    WHEN OTHERS THEN
      P_COD_ERROR := V_ERROR;
      P_MEN_ERROR := V_CAB || ' ' || TO_CHAR(SQLERRM);
  END;

  PROCEDURE SGASS_OBTENER_VALOR_EXT(P_ID        IN VARCHAR2,
                                    P_CAMP      IN VARCHAR2,
                                    P_ABREV     IN VARCHAR2,
                                    P_RSULT     OUT VARCHAR2, --CLOB
                                    P_COD_ERROR OUT NUMBER,
                                    P_MEN_ERROR OUT VARCHAR2) IS
    V_VAL        NUMBER;
    V_ERROR      NUMBER;
    V_MSJERR     VARCHAR2(3000);
    V_TABLE_NAME VARCHAR2(100);
    V_SQL        VARCHAR2(32000); --CLOB
    V_ID_NAME    VARCHAR2(100);
    V_ERR_EXCEPTION EXCEPTION;
    V_CAB CONSTANT VARCHAR2(300) := 'OPERACION.PKG_SOT_UNIFICADA.OBTENER_DATO_EXT';
  BEGIN
    BEGIN
      SELECT T.TRPOSTV_TABLA_EXT, T.TRPOSTV_IDENTIFICADOR
        INTO V_TABLE_NAME, V_ID_NAME
        FROM OPERACION.SGAT_TRAMA_POSTV T
       WHERE T.TRPOSTV_ABREV = P_ABREV
         AND T.TRPOSTV_TABLA_PINC IS NOT NULL
         AND T.TRPOSTV_IDENTIFICADOR IS NOT NULL;
    EXCEPTION
      WHEN OTHERS THEN
        V_ERROR  := -1;
        V_MSJERR := V_CAB || ': No se encontro valor(P_ABREV)  Válido';
        RAISE V_ERR_EXCEPTION;
    END;
  
    SELECT COUNT(1)
      INTO V_VAL
      FROM OPERACION.SGAT_TRAMA_POSTV A
     INNER JOIN OPERACION.SGAT_TRAMA_POSTV_DET B
        ON A.TRPOSTV_TRAMAID = B.TPOSTD_TRAMAID
     WHERE B.TPOSTD_ESTADO = 1
       AND A.TRPOSTV_ABREV = P_ABREV
       AND TRIM(B.TPOSTD_COLUMN_NAME) = P_CAMP
       AND B.TPOSTD_FLG_TABLE = 0;
  
    IF V_VAL = 0 THEN
      V_ERROR  := -1;
      V_MSJERR := V_CAB || ': No Existe Configuración';
      RAISE V_ERR_EXCEPTION;
    END IF;
  
    V_SQL := 'SELECT COUNT(1) FROM ' || V_TABLE_NAME || ' WHERE ' ||
             V_ID_NAME || ' = ' || P_ID || ' AND POSTV_ATRIBUTO = ''' ||
             P_CAMP || '''';
  
    EXECUTE IMMEDIATE V_SQL
      INTO V_VAL;
  
    IF V_VAL = 0 THEN
      V_ERROR  := -1;
      V_MSJERR := V_CAB || ': No Existe Registro';
      RAISE V_ERR_EXCEPTION;
    END IF;
  
    V_SQL := 'SELECT POSTV_VALOR FROM ' || V_TABLE_NAME || ' WHERE ' ||
             V_ID_NAME || ' = ' || P_ID || ' AND POSTV_ATRIBUTO = ''' ||
             P_CAMP || '''';
  
    EXECUTE IMMEDIATE V_SQL
      INTO P_RSULT;
  EXCEPTION
    WHEN V_ERR_EXCEPTION THEN
      P_COD_ERROR := V_ERROR;
      P_MEN_ERROR := V_MSJERR;
    WHEN OTHERS THEN
      P_COD_ERROR := V_ERROR;
      P_MEN_ERROR := V_CAB || ' ' || TO_CHAR(SQLERRM);
  END;

  PROCEDURE SGASU_ACT_TRS_RESPUESTA(P_IDTRS     NUMBER,
                                    P_ORDEN     NUMBER,
                                    P_COD_ERROR NUMBER,
                                    P_MEN_ERROR VARCHAR2) IS
    PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    UPDATE OPERACION.SGAT_DF_TRANSACCION_DET T
       SET T.TRSDN_CODRPTA = P_COD_ERROR, T.TRSDV_MSJRPTA = P_MEN_ERROR
     WHERE T.TRSDN_IDTRS = P_IDTRS
       AND T.TRSDN_ORDEN = P_ORDEN;
  
    COMMIT;
  END;

  PROCEDURE SGASU_ACT_TRS_CODSOLOT(P_IDTRS NUMBER, P_CODSOLOT NUMBER) IS
    PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    UPDATE OPERACION.SGAT_DF_TRANSACCION_CAB T
       SET T.TRSCN_CODSOLOT = P_CODSOLOT
     WHERE T.TRSCN_IDTRS = P_IDTRS;
  
    COMMIT;
  END;

  PROCEDURE SGASS_GENERA_FLUJO(P_IDTRS     OUT NUMBER,
                               P_COD_ERROR OUT NUMBER,
                               P_MEN_ERROR OUT VARCHAR2) IS
    V_DESCRIPCION   VARCHAR2(100);
    N_IDTRS         NUMBER;
    C_DETFLUJO      SYS_REFCURSOR;
    C_DETCONDICION  SYS_REFCURSOR;
    N_CODRESP       NUMBER;
    V_MSJRES        VARCHAR2(500);
    V_IDTRANSVERSAL NUMBER;
    V_IDFLUJO       NUMBER;
  BEGIN
    SELECT B.CODIGON
      INTO V_IDTRANSVERSAL
      FROM OPERACION.TIPOPEDD A
     INNER JOIN OPERACION.OPEDD B
        ON A.TIPOPEDD = B.TIPOPEDD
     WHERE A.ABREV = 'GEN_UNIF_SOT'
       AND B.ABREVIACION = 'ID_TRANSV';
  
    SELECT B.CODIGON
      INTO V_IDFLUJO
      FROM OPERACION.TIPOPEDD A
     INNER JOIN OPERACION.OPEDD B
        ON A.TIPOPEDD = B.TIPOPEDD
     WHERE A.ABREV = 'GEN_UNIF_SOT'
       AND B.ABREVIACION = 'ID_GENSOT';
  
    OPERACION.PKG_FLUJO_AUTOMATICO.SGASS_DETALLE_FLUJO(NULL,
                                                       NULL,
                                                       V_IDTRANSVERSAL,
                                                       TO_CLOB('GENSOT'),
                                                       V_IDFLUJO,
                                                       V_DESCRIPCION,
                                                       N_IDTRS,
                                                       C_DETFLUJO,
                                                       C_DETCONDICION,
                                                       N_CODRESP,
                                                       V_MSJRES);
  
    P_COD_ERROR := N_CODRESP;
    P_MEN_ERROR := V_MSJRES;
    P_IDTRS     := N_IDTRS;
  END;

  PROCEDURE SGASI_EXECUTE_MAIN(P_VENTA      CLOB,
                               P_SERVICIOS  CLOB,
                               P_ERROR_CODE OUT NUMBER,
                               P_ERROR_MSG  OUT VARCHAR2) IS

  
    V_ERROR         NUMBER;
    V_MSJERR        VARCHAR2(3000);
    V_CURS_TAB      SYS_REFCURSOR;
    V_CURS_EXT      SYS_REFCURSOR;
    V_CURS_TAB_SERV SYS_REFCURSOR;
    V_CURS_EXT_SERV SYS_REFCURSOR;
    TYPE T_TABLETYPE IS TABLE OF OPERACION.SGAT_POSTV%ROWTYPE;
    V_OUTTABLE T_TABLETYPE;
    V_PROCESS  NUMBER;
    V_CAB      VARCHAR2(100) := '[OPERACION.PKG_SOT_UNIFICADA.EXECUTE_MAIN] ';
    --------------
    V_CLOB CLOB;
  
  BEGIN
    V_ERROR  := 0;
    V_MSJERR := V_CAB || 'ÉXITO EJECUCIÓN';
  
    OPERACION.PKG_SOT_UNIFICADA.SGASS_SEPARA_TRAMA(P_VENTA,
                                                   'POSTV',
                                                   V_CURS_TAB,
                                                   V_CURS_EXT,
                                                   V_ERROR,
                                                   V_MSJERR);
  
    OPERACION.PKG_SOT_UNIFICADA.SGASI_POSTVENTA(V_CURS_TAB,
                                                V_CURS_EXT,
                                                V_PROCESS,
                                                V_ERROR,
                                                V_MSJERR);
  
    OPERACION.PKG_SOT_UNIFICADA.SGASS_SEPARA_TRAMA(P_SERVICIOS,
                                                   'POSTV_SERV',
                                                   V_CURS_TAB_SERV,
                                                   V_CURS_EXT_SERV,
                                                   V_ERROR,
                                                   V_MSJERR);
  
    OPERACION.PKG_SOT_UNIFICADA.SGASI_POSTVENTA_SERV(V_CURS_TAB_SERV,
                                                     V_CURS_EXT_SERV,
                                                     V_PROCESS,
                                                     V_ERROR,
                                                     V_MSJERR);
  
  END;

  PROCEDURE SGASS_SEPARA_TRAMA(P_TRAMA     IN CLOB,
                               P_ABREV     IN VARCHAR2,
                               P_CURS_TAB  OUT SYS_REFCURSOR,
                               P_CURS_EXT  OUT SYS_REFCURSOR,
                               P_COD_ERROR OUT NUMBER,
                               P_MEN_ERROR OUT VARCHAR2) IS
  
    V_SQL     VARCHAR2(32000); --CLOB;
    T_XMLTYPE XMLTYPE;
    V_ERROR   NUMBER;
    V_MSJERR  VARCHAR2(3000);
    V_CAB     VARCHAR2(100) := '[OPERACION.PKG_SOT_UNIFICADA.SGASS_SEPARA_TRAMA] ';
  
  BEGIN
    V_ERROR  := 0;
    V_MSJERR := V_CAB || 'ÉXITO EJECUCIÓN';
  
    T_XMLTYPE := SYS.XMLTYPE.CREATEXML(P_TRAMA);
    V_SQL     := SGAFUN_CURSOR_TABLE(T_XMLTYPE, P_ABREV);
    IF V_SQL IS NOT NULL THEN
      OPEN P_CURS_TAB FOR V_SQL;
      V_SQL := SGAFUN_CURSOR_EXTEND(T_XMLTYPE, P_ABREV);
      IF V_SQL IS NOT NULL THEN
        OPEN P_CURS_EXT FOR V_SQL;
      END IF;
    END IF;
  
  END;

  FUNCTION SGAFUN_CURSOR_TABLE(P_XMLTYPE XMLTYPE, P_ABREV VARCHAR2)
    RETURN VARCHAR2 IS
  
    V_XML  CLOB;
    V_DDL  CLOB;
    V_ROW  NUMBER;
    V_VAL  NUMBER := 0;
    V_CLMN VARCHAR2(50);
  
    CURSOR C_TRAMA_TABLE IS
      SELECT B.*
        FROM OPERACION.SGAT_TRAMA_POSTV A
       INNER JOIN OPERACION.SGAT_TRAMA_POSTV_DET B
          ON A.TRPOSTV_TRAMAID = B.TPOSTD_TRAMAID
       WHERE A.TRPOSTV_ABREV = P_ABREV
         AND B.TPOSTD_FLG_TABLE = 1
       ORDER BY B.TPOSTD_ORDEN ASC;
  
  BEGIN
  
    SELECT P_XMLTYPE.GETCLOBVAL() INTO V_XML FROM DUAL;
  
    V_DDL := 'SELECT ';
  
    FOR X IN C_TRAMA_TABLE LOOP
      IF X.TPOSTD_ORDEN = 0 THEN
        V_VAL := 1;
      ELSIF X.TPOSTD_ESTADO = 1 THEN
        IF SUBSTR(X.TPOSTD_COLUMN_TYPE, 1, 5) = 'DATE(' THEN
          V_DDL := V_DDL || 'TO_' || SUBSTR(X.TPOSTD_COLUMN_TYPE, 1, 5) ||
                   X.TPOSTD_COLUMN_NAME ||
                   SUBSTR(X.TPOSTD_COLUMN_TYPE,
                          6,
                          LENGTH(X.TPOSTD_COLUMN_TYPE)) || ',';
        ELSIF X.TPOSTD_COLUMN_TYPE = 'DATE' OR
              X.TPOSTD_COLUMN_TYPE = 'SYSDATE' THEN
          V_DDL := V_DDL || 'SYSDATE' || ',';
        ELSE
          V_DDL := V_DDL || 'TR.' || X.TPOSTD_COLUMN_NAME || ',';
        END IF;
      ELSIF X.TPOSTD_ORDEN = 0 THEN
        V_DDL := V_DDL || 'NULL AS ' || X.TPOSTD_COLUMN_NAME || ',';
      END IF;
      V_ROW := C_TRAMA_TABLE%ROWCOUNT;
    END LOOP;
  
    IF V_ROW <= 1 OR V_VAL <> 1 THEN
      V_DDL := NULL;
    ELSE
      V_DDL := SUBSTR(V_DDL, 1, LENGTH(V_DDL) - 1);
      V_DDL := V_DDL || ' FROM (SELECT XMLTYPE(''' || V_XML ||
               ''') AS CONTENT FROM DUAL) T, ';
    
      FOR X IN C_TRAMA_TABLE LOOP
        IF X.TPOSTD_ORDEN = 0 THEN
          V_DDL := V_DDL || 'XMLTABLE(''' || X.TPOSTD_NIVEL ||
                   ''' PASSING T.CONTENT' || CHR(13) || 'COLUMNS ';
        ELSIF SUBSTR(X.TPOSTD_COLUMN_TYPE, 1, 4) = 'DATE' OR
              SUBSTR(X.TPOSTD_COLUMN_TYPE, 1, 7) = 'SYSDATE' THEN
          V_DDL := V_DDL || X.TPOSTD_COLUMN_NAME || ' ' || 'VARCHAR2(100)' ||
                   ' PATH ''' || X.TPOSTD_NIVEL || ''', ' || CHR(13);
        ELSE
          V_DDL := V_DDL || X.TPOSTD_COLUMN_NAME || ' ' ||
                   X.TPOSTD_COLUMN_TYPE || ' PATH ''' || X.TPOSTD_NIVEL ||
                   ''', ' || CHR(13);
        END IF;
      END LOOP;
    
      V_DDL := SUBSTR(V_DDL, 1, LENGTH(V_DDL) - 3) || ') TR';
    END IF;
  
    RETURN V_DDL;
  END;

  FUNCTION SGAFUN_CURSOR_EXTEND(P_XMLTYPE XMLTYPE, P_ABREV VARCHAR2)
    RETURN VARCHAR2 IS
  
    V_XML CLOB;
    V_DDL CLOB;
    V_AUX CLOB;
    V_ROW NUMBER;
    V_VAL NUMBER := 0;
  
    CURSOR C_TRAMA_ADIC IS
      SELECT TB.*
        FROM (SELECT B.*
                FROM OPERACION.SGAT_TRAMA_POSTV A
               INNER JOIN OPERACION.SGAT_TRAMA_POSTV_DET B
                  ON A.TRPOSTV_TRAMAID = B.TPOSTD_TRAMAID
               WHERE B.TPOSTD_ESTADO = 1
                 AND A.TRPOSTV_ABREV = P_ABREV
                 AND B.TPOSTD_ORDEN = 0
              UNION
              SELECT B.*
                FROM OPERACION.SGAT_TRAMA_POSTV A
               INNER JOIN OPERACION.SGAT_TRAMA_POSTV_DET B
                  ON A.TRPOSTV_TRAMAID = B.TPOSTD_TRAMAID
               WHERE B.TPOSTD_ESTADO = 1
                 AND A.TRPOSTV_ABREV = P_ABREV
                 AND B.TPOSTD_FLG_TABLE = 0) TB
       ORDER BY TB.TPOSTD_ORDEN ASC;
  
  BEGIN
  
    SELECT P_XMLTYPE.GETCLOBVAL() INTO V_XML FROM DUAL;
  
    V_DDL := 'WITH TB AS (SELECT XMLTYPE(''' || V_XML ||
             ''') AS CONTENT FROM DUAL)' || CHR(13);
  
    FOR X IN C_TRAMA_ADIC LOOP
      IF X.TPOSTD_ORDEN = 0 THEN
        V_AUX := ' FROM TB T, XMLTABLE(''' || X.TPOSTD_NIVEL ||
                 ''' PASSING T.CONTENT' || CHR(13) || 'COLUMNS ';
        V_VAL := 1;
      ELSIF X.TPOSTD_ESTADO = 1 AND V_VAL = 1 THEN
        V_DDL := V_DDL || ' SELECT 0 AS IDPROCESS, ''' ||
                 X.TPOSTD_COLUMN_NAME || ''' AS ATRIBUTO,' || 'TO_CHAR(TR.' ||
                 X.TPOSTD_COLUMN_NAME || ') AS VALOR, ' || X.TPOSTD_ORDEN ||
                 ' AS ORDEN, SYSDATE AS FECUSU, USER AS CODUSU ' || V_AUX ||
                 X.TPOSTD_COLUMN_NAME || ' ' || X.TPOSTD_COLUMN_TYPE ||
                 ' PATH ''' || X.TPOSTD_NIVEL || ''') TR ' || CHR(13) ||
                 'UNION' || CHR(13);
      ELSIF X.TPOSTD_ESTADO = 0 AND V_VAL = 1 THEN
        V_DDL := V_DDL || ' SELECT 0 AS IDPROCESS, ''' ||
                 X.TPOSTD_COLUMN_NAME || ''' AS ATRIBUTO,' ||
                 'TO_CHAR('') AS VALOR, ' || X.TPOSTD_ORDEN ||
                 ' AS ORDEN, SYSDATE AS FECUSU, USER AS CODUSU ' || V_AUX ||
                 X.TPOSTD_COLUMN_NAME || ' ' || X.TPOSTD_COLUMN_TYPE ||
                 ' PATH ''' || X.TPOSTD_NIVEL || ''') TR ' || CHR(13) ||
                 'UNION' || CHR(13);
      END IF;
      V_ROW := C_TRAMA_ADIC%ROWCOUNT;
    END LOOP;
  
    IF V_ROW <= 1 OR V_VAL <> 1 THEN
      V_DDL := NULL;
    ELSE
      V_DDL := SUBSTR(V_DDL, 1, LENGTH(V_DDL) - 6);
    END IF;
  
    RETURN V_DDL;
  END;

  PROCEDURE SGASI_POSTVENTA(P_CURS_TABLE IN SYS_REFCURSOR,
                            P_CURS_EXTND IN SYS_REFCURSOR,
                            P_ID_PROCESS OUT NUMBER,
                            P_COD_ERROR  OUT NUMBER,
                            P_MEN_ERROR  OUT VARCHAR2) IS
  
    TYPE T_TABLETYPE IS TABLE OF OPERACION.SGAT_POSTV%ROWTYPE;
    TYPE T_EXTNDTYPE IS TABLE OF OPERACION.SGAT_POSTV_EXT%ROWTYPE;
    V_OUTTABLE  T_TABLETYPE;
    V_OUTEXTND  T_EXTNDTYPE;
    V_PROCESO   OPERACION.SGAT_POSTV%ROWTYPE;
    V_IDPROCESS OPERACION.SGAT_POSTV.IDPROCESS%TYPE;
    V_ERROR     NUMBER;
    V_MSJERR    VARCHAR2(3000);
    V_CAB       VARCHAR2(100) := '[OPERACION.PKG_SOT_UNIFICADA.SGASI_POSTVENTA] ';
  
  BEGIN
    V_ERROR  := 0;
    V_MSJERR := V_CAB || 'ÉXITO EJECUCIÓN';
  
    IF P_CURS_TABLE IS NOT NULL THEN
      FETCH P_CURS_TABLE BULK COLLECT
        INTO V_OUTTABLE;
      FOR I IN V_OUTTABLE.FIRST .. V_OUTTABLE.LAST LOOP
        SELECT OPERACION.SGASEQ_POSTV.NEXTVAL INTO V_IDPROCESS FROM DUAL;
        V_OUTTABLE(I).IDPROCESS := V_IDPROCESS;
        V_OUTTABLE(I).ID_SIAC_POSTVENTA_LTE := V_IDPROCESS;
        INSERT INTO OPERACION.SGAT_POSTV VALUES V_OUTTABLE (I);
        COMMIT;
        P_ID_PROCESS := V_IDPROCESS;
      END LOOP;
      CLOSE P_CURS_TABLE;
    END IF;
  
    IF P_CURS_EXTND IS NOT NULL THEN
      FETCH P_CURS_EXTND BULK COLLECT
        INTO V_OUTEXTND;
      FOR I IN V_OUTEXTND.FIRST .. V_OUTEXTND.LAST LOOP
        V_OUTEXTND(I).IDPROCESS := V_IDPROCESS;
        INSERT INTO OPERACION.SGAT_POSTV_EXT VALUES V_OUTEXTND (I);
        COMMIT;
      END LOOP;
      CLOSE P_CURS_EXTND;
    END IF;
  
  END;

  PROCEDURE SGASI_POSTVENTA_SERV(P_CURS_TABLE IN SYS_REFCURSOR,
                                 P_CURS_EXTND IN SYS_REFCURSOR,
                                 P_ID_PROCES  IN NUMBER,
                                 P_COD_ERROR  OUT NUMBER,
                                 P_MEN_ERROR  OUT VARCHAR2) IS
  
    TYPE T_TABLETYPE IS TABLE OF OPERACION.SGAT_POSTV_SERV%ROWTYPE;
    TYPE T_EXTNDTYPE IS TABLE OF OPERACION.SGAT_POSTV_SERV_EXT%ROWTYPE;
    V_OUTTABLE  T_TABLETYPE;
    V_OUTEXTND  T_EXTNDTYPE;
    V_PROCESO   OPERACION.SGAT_POSTV_SERV%ROWTYPE;
    V_IDPROCESS OPERACION.SGAT_POSTV_SERV.IDINTERACCION%TYPE;
    V_ID        OPERACION.SGAT_POSTV_SERV.ID_POSTV_SERV%TYPE;
    V_COUNT     NUMBER := 0;
    V_ERROR     NUMBER;
    V_MSJERR    VARCHAR2(3000);
    V_CAB       VARCHAR2(100) := '[OPERACION.PKG_SOT_UNIFICADA.SGASI_POSTVENTA_SERV] ';
  
  BEGIN
    V_ERROR  := 0;
    V_MSJERR := V_CAB || 'ÉXITO EJECUCIÓN';
  
    IF P_CURS_TABLE IS NOT NULL THEN
      FETCH P_CURS_TABLE BULK COLLECT
        INTO V_OUTTABLE;
      SELECT OPERACION.SGASEQ_POSTV_SERV.NEXTVAL
        INTO V_IDPROCESS
        FROM DUAL;
      FOR I IN V_OUTTABLE.FIRST .. V_OUTTABLE.LAST LOOP
        SELECT OPERACION.SGASEQ_POSTV_SERV_ID.NEXTVAL INTO V_ID FROM DUAL;
        V_OUTTABLE(I).IDINTERACCION := V_IDPROCESS;
        V_OUTTABLE(I).ID_POSTV_SERV := V_ID;
        INSERT INTO OPERACION.SGAT_POSTV_SERV VALUES V_OUTTABLE (I);
        UPDATE OPERACION.SGAT_POSTV T
           SET T.IDINTERACCION = V_IDPROCESS
         WHERE IDPROCESS = P_ID_PROCES;
        COMMIT;
        V_COUNT := P_CURS_TABLE%ROWCOUNT - 1;
      END LOOP;
      CLOSE P_CURS_TABLE;
    END IF;
  
    IF P_CURS_EXTND IS NOT NULL THEN
      V_ID := V_ID - V_COUNT;
      FETCH P_CURS_EXTND BULK COLLECT
        INTO V_OUTEXTND;
      FOR I IN V_OUTEXTND.FIRST .. V_OUTEXTND.LAST LOOP
        V_OUTEXTND(I).ID_POSTV_SERV := V_ID;
        INSERT INTO OPERACION.SGAT_POSTV_SERV_EXT VALUES V_OUTEXTND (I);
        COMMIT;
        V_ID := V_ID + 1;
      END LOOP;
      CLOSE P_CURS_EXTND;
    END IF;
  
  END;

END PKG_SOT_UNIFICADA;
/