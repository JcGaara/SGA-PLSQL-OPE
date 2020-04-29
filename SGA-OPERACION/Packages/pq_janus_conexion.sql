CREATE OR REPLACE PACKAGE OPERACION.pq_janus_conexion IS
  /******************************************************************************
   PROPOSITO:
  
   REVISIONES:
     Version  Fecha       Autor            Solicitado por      Descripcion
     -------  -----       -----            --------------      -----------
     1.0      26/02/2014  Mauro Zegarra    Christian Riquelme  version inicial
     2.0      29/05/2014  Mauro Zegarra    Christian Riquelme  Mejoras
     3.0      18/05/2014  Eustaquio Gibaja Christian Riquelme  Mejoras
  /* ***************************************************************************/
  g_codigo  VARCHAR2(3);
  --ini 3.0
  --g_mensaje VARCHAR2(30);
  g_mensaje operacion.int_telefonia_log.ws_error_dsc%TYPE;
  --fin 3.0
  PROCEDURE enviar_solicitud;

  FUNCTION get_metodo RETURN VARCHAR2;

  FUNCTION get_url RETURN opedd.descripcion%TYPE;

--ini 2.0
  FUNCTION get_url_metodo RETURN opedd.descripcion%TYPE;
--fin 2.0
  PROCEDURE enviar_x_ws;

  PROCEDURE enviar_x_dblink;

  PROCEDURE update_int_telefonia_log;

  FUNCTION armar_xml RETURN VARCHAR2;

  FUNCTION call_webservice(p_xml VARCHAR2, p_url VARCHAR2) RETURN VARCHAR2;

  PROCEDURE guardar_error_cx(p_error VARCHAR2);

  PROCEDURE get_rpta_ws(p_xml VARCHAR2);

  PROCEDURE guardar_error_rpta;

  FUNCTION get_atributo(p_xml IN VARCHAR2, p_atributo VARCHAR2) RETURN VARCHAR2;

END;
/
