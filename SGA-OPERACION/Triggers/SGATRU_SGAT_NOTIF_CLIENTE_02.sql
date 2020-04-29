CREATE OR REPLACE TRIGGER OPERACION.SGATRU_SGAT_NOTIF_CLIENTE_02
BEFORE UPDATE ON OPERACION.SGAT_NOTIFICACION_CLIENTE
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
BEGIN
  :new.CLINV_USUMOD := user;
  :new.CLIND_FECMOD := sysdate;
END;
/