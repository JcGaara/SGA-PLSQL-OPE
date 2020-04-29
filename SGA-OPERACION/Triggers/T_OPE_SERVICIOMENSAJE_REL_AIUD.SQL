create or replace trigger OPERACION.T_OPE_SERVICIOMENSAJE_REL_AIUD
  after insert or update or delete on OPERACION.OPE_SERVICIOMENSAJE_REL
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
    Insert into HISTORICO.OPE_SERVICIOMENSAJE_REL_LOG
     (idservmens,
     idmensaje,
     tipsrv,
     descripcion,
     estado,
     acclog)
    Values
      (:new.idservmens,
     :new.idmensaje,
     :new.tipsrv,
     :new.descripcion,
     :new.estado,
     ls_accion);
  End If;

  If updating then
    ls_accion := 'U';
    Insert into HISTORICO.OPE_SERVICIOMENSAJE_REL_LOG
     (idservmens,
     idmensaje,
     tipsrv,
     descripcion,
     estado,
     acclog)
    Values
      (:old.idservmens,
     :old.idmensaje,
     :old.tipsrv,
     :old.descripcion,
     :old.estado,
       ls_accion);
  End If;

  If deleting then
    ls_accion := 'D';
    Insert into HISTORICO.OPE_SERVICIOMENSAJE_REL_LOG
     (idservmens,
     idmensaje,
     tipsrv,
     descripcion,
     estado,
     acclog)
    Values
      (:old.idservmens,
     :old.idmensaje,
     :old.tipsrv,
     :old.descripcion,
     :old.estado,
       ls_accion);
  End If;
end;
/
