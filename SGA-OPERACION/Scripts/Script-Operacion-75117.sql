------------ cabecera
insert into tipopedd (TIPOPEDD, DESCRIPCION, ABREV)
values (null, 'Facturacion SGA', 'PARAM_FACT_SGA');
------------ detalle
insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values(null, null, 1, 'Habilita la facturacion para SGA', 'habilitado', (select t.tipopedd from tipopedd t where t.abrev = 'PARAM_FACT_SGA'), null);

insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null, null, 7, 'Estado por default para facturacion SGA', 'est_fact_sga', (select t.tipopedd from tipopedd t where t.abrev = 'PARAM_FACT_SGA'), null);

COMMIT;
