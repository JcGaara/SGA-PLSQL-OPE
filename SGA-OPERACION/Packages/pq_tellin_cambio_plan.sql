CREATE OR REPLACE PACKAGE OPERACION.pq_tellin_cambio_plan IS
  /******************************************************************************
   PROPOSITO:
  
   REVISIONES:
     Version  Fecha       Autor          Solicitado por      Descripcion
     -------  -----       -----          --------------      -----------
     1.0      17/03/2014  Mauro Zegarra  Christian Riquelme  version inicial
  /* ***************************************************************************/
  PROCEDURE cambio_plan;

  FUNCTION esta_registrado RETURN BOOLEAN;

  TYPE linea IS RECORD(
    codsolot  solotpto.codsolot%TYPE,
    codinssrv inssrv.codinssrv%TYPE,
    pid       insprd.pid%TYPE,
    pid_old   solotpto.pid_old%TYPE,
    codnumtel numtel.codnumtel%TYPE,
    idplan    tystabsrv.idplan%TYPE,
    codsrv    insprd.codsrv%TYPE,
    codcli    inssrv.codcli%TYPE,
    numslc    inssrv.numslc%TYPE,
    numero    inssrv.numero%TYPE);

  FUNCTION get_linea RETURN linea;

  FUNCTION get_codsrv_origen RETURN tystabsrv.codsrv%TYPE;

  FUNCTION get_codsrv_destino RETURN tystabsrv.codsrv%TYPE;

  PROCEDURE tellin_tellin;

  PROCEDURE crear_int_servicio_plataforma;

  PROCEDURE crear_int_telefonia_log;

END;
/
