INSERT INTO OPERACION.SGAT_EF_ETAPA_PRM (EFEPN_ID, EFEPN_CODN, EFEPV_CODV, EFEPV_DESCRIPCION, EFEPV_TRANSACCION, EFEPN_VALOR, EFEPN_ID_PADRE, EFEPV_SISTEMA, EFEPN_CODN2, EFEPV_CODV2)
VALUES (7, 1, NULL, 'SLOTS DISPONIBLES EN CHASIS MC ', 'DETALLE_EQUIPOS', NULL, 3, 'N', NULL, NULL);

INSERT INTO OPERACION.SGAT_EF_ETAPA_PRM (EFEPN_ID, EFEPN_CODN, EFEPV_CODV, EFEPV_DESCRIPCION, EFEPV_TRANSACCION, EFEPN_VALOR, EFEPN_ID_PADRE, EFEPV_SISTEMA, EFEPN_CODN2, EFEPV_CODV2)
VALUES (8, 1, NULL, 'TARJETA INSTALADA', 'DETALLE_EQUIPOS', NULL, 3, 'N', NULL, NULL);

INSERT INTO OPERACION.SGAT_EF_ETAPA_PRM (EFEPN_ID, EFEPN_CODN, EFEPV_CODV, EFEPV_DESCRIPCION, EFEPV_TRANSACCION, EFEPN_VALOR, EFEPN_ID_PADRE, EFEPV_SISTEMA, EFEPN_CODN2, EFEPV_CODV2)
VALUES (4, NULL, NULL, 'DISTANCIAS_EQUIPOS', 'REGLAS_SMALLWORLD', 1, NULL, 'N', NULL, NULL);

INSERT INTO OPERACION.SGAT_EF_ETAPA_PRM (EFEPN_ID, EFEPN_CODN, EFEPV_CODV, EFEPV_DESCRIPCION, EFEPV_TRANSACCION, EFEPN_VALOR, EFEPN_ID_PADRE, EFEPV_SISTEMA, EFEPN_CODN2, EFEPV_CODV2)
VALUES (9, 0, NULL, 'MENOR A 3KM', 'DISTANCIAS_EQUIPOS', NULL, 4, 'N', 3000, NULL);

INSERT INTO OPERACION.SGAT_EF_ETAPA_PRM (EFEPN_ID, EFEPN_CODN, EFEPV_CODV, EFEPV_DESCRIPCION, EFEPV_TRANSACCION, EFEPN_VALOR, EFEPN_ID_PADRE, EFEPV_SISTEMA, EFEPN_CODN2, EFEPV_CODV2)
VALUES (10, 0, NULL, 'MENOR A 10KM', 'DISTANCIAS_EQUIPOS', NULL, 4, 'N', 10000, NULL);

INSERT INTO OPERACION.SGAT_EF_ETAPA_PRM (EFEPN_ID, EFEPN_CODN, EFEPV_CODV, EFEPV_DESCRIPCION, EFEPV_TRANSACCION, EFEPN_VALOR, EFEPN_ID_PADRE, EFEPV_SISTEMA, EFEPN_CODN2, EFEPV_CODV2)
VALUES (11, 0, NULL, 'MENOR A 25KM', 'DISTANCIAS_EQUIPOS', NULL, 4, 'N', 25000, NULL);

INSERT INTO OPERACION.SGAT_EF_ETAPA_PRM (EFEPN_ID, EFEPN_CODN, EFEPV_CODV, EFEPV_DESCRIPCION, EFEPV_TRANSACCION, EFEPN_VALOR, EFEPN_ID_PADRE, EFEPV_SISTEMA, EFEPN_CODN2, EFEPV_CODV2)
VALUES (12, 3000, NULL, 'MAYOR A 3KM', 'DISTANCIAS_EQUIPOS', NULL, 4, 'N', 100000, NULL);

