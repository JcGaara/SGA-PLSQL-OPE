
--Se registra la cabecera en la TIPOPEDD
insert into tipopedd (DESCRIPCION, ABREV)
values ('PARAMETRO - BAJA WIMAX', 'PARBAJAWIMAX');


--Se registra los parametros en la OPEDD - parametros wimax
insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('0058', null, 'TIPO SERVICIO - BAJA WIMAX', 'TIPSRVBAJWIMAX', (select c.TIPOPEDD from tipopedd c where abrev = 'PARBAJAWIMAX'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null, 5, 'TIPO TRABAJO - BAJA WIMAX', 'TIPTRABAJWIMAX', (select c.TIPOPEDD from tipopedd c where abrev = 'PARBAJAWIMAX'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null, 17, 'ESTADO SOT - BAJA WIMAX', 'ESTSOTBAJWIMAX', (select c.TIPOPEDD from tipopedd c where abrev = 'PARBAJAWIMAX'), null);

--Se registra los paremetros en la OPEDD - parametros producto
insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('INT', 527, 'CE Internet - WIMAX', 'IDPRODCONTING_SERV_WIMAX', (select c.TIPOPEDD from tipopedd c where abrev = 'IDPRODUCTOCONTINGENCIA'), 4);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('INT', 910, 'Internet Movil 3 GB - WIMAX', 'IDPRODCONTING_SERV_WIMAX', (select c.TIPOPEDD from tipopedd c where abrev = 'IDPRODUCTOCONTINGENCIA'), 4);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('INT', 911, 'Internet Movil 3 GB - WIMAX', 'IDPRODCONTING_SERV_WIMAX', (select c.TIPOPEDD from tipopedd c where abrev = 'IDPRODUCTOCONTINGENCIA'), 4);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('INT', 842, 'Web y Mail Hosting CE - WIMAX', 'IDPRODCONTING_SERV_WIMAX', (select c.TIPOPEDD from tipopedd c where abrev = 'IDPRODUCTOCONTINGENCIA'), 4);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('TLF', 737, 'CE Telefonia Fija - WIMAX', 'IDPRODCONTING_SERV_WIMAX', (select c.TIPOPEDD from tipopedd c where abrev = 'IDPRODUCTOCONTINGENCIA'), 4);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('TLF', 852, 'CE: Plan Abierto - WIMAX', 'IDPRODCONTING_SERV_WIMAX', (select c.TIPOPEDD from tipopedd c where abrev = 'IDPRODUCTOCONTINGENCIA'), 4);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('TLF', 503, 'Linea Telefónica CE - WIMAX', 'IDPRODCONTING_SERV_WIMAX', (select c.TIPOPEDD from tipopedd c where abrev = 'IDPRODUCTOCONTINGENCIA'), 4);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('INT', 524, 'Casillas de Correo - WIMAX', 'IDPRODCONTING_SERV_WIMAX', (select c.TIPOPEDD from tipopedd c where abrev = 'IDPRODUCTOCONTINGENCIA'), 4);

--Se regisra los valores en la tabla constante
insert into operacion.constante (CONSTANTE, DESCRIPCION, TIPO, VALOR, OBS)
values ('DN_TYPE_LTE', 'DN_TYPE_LTE', 'N', '9', null);

insert into operacion.constante (CONSTANTE, DESCRIPCION, TIPO, VALOR, OBS)
values ('HLCODE_LTE', 'HLCODE_LTE', 'N', '1', null);

insert into operacion.constante (CONSTANTE, DESCRIPCION, TIPO, VALOR, OBS)
values ('HMCODE_LTE', 'HMCODE_LTE', 'N', '3596', null);

insert into operacion.constante (CONSTANTE, DESCRIPCION, TIPO, VALOR, OBS)
values ('LTE_WIMAX_MIGRA', 'LTE_WIMAX_MIGRA', null, '1', null);

insert into operacion.constante (CONSTANTE, DESCRIPCION, TIPO, VALOR, OBS)
values ('PLCODE_LTE', 'PLCODE LTE', 'N', '79', null);

commit;