insert into operacion.tipopedd (DESCRIPCION, ABREV)
values ('Datos de Parametros', 'datos_param_sans');

insert into operacion.opedd (CODIGOC, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('ActualizarContratoRequest', 'Tipo de Proceso Actualizar Contrato', 'tipo_proceso_act_contrato',(select tipopedd from tipopedd where abrev='datos_param_sans'), 0);

insert into operacion.opedd (DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('http://172.16.115.164:7903/ActivosPostpagoConvergenteWS/ebsActivosPostpagoConvergenteSB11', 'url_act_cnt', (select tipopedd from tipopedd where abrev='datos_param_sans'), 0);

insert into operacion.opedd (DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('http://172.16.115.132:7903/SimcardsWS/ebsSimcards', 'url',(select tipopedd from tipopedd where abrev='datos_param_sans'), 0);

insert into operacion.opedd (CODIGOC, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('obtenerNroTelefRequest', 'Tipo de Proceso Num Tel', 'tipo_proceso_num_tel', (select tipopedd from tipopedd where abrev='datos_param_sans'), 0);

insert into operacion.opedd (CODIGOC, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('SGA', 'Nombre de la Aplicacion', 'nombre_aplicacion', (select tipopedd from tipopedd where abrev='datos_param_sans'), 0);

insert into operacion.opedd (CODIGOC, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('000000000004005623', 'material', 'parametro_input', (select tipopedd from tipopedd where abrev='datos_param_sans'), 1);

insert into operacion.opedd (DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('nroSerie', 'parametro_input', (select tipopedd from tipopedd where abrev='datos_param_sans'), 2);

insert into operacion.opedd (CODIGOC, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('cambiarStatusRequest', 'Tipo de Proceso Cambiar Status', 'tipo_proceso_camb_status', (select tipopedd from tipopedd where abrev='datos_param_sans'), 0);

insert into operacion.opedd (CODIGOC, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('1', 'Status', 'status', (select tipopedd from tipopedd where abrev='datos_param_sans'), 0);

commit;