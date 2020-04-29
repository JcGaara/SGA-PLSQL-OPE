DECLARE LN_COUNT NUMBER;

BEGIN
  LN_COUNT := 0;
  ------------------------------------------------------------------------------------------
  -- ELIMINAR PARAMETRO VAL_SINGLE_PORTOUT
  ------------------------------------------------------------------------------------------ 
  SELECT COUNT(*)
    INTO LN_COUNT
    FROM OPEDD
   WHERE ABREVIACION ='VAL_SINGLE_PORTOUT'
   AND TIPOPEDD = (SELECT TIPOPEDD FROM TIPOPEDD WHERE ABREV='PORT_OUT');
          
  IF LN_COUNT > 0 THEN  
    DELETE FROM OPEDD
    WHERE ABREVIACION ='VAL_SINGLE_PORTOUT'
    AND TIPOPEDD = (SELECT TIPOPEDD FROM TIPOPEDD WHERE ABREV='PORT_OUT');
    COMMIT;
  END IF;       .
  ------------------------------------------------------------------------------------------
  -- ELIMINAR PARAMETRO CONTRATA POR DEFECTO
  ------------------------------------------------------------------------------------------ 
  SELECT COUNT(*)
    INTO LN_COUNT
    FROM OPEDD
   WHERE ABREVIACION ='CONTR_DEFECTO'
   AND TIPOPEDD = (SELECT TIPOPEDD FROM TIPOPEDD WHERE ABREV='CONF_ALTA_PORTOUT');
          
  IF LN_COUNT > 0 THEN  
    DELETE FROM OPEDD
    WHERE ABREVIACION ='CONTR_DEFECTO'
    AND TIPOPEDD = (SELECT TIPOPEDD FROM TIPOPEDD WHERE ABREV='CONF_ALTA_PORTOUT');
    COMMIT;
  END IF;     
END;
/