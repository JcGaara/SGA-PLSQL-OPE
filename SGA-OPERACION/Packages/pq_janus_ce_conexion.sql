CREATE OR REPLACE PACKAGE OPERACION.PQ_JANUS_CE_CONEXION IS
  /******************************************************************************
   PROPOSITO:
  
   REVISIONES:
     Version  Fecha       Autor            Solicitado por      Descripcion
     -------  -----       -----            --------------      -----------
     1.0      2014-06-26  Eustaquio Gibaja Christian Riquelme  version inicial
     2.0      2014-10-22  Edwin Vasquez     Christian Riquelme  Claro Empresas WiMAX
  /* ***************************************************************************/
  /*g_codigo  VARCHAR2(3);
  g_mensaje operacion.int_telefonia_log.ws_error_dsc%TYPE;*/

  type t_response is record(
    codigo  telefonia_ce_det.id_ws_error%type,
    mensaje telefonia_ce_det.ws_error_dsc%type);

  PROCEDURE enviar_solicitud(p_idtrans             int_plataforma_bscs.idtrans%type,
                             p_id_telefonia_ce_det telefonia_ce_det.id_telefonia_ce_det%type);

  FUNCTION get_metodo(p_action telefonia_ce_det.action_id%type) RETURN VARCHAR2;

  FUNCTION get_url RETURN opedd.descripcion%TYPE;

  FUNCTION get_url_metodo RETURN opedd.descripcion%TYPE;

  PROCEDURE enviar_x_mock(p_idtrans             int_plataforma_bscs.idtrans%type,
                          p_id_telefonia_ce_det telefonia_ce_det.id_telefonia_ce_det%type);

  PROCEDURE enviar_x_ws(p_idtrans             int_plataforma_bscs.idtrans%type,
                        p_id_telefonia_ce_det telefonia_ce_det.id_telefonia_ce_det%type);

  PROCEDURE update_telefonia_ce_det(p_id_telefonia_ce_det telefonia_ce_det.id_telefonia_ce_det%type,
                                    p_response            t_response);

  FUNCTION armar_xml(p_idtrans int_plataforma_bscs.idtrans%type) RETURN VARCHAR2;

  function armar_xml_rpta(p_idtrans int_plataforma_bscs.idtrans%type)
    return varchar2;

  FUNCTION call_webservice(p_id_telefonia_ce_det telefonia_ce_det.id_telefonia_ce_det%type,
                           p_xml                 varchar2,
                           p_url                 varchar2) RETURN VARCHAR2;

  PROCEDURE guardar_error_cx(p_id_telefonia_ce_det telefonia_ce_det.id_telefonia_ce_det%type,
                             p_error               varchar2);

  PROCEDURE get_rpta_ws(p_xml VARCHAR2);

  function get_rpta_ws(p_id_telefonia_ce_det telefonia_ce_det.id_telefonia_ce_det%type,
                       p_xml                 varchar2) return t_response;

  PROCEDURE guardar_error_rpta(p_id_telefonia_ce_det telefonia_ce_det.id_telefonia_ce_det%type,
                               p_codigo              telefonia_ce_det.id_ws_error%type,
                               p_mensaje             telefonia_ce_det.ws_error_dsc%type);

  FUNCTION get_atributo(p_xml IN VARCHAR2, p_atributo VARCHAR2) RETURN VARCHAR2;

  PROCEDURE inicializar;

END;
/