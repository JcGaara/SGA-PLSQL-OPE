--1.- SCRIPT PARAMETROS DE UPDATE_DIR_CONVERGENTE
DECLARE
  ln_tipatc NUMBER;

BEGIN

  SELECT MAX(tipopedd) INTO ln_tipatc FROM operacion.tipopedd;

  INSERT INTO operacion.tipopedd
    (tipopedd, descripcion, abrev)
  VALUES
    (ln_tipatc + 1, 'ACTUALIZAR DIRECCION.', 'UPDATE_DIR_CONVERGENTE');

  INSERT INTO operacion.opedd
    (descripcion, abreviacion, tipopedd)
  VALUES
    ('polol@globalhitss.com', 'UPDATE_SUPPORT', ln_tipatc + 1);

  COMMIT;

END;
/
