CREATE TABLE OPERACION.BOUQUET
(
  IDBOUQUET    NUMBER                           NOT NULL,
  VALBOUQUET   VARCHAR2(300 BYTE),
  DESCBOUQUET  VARCHAR2(100 BYTE),
  CODUSU       VARCHAR2(30 BYTE)                DEFAULT user,
  FECREG       DATE                             DEFAULT sysdate,
  ESTADO       NUMBER(1)                        DEFAULT 1
);


