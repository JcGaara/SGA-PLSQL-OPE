create or replace trigger OPERACION.T_OPE_CONFFECHA_DET_AIUD
  after insert or update or delete on OPERACION.OPE_CONFFECHA_DET
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
    Insert into HISTORICO.OPE_CONFFECHA_DET_LOG
     (codfecha,
     campofecha,
     acclog)
    Values
      (:new.codfecha,
     :new.campofecha,
     ls_accion);
  End If;

  If updating then
    ls_accion := 'U';
    Insert into HISTORICO.OPE_CONFFECHA_DET_LOG
     (codfecha,
     campofecha,
      acclog)
    Values
      (:old.codfecha,
     :old.campofecha,
      ls_accion);
  End If;

  If deleting then
    ls_accion := 'D';
    Insert into HISTORICO.OPE_CONFFECHA_DET_LOG
     (codfecha,
     campofecha,
     acclog)
    Values
      (:old.codfecha,
     :old.campofecha,
      ls_accion);
  End If;
end;
/
