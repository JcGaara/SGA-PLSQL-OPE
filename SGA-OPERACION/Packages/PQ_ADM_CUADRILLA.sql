CREATE OR REPLACE PACKAGE OPERACION.pq_adm_cuadrilla IS
  /****************************************************************************************************
     NOMBRE:        PQ_ADM_CUADRILLA
     DESCRIPCION:   Manejo de las customizaciones proyecto administracion manejo de cuadrillas.

     Ver        Date        Author              Solicitado por       Descripcion
     ---------  ----------  ------------------- ----------------   ------------------------------------
     1.0        08/05/2015  Jorge Rivas/        Nalda Arotinco     PQT-235788-TSK-70790 - Administracion
                            Steve Panduro/                         de Cuadrillas.
                            Justiniano Condori
     2.0        25/02/2016  Steve Panduro       Nalda Arotinco     SD-690390
     3.0        12/04/2016  Jorge Rivas         Nalda Arotinco     SD-744023
     4.0        10/05/2016  Juan Gonzales       Nalda Arotinco     SGA-SD-788452
     5.0        11/02/2016  Emma Guzman         Lizbeth Portella   PROY- 22818 -IDEA-28605 Administración y manejo de cuadrillas  - TOA Fase 2 Claro Empresas
     6.0        07/06/2016  Juan Gonzales       Nalda Arotinco     SD-820645
     7.0        15/06/2016  Juan Gonzales       Nalda Arotinco     SD-833131
     8.0        24/06/2016  Juan Gonzales       Lizbeth Portella   SD-837900 - Activacion de Equipos ETA
     9.0        13/07/2016  Felipe Maguiña      Lizbeth Portella   SD-861542
    10.0        08/08/2016  Justiniano Condori  Lizbeth Portella   PROY-22818-IDEA-28605 Administración y manejo de cuadrillas  - TOA
    11.0        01/09/2016  Justiniano Condori  Lizbeth Portella   SD-861528
    12.0        12/09/2016  Justiniano Condori  Lizbeth Portella
    13.0        07/12/2016  Juan Gonzales       Lizbeth Portella   PROY-22818.SD1025748
    14.0        16/09/2016  Luis Guzman         Lizbeth Portella   PROY-25148-IDEA-32224
    15.0        20/02/2017  HITSS               HITSS              SD_INC000000710996
    16.0        13/03/2017  HITSS               HITSS              SD_INC000000737351
    17.0        06/04/2017  Edwin Vasquez       Lizbeth Portella   PROY-25148 Mejoras en los SIACs para TOA y Reclamos
    18.0        26/06/2017  Edwin Vasquez       Lizbeth Portella   PROY-25148 INC000000845147 - Mejoras en los SIACs para TOA y Reclamos
    19.0        14/07/2017  Servicio Fallas-HITSS                  INC000000823426
    20.0        07/07/2017  Edwin Vasquez       Lizbeth Portella   PROY-22818 INC000000858490 - Mejoras en los SIACs para TOA y Reclamos
    23.0        12/09/2017  Luigi Sipion        Nalda Arotico      PROY-40032-IDEA-40030 Adap. SGA Gestor de Agendamiento/Liquidaciones para integrar con FullStack
    24.0        21/09/2018  Gino Gutiérrez      Lizbeth Portella   PROY-26249 Adaptaciones Legados TI para Proceso MWF AdmCuadrillas
    25.0        05/11/2018  Servicio Fallas-HITSS                  INC
	26.0		26/12/2019	Romario Medina		Lizbeth Portella   INC
  ****************************************************************************************************/
  lv_aplicacion VARCHAR2(20) := 'SGA';
  lv_todos      varchar2(20) := 'TODOS';

  --TYPE type_table_subtipo_orden IS TABLE OF operacion.type_subtipo_orden_adc;
  TYPE gc_salida IS REF CURSOR;
  /*Steve ini*/
  TYPE iw_sga_bscs IS RECORD(
    lv_tip_interface VARCHAR2(30),
    ln_idproducto    NUMBER,
    lv_trs_prov_bscs operacion.trs_interface_iw.trs_prov_bscs%TYPE,
    lv_estado_bscs   operacion.trs_interface_iw.estado_bscs%TYPE,
    lv_estado_iw     operacion.trs_interface_iw.estado_iw%TYPE);
  /*Steve fin*/
  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        08/05/2015  Jorge Rivas      Actualiza categoria del cliente VIP
  ******************************************************************************/
  PROCEDURE p_actualiza_indicadorvip(as_customercode IN customer_atention.customercode%TYPE,
                                     an_iderror      OUT NUMERIC,
                                     as_mensajeerror OUT VARCHAR2);
  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        08/05/2015  Jorge Rivas      Valida si el cliente es VIP
  ******************************************************************************/
  FUNCTION f_valida_cliente_vip(as_customercode IN customer_atention.customercode%TYPE)
    RETURN NUMBER;

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        22/05/2015  Jorge Rivas      Valida si la SOLOT tiene flujo adc
  2.0        dd/mm/yyyy  Programador         Valida la existencia en la matriz
  3.0        01/09/2016  Justiniano Condori  Modificacion de Flujo
  ******************************************************************************/
  PROCEDURE p_valida_flujo_adc(an_idagenda     IN agendamiento.idagenda%TYPE,
                               an_flag_aplica  OUT NUMERIC,
                               an_iderror      OUT NUMERIC,
                               as_mensajeerror OUT VARCHAR2);
  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        22/05/2015  Jorge Rivas      Actualiza las coordenas X, Y de la sucursal
  ******************************************************************************/
  PROCEDURE p_actualiza_xy_adc(av_codcli       IN marketing.vtasuccli.codcli%TYPE,
                               av_codsuc       IN marketing.vtasuccli.codsuc%TYPE,
                               av_coordx       IN marketing.vtasuccli.coordx_eta%TYPE,
                               av_coordy       IN marketing.vtasuccli.coordy_eta%TYPE,
                               an_iderror      OUT NUMERIC,
                               as_mensajeerror OUT VARCHAR2);
  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        22/05/2015  Jorge Rivas      Retorna las coordenas X, Y de la sucursal
  ******************************************************************************/
  PROCEDURE p_retorna_agendamiento_xy(an_idagenda     IN operacion.agendamiento.idagenda%TYPE,
                                      av_coordx       OUT marketing.vtasuccli.coordx_eta%TYPE,
                                      av_coordy       OUT marketing.vtasuccli.coordy_eta%TYPE,
                                      an_iderror      OUT NUMERIC,
                                      as_mensajeerror OUT VARCHAR2);
  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        22/05/2015  Jorge Rivas      Generacion de trama para cancelacion de agenda
  ******************************************************************************/
  PROCEDURE p_gen_trama_cancela_agenda(an_idagenda     IN operacion.agendamiento.idagenda%TYPE,
                                       av_trama        OUT CLOB,
                                       an_iderror      OUT NUMERIC,
                                       as_mensajeerror OUT VARCHAR2);
  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        22/05/2015  Jorge Rivas      Lista los servicios por agenda
  ******************************************************************************/
  PROCEDURE p_lista_servicios_agenda(an_idagenda IN agendamiento.idagenda%TYPE,
                                     av_trama    OUT CLOB);
  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        02/06/2015  Jorge Rivas      Ejecuta el WS de cancelacion de agenda
  ******************************************************************************/
  PROCEDURE p_cancela_agenda(an_codsolot     IN operacion.agendamiento.codsolot%TYPE,
                             an_idagenda     IN operacion.agendamiento.idagenda%TYPE,
                             an_estagenda    IN NUMBER,
                             av_observacion  IN operacion.cambio_estado_ot_adc.motivo%TYPE,
                             an_iderror      OUT NUMERIC,
                             av_mensajeerror OUT VARCHAR2);
  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        03/06/2015  Jorge Rivas      Cancelacion de agendas por SOT
  ******************************************************************************/
  PROCEDURE p_cancela_orden(an_codsot       IN operacion.agendamiento.codsolot%TYPE,
                            an_estagenda    IN NUMBER,
                            an_iderror      OUT NUMERIC,
                            av_mensajeerror OUT VARCHAR2);
  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        08/06/2015  Jorge Rivas      Asignacion de contrata
  ******************************************************************************/
  PROCEDURE p_asignacontrata_adc(an_agenda       IN operacion.agendamiento.idagenda%TYPE,
                                 av_subto        VARCHAR2,
                                 av_idbucket     VARCHAR2,
                                 av_codcon       VARCHAR2,
                                 an_iderror      OUT NUMBER,
                                 av_mensajeerror OUT VARCHAR2);
  /******************************************************************************
  Ver        Date        Author           Descripcion
  ---------  ----------  ---------------  ------------------------------------
  1.0        11/06/2015  Jorge Rivas      Devuelve la estructura XML de un metodo de la tabla
                                          operacion.ope_cab_xml
  ******************************************************************************/
  FUNCTION f_obtener_xml(ab_xml     CLOB,
                         av_metodo  VARCHAR2,
                         av_origen  VARCHAR2,
                         av_destino VARCHAR2) RETURN CLOB;
  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        09/06/2015  Jorge Rivas      Retorna zona si plano o centro poblado tiene flujo adc
  ******************************************************************************/
  PROCEDURE p_valida_flujo_zona_adc(as_origen  IN varchar2,
                                    av_idplano IN marketing.vtatabgeoref.idplano%TYPE,
                                    av_ubigeo  IN VARCHAR2,
                                    an_tiptra  IN operacion.matriz_tystipsrv_tiptra_adc.tiptra%TYPE,
                                    an_tipsrv  IN operacion.matriz_tystipsrv_tiptra_adc.tipsrv%TYPE,
                                    as_codzona OUT operacion.zona_adc.codzona%TYPE,
                                    an_indica  OUT number);
  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        14/08/2015                   Valida el flujo por motivo
  ******************************************************************************/
  PROCEDURE p_valida_flujo_mot_adc(as_origen   IN VARCHAR2,
                                   av_idplano  IN marketing.vtatabgeoref.idplano%TYPE,
                                   av_ubigeo   IN VARCHAR2,
                                   an_tiptra   IN operacion.matriz_tystipsrv_tiptra_adc.tiptra%TYPE,
                                   an_tipsrv   IN operacion.matriz_tystipsrv_tiptra_adc.tipsrv%TYPE,
                                   as_tipagen  IN operacion.matriz_tystipsrv_tiptra_adc.tipo_agenda%type,
                                   as_codmotot IN operacion.matriz_tiptratipsrvmot_adc.id_motivo%type,
                                   as_codzona  OUT operacion.zona_adc.codzona%type,
                                   an_indica   OUT NUMBER);
  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        08/05/2015  Jorge Rivas      Devuelve una tabla con los codigos de subtipo de orden
  ******************************************************************************/
  PROCEDURE p_consulta_subtipord(av_cod_tipo_orden IN operacion.tipo_orden_adc.cod_tipo_orden%TYPE,
                                 p_cursor          OUT gc_salida);
  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        21/05/2015  Jorge Rivas      Retorna la zona y plano
  ******************************************************************************/
  PROCEDURE p_retornar_zona_plano(av_idplano      IN marketing.vtatabgeoref.idplano%TYPE,
                                  av_ubigeo2      IN VARCHAR2,
                                  av_plano        OUT marketing.vtatabgeoref.idplano%TYPE,
                                  av_codzona      OUT operacion.zona_adc.codzona%TYPE,
                                  an_iderror      OUT NUMBER,
                                  av_mensajeerror OUT VARCHAR2);
  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        16/06/2015  Jorge Rivas      inserta log de errores
  ******************************************************************************/
  PROCEDURE p_insertar_log_error_ws_adc(av_tipo_trs     operacion.log_error_ws_adc.tipo_trs%TYPE,
                                        av_idagenda     operacion.log_error_ws_adc.idagenda%TYPE,
                                        av_iderror      operacion.log_error_ws_adc.iderror%TYPE,
                                        av_mensajeerror operacion.log_error_ws_adc.mensajeerror%TYPE);
  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        17/06/2015  Jorge Rivas      obtiene tag desde la trama ingresada
  ******************************************************************************/
  FUNCTION f_obtener_tag(av_tag VARCHAR2, av_trama CLOB) RETURN VARCHAR2;
  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        17/06/2015  Jorge Rivas      Genera OT ADC
  ******************************************************************************/
  PROCEDURE p_genera_ot_adc(an_codsolot     IN operacion.agendamiento.codsolot%TYPE,
                            an_idagenda     IN operacion.agendamiento.idagenda%TYPE,
                            an_iderror      OUT NUMBER,
                            av_mensajeerror OUT VARCHAR2);
  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        25/06/2015  Jorge Rivas      Obtiene el flag de generacion de orden ADC
  ******************************************************************************/
  FUNCTION f_obtiene_flag_orden_adc(an_idagenda IN operacion.agendamiento.idagenda%TYPE)
    RETURN NUMBER;

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        30/07/2015  Jorge Rivas      Genera trama de capacidad desde una solot
  ******************************************************************************/
  procedure p_gen_trama_capacidad_solot(an_codsolot          operacion.solot.codsolot%type,
                                        av_cod_subtipo_orden operacion.subtipo_orden_adc.cod_subtipo_orden%type,
                                        ad_fecha             date,
                                        av_trama             out clob,
                                        Pv_xml               out clob,
                                        Pv_Mensaje_Repws     out varchar2,
                                        Pn_Codigo_Respws     Out number);

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        31/07/2015  Jorge Rivas      Elimina datos en la tabla de capacidad desde una solot
  ******************************************************************************/
  procedure p_elimna_tmp_capacidad_solot(an_codsolot operacion.solot.codsolot%type,
                                         an_error    out number,
                                         av_error    out varchar2);

  PROCEDURE p_insertar_parm_vta_pvta_adc(an_codsolot         operacion.solot.codsolot%type,
                                         an_id_subtipo_orden operacion.subtipo_orden_adc.id_subtipo_orden%TYPE,
                                         ad_fecha            DATE,
                                         av_cod_franja       operacion.franja_horaria.codigo%TYPE,
                                         av_bucket           operacion.parametro_vta_pvta_adc.idbucket%TYPE,
                                         Pn_Codigo_Respws    OUT NUMBER,
                                         Pv_Mensaje_Repws    OUT VARCHAR2);

  /******************************************************************************
     Ver         Date          Author                   Descripcion
  ---------  ----------  ------------------  ------------------------------------
    1.0      07/08/2015  Jorge Rivas       Retorna la fecha maxima de la tabla temporal por solot
  ******************************************************************************/
  FUNCTION f_obtiene_max_fech_solot(an_codsolot operacion.solot.codsolot%type,
                                    ad_fecha    agendamiento.fecagenda%type)
    RETURN NUMBER;

  /******************************************************************************
  Ver           Date          Author                   Descripcion
  ---------  ----------  ------------------ ----------------------------------------
  1.0        07/08/2014  Jorge Rivas        Retorna 1 si el cliente es corporativo
  ******************************************************************************/
  FUNCTION f_obtiene_tipo_cliente(av_codcli vtatabcli.codcli%TYPE)
    RETURN NUMBER;

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        08/10/2015  Jorge Rivas      Devuelve una tabla con los codigos de subtipo de orden
  ******************************************************************************/
  PROCEDURE p_obtiene_subtipord(av_cod_tipo_orden IN operacion.tipo_orden_adc.cod_tipo_orden%TYPE,
                                an_servicio       IN operacion.subtipo_orden_adc.servicio%TYPE,
                                an_decos          IN operacion.subtipo_orden_adc.decos%TYPE,
                                p_cursor          OUT gc_salida);

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        09/10/2015  Jorge Rivas      Devuelve parametros para tipo de orden HFCI
  ******************************************************************************/
  PROCEDURE p_obtener_parametros_HFCI(an_codsolot       IN operacion.solot.codsolot%TYPE,
                                      av_cod_tipo_orden OUT operacion.tipo_orden_adc.cod_tipo_orden%TYPE,
                                      an_servicio       OUT INTEGER,
                                      an_decos          OUT INTEGER);

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        06/11/2015  Jorge Rivas      Devuelve datos de parametro_vta_pvta_adc
  ******************************************************************************/
  PROCEDURE p_obtener_param_vta_pvta_adc(an_codsolot       IN operacion.solot.codsolot%TYPE,
                                         av_subtipo_orden  OUT operacion.parametro_vta_pvta_adc.subtipo_orden%TYPE,
                                         av_plano          OUT operacion.parametro_vta_pvta_adc.plano%TYPE,
                                         adt_fecha_progra  OUT operacion.parametro_vta_pvta_adc.fecha_progra%TYPE,
                                         av_franja         OUT operacion.parametro_vta_pvta_adc.franja%TYPE,
                                         an_fila           OUT INTEGER,
                                         av_cod_tipo_orden OUT operacion.tipo_orden_adc.cod_tipo_orden%TYPE,
                                         an_tiptra         OUT operacion.solot.tiptra%TYPE,
                                         an_flag           OUT INTEGER);
