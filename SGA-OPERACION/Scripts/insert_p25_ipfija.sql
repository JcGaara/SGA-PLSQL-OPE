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
      VALUES(v_cod_tipopedd,'Configuracion para Contin SGA', 'CONFSERVADICIONAL');
      
      ---detalle               
      insert into operacion.opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
      values ((SELECT MAX(IDOPEDD)+1 FROM OPERACION.OPEDD), '', 12, 'Cerrada', 'ESTSOL_SADIC', v_cod_tipopedd, null);

      insert into operacion.opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
      values ((SELECT MAX(IDOPEDD)+1 FROM OPERACION.OPEDD), '', 17, 'En Ejecucion', 'ESTSOL_SADIC', v_cod_tipopedd, null); 
      
      insert into operacion.opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
      values ((SELECT MAX(IDOPEDD)+1 FROM OPERACION.OPEDD), '', 29, 'Atendida', 'ESTSOL_SADIC', v_cod_tipopedd, null);

      insert into operacion.opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
      values ((SELECT MAX(IDOPEDD)+1 FROM OPERACION.OPEDD), '', 412, 'HFC - TRASLADO EXTERNO', 'TIPTRAVAL', v_cod_tipopedd, null); 
      
      insert into operacion.opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
      values ((SELECT MAX(IDOPEDD)+1 FROM OPERACION.OPEDD), '', 424, 'HFC - INSTALACION PAQUETES TODO CLARO DIGITAL', 'TIPTRAVAL', v_cod_tipopedd, null);

      insert into operacion.opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
      values ((SELECT MAX(IDOPEDD)+1 FROM OPERACION.OPEDD), '', 427, 'HFC - CAMBIO DE PLAN', 'TIPTRAVAL', v_cod_tipopedd, null); 
      
      insert into operacion.opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
      values ((SELECT MAX(IDOPEDD)+1 FROM OPERACION.OPEDD), '', 620, 'CLARO EMPRESAS HFC - SERVICIOS MENORES', 'TIPTRAVAL', v_cod_tipopedd, null);

      insert into operacion.opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
      values ((SELECT MAX(IDOPEDD)+1 FROM OPERACION.OPEDD), '', 658, 'HFC - SISACT INSTALACION PAQUETES TODO CLARO DIGITAL', 'TIPTRAVAL', v_cod_tipopedd, null); 
      
      insert into operacion.opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
      values ((SELECT MAX(IDOPEDD)+1 FROM OPERACION.OPEDD), '', 676, 'HFC - PORTABILIDAD INSTALACIONES PAQUETES CLARO', 'TIPTRAVAL', v_cod_tipopedd, null);

      insert into operacion.opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
      values ((SELECT MAX(IDOPEDD)+1 FROM OPERACION.OPEDD), '', 678, 'HFC/SISACT - MIGRACION SISACT', 'TIPTRAVAL', v_cod_tipopedd, null); 
      
      insert into operacion.opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
      values ((SELECT MAX(IDOPEDD)+1 FROM OPERACION.OPEDD), 'INT', 745, 'HFC/SIAC - IPFIJA CONFIGURACION', 'DROPDOWN', v_cod_tipopedd, 1);

      insert into operacion.opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
      values ((SELECT MAX(IDOPEDD)+1 FROM OPERACION.OPEDD), 'INT', 766, 'HFC/SIAC - PUERTO25', 'DROPDOWN', v_cod_tipopedd, 0); 
      
                
  END IF;

  COMMIT;
  
END LOOP;
    
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    DBMS_OUTPUT.put_line('Error '||TO_CHAR(SQLCODE)||' '|| SQLERRM);
    
END;
/
