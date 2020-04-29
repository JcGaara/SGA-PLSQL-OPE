CREATE OR REPLACE TRIGGER OPERACION.t_ope_sol_fecha_retro_cab_aiud
   after insert or update or delete
   on operacion.ope_solicitud_fecha_retro_cab
   referencing old as old new as new
   for each row
/********************************************************************************************
     ver     fecha          autor                solicitado por          descripcion
    ------  ----------  --------------------    ---------------    ------------------------
     1.0     04/06/2010  Joseph Asencios         REQ-118672        creación
 ********************************************************************************************/
declare
lc_usuario_log varchar2(100);
lc_accion      char(1);
id             number(18);
ln_campo       number;
begin
   ln_campo := 0;
   select sq_ope_sol_fecha_retro2_his.nextval into id from operacion.dummy_ope;

   select max(osuser) into lc_usuario_log
      from v$session
      where audsid = ( select userenv('sessionid') from dual);

   lc_usuario_log := trim(rpad(user||'-'||lc_usuario_log,50));

   if inserting then
      lc_accion := 'I';
      insert into ope_solicitud_fecha_retro2_his(
                  idsec,
                  idsol,
                  codsolot ,
                  idtipo,
                  area_ejec ,
                  usu_ejec ,
                  area_resp  ,
                  usu_jefe_aprob,
                  usu_aprob,
                  estado ,
                  fec_retro,
                  fec_regul,
                  fec_aprob,
                  observacion,
                  obs_aprob,
                  usu_adm_rec,
                  obs_adm_rec,
                  correo_adm_rec,
                  campo,
                  tipo,
                  usumod,
                  fecmod
                  )
      values   (  id,
                  :new.idsol,
                  :new.codsolot ,
                  :new.idtipo,
                  :new.area_ejec ,
                  :new.usu_ejec ,
                  :new.area_resp  ,
                  :new.usu_jefe_aprob,
                  :new.usu_aprob,
                  :new.estado ,
                  :new.fec_retro,
                  :new.fec_regul,
                  :new.fec_aprob,
                  :new.observacion,
                  :new.obs_aprob,
                  :new.usu_adm_rec,
                  :new.obs_adm_rec,
                  :new.correo_adm_rec,
                  12,
                  lc_accion,
                  lc_usuario_log,
                  sysdate );
   elsif updating or deleting then
      if updating then
         lc_accion := 'U';
      elsif deleting then
         lc_accion := 'D';
      end if;
      if (updating('estado') and :old.estado <> :new.estado ) and
         (updating('fec_retro') and :old.fec_retro <> :new.fec_retro) then
         ln_campo := 12;
      elsif (updating('estado') and :old.estado <> :new.estado) then
         ln_campo := 1;
      elsif (updating('fec_retro') and :old.fec_retro <> :new.fec_retro ) then
         ln_campo := 2;
      end if;

      insert into ope_solicitud_fecha_retro2_his(
                  idsec,
                  idsol,
                  codsolot ,
                  idtipo,
                  area_ejec ,
                  usu_ejec ,
                  area_resp  ,
                  usu_jefe_aprob,
                  usu_aprob,
                  estado ,
                  fec_retro,
                  fec_regul,
                  fec_aprob,
                  observacion,
                  obs_aprob,
                  usu_adm_rec,
                  obs_adm_rec,
                  correo_adm_rec,
                  campo,
                  tipo,
                  usumod,
                  fecmod )
      values   (  id,
                  :old.idsol,
                  :old.codsolot ,
                  :old.idtipo,
                  :old.area_ejec ,
                  :old.usu_ejec ,
                  :old.area_resp  ,
                  :old.usu_jefe_aprob,
                  :old.usu_aprob,
                  :old.estado ,
                  :old.fec_retro,
                  :old.fec_regul,
                  :old.fec_aprob,
                  :old.observacion,
                  :old.obs_aprob,
                  :old.usu_adm_rec,
                  :old.obs_adm_rec,
                  :old.correo_adm_rec,
                  ln_campo,
                  lc_accion,
                  lc_usuario_log,
                  sysdate );
      end if;
end;
/



