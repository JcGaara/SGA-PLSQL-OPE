create or replace trigger OPERACION.T_OPE_MENSAJES_MAE_AIUD
  after insert or update or delete on OPERACION.OPE_MENSAJES_MAE
  for each row
    /*********************************************************************************************
  REVISIONES:
  Ver        Fecha        Autor           Descripcion
  ---------  ----------  ---------------  -----------------------------------
  1.0        30/03/2011  Alfonso          REQ-161066: Creación
  ***********************************************************************************************/

declare
  ls_accion char(1);
begin
  If inserting then
    ls_accion := 'I';
    Insert into HISTORICO.OPE_MENSAJES_MAE_LOG
     (idmensaje,
     mensaje,
     descripcion,
     aplicaxsegmark,
     estado,
     codtipo,
     transaccionunica,
     sobretx,
     diasposteriorestx,
     codfecha,
     acclog)
    Values
      (:new.idmensaje,
     :new.mensaje,
     :new.descripcion,
     :new.aplicaxsegmark,
     :new.estado,
     :new.codtipo,
     :new.transaccionunica,
     :new.sobretx,
     :new.diasposteriorestx,
     :new.codfecha,
     ls_accion);
  End If;

  If updating then
    ls_accion := 'U';
    Insert into HISTORICO.OPE_MENSAJES_MAE_LOG
      (idmensaje,
     mensaje,
     descripcion,
     aplicaxsegmark,
     estado,
     codtipo,
     transaccionunica,
     sobretx,
     diasposteriorestx,
     codfecha,
     acclog)
    Values
      (:old.idmensaje,
     :old.mensaje,
     :old.descripcion,
     :old.aplicaxsegmark,
     :old.estado,
     :old.codtipo,
     :old.transaccionunica,
     :old.sobretx,
     :old.diasposteriorestx,
     :old.codfecha,
       ls_accion);
  End If;

  If deleting then
    ls_accion := 'D';
    Insert into HISTORICO.OPE_MENSAJES_MAE_LOG
      (idmensaje,
     mensaje,
     descripcion,
     aplicaxsegmark,
     estado,
     codtipo,
     transaccionunica,
     sobretx,
     diasposteriorestx,
     codfecha,
     acclog)
    Values
      (:old.idmensaje,
     :old.mensaje,
     :old.descripcion,
     :old.aplicaxsegmark,
     :old.estado,
     :old.codtipo,
     :old.transaccionunica,
     :old.sobretx,
     :old.diasposteriorestx,
     :old.codfecha,
       ls_accion);
  End If;
end;
/
