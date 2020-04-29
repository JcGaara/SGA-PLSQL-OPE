delete from operacion.opedd where tipopedd = (select tipopedd from operacion.tipopedd where abrev = 'DIAS_LIBERAR_HILOS');

delete from operacion.tipopedd where abrev = 'DIAS_LIBERAR_HILOS';

delete from operacion.opedd where tipopedd = (select tipopedd from operacion.tipopedd where abrev = 'DISPONIBILIDAD_HILOS');

delete from operacion.tipopedd where abrev = 'DISPONIBILIDAD_HILOS';

delete from operacion.opedd where tipopedd = (select tipopedd from operacion.tipopedd where abrev = 'TIPTRA_LIBERAR_HILOS');

delete from operacion.tipopedd where abrev = 'TIPTRA_LIBERAR_HILOS';

commit;
/