/******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        11/01/2016  Jorge Rivas      Consulta capacidad desde una incidencia
  ******************************************************************************/
  PROCEDURE p_consulta_capacidad_incid_sga(an_codincidence      operacion.transaccion_ws_adc.codincidence%TYPE DEFAULT NULL,
                                           an_tiptra            operacion.tiptrabajo.tiptra%TYPE DEFAULT NULL,
                                           av_cod_subtipo_orden operacion.subtipo_orden_adc.cod_subtipo_orden%type,
                                           av_plano              marketing.vtatabgeoref.idplano%TYPE,
                                           p_fecha              DATE, -- Fecha de Consulta de Capacidad
                                           p_id_msj_err         OUT number,
                                           p_desc_msj_err       OUT VARCHAR2);

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        11/01/2016  Jorge Rivas      Genera trama de capacidad para incidencia
  ******************************************************************************/
  PROCEDURE p_gen_trama_capacidad_incid(an_codincidence   operacion.transaccion_ws_adc.codincidence%TYPE,
                                        an_tiptra             operacion.tiptrabajo.tiptra%TYPE,
                                        av_cod_subtipo_orden  operacion.subtipo_orden_adc.cod_subtipo_orden%TYPE,
                                        av_plano              marketing.vtatabgeoref.idplano%TYPE,
                                        ad_fecha              date,
                                        av_trama              out clob,
                                        Pv_xml                out clob,
                                        Pv_Mensaje_Repws      out varchar2,
                                        Pn_Codigo_Respws      Out number);

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        26/01/2016  Jorge Rivas      Obtiene configuracion de parametros de incidencia
  ******************************************************************************/
   FUNCTION f_obtener_matriz_incidence_adc(an_codsubtype        operacion.matriz_incidence_adc.codsubtype%TYPE,
                                           an_codchannel        operacion.matriz_incidence_adc.codchannel%TYPE,
                                           an_codtypeservice    operacion.matriz_incidence_adc.codtypeservice%TYPE,
                                           an_codcase           operacion.matriz_incidence_adc.codcase%TYPE)
  RETURN NUMBER;

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        25/01/2016  Jorge Rivas      Insertar en la tabla parametro_incidence_adc
  ******************************************************************************/
  PROCEDURE p_insertar_parm_incidence_adc(an_codincidence         operacion.parametro_incidence_adc.codincidence%type,
                                          av_subtipo_orden        operacion.parametro_incidence_adc.subtipo_orden%TYPE,
                                          ad_fecha_programacion   operacion.parametro_incidence_adc.fecha_programacion%TYPE,
                                          av_franja               operacion.parametro_incidence_adc.franja%TYPE,
                                          av_idbucket             operacion.parametro_incidence_adc.idbucket%TYPE,
                                          av_idplano              operacion.parametro_incidence_adc.plano%TYPE,
                                          p_resultado    OUT NUMBER,
                                          p_mensaje      OUT VARCHAR2);

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        26/01/2016  Jorge Rivas      Insertar en la tabla parm_vta_pvta_adc desde una incidencia
  ******************************************************************************/
  PROCEDURE p_insertar_vta_pvta_adc_inc(an_codincidence operacion.parametro_incidence_adc.codincidence%type,
                                        an_codsolot     operacion.solot.codsolot%TYPE,
                                        p_resultado     OUT NUMBER,
                                        p_mensaje       OUT VARCHAR2);

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        03/06/2016  Jorge Rivas      Obtiene tipo de tecnologia
  ******************************************************************************/
  FUNCTION f_obtener_tipo_tecnologia(an_tiptra tiptrabajo.tiptra%TYPE)
    RETURN VARCHAR2;
  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        26/12/2019  Romario Medina      Obtiene tipo de tecnologia para Claro empresas
  ******************************************************************************/
  FUNCTION f_obtener_tipo_tecnologia_CE(an_tiptra tiptrabajo.tiptra%TYPE)
    RETURN VARCHAR2;
  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        12/01/2016  Jorge Rivas      Obtiene zona plano desde codsolot
  ******************************************************************************/
  PROCEDURE p_obtener_zona_plano
  ( an_codsolot operacion.solot.codsolot%TYPE,
    av_centrop    OUT marketing.vtasuccli.ubigeo2%TYPE,
    av_idplano    OUT marketing.vtasuccli.idplano%TYPE,
    av_tecnologia OUT VARCHAR2,
    an_error      OUT NUMBER,
    av_error      OUT VARCHAR2
  );
  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  2.0       26/02/2016  Jorge Rivas      Valida la disponibilidad de capacidad en ETA
  ******************************************************************************/
  PROCEDURE p_validar_disponibildad(
    an_idagenda  agendamiento.idagenda%TYPE,
    av_mensaje   OUT VARCHAR2,
    an_resultado Out NUMBER
  );

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  3.0        27/06/2015  Jorge Rivas      Devuelve una tabla con los centros poblados y zonas
  ******************************************************************************/
  PROCEDURE p_consulta_centro_poblado(pi_idpoblado         in string,
                                      pi_idubigeo          in string,
                                      pi_codclasificacion  in string,
                                      pi_clasificacion     in string,
                                      pi_codcategoria      in string,
                                      pi_categoria         in string,
                                      pi_idzona            in string,
                                      pi_descripcion       IN string,
                                      pi_flag_adc          IN string,
                                      pi_cobertura         IN string,
                                      pi_cobertura_lte     IN string,
                                      p_cursor OUT gc_salida);

  /******************************************************************************
  Ver           Date          Author                   Descripcion
  ---------  ----------  ------------------ ----------------------------------------
  1.0        25/05/2014  Justiniano Condori Cancelar las agendas asociadas a una SOT
  2.0        04/10/2016  Justiniano Condori
  ******************************************************************************/
  PROCEDURE p_cancelar_agendaxsot(p_sot       IN NUMBER,
                                  p_resultado OUT number,--2.0
                                  p_mensaje   OUT VARCHAR2);
  /******************************************************************************
  Ver           Date          Author                   Descripcion
  ---------  ----------  ------------------ ----------------------------------------
  1.0        26/05/2014                     Cargar Combo Tipo Trabajo
  ******************************************************************************/
  PROCEDURE p_lista_trabajo(p_cursor OUT gc_salida);
  /*Steve ini*/
  procedure p_elimna_tmp_capacidad(an_idagenda agendamiento.idagenda%type,
                                   an_error    out number,
                                   av_error    out varchar2);

  procedure p_actualiza_trs_interface_iw(an_idtrs  operacion.trs_interface_iw.idtrs%type,
                                         av_modelo operacion.trs_interface_iw.modelo%type,
                                         av_mac    operacion.trs_interface_iw.mac_address%type,
                                         av_ua     operacion.trs_interface_iw.unit_address%type,
                                         an_error  out number,
                                         av_error  out varchar2);

  function f_obtiene_codsolotxagenda(an_idagenda agendamiento.idagenda%type)
    return number;

  function f_datos_iw(av_cadena varchar2) return IW_SGA_BSCS;

  function f_obtiene_tipo_tecnologia(an_codsolot solot.codsolot%type,
                                     an_error    out number,
                                     av_error    out varchar2)
    return varchar2;

  procedure p_instala_equipo_HFC(an_idagenda agendamiento.idagenda%type,
                                 av_modelo     operacion.trs_interface_iw.modelo%type,
                                 av_mac        operacion.trs_interface_iw.mac_address%type, --telefonia
                                 av_mta_mac_cm operacion.trs_interface_iw.mac_address%type, --internet
                                 av_invsn      operacion.trs_interface_iw.mac_address%type, --tv
                                 av_ua         operacion.trs_interface_iw.unit_address%type,
                                 av_categoria  operacion.inventario_em_adc.categoria%type,
                                 an_error      out number,
                                 av_error      out varchar2);

  procedure p_asocia_tarjeta_deco_DTH(an_idagenda agendamiento.idagenda%type,
                                      av_numserie solotptoequ.numserie%type,
                                      av_mac      solotptoequ.mac%type,
                                      av_invsn    operacion.trs_interface_iw.mac_address%type,
                                      an_grupo    number,
                                      an_error    out number,
                                      av_error    out varchar2);

  procedure p_instala_equipo_DTH(an_idagenda  agendamiento.idagenda%type,
                                 av_numserie  solotptoequ.numserie%type,
                                 av_mac       solotptoequ.mac%type,
                                 an_grupo     number,
                                 an_codinssrv solotpto.codinssrv%type,
                                 an_error     out number,
                                 av_error     out varchar2);

  function f_obtiene_interfase(av_dsc   varchar2,
                               an_error out number,
                               av_error out varchar2) return varchar2;

  procedure p_instala_equipos_DTH_HFC(an_idagenda        agendamiento.idagenda%type,
                                      av_idinventario    varchar2,
                                      av_tecnol          varchar2,
                                      av_inv_description varchar2,
                                      av_modelo          operacion.trs_interface_iw.modelo%type,
                                      av_invtype_label   operacion.inventario_em_adc.idunico%type, --codigo unico
                                      av_codigosap       varchar2,
                                      av_invsn           operacion.trs_interface_iw.mac_address%type, --HFC DECO 2020 serie
                                      av_mta_mac_cm      operacion.trs_interface_iw.mac_address%type, --HFC MTA 620 --internet
                                      av_mta_mac         operacion.trs_interface_iw.mac_address%type, --HFC MTA 820 telefonia
                                      av_unit_addr       operacion.trs_interface_iw.unit_address%type,
                                      av_nro_tarjeta     operacion.trs_interface_iw.mac_address%type, --DTH TARJETA
                                      av_inddependencia  varchar2,
                                      av_observacion     varchar2,
                                      an_message_id      number,
                                      av_external_id     varchar2,
                                      an_error           out number,
                                      av_error           out varchar2);

  procedure p_valida_activacion_HFC(an_idagenda agendamiento.idagenda%type,
                                    an_error    out number,
                                    av_error    out varchar2);

  procedure p_valida_activacion_DTH(an_idagenda agendamiento.idagenda%type,
                                    an_error    out number,
                                    av_error    out varchar2);

  procedure p_valida_act_DTH_HFC(an_idagenda      agendamiento.idagenda%type,
                                 av_id_producto   operacion.trs_interface_iw.id_producto%type,
                                 av_tip_interfase operacion.trs_interface_iw.id_interfase%type,
                                 av_tecnol        varchar2,
                                 an_error         out number,
                                 av_error         out varchar2);

  function f_obtiene_cod_emta(an_error out number, av_error out varchar2)
    return varchar2;

  function f_obtiene_cod_box(an_error out number, av_error out varchar2)
    return varchar2;

  function f_obtiene_cant_dias(an_error out number, av_error out varchar2)
    return number;

  function f_obtiene_calculate_duration(an_error out number,
                                        av_error out varchar2)
    return varchar2;

  function f_obtiene_calculate_travel(an_error out number,
                                      av_error out varchar2) return varchar2;

  function f_obtiene_calcule_work_skill(an_error out number,
                                        av_error out varchar2)
    return varchar2;

  function f_obtiene_by_work_zone(an_error out number,
                                  av_error out varchar2) return varchar2;

  function f_obtiene_work_skill(av_cod_subtipo_orden operacion.subtipo_orden_adc.cod_subtipo_orden%type,
                                an_error             out number,
                                av_error             out varchar2)
    return varchar2;

  procedure p_gen_trama_capacidad(an_codsolot          solot.codsolot%type,
                                  an_idagenda          agendamiento.idagenda%type,
                                  av_cod_subtipo_orden operacion.subtipo_orden_adc.cod_subtipo_orden%type,
                                  ad_fecha             date,
                                  av_trama             out clob,
                                  Pv_xml               out clob,
                                  Pv_Mensaje_Repws     out varchar2,
                                  Pn_Codigo_Respws     Out number);

  function f_obtiene_origen_estado_motivo(av_tipo varchar2) return number;

  function f_retorna_estado_ETA_SGA(av_origen    varchar2, --ETA  / SGA
                                    an_tipoorden operacion.tipo_orden_adc.id_tipo_orden%type,
                                    an_estado    estagenda.estage%type,
                                    an_motivo    mot_solucionxtiptra.codmot_solucion%type,
                                    an_origen    out number) return number;

  procedure p_act_estado_agenda(av_origen   varchar2,
                                an_idagenda agendamiento.idagenda%type,
                                an_estado   number,
                                an_motivo   number,
                                av_ticket_remedy varchar2 default null,--23.0
                                an_error    out number,
                                av_error    out varchar2);

  function f_devuelve_fin_instalacion(an_message_id number) return number;

  function f_obtiene_tipo_trabajo(an_codsolot solot.codsolot%type,
                                  an_error    out number,
                                  av_error    out varchar2) return number;

  PROCEDURE p_consulta_capacidad_sga(an_codsolot          solot.codsolot%type,
                                     an_idagenda          agendamiento.idagenda%type,
                                     av_cod_subtipo_orden operacion.subtipo_orden_adc.cod_subtipo_orden%type,
                                     p_fecha              DATE, -- Fecha de Consulta de Capacidad
                                     p_id_msj_err         OUT number,
                                     p_desc_msj_err       OUT VARCHAR2);

  FUNCTION f_obtiene_tipoorden(as_tiptra tiptrabajo.tiptra%TYPE,
                               an_error  out number,
                               av_error  out varchar2) RETURN VARCHAR2;

  PROCEDURE p_devuelve_categoria_inv(as_idunico      operacion.inventario_em_adc.idunico%type,
                                     an_tipo         number,--3.0 <fase 2>
                                     as_categoria    out operacion.inventario_em_adc.categoria%type,
                                     an_iderror      OUT NUMERIC,
                                     as_mensajeerror OUT VARCHAR2);

  PROCEDURE p_insertar_log_instalacion_eqp(av_tipo         varchar2,
                                           an_message_id   number,
                                           an_idagenda     agendamiento.idagenda%type,
                                           av_idinventario varchar2);
  /*Steve fin */

  /******************************************************************************
    Ver         Date          Author                   Descripcion
  ---------  ----------  ------------------  ------------------------------------
   1.0        04/06/2015  Justiniano Condori  Retorna Disponibilidad Maxima
  ******************************************************************************/
  FUNCTION f_obtiene_disp_max RETURN NUMBER;
  /******************************************************************************
     Ver         Date          Author                   Descripcion
  ---------  ----------  ------------------  ------------------------------------
    1.0        05/06/2015  Justiniano Condori  Retorna la fecha maxima de la tabla temporal
  ******************************************************************************/
  FUNCTION f_obtiene_max_fech(an_idagenda agendamiento.idagenda%type,
                              ad_fecha    agendamiento.fecagenda%type)
    RETURN NUMBER;
  /******************************************************************************
     Ver         Date          Author                   Descripcion
  ---------  ----------  ------------------  ------------------------------------
  1.0        05/06/2015  Justiniano Condori  Reemplaza los caracteres especiales
  ******************************************************************************/
  FUNCTION f_reemplazar_caracter(p_caracter in clob) return clob;

  /******************************************************************************
    Ver         Date          Author                   Descripcion
  ---------  ----------  ------------------  ------------------------------------
  1.0        05/06/2015  Justiniano Condori  Realiza la creacion de la trama de la
                                             orden de Trabajo Agendamiento/Reagendamiento/Puerta a Puerta/
                                             No Programada
  ******************************************************************************/
  procedure p_gen_trama_orden_trabajo(p_ind            in varchar2,
                                      p_idagenda       in number,
                                      p_fecha          in date, -- solo para PR y RP, caso contrario nulo
                                      p_franja_horaria in varchar2, -- solo para PR y RP, caso contrario nulo
                                      p_bucket         in varchar2, -- Si es PP sera el dni del tecnico que sera el bucket
                                      p_contacto       in varchar2, -- solo para RP, caso contrario nulo
                                      p_direccion      in varchar2, -- solo para RP, caso contrario nulo
                                      p_telefono       in varchar2, -- solo para RP, caso contrario nulo
                                      p_zona           in varchar2,
                                      p_plano          in varchar2,
                                      p_tipo_orden     in varchar2,
                                      p_subtipo_orden  in varchar2,
                                      p_observaciones  in varchar2,
                                      p_trama          out clob,
                                      p_resultado      out varchar2,
                                      p_mensaje        out varchar2);

  /******************************************************************************
     Ver         Date          Author                   Descripcion
  ---------  ----------  ------------------  ------------------------------------
   1.0       05/06/2015  Justiniano Condori  Realiza la creacion de la orden de Trabajo Programada
  ******************************************************************************/
  procedure p_crear_orden_adc_pr(p_idagenda       in number,
                                 p_sot            in number,
                                 p_fecha          in date,
                                 p_bucket         in varchar2,
                                 p_franja_horaria in varchar2,
                                 p_zona           in varchar2,
                                 p_plano          in varchar2,
                                 p_tipo_orden     in varchar2,
                                 p_subtipo_orden  in varchar2,
                                 p_cod_rpt        out varchar2,
                                 p_msj_rpt        out varchar2);
  /******************************************************************************
     Ver         Date          Author                   Descripcion
  ---------  ----------  ------------------  ------------------------------------
   1.0       05/06/2015  Justiniano Condori  Realiza la creacion de la orden de Trabajo No Programada
  ******************************************************************************/
  procedure p_crear_orden_adc_np(p_idagenda      in number,
                                 p_sot           in number,
                                 p_idbucket      in varchar2,
                                 p_zona          in varchar2,
                                 p_plano         in varchar2,
                                 p_tipo_orden    in varchar2,
                                 p_subtipo_orden in varchar2,
                                 p_cod_rpt       out varchar2,
                                 p_msj_rpt       out varchar2);
  /******************************************************************************
     Ver         Date          Author                   Descripcion
  ---------  ----------  ------------------  ------------------------------------
   1.0       05/06/2015  Justiniano Condori  Realiza la creacion de la orden de Trabajo Puerta a Puerta
  ******************************************************************************/
  procedure p_crear_orden_adc_pp(p_idagenda      in number,
                                 p_sot           in number,
                                 p_dni_tecnico   in varchar2,
                                 p_zona          in varchar2,
                                 p_plano         in varchar2,
                                 p_tipo_orden    in varchar2,
                                 p_subtipo_orden in varchar2,
                                 p_cod_rpt       out varchar2,
                                 p_msj_rpt       out varchar2);
  /******************************************************************************
     Ver         Date          Author                   Descripcion
  ---------  ----------  ------------------  ------------------------------------
   1.0       05/06/2015  Justiniano Condori  Realiza la creacion de la orden de Trabajo Programada
                                             por Interface de Agendamiento/ReAgendamiento.
  ******************************************************************************/
  procedure p_crear_orden_adc_inter(p_ind            in varchar2,
                                    p_idagenda       in number,
                                    p_fecha          in date,
                                    p_contacto       in varchar2,
                                    p_direccion      in varchar2,
                                    p_telefono       in varchar2,
                                    p_bucket         in varchar2,
                                    p_franja_horaria in varchar2,
                                    p_plano          in varchar2,
                                    p_zona           in varchar2,
                                    p_tipo_orden     in varchar2,
                                    p_subtipo_orden  in varchar2,
                                    p_observaciones  in varchar2,
                                    p_cod_rpt        out varchar2,
                                    p_msj_rpt        out varchar2);
  /******************************************************************************
     Ver         Date          Author                   Descripcion
  ---------  ----------  ------------------  ------------------------------------
   1.0       05/06/2015  Justiniano Condori  Realiza la creacion de la orden de Trabajo en
                                             Oracle Field Service
  ******************************************************************************/
  procedure p_crear_ot_wf(p_idagenda  in number,
                          p_resultado out varchar2,
                          p_mensaje   out varchar2);

  /******************************************************************************
    Ver         Date          Author                   Descripcion
  ---------  ----------  ------------------  ------------------------------------
  1.0        17/06/2015  Juan Carlos Gonzales  Retorna Estado de la matriz de mantenimiento
                                               Tipos de trabajo y Servicios
  ******************************************************************************/
  FUNCTION f_val_generacion_ot_auto(p_tipsrv OPERACION.MATRIZ_TYSTIPSRV_TIPTRA_ADC.TIPSRV%TYPE,
                                    p_tiptra OPERACION.MATRIZ_TYSTIPSRV_TIPTRA_ADC.TIPTRA%TYPE,
                                    p_motivo OPERACION.MATRIZ_TIPTRATIPSRVMOT_ADC.ID_MOTIVO%TYPE,
                                    p_agenda OPERACION.MATRIZ_TYSTIPSRV_TIPTRA_ADC.TIPO_AGENDA%TYPE)
    RETURN NUMBER;
  /******************************************************************************
     Ver         Date          Author                   Descripcion
  ---------  ----------  ------------------  ------------------------------------
   1.0       05/06/2015                      Iniciar la orden en el SGA para actualizar Coordenada
  ******************************************************************************/
  PROCEDURE p_inicia_orden_adc(an_IdAgenda     in operacion.agendamiento.idagenda%type,
                               as_idtecnico    in varchar2,
                               as_coordenadas  in varchar2,
                               an_iderror      OUT NUMERIC,
                               as_mensajeerror OUT VARCHAR2);

  /******************************************************************************
    Ver         Date          Author                   Descripcion
  ---------  ----------  ------------------  ------------------------------------
  1.0        16/06/2015  Luis Polo Benites   Inserta carga de excel de inventarios
  2.0        02/03/2016  Steve Panduro       ETA FASE 2 CE
  3.0        26/09/2016  Justiniano Condori
  ******************************************************************************/
  PROCEDURE p_carga_inventario_adc(ln_id_proceso       in number,--3.0
                                   ls_long_dni         in number, --3.0
                                   ls_long_serie_deco  in number,--3.0
                                   ls_long_ua_deco     in number,--3.0
                                   ls_long_serie_emta  in number,--3.0
                                   ls_long_mac_cm_emta in number,--3.0
                                   ls_long_mac_emta    in number,--3.0
                                   ls_tecnologia       IN operacion.inventario_env_adc.tecnologia%TYPE,
                                   ls_descripcion      IN operacion.inventario_env_adc.descripcion%TYPE,
                                   ls_modelo           IN operacion.inventario_env_adc.modelo%TYPE,
                                   ls_tipo_inventario  IN operacion.inventario_env_adc.tipo_inventario%TYPE,
                                   ls_codigo_sap       IN operacion.inventario_env_adc.codigo_sap%TYPE,
                                   ls_invsn            IN operacion.inventario_env_adc.invsn%TYPE,
                                   ls_mta_mac_cm       IN operacion.inventario_env_adc.mta_mac_cm%TYPE,
                                   ls_mta_mac          IN operacion.inventario_env_adc.mta_mac%TYPE,
                                   ls_unit_addr        IN operacion.inventario_env_adc.unit_addr%TYPE,
                                   ls_nro_tarjeta      IN operacion.inventario_env_adc.nro_tarjeta%TYPE,
                                   ls_inddependencia   IN operacion.inventario_env_adc.inddependencia%TYPE,
                                   ln_idrecursoext     IN operacion.inventario_env_adc.id_recurso_ext%TYPE,
                                   ls_observacion      IN operacion.inventario_env_adc.observacion%TYPE,
                                   ln_quantity         IN operacion.inventario_env_adc.quantity%TYPE,
                                   ln_fecha_inventario IN operacion.inventario_env_adc.fecha_inventario%TYPE,
                                   --ln_archivo          IN operacion.inventario_env_adc.archivo%TYPE,--3.0
                                   ln_flg_tipo         IN operacion.inventario_env_adc.flg_tipo%TYPE); --2.0 FASE 2 ETA
  /******************************************************************************
    Ver         Date          Author                   Descripcion
  ---------  ----------  ------------------  ------------------------------------
  1.0        16/06/2015  Luis Polo Benites   Valida los datos ingresados a traves del excel
  2.0        02/03/2016  Steve Panduro       ETA FASE 2 CE
  3.0        02/03/2016  Steve Panduro       ETA FASE 2 CE
  4.0        02/03/2016  Steve Panduro       Modificacion de descripcion
  5.0        26/09/2016  Justiniano Condori
  ******************************************************************************/
  PROCEDURE p_validar_excl_carga_masiva(ln_id_proceso       in number,--5.0
                                        ln_long_dni         in number,--5.0
                                        ln_long_serie_deco  in number,--5.0
                                        ln_long_ua_deco     in number,--5.0
                                        ln_long_serie_emta  in number,--5.0
                                        ln_long_mac_cm_emta in number,--5.0
                                        ln_long_mac_emta    in number,--5.0
                                        ln_idinventario     IN operacion.inventario_env_adc.id_inventario%TYPE,
                                        ls_tecnologia       IN operacion.inventario_env_adc.tecnologia%TYPE,
                                        ln_idrecursoext     IN operacion.inventario_env_adc.id_recurso_ext%TYPE,
                                        ln_fecha_inventario IN operacion.inventario_env_adc.fecha_inventario%TYPE,
                                        ln_flg_tipo         IN operacion.inventario_env_adc.flg_tipo%TYPE); --2.0 FASE 2 ETA
  /******************************************************************************
    Ver         Date          Author                   Descripcion
  ---------  ----------  ------------------  ------------------------------------
  1.0        16/06/2015  Luis Polo Benites   Ejecuta el WS de inventario FULL
  2.0        25/05/2016  Juan Gonzales       Carga Incremental
  3.0        03/06/2016  Juan Gonzales       Adicionar contrata
  4.0        03/06/2016  Juan Gonzales       Control de errores
  5.0        05/10/2016  Justiniano Condori
  ******************************************************************************/
  PROCEDURE p_ws_inventario(an_id_proceso   in number, --5.0
                            an_fecha        IN operacion.inventario_env_adc.fecha_inventario%TYPE,
                            av_servicio     varchar2,
                            an_flg_tipo     in operacion.inventario_env_adc.flg_tipo%type, --2.0 eta fase 2
                            av_contrata     IN operacion.inventario_env_adc.usureg%type, --3.0
                            av_accion       IN VARCHAR2,--3.0
                            an_iderror      OUT NUMERIC,
                            av_mensajeerror OUT VARCHAR2);
  /******************************************************************************
  Ver        Date        Author             Description
  ---------  ----------  -----------------  -----------------------------------
  1.0        16/06/2015  Luis Polo Benites  Generacion de trama para inventario
  3.0        03/06/2016  Juan Gonzales      Adicionar contrata
  ******************************************************************************/
  PROCEDURE p_gen_trama_inventario_full(an_fecha        IN operacion.inventario_env_adc.fecha_inventario%TYPE,
                                        av_contrata     IN operacion.inventario_env_adc.usureg%type, --3.0
                                        av_trama        OUT CLOB,
                                        an_iderror      OUT NUMERIC,
                                        as_mensajeerror OUT VARCHAR2);
  /******************************************************************************
  Ver        Date        Author             Description
  ---------  ----------  -----------------  -----------------------------------
  1.0        16/06/2015  Luis Polo Benites  Generacion de trama para inventario
  2.0        11/05/2016  juan Gonzales      Incidencia SGA-SD-788452
  3.0        03/06/2016  Juan Gonzales      Adicionar contrata y accion
  4.0        05/10/2016  Justiniano Condori Modificar el proceso de envio de trama
  ******************************************************************************/
  PROCEDURE p_gen_trama_inventario_inc(an_id_proceso    in number, --4.0
                                       an_fecha         IN operacion.inventario_env_adc.fecha_inventario%TYPE,
                                       an_idrecurso_ext IN operacion.inventario_env_adc.id_recurso_ext%TYPE,
                                       av_contrata      IN operacion.inventario_env_adc.usureg%type, --3.0
                                       av_accion        IN VARCHAR2,--3.0
                                       av_trama         OUT CLOB,
                                       an_iderror       OUT NUMERIC,
                                       as_mensajeerror  OUT VARCHAR2);

  /******************************************************************************
    Ver         Date          Author                   Descripcion
  ---------  ----------  ------------------  ------------------------------------
  1.0        16/06/2015  Justiniano Condori  Inserta registro en la tabla de creacion de OTs
  ******************************************************************************/
  procedure p_insert_ot_adc(p_sot      in number,
                            p_origen   in varchar2,
                            p_idagenda in number,
                            p_estado   in number,
                            p_motivo   IN operacion.cambio_estado_ot_adc.motivo%TYPE DEFAULT NULL);
  /******************************************************************************
    Ver         Date          Author                   Descripcion
  ---------  ----------  ------------------  ------------------------------------
  1.0        16/06/2015  Nalda Arotinco      Obtiene valores para la creacion de OT
  ******************************************************************************/
  PROCEDURE p_obtiene_valores_adc(an_idagenda     IN agendamiento.idagenda%TYPE,
                                  av_idplano      out operacion.parametro_vta_pvta_adc.plano%TYPE,
                                  av_centrop      out operacion.parametro_vta_pvta_adc.idpoblado%TYPE,
                                  av_subtipo      out operacion.parametro_vta_pvta_adc.subtipo_orden%type,
                                  an_tiptra       out operacion.solot.tiptra%type,
                                  av_tipsrv       out operacion.solot.tipsrv%type,
                                  av_bucket       out operacion.parametro_vta_pvta_adc.idbucket%TYPE,
                                  an_dnitec       out operacion.parametro_vta_pvta_adc.dni_tecnico%type,
                                  ad_fecha        out operacion.parametro_vta_pvta_adc.fecha_progra%type,
                                  av_franja       out operacion.parametro_vta_pvta_adc.franja%type,
                                  av_indpp        out operacion.parametro_vta_pvta_adc.flg_puerta%type,
                                  av_zona         out operacion.zona_adc.codzona%type,
                                  an_iderror      OUT NUMERIC,
                                  as_mensajeerror OUT VARCHAR2);
  /******************************************************************************
    Ver         Date          Author                   Descripcion
  ---------  ----------  ------------------  ------------------------------------
  1.0        16/06/2015  Justiniano Condori  Devolver el Subtipo de Orden en base a la SOT
  ******************************************************************************/
  function f_devuelve_subtipo(p_codsolot in number) return varchar2;

  /******************************************************************************
    Ver         Date          Author                   Descripcion
  ---------  ----------  ------------------  ------------------------------------
  1.0        16/06/2015  Steve P.  Actualiza Tabla solotptoqu DTH
  ******************************************************************************/

  procedure p_actualiza_solotptoqu_dth(an_codsolot solot.codsolot%type,
                                       av_numserie solotptoequ.numserie%type,
                                       av_mac      solotptoequ.mac%type,
                                       av_invsn    operacion.trs_interface_iw.mac_address%type,
                                       an_grupo    number,
                                       an_error    out number,
                                       av_error    out varchar2);

  /******************************************************************************
    Ver         Date          Author                   Descripcion
  ---------  ----------  ------------------  ------------------------------------
  1.0        31/07/2015  Justiniano Condori  Validar si pertenece a Zona Lejana
  ******************************************************************************/
  function f_val_zonalejana(p_idagenda in number) return number;
  --ini 4.0
 /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        11/05/2016  Juan Gonzales    Asignacion de contrata para ejecucion desde
                                          el aplicativo ETADirect
  ******************************************************************************/
  PROCEDURE p_asignacontrata_st (an_agenda       operacion.agendamiento.idagenda%TYPE,
                                 av_subto        VARCHAR2,
                                 av_idbucket     VARCHAR2,
                                 av_codcon       VARCHAR2,
                                 an_iderror      OUT NUMBER,
                                 av_mensajeerror OUT VARCHAR2);
