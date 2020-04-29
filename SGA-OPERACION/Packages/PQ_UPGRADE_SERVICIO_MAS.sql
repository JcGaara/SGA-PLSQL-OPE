CREATE OR REPLACE PACKAGE OPERACION.PQ_UPGRADE_SERVICIO_MAS IS

  /*******************************************************************************
  PROPOSITO: Generacion de SOT por Updagre de servicio
  *******************************************************************************/
  CN_TIPSV_CABLE CONSTANT VARCHAR2(4) := '0062'; -- Cable
  CN_TIPSV_INT   CONSTANT VARCHAR2(4) := '0006'; -- Internet
  CN_TIPSV_TLF   CONSTANT VARCHAR2(4) := '0004'; -- Telefonia
  
  G_ID INTEGER;
  PROCEDURE P_JOB_GENERA_SOT;

  PROCEDURE P_GENERA_TRANS_UPGRADE(P_COD_ID OPERACION.SOLOT.COD_ID%TYPE);

  FUNCTION REGISTRAR_SOLOT(P_COD_ID   OPERACION.SOLOT.COD_ID%TYPE,
                           P_CODSOLOT OPERACION.SOLOT.CODSOLOT%TYPE)
    RETURN SOLOT.CODSOLOT%TYPE;

  --Registra pids nuevos CORE y ADIC en inssrv y solotpto
  PROCEDURE REGISTRAR_SOLOTPTO(P_COD_ID       SOLOT.COD_ID%TYPE,
                               P_CODSOLOT     SOLOT.CODSOLOT%TYPE,
                               P_CODSOLOT_ANT SOLOT.CODSOLOT%TYPE);

  FUNCTION GET_CODINSSRV(P_CODSOLOT OPERACION.SOLOT.CODSOLOT%TYPE,
                         P_TIPSRV   INSSRV.TIPSRV%TYPE)
    RETURN INSSRV.CODINSSRV%TYPE;

  FUNCTION F_GET_TIPO_PRODUCTO(AV_CODSRV SALES.MIGRA_UPGRADE_MASIVO.CODSRV_OLD%TYPE)
    RETURN INSSRV.TIPSRV%TYPE; --2.0
  PROCEDURE P_REG_LOG(AC_CODCLI      OPERACION.SOLOT.CODCLI%TYPE,
                      AN_CUSTOMER_ID NUMBER,
                      AN_IDTRS       NUMBER,
                      AN_CODSOLOT    NUMBER,
                      AN_IDINTERFACE NUMBER,
                      AN_ERROR       NUMBER,
                      AV_TEXTO       VARCHAR2,
                      AN_COD_ID      NUMBER DEFAULT 0,
                      AV_PROCESO     VARCHAR DEFAULT '');

  --Ejecuta upgrade se baja todo lo que tiene y activa tal cual detalle de la solotpto
  PROCEDURE P_EJE_UPGRADE_INCOGNITO(A_IDTAREAWF IN NUMBER,
                                    A_IDWF      IN NUMBER,
                                    A_TAREA     IN NUMBER,
                                    A_TAREADEF  IN NUMBER);

  PROCEDURE P_CAMBIO_JANUS(AN_CODSOLOT NUMBER);

  PROCEDURE SP_PROV_ADIC_JANUS(P_CO_ID       IN INTEGER,
                               P_CUSTOMER_ID IN INTEGER,
                               P_TMCODE      IN INTEGER,
                               P_SNCODE      IN INTEGER,
                               P_ACCION      IN VARCHAR2,
                               P_RESULTADO   OUT INTEGER,
                               P_MSGERR      OUT VARCHAR2,
                               P_ORDID       OUT NUMBER);

  PROCEDURE P_ACT_DESACT_SERV_BSCS(A_IDTAREAWF IN NUMBER,
                                   A_IDWF      IN NUMBER,
                                   A_TAREA     IN NUMBER,
                                   A_TAREADEF  IN NUMBER);

  PROCEDURE P_ACT_DESACT_SERV_SGA(A_IDTAREAWF IN NUMBER,
                                  A_IDWF      IN NUMBER,
                                  A_TAREA     IN NUMBER,
                                  A_TAREADEF  IN NUMBER);

  PROCEDURE P_ACT_VTADETPTOENL(P_COD_ID       SOLOT.COD_ID%TYPE); --4.0

  PROCEDURE P_JOB_ATIENDE_SOT_UP;

   PROCEDURE P_JOB_GENERA_SOT_DESAC;

END;
/
