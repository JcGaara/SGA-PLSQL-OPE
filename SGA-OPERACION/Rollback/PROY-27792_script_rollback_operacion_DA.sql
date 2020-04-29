--Motivo para Baja Deco Adicional
DELETE FROM operacion.opedd where tipopedd = (SELECT t.tipopedd FROM operacion.tipopedd t where t.abrev = 'DECO_ADICIONAL') and abreviacion = 'SOLINSALTA';

--Monto Baja Deco Adicional
DELETE FROM operacion.opedd where tipopedd = (SELECT t.tipopedd FROM operacion.tipopedd t where t.abrev = 'HFC_SIAC_DEC_ADICIONAL') and abreviacion = 'MONTB_OCC';

DELETE FROM operacion.mototxtiptra where tiptra = 705 and codmotot = 667;
DELETE FROM operacion.mototxtiptra where tiptra = 689 and codmotot = 667;

COMMIT;
/