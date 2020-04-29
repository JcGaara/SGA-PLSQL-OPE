create or replace trigger operacion.T_OPE_RANGO_BI
  before insert on operacion.ope_rango
  referencing old as old new as new  
  for each row
/********************************************************************************************
     Ver     Fecha          Autor                Solicitado por          Descripcion
    ------  ----------  --------------------    ---------------    ------------------------
     1.0     15/06/2012  Edilberto Astulle	PROY_3433_AgendamientoenLineaOperaciones
 ********************************************************************************************/    
declare
i integer;
begin
  if :new.id_rango is null then
    select OPERACION.SQ_OPE_RANGO.NExTVAL into :new.id_RANGO
      from dummy_ope;
  end if;
end;
/