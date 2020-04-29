CREATE TABLE OPERACION.MATRIZAPROB
(
  CODSRV     CHAR(4 BYTE)                       NOT NULL,
  TIPO       NUMBER(2)                          NOT NULL,
  COSTO_PIN  NUMBER(12,4)                       DEFAULT 0,
  COSTO_PEX  NUMBER(12,4)                       DEFAULT 0,
  CODUSU     VARCHAR2(30 BYTE)                  DEFAULT user,
  FECUSU     DATE                               DEFAULT sysdate,
  CODUSUMOD  VARCHAR2(30 BYTE)                  DEFAULT user,
  FECUSUMOD  DATE                               DEFAULT sysdate
);


