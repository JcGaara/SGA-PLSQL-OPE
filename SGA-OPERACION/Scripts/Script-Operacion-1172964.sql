--1. CREACION DE TIPOS Y ESTADOS
  INSERT INTO tipopedd (descripcion, abrev)
  VALUES ( 'Estado de Linea en BSCS', 'ESTADO_LINEA_BSCS');
  
    INSERT INTO OPERACION.OPEDD( codigon, descripcion, tipopedd, abreviacion)
  VALUES (5,'Estado de la Linea Generado en BSCS', (SELECT a.tipopedd FROM operacion.tipopedd a WHERE upper(a.abrev) = 'ESTADO_LINEA_BSCS'), 'ESTADO_GENERADA');
 
UPDATE tareawfdef
   SET tipo = 0
WHERE wfdef = 1024
   AND descripcion = 'Activacion - Lineas Control';

UPDATE tareawfdef
   SET tipo = 0
WHERE wfdef = 1129
   AND descripcion = 'Traslado Externo - Lineas Control';
   
UPDATE tareawfdef
   SET tipo = 0
WHERE wfdef = 1046
   AND descripcion = 'Suspension en Plataforma Telefonica Janus';
   
UPDATE tareawfdef
   SET tipo = 0
WHERE wfdef = 1047
   AND descripcion = 'Reconexion en Plataforma Telefónica Janus';

COMMIT;
