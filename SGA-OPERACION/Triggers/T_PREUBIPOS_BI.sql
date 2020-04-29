CREATE OR REPLACE TRIGGER OPERACION.T_PREUBIPOS_BI
 BEFORE INSERT ON OPERACION.PREUBIPOS
FOR EACH ROW
DECLARE
tmpVar NUMBER;

BEGIN
	if :new.orden is null then
   	select nvl(max(orden),0) + 1 into :new.orden from preubipos where codpre = :new.codpre and idubi = :new.idubi;
   end if;

END;
/



