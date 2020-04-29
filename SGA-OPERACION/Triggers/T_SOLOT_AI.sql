CREATE OR REPLACE TRIGGER OPERACION.T_SOLOT_AI
AFTER INSERT
ON OPERACION.SOLOT
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
DECLARE
tmpvar number;
ls_texto varchar2(1200);
ls_estsol varchar2(1000);
ls_cliente vtatabcli.nomcli%type;
ls_consultor vtatabect.nomect%type;
ls_tipsrv tystipsrv.dsctipsrv%type;
ls_segmento vtatabsegmark.dscsegmark%type;
ls_sector vtatabsecmark.dscsecmark%type;
ls_ejecutivo usuarioope.nombre%type;
-- para capturar el mail del ejecutivo
ls_ejecutivo_mail usuarioope.email%type;
ls_adminproy_mail usuarioope.email%type;
ls_adminproy_usuario usuarioope.usuario%type;
l_tiptrs number;
--
li_segmento number;
li_sector number;

/******************************************************************************
CAMBIOS

Fecha        Autor           Descripcion
----------  ---------------  ------------------------
26/01/2007 Gustavo Ormeo  Cambio de grupo detinatario en correo
   1.0    06/10/2010                      REQ.139588 Cambio de Marca

******************************************************************************/


cursor cur_correo is
select a.email from envcorreo a where a.tipo = 2 and a.coddpt = :new.coddpt;


--correo para el area de VENTAS
cursor cur_correo1 is
select a.email from envcorreo a where a.tipo = 2 and a.area=:new.areasol;


BEGIN

if :new.estsol = 11 then
    ls_texto := 'Fue aprobada por '||user||' Fecha: '||to_char(sysdate,'dd/mm/yyyy hh24:mi:ss')||chr(13);
  if :new.numslc is not null then
      ls_texto := ls_texto || 'Proyecto: '||:new.numslc;
  end if;
    for  ls_correo in cur_correo loop
      P_ENVIA_CORREO_DE_TEXTO_ATT('Solicitud de Orden de Trabajo '||to_char(:new.codsolot), ls_correo.email, ls_texto);
    end  loop;
end if;


if :new.numpsp is not null and :new.areasol = 102 then
    select descripcion into ls_estsol from estsol where estsol = :new.estsol;
  select nomcli into ls_cliente from vtatabcli where codcli = :new.codcli;
  select dsctipsrv into ls_tipsrv from tystipsrv where tipsrv = :new.tipsrv;
    ls_texto := 'Fue aprobada por '||user||' Fecha: '||to_char(sysdate,'dd/mm/yyyy hh24:mi:ss')||chr(13);
  ls_texto := ls_texto || 'ESTADO DE LA SOT: '|| ls_estsol || chr(13);
  ls_texto := ls_texto || 'Cliente: ' || ls_cliente || chr(13);
  ls_texto := ls_texto || 'Proyecto: '||:new.numslc || chr(13);
  ls_texto := ls_texto || 'Tipo de Servicio: ' || ls_tipsrv || chr(13);
    for  ls_correo1 in cur_correo1 loop
      P_ENVIA_CORREO_DE_TEXTO_ATT('Solicitud de Orden de Trabajo '||to_char(:new.codsolot), ls_correo1.email, ls_texto);
    end  loop;
end if;


  ---Req. 62937 Hector Huaman
  begin
  select s.usuario,s.email into ls_adminproy_usuario,ls_adminproy_mail
  from
  customer_atention c,
  userxdepartment u,
  usuarioope s
  where c.codccareuser=u.userid
  and u.flagccareuser=1
  and s.usuario=c.codccareuser
  and c.customercode= :new.codcli;
  exception
    when others then
       ls_adminproy_mail := null;
       ls_adminproy_usuario:=null;
  end;

  begin
  select tiptrs into l_tiptrs
  from tiptrabajo
  where tiptra=:new.tiptra;
    exception
    when others then
       l_tiptrs :=0;
  end;

