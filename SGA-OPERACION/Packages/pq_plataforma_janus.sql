CREATE OR REPLACE PACKAGE OPERACION.PQ_PLATAFORMA_JANUS IS

  /***********************************************************************************************************
    PROPOSITO: Plataformas Telefonica
  
    REVISIONES:
    Version  Fecha       Autor          Solicitado por            Descripcion
    -------  -----       -----          --------------            -----------
    1.0      12/03/2014  Jose Soto Guevara  Christian Riquelme  Proceso de Susp.Corte  y Reconexion en JANUS
    2.0      30/05/2014  Jose Soto Guevara  Christian Riquelme  Inclusion de Validacion de WF - HFC
    3.0      06/06/2014  Jose Soto Guevara  Christian Riquelme  Mejoras
  /***********************************************************************************************************/

  CN_ESTTAREA_ERROR CONSTANT esttarea.esttarea%TYPE := 15;
  CN_ESTTAREA_CERR  CONSTANT esttarea.esttarea%TYPE := 4;

  /****  ini 3.0  ***/
  --gs_numslc       operacion.inssrv.numslc%type;
  /***   fin 3.0  ***/
  gn_id_telefonia operacion.int_telefonia.id%TYPE := 0;
  gn_id_tel       operacion.int_telefonia.id%TYPE := 0;
  gs_imsi         operacion.opedd.codigoc%TYPE;

  PROCEDURE p_error_tarea;
  PROCEDURE p_update_bscs(an_id        IN NUMBER,
                          an_resultado IN NUMBER,
                          as_mensaje   IN VARCHAR2);
  PROCEDURE p_update_log(an_id        NUMBER,
                         an_resultado NUMBER,
                         as_mensaje   VARCHAR2);
  PROCEDURE p_update_telef;
  PROCEDURE p_inserta_tarea(an_idtareawf tareawf.idtareawf%TYPE,
                            as_texto     VARCHAR2);

  PROCEDURE p_inserta_plataforma_bscs(as_codcli    IN VARCHAR2,
                                      as_nombre    IN VARCHAR2,
                                      as_apellido  IN VARCHAR2,
                                      as_co_id     IN VARCHAR2,
                                      an_action_id IN NUMBER,
                                      as_trama     IN VARCHAR2,
                                      as_imsi      IN VARCHAR2,
                                      an_idtrans   OUT NUMBER);

  /***  ini 2.0  ***/
  PROCEDURE p_suspension_janus(an_idtareawf tareawf.idtareawf%TYPE,
                               an_idwf      tareawf.idwf%TYPE,
                               an_tarea     tareawf.tarea%TYPE,
                               an_tareadef  tareawf.tareadef%TYPE);

  PROCEDURE p_corte_janus(an_idtareawf tareawf.idtareawf%TYPE,
                          an_idwf      tareawf.idwf%TYPE,
                          an_tarea     tareawf.tarea%TYPE,
                          an_tareadef  tareawf.tareadef%TYPE);
  PROCEDURE p_reconexion_janus(an_idtareawf tareawf.idtareawf%TYPE,
                               an_idwf      tareawf.idwf%TYPE,
                               an_tarea     tareawf.tarea%TYPE,
                               an_tareadef  tareawf.tareadef%TYPE);

  PROCEDURE p_inserta_int_telefonia(as_operacion VARCHAR2,
                                    an_idtareawf NUMBER,
                                    an_idwf      NUMBER,
                                    an_tarea     NUMBER,
                                    an_tareadef  NUMBER,
                                    as_origen    VARCHAR2,
                                    as_destino   VARCHAR2,
                                    an_sot       NUMBER,
                                    as_platf     VARCHAR2,
                                    an_innsrv    NUMBER,
                                    as_numero    VARCHAR2,
                                    /**** ini 3.0    ****/
                                    -- an_pid
                                    /***  fin 3.0   ***/
                                    an_janus   NUMBER,
                                    as_tx_bscs VARCHAR2,
                                    an_sga_id  NUMBER,
                                    as_sga_dsc VARCHAR2);
  /***  fin 2.0  ***/
  FUNCTION f_valida_janus(an_idwf NUMBER) RETURN NUMBER;
  FUNCTION f_get_codclie_janus(an_sot NUMBER) RETURN VARCHAR2;
  FUNCTION f_get_pid(as_numslc VARCHAR2) RETURN NUMBER;
  FUNCTION f_get_sot(an_idwf tareawf.idwf%TYPE) RETURN NUMBER;
  FUNCTION f_action_id(as_operacion VARCHAR2) RETURN NUMBER;
  FUNCTION f_operacion_susp RETURN VARCHAR2;
  FUNCTION f_operacion_recn RETURN VARCHAR2;
  FUNCTION f_operacion_cort RETURN VARCHAR2;
  FUNCTION f_trs_operacion RETURN VARCHAR2;
  FUNCTION f_imsi RETURN VARCHAR2;
  FUNCTION f_ok RETURN VARCHAR2;
  FUNCTION f_prefijo RETURN VARCHAR2;
  FUNCTION f_get_numslc(an_sot NUMBER) RETURN VARCHAR2;

END;
/