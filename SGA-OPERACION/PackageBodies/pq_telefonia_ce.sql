CREATE OR REPLACE PACKAGE BODY OPERACION.PQ_TELEFONIA_CE IS
  /************************************************************************************************
   PROPOSITO: Centralizar los procesos de tipo interfaz con las plataformas
              telefonicas
   REVISIONES:
     Version  Fecha       Autor            Solicitado por      Descripcion
     -------  -----       -----             --------------      -----------
     1.0      26/06/2014  Eustaquio Gibaja  Christian Riquelme  version inicial
     2.0      24/07/2014  Eustaquio Gibaja  Christian Riquelme  Cambio estado Tarea en No interviene
     3.0      16/12/2014  Edwin Vasquez     Christian Riquelme  Claro Empresas WiMAX
  /* **********************************************************************************************/
  PROCEDURE alta(p_idtareawf tareawf.idtareawf%TYPE,
                 p_idwf      tareawf.idwf%TYPE,
                 p_tarea     tareawf.tarea%TYPE,
                 p_tareadef  tareawf.tareadef%TYPE) IS
    c_alta constant telefonia_ce.operacion%type := 1;
    
    /*set_globals(p_idtareawf, p_idwf, p_tarea, p_tareadef);*/
  begin
    IF NOT es_telefonia(p_idwf) THEN
      no_interviene(p_idtareawf);
      RETURN;
    END IF;

    IF NOT es_claro_empresas(p_idwf) THEN
      --ini 2.0
      /*RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.ALTA: NO ES CLARO EMPRESAS HFC');*/
      no_interviene(p_idtareawf);
      RETURN;
      --fin 2.0
    END IF;

    IF esta_registrado(c_alta, p_idtareawf) THEN
      RETURN;
    END IF;

    IF not es_janus(c_alta, p_idwf) THEN
      /*crear_telefonia_ce();
      pq_janus_ce_alta.alta();
    ELSE*/
      no_interviene(p_idtareawf);
      RETURN;
    END IF;

    /*update_telefonia_ce();*/

   pq_janus_ce_alta.alta(p_idtareawf, p_idwf, p_tarea, p_tareadef);

  EXCEPTION
    WHEN OTHERS THEN
      pq_telefonia_ce_det.logger(p_idtareawf,SQLERRM);
  END;
  /* **********************************************************************************************/
  PROCEDURE baja(p_idtareawf tareawf.idtareawf%TYPE,
                 p_idwf      tareawf.idwf%TYPE,
                 p_tarea     tareawf.tarea%TYPE,
                 p_tareadef  tareawf.tareadef%TYPE) IS
c_baja constant telefonia_ce.operacion%type := 2;

  BEGIN

    /*g_operacion := 2;*/

    --set_globals(p_idtareawf, p_idwf, p_tarea, p_tareadef);

    IF NOT es_telefonia(p_idwf) THEN
      no_interviene(p_idtareawf);
      RETURN;
    END IF;

    IF NOT es_claro_empresas(p_idwf) THEN
       --ini 2.0
      /*RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.BAJA: NO ES CLARO EMPRESAS HFC');*/
      no_interviene(p_idtareawf);
      RETURN;
      --fin 2.0
    END IF;

    IF esta_registrado(c_baja, p_idtareawf) THEN
      RETURN;
    END IF;

    if not es_janus(c_baja, p_idwf) then
      /*crear_telefonia_ce();
      pq_janus_ce_baja.baja();
    ELSE*/
      no_interviene(p_idtareawf);
      RETURN;
    END IF;

    pq_janus_ce_baja.baja(p_idtareawf, p_idwf, p_tarea, p_tareadef);

    /*update_telefonia_ce();*/

  EXCEPTION
    WHEN OTHERS THEN
      pq_telefonia_ce_det.logger(p_idtareawf,SQLERRM);
  END;
  /* **********************************************************************************************/
