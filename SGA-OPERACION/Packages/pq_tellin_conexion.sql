CREATE OR REPLACE PACKAGE OPERACION.pq_tellin_conexion IS
  /******************************************************************************
   PROPOSITO:

   REVISIONES:
     Version  Fecha       Autor          Solicitado por      Descripcion
     -------  -----       -----          --------------      -----------
     1.0      26/02/2014  Mauro Zegarra  Christian Riquelme  version inicial
  /* ***************************************************************************/
  g_mensaje VARCHAR2(30);

  PROCEDURE enviar_solicitud;

  FUNCTION get_metodo RETURN VARCHAR2;

  PROCEDURE enviar_x_ws;

  PROCEDURE update_int_telefonia_log;

  FUNCTION get_param RETURN VARCHAR2;

  FUNCTION get_idlote RETURN int_servicio_plataforma.idlote%TYPE;

END;
/