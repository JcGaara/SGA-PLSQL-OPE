
insert into tipopedd ( DESCRIPCION)
values ('BAM-Config  TIPACCIONPV');
commit;


insert into opedd (CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ( 3, 'Reconexion', 'CONF_TIPACT', ( select tipopedd from tipopedd where descripcion ='BAM-Config  TIPACCIONPV'), 2);

insert into opedd (CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ( 4, 'Suspension', 'CONF_TIPACT', ( select tipopedd from tipopedd where descripcion ='BAM-Config  TIPACCIONPV'), 1);

insert into opedd (CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ( 5, 'Cancelacion', 'CONF_TIPACT', ( select tipopedd from tipopedd where descripcion ='BAM-Config  TIPACCIONPV'), 5);

insert into opedd (CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ( 10, 'Corte', 'CONF_TIPACT', ( select tipopedd from tipopedd where descripcion ='BAM-Config  TIPACCIONPV'), 3);

commit;


insert into tipopedd ( DESCRIPCION)
values ('BAM-Config  IDTRANCORTE');
commit;


insert into opedd (CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ( 3, 'Reconexion', 'CONF_CORTE', ( select tipopedd from tipopedd where descripcion ='BAM-Config  IDTRANCORTE'), 6);

insert into opedd (CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ( 4, 'Suspension', 'CONF_CORTE', ( select tipopedd from tipopedd where descripcion ='BAM-Config  IDTRANCORTE'), 2);

insert into opedd (CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ( 5, 'Cancelacion', 'CONF_CORTE', ( select tipopedd from tipopedd where descripcion ='BAM-Config  IDTRANCORTE'), 4);

insert into opedd (CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ( 10, 'Corte', 'CONF_CORTE', ( select tipopedd from tipopedd where descripcion ='BAM-Config  IDTRANCORTE'), 3);

commit;