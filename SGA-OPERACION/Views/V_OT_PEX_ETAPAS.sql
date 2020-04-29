CREATE OR REPLACE VIEW OPERACION.V_OT_PEX_ETAPAS
AS 
SELECT solotptoeta.codsolot codpre,  
         solotptoeta.punto idubi,  
         solotptoeta.codeta codeta, 
         solotptoeta.orden orden, 
         etapa.descripcion etapa,  
         estpreubieta.descripcion Estado_etapa,  
         contrata.nombre nombre_contratista,  
         solotptoeta.fecini fecha_inicio_etapa,  
         solotptoeta.fecfin fecha_fin_etapa,  
         solotptoeta.fecper fecha_permiso_etapa,  
         solotptoeta.feccon Fecha_contratista,  
         solotptoeta.fecliq fecha_liquidacion,  
         solotptoeta.obs observacion_etapa  
    FROM estpreubieta,  
         etapa,  
         solotptoeta,  
         contrata  
   WHERE ( solotptoeta.codcon = contrata.codcon (+)) and  
         ( estpreubieta.esteta (+) = solotptoeta.esteta) and  
         ( etapa.codeta = solotptoeta.codeta );


