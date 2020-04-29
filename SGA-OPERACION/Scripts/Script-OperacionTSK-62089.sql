------------------------------------------ PORTABILIDAD_USERS_AUTO
-------------------------------- cabecera
insert into tipopedd (TIPOPEDD, DESCRIPCION, ABREV)
values (null, 'PORTABILIDAD USERS AUTORIZADO', 'PORTABILIDAD_USERS_AUTO');
------------------------------------------ PORTABILIDAD_MSG_CP
update opedd o
   set o.codigon_aux = 1
 where o.tipopedd =
       (select t.tipopedd from tipopedd t where t.abrev = 'PORTABILIDAD_MSG_CP')
   and o.abreviacion = 'REC01ABD11';
------------------------------------------ PORTABILIDAD_MSG
update opedd o
   set o.codigon_aux = 1
 where o.tipopedd =
       (select t.tipopedd from tipopedd t where t.abrev = 'PORTABILIDAD_MSG')
   and o.abreviacion = '05R03';
------------------------------------------ PORTABILIDAD_VALIDACION
-------------------------------- cabecera
insert into tipopedd (TIPOPEDD, DESCRIPCION, ABREV)
values (null, 'Validaciones Portabilidad', 'portabilidad_validacion');
-------------------------------- detalle
insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null, 'des', 0, 'sisact_pkg_portabilidad_corpcp.sisacsi_registrar_sec_sga@dbl_sisact', 'consulta_previa', (select t.tipopedd from tipopedd t where t.abrev = 'portabilidad_validacion'), null);

insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null, 'prd', 1, 'usrpvu.sisact_pkg_portabilidad_corp.sisacsi_registrar_sec_sga@dbl_pvudb', 'consulta_previa', (select t.tipopedd from tipopedd t where t.abrev = 'portabilidad_validacion'), null);

insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null, 'des', 0, 'sisact_pkg_portabilidad_corpcp.sisacsu_anular_sec_sga@dbl_sisact', 'liberar_sisact_dblink', (select t.tipopedd from tipopedd t where t.abrev = 'portabilidad_validacion'), null);
                         
insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null, 'prd', 1, 'usrpvu.sisact_pkg_portabilidad_corp.sisacsu_anular_sec_sga@dbl_pvudb', 'liberar_sisact_dblink', (select t.tipopedd from tipopedd t where t.abrev = 'portabilidad_validacion'), null);
                         
insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null, 'mock', 0, 'mock', 'liberar_iw', (select t.tipopedd from tipopedd t where t.abrev = 'portabilidad_validacion'), null);

insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null, 'dblink', 1, 'dblink', 'liberar_iw', (select t.tipopedd from tipopedd t where t.abrev = 'portabilidad_validacion'), null);

insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null, 'mock', 0, 'mock', 'liberar_janus', (select t.tipopedd from tipopedd t where t.abrev = 'portabilidad_validacion'), null);

insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null, 'dblink', 1, 'dblink', 'liberar_janus', (select t.tipopedd from tipopedd t where t.abrev = 'portabilidad_validacion'), null);

insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null, null, 1, 'tim.pp001_pkg_prov_janus.sp_reg_prov_ctrl_corp', 'liberar_janus_dblink', (select t.tipopedd from tipopedd t where t.abrev = 'portabilidad_validacion'), null);

insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null, 'mock', 0, 'mock', 'liberar_sisact', (select t.tipopedd from tipopedd t where t.abrev = 'portabilidad_validacion'), null);

insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null, 'dblink', 1, 'dblink', 'liberar_sisact', (select t.tipopedd from tipopedd t where t.abrev = 'portabilidad_validacion'), null);

insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null, 'mock', 0, 'mock', 'liberar_bscs', (select t.tipopedd from tipopedd t where t.abrev = 'portabilidad_validacion'), null);

insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null, 'dblink', 1, 'dblink', 'liberar_bscs', (select t.tipopedd from tipopedd t where t.abrev = 'portabilidad_validacion'), null);

insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null, 'E77281', 0, 'Usuario', 'usuario', (select t.tipopedd from tipopedd t where t.abrev = 'portabilidad_validacion'), null);

insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null, 'atendido', 29, 'Estado Atendido a estado Anulado', 'estado_valida', (select t.tipopedd from tipopedd t where t.abrev = 'portabilidad_validacion'), 13);

insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null, '0073', null, 'Paquetes Pymes en HFC', 'portabilidad_srv', (select t.tipopedd from tipopedd t where t.abrev = 'portabilidad_validacion'), null);

insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null, null, 1, 'Liberar Numero en IW, BSCS, SISACT', 'habilitado', (select t.tipopedd from tipopedd t where t.abrev = 'portabilidad_validacion'), null);

insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null, null, null, 'Anular SEC x Liberacion de Numero', 'liberar_sisact_msg', (select t.tipopedd from tipopedd t where t.abrev = 'portabilidad_validacion'), null);

commit;

