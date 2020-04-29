create table operacion.det_atc_cort_archivo
(
id_archivo number(22),
codigo_tarjeta char(11)
)
tablespace OPERACION_DAT;

comment on table operacion.det_atc_cort_archivo is 'Tabla encargada de guardar los codigos de tarjeta de los archivos generados por la Activación/Corte.';
comment on column operacion.det_atc_cort_archivo.id_archivo is 'Identificador del Archivo';
comment on column operacion.det_atc_cort_archivo.codigo_tarjeta is 'Tarjeta que esta en el Archivo';