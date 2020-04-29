----TIPO y SUB TIPO de ORDEN ----falta que configuren en produccion

--Script para cambio de direccion solo Traslado Externo
--Tarea Validar Servicios Traslado Externo
insert into operacion.opedd(IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select max(idopedd)+1 from operacion.opedd), null, (select tiptra from operacion.tiptrabajo where descripcion = 'FTTH/SIAC - TRASLADO EXTERNO'),
			'FTTH/SIAC - TRASLADO EXTERNO', 'TRASLADO_EXTERNO_FTTH', (select TIPOPEDD from operacion.tipopedd where abrev = 'CAMBIO_DIRECCION_TE'), 1);
			
--Tarea Asignacion Numero Traslado Externo
insert into operacion.opedd(IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select max(idopedd)+1 from operacion.opedd), 'FLUJO_EXT', (select tiptra from operacion.tiptrabajo where descripcion = 'FTTH/SIAC - TRASLADO EXTERNO'),
			'FTTH/SIAC - TRASLADO EXTERNO', 'SOLUCION_HFC_SIAC_TIPTRA', (select TIPOPEDD from operacion.tipopedd where abrev = 'CONFSERVADICIONAL'), 10);

--Tarea Activación/Desactivación Servicios AUTO
--POS
insert into operacion.opedd(IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select max(idopedd)+1 from operacion.opedd), null, (select tiptra from operacion.tiptrabajo where descripcion = 'FTTH/SIAC - TRASLADO EXTERNO'),
			'FTTH/SIAC - TRASLADO EXTERNO', null, 402, null);
insert into operacion.opedd(IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select max(idopedd)+1 from operacion.opedd), null, (select tiptra from operacion.tiptrabajo where descripcion = 'FTTH/SIAC - TRASLADO INTERNO'),
			'FTTH/SIAC - TRASLADO INTERNO', null, 402, null);
			

--Script para el combo tipo de trabajo	
--Validar el campo CODIGON_AUX segun el tipo de orden ADC		
insert into operacion.opedd(IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select max(idopedd)+1 from operacion.opedd), 1, (select tiptra from operacion.tiptrabajo where descripcion = 'FTTH/SIAC - TRASLADO INTERNO'),
			'FTTH/SIAC - TRASLADO INTERNO', 'TRASLADO_INTERNO_FTTH', (select TIPOPEDD from operacion.tipopedd where abrev = 'TIPO_TRANS_SIAC'), 12);
insert into operacion.opedd(IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select max(idopedd)+1 from operacion.opedd), 1, (select tiptra from operacion.tiptrabajo where descripcion = 'FTTH/SIAC - TRASLADO EXTERNO'),
			'FTTH/SIAC - TRASLADO EXTERNO', 'TRASLADO_EXTERNO_FTTH', (select TIPOPEDD from operacion.tipopedd where abrev = 'TIPO_TRANS_SIAC'), 13);
			
---Para obtener el tipo de trabajo PQ_INT_PRYOPE
insert into operacion.opedd(IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select max(idopedd)+1 from operacion.opedd), 'TRASLADO_EXT_SIAC_FTTH', (select tiptra from operacion.tiptrabajo where descripcion = 'FTTH/SIAC - TRASLADO EXTERNO'),
			'Traslado Externo SIAC FTTH', 'SOLUCION_HFC_SIAC_TIPTRA', (select TIPOPEDD from operacion.tipopedd where abrev = 'CONFSERVADICIONAL'), null);
	

commit;