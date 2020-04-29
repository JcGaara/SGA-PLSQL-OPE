CREATE OR REPLACE PACKAGE OPERACION.PQ_JANUS_RECHAZO IS
  /****************************************************************************************************
     NAME:       PQ_JANUS_SOT_RECHAZO
     PURPOSE:    ejecutar proceso inverso en transacciones con JANUS
  
     REVISIONS:
     Ver        Date        Author           Solicitado por                  Description
     ---------  ----------  ---------------  --------------                  ----------------------
     1.0        20/02/2014  Eustaquio Gibaja Christian Riquelme             ejecutar proceso inverso en la transacciones con JANUS
  ***************************************************************************************************/

  g_codsolot         solot.codsolot%TYPE;
  c_alta_hfc         operacion.opedd.abreviacion%TYPE := 'ALTA_HFC';
  c_baja_hfc         operacion.opedd.abreviacion%TYPE := 'BAJA_HFC';
  c_traslado_ext_hfc operacion.opedd.abreviacion%TYPE := 'TRASLADO_EXTERNO_HFC';
  c_cambio_plan_hfc  operacion.opedd.abreviacion%TYPE := 'CAMBIO_PLAN_HFC';
  c_reconexion_hfc   operacion.opedd.abreviacion%TYPE := 'RECONEXION_HFC';
  c_suspension_hfc   operacion.opedd.abreviacion%TYPE := 'SUSPENSION_HFC';
  c_corte_hfc        operacion.opedd.abreviacion%TYPE := 'CORTE_HFC';

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

  g_linea linea;

  TYPE linea_old IS RECORD(
    plan_base         operacion.int_plataforma_bscs.plan_base%TYPE,
    plan_opcional     operacion.int_plataforma_bscs.plan_opcional%TYPE,
    plan_old          operacion.int_plataforma_bscs.plan_old%TYPE,
    plan_opcional_old operacion.int_plataforma_bscs.plan_opcional_old%TYPE,
    numero            operacion.int_plataforma_bscs.numero%TYPE,
    numero_old        operacion.int_plataforma_bscs.numero_old%TYPE,
    imsi              operacion.int_plataforma_bscs.imsi%TYPE);

  g_linea_old linea_old;

  PROCEDURE execute_proceso(p_idwf tareawfcpy.idwf%TYPE);

  PROCEDURE set_globals(p_idwf tareawf.idwf%TYPE);

  PROCEDURE baja;

  PROCEDURE alta;

  PROCEDURE suspension;

  PROCEDURE reconexion;

  PROCEDURE cambio_plan;

  PROCEDURE cambio_plan_janus_janus;

  PROCEDURE alta_tellin;

  PROCEDURE crear_int_servicio_plataforma;

  PROCEDURE crear_int_telefonia_log_tellin;

  PROCEDURE set_tipo;

  PROCEDURE crear_int_telefonia_log;

  FUNCTION get_id_telefonia RETURN operacion.int_telefonia.id%TYPE;

  PROCEDURE registrar_chg_sot;

  PROCEDURE registrar_chg_sot_cabecera;

  PROCEDURE registrar_chg_sot_detalle;

  FUNCTION get_idwf_origen RETURN tareawfcpy.idwf%TYPE;

END;
/
