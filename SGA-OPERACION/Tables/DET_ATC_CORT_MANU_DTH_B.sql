create table operacion.det_atc_cort_manu_dth_b
(
id_proc_manu   number(22),
bouquet number(8)
)
tablespace OPERACION_DAT;

comment on table operacion.det_atc_cort_manu_dth_b is 'Tabla de Detalle de la Activación/Corte Manual encargada de guardar los bouquets asociados al Proceso.';
comment on column operacion.det_atc_cort_manu_dth_b.id_proc_manu is 'Identificador del Proceso Manul asociado';
comment on column operacion.det_atc_cort_manu_dth_b.bouquet is 'Bouquet asociado al Proceso Manual';