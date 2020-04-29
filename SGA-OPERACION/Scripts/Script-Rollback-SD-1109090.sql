--Eliminar tipos y estados
DELETE  FROM operacion.opedd WHERE tipopedd IN (SELECT a.tipopedd FROM operacion.tipopedd a WHERE upper(a.abrev) = 'PLAT_JANUS')
AND abreviacion = 'URL_JANUS_METODO';

--Eliminar campo agregado
alter table OPERACION.INT_TELEFONIA_LOG drop column WS_XML;

COMMIT;
