DECLARE
  ln_codmot    NUMBER;
  ln_tiptra    NUMBER;

BEGIN
--tiptrabajo
  SELECT MAX(tiptra) + 1 INTO ln_tiptra FROM operacion.tiptrabajo;
  
  INSERT INTO operacion.tiptrabajo 
     (tiptra, tiptrs, descripcion) 
  VALUES 
     (ln_tiptra,5,'WLL/SIAC - BAJA ADMINISTRATIVA');

--motot
  INSERT INTO operacion.motot
    (codmotot, descripcion, flgcom)
  VALUES
    ((SELECT MAX(t.codmotot) + 1 FROM operacion.motot t), 'WLL/SIAC - CAMBIO DE NUMERO', 0);

  INSERT INTO operacion.motot
    (codmotot, descripcion, flgcom)
  VALUES
    ((SELECT MAX(t.codmotot) + 1 FROM operacion.motot t), 'WLL/SIAC - CAMBIO DE TITULARIDAD', 0);
    
  INSERT INTO operacion.motot
    (codmotot, descripcion, flgcom)
  VALUES
    ((SELECT MAX(t.codmotot) + 1 FROM operacion.motot t), 'WLL/SIAC - FRAUDE', 0);
    
  INSERT INTO operacion.motot
    (codmotot, descripcion, flgcom)
  VALUES
    ((SELECT MAX(t.codmotot) + 1 FROM operacion.motot t), 'WLL/SIAC - POR REGULARIZACION', 0);
    
  INSERT INTO operacion.motot
    (codmotot, descripcion, flgcom)
  VALUES
    ((SELECT MAX(t.codmotot) + 1 FROM operacion.motot t), 'WLL/SIAC - PORT OUT', 0);
    
  INSERT INTO operacion.motot
    (codmotot, descripcion, flgcom)
  VALUES
    ((SELECT MAX(t.codmotot) + 1 FROM operacion.motot t), 'WLL/SIAC - CAMBIO DE PLAN', 0);  

  INSERT INTO operacion.motot
    (codmotot, descripcion, flgcom)
  VALUES
    ((SELECT MAX(t.codmotot) + 1 FROM operacion.motot t), 'WLL/SIAC - A SOLICITUD DE CLIENTE', 0);

  INSERT INTO operacion.motot
    (codmotot, descripcion, flgcom)
  VALUES
    ((SELECT MAX(t.codmotot) + 1 FROM operacion.motot t), 'HFC/SIAC - CAMBIO DE TITULARIDAD', 0);
    
  INSERT INTO operacion.motot
    (codmotot, descripcion, flgcom)
  VALUES
    ((SELECT MAX(t.codmotot) + 1 FROM operacion.motot t), 'HFC/SIAC - CAMBIO DE PLAN', 0);
    
  INSERT INTO operacion.motot
    (codmotot, descripcion, flgcom)
  VALUES
    ((SELECT MAX(t.codmotot) + 1 FROM operacion.motot t), 'HFC/SIAC - A SOLICITUD DE CLIENTE', 0);
    
  INSERT INTO operacion.motot
    (codmotot, descripcion, flgcom)
  VALUES
    ((SELECT MAX(t.codmotot) + 1 FROM operacion.motot t), 'HFC/SIAC - MIGRACION A CLARO EMPRESA', 0);
    
