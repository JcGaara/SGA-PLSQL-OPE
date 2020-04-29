CREATE OR REPLACE PACKAGE OPERACION.PQ_BSCS_IW IS
  /*******************************************************************************************************
   NOMBRE:       OPERACION.
   PROPOSITO:    Registrar Informacion en la Tablas de Intraway
   REVISIONES:
   Version    Fecha       Autor            Solicitado por    Descripcion
   ---------  ----------  ---------------  --------------    -----------------------------------------
    1.0       04/07/2014  Dorian Sucasaca  Hector Huaman     Registrar Informacion de  SISACT en INTRAWAY
  *******************************************************************************************************/
  
  FND_IDINTERFACE_CM      CONSTANT VARCHAR2(4) := '620';
  FND_IDINTERFACE_MTA     CONSTANT VARCHAR2(4) := '820';
  FND_IDINTERFACE_EP      CONSTANT VARCHAR2(4) := '824';
  FND_IDINTERFACE_CF      CONSTANT VARCHAR2(4) := '830';
  FND_IDINTERFACE_STB     CONSTANT VARCHAR2(4) := '2020';
  FND_IDINTERFACE_STB_SA  CONSTANT VARCHAR2(4) := '2030';
  FND_IDINTERFACE_STB_VOD CONSTANT VARCHAR2(4) := '2050';
  FND_IDSISTEMA           CONSTANT VARCHAR2(4) := '1';
  FND_IDEMPRESA           CONSTANT VARCHAR2(4) := '121';
  FND_IDCONEXION          CONSTANT VARCHAR2(4) := '0';
  
  N_INT_SRV_IW            INT_SERVICIO_INTRAWAY%ROWTYPE;

  PROCEDURE P_GEN_IW_SRV(A_IDTAREAWF IN NUMBER,
                         A_IDWF      IN NUMBER,
                         A_TAREA     IN NUMBER,
                         A_TAREADEF  IN NUMBER);
  
  /* Reserva espacio en Intraway para el Cable Modem */
  PROCEDURE P_INT_CM(CM_IMI  IN INT_SERVICIO_INTRAWAY%ROWTYPE,
                     CM_ID   IN OPERACION.TRS_INTERFACE_IW.IDTRS%TYPE,
                     CM_EST  OUT VARCHAR2,
                     CM_MSJ  OUT VARCHAR2);
                    
  /* Reserva espacio en Intraway para el MTA */
  PROCEDURE P_INT_MTA(MTA_IMI  IN INT_SERVICIO_INTRAWAY%ROWTYPE,
                      MTA_ID   IN OPERACION.TRS_INTERFACE_IW.IDTRS%TYPE,
                      MTA_EST  OUT VARCHAR2,
                      MTA_MSJ  OUT VARCHAR2);
                     
  /* Reserva espacio en Intraway para los EndPoint */                      
  PROCEDURE P_INT_EP(EP_IMI  IN INT_SERVICIO_INTRAWAY%ROWTYPE,
                     EP_ID   IN OPERACION.TRS_INTERFACE_IW.IDTRS%TYPE,
                     EP_EST  OUT VARCHAR2,
                     EP_MSJ  OUT VARCHAR2);
  
  /* Reserva espacio en Intraway para los Features */                     
  PROCEDURE P_INT_CF(CF_IMI  IN INT_SERVICIO_INTRAWAY%ROWTYPE,
                     CF_ID   IN OPERACION.TRS_INTERFACE_IW.IDTRS%TYPE,
                     CF_EST  OUT VARCHAR2,
                     CF_MSJ  OUT VARCHAR2);

  /* Reserva espacio en Intraway para el Set-top-Box */
  PROCEDURE P_INT_STB(STB_IMI   IN INT_SERVICIO_INTRAWAY%ROWTYPE,
                      STB_ID    IN OPERACION.TRS_INTERFACE_IW.IDTRS%TYPE,
                      STB_EST   OUT VARCHAR2,
                      STB_MSJ   OUT VARCHAR2);
                     
  /* Realiza la reserva de espacio para los Servicios Adicionales (canales de TV ) para los equipos STB */ 
  PROCEDURE P_INT_STB_SA(STB_SA_IMI  IN INT_SERVICIO_INTRAWAY%ROWTYPE,
                         STB_SA_ID      IN OPERACION.TRS_INTERFACE_IW.IDTRS%TYPE,
                         STB_SA_EST  OUT VARCHAR2,
                         STB_SA_MSJ  OUT VARCHAR2);

  PROCEDURE P_INT_STB_VOD(STB_VOD_IMI  IN INT_SERVICIO_INTRAWAY%ROWTYPE,
                          STB_VOD_ID    IN OPERACION.TRS_INTERFACE_IW.IDTRS%TYPE,
                          STB_VOD_EST  OUT VARCHAR2,
                          STB_VOD_MSJ  OUT VARCHAR2);
                         
  /* Grabar registros en la tabla int_mensaje_intraway */ 
  PROCEDURE P_REG_INT_MSJ_IW(M_INT_MENSAJE_IW  IN INT_MENSAJE_INTRAWAY%ROWTYPE,
                             M_ESTADO          OUT VARCHAR2,
                             M_MENSAJE         OUT VARCHAR2);

  /* Grabar registros en la tabla int_servicio_intraway */                               
  PROCEDURE P_REG_INT_SRV_IW(S_INT_MENSAJE_IW  IN INT_SERVICIO_INTRAWAY%ROWTYPE,
                             S_ESTADO          OUT VARCHAR2,
                             S_MENSAJE         OUT VARCHAR2);
                             
  /* Registra Errores en en Proceso */                           
  PROCEDURE P_REG_ERROR(S_IDTAREAWF  IN TAREAWFSEG.IDTAREAWF%TYPE,
                        S_MENSAJE    IN TAREAWFSEG.OBSERVACION%TYPE);
                                                              
END PQ_BSCS_IW;
/
