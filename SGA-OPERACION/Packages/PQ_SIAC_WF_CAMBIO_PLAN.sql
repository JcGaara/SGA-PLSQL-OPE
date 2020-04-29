create or replace package operacion.PQ_SIAC_WF_CAMBIO_PLAN is
  /************************************************************************************************
  NOMBRE:     OPERACION.PQ_SIAC_CAMBIO_PLAN
  PROPOSITO:  Generar WF Cambio de Plan

  REVISIONES:
   Version   Fecha          Autor            Solicitado por      Descripcion
   -------- ----------  ------------------   -----------------   ------------------------
   1.0      06/08/2014   Alex Alamo           Hector Huaman       Generar WF Cambio de Plan
   2.0      15/09/2014   Jimmy Calle          Hector Huaman       Mejora en Proyecto de SIAC Cambio de Plan
   3.0      2015-07-09   Freddy Gonzales      Hector Huaman       SD-335922 - SOTs con dirección errada
   4.0      15/12/2015   Dorian Sucasaca                          PQT-247649-TSK-76965
  /************************************************************************************************/

  g_idtareawf tareawfcpy.idtareawf%TYPE;
  g_idwf      tareawf.idwf%TYPE;
  g_tarea     tareawf.tarea%TYPE;
  g_tareadef  tareawf.tareadef%TYPE;

PROCEDURE asigna_numero_siac_cp(p_idtareawf IN NUMBER,
                                p_idwf      IN NUMBER,
                                p_tarea     IN NUMBER,
                                p_tareadef  IN NUMBER);

 FUNCTION existe_telefonia RETURN BOOLEAN;

 PROCEDURE no_interviene;

 FUNCTION get_codsolot RETURN solot.codsolot%TYPE;

  function tenia_telefonia_old(p_codsolot solot.codsolot%type) return boolean;

  function get_inssrv_old(p_codsolot solot.codsolot%type) return inssrv%rowtype;

 FUNCTION get_inssrv RETURN inssrv%ROWTYPE;

 PROCEDURE cierre_tarea;

 PROCEDURE baja_sisac_cp(p_idtareawf IN NUMBER,
                        p_idwf       IN NUMBER,
                        p_tarea      IN NUMBER,
                        p_tareadef   IN NUMBER);
                        
 FUNCTION get_co_id RETURN inssrv.co_id%TYPE;

 PROCEDURE insert_tareawfseg(p_tareawfseg IN OUT NOCOPY tareawfseg%ROWTYPE);
 
 PROCEDURE crear_tareawfseg(p_mensaje tareawfseg.observacion%TYPE);

END;
/
