INSERT INTO operacion.tipopedd (
  tipopedd,
  descripcion,
  abrev )
VALUES (
  (select max(tipopedd) + 1 
     from operacion.tipopedd),
  'Codigo asoc. seguimiento CNOC',
  'ASOCIATED_INCIDENCE_CNOC');
  
INSERT INTO operacion.tipopedd (
  tipopedd,
  descripcion,
  abrev )
VALUES (
  (select max(tipopedd) + 1 
     from operacion.tipopedd),
  'Tipo Trabajo Inter CNOC',
  'ASOCIATED_INC_INTER_CNOC');
COMMIT;

