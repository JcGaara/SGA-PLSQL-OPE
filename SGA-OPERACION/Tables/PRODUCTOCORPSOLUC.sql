CREATE TABLE OPERACION.PRODUCTOCORPSOLUC
(
  CODPRD      NUMBER(5)                         NOT NULL,
  IDSOLUCION  NUMBER(10)                        NOT NULL,
  CODUSU      VARCHAR2(50 BYTE)                 DEFAULT USER,
  FECUSU      DATE                              DEFAULT SYSDATE,
  ESTADO      NUMBER(1),
  SOLUCION    VARCHAR2(100 BYTE)
);


