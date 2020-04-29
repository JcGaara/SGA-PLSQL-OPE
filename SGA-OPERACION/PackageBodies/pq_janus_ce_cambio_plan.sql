create or replace package body operacion.pq_janus_ce_cambio_plan is
  /*******************************************************************************
   PROPOSITO: Habilitación de Planes Control Wimax CE en JANUS
     
   REVISIONES:
     Version  Fecha       Autor          Solicitado por      Descripcion
     -------  -----       -----          --------------      -----------
     1.0      17/12/2014  Edwin Vasquez  Christian Riquelme  Claro Empresas WiMAX
     2.0      15/05/2015  Jose Varillas  Giovanni Vasquez    Claro Empresas Cambio de Plan
     3.0      15/05/2015  Jose Varillas  Giovanni Vasquez    
	 4.0	  11/11/2015  Jose Varillas  Giovanni Vasquez	 SD_533380
	 4.0	  18/12/2015  Jose Varillas  Giovanni Vasquez	 SD_600307
  /* ****************************************************************************/
  procedure cambio_plan(p_idtareawf tareawf.idtareawf%type,
                        p_idwf      tareawf.idwf%type,
                        p_tarea     tareawf.tarea%type,
                        p_tareadef  tareawf.tareadef%type) is
    l_origen  varchar2(30);
    l_destino varchar2(30);
	
    ln_valida 		number;
    ln_out          number;
    lv_mensaje      varchar2(400);
    lv_customer_id  varchar2(400);
    ln_codplan      number;
    lv_producto     varchar2(400);
    ld_fecini       date;
    lv_estado       varchar2(400);
    lv_ciclo        varchar2(400);
    ln_janus        number;	
	
    cursor c_lineas(c_idwf number) is

      select e.numslc, e.codinssrv, e.numero, b.pid
        from wf d, solotpto a, insprd b, tystabsrv c, inssrv e, solot g
       where d.idwf = c_idwf
         and a.codsolot = d.codsolot
         and a.pid = b.pid
         and e.tipinssrv = 3
         and b.codsrv = c.codsrv
         and e.codinssrv = b.codinssrv
         and a.codsolot = g.codsolot
         and b.flgprinc = 1
         and e.cid is not null
         and e.numero in (select e.numero
                            from wf d, solotpto a, insprd b, inssrv e
                           where d.idwf = operacion.pq_janus_ce_cambio_plan.get_idwf_origen(c_idwf)
                             and a.codsolot = d.codsolot
                             and a.pid = b.pid
                             and e.tipinssrv = 3
                             and e.codinssrv = b.codinssrv
                             and b.flgprinc = 1
                             and e.cid is not null);    

  begin
    
    ln_janus  := 0;
    --Verificar Existencia de Lineas en JANUS
    For lc_lineas in c_lineas(p_idwf) loop
      
      operacion.pq_sga_iw.p_cons_linea_janus(lc_lineas.numero,ln_out,lv_mensaje,lv_customer_id,ln_codplan,lv_producto,ld_fecini,lv_estado,lv_ciclo);
      
      if ln_out = 1 then
        ln_janus := ln_janus + 1;
      end if;
      
    end loop;
    
    if ln_janus > 0 then
      l_origen := 'JANUS';
    else
      l_origen  := get_plataforma_origen(p_idwf);
    end if;
    l_destino := get_plataforma_destino(p_idwf);
  
    select to_number(c.valor)
     into ln_valida
      from constante c
     where c.constante = 'CPLAN_CE_JANUS';
	 
    if (l_origen = l_destino) and (l_destino = 'JANUS') then
      validar_plan(p_idtareawf, p_idwf, p_tarea, p_tareadef);
      
    elsif l_origen = 'JANUS' and
          (l_destino = 'ABIERTA' or l_destino = 'TELLIN' or l_destino = 'NINGUNO') then
    
       alta_baja_cplan_plataformas(p_idtareawf,
                                   p_idwf,
                                   p_tarea,
                                   p_tareadef,
                                   2); --Baja
       if ln_valida = 0 then
         consumir_ws(p_idtareawf,p_idwf);
       end if;

    elsif (l_origen = 'ABIERTA' or l_origen = 'TELLIN' or l_destino = 'NINGUNO') and
          l_destino = 'JANUS' then

       alta_baja_cplan_plataformas(p_idtareawf,
                                   p_idwf,
                                   p_tarea,
                                   p_tareadef,
                                   1); --Alta

       if ln_valida = 0 then
         consumir_ws(p_idtareawf,p_idwf);
       end if;
    elsif (l_origen = 'ABIERTA' or l_origen = 'TELLIN') and
          l_destino = 'ABIERTA' then
      pq_telefonia_ce.no_interviene(p_idtareawf);
      
    elsif (l_origen = 'ABIERTA' or l_origen = 'TELLIN') and
          l_destino = 'TELLIN' then
      pq_telefonia_ce.no_interviene(p_idtareawf);
	
	else
	  pq_telefonia_ce.no_interviene(p_idtareawf);
      
    end if;
  
  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit ||
                              '.cambio_plan(p_idtareawf => ' || p_idtareawf ||
                              ', p_idwf => ' || p_idwf  || ') ' ||
                              sqlerrm);
  end;
  --------------------------------------------------------------------------------
  procedure validar_plan(p_idtareawf tareawf.idtareawf%type,
                         p_idwf      tareawf.idwf%type,
                         p_tarea     tareawf.tarea%type,
                         p_tareadef  tareawf.tareadef%type) is
    l_idwf_old    wf.idwf%type;
    l_srv_origen  tystabsrv.codsrv%type;
    l_srv_destino tystabsrv.codsrv%type;
    l_cant_orig   number;
    l_cant_dest   number;
    l_linea       linea;
  
    ln_valida number;
    ln_error number;
    lv_error varchar2(1000);

  begin
    if not pq_telefonia_ce.existe_reserva(p_idwf) then
      raise_application_error(-20000,
                              $$plsql_unit ||
                              'LOS NUMEROS TELEFONICOS NO CUENTAN CON RESERVA');
    end if;
  
    l_linea := get_linea(p_idwf);
  
    l_srv_origen  := get_codsrv(l_linea.pid_old);
    l_srv_destino := get_codsrv(l_linea.pid);
  
    l_idwf_old  := get_idwf_origen(p_idwf);
    l_cant_orig := get_cant_num(l_idwf_old);
    l_cant_dest := get_cant_num(p_idwf);
  
    select to_number(c.valor)
     into ln_valida
      from constante c
     where c.constante = 'CPLAN_CE_JANUS';

    if l_srv_origen = l_srv_destino then
      if l_cant_orig = l_cant_dest then
        pq_telefonia_ce.no_interviene(p_idtareawf);
        return;
        
      elsif l_cant_orig <> l_cant_dest then
        if l_cant_orig > l_cant_dest then
          alta_baja_cplan(p_idtareawf, p_idwf, p_tarea, p_tareadef, 2); --Baja
          
        else
          alta_baja_cplan(p_idtareawf, p_idwf, p_tarea, p_tareadef, 1); --Alta
          
        end if;
        if ln_valida = 0 then
          consumir_ws(p_idtareawf,p_idwf);
        end if;
      end if;
    end if;
  
    if l_srv_origen <> l_srv_destino then
      if l_cant_orig = l_cant_dest then

        cambio_janus(p_idtareawf, p_idwf, p_tarea, p_tareadef);
        if ln_valida = 0 then
          consumir_ws(p_idtareawf,p_idwf);
        else
          -- Cambio de Plan Janus - DBLINK
          operacion.pq_cont_regularizacion.p_cambio_plan_janus_ce(l_linea.codsolot, ln_error, lv_error);
        end if;
        
      elsif l_cant_orig <> l_cant_dest then
        if ln_valida = 0 then
          --if l_cant_orig > l_cant_dest then
            --cambio_janus_proceso(p_idtareawf, p_idwf, p_tarea, p_tareadef);
            --alta_baja_cplan(p_idtareawf, p_idwf, p_tarea, p_tareadef, 2); --Baja
          
          --else
            cambio_janus_proceso(p_idtareawf, p_idwf, p_tarea, p_tareadef);
            --alta_baja_cplan(p_idtareawf, p_idwf, p_tarea, p_tareadef, 1); --Alta
          
          --end if;
        else
          if l_cant_orig > l_cant_dest then
            cambio_janus(p_idtareawf, p_idwf, p_tarea, p_tareadef);
            -- Lineas que se Mantienen
            operacion.pq_cont_regularizacion.p_cambio_plan_janus_ce(l_linea.codsolot, ln_error, lv_error);
            -- Lineas de Baja
            alta_baja_cplan(p_idtareawf, p_idwf, p_tarea, p_tareadef, 2); --Baja
          else
            cambio_janus(p_idtareawf, p_idwf, p_tarea, p_tareadef);
            -- Lineas que se Mantienen
            operacion.pq_cont_regularizacion.p_cambio_plan_janus_ce(l_linea.codsolot, ln_error, lv_error);
            -- Lineas de Alta
            alta_baja_cplan(p_idtareawf, p_idwf, p_tarea, p_tareadef, 1); --Alta
          end if;
        end if;
      end if;
      --consumir_ws(p_idtareawf,p_idwf);
    end if;
  
  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit ||
                              '.validar_plan(p_idtareawf => ' || p_idtareawf ||
                              ', p_idwf => ' || p_idwf || ') ' ||
                              ' ) ' || sqlerrm);
  end;
  --------------------------------------------------------------------------------
  procedure cambio_janus_proceso(p_idtareawf tareawf.idtareawf%type,
                                 p_idwf      tareawf.idwf%type,
                                 p_tarea     tareawf.tarea%type,
                                 p_tareadef  tareawf.tareadef%type) is
  
    l_codsolot            solot.codsolot%type;
    l_id_telefonia_ce     telefonia_ce.id_telefonia_ce%type;
    l_telefonia_ce        telefonia_ce%rowtype;
    l_idtrans             int_plataforma_bscs.idtrans%type;
    l_id_telefonia_ce_det telefonia_ce_det.id_telefonia_ce_det%type;
    l_cantidad            number;
    c_cambioplan          constant telefonia_ce.operacion%type := 16;
    c_baja                constant telefonia_ce.operacion%type := 2;
    l_idwf_old            tareawf.idwf%type;
    l_tipsrv              tystipsrv.tipsrv%type;
    l_numslc              vtatabslcfac.numslc%type;
    l_total               pls_integer;
    l_enviadas            pls_integer;
    
    /*cursor registro_lineas(p_idwf     tareawf.idwf%type,
                           p_idwf_old tareawf.idwf%type) is
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
         and e.cid is not null
         and e.numero in (select e.numero
                            from wf d, solotpto a, insprd b, inssrv e
                           where d.idwf = p_idwf_old
                             and a.codsolot = d.codsolot
                             and a.pid = b.pid
                             and e.tipinssrv = 3
                             and e.codinssrv = b.codinssrv
                             and b.flgprinc = 1
                             and e.cid is not null);*/
                             
     cursor registro_lineas(p_idwf           tareawf.idwf%type) is
        select f.codinssrv, ins.numero, f.pid
          from wf a,
               tystabsrv b,
               (select a.codsolot, b.codinssrv, max(c.pid) pid
                  from solotpto a, inssrv b, insprd c
                 where a.codinssrv = b.codinssrv
                   and b.tipinssrv = 3
                   and b.codinssrv = c.codinssrv
                   and c.flgprinc = 1
                 group by a.codsolot, b.codinssrv) e,
               insprd f,
               inssrv ins
         where a.idwf = p_idwf
           and a.codsolot = e.codsolot
           and f.codinssrv = e.codinssrv
           and f.pid = e.pid
           and f.codsrv = b.codsrv
           and b.codsrv not in
               (select d.codigoc
                  from tipopedd c, opedd d
                 where c.abrev = 'CFAXSERVER'
                   and c.tipopedd = d.tipopedd
                   and d.abreviacion = 'CFAXSERVER_SRV')
           and e.codinssrv = ins.codinssrv;                        

  begin
    select t.codsolot into l_codsolot from wf t where t.idwf = p_idwf;
    l_numslc := get_proyecto_origen(p_idwf);
    
    l_idwf_old := get_idwf_origen(p_idwf);
    l_total    := operacion.PQ_JANUS_CE_BAJA.get_lineas_restantes(l_idwf_old);
    l_enviadas := 0;
    
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
    
    l_telefonia_ce := pq_janus_ce_alta.get_telefonia_ce(l_id_telefonia_ce);
    
    for linea in registro_lineas(l_idwf_old) loop
        l_enviadas := l_enviadas + 1;
          
        l_idtrans := operacion.pq_janus_ce_baja.crear_int_plataforma_bscs(linea.numero,
                                                                          linea.codinssrv,
                                                                          l_total -
                                                                          l_enviadas);
          
        l_id_telefonia_ce_det := operacion.pq_janus_ce_baja.crear_telefonia_ce_det(l_telefonia_ce,
                                                                                   linea.codinssrv,
                                                                                   linea.numero,
                                                                                   linea.pid,
                                                                                   l_idtrans);
                                                                                   
        update int_plataforma_bscs
           set action_id = c_baja, codigo_cliente = l_numslc
         where idtrans = l_idtrans;
         
        update telefonia_ce_det
           set action_id = c_baja
         where id_telefonia_ce_det = l_id_telefonia_ce_det; 
                                                                                
    end loop;
                                                      
    /*update int_plataforma_bscs ipb
       set ipb.codigo_cliente = l_numslc
     where exists
           (select '1'
              from operacion.telefonia_ce tc, operacion.telefonia_ce_det tcd
             where tc.id_telefonia_ce = tcd.id_telefonia_ce
               and tcd.idtrans = ipb.idtrans
               and tc.id_telefonia_ce = l_id_telefonia_ce);*/
    
     update telefonia_ce
        set operacion = c_cambioplan
      where idtareawf = p_idtareawf
        and idwf = p_idwf
        and tarea = p_tarea
        and tareadef = p_tareadef;
       
    operacion.pq_janus_ce_alta.alta(p_idtareawf, p_idwf, p_tarea, p_tareadef);
        
  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit ||
                              '.cambio_janus_proceso(p_idtareawf => ' || p_idtareawf ||
                              ', p_idwf => ' || p_idwf || ' ) ' ||
                              sqlerrm);
  end;
  ------------------------------------------------------------
  procedure cambio_janus(p_idtareawf tareawf.idtareawf%type,
                         p_idwf      tareawf.idwf%type,
                         p_tarea     tareawf.tarea%type,
                         p_tareadef  tareawf.tareadef%type) is
  
    l_codsolot            solot.codsolot%type;
    l_id_telefonia_ce     telefonia_ce.id_telefonia_ce%type;
    l_telefonia_ce        telefonia_ce%rowtype;
    l_idtrans             int_plataforma_bscs.idtrans%type;
    l_id_telefonia_ce_det telefonia_ce_det.id_telefonia_ce_det%type;
    l_cantidad            number;
    c_cambioplan          constant telefonia_ce.operacion%type := 16;
    l_idwf_old            tareawf.idwf%type;
    l_tipsrv              tystipsrv.tipsrv%type;
    
    cursor registro_lineas(p_idwf     tareawf.idwf%type,
                           p_idwf_old tareawf.idwf%type) is
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
         and e.cid is not null
         and e.numero in (select e.numero
                            from wf d, solotpto a, insprd b, inssrv e
                           where d.idwf = p_idwf_old
                             and a.codsolot = d.codsolot
                             and a.pid = b.pid
                             and e.tipinssrv = 3
                             and e.codinssrv = b.codinssrv
                             and b.flgprinc = 1
                             and e.cid is not null);

  begin
    select t.codsolot into l_codsolot from wf t where t.idwf = p_idwf;
  
    select count(*)
      into l_cantidad
      from telefonia_ce
     where idtareawf = p_idtareawf
       and idwf = p_idwf
       and tarea = p_tarea
       and tareadef = p_tareadef;
  
    if l_cantidad = 0 then
      l_tipsrv := get_tipsrv(l_codsolot);
      
      insert into telefonia_ce
        (idtareawf, idwf, tarea, tareadef, codsolot, operacion, tipsrv)
      values
        (p_idtareawf,p_idwf,p_tarea,p_tareadef,l_codsolot,c_cambioplan,l_tipsrv)
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
  
    l_idwf_old := get_idwf_origen(p_idwf);
  
    for linea in registro_lineas(p_idwf, l_idwf_old) loop
    
      l_idtrans             := crear_int_plataforma_bscs(p_idwf,
                                                         linea.codinssrv,
                                                         linea.numero);
      l_id_telefonia_ce_det := pq_janus_ce_alta.crear_telefonia_ce_det(l_telefonia_ce,
                                                                       linea.codinssrv,
                                                                       linea.numero,
                                                                       linea.pid,
                                                                       l_idtrans);
    
      update telefonia_ce_det
         set action_id = c_cambioplan
       where id_telefonia_ce_det = l_id_telefonia_ce_det;
                                                                          
    end loop;
  
  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit ||
                              '.cambio_janus(p_idtareawf => ' || p_idtareawf ||
                              ', p_idwf => ' || p_idwf || ' ) ' ||
                              sqlerrm);
  end;
  --------------------------------------------------------------------------------
  function crear_int_plataforma_bscs(p_idwf      tareawf.idwf%type,
                                     p_codinssrv inssrv.codinssrv%type,
                                     p_numero    numtel.numero%type)
    return int_plataforma_bscs.idtrans%type is
  
    c_cambio_plan constant pls_integer := 16;
    l_int_bscs  int_plataforma_bscs%rowtype;
    l_linea     linea;
    l_linea_old int_plataforma_bscs%rowtype;
    l_numslc    vtatabslcfac.numslc%type;
      
  begin
      
    l_numslc := get_proyecto_origen(p_idwf);
    
    l_linea     := get_linea(p_idwf);
    l_linea_old := get_linea_old(l_linea);
  
    l_int_bscs.codigo_cliente    := l_numslc;
    l_int_bscs.co_id             := p_codinssrv;
    l_int_bscs.numero            := p_numero;
    l_int_bscs.action_id         := c_cambio_plan;
    l_int_bscs.trama             := armar_trama(l_numslc, p_codinssrv,l_linea.plan, l_linea.plan_opcional);
    l_int_bscs.plan_base         := l_linea.plan;
    l_int_bscs.plan_opcional     := l_linea.plan_opcional;
    l_int_bscs.plan_old          := l_linea_old.plan_base;
    l_int_bscs.plan_opcional_old := l_linea_old.plan_opcional;
    l_int_bscs.imsi              := pq_janus.get_conf('P_IMSI') || p_numero;
    l_int_bscs.imsi_old          := l_linea_old.imsi;
    pq_janus.insert_int_plataforma_bscs(l_int_bscs);
  
    return l_int_bscs.idtrans;
  
  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit ||
                              '.crear_int_plataforma_bscs(p_idwf => ' || p_idwf ||
                              ' ,p_codinssrv => '||p_codinssrv||
                              ',p_numero => ' || p_numero || ') ' ||
                               sqlerrm);
  end;
  --------------------------------------------------------------------------------------------
  function get_idwf_origen(p_idwf wf.idwf%type) return varchar2 is
    l_idwf wf.idwf%type;
  
  begin
    select tt.idwf
      into l_idwf
      from wf t, solot s, regvtamentab r, solot ss, wf tt
     where t.idwf = p_idwf
       and t.codsolot = s.codsolot
       and s.numslc = r.numslc
       and r.numslc_ori = ss.numslc
       and ss.codsolot = tt.codsolot
       and tt.valido = 1;
  
    return l_idwf;
  
  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit ||
                              '.get_idwf_origen( p_idwf => ' || p_idwf || ') ' ||
                              sqlerrm);
  end;
  --------------------------------------------------------------------------------
  function get_plataforma_origen(p_idwf wf.idwf%type) return varchar2 is
    l_idwf wf.idwf%type;
  begin
    l_idwf := get_idwf_origen(p_idwf);
    return get_plataforma(l_idwf);
  end;
  --------------------------------------------------------------------------------
  function get_plataforma_destino(p_idwf wf.idwf%type) return varchar2 is
  begin
    return get_plataforma(p_idwf);
  end;
  --------------------------------------------------------------------------------
  function get_plataforma(p_idwf wf.idwf%type) return varchar2 is
    l_count number;
  
  begin
    l_count := 0;
  
    select count(*)
      into l_count
      from tystabsrv t, solotpto s, wf w
     where w.idwf = p_idwf
       and w.codsolot = s.codsolot
       and s.codsrvnue = t.codsrv
       and t.idproducto in (select pp.idproducto
                              from plan_redint p, planxproducto pp
                             where p.idplan = pp.idplan
                               and p.idplan = t.idplan
                               and p.idplataforma = 6) --janus
       and t.flag_lc = 1;
  
    if l_count > 0 then
      return 'JANUS';
    end if;
  
    select count(*)
      into l_count
      from tystabsrv t, solotpto s, wf w
     where w.idwf = p_idwf
       and w.codsolot = s.codsolot
       and s.codsrvnue = t.codsrv
       and t.idproducto in (select pp.idproducto
                              from plan_redint p, planxproducto pp
                             where p.idplan = pp.idplan
                               and p.idplan = t.idplan
                               and p.idplataforma = 3) --tellin
       and t.flag_lc = 1;
  
    if l_count > 0 then
      return 'TELLIN';
    end if;
  
    select count(*)
      into l_count
      from wf t, solotpto s, tystabsrv ty
     where t.idwf = p_idwf
       and t.codsolot = s.codsolot
       and s.codsrvnue = ty.codsrv
       and ty.tipsrv = '0004'
       and (ty.flag_lc is null or ty.flag_lc = 0);
  
    if l_count > 0 then
      return 'ABIERTA';
    end if;
  
    if l_count = 0 then
      return 'NINGUNO';
    end if;
  
  end;
  --------------------------------------------------------------------------------
  function get_linea(p_idwf wf.idwf%type) return linea is
    l_linea linea;
  
  begin
    select s.codsolot,
           e.codinssrv,
           i.pid,
           s.pid_old,
           t.idplan,
           i.codsrv,
           e.codcli,
           e.numslc,
           e.numero,
           p.plan,
           p.plan_opcional
      into l_linea
      from wf w, solotpto s, insprd i, inssrv e, tystabsrv t, plan_redint p
     where w.idwf = p_idwf
       and w.codsolot = s.codsolot
       and s.pid = i.pid
       and i.codinssrv = e.codinssrv
       and e.tipinssrv = 3
       and i.codsrv = t.codsrv
       and t.tipsrv = '0004'
       and t.idplan = p.idplan;
  
    return l_linea;
  
  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit || '.get_linea( p_idwf => ' ||
                              p_idwf || ' ) ' || sqlerrm);
  end;
  ---------------------------------------------------------------------------------
  function get_codsrv(p_pid solotpto.pid%type) return tystabsrv.codsrv%type is
    l_codsrv tystabsrv.codsrv%type;
  
  begin
    select a.codsrv
      into l_codsrv
      from insprd a, tystabsrv b, plan_redint c
     where a.pid = p_pid
       and a.codsrv = b.codsrv
       and b.idplan = c.idplan
       and c.idtipo in (2, 3);
  
    return l_codsrv;
  
  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit ||
                              '.get_codsrv( p_pid => ' || p_pid ||
                              ' ) ' || sqlerrm);
  end;
  ----------------------------------------------------------------------------  
  function get_cant_num(p_idwf wf.idwf%type) return number is
    l_cant_num number;
  
  begin
    select count(e.numero)
      into l_cant_num
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
  
    return l_cant_num;
  
  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit ||
                              '.get_cant_num( p_idwf => ' || p_idwf || ' )' ||
                              sqlerrm);
  end;
  ---------------------------------------------------------------------------------  
  function get_linea_old(p_linea linea) return int_plataforma_bscs%rowtype is
    l_linea_old int_plataforma_bscs%rowtype;
  
  begin
  
    select b.*
      into l_linea_old
      from int_plataforma_bscs b
     where b.idtrans = (select max(b.idtrans)
                          from int_plataforma_bscs b
                         where b.numero = p_linea.numero);
  
    return l_linea_old;
  
  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit || '.get_linea_old (p_linea.numero =>' ||
                              p_linea.numero || ' ) ' || sqlerrm);
  end;
  --------------------------------------------------------------------------------    
  function get_telefonia_ce(p_id_telefonia_ce telefonia_ce.id_telefonia_ce%type)
    return telefonia_ce%rowtype is
    l_telefonia_ce telefonia_ce%rowtype;
  
  begin
    select t.*
      into l_telefonia_ce
      from telefonia_ce t
     where t.id_telefonia_ce = p_id_telefonia_ce;
  
    return l_telefonia_ce;
  
  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit ||
                              '.get_telefonia_ce(p_id_telefonia_ce => ' ||
                              p_id_telefonia_ce || ') ' || sqlerrm);
  end;
  --------------------------------------------------------------------------------
  function armar_trama(p_numslc    vtatabslcfac.numslc%type,
                       p_codinssrv inssrv.codinssrv%type,
                       p_plan      plan_redint.plan%type,
                       p_plan_opc  plan_redint.plan_opcional%type) return varchar2 is
                       
    l_trama varchar2(32767);
  
  begin
    l_trama := p_codinssrv || '|';
    l_trama := l_trama || pq_janus_ce.get_conf('P_COD_CUENTA') || p_numslc || '|';
    l_trama := l_trama || p_plan || '|';
    l_trama := l_trama || p_plan_opc;
  
    return l_trama;
  
  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit || '.armar_trama ( p_numslc =>' ||
                              p_numslc || ',p_codinssrv =>' || p_codinssrv ||
                              ' ,p_plan =>' || p_plan ||
                              ' ,p_plan_opc =>' || p_plan_opc ||') ' || sqlerrm);
  end;
  
  --------------------------------------------------------------------------------
  function get_tipsrv(p_solot solot.codsolot%type) return tystipsrv.tipsrv%type is
    l_tipsrv tystipsrv.tipsrv%type;
  
  begin
    select s.tipsrv
      into l_tipsrv
      from solot s
     where s.codsolot = p_solot;
  
    return l_tipsrv;
  
  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit || '.get_tipsrv( p_solot => ' ||
                              p_solot || ' ) ' || sqlerrm);
  end;
  ---------------------------------------------------------------------------------
  function get_proyecto_origen(p_idwf tareawfcpy.idwf%type) return vtatabslcfac.numslc%type is
     l_numslc          vtatabslcfac.numslc%type;
     l_tiptra          tiptrabajo.tiptra%type;
     l_cantidad        PLS_INTEGER;
     
  begin
      
      select s.numslc 
        into l_numslc 
        from wf t, solot s 
       where t.codsolot = s.codsolot 
         and t.idwf = p_idwf;
            
      LOOP
         Begin  
             select tiptra
               into l_tiptra
               from solot
              where numslc = l_numslc;
                  
             if l_tiptra is null then
                 l_tiptra := 0;
                 l_numslc := '';
             end if;
         
              Exception
                when others then
                   l_tiptra := 0;
                   l_numslc := '';
         End;            
         
         select count(*)
           into l_cantidad
           from tipopedd c, opedd d
          where c.abrev = 'PLAT_JANUS_CE'--(368, 424)--Alta Wimax, Alta HFC
            and c.tipopedd = d.tipopedd
            and d.abreviacion = 'TIPO_PROYECTO_ORIGEN'
            and d.codigon = l_tiptra;
         
         EXIT WHEN l_cantidad > 0 or l_tiptra = 0;
                
         if l_cantidad = 0 then--si tiptra no es (368, 424)
          begin
                             
              select sr.numslc_ori
                into l_numslc
                from sales.regvtamentab sr
               where numslc = l_numslc;

               Exception
                when others then
                   l_numslc := '';              
                       
          End;         
         end if;  
         
      END LOOP;

      return l_numslc;
  end;
  ---------------------------------------------------------------------------------
  function get_tareawfcpy(p_idwf tareawfcpy.idwf%type) return tarea is
    l_tareawfcpy tarea;
  
  begin
    select t.idtareawf, t.idwf, t.tarea, t.tareadef
      into l_tareawfcpy
      from tareawfcpy t
     where t.idwf = p_idwf
       and exists (select 1
                    from tipopedd c, opedd d
                   where c.abrev = 'TAR_CAM_JANUS'
                     and c.tipopedd = d.tipopedd
                     and d.abreviacion = 'TAR_CAM_PLAN_JANUS'
                     and t.tareadef = d.codigoc);
  
    return l_tareawfcpy;
  
  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit || '.get_tareawfcpy( p_idwf => ' ||
                              p_idwf || ' ) ' || sqlerrm);
  end;
  ------------------------------------------------------------
  procedure alta_baja_cplan_plataformas(p_idtareawf tareawf.idtareawf%type,
                                        p_idwf      tareawf.idwf%type,
                                        p_tarea     tareawf.tarea%type,
                                        p_tareadef  tareawf.tareadef%type,
                                        p_operacion telefonia_ce.operacion%type) is
                                        
    c_cambioplan          constant telefonia_ce.operacion%type := 16;
    l_codsolot            solot.codsolot%type;
    l_id_telefonia_ce     telefonia_ce.id_telefonia_ce%type;
    l_telefonia_ce        telefonia_ce%rowtype;
    l_idtrans             int_plataforma_bscs.idtrans%type;
    l_id_telefonia_ce_det telefonia_ce_det.id_telefonia_ce_det%type;
    l_total               pls_integer;
    l_enviadas            pls_integer;
    l_idwf_old            tareawf.idwf%type;
    l_tipsrv              tystipsrv.tipsrv%type;
    l_cantidad            number;
    l_numslc              vtatabslcfac.numslc%type;
    ln_valida             number;
    ln_error              number;
    lv_error              varchar2(1000);

    cursor registro_lineas(p_idwf           tareawf.idwf%type,
                           p_operacion_proy telefonia_ce.operacion%type) is
      select ins.numslc, f.codinssrv, ins.numero, f.pid
        from wf a,
             tystabsrv b,
             (select a.codsolot, b.codinssrv, max(c.pid) pid
                from solotpto a, inssrv b, insprd c
               where a.codinssrv = b.codinssrv
                 and b.tipinssrv = 3
                 and b.codinssrv = c.codinssrv
                 and c.flgprinc = 1
               group by a.codsolot, b.codinssrv) e,
             insprd f,
             inssrv ins
       where a.idwf = p_idwf
         and a.codsolot = e.codsolot
         and f.codinssrv = e.codinssrv
         and f.pid = e.pid
         and f.codsrv = b.codsrv
         and b.codsrv not in
             (select d.codigoc
                from tipopedd c, opedd d
               where c.abrev = 'CFAXSERVER'
                 and c.tipopedd = d.tipopedd
                 and d.abreviacion = 'CFAXSERVER_SRV')
         and e.codinssrv = ins.codinssrv
         and p_operacion_proy = 2--Bajas
      union
      select e.numslc,e.codinssrv, e.numero, b.pid
        from wf d, solotpto a, insprd b, tystabsrv c, inssrv e, solot g
       where d.idwf = p_idwf
         and a.codsolot = d.codsolot
         and a.pid = b.pid
         and e.tipinssrv = 3
         and b.codsrv = c.codsrv
         and e.codinssrv = b.codinssrv
         and a.codsolot = g.codsolot
         and b.flgprinc = 1
         and e.cid is not null
         and p_operacion_proy = 1 --Altas
       order by 3 desc;
  
  begin
    select t.codsolot into l_codsolot from wf t where t.idwf = p_idwf;
    
    if p_operacion = 2 then--Baja
        l_idwf_old := get_idwf_origen(p_idwf);
        l_total    := operacion.PQ_JANUS_CE_BAJA.get_lineas_restantes(l_idwf_old);
        l_enviadas := 0;
    else--Alta        
        l_idwf_old := p_idwf;
    end if;
    
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
        (p_idtareawf, p_idwf, p_tarea, p_tareadef, l_codsolot, p_operacion, l_tipsrv) --4 .0
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
    
    l_telefonia_ce := pq_janus_ce_alta.get_telefonia_ce(l_id_telefonia_ce);
  
    select to_number(c.valor)
     into ln_valida
      from constante c
     where c.constante = 'CPLAN_CE_JANUS';

    for linea in registro_lineas(l_idwf_old, p_operacion) loop
        if p_operacion = 2 then--Baja 
            l_numslc := get_proyecto_origen(p_idwf);
            l_enviadas := l_enviadas + 1;
          
            l_idtrans := operacion.pq_janus_ce_baja.crear_int_plataforma_bscs(linea.numero,
                                                                              linea.codinssrv,
                                                                              l_total -
                                                                              l_enviadas);
          
            l_id_telefonia_ce_det := operacion.pq_janus_ce_baja.crear_telefonia_ce_det(l_telefonia_ce,
                                                                                       linea.codinssrv,
                                                                                       linea.numero,
                                                                                       linea.pid,
                                                                                       l_idtrans);
                                                                                   
            if ln_valida <> 0 then
              operacion.pq_cont_regularizacion.p_bajanumero_janus_sga_ce(l_codsolot,linea.numero,ln_error,lv_error);
            end if;
        else--Alta
            l_numslc := linea.numslc;
            l_idtrans := operacion.pq_janus_ce_alta.crear_int_plataforma_bscs
                                          (l_idwf_old,
                                           l_numslc,
                                           linea.codinssrv,
                                           linea.numero);
    
            l_id_telefonia_ce_det := operacion.pq_janus_ce_alta.crear_telefonia_ce_det
                                                       (l_telefonia_ce,
                                                        linea.codinssrv,
                                                        linea.numero,
                                                        linea.pid,
                                                        l_idtrans);
            if ln_valida <> 0 then
              operacion.pq_cont_regularizacion.p_altanumero_janus_sga_ce(l_codsolot,linea.numero,ln_error,lv_error);
            end if;
        end if;    
        
        update int_plataforma_bscs
           set action_id = p_operacion, codigo_cliente = l_numslc
         where idtrans = l_idtrans;
         
        update telefonia_ce_det
           set action_id = p_operacion
         where id_telefonia_ce_det = l_id_telefonia_ce_det; 
                                                                                
    end loop;
                                                      
    /*update int_plataforma_bscs ipb
       set ipb.codigo_cliente = l_numslc
     where exists
           (select '1'
              from operacion.telefonia_ce tc, operacion.telefonia_ce_det tcd
             where tc.id_telefonia_ce = tcd.id_telefonia_ce
               and tcd.idtrans = ipb.idtrans
               and tc.id_telefonia_ce = l_id_telefonia_ce);*/

  exception
    when others then
       raise_application_error(-20000,
                              $$plsql_unit ||
                              '.alta_baja_cplan_plataformas(p_idtareawf => ' || p_idtareawf ||
                              ' p_operacion => ' || p_operacion || ' ) ' || sqlerrm);
  end;
  ------------------------------------------------------------------------
  procedure alta_baja_cplan(p_idtareawf tareawf.idtareawf%type,
                            p_idwf      tareawf.idwf%type,
                            p_tarea     tareawf.tarea%type,
                            p_tareadef  tareawf.tareadef%type,
                            p_operacion telefonia_ce.operacion%type) is
    
    c_cambioplan          constant telefonia_ce.operacion%type := 16;
    --c_alta                constant telefonia_ce.operacion%type := 1;
    l_codsolot            solot.codsolot%type;
    l_id_telefonia_ce     telefonia_ce.id_telefonia_ce%type;
    l_telefonia_ce        operacion.telefonia_ce%rowtype;
    l_idtrans             operacion.int_plataforma_bscs.idtrans%type;
    l_id_telefonia_ce_det operacion.telefonia_ce_det.id_telefonia_ce_det%type;
    l_idwf_old            tareawf.idwf%type;  
    l_total               pls_integer;
    l_enviadas            pls_integer;
    l_cantidad            number;
    l_numslc              vtatabslcfac.numslc%type;
    l_tipsrv              tystipsrv.tipsrv%type;
    ln_valida             number;
    ln_error              number;
    lv_error              varchar2(1000);

    cursor registro_lineas(p_idwf     tareawf.idwf%type,
                           p_idwf_old tareawf.idwf%type) is
      select e.numslc, e.codinssrv, e.numero, b.pid
        from wf d, solotpto a, insprd b, inssrv e
       where ((p_operacion = 1 and d.idwf = p_idwf) or
              (p_operacion = 2 and d.idwf = p_idwf_old))
         and a.codsolot = d.codsolot
         and a.pid = b.pid
         and e.tipinssrv = 3
         and e.codinssrv = b.codinssrv
         and b.flgprinc = 1
         and e.cid is not null
         and e.numero not in
             (select e.numero
                from wf d, solotpto a, insprd b, inssrv e
               where ((p_operacion = 1 and d.idwf = p_idwf_old) or
                      (p_operacion = 2 and d.idwf = p_idwf))
                 and a.codsolot = d.codsolot
                 and a.pid = b.pid
                 and e.tipinssrv = 3
                 and e.codinssrv = b.codinssrv
                 and b.flgprinc = 1
                 and e.cid is not null);
  
  begin
    select t.codsolot into l_codsolot from wf t where t.idwf = p_idwf;
    --l_numslc := get_proyecto_origen(p_idwf);
    l_idwf_old := get_idwf_origen(p_idwf);
  
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
        (p_idtareawf,p_idwf,p_tarea,p_tareadef,l_codsolot,p_operacion,l_tipsrv) --4.0
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
  
    select to_number(c.valor)
     into ln_valida
      from constante c
     where c.constante = 'CPLAN_CE_JANUS';

    if p_operacion = 2 then --Baja
      /*select count(*)
        into l_total
        from operacion.telefonia_ce_det tcd
       where id_telefonia_ce = l_id_telefonia_ce
         and action_id = c_alta;*/
      l_total := operacion.PQ_JANUS_CE_BAJA.get_lineas_restantes(p_idwf);
      l_total := operacion.PQ_JANUS_CE_BAJA.get_lineas_restantes(l_idwf_old) - l_total;
      l_enviadas := 0;         
    end if;
  
    for linea in registro_lineas(p_idwf, l_idwf_old) loop
      if p_operacion = 2 then--Baja
        l_numslc := get_proyecto_origen(p_idwf);
        l_enviadas := l_enviadas + 1;
      
        l_idtrans := operacion.pq_janus_ce_baja.crear_int_plataforma_bscs(linea.numero,
                                                                          linea.codinssrv,
                                                                          l_total -
                                                                          l_enviadas);
      
        l_id_telefonia_ce_det := operacion.pq_janus_ce_baja.crear_telefonia_ce_det(l_telefonia_ce,
                                                                                   linea.codinssrv,
                                                                                   linea.numero,
                                                                                   linea.pid,
                                                                                   l_idtrans);
        if ln_valida <> 0 then
          operacion.pq_cont_regularizacion.p_bajanumero_janus_sga_ce(l_codsolot,linea.numero,ln_error,lv_error);
        end if;
      else--Alta
        l_numslc := linea.numslc; 
        l_idtrans := operacion.pq_janus_ce_alta.crear_int_plataforma_bscs(p_idwf,
                                                                          l_numslc,
                                                                          linea.codinssrv,
                                                                          linea.numero);
      
        l_id_telefonia_ce_det := operacion.pq_janus_ce_alta.crear_telefonia_ce_det(l_telefonia_ce,
                                                                                   linea.codinssrv,
                                                                                   linea.numero,
                                                                                   linea.pid,
                                                                                   l_idtrans);
        if ln_valida <> 0 then
          operacion.pq_cont_regularizacion.p_altanumero_janus_sga_ce(l_codsolot,linea.numero,ln_error,lv_error);
        end if;
      end if;
    
      update int_plataforma_bscs
           set action_id = p_operacion, codigo_cliente = l_numslc
         where idtrans = l_idtrans;
         
      update telefonia_ce_det
         set action_id = p_operacion
       where id_telefonia_ce_det = l_id_telefonia_ce_det;
    
    end loop;
    
    /*update int_plataforma_bscs ipb
       set ipb.codigo_cliente = l_numslc
     where exists
           (select '1'
              from operacion.telefonia_ce tc, operacion.telefonia_ce_det tcd
             where tc.id_telefonia_ce = tcd.id_telefonia_ce
               and tcd.idtrans = ipb.idtrans
               and tc.id_telefonia_ce = l_id_telefonia_ce);*/
               
    exception
      when others then
        raise_application_error(-20000,
                                $$plsql_unit ||
                                '.alta_baja_cplan(p_idtareawf => ' ||
                                p_idtareawf ||', p_operacion => ' || p_operacion || ' ) ' ||
                                sqlerrm);
  end;
