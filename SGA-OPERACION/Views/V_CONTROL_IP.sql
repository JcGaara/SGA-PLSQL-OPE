create or replace view operacion.v_control_ip as
select distinct cli.codcli,
       sot.codsolot,
       est.descripcion,
       ips.id_servicio,
       ips.id_producto,
       ips.id_venta,
       cli.nomcli,
       cli.dircli,
       hub.deschub,
       cmt.desccmts,
       geo.idplano,
       ubi.nomdst,
       ubi.nomest,
       paq.idpaq,
       paq.observacion,
       ips.mac_address_cm,
       ips.modelo,
       ips.ips_cpe_fija,
       ips.mac_cpe_fija,
       ips.fec_alta,
       ips.fec_baja,
       prd.pid,
       ins.codinssrv,
       ins.codsrv,
       ips.codusu,
       ips.fecusu,
       ips.codusumod,
       ips.fecusumod
  from operacion.solot sot,
       operacion.solotpto pto,
       operacion.inssrv ins,
       operacion.insprd prd,
       marketing.vtasuccli suc,
       marketing.vtatabcli cli,
       sales.paquete_venta paq,
       intraway.ope_hub hub,
       intraway.ope_cmts cmt,
       marketing.vtatabgeoref geo,
       operacion.controlip ips,
       operacion.estsol est,
       produccion.v_ubicaciones ubi
 where sot.codsolot = pto.codsolot
   and pto.codinssrv = ins.codinssrv
   and ips.cod_solot = sot.codsolot
   and ips.codinssrv = pto.codinssrv
   and sot.codcli = cli.codcli
   and ins.codcli = cli.codcli
   and suc.codcli = cli.codcli
   and sot.estsol = est.estsol
   and ins.codsuc = suc.codsuc
   and prd.codinssrv = ins.codinssrv
   and prd.codsrv = ins.codsrv
   and ins.idpaq  = paq.idpaq
   and suc.idhub = hub.idhub
   and suc.idcmts = cmt.idcmts
   and suc.idhub = cmt.idhub
   and suc.ubisuc = geo.codubi
   and suc.idplano = geo.idplano
   and ubi.codubi = geo.codubi;
/
