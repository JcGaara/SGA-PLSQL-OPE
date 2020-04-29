CREATE OR REPLACE PACKAGE OPERACION.PQ_JANUS_CE_BAJA IS
  /******************************************************************************
   PROPOSITO: Realizar la baja de servicios telefonicos HFC CE
  
   REVISIONES:
     Version  Fecha       Autor            Solicitado por      Descripcion
     -------  -----       -----             --------------      -----------
     1.0    2014-06-26    Eustaquio Gibaja  Christian Riquelme  version inicial
     2.0    2014-09-29    César Quispe      Mauro Zegarra       Req. 165094 Configuración Janus Multi Proyecto
  /* ***************************************************************************/
  /*g_lineas_total    PLS_INTEGER;
  g_lineas_enviadas PLS_INTEGER;*/

  PROCEDURE baja(p_idtareawf tareawf.idtareawf%type,
                 p_idwf      tareawf.idwf%type,
                 p_tarea     tareawf.tarea%type,
                 p_tareadef  tareawf.tareadef%type);

  PROCEDURE set_linea_x_servicio(p_pid       insprd.pid%TYPE,
                                 p_codinssrv inssrv.codinssrv%TYPE,
                                 p_numero    inssrv.numero%TYPE);

  PROCEDURE set_instancias_x_linea(p_id      telefonia_ce_det.id_telefonia_ce_det%TYPE,
                                   p_idtrans telefonia_ce_det.idtrans%TYPE,
                                   p_trama   int_plataforma_bscs.trama%TYPE);

  PROCEDURE crear_telefonia_ce_det;

  PROCEDURE crear_int_plataforma_bscs;

  function crear_telefonia_ce_det(p_telefonia_ce telefonia_ce%rowtype,
                                  p_codinssrv    inssrv.codinssrv%type,
                                  p_numero       numtel.numero%type,
                                  p_pid          insprd.pid%type,
                                  p_idtrans      int_plataforma_bscs.idtrans%type)
    return telefonia_ce_det.id_telefonia_ce_det%type;

  function crear_int_plataforma_bscs(p_numero           numtel.numero%type,
                                     p_codinssrv        inssrv.codinssrv%type,
                                     p_lineas_restantes number)
    return int_plataforma_bscs.idtrans%type;

  FUNCTION armar_trama(p_numero           numtel.numero%type,
                       p_codinssrv        inssrv.codinssrv%type,
                       p_lineas_restantes number) RETURN VARCHAR2;

  FUNCTION get_lineas_restantes(p_idwf tareawf.idwf%type) RETURN NUMBER;

  function es_baja_x_cambio_plan(p_idwf tareawf.idwf%type) return boolean;

END;
/