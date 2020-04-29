INSERT INTO operacion.tipopedd (
  tipopedd,
  descripcion,
  abrev )
VALUES (
  (select max(tipopedd) + 1 
     from operacion.tipopedd),
  'Tipo Trabajo Inst. WIMAX',
  'TIPTRA_ANULA_SOT_INST_WIMAX');
INSERT INTO operacion.tipopedd (
  tipopedd,
  descripcion,
  abrev )
VALUES (
  (select max(tipopedd) + 1 
     from operacion.tipopedd),
  'Días para anular SOT INST WIMA',
  'DIAS_ANULA_SOT_INST_WIMAX');
COMMIT;
/
