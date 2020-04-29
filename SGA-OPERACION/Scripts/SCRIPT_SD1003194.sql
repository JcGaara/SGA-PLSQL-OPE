create index SALES.IDX_VTADETPTOENL_214 on SALES.VTADETPTOENL (PID_OLD)
  tablespace SALES_DAT
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
--------------------------------------------------------------------------------------------------------
insert into tipopedd (TIPOPEDD, DESCRIPCION, ABREV)
values ((select max(TIPOPEDD) + 1 from tipopedd), 'TRANSFER BILLING', 'TRANS_BILL');
        
insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select max(IDOPEDD) + 1 from opedd), NULL,2, 'UPGRADE', 'TIPTRA_SOT',
(select MAX(tipopedd) from tipopedd where upper(abrev)='TRANS_BILL'), null);
        
insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select max(IDOPEDD) + 1 from opedd), NULL,11, 'DOWNGRADE', 'TIPTRA_SOT',
(select MAX(tipopedd) from tipopedd where upper(abrev)='TRANS_BILL'), null);

insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select max(IDOPEDD) + 1 from opedd), NULL,80, 'DOWNGRADE', 'TIPTRA_SOT',
(select MAX(tipopedd) from tipopedd where upper(abrev)='TRANS_BILL'), null);

--------------------------------------------------------------------------------------------------------
insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select max(IDOPEDD) + 1 from opedd), NULL,17, 'En Ejecución', 'ESTSOL_SOT',
(select MAX(tipopedd) from tipopedd where upper(abrev)='TRANS_BILL'), null);

--------------------------------------------------------------------------------------------------------
insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select max(IDOPEDD) + 1 from opedd), '0006',NULL, 'Acceso Dedicado a Internet', 'TIPSRV_SOT',
(select MAX(tipopedd) from tipopedd where upper(abrev)='TRANS_BILL'), null);

insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select max(IDOPEDD) + 1 from opedd), '0004',NULL, 'Telefonia Fija', 'TIPSRV_SOT',
(select MAX(tipopedd) from tipopedd where upper(abrev)='TRANS_BILL'), null);

insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select max(IDOPEDD) + 1 from opedd), '0001',NULL, 'Larga Distancia Internacional', 'TIPSRV_SOT',
(select MAX(tipopedd) from tipopedd where upper(abrev)='TRANS_BILL'), null);

insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select max(IDOPEDD) + 1 from opedd), '0002',NULL, 'Larga Distancia Nacional', 'TIPSRV_SOT',
(select MAX(tipopedd) from tipopedd where upper(abrev)='TRANS_BILL'), null);

insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select max(IDOPEDD) + 1 from opedd), '0044',NULL, 'Servicio 0800', 'TIPSRV_SOT',
(select MAX(tipopedd) from tipopedd where upper(abrev)='TRANS_BILL'), null);

insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select max(IDOPEDD) + 1 from opedd), '0056',NULL, 'Servicio 0801', 'TIPSRV_SOT',
(select MAX(tipopedd) from tipopedd where upper(abrev)='TRANS_BILL'), null);

insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select max(IDOPEDD) + 1 from opedd), '0052',NULL, 'Red Privada Virtual Local', 'TIPSRV_SOT',
(select MAX(tipopedd) from tipopedd where upper(abrev)='TRANS_BILL'), null);

insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select max(IDOPEDD) + 1 from opedd), '0053',NULL, 'Red Privada Virtual Nacional', 'TIPSRV_SOT',
(select MAX(tipopedd) from tipopedd where upper(abrev)='TRANS_BILL'), null);

insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select max(IDOPEDD) + 1 from opedd), '0049',NULL, 'Red Privada Virtual Internacional', 'TIPSRV_SOT',
(select MAX(tipopedd) from tipopedd where upper(abrev)='TRANS_BILL'), null);

insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select max(IDOPEDD) + 1 from opedd), '0010',NULL, 'Alquiler de Equipos', 'TIPSRV_SOT',
(select MAX(tipopedd) from tipopedd where upper(abrev)='TRANS_BILL'), null);

insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select max(IDOPEDD) + 1 from opedd), '0094',NULL, 'Carrier Ethernet', 'TIPSRV_SOT',
(select MAX(tipopedd) from tipopedd where upper(abrev)='TRANS_BILL'), null);

insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select max(IDOPEDD) + 1 from opedd), '0014',NULL, 'Domestic IP Data', 'TIPSRV_SOT',
(select MAX(tipopedd) from tipopedd where upper(abrev)='TRANS_BILL'), null);

insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select max(IDOPEDD) + 1 from opedd), '0036',NULL, 'Local Private Lines', 'TIPSRV_SOT',
(select MAX(tipopedd) from tipopedd where upper(abrev)='TRANS_BILL'), null);

insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select max(IDOPEDD) + 1 from opedd), '0055',NULL, 'Servicios Administrados', 'TIPSRV_SOT',
(select MAX(tipopedd) from tipopedd where upper(abrev)='TRANS_BILL'), null);

insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select max(IDOPEDD) + 1 from opedd), '0088',NULL, 'Small Cell', 'TIPSRV_SOT',
(select MAX(tipopedd) from tipopedd where upper(abrev)='TRANS_BILL'), null);

insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select max(IDOPEDD) + 1 from opedd), '0074',NULL, 'Telefonia Fija Virtual', 'TIPSRV_SOT',
(select MAX(tipopedd) from tipopedd where upper(abrev)='TRANS_BILL'), null);

insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select max(IDOPEDD) + 1 from opedd), '0066',NULL, 'TVSAT', 'TIPSRV_SOT',
(select MAX(tipopedd) from tipopedd where upper(abrev)='TRANS_BILL'), null);
-------------------------------------------------------------------------------------------------------
insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select max(IDOPEDD) + 1 from opedd), '1',NULL, 'PROC_FALLA', 'P_INSERT_NUMSLC_ORI',
(select MAX(tipopedd) from tipopedd where upper(abrev)='TRANS_BILL'), null);
insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select max(IDOPEDD) + 1 from opedd), '1',NULL, 'PROC_FALLA', 'P_VAL_DOBLEREG_NUMSLC',
(select MAX(tipopedd) from tipopedd where upper(abrev)='TRANS_BILL'), null);
insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select max(IDOPEDD) + 1 from opedd), '1',NULL, 'PROC_FALLA', 'P_VAL_DOBLEREG_PID',
(select MAX(tipopedd) from tipopedd where upper(abrev)='TRANS_BILL'), null);
insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select max(IDOPEDD) + 1 from opedd), '1',NULL, 'PROC_FALLA', 'P_VAL_PIDOLD_UPDOWN',
(select MAX(tipopedd) from tipopedd where upper(abrev)='TRANS_BILL'), null);
insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select max(IDOPEDD) + 1 from opedd), '1',NULL, 'PROC_FALLA', 'T_SOLOT_BI',
(select MAX(tipopedd) from tipopedd where upper(abrev)='TRANS_BILL'), null);
insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select max(IDOPEDD) + 1 from opedd), '1',NULL, 'PROC_FALLA', 'P_WF_POS_ACTSRV',
(select MAX(tipopedd) from tipopedd where upper(abrev)='TRANS_BILL'), null);
insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select max(IDOPEDD) + 1 from opedd), '1',NULL, 'PROC_FALLA', 'P_GEN_SOLOT_TRASLADO_F',
(select MAX(tipopedd) from tipopedd where upper(abrev)='TRANS_BILL'), null);
insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select max(IDOPEDD) + 1 from opedd), '1',NULL, 'PROC_FALLA', 'P_EXE_INT_PRYOPE',
(select MAX(tipopedd) from tipopedd where upper(abrev)='TRANS_BILL'), null);
insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select max(IDOPEDD) + 1 from opedd), '1',NULL, 'PROC_FALLA', 'W_MNT_ESTUDIO_FACTIBILIDAD',
(select MAX(tipopedd) from tipopedd where upper(abrev)='TRANS_BILL'), null);
insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select max(IDOPEDD) + 1 from opedd), '1',NULL, 'PROC_FALLA', 'P_VAL_NUMTLF_TRAS',
(select MAX(tipopedd) from tipopedd where upper(abrev)='TRANS_BILL'), null);

/

