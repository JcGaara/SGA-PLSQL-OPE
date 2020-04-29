CREATE OR REPLACE VIEW OPERACION.V_DESPACHO_MASIVO
AS 
select f.tipproyecto servicio, /****** DTH ******/
       to_char(a.codsolot) acta_instalacion,
       (select min(con.nombre)
          from reginsdth reg, contrata con
         where codsolot = a.codsolot
           and reg.codcon = con.codcon) contrata,
       (select min(reg.codcon)
          from reginsdth reg
         where reg.codsolot = a.codsolot) codcon,
       trunc(a.fecfdis) fecliq,
       null fec_cont,
       a.codsolot,
       trim(c.cod_sap) material,
       a.cantidad cantidad,
       a.costo,
       221 clase_mov,
       ('PEVA') centro,
       (select almacen /*|| '-' || alm_descripcion almacen*/ --1.0
          from z_mm_configuracion c
         where c.operador in
               (select a.idsucxcontrata
                  from sucursalxcontrata a, deptxcontrata b
                 where a.codcon in
                       (select min(r.codcon)
                          from reginsdth r
                         where r.codsolot = a.codsolot)
                   and a.idsucxcontrata = b.idsucxcontrata
                   and trim(b.codest) in
                       (select trim(codest)
                          from v_ubicaciones
                         where codubi =
                               (select distinct codubi
                                  from solotpto
                                 where codsolot = a.codsolot)))
           and c.centro = 'PEVA'
           and rownum = 1) almacen,
       ('') des_alm,
       '' lote,
       '' reserva,
       '' posicion,
       a.pep pep,
       a.numserie serie,
       a.flg_despacho despachado,
       a.observacion,
       g.descripcion tipo_trabajo,
       h.descripcion est_sot,
       d.estsol estsol,
       d.tiptra tiptra,
       d.observacion obser_sot,
       j.desmotivo motivo_venta,
       a.punto,
       a.orden,
       a.trans_despacho,
       a.nro_res,
       a.nro_res_l,
       a.pep_leasing,
       f.tipproyecto,
       a.tipequ,
       k.descripcion etapa,
       '' tipo_venta,
       d.fecusu fecha_gen_sot,
       d.codcli codigo_cliente,
       d.recosi incidencia,
       c.desmat desmat
  from solotptoequ        a,
       tipequ             b,
       almtabmat          c,
       solot              d,
       vtatabslcfac       e,
       soluciones         f,
       tiptrabajo         g,
       estsol             h,
       vtatabprecon       i,
       vtatabmotivo_venta j,
       etapa              k
 where a.tipequ = b.tipequ(+)
   and b.codtipequ = c.codmat(+)
   and a.codsolot = d.codsolot
   and d.numslc = e.numslc
   and e.idsolucion = f.idsolucion
   and d.tiptra = g.tiptra
   and d.estsol = h.estsol
   and a.codeta = k.codeta
   and e.numslc = i.numslc(+)
   and i.codmotivo_tc = j.codmotivo(+)
   and f.tipproyecto = 1
