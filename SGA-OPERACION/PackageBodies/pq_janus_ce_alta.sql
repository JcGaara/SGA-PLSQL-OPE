CREATE OR REPLACE PACKAGE BODY OPERACION.pq_janus_ce_alta IS
  /************************************************************************************************
   PROPOSITO: Centralizar los procesos de tipo interfaz con las plataformas
              telefonicas
   REVISIONES:
     Version  Fecha       Autor            Solicitado por      Descripcion
     -------  -----       -----             --------------      -----------
     1.0    2014-06-26    Eustaquio Gibaja  Christian Riquelme  version inicial
     2.0    2014-10-20    Jimmy Calle       Christian Riquelme  Asignacion de Ciclo CE
     3.0    2014-10-23    César Quispe      Christian Riquelme  Req. 165094 Configuración Janus Multi Proyecto
     4.0    2014-10-23    Edwin Vasquez     Christian Riquelme  Claro Empresas WiMAX
  /* **********************************************************************************************/
  /*g_linea     linea;
  g_cliente   cliente;
  g_sucursal  sucursal%ROWTYPE;
  g_plan      plan%ROWTYPE;
  g_pid       insprd.pid%TYPE;
  g_numslc    inssrv.numslc%TYPE; --3.0
  g_codinssrv inssrv.codinssrv%TYPE;
  g_numero    inssrv.numero%TYPE;*/
  /* **********************************************************************************************/
  PROCEDURE alta(p_idtareawf tareawf.idtareawf%type,
                 p_idwf      tareawf.idwf%type,
                 p_tarea     tareawf.tarea%type,
                 p_tareadef  tareawf.tareadef%type) IS
  
    c_alta                constant telefonia_ce.operacion%type := 1;
    l_codsolot            solot.codsolot%type;
    l_id_telefonia_ce     telefonia_ce.id_telefonia_ce%type;
    l_telefonia_ce        operacion.telefonia_ce%rowtype;
    l_idtrans             operacion.int_plataforma_bscs.idtrans%type;
    l_id_telefonia_ce_det operacion.telefonia_ce_det.id_telefonia_ce_det%type;
    l_ws_error_dsc        operacion.telefonia_ce_det.ws_error_dsc%type;
    l_tipsrv              tystipsrv.tipsrv%type;
    l_cantidad            number;
    --l_numslc              vtatabslcfac.numslc%type;
    
    /*Ini 3.0*/
    /*CURSOR registro_lineas IS
      SELECT e.codinssrv, e.numero, b.pid
        FROM wf d, solotpto a, insprd b, tystabsrv c, inssrv e, solot g
       WHERE d.idwf = pq_telefonia_ce.g_idwf
         AND a.codsolot = d.codsolot
         AND a.pid = b.pid
         AND e.tipinssrv = 3
         AND b.codsrv = c.codsrv
         AND e.codinssrv = b.codinssrv
         AND a.codsolot = g.codsolot
         AND b.flgprinc = 1
         AND e.cid IS NOT NULL;*/
    /*CURSOR registro_lineas IS
    SELECT e.numslc, e.codinssrv, e.numero, b.pid
        FROM wf d, solotpto a, insprd b, tystabsrv c, inssrv e, solot g
       WHERE d.idwf = pq_telefonia_ce.g_idwf
         AND a.codsolot = d.codsolot
         AND a.pid = b.pid
         AND e.tipinssrv = 3
         AND b.codsrv = c.codsrv
         AND e.codinssrv = b.codinssrv
         AND a.codsolot = g.codsolot
         AND b.flgprinc = 1
         AND e.cid IS NOT NULL;*/
    /*Fin 3.0*/
  
  cursor registro_lineas(p_idwf tareawf.idwf%type) is
      select e.numslc, e.codinssrv, e.numero, b.pid
        from wf d, solotpto a, insprd b, tystabsrv c, inssrv e, solot g
       where d.idwf = p_idwf
         and a.codsolot = d.codsolot
         and a.pid = b.pid
         and e.tipinssrv = 3
         and b.codsrv = c.codsrv
         and e.codinssrv = b.codinssrv
         and a.codsolot = g.codsolot
         and b.flgprinc = 1
         and e.cid is not null;
  
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
       order by d.idtrans;

  BEGIN
    select t.codsolot into l_codsolot from wf t where t.idwf = p_idwf;
    --l_numslc := operacion.pq_janus_ce_cambio_plan.get_proyecto_origen(p_idwf);
    
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
        (p_idtareawf, p_idwf, p_tarea, p_tareadef, l_codsolot, c_alta, l_tipsrv)
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
  
    l_telefonia_ce := get_telefonia_ce(l_id_telefonia_ce);

    IF NOT pq_telefonia_ce.existe_reserva(p_idwf) THEN
      RAISE_APPLICATION_ERROR(-20000,
                              'Existe servicios que no tienen asignado numero ' ||
                              'telefonico, realizar asignacion y luego cambiar ' ||
                              'la tarea a estado Generada.');
    END IF;
  
    --set_variables_genericas();
  
    FOR lineas IN registro_lineas(p_idwf) LOOP
    
      /*Ini 3.0*/
      --set_linea_x_servicio(lineas.pid, lineas.codinssrv, lineas.numero);
      --set_linea_x_servicio(lineas.pid, lineas.numslc, lineas.codinssrv, lineas.numero);
      /*Fin 3.0*/
    
      --crear_int_plataforma_bscs();
    
      --crear_telefonia_ce_det();
      l_idtrans := crear_int_plataforma_bscs(p_idwf,
                                             /*l_numslc*/lineas.numslc,
                                             lineas.codinssrv,
                                             lineas.numero);
    
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
    
      pq_janus_ce_conexion.enviar_solicitud(lineas.idtrans,
                                            lineas.id_telefonia_ce_det);
    
      select t.ws_error_dsc
        into l_ws_error_dsc
        from operacion.telefonia_ce_det t
       where t.id_telefonia_ce_det = lineas.id_telefonia_ce_det;
    
      insert into tareawfseg
        (idtareawf, observacion)
      values
        (p_idtareawf, l_ws_error_dsc);
    
      update telefonia_ce_det t
         set t.id_sga_error = 0, t.sga_error_dsc = 'OK', t.verificado = 0
       where t.id_telefonia_ce_det = lineas.id_telefonia_ce_det;

      --pq_janus_ce.update_int_plataforma_bscs();
    
      --pq_janus_ce.crear_tareawfseg();
    
      --pq_telefonia_ce.update_telefonia_ce_det();
    
    END LOOP;
    
    update operacion.telefonia_ce t
        set t.id_error = 0, t.mensaje = 'Registro satisfactorio'
      where t.id_telefonia_ce = l_id_telefonia_ce;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000, $$PLSQL_UNIT || '.ALTA: ' || SQLERRM);
  END;
  /* ***************************************************************************/
  PROCEDURE set_variables_genericas IS
  BEGIN
    null; 
    /*g_linea    := get_linea();
    g_cliente  := get_cliente();
    g_sucursal := get_sucursal();
    g_plan     := get_plan();*/
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.SET_VARIABLES_GENERICAS: ' ||
                              SQLERRM);
  END;
  /* **********************************************************************************************/
  PROCEDURE set_linea_x_servicio(p_pid       insprd.pid%TYPE,
                                 p_numslc    insprd.numslc%TYPE, --3.0
                                 p_codinssrv inssrv.codinssrv%TYPE,
                                 p_numero    inssrv.numero%TYPE) IS
  BEGIN
    null; 
    /*g_pid       := p_pid;
    g_numslc    := p_numslc; --3.0
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
    l_log telefonia_ce_det%ROWTYPE;
  
  BEGIN
    /*l_log.id_telefonia_ce := pq_telefonia_ce.get_id();
    l_log.codinssrv       := g_codinssrv;
    l_log.numero          := g_numero;
    l_log.pid             := g_pid;
    l_log.idtrans         := pq_janus_ce.g_idtrans;
    l_log.action_id       := pq_telefonia_ce.g_operacion;*/
    l_log.verificado      := 0;
    l_log.ws_envios       := 0;
  
    pq_telefonia_ce.insert_telefonia_ce_det(l_log);
  
    --pq_telefonia_ce_det.g_id_telefonia_ce_det := l_log.id_telefonia_ce_det;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.CREAR_TELEFONIA_CE_DET: ' ||
                              SQLERRM);
  END;
  /* ***************************************************************************/
  PROCEDURE crear_int_plataforma_bscs IS
    --C_ALTA CONSTANT int_plataforma_bscs.action_id%TYPE := 1;
    --l_bscs int_plataforma_bscs%ROWTYPE;
  
  BEGIN
  
    null;
    /*l_bscs.codigo_cliente := g_linea.codcli;*/ --3.0
    /*l_bscs.codigo_cliente := g_numslc;           --3.0
    l_bscs.codigo_cuenta  := pq_janus_ce.get_conf('P_HCCD') || g_linea.codcli;
    l_bscs.ruc            := g_cliente.ruc;
    l_bscs.nombre         := g_cliente.nomclires;
    l_bscs.apellidos      := g_cliente.apellidos;
    l_bscs.tipdide        := g_cliente.tipdide;
    l_bscs.ntdide         := g_cliente.ntdide;
    l_bscs.razon          := g_cliente.razon;
    l_bscs.telefonor1     := g_cliente.telefono1;
    l_bscs.telefonor2     := g_cliente.telefono2;
    l_bscs.email          := get_nomemail();
    l_bscs.direccion      := g_sucursal.dirsuc;
    l_bscs.referencia     := g_sucursal.referencia;
    l_bscs.distrito       := g_sucursal.nomdst;
    l_bscs.provincia      := g_sucursal.nompvc;
    l_bscs.departamento   := g_sucursal.nomest;
    l_bscs.co_id          := g_codinssrv;
    l_bscs.numero         := g_numero;
    l_bscs.imsi           := pq_janus_ce.get_conf('P_IMSI') || g_numero;
    --l_bscs.ciclo          := get_fecini(g_linea.numslc);--2.0
    l_bscs.ciclo          := get_ciclo();--2.0
    l_bscs.action_id      := C_ALTA;
    l_bscs.trama          := armar_trama();
    l_bscs.plan_base      := g_plan.plan;
    l_bscs.plan_opcional  := g_plan.plan_opcional;
    pq_janus_ce.insert_int_plataforma_bscs(l_bscs);
  
    pq_janus_ce.g_idtrans   := l_bscs.idtrans;
    pq_janus_ce.g_action_id := C_ALTA;*/
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.CREAR_INT_PLATAFORMA_BSCS: ' ||
                              SQLERRM);
  END;
  /* ***************************************************************************/
  
  function crear_telefonia_ce_det(p_telefonia_ce operacion.telefonia_ce%rowtype,
                                  p_codinssrv    inssrv.codinssrv%type,
                                  p_numero       numtel.numero%type,
                                  p_pid          insprd.pid%type,
                                  p_idtrans      operacion.int_plataforma_bscs.idtrans%type)
    return operacion.telefonia_ce_det.id_telefonia_ce_det%type is
    l_det operacion.telefonia_ce_det%rowtype;
    c_alta constant operacion.int_plataforma_bscs.action_id%type := 1;
  
  begin
    l_det.id_telefonia_ce := p_telefonia_ce.id_telefonia_ce;
    l_det.codinssrv       := p_codinssrv;
    l_det.numero          := p_numero;
    l_det.pid             := p_pid;
    l_det.idtrans         := p_idtrans;
    l_det.action_id       := c_alta/*p_telefonia_ce.operacion*/;
    l_det.verificado      := 0;
  
    pq_telefonia_ce.insert_telefonia_ce_det(l_det);
  
    return l_det.id_telefonia_ce_det;
  
  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit || '.crear_telefonia_ce_det: ' ||
                              sqlerrm);
  end;
  /* ***************************************************************************/
  function crear_int_plataforma_bscs(p_idwf      tareawf.idwf%type,
                                     p_numslc    vtatabslcfac.numslc%type,
                                     p_codinssrv inssrv.codinssrv%type,
                                     p_numero    numtel.numero%type)
    return operacion.int_plataforma_bscs.idtrans%type is
    c_alta constant operacion.int_plataforma_bscs.action_id%type := 1;
    l_linea    linea;
    l_cliente  cliente;
    l_sucursal sucursal%rowtype;
    l_plan     plan%rowtype;
    l_bscs     operacion.int_plataforma_bscs%rowtype;
  
  begin
    l_linea        := get_linea(p_idwf);
    l_cliente      := get_cliente(l_linea.codcli);
    l_sucursal     := get_sucursal(l_linea.numslc);
    l_plan         := get_plan(l_linea.idplan);
    l_linea.numslc := p_numslc;

    l_bscs.codigo_cliente := p_numslc;
    l_bscs.codigo_cuenta  := operacion.pq_janus_ce.get_conf('P_HCCD') ||
                             l_linea.codcli;
    l_bscs.ruc            := l_cliente.ruc;
    l_bscs.nombre         := l_cliente.nomclires;
    l_bscs.apellidos      := l_cliente.apellidos;
    l_bscs.tipdide        := l_cliente.tipdide;
    l_bscs.ntdide         := l_cliente.ntdide;
    l_bscs.razon          := l_cliente.razon;
    l_bscs.telefonor1     := l_cliente.telefono1;
    l_bscs.telefonor2     := l_cliente.telefono2;
    l_bscs.email          := get_nomemail(l_linea.codcli);
    l_bscs.direccion      := substr(l_sucursal.dirsuc, 1, 40);
    l_bscs.referencia     := l_sucursal.referencia;
    l_bscs.distrito       := l_sucursal.nomdst;
    l_bscs.provincia      := l_sucursal.nompvc;
    l_bscs.departamento   := l_sucursal.nomest;
    l_bscs.co_id          := p_codinssrv;
    l_bscs.numero         := p_numero;
    l_bscs.imsi           := pq_janus_ce.get_conf('P_IMSI') || p_numero;
    l_bscs.ciclo          := get_ciclo();
    l_bscs.action_id      := c_alta;
    l_bscs.trama          := armar_trama(l_linea,
                                         l_cliente,
                                         l_sucursal,
                                         l_plan,
                                         p_codinssrv,
                                         p_numero);
    l_bscs.plan_base      := l_plan.plan;
    l_bscs.plan_opcional  := l_plan.plan_opcional;
    l_bscs.codusu         := user;
    l_bscs.fecusu         := sysdate;
  
    l_bscs.idtrans := pq_janus_ce.insert_int_plataforma_bscs(l_bscs);
  
    return l_bscs.idtrans;
  
    --operacion.pq_janus_ce.g_idtrans   := l_bscs.idtrans;
    --todo: operacion.pq_janus_ce.g_action_id := c_alta;
  
  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit || '.crear_int_plataforma_bscs: ' ||
                              sqlerrm);
  end;
  /* ***************************************************************************/
  function get_ciclo return opedd.codigoc%type is/*****2.0*****/
    l_ciclo opedd.codigoc%type;

  begin
    select d.codigoc
      into l_ciclo
      from tipopedd c, opedd d
     where c.abrev = 'PLAT_JANUS_CE'
       and c.tipopedd = d.tipopedd
       and d.abreviacion = 'CICLO';

    return l_ciclo;

  exception
    when others then
      RAISE_APPLICATION_ERROR(-20000,
                              $$plsql_unit || '.get_ciclo: ' || sqlerrm);
  end;/******2.0******/
  /* ***************************************************************************/
  FUNCTION get_linea(p_idwf tareawf.idwf%type)  RETURN linea IS
    l_linea linea;
  
  BEGIN
    SELECT e.codcli, e.numslc, h.idplan, g.codsolot
      INTO l_linea
      FROM wf          d,
           solotpto    a,
           insprd      b,
           tystabsrv   c,
           inssrv      e,
           solot       g,
           plan_redint h
     WHERE d.idwf = p_idwf--pq_telefonia_ce.g_idwf
       AND a.codsolot = d.codsolot
       AND a.pid = b.pid
        --and i.flgprinc = 1
        --el plan no esta asociado al producto principal sino a las lineas adicionales
       AND e.tipinssrv = 3
       AND c.idplan = h.idplan
       AND h.idtipo IN (2, 3) --control, prepago
       AND b.codsrv = c.codsrv
       AND e.codinssrv = b.codinssrv
       AND a.codsolot = g.codsolot;

    RETURN l_linea;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              --$$PLSQL_UNIT || '.GET_LINEA: ' || SQLERRM);
                              $$plsql_unit || '.get_linea(p_idwf => ' || p_idwf || ') ' ||
                              sqlerrm);
  END;
  /* ***************************************************************************/
  FUNCTION get_cliente(p_codcli vtatabcli.codcli%type) RETURN cliente IS
    l_cliente cliente;
  
  BEGIN
    SELECT vc.tipdide,
           vc.ntdide,
           REPLACE(vc.apepatcli, '|', ' ') || ' ' ||
           REPLACE(vc.apematcli, '|', ' ') apellidos,
           REPLACE(vc.nomclires, '|', ' '),
           DECODE(vc.tipdide, '001', vc.ntdide, NULL) AS ruc,
           REPLACE(vc.nomcli, '|', ' ') AS razon,
           vc.telefono1,
           vc.telefono2
      INTO l_cliente
      FROM vtatabcli vc
     WHERE vc.codcli = p_codcli/*g_linea.codcli*/;
  
    RETURN l_cliente;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              --$$PLSQL_UNIT || '.GET_CLIENTE: ' || SQLERRM);
                              $$plsql_unit || '.get_cliente(p_codcli => ' ||
                              p_codcli || ') ' || sqlerrm);
  END;
  /* ***************************************************************************/
  FUNCTION get_sucursal(p_numslc vtatabslcfac.numslc%type)
     RETURN sucursal%ROWTYPE IS
    l_sucursal sucursal%ROWTYPE;
  
  BEGIN
    SELECT REPLACE(vsuc.dirsuc, '|', ' ') dirsuc,
           REPLACE(vsuc.referencia, '|', ' ') referencia,
           vu.nomdst,
           vu.nompvc,
           vu.nomest
      INTO l_sucursal
      FROM vtasuccli vsuc,
           (SELECT DISTINCT codsuc
              FROM vtadetptoenl vdet
             WHERE vdet.numslc = p_numslc/*g_linea.numslc*/) vv,
           v_ubicaciones vu
     WHERE vsuc.codsuc = vv.codsuc
       AND vsuc.ubisuc = vu.codubi(+);
  
    RETURN l_sucursal;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              --$$PLSQL_UNIT || '.GET_SUCURSAL: ' || SQLERRM);
                              $$plsql_unit || '.get_sucursal(p_numslc => ' ||
                              p_numslc || ') ' || sqlerrm);
  END;
  /* ***************************************************************************/
  FUNCTION get_plan(p_idplan plan_redint.idplan%type) RETURN plan%ROWTYPE IS
    l_plan plan%ROWTYPE;
  
  BEGIN
    SELECT t.plan, t.plan_opcional
      INTO l_plan
      FROM plan_redint t
     WHERE t.idplan = p_idplan/*g_linea.idplan*/;
  
    RETURN l_plan;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000, $$PLSQL_UNIT || '.GET_PLAN: ' || SQLERRM);
  END;
  /* ***************************************************************************/
  FUNCTION get_nomemail(p_codcli vtatabcli.codcli%type) 
    RETURN vtaafilrecemail.nomemail%TYPE IS
    l_nomemail vtaafilrecemail.nomemail%TYPE;
  
  BEGIN
    SELECT z.nomemail
      INTO l_nomemail
      FROM (SELECT v.nomemail
              FROM marketing.vtaafilrecemail v
             WHERE v.codcli = p_codcli--g_linea.codcli
             ORDER BY v.fecusu DESC) z
     WHERE ROWNUM = 1;
  
    RETURN l_nomemail;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN NULL;
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              --$$PLSQL_UNIT || '.GET_NOMEMAIL: ' || SQLERRM);
                              $$plsql_unit || '.get_nomemail(p_codcli => ' ||
                              p_codcli || ') ' || sqlerrm);
  END;
  /* ***************************************************************************/
  FUNCTION get_fecini(p_numslc vtatabslcfac.numslc%TYPE) RETURN VARCHAR2 IS
    l_dia    NUMBER;
    l_cicfac NUMBER;
  
  BEGIN
    l_dia    := pq_transfer_billing.f_get_dia_inicio(p_numslc);
    l_cicfac := pq_transfer_billing.f_obtiene_ciclo(6, l_dia);
  
    RETURN get_fecini(l_cicfac);
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.GET_FECINI: ' || SQLERRM);
  END;
  /* ***************************************************************************/
  FUNCTION get_fecini(p_cicfac fechaxciclo.cicfac%TYPE) RETURN VARCHAR2 IS
    l_fecini_cicfac VARCHAR2(2);
  
  BEGIN
    SELECT DISTINCT (TO_CHAR(fecini, 'DD'))
      INTO l_fecini_cicfac
      FROM fechaxciclo
     WHERE cicfac = p_cicfac;
  
    RETURN l_fecini_cicfac;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN '01';
  END;
  /* ***************************************************************************/
  FUNCTION armar_trama(p_linea     linea,
                       p_cliente   cliente,
                       p_sucursal  sucursal%rowtype,
                       p_plan      plan%rowtype,
                       p_codinssrv inssrv.codinssrv%type,
                       p_numero    numtel.numero%type) RETURN VARCHAR2 IS
    l_trama VARCHAR2(32767);
  
  BEGIN
    /*l_trama := pq_janus_ce.get_conf('P_HCON') || g_linea.codcli || '|';*/ --3.0
    l_trama := pq_janus_ce.get_conf('P_COD_CUENTA')||p_linea.numslc/*g_numslc*/ || '|';       --3.0
    l_trama := l_trama || pq_janus_ce.get_conf('P_HCCD') || p_linea/*g_linea*/.codcli || '|';
    l_trama := l_trama || p_cliente/*g_cliente*/.ruc || '|';
    l_trama := l_trama || p_cliente/*g_cliente*/.nomclires || '|';
    l_trama := l_trama || p_cliente/*g_cliente*/.apellidos || '|';
    l_trama := l_trama || p_cliente/*g_cliente*/.tipdide || '|';
    l_trama := l_trama || p_cliente/*g_cliente*/.ntdide || '|';
    l_trama := l_trama || p_cliente/*g_cliente*/.razon || '|';
    l_trama := l_trama || p_cliente/*g_cliente*/.telefono1 || '|';
    l_trama := l_trama || p_cliente/*g_cliente*/.telefono2 || '|';
    l_trama := l_trama || get_nomemail(p_linea.codcli) || '|';
    l_trama := l_trama || trim_dato('DIRSUC', p_sucursal/*g_sucursal*/.dirsuc) || '|';
    l_trama := l_trama || trim_dato('REFERENCIA', p_sucursal/*g_sucursal*/.referencia) || '|';
    l_trama := l_trama || p_sucursal/*g_sucursal*/.nomdst || '|';
    l_trama := l_trama || p_sucursal/*g_sucursal*/.nompvc || '|';
    l_trama := l_trama || p_sucursal/*g_sucursal*/.nomest || '|';
    l_trama := l_trama || p_codinssrv/*g_codinssrv*/ || '|';
    l_trama := l_trama || p_numero/*g_numero*/ || '|';
    l_trama := l_trama || pq_janus_ce.get_conf('P_IMSI') || p_numero/*g_numero*/ || '|';
    --l_trama := l_trama || get_fecini(g_linea.numslc) || '|';--2.0
    l_trama := l_trama || get_ciclo() || '|';--2.0
    l_trama := l_trama || p_plan/*g_plan*/.plan || '|';
    l_trama := l_trama || p_plan/*g_plan*/.plan_opcional;
  
    encode(l_trama);
  
    RETURN l_trama;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.ARMAR_TRAMA: ' || SQLERRM);
  END;
  /* ***************************************************************************/
  function get_telefonia_ce(p_id_telefonia_ce operacion.telefonia_ce.id_telefonia_ce%type)
    return operacion.telefonia_ce%rowtype is
    l_telefonia_ce operacion.telefonia_ce%rowtype;
  
  begin
    select t.*
      into l_telefonia_ce
      from operacion.telefonia_ce t
     where t.id_telefonia_ce = p_id_telefonia_ce;
  
    return l_telefonia_ce;
  
  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit ||
                              '.get_telefonia_ce(p_id_telefonia_ce => ' ||
                              p_id_telefonia_ce || ') ' || sqlerrm);
  end;
  /* ***************************************************************************/
  FUNCTION trim_dato(p_dato VARCHAR2, p_string VARCHAR2) RETURN VARCHAR2 IS
    l_length opedd.codigon%TYPE;
  
  BEGIN
    SELECT d.codigon
      INTO l_length
      FROM tipopedd c, opedd d
     WHERE c.abrev = 'PLAT_JANUS_CE'
       AND c.tipopedd = d.tipopedd
       AND d.abreviacion = p_dato;
  
    RETURN SUBSTR(p_string, 1, l_length);
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.TRIM_DATO: ' || SQLERRM);
  END;
  /* ***************************************************************************/
  PROCEDURE encode(p_string IN OUT VARCHAR2) IS
  BEGIN
    p_string := REPLACE(p_string, chr(209), chr(78));
    p_string := REPLACE(p_string, chr(38), chr(32));
    p_string := CONVERT(p_string, 'US7ASCII', 'WE8ISO8859P1');
  END;
  /* ***************************************************************************/
END;
/