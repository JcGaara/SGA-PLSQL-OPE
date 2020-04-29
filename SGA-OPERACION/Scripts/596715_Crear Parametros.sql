DECLARE ln_tipopedd NUMBER;
        le_rollback EXCEPTION;
        an_error NUMBER;
        av_error VARCHAR2(1000);
BEGIN
        SELECT NVL(MAX(   tipopedd ) , 0)
               INTO ln_tipopedd 
               FROM  OPERACION.tipopedd;
        
        ln_tipopedd:= ln_tipopedd + 1;
        
        INSERT INTO OPERACION.tipopedd ( tipopedd, descripcion, abrev )
        VALUES ( ln_tipopedd, 'TIPTRA SOT DE ALTA', 'SOT_ALTA_MIGRA');
        
        IF SQL%ROWCOUNT = 0 THEN
          RAISE le_rollback; 
        END IF;
        
        INSERT INTO operacion.opedd ( idopedd, codigoc, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
         VALUES ( (SELECT MAX(idopedd) + 1 FROM opedd), '424', 424, ( SELECT descripcion FROM tiptrabajo WHERE tiptra = 424 ) , '424', ln_tipopedd, null);

         IF SQL%ROWCOUNT = 0 THEN
          RAISE le_rollback; 
        END IF;
        
        INSERT INTO operacion.opedd ( idopedd, codigoc, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
         VALUES ( (SELECT MAX(idopedd) + 1 FROM opedd), '427', 427, ( SELECT descripcion FROM tiptrabajo WHERE tiptra = 427 ) , '427', ln_tipopedd, null);
         
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