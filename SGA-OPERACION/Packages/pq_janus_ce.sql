CREATE OR REPLACE PACKAGE OPERACION.PQ_JANUS_CE IS
  /******************************************************************************
   PROPOSITO:
  
   REVISIONES:
     Version  Fecha       Autor            Solicitado por      Descripcion
     -------  -----       -----             --------------      -----------
     1.0    2014-06-26    Eustaquio Gibaja  Christian Riquelme  version inicial
     2.0    2014-10-22    Edwin Vasquez     Christian Riquelme  Claro Empresas WiMAX
  /* ***************************************************************************/
  /*g_trama     int_plataforma_bscs.trama%TYPE;
  g_idtrans   int_plataforma_bscs.idtrans%TYPE;
  g_action_id int_plataforma_bscs.action_id%TYPE;*/

  PROCEDURE insert_int_plataforma_bscs(p_int_bscs IN OUT int_plataforma_bscs%ROWTYPE);

  PROCEDURE crear_tareawfseg;

  function insert_int_plataforma_bscs(p_int_plataforma_bscs int_plataforma_bscs%rowtype)
    return int_plataforma_bscs.idtrans%type;--2.0

  FUNCTION get_conf(p_param VARCHAR2) RETURN opedd.codigoc%TYPE;

  PROCEDURE update_int_plataforma_bscs;

  FUNCTION get_config(p_param opedd.abreviacion%TYPE) RETURN opedd.codigoc%TYPE;

  function get(p_idtrans int_plataforma_bscs.idtrans%type)
    return operacion.int_plataforma_bscs%rowtype;
end;
/