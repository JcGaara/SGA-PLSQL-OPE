CREATE OR REPLACE TRIGGER OPERACION.t_ope_archiv_tarjeta_tv_det_bi
  before insert on operacion.ope_archivo_tarjeta_tvsat_det
  referencing old as old new as new
  for each row
/********************************************************************************************
     Ver     Fecha          Autor                Solicitado por          Descripcion
    ------  ----------  --------------------    ---------------    ------------------------
     1.0     22/03/2010  Joseph Asencios         REQ-106641        Creación
 ********************************************************************************************/
declare
begin
  if :new.idreg_tarjeta is null then
      select sq_ope_archivo_tarjeta_tv_det.nextval
             into :new.idreg_tarjeta
      from operacion.dummy_ope;
  end if;
end;
/



