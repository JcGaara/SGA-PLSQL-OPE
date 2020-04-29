CREATE OR REPLACE PACKAGE OPERACION.PKG_EF_COSTEO IS

  /****************************************************************
  * NOMBRE PACKAGE : PKG_COSTEO_EF
  * PROPOSITO : CALCULAR EL COSTEO PEXT Y PINT DE UN EF
  * INPUT : <PARAMETRO> - DESCRIPCION DE LOS PARAMETROS
  * OUTPUT : <DESCRIPCION DE LA SALIDA>
  * CREADO POR : ANDRES ARIAS, FRANZ IPARRAGUIRRE
  * MODIFICADO POR: RAUL HUAMANI Y JORGE CAMACHO
  * FEC CREACION : 29/03/2019 14:36:14
  * FEC ACTUALIZACION : 02/09/2019 17:16
  ****************************************************************/

  /******************************************************************************************
    VERSION   FECHA       AUTOR             SOLICITADO POR  DESCRIPCION.
    --------  ----------  ---------------   --------------  ---------------------------------
      1.0     27/09/2019  ANDRES ARIAS      MARIO HIDALGO   Calcular costos PINT y PEXT de un EF 
      2.0     05/11/2019  ANDRES ARIAS      MARIO HIDALGO   Revisiones para escenario CDS
      3.0     14/11/2019  ANDRES ARIAS      MANUEL MENDOZA  REVISION EN SP: SGAFUN_GET_CANTIDAD 
		                                                      Y SGASI_INSERTAR_COSTEO_PEXT
  *******************************************************************************************/

  -- PUBLIC CONSTANT DECLARATIONS
    
  -- PUBLIC CURSOR DECLARATIONS
  CURSOR CUR_ANCHO_BANDA IS
    SELECT NUMPTO, CODSUC, BANWID, 1.00 AS BANWID_MB
      FROM SALES.VTADETPTOENL;

  -- PUBLIC TYPE DECLARATIONS
  TYPE T_EQUIPOCOMP_REC IS RECORD(
    PUNTO     SALES.VTADETPTOENL.NUMPTO_PRIN%TYPE,
    ORDEN     PLS_INTEGER,
    CODTIPEQU OPERACION.TIPEQU.CODTIPEQU%TYPE,
    TIPEQU    OPERACION.TIPEQU.TIPEQU%TYPE,
    COSTO     OPERACION.TIPEQU.COSTO%TYPE,
    CANTIDAD  OPERACION.EQUCOMXOPE.CANTIDAD%TYPE,
    TIPPRP    PLS_INTEGER,
    CODEQUCOM SALES.VTADETPTOENL.CODEQUCOM%TYPE);

  TYPE T_EQUIPO_REC IS RECORD(
    CODUBIRED    METASOLV.UBIRED.CODUBIRED%TYPE,
    CODUBI       METASOLV.UBIRED.CODUBI%TYPE,
    TGER_CODTIPO METASOLV.EQUIPORED.TGER_CODTIPO%TYPE,
    TGER_NOMTIPO METASOLV.SGAT_TIPAGR_EQUIPORED.TGER_NOMTIPO%TYPE);

  TYPE T_TARJETA_REC IS RECORD(
    TGER_CODTIPO METASOLV.EQUIPORED.TGER_CODTIPO%TYPE,
    TGER_NOMTIPO METASOLV.SGAT_TIPAGR_EQUIPORED.TGER_NOMTIPO%TYPE,
    TARJETA      PLS_INTEGER);

  TYPE T_PARTIDA_LS_REC IS RECORD(
    PARTIDA VARCHAR2(20),
    CANT    NUMBER);

  TYPE T_ANCHO_BANDA IS TABLE OF CUR_ANCHO_BANDA%ROWTYPE;

  TYPE T_EQUIPOCOMP IS TABLE OF T_EQUIPOCOMP_REC;
  TYPE T_EQUIPO     IS TABLE OF T_EQUIPO_REC;
  TYPE T_TARJETA    IS TABLE OF T_TARJETA_REC;
  TYPE T_PARTIDA_LS IS TABLE OF T_PARTIDA_LS_REC INDEX BY PLS_INTEGER;
 
  -- PUBLIC VARIABLE DECLARATIONS  

  -- PUBLIC FUNCTION AND PROCEDURE DECLARATIONS
  FUNCTION SGAFUN_GEF_EF(K_SEF       SALES.VTATABSLCFAC.NUMSLC%TYPE,
                         K_CODIGO    OUT PLS_INTEGER,
                         K_MENSAJE   OUT VARCHAR2)
    RETURN OPERACION.EF.CODEF%TYPE;
    
  FUNCTION SGAFUN_GET_ANCHOBANDA(K_SEF       SALES.VTATABSLCFAC.NUMSLC%TYPE,
                                 K_SUC       SALES.VTADETPTOENL.CODSUC%TYPE,
                                 K_CODIGO    OUT PLS_INTEGER,
                                 K_MENSAJE   OUT VARCHAR2)
    RETURN T_ANCHO_BANDA;

  FUNCTION SGAFUN_GET_ID_ANCHOBANDA(K_AB_MB     NUMBER,
                                    K_CODIGO    OUT PLS_INTEGER,
                                    K_MENSAJE   OUT VARCHAR2)
	 RETURN VARCHAR2;

  FUNCTION SGAFUN_GET_EQUIPOCOMP(K_SEF       SALES.VTATABSLCFAC.NUMSLC%TYPE,
                                 K_SUC       SALES.VTADETPTOENL.CODSUC%TYPE,
                                 K_CODIGO    OUT PLS_INTEGER,
                                 K_MENSAJE   OUT VARCHAR2)
    RETURN T_EQUIPOCOMP;

  FUNCTION SGAFUN_GET_EQUIPORED(K_POP_GIS    METASOLV.UBIRED.UBIRV_CODUBIRED_GIS%TYPE,
                                K_ANCHOBANDA VARCHAR2,
                                K_CODIGO     OUT PLS_INTEGER,
                                K_MENSAJE    OUT VARCHAR2)
    RETURN T_EQUIPO;

  FUNCTION SGAFUN_GET_TARJETA(K_POP_GIS    METASOLV.UBIRED.UBIRV_CODUBIRED_GIS%TYPE,
                              K_ANCHOBANDA VARCHAR2,
                              K_CODIGO     OUT PLS_INTEGER,
                              K_MENSAJE    OUT VARCHAR2)
    RETURN T_TARJETA;

  FUNCTION SGAFUN_VAL_ESCENARIO(K_ESCENARIO OPERACION.EFPTO.EFPTV_ESCENARIO%TYPE,
                                K_CODIGO    OUT PLS_INTEGER,
                                K_MENSAJE   OUT VARCHAR2)
    RETURN PLS_INTEGER;

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
                                  K_MENSAJE         OUT VARCHAR2);

  FUNCTION SGAFUN_GET_POLITICAS(K_SUC       SALES.VTADETPTOENL.CODSUC%TYPE,
                                K_ESCENARIO OPERACION.EFPTO.EFPTV_ESCENARIO%TYPE,
                                K_DISTANCIA OPERACION.EFPTO.EFPTN_LONFIBRA_PROY%TYPE,
                                K_CODIGO    OUT PLS_INTEGER,
                                K_MENSAJE   OUT VARCHAR2)
    RETURN VARCHAR2;
    
  PROCEDURE SGASS_GET_PARTIDAS(K_ID_RECOSTEO  OPERACION.SGAT_EF_PARTIDA_CAB.EFPCN_ID%TYPE,
										 K_PARTIDA_LS   OUT T_PARTIDA_LS,
                               K_CODIGO       OUT PLS_INTEGER,
                               K_MENSAJE      OUT VARCHAR2);

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
    RETURN NUMBER;

  PROCEDURE SGASI_INSERTAR_COSTEO_PINT(K_EF           OPERACION.EF.CODEF%TYPE,
                                       K_REGLA_PINT   OPERACION.SGAT_EF_REGLACOSTEO_PINT.EFRCN_PINT%TYPE,
                                       K_EQUIPOCOMP_T T_EQUIPOCOMP,
                                       K_PUNTO        OPERACION.EFPTOEQU.PUNTO%TYPE,
                                       K_CODIGO       OUT PLS_INTEGER,
                                       K_MENSAJE      OUT VARCHAR2);
                                       
  PROCEDURE SGASI_INSERTAR_COSTEO_PEXT(K_SEF           SALES.VTATABSLCFAC.NUMSLC%TYPE,
                                       K_SUC           SALES.VTADETPTOENL.CODSUC%TYPE,	  
	                                    K_EF            OPERACION.EF.CODEF%TYPE,
                                       K_PUNTO         NUMBER,
                                       K_ESCENARIO     OPERACION.EFPTO.EFPTV_ESCENARIO%TYPE,
                                       K_POLITICA      OPERACION.EFPTO.EFPTV_POLITICA%TYPE,
                                       K_ID_RECOSTEO   OPERACION.SGAT_EF_PARTIDA_CAB.EFPCN_ID%TYPE,
                                       K_CODIGO        OUT PLS_INTEGER,
                                       K_MENSAJE       OUT VARCHAR2);
  
  -----------------
  PROCEDURE SGASS_MUFA_REGLA_PINT(K_SEF             SALES.VTATABSLCFAC.NUMSLC%TYPE,
                                  K_SUC             SALES.VTADETPTOENL.CODSUC%TYPE,
                                  K_POP_GIS         METASOLV.UBIRED.UBIRV_CODUBIRED_GIS%TYPE,
                                  K_HILO            METASOLV.SGAT_PEX_FIBRA.FIBRN_CODFIBRA%TYPE,
                                  K_DIST_POPCLIENTE OPERACION.EFPTO.LONFIBRA%TYPE,
                                  K_ESCENARIO       OPERACION.EFPTO.EFPTV_ESCENARIO%TYPE,
                                  K_CODIGO          OUT PLS_INTEGER,
                                  K_MENSAJE         OUT VARCHAR2);
                                  
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
                            K_MENSAJE          OUT VARCHAR2);
                            
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
                         K_MENSAJE          OUT VARCHAR2);

  PROCEDURE SGASI_GESTIONAR_EF_PARTIDA(K_RFS_GIS  IN OPERACION.EFPTO.EFPTV_RFS_GIS%TYPE,
                                       K_PARTIDAS IN CLOB,
                                       K_ESTADO   IN PLS_INTEGER,
                                       K_CODIGO   OUT PLS_INTEGER,
                                       K_MENSAJE  OUT VARCHAR2);

  PROCEDURE SGASI_INSERTAR_EF_PARTIDA_CAB(R_PARTIDA_CAB IN OPERACION.SGAT_EF_PARTIDA_CAB%ROWTYPE,
                                          K_EFPCN_ID    OUT OPERACION.SGAT_EF_PARTIDA_CAB.EFPCN_ID%TYPE,
                                          K_CODIGO      OUT PLS_INTEGER,
                                          K_MENSAJE     OUT VARCHAR2);

  PROCEDURE SGASI_INSERTAR_EF_PARTIDA_DET(R_PARTIDA_DET IN OPERACION.SGAT_EF_PARTIDA_DET%ROWTYPE,
                                          K_CODIGO      OUT PLS_INTEGER,
                                          K_MENSAJE     OUT VARCHAR2);
                                          
  PROCEDURE SGASS_LISTADO_RECOSTEO( K_ID_RECOSTEO  IN  OPERACION.SGAT_EF_PARTIDA_CAB.EFPCN_ID%TYPE,
                                    K_CURSOR       OUT SYS_REFCURSOR,
                                    K_CODIGO       OUT PLS_INTEGER,
                                    K_MENSAJE      OUT VARCHAR2);

  PROCEDURE SGASU_ACT_ESTADO_RECOSTEO( K_ID_RECOSTEO  IN  OPERACION.SGAT_EF_PARTIDA_CAB.EFPCN_ID%TYPE,
                                       K_RC_ESTADO    IN  OPERACION.SGAT_EF_PARTIDA_CAB.EFPCN_ESTADO%TYPE,
                                       K_CODIGO       OUT PLS_INTEGER,
                                       K_MENSAJE      OUT VARCHAR2);

  PROCEDURE SGASI_EF_RECOSTEO(K_ID_RECOSTEO    OPERACION.SGAT_EF_PARTIDA_CAB.EFPCN_ID%TYPE,
                              K_CODIGO         OUT PLS_INTEGER,
                              K_MENSAJE        OUT VARCHAR2);

  FUNCTION SGAFUN_PERMISOMUNICIPAL(K_CODSUC    MARKETING.VTASUCCLI.CODSUC%TYPE,
                                   K_CODIGO    OUT PLS_INTEGER,
                                   K_MENSAJE   OUT VARCHAR2)
  RETURN PLS_INTEGER;
    
  FUNCTION SGAFUN_AUTORIZA_MINCULTURA(K_CODSUC    MARKETING.VTASUCCLI.CODSUC%TYPE,
                                      K_CODIGO    OUT PLS_INTEGER,
                                      K_MENSAJE   OUT VARCHAR2)
  RETURN PLS_INTEGER;  

  FUNCTION SGAFUN_ZONALIMA(K_CODSUC    MARKETING.VTASUCCLI.CODSUC%TYPE,
                           K_CODIGO    OUT PLS_INTEGER,
                           K_MENSAJE   OUT VARCHAR2)
  RETURN PLS_INTEGER;
    
  FUNCTION SGAFUN_CONTRATA_LOCALIA(K_CODSUC    MARKETING.VTASUCCLI.CODSUC%TYPE,
											             K_CODIGO    OUT PLS_INTEGER,
											             K_MENSAJE   OUT VARCHAR2)
  RETURN PLS_INTEGER;

  FUNCTION SGAFUN_GET_PARAM_REGNEGO(K_REGLA      OPERACION.SGAT_EF_ETAPA_PRM.EFEPV_TRANSACCION%TYPE,
                                    K_VALOR      OPERACION.SGAT_EF_ETAPA_PRM.EFEPV_DESCRIPCION%TYPE,
                                    K_CODIGO     OUT PLS_INTEGER,
                                    K_MENSAJE    OUT VARCHAR2)
  RETURN OPERACION.SGAT_EF_ETAPA_PRM.EFEPN_CODN%TYPE;

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
                                       K_MENSAJE         OUT VARCHAR2);
END PKG_EF_COSTEO;
/