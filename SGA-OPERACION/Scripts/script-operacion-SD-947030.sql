INSERT INTO operacion.tipopedd
  (descripcion, abrev)
VALUES
  ('Soluciones de Paq Inalab. Fact', 'DTH_AUTOMATICO_FAC');
COMMIT;

INSERT INTO operacion.opedd
  (codigon, descripcion, tipopedd)
VALUES
  (67, 'TV Satelital', (SELECT MAX(tipopedd) FROM operacion.tipopedd));
COMMIT;

INSERT INTO operacion.opedd
  (codigon, descripcion, tipopedd)
VALUES
  (120,
   'TV Satelital Postpago',
   (SELECT MAX(tipopedd) FROM operacion.tipopedd));
COMMIT;