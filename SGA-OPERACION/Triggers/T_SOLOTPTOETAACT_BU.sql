create or replace trigger "OPERACION"."T_SOLOTPTOETAACT_BU" 
 before UPDATE ON solotptoetaact
FOR EACH ROW
DECLARE
fec_actual date;
n_validaestado number;
n_esteta number;

BEGIN
  select esteta into n_esteta from solotptoeta where codsolot=:new.codsolot and punto=:new.punto and orden=:new.orden;
  select count(1) into n_validaestado
  from opedd where tipopedd=224  and codigon=n_esteta;
  if n_validaestado > 0 then
    RAISE_APPLICATION_ERROR(-20500,'No se puede borrar la etapa estando en este estado.');
  end if;
  
   fec_actual := sysdate;
   if UPDATING('candis') then
      if :new.candis <> :old.candis then
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
END;
/
