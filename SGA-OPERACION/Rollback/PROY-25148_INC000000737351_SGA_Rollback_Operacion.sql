delete from operacion.parametro_det_adc 
 where id_parametro in (select id_parametro from operacion.parametro_cab_adc where abreviatura = 'VAL_FRA');
 
delete from operacion.parametro_cab_adc 
 where abreviatura = 'VAL_FRA';

delete from operacion.parametro_det_adc 
 where id_parametro in (select id_parametro from operacion.parametro_cab_adc where abreviatura = 'REGLA_FRANJA_HORARIA');

delete from operacion.parametro_cab_adc 
 where abreviatura = 'REGLA_FRANJA_HORARIA';
 
 commit;
 /
 