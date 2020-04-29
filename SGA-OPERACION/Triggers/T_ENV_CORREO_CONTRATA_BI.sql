CREATE OR REPLACE TRIGGER OPERACION.T_ENV_CORREO_CONTRATA_BI
  BEFORE INSERT
  on OPERACION.CFG_ENV_CORREO_CONTRATA
  for each row
 /**************************************************************************
   NOMBRE:     T_ENV_CORREO_CONTRATA_BI
   PROPOSITO:  Genera codigo secuencial de Tabla

   REVISIONES:
   Ver        Fecha        Autor            Descripcion
   ---------  ----------  ---------------   ------------------------
   1.0        16/03/2010  Edilberto Astulle	Version Inicial
   **************************************************************************/
declare
ln_idcfg NUMBER;
begin
   if :new.idcfg is null then
       select SQ_CFG_ENV_CONTRATA.nextval into ln_idcfg from dummy_ope;
       :new.IDCFG := ln_idcfg;
   end if;
end;
/