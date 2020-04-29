
insert into operacion.tipopedd ( DESCRIPCION, ABREV)
values ('CONFIGURACION LTE TAREA PROG', 'TAREA_PROG_LTE');

insert into tipopedd ( DESCRIPCION, ABREV)
values ('CONFIGURACION LTE', 'CONF_LTE_ORI_EST');

insert into tipopedd ( DESCRIPCION, ABREV)
values ('CONFIGURACION TAREA LTE', 'CONF_TAR_LTE');

insert into tipopedd ( DESCRIPCION, ABREV)
values ('CONFIGURACION PROD LTE', 'CONF_PROD_LTE');
commit;



insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('SIAC', 2, 'Baja Total', 'BAJA_PROGRAMADA', ( select tipopedd from operacion.tipopedd where abrev = 'TAREA_PROG_LTE' ), 0);

insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('SIAC', 3, 'Alta Servicio Adicional', 'ALTA_PROGRAMADA', ( select tipopedd from operacion.tipopedd where abrev = 'TAREA_PROG_LTE' ), 1);

insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('SIAC', 5, 'Baja Servicio Adicional', 'BAJA_PROGRAMADA', ( select tipopedd from operacion.tipopedd where abrev = 'TAREA_PROG_LTE' ), 1);

insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('SIAC', 8, 'Corte', 'BAJA_PROGRAMADA', ( select tipopedd from operacion.tipopedd where abrev = 'TAREA_PROG_LTE' ), 0);

insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('SIAC', 11, 'Reconexión de Corte', 'ALTA_PROGRAMADA', ( select tipopedd from operacion.tipopedd where abrev = 'TAREA_PROG_LTE' ), 0);

insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('OAC', 10, 'Desbloqueo', 'ALTA_PROGRAMADA', ( select tipopedd from operacion.tipopedd where abrev = 'TAREA_PROG_LTE' ), 0);

insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('OAC', 9, 'Bloqueo', 'BAJA_PROGRAMADA', ( select tipopedd from operacion.tipopedd where abrev = 'TAREA_PROG_LTE' ), 0);

insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('OAC', 2, 'Desactivacion', 'BAJA_PROGRAMADA', ( select tipopedd from operacion.tipopedd where abrev = 'TAREA_PROG_LTE' ), 0);

insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('OAC', 11, 'Reconexión', 'ALTA_PROGRAMADA', ( select tipopedd from operacion.tipopedd where abrev = 'TAREA_PROG_LTE' ), 0);
commit;


insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('SIAC', null, 'GENERACION SIAC', 'ORIGEN-PROVISION', ( select tipopedd from operacion.tipopedd where abrev = 'CONF_LTE_ORI_EST' ), null);

insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('OAC', null, 'GENERACION OAC', 'ORIGEN-PROVISION', ( select tipopedd from operacion.tipopedd where abrev = 'CONF_LTE_ORI_EST' ), null);

insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('TEL+INT', 7, 'PROVISION LTE', 'ESTADO-OK', ( select tipopedd from operacion.tipopedd where abrev = 'CONF_LTE_ORI_EST' ), 1);

insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('TV', 99, 'PROVISION DTH', 'ESTADO-OK', ( select tipopedd from operacion.tipopedd where abrev = 'CONF_LTE_ORI_EST' ), 1);

insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('TEL+INT', 100, 'PROVISION LTE', 'ESTADO-OK', ( select tipopedd from operacion.tipopedd where abrev = 'CONF_LTE_ORI_EST' ), 2);

insert into operacion.opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ( 'INTERNET', 7, 'PROVISION INTERNET', 'ESTADO-OK', ( select tipopedd from operacion.tipopedd where abrev = 'CONF_LTE_ORI_EST' ), null);

insert into operacion.opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ( 'INTERNET', 100, 'PROVISION INTERNET', 'ESTADO-OK', ( select tipopedd from operacion.tipopedd where abrev = 'CONF_LTE_ORI_EST' ), null);

insert into operacion.opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ( 'TELEFONIA', 7, 'PROVISION TELEFONIA', 'ESTADO-OK', ( select tipopedd from operacion.tipopedd where abrev = 'CONF_LTE_ORI_EST' ), null);

insert into operacion.opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ( 'TELEFONIA', 100, 'PROVISION TELEFONIA', 'ESTADO-OK', ( select tipopedd from operacion.tipopedd where abrev = 'CONF_LTE_ORI_EST' ), null);
commit;


