insert into tipopedd ( DESCRIPCION, ABREV)
values ( 'PORTABILIDAD NUMERICA', 'PORTABILIDAD_SERVICIOS');
COMMIT;
insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('0004', 501, 'PRIMARIO', 'PRIMARIO',(Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_SERVICIOS')  , 1);
insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('0004', 503, 'ANALOGICO', 'ANALOGICO',(Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_SERVICIOS')  , 1);
COMMIT;