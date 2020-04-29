CREATE OR REPLACE TRIGGER OPERACION.T_EFPTO_BIU
-- 1.0 REQ 128635 141200
  before insert or update on EFPTO
  REFERENCING OLD AS OLD NEW AS NEW
  for each row
declare
  orden number;
begin

SELECT OPERACION.SQ_EFPTO_LOG.nextval INTO orden FROM DUMMY_OPE;

if inserting and (:new.fecconasig_sop is not null) and (:new.codcon is not null) then
  insert into OPERACION.EFPTO_LOG
  values
    (orden,:new.CODEF, :new.PUNTO, sysdate, user, :new.CODCON);

elsif updating('CODCON') and (:new.codcon<> nvl(:old.codcon,0)) then
  insert into OPERACION.EFPTO_LOG
  values
    (orden,:new.CODEF, :new.PUNTO, sysdate, user, :new.CODCON);

end if;

end;
/



