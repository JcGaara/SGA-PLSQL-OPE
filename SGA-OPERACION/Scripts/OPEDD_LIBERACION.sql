insert into OPERACION.TIPOPEDD (DESCRIPCION, ABREV)
values ('Estados Liberacion Numero', 'ESTADO_LIBERACION');

insert into OPERACION.OPEDD (CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (6, 'RESERVA SISTEMA', 'RES_SISTEMA', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'ESTADO_LIBERACION'), 1);

insert into OPERACION.TIPOPEDD (DESCRIPCION, ABREV)
values ('Tipos de Trabajo para la Baja', 'TIPOS_TRABAJO');

insert into OPERACION.OPEDD (CODIGOC, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('5', 'BAJA TOTAL DEL SERVICIO', 'BAJA_TOTAL', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'TIPOS_TRABAJO'), 1);

insert into OPERACION.OPEDD (CODIGOC, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('408', 'HFC - BAJA TOTAL DE SERVICIO', 'BAJA_TOTAL_SRV', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'TIPOS_TRABAJO'), 1);

insert into OPERACION.OPEDD (CODIGOC, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('757', 'WLL/SIAC - BAJA TOTAL DE SERVICIO', 'WLL_BAJA_TOTAL', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'TIPOS_TRABAJO'), 1);

insert into OPERACION.OPEDD (CODIGOC, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('795', 'HFC/SIAC - BAJA TOTAL POR CAMBIO DE PLAN', 'HFC_BAJA_TOTAL_CBP', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'TIPOS_TRABAJO'), 1);

insert into OPERACION.OPEDD (CODIGOC, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('448', 'HFC - BAJA TODO CLARO TOTAL', 'HFC_BAJA_CLARO', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'TIPOS_TRABAJO'), 1);

insert into OPERACION.OPEDD (CODIGOC, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('728', 'HFC/SIAC - BAJA TOTAL DEL SERVICIO', 'SIAC_BAJA_TOTAL_SRV', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'TIPOS_TRABAJO'), 1);

insert into OPERACION.OPEDD (CODIGOC, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('783', 'WLL/SIAC - CANCELACION DE SERVICIO', 'WLL_CANCE_SERV', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'TIPOS_TRABAJO'), 1);

insert into OPERACION.OPEDD (CODIGOC, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('747', 'BAJA TOTAL 3PLAY INALAMBRICO', 'BAJA_TOTAL_3PLAY', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'TIPOS_TRABAJO'), 1);

insert into OPERACION.OPEDD (CODIGOC, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('796', 'HFC/SIAC DESACTIVACION POR SUSTITUCION', 'HFC_DESAC_SUS', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'TIPOS_TRABAJO'), 1);

insert into OPERACION.OPEDD (CODIGOC, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('804', 'HFC - BAJA ADMINISTRATIVA MIGRACION A SISACT MIGRACION', 'HFC_BAJA_ADM', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'TIPOS_TRABAJO'), 1);

insert into OPERACION.OPEDD (CODIGOC, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('747', 'BAJA TOTAL 3PLAY INALAMBRICO', 'LTE_BAJA_ANULA', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'TIPOS_TRABAJO'), 1);

insert into OPERACION.OPEDD (CODIGOC, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('757', 'WLL/SIAC - BAJA TOTAL DE SERVICIO', 'LTE_BAJA_ANULA', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'TIPOS_TRABAJO'), 1);

insert into OPERACION.OPEDD (CODIGOC, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('783', 'WLL/SIAC - CANCELACION DE SERVICIO', 'LTE_BAJA_ANULA', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'TIPOS_TRABAJO'), 1);

insert into OPERACION.OPEDD (CODIGOC, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('801', 'WLL/LTE MIGRACION WIMAX - LTE', 'LTE_BAJA_ANULA', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'TIPOS_TRABAJO'), 1);

insert into OPERACION.OPEDD (CODIGOC, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('811', 'WLL/SIAC - BAJA ADMINISTRATIVA', 'LTE_BAJA_ANULA', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'TIPOS_TRABAJO'), 1);