union all
select f.tipproyecto servicio, /******  HFC  ******/
       (select min(acta_instalacion)
          from solotpto_id
         where codsolot = a.codsolot
           and acta_instalacion is not null) acta_instalacion,
       (select decode(count(distinct b1.codcon),
                      1,
                      min(b1.nombre),
                      'TECNICOS BOGA')
          from solotpto_id a1, contrata b1
         where a1.codsolot = a.codsolot
           and a1.codcon = b1.codcon
           and a1.codcon is not null
           and not a1.codcon = 123) contrata,
       (select decode(count(distinct b1.codcon), 1, min(b1.codcon), 123)
          from solotpto_id a1, contrata b1
         where a1.codsolot = a.codsolot
           and a1.codcon = b1.codcon
           and a1.codcon is not null
           and not a1.codcon = 123) codcon,
       trunc((select min(trs.feceje)
               from trssolot trs
              where trs.codsolot = a.codsolot)) fecliq, --<req. 112471>
       null fec_cont,
       a.codsolot,
       trim(c.cod_sap) material,
       a.cantidad cantidad,
       a.costo,
       221 clase_mov,
       ('PEVA') centro,
       (select almacen /*|| '-' || alm_descripcion almacen*/ --1.0
          from z_mm_configuracion c
         where c.operador in
               (select a.idsucxcontrata
                  from sucursalxcontrata a, deptxcontrata b
                 where a.codcon in (select decode(count(distinct b1.codcon),
                                                  1,
                                                  min(b1.codcon),
                                                  123)
                                      from solotpto_id a1, contrata b1
                                     where a1.codsolot = a.codsolot
                                       and a1.codcon = b1.codcon
                                       and a1.codcon is not null
                                       and not a1.codcon = 123)
                   and a.idsucxcontrata = b.idsucxcontrata
                   and trim(b.codest) in
                       (select trim(codest)
                          from v_ubicaciones
                         where codubi =
                               (select distinct codubi
                                  from solotpto
                                 where codsolot = a.codsolot)))
           and c.centro = 'PEVA'
           and rownum = 1) almacen,
       ('') des_alm,
       '' lote,
       '' reserva,
       '' posicion,
       a.pep pep,
       a.numserie serie,
       a.flg_despacho despachado,
       a.observacion,
       g.descripcion,
       h.descripcion,
       d.estsol estsol,
       d.tiptra tiptra,
       d.observacion obser_sot,
       '' motivo_venta,
       a.punto,
       a.orden,
       a.trans_despacho,
       a.nro_res,
       a.nro_res_l,
       a.pep_leasing,
       f.tipproyecto,
       a.tipequ,
       i.descripcion etapa,
       '' tipo_venta,
       d.fecusu fecha_gen_sot,
       d.codcli codigo_cliente,
       d.recosi incidencia,
       c.desmat desmat
  from solotptoequ  a,
       tipequ       b,
       almtabmat    c,
       solot        d,
       vtatabslcfac e,
       soluciones   f,
       tiptrabajo   g,
       estsol       h,
       etapa        i
 where a.tipequ = b.tipequ(+)
   and b.codtipequ = c.codmat(+)
   and a.codsolot = d.codsolot
   and d.numslc = e.numslc
   and e.idsolucion = f.idsolucion
   and d.tiptra = g.tiptra
   and d.estsol = h.estsol
   and f.tipproyecto = 2
   and a.codeta = i.codeta
union all
select f.tipproyecto servicio, /******  CDMA  ******/
       to_char(a.codsolot) acta_instalacion,
       (select nombre
          from contrata
         where codcon =
               nvl((select codcon
                     from vtatabect
                    where codect in (select codsupvta
                                       from vtatabect
                                      where codect = e.codsupvta)),
                   1)) contrata,
       (nvl((select codcon
              from vtatabect
             where codect in (select codsupvta
                                from vtatabect
                               where codect = e.codsupvta)),
            1)) codcon,
       trunc(a.fecfdis) fecliq,
       null fec_cont,
       a.codsolot,
       c.cod_sap material,
       a.cantidad cantidad,
       a.costo,
       221 clase_mov,
       ('PEVA') centro,
       (select almacen /*|| '-' || alm_descripcion almacen*/ --1.0
          from z_mm_configuracion c
         where c.operador in
               (select a.idsucxcontrata
                  from sucursalxcontrata a, deptxcontrata b
                 where a.codcon in (nvl((select codcon
                                          from vtatabect
                                         where codect in
                                               (select codsupvta
                                                  from vtatabect
                                                 where codect = e.codsupvta)),
                                        1))
                   and a.idsucxcontrata = b.idsucxcontrata
                   and trim(b.codest) in
                       (select trim(codest)
                          from v_ubicaciones
                         where codubi =
                               (select distinct codubi
                                  from solotpto
                                 where codsolot = a.codsolot)))
           and c.centro = 'PEVA'
           and rownum = 1) almacen,
       ('') des_alm,
       '' lote,
       '' reserva,
       '' posicion,
       a.pep pep,
       a.numserie serie,
       a.flg_despacho despachado,
       a.observacion,
       g.descripcion,
       h.descripcion,
       d.estsol estsol,
       d.tiptra tiptra,
       d.observacion obser_sot,
       j.desmotivo motivo_venta,
       a.punto,
       a.orden,
       a.trans_despacho,
       a.nro_res,
       a.nro_res_l,
       a.pep_leasing,
       f.tipproyecto,
       a.tipequ,
       k.descripcion etapa,
       (select distinct tty.dscsrv
          from solotpto ssp, tystabsrv tty
         where ssp.codsolot = d.codsolot
           and ssp.codsrvnue = tty.codsrv
           and ssp.codsrvnue in (5054, 4755, 5112, 7903, 7904) -- Req.142132
           and rownum = 1) tipo_venta,
       trunc(d.fecusu) fecha_gen_sot,
       d.codcli codigo_cliente,
       d.recosi incidencia,
       c.desmat desmat
  from solotptoequ        a,
       tipequ             b,
       almtabmat          c,
       solot              d,
       vtatabslcfac       e,
       soluciones         f,
       tiptrabajo         g,
       estsol             h,
       vtatabprecon       i,
       vtatabmotivo_venta j,
       etapa              k
 where a.tipequ = b.tipequ(+)
   and b.codtipequ = c.codmat(+)
   and a.codsolot = d.codsolot
   and d.numslc = e.numslc
   and e.idsolucion = f.idsolucion
   and d.tiptra = g.tiptra
   and d.estsol = h.estsol
   and e.numslc = i.numslc(+)
   and i.codmotivo_tc = j.codmotivo(+)
   and a.codeta = k.codeta
   and f.tipproyecto = 3
