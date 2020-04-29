CREATE OR REPLACE PACKAGE OPERACION.PQ_SGA_SIAC IS

  /****************************************************************************************************

  ***
     NOMBRE:       OPERACION.PQ_SGA_SIAC
     PROPOSITO:    Paquete de objetos necesarios para la conexion del SGA - SIAC
     REVISIONES:
     Version    Fecha       Autor                  Solicitado por    Descripcion
     ---------  ----------  ---------------        --------------  -----------------------------------------
      1.0       04/11/2015                    00
      2.0  08/02/2016  Carlos Terán     Karen Velezmoro   SD-596715 Se activa la facturación en SGA (Alineación)
      3.0       16/03/2016  Alfonso Muñante                    SGA-SD-337664 SERVICIO ADICIONAL CABLE
      4.0       26/05/2016  Alfonso Muñante                    SGA-SD-337664-1 SERVICIO ADICIONAL CABLE
                01/09/2016  Alfonso Muñante                    SD-865432
      5.0       16/11/2016  Servicio Fallas-HITSS  Melvin Balcazar   SD-897090 Correccion del costo que mandan a BSCS
    6.0       07/01/2016  Servicio Fallas-HITSS              SD982863
      7.0       14/03/2017  Servicio Fallas-HITSS  Carlos Terán    INC000000731747 - Error en la generación de SOT de Alta Serv Adicional
      9.0       06/04/2017  Rodolfo Peña             Juan Reyna    PROY-19003 - Mejoras claro club
    10.0      18/04/2017  Servicio Fallas-HITSS                  INC000000677720
      11.0      11/05/2017  Servicio Fallas-HITSS  Carlos Terán    INC000000795494 - Error en la generación de SOT de Alta-Baja Servicios Adicionales
      12.0      20/07/2017  Felipe Maguiña                         PROY-27792
  *****************************************************************************************************

  **/

  type gc_salida is REF CURSOR;
  type o_mensaje is REF CURSOR;

  type detalle_vtadetptoenl_type is record(
    descpto     vtadetptoenl.descpto%type,
    dirpto      vtadetptoenl.dirpto%type,
    ubipto      vtadetptoenl.ubipto%type,
    codsuc      vtadetptoenl.codsuc%type,
    codinssrv   vtadetptoenl.codinssrv%type,
    estcts      vtadetptoenl.estcts%type,
    tipsrv      solot.tipsrv%type,
    codcli      solot.codcli%type,
    cantidad    vtadetptoenl.cantidad%type,
    areasol     solot.areasol%type,
    customer_id solot.customer_id%type,
    iddet       detalle_paquete.iddet%type,
    idpaq       paquete_venta.idpaq%type);

  TYPE arr_det_dec IS RECORD(
    lv_idproducto operacion.trs_interface_iw.id_producto%type,
    ln_modelo     operacion.trs_interface_iw.modelo%TYPE);
  TYPE ARR_SIAC_SERV IS TABLE OF arr_det_dec INDEX BY BINARY_INTEGER;

  procedure p_consulta_equ_IW(av_customer_id in varchar2,
                              ac_equ_cur     out gc_salida,
                              an_resultado   out number,
                              tipoBusqueda   in number,
                              av_mensaje     out varchar2);

  TYPE t_array IS TABLE OF VARCHAR2(32767) INDEX BY BINARY_INTEGER;

  procedure p_inst_serv_act(n_customerid intraway.servicio_activos_iw.customer_id%type);

  function detalle_vtadetptoenl_baja(n_codsolot operacion.solot.codsolot%type)
    return detalle_vtadetptoenl_type;

  function get_parametro_deco(p_abreviacion opedd.abreviacion%type,
                              p_codigon_aux opedd.codigon_aux%type)
    return varchar2;

  function obt_sot_dec_adi(v_id_producto varchar2) return number;

  function valida_modelo(v_modelo varchar2, v_id_producto varchar2)
    return number;

  Function f_val_servicio(v_idproducto varchar2) return number;

  Function f_crea_solot_baja(n_cod_id      operacion.solot.cod_id%type,
                             n_customer_id operacion.solot.customer_id%type,
                             n_codsolot    operacion.solot.codsolot%type)
    return number;

  procedure registrar_solotpto(n_codsolot     operacion.solot.codsolot%type,
                               n_pid          operacion.solotpto.pid%type,
                               n_codsolot_ant operacion.solot.codsolot%type);

  function get_wfdef return number;

  procedure p_val_num_serie(v_numserie    operacion.solotptoequ.numserie%type,
                            v_id_producto varchar2,
                            n_codsolot    operacion.solot.codsolot%type,
                            v_modelo      operacion.solotptoequ.codequcom%type,
                            n_coderror    out number,
                            v_mensaje     out varchar2);

  PROCEDURE p_crea_sot_baja(n_cod_id      operacion.solot.cod_id%type,
                            n_customer_id operacion.solot.customer_id%type,
                            arr_siac      ARR_SIAC_SERV,
                            P_MSGERR      out varchar2,
                            n_coderror    out number);
  -- Inicio para incidencia SD-534868 - 20/11/2015 - D.H
  Function split(p_list varchar2, p_del varchar2) return split_tbl
    pipelined;

  FUNCTION SPLIT1(p_in_string VARCHAR2, p_delim VARCHAR2) RETURN t_array;

  Procedure p_baja_deco_adicional(n_cod_id      operacion.solot.cod_id%type,
                                  n_customer_id operacion.solot.codsolot%type,
                                  v_cadena      IN VARCHAR2,
                                  n_error       OUT NUMBER,
                                  v_mensaje     OUT VARCHAR2);
  -- Fin para incidencia SD-534868 - 20/11/2015 - D.H

  procedure p_gen_sot_servadic;

  procedure p_gen_sot_baja_servadic;

  procedure sp_valida_servadic(p_co_id    IN INTEGER,
                               p_estado   OUT INTEGER);

  procedure p_prov_svradi_bscs(a_idtareawf in number,
                               a_idwf      in number,
                               a_tarea     in number,
                               a_tareadef  in number);

  procedure p_pre_svradi_iw(a_idtareawf in number,
                            a_idwf      in number,
                            a_tarea     in number,
                            a_tareadef  in number);

  procedure p_pos_svradi_iw(a_idtareawf in number,
                            a_idwf      in number,
                            a_tarea     in number,
                            a_tareadef  in number);

  procedure p_act_est_coid(a_idtareawf in number,
                            a_idwf      in number,
                            a_tarea     in number,
                            a_tareadef  in number);

  function f_obtiene_valores_scr(p_abreviacion opedd.abreviacion%type)
    return varchar2;

  PROCEDURE p_reg_insprd_servadi(p_cod_id sales.sot_sisact.cod_id%TYPE,
                                 n_codsrv in tystabsrv.codsrv%TYPE,
                                 n_pid out insprd.pid%TYPE);

  function f_obt_cod_siac(v_co_ser operacion.ope_sol_siac.co_ser%TYPE,
                          v_des_ext varchar2) return varchar2;

  procedure p_genera_sot_sga_sa(as_customer_id in varchar2,
                              ad_cod_id      in sales.sot_sisact.cod_id%type,
                              an_tiptra      in number,
                              ad_fecprog     in date,
                              as_franja      in varchar2,
                              an_codmotot    in motot.codmotot%type,
                              as_observacion in solot.observacion%type,
                              as_plano       in vtatabgeoref.idplano%type,
                              as_usuarioreg  in solot.codusu%type,
                              an_pid         in insprd.pid%type,
                              o_codsolot     out number,
                              o_res_cod      out number,
                              o_res_desc     out varchar2);

  procedure p_gen_sot_siac(as_numslc      vtatabslcfac.numslc%type,
                           a_codcli       vtatabcli.codcli%type,
                           a_tiptra       in number,
                           a_codmotot     in number,
                           a_codcon       in number,
                           a_codcuadrilla in operacion.ope_cuadrillaxdistrito_det.codcuadrilla%type,
                           ad_feccom      in agendamiento.fecreagenda%type,
                           a_observacion  in solot.observacion%type,
                           a_idplano      in varchar2 default null,
                           a_tiposervico  in number,
                           an_pid         in insprd.pid%type,
                           a_codsolot     out number);
  procedure p_ini_fac_svradi_bscs(a_idtareawf in number,
                                  a_idwf      in number,
                                  a_tarea     in number,
                                  a_tareadef  in number);

  function f_val_trs_ser_adic(an_cod_id          number,
                              an_servi_cod       number,
                              ad_servd_fecha_reg date,
                              an_co_ser          varchar2) return number; --11.0

  procedure p_insert_ope_sol_siac_sadic(an_cod_id        number,
                                        av_customer_id   varchar2,
                                        av_xml           varchar2,
                                        ad_fecha_reg     date,
                                        av_tipo_serv     varchar2,
                                        av_co_ser        varchar2,
                                        an_servi_cod     number,
                                        av_tipo_reg      varchar2,
                                        av_codinteracion varchar2,
                                        an_fideliza      number,
                                        ad_fecha_prog    date,
                                        an_idseq         out number,
                                        an_coderror      out number,
                                        av_msgerror      out varchar2);

  procedure p_update_postt_serv_fija_sadic(an_servc_estado    number,
                                           av_servv_men_error varchar2,
                                           an_servv_cod_error number,
                                           an_co_id           number,
                                           an_servi_cod       number,
                                           ad_servd_fecha_reg date,
                                           an_co_ser          number,
                                           an_coderror        out number,
                                           av_msgerror        out varchar2);

  PROCEDURE consulta_servicio_comercial ( p_co_id  IN  INTEGER,
                                           p_co_ser IN  INTEGER,
                                           v_estado OUT VARCHAR2,
                                           v_errnum OUT INTEGER,
                                           v_errmsj OUT VARCHAR2 );

