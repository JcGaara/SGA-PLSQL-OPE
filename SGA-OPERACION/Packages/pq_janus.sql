CREATE OR REPLACE PACKAGE OPERACION.pq_janus IS
  /******************************************************************************
   PROPOSITO:
  
   REVISIONES:
     Version  Fecha       Autor          Solicitado por      Descripcion
     -------  -----       -----          --------------      -----------
     1.0      26/02/2014  Mauro Zegarra  Christian Riquelme  version inicial
     2.0      14/07/2014  Juan Gonzales  Christian Riquelme  Retardar transaccion
  /* ***************************************************************************/
  g_trama     VARCHAR2(32767);
  g_idtrans   int_plataforma_bscs.idtrans%TYPE;
  g_tx_bscs   VARCHAR2(30);
  g_action_id int_plataforma_bscs.action_id%TYPE;

  PROCEDURE insert_int_plataforma_bscs(p_int_bscs IN OUT int_plataforma_bscs%ROWTYPE);

  PROCEDURE crear_tareawfseg;

  FUNCTION set_tx_bscs(p_action_id int_plataforma_bscs.action_id%TYPE)
    RETURN VARCHAR2;

  FUNCTION get_conf(p_param VARCHAR2) RETURN opedd.codigoc%TYPE;

  PROCEDURE update_int_plataforma_bscs;

  FUNCTION get_config(p_param opedd.abreviacion%TYPE) RETURN opedd.codigoc%TYPE;

  PROCEDURE timer(p_sec NUMBER); --2.0

END;
/