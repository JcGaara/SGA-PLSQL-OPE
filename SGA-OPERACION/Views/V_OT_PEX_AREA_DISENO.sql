CREATE OR REPLACE VIEW OPERACION.V_OT_PEX_AREA_DISENO
AS 
SELECT   ot.codot numero_ot,  
         ot.codsolot numero_solicitud,  
         ot.codsolot  codpre,  
         estot.descripcion estado,  
         ot.fecusu fecha_generacion,  
         ot.feccom fecha_compromiso,  
         ot.fecini fecha_inicio,  
         ot.fecfin fecha_fin  
    FROM (select codot, codsolot, feccom, fecusu,fecini, fecfin, estot from ot where ot.area = 11 ) ot,  
         estot  
   WHERE  
         ot.estot  = estot.estot (+);


