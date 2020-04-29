 --Eliminar tipos y estados
DELETE FROM operacion.opedd WHERE tipopedd IN (SELECT a.tipopedd FROM operacion.tipopedd a WHERE upper(a.abrev) = 'ESTADO_LINEA_BSCS');
DELETE FROM operacion.tipopedd WHERE tipopedd IN (SELECT a.tipopedd FROM operacion.tipopedd a WHERE upper(a.abrev) = 'ESTADO_LINEA_BSCS');

UPDATE tareawfdef
   SET tipo = 2
WHERE wfdef = 1024
   AND descripcion = 'Activacion - Lineas Control';

UPDATE tareawfdef
   SET tipo = 2
WHERE wfdef = 1129
   AND descripcion = 'Traslado Externo - Lineas Control';
   
UPDATE tareawfdef
   SET tipo = 2
WHERE wfdef = 1046
   AND descripcion = 'Suspension en Plataforma Telefonica Janus';
   
UPDATE tareawfdef
   SET tipo = 2
WHERE wfdef = 1047
   AND descripcion = 'Reconexion en Plataforma Telefónica Janus';

COMMIT;
