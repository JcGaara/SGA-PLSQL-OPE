INSERT INTO operacion.tipopedd (
  tipopedd,
  descripcion,
  abrev )
VALUES (
  (select max(tipopedd) + 1 
     from operacion.tipopedd),
	'Correo DTH',
	'MAIL_DTH');

INSERT INTO operacion.tipopedd (
  tipopedd,
  descripcion,
  abrev )
VALUES (
  (select max(tipopedd) + 1 
     from operacion.tipopedd),
	'Solucion TV Satelital',
	'TV_DTH');

INSERT INTO operacion.tipopedd (
  tipopedd,
  descripcion,
  abrev )
VALUES (
  (select max(tipopedd) + 1 
     from operacion.tipopedd),
	'Operaciones DTH',
	'OPE_DTH');

COMMIT;
/
