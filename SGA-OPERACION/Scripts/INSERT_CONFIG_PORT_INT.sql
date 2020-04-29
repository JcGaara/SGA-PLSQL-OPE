--PORTABILIDAD INSTALACION 3 PLAY INALAMBRICO
DECLARE
  ln_count NUMBER;
  lv_select varchar2(3000);
  lv_pos1 varchar2(100);
  lv_pos2 varchar2(100);
  Cursor c1 is 
    select tarea, descripcion, tipo, area, wfdef, tareadef, plazo,
           REPLACE(pre_tareas,';',',') as pre_tarea ,REPLACE(pos_tareas,';',',') as pos_tarea
      from opewf.tareawfdef
     where wfdef =
           (select wfdef
              from wfdef
             where descripcion = 'INSTALACION 3 PLAY INALAMBRICO');
   
BEGIN
  ln_count := 0;
  ------------------------------------------------------------------------------------------
  -- Insercion del TIPTRA
  ------------------------------------------------------------------------------------------
  SELECT COUNT(*)
    INTO ln_count
    FROM operacion.tiptrabajo
   where descripcion = 'PORTABILIDAD INSTALACION 3 PLAY INALAMBRICO';
  IF ln_count = 0 THEN
    insert into operacion.tiptrabajo
      (tiptra,
       tiptrs,
       descripcion,
       flgcom,
       flgpryint,
       sotfacturable,
       agenda,
       corporativo,
       selpuntossot)
    values
      ((select max(tiptra) + 1 from tiptrabajo),
       1,
       'PORTABILIDAD INSTALACION 3 PLAY INALAMBRICO',
       0,
       0,
       0,
       0,
       0,
       0);
       commit;
  END IF;
  ------------------------------------------------------------------------------------------
  -- Insercion del Configuracion de TipoTrabajo
  ------------------------------------------------------------------------------------------
  ln_count := 0;
  SELECT COUNT(*)
    INTO ln_count
    FROM OPERACION.OPEDD O, OPERACION.TIPOPEDD T
   WHERE O.TIPOPEDD = T.TIPOPEDD
     AND T.ABREV = 'TIPTRABAJO'
     AND O.ABREVIACION = 'SISACT_WLL_PORTA';
  IF ln_count = 0 THEN
    INSERT INTO OPERACION.OPEDD
      (TIPOPEDD, CODIGON, DESCRIPCION, ABREVIACION)
    VALUES
      ((SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'TIPTRABAJO'),
       (SELECT TIPTRA
          FROM OPERACION.TIPTRABAJO
         WHERE DESCRIPCION = 'PORTABILIDAD INSTALACION 3 PLAY INALAMBRICO'),
       'PORTABILIDAD LTE',
       'SISACT_WLL_PORTA');
    Commit;
  END IF;
  ------------------------------------------------------------------------------------------
  -- Insercion del Workflow
  ------------------------------------------------------------------------------------------
  SELECT COUNT(*)
    INTO ln_count
    FROM opewf.wfdef
   where descripcion = 'PORTABILIDAD INSTALACION 3 PLAY INALAMBRICO';
  IF ln_count = 0 THEN
    INSERT INTO OPEWF.WFDEF
      (WFDEF, ESTADO, CLASEWF, DESCRIPCION, VERSION)
    VALUES
      ((SELECT MAX(WFDEF) + 1 FROM OPEWF.WFDEF),
       1,
       0,
       'PORTABILIDAD INSTALACION 3 PLAY INALAMBRICO',
       1);
       commit;
  end if;
  ------------------------------------------------------------------------------------------
  -- Insercion del Configuracion de WorkFlow Automatico
  ------------------------------------------------------------------------------------------
  ln_count := 0;
  SELECT COUNT(*)
    INTO ln_count
    FROM OPERACION.OPEDD O, OPERACION.TIPOPEDD T
   WHERE O.TIPOPEDD = T.TIPOPEDD
     AND T.TIPOPEDD = 260
     AND O.DESCRIPCION = 'PORTABILIDAD INSTALACION 3 PLAY INALAMBRICO';
  If ln_count = 0 Then
    INSERT INTO OPERACION.OPEDD
      (CODIGON, DESCRIPCION, TIPOPEDD)
    VALUES
      ((SELECT WFDEF
         FROM WFDEF
        WHERE DESCRIPCION = 'PORTABILIDAD INSTALACION 3 PLAY INALAMBRICO'),
       'PORTABILIDAD LTE',
       260);
    Commit;
  End If;
  ------------------------------------------------------------------------------------------
  -- Insercion de la Configuracion WF x TIPTRA
  ------------------------------------------------------------------------------------------
  SELECT COUNT(*)
    INTO ln_count
    FROM cusbra.br_sel_wf
   where tiptra = (select tiptra from operacion.tiptrabajo where descripcion = 'PORTABILIDAD INSTALACION 3 PLAY INALAMBRICO')
     and wfdef = (select wfdef from opewf.wfdef where descripcion = 'PORTABILIDAD INSTALACION 3 PLAY INALAMBRICO');
  IF ln_count = 0 THEN
      insert into cusbra.br_sel_wf
        (tiptra, wfdef, flg_select)
      values
        ((select tiptra
           from operacion.tiptrabajo
          where descripcion = 'PORTABILIDAD INSTALACION 3 PLAY INALAMBRICO'),
         (select wfdef
            from opewf.wfdef
           where descripcion = 'PORTABILIDAD INSTALACION 3 PLAY INALAMBRICO'),
         0);
      commit;
  end if;
  ------------------------------------------------------------------------------------------
  -- Insercion de Tarea Cambiar estado a Pendiente de Portabilidad
  ------------------------------------------------------------------------------------------
  ln_count := 0;
  select COUNT(*)
    INTO ln_count
    from opewf.tareadef t
   where t.descripcion =
         'Cambiar estado a Pendiente de Portabilidad';
  IF ln_count = 0 THEN
    insert into OPEWF.TAREADEF
      (TAREADEF,
       TIPO,
       DESCRIPCION,
       PRE_PROC,
       CUR_PROC,
       CHG_PROC,
       POS_PROC,
       PRE_MAIL,
       POS_MAIL,
       FLG_FT,
       FLG_WEB,
       SQL_VAL)
    values
      ((select max(td.TAREADEF) + 1 from OPEWF.TAREADEF td),
       0,
       'Cambiar estado a Pendiente de Portabilidad',
       'SALES.PQ_PORTABILIDAD.P_PORTIN_CHG_EST_SOT', -- Tarea Pre
       null,
       null,
       null, -- Tarea Post
       null,
       null,
       0,
       null,
       null);
       commit;
  end if;
  ------------------------------------------------------------------------------------------
  -- Insercion de Asociacion en TAREAWFDEF
  ------------------------------------------------------------------------------------------
  ln_count := 0;
  FOR lc1 in c1 Loop
    Select count(1) 
      into ln_count
      from opewf.tareawfdef
     where wfdef = (select wfdef from opewf.wfdef where descripcion = 'PORTABILIDAD INSTALACION 3 PLAY INALAMBRICO')
       and tareadef = lc1.tareadef;
    dbms_output.put_line(ln_count);
    If ln_count = 0 Then
      Insert into opewf.tareawfdef (tarea, descripcion, tipo, area, wfdef, tareadef,plazo)
      Values (f_get_id_tareawfdef(),
              lc1.descripcion,
              lc1.tipo,
              lc1.area,
              (select wfdef from opewf.wfdef where descripcion = 'PORTABILIDAD INSTALACION 3 PLAY INALAMBRICO'),
              lc1.tareadef,
              lc1.plazo);
      Commit;
    End If;
  end Loop;
  ln_count := 0;
  Select count(1)
    into ln_count
    from opewf.tareawfdef
   where wfdef = (select wfdef from opewf.wfdef where descripcion = 'PORTABILIDAD INSTALACION 3 PLAY INALAMBRICO')
     and tareadef = (select tareadef from opewf.tareadef where descripcion = 'Cambiar estado a Pendiente de Portabilidad');
  If ln_count = 0 Then
    Insert into opewf.tareawfdef (tarea, descripcion, tipo, area, wfdef, tareadef)
    Values (f_get_id_tareawfdef(),
            'Cambiar estado a Pendiente de Portabilidad',
            0,
            325,
            (select wfdef from opewf.wfdef where descripcion = 'PORTABILIDAD INSTALACION 3 PLAY INALAMBRICO'),
            (select tareadef from opewf.tareadef where descripcion = 'Cambiar estado a Pendiente de Portabilidad'));
    Commit;
  End If;
  ------------------------------------------------------------------------------------------
  -- Actualizacion de Asociacion en TAREAWFDEF
  ------------------------------------------------------------------------------------------
  ln_count := 0;
  --Actualizacion de Pre y Pos Tareas Predeterminadas
  FOR lc1 in c1 Loop
    If lc1.pre_tarea is not null Then
      lv_select := 'select count(1) from opewf.tareawfdef where tarea in (' || lc1.pre_tarea || ')';
      execute immediate lv_select into ln_count;
      if ln_count = 1 Then
        update opewf.tareawfdef
           set pre_tareas = 
               (select tarea from opewf.tareawfdef  
                 where wfdef = (select wfdef from opewf.wfdef where descripcion = 'PORTABILIDAD INSTALACION 3 PLAY INALAMBRICO')
                   and tareadef in (select tareadef from opewf.tareawfdef where tarea = lc1.pre_tarea))
         where wfdef = (select wfdef from opewf.wfdef where descripcion = 'PORTABILIDAD INSTALACION 3 PLAY INALAMBRICO')
           and tareadef in (select tareadef from opewf.tareawfdef where tarea = lc1.tarea);
        commit;
      end If;
    End If;
    If lc1.pos_tarea is not null Then
      lv_select := 'select count(1) from opewf.tareawfdef where tarea in (' || lc1.pos_tarea || ')';
      execute immediate lv_select into ln_count;
      if ln_count = 1 Then
        update opewf.tareawfdef
           set pos_tareas = 
               (select tarea from opewf.tareawfdef  
                 where wfdef = (select wfdef from opewf.wfdef where descripcion = 'PORTABILIDAD INSTALACION 3 PLAY INALAMBRICO')
                   and tareadef in (select tareadef from opewf.tareawfdef where tarea = lc1.pos_tarea))
         where wfdef = (select wfdef from opewf.wfdef where descripcion = 'PORTABILIDAD INSTALACION 3 PLAY INALAMBRICO')
           and tareadef in (select tareadef from opewf.tareawfdef where tarea = lc1.tarea);
        commit;
      end If;
    End If;
  End Loop;
  --Actualizacion de Tarea Activacion de Servicios Inalambricos
  Select tarea 
    into lv_pos1
    from opewf.tareawfdef
   where wfdef = (select wfdef from opewf.wfdef where descripcion = 'PORTABILIDAD INSTALACION 3 PLAY INALAMBRICO')
     and tareadef in (select tareadef from opewf.tareadef where descripcion = 'Validacion de Instalacion de Servicio Inalambrico');
  lv_pos2 := lv_pos1;
  Select tarea 
    into lv_pos1
    from opewf.tareawfdef
   where wfdef = (select wfdef from opewf.wfdef where descripcion = 'PORTABILIDAD INSTALACION 3 PLAY INALAMBRICO')
     and tareadef in (select tareadef from opewf.tareadef where descripcion = 'Pre-Seleccion');     
  lv_pos2 := lv_pos2 || ';' || lv_pos1;
  Select tarea 
    into lv_pos1
    from opewf.tareawfdef
   where wfdef = (select wfdef from opewf.wfdef where descripcion = 'PORTABILIDAD INSTALACION 3 PLAY INALAMBRICO')
     and tareadef in (select tareadef from opewf.tareadef where descripcion = 'Cambiar estado a Pendiente de Portabilidad');     
  lv_pos2 := lv_pos2 || ';' || lv_pos1;
  update opewf.tareawfdef
     set pos_tareas = lv_pos2
   where wfdef = (select wfdef from opewf.wfdef where descripcion = 'PORTABILIDAD INSTALACION 3 PLAY INALAMBRICO')
     and tareadef in (select tareadef from opewf.tareadef where descripcion = 'Activacion de Servicios Inalambricos');
  commit;
  --Actualizacion de Tarea Validacion de Instalacion de Servicio Inalambrico
  Select tarea 
    into lv_pos1
    from opewf.tareawfdef
   where wfdef = (select wfdef from opewf.wfdef where descripcion = 'PORTABILIDAD INSTALACION 3 PLAY INALAMBRICO')
     and tareadef in (select tareadef from opewf.tareadef where descripcion = 'Gestion documentacion Inalambrico');
  lv_pos2 := lv_pos1;
  Select tarea 
    into lv_pos1
    from opewf.tareawfdef
   where wfdef = (select wfdef from opewf.wfdef where descripcion = 'PORTABILIDAD INSTALACION 3 PLAY INALAMBRICO')
     and tareadef in (select tareadef from opewf.tareadef where descripcion = 'Gestion fotos Inalambrico');     
  lv_pos2 := lv_pos2 || ';' || lv_pos1;
  update opewf.tareawfdef
     set pos_tareas = lv_pos2
   where wfdef = (select wfdef from opewf.wfdef where descripcion = 'PORTABILIDAD INSTALACION 3 PLAY INALAMBRICO')
     and tareadef in (select tareadef from opewf.tareadef where descripcion = 'Validacion de Instalacion de Servicio Inalambrico');  
  commit;
  --Actualizacion de Tarea Cambiar estado a Pendiente de Portabilidad
  Select tarea 
    into lv_pos1
    from opewf.tareawfdef
   where wfdef = (select wfdef from opewf.wfdef where descripcion = 'PORTABILIDAD INSTALACION 3 PLAY INALAMBRICO')
     and tareadef in (select tareadef from opewf.tareadef where descripcion = 'Activacion de Servicios Inalambricos');
  update opewf.tareawfdef
     set pre_tareas = lv_pos1
   where wfdef = (select wfdef from opewf.wfdef where descripcion = 'PORTABILIDAD INSTALACION 3 PLAY INALAMBRICO')
     and tareadef in (select tareadef from opewf.tareadef where descripcion = 'Cambiar estado a Pendiente de Portabilidad');  
  commit;
  ------------------------------------------------------------------------------------------
  -- Insercion de la Matriz de Configuraciones
  ------------------------------------------------------------------------------------------
  INSERT INTO OPERACION.TIPOPEDD (DESCRIPCION,ABREV)
  VALUES ('PORTABILIDAD IN LTE','PORT_IN');

  INSERT INTO OPERACION.OPEDD(CODIGOC,DESCRIPCION,ABREVIACION,TIPOPEDD)
  VALUES('15', 'Longitud del Telefono','LEN_TLF',(SELECT TIPOPEDD FROM TIPOPEDD WHERE ABREV = 'PORT_IN'));

  INSERT INTO OPERACION.OPEDD(CODIGOC,DESCRIPCION,ABREVIACION,TIPOPEDD)
  VALUES('|90;04|91;01,02,03|92;05|', 'Codigo de Region','COD_REG',(SELECT TIPOPEDD FROM TIPOPEDD WHERE ABREV = 'PORT_IN'));

  INSERT INTO OPERACION.OPEDD(CODIGOC,DESCRIPCION,ABREVIACION,TIPOPEDD)
  VALUES('HLR06', 'Codigo HLR','HLR',(SELECT TIPOPEDD FROM TIPOPEDD WHERE ABREV = 'PORT_IN'));

  INSERT INTO OPERACION.OPEDD(CODIGOC,DESCRIPCION,ABREVIACION,TIPOPEDD)
  VALUES('01', 'Tipo de Nro de Telefono','TIPO_TLF',(SELECT TIPOPEDD FROM TIPOPEDD WHERE ABREV = 'PORT_IN'));

  INSERT INTO OPERACION.OPEDD(CODIGOC,DESCRIPCION,ABREVIACION,TIPOPEDD)
  VALUES('02', 'Clasificacion de la Red','CLASF_RED',(SELECT TIPOPEDD FROM TIPOPEDD WHERE ABREV = 'PORT_IN'));
    
  COMMIT;
END;
/