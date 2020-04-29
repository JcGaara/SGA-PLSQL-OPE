CREATE TABLE OPERACION.PROYECTOSXCERRAR
(
  NUMSLC  CHAR(10 BYTE)                         NOT NULL,
  CID     NUMBER(8)                             NOT NULL,
  FECINI  DATE                                  NOT NULL,
  FECFIN  DATE                                  NOT NULL,
  DIATOT  NUMBER(8)                             NOT NULL,
  MONTO   NUMBER                                NOT NULL,
  FECEJE  DATE                                  DEFAULT sysdate               NOT NULL
);


