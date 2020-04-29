CREATE OR REPLACE TRIGGER OPERACION.t_ope_tipo_res_fec_act_mae_bu
   before update on operacion.ope_tipo_res_fec_act_mae
   referencing old as old new as new
   for each row
/********************************************************************************************
     Ver     Fecha          Autor                Solicitado por          Descripcion
    ------  ----------  --------------------    ---------------    ------------------------
     1.0     04/06/2010  Joseph Asencios         REQ-118672        Creaci�n
 ********************************************************************************************/
declare
begin
   :new.fecmod := sysdate;
   :new.usumod := user;
end;
/



