create or replace trigger OPERACION.T_OPE_PROCESOS_REL_BU
  before update on OPERACION.OPE_PROCESOS_REL
  for each row
    /*********************************************************************************************
  REVISIONES:
  Ver        Fecha        Autor           Descripcion
  ---------  ----------  ---------------  -----------------------------------
  1.0        30/03/2011  Alfonso          REQ-161066: Creación
  ***********************************************************************************************/

declare

begin
  :new.usumod := user;
  :new.fecmod := sysdate;
end;
/
