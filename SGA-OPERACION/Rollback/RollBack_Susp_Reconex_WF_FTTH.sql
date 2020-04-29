------------------------------------------------------------------------------------------
--Eliminar Tareas-----------------------------------------------------------------------
--Suspension

delete from opewf.tareawfdef t
 where trim(t.descripcion) =
       'Suspension/Reconexion Provision Incognito FIJA - FTTH'
   and wfdef =
       (select wfdef
          from opewf.wfdef
         where descripcion = 'FTTH/SIAC - SUSPENSION DEL SERVICIO FIJA');

delete from opewf.tareawfdef t
 where trim(t.descripcion) =
       'Suspension/Reconexion Facturacion BSCS FIJA - FTTH'
   and wfdef =
       (select wfdef
          from opewf.wfdef
         where descripcion = 'FTTH/SIAC - SUSPENSION DEL SERVICIO FIJA');

delete from opewf.tareawfdef t
 where trim(t.descripcion) =
       'Suspension/Reconexion Cobranzas OAC FIJA - FTTH'
   and wfdef =
       (select wfdef
          from opewf.wfdef
         where descripcion = 'FTTH/SIAC - SUSPENSION DEL SERVICIO FIJA');

delete from opewf.tareawfdef t
 where trim(t.descripcion) =
       'Suspension/Reconexion Servicios AUTO FIJA - FTTH'
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

--Reconexion-----------------------------------------------------------------

delete from opewf.tareawfdef t
 where trim(t.descripcion) =
       'Suspension/Reconexion Provision Incognito FIJA - FTTH'
   and wfdef =
       (select wfdef
          from opewf.wfdef
         where descripcion = 'FTTH/SIAC - RECONEXION DEL SERVICIO FIJA');

delete from opewf.tareawfdef t
 where trim(t.descripcion) =
       'Suspension/Reconexion Facturacion BSCS FIJA - FTTH'
   and wfdef =
       (select wfdef
          from opewf.wfdef
         where descripcion = 'FTTH/SIAC - RECONEXION DEL SERVICIO FIJA');

delete from opewf.tareawfdef t
 where trim(t.descripcion) =
       'Suspension/Reconexion Cobranzas OAC FIJA - FTTH'
   and wfdef =
       (select wfdef
          from opewf.wfdef
         where descripcion = 'FTTH/SIAC - RECONEXION DEL SERVICIO FIJA');

delete from opewf.tareawfdef t
 where trim(t.descripcion) =
       'Suspension/Reconexion Servicios AUTO FIJA - FTTH'
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
--tareadef      
    
  delete from opewf.tareadef t
  where t.descripcion =
       'Suspension/Reconexion Provision Incognito FIJA';
       
  delete from opewf.tareadef t
  where t.descripcion =
       'Suspension/Reconexion Facturacion BSCS FIJA';
       
  delete from opewf.tareadef t
  where t.descripcion =
       'Suspension/Reconexion Cobranzas OAC FIJA';
       
  commit;

--------------------------------------------------------------------------------------------     
-- insert- Tareas - antes
-------------------------------------------------------------------------------------------

--Insert tareawfdef-------------------------------------------------------------------------

--1 --INCOGNITO - BSCS
DECLARE
  ln_count NUMBER;
BEGIN
  ln_count := 0;
select COUNT(*)
  INTO ln_count
  from opewf.tareawfdef t
 where trim(t.descripcion) =
       'Suspension/Reconexion Facturacion BSCS - Provision FIJA - FTTH'
   and t.wfdef =
       (select wfdef
          from opewf.wfdef
         where descripcion = 'FTTH/SIAC - SUSPENSION DEL SERVICIO FIJA');
