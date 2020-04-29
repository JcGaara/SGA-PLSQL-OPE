CREATE OR REPLACE TRIGGER OPERACION.T_VIGRESUMEN_BI
BEFORE INSERT
ON OPERACION.VIGRESUMEN
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
DECLARE

BEGIN
   if :new.id is null then
      SELECT SQ_VIGRESUMEN.NEXTVAL  INTO :new.id FROM dual;
   end if;
END;
/



