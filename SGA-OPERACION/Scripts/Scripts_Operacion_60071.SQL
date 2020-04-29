-- Insercion de Tipo

insert into tipopedd ( DESCRIPCION, ABREV)
values ('TEL-SOFTSWITCH', 'SOFTSWITCH');
commit;

-- Insercion de Estados

insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ( 'nortel', 820, 'CmsCrmId', 'NORTEL', ( select tipopedd from tipopedd where abrev =  'SOFTSWITCH'), 1);

insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ( 'mta', 820, 'ispMTACrmId', 'NORTEL', ( select tipopedd from tipopedd where abrev =  'SOFTSWITCH'), 1);

insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ( 'IMS Huawei', 820, 'CmsCrmId', 'IMS Huawei', ( select tipopedd from tipopedd where abrev =  'SOFTSWITCH'), 2);

insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ( 'mta-ims', 820, 'ispMTACrmId', 'IMS Huawei', ( select tipopedd from tipopedd where abrev =  'SOFTSWITCH'), 2);

insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ( 'nortel', 824, 'CmsCrmId', 'NORTEL', ( select tipopedd from tipopedd where abrev =  'SOFTSWITCH'), 1);

insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ( 'IMS Huawei', 824, 'CmsCrmId', 'IMS Huawei', ( select tipopedd from tipopedd where abrev =  'SOFTSWITCH'), 2);

commit;

-- Inserccion de Constante para SSW
insert into operacion.constante (CONSTANTE, DESCRIPCION, TIPO, VALOR)
values ('SOFTSWITCH', 'Constante para SSW de Portabilidad', 'C','IMS Huawei');
commit;