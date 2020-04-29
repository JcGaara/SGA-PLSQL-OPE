CREATE OR REPLACE PACKAGE OPERACION.pq_tellin IS
  /******************************************************************************
   PROPOSITO:
  
   REVISIONES:
     Version  Fecha       Autor          Solicitado por      Descripcion
     -------  -----       -----          --------------      -----------
     1.0      26/02/2014  Mauro Zegarra  Christian Riquelme  version inicial
  /* ***************************************************************************/
  FUNCTION find_iddefope RETURN int_operacion_tareadef.iddefope%TYPE;

  PROCEDURE update_int_servicio_plataforma;

  PROCEDURE crear_tareawfseg;

  PROCEDURE insert_int_servicio_plataforma(p_tellin IN OUT int_servicio_plataforma%ROWTYPE);

  FUNCTION get_iddefope RETURN int_operacion_tareadef.iddefope%TYPE;

  FUNCTION get_idseq RETURN int_servicio_plataforma.idseq%TYPE;
  PROCEDURE set_idseq(p_idseq operacion.int_servicio_plataforma.idseq%TYPE);
END;
/
