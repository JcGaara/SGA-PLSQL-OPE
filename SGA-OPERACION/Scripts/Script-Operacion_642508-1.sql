/*Creamos el nuevo parametro*/

insert into tipopedd ( DESCRIPCION, ABREV)
values ('PROYECTO RESERVA IW', 'PROY_R_IW');

insert into opedd ( CODIGON, DESCRIPCION, TIPOPEDD)
values ( 728, 'CAMBIO DE PLAN',( select tipopedd from tipopedd where abrev = 'PROY_R_IW' ));
commit;
/