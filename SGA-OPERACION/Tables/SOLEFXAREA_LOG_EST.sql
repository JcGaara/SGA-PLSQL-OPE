CREATE TABLE OPERACION.SOLEFXAREA_LOG_EST
(
  CODEF   NUMBER(8)                             NOT NULL,
  AREA    NUMBER(4)                             NOT NULL,
  FECMOD  DATE                                  NOT NULL,
  USUMOD  VARCHAR2(30 BYTE)                     NOT NULL,
  OLDEST  NUMBER(2),
  NEWEST  NUMBER(2)
);


