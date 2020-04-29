GRANT EXECUTE ON SALES.PQ_MIGRACION TO USRSISACT;

INSERT INTO tipopedd
  (descripcion, abrev)
VALUES
  ('TIPO DE TRABAJO', 'TIPTRABAJO');
--
INSERT INTO tipopedd
  (descripcion, abrev)
VALUES
  ('MIGRACION', 'MIGRACION');
--
INSERT INTO opedd
  (codigon, descripcion, tipopedd, abreviacion)
VALUES
  (680,
   'BAJA ADMINISTRATIVA',
   (SELECT c.tipopedd FROM tipopedd c WHERE UPPER(c.abrev) = 'MIGRACION'),
   'BAJA_ADM');
--
INSERT INTO opedd
  (codigon, descripcion, tipopedd, abreviacion)
VALUES
  (658,
   'VENTA SISACT',
   (SELECT c.tipopedd FROM tipopedd c WHERE UPPER(c.abrev) = 'TIPTRABAJO'),
   'SISACT');
--
INSERT INTO opedd
  (codigon, descripcion, tipopedd, abreviacion)
VALUES
  (676,
   'PORTABILIDAD',
   (SELECT c.tipopedd FROM tipopedd c WHERE UPPER(c.abrev) = 'TIPTRABAJO'),
   'PORTA');
--
INSERT INTO opedd
  (codigon, descripcion, tipopedd, abreviacion)
VALUES
  (678,
   'MIGRACION A SISACT',
   (SELECT c.tipopedd FROM tipopedd c WHERE UPPER(c.abrev) = 'TIPTRABAJO'),
   'MIGRA');
--
INSERT INTO opedd
  (codigon, descripcion, tipopedd, abreviacion)
VALUES
  (679,
   'MIGRACION A SISACT + PORTABILIDAD',
   (SELECT c.tipopedd FROM tipopedd c WHERE UPPER(c.abrev) = 'TIPTRABAJO'),
   'MIGRA_PORTA');

COMMIT;