--<req. 111186>
union all
select f.tipproyecto servicio, /******  TPI  ******/
       (d.acta_instalacion) acta_instalacion,
       (select min(b1.nombre)
          from solotpto_id a1, contrata b1
         where a1.codsolot = a.codsolot
           and a1.codcon = b1.codcon
           and a1.codcon is not null
           and not a1.codcon = 123) contrata,
       (select min(a1.codcon)
          from solotpto_id a1
         where a1.codsolot = a.codsolot) codcon,
       trunc(a.fecfdis) fecliq,
       null fec_cont,
       a.codsolot,
       trim(c.cod_sap) material,
       a.cantidad cantidad,
       a.costo,
       221 clase_mov,
       ('PEVA') centro,
       (select almacen /*|| '-' || alm_descripcion almacen*/ --1.0
          from z_mm_configuracion c
         where c.operador in
               (select a.idsucxcontrata
                  from sucursalxcontrata a, deptxcontrata b
                 where a.codcon in
                       (select min(a1.codcon)
                          from solotpto_id a1
                         where a1.codsolot = a.codsolot)
                   and a.idsucxcontrata = b.idsucxcontrata
                   and trim(b.codest) in
                       (select trim(codest)
                          from v_ubicaciones
                         where codubi =
                               (select distinct codubi
                                  from solotpto
                                 where codsolot = a.codsolot)))
           and c.centro = 'PEVA'
           and rownum = 1) almacen,
       ('') des_alm,
       '' lote,
       '' reserva,
       '' posicion,
       a.pep pep,
       a.numserie serie,
       a.flg_despacho despachado,
       a.observacion,
       g.descripcion,
       h.descripcion,
       d.estsol estsol,
       d.tiptra tiptra,
       d.observacion obser_sot,
       '' motivo_venta,
       a.punto,
       a.orden,
       a.trans_despacho,
       a.nro_res,
       a.nro_res_l,
       a.pep_leasing,
       f.tipproyecto,
       a.tipequ,
       i.descripcion etapa,
       '' tipo_venta,
       d.fecusu fecha_gen_sot,
       d.codcli codigo_cliente,
       d.recosi incidencia,
       c.desmat desmat
  from solotptoequ  a,
       tipequ       b,
       almtabmat    c,
       solot        d,
       vtatabslcfac e,
       soluciones   f,
       tiptrabajo   g,
       estsol       h,
       etapa        i
 where a.tipequ = b.tipequ(+)
   and b.codtipequ = c.codmat(+)
   and a.codsolot = d.codsolot
   and a.codeta = i.codeta
   and d.numslc = e.numslc
   and e.idsolucion = f.idsolucion
   and d.tiptra = g.tiptra
   and d.estsol = h.estsol
   and f.tipproyecto = 4
