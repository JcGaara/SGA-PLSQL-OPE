DECLARE
  ln_count NUMBER;
BEGIN
  ln_count := 0;

  ------------------------------------------------------------------------------------------
  --Eliminar Tareas----------------------------------------------------------------
  --Suspension
  delete from opewf.tareawfdef t
   where trim(t.descripcion) =
         'Suspension/Reconexion Facturacion BSCS - Provision FIJA - FTTH'
     and wfdef =
         (select wfdef
            from opewf.wfdef
           where descripcion = 'FTTH/SIAC - SUSPENSION DEL SERVICIO FIJA');
  delete from opewf.tareawfdef t
   where trim(t.descripcion) =
         'Suspension/Reconexion Actualizacion OAC - Provision BSCS FIJA - FTTH'
     and wfdef =
         (select wfdef
            from opewf.wfdef
           where descripcion = 'FTTH/SIAC - SUSPENSION DEL SERVICIO FIJA');
  delete from opewf.tareawfdef t
   where trim(t.descripcion) =
         'Activación/Desactivación Servicios AUTO FIJA - FTTH'
     and wfdef =
         (select wfdef
            from opewf.wfdef
           where descripcion = 'FTTH/SIAC - SUSPENSION DEL SERVICIO FIJA');
  delete from opewf.tareawfdef t
   where trim(t.descripcion) =
         'Suspension/Reconexion SIDs Automatico FIJA - FTTH'
     and wfdef =
         (select wfdef
            from opewf.wfdef
           where descripcion = 'FTTH/SIAC - SUSPENSION DEL SERVICIO FIJA');

  commit;

  --Reconexion
  delete from opewf.tareawfdef t
   where trim(t.descripcion) =
         'Suspension/Reconexion Facturacion BSCS - Provision FIJA - FTTH'
     and wfdef =
         (select wfdef
            from opewf.wfdef
           where descripcion = 'FTTH/SIAC - RECONEXION DEL SERVICIO FIJA');
  delete from opewf.tareawfdef t
   where trim(t.descripcion) =
         'Suspension/Reconexion Actualizacion OAC - Provision BSCS FIJA - FTTH'
     and wfdef =
         (select wfdef
            from opewf.wfdef
           where descripcion = 'FTTH/SIAC - RECONEXION DEL SERVICIO FIJA');
  delete from opewf.tareawfdef t
   where trim(t.descripcion) =
         'Activación/Desactivación Servicios AUTO FIJA - FTTH'
     and wfdef =
         (select wfdef
            from opewf.wfdef
           where descripcion = 'FTTH/SIAC - RECONEXION DEL SERVICIO FIJA');
  delete from opewf.tareawfdef t
   where trim(t.descripcion) =
         'Suspension/Reconexion SIDs Automatico FIJA - FTTH'
     and wfdef =
         (select wfdef
            from opewf.wfdef
           where descripcion = 'FTTH/SIAC - RECONEXION DEL SERVICIO FIJA');
  commit;
