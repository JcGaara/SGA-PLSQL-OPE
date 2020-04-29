
insert into tipopedd (DESCRIPCION, ABREV)
values ('PR_PORT_CORP_ALERTAS', 'PR-CORP-ALER');
commit;

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select tipsrv from tystipsrv where upper(dsctipsrv) ='TELEFONIA FIJA'), 1, (select dsctipsrv from tystipsrv where upper(dsctipsrv) ='TELEFONIA FIJA'), 'PR-CORP-TERM', ( select tipopedd from tipopedd where abrev ='PR-CORP-ALER' ), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select tipsrv from tystipsrv where upper(dsctipsrv) ='TELEFONIA FIJA'), 1, (select dsctipsrv from tystipsrv where upper(dsctipsrv) ='TELEFONIA FIJA'), 'PR-CORP-PEND', ( select tipopedd from tipopedd where abrev ='PR-CORP-ALER' ), null);

insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select tipsrv from tystipsrv where upper(dsctipsrv) ='SERVICIO 0800'), 1, (select dsctipsrv from tystipsrv where upper(dsctipsrv) ='SERVICIO 0800'), 'PR-CORP-PEND', ( select tipopedd from tipopedd where abrev ='PR-CORP-ALER' ), null);

insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select tipsrv from tystipsrv where upper(dsctipsrv) ='SERVICIO 0800'), 1, (select dsctipsrv from tystipsrv where upper(dsctipsrv) ='SERVICIO 0800'), 'PR-CORP-TERM', ( select tipopedd from tipopedd where abrev ='PR-CORP-ALER' ), null);

insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select tipsrv from tystipsrv where upper(dsctipsrv) ='SERVICIO 0801'), 1, (select dsctipsrv from tystipsrv where upper(dsctipsrv) ='SERVICIO 0801'), 'PR-CORP-PEND', ( select tipopedd from tipopedd where abrev ='PR-CORP-ALER' ), null);

insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select tipsrv from tystipsrv where upper(dsctipsrv) ='SERVICIO 0801'), 1, (select dsctipsrv from tystipsrv where upper(dsctipsrv) ='SERVICIO 0801'), 'PR-CORP-TERM', ( select tipopedd from tipopedd where abrev ='PR-CORP-ALER' ), null);

insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select tipsrv from tystipsrv where upper(dsctipsrv) ='PAQUETES PYMES E INMOBILIARIO'), 1, (select dsctipsrv from tystipsrv where upper(dsctipsrv) ='PAQUETES PYMES E INMOBILIARIO'), 'PR-CORP-TERM', ( select tipopedd from tipopedd where abrev ='PR-CORP-ALER' ), null);

insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select tipsrv from tystipsrv where upper(dsctipsrv) ='PAQUETES PYMES E INMOBILIARIO'), 1, (select dsctipsrv from tystipsrv where upper(dsctipsrv) ='PAQUETES PYMES E INMOBILIARIO'), 'PR-CORP-PEND', ( select tipopedd from tipopedd where abrev ='PR-CORP-ALER' ), null);

insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select tipsrv from tystipsrv where upper(dsctipsrv) ='PAQUETES PYMES EN HFC'), 1, (select dsctipsrv from tystipsrv where upper(dsctipsrv) ='PAQUETES PYMES EN HFC'), 'PR-CORP-TERM', ( select tipopedd from tipopedd where abrev ='PR-CORP-ALER' ), null);

insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select tipsrv from tystipsrv where upper(dsctipsrv) ='PAQUETES PYMES EN HFC'), 1, (select dsctipsrv from tystipsrv where upper(dsctipsrv) ='PAQUETES PYMES EN HFC'), 'PR-CORP-PEND', ( select tipopedd from tipopedd where abrev ='PR-CORP-ALER' ), null);
commit;

insert into tipopedd ( DESCRIPCION, ABREV)
values ( 'PR_PORT_CORP_MAIL', 'PR-CORP-MAIL');
commit;

insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ( null , null, 'sucasacad@globalhitss.com', 'PR-MAIL_PEN', ( select tipopedd from tipopedd where abrev ='PR-CORP-MAIL' ), null);

insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ( null, null, 'Portabilidad Numerica Fija (flujo corporativo): ALERTAS: SOT Pendientes', 'PR-ASUNTO_PEN', ( select tipopedd from tipopedd where abrev ='PR-CORP-MAIL' ), null);

insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ( null, null, 'Se envia Listado de SOT que se Acercan a la Fecha de Compromiso', 'PR-DETALLE_PEN', ( select tipopedd from tipopedd where abrev ='PR-CORP-MAIL' ), null);

insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ( null, null, 'sucasacad@globalhitss.com', 'PR-MAIL_VEN', ( select tipopedd from tipopedd where abrev ='PR-CORP-MAIL' ), null);

insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ( null, null, 'Portabilidad Numerica Fija (flujo corporativo): ALERTAS: SOT Vencidas', 'PR-ASUNTO_VEN', ( select tipopedd from tipopedd where abrev ='PR-CORP-MAIL' ), null);

insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ( null, null, 'Se envia Listado de SOT que se Encuentran con Fecha de Activacion Mayor a la Fecha de Compromiso', 'PR-DETALLE_VEN', ( select tipopedd from tipopedd where abrev ='PR-CORP-MAIL' ), null);
commit;

insert into tipopedd ( DESCRIPCION, ABREV)
values ( 'PR_PORT_CORP_WF', 'PR-CORP-WF');
commit;

insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select tipsrv from tystipsrv where upper(dsctipsrv) ='TELEFONIA FIJA'), 5, (select dsctipsrv from tystipsrv where upper(dsctipsrv) ='TELEFONIA FIJA'), 'BAJA-AUTO', ( select tipopedd from tipopedd where abrev ='PR-CORP-WF' ), 725);

insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select tipsrv from tystipsrv where upper(dsctipsrv) ='SERVICIO 0800'), 5, (select dsctipsrv from tystipsrv where upper(dsctipsrv) ='SERVICIO 0800'), 'BAJA-AUTO', ( select tipopedd from tipopedd where abrev ='PR-CORP-WF' ), 635);

insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select tipsrv from tystipsrv where upper(dsctipsrv) ='SERVICIO 0801'), 5, (select dsctipsrv from tystipsrv where upper(dsctipsrv) ='SERVICIO 0801'), 'BAJA-AUTO', ( select tipopedd from tipopedd where abrev ='PR-CORP-WF' ), 635);

insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select tipsrv from tystipsrv where upper(dsctipsrv) ='PAQUETES PYMES E INMOBILIARIO'), 5, (select dsctipsrv from tystipsrv where upper(dsctipsrv) ='PAQUETES PYMES E INMOBILIARIO'), 'BAJA-AUTO', ( select tipopedd from tipopedd where abrev ='PR-CORP-WF' ), 745);

insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select tipsrv from tystipsrv where upper(dsctipsrv) ='PAQUETES PYMES EN HFC'), 5, (select dsctipsrv from tystipsrv where upper(dsctipsrv) ='PAQUETES PYMES EN HFC'), 'BAJA-AUTO', ( select tipopedd from tipopedd where abrev ='PR-CORP-WF' ), 807);

--------
-------------------  INSERTAR URL
insert into operacion.constante
  (CONSTANTE, DESCRIPCION, TIPO, CODUSU, FECUSU, VALOR, OBS)
values
  ('TARGET-CORP',
   'Target URL de WS',
   'C',
   user,
   sysdate,
   'http://172.19.74.205:8903/GwPortaEnvioWS/GwPortaEnvioWSSoap11?wsdl',
   '');
------------------ INSERTAR ACTION
insert into constante
  (CONSTANTE, DESCRIPCION, TIPO, CODUSU, FECUSU, VALOR, OBS)
values
  ('ACT_PORTA_CORP',
   'ACTION_PORTABILIDAD',
   'C',
   user,
   sysdate,
   'http://claro.com.pe/eai/postventa/GwPortaEnvioWS/ws/types',
   '');

commit;
-----------
----------------PR_PORT_CORP_CONF
insert into tipopedd
  (tipopedd, descripcion, abrev)
values
  ((select max(tipopedd) + 1 from tipopedd),
   'PR_PORT_CORP_CONF',
   'PR_CORP_CONF');
--
insert into opedd
  (idopedd, codigoc, codigon, descripcion, abreviacion, tipopedd)
