CREATE OR REPLACE PACKAGE BODY OPERACION.PKG_GESTION_RECURSOS IS

  /****************************************************************
  * Nombre SP           :  sgass_valid_dispo_hilo_puerto
  * Proposito           :  Valida disponibilidad de Hilos y Puertos
  * Input               :  <pi_cursor_datos>     - Datos de Ingreso
  * Output              :  <po_cursor_datos>     - Datos de salida.
                           <po_codigo_respuesta>  - Codigo de Resultado:
                                                  -1 -> SIN DATOS DE ENTRADA
                                                   0 -> CONSULTA EXITOSA
                                                 -99 -> ERROR DE ORACLE
                           <po_mensaje_respuesta> - Mensaje de Resultado.
  * Creado por          :  HITSS
  * Fec Creacion        :  22/04/2019
  * Fec Actualizacion   :  22/04/2019
  ****************************************************************/  
  procedure sgass_valid_dispo_hilo_puerto(pi_cursor_datos      in clob,
                                          po_cursor_datos      out sys_refcursor,
                                          po_codigo_respuesta  out varchar2,
                                          po_mensaje_respuesta out varchar2) is
    lv_puntored     sys_refcursor;
    lv_puntored_val sys_refcursor;
    lv_TipoPuntoRed varchar2(10);
    lv_CodPuntoRed  varchar2(100);
    lv_valor01      varchar2(100);
    ln_valida_reg   number;
    li_tab_out      operacion.t_disp_table_out_std := operacion.t_disp_table_out_std();
    error_ex exception;

    cursor cur_inventario is
      select null descrip_cable_gis,
             (f.FIBRV_DESCRIPCION) descrip_fibra,
             (ef.codestfibra) codestfibra,
             (i.cid) cid
        from pex_cable c
       inner join pex_cajter ct
          on ct.codcable = c.codcable
        left outer join metasolv.sgat_pex_fibra f
          on f.fibrn_codcable = ct.codcable
         and f.fibrn_codcajter = ct.codcajter
         and f.fibrn_codestfibra <> 6
        left outer join pex_estfibra ef
          on ef.codestfibra = f.fibrn_codestfibra
        left outer join metasolv.sgat_pex_fibra_orides fo
          on fo.oridn_codfibra = f.fibrn_codfibra
         and fo.oridn_tipo = 1
         and fo.oridn_codubired = c.codubired_ori
        left outer join inssrv i
          on i.codinssrv = f.fibrn_codinssrv
        left outer join estinssrv e
          on e.estinssrv = i.estinssrv
       where ct.cajtv_codcajter_gis = lv_valor01
         and f.fibrn_codestfibra = 1
         and exists (select null
                from pex_tipcable tc
               where tc.tipo in ('MO', 'MU')
                 and tc.codtipcab = c.codtipcab);

    cursor cur_valida_reg is
      select count(1)
        from pex_cable c
       inner join pex_cajter ct
          on ct.codcable = c.codcable
        left outer join metasolv.sgat_pex_fibra f
          on f.fibrn_codcable = ct.codcable
         and f.fibrn_codcajter = ct.codcajter
         and f.fibrn_codestfibra <> 6
        left outer join pex_estfibra ef
          on ef.codestfibra = f.fibrn_codestfibra
        left outer join metasolv.sgat_pex_fibra_orides fo
          on fo.oridn_codfibra = f.fibrn_codfibra
         and fo.oridn_tipo = 1
         and fo.oridn_codubired = c.codubired_ori
       where ct.cajtv_codcajter_gis = lv_valor01
         and f.fibrn_codestfibra = 1
         and exists (select null
                from pex_tipcable tc
               where tc.tipo in ('MO', 'MU')
                 and tc.codtipcab = c.codtipcab);
  
    rf_inv     cur_inventario%rowtype;
    lb_data_in boolean := false;

  begin

    /*Valida datos de entrada*/
    lv_TipoPuntoRed := '';
    lv_CodPuntoRed  := '';
    open lv_puntored_val for dbms_lob.substr(pi_cursor_datos, 32000, 1);
    loop
      fetch lv_puntored_val
        into lv_TipoPuntoRed, lv_CodPuntoRed;
      exit when lv_puntored_val%notfound;
      lb_data_in := true;
    end loop;
    close lv_puntored_val;

    if lb_data_in then

      /*Si existen datos de entrada*/
      lv_TipoPuntoRed := '';
      lv_CodPuntoRed  := '';
      open lv_puntored for dbms_lob.substr(pi_cursor_datos, 32000, 1);
      loop
        fetch lv_puntored
          into lv_TipoPuntoRed, lv_CodPuntoRed;
        exit when lv_puntored%notfound;
        /*Proceso de datos*/

        if trim(lv_TipoPuntoRed) = '1' then

          /*Validamos el codigo de mufa GIS*/
          if lv_CodPuntoRed is null then

            /*lv_CodPuntoRed es nulo*/
            po_codigo_respuesta  := '-2';
            po_mensaje_respuesta := 'NO EXISTEN CODIGOS A PROCESAR.';
            raise error_ex;
          else

            /*valor01 = codigo de mufa GIS*/
            lv_valor01 := trim(lv_CodPuntoRed);

            /*Validar registro existente*/
            open cur_valida_reg;
            fetch cur_valida_reg
              into ln_valida_reg;
            close cur_valida_reg;

            if ln_valida_reg = 0 then
              /*No existes registros*/

              po_codigo_respuesta  := '-3';
              po_mensaje_respuesta := 'NO EXISTEN REGISTROS.';
              raise error_ex;
            else
              /*Consultar inventario*/
              open cur_inventario;
              loop
                fetch cur_inventario
                  into rf_inv;
                exit when cur_inventario%notfound;
                /*Proceso*/
                li_tab_out.extend;
                li_tab_out(li_tab_out.count) := operacion.t_disp_class_out_std(lv_TipoPuntoRed,
                                                                               lv_CodPuntoRed,
                                                                               rf_inv.descrip_cable_gis,
                                                                               rf_inv.descrip_fibra,
                                                                               rf_inv.codestfibra,
                                                                               rf_inv.cid);
              end loop;
              close cur_inventario;
            
            end if;
          end if;
        end if;

      end loop;
      close lv_puntored;

      open po_cursor_datos for
        select TipoPuntoRed tipoPuntoRed,
               CodPuntoRed  codPuntoRed,
               campov1,
               campov2,
               campov3,
               campov4
          from table(li_tab_out);
    
      po_codigo_respuesta  := '0';
      po_mensaje_respuesta := 'CONSULTA EXITOSA.';
    
    else
      /*No existen datos de entrada*/
      open po_cursor_datos for
        select null tipoPuntoRed,
               null codPuntoRed,
               null campov1,
               null campov2,
               null campov3,
               null campov4
          from dual
         where 1 = 2;
    
      po_codigo_respuesta  := '-1';
      po_mensaje_respuesta := 'SIN DATOS DE ENTRADA.';
    end if;

  exception
    when error_ex then
      open po_cursor_datos for
        select null tipoPuntoRed,
               null codPuntoRed,
               null campov1,
               null campov2,
               null campov3,
               null campov4
          from dual
         where 1 = 2;
    when others then
      begin
        raise_application_error(-20660,
                                'Error en sgass_valid_dispo_hilo_puerto. ' ||
                                TO_CHAR(SQLCODE) || 'msg:' || SQLERRM);
        po_codigo_respuesta  := '-99';
        po_mensaje_respuesta := 'ERROR DE ORACLE.' || 'SQLCODE: ' ||
                                TO_CHAR(SQLCODE) || '.SQLERRM: ' || SQLERRM;
      end;
  end;

  /****************************************************************
  * Nombre SP           :  sgass_reserva_hilo
  * Proposito           :  Actualiza estado de Hilo a Reserva Fact
  * Input               :  <pv_codmufagis>       - Codigo de Mufa GIS
  *                        <pv_deshilo>          - Descripcion del Hilo a reservar
  * Output              :  <po_cursor_datos>     - Datos de salida.
                           <po_codigo_respuesta>  - Codigo de Resultado:
                                                   0 -> CONSULTA EXITOSA
                                                 -99 -> ERROR DE ORACLE
                           <po_mensaje_respuesta> - Mensaje de Resultado.
  * Creado por          :  HITSS
  * Fec Creacion        :  22/04/2019
  * Fec Actualizacion   :  08/05/2019
  ****************************************************************/  
  procedure sgass_reserva_hilo(pv_codmufagis        in varchar2,
                               pv_deshilo           in varchar2,
                               pv_numslc            in varchar2,
                               pv_codsuc            in varchar2,
                               po_cursor_datos      out sys_refcursor,
                               po_codigo_respuesta  out varchar2,
                               po_mensaje_respuesta out varchar2) is

    li_tab_out operacion.t_disp_table_out_std := operacion.t_disp_table_out_std();
    error_ex exception;
    lv_cajterm_gis varchar2(100);
    ln_count1      number;
    ln_count2      number;
    lv_codcli      sales.vtatabslcfac.codcli%type;
    lv_codsuc      metasolv.sgat_pex_fibra.fibrc_codsuc%type;

    cursor cur_hilo is
      select null CodCajTermGis,
             to_char(f.fibrn_codfibra) CodFibra,
             to_char(ef.codestfibra) CodEstFibra,
             NULL CID
        from pex_cable c
       inner join pex_cajter ct
          on ct.codcable = c.codcable
        left outer join metasolv.sgat_pex_fibra f
          on f.fibrn_codcable = ct.codcable
         and f.fibrn_codcajter = ct.codcajter
         and f.fibrn_codestfibra <> 6
        left outer join pex_estfibra ef
          on ef.codestfibra = f.fibrn_codestfibra
        left outer join metasolv.sgat_pex_fibra_orides fo
          on fo.oridn_codfibra = f.fibrn_codfibra
         and fo.oridn_tipo = 1
         and fo.oridn_codubired = c.codubired_ori
       where f.fibrv_descripcion = pv_deshilo
         and ct.cajtv_codcajter_gis = lv_cajterm_gis;

    rf_hilo cur_hilo%rowtype;
  begin
    if pv_numslc is null then
      po_codigo_respuesta  := '-1';
      po_mensaje_respuesta := 'NUMERO DE PROYECTO INVALIDO.';
      raise error_ex;
    end if;

    if pv_codsuc is null then
      po_codigo_respuesta  := '-1';
      po_mensaje_respuesta := 'CODIGO DE SUCURSAL INVALIDO.';
      raise error_ex;
    end if;

    begin
      select distinct c.codcli
        into lv_codcli
        from sales.vtatabslcfac c
       where c.numslc = pv_numslc;
    exception
      when no_data_found then
        po_codigo_respuesta  := '-1';
        po_mensaje_respuesta := 'NO EXISTE El NUMERO DE PROYECTO.';
        raise error_ex;
    end;

    begin
      select distinct d.codsuc
        into lv_codsuc
        from sales.vtatabslcfac   c,
             sales.vtadetptoenl   d,
             marketing.vtasuccli  s,
             produccion.pertipvia t
       where c.numslc = d.numslc
         and d.codsuc = s.codsuc
         and s.tipviap = t.codvia
         and d.codsuc = pv_codsuc
         and c.numslc = pv_numslc;
    exception
      when no_data_found then
        po_codigo_respuesta  := '-1';
        po_mensaje_respuesta := 'NO EXISTE El CODIGO DE SUCURSAL, O NO ESTA RELACIONADO AL NUMERO DE PROYECTO.';
        raise error_ex;
    end;

    lv_cajterm_gis := pv_codmufagis;

    begin
      select count(*)
        into ln_count1
        from metasolv.pex_cajter ct
       where ct.cajtv_codcajter_gis = lv_cajterm_gis;

      if nvl(ln_count1, 0) = 0 then
        po_codigo_respuesta  := '-1';
        po_mensaje_respuesta := 'NO EXISTE LA MUFA GIS.';
        raise error_ex;
      end if;
    exception
      when no_data_found then
        po_codigo_respuesta  := '-1';
        po_mensaje_respuesta := 'NO EXISTE LA MUFA GIS.';
        raise error_ex;
    end;

    begin
      select count(1)
        into ln_count1
        from metasolv.pex_cajter ct
       where ct.cajtv_codcajter_gis = lv_cajterm_gis;

      if nvl(ln_count1, 0) = 0 then
        po_codigo_respuesta  := '-3';
        po_mensaje_respuesta := 'NO EXISTEN DATOS REGISTRADOS.';
        raise error_ex;
      end if;
    exception
      when no_data_found then
        po_codigo_respuesta  := '-4';
        po_mensaje_respuesta := 'NO EXISTEN DATOS REGISTRADOS.';
        raise error_ex;
    end;
