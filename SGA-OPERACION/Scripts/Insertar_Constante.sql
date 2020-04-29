-- Configuración de número de hilos a utilizar para la carga de incidencias
INSERT INTO OPERACION.CONSTANTE (CONSTANTE, DESCRIPCION, TIPO, VALOR) 
VALUES ('NUMH_CARGA_INC', 'Numeros de hilos para cargar incidencias para el reporte SLA en el modulo de ATC del SGA', 'N', '10');
COMMIT;