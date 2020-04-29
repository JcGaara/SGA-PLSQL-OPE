--1.- SCRIPT PARAMETROS DE ESTADOS DE AGENDAMIENTO
DECLARE
  ln_tipatc NUMBER;

BEGIN

  SELECT MAX(tipopedd) INTO ln_tipatc FROM operacion.tipopedd;

  INSERT INTO operacion.tipopedd
    (tipopedd, descripcion, abrev)
  VALUES
    (ln_tipatc + 1, 'ESTADOS DE AGENDAMIENTO', 'ESTAGE_AGENDA');

  INSERT INTO operacion.opedd
    (codigon, abreviacion, tipopedd)
  VALUES
    (16, 'EN AGENDA', ln_tipatc + 1);

  COMMIT;

END;
/
