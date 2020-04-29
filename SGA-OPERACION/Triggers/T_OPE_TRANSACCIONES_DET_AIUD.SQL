create or replace trigger OPERACION.T_OPE_TRANSACCIONES_DET_AIUD
  after insert or update or delete on OPERACION.OPE_TRANSACCIONES_DET
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
    Insert into HISTORICO.OPE_TRANSACCIONES_DET_LOG
     (idtransaccion, 
     idproceso, 
     transaccion, 
     estado, 
     acclog)
    Values
      (:new.idtransaccion, 
     :new.idproceso, 
     :new.transaccion, 
     :new.estado,
     ls_accion);
  End If;

  If updating then
    ls_accion := 'U';
      Insert into HISTORICO.OPE_TRANSACCIONES_DET_LOG
     (idtransaccion, 
     idproceso, 
     transaccion, 
     estado, 
     acclog)
    Values
      (:old.idtransaccion, 
     :old.idproceso, 
     :old.transaccion, 
     :old.estado,
       ls_accion);
  End If;

  If deleting then
    ls_accion := 'D';
      Insert into HISTORICO.OPE_TRANSACCIONES_DET_LOG
     (idtransaccion, 
     idproceso, 
     transaccion, 
     estado, 
     acclog)
    Values
      (:old.idtransaccion, 
     :old.idproceso, 
     :old.transaccion, 
     :old.estado,
       ls_accion);
  End If;
end;
/
