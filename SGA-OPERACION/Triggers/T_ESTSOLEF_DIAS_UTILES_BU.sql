CREATE OR REPLACE TRIGGER OPERACION.T_ESTSOLEF_DIAS_UTILES_BU
BEFORE UPDATE
ON OPERACION.ESTSOLEF_DIAS_UTILES
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
BEGIN
     if updating ('fechafin') then
        if :new.fechafin is not null then
           :new.dias := :new.fechafin - :new.fechaini;
        end if;
     end if;
END;
/



