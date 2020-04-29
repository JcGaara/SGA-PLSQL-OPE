CREATE OR REPLACE TRIGGER OPERACION.T_CTRLDOC_BI
 BEFORE INSERT ON CTRLDOC
FOR EACH ROW
BEGIN
   if :new.codctrldoc is null then
      select SQ_ctrldoc_cod.nextval into :new.codctrldoc from dual;
   end if;
END;
/



