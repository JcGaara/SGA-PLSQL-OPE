drop procedure OPERACION.sgass_val_orden_visit_cp;
drop procedure OPERACION.P_CONS_LINEA_JANUS_REG;

DELETE FROM operacion.opedd
 WHERE tipopedd =
       (SELECT tipopedd FROM operacion.tipopedd b WHERE B.ABREV = 'TIPTRA_HFC_LTE_CP');
	   
DELETE FROM operacion.opedd
 WHERE tipopedd = (SELECT tipopedd
                     FROM operacion.tipopedd b
                    WHERE B.ABREV = 'TIPO_MOT_HFC_LTE_VIS');
					
DELETE FROM operacion.opedd
 WHERE tipopedd =
       (SELECT tipopedd FROM operacion.tipopedd b WHERE B.ABREV = 'CONF_WLLSIAC_CP');
	   
DELETE FROM operacion.opedd
 WHERE tipopedd =
       (SELECT tipopedd FROM operacion.tipopedd b WHERE B.ABREV = 'CONF_CP_CIERRE_SVT');
	   
DELETE FROM operacion.opedd
 WHERE tipopedd =
       (SELECT tipopedd FROM operacion.tipopedd b WHERE B.ABREV = 'TRAM_PLAN_COME');

DELETE FROM operacion.tipopedd b WHERE B.ABREV IN ('TIPTRA_HFC_LTE_CP');
DELETE FROM operacion.tipopedd b WHERE B.ABREV IN ('TIPO_MOT_HFC_LTE_VIS');
DELETE FROM operacion.tipopedd b WHERE B.ABREV IN ('CONF_WLLSIAC_CP');
DELETE FROM operacion.tipopedd b WHERE B.ABREV IN ('CONF_CP_CIERRE_SVT');
DELETE FROM operacion.tipopedd b WHERE B.ABREV IN ('TRAM_PLAN_COME');
DELETE FROM operacion.tipopedd b WHERE B.ABREV IN ('TRAM_PLAN_COME');

DELETE FROM operacion.motot WHERE descripcion  = 'HFC/SIAC CAMBIO PLAN(SIN VISITA TECNICA)';
DELETE FROM operacion.motot WHERE descripcion  = 'HFC/SIAC CAMBIO PLAN(CON VISITA TECNICA)';
DELETE FROM operacion.mototxtiptra 
      WHERE TIPTRA = 695 
	    AND CODMOTOT IN (SELECT codmotot 
						   FROM operacion.motot 
						  WHERE descripcion = 'HFC/SIAC CAMBIO PLAN(SIN VISITA TECNICA)') ;						  
DELETE FROM operacion.mototxtiptra 
      WHERE TIPTRA = 695 
	    AND CODMOTOT IN (SELECT codmotot 
						   FROM operacion.motot 
						  WHERE descripcion = 'HFC/SIAC CAMBIO PLAN(CON VISITA TECNICA)') ;		
						  
DELETE FROM operacion.mototxtiptra 
      WHERE TIPTRA = 753 
	    AND CODMOTOT IN (SELECT codmotot 
						   FROM operacion.motot 
						  WHERE descripcion = 'INALAMBRICO - CAMBIO DE PLAN (SIN VISITA TECNICA)') ;						  
DELETE FROM operacion.mototxtiptra 
      WHERE TIPTRA = 753 
	    AND CODMOTOT IN (SELECT codmotot 
						   FROM operacion.motot 
						  WHERE descripcion = 'INALAMBRICO - CAMBIO DE PLAN (CON VISITA TECNICA)') ;								  
						  
COMMIT;
/						  

