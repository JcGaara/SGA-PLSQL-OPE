CREATE OR REPLACE TRIGGER OPERACION."T_SOLOTPTO_AIUD"
  after insert or delete or update on operacion.solotpto
  referencing old as old new as new
  for each row
  /*********************************************************************************************
    NOMBRE:            OPERACION.T_SOLOTPTO_AIUD
    PROPOSITO:
    REVISIONES:
    Ver        Fecha        Autor           Solicitado por      Descripcion
    ---------  ----------  ---------------  ----------------    --------------------
    1.0        23/12/2010  Alfonso Pérez    Cesar Rosciano      Creacion REQ 152240
    2.0        15/03/2011  Widmer Quispe    Edilberto Astulle   Req: 123054 y 123052, Asignación de CODSRV.
  ***********************************************************************************************/
declare
  v_usuario_log varchar2(50);
  v_data_log    date;
  v_acao_log    char(1);
  v_user_nolog  number(1) := 0;
begin
  if v_user_nolog = 0 then
    select min(osuser)
      into v_usuario_log
      from sys.v_$session
     where audsid = userenv('SESSIONID');
    v_usuario_log := v_usuario_log || '-' || user;
    select sysdate into v_data_log from dual;
    if inserting then
      v_acao_log := 'I';
      insert into historico.ope_solotpto_log
        (codsolot,
          punto,
          tiptrs,
          codsrvant,
          bwant,
          codsrvnue,
          bwnue,
          codinssrv,
          cid,
          descripcion,
          direccion,
          tipo,
          estado,
          visible,
          puerta,
          pop,
          codubi,
          fecini,
          fecfin,
          fecinisrv,
          feccom,
          tiptraef,
          tipotpto,
          efpto,
          pid,
          pid_old,
          cantidad,
          codpostal,
          flgmt,
          codinssrv_tra,
          mediotx,
          provenlace,
          flg_agenda,
          cintillo,
          ncos_old,
          ncos_new,
          accion,
          usureg,
          idplataforma --<2.0>
          )
      values
        (:new.codsolot,
          :new.punto,
          :new.tiptrs,
          :new.codsrvant,
          :new.bwant,
          :new.codsrvnue,
          :new.bwnue,
          :new.codinssrv,
          :new.cid,
          :new.descripcion,
          :new.direccion,
          :new.tipo,
          :new.estado,
          :new.visible,
          :new.puerta,
          :new.pop,
          :new.codubi,
          :new.fecini,
          :new.fecfin,
          :new.fecinisrv,
          :new.feccom,
          :new.tiptraef,
          :new.tipotpto,
          :new.efpto,
          :new.pid,
          :new.pid_old,
          :new.cantidad,
          :new.codpostal,
          :new.flgmt,
          :new.codinssrv_tra,
          :new.mediotx,
          :new.provenlace,
          :new.flg_agenda,
          :new.cintillo,
          :new.ncos_old,
          :new.ncos_new,
         v_acao_log,
         v_usuario_log,
          :new.idplataforma --<2.0>
          );
    elsif updating then
      v_acao_log := 'U';
      insert into historico.ope_solotpto_log
        (codsolot,
          punto,
          tiptrs,
          codsrvant,
          bwant,
          codsrvnue,
          bwnue,
          codinssrv,
          cid,
          descripcion,
          direccion,
          tipo,
          estado,
          visible,
          puerta,
          pop,
          codubi,
          fecini,
          fecfin,
          fecinisrv,
          feccom,
          tiptraef,
          tipotpto,
          efpto,
          pid,
          pid_old,
          cantidad,
          codpostal,
          flgmt,
          codinssrv_tra,
          mediotx,
          provenlace,
          flg_agenda,
          cintillo,
          ncos_old,
          ncos_new,
          accion,
          usureg,
          idplataforma --<2.0>
          )
      values
        (:old.codsolot,
          :old.punto,
          :old.tiptrs,
          :old.codsrvant,
          :old.bwant,
          :old.codsrvnue,
          :old.bwnue,
          :old.codinssrv,
          :old.cid,
          :old.descripcion,
          :old.direccion,
          :old.tipo,
          :old.estado,
          :old.visible,
          :old.puerta,
          :old.pop,
          :old.codubi,
          :old.fecini,
          :old.fecfin,
          :old.fecinisrv,
          :old.feccom,
          :old.tiptraef,
          :old.tipotpto,
          :old.efpto,
          :old.pid,
          :old.pid_old,
          :old.cantidad,
          :old.codpostal,
          :old.flgmt,
          :old.codinssrv_tra,
          :old.mediotx,
          :old.provenlace,
          :old.flg_agenda,
          :old.cintillo,
          :old.ncos_old,
          :old.ncos_new,
         v_acao_log,
         v_usuario_log,
         :old.idplataforma --<2.0>
         );
    elsif deleting then
      v_acao_log := 'D';
      insert into historico.ope_solotpto_log
        (codsolot,
          punto,
          tiptrs,
          codsrvant,
          bwant,
          codsrvnue,
          bwnue,
          codinssrv,
          cid,
          descripcion,
          direccion,
          tipo,
          estado,
          visible,
          puerta,
          pop,
          codubi,
          fecini,
          fecfin,
          fecinisrv,
          feccom,
          tiptraef,
          tipotpto,
          efpto,
          pid,
          pid_old,
          cantidad,
          codpostal,
          flgmt,
          codinssrv_tra,
          mediotx,
          provenlace,
          flg_agenda,
          cintillo,
          ncos_old,
          ncos_new,
          accion,
          usureg,
          idplataforma --<2.0>
          )
      values
        (:old.codsolot,
          :old.punto,
          :old.tiptrs,
          :old.codsrvant,
          :old.bwant,
          :old.codsrvnue,
          :old.bwnue,
          :old.codinssrv,
          :old.cid,
          :old.descripcion,
          :old.direccion,
          :old.tipo,
          :old.estado,
          :old.visible,
          :old.puerta,
          :old.pop,
          :old.codubi,
          :old.fecini,
          :old.fecfin,
          :old.fecinisrv,
          :old.feccom,
          :old.tiptraef,
          :old.tipotpto,
          :old.efpto,
          :old.pid,
          :old.pid_old,
          :old.cantidad,
          :old.codpostal,
          :old.flgmt,
          :old.codinssrv_tra,
          :old.mediotx,
          :old.provenlace,
          :old.flg_agenda,
          :old.cintillo,
          :old.ncos_old,
          :old.ncos_new,
         v_acao_log,
         v_usuario_log,
         :old.idplataforma --<2.0>
         );
    end if;
  end if;
end;
/



