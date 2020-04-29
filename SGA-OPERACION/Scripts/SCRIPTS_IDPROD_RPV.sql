DECLARE
  LN_COUNT NUMBER;
BEGIN
  
-- CONSTANTE IDSOLUCION 236

	SELECT COUNT(*)
	  INTO LN_COUNT
	  FROM OPERACION.CONSTANTE C
	 WHERE C.CONSTANTE = 'SOLUCION_RPV';


	IF LN_COUNT = 0 THEN
		INSERT INTO OPERACION.CONSTANTE
		  (CONSTANTE, DESCRIPCION, TIPO, VALOR, OBS)
		VALUES
		  ('SOLUCION_RPV',
		   'ID SOLUCION RPV',
		   'N',
		   (SELECT MAX(IDSOLUCION)
			  FROM SOLUCIONES
			 WHERE SOLUCION = 'RPV Claro Negocios'),
		   NULL);
		COMMIT;
	END IF;
  
-- TIPO SRV 0098
	
	SELECT COUNT(*)
	  INTO LN_COUNT
	  FROM TIPOPEDD T, OPEDD O
	 WHERE T.TIPOPEDD = O.TIPOPEDD
	   AND T.ABREV = 'I_S_APROB_SEF_TEMP'
	   AND O.CODIGOC = (select tipsrv from tystipsrv where dsctipsrv = 'Red Claro Negocios');

	IF LN_COUNT = 0 THEN
		INSERT INTO OPERACION.OPEDD
		  (IDOPEDD, CODIGOC, DESCRIPCION, TIPOPEDD)
		VALUES
		  ((SELECT MAX(IDOPEDD) + 1 FROM OPEDD),
		   (select tipsrv from tystipsrv where dsctipsrv = 'Red Claro Negocios'),
		   'Red Claro Negocios',
		   (SELECT  MAX(TIPOPEDD)
			  FROM OPERACION.TIPOPEDD
			 WHERE UPPER(ABREV) = 'I_S_APROB_SEF_TEMP'));
		COMMIT;
	END IF;
  
-- ID PRODUCTO
	
	SELECT COUNT(*)
	  INTO LN_COUNT
	  FROM TIPOPEDD T, OPEDD O
	 WHERE T.TIPOPEDD = O.TIPOPEDD
	   AND T.ABREV = 'IDPRODUCTOCONTINGENCIA'
	   AND O.CODIGON = (select idproducto from producto where descripcion = 'Red Claro Negocios - Acceso');

	IF LN_COUNT = 0 THEN
		INSERT INTO OPERACION.OPEDD
		  (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, TIPOPEDD)
		VALUES
		  ((SELECT MAX(IDOPEDD) + 1 FROM OPEDD),
		   'INT',
       (select idproducto from producto where descripcion = 'Red Claro Negocios - Acceso'),
		   'INTERNET ID PRODUCTO',
		   (SELECT TIPOPEDD
			  FROM OPERACION.TIPOPEDD
			 WHERE UPPER(ABREV) = 'IDPRODUCTOCONTINGENCIA'));
		COMMIT;
	END IF;

END;
/