INSERT INTO OPERACION.SGAT_EF_ETAPA_PRM (EFEPN_ID, EFEPN_CODN, EFEPV_CODV, EFEPV_DESCRIPCION, EFEPV_TRANSACCION, EFEPN_VALOR, EFEPN_ID_PADRE, EFEPV_SISTEMA, EFEPN_CODN2, EFEPV_CODV2)
VALUES (13, 15000, NULL, 'MAYOR A 15KM', 'DISTANCIAS_EQUIPOS', NULL, 4, 'N', 100000, NULL);

INSERT INTO OPERACION.SGAT_EF_ETAPA_PRM (EFEPN_ID, EFEPN_CODN, EFEPV_CODV, EFEPV_DESCRIPCION, EFEPV_TRANSACCION, EFEPN_VALOR, EFEPN_ID_PADRE, EFEPV_SISTEMA, EFEPN_CODN2, EFEPV_CODV2)
VALUES (14, 25000, NULL, 'MAYOR A 25KM', 'DISTANCIAS_EQUIPOS', NULL, 4, 'N', 100000, NULL);

INSERT INTO OPERACION.SGAT_EF_ETAPA_PRM (EFEPN_ID, EFEPN_CODN, EFEPV_CODV, EFEPV_DESCRIPCION, EFEPV_TRANSACCION, EFEPN_VALOR, EFEPN_ID_PADRE, EFEPV_SISTEMA, EFEPN_CODN2, EFEPV_CODV2)
VALUES (15, 10000, NULL, 'ENTRE 10KM Y 15KM', 'DISTANCIAS_EQUIPOS', NULL, 4, 'N', 15000, NULL);

INSERT INTO OPERACION.SGAT_EF_ETAPA_PRM (EFEPN_ID, EFEPN_CODN, EFEPV_CODV, EFEPV_DESCRIPCION, EFEPV_TRANSACCION, EFEPN_VALOR, EFEPN_ID_PADRE, EFEPV_SISTEMA, EFEPN_CODN2, EFEPV_CODV2)
VALUES (1, NULL, NULL, 'SEPARACION DE COSTOS', 'REGLAS_POLITICA', 1, NULL, 'S', NULL, NULL);

INSERT INTO OPERACION.SGAT_EF_ETAPA_PRM (EFEPN_ID, EFEPN_CODN, EFEPV_CODV, EFEPV_DESCRIPCION, EFEPV_TRANSACCION, EFEPN_VALOR, EFEPN_ID_PADRE, EFEPV_SISTEMA, EFEPN_CODN2, EFEPV_CODV2)
VALUES (6, 80, NULL, 'MAYOR A 80 MB', 'ANCHO DE BANDA', NULL, 2, 'N', 1000, NULL);

INSERT INTO OPERACION.SGAT_EF_ETAPA_PRM (EFEPN_ID, EFEPN_CODN, EFEPV_CODV, EFEPV_DESCRIPCION, EFEPV_TRANSACCION, EFEPN_VALOR, EFEPN_ID_PADRE, EFEPV_SISTEMA, EFEPN_CODN2, EFEPV_CODV2)
VALUES (5, 0, NULL, 'MENOR A 80 MB', 'ANCHO DE BANDA', NULL, 2, 'N', 80, NULL);

INSERT INTO OPERACION.SGAT_EF_ETAPA_PRM (EFEPN_ID, EFEPN_CODN, EFEPV_CODV, EFEPV_DESCRIPCION, EFEPV_TRANSACCION, EFEPN_VALOR, EFEPN_ID_PADRE, EFEPV_SISTEMA, EFEPN_CODN2, EFEPV_CODV2)
VALUES (17, NULL, NULL, 'MODALIDAD_NEGOCIOS', 'REGLAS_NEGOCIOS', 0, NULL, 'N', NULL, NULL);

INSERT INTO OPERACION.SGAT_EF_ETAPA_PRM (EFEPN_ID, EFEPN_CODN, EFEPV_CODV, EFEPV_DESCRIPCION, EFEPV_TRANSACCION, EFEPN_VALOR, EFEPN_ID_PADRE, EFEPV_SISTEMA, EFEPN_CODN2, EFEPV_CODV2)
VALUES (18, NULL, 'SA', 'SERVICIOS ADICIONALES', 'MODALIDAD_NEGOCIOS', NULL, 17, 'N', NULL, NULL);

