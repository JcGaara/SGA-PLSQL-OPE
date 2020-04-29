CREATE OR REPLACE TRIGGER OPERACION.T_PREUBIETAEST_BI
BEFORE INSERT
ON OPERACION.PREUBIETAEST
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
BEGIN
   if :new.iditem is null then
      select nvl(max(iditem),0) + 1 into :new.iditem from preubietaest;
   end if;

exception
when others then
  RAISE_APPLICATION_ERROR(-20500,'No hay tip de servicio');
END;
/



