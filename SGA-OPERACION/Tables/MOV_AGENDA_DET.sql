CREATE TABLE OPERACION.MOV_AGENDA_DET
(
  CODCON         NUMBER,
  FECHA          DATE,
  IDBLOQUE       NUMBER,
  CANT_INST      NUMBER,
  IDZONA         CHAR(3 BYTE),
  SALTO          NUMBER,
  FLG_SALTO      CHAR(1 BYTE),
  CANT_MAX_INST  NUMBER,
  USUREG         VARCHAR2(30 BYTE)              DEFAULT USER,
  FECREG         DATE                           DEFAULT SYSDATE,
  USUMOD         VARCHAR2(30 BYTE)              DEFAULT USER,
  FECMOD         DATE                           DEFAULT SYSDATE
);


