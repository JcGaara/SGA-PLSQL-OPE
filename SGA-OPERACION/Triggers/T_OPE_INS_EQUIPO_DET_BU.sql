CREATE OR REPLACE TRIGGER OPERACION.T_OPE_INS_EQUIPO_DET_BU
  before update on OPERACION.OPE_INS_EQUIPO_DET
  for each row
declare

begin
  :new.usumod := user;
  :new.fecmod := sysdate;
end;
/



