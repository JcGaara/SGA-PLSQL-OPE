CREATE OR REPLACE TRIGGER OPERACION.SGATRU_EF_REGLACOSTEO_PINT
BEFORE UPDATE ON OPERACION.SGAT_EF_REGLACOSTEO_PINT
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
BEGIN
  :new.EFRCV_USUMOD := user;
  :new.EFRCD_FECMOD := sysdate;
END;
/