
insert into operacion.opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select max(idopedd) +1 from operacion.opedd), null, 1, 'Controlar que no exista una cancelación de agenda asociada a una reserva en SGA y TOA', 'Ctrl_Cancelacion',  (SELECT A.TIPOPEDD FROM operacion.tipopedd A WHERE UPPER(ABREV) ='IPC_CTRL'), null);

insert into operacion.opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select max(idopedd) +1 from operacion.opedd), null, 2, 'Controlar que no exista una agenda con mas de una orden en TOA (reserva)', 'CTRL_DUP_TOA',  (SELECT A.TIPOPEDD FROM operacion.tipopedd A WHERE UPPER(ABREV) ='IPC_CTRL'), null);

insert into operacion.opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select max(idopedd) +1 from operacion.opedd), null, 3, 'Detectar las altas HFC y FTTH que cuenten con la misma orden (reserva)  en SGA y TOA', 'CTRL_DUP_RESERVA',  (SELECT A.TIPOPEDD FROM operacion.tipopedd A WHERE UPPER(ABREV) ='IPC_CTRL'), null);

COMMIT;
