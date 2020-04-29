CREATE OR REPLACE TRIGGER OPERACION.T_OPE_INS_EQUIPO_CAB_AIUD
  after insert or update or delete on OPERACION.OPE_INS_EQUIPO_CAB
  for each row
declare
  ls_accion char(1);
begin
  If inserting then
    ls_accion := 'I';
    Insert into HISTORICO.OPE_INS_EQUIPO_CAB_LOG
      (IDINS_EQUIPO,
       TIPEQU,
       SERIE,
       MAC1,
       MAC2,
       MODELO,
       CODSOLOT,
       CODCLI,
       CODSUC,
       NUMSLC,
       TOT_LINEAS,
       NUM_LINEAS_LIBRES,
       ESTADO,
       ACCLOG)
    Values
      (:new.IDINS_EQUIPO,
       :new.TIPEQU,
       :new.SERIE,
       :new.MAC1,
       :new.MAC2,
       :new.MODELO,
       :new.CODSOLOT,
       :new.CODCLI,
       :new.CODSUC,
       :new.NUMSLC,
       :new.TOT_LINEAS,
       :new.NUM_LINEAS_LIBRES,
       :new.ESTADO,
       ls_accion);
  End If;

  If updating then
    ls_accion := 'U';
    Insert into HISTORICO.OPE_INS_EQUIPO_CAB_LOG
      (IDINS_EQUIPO,
       TIPEQU,
       SERIE,
       MAC1,
       MAC2,
       MODELO,
       CODSOLOT,
       CODCLI,
       CODSUC,
       NUMSLC,
       TOT_LINEAS,
       NUM_LINEAS_LIBRES,
       ESTADO,
       ACCLOG)
    Values
      (:old.IDINS_EQUIPO,
       :old.TIPEQU,
       :old.SERIE,
       :old.MAC1,
       :old.MAC2,
       :old.MODELO,
       :old.CODSOLOT,
       :old.CODCLI,
       :old.CODSUC,
       :old.NUMSLC,
       :old.TOT_LINEAS,
       :old.NUM_LINEAS_LIBRES,
       :old.ESTADO,
       ls_accion);
  End If;

  If deleting then
    ls_accion := 'D';
    Insert into HISTORICO.OPE_INS_EQUIPO_CAB_LOG
      (IDINS_EQUIPO,
       TIPEQU,
       SERIE,
       MAC1,
       MAC2,
       MODELO,
       CODSOLOT,
       CODCLI,
       CODSUC,
       NUMSLC,
       TOT_LINEAS,
       NUM_LINEAS_LIBRES,
       ESTADO,
       ACCLOG)
    Values
      (:old.IDINS_EQUIPO,
       :old.TIPEQU,
       :old.SERIE,
       :old.MAC1,
       :old.MAC2,
       :old.MODELO,
       :old.CODSOLOT,
       :old.CODCLI,
       :old.CODSUC,
       :old.NUMSLC,
       :old.TOT_LINEAS,
       :old.NUM_LINEAS_LIBRES,
       :old.ESTADO,
       ls_accion);
  End If;
end;
/



