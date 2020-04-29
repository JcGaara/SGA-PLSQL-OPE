CREATE TABLE OPERACION.SOLOTPTOCNT
(
  CODSOLOT     NUMBER(8)                        NOT NULL,
  PUNTO        NUMBER(10)                       NOT NULL,
  ORDEN        NUMBER(5)                        NOT NULL,
  NOMCNT       VARCHAR2(100 BYTE)               NOT NULL,
  CARCNT       VARCHAR2(40 BYTE),
  DIRCNT       VARCHAR2(480 BYTE)               NOT NULL,
  TELEFONO     VARCHAR2(50 BYTE),
  TELEFONO2    VARCHAR2(50 BYTE),
  EMAIL        VARCHAR2(120 BYTE),
  OBSERVACION  VARCHAR2(500 BYTE),
  CODUSU       VARCHAR2(30 BYTE)                DEFAULT user,
  FECUSU       DATE                             DEFAULT sysdate
);

COMMENT ON COLUMN OPERACION.SOLOTPTOCNT.CODSOLOT IS 'Nro de la solicitud';

COMMENT ON COLUMN OPERACION.SOLOTPTOCNT.PUNTO IS 'Punto de la solicitud';

COMMENT ON COLUMN OPERACION.SOLOTPTOCNT.NOMCNT IS 'Nombre del contacto';

COMMENT ON COLUMN OPERACION.SOLOTPTOCNT.CARCNT IS 'Cargo del contacto';

COMMENT ON COLUMN OPERACION.SOLOTPTOCNT.DIRCNT IS 'Direcci�n del contacto';

COMMENT ON COLUMN OPERACION.SOLOTPTOCNT.TELEFONO IS 'Telefono del contacto';

COMMENT ON COLUMN OPERACION.SOLOTPTOCNT.TELEFONO2 IS 'Telefono del contacto';

COMMENT ON COLUMN OPERACION.SOLOTPTOCNT.EMAIL IS 'Correo del contacto';

COMMENT ON COLUMN OPERACION.SOLOTPTOCNT.OBSERVACION IS 'Observacion';


