CREATE OR REPLACE PROCEDURE OPERACION.p_requerir_sol_pedido
(numrequisicion in int, newnumrequisicion out number)
IS

  --Variables Cabecera
  r_cab_trans financial.z_ps_transacciones_spw%rowtype;

  cursor cursor_detalle is
      select *
      from financial.z_ps_transacciones_det_spw
      where
      id_requisicion = numrequisicion;

BEGIN

  --Seleccionar Cabecera a duplicar
  select *
  into r_cab_trans
  from financial.z_ps_transacciones_spw
  where id_requisicion = numrequisicion;


  --Insertar Cabecera Duplicada
  insert into financial.z_ps_transacciones_spw
  (id_requisicion, contrata, mes, fecha_entrega,
  estado_linea, status_solweb, nro_web, nro_solped, nro_pedido, requisitor,
  usuario_registro, fecha_registro, modificado_por, fecha_modificacion,
  monto_soles, multa, total, moneda_id,flg_genera,tipo_cambio)
  values
  (financial.z_ps_spw_requisicion_s.nextVal, r_cab_trans.contrata, r_cab_trans.mes, r_cab_trans.fecha_entrega ,
  '1',  r_cab_trans.status_solweb, r_cab_trans.nro_web, r_cab_trans.nro_solped, r_cab_trans.nro_pedido,
  r_cab_trans.requisitor, r_cab_trans.usuario_registro, r_cab_trans.fecha_registro, user, sysdate,
  r_cab_trans.monto_soles , r_cab_trans.multa, r_cab_trans.total, r_cab_trans.moneda_id , r_cab_trans.flg_genera ,
  r_cab_trans.tipo_cambio)
  returning id_requisicion into newnumrequisicion;

  commit;

  --Insertar Detalles Duplicados


    for crs_det in cursor_detalle loop

        insert into financial.z_ps_transacciones_det_spw
        (id_transaccion, id_requisicion, codsolot, punto, orden, codeta,
        fecha_valorizacion, estado_linea, usuario_registro, fecha_registro,
        modificado_por, fecha_modificacion, numslc, monto_soles, multa, total)
        values (financial.z_ps_spw_trxn_s.nextVal, newnumrequisicion, crs_det.codsolot, crs_det.punto, crs_det.orden,
        crs_det.codeta, crs_det.fecha_valorizacion, '1',crs_det.usuario_registro,
        crs_det.fecha_registro, user, sysdate, crs_det.numslc  , crs_det.monto_soles, crs_det.multa, crs_det.total);

        --Actualizar el flag sp_generado de la solotptoeta

        if (r_cab_trans.flg_genera = 1) then
              update operacion.solotptoetamat
              set flg_spgenerado = 1
              where codsolot = crs_det.codsolot
              and   punto     = crs_det.punto
              and   orden     = crs_det.orden
              and   flg_spgenerado = 2;

              update operacion.solotptoetaact
              set flg_spgenerado = 1
              where codsolot = crs_det.codsolot
              and   punto     = crs_det.punto
              and   orden     = crs_det.orden
              and   flg_spgenerado = 2;

         end if;

         if (r_cab_trans.flg_genera = 2) then

              update operacion.solotptoetaact
              set flg_spgenerado = 1
              where codsolot = crs_det.codsolot
              and   punto     = crs_det.punto
              and   orden     = crs_det.orden
              and   flg_spgenerado = 2;

         end if;


         if (r_cab_trans.flg_genera = 3) then
              update operacion.solotptoetamat
              set flg_spgenerado = 1
              where codsolot = crs_det.codsolot
              and   punto     = crs_det.punto
              and   orden     = crs_det.orden
              and   flg_spgenerado = 2;
         end if;

         commit;

    end loop;

--    close cursor_detalle;


END;
/


