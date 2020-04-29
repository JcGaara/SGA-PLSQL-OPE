create or replace trigger operacion.T_CIERRE_TAREA_AGENDA_BUID
-- 1.0 30/10/2012  Edilberto Astulle PROY-5513_HFC - Funcionalidad de Bajas de Servicio 3play
  before insert or update or delete on OPERACION.CIERRE_TAREA_AGENDA
  for each row
declare
  accion varchar2(3);
begin
  If updating then
    accion := 'U';
    Insert into HISTORICO.CIERRE_TAREA_AGENDA_LOG
    values
      (:old.IDSEQ,
       :old.TAREADEF,
       :old.ESTTAREA,
       USER,
       SYSDATE,
       accion);
  elsif inserting then
    accion := 'I';
    Insert into HISTORICO.CIERRE_TAREA_AGENDA_LOG
    values
      (:NEW.IDSEQ,
       :NEW.TAREADEF,
       :NEW.ESTTAREA,
       USER,
       SYSDATE,
       accion);
  elsif deleting then
    accion := 'D';
    Insert into HISTORICO.CIERRE_TAREA_AGENDA_LOG
    values
      (:old.IDSEQ,
       :old.TAREADEF,
       :old.ESTTAREA,
       USER,
       SYSDATE,
       accion);
   End If;
end;
/