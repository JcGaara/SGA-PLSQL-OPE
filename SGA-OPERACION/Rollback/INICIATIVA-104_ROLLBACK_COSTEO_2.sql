UPDATE OPERACION.SGAT_EF_ETAPA_PRM
	SET EFEPV_DESCRIPCION = 'SEPARACION DE COSTOS'
 WHERE EFEPN_ID = 1;
 
UPDATE OPERACION.SGAT_EF_ETAPA_PRM
	SET EFEPV_CODV = 'SDC', EFEPV_DESCRIPCION = 'SANGRADO DE CABLE'
 WHERE EFEPN_ID = 20;
 
UPDATE OPERACION.SGAT_EF_ETAPA_PRM
	SET EFEPN_CODN = 2, EFEPV_TRANSACCION = 'SEPARACION DE COSTOS'
 WHERE EFEPN_ID = 22;
 
UPDATE OPERACION.SGAT_EF_ETAPA_PRM
	SET EFEPN_CODN        = 3,
		 EFEPV_CODV        = '0000000022',
		 EFEPV_DESCRIPCION = 'LURIGANCHO/CHOSICA',
		 EFEPV_TRANSACCION = 'SEPARACION DE COSTOS'
 WHERE EFEPN_ID = 23;
 
UPDATE OPERACION.SGAT_EF_ETAPA_PRM
	SET EFEPV_DESCRIPCION = 'MODALIDAD_NEGOCIOS',
		 EFEPV_TRANSACCION = 'REGLAS_NEGOCIOS'
 WHERE EFEPN_ID = 17;
 
UPDATE OPERACION.SGAT_EF_ETAPA_PRM
	SET EFEPV_TRANSACCION = 'MODALIDAD_NEGOCIOS'
 WHERE EFEPV_TRANSACCION = 'ESCENARIOS';
 
UPDATE OPERACION.SGAT_EF_ETAPA_PRM
	SET EFEPV_TRANSACCION = 'REGLAS_SMALLWORLD'
 WHERE EFEPN_ID IN (2, 3, 4);
 
UPDATE OPERACION.SGAT_EF_ETAPA_PRM
	SET EFEPN_VALOR = 1
 WHERE EFEPN_ID IN (1, 2, 3, 4);
 
UPDATE OPERACION.SGAT_EF_ETAPA_PRM SET EFEPN_VALOR = 0 WHERE EFEPN_ID = 17;

UPDATE OPERACION.SGAT_EF_ETAPA_PRM
	SET EFEPN_VALOR = NULL
 WHERE EFEPN_ID IN
		 (5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 18, 19, 20, 21);


DELETE FROM OPERACION.SGAT_EF_ETAPA_PRM
 WHERE EFEPN_ID >= 24;

DELETE FROM OPERACION.SGAT_EF_ETAPA_CNFG
 WHERE EFECN_ID >= 31;

DELETE FROM OPERACION.SGAT_EF_ETAPA_SRVC
 WHERE EFESN_ID >= 5;

 
COMMIT;