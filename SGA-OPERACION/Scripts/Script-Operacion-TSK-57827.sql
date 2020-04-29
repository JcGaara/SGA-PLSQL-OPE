/*INGRESANDO ESTADOS PAREO*/
INSERT INTO ATCCORP.ATC_ESTADO_PAREO VALUES(0,'REGISTRADO',UPPER('Afecta SOLICITUDES PAREO y FILE PAREO'));
COMMIT;
INSERT INTO ATCCORP.ATC_ESTADO_PAREO VALUES(1,'ENVIADO',UPPER('Afecta SOLICITUDES PAREO y FILE PAREO'));
COMMIT;
INSERT INTO ATCCORP.ATC_ESTADO_PAREO VALUES(2,'OK',UPPER('Afecta solo a FILE PAR'));
COMMIT;
INSERT INTO ATCCORP.ATC_ESTADO_PAREO VALUES(3,'ERROR',UPPER('Afecta solo a FILE PAR'));
COMMIT;
INSERT INTO ATCCORP.ATC_ESTADO_PAREO VALUES(4,'PROCESADO PARCIAL',UPPER('Afecta solo a SOLICITUDES PAREO'));
COMMIT;
INSERT INTO ATCCORP.ATC_ESTADO_PAREO VALUES(5,'PROCESADO TOTAL',UPPER('Afecta solo a SOLICITUDES PAREO'));
COMMIT;
/*CONFIGURACION PARAMETROS DTH*/
DECLARE 
 l_tipopedd NUMBER;
 l_opedd    NUMBER;
BEGIN

  SELECT MAX(tpp.tipopedd)+1 INTO l_tipopedd FROM TIPOPEDD tpp;
  INSERT INTO TIPOPEDD VALUES(l_tipopedd,'Parametros DTH','PARAM_DTH');
  COMMIT;
  
  SELECT MAX(opd.IDOPEDD)+1 INTO l_opedd FROM OPEDD opd;
  
  INSERT INTO OPEDD (TIPOPEDD,IDOPEDD,CODIGOC,DESCRIPCION, ABREVIACION) VALUES(l_tipopedd,l_opedd,'DirectorioLocal2', '/u03/oracle/PESGAPRD/UTL_FILE', 'DirectorioLocal2');
  COMMIT;

  INSERT INTO OPEDD (TIPOPEDD,IDOPEDD,CODIGOC,DESCRIPCION, ABREVIACION) VALUES(l_tipopedd,l_opedd + 1,'Ruta de Know Host', '/home/oracle/.ssh/known_hosts', 'RUT_KH');
  COMMIT;
  
  INSERT INTO OPEDD (TIPOPEDD,IDOPEDD,CODIGOC,DESCRIPCION, ABREVIACION) VALUES(l_tipopedd,l_opedd + 2,'Host', '10.245.23.41', 'HOST');
  COMMIT;  
  
  INSERT INTO OPEDD (TIPOPEDD,IDOPEDD,CODIGOC,DESCRIPCION, ABREVIACION) VALUES(l_tipopedd,l_opedd + 3,'Usuario', 'peru', 'USUARIO');
  COMMIT;  

  INSERT INTO OPEDD (TIPOPEDD,IDOPEDD,CODIGOC,DESCRIPCION, ABREVIACION) VALUES(l_tipopedd,l_opedd + 4,'Clave', 'peru', 'CLAVE');
  COMMIT;  

  INSERT INTO OPEDD (TIPOPEDD,IDOPEDD,CODIGOC,DESCRIPCION, ABREVIACION) VALUES(l_tipopedd,l_opedd + 5,'Idrsa.RSA', '/home/oracle/.ssh/id_rsa', 'IDRSA');
  COMMIT;

  INSERT INTO OPEDD (TIPOPEDD,IDOPEDD,CODIGOC,DESCRIPCION, ABREVIACION) VALUES(l_tipopedd,l_opedd + 6,'Puerto', '22', 'PUERTO');
  COMMIT;

  INSERT INTO OPEDD (TIPOPEDD,IDOPEDD,CODIGOC,DESCRIPCION, ABREVIACION) VALUES(l_tipopedd,l_opedd + 7,'DirectorioLocal', '/u92/oracle/peprdrac1/dth', 'DirectorioLocal');
  COMMIT;

  INSERT INTO OPEDD (TIPOPEDD,IDOPEDD,CODIGOC,DESCRIPCION, ABREVIACION) VALUES(l_tipopedd,l_opedd + 8,'Dir.remoto.Ok', 'autreq/ok/', 'Dir.remoto.Ok');
  COMMIT;

  INSERT INTO OPEDD (TIPOPEDD,IDOPEDD,CODIGOC,DESCRIPCION, ABREVIACION) VALUES(l_tipopedd,l_opedd + 9,'Dir.remoto.Req', 'autreq/req', 'Dir.remoto.Req');
  COMMIT;
  
  INSERT INTO OPEDD (TIPOPEDD,IDOPEDD,CODIGOC,DESCRIPCION, ABREVIACION) VALUES(l_tipopedd,l_opedd + 10,'arch.Error', 'errors.txt', 'arch.Error');
  COMMIT;
  
  INSERT INTO OPEDD (TIPOPEDD,IDOPEDD,CODIGOC,DESCRIPCION, ABREVIACION) VALUES(l_tipopedd,l_opedd + 11,'Dir.arch.Error', 'autreq/err/errors.txt', 'Dir.arch.Error');
  COMMIT;

  INSERT INTO OPEDD (TIPOPEDD,IDOPEDD,CODIGOC,DESCRIPCION, ABREVIACION) VALUES(l_tipopedd,l_opedd + 12,'Dir.arch.Error2', 'aut/err/errors.txt', 'Dir.arch.Error2');
  COMMIT;

  INSERT INTO OPEDD (TIPOPEDD,IDOPEDD,CODIGOC,DESCRIPCION, ABREVIACION) VALUES(l_tipopedd,l_opedd + 13,'Dir.remoto.Error', 'autreq/err/', 'Dir.remoto.Error');
  COMMIT;

  INSERT INTO OPEDD (TIPOPEDD,IDOPEDD,CODIGOC,DESCRIPCION, ABREVIACION) VALUES(l_tipopedd,l_opedd + 14,'Nom.arch.MSN', 'tarjetas.lst', 'Nom.arch.MSN');
  COMMIT;
  
