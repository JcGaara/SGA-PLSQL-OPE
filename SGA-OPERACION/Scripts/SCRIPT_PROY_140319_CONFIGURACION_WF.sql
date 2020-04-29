DECLARE
  LN_COUNT  NUMBER;
  LN_TIPTRA_A NUMBER;
  LN_TIPTRA_D NUMBER;
BEGIN
  LN_COUNT := 0;
  
  ------------------------------------------------------------------------------------------
  -- INSERCION DEL TIPTRABAJO - ACTIVAR                                        0
  ------------------------------------------------------------------------------------------
  SELECT T.TIPTRA
    INTO LN_TIPTRA_A 
    FROM TIPTRABAJO T
   WHERE T.DESCRIPCION = 'HFC - ACTIVAR BONO';
  ------------------------------------------------------------------------------------------
  -- INSERCION DEL TIPTRABAJO  ACTIVAR                                       0
  ------------------------------------------------------------------------------------------
  INSERT INTO CUSBRA.BR_SEL_WF (TIPTRA, FLGMT, CODUSU, FECUSU, TIPSRV, PRE_PROC, VALOR, IDCAMPANHA, TIPMOTOT, FLG_SELECT)
  VALUES (LN_TIPTRA_A, NULL, 'EASTULLE', SYSDATE, '0061', NULL, NULL, NULL, NULL, 0);
    ------------------------------------------------------------------------------------------
  -- INSERCION DEL TIPTRABAJO - DESACTIVAR                                        0
  ------------------------------------------------------------------------------------------
  SELECT T.TIPTRA
    INTO LN_TIPTRA_D 
    FROM TIPTRABAJO T
   WHERE T.DESCRIPCION = 'HFC - DESACTIVAR BONO';
  ------------------------------------------------------------------------------------------
  -- INSERCION DEL TIPTRABAJO  DESACTIVAR                                       0
  ------------------------------------------------------------------------------------------
  INSERT INTO CUSBRA.BR_SEL_WF (TIPTRA, FLGMT, CODUSU, FECUSU, TIPSRV, PRE_PROC, VALOR, IDCAMPANHA, TIPMOTOT, FLG_SELECT)
  VALUES (LN_TIPTRA_D, NULL, 'EASTULLE', SYSDATE, '0061', NULL, NULL, NULL, NULL, 0);
 ------------------------------------------------------------------------------------------
  -- INSERCION DEL WORKFLOW                                         1
  ------------------------------------------------------------------------------------------
    LN_COUNT := 0;
  SELECT COUNT(*)
    INTO LN_COUNT
    FROM OPEWF.WFDEF
   WHERE DESCRIPCION = 'HFC - CAMBIO DE VELOCIDAD (BONO)';
  IF LN_COUNT = 0 THEN
    
    INSERT INTO OPEWF.WFDEF
      (WFDEF, ESTADO, CLASEWF, DESCRIPCION, VERSION)
    VALUES
      ((SELECT MAX(WFDEF) + 1 FROM OPEWF.WFDEF),
       1,
       0,
       'HFC - CAMBIO DE VELOCIDAD (BONO)',
       1);
  END IF;
    ------------------------------------------------------------------------------------------
  -- UPDATE AL CAMPO WFDEF DE LA TABLA CUSBRA.BR_SEL_WF 
  ------------------------------------------------------------------------------------------
     UPDATE CUSBRA.BR_SEL_WF SET WFDEF = (SELECT WFDEF FROM WFDEF WHERE  DESCRIPCION='HFC - CAMBIO DE VELOCIDAD (BONO)')
    WHERE TIPTRA=(SELECT TIPTRA FROM TIPTRABAJO WHERE DESCRIPCION = 'HFC - ACTIVAR BONO');
     ------------------------------------------------------------------------------------------
  -- UPDATE AL CAMPO WFDEF DE LA TABLA CUSBRA.BR_SEL_WF
  ------------------------------------------------------------------------------------------
     UPDATE CUSBRA.BR_SEL_WF SET WFDEF = (SELECT WFDEF FROM WFDEF WHERE  DESCRIPCION='HFC - CAMBIO DE VELOCIDAD (BONO)')
    WHERE TIPTRA=(SELECT TIPTRA FROM TIPTRABAJO WHERE DESCRIPCION = 'HFC - DESACTIVAR BONO');
  ------------------------------------------------------------------------------------------
  -- INSERCION DE TAREA INCOGNITO            2
  ------------------------------------------------------------------------------------------
  LN_COUNT := 0;
  SELECT COUNT(*)
    INTO LN_COUNT
    FROM OPEWF.TAREADEF T
   WHERE T.DESCRIPCION = 'BONO - INCOGNITO';
  IF LN_COUNT = 0 THEN
    INSERT INTO OPEWF.TAREADEF
      (TAREADEF,
       TIPO,
       DESCRIPCION,
       PRE_PROC,
       CUR_PROC,
       CHG_PROC,
       POS_PROC,
       PRE_MAIL,
       POS_MAIL,
       FLG_FT,
       FLG_WEB,
       SQL_VAL)
    VALUES
      ((SELECT MAX(TD.TAREADEF) + 1 FROM OPEWF.TAREADEF TD),
       0,
       'BONO - INCOGNITO',
       NULL, -- TAREA PRE
       NULL,
       NULL,
       'OPERACION.PQ_GESTIONA_BONO.SGASI_IDENTIFICAR_ACCION_BONO', -- TAREA POST
       NULL,
       NULL,
       0,
       NULL,
       NULL);
  END IF;
  ------------------------------------------------------------------------------------------
  -- INSERCION DE TAREA DE SGA                        2
  ------------------------------------------------------------------------------------------
  LN_COUNT := 0;
  SELECT COUNT(*)
    INTO LN_COUNT
    FROM OPEWF.TAREADEF T
   WHERE T.DESCRIPCION = 'BONO - SGA';
  IF LN_COUNT = 0 THEN
    INSERT INTO OPEWF.TAREADEF
      (TAREADEF,
       TIPO,
       DESCRIPCION,
       PRE_PROC,
       CUR_PROC,
       CHG_PROC,
       POS_PROC,
       PRE_MAIL,
       POS_MAIL,
       FLG_FT,
       FLG_WEB,
       SQL_VAL)
    VALUES
      ((SELECT MAX(TD.TAREADEF) + 1 FROM OPEWF.TAREADEF TD),
       0,
       'BONO - SGA',
       NULL, -- TAREA PRE
       NULL,
       NULL,
       'OPERACION.PQ_GESTIONA_BONO.SGASU_ASIGNAR_ESTADOS_SERV', -- TAREA POST
       NULL,
       NULL,
       0,
       NULL,
       NULL);
  END IF;
 
  ------------------------------------------------------------------------------------------
  -- ACTIVACION BONO INCOGNITO              3
  ------------------------------------------------------------------------------------------
  LN_COUNT := 0;
  SELECT COUNT(*)
    INTO LN_COUNT
    FROM OPEWF.TAREAWFDEF T
   WHERE T.DESCRIPCION = 'BONO - INCOGNITO';
  IF LN_COUNT = 0 THEN
      INSERT INTO OPEWF.TAREAWFDEF
        (TAREA, DESCRIPCION, TIPO, AREA, WFDEF, TAREADEF)
      VALUES
        (F_GET_ID_TAREAWFDEF(),
         'BONO - INCOGNITO',
         2,
         427, --SE CAMBIO
         (SELECT WFDEF
            FROM OPEWF.WFDEF
           WHERE DESCRIPCION = 'HFC - CAMBIO DE VELOCIDAD (BONO)'),
         (SELECT TAREADEF
            FROM OPEWF.TAREADEF
           WHERE DESCRIPCION = 'BONO - INCOGNITO'));
  END IF;
  ------------------------------------------------------------------------------------------
  -- ACTIVACIÓN BONO - SGA                                       3
  ------------------------------------------------------------------------------------------
  LN_COUNT := 0;
  SELECT COUNT(*)
    INTO LN_COUNT
    FROM OPEWF.TAREAWFDEF T
   WHERE T.DESCRIPCION = 'BONO - SGA';
  IF LN_COUNT = 0 THEN
      INSERT INTO OPEWF.TAREAWFDEF
        (TAREA, DESCRIPCION, TIPO, AREA, WFDEF, TAREADEF)
      VALUES
        (F_GET_ID_TAREAWFDEF(),
         'BONO - SGA',
         2, --CAMBIADO
         427, --CAMBIADO
         (SELECT WFDEF
            FROM OPEWF.WFDEF
           WHERE DESCRIPCION = 'HFC - CAMBIO DE VELOCIDAD (BONO)'),
         (SELECT TAREADEF
            FROM OPEWF.TAREADEF
           WHERE DESCRIPCION = 'BONO - SGA'));
  END IF;
