CREATE OR REPLACE PACKAGE OPERACION.PQ_JANUS_PROCESOS IS
  /****************************************************************************************************
     NAME:       PQ_JANUS_PROCESOS
     PURPOSE:    Ejecutar reenvios a BSCS
  
     REVISIONS:
     Ver        Date        Author           Solicitado por                  Description
     ---------  ----------  ---------------  --------------                  ----------------------
     1.0        20/02/2014  Eustaquio Gibaja Christian Riquelme             Ejecutar reenvios a BSCS
     2.0        20/02/2014  Eustaquio Gibaja Christian Riquelme             Adecuación de respuesta de BSCS
  ***************************************************************************************************/
  g_id_telefonia           operacion.int_telefonia.id%TYPE;
  g_idtrans                operacion.int_plataforma_bscs.idtrans%TYPE;
  g_idtareawf_valida_janus tareawfcpy.idtareawf%TYPE;

  TYPE linea IS RECORD(
    operation operacion.int_telefonia.operacion%TYPE,
    codsolot  operacion.int_telefonia.codsolot%TYPE,
    tx_bscs   operacion.int_telefonia_log.tx_bscs%TYPE,
    idtareawf tareawf.idtareawf%TYPE);

  TYPE transaccion IS RECORD(
    idtrans   operacion.int_plataforma_bscs.idtrans%TYPE,
    action_id operacion.int_plataforma_bscs.action_id%TYPE,
    co_id     operacion.int_plataforma_bscs.co_id%TYPE);

  PROCEDURE main_reenvio_bscs;

  PROCEDURE set_globals(p_id_telefonia operacion.int_telefonia.id%TYPE,
                        p_idlog        operacion.int_telefonia_log.id%TYPE,
                        p_idtrans      operacion.int_plataforma_bscs.idtrans%TYPE,
                        p_action_id    operacion.int_plataforma_bscs.action_id%TYPE,
                        p_trama        operacion.int_plataforma_bscs.trama%TYPE);

  FUNCTION get_cantidad_envio RETURN opedd.codigon%TYPE;

  PROCEDURE reenvio_solicitud;

  PROCEDURE update_int_telefonia;

  PROCEDURE send_mail_soporte_bscs(p_idlog operacion.int_telefonia_log.id%TYPE);

  FUNCTION get_linea(p_idlog operacion.int_telefonia_log.id%TYPE) RETURN linea;

  FUNCTION get_email_soporte_envio_bscs RETURN opedd.descripcion%TYPE;

  FUNCTION get_email_soporte_cerrar_janus RETURN opedd.descripcion%TYPE;

  FUNCTION get_horas_permitidas_janus RETURN opedd.codigon%TYPE;

  FUNCTION get_horas_sin_cerrar_janus(p_idwf wf.idwf%TYPE) RETURN NUMBER;

  FUNCTION get_envios_realizados(p_idlog operacion.int_telefonia_log.id%TYPE)
    RETURN operacion.int_telefonia_log.ws_envios%TYPE;

  PROCEDURE main_cerrar_tarea_janus;

  FUNCTION get_status_tx_janus(p_idtrans operacion.int_telefonia_log.idtrans%TYPE)
    RETURN operacion.int_telefonia_log.verificado%TYPE;

  FUNCTION get_transaccion RETURN transaccion;

  PROCEDURE valida_tx_janus(p_idtareawf tareawf.idtareawf%TYPE,
                            p_idwf      tareawf.idwf%TYPE,
                            p_tarea     tareawf.tarea%TYPE,
                            p_tareadef  tareawf.tareadef%TYPE,
                            p_tipesttar tareawf.tipesttar%TYPE,
                            p_esttarea  tareawf.esttarea%TYPE,
                            p_mottarchg tareawf.mottarchg%TYPE,
                            p_fecini    tareawf.fecini%TYPE,
                            p_fecfin    tareawf.fecfin%TYPE);

  FUNCTION get_status_solot(p_idwf wf.idwf%TYPE) RETURN solot.estsol%TYPE;

  PROCEDURE update_int_telefonia_log(p_idlog operacion.int_telefonia_log.id%TYPE);

  FUNCTION get_estado_generada_bscs RETURN opedd.codigon%TYPE; --2.0

END;
/