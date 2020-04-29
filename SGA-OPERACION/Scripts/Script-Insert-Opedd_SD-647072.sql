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
	1,
	488,
	'Instalación - NOC',
	NULL,
	(select operacion.tipopedd.tipopedd 
     from operacion.tipopedd
    where abrev = 'RPT_DEMO_TAREA'),
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
	2,
	299,
	'Activación/Desactivación del servicio',
	NULL,
	(select operacion.tipopedd.tipopedd 
     from operacion.tipopedd
    where abrev = 'RPT_DEMO_TAREA'),
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
	3,
	369,
	'Upgrade del servicio - NOC',
	NULL,
	(select operacion.tipopedd.tipopedd 
     from operacion.tipopedd
    where abrev = 'RPT_DEMO_TAREA'),
	NULL);
COMMIT;
/
