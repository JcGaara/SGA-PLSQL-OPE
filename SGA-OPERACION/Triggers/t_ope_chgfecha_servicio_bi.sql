create or replace trigger operacion.t_ope_chgfecha_servicio_bi
  before insert on operacion.ope_chgfechaservicio_his
  referencing old as old new as new  
  for each row
declare
/********************************************************************************************
     Ver     Fecha          Autor                Solicitado por          Descripcion
    ------  ----------  --------------------    ---------------    ------------------------
     1.0	17/06/2013  Carlos Lazarte			REQ-164387			Creación
 ********************************************************************************************/
begin
  if :new.idchgfecserv is null then
      select operacion.sq_ope_chgfechaservicio_his_id.nextval
             into :new.idchgfecserv
      from operacion.dummy_ope;
  end if;
end;
