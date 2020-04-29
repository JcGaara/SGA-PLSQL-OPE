CREATE OR REPLACE TRIGGER OPERACION.T_EFPTOETAACT_BIU
 BEFORE INSERT OR UPDATE ON EFPTOETAACT
FOR EACH ROW
BEGIN
   if :new.moneda_id is null then
      if :new.moneda = 'D' then
         :new.moneda_id := 2;
      else
         :new.moneda_id := 1;
      end if;
   end if;

END T_EFPTOETAACT_BIU;
/



