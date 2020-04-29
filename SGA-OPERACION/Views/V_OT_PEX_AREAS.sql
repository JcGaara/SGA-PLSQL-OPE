CREATE OR REPLACE VIEW OPERACION.V_OT_PEX_AREAS
AS 
SELECT ot.codot numero_ot,  
         ot.codsolot numero_solicitud,  
         solot.codsolot codpre,  
         ot.area   ,  
         estot.descripcion estado,  
         ot.fecusu fecha_generacion,  
         ot.fecini fecha_inicio,  
         ot.fecfin fecha_fin  
    FROM ot,  
         solot,  
         estot  
   WHERE ( estot.estot = ot.estot ) and  
         ( solot.codsolot = ot.codsolot ) 
                  and ot.area >= 10 and ot.area <= 14;


