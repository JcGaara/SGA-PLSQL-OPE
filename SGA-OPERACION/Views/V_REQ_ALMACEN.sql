CREATE OR REPLACE VIEW OPERACION.V_REQ_ALMACEN
AS 
SELECT solot.numslc proyecto,solotptoetamat.codsolot, 
solotpto_id.nroreq,
solotptoetamat.punto, 
solotptoetamat.orden, 
solotptoetamat.candis, 
solotptoetamat.canins, 
solotptoetamat.canins_ate, 
solotptoetamat.canins_sol, 
solotptoetamat.canins_dev, 
solotptoetamat.canliq, 
v_matope.descripcion, 
v_matope.coduni, 
solotptoetamat.moneda_id,
matope.campo1 
FROM solotptoetamat, 
solot,
v_matope,
matope,
solotpto_id
WHERE ( solotptoetamat.codmat = v_matope.codmat ) and 
flgsol = 1 and
solot.codsolot = solotptoetamat.codsolot and
(solotpto_id.codsolot = solotptoetamat.codsolot and 
solotpto_id.punto = solotptoetamat.punto) and
( solotptoetamat.codmat = matope.codmat );


