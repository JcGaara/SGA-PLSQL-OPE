CREATE OR REPLACE PACKAGE OPERACION.PQ_CONT_REGULARIZACION IS
  /*******************************************************************************************************
   NOMBRE:       OPERACION.PQ_CONT_REGULARIZACION
   PROPOSITO:    Paquete de objetos necesarios para la regularizacion de equipos - contratos  BSCS-SGA
   REVISIONES:
   Version    Fecha       Autor            Solicitado por    Descripcion
   ---------  ----------  ---------------  --------------    -----------------------------------------
    1.0       28/06/2015  Angelo Angulo                    SD-318468 - Paquete creado para regularizacion de contratos generados por contingencia.
    2.0       08/07/2015  Luis Flores Osorio               SD-412773
    3.0       09/02/2016  Carlos TerÃ¡n                       SD-596715 - Se activa la facturaciÃ³n en SGA (AlineaciÃ³n)
    4.0       01/04/2016                                     SD-642508 - Cambio de Plan
    5.0       07/12/2016  Servicio Fallas-HITSS         SD_1040408 -
    9.0      11/05/2017
   12.0       11/09/2019  Steve Panduro     FTTH             FTTH
   14.0       12/11/2019  Cesar Rengifo     HFC              HFC APlicativo APK
   15.0       03/02/2020  Edilberto Astulle
   16.0       10/03/2020  Nilton Paredes                     INICIATIVA-435
  *******************************************************************************************************/
  type t_cursor is ref cursor;

  procedure P_REG_BSCS_IW_SGA(an_cod_id number,
                              an_error  out integer,
                              av_error  out varchar2);

  PROCEDURE P_CONSULTA_IW(a_codsolot in solot.codsolot%type,
                          a_tipo     in number,
                          a_ticket   out number,
                          an_error   out integer,
                          av_error   out varchar2);

  PROCEDURE P_CONS_DET_IW(a_codsolot in solot.codsolot%type,
                          an_error   out integer,
                          av_error   out varchar2);

  procedure P_ACTIVARFACTURACION(an_cod_id number,
                                 an_error  out integer,
                                 av_error  out varchar2);
  PROCEDURE P_CARGA_SERVICIOS_HFC;

  PROCEDURE P_CARGA_EQUIPOS_HFC;

  PROCEDURE P_CARGA_MASIVA_BSCS;

  PROCEDURE SP_CARGA_MASIVA_HISTORICO;

  PROCEDURE P_HISTORIAL_CONTRATO(a_cod_id    in number,
                                 o_resultado out t_cursor);

  procedure P_REG_LOG(ac_codcli      OPERACION.SOLOT.CODCLI%type,
                      an_customer_id number,
                      an_idtrs       number,
                      an_codsolot    number,
                      an_idinterface number,
                      an_error       number,
                      av_texto       varchar2,
                      an_cod_id      number default 0,
                      av_proceso     varchar default '');

  function F_CONS_NUMERO_BSCS(t_numero number) return varchar2;

  function F_CONS_NUMERO_BSCS_CO_ID(co_id number) return varchar2;

  function f_macroestado(l_estsol in number) return varchar2;

  function f_val_pendiente_provision(an_cod_id number) return number;

  -- Valida el estado del contrato
  function f_val_contrato_activo(an_cod_id number) return number;

  function f_val_tipo_servicio_bscs(sncode number) return varchar2;

  procedure p_chg_est_tareawf(an_codsolot number,
                              an_error    out integer,
                              av_error    out varchar2);

  -- Procedimiento de baja de la linea telefonica en el janus.
  procedure p_bajanumero_janus(an_codsolot number,
                               an_error    out integer,
                               av_error    out varchar2);

  -- Procedimiento de baja del cliente en janus
  procedure p_bajacliente_janus(an_codsolot number,
                                an_error    out integer,
                                av_error    out varchar2);

  --Procedimiento de alta de numero en Janus
  procedure p_altanumero_janus(an_codsolot number,
                               an_error    out integer,
                               av_error    out varchar2);

  -- Funcion que valida si existe pendientes en la provision de baja para llanos
  function f_val_prov_janus_pend(an_cod_id number) return number;

  -- Funcion para validar si se activa o desactiva los botones de llanos en la ventana de contigencia SGA
  function f_val_accion_janus_boton(an_codsolot number, av_accion varchar2)
    return number;

  -- Ini 2.0
  function f_valida_linea_bscs_janus(an_codsolot number) return varchar2;

  -- Fin 2.0

  PROCEDURE p_anula_masivo(o_resultado OUT T_CURSOR);

  procedure p_valida_linea_bscs(av_numero  in varchar2,
                                an_out     out number,
                                av_mensaje out varchar2);

  procedure p_valida_linea_iw(av_numero  in varchar2,
                              an_out     out number,
                              av_mensaje out varchar2);

  procedure p_valida_linea_janus(av_numero  in varchar2,
                                 an_out     out number,
                                 av_mensaje out varchar2);
  procedure p_valida_linea(av_numero  in varchar2,
                           an_out     out number,
                           av_mensaje out varchar2);
  procedure p_cont_reproceso(an_cod_id number,
                             an_error  out integer,
                             av_error  out varchar2);

  function f_get_ciclo_codinssrv(l_numero    numtel.numero%type,
                               l_codinssrv insprd.codinssrv%type)
  return varchar2;
  procedure p_altanumero_janus_sgamasiva(an_error out integer,
                                        av_error out varchar2);

  -- Luis Flores Osorio 09/09/2015
  --Funcion que valida si la SOT tiene el servicio de telefonia asociado
  function f_val_serv_tlf_sot(an_codsolot number) return number;

  procedure p_insert_janus_solot_seg(an_codsolot number,
                                     an_cod_id number,
                                     an_customerid number,
                                     av_accion varchar2,
                                     av_customerjanus varchar2,
                                     av_numero varchar2,
                                     an_error out number,
                                     av_msgerror out varchar2);

  procedure p_bajanumero_janus_bscs(an_codsolot number,
                                    an_error    out integer,
                                    av_error    out varchar2);

  procedure p_bajacliente_janus_bscs(an_codsolot number,
                                     an_error    out integer,
                                     av_error    out varchar2);

  procedure p_bajatotal_janus_bscs(an_codsolot number,
                                    an_error    out integer,
                                    av_error    out varchar2);

  procedure p_altanumero_janus_bscs(an_codsolot number,
                                    an_error    out integer,
                                    av_error    out varchar2);

  procedure p_bajanumero_janus_sga(an_codsolot number,
                                   an_error    out integer,
                                   av_error    out varchar2);

  procedure p_bajacliente_janus_sga(an_codsolot number,
                                  an_error    out integer,
                                  av_error    out varchar2);

  procedure p_bajatotal_janus_sga(an_codsolot number,
                                   an_error    out integer,
                                   av_error    out varchar2);

  procedure p_altanumero_janus_sga(an_codsolot number,
                                   an_error    out integer,
                                   av_error    out varchar2);

  procedure p_bajanumero_janus_sga_ce(an_codsolot number,
                                   av_numero   varchar2,
                                   an_error    out integer,
                                   av_error    out varchar2);

  procedure p_bajacliente_janus_sga_ce(an_codsolot number,
                                  an_error    out integer,
                                  av_error    out varchar2);

  procedure p_altanumero_janus_sga_ce(an_codsolot number,
                                      av_numero   varchar2,
                                      an_error    out integer,
                                      av_error    out varchar2);

  procedure p_cons_det_iw_sga(a_codsolot in solot.codsolot%type,
                              an_error   out integer,
                              av_error   out varchar2);

  function f_val_existe_contract_sercad(an_cod_id number) return number;

  function f_retorna_customerjanusxsot(an_codsolot number) return varchar2;

  procedure p_ejecutar_baja_janus_ce(an_codsolot number, an_error out number , av_error out varchar2);

  function f_retorna_trama_alta_ce(an_codsolot number,
                                   av_numslc    varchar2,
                                   an_codinssrv number,
                                   av_numero    varchar2)
    return varchar2;

  function f_obt_cant_linea_ce(an_codsolot number) return number;

  procedure p_cont_reproceso_ce(an_cod_id number,
                             an_error  out integer,
                             av_error  out varchar2);

  procedure p_val_dato_linea_ce_janus(an_codsolot in number,
                                      av_numero in varchar2,
                                      av_customerjanus in varchar2,
                                      an_codplanjanus in number,
                                      av_ciclojanus in varchar2,
                                      an_valida out number,
                                      av_mensaje out varchar2);

  function p_retorna_plan_prin_ce(an_codsolot number) return number;

  procedure p_retorna_datos_cliente_ce(an_codsolot number,
                                       av_codcli out varchar2,
                                       av_numslc out varchar2,
                                       an_planbase out number,
                                       an_planopcion out number,
                                       av_tipdide out varchar2,
                                       av_ntdide out varchar2,
                                       av_apellidos out varchar2,
                                       av_nomcli out varchar2,
                                       av_ruc out varchar2,
                                       av_razon out varchar2,
                                       av_tlf1 out varchar2,
                                       av_tlf2 out varchar2,
                                       an_error out number,
                                       av_error out varchar2);

  procedure p_retorna_datos_sucursal_ce(av_numslc varchar2,
                                       av_dirsuc out varchar2,
                                       av_referencia out varchar2,
                                       av_nomdst out varchar2,
                                       av_nompvc out varchar2,
                                       av_nomest out varchar2,
                                       an_error out number,
                                       av_error out varchar2);

  procedure p_cambio_plan_janus_ce(an_codsolot number,
                                   an_error out number,
                                   av_error out varchar2);

  procedure p_retorna_plan_ce(an_codsolot number, an_codplan out number, an_codplanopc out number);

  procedure p_reproceso_janusxsot(an_codsolot number,
                                 an_error    out number,
                                 av_error    out varchar2);

  procedure p_regulariza_prov_bscs_pend;

  function f_val_tlflinea_abierta_ctrl(an_codsolot number) return number;

  function f_val_sot_recha_anula(an_codsolot number) return number;

  PROCEDURE SP_REQUEST_BSCS_PEND(P_PROCESO   IN NUMBER,
                               P_RANGO     IN NUMBER,
                               P_RESULTADO OUT SYS_REFCURSOR);

  FUNCTION ARMAR_TRAMA_CE(p_numero   varchar2,
                          p_codinssrv inssrv.codinssrv%type,
                          p_plan      plan_redint.plan%type,
                          p_plan_opc  plan_redint.plan_opcional%type) return varchar2;

  PROCEDURE SP_GENERA_RESERVA(an_cod_id IN  NUMBER,
                             an_error  OUT INTEGER,
                             av_error  OUT VARCHAR2);

 PROCEDURE SP_ACTIVA_SERVICIO(an_cod_id IN  NUMBER,
                              an_error  OUT INTEGER,
                              av_error  OUT VARCHAR2);

 PROCEDURE SP_REGULARIZACION(an_cod_id IN  NUMBER,
               an_error  OUT INTEGER,
               av_error  OUT VARCHAR2);

 FUNCTION F_MOSTRAR_MENSAJE(an_cod_id NUMBER,av_estado NUMBER) RETURN VARCHAR2;

 PROCEDURE SP_ACTUALIZAR_EQUIPO(an_cod_id        IN  NUMBER,
                               av_codsolot      IN  NUMBER,
                               an_customerid    IN  NUMBER,
                               an_error         OUT NUMBER,
                               av_error         OUT VARCHAR);

 PROCEDURE SP_BUSCA_CODSOLT_CUST(an_cod_id             IN   NUMBER,
                                 an_codsolot           OUT  NUMBER,
                                 an_customer_id        OUT  NUMBER,
                                 an_error              OUT  VARCHAR,
                                 av_error              OUT  VARCHAR);

 FUNCTION F_VAL_REGISTRO_BSCS(an_cod_id NUMBER, av_estado VARCHAR2) return NUMBER;

  PROCEDURE SP_LISTA_CONSOLIDADO(AV_ESTADO IN VARCHAR2,o_resultado OUT T_CURSOR);

  PROCEDURE SP_LISTA_CONTRATOS_ALINEACION(AV_ESTADO IN VARCHAR2,o_resultado OUT T_CURSOR);

  PROCEDURE SP_PROCESO_MASIVO_CONTRATOS(AN_ERROR_F OUT INTEGER,
                                       AV_ERROR_F OUT VARCHAR2);

  procedure SP_REGISTRAR_ALINEACION_JANUS(AN_ERROR  OUT INTEGER,
                                         AV_ERROR  OUT VARCHAR2);

  procedure SP_REGISTRAR_HISTORICO(AV_TIPO_OPERA IN VARCHAR2,
                                  AN_CUSTOMER_ID IN NUMBER,
                                  AN_CODSOLOT    IN NUMBER,
                                  AN_CO_ID       IN NUMBER,
                                  AN_CO_ID_OLD   IN NUMBER,
                                  AV_CODCLI      IN VARCHAR2,
                                  AV_NUMERO      IN VARCHAR2,
                                  AN_ESTSOL      IN NUMBER,
                                  AV_CICLO       IN VARCHAR2,
                                  AN_CODPLAN     IN NUMBER,
                                  AV_DN_NUM      IN VARCHAR2,
                                  AN_CODINSSRV   IN NUMBER,
                                  AV_CH_STATUS   IN VARCHAR2,
                                  AV_CH_PENDING  IN VARCHAR2,
                                  AN_ESTINSSRV   IN NUMBER,
                                  AN_FECULTEST   IN DATE,
                                  AN_FLG_UNICO   IN NUMBER,
                                  AV_DESCRIPCION IN VARCHAR2,
                                  AV_OBSERVACION IN VARCHAR2,
                                  AV_TRANSACCION IN VARCHAR2,
                                  AN_NUM01       IN NUMBER,
                                  AN_NUM02       IN NUMBER,
                                  AN_NUM03       IN NUMBER,
                                  AN_NUM04       IN NUMBER,
                                  AN_NUM05       IN NUMBER,
                                  AN_NUM06       IN NUMBER,
                                  AN_NUM07       IN NUMBER,
                                  AN_NUM08       IN NUMBER,
                                  AN_NUM09       IN NUMBER,
                                  AN_NUM10       IN NUMBER,
                                  AV_VAR01       IN VARCHAR2,
                                  AV_VAR02       IN VARCHAR2,
                                  AV_VAR03       IN VARCHAR2,
                                  AV_VAR04       IN VARCHAR2,
                                  AV_VAR05       IN VARCHAR2,
                                  AV_VAR06       IN VARCHAR2,
                                  AV_VAR07       IN VARCHAR2,
                                  AV_VAR08       IN VARCHAR2,
                                  AV_VAR09       IN VARCHAR2,
                                  AV_VAR10       IN VARCHAR2,
                                  AV_VAR11       IN VARCHAR2,
                                  AV_VAR12       IN VARCHAR2,
                                  AV_CODUSU      IN VARCHAR2,
                                  AN_FECUSU      IN DATE,
                                  AN_ERROR  OUT INTEGER,
                                  AV_ERROR  OUT VARCHAR2);

 PROCEDURE SP_DELETE_HISTORICO(   N_TIPO IN VARCHAR2,
                                 P_RESULTADO  OUT INTEGER,
                                 P_MSGERR     OUT VARCHAR2);

 PROCEDURE SP_OBTENER_NUMERO_SGA(an_codsolot IN NUMBER,
                               ln_numero OUT NUMBER,
                               lv_numero OUT VARCHAR2);

 PROCEDURE SP_VALIDACION_JANUS(an_codsolot IN NUMBER,
                               an_cod_id IN VARCHAR2,
                               an_numero IN VARCHAR2,
                               an_customer IN NUMBER,
                               an_error_j OUT INTEGER,
                               av_error_j OUT VARCHAR2);

 PROCEDURE SP_INSERT_SOTANULA(an_estado IN NUMBER,
                             av_codsolot IN VARCHAR,
                             av_observacion IN VARCHAR,
                             an_error OUT NUMBER,
                             av_error OUT VARCHAR2);

 FUNCTION F_VALIDAR_SERVICIOS(l_codoslot NUMBER, an_idinterface VARCHAR2) RETURN NUMBER;

 PROCEDURE SP_VALIDA_EQUIPO(an_cod_id        IN  NUMBER,
                            av_codsolot      IN  NUMBER,
                            an_customerid    IN  NUMBER,
                            an_error         OUT NUMBER,
                            av_error         OUT VARCHAR);

