CREATE OR REPLACE PACKAGE OPERACION.PQ_SIAC_CAMBIO_PLAN IS

  /************************************************************************************************
  NOMBRE:     OPERACION.PQ_SIAC_CAMBIO_PLAN
  PROPOSITO:  Generacion de cambio de plan

  REVISIONES:
   Version   Fecha          Autor            Solicitado por      Descripcion
   -------- ----------  ------------------   -----------------   ------------------------
   1.0      06/01/2013   Alex Alamo           Hector Huaman       Generar Cambio de Plan
                         Eustaquio Gibaja
                         Mauro Zegarra
   2.0      2014-01-30   Carlos Chamache      Hector Huaman       Creacion de Servicios POST-VENTA
   3.0      2014-02-10   Lady Curay           Hector Huaman       Creacion de Servicios POST-VENTA 2.0
   4.0      2014-03-24   Carlos Chamache      Hector Huaman       Registrar cantidad de Equipos
   5.0      2014-04-08   Carlos Chamache      Hector Huaman       Registrar observacion en solot
   6.0      2014-07-21   Alex Alamo           Hector Huaman       modificar Proceso Cambio de Plan
   7.0      2014-08-14   Hector Huaman        Hector Huaman       Registro y consulta contrato cambio de plan
   8.0      2014-08-25   Hector Huaman        Hector Huaman       Correción al proceso de actualización de contrato
   9.0      2015-06-16   Rosa Facundo         Hector Huaman       Cambio de Plan  en SIAC HFC
  10.0      2015-07-09   Freddy Gonzales      Hector Huaman       SD-335922 SOTs con direccion errada
  11.0      2015-08-28   Fernando Loza        Hector Huaman       SD 318447 Error cambio de plan, traslado interno/externo
                                  				  Corrección de get_cntcli y agregar EXCEPTIONs
  12.0      2015-11-05   Fernando Loza        Hector Huaman       SD-522935
  13.0      2016-04-01                                            SD-642508 Cambio de Plan
  14.0      2016-04-28   Diego Ramos          Paul Moya           PROY-17652 IDEA-22491 - ETAdirect.
  15.0      2016-12-14   Servicio Fallas-HITSS                    SD1045894 - Problemas para generaciÃ³n BAJA Para EL 2do Cambio de plan
  16.0      2017-05-02   Servicio Fallas-HITSS                    INC000000693947
  19.0      2017-06-13   Felipe Maguiña       Tito Huertas        PROY 27792
  20.0      2017-06-13   Luis Flores          Luis Flores         PROY 32581
  21.0		2019-07-08   Servicio Fallas-HITSS                    INC000002010641_SGA_Falla desactivación en JANUS (Bolsa de minutos)
  /************************************************************************************************/

  g_cod_id      sales.sot_sisact.cod_id%TYPE;
  g_numslc_old  vtatabslcfac.numslc%TYPE;
  g_numregistro regvtamentab.numregistro%TYPE;
  g_numslc_new  vtatabslcfac.numslc%TYPE;
  g_codsolot    solot.codsolot%TYPE;

  g_proceso     varchar2(100):= 'PQ_SIAC_CAMBIO_PLAN';
  --<INI 2.0>
  TYPE idlinea_type IS RECORD(
    idlinea            sales.linea_paquete.idlinea%TYPE,
    servicio_sga       sales.tystabsrv.codsrv%TYPE,
    cantidad_instancia sales.vtadetptoenl.cantidad%TYPE,
    tipequ             operacion.tipequ.tipequ%TYPE,
    codtipequ          operacion.equcomxope.codtipequ%TYPE,
    cantidad           sales.vtadetptoenl.cantidad%TYPE,--<4.0>
    status             VARCHAR2(30));

  TYPE idlineas_type IS TABLE OF idlinea_type INDEX BY PLS_INTEGER;

  TYPE servicio_type IS RECORD(
    servicio           sales.servicio_sisact.idservicio_sisact%TYPE,
    idgrupo_principal  sales.grupo_sisact.idgrupo_sisact%TYPE,
    idgrupo            sales.grupo_sisact.idgrupo_sisact%TYPE,
    cantidad_instancia sales.vtadetptoenl.cantidad%TYPE,
    dscsrv             sales.tystabsrv.dscsrv%TYPE,
    bandwid            sales.tystabsrv.banwid%TYPE,
    flag_lc            sales.tystabsrv.flag_lc%TYPE,
    cantidad_idlinea   NUMBER := 1,
    tipequ             operacion.tipequ.tipequ%TYPE,
    codtipequ          operacion.equcomxope.codtipequ%TYPE,
    --<ini 4.0>
    --cantidad           NUMBER := 1,
    cantidad           sales.vtadetptoenl.cantidad%TYPE,
    --<fin 4.0>
    dscequ             sales.vtaequcom.dscequ%TYPE,
    codigo_ext         VARCHAR2(50));

  TYPE servicios_type IS TABLE OF servicio_type INDEX BY PLS_INTEGER;
  --<FIN 2.0>

  TYPE precon_type IS RECORD(
    obsaprofe vtatabprecon.obsaprofe%TYPE,
    carta     vtatabprecon.carta%TYPE,
    carrier   vtatabprecon.carrier%TYPE,
    presusc   vtatabprecon.presusc%TYPE,
    publicar  vtatabprecon.publicar%TYPE);

  TYPE service_type IS RECORD(
    idlinea  linea_paquete.idlinea%TYPE,
    cantidad NUMBER--<4.0>
    );

  TYPE services_type IS TABLE OF service_type INDEX BY PLS_INTEGER;

  TYPE detalle_servicio_type IS RECORD(
    flgprincipal detalle_paquete.flgprincipal%TYPE,
    idproducto   detalle_paquete.idproducto%TYPE,
    codsrv       linea_paquete.codsrv%TYPE,
    codequcom    linea_paquete.codequcom%TYPE,
    idprecio     define_precio.idprecio%TYPE,
    cantidad     linea_paquete.cantidad%TYPE,
    moneda_id    define_precio.moneda_id%TYPE,
    idpaq        detalle_paquete.idpaq%TYPE,
    iddet        detalle_paquete.iddet%TYPE,
    paquete      detalle_paquete.paquete%TYPE,
    banwid       tystabsrv.banwid%TYPE);

  --<INI 2.0>
  /*
  PROCEDURE execute_main(p_services VARCHAR2,
                         p_equipos  VARCHAR2,
                         p_cod_id   sales.sot_sisact.cod_id%TYPE,
                         p_precon   precon_type);
  */

  PROCEDURE execute_main(p_id sales.sisact_postventa_det_serv_hfc.idinteraccion%TYPE,
                         --p_servicios servicios_type,
                         p_cod_id sales.sot_sisact.cod_id%TYPE, --3.0
                         p_precon precon_type);
  --<FIN 2.0>

  FUNCTION get_codsolot RETURN solot.codsolot%TYPE;

  PROCEDURE create_regvtamentab(p_cod_id sales.sot_sisact.cod_id%TYPE);

  FUNCTION insert_regvtamentab(p_regmen regvtamentab%ROWTYPE)
    RETURN regvtamentab.numregistro%TYPE;

  PROCEDURE create_vtatabprecon(p_numslc vtatabslcfac.numslc%TYPE,
                                p_precon precon_type);

  FUNCTION get_codcli RETURN vtatabcli.codcli%TYPE;

  PROCEDURE update_numslc_new;

  PROCEDURE create_reginsprdbaja(p_numslc vtatabslcfac.numslc%TYPE,p_cod_id sales.sot_sisact.cod_id%TYPE); --6.0

  PROCEDURE create_sales_detail(p_services services_type);

  --Ini 6.0
   PROCEDURE actualiza_co_id(g_numslc_new vtatabslcfac.numslc%TYPE, p_cod_id inssrv.co_id%TYPE);
  --Fin 6.0

  --<INI 2.0>
  /*
  FUNCTION get_services(p_services VARCHAR2, p_equipos VARCHAR2)
      RETURN services_type;
  */
  FUNCTION get_services(p_servicios servicios_type) RETURN services_type;
  --<FIN 2.0>

  FUNCTION get_idlinea_equipo(p_record VARCHAR2)
    RETURN linea_paquete.idlinea%TYPE;

  FUNCTION get_idlinea_equipo(p_tipequ  tipequ.tipequ%TYPE,
                              p_idgrupo sales.grupo_sisact.idgrupo_sisact%TYPE)
    RETURN linea_paquete.idlinea%TYPE;

  FUNCTION create_instancia_paquete_cambi(p_idinsxpaq   regdetptoenlcambio.idinsxpaq%TYPE,
                                          p_idlinea     linea_paquete.idlinea%TYPE,
                                          p_numregistro regvtamentab.numregistro%TYPE,
                                          p_codsuc      vtasuccli.codsuc%TYPE)
    RETURN instancia_paquete_cambio.idsecuencia%TYPE;

  PROCEDURE create_regdetptoenlcambio(p_idsecuencia instancia_paquete_cambio.idsecuencia%TYPE,
                                      p_idlinea     linea_paquete.idlinea%TYPE,
                                      p_cantidad    sales.vtadetptoenl.cantidad%TYPE,--<4.0>
                                      p_punto       vtadetptoenl.numpto%TYPE,
                                      p_idinsxpaq   regdetptoenlcambio.idinsxpaq%TYPE);

  FUNCTION get_detalle_servicio(p_idlinea linea_paquete.idlinea%TYPE)
    RETURN detalle_servicio_type;

  FUNCTION get_idinsxpaq RETURN NUMBER;

  FUNCTION get_idlinea_service(p_serviceid_sisact sales.servicio_sisact.idservicio_sisact%TYPE)
    RETURN linea_paquete.idlinea%TYPE;

  FUNCTION row_count(p_string VARCHAR2) RETURN NUMBER;

  FUNCTION get_impuesto(p_idimpuesto impuesto.idimpuesto%TYPE) RETURN NUMBER;

  FUNCTION get_sucursal(p_codsuc vtasuccli.codsuc%TYPE) RETURN vtasuccli%ROWTYPE;

  function get_inssrv(p_cod_id sales.sot_sisact.cod_id%type)
    return inssrv%rowtype;

  function existe_traslado(p_cod_id sales.sot_sisact.cod_id%type)
    return boolean;

  function get_datos_traslado(p_cod_id sales.sot_sisact.cod_id%type)
    return inssrv%rowtype;

  FUNCTION get_cntcli(p_cod_id sales.sot_sisact.cod_id%TYPE)
    RETURN vtatabcntcli%ROWTYPE;

  FUNCTION get_slcfac(p_cod_id sales.sot_sisact.cod_id%TYPE)
    RETURN vtatabslcfac%ROWTYPE;

  FUNCTION proyecto_preventa(p_numslc vtatabslcfac.numslc%TYPE) RETURN NUMBER;

  PROCEDURE asignar_plataforma(p_numslc  vtatabslcfac.numslc%TYPE,
                               p_retorna OUT NUMBER,
                               p_texto   OUT VARCHAR2);

  FUNCTION validar_checkproy(p_numslc vtatabslcfac.numslc%TYPE) RETURN VARCHAR2;

  FUNCTION validar_producto_sla(p_numslc vtatabslcfac.numslc%TYPE) RETURN NUMBER;

  PROCEDURE validar_tiposolucion(p_parametro VARCHAR2);

  PROCEDURE load_instancia_cambio(p_numslc vtatabslcfac.numslc%TYPE);

  PROCEDURE generar_ptoenl_cambio(p_numregistro regvtamentab.numregistro%TYPE,
                                  p_numslc      vtatabslcfac.numslc%TYPE,
                                  p_precon_type precon_type);--<5.0>

  PROCEDURE generar_des_cambio(p_numregistro regvtamentab.numregistro%TYPE,
                               p_numslc      vtatabslcfac.numslc%TYPE,
                                  p_precon_type precon_type);--<5.0>

  PROCEDURE grabar_reservas(p_numregistro regvtamentab.numregistro%TYPE,
                            p_numslc      vtatabslcfac.numslc%TYPE);

  PROCEDURE actualizar_grupo_cambio(p_numslc vtatabslcfac.numslc%TYPE);

  PROCEDURE load_detalle_cambio(p_numregistro regvtamentab.numregistro%TYPE,
                                p_numslc      vtatabslcfac.numslc%TYPE);

  PROCEDURE actualizar_pto_pri_cambio(p_numregistro regvtamentab.numregistro%TYPE);

  PROCEDURE generar_sef(p_numregistro regvtamentab.numregistro%TYPE);

  PROCEDURE set_instance(p_tipo_instancia operacion.siac_instancia.tipo_instancia%TYPE,
                         p_instancia      operacion.siac_instancia.instancia%TYPE);

  --<INI 2.0>
  FUNCTION list_servicios(p_services_type services_type) RETURN VARCHAR2;

  FUNCTION list_equipos(p_services_type services_type) RETURN VARCHAR2;

  PROCEDURE update_negocio_proceso(p_services_type services_type);

  FUNCTION get_linea(p_servicio servicio_type)
    RETURN sales.linea_paquete.idlinea%TYPE;

  FUNCTION fill_new_services(p_services      services_type,
                             p_new_servicios servicios_type) RETURN services_type;

  FUNCTION is_servicio_principal(p_idgrupo sales.grupo_sisact.idgrupo_sisact%TYPE)
    RETURN BOOLEAN;

  FUNCTION is_servicio_adicional(p_idgrupo sales.grupo_sisact.idgrupo_sisact%TYPE)
    RETURN BOOLEAN;

  FUNCTION get_codsrv_comodato(p_idgrupo sales.grupo_sisact.idgrupo_sisact%TYPE)
    RETURN sales.tystabsrv.codsrv%TYPE;

  FUNCTION is_servicio_comodato(p_idgrupo           sales.grupo_sisact.idgrupo_sisact%TYPE,
                                p_idgrupo_principal sales.grupo_sisact.idgrupo_sisact%TYPE)
    RETURN BOOLEAN;

  FUNCTION is_servicio_alquiler(p_idgrupo           sales.grupo_sisact.idgrupo_sisact%TYPE,
                                p_idgrupo_principal sales.grupo_sisact.idgrupo_sisact%TYPE)
    RETURN BOOLEAN;

  PROCEDURE insert_servicios(p_servicios servicios_type,
                             p_idlinea   OUT idlineas_type);
  --<FIN 2.0>
  PROCEDURE p_act_customer_sga(p_cod_sot     solot.codsolot%TYPE,
                               p_customer_id solot.customer_id%TYPE,
                               p_cod_id      solot.cod_id%TYPE,
                               p_error_code  OUT NUMBER,
                               p_mensaje     OUT VARCHAR2);
  --<7.0
  PROCEDURE p_consulta (p_cod_sot   in  solot.codsolot%TYPE,
                               p_customer_id OUT  solot.customer_id%TYPE,
                               p_cod_id      OUT   solot.cod_id%TYPE,
                               p_error_code  OUT NUMBER,
                               p_mensaje     OUT VARCHAR2);

   PROCEDURE p_insert_co_id(p_cod_sot   in  solot.codsolot%TYPE,
                               p_customer_id IN  solot.customer_id%TYPE,
                               p_cod_id      IN   solot.cod_id%TYPE,
                               P_ERROR   IN NUMBER,
                               P_MSG_ERROR IN VARCHAR2,
                               p_error_code  OUT NUMBER,
                               p_mensaje     OUT VARCHAR2);
   FUNCTION exist_sot_siac(p_codsolot solot.codsolot%TYPE) RETURN BOOLEAN;
  --7.0>

  procedure p_insert_log_post_siac(an_cod_id      operacion.postventasiac_log.co_id%type,
                                   an_customer_id operacion.postventasiac_log.customer_id%type,
                                   av_proceso     operacion.postventasiac_log.proceso%type,
                                   av_msgerror    operacion.postventasiac_log.msgerror%type);

  --INI 19.0
  /****************************************************************
  '* Nombre SP : SGASP_REGLA_HFC
  '* Proposito : Regla validar el tipo de decodificador
  '* Input  : p_customer_id - Customer_id del cliente
              p_lista       - Cursor con la lista de equipos del plan nuevo
  '* Output : p_resp        - Valor devuelto por el SP
                            - 1 - Con visita
                            - 0 - Sin visita
                            - -1 - Error en BD
              p_mens        - Error de BD
  '* Creado por : Jorge Rivas
  '* Fec Creacion : 12/06/2017
  '* Fec Actualizacion :
  '****************************************************************/

  FUNCTION SGAFUN_VALIDA_CB_PLAN(K_CODSOLOT OPERACION.SOLOT.CODSOLOT%TYPE)
    RETURN NUMBER;

  FUNCTION SGAFUN_VALIDA_CB_PLAN_VISITA(K_CODSOLOT OPERACION.SOLOT.CODSOLOT%TYPE)
    RETURN NUMBER;

  PROCEDURE SGASI_GEST_RECURSOS(K_IDTAREAWF IN NUMBER,
                                K_IDWF      IN NUMBER,
                                K_TAREA     IN NUMBER,
                                K_TAREADEF  IN NUMBER);

  PROCEDURE SGASI_REGISTRO_JANUS(K_IDTAREAWF IN NUMBER,
                                 K_IDWF      IN NUMBER,
                                 K_TAREA     IN NUMBER,
                                 K_TAREADEF  IN NUMBER);

  PROCEDURE SGASI_INICIA_FACT_HFC(K_CODSOLOT IN NUMBER,
                                  K_ERROR    OUT NUMBER,
                                  K_MENSAJE  OUT VARCHAR2);

  PROCEDURE SGASS_VISITA_TECNICA(P_OPER VARCHAR2);


  PROCEDURE SGASS_CIERRE_TAREA(P_IDTAREAWF OPEWF.TAREAWF.IDTAREAWF%TYPE,
                               P_ESTADO    NUMBER,
                               P_COD_RESP  OUT NUMBER,
                               P_MSJ_RESP  OUT VARCHAR2);

  PROCEDURE SGASS_DET_EQUIPO(K_COD_ID  operacion.solot.cod_id%TYPE,
                             K_CURSOR  OUT SYS_REFCURSOR,
                             K_ERROR   OUT NUMBER,
                             K_MENSAJE OUT VARCHAR2);
