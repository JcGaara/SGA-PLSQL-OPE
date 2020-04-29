create or replace trigger operacion.T_MOTOTXTIPTRA_BI
  before insert on operacion.mototxtiptra
  referencing old as old new as new
  for each row
/*********************************************************************************************
  NOMBRE:            OPERACION.T_MOTOTXTIPTRA_BI
  PROPOSITO:
  REVISIONES:
  Ver        Fecha        Autor           Solicitado por     Descripcion
  ---------  ----------  ---------------  ---------------    ------------------------------------------------------------------
  1.0        04/01/2012  Fernando Canaval Edilberto Astulle  PROY-1332 Motivos de SOT por Tipo de Trabajo
  ***********************************************************************************************/
declare
begin
  if :new.idmotxtip is null then
    select operacion.sq_operacion_mototxtiptra.nextval
      into :new.idmotxtip
      from dummy_ope;
  end if;
end;
/