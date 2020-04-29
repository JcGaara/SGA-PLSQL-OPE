DECLARE
  v_cont_tipo_o     INTEGER;
BEGIN

  SELECT COUNT(*) INTO v_cont_tipo_o FROM tipopedd WHERE abrev = 'PREFIJO_DECO';
  
  IF v_cont_tipo_o > 0 THEN   
     DELETE FROM opedd WHERE tipopedd = (SELECT MAX(tipopedd)  FROM tipopedd WHERE abrev = 'PREFIJO_DECO');
     COMMIT;

     DELETE FROM tipopedd WHERE tipopedd = (SELECT MAX(tipopedd)  FROM tipopedd WHERE abrev = 'PREFIJO_DECO');
     COMMIT;
  END IF;
END;
