CREATE OR REPLACE TRIGGER OPERACION.T_PREUBIETAACT_BI
BEFORE INSERT
ON OPERACION.PREUBIETAACT
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
BEGIN
   if :new.idact is null then
      select SQ_PREUBIETAACT.nextval into :new.idact from dual;
   end if;

exception
when others then
  RAISE_APPLICATION_ERROR(-20500,'No hay tip de servicio');
END;
/