IF ln_count = 0 THEN
  insert into opewf.tareawfdef
    (tarea, descripcion, tipo, area, wfdef, tareadef, estado)
  values
    (f_get_id_tareawfdef(),
     'Suspension/Reconexion Facturacion BSCS - Provision FIJA - FTTH',
     2,
     62,
     (select wfdef
        from opewf.wfdef
       where descripcion = 'FTTH/SIAC - SUSPENSION DEL SERVICIO FIJA'),
     (select tareadef
        from opewf.tareadef
       where upper(descripcion) =
             upper('Suspension/Reconexion Facturacion BSCS - Provision FIJA')),
     1);
  commit;
end if;

--2 --Actualizacion OAC - Provision BSCS FIJA
ln_count := 0;
select COUNT(*)
  INTO ln_count
  from opewf.tareawfdef t
 where trim(t.descripcion) =
       'Suspension/Reconexion Actualizacion OAC - Provision BSCS FIJA - FTTH'
   and t.wfdef =
       (select wfdef
          from opewf.wfdef
         where descripcion = 'FTTH/SIAC - SUSPENSION DEL SERVICIO FIJA');
IF ln_count = 0 THEN
  insert into opewf.tareawfdef
    (tarea, descripcion, tipo, area, wfdef, tareadef, estado)
  values
    (f_get_id_tareawfdef(),
     'Suspension/Reconexion Actualizacion OAC - Provision BSCS FIJA - FTTH',
     2,
     62,
     (select wfdef
        from opewf.wfdef
       where descripcion = 'FTTH/SIAC - SUSPENSION DEL SERVICIO FIJA'),
     (select tareadef
        from opewf.tareadef
       where upper(descripcion) =
             upper('Suspension/Reconexion Actualizacion OAC - Provision BSCS FIJA')),
     1);
  commit;
end if;
--3 -- SGA Servicios AUTO
ln_count := 0;
select COUNT(*)
  INTO ln_count
  from opewf.tareawfdef t
 where trim(t.descripcion) =
       'Activación/Desactivación Servicios AUTO FIJA - FTTH'
   and t.wfdef =
       (select wfdef
          from opewf.wfdef
         where descripcion = 'FTTH/SIAC - SUSPENSION DEL SERVICIO FIJA');
IF ln_count = 0 THEN
  insert into opewf.tareawfdef
    (tarea, descripcion, tipo, area, wfdef, tareadef, estado)
  values
    (f_get_id_tareawfdef(),
     'Activación/Desactivación Servicios AUTO FIJA - FTTH',
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

--INCOGNITO - BSCS
update opewf.tareawfdef
   set orden      = 0,
       pos_tareas =
       (select tarea
          from opewf.tareawfdef
         where tareadef =
               (select tareadef
                  from opewf.tareadef
                 where trim(descripcion) =
                       'Suspension/Reconexion Actualizacion OAC - Provision BSCS FIJA')
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
                       'Suspension/Reconexion Facturacion BSCS - Provision FIJA')
           and wfdef =
               (select wfdef
                  from opewf.wfdef
                 where descripcion =
                       'FTTH/SIAC - SUSPENSION DEL SERVICIO FIJA'));
commit;

--OAC - BSCS
update opewf.tareawfdef
   set orden      = 0,
       pre_tareas =
       (select tarea
          from opewf.tareawfdef
         where tareadef =
               (select tareadef
                  from opewf.tareadef
                 where trim(descripcion) =
                       'Suspension/Reconexion Facturacion BSCS - Provision FIJA')
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
                       'Suspension/Reconexion Actualizacion OAC - Provision BSCS FIJA')
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
                       'Suspension/Reconexion Actualizacion OAC - Provision BSCS FIJA')
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

--Insert tareawfdef-----------------------------------------------------------------------------------------------------

--1 --INCOGNITO - BSCS
ln_count := 0;
select COUNT(*)
  INTO ln_count
  from opewf.tareawfdef t
 where trim(t.descripcion) =
       'Suspension/Reconexion Facturacion BSCS - Provision FIJA - FTTH'
   and t.wfdef =
       (select wfdef
          from opewf.wfdef
         where descripcion = 'FTTH/SIAC - RECONEXION DEL SERVICIO FIJA');
