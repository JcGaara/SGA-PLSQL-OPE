CREATE OR REPLACE PACKAGE BODY OPERACION.PQ_JANUS_CE_BAJA IS
  /******************************************************************************
   PROPOSITO: Realizar la baja de servicios telefonicos HFC CE
  
   REVISIONES:
     Version  Fecha       Autor            Solicitado por      Descripcion
     -------  -----       -----             --------------      -----------
     1.0    2014-06-26    Eustaquio Gibaja  Christian Riquelme  version inicial
     2.0    2014-10-23    Edwin Vasquez     Christian Riquelme  Claro Empresas WiMAX
  /* ***************************************************************************/
  /*g_pid       insprd.pid%TYPE;
  g_codinssrv inssrv.codinssrv%TYPE;
  g_numero    inssrv.numero%TYPE;*/
  /* ***************************************************************************/
  PROCEDURE baja(p_idtareawf tareawf.idtareawf%type,
                 p_idwf      tareawf.idwf%type,
                 p_tarea     tareawf.tarea%type,
                 p_tareadef  tareawf.tareadef%type) IS
    
    c_baja                constant telefonia_ce.operacion%type := 2;
    l_codsolot            solot.codsolot%type;
    l_id_telefonia_ce     telefonia_ce.id_telefonia_ce%type;
    l_telefonia_ce        telefonia_ce%rowtype;
    l_idtrans             int_plataforma_bscs.idtrans%type;
    l_id_telefonia_ce_det telefonia_ce_det.id_telefonia_ce_det%type;
    l_ws_error_dsc        telefonia_ce_det.ws_error_dsc%type;
    l_total               pls_integer;
    l_enviadas            pls_integer;
    l_tipsrv              tystipsrv.tipsrv%type;
    l_cantidad            number;

    CURSOR registro_lineas(p_idwf tareawf.idwf%type) IS
      SELECT a.codsolot, f.pid, ins.numero, f.codinssrv
        FROM wf a,
             tystabsrv b,
             (SELECT a.codsolot, b.codinssrv, MAX(c.pid) pid
                FROM solotpto a, inssrv b, insprd c
               WHERE a.codinssrv = b.codinssrv
                 AND b.tipinssrv = 3
                 AND b.codinssrv = c.codinssrv
                 AND c.flgprinc = 1
               GROUP BY a.codsolot, b.codinssrv) e,
             insprd f,
             inssrv ins
       WHERE a.idwf = p_idwf--operacion.pq_telefonia_ce.g_idwf
         AND a.codsolot = e.codsolot
         AND f.codinssrv = e.codinssrv
         AND f.pid = e.pid
         AND f.codsrv = b.codsrv
         AND b.codsrv NOT IN
             (SELECT d.codigoc
                FROM tipopedd c, opedd d
               WHERE c.abrev = 'CFAXSERVER'
                 AND c.tipopedd = d.tipopedd
                 AND d.abreviacion = 'CFAXSERVER_SRV')
         AND e.codinssrv = ins.codinssrv
       ORDER BY f.pid DESC;
  
    CURSOR envio_lineas(p_idwf tareawf.idwf%type) IS
      SELECT c.id_telefonia_ce_det, d.idtrans, d.trama
        FROM wf                            a,
             operacion.telefonia_ce        b,
             operacion.telefonia_ce_det    c,
             operacion.int_plataforma_bscs d
       WHERE a.idwf = b.idwf
         AND b.id_telefonia_ce = c.id_telefonia_ce
         AND c.idtrans = d.idtrans
         AND a.idwf = p_idwf--pq_telefonia_ce.g_idwf
         AND a.valido = 1
         and c.action_id = 2 --baja
       ORDER BY c.pid DESC;

  BEGIN
     select t.codsolot into l_codsolot from wf t where t.idwf = p_idwf;
    
    select count(*)
      into l_cantidad
      from telefonia_ce
     where idtareawf = p_idtareawf
       and idwf = p_idwf
       and tarea = p_tarea
       and tareadef = p_tareadef;
  
    if l_cantidad = 0 then
      l_tipsrv := operacion.pq_janus_ce_cambio_plan.get_tipsrv(l_codsolot);
       
      insert into telefonia_ce
        (idtareawf, idwf, tarea, tareadef, codsolot, operacion, tipsrv)
      values
        (p_idtareawf, p_idwf, p_tarea, p_tareadef, l_codsolot, c_baja, l_tipsrv)
      returning id_telefonia_ce into l_id_telefonia_ce;
    else
      select id_telefonia_ce
        into l_id_telefonia_ce
        from telefonia_ce
       where idtareawf = p_idtareawf
         and idwf = p_idwf
         and tarea = p_tarea
         and tareadef = p_tareadef;
    end if;

    l_total /*g_lineas_total*/    := get_lineas_restantes(p_idwf);
    l_enviadas/*g_lineas_enviadas*/ := 0;
    
    l_telefonia_ce := pq_janus_ce_alta.get_telefonia_ce(l_id_telefonia_ce);

    FOR lineas IN registro_lineas(p_idwf) LOOP
    
      l_enviadas/*g_lineas_enviadas*/ := l_enviadas/*g_lineas_enviadas*/ + 1;
    
      --set_linea_x_servicio(lineas.pid, lineas.codinssrv, lineas.numero);
    
      --crear_int_plataforma_bscs();
    
      --crear_telefonia_ce_det();

      l_idtrans := crear_int_plataforma_bscs(lineas.numero,
                                             lineas.codinssrv,
                                             l_total - l_enviadas);
    
      l_id_telefonia_ce_det := crear_telefonia_ce_det(l_telefonia_ce,
                                                      lineas.codinssrv,
                                                      lineas.numero,
                                                      lineas.pid,
                                                      l_idtrans);
    
    END LOOP;
  
    FOR lineas IN envio_lineas(p_idwf) LOOP
    
      /*set_instancias_x_linea(lineas.id_telefonia_ce_det,
                             lineas.idtrans,
                             lineas.trama);*/
    
      operacion.pq_janus_ce_conexion.enviar_solicitud(lineas.idtrans,
                                                      lineas.id_telefonia_ce_det);
    
      select t.ws_error_dsc
        into l_ws_error_dsc
        from telefonia_ce_det t
       where t.id_telefonia_ce_det = lineas.id_telefonia_ce_det;
    
      insert into tareawfseg
        (idtareawf, observacion)
      values
        (p_idtareawf, l_ws_error_dsc);
    
      update telefonia_ce_det t
         set t.id_sga_error = 0, t.sga_error_dsc = 'OK', t.verificado = 0
       where t.id_telefonia_ce_det = lineas.id_telefonia_ce_det;

      --operacion.pq_janus_ce.update_int_plataforma_bscs();
    
      --operacion.pq_janus_ce.crear_tareawfseg();
    
      --operacion.pq_telefonia_ce.update_telefonia_ce_det();
    
    END LOOP;
  
     update operacion.telefonia_ce t
       set t.id_error = 0, t.mensaje = 'Registro satisfactorio'
     where t.id_telefonia_ce = l_id_telefonia_ce;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000, $$PLSQL_UNIT || '.BAJA: ' || SQLERRM);
  END;
  /* ***************************************************************************/
  PROCEDURE set_linea_x_servicio(p_pid       insprd.pid%TYPE,
                                 p_codinssrv inssrv.codinssrv%TYPE,
                                 p_numero    inssrv.numero%TYPE) IS
  BEGIN
     null;
    /*g_pid       := p_pid;
    g_codinssrv := p_codinssrv;
    g_numero    := p_numero;*/
  END;
  /* **********************************************************************************************/
  PROCEDURE set_instancias_x_linea(p_id      telefonia_ce_det.id_telefonia_ce_det%TYPE,
                                   p_idtrans telefonia_ce_det.idtrans%TYPE,
                                   p_trama   int_plataforma_bscs.trama%TYPE) IS
  BEGIN
     null;
    /*pq_telefonia_ce_det.g_id_telefonia_ce_det := p_id;
    pq_janus_ce.g_idtrans                     := p_idtrans;
    pq_janus_ce.g_trama                       := p_trama;*/
  END;
  /* **********************************************************************************************/
  PROCEDURE crear_telefonia_ce_det IS
    l_log operacion.telefonia_ce_det%ROWTYPE;
  
  BEGIN
    null; 
    /*l_log.id_telefonia_ce := operacion.pq_telefonia_ce.get_id();
    l_log.codinssrv       := g_codinssrv;
    l_log.numero          := g_numero;
    l_log.pid             := g_pid;
    l_log.idtrans         := operacion.pq_janus_ce.g_idtrans;
    l_log.action_id       := pq_telefonia_ce.g_operacion;
    l_log.verificado      := 0;
    l_log.ws_envios       := 0;
    operacion.pq_telefonia_ce.insert_telefonia_ce_det(l_log);
  
    operacion.pq_telefonia_ce_det.g_id_telefonia_ce_det := l_log.id_telefonia_ce_det;*/
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.CREAR_TELEFONIA_CE_DET: ' ||
                              SQLERRM);
  END;
  /* ***************************************************************************/
  PROCEDURE crear_int_plataforma_bscs IS
    C_BAJA CONSTANT PLS_INTEGER := 2;
    l_int_bscs operacion.int_plataforma_bscs%ROWTYPE;
  
  BEGIN
    null;
    /*l_int_bscs.co_id     := operacion.pq_janus_ce.get_conf('P_HCTR') ||
                            g_codinssrv;
    l_int_bscs.numero    := g_numero;
    l_int_bscs.imsi      := operacion.pq_janus_ce.get_conf('P_IMSI') ||
                            g_numero;
    l_int_bscs.action_id := C_BAJA;
    l_int_bscs.trama     := armar_trama();
    operacion.pq_janus_ce.insert_int_plataforma_bscs(l_int_bscs);
  
    operacion.pq_janus_ce.g_idtrans   := l_int_bscs.idtrans;
    operacion.pq_janus_ce.g_action_id := C_BAJA;*/
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.CREAR_INT_PLATAFORMA_BSCS: ' ||
                              SQLERRM);
  END;
  /* ***************************************************************************/
