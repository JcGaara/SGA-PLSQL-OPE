INSERT INTO operacion.tipopedd (
  tipopedd,
  descripcion,
  abrev )
VALUES (
  (select max(tipopedd) + 1 
     from operacion.tipopedd),
  'Notificar incidencias',
  'NOTIFICA_INCIDENCIA');
commit;
/
