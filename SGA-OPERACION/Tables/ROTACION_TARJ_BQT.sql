create table operacion.rotacion_tarj_bqt
(
codigo_tarjeta varchar2(30),
bouquet varchar2(3)
)
TABLESPACE OPERACION_DAT
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE operacion.rotacion_tarj_bqt IS 'Tabla encargada de guardar la informacion de los codigos de tarjeta y bouquets para el proceso de Rotacion';
COMMENT ON COLUMN operacion.rotacion_tarj_bqt.codigo_tarjeta IS 'Codigo de Tarjeta';
COMMENT ON COLUMN operacion.rotacion_tarj_bqt.bouquet IS 'Bouquet asociado';