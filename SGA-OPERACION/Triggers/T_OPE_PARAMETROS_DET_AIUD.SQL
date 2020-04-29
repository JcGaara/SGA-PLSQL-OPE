create or replace trigger OPERACION.T_OPE_PARAMETROS_DET_AIUD
  after insert or update or delete on OPERACION.OPE_PARAMETROS_DET
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
    Insert into HISTORICO.OPE_PARAMETROS_DET_LOG
     (idparametro, 
     parametro, 
     valor, 
     tipodedato, 
     longitud, 
     acclog)
    Values
      (:new.idparametro, 
     :new.parametro, 
     :new.valor, 
     :new.tipodedato, 
     :new.longitud, 
     ls_accion);
  End If;

  If updating then
    ls_accion := 'U';
      Insert into HISTORICO.OPE_PARAMETROS_DET_LOG
     (idparametro, 
     parametro, 
     valor, 
     tipodedato, 
     longitud, 
     acclog)
    Values
      (:old.idparametro, 
     :old.parametro, 
     :old.valor, 
     :old.tipodedato, 
     :old.longitud,
       ls_accion);
  End If;

  If deleting then
    ls_accion := 'D';
      Insert into HISTORICO.OPE_PARAMETROS_DET_LOG
     (idparametro, 
     parametro, 
     valor, 
     tipodedato, 
     longitud, 
     acclog)
    Values
      (:old.idparametro, 
     :old.parametro, 
     :old.valor, 
     :old.tipodedato, 
     :old.longitud,
       ls_accion);
  End If;
end;
/
