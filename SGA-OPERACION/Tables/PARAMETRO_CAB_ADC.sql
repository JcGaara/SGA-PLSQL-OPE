CREATE TABLE operacion.PARAMETRO_CAB_ADC  (
   ID_PARAMETRO         NUMBER(8)   NOT NULL,
   DESCRIPCION          VARCHAR2(50),
   ABREVIATURA          VARCHAR2(30),
   ESTADO               CHAR(1) 	 DEFAULT 1,
   FECCRE               DATE DEFAULT SYSDATE,
   USUCRE               VARCHAR2(30) DEFAULT USER,
   FECMOD               DATE,
   USUMOD               VARCHAR2(30),
   IPCRE                VARCHAR2(30),
   IPMOD                VARCHAR2(30)
)
TABLESPACE operacion_dat;

COMMENT ON COLUMN operacion.parametro_cab_adc.id_parametro IS 'Tipo de parametro';
COMMENT ON COLUMN operacion.parametro_cab_adc.descripcion IS 'Descripcion del tipo de parametro';
COMMENT ON COLUMN operacion.parametro_cab_adc.abreviatura IS 'Abreviatura del tipo de parametro';
COMMENT ON COLUMN operacion.parametro_cab_adc.estado 	  IS 'Estado del tipo de parametro';
COMMENT ON COLUMN operacion.parametro_cab_adc.ipcre   	  IS 'IP que registro ';
COMMENT ON COLUMN operacion.parametro_cab_adc.ipmod  	  IS 'IP que modifico';
COMMENT ON COLUMN operacion.parametro_cab_adc.feccre  	  IS 'fecha de creacion';
COMMENT ON COLUMN operacion.parametro_cab_adc.fecmod  	  IS 'fecha de modificacion';
COMMENT ON COLUMN operacion.parametro_cab_adc.usucre  	  IS 'usuario que creo';
COMMENT ON COLUMN operacion.parametro_cab_adc.usumod  	  IS 'usuario que modifico';
/