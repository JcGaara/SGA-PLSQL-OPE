create or replace trigger OPERACION.T_OPE_GRUPO_MENSAJES_DET_AIUD
  after insert or update or delete on OPERACION.OPE_GRUPO_MENSAJES_DET
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
    Insert into HISTORICO.OPE_GRUPO_MENSAJES_DET_LOG
     (idgrupomensaje, 
     idgrupo, 
     idmensaje, 
     diasutiles, 
     orden, 
     estado, 
     grupoejecucion, 
     acclog)
    Values
      (:new.idgrupomensaje, 
     :new.idgrupo, 
     :new.idmensaje, 
     :new.diasutiles, 
     :new.orden, 
     :new.estado, 
     :new.grupoejecucion, 
     ls_accion);
  End If;

  If updating then
    ls_accion := 'U';
     Insert into HISTORICO.OPE_GRUPO_MENSAJES_DET_LOG
     (idgrupomensaje, 
     idgrupo, 
     idmensaje, 
     diasutiles, 
     orden, 
     estado, 
     grupoejecucion, 
     acclog)
    Values
      (:old.idgrupomensaje, 
     :old.idgrupo, 
     :old.idmensaje, 
     :old.diasutiles, 
     :old.orden, 
     :old.estado, 
     :old.grupoejecucion, 
       ls_accion);
  End If;

  If deleting then
    ls_accion := 'D';
     Insert into HISTORICO.OPE_GRUPO_MENSAJES_DET_LOG
     (idgrupomensaje, 
     idgrupo, 
     idmensaje, 
     diasutiles, 
     orden, 
     estado, 
     grupoejecucion, 
     acclog)
    Values
      (:old.idgrupomensaje, 
     :old.idgrupo, 
     :old.idmensaje, 
     :old.diasutiles, 
     :old.orden, 
     :old.estado, 
     :old.grupoejecucion, 
       ls_accion);
  End If;
end;
/
