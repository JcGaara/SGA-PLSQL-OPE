CREATE OR REPLACE TRIGGER OPERACION.T_LOG_TRS_INTERFACE_IW_BI
  BEFORE INSERT
  on OPERACION.LOG_TRS_INTERFACE_IW
  for each row
 /**************************************************************************
   NOMBRE:     T_LOG_TRS_INTERFACE_IW_BI
   PROPOSITO:  Genera codigo secuencial
   1.0        16/09/2013  Edilberto Astulle
   **************************************************************************/
declare
ln_idlog NUMBER;
begin
   if :new.idlog is null then
       select OPERACION.SQ_TRS_INTERFACE_IW_LOG.nextval into ln_idlog from dummy_ope;
       :new.idlog := ln_idlog;
   end if;
end;
/