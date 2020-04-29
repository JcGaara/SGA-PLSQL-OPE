CREATE OR REPLACE TRIGGER OPERACION.T_CTRLDOC_BU
 BEFORE UPDATE ON CTRLDOC
FOR EACH ROW
BEGIN
   if updating('ESTDOCXCLI') then
      :new.codusumod := user;
      :new.fecusumod := sysdate;
   end if;
END;
/



