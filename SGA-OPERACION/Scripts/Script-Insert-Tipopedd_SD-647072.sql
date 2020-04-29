INSERT INTO operacion.tipopedd (
  tipopedd,
  descripcion,
  abrev )
VALUES (
  (select max(tipopedd) + 1 
     from operacion.tipopedd),
  'Tareas para Reporte de DEMO',
  'RPT_DEMO_TAREA');
COMMIT;
/
