CREATE OR REPLACE TRIGGER OPERACION.SGATRU_SGAT_CID_SERV_LIC_02
BEFORE UPDATE ON OPERACION.SGAT_CID_SERV_LICENCIA
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
BEGIN
  :new.serlv_usumod := user;
  :new.serld_fecmod := sysdate;
END;
/
