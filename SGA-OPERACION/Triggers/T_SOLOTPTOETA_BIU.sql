CREATE OR REPLACE TRIGGER OPERACION.T_SOLOTPTOETA_BIU
-- 2.0 REQ 128635 141200
BEFORE INSERT OR UPDATE
ON OPERACION.SOLOTPTOETA
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
declare
  ln_recosi solot.recosi%type;
  ln_ticket incidence.nticket%type;
  lc_mail   contrata.email%type;
  lc_mail_sup contrata.email%type;
  lc_subject opewf.cola_send_mail_job.subject%type;
  lc_cuerpo  opewf.cola_send_mail_job.cuerpo%type;
  lc_from    varchar2(400);
  ln_codot   ot.codot%type;
  lc_tiptra  tiptrabajo.descripcion%type;
  lc_observacion  ot.observacion%type;
  orden number; --2.0
begin
  if :old.codcon is null and :new.codcon is not null then
    select recosi
    into ln_recosi
    from solot
    where codsolot = :new.codsolot;

    if ln_recosi is not null then
      --Busca correo
      select email into lc_mail
      from contrata
      where codcon = :new.codcon;

      select nvl(tiptrabajo.descripcion,' ')  into lc_tiptra
      from solot, tiptrabajo
      where solot.tiptra = tiptrabajo.tiptra (+)
      and   solot.codsolot = :new.codsolot;

      if lc_mail is not null then
        begin
          select value
          into lc_mail_sup
          from atcparameter
          where codparameter = 'MAILGENOT';
        exception when others then
          lc_mail_sup := null;
        end;
        if lc_mail_sup is not null then
          lc_from := lc_mail_sup;
          lc_mail := lc_mail || ',' || lc_mail_sup;
        else
          lc_from := 'SGA';
        end if;
--DAJ-
        begin
          select nticket into ln_ticket
          from incidence where codincidence = ln_recosi;
        exception when no_data_found then
           ln_ticket := ln_Recosi;
        end;
        lc_subject := 'Ticket nro. ' || to_char(ln_ticket) || ' ' ||lc_tiptra||' : '||:new.obs;
--fin--
        begin
          select codot, observacion
          into ln_codot, lc_observacion
          from ot
          where codsolot = :new.codsolot;
        exception when others then
          ln_codot := null;
        end;
        lc_cuerpo  := lc_observacion || chr(10) || chr(13) || chr(10) || chr(13);
        lc_cuerpo  := lc_cuerpo || 'Este correo fue enviado a:  ' || lc_mail || '.';
        p_envia_correo_de_texto_att(lc_subject,lc_mail,lc_cuerpo,lc_from);
      end if;
    end if;
  end if;

 -- ini 2.0
 SELECT OPERACION.SQ_SOLOTPTOETA_AGEND_LOG.nextval INTO orden FROM DUMMY_OPE;

if inserting and (:new.codcon is not null) then
  insert into OPERACION.SOLOTPTOETA_AGENDAMIENTO_LOG
  values
    (orden, :new.CODSOLOT, :new.PUNTO, :NEW.ORDEN, sysdate, user, :new.CODCON);

elsif updating('CODCON') and (:new.codcon<> nvl(:old.codcon,0)) then
  insert into OPERACION.SOLOTPTOETA_AGENDAMIENTO_LOG
  values
    (orden, :new.CODSOLOT, :new.PUNTO, :NEW.ORDEN, sysdate, user, :new.CODCON);
end if;
-- fin 2.0
end t_solotptoeta_biu;
/



