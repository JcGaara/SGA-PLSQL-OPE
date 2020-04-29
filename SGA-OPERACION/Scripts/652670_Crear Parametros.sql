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
        VALUES ( ln_tipopedd, 'HFC LIMITES', 'PRC_HFC_BULKCOLLECT_LIMIT');
		
        
        IF SQL%ROWCOUNT = 0 THEN
          RAISE le_rollback; 
        END IF;
        
        INSERT INTO operacion.opedd ( idopedd, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
         VALUES ( (SELECT MAX(idopedd) + 1 FROM opedd), 1000, 'LIMITE SOT BAJA OAC' , 'p_genera_sot_baja_oac', ln_tipopedd, null);

         IF SQL%ROWCOUNT = 0 THEN
          RAISE le_rollback; 
        END IF;
        
        INSERT INTO operacion.opedd ( idopedd, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
         VALUES ( (SELECT MAX(idopedd) + 1 FROM opedd), 1000, 'LIMITE ASIGNA WFBSCS SIAC' , 'p_asigna_wfbscs_siac', ln_tipopedd, null);
       
        IF SQL%ROWCOUNT = 0 THEN
          RAISE le_rollback; 
        END IF;
         
 	INSERT INTO operacion.opedd ( idopedd, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
         VALUES ( (SELECT MAX(idopedd) + 1 FROM opedd), 1000, 'LIMITE ASIGNA WFBSCS SIAC' , 'p_genera_sot_reconexion_oac', ln_tipopedd, null);
       
        IF SQL%ROWCOUNT = 0 THEN
          RAISE le_rollback; 
        END IF;
		
	INSERT INTO operacion.opedd ( idopedd, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
         VALUES ( (SELECT MAX(idopedd) + 1 FROM opedd), 1000, 'LIMITE BAJA BSCS' , 'p_job_ws_baja_bscs', ln_tipopedd, null);

         IF SQL%ROWCOUNT = 0 THEN
          RAISE le_rollback; 
        END IF;
		
	INSERT INTO operacion.opedd ( idopedd, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
         VALUES ( (SELECT MAX(idopedd) + 1 FROM opedd), 1000, 'LIMITE BAJA JANUS' , 'p_job_alinea_janus', ln_tipopedd, null);

         IF SQL%ROWCOUNT = 0 THEN
          RAISE le_rollback; 
        END IF;
	
		INSERT INTO operacion.opedd ( idopedd, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
         VALUES ( (SELECT MAX(idopedd) + 1 FROM opedd), 1000, 'LIMITE GENERA SOT BAJA' , 'p_genera_sot_baja', ln_tipopedd, null);

         IF SQL%ROWCOUNT = 0 THEN
          RAISE le_rollback; 
        END IF;
		/************************/
		INSERT INTO operacion.opedd ( idopedd, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
         VALUES ( (SELECT MAX(idopedd) + 1 FROM opedd), 1000, 'LIMITE GENERA SOT SUSP OAC' , 'p_genera_sot_suspension_oac', ln_tipopedd, null);

         IF SQL%ROWCOUNT = 0 THEN
          RAISE le_rollback; 
        END IF;
		
		INSERT INTO operacion.opedd ( idopedd, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
         VALUES ( (SELECT MAX(idopedd) + 1 FROM opedd), 1000, 'LIMITE GENERA SOT RECONEXION SIAC' , 'p_genera_sot_reconexion', ln_tipopedd, null);

         IF SQL%ROWCOUNT = 0 THEN
          RAISE le_rollback; 
        END IF;
		
		INSERT INTO operacion.opedd ( idopedd, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
         VALUES ( (SELECT MAX(idopedd) + 1 FROM opedd), 1000, 'LIMITE JOB REC SOL BSCS' , 'p_job_rec_sol_bscs', ln_tipopedd, null);

         IF SQL%ROWCOUNT = 0 THEN
          RAISE le_rollback; 
        END IF;
		
		INSERT INTO operacion.opedd ( idopedd, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
         VALUES ( (SELECT MAX(idopedd) + 1 FROM opedd), 1000, 'LIMITE GENERA SOT SUSPENSION SIAC' , 'p_genera_sot_suspension', ln_tipopedd, null);

         IF SQL%ROWCOUNT = 0 THEN
          RAISE le_rollback; 
        END IF;
		
		INSERT INTO operacion.opedd ( idopedd, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
         VALUES ( (SELECT MAX(idopedd) + 1 FROM opedd), 1000, 'LIMITE JOB SUS SOL BSCS' , 'p_job_sus_sol_bscs', ln_tipopedd, null);

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