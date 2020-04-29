create or replace package body operacion.pkg_dth_migracion as
  /******************************************************************************
   REVISIONES:
     Version  Fecha       Autor           Solicitado por      Descripcion
     -------  -----       -----           --------------      -----------
     1.0      2015-11-17  Freddy Gonzales Alberto Miranda     Migracion DTH
	 2.0      2015-11-21  Angel Condori   Alberto Miranda     Alineacion a Produccion
  /* ***************************************************************************/
  function es_migracion(p_numslc vtatabslcfac.numslc%type) return number is
    l_idprocess sales.int_negocio_instancia.idprocess%type;
    l_count     pls_integer;

  begin
    select t.idprocess
      into l_idprocess
      from sales.int_negocio_instancia t
     where t.instancia = 'PROYECTO DE VENTA'
       and t.idinstancia = p_numslc;

    select count(*)
      into l_count
      from sales.int_negocio_proceso t
     where t.idprocess = l_idprocess
       and t.idnegocio = get_datos_dth_migra('ventas_dth')
       and t.tipo = get_tipo_migracion();

    return l_count;

  exception
    when no_data_found then
      return 0;
    when others then
      raise_application_error(-20000,
                              $$plsql_unit || '.es_migracion(p_numslc => ' ||
                              p_numslc || ') ' || sqlerrm);

  end;
  ---------------------------------------------------------------------------
  procedure es_migracion_con_servicio(p_idprocess sales.int_negocio_proceso.idprocess%type,
                                      p_codcli    vtatabcli.codcli%type) is
    l_count pls_integer;

  begin
    select count(*)
      into l_count
      from sales.int_negocio_proceso t
     where t.idprocess = p_idprocess
       and t.idnegocio = get_datos_dth_migra('ventas_dth')
       and t.tipo = get_tipo_migracion();

    if l_count = 0 then
      return;
    end if;

    verifica_contrato(p_codcli);

  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit || '.es_migracion(p_idprocess => ' ||
                              p_idprocess || ') ' || sqlerrm);
  end;
  ---------------------------------------------------------------------------
  procedure verifica_contrato(p_codcli vtatabcli.codcli%type) is
    l_count pls_integer;

  begin
    select count(*)
      into l_count
      from ope_srv_recarga_cab t
     where t.flg_recarga = '0'
       and t.flg_envio_act <> '0'
       and t.nro_contrato is not null
       and t.codcli = p_codcli;

    if l_count = 0 then
      raise_application_error(-20000,
                              'El cliente: ' || p_codcli ||
                              ' No tiene servicio para Generar Baja.');
      return;
    elsif l_count > 1 then
      raise_application_error(-20000,
                              'El cliente: ' || p_codcli ||
                              ' tiene demasidos servicios para generar Baja.');
      return;
    end if;

  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit || '.tiene_contrato(p_codcli => ' ||
                              p_codcli || ') ' || sqlerrm);
  end;
  ---------------------------------------------------------------------------
  function get_datos_dth_migra(p_abreviacion opedd.abreviacion%type)
    return opedd.codigon%type is
    l_codigon opedd.codigon%type;

  begin
    select d.codigon
      into l_codigon
      from tipopedd c, opedd d
     where c.abrev = 'dth_migracion'
       and c.tipopedd = d.tipopedd
       and d.abreviacion = p_abreviacion;

    return l_codigon;

  exception
    when no_data_found then
      return 0;
    when others then
      raise_application_error(-20000,
                              $$plsql_unit ||
                              '.get_datos_dth_migra(p_abreviacion => ' ||
                              p_abreviacion || ') ' || sqlerrm);
  end;
  ---------------------------------------------------------------------------
  function get_tipo_migracion return sales.int_negocio_proceso.tipo%type is
    l_tipo sales.int_negocio_proceso.tipo%type;

  begin
    select d.codigoc
      into l_tipo
      from tipopedd c, opedd d
     where c.abrev = 'dth_migracion'
       and c.tipopedd = d.tipopedd
       and d.abreviacion = 'tipo_migracion';

    return l_tipo;

  exception
    when no_data_found then
      return '0';
    when others then
      raise_application_error(-20000,
                              $$plsql_unit || '.get_tipo_migracion() ' ||
                              sqlerrm);
  end;
  ---------------------------------------------------------------------------
  function desactivar_contrato(p_codsolot solot.codsolot%type) return number is
    l_codcli       solot.codcli%type;
    l_nro_contrato ope_srv_recarga_cab.nro_contrato%type;
    l_co_id        number;
    l_reason       number;
    l_user         varchar2(30);
    l_request_id   number;

  begin
    l_codcli       := get_codcli(p_codsolot);
    l_nro_contrato := get_nro_contrato(l_codcli);

    l_co_id  := obt_co_id_sisact(l_nro_contrato, p_codsolot);
    l_reason := get_datos_dth_migra('reason');
    l_user   := get_user();

    tim.tim111_pkg_acciones.sp_contract_deactivation@DBL_BSCS_BF(l_co_id,
                                                                 l_reason,
                                                                 l_user,
                                                                 l_request_id);

    return l_request_id;

  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit || '.desactivar_contrato() ' ||
                              sqlerrm);
  end;
  ---------------------------------------------------------------------------
  function get_codcli(p_codsolot solot.codsolot%type) return solot.codcli%type is
    l_codcli solot.codcli%type;

  begin
    select t.codcli into l_codcli from solot t where t.codsolot = p_codsolot;

    return l_codcli;

  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit || '.get_codcli(p_codsolot => ' ||
                              p_codsolot || ') ' || sqlerrm);
  end;
  ---------------------------------------------------------------------------
  function get_nro_contrato(p_codcli solot.codcli%type)
    return ope_srv_recarga_cab.nro_contrato%type is
    l_nro_contrato ope_srv_recarga_cab.nro_contrato%type;

  begin
    select t.nro_contrato
      into l_nro_contrato
      from ope_srv_recarga_cab t
     where t.flg_recarga = '0'
       and t.flg_envio_act <> '0'
       and t.nro_contrato is not null
       and t.codcli = p_codcli;

    return l_nro_contrato;

  exception
    when no_data_found then
      raise_application_error(-20000,
                              'No existe numero de contrato para el cliente:' ||
                              p_codcli);
    when others then
      raise_application_error(-20000,
                              $$plsql_unit || '.get_codcli(p_codcli => ' ||
                              p_codcli || ') ' || sqlerrm);
  end;
  ---------------------------------------------------------------------------
  function get_solot_baja(p_codsolot solot.codsolot%type)
    return solot.codsolot%type is
    l_codcli   solot.codcli%type;
    l_codsolot solot.codsolot%type;

  begin
    l_codcli := get_codcli(p_codsolot);

    select t.codsolot
      into l_codsolot
      from ope_srv_recarga_cab t
     where t.flg_recarga = '0'
       and t.flg_envio_act <> '0'
       and t.nro_contrato is not null
       and t.codcli = l_codcli;

    return l_codsolot;

  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit || '.get_solot_baja(p_codsolot => ' ||
                              p_codsolot || ') ' || sqlerrm);
  end;
  ---------------------------------------------------------------------------
  function obt_co_id_sisact(ac_num_contrato in varchar2,
                            ac_num_sot      in varchar2) return varchar2 is
    lc_co_id varchar2(50);
  begin
    select cd.co_id
      into lc_co_id
      from usrpvu.sisact_ap_contrato@DBL_PVUDB     co, --2.0
           usrpvu.sisact_ap_contrato_det@DBL_PVUDB cd  --2.0
     where co.contn_numero_contrato = cd.id_contrato
       and (co.contn_numero_contrato = ac_num_contrato or
           co.contn_numero_sot = ac_num_sot);

    return lc_co_id;
  exception
    when others then
      lc_co_id := null;
      return lc_co_id;
  end;
  ---------------------------------------------------------------------------
  function get_user return opedd.codigoc%type is
    l_codigoc opedd.codigoc%type;

  begin
    select d.codigoc
      into l_codigoc
      from tipopedd c, opedd d
     where c.abrev = 'dth_migracion'
       and c.tipopedd = d.tipopedd
       and d.abreviacion = 'user_bscs';

    return l_codigoc;

  exception
    when no_data_found then
      raise_application_error(-20000,
                              'Debe de configurar un codigo de Usuario');
    when others then
      raise_application_error(-20000,
                              $$plsql_unit || '.get_user() ' || sqlerrm);
  end;
  ---------------------------------------------------------------------------
end pkg_dth_migracion;
/