CREATE OR REPLACE PACKAGE OPERACION.PQ_TELEFONIA_CE IS
  /************************************************************************************************
   PROPOSITO: Centralizar los procesos de tipo interfaz con las plataformas
              telefonicas
   REVISIONES:
     Version  Fecha       Autor            Solicitado por      Descripcion
     -------  -----       -----             --------------      -----------
     1.0      26/02/2014  Eustaquio Gibaja  Christian Riquelme  version inicial
     2.0      24/07/2014  Eustaquio Gibaja  Christian Riquelme  Modificar la tarea en No Interviene
     3.0      16/12/2014  Edwin Vasquez     Christian Riquelme  Claro Empresas WiMAX
  /* **********************************************************************************************/
  /*g_idtareawf       tareawfcpy.idtareawf%TYPE;
  g_idwf            tareawf.idwf%TYPE;
  g_tarea           tareawf.tarea%TYPE;
  g_tareadef        tareawf.tareadef%TYPE;
  g_operacion       VARCHAR2(30);
  g_id_telefonia_ce telefonia_ce.id_telefonia_ce%TYPE;
  g_tipestsol       tipestsol.tipestsol%TYPE;*/
  /* **********************************************************************************************/

  PROCEDURE alta(p_idtareawf tareawf.idtareawf%TYPE,
                 p_idwf      tareawf.idwf%TYPE,
                 p_tarea     tareawf.tarea%TYPE,
                 p_tareadef  tareawf.tareadef%TYPE);

  PROCEDURE baja(p_idtareawf tareawf.idtareawf%TYPE,
                 p_idwf      tareawf.idwf%TYPE,
                 p_tarea     tareawf.tarea%TYPE,
                 p_tareadef  tareawf.tareadef%TYPE);

  procedure cambio_plan(p_idtareawf tareawf.idtareawf%type,
                        p_idwf      tareawf.idwf%TYPE,
                        p_tarea     tareawf.tarea%TYPE,
                        p_tareadef  tareawf.tareadef%TYPE);

  function es_telefonia(p_idwf tareawf.idwf%type) return boolean; 

  /*PROCEDURE set_globals(p_idtareawf tareawf.idtareawf%TYPE,
                        p_idwf      tareawf.idwf%TYPE,
                        p_tarea     tareawf.tarea%TYPE,
                        p_tareadef  tareawf.tareadef%TYPE); */ 

  PROCEDURE no_interviene(p_idtareawf tareawf.idtareawf%type);

  

  FUNCTION esta_registrado(p_operacion telefonia_ce.operacion%type,
                           p_idtareawf tareawf.idtareawf%type) return boolean;

  PROCEDURE crear_telefonia_ce;

   function crear_telefonia_ce(p_idtareawf tareawf.idtareawf%type,
                              p_idwf      tareawf.idwf%type,
                              p_tarea     tareawf.tarea%type,
                              p_tareadef  tareawf.tareadef%type,
                              p_operacion operacion.telefonia_ce.operacion%type)
    return operacion.telefonia_ce.id_telefonia_ce%type;

  PROCEDURE insert_telefonia_ce(p_telef IN OUT NOCOPY telefonia_ce%ROWTYPE);

  

  FUNCTION es_janus (p_operacion operacion.telefonia_ce.operacion%type,
                    p_idwf      tareawf.idwf%type) return boolean;

  function es_janus_cambio_plan(p_idwf tareawf.idwf%type) return boolean;

  PROCEDURE update_telefonia_ce;

  FUNCTION get_tipestsol RETURN tipestsol.tipestsol%TYPE;

  FUNCTION get_codsolot RETURN solot.codsolot%TYPE;

  

  FUNCTION es_claro_empresas(p_idwf tareawf.idwf%type) RETURN BOOLEAN;

  PROCEDURE insert_telefonia_ce_det(p_log IN OUT NOCOPY telefonia_ce_det%ROWTYPE);

  --FUNCTION get_id RETURN telefonia_ce.id_telefonia_ce%TYPE;

  PROCEDURE update_telefonia_ce_det(p_id_telefonia_ce_det telefonia_ce_det.id_telefonia_ce_det%type);

  PROCEDURE insert_tareawfseg(p_tareawfseg IN OUT NOCOPY tareawfseg%ROWTYPE);

  PROCEDURE chg_alta(p_idtareawf tareawf.idtareawf%TYPE,
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

  FUNCTION existe_reserva(p_idwf tareawf.idwf%type) RETURN BOOLEAN;

  FUNCTION get_idwf_alta (p_idwf tareawf.idwf%type) return tareawf.idwf%type;

  function habilita_planes_control return boolean;

  procedure pos_tarea(p_idtareawf tareawf.idtareawf%type,
                      p_idwf      tareawf.idwf%type,
                      p_tarea     tareawf.tarea%type,
                      p_tareadef  tareawf.tareadef%type);

END;
/