procedure cambio_plan(p_idtareawf tareawf.idtareawf%type,
                        p_idwf      tareawf.idwf%type,
                        p_tarea     tareawf.tarea%type,
                        p_tareadef  tareawf.tareadef%type) is
    c_cambio_plan constant telefonia_ce.operacion%type := 16;
  
  begin
    if not habilita_planes_control() then
      return;
    end if;
  
    if not es_telefonia(p_idwf) then
      no_interviene(p_idtareawf);
      return;
    end if;
  
    if not es_claro_empresas(p_idwf) then
      no_interviene(p_idtareawf);
      return;
    end if;
  
    if esta_registrado(c_cambio_plan, p_idtareawf) then
      return;
    end if;
  
    if not es_janus_cambio_plan(p_idwf) then
      no_interviene(p_idtareawf);
      return;
    end if;
  
    pq_janus_ce_cambio_plan.cambio_plan(p_idtareawf,
                                        p_idwf,
                                        p_tarea,
                                        p_tareadef);
  
  exception
    when others then
      pq_telefonia_ce_det.logger(p_idtareawf, sqlerrm);
  end;
  --------------------------------------------------------------------------------
  FUNCTION es_telefonia(p_idwf tareawf.idwf%type) RETURN BOOLEAN IS
    l_count PLS_INTEGER;

  BEGIN
    SELECT COUNT(*)
      INTO l_count
      FROM wf w, solotpto s, inssrv i
     WHERE w.idwf = p_idwf
       AND w.codsolot = s.codsolot
       AND s.codinssrv = i.codinssrv
       AND i.tipinssrv = 3;

    RETURN l_count > 0;
  END;
  /* **********************************************************************************************/
  /*PROCEDURE set_globals(p_idtareawf tareawf.idtareawf%TYPE,
                        p_idwf      tareawf.idwf%TYPE,
                        p_tarea     tareawf.tarea%TYPE,
                        p_tareadef  tareawf.tareadef%TYPE) IS
  BEGIN
    g_idtareawf := p_idtareawf;
    g_idwf      := p_idwf;
    g_tarea     := p_tarea;
    g_tareadef  := p_tareadef;
  END;*/
  /* **********************************************************************************************/
  PROCEDURE no_interviene(p_idtareawf tareawf.idtareawf%type) IS
  BEGIN
    opewf.pq_wf.p_chg_status_tareawf(p_idtareawf,
                                     4, --Cerrada
                                     8, --No interviene
                                     0,
                                     SYSDATE,
                                     SYSDATE);
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.NO_INTERVIENE(p_idtareawf =>  ' || 
                              p_idtareawf || ') ' || sqlerrm);
  END;
  /* **********************************************************************************************/
  FUNCTION esta_registrado(p_operacion telefonia_ce.operacion%type,
                           p_idtareawf tareawf.idtareawf%type) return boolean is
    l_count PLS_INTEGER;

  BEGIN
    /*g_tipestsol := get_tipestsol();*/

    SELECT COUNT(*)
      INTO l_count
      FROM telefonia_ce t
     WHERE t.idtareawf = p_idtareawf
       AND t.operacion = p_operacion;

    RETURN l_count > 0;
  END;
  /* **********************************************************************************************/
 PROCEDURE crear_telefonia_ce IS
    l_tel telefonia_ce%ROWTYPE;

  BEGIN
     null;
    /*l_tel.idtareawf := g_idtareawf;
    l_tel.idwf      := g_idwf;
    l_tel.tarea     := g_tarea;
    l_tel.tareadef  := g_tareadef;
    insert_telefonia_ce(l_tel);

    g_id_telefonia_ce := l_tel.id_telefonia_ce;*/

  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.CREAR_INT_TELEFONIA_CE: ' ||
                              SQLERRM);
  END;
  /* **********************************************************************************************/
  function crear_telefonia_ce(p_idtareawf tareawf.idtareawf%type,
                              p_idwf      tareawf.idwf%type,
                              p_tarea     tareawf.tarea%type,
                              p_tareadef  tareawf.tareadef%type,
                              p_operacion operacion.telefonia_ce.operacion%type)
    return operacion.telefonia_ce.id_telefonia_ce%type is
    l_tel operacion.telefonia_ce%rowtype;

  BEGIN
    l_tel.idtareawf := p_idtareawf;
    l_tel.idwf      := p_idwf;
    l_tel.tarea     := p_tarea;
    l_tel.tareadef  := p_tareadef;
    l_tel.operacion := p_operacion;

    insert_telefonia_ce(l_tel);

    /*g_id_telefonia_ce := l_tel.id_telefonia_ce;*/

    return l_tel.id_telefonia_ce;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.CREAR_INT_TELEFONIA_CE: ' ||
                              SQLERRM);
  END;
  /* **********************************************************************************************/
  PROCEDURE insert_telefonia_ce(p_telef IN OUT NOCOPY telefonia_ce%ROWTYPE) IS
  BEGIN
    p_telef.usureg := USER;
    p_telef.fecreg := SYSDATE;
    p_telef.usumod := USER;
    p_telef.fecmod := SYSDATE;

    INSERT INTO telefonia_ce
    VALUES p_telef
    RETURNING id_telefonia_ce INTO p_telef.id_telefonia_ce;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.INSERT_TELEFONIA_CE: ' ||
                              SQLERRM);
  END;
  /* **********************************************************************************************/
  FUNCTION es_janus (p_operacion operacion.telefonia_ce.operacion%type,
                    p_idwf      tareawf.idwf%type) return boolean is
    l_count PLS_INTEGER;
    l_idwf  tareawf.idwf%TYPE;
  BEGIN

    IF p_operacion in (1, 16) THEN
      l_idwf := p_idwf;
    END IF;

    IF p_operacion = 2 THEN
      l_idwf := get_idwf_alta(p_idwf);
    END IF;

    SELECT COUNT(*)
      INTO l_count
      FROM tystabsrv t, solotpto s, wf w
     WHERE w.idwf = l_idwf
       AND w.codsolot = s.codsolot
       AND s.codsrvnue = t.codsrv
       AND t.idproducto IN (SELECT pp.idproducto
                              FROM plan_redint p, planxproducto pp
                             WHERE p.idplan = pp.idplan
                               AND p.idplan = t.idplan
                               AND p.idplataforma = 6) --janus
       AND t.flag_lc = 1;
    RETURN l_count > 0;

  END;
