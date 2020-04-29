CREATE OR REPLACE TRIGGER OPERACION.T_flujoxareaot_BI
BEFORE INSERT
ON OPERACION.flujoxareaot
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
BEGIN

	-- se actualiza temporalmente el campo area para las OT
   if :new.area_ori is null then
   	select area into :new.area_ori from areaope where coddpt = :new.coddptori;
   end if;
   if :new.area_des is null then
   	select area into :new.area_des from areaope where coddpt = :new.coddptdes;
   end if;

END;
/



