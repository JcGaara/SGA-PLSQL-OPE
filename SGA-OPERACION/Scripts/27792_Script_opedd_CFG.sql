insert into operacion.tipopedd (DESCRIPCION, ABREV)
values ('Config. Siacunico Motivo', 'CFG_SU_MTV');

insert into operacion.opedd (CODIGOC,CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('LTE',783, 'WLL/SIAC - CANCELACION DE SERVICIO', 'TIPTRA', (select tipopedd from operacion.tipopedd where abrev='CFG_SU_MTV'));
insert into operacion.opedd (CODIGOC,CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('HFC',729, 'HFC/SIAC - BAJA ADMINISTRATIVA', 'TIPTRA', (select tipopedd from operacion.tipopedd where abrev='CFG_SU_MTV'));
insert into operacion.opedd (CODIGOC,CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('HFC',728, 'HFC/SIAC - BAJA TOTAL DEL SERVICIO', 'TIPTRA', (select tipopedd from operacion.tipopedd where abrev='CFG_SU_MTV'));

insert into operacion.opedd (CODIGOC, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('270107', 'SubClase HFC', 'SUB_CLASE', (select tipopedd from operacion.tipopedd where abrev='CFG_SU_MTV'));

insert into operacion.opedd (CODIGOC, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('300405', 'SubClase LTE', 'SUB_CLASE', (select tipopedd from operacion.tipopedd where abrev='CFG_SU_MTV'));

commit;