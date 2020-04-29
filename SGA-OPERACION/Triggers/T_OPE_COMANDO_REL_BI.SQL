create or replace trigger OPERACION.T_OPE_COMANDO_REL_BI
  before insert on OPERACION.OPE_COMANDO_REL
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
  if :new.IDCOMANDO is null then
    select operacion.SQ_COMANDO_REL.Nextval into ln_id from dummy_ope;
    :new.IDCOMANDO := ln_id;
  end if;
end;
/