INSERT INTO OPERACION.SGAT_EF_ETAPA_PRM (EFEPN_ID, EFEPN_CODN, EFEPV_CODV, EFEPV_DESCRIPCION, EFEPV_TRANSACCION, EFEPN_VALOR, EFEPN_ID_PADRE, EFEPV_SISTEMA, EFEPN_CODN2, EFEPV_CODV2)
VALUES (19, NULL, 'MMC', 'MUFA MAS CERCANA', 'MODALIDAD_NEGOCIOS', NULL, 17, 'N', NULL, NULL);

INSERT INTO OPERACION.SGAT_EF_ETAPA_PRM (EFEPN_ID, EFEPN_CODN, EFEPV_CODV, EFEPV_DESCRIPCION, EFEPV_TRANSACCION, EFEPN_VALOR, EFEPN_ID_PADRE, EFEPV_SISTEMA, EFEPN_CODN2, EFEPV_CODV2)
VALUES (20, NULL, 'SDC', 'SANGRADO DE CABLE', 'MODALIDAD_NEGOCIOS', NULL, 17, 'N', NULL, NULL);

INSERT INTO OPERACION.SGAT_EF_ETAPA_PRM (EFEPN_ID, EFEPN_CODN, EFEPV_CODV, EFEPV_DESCRIPCION, EFEPV_TRANSACCION, EFEPN_VALOR, EFEPN_ID_PADRE, EFEPV_SISTEMA, EFEPN_CODN2, EFEPV_CODV2)
VALUES (21, NULL, 'CDS', 'CABLE DIRECTO SITE', 'MODALIDAD_NEGOCIOS', NULL, 17, 'N', NULL, NULL);

INSERT INTO OPERACION.SGAT_EF_ETAPA_PRM (EFEPN_ID, EFEPN_CODN, EFEPV_CODV, EFEPV_DESCRIPCION, EFEPV_TRANSACCION, EFEPN_VALOR, EFEPN_ID_PADRE, EFEPV_SISTEMA, EFEPN_CODN2, EFEPV_CODV2)
VALUES (23, 3, '0000000022', 'LURIGANCHO/CHOSICA', 'SEPARACION DE COSTOS', NULL, 1, 'N', NULL, NULL);

INSERT INTO OPERACION.SGAT_EF_ETAPA_PRM (EFEPN_ID, EFEPN_CODN, EFEPV_CODV, EFEPV_DESCRIPCION, EFEPV_TRANSACCION, EFEPN_VALOR, EFEPN_ID_PADRE, EFEPV_SISTEMA, EFEPN_CODN2, EFEPV_CODV2)
VALUES (22, 2, '0000000011', 'LIMA (CERCADO)', 'SEPARACION DE COSTOS', NULL, 1, 'N', NULL, NULL);

INSERT INTO OPERACION.SGAT_EF_ETAPA_PRM (EFEPN_ID, EFEPN_CODN, EFEPV_CODV, EFEPV_DESCRIPCION, EFEPV_TRANSACCION, EFEPN_VALOR, EFEPN_ID_PADRE, EFEPV_SISTEMA, EFEPN_CODN2, EFEPV_CODV2)
VALUES (2, NULL, NULL, 'ANCHO DE BANDA', 'REGLAS_SMALLWORLD', 1, NULL, 'N', NULL, NULL);

INSERT INTO OPERACION.SGAT_EF_ETAPA_PRM (EFEPN_ID, EFEPN_CODN, EFEPV_CODV, EFEPV_DESCRIPCION, EFEPV_TRANSACCION, EFEPN_VALOR, EFEPN_ID_PADRE, EFEPV_SISTEMA, EFEPN_CODN2, EFEPV_CODV2)
VALUES (3, NULL, NULL, 'DETALLE_EQUIPOS', 'REGLAS_SMALLWORLD', 1, NULL, 'N', NULL, NULL);

COMMIT;