--Fin 4.0
--INI 5.0
  /******************************************************************************
    Ver         Date          Author                   Descripcion
  ---------  ----------  ------------------  ------------------------------------
  1.0        11/02/2016   Emma Guzman      Evalua la agenda y devuelve 1 = MASIVO, 2 = CLARO EMPRESA
  ******************************************************************************/
  PROCEDURE p_tipo_serv_x_agenda(p_idagenda      in number,
                                 an_tipo         out number,
                                 an_iderror      OUT NUMERIC,
                                 as_mensajeerror OUT VARCHAR2);
  /******************************************************************************
    Ver         Date          Author                   Descripcion
  ---------  ----------  ------------------  ------------------------------------
  1.0        11/02/2016   Emma Guzman      Evalua la agenda y devuelve 1 = MASIVO, 2 = CLARO EMPRESA
  ******************************************************************************/
  PROCEDURE p_tipo_x_tiposerv(an_codsolot     in number,
                              an_tipo         out number,
                              an_iderror      OUT NUMERIC,
                              as_mensajeerror OUT VARCHAR2);
  /******************************************************************************
    Ver         Date          Author                   Descripcion
  ---------  ----------  ------------------  ------------------------------------
  1.0        18/02/2016   Emma Guzman      Valida Datos de Clro Empresa
  ******************************************************************************/
  PROCEDURE p_valida_datos_ce(an_codsolot     in number,
                              an_iderror      OUT NUMERIC,
                              as_mensajeerror OUT VARCHAR2);
  /******************************************************************************
    Ver         Date          Author                   Descripcion
  ---------  ----------  ------------------  ------------------------------------
  1.0        22/02/2016   Emma Guzman      Valida tipo de orden de la sot
  ******************************************************************************/
  function f_valida_tipo_orden(p_codsolot in number) return number;
  /******************************************************************************
    Ver         Date          Author                   Descripcion
  ---------  ----------  ------------------  ------------------------------------
  1.0        11/02/2016   Emma Guzman      Evalua el tipo serv y devuelve 1 = MASIVO, 2 = CLARO EMPRESA
  ******************************************************************************/
  function f_tipo_x_tiposerv(as_tipsrv in solot.tipsrv%type) return number;
  /******************************************************************************
    Ver         Date          Author                   Descripcion
  ---------  ----------  ------------------  ------------------------------------
  1.0        11/02/2016   Emma Guzman      Evalua el tipo trabajo y la incidencia y devuelve 1 = MASIVO, 2 = CLARO EMPRESA
  ******************************************************************************/
  function f_tipo_x_titra_incid(an_tiptra       in solot.tiptra%type,
                                an_codincidence incidence.codincidence%type)
    return number;
  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        15/01/2016  Juan Gonzales    Instala Equipo CE
  2.0        17/06/2016  Juan Gonzales        Instala Equipo CE correccion instalacion decos
  3.0        15/07/2016  Felipe Maguiña       Instala Equipo CE correccion instalacion
  4.0        01/09/2016  Justiniano Condori   Instalacion de Equipos CE
  ******************************************************************************/
  procedure p_instala_equipo_hfc_ce(an_idagenda   agendamiento.idagenda%type,
                                    av_modelo     intraway.int_servicio_intraway.modelo%type,
                                    av_mac        intraway.int_servicio_intraway.macaddress%type, --telefonia
                                    av_mta_mac_cm intraway.int_servicio_intraway.macaddress%type, --internet
                                    av_invsn      intraway.int_servicio_intraway.macaddress%type, --tv
                                    av_ua         intraway.int_servicio_intraway.serialnumber%type,
                                    av_categoria  operacion.inventario_em_adc.categoria%type,
                                    an_error      out number,
                                    av_error      out varchar2);
  /******************************************************************************
    Ver         Date          Author                   Descripcion
  ---------  ----------  ------------------  ------------------------------------
  1.0        11/02/2016  Steve Panduro     Obtiene Tipo de Orden x Tipo Trabajo y Tipo servicio -  CLARO EMPRESA
  ******************************************************************************/
  procedure p_tipo_serv_x_tipotrabajo(av_tipsrv     tystipsrv.tipsrv%type,
                                      an_tiptra     tiptrabajo.tiptra%type,
                                      av_tipo_orden out operacion.tipo_orden_adc.cod_tipo_orden%type,
                                      an_error      OUT NUMERIC,
                                      av_error      OUT VARCHAR2);

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        26/05/2015  Steve P.               Obtiene Tipo de Orden CE
  ******************************************************************************/

  FUNCTION f_obtiene_tipoorden_ce(as_tiptra tiptrabajo.tiptra%TYPE,
                                  an_error  out number,
                                  av_error  out varchar2) RETURN VARCHAR2;

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        26/05/2015  Juan Gonzales    Valida PosVenta para Claro empresa
  ******************************************************************************/

  PROCEDURE p_valida_posventa_ce(av_tipsrv in solot.tipsrv%type,
                                an_tiptra in tiptrabajo.tiptra%TYPE,
                                av_tipo_orden out operacion.tipo_orden_adc.cod_tipo_orden%type,
                                an_error      OUT NUMERIC,
                                av_error      OUT VARCHAR2);
  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        02/05/2016  Juan Gonzales    Validacion para las Bajas
  ******************************************************************************/
   PROCEDURE p_valida_fecha(p_fecha       date,
                           p_tipsvr      varchar2,
                           p_iderror     out number,
                           p_mensaje     out varchar2);

