create or replace trigger OPERACION.T_OPE_GRUPOMENSSOL_DET_BU
  before update on OPERACION.OPE_GRUPOMENSSOL_DET
  for each row
    /*********************************************************************************************
  REVISIONES:
  Ver        Fecha        Autor           Descripcion
  ---------  ----------  ---------------  -----------------------------------
  1.0        30/03/2011  Alfonso          REQ-161066: Creaci�n
  ***********************************************************************************************/

declare

begin
  :new.usumod := user;
  :new.fecmod := sysdate;
end;
/