/*
  delete from opewf.tareadef t
   where t.descripcion =
         'Suspension/Reconexion Facturacion BSCS - Provision FIJA';
  delete from opewf.tareadef t
   where t.descripcion =
         'Suspension/Reconexion Actualizacion OAC - Provision BSCS FIJA';*/
  commit;
  ------------------------------------------------------------------------------------------

  --Insert tareadef: Provision Incognito FIJA------------------------------------------------
  ln_count := 0;
  select COUNT(*)
    INTO ln_count
    from opewf.tareadef t
   where t.descripcion = 'Suspension/Reconexion Provision Incognito FIJA';
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
       'Suspension/Reconexion Provision Incognito FIJA',
       'OPERACION.PKG_PROV_INCOGNITO.SP_SUSPENSION_RECONEXION_PROV', -- Tarea pre,
       null,
       null,
       null,
       null,
       null,
       0,
       null,
       null);
    commit;
  end if;

  --Insert tareadef: Facturacion BSCS FIJA---------------------------------------------------------
  ln_count := 0;
  select COUNT(*)
    INTO ln_count
    from opewf.tareadef t
   where t.descripcion = 'Suspension/Reconexion Facturacion BSCS FIJA';
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
       'Suspension/Reconexion Facturacion BSCS FIJA',
       'OPERACION.PKG_PROV_INCOGNITO.SP_SUSPENSION_RECONEXION_BSCS', -- Tarea Pre
       null,
       null,
       'OPERACION.PQ_SGA_IW.P_UPDATE_PROV_HFC_BSCS', -- Tarea Post
       null,
       null,
       0,
       null,
       null);
    commit;
  end if;

  --Insert tareadef: Cobranzas OAC FIJA---------------------------------------------------------
  ln_count := 0;
  select COUNT(*)
    INTO ln_count
    from opewf.tareadef t
   where t.descripcion = 'Suspension/Reconexion Cobranzas OAC FIJA';
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
       'Suspension/Reconexion Cobranzas OAC FIJA',
       'OPERACION.PKG_PROV_INCOGNITO.SP_UPDATE_ESTADO_OAC', -- Tarea Pre
       null,
       null,
       null,
       null,
       null,
       0,
       null,
       null);
    commit;
  end if;

  ------------------------------------------------------------------------------------------------------------------------
  --****--Insert tareadef: tareadef---------------------------------------------------------

  --1 --INCOGNITO 
  ln_count := 0;
  select COUNT(*)
    INTO ln_count
    from opewf.tareawfdef t
   where trim(t.descripcion) =
         'Suspension/Reconexion Provision Incognito FIJA - FTTH'
     and t.wfdef =
         (select wfdef
            from opewf.wfdef
           where descripcion = 'FTTH/SIAC - SUSPENSION DEL SERVICIO FIJA');
  IF ln_count = 0 THEN
    insert into opewf.tareawfdef
      (tarea, descripcion, tipo, area, wfdef, tareadef, estado)
    values
      (f_get_id_tareawfdef(),
       'Suspension/Reconexion Provision Incognito FIJA - FTTH',
       2,
       62,
       (select wfdef
          from opewf.wfdef
         where descripcion = 'FTTH/SIAC - SUSPENSION DEL SERVICIO FIJA'),
       (select tareadef
          from opewf.tareadef
         where upper(descripcion) =
               upper('Suspension/Reconexion Provision Incognito FIJA')),
       1);
    commit;
  end if;

  --2 -- BSCS
  ln_count := 0;
  select COUNT(*)
    INTO ln_count
    from opewf.tareawfdef t
   where trim(t.descripcion) =
         'Suspension/Reconexion Facturacion BSCS FIJA - FTTH'
     and t.wfdef =
         (select wfdef
            from opewf.wfdef
           where descripcion = 'FTTH/SIAC - SUSPENSION DEL SERVICIO FIJA');
  IF ln_count = 0 THEN
    insert into opewf.tareawfdef
      (tarea, descripcion, tipo, area, wfdef, tareadef, estado)
    values
      (f_get_id_tareawfdef(),
       'Suspension/Reconexion Facturacion BSCS FIJA - FTTH',
       2,
       62,
       (select wfdef
          from opewf.wfdef
         where descripcion = 'FTTH/SIAC - SUSPENSION DEL SERVICIO FIJA'),
       (select tareadef
          from opewf.tareadef
         where upper(descripcion) =
               upper('Suspension/Reconexion Facturacion BSCS FIJA')),
       1);
    commit;
  end if;

  --3 -- Cobranzas OAC 
  ln_count := 0;
  select COUNT(*)
    INTO ln_count
    from opewf.tareawfdef t
   where trim(t.descripcion) =
         'Suspension/Reconexion Cobranzas OAC FIJA - FTTH'
     and t.wfdef =
         (select wfdef
            from opewf.wfdef
           where descripcion = 'FTTH/SIAC - SUSPENSION DEL SERVICIO FIJA');
  IF ln_count = 0 THEN
    insert into opewf.tareawfdef
      (tarea, descripcion, tipo, area, wfdef, tareadef, estado)
    values
      (f_get_id_tareawfdef(),
       'Suspension/Reconexion Cobranzas OAC FIJA - FTTH',
       2,
       62,
       (select wfdef
          from opewf.wfdef
         where descripcion = 'FTTH/SIAC - SUSPENSION DEL SERVICIO FIJA'),
       (select tareadef
          from opewf.tareadef
         where upper(descripcion) =
               upper('Suspension/Reconexion Cobranzas OAC FIJA')),
       1);
    commit;
  end if;
  --4 -- SGA Servicios AUTO - tareawfdef

  ln_count := 0;
  select COUNT(*)
    INTO ln_count
    from opewf.tareawfdef t
   where trim(t.descripcion) =
         'Suspension/Reconexion Servicios AUTO FIJA - FTTH'
     and t.wfdef =
         (select wfdef
            from opewf.wfdef
           where descripcion = 'FTTH/SIAC - SUSPENSION DEL SERVICIO FIJA');
  IF ln_count = 0 THEN
    insert into opewf.tareawfdef
      (tarea, descripcion, tipo, area, wfdef, tareadef, estado)
    values
      (f_get_id_tareawfdef(),
       'Suspension/Reconexion Servicios AUTO FIJA - FTTH',
       2,
       62,
       (select wfdef
          from opewf.wfdef
         where descripcion = 'FTTH/SIAC - SUSPENSION DEL SERVICIO FIJA'),
       (select tareadef
          from opewf.tareadef
         where upper(descripcion) =
               upper('Activación/Desactivación Servicios AUTO')),
       1);
    commit;
  end if;

  --5 -- SGA SIDs Automatico
  ln_count := 0;
  select COUNT(*)
    INTO ln_count
    from opewf.tareawfdef t
   where trim(t.descripcion) =
         'Suspension/Reconexion SIDs Automatico FIJA - FTTH'
     and t.wfdef =
         (select wfdef
            from opewf.wfdef
           where descripcion = 'FTTH/SIAC - SUSPENSION DEL SERVICIO FIJA');
  IF ln_count = 0 THEN
    insert into opewf.tareawfdef
      (tarea, descripcion, tipo, area, wfdef, tareadef, estado)
    values
      (f_get_id_tareawfdef(),
       'Suspension/Reconexion SIDs Automatico FIJA - FTTH',
       2,
       62,
       (select wfdef
          from opewf.wfdef
         where descripcion = 'FTTH/SIAC - SUSPENSION DEL SERVICIO FIJA'),
       (select tareadef
          from opewf.tareadef
         where upper(descripcion) =
               upper('Suspensiones/Reconexion SIDs Automatico')),
       1);
    commit;
  end if;

  ---Update Tarea Pre -Post

  -- 1-- INCOGNITO
  update opewf.tareawfdef
     set orden      = 0,
         pos_tareas =
         (select tarea
            from opewf.tareawfdef
           where tareadef =
                 (select tareadef
                    from opewf.tareadef
                   where trim(descripcion) =
                         'Suspension/Reconexion Facturacion BSCS FIJA')
             and wfdef =
                 (select wfdef
                    from opewf.wfdef
                   where descripcion =
                         'FTTH/SIAC - SUSPENSION DEL SERVICIO FIJA')),
         plazo      = 1
   where tarea =
         (select tarea
            from opewf.tareawfdef
           where tareadef =
                 (select tareadef
                    from opewf.tareadef
                   where descripcion =
                         'Suspension/Reconexion Provision Incognito FIJA')
             and wfdef =
                 (select wfdef
                    from opewf.wfdef
                   where descripcion =
                         'FTTH/SIAC - SUSPENSION DEL SERVICIO FIJA'));
  commit;

  -- 2-- BSCS
  update opewf.tareawfdef
     set orden      = 0,
         pre_tareas =
         (select tarea
            from opewf.tareawfdef
           where tareadef =
                 (select tareadef
                    from opewf.tareadef
                   where trim(descripcion) =
                         'Suspension/Reconexion Provision Incognito FIJA')
             and wfdef =
                 (select wfdef
                    from opewf.wfdef
                   where descripcion =
                         'FTTH/SIAC - SUSPENSION DEL SERVICIO FIJA')),
         pos_tareas =
         (select tarea
            from opewf.tareawfdef
           where tareadef =
                 (select tareadef
                    from opewf.tareadef
                   where trim(descripcion) =
                         'Suspension/Reconexion Cobranzas OAC FIJA')
             and wfdef =
                 (select wfdef
                    from opewf.wfdef
                   where descripcion =
                         'FTTH/SIAC - SUSPENSION DEL SERVICIO FIJA')),
         plazo      = 1
   where tarea =
         (select tarea
            from opewf.tareawfdef
           where tareadef =
                 (select tareadef
                    from opewf.tareadef
                   where descripcion =
                         'Suspension/Reconexion Facturacion BSCS FIJA')
             and wfdef =
                 (select wfdef
                    from opewf.wfdef
                   where descripcion =
                         'FTTH/SIAC - SUSPENSION DEL SERVICIO FIJA'));
  commit;

  --OAC 
  update opewf.tareawfdef
     set orden      = 0,
         pre_tareas =
         (select tarea
            from opewf.tareawfdef
           where tareadef =
                 (select tareadef
                    from opewf.tareadef
                   where trim(descripcion) =
                         'Suspension/Reconexion Facturacion BSCS FIJA')
             and wfdef =
                 (select wfdef
                    from opewf.wfdef
                   where descripcion =
                         'FTTH/SIAC - SUSPENSION DEL SERVICIO FIJA')),
         pos_tareas =
         (select tarea
            from opewf.tareawfdef
           where tareadef =
                 (select tareadef
                    from opewf.tareadef
                   where trim(descripcion) =
                         'Activación/Desactivación Servicios AUTO')
             and wfdef =
                 (select wfdef
                    from opewf.wfdef
                   where descripcion =
                         'FTTH/SIAC - SUSPENSION DEL SERVICIO FIJA')),
         plazo      = 1
   where tarea =
         (select tarea
            from opewf.tareawfdef
           where tareadef =
                 (select tareadef
                    from opewf.tareadef
                   where descripcion =
                         'Suspension/Reconexion Cobranzas OAC FIJA')
             and wfdef =
                 (select wfdef
                    from opewf.wfdef
                   where descripcion =
                         'FTTH/SIAC - SUSPENSION DEL SERVICIO FIJA'));
  commit;

  --SGA Servicios AUTO
  update opewf.tareawfdef
     set orden      = 0,
         pre_tareas =
         (select tarea
            from opewf.tareawfdef
           where tareadef =
                 (select tareadef
                    from opewf.tareadef
                   where trim(descripcion) =
                         'Suspension/Reconexion Cobranzas OAC FIJA')
             and wfdef =
                 (select wfdef
                    from opewf.wfdef
                   where descripcion =
                         'FTTH/SIAC - SUSPENSION DEL SERVICIO FIJA')),
         pos_tareas =
         (select tarea
            from opewf.tareawfdef
           where tareadef =
                 (select tareadef
                    from opewf.tareadef
                   where trim(descripcion) =
                         'Suspensiones/Reconexion SIDs Automatico')
             and wfdef =
                 (select wfdef
                    from opewf.wfdef
                   where descripcion =
                         'FTTH/SIAC - SUSPENSION DEL SERVICIO FIJA')),
         plazo      = 1
   where tarea =
         (select tarea
            from opewf.tareawfdef
           where tareadef =
                 (select tareadef
                    from opewf.tareadef
                   where descripcion =
                         'Activación/Desactivación Servicios AUTO')
             and wfdef =
                 (select wfdef
                    from opewf.wfdef
                   where descripcion =
                         'FTTH/SIAC - SUSPENSION DEL SERVICIO FIJA'));
  commit;

  --SGA SIDs Automatico
  update opewf.tareawfdef
     set orden      = 0,
         pre_tareas =
         (select tarea
            from opewf.tareawfdef
           where tareadef =
                 (select tareadef
                    from opewf.tareadef
                   where trim(descripcion) =
                         'Activación/Desactivación Servicios AUTO')
             and wfdef =
                 (select wfdef
                    from opewf.wfdef
                   where descripcion =
                         'FTTH/SIAC - SUSPENSION DEL SERVICIO FIJA')),
         plazo      = 1
   where tarea =
         (select tarea
            from opewf.tareawfdef
           where tareadef =
                 (select tareadef
                    from opewf.tareadef
                   where descripcion =
                         'Suspensiones/Reconexion SIDs Automatico')
             and wfdef =
                 (select wfdef
                    from opewf.wfdef
                   where descripcion =
                         'FTTH/SIAC - SUSPENSION DEL SERVICIO FIJA'));
  commit;

  ---------------------------------------------------------------------------------------------------------------------------------------
  ---RECONEXION FTTH---------------------------------------------------------------------------------------------------------------------
  ---------------------------------------------------------------------------------------------------------------------------------------

  ln_count := 0;
  ------------------------------------------------------------------------------------------
  -- Insercion del Workflow --
  ------------------------------------------------------------------------------------------

  ------------------------------------------------------------------------------------------------------------------------
  --****--Insert tareadef: Actualizacion SGA FIJA: EXISTEN: tareadef---------------------------------------------------------
  --Insert tareawfdef-----------------------------------------------------------------------------------------------------

  --1 --INCOGNITO - BSCS
  ln_count := 0;
  select COUNT(*)
    INTO ln_count
    from opewf.tareawfdef t
   where trim(t.descripcion) =
         'Suspension/Reconexion Provision Incognito FIJA - FTTH'
     and t.wfdef =
         (select wfdef
            from opewf.wfdef
           where descripcion = 'FTTH/SIAC - RECONEXION DEL SERVICIO FIJA');
  IF ln_count = 0 THEN
    insert into opewf.tareawfdef
      (tarea, descripcion, tipo, area, wfdef, tareadef, estado)
    values
      (f_get_id_tareawfdef(),
       'Suspension/Reconexion Provision Incognito FIJA - FTTH',
       2,
       62,
       (select wfdef
          from opewf.wfdef
         where descripcion = 'FTTH/SIAC - RECONEXION DEL SERVICIO FIJA'),
       (select tareadef
          from opewf.tareadef
         where upper(descripcion) =
               upper('Suspension/Reconexion Provision Incognito FIJA')),
       1);
    commit;
  end if;

  --2 -- BSCS
  ln_count := 0;
  select COUNT(*)
    INTO ln_count
    from opewf.tareawfdef t
   where trim(t.descripcion) =
         'Suspension/Reconexion Facturacion BSCS FIJA - FTTH'
     and t.wfdef =
         (select wfdef
            from opewf.wfdef
           where descripcion = 'FTTH/SIAC - RECONEXION DEL SERVICIO FIJA');
  IF ln_count = 0 THEN
    insert into opewf.tareawfdef
      (tarea, descripcion, tipo, area, wfdef, tareadef, estado)
    values
      (f_get_id_tareawfdef(),
       'Suspension/Reconexion Facturacion BSCS FIJA - FTTH',
       2,
       62,
       (select wfdef
          from opewf.wfdef
         where descripcion = 'FTTH/SIAC - RECONEXION DEL SERVICIO FIJA'),
       (select tareadef
          from opewf.tareadef
         where upper(descripcion) =
               upper('Suspension/Reconexion Facturacion BSCS FIJA')),
       1);
    commit;
  end if;

  --3 -- Cobranzas OAC 
  ln_count := 0;
  select COUNT(*)
    INTO ln_count
    from opewf.tareawfdef t
   where trim(t.descripcion) =
         'Suspension/Reconexion Cobranzas OAC FIJA - FTTH'
     and t.wfdef =
         (select wfdef
            from opewf.wfdef
           where descripcion = 'FTTH/SIAC - RECONEXION DEL SERVICIO FIJA');
  IF ln_count = 0 THEN
    insert into opewf.tareawfdef
      (tarea, descripcion, tipo, area, wfdef, tareadef, estado)
    values
      (f_get_id_tareawfdef(),
       'Suspension/Reconexion Cobranzas OAC FIJA - FTTH',
       2,
       62,
       (select wfdef
          from opewf.wfdef
         where descripcion = 'FTTH/SIAC - RECONEXION DEL SERVICIO FIJA'),
       (select tareadef
          from opewf.tareadef
         where upper(descripcion) =
               upper('Suspension/Reconexion Cobranzas OAC FIJA')),
       1);
    commit;
  end if;
  --3 -- SGA Servicios AUTO
  ln_count := 0;
  select COUNT(*)
    INTO ln_count
    from opewf.tareawfdef t
   where trim(t.descripcion) =
         'Suspension/Reconexion Servicios AUTO FIJA - FTTH'
     and t.wfdef =
         (select wfdef
            from opewf.wfdef
           where descripcion = 'FTTH/SIAC - RECONEXION DEL SERVICIO FIJA');
  IF ln_count = 0 THEN
    insert into opewf.tareawfdef
      (tarea, descripcion, tipo, area, wfdef, tareadef, estado)
    values
      (f_get_id_tareawfdef(),
       'Suspension/Reconexion Servicios AUTO FIJA - FTTH',
       2,
       62,
       (select wfdef
          from opewf.wfdef
         where descripcion = 'FTTH/SIAC - RECONEXION DEL SERVICIO FIJA'),
       (select tareadef
          from opewf.tareadef
         where upper(descripcion) =
               upper('Activación/Desactivación Servicios AUTO')),
       1);
    commit;
  end if;

  --4 -- SGA SIDs Automatico
  ln_count := 0;
  select COUNT(*)
    INTO ln_count
    from opewf.tareawfdef t
   where trim(t.descripcion) =
         'Suspension/Reconexion SIDs Automatico FIJA - FTTH'
     and t.wfdef =
         (select wfdef
            from opewf.wfdef
           where descripcion = 'FTTH/SIAC - RECONEXION DEL SERVICIO FIJA');
  IF ln_count = 0 THEN
    insert into opewf.tareawfdef
      (tarea, descripcion, tipo, area, wfdef, tareadef, estado)
    values
      (f_get_id_tareawfdef(),
       'Suspension/Reconexion SIDs Automatico FIJA - FTTH',
       2,
       62,
       (select wfdef
          from opewf.wfdef
         where descripcion = 'FTTH/SIAC - RECONEXION DEL SERVICIO FIJA'),
       (select tareadef
          from opewf.tareadef
         where upper(descripcion) =
               upper('Suspensiones/Reconexion SIDs Automatico')),
       1);
    commit;
  end if;

  -------------------------------------------------------------------------------------------------------------------
  ---Update Tarea Pre -Post------------------------------------------------------------------------------------------
  -------------------------------------------------------------------------------------------------------------------

  -- 1-- INCOGNITO
  update opewf.tareawfdef
     set orden      = 0,
         pos_tareas =
         (select tarea
            from opewf.tareawfdef
           where tareadef =
                 (select tareadef
                    from opewf.tareadef
                   where trim(descripcion) =
                         'Suspension/Reconexion Facturacion BSCS FIJA')
             and wfdef =
                 (select wfdef
                    from opewf.wfdef
                   where descripcion =
                         'FTTH/SIAC - RECONEXION DEL SERVICIO FIJA')),
         plazo      = 1
   where tarea =
         (select tarea
            from opewf.tareawfdef
           where tareadef =
                 (select tareadef
                    from opewf.tareadef
                   where descripcion =
                         'Suspension/Reconexion Provision Incognito FIJA')
             and wfdef =
                 (select wfdef
                    from opewf.wfdef
                   where descripcion =
                         'FTTH/SIAC - RECONEXION DEL SERVICIO FIJA'));
  commit;

  -- 2-- BSCS
  update opewf.tareawfdef
     set orden      = 0,
         pre_tareas =
         (select tarea
            from opewf.tareawfdef
           where tareadef =
                 (select tareadef
                    from opewf.tareadef
                   where trim(descripcion) =
                         'Suspension/Reconexion Provision Incognito FIJA')
             and wfdef =
                 (select wfdef
                    from opewf.wfdef
                   where descripcion =
                         'FTTH/SIAC - RECONEXION DEL SERVICIO FIJA')),
         pos_tareas =
         (select tarea
            from opewf.tareawfdef
           where tareadef =
                 (select tareadef
                    from opewf.tareadef
                   where trim(descripcion) =
                         'Suspension/Reconexion Cobranzas OAC FIJA')
             and wfdef =
                 (select wfdef
                    from opewf.wfdef
                   where descripcion =
                         'FTTH/SIAC - RECONEXION DEL SERVICIO FIJA')),
         plazo      = 1
   where tarea =
         (select tarea
            from opewf.tareawfdef
           where tareadef =
                 (select tareadef
                    from opewf.tareadef
                   where descripcion =
                         'Suspension/Reconexion Facturacion BSCS FIJA')
             and wfdef =
                 (select wfdef
                    from opewf.wfdef
                   where descripcion =
                         'FTTH/SIAC - RECONEXION DEL SERVICIO FIJA'));
  commit;

  --OAC 
  update opewf.tareawfdef
     set orden      = 0,
         pre_tareas =
         (select tarea
            from opewf.tareawfdef
           where tareadef =
                 (select tareadef
                    from opewf.tareadef
                   where trim(descripcion) =
                         'Suspension/Reconexion Facturacion BSCS FIJA')
             and wfdef =
                 (select wfdef
                    from opewf.wfdef
                   where descripcion =
                         'FTTH/SIAC - RECONEXION DEL SERVICIO FIJA')),
         pos_tareas =
         (select tarea
            from opewf.tareawfdef
           where tareadef =
                 (select tareadef
                    from opewf.tareadef
                   where trim(descripcion) =
                         'Activación/Desactivación Servicios AUTO')
             and wfdef =
                 (select wfdef
                    from opewf.wfdef
                   where descripcion =
                         'FTTH/SIAC - RECONEXION DEL SERVICIO FIJA')),
         plazo      = 1
   where tarea =
         (select tarea
            from opewf.tareawfdef
           where tareadef =
                 (select tareadef
                    from opewf.tareadef
                   where descripcion =
                         'Suspension/Reconexion Cobranzas OAC FIJA')
             and wfdef =
                 (select wfdef
                    from opewf.wfdef
                   where descripcion =
                         'FTTH/SIAC - RECONEXION DEL SERVICIO FIJA'));
  commit;

  --SGA Servicios AUTO
  update opewf.tareawfdef
     set orden      = 0,
         pre_tareas =
         (select tarea
            from opewf.tareawfdef
           where tareadef =
                 (select tareadef
                    from opewf.tareadef
                   where trim(descripcion) =
                         'Suspension/Reconexion Cobranzas OAC FIJA')
             and wfdef =
                 (select wfdef
                    from opewf.wfdef
                   where descripcion =
                         'FTTH/SIAC - RECONEXION DEL SERVICIO FIJA')),
         pos_tareas =
         (select tarea
            from opewf.tareawfdef
           where tareadef =
                 (select tareadef
                    from opewf.tareadef
                   where trim(descripcion) =
                         'Suspensiones/Reconexion SIDs Automatico')
             and wfdef =
                 (select wfdef
                    from opewf.wfdef
                   where descripcion =
                         'FTTH/SIAC - RECONEXION DEL SERVICIO FIJA')),
         plazo      = 1
   where tarea =
         (select tarea
            from opewf.tareawfdef
           where tareadef =
                 (select tareadef
                    from opewf.tareadef
                   where descripcion =
                         'Activación/Desactivación Servicios AUTO')
             and wfdef =
                 (select wfdef
                    from opewf.wfdef
                   where descripcion =
                         'FTTH/SIAC - RECONEXION DEL SERVICIO FIJA'));
  commit;

  --SGA SIDs Automatico
  update opewf.tareawfdef
     set orden      = 0,
         pre_tareas =
         (select tarea
            from opewf.tareawfdef
           where tareadef =
                 (select tareadef
                    from opewf.tareadef
                   where trim(descripcion) =
                         'Activación/Desactivación Servicios AUTO')
             and wfdef =
                 (select wfdef
                    from opewf.wfdef
                   where descripcion =
                         'FTTH/SIAC - RECONEXION DEL SERVICIO FIJA')),
         plazo      = 1
   where tarea =
         (select tarea
            from opewf.tareawfdef
           where tareadef =
                 (select tareadef
                    from opewf.tareadef
                   where descripcion =
                         'Suspensiones/Reconexion SIDs Automatico')
             and wfdef =
                 (select wfdef
                    from opewf.wfdef
                   where descripcion =
                         'FTTH/SIAC - RECONEXION DEL SERVICIO FIJA'));
  commit;

end;
/
