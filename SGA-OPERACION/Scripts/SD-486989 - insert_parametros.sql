DECLARE ln_tipopedd NUMBER;
        le_rollback EXCEPTION;
        an_error NUMBER;
        av_error VARCHAR2(1000);
BEGIN
        SELECT NVL(MAX(   tipopedd ) , 0)
               INTO ln_tipopedd 
               FROM  OPERACION.tipopedd;
        
        ln_tipopedd:= ln_tipopedd + 1;
        
        INSERT INTO OPERACION.tipopedd ( tipopedd, descripcion, abrev)
        VALUES ( ln_tipopedd, 'TIPOS TRAB ORDEN VISITA', 'PRC_HFC_OPT_OV');
    
        
        IF SQL%ROWCOUNT = 0 THEN
          RAISE le_rollback; 
        END IF;
        
INSERT INTO operacion.opedd ( idopedd, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
VALUES ( (SELECT MAX(idopedd) + 1 FROM opedd), 480, 'HFC - MANTENIMIENTO' , 'TIPTRA_OV', ln_tipopedd, null);  

IF SQL%ROWCOUNT = 0 THEN
          RAISE le_rollback; 
        END IF;
INSERT INTO operacion.opedd ( idopedd, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
VALUES ( (SELECT MAX(idopedd) + 1 FROM opedd), 441, 'HFC - SUSPENSIÓN TODO CLARO POR FALTA DE PAGO' , 'TIPTRA_OV', ln_tipopedd, null);    

IF SQL%ROWCOUNT = 0 THEN
          RAISE le_rollback; 
        END IF;
INSERT INTO operacion.opedd ( idopedd, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
VALUES ( (SELECT MAX(idopedd) + 1 FROM opedd), 443, 'HFC - RECONEXIÓN TODO CLARO POR FALTA DE PAGO' , 'TIPTRA_OV', ln_tipopedd, null); 
        
        IF SQL%ROWCOUNT = 0 THEN
          RAISE le_rollback; 
        END IF;
INSERT INTO operacion.opedd ( idopedd, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
VALUES ( (SELECT MAX(idopedd) + 1 FROM opedd), 444, 'HFC - SUSP. TODO CLARO A SOLIC. DEL CLIENTE' , 'TIPTRA_OV', ln_tipopedd, null); 

IF SQL%ROWCOUNT = 0 THEN
          RAISE le_rollback; 
        END IF;
    INSERT INTO operacion.opedd ( idopedd, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
VALUES ( (SELECT MAX(idopedd) + 1 FROM opedd), 445, 'HFC - RECONX. TODO CLARO A SOLIC. DEL CLIENTE' , 'TIPTRA_OV', ln_tipopedd, null); 

IF SQL%ROWCOUNT = 0 THEN
          RAISE le_rollback; 
        END IF;
INSERT INTO operacion.opedd ( idopedd, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
VALUES ( (SELECT MAX(idopedd) + 1 FROM opedd), 489, 'HFC - RETENCION' , 'TIPTRA_OV', ln_tipopedd, null); 

IF SQL%ROWCOUNT = 0 THEN
          RAISE le_rollback; 
        END IF;
      COMMIT;
      
INSERT INTO operacion.opedd ( idopedd, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
VALUES ( (SELECT MAX(idopedd) + 1 FROM opedd), 17, 'EN EJECUCION' , 'EST_SOT', ln_tipopedd, null); 

IF SQL%ROWCOUNT = 0 THEN
          RAISE le_rollback; 
        END IF;
      COMMIT;      
                
        EXCEPTION
        WHEN le_rollback THEN
           an_error := sqlcode;
           av_error := sqlerrm;
           ROLLBACK;
           RAISE_APPLICATION_ERROR(-20500, 'Ocurrió un error al ejecutar el procedimiento ' || $$plsql_unit || ': ' ||  av_error);
        WHEN OTHERS THEN
           an_error := sqlcode;
           av_error := sqlerrm;
           ROLLBACK;
           RAISE_APPLICATION_ERROR(-20500, 'Ocurrió un error al ejecutar el procedimiento ' || $$plsql_unit || ': ' ||  av_error);
                              
END; 
/