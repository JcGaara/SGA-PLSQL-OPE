DECLARE

  LN_COUNT NUMBER;

BEGIN

  select COUNT(1)
    into LN_COUNT
    from operacion.tipproyecto
   where descripcion = 'FTTH';

  if LN_COUNT > 0 then
    delete from operacion.tipproyecto where descripcion = 'FTTH';
  end if;
COMMIT;
END;
/
