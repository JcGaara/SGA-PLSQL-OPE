CREATE OR REPLACE PACKAGE OPERACION.PKG_SOT_UNIFICADA IS

  /************************************************************************************************
  NOMBRE:     OPERACION.PKG_SOT_UNIFICADA
  PROPOSITO:  Generación unificada de SOT
  
  REVISIONES:
   Version   Fecha          Autor            Solicitado por      Descripcion
   -------- ----------  ------------------   -----------------   ------------------------
   1.0      23/01/2020  Felipe Maguiña       Dante Sunohara      INICIATIVA-193 Reingeniería de Venta y PostVenta Fija   
  /************************************************************************************************/

  TYPE T_COND_TYPE IS RECORD(
    PRODUCTO VARCHAR2(20),
    TRANSAC  VARCHAR2(20));

  PROCEDURE SGASS_GENERA_SOT(P_IDPROCESS NUMBER,
                             P_ERROR     OUT NUMBER,
                             P_MENSAJE   OUT VARCHAR2);
  FUNCTION SGAFUN_VALIDA_CONDICION(P_IDCOND NUMBER, P_CONDIC T_COND_TYPE)
    RETURN BOOLEAN;
  FUNCTION SGAFUN_VALIDA_EXISTE(P_BUSCA VARCHAR2, P_TEXTO VARCHAR2)
    RETURN NUMBER;
  PROCEDURE SGASI_ACT_PARAMETRO(P_ABREV     VARCHAR2,
                                P_IDPROCESS NUMBER,
                                P_ATRIBUTO  VARCHAR2,
                                P_VALOR     VARCHAR2);
  PROCEDURE SGASS_OBTENER_DATO(P_ID        IN VARCHAR2,
                               P_CAMP      IN VARCHAR2,
                               P_ABREV     IN VARCHAR2,
                               P_RSULT     OUT VARCHAR2, --CLOB
                               P_COD_ERROR OUT NUMBER,
                               P_MEN_ERROR OUT VARCHAR2);
  PROCEDURE SGASS_OBTENER_VALOR(P_ID        IN VARCHAR2,
                                P_CAMP      IN VARCHAR2,
                                P_ABREV     IN VARCHAR2,
                                P_RSULT     OUT VARCHAR2, --CLOB
                                P_COD_ERROR OUT NUMBER,
                                P_MEN_ERROR OUT VARCHAR2);
  PROCEDURE SGASS_OBTENER_VALOR_EXT(P_ID        IN VARCHAR2,
                                    P_CAMP      IN VARCHAR2,
                                    P_ABREV     IN VARCHAR2,
                                    P_RSULT     OUT VARCHAR2, --CLOB
                                    P_COD_ERROR OUT NUMBER,
                                    P_MEN_ERROR OUT VARCHAR2);
  PROCEDURE SGASU_ACT_TRS_RESPUESTA(P_IDTRS     NUMBER,
                                    P_ORDEN     NUMBER,
                                    P_COD_ERROR NUMBER,
                                    P_MEN_ERROR VARCHAR2);
  PROCEDURE SGASU_ACT_TRS_CODSOLOT(P_IDTRS NUMBER, P_CODSOLOT NUMBER);

  PROCEDURE SGASS_GENERA_FLUJO(P_IDTRS     OUT NUMBER,
                               P_COD_ERROR OUT NUMBER,
                               P_MEN_ERROR OUT VARCHAR2);

  PROCEDURE SGASI_EXECUTE_MAIN(P_VENTA      CLOB,
                               P_SERVICIOS  CLOB,
                               P_ERROR_CODE OUT NUMBER,
                               P_ERROR_MSG  OUT VARCHAR2);

  PROCEDURE SGASS_SEPARA_TRAMA(P_TRAMA     IN CLOB,
                               P_ABREV     IN VARCHAR2,
                               P_CURS_TAB  OUT SYS_REFCURSOR,
                               P_CURS_EXT  OUT SYS_REFCURSOR,
                               P_COD_ERROR OUT NUMBER,
                               P_MEN_ERROR OUT VARCHAR2);

  FUNCTION SGAFUN_CURSOR_TABLE(P_XMLTYPE XMLTYPE, P_ABREV VARCHAR2)
    RETURN VARCHAR2;

  FUNCTION SGAFUN_CURSOR_EXTEND(P_XMLTYPE XMLTYPE, P_ABREV VARCHAR2)
    RETURN VARCHAR2;

  PROCEDURE SGASI_POSTVENTA(P_CURS_TABLE IN SYS_REFCURSOR,
                            P_CURS_EXTND IN SYS_REFCURSOR,
                            P_ID_PROCESS OUT NUMBER,
                            P_COD_ERROR  OUT NUMBER,
                            P_MEN_ERROR  OUT VARCHAR2);

  PROCEDURE SGASI_POSTVENTA_SERV(P_CURS_TABLE IN SYS_REFCURSOR,
                                 P_CURS_EXTND IN SYS_REFCURSOR,
                                 P_ID_PROCES  IN NUMBER,
                                 P_COD_ERROR  OUT NUMBER,
                                 P_MEN_ERROR  OUT VARCHAR2);

END PKG_SOT_UNIFICADA;
/