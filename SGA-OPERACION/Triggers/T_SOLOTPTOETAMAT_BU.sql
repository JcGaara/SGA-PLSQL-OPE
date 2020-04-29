CREATE OR REPLACE TRIGGER OPERACION.t_solotptoetamat_bu
 before UPDATE ON solotptoetamat
FOR EACH ROW
DECLARE
fec_actual date;
BEGIN
   fec_actual := sysdate;
   if UPDATING('candis') then
      if :new.candis <> :old.candis then
         if :new.canins is null then
            :new.canins := :new.candis;
         end if;
         if :new.canliq is null then
            :new.canliq := :new.candis;
         end if;
      end if;
   end if;
   if UPDATING('cosdis') then
      if :new.cosdis <> :old.cosdis then
         if :new.cosliq is null then
            :new.cosliq := :new.cosdis;
         end if;
      end if;
   end if;
   if UPDATING('canins') then
      if :new.canins <> :old.canins then
         if :new.canliq is null then
            :new.canliq := :new.canins;
         end if;
      end if;
   end if;
END;
/



