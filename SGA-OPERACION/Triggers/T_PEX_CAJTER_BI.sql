CREATE OR REPLACE TRIGGER OPERACION.T_PEX_CAJTER_BI
  BEFORE INSERT
  ON PEX_CAJTER
  FOR EACH ROW
DECLARE
ls_descripcion VARCHAR(50);
ls_pos VARCHAR2(50);
ls_pre VARCHAR(50);
BEGIN
:NEW.descripcion := NVL(:NEW.pre,'')||:new.cajter||NVL(:NEW.POS,'');

 /*  IF :NEW.pos IS NULL THEN
     ls_pos:='';
   ELSE
     ls_pos:=:NEW.pos;
   END IF;
   IF :NEW.pre IS NULL THEN
     ls_pre:='';
   ELSE
     ls_pre:=:NEW.pre;
   END IF;
   ls_descripcion:=ls_pre + :new.cajter +ls_pos;
   :NEW.descripcion :=  ls_descripcion;*/
END;
/



