CREATE OR REPLACE PACKAGE OPERACION.PQ_IW_SGA_BSCS IS

  /*******************************************************************************************************
   NOMBRE:       OPERACION.PQ_IW_SGA_BSCS
   PROPOSITO:    Paquete de objetos necesarios para la Conexion del SGA - BSCS
   REVISIONES:
   Version    Fecha       Autor            Solicitado por    Descripcion
   ---------  ----------  ---------------  --------------    -----------------------------------------
    1.0       09/08/2013  Edilberto Astulle                  PQT-159305-TSK-30818
    3.0       26/12/2013  Edilberto Astulle                  SD-909038
    4.0       19/04/2014  Edilberto Astulle                  SD_1064022
    5.0       19/05/2014  Edilberto Astulle                  PROY-12361 IDEA-15479 Eliminacion y creacion de reserva y más
    6.0       16/06/2014  Edilberto Astulle                  SD_1126603
    7.0       23/06/2014  Edilberto Astulle                  SD-1137139
    8.0       07/07/2014  Edilberto Astulle                  SD_1126041
    9.0       20/07/2014  Edilberto Astulle                  SD_1158229
    10.0      30/07/2014  Edilberto Astulle                  SD-1172651
    11.0       06/08/2014  Edilberto Astulle     SD_ 7956
    12.0       16/08/2014  Edilberto Astulle     SD-1173230 Problemas para cambio de fecha de compromiso
    13.0       20/08/2014  Edilberto Astulle     SDM_43533
    14.0       13/09/2014  Edilberto Astulle     SD_1169600
    15.0       23/09/2014  Edilberto Astulle     SD_39941 RV Accesos SGA Inventario de site
    16.0       09/10/2014  Dorian Sucasaca       PQT-215228-TSK-60071 Envío de Comandos de SGA a SSW Nortel e IMS
    17.0       04/11/2014  Edilberto Astulle     SD_39941 RV Accesos SGA Inventario de site
    18.0       13/11/2014  Dorian Sucasaca       SD_129848
    19.0       01/12/2014  Edilberto Astulle     SD_120302 Problemas en actualizacion masiva Agenda workflow SGA - Sot de baja HFC
    20.0       15/12/2014  Edilberto Astulle     SD_167445 Deco Pendiente SIAC HFC
    21.0       15/01/2015  Miriam Mandujano      SD_199141 SOT 17267599 - JEYMI BRIGITH CASTILLO LAZO
  22.0       17/04/2015  Michael Boza          SD_288299 Cliente Servicio fijo
  23.0      15/06/2015  Angelo Angulo
      24.0     04/08/2015                        SD-399889 Se debe consumir directamente a la funcion publica F_GET_NUMERO_TEL_ITW
    25.0       04/11/2015  Alfonso Muñante       SD-438726 Se regulariza en bscs la reserva hfc y el registro de servicios
    26.0       15/02/2016  Alfonso Muñante       SGA-SD-438726-1
    27.0       01/04/2016                        SD-642508 Cambio de Plan
  28.0     2016-12-29  Servicios Fallas - Hitss        SD925014
  29.0       20/02/2017  Servicio Fallas - HITSS
  30.0       23/04/2019  Serv. Fallas          INC000001471706
  *******************************************************************************************************/

  FND_IDINTERFACE_CM   constant varchar2(4) := '620';
  FND_IDINTERFACE_CMM  constant varchar2(4) := '628';
  FND_IDINTERFACE_CMSE constant varchar2(4) := '600'; --Servidor E-Mail
  FND_IDINTERFACE_CMCE constant varchar2(4) := '602'; --Cuentas E-Mail
  FND_IDINTERFACE_MTA  constant varchar2(4) := '820';
  FND_IDINTERFACE_EP   constant varchar2(4) := '824';
  FND_IDINTERFACE_CF   constant varchar2(4) := '830';
  FND_IDINTERFACE_STB  constant varchar2(4) := '2020';
  FND_IDINTERFACE_STBI constant varchar2(4) := '2022';
  FND_IDINTERFACE_STB_SA constant varchar2(4) := '2030';
  FND_IDINTERFACE_STB_MTO constant varchar2(4) := '2025';
  FND_IDINTERFACE_STB_VOD constant varchar2(4) := '2050';

  FND_IDSERVICIO_CM   constant varchar2(1) := '1';
  FND_IDSERVICIO_CMM  constant varchar2(1) := '1';
  FND_IDSERVICIO_CMSE constant varchar2(1) := '1'; --Servidor E-Mail
  FND_IDSERVICIO_CMCE constant varchar2(1) := '1'; --Cuentas E-Mail
  FND_IDSERVICIO_MTA  constant varchar2(2) := '20';
  FND_IDSERVICIO_EP   constant varchar2(2) := '21';
  FND_IDSERVICIO_CF   constant varchar2(2) := '22';
  FND_IDSERVICIO_STB  constant varchar2(2) := '50';
  FND_IDSERVICIO_STB_SA constant varchar2(2) := '51';
  FND_IDSERVICIO_STB_VOD constant varchar2(2) := '60';

  FND_TIPSRV_TEL constant varchar2(4) := '0004';
  FND_TIPSRV_INT constant varchar2(4) := '0006';
  FND_TIPSRV_CAB constant varchar2(4) := '0062';
  FND_TIPSRV_EQU constant varchar2(4) := '0050';--14.0

  PROCEDURE p_gen_reserva_iw(a_idtareawf in number,
        a_idwf      in number,
        a_tarea     in number,
        a_tareadef  in number, a_envio number default 0);--4.0

  FUNCTION f_obt_codact(p_a_id_estado    in number,
        p_id_cliente     in varchar2,
        p_id_producto    in varchar2,
        p_id_interfase   in varchar2,
        p_codsolot       in varchar2,
        p_activationcode in varchar2) return varchar2;

  FUNCTION f_obt_arr_pip(a_idtrs in number ) return varchar2;

  procedure p_reg_variable(a_idtrs number,a_parametro varchar2,
        a_valor varchar2,a_interface number);

  procedure p_genera_reserva_iw(a_idtareawf in number,
        a_idwf      in number,
        a_tarea     in number,
        a_tareadef  in number);

  procedure p_inicio_fact(a_idtareawf in number,
       a_idwf      in number,
       a_tarea     in number,
       a_tareadef  in number);

  procedure p_instala_srv_iw(an_codsolot in number,
       av_valores_int in varchar2,
       av_valores_tel in varchar2,
       av_valores_cab in varchar2,
       an_error out number,
       av_error out varchar2);

  FUNCTION F_GET_NCOS(a_codsolot in solot.codsolot%type,
                      a_codsrv   in tystabsrv.codsrv%type,
                      a_opcion   in number) return varchar2;

  function f_obt_channelmap(a_codinssrv in inssrv.codinssrv%type,
                            a_opcion    in number,
                            a_tipo      in number) return varchar2;

  function f_obt_cod_ext_int(an_codsolot in solot.codsolot%type,
                  ac_codsrv in tystabsrv.codsrv%type,
                  an_proceso  number ) return varchar2;

  function f_obt_hub(a_codinssrv in inssrv.codinssrv%type)
  return varchar2 ;

  FUNCTION f_retorno_idiscpe( a_codigo_ext  IN configuracion_itw.codigo_ext%TYPE ) return varchar2;

  PROCEDURE p_interface_cm(a_codcli  IN VARCHAR2,
      a_pid_internet IN NUMBER,
      a_cod_id in number,
      a_codsolot  IN solot.codsolot%TYPE,
      a_codinssrv  IN inssrv.codinssrv%TYPE,
      a_cod_ext  IN tystabsrv.codigo_ext%TYPE,
      a_codact  IN VARCHAR2,
      a_cantcpe  IN NUMBER,
      a_hub      IN intraway.ope_hub.nombre%TYPE DEFAULT NULL,
      a_nodo     IN marketing.vtasuccli.idplano%TYPE DEFAULT NULL,
      o_mensaje  IN OUT VARCHAR2,
      o_error    IN OUT NUMBER);

  PROCEDURE p_interface_mta(a_codcli   IN vtatabcli.codcli%TYPE,
      a_pid_telefonia  IN NUMBER,
      a_pid_internet IN NUMBER,
      a_cod_id in number,
      a_codsolot       IN solot.codsolot%TYPE,
      a_codinssrv      IN inssrv.codinssrv%TYPE,
      a_profilecrmid   IN VARCHAR2, --CMTS
      a_codact  IN VARCHAR2,
      o_mensaje        IN OUT VARCHAR2,
      o_error          IN OUT NUMBER);

  PROCEDURE p_interface_mta_ep(a_codcli   IN vtatabcli.codcli%TYPE,
      a_id_producto        IN NUMBER,
      a_producto_padre    IN NUMBER,
      a_nroendpoint       IN NUMBER,
      a_nrotelefono       IN numtel.numero%TYPE,
      a_homeexchangecrmid IN VARCHAR2,
      a_cod_id in number,
      a_codsolot          IN solot.codsolot%TYPE,
      a_codinssrv         IN inssrv.codinssrv%TYPE,
      o_mensaje           IN OUT VARCHAR2,
      o_error             IN OUT NUMBER);

  PROCEDURE p_interface_mta_fac(a_codcli IN vtatabcli.codcli%TYPE,
      a_id_producto        IN NUMBER,
      a_producto_padre    IN NUMBER,
      a_pid_telefonia  IN NUMBER,
      a_codigo_ext IN tystabsrv.codigo_ext%TYPE,
      a_cod_id in number,
      a_codsolot IN solot.codsolot%TYPE,
      a_codinssrv  IN int_servicio_intraway.codinssrv%TYPE,
      o_mensaje   IN OUT VARCHAR2,
      o_error  IN OUT NUMBER);

  PROCEDURE p_interface_stb(a_codcli IN vtatabcli.codcli%TYPE,
       a_pid_stb IN NUMBER,
       a_pid_cab IN NUMBER,
       a_codact  IN VARCHAR2,
       a_codigo_ext  IN VARCHAR2,
       a_channelmap      IN VARCHAR2,
       a_configcrmid     IN VARCHAR2,
       a_cod_id in number,
       a_codsolot        IN solot.codsolot%TYPE,
       a_codinssrv       IN inssrv.codinssrv%TYPE,
       a_sendtocontroler IN VARCHAR2,
       o_mensaje         IN OUT VARCHAR2,
       o_error           IN OUT NUMBER);

  PROCEDURE p_interface_stb_vod(a_codcli IN VARCHAR2,
       a_pid_stb_fac IN NUMBER,
       a_pid_stb IN NUMBER,
       a_pid_cable IN NUMBER,
       a_codigo_ext  IN tystabsrv.codigo_ext%TYPE,
       a_cod_id in number,
       a_codsolot IN solot.codsolot%TYPE,
       a_codinssrv IN int_servicio_intraway.codinssrv%TYPE,
       o_mensaje IN OUT VARCHAR2,
       o_error IN OUT NUMBER);

  PROCEDURE p_interface_stb_sa(a_codcli IN vtatabcli.codcli%TYPE,
      a_pid_stb_fac IN NUMBER,
      a_pid_stb IN NUMBER,
      a_pid_cable IN NUMBER,
      a_codigo_ext IN tystabsrv.codigo_ext%TYPE,
      a_cod_id in number,
      a_codsolot        IN solot.codsolot%TYPE,
      a_codinssrv       IN int_servicio_intraway.codinssrv%TYPE,
      o_mensaje         IN OUT VARCHAR2,
      o_error           IN OUT NUMBER);

  PROCEDURE p_interface_stb_manto(a_codcli IN vtatabcli.codcli%TYPE,
      a_id_producto IN int_servicio_intraway.id_producto%TYPE DEFAULT '0',
      a_cod_id in number,
      a_codsolot    IN solot.codsolot%TYPE DEFAULT '0',
      a_codinssrv   IN inssrv.codinssrv%TYPE DEFAULT '0',
      a_comando     IN VARCHAR2,
      o_mensaje     IN OUT VARCHAR2,
      o_error       IN OUT NUMBER);

  procedure p_reg_log(ac_codcli OPERACION.SOLOT.CODCLI%type,an_customer_id number,
      an_idtrs number,an_codsolot number,an_idinterface number,
      an_error number, av_texto varchar2,an_cod_id number default 0,av_proceso varchar default '');--10.0

