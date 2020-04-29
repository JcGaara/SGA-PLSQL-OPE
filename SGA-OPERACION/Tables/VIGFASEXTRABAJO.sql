CREATE TABLE OPERACION.VIGFASEXTRABAJO
(
  TIPTRA  NUMBER(4)                             NOT NULL,
  FASE    NUMBER(2)                             NOT NULL,
  CODUSU  VARCHAR2(30 BYTE)                     DEFAULT user,
  FECUSU  DATE                                  DEFAULT sysdate
);


