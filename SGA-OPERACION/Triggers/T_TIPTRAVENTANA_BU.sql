CREATE OR REPLACE TRIGGER OPERACION.T_TIPTRAVENTANA_BU
  before update on OPERACION.TIPTRAVENTANA
  for each row
declare

begin
  :new.usumod := user;
  :new.fecmod := sysdate;
end;
/



