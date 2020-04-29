CREATE TABLE OPERACION.CMPXTIPEQU
(
  CODTIPEQUCMP  CHAR(15 BYTE)                   NOT NULL,
  CODTIPEQU     CHAR(15 BYTE),
  CANTIDAD      NUMBER(8,2)                     DEFAULT 0                     NOT NULL,
  NECESARIO     NUMBER(1)                       DEFAULT 0                     NOT NULL,
  CODUSU        VARCHAR2(30 BYTE)               DEFAULT user                  NOT NULL,
  FECUSU        DATE                            DEFAULT SYSDATE               NOT NULL,
  TIPEQU        NUMBER(6)                       NOT NULL,
  TIPEQUCMP     NUMBER(6)
);

COMMENT ON TABLE OPERACION.CMPXTIPEQU IS 'Relacion de Componentes por cada tipo de equipo';

COMMENT ON COLUMN OPERACION.CMPXTIPEQU.CODTIPEQUCMP IS 'Codigo del tipo de equipo';

COMMENT ON COLUMN OPERACION.CMPXTIPEQU.CODTIPEQU IS 'Codigo del tipo de equipo';

COMMENT ON COLUMN OPERACION.CMPXTIPEQU.CANTIDAD IS 'Cantidad del componente de equipo';

COMMENT ON COLUMN OPERACION.CMPXTIPEQU.NECESARIO IS 'Indica si el componente es necesario';

COMMENT ON COLUMN OPERACION.CMPXTIPEQU.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.CMPXTIPEQU.FECUSU IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.CMPXTIPEQU.TIPEQU IS 'Codigo del tipo de equipo';

COMMENT ON COLUMN OPERACION.CMPXTIPEQU.TIPEQUCMP IS 'Codigo del tipo de equipo';


