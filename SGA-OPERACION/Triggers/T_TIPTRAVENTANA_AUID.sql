CREATE OR REPLACE TRIGGER OPERACION.T_TIPTRAVENTANA_AUID
  after insert or update or delete on OPERACION.TIPTRAVENTANA
  for each row
declare
  ls_accion char(1);
begin
  If inserting then
    ls_accion := 'I';
    Insert into HISTORICO.TIPTRAVENTANA_LOG
      ( IDVENTANA,
	CONTRATA,
	TITULO,
	TIPO,
	ACCION,
	FECREG,
	USUREG)
    Values
      (:new.IDVENTANA,
       :new.CONTRATA,
       :new.TITULO,
       :new.TIPO,
       ls_accion,
	:new.FECREG,
	:new.USUREG);
  End If;

  If updating then
    ls_accion := 'U';
    Insert into HISTORICO.TIPTRAVENTANA_LOG
      ( IDVENTANA,
	CONTRATA,
	TITULO,
	TIPO,
	ACCION,
	FECREG,
	USUREG)
    Values
      (:OLD.IDVENTANA,
       :OLD.CONTRATA,
       :OLD.TITULO,
       :OLD.TIPO,
       ls_accion,
	SYSDATE,
	USER);
  End If;

  If deleting then
    ls_accion := 'D';
    Insert into HISTORICO.TIPTRAVENTANA_LOG
      ( IDVENTANA,
	CONTRATA,
	TITULO,
	TIPO,
	ACCION,
	FECREG,
	USUREG)
    Values
      (:OLD.IDVENTANA,
       :OLD.CONTRATA,
       :OLD.TITULO,
       :OLD.TIPO,
       ls_accion,
	SYSDATE,
	USER);
  End If;
end;
/