--mototxtiptra
  INSERT INTO operacion.mototxtiptra
    (tiptra, codmotot)
  VALUES
    (729,
     (SELECT codmotot
        FROM operacion.motot
       WHERE descripcion = 'HFC/SIAC - CAMBIO DE NUMERO'));

  INSERT INTO operacion.mototxtiptra
    (tiptra, codmotot)
  VALUES
    (729,
     (SELECT codmotot
        FROM operacion.motot
       WHERE descripcion = 'HFC/SIAC - CAMBIO DE TITULARIDAD'));

  INSERT INTO operacion.mototxtiptra
    (tiptra, codmotot)
  VALUES
    (729,
     (SELECT codmotot
        FROM operacion.motot
       WHERE descripcion = 'HFC/SIAC - FRAUDE'));

  INSERT INTO operacion.mototxtiptra
    (tiptra, codmotot)
  VALUES
    (729,
     (SELECT codmotot
        FROM operacion.motot
       WHERE descripcion = 'HFC/SIAC - POR REGULARIZACION'));
       
  INSERT INTO operacion.mototxtiptra
    (tiptra, codmotot)
  VALUES
    (729,
     (SELECT codmotot
        FROM operacion.motot
       WHERE descripcion = 'HFC/SIAC - PORT OUT'));              

  INSERT INTO operacion.mototxtiptra
    (tiptra, codmotot)
  VALUES
    (729,
     (SELECT codmotot
        FROM operacion.motot
       WHERE descripcion = 'HFC/SIAC - CAMBIO DE PLAN'));

--
  INSERT INTO operacion.mototxtiptra
    (tiptra, codmotot)
  VALUES
    (728,
     (SELECT codmotot
        FROM operacion.motot
       WHERE descripcion = 'HFC/SIAC - A SOLICITUD DE CLIENTE'));

  INSERT INTO operacion.mototxtiptra
    (tiptra, codmotot)
  VALUES
    (728,
     (SELECT codmotot
        FROM operacion.motot
       WHERE descripcion = 'HFC/SIAC - MIGRACION A CLARO EMPRESA'));
       
  UPDATE operacion.mototxtiptra
     SET tiptra = 729
   WHERE tiptra = 728
     AND codmotot =
         (SELECT codmotot
            FROM operacion.motot
           WHERE descripcion = 'HFC/SIAC - TRASLADO A OTRA PROVINCIA');

----
  INSERT INTO operacion.mototxtiptra
    (tiptra, codmotot)
  VALUES
    (ln_tiptra,
     (SELECT codmotot
        FROM operacion.motot
       WHERE descripcion = 'WLL/SIAC - CAMBIO DE NUMERO'));

  INSERT INTO operacion.mototxtiptra
    (tiptra, codmotot)
  VALUES
    (ln_tiptra,
     (SELECT codmotot
        FROM operacion.motot
       WHERE descripcion = 'WLL/SIAC - CAMBIO DE TITULARIDAD'));

  INSERT INTO operacion.mototxtiptra
    (tiptra, codmotot)
  VALUES
    (ln_tiptra,
     (SELECT codmotot
        FROM operacion.motot
       WHERE descripcion = 'WLL/SIAC - FRAUDE'));

  INSERT INTO operacion.mototxtiptra
    (tiptra, codmotot)
  VALUES
    (ln_tiptra,
     (SELECT codmotot
        FROM operacion.motot
       WHERE descripcion = 'WLL/SIAC - POR REGULARIZACION'));
       
  INSERT INTO operacion.mototxtiptra
    (tiptra, codmotot)
  VALUES
    (ln_tiptra,
     (SELECT codmotot
        FROM operacion.motot
       WHERE descripcion = 'WLL/SIAC - PORT OUT'));              

  INSERT INTO operacion.mototxtiptra
    (tiptra, codmotot)
  VALUES
    (ln_tiptra,
     (SELECT codmotot
        FROM operacion.motot
       WHERE descripcion = 'WLL/SIAC - CAMBIO DE PLAN'));

--
  INSERT INTO operacion.mototxtiptra
    (tiptra, codmotot)
  VALUES
    (757,
     (SELECT codmotot
        FROM operacion.motot
       WHERE descripcion = 'WLL/SIAC - A SOLICITUD DE CLIENTE'));

  UPDATE operacion.mototxtiptra
     SET tiptra = ln_tiptra
   WHERE tiptra = 757
     AND codmotot =
         (SELECT codmotot
            FROM operacion.motot
           WHERE descripcion = 'WLL/SIAC - TRASLADO A OTRA PROVINCIA');

  COMMIT;
END;
/
