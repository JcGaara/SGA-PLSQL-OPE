CREATE OR REPLACE TRIGGER OPERACION.T_PREUBISEG_BI
 BEFORE INSERT ON preubiseg
FOR EACH ROW
DECLARE
tmpVar NUMBER;
BEGIN
	if :new.orden is null then
	   select nvl(max(orden),0) + 1 into :new.orden from preubiseg where codpre = :new.codpre and idubi = :new.idubi;
   end if;
END;
/