Procedure p_asignar_numero(a_codsolot in number,a_numero in varchar2,o_mensaje IN OUT VARCHAR2,o_error IN OUT NUMBER);--13.0

function f_sot_desde_sisact(an_codsolot operacion.solot.codsolot%TYPE,an_codigo number default 0)
    return number;

--Inicio 5.0
procedure p_instala_srv_adic(an_codsolot in number,av_valores_cab in varchar2,
     an_error out number,av_error out varchar2);

procedure p_alinear_res_bscs(an_codsolot in number,an_error out integer,av_error out varchar2);

procedure p_regenera_prov_res(an_codsolot in number,an_error out integer,av_error out varchar2);
--13.0
procedure p_relanzar_inst(an_codsolot in number,an_idtrs in number, av_tip_interfase in varchar2,av_valores in varchar2,
     an_error out integer,av_error out varchar2);--20.0

procedure p_gen_cargo_traslado(a_idtareawf in number,a_idwf in number,
     a_tarea in number,a_tareadef in number);

procedure p_consulta_estado_prov(an_codsolot in number,av_proceso in varchar2,an_error out integer,av_error out varchar2);

procedure p_consulta_estado_prov2(an_codsolot in number,av_proceso in varchar2,an_error out integer,av_error out varchar2);

procedure p_consulta_estado_prov3(an_codsolot in number,av_trama out varchar2,an_error out integer,av_error out varchar2);
--6.0
procedure p_consulta_estado_prov4(an_codsolot in number,av_action_id in varchar2,an_id_producto in number,av_tipo_srv in varchar2, av_trama out varchar2,an_error out integer,av_error out varchar2);
--7.0
procedure p_gen_reserva_shell(an_error out integer,av_error out varchar2);

