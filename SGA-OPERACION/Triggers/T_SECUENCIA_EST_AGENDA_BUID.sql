create or replace trigger operacion.T_SECUENCIA_EST_AGENDA_BUID
-- 1.0 REQ 128635 141200
-- 2.0 23/03/2012  Edilberto Astulle        PROY-2307_Cambio IW DTA Adicional
-- 3.0 30/10/2012  Edilberto Astulle        PROY-5513_HFC - Funcionalidad de Bajas de Servicio 3play
-- 4.0 26/05/2015  Miriam Mandujano         SD-298764  SGA - “Pendiente de portabilidad” - VARIAS SOT
-- 5.0 05/04/2016  Servicios Fallas - Hitss INC000000747489 - Problema de asignación de Flujos de Estado en los Workflow    
  before insert or update or delete on OPERACION.SECUENCIA_ESTADOS_AGENDA
  for each row
declare
  accion varchar2(3);
begin
  If updating then
    accion := 'UPD';
    Insert into HISTORICO.SECUENCIA_ESTADOS_AGENDA_LOG--4.0 ini 
    (ESTAGENDAINI,
     ESTAGENDAFIN,
     USUREG,
     FECREG,
     USUMOD,
     FECMOD,
     ACCION,
     APLICA_CONTRATA,
     APLICA_PEXT,
     IDSEQ, --4.0 fin
     TIPO) --5.0
    values
      (:old.ESTAGENDAINI,
       :old.ESTAGENDAFIN,
       :old.USUREG,
       :old.FECREG,
       :old.USUMOD,
       :old.FECMOD,
       accion,:old.APLICA_CONTRATA,:old.aplica_pext,:old.IDSEQ, :old.tipo);--2.0
  elsif inserting then
    accion := 'INS';
    Insert into HISTORICO.SECUENCIA_ESTADOS_AGENDA_LOG--4.0 ini 
    (ESTAGENDAINI,
     ESTAGENDAFIN,
     USUREG,
     FECREG,
     USUMOD,
     FECMOD,
     ACCION,
     APLICA_CONTRATA,
     APLICA_PEXT,
     IDSEQ, --4.0 fin
     TIPO)  --5.0
    values
      (:new.ESTAGENDAINI,
       :new.ESTAGENDAFIN,
       :new.USUREG,
       :new.FECREG,
       :new.USUMOD,
       :new.FECMOD,
       accion,:new.APLICA_CONTRATA,:new.aplica_pext,:new.IDSEQ, :new.tipo);--2.0
  elsif deleting then
    accion := 'DEL';
    Insert into HISTORICO.SECUENCIA_ESTADOS_AGENDA_LOG--4.0 ini 
    (ESTAGENDAINI,
     ESTAGENDAFIN,
     USUREG,
     FECREG,
     USUMOD,
     FECMOD,
     ACCION,
     APLICA_CONTRATA,
     APLICA_PEXT,
     IDSEQ,  --4.0 fin
     TIPO) 
    values
      (:old.ESTAGENDAINI,
       :old.ESTAGENDAFIN,
       :old.USUREG,
       :old.FECREG,
       :old.USUMOD,
       :old.FECMOD,
       accion,:old.APLICA_CONTRATA,:old.aplica_pext,:old.IDSEQ, :old.tipo);--2.0 5.0
   End If;
end;
/
