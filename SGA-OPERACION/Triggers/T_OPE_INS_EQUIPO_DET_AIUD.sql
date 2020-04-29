CREATE OR REPLACE TRIGGER OPERACION.T_OPE_INS_EQUIPO_DET_AIUD
  after insert or update or delete on OPERACION.OPE_INS_EQUIPO_DET
  for each row
declare
  ls_accion char(1);
begin
  If inserting then
    ls_accion := 'I';
    Insert into HISTORICO.OPE_INS_EQUIPO_DET_LOG
      (IDINS_EQUIPO_DET,
       IDINS_EQUIPO,
       TIPO,
       CODINSSRV,
       CODSOLOT,
       ESTADO,
       ACCLOG)
    Values
      (:NEW.IDINS_EQUIPO_DET,
       :NEW.IDINS_EQUIPO,
       :NEW.TIPO,
       :NEW.CODINSSRV,
       :NEW.CODSOLOT,
       :NEW.ESTADO,
       ls_accion);
  End If;

  If updating then
    ls_accion := 'U';
    Insert into HISTORICO.OPE_INS_EQUIPO_DET_LOG
      (IDINS_EQUIPO_DET,
       IDINS_EQUIPO,
       TIPO,
       CODINSSRV,
       CODSOLOT,
       ESTADO,
       ACCLOG)
    Values
      (:OLD.IDINS_EQUIPO_DET,
       :OLD.IDINS_EQUIPO,
       :OLD.TIPO,
       :OLD.CODINSSRV,
       :OLD.CODSOLOT,
       :OLD.ESTADO,
       ls_accion);
  End If;

  If deleting then
    ls_accion := 'D';
    Insert into HISTORICO.OPE_INS_EQUIPO_DET_LOG
      (IDINS_EQUIPO_DET,
       IDINS_EQUIPO,
       TIPO,
       CODINSSRV,
       CODSOLOT,
       ESTADO,
       ACCLOG)
    Values
      (:OLD.IDINS_EQUIPO_DET,
       :OLD.IDINS_EQUIPO,
       :OLD.TIPO,
       :OLD.CODINSSRV,
       :OLD.CODSOLOT,
       :OLD.ESTADO,
       ls_accion);
  End If;
end;
/



