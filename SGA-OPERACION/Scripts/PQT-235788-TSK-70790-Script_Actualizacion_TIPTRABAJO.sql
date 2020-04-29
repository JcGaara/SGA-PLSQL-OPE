update operacion.tiptrabajo set id_tipo_orden= (SELECT a.id_tipo_orden FROM operacion.tipo_orden_adc a WHERE a.cod_tipo_orden = 'CANT') where tiptra='5';
update operacion.tiptrabajo set id_tipo_orden= (SELECT a.id_tipo_orden FROM operacion.tipo_orden_adc a WHERE a.cod_tipo_orden = 'TPIM') where tiptra='394';
update operacion.tiptrabajo set id_tipo_orden= (SELECT a.id_tipo_orden FROM operacion.tipo_orden_adc a WHERE a.cod_tipo_orden = 'ANAI') where tiptra='404';
update operacion.tiptrabajo set id_tipo_orden= (SELECT a.id_tipo_orden FROM operacion.tipo_orden_adc a WHERE a.cod_tipo_orden = 'HFCM') where tiptra='412';
update operacion.tiptrabajo set id_tipo_orden= (SELECT a.id_tipo_orden FROM operacion.tipo_orden_adc a WHERE a.cod_tipo_orden = 'HFCM') where tiptra='418';
update operacion.tiptrabajo set id_tipo_orden= (SELECT a.id_tipo_orden FROM operacion.tipo_orden_adc a WHERE a.cod_tipo_orden = 'DTHI') where tiptra='419';
update operacion.tiptrabajo set id_tipo_orden= (SELECT a.id_tipo_orden FROM operacion.tipo_orden_adc a WHERE a.cod_tipo_orden = 'HFCM') where tiptra='427';
update operacion.tiptrabajo set id_tipo_orden= (SELECT a.id_tipo_orden FROM operacion.tipo_orden_adc a WHERE a.cod_tipo_orden = 'DTHI') where tiptra='485';
update operacion.tiptrabajo set id_tipo_orden= (SELECT a.id_tipo_orden FROM operacion.tipo_orden_adc a WHERE a.cod_tipo_orden = 'DTHP') where tiptra='497';
update operacion.tiptrabajo set id_tipo_orden= (SELECT a.id_tipo_orden FROM operacion.tipo_orden_adc a WHERE a.cod_tipo_orden = 'DTHM') where tiptra='498';
update operacion.tiptrabajo set id_tipo_orden= (SELECT a.id_tipo_orden FROM operacion.tipo_orden_adc a WHERE a.cod_tipo_orden = 'DTHP') where tiptra='617';
update operacion.tiptrabajo set id_tipo_orden= (SELECT a.id_tipo_orden FROM operacion.tipo_orden_adc a WHERE a.cod_tipo_orden = 'HFCI') where tiptra='658';
update operacion.tiptrabajo set id_tipo_orden= (SELECT a.id_tipo_orden FROM operacion.tipo_orden_adc a WHERE a.cod_tipo_orden = 'TPII') where tiptra='661';
update operacion.tiptrabajo set id_tipo_orden= (SELECT a.id_tipo_orden FROM operacion.tipo_orden_adc a WHERE a.cod_tipo_orden = 'HFCI') where tiptra='676';
update operacion.tiptrabajo set id_tipo_orden= (SELECT a.id_tipo_orden FROM operacion.tipo_orden_adc a WHERE a.cod_tipo_orden = 'HFCM') where tiptra='689';
update operacion.tiptrabajo set id_tipo_orden= (SELECT a.id_tipo_orden FROM operacion.tipo_orden_adc a WHERE a.cod_tipo_orden = 'HFCP') where tiptra='692';
update operacion.tiptrabajo set id_tipo_orden= (SELECT a.id_tipo_orden FROM operacion.tipo_orden_adc a WHERE a.cod_tipo_orden = 'HFCP') where tiptra='700';

COMMIT;
