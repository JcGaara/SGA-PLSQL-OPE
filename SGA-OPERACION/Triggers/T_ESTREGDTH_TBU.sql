CREATE OR REPLACE TRIGGER OPERACION.T_ESTREGDTH_TBU
  BEFORE UPDATE ON OPERACION.ESTREGDTH
  REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW
BEGIN
  :NEW.USUMOD := USER;
  :NEW.FECMOD := SYSDATE;
END;
/



