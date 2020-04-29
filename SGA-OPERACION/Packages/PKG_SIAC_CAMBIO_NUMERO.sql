CREATE OR REPLACE PACKAGE OPERACION.PKG_SIAC_CAMBIO_NUMERO IS
  /*******************************************************************************
  PROPOSITO: Realiza la creacion de SOT por el BIPEL y Las tareas automaticas son generadas 
             por la Shell WF_CAMBIO_NUMERO

  Version  Fecha       Autor             Solicitado por     Descripcion
  -------  ----------  ----------------  ----------------   -----------
    1.0    16/05/2017  Juan Gonzales      Alfredo YI       Cambio de numero SIAC UNICO
                       Lidia Quispe
  *******************************************************************************/
  G_TELEFONIA         CONSTANT TYSTABSRV.TIPSRV%TYPE := '0004';
  G_IDTRANSACCION     sales.siact_util_trama.tramn_idtransaccion%TYPE;
  G_TIPOTRANSACCION   VARCHAR2(50);
  G_idinteraccion     sales.siact_util_trama.tramn_idinteraccion%TYPE;

  PROCEDURE SIACSI_CAMBIO_NUMERO(K_ID_TRANSACCION     SALES.SIACT_UTIL_TRAMA.TRAMN_IDINTERACCION%TYPE,
                                 K_CO_ID              SOLOT.COD_ID%TYPE,
                                 K_CUSTOMER_ID        SALES.CLIENTE_SISACT.CUSTOMER_ID%TYPE,
                                 K_TIPO               VARCHAR2,
                                 K_CODSOLOT           OUT SOLOT.CODSOLOT%TYPE,
                                 K_ERROR_CODE         OUT NUMBER,
                                 K_ERROR_MSG          OUT VARCHAR2);

  PROCEDURE SIACSI_GENERA_SOLOT(K_CODCLI       IN VTATABCLI.CODCLI%TYPE,
                                K_TIPTRA       IN TIPTRABAJO.TIPTRA%TYPE,
                                K_NUMSLC_OLD   IN SOLOT.NUMSLC%TYPE,
                                K_CO_ID        IN SOLOT.CODSOLOT%TYPE,
                                K_CUSTOMER_ID  IN SOLOT.CUSTOMER_ID%TYPE,
                                K_TIPO         IN VARCHAR2,
                                K_CODSOLOT     OUT SOLOT.CODSOLOT%TYPE);

  PROCEDURE SIACSI_GENERA_SOLOTPTO (K_CODSOLOT      IN SOLOT.CODSOLOT%TYPE,
                                    K_NUMSLC        IN INSSRV.NUMSLC%TYPE);


  PROCEDURE SIACSI_ASIGNA_NUMERO(K_IDTAREAWF IN NUMBER,
                                 K_IDWF      IN NUMBER,
                                 K_TAREA     IN NUMBER,
                                 K_TAREADEF  IN NUMBER);

  PROCEDURE SIACSI_PROV_IL(K_IDTAREAWF IN NUMBER,
                           K_IDWF      IN NUMBER,
                           K_TAREA     IN NUMBER,
                           K_TAREADEF  IN NUMBER);

  PROCEDURE SIACSI_PROV_JANUS(K_IDTAREAWF IN NUMBER,
                              K_IDWF      IN NUMBER,
                              K_TAREA     IN NUMBER,
                              K_TAREADEF  IN NUMBER);

  PROCEDURE SIACSU_ASIG_NUM_BSCS(K_IDTAREAWF IN NUMBER,
                                 K_IDWF      IN NUMBER,
                                 K_TAREA     IN NUMBER,
                                 K_TAREADEF  IN NUMBER);

  PROCEDURE SIACSI_POS_COBRO_OCC(K_IDTAREAWF IN NUMBER,
                                 K_IDWF      IN NUMBER,
                                 K_TAREA     IN NUMBER,
                                 K_TAREADEF  IN NUMBER);

  PROCEDURE SIACSI_LIBERA_IW_INCOG(K_IDTAREAWF IN NUMBER,
                                   K_IDWF      IN NUMBER,
                                   K_TAREA     IN NUMBER,
                                   K_TAREADEF  IN NUMBER);

  PROCEDURE SIACSI_PRE_ENVIO_CORREO(K_IDTAREAWF IN NUMBER,
                                    K_IDWF      IN NUMBER,
                                    K_TAREA     IN NUMBER,
                                    K_TAREADEF  IN NUMBER);

  PROCEDURE SIACSU_ESTADO_TAREA(K_IDWF      TAREAWF.IDWF%TYPE,
                                K_IDTAREAWF TAREAWF.IDTAREAWF%TYPE,
                                K_ESTADO    NUMBER);

  PROCEDURE SIACSU_RESERVA_NUMERO(K_CO_ID        IN SOLOT.COD_ID%TYPE,
                                  K_CUSTOMER_ID  IN SOLOT.CUSTOMER_ID%TYPE,
                                  K_NUMERO       OUT NUMTEL.NUMERO%TYPE,
                                  K_ERROR_CODE   OUT NUMBER,
                                  K_ERROR_MSG    OUT VARCHAR2);

  PROCEDURE SIACSU_ROLLBACK_NUMERO(K_ID_TRANS     IN  SALES.SIACT_UTIL_TRAMA.TRAMN_IDINTERACCION%TYPE,
                                   K_NUMERO       IN  NUMTEL.NUMERO%TYPE,
                                   K_ERROR_CODE   OUT NUMBER,
                                   K_ERROR_MSG    OUT VARCHAR2);

  PROCEDURE SIACSI_NUMTEL_LTE(K_NUMERO     IN INSSRV.NUMERO%TYPE,
                              K_SIMCARD    IN NUMTEL.simcard%TYPE,
                              K_CODINSSRV  IN INSSRV.CODINSSRV%TYPE,
                              K_RESUL      OUT NUMBER,
                              K_MENSAJE    OUT VARCHAR2);

  PROCEDURE SIACSI_INSERT_NUMTEL(K_NUMERO    IN NUMTEL.NUMERO%TYPE,
                                 K_SIMCARD   IN NUMTEL.SIMCARD%TYPE,
                                 K_CODINSSRV IN INSSRV.CODINSSRV%TYPE,
                                 K_ESTNUMTEL IN NUMBER,
                                 K_TIPNUMTEL IN NUMBER,
                                 K_CODNUMTEL OUT NUMBER,
                                 K_COD       OUT NUMBER,
                                 K_MENSAJE   OUT VARCHAR2);

  PROCEDURE SIACSU_UPDATE_NUMTEL(K_SIMCARD   IN NUMTEL.SIMCARD%TYPE,
                                 K_CODINSSRV IN INSSRV.CODINSSRV%TYPE,
                                 K_ESTNUMTEL IN NUMBER,
                                 K_TIPNUMTEL IN NUMBER,
                                 K_CODNUMTEL IN NUMBER,
                                 K_PUBLICAR  IN NUMBER,
                                 K_COD       OUT NUMBER,
                                 K_MENSAJE   OUT VARCHAR2);

  PROCEDURE SIACSI_INSERT_RESERVATEL(K_CODNUMTEL IN RESERVATEL.CODNUMTEL%TYPE,
                                     K_CODINSSRV IN INSSRV.CODINSSRV%TYPE,
                                     K_ESTNUMTEL IN NUMBER,
                                     K_CODCLI    IN INSSRV.CODCLI%TYPE,
                                     K_COD       OUT NUMBER,
                                     K_MENSAJE   OUT VARCHAR2);

  PROCEDURE SIACSS_CONSULTA_TRAMA(K_CODSOLOT      IN SOLOT.CODSOLOT%TYPE,
                                  K_IDTRANSACCION OUT SALES.SIACT_UTIL_TRAMA.TRAMN_IDTRANSACCION%TYPE,
                                  K_IDINTERACCION OUT SALES.SIACT_UTIL_TRAMA.TRAMN_IDINTERACCION%TYPE,
                                  K_CO_ID         OUT SALES.SIACT_UTIL_TRAMA.TRAMN_CO_ID%TYPE,
                                  K_CUSTOMER_ID   OUT SALES.SIACT_UTIL_TRAMA.TRAMN_CUSTOMER_ID%TYPE,
                                  K_TRAMA         OUT SALES.SIACT_UTIL_TRAMA.TRAMV_TRAMA%TYPE);

  FUNCTION SIACFUN_OBTIENE_SOT(K_IDWF      IN wf.idwf%TYPE) RETURN NUMBER;
  
  PROCEDURE SIACSU_ROLLBACK_ESTADO(K_CODSOLOT IN SOLOT.CODSOLOT%TYPE,
                                   K_COD_ERR  OUT NUMBER,
                                   K_MSN_ERR  OUT VARCHAR2);
                                   
  PROCEDURE SIACSU_VALIDA_NUMERO (K_NUMERO IN NUMTEL.NUMERO%TYPE);
  
  FUNCTION SIACFUN_VALIDA_NUM(NUMERO_ANT IN VARCHAR,
                               CO_ID IN NUMBER)
                               RETURN NUMBER;

 END;  
/