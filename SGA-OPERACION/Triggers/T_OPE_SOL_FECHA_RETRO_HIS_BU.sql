CREATE OR REPLACE TRIGGER OPERACION.t_ope_sol_fecha_retro_his_bu
   before update on operacion.ope_solicitud_fecha_retro_his
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



