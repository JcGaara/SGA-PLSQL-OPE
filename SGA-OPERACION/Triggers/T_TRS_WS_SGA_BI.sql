create or replace trigger operacion.T_TRS_WS_SGA_BI
  before insert on OPERACION.TRS_WS_SGA
  referencing old as old new as new
  for each row
/********************************************************************************************
     Ver     Fecha          Autor                Solicitado por          Descripcion
    ------  ----------  --------------------    ---------------    ------------------------
     1.0     15/10/2012  Edilberto Astulle	PROY-3968_Optimizacion de Interface Intraway - SGA para la carga de equipos
 ********************************************************************************************/
declare

begin
  if :new.IDTRANSACCION is null then
    select OPERACION.SEQ_EQU_IW.NExTVAL into :new.IDTRANSACCION from dummy_ope;

  end if;
end;
/
