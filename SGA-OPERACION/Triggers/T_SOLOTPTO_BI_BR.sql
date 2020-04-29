CREATE OR REPLACE TRIGGER OPERACION.T_SOLOTPTO_BI_BR
BEFORE INSERT
ON OPERACION.SOLOTPTO
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
BEGIN
   -- Logica para Brasil
   -- Temporal para MT
   if :new.codinssrv is not null then --and :new.flgmt is null then
 		select decode(campo1, null, 0, 1) into :new.flgmt from inssrv where codinssrv = :new.codinssrv;
   end if;

END;
/



