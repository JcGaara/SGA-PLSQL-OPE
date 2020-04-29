INSERT INTO operacion.tipopedd (
  tipopedd,
  descripcion,
  abrev )
VALUES (
  (select max(tipopedd) + 1 
     from operacion.tipopedd),
  'Tipo de Incidencia.',
  'TIP_INCIDENCE');
COMMIT;
/
