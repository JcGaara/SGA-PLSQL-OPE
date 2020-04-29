INSERT INTO operacion.opedd ( 
  idopedd,
  codigoc, 
  
  descripcion, 
  abreviacion, 
  tipopedd, 
  codigon_aux)
VALUES (
	(select max(operacion.opedd.idopedd) + 1
     from operacion.opedd),
	'ACTIVO',
	
	'noc@desysweb.com',
	NULL,
	(select operacion.tipopedd.tipopedd 
     from operacion.tipopedd
    where abrev = 'NOTIFICA_INCIDENCIA'),
	NULL);
INSERT INTO operacion.opedd ( 
  idopedd,
  codigoc, 
  
  descripcion, 
  abreviacion, 
  tipopedd, 
  codigon_aux)
VALUES (
	(select max(operacion.opedd.idopedd) + 1
     from operacion.opedd),
	'UNICO',
	
	'service.desk@desysweb.com',
	NULL,
	(select operacion.tipopedd.tipopedd 
     from operacion.tipopedd
    where abrev = 'NOTIFICA_INCIDENCIA'),
	NULL);
COMMIT;
/
