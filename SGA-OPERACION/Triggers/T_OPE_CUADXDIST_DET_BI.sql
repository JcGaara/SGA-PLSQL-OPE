create or replace trigger operacion.T_OPE_CUADXDIST_DET_BI
  before insert on operacion.ope_cuadrillaxdistrito_det
  referencing old as old new as new
  for each row
/********************************************************************************************
     Ver     Fecha          Autor                Solicitado por          Descripcion
    ------  ----------  --------------------    ---------------    ------------------------
     1.0     15/06/2012  Edilberto Astulle	PROY_3433_AgendamientoenLineaOperaciones
     2.0     25/07/2012  Edilberto Astulle	PROY_3433_AgendamientoenLineaOperaciones
     3.0     05/11/2012  Edilberto Astulle	PROY-4877 IDEA-5583 Automatización de asignación de PEP's
 ********************************************************************************************/
declare
i integer;
begin
  if :new.id_ope_cuadrillaxdistrito_det is null then
    select OPERACION.SQ_OPE_CUADRILLAXDISTRITO_DET.NExTVAL into :new.id_ope_cuadrillaxdistrito_det
      from dummy_ope;
    --i 1..8, se considera todos los dias de la semana mas el feriado
    for i in 1..8
    loop
      OPERACION.PQ_AGENDAMIENTO.p_ins_horarioxcuadrillaanual(:new.id_ope_cuadrillaxdistrito_det,:new.tiptra,i);
    end loop;
  end if;
end;
/