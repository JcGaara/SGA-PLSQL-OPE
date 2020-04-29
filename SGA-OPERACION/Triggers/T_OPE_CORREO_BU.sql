create or replace trigger "OPERACION"."T_OPE_CORREO_BU" 
   before update on operacion.ope_correo_mae
   referencing old as old new as new
   for each row
/********************************************************************************************
     Ver     Fecha          Autor                Solicitado por          Descripcion
    ------  ----------  --------------------    ---------------    ------------------------
     1.0     13/10/2011  Kevy Carranza          REQ-161140         Creación
 ********************************************************************************************/
declare
begin
   :new.fecmod := sysdate;
   :new.usumod := user;
end;
/
