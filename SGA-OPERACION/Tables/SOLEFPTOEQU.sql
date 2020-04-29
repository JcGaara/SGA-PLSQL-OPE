CREATE TABLE OPERACION.SOLEFPTOEQU
(
  NUMSLC       CHAR(10 BYTE)                    NOT NULL,
  NUMPTO       CHAR(5 BYTE)                     NOT NULL,
  ORDEN        NUMBER(4)                        NOT NULL,
  TIPPRP       NUMBER(2)                        NOT NULL,
  OBSERVACION  VARCHAR2(200 BYTE),
  CANTIDAD     NUMBER(8,2)                      DEFAULT 1                     NOT NULL,
  FECUSU       DATE                             DEFAULT SYSDATE               NOT NULL,
  CODUSU       VARCHAR2(30 BYTE)                DEFAULT user                  NOT NULL,
  TIPEQU       NUMBER(6)                        NOT NULL
);

COMMENT ON TABLE OPERACION.SOLEFPTOEQU IS 'No es usada';

COMMENT ON COLUMN OPERACION.SOLEFPTOEQU.NUMSLC IS 'Numero de proyecto';

COMMENT ON COLUMN OPERACION.SOLEFPTOEQU.NUMPTO IS 'Numero de punto del proyecto';

COMMENT ON COLUMN OPERACION.SOLEFPTOEQU.ORDEN IS 'Orden de la tabla';

COMMENT ON COLUMN OPERACION.SOLEFPTOEQU.TIPPRP IS 'Tipo de propiedad';

COMMENT ON COLUMN OPERACION.SOLEFPTOEQU.OBSERVACION IS 'Observaci�n';

COMMENT ON COLUMN OPERACION.SOLEFPTOEQU.CANTIDAD IS 'Cantidad de equipos';

COMMENT ON COLUMN OPERACION.SOLEFPTOEQU.FECUSU IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.SOLEFPTOEQU.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.SOLEFPTOEQU.TIPEQU IS 'Codigo de tipo de equipo';

