CREATE OR REPLACE TRIGGER OPERACION.T_PREUBIEST_BI
BEFORE INSERT
ON OPERACION.PREUBIEST
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
BEGIN
   if :new.iditem is null then
      select nvl(max(iditem),0) + 1 into :new.iditem from preubiest;
   end if;
END;
/



