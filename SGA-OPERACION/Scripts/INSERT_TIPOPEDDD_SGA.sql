
insert into operacion.tipopedd (TIPOPEDD, DESCRIPCION, ABREV)
values ((select max(TIPOPEDD) +1 from operacion.tipopedd), 'Controles de Reserva', 'IPC_CTRL');

COMMIT;


