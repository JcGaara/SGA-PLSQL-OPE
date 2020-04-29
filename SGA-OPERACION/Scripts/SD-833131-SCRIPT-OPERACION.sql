INSERT INTO operacion.parametro_cab_adc (descripcion, abreviatura, estado) VALUES ('CREA ORDEN ADC', 'VALIDA_ORDEN_ADC', '1');
          
      INSERT INTO operacion.parametro_det_adc (id_parametro, codigoc, codigon, descripcion, abreviatura, estado) 
      VALUES ((SELECT a.id_parametro FROM operacion.parametro_cab_adc a WHERE a.abreviatura = 'VALIDA_ORDEN_ADC'),NULL,  1, 'FLAG VALIDA ORDEN ADC', 'FLUJO_ORDEN_ADC', '1');      
commit;
/
