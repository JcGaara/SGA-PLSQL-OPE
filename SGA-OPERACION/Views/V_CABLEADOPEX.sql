CREATE OR REPLACE VIEW OPERACION.V_CABLEADOPEX
AS 
select se.codsolot,e.descripcion,se.fecini,sm.codmat,m.descripcion,sm.candis,sm.canliq
from solotptoeta se, etapa e, solotptoetamat sm, matope m
where 
se.codeta=10
and se.codeta = e.codeta
and e.codeta in (200,310,4,314,10,316)
and se.codsolot=sm.codsolot
and se.punto=sm.punto
and se.orden=sm.orden
and sm.codmat=m.codmat
and sm.contrata=0;


