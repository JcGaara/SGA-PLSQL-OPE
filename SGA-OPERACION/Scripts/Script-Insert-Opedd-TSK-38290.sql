INSERT INTO operacion.opedd ( 
  idopedd,
  codigoc, 
  codigon, 
  descripcion, 
  abreviacion, 
  tipopedd, 
  codigon_aux)
VALUES (
	(select max(operacion.opedd.idopedd) + 1
     from operacion.opedd),
	null,
	16,
	'Calidad',
	'REP-CAL',
	(select operacion.tipopedd.tipopedd 
     from operacion.tipopedd
    where abrev = 'TIP_INCIDENCE'),
	NULL);
INSERT INTO operacion.opedd ( 
  idopedd,
  codigoc, 
  codigon, 
  descripcion, 
  abreviacion, 
  tipopedd, 
  codigon_aux)
VALUES (
	(select max(operacion.opedd.idopedd) + 1
     from operacion.opedd),
	null,
	20,
	'Reporte Equipos',
	'NOC-EQU',
	(select operacion.tipopedd.tipopedd 
     from operacion.tipopedd
    where abrev = 'TIP_INCIDENCE'),
	NULL);
COMMIT;
/
