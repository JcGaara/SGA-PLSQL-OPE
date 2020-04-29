-- Insert Into Tipopedd 
insert into tipopedd (DESCRIPCION, ABREV)
values ('CONF. ENVIO MAIL GENERICO', 'CONF_EMAIL_GENE');

-- Insert Into Opedd 
insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('ASUNTO', 1, 'Actualizaci�n de c�digo gen�rico', 'CASUNTO', (select tipopedd from tipopedd where abrev='CONF_EMAIL_GENE'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('CUERPO', 2, 'Actualizaci�n de c�digo gen�rico', 'CCUERPO', (select tipopedd from tipopedd where abrev='CONF_EMAIL_GENE'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('LISTA CORREOS', 3, 'dlpefactibilidadpext@claro.com.pe', 'LISTMAIL', (select tipopedd from tipopedd where abrev='CONF_EMAIL_GENE'), null);

commit;
/