--------------------------------------------------------------------------------
procedure consumir_ws(p_idtareawf           tareawf.idtareawf%type,
                      p_idwf                tareawf.idwf%type) is
                      
   l_ws_error_dsc        telefonia_ce_det.ws_error_dsc%type;
   l_cantidad            number;
   
   cursor envio_lineas(p_idwf tareawf.idwf%type) is
      select c.id_telefonia_ce_det, d.idtrans
        from wf                  a,
             telefonia_ce        b,
             telefonia_ce_det    c,
             int_plataforma_bscs d
       where a.idwf = p_idwf
         and a.idwf = b.idwf
         and a.valido = 1
         and b.id_telefonia_ce = c.id_telefonia_ce
         and c.idtrans = d.idtrans
       order by d.idtrans;
          
begin
    for linea in envio_lineas(p_idwf) loop
        pq_janus_ce_conexion.enviar_solicitud(linea.idtrans,
                                              linea.id_telefonia_ce_det);
      
        l_cantidad := 0;
        select t.ws_error_dsc
          into l_ws_error_dsc
          from telefonia_ce_det t
         where t.id_telefonia_ce_det = linea.id_telefonia_ce_det;
          
        select count(*)
          into l_cantidad
          from tareawfseg
         where idtareawf = p_idtareawf;
    
        if l_cantidad = 0 then
          insert into tareawfseg
            (idtareawf, observacion)
          values
            (p_idtareawf, l_ws_error_dsc);
        else
           update tareawfseg
              set observacion = l_ws_error_dsc
            where idtareawf = p_idtareawf;
        end if;
                  
        update telefonia_ce_det t
           set t.id_sga_error = 0, t.sga_error_dsc = 'OK', t.verificado = 0
         where t.id_telefonia_ce_det = linea.id_telefonia_ce_det;
    end loop;
    
    update telefonia_ce t
       set t.id_error = 0, t.mensaje = 'Registro satisfactorio'
     where idwf = p_idwf
       and idtareawf = p_idtareawf;
       
    exception
      when others then
        raise_application_error(-20000,
                                $$plsql_unit ||
                                '.consumir_ws(p_idtareawf => ' || p_idtareawf ||
                                ', p_idwf => ' || p_idwf || ' ) ' ||
                                sqlerrm);   
end;
--------------------------------------------------------------------------
end;
/
