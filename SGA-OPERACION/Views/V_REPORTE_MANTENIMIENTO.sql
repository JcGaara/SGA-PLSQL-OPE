CREATE OR REPLACE VIEW OPERACION.V_REPORTE_MANTENIMIENTO
AS 
SELECT mantenimiento.codelered,  
         mantenimiento.codestmant,  
         estmant.descripcion estado,  
         mantenimiento.fecpro,  
         mantenimiento.fecrea,  
         tipelered.descripcion ,  
         tipelered.codtipelered ,  
         elered.descripcion,  
         elered.ubicacion,  
         to_number(to_char(mantenimiento.fecpro,'w')) sem_pro,  
         to_char(mantenimiento.fecpro,'Month') mesl_pro,  
         to_number(to_char(mantenimiento.fecpro,'MM')) mes_pro,  
         to_number(to_char(mantenimiento.fecpro,'YYYY')) anno_pro,  
         to_number(to_char(mantenimiento.fecrea,'w')) sem_con,  
         to_char(mantenimiento.fecrea,'Month') mesl_con,  
         to_number(to_char(mantenimiento.fecrea,'MM')) mes_con,  
         to_number(to_char(mantenimiento.fecrea,'YYYY')) anno_con  
    FROM elered,  
         estmant,  
         inssrv,  
         mantenimiento,  
         tipelered  
   WHERE ( elered.codelered = inssrv.codelered (+)) and  
         ( estmant.codestmant = mantenimiento.codestmant ) and  
         ( mantenimiento.codelered = elered.codelered ) and  
         ( tipelered.codtipelered = elered.codtipelered );


