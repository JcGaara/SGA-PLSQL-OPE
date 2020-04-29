-- UPDATE DE SUSPENSION
update operacion.opedd set codigoc = null where abreviacion = 'SUSXTIPTRA_HFC' and codigon = 658;
update operacion.opedd set codigoc = null where abreviacion = 'SUSXTIPTRA_FTTH' and codigon = 830;
-- UPDATE DE RECONEXION
update operacion.opedd set codigoc = null where abreviacion = 'RECXTIPTRA_HFC' and codigon = 658;
update operacion.opedd set codigoc = null where abreviacion = 'RECXTIPTRA_FTTH' and codigon = 830; 
-- UPDATE DE BAJA
update operacion.opedd set codigoc = null where abreviacion = 'BAJAXTIPTRA_HFC' and codigon = 658;
update operacion.opedd set codigoc = null where abreviacion = 'BAJAXTIPTRA_FTTH' and codigon = 830;

-- UPDATE CONFIGURACION TIPREGCONTIWSGABSCS
update operacion.opedd set abreviacion = null where tipopedd = 1392 and codigon in (427,676,658,412,695,693,678,785,744,825); 
update operacion.opedd set abreviacion = null where tipopedd = 1392 and codigon in (801,753,754);
update operacion.opedd set abreviacion = null where tipopedd = 1392 and codigon in (830);

COMMIT;
/
