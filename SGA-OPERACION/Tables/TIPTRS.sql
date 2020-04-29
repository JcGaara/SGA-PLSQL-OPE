CREATE TABLE OPERACION.TIPTRS
(
  TIPTRS       NUMBER(2)                        NOT NULL,
  ESTINSSRV    NUMBER(2),
  DESCRIPCION  VARCHAR2(100 BYTE)               NOT NULL,
  ABREVI       CHAR(2 BYTE)                     NOT NULL,
  FECUSU       DATE                             DEFAULT SYSDATE               NOT NULL,
  CODUSU       VARCHAR2(30 BYTE)                DEFAULT user                  NOT NULL
);

COMMENT ON TABLE OPERACION.TIPTRS IS 'Tipo de la transaccion ';

COMMENT ON COLUMN OPERACION.TIPTRS.TIPTRS IS 'Codigo del tipo de transaccion';

COMMENT ON COLUMN OPERACION.TIPTRS.ESTINSSRV IS 'Codigo del estado de la instancia de servicio';

COMMENT ON COLUMN OPERACION.TIPTRS.DESCRIPCION IS 'Descripcion del tipo de transaccion';

COMMENT ON COLUMN OPERACION.TIPTRS.ABREVI IS 'Abreviatura';

COMMENT ON COLUMN OPERACION.TIPTRS.FECUSU IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.TIPTRS.CODUSU IS 'Codigo de Usuario registro';


