CREATE TABLE OPERACION.VIGRESUMEN_DET
(
  ID      NUMBER(10)                            NOT NULL,
  AREA    NUMBER(4)                             NOT NULL,
  CODUSU  VARCHAR2(30 BYTE)                     DEFAULT user,
  FECUSU  DATE                                  DEFAULT sysdate
);


