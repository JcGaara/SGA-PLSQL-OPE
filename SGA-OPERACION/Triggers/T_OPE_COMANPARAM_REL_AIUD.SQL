create or replace trigger OPERACION.T_OPE_COMANPARAM_REL_AIUD
  after insert or update or delete on OPERACION.OPE_COMANDOPARAMETRO_REL
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
    Insert into HISTORICO.OPE_COMANDOPARAMETRO_REL_LOG
     (iddetalle, 
     idcomando, 
     idparametro,
     valor, 
     acclog)
    Values
      (:new.iddetalle, 
     :new.idcomando, 
     :new.idparametro, 
     :new.valor,
     ls_accion);
  End If;

  If updating then
    ls_accion := 'U';
     Insert into HISTORICO.OPE_COMANDOPARAMETRO_REL_LOG
    (iddetalle, 
     idcomando, 
     idparametro,
     valor, 
     acclog)
    Values
      (:old.iddetalle, 
     :old.idcomando, 
     :old.idparametro, 
     :old.valor,
     ls_accion);
  End If;

  If deleting then
    ls_accion := 'D';
    Insert into HISTORICO.OPE_COMANDOPARAMETRO_REL_LOG
    (iddetalle, 
     idcomando, 
     idparametro, 
     valor,
     acclog)
    Values
      (:old.iddetalle, 
     :old.idcomando, 
     :old.idparametro, 
     :old.valor,
       ls_accion);
  End If;
end;
/
