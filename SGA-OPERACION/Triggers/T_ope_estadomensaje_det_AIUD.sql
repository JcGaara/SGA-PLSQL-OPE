create or replace trigger OPERACION.T_ope_estadomensaje_det_AIUD
  after insert or update or delete on OPERACION.ope_estadomensaje_det
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
    Insert into HISTORICO.ope_estadomensaje_det_LOG
     (idestado,
     nombre,
     activo,
     acclog)
    Values
      (:new.idestado,
     :new.nombre,
     :new.activo,
     ls_accion);
  End If;

  If updating then
    ls_accion := 'U';
    Insert into HISTORICO.ope_estadomensaje_det_LOG
     (idestado,
     nombre,
     activo,
      acclog)
    Values
      (:old.idestado,
     :old.nombre,
     :old.activo,
      ls_accion);
  End If;

  If deleting then
    ls_accion := 'D';
    Insert into HISTORICO.ope_estadomensaje_det_LOG
     (idestado,
     nombre,
     activo,
     acclog)
    Values
      (:old.idestado,
     :old.nombre,
     :old.activo,
      ls_accion);
  End If;
end;
/
