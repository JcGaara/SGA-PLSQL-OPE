DECLARE
  LN_VAL      NUMBER;
BEGIN
 
  SELECT COUNT(1)
    INTO LN_VAL
    FROM OPERACION.TIPOPEDD T
   WHERE T.ABREV = 'ESTSERV_PORTOUT';
   
  IF LN_VAL > 0 THEN
	DELETE FROM OPERACION.TIPOPEDD T WHERE T.ABREV = 'ESTSERV_PORTOUT';  
    DELETE FROM OPERACION.OPEDD where CODIGON = 1 AND DESCRIPCION = 'Activo' AND ABREVIACION = 'ACTIVO';
	DELETE FROM OPERACION.OPEDD where CODIGON = 2 AND DESCRIPCION = 'Suspendido' AND ABREVIACION = 'SUSPENDIDO';
	DELETE FROM OPERACION.OPEDD where CODIGON = 3 AND DESCRIPCION = 'Cancelado' AND ABREVIACION = 'CANCELADO';  
    COMMIT;
  END IF;

END;
/