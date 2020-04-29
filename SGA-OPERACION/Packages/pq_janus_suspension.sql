CREATE OR REPLACE PACKAGE OPERACION.PQ_JANUS_SUSPENSION IS
  /****************************************************************************************************
     NAME:       PQ_JANUS_SUSPENSION
     PURPOSE:    Ejecutar proceso DE SUSPENSION EN JANUS
  
     REVISIONS:
     Ver        Date        Author           Solicitado por                  Description
     ---------  ----------  ---------------  --------------                  ----------------------
     1.0        20/02/2014  Eustaquio Gibaja Christian Riquelme            Ejecutar proceso DE SUSPENSION EN JANUS
  ***************************************************************************************************/
  g_operacion VARCHAR2(30);
  g_origen    VARCHAR2(30);
  g_destino   VARCHAR2(30);
  g_codsolot  solot.codsolot%TYPE;
  g_pid       insprd.pid%TYPE;
  g_codinssrv inssrv.codinssrv%TYPE;
  g_numero    inssrv.numero%TYPE;

  PROCEDURE suspension_padre(p_idtareawf tareawf.idtareawf%TYPE,
                             p_idwf      tareawf.idwf%TYPE,
                             p_tarea     tareawf.tarea%TYPE,
                             p_tareadef  tareawf.tareadef%TYPE);

  PROCEDURE suspension;

  TYPE linea IS RECORD(
    codinssrv inssrv.codinssrv%TYPE,
    numero    inssrv.numero%TYPE,
    pid       insprd.pid%TYPE);

  FUNCTION get_linea RETURN linea;

  PROCEDURE set_contexto;

  FUNCTION get_codsolot RETURN solot.codsolot%TYPE;

  PROCEDURE crea_int_plataforma_bscs;

  FUNCTION armar_trama RETURN VARCHAR2;

  FUNCTION get_codinssrv RETURN inssrv.codinssrv%TYPE;

  FUNCTION get_pid RETURN insprd.pid%TYPE;

  FUNCTION get_numero RETURN numtel.numero%TYPE;

  PROCEDURE crea_int_telefonia_log;

  FUNCTION get_id_telefonia RETURN operacion.int_telefonia.id%TYPE;
END;
/
