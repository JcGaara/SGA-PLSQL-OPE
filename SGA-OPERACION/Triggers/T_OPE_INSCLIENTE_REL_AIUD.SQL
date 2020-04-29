create or replace trigger OPERACION.T_OPE_INSCLIENTE_REL_AIUD
  after insert or update or delete on OPERACION.OPE_INSCLIENTE_REL
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
    Insert into HISTORICO.OPE_INSCLIENTE_REL_LOG
      (idtransmensaje,
       idgrupomensaje,
       idmensaje,    
       codcli,
       codinssrv,
       idfac,
       nomabr,
       estado,
       acclog)
    Values
      (:new.idtransmensaje,
       :new.idgrupomensaje,
       :new.idmensaje,
       :new.codcli,
       :new.codinssrv,
       :new.idfac,
       :new.nomabr,
       :new.estado,
       ls_accion);
  End If;

  If updating then
    ls_accion := 'U';
    Insert into HISTORICO.OPE_INSCLIENTE_REL_LOG
      (idtransmensaje,
       idgrupomensaje,
       idmensaje,
       codcli,
       codinssrv,
       idfac,
       nomabr,
       estado,
       acclog)
    Values
      (:old.idtransmensaje,
       :old.idgrupomensaje,
       :old.idmensaje,
       :old.codcli,
       :old.codinssrv,
       :old.idfac,
       :old.nomabr,
       :old.estado,
       ls_accion);
  End If;

  If deleting then
    ls_accion := 'D';
    Insert into HISTORICO.OPE_INSCLIENTE_REL_LOG
      (idtransmensaje,
       idgrupomensaje,
       idmensaje,
       codcli,
       codinssrv,
       idfac,
       nomabr,
       estado,
       acclog)
    Values
      (:old.idtransmensaje,
       :old.idgrupomensaje,
       :old.idmensaje,
       :old.codcli,
       :old.codinssrv,
       :old.idfac,
       :old.nomabr,
       :old.estado,
       ls_accion);
  End If;
end;
/
