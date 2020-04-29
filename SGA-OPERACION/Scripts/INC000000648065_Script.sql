ALTER TABLE SALES.VTADETPTOENL ADD IDCUENTA NUMBER;
alter table SALES.REG_CONCILIACION_FALLIDA modify datan_idconciliacion_fallida NUMBER;
--------------------------------------------------------------------------------------------------------
insert into tipopedd (TIPOPEDD, DESCRIPCION, ABREV)
values ((select max(TIPOPEDD) + 1 from tipopedd), 'SWITCH CLOUD', 'CLOUD');
--------------------------------------------------------------------------------------------------------
insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select max(IDOPEDD) + 1 from opedd), null ,1, null, 'SWITCH',
(select MAX(tipopedd) from tipopedd where upper(abrev)='CLOUD'), null);

insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select max(IDOPEDD) + 1 from opedd), null ,0, null, 'BTN_ELIMINAR',
(select MAX(tipopedd) from tipopedd where upper(abrev)='CLOUD'), null);

insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select max(IDOPEDD) + 1 from opedd), null ,0, null, 'BTN_CREAR',
(select MAX(tipopedd) from tipopedd where upper(abrev)='CLOUD'), null);
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
insert into tipopedd (TIPOPEDD, DESCRIPCION, ABREV)
values ((select max(TIPOPEDD) + 1 from tipopedd), 'ASOCIA GRUPOS', 'MSJ_SGA');
--------------------------------------------------------------------------------------------------------
insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select max(IDOPEDD) + 1 from opedd), 'SEF',1, 'Ingresar registros de Servicios', 'MSJ',
(select MAX(tipopedd) from tipopedd where upper(abrev)='MSJ_SGA'), null);
        
insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select max(IDOPEDD) + 1 from opedd), 'SEF',2, 'Debe de Guardar sus cambios', 'MSJ',
(select MAX(tipopedd) from tipopedd where upper(abrev)='MSJ_SGA'), null);

insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select max(IDOPEDD) + 1 from opedd), 'SEF',3, 'Debe generar Proyecto', 'MSJ',
(select MAX(tipopedd) from tipopedd where upper(abrev)='MSJ_SGA'), null);

insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select max(IDOPEDD) + 1 from opedd), 'SEF',4, 'Seleccione una Fila', 'MSJ',
(select MAX(tipopedd) from tipopedd where upper(abrev)='MSJ_SGA'), null);

insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select max(IDOPEDD) + 1 from opedd), 'SEF',1, 'Estudio de Factibilidad', 'TITLE',
(select MAX(tipopedd) from tipopedd where upper(abrev)='MSJ_SGA'), null);

insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select max(IDOPEDD) + 1 from opedd), 'SEF',2, 'Seleccion de Sucursal', 'TITLE',
(select MAX(tipopedd) from tipopedd where upper(abrev)='MSJ_SGA'), null);
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
insert into tipopedd (TIPOPEDD, DESCRIPCION, ABREV)
values ((select max(TIPOPEDD) + 1 from tipopedd), 'ASOCIA GRUPOS', 'ASOC_GRUP');
--------------------------------------------------------------------------------------------------------
insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select max(IDOPEDD) + 1 from opedd), null ,1, null, 'IDTIPFAC',
(select MAX(tipopedd) from tipopedd where upper(abrev)='ASOC_GRUP'), null);

insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select max(IDOPEDD) + 1 from opedd), null ,39, null, 'CICFAC',
(select MAX(tipopedd) from tipopedd where upper(abrev)='ASOC_GRUP'), null);
--------------------------------------------------------------------------------------------------------

commit;

/
