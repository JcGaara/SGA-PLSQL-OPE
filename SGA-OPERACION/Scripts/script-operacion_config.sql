DECLARE 
 LN_CANT NUMBER;
 LN_COUNT_1 NUMBER;
 LN_COUNT_2 NUMBER;
BEGIN 
  
   SELECT count(1)
     INTO LN_CANT
     FROM TIPOPEDD
    WHERE UPPER(ABREV) = 'ASIG_IP/MASK_SGA';
  
   IF LN_CANT = 0 THEN
    
      INSERT INTO TIPOPEDD
        (TIPOPEDD, DESCRIPCION, ABREV)
      VALUES
        ((SELECT MAX(TIPOPEDD) + 1 FROM TIPOPEDD),
         'ASIGNACIÓN DE IP SGA',
         'ASIG_IP/MASK_SGA');

      INSERT INTO OPEDD
        (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
      VALUES
        ((SELECT MAX(IDOPEDD) + 1 FROM OPEDD), '255.255.252.0'  , 22, 'Mascara IP 22', 'Mascara_IP', (SELECT MAX(TIPOPEDD)
                                                                                                        FROM TIPOPEDD
                                                                                                       WHERE UPPER(ABREV) = 'ASIG_IP/MASK_SGA'),NULL);
      INSERT INTO OPEDD
        (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
      VALUES
        ((SELECT MAX(IDOPEDD) + 1 FROM OPEDD), '255.255.255.128', 25, 'Mascara IP 25', 'Mascara_IP', (SELECT MAX(TIPOPEDD)
                                                                                                        FROM TIPOPEDD
                                                                                                       WHERE UPPER(ABREV) = 'ASIG_IP/MASK_SGA'),NULL);
      INSERT INTO OPEDD
        (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
      VALUES
        ((SELECT MAX(IDOPEDD) + 1 FROM OPEDD), '255.255.255.240', 28, 'Mascara IP 28', 'Mascara_IP', (SELECT MAX(TIPOPEDD)
                                                                                                        FROM TIPOPEDD
                                                                                                       WHERE UPPER(ABREV) = 'ASIG_IP/MASK_SGA'),NULL);
      INSERT INTO OPEDD
        (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
      VALUES
        ((SELECT MAX(IDOPEDD) + 1 FROM OPEDD), '255.255.255.248', 29, 'Mascara IP 29', 'Mascara_IP', (SELECT MAX(TIPOPEDD)
                                                                                                        FROM TIPOPEDD
                                                                                                       WHERE UPPER(ABREV) = 'ASIG_IP/MASK_SGA'),NULL);
      INSERT INTO OPEDD
        (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
      VALUES
        ((SELECT MAX(IDOPEDD) + 1 FROM OPEDD), '255.255.255.252', 30, 'Mascara IP 30', 'Mascara_IP', (SELECT MAX(TIPOPEDD)
                                                                                                        FROM TIPOPEDD
                                                                                                       WHERE UPPER(ABREV) = 'ASIG_IP/MASK_SGA'),NULL);

      INSERT INTO OPEDD
        (IDOPEDD,
         CODIGOC,
         CODIGON,
         DESCRIPCION,
         ABREVIACION,
         TIPOPEDD,
         CODIGON_AUX)
      VALUES
        ((SELECT MAX(IDOPEDD) + 1 FROM OPEDD),
         '192.168.1.0',
         NULL,
         '255.255.255.252',
         'IP/MASK_WAN',
         (SELECT MAX(TIPOPEDD)
            FROM TIPOPEDD
           WHERE UPPER(ABREV) = 'ASIG_IP/MASK_SGA'),
         1);
   END IF;
   
   SELECT count(1)
    INTO LN_CANT
    FROM TIPOPEDD
   WHERE UPPER(ABREV) = 'TRANS_TIPTRA_SGA';
   
   IF LN_CANT = 0 THEN 
       INSERT INTO TIPOPEDD
         (TIPOPEDD, DESCRIPCION, ABREV)
       VALUES
         ((SELECT MAX(TIPOPEDD) + 1 FROM TIPOPEDD),
          'TIPTRA TRANSACIONES FITEL',
          'TRANS_TIPTRA_SGA');
       
       INSERT INTO OPEDD
         (IDOPEDD,
          CODIGOC,
          CODIGON,
          DESCRIPCION,
          ABREVIACION,
          TIPOPEDD,
          CODIGON_AUX)
       VALUES
         ((SELECT MAX(IDOPEDD) + 1 FROM OPEDD),
          NULL,
          (SELECT TIPTRA
             FROM TIPTRABAJO
            WHERE DESCRIPCION = 'FITEL - INSTALACION'),
          'FITEL - INSTALACION',
           'ASIGNA_IP_CLIENTE',
          (SELECT MAX(TIPOPEDD)
             FROM TIPOPEDD
            WHERE UPPER(ABREV) = 'TRANS_TIPTRA_SGA'),
          1);
          
       INSERT INTO OPEDD
         (IDOPEDD,
          CODIGOC,
          CODIGON,
          DESCRIPCION,
          ABREVIACION,
          TIPOPEDD,
          CODIGON_AUX)
       VALUES
         ((SELECT MAX(IDOPEDD) + 1 FROM OPEDD),
          NULL,
          (SELECT TIPTRA
             FROM TIPTRABAJO
            WHERE DESCRIPCION = 'FITEL - INSTALACION'),
          'FITEL - INSTALACION',
           NULL,
          (SELECT MAX(TIPOPEDD)
             FROM TIPOPEDD
            WHERE UPPER(ABREV) = 'TRANS_TIPTRA_SGA'),
          NULL);
   END IF;
   COMMIT;
   
  /*INICIO INSERT OPEDD */
  SELECT COUNT(*)
    INTO LN_COUNT_2
    FROM OPERACION.OPEDD DET
   WHERE DET.TIPOPEDD IN
         (SELECT TIPOPEDD
            FROM OPERACION.TIPOPEDD
           WHERE UPPER(ABREV) = 'TIPEQU_FITEL_TLF');

  SELECT COUNT(*)
    INTO LN_COUNT_1
    FROM OPERACION.TIPOPEDD
   WHERE UPPER(ABREV) = 'TIPEQU_FITEL_TLF';

  IF LN_COUNT_1 = 0 THEN
    INSERT INTO OPERACION.TIPOPEDD
      (TIPOPEDD, DESCRIPCION, ABREV)
    VALUES
      ((SELECT MAX(TIPOPEDD) + 1 FROM TIPOPEDD),'EQUIPOS DE TELEFONIA FITEL', 'TIPEQU_FITEL_TLF');
    COMMIT;
  END IF;

  IF LN_COUNT_2 = 0 THEN
    INSERT INTO OPERACION.OPEDD
      (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
    VALUES
      ((SELECT MAX(IDOPEDD) + 1 FROM OPEDD),
	   '3',
       21958,
       'SIM CARD ',
       NULL,
       (SELECT TIPOPEDD
          FROM OPERACION.TIPOPEDD
         WHERE UPPER(ABREV) = 'TIPEQU_FITEL_TLF'),
       0);
    COMMIT;
  END IF;
  
    SELECT COUNT(*)
    INTO LN_CANT
    FROM OPERACION.OPEDD DET
   WHERE DET.TIPOPEDD IN
         (SELECT TIPOPEDD
            FROM OPERACION.TIPOPEDD
           WHERE UPPER(ABREV) = 'DESHATABCONTRATOS')
      AND DET.CODIGOC = 'E371542';

  IF LN_CANT = 0 THEN
    INSERT INTO OPERACION.OPEDD
      (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
    VALUES
      ((SELECT MAX(IDOPEDD) + 1 FROM OPEDD),
     'E371542',
       NULL,
       'Diego Alonso Jesus Guadalupe',
       NULL,
       (SELECT TIPOPEDD
          FROM OPERACION.TIPOPEDD
         WHERE UPPER(ABREV) = 'DESHATABCONTRATOS'),
       NULL);
    COMMIT;
  END IF;
  
  SELECT COUNT(*)
    INTO LN_CANT
    FROM OPERACION.OPEDD DET
   WHERE DET.TIPOPEDD IN
         (SELECT TIPOPEDD
            FROM OPERACION.TIPOPEDD
           WHERE UPPER(ABREV) = 'DESHATABCONTRATOS')
      AND DET.CODIGOC = 'E371672';

  IF LN_CANT = 0 THEN
    INSERT INTO OPERACION.OPEDD
      (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
    VALUES
      ((SELECT MAX(IDOPEDD) + 1 FROM OPEDD),
     'E371672',
       NULL,
       'Luis Antonio Marchena Nuñez',
       NULL,
       (SELECT TIPOPEDD
          FROM OPERACION.TIPOPEDD
         WHERE UPPER(ABREV) = 'DESHATABCONTRATOS'),
       NULL);
    COMMIT;
  END IF;
  
  SELECT COUNT(*)
    INTO LN_CANT
    FROM OPERACION.OPEDD DET
   WHERE DET.TIPOPEDD IN
         (SELECT TIPOPEDD
            FROM OPERACION.TIPOPEDD
           WHERE UPPER(ABREV) = 'DESHATABCONTRATOS')
      AND DET.CODIGOC = 'E371495';

  IF LN_CANT = 0 THEN
    INSERT INTO OPERACION.OPEDD
      (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
    VALUES
      ((SELECT MAX(IDOPEDD) + 1 FROM OPEDD),
     'E371495',
       NULL,
       'Jaime Brayan Avila Sandoval',
       NULL,
       (SELECT TIPOPEDD
          FROM OPERACION.TIPOPEDD
         WHERE UPPER(ABREV) = 'DESHATABCONTRATOS'),
       NULL);
    COMMIT;
  END IF;
  
  SELECT COUNT(*)
    INTO LN_CANT
    FROM OPERACION.OPEDD DET
   WHERE DET.TIPOPEDD IN
         (SELECT TIPOPEDD
            FROM OPERACION.TIPOPEDD
           WHERE UPPER(ABREV) = 'DESHATABCONTRATOS')
      AND DET.CODIGOC = 'E371606';

  IF LN_CANT = 0 THEN
    INSERT INTO OPERACION.OPEDD
      (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
    VALUES
      ((SELECT MAX(IDOPEDD) + 1 FROM OPEDD),
     'E371606',
       NULL,
       'Luciano Cardenas Romel',
       NULL,
       (SELECT TIPOPEDD
          FROM OPERACION.TIPOPEDD
         WHERE UPPER(ABREV) = 'DESHATABCONTRATOS'),
       NULL);
    COMMIT;
  END IF;
  
  /*FIN ROLLBACK OPEDD */
END;  
/
