CREATE TABLE OPERACION.EFMOTIVOMOD
(
  IDMOTIVO     NUMBER(2)                        NOT NULL,
  DESCRIPCION  VARCHAR2(100 BYTE)               NOT NULL,
  ESTADO       NUMBER                           DEFAULT 1                     NOT NULL,
  FECUSU       DATE                             DEFAULT SYSDATE               NOT NULL,
  CODUSU       VARCHAR2(30 BYTE)                DEFAULT user                  NOT NULL,
  ABREVI       CHAR(2 BYTE)                     NOT NULL
);


