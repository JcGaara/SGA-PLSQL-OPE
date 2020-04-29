CREATE OR REPLACE TRIGGER OPERACION.t_log_env_x_bouquet_TBI
  BEFORE INSERT ON operacion.log_env_filexbouquet
  REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW
DECLARE
  id     number(15);
BEGIN
  SELECT OPERACION.SQ_IDLOGENV.NEXTVAL INTO id FROM dual;
  :new.idlogenv := id;
END;
/



