CREATE OR REPLACE PACKAGE OPERACION.PQ_JANUS_UTL IS
  /****************************************************************************************************
     NAME:       PQ_JANUS_UTL
     PURPOSE:    Ejecutar procesos generales para conexion Janus
  
     REVISIONS:
     Ver        Date        Author            Solicitado por      Description
     ---------  ----------  ---------------   --------------      ----------------------
     1.0        20/02/2014  Eustaquio Gibaja  Christian Riquelme  Ejecutar procesos generales para conexion Janus
     2.0        08/07/2014  Juan Gonzales     Christian Riquelme  agregar validacion de envio de sucursal
  ***************************************************************************************************/

  g_idwf wf.idwf%TYPE;

  TYPE linea IS RECORD(
    codsolot      wf.codsolot%TYPE,
    codinssrv     insprd.codinssrv%TYPE,
    pid           insprd.pid%TYPE,
    pid_old       solotpto.pid_old%TYPE,
    idplan        tystabsrv.idplan%TYPE,
    codsrv        tystabsrv.codsrv%TYPE,
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
    imsi              operacion.int_plataforma_bscs.imsi%TYPE,
    codinssrv         operacion.int_telefonia_log.codinssrv%TYPE,
    trama             operacion.int_plataforma_bscs.trama%TYPE);

  g_linea_old linea_old;

  TYPE cliente IS RECORD(
    tipdide   vtatabcli.tipdide%TYPE,
    ntdide    vtatabcli.ntdide%TYPE,
    apellidos operacion.int_plataforma_bscs.apellidos%TYPE,
    nomclires vtatabcli.nomclires%TYPE,
    ruc       vtatabcli.ntdide%TYPE,
    razon     vtatabcli.nomcli%TYPE,
    telefono1 vtatabcli.telefono1%TYPE,
    telefono2 vtatabcli.telefono2%TYPE);

  CURSOR sucursal IS
    SELECT v.dirsuc, v.referencia, u.nomdst, u.nompvc, u.nomest
      FROM vtasuccli v, v_ubicaciones u;

  CURSOR plan IS
    SELECT t.plan, t.plan_opcional FROM plan_redint t;

  PROCEDURE crear_int_plataforma_bscs_baja;

  PROCEDURE crear_int_plataforma_bscs_alta;

  PROCEDURE crear_int_plataforma_bscs_cp;

  PROCEDURE crear_int_plataforma_bscs_rech;

  PROCEDURE crear_int_plat_bscs_cp_rech;

  FUNCTION get_linea_baja RETURN linea;

  FUNCTION get_linea_alta RETURN linea;

  FUNCTION get_linea_x_rechazo RETURN linea;

  FUNCTION get_linea_cp RETURN linea;

  FUNCTION get_linea_old RETURN linea_old;

  FUNCTION get_tx_bscs RETURN linea_old;

  FUNCTION get_linea_tx RETURN linea_old;

  FUNCTION get_idtrans_cp RETURN operacion.int_plataforma_bscs.idtrans%TYPE;

  PROCEDURE update_int_telefonia(p_id_telefonia operacion.int_telefonia.id%TYPE);

  PROCEDURE update_int_telefonia_log(p_idlog operacion.int_telefonia_log.id%TYPE);

  FUNCTION es_janus_py_origen RETURN BOOLEAN;

  FUNCTION es_janus(p_idwf tareawfcpy.idwf%TYPE) RETURN BOOLEAN;

  FUNCTION armar_trama_baja RETURN VARCHAR2;

  FUNCTION armar_trama_alta RETURN VARCHAR2;

  FUNCTION get_codsrv_origen RETURN tystabsrv.codsrv%TYPE;

  FUNCTION get_codsrv_destino RETURN tystabsrv.codsrv%TYPE;

  FUNCTION armar_trama_cp RETURN VARCHAR2;

  FUNCTION get_codsolot RETURN solot.codsolot%TYPE;

  FUNCTION get_nomemail RETURN vtaafilrecemail.nomemail%TYPE;

  FUNCTION get_cliente RETURN cliente;

  FUNCTION get_sucursal RETURN sucursal%ROWTYPE;

  FUNCTION get_plan RETURN plan%ROWTYPE;

  FUNCTION get_codinssrv RETURN inssrv.codinssrv%TYPE;

  FUNCTION get_pid RETURN insprd.pid%TYPE;

  FUNCTION get_numero RETURN numtel.numero%TYPE;

  FUNCTION get_wfdef(p_idwf tareawfcpy.idwf%TYPE) RETURN wfdef.wfdef%TYPE;

  FUNCTION get_idwf_origen RETURN tareawfcpy.idwf%TYPE;

  FUNCTION get_pid_old RETURN insprd.pid%TYPE;

  FUNCTION get_id_telefonia RETURN operacion.int_telefonia.id%TYPE;

  FUNCTION get_tarea_janus(p_idwf tareawf.idwf%TYPE) RETURN tareawfdef.tarea%TYPE;

  FUNCTION get_idtareawf RETURN tareawfcpy.idtareawf%TYPE;

  PROCEDURE crear_int_telefonia_log;

  PROCEDURE crear_int_telefonia_log_cp;

  FUNCTION caso_sot_rechazo(p_idwf tareawfcpy.idwf%TYPE)
    RETURN operacion.opedd.abreviacion%TYPE;

  FUNCTION get_tx_janus_pendiente(p_codsolot solot.codsolot%TYPE) RETURN NUMBER;

  FUNCTION es_tx_janus_ejecutada(p_codsolot solot.codsolot%TYPE) RETURN BOOLEAN;

  FUNCTION exist_janus_rechazo(p_idwf wf.idwf%TYPE) RETURN BOOLEAN;

  FUNCTION existe_tx_janus(p_idwf tareawfcpy.idwf%TYPE) RETURN BOOLEAN;

  FUNCTION get_idtareawf_valida_tx_janus(p_idwf tareawf.idwf%TYPE)
    RETURN tareawfcpy.idtareawf%TYPE;

  FUNCTION get_tarea_valida_tx_janus RETURN tareawfcpy.tarea%TYPE;

  PROCEDURE cerrar_tarea_valida_janus(p_idtareawf tareawf.idtareawf%TYPE,
                                      p_idwf      tareawf.idwf%TYPE,
                                      p_tarea     tareawf.tarea%TYPE,
                                      p_tareadef  tareawf.tareadef%TYPE);

  PROCEDURE set_globals(p_idwf tareawf.idwf%TYPE);
END;
/
