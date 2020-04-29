CREATE OR REPLACE PACKAGE OPERACION.pq_tellin_baja IS
  /******************************************************************************
   PROPOSITO: BAJA TELLIN
  
   REVISIONES:
     Version  Fecha       Autor          Solicitado por      Descripcion
     -------  -----       -----          --------------      -----------
     1.0      26/02/2014  Mauro Zegarra  Christian Riquelme  version inicial
  /* ***************************************************************************/
  PROCEDURE baja;

  FUNCTION esta_registrado RETURN BOOLEAN;

  TYPE linea IS RECORD(
    codsolot  wf.codsolot%TYPE,
    codinssrv insprd.codinssrv%TYPE,
    pid       insprd.pid%TYPE,
    codnumtel numtel.codnumtel%TYPE,
    idplan    tystabsrv.idplan%TYPE,
    codsrv    tystabsrv.codsrv%TYPE,
    codcli    inssrv.codcli%TYPE,
    numslc    inssrv.numslc%TYPE,
    numero    inssrv.numero%TYPE);

  FUNCTION get_linea RETURN linea;

  PROCEDURE crear_int_servicio_plataforma;

  PROCEDURE crear_int_telefonia_log;

END;
/