/******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        02/05/2016  Juan Gonzales    Validacion de tipo de trabajo, servicio y motivo
  ******************************************************************************/
  procedure p_valida_motivo (p_tiptra   IN  tiptrabajo.tiptra%type,
                             p_tipsvr   IN  operacion.MATRIZ_TYSTIPSRV_TIPTRA_ADC.tipsrv%type,
                             p_codmotot IN  operacion.matriz_tiptratipsrvmot_adc.id_motivo%type,
                             p_iderror  OUT number);

--FIN 5.0
--INI 7.0
/******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        11/05/2016  Juan Gonzales    obtener la programacion de la agenda
  ******************************************************************************/
PROCEDURE p_obtener_prog_agenda (an_agenda        IN operacion.agendamiento.idagenda%TYPE,
                                 p_solot          OUT solot.codsolot%type,
                                 p_fecha          OUT date,
                                 p_bucket         OUT varchar2,
                                 p_franja_horaria OUT varchar2,
                                 p_zona           OUT varchar2,
                                 p_plano          OUT varchar2,
                                 p_tipo_orden     OUT varchar2,
                                 p_subtipo_orden  OUT varchar2,
                                 p_cod_rpt        out varchar2,
                                 p_msj_rpt        out varchar2);

--FIN 7.0
-- Ini 9.0
  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        15/07/2015  Felipe Maguiña   Inserta Log Instalacion de Equipos
  ******************************************************************************/
  procedure p_insertar_log_inst_eqp_hfc(an_idagenda     operacion.agendamiento.idagenda%TYPE,
                                        av_id_interfase varchar2,
                                        av_modelo       operacion.trs_interface_iw.modelo%type,
                                        av_mac          operacion.trs_interface_iw.mac_address%type,
                                        av_invsn        operacion.trs_interface_iw.mac_address%type,
                                        an_iderror      number,
                                        av_descripcion  varchar2,
                                        av_proceso      varchar2);
