DECLARE
  ln_count NUMBER;
BEGIN

  UPDATE operacion.OPEDD
     SET CODIGON_AUX = 9
   WHERE TIPOPEDD = (select tipopedd
                       from operacion.tipopedd
                      where descripcion = 'TIPO DE TRABAJO'
                        and abrev = 'TIPTRABAJO')
     AND ABREVIACION = 'SISACT_FTTH';

  UPDATE operacion.OPEDD
     SET CODIGON_AUX = 5
   WHERE TIPOPEDD = (select tipopedd
                       from operacion.tipopedd
                      where descripcion = 'TIPO DE TRABAJO'
                        and abrev = 'TIPTRABAJO')
     AND ABREVIACION = 'SISACT';

  ln_count := 0;

  SELECT COUNT(1)
    INTO ln_count
    FROM operacion.opedd
   where CODIGON in
         (select tiptra
            from operacion.tiptrabajo
           where descripcion = 'FTTH/SIAC - SUSPENSION DEL SERVICIO')
     and TIPOPEDD =
         (select TIPOPEDD
            from TIPOPEDD
           where descripcion = 'Proceso Corte_Susp_Reconx');

  IF ln_count = 0 THEN
    insert into operacion.opedd
      (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
    values
      ((select max(IDOPEDD) + 1 from opedd),
       '5',
       (select tiptra
          from operacion.tiptrabajo
         where descripcion = 'FTTH/SIAC - SUSPENSION DEL SERVICIO'),
       'FTTH/SIAC - SUSPENSION DEL SERVICIO',
       'SCR',
       (select TIPOPEDD
          from TIPOPEDD
         where descripcion = 'Proceso Corte_Susp_Reconx'));
  end if;

  ln_count := 0;

  SELECT COUNT(1)
    INTO ln_count
    FROM operacion.opedd o, operacion.tipopedd t
   WHERE o.tipopedd = t.tipopedd
     AND t.abrev = 'ASIGNARWFBSCS'
     AND o.codigon_aux = 2
     AND o.codigon =
         (select tiptra
            from operacion.tiptrabajo
           where descripcion = 'FTTH/SIAC - SUSPENSION DEL SERVICIO');

  IF ln_count = 0 THEN
    insert into operacion.opedd
      (IDOPEDD, CODIGON, DESCRIPCION, TIPOPEDD, CODIGON_AUX)
    values
      ((select max(IDOPEDD) + 1 from opedd),
       (select tiptra
          from operacion.tiptrabajo
         where descripcion = 'FTTH/SIAC - SUSPENSION DEL SERVICIO'),
       'FTTH/SIAC - SUSPENSION DEL SERVICIO',
       (SELECT tipopedd
          from operacion.tipopedd t
         WHERE t.abrev = 'ASIGNARWFBSCS'),
       2);
  end if;

  ln_count := 0;
  SELECT COUNT(1)
    INTO ln_count
    FROM operacion.TIPOPEDD
   where abrev = 'SUSXTIPTRA';

  if ln_count = 0 then
  
    insert into OPERACION.TIPOPEDD
      (descripcion, abrev)
    values
      ('Suspension por Tipo de Trabajo', 'SUSXTIPTRA');
  end if;

  ln_count := 0;

  SELECT COUNT(1)
    INTO ln_count
    FROM operacion.opedd
   where descripcion = 'Suspension por Tipo de Trabajo HFC'
     and abreviacion = 'SUSXTIPTRA_HFC';

  IF ln_count = 0 THEN
    insert into OPERACION.OPEDD
      (codigon, descripcion, abreviacion, tipopedd, codigon_aux)
    values
      ((select tiptra
         from OPERACION.tiptrabajo
        where descripcion =
              'HFC - SISACT INSTALACION PAQUETES TODO CLARO DIGITAL'),
       'Suspension por Tipo de Trabajo HFC',
       'SUSXTIPTRA_HFC',
       (select tipopedd from OPERACION.TIPOPEDD where abrev = 'SUSXTIPTRA'),
       (select idtragrucorte
          from COLLECTIONS.cxc_transxgrupocorte
         where idgrupocorte = 56
           and idtrancorte = 2));
  end if;

  ln_count := 0;

  SELECT COUNT(1)
    INTO ln_count
    FROM operacion.opedd
   where descripcion = 'Suspension por Tipo de Trabajo FTTH'
     and abreviacion = 'SUSXTIPTRA_FTTH';

  IF ln_count = 0 THEN
  
    insert into OPERACION.OPEDD
      (codigon, descripcion, abreviacion, tipopedd, codigon_aux)
    values
      ((select tiptra
         from OPERACION.tiptrabajo
        where descripcion =
              'FTTH - SISACT INSTALACION PAQUETES TODO CLARO DIGITAL'),
       'Suspension por Tipo de Trabajo FTTH',
       'SUSXTIPTRA_FTTH',
       (select tipopedd
          from OPERACION.TIPOPEDD
         where abrev like ('SUSXTIPTRA')),
       (select idtragrucorte
          from COLLECTIONS.cxc_transxgrupocorte
         where desabr = 'SUSPENSION FALTA DE PAGO FTTH'));
  end if;

  ln_count := 0;
  select count(1)
    into ln_count
    from OPERACION.TIPOPEDD
   where abrev = 'RECXTIPTRA';

  if ln_count = 0 then
    insert into OPERACION.TIPOPEDD
      (descripcion, abrev)
    values
      ('Reconexión por Tipo de Trabajo', 'RECXTIPTRA');
  end if;

  ln_count := 0;
  SELECT COUNT(1)
    INTO ln_count
    FROM operacion.opedd
   where CODIGON in
         (select tiptra
            from operacion.tiptrabajo
           where descripcion = 'FTTH/SIAC - RECONEXION DEL SERVICIO')
     and TIPOPEDD =
         (select TIPOPEDD
            from TIPOPEDD
           where descripcion = 'Proceso Corte_Susp_Reconx');

  IF ln_count = 0 THEN
    insert into operacion.opedd
      (IDOPEDD,
       CODIGOC,
       CODIGON,
       DESCRIPCION,
       ABREVIACION,
       TIPOPEDD,
       CODIGON_AUX)
    values
      ((select max(IDOPEDD) + 1 from opedd),
       '6',
       (select tiptra
          from operacion.tiptrabajo
         where descripcion = 'FTTH/SIAC - RECONEXION DEL SERVICIO'),
       'FTTH - RECONEXIÓN TODO CLARO POR FALTA DE PAGO',
       'SCR',
       (select TIPOPEDD
          from TIPOPEDD
         where descripcion = 'Proceso Corte_Susp_Reconx'),
       null);
  end if;

  ln_count := 0;
  SELECT COUNT(1)
    INTO ln_count
    FROM operacion.opedd o, operacion.tipopedd t
   WHERE o.tipopedd = t.tipopedd
     AND t.abrev = 'ASIGNARWFBSCS'
     AND o.codigon_aux = 3
     AND o.codigon =
         (select tiptra
            from operacion.tiptrabajo
           where descripcion = 'FTTH/SIAC - RECONEXION DEL SERVICIO');

  IF ln_count = 0 THEN
    insert into operacion.opedd
      (IDOPEDD, CODIGON, DESCRIPCION, TIPOPEDD, CODIGON_AUX)
    values
      ((select max(IDOPEDD) + 1 from opedd),
       (select tiptra
          from operacion.tiptrabajo
         where descripcion = 'FTTH/SIAC - RECONEXION DEL SERVICIO'),
       'FTTH/SIAC - RECONEXION DEL SERVICIO',
       (SELECT tipopedd
          from operacion.tipopedd t
         WHERE t.abrev = 'ASIGNARWFBSCS'),
       3);
  end if;

  ln_count := 0;
  SELECT COUNT(1)
    INTO ln_count
    FROM operacion.opedd
   where descripcion = 'Reconexión por Tipo de Trabajo HFC'
     and abreviacion = 'RECXTIPTRA_HFC';

  if ln_count = 0 then
  
    insert into OPERACION.OPEDD
      (codigon, descripcion, abreviacion, tipopedd, codigon_aux)
    values
      ((select tiptra
         from OPERACION.tiptrabajo
        where descripcion =
              'HFC - SISACT INSTALACION PAQUETES TODO CLARO DIGITAL'),
       'Reconexión por Tipo de Trabajo HFC',
       'RECXTIPTRA_HFC',
       (select tipopedd
          from OPERACION.TIPOPEDD
         where abrev like ('RECXTIPTRA')),
       (select idtragrucorte
          from COLLECTIONS.cxc_transxgrupocorte
         where idgrupocorte = 56
           and idtrancorte = 6));
  end if;

  ln_count := 0;
  SELECT COUNT(1)
    INTO ln_count
    FROM operacion.opedd
   where descripcion = 'Reconexión por Tipo de Trabajo FTTH'
     and abreviacion = 'RECXTIPTRA_FTTH';

  if ln_count = 0 then
    insert into OPERACION.OPEDD
      (codigon, descripcion, abreviacion, tipopedd, codigon_aux)
    values
      ((select tiptra
         from OPERACION.tiptrabajo
        where descripcion =
              'FTTH - SISACT INSTALACION PAQUETES TODO CLARO DIGITAL'),
       'Reconexión por Tipo de Trabajo FTTH',
       'RECXTIPTRA_FTTH',
       (select tipopedd
          from OPERACION.TIPOPEDD
         where abrev like ('RECXTIPTRA')),
       (select idtragrucorte
          from COLLECTIONS.cxc_transxgrupocorte
         where desabr = 'RECONEXION SERVICIO SFP FTTH'));
  end if;

  ln_count := 0;

  SELECT COUNT(1)
    INTO ln_count
    FROM operacion.opedd
   where CODIGON in
         (select tiptra
            from operacion.tiptrabajo
           where descripcion = 'FTTH/SIAC - BAJA TOTAL DEL SERVICIO')
     and TIPOPEDD =
         (select TIPOPEDD
            from TIPOPEDD
           where descripcion = 'Proceso Corte_Susp_Reconx');

  IF ln_count = 0 THEN
    insert into operacion.opedd
      (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
    values
      ((select max(IDOPEDD) + 1 from opedd),
       '5',
       (select tiptra
          from operacion.tiptrabajo
         where descripcion = 'FTTH/SIAC - BAJA TOTAL DEL SERVICIO'),
       'FTTH/SIAC - BAJA DEL SERVICIO',
       'SCR',
       (select TIPOPEDD
          from TIPOPEDD
         where descripcion = 'Proceso Corte_Susp_Reconx'));
  end if;

  ln_count := 0;

  SELECT COUNT(1)
    INTO ln_count
    FROM operacion.opedd o, operacion.tipopedd t
   WHERE o.tipopedd = t.tipopedd
     AND t.abrev = 'ASIGNARWFBSCS'
     AND o.codigon_aux = 1
     AND o.codigon =
         (select tiptra
            from operacion.tiptrabajo
           where descripcion = 'FTTH/SIAC - BAJA TOTAL DEL SERVICIO');

  IF ln_count = 0 THEN
    insert into operacion.opedd
      (IDOPEDD, CODIGON, DESCRIPCION, TIPOPEDD, CODIGON_AUX)
    values
      ((select max(IDOPEDD) + 1 from opedd),
       (select tiptra
          from operacion.tiptrabajo
         where descripcion = 'FTTH/SIAC - BAJA TOTAL DEL SERVICIO'),
       'FTTH/SIAC - BAJA DEL SERVICIO',
       (SELECT tipopedd
          from operacion.tipopedd t
         WHERE t.abrev = 'ASIGNARWFBSCS'),
       1);
  end if;

  ln_count := 0;
  SELECT COUNT(1)
    INTO ln_count
    FROM operacion.TIPOPEDD
   where abrev = 'BAJAXTIPTRA';

  if ln_count = 0 then
  
    insert into OPERACION.TIPOPEDD
      (descripcion, abrev)
    values
      ('Baja por Tipo de Trabajo', 'BAJAXTIPTRA');
  end if;

  ln_count := 0;

  SELECT COUNT(1)
    INTO ln_count
    FROM operacion.opedd
   where descripcion = 'Baja por Tipo de Trabajo HFC'
     and abreviacion = 'BAJAXTIPTRA_HFC';

  IF ln_count = 0 THEN
    insert into OPERACION.OPEDD
      (codigon, descripcion, abreviacion, tipopedd, codigon_aux)
    values
      ((select tiptra
         from OPERACION.tiptrabajo
        where descripcion =
              'HFC - SISACT INSTALACION PAQUETES TODO CLARO DIGITAL'),
       'Baja por Tipo de Trabajo HFC',
       'BAJAXTIPTRA_HFC',
       (select tipopedd from OPERACION.TIPOPEDD where abrev = 'BAJAXTIPTRA'),
       (select idtragrucorte
          from COLLECTIONS.cxc_transxgrupocorte
         where idgrupocorte = 56
           and idtrancorte = 4));
  end if;

  ln_count := 0;

  SELECT COUNT(1)
    INTO ln_count
    FROM operacion.opedd
   where descripcion = 'Baja por Tipo de Trabajo FTTH'
     and abreviacion = 'BAJAXTIPTRA_FTTH';

  IF ln_count = 0 THEN
  
    insert into OPERACION.OPEDD
      (codigon, descripcion, abreviacion, tipopedd, codigon_aux)
    values
      ((select tiptra
         from OPERACION.tiptrabajo
        where descripcion =
              'FTTH - SISACT INSTALACION PAQUETES TODO CLARO DIGITAL'),
       'Baja por Tipo de Trabajo FTTH',
       'BAJAXTIPTRA_FTTH',
       (select tipopedd
          from OPERACION.TIPOPEDD
         where abrev like ('BAJAXTIPTRA')),
       (select idtragrucorte
          from COLLECTIONS.cxc_transxgrupocorte
         where desabr = 'BAJA FALTA DE PAGO FTTH'));
  end if;

  ln_count := 0;

  SELECT COUNT(1)
    INTO ln_count
    FROM operacion.opedd
   where descripcion =
         'FTTH/SISACT - INSTALACION PAQUETES TODO CLARO DIGITAL';

  IF ln_count = 0 THEN
    insert into opedd
      (CODIGON, DESCRIPCION, TIPOPEDD)
    values
      ((select tiptra
         from operacion.tiptrabajo
        where descripcion = 'FTTH/SIAC - BAJA TOTAL DEL SERVICIO'),
       'FTTH/SISACT - INSTALACION PAQUETES TODO CLARO DIGITAL',
       (select tipopedd
          from tipopedd
         where descripcion = 'Tipos de Trabajo en Agenda nue'));
  end if;
  commit;
end;
/
