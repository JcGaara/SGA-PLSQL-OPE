CREATE OR REPLACE PACKAGE OPERACION.PQ_SGA_BSCS IS

  /*******************************************************************************************************
   NOMBRE:       OPERACION.PQ_SGA_JANUS
   PROPOSITO:    Paquete de objetos necesarios para la Conexion del SGA - JANUS
   REVISIONES:
   Version    Fecha       Autor            Solicitado por    Descripcion
  ---------  ----------  ---------------  --------------    -----------------------------------------
    1.0       04/11/2015                   00
    2.0       01/04/2016                                    SD-642508 Cambio de Plan
    3.0       28/04/2016                                    SD-642508-1 Cambio de Plan II
    4.0       01/07/2016                                    SGA_SD-767463 Se asignan bolsas en Janus de clientes anteriores
    5.0       07/12/2016  Servicio Fallas-HITSS        SD_1040408
    6.0       19/01/2017  Servicio Fallas-HITSS             Migración WIMAX a LTE
    7.0       07/04/2017  Juan Olivares                      PROY-28711 Mejorar la atención del proceso de mtto de los servicios HFC
    8.0       18/04/2017  Servicio Fallas-HITSS             INC000000677720
    12.0      04/07/2017  Juan Gonzales   Alfredo Yi        PROY-27792 - Cobro OCC punto Adicional             INC000000677720
    13.0      08/08/2017  Servicio Fallas-HITSS             INC000000856062
    18.0      23/05/2019  Servicio Fallas-HITSS             INC000002064809
  *******************************************************************************************************/
  type l_sald is REF CURSOR;

  C_MARKET_LTE         CONSTANT PLS_INTEGER := 1;
  C_PLCODE_LTE         CONSTANT PLS_INTEGER := 79;
  C_INVALID_REASON     CONSTANT NUMBER(2) := -1; -- Motivo de acción incorrecto
  C_INVALID_USER       CONSTANT NUMBER(2) := -3; -- Usuario inválido
  C_INVALID_CONTRACT   CONSTANT NUMBER(2) := -5; -- Id de contrato inválido
  C_INVALID_STATUS     CONSTANT NUMBER(2) := -2; -- El estado actual o propuesto del contrato no permite ejecutar la acción
  C_PENDING_REQUEST    CONSTANT NUMBER(2) := -4; -- Tiene request pendiente
  C_EXCEPTION_OTHERS   CONSTANT NUMBER(2) := -6; -- Ocurrió otra excepción
  V_TIPO_PROD_INT_TELF CONSTANT VARCHAR2(20) := 'TEL+INT';
  V_TIPO_PROD_INT      CONSTANT VARCHAR2(20) := 'INTERNET';
  V_TIPO_PROD_TELF     CONSTANT VARCHAR2(20) := 'TELEFONIA';
  V_TIPO_PROD_TV       CONSTANT VARCHAR2(20) := 'TV';
  C_SNCODE_TLF         CONSTANT NUMBER := 600;
  
  TYPE typ_reg_transaccion_sga IS TABLE OF operacion.reg_transaccion_sga%ROWTYPE INDEX BY PLS_INTEGER;   --18.0

  TYPE typ_LOG_ERROR_TRANSACCION_SGA IS TABLE OF historico.LOG_ERROR_TRANSACCION_SGA%ROWTYPE INDEX BY PLS_INTEGER;   --18.0

  procedure p_desactiva_contrato_cplan(an_codsolot number,
                                       n_cod_id number,
                                       an_error out number,
                                       av_error out varchar2);

  procedure p_job_ws_baja_bscs;

  procedure p_job_sus_sol_bscs;

  procedure p_job_rec_sol_bscs;
        
  procedure p_reg_log_sga(atyp_reg_transaccion_sga       typ_reg_transaccion_sga,
                          atyp_LOG_ERROR_TRANSACCION_SGA typ_LOG_ERROR_TRANSACCION_SGA); -- 18.0
        
  FUNCTION get_email_envio_sol_bscs RETURN opedd.descripcion%TYPE;                       -- 18.0
      
  procedure p_reg_log(ac_codcli      operacion.solot.codcli%type,
            an_customer_id number,
            an_idtrs       number,
            an_codsolot    number,
            an_idinterface number,
            an_error       number,
            av_texto       varchar2,
            an_cod_id      number default 0,
            av_proceso     varchar default '');

  procedure p_consulta_motivoxtiptra(an_tiptra in number, srv_cur out sys_refcursor);

  PROCEDURE P_BAJA_DECO_STB (L_CLIENTE IN VARCHAR2,--CUSTOMER_ID
                             L_IDPRODUCTO IN NUMBER,
                             L_IDVENTA IN NUMBER, --SIEMPRE ES 0
                             L_SOT IN NUMBER,
                             L_SID IN NUMBER, --codinssrv / co_id
                             L_ENVIO IN NUMBER ,
                             L_ERROR OUT NUMBER,
                             L_MENSAJE OUT VARCHAR2
                          ) ;

  Procedure p_baja_deco_bscs(n_cod_id    operacion.solot.cod_id%type,
                             n_codsolot  operacion.solot.codsolot%type,
                             n_idproducto number, --8.0
                             L_ERROR     OUT NUMBER,
                             L_MENSAJE   OUT VARCHAR2);
  -- Ini 2.0
  PROCEDURE P_REGULARIZA_SOT_BAJA(an_sot_baja operacion.solot.codsolot%TYPE,
                                  an_error  out integer,
                                  av_error  out varchar2);

  PROCEDURE P_DEPURA_SOT_BAJA(an_sot_baja operacion.solot.codsolot%TYPE,
                              an_error  out integer,
                              av_error  out varchar2);

  FUNCTION F_OBTENER_SOT_ALTA(av_codcli operacion.solot.codcli%TYPE, an_sot_baja operacion.solot.codsolot%TYPE) RETURN NUMBER;

  function f_val_exis_sot_serv_adic(an_codinssrv in number,
                                    an_tiptra in number) return number;
                                      
  procedure p_genera_sot_cont_sga(an_tiptra in solot.tiptra%type,
                                  an_codsolot in solot.codsolot%type,
                                  an_tipo in number,
                                  an_codinssrv in inssrv.codinssrv%type,
                                  an_coderror out number,
                                  av_msgerror out varchar2,
                                  an_out_codsolot out solot.codsolot%type);


  procedure p_insert_sot_cont_sga(v_codcli   in solot.codcli%type,
                                  v_tiptra   in solot.tiptra%type,
                                  v_tipsrv   in solot.tipsrv%type,
                                  v_motivo   in solot.codmotot%type,
                                  v_areasol  in solot.areasol%type,
                                  an_customer_id     in solot.customer_id%type,
                                  an_cod_id          in solot.cod_id%type,
                                  av_observacion in solot.observacion%type,
                                  a_codsolot out number);

  procedure p_insert_solotpto_cont_sga(an_codsolot      in solot.codsolot%type,
                                       an_codsolot_b    in solot.codsolot%type,
                                       av_codcli        in solot.codcli%type,
                                       an_codinssrv     in inssrv.codinssrv%type,
                                       av_ncos_new      in solotpto.ncos_new%type,
                                       an_resultado     out number,
                                       ac_mensaje       out varchar2,
                                       an_puntos        out number);

  procedure p_alinea_reconexion_bscs;

  -- Fin 2.0

  procedure p_libera_request_co_id(an_cod_id in number,
                                   an_coderror out number,
                                   av_msgerror out varchar2);

  function f_val_existe_contract_sercad(an_cod_id number) return number;

  procedure p_reg_contr_services_cap(an_cod_id number,
                                     av_numero varchar2,
                                     an_error  out integer,
                                     av_error  out varchar2);

  function f_get_is_cp_hfc(an_codsolot number) return number;

  procedure p_act_prov_bscs_reserv_hfc(an_co_id    number,
                                       an_coderror out number,
                                       av_error    out varchar2);
  -- INI 6.0
  procedure p_reg_nro_lte_bscs(av_numero in varchar2,
                               an_error  out number,
                               av_error  out varchar2);

  function f_get_obtiene_param_lte(av_cadena varchar2) return number;
  -- FIN 6.0

  function f_is_marketlte(p_co_id in number) return boolean;

  procedure sp_get_contract_dnnum(p_co_id  in integer,
                                  p_dn_num out varchar2);

  procedure p_anular_venta_lte(p_co_id     in integer,
                               p_resultado out integer,
                               p_msgerr    out varchar2);

  procedure p_anula_contrato_bscs_lte(p_co_id     in integer,
                                      p_ch_reason in integer,
                                      p_resultado out integer,
                                      p_msgerr    out varchar2);
  -- Ini 7.0
  function get_codsrv_bscs(p_sncode varchar2) return varchar2;

  procedure lista_srv_bscs(p_cod_id number, p_serv_bscs out sys_refcursor);

  procedure lista_equ_bscs(p_cod_id number, p_equ_bscs out sys_refcursor);
  -- Fin 7.0
  --INI 12.0
  PROCEDURE SIACSI_REG_OCC(K_IDTAREAWF IN NUMBER,
                           K_IDWF      IN NUMBER,
                           K_TAREA     IN NUMBER,
                           K_TAREADEF  IN NUMBER);
  --FIN 12.0
  -- Ini 13.0
  procedure relanza_reserva(p_cod_id    number,
                            p_codsolot  number,
                            p_resultado out integer,
                            p_msgerr    out varchar2);
  -- Fin 13.0

  function f_get_tarfif_prov_tlf_hfc(an_cod_id number) return varchar2;--14.0

  function f_get_tarfif_prov_tlf_lte(an_cod_id number) return varchar2; -- LFLORES

END PQ_SGA_BSCS;
/