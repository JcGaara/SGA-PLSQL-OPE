create or replace package operacion.pq_ope_interfaz_tvsat is
  /************************************************************
  NOMBRE:     PQ_OPE_INTERFAZ_TVSAT
  PROPOSITO:  Manejo de Procedimientos y Funciones usados en
              la interfaz CONAX para Servicios Inalámbricos.

  PROGRAMADO EN JOB:  NO

  REVISIONES:
  Versión  Fecha       Autor              Solicitado por  Descripción
  -------  ----------  -----------------  --------------  -------------------------------
  1.0      01/06/2010  Mariela Aguirre    Proyecto Perú   Creación.
                                                          CORTES Y RECONEXIONES SERVICIOS
                                                          INALAMBRICOS (DTH, CDMA y GSM)
  2.0      17/08/2010  Mariela Aguirre    Proyecto Perú   Ajustes Post-implementacion Proyecto.
  3.0      13/09/2010  Mariela Aguirre                    Req. # 142041
  4.0      21/09/2010  Joseph Asencios    REQ-MIGRACION-DTH: Homologación de DTH con las nuevas estructuras de bundle.
                                                             Se modificó: p_actualiza_datos_solicitud,p_act_instancias
  5.0      28/09/2010  Mariela Aguirre    Jose Ramos      Ajustes Req. # 142041
  6.0      12/11/2010  Antonio Lagos      Jose Ramos      REQ.147952, actualizacion de estado en reginsdth_web
  7.0      23/02/2011  Alex Alamo         Edilberto       modificacion de argumento del Job de Suspension y Reconexion DTH
  8.0      28/03/2011  Antonio Lagos      Edilberto       REQ 153934: mejoras en Suspension y Reconexion DTH
  9.0      14/04/2011  Antonio Lagos      Jose Ramos      Evitar duplicidad de serie dentro de un archivo.
  10.0     13/04/2011  Luis Patiño                        PROY Suma de cargos
  11.0     10/06/2011  Widmer Quispe      Jose ramos      Se comenta funcionalidad
  12.0     22/02/2013  Juan Ortiz         Hector Huaman   Req.163947: Diferenciar archivos de señal DTH (SGA)
  13.0     10/04/2013  Hector Huaman                      SD_551325 Mejora en el PPV
  14.0     30/04/2013  Edilberto Astulle                  PQT-151518-TSK-26743
  15.0     12/11/2013  Edson Caqui        Manuel Gallegos IDEA-13749 Automatizar proceso Reconexion, Suspension y Cortes - DTH                                                                  Facturable
  16.0     01/12/2014  Jorge Armas        Manuel Gallegos PROY-17565-  Aprovisionamiento DTH Prepago - INTRAWAY
  17.0     06/07/2015  Luis Flores Osorio                 SD-417723
  18.0     17/11/2016  Justiniano Condori Mauro Zegarra   PROY-20152 Proyecto LTE - 3Play inalámbrico-Servicios Adicionales TV
  19.0     06/04/2017  Justiniano Condori Fanny Najarro   STR.SOL.PROY-20152.SGA_1
  20.0     05/10/2017  Jose Arriola       Carlos Lazarte  PROY-299955 - Alineacion CONTEGO Fase II
  ***********************************************************/

  fnd_estado_pend_ejecucion constant number(2) := 1;
  fnd_estado_lotizado       constant number(2) := 2;
  fnd_estado_conf_ok        constant number(2) := 3;
  fnd_estado_conf_err       constant number(2) := 4;
  fnd_estado_relotizar      constant number(2) := 7;

  function f_obt_parametro(ac_parametro ope_parametros_globales_aux.nombre_parametro%type)
    return varchar2;

  function f_obt_valor_linea_archivo(ac_ruta    in varchar2,
                                     ac_archivo in varchar2,
                                     an_linea   in number) return varchar2;

  procedure p_actualiza_datos_solicitud(an_idsol   in ope_tvsat_sltd_cab.idsol%type,
                                        an_estado  in ope_tvsat_sltd_cab.estado%type default null,
                                        ac_mensaje in varchar2 default null,
                                        ac_error   in out varchar2,
                                        --ini 8.0
                                        an_act_tarea in number default 1);
  --fin 8.0

  procedure p_actualiza_detalle_lote(an_idsol in ope_tvsat_sltd_cab.idsol%type,
                                     ac_error in out varchar2);

  procedure p_act_instancias_asociadas(an_idsol in ope_tvsat_sltd_cab.idsol%type,
                                       ac_error in out varchar2);

  procedure p_genera_archivo_conax(an_tipo      in number,
                                   an_idlote    in ope_tvsat_lote_sltd_aux.idlote%type,
                                   ac_bouquet   in ope_tvsat_archivo_cab.bouquet%type,
                                   ac_resultado in out varchar2,
                                   ac_mensaje   in out varchar2);

  procedure p_envio_archivo_conax(an_idlote    in ope_tvsat_lote_sltd_aux.idlote%type,
                                  ac_bouquet   in ope_tvsat_archivo_cab.bouquet%type,
                                  ac_resultado in out varchar2,
                                  ac_mensaje   in out varchar2);

  procedure p_envio_archivo(an_tipo      in number,
                            an_idlote    in ope_tvsat_lote_sltd_aux.idlote%type,
                            ac_bouquet   in ope_tvsat_archivo_cab.bouquet%type,
                            ac_resultado in out varchar2,
                            ac_mensaje   in out varchar2);

  procedure p_genera_archivo_lote(an_tipo      in number,
                                  an_idlote    in ope_tvsat_lote_sltd_aux.idlote%type,
                                  ac_resultado in out varchar2,
                                  ac_mensaje   in out varchar2);

  procedure p_envio_archivo_lote(an_idlote    in ope_tvsat_lote_sltd_aux.idlote%type,
                                 ac_resultado in out varchar2,
                                 ac_mensaje   in out varchar2);

  procedure p_reenvio_lote(an_idlote    in ope_tvsat_lote_sltd_aux.idlote%type,
                           ac_resultado in out varchar2,
                           ac_mensaje   in out varchar2);

  procedure p_lee_error_archivo_conax(ac_ruta          in varchar2,
                                      ac_nombre        in varchar2,
                                      ac_archivo_error in varchar2,
                                      ac_resultado     in out varchar2,
                                      ac_mensaje       in out varchar2);

  procedure p_separa_lote(an_tipo      number,
                          an_idlote    in ope_tvsat_lote_sltd_aux.idlote%type,
                          an_idlotenew in out ope_tvsat_lote_sltd_aux.idlote%type);

  procedure p_job_envia_solicitud_conax;

  procedure p_job_verifica_respuesta_conax;
  -- ini 7.0
  procedure p_job_genera_archivo_conax(ac_tiposolicitud ope_tvsat_sltd_cab.tiposolicitud%type,
                                       an_tipreg        in number);
  -- fin 7.0
  procedure p_job_reenvio_archivo_conax;

  procedure p_job_recibe_respuesta_conax;

  procedure p_job_verifica_solicitud;

  procedure p_job_revision_lotes;
  --Ini 12.0
  function f_genera_nombre_archivo(tipoplan in number, tipoestado varchar2)
    return varchar2;

  procedure p_reset_seq(p_seq_name in varchar2);
  --Fin 12.0
  -- Ini 15.0
  procedure p_genera_archivo_conax_fac(an_tipo      in number,
                                       an_idlote    in ope_tvsat_lote_sltd_aux.idlote%type,
                                       ac_bouquet   in ope_tvsat_archivo_cab.bouquet%type,
                                       ac_resultado in out varchar2,
                                       ac_mensaje   in out varchar2);
  -- Fin 15.0

  -- ini 17.0
  procedure p_job_gen_archivo_conax_post(ac_tiposolicitud ope_tvsat_sltd_cab.tiposolicitud%type);

  
  procedure p_actualiza_datos_sol_postpago(an_idsol   in ope_tvsat_sltd_cab.idsol%type,
                                           an_estado  in ope_tvsat_sltd_cab.estado%type default null,
                                           ac_mensaje in varchar2 default null,
                                           ac_error   in out varchar2);
  -- fin 17.0

end pq_ope_interfaz_tvsat;
/