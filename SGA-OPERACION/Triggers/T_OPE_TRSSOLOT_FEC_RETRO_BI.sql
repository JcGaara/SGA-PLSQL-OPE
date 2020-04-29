CREATE OR REPLACE TRIGGER OPERACION.t_ope_trssolot_fec_retro_bi
  before insert on operacion.ope_trssolot_fecha_retro_det
  referencing old as old new as new
  for each row
/********************************************************************************************
     Ver     Fecha          Autor                Solicitado por          Descripcion
    ------  ----------  --------------------    ---------------    ------------------------
     1.0     04/06/2010  Joseph Asencios         REQ-118672        Creación
 ********************************************************************************************/
declare
begin
  if :new.idsec is null then
      select sq_ope_trssolot_fec_retro_det.nextval
             into :new.idsec
      from  operacion.dummy_ope;
  end if;
end;
/



