-- Create table
create table operacion.subtipo_orden_adc
(
  id_subtipo_orden  NUMBER(10) not null,
  cod_subtipo_orden VARCHAR2(10),
  descripcion       VARCHAR2(100),
  tiempo_min        NUMBER,
  id_work_skill     NUMBER(10),
  grado_dificultad  NUMBER(10),
  id_tipo_orden     NUMBER(10),
  estado            NUMBER(1) default 0,
  servicio          NUMBER(8),
  decos             NUMBER(8),  
  ipcre             VARCHAR2(20),
  ipmod             VARCHAR2(20),
  fecre             DATE default sysdate,
  fecmod            DATE,
  usucre            VARCHAR2(30) default user,
  usumod            VARCHAR2(30)
)
TABLESPACE OPERACION_DAT;

-- Add comments to the columns 
COMMENT ON COLUMN OPERACION.SUBTIPO_ORDEN_ADC.id_subtipo_orden  IS 'codigo secuencial';
COMMENT ON COLUMN OPERACION.SUBTIPO_ORDEN_ADC.cod_subtipo_orden IS 'codigo del sub tipo de orden';
COMMENT ON COLUMN OPERACION.SUBTIPO_ORDEN_ADC.descripcion  		IS 'nombre del sub tipo de orden';
COMMENT ON COLUMN OPERACION.SUBTIPO_ORDEN_ADC.tiempo_min  		IS 'tiempo minimo';
COMMENT ON COLUMN OPERACION.SUBTIPO_ORDEN_ADC.id_work_skill  	IS 'codigo de work skill';
COMMENT ON COLUMN OPERACION.SUBTIPO_ORDEN_ADC.grado_dificultad  IS 'Grado de difultad del subtipo';
COMMENT ON COLUMN OPERACION.SUBTIPO_ORDEN_ADC.id_tipo_orden  	IS 'codigo del tipo de orden';
COMMENT ON COLUMN OPERACION.SUBTIPO_ORDEN_ADC.estado  			IS 'acitvo = 1 , inactivo = 0';
COMMENT ON COLUMN OPERACION.SUBTIPO_ORDEN_ADC.servicio  		IS 'tipo de servico';
COMMENT ON COLUMN OPERACION.SUBTIPO_ORDEN_ADC.decos 			IS 'numero de decos';
COMMENT ON COLUMN OPERACION.SUBTIPO_ORDEN_ADC.ipcre  			IS 'ip de la pc que creo el tipo de orden';
COMMENT ON COLUMN OPERACION.SUBTIPO_ORDEN_ADC.ipmod  			IS 'ip de la pc que modifico el tipo de orden';
COMMENT ON COLUMN OPERACION.SUBTIPO_ORDEN_ADC.fecre  			IS 'fecha de la pc que creo el tipo de orden';
COMMENT ON COLUMN OPERACION.SUBTIPO_ORDEN_ADC.fecmod  			IS 'fecha de la pc que modifico el tipo de orden';
COMMENT ON COLUMN OPERACION.SUBTIPO_ORDEN_ADC.usucre  			IS 'usuario de la pc que creo el tipo de orden';
COMMENT ON COLUMN OPERACION.SUBTIPO_ORDEN_ADC.usumod  			IS 'usuario de la pc que modifico el tipo de orden';