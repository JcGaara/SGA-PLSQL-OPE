
insert into operacion.tipopedd (tipopedd,descripcion,abrev) 
select nvl(max(t.tipopedd),0) + 1  ,'CONSOLID-MODIF CONS VENTACLARO','CONS_MODIF_CONS_VENT_CLARO' from operacion.tipopedd t;

INSERT INTO operacion.tipopedd (
  tipopedd,
  descripcion,
  abrev ) 
  select nvl(max(t.tipopedd),0) + 1  ,
		 'CONS CANALES-TIPO TRAB UPGRADE',
		 'CONS_N_CANALES_TRAB_UPGRADE' 
  from operacion.tipopedd t;


insert into operacion.tipopedd (
  tipopedd,
  descripcion,
  abrev) 
  select nvl(max(t.tipopedd),0) + 1  ,
         'CONSOLIDA TIPO VENTA-FASEII',
         'CONVEN_TIPVTA_F2_RF2' 
  from operacion.tipopedd t;

--Descripcion de Servicios
INSERT INTO operacion.tipopedd (
  tipopedd,
  descripcion,
  abrev )
VALUES (
  (select max(tipopedd) + 1 
     from operacion.tipopedd),
	'Consolidado Ventas  Desc  Serv',
	'CONSOLIDA_DESCSERVICIO');

INSERT INTO operacion.tipopedd (
  tipopedd,
  descripcion,
  abrev )
VALUES (
  (select max(tipopedd) + 1 
     from operacion.tipopedd),
	'Consolidado Ventas codtab',
	'CONSOLIDA_GENHISEST');

--Tipos de Trabajo de Diferenciales
INSERT INTO operacion.tipopedd (
  tipopedd,
  descripcion,
  abrev )
VALUES (
  (select max(tipopedd) + 1 
     from operacion.tipopedd),
	'Consolidado Ventas Dif Trabajo',
	'CONSOLIDA_DIFERENCIAL_TRA');

--Gerentes para Diferenciales
INSERT INTO operacion.tipopedd (
  tipopedd,
  descripcion,
  abrev )
VALUES (
  (select max(tipopedd) + 1 
     from operacion.tipopedd),
	'Consolidado Ventas Dif Consult',
	'CONSOLIDA_DIFERENCIAL_GER');

--Proyectos CE
INSERT INTO operacion.tipopedd (
  tipopedd,
  descripcion,
  abrev )
VALUES (
  (select max(tipopedd) + 1 
     from operacion.tipopedd),
	'Consolidado Ventas CE',
	'CONSOLIDA_TIPSER_CE');

--Diferenciales
INSERT INTO operacion.tipopedd (
  tipopedd,
  descripcion,
  abrev )
VALUES (
  (select max(tipopedd) + 1 
     from operacion.tipopedd),
	'Consolidado Ventas Diferencial',
	'CONSOLIDA_DIFERENCIAL');

--Tipos Trabajos de Campos Fijos
INSERT INTO operacion.tipopedd (
  tipopedd,
  descripcion,
  abrev )
VALUES (
  (select max(tipopedd) + 1 
     from operacion.tipopedd),
	'ConsolidadoVentasTipTrab_Fijos',
	'CONSOLIDA_TIPOS_TRAB_FIJOS');

--Proyectos Fibra
INSERT INTO operacion.tipopedd (
  tipopedd,
  descripcion,
  abrev )
VALUES (
  (select max(tipopedd) + 1 
     from operacion.tipopedd),
	'Consolidado Ventas Fibra',
	'CONSOLIDA_TIPSER_FIBRA');

--ESTADO para Valores Fijos
INSERT INTO operacion.tipopedd (
  tipopedd,
  descripcion,
  abrev )
VALUES (
  (select max(tipopedd) + 1 
     from operacion.tipopedd),
	'EstadoConsolidado',
	'CONSOLIDA_ESTADO');

-- Correos
INSERT INTO operacion.tipopedd (
  tipopedd,
  descripcion,
  abrev )
VALUES (
  (select max(tipopedd) + 1 
     from operacion.tipopedd),
	'Consolidado Ventas Correos',
	'CONSOLIDA_MAIL');

--PTACentral	
insert into tipopedd
(descripcion, abrev)
values('ConsolidadoVentasPtaCentral','CONSOLIDA_PTACENTRAL');

--Acceso
insert into tipopedd
(descripcion, abrev)
values('ConsolidadoVentasAcceso','CONSOLIDA_ACCESO');

--Equivalencias de Tipos de Trabajo
insert into tipopedd
(descripcion, abrev)
values('Consolidado Equivalencias','CONSOLIDA_EQUIVALENCIAS');

--Tipos Diferenciales
insert into tipopedd
(descripcion, abrev)
values('ConsolidadoTiposDiferenciales','CONSOLIDA_TIPOSDIFERENCIAL');

--Campos Fijos
insert into tipopedd
(descripcion, abrev)
values('ConsolidadoCamposFijos','CONSOLIDA_CAMPOSFIJOS');

--Cloud
INSERT INTO TIPOPEDD(descripcion,abrev) 
values ('Consolidado Serv Adic Cloud','CONSOLIDA_SERVICIO_CLOUD');

--Vta Productos
INSERT INTO TIPOPEDD(descripcion,abrev) 
values ('Consolidado Vtas Productos','CONSOLIDADO_VTA_PRDCTO');

--VER DW PARA PROYECTOS CE CON CLOUD ADICIONAL
INSERT INTO TIPOPEDD
(DESCRIPCION, ABREV)
VALUES('CONSOLIDADO_VERDW', 'CONSOLIDADO_VERDW');

--Segmento de Clientes para Diferenciales de Telefonia Fija
insert into tipopedd
(descripcion, abrev)
values('SEGMENTODIFERENCIAL','SEGMENTODIFERENCIAL');

--Metricas UGIS
insert into tipopedd
(descripcion, abrev)
values('METRICASUGIS','METRICASUGIS');

--Proyectos Internet
insert into tipopedd
(descripcion, abrev)
values('PROYECTOS DE INTERNET','PROYECTOSINTERNET');

--Proyectos RPV
insert into tipopedd
(descripcion, abrev)
values('PROYECTOS DE RPV','PROYECTOSRPV');

COMMIT;

----------------------------

--CONS_N_CANALES_TRAB_UPGRADE
INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE op.ABREV='CONS_N_CANALES_TRAB_UPGRADE'),
 '0004'  , 2 , 'Telefonia Fija' , 'UPGRADE DE SERVICIO' 
)  ;

--CONS_MODIF_CONS_VENT_CLARO
INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONS_MODIF_CONS_VENT_CLARO'),
 '0004'  , 1 , 'Telefonia Fija' , '' 
)  ;

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONS_MODIF_CONS_VENT_CLARO'),
 '0006'  , 2 , 'Acceso Dedicado a Internet' , '' 
)  ;

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONS_MODIF_CONS_VENT_CLARO'),
 '0025'  , 3 , 'Shared Server Hosting' , '' 
)  ;

--Configuracion de Canales CONVEN_CANAL
DELETE opedd
WHERE tipopedd = (Select tipopedd from tipopedd where upper(abrev) = 'CONVEN_CANAL');

insert into opedd (codigoc, codigon,descripcion, abreviacion, tipopedd)
values ('504', null, 'Telefonía Fija - Número de Canales', '0004', (Select tipopedd from tipopedd where upper(abrev) = 'CONVEN_CANAL'));

insert into opedd (codigoc, codigon,descripcion, abreviacion, tipopedd)
values ('905', 2, 'Telefonía Fija - Número de Canales Troncal SIP', '0004', (Select tipopedd from tipopedd where upper(abrev) = 'CONVEN_CANAL'));

--CONVEN_TIPVTA_F2_RF2
INSERT INTO operacion.OPEDD (
  IDOPEDD,
  TIPOPEDD,
  CODIGOC,
  CODIGON,
  DESCRIPCION,
  ABREVIACION) 