IF ln_count = 0 THEN
  insert into opewf.tareawfdef
    (tarea, descripcion, tipo, area, wfdef, tareadef, estado)
  values
    (opewf.f_get_id_tareawfdef(),
     'Suspension/Reconexion Facturacion BSCS - Provision FIJA - FTTH',
     2,
     62,
     (select wfdef
        from opewf.wfdef
       where descripcion = 'FTTH/SIAC - RECONEXION DEL SERVICIO FIJA'),
     (select tareadef
        from opewf.tareadef
       where upper(descripcion) =
             upper('Suspension/Reconexion Facturacion BSCS - Provision FIJA')),
     1);
  commit;
end if;

--2 --Actualizacion OAC - Provision BSCS FIJA
ln_count := 0;
select COUNT(*)
  INTO ln_count
  from opewf.tareawfdef t
 where trim(t.descripcion) =
       'Suspension/Reconexion Actualizacion OAC - Provision BSCS FIJA - FTTH'
   and t.wfdef =
       (select wfdef
          from opewf.wfdef
         where descripcion = 'FTTH/SIAC - RECONEXION DEL SERVICIO FIJA');
IF ln_count = 0 THEN
  insert into opewf.tareawfdef
    (tarea, descripcion, tipo, area, wfdef, tareadef, estado)
  values
    (opewf.f_get_id_tareawfdef(),
     'Suspension/Reconexion Actualizacion OAC - Provision BSCS FIJA - FTTH',
     2,
     62,
     (select wfdef
        from opewf.wfdef
       where descripcion = 'FTTH/SIAC - RECONEXION DEL SERVICIO FIJA'),
     (select tareadef
        from opewf.tareadef
       where upper(descripcion) =
             upper('Suspension/Reconexion Actualizacion OAC - Provision BSCS FIJA')),
     1);
  commit;
end if;
--3 -- SGA Servicios AUTO
ln_count := 0;
select COUNT(*)
  INTO ln_count
  from opewf.tareawfdef t
 where trim(t.descripcion) =
       'Activación/Desactivación Servicios AUTO FIJA - FTTH'
   and t.wfdef =
       (select wfdef
          from opewf.wfdef
         where descripcion = 'FTTH/SIAC - RECONEXION DEL SERVICIO FIJA');
IF ln_count = 0 THEN
  insert into opewf.tareawfdef
    (tarea, descripcion, tipo, area, wfdef, tareadef, estado)
  values
    (opewf.f_get_id_tareawfdef(),
     'Activación/Desactivación Servicios AUTO FIJA - FTTH',
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
    (opewf.f_get_id_tareawfdef(),
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

---Update Tarea Pre -Post

--INCOGNITO - BSCS
update opewf.tareawfdef
   set orden      = 0,
       pos_tareas =
       (select tarea
          from opewf.tareawfdef
         where tareadef =
               (select tareadef
                  from opewf.tareadef
                 where trim(descripcion) =
                       'Suspension/Reconexion Actualizacion OAC - Provision BSCS FIJA')
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
                       'Suspension/Reconexion Facturacion BSCS - Provision FIJA')
           and wfdef =
               (select wfdef
                  from opewf.wfdef
                 where descripcion =
                       'FTTH/SIAC - RECONEXION DEL SERVICIO FIJA'));
commit;

--OAC - BSCS
update opewf.tareawfdef
   set orden      = 0,
       pre_tareas =
       (select tarea
          from opewf.tareawfdef
         where tareadef =
               (select tareadef
                  from opewf.tareadef
                 where trim(descripcion) =
                       'Suspension/Reconexion Facturacion BSCS - Provision FIJA')
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
                       'Suspension/Reconexion Actualizacion OAC - Provision BSCS FIJA')
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
                       'Suspension/Reconexion Actualizacion OAC - Provision BSCS FIJA')
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

