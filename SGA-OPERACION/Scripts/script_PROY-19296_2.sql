insert into operacion.tipopedd (TIPOPEDD, DESCRIPCION, ABREV)
values ((select max (TIPOPEDD)+1 from operacion.tipopedd) , 'RANGOS DE TIEMPO SLA', 'RANG_TEMP_SLA');

insert into operacion.opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select max (IDOPEDD)+1 from operacion.opedd), null, null, '0 - 4 hrs.', 'RANGO_1', 
(select TIPOPEDD from operacion.tipopedd where ABREV= 'RANG_TEMP_SLA' ), null);


insert into operacion.opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select max (IDOPEDD)+1 from operacion.opedd), null, null, '4 - 8 hrs.', 'RANGO_2',
(select TIPOPEDD from operacion.tipopedd where ABREV= 'RANG_TEMP_SLA' ) , null);

insert into operacion.opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select max (IDOPEDD)+1 from operacion.opedd), null, null, '8 - 24 hrs.', 'RANGO_3',
(select TIPOPEDD from operacion.tipopedd where ABREV= 'RANG_TEMP_SLA' ) , null);

insert into operacion.opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select max (IDOPEDD)+1 from operacion.opedd), null, null, '24 - 48 hrs.', 'RANGO_4', 
(select TIPOPEDD from operacion.tipopedd where ABREV= 'RANG_TEMP_SLA' ), null);

insert into operacion.opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select max (IDOPEDD)+1 from operacion.opedd), null, null, 'Mas de 48 hrs.', 'RANGO_5', 
(select TIPOPEDD from operacion.tipopedd where ABREV= 'RANG_TEMP_SLA' ) , null);

commit;