insert into OPERACION.OPEDD (CODIGOC, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('744', 'INSTALACION 3PLAY INALAMBRICO', 'LTE_BAJA_ANULA', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'TIPOS_TRABAJO'), 1);

insert into OPERACION.OPEDD (CODIGOC, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('746', 'INSTALACION 3PLAY INALAMBRICO - MIGRACION', 'LTE_BAJA_ANULA', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'TIPOS_TRABAJO'), 1);

insert into OPERACION.TIPOPEDD (DESCRIPCION, ABREV)
values ('Tipos de Lineas', 'TIPOS_LINEAS');

insert into OPERACION.OPEDD (CODIGON, CODIGOC, DESCRIPCION, TIPOPEDD, CODIGON_AUX)
values (74,'HFC_Corp', 'Zona Xplor@ Arequipa', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'TIPOS_LINEAS'), 1);

insert into OPERACION.OPEDD (CODIGON, CODIGOC, DESCRIPCION, TIPOPEDD, CODIGON_AUX)
values (125,'HFC_Corp', 'Zona Xplor@ Cajamarca', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'TIPOS_LINEAS'), 1);

insert into OPERACION.OPEDD (CODIGON, CODIGOC, DESCRIPCION, TIPOPEDD, CODIGON_AUX)
values (77,'HFC_Corp', 'Zona Xplor@ Chiclayo', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'TIPOS_LINEAS'), 1);

insert into OPERACION.OPEDD (CODIGON, CODIGOC, DESCRIPCION, TIPOPEDD, CODIGON_AUX)
values (140,'HFC_Corp', 'Zona Xplor@ Chimbote', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'TIPOS_LINEAS'), 1);

insert into OPERACION.OPEDD (CODIGON, CODIGOC, DESCRIPCION, TIPOPEDD, CODIGON_AUX)
values (135,'HFC_Corp', 'Zona Xplor@ Cusco', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'TIPOS_LINEAS'), 1);

insert into OPERACION.OPEDD (CODIGON, CODIGOC, DESCRIPCION, TIPOPEDD, CODIGON_AUX)
values (96,'HFC_Corp', 'Zona Xplor@ Huancayo', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'TIPOS_LINEAS'), 1);

insert into OPERACION.OPEDD (CODIGON, CODIGOC, DESCRIPCION, TIPOPEDD, CODIGON_AUX)
values (182,'HFC_Corp', 'Zona Xplor@ Ica', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'TIPOS_LINEAS'), 1);

insert into OPERACION.OPEDD (CODIGON, CODIGOC, DESCRIPCION, TIPOPEDD, CODIGON_AUX)
values (76,'HFC_Corp', 'Zona Xplor@ Iquitos', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'TIPOS_LINEAS'), 1);

insert into OPERACION.OPEDD (CODIGON, CODIGOC, DESCRIPCION, TIPOPEDD, CODIGON_AUX)
values (183,'HFC_Corp', 'Zona Xplor@ Juliaca', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'TIPOS_LINEAS'), 1);

insert into OPERACION.OPEDD (CODIGON, CODIGOC, DESCRIPCION, TIPOPEDD, CODIGON_AUX)
values (71,'HFC_Corp', 'Zona Xplor@ Lima', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'TIPOS_LINEAS'), 1);

insert into OPERACION.OPEDD (CODIGON, CODIGOC, DESCRIPCION, TIPOPEDD, CODIGON_AUX)
values (78,'HFC_Corp', 'Zona Xplor@ Piura', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'TIPOS_LINEAS'), 1);

insert into OPERACION.OPEDD (CODIGON, CODIGOC, DESCRIPCION, TIPOPEDD, CODIGON_AUX)
values (79,'HFC_Corp', 'Zona Xplor@ Pucallpa', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'TIPOS_LINEAS'), 1);

insert into OPERACION.OPEDD (CODIGON, CODIGOC, DESCRIPCION, TIPOPEDD, CODIGON_AUX)
values (134,'HFC_Corp', 'Zona Xplor@ Tacna', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'TIPOS_LINEAS'), 1);

