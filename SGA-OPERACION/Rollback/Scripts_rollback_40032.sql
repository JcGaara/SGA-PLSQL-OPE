-- Delete de Configuraciones
delete from OPERACION.parametro_det_adc t
where t.id_parametro = (select t.id_parametro
          from operacion.parametro_cab_adc t
         where t.abreviatura = 'integrar_fullstack');

delete from OPERACION.parametro_cab_adc t
where t.abreviatura = 'integrar_fullstack';

delete from OPERACION.ope_cab_xml t
where t.programa in ('XAServices_ToInstall_Cont','Services_ToInstall_Cont')
and t.metodo in ('XAServices_ToInstall_Cont','Services_ToInstall_Cont');

-- Delete de Columnas

-- Tabla OPERACION.tipo_orden_adc
alter table OPERACION.tipo_orden_adc drop column omitenfranja;

alter table OPERACION.tipo_orden_adc drop column flg_cuota_vip;


-- Tabla OPERACION.zona_adc
alter table OPERACION.ZONA_ADC drop column flag_zona;

-- Tabla OPERACION.agendamientochgest
alter table OPERACION.agendamientochgest drop column ticket_remedy;

-- Tabla OPERACION.inventario_em_adc
alter table OPERACION.inventario_em_adc drop column flg_config_puerto;

-- Tabla OPERACION.inventario_env_adc
alter table OPERACION.inventario_env_adc drop column flg_config_puerto;


-- Drop Table
drop table OPERACION.config_puertos;

-- Drop Secuencia
drop sequence OPERACION.seq_config_puertos; 

-- Drop Trigger
drop trigger OPERACION.t_config_puertos_bi;
