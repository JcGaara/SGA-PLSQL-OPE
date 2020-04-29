create or replace trigger operacion.t_ope_trx_clarovideo_sva_aiud
  after insert or update or delete on operacion.ope_trx_clarovideo_sva
  referencing old as old new as new
  for each row
/*********************************************************************************************************************************
    nombre:               t_ope_trx_clarovideo_sva_aiud
    revisiones:
    ver        fecha        autor             solicitado por    descripcion
    ---------  ----------  ----------------  ----------------  ------------------------
    1.0        16/05/2014  César Quispe      Hector Huaman     REQ-165004 Creación Interface de compra servicios SVA
  ***********************************************************************************************************************************/

declare
  lc_usuario_log varchar2(100);
  lc_accion      char(1);
  ln_id          number(20);

begin

  select historico.sq_ope_trx_clarovideo_sva_log.nextval into ln_id from dual;

  select max(osuser)
    into lc_usuario_log
    from v$session
   where audsid = (select userenv('sessionid') from dual);

  lc_usuario_log := trim(rpad(user || '-' || lc_usuario_log, 50));

  if inserting then
    lc_accion := 'i';
    insert into historico.ope_trx_clarovideo_sva_log
      (idlog,
       idregistro,
       idtransaccion,
       aplicacion,
       usraplicacion,
       ipaplicacion,
       cod_cli_sga,
       tipo_operacion,
       criterio,
       numslc_inicial,
       numslc_final,
       codsolot,
       sid_inicial,
       sid_final,
       fecha_envio,
       resultado,
       mensaje,
       estado,
       nro_reintento,
       usureg,
       fecreg,
       usumod,
       fecmod,
       flag_envio_email,
       usulog,
       feclog,
       acclog)
    values
      (ln_id,
       :new.idregistro,
       :new.idtransaccion,
       :new.aplicacion,
       :new.usraplicacion,
       :new.ipaplicacion,
       :new.cod_cli_sga,
       :new.tipo_operacion,
       :new.criterio,
       :new.numslc_inicial,
       :new.numslc_final,
       :new.codsolot,
       :new.sid_inicial,
       :new.sid_final,
       :new.fecha_envio,
       :new.resultado,
       :new.mensaje,
       :new.estado,
       :new.nro_reintento,
       :new.usureg,
       :new.fecreg,
       :new.usumod,
       :new.fecmod,
       :new.flag_envio_email,
       lc_usuario_log,
       sysdate,
       lc_accion);
  elsif updating or deleting then
    if updating then
      lc_accion := 'u';
    elsif deleting then
      lc_accion := 'd';
    end if;

    insert into historico.ope_trx_clarovideo_sva_log
      (idlog,
       idregistro,
       idtransaccion,
       aplicacion,
       usraplicacion,
       ipaplicacion,
       cod_cli_sga,
       tipo_operacion,
       criterio,
       numslc_inicial,
       numslc_final,
       codsolot,
       sid_inicial,
       sid_final,
       fecha_envio,
       resultado,
       mensaje,
       estado,
       nro_reintento,
       usureg,
       fecreg,
       usumod,
       fecmod,
       flag_envio_email,
       usulog,
       feclog,
       acclog)
    values
      (ln_id,
       :old.idregistro,
       :old.idtransaccion,
       :old.aplicacion,
       :old.usraplicacion,
       :old.ipaplicacion,
       :old.cod_cli_sga,
       :old.tipo_operacion,
       :old.criterio,
       :old.numslc_inicial,
       :old.numslc_final,
       :old.codsolot,
       :old.sid_inicial,
       :old.sid_final,
       :old.fecha_envio,
       :old.resultado,
       :old.mensaje,
       :old.estado,
       :old.nro_reintento,
       :old.usureg,
       :old.fecreg,
       :old.usumod,
       :old.fecmod,
       :old.flag_envio_email,
       lc_usuario_log,
       sysdate,
       lc_accion);
  end if;
end;
/