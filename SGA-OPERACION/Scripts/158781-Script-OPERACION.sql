-----Creacion de cabecera

insert into OPERACION.TIPOPEDD (DESCRIPCION, ABREV)
values ('Tipos de CPE', 'CPE');
commit;

-----creacion de detalle


insert into OPERACION.OPEDD ( CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ( 1, 'cpe', null, ( SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'CPE') , null);
commit;
insert into OPERACION.OPEDD ( CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ( 2, 'cpe-pyme', null, ( SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'CPE') , null);
commit;
