------------ cabecera
insert into tipopedd (TIPOPEDD, DESCRIPCION, ABREV)
values (NULL, 'INSTALACION DE DECO ADICIONAL', 'DECO_ADICIONAL');
------------ detalle
insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (NULL, '', 923, 'IDPRODUCTO CABLE SISACT', 'IDPROD_SISACT', (select t.tipopedd from tipopedd t where t.abrev = 'DECO_ADICIONAL'), null);

insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (NULL, '001', null, 'GRUPO SERVICIO PRINCIPALES', 'GRUP_SERV_PRIN', (select t.tipopedd from tipopedd t where t.abrev = 'DECO_ADICIONAL'), null);

insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (NULL, '', 0, 'CREAR SERVICIO DE INSTALACION', 'CREAR_INSTALACION', (select t.tipopedd from tipopedd t where t.abrev = 'DECO_ADICIONAL'), null);

insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (NULL, '005', null, 'GRUPO SERVICIO ADICIONALES', 'GRUP_SERV_ADIC', (select t.tipopedd from tipopedd t where t.abrev = 'DECO_ADICIONAL'), null);

insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (NULL, '002', null, 'GRUPO SERVICIO PRINCIPALES', 'GRUP_SERV_PRIN', (select t.tipopedd from tipopedd t where t.abrev = 'DECO_ADICIONAL'), null);

insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (NULL, '003', null, 'GRUPO SERVICIO PRINCIPALES', 'GRUP_SERV_PRIN', (select t.tipopedd from tipopedd t where t.abrev = 'DECO_ADICIONAL'), null);

insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (NULL, '004', null, 'GRUPO SERVICIO PRINCIPALES', 'GRUP_SERV_PRIN', (select t.tipopedd from tipopedd t where t.abrev = 'DECO_ADICIONAL'), null);

insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (NULL, '009', null, 'GRUPO SERVICIO COMODATO', 'GRUP_SERV_COMO', (select t.tipopedd from tipopedd t where t.abrev = 'DECO_ADICIONAL'), null);

insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (NULL, '008', null, 'GRUPO SERVICIO ALQUILER', 'GRUP_SERV_ALQU', (select t.tipopedd from tipopedd t where t.abrev = 'DECO_ADICIONAL'), null);

insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (NULL, '', 2, 'SOLICITUD DE INSTALACION', 'CODMOTOT', (select t.tipopedd from tipopedd t where t.abrev = 'DECO_ADICIONAL'), null);

insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (NULL, '6608', null, 'SERVICIO DE INSTALACION', 'CODSRV', (select t.tipopedd from tipopedd t where t.abrev = 'DECO_ADICIONAL'), null);

insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (NULL, '', 1198, 'WORK FLOW SOLOT DECO ADICIONAL', 'WFDECADIC', (select t.tipopedd from tipopedd t where t.abrev = 'DECO_ADICIONAL'), null);

insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (NULL, '689', null, 'REGISTRO VENTA DECO ADICIONAL TIPTRA', 'RVTIPTRA', (select t.tipopedd from tipopedd t where t.abrev = 'DECO_ADICIONAL'), null);

insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (NULL, '00000000', null, 'REGISTRO VENTA CODSOL POR DEAFAULT', 'RVCODSOL', (select t.tipopedd from tipopedd t where t.abrev = 'DECO_ADICIONAL'), null);

insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (NULL, '001', null, 'Generacion Automatica de Decos Adicionales.', 'OBSSOLFAC', (select t.tipopedd from tipopedd t where t.abrev = 'DECO_ADICIONAL'), 1);

insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (NULL, '001', null, 'PYMES - Servicios Complementarios', 'SRVPRI', (select t.tipopedd from tipopedd t where t.abrev = 'DECO_ADICIONAL'), 1);

insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (NULL, '001', null, 'Generacion Automatica de Decos Adicionales.', 'SOLOTOBS', (select t.tipopedd from tipopedd t where t.abrev = 'DECO_ADICIONAL'), 1);

insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (NULL, '0062', null, 'TIPO DE SERVICIO SOLO DECO ADICIONAL', 'TIPSRVDECO', (select t.tipopedd from tipopedd t where t.abrev = 'DECO_ADICIONAL'), null);

COMMIT;