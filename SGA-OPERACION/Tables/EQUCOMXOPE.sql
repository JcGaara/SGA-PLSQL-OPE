CREATE TABLE OPERACION.EQUCOMXOPE
(
  CODEQUCOM  CHAR(4 BYTE)                       NOT NULL,
  CODTIPEQU  CHAR(15 BYTE),
  CANTIDAD   NUMBER(8,2)                        DEFAULT 1                     NOT NULL,
  ESPARTE    NUMBER(1)                          DEFAULT 0                     NOT NULL,
  TIPEQU     NUMBER(6)                          NOT NULL,
  USERCODE   VARCHAR2(20 BYTE)                  DEFAULT user,
  USERDATE   DATE                               DEFAULT sysdate
);

COMMENT ON TABLE OPERACION.EQUCOMXOPE IS 'Relacion entre los equipos comerciales y operaciones';

COMMENT ON COLUMN OPERACION.EQUCOMXOPE.CODEQUCOM IS 'Codigo del equipo comercial';

COMMENT ON COLUMN OPERACION.EQUCOMXOPE.CODTIPEQU IS 'Codigo del tipo de equipo';

COMMENT ON COLUMN OPERACION.EQUCOMXOPE.CANTIDAD IS 'Cantidad del equipo comercial';

COMMENT ON COLUMN OPERACION.EQUCOMXOPE.ESPARTE IS 'Indica si el equipo comercial es parte del equipo de operacion';

COMMENT ON COLUMN OPERACION.EQUCOMXOPE.TIPEQU IS 'Codigo del tipo de equipo';

COMMENT ON COLUMN OPERACION.EQUCOMXOPE.USERCODE IS 'Usuario que registra el item';

COMMENT ON COLUMN OPERACION.EQUCOMXOPE.USERDATE IS 'Fecha de registro';


