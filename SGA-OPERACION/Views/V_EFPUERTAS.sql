CREATE OR REPLACE VIEW OPERACION.V_EFPUERTAS
AS 
select ef.codef EF  , ts.dsctipsrv SERVICIO ,ee.descripcion ESTADO, ef.codcli, vc.nomcli,/*ef.fecapr FECHA_APROBACION,*/ef.fecusu FECHA_GENERACION,
ef.fecfin FECHA_FIN,ef.numdiapla DIAS_PLAZO,count(*) PUERTAS
from ef ,efpto ep , vtatabslcfac vn, tystipsrv ts, estef ee, vtatabcli vc
where ep.pop is not null
and ef.codef=ep.codef
and ef.numslc=vn.numslc
and vn.tipsrv=ts.tipsrv
and ef.estef=ee.estef
and ef.codcli=vc.codcli
group by ef.codef , ts.dsctipsrv,ee.descripcion, ef.codcli, vc.nomcli,ef.fecapr,ef.fecusu,
ef.fecfin,ef.numdiapla;


