CREATE OR REPLACE TRIGGER OPERACION.T_ENV_CORREO_CONTRATA_CON_BI
  BEFORE INSERT
  on OPERACION.CFG_ENV_CORREO_CONTRATA_CON
  for each row
 /**************************************************************************
   NOMBRE:     T_ENV_CORREO_CONTRATA_CON_BI
   PROPOSITO:  Genera codigo secuencial de Tabla

   REVISIONES:
   Ver        Fecha        Autor            Descripcion
   ---------  ----------  ---------------   ------------------------
   1.0        16/03/2010  Edilberto Astulle	Version Inicial
   **************************************************************************/
declare
ln_idcfgcon NUMBER;
begin
   if :new.idcfgcon is null then
       select SQ_CFG_ENV_CONTRATA_CON.nextval into ln_idcfgcon from dummy_ope;
       :new.idcfgcon := ln_idcfgcon;
   end if;
end;
/