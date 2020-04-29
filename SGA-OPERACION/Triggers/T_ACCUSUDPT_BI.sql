CREATE OR REPLACE TRIGGER OPERACION.T_accusudpt_BI
BEFORE INSERT
ON OPERACION.accusudpt
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
BEGIN
-- se actualiza temporalmente el campo area para las OT
   if :new.area is null then
   	begin
	   	select area into :new.area from areaope where coddpt = :new.coddpt;
      exception
      	when others then
         	null;
      end;
   end if;

END;
/



