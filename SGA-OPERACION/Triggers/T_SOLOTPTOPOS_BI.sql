CREATE OR REPLACE TRIGGER OPERACION.T_SOLOTPTOPOS_BI
 BEFORE INSERT ON OPERACION.SOLOTPTOPOS
FOR EACH ROW
DECLARE
tmpVar NUMBER;

BEGIN
	if :new.orden is null then
   	select nvl(max(orden),0) + 1 into :new.orden from solotptopos where codsolot = :new.codsolot and punto = :new.punto;
   end if;

END;
/



