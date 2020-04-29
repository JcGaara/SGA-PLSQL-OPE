create or replace trigger OPERACION.T_OPE_GRUPOS_REL_BI
  before insert on OPERACION.OPE_GRUPOS_REL
  for each row
    /*********************************************************************************************
  REVISIONES:
  Ver        Fecha        Autor           Descripcion
  ---------  ----------  ---------------  -----------------------------------
  1.0        30/03/2011  Alfonso          REQ-161066: Creación
  ***********************************************************************************************/

declare
  ln_id number;
begin
  select operacion.SQ_GRUPOS_REL.Nextval into ln_id from dummy_ope;
  :new.IDGRUPO := ln_id;
end;
/
