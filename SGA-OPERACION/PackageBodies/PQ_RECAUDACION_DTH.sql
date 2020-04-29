create or replace package body operacion.pq_recaudacion_dth is
  /*********************************************************************************************
      NOMBRE:           pq_recaudacion_dth
      PROPOSITO:        Permite obtener informacion para la recaudacion DTH.
      PROGRAMADO EN JOB:  NO
      REVISIONES:
      Ver     Fecha       Autor             Solicitado por        Descripcion
      ------  ----------  ---------------   -----------------     -----------------------------------
      1.0     29/08/2011  Widmer Quispe     Jose Ramos            Proy. Recaudacion DTH
      2.0     14/10/2011  Widmer Quispe     Jose Ramos            Proy. Recaudacion DTH
  ********************************************************************************************/

  --<1.0
  procedure p_carga_inicial_cliente_dth is
  
    cursor c_recarga is
      select *
        from ope_srv_recarga_cab o
       where --<2.0 --  o.estado = '02'
             o.estado in ('02', '03')
         and o.tipbqd = 4 --- Solo DTH , no CDMA
        --2.0>
         and o.flg_recarga = 1
         and o.flg_trans_int = 0
        order by o.codigo_recarga asc;
  
    ln_contador_reg             number;
    lc_linea_error              varchar2(3000);
    i                           number;
    ln_codigo_recarga_inicial   ope_srv_recarga_cab.codigo_recarga%type;
    ln_codigo_recarga_final     ope_srv_recarga_cab.codigo_recarga%type;
    ld_fecha_fin_vigencia_dth   ope_srv_recarga_cab.fecfinvig%type;
    lv_nombre                   vtatabcli.nomcli%type;
    lv_apellido                 vtatabcli.apepat%type;
    lv_apellidopat              vtatabcli.apepat%type;
    lv_apellidomat              vtatabcli.apepat%type;
    lv_tipo_de_documento        vtatipdid.dscdid%type;
    lv_numero_de_documento      vtatabcli.ntdide%type;
    ln_flag_mantenimiento       number(1);
    ld_fecha_registro_solicitud date;
    lr_cliente                  vtatabcli%rowtype;
    lv_numregistro              ope_srv_recarga_cab.numregistro%type;
    lr_tipdoc                   vtatipdid%rowtype;
    --lc_destino                  ope_parametros_globales_aux.valorparametro%type; --2.0
    lc_texto  cola_send_mail_job.cuerpo%type;
    r_recarga c_recarga%rowtype;
    --<2.0
    l_descripcion opedd.descripcion%type;
    --2.0>
  
  begin
  
    delete from ope_carga_inicial_tmp;
  
    ln_contador_reg := 0;
  
    open c_recarga;
    loop
      <<inicio>>
      fetch c_recarga
        into r_recarga;
      exit when c_recarga%notfound;
      lr_cliente                := null; --2.0
      lr_tipdoc                 := null; --2.0
      l_descripcion             := null; --2.0
      lc_texto                  := null; --2.0
      lc_linea_error            := null; --2.0
      i                         := 0;
      ln_codigo_recarga_inicial := r_recarga.codigo_recarga;
    
      if nvl(ln_codigo_recarga_inicial, 0) = 0 then
      
        lc_texto := 'Error al consultar código de recarga es nulo, Código Recarga: ' ||
                    r_recarga.codigo_recarga || ' Codcli: ' ||
                    r_recarga.codcli || chr(13) || lc_linea_error;
        --<2.0
        /*lc_destino := operacion.pq_ope_interfaz_tvsat.f_obt_parametro('cortesyreconexiones.correo_responsable_operaciones');
        p_envia_correo_de_texto_att('Consulta Clientes DTH',
                                    lc_destino,
                                    lc_texto);
        commit;
        */
        --2.0>
        i := i + 1;
        --goto inicio; --2.0
      end if;
    
      ln_codigo_recarga_final   := null;
      ld_fecha_fin_vigencia_dth := r_recarga.fecfinvig;
    
      begin
        select v.*
          into lr_cliente
          from vtatabcli v
         where v.codcli = r_recarga.codcli;
      exception
        when others then
          lc_texto := 'Error al consultar Cliente, Código Recarga: ' ||
                      r_recarga.codigo_recarga || ' Codcli: ' ||
                      r_recarga.codcli || chr(13) || lc_linea_error;
          --<2.0
          /*lc_destino := operacion.pq_ope_interfaz_tvsat.f_obt_parametro('cortesyreconexiones.correo_responsable_operaciones');
          p_envia_correo_de_texto_att('Consulta Clientes DTH',
                                      lc_destino,
                                      lc_texto);
          commit;
                                      */
          --2.0>
          i := i + 1;
          --goto inicio; --2.0
      end;
    
      lv_nombre      := lr_cliente.nomclires;
      lv_apellidopat := lr_cliente.apepatcli;
      lv_apellidomat := lr_cliente.apematcli;
      lv_apellido    := lv_apellidopat || ' ' || lv_apellidomat;
    
      if nvl(lv_nombre, '0') = '0' then
        lv_nombre   := lr_cliente.nombre;
        lv_apellido := lr_cliente.apepat || ' ' || lr_cliente.apmat;
      end if;
    
      --<2.0
      select descripcion
        into l_descripcion
        from opedd
       where tipopedd = 1025
         and abreviacion = 'CE';
      --2.0>
    
      begin
        select *
          into lr_tipdoc
          from vtatipdid t
         where t.tipdide = lr_cliente.tipdide;
      exception
        when others then
          lc_linea_error := sqlcode || ' ' || sqlerrm;
          lc_texto       := 'Error al consultar Documento de Cliente, Código Recarga: ' ||
                            r_recarga.codigo_recarga || ' Codcli: ' ||
                            r_recarga.codcli || ' TIPDOC: ' ||
                            lr_cliente.tipdide || chr(13) || lc_linea_error;
          --<2.0
          /*lc_destino     := operacion.pq_ope_interfaz_tvsat.f_obt_parametro('cortesyreconexiones.correo_responsable_operaciones');
          p_envia_correo_de_texto_att('Consulta de Documentos Clientes DTH',
                                      lc_destino,
                                      lc_texto);
          commit;
          */
          --2.0>
          i := i + 1;
          --goto inicio; --2.0
      end;
    
      lv_tipo_de_documento := lr_tipdoc.descint;
    
      --<2.0
      if (lr_tipdoc.tipdide = '004') then
        lv_tipo_de_documento := l_descripcion;
      end if;
      --2.0>
    
      if lr_tipdoc.flg_int = 1 then
        lv_numero_de_documento := lr_cliente.ntdide;
      else
        lv_numero_de_documento := lr_tipdoc.nrodoc_default;
      end if;
    
      if lv_nombre is null then
        lv_nombre   := lr_cliente.nomcli;
        lv_apellido := '';
      end if;
    
      --<2.0
      if length(trim(lv_nombre)) > 30 then
        lv_nombre := substr(trim(lv_nombre), 1, 30);
      end if;
    
      if nvl(trim(lv_apellido), '0') = '0' then
        lv_apellido := lv_nombre;
      end if;
      --2.0>
    
      ln_flag_mantenimiento := 1;
    
      ld_fecha_registro_solicitud := sysdate;
    
      if nvl(lv_nombre, '0') = '0' then
      
        lc_texto := 'Error al consultar Cliente, Nombre es Nulo, Código Recarga: ' ||
                    r_recarga.codigo_recarga || ' Codcli: ' ||
                    r_recarga.codcli || chr(13) || lc_linea_error;
        --<2.0
        /*lc_destino := operacion.pq_ope_interfaz_tvsat.f_obt_parametro('cortesyreconexiones.correo_responsable_operaciones');
        p_envia_correo_de_texto_att('Consulta Clientes DTH',
                                    lc_destino,
                                    lc_texto);
        commit;
        */
        --2.0>
        i := i + 1;
        --goto inicio;
      end if;
    
      --<2.0
      if i > 0 then
        ln_flag_mantenimiento := 9;
      end if;
      --2.0>
    
      --escribe el detalle del archivo
      insert into ope_carga_inicial_tmp
        (codigo_recarga_ini,
         codigo_recarga_fin,
         fecha_fin_vigencia,
         nombre,
         apellido,
         tipo_documento,
         numero_documento,
         flag_mantenimiento,
         fecha_registro_solicitud,
         --<2.0
         observacion
         --2.0>
         )
      values
        (ln_codigo_recarga_inicial,
         ln_codigo_recarga_final,
         to_char(ld_fecha_fin_vigencia_dth, 'DD/MM/YYYY'),
         trim(lv_nombre),
         trim(lv_apellido),
         lv_tipo_de_documento,
         lv_numero_de_documento,
         ln_flag_mantenimiento,
         ld_fecha_registro_solicitud,
         --<2.0
         lc_texto
         --2.0>
         );
    
      ln_contador_reg := ln_contador_reg + 1;
      lv_numregistro  := r_recarga.numregistro;
    
      if i = 0 then
        update ope_srv_recarga_cab o
           set o.flg_trans_int = 1, o.fec_trans_int = sysdate
         where o.codigo_recarga = r_recarga.codigo_recarga
           and o.numregistro = r_recarga.numregistro;
      end if;
      commit; --2.0
    end loop;
  
    --commit; 2.0
  exception
    when others then
      dbms_output.put_line('Error al generar el reporte: ' || sqlerrm || ' ' ||
                           to_char(lv_numregistro));
      Rollback;
  end;

  procedure p_carga_diaria_cliente_dth is
  
    cursor c_recarga is
      select *
        from ope_srv_recarga_cab o
       where --<2.0  o.estado = '02'
             o.estado in ('02', '03')
         and o.tipbqd = 4 --- Solo DTH , no CDMA
         --2.0>
         and o.flg_recarga = 1
         and o.flg_trans_int = 0
         order by o.codigo_recarga asc;
  
    cursor c_recarga_baja is
      select *
        from ope_srv_recarga_cab o
       where o.estado = '04'
         and o.flg_recarga = 1
         and o.flg_trans_int_baja = 0
         and o.flg_trans_int = 1
         and not exists (select 1
                from ope_sot_baja_alta_rel b
               where b.codsolot_alta_old = o.codsolot)
            --<2.0
         and o.tipbqd = 4 -- Solo DTH , no CDMA
      --2.0>
       order by o.codigo_recarga asc;
  
    ln_contador_reg             number;
    lc_linea_error              varchar2(3000);
    i                           number;
    j                           number;
    k                           number;
    m                           number;
    ln_codigo_recarga_inicial   ope_srv_recarga_cab.codigo_recarga%type;
    ln_codigo_recarga_final     ope_srv_recarga_cab.codigo_recarga%type;
    ld_fecha_fin_vigencia_dth   ope_srv_recarga_cab.fecfinvig%type;
    lv_nombre                   vtatabcli.nomcli%type;
    lv_apellido                 vtatabcli.apepat%type;
    lv_apellidopat              vtatabcli.apepat%type;
    lv_apellidomat              vtatabcli.apepat%type;
    lv_tipo_de_documento        vtatipdid.dscdid%type;
    lv_numero_de_documento      vtatabcli.ntdide%type;
    ln_flag_mantenimiento       number(1);
    ld_fecha_registro_solicitud date;
    lr_cliente                  vtatabcli%rowtype;
    lv_numregistro              ope_srv_recarga_cab.numregistro%type;
    lr_tipdoc                   vtatipdid%rowtype;
    --lc_destino                  ope_parametros_globales_aux.valorparametro%type; 2.0
    lc_texto       cola_send_mail_job.cuerpo%type;
    lv_codcli      vtatabcli.codcli%type;
    r_recarga      c_recarga%rowtype;
    r_recarga_baja c_recarga_baja%rowtype;
    --<2.0
    l_descripcion opedd.descripcion%type;
    --2.0>
  
  begin
  
    delete from ope_carga_diaria_tmp;
    ln_contador_reg := 0;
  
    open c_recarga;
    loop
      <<inicio>>
      fetch c_recarga
        into r_recarga;
      exit when c_recarga%notfound;
      lr_cliente                := null; --2.0
      lr_tipdoc                 := null; --2.0
      l_descripcion             := null; --2.0
      lc_texto                  := null; --2.0
      lc_linea_error            := null; --2.0
      i                         := 0;
      k                         := 0;
      m                         := 0;
      ln_codigo_recarga_inicial := r_recarga.codigo_recarga; --<CODIGO RECARGA INICIAL>
      ln_codigo_recarga_final   := null; --<CODIGO RECARGA FINAL>
      ld_fecha_fin_vigencia_dth := r_recarga.fecfinvig; --<FECHA FIN VIGENCIA DTH>
    
      --<FLAG MANTENIMIENTO**>
      --if r_recarga.estado = '02' then --2.0
    
      ln_flag_mantenimiento := 1;
      --obtener la SOT de Baja de los servicios cancelados
      select count(1)
        into j
        from ope_srv_recarga_cab o
       where codsolot =
             (select b.codsolot_alta_old
                from operacion.ope_sot_baja_alta_rel b
               where b.codsolot_alta_new = r_recarga.codsolot);
    
      if j > 0 then
        --Se recupera la SOT baja
        select o.codcli, o.codigo_recarga
          into lv_codcli, ln_codigo_recarga_inicial
          from ope_srv_recarga_cab o
         where codsolot =
               (select b.codsolot_alta_old
                  from operacion.ope_sot_baja_alta_rel b
                 where b.codsolot_alta_new = r_recarga.codsolot);
      
        if r_recarga.codigo_recarga <> ln_codigo_recarga_inicial then
          ln_codigo_recarga_final := r_recarga.codigo_recarga;
          ln_flag_mantenimiento   := 2;
          m                       := 0;
        else
          m := m + 1;
        end if;
      
        if nvl(ln_codigo_recarga_inicial, 0) = 0 then
          lc_texto := 'Error al consultar código de recarga es nulo, Código Recarga: ' ||
                      r_recarga.codigo_recarga || ' Codcli: ' ||
                      r_recarga.codcli || chr(13) || lc_linea_error;
          --<2.0
          /*lc_destino := operacion.pq_ope_interfaz_tvsat.f_obt_parametro('cortesyreconexiones.correo_responsable_operaciones');
          p_envia_correo_de_texto_att('Consulta Clientes DTH',
                                      lc_destino,
                                      lc_texto);*/
          --2.0>
          i := i + 1;
          --goto inicio; --2.0
        end if;
      
        if lv_codcli <> r_recarga.codcli then
          ln_flag_mantenimiento := 3;
          r_recarga.codcli      := lv_codcli;
          k                     := 0;
        else
          if m <> 0 then
            --codigo de recarga igual q la anterior
            k := k + 1;
          end if;
        end if;
      
        if k > 0 then
          i := i + 1;
          --<2.0
          --goto inicio;
          lc_texto := 'Error al consultar, código de recarga y cliente es el mismo: ' ||
                      r_recarga.codigo_recarga || ' Codcli: ' ||
                      r_recarga.codcli || chr(13) || lc_linea_error;
          --2.0>
        end if;
        --<2.0
      else
        if nvl(ln_codigo_recarga_inicial, 0) = 0 then
          lc_texto := 'Error al consultar código de recarga es nulo, Código Recarga: ' ||
                      r_recarga.codigo_recarga || ' Codcli: ' ||
                      r_recarga.codcli || chr(13) || lc_linea_error;
          i        := i + 1;
        end if;
        --2.0>
      end if;
      --end if; --2.0
    
      --Obtener <NOMBRE> y <APELLIDO>
      begin
        select v.*
          into lr_cliente
          from vtatabcli v
         where v.codcli = r_recarga.codcli;
      exception
        when others then
          lc_linea_error := sqlcode || ' ' || sqlerrm; --2.0
          lc_texto       := 'Error al consultar Cliente, Código Recarga: ' ||
                            r_recarga.codigo_recarga || ' Codcli: ' ||
                            r_recarga.codcli || chr(13) || lc_linea_error;
          --<2.0
          /*lc_destino := operacion.pq_ope_interfaz_tvsat.f_obt_parametro('recaudaciondth.correo_responsable_operaciones');
          p_envia_correo_de_texto_att('Consulta Clientes DTH',
                                      lc_destino,
                                      lc_texto);*/
          --2.0>
          i := i + 1;
          --goto inicio; --2.0
      end;
    
      lv_nombre      := lr_cliente.nomclires;
      lv_apellidopat := lr_cliente.apepatcli;
      lv_apellidomat := lr_cliente.apematcli;
      lv_apellido    := lv_apellidopat || ' ' || lv_apellidomat;
    
      if nvl(lv_nombre, '0') = '0' then
        lv_nombre   := lr_cliente.nombre;
        lv_apellido := lr_cliente.apepat || ' ' || lr_cliente.apmat;
      end if;
    
      if lv_nombre is null then
        lv_nombre   := lr_cliente.nomcli;
        lv_apellido := '';
      end if;
    
      --<2.0
      if length(trim(lv_nombre)) > 30 then
        lv_nombre := substr(trim(lv_nombre), 1, 30);
      end if;
    
      if nvl(trim(lv_apellido), '0') = '0' then
        lv_apellido := lv_nombre;
      end if;
      --2.0>
    
      if nvl(lv_nombre, '0') = '0' then
        lc_texto := 'Error al consultar Cliente, Nombre es Nulo, Código Recarga: ' ||
                    r_recarga.codigo_recarga || ' Codcli: ' ||
                    r_recarga.codcli || chr(13) || lc_linea_error;
        --<2.0
        /*lc_destino := operacion.pq_ope_interfaz_tvsat.f_obt_parametro('cortesyreconexiones.correo_responsable_operaciones');
        p_envia_correo_de_texto_att('Consulta Clientes DTH',
                                    lc_destino,
                                    lc_texto);*/
        --2.0>
        i := i + 1;
        --goto inicio; --2.0
      end if;
    
      --<2.0
      select descripcion
        into l_descripcion
        from opedd
       where tipopedd = 1025
         and abreviacion = 'CE';
      --2.0>
    
      --Obtener <TIPO DE DOCUMENTO>
      begin
        select *
          into lr_tipdoc
          from vtatipdid t
         where t.tipdide = lr_cliente.tipdide;
      exception
        when others then
          lc_linea_error := sqlcode || ' ' || sqlerrm;
          lc_texto       := 'Error al consultar Documento de Cliente, Código Recarga: ' ||
                            r_recarga.codigo_recarga || ' Codcli: ' ||
                            r_recarga.codcli || ' TIPDOC: ' ||
                            lr_cliente.tipdide || chr(13) || lc_linea_error;
          --<2.0
          /*lc_destino     := operacion.pq_ope_interfaz_tvsat.f_obt_parametro('recaudaciondth.correo_responsable_operaciones');
          p_envia_correo_de_texto_att('Consulta de Documentos Clientes DTH',
                                      lc_destino,
                                      lc_texto);*/
          --2.0>
          i := i + 1;
          --goto inicio; --2.0
      end;
    
      lv_tipo_de_documento := lr_tipdoc.descint;
    
      --<2.0
      if (lr_tipdoc.tipdide = '004') then
        lv_tipo_de_documento := l_descripcion;
      end if;
      --2.0>
    
      --<NUMERO DE DOCUMENTO>
      if lr_tipdoc.flg_int = 1 then
        lv_numero_de_documento := lr_cliente.ntdide;
      else
        lv_numero_de_documento := lr_tipdoc.nrodoc_default;
      end if;
    
      --<FECHA REGISTRO SOLICITUD>
      ld_fecha_registro_solicitud := sysdate;
    
      --<2.0
      if i > 0 then
        ln_flag_mantenimiento := 9;
      end if;
      --2.0>
    
      --escribe el detalle del archivo
      insert into ope_carga_diaria_tmp
        (codigo_recarga_ini,
         codigo_recarga_fin,
         fecha_fin_vigencia,
         nombre,
         apellido,
         tipo_documento,
         numero_documento,
         flag_mantenimiento,
         fecha_registro_solicitud,
         --<2.0
         observacion
         --2.0>
         )
      values
        (ln_codigo_recarga_inicial,
         ln_codigo_recarga_final,
         to_char(ld_fecha_fin_vigencia_dth, 'DD/MM/YYYY'),
         trim(lv_nombre),
         trim(lv_apellido),
         lv_tipo_de_documento,
         lv_numero_de_documento,
         ln_flag_mantenimiento,
         ld_fecha_registro_solicitud,
         --<2.0
         lc_texto
         --2.0>
         );
    
      ln_contador_reg := ln_contador_reg + 1;
      lv_numregistro  := r_recarga.numregistro;
    
      if i = 0 then
        update ope_srv_recarga_cab o
           set o.flg_trans_int = 1, o.fec_trans_int = sysdate
         where o.codigo_recarga = r_recarga.codigo_recarga
           and o.numregistro = r_recarga.numregistro;
      end if;
      commit; --2.0
    end loop;
  
    ln_contador_reg := 0;
    --recargas de baja
    open c_recarga_baja;
    loop
      <<inicio>>
      fetch c_recarga_baja
        into r_recarga_baja;
      exit when c_recarga_baja%notfound;
      lr_cliente                := null; --2.0
      lr_tipdoc                 := null; --2.0
      l_descripcion             := null; --2.0
      lc_texto                  := null; --2.0
      lc_linea_error            := null; --2.0
      i                         := 0;
      ln_codigo_recarga_inicial := r_recarga_baja.codigo_recarga; --<CODIGO RECARGA INICIAL>
      --<2.0
      if nvl(ln_codigo_recarga_inicial, 0) = 0 then
        lc_texto := 'Error al consultar código de recarga es nulo, Código Recarga: ' ||
                    r_recarga_baja.codigo_recarga || ' Codcli: ' ||
                    r_recarga_baja.codcli || chr(13) || lc_linea_error;
        i        := i + 1;
      end if;
      --2.0>
    
      ln_codigo_recarga_final   := null; --<CODIGO RECARGA FINAL>
      ld_fecha_fin_vigencia_dth := r_recarga_baja.fecfinvig; --<FECHA FIN VIGENCIA DTH>
    
      --<FLAG MANTENIMIENTO**>
      ln_flag_mantenimiento := 0;
      --Obtener <NOMBRE> y <APELLIDO>
      begin
        select v.*
          into lr_cliente
          from vtatabcli v
         where v.codcli = r_recarga_baja.codcli;
      exception
        when others then
          lc_linea_error := sqlcode || ' ' || sqlerrm; --2.0
          lc_texto       := 'Error al consultar Cliente, Código Recarga: ' ||
                            r_recarga_baja.codigo_recarga || ' Codcli: ' ||
                            r_recarga_baja.codcli || chr(13) ||
                            lc_linea_error;
          --<2.0
          /*lc_destino := operacion.pq_ope_interfaz_tvsat.f_obt_parametro('recaudaciondth.correo_responsable_operaciones');
          p_envia_correo_de_texto_att('Consulta Clientes DTH',
                                      lc_destino,
                                      lc_texto);*/
          --2.0>
          i := i + 1;
          --goto inicio; --2.0
      end;
    
      lv_nombre      := lr_cliente.nomclires;
      lv_apellidopat := lr_cliente.apepatcli;
      lv_apellidomat := lr_cliente.apematcli;
      lv_apellido    := lv_apellidopat || ' ' || lv_apellidomat;
    
      if nvl(lv_nombre, '0') = '0' then
        lv_nombre   := lr_cliente.nombre;
        lv_apellido := lr_cliente.apepat || ' ' || lr_cliente.apmat;
      end if;
    
      if lv_nombre is null then
        lv_nombre   := lr_cliente.nomcli;
        lv_apellido := '';
      end if;
    
      --<2.0
      if length(trim(lv_nombre)) > 30 then
        lv_nombre := substr(trim(lv_nombre), 1, 30);
      end if;
    
      if nvl(trim(lv_apellido), '0') = '0' then
        lv_apellido := lv_nombre;
      end if;
      --2.0>
    
      if nvl(lv_nombre, '0') = '0' then
        lc_texto := 'Error al consultar Cliente, Nombre es Nulo, Código Recarga: ' ||
                    r_recarga_baja.codigo_recarga || ' Codcli: ' ||
                    r_recarga_baja.codcli || chr(13) || lc_linea_error;
        --<2.0
        /*lc_destino := operacion.pq_ope_interfaz_tvsat.f_obt_parametro('cortesyreconexiones.correo_responsable_operaciones');
        p_envia_correo_de_texto_att('Consulta Clientes DTH',
                                    lc_destino,
                                    lc_texto);*/
        --2.0>
        i := i + 1;
        --goto inicio; --2.0
      end if;
    
      --<2.0
      select descripcion
        into l_descripcion
        from opedd
       where tipopedd = 1025
         and abreviacion = 'CE';
      --2.0>
    
      --Obtener <TIPO DE DOCUMENTO>
      begin
        select *
          into lr_tipdoc
          from vtatipdid t
         where t.tipdide = lr_cliente.tipdide;
      exception
        when others then
          lc_linea_error := sqlcode || ' ' || sqlerrm;
          lc_texto       := 'Error al consultar Documento de Cliente, Código Recarga: ' ||
                            r_recarga_baja.codigo_recarga || ' Codcli: ' ||
                            r_recarga_baja.codcli || ' TIPDOC: ' ||
                            lr_cliente.tipdide || chr(13) || lc_linea_error;
          --<2.0
          /*lc_destino     := operacion.pq_ope_interfaz_tvsat.f_obt_parametro('recaudaciondth.correo_responsable_operaciones');
          p_envia_correo_de_texto_att('Consulta de Documentos Clientes DTH',
                                      lc_destino,
                                      lc_texto);*/
          --2.0>
          i := i + 1;
          --goto inicio; --2.0
      end;
    
      lv_tipo_de_documento := lr_tipdoc.descint;
    
      --<2.0
      if (lr_tipdoc.tipdide = '004') then
        lv_tipo_de_documento := l_descripcion;
      end if;
      --2.0>
    
      --<NUMERO DE DOCUMENTO>
      if lr_tipdoc.flg_int = 1 then
        lv_numero_de_documento := lr_cliente.ntdide;
      else
        lv_numero_de_documento := lr_tipdoc.nrodoc_default;
      end if;
    
      --<FECHA REGISTRO SOLICITUD>
      ld_fecha_registro_solicitud := sysdate;
    
      --<2.0
      if i > 0 then
        ln_flag_mantenimiento := 9;
      end if;
      --2.0>
    
      --escribe el detalle del archivo
      insert into ope_carga_diaria_tmp
        (codigo_recarga_ini,
         codigo_recarga_fin,
         fecha_fin_vigencia,
         nombre,
         apellido,
         tipo_documento,
         numero_documento,
         flag_mantenimiento,
         fecha_registro_solicitud,
         --<2.0
         observacion
         --2.0>
         )
      values
        (ln_codigo_recarga_inicial,
         ln_codigo_recarga_final,
         to_char(ld_fecha_fin_vigencia_dth, 'DD/MM/YYYY'),
         trim(lv_nombre),
         trim(lv_apellido),
         lv_tipo_de_documento,
         lv_numero_de_documento,
         ln_flag_mantenimiento,
         ld_fecha_registro_solicitud,
         --<2.0
         lc_texto
         --2.0>
         );
    
      ln_contador_reg := ln_contador_reg + 1;
      lv_numregistro  := r_recarga_baja.numregistro;
    
      if i = 0 then
        update ope_srv_recarga_cab o
           set o.flg_trans_int_baja = 1, o.fec_trans_int_baja = sysdate
         where o.codigo_recarga = r_recarga_baja.codigo_recarga
           and o.numregistro = r_recarga_baja.numregistro;
      end if;
      commit; --2.0
    end loop;
  
    --commit;
  exception
    when others then
      dbms_output.put_line('Error al generar el reporte: ' || sqlerrm || ' ' ||
                           to_char(lv_numregistro));
      Rollback;
    
  end;
  -->
end;
/