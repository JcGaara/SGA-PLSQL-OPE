create or replace trigger operacion.t_tarjeta_deco_asoc_bu
   before update on operacion.tarjeta_deco_asoc
   referencing old as old new as  new
   for each row
/*------------------------------------------------------------------------------------------
    TRIGGER: T_TRSEQUI_PIN_TRS_AIUD
    MODIFICATION HISTORY
    Person       	Date          Comments
    ---------    	----------   --------------------------------------------------------------
    Mauro Zegarra   14/11/2011   Creacion
-------------------------------------------------------------------------------------------*/
declare
begin
	:new.USUMOD := user;
	:new.FECMOD := sysdate;
end;
/
