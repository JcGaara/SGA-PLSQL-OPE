CREATE OR REPLACE TRIGGER OPERACION.T_OTPTO_BI
 BEFORE insert ON otpto
FOR EACH ROW
BEGIN
   if :new.feccom is null then
      select ot.feccom into :new.feccom from ot where codot = :new.codot;
   end if;
END;
/



