CREATE OR REPLACE PACKAGE OPERACION.PQ_JANUS_CE_PROCESOS IS
  /****************************************************************************************************
     NAME:       PQ_JANUS_CE_PROCESOS
     PURPOSE:    Ejecutar reenvios a BSCS
  
     REVISIONS:
     Version  Fecha       Autor            Solicitado por      Descripcion
     -------  -----       -----            --------------      -----------
     1.0      2014-06-26  Cesar Quispe    Christian Riquelme  version inicial
     2.0      2014-06-26  Cesar Quispe    Christian Riquelme  Adecuación de respuesta de BSCS
     3.0      2014-11-24  Eustaquio Gibaja Christian Riquelme  Mejoras en recepcion de respuesta de BSCS
     4.0      2014-12-24  Edwin Vasquez    Christian Riquelme  Claro Empresas WiMAX
  ***************************************************************************************************/
  /*g_id_telefonia           operacion.telefonia_ce.id_telefonia_ce%TYPE;
  g_idtrans                operacion.int_plataforma_bscs.idtrans%TYPE;
  g_idtareawf_valida_janus tareawfcpy.idtareawf%TYPE;*/

  TYPE linea IS RECORD(
    operation operacion.telefonia_ce.operacion%TYPE,
    codsolot  operacion.telefonia_ce.codsolot%TYPE,
    tx_bscs   operacion.telefonia_ce_det.idtrans%TYPE,
    idtareawf tareawf.idtareawf%TYPE);

  TYPE transaccion IS RECORD(
    idtrans   operacion.int_plataforma_bscs.idtrans%TYPE,
    action_id operacion.int_plataforma_bscs.action_id%TYPE,
    co_id     operacion.int_plataforma_bscs.co_id%TYPE);

  PROCEDURE main_reenvio_bscs;

  /*PROCEDURE set_globals(p_id_telefonia        operacion.telefonia_ce.id_telefonia_ce%TYPE,
                        p_id_telefonia_ce_det operacion.telefonia_ce_det.id_telefonia_ce_det%TYPE,
                        p_idtrans             operacion.int_plataforma_bscs.idtrans%TYPE,
                        p_action_id           operacion.int_plataforma_bscs.action_id%TYPE,
                        p_trama               operacion.int_plataforma_bscs.trama%TYPE);*/

  FUNCTION get_cantidad_envio RETURN opedd.codigon%TYPE;

  PROCEDURE reenvio_solicitud(p_idtrans             int_plataforma_bscs.idtrans%type,
                              p_id_telefonia_ce_det telefonia_ce_det.id_telefonia_ce_det%type,
                              p_id_telefonia_ce     telefonia_ce.id_telefonia_ce%type,
                              p_operacion           telefonia_ce.operacion%type);

  PROCEDURE update_telefonia_ce(p_id_telefonia_ce telefonia_ce.id_telefonia_ce%type,
                                p_operacion       telefonia_ce.operacion%type);

  PROCEDURE send_mail_soporte_bscs(p_id_telefonia_ce_det operacion.telefonia_ce_det.id_telefonia_ce_det%TYPE);

  PROCEDURE send_mail_soporte_cierre_tarea(p_idlog operacion.telefonia_ce.id_telefonia_ce%TYPE);

  FUNCTION get_linea(p_id_telefonia_ce_det operacion.telefonia_ce_det.id_telefonia_ce_det%TYPE)
    RETURN linea;

  FUNCTION get_email_soporte_envio_bscs RETURN opedd.descripcion%TYPE;

  FUNCTION get_email_soporte_cerrar_janus RETURN opedd.descripcion%TYPE;

  FUNCTION get_horas_permitidas_janus RETURN opedd.codigon%TYPE;

  FUNCTION get_horas_sin_cerrar_janus(p_idwf      wf.idwf%type,
                                      p_idtareawf operacion.telefonia_ce.idtareawf%type) 
    RETURN NUMBER;

  FUNCTION get_envios_realizados(p_id_telefonia_ce_det  operacion.telefonia_ce_det.id_telefonia_ce_det%TYPE)
    RETURN operacion.telefonia_ce_det.ws_envios%TYPE;

  PROCEDURE main_cerrar_tarea_janus;

  FUNCTION get_status_tx_janus(p_idtrans operacion.telefonia_ce_det.idtrans%TYPE)
    RETURN operacion.telefonia_ce_det.verificado%TYPE;

  FUNCTION get_transaccion(p_idtrans operacion.telefonia_ce_det.idtrans%type)
    RETURN transaccion;

  PROCEDURE update_telefonia_ce_det(p_idlog operacion.telefonia_ce_det.id_telefonia_ce_det%TYPE);

  PROCEDURE cerrar_tarea_linea_c(p_idtareawf tareawf.idtareawf%TYPE,
                                 p_idwf      tareawf.idwf%TYPE,
                                 p_tarea     tareawf.tarea%TYPE,
                                 p_tareadef  tareawf.tareadef%TYPE,
                                 a_tipesttar tareawf.tipesttar%TYPE,
                                 a_esttarea  tareawf.esttarea%TYPE,
                                 a_mottarchg tareawf.mottarchg%TYPE,
                                 a_fecini    tareawf.feccom%TYPE,
                                 a_fecfin    tareawf.fecfin%TYPE);

  FUNCTION get_estadotarea(p_idtareawf tareawf.idtareawf%TYPE) RETURN NUMBER;

  PROCEDURE cambiar_estado_tareawf(p_idtareawf tareawf.idtareawf%TYPE);

  FUNCTION get_cantidad_enviospendientes(p_idtareawf tareawf.idtareawf%TYPE)
    RETURN NUMBER;
END;
/