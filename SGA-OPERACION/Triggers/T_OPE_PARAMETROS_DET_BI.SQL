create or replace trigger OPERACION.T_OPE_PARAMETROS_DET_BI
  before insert on OPERACION.OPE_PARAMETROS_DET
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
  select operacion.SQ_PARAMETROS_DET.Nextval into ln_id from dummy_ope;
  :new.IDPARAMETRO := ln_id;
end;
/
