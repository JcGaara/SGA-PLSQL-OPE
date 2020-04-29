CREATE OR REPLACE TRIGGER OPERACION.T_PREUBI_LOG_BIU
-- 1.0 REQ 128635 141200
  before insert or update on PREUBI
  REFERENCING OLD AS OLD NEW AS NEW
  for each row
declare
  orden number;
begin

SELECT OPERACION.SQ_PREUBI_LOG.nextval INTO orden FROM DUMMY_OPE;
if inserting and (:new.codcon is not null) then
  insert into OPERACION.PREUBI_LOG
  values
    (orden,:new.PUNTO, :new.CODSOLOT, sysdate, user, :new.CODCON);

elsif updating('CODCON') and (:new.codcon<> nvl(:old.codcon,0)) then
  insert into OPERACION.PREUBI_LOG
  values
    (orden,:new.PUNTO, :new.CODSOLOT, sysdate, user, :new.CODCON);
end if;

end;
/



