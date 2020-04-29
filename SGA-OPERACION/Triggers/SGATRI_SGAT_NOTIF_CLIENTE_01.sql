CREATE OR REPLACE TRIGGER OPERACION.SGATRI_SGAT_NOTIF_CLIENTE_01
BEFORE INSERT ON  OPERACION.SGAT_NOTIFICACION_CLIENTE
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW 
  WHEN (NEW.CLINN_ID IS NULL)
BEGIN
  :new.CLINV_USUREG := user;
  :new.CLIND_FECREG := sysdate;
  SELECT OPERACION.SGASEQ_NOTIFICACION_CLIENTE.NEXTVAL INTO :NEW.CLINN_ID FROM DUAL;
END;
/