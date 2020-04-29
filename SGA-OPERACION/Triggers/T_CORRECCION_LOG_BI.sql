CREATE OR REPLACE TRIGGER OPERACION.T_correccion_log_BI
  BEFORE INSERT
  on correccion_log
  for each row
BEGIN
   if :new.IDlog is null then
      Select nvl(max(IDlog),0)+1 into :new.IDlog from correccion_log;
      :new.codusu := user;
      :new.fecusu := sysdate;
   end if;
exception
when others then
     RAISE_APPLICATION_ERROR(-20500,'ERROR AL GENERAR ID');
END;
/



