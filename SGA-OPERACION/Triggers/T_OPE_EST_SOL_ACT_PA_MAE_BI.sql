CREATE OR REPLACE TRIGGER OPERACION.t_ope_est_sol_act_pa_mae_bi
  before insert on operacion.ope_est_sol_act_pa_mae
  referencing old as old new as new
  for each row
/********************************************************************************************
     ver     fecha          autor                solicitado por          descripcion
    ------  ----------  --------------------    ---------------    ------------------------
     1.0     04/06/2010  joseph asencios         req-118672        creación
 ********************************************************************************************/
declare
begin
  if :new.estado is null then
      select sq_ope_est_sol_act_pa.nextval
             into :new.estado
      from operacion.dummy_ope;
  end if;
end;
/