--ini 12.0
  PROCEDURE SGASI_TABEQU_IW(an_cod_id     IN NUMBER,
                            av_codsolot   IN NUMBER,
                            an_customerid IN NUMBER,
							an_conta_hfc  IN NUMBER,  --- 14.00
                            an_error      OUT NUMBER,
                            av_error      OUT VARCHAR);
-- fin 12.0

  --- INI 14.0
   PROCEDURE SP_LISTA_MATERIALES(an_estado   IN NUMBER,
                                 av_codsolot IN NUMBER,
                                 o_resultado OUT T_CURSOR);
  --- FIN 14.0 
  -- ini 15.0
procedure sp_valida_prov_app (a_idtareawf in number default null,
                              a_idwf      in number,
                              a_tarea     in number default null,
                              a_tareadef  in number default null,
                              an_error    OUT NUMBER,
                              av_error    OUT VARCHAR);
 --- FIN 15.0							 
  --Ini 16.0
  PROCEDURE SP_UPDATE_MODEL_EQUIP(A_CODSOLOT IN SOLOT.CODSOLOT%TYPE,
                                  AN_ERROR   OUT INTEGER,
                                  AV_ERROR   OUT VARCHAR2);
  --Fin 16.0

END PQ_CONT_REGULARIZACION;
/