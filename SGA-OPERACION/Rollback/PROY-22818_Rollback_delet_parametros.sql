 -------------------------RF: 20 ESTADO DE AGENDADO REPROCESO ORDEN-------------------------
delete from operacion.parametro_det_adc t
 where t.id_parametro in
       (select a.id_parametro
          from operacion.parametro_cab_adc a
         where a.abreviatura = 'EST_REPORDEN');
		 
delete from operacion.parametro_cab_adc t
 where t.abreviatura = 'EST_REPORDEN';		
 
-------------------------RF: 20 MENSAJE DE ERROR ------------------------------------------
delete from operacion.parametro_det_adc t
 where t.id_parametro in
       (select a.id_parametro
          from operacion.parametro_cab_adc a
         where a.abreviatura = 'MNS_REORDEN');
		 
delete from operacion.parametro_cab_adc t
 where t.abreviatura = 'MNS_REORDEN';

 commit;











 
 