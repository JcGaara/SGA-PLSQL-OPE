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
	'ACTIVO',
	370,
	'Baja por Anulacion de Paquete - WIMAX',
	NULL,
	(select operacion.tipopedd.tipopedd 
     from operacion.tipopedd
    where abrev = 'TIPTRA_ANULA_SOT_INST_WIMAX'),
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
	'UNICO',
	30,
	'Cantidad de días para anular Sot de Instalación WIMAX Rechazada',
	NULL,
	(select operacion.tipopedd.tipopedd 
     from operacion.tipopedd
    where abrev = 'DIAS_ANULA_SOT_INST_WIMAX'),
	NULL);
COMMIT;
/

