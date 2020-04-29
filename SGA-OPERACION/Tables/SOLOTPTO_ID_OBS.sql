CREATE TABLE OPERACION.SOLOTPTO_ID_OBS
(
  ID           NUMBER(8),
  CODSOLOT     NUMBER(8),
  PUNTO        NUMBER(10),
  OBSERVACION  VARCHAR2(4000 BYTE),
  USUREG       VARCHAR2(30 BYTE)                DEFAULT user,
  FECREG       DATE                             DEFAULT sysdate,
  USUMOD       VARCHAR2(30 BYTE)                DEFAULT user,
  FECMOD       DATE                             DEFAULT sysdate
);


