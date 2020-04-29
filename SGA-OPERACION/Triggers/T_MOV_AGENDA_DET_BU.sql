CREATE OR REPLACE TRIGGER OPERACION.t_mov_agenda_det_bu
  before update on OPERACION.MOV_AGENDA_DET
  for each row
declare
  -- local variables here
begin
  :new.usumod := user;
  :new.fecmod := sysdate;
end t_mov_agenda_det_bu;
/