--
    begin
      select count(1)
        into ln_count2
        from metasolv.pex_cable c
       inner join pex_cajter ct
          on ct.codcable = c.codcable
        left outer join metasolv.sgat_pex_fibra f
          on f.fibrn_codcable = ct.codcable
         and f.fibrn_codcajter = ct.codcajter
         and f.fibrn_codestfibra <> 6
        left outer join metasolv.pex_estfibra ef
          on ef.codestfibra = f.fibrn_codestfibra
        left outer join metasolv.sgat_pex_fibra_orides fo
          on fo.oridn_codfibra = f.fibrn_codfibra
         and fo.oridn_tipo = 1
         and fo.oridn_codubired = c.codubired_ori
       where f.fibrv_descripcion = pv_deshilo
         and ct.cajtv_codcajter_gis = lv_cajterm_gis;

      if nvl(ln_count2, 0) > 1 then
        po_codigo_respuesta  := '-5';
        po_mensaje_respuesta := 'EXISTEN DATOS DUPLICADOS.';
        raise error_ex;
      elsif nvl(ln_count2, 0) = 0 then
        po_codigo_respuesta  := '-6';
        po_mensaje_respuesta := 'NO EXISTEN DATOS REGISTRADOS.';
        raise error_ex;
      end if;
    exception
      when no_data_found then
        po_codigo_respuesta  := '-7';
        po_mensaje_respuesta := 'NO EXISTEN DATOS REGISTRADOS.';
        raise error_ex;
    end;
