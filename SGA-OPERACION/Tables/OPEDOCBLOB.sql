CREATE TABLE OPERACION.OPEDOCBLOB
(
  DOCANEXO     NUMBER(10)                       NOT NULL,
  DOCID        NUMBER(10)                       NOT NULL,
  DESCRIPCION  VARCHAR2(100 BYTE),
  DATA         BLOB,
  CODUSU       VARCHAR2(30 BYTE)                DEFAULT user                  NOT NULL,
  FECUSU       DATE                             DEFAULT SYSDATE               NOT NULL,
  TIPO         VARCHAR2(20 BYTE),
  RESUMEN      VARCHAR2(200 BYTE),
  RUTA         VARCHAR2(1000 BYTE)
);


