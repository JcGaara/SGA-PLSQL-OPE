CREATE OR REPLACE TRIGGER OPERACION.T_accusudpt_BU
BEFORE UPDATE
ON OPERACION.accusudpt
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
BEGIN

	-- se actualiza temporalmente el campo area para las OT
   IF UPDATING ('CODDPT') THEN
  		select area into :new.area from areaope where coddpt = :new.coddpt;
   END IF;
EXCEPTION
	WHEN OTHERS THEN
   		 NULL;

END;
/