-- Inicio para incidencia SD-865432
  /*function f_val_alta_ser_adic_flujo(an_cod_id number, an_co_ser number)
    return number;
  -- Fin para incidencia SD-865432*/
function f_val_alta_newflujo(an_cod_id number, an_co_ser number)
    return number;
procedure p_update_eai_contrato(d_fecinirecsiac in date);
-- Inicio para incidencia INC000000731747
  function f_cont_servicioprog_porest(estado char, p_servi_cod integer default 14) return number; --11.0
-- Fin para incidencia INC000000731747

/* <Ini 9.0> */
   function f_obtener_proceso_iw(p_abreviacion opedd.abreviacion%type, an_tiptra opedd.codigon%type) return varchar2;


   procedure p_act_desact_serv_cclub(a_idtareawf in number,
                                    a_idwf      in number,
                                    a_tarea     in number,
                                    a_tareadef  in number);
   /* <Fin 9.0> */

   --Ini 10.0
  procedure lista_decos(p_customer_id varchar2,
                        p_cod_id      solot.cod_id%type,
                        p_decos       out sys_refcursor);

  procedure valida_deco_hd(p_productos varchar2,
                           p_codsolot  number,
                           p_valida    out number);

  function es_decohd(p_codigo varchar2) return number;

  procedure actualiza_pid(p_productos varchar2,
                          p_codsolot  number);
  --Fin 10.0
  --Ini 12.0
  PROCEDURE SIACSS_EQU_IW_TIP(av_customer_id IN VARCHAR2,
                              an_cod_id      IN NUMBER,
                              ac_equ_cur     OUT gc_salida,
                              an_resultado   OUT NUMBER,
                              tipoBusqueda   IN NUMBER,
                              av_mensaje     OUT VARCHAR2);

  FUNCTION SGAFUN_OBT_SNCODE(an_cod_id IN NUMBER, an_idproducto IN NUMBER)
    RETURN NUMBER;
  --Fin 12.0
  PROCEDURE SP_PROV_ADIC_HFC(AN_COD_ID   IN NUMBER,
                             AN_CODSOLOT IN NUMBER,
                             AV_ACTION   IN VARCHAR2);
                             
  function get_codinssrv(p_cod_id  operacion.solot.cod_id%type,
                        av_codsrv tystabsrv.codsrv%type)
   return inssrv.codinssrv%type; 


PROCEDURE SP_PROV_ADIC_JANUS(P_CO_ID       IN INTEGER,
                               P_CUSTOMER_ID IN INTEGER,
                               P_TMCODE      IN INTEGER,
                               P_SNCODE      IN INTEGER,
                               P_ACCION      IN VARCHAR2,
                               P_RESULTADO   OUT INTEGER,
                               P_MSGERR      OUT VARCHAR2);

function f_obt_cod_sncode(v_servv_codigo varchar2) return varchar2;

END PQ_SGA_SIAC;
/
