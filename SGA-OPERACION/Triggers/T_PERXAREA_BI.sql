CREATE OR REPLACE TRIGGER OPERACION.T_PERXAREA_BI
BEFORE INSERT
ON OPERACION.PERXAREA
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
BEGIN

	-- se actualiza temporalmente el campo area para las OT
   if :new.area is null then
   	BEGIN
	   	select area into :new.area from areaope where coddpt = :new.coddpt;
		EXCEPTION
			WHEN OTHERS THEN
   			NULL;
      END;
   end if;
END;
/



