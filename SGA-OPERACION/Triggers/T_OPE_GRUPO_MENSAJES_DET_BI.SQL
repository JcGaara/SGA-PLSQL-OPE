create or replace trigger OPERACION.T_OPE_GRUPO_MENSAJES_DET_BI
  before insert on OPERACION.OPE_GRUPO_MENSAJES_DET
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
  if :new.IDGRUPOMENSAJE is null then
    select operacion.SQ_GRUPO_MENSAJES_DET.Nextval into ln_id from dummy_ope;
    :new.IDGRUPOMENSAJE := ln_id;
  end if;
end;
/
