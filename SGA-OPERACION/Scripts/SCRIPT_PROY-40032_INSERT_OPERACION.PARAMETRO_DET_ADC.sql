﻿--Parámetro Configuración generación de trama/SOT
 INSERT INTO OPERACION.PARAMETRO_DET_ADC (ID_PARAMETRO, CODIGOC, CODIGON, DESCRIPCION, ABREVIATURA, ESTADO) VALUES ((SELECT a.id_parametro FROM operacion.parametro_cab_adc a WHERE a.abreviatura = 'FLAG_SGAT_AGENDA'), 'F', NULL, 'FLAG GENERACIÓN DE TRAMA/SOT','SEL_PEDIDO_AGEND' , '1');


--Parámetro Configuración de Inserción a tabla SGAT_AGENDA_SERVINST 

 INSERT INTO OPERACION.PARAMETRO_DET_ADC (ID_PARAMETRO, CODIGOC, CODIGON, DESCRIPCION, ABREVIATURA, ESTADO) VALUES ((SELECT a.id_parametro FROM operacion.parametro_cab_adc a WHERE a.abreviatura = 'EST_AGEN_SERV'), NULL, '0', 'SIN ACCION','SIN_ACC' , '1');
 INSERT INTO OPERACION.PARAMETRO_DET_ADC (ID_PARAMETRO, CODIGOC, CODIGON, DESCRIPCION, ABREVIATURA, ESTADO) VALUES ((SELECT a.id_parametro FROM operacion.parametro_cab_adc a WHERE a.abreviatura = 'EST_AGEN_SERV'), NULL, '1','ELIMINAR/INSERTAR','DEL_INS',  '1');
 INSERT INTO OPERACION.PARAMETRO_DET_ADC (ID_PARAMETRO, CODIGOC, CODIGON, DESCRIPCION, ABREVIATURA, ESTADO) VALUES ((SELECT a.id_parametro FROM operacion.parametro_cab_adc a WHERE a.abreviatura = 'EST_AGEN_SERV'), NULL, '2', 'ACTUALIZAR','UPD',  '1');
COMMIT;
