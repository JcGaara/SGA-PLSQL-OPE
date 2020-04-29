delete from operacion.parametro_det_adc t
 where t.id_parametro in
       (select a.id_parametro
          from operacion.parametro_cab_adc a
         where a.abreviatura = 'TELEF_CLIENTE');
		 
delete from operacion.parametro_cab_adc t
 where t.abreviatura = 'TELEF_CLIENTE';		
 

 commit; 