values( 
 (select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
 (SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONVEN_TIPVTA_F2_RF2'),
 '0073'  , 
 1 , 
 'Paquetes Pymes en HFC' , 
 'Claro Empresas' );

INSERT INTO operacion.OPEDD (
  IDOPEDD,
  TIPOPEDD,
  CODIGOC,
  CODIGON,
  DESCRIPCION,
  ABREVIACION) 
values( 
 (select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
 (SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONVEN_TIPVTA_F2_RF2'),
  '0058'  , 
  2 , 
  'Paquetes Pymes e Inmobiliario' , 
  'Claro Empresas') ;

-- CONSOLIDA_GENHISEST
INSERT INTO operacion.opedd ( 
  idopedd,
  codigoc, 
  codigon, 
  descripcion, 
  abreviacion, 
  tipopedd, 
  codigon_aux)
VALUES (
	(select max(operacion.opedd.idopedd) + 1 from operacion.opedd),
	'00013',
	NULL,
	'Codigo Tab',
	'Consolidado de Ventas Fibra',
	(SELECT tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_GENHISEST'),
	NULL);

-- CONSOLIDA_DESCSERVICIO
INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '527'  , 1 , 'Acceso Dedicado a Internet - Enlace Internacional' , '0006' );
  
INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '680'  , 2 , 'Enlace Backup - Internet' , '0006' );
  
INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '523'  , 3 , 'Professional Internet Access' , '0006' );

   INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '893'  , 4 , 'Monitoreo de Red Avanzado Internet' , '0006' );
  
     INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '714'  , 5 , 'ADI - BoD' , '0006' );

 INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '682'  , 6 , 'Servicios Adicionales - Internet' , '0006' );

  INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '907'  , 7 , 'Servicios Adicionales - Internet - Claro Proteccion' , '0006' );
  
  INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '813'  , 2 , 'Domestic IP Data - BT' , '0014' );

    INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '894'  , 3 , 'Monitoreo de Red Avanzado Domestic IP Data' , '0014' );

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '887'  , 4 , 'Domestic IP Data - Servicios Adicionales' , '0014' );

  INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '822'  , 1 , 'Acceso a facilidad externa de red' , '0069' );

  INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '541'  , 1 , 'Housing Setup' , '0020' );

 INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '734'  , 3 , 'Servicios Data Center IBM' , '0020' );

  INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '601'  , 1 , 'International ATM - Enlace' , '0042' );

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '580'  , 1 , 'Internacional Private Lines - Puerta' , '0022' );

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '510'  , 1 , 'Local IP Data - Puerta' , '0005' );

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '889'  , 3 , 'Local IP Data - Servicios Adicionales' , '0005' );

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '581'  , 1 , 'Local Private Lines - Puerta' , '0036' );

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '859'  , 3 , 'Local Private Lines - Servicios Complementarios' , '0036' );

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '824'  , 1 , 'Red Privada Virtual - Acceso Internacional' , '0049' );

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '708'  , 1 , 'RPVL ACCESO' , '0052' );

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '741'  , 2 , 'RPVL ACCESO Contingencia' , '0052' );
  
INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '892'  , 3 , 'Monitoreo de Red Avanzado RPVL' , '0052' );

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '871'  , 4 , 'RPVL Acceso Hosted IPPBX' , '0052' );

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '744'  , 5 , 'Reporte Avanzado de Trafico RPVL' , '0052' );

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '754'  , 6 , 'RPVL ACCESO POS' , '0052' );

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '735'  , 7 , 'RPVL Acceso - BoD' , '0052' );

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '810'  , 8 , 'RPVL ACCESO GPRS/EDGE' , '0052' );

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '719'  , 9 , 'RPVL BW Video' , '0052' );

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '723'  , 10 , 'RPVL ACCESO DATA CENTER' , '0052' );

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '739'  , 11 , 'Servicio Adicionales Red Privada Virtual' , '0052' );

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '727'  , 1 , 'RPVN ACCESO' , '0053' );

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '865'  , 3 , 'Reporte Avanzado de Trafico RPVN' , '0053' );

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '4'  , 1 , 'Servicio 0800 Local' , '0044' );

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '688'  , 2 , 'Servicio 0800 Nacional' , '0044' );

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '721'  , 3 , 'Servicio 0800 Internacional' , '0044' );

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '689'  , 4 , 'Servicio 0800 Local y Nacional' , '0044' );

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '6'  , 5 , 'Servicios Adicionales 0 800' , '0044' );

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '725'  , 1 , 'Servicio 0801 Local y Nacional' , '0056' );

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '864'  , 1 , 'Optimizacion Internet' , '0055' );

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '860'  , 2 , 'LAN Gestionada' , '0055' );

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '848'  , 4 , 'Marketing Dinamico' , '0055' );

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '839'  , 5 , 'PBX Gestionada' , '0055' );

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '816'  , 6 , 'Servicios Administrados' , '0055' );

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '814'  , 7 , 'Hosted IP PBX' , '0055' );

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '903'  , 8 , 'Hosted IP PBX - Contact Center' , '0055' );

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '896'  , 9 , 'LAN Gestionada - Servicios Adicionales' , '0055' );

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '898'  , 10 , 'Gestión de Aplicaciones - Servicios Adicionales' , '0055' );

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '897'  , 11 , 'Gestión de Aplicaciones' , '0055' );

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '807'  , 12 , 'Administración de BW a Internet' , '0055' );

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '747'  , 13 , 'Equipo Seguridad Administrada' , '0055' );

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '748'  , 14 , 'Servicios Adicionales - Seguridad Administrada' , '0055' );

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '524'  , 1 , 'Servicio E-mail' , '0025' );

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '551'  , 2 , 'Shared Server Hosting' , '0025' );

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '670'  , 3 , 'Servicios Adicionales de Hosting' , '0025' );

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '504'  , 1 , 'Telefonía Fija - Número de Canales' , '0004' );

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '503'  , 3 , 'Telefonía Fija - Líneas Analógicas' , '0004' );

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '758'  , 4 , 'Telefonía Fija - Líneas Analógicas Corporativas' , '0004' );

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '861'  , 5 , 'Telefonía - Linea Virtual' , '0004' );

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '819'  , 6 , 'Telefonía Fija - Lineas Troncales IP' , '0004' );

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '202'  , 7 , 'Bolsa de Minutos Nacional' , '0004' );

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '759'  , 8 , 'Bolsa de Minutos Móvil Local' , '0004' );

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '204'  , 9 , 'Bolsa de Minutos Local Ant.' , '0004' );

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '703'  , 10 , 'Bolsa de Minutos Local' , '0004' );

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '743'  , 11 , 'Bolsa de Minutos Local 0800' , '0004' );

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '804'  , 12 , 'Bolsa de Miinutos Nacional 0800' , '0004' );

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '736'  , 13 , 'Bolsa de Minutos Internacional - Inactivo' , '0004' );

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '501'  , 14 , 'Telefonía Fija - Líneas Digitales, DDR' , '0004' );

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '702'  , 15 , 'FAX SERVER' , '0004' );

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '502'  , 16 , 'Telefonía Fija - Servicios Adicionales' , '0004' );

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '605'  , 1 , 'Value Added Teleconference' , '0047' );

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '684'  , 3 , 'Mantenimiento de Equipos' , '0011' );

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '789'  , 1 , 'VSAT - Enlace ' , '0066' );
---
INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '905'  , 2 , 'Telefonía Fija - Número de Canales Troncal SIP' , '0004' );

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '522'  , 1 , 'Venta de Equipos' , '0011' );

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '732'  , 4 , 'RPVN  BW Video' , '0053' );

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '763'  , 5 , 'Red Empresarial Nacional' , '0053' );

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '751'  , 2 , 'Servicios Adicionales 0 801' , '0056' );

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '811'  , 6 , 'RPVN ACCESO GPRS/EDGE' , '0053' );

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '899'  , 2 , 'Monitoreo de Red Avanzado Local Private Lines' , '0036' );

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '919'  , 2 , 'Red Privada Virtual Internacional - Servicios Adicionales' , '0049' );

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '908'  , 2 , 'Monitoreo de Red Avanzado RPVN' , '0053' );

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION, CODIGON_AUX) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '745'  , 3 , 'Seguridad Administrada' , '0055', 1 );
 
 INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION, CODIGON_AUX) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '749'  , 3 , 'Seguridad Administrada' , '0055', 2 );
 
 INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION, CODIGON_AUX) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '521'  , 2 , 'Servicios Adicionales' , '0011', 2 );
 
  INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION, CODIGON_AUX) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '540'  , 2 , 'Housing' , '0020', 1 );
 
  INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION, CODIGON_AUX) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '542'  , 2 , 'Housing' , '0020', 3 );
 
  INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
 '514'  , 1 , 'Domestic IP Data - Enlace' , '0014' );
 
