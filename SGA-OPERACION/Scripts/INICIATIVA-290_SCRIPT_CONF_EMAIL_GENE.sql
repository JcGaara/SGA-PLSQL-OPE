-- Insert Into Tipopedd 
insert into tipopedd (DESCRIPCION, ABREV)
values ('CONF. ENVIO MAIL GENERICO', 'CONF_EMAIL_GENE');

-- Insert Into Opedd 
insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('ASUNTO', 1, 'Actualización de código genérico', 'CASUNTO', (select tipopedd from tipopedd where abrev='CONF_EMAIL_GENE'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('CUERPO', 2, 'Actualización de código genérico', 'CCUERPO', (select tipopedd from tipopedd where abrev='CONF_EMAIL_GENE'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('LISTA CORREOS', 3, 'dlpefactibilidadpext@claro.com.pe', 'LISTMAIL', (select tipopedd from tipopedd where abrev='CONF_EMAIL_GENE'), null);

commit;
/
