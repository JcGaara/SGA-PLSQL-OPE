-- Actualizando tabla de carga de inventarios
alter table operacion.inventario_env_adc
add id_proceso number;
-- Actualizando tabla de Log
alter table operacion.inventario_env_adc_log_err
add id_proceso number;
-- Actualizando tabla de carga de inventarios para envio de WS
alter table operacion.inventario_envio_eta_err
add id_proceso number;