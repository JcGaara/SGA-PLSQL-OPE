CREATE OR REPLACE TRIGGER OPERACION.reginsdth_TBI
  BEFORE INSERT ON operacion.reginsdth
  REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW
DECLARE
  tmpVar NUMBER;
  id     number(10);
BEGIN
  SELECT MAX(TO_NUMBER(numregistro)) INTO id FROM operacion.reginsdth;
  IF id IS NULL THEN
    id := 0;
  END IF;
  id               := id + 1;
  :new.NUMREGISTRO := LPAD(id, 10, '0');
END;
/

ALTER TRIGGER OPERACION.REGINSDTH_TBI DISABLE;



