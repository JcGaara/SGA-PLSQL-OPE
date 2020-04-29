create or replace trigger OPERACION.T_OPE_MENSAJES_MAE_BI
  before insert on OPERACION.OPE_MENSAJES_MAE
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
  if :new.IDMENSAJE is null then
    select operacion.SQ_MENSAJES_MAE.Nextval into ln_id from dummy_ope;
    :new.IDMENSAJE := ln_id;
  end if;
end;
/
