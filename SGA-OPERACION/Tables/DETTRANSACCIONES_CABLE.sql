CREATE TABLE OPERACION.DETTRANSACCIONES_CABLE
(
  NOMABR            VARCHAR2(50 BYTE),
  CODINSSRV         NUMBER(10),
  IDTRANS           NUMBER,
  IDENTIFICADORCLC  NUMBER,
  ESTADO            NUMBER                      DEFAULT 1,
  CODUSU            VARCHAR2(50 BYTE)           DEFAULT user,
  FECUSU            DATE                        DEFAULT sysdate
);


