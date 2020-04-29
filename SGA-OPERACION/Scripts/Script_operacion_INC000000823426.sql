insert into tipopedd (DESCRIPCION, ABREV)
values ('Caracteres especiales en trama', 'CARACT_ESPEC_TRAMA');

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('|', null, 'Caracter Especial', 'caract_espec', (select t.tipopedd from tipopedd t where t.abrev = 'CARACT_ESPEC_TRAMA'), 1);
insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('<', null, 'Caracter Especial', 'caract_espec', (select t.tipopedd from tipopedd t where t.abrev = 'CARACT_ESPEC_TRAMA'), 1);
insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('>', null, 'Caracter Especial', 'caract_espec', (select t.tipopedd from tipopedd t where t.abrev = 'CARACT_ESPEC_TRAMA'), 1);
insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('¡', null, 'Caracter Especial', 'caract_espec', (select t.tipopedd from tipopedd t where t.abrev = 'CARACT_ESPEC_TRAMA'), 1);
insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('!', null, 'Caracter Especial', 'caract_espec', (select t.tipopedd from tipopedd t where t.abrev = 'CARACT_ESPEC_TRAMA'), 1);

COMMIT;