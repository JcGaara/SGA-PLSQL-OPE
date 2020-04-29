CREATE TABLE OPERACION.MATETAPAXFOR
(
  CODFOR       NUMBER(5)                        NOT NULL,
  CODMAT       CHAR(15 BYTE)                    NOT NULL,
  CANTIDAD     NUMBER(8,2)                      DEFAULT 0                     NOT NULL,
  CODUSU       VARCHAR2(30 BYTE)                DEFAULT user                  NOT NULL,
  FECUSU       DATE                             DEFAULT SYSDATE               NOT NULL,
  CODETA       NUMBER(5)                        NOT NULL,
  CAN_MAX      NUMBER,
  RECUPERABLE  NUMBER                           DEFAULT 0,
  TIPO         NUMBER                           DEFAULT 1
);

COMMENT ON TABLE OPERACION.MATETAPAXFOR IS 'Tabla de Materiales etapa por formula';

COMMENT ON COLUMN OPERACION.MATETAPAXFOR.CODFOR IS 'Codigo de formula';

COMMENT ON COLUMN OPERACION.MATETAPAXFOR.CODMAT IS 'Codigo de material';

COMMENT ON COLUMN OPERACION.MATETAPAXFOR.CANTIDAD IS 'Cantidad de material';

COMMENT ON COLUMN OPERACION.MATETAPAXFOR.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.MATETAPAXFOR.FECUSU IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.MATETAPAXFOR.CODETA IS 'Etapa';

COMMENT ON COLUMN OPERACION.MATETAPAXFOR.RECUPERABLE IS 'Indica si el Equipo o Material sera recuperable';

COMMENT ON COLUMN OPERACION.MATETAPAXFOR.TIPO IS '1:Material 2;Equipo';


