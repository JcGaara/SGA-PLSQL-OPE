DECLARE

  LN_COUNT NUMBER;

BEGIN

  select COUNT(1)
    into LN_COUNT
    from operacion.tipproyecto
   where descripcion = 'FTTH';

  if LN_COUNT = 0 then
  
    insert into operacion.tipproyecto
      (TIPPROYECTO, DESCRIPCION)
    values
      ((select max(tipproyecto) + 1 from operacion.tipproyecto), 'FTTH');
  end if;
  COMMIT;
END;
/
