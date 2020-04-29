CREATE OR REPLACE TRIGGER OPERACION.T_LOG_ERROR_SGASAP_BI
  BEFORE INSERT
  on OPERACION.LOG_ERROR_SGASAP
  for each row
 /**************************************************************************
   NOMBRE:     T_LOG_ERROR_SGASAP_BI
   PROPOSITO:  Genera codigo secuencial
   1.0        01/10/2013  Edilberto Astulle
   **************************************************************************/
declare
ln_idlog NUMBER;
begin
   if :new.idlog is null then
       select OPERACION.SQ_LOG_ERROR_SGASAP.nextval into ln_idlog from dummy_ope;
       :new.idlog := ln_idlog;
   end if;
end;
/