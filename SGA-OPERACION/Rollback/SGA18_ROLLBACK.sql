DECLARE
  LN_CONT NUMBER;
BEGIN
  SELECT COUNT(1)
    INTO LN_CONT
    FROM operacion.constante C
   WHERE C.CONSTANTE = 'VAL_CEQU_LTE';
   
  IF LN_CONT = 1 THEN
    delete from operacion.constante c
    where c.constante = 'VAL_CEQU_LTE';
    COMMIT;
  END IF;
END;
/