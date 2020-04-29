DECLARE
  LN_CANT NUMBER;

BEGIN

  SELECT COUNT(1)
    INTO LN_CANT
    FROM OPERACION.OPE_CAB_XML CAB, OPERACION.OPE_PARAM_XML DET
   WHERE CAB.IDCAB = DET.IDCAB
     AND CAB.nombrexml =  'CreateRequestClienteAltaCBIO';

  IF LN_CANT > 0 THEN
    DELETE FROM OPERACION.OPE_PARAM_XML DET
     WHERE DET.IDCAB =
           (SELECT IDCAB
              FROM OPERACION.OPE_CAB_XML
             WHERE nombrexml =  'CreateRequestClienteAltaCBIO');
    COMMIT;
  END IF;

  SELECT COUNT(1)
    INTO LN_CANT
    FROM OPERACION.OPE_CAB_XML CAB, SGACRM.FT_TIPTRA_ESCENARIO TIP
   WHERE CAB.IDCAB = TIP.IDCAB
     AND CAB.nombrexml =  'CreateRequestClienteAltaCBIO';

  IF LN_CANT > 0 THEN
    DELETE FROM SGACRM.FT_TIPTRA_ESCENARIO TIP
     WHERE TIP.IDCAB =
           (SELECT IDCAB
              FROM OPERACION.OPE_CAB_XML
             WHERE nombrexml =  'CreateRequestClienteAltaCBIO');
    COMMIT;
  END IF;

  SELECT COUNT(1)
    INTO LN_CANT
    FROM OPERACION.OPE_CAB_XML
   WHERE nombrexml =  'CreateRequestClienteAltaCBIO';

  IF LN_CANT > 0 THEN
    DELETE FROM OPERACION.OPE_CAB_XML
     WHERE nombrexml =  'CreateRequestClienteAltaCBIO';
    COMMIT;
  END IF;
  
  SELECT count(1)
    INTO LN_CANT
    FROM TIPOPEDD
   WHERE UPPER(ABREV) = 'TRANS_TIPTRA_APIS_CBIOS';
  
  IF LN_CANT > 0 THEN
    
   DELETE FROM OPEDD WHERE TIPOPEDD IN (SELECT TIPOPEDD FROM TIPOPEDD WHERE UPPER(ABREV) = 'TRANS_TIPTRA_APIS_CBIOS');
   DELETE FROM TIPOPEDD WHERE UPPER(ABREV) = 'TRANS_TIPTRA_APIS_CBIOS';
   
    
  END IF; 

  COMMIT;
END;
/
  DROP TABLE OPERACION.OPE_PARAM_XML;
  DROP TABLE OPERACION.SGAT_BSCSIX_CBIO;
  DROP PROCEDURE OPERACION.SGASS_ENV_MDC_SGA_CBIO;
