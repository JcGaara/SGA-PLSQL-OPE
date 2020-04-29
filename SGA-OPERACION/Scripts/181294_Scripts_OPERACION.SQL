
insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null, ( select wfdef from wfdef where descripcion like '%HFC - CAMBIO DE TITULARIDAD%' ), (select descripcion from wfdef where descripcion like '%HFC - CAMBIO DE TITULARIDAD%'), null, ( select tipopedd from tipopedd where upper(descripcion) like '%OP-ASIG FLUJO AUTOMATICOS%' ), null);

commit;

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null, ( select wfdef from wfdef where descripcion like '%HFC - CAMBIO NUMERO%' ), (select descripcion from wfdef where descripcion like '%HFC - CAMBIO NUMERO%'), null, ( select tipopedd from tipopedd where upper(descripcion) like '%OP-ASIG FLUJO AUTOMATICOS%' ), null);

commit;



