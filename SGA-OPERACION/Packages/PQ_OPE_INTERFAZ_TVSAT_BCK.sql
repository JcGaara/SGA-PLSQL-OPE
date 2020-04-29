CREATE OR REPLACE PACKAGE OPERACION.pq_ope_interfaz_tvsat_bck is
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
                                       an_tipreg in number);
-- fin 7.0
  procedure p_job_reenvio_archivo_conax;

  procedure p_job_recibe_respuesta_conax;

  procedure p_job_verifica_solicitud;

  procedure p_job_revision_lotes;

end pq_ope_interfaz_tvsat_bck;
/


