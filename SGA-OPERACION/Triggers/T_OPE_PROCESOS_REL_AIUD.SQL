create or replace trigger OPERACION.T_OPE_PROCESOS_REL_AIUD
  after insert or update or delete on OPERACION.OPE_PROCESOS_REL
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
    Insert into HISTORICO.OPE_PROCESOS_REL_LOG
     (idproceso, 
     idgrupomensaje, 
     proceso, 
     orden, 
     tipoproceso, 
     estado, 
     acclog)
    Values
      (:new.idproceso, 
     :new.idgrupomensaje, 
     :new.proceso, 
     :new.orden, 
     :new.tipoproceso, 
     :new.estado, 
     ls_accion);
  End If;

  If updating then
    ls_accion := 'U';
     Insert into HISTORICO.OPE_PROCESOS_REL_LOG
     (idproceso, 
     idgrupomensaje, 
     proceso, 
     orden, 
     tipoproceso, 
     estado,
     acclog)
    Values
      (:old.idproceso, 
     :old.idgrupomensaje, 
     :old.proceso, 
     :old.orden, 
     :old.tipoproceso, 
     :old.estado, 
       ls_accion);
  End If;

  If deleting then
    ls_accion := 'D';
     Insert into HISTORICO.OPE_PROCESOS_REL_LOG
     (idproceso, 
     idgrupomensaje, 
     proceso, 
     orden, 
     tipoproceso, 
     estado, 
     acclog)
    Values
      (:old.idproceso, 
     :old.idgrupomensaje, 
     :old.proceso, 
     :old.orden, 
     :old.tipoproceso, 
     :old.estado, 
       ls_accion);
  End If;
end;
/
