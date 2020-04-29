--Creacion Tareas

INSERT INTO OPEWF.TAREADEF (TAREADEF, DESCRIPCION, PRE_PROC, CHG_PROC, TIPO)
VALUES ((SELECT MAX(a.tareadef) + 1 FROM tareadef a),'Activacion - Lineas Control', 'OPERACION.PQ_INT_TELEFONIA.ALTA', 'OPERACION.PQ_INT_TELEFONIA.CHG_ALTA', 0);

INSERT INTO OPEWF.TAREADEF (TAREADEF, DESCRIPCION, PRE_PROC, CHG_PROC, TIPO)
VALUES ((SELECT MAX(a.tareadef) + 1 FROM tareadef a), 'Desactivacion - Lineas Control', 'OPERACION.PQ_INT_TELEFONIA.BAJA', 'OPERACION.PQ_INT_TELEFONIA.CHG_BAJA', 0);

INSERT INTO OPEWF.TAREADEF (TAREADEF, DESCRIPCION, PRE_PROC, CHG_PROC, TIPO)
VALUES ((SELECT MAX(a.tareadef) + 1 FROM tareadef a), 'Cambio de Plan - Lineas Control', 'OPERACION.PQ_INT_TELEFONIA.CAMBIO_PLAN', 'OPERACION.PQ_INT_TELEFONIA.CHG_CAMBIO_PLAN', 0);

INSERT INTO OPEWF.TAREADEF (TAREADEF, DESCRIPCION, PRE_PROC, CHG_PROC, TIPO)
VALUES ((SELECT MAX(a.tareadef) + 1 FROM tareadef a), 'Traslado Externo - Lineas Control', 'OPERACION.PQ_JANUS_TRASLADO_EXTERNO.EXECUTE', null, 0);

INSERT INTO OPEWF.TAREADEF (TAREADEF, DESCRIPCION, PRE_PROC, CHG_PROC, TIPO)
VALUES ((SELECT MAX(a.tareadef) + 1 FROM tareadef a), 'Verificacion de Transaccion en JANUS', 'OPERACION.PQ_JANUS_UTL.CERRAR_TAREA_VALIDA_JANUS', 'OPERACION.PQ_JANUS_PROCESOS.VALIDA_TX_JANUS', 0);

INSERT INTO OPEWF.TAREADEF (TAREADEF, DESCRIPCION, POS_PROC, TIPO)
VALUES ((SELECT MAX(a.tareadef) + 1 FROM tareadef a), 'Suspension en Plataforma Telefonica Janus','OPERACION.PQ_PLATAFORMA_JANUS.P_SUSPENSION_JANUS',0);


INSERT INTO OPEWF.TAREADEF (TAREADEF, DESCRIPCION, POS_PROC, TIPO)
VALUES ((SELECT MAX(a.tareadef) + 1 FROM tareadef a), 'Reconexion en Plataforma Telefónica Janus', 'OPERACION.PQ_PLATAFORMA_JANUS.P_RECONEXION_JANUS',0);

INSERT INTO OPEWF.TAREADEF (TAREADEF, DESCRIPCION, POS_PROC,  TIPO)
VALUES ((SELECT MAX(a.tareadef) + 1 FROM tareadef a), 'Corte en Plataforma Telefónica Janus', 'OPERACION.PQ_PLATAFORMA_JANUS.P_CORTE_JANUS',  0);

--Creacion de variables en Tipos y Estados

--PLATAFORMA JANUS
INSERT INTO OPERACION.TIPOPEDD (descripcion, abrev)
VALUES ('PLATAFORMA JANUS','PLAT_JANUS');

INSERT INTO OPERACION.OPEDD(codigoc, codigon, descripcion, tipopedd, abreviacion)
VALUES ('WS',1,'WS', (SELECT a.tipopedd FROM operacion.tipopedd a WHERE upper(a.abrev) = 'PLAT_JANUS'),'CONEXION_TELLIN');

INSERT INTO OPERACION.OPEDD(codigoc, codigon, descripcion, tipopedd, abreviacion)
VALUES ('MOCK',0,'OBJETO SIMULADO', (SELECT a.tipopedd FROM operacion.tipopedd a WHERE upper(a.abrev) = 'PLAT_JANUS'), 'CONEXION_JANUS');

