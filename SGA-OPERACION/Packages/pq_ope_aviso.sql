create or replace package operacion.pq_ope_aviso is

  /************************************************************
  NOMBRE:     PQ_OPE_AVISO
  PROPÓSITO:  Agrupación de funcionalidad de suspensiones, cortes y reconexiones

  REVISIONES:
  Versión      Fecha        Autor           Descripción
  ---------  ----------  ---------------  ------------------------
  1.0        15/11/2011  Alfonso Pérez     Creación
  1.1        19/03/2012  Kevy Carranza     Envío de mensajes a los equipos compatibles con Portal Cautivo
  2.0        13/09/2012  Kevy Carranza     REQ 163208 Portal Cautivo - Exoneracion de evento cobranzas
  3.0        07/10/2013  Isaac Barrios     PROY-4086 Nuevo Sistema de Cobranzas
  4.0        20/02/2017  Servicio Fallas-HITSS         
  ***********************************************************/
  procedure p_genera_registros(an_inicio number);
  procedure p_gen_antesvencimiento(an_caso       number,
                                   an_grupo      number,
                                   an_comando    number,
                                   an_orden      number,
                                   an_aplica_seg number,
                                   an_aplica_sol number,
                                   an_dias       number);

  procedure p_gen_antsuspension(an_caso       number,
                                an_grupo      number,
                                an_comando    number,
                                an_orden      number,
                                an_aplica_seg number,
                                an_aplica_sol number,
                                an_dias       number);
  procedure p_gen_despsuspension(an_caso       number,
                                 an_grupo      number,
                                 an_comando    number,
                                 an_orden      number,
                                 an_aplica_seg number,
                                 an_aplica_sol number,
                                 an_dias       number);
  procedure p_valida_registros(an_tipo number);
  procedure p_setea_campos(an_tipo number);
  procedure p_int_proceso(a_opcion     in number,
                          a_codsolot   in solot.codsolot%type,
                          a_enviar_itw in number default 0);

  procedure p_cm_manager_message(a_estado       in number,
                                 a_cliente      in vtatabcli.codcli%type,
                                 a_pidorigen    in number,
                                 a_pidactual    in number,
                                 a_idmensajecrm in varchar2,
                                 a_proceso      in int_mensaje_intraway.proceso%type,
                                 a_codsolot     in solot.codsolot%type,
                                 o_resultado    in out varchar2,
                                 o_mensaje      in out varchar2,
                                 o_error        in out number,
                                 a_enviar_itw   in number default 1,
                                 a_id_venta     in number default 0);

  procedure p_genera_mensaje_itw(an_inicio number);

  procedure p_ins_mensaje(ar_int_mensaje_itw_cab in int_mensaje_itw_cab%rowtype,
                          ac_resultado           out varchar2,
                          ac_mensaje             out varchar2);

  procedure p_ins_comando_mensaje(ar_int_comandoxmensaje_itw in int_comandoxmensaje_itw%rowtype,
                                  a_cliente                  in vtatabcli.codcli%type,
                                  a_proceso                  in number,
                                  o_resultado                in out varchar2,
                                  o_mensaje                  in out varchar2);
  procedure p_proc_comando_mensaje;

  procedure p_revierte_comando_mensaje(a_iddettranmsj in int_comandoxmensaje_itw.iddettranmsj%type,
                                       a_proceso      in number,
                                       a_enviar_itw   in number default 1,
                                       o_resultado    in out varchar2,
                                       o_mensaje      in out varchar2,
                                       o_error        in out number);

  procedure p_enviacomando(ln_idlote    number,
                           ls_interfase int_comandoxmensaje_itw.id_interfase%type,
                           o_resultado  in out varchar2,
                           o_mensaje    in out varchar2,
                           o_error      in out number);

  procedure p_revisadetalle_comando(an_inicio number);

  function f_obtiene_datos(an_codinssrv number) return number;

  --Ini 1.1
  procedure p_proceso_enviomanual(as_codcli     marketing.vtatabcli.codcli%type,
                                  an_proceso    varchar2,
                                  an_idproducto intraway.int_servicio_intraway.id_producto%type,
                                  an_codinssrv  operacion.inssrv.codinssrv%type,
                                  an_sersut     collections.cxctabfac.sersut%type, --2.0
                                  an_numsut     collections.cxctabfac.numsut%type, --2.0
                                  as_resultado  out varchar2);

  function f_obtiene_idproceso(as_parametro varchar2) return number;

  function f_obtiene_parametro(as_parametro varchar2) return number;

  procedure p_procesa_parametros(an_proceso    out number,
                                 as_idconexion out varchar2,
                                 as_idempresa  out varchar2,
                                 as_resultado  out varchar2);

  procedure p_armar_xml(an_idinterfaz number, as_resultado out varchar2);

  procedure p_ins_int_envio(ar_int_envio intraway.int_envio%ROWTYPE,
                            as_resultado out varchar2);

  procedure p_arma_cab_xml(as_idinterfase  intraway.int_interface.id_interface%type,
                           as_cabecera_xml out intraway.int_interface.cabecera_xml%type,
                           an_asincrono    out intraway.int_interface.asincrono %type,
                           as_resultado    out varchar2);
  --2.0 Se elimina función f_obtiene_valor_xml
  --Ini 3.0
  procedure p_enviar_comando_pc(as_codinssrv   inssrv.codinssrv%type,
                                as_idinterfase intraway.int_envio.id_interfase%type,
                                as_codcli      marketing.vtatabcli.codcli%type,
                                as_idproducto  intraway.int_envio.id_producto%type,
                                an_proceso     varchar2,
				an_tiptrabajo  number,
				an_id_oac      number, 
                                as_resultado   out varchar2);
  --Fin 3.0
  --Fin 1.1

  --Ini 2.0
  procedure p_procesa_registros(an_caso       operacion.ope_segmentomercado_rel.idmensaje%type,
                                an_grupo      operacion.ope_grupomenssol_det.idgrupo%type,
                                an_comando    operacion.ope_inscliente_rel.idcomando%type,
                                an_orden      operacion.ope_inscliente_rel.orden%type,
                                an_aplica_seg number,
                                an_aplica_sol number,
                                an_idlote     number,
                                ls_codcli     operacion.ope_inscliente_rel.codcli%type,
                                ls_nomcli     operacion.ope_inscliente_rel.nomcli%type,
                                ls_idsolucion operacion.ope_inscliente_rel.idsolucion%type,
                                ls_codinssrv  operacion.inssrv.codinssrv%type,
                                ls_nomabr     collections.cxctabfac.nomabr%type,
                                ls_idfac      collections.cxctabfac.idfac%type,
                                ls_codsegmark operacion.ope_segmentomercado_rel.codsegmark%type);

  procedure p_ins_ope_inscliente_rel(ar_ope_inscliente_rel operacion.ope_inscliente_rel%rowtype);

  procedure p_ins_ope_inscliente_cab(p_idlote out operacion.ope_inscliente_cab.id_lote%type);

  function f_val_incidence(as_codcli in collections.cxctabfac.codcli%type,
                           as_sersut in collections.cxctabfac.sersut%type,
                           as_numsut in collections.cxctabfac.numsut%type)
    return number;

  function f_val_estado_incidence(as_codcli in collections.cxctabfac.codcli%type,
                                  as_sersut in collections.cxctabfac.sersut%type,
                                  as_numsut in collections.cxctabfac.numsut%type)
    return number;
  --Fin 2.0

end;
/