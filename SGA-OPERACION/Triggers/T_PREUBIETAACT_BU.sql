CREATE OR REPLACE TRIGGER OPERACION.t_preubietaact_bu
 before UPDATE ON preubietaact
FOR EACH ROW
DECLARE
fec_actual date;
BEGIN
   fec_actual := sysdate;
   if UPDATING('canpro') then
      if :new.canpro <> :old.canpro then
         if :new.candis is null then
            :new.candis := :new.canpro;
         end if;
         if :new.canins is null then
            :new.canins := :new.canpro;
         end if;
         if :new.canliq is null then
            :new.canliq := :new.canpro;
         end if;
      end if;
   end if;
   if UPDATING('cospro') then
      if :new.cospro <> :old.cospro then
         if :new.cosdis is null then
            :new.cosdis := :new.cospro;
         end if;
         if :new.cosins is null then
            :new.cosins := :new.cospro;
         end if;
         if :new.cosliq is null then
            :new.cosliq := :new.cospro;
         end if;
      end if;
   end if;
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
         if :new.cosins is null then
            :new.cosins := :new.cosdis;
         end if;
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
   if UPDATING('cosins') then
      if :new.cosdis <> :old.cosdis then
         if :new.cosliq is null then
            :new.cosliq := :new.cosins;
         end if;
      end if;
   end if;
END;
/



