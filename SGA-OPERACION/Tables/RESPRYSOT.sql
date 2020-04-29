CREATE TABLE OPERACION.RESPRYSOT
(
  PROYECTO     CHAR(10 BYTE),
  SOT          NUMBER(8)                        NOT NULL,
  TIPO         VARCHAR2(200 BYTE),
  ESTADO_SOT   VARCHAR2(100 BYTE)               NOT NULL,
  SERVICIO     VARCHAR2(50 BYTE),
  CODCLI       CHAR(8 BYTE)                     NOT NULL,
  NOMCLI       VARCHAR2(200 BYTE)               NOT NULL,
  FEC_GEN      DATE                             NOT NULL,
  FEC_APR      DATE,
  FEC_COM      DATE,
  FEC_COM_SOT  DATE
);


