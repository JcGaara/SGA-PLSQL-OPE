CREATE TABLE OPERACION.LIQUIDACIONDOCBLOB
(
  IDLIQDOCBLOB  NUMBER(10)                      NOT NULL,
  IDLIQ         NUMBER(10),
  DESCRIPCION   VARCHAR2(100 BYTE),
  DATA          BLOB,
  CODUSU        VARCHAR2(30 BYTE)               DEFAULT user                  NOT NULL,
  FECUSU        DATE                            DEFAULT sysdate               NOT NULL
);