insert into operacion.opedd ( DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ( 'TELEFONIA +  INTERNET LTE', 'TEL+INT', ( select tipopedd from operacion.tipopedd where abrev = 'CONF_PROD_LTE' ), 1);

insert into operacion.opedd ( DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ( 'TELEVISION LTE', 'TV', ( select tipopedd from operacion.tipopedd where abrev = 'CONF_PROD_LTE' ), 0);

insert into operacion.opedd ( DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ( 'INTERNET', 'INTERNET', ( select tipopedd from operacion.tipopedd where abrev = 'CONF_PROD_LTE' ), 1);

insert into operacion.opedd ( DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ( 'TELEFONIA', 'TELEFONIA', ( select tipopedd from operacion.tipopedd where abrev = 'CONF_PROD_LTE' ), 1);
commit;


insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('LTE', (select tareadef from tareadef  where upper(descripcion) = upper('CSR-Activacion Servicios LTE')), 'CSR-Activacion Servicios LTE', 'AUTOMATICO', ( select tipopedd from operacion.tipopedd where abrev = 'CONF_TAR_LTE' ), 11);

insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('LTE', (select tareadef from tareadef  where upper(descripcion) = upper('CSR-Desactivacion Servicios LTE')), 'CSR-Desactivacion Servicios LTE', 'AUTOMATICO', ( select tipopedd from operacion.tipopedd where abrev = 'CONF_TAR_LTE' ), 9);

insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('LTE', (select tareadef from tareadef  where upper(descripcion) = upper('Validacion Activacion/Desactivacion Adicionales')), 'Validacion Activacion/Desactivacion Adicionales', 'AUTOMATICO', ( select tipopedd from operacion.tipopedd where abrev = 'CONF_TAR_LTE' ), 3);

insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('LTE', (select tareadef from tareadef  where upper(descripcion) = upper('Validacion Activacion/Desactivacion Adicionales')), 'Validacion Activacion/Desactivacion Adicionales', 'AUTOMATICO', ( select tipopedd from operacion.tipopedd where abrev = 'CONF_TAR_LTE' ), 5);

insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('LTE', (select tareadef from tareadef  where upper(descripcion) = upper('Validación de Cancelacion de Servicios LTE')), 'Validacion de Cancelacion de Servicios LTE', 'MANUAL', ( select tipopedd from operacion.tipopedd where abrev = 'CONF_TAR_LTE' ), 2);
commit;

DELETE FROM  OPERACION.OPEDD WHERE TIPOPEDD = ( SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'TIP_TRA_CSR' );
COMMIT;

insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('SIAC', (select tiptra from operacion.tiptrabajo where upper(descripcion) = 'WLL/SIAC - ACTIVACION SERVICIOS ADICIONALES'), 'WLL/SIAC - ACTIVACION SERVICIOS ADICIONALES', '188', ( select tipopedd from operacion.tipopedd where abrev = 'TIP_TRA_CSR' ), 3);

insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('SIAC', (select tiptra from operacion.tiptrabajo where upper(descripcion) = 'WLL/SIAC - DESACTIVACION SERVICIOS ADICIONALES'), 'WLL/SIAC - DESACTIVACION SERVICIOS ADICIONALES', '188', ( select tipopedd from operacion.tipopedd where abrev = 'TIP_TRA_CSR' ), 5);

insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('SIAC', (select tiptra from operacion.tiptrabajo where upper(descripcion) = 'WLL/SIAC - CANCELACION DE SERVICIO'), 'WLL/SIAC - CANCELACION DE SERVICIO', '609', ( select tipopedd from operacion.tipopedd where abrev = 'TIP_TRA_CSR' ), 2);

insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('SIAC', (select tiptra from operacion.tiptrabajo where upper(descripcion) = 'WLL/SIAC - SUSPENSION A SOLIC. DEL CLIENTE'), 'WLL/SIAC - SUSPENSION A SOLIC. DEL CLIENTE', '188', ( select tipopedd from operacion.tipopedd where abrev = 'TIP_TRA_CSR' ), 8);

insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('SIAC', (select tiptra from operacion.tiptrabajo where upper(descripcion) = 'WLL/SIAC - RECONEXION DE CORTE A SOLIC. DEL CLIENTE'), 'WLL/SIAC - RECONEXION DE CORTE A SOLIC. DEL CLIENTE', '188', ( select tipopedd from operacion.tipopedd where abrev = 'TIP_TRA_CSR' ), 11);

insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('OAC', (select tiptra from operacion.tiptrabajo where upper(descripcion) = 'BAJA TOTAL 3PLAY INALAMBRICO'), 'BAJA TOTAL 3PLAY INALAMBRICO', '1002', ( select tipopedd from operacion.tipopedd where abrev = 'TIP_TRA_CSR' ), 2);

insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('OAC', (select tiptra from operacion.tiptrabajo where upper(descripcion) = 'SUSPENSION 3PLAY INALAMBRICO'), 'SUSPENSION 3PLAY INALAMBRICO', null, ( select tipopedd from operacion.tipopedd where abrev = 'TIP_TRA_CSR' ), 9);

insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('OAC', (select tiptra from operacion.tiptrabajo where upper(descripcion) = 'RECONEXION DE SUSPENSION 3PLAY INALAMBRICO'), 'RECONEXION DE SUSPENSION 3PLAY INALAMBRICO', null, ( select tipopedd from operacion.tipopedd where abrev = 'TIP_TRA_CSR' ), 10);

insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('OAC', (select tiptra from operacion.tiptrabajo where upper(descripcion) = 'RECONEXION DE SUSPENSION 3PLAY INALAMBRICO'), 'RECONEXION DE SUSPENSION 3PLAY INALAMBRICO', null, ( select tipopedd from operacion.tipopedd where abrev = 'TIP_TRA_CSR' ), 11);
commit;

