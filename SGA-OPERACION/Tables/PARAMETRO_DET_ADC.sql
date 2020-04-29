CREATE TABLE operacion.parametro_det_adc  
(
  id_parametro NUMBER(8) 	NOT NULL,
  id_detalle   NUMBER(8) 	NOT NULL,
  codigoc      VARCHAR2(500),
  codigon      NUMBER(8),
  descripcion  VARCHAR2(100),
  abreviatura  VARCHAR2(30),
  estado       CHAR(1),
  feccre       DATE DEFAULT SYSDATE,
  usucre       VARCHAR2(30) DEFAULT USER,
  fecmod       DATE,
  usumod       VARCHAR2(30),
  ipcre        VARCHAR2(30),
  ipmod        VARCHAR2(30)
)
TABLESPACE operacion_dat;

COMMENT ON COLUMN operacion.parametro_det_adc.id_parametro IS 'Tipo de parametro';
COMMENT ON COLUMN operacion.parametro_det_adc.id_detalle  IS 'Secuencia detalle';
COMMENT ON COLUMN operacion.parametro_det_adc.descripcion IS 'Descripcion del tipo de parametro';
COMMENT ON COLUMN operacion.parametro_det_adc.abreviatura IS 'Abreviatura del tipo de parametro';
comment on column operacion.parametro_det_adc.estado 	  IS 'Estado del tipo de parametro';
COMMENT ON COLUMN operacion.parametro_cab_adc.ipcre   	  IS 'IP que registro ';
COMMENT ON COLUMN operacion.parametro_cab_adc.ipmod  	  IS 'IP que modifico';
COMMENT ON COLUMN operacion.parametro_cab_adc.feccre  	  IS 'fecha de creacion';
COMMENT ON COLUMN operacion.parametro_cab_adc.fecmod  	  IS 'fecha de modificacion';
COMMENT ON COLUMN operacion.parametro_cab_adc.usucre  	  IS 'usuario que creo';
COMMENT ON COLUMN operacion.parametro_cab_adc.usumod  	  IS 'usuario que modifico';
/