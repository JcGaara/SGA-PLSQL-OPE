create table operacion.cab_inventario_env_adc
(
id_proceso number,
tipo_proceso number(1),
estado_proceso number(1) default 0,
archivo varchar2(500),
usureg varchar2(30) default user,
fecreg date default sysdate,
ipreg varchar2(30),
usumod varchar2(30) default user,
fecmod date default sysdate,
ipmod varchar2(30)
) tablespace operacion_dat;

comment on table operacion.cab_inventario_env_adc is 'Tabla de cabecera del Proceso de Inventario para Oracle Field Service';
comment on column operacion.cab_inventario_env_adc.id_proceso is 'Identificador del Proceso';
comment on column operacion.cab_inventario_env_adc.tipo_proceso is 'Tipo de Proceso, 2: Incremental, 1: Full';
comment on column operacion.cab_inventario_env_adc.estado_proceso is 'Estado de Proceso';
comment on column operacion.cab_inventario_env_adc.archivo is 'Ruta de Archivo';
comment on column operacion.cab_inventario_env_adc.usureg is 'Usuario de Registro';
comment on column operacion.cab_inventario_env_adc.fecreg is 'Fecha de Registro';
comment on column operacion.cab_inventario_env_adc.ipreg is 'IP de Registro';
comment on column operacion.cab_inventario_env_adc.usumod is 'Usuario de Modificacion';
comment on column operacion.cab_inventario_env_adc.fecmod is 'Fecha de Modificacion';
comment on column operacion.cab_inventario_env_adc.ipmod is 'IP de Modificacion';