CREATE OR REPLACE VIEW OPERACION.V_OT_PEX_MATERIAL
AS 
SELECT solotptoetamat.codsolot codpre,
         solotptoetamat.punto idubi,
         solotptoeta.codeta,
         solotptoetamat.codmat codigo_material,
         almtabmat.desmat descripcion_material,
         almtabmat.abrmat abrev_material,
         almunimed.desund unidad_medida,
         almunimed.abrund abrev_unidad_medida,
         solotptoetamat.candis cant_diseno,
         solotptoetamat.cosdis costo_diseno,
         solotptoetamat.canins cant_instalacion,
         0 costo_instalacion,
         solotptoetamat.canins_ate cant_atendida,
         solotptoetamat.canins_sol cant_solicitada,
         solotptoetamat.canins_dev cant_devuelta,
         solotptoetamat.canliq cant_liquidacion,
         solotptoetamat.cosliq costo_liquidacion,
         solotptoetamat.contrata por_contrata,
         solotptoetamat.observacion observacion
    FROM almtabmat,
         solotptoeta,
         solotptoetamat,
         almunimed
   WHERE solotptoeta.codsolot = solotptoetamat.codsolot and
         solotptoeta.punto = solotptoetamat.punto and
         solotptoeta.orden = solotptoetamat.orden and
         almunimed.codund = almtabmat.codund and
         almtabmat.codmat = solotptoetamat.codmat;


