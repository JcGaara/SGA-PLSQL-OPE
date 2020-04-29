--- Configuraciones de Ip fase 2

insert into tipopedd ( DESCRIPCION, ABREV)
values ( 'IW-Config Servicios', 'SRV_IP');

insert into tipopedd (DESCRIPCION, ABREV)
values ('IW-Config Permisos', 'PER_IP');

insert into tipopedd (DESCRIPCION, ABREV)
values ('IW-Config Numeros IPs', 'NUM_IP');

insert into tipopedd (DESCRIPCION, ABREV)
values ('IW-Config  eMTA', 'EQU_EMTA');

commit;


insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values  ('857', 9051, 'Pull de 4 IPs Fijas Adicionales CE en HFC', 'SRV_IP', ( select tipopedd from tipopedd where abrev in ('SRV_IP')), null);

commit;



insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('1', null, 'EASTULLE', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('2', null, 'E812181', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('3', null, 'E816827', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('4', null, 'E816828', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('5', null, 'E811857', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('6', null, 'E816668 ', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('7', null, 'E808118 ', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('8', null, 'E814161', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('9', null, 'E804873', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('10', null, 'E812771', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('11', null, 'E818365', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('12', null, 'E807400', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('13', null, 'E804808', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('14', null, 'E817460', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('15', null, 'E807405', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('16', null, 'E819551', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('17', null, 'E818838', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('18', null, 'E812222', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('19', null, 'E819559', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('20', null, 'E816513', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('21', null, 'E815396', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('22', null, 'E816608', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('23', null, 'E812778', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('24', null, 'E819552', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('25', null, 'E807407 ', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('26', null, 'E818836', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('27', null, 'E807408', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('28', null, 'E804874', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('29', null, 'E807442', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('30', null, 'E820298', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('31', null, 'E806308', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('32', null, 'E806309', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('33', null, 'E806291', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('34', null, 'E814834', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('35', null, 'E814845', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('36', null, 'E814838', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('37', null, 'E815248', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('38', null, 'E817314', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('39', null, 'E817315', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('40', null, 'E802702', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('41', null, 'E817568', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('42', null, 'E817558', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('43', null, 'E818444', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('44', null, 'E818440', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('45', null, 'E818438', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('53', null, 'E805094', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('46', null, 'E818946', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('47', null, 'E818945', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('48', null, 'E818936', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('49', null, 'E819842', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('50', null, 'E819844', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('51', null, 'E805871', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('52', null, 'E817461', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('54', null, 'E816512', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('55', null, 'E818075', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('56', null, 'E814666', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('57', null, 'E818074', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('58', null, 'E820188', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('59', null, 'E813925', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('60', null, 'E818976', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('61', null, 'E805098', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('62', null, 'E817458', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('63', null, 'E816829', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('64', null, 'E818834', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('65', null, 'E818835', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('66', null, 'E814160', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('67', null, 'E814667', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('68', null, 'E820112', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('69', null, 'E820120', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('70', null, 'E804957', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('71', null, 'E804006', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('72', null, 'E813622', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('73', null, 'E810590', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('74', null, 'E813048', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('75', null, 'JMIRALLES', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('76', null, 'T14200', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('77', null, 'T14153', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('78', null, 'KAVILA', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('79', null, 'E76560', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('80', null, 'E76582', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('81', null, 'E76585', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('82', null, 'E77253', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('83', null, 'E77328', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('84', null, 'E77329', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('85', null, 'E77330', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('86', null, 'E77614', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('87', null, 'E77615', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('88', null, 'E77808', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('89', null, 'E77809', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('90', null, 'E78111', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('91', null, 'E8806002', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('92', null, 'E8806003', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('93', null, 'T14332', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('94', null, 'T14333', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('95', null, 'T14335', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('96', null, 'T14337', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('97', null, 'T14338', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('98', null, 'T14343', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('99', null, 'T14348', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('100', null, 'T14355', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('101', null, 'T14731', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('102', null, 'T14733', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('103', null, 'T16185', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('104', null, 'T16393', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('105', null, 'JPACHECO', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('106', null, 'T16429', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('107', null, 'RTORRES', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('108', null, 'T15240', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('109', null, 'IVILLAVERDE', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('110', null, 'ACHAGUA', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('111', null, 'PPENALOZA', 'PER_IP',  ( select tipopedd from tipopedd where abrev in ('PER_IP')), null);

commit;

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null, 1, 'Numero  de IP', 'NUM_IP', ( select tipopedd from tipopedd where abrev in ('NUM_IP')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null, 4, 'Numero  de IP', 'NUM_IP', ( select tipopedd from tipopedd where abrev in ('NUM_IP')), null);

commit;

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null, 1, 'ARRIS_TM602G', 'EQU_EMTA', ( select tipopedd from tipopedd where abrev in ('EQU_EMTA')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null, 2, 'ARRIS_TM608G', 'EQU_EMTA', ( select tipopedd from tipopedd where abrev in ('EQU_EMTA')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null, 3, 'CISCO_DPC2425R2', 'EQU_EMTA', ( select tipopedd from tipopedd where abrev in ('EQU_EMTA')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null, 4, 'MOTOROLA_SBV5322', 'EQU_EMTA', ( select tipopedd from tipopedd where abrev in ('EQU_EMTA')), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null, 5, 'UBEE_U10C022', 'EQU_EMTA', ( select tipopedd from tipopedd where abrev in ('EQU_EMTA')), null);


commit;
/