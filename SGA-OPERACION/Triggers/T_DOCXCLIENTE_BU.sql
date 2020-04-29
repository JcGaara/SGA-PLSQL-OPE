CREATE OR REPLACE TRIGGER OPERACION.T_DOCXCLIENTE_BU
 BEFORE UPDATE ON DOCXCLIENTE
FOR EACH ROW
BEGIN
   if updating('ESTDOCXCLI') then
      :new.codusumod := user;
      :new.fecusumod := sysdate;
   end if;
END;
/



