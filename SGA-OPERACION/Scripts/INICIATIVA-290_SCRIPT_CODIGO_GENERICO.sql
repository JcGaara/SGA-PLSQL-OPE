-- Insert Into Tipopedd 
insert into tipopedd (DESCRIPCION, ABREV)
values ('Lista de codigos genericos', 'CODIGOS_GENERICOS');

-- Insert Into Opedd 
insert into opedd (CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ( 14929, 'Código Genérico', 'EGENERIC', (select tipopedd from tipopedd where abrev='CODIGOS_GENERICOS'), null);

commit;
/
