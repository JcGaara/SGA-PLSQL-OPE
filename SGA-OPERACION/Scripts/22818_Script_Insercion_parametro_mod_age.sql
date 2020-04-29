insert into operacion.parametro_cab_adc(descripcion,abreviatura,estado) values('MENSAJES DE FLAG DE AGENDAMIENTO OBLIGATORIO','M_FLG_AOBLG','1');
insert into operacion.parametro_det_adc
(codigoc,descripcion,abreviatura,estado,id_parametro) 
values 
('El servicio de agendamiento en línea no responde. Favor de generar un caso al BACK OFFICE para su atención',
 'Could not access remote service at',
 'MSJ_DISP_ETA',
 '1',
 (select ID_PARAMETRO from operacion.parametro_cab_adc where abreviatura='M_FLG_AOBLG'));

 insert into operacion.parametro_det_adc
(codigoc,descripcion,abreviatura,estado,id_parametro) 
values 
('Por favor seleccionar la fecha y franja horaria del Agendamiento en Línea',
 'Mensaje de agendamiento obligatorio de Etadirect',
 'MSJ_OBLIG_ETA',
 '1',
 (select ID_PARAMETRO from operacion.parametro_cab_adc where abreviatura='M_FLG_AOBLG'));

 insert into operacion.parametro_det_adc
(codigoc,descripcion,abreviatura,estado,id_parametro) 
values 
('El servicio de agendamiento en línea no responde, debido a inconvenientes con la configuración de planos o zonas de trabajo',
 'Unable to determine work zone for given fields',
 'MSJ_CONF_BKT',
 '1',
 (select ID_PARAMETRO from operacion.parametro_cab_adc where abreviatura='M_FLG_AOBLG'));

 insert into operacion.parametro_det_adc
(codigoc,descripcion,abreviatura,estado,id_parametro) 
values 
('Por favor seleccionar el subtipo de orden',
 'Mensaje de seleccion de subtipo de orden',
 'MSJ_SEL_ST',
 '1',
 (select ID_PARAMETRO from operacion.parametro_cab_adc where abreviatura='M_FLG_AOBLG'));
commit;

alter table operacion.matriz_tystipsrv_tiptra_adc
add flgaobliga number(1) default 1;
comment on column operacion.matriz_tystipsrv_tiptra_adc.flgaobliga is 'Flag. de Obligacion de Agendamiento';

update operacion.matriz_tystipsrv_tiptra_adc
   set flgaobliga=1;
commit;