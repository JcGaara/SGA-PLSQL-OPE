---INSERT CABECERA Y DETALLE :  TIPOPEDD - OPEDD
DECLARE
v_contador             INTEGER:=0;        
v_cod_tipopedd         NUMBER(6);
v_cod_idopedd          NUMBER(6);
BEGIN

LOOP
  EXIT WHEN v_contador = 13;
  v_contador := v_contador + 1;

  SELECT MAX(tipopedd)+1 INTO v_cod_tipopedd FROM OPERACION.TIPOPEDD;

  IF v_contador=1 THEN 
      INSERT INTO OPERACION.TIPOPEDD (TIPOPEDD,DESCRIPCION,ABREV)
           VALUES(v_cod_tipopedd,'Action Id - regular','ACTIONIDPROV_A');

      SELECT MAX(IDOPEDD)+1 INTO v_cod_idopedd FROM OPERACION.OPEDD;

      INSERT INTO OPERACION.OPEDD (IDOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION,TIPOPEDD)
                  VALUES(v_cod_idopedd,'',1,'ACTION ID A','REGULAR',v_cod_tipopedd); 
                    
  END IF;
  
  IF v_contador=2 THEN 
    INSERT INTO OPERACION.TIPOPEDD (TIPOPEDD,DESCRIPCION,ABREV)
    VALUES(v_cod_tipopedd,'Action Id - regular','ACTIONIDPROV_B');

      SELECT MAX(IDOPEDD)+1 INTO v_cod_idopedd FROM OPERACION.OPEDD;
      
      INSERT INTO OPERACION.OPEDD (IDOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION,TIPOPEDD)
                  VALUES(v_cod_idopedd,'',2,'ACTION ID B','BAJA_BSCS',v_cod_tipopedd);

  END IF;

  IF v_contador=3 THEN 
        INSERT INTO OPERACION.TIPOPEDD (TIPOPEDD,DESCRIPCION,ABREV)
                     VALUES(v_cod_tipopedd,'Action Id - baja','ACTIONIDPROV_H');

      SELECT MAX(IDOPEDD)+1 INTO v_cod_idopedd FROM OPERACION.OPEDD;
      
      INSERT INTO OPERACION.OPEDD (IDOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION,TIPOPEDD)
                  VALUES(v_cod_idopedd,'',8,'ACTION ID H','REGULAR',v_cod_tipopedd);
  END IF;

  IF v_contador=4 THEN 
      INSERT INTO OPERACION.TIPOPEDD (TIPOPEDD,DESCRIPCION,ABREV)
                     VALUES(v_cod_tipopedd,'Validacion consulta BSCS','DATO BSCS');

      SELECT MAX(IDOPEDD)+1 INTO v_cod_idopedd FROM OPERACION.OPEDD;
      
      INSERT INTO OPERACION.OPEDD (IDOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION,TIPOPEDD)
                  VALUES(v_cod_idopedd,'',0,'and a.ch_status !=''d'' and a.ch_pending is not null','DATO BSCS',v_cod_tipopedd);
  END IF;
  
  IF v_contador=5 THEN 
      INSERT INTO OPERACION.TIPOPEDD (TIPOPEDD,DESCRIPCION,ABREV)
                     VALUES(v_cod_tipopedd,'Estado del SOLOT','EST_SOLOT');

      SELECT MAX(IDOPEDD)+1 INTO v_cod_idopedd FROM OPERACION.OPEDD;
      
      INSERT INTO OPERACION.OPEDD (IDOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION,TIPOPEDD)
                  VALUES(v_cod_idopedd,'',9,'ESTADO SOLOT','EST_SOLOT',v_cod_tipopedd);
  END IF;
  
  IF v_contador=6 THEN 
      INSERT INTO OPERACION.TIPOPEDD (TIPOPEDD,DESCRIPCION,ABREV)
                     VALUES(v_cod_tipopedd,'Estado del SOLOT','EST_SOLOT');

      SELECT MAX(IDOPEDD)+1 INTO v_cod_idopedd FROM OPERACION.OPEDD;
      
      INSERT INTO OPERACION.OPEDD (IDOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION,TIPOPEDD)
                  VALUES(v_cod_idopedd,'',12,'ESTADO SOLOT','EST_SOLOT',v_cod_tipopedd);
  END IF;

  IF v_contador=7 THEN 
      INSERT INTO OPERACION.TIPOPEDD (TIPOPEDD,DESCRIPCION,ABREV)
                     VALUES(v_cod_tipopedd,'Estado del SOLOT','EST_SOLOT');

      SELECT MAX(IDOPEDD)+1 INTO v_cod_idopedd FROM OPERACION.OPEDD;
      
      INSERT INTO OPERACION.OPEDD (IDOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION,TIPOPEDD)
                  VALUES(v_cod_idopedd,'',17,'ESTADO SOLOT','EST_SOLOT',v_cod_tipopedd);
  END IF;  
  
  IF v_contador=8 THEN 
      INSERT INTO OPERACION.TIPOPEDD (TIPOPEDD,DESCRIPCION,ABREV)
                     VALUES(v_cod_tipopedd,'Estado del SOLOT','EST_SOLOT');

      SELECT MAX(IDOPEDD)+1 INTO v_cod_idopedd FROM OPERACION.OPEDD;
      
      INSERT INTO OPERACION.OPEDD (IDOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION,TIPOPEDD)
                  VALUES(v_cod_idopedd,'',29,'ESTADO SOLOT','EST_SOLOT',v_cod_tipopedd);
  END IF;  
  
  IF v_contador=9 THEN 
      INSERT INTO OPERACION.TIPOPEDD (TIPOPEDD, DESCRIPCION, ABREV)
                       VALUES(v_cod_tipopedd,'CONFIGURACI�N DIA MASIVO','HISTCMASIVO');

      SELECT MAX(IDOPEDD)+1 INTO v_cod_idopedd FROM OPERACION.OPEDD;
      
      INSERT INTO OPERACION.OPEDD (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
               VALUES(v_cod_idopedd, '', NULL, 'D�AS PARA ANULACI�N DE HISTORICO DE PROCESO CARGA MASIVO', 'HISTCMASIVO', v_cod_tipopedd, 60);
  END IF; 
  
  IF v_contador=10 THEN 
      INSERT INTO OPERACION.TIPOPEDD (TIPOPEDD, DESCRIPCION, ABREV)
             VALUES(v_cod_tipopedd,'TIPTRA CONSULTA SGA','TIPTRA_SGA');

        INSERT INTO OPERACION.OPEDD (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
        VALUES ((select max(IDOPEDD)+1 from OPERACION.OPEDD), '', 700, 'CONSULTA TIPTRABAJO', 'TIPTRA_SGA', v_cod_tipopedd, NULL);


        INSERT INTO OPERACION.OPEDD (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
        VALUES ((select max(IDOPEDD)+1 from OPERACION.OPEDD), '', 418, 'CONSULTA TIPTRABAJO', 'TIPTRA_SGA', v_cod_tipopedd, NULL);


        INSERT INTO OPERACION.OPEDD (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
        VALUES ((select max(IDOPEDD)+1 from OPERACION.OPEDD), '', 689, 'CONSULTA TIPTRABAJO', 'TIPTRA_SGA', v_cod_tipopedd, NULL);


        INSERT INTO OPERACION.OPEDD (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
        VALUES ((select max(IDOPEDD)+1 from OPERACION.OPEDD), '', 721, 'CONSULTA TIPTRABAJO', 'TIPTRA_SGA', v_cod_tipopedd, NULL);


        INSERT INTO OPERACION.OPEDD (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
        VALUES ((select max(IDOPEDD)+1 from OPERACION.OPEDD), '', 692, 'CONSULTA TIPTRABAJO', 'TIPTRA_SGA', v_cod_tipopedd, NULL);


        INSERT INTO OPERACION.OPEDD (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
        VALUES ((select max(IDOPEDD)+1 from OPERACION.OPEDD), '', 412, 'CONSULTA TIPTRABAJO', 'TIPTRA_SGA', v_cod_tipopedd, NULL);

  END IF;  
  
  IF v_contador=11 THEN 
      INSERT INTO OPERACION.TIPOPEDD (TIPOPEDD, DESCRIPCION, ABREV)
             VALUES(v_cod_tipopedd,'TIPTRA CONSULTA SOLOT','TIPTRA_SOLOT');

        INSERT INTO OPERACION.OPEDD (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
        VALUES((select max(IDOPEDD)+1 from OPERACION.OPEDD), '', 427, 'CONSULTA TIPTRA EN TABLA SOLOT', 'TIPTRA_SOLOT', v_cod_tipopedd, NULL);


        INSERT INTO OPERACION.OPEDD (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
        VALUES((select max(IDOPEDD)+1 from OPERACION.OPEDD), '', 676, 'CONSULTA TIPTRA EN TABLA SOLOT', 'TIPTRA_SOLOT', v_cod_tipopedd, NULL);


        INSERT INTO OPERACION.OPEDD (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
        VALUES((select max(IDOPEDD)+1 from OPERACION.OPEDD), '', 678, 'CONSULTA TIPTRA EN TABLA SOLOT', 'TIPTRA_SOLOT', v_cod_tipopedd, NULL);


  END IF; 
  
  IF v_contador=12 THEN 
      INSERT INTO OPERACION.TIPOPEDD (TIPOPEDD, DESCRIPCION, ABREV)
             VALUES(v_cod_tipopedd,'CONSULTA ESTSOL','CONS_ESTSOL');

        INSERT INTO OPERACION.OPEDD (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
               VALUES((select max(IDOPEDD)+1 from OPERACION.OPEDD), '', 16, 'CONSULTA EN TABLA ESTSOL', 'CONS_ESTSOL', v_cod_tipopedd, NULL);

        INSERT INTO OPERACION.OPEDD (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
               VALUES((select max(IDOPEDD)+1 from OPERACION.OPEDD), '', 27, 'CONSULTA EN TABLA ESTSOL', 'CONS_ESTSOL', v_cod_tipopedd, NULL);

  END IF; 
  
  IF v_contador=13 THEN 
      INSERT INTO OPERACION.TIPOPEDD (TIPOPEDD, DESCRIPCION, ABREV)
             VALUES(v_cod_tipopedd,'CONFIGURACI�N DIA ','HISTALICONT');

        INSERT INTO OPERACION.OPEDD (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
               VALUES((select max(IDOPEDD)+1 from OPERACION.OPEDD), '', 0, 'D�AS PARA ANULACI�N DE HISTORICO ALINEACI�N DE CONTRATOS MASIVO', 'HISTALICONT', v_cod_tipopedd, 30);


  END IF; 

  COMMIT;
  
END LOOP;
    
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    DBMS_OUTPUT.put_line('Error '||TO_CHAR(SQLCODE)||' '|| SQLERRM);
    
END;
/
