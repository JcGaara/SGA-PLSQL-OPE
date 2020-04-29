create or replace trigger OPERACION.T_OPE_GRUPOMENSSOL_DET_AIUD
  after insert or update or delete on OPERACION.OPE_GRUPOMENSSOL_DET
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
    Insert into HISTORICO.OPE_GRUPOMENSSOL_DET_LOG
     (idgrupo, 
     idsolucion, 
     descripcion, 
     estadosol, 
     familia, 
     grupocorte, 
     acclog)
    Values
      (:new.idgrupo, 
     :new.idsolucion, 
     :new.descripcion, 
     :new.estadosol, 
     :new.familia, 
     :new.grupocorte,
     ls_accion);
  End If;

  If updating then
    ls_accion := 'U';
     Insert into HISTORICO.OPE_GRUPOMENSSOL_DET_LOG
     (idgrupo, 
     idsolucion, 
     descripcion, 
     estadosol, 
     familia, 
     grupocorte, 
     acclog)
    Values
      (:old.idgrupo, 
     :old.idsolucion, 
     :old.descripcion, 
     :old.estadosol, 
     :old.familia, 
     :old.grupocorte,
       ls_accion);
  End If;

  If deleting then
    ls_accion := 'D';
    Insert into HISTORICO.OPE_GRUPOMENSSOL_DET_LOG
     (idgrupo, 
     idsolucion, 
     descripcion, 
     estadosol, 
     familia, 
     grupocorte, 
     acclog)
    Values
      (:old.idgrupo, 
     :old.idsolucion, 
     :old.descripcion, 
     :old.estadosol, 
     :old.familia, 
     :old.grupocorte,
       ls_accion);
  End If;
end;
/