insert into opedd(IDOPEDD,TIPOPEDD,
CODIGOC,CODIGON,DESCRIPCION,ABREVIACION)
values(
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_DESCSERVICIO'),
'525' , 2, 'Enlace Backup', '0005');

-- CONSOLIDA_DIFERENCIAL_TRA
INSERT INTO operacion.opedd ( 
  idopedd,
  codigoc, 
  codigon, 
  descripcion, 
  abreviacion, 
  tipopedd, 
  codigon_aux)
VALUES (
	(select max(operacion.opedd.idopedd) + 1 from operacion.opedd),
	'1',
	2,
	'Upgrade de Servicio',
	'Upgrade',
	(SELECT tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_DIFERENCIAL_TRA'),
	1);
	
INSERT INTO operacion.opedd ( 
  idopedd,
  codigoc, 
  codigon, 
  descripcion, 
  abreviacion, 
  tipopedd, 
  codigon_aux)
VALUES (
	(select max(operacion.opedd.idopedd) + 1 from operacion.opedd),
	NULL,
	3,
	'Downgrade de Servicio',
	'Downgrade',
	(SELECT tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_DIFERENCIAL_TRA'),
	1);
	
INSERT INTO operacion.opedd ( 
  idopedd,
  codigoc, 
  codigon, 
  descripcion, 
  abreviacion, 
  tipopedd, 
  codigon_aux)
VALUES (
	(select max(operacion.opedd.idopedd) + 1 from operacion.opedd),
	NULL,
	9,
	'Renovación de Contrato',
	'Renovación',
	(SELECT tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_DIFERENCIAL_TRA'),
	1);
	
INSERT INTO operacion.opedd ( 
  idopedd,
  codigoc, 
  codigon, 
  descripcion, 
  abreviacion, 
  tipopedd, 
  codigon_aux)
VALUES (
	(select max(operacion.opedd.idopedd) + 1 from operacion.opedd),
	NULL,
	4,
	'Cambio de Equipo',
	'Cambio de Equipo',
	(SELECT tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_DIFERENCIAL_TRA'),
	1);
	
INSERT INTO operacion.opedd ( 
  idopedd,
  codigoc, 
  codigon, 
  descripcion, 
  abreviacion, 
  tipopedd, 
  codigon_aux)
VALUES (
	(select max(operacion.opedd.idopedd) + 1 from operacion.opedd),
	NULL,
	5,
	'Traslado Externo',
	'Traslado Externo',
	(SELECT tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_DIFERENCIAL_TRA'),
	1);
	
INSERT INTO operacion.opedd ( 
  idopedd,
  codigoc, 
  codigon, 
  descripcion, 
  abreviacion, 
  tipopedd, 
  codigon_aux)
VALUES (
	(select max(operacion.opedd.idopedd) + 1 from operacion.opedd),
	'1',
	1,
	'Instalacion',
	'Instalacion',
	(SELECT tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_DIFERENCIAL_TRA'),
	0);

-- CONSOLIDA_DIFERENCIAL_GER
INSERT INTO operacion.opedd ( 
	idopedd,
	codigoc, 
	codigon, 
	descripcion, 
	abreviacion, 
	tipopedd, 
	codigon_aux)
VALUES (
	(select max(operacion.opedd.idopedd) + 1 from operacion.opedd),
	'OTROS',
	28,
	'VARIOS',
	'DIFERENCIAL',
	(SELECT tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_DIFERENCIAL_GER'),
	1);
	
INSERT INTO operacion.opedd ( 
	idopedd,
	codigoc, 
	codigon, 
	descripcion, 
	abreviacion, 
	tipopedd, 
	codigon_aux)
VALUES (
	(select max(operacion.opedd.idopedd) + 1 from operacion.opedd),
	'00000032',
	0,
	'MIRKO LUCIANO LATINEZ FLORES',
	'DIFERENCIAL',
	(SELECT tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_DIFERENCIAL_GER'),
	1);
	
INSERT INTO operacion.opedd ( 
	idopedd,
	codigoc, 
	codigon, 
	descripcion, 
	abreviacion, 
	tipopedd, 
	codigon_aux)
VALUES (
	(select max(operacion.opedd.idopedd) + 1 from operacion.opedd),
	'00000332',
	0,
	'JAIME RUBEN ZAMBRANO CORDOVA',
	'DIFERENCIAL',
	(SELECT tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_DIFERENCIAL_GER'),
	1);
	
INSERT INTO operacion.opedd ( 
	idopedd,
	codigoc, 
	codigon, 
	descripcion, 
	abreviacion, 
	tipopedd, 
	codigon_aux)
VALUES (
	(select max(operacion.opedd.idopedd) + 1 from operacion.opedd),
	'00026361',
	0,
	'JOSE EDUARDO CORNEJO SUPARO',
	'DIFERENCIAL',
	(SELECT tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_DIFERENCIAL_GER'),
	1);

insert into opedd (
	IDOPEDD, 
	CODIGOC, 
	CODIGON, 
	DESCRIPCION, 
	ABREVIACION, 
	TIPOPEDD, 
	CODIGON_AUX)
values (
	(select max(operacion.opedd.idopedd) + 1 from operacion.opedd), 
	'00004138', 
	0, 
	'MIRKO LUCIANO LATINEZ FLORES', 
	'DIFERENCIAL', 
	(SELECT tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_DIFERENCIAL_GER'), 
	1);

insert into opedd (
	IDOPEDD, 
	CODIGOC, 
	CODIGON, 
	DESCRIPCION, 
	ABREVIACION, 
	TIPOPEDD, 
	CODIGON_AUX)
values (
	(select max(operacion.opedd.idopedd) + 1 from operacion.opedd), 
	'00032071', 
	0, 
	'MIRKO LUCIANO LATINEZ FLORES', 
	'DIFERENCIAL', 
	(SELECT tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_DIFERENCIAL_GER'), 
	1);

insert into opedd (
	IDOPEDD, 
	CODIGOC, 
	CODIGON,
	DESCRIPCION, 
	ABREVIACION, 
	TIPOPEDD, 
	CODIGON_AUX)
values (
	(select max(operacion.opedd.idopedd) + 1 from operacion.opedd), 
	'00000008', 
	0, 
	'JOSE EDUARDO CORNEJO SUPARO', 
	'DIFERENCIAL', 
	(SELECT tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_DIFERENCIAL_GER'), 
	1);

insert into opedd (
	IDOPEDD, 
	CODIGOC, 
	CODIGON, 
	DESCRIPCION, 
	ABREVIACION, 
	TIPOPEDD, 
	CODIGON_AUX)
values (
	(select max(operacion.opedd.idopedd) + 1 from operacion.opedd), 
	'00032069', 
	0, 
	'JOSE EDUARDO CORNEJO SUPARO', 
	'DIFERENCIAL', 
	(SELECT tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_DIFERENCIAL_GER'), 
	1);

insert into opedd (
	IDOPEDD, 
	CODIGOC, 
	CODIGON, 
	DESCRIPCION, 
	ABREVIACION, 
	TIPOPEDD, 
	CODIGON_AUX)
values (
	(select max(operacion.opedd.idopedd) + 1 from operacion.opedd), 
	'00000016', 
	0, 
	'JAIME RUBEN ZAMBRANO CORDOVA', 
	'DIFERENCIAL', 
	(SELECT tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_DIFERENCIAL_GER'), 
	1);

insert into opedd (
	IDOPEDD, 
	CODIGOC, 
	CODIGON, 
	DESCRIPCION, 
	ABREVIACION, 
	TIPOPEDD, 
	CODIGON_AUX)
values (
	(select max(operacion.opedd.idopedd) + 1 from operacion.opedd), 
	'00032068', 
	0, 
	'JAIME RUBEN ZAMBRANO CORDOVA', 
	'DIFERENCIAL', 
	(SELECT tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_DIFERENCIAL_GER'), 
	1);
	
insert into opedd (
	IDOPEDD, 
	CODIGOC, 
	CODIGON, 
	DESCRIPCION, 
	ABREVIACION, 
	TIPOPEDD, 
	CODIGON_AUX)
values (
	(select max(operacion.opedd.idopedd) + 1 from operacion.opedd),
	'00032065', 
	0, 
	'ALAIN SUAREZ ASCARZA', 
	'DIFERENCIAL', 
	(SELECT tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_DIFERENCIAL_GER'), 
	0);

insert into opedd (
	IDOPEDD, 
	CODIGOC, 
	CODIGON, 
	DESCRIPCION, 
	ABREVIACION, 
	TIPOPEDD, 
	CODIGON_AUX)
values (
	(select max(operacion.opedd.idopedd) + 1 from operacion.opedd),
	'00013824', 
	0, 
	'ALAIN SUAREZ ASCARZA', 
	'DIFERENCIAL', 
	(SELECT tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_DIFERENCIAL_GER'),
	0);

insert into opedd (
	IDOPEDD, 
	CODIGOC,
	CODIGON, 
	DESCRIPCION, 
	ABREVIACION, 
	TIPOPEDD, 
	CODIGON_AUX)
values (
	(select max(operacion.opedd.idopedd) + 1 from operacion.opedd),
	'00013956', 
	0, 
	'ALAIN SUAREZ ASCARZA', 
	'DIFERENCIAL', 
	(SELECT tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_DIFERENCIAL_GER'),
	0);

insert into opedd (
	IDOPEDD, 
	CODIGOC,
	CODIGON, 
	DESCRIPCION, 
	ABREVIACION, 
	TIPOPEDD, 
	CODIGON_AUX)
values (
	(select max(operacion.opedd.idopedd) + 1 from operacion.opedd),
	'PORTABILIDAD', 
	35, 
	'PROYECTOS CON PORTABILIDAD', 
	'DIFERENCIAL', 
	(SELECT tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_DIFERENCIAL_GER'),
	1);

-- CONSOLIDA_TIPSER_CE
INSERT INTO operacion.opedd ( 
  idopedd,
  codigoc, 
  codigon, 
  descripcion, 
  abreviacion, 
  tipopedd, 
  codigon_aux)
VALUES (
	(select max(operacion.opedd.idopedd) + 1 from operacion.opedd),
	'0073',
	1,
	'Paquetes Pymes en HFC',
	'Claro Empresas',
	(SELECT tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_TIPSER_CE'),
	6);
	
INSERT INTO operacion.opedd ( 
  idopedd,
  codigoc, 
  codigon, 
  descripcion, 
  abreviacion, 
  tipopedd, 
  codigon_aux)
VALUES (
	(select max(operacion.opedd.idopedd) + 1 from operacion.opedd),
	'0058',
	2,
	'Paquetes Pymes e Inmobiliario',
	'Claro Empresas',
	(SELECT tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_TIPSER_CE'),
	6);

-- CONSOLIDA_DIFERENCIAL
INSERT INTO operacion.opedd ( 
  idopedd,
  codigoc, 
  codigon, 
  descripcion, 
  abreviacion, 
  tipopedd, 
  codigon_aux)
VALUES (
	(select max(operacion.opedd.idopedd) + 1 from operacion.opedd),
	'0004',
	NULL,
	'Telefonia Fija',
	'Consolidado Ventas Diferencial',
	(SELECT tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_DIFERENCIAL'),
	1);

-- CONSOLIDA_TIPOS_TRAB_FIJOS
INSERT INTO operacion.opedd ( 
  idopedd,
  codigoc, 
  codigon, 
  descripcion, 
  abreviacion, 
  tipopedd, 
  codigon_aux)
VALUES (
	(select max(operacion.opedd.idopedd) + 1 from operacion.opedd),
	NULL,
	2,
	'Upgrade de Servicio',
	'Upgrade',
	(SELECT tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_TIPOS_TRAB_FIJOS'),
	1);
	
INSERT INTO operacion.opedd ( 
  idopedd,
  codigoc, 
  codigon, 
  descripcion, 
  abreviacion, 
  tipopedd, 
  codigon_aux)
VALUES (
	(select max(operacion.opedd.idopedd) + 1 from operacion.opedd),
	NULL,
	4,
	'Cambio de Equipo',
	'Cambio de Equipo',
	(SELECT tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_TIPOS_TRAB_FIJOS'),
	NULL);
	
INSERT INTO operacion.opedd ( 
  idopedd,
  codigoc, 
  codigon, 
  descripcion, 
  abreviacion, 
  tipopedd, 
  codigon_aux)
VALUES (
	(select max(operacion.opedd.idopedd) + 1 from operacion.opedd),
	NULL,
	3,
	'Downgrade de Servicio',
	'Downgrade',
	(SELECT tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_TIPOS_TRAB_FIJOS'),
	NULL);
	
INSERT INTO operacion.opedd ( 
  idopedd,
  codigoc, 
  codigon, 
  descripcion, 
  abreviacion, 
  tipopedd, 
  codigon_aux)
VALUES (
	(select max(operacion.opedd.idopedd) + 1 from operacion.opedd),
	NULL,
	5,
	'Traslado Externo',
	'Traslado Externo',
	(SELECT tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_TIPOS_TRAB_FIJOS'),
	NULL);
	
INSERT INTO operacion.opedd ( 
  idopedd,
  codigoc, 
  codigon, 
  descripcion, 
  abreviacion, 
  tipopedd, 
  codigon_aux)
VALUES (
	(select max(operacion.opedd.idopedd) + 1 from operacion.opedd),
	NULL,
	9,
	'Renovación de Contrato',
	'Renovación',
	(SELECT tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_TIPOS_TRAB_FIJOS'),
	NULL);
	
INSERT INTO operacion.opedd ( 
  idopedd,
  codigoc, 
  codigon, 
  descripcion, 
  abreviacion, 
  tipopedd, 
  codigon_aux)
VALUES (
	(select max(operacion.opedd.idopedd) + 1 from operacion.opedd),
	NULL,
	7,
	'Traslado Interno',
	'Traslado Interno',
	(SELECT tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_TIPOS_TRAB_FIJOS'),
	NULL);
	
INSERT INTO operacion.opedd ( 
  idopedd,
  codigoc, 
  codigon, 
  descripcion, 
  abreviacion, 
  tipopedd, 
  codigon_aux)
VALUES (
	(select max(operacion.opedd.idopedd) + 1 from operacion.opedd),
	NULL,
	6,
	'Venta Complementaria',
	'Venta Complementaria',
	(SELECT tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_TIPOS_TRAB_FIJOS'),
	NULL);

-- CONSOLIDA_TIPSER_FIBRA
INSERT INTO operacion.opedd ( 
  idopedd,
  codigoc, 
  codigon, 
  descripcion, 
  abreviacion, 
  tipopedd, 
  codigon_aux)
VALUES (
	(select max(operacion.opedd.idopedd) + 1 from operacion.opedd),
	'0006',
	3,
	'Acceso Dedicado a Internet',
	'Fibra Corporativo',
	(SELECT tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_TIPSER_FIBRA'),
	0);
	
INSERT INTO operacion.opedd ( 
  idopedd,
  codigoc, 
  codigon, 
  descripcion, 
  abreviacion, 
  tipopedd, 
  codigon_aux)
VALUES (
	(select max(operacion.opedd.idopedd) + 1 from operacion.opedd),
	'0027',
	4,
	'Alquileres',
	'Fibra Corporativo',
	(SELECT tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_TIPSER_FIBRA'),
	0);
	
INSERT INTO operacion.opedd ( 
  idopedd,
  codigoc, 
  codigon, 
  descripcion, 
  abreviacion, 
  tipopedd, 
  codigon_aux)
VALUES (
	(select max(operacion.opedd.idopedd) + 1 from operacion.opedd),
	'0014',
	5,
	'Domestic IP Data',
	'Fibra Corporativo',
	(SELECT tipopedd from tipopedd where upper(abrev)= 'CONSOLIDA_TIPSER_FIBRA'),
	0);
	
INSERT INTO operacion.opedd ( 
  idopedd,
  codigoc, 
  codigon, 
  descripcion, 
  abreviacion, 
  tipopedd, 
  codigon_aux)
VALUES (
	(select max(operacion.opedd.idopedd) + 1 from operacion.opedd),
	'0069',
	6,
	'Facilidades de Red',
	'Fibra Corporativo',
	(SELECT tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_TIPSER_FIBRA'),
	0);
	
INSERT INTO operacion.opedd ( 
  idopedd,
  codigoc, 
  codigon, 
  descripcion, 
  abreviacion, 
  tipopedd, 
  codigon_aux)
VALUES (
	(select max(operacion.opedd.idopedd) + 1 from operacion.opedd),
	'0020',
	7,
	'Housing',
	'Fibra Corporativo',
	(SELECT tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_TIPSER_FIBRA'),
	0);
	
INSERT INTO operacion.opedd ( 
  idopedd,
  codigoc, 
  codigon, 
  descripcion, 
  abreviacion, 
  tipopedd, 
  codigon_aux)
VALUES (
	(select max(operacion.opedd.idopedd) + 1 from operacion.opedd),
	'0042',
	8,
	'International ATM',
	'Fibra Corporativo',
	(SELECT tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_TIPSER_FIBRA'),
	0);
	
INSERT INTO operacion.opedd ( 
  idopedd,
  codigoc, 
  codigon, 
  descripcion, 
  abreviacion, 
  tipopedd, 
  codigon_aux)
VALUES (
	(select max(operacion.opedd.idopedd) + 1 from operacion.opedd),
	'0022',
	9,
	'International Private Lines',
	'Fibra Corporativo',
	(SELECT tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_TIPSER_FIBRA'),
	0);
	
INSERT INTO operacion.opedd ( 
  idopedd,
  codigoc, 
  codigon, 
  descripcion, 
  abreviacion, 
  tipopedd, 
  codigon_aux)
VALUES (
	(select max(operacion.opedd.idopedd) + 1 from operacion.opedd),
	'0005',
	10,
	'Local IP Data',
	'Fibra Corporativo',
	(SELECT tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_TIPSER_FIBRA'),
	0);
	
INSERT INTO operacion.opedd ( 
  idopedd,
  codigoc, 
  codigon, 
  descripcion, 
  abreviacion, 
  tipopedd, 
  codigon_aux)
VALUES (
	(select max(operacion.opedd.idopedd) + 1 from operacion.opedd),
	'0036',
	11,
	'Local Private Lines',
	'Fibra Corporativo',
	(SELECT tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_TIPSER_FIBRA'),
	0);
	
INSERT INTO operacion.opedd ( 
  idopedd,
  codigoc, 
  codigon, 
  descripcion, 
  abreviacion, 
  tipopedd, 
  codigon_aux)
VALUES (
	(select max(operacion.opedd.idopedd) + 1 from operacion.opedd),
	'0049',
	12,
	'Red Privada Virtual Internacional',
	'Fibra Corporativo',
	(SELECT tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_TIPSER_FIBRA'),
	0);
	
INSERT INTO operacion.opedd ( 
  idopedd,
  codigoc, 
  codigon, 
  descripcion, 
  abreviacion, 
  tipopedd, 
  codigon_aux)
VALUES (
	(select max(operacion.opedd.idopedd) + 1 from operacion.opedd),
	'0052',
	13,
	'Red Privada Virtual Local ',
	'Fibra Corporativo',
	(SELECT tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_TIPSER_FIBRA'),
	0);
	
INSERT INTO operacion.opedd ( 
  idopedd,
  codigoc, 
  codigon, 
  descripcion, 
  abreviacion, 
  tipopedd, 
  codigon_aux)
VALUES (
	(select max(operacion.opedd.idopedd) + 1 from operacion.opedd),
	'0053',
	14,
	'Red Privada Virtual Nacional',
	'Fibra Corporativo',
	(SELECT tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_TIPSER_FIBRA'),
	0);
	
INSERT INTO operacion.opedd ( 
  idopedd,
  codigoc, 
  codigon, 
  descripcion, 
  abreviacion, 
  tipopedd, 
  codigon_aux)
VALUES (
	(select max(operacion.opedd.idopedd) + 1 from operacion.opedd),
	'0044',
	15,
	'Servicio 0800',
	'Fibra Corporativo',
	(SELECT tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_TIPSER_FIBRA'),
	0);
	
INSERT INTO operacion.opedd ( 
  idopedd,
  codigoc, 
  codigon, 
  descripcion, 
  abreviacion, 
  tipopedd, 
  codigon_aux)
VALUES (
	(select max(operacion.opedd.idopedd) + 1 from operacion.opedd),
	'0056',
	16,
	'Servicio 0801',
	'Fibra Corporativo',
	(SELECT tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_TIPSER_FIBRA'),
	0);
	
INSERT INTO operacion.opedd ( 
  idopedd,
  codigoc, 
  codigon, 
  descripcion, 
  abreviacion, 
  tipopedd, 
  codigon_aux)
VALUES (
	(select max(operacion.opedd.idopedd) + 1 from operacion.opedd),
	'0055',
	17,
	'Servicios Administrados',
	'Fibra Corporativo',
	(SELECT tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_TIPSER_FIBRA'),
	0);
	
INSERT INTO operacion.opedd ( 
  idopedd,
  codigoc, 
  codigon, 
  descripcion, 
  abreviacion, 
  tipopedd, 
  codigon_aux)
VALUES (
	(select max(operacion.opedd.idopedd) + 1 from operacion.opedd),
	'0025',
	18,
	'Shared Server Hosting',
	'Fibra Corporativo',
	(SELECT tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_TIPSER_FIBRA'),
	0);
	
INSERT INTO operacion.opedd ( 
  idopedd,
  codigoc, 
  codigon, 
  descripcion, 
  abreviacion, 
  tipopedd, 
  codigon_aux)
VALUES (
	(select max(operacion.opedd.idopedd) + 1 from operacion.opedd),
	'0004',
	19,
	'Telefonia Fija',
	'Fibra Corporativo',
	(SELECT tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_TIPSER_FIBRA'),
	0);
	
INSERT INTO operacion.opedd ( 
  idopedd,
  codigoc, 
  codigon, 
  descripcion, 
  abreviacion, 
  tipopedd, 
  codigon_aux)
VALUES (
	(select max(operacion.opedd.idopedd) + 1 from operacion.opedd),
	'0047',
	20,
	'Value Added Teleconference',
	'Fibra Corporativo',
	(SELECT tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_TIPSER_FIBRA'),
	0);
	
INSERT INTO operacion.opedd ( 
  idopedd,
  codigoc, 
  codigon, 
  descripcion, 
  abreviacion, 
  tipopedd, 
  codigon_aux)
VALUES (
	(select max(operacion.opedd.idopedd) + 1 from operacion.opedd),
	'0011',
	21,
	'Venta',
	'Fibra Corporativo',
	(SELECT tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_TIPSER_FIBRA'),
	0);
	
INSERT INTO operacion.opedd ( 
  idopedd,
  codigoc, 
  codigon, 
  descripcion, 
  abreviacion, 
  tipopedd, 
  codigon_aux)
VALUES (
	(select max(operacion.opedd.idopedd) + 1 from operacion.opedd),
	'0066',
	22,
	'VSAT',
	'Fibra Corporativo',
	(SELECT tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_TIPSER_FIBRA'),
	0);

-- CONSOLIDA_ESTADO
INSERT INTO operacion.opedd ( 
  idopedd,
  codigoc, 
  codigon, 
  descripcion, 
  abreviacion, 
  tipopedd, 
  codigon_aux)
VALUES (
	(select max(operacion.opedd.idopedd) + 1 from operacion.opedd),
	'01',
	NULL,
	'Pendiente de Regularizacion',
	'Pendiente',
	(SELECT tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_ESTADO'),
	NULL);

-- CONSOLIDA_MAIL
insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ( 'Usuario', 1, 'José Goicochea ', 'jose.goicochea@claro.com.pe', (SELECT tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_MAIL'));

insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ( 'Usuario', 1, 'Jorge Arenas', 'jorge.arenas@claro.com.pe', (SELECT tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_MAIL'));

insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ( 'SOAP', 1, 'Richard Medina', 'richard.medina@claro.com.pe', (SELECT tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_MAIL'));

insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ( 'Otros', 1, 'Karen Velezmoro', 'e77119@claro.com.pe', (SELECT tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_MAIL'));

----Configuracion de Lineas Analogicas CONVEN_LINANALOGICA
update operacion.opedd
set abreviacion = '0058', codigon_aux = 1, DESCRIPCION = 'Telefonía Fija - Líneas Analógicas'
where tipopedd = (Select TIPOPEDD from TIPOPEDD where upper(abrev) = 'CONVEN_LINANALOGICA')
  and codigoc = '503';
  
update operacion.opedd
set abreviacion = '0004', codigon_aux = 1, DESCRIPCION = 'Telefonía Fija - Líneas Analógicas Corporativas'
where tipopedd = (Select TIPOPEDD from TIPOPEDD where upper(abrev) = 'CONVEN_LINANALOGICA')
  and codigoc = '758';

update operacion.opedd
set abreviacion = '0073', codigon_aux = 1, DESCRIPCION = 'Telefonía Fija - Líneas Cable Digital - Claro Empresas en HFC'
where tipopedd = (Select TIPOPEDD from TIPOPEDD where upper(abrev) = 'CONVEN_LINANALOGICA')
  and codigoc = '852';

insert into operacion.opedd (CODIGOC, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((Select idproducto from producto where descripcion = 'Telefonía Fija - Líneas Analógicas'), 
		 'Telefonía Fija - Líneas Analógicas', '0004', (Select TIPOPEDD from TIPOPEDD where upper(abrev) = 'CONVEN_LINANALOGICA'), 1);

--CONSOLIDA_ACCESO	 
insert into opedd
(codigoc, codigon, descripcion, abreviacion, tipopedd)
values('0049',824,'Red Privada Virtual - Acceso Internacional', 'ACCESO', (Select tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_ACCESO'));

insert into opedd
(codigoc, codigon,descripcion, abreviacion, tipopedd)
values('0052',708,'RPVL ACCESO', 'ACCESO', (Select tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_ACCESO'));

insert into opedd
(codigoc, codigon,descripcion, abreviacion, tipopedd)
values('0052',741,'RPVL ACCESO Contingencia', 'ACCESO', (Select tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_ACCESO'));

insert into opedd
(codigoc, codigon,descripcion, abreviacion, tipopedd)
values('0052',754,'RPVL ACCESO POS', 'ACCESO', (Select tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_ACCESO'));

insert into opedd
(codigoc, codigon,descripcion, abreviacion, tipopedd)
values('0053',727,'RPVN ACCESO', 'ACCESO', (Select tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_ACCESO'));

--CONSOLIDA_PTACENTRAL
insert into opedd
(codigoc, codigon,descripcion, abreviacion, tipopedd)
values('0006',527,'Acceso Dedicado a Internet - Enlace Internacional', 'PTACENTRAL', (Select tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_PTACENTRAL'));

insert into opedd
(codigoc, codigon,descripcion, abreviacion, tipopedd)
values('0006',680,'Enlace Backup - Internet', 'PTACENTRAL', (Select tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_PTACENTRAL'));

insert into opedd
(codigoc, codigon,descripcion, abreviacion, tipopedd)
values('0006',523,'Professional Internet Access', 'PTACENTRAL', (Select tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_PTACENTRAL'));

insert into opedd
(codigoc, codigon,descripcion, abreviacion, tipopedd)
values('0014',514,'Domestic IP Data - Enlace', 'PTACENTRAL', (Select tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_PTACENTRAL'));

insert into opedd
(codigoc, codigon,descripcion, abreviacion, tipopedd)
values('0069',822,'Acceso a facilidad externa de red', 'PTACENTRAL', (Select tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_PTACENTRAL'));

insert into opedd
(codigoc, codigon,descripcion, abreviacion, tipopedd)
values('0042',601,'International ATM - Enlace', 'PTACENTRAL', (Select tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_PTACENTRAL'));

insert into opedd
(codigoc, codigon,descripcion, abreviacion, tipopedd)
values('0022',580,'Internacional Private Lines - Puerta', 'PTACENTRAL', (Select tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_PTACENTRAL'));

insert into opedd
(codigoc, codigon,descripcion, abreviacion, tipopedd)
values('0005',510,'Local IP Data - Puerta', 'PTACENTRAL', (Select tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_PTACENTRAL'));

insert into opedd
(codigoc, codigon,descripcion, abreviacion, tipopedd)
values('0005',525,'Enlace Backup', 'PTACENTRAL', (Select tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_PTACENTRAL'));

insert into opedd
(codigoc, codigon,descripcion, abreviacion, tipopedd)
values('0036',581,'Local Private Lines - Puerta', 'PTACENTRAL', (Select tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_PTACENTRAL'));

insert into opedd
(codigoc, codigon,descripcion, abreviacion, tipopedd)
values('0066',789,'VSAT - Enlace', 'PTACENTRAL', (Select tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_PTACENTRAL'));

--CONSOLIDA_EQUIVALENCIAS
insert into opedd
(codigoc, codigon,descripcion, abreviacion, tipopedd)
values('1',1,'Instalación', 'EQUIVALENCIAS', (Select tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_EQUIVALENCIAS'));

insert into opedd
(codigoc, codigon,descripcion, abreviacion, tipopedd)
values('2',2,'Upgrade', 'EQUIVALENCIAS', (Select tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_EQUIVALENCIAS'));

insert into opedd
(codigoc, codigon,descripcion, abreviacion, tipopedd)
values('3',11,'Downgrade', 'EQUIVALENCIAS', (Select tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_EQUIVALENCIAS'));

insert into opedd
(codigoc, codigon,descripcion, abreviacion, tipopedd)
values('4',9,'Cambio de Equipos', 'EQUIVALENCIAS', (Select tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_EQUIVALENCIAS'));

insert into opedd
(codigoc, codigon,descripcion, abreviacion, tipopedd)
values('5',80,'Traslado Externo de Servicio', 'EQUIVALENCIAS', (Select tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_EQUIVALENCIAS'));

insert into opedd
(codigoc, codigon,descripcion, abreviacion, tipopedd)
values('6',429,'Ventas Complementarias', 'EQUIVALENCIAS', (Select tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_EQUIVALENCIAS'));

insert into opedd
(codigoc, codigon,descripcion, abreviacion, tipopedd)
values('7',155,'Traslado Interno', 'EQUIVALENCIAS', (Select tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_EQUIVALENCIAS'));

insert into opedd
(codigoc, codigon,descripcion, abreviacion, tipopedd)
values('9',144,'Renovacion de Servicio', 'EQUIVALENCIAS', (Select tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_EQUIVALENCIAS'));

insert into opedd
(codigoc, codigon,descripcion, abreviacion, tipopedd)
values('12',449,'Migración a RPV', 'EQUIVALENCIAS', (Select tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_EQUIVALENCIAS'));

--CONSOLIDA_TIPOSDIFERENCIAL
insert into opedd
(codigon,descripcion, abreviacion, tipopedd, codigon_aux)
values(1,'Fijo a Fijo', 'TIPOSDIFERENCIAL', (Select tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_TIPOSDIFERENCIAL'),1);

insert into opedd
(codigon,descripcion, abreviacion, tipopedd, codigon_aux)
values(2,'Fijo a Móvil', 'TIPOSDIFERENCIAL', (Select tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_TIPOSDIFERENCIAL'),1);

insert into opedd
(codigon,descripcion, abreviacion, tipopedd, codigon_aux)
values(7,'Larga Distancia', 'TIPOSDIFERENCIAL', (Select tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_TIPOSDIFERENCIAL'),0);

--CONSOLIDA_CAMPOSFIJOS
insert into opedd
(descripcion, abreviacion, tipopedd,codigon)
values('DURCON', 'CAMPOSFIJOS', (Select tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_CAMPOSFIJOS'),1);

insert into opedd
(descripcion, abreviacion, tipopedd, codigon)
values('NROADICIONALES', 'CAMPOSFIJOS', (Select tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_CAMPOSFIJOS'),1);

insert into opedd
(descripcion, abreviacion, tipopedd, codigon)
values('CODEST', 'CAMPOSFIJOS', (Select tipopedd from tipopedd where upper(abrev) = 'CONSOLIDA_CAMPOSFIJOS'),1);

----VER DW PARA PROYECTOS CE CON CLOUD ADICIONAL
insert into opedd
(codigoc, codigon, descripcion, abreviacion, tipopedd)
values('0006',1,'Acceso Dedicado a Internet','VER_DW_CE_CON_CLOUD', (Select tipopedd from tipopedd where upper(abrev) = 'CONSOLIDADO_VERDW'));

insert into opedd
(codigoc, codigon, descripcion, abreviacion, tipopedd)
values('0025',2,'Shared Server Hosting','VER_DW_CE_CON_CLOUD', (Select tipopedd from tipopedd where upper(abrev) = 'CONSOLIDADO_VERDW'));

insert into opedd
(codigoc, codigon, descripcion, abreviacion, tipopedd)
values('0062',3,'Cable','VER_DW_CE_CON_CLOUD', (Select tipopedd from tipopedd where upper(abrev) = 'CONSOLIDADO_VERDW'));

insert into opedd
(codigoc, codigon, descripcion, abreviacion, tipopedd)
values('0004',4,'Telefonia Fija','VER_DW_CE_CON_CLOUD', (Select tipopedd from tipopedd where upper(abrev) = 'CONSOLIDADO_VERDW'));

-----SEGMENTO PARA DIFERENCIALES DE TELEFONIA
insert into opedd
( codigon, descripcion, abreviacion, tipopedd, codigon_aux)
values(26,'GOBIERNO','SEGMENTO_DIFERENCIAL', (Select tipopedd from tipopedd where upper(abrev) = 'SEGMENTODIFERENCIAL'),1);

--------------------------
--CONSOLIDA_SERVICIO_CLOUD
INSERT INTO operacion.OPEDD 
(IDOPEDD,TIPOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION)
values((select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped),(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_SERVICIO_CLOUD'),'913',1,'CE - Presencia Web - Business','0083');

INSERT INTO operacion.OPEDD 
(IDOPEDD,TIPOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION)
values((select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped),(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_SERVICIO_CLOUD'),'913',1,'CE - Presencia Web - Elite Ecommerce','0083');

INSERT INTO operacion.OPEDD 
(IDOPEDD,TIPOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION)
values((select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped),(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_SERVICIO_CLOUD'),'913',1,'CE - Presencia Web - Web Entry','0083');

INSERT INTO operacion.OPEDD 
(IDOPEDD,TIPOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION)
values((select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped),(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_SERVICIO_CLOUD'),'912',1,'CE en HFC - Presencia Web - Business','0083');

INSERT INTO operacion.OPEDD 
(IDOPEDD,TIPOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION)
values((select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped),(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_SERVICIO_CLOUD'),'912',1,'CE en HFC - Presencia Web - Elite Ecommerce','0083');

INSERT INTO operacion.OPEDD 
(IDOPEDD,TIPOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION)
values((select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped),(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_SERVICIO_CLOUD'),'912',1,'CE en HFC - Presencia Web - Web Entry','0083');

INSERT INTO operacion.OPEDD 
(IDOPEDD,TIPOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION)
values((select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped),(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_SERVICIO_CLOUD'),'913',1,'CE Office 365 - Project Pro','0083');

INSERT INTO operacion.OPEDD 
(IDOPEDD,TIPOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION)
values((select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped),(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_SERVICIO_CLOUD'),'913',1,'CE Office 365 - Visio Pro ','0083');

INSERT INTO operacion.OPEDD 
(IDOPEDD,TIPOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION)
values((select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped),(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_SERVICIO_CLOUD'),'938',1,'CE: Office 365 - Paquete C','0083');

INSERT INTO operacion.OPEDD 
(IDOPEDD,TIPOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION)
values((select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped),(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_SERVICIO_CLOUD'),'913',1,'CE: Office 365 - Paquete E3','0083');

INSERT INTO operacion.OPEDD 
(IDOPEDD,TIPOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION)
values((select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped),(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_SERVICIO_CLOUD'),'913',1,'CE:Office 365 - Paquete E1','0083');

INSERT INTO operacion.OPEDD 
(IDOPEDD,TIPOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION)
values((select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped),(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_SERVICIO_CLOUD'),'913',1,'CE:Office 365 - Paquete K1','0083');

INSERT INTO operacion.OPEDD 
(IDOPEDD,TIPOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION)
values((select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped),(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_SERVICIO_CLOUD'),'913',1,'CE:Office 365 - Paquete M','0083');

INSERT INTO operacion.OPEDD 
(IDOPEDD,TIPOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION)
values((select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped),(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_SERVICIO_CLOUD'),'913',1,'CE:Office 365 - Paquete P1','0083');

INSERT INTO operacion.OPEDD 
(IDOPEDD,TIPOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION)
values((select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped),(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_SERVICIO_CLOUD'),'913',1,'CE:Office 365 - Paquete P2','0083');

INSERT INTO operacion.OPEDD 
(IDOPEDD,TIPOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION)
values((select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped),(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_SERVICIO_CLOUD'),'915',1,'Móvil + Presencia Web - Business','0083');

INSERT INTO operacion.OPEDD 
(IDOPEDD,TIPOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION)
values((select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped),(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_SERVICIO_CLOUD'),'915',1,'Móvil + Presencia Web - Elite Ecommerce','0083');

INSERT INTO operacion.OPEDD 
(IDOPEDD,TIPOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION)
values((select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped),(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_SERVICIO_CLOUD'),'915',1,'Móvil + Presencia Web - Web Entry','0083');

INSERT INTO operacion.OPEDD 
(IDOPEDD,TIPOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION)
values((select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped),(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_SERVICIO_CLOUD'),'939',1,'Office 365 - Paquete C','0083');

INSERT INTO operacion.OPEDD 
(IDOPEDD,TIPOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION)
values((select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped),(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_SERVICIO_CLOUD'),'940',1,'Office 365 - Paquete E1','0083');

INSERT INTO operacion.OPEDD 
(IDOPEDD,TIPOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION)
values((select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped),(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_SERVICIO_CLOUD'),'940',1,'Office 365 - Paquete E3','0083');

INSERT INTO operacion.OPEDD 
(IDOPEDD,TIPOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION)
values((select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped),(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_SERVICIO_CLOUD'),'912',1,'Office 365 - Paquete K1','0083');

INSERT INTO operacion.OPEDD 
(IDOPEDD,TIPOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION)
values((select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped),(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_SERVICIO_CLOUD'),'912',1,'Office 365 - Paquete M','0083');

INSERT INTO operacion.OPEDD 
(IDOPEDD,TIPOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION)
values((select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped),(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_SERVICIO_CLOUD'),'912',1,'Office 365 - Paquete P1','0083');

INSERT INTO operacion.OPEDD 
(IDOPEDD,TIPOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION)
values((select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped),(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_SERVICIO_CLOUD'),'912',1,'Office 365 - Paquete P2','0083');

INSERT INTO operacion.OPEDD 
(IDOPEDD,TIPOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION)
values((select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped),(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_SERVICIO_CLOUD'),'912',1,'Office 365 - Project Pro','0083');

INSERT INTO operacion.OPEDD 
(IDOPEDD,TIPOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION)
values((select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped),(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_SERVICIO_CLOUD'),'912',1,'Office 365 - Visio Pro ','0083');

INSERT INTO operacion.OPEDD 
(IDOPEDD,TIPOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION)
values((select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped),(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_SERVICIO_CLOUD'),'916',1,'Pre. Web','0083');

INSERT INTO operacion.OPEDD 
(IDOPEDD,TIPOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION)
values((select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped),(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_SERVICIO_CLOUD'),'912',1,'Presencia Web - Business','0083');

INSERT INTO operacion.OPEDD 
(IDOPEDD,TIPOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION)
values((select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped),(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_SERVICIO_CLOUD'),'912',1,'Presencia Web - Elite','0083');

INSERT INTO operacion.OPEDD 
(IDOPEDD,TIPOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION)
values((select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped),(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_SERVICIO_CLOUD'),'915',1,'Presencia WEB - Entry','0083');

INSERT INTO operacion.OPEDD 
(IDOPEDD,TIPOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION)
values((select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped),(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDA_SERVICIO_CLOUD'),'912',1,'Presencia Web - Web Entry','0083');

--CONSOLIDADO_VTA_PRDCTO
INSERT INTO operacion.OPEDD 
(IDOPEDD,TIPOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION,CODIGON_AUX)
values((select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped),(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDADO_VTA_PRDCTO'),'0058',1,'PRI-Paquetes Pymes e Inmobiliario','Claro Empresas',6);

INSERT INTO operacion.OPEDD 
(IDOPEDD,TIPOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION,CODIGON_AUX)
values((select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped),(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDADO_VTA_PRDCTO'),'0082',1,'PRI-Internet Móvil Claro','Cloud',10);

INSERT INTO operacion.OPEDD 
(IDOPEDD,TIPOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION,CODIGON_AUX)
values((select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped),(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDADO_VTA_PRDCTO'),'0073',1,'PRI-Paquetes Pymes en HFC','Claro Empresas',6);

INSERT INTO operacion.OPEDD 
(IDOPEDD,TIPOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION,CODIGON_AUX)
values((select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped),(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE upper(op.ABREV)='CONSOLIDADO_VTA_PRDCTO'),'0083',2,'ADIC-Serv. Adicional Cloud','Cloud',0);

--Metricas UGIS
INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,CODIGOC,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE op.ABREV='METRICASUGIS'),
 'NROPUERTAREM'  , 'Nro. Pta. Remota' , 'METRICAS');
 
INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,CODIGOC,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE op.ABREV='METRICASUGIS'),
 'NROPUERTASADIC'  , 'Nro. Pta. Adicional' , 'METRICAS');

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,CODIGOC,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE op.ABREV='METRICASUGIS'),
 'NROPUERTACENT'  , 'Nro. Pta. Central' , 'METRICAS');
  
INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,CODIGOC,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE op.ABREV='METRICASUGIS'),
 'NROPRIS'  , '# Pris' , 'METRICAS');
 
INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,CODIGOC,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE op.ABREV='METRICASUGIS'),
 'NROCANALES'  , '# Canales' , 'METRICAS');
    
INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,CODIGOC,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE op.ABREV='METRICASUGIS'),
 'NROTUPS'  , '# TUPs' , 'METRICAS');    
  
INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,CODIGOC,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE op.ABREV='METRICASUGIS'),
 'NROLINEASANALOG'  , '#Lineas Analog' , 'METRICAS');    
     
 INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,CODIGOC,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE op.ABREV='METRICASUGIS'),
 'RPVNROACC'  , 'Nro. Acceso' , 'METRICAS');   
   
 INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,CODIGOC,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE op.ABREV='METRICASUGIS'),
 'RPVNROPORT'  , 'Nro. Puerto RPV' , 'METRICAS');   
    
 INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,CODIGOC,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE op.ABREV='METRICASUGIS'),
 'RPVNROQ1'  , 'CoS1' , 'METRICAS');   
    
 INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,CODIGOC,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE op.ABREV='METRICASUGIS'),
 'RPVNROQ2'  , 'CoS2' , 'METRICAS');       
        
 INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,CODIGOC,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE op.ABREV='METRICASUGIS'),
 'RPVNROQ3'  , 'CoS3' , 'METRICAS');  
     
 INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,CODIGOC,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE op.ABREV='METRICASUGIS'),
 'RPVNROVIDEO'  , 'Nro. BW Video' , 'METRICAS');  
 
 ------PROYECTOS INTERNET
  INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,CODIGOC,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE op.ABREV='PROYECTOSINTERNET'),
 '0006' , 'Acceso Dedicado a Internet' , 'INTERNET');  
 
  INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,CODIGOC,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE op.ABREV='PROYECTOSINTERNET'),
 '0014' , 'Domestic IP Data' , 'INTERNET');  
 
  INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,CODIGOC,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE op.ABREV='PROYECTOSINTERNET'),
 '0069' , 'Facilidades de Red' , 'INTERNET');  
  
 INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,CODIGOC,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE op.ABREV='PROYECTOSINTERNET'),
 '0042' , 'International ATM' , 'INTERNET');  
   
 INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,CODIGOC,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE op.ABREV='PROYECTOSINTERNET'),
 '0022' , 'International Private Lines ' , 'INTERNET');  
 
 INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,CODIGOC,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE op.ABREV='PROYECTOSINTERNET'),
 '0005' , 'Local IP Data' , 'INTERNET');  
       
  INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,CODIGOC,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE op.ABREV='PROYECTOSINTERNET'),
 '0036' , 'Local Private Lines' , 'INTERNET');     
    
  INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,CODIGOC,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE op.ABREV='PROYECTOSINTERNET'),
 '0066' , 'VSAT' , 'INTERNET');  
     
--Proyectos RPV
INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,CODIGOC,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE op.ABREV='PROYECTOSRPV'),
 '0049' , 'Red Privada Virtual Internacional' , 'RPV'); 

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,CODIGOC,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE op.ABREV='PROYECTOSRPV'),
 '0052' , 'Red Privada Virtual Local ' , 'RPV');  
 
 INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,CODIGOC,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE op.ABREV='PROYECTOSRPV'),
 '0053' , 'Red Privada Virtual Nacional' , 'RPV');  
  
COMMIT;