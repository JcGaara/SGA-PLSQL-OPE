create or replace trigger OPERACION.T_TABEQUIPO_MATERIAL_BU
   before update on OPERACION.TABEQUIPO_MATERIAL
   referencing old as old new as  new
   for each row
/*------------------------------------------------------------------------------------------
    TRIGGER: T_TRSEQUI_PIN_TRS_AIUD
    MODIFICATION HISTORY
    Person       	Date          Comments
    ---------    	----------   --------------------------------------------------------------
    Mauro Zegarra   31/10/2011   Creacion
-------------------------------------------------------------------------------------------*/
declare
begin
	:new.USUMOD := user;
	:new.FECMOD := sysdate;
   

end;
/
