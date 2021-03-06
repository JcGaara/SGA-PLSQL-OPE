DECLARE
  L_IDCAB    NUMBER;
  V_TIPOPEDD NUMBER;
BEGIN
  SELECT IDCAB
    INTO L_IDCAB
    FROM OPERACION.OPE_CAB_XML
   WHERE PROGRAMA = 'PreregistroDatosCCL';
  DELETE FROM OPERACION.OPE_DET_XML WHERE IDCAB = L_IDCAB;
  DELETE FROM OPERACION.OPE_CAB_XML WHERE IDCAB = L_IDCAB;

  SELECT TIPOPEDD
    INTO V_TIPOPEDD
    FROM OPERACION.TIPOPEDD
   WHERE ABREV = 'REINT_REG_CCL';
  DELETE FROM OPERACION.OPEDD WHERE TIPOPEDD = V_TIPOPEDD;
  DELETE FROM OPERACION.TIPOPEDD WHERE TIPOPEDD = V_TIPOPEDD;
  
  COMMIT;
END;
/