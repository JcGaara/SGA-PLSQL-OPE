create or replace trigger OPERACION.T_OPE_SERVICIOMENSAJE_REL_BI
  before insert on OPERACION.OPE_SERVICIOMENSAJE_REL
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
  if :new.IDSERVMENS is null then
    select operacion.SQ_SERVICIOMENSAJE_REL.Nextval into ln_id from dummy_ope;
    :new.IDSERVMENS := ln_id;
  end if;
end;
/
