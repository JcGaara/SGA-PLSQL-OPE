create or replace trigger operacion.T_MOT_SOLUCIONXTIPTRA_BUID
-- 1.0 REQ 128635 141200
-- 2.0 Edilberto Astulle  30/10/2012  PROY-5513_HFC - Funcionalidad de Bajas de Servicio 3play
  before insert or update or delete on OPERACION.MOT_SOLUCIONXTIPTRA
  for each row
declare
  accion varchar2(3);
begin
  If updating then
    accion := 'UPD';
    Insert into HISTORICO.MOT_SOLUCIONXTIPTRA_LOG
    values
      (:old.TIPTRA,
       :old.CODMOT_SOLUCION,
       :old.USUREG,
       :old.FECREG,
       :old.USUMOD,
       :old.FECMOD,
       accion, :old.aplica_contrata,:old.aplica_pext);--2.0
  elsif inserting then
    accion := 'INS';
    Insert into HISTORICO.MOT_SOLUCIONXTIPTRA_LOG
    values
      (:new.TIPTRA,
       :new.CODMOT_SOLUCION,
       :new.USUREG,
       :new.FECREG,
       :new.USUMOD,
       :new.FECMOD,
       accion, :new.aplica_contrata,:new.aplica_pext);--2.0
  elsif deleting then
    accion := 'DEL';
    Insert into HISTORICO.MOT_SOLUCIONXTIPTRA_LOG
    values
      (:old.TIPTRA,
       :old.CODMOT_SOLUCION,
       :old.USUREG,
       :old.FECREG,
       :old.USUMOD,
       :old.FECMOD,
       accion, :old.aplica_contrata,:old.aplica_pext);--2.0
  End If;
end;
/