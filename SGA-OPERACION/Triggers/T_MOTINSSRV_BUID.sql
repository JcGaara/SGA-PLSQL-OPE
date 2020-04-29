CREATE OR REPLACE TRIGGER OPERACION.T_MOTINSSRV_BUID
  before insert or update or delete on OPERACION.MOTINSSRV
  for each row
/**********************************************************
      NOMBRE:       OPERACION.T_MOTINSSRV_BUID
     PROPOSITO:

     REVISIONES:
     Ver        Fecha        Autor           Solicitado por  Descripcion
     ---------  ----------  ---------------  --------------  ----------------------

      1.0       26/01/2011  Alexander Yong  Miguel Londoña   REQ-120528: Creación

***********************************************************/
declare
  ls_accion     varchar2(3);
begin
  If updating Then
     ls_accion := 'UPD';
     Insert into HISTORICO.MOTINSSRV_LOG
     values
     (:old.CODMOTINSSRV,
      :old.DESCRIPCION,
      sysdate,
      user,
      :old.FLG_GENERA_NC,
      :old.FLG_ANULA_DEV,
      :old.FLG_PENALIDAD,
      ls_accion
      );
  End If;
  If deleting Then
     ls_accion := 'DEL';
     Insert into HISTORICO.MOTINSSRV_LOG
     values
     (:old.CODMOTINSSRV,
      :old.DESCRIPCION,
      sysdate,
      user,
      :old.FLG_GENERA_NC,
      :old.FLG_ANULA_DEV,
      :old.FLG_PENALIDAD,
      ls_accion
      );
  End If;
  If inserting Then
     ls_accion := 'INS';
     Insert into HISTORICO.MOTINSSRV_LOG
     values
     (:new.CODMOTINSSRV,
      :new.DESCRIPCION,
      sysdate,
      user,
      :new.FLG_GENERA_NC,
      :new.FLG_ANULA_DEV,
      :new.FLG_PENALIDAD,
      ls_accion
      );
  End If;
end;
/



