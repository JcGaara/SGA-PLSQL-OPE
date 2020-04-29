CREATE OR REPLACE PACKAGE OPERACION.PQ_TELEFONIA_CE_DET IS
  /******************************************************************************
   PROPOSITO: Registrar y guardar detalle de error
  
   REVISIONES:
     Version  Fecha       Autor          Solicitado por      Descripcion
     -------  -----       -----          --------------      -----------
     1.0      26/06/2014                 Christian Riquelme  version inicial
     2.0      2014-12-26  Edwin Vasquez     Christian Riquelme  Claro Empresas WiMAX
  /* ***************************************************************************/
  /*g_id_telefonia_ce_det operacion.telefonia_ce_det.id_telefonia_ce_det%TYPE;*/

  PROCEDURE logger(p_idtareawf tareawf.idtareawf%type, p_msg VARCHAR2);

  FUNCTION formart_msg(p_msg VARCHAR2) RETURN VARCHAR2;

  PROCEDURE set_msg(p_idtareawf tareawf.idtareawf%type, p_msg VARCHAR2);

  PROCEDURE con_error(p_idtareawf tareawf.idtareawf%type);

  /*FUNCTION get_id RETURN operacion.telefonia_ce_det.id_telefonia_ce_det%TYPE;*/

END;
/