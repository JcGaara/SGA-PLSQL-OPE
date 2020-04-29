create or replace trigger "OPERACION"."T_OPE_CORREO_AIUD"
   after insert or update or delete
   on operacion.ope_correo_mae
   referencing old as old new as new
   for each row
/********************************************************************************************
     ver     fecha          autor                solicitado por          descripcion
    ------  ----------  --------------------    ---------------    ------------------------
     1.0     13/10/2011  Kevy Carranza          REQ-161140         creación
 ********************************************************************************************/
declare
lc_usuario_log varchar2(100);
lc_accion      char(1);
id             number(18);
ln_campo       number;
begin
   ln_campo := 0;
select HISTORICO.SQ_OPE_CORREO_LOG.nextval into id from operacion.dummy_ope;

   select max(osuser) into lc_usuario_log
      from v$session
      where audsid = ( select userenv('sessionid') from dual);

   lc_usuario_log := trim(rpad(user||'-'||lc_usuario_log,50));

   if inserting then
      lc_accion := 'I';
      insert into HISTORICO.ope_correo_log(
                  idlog,
                  IDCORREO,
                  CORREO,
                  tipo,
                  usumod,
                  fecmod
                  )
      values   (  id,
                  :new.idcorreo,
                  :new.correo,
                  lc_accion,
                  lc_usuario_log,
                  sysdate );
   elsif updating or deleting then
      if updating then
         lc_accion := 'U';
      elsif deleting then
         lc_accion := 'D';
      end if;

      insert into HISTORICO.ope_correo_log(
                  idlog,
                  IDCORREO,
                  CORREO,
                  tipo,
                  usumod,
                  fecmod
                  )
      values   (  id,
                  :old.idcorreo,
                  :old.correo,
                  lc_accion,
                  lc_usuario_log,
                  sysdate );
      end if;
end;
/
