CREATE OR REPLACE TRIGGER OPERACION.T_MOTOTXAREA_BI
BEFORE INSERT
ON OPERACION.MOTOTXAREA
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
BEGIN

	-- se actualiza temporalmente el campo area para las OT
   if :new.area is null then
   	select area into :new.area from areaope where coddpt = :new.coddpt;
   end if;

END;
/



