delete from operacion.parametro_det_adc t where t.id_parametro = (SELECT id_parametro FROM operacion.parametro_cab_adc WHERE  abreviatura = 'TECNO_RELAN_PROG'and estado = 1) and t.estado = 1;

delete from operacion.parametro_cab_adc t where t.abreviatura = 'TECNO_RELAN_PROG' and t.estado = 1;

commit;


