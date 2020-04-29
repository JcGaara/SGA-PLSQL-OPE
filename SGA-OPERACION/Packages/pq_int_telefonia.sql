CREATE OR REPLACE PACKAGE OPERACION.pq_int_telefonia IS
  /******************************************************************************
   PROPOSITO: Centralizar los procesos de las plataformas telefonicas
  
   REVISIONES:
     Version  Fecha       Autor          Solicitado por      Descripcion
     -------  -----       -----          --------------      -----------
     1.0      26/02/2014  Mauro Zegarra  Christian Riquelme  version inicial
     2.0      24/07/2014  Eustaquio Gibaja  Christian Riquelme  Cambio de estado tarea No interviene
  /* ***************************************************************************/
  g_idtareawf tareawfcpy.idtareawf%TYPE;
  g_idwf      tareawf.idwf%TYPE;
  g_tarea     tareawf.tarea%TYPE;
  g_tareadef  tareawf.tareadef%TYPE;
  g_operacion VARCHAR2(30);
  g_origen    VARCHAR2(30);
  g_destino   VARCHAR2(30);

  PROCEDURE alta(p_idtareawf tareawf.idtareawf%TYPE,
                 p_idwf      tareawf.idwf%TYPE,
                 p_tarea     tareawf.tarea%TYPE,
                 p_tareadef  tareawf.tareadef%TYPE);

  PROCEDURE baja(p_idtareawf tareawf.idtareawf%TYPE,
                 p_idwf      tareawf.idwf%TYPE,
                 p_tarea     tareawf.tarea%TYPE,
                 p_tareadef  tareawf.tareadef%TYPE);

  PROCEDURE cambio_plan(p_idtareawf tareawf.idtareawf%TYPE,
                        p_idwf      tareawf.idwf%TYPE,
                        p_tarea     tareawf.tarea%TYPE,
                        p_tareadef  tareawf.tareadef%TYPE);

  FUNCTION esta_registrado(p_operacion VARCHAR2) RETURN BOOLEAN;

  PROCEDURE set_globals(p_idtareawf tareawf.idtareawf%TYPE,
                        p_idwf      tareawf.idwf%TYPE,
                        p_tarea     tareawf.tarea%TYPE,
                        p_tareadef  tareawf.tareadef%TYPE);

  PROCEDURE crear_int_telefonia;

  PROCEDURE update_int_telefonia;

  FUNCTION get_tipestsol RETURN tipestsol.tipestsol%TYPE;

  PROCEDURE update_int_telefonia_log;

  PROCEDURE cambio_plan_plataforma(p_plataforma VARCHAR2);

  FUNCTION get_codsolot RETURN solot.codsolot%TYPE;

  TYPE linea IS RECORD(
    codsolot  solotpto.codsolot%TYPE,
    codinssrv inssrv.codinssrv%TYPE,
    pid       solotpto.pid%TYPE,
    pid_old   solotpto.pid_old%TYPE,
    numero    inssrv.numero%TYPE);

  FUNCTION get_plataforma_origen RETURN VARCHAR2;

  FUNCTION get_plataforma_destino RETURN VARCHAR2;

  FUNCTION get_idwf_origen RETURN wf.idwf%TYPE;

  FUNCTION get_plataforma RETURN VARCHAR2;

  FUNCTION es_masivo_hfc RETURN BOOLEAN;

  FUNCTION existe_reserva RETURN BOOLEAN;

  PROCEDURE alta_plataforma_destino(p_plataforma VARCHAR2);

  PROCEDURE baja_plataforma_origen(p_plataforma VARCHAR2);

  FUNCTION es_janus RETURN BOOLEAN;

  FUNCTION es_tellin RETURN BOOLEAN;

  FUNCTION es_abierta RETURN BOOLEAN;

  PROCEDURE insert_tareawfseg(p_tareawfseg IN OUT NOCOPY tareawfseg%ROWTYPE);

  PROCEDURE insert_int_telefonia(p_telef IN OUT NOCOPY int_telefonia%ROWTYPE);

  PROCEDURE insert_int_telefonia_log(p_log IN OUT NOCOPY int_telefonia_log%ROWTYPE);

  PROCEDURE chg_alta(p_idtareawf tareawf.idtareawf%TYPE,
                     p_idwf      tareawf.idwf%TYPE,
                     p_tarea     tareawf.tarea%TYPE,
                     p_tareadef  tareawf.tareadef%TYPE,
                     p_tipesttar tareawf.tipesttar%TYPE,
                     p_esttarea  tareawf.esttarea%TYPE,
                     p_mottarchg tareawf.mottarchg%TYPE,
                     p_fecini    tareawf.fecini%TYPE,
                     p_fecfin    tareawf.fecfin%TYPE);

  PROCEDURE chg_cambio_plan(p_idtareawf tareawf.idtareawf%TYPE,
                            p_idwf      tareawf.idwf%TYPE,
                            p_tarea     tareawf.tarea%TYPE,
                            p_tareadef  tareawf.tareadef%TYPE,
                            p_tipesttar tareawf.tipesttar%TYPE,
                            p_esttarea  tareawf.esttarea%TYPE,
                            p_mottarchg tareawf.mottarchg%TYPE,
                            p_fecini    tareawf.fecini%TYPE,
                            p_fecfin    tareawf.fecfin%TYPE);

  PROCEDURE chg_baja(p_idtareawf tareawf.idtareawf%TYPE,
                     p_idwf      tareawf.idwf%TYPE,
                     p_tarea     tareawf.tarea%TYPE,
                     p_tareadef  tareawf.tareadef%TYPE,
                     p_tipesttar tareawf.tipesttar%TYPE,
                     p_esttarea  tareawf.esttarea%TYPE,
                     p_mottarchg tareawf.mottarchg%TYPE,
                     p_fecini    tareawf.fecini%TYPE,
                     p_fecfin    tareawf.fecfin%TYPE);

  FUNCTION find_esttarea(p_idtareawf tareawf.idtareawf%TYPE)
    RETURN tareawf.esttarea%TYPE;

  FUNCTION es_telefonia RETURN BOOLEAN;

  PROCEDURE no_interviene;

  FUNCTION get_id RETURN int_telefonia.id%TYPE;

END;
/
