CREATE OR REPLACE PACKAGE OPERACION.PQ_AGENDAMIENTO is
  /***********************************************************************************************
    NOMBRE:     OPERACION.Pq_Agendamiento
    PROPOSITO:  Realizar toda la funcionalidad de Agendamiento Peru
    PROGRAMADO EN JOB:  NO
  
    REVISIONES:
    Version      Fecha        Autor             Solicitado Por        Descripcion
    ---------  ----------  -----------------    --------------        ------------------------
    1.0        08/03/2010  Marcos Echevarria    Edilberto Astulle     REQ-107706: Se crea el paquete agendamiento
    2.0        25/05/2010  Marcos Echevarria    Edilberto Astulle     REQ-130663: Se inserta codsuc y codcase en agendamiento, optimizacion de interface incidencia, creacion
                                                                      de nuevo procedimiento asigan contrata Telmex
    3.0        22/06/2010  Antonio Lagos        Juan Gallegos         REQ-119999: Bundle, carga masiva de agenda
    4.0        30/07/2010  Mariela Aguirre      Rolando Martinez      REQ-135892: Asignacion de contrata y Tipo Trabajo en DISTRITOXCONTRATA
    5.0        05/10/2010  Esdon Caqui          Marco de la Cruz      Req.144627. Considerar prioridad en contrata para distrito y tipo de trabajo.
    6.0        08/11/2010  Alexander Yong       Marco de la Cruz      REQ-148249: Error en el flujo de la atencion de  incidencias
    7.0        21/12/2010  Antonio Lagos        Edilberto Astulle     REQ-134845: Se agrega campo area a la agenda
    8.0        04/02/2011  Alexander Yong       Zulma Quispe          REQ-148648: Requerimiento para Instalar mas de 01 linea telefonica por equipo eMTA
    9.0        28/04/2011  Alexander Yong       Zulma Quispe          REQ-159020: Adecuaciones al Nuevo WF de Instalaciones
   10.0       05/05/2011  Antonio Lagos        Zulma Quispe          REQ-159162: puerta a puerta TN
    11.0       06/05/2011  Antonio Lagos        Zulma Quispe          REQ-140967: cancelar agenda al cancelar y volver a asignar el workflow
    12.0       01/07/2011  Tommy Arakaki        Edilberto Astulle     REQ 159541 - Mejoras en el Modulo de Agendamiento de HFC
    13.0       11/08/2011  Alexander Yong       Edilberto Astulle     REQ-160185: SOTs Baja 3Play
    14.0       21/06/2011  Alfonso Perez        Elver Ramirez         REQ-159092: PS Tablero de Control
    15.0       12/01/2012  Edilberto Astulle    Edilberto Astulle     PROY-1332 Motivos de SOT por Tipo de Trabajo
    16.0       23/02/2012  Edilberto Astulle    Edilberto Astulle     PROY-1875 Mejorar el proceso de Bajas HFC a nivel de Intraway
    17.0       23/03/2012  Edilberto Astulle    Edilberto Astulle     PROY-2769_Generacion de Nuevo grupo de corte CE en HFC
    18.0       09/04/2012  Edilberto Astulle    Edilberto Astulle     PROY-2787_Modificacion modulo de control de tareas SGA Operaciones
    19.0       29/04/2012  Edilberto Astulle    Edilberto Astulle     PROY-1483_Agendamiento para Mantenimiento e Instalaciones de proveedores
    20.0       31/05/2012  Alex Alamo           Hector Huaman         PROY-0642- DTH Postpago
    21.0       31/05/2012  Edilberto Astulle                          IDEA-4694  Gestion Instalacion/PostVenta IM DTH
    22.0       30/06/2012  Edilberto Astulle                          PQT-121129-TSK-10791
    23.0       30/06/2012  Edilberto Astulle                          PROY-2307_Cambio IW DTA Adicional
    24.0       20/07/2012  Edilberto Astulle                          PROY-4191_Cambio Work Flow CE HFC
    25.0       26/07/2012  Edilberto Astulle                          PROY-4316 Banda Ancha Movil
    26.0       30/07/2012  Edilberto Astulle                          PROY_3433_AgendamientoenLineaOperaciones
    27.0       30/09/2012  Edilberto Astulle                          PROY-4854_Modificacion de work flow de Wimax y HFC Claro Empresas
    28.0       30/09/2012  Alex Alamo                                 PROY-4886_IDEA-6033 Requerimiento programacion de instalaciones DTH, solicitud Osiptel
    29.0       05/10/2012  Hector Huaman                              SD-257329 Requerimiento programacion de instalaciones DTH, solicitud Osiptel
    30.0       10/10/2012  Edilberto Astulle                          PROY-4856_Atencion de generacion Cuentas en RTellin para CE en HFC
    31.0       20/10/2012  Edilberto Astulle                          PROY-3968_Optimizacion de Interface Intraway - SGA para la carga de equipos
    32.0       30/10/2012  Edilberto Astulle                          PROY-5513_HFC - Funcionalidad de Bajas de Servicio 3play
    33.0       20/12/2012  Edilberto Astulle                          SD-381939
    34.0       30/12/2012  Edilberto Astulle                          SD_363631
    35.0       23/02/2013  Edilberto Astulle     PQT-143459-TSK-22535
    36.0       03/04/2013  Edilberto Astulle     PQT-136449-TSK-18852
    37.0       23/05/2013  Edilberto Astulle     PQT-155613-TSK-28885
    38.0       02/0/2013   Edilberto Astulle     PROY-9381 IDEA-11686  Seleccion Multiple
    39.0       22/08/2013  Mauro Zegarra         Guillermo Salcedo     REQ-164606: Error al generar sot de instalacion de deco adicional
    40.0       22/09/2013  Edilberto Astulle     PROY-7101 Implementar Mejoras Cambio de Plan HFC
    41.0       25/09/2013  Edilberto Astulle     PROY-4429 - Evaluacion y venta unificada - Facturacion centralizada Operaciones
    43.0       14/03/2014  Edilberto Astulle     SD-973402
    44.0       04/03/2014  Edilberto Astulle     SD_978729
    45.0       14/04/2014  Edilberto Astulle     PQT-186237-TSK-44916
    46.0       02/06/2014  Edilberto Astulle     SD_1126603
    47.0       31/07/2014  Edilberto Astulle     SD-1172651 - equipos baja sin equipos
    48.0       06/08/2014  Edilberto Astulle     SD_ 7956
    49.0       06/11/2014  Edilberto Astulle     SD_120302 Problemas en actualizacion masiva Agenda workflow SGA - Sot de baja HFC
    50.0       23/01/2015  Hector Huaman         SD_199141
    51.0       16/02/2015  Edilberto Astulle     SD-231042
    52.0       14/05/2015  Edilberto Astulle     SD-298764
    53.0       24/05/2015  Edilberto Astulle     SD-307352 Problema con el SGA
    54.0       01/10/2015  Jose Varillas         Giovanni Vasquez        SD_426907
    55.0       10/09/2015  Angel Condori         Eustaquio Gibaja     Proyecto 3Play Inalambrico
    56.0       28/11/2015  Angel Condori         Eustaquio Gibaja     PQT-246986-TSK-76624
    57.0       15/12/2015  Dorian Sucasaca       PQT-247649-TSK-76965
    58.0       10/06/2015  Jorge Rivas/Angel Condori                  PROY-17652 Adm Manejo de Cuadrillas
    59.0       24/02/2016  Edilberto Astulle
    60.0       28/04/2016                                             SD-642508-1 Cambio de Plan Fase II
    61.0       06/02/2017  HITSS                 Mejoras Siac Reclamos
    64.0       10/04/2017  Edwin Vasquez         Lizbeth Portella     PROY-25148 IDEA-32224 - Mejoras en los SIACs para TOA y Reclamos
    65.0       06/06/2017  Juan Olivares         Henry Huamani        PROY-26477-IDEA-33647 Mejoras en SIACs Reclamos, generaci￿n y cierre autom￿tico de SOTs
    68.0       12/09/2017  Luigi Sipion          Nalda Arotico        PROY-40032-IDEA-40030 Adap. SGA Gestor de Agendamiento/Liquidaciones para integrar con FullStack
    72.0       02/04/2019  Cesar Najarro         Cesar Najarro        SD-INC000001471706 Mantender pod idprooducto de incognito para TE
  **********************************************************************************************/
  --Inicio 25.0
  TYPE type_agenda_hora is TABLE OF operacion.type_hora;
  TYPE type_table_calendario is TABLE OF operacion.type_calendario;
  TYPE type_table_calendario_ope is TABLE OF operacion.type_calendario_ope;
  --Fin 25.0

  --PROCEDURE P_crea_agendamiento(a_codsolot in number,a_fecha VARCHAR2,a_hora VARCHAR2, --3.0
  procedure p_crea_agendamiento(a_codsolot    in number,
                                a_codcon      in number,
                                a_instalador  in varchar2,
                                a_fecha       varchar2,
                                a_hora        varchar2, --3.0
                                a_observacion varchar2,
                                a_referencia  varchar2,
                                a_idtareawf   in number default null,
                                --ini 7.0
                                a_area in number default null,
                                --fin 7.0
                                a_idagenda in out number);

  procedure p_chg_est_agendamiento(a_idagenda       in number,
                                   a_estagenda      in number,
                                   a_estagenda_old  in number default null,
                                   a_observacion    in varchar2 default null,
                                   a_mot_solucion   in number default null,
                                   a_fecha          in date default sysdate,
                                   a_cadena_mots    in varchar2 default null,
                                   an_estado_adc    in number default null, --58.0
                                   av_ticket_remedy varchar2 default null); --68.0

  procedure p_ejecucion_agendamiento(a_idagenda     in number,
                                     a_estagenda    in number,
                                     a_tipo         in number,
                                     a_observacion  in varchar2,
                                     a_mot_solucion in number default null,
                                     a_fecha        in date default sysdate);

  procedure p_cancelar_agendamiento(a_idagenda     in number,
                                    a_estagenda    in number,
                                    a_tipo         in number,
                                    a_observacion  in varchar2,
                                    a_mot_solucion in number default null,
                                    a_fecha        in date default sysdate);

  procedure p_cerrar_agendamiento(a_idagenda     in number,
                                  a_estagenda    in number,
                                  a_tipo         in number,
                                  a_observacion  in varchar2,
                                  a_mot_solucion in number default null,
                                  a_fecha        in date default sysdate,
                                  a_cadena_mots  in varchar2 default null); --<12.0>

  procedure p_re_agendar(a_idagenda    in number,
                         a_fecha       varchar2,
                         a_hora        varchar2,
                         a_observacion varchar2,
                         a_idtareawf   in number default null);

  procedure p_genera_agenda(a_idtareawf in number,
                            a_idwf      in number,
                            a_tarea     in number,
                            a_tareadef  in number);

  procedure p_asigna_contrataxdistrito(a_idagenda in number,
                                       a_codsolot in number,
                                       o_mensaje  in out varchar2,
                                       o_error    in out number);

  procedure p_gen_agenda_sin_asignar(a_idtareawf in number,
                                     a_idwf      in number,
                                     a_tarea     in number,
                                     a_tareadef  in number);

  procedure p_interface_incidencia(a_idagenda     in number,
                                   a_estagenda    in number,
                                   a_tipo         in number,
                                   a_observacion  in varchar2,
                                   a_mot_solucion in number default null,
                                   a_fecha        in date default sysdate);
  --ini 2.0
  procedure p_asigna_contrata_telmex(a_idtareawf in number,
                                     a_idwf      in number,
                                     a_tarea     in number,
                                     a_tareadef  in number);
  --fin2.0
  --ini 3.0
  procedure p_carga_masiva_agenda(a_idcarga    number,
                                  an_cod_error in out number,
                                  av_des_error in out varchar2);
  function f_aplica_incidencia(an_idagenda agendamiento.idagenda%type)
    return number;

  --fin 3.0
  --4.0
  procedure p_actualiza_contrata(an_idagenda agendamiento.idagenda%type,
                                 an_codcon   agendamiento.codcon%type);
  --fin 4.0

  --Ini 8.0
  procedure p_asigna_contrataxplano(a_idtareawf in number,
                                    a_idwf      in number,
                                    a_tarea     in number,
                                    a_tareadef  in number);
  --Ini 9.0

  procedure p_gen_agenda_en_blanco(a_idtareawf in number,
                                   a_idwf      in number,
                                   a_tarea     in number,
                                   a_tareadef  in number);

  procedure p_crea_agenda_sin_fecha(a_codsolot    in number,
                                    a_codcon      in number,
                                    a_instalador  in varchar2,
                                    a_observacion varchar2,
                                    a_referencia  varchar2,
                                    a_idtareawf   in number default null,
                                    a_area        in number default null,
                                    a_idagenda    in out number);

  function f_es_puerta_puerta(a_codsolot in number) return number;

  --Fin 9.0
  --ini 11.0
  procedure p_cancela_agenda_wf_ant(a_codsolot solot.codsolot%type);
  --fin 11.0

  --Ini 12.0

  procedure p_asig_contrata(an_idagenda agendamiento.idagenda%type,
                            an_codcon   agendamiento.codcon%type,
                            av_obs      agendamientochgest.observacion%type);

  Procedure p_inserta_motivos(av_cadena_mot in varchar2,
                              an_idagenda   agendamiento.idagenda%type);
  --Fin 12.0

  --Ini 13.0
  procedure p_actualiza_fec_progra(an_idagenda  agendamiento.idagenda%type,
                                   ad_fecagenda agendamiento.fecagenda%type);

  --Fin 13.0

  --Ini 15.0
  procedure p_genera_agendamiento(a_idtareawf in number,
                                  a_idwf      in number,
                                  a_tarea     in number,
                                  a_tareadef  in number);

  procedure p_crea_agenda(a_codsolot      in number,
                          a_codcon        in number,
                          a_instalador    in varchar2,
                          a_feccompromiso date,
                          a_observacion   varchar2,
                          a_referencia    varchar2,
                          a_idtareawf     in number default null,
                          a_area          in number default null,
                          a_idagenda      in out number);
  --Fin 15.0
  procedure p_obt_datos_web_uni(an_idagenda  agendamiento.idagenda%type,
                                ad_fecagenda agendamiento.fecagenda%type);

  --Inicio 26.0
  function f_obt_horaxtiptrabajo(an_tiptra operacion.tiptrabajo.tiptra%type)
    return type_agenda_hora
    pipelined;

  procedure p_ins_horarioxcuadrillaanual(an_clave  operacion.ope_horaxcuadrilla_det.id_ope_cuadrillaxdistrito_det%type,
                                         an_tiptra tiptrabajo.tiptra%type,
                                         an_dia    operacion.ope_horaxcuadrilla_det.dia%type);

  procedure p_muestra_calendario(an_incidence   atccorp.incidence.codincidence%type,
                                 an_tiptra      tiptrabajo.tiptra%type,
                                 as_fechaagenda date default sysdate);

  function f_busca_agenda_disponible(as_codubi      inssrv.codubi%type,
                                     ad_fechaagenda date,
                                     as_hora        char,
                                     as_codcon      contrata.codcon%type)
    return number;

  function f_obt_calendario(an_incidence   atccorp.incidence.codincidence%type,
                            an_tiptra      tiptrabajo.tiptra%type,
                            as_fechaagenda date default sysdate)
    return type_table_calendario
    pipelined;

  procedure p_valida_hora_agenda(ad_fecha_compromiso in agendamiento.fecagenda%type,
                                 an_tiptra           in tiptrabajo.tiptra%type,
                                 an_color            in number,
                                 a_msg_error         out varchar2,
                                 a_coderror          out number);

  procedure p_valida_hora_agenda_ope(ad_fecha_compromiso in agendamiento.fecagenda%type,
                                     an_tiptra           in tiptrabajo.tiptra%type,
                                     an_color            in number,
                                     an_idagenda         in agendamiento.idagenda%type,
                                     a_msg_error         out varchar2,
                                     a_coderror          out number);
  function f_es_agendable(an_tiptra in tiptrabajo.tiptra%type) return number;

  procedure p_reagendamiento(an_idagenda     agendamiento.idagenda%type,
                             an_tiptrabajo   tiptrabajo.tiptra%type,
                             ad_fecreagenda  agendamiento.fecagenda%type,
                             as_observacion  agendamiento.observacion%type,
                             as_codcuadrilla operacion.ope_cuadrillaxdistrito_det.codcuadrilla%type,
                             a_msg_error     out varchar2,
                             a_coderror      out number);

  procedure p_cancelar_agenda(an_codincidence incidence.codincidence%type,
                              an_idagenda     agendamiento.idagenda%type,
                              an_tiptrabajo   tiptrabajo.tiptra%type,
                              as_observacion  agendamiento.observacion%type,
                              a_msg_error     out varchar2,
                              a_coderror      out number);

  procedure p_eliminar_configxtipotrabajo(an_tiptra tiptrabajo.tiptra%type);

  function f_busca_agenda_disponible_ope(as_codubi       inssrv.codubi%type,
                                         ad_fechaagenda  date,
                                         as_hora         char,
                                         as_codcon       contrata.codcon%type,
                                         as_codcuadrilla cuadrillaxcontrata.codcuadrilla%type)
    return number;

  function f_obt_calendario_ope(an_incidence    atccorp.incidence.codincidence%type,
                                an_tiptra       tiptrabajo.tiptra%type,
                                an_codcon       contrata.codcon%type,
                                as_codcuadrilla cuadrillaxcontrata.codcuadrilla%type,
                                as_codubi       vtatabdst.codubi%type,
                                as_fechaagenda  date default sysdate)
    return type_table_calendario_ope
    pipelined;

  procedure p_get_hora(an_incidence incidence.codincidence%type,
                       an_tiptra    tiptrabajo.tiptra%type,
                       ad_fecagenda agendamiento.fecagenda%type);

  function f_genera_horario(an_incidence atccorp.incidence.codincidence%type,
                            an_tiptra    tiptrabajo.tiptra%type,
                            ad_fecagenda agendamiento.fecagenda%type default sysdate)
    return type_table_calendario
    pipelined;

  procedure p_genera_horario_ope(an_tiptra       tiptrabajo.tiptra%type,
                                 an_codcon       contrata.codcon%type,
                                 as_codcuadrilla cuadrillaxcontrata.codcuadrilla%type,
                                 as_codubi       vtatabdst.codubi%type,
                                 ad_fecagenda    agendamiento.fecagenda%type default sysdate);

  function f_genera_horario_ope(an_tiptra       tiptrabajo.tiptra%type,
                                an_codcon       contrata.codcon%type,
                                as_codcuadrilla cuadrillaxcontrata.codcuadrilla%type,
                                as_codubi       vtatabdst.codubi%type,
                                ad_fecagenda    agendamiento.fecagenda%type default sysdate)
    return type_table_calendario_ope
    pipelined;
  --Fin 26.0
  --Inicio 27.0
  procedure p_obt_idagenda(an_codsolot solot.codsolot%type,
                           a_idagenda  out number);
  procedure P_CHG_GES_REC_IW(a_idtareawf in number,
                             a_idwf      in number,
                             a_tarea     in number,
                             a_tareadef  in number,
                             a_tipesttar in number,
                             a_esttarea  in number,
                             a_mottarchg in number,
                             a_fecini    in date,
                             a_fecfin    in date);

  --Fin 27.0

  -- Ini 55.0
  PROCEDURE p_gen_agenda_sin_asignar_lte(a_idtareawf in number,
                                         a_idwf      in number,
                                         a_tarea     in number,
                                         a_tareadef  in number);
  -- Fin 55.0

  --ini 61.0
  PROCEDURE SGASS_VALIDA_ESTADO(P_IDAGENDA          IN NUMBER,
                                P_ESTADO            OUT VARCHAR2,
                                P_CODIGO_RESPUESTA  OUT NUMBER,
                                P_MENSAJE_RESPUESTA OUT VARCHAR2);

  PROCEDURE SGASS_VALIDA_SUBTIPO(P_SUBTIPO_TRAB      IN VARCHAR2,
                                 P_CODIGO_RESPUESTA  OUT NUMBER,
                                 P_MENSAJE_RESPUESTA OUT VARCHAR2);

  PROCEDURE SGASS_VALIDA_DATOS(P_IDAGENDA          IN NUMBER,
                               P_CUR_SALIDA        OUT SYS_REFCURSOR,
                               P_CODIGO_RESPUESTA  OUT NUMBER,
                               P_MENSAJE_RESPUESTA OUT VARCHAR2);
  --fin 61.0

  -- Inicio 64.0
  -----------------------------------------------------------------------------------
  FUNCTION SGAFUN_OBT_OBS_REAGEN(p_observacion IN varchar2,
                                 p_fecha       IN date) RETURN VARCHAR2;
  -----------------------------------------------------------------------------------
  -- fin 64.0

  -- Inicio 65.0
  --------------------------------------------------------------------------------
  procedure SGASS_ACCION_CIERRE(pi_estado_ini number,
                                pi_estado_fin number,
                                po_accion     out varchar2,
                                po_cod_error  out number,
                                po_des_error  out varchar2);
  --------------------------------------------------------------------------------
  procedure SGASS_ACT_ESTDO_RECL(pi_idagenda       number,
                                 pi_usuario        varchar2,
                                 pi_estagenda_ini  number,
                                 pi_estagenda_fin  number,
                                 po_flag_insercion out varchar2,
                                 po_msg_text       out varchar2);
  --------------------------------------------------------------------------------
  -- Fin 65.0
  -- Inicio 72.0
  procedure SGASS_REGISTRA_DATOS_ORIGEN(ln_cod_id   number,
                                        ln_codsolot number);
  -- Fin 72.0
end pq_agendamiento;
/