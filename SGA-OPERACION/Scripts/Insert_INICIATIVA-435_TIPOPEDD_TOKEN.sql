DECLARE
  V_TIPOPEDD NUMBER;
  V_OPEDD NUMBER;
BEGIN
  SELECT MAX(tipopedd) + 1 INTO V_TIPOPEDD FROM operacion.tipopedd;
  SELECT MAX(idopedd) + 1 INTO V_OPEDD FROM operacion.opedd;

  INSERT INTO OPERACION.TIPOPEDD (TIPOPEDD, DESCRIPCION, ABREV)
  VALUES (V_TIPOPEDD, 'No_Valida_Token', 'No_Valida_Token');
  
  INSERT INTO OPERACION.OPEDD (IDOPEDD, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  VALUES (V_OPEDD, 
(SELECT IDCAB
      FROM OPERACION.OPE_CAB_XML
     WHERE PROGRAMA = 'PreregistroDatosCCL'), 'PreregistroDatosCCL', 'PreregistroDatosCCL', V_TIPOPEDD, 0);
 
 INSERT INTO OPERACION.TIPOPEDD (TIPOPEDD, DESCRIPCION, ABREV)
  VALUES (V_TIPOPEDD + 1 , 'ALQ. EQUIPOS CLARO TV', 'ALQ_OTT');

 INSERT INTO OPERACION.OPEDD (IDOPEDD, CODIGOC, DESCRIPCION, TIPOPEDD, CODIGON_AUX)
  VALUES (V_OPEDD + 1 , 'AEEL', 'Alquiler de Equipos de Claro TV', V_TIPOPEDD + 1, 0);
 
  COMMIT;
END;
/
