CREATE OR REPLACE TRIGGER OPERACION.T_SOLOTPTO_ID_BIU
BEFORE INSERT OR UPDATE
ON OPERACION.SOLOTPTO_ID
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
DECLARE
/******************************************************************************
   NAME:       T_SOLOTPTO_ID_AIU
   PURPOSE:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        26/01/2006   VICTOR HUGO          1. Created this trigger.
   2.0        REQ 128635 141200
   3.0
  ******************************************************************************/
nSecuencial number;
BEGIN
   IF UPDATING ('ESTREQUISIC') THEN
        :NEW.FECMODESTREQ := SYSDATE;
   END IF;

   IF UPDATING ('MOTPOSTERGA') THEN
     IF :NEW.MOTPOSTERGA = 3 THEN
           :NEW.FECPOSTERGA := SYSDATE;
    END IF;
   END IF;
--2.0
  IF INSERTING and :new.codcon is not null THEN
    SELECT SQ_OPE_SOLOTPTO_ID_LOG_AGE.NEXTVAL  INTO nSecuencial FROM dummy_ope;
     INSERT INTO OPERACION.SOLOTPTO_ID_LOG_AGE
     (CODSOLOT,PUNTO,orden,CODCONREAGENDA)
     VALUES(:NEW.CODSOLOT,:NEW.PUNTO,nSecuencial,:NEW.CODCON);
     --ini 3.0
     :NEW.FECASIGCON := sysdate;
     --fin 3.0
  elsif updating('CODCON') and (:new.codcon<> nvl(:old.codcon,0)) then
     SELECT SQ_OPE_SOLOTPTO_ID_LOG_AGE.NEXTVAL  INTO nSecuencial FROM dummy_ope;
     INSERT INTO OPERACION.SOLOTPTO_ID_LOG_AGE
     (CODSOLOT,PUNTO,orden,CODCONREAGENDA)
      VALUES(:NEW.CODSOLOT,:NEW.PUNTO,nSecuencial,:NEW.CODCON);
     --ini 3.0
     :NEW.FECASIGCON := sysdate;
     --fin 3.0
  END IF;
--2.0
END;
/