-- Fin 9.0
  -- Ini 10.0
  /******************************************************************************
    Ver         Fecha         Autor                   Descripcion
  ---------  ----------  ---------------  ------------------------------------
    1.0      13/08/2016  Justiniano       Consulta el mensaje configurado segun una abreviatura
                         Condori
  ******************************************************************************/
  function f_consulta_msj_x_abrev(p_abrev in varchar2)
  return varchar2;
  /******************************************************************************
    Ver         Fecha         Autor                   Descripcion
  ---------  ----------  ---------------  ------------------------------------
    1.0      13/08/2016  Justiniano       Consulta el mensaje configurado segun el texto
                         Condori
  ******************************************************************************/
  function f_consulta_msj_x_msj(p_msj in varchar2)
  return varchar2;
  -- Fin 10.0
  --Ini 12.0

   --INI FASE 3
  /***********************************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        19/09/2016  Alfonso Muñante  Obtiene consulta historica
  *********************************************************************************************/
  PROCEDURE AGENDAMSS_CONSULTA_HIST_ETA(an_idagenda  operacion.agendamiento.idagenda%TYPE,
                                          p_agenda     OUT SYS_REFCURSOR);

   /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        27/09/2016  Alfonso M.      Obtiene el plano
  ******************************************************************************/
  PROCEDURE SGASS_OBTIENE_PLANO(an_tiptra     solot.tiptra%type,
                           an_codinssrv  inssrv.codinssrv%type,
                           an_plano      out vtasuccli.idplano%type,
                           an_error      out number,
                           av_error      out varchar2);

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        27/09/2016  Alfonso M.      Obtiene el tipo de tecnologia
  ******************************************************************************/
  FUNCTION SGAFUN_obtiene_tiptra(an_tiptra     solot.tiptra%type) return varchar2;

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        27/09/2016  Alfonso M.      Obtiene el centro poblado por incidencia
  ******************************************************************************/
  procedure SGASS_GET_CENT_PBL(p_incidence customerxincidence.codincidence%type,
                           p_centro out sys_refcursor);

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        27/09/2016  Alfonso M.      Actualiza datos de agendamiento
  ******************************************************************************/
  procedure SGASU_ACT_AGENDAMIENTO (p_agenda           in operacion.agendamiento.idagenda%type,
                                         p_codcon           in operacion.agendamiento.codcon%type,
                                         p_ACTA_INSTALACION in operacion.agendamiento.acta_instalacion%type,
                                         p_ESTAGE           in operacion.agendamiento.estage%type,
                                         p_FEC_INSTALACION  in operacion.agendamiento.fecha_instalacion%type,
                                         p_OBSERVACION      in operacion.agendamiento.observacion%type,
                                         p_FECAGENDA        in operacion.agendamiento.fecagenda%type,
                                         p_CINTILLO         in operacion.agendamiento.cintillo%type,
                                         p_CODCNT           in operacion.agendamiento.codcnt%type,
                                         p_NOMCNT           in operacion.agendamiento.nomcnt%type,
                                         p_INSTALADOR       in operacion.agendamiento.instalador%type,
                                         p_SUPERVISOR       in operacion.agendamiento.supervisor%type,
                                         p_FECREAGENDA      in operacion.agendamiento.fecreagenda%type);

 --FIN FASE

