create or replace trigger operacion.t_mototxtiptra_auid
  after insert or delete or update on operacion.mototxtiptra
  referencing old as old new as new
  for each row
/*********************************************************************************************
  NOMBRE:            OPERACION.T_MOTOTXTIPTRA_AUID
  PROPOSITO:
  REVISIONES:
  Ver        Fecha        Autor           Solicitado por     Descripcion
  ---------  ----------  ---------------  ---------------    ------------------------------------------------------------------
  1.0        04/01/2012  Fernando Canaval Edilberto Astulle  PROY-1332 Motivos de SOT por Tipo de Trabajo
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
      insert into historico.mototxtiptra_log
        (idmotxtip ,tiptra, codmotot, acccion, usureg)
      values
        (:new.idmotxtip,
         :new.tiptra,
         :new.codmotot,
         v_acao_log,
         v_usuario_log);
    elsif updating then
      v_acao_log := 'U';
      insert into historico.mototxtiptra_log
        (idmotxtip ,tiptra, codmotot, acccion, usureg)
      values
        (:old.idmotxtip,
         :old.tiptra,
         :old.codmotot,
         v_acao_log,
         v_usuario_log);
    elsif deleting then
      v_acao_log := 'D';
      insert into historico.mototxtiptra_log
        (idmotxtip ,tiptra, codmotot, acccion, usureg)
      values
        (:old.idmotxtip,
         :old.tiptra,
         :old.codmotot,
         v_acao_log,
         v_usuario_log);
    end if;
  end if;
end;
/