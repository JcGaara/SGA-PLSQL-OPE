DECLARE

  CURSOR c_mot IS
    SELECT *
      FROM operacion.motot m
     WHERE m.descripcion IN
           ('HFC/SIAC - CAMBIO DE TITULARIDAD',
            'HFC/SIAC - CAMBIO DE PLAN',
            'HFC/SIAC - A SOLICITUD DE CLIENTE',
            'HFC/SIAC - MIGRACION A CLARO EMPRESA',
            'WLL/SIAC - CAMBIO DE NUMERO',
            'WLL/SIAC - CAMBIO DE TITULARIDAD',
            'WLL/SIAC - FRAUDE',
            'WLL/SIAC - POR REGULARIZACION',
            'WLL/SIAC - PORT OUT',
            'WLL/SIAC - CAMBIO DE PLAN',
            'WLL/SIAC - A SOLICITUD DE CLIENTE');

BEGIN
  FOR x IN c_mot LOOP
    DELETE FROM operacion.mototxtiptra mt WHERE mt.codmotot = x.codmotot;
    DELETE FROM operacion.motot mt WHERE mt.codmotot = x.codmotot;
  END LOOP;

  DELETE FROM operacion.mototxtiptra mt
   WHERE mt.codmotot IN
         (SELECT codmotot
            FROM motot
           WHERE descripcion IN
                 ('HFC/SIAC - PORT OUT',
                  'HFC/SIAC - FRAUDE',
                  'HFC/SIAC - CAMBIO DE NUMERO',
                  'HFC/SIAC - POR REGULARIZACION'));

  DELETE FROM operacion.TIPTRABAJO T
   WHERE T.DESCRIPCION = 'WLL/SIAC - BAJA ADMINISTRATIVA';

  COMMIT;
END;
/