---Req. 62937 Hector Huaman


/* Requerimiento 31004 */

if (:new.idopc is null and :new.numpsp is null and :new.numslc is null and :new.origen is null) and (:new.estsol = 10 or :new.estsol = 11) then

  begin
    select descripcion into ls_estsol from estsol where estsol = :new.estsol;
    exception
    when others then
       ls_estsol := null;
  end;

  begin
    select nvl(nomcli, '') into ls_cliente from vtatabcli where codcli = :new.codcli;
    exception
    when others then
       ls_cliente := null;
  end;

  begin
    select nvl(u.nombre, '') into ls_ejecutivo from usuarioope u, customer_atention c
    where u.usuario = c.codccareuser and c.customercode = :new.codcli;
    exception
    when others then
       ls_ejecutivo := null;
  end;

  begin
    select s.dscsegmark into ls_segmento from vtatabcli c, vtatabsegmark s
      where s.codsegmark = c.codsegmark and c.codcli = :new.codcli;
    exception
    when others then
       ls_segmento := null;
  end;

  begin
    select s.dscsecmark into ls_sector from vtatabcli c, vtatabsecmark s
    where s.codsecmark = c.codsecmark and c.codcli = :new.codcli;
    exception
    when others then
       ls_sector := null;
  end;

  begin
    select dsctipsrv into ls_tipsrv from tystipsrv where tipsrv = :new.tipsrv;
    exception
    when others then
       ls_tipsrv := null;
  end;

  begin
    select e.nomect into ls_consultor from vtatabcli c, vtatabect e
       where e.codect = c.codect and c.codcli = :new.codcli;

    exception
    when others then
       ls_consultor := null;
  end;
    ls_texto := 'Generado por usuario:'||user||' Fecha: '||to_char(sysdate,'dd/mm/yyyy hh24:mi:ss')||chr(13);

  if ls_estsol is not null then
     ls_texto := ls_texto || 'ESTADO DE LA SOT: '|| ls_estsol || chr(13);
    end if;

  if ls_cliente is not null then
    ls_texto := ls_texto || 'Cliente: ' || ls_cliente || chr(13);
  end if;

  if ls_segmento is not null then
     ls_texto := ls_texto || 'Segmento: ' || ls_segmento || chr(13);
  end if;

  if ls_sector is not null then
    ls_texto := ls_texto || 'Sector: ' || ls_sector || chr(13);
  end if;

  if :new.numslc is not null then
      ls_texto := ls_texto || 'Proyecto: '||:new.numslc;
  end if;

  if ls_tipsrv is not null then
     ls_texto := ls_texto || 'Tipo de Servicio: ' || ls_tipsrv || chr(13);
  end if;

  if ls_consultor is not null then
    ls_texto := ls_texto ||  'Consultor Asociado: ' || ls_consultor || chr(13);
  end if;

  if ls_ejecutivo is not null then
    ls_texto := ls_texto ||  'Ejecutivo Mantenimiento de Cuentas: ' || ls_ejecutivo || chr(13);
  end if;
-- SE REALIZA CAMBIO EN EL GRUPO DESTINATARIO DEL CORREO AUTOMTICO, GUSTAVO ORMEO, REQ. 47590
-- (DE DL-PE-MantenimientodeCuentas A DL-PE-AdministraciondeProyectos)
---OPEWF.PQ_SEND_MAIL_JOB.p_send_mail ('Solicitud de Orden de Trabajo '||to_char(:new.codsolot), 'DL-PE-AdministraciondeProyectos', ls_texto, 'SGA@Ventas' );
--CAMBIO REQ. 62937 DEL GRUPO DL-PE-AdministraciondeProyectos AL ADMINISTRADOR DEL PROYECTO
  if (:new.tipsrv<>'0058' and :new.tipsrv<>'0061' and :new.tipsrv<>'0062' and :new.tipsrv<>'0064' and :new.tipsrv<>'0059') and  (l_tiptrs in(1,2,6)) then
    if ls_adminproy_mail is not null then
      OPEWF.PQ_SEND_MAIL_JOB .p_send_mail ('Solicitud de Orden de Trabajo '||to_char(:new.codsolot), ls_adminproy_mail, ls_texto, 'SGA@Ventas' );
    else
       null;--1.00
       --if (ls_adminproy_usuario<>'CEXPLORA') or (ls_adminproy_usuario is null)  then
       --  OPEWF.PQ_SEND_MAIL_JOB.p_send_mail ('Solicitud de Orden de Trabajo '||to_char(:new.codsolot),'ursula.delgado', ls_texto, 'SGA@Ventas' );
       --end if;
    end if;
  end if;
