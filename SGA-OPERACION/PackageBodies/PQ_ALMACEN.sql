CREATE OR REPLACE PACKAGE BODY OPERACION.pq_almacen as

  procedure p_envia_correo_reserva(a_transaccion in number,
                                   a_tipo        in number)

   is
    f_doc     utl_file.file_type;
    v_correo  varchar2(200);
    v_ruta    varchar2(200);
    v_cuerpo  varchar2(4000);
    vnomarch  varchar2(400);
    v_subject varchar2(400);
    cursor c_res_cab is
      select a.transaccion transaccion,
             to_char(sysdate, 'dd/mm/yyyy hh:mm:ss') fec_usu,
             a.codsol,
             a.codsolot,
             d.nombre contrata,
             c.nomcli,
             a.numslc,
             a.cid
        from solicitud_mat a, solot b, vtatabcli c, contrata d
       where transaccion = a_transaccion
         and a.codsolot = b.codsolot
         and b.codcli = c.codcli
         and a.codcon = d.codcon(+);

    cursor c_res_det_m is
      select a.transaccion,
             c.cod_sap cod_sap,
             a.codsolot sot,
             c.cantidad,
             d.desmat descripcion,
             a.codom om,
             e.observacion observacion,
             'Reserva' sol_res,
             c.nro_res num_reserva,
             c.nro_solped_web num_sol_sga,
             c.nro_solped_sap,
             e.centrosap centro,
             e.almacensap almacen
        from financial.solicitud_mat       a,
             financial.solicitud_mat_det   g,
             financial.sol_mat_det_sol_res c,
             produccion.almtabmat          d,
             solotptoetamat                e
       where a.id_sol = g.id_sol
         and g.id_lin_det = c.id_lin_det
         and c.estado_int_res = 2
         and c.flg_reserva = 'S'
         and a.id_sol = c.id_sol
         and c.codmat = d.codmat
         and g.idmat = e.idmat
         and a.transaccion = a_transaccion;

    cursor c_res_det_e is
      select a.transaccion,
             c.cod_sap cod_sap,
             a.codsolot sot,
             c.cantidad,
             d.desmat descripcion,
             a.codom om,
             e.observacion observacion,
             'Reserva' sol_res,
             c.nro_res num_reserva,
             c.nro_solped_web num_sol_sga,
             c.nro_solped_sap,
             e.centrosap centro,
             e.almacensap almacen
        from financial.solicitud_mat       a,
             financial.solicitud_mat_det   g,
             financial.sol_mat_det_sol_res c,
             produccion.almtabmat          d,
             solotptoequ                   e
       where a.id_sol = g.id_sol
         and g.id_lin_det = c.id_lin_det
         and c.estado_int_res = 2
         and c.flg_reserva = 'S'
         and a.id_sol = c.id_sol
         and c.codmat = d.codmat
         and a.codsolot = e.codsolot
         and g.punto = e.punto
         and g.orden = e.orden
         and a.transaccion = a_transaccion;

  begin
    v_cuerpo := '';
    v_cuerpo := v_cuerpo || '' || chr(13);
    v_cuerpo := v_cuerpo || 'Envio de Correo Automático' || chr(13);
    v_cuerpo := v_cuerpo || '' || chr(13);
    vnomarch := 'Tran_Sol_Mat - ' || to_char(a_transaccion) || '.txt';
    --<7.0>
    v_ruta := '/u03/oracle/PESGAPRD/UTL_FILE'; -- para produccion
    --v_ruta := '/u03/oracle/PESGADES/UTL_FILE'; -- para pruebas
    --v_ruta := '/u92/oracle/peprdrac1/general/operaciones'; -- para pruebas
    --</7.0>
    f_doc := utl_file.fopen(v_ruta, vnomarch, 'w');

    for c_c in c_res_cab loop
      v_subject := 'Reserva - SOT ' || to_char(c_c.codsolot) || ' - ' ||
                   substr(c_c.nomcli, 1, 40); --<7.0>
      utl_file.put_line(f_doc, v_subject || chr(13));
      utl_file.put_line(f_doc,
                        'Transacción        : ' || c_c.transaccion ||
                        chr(13));
      utl_file.put_line(f_doc,
                        'Fecha de reserva   : ' || c_c.fec_usu || chr(13));
      utl_file.put_line(f_doc,
                        'Usuario de reserva : ' || c_c.codsol || chr(13));
      utl_file.put_line(f_doc,
                        'SOT                : ' || c_c.codsolot || chr(13));
      utl_file.put_line(f_doc,
                        'Contrata           : ' || c_c.contrata || chr(13));
      utl_file.put_line(f_doc,
                        'Cliente            : ' || c_c.nomcli || chr(13));
      utl_file.put_line(f_doc,
                        'Proyecto           : ' || c_c.numslc || chr(13));
      utl_file.put_line(f_doc,
                        'CID                : ' || c_c.cid || chr(13));
    end loop;
    if a_tipo = 1 then
      --Equipos
      for c_e in c_res_det_e loop
        utl_file.put_line(f_doc,
                          '---------------------------------------' ||
                          chr(13));
        utl_file.put_line(f_doc,
                          '*  R/S                : ' || c_e.sol_res ||
                          chr(13));
        utl_file.put_line(f_doc,
                          '*  Codigo SAP         : ' || c_e.cod_sap ||
                          chr(13));
        utl_file.put_line(f_doc,
                          '*  Reserva            : ' || c_e.num_reserva ||
                          chr(13));
        utl_file.put_line(f_doc,
                          '*  Descripción        : ' || c_e.descripcion ||
                          chr(13));
        utl_file.put_line(f_doc,
                          '*  Cantidad           : ' || c_e.cantidad ||
                          chr(13));
        utl_file.put_line(f_doc,
                          '*  Observaciones      : ' || c_e.observacion ||
                          chr(13)); --
        utl_file.put_line(f_doc,
                          '*  Centro             : ' || c_e.centro ||
                          chr(13)); --
        utl_file.put_line(f_doc,
                          '*  Almacén            : ' || c_e.almacen ||
                          chr(13)); --
        utl_file.put_line(f_doc,
                          '*  SOL SAP            : ' || c_e.nro_solped_sap ||
                          chr(13));
        utl_file.put_line(f_doc,
                          '*  SOL WEB            : ' || c_e.num_sol_sga ||
                          chr(13));
      end loop;
    else
      for c_m in c_res_det_m loop
        utl_file.put_line(f_doc,
                          '---------------------------------------' ||
                          chr(13));
        utl_file.put_line(f_doc,
                          '*  R/S                : ' || c_m.sol_res ||
                          chr(13));
        utl_file.put_line(f_doc,
                          '*  Codigo SAP         : ' || c_m.cod_sap ||
                          chr(13));
        utl_file.put_line(f_doc,
                          '*  Reserva            : ' || c_m.num_reserva ||
                          chr(13));
        utl_file.put_line(f_doc,
                          '*  Descripción        : ' || c_m.descripcion ||
                          chr(13));
        utl_file.put_line(f_doc,
                          '*  Cantidad           : ' || c_m.cantidad ||
                          chr(13));
        utl_file.put_line(f_doc,
                          '*  Observaciones      : ' || c_m.observacion ||
                          chr(13)); --
        utl_file.put_line(f_doc,
                          '*  Centro             : ' || c_m.centro ||
                          chr(13)); --
        utl_file.put_line(f_doc,
                          '*  Almacén            : ' || c_m.almacen ||
                          chr(13)); --
        utl_file.put_line(f_doc,
                          '*  SOL SAP            : ' || c_m.nro_solped_sap ||
                          chr(13));
        utl_file.put_line(f_doc,
                          '*  SOL WEB            : ' || c_m.num_sol_sga ||
                          chr(13));
      end loop;
    end if;
    utl_file.fclose(f_doc);
    --<7.0>
    p_envia_correo_c_attach(v_subject,
                            'dl-pe-almacenes',
                            v_cuerpo,
                            sendmailjpkg.attachments_list(v_ruta || '/' ||
                                                          vnomarch),
                            'SGA'); -- para produccion

    select email into v_correo from usuarioope where usuario = user; -- para produccion
    --select email into v_correo from usuarioope where usuario = 'ECAQUI'; -- para pruebas
    if v_correo is not null then
      p_envia_correo_c_attach(v_subject,
                              v_correo,
                              v_cuerpo,
                              sendmailjpkg.attachments_list(v_ruta || '/' ||
                                                            vnomarch),
                              'SGA');
    end if;
    --</7.0>

  end;

  --<REQ ID = 103416>
  procedure p_envia_correo_reserva_anulada(a_transaccion in number,
                                           a_solot       in number,
                                           a_tipo        in number)

   is
    f_doc     utl_file.file_type;
    v_correo  varchar2(200);
    v_ruta    varchar2(200);
    v_cuerpo  varchar2(4000);
    vnomarch  varchar2(400);
    v_subject varchar2(400);
    v_nombre  varchar2(200);
    cursor c_res_cab is
      select a.transaccion transaccion,
             f.reservation,
             f.user_cancel,
             f.transaccion_anula,
             to_char(a.fec_usu, 'dd/mm/yyyy hh24:mm:ss') fec_usu,
             a.codsol,
             a.codsolot,
             d.nombre contrata,
             a.numslc,
             a.cid,
             to_char(sysdate, 'dd/mm/yyyy hh24:mm:ss') fecanula
        from solicitud_mat a, contrata d, z_mm_reservationheader f
       where f.transaccion_anula = a_transaccion
         and a.codsolot = a_solot
         and a.id_sol = f.id_sol
         and a.codcon = d.codcon(+);

    cursor c_res_det_m(p_reserva in varchar2) is
      select a.transaccion,
             c.cod_sap cod_sap,
             a.codsolot sot,
             c.cantidad,
             d.desmat descripcion,
             a.codom om,
             e.observacion observacion,
             'Reserva' sol_res,
             c.nro_res num_reserva,
             c.nro_solped_web num_sol_sga,
             c.nro_solped_sap,
             e.centrosap centro,
             e.almacensap almacen
        from z_mm_reservationheader        f,
             financial.solicitud_mat       a,
             financial.solicitud_mat_det   g,
             financial.sol_mat_det_sol_res c,
             produccion.almtabmat          d,
             solotptoetamat                e
       where f.transaccion_anula = a_transaccion
         and a.id_sol = f.id_sol
         and a.id_sol = g.id_sol
         and g.id_lin_det = c.id_lin_det
         and a.id_sol = c.id_sol
         and c.codmat = d.codmat
         and g.idmat = e.idmat
         and to_char(c.nro_res) = p_reserva;

    cursor c_res_det_e(p_reserva in varchar2) is
      select a.transaccion,
             c.cod_sap cod_sap,
             a.codsolot sot,
             c.cantidad,
             d.desmat descripcion,
             a.codom om,
             e.observacion observacion,
             'Reserva' sol_res,
             c.nro_res num_reserva,
             c.nro_solped_web num_sol_sga,
             c.nro_solped_sap,
             e.centrosap centro,
             e.almacensap almacen
        from z_mm_reservationheader        f,
             financial.solicitud_mat       a,
             financial.solicitud_mat_det   g,
             financial.sol_mat_det_sol_res c,
             produccion.almtabmat          d,
             solotptoequ                   e
       where f.transaccion_anula = a_transaccion
         and a.id_sol = f.id_sol
         and a.id_sol = g.id_sol
         and g.id_lin_det = c.id_lin_det
         and a.id_sol = c.id_sol
         and c.codmat = d.codmat
         and a.codsolot = e.codsolot
         and g.punto = e.punto
         and g.orden = e.orden
         and to_char(c.nro_res) = p_reserva;

  begin
    v_cuerpo := '';
    v_cuerpo := v_cuerpo || '' || chr(13);
    v_cuerpo := v_cuerpo || 'Envio de Correo Automático' || chr(13);
    v_cuerpo := v_cuerpo || '' || chr(13);
    vnomarch := 'RESERVAS_ANULADAS_Nro' ||
                lpad(to_char(a_transaccion), 6, '0') || '_SOT_' ||
                to_char(a_solot) || '.txt';
    v_ruta   := '/u03/oracle/PESGAPRD/UTL_FILE';
    /*v_ruta :=  '/u92/oracle/peprdrac1/general/operaciones';*/
    f_doc := utl_file.fopen(v_ruta, vnomarch, 'w');

    select nomcli
      into v_nombre
      from vtatabcli
     where codcli = (select codcli from solot where codsolot = a_solot);

    v_subject := 'Reservas Anuladas - SOT ' || to_char(a_solot) || ' - ' ||
                 substr(v_nombre, 1, 40);

    for c_c in c_res_cab loop

      utl_file.put_line(f_doc, 'RESERVAS ANULADAS' || chr(13) || chr(13));
      utl_file.put_line(f_doc,
                        '*  Reserva         : ' || c_c.reservation ||
                        chr(13));
      utl_file.put_line(f_doc, v_subject || chr(13));
      utl_file.put_line(f_doc,
                        'Fecha de anulación : ' || c_c.fecanula || chr(13));
      utl_file.put_line(f_doc,
                        'Usuario generador  : ' || c_c.user_cancel ||
                        chr(13));
      utl_file.put_line(f_doc,
                        'Contrata           : ' || c_c.contrata || chr(13));
      utl_file.put_line(f_doc,
                        'Cliente            : ' || v_nombre || chr(13) ||
                        chr(13));
      utl_file.put_line(f_doc, 'LINEAS ANULADAS' || chr(13) || chr(13));
      if a_tipo = 1 then
        --Equipos
        for c_e in c_res_det_e(c_c.reservation) loop
          utl_file.put_line(f_doc,
                            '---------------------------------------' ||
                            chr(13));
          utl_file.put_line(f_doc,
                            '*  Codigo SAP         : ' || c_e.cod_sap ||
                            chr(13));
          utl_file.put_line(f_doc,
                            '*  Descripción        : ' || c_e.descripcion ||
                            chr(13));
          utl_file.put_line(f_doc,
                            '*  Cantidad           : ' || c_e.cantidad ||
                            chr(13));
          utl_file.put_line(f_doc,
                            '*  Observaciones      : ' || c_e.observacion ||
                            chr(13));
          utl_file.put_line(f_doc,
                            '*  Centro             : ' || c_e.centro ||
                            chr(13));
          utl_file.put_line(f_doc,
                            '*  Almacén            : ' || c_e.almacen ||
                            chr(13));
        end loop;
      else
        for c_m in c_res_det_m(c_c.reservation) loop
          utl_file.put_line(f_doc,
                            '---------------------------------------' ||
                            chr(13));
          utl_file.put_line(f_doc,
                            '*  Codigo SAP         : ' || c_m.cod_sap ||
                            chr(13));
          utl_file.put_line(f_doc,
                            '*  Descripción        : ' || c_m.descripcion ||
                            chr(13));
          utl_file.put_line(f_doc,
                            '*  Cantidad           : ' || c_m.cantidad ||
                            chr(13));
          utl_file.put_line(f_doc,
                            '*  Observaciones      : ' || c_m.observacion ||
                            chr(13));
          utl_file.put_line(f_doc,
                            '*  Centro             : ' || c_m.centro ||
                            chr(13));
          utl_file.put_line(f_doc,
                            '*  Almacén            : ' || c_m.almacen ||
                            chr(13));
        end loop;
      end if;
      utl_file.put_line(f_doc,
                        '=======================================' ||
                        chr(13));
    end loop;

    utl_file.fclose(f_doc);
    p_envia_correo_c_attach(v_subject,
                            'dl-pe-almacenes',
                            v_cuerpo,
                            sendmailjpkg.attachments_list(v_ruta || '/' ||
                                                          vnomarch),
                            'SGA');
    select email into v_correo from usuarioope where usuario = user;
    if v_correo is not null then
      p_envia_correo_c_attach(v_subject,
                              v_correo,
                              v_cuerpo,
                              sendmailjpkg.attachments_list(v_ruta || '/' ||
                                                            vnomarch),
                              'SGA');
    end if;

  end;
  --</REQ>

  /******************************************************************************
  Version     Fecha       Autor           Descripción.
  ---------  ----------  ---------------  ------------------------------------
  1.0        10/08/2009                   Procedimiento que genera el consolidado de Materiales y Almacenes que se
                                          va descargar del SAP consultando el Stock disponible de los materiales en cada almacen
  ******************************************************************************/

  procedure p_stock_despacho(a_tipproyecto number,
                             a_fecini      date,
                             a_fecfin      date,
                             a_codcon      number)

   is

    n_idsucxcontrata number;
    v_error_sqlm     varchar2(1000);
    n_canttotalproc  number;
    l_es_mat         number;
    cursor c_stk_mat is --Consolidado de Almacenes y materiales que intervienen en la descarga
      select codcon, codest, material, sum(cantidad) canttotalproc
        from (select v_d.codcon,
                     (select min(v1.codest)
                        from solotpto s1, v_ubicaciones v1
                       where s1.codsolot = v_d.codsolot
                         and s1.codubi = v1.codubi) codest,
                     v_d.material,
                     v_d.cantidad
                from v_despacho_masivo v_d
               where v_d.servicio = a_tipproyecto
                 and v_d.fecliq between a_fecini and a_fecfin
                 and codcon = nvl(a_codcon, codcon))
       group by codcon, codest, material;

    cursor c_centro is
      select * from z_mm_configuracion where operador = n_idsucxcontrata;

  begin
    delete maestro_stock_mat;
    --Maestro de Materiales
    for c_s in c_stk_mat loop
      begin
        select a.idsucxcontrata
          into n_idsucxcontrata
          from sucursalxcontrata a, deptxcontrata c
         where a.codcon = c_s.codcon
           and a.idsucxcontrata = c.idsucxcontrata
           and trim(c.codest) = c_s.codest;
      exception
        when others then
          v_error_sqlm := sqlerrm;
          insert into error_despacho_masivo
            (desc_error, error_sqlm, codcon, material)
          values
            ('Revisar la configuracion de Sucursales por Contrata',
             v_error_sqlm,
             c_s.codcon,
             c_s.material); --Insertar informacion de Error
      end;
      for c_c in c_centro loop
        n_canttotalproc := 0;
        if c_c.centro = 'PEVA' then
          n_canttotalproc := c_s.canttotalproc;
        end if;
        --Solo se solicita stock de los materiales : TIPOPEDD =240
        select count(1)
          into l_es_mat
          from opedd
         where tipopedd = 240
           and c_s.material = codigoc;
        if l_es_mat > 0 then
          insert into maestro_stock_mat
            (idalm,
             cod_sap,
             centro,
             almacen,
             cantidad,
             operador,
             canttotalproc,
             cantconsumida)
          values
            (null,
             c_s.material,
             c_c.centro,
             c_c.almacen,
             0,
             n_idsucxcontrata,
             n_canttotalproc,
             0);
        end if;
      end loop;
    end loop;
    --Procedimiento de Interfaces SGA-SAP

  end;

  /******************************************************************************
  Version     Fecha       Autor           Descripción.
  ---------  ----------  ---------------  ------------------------------------
  1.0
  ******************************************************************************/

  procedure p_despacho_masivo(a_tipproyecto    number,
                              a_fecini         date,
                              a_fecfin         date,
                              a_codcon         number,
                              a_trans_despacho out number)

   is

    v_centro          varchar2(30);
    v_almacen         varchar2(30);
    v_codubi          varchar2(30);
    n_idsucxcontrata  number;
    l_cont_sot        number;
    n_id_despacho     number;
    n_no_item         number;
    pv_valido         varchar2(1000);
    pv_error          varchar2(1000);
    v_error_sqlm      varchar2(1000);
    l_cont_pep        number;
    n_cantconsumida   number;
    l_es_mat          number;
    ln_trans_despacho number;
    vnomarch          varchar2(400);
    f_doc             utl_file.file_type;
    v_ruta            varchar2(200);
    v_subject         varchar2(400);
    v_cuerpo          varchar2(4000);
    v_tipproyecto     varchar2(30);
    d_fecliq          date; --<4.0>
    cursor c_sot_hfc is
      select distinct codsolot
        from v_despacho_masivo
       where servicio = a_tipproyecto
         and codcon = nvl(a_codcon, codcon)
         and fecliq between a_fecini and a_fecfin
       order by codsolot;

    cursor c_equ_hfc is
      select acta_instalacion,
             codcon,
             fecliq,
             codsolot,
             tipequ,
             material,
             cantidad,
             costo,
             serie,
             despachado,
             estsol,
             tiptra,
             nro_res,
             nro_res_l,
             pep,
             pep_leasing,
             tipproyecto,
             centro,
             substr(almacen, 1, 4) almacen
        from v_despacho_masivo
       where servicio = a_tipproyecto
         and codcon = nvl(a_codcon, codcon)
         and fecliq between a_fecini and a_fecfin
       order by codsolot;

    cursor c_stock_sap is
      select * from z_mm_stock_despacho_masivo;

    --Listado de Errores
    cursor c_error is
      select a.id_despacho,
             a.documento sot,
             a.descripcion acta_instal,
             b.material,
             b.centro,
             b.almacen,
             b.cantidad,
             b.estado,
             b.mensaje_estado mensaje
        from z_mm_despacho_masivo a, z_mm_despacho_masivo_detalle b
       where a.trans_despacho = ln_trans_despacho
         and a.id_despacho = b.id_despacho
         and b.estado = 'E';

  begin
    select descripcion
      into v_tipproyecto
      from tipproyecto
     where tipproyecto = a_tipproyecto;
    --Transaccion de Despacho Masivo
    select sq_trans_despacho.nextval into ln_trans_despacho from dual;
    a_trans_despacho := ln_trans_despacho;
    --Actualizar las cantidades en base a la consulta de Stock Disponible
    for c_sd in c_stock_sap loop
      update maestro_stock_mat a
         set a.cantidad = c_sd.cantidad, a.cantconsumida = c_sd.cantidad
       where a.cod_sap = c_sd.material
         and a.centro = c_sd.centro
         and a.almacen = c_sd.almacen;
    end loop;

    --Pega PEP y Asigna Presupuesto
    for c_sot in c_sot_hfc loop
      --Actualiza la transaccion en los componentes YA QUE LOS
      --COMPONENTES POR ÚLTIMA DEF VAN A TENER ETAPAS DIFERENTES TB--
      select count(*)
        into l_cont_pep
        from solotptoequ
       where codsolot = c_sot.codsolot
         and pep is not null;
      if l_cont_pep = 0 then
        financial.pq_z_mm_pep_misc.sp_popula_peps_equmas(c_sot.codsolot,
                                                         pv_valido,
                                                         pv_error);
        financial.pq_z_mm_pep_misc.sp_popula_peps_matmas(c_sot.codsolot,
                                                         pv_valido,
                                                         pv_error);
        update solotptoequ a
           set flg_despacho = 1, trans_despacho = ln_trans_despacho
         where a.codsolot = c_sot.codsolot
           and a.flgreq = 0
           and a.costo > 0
           and a.orden in (select orden
                             from solotptoequ
                            where codsolot = a.codsolot
                              and punto = a.punto
                              and orden = a.orden
                              and fecfdis is not null);
      end if;
    end loop;

    --Envia Informacion a DespachoMasivo
    for c_eq in c_equ_hfc loop
      select min(codubi)
        into v_codubi
        from solotpto
       where codsolot = c_eq.codsolot;
      begin
        select a.idsucxcontrata
          into n_idsucxcontrata
          from sucursalxcontrata a, deptxcontrata c, v_ubicaciones d
         where a.codcon = c_eq.codcon
           and d.codubi = v_codubi
           and a.idsucxcontrata = c.idsucxcontrata
           and trim(c.codest) = trim(d.codest)
           and d.codpai = 51;
      exception
        when others then
          v_error_sqlm := sqlerrm;
          insert into error_despacho_masivo
            (desc_error, error_sqlm, codcon, material, codsolot)
          values
            ('Revisar la configuracion de Sucursales por Contrata', --Mas de una sucursal por Departamento o ninguna
             v_error_sqlm,
             c_eq.codcon,
             c_eq.material,
             c_eq.codsolot); --Insertar informacion de Error
      end;
      --Seleccionamos el Centro y el Almacen
      v_centro  := c_eq.centro;
      v_almacen := c_eq.almacen;

      begin
        --<4.0
        --Para el Piloto la fecha de Liquidacion sera FECFDIS de SOLOTPTOEQU
        d_fecliq := null;
        if a_tipproyecto = 2 then
          select trunc(min(fecfdis))
            into d_fecliq
            from solotptoequ
           where codsolot = c_eq.codsolot;
        end if;
        --4.0>
        insert into despacho_masivo
          (codsolot,
           tipequ,
           cod_sap,
           cantidad,
           costo,
           numserie,
           fecins,
           observacion,
           fecfdis,
           nro_res,
           nro_res_l,
           pep,
           pep_leasing,
           codcon,
           idsucxcontrata,
           centrosap,
           almacensap,
           acta_instalacion,
           tipproyecto,
           trans_despacho)
        values
          (c_eq.codsolot,
           c_eq.tipequ,
           c_eq.material,
           c_eq.cantidad,
           c_eq.costo,
           c_eq.serie,
           c_eq.fecliq,
           '',
           c_eq.fecliq,
           c_eq.nro_res,
           c_eq.nro_res_l,
           c_eq.pep,
           c_eq.pep_leasing,
           c_eq.codcon,
           n_idsucxcontrata,
           v_centro,
           v_almacen,
           c_eq.acta_instalacion,
           c_eq.tipproyecto,
           ln_trans_despacho);
      exception
        when others then
          v_error_sqlm := sqlerrm;
          insert into error_despacho_masivo
            (desc_error, error_sqlm, codcon, material, codsolot)
          values
            ('Problemas al Insertar en Tabla DESPACHO_MASIVO.',
             v_error_sqlm,
             c_eq.codcon,
             c_eq.material,
             c_eq.codsolot);
      end;
      --z_mm_despacho_masivo
      select count(*)
        into l_cont_sot
        from z_mm_despacho_masivo
       where documento = c_eq.codsolot;
      if l_cont_sot = 0 then
        select sq_id_despacho.nextval into n_id_despacho from dual;
        insert into z_mm_despacho_masivo
          (id_despacho,
           tipo_documento,
           documento,
           descripcion,
           tipo_movimiento,
           operador,
           fecha_documento,
           fecha_contable,
           id_grupo_despacho,
           documento_material,
           anho_doc_material,
           archivo,
           fecha_registro,
           fecha_modificacion,
           estado,
           trans_despacho)
        values
          (n_id_despacho,
           'SOT',
           c_eq.codsolot,
           c_eq.acta_instalacion,
           221,
           n_idsucxcontrata,
           decode(a_tipproyecto, 2, d_fecliq, c_eq.fecliq), --<4.0>
           sysdate,
           null,
           null,
           null,
           null,
           sysdate,
           null,
           null,
           ln_trans_despacho);
      end if;
      --z_mm_despacho_masivo_detalle
      select nvl(max(no_item), 0) + 1
        into n_no_item
        from z_mm_despacho_masivo_detalle
       where id_despacho = n_id_despacho;
      insert into z_mm_despacho_masivo_detalle
        (id_despacho,
         no_item,
         material,
         centro,
         almacen,
         cantidad,
         no_reserva,
         no_item_reserva,
         centro_costo,
         clase_valoracion,
         elementopep,
         lote,
         estado,
         mensaje_estado)
      values
        (n_id_despacho,
         n_no_item,
         c_eq.material,
         v_centro,
         v_almacen,
         c_eq.cantidad,
         null,
         null,
         null,
         null,
         c_eq.pep,
         null,
         'P',
         null);

      --Verificar que la cantidad Consumida no exceda el Stock Disponible
      begin
        select cantconsumida
          into n_cantconsumida
          from maestro_stock_mat a
         where a.cod_sap = c_eq.material
           and a.centro = v_centro
           and a.almacen = v_almacen;
      exception
        when others then
          v_error_sqlm := sqlerrm;
          insert into error_despacho_masivo
            (desc_error,
             error_sqlm,
             codcon,
             material,
             codsolot,
             centro,
             almacen)
          values
            ('No se encuentra información para el Centro y el Almacen, revisar si la SOT tiene asignado Almacen.',
             v_error_sqlm,
             c_eq.codcon,
             c_eq.material,
             c_eq.codsolot,
             v_centro,
             v_almacen); --Insertar informacion de Error
      end;

      --Solo se solicita stock de los materiales : TIPOPEDD =240
      select count(1)
        into l_es_mat
        from opedd
       where tipopedd = 240
         and c_eq.material = codigoc;

      if l_es_mat > 0 then
        --Material SAP
        if c_eq.cantidad > n_cantconsumida then
          --En caso se acabo el Stock
          insert into error_despacho_masivo
            (desc_error,
             error_sqlm,
             codcon,
             material,
             codsolot,
             centro,
             almacen)
          values
            ('La Cantidad a despachar : ' || to_char(c_eq.cantidad) ||
             ' es mayor a la Disponible : ' || to_char(n_cantconsumida),
             '',
             c_eq.codcon,
             c_eq.material,
             c_eq.codsolot,
             v_centro,
             v_almacen); --Insertar informacion de Verificación
        else
          --Actualizar las cantidades en MAESTRO_STOCK_MAT
          update maestro_stock_mat a
             set a.cantconsumida = a.cantconsumida - c_eq.cantidad
           where a.cod_sap = c_eq.material
             and a.centro = v_centro
             and a.almacen = v_almacen;
        end if;
      else
        --z_mm_despacho_masivo_serie
        if c_eq.serie is not null then
          insert into z_mm_despacho_masivo_serie
            (id_despacho, no_item, no_serie)
          values
            (n_id_despacho, n_no_item, c_eq.serie);
        end if;
      end if;
    end loop;

    --Envio de Errores a los responsables de Productos Masivos:
    --1  DTH
    --2  HFC
    --3  CDMA
    --4  TPI
    --5  CLARO EMPRESAS --9.0
    /*v_cuerpo := '';
      v_cuerpo := v_cuerpo || 'SGA Operaciones' || chr(13);
      v_cuerpo := v_cuerpo || '' || chr(13);
      v_cuerpo := v_cuerpo || 'Error por Despacho Masivo' || chr(13);

      vNomArch:= 'Error_Despacho_Masivo_' || v_tipproyecto || '_' || to_char(a_trans_despacho) || '.txt';
      v_ruta := '/u02/oracle/PESGAUAT/UTL_FILE';
    --  v_ruta := '/u03/oracle/PESGAPRD/UTL_FILE/';
      f_doc := utl_file.fopen( v_ruta , vNomArch, 'w');
      for c_e in c_error loop
        utl_file.put_line(f_doc, '------------------------------' || chr(13));
        utl_file.put_line(f_doc, 'SOT     :' || c_e.sot || chr(13));
        utl_file.put_line(f_doc, 'ACTA    :' || c_e.acta_instal || chr(13));
        utl_file.put_line(f_doc, 'MATERIAL:' || c_e.material || chr(13));
        utl_file.put_line(f_doc, 'CENTRO  :' || c_e.centro || chr(13));
        utl_file.put_line(f_doc, 'ALMACEN :' || c_e.almacen || chr(13));
        utl_file.put_line(f_doc, 'CANTIDAD:' || c_e.cantidad || chr(13));
        utl_file.put_line(f_doc, 'MENSAJE :' || c_e.mensaje || chr(13));
      end loop;
      utl_file.fclose(f_doc);
      p_envia_correo_c_attach(vNomArch,'jose.bravo',v_cuerpo,SendMailJPkg.ATTACHMENTS_LIST(v_ruta||'/'||vNomArch),'SGA');*/

  end;
  --<REQ ID=114000>
  procedure p_cargar_equ_traslado(a_codsolot    solot.codsolot%type,
                                  a_idplantilla plantilla_traslado.idplantilla%type) is
    n_orden    number;
    n_ord_tras number;
    r_tras     plantilla_traslado%rowtype;

  begin
    --Se identifica la plantilla

    select *
      into r_tras
      from plantilla_traslado
     where idplantilla = a_idplantilla;
    select operacion.sq_idplantilla_tras.nextval into n_orden from dual;
    select operacion.sq_orden_traslado.nextval into n_ord_tras from dual;
    --Se registra en traslado
    insert into traslado_almacen
      (codsolot,
       orden,
       tipequ,
       centro_ori,
       almacen_ori,
       centro_des,
       almacen_des,
       cantidad,
       flgreq,
       ord_tras)
    values
      (a_codsolot,
       n_orden,
       r_tras.tipequ,
       r_tras.centro_ori,
       r_tras.almacen_ori,
       r_tras.centro_des,
       r_tras.almacen_des,
       0,
       0,
       n_ord_tras);

  end;
  --</REQ>

  --<6.0
  procedure p_cargar_mat_traslado(a_codsolot    solot.codsolot%type,
                                  a_tipequ      number,
                                  a_centro_ori  varchar2,
                                  a_almacen_ori varchar2,
                                  a_centro_des  varchar2,
                                  a_almacen_des varchar2,
                                  a_cantidad    number) is --<8.0>
    n_orden    number;
    n_ord_tras number;
    r_tras     plantilla_traslado%rowtype;

  begin
    if a_tipequ is null or a_tipequ = 0 then
      raise_application_error(-20500, 'Seleccione el Equipo o Material.');
    end if;
    if a_centro_ori is null or a_almacen_ori is null then
      raise_application_error(-20500,
                              'Seleccione el Centro-Almacen Origen.');
    end if;
    if a_centro_des is null or a_almacen_des is null then
      raise_application_error(-20500,
                              'Seleccione el Centro-Almacen Destino.');
    end if;

    --Se identifica la plantilla
    select operacion.sq_orden_traslado.nextval into n_orden from dual;
    --Se registra en traslado
    insert into traslado_almacen
      (codsolot,
       orden,
       tipequ,
       centro_ori,
       almacen_ori,
       centro_des,
       almacen_des,
       cantidad,
       flgreq)
    values
      (a_codsolot,
       n_orden,
       a_tipequ,
       a_centro_ori,
       a_almacen_ori,
       a_centro_des,
       a_almacen_des,
       a_cantidad,--<8.0>
       0);

  end;
  -->6.0

  --<7.0>
  procedure p_despacho_masivo2(a_tipproyecto    in number,
                               a_fecini         in date,
                               a_fecfin         in date,
                               a_codcon         in number,
                               a_trans_despacho out number) is

    c_nom_proceso   log_rep_proceso_error.nom_proceso%type := 'FINANCIAL.PQ_Z_MM_DESPACHO_MAT.SP_STOCK_SERIES';
    c_id_proceso    log_rep_proceso_error.id_proceso%type := '5963';
    c_sec_grabacion float := fn_rep_registra_error_ini(c_nom_proceso,
                                                       c_id_proceso);

  begin

    --STOCK DE MATERIALES: CODIGO PARA EL CONSOLIDAD DE MATERIALES QUE SE VAN A DESPACHAR
    c_nom_proceso := 'OPERACION.PQ_ALMACEN.P_STOCK_DESPACHO';
    operacion.pq_almacen.p_stock_despacho(a_tipproyecto,
                                          a_fecini,
                                          a_fecfin,
                                          a_codcon);
    commit;
    ----INTERFACE PARA CONSULTA DE STOCK DE MATERIALES A CONSULTAR
    c_nom_proceso := 'FINANCIAL.PQ_Z_MM_DESPACHO_MAT.SP_STOCK_DESPACHO_MASIVO';
    financial.pq_z_mm_despacho_mat.sp_stock_despacho_masivo;
    commit;
    --CARGA DE EQUIPOS Y MATERIALES QUE SE VAN A DESPACHAR
    c_nom_proceso := 'OPERACION.PQ_ALMACEN.P_DESPACHO_MASIVO';
    operacion.pq_almacen.p_despacho_masivo(a_tipproyecto,
                                           a_fecini,
                                           a_fecfin,
                                           a_codcon,
                                           a_trans_despacho);
    commit;

  exception
    when others then
      soporte.sp_rep_registra_error_job(c_nom_proceso,
                                        c_id_proceso,
                                        sqlerrm,
                                        '1',
                                        c_sec_grabacion);
      raise_application_error(-20000, sqlerrm);
  end;
  --</7.0>

end pq_almacen;
/


