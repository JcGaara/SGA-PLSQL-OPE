create table operacion.rotacion_datos
(
id_proceso number(22),
codcli varchar2(10),
codinssrv number(22),
fecini date,
fecfinvig date,
estado varchar2(2),
tarjeta varchar2(20),
codsrv varchar2(22),
tipo_servicio char(1)
)
TABLESPACE OPERACION_DAT
NOLOGGING;
COMMENT ON TABLE operacion.rotacion_datos IS 'Tabla encargada de guardar la informacion de los codigos de tarjeta y bouquets para el proceso de Rotacion';
COMMENT ON COLUMN operacion.rotacion_datos.id_proceso IS 'Identificador de Proceso';
COMMENT ON COLUMN operacion.rotacion_datos.codcli IS 'Codigo de Cliente, Para Postpago se almacenara el CUSTOMER_ID';
COMMENT ON COLUMN operacion.rotacion_datos.codinssrv IS 'Codigo de Instancia de Servicio, Para Postpago se almacenara el CO_ID';
COMMENT ON COLUMN operacion.rotacion_datos.fecini IS 'Fecha de inicio';
COMMENT ON COLUMN operacion.rotacion_datos.fecfinvig IS 'Fecha de fin de vigencia';
COMMENT ON COLUMN operacion.rotacion_datos.estado IS 'Estado de la recarga';
COMMENT ON COLUMN operacion.rotacion_datos.tarjeta IS 'Codigo de Tarjeta';
COMMENT ON COLUMN operacion.rotacion_datos.codsrv IS 'Codigo de Servicio asociado, Para Postpago se almacenara el SNCODE';
COMMENT ON COLUMN migracion.rotacion_datos.tipo_servicio IS 'Tipo de Servicio: 1 - Postpago, 2 - Prepago con Recarga, 3  - Prepago sin Recarga, 4 - Demo, 5 - Promocion';