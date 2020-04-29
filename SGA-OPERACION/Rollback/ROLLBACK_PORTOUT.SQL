DECLARE LN_COUNT NUMBER;

BEGIN
  LN_COUNT := 0;
  ------------------------------------------------------------------------------------------
  -- ELIMINAR PARAMETROS PARA GENERACION DE CONTRATO BSCS 
  ------------------------------------------------------------------------------------------  
  ------------------------------------------------------------------------------------------
  -- ELIMINAR PARAMETRO SNCODE_DECO
  ------------------------------------------------------------------------------------------   
  SELECT COUNT(*)
    INTO LN_COUNT
    FROM OPEDD
   WHERE ABREVIACION ='SNCODE_DECO'
   AND TIPOPEDD = (SELECT TIPOPEDD FROM TIPOPEDD WHERE ABREV='BSCS_CONTRATO');
        
  IF LN_COUNT > 0 THEN  
    DELETE FROM OPEDD
    WHERE ABREVIACION ='SNCODE_DECO'
    AND TIPOPEDD = (SELECT TIPOPEDD FROM TIPOPEDD WHERE ABREV='BSCS_CONTRATO');
    COMMIT;
  END IF;
  ------------------------------------------------------------------------------------------
  -- ELIMINAR PARAMETRO PLAN_LTE_SISACT
  ------------------------------------------------------------------------------------------ 
  SELECT COUNT(*)
    INTO LN_COUNT
    FROM OPEDD
   WHERE ABREVIACION ='PLAN_LTE_SISACT'
   AND TIPOPEDD = (SELECT TIPOPEDD FROM TIPOPEDD WHERE ABREV='BSCS_CONTRATO');
          
  IF LN_COUNT > 0 THEN   
   DELETE FROM OPEDD
   WHERE ABREVIACION ='PLAN_LTE_SISACT'
   AND TIPOPEDD = (SELECT TIPOPEDD FROM TIPOPEDD WHERE ABREV='BSCS_CONTRATO');             
    COMMIT;
  END IF;
  ------------------------------------------------------------------------------------------
  -- ELIMINAR PARAMETRO PLAN
  ------------------------------------------------------------------------------------------ 
  SELECT COUNT(*)
    INTO LN_COUNT
    FROM OPEDD
   WHERE ABREVIACION ='PLAN'
   AND TIPOPEDD = (SELECT TIPOPEDD FROM TIPOPEDD WHERE ABREV='BSCS_CONTRATO');
          
  IF LN_COUNT > 0 THEN   
   DELETE FROM OPEDD
   WHERE ABREVIACION ='PLAN'
   AND TIPOPEDD = (SELECT TIPOPEDD FROM TIPOPEDD WHERE ABREV='BSCS_CONTRATO');
    COMMIT;
  END IF;    
------------------------------------------------------------------------------------------
-- ELIMINAR PARAMETRO TRAMA_COLUMN
------------------------------------------------------------------------------------------ 
  SELECT COUNT(*)
    INTO LN_COUNT
    FROM OPEDD
   WHERE ABREVIACION ='TRAMA_COLUMN'
   AND TIPOPEDD = (SELECT TIPOPEDD FROM TIPOPEDD WHERE ABREV='CONF_ALTA_PORTOUT')
   AND CODIGOC ='IDSRV_SISACT';
          
  IF LN_COUNT > 0 THEN  
   DELETE FROM OPEDD
   WHERE ABREVIACION ='TRAMA_COLUMN'
   AND TIPOPEDD = (SELECT TIPOPEDD FROM TIPOPEDD WHERE ABREV='CONF_ALTA_PORTOUT')
   AND CODIGOC = 'IDSRV_SISACT';
   COMMIT;
  END IF;  
  --
  SELECT COUNT(*)
    INTO LN_COUNT
    FROM OPEDD
   WHERE ABREVIACION ='TRAMA_COLUMN'
   AND TIPOPEDD = (SELECT TIPOPEDD FROM TIPOPEDD WHERE ABREV='CONF_ALTA_PORTOUT')
   AND CODIGOC ='CANTIDAD';
          
  IF LN_COUNT > 0 THEN  
   DELETE FROM OPEDD
   WHERE ABREVIACION ='TRAMA_COLUMN'
   AND TIPOPEDD = (SELECT TIPOPEDD FROM TIPOPEDD WHERE ABREV='CONF_ALTA_PORTOUT')
   AND CODIGOC = 'CANTIDAD';
   COMMIT;
  END IF; 
------------------------------------------------------------------------------------------
-- ELIMINAR PARAMETRO CONF_ALTA_PORTOUT -  GRUPO_PRINC
------------------------------------------------------------------------------------------   
  SELECT COUNT(*)
    INTO LN_COUNT
    FROM OPEDD
   WHERE ABREVIACION ='GRUPO_PRINC'
   AND TIPOPEDD = (SELECT TIPOPEDD FROM TIPOPEDD WHERE ABREV='CONF_ALTA_PORTOUT');
   
   DELETE FROM OPEDD
   WHERE ABREVIACION ='GRUPO_PRINC'
   AND TIPOPEDD = (SELECT TIPOPEDD FROM TIPOPEDD WHERE ABREV='CONF_ALTA_PORTOUT');
   COMMIT;  
END;
/
