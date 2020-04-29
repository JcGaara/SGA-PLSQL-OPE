CREATE OR REPLACE PACKAGE OPERACION.pq_janus_comunicacion IS
  /****************************************************************************************************
     NAME:       PQ_JANUS_COMUNICACION
     PURPOSE:    Envía trama de datos a plataforma JANUS
  
     REVISIONS:
     Ver  Date        Author            Solicitado por      Description
     ---  ----------  ---------------   --------------      ----------------------------
     1.0  20/02/2014  Eustaquio Gibaja  Christian Riquelme  Envía trama de datos a plataforma JANUS
     2.0  30/02/2014  Eustaquio Gibaja  Christian Riquelme  Mejoras envío de trama
     3.0  21/07/2014  Eustaquio Gibaja  Christian Riquelme  Guardar xml de envío a BSCS
  ***************************************************************************************************/

  g_idtrans   operacion.int_plataforma_bscs.idtrans%TYPE;
  g_action_id operacion.int_plataforma_bscs.action_id%TYPE;
  g_trama     operacion.int_plataforma_bscs.trama%TYPE;
  g_codigo    VARCHAR2(3);
  g_mensaje   VARCHAR2(30);

  TYPE respuesta IS RECORD(
    codigo  VARCHAR2(3),
    mensaje VARCHAR2(30));

  PROCEDURE enviar_solicitud(p_idtrans   operacion.int_plataforma_bscs.idtrans%TYPE,
                             p_action_id operacion.int_plataforma_bscs.action_id%TYPE,
                             p_trama     operacion.int_plataforma_bscs.trama%TYPE);

  FUNCTION get_metodo RETURN VARCHAR2;

  PROCEDURE enviar_x_ws;

  PROCEDURE enviar_x_dblink;

  FUNCTION armar_xml RETURN VARCHAR2;

  FUNCTION call_webservice(p_xml VARCHAR2, p_url VARCHAR2) RETURN VARCHAR2;

  PROCEDURE update_int_telefonia_log(p_idtrans operacion.int_plataforma_bscs.idtrans%TYPE);

  FUNCTION get_id_log(p_idtrans operacion.int_plataforma_bscs.idtrans%TYPE)
    RETURN operacion.int_telefonia_log.id%TYPE;

  FUNCTION get_atributo(p_xml VARCHAR2, p_atributo VARCHAR2) RETURN VARCHAR2;

  PROCEDURE set_rpta(p_xml VARCHAR2);
END;
/