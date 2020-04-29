CREATE OR REPLACE PACKAGE OPERACION.PQ_SIAC_POSTVENTA IS
  /************************************************************************************************
  NOMBRE:     OPERACION.PQ_POSTVENTA_UNIFICADA
  PROPOSITO:  Generacion de Post Venta Automatica HFC

  REVISIONES:
   Version  Fecha        Autor                Solicitado por      Descripcion
   -------- ----------   ------------------   -----------------   ------------------------
   1.0      2013-09-11   Alex Alamo           Hector Huaman       Generar Cambio de Plan y Traslado Externo
                         Eustaquio Gibaja
                         Mauro Zegarra
   2.0      2014-02-25   Carlos Chamache      Hector Huaman       Creacion de Servicios POST-VENTA
   3.0      2014-05-14   Hector Huaman        Hector Huaman       Creacion de Servicios POST-VENTA (Adecuaciones)
   4.0      2014-05-21   Hector Huaman        Hector Huaman       Cargo del servicio
   5.0      2014-07-21   Alex Alamo           Hector Huaman       modificar Proceso Cambio de Plan
   6.0      2014-08-19   Hector Huaman        Hector Huaman       SD-1173230
   7.0      2014-11-25   Eustaquio Gibaja     Hector Huaman       Mejoras en el flujo de traslado ext. (reemplazar variables globales)
   8.0      2014-11-28   Eustaquio Gibaja     Hector Huaman       Mejoras en la generacion de contacto de cliente.
   9.0      2014-12-11   Edwin Vasquez        Hector Huaman       Deco Adicional
  10.0      2015-01-22   Freddy Gonzales      Hector Huaman       Registrar datos en la tabla sales.int_negocio_instancia
                                                                  al generar una Post Venta desde Deco Adicional.
  11.0      2015-03-04   Freddy Gonzales      Guillermo Salcedo   SDM 230032: Generar SOT de Translado Externo cuando el cliente viene
  12.0      2015-03-23   Luz Facundo                               p_validad_transaccion al generar una Post Venta desde Deco Adicional
                                                                  anteriormente con Cambio de plan.
  13.0      2015-05-13   Freddy Gonzales      Hector Huaman       SD-298641
  14.0      2015-11-13   Fernando Loza        Richard Medina      SD-522935 generar raise_application_error en caso de error
  15.0      2015-11-26   Leonardo Silvera     Paul Moya           PROY-17652 IDEA-22491 - ETAdirect
  16.0      2016-02-03   Carlos Terán        Karen Velezmoro    SD-596715 Se activa la facturación en SGA (Alineación )
  17.0      2016-02-23   Juan Olivares        Paul Moya           PROY-17652 IDEA-22491 - ETAdirect
  18.0      2016-04-01                                            SD-642508 Cambio de Plan
  19.0      2016-04-20   Diego Ramos          Paul Moya           PROY-17652 IDEA-22491 - ETAdirect.
  20.0      28/11/2016   Luis Flores                              PROY-20828.SGA Mejora Provision HFC
  21.0	  2017-07-10   Felipe Maguiña	    Tito Huertas		PROY-27792
  /************************************************************************************************/
  g_idprocess  operacion.siac_postventa_proceso.idprocess%TYPE;
  g_tipotrans  VARCHAR2(30);
  g_codsuc     vtasuccli.codsuc%TYPE;
  g_codcli     sales.cliente_sisact.codcli%TYPE;
  g_numslc_old sales.sot_sisact.numslc%TYPE;
  g_codcnt     marketing.vtatabcntcli.codcnt%TYPE;
  TYPE gc_salida IS REF CURSOR;

  TYPE postventa_in_type IS RECORD(
    cod_id             sales.sot_sisact.cod_id%TYPE,
    customer_id        sales.cliente_sisact.customer_id%TYPE,
    tipotrans          VARCHAR2(30),
    codintercaso       VARCHAR2(30),
    tipovia            inmueble.tipviap%TYPE,
    nombrevia          inmueble.nomvia%TYPE,
    numerovia          inmueble.numvia%TYPE,
    tipourbanizacion   vtasuccli.idtipurb%TYPE,
    nombreurbanizacion vtasuccli.nomurb%TYPE,
    manzana            inmueble.manzana%TYPE,
    lote               inmueble.lote%TYPE,
    codubigeo          vtatabdst.ubigeo%TYPE,
    codzona            vtasuccli.codzona%TYPE,
    idplano            vtasuccli.idplano%TYPE,
    codedif            VARCHAR2(500), -- 5.0
    referencia         inmueble.referencia%TYPE,
    --observacion        VARCHAR2(50),--3.0
    observacion    SOLOT.OBSERVACION%TYPE, -- 5.0
    fec_prog       DATE,
    franja_horaria VARCHAR2(50),
    numcarta       vtatabprecon.carta%TYPE,
    operador       vtatabprecon.carrier%TYPE,
    presuscrito    vtatabprecon.presusc%TYPE,
    publicar       vtatabprecon.publicar%TYPE,
    codmotot       motot.codmotot%TYPE,
    lista_tipequ   VARCHAR2(200),
    ad_tmcode      VARCHAR2(200),
    lista_coser    VARCHAR2(200),
    lista_sncode   VARCHAR2(200),
    lista_spcode   VARCHAR2(200),
    cargo          agendamiento.cargo%TYPE); --4.0

  TYPE postventa_out_type IS RECORD(
    codsuc   vtasuccli.codsuc%TYPE,
    numslc   vtatabslcfac.numslc%TYPE,
    codsolot solot.codsolot%TYPE);

  TYPE instan_in_type IS RECORD(
    tipotrans   operacion.siac_postventa_proceso.tipo_trans%TYPE,
    cod_id      operacion.siac_postventa_proceso.cod_id%TYPE,
    numslc      sales.vtatabslcfac.numslc%TYPE,
    numregistro regvtamentab.numregistro%TYPE);

  procedure p_genera_transaccion(p_id                 sales.sisact_postventa_det_serv_hfc.idinteraccion%type,
                                 v_cod_id             sales.sot_sisact.cod_id%type,
                                 v_customer_id        sales.cliente_sisact.customer_id%type,
                                 v_tipotrans          varchar2,
                                 v_codintercaso       varchar2,
                                 v_tipovia            inmueble.tipviap%type,
                                 v_nombrevia          inmueble.nomvia%type,
                                 v_numerovia          inmueble.numvia%type,
                                 v_tipourbanizacion   vtasuccli.idtipurb%type,
                                 v_nombreurbanizacion vtasuccli.nomurb%type,
                                 v_manzana            inmueble.manzana%type,
                                 v_lote               inmueble.lote%type,
                                 v_codubigeo          vtatabdst.ubigeo%type,
                                 v_codzona            vtasuccli.codzona%type,
                                 v_idplano            vtasuccli.idplano%type,
                                 v_codedif            varchar2,
                                 v_referencia         inmueble.referencia%type,
                                 v_observacion        SOLOT.Observacion%type,
                                 v_fec_prog           date,
                                 v_franja_horaria     varchar2,
                                 v_numcarta           vtatabprecon.carta%type,
                                 v_operador           vtatabprecon.carrier%type,
                                 v_presuscrito        vtatabprecon.presusc%type,
                                 v_publicar           vtatabprecon.publicar%type,
                                 v_ad_tmcode          varchar2,
                                 v_lista_coser        varchar2,
                                 v_lista_spcode       varchar2,
                                 v_usuarioreg         solot.codusu%type,
                                 v_cargo              agendamiento.cargo%type,
                                 v_codsolot           out solot.codsolot%type,
                                 p_error_code         out number,
                                 p_error_msg          out varchar2);

  PROCEDURE execute_main(p_postventa postventa_in_type,
                         p_id        sales.sisact_postventa_det_serv_hfc.idinteraccion%TYPE, --2.0
                         --p_servicios     operacion.pq_siac_cambio_plan.servicios_type, --2.0
                         p_postventa_out OUT postventa_out_type,
                         p_error_code    OUT NUMBER,
                         p_error_msg     OUT VARCHAR2);

  FUNCTION get_postventa_out(p_tipotrans VARCHAR2) RETURN postventa_out_type;

  procedure load_information_te(p_postventa postventa_in_type);

  FUNCTION load_information_cp(p_postventa postventa_in_type)
    RETURN operacion.pq_siac_cambio_plan.precon_type;

  FUNCTION set_negocio_proceso(p_postventa postventa_in_type)
    RETURN sales.int_negocio_proceso.idprocess%TYPE;

  PROCEDURE regla_negocio(p_tipo_regla VARCHAR2);

  FUNCTION get_msg_error(p_valor      VARCHAR2,
                         p_key_detail operacion.config_det.key_detail%TYPE,
                         p_value      operacion.config_det.value%TYPE)
    RETURN VARCHAR2;

  FUNCTION get_codcli(p_customer_id sales.cliente_sisact.customer_id%TYPE)
    RETURN sales.cliente_sisact.codcli%TYPE;

  function get_numslc(p_cod_id sales.sot_sisact.cod_id%type,
                      p_codcli sales.vtatabslcfac.codcli%type)
    return sales.sot_sisact.numslc%type;

  PROCEDURE verificar_cliente_proyecto(p_numslc vtatabslcfac.numslc%TYPE,
                                       p_codcli vtatabcli.codcli%TYPE);

  FUNCTION get_contacto(p_codcli sales.cliente_sisact.codcli%TYPE)
    RETURN marketing.vtatabcntcli.codcnt%TYPE;

  FUNCTION get_tipdide(p_codcli sales.cliente_sisact.codcli%TYPE)
    RETURN marketing.vtatabcli.tipdide%TYPE;

  FUNCTION get_ntdide(p_codcli sales.cliente_sisact.codcli%TYPE)
    RETURN marketing.vtatabcli.ntdide%TYPE;

  FUNCTION insert_vtatabcntcli(p_codcli sales.cliente_sisact.codcli%TYPE)
    RETURN marketing.vtatabcntcli.codcnt%TYPE;

  FUNCTION get_dsccnt(p_tipcnt vtatabcntcli.tipcnt%TYPE)
    RETURN marketing.vtatipcnt.dsccnt%TYPE;

  PROCEDURE review_negocio_proceso;

  FUNCTION format_msg(p_msg_err operacion.siac_negocio_err.ora_text%TYPE)
    RETURN operacion.siac_negocio_err.ora_text%TYPE;

  PROCEDURE set_log_err(p_msg_err operacion.siac_negocio_err.ora_text%TYPE);

  FUNCTION get_inf_instancia RETURN instan_in_type;

  PROCEDURE set_hist_srv_cp;

  PROCEDURE has_active_services;
  PROCEDURE p_lista_operador(ac_prob_cur OUT gc_salida);
  
  procedure p_validad_transaccion(v_customer_id    in operacion.solot.customer_id%type,
                                  an_codigo_error  out number,
                                  av_mensaje       out varchar2);

  procedure set_siac_instancia(p_idprocess      siac_instancia.idprocess%type,
                               p_tipo_postventa siac_instancia.tipo_postventa%type,
                               p_tipo_instancia siac_instancia.tipo_instancia%type,
                               p_instancia      siac_instancia.instancia%type);

  procedure insert_siac_instancia(p_siac_instancia siac_instancia%rowtype);

  procedure set_int_negocio_instancia(p_idprocess   sales.int_negocio_instancia.idprocess%type,
                                      p_instancia   sales.int_negocio_instancia.instancia%type,
                                      p_idinstancia sales.int_negocio_instancia.idinstancia%type);

  procedure insert_int_negocio_instancia(p_int_negocio_instancia sales.int_negocio_instancia%rowtype);

  procedure p_valida_trans_co_id(p_cod_id sales.sot_sisact.cod_id%type);

  procedure p_obt_area_x_cod_id(an_cod_id   in sales.sot_sisact.cod_id%type,
                                an_areasol  out solot.areasol%type);

  function f_max_sot_siac_sisact(an_cod_id   sales.sot_sisact.cod_id%type) return number;
  
  function g_get_is_hfc_siac(av_numslc varchar2, av_param varchar2)
    return number;
  
  procedure p_actualizar_trrsolot_siac(a_idtareawf in number,
                                       a_idwf      in number,
                                       a_tarea     in number,
                                       a_tareadef  in number);
                                       
  procedure p_ejecuta_transaccion_te_siac(a_idtareawf in number,
                                          a_idwf      in number,
                                          a_tarea     in number,
                                          a_tareadef  in number);  
                                           
  procedure p_asignacion_numero_siac(a_idtareawf in number,
                                    a_idwf      in number,
                                    a_tarea     in number,
                                    a_tareadef  in number);   
   procedure SHFCSI_DIR_EXT(PCODSOLOT              IN NUMBER,
                           PCUSTOMER_ID           IN INTEGER,
                           PDIRECCION_FACTURACION IN VARCHAR2,
                           PNOTAS_DIRECCION       IN VARCHAR2,
                           PDISTRITO              IN VARCHAR2,
                           PPROVINCIA             IN VARCHAR2,
                           PCODIGO_POSTAL         IN VARCHAR2,
                           PDEPARTAMENTO          IN VARCHAR2,
                           PPAIS                  IN VARCHAR2,
                           PFLAG_DIRECC_FACT      IN NUMBER,
                           PUSUARIO_REG           IN VARCHAR2,
                           PFECHA_REG             IN DATE,
                           PRESULTADO             OUT INTEGER,
                           PMSGERR                OUT VARCHAR2);
                           
  procedure SHFCSU_OCC_EXT(PCODSOLOT                IN  NUMBER,
                              PCUSTOMER_ID          IN  INTEGER,
                              PFECVIG                IN  DATE,
                              PMONTO                IN  FLOAT,
                              POBSERVACION          IN  VARCHAR2,
                              PFLAG_COBRO_OCC        IN  INTEGER,
                              PAPLICACION            IN  VARCHAR2,
                              PUSUARIO_ACT          IN  VARCHAR2,
                              PFECHA_ACT            IN  DATE,
                              PCOD_ID               sales.sot_sisact.cod_id%type,
                              PRESULTADO            OUT INTEGER,
                              PMSGERR               OUT VARCHAR2);

  --ini  21.0
  PROCEDURE SGASS_TIP_TRAB_CONFIP(a_cursor OUT gc_salida);

  PROCEDURE SGASS_TIPO_CONFIP(an_tiptrabajo IN NUMBER,
                               a_cursor OUT gc_salida);

  PROCEDURE SGASS_SUCURSALES_CLIENTE(an_customer_id IN NUMBER,
                                    a_cursor OUT gc_salida);

  --fin  21.0
  
  procedure p_valida_cp_idinteraccion(av_idinteraccion in operacion.siac_postventa_proceso.cod_intercaso%type,
                                     an_cod_id        in solot.cod_id%type,
                                     an_codsolot      out solot.codsolot%type,
                                     an_error         out number,
                                     av_mensaje       out varchar2);
END;
/