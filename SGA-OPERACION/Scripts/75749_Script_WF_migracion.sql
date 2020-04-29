declare
  l_tipopedd tipopedd.tipopedd%type;
  l_tiptra   tiptrabajo.tiptra%type;
  l_wfdef    wfdef.wfdef%type;
  ln_count   number;

begin
  ln_count := 0;
  ------------------------------------------------------------------------------------------
  -- Insercion del Workflow
  ------------------------------------------------------------------------------------------
  select count(*)
    into ln_count
    from opewf.wfdef
   where descripcion = 'INSTALACION 3 PLAY INALAMBRICO - MIGRACION';
  if ln_count = 0 then
    insert into OPEWF.WFDEF
      (WFDEF, ESTADO, CLASEWF, DESCRIPCION, VERSION)
    values
      ((select max(WFDEF) + 1 from OPEWF.WFDEF),
       1,
       0,
       'INSTALACION 3 PLAY INALAMBRICO - MIGRACION',
       1)
    returning wfdef into l_wfdef;
    commit;
  end if;
  ------------------------------------------------------------------------------------------
  -- Insercion de Asociacion en TAREAWFDEF
  ------------------------------------------------------------------------------------------
  ------------------------------------------------------------------------------------------
  -- Asociacion de Tarea de Validación del Instalador del Servicio Claro TV Inalambrico
  ------------------------------------------------------------------------------------------
  ln_count := 0;
  select count(*)
    into ln_count
    from opewf.tareawfdef t
   where t.descripcion =
         'Validacion del Instalador del Servicio Claro TV Inalambrico'
     and t.wfdef = l_wfdef;
  if ln_count = 0 then
    insert into opewf.tareawfdef
      (tarea, descripcion, tipo, area, wfdef, tareadef)
    values
      (f_get_id_tareawfdef(),
       'Validacion del Instalador del Servicio Claro TV Inalambrico',
       0,
       325,
       l_wfdef,
       (select tareadef
          from opewf.tareadef
         where descripcion =
               'Validacion del Instalador del Servicio Claro TV Inalambrico'));
    commit;
  end if;
  ------------------------------------------------------------------------------------------
  -- Asociacion de Tarea de Programación Inalambrico
  ------------------------------------------------------------------------------------------
  ln_count := 0;
  select count(*)
    into ln_count
    from opewf.tareawfdef t
   where t.descripcion = 'Programacion Inalambrico'
     and t.wfdef = l_wfdef;
  if ln_count = 0 then
    insert into opewf.tareawfdef
      (tarea, descripcion, tipo, area, wfdef, tareadef, tipo_agenda)
    values
      (f_get_id_tareawfdef(),
       'Programacion Inalambrico',
       0,
       325,
       l_wfdef,
       (select tareadef
          from opewf.tareadef
         where descripcion = 'Programacion Inalambrico'),
       'ACOMETIDA');
    commit;
  end if;
  ------------------------------------------------------------------------------------------
  -- Asociacion de Tarea de Carga Automatica de materiales y MO Inalambrico
  ------------------------------------------------------------------------------------------
  ln_count := 0;
  select count(*)
    into ln_count
    from opewf.tareawfdef t
   where t.descripcion = 'Carga Automatica de materiales y MO Inalambrico'
     and t.wfdef = l_wfdef;
  if ln_count = 0 then
    insert into opewf.tareawfdef
      (tarea, descripcion, tipo, area, wfdef, tareadef)
    values
      (f_get_id_tareawfdef(),
       'Carga Automatica de materiales y MO Inalambrico',
       0,
       325,
       l_wfdef,
       (select tareadef
          from opewf.tareadef
         where descripcion = 'Carga Automatica de materiales y MO Inalambrico'));
    commit;
  end if;
  ------------------------------------------------------------------------------------------
  -- Asociacion de Tarea de Registro de datos Inalambricos
  ------------------------------------------------------------------------------------------
  ln_count := 0;
  select count(*)
    into ln_count
    from opewf.tareawfdef t
   where t.descripcion = 'Registro de datos Inalambricos'
     and t.wfdef = l_wfdef;
  if ln_count = 0 then
    insert into opewf.tareawfdef
      (tarea, descripcion, tipo, area, wfdef, tareadef)
    values
      (f_get_id_tareawfdef(),
       'Registro de datos Inalambricos',
       0,
       325,
       l_wfdef,
       (select tareadef
          from opewf.tareadef
         where descripcion = 'Registro de datos Inalambricos'));
    commit;
  end if;
  ------------------------------------------------------------------------------------------
  -- Asociacion de Tarea de Activación de Servicios Inalambricos
  ------------------------------------------------------------------------------------------
  ln_count := 0;
  select count(*)
    into ln_count
    from opewf.tareawfdef t
   where t.descripcion = 'Activacion de Servicios Inalambricos'
     and t.wfdef = l_wfdef;
  if ln_count = 0 then
    insert into opewf.tareawfdef
      (tarea, descripcion, tipo, area, wfdef, tareadef)
    values
      (f_get_id_tareawfdef(),
       'Activacion de Servicios Inalambricos',
       0,
       325,
       l_wfdef,
       (select tareadef
          from opewf.tareadef
         where descripcion = 'Activacion de Servicios Inalambricos'));
    commit;
  end if;
  ------------------------------------------------------------------------------------------
  -- Asociacion de Tarea de Validacion de Instalacion de Servicio Inalambrico
  ------------------------------------------------------------------------------------------
  ln_count := 0;
  select count(*)
    into ln_count
    from opewf.tareawfdef t
   where t.descripcion = 'Validacion de Instalacion de Servicio Inalambrico'
     and t.wfdef = l_wfdef;
  if ln_count = 0 then
    insert into opewf.tareawfdef
      (tarea, descripcion, tipo, area, wfdef, tareadef)
    values
      (f_get_id_tareawfdef(),
       'Validacion de Instalacion de Servicio Inalambrico',
       0,
       325,
       l_wfdef,
       (select tareadef
          from opewf.tareadef
         where descripcion = 'Validacion de Instalacion de Servicio Inalambrico'));
    commit;
  end if;
  ------------------------------------------------------------------------------------------
  -- Asociacion de Tarea de Gestión fotos Inalambrico
  ------------------------------------------------------------------------------------------
  ln_count := 0;
  select count(*)
    into ln_count
    from opewf.tareawfdef t
   where t.descripcion = 'Gestion fotos Inalambrico'
     and t.wfdef = l_wfdef;
  if ln_count = 0 then
    insert into opewf.tareawfdef
      (tarea, descripcion, tipo, area, wfdef, tareadef)
    values
      (f_get_id_tareawfdef(),
       'Gestion fotos Inalambrico',
       0,
       325,
       l_wfdef,
       (select tareadef
          from opewf.tareadef
         where descripcion = 'Gestion fotos Inalambrico'));
    commit;
  end if;
  ------------------------------------------------------------------------------------------
  -- Asociacion de Tarea de Gestión documentación Inalambrico
  ------------------------------------------------------------------------------------------
  ln_count := 0;
  select count(*)
    into ln_count
    from opewf.tareawfdef t
   where t.descripcion = 'Gestion documentacion Inalambrico'
     and t.wfdef = l_wfdef;
  if ln_count = 0 then
    insert into opewf.tareawfdef
      (tarea, descripcion, tipo, area, wfdef, tareadef)
    values
      (f_get_id_tareawfdef(),
       'Gestion documentacion Inalambrico',
       0,
       397,
       l_wfdef,
       (select tareadef
          from opewf.tareadef
         where descripcion = 'Gestion documentacion Inalambrico'));
    commit;
  end if;
  ------------------------------------------------------------------------------------------
  -- Actualizacion de Asociacion en TAREAWFDEF
  ------------------------------------------------------------------------------------------
  -- Secuencia de Validacion de Instalador de Servicio
  update opewf.tareawfdef
     set pre_tareas = '', pos_tareas = '', plazo = 1, orden = 0
   where tarea = (select tarea
                    from opewf.tareawfdef
                   where tareadef =
                         (select tareadef
                            from opewf.tareadef
                           where descripcion =
                                 'Validacion del Instalador del Servicio Claro TV Inalambrico')
                     and wfdef = l_wfdef);
  commit;
  -- Secuencia de Programacion - post_tarea carga
  update opewf.tareawfdef
     set pos_tareas =
         (select tarea
            from opewf.tareawfdef
           where wfdef = l_wfdef
             and tareadef =
                 (select tareadef
                    from opewf.tareadef
                   where descripcion =
                         'Carga Automatica de materiales y MO Inalambrico')),
         plazo      = 1,
         orden      = 1
   where tarea = (select tarea
                    from opewf.tareawfdef
                   where tareadef =
                         (select tareadef
                            from opewf.tareadef
                           where descripcion = 'Programacion Inalambrico')
                     and wfdef = l_wfdef);
  commit;
  -- Secuencia de Carga Automatica de materiales y MO - WLL
  update opewf.tareawfdef
     set pos_tareas =
         (select tarea
            from opewf.tareawfdef
           where wfdef = l_wfdef
             and tareadef =
                 (select tareadef
                    from opewf.tareadef
                   where descripcion = 'Registro de datos Inalambricos')),
         pre_tareas =
         (select tarea
            from opewf.tareawfdef
           where wfdef = l_wfdef
             and tareadef =
                 (select tareadef
                    from opewf.tareadef
                   where descripcion = 'Programacion Inalambrico')),
         plazo      = 1,
         tipo       = 2
   where tarea = (select tarea
                    from opewf.tareawfdef
                   where tareadef =
                         (select tareadef
                            from opewf.tareadef
                           where descripcion =
                                 'Carga Automatica de materiales y MO Inalambrico')
                     and wfdef = l_wfdef);
  commit;
  -- Secuencia de Registro de Datos
  update opewf.tareawfdef
     set pos_tareas =
         (select tarea
            from opewf.tareawfdef
           where wfdef = l_wfdef
             and tareadef =
                 (select tareadef
                    from opewf.tareadef
                   where descripcion = 'Activacion de Servicios Inalambricos')),
         pre_tareas =
         (select tarea
            from opewf.tareawfdef
           where wfdef = l_wfdef
             and tareadef =
                 (select tareadef
                    from opewf.tareadef
                   where descripcion =
                         'Carga Automatica de materiales y MO Inalambrico')),
         plazo      = 1
   where tarea = (select tarea
                    from opewf.tareawfdef
                   where tareadef =
                         (select tareadef
                            from opewf.tareadef
                           where descripcion = 'Registro de datos Inalambricos')
                     and wfdef = l_wfdef);
  commit;
  -- Secuencia de Activación de Servicios Inalambricos
  update opewf.tareawfdef
     set pos_tareas =
         (select tarea
            from opewf.tareawfdef
           where wfdef = l_wfdef
             and tareadef =
                 (select tareadef
                    from opewf.tareadef
                   where descripcion =
                         'Validacion de Instalacion de Servicio Inalambrico')),
         pre_tareas =
         (select tarea
            from opewf.tareawfdef
           where wfdef = l_wfdef
             and tareadef =
                 (select tareadef
                    from opewf.tareadef
                   where descripcion = 'Registro de datos Inalambricos')),
         plazo      = 1
   where tarea =
         (select tarea
            from opewf.tareawfdef
           where tareadef =
                 (select tareadef
                    from opewf.tareadef
                   where descripcion = 'Activacion de Servicios Inalambricos')
             and wfdef = l_wfdef);
  commit;
  -- Secuencia de Validacion de Instalacion de Servicio Inalambrico
  update opewf.tareawfdef
     set pre_tareas =
         (select tarea
            from opewf.tareawfdef
           where wfdef = l_wfdef
             and tareadef =
                 (select tareadef
                    from opewf.tareadef
                   where descripcion = 'Activacion de Servicios Inalambricos')),
         pos_tareas = trim(to_char((select tarea
                                     from opewf.tareawfdef
                                    where wfdef = l_wfdef
                                      and tareadef =
                                          (select tareadef
                                             from opewf.tareadef
                                            where descripcion =
                                                  'Gestion documentacion Inalambrico')),
                                   '999999')) || ';' ||
                      trim(to_char((select tarea
                                     from opewf.tareawfdef
                                    where wfdef = l_wfdef
                                      and tareadef =
                                          (select tareadef
                                             from opewf.tareadef
                                            where descripcion =
                                                  'Gestion fotos Inalambrico')),
                                   '999999')),
         plazo      = 1
   where tarea = (select tarea
                    from opewf.tareawfdef
                   where tareadef =
                         (select tareadef
                            from opewf.tareadef
                           where descripcion =
                                 'Validacion de Instalacion de Servicio Inalambrico')
                     and wfdef = l_wfdef);
  commit;
  -- Secuencia de Gestion de Documentos
  update opewf.tareawfdef
     set pre_tareas =
         (select tarea
            from opewf.tareawfdef
           where wfdef = l_wfdef
             and tareadef =
                 (select tareadef
                    from opewf.tareadef
                   where descripcion =
                         'Validacion de Instalacion de Servicio Inalambrico')),
         plazo      = 1
   where tarea =
         (select tarea
            from opewf.tareawfdef
           where tareadef =
                 (select tareadef
                    from opewf.tareadef
                   where descripcion = 'Gestion documentacion Inalambrico')
             and wfdef = l_wfdef);
  commit;
  -- Secuencia de Gestion de Fotos
  update opewf.tareawfdef
     set pre_tareas =
         (select tarea
            from opewf.tareawfdef
           where wfdef = l_wfdef
             and tareadef =
                 (select tareadef
                    from opewf.tareadef
                   where descripcion =
                         'Validacion de Instalacion de Servicio Inalambrico')),
         plazo      = 1
   where tarea = (select tarea
                    from opewf.tareawfdef
                   where tareadef =
                         (select tareadef
                            from opewf.tareadef
                           where descripcion = 'Gestion fotos Inalambrico')
                     and wfdef = l_wfdef);

  commit;

  ------------------------------------------------------------------------------------------
  -- Insercion de Tipo de Trabajo
  ------------------------------------------------------------------------------------------
  insert into operacion.tiptrabajo
    (tiptra,
     descripcion,
     flgcom,
     flgpryint,
     sotfacturable,
     agendable,
     corporativo,
     selpuntossot)
  values
    ((select max(tiptra) + 1 from operacion.tiptrabajo),
     'INSTALACION 3 PLAY INALAMBRICO - MIGRACION',
     0,
     0,
     0,
     0,
     0,
     0)
  returning tiptra into l_tiptra;
  commit;

  ------------------------------------------------------------------------------------------
  -- Insercion de Tipo y Estado
  ------------------------------------------------------------------------------------------  
  insert into operacion.tipopedd
    (descripcion, abrev)
  values
    ('DTH Migracion', 'dth_migracion')
  returning tipopedd into l_tipopedd;
  commit;
  
  insert into operacion.opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd)
  values
    (null,
     l_tiptra,
     'Tipo Trabajo DTH - Migracion',
     'tiptra_dth_migra',
     l_tipopedd);

  insert into operacion.opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd)
  values
    (null, 2, 'Ventas DTH', 'ventas_dth', l_tipopedd);

  insert into operacion.opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd)
  values
    ('2', null, 'Tipo Migracion', 'tipo_migracion', l_tipopedd);

  insert into operacion.opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd)
  values
    (null, 29, 'Codigo Reason', 'reason', l_tipopedd);

  insert into operacion.opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd)
  values
    ('T12841', null, 'Usario BSCS', 'user_bscs', l_tipopedd);

  insert into operacion.opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd)
  values
    (null, l_wfdef, 'INSTALACION 3 PLAY INALAMBRICO - MIGRACION', null, 260);
    
  commit;

end;
/
