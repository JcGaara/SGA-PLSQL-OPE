CREATE OR REPLACE TRIGGER OPERACION.T_CFGDW_BI
  BEFORE INSERT
  ON OPERACION.CFGDW
  FOR EACH ROW
BEGIN
   if :new.ID is null then
      Select nvl(max(ID),0)+1 into :new.ID from OPERACION.CFGDW;
   end if;
exception
when others then
     RAISE_APPLICATION_ERROR(-20500,'ERROR AL GENERAR ID');
END;
/



