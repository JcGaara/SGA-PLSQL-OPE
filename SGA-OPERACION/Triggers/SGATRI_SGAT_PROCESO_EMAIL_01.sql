CREATE OR REPLACE TRIGGER OPERACION.SGATRI_SGAT_PROCESO_EMAIL_01
  BEFORE INSERT ON OPERACION.SGAT_PROCESO_ENVIO_MAIL
  REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW
    WHEN (NEW.PEMN_IDMSJ IS NULL)
BEGIN
    :new.PEMV_USUREG := user;
    :new.PEMD_FECREG := sysdate;
    SELECT OPERACION.SGASEQ_SGAT_PROCESO_ENVIO_MAIL.NEXTVAL INTO :NEW.PEMN_IDMSJ FROM DUAL;
END;
/