values
  ((select max(idopedd) + 1 from opedd),
   (select tipsrv from tystipsrv where upper(dsctipsrv) ='PAQUETES PYMES EN HFC'),
   1,
   (select dsctipsrv from tystipsrv where upper(dsctipsrv) ='PAQUETES PYMES EN HFC'),
   'TIPSRV',
   (select tipopedd from tipopedd where descripcion = 'PR_PORT_CORP_CONF'));
--
insert into opedd
  (idopedd, codigoc, codigon, descripcion, abreviacion, tipopedd)
values
  ((select max(idopedd) + 1 from opedd),
   (select tipsrv from tystipsrv where upper(dsctipsrv) ='SERVICIO 0800'),
   0,
   (select dsctipsrv from tystipsrv where upper(dsctipsrv) ='SERVICIO 0800'),
   'TIPSRV',
   (select tipopedd from tipopedd where descripcion = 'PR_PORT_CORP_CONF'));
--
insert into opedd
  (idopedd, codigoc, codigon, descripcion, abreviacion, tipopedd)
values
  ((select max(idopedd) + 1 from opedd),
   (select tipsrv from tystipsrv where upper(dsctipsrv) ='SERVICIO 0801'),
   0,
   (select dsctipsrv from tystipsrv where upper(dsctipsrv) ='SERVICIO 0801'),
   'TIPSRV',
   (select tipopedd from tipopedd where descripcion = 'PR_PORT_CORP_CONF'));
--   
insert into opedd
  (idopedd, codigoc, codigon, descripcion, abreviacion, tipopedd)
values
  ((select max(idopedd) + 1 from opedd),
   (select tipsrv from tystipsrv where upper(dsctipsrv) ='TELEFONIA FIJA'),
   0,
   (select dsctipsrv from tystipsrv where upper(dsctipsrv) ='TELEFONIA FIJA'),
   'TIPSRV',
   (select tipopedd from tipopedd where descripcion = 'PR_PORT_CORP_CONF'));
--   
insert into opedd
  (idopedd, codigoc, codigon, descripcion, abreviacion, tipopedd)
values
  ((select max(idopedd) + 1 from opedd),
   (select tipsrv from tystipsrv where upper(dsctipsrv) ='PAQUETES PYMES E INMOBILIARIO'),
   0,
   (select dsctipsrv from tystipsrv where upper(dsctipsrv) ='PAQUETES PYMES E INMOBILIARIO'),
   'TIPSRV',
   (select tipopedd from tipopedd where descripcion = 'PR_PORT_CORP_CONF'));
--   
insert into opedd
  (idopedd, codigoc, codigon, descripcion, abreviacion, tipopedd)
values
  ((select max(idopedd) + 1 from opedd),
   (select tareadef from tareadef     where trim(upper(descripcion)) = 'ACTIVACIÓN/DESACTIVACIÓN DEL SERVICIO'),
   null,
   (Select descripcion from tareadef     where trim(upper(descripcion)) = 'ACTIVACIÓN/DESACTIVACIÓN DEL SERVICIO'),
   'TAREAACT',
   (select tipopedd from tipopedd where descripcion = 'PR_PORT_CORP_CONF'));
--   
insert into opedd
  (idopedd, codigoc, codigon, descripcion, abreviacion, tipopedd)
values
  ((select max(idopedd) + 1 from opedd),
   (select tiptra from tiptrabajo  where trim(upper(descripcion)) = 'HFC - INSTALACION PAQUETES TODO CLARO DIGITAL'),
   null,
   (select descripcion from tiptrabajo  where trim(upper(descripcion)) = 'HFC - INSTALACION PAQUETES TODO CLARO DIGITAL'),
   'TIPTRAPLAY',
   (select tipopedd from tipopedd where descripcion = 'PR_PORT_CORP_CONF'));
--
commit;


--

insert into opedd
  (idopedd, codigoc, codigon, descripcion, abreviacion, tipopedd)
values
  ((select max(idopedd) + 1 from opedd),
   (select tiptra from tiptrabajo  where trim(upper(descripcion)) = 'HFC - INSTALACION PAQUETES TODO CLARO DIGITAL'),
   (select tiptra from tiptrabajo  where trim(upper(descripcion)) = 'HFC - INSTALACION PAQUETES TODO CLARO DIGITAL'),
   (select descripcion from tiptrabajo  where trim(upper(descripcion)) = 'HFC - INSTALACION PAQUETES TODO CLARO DIGITAL'),
   'TIPTRA_ALTA',
   (select tipopedd from tipopedd where descripcion = 'PR_PORT_CORP_CONF'));