--CAMBIO REQ. 62937 DEL GRUPO DL-PE-AdministraciondeProyectos AL ADMINISTRADOR DEL PROYECTO--1.0

end if;

------------------------------------------------------------------------------------------------------
--- INICIO - CAMBIO EN EL TRIGGER (GUSTAVO ORMEO) SOBRE REQUERIMIENTO 46446

if (:new.idopc is not null and :new.numpsp is not null /*and :new.numslc is null and :new.origen is null*/) and (:new.estsol = 10 or :new.estsol = 11) then

  begin
    select descripcion into ls_estsol from estsol where estsol = :new.estsol;
    exception
    when others then
       ls_estsol := null;
  end;

  begin
    select nvl(nomcli, '') into ls_cliente from vtatabcli where codcli = :new.codcli;
    exception
    when others then
       ls_cliente := null;
  end;

  begin
    select u.nombre into ls_ejecutivo from usuarioope u, customer_atention c
    where u.usuario = c.codccareuser and c.customercode = :new.codcli;
    exception
    when others then
       ls_ejecutivo := null;
  end;
  ---- mail del ejeutivo de cuenta
  begin
    select u.email into ls_ejecutivo_mail from usuarioope u, customer_atention c
    where u.usuario = c.codccareuser and c.customercode = :new.codcli;
    exception
    when others then
       ls_ejecutivo_mail := null;
  end;
  ------

  begin
    select s.dscsegmark into ls_segmento from vtatabcli c, vtatabsegmark s
      where s.codsegmark = c.codsegmark and c.codcli = :new.codcli;
    exception
    when others then
       ls_segmento := null;
  end;

  begin
    select s.dscsecmark into ls_sector from vtatabcli c, vtatabsecmark s
    where s.codsecmark = c.codsecmark and c.codcli = :new.codcli;
    exception
    when others then
       ls_sector := null;
  end;

  begin
    select dsctipsrv into ls_tipsrv from tystipsrv where tipsrv = :new.tipsrv;
    exception
    when others then
       ls_tipsrv := null;
  end;

  begin
    select e.nomect into ls_consultor from vtatabcli c, vtatabect e
       where e.codect = c.codect and c.codcli = :new.codcli;

    exception
    when others then
       ls_consultor := null;
  end;

    ls_texto := 'Generado por usuario:'||user||' Fecha: '||to_char(sysdate,'dd/mm/yyyy hh24:mi:ss')||chr(13);

  if ls_estsol is not null then
     ls_texto := ls_texto || 'ESTADO DE LA SOT: '|| ls_estsol || chr(13);
    end if;

  if ls_cliente is not null then
    ls_texto := ls_texto || 'Cliente: ' || ls_cliente || chr(13);
  end if;

  if ls_segmento is not null then
     ls_texto := ls_texto || 'Segmento: ' || ls_segmento || chr(13);
  end if;

  if ls_sector is not null then
    ls_texto := ls_texto || 'Sector: ' || ls_sector || chr(13);
  end if;

  if :new.numslc is not null then
      ls_texto := ls_texto || 'Proyecto: '||:new.numslc;
  end if;

  if ls_tipsrv is not null then
     ls_texto := ls_texto || 'Tipo de Servicio: ' || ls_tipsrv || chr(13);
  end if;

  if ls_consultor is not null then
    ls_texto := ls_texto ||  'Consultor Asociado: ' || ls_consultor || chr(13);
  end if;

  if ls_ejecutivo is not null then
    ls_texto := ls_texto ||  'Ejecutivo Mantenimiento de Cuentas: ' || ls_ejecutivo || chr(13);

  end if;

  if ls_ejecutivo_mail is not null then
    OPEWF.PQ_SEND_MAIL_JOB.p_send_mail ('Solicitud de Orden de Trabajo '||to_char(:new.codsolot), ls_ejecutivo_mail, ls_texto, 'SGA@Ventas' );
  else