--FIN 19.0
  PROCEDURE SGASI_CAMBIO_PLAN_JANUS(an_codsolot IN NUMBER,
                                    K_ERROR    OUT NUMBER,
                                    K_MENSAJE  OUT VARCHAR2);

  PROCEDURE P_REG_TRS_CP_VIS(AN_CODSOLOT IN NUMBER,
                                   AN_ERROR    OUT NUMBER,
                                   AV_ERROR    OUT VARCHAR2);

  -- PROY-31513
  FUNCTION SGAFUN_ACTUALIZA_ANOTACION(AV_ANOTACION IN VARCHAR2,
                                      AN_CODSOLOT IN NUMBER,
                                      AN_PROCESS  IN NUMBER)
                                      RETURN VARCHAR2;
  -- INI 20.0              
  procedure SGASS_VAL_EQUIPOXSERV(pi_idinteracion sales.sisact_postventa_det_serv_hfc.idinteraccion%type,
                                 po_error        out number,
                                 po_mensaje      out varchar2);
  -- FIN 20.0
  
   PROCEDURE CAMBIO_CABLE(n_codsolot IN solot.codsolot%type,
                          v_codcli  IN solot.codcli%type,
                          n_codsolot_cur IN number
                          );

   PROCEDURE SGASI_DESACTIVA_CONTRATO_CE(PI_IDTAREAWF IN NUMBER,
                                         PI_IDWF      IN NUMBER,
                                         PI_TAREA     IN NUMBER,
                                         PI_TAREADEF  IN NUMBER);
   
   PROCEDURE UPDATE_INSSERV_CAMBIO_PLAN(L_CODSOT IN NUMBER,
                            P_ERROR   OUT NUMBER,
                            P_MENSAJE OUT VARCHAR2);
  -- INI 21.0
  FUNCTION get_pid(AN_CODSOLOT  IN NUMBER,
                   AN_CODINSSRV IN NUMBER,
                   AN_PIDSGA    IN NUMBER)
                   RETURN NUMBER ; 
  -- FIN 21.0 
END;
/
