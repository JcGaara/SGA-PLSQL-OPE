/* parametros validacion cci*/
insert into operacion.tipopedd ( DESCRIPCION, ABREV)
values ('PARAMETRIA VALIDACION CCI', 'PAR_VAL_CCI');

insert into operacion.opedd (DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('VALIDACION_CCI', 'NOM_APP_CCI', (select t.tipopedd from tipopedd t where t.abrev = 'PAR_VAL_CCI'), 1);

insert into operacion.opedd ( DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('http://172.17.26.37:20000/ValidacionCCI/ebsValidacionCCISB11', 'URL_VAL_CCI', (select t.tipopedd from tipopedd t where t.abrev = 'PAR_VAL_CCI'), 1);

insert into operacion.opedd (CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (1, 'Activa Flujo Validacion CCI', 'FLAG_CCI', (select t.tipopedd from tipopedd t where t.abrev = 'PAR_VAL_CCI'), 1);     

insert into operacion.opedd (CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (1, 'Flag envio CCI', 'FLAG_ENVXML', (select t.tipopedd from tipopedd t where t.abrev = 'PAR_VAL_CCI'), 1);       

commit;