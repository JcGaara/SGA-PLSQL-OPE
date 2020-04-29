create or replace trigger OPERACION.T_OPE_ESTADOSERVICIO_REL_AIUD
  after insert or update or delete on OPERACION.OPE_ESTADOSERVICIO_REL
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
    Insert into HISTORICO.OPE_ESTADOSERVICIO_REL_LOG
     (IDMENSAJE,
     ESTINSSRV,
     estado,
     acclog)
    Values
      (:new.IDMENSAJE,
      :new.ESTINSSRV,
     :new.estado,
     ls_accion);
  End If;

  If updating then
    ls_accion := 'U';
    Insert into HISTORICO.OPE_ESTADOSERVICIO_REL_LOG
     (IDMENSAJE,
     ESTINSSRV,
     estado,
     acclog)
    Values
      (:old.IDMENSAJE,
      :old.ESTINSSRV,
     :old.estado,
       ls_accion);
  End If;

  If deleting then
    ls_accion := 'D';
    Insert into HISTORICO.OPE_ESTADOSERVICIO_REL_LOG
     (IDMENSAJE,
     ESTINSSRV,
     estado,
     acclog)
    Values
      (:old.IDMENSAJE,
      :old.ESTINSSRV,
     :old.estado,
       ls_accion);
  End If;
end;
/
