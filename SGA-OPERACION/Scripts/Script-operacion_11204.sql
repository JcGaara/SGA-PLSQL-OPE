DECLARE
  l_tipopedd tipopedd.tipopedd%TYPE;
BEGIN

  INSERT INTO tipopedd
    (descripcion, abrev)
  VALUES
    ('Claro Tv HFC ', 'TV_HFC');
 
  SELECT t.tipopedd
    INTO l_tipopedd
    FROM tipopedd t
   WHERE t.abrev = 'TV_HFC';

  INSERT INTO opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
  VALUES
    (NULL, 768, 'Claro TV Digital', NULL, l_tipopedd, NULL);

  INSERT INTO opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
  VALUES
    (NULL, 770, 'Claro TV Analogico', NULL, l_tipopedd, NULL);

COMMIT;
END;
