UPDATE operacion.parametro_det_adc t
set  t.abreviatura = 'MANTTOS'
WHERE t.id_parametro = (select t.id_parametro from operacion.parametro_cab_adc t where  t.abreviatura = 'REGLA_FRANJA_HORARIA')
AND codigon IN ('480', '610', '489', '671', '770')
AND t.abreviatura = 'NUEVO_MANTTOS'
AND t.codigoc = 'A';

commit;