insert into OPERACION.OPEDD (CODIGON, CODIGOC, DESCRIPCION, TIPOPEDD, CODIGON_AUX)
values (171,'HFC_Corp', 'Zona Xplor@ Tarapoto', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'TIPOS_LINEAS'), 1);

insert into OPERACION.OPEDD (CODIGON, CODIGOC, DESCRIPCION, TIPOPEDD, CODIGON_AUX)
values (73,'HFC_Corp', 'Zona Xplor@ Trujillo', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'TIPOS_LINEAS'), 1);

insert into OPERACION.OPEDD (CODIGON, CODIGOC, DESCRIPCION, TIPOPEDD, CODIGON_AUX)
values (98,'HFC_Mas', 'Zona 3Play Automatico', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'TIPOS_LINEAS'), 1);

insert into OPERACION.OPEDD (CODIGON, CODIGOC, DESCRIPCION, TIPOPEDD, CODIGON_AUX)
values (94,'HFC_Mas', 'Zona 3Play Manual', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'TIPOS_LINEAS'), 1);

insert into OPERACION.OPEDD (CODIGON, CODIGOC, DESCRIPCION, TIPOPEDD, CODIGON_AUX)
values (133,'TPI_Mas', 'TPI CDMA Arequipa', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'TIPOS_LINEAS'), 1);

insert into OPERACION.OPEDD (CODIGON, CODIGOC, DESCRIPCION, TIPOPEDD, CODIGON_AUX)
values (158,'TPI_Mas', 'TPI CDMA Cajamarca', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'TIPOS_LINEAS'), 1);

insert into OPERACION.OPEDD (CODIGON, CODIGOC, DESCRIPCION, TIPOPEDD, CODIGON_AUX)
values (121,'TPI_Mas', 'TPI CDMA Chiclayo', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'TIPOS_LINEAS'), 1);

insert into OPERACION.OPEDD (CODIGON, CODIGOC, DESCRIPCION, TIPOPEDD, CODIGON_AUX)
values (159,'TPI_Mas', 'TPI CDMA Cusco', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'TIPOS_LINEAS'), 1);

insert into OPERACION.OPEDD (CODIGON, CODIGOC, DESCRIPCION, TIPOPEDD, CODIGON_AUX)
values (157,'TPI_Mas', 'TPI CDMA Iquitos', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'TIPOS_LINEAS'), 1);

insert into OPERACION.OPEDD (CODIGON, CODIGOC, DESCRIPCION, TIPOPEDD, CODIGON_AUX)
values (165,'TPI_Mas', 'TPI CDMA Lima', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'TIPOS_LINEAS'), 1);

insert into OPERACION.OPEDD (CODIGON, CODIGOC, DESCRIPCION, TIPOPEDD, CODIGON_AUX)
values (122,'TPI_Mas', 'TPI CDMA Piura', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'TIPOS_LINEAS'), 1);

insert into OPERACION.OPEDD (CODIGON, CODIGOC, DESCRIPCION, TIPOPEDD, CODIGON_AUX)
values (123,'TPI_Mas', 'TPI CDMA Pucallpa', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'TIPOS_LINEAS'), 1);

insert into OPERACION.OPEDD (CODIGON, CODIGOC, DESCRIPCION, TIPOPEDD, CODIGON_AUX)
values (161,'TPI_Mas', 'TPI CDMA Tacna', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'TIPOS_LINEAS'), 1);

insert into OPERACION.OPEDD (CODIGON, CODIGOC, DESCRIPCION, TIPOPEDD, CODIGON_AUX)
values (153,'TPI_Mas', 'TPI CDMA Trujillo', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'TIPOS_LINEAS'), 1);

insert into OPERACION.OPEDD (CODIGON, CODIGOC, DESCRIPCION, TIPOPEDD, CODIGON_AUX)
values (110,'TPI_Mas', 'TPI Chiclayo', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'TIPOS_LINEAS'), 1);

