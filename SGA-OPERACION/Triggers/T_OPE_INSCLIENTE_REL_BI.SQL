create or replace trigger OPERACION.T_OPE_INSCLIENTE_REL_BI
  before insert on OPERACION.OPE_INSCLIENTE_REL
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
  select operacion.SQ_INSCLIENTE_REL.Nextval into ln_id from dummy_ope;
  :new.IDTRANSMENSAJE := ln_id;
end;
/
