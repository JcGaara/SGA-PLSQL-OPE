CREATE TABLE OPERACION.BODPRODUCTO
(
  IDBODPRODUCTO  NUMBER(5)                      NOT NULL,
  IDPRODUCTO     NUMBER(10)                     NOT NULL,
  IDPRODUCTOBOD  NUMBER(10)                     NOT NULL,
  FLGBOD         NUMBER,
  FLGFACT        NUMBER,
  CODUSU         VARCHAR2(30 BYTE)              DEFAULT USER,
  FECUSU         DATE                           DEFAULT SYSDATE,
  TIPSRV         CHAR(4 BYTE),
  FLGACCESO      NUMBER
);


