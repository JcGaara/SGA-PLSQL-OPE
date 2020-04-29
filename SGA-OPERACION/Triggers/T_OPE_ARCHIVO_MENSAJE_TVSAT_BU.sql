CREATE OR REPLACE TRIGGER OPERACION.t_ope_archivo_mensaje_tvsat_bu
   before update on operacion.ope_archivo_mensaje_tvsat_cab
   referencing old as old new as new
   for each row
/********************************************************************************************
     Ver     Fecha          Autor                Solicitado por          Descripcion
    ------  ----------  --------------------    ---------------    ------------------------
     1.0     22/03/2010  Joseph Asencios         REQ-106641        Creaci�n
 ********************************************************************************************/
declare
begin
   :new.fecmod := sysdate;
   :new.usumod := user;
end;
/



