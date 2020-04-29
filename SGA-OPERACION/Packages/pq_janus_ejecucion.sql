CREATE OR REPLACE PACKAGE OPERACION.PQ_JANUS_EJECUCION IS
  /****************************************************************************************************
     NAME:       PQ_JANUS_SOT_EJECUCION
     PURPOSE:    Retomar proceso para las  transacciones con JANUS
  
     REVISIONS:
     Ver        Date        Author           Solicitado por                  Description
     ---------  ----------  ---------------  --------------                  ----------------------
     1.0        20/02/2014  Eustaquio Gibaja Christian Riquelme             Retomar proceso para las  transacciones con JANUS
  ***************************************************************************************************/
  g_codsolot         solot.codsolot%TYPE;
  c_alta_hfc         operacion.opedd.abreviacion%TYPE := 'ALTA_HFC';
  c_baja_hfc         operacion.opedd.abreviacion%TYPE := 'BAJA_HFC';
  c_traslado_ext_hfc operacion.opedd.abreviacion%TYPE := 'TRASLADO_EXTERNO_HFC';
  c_cambio_plan_hfc  operacion.opedd.abreviacion%TYPE := 'CAMBIO_PLAN_HFC';
  c_reconexion_hfc   operacion.opedd.abreviacion%TYPE := 'RECONEXION_HFC';
  c_suspension_hfc   operacion.opedd.abreviacion%TYPE := 'SUSPENSION_HFC';
  c_corte_hfc        operacion.opedd.abreviacion%TYPE := 'CORTE_HFC';
  g_operacion        VARCHAR2(30);
  g_origen           VARCHAR2(30);
  g_destino          VARCHAR2(30);

  PROCEDURE execute_proceso(p_idwf tareawfcpy.idwf%TYPE);

  PROCEDURE set_globals(p_idwf tareawf.idwf%TYPE);

  PROCEDURE alta;

  PROCEDURE baja;

  PROCEDURE suspension;

  PROCEDURE reconexion;

  PROCEDURE cambio_plan;

  PROCEDURE cambio_plan_janus_janus;

  PROCEDURE baja_tellin;

  PROCEDURE set_tipo;

  PROCEDURE crear_int_servicio_plataforma;

  PROCEDURE crear_int_telefonia_log_tellin;

  PROCEDURE crear_int_telefonia_log;

  FUNCTION get_id_telefonia RETURN operacion.int_telefonia.id%TYPE;

  PROCEDURE registrar_chg_sot;

  PROCEDURE registrar_chg_sot_cabecera;

  PROCEDURE registrar_chg_sot_detalle;

END;
/
