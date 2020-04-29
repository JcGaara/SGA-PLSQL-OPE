CREATE TABLE OPERACION.TIPESTDTH
(
  TIPOESTADO   NUMBER(3)                        NOT NULL,
  DESCRIPCION  VARCHAR2(100 BYTE),
  ACTIVO       NUMBER(1),
  USUREG       VARCHAR2(30 BYTE)                DEFAULT USER,
  FECREG       DATE                             DEFAULT SYSDATE,
  USUMOD       VARCHAR2(30 BYTE)                DEFAULT USER,
  FECMOD       DATE                             DEFAULT SYSDATE
);


