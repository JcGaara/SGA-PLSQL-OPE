create or replace trigger OPERACION.T_OPE_GRUPOS_REL_AIUD
  after insert or update or delete on OPERACION.OPE_GRUPOS_REL
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
    Insert into HISTORICO.OPE_GRUPOS_REL_LOG
     (idgrupo,
     descabr,
     descripcion,
     aplicasolucion,
     estado,
     acclog)
    Values
      (:new.idgrupo,
     :new.descabr,
     :new.descripcion,
     :new.aplicasolucion,
     :new.estado,
     ls_accion);
  End If;

  If updating then
    ls_accion := 'U';
     Insert into HISTORICO.OPE_GRUPOS_REL_LOG
     (idgrupo,
     descabr,
     descripcion,
     aplicasolucion,
     estado,
     acclog)
    Values
      (:old.idgrupo,
     :old.descabr,
     :old.descripcion,
     :old.aplicasolucion,
     :old.estado,
       ls_accion);
  End If;

  If deleting then
    ls_accion := 'D';
     Insert into HISTORICO.OPE_GRUPOS_REL_LOG
     (idgrupo,
     descabr,
     descripcion,
     aplicasolucion,
     estado,
     acclog)
    Values
      (:old.idgrupo,
     :old.descabr,
     :old.descripcion,
     :old.aplicasolucion,
     :old.estado,
       ls_accion);
  End If;
end;
/
