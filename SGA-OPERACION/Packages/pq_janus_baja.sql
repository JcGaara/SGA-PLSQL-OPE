CREATE OR REPLACE PACKAGE OPERACION.pq_janus_baja IS
  /******************************************************************************
   PROPOSITO:
  
   REVISIONES:
     Version  Fecha       Autor          Solicitado por      Descripcion
     -------  -----       -----          --------------      -----------
     1.0      26/02/2014  Mauro Zegarra  Christian Riquelme  version inicial
  /* ***************************************************************************/
  PROCEDURE baja;

  PROCEDURE crear_int_telefonia_log;

  PROCEDURE crear_int_plataforma_bscs;

  TYPE linea IS RECORD(
    codsolot  wf.codsolot%TYPE,
    pid       insprd.pid%TYPE,
    numero    inssrv.numero%TYPE,
    codinssrv insprd.codinssrv%TYPE);

  FUNCTION get_linea RETURN linea;

  FUNCTION armar_trama RETURN VARCHAR2;
  
  FUNCTION get_idwf_origen RETURN tareawfcpy.idwf%TYPE;

END;
/
