ALTER TABLE operacion.transaccion_ws_adc
ADD codincidence NUMBER(8);
COMMENT ON COLUMN operacion.transaccion_ws_adc.codincidence IS 'Código de Incidencia';

ALTER TABLE operacion.tmp_capacidad
ADD codincidence NUMBER(8);
COMMENT ON COLUMN operacion.tmp_capacidad.codincidence IS 'Código de Incidencia';

ALTER TABLE operacion.matriz_tystipsrv_tiptra_adc
ADD con_cap_i NUMBER(1) DEFAULT 0;
COMMENT ON COLUMN operacion.matriz_tystipsrv_tiptra_adc.con_cap_i IS 'Consulta Capacidad de Incidencia';

-- AGREGAR CAMPO A TIPO DE TRABAJO RF01   
--OPERACION
alter table operacion.tiptrabajo
add  ID_TIPO_ORDEN_CE numeric(10);
comment on column OPERACION.TIPTRABAJO.ID_TIPO_ORDEN_CE
is 'codigo del tipo orden CE';
  
-- CAMPO EN operacion.TIPO_ORDEN_ADC
alter table operacion.TIPO_ORDEN_ADC
add  flg_Tipo numeric(10);
comment on column OPERACION.TIPO_ORDEN_ADC.flg_Tipo
is 'Flag para indicar si es tipo Masivo, Claro Empresa... tipos y estados FLG_TIPO_ADC';
  
--CAMPO EN operacion.SUBTIPO_ORDEN_ADC
alter table operacion.SUBTIPO_ORDEN_ADC
add  lineas numeric(10);
comment on column OPERACION.SUBTIPO_ORDEN_ADC.lineas
is 'Campo para indicar la cantidad de lineas para CE';
 
-- Steve 

ALTER TABLE operacion.inventario_em_adc ADD FLG_TIPO NUMBER(10) default 1;
COMMENT ON COLUMN operacion.inventario_em_adc.FLG_TIPO is 'Flag para indicar si es 1 tipo Masivo,2  Claro Empresa';

ALTER TABLE operacion.inventario_env_adc 
ADD flg_tipo NUMBER(10);
COMMENT ON COLUMN operacion.inventario_env_adc.flg_tipo 
is 'Flag para indicar si es tipo Masivo, Claro Empresa... tipos y estados FLG_TIPO_ADC';

ALTER TABLE operacion.inventario_env_adc_log_err 
ADD flg_tipo NUMBER(10);
COMMENT ON COLUMN operacion.inventario_env_adc_log_err.flg_tipo 
is 'Flag para indicar si es tipo Masivo, Claro Empresa... tipos y estados FLG_TIPO_ADC';

ALTER TABLE operacion.inventario_envio_eta_err  
ADD flg_tipo NUMBER(10);
COMMENT ON COLUMN operacion.inventario_envio_eta_err.flg_tipo 
is 'Flag para indicar si es tipo Masivo, Claro Empresa... tipos y estados FLG_TIPO_ADC';

/
