DECLARE
  ln_count NUMBER;
BEGIN

  ln_count := 0;

  SELECT COUNT(1)
    INTO ln_count
    FROM OPERACION.tiptrabajo
   where descripcion = 'FTTH/SIAC - SUSPENSION DEL SERVICIO';

  IF ln_count = 0 THEN
    insert into OPERACION.tiptrabajo
      (tiptra,
       tiptrs,
       descripcion,
       fecusu,
       codusu,
       flgcom,
       flgpryint,
       sotfacturable,
       agendable,
       corporativo,
       selpuntossot)
    values
      ((select max(tiptra) + 1 from operacion.tiptrabajo),
       (select tiptrs from tiptrs where descripcion = 'Suspension'),
       'FTTH/SIAC - SUSPENSION DEL SERVICIO',
       sysdate,
       user,
       0,
       0,
       0,
       0,
       0,
       0);
  end if;

  ln_count := 0;
  SELECT COUNT(1)
    INTO ln_count
    FROM OPERACION.ope_plantillasot
   where descripcion = 'FTTH - BSCS- SUSPENSION';

  if ln_count = 0 then
    insert into OPERACION.ope_plantillasot
      (descripcion,
       tiptra,
       motot,
       tipsrv,
       diasfeccom,
       areasol,
       estado,
       usureg,
       fecreg)
    values
      ('FTTH - BSCS- SUSPENSION',
       (select tiptra
          from OPERACION.tiptrabajo
         where descripcion = 'FTTH/SIAC - SUSPENSION DEL SERVICIO'),
       (select codmotot from motot where descripcion = 'RETRASO DE PAGOS'),
       (select tipsrv from tystipsrv where dsctipsrv = 'Paquetes Masivos'),
       0,
       201,
       1,
       user,
       sysdate);
  end if;

  ln_count := 0;

  SELECT COUNT(1)
    INTO ln_count
    FROM OPERACION.tiptrabajo
   where descripcion = 'FTTH/SIAC - RECONEXION DEL SERVICIO';

  if ln_count = 0 then
    insert into OPERACION.tiptrabajo
      (tiptra,
       tiptrs,
       descripcion,
       fecusu,
       codusu,
       flgcom,
       flgpryint,
       sotfacturable,
       agendable,
       corporativo,
       selpuntossot)
    values
      ((select max(tiptra) + 1 from operacion.tiptrabajo),
       (select tiptrs from tiptrs where descripcion = 'Reconexion'),
       'FTTH/SIAC - RECONEXION DEL SERVICIO',
       sysdate,
       user,
       0,
       0,
       0,
       0,
       0,
       0);
  end if;

  ln_count := 0;

  SELECT COUNT(1)
    INTO ln_count
    FROM OPERACION.ope_plantillasot
   where descripcion = 'FTTH - BSCS- RECONEXION';

  if ln_count = 0 then
    insert into OPERACION.ope_plantillasot
      (descripcion,
       tiptra,
       motot,
       tipsrv,
       diasfeccom,
       areasol,
       estado,
       usureg,
       fecreg)
    values
      ('FTTH - BSCS- RECONEXION',
       (select tiptra
          from OPERACION.tiptrabajo
         where descripcion = 'FTTH/SIAC - RECONEXION DEL SERVICIO'),
       (select codmotot from motot where descripcion = 'DEUDA CANCELADA'),
       (select tipsrv from tystipsrv where dsctipsrv = 'Paquetes Masivos'),
       0,
       201,
       1,
       user,
       sysdate);
  end if;

  ln_count := 0;

  SELECT COUNT(1)
    INTO ln_count
    FROM OPERACION.tiptrabajo
   where descripcion = 'FTTH/SIAC - BAJA TOTAL DEL SERVICIO';

  if ln_count = 0 then
    insert into OPERACION.tiptrabajo
      (tiptra,
       tiptrs,
       descripcion,
       fecusu,
       codusu,
       flgcom,
       flgpryint,
       sotfacturable,
       agendable,
       num_reagenda,
       corporativo,
       selpuntossot)
    values
      ((select max(tiptra) + 1 from operacion.tiptrabajo),
       (select tiptrs from tiptrs where descripcion = 'Cancelacion'),
       'FTTH/SIAC - BAJA TOTAL DEL SERVICIO',
       sysdate,
       user,
       0,
       0,
       0,
       0,
       4,
       0,
       0);
  end if;

  ln_count := 0;

  SELECT COUNT(1)
    INTO ln_count
    FROM OPERACION.ope_plantillasot
   where descripcion = 'FTTH - BSCS- BAJA';

  if ln_count = 0 then
    insert into OPERACION.ope_plantillasot
      (descripcion,
       tiptra,
       motot,
       tipsrv,
       diasfeccom,
       areasol,
       estado,
       usureg,
       fecreg)
    values
      ('FTTH - BSCS- BAJA',
       (select tiptra
          from OPERACION.tiptrabajo
         where descripcion = 'FTTH/SIAC - BAJA TOTAL DEL SERVICIO'),
       (select codmotot from motot where descripcion = 'RETRASO DE PAGOS'),
       (select tipsrv from tystipsrv where dsctipsrv = 'Paquetes Masivos'),
       0,
       201,
       1,
       user,
       sysdate);
  end if;

  ln_count := 0;

  SELECT COUNT(1)
    INTO ln_count
    FROM OPERACION.tiptrabajo
   where descripcion = 'FTTH/SIAC - BAJA TOTAL DEL SERVICIO';

  IF ln_count = 0 THEN
    insert into OPERACION.tiptrabajo
      (tiptra,
       tiptrs,
       descripcion,
       fecusu,
       codusu,
       flgcom,
       flgpryint,
       sotfacturable,
       agendable,
       num_reagenda,
       corporativo,
       selpuntossot)
    values
      ((select max(tiptra) + 1 from operacion.tiptrabajo),
       (select tiptrs from tiptrs where descripcion = 'Cancelacion'),
       'FTTH/SIAC - BAJA TOTAL DEL SERVICIO',
       sysdate,
       user,
       0,
       0,
       0,
       0,
       0,
       0,
       0);
  end if;

  ln_count := 0;
  SELECT COUNT(1)
    INTO ln_count
    FROM OPERACION.ope_plantillasot
   where descripcion = 'FTTH - BSCS- SUSPENSION';

  if ln_count = 0 then
    insert into OPERACION.ope_plantillasot
      (descripcion,
       tiptra,
       motot,
       tipsrv,
       diasfeccom,
       areasol,
       estado,
       usureg,
       fecreg)
    values
      ('FTTH - BSCS- BAJA',
       (select tiptra
          from OPERACION.tiptrabajo
         where descripcion = 'FTTH/SIAC - BAJA TOTAL DEL SERVICIO'),
       (select codmotot from motot where descripcion = 'RETRASO DE PAGOS'),
       (select tipsrv from tystipsrv where dsctipsrv = 'Paquetes Masivos'),
       0,
       201,
       1,
       user,
       sysdate);
  end if;

  commit;
end;
/
