CREATE OR REPLACE TRIGGER OPERACION.T_MOT_SOLUCION_BU
  before update on OPERACION.MOT_SOLUCION
  for each row
declare

begin
  :new.usumod := user;
  :new.fecmod := sysdate;
end;
/



