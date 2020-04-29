create table operacion.det_atc_cort_manu_dth
(
id_proc_manu   number(22),
codigo_tarjeta varchar2(20),
flg_verif      char(1)
)
tablespace OPERACION_DAT;

-- Agregando Comentarios
comment on table operacion.det_atc_cort_manu_dth is 'Tabla de Detalle de la Activación/Corte Manual encargada de guardar la información del proceso.';
comment on column operacion.det_atc_cort_manu_dth.id_proc_manu is 'Identificador del Proceso Manul asociado';
comment on column operacion.det_atc_cort_manu_dth.codigo_tarjeta is 'Código de la Tarjeta del decodificador';
comment on column operacion.det_atc_cort_manu_dth.flg_verif is 'Flag de verificacion de Número de Tarjeta';