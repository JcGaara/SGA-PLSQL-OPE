insert into operacion.tipopedd (DESCRIPCION, ABREV)
values ('Tip. Trab. HFC-LTE Camb. Plan', 'TIPTRA_HFC_LTE_CP');

insert into operacion.opedd (CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (695, 'HFC/SIAC - CAMBIO DE PLAN', 'HFC_SIAC_CPLAN', (SELECT tipopedd FROM operacion.tipopedd b where B.ABREV ='TIPTRA_HFC_LTE_CP'), null);

insert into operacion.opedd (CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (753, 'WLL/SIAC - CAMBIO DE PLAN', 'LTE_SIAC_CPLAN', (SELECT tipopedd FROM operacion.tipopedd b where B.ABREV ='TIPTRA_HFC_LTE_CP'), null);

--
insert into operacion.tipopedd (DESCRIPCION, ABREV)
values ('CONFIG CAMBIO PLAN HFC-LTE', 'CONF_WLLSIAC_CP');

insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null, 1, 'CONTRAT POR DEFECTO', 'CONT_DEFAULT', (SELECT tipopedd FROM operacion.tipopedd b where B.ABREV ='CONF_WLLSIAC_CP'), null);

insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('H', 0, 'TIEMPO GRACIA(H:HORAS,D:DIAS)', 'TIME_SINVIST', (SELECT tipopedd FROM operacion.tipopedd b where B.ABREV ='CONF_WLLSIAC_CP'), null);

insert into operacion.opedd (CODIGOC, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('0', 'Act/Desact de Cambios CP-HFC/LTE', 'ACT_CPLAN', (SELECT tipopedd FROM operacion.tipopedd b where B.ABREV ='CONF_WLLSIAC_CP'), null);

--
insert into operacion.tipopedd (DESCRIPCION, ABREV)
values ('CONFIG. CAMBIO PLAN CIERRE', 'CONF_CP_CIERRE_SVT');

insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('AUTO', 1024, 'Agendamiento', 'HFC', (SELECT tipopedd FROM operacion.tipopedd b where B.ABREV ='CONF_CP_CIERRE_SVT'), 4);

insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('AUTO', 1192, 'Asignar Numero Telefonico CP', 'HFC', (SELECT tipopedd FROM operacion.tipopedd b where B.ABREV ='CONF_CP_CIERRE_SVT'), 4);

insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('AUTO', 1009, 'Gestion Programacion', 'HFC', (SELECT tipopedd FROM operacion.tipopedd b where B.ABREV ='CONF_CP_CIERRE_SVT'), 8);

insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('AUTO', 1020, 'Gestion Recursos IW', 'HFC', (SELECT tipopedd FROM operacion.tipopedd b where B.ABREV ='CONF_CP_CIERRE_SVT'), 4);

insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('AUTO', (select tareadef from opewf.tareadef where descripcion = 'Cambio de Plan JANUS'), 'Cambio de Plan JANUS', 'HFC', (SELECT tipopedd FROM operacion.tipopedd b where B.ABREV ='CONF_CP_CIERRE_SVT'), 4);

insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('VAL', 1248, 'Validar Servicios - Cambio Plan HFC', 'HFC', (SELECT tipopedd FROM operacion.tipopedd b where B.ABREV ='CONF_CP_CIERRE_SVT'), 4);

insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('AUTO', 299, 'Activacion/Desactivacion del servicio ', 'HFC', (SELECT tipopedd FROM operacion.tipopedd b where B.ABREV ='CONF_CP_CIERRE_SVT'), 4);

insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('AUTO', 1023, 'Liquidaciones Equ y MO', 'HFC', (SELECT tipopedd FROM operacion.tipopedd b where B.ABREV ='CONF_CP_CIERRE_SVT'), 8);

insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('AUTO', 1084, 'Descarga Equipos IW', 'HFC', (SELECT tipopedd FROM operacion.tipopedd b where B.ABREV ='CONF_CP_CIERRE_SVT'), 4);

insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('AUTO', 1216, 'Gestion fotos', 'HFC', (SELECT tipopedd FROM operacion.tipopedd b where B.ABREV ='CONF_CP_CIERRE_SVT'), 8);

--Datos Plan Comercial
insert into operacion.tipopedd ( DESCRIPCION, ABREV)
values ('Datos Trama Plan Comercial', 'TRAM_PLAN_COME');

insert into operacion.opedd ( CODIGON, CODIGOC, DESCRIPCION, TIPOPEDD)
values ( 1, 'CAB', 'TIPO_PLAN', ( select tipopedd from operacion.tipopedd where abrev = 'TRAM_PLAN_COME' ));

insert into operacion.opedd ( CODIGON, CODIGOC, DESCRIPCION, TIPOPEDD)
values ( 2, 'CAB', 'COD_PLAN', ( select tipopedd from operacion.tipopedd where abrev = 'TRAM_PLAN_COME' ));

insert into operacion.opedd ( CODIGON, CODIGOC, DESCRIPCION, TIPOPEDD)
values ( 3, 'CAB', 'TMCODE', ( select tipopedd from operacion.tipopedd where abrev = 'TRAM_PLAN_COME' ));

insert into operacion.opedd ( CODIGON, CODIGOC, DESCRIPCION, TIPOPEDD)
values ( 4, 'CAB', 'FEC_VENTA', ( select tipopedd from operacion.tipopedd where abrev = 'TRAM_PLAN_COME' ));

insert into operacion.opedd ( CODIGON, CODIGOC, DESCRIPCION, TIPOPEDD)
values ( 5, 'CAB', 'USUARIO', ( select tipopedd from operacion.tipopedd where abrev = 'TRAM_PLAN_COME' ));

insert into operacion.opedd ( CODIGON, CODIGOC, DESCRIPCION, TIPOPEDD)
values ( 6, 'CAB', 'TIPO_EQUIPO', ( select tipopedd from operacion.tipopedd where abrev = 'TRAM_PLAN_COME' ));

insert into operacion.opedd ( CODIGON, CODIGOC, DESCRIPCION, TIPOPEDD)
values ( 7, 'CAB', 'MODELO_EQUIPO', ( select tipopedd from operacion.tipopedd where abrev = 'TRAM_PLAN_COME' ));
--
insert into operacion.opedd ( CODIGON, CODIGOC, DESCRIPCION, TIPOPEDD)
values ( 1, 'DET', 'PRODUCTO', ( select tipopedd from operacion.tipopedd where abrev = 'TRAM_PLAN_COME' ));

insert into operacion.opedd ( CODIGON, CODIGOC, DESCRIPCION, TIPOPEDD)
values ( 2, 'DET', 'SNCODE', ( select tipopedd from operacion.tipopedd where abrev = 'TRAM_PLAN_COME' ));

insert into operacion.opedd ( CODIGON, CODIGOC, DESCRIPCION, TIPOPEDD)
values ( 3, 'DET', 'SP_CODE', ( select tipopedd from operacion.tipopedd where abrev = 'TRAM_PLAN_COME' ));

insert into operacion.opedd ( CODIGON, CODIGOC, DESCRIPCION, TIPOPEDD)
values ( 4, 'DET', 'TIPO_SERV', ( select tipopedd from operacion.tipopedd where abrev = 'TRAM_PLAN_COME' ));

insert into operacion.opedd ( CODIGON, CODIGOC, DESCRIPCION, TIPOPEDD)
values ( 5, 'DET', 'TIPEQU', ( select tipopedd from operacion.tipopedd where abrev = 'TRAM_PLAN_COME' ));


commit;
/