--------------------------------------------------------------------------------
  function es_janus_cambio_plan(p_idwf tareawf.idwf%type) return boolean is
    l_count pls_integer;
    l_idwf  tareawf.idwf%type;
  
  begin
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
  
    if l_count = 0 then
      l_idwf := operacion.pq_janus_ce_cambio_plan.get_idwf_origen(p_idwf);
    
      select count(*)
        into l_count
        from tystabsrv t, solotpto s, wf w
       where w.idwf = l_idwf
         and w.codsolot = s.codsolot
         and s.codsrvnue = t.codsrv
         and t.idproducto in (select pp.idproducto
                                from plan_redint p, planxproducto pp
                               where p.idplan = pp.idplan
                                 and p.idplan = t.idplan
                                 and p.idplataforma = 6) --janus
         and t.flag_lc = 1;
    end if;
  
    return l_count > 0;
  end;
  /* **********************************************************************************************/

  PROCEDURE update_telefonia_ce IS
    --l_tel telefonia_ce%ROWTYPE;

  BEGIN
     null;
     
    /*SELECT t.*
      INTO l_tel
      FROM telefonia_ce t
     WHERE t.id_telefonia_ce = g_id_telefonia_ce;

    l_tel.operacion := g_operacion;
    l_tel.codsolot  := get_codsolot();
    l_tel.id_error  := 0;
    l_tel.mensaje   := 'OK';

    UPDATE telefonia_ce t
       SET ROW = l_tel
     WHERE t.id_telefonia_ce = l_tel.id_telefonia_ce;*/

  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END;

  /* **********************************************************************************************/
  FUNCTION get_tipestsol RETURN tipestsol.tipestsol%TYPE IS
    l_tipestsol tipestsol.tipestsol%TYPE;

  BEGIN 
     l_tipestsol := '';
     
    /*SELECT t.tipestsol
      INTO l_tipestsol
      FROM wf w, solot s, estsol e, tipestsol t
     WHERE w.idwf = g_idwf
       AND w.codsolot = s.codsolot
       AND s.estsol = e.estsol
       AND e.tipestsol = t.tipestsol;*/

    RETURN l_tipestsol;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.GET_TIPESTSOL: ' || SQLERRM);
  END;
  /* **********************************************************************************************/
  FUNCTION get_codsolot RETURN solot.codsolot%TYPE IS
    l_codsolot solot.codsolot%TYPE;

  BEGIN
    l_codsolot := 0;
    
    --SELECT t.codsolot INTO l_codsolot FROM wf t WHERE t.idwf = g_idwf;
    RETURN l_codsolot;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.GET_CODSOLOT: ' || SQLERRM);
  END;
  /* **********************************************************************************************/
  FUNCTION es_claro_empresas(p_idwf tareawf.idwf%type) RETURN BOOLEAN IS
    l_count PLS_INTEGER;

  BEGIN
    SELECT COUNT(*)
      INTO l_count
      FROM solot s, wf w
     WHERE s.codsolot = w.codsolot
       AND w.idwf = p_idwf
       AND s.tipsrv IN (SELECT d.codigoc
                          FROM tipopedd c, opedd d
                         WHERE c.abrev = 'TIPSRV_JANUS_CE'
                           AND c.tipopedd = d.tipopedd
                           AND d.abreviacion = 'FAMILIA');

    RETURN l_count > 0;
  END;
  /* **********************************************************************************************/
  PROCEDURE insert_telefonia_ce_det(p_log IN OUT NOCOPY telefonia_ce_det%ROWTYPE) IS
  BEGIN
    p_log.usureg := USER;
    p_log.fecreg := SYSDATE;
    p_log.usumod := USER;
    p_log.fecmod := SYSDATE;

    INSERT INTO telefonia_ce_det
    VALUES p_log
    RETURNING id_telefonia_ce_det INTO p_log.id_telefonia_ce_det;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.INSERT_TELEFONIA_CE_DET: ' ||
                              SQLERRM);
  END;
  /* **********************************************************************************************/
  /*FUNCTION get_id RETURN telefonia_ce.id_telefonia_ce%TYPE IS
  BEGIN
    RETURN g_id_telefonia_ce;
  END;*/
  /* **********************************************************************************************/
  PROCEDURE update_telefonia_ce_det(p_id_telefonia_ce_det telefonia_ce_det.id_telefonia_ce_det%type)IS
    l_log telefonia_ce_det%ROWTYPE;

  BEGIN
    SELECT t.*
      INTO l_log
      FROM operacion.telefonia_ce_det t
     WHERE t.id_telefonia_ce_det = p_id_telefonia_ce_det;

    l_log.id_sga_error  := 0;
    l_log.sga_error_dsc := 'OK';
    l_log.verificado    := 0;

    UPDATE telefonia_ce_det t
       SET ROW = l_log
     WHERE t.id_telefonia_ce_det = l_log.id_telefonia_ce_det;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.UPDATE_TELEFONIA_CE_DET: ' ||
                              SQLERRM);
  END;
  /* **********************************************************************************************/
  PROCEDURE insert_tareawfseg(p_tareawfseg IN OUT NOCOPY tareawfseg%ROWTYPE) IS
  BEGIN
    p_tareawfseg.fecusu := SYSDATE;
    p_tareawfseg.codusu := USER;
    p_tareawfseg.flag   := 0;

    INSERT INTO tareawfseg VALUES p_tareawfseg;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.INSERT_TAREAWFSEG: ' || SQLERRM);
  END;
  /* **********************************************************************************************/
  PROCEDURE chg_alta(p_idtareawf tareawf.idtareawf%TYPE,
                     p_idwf      tareawf.idwf%TYPE,
                     p_tarea     tareawf.tarea%TYPE,
                     p_tareadef  tareawf.tareadef%TYPE,
                     p_tipesttar tareawf.tipesttar%TYPE,
                     p_esttarea  tareawf.esttarea%TYPE,
                     p_mottarchg tareawf.mottarchg%TYPE,
                     p_fecini    tareawf.fecini%TYPE,
                     p_fecfin    tareawf.fecfin%TYPE) IS

    C_CON_ERRORES CONSTANT esttarea.esttarea%TYPE := 19;
    C_CERRADA     CONSTANT esttarea.esttarea%TYPE := 4;

  BEGIN
    IF find_esttarea(p_idtareawf) = C_CON_ERRORES AND p_esttarea = C_CERRADA THEN
      alta(p_idtareawf, p_idwf, p_tarea, p_tareadef);
    END IF;
    DBMS_OUTPUT.PUT_LINE(p_tipesttar || p_mottarchg || p_fecini || p_fecfin);
  END;
  /* **********************************************************************************************/
  FUNCTION find_esttarea(p_idtareawf tareawf.idtareawf%TYPE)
    RETURN tareawf.esttarea%TYPE IS
    l_esttarea tareawf.esttarea%TYPE;

  BEGIN
    SELECT esttarea INTO l_esttarea FROM tareawf WHERE idtareawf = p_idtareawf;

    RETURN l_esttarea;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.FIND_ESTTAREA: ' || SQLERRM);
  END;
  /* **********************************************************************************************/
  FUNCTION existe_reserva(p_idwf tareawf.idwf%type) RETURN BOOLEAN IS
    l_count_inssrv        PLS_INTEGER;
    l_count_inssrv_numtel PLS_INTEGER;

  BEGIN
    -- numero telefonicos de venta
    SELECT COUNT(*)
      INTO l_count_inssrv
      FROM wf, solot s, inssrv i
     WHERE wf.idwf = p_idwf
       AND wf.codsolot = s.codsolot
       AND s.numslc = i.numslc
       AND i.tipinssrv = 3
       AND i.cid IS NOT NULL;

    -- numero telefonicos de venta en numtel
    --todo: la reservas se verifican en la reservatel no en la numtel
    SELECT COUNT(*)
      INTO l_count_inssrv_numtel
      FROM wf, solot s, inssrv i, numtel n
     WHERE wf.idwf = p_idwf
       AND wf.codsolot = s.codsolot
       AND s.numslc = i.numslc
       AND i.tipinssrv = 3
       AND i.codinssrv = n.codinssrv
       AND i.cid IS NOT NULL;

    /*IF l_count_inssrv = l_count_inssrv_numtel THEN
      RETURN TRUE;
    ELSE
      RETURN FALSE;
    END IF;*/

    return l_count_inssrv = l_count_inssrv_numtel;

  END;
  /* **********************************************************************************************/
  FUNCTION get_idwf_alta(p_idwf tareawf.idwf%type) RETURN tareawf.idwf%TYPE IS
    l_idwf_alta tareawf.idwf%TYPE;

  BEGIN
    SELECT a.idwf
      INTO l_idwf_alta
      FROM wf a, solot b
     WHERE a.codsolot = b.codsolot
       AND a.valido = 1
       AND b.numslc IN (SELECT DISTINCT (a.numslc)
                          FROM inssrv a, solotpto b, wf c
                         WHERE a.codinssrv = b.codinssrv
                           AND b.codsolot = c.codsolot
                           AND c.valido = 1
                           AND c.idwf = p_idwf);

    RETURN l_idwf_alta;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.GET_IDWF_ALTA: ' || SQLERRM);
  END;
  /* **********************************************************************************************/
  function habilita_planes_control return boolean is
    l_count number;
  
  begin
    select count(d.codigon)
      into l_count
      from tipopedd c, opedd d
     where c.tipopedd = d.tipopedd
       and c.abrev = 'HAB_WIMAX_JANUS'
       and d.abreviacion = 'habilitado'
       and d.codigon = 1;
  
    return l_count > 0;
  end;
  --------------------------------------------------------------------------------
  procedure pos_tarea(p_idtareawf tareawf.idtareawf%type,
                      p_idwf      tareawf.idwf%type,
                      p_tarea     tareawf.tarea%type,
                      p_tareadef  tareawf.tareadef%type) is
    c_no_interviene constant tareawf.esttarea%type := 8;
    l_count pls_integer;
  
  begin
    select count(*)
      into l_count
      from tareawfchg t
     where t.idtareawf = p_idtareawf
       and t.esttarea = c_no_interviene;
  
    if l_count > 0 then
      update tareawf t
         set t.esttarea = c_no_interviene
       where t.idtareawf = p_idtareawf;
    end if;
  
  exception
    when others then
      pq_telefonia_ce_det.logger(p_idtareawf, sqlerrm);
      dbms_output.put_line(p_idwf);
      dbms_output.put_line(p_tarea);
      dbms_output.put_line(p_tareadef);
  end;
  --------------------------------------------------------------------------------  
END;
/