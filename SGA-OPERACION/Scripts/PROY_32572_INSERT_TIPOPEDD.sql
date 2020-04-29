---INSERT CABECERA Y DETALLE :  TIPOPEDD - OPEDD
DECLARE
v_contador             INTEGER:=0;        
v_cod_tipopedd         NUMBER(6);
v_cod_idopedd          NUMBER(6);
BEGIN

LOOP
  EXIT WHEN v_contador = 1;
  v_contador := v_contador + 1;

  SELECT MAX(tipopedd)+1 INTO v_cod_tipopedd FROM OPERACION.TIPOPEDD;

  IF v_contador=1 THEN 
     
      ---cabecera
      INSERT INTO OPERACION.TIPOPEDD (TIPOPEDD,DESCRIPCION,ABREV)
      VALUES(v_cod_tipopedd,'Tipo de Evaluacion para AR', 'AR_TIPO_EVAL');
      
      ---detalle               
      insert into operacion.opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
      values ((SELECT MAX(IDOPEDD)+1 FROM OPERACION.OPEDD), '1', 1, 'Costo de RED Total', 'CRT', v_cod_tipopedd, null);

      insert into operacion.opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
      values ((SELECT MAX(IDOPEDD)+1 FROM OPERACION.OPEDD), '2', 2, 'Costo de RED Incremental', 'CRI', v_cod_tipopedd, null); 
      
      insert into operacion.opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
      values ((SELECT MAX(IDOPEDD)+1 FROM OPERACION.OPEDD), '3', 3, 'Costo sin RED', 'CSR', v_cod_tipopedd, null); 
                         
  END IF;

  COMMIT;
  
END LOOP;
    
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    DBMS_OUTPUT.put_line('Error '||TO_CHAR(SQLCODE)||' '|| SQLERRM);
    
END;
/
