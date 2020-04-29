-- Configuraciones

---Instalaciones

insert into operacion.tipopedd ( DESCRIPCION, ABREV)
values ('CONFIGURACION SGA JANUS', 'CONFIG_A_SGA_JANUS');
commit;


insert into operacion.tipopedd ( DESCRIPCION, ABREV)
values ('CONFIGURACION SGA JANUS', 'CONFIG_B_SGA_JANUS');
commit;



insert into operacion.opedd ( CODIGOC, DESCRIPCION, TIPOPEDD)
values ( 'CP', 'CAMBIO DE PLAN',( select tipopedd from operacion.tipopedd where abrev = 'CONFIG_A_SGA_JANUS' ));

insert into operacion.opedd ( CODIGOC, DESCRIPCION, TIPOPEDD)
values ( 'FI', 'FIDELIZACION',( select tipopedd from operacion.tipopedd where abrev = 'CONFIG_A_SGA_JANUS' ));

insert into operacion.opedd ( CODIGOC, DESCRIPCION, TIPOPEDD)
values ( 'CR', 'CAMBIO RECAUDACION',( select tipopedd from operacion.tipopedd where abrev = 'CONFIG_A_SGA_JANUS' ));
commit;



insert into operacion.opedd ( CODIGOC, DESCRIPCION, TIPOPEDD)
values ( 'TE', 'TRASLADO EXTERNO',( select tipopedd from operacion.tipopedd where abrev = 'CONFIG_B_SGA_JANUS' ));

insert into operacion.opedd ( CODIGOC, DESCRIPCION, TIPOPEDD)
values ( 'TI', 'TRASLADO INTERNO',( select tipopedd from operacion.tipopedd where abrev = 'CONFIG_B_SGA_JANUS' ));

insert into operacion.opedd ( CODIGOC, DESCRIPCION, TIPOPEDD)
values ( 'RE', 'RENOVACION',( select tipopedd from operacion.tipopedd where abrev = 'CONFIG_B_SGA_JANUS' ));

insert into operacion.opedd ( CODIGOC, DESCRIPCION, TIPOPEDD)
values ( 'TIR', 'TRASLADO INTERNO Y RENOVACIÓN',( select tipopedd from operacion.tipopedd where abrev = 'CONFIG_B_SGA_JANUS' ));

insert into operacion.opedd ( CODIGOC, DESCRIPCION, TIPOPEDD)
values ( 'TER', 'TRASLADO EXTERNO Y RENOVACIÓN',( select tipopedd from operacion.tipopedd where abrev = 'CONFIG_B_SGA_JANUS' ));

insert into operacion.opedd ( CODIGOC, DESCRIPCION, TIPOPEDD)
values ( 'UDG', 'UPGRADE/DOWNGRADE',( select tipopedd from operacion.tipopedd where abrev = 'CONFIG_B_SGA_JANUS' ));

insert into operacion.opedd ( CODIGOC, DESCRIPCION, TIPOPEDD)
values ( 'TIT', 'CAMBIO TITULARIDAD',( select tipopedd from operacion.tipopedd where abrev = 'CONFIG_B_SGA_JANUS' ));

insert into operacion.opedd ( CODIGOC, DESCRIPCION, TIPOPEDD)
values ( 'CN', 'CAMBIO NUMERO',( select tipopedd from operacion.tipopedd where abrev = 'CONFIG_B_SGA_JANUS' ));

insert into operacion.opedd ( CODIGOC, DESCRIPCION, TIPOPEDD)
values ( 'FAST', 'CONFIGURACIÓN FAST TRACK',( select tipopedd from operacion.tipopedd where abrev = 'CONFIG_B_SGA_JANUS' ));


---Instalacion de Configuraciones: 
insert into operacion.tipopedd ( DESCRIPCION, ABREV)
values ('Conf. Serv. SGA-Intraway', 'CONFIG-SGA-IW');

insert into operacion.opedd ( CODIGOC, DESCRIPCION, TIPOPEDD)
values ( '0061', 'Paquetes Masivos',( select tipopedd from operacion.tipopedd where abrev = 'CONFIG-SGA-IW' ));
insert into operacion.opedd ( CODIGOC, DESCRIPCION, TIPOPEDD)
values ( '0073', 'Paquetes Pymes en HFC',( select tipopedd from operacion.tipopedd where abrev = 'CONFIG-SGA-IW' ));
commit;

/



     