/***********************************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        16/09/2016  Luis Guzmán      Insertar a la tabla operacion.sga_orden_reproceso_adc
  *********************************************************************************************/
  PROCEDURE carga_orden_reproceso(p_reproceso          NUMBER,
                                  p_cod_solot          NUMBER,
                                  p_idagenda           NUMBER,
                                  p_archivo            VARCHAR2,
                                  p_codigo_respuesta   OUT NUMBER,
                                  p_mensaje_respuesta  OUT VARCHAR2);

/***********************************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        16/09/2016  Luis Guzmán      Insertar a la tabla operacion.sga_log_reproceso
  *********************************************************************************************/
  PROCEDURE orden_registrar_log(p_reproceso         NUMBER,
                                p_cod_solot         NUMBER,
                                p_idagenda          NUMBER,
                                p_des_error         VARCHAR2,
                                p_archivo           VARCHAR2,
                                p_cod_error         NUMBER,
                                p_codigo_respuesta  OUT NUMBER,
                                p_mensaje_respuesta OUT VARCHAR2);


  /***********************************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        19/09/2016  Luis Guzmán      Reprocesa las ordenes
  *********************************************************************************************/
  PROCEDURE orden_reproceso(p_reproceso         NUMBER,
                            p_cod_solot         NUMBER,
                            p_idagenda          NUMBER,
                            p_codigo_respuesta  OUT NUMBER,
                            p_mensaje_respuesta OUT VARCHAR2) ;

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        19/09/2016  Luis Guzmán    Cancelacion de agendas por SOT
  ******************************************************************************/
  PROCEDURE p_cancela_orden_repr_ord(an_codsot       IN operacion.agendamiento.codsolot%TYPE,
                                     an_idagenda     IN NUMBER,
                                     an_estagenda    IN NUMBER,
                                     an_iderror      OUT NUMERIC,
                                     av_mensajeerror OUT VARCHAR2) ;

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        30/09/2016  Luis Guzmán    Recupera valores de la tabla de parametros
  ******************************************************************************/
  FUNCTION f_obtiene_val_par_det(av_cab_abrev operacion.parametro_cab_adc.abreviatura%type,
                                 av_par_caden varchar2,
                                 an_tipo      number,
                                 av_campo     varchar2) return varchar2;
  /*******************************************************************************************
    Ver         Fecha         Autor                   Descripcion
  ---------  ----------  --------------------  -----------------------------------------------
    1.0      12/09/2016  Justiniano Condori    Consulta el Tipo de Flag
  *******************************************************************************************/
  procedure paramss_consulta_flagtipo(p_flag_tipo out number);
  /*******************************************************************************************
    Ver         Fecha         Autor                   Descripcion
  ---------  ----------  --------------------  -----------------------------------------------
    1.0      03/10/2016  Justiniano Condori    Consulta Valores de validacion
  *******************************************************************************************/
  procedure p_param_val_inv(p_long_dni out number,
                            p_long_serie_deco out number,
                            p_long_ua_deco out number,
                            p_long_serie_emta out number,
                            p_long_mac_cm_emta out number,
                            p_long_mac_emta out number,
                            p_cod out number,
                            p_mensaje out varchar2);
  /*******************************************************************************************
    Ver         Fecha         Autor                   Descripcion
  ---------  ----------  --------------------  -----------------------------------------------
    1.0      03/10/2016  Justiniano Condori    Inserta la cabecera del inventario para envio
  *******************************************************************************************/
  procedure p_insert_cab_inv_adc(p_tipo_proceso in number,
                                 p_ruta_archivo in varchar2,
                                 p_id_proceso out number,
                                 p_cod out number,
                                 p_mensaje out varchar2);
  /*******************************************************************************************
    Ver         Fecha         Autor                   Descripcion
  ---------  ----------  --------------------  -----------------------------------------------
    1.0      05/10/2016  Justiniano Condori    Valida que los registros esten todos validados
  *******************************************************************************************/
  procedure p_val_proc_carga(p_id_proceso in number,
                             p_val        out number,
                             p_cod        out number,
                             p_mensaje    out varchar2);
  /*******************************************************************************************
    Ver         Fecha         Autor                   Descripcion
  ---------  ----------  --------------------  -----------------------------------------------
    1.0      18/10/2016  Justiniano Condori    Realiza el conteo de los registros que se
                                               encuentran con errores
  *******************************************************************************************/
  function f_val_elem_error(p_id_proceso in number) return number;
  --Fin 12.0
