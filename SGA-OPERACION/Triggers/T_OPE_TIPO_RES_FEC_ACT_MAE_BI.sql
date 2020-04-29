CREATE OR REPLACE TRIGGER OPERACION.t_ope_tipo_res_fec_act_mae_bi
  before insert on operacion.ope_tipo_res_fec_act_mae
  referencing old as old new as new
  for each row
/********************************************************************************************
     Ver     Fecha          Autor                Solicitado por          Descripcion
    ------  ----------  --------------------    ---------------    ------------------------
     1.0     04/06/2010  Joseph Asencios         REQ-118672        Creación
 ********************************************************************************************/
declare
begin
  if :new.idtipo is null then
      select sq_ope_tipo_res_fec_act_tipo.nextval
             into :new.idtipo
      from  operacion.dummy_ope;
  end if;
end;
/



