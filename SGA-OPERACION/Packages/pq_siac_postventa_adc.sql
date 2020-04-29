CREATE OR REPLACE PACKAGE OPERACION.PQ_SIAC_POSTVENTA_ADC IS
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
  12.0      2015-03-23   Luz Facundo                                         p_validad_transaccion al generar una Post Venta desde Deco Adicional
                                                                  anteriormente con Cambio de plan.
  13.0      2015-05-13   Freddy Gonzales      Hector Huaman       SD-298641
  14.0      2015-11-13   Fernando Loza        Richard Medina      SD-522935 generar raise_application_error en caso de error  
  15.0      2015-11-26   Leonardo Silvera     Paul Moya           PROY-17652 IDEA-22491 - ETAdirect
  
  /************************************************************************************************/
  g_idprocess  operacion.siac_postventa_proceso.idprocess%TYPE;
  g_tipotrans  VARCHAR2(30);
  g_codsuc     vtasuccli.codsuc%TYPE;
  g_codcli     sales.cliente_sisact.codcli%TYPE;
  g_numslc_old sales.sot_sisact.numslc%TYPE;
  g_codcnt     marketing.vtatabcntcli.codcnt%TYPE;
  TYPE gc_salida IS REF CURSOR;

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

  PROCEDURE execute_main(p_postventa OPERACION.PQ_SIAC_POSTVENTA.postventa_in_type,
                         p_id        sales.sisact_postventa_det_serv_hfc.idinteraccion%TYPE, --2.0
                         --p_servicios     operacion.pq_siac_cambio_plan.servicios_type, --2.0
                         p_postventa_out OUT OPERACION.PQ_SIAC_POSTVENTA.postventa_out_type,
                         p_error_code    OUT NUMBER,
                         p_error_msg     OUT VARCHAR2);

  FUNCTION get_postventa_out(p_tipotrans VARCHAR2) RETURN OPERACION.PQ_SIAC_POSTVENTA.postventa_out_type;

  procedure load_information_te(p_postventa OPERACION.PQ_SIAC_POSTVENTA.postventa_in_type);

  FUNCTION load_information_cp(p_postventa OPERACION.PQ_SIAC_POSTVENTA.postventa_in_type)
    RETURN operacion.pq_siac_cambio_plan.precon_type;

  FUNCTION set_negocio_proceso(p_postventa OPERACION.PQ_SIAC_POSTVENTA.postventa_in_type)
    RETURN sales.int_negocio_proceso.idprocess%TYPE;

  PROCEDURE regla_negocio(p_tipo_regla VARCHAR2);

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

  PROCEDURE set_hist_srv_cp;

  PROCEDURE has_active_services;
  PROCEDURE p_lista_operador(ac_prob_cur OUT gc_salida);
  PROCEDURE p_validad_transaccion(v_customer_id IN sales.cliente_sisact.customer_id%TYPE,
                                  v_tipotrans   IN VARCHAR2,
                                  v_error_code  OUT NUMBER,
                                  v_error_msg   OUT VARCHAR2);

  procedure set_siac_instancia(p_idprocess      siac_instancia.idprocess%type,
                               p_tipo_postventa siac_instancia.tipo_postventa%type,
                               p_tipo_instancia siac_instancia.tipo_instancia%type,
                               p_instancia      siac_instancia.instancia%type);

  procedure insert_siac_instancia(p_siac_instancia siac_instancia%rowtype);

  procedure set_int_negocio_instancia(p_idprocess   sales.int_negocio_instancia.idprocess%type,
                                      p_instancia   sales.int_negocio_instancia.instancia%type,
                                      p_idinstancia sales.int_negocio_instancia.idinstancia%type);

  procedure insert_int_negocio_instancia(p_int_negocio_instancia sales.int_negocio_instancia%rowtype);

END;
/