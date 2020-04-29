CREATE TABLE OPERACION.ESTINSSRV
(
  ESTINSSRV    NUMBER(2)                        NOT NULL,
  DESCRIPCION  VARCHAR2(100 BYTE)               NOT NULL,
  FECUSU       DATE                             DEFAULT SYSDATE               NOT NULL,
  CODUSU       VARCHAR2(30 BYTE)                DEFAULT user                  NOT NULL,
  ABREVI       CHAR(2 BYTE)                     NOT NULL
);

COMMENT ON TABLE OPERACION.ESTINSSRV IS 'Estado de la instancia de servicio';

COMMENT ON COLUMN OPERACION.ESTINSSRV.ESTINSSRV IS 'Codigo del estado de la instancia de servicio';

COMMENT ON COLUMN OPERACION.ESTINSSRV.DESCRIPCION IS 'Descripcion del estado de instancia de servicio';

COMMENT ON COLUMN OPERACION.ESTINSSRV.FECUSU IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.ESTINSSRV.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.ESTINSSRV.ABREVI IS 'Abreviatura';