function crear_telefonia_ce_det(p_telefonia_ce telefonia_ce%rowtype,
                                  p_codinssrv    inssrv.codinssrv%type,
                                  p_numero       numtel.numero%type,
                                  p_pid          insprd.pid%type,
                                  p_idtrans      int_plataforma_bscs.idtrans%type)
    return telefonia_ce_det.id_telefonia_ce_det%type is
    l_det telefonia_ce_det%rowtype;
  
  begin
    l_det.id_telefonia_ce := p_telefonia_ce.id_telefonia_ce;
    l_det.codinssrv       := p_codinssrv;
    l_det.numero          := p_numero;
    l_det.pid             := p_pid;
    l_det.idtrans         := p_idtrans;
    l_det.action_id       := p_telefonia_ce.operacion;
    l_det.verificado      := 0;
  
    pq_telefonia_ce.insert_telefonia_ce_det(l_det);
  
    return l_det.id_telefonia_ce_det;
  
  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit || '.crear_telefonia_ce_det: ' ||
                              sqlerrm);
  end;
  --------------------------------------------------------------------------------
  function crear_int_plataforma_bscs(p_numero           numtel.numero%type,
                                     p_codinssrv        inssrv.codinssrv%type,
                                     p_lineas_restantes number)
    return int_plataforma_bscs.idtrans%type is
    c_baja constant int_plataforma_bscs.action_id%type := 2;
    l_bscs int_plataforma_bscs%rowtype;
  
  begin
    l_bscs.co_id     := pq_janus_ce.get_conf('P_HCTR') || p_codinssrv;
    l_bscs.numero    := p_numero;
    l_bscs.imsi      := pq_janus_ce.get_conf('P_IMSI') || p_numero;
    l_bscs.action_id := c_baja;
    l_bscs.trama     := armar_trama(p_numero, p_codinssrv, p_lineas_restantes);
    l_bscs.codusu    := user;
    l_bscs.fecusu    := sysdate;
  
    l_bscs.idtrans := pq_janus_ce.insert_int_plataforma_bscs(l_bscs);
  
    return l_bscs.idtrans;
  
  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit || '.crear_int_plataforma_bscs: ' ||
                              sqlerrm);
  end;
  --------------------------------------------------------------------------------
  FUNCTION armar_trama(p_numero           numtel.numero%type,
                       p_codinssrv        inssrv.codinssrv%type,
                       p_lineas_restantes number) RETURN VARCHAR2 IS
    l_trama            VARCHAR2(32767);
    --l_lineas_restantes PLS_INTEGER;
  
  BEGIN
  
    --l_lineas_restantes := g_lineas_total - g_lineas_enviadas;
    l_trama            := p_numero/*g_numero*/ || '|';
    l_trama            := l_trama || operacion.pq_janus_ce.get_conf('P_IMSI') ||
                          p_numero/*g_numero*/ || '|';
    l_trama            := l_trama || operacion.pq_janus_ce.get_conf('P_HCTR') ||
                          p_codinssrv/*g_codinssrv*/ || '|';
    l_trama            := l_trama || p_lineas_restantes/*l_lineas_restantes*/;
  
    RETURN l_trama;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.ARMAR_TRAMA: ' || SQLERRM);
  END;
  /* ***************************************************************************/
  FUNCTION get_lineas_restantes(p_idwf tareawf.idwf%type) RETURN NUMBER IS
     l_idwf   tareawf.idwf%type;
     l_lineas_restantes NUMBER;
  BEGIN
  
    if es_baja_x_cambio_plan(p_idwf) then
      l_idwf := p_idwf;
    else
      l_idwf := pq_telefonia_ce.get_idwf_alta(p_idwf);
    end if;
 
    SELECT COUNT(*)
      INTO l_lineas_restantes
      FROM wf a,
           tystabsrv b,
           (SELECT a.codsolot, b.codinssrv, MAX(c.pid) pid
              FROM solotpto a, inssrv b, insprd c
             WHERE a.codinssrv = b.codinssrv
               AND b.tipinssrv = 3
               AND b.codinssrv = c.codinssrv
               AND c.flgprinc = 1
             GROUP BY a.codsolot, b.codinssrv) e,
           insprd f,
           inssrv ins
     WHERE a.idwf = l_idwf--operacion.pq_telefonia_ce.get_idwf_alta()
       AND a.codsolot = e.codsolot
       AND f.codinssrv = e.codinssrv
       AND f.pid = e.pid
       AND f.codsrv = b.codsrv
       AND e.codinssrv = ins.codinssrv;
  
    RETURN l_lineas_restantes;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.GET_LINEAS_RESTANTES: ' ||
                              SQLERRM);
  END;
  /* **********************************************************************************************/
  function es_baja_x_cambio_plan(p_idwf tareawf.idwf%type) return boolean is
    l_count pls_integer;
    c_alta constant telefonia_ce.operacion%type := 1;
  
  begin
    select count(*)
      into l_count
      from telefonia_ce t
     where t.idwf = p_idwf
       and t.operacion = c_alta;
  
    return l_count > 0;
  end;
  --------------------------------------------------------------------------------
END;
/