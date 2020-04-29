CREATE OR REPLACE VIEW OPERACION.V_PROYECTOS
AS 
SELECT  
vtatabslcfac.numslc,  
vtatabslcfac.codcli,  
vtatabcli.nomcli,  
vtatabslcfac.codsol,  
vtatabect.nomect,  
vtatabslcfac.codsrv,  
tystabsrv.dscsrv,  
tystipsrv.tipsrv,  
tystipsrv.dsctipsrv,  
vtatabslcfac.fecapr,  
vtatabslcfac.estsolfac,  
vtatabestpro.desest,  
a.numpsp,  
a.idopc,  
a.estpspcli,  
a.estado_descripcion,  
a.tipo_contrato  
from  
vtatabslcfac,  
(select  
vtatabpspcli.NUMPSP,  
vtatabpspcli.NUMSLC,  
vtatabpspcli.IDOPC,  
vtatabpspcli.tipsrv,  
vtatabpspcli.ESTPSPCLI,  
decode(vtatabpspcli.ESTPSPCLI,'02','C','05','D',null) tipo_contrato,  
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
vtatabect,  
vtatabestpro  
where  
vtatabslcfac.numslc = a.numslc(+) and  
a.tipsrv = tystipsrv.tipsrv(+) and  
vtatabslcfac.codsrv = tystabsrv.codsrv(+) and  
vtatabestpro.codtab = '00001' and  
vtatabslcfac.estsolfac = vtatabestpro.codest and  
vtatabslcfac.codcli = vtatabcli.codcli(+) AND  
vtatabslcfac.codsol = vtatabect.codect(+);


