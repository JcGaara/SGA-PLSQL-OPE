CREATE OR REPLACE TRIGGER OPERACION.t_ope_programa_mensaje_det_bi
  before insert on operacion.ope_programa_mensaje_tv_det
  referencing old as old new as new
  for each row
/********************************************************************************************
     Ver     Fecha          Autor                Solicitado por          Descripcion
    ------  ----------  --------------------    ---------------    ------------------------
     1.0     22/03/2010  Joseph Asencios         REQ-106641        Creación
 ********************************************************************************************/
declare
begin
  if :new.idprogramacion is null then
      select sq_ope_programa_mensaje_det.nextval
             into :new.idprogramacion
      from operacion.dummy_ope;
  end if;
end;
/



