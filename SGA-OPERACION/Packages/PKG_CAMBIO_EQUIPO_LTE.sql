CREATE OR REPLACE PACKAGE OPERACION.PKG_CAMBIO_EQUIPO_LTE IS
  /************************************************************************************************
  NOMBRE:     OPERACION.PKG_CAMBIO_EQUIPO_LTE
  PROPOSITO:  Proceso de Cambio de Equipo y Reposicion de Equipos LTE

  REVISIONES: 0908
   Version   Fecha          Autor            Solicitado por      Descripcion
   -------- ----------  ------------------   -----------------   ------------------------
   1.0      22/06/2018   Justiniano Condori/ Justiniano Condori   [IDEA-40758/PROY-32581-Postventa LTE/HFC] - [Cambio de Equipo LTE]
                         Jose Arriola
   2.0      13/08/2018   Jose Arriola        Justiniano Condori   Complemento/Mejoras de la version 1.0
   3.0      20/11/2018   Luis Flores         Luis Flores          Mejoras de la version 1.0
   4.0      06/12/2018   Luis Flores         Luis Flores          Mejoras de la version 1.0
   5.0      22/01/2019   Luis Flores         Luis Flores          IDEA-40758/PROY-32581-Postventa LTE/HFC] - [Cambio de Equipo LTE]
  /************************************************************************************************/

  C_ALTA            CONSTANT VARCHAR2(1) := 'A';
  C_BAJA            CONSTANT VARCHAR2(1) := 'B';
  C_CA              CONSTANT VARCHAR2(2) := 'CA';
  C_TP_CONAX        CONSTANT VARCHAR2(2) := 'CX';
  C_TP_PASSW        CONSTANT VARCHAR2(3) := 'PWD';
  C_TP_CHIP         CONSTANT VARCHAR2(2) := 'SC';
  C_EST_CONTEGO_ERR CONSTANT CHAR(1) := '4';
  C_EST_CONTEGO_INI CONSTANT CHAR(1) := '1';
  C_PROV_CANCELADO  CONSTANT CHAR(1) := '6';
  C_MSG_CANCELADO   CONSTANT VARCHAR2(45) := 'REPROCESADO DESDE PROCESO CAMBIO DE EQUIPO';
  C_MSG_REPROC      CONSTANT VARCHAR2(50) := 'SE HIZO EL REENVIO PARA REPROCESAR';
  C_MSG_PROCESANDO  CONSTANT VARCHAR2(15) := 'PROCESANDO';--2.0

  PROCEDURE SGASI_SOLOTPTO(PI_CODSOLOT IN NUMBER,
                           PI_CO_ID    IN NUMBER,
                           PO_COD      OUT NUMBER,
                           PO_MSJ      OUT VARCHAR2);

  FUNCTION SGAFUN_REG_SOT(PI_IDPROCESS    IN NUMBER,
                          PI_COD_ID       IN NUMBER,
                          PI_CUSTOMER_ID  IN NUMBER,
                          PI_TIPTRA       IN NUMBER,
                          PI_TIPPOSTVENTA IN VARCHAR2) RETURN NUMBER;

  PROCEDURE SGAFUN_CAMB_EQU(PI_ID_PROCESS  IN NUMBER,
                            PI_TIPTRA      IN NUMBER,
                            PI_COD_ID      IN NUMBER,
                            PI_CUSTOMER_ID IN NUMBER,
                            PO_CODSOLOT    OUT NUMBER,
                            PO_COD         OUT NUMBER,
                            PO_MSJ         OUT VARCHAR2);

  PROCEDURE SGASI_REENVIO(PI_CODSOLOT IN OPERACION.SOLOT.CODSOLOT%TYPE,
                          PI_TIPO_OPE IN VARCHAR2,
                          PO_COD      OUT NUMBER,
                          PO_MSJ      OUT VARCHAR2);

  PROCEDURE SGASI_ESTADO_PROV(PI_CODSOLOT IN OPERACION.SOLOT.CODSOLOT%TYPE,
                              PI_TIPO_OPE IN VARCHAR2,
                              PO_COD      OUT NUMBER,
                              PO_MSJ      OUT VARCHAR2);

  PROCEDURE SGASI_ACTIVACION(PI_IDTAREAWF IN NUMBER,
                             PI_IDWF      IN NUMBER,
                             PI_TAREA     IN NUMBER,
                             PI_TAREADEF  IN NUMBER);

  PROCEDURE SGASS_VALIDACION(PI_IDTAREAWF IN NUMBER,
                             PI_IDWF      IN NUMBER,
                             PI_TAREA     IN NUMBER,
                             PI_TAREADEF  IN NUMBER);

  PROCEDURE SGASI_CAMBIO_PWD(PI_CO_ID         IN VARCHAR2,
                             PI_ICCID_OLD     IN VARCHAR2,
                             PI_ICCID_NEW     IN VARCHAR2,
                             PI_SOT           IN INTEGER,
                             PO_REQUEST       OUT INTEGER,
                             PO_REQUEST_PADRE IN OUT INTEGER,
                             PO_RESULTADO     OUT INTEGER,
                             PO_MSGERR        OUT VARCHAR2);

  FUNCTION SGAFUN_VALIDA_PROVLTE(PI_CODSOLOT OPERACION.SOLOT.CODSOLOT%TYPE,
                                 PI_ACTION   NUMBER) RETURN NUMBER;

  FUNCTION SGAFUN_VALPROV_CONTEGO(PI_CODSOLOT OPERACION.SGAT_TRXCONTEGO.TRXN_CODSOLOT%TYPE,
                                  PI_NUMSERIE OPERACION.SGAT_TRXCONTEGO.TRXV_SERIE_TARJETA%TYPE,
                                  PI_ACTION   NUMBER) RETURN NUMBER;

  PROCEDURE SGASU_EQUIPO_MAT(PI_ACTION   IN SALES.SISACT_POSTVENTA_DET_SERV_LTE.FLAG_ACCION%TYPE,
                             PI_NUMSERIE IN SALES.SISACT_POSTVENTA_DET_SERV_LTE.NUM_SERIE%TYPE,
                             PO_COD_RPTA OUT NUMBER,
                             PO_DES_RPTA OUT VARCHAR2);

  PROCEDURE SGASS_DATOSXSOLOT(K_CODSOLOT IN OPERACION.SOLOT.CODSOLOT%TYPE,
                              K_DATOS    OUT SYS_REFCURSOR);

  PROCEDURE SGASS_PROVLTE(K_CODSOLOT IN OPERACION.SOLOT.CODSOLOT%TYPE,
                          K_DATOS    OUT SYS_REFCURSOR);

  PROCEDURE SGASS_EQCABTLIN(K_CODSOLOT IN OPERACION.SOLOT.CODSOLOT%TYPE,
                            K_TIPO     IN NUMBER,
                            K_DATOS    OUT SYS_REFCURSOR);

  PROCEDURE sgasu_serv_x_cliente(p_codsolot       IN NUMBER,
                                 p_tipo_operacion IN VARCHAR2,
                                 p_mensaje        IN VARCHAR2,
                                 p_estado         IN VARCHAR2,
                                 p_codigo_resp    OUT NUMBER,
                                 p_mensaje_resp   OUT VARCHAR2);


  PROCEDURE SGASS_VALPROVXOPE(PI_CODSOLOT IN OPERACION.SOLOT.CODSOLOT%TYPE,
                              PI_TIPO_OPE IN VARCHAR2,
                              PO_COD      OUT NUMBER,
                              PO_MSJ      OUT VARCHAR2);

  PROCEDURE SGASU_AT_SERVICIO(PI_CODSOLOT IN OPERACION.SOLOT.CODSOLOT%TYPE,
                               PI_TIPO_OPE IN VARCHAR2,
                               PI_NUM_REENVIO IN NUMBER);
  --INI 2.0
  FUNCTION SGAFUN_CONTEGOERRO(K_CODSOLOT IN OPERACION.SGAT_TRXCONTEGO.TRXN_CODSOLOT%TYPE,
                              K_NUMSERIE IN OPERACION.SGAT_TRXCONTEGO.TRXV_SERIE_TARJETA%TYPE) RETURN NUMBER;

  PROCEDURE SGASS_DETALLEXEQUIPO(K_ABREV IN OPERACION.TIPOPEDD.ABREV%TYPE,
                                K_DATOS    OUT SYS_REFCURSOR);
  --FIN 2.0
  
  PROCEDURE SGASU_UPDATE_PREACTIVA(AN_COD_ID IN SOLOT.COD_ID%TYPE,
                                   AV_TIPO   IN VARCHAR2,
                                   AN_ERROR  OUT NUMBER,
                                   AV_ERROR  OUT VARCHAR2);
--INI 5.0
  PROCEDURE SGASS_SUBTIPORDEN_TP(PI_TIPTRA   OPERACION.TIPTRABAJO.TIPTRA%TYPE,
                               PO_DATO       out sys_refcursor);
--FIN 5.0
end;
/