--   
insert into opedd
  (idopedd, codigoc, codigon, descripcion, abreviacion, tipopedd)
values
  ((select max(idopedd) + 1 from opedd),
   (select tiptra from tiptrabajo  where trim(upper(descripcion)) = 'INSTALACION PAQUETES'),
   (select tiptra from tiptrabajo  where trim(upper(descripcion)) = 'INSTALACION PAQUETES'),
   (select descripcion from tiptrabajo  where trim(upper(descripcion)) = 'INSTALACION PAQUETES'),
   'TIPTRA_ALTA',
   (select tipopedd from tipopedd where descripcion = 'PR_PORT_CORP_CONF'));
--   
insert into opedd
  (idopedd, codigoc, codigon, descripcion, abreviacion, tipopedd)
values
  ((select max(idopedd) + 1 from opedd),
   (select tiptra from tiptrabajo  where trim(upper(descripcion)) = 'CONFIGURACION'),
   (select tiptra from tiptrabajo  where trim(upper(descripcion)) = 'CONFIGURACION'),
   (select descripcion from tiptrabajo  where trim(upper(descripcion)) = 'CONFIGURACION'),
   'TIPTRA_ALTA',
   (select tipopedd from tipopedd where descripcion = 'PR_PORT_CORP_CONF'));
--   
insert into opedd
  (idopedd, codigoc, codigon, descripcion, abreviacion, tipopedd)
values
  ((select max(idopedd) + 1 from opedd),
   (select tiptra from tiptrabajo  where trim(upper(descripcion)) = 'INSTALACION'),
   (select tiptra from tiptrabajo  where trim(upper(descripcion)) = 'INSTALACION'),
   (select descripcion from tiptrabajo  where trim(upper(descripcion)) = 'INSTALACION'),
   'TIPTRA_ALTA',
   (select tipopedd from tipopedd where descripcion = 'PR_PORT_CORP_CONF'));
--
commit;


--   
insert into opedd
  (idopedd, codigoc, codigon, descripcion, abreviacion, tipopedd)
values
  ((select max(idopedd) + 1 from opedd),
   (select tiptra from tiptrabajo  where trim(upper(descripcion)) = 'HFC - BAJA TODO CLARO TOTAL'),
   (select tiptra from tiptrabajo  where trim(upper(descripcion)) = 'HFC - BAJA TODO CLARO TOTAL'),
   (select descripcion from tiptrabajo  where trim(upper(descripcion)) = 'HFC - BAJA TODO CLARO TOTAL'),
   'TIPTRA_BAJA',
   (select tipopedd from tipopedd where descripcion = 'PR_PORT_CORP_CONF'));
--   
insert into opedd
  (idopedd, codigoc, codigon, descripcion, abreviacion, tipopedd)
values
  ((select max(idopedd) + 1 from opedd),
   (select tiptra from tiptrabajo  where trim(upper(descripcion)) = 'BAJA TOTAL DEL SERVICIO'),
   (select tiptra from tiptrabajo  where trim(upper(descripcion)) = 'BAJA TOTAL DEL SERVICIO'),
   (select descripcion from tiptrabajo  where trim(upper(descripcion)) = 'BAJA TOTAL DEL SERVICIO'),
   'TIPTRA_BAJA',
   (select tipopedd from tipopedd where descripcion = 'PR_PORT_CORP_CONF'));
--
commit;

insert into tipopedd (DESCRIPCION, ABREV)
values ('PR_PORT_CORP_WS', 'PR-CORP-WS');
commit;

insert into opedd (CODIGOC,  DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('PP', 'TIPO MENSAJE', 'WS_PP_MS', ( select tipopedd from tipopedd where abrev ='PR-CORP-WS' ), null);

insert into opedd (CODIGOC,  DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('21', 'REMITENTE', 'WS_PP_RE', ( select tipopedd from tipopedd where abrev ='PR-CORP-WS' ), null);

insert into opedd (CODIGOC,  DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('00', 'DESTINATARIO', 'WS_PP_DE', ( select tipopedd from tipopedd where abrev ='PR-CORP-WS' ), null);

commit;


