create or replace trigger "OPERACION"."T_OPE_TIPOMASIVASOT_MAE_AIUD"
  after insert or update or delete on OPERACION.OPE_TIPOMASIVASOT_MAE
  referencing old as old new as new
  for each row
/********************************************************************************************
     ver     fecha          autor                solicitado por          descripcion
    ------  ----------  --------------------    ---------------    ------------------------
      1.0        08/11/2011  Keila Carpio     Creacion REQ 160732 Gestion de SOTs
 ********************************************************************************************/
DECLARE
  lc_accion      char(1);
  ln_secuencia number; 
  lc_usuario_log varchar2(100); 
BEGIN

  select HISTORICO.SQ_OPE_TIPOMASIVASOT_MAE_LOG.nextval
  	into ln_secuencia
           from HISTORICO.dummy_his;            

  
  select max(osuser)
    into lc_usuario_log
    from v$session
   where audsid = (select userenv('sessionid') from  HISTORICO.dummy_his); 

  lc_usuario_log := trim(rpad(user || '-' || lc_usuario_log, 30));
  if inserting then
    lc_accion := 'I';
    insert into HISTORICO.OPE_TIPOMASIVASOT_MAE_LOG
      (NUMLOG,
       IDTIPO, 
       DESCRIPCION,
       ACCLOG,
       USULOG,
       FECLOG)
    values
      (ln_secuencia,
       :new.IDTIPO,
       :new.DESCRIPCION,
       lc_accion,
       lc_usuario_log,
       SYSDATE);
  elsif updating or deleting then
    if updating then
      lc_accion := 'U';
    elsif deleting then
      lc_accion := 'D';
    end if;
  
    insert into HISTORICO.OPE_TIPOMASIVASOT_MAE_LOG
      (NUMLOG,
       IDTIPO, 
       DESCRIPCION,
       ACCLOG,
       USULOG,
       FECLOG)
    values
      (ln_secuencia,:old.IDTIPO,
       :old.DESCRIPCION,
       lc_accion,
       lc_usuario_log,
       SYSDATE);
  end if;

END;
/
