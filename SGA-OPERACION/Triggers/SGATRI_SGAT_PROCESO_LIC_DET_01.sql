CREATE OR REPLACE TRIGGER OPERACION.SGATRI_SGAT_PROCESO_LIC_DET_01
BEFORE INSERT ON  OPERACION.SGAT_PROCESO_LIC_DET
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
BEGIN
  :new.licdv_usureg := user;
  :new.licdd_fecreg := sysdate;
END;
/
