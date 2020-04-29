CREATE OR REPLACE TRIGGER OPERACION.T_insprdsla_BI
BEFORE INSERT
ON OPERACION.insprdsla
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
BEGIN
    if :new.idinsprdsla is null then
      :new.idinsprdsla := F_GET_ID_INSPRDsla;
    end if;
END;
/



