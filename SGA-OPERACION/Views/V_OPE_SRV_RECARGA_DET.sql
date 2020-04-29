CREATE OR REPLACE VIEW OPERACION.V_OPE_SRV_RECARGA_DET
AS 
select a.numregistro,a.codigo_recarga,a.fecinivig,a.fecfinvig,a.fecalerta,a.feccorte,a.flg_recarga,a.codcli,
a.numslc,a.codsolot,a.idpaq,a.estado,b.codinssrv,b.tipsrv,b.codsrv,b.fecact,b.fecbaja,b.pid,
b.estado estado_det,b.ulttareawf
from ope_srv_recarga_cab a,ope_srv_recarga_det b
where a.numregistro = b.numregistro;


