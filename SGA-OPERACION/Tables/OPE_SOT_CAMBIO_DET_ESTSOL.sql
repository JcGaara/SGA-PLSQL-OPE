CREATE TABLE OPERACION.OPE_SOT_CAMBIO_DET_ESTSOL
(
  IDSEQ   NUMBER(4)                             NOT NULL,
  ESTSOL  NUMBER(2)                             NOT NULL,
  ESTADO  NUMBER(1)                             DEFAULT 1                     NOT NULL,
  USUREG  VARCHAR2(30 BYTE)                     DEFAULT USER                  NOT NULL,
  FECREG  DATE                                  DEFAULT SYSDATE               NOT NULL,
  USUMOD  VARCHAR2(30 BYTE)                     DEFAULT USER                  NOT NULL,
  FECMOD  DATE                                  DEFAULT SYSDATE               NOT NULL
);


