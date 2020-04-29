CREATE OR REPLACE VIEW OPERACION.V_OT_PEX_MANO_DE_OBRA
AS 
SELECT solotptoetaact.codsolot codpre,  
         solotptoetaact.punto idubi,  
         solotptoeta.codeta,  
         actividad.descripcion actividad,  
         decode(solotptoetaact.moneda_id,1,'S',2,'D',null) moneda,  
         solotptoetaact.candis cant_diseno,  
         solotptoetaact.cosdis costo_diseno,  
         0 cant_instalacion,  
         0 costo_instalacion,  
         solotptoetaact.canliq cant_liquidacion,  
         solotptoetaact.cosliq costo_liquidacion,  
         solotptoetaact.contrata Por_contrata  
    FROM actividad,  
         solotptoeta,
         solotptoetaact  
   WHERE 
         solotptoeta.codsolot = solotptoetaact.codsolot and
         solotptoeta.punto = solotptoetaact.punto and
         solotptoeta.orden = solotptoetaact.orden and
         solotptoetaact.codact = actividad.codact and  
         actividad.espermiso = 0;