union all
select f.tipproyecto servicio, /******  TN  ******/
       (d.acta_instalacion) acta_instalacion,
       (select min(b1.nombre)
          from solotpto_id a1, contrata b1
         where a1.codsolot = a.codsolot
           and a1.codcon = b1.codcon
           and a1.codcon is not null
           and not a1.codcon = 123) contrata,
       (select min(a1.codcon)
          from solotpto_id a1
         where a1.codsolot = a.codsolot) codcon,
       trunc(a.fecfdis) fecliq,
       null fec_cont,
       a.codsolot,
       trim(c.cod_sap) material,
       a.cantidad cantidad,
       a.costo,
       221 clase_mov,
       ('PEVA') centro,
       (select almacen /* || '-' || alm_descripcion almacen*/ --1.0
          from z_mm_configuracion c
         where c.operador in
               (select a.idsucxcontrata
                  from sucursalxcontrata a, deptxcontrata b
                 where a.codcon in
                       (select min(a1.codcon)
                          from solotpto_id a1
                         where a1.codsolot = a.codsolot)
                   and a.idsucxcontrata = b.idsucxcontrata
                   and trim(b.codest) in
                       (select trim(codest)
                          from v_ubicaciones
                         where codubi =
                               (select distinct codubi
                                  from solotpto
                                 where codsolot = a.codsolot)))
           and c.centro = 'PEVA'
           and rownum = 1) almacen,
       ('') des_alm,
       '' lote,
       '' reserva,
       '' posicion,
       a.pep pep,
       a.numserie serie,
       a.flg_despacho despachado,
       a.observacion,
       g.descripcion,
       h.descripcion,
       d.estsol estsol,
       d.tiptra tiptra,
       d.observacion obser_sot,
       '' motivo_venta,
       a.punto,
       a.orden,
       a.trans_despacho,
       a.nro_res,
       a.nro_res_l,
       a.pep_leasing,
       f.tipproyecto,
       a.tipequ,
       i.descripcion etapa,
       '' tipo_venta,
       d.fecusu fecha_gen_sot,
       d.codcli codigo_cliente,
       d.recosi incidencia,
       c.desmat desmat
  from solotptoequ  a,
       tipequ       b,
       almtabmat    c,
       solot        d,
       vtatabslcfac e,
       soluciones   f,
       tiptrabajo   g,
       estsol       h,
       etapa        i
 where a.tipequ = b.tipequ(+)
   and b.codtipequ = c.codmat(+)
   and a.codsolot = d.codsolot
   and a.codeta = i.codeta
   and d.numslc = e.numslc
   and e.idsolucion = f.idsolucion
   and d.tiptra = g.tiptra
   and d.estsol = h.estsol
   and f.tipproyecto = 5
union all
select 7 servicio, /* REQ 130264 Información de Mantenimientos */
       a.acta_instalacion,
       f.nombre,
       a.codcon,
       a.fecha_instalacion,
       null fec_cont,
       a.codsolot,
       e.cod_sap,
       c.cantidad,
       c.costo,
       221,
       ('PEVA') centro,
       (select almacen /*|| '-' || alm_descripcion almacen*/ --1.0
          from z_mm_configuracion cc
         where cc.operador in (select aa.idsucxcontrata
                                 from sucursalxcontrata aa, deptxcontrata bb
                                where aa.codcon in (a.codcon)
                                  and aa.idsucxcontrata = bb.idsucxcontrata
                                  and bb.codest = (g.codest))
           and cc.centro = 'PEVA'
           and rownum = 1) almacen,
       ('') des_alm,
       '' lote,
       '' reserva,
       '' posicion,
       c.pep pep,
       c.numserie serie,
       c.flg_despacho despachado,
       c.observacion,
       h.descripcion,
       i.descripcion,
       b.estsol estsol,
       b.tiptra tiptra,
       k.nomcli obser_sot,
       '' motivo_venta,
       c.punto,
       c.orden,
       c.trans_despacho,
       c.nro_res,
       c.nro_res_l,
       c.pep_leasing,
       7,
       c.tipequ,
       j.descripcion etapa,
       '' tipo_venta,
       b.fecusu fecha_gen_sot,
       b.codcli codigo_cliente,
       b.recosi incidencia,
       e.desmat desmat
  from agendamiento a,
       solot        b,
       solotptoequ  c,
       tipequ       d,
       almtabmat    e,
       contrata     f,
       vtatabdst    g,
       tiptrabajo   h,
       estsol       i,
       etapa        j,
       vtatabcli    k
 where a.codsolot = c.codsolot
   and b.codsolot = c.codsolot
   and b.codcli = k.codcli
   and c.tipequ = d.tipequ
   and d.codtipequ = e.codmat
   and c.codeta = j.codeta
   and a.codcon = f.codcon
   and a.codubi = g.codubi
   and b.tiptra = h.tiptra
   and b.estsol = i.estsol;


