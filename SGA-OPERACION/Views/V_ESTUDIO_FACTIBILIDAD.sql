CREATE OR REPLACE VIEW OPERACION.V_ESTUDIO_FACTIBILIDAD
AS 
SELECT ef.codef,  
ef.numslc,  
ef.codcli,  
vtatabcli.nomcli,  
ef.NUMDIAPLA,  
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
vtatabestpro.desest,  
a.numpsp,  
a.idopc,  
a.estpspcli,  
a.estado_descripcion,  
puertas.cant,  
puntos.cant  
from  
ef,  
(select codef, count(*) cant from efpto where pop is not null group by codef) puertas,  
(select codef, count(*) cant from efpto group by codef) puntos,  
vtatabslcfac,  
(select  
vtatabpspcli.NUMPSP,  
vtatabpspcli.NUMSLC,  
vtatabpspcli.IDOPC,  
vtatabpspcli.ESTPSPCLI,  
vtatabestpro.desest estado_descripcion  
from vtatabpspcli,  
vtatabestpro,  
(select max(c.numpsp) numpsp, max(c.idopc) idopc  
from vtatabpspcli c group by c.numpsp) b  
where  
vtatabpspcli.numpsp  = b.numpsp  and  
vtatabpspcli.idopc  = b.idopc and  
vtatabestpro.codtab = '00013' and  
vtatabestpro.codest = vtatabpspcli.estpspcli ) a,  
tystabsrv,  
tystipsrv,  
vtatabcli,  
estef,  
vtatabect,  
vtatabestpro  
where  
ef.numslc = vtatabslcfac.numslc and  
ef.codef = puntos.codef (+) and  
ef.codef = puertas.codef (+) and  
vtatabslcfac.numslc = a.numslc(+) and  
ef.tipsrv = tystipsrv.tipsrv(+) and  
vtatabslcfac.codsrv = tystabsrv.codsrv(+) and  
vtatabestpro.codtab = '00001' and  
vtatabslcfac.estsolfac = vtatabestpro.codest and  
ef.codcli = vtatabcli.codcli(+) AND  
ef.ESTEF = estef.estef and  
vtatabslcfac.codsol = vtatabect.codect(+);