-- ini 13.0
  /*******************************************************************************************
    Ver         Fecha         Autor                   Descripcion
  ---------  ----------  --------------------  -----------------------------------------------
    1.0      07/10/2016  Juan Carlos Gonzales  Valida la configuracion del tiptra y tipsrv
                                               en la configuracion para los telefonos del cliente
  *******************************************************************************************/
  function f_val_conf_telf_cliente(p_idagenda agendamiento.idagenda%type)return number;
-- Fin 13.0

/******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  3.0        07/10/2016  Jorge Rivas      Devuelve tipo de orden y subtipo de orden
  ******************************************************************************/
  PROCEDURE SGASS_OBTDATOS_ORDEN
  (p_numslc             IN  sales.vtadetptoenl.numslc%TYPE,
   p_tiptra             OUT operacion.tiptrabajo.tiptra%TYPE,
   p_id_tipo_orden      OUT operacion.subtipo_orden_adc.id_tipo_orden%TYPE,
   p_cod_tipo_orden     OUT operacion.tipo_orden_adc.cod_tipo_orden%TYPE,
   p_id_subtipo_orden   OUT operacion.subtipo_orden_adc.id_subtipo_orden%TYPE,
   p_cod_subtipo_orden  OUT operacion.subtipo_orden_adc.cod_subtipo_orden%TYPE,
   p_resultado          OUT INTEGER,
   p_mensaje            OUT VARCHAR2);

   --INICIO
    /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  3.0        13/10/2016  Jorge Rivas      Devuelve 1 si la solucion es tipo de cliente nuevo
  ******************************************************************************/
  FUNCTION SGAFUN_SOLCLIENTE_NUEVO(p_id_solucion IN sales.vtatabslcfac.idsolucion%TYPE)
  RETURN NUMBER;

   /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        27/09/2016  Alfonso M.      Obtiene valores de la tabla de parametros
  ******************************************************************************/
  FUNCTION f_obtiene_valores_crmdd(p_abreviacion crmdd.abreviacion%TYPE,
                                   p_abrev       tipcrmdd.abrev%TYPE,
                                   an_tipo       NUMBER) RETURN VARCHAR2;





  PROCEDURE SIACRECSU_ACT_FLAGPRIORIZA(P_COD_SOLOT in NUMBER,
  P_FLG_PRIORIZ IN operacion.parametro_vta_pvta_adc.pvad_flag_prio%type, --  17.0
  P_FLG_SOLCLI IN  operacion.parametro_vta_pvta_adc.pvpac_flag_sol_cli%type, --  17.0
  P_CODIGO_RESPUESTA OUT NUMBER,
  P_MENSAJE_RESPUESTA OUT VARCHAR2);

  PROCEDURE SGASS_VALIDA_ESTADO(P_IDAGENDA            IN NUMBER,
                  P_ESTADO              OUT VARCHAR2,
                  P_CODIGO_RESPUESTA    OUT NUMBER,
                  P_MENSAJE_RESPUESTA   OUT VARCHAR2);

  PROCEDURE SGASS_VALIDA_SUBTIPO(P_SUBTIPO_TRAB        IN VARCHAR2,
                P_CODIGO_RESPUESTA         OUT NUMBER,
                P_MENSAJE_RESPUESTA        OUT VARCHAR2);

  PROCEDURE SGASS_VALIDA_DATOS(P_IDAGENDA            IN NUMBER,
                P_CUR_SALIDA          OUT SYS_REFCURSOR,
                P_CODIGO_RESPUESTA    OUT NUMBER,
                P_MENSAJE_RESPUESTA   OUT VARCHAR2);


  --FIN FASE

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        21/02/2017  HITSS            SD_INC000000710996 Devuelve 1 si aplica TOA incidencia
  ******************************************************************************/
 FUNCTION f_obtiene_flag_toa(p_tiptra IN solot.tiptra%type,
                             p_codtype  IN incidence.codtypeservice%type)  RETURN NUMBER;


