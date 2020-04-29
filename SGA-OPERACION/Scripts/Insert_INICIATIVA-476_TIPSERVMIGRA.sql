insert into tipopedd (DESCRIPCION, ABREV)
values ('Nombre TipoServ Migracion ', 'TIPSERVMIGRA');
insert into opedd (CODIGOC, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('0004', 'Telefonía', '0004', 
(SELECT tipopedd FROM tipopedd where ABREV = 'TIPSERVMIGRA'));

insert into opedd (CODIGOC, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('0006', 'Internet', '0006', 
(SELECT tipopedd FROM tipopedd where ABREV = 'TIPSERVMIGRA'));

insert into opedd (CODIGOC, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('0062', 'Cable', '0062', 
(SELECT tipopedd FROM tipopedd where ABREV = 'TIPSERVMIGRA'));

insert into tipopedd (DESCRIPCION, ABREV)
values ('Tipo Equipo por Servicio ', 'TIPEQUSERV');


insert into opedd (CODIGOC, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('0004', 'EMTA', '0004', 
(SELECT tipopedd FROM tipopedd where ABREV = 'TIPEQUSERV'));
insert into opedd (CODIGOC, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('0004', 'TELMEX - TPE', '0004', 
(SELECT tipopedd FROM tipopedd where ABREV = 'TIPEQUSERV'));
insert into opedd (CODIGOC, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('0004', 'TARJETAS INTERFACES', '0004', 
(SELECT tipopedd FROM tipopedd where ABREV = 'TIPEQUSERV'));
insert into opedd (CODIGOC, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('0004', 'TELEFONO', '0004', 
(SELECT tipopedd FROM tipopedd where ABREV = 'TIPEQUSERV'));


insert into opedd (CODIGOC, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('0006', 'ROUTER', '0006', 
(SELECT tipopedd FROM tipopedd where ABREV = 'TIPEQUSERV'));

insert into opedd (CODIGOC, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('0062', 'ANTENA', '0062', 
(SELECT tipopedd FROM tipopedd where ABREV = 'TIPEQUSERV'));

insert into opedd (CODIGOC, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('0062', 'CONTROL REMOTO', '0062', 
(SELECT tipopedd FROM tipopedd where ABREV = 'TIPEQUSERV'));

insert into opedd (CODIGOC, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('0062', 'CABLES SERIALES', '0062', 
(SELECT tipopedd FROM tipopedd where ABREV = 'TIPEQUSERV'));

insert into opedd (CODIGOC, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('0062', 'DECODIFICADOR', '0062', 
(SELECT tipopedd FROM tipopedd where ABREV = 'TIPEQUSERV'));

insert into opedd (CODIGOC, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('0062', 'SMART CARD', '0062', 
(SELECT tipopedd FROM tipopedd where ABREV = 'TIPEQUSERV'));

commit;

