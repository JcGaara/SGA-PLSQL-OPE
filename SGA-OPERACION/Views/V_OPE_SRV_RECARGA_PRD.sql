CREATE OR REPLACE VIEW OPERACION.V_OPE_SRV_RECARGA_PRD
AS 
select a.numregistro,
       a.codigo_recarga,
       a.fecinivig,
       a.fecfinvig,
       a.fecalerta,
       a.feccorte,
       a.flg_recarga,
       a.codcli,
       a.numslc,
       a.codsolot,
       a.idpaq,
       a.estado,
       b.codinssrv,
       b.tipsrv,
       b.fecact,
       b.fecbaja,
       b.estado estado_det,
       b.ulttareawf,
       i.codsrv as codsrv,
       i.iddet,
       i.pid,
       PQ_VTA_PAQUETE_CONFIGURA.F_IS_CNR(I.PID) FLG_CNR
from ope_srv_recarga_cab a,
     ope_srv_recarga_det b,
     insprd i
where a.numregistro = b.numregistro
and b.codinssrv = i.codinssrv
and i.estinsprd in (1,2);


