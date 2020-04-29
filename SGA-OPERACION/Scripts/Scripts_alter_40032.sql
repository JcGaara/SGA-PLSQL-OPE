-- Tabla OPERACION.TIPO_ORDEN_ADC
alter table OPERACION.tipo_orden_adc add omitenfranja  NUMBER(2) default 0;

alter table OPERACION.tipo_orden_adc add flg_cuota_vip NUMBER(1) default 1;

-- Add comments to the columns 
comment on column OPERACION.TIPO_ORDEN_ADC.omitenfranja
  is 'Cantidad de Franjas a filtrar a partir de la fecha del sistema para la consulta de capacidad';

comment on column OPERACION.TIPO_ORDEN_ADC.flg_cuota_vip
  is 'Flag para indicar si una cuota es VIP o no. 1 = Si , 2 = No';


-- Tabla OPERACION.zona_adc
alter table OPERACION.ZONA_ADC add flag_zona NUMBER(1) default 1;

comment on column OPERACION.ZONA_ADC.flag_zona
  is 'FLAG DE ZONA COMPLEJA
1 = NO COMPLEJA (DEFAULT) , 
2 = COMPLEJA
';

-- Tabla OPERACION.agendamientochgest
alter table OPERACION.agendamientochgest add ticket_remedy VARCHAR2(20);


comment on column OPERACION.AGENDAMIENTOCHGEST.ticket_remedy
  is 'Codigo del Ticket Remedy';


-- Tabla OPERACION.inventario_em_adc
alter table OPERACION.INVENTARIO_EM_ADC add flg_config_puerto VARCHAR2(1) ;

comment on column OPERACION.INVENTARIO_EM_ADC.flg_config_puerto
  is 'flag para indicar si es: 1 configura puertos, 0 sin confinguracion de puerto';


-- Tabla OPERACION.inventario_env_adc
alter table OPERACION.inventario_env_adc add flg_config_puerto varchar2(1) ;

comment on column OPERACION.inventario_env_adc.flg_config_puerto
  is 'flag para indicar si es: 1 configurado puertos, 0 sin confinguracion de puerto';
