create table operacion.rotacion_auto_archivo_det
(
id_archivo number(22),
codigo_tarjeta varchar2(30)
)
tablespace OPERACION_DAT;

comment on table operacion.rotacion_auto_archivo_det is 'Tabla encargada de guardar los codigos de tarjeta de los archivos generados por la Rotación.';
comment on column operacion.rotacion_auto_archivo_det.id_archivo is 'Identificador del Archivo';
comment on column operacion.rotacion_auto_archivo_det.codigo_tarjeta is 'Tarjeta ubicada en el Archivo';