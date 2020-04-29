CREATE OR REPLACE TRIGGER OPERACION.T_OPEDD_BI
 BEFORE INSERT ON OPERACION.OPEDD
FOR EACH ROW
DECLARE
tmpVar NUMBER;

BEGIN
   if :new.idopedd is null then
   	select nvl(max(idopedd),0) + 1 into :new.idopedd from opedd;
   end if;

END;
/



