CREATE OR REPLACE TRIGGER OPERACION.T_OPE_MOT_TIPTRA_DET_BU
  before update on OPERACION.OPE_MOT_TIPTRA_DET
  for each row
declare

begin
  :new.usumod := user;
  :new.fecmod := sysdate;
end;
/