INSERT INTO OPERACION.OPEDD(codigoc, codigon, descripcion, tipopedd, abreviacion)
VALUES ('DBLINK',0,'DBLINK', (SELECT a.tipopedd FROM operacion.tipopedd a WHERE upper(a.abrev) = 'PLAT_JANUS'), 'CONEXION_JANUS');

INSERT INTO OPERACION.OPEDD(codigoc, codigon, descripcion, tipopedd, abreviacion)
VALUES ('WS',1,'WS', (SELECT a.tipopedd FROM operacion.tipopedd a WHERE upper(a.abrev) = 'PLAT_JANUS'), 'CONEXION_JANUS');

INSERT INTO OPERACION.OPEDD(codigoc, codigon, descripcion, tipopedd, abreviacion)
VALUES ('MOCK',0,'OBJETO SIMULADO', (SELECT a.tipopedd FROM operacion.tipopedd a WHERE upper(a.abrev) = 'PLAT_JANUS'),'CONEXION_TELLIN');

INSERT INTO OPERACION.OPEDD(codigoc, codigon, descripcion, tipopedd, abreviacion)
VALUES ('OK',1,'http://172.19.74.68:8903/dsEjecutaAccionesFija/ebsdsEjecutaAccionesFijaSB11?wsdl', (SELECT a.tipopedd FROM operacion.tipopedd a WHERE upper(a.abrev) = 'PLAT_JANUS'),'URL_JANUS');

INSERT INTO OPERACION.OPEDD(codigoc, codigon, descripcion, tipopedd, abreviacion)
VALUES ('MOCK TIMED OUT',0,'http://10.244.28.199/IntrawayWS/server.php', (SELECT a.tipopedd FROM operacion.tipopedd a WHERE upper(a.abrev) = 'PLAT_JANUS'),'URL_JANUS');

--BSCS-reenvío Plat. Telefónica
INSERT INTO OPERACION.TIPOPEDD (descripcion, abrev)
VALUES ('BSCS-REENVIO_PLAT_TELEFÓNICA','BSCS_SHELL_PLAT_TEL');

INSERT INTO OPERACION.OPEDD( codigon, descripcion, tipopedd, abreviacion)
VALUES (5,'Cantidad Reenvios Solicitudes  a BSCS ', (SELECT a.tipopedd FROM operacion.tipopedd a WHERE upper(a.abrev) = 'BSCS_SHELL_PLAT_TEL'), 'BSCS_CANT_ENVIO');

INSERT INTO OPERACION.OPEDD( codigon, descripcion,tipopedd , abreviacion)
VALUES (24,'Cantidad Horas Permitida sin Cerrar  Tareas JANUS', (SELECT a.tipopedd FROM operacion.tipopedd a WHERE upper(a.abrev) = 'BSCS_SHELL_PLAT_TEL'), 'HORAS_SIN_CERRAR_TAREA_JANUS');

INSERT INTO OPERACION.OPEDD( tipopedd, abreviacion)
VALUES ( (SELECT a.tipopedd FROM operacion.tipopedd a WHERE upper(a.abrev) = 'BSCS_SHELL_PLAT_TEL'), 'BSCS_CORREO_SOPRTE');

INSERT INTO OPERACION.OPEDD( tipopedd, abreviacion)
VALUES ( (SELECT a.tipopedd FROM operacion.tipopedd a WHERE upper(a.abrev) = 'BSCS_SHELL_PLAT_TEL'), 'CORREO_CERRAR_TAREA_JANUS');

--JANUS-Tarea verificación TX
INSERT INTO OPERACION.TIPOPEDD (descripcion, abrev)
VALUES ('JANUS-TAREA_VERIFICACION_TX','JANUS_VERIFICA_TX');

INSERT INTO OPERACION.OPEDD( codigon,descripcion, tipopedd, abreviacion)
VALUES ( (SELECT tareadef FROM tareadef  WHERE descripcion = 'Verificacion de Transaccion en JANUS' ),'Tarea Verificacion Transaccion en JANUS', (SELECT a.tipopedd FROM operacion.tipopedd a WHERE upper(a.abrev) = 'JANUS_VERIFICA_TX'), 'JANUS_VERIFICA_TX');

--OPERACION_JANUS
INSERT INTO OPERACION.TIPOPEDD (descripcion, abrev)
VALUES ('OPERACION_JANUS','JANUS_OPE');

INSERT INTO OPERACION.OPEDD(codigoc, codigon,descripcion, tipopedd, abreviacion)
VALUES ('CORTE',3, 'Operacion de Corte',(SELECT a.tipopedd FROM operacion.tipopedd a WHERE upper(a.abrev) = 'JANUS_OPE'), 'JANUS_CORT');

