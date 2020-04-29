create table operacion.cab_atc_cort_archivo
(
id_archivo number(22),
nom_archivo varchar2(12),
estado_arch char(1),
cant_tarjetas number(5),
id_proceso number(22),
nro_intento number(1) default 0
)
tablespace OPERACION_DAT;

comment on table operacion.cab_atc_cort_archivo is 'Tabla encargada de guardar los datos de los archivos generados por la Activación/Corte.';
comment on column operacion.cab_atc_cort_archivo.id_archivo is 'Identificador del Archivo';
comment on column operacion.cab_atc_cort_archivo.nom_archivo is 'Nombre del archivo que contiene los codigos de tarjeta';
comment on column operacion.cab_atc_cort_archivo.estado_arch is 'Estado del proceso del Archivo';
comment on column operacion.cab_atc_cort_archivo.cant_tarjetas is 'Cantidad de Tarjetas guardadas en el archivo';
comment on column operacion.cab_atc_cort_archivo.id_proceso is 'Identificador del Proceso asociado';
comment on column operacion.cab_atc_cort_archivo.nro_intento is 'Numero de Intento';