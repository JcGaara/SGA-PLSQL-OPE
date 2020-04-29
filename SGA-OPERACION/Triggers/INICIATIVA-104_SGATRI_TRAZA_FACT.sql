CREATE OR REPLACE TRIGGER OPERACION.SGATRI_TRAZA_FACT
  BEFORE INSERT ON operacion.sgat_traza_fact
  FOR EACH ROW
BEGIN
  IF :NEW.trfan_idtraza IS NULL THEN
    SELECT operacion.SGASEQ_TRAZA_FACT.nextval INTO :NEW.trfan_idtraza FROM DUAL;
  END IF;
  
  :NEW.trfad_fechcact := sysdate;
  :NEW.trfav_usuact   := user;
END;
/