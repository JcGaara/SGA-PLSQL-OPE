CREATE OR REPLACE PACKAGE OPERACION.PKG_PROVISION_EAI IS

  -- AUTHOR  : C13985
  -- CREATED : 08/05/2019 05:12:51 PM

  G_CODSOLOT NUMBER; --7.0
  PROCEDURE SSGA_SOT_PROCESO(PI_CUSTOMERID NUMBER,
                             PO_CODERROR   OUT NUMBER,
                             PO_MSJERROR   OUT VARCHAR2);

  PROCEDURE ISGA_GENERA_SOT(PI_CUSTOMERID NUMBER,
                            PO_CODERROR   OUT NUMBER,
                            PO_MSJERROR   OUT VARCHAR2,
                            PI_TIPTRS     NUMBER, --3 Suspension,4 Reconexion
                            PI_IDTRSEXT   NUMBER);
  PROCEDURE P_INSERT_SOT(V_CODCLI      IN SOLOT.CODCLI%TYPE,
                         V_TIPTRA      IN SOLOT.TIPTRA%TYPE,
                         V_TIPSRV      IN SOLOT.TIPSRV%TYPE,
                         V_GRADO       IN SOLOT.GRADO%TYPE,
                         V_MOTIVO      IN SOLOT.CODMOTOT%TYPE,
                         V_AREASOL     IN SOLOT.AREASOL%TYPE,
                         PI_CUSTOMERID IN SOLOT.CUSTOMER_ID%TYPE,
                         A_IDOAC       IN NUMBER,
                         A_CODSOLOT    OUT NUMBER);
  PROCEDURE P_INSERT_SOLOTPTO(AN_CODSOLOT  IN SOLOT.CODSOLOT%TYPE,
                              AV_CODCLI    IN VARCHAR2,
                              AV_CUSTMERID IN NUMBER,
                              AC_MENSAJE   OUT VARCHAR2,
                              AN_PUNTOS    OUT NUMBER);
  FUNCTION F_GET_TIPTRA(LN_TIPTRS NUMBER) RETURN NUMBER;
END;
/