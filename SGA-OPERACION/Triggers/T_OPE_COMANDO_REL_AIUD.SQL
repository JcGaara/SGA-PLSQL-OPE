create or replace trigger OPERACION.T_OPE_COMANDO_REL_AIUD
  after insert or update or delete on OPERACION.OPE_COMANDO_REL
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
    Insert into HISTORICO.OPE_COMANDO_REL_LOG
     (idcomando,
     comando,
     orden,
     procedimiento,
     idservmens,
     idparametro,
     acclog)
    Values
      (:new.idcomando,
     :new.comando,
     :new.orden,
     :new.procedimiento,
     :new.idservmens,
     :new.idparametro,
     ls_accion);
  End If;

  If updating then
    ls_accion := 'U';
    Insert into HISTORICO.OPE_COMANDO_REL_LOG
     (idcomando,
     comando,
     orden,
     procedimiento,
     idservmens,
     idparametro,
     acclog)
    Values
      (:old.idcomando,
     :old.comando,
     :old.orden,
     :old.procedimiento,
     :old.idservmens,
     :old.idparametro,
       ls_accion);
  End If;

  If deleting then
    ls_accion := 'D';
    Insert into HISTORICO.OPE_COMANDO_REL_LOG
     (idcomando,
     comando,
     orden,
     procedimiento,
     idservmens,
     idparametro,
     acclog)
    Values
      (:old.idcomando,
     :old.comando,
     :old.orden,
     :old.procedimiento,
     :old.idservmens,
     :old.idparametro,
       ls_accion);
  End If;
end;
/
