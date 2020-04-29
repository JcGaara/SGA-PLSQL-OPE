CREATE OR REPLACE PACKAGE OPERACION.PKG_TRANSACCIONES_SGA IS
  /************************************************************************************************
  NOMBRE:     OPERACION.PKG_TRANSACCIONES_FITEL
  PROPOSITO:  Procesos de servicios FITEL
  
  REVISIONES:
   Version   Fecha          Autor            Solicitado por      Descripcion
   -------- ----------  ------------------   -----------------   ------------------------
   1.0      26/08/2019  Juan Gonzales                            [IDEA-140458 - Fitel]
                        Katherine Garcia
  /***********************************************************************************************/

  VV_DESC_TRANS VARCHAR2(200);

  -- Tipos Estados Transacioness
  VC_SERV_PROV    CONSTANT VARCHAR2(20) := 'TRANS_SGA';
  VC_SERV_EST     CONSTANT VARCHAR2(20) := 'EST_SERV_SGA';
  FND_EST_SOT_EJE CONSTANT INTEGER := 17;
  FND_EST_SOT_ATE CONSTANT INTEGER := 29;

  VN_EJEC_02  CONSTANT NUMBER := 2; --Sp Ejecutado Correctamente, requiere Permiso para Ejecutar Actualizacion  
  VN_EJEC_01  CONSTANT NUMBER := 1; --Sp Ejecutado Correctamente, requiere Ingreso de Datos
  VN_EJEC_OK  CONSTANT NUMBER := 0; --Sp Ejecutado Correctamente
  VN_ERROR_E1 CONSTANT NUMBER := -1; --Error técnico en SP
  VN_ERROR_E2 CONSTANT NUMBER := -2; --Error no registra Datos   
  VN_ERROR_E3 CONSTANT NUMBER := -3; --Error por disponibilidad WS
  VN_ERROR_E4 CONSTANT NUMBER := -4; --Error por timeout WS 

  PROCEDURE SGASI_CARGA_EQUIPO(PI_IDTAREAWF IN NUMBER,
                               PI_IDWF      IN NUMBER,
                               PI_TAREA     IN NUMBER,
                               PI_TAREADEF  IN NUMBER);

  FUNCTION SGAS_FUN_VALIDA_TRANS(PI_CODSOLOT OPERACION.SOLOT.CODSOLOT%TYPE,
                                 PI_CID      OPERACION.INSSRV.CID%TYPE,
                                 PI_ABREV    VARCHAR2,
                                 PI_FLAG     NUMBER) RETURN NUMBER;

  FUNCTION SGAS_FUN_SERV_ADIC(PI_CID OPERACION.INSSRV.CID%TYPE) RETURN NUMBER;

  PROCEDURE SGASS_VALIDA_APROVISION(PI_IDTAREAWF IN NUMBER,
                                    PI_IDWF      IN NUMBER,
                                    PI_TAREA     IN NUMBER,
                                    PI_TAREADEF  IN NUMBER);

  PROCEDURE SGASI_TRAZABILIDAD_LOG(PI_CODSOLOT IN NUMBER,
                                   PI_TIPTRA   IN NUMBER,
                                   PI_ID_TAREA IN NUMBER,
                                   PI_CID      IN NUMBER,
                                   PI_MSG_ERR  IN OPERACION.SGAT_APROVISION_LOG.SGAV_MENSAJE%TYPE);

  PROCEDURE SGASS_OBTIENE_SOT(PI_IDWF     IN WF.IDWF%TYPE,
                              PI_CODSOLOT OUT NUMBER,
                              PI_TIPTRA   OUT NUMBER);

  PROCEDURE SGASS_CONSULTA_EQUIPO(PV_SERIE   IN OPERACION.SOLOTPTOEQU.NUMSERIE%TYPE,
                                  PN_SOLOT   IN OPERACION.SOLOT.CODSOLOT%TYPE,
                                  PN_CODIGO  OUT NUMBER,
                                  PV_MENSAJE OUT VARCHAR2);

  PROCEDURE SGASS_CERRAR_ACTIVACION(PI_IDTAREAWF IN NUMBER,
                                    PI_IDWF      IN NUMBER,
                                    PI_TAREA     IN NUMBER,
                                    PI_TAREADEF  IN NUMBER);

  PROCEDURE SGASS_LIBERAR_EQUIPO_SGA(AN_CODSOLOT     IN OPERACION.SOLOT.CODSOLOT%TYPE,
                                     AN_CODIGO_RESP  OUT NUMBER,
                                     AV_MENSAJE_RESP OUT VARCHAR2);

  PROCEDURE SGASS_LIBERAR_IP_SGA(AN_CODSOLOT     IN OPERACION.SOLOT.CODSOLOT%TYPE,
                                 AN_CODIGO_RESP  OUT NUMBER,
                                 AV_MENSAJE_RESP OUT VARCHAR2);

  FUNCTION SGAS_FUN_VALIDA_IP(PI_CID OPERACION.INSSRV.CID%TYPE)
    RETURN VARCHAR2;

  FUNCTION SGAS_FUN_VAL_INSTITUCION(PI_CID OPERACION.INSSRV.CID%TYPE)
    RETURN NUMBER;

  PROCEDURE SGASS_PRE_ACTIVACION(PI_IDTAREAWF IN NUMBER,
                                 PI_IDWF      IN NUMBER,
                                 PI_TAREA     IN NUMBER,
                                 PI_TAREADEF  IN NUMBER);

  PROCEDURE SGASS_PRE_PROVISION(PI_IDTAREAWF IN NUMBER,
                                PI_IDWF      IN NUMBER,
                                PI_TAREA     IN NUMBER,
                                PI_TAREADEF  IN NUMBER);

  PROCEDURE SGASS_POST_PROVISION(PI_IDTAREAWF IN NUMBER,
                                 PI_IDWF      IN NUMBER,
                                 PI_TAREA     IN NUMBER,
                                 PI_TAREADEF  IN NUMBER);

  PROCEDURE SGASS_REGISTRAR_SERVICIO(AN_CODSOLOT IN OPERACION.SOLOT.CODSOLOT%TYPE,
                                     AN_CODIGO   OUT NUMBER,
                                     AV_MENSAJE  OUT VARCHAR2);

  PROCEDURE SGASS_CONSULTAR_SERVICIO(AN_CODSOLOT IN OPERACION.SOLOT.CODSOLOT%TYPE,
                                     AN_ESTADO   OUT NUMBER,
                                     AN_CODIGO   OUT NUMBER,
                                     AV_MENSAJE  OUT VARCHAR2);

  PROCEDURE SGASS_PROVISION_INTERNET(AN_CODSOLOT     IN OPERACION.SOLOT.CODSOLOT%TYPE,
                                     AN_CODIGO_RESP  OUT NUMBER,
                                     AV_MENSAJE_RESP OUT VARCHAR2);

  PROCEDURE SGASS_DATOS_SOT(AN_CODSOLOT     IN OPERACION.SOLOT.CODSOLOT%TYPE,
                            AN_TIPTRA       OUT OPERACION.SOLOT.TIPTRA%TYPE,
                            AN_TIPSRV       OUT OPERACION.SOLOT.TIPSRV%TYPE,
                            AN_CODIGO_RESP  OUT NUMBER,
                            AV_MENSAJE_RESP OUT VARCHAR2);

  PROCEDURE SGASS_VALIDA_RED_CNOC(PI_CID         IN OPERACION.INSSRV.CID%TYPE,
                                  PO_CODIGO_RESP OUT NUMBER,
                                  PO_MENSAJE     OUT VARCHAR2);

  PROCEDURE SGASS_VALIDA_NUMERO_SANS(PI_NUMSERIE IN OPERACION.SOLOTPTOEQU.NUMSERIE%TYPE,
                                     PI_CODSOLOT IN OPERACION.SOLOT.CODSOLOT%TYPE,
                                     PO_NRO_TLF  OUT VARCHAR2,
                                     PO_ESTADO   OUT NUMBER,
                                     PO_MENSAJE  OUT VARCHAR2);

  PROCEDURE SGASS_VALIDA_FICHA(PI_CODSOLOT    IN NUMBER,
                               PO_IDFICHA     OUT NUMBER,
                               PO_CODINSSRV   OUT OPERACION.INSSRV.CODINSSRV%TYPE,
                               PO_PID         OUT OPERACION.INSPRD.PID%TYPE,
                               PO_CID         OUT OPERACION.INSSRV.CID%TYPE,
                               PO_CODIGO_RESP OUT NUMBER,
                               PO_MENSAJE     OUT VARCHAR2);

  PROCEDURE SGASS_CREAR_FT(AN_TABLA        IN VARCHAR2,
                           AN_CODINSSRV    IN OPERACION.INSPRD.CODINSSRV%TYPE,
                           AN_PID          IN OPERACION.INSPRD.PID%TYPE,
                           AN_CODSOLOT     IN OPERACION.SOLOT.CODSOLOT%TYPE,
                           AN_CODIGO_RESP  OUT NUMBER,
                           AV_MENSAJE_RESP OUT VARCHAR2);

  PROCEDURE SGASU_COMPARA_ACTUALIZA_FICHA(PI_IDFICHA     IN SGACRM.FT_INSTDOCUMENTO.IDFICHA%TYPE,
                                          PI_CODSOLOT    IN OPERACION.SOLOT.CODSOLOT%TYPE,
                                          PO_CODIGO_RESP OUT NUMBER,
                                          PO_MENSAJE     OUT VARCHAR2);
  PROCEDURE SGASS_VALIDA_EQUIPO_SIM(PI_CODSOLOT IN OPERACION.SOLOT.CODSOLOT%TYPE,
                                    PO_ESTADO   OUT NUMBER,
                                    PO_MENSAJE  OUT VARCHAR2);

  PROCEDURE SGASS_CONSULTA_TIMER(AN_TRANSAC      IN VARCHAR2,
                                 AN_SEGUNDOS     OUT NUMBER,
                                 AN_CODIGO_RESP  OUT NUMBER,
                                 AV_MENSAJE_RESP OUT VARCHAR2);

  PROCEDURE SGASS_BAJA(AN_CODIGO OUT NUMBER, AV_MENSAJE OUT VARCHAR2);

  PROCEDURE SGASS_SUSPENSION(AN_CODIGO OUT NUMBER, AV_MENSAJE OUT VARCHAR2);

  PROCEDURE SGASS_RECONEXION(AN_CODIGO OUT NUMBER, AV_MENSAJE OUT VARCHAR2);

  PROCEDURE SGASS_ACTUALIZAR_ACTION(AN_CODSOLOT IN OPERACION.SOLOT.CODSOLOT%TYPE,
                                    AN_TIPTRA   IN OPERACION.SOLOT.TIPTRA%TYPE,
                                    AN_FICHA    IN SGACRM.FT_INSTDOCUMENTO.IDFICHA%TYPE,
                                    AN_CODIGO   OUT NUMBER,
                                    AV_MENSAJE  OUT VARCHAR2);

  FUNCTION SGAS_FUN_NETWORK_SERVICE(PI_CODINSSRV OPERACION.INSSRV.CODINSSRV%TYPE,
                                    PI_ACTION    NUMBER) RETURN VARCHAR2;

  PROCEDURE SGASU_LIBERAR_MSISDN_SANS(AN_CODSOLOT     OPERACION.SOLOT.CODSOLOT%TYPE,
                                      AN_CODIGO_RESP  OUT NUMBER,
                                      AV_MENSAJE_RESP OUT VARCHAR2);
END PKG_TRANSACCIONES_SGA;
/