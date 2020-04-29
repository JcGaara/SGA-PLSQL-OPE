create or replace package operacion.pq_janus_ce_cambio_plan is
  /*******************************************************************************
   PROPOSITO: Habilitación de Planes Control Wimax CE en JANUS
           
   REVISIONES:
     Version  Fecha       Autor          Solicitado por      Descripcion
     -------  -----       -----          --------------      -----------
     1.0      17/12/2014  Edwin Vasquez  Christian Riquelme  Claro Empresas WiMAX
     2.0      15/05/2015  Jose Varillas  Giovanni Vasquez    Claro Empresas Cambio de Plan
     3.0      15/05/2015  Jose Varillas  Giovanni Vasquez    
	 4.0	  11/11/2015  Jose Varillas  Giovanni Vasquez	 SD_533380
	 5.0	  18/12/2015  Jose Varillas  Giovanni Vasquez	 SD_600307
  /* ****************************************************************************/
  type linea is record(
    codsolot      solotpto.codsolot%type,
    codinssrv     inssrv.codinssrv%type,
    pid           insprd.pid%type,
    pid_old       solotpto.pid_old%type,
    idplan        tystabsrv.idplan%type,
    codsrv        insprd.codsrv%type,
    codcli        inssrv.codcli%type,
    numslc        inssrv.numslc%type,
    numero        inssrv.numero%type,
    plan          plan_redint.plan%type,
    plan_opcional plan_redint.plan_opcional%type);

  type tarea is record(
    idtareawf tareawfcpy.idtareawf%type,
    idwf      tareawfcpy.idwf%type,
    tarea     tareawfcpy.tarea%type,
    tareadef  tareawfcpy.tareadef%type);

  procedure cambio_plan(p_idtareawf tareawf.idtareawf%type,
                        p_idwf      tareawf.idwf%type,
                        p_tarea     tareawf.tarea%type,
                        p_tareadef  tareawf.tareadef%type);

  procedure validar_plan(p_idtareawf tareawf.idtareawf%type,
                         p_idwf      tareawf.idwf%type,
                         p_tarea     tareawf.tarea%type,
                         p_tareadef  tareawf.tareadef%type);

  procedure cambio_janus_proceso(p_idtareawf tareawf.idtareawf%type,
                                 p_idwf      tareawf.idwf%type,
                                 p_tarea     tareawf.tarea%type,
                                 p_tareadef  tareawf.tareadef%type);
                                 
  procedure cambio_janus(p_idtareawf tareawf.idtareawf%type,
                         p_idwf      tareawf.idwf%type,
                         p_tarea     tareawf.tarea%type,
                         p_tareadef  tareawf.tareadef%type);

  function crear_int_plataforma_bscs(p_idwf      tareawf.idwf%type,
                                     p_codinssrv inssrv.codinssrv%type,
                                     p_numero    numtel.numero%type)
    return int_plataforma_bscs.idtrans%type;

  function get_idwf_origen(p_idwf wf.idwf%type) return varchar2;

  function get_plataforma_origen(p_idwf wf.idwf%type) return varchar2;

  function get_plataforma_destino(p_idwf wf.idwf%type) return varchar2;

  function get_plataforma(p_idwf wf.idwf%type) return varchar2;

  function get_linea(p_idwf wf.idwf%type) return linea;

  function get_codsrv(p_pid solotpto.pid%type) return tystabsrv.codsrv%type;

  function get_cant_num(p_idwf wf.idwf%type) return number;

  function get_linea_old(p_linea linea) return int_plataforma_bscs%rowtype;

  function get_telefonia_ce(p_id_telefonia_ce telefonia_ce.id_telefonia_ce%type)
    return telefonia_ce%rowtype;

  function armar_trama(p_numslc    vtatabslcfac.numslc%type,
                       p_codinssrv inssrv.codinssrv%type,
                       p_plan      plan_redint.plan%type,
                       p_plan_opc  plan_redint.plan_opcional%type) return varchar2;

  function get_tipsrv(p_solot solot.codsolot%type) return tystipsrv.tipsrv%type;
  
  function get_proyecto_origen(p_idwf tareawfcpy.idwf%type) return vtatabslcfac.numslc%type;
  
  function get_tareawfcpy(p_idwf tareawfcpy.idwf%type) return tarea;
  
  procedure alta_baja_cplan_plataformas(p_idtareawf tareawf.idtareawf%type,
                                        p_idwf      tareawf.idwf%type,
                                        p_tarea     tareawf.tarea%type,
                                        p_tareadef  tareawf.tareadef%type,
                                        p_operacion telefonia_ce.operacion%type);

  procedure alta_baja_cplan(p_idtareawf tareawf.idtareawf%type,
                            p_idwf      tareawf.idwf%type,
                            p_tarea     tareawf.tarea%type,
                            p_tareadef  tareawf.tareadef%type,
                            p_operacion telefonia_ce.operacion%type);
                            
  procedure consumir_ws(p_idtareawf           tareawf.idtareawf%type,
                        p_idwf                tareawf.idwf%type);   
                                               
end;
/
