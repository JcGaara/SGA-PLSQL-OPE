CREATE TABLE OPERACION.TECNICO
(
  CODTEC     NUMBER(6)                          NOT NULL,
  CODCON     NUMBER(6)                          NOT NULL,
  IDZONA     CHAR(3 BYTE)                       NOT NULL,
  CODJEFE    NUMBER(6),
  RUT        VARCHAR2(10 BYTE)                  NOT NULL,
  NOMBRE     VARCHAR2(100 BYTE)                 NOT NULL,
  FECING     DATE,
  FECSAL     DATE,
  MOTSAL     VARCHAR2(200 BYTE),
  FLG_CARGO  NUMBER(1)                          DEFAULT 0                     NOT NULL,
  FECUSU     DATE                               DEFAULT SYSDATE               NOT NULL,
  CODUSU     VARCHAR2(30 BYTE)                  DEFAULT user                  NOT NULL,
  DV         CHAR(1 BYTE)                       NOT NULL
);


