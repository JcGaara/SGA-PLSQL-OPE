CREATE TABLE OPERACION.SERVICIO_DOC
(
  IDDOC        NUMBER(10)                       NOT NULL,
  CODINSSRV    NUMBER(10),
  IDIMAGEN     NUMBER,
  TIPODOC      NUMBER(2),
  OBSERVACION  VARCHAR2(400 BYTE),
  USUREG       VARCHAR2(30 BYTE)                DEFAULT user                  NOT NULL,
  FECREG       DATE                             DEFAULT sysdate               NOT NULL,
  USUMOD       VARCHAR2(30 BYTE)                DEFAULT user                  NOT NULL,
  FECMOD       DATE                             DEFAULT sysdate               NOT NULL
);


