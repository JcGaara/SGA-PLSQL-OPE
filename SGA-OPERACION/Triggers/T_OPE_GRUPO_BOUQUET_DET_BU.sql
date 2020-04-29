CREATE OR REPLACE TRIGGER OPERACION.t_OPE_GRUPO_BOUQUET_DET_bu
   before update on operacion.OPE_GRUPO_BOUQUET_DET
   referencing old as old new as new
   for each row
/********************************************************************************************
     Ver     Fecha          Autor                Solicitado por          Descripcion
    ------  ----------  --------------------    ---------------    ------------------------
     1.0     22/03/2010  Joseph Asencios         REQ-106641        Creación
 ********************************************************************************************/
declare
begin
   :new.fecmod := sysdate;
   :new.usumod := user;
end;
/



