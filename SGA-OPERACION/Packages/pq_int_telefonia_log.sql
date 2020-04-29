CREATE OR REPLACE PACKAGE OPERACION.pq_int_telefonia_log IS
  /******************************************************************************
   PROPOSITO:
  
   REVISIONES:
     Version  Fecha       Autor          Solicitado por      Descripcion
     -------  -----       -----          --------------      -----------
     1.0      26/02/2014  Mauro Zegarra  Christian Riquelme  version inicial
  /* ***************************************************************************/
  g_id operacion.int_telefonia_log.id%TYPE;

  PROCEDURE logger(p_msg VARCHAR2);

  FUNCTION formart_msg(p_msg VARCHAR2) RETURN VARCHAR2;

  PROCEDURE set_msg(p_msg VARCHAR2);

  PROCEDURE con_error;

  FUNCTION get_id RETURN operacion.int_telefonia_log.id%TYPE;
END;
/
