create or replace trigger OPERACION.T_OPE_TIPOMENSAJE_REL_BI
  before insert on OPERACION.OPE_TIPOMENSAJE_REL
  for each row
    /*********************************************************************************************
  REVISIONES:
  Ver        Fecha        Autor           Descripcion
  ---------  ----------  ---------------  -----------------------------------
  1.0        30/03/2011  Alfonso          REQ-161066: Creaci�n
  ***********************************************************************************************/

declare
  ln_id number;
begin
  select operacion.SQ_TIPOMENSAJE_REL.Nextval into ln_id from dummy_ope;
  :new.CODTIPO := ln_id;
end;
/
