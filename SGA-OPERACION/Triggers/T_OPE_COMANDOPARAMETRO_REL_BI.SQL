create or replace trigger OPERACION.T_OPE_COMANDOPARAMETRO_REL_BI
  before insert on OPERACION.OPE_COMANDOPARAMETRO_REL
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
  if :new.IDDETALLE is null then
    select operacion.SQ_COMANDOPARAMETRO_REL.Nextval into ln_id from dummy_ope;
    :new.IDDETALLE := ln_id;
  end if;
end;
/