--
    open cur_hilo;
    loop
      fetch cur_hilo
        into rf_hilo;
      exit when cur_hilo%notfound;
      li_tab_out.extend;
      li_tab_out(li_tab_out.count) := operacion.t_disp_class_out_std(null,
                                                                     null,
                                                                     rf_hilo.CodCajTermGis,
                                                                     rf_hilo.CodFibra,
                                                                     rf_hilo.CodEstFibra,
                                                                     NULL);

      if rf_hilo.CodEstFibra <> 1 then
        po_codigo_respuesta  := '-8';
        po_mensaje_respuesta := 'EL HILO DEBE ESTAR LIBRE.';
        raise error_ex;
      end if;

      update metasolv.sgat_pex_fibra f
         set f.fibrn_codestfibra = 5,
             f.fibrc_codcli      = lv_codcli,
             f.fibrc_numslc      = pv_numslc,
             f.fibrc_codsuc      = pv_codsuc
       where f.fibrv_descripcion = pv_deshilo
         and (f.fibrn_codcajter, f.fibrn_codcable) in
             (select ct.codcajter, c.codcable
                from metasolv.pex_cable c
               inner join metasolv.pex_cajter ct
                  on ct.codcable = c.codcable
                 and ct.cajtv_codcajter_gis = lv_cajterm_gis);
    end loop;
    close cur_hilo;

    open po_cursor_datos for
      select t.campov2     campov1,
             e.codestfibra campov2,
             e.descripcion campov3
        from metasolv.pex_estfibra e,
             metasolv.sgat_pex_fibra f,
             table(li_tab_out) t
       where e.codestfibra = f.fibrn_codestfibra
         and f.fibrn_codfibra = to_number(t.campov2);

    po_codigo_respuesta  := '0';
    po_mensaje_respuesta := 'RESERVA EXITOSA.';

  exception
    when error_ex then
      open po_cursor_datos for
        select null campov1, null campov2, null campov3
          from dual
         where 1 = 2;

    when others then
      raise_application_error(-20660,
                              'Error en sgass_libera_hilo. ' ||
                              TO_CHAR(SQLCODE) || 'msg:' || SQLERRM);
    
      po_codigo_respuesta  := '-99';
      po_mensaje_respuesta := 'ERROR DE ORACLE.' || 'SQLCODE: ' ||
                              TO_CHAR(SQLCODE) || '.SQLERRM: ' || SQLERRM;
  end;
  
  /****************************************************************
  * Nombre SP           :  sgass_libera_hilo
  * Proposito           :  Actualiza estado de Hilo a Libre
  * Input               :  <pv_codmufagis>       - Codigo de Mufa GIS
  *                        <pv_deshilo>          - Descripcion del Hilo a reservar
  * Output              : <po_cursor_datos>     - Datos de salida.
                          <po_codigo_respuesta>  - Codigo de Resultado:
                                                   0 -> ACTUALIZACION EXITOSA
                                                 -99 -> ERROR DE ORACLE
                           <po_mensaje_respuesta> - Mensaje de Resultado.
  * Creado por          :  HITSS
  * Fec Creacion        :  17/09/2019
  * Fec Actualizacion   :  17/09/2019
  ****************************************************************/  
   procedure sgass_libera_hilo(pv_codmufagis        in varchar2,
                               pv_deshilo           in varchar2,
                               pv_numslc            in varchar2,
                               pv_codsuc            in varchar2,
                               po_cursor_datos      out sys_refcursor,
                               po_codigo_respuesta  out varchar2,
                               po_mensaje_respuesta out varchar2) is

    li_tab_out operacion.t_disp_table_out_std := operacion.t_disp_table_out_std();
    error_ex exception;
    lv_cajterm_gis varchar2(100);
    ln_count1      number;
    ln_count2      number;
    lv_codcli      sales.vtatabslcfac.codcli%type;
    lv_codsuc      metasolv.sgat_pex_fibra.fibrc_codsuc%type;

    cursor cur_hilo is
      select null CodCajTermGis,
             to_char(f.fibrn_codfibra) CodFibra,
             to_char(ef.codestfibra) CodEstFibra,
             NULL CID
        from pex_cable c
       inner join pex_cajter ct
          on ct.codcable = c.codcable
        left outer join metasolv.sgat_pex_fibra f
          on f.fibrn_codcable = ct.codcable
         and f.fibrn_codcajter = ct.codcajter
         and f.fibrn_codestfibra <> 6
        left outer join pex_estfibra ef
          on ef.codestfibra = f.fibrn_codestfibra
        left outer join metasolv.sgat_pex_fibra_orides fo
          on fo.oridn_codfibra = f.fibrn_codfibra
         and fo.oridn_tipo = 1
         and fo.oridn_codubired = c.codubired_ori
       where f.fibrv_descripcion = pv_deshilo
         and ct.cajtv_codcajter_gis = lv_cajterm_gis;

    rf_hilo cur_hilo%rowtype;
  begin
    if pv_numslc is null then
      po_codigo_respuesta  := '-1';
      po_mensaje_respuesta := 'NUMERO DE PROYECTO INVALIDO.';
      raise error_ex;
    end if;

    if pv_codsuc is null then
      po_codigo_respuesta  := '-1';
      po_mensaje_respuesta := 'CODIGO DE SUCURSAL INVALIDO.';
      raise error_ex;
    end if;

    begin
      select distinct c.codcli
        into lv_codcli
        from sales.vtatabslcfac c
       where c.numslc = pv_numslc;
    exception
      when no_data_found then
        po_codigo_respuesta  := '-1';
        po_mensaje_respuesta := 'NO EXISTE El NUMERO DE PROYECTO.';
        raise error_ex;
    end;

    begin
      select distinct d.codsuc
        into lv_codsuc
        from sales.vtatabslcfac   c,
             sales.vtadetptoenl   d,
             marketing.vtasuccli  s,
             produccion.pertipvia t
       where c.numslc = d.numslc
         and d.codsuc = s.codsuc
         and s.tipviap = t.codvia
         and d.codsuc = pv_codsuc
         and c.numslc = pv_numslc;
    exception
      when no_data_found then
        po_codigo_respuesta  := '-1';
        po_mensaje_respuesta := 'NO EXISTE El CODIGO DE SUCURSAL, O NO ESTA RELACIONADO AL NUMERO DE PROYECTO.';
        raise error_ex;
    end;

    lv_cajterm_gis := pv_codmufagis;

    begin
      select count(*)
        into ln_count1
        from metasolv.pex_cajter ct
       where ct.cajtv_codcajter_gis = lv_cajterm_gis;

      if nvl(ln_count1, 0) = 0 then
        po_codigo_respuesta  := '-1';
        po_mensaje_respuesta := 'NO EXISTE LA MUFA GIS.';
        raise error_ex;
      end if;
    exception
      when no_data_found then
        po_codigo_respuesta  := '-1';
        po_mensaje_respuesta := 'NO EXISTE LA MUFA GIS.';
        raise error_ex;
    end;

    begin
      select count(1)
        into ln_count1
        from metasolv.pex_cajter ct
       where ct.cajtv_codcajter_gis = lv_cajterm_gis;

      if nvl(ln_count1, 0) = 0 then
        po_codigo_respuesta  := '-3';
        po_mensaje_respuesta := 'NO EXISTEN DATOS REGISTRADOS.';
        raise error_ex;
      end if;
    exception
      when no_data_found then
        po_codigo_respuesta  := '-4';
        po_mensaje_respuesta := 'NO EXISTEN DATOS REGISTRADOS.';
        raise error_ex;
    end;

    begin
      select count(1)
        into ln_count2
        from metasolv.pex_cable c
       inner join pex_cajter ct
          on ct.codcable = c.codcable
        left outer join metasolv.sgat_pex_fibra f
          on f.fibrn_codcable = ct.codcable
         and f.fibrn_codcajter = ct.codcajter
         and f.fibrn_codestfibra <> 6
        left outer join metasolv.pex_estfibra ef
          on ef.codestfibra = f.fibrn_codestfibra
        left outer join metasolv.sgat_pex_fibra_orides fo
          on fo.oridn_codfibra = f.fibrn_codfibra
         and fo.oridn_tipo = 1
         and fo.oridn_codubired = c.codubired_ori
       where f.fibrv_descripcion = pv_deshilo
         and ct.cajtv_codcajter_gis = lv_cajterm_gis;

      if nvl(ln_count2, 0) > 1 then
        po_codigo_respuesta  := '-5';
        po_mensaje_respuesta := 'EXISTEN DATOS DUPLICADOS.';
        raise error_ex;
      elsif nvl(ln_count2, 0) = 0 then
        po_codigo_respuesta  := '-6';
        po_mensaje_respuesta := 'NO EXISTEN DATOS REGISTRADOS.';
        raise error_ex;
      end if;
    exception
      when no_data_found then
        po_codigo_respuesta  := '-7';
        po_mensaje_respuesta := 'NO EXISTEN DATOS REGISTRADOS.';
        raise error_ex;
    end;

    open cur_hilo;
    loop
      fetch cur_hilo
        into rf_hilo;
      exit when cur_hilo%notfound;
      li_tab_out.extend;
      li_tab_out(li_tab_out.count) := operacion.t_disp_class_out_std(null,
                                                                     null,
                                                                     rf_hilo.CodCajTermGis,
                                                                     rf_hilo.CodFibra,
                                                                     rf_hilo.CodEstFibra,
                                                                     NULL);

      update metasolv.sgat_pex_fibra f
         set f.fibrn_codestfibra = 1,  
           f.fibrn_codinssrv   = null,
           f.fibrc_codcli      = null,
           f.fibrc_numslc      = null,
           f.fibrc_codsuc      = null,
           f.fibrd_fecins      = null,
           f.fibrn_codsolot    = null
       where f.fibrv_descripcion = pv_deshilo
         and (f.fibrn_codcajter, f.fibrn_codcable) in
             (select ct.codcajter, c.codcable
                from metasolv.pex_cable c
               inner join metasolv.pex_cajter ct
                  on ct.codcable = c.codcable
                 and ct.cajtv_codcajter_gis = lv_cajterm_gis);
    end loop;
    close cur_hilo;

    open po_cursor_datos for
      select t.campov2     campov1,
             e.codestfibra campov2,
             e.descripcion campov3
        from metasolv.pex_estfibra e,
             metasolv.sgat_pex_fibra f,
             table(li_tab_out) t
       where e.codestfibra = f.fibrn_codestfibra
         and f.fibrn_codfibra = to_number(t.campov2);

    po_codigo_respuesta  := '0';
    po_mensaje_respuesta := 'LIBERACION EXITOSA.';

  exception
    when error_ex then
      open po_cursor_datos for
        select null campov1, null campov2, null campov3
          from dual
         where 1 = 2;

    when others then
      raise_application_error(-20660,
                              'Error en sgass_libera_hilo. ' ||
                              TO_CHAR(SQLCODE) || 'msg:' || SQLERRM);

      po_codigo_respuesta  := '-99';
      po_mensaje_respuesta := 'ERROR DE ORACLE.' || 'SQLCODE: ' ||
                              TO_CHAR(SQLCODE) || '.SQLERRM: ' || SQLERRM;
  end;

  /****************************************************************/  
  procedure sgass_bss_gestionsefgis(pi_codigoProyecto    in varchar2,
                                    pi_codigoSucursal    in varchar2,
                                    pi_idTrazabilidad    in number,
                                    po_xml_input         out clob,
                                    po_xml_output        out clob,
                                    po_codigo_respuesta  out number, 
                                    po_mensaje_respuesta out varchar2) IS
  lv_URL                   varchar2(400);
  lclb_xml                 clob;
  lclb_outxml              clob;
  ln_idcab                 number;
  lv_idTransaccion         varchar2(8);
  lv_fechaUTC              varchar2(20);
  ln_codigoDireccion       number;
  ln_codigoSubDireccion    number;

  error_ex       exception;
  begin
    begin
      select idcab, target_url, xmlclob
        into ln_idcab, lv_URL, lclb_xml
        from operacion.ope_cab_xml
       where titulo = 'BSS_GestionSEFGIS';
    exception
      when no_data_found then
        po_mensaje_respuesta := 'NO SE REGISTRO GeoreferenciacionGIS EN LA TABLA OPERACION.OPE_CAB_XML';
        raise error_ex;
    end;

    begin    
      select i.inmun_coddireccion, i.inmun_codsubdireccion
        into ln_codigoDireccion, ln_codigoSubDireccion
        from marketing.vtasuccli v
       inner join marketing.inmueble i
          on v.idinmueble = i.idinmueble
       where v.codsuc = pi_codigoSucursal;
    exception
      when no_data_found then
       ln_codigoDireccion := NULL;
       ln_codigoSubDireccion := NULL;
    end;

    select to_char(sysdate,'ddmmyyyy') into lv_idTransaccion from dual;

    select to_char(sysdate,'yyyymmddhh24miss') into lv_fechaUTC from dual;

    lclb_xml := webservice.pkg_gestion_recursos_ws.sgafun_clob_replace (lclb_xml, '@idTransaccion', lv_idTransaccion);
    lclb_xml := webservice.pkg_gestion_recursos_ws.sgafun_clob_replace (lclb_xml, '@codigoDireccion', trim(to_char(nvl(ln_codigoDireccion,''))));
    lclb_xml := webservice.pkg_gestion_recursos_ws.sgafun_clob_replace (lclb_xml, '@codigoSubdireccion', trim(to_char(nvl(ln_codigoSubDireccion,''))));
    lclb_xml := webservice.pkg_gestion_recursos_ws.sgafun_clob_replace (lclb_xml, '@fechaUTC', lv_fechaUTC);
    lclb_xml := webservice.pkg_gestion_recursos_ws.sgafun_clob_replace (lclb_xml, '@codigoProyecto', pi_codigoProyecto);
    lclb_xml := webservice.pkg_gestion_recursos_ws.sgafun_clob_replace (lclb_xml, '@codigoSucursal', pi_codigoSucursal);
    lclb_xml := webservice.pkg_gestion_recursos_ws.sgafun_clob_replace (lclb_xml, '@idTrazabilidad', trim(to_char(pi_idTrazabilidad)));

    lclb_outxml:= webservice.pkg_gestion_recursos_ws.sgafun_send_webservice(lclb_xml, lv_URL);

    po_codigo_respuesta := 0;
    po_mensaje_respuesta:= 'OK';
    
    po_xml_input := lclb_xml;
    po_xml_output:= lclb_outxml;
  exception
    when error_ex then
      po_codigo_respuesta  := -1;
    when others then
      raise_application_error(-20660,
                              'Error en sgass_bss_gestionsefgis. ' ||
                              TO_CHAR(SQLCODE) || 'msg:' || SQLERRM);

      po_codigo_respuesta  := -99;
      po_mensaje_respuesta := 'ERROR DE ORACLE.' || 'SQLCODE: ' ||
                              TO_CHAR(SQLCODE) || '.SQLERRM: ' || SQLERRM;        
  end;
END;
/