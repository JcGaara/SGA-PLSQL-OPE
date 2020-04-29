delete from operacion.opedd where CODIGON = (select tiptra from operacion.tiptrabajo where descripcion = 'FTTH/SIAC - TRASLADO EXTERNO')
	and TIPOPEDD = (select TIPOPEDD from operacion.tipopedd where abrev = 'CAMBIO_DIRECCION_TE');
delete from operacion.opedd where CODIGON = (select tiptra from operacion.tiptrabajo where descripcion = 'FTTH/SIAC - TRASLADO EXTERNO')
	and TIPOPEDD = (select TIPOPEDD from operacion.tipopedd where abrev = 'CONFSERVADICIONAL') and codigoc = 'FLUJO_EXT';
delete from operacion.opedd where CODIGON = (select tiptra from operacion.tiptrabajo where descripcion = 'FTTH/SIAC - TRASLADO EXTERNO')
	and TIPOPEDD = 402;
delete from operacion.opedd where CODIGON = (select tiptra from operacion.tiptrabajo where descripcion = 'FTTH/SIAC - TRASLADO INTERNO')
	and TIPOPEDD = 402;
delete from operacion.opedd where CODIGON = (select tiptra from operacion.tiptrabajo where descripcion = 'FTTH/SIAC - TRASLADO EXTERNO')
	and TIPOPEDD = (select TIPOPEDD from operacion.tipopedd where abrev = 'TIPO_TRANS_SIAC');
delete from operacion.opedd where CODIGON = (select tiptra from operacion.tiptrabajo where descripcion = 'FTTH/SIAC - TRASLADO INTERNO')
	and TIPOPEDD = (select TIPOPEDD from operacion.tipopedd where abrev = 'TIPO_TRANS_SIAC');
delete from operacion.opedd where CODIGON = (select tiptra from operacion.tiptrabajo where descripcion = 'FTTH/SIAC - TRASLADO EXTERNO')
	and TIPOPEDD = (select TIPOPEDD from operacion.tipopedd where abrev = 'CONFSERVADICIONAL') and codigoc = 'TRASLADO_EXT_SIAC_FTTH';
	
commit;