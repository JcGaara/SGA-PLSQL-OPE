CREATE TABLE OPERACION.TIPINSSRV
(
  TIPINSSRV    NUMBER(2)                        NOT NULL,
  DESCRIPCION  VARCHAR2(100 BYTE)               NOT NULL,
  ABREVI       CHAR(10 BYTE)                    NOT NULL
);

COMMENT ON TABLE OPERACION.TIPINSSRV IS 'Tipos de Instancias de Servicio: Sucursal Datos o Elemento de Red';

COMMENT ON COLUMN OPERACION.TIPINSSRV.TIPINSSRV IS 'Tipo de instancia de servicio';

COMMENT ON COLUMN OPERACION.TIPINSSRV.DESCRIPCION IS 'Descripcion del tipo de instancia de servicio';

COMMENT ON COLUMN OPERACION.TIPINSSRV.ABREVI IS 'Abreviatura';


