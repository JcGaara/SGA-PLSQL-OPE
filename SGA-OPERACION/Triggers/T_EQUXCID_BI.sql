CREATE OR REPLACE TRIGGER OPERACION.t_equxcid_bi
  before insert on equxcid
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
declare
  -- local variables here
begin
  if :new.area is null then
    select area into :new.area from usuarioope where usuario = user;

  end if;
end t_equxcid_bi;
/



