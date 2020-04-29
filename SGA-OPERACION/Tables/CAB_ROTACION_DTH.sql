create table operacion.cab_rotacion_dth
(
id_proceso    number(22),
cod_usua      varchar2(30),
direccion_ip  varchar2(39),
fecha_envio   date,
mes           char(2),
anho          char(4),
cant_tot_tarj number(5),
estado        char(1),
fecha_reg     date,
flg_p         number(1) default 0
)
tablespace operacion_dat;

comment on table operacion.cab_rotacion_dth is 'Tabla de cabecera de rotación encargada de guardar la información del proceso.';
comment on column operacion.cab_rotacion_dth.id_proceso is 'Identificador del Proceso';
comment on column operacion.cab_rotacion_dth.cod_usua is 'Código del usuario ejecutor';
comment on column operacion.cab_rotacion_dth.direccion_ip is 'Direción Ip del usuario';
comment on column operacion.cab_rotacion_dth.fecha_envio is 'Fecha del envio del proceso';
comment on column operacion.cab_rotacion_dth.mes is 'Mes de activación';
comment on column operacion.cab_rotacion_dth.anho is 'Año de activación';
comment on column operacion.cab_rotacion_dth.cant_tot_tarj is 'Cantidad total de tarjetas';
comment on column operacion.cab_rotacion_dth.estado is 'Estado del Proceso';
comment on column operacion.cab_rotacion_dth.fecha_reg is 'Fecha de Registro del Proceso Manual';
comment on column operacion.cab_rotacion_dth.flg_p is 'Flag que indica que se crearon los archivos: 1';