create table operacion.rot_paq_postpago
(
sncode varchar2(22),
bouquet varchar2(4)
)
tablespace OPERACION_DAT;

COMMENT ON TABLE operacion.rot_paq_postpago IS 'Tabla encargada de guardar la relacion del Grupo de Bouquet de la BSCS y el Bouquet';
COMMENT ON COLUMN operacion.rot_paq_postpago.sncode IS 'Codigo de Grupo de Bouquet asociado creado en la base de datos de la BSCS';
COMMENT ON COLUMN operacion.rot_paq_postpago.bouquet IS 'Numero de Bouquet';