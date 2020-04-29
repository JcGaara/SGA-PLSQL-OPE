create or replace trigger OPERACION.T_MOTOTXTIPTRA_BU
  before update on operacion.mototxtiptra
  referencing old as old new as new
  for each row
/*********************************************************************************************
  NOMBRE:            OPERACION.T_MOTOTXTIPTRA_BU
  PROPOSITO:
  REVISIONES:
  Ver        Fecha        Autor           Solicitado por     Descripcion
  ---------  ----------  ---------------  ---------------    ------------------------------------------------------------------
  1.0        04/01/2012  Fernando Canaval Edilberto Astulle  PROY-1332 Motivos de SOT por Tipo de Trabajo
  ***********************************************************************************************/
declare
begin
  :new.usumod := user;
  :new.fecmod := sysdate;
end;
/