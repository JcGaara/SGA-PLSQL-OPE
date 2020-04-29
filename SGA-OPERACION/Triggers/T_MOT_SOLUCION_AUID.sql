create or replace trigger OPERACION.T_MOT_SOLUCION_AUID
  after insert or update or delete on OPERACION.MOT_SOLUCION
  for each row
--       1.0      11/10/2011  Edilberto Astulle     PROY-4856_Atencion de generacion Cuentas en RTellin para CE en HFC
declare
  ls_accion char(1);
begin
  If inserting then
    ls_accion := 'I';
    Insert into HISTORICO.MOT_SOLUCION_LOG
      (CODMOT_SOLUCION,
       DESCRIPCION,
       ESTADO,
       ACCLOG,CODMOT_GRUPO )--1.0
    Values
      (:new.CODMOT_SOLUCION,
       :new.DESCRIPCION,
       :new.ESTADO,
       ls_accion,:new.CODMOT_GRUPO);--1.0
  End If;

  If updating then
    ls_accion := 'U';
    Insert into HISTORICO.MOT_SOLUCION_LOG
      (CODMOT_SOLUCION,
       DESCRIPCION,
       ESTADO,
       ACCLOG,CODMOT_GRUPO )--1.0
    Values
      (:old.CODMOT_SOLUCION,
       :old.DESCRIPCION,
       :old.ESTADO,
       ls_accion,:OLD.CODMOT_GRUPO);--1.0
  End If;

  If deleting then
    ls_accion := 'D';
    Insert into HISTORICO.MOT_SOLUCION_LOG
      (CODMOT_SOLUCION,
       DESCRIPCION,
       ESTADO,
       ACCLOG,CODMOT_GRUPO )--1.0
    Values
      (:old.CODMOT_SOLUCION,
       :old.DESCRIPCION,
       :old.ESTADO,
       ls_accion,:new.CODMOT_GRUPO);--1.0
  End If;
end;
/