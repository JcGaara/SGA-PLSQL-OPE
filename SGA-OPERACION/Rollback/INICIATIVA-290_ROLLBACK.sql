DROP PACKAGE OPERACION.pkg_ef_corp;

DELETE FROM operacion.opedd WHERE abreviacion = 'REG_SUM_DIAPLA_EF';
DELETE FROM operacion.tipopedd WHERE abrev = 'REG_SUM_DIAPLA_EF';

ALTER TABLE operacion.areaope
DROP COLUMN open_flgsum;
