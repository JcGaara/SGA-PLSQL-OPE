create or replace trigger OPERACION.T_OPE_TRANSACCIONES_DET_BI
  before insert on OPERACION.OPE_TRANSACCIONES_DET
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
  select operacion.SQ_TRANSACCIONES_DET.Nextval into ln_id from dummy_ope;
  :new.IDTRANSACCION := ln_id;
end;
/