insert into OPERACION.OPEDD (CODIGON, CODIGOC, DESCRIPCION, TIPOPEDD, CODIGON_AUX)
values (180,'TPI_Mas', 'TPI GSM Automatico', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'TIPOS_LINEAS'), 1);

insert into OPERACION.OPEDD (CODIGON, CODIGOC, DESCRIPCION, TIPOPEDD, CODIGON_AUX)
values (106,'TPI_Mas', 'TPI Trujillo', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'TIPOS_LINEAS'), 1);

insert into OPERACION.OPEDD (CODIGON, CODIGOC, DESCRIPCION, TIPOPEDD, CODIGON_AUX)
values (185,'TPI_Mas', 'TPIs Chimbote', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'TIPOS_LINEAS'), 1);

insert into OPERACION.OPEDD (CODIGON, CODIGOC, DESCRIPCION, TIPOPEDD, CODIGON_AUX)
values (118,'TPI_Mas', 'TPIs Huancayo', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'TIPOS_LINEAS'), 1);

insert into OPERACION.OPEDD (CODIGON, CODIGOC, DESCRIPCION, TIPOPEDD, CODIGON_AUX)
values (95,'TPI_Mas', 'TPIs Lima VoCable', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'TIPOS_LINEAS'), 1);

insert into OPERACION.OPEDD (CODIGON, CODIGOC, DESCRIPCION, TIPOPEDD, CODIGON_AUX)
values (130,'TPI_Mas', 'TPIs Lima VoCable Automatico', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'TIPOS_LINEAS'), 1);

insert into OPERACION.OPEDD (CODIGON, CODIGOC, DESCRIPCION, TIPOPEDD, CODIGON_AUX)
values (85,'TPI_Mas', 'TPIs Lima WIMax', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'TIPOS_LINEAS'), 1);

insert into OPERACION.OPEDD (CODIGON, CODIGOC, DESCRIPCION, TIPOPEDD, CODIGON_AUX)
values (93,'TPI_Mas', 'TPIs Piura', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'TIPOS_LINEAS'), 1);

insert into OPERACION.OPEDD (CODIGON, CODIGOC, DESCRIPCION, TIPOPEDD, CODIGON_AUX)
values (164,'HFC_Corp', 'Central Virtual Automatico', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'TIPOS_LINEAS'), 1);

insert into OPERACION.OPEDD (CODIGON, CODIGOC, DESCRIPCION, TIPOPEDD, CODIGON_AUX)
values (177,'HFC_Corp', 'Central Virtual Manual', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'TIPOS_LINEAS'), 1);

insert into OPERACION.TIPOPEDD (DESCRIPCION, ABREV)
values ('Dias Config. Liberacion Lineas', 'DIAS_CONFIG_LIBERACION');

insert into OPERACION.OPEDD (CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (90, 'Dias Desactivacion', 'DIAS_DESACTIVACION', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'DIAS_CONFIG_LIBERACION'), 1);

insert into OPERACION.OPEDD (CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (180, 'Dias desactivacion uso prohibido penal', 'DIAS_PROHIBIDO_PENAL', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'DIAS_CONFIG_LIBERACION'), 1);

insert into OPERACION.OPEDD (CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (30, 'Dias para SOT ANULADA', 'SOT_ANULADA', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'DIAS_CONFIG_LIBERACION'), 1);

insert into OPERACION.OPEDD (CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (180, 'Dias para SOT RECHAZADA', 'SOT_RECHAZADA', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'DIAS_CONFIG_LIBERACION'), 1);

insert into OPERACION.TIPOPEDD (DESCRIPCION, ABREV)
values ('Configuracion de Liberacion', 'CONFIG_LIB');

insert into OPERACION.OPEDD (CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (1, 'Liberacion Masivo', 'LIB_MASIVO', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'CONFIG_LIB'), 1);

insert into OPERACION.OPEDD (CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (2, 'Liberacion Corporativo', 'LIB_CORPORATIVO', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'CONFIG_LIB'), 1);

COMMIT
/