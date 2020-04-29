---INSERT CABECERA Y DETALLE :  TIPOPEDD - OPEDD
---cabecera
insert into tipopedd (TIPOPEDD, DESCRIPCION, ABREV)
values ((select MAX(TIPOPEDD)from tipopedd)+1, 'CORPORATIVO TIPO VENDEDOR', 'LIST_CONSULDIST');

---detalle
insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select max(IDOPEDD)from opedd)+1, '010', null, 'Listado de Consultores', 'LISTCONSUL', (select tipopedd from tipopedd where abrev='LIST_CONSULDIST'), null);

insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select max(IDOPEDD)from opedd)+1, 'DGM', null, 'Listado de Distribuidores', 'LISTDISTRIB', (select tipopedd from tipopedd where abrev='LIST_CONSULDIST'), null);

COMMIT;
