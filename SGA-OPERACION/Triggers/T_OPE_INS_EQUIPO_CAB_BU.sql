CREATE OR REPLACE TRIGGER OPERACION.T_OPE_INS_EQUIPO_CAB_BU
  before update on OPERACION.OPE_INS_EQUIPO_CAB
  for each row
declare

begin
  :new.usumod := user;
  :new.fecmod := sysdate;
end;
/



