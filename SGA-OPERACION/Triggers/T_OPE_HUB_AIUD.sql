CREATE OR REPLACE TRIGGER OPERACION.t_ope_hub_aiud
after insert or delete or update
on intraway.ope_hub
referencing old as old new as new
for each row
/************************************************************************************
 Ver        Fecha        Autor           Solicitado por  Descripcion
 ---------  ----------  ---------------  --------------  ----------------------
  1.0       14/07/2011  Joseph Asencios  Zulma Quispe    REQ-153355: Creación
*************************************************************************************/
declare
  v_usuario_log varchar2(50);
  v_acao_log char(1);
  v_user_nolog number(1) :=0;
begin

  if v_user_nolog = 0 then
    select min(osuser) into v_usuario_log
    from sys.v_$session

    where audsid = userenv('SESSIONID');
    v_usuario_log := v_usuario_log || '-' || user;

    if inserting then
       v_acao_log := 'I';
       insert into intraway.his_ope_hub_log
         (idhub,
          deschub,
          abrevhub,
          codubi,
          estado,
          codusu,
          fecusu,
          tipored,
          operatividad,
          nombre,
          flg_vod,
          accion,
          usureg)
       values
         (:new.idhub,
          :new.deschub,
          :new.abrevhub,
          :new.codubi,
          :new.estado,
          :new.codusu,
          :new.fecusu,
          :new.tipored,
          :new.operatividad,
          :new.nombre,
          :new.flg_vod,
          v_acao_log,
          v_usuario_log);
    elsif updating then
       v_acao_log := 'U';

       insert into intraway.his_ope_hub_log
         (idhub,
          deschub,
          abrevhub,
          codubi,
          estado,
          codusu,
          fecusu,
          tipored,
          operatividad,
          nombre,
          flg_vod,
          accion,
          usureg)
       values
         (:old.idhub,
          :old.deschub,
          :old.abrevhub,
          :old.codubi,
          :old.estado,
          :old.codusu,
          :old.fecusu,
          :old.tipored,
          :old.operatividad,
          :old.nombre,
          :old.flg_vod,
          v_acao_log,
          v_usuario_log);
    elsif deleting then
       v_acao_log := 'D';
       insert into intraway.his_ope_hub_log
         (idhub,
          deschub,
          abrevhub,
          codubi,
          estado,
          codusu,
          fecusu,
          tipored,
          operatividad,
          nombre,
          flg_vod,
          accion,
          usureg)
       values
         (:old.idhub,
          :old.deschub,
          :old.abrevhub,
          :old.codubi,
          :old.estado,
          :old.codusu,
          :old.fecusu,
          :old.tipored,
          :old.operatividad,
          :old.nombre,
          :old.flg_vod,
          v_acao_log,
          v_usuario_log);
    end if;
  end if;
end;
/



