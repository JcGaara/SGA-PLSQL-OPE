CREATE OR REPLACE PACKAGE OPERACION.PQ_SERV_VALOR_AGREGADO IS

/************************************************************
NOMBRE:     P_GENERA_REGINSRPROF24H
PROPOSITO:  Manejo de los procedimientos de los servicios de valor agregado.
PROGRAMADO EN JOB:  NO

REVISIONES:
Version      Fecha        Autor           Descripcisn
---------  ----------  ---------------  ------------------------
1.0        12/08/2009  Hector Huaman 99917 se rehace el paquete
2.0        17/04/2015  César Quispe      Hector Huaman     REQ-165004 Creación de Interface de compra de servicios SVA
3.0        06/07/2015  Edwin Vasquez     Hector Huaman     INC-IDEA-12991-Creacion Interface de compra servicios SVA a través de la Fija
4.0        10/07/2015  Michael Boza      Hector Huaman     INC-IDEA-12991-Creacion Interface de compra servicios SVA a través de la Fija
***********************************************************/
  --CONSTANTES
  cv_aplicacion          constant operacion.ope_trx_clarovideo_sva.aplicacion%type := 'SGA';
  cv_usuario             constant operacion.ope_trx_clarovideo_sva.usraplicacion%type := user;
  cv_tipope_trasexterno  constant operacion.ope_trx_clarovideo_sva.tipo_operacion%type := 'TE';
  cv_tipope_cambioplan   constant operacion.ope_trx_clarovideo_sva.tipo_operacion%type := 'CP';
  cv_tipope_baja         constant operacion.ope_trx_clarovideo_sva.tipo_operacion%type := 'BA';
  cv_criterio_baja       constant operacion.ope_trx_clarovideo_sva.criterio%type := 'SID';
  cv_criterio_reasigna   constant operacion.ope_trx_clarovideo_sva.criterio%type := 'SID';
  cn_trx_registrado      constant number := 0;
  cn_trx_procesado_ok    constant number := 1;
  cn_trx_procesado_error constant number := 2;

function f_encode(parametro varchar2) return varchar2;

function f_linkea(link varchar2) return varchar2;


procedure p_genera_reginsprof24h;

procedure p_prof24h_baja(a_idtareawf in number,
                          a_idwf      in number,
                          a_tarea     in number,
                          a_tareadef  in number);

procedure p_baja_srvprofesor24h(a_idtareawf in number,
                                a_idwf      in number,
                                a_tarea     in number,
                                a_tareadef  in number);

  procedure p_genera_traslado_externo_sva(a_idtareawf in number,
                                          a_idwf      in number,
                                          a_tarea     in number,
                                          a_tareadef  in number);

  procedure p_genera_cambio_plan_sva(a_idtareawf in number,
                                     a_idwf      in number,
                                     a_tarea     in number,
                                     a_tareadef  in number);

  procedure p_genera_baja_sva(a_idtareawf in number,
                              a_idwf      in number,
                              a_tarea     in number,
                              a_tareadef  in number);

  procedure p_revierte_envio_sva(an_codsolot in number);

  procedure p_genera_trx_envio_sva(av_codcli         in varchar2,
                                   av_tipo_operacion in varchar2,
                                   av_criterio       in varchar2,
                                   av_numslc_inicial in varchar2,
                                   av_numslc_final   in varchar2,
                                   an_codsolot       in number,
                                   an_sid_inicial    number,
                                   an_sid_final      number,
                                   an_resultado      out number,
                                   av_mensaje        out varchar2);

  procedure p_registra_trx_envio_sva(ar_ope_clarovideo_sva in operacion.ope_trx_clarovideo_sva%rowtype,
                                     an_resultado          out number,
                                     av_mensaje            out varchar2);

  procedure p_registra_trx_resp_sva(ar_ope_clarovideo_sva in operacion.ope_trx_clarovideo_sva%rowtype,
                                    an_resultado          out number,
                                    av_mensaje            out varchar2);

  procedure p_ejecuta_trx_ws_sva(ar_ope_clarovideo_sva in out operacion.ope_trx_clarovideo_sva%rowtype,
                                 an_resultado          out number,
                                 av_mensaje            out varchar2);

  procedure p_aplica_trx_ws_sva(an_resultado out number,
                                av_mensaje   out varchar2);

  function f_arma_xml(ar_ope_clarovideo_sva in operacion.ope_trx_clarovideo_sva%rowtype)
    return varchar2;

  function f_ejecuta_webservice(av_xml in varchar2, av_url in varchar2)
    return varchar2;

  function f_obtiene_atributo(av_xml in varchar2, av_atributo in varchar2)
    return varchar2;

  function f_obtiene_idregistro return number;

  function f_obtiene_max_reintento return varchar2;

  function f_obtiene_sidxproyecto_te(av_numslc in varchar2) return number;

  function f_obtiene_sidxproyecto_cp(av_numslc in varchar2) return number;

  function f_valida_trx_pendiente(an_codsolot   in number,
                                  an_idregistro in number) return number;

  function f_valida_registrado_sva(an_codsolot in number) return number;

  procedure devuelve_respuesta_error(p_resultado     out number,
                                     p_mensaje       out varchar2,
                                     p_detalle_error out clob);


END PQ_SERV_VALOR_AGREGADO;
/