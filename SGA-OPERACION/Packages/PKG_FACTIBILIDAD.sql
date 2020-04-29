CREATE OR REPLACE PACKAGE OPERACION.PKG_FACTIBILIDAD IS

  /****************************************************************
  * NOMBRE PACKAGE : PKG_FACTIBILIDAD
  * PROPOSITO :
  * INPUT : <PARAMETRO> - DESCRIPCION DE LOS PARAMETROS
  * OUTPUT : <DESCRIPCION DE LA SALIDA>
  * CREADO POR : ANDRES ARIAS
  * FEC CREACION : 21/05/2019 11:43:30
  * FEC ACTUALIZACION : 10/09/2019 10:00:00
  ****************************************************************/

  V_PENDIENTE OPERACION.SGAT_TRAZA_DET_FACT.TDFAV_ESTADO%TYPE := 0;

  PROCEDURE SGASS_SM_GET_CID(K_CODDIRECCION    MARKETING.SGAT_DIRGEOREF_SW.DGRN_CODDIRECCION%TYPE,
                             K_CODSUBDIRECCION MARKETING.SGAT_DIRGEOREF_SW.DGRN_CODSUBDIRECCION%TYPE,
                             K_CID             OUT SYS_REFCURSOR,
                             K_CODIGO          OUT PLS_INTEGER,
                             K_MENSAJE         OUT VARCHAR2);

  PROCEDURE SGASS_TRAZA_FACT(PI_ESTADO   IN VARCHAR2,
                             PO_CURSOR   OUT SYS_REFCURSOR,
                             PO_CODERROR OUT NUMBER,
                             PO_MSGERR   OUT VARCHAR2);

  PROCEDURE SGASU_TRAZA_FACT(PI_IDTRAZA     IN NUMBER,
                             PI_CODPROYECTO IN VARCHAR2,
                             PI_CODSUCURSAL IN VARCHAR2,
                             PI_ESTADO      IN NUMBER,
                             PI_TRAMAINPUT  IN CLOB,
                             PI_TRAMAOUTPUT IN CLOB,
                             PI_ACTIVIDAD   IN VARCHAR2,
                             PI_DESCRIPCION IN VARCHAR2,
                             PI_USUARIO     IN VARCHAR,
                             PO_CODERROR    OUT NUMBER,
                             PO_MSGERR      OUT VARCHAR);

  PROCEDURE SGASI_TRAZA_FACT(PI_CODEF OPERACION.EF.CODEF%TYPE);

  FUNCTION SGAFUN_TIPO_PROY(PI_NUMSLC IN VARCHAR2) RETURN NUMBER;

  FUNCTION SGAFUN_OBTENER_UBIGEO(PV_CODUBI CHAR,PN_CODVAL NUMBER) RETURN CHAR;
									  
END PKG_FACTIBILIDAD;
/
