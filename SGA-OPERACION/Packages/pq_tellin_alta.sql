CREATE OR REPLACE PACKAGE OPERACION.pq_tellin_alta IS
  /******************************************************************************
   PROPOSITO: ALTA TELLIN
  
   REVISIONES:
     Version  Fecha       Autor          Solicitado por      Descripcion
     -------  -----       -----          --------------      -----------
     1.0      26/02/2014  Mauro Zegarra  Christian Riquelme  version inicial
  /* ***************************************************************************/
  PROCEDURE alta;

  TYPE linea IS RECORD(
    codsolot  solot.codsolot%TYPE,
    codinssrv inssrv.codinssrv%TYPE,
    pid       insprd.pid%TYPE,
    codnumtel numtel.codnumtel%TYPE,
    idplan    plan_redint.idplan%TYPE,
    codsrv    tystabsrv.codsrv%TYPE,
    codcli    inssrv.codcli%TYPE,
    numero    inssrv.numero%TYPE,
    numslc    inssrv.numslc%TYPE);

  FUNCTION get_linea RETURN linea;

  PROCEDURE crear_int_servicio_plataforma;

  PROCEDURE crear_int_telefonia_log;

END;
/
