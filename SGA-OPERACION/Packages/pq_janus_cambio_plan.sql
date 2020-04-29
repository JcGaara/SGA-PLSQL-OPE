CREATE OR REPLACE PACKAGE OPERACION.pq_janus_cambio_plan IS
  /******************************************************************************
   PROPOSITO:
  
   REVISIONES:
     Version  Fecha       Autor          Solicitado por      Descripcion
     -------  -----       -----          --------------      -----------
     1.0      26/02/2014  Mauro Zegarra  Christian Riquelme  version inicial
  /* ***************************************************************************/
  PROCEDURE cambio_plan;

  TYPE linea IS RECORD(
    codsolot      solotpto.codsolot%TYPE,
    codinssrv     inssrv.codinssrv%TYPE,
    pid           insprd.pid%TYPE,
    pid_old       solotpto.pid_old%TYPE,
    idplan        tystabsrv.idplan%TYPE,
    codsrv        insprd.codsrv%TYPE,
    codcli        inssrv.codcli%TYPE,
    numslc        inssrv.numslc%TYPE,
    numero        inssrv.numero%TYPE,
    plan          plan_redint.plan%TYPE,
    plan_opcional plan_redint.plan_opcional%TYPE);

  FUNCTION get_linea RETURN linea;

  FUNCTION get_codsrv_origen RETURN tystabsrv.codsrv%TYPE;

  FUNCTION get_codsrv_destino RETURN tystabsrv.codsrv%TYPE;

  PROCEDURE janus_janus;

  PROCEDURE crear_int_telefonia_log;

  PROCEDURE crear_int_plataforma_bscs;

  FUNCTION armar_trama RETURN VARCHAR2;

  FUNCTION get_linea_old RETURN int_plataforma_bscs%ROWTYPE;

END;
/