/******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0       21/02/2017  Katherine Morales  Devuelve estado franja
  ******************************************************************************/
  FUNCTION f_valida_hfranja(pcodigo in varchar2 )
  RETURN NUMBER;

 /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        10/03/2017  Jorge Rivas      Devuelve regla de la franja
  ******************************************************************************/
  FUNCTION f_regla_franja(p_tipmod IN varchar2,
                           p_tiptra IN solot.tiptra%type)
  RETURN VARCHAR2;

  /******************************************************************************
  Ver           Date          Author                   Descripcion
  ---------  ----------  ------------------ ----------------------------------------
  1.0        15/03/2017  Jorge Rivas        Retorna tipo de trabajo nueva sef
  ******************************************************************************/
  FUNCTION f_obtiene_tiptra_vta_nueva_sef(p_numslc sales.vtatabslcfac.numslc%type)
  RETURN NUMBER;

  /******************************************************************************
  Ver           Date          Author                   Descripcion
  ---------  ----------  ------------------ ----------------------------------------
  1.0        15/03/2017  Katherine Morales R         Retorna Cantidad Franjas
  ******************************************************************************/
  FUNCTION  f_obtiene_cant_franja
  RETURN NUMBER;
  /******************************************************************************
  Ver           Date          Author                   Descripcion
  ---------  ----------  ------------------ ----------------------------------------
  1.0        26/06/2017  Edwin Vasquez C        retorna tecnologia permitida relanzar agendamiento
  ******************************************************************************/
  FUNCTION SGAFUN_TECNO_PERMITIDA(pi_idagenda agendamiento.idagenda%TYPE)
  RETURN boolean;

  -- Ini 19.0
  function extrae_carac_spec(p_dato varchar2) return varchar2;
  -- Fin 19.0
  -- Ini 20.0
  /******************************************************************************
  Ver           Date          Author                   Descripcion
  ---------  ----------  ------------------ ----------------------------------------
  1.0        06/07/2017  Edwin Vasquez C        retorna la franja actual
  ******************************************************************************/
  FUNCTION sgafun_obt_franja_actual
     RETURN varchar2;
  -- Fin 20.0
  --Ini 21.0
  --------------------------------------------------------------------------------
  procedure valida_medcom_toa(p_codincidence incidence.codincidence%type,
                              p_resultado    out number,
                              p_mensaje      out varchar2);
  --Fin 21.0
  --INI PROY-31513 TOA
  PROCEDURE SGASS_OBT_PARAMETROS (pi_idparametro number,
                                po_dato        out sys_refcursor,
                                  po_cod_error   out number,
                                  po_des_error   out varchar2);

  PROCEDURE SGASS_LISTA_vta_pvta_adc(an_codsolot    IN operacion.solot.codsolot%TYPE,
                                     po_dato        out sys_refcursor,
                                     po_cod_error   out number,
                                     po_des_error   out varchar2);

  PROCEDURE SGASS_SUBTIPO_TRABAJO (vIdtiptra      NUMBER,
                                 po_dato        out sys_refcursor,
                                   po_cod_error   out number,
                                   po_des_error   out varchar2);

  PROCEDURE SGASS_SUBTIPO_ORDEN (ln_cod_id        OPERACION.SOLOT.COD_ID%TYPE,
                                 LN_TIPTRA        OPERACION.TIPTRABAJO.TIPTRA%TYPE,
                                 LV_SUBTIPO_ORDEN  out varchar2,
                                 po_cod_error      out number,
                                 po_des_error      out varchar2);

  PROCEDURE SGASU_ACTUALIZA_CAMPOS   (ln_idpoblado      number,
                                      LN_IDZONA         OPERACION.ZONA_ADC.IDZONA%TYPE,
                                      LN_COBERTURA      NUMBER,
                                      LN_COBERTURA_LTE  NUMBER,
                                      LN_FLAG_ADC       NUMBER,
                                      po_cod_error      out number,
                                      po_des_error      out varchar2) ;
  -- FIN PROY-31513
 PROCEDURE SGASU_parm_vta_pvta_adc( inCODSOLOT      OPERACION.SOLOT.CODSOLOT%TYPE,
                                    inPLANO         in varchar2,
                                    inIDPOBLADO     in varchar2,
                                    inSUBTIPO_ORDEN in varchar2,
                                    inFECHA_PROGRA  in date,
                                    inFRANJA        in varchar2,
                                    inIDBUCKET      in varchar2,
                                    ouCOD_ERR       out varchar2,
                                    ouMSG_ERR       out varchar2);
  --Inicio 23.0
  function SGAFUN_VALIDA_CONFIG_PUERTO(K_CODIGO_SAP in operacion.inventario_env_adc.codigo_sap%type)
    return number;

  function SGAFUN_OBTIENE_VALOR_CAMPO(K_DESCRIPCION       in varchar2,
                                      K_NUMERO_ERROR      out number,
                                      K_DESCRIPCION_ERROR out varchar2)
    return number;

  function SGAFUN_OBTIENE_FLAG_VIP_ORD(K_COD_SUBTIPO_ORDEN operacion.subtipo_orden_adc.cod_subtipo_orden%type,
                                       K_NUMERO_ERROR      out number,
                                       K_DESCRIPCION_ERROR out varchar2)
    return number;

  function SGAFUN_OBTIENE_ZONA_COMPLEJA(K_CODZONA           operacion.zona_adc.codzona%type,
                                        K_NUMERO_ERROR      out number,
                                        K_DESCRIPCION_ERROR out varchar2)
    return number;

  procedure SGASS_LISTA_SERV_CONTACTOS(K_CODIGO_CLIENTE in agendamiento.codcli%type,
                                       K_TRAMA          out clob);

  procedure SGASS_TRAMA_INVENTARIO_DEL_ALL(k_id_proceso    in number,
                                           k_fecha         in operacion.inventario_env_adc.fecha_inventario%type,
                                           k_flg_tipo      in operacion.inventario_env_adc.flg_tipo%type,
                                           k_contrata      in operacion.inventario_env_adc.usureg%type,
                                           k_accion        in varchar2,
                                           k_iderror       out numeric,
                                           k_mensaje_error out varchar2);
  --Fin 23.0

  --Inicio 24.0
  procedure SP_VALIDA_EXISTE_SOT(IDORDER      in AGENLIQ.SGAT_AGENDA.AGENN_IDPEDIDO%type,
                                 CODRESPUESTA out number,
                                 DESCRIPCION  out varchar2);
  --Fin 24.0
  --Ini 25.0
  FUNCTION GET_PARAM_C(P_ABREV1 VARCHAR2, P_ABREV2 VARCHAR2) RETURN VARCHAR2;
  FUNCTION GET_PARAM_N(P_ABREV1 VARCHAR2, P_ABREV2 VARCHAR2) RETURN NUMBER;
  --Fin 25.0
END;
/

