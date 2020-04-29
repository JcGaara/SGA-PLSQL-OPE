declare
 v_tiptra operacion.tiptrabajo.tiptra%TYPE;
begin

insert into operacion.tipo_orden_adc(ID_TIPO_ORDEN, COD_TIPO_ORDEN, DESCRIPCION, TIPO_TECNOLOGIA, ESTADO, TIPO_SERVICIO, FLG_TIPO, OMITENFRANJA, FLG_CUOTA_VIP)
values ((select MAX(ID_TIPO_ORDEN)+1 from operacion.tipo_orden_adc),'FTTHM', 'FTTH MANTENIMIENTO', 'FTTH', 1, 'Mantenimiento', 1, 0, 1);

insert into operacion.subtipo_orden_adc(ID_SUBTIPO_ORDEN, COD_SUBTIPO_ORDEN, DESCRIPCION, TIEMPO_MIN, ID_WORK_SKILL, ID_TIPO_ORDEN, ESTADO)
values ((select MAX(ID_SUBTIPO_ORDEN)+1 from operacion.subtipo_orden_adc),'FTTHMM', 'MANTENIMIENTO FTTH', 60, 10, (select id_tipo_orden from operacion.tipo_orden_adc where descripcion = 'FTTH MANTENIMIENTO'), 1);

insert into operacion.tiptrabajo
    (tiptra,
     tiptrs,
     descripcion,
     flgcom,
     flgpryint,
     sotfacturable,
     agenda,
     corporativo,
     selpuntossot,
	 id_tipo_orden)
  values
    ((select max(tiptra) + 1 from tiptrabajo),
     1,
     'FTTH - MANTENIMIENTO',
     0,
     0,
     0,
     0,
     0,
     0,
	 (select id_tipo_orden from operacion.tipo_orden_adc where descripcion = 'FTTH MANTENIMIENTO'))
	returning tiptra into v_tiptra; 
	
insert into OPERACION.OPEDD (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select tiptra from operacion.tiptrabajo where descripcion = 'FTTH - MANTENIMIENTO'),
         (select tiptra from operacion.tiptrabajo where descripcion = 'FTTH - MANTENIMIENTO'),
         'SIAC-FTTH-ORDEN DE VISITA',
         'TIPO_TRANS_SIAC',
         (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'TIPO_TRANS_SIAC'),
         1);

insert into operacion.opedd(CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ((SELECT wfdef FROM opewf.wfdef where descripcion = 'MANTENIMIENTO FTTH'),
         'MANTENIMIENTO FTTH', 'wf_migracion_plano', 
        (select tipopedd from operacion.tipopedd t where t.abrev = 'migracion_plano'));		 

commit;
end;
/