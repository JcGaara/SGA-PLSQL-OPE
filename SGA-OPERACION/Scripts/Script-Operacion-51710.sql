
--1. CREACION DE TAREA
  INSERT INTO OPEWF.TAREADEF (TAREADEF, DESCRIPCION, PRE_PROC, CHG_PROC, TIPO)
  VALUES ((SELECT MAX(a.tareadef) + 1 FROM tareadef a),'Activacion - Lineas Control CE', 'OPERACION.PQ_TELEFONIA_CE.ALTA', 'OPERACION.PQ_JANUS_CE_PROCESOS.CERRAR_TAREA_LINEA_C', 0);

  INSERT INTO OPEWF.TAREADEF (TAREADEF, DESCRIPCION, PRE_PROC, CHG_PROC, TIPO)
  VALUES ((SELECT MAX(a.tareadef) + 1 FROM tareadef a), 'Desactivacion - Lineas Control CE', 'OPERACION.PQ_TELEFONIA_CE.BAJA', 'OPERACION.PQ_JANUS_CE_PROCESOS.CERRAR_TAREA_LINEA_C', 0);

--2. CREACION DE TIPOS Y ESTADOS
--2.1  Plataforma Janus CE
  INSERT INTO tipopedd (descripcion, abrev)
  VALUES ( 'PLATAFORMA_JANUS_CE', 'PLAT_JANUS_CE');

  INSERT INTO OPERACION.OPEDD(codigoc, codigon, descripcion, tipopedd, abreviacion)
  VALUES ('WS',1,'WS', (SELECT a.tipopedd FROM operacion.tipopedd a WHERE upper(a.abrev) = 'PLAT_JANUS_CE'),'CONEXION_JANUS');
  
  INSERT INTO OPERACION.OPEDD(codigoc, codigon, descripcion, tipopedd, abreviacion)
  VALUES ('MOCK',0,'OBJETO SIMULADO', (SELECT a.tipopedd FROM operacion.tipopedd a WHERE upper(a.abrev) = 'PLAT_JANUS_CE'),'CONEXION_JANUS');
  
  INSERT INTO OPERACION.OPEDD(codigoc, codigon, descripcion, tipopedd, abreviacion)
  VALUES ('OK',1,'http://172.19.74.67:8903/dsEjecutaAccionesFija/ebsdsEjecutaAccionesFijaSB11?WSDL', (SELECT a.tipopedd FROM operacion.tipopedd a WHERE upper(a.abrev) = 'PLAT_JANUS_CE'),'URL_JANUS');

  INSERT INTO OPERACION.OPEDD(codigoc, codigon, descripcion, tipopedd, abreviacion)
  VALUES ('OK',1,'http://claro.com.pe/eai/ebs/ws/dsEjecutaAccionesFija/ejecutarAccionesFija/', (SELECT a.tipopedd FROM operacion.tipopedd a WHERE upper(a.abrev) = 'PLAT_JANUS_CE'),'URL_JANUS_METODO');
  
   INSERT INTO OPERACION.OPEDD( codigon, descripcion, tipopedd, abreviacion)
   VALUES (200,'LONGITUD DEL DATO DIRSUC', (SELECT a.tipopedd FROM operacion.tipopedd a WHERE upper(a.abrev) = 'PLAT_JANUS_CE'),'DIRSUC');
   
   INSERT INTO OPERACION.OPEDD( codigon, descripcion, tipopedd, abreviacion)
   VALUES (200,'LONGITUD DEL DATO REFERENCIA', (SELECT a.tipopedd FROM operacion.tipopedd a WHERE upper(a.abrev) = 'PLAT_JANUS_CE'),'REFERENCIA');
  
  
--2.2 CONSTANTES DE PROCESO

  INSERT INTO tipopedd (descripcion, abrev)
  VALUES ( 'BSCS-REENVIO_PLAT_TEL_CORP', 'BSCS_SHELL_PLAT_TEL_CE');
  
  INSERT INTO OPERACION.OPEDD( codigon, descripcion, tipopedd, abreviacion)
  VALUES (5,'Cantidad Reenvios Solicitudes  a BSCS ', (SELECT a.tipopedd FROM operacion.tipopedd a WHERE upper(a.abrev) = 'BSCS_SHELL_PLAT_TEL_CE'), 'BSCS_CANT_ENVIO');

  INSERT INTO OPERACION.OPEDD( codigon, descripcion,tipopedd , abreviacion)
  VALUES (24,'Cantidad Horas Permitida sin Cerrar  Tareas JANUS', (SELECT a.tipopedd FROM operacion.tipopedd a WHERE upper(a.abrev) = 'BSCS_SHELL_PLAT_TEL_CE'), 'HORAS_SIN_CERRAR_TAREA_JANUS');

  INSERT INTO OPERACION.OPEDD( tipopedd, abreviacion)
  VALUES ( (SELECT a.tipopedd FROM operacion.tipopedd a WHERE upper(a.abrev) = 'BSCS_SHELL_PLAT_TEL_CE'), 'BSCS_CORREO_SOPRTE');

  INSERT INTO OPERACION.OPEDD( tipopedd, abreviacion)
  VALUES ( (SELECT a.tipopedd FROM operacion.tipopedd a WHERE upper(a.abrev) = 'BSCS_SHELL_PLAT_TEL_CE'), 'CORREO_CERRAR_TAREA_JANUS');
  
-- 3.3 TIPSRV HFC CE

  INSERT INTO tipopedd (descripcion, abrev)
  VALUES ( 'TIPOS_SERVICIOS_JANUS_CE', 'TIPSRV_JANUS_CE');
  
  INSERT INTO OPERACION.OPEDD(  codigoc,descripcion, tipopedd, abreviacion)
  VALUES ('0073','HFC CE' ,(SELECT a.tipopedd FROM operacion.tipopedd a WHERE upper(a.abrev) = 'TIPSRV_JANUS_CE'), 'FAMILIA');
  
  COMMIT;
 
