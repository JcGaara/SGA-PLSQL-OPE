CREATE OR REPLACE PACKAGE OPERACION.PKG_UPGRADE_SERV_CORP IS

  /*******************************************************************************
  PROPOSITO: EGeneracion de SOT por Updagre de servicio
  *******************************************************************************/
  CN_TIPSV_CABLE CONSTANT CHAR(4) := '0062'; -- Cable
  CN_TIPSV_INT   CONSTANT CHAR(4) := '0006'; -- Internet
  CN_TIPSV_TLF   CONSTANT CHAR(4) := '0004'; -- Telefonia
  PROCEDURE SGASS_PROCESAR_SOT;

  PROCEDURE SGASI_GENERAR_SOT(PI_CODSOLOT OPERACION.SOLOT.CODSOLOT%TYPE);

  FUNCTION SGAFUN_REGISTRAR_SOLOT(PI_CODSOLOT OPERACION.SOLOT.CODSOLOT%TYPE)
           RETURN SOLOT.CODSOLOT%TYPE;

  --Registra pids nuevos CORE y ADIC en inssrv y solotpto
  PROCEDURE SGASI_REGISTRAR_SOLOTPTO(P_CODSOLOT     SOLOT.CODSOLOT%TYPE,
                                     P_CODSOLOT_ANT SOLOT.CODSOLOT%TYPE);

  FUNCTION SGAFUN_GET_CODINSSRV(P_CODSOLOT OPERACION.SOLOT.CODSOLOT%TYPE,
                         P_TIPSRV   INSSRV.TIPSRV%TYPE)
    RETURN INSSRV.CODINSSRV%TYPE;

  FUNCTION F_GET_TIPO_PRODUCTO(AV_CODSRV SALES.SGAT_MIGRA_UP_CORP.SGAV_CODSRV_OLD%TYPE)
    RETURN INSSRV.TIPSRV%TYPE; --2.0
  PROCEDURE SGASI_REG_LOG(AC_CODCLI      OPERACION.SOLOT.CODCLI%TYPE,
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


  PROCEDURE SGASU_ACT_DESACT_SERV_SGA(A_IDTAREAWF IN NUMBER,
                                  A_IDWF      IN NUMBER,
                                  A_TAREA     IN NUMBER,
                                  A_TAREADEF  IN NUMBER);

  PROCEDURE SGASU_ACT_VTADETPTOENL(P_CODSOLOT   SOLOT.CODSOLOT%TYPE); 

  PROCEDURE SGASI_JOB_ATIENDE_SOT_UP;

END;
/