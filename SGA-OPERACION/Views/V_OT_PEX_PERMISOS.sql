CREATE OR REPLACE VIEW OPERACION.V_OT_PEX_PERMISOS
AS 
SELECT 
         solotptoetaact.codsolot codpre,  
         solotptoetaact.punto idubi, 
         solotptoeta.codeta codeta,  
         actividad.descripcion actividad,  
         decode(solotptoetaact.moneda_id,1,'S',2,'D',null) moneda,  
         solotptoetaact.candis cant_diseno,  
         solotptoetaact.cosdis costo_diseno,  
         solotptoetaact.canliq cant_liquidacion,  
         solotptoetaact.cosliq costo_liquidacion  
    FROM actividad,  
         solotptoeta,
         solotptoetaact  
   WHERE 
         solotptoeta.codsolot = solotptoetaact.codsolot and
         solotptoeta.punto = solotptoetaact.punto and
         solotptoeta.orden = solotptoetaact.orden and
         actividad.codact = solotptoetaact.codact  and  
         actividad.espermiso = 1;


