CREATE OR REPLACE TRIGGER OPERACION.T_VIGRESUMEN_LOG_BI
BEFORE INSERT
ON OPERACION.VIGRESUMEN_LOG
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
DECLARE

BEGIN
   if :new.idlog is null then
      SELECT SQ_VIGRESUMEN_LOG.NEXTVAL  INTO :new.idlog FROM dual;
   end if;
END;
/



