create or replace trigger OPERACION.T_OPE_TIPOMENSAJE_REL_AIUD
  after insert or update or delete on OPERACION.OPE_TIPOMENSAJE_REL
  for each row
    /*********************************************************************************************
  REVISIONES:
  Ver        Fecha        Autor           Descripcion
  ---------  ----------  ---------------  -----------------------------------
  1.0        30/03/2011  Alfonso          REQ-161066: Creaci�n
  ***********************************************************************************************/

declare
  ls_accion char(1);
begin
  If inserting then
    ls_accion := 'I';
    Insert into HISTORICO.OPE_TIPOMENSAJE_REL_LOG
     (codtipo,
     nombretipo,
     esttipo,
     acclog)
    Values
      (:new.codtipo,
     :new.nombretipo,
     :new.esttipo,
     ls_accion);
  End If;

  If updating then
    ls_accion := 'U';
    Insert into HISTORICO.OPE_TIPOMENSAJE_REL_LOG
     (codtipo,
     nombretipo,
     esttipo,
     acclog)
    Values
      (:old.codtipo,
     :old.nombretipo,
     :old.esttipo,
     ls_accion);
  End If;

  If deleting then
    ls_accion := 'D';
    Insert into HISTORICO.OPE_TIPOMENSAJE_REL_LOG
     (codtipo,
     nombretipo,
     esttipo,
     acclog)
    Values
      (:old.codtipo,
     :old.nombretipo,
     :old.esttipo,
     ls_accion);
  End If;
end;
/
