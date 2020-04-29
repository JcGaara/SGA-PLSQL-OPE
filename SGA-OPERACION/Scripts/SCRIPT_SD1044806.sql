insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select max(IDOPEDD) + 1 from opedd), '1',NULL, 'PROC_FALLA', 'P_VAL_NUMTLF_TRAS',
(select MAX(tipopedd) from tipopedd where upper(abrev)='TRANS_BILL'), 80);

insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select max(IDOPEDD) + 1 from opedd), '1',NULL, 'PROC_FALLA', 'P_VAL_NUMTLF_TRAS',
(select MAX(tipopedd) from tipopedd where upper(abrev)='TRANS_BILL'), 341);

insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select max(IDOPEDD) + 1 from opedd), '1',NULL, 'PROC_FALLA', 'P_VAL_NUMTLF_TRAS',
(select MAX(tipopedd) from tipopedd where upper(abrev)='TRANS_BILL'), 346);

insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select max(IDOPEDD) + 1 from opedd), '1',NULL, 'PROC_FALLA', 'P_VAL_NUMTLF_TRAS',
(select MAX(tipopedd) from tipopedd where upper(abrev)='TRANS_BILL'), 390);

insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select max(IDOPEDD) + 1 from opedd), '1',NULL, 'PROC_FALLA', 'P_VAL_NUMTLF_TRAS',
(select MAX(tipopedd) from tipopedd where upper(abrev)='TRANS_BILL'), 393);

insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select max(IDOPEDD) + 1 from opedd), '1',NULL, 'PROC_FALLA', 'P_VAL_NUMTLF_TRAS',
(select MAX(tipopedd) from tipopedd where upper(abrev)='TRANS_BILL'), 412);

insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select max(IDOPEDD) + 1 from opedd), '1',NULL, 'PROC_FALLA', 'P_VAL_NUMTLF_TRAS',
(select MAX(tipopedd) from tipopedd where upper(abrev)='TRANS_BILL'), 420);

insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select max(IDOPEDD) + 1 from opedd), '1',NULL, 'PROC_FALLA', 'P_VAL_NUMTLF_TRAS',
(select MAX(tipopedd) from tipopedd where upper(abrev)='TRANS_BILL'), 1);

commit;
/