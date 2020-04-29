

insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('0004', null, 'TELEFONIA FIJA', 'FIJA_Y_ESPECIAL',(Select tipopedd from tipopedd where abrev= 'PORTABILIDAD')  , null);

insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ( '0056', null, 'SERVICIO 0801', 'FIJA_Y_ESPECIAL', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD'), null);

insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ( '0044', null, 'SERVICIO 0800', 'FIJA_Y_ESPECIAL',(Select tipopedd from tipopedd where abrev= 'PORTABILIDAD'), null);

COMMIT;