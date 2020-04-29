create or replace package operacion.pkg_dth_migracion is
  /******************************************************************************
   REVISIONES:
     Version  Fecha       Autor           Solicitado por      Descripcion
     -------  -----       -----           --------------      -----------
     1.0      2015-11-17  Freddy Gonzales Alberto Miranda     Migracion DTH
	 2.0      2015-11-21  Angel Condori   Alberto Miranda     Alineacion a Produccion
  /* ***************************************************************************/
  function es_migracion(p_numslc vtatabslcfac.numslc%type) return number;

  procedure es_migracion_con_servicio(p_idprocess sales.int_negocio_proceso.idprocess%type,
                                      p_codcli    vtatabcli.codcli%type);

  procedure verifica_contrato(p_codcli vtatabcli.codcli%type);

  function get_datos_dth_migra(p_abreviacion opedd.abreviacion%type)
    return opedd.codigon%type;

  function get_tipo_migracion return sales.int_negocio_proceso.tipo%type;

  function desactivar_contrato(p_codsolot solot.codsolot%type) return number;

  function get_codcli(p_codsolot solot.codsolot%type) return solot.codcli%type;

  function get_nro_contrato(p_codcli solot.codcli%type)
    return ope_srv_recarga_cab.nro_contrato%type;

  function get_solot_baja(p_codsolot solot.codsolot%type)
    return solot.codsolot%type;

  function obt_co_id_sisact(ac_num_contrato in varchar2,
                            ac_num_sot      in varchar2) return varchar2;

  function get_user return opedd.codigoc%type;

end pkg_dth_migracion;
/