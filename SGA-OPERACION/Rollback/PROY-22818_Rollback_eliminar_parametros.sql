delete from operacion.parametro_det_adc 
 where id_parametro=(select id_parametro 
                       from operacion.parametro_cab_adc 
                      where abreviatura='CONF_INV');
delete from operacion.parametro_cab_adc 
  where abreviatura='CONF_INV';
commit;

delete from operacion.parametro_det_adc 
 where id_parametro=(select id_parametro 
                       from operacion.parametro_cab_adc 
                      where abreviatura='VAL_L_INV');
delete from operacion.parametro_cab_adc 
  where abreviatura='VAL_L_INV';
commit;

delete from operacion.parametro_det_adc 
 where id_parametro=(select id_parametro 
                       from operacion.parametro_cab_adc 
                      where abreviatura='CONF_M_INV');
delete from operacion.parametro_cab_adc 
  where abreviatura='CONF_M_INV';
commit;
delete from operacion.parametro_det_adc 
 where id_parametro=(select id_parametro 
                       from operacion.parametro_cab_adc 
                      where abreviatura='VAL_EQ_ITW');
delete from operacion.parametro_cab_adc 
  where abreviatura='VAL_EQ_ITW';
commit;