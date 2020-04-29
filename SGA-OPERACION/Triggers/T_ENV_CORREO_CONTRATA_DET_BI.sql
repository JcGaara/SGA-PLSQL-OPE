CREATE OR REPLACE TRIGGER OPERACION.T_ENV_CORREO_CONTRATA_DET_BI
  BEFORE INSERT
  on OPERACION.CFG_ENV_CORREO_CONTRATA_DET
  for each row
 /**************************************************************************
   NOMBRE:     T_ENV_CORREO_CONTRATA_DET_BI
   PROPOSITO:  Genera codigo secuencial de Tabla

   REVISIONES:
   Ver        Fecha        Autor            Descripcion
   ---------  ----------  ---------------   ------------------------
   1.0        16/03/2010  Edilberto Astulle	Version Inicial
   **************************************************************************/
declare
ln_idcfgdet NUMBER;
begin
   if :new.idcfgdet is null then
       select SQ_CFG_ENV_CONTRATA_DET.nextval into ln_idcfgdet from dummy_ope;
       :new.idcfgdet := ln_idcfgdet;
   end if;
end;
/