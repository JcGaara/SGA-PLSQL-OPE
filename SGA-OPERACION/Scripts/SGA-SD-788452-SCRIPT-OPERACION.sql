INSERT INTO operacion.parametro_cab_adc (descripcion, abreviatura, estado) VALUES ('ACTIVACION ETA', 'ACTIVACION_ETA', '1');
          
      INSERT INTO operacion.parametro_det_adc (id_parametro, codigoc, codigon, descripcion, abreviatura, estado) 
      VALUES ((SELECT a.id_parametro FROM operacion.parametro_cab_adc a WHERE a.abreviatura = 'ACTIVACION_ETA'),NULL, 620, 'ACTIVACION DE INTERNET', NULL, '1');

      INSERT INTO operacion.parametro_det_adc (id_parametro, codigoc, codigon, descripcion, abreviatura, estado) 
      VALUES ((SELECT a.id_parametro FROM operacion.parametro_cab_adc a WHERE a.abreviatura = 'ACTIVACION_ETA'),NULL,  820, 'ACTIVACION DE TELEFONIA', NULL, '1');
      
      INSERT INTO operacion.parametro_det_adc (id_parametro, codigoc, codigon, descripcion, abreviatura, estado) 
      VALUES ((SELECT a.id_parametro FROM operacion.parametro_cab_adc a WHERE a.abreviatura = 'ACTIVACION_ETA'),NULL,  2020, 'ACTIVACION DE TV',NULL , '1');
commit;
/