INSERT INTO OPERACION.OPEDD(codigoc, codigon,descripcion, tipopedd, abreviacion)
VALUES ('IMSI', NULL, 'Codigo IMSI', (SELECT a.tipopedd FROM operacion.tipopedd a WHERE upper(a.abrev) = 'JANUS_OPE'), 'JANUS_IMSI');

INSERT INTO OPERACION.OPEDD(codigoc, codigon,descripcion, tipopedd, abreviacion)
VALUES ('RECONEXION',4, 'Operacion de Reconexion',(SELECT a.tipopedd FROM operacion.tipopedd a WHERE upper(a.abrev) = 'JANUS_OPE'), 'JANUS_RECN');

INSERT INTO OPERACION.OPEDD(codigoc, codigon,descripcion, tipopedd, abreviacion)
VALUES ('JANUS',4, 'TRANS JANUS',(SELECT a.tipopedd FROM operacion.tipopedd a WHERE upper(a.abrev) = 'JANUS_OPE'), 'JANUS');

INSERT INTO OPERACION.OPEDD(codigoc, codigon,descripcion, tipopedd, abreviacion)
VALUES ('SUSPENSION', 4, 'Operacion de Suspension',(SELECT a.tipopedd FROM operacion.tipopedd a WHERE upper(a.abrev) = 'JANUS_OPE'), 'JANUS_SUSP');

INSERT INTO OPERACION.OPEDD(codigoc, codigon,descripcion, tipopedd, abreviacion)
VALUES ('OK',NULL,'OK janus', (SELECT a.tipopedd FROM operacion.tipopedd a WHERE upper(a.abrev) = 'JANUS_OPE'), 'OKJANUS');

--JANUS-WF_SOT_RECHAZO
INSERT INTO OPERACION.TIPOPEDD (descripcion, abrev)
VALUES ('JANUS-WF_SOT_RECHAZO','JANUS_SOT_RECHAZO');

INSERT INTO OPERACION.OPEDD(codigon, descripcion, tipopedd, abreviacion)
VALUES (1024,'WF Alta de servicios HFC', (SELECT a.tipopedd FROM operacion.tipopedd a WHERE upper(a.abrev) = 'JANUS_SOT_RECHAZO'), 'ALTA_HFC');

INSERT INTO OPERACION.OPEDD(codigon, descripcion, tipopedd, abreviacion)
VALUES (807,'WF baja de servicios HFC', (SELECT a.tipopedd FROM operacion.tipopedd a WHERE upper(a.abrev) = 'JANUS_SOT_RECHAZO'), 'BAJA_HFC');

INSERT INTO OPERACION.OPEDD(codigon, descripcion, tipopedd, abreviacion)
VALUES (790, 'WF Cambio de Plan HFC', (SELECT a.tipopedd FROM operacion.tipopedd a WHERE upper(a.abrev) = 'JANUS_SOT_RECHAZO'), 'CAMBIO_PLAN_HFC');

INSERT INTO OPERACION.OPEDD(codigon, descripcion, tipopedd, abreviacion)
VALUES (1129, 'WF Traslado Externo HFC', (SELECT a.tipopedd FROM operacion.tipopedd a WHERE upper(a.abrev) = 'JANUS_SOT_RECHAZO'), 'TRASLADO_EXTERNO_HFC');

INSERT INTO OPERACION.OPEDD(descripcion, tipopedd, abreviacion)
VALUES ('WF Suspension HFC',(SELECT a.tipopedd FROM operacion.tipopedd a WHERE upper(a.abrev) = 'JANUS_SOT_RECHAZO'), 'SUSPENSION_HFC');

INSERT INTO OPERACION.OPEDD(descripcion, tipopedd, abreviacion)
VALUES ('WF Reconexion HFC', (SELECT a.tipopedd FROM operacion.tipopedd a WHERE upper(a.abrev) = 'JANUS_SOT_RECHAZO'), 'RECONEXION_HFC');

INSERT INTO OPERACION.OPEDD(descripcion, tipopedd, abreviacion)
VALUES ('WF Corte HFC', (SELECT a.tipopedd FROM operacion.tipopedd a WHERE upper(a.abrev) = 'JANUS_SOT_RECHAZO'), 'CORTE_HFC');


commit;


