DECLARE
  LN_CONT NUMBER;
BEGIN
  SELECT COUNT(1)
    INTO LN_CONT
    FROM operacion.constante C
   WHERE C.CONSTANTE = 'VAL_CEQU_LTE';
   
  IF LN_CONT = 0 THEN
    insert into operacion.constante
      (constante, descripcion, tipo, codusu, fecusu, valor, obs)
    values
      ('VAL_CEQU_LTE',
       'Flag de Contingencia para CE LTE',
       'N',
       user,
       sysdate,
       0,
       '1:Flag activo, 0:Flag Inactivo');
    COMMIT;
  END IF;
END;
/