create or replace trigger OPERACION.T_OPE_SEGMENTOMERCADO_REL_AIUD
  after insert or update or delete on OPERACION.OPE_SEGMENTOMERCADO_REL
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
    Insert into HISTORICO.OPE_SEGMENTOMERCADO_REL_LOG
     (idmensaje, 
     codsegmark, 
     estado, 
     acclog)
    Values
      ( :new.idmensaje, 
      :new.codsegmark, 
      :new.estado, 
       ls_accion);
  End If;

  If updating then
    ls_accion := 'U';
    Insert into HISTORICO.OPE_SEGMENTOMERCADO_REL_LOG
      (idmensaje, 
     codsegmark, 
     estado,
       ACCLOG)
    Values
      ( :old.idmensaje, 
     :old.codsegmark, 
     :old.estado,
       ls_accion);
  End If;

  If deleting then
    ls_accion := 'D';
    Insert into HISTORICO.OPE_SEGMENTOMERCADO_REL_LOG
      (idmensaje, 
     codsegmark, 
     estado,
       ACCLOG)
    Values
      (:old.idmensaje, 
     :old.codsegmark, 
     :old.estado,
       ls_accion);
  End If;
end;
/
