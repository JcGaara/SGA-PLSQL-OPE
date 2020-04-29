DECLARE
  li_tipopedd NUMBER;
BEGIN
  INSERT INTO operacion.tipopedd
    (descripcion, abrev)
  VALUES
    ('Tarea Prediagnotico', 'TASKPREDIAG');
  BEGIN
    SELECT tipopedd
      INTO li_tipopedd
      FROM operacion.tipopedd
     WHERE descripcion = 'Tarea Prediagnotico'
       AND abrev = 'TASKPREDIAG';
  EXCEPTION
    WHEN no_data_found THEN
      li_tipopedd := 0;
    WHEN OTHERS THEN
      li_tipopedd := 0;
  END;
  IF li_tipopedd > 0 THEN
    INSERT INTO operacion.opedd
      (codigon, descripcion, abreviacion, tipopedd, codigon_aux)
    VALUES
      (10246,
       'CODIGO DE LA TAREA DE PREDIGNOSTICO',
       'TASKPREDIAG',
       li_tipopedd,
       0);
  END IF;
  COMMIT;
END;
/
