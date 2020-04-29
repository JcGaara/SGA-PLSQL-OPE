create table operacion.ESTADO_MOTIVO_SGA_ADC
(
  id_tipo_orden        NUMBER(10) not null,
  idestado_sga_origen  NUMBER(8) not null,
  idmotivo_sga_origen  NUMBER(8) not null,
  idestado_adc_destino NUMBER(8) not null,
  idmotivo_sga_destino NUMBER(8) not null,
  estado               CHAR(1) default '1',
  feccrea              DATE default SYSDATE,
  usucrea              VARCHAR2(30) default USER,
  fecmod               DATE,
  usumod               VARCHAR2(30),
  ipcre                VARCHAR2(30),
  ipmod                VARCHAR2(30))
TABLESPACE operacion_dat;

COMMENT ON COLUMN operacion.estado_motivo_sga_adc.id_tipo_orden        IS 'Tipo de orden';
COMMENT ON COLUMN operacion.estado_motivo_sga_adc.idestado_sga_origen  IS 'Estado SGA de origen';
COMMENT ON COLUMN operacion.estado_motivo_sga_adc.idmotivo_sga_origen  IS 'Motivo SGA de origen';
COMMENT ON COLUMN operacion.estado_motivo_sga_adc.idestado_adc_destino IS 'Estado ETA de destino';
COMMENT ON COLUMN operacion.estado_motivo_sga_adc.idmotivo_sga_destino IS 'Motivo SGA de destino';
COMMENT ON COLUMN operacion.parametro_cab_adc.ipcre   		       IS 'IP que registro ';
COMMENT ON COLUMN operacion.parametro_cab_adc.ipmod   		       IS 'IP que modifico';
COMMENT ON COLUMN operacion.parametro_cab_adc.feccre  		       IS 'Fecha de creacion';
COMMENT ON COLUMN operacion.parametro_cab_adc.fecmod  		       IS 'Fecha de modificacion';
COMMENT ON COLUMN operacion.parametro_cab_adc.usucre  		       IS 'Usuario que creo';
COMMENT ON COLUMN operacion.parametro_cab_adc.usumod  		       IS 'Usuario que modifico';
