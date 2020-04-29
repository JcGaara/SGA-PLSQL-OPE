DECLARE
  v_cont_tipo_o     INTEGER;
  v_cont_o          INTEGER;
BEGIN

  SELECT COUNT(*) INTO v_cont_tipo_o FROM tipopedd WHERE abrev = 'PREFIJO_DECO';
  SELECT COUNT(*) INTO v_cont_o FROM tipopedd t  INNER JOIN  opedd o ON t.tipopedd = o.tipopedd AND t.abrev = 'PREFIJO_DECO'  ;
   
  -- si NO HAY tipopedd.abrev = "PREFIJO_DECO"
  IF v_cont_tipo_o = 0  THEN   
     INSERT INTO tipopedd(tipopedd, descripcion, abrev)
     VALUES(NULL, 'PREFIJO ARION', 'PREFIJO_DECO');
     COMMIT;

     INSERT INTO opedd(idopedd, codigoc, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
     VALUES(NULL, 'TMX', NULL, 'PREFIJO ARION', NULL,(SELECT MAX(tipopedd)  FROM tipopedd WHERE abrev = 'PREFIJO_DECO') , NULL);
     COMMIT;
  END IF;
  --si HAY tipopedd.abrev = "PREFIJO_DECO" y NO presenta registro en opedd
  IF v_cont_tipo_o > 0 AND v_cont_o = 0 THEN   
     INSERT INTO opedd(idopedd, codigoc, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
     VALUES(NULL, 'TMX', NULL, 'PREFIJO ARION', NULL,(SELECT MAX(tipopedd)  FROM tipopedd WHERE abrev = 'PREFIJO_DECO') , NULL);
     COMMIT;
  END IF;
END;
