CREATE OR REPLACE VIEW OPERACION.V_DETALLE_ESTUDIO_FACTIBILIDAD
AS 
SELECT /*+ ORDERED */ ef.codef,  
ef.numslc,  
ef.codcli,  
vtatabcli.nomcli,  
ef.numdiapla,  
ef.estef,  
estef.descripcion,  
ef.cosmo,  
ef.cosmat,  
ef.cosequ,  
ef.fecfin,  
ef.fecapr,  
ef.fecusu,  
vtatabslcfac.codsol,  
vtatabect.nomect,  
vtatabslcfac.codsrv,  
tystabsrv.dscsrv,  
ef.tipsrv,  
tystipsrv.dsctipsrv,  
vtatabslcfac.fecapr,  
vtatabslcfac.estsolfac,  
VTATABESTPRO2.desest,  
a.numpsp,  
a.idopc,  
a.estpspcli,  
a.estado_descripcion,  
puertas.cant,  
puntos.cant,  
v_pop.pop,  
v_pop.descripcion,  
EFPTO3.punto,  
EFPTO3.descripcion,  
EFPTO3.direccion,  
vtatabdst.nomdst,  
tystabsrv.dscsrv,  
EFPTO3.bw,  
EFPTO3.coordx1,  
EFPTO3.coordy1,  
EFPTO3.coordx2,  
EFPTO3.coordy2,  
RTRIM(TO_CHAR(EFPTO3.coordy2)) || EFPTO3.coordx2 AS CUADRICULA,  
RTRIM(TO_CHAR(EFPTO3.coordy1)) || EFPTO3.coordx1 AS CUADRANTE,  
EFPTO3.cosmo,  
EFPTO3.cosmat,  
EFPTO3.cosequ,  
EFPTO3.fecini,  
EFPTO3.numdiapla,  
EFPTO3.fecfin,  
EFPTO3.codinssrv  
from ef,  
(select codef,  
count(*) cant  
from efpto EFPTO1  
group by codef) puertas,  
(select codef,  
count(*) cant  
from efpto EFPTO2  
group by codef) puntos,  
vtatabslcfac,  
(select vtatabpspcli.NUMPSP,  
vtatabpspcli.NUMSLC,  
vtatabpspcli.IDOPC,  
vtatabpspcli.ESTPSPCLI,  
VTATABESTPRO1.desest estado_descripcion  
from vtatabpspcli,  
vtatabestpro VTATABESTPRO1,  
(select max(c.numpsp) numpsp,  
max(c.idopc) idopc  
from vtatabpspcli c  
group by c.numpsp) b  
where vtatabpspcli.numpsp = b.numpsp  
and vtatabpspcli.idopc = b.idopc  
and VTATABESTPRO1.codtab = '00013'  
and VTATABESTPRO1.codest = vtatabpspcli.estpspcli) a,  
tystabsrv,  
tystipsrv,  
vtatabcli,  
estef,  
vtatabect,  
vtatabestpro VTATABESTPRO2,  
efpto EFPTO3,  
vtatabdst,  
v_pop,  
tystabsrv servicio  
where ef.numslc = vtatabslcfac.numslc  
and EFPTO3.codef = ef.codef  
and vtatabdst.codubi (+) = EFPTO3.codubi  
and EFPTO3.pop = v_pop.pop (+)  
and servicio.codsrv (+) = EFPTO3.codsrv  
and ef.codef = puntos.codef (+)  
and ef.codef = puertas.codef (+)  
and vtatabslcfac.numslc = a.numslc (+)  
and ef.tipsrv = tystipsrv.tipsrv (+)  
and vtatabslcfac.codsrv = tystabsrv.codsrv (+)  
and VTATABESTPRO2.codtab = '00001'  
and vtatabslcfac.estsolfac = VTATABESTPRO2.codest  
and ef.codcli = vtatabcli.codcli (+)  
AND ef.ESTEF = estef.estef  
and vtatabslcfac.codsol = vtatabect.codect;


