DECLARE
  l_msg VARCHAR2(10000);
  /* *********************************/
  PROCEDURE eliminar_configuracion(p_msg OUT VARCHAR2) IS
    C_WORKFLOW CONSTANT wfdef.descripcion%TYPE := 'HFC - TRASLADO EXTERNO';
    C_TAREA    CONSTANT tareadef.descripcion%TYPE := 'Actualización información BSCS';
    l_tareadef    tareadef.tareadef%TYPE;
    l_wfdef       wfdef.wfdef%TYPE;
    l_tarea       tareawfdef.tarea%TYPE;
    l_tarea_padre tareawfdef%ROWTYPE;
  
    post_t_1 tareawfdef.pos_tareas%TYPE;
    post_t_2 tareawfdef.pos_tareas%TYPE;
  
  BEGIN
    --wfdef
    SELECT w.wfdef INTO l_wfdef FROM wfdef w WHERE w.descripcion = C_WORKFLOW;
  
    --tareadef
    SELECT t.tareadef
      INTO l_tareadef
      FROM tareadef t
     WHERE t.descripcion = C_TAREA;
  
    --tareawfdef
    SELECT t.tarea
      INTO l_tarea
      FROM tareawfdef t
     WHERE t.tareadef = l_tareadef
       AND t.wfdef = l_wfdef;
  
    -- tarea padre
    SELECT t.*
      INTO l_tarea_padre
      FROM tareawfdef t
     WHERE t.wfdef = 1129
       AND t.descripcion LIKE 'Activación/Desactivación del servicio%';
  
    post_t_1 := substr(l_tarea_padre.pos_tareas,
                       1,
                       INSTR(l_tarea_padre.pos_tareas, l_tarea) - 2);
  
    post_t_2                 := substr(l_tarea_padre.pos_tareas,
                                       INSTR(l_tarea_padre.pos_tareas, l_tarea) +
                                       length(l_tarea),
                                       length(l_tarea_padre.pos_tareas));
    l_tarea_padre.pos_tareas := post_t_1 || post_t_2;
  
    /* *********************************
       ROLBACK
    /* *********************************/
    --UPDATE TAREA PADRE
    UPDATE tareawfdef t SET t.pos_tareas =  l_tarea_padre.pos_tareas WHERE t.tarea = l_tarea_padre.tarea;
    --DELETE REGISTROS CREADOS    
  
    --        tareawfchgres
    DELETE FROM tareawfchgres t
     WHERE t.idtareawf IN (SELECT tw.idtareawf
                             FROM tareawf tw
                            WHERE tw.tarea = l_tarea
                              AND tw.tareadef = l_tareadef);
  
    --      tareawfchg
    DELETE FROM tareawfchg t
     WHERE t.idtareawf IN (SELECT tw.idtareawf
                             FROM tareawf tw
                            WHERE tw.tarea = l_tarea
                              AND tw.tareadef = l_tareadef);
  
    --      tareawfseg
    DELETE FROM tareawfseg t
     WHERE t.idtareawf IN (SELECT tw.idtareawf
                             FROM tareawf tw
                            WHERE tw.tarea = l_tarea
                              AND tw.tareadef = l_tareadef);
  
    --    tareawf
    DELETE FROM tareawf tw
     WHERE tw.tarea = l_tarea
       AND tw.tareadef = l_tareadef;
  
    --    tareawfcpy
    DELETE FROM tareawfcpy tw
     WHERE tw.tarea = l_tarea
       AND tw.wfdef = l_wfdef;
  
    --  tareawfdef
    DELETE FROM tareawfdef t
     WHERE t.tareadef = l_tareadef
       AND t.wfdef = l_wfdef;
  
    --  TAREADEFOPC              
    DELETE FROM TAREADEFOPC t WHERE t.tareadef = l_tareadef;
  
    --tareadef
    DELETE FROM tareadef t WHERE t.Tareadef = l_tareadef;
  
  EXCEPTION
    WHEN OTHERS THEN
      p_msg := SQLERRM;
  END;
  /* *********************************/
  PROCEDURE eliminar_objetos(p_msg OUT VARCHAR2) IS
    TYPE objeto IS TABLE OF VARCHAR2(500) INDEX BY BINARY_INTEGER;
    l_objetos objeto;
  BEGIN
    --PACKAGE(S)
    l_objetos(1) := 'DROP PACKAGE operacion.pq_ope_siac_bscs';
    --SEQUENCE(S)
    l_objetos(2) := 'DROP SEQUENCE operacion.sq_int_send_dir_bscs_log';
    --TRIGGER(S)
    l_objetos(3) := 'DROP TRIGGER operacion.t_int_send_dir_bscs_log_bi';
    --TABLE(S)
    l_objetos(4) := 'DROP TABLE operacion.int_send_dir_bscs_log';
  
    FOR i IN l_objetos.FIRST .. l_objetos.LAST LOOP
      BEGIN
        EXECUTE IMMEDIATE l_objetos(i);
      
      EXCEPTION
        WHEN OTHERS THEN
          IF p_msg IS NULL THEN
            p_msg := SQLERRM;
          ELSE
            p_msg := p_msg || CHR(10) || SQLERRM;
          END IF;
        
      END;
    END LOOP;
  END;
  /* *********************************/
BEGIN
  --CONFIGURACION
  eliminar_configuracion(l_msg);
  --OBJETOS
  eliminar_objetos(l_msg);

  COMMIT;

  --REPORTE
  dbms_output.put_line(l_msg);
END;