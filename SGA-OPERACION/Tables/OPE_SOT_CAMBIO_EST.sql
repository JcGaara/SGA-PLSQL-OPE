CREATE TABLE OPERACION.OPE_SOT_CAMBIO_EST
(
  IDSEQ         NUMBER(4)                       NOT NULL,
  TIPSRV        CHAR(4 BYTE),
  NDIAS_PEND    NUMBER(4),
  TIPO_NDIAS    NUMBER(2),
  FLG_AGENDA    NUMBER(1),
  ESTSOL_NEW    NUMBER(2),
  CODMOTOT_NEW  NUMBER(3),
  TIPTRA        NUMBER(4),
  OBSERVACION   VARCHAR2(4000 BYTE),
  ESTADO        NUMBER(1)                       DEFAULT 1                     NOT NULL,
  USUREG        VARCHAR2(30 BYTE)               DEFAULT USER                  NOT NULL,
  FECREG        DATE                            DEFAULT SYSDATE               NOT NULL,
  USUMOD        VARCHAR2(30 BYTE)               DEFAULT USER                  NOT NULL,
  FECMOD        DATE                            DEFAULT SYSDATE               NOT NULL
);


