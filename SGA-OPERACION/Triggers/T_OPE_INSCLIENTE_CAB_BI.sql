create or replace trigger OPERACION.T_OPE_INSCLIENTE_CAB_BI
  before insert on OPERACION.OPE_INSCLIENTE_CAB
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
  select operacion.SQ_INSCLIENTE_CAB.Nextval into ln_id from dummy_ope;
  :new.ID_LOTE := ln_id;
end;
/
