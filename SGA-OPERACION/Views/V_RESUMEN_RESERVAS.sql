create or replace view operacion.v_resumen_reservas as
select a.id_sol id_sol, --REQ 122579
       c.nro_res num_reserva,
       a.fec_usu fecgenreserva,
       c.cod_sap cod_sap,
       d.desmat descripcion,
       c.cantidad cantidad,
       e.centrosap centro,
       (select almacen || ' ' || alm_descripcion alm_descripcion
          from z_mm_configuracion
         where almacen = e.almacensap
           and centro = e.centrosap) almacen, --REQ 130264
       '' centro_des, --REQ 114000
       '' almacen_des, --REQ 114000
       a.codsol solicitante,
       a.codsolot sot,
       a.numslc proyecto,
       g.elemento_pep pep,
       f.nomcli cliente,
       g.nombre contrata,
       a.transaccion transaccion,
       e.observacion observacion,
       f.codcli codcli,
       g.fec_atencion, --REQ 122579
       h.abrdid || '-' || f.ntdide ruc, --REQ 122579
       'Equipos' tipo,
       (SELECT d.descripcion FROM operacion.tipopedd m, operacion.opedd d WHERE m.abrev = 'EST_RES_SAPSGA' AND m.tipopedd = d.tipopedd AND d.codigon = c.estado_sap) estado_res
/*       decode(nvl(c.flg_anular, 0),
              0,
              'Generado',
              1,
              'Por anular',
              2,
              'Anulado') estado_res --REQ 135592*/
  from financial.solicitud_mat       a,
       financial.solicitud_mat_det   g,
       financial.sol_mat_det_sol_res c,
       produccion.almtabmat          d,
       solotptoequ                   e,
       vtatabcli                     f,
       contrata                      g,
       vtatipdid                     h --REQ 122579
 where a.id_sol = g.id_sol
   and g.id_lin_det = c.id_lin_det
   and c.estado_int_res = 2
   and c.flg_reserva = 'S'
   and a.id_sol = c.id_sol
   and c.codmat = d.codmat
   and a.codsolot = e.codsolot
   and g.punto = e.punto
   and g.orden = e.orden
   and a.codcli = f.codcli(+)
   and a.codcon = g.codcon(+)
   and f.tipdide = h.tipdide(+) --REQ 122579
union all
select a.id_sol id_sol, --REQ 122579
       c.nro_res num_reserva,
       a.fec_usu fecgenreserva,
       c.cod_sap cod_sap,
       d.desmat descripcion,
       c.cantidad,
       e.centrosap centro,
       (select almacen || ' ' || alm_descripcion alm_descripcion
          from z_mm_configuracion
         where almacen = e.almacensap
           and centro = e.centrosap) almacen, --REQ 130264
       '' centro_des, --REQ 114000
       '' almacen_des, --REQ 114000
       a.codsol,
       a.codsolot sot,
       a.numslc proyecto,
       g.elemento_pep pep,
       f.nomcli cliente,
       g.nombre contrata,
       a.transaccion,
       e.observacion observacion,
       f.codcli codcli,
       g.fec_atencion, --REQ 122579
       h.abrdid || '-' || f.ntdide ruc, --REQ 122579
       'Materiales' tipo,
       (SELECT d.descripcion FROM operacion.tipopedd m, operacion.opedd d WHERE m.abrev = 'EST_RES_SAPSGA' AND m.tipopedd = d.tipopedd AND d.codigon = c.estado_sap) estado_res
/*       decode(nvl(c.flg_anular, 0),
              0,
              'Generado',
              1,
              'Por anular',
              2,
              'Anulado') estado_res --REQ 135592*/
  from financial.solicitud_mat       a,
       financial.solicitud_mat_det   g,
       financial.sol_mat_det_sol_res c,
       produccion.almtabmat          d,
       solotptoetamat                e,
       vtatabcli                     f,
       contrata                      g,
       vtatipdid                     h --REQ 122579
 where a.id_sol = g.id_sol
   and g.id_lin_det = c.id_lin_det
   and c.estado_int_res = 2
   and c.flg_reserva = 'S'
   and a.id_sol = c.id_sol
   and c.codmat = d.codmat
   and g.idmat = e.idmat
   and a.codcli = f.codcli(+)
   and a.codcon = g.codcon(+)
   and f.tipdide = h.tipdide(+) --REQ 122579
union all
select a.id_sol id_sol, --REQ 122579
       c.nro_res num_reserva,
       a.fec_usu fecgenreserva,
       c.cod_sap cod_sap,
       d.desmat descripcion,
       c.cantidad,
       e.centro_ori centro,
       (select almacen || ' ' || alm_descripcion alm_descripcion
          from z_mm_configuracion
         where centro = e.centro_ori
           and almacen = e.almacen_ori) almacen, --REQ 130264 Corrección 20100714
       e.centro_des centro_des, --REQ 114000
       e.almacen_des almacen_des, --REQ 114000
       a.codsol,
       a.codsolot sot,
       a.numslc proyecto,
       g.elemento_pep pep,
       f.nomcli cliente,
       g.nombre contrata,
       a.transaccion,
       e.observacion observacion,
       f.codcli codcli,
       null fec_atencion, --REQ 122579
       null ruc, --REQ 122579
       'Traslado' sol_res,
       (SELECT d.descripcion FROM operacion.tipopedd m, operacion.opedd d WHERE m.abrev = 'EST_RES_SAPSGA' AND m.tipopedd = d.tipopedd AND d.codigon = c.estado_sap) estado_res
/*       decode(nvl(c.flg_anular, 0),
              0,
              'Generado',
              1,
              'Por anular',
              2,
              'Anulado') estado_res --REQ 135592*/
  from financial.solicitud_mat       a,
       financial.solicitud_mat_det   g,
       financial.sol_mat_det_sol_res c,
       produccion.almtabmat          d,
       traslado_almacen              e,
       vtatabcli                     f,
       contrata                      g
 where a.id_sol = g.id_sol
   and g.id_lin_det = c.id_lin_det
   and c.estado_int_res = 2
   and c.flg_reserva = 'S'
   and a.id_sol = c.id_sol
   and c.codmat = d.codmat
   and a.codsolot = e.codsolot
   and g.orden = e.orden
   and a.codcli = f.codcli(+)
   and a.codcon = g.codcon(+)
union all -- REQ 130264 Tarjetas Prepago
select a.idsolprepago,
       a.idreserva,
       a.fecgen,
       b.coditem,
       b.desctipo,
       b.cantidad,
       b.plant,
       (select almacen || ' ' || alm_descripcion alm_descripcion
          from z_mm_configuracion
         where almacen = b.stge_loc
           and centro = b.plant) almacen,
       '' centro_des,
       '' almacen_des,
       b.usureg,
       0 sot,
       '' proyecto,
       '' pep,
       c.nomcli cliente,
       '' contrata,
       0 transaccion,
       b.observ,
       a.codcli,
       sysdate fec_atencion,
       d.abrdid || '-' || c.ntdide ruc,
       'Tarjetas' tipo,
       '' estado_res --REQ 135592
  from solprepago     a,
       int_solprepago b,
       vtatabcli      c,
       vtatipdid      d
 where a.idsolprepago = b.idsolprepago
   and a.codcli = c.codcli(+)
   and c.tipdide = d.tipdide(+);