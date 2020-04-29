/*===============================================================================*/
insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ( 'MOCK', 1, 'ALTA', 'CONEXION_JANUS_PROCESO', (select tipopedd from tipopedd where abrev = 'PLAT_JANUS_CE'), 0);

insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ( 'WS', 1, 'ALTA', 'CONEXION_JANUS_PROCESO', (select tipopedd from tipopedd where abrev = 'PLAT_JANUS_CE'), 1);

insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ( 'WS', 2, 'BAJA', 'CONEXION_JANUS_PROCESO', (select tipopedd from tipopedd where abrev = 'PLAT_JANUS_CE'), 1);

insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ( 'MOCK', 2, 'BAJA', 'CONEXION_JANUS_PROCESO', (select tipopedd from tipopedd where abrev = 'PLAT_JANUS_CE'), 0);

insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ( 'WS', 16, 'CAMBIO PLAN', 'CONEXION_JANUS_PROCESO', (select tipopedd from tipopedd where abrev = 'PLAT_JANUS_CE'), 1);

insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ( 'MOCK', 16, 'CAMBIO PLAN', 'CONEXION_JANUS_PROCESO', (select tipopedd from tipopedd where abrev = 'PLAT_JANUS_CE'), 0);

insert into opedd (  CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (  368, 'ALTA WIMAX', 'TIPO_PROYECTO_ORIGEN', (select tipopedd from tipopedd where abrev = 'PLAT_JANUS_CE'), null);

insert into opedd (  CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (  424, 'ALTA HFC', 'TIPO_PROYECTO_ORIGEN', (select tipopedd from tipopedd where abrev = 'PLAT_JANUS_CE'), null);

/*===============================================================================*/
insert into tipopedd ( DESCRIPCION, ABREV)
values ( 'TAREAS CAMBIO JANUS', 'TAR_CAM_JANUS');

insert into tipopedd (DESCRIPCION, ABREV)
values ('Habilitación de Planes Control', 'HAB_WIMAX_JANUS');
/*===============================================================================*/
insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ( '1185', null, 'Activacion - Lineas Control CE', 'TAR_CAM_PLAN_JANUS', (select tipopedd from tipopedd where abrev = 'TAR_CAM_JANUS'), null);
insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ( '1186', null, 'Desactivacion - Lineas Control CE', 'TAR_CAM_PLAN_JANUS', (select tipopedd from tipopedd where abrev = 'TAR_CAM_JANUS'), null);
insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ( '10077', null, 'Act/ Desc Líneas Control Janus', 'TAR_CAM_PLAN_JANUS', (select tipopedd from tipopedd where abrev = 'TAR_CAM_JANUS'), null);

insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ( null, 1, 'habilita opcion planes control WiMax en Janus', 'habilitado', (select tipopedd from tipopedd where abrev = 'HAB_WIMAX_JANUS'), null);

insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('0058', null, 'Paquetes Pymes e Inmobiliario', 'FAMILIA', (select tipopedd from tipopedd where abrev = 'TIPSRV_JANUS_CE'), null);
/*===============================================================================*/
update tareadef t
set t.pos_proc = 'OPERACION.PQ_TELEFONIA_CE.POS_TAREA'
where TAREADEF = 1185;

update tareadef t
set  t.pos_proc = 'OPERACION.PQ_TELEFONIA_CE.POS_TAREA'
where TAREADEF = 1186;

insert into tareadef (TAREADEF, TIPO, DESCRIPCION, PRE_PROC, CUR_PROC, CHG_PROC, POS_PROC, PRE_MAIL, POS_MAIL, FLG_FT, FLG_WEB, SQL_VAL)
values (10077, 0, 'Act/ Desc Líneas Control Janus', 'OPERACION.PQ_TELEFONIA_CE.CAMBIO_PLAN', null, 'OPERACION.PQ_JANUS_CE_PROCESOS.CERRAR_TAREA_LINEA_C', 'OPERACION.PQ_TELEFONIA_CE.POS_TAREA', null, null, 0, null, null);
/*===============================================================================*/
commit;
/*===============================================================================*/
alter table operacion.telefonia_ce add TIPSRV CHAR(4) default '0073' not null;
comment on column OPERACION.TELEFONIA_CE.TIPSRV is 'Tipo de Servicio';

alter table operacion.telefonia_ce_det add WS_XML_RPTA VARCHAR2(4000);
comment on column OPERACION.TELEFONIA_CE_DET.WS_XML_RPTA is 'XML DE RESPUESTA WS';
