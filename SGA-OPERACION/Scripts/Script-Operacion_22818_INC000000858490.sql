/* se actualiza la nueva regla NUEVO_MANTTOS para los tipos de trabajo 480, 610, 489, 671, 770' que tienen la regla MANTTOS  */
UPDATE operacion.parametro_det_adc t
set  t.abreviatura = 'NUEVO_MANTTOS'
WHERE t.id_parametro = (select t.id_parametro from operacion.parametro_cab_adc t where  t.abreviatura = 'REGLA_FRANJA_HORARIA')
AND codigon IN ('480', '610', '489', '671', '770')
AND t.abreviatura = 'MANTTOS'
AND t.codigoc = 'A';

commit;
