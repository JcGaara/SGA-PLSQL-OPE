CREATE OR REPLACE TRIGGER OPERACION.T_OPE_MOT_TIPTRA_DET_AUID
  after insert or update or delete on OPERACION.OPE_MOT_TIPTRA_DET
  for each row
declare
  ls_accion char(1);
begin
  If inserting then
    ls_accion := 'I';
    Insert into HISTORICO.OPE_MOT_TIPTRA_DET_LOG
      (ID,
       TIPTRA,
       CODMOT_SOLUCION,
       TIPO,
       ACCLOG)
    Values
      (:new.ID,
       :new.TIPTRA,
       :new.CODMOT_SOLUCION,
       :new.TIPO,
       ls_accion);
  End If;

  If updating then
    ls_accion := 'U';
    Insert into HISTORICO.OPE_MOT_TIPTRA_DET_LOG
      (ID,
       TIPTRA,
       CODMOT_SOLUCION,
       TIPO,
       ACCLOG)
    Values
      (:old.ID,
       :old.TIPTRA,
       :old.CODMOT_SOLUCION,
       :old.TIPO,
       ls_accion);
  End If;

  If deleting then
    ls_accion := 'D';
    Insert into HISTORICO.OPE_MOT_TIPTRA_DET_LOG
      (ID,
       TIPTRA,
       CODMOT_SOLUCION,
       TIPO,
       ACCLOG)
    Values
      (:old.ID,
       :old.TIPTRA,
       :old.CODMOT_SOLUCION,
       :old.TIPO,
       ls_accion);
  End If;
end;
/



