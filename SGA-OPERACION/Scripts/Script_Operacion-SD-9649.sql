insert into tipopedd (ABREV)
values ('GC_CONF_PARA_CIERRE');
commit;


insert into opedd (CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ( 10, 'CABLE ANALOGICO', 'GC_CONF_PARA_CIERRE', ( select tipopedd from tipopedd where ABREV ='GC_CONF_PARA_CIERRE'));       
insert into opedd (CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ( 11, 'SINGLE PLAY ANALOGICO', 'GC_CONF_PARA_CIERRE', ( select tipopedd from tipopedd where ABREV ='GC_CONF_PARA_CIERRE'));       
insert into opedd (CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ( 19, 'CE en HFC', 'GC_CONF_PARA_CIERRE', ( select tipopedd from tipopedd where ABREV ='GC_CONF_PARA_CIERRE'));       
insert into opedd (CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ( 20, 'HFC - Cable', 'GC_CONF_PARA_CIERRE', ( select tipopedd from tipopedd where ABREV ='GC_CONF_PARA_CIERRE'));       
insert into opedd (CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ( 21, 'HFC - Internet', 'GC_CONF_PARA_CIERRE', ( select tipopedd from tipopedd where ABREV ='GC_CONF_PARA_CIERRE'));       
insert into opedd (CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ( 22, 'HFC - Telefonia', 'GC_CONF_PARA_CIERRE', ( select tipopedd from tipopedd where ABREV ='GC_CONF_PARA_CIERRE'));       
insert into opedd (CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ( 23, 'HFC - Cable + Telefonia', 'GC_CONF_PARA_CIERRE', ( select tipopedd from tipopedd where ABREV ='GC_CONF_PARA_CIERRE'));       
insert into opedd (CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ( 24, 'HFC - Telefonia + Internet', 'GC_CONF_PARA_CIERRE', ( select tipopedd from tipopedd where ABREV ='GC_CONF_PARA_CIERRE'));       
insert into opedd (CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ( 25, 'HFC - Cable + Internet', 'GC_CONF_PARA_CIERRE', ( select tipopedd from tipopedd where ABREV ='GC_CONF_PARA_CIERRE'));       
insert into opedd (CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ( 26, 'HFC - Cable + Internet + Telefonia', 'GC_CONF_PARA_CIERRE', ( select tipopedd from tipopedd where ABREV ='GC_CONF_PARA_CIERRE'));       
commit;