procedure p_act_bscs_ivr(an_codsolot in number,an_error out integer,av_error out varchar2);

procedure p_manto_stb_mat(an_codsolot in number,an_id_producto in number,av_comando in varchar2,an_error out integer,av_error out varchar2);

procedure p_actualiza_valores(an_idtrs in number,av_atributo in varchar2,av_valor in varchar2,an_error out integer,av_error out varchar2);

function f_cadena(ac_cadena in varchar2,an_caracter in varchar2, an_posicion in number) return varchar2;
--8.0
procedure P_act_info_sga_bscs(an_customer_id in number,an_cod_id in number,an_cod_err_bscs in number,av_error in varchar2,an_cod_error out number,av_msg_error out varchar2);
--12.0
procedure P_desactivacion_contrato(an_cod_id in number);

procedure P_eliminar_reserva(an_cod_id in number,av_tiposerv in varchar2,an_idproducto in number,an_error out number,av_error out varchar2);

procedure P_liberar_reserva(an_cod_id in number,av_tiposerv in varchar2,an_idproducto in number,an_error out number,av_error out varchar2);
--15.0
procedure p_cambio_estado_sot(a_idtareawf in number,a_idwf in number,
a_tarea in number,a_tareadef in number,a_tipesttar in number,a_esttarea in number,
a_mottarchg in number,a_fecini in date,a_fecfin in date);
--19.0
procedure p_inst_equipo_ivr(an_codsolot in number,av_tiposerv in varchar2,an_idproducto in number,av_nroserie in varchar2, an_error out number,av_error out varchar2);
procedure p_gen_cambio_direccion_iw(an_codsolot in number);
procedure p_gen_traslado_extHFC(an_codsolot in number,an_customerid in number,av_notasdireccion in varchar2,
av_codigo_plano in varchar2,av_direccion in varchar2,av_ubigeo in varchar2,an_error in out number,av_error in out varchar2);
--ini 25.0
procedure p_reg_rsv_dec_adic(a_idtareawf in number,
                                                              a_idwf      in number,
                                                              a_tarea     in number,
                                                              a_tareadef  in number);
--fin 25.0
  --Ini 30.0
  procedure p_replica(a_codcli    vtatabcli.codcli%type,
                      a_codsolot  solot.codsolot%type,
                      a_pid       number,
                      a_codinssrv inssrv.codinssrv%type,
                      a_cod_id    number,
                      a_codact    varchar2,
                      a_interface number,
                      o_mensaje   out varchar2,
                      o_error     out number);
  
  procedure p_replica_interface_iw_det(a_idtrs_new number,
                                       a_idtrs_old number,
                                       a_codact    varchar2,
                                       a_interface number,
                                       o_mensaje   out varchar2,
                                       o_error     out number);
  
  procedure p_replica_interface_iw(a_idtrs_new number,
                                   a_idtrs_old number,
                                   a_codcli    varchar2,
                                   a_pid       number,
                                   a_codsolot  solot.codsolot%type,
                                   a_codinssrv inssrv.codinssrv%type,
                                   a_cod_id    number,
                                   a_interface number,
                                   a_codact    varchar2,
                                   o_mensaje   out varchar2,
                                   o_error     out number);
  --Fin 30.0
END PQ_IW_SGA_BSCS;
/
