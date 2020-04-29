CREATE OR REPLACE TRIGGER OPERACION.SGATRI_TRAZA_DET_FACT
  BEFORE INSERT ON operacion.sgat_traza_det_fact
  FOR EACH ROW
BEGIN
  IF :NEW.tdfan_idtrazadt IS NULL THEN
    SELECT operacion.SGASEQ_TRAZA_DET_FACT.nextval INTO :NEW.tdfan_idtrazadt FROM DUAL;
  END IF;

  :NEW.trfad_fecact := sysdate;
  :NEW.trfav_usuact := user;
END;
/