----------------------------------------------------------------------------------------
-- SECUENCIA DE INCOGNITO
UPDATE OPEWF.TAREAWFDEF
   SET POS_TAREAS =
       (SELECT TAREA
          FROM OPEWF.TAREAWFDEF
         WHERE WFDEF =
               (SELECT WFDEF
                  FROM OPEWF.WFDEF
                 WHERE DESCRIPCION = 'HFC - CAMBIO DE VELOCIDAD (BONO)')
           AND TAREADEF =
               (SELECT TAREADEF
                  FROM OPEWF.TAREADEF
                 WHERE DESCRIPCION =
                       'BONO - SGA')),
       PLAZO      = 1,
       ORDEN      = 0
 WHERE TAREA =
       (SELECT TAREA
          FROM OPEWF.TAREAWFDEF
         WHERE TAREADEF =
               (SELECT TAREADEF
                  FROM OPEWF.TAREADEF
                 WHERE DESCRIPCION = 'BONO - INCOGNITO')
           AND WFDEF =
               (SELECT WFDEF
                  FROM OPEWF.WFDEF
                 WHERE DESCRIPCION = 'HFC - CAMBIO DE VELOCIDAD (BONO)'));
----------------------------------------------------------------------------------
-- SECUENCIA DE SGA
UPDATE OPEWF.TAREAWFDEF
   SET PRE_TAREAS =
       (SELECT TAREA
          FROM OPEWF.TAREAWFDEF
         WHERE WFDEF =
               (SELECT WFDEF
                  FROM OPEWF.WFDEF
                 WHERE DESCRIPCION = 'HFC - CAMBIO DE VELOCIDAD (BONO)')
           AND TAREADEF = (SELECT TAREADEF
            FROM OPEWF.TAREADEF
           WHERE DESCRIPCION = 'BONO - INCOGNITO')),
       PLAZO=NULL,
       ORDEN      = 0
 WHERE TAREA =
       (SELECT TAREA
          FROM OPEWF.TAREAWFDEF
         WHERE TAREADEF = (SELECT TAREADEF
            FROM OPEWF.TAREADEF
           WHERE DESCRIPCION = 'BONO - SGA')
           AND WFDEF =
               (SELECT WFDEF
                  FROM OPEWF.WFDEF
                 WHERE DESCRIPCION = 'HFC - CAMBIO DE VELOCIDAD (BONO)'));
       COMMIT;

END;
/