-- SE REALIZA CAMBIO EN EL GRUPO DESTINATARIO DEL CORREO AUTOMTICO, GUSTAVO ORMEO, REQ. 47590
-- (DE DL-PE-MantenimientodeCuentas A DL-PE-AdministraciondeProyectos)--1.0
---OPEWF.PQ_SEND_MAIL_JOB.p_send_mail ('Solicitud de Orden de Trabajo '||to_char(:new.codsolot), 'DL-PE-AdministraciondeProyectos', ls_texto, 'SGA@Ventas' );--1.0
--CAMBIO REQ. 62937 DEL GRUPO DL-PE-AdministraciondeProyectos AL ADMINISTRADOR DEL PROYECTO--1.0
  if (:new.tipsrv<>'0058' and :new.tipsrv<>'0061' and :new.tipsrv<>'0062' and :new.tipsrv<>'0064' and :new.tipsrv<>'0059') and  (l_tiptrs in(1,2,6))  then
    if ls_adminproy_mail is not null then
      OPEWF.PQ_SEND_MAIL_JOB .p_send_mail ('Solicitud de Orden de Trabajo '||to_char(:new.codsolot), ls_adminproy_mail, ls_texto, 'SGA@Ventas' );
    else
       null;--1.0
       --if (ls_adminproy_usuario<>'CEXPLORA') or (ls_adminproy_usuario is null)  then
       --  OPEWF.PQ_SEND_MAIL_JOB.p_send_mail ('Solicitud de Orden de Trabajo '||to_char(:new.codsolot),'ursula.delgado', ls_texto, 'SGA@Ventas' );
       --end if;
    end if;
  end if;
--CAMBIO REQ. 62937 DEL GRUPO DL-PE-AdministraciondeProyectos AL ADMINISTRADOR DEL PROYECTO

  end if;

end if;


--- FIN - CAMBIO EN EL TRIGGER (GUSTAVO ORMEO) SOBRE REQUERIMIENTO 46446
--------------------------------------------------------------------------------------




--se inserta en las tablas de presupuesto
P_LLENA_PRESUPUESTO_DE_SOLOT(:new.codsolot, :new.codcli, :new.numslc, :new.tipsrv);

-- Se inserta en la tabla SOLOT_ADI.
insert into solot_adi (codsolot) values (:new.codsolot);

--
/*
-- Comentado por CC el 11/11/02
-- Ya no se requiere

begin

-- Se inserta en las tablas de documentacion
   select count(*) into tmpvar from docxcliente where codcli = :new.codcli;
   if tmpvar = 0 and :new.codcli is not null and :new.numslc is not null then
      insert into docxcliente( codcli, estdocxcli) values (:new.codcli, 1);
    insert into ctrldoc ( CODCLI, NUMSLC, ESTDOCXCLI ) values (:new.codcli, :new.numslc, 4);
   else
      update docxcliente set estdocxcli = 3 where codcli = :new.codcli and estdocxcli = 2;
      select count(*) into tmpvar from ctrldoc where codcli = :new.codcli and numslc = :new.numslc;
      if tmpvar = 0 and :new.codcli is not null and :new.numslc is not null then
         insert into ctrldoc ( CODCLI, NUMSLC, ESTDOCXCLI ) values (:new.codcli, :new.numslc, 4);
      end if;
   end if;
exception
  when others then
    null;
*/

END;
/



