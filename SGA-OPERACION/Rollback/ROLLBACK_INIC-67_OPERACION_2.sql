DELETE FROM operacion.OPEDD WHERE TIPOPEDD= 
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE op.ABREV='FLUJO_APROB_DIRECCIONES');


DELETE FROM operacion.OPEDD WHERE TIPOPEDD= 
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE op.ABREV='FLUJO_APROB_CARGOS_NIVEL');

DELETE FROM operacion.TIPOPEDD OPD WHERE OPD.ABREV='FLUJO_APROB_DIRECCIONES';

DELETE FROM operacion.TIPOPEDD OPD WHERE OPD.ABREV='FLUJO_APROB_CARGOS_NIVEL';

COMMIT;






