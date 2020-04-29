CREATE OR REPLACE TRIGGER OPERACION.t_OPE_LISTA_FILTROS_TMP_bu
   before update on operacion.OPE_LISTA_FILTROS_TMP
   referencing old as old new as new
   for each row
/********************************************************************************************
     Ver     Fecha          Autor                Solicitado por          Descripcion
    ------  ----------  --------------------    ---------------    ------------------------
     1.0     27/04/2010  Joseph Asencios         REQ-106641        Creación
 ********************************************************************************************/
declare
begin
   :new.fecmod := sysdate;
   :new.usumod := user;
end;
/



