create table operacion.cab_atc_cort_manu_dth
(
id_proc_manu number(22),
estado       number(1),            
descripcion  varchar2(100),     
tipo_proc    char(1),        
id_paquete   number(8),         
fecha_ejec   date,           
motivo       varchar2(100),  
tipo_cliente char(1),        
direccion_ip varchar2(39),   
cod_usua     varchar2(30),   
fecha_reg    date,           
tip_ac       char(1),
flg_p        number(1) default 0
)
tablespace OPERACION_DAT;

comment on table operacion.cab_atc_cort_manu_dth is 'Tabla de cabecera de Activaci�n/Corte Manual encargada de guardar la informaci�n del proceso.';
comment on column operacion.cab_atc_cort_manu_dth.id_proc_manu is 'Identificador del Proceso Manual';
comment on column operacion.cab_atc_cort_manu_dth.estado is 'Estado del Proceso Manual';
comment on column operacion.cab_atc_cort_manu_dth.descripcion is 'Descripci�n del Proceso Manual';
comment on column operacion.cab_atc_cort_manu_dth.tipo_proc is 'Tipo de Proceso: Activacion - 1 / Corte - 2';
comment on column operacion.cab_atc_cort_manu_dth.id_paquete is 'Identificador de Paquete asociado';
comment on column operacion.cab_atc_cort_manu_dth.fecha_ejec is 'Fecha de Ejecuci�n';
comment on column operacion.cab_atc_cort_manu_dth.motivo is 'Motivo del Proceso Manual';
comment on column operacion.cab_atc_cort_manu_dth.tipo_cliente is 'Tipo de Cliente: Pre-Pago - 1 / Post-Pago - 2';
comment on column operacion.cab_atc_cort_manu_dth.direccion_ip is 'Direcci�n IP';
comment on column operacion.cab_atc_cort_manu_dth.cod_usua is 'C�digo del Usuario Ejecutor';
comment on column operacion.cab_atc_cort_manu_dth.fecha_reg is 'Fecha de Registro del Proceso Manual';
comment on column operacion.cab_atc_cort_manu_dth.tip_ac is 'Tipo de Activaci�n/Corte por Bouquet (B) o por Paquete(P)';
comment on column operacion.cab_atc_cort_manu_dth.flg_p is 'Flag que indica que se crearon los archivos: 1';