END;
/
/*CONFIGURACION PARAMETROS DTH PAREO*/
DECLARE 
 l_tipopedd NUMBER;
 l_opedd    NUMBER;
BEGIN

  SELECT MAX(tpp.tipopedd)+1 INTO l_tipopedd FROM TIPOPEDD tpp;
  INSERT INTO TIPOPEDD VALUES(l_tipopedd,'Configuración de mensajes.','PAREO_DTH_MSG');
  COMMIT;
  
  SELECT MAX(opd.IDOPEDD)+1 INTO l_opedd FROM OPEDD opd;
  
  INSERT INTO OPEDD (TIPOPEDD,IDOPEDD,CODIGOC,DESCRIPCION) VALUES(l_tipopedd,l_opedd,'ENVIO_FTP_OK','Se procedió a realizar el envío a CONAX de manera exitosa.');
  COMMIT;
  INSERT INTO OPEDD (TIPOPEDD,IDOPEDD,CODIGOC,DESCRIPCION) VALUES(l_tipopedd,l_opedd+1,'SUPERO_ENVIOS','Superó el máximo de envíos.');
  COMMIT;
  INSERT INTO OPEDD (TIPOPEDD,IDOPEDD,CODIGOC,DESCRIPCION) VALUES(l_tipopedd,l_opedd+2,'NO_EXISTE_TARJETA','Código de tarjeta no existe en inventario de equipos.');
  COMMIT;
  INSERT INTO OPEDD (TIPOPEDD,IDOPEDD,CODIGOC,DESCRIPCION) VALUES(l_tipopedd,l_opedd+3,'NO_EXISTE_DECO','Código de decodificador no existe en inventario de equipos.');
  COMMIT;
  INSERT INTO OPEDD (TIPOPEDD,IDOPEDD,CODIGOC,DESCRIPCION) VALUES(l_tipopedd,l_opedd+4,'ENVIO_FTP_ERROR','Hubo un inconveniente con la operación, favor comuníquese con el personal de soporte del aplicativo.');
  COMMIT;
  INSERT INTO OPEDD (TIPOPEDD,IDOPEDD,CODIGOC,DESCRIPCION) VALUES(l_tipopedd,l_opedd+5,'ACTUALIZAR_FTP_OK','Se procedió a realizar la consulta de la respuesta de CONAX de manera exitosa.');
  COMMIT;
  INSERT INTO OPEDD (TIPOPEDD,IDOPEDD,CODIGOC,DESCRIPCION) VALUES(l_tipopedd,l_opedd+6,'ACTUALIZAR_FTP_ERROR','Hubo un inconveniente con la operación, favor comuníquese con el personal de soporte del aplicativo.');
  COMMIT;
  INSERT INTO OPEDD (TIPOPEDD,IDOPEDD,CODIGOC,DESCRIPCION) VALUES(l_tipopedd,l_opedd+7,'FMT_NRO_CARAC','Supero el NRO MAXIMO de caracteres');
  COMMIT;
  INSERT INTO OPEDD (TIPOPEDD,IDOPEDD,CODIGOC,DESCRIPCION) VALUES(l_tipopedd,l_opedd+8,'FMT_ESP_VACIO','Se Identifico ESPACIO EN BLANCO');
  COMMIT;
  INSERT INTO OPEDD (TIPOPEDD,IDOPEDD,CODIGOC,DESCRIPCION) VALUES(l_tipopedd,l_opedd+9,'FMT_TARJ_01','El NRO TARJETA es INVALIDO, debe empezar 01');
  COMMIT;
  INSERT INTO OPEDD (TIPOPEDD,IDOPEDD,CODIGOC,DESCRIPCION) VALUES(l_tipopedd,l_opedd+10,'FMT_DECO_00','El NRO DECODIFICADOR es INVALIDO, debe empezar 00');
  COMMIT;
  INSERT INTO OPEDD (TIPOPEDD,IDOPEDD,CODIGOC,DESCRIPCION) VALUES(l_tipopedd,l_opedd+11,'FMT_DECO_ARI','El NRO DECODIFICADOR es INVALIDO, debe ser del tipo ARION');
  COMMIT;

  SELECT MAX(tpp.tipopedd)+1 INTO l_tipopedd FROM TIPOPEDD tpp;
  INSERT INTO TIPOPEDD VALUES(l_tipopedd,'Configuración de Parámetros','PAREO_DTH_PARAMETROS');
  COMMIT;
  
  SELECT MAX(opd.IDOPEDD)+1 INTO l_opedd FROM OPEDD opd;
  
  INSERT INTO OPEDD (TIPOPEDD,IDOPEDD,CODIGOC,DESCRIPCION) VALUES(l_tipopedd,l_opedd,'RANGO_CICLICO','200000-599999');
  COMMIT;
  INSERT INTO OPEDD (TIPOPEDD,IDOPEDD,CODIGOC,DESCRIPCION) VALUES(l_tipopedd,l_opedd+1,'MAXIMO_ENVIOS','');
  COMMIT;

END;
/
/*CREANDO TYPE*/
  CREATE OR REPLACE TYPE OPERACION.conex_intraway AS OBJECT (
     phost               VARCHAR2(30),
     ppuerto             VARCHAR2(20),
     pusuario            VARCHAR2(20),
     pPass               VARCHAR2(50),
     pDirectorioLocal    VARCHAR2(100),
     pDirectorioLocal2   VARCHAR2(100),
     pArchivoRemotoReq   VARCHAR2(100),
     pArchivoRemotoOK    VARCHAR2(100),
     pArchivoRemotoError VARCHAR2(100),
     p_errors_local      VARCHAR2(100),
     p_errors_remoto     VARCHAR2(100),
     p_errors_remoto2    VARCHAR2(100)
  );
/
