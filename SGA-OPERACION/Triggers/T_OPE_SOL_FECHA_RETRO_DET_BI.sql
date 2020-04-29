CREATE OR REPLACE TRIGGER OPERACION.t_ope_sol_fecha_retro_det_bi
  before insert on operacion.ope_solicitud_fecha_retro_det
  referencing old as old new as new
  for each row
/********************************************************************************************
     Ver     Fecha          Autor                Solicitado por          Descripcion
    ------  ----------  --------------------    ---------------    ------------------------
     1.0     04/06/2010  Joseph Asencios         REQ-118672        Creación
 ********************************************************************************************/
declare
begin
  if :new.iddetsol is null then
      select sq_ope_sol_fecha_retro_det.nextval
             into :new.iddetsol
      from  operacion.dummy_ope;
  end if;
end;
/



