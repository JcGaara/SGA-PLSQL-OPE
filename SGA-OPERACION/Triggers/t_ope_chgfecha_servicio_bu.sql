create or replace trigger operacion.t_ope_chgfechaservicio_his_bu
  before update on operacion.ope_chgfechaservicio_his
  referencing old as old new as new  
  for each row
declare
/********************************************************************************************
     Ver     Fecha          Autor                Solicitado por          Descripcion
    ------  ----------  --------------------    ---------------    ------------------------
     1.0	17/06/2013  Carlos Lazarte			REQ-164387			Creación
 ********************************************************************************************/
begin
   :new.fecmod := sysdate;
   :new.usumod := user;
end;