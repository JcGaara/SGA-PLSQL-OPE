create or replace trigger operacion.t_tarjeta_deco_asoc_aiud
  after insert or update or delete on operacion.tarjeta_deco_asoc
  referencing old as old new as  new
  for each row
/*------------------------------------------------------------------------------------------
    TRIGGER: operacion.t_tarjeta_deco_asoc_aiud
    MODIFICATION HISTORY
    Person         Date        Comments
    ---------      ----------  --------------------------------------------------------------
    Mauro Zegarra  14/11/2011   Creacion
-------------------------------------------------------------------------------------------*/
declare
  lc_usuario_log varchar2(100);
  lc_accion      char(1);
  idlog          number(18);

begin

  select historico.sq_tarjeta_deco_asoc_log.nextval into idlog from DUAL;

  select max(osuser)
    into lc_usuario_log
    from v$session
   where audsid = (select userenv('sessionid') from dual);

  lc_usuario_log := trim(rpad(user || '-' || lc_usuario_log, 50));

  if inserting then
    lc_accion := 'I';
    insert into historico.tarjeta_deco_asoc_log
      (ID,
       ID_ASOC,
       CODSOLOT,
       IDDET_DECO,
       NRO_SERIE_DECO,
       IDDET_TARJETA,
       NRO_SERIE_TARJETA,
       USUREG,
       FECREG,
       TIPO_LOG)
    values
      (idlog,
       :new.ID_ASOC,
       :new.CODSOLOT,
       :new.IDDET_DECO,
       :new.NRO_SERIE_DECO,
       :new.IDDET_TARJETA,
       :new.NRO_SERIE_TARJETA,
       lc_usuario_log,
       SYSDATE,
       lc_accion);
  elsif updating or deleting then
    if updating then
      lc_accion := 'U';
    elsif deleting then
      lc_accion := 'D';
    end if;
    insert into historico.tarjeta_deco_asoc_log
      (ID,
       ID_ASOC,
       CODSOLOT,
       IDDET_DECO,
       NRO_SERIE_DECO,
       IDDET_TARJETA,
       NRO_SERIE_TARJETA,
       USUREG,
       FECREG,
       TIPO_LOG)
    values
      (idlog,
       :old.ID_ASOC,
       :old.CODSOLOT,
       :old.IDDET_DECO,
       :old.NRO_SERIE_DECO,
       :old.IDDET_TARJETA,
       :old.NRO_SERIE_TARJETA,
       lc_usuario_log,
       SYSDATE,
       lc_accion);
  end if;
end;
/