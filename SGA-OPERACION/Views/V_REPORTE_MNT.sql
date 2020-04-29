CREATE OR REPLACE VIEW OPERACION.V_REPORTE_MNT
AS 
SELECT    elered.codtipelered tipo,  
         to_number(to_char(mantenimiento.fecpro,'w')) sem_pro,  
         to_char(mantenimiento.fecpro,'Month') mesl_pro,  
         to_number(to_char(mantenimiento.fecpro,'MM')) mes_pro,  
         to_number(to_char(mantenimiento.fecpro,'YYYY')) anno_pro,  
         to_number(to_char(mantenimiento.fecrea,'w')) sem_con,  
         to_char(mantenimiento.fecrea,'Month') mesl_con,  
         to_number(to_char(mantenimiento.fecrea,'MM')) mes_con,  
         to_number(to_char(mantenimiento.fecrea,'YYYY')) anno_con,  
         count(*)  cantidad  
    FROM elered,  
         mantenimiento  
   WHERE mantenimiento.codelered = elered.codelered  
group by  
   elered.codtipelered ,  
    mantenimiento.fecpro,  
     mantenimiento.fecrea;


