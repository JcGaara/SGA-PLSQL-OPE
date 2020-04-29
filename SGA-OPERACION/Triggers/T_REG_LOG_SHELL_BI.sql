CREATE OR REPLACE TRIGGER OPERACION.T_REG_LOG_SHELL_BI
  BEFORE INSERT ON OPERACION.REG_LOG_SHELL
  REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW
DECLARE
  maxid NUMBER;
BEGIN
  IF :new.idseq IS NULL THEN
  select OPERACION.SQ_REG_LOG_SHELL.nextval into :new.idseq from dual;
  ELSE
    SELECT OPERACION.SQ_REG_LOG_SHELL.Currval INTO maxid FROM dual;
    WHILE (:new.idseq > maxid) LOOP
      select OPERACION.SQ_REG_LOG_SHELL.nextval into :new.idseq from dual;
      SELECT OPERACION.SQ_REG_LOG_SHELL.Currval INTO maxid FROM dual;
    END LOOP;
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20500, 'ERROR AL GENERAR ID');
END; 
/