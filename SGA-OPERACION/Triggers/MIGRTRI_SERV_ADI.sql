CREATE OR REPLACE TRIGGER OPERACION.MIGRTRI_SERV_ADI
  BEFORE INSERT ON OPERACION.MIGRT_SERV_ADICIONAL
  FOR EACH ROW

BEGIN
	IF :NEW.DATAN_ID IS NULL THEN
       SELECT OPERACION.MIGRSEQ_SERV_ADI.NEXTVAL INTO :NEW.DATAN_ID FROM DUAL;
    END IF;   
END;
/  