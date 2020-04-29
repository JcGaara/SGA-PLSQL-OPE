CREATE OR REPLACE PACKAGE OPERACION.PQ_SGA_IW IS

  /*******************************************************************************************************
   NOMBRE:       OPERACION.PQ_SGA_BSCS
   PROPOSITO:    Paquete de objetos necesarios para la Conexion del SGA - BSCS
   REVISIONES:
   Version    Fecha       Autor            Solicitado por    Descripcion
   ---------  ----------  ---------------  --------------    -----------------------------------------
    1.0       09/08/2013  Edilberto Astulle                  00
    2.0       06/10/2015  Marco de la Cruz                   SD-433116 - Mejorar el Flujo de Provisión HFC (SGA-IW)
    3.0       29/10/2015  Juan Gonzales    Joel Franco       SD-507517 - Anulación de SOT y asignación de número telefónico
  4.0       24/11/2015                                     SD-438726
    5.0      14/12/2015  Luis Flores               SGA-SD-560640
    6.0      8/1/2016    Carlos Terán              SD-606329 Corregir ciclo de facturacion despues de un cambio de plan y reg SOA
    7.0      8/2/2016    Carlos Terán              SD-596715 Se activa la facturación en SGA (Alineación)
    8.0      15/02/2016  Alfonso Muñante           SGA-SD-438726-1
    9.0      28/04/2016                            SD-642508-1 Cambio de Plan Fase II
    10.0     19/01/2017  Servicio Fallas-HITSS              Migración WIMAX a LTE
    11.0     28/02/2017  Servicio Fallas-HITSS      INC000000697906
  *******************************************************************************************************/
  C_COD_RPTA_ERROR CONSTANT VARCHAR2(1) := '1';
  C_COD_RPTA_OK CONSTANT VARCHAR2(1) := '0';
  FND_ESTADO_EXITO CONSTANT VARCHAR2(1) := '1';
  FND_ESTADO_ERROR CONSTANT VARCHAR2(1) := '0';
  G_CODSOLOT NUMBER;

 PROCEDURE p_genera_sot_baja_oac; -- 3.0
 procedure p_genera_sot_reconexion_oac;
 procedure p_genera_sot_suspension_oac;
 procedure p_genera_sot_corte_oac;

 procedure p_genera_sot_oac(av_cod_id    in solot.cod_id%type,
                          an_idtrancorte  in number,
                          an_idgrupocorte in number,
                          an_cod_rpta     out number,
                          ac_msg_rpta     out varchar2);

 procedure p_insert_sot_oac(v_codcli   in solot.codcli%type,
                       v_tiptra   in solot.tiptra%type,
                       v_tipsrv   in solot.tipsrv%type,
                       v_grado    in solot.grado%type,
                       v_motivo   in solot.codmotot%type,
                       v_areasol  in solot.areasol%type,
                       a_idoac in number,
                       a_codsolot out number);


 procedure p_insert_solotpto_oac(an_idlog in  collections.logtrsoac_bscs.idlog%type,
                               an_codsolot      in solot.codsolot%type,
                               an_codsolot_b    in solot.codsolot%type,
                               av_codcli        in varchar2,
                               av_numslc        in varchar2,
                               ac_resultado     out varchar2,
                               ac_mensaje       out varchar2,
                               an_puntos        out number);

 procedure p_reg_log_oac(an_tipo         number,
                       an_idlog       in out collections.logtrsoac_bscs.idlog%type,
                       an_cod_id       collections.logtrsoac_bscs.cod_id%type,
                       av_codcli       collections.logtrsoac_bscs.codcli%type,
                       av_numslc       collections.logtrsoac_bscs.numslc%type,
                       an_idgrupocorte collections.logtrsoac_bscs.idgrupocorte%type,
                       an_idtrancorte  collections.logtrsoac_bscs.idtrancorte%type,
                       ac_proceso      collections.logtrsoac_bscs.proceso%type,
                       ac_texto        collections.logtrsoac_bscs.texto%type,
                       ac_codsolot     collections.logtrsoac_bscs.codsolot%type,
                       an_canttickler  collections.logtrsoac_bscs.cant_tickler%type);   --6.0


 procedure p_genera_xml_baja(a_idtareawf in number,
                               a_idwf      in number,
                               a_tarea     in number,
                               a_tareadef  in number) ;

 procedure p_genera_xml_scr(a_idtareawf in number,
                               a_idwf      in number,
                               a_tarea     in number,
                               a_tareadef  in number);

 procedure p_envio_xml_baja(a_idtareawf in number,
                               a_idwf      in number,
                               a_tarea     in number,
                               a_tareadef  in number);

 procedure p_envio_xml_scr(a_idtareawf in number,
                               a_idwf      in number,
                               a_tarea     in number,
                               a_tareadef  in number);

 procedure p_genera_sot_baja ;

 procedure p_genera_sot_bscs(as_customer_id in varchar2,
                           ad_cod_id      in sales.sot_sisact.cod_id%type,
                           an_tiptra      in number,
                           ad_fecprog     in date,
                           as_franja      in varchar2,
                           an_codmotot    in motot.codmotot%type,
                           as_observacion in solot.observacion%type,
                           as_plano       in vtatabgeoref.idplano%type,
                           as_usuarioreg  in solot.codusu%type,
                           o_codsolot     out number,
                           o_res_cod      out number,
                           o_res_desc     out varchar2);

 procedure p_envia_ws_desactiva_baja(an_codsolot number,
                                    an_coderror out number,
                                    av_msgerror out varchar2);

 procedure p_valida_contrato(n_cod_id number,
                            an_codsolot number,
                            av_tipo varchar2,
                            an_coderror out number,
                            av_msgerror out varchar2);

 procedure p_desactiva_contrato(a_idtareawf in number,
                               a_idwf      in number,
                               a_tarea     in number,
                               a_tareadef  in number);

 procedure p_desactiva_bscs_hfc(a_idtareawf in number,
                               a_idwf      in number,
                               a_tarea     in number,
                               a_tareadef  in number);


 procedure p_reg_log(ac_codcli OPERACION.SOLOT.CODCLI%type,an_customer_id number,
    an_idtrs number,an_codsolot number,an_idinterface number,
    an_error number, av_texto varchar2,an_cod_id number default 0,av_proceso varchar default '');--10.0

 function f_val_sotbaja_hfc(an_codsolot number) return number;

 function f_val_sotrechazada_hfc(an_codsolot number) return number; --3.0

 function f_obtener_ciclo_bscs( an_cod_id number ) return varchar2; --10.0

 procedure p_ejecutar_baja_janus(an_codsolot number, an_error out number , av_error out varchar2);

 procedure p_cons_numtelefonico_sot(an_codsolot in number,
                                     av_numero out varchar2,
                                     av_codcli out varchar2,
                                     an_cod_id out number,
                                     an_customerid out number,
                                     an_codinssrv out number,
                                     an_error out number,
                                     av_error out varchar2);

-- Consulta si el numero existe en Janus
 procedure p_cons_linea_janus(av_numero      in varchar2,
                               an_out         out number,
                               av_mensaje     out varchar2,
                               av_customer_id out varchar2,
                               an_codplan     out number,
                               av_producto    out varchar2,
                               ad_fecini      out date,
                               av_estado      out varchar2,
                               av_ciclo       out varchar2);

 function f_val_tipo_serv_sot(an_codsolot number) return number ;

 function f_valida_prov_numero(av_customerid varchar2) return number;

 procedure p_insert_prov_bscs_janus(an_actionid number,
                                     an_priority number,
                                     an_customerid number,
                                     an_cod_id number,
                                     av_estadoprv varchar2,
                                     an_tarea number,
                                     av_trama varchar2,
                                     an_error out number,
                                     av_msgerror out varchar2);

 procedure p_insert_prov_ctrl_janus(an_actionid number,
                                     an_priority number,
                                     av_customerid varchar2,
                                     an_cod_id number,
                                     av_estadoprv varchar2,
                                     av_trama varchar2,
                                     an_error out number,
                                     av_msgerror out varchar2);
-- procedimiento que valida si esta alineado en Janus y BSCS
 procedure p_val_datos_linea_janus(av_tipo in varchar2,
                                    an_codsolot in number,
                                    an_cod_id in number,
                                    av_numero in varchar2,
                                    av_customerjanus in varchar2,
                                    an_codplanjanus in number,
                                    av_ciclojanus in varchar2,
                                    an_valida out number,
                                    av_mensaje out varchar2) ;

 function f_val_prov_janus_pend(an_cod_id number) return number;

 procedure p_genera_sot_suspension;

 procedure p_genera_sot_reconexion;

 function f_obtiene_valores_scr(p_abreviacion opedd.abreviacion%type)return varchar2;

 procedure p_genera_reconexion(a_idtareawf in number,
                               a_idwf      in number,
                               a_tarea     in number,
                               a_tareadef  in number);

  procedure p_actualiza_contrato_rx(a_idtareawf in number,
                               a_idwf      in number,
                               a_tarea     in number,
                               a_tareadef  in number);

 procedure p_genera_corte_suspension(a_idtareawf in number,
                               a_idwf      in number,
                               a_tarea     in number,
                               a_tareadef  in number);

 procedure p_actualiza_contrato_sp(a_idtareawf in number,
                               a_idwf      in number,
                               a_tarea     in number,
                               a_tareadef  in number);

 function f_retorna_xml_recorta(av_xml clob) return varchar2;

 procedure p_cambio_ciclo_bscs(an_codsolot number,
                                an_cod_idold number,
                                an_error out number,
                                av_error out varchar2);

 function f_val_trs_susp(an_cod_id number,an_servi_cod number,ad_servd_fecha_reg date)  return number;

 function f_val_factura_contrato(an_co_id number) return number;

 function f_val_status_contrato(an_co_id number) return number;

 function f_val_nofact_act_contr(an_co_id number) return varchar2;

 procedure p_cambio_newciclo_bscs(an_codsolot number,
                                   an_cod_idold number,
                                   av_newciclo varchar2,
                                   an_error out number,
                                   av_error out varchar2);

 procedure sp_valida_suspension( p_co_id        IN  INTEGER,
                                 p_nro_dias     IN  INTEGER,
                                 p_fideliza     IN  INTEGER,
                                 p_fec_susp     IN  VARCHAR2,
                                 p_username     IN  VARCHAR2, --6.0
                                 p_tickler_code in  varchar2, --6.0
                                 p_tickler_desc in varchar2, --6.0
                                 p_estado       OUT INTEGER,
                                 p_customer_id  OUT INTEGER,
                                 p_dn_num       OUT VARCHAR2,
                                 p_email        OUT VARCHAR2 );

 procedure sp_contract_suspension( p_co_id        IN  NUMBER,
                                   p_tickler_code IN  VARCHAR2,
                                   p_tickler_des  IN  VARCHAR2,
                                   p_reason       IN  NUMBER,
                                   p_username     IN  VARCHAR2,
                                   p_request_id   OUT NUMBER );



 procedure sp_valida_reactivacion( p_co_id        IN  INTEGER,
                                   p_username     IN  VARCHAR2,
                                   p_tickler_code IN  VARCHAR2,
                                   p_estado       OUT INTEGER);

 -- Ini 6.0
 procedure p_cierre_tickler_code_bscs(an_co_id number,
                                      av_username varchar2,
                                      av_tickler_code varchar2,
                                      an_coderror out number);

 procedure p_create_tickler_code_bscs(p_co_id number,
                                      p_tickler_code varchar2,
                                      p_tickler_des varchar2,
                                      p_username varchar2,
                                      an_coderror out number
                                      );

 function f_val_ult_sot_susp_co_id(an_cod_id number) return number;

 -- Fin 6.0

 procedure sp_contract_reactivation( p_co_id        IN  NUMBER,
                                     p_tickler_code IN  VARCHAR2,
                                     p_username     IN  VARCHAR2,
                                     p_request_id   OUT NUMBER );

 procedure p_insert_ope_sol_siac(an_cod_id number,
                                av_customer_id varchar2,
                                av_xml varchar2,
                                ad_fecha_reg date,
                                av_tipo_serv varchar2,
                                av_co_ser varchar2,
                                an_servi_cod number,
                                av_tipo_reg varchar2,
                                av_codinteracion varchar2,
                                an_fideliza number,
                                ad_fecha_prog date,
                                an_idseq out number,
                                an_coderror out number,
                                av_msgerror out varchar2);

 procedure p_update_ope_sol_siac(an_idseq number,
                                an_codsolot number,
                                an_customer_id number,
                                an_estado number,
                                an_coderror_rpta number,
                                av_coderror_rpta varchar2,
                                an_coderror out number,
                                av_msgerror out varchar2);

 procedure p_update_postt_serv_fija(an_servc_estado number,
                                           av_servv_men_error varchar2,
                                           an_servv_cod_error number,
                                           an_co_id number,
                                           an_servi_cod number,
                                           ad_servd_fecha_reg date,
                                           an_coderror out number,
                                           av_msgerror out varchar2);

 procedure p_regulariza_reques_pend(an_cod_id number,
                                     an_coderror out number,
                                     av_msgerror out varchar2);

 function f_valida_envio_res_act_iw(an_codsolot number) return number;

 function f_max_sot_x_cod_id(an_cod_id number) return number;

 procedure p_update_prov_hfc_bscs(a_idtareawf in number,
                                  a_idwf      in number,
                                  a_tarea     in number,
                                  a_tareadef  in number) ;

 function f_val_baja_co_id_customer_id(an_customer_id number, an_cod_id number) return number;

 procedure p_reg_serv_cod_id_sot(an_cod_id in number, an_codsolot out number);

 procedure p_act_desact_srv_auto_rx(a_idtareawf in number,
                                   a_idwf      in number,
                                   a_tarea     in number,
                                   a_tareadef  in number);

 function f_val_ticklerrecord_siac_open(an_co_id number, p_tickler_code varchar2)
    return number;

 procedure p_gen_envia_xml_src_iw(a_idtareawf in number,
                                   a_idwf      in number,
                                   a_tarea     in number,
                                   a_tareadef  in number);

 function f_val_tickler_records_oac(an_co_id number) return number;

 procedure p_gen_envia_xml_baja(a_idtareawf in number,
                                     a_idwf      in number,
                                     a_tarea     in number,
                                     a_tareadef  in number);

 function f_val_cambioplan_cod_id_old(an_cod_old number, an_customer_id number) return number;

 procedure p_actualiza_ciclo_bscs(an_codsolot_alta number,
                                an_cod_id number,
                                an_codsolot_baja number,
                                an_error out number,
                                av_error out varchar2);
 
 --Ini 11.0
 Function f_obt_cli_idprod (p_idproducto IN producto.idproducto%TYPE) return number;
 
 Function f_obt_idplano (p_codsuc IN marketing.vtasuccli.codsuc%TYPE) return number;
 --Fin 11.0
 FUNCTION F_RETORNA_SELECT_STATUS(P_LV_CH_STATUS VARCHAR2, P_LV_CH_PENDING VARCHAR2) RETURN NUMBER;
   
END PQ_SGA_IW;
/