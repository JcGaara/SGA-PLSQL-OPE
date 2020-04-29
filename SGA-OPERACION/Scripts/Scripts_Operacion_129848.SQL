-- Insercion de Tipo

insert into tipopedd ( DESCRIPCION, ABREV)
values ('CONFIGURACION IMS', 'CONF_IMS');
commit;

-- Insercion de Estados

insert into opedd ( CODIGOC, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ( '0004', 'Telefonia Fija', 'TIPSRV_IMS', ( select tipopedd from tipopedd where abrev =  'CONF_IMS'));

insert into opedd ( CODIGOC, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ( '0059', 'Telefonía Pública de Interior', 'TIPSRV_IMS', ( select tipopedd from tipopedd where abrev =  'CONF_IMS'));
commit;
