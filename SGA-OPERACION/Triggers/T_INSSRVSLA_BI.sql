CREATE OR REPLACE TRIGGER OPERACION.T_inssrvsla_BI
BEFORE INSERT
ON OPERACION.inssrvsla
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
BEGIN
    if :new.idinssrvsla is null then
      :new.idinssrvsla := F_GET_ID_INSSRVsla;
    end if;
END;
/



