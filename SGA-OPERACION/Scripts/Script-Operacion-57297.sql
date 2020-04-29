
DECLARE
  ln_count                NUMBER;

BEGIN
    ln_count  := 0;

    SELECT COUNT(*) INTO  ln_count  FROM operacion.tipopedd  WHERE abrev = 'BOUQUET_DTH_MSG';

    IF  ln_count  = 0 THEN

          -- CONFIGURACION DE MENSAJES BOUQUET DTH
          insert into tipopedd values(NULL,'Configuración de mensajes.','BOUQUET_DTH_MSG' );
               
           INSERT INTO opedd (IDOPEDD, CODIGOC, DESCRIPCION, TIPOPEDD)
           VALUES (NULL,'ENVIO_FTP_OK','Se procedió a realizar el envío a CONAX de manera exitosa.',(SELECT tipopedd FROM tipopedd WHERE abrev = 'BOUQUET_DTH_MSG'));
            INSERT INTO opedd (IDOPEDD, CODIGOC, DESCRIPCION, TIPOPEDD)
           VALUES (NULL,'CREA_FTP_OK','Se procedió a crear el archivo en el FTP de manera exitosa.',(SELECT tipopedd FROM tipopedd WHERE abrev = 'BOUQUET_DTH_MSG'));            
            INSERT INTO opedd (IDOPEDD, CODIGOC, DESCRIPCION, TIPOPEDD)
           VALUES (NULL,'SUPERO_ENVIOS','Superó el máximo de envíos.',(SELECT tipopedd FROM tipopedd WHERE abrev = 'BOUQUET_DTH_MSG'));
            INSERT INTO opedd (IDOPEDD, CODIGOC, DESCRIPCION, TIPOPEDD)
           VALUES (NULL,'NO_EXISTE_TARJETA','Código de tarjeta no existe en inventario de equipos.',(SELECT tipopedd FROM tipopedd WHERE abrev = 'BOUQUET_DTH_MSG'));
            INSERT INTO opedd (IDOPEDD, CODIGOC, DESCRIPCION, TIPOPEDD)
           VALUES (NULL,'ENVIO_FTP_ERROR','Hubo un inconveniente con la operación, favor comuníquese con el personal de soporte del aplicativo.',(SELECT tipopedd FROM tipopedd WHERE abrev = 'BOUQUET_DTH_MSG'));
            INSERT INTO opedd (IDOPEDD, CODIGOC, DESCRIPCION, TIPOPEDD)
           VALUES (NULL,'ACTUALIZAR_FTP_OK','Se procedió a realizar la consulta de la respuesta de CONAX de manera exitosa.',(SELECT tipopedd FROM tipopedd WHERE abrev = 'BOUQUET_DTH_MSG'));
            INSERT INTO opedd (IDOPEDD, CODIGOC, DESCRIPCION, TIPOPEDD)
           VALUES (NULL,'ACTUALIZAR_FTP_ERROR','Hubo un inconveniente con la operación, favor comuníquese con el personal de soporte del aplicativo.',(SELECT tipopedd FROM tipopedd WHERE abrev = 'BOUQUET_DTH_MSG'));
            INSERT INTO opedd (IDOPEDD, CODIGOC, DESCRIPCION, TIPOPEDD)
           VALUES (NULL,'FMT_NRO_CARAC','Supero el NRO MAXIMO de caracteres',(SELECT tipopedd FROM tipopedd WHERE abrev = 'BOUQUET_DTH_MSG'));
            INSERT INTO opedd (IDOPEDD, CODIGOC, DESCRIPCION, TIPOPEDD)
           VALUES (NULL,'FMT_ESP_VACIO','Se Identifico ESPACIO EN BLANCO ',(SELECT tipopedd FROM tipopedd WHERE abrev = 'BOUQUET_DTH_MSG'));
            INSERT INTO opedd (IDOPEDD, CODIGOC, DESCRIPCION, TIPOPEDD)
           VALUES (NULL,'FMT_TARJ_01','El NRO TARJETA es INVALIDO, debe empezar 01',(SELECT tipopedd FROM tipopedd WHERE abrev = 'BOUQUET_DTH_MSG'));
    end if ;
    commit;

    ln_count  := 0;

    SELECT COUNT(*) INTO  ln_count  FROM operacion.tipopedd  WHERE abrev = 'BOUQUET_DTH_PARAMETROS';

    IF  ln_count  = 0 THEN

           ------------ CONFIGURACION DE PARAMETROS BOUQUET DTH

            insert into tipopedd values(null,'Configuración de Parámetros','BOUQUET_DTH_PARAMETROS' );
           
            INSERT INTO opedd (IDOPEDD, CODIGOC,CODIGON, DESCRIPCION, TIPOPEDD)
           VALUES (NULL,'MAXIMO_ENVIOS',6,null,(SELECT tipopedd FROM tipopedd WHERE abrev = 'BOUQUET_DTH_PARAMETROS'));   
           INSERT INTO opedd (IDOPEDD, CODIGOC,CODIGON, DESCRIPCION, TIPOPEDD)
           VALUES (NULL,'RANGO_CICLICO',null,'200000-599999',(SELECT tipopedd FROM tipopedd WHERE abrev = 'BOUQUET_DTH_PARAMETROS'));
            INSERT INTO opedd (IDOPEDD, CODIGOC, CODIGON,DESCRIPCION, TIPOPEDD)
           VALUES (NULL,'CANT_TARJETAS',4000,'INDICA CANTIDAD DE TARJETAS POR ARCHIVO',(SELECT tipopedd FROM tipopedd WHERE abrev = 'BOUQUET_DTH_PARAMETROS'));   
		   INSERT INTO opedd (IDOPEDD, CODIGOC, CODIGON,DESCRIPCION, TIPOPEDD)
           VALUES (NULL,'CANTMIN_TARJ',1000,'INDICA CANTIDAD DE TARJETAS PARA PASAR A PRINCIPAL',(SELECT tipopedd FROM tipopedd WHERE abrev = 'BOUQUET_DTH_PARAMETROS'));   
     end if ;
    commit;      

    ln_count  := 0;

    SELECT COUNT(*) INTO  ln_count  FROM operacion.tipopedd  WHERE abrev = 'BOUQUET_DTH_ESTADO';

    IF  ln_count  = 0 THEN
           ------------ CONFIGURACION DE ESTADOS BOUQUET DTH

            insert into tipopedd values(null,'Configuración de Estados','BOUQUET_DTH_ESTADO' );
           
            INSERT INTO opedd (IDOPEDD, CODIGON, DESCRIPCION, TIPOPEDD)
           VALUES (NULL,1,'REGISTRADO',(SELECT tipopedd FROM tipopedd WHERE abrev = 'BOUQUET_DTH_ESTADO'));   
            INSERT INTO opedd (IDOPEDD, CODIGON, DESCRIPCION, TIPOPEDD)
           VALUES (NULL,2,'ENVIADO',(SELECT tipopedd FROM tipopedd WHERE abrev = 'BOUQUET_DTH_ESTADO'));   
            INSERT INTO opedd (IDOPEDD, CODIGON, DESCRIPCION, TIPOPEDD)
           VALUES (NULL,3,'PENDIENTE',(SELECT tipopedd FROM tipopedd WHERE abrev = 'BOUQUET_DTH_ESTADO'));   
            INSERT INTO opedd (IDOPEDD, CODIGON, DESCRIPCION, TIPOPEDD)
           VALUES (NULL,4,'ERROR',(SELECT tipopedd FROM tipopedd WHERE abrev = 'BOUQUET_DTH_ESTADO'));   
            INSERT INTO opedd (IDOPEDD, CODIGON, DESCRIPCION, TIPOPEDD)
           VALUES (NULL,5,'OK',(SELECT tipopedd FROM tipopedd WHERE abrev = 'BOUQUET_DTH_ESTADO'));   
            INSERT INTO opedd (IDOPEDD, CODIGON, DESCRIPCION, TIPOPEDD)
           VALUES (NULL,6,'PROCESADO PARCIAL',(SELECT tipopedd FROM tipopedd WHERE abrev = 'BOUQUET_DTH_ESTADO'));   
            INSERT INTO opedd (IDOPEDD, CODIGON, DESCRIPCION, TIPOPEDD)
           VALUES (NULL,7,'PROCESADO TOTAL',(SELECT tipopedd FROM tipopedd WHERE abrev = 'BOUQUET_DTH_ESTADO'));   
     end if ;
    commit;    
            
    ln_count  := 0;

    SELECT COUNT(*) INTO  ln_count  FROM operacion.tipopedd  WHERE abrev = 'CORREO_SOAP_BOUQUET_DTH';

    IF  ln_count  = 0 THEN
            -------------------------- LISTA DE CORREOS AL SOAP POR FALLA AL EJECUTAR SHELL
              insert into tipopedd values(null,'Lista de Correos ','CORREO_SOAP_BOUQUET_DTH' );
           
            INSERT INTO opedd (IDOPEDD,CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
           VALUES (NULL,'TO_MAIL',1,'sramos.cosapisoft@claro.com.pe', 'SUSANA RAMOS',(SELECT tipopedd FROM tipopedd WHERE abrev = 'CORREO_SOAP_BOUQUET_DTH'));   
            INSERT INTO opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
           VALUES (NULL,'CC_MAIL',1,'guzmaner@globalhitss.com', 'EMMA GUZMAN',(SELECT tipopedd FROM tipopedd WHERE abrev = 'CORREO_SOAP_BOUQUET_DTH'));   
      end if ;
    commit;  

    ln_count  := 0;

    SELECT COUNT(*) INTO  ln_count  FROM operacion.tipopedd  WHERE abrev = 'BOUQUET_TIPEQU';

    IF  ln_count  = 0 THEN
            -------------------------- LISTA DE CODIGOS DE TIPO DE EQUIPOS PARA CONSULTA BOUQUET DTH

            insert into tipopedd values(NULL,'tipo equipo para consultas DTH','BOUQUET_TIPEQU' );           
           
            INSERT INTO opedd (IDOPEDD, CODIGON, DESCRIPCION, TIPOPEDD)
           VALUES (NULL,7242,'TARJETAS',(SELECT tipopedd FROM tipopedd WHERE abrev = 'BOUQUET_TIPEQU'));
    end if ;
    commit; 

	
    ln_count  := 0;

    SELECT COUNT(*) INTO  ln_count  FROM operacion.tipopedd  WHERE abrev = 'PERCARMASTARJ';

    IF  ln_count  = 0 THEN
            -------------------------- PERFILES CON ACCESO A LA CARGA MASIVA
            insert into tipopedd values(NULL,'Perfiles Acceso a Carga Masiva','PERCARMASTARJ') ;           
           
            INSERT INTO opedd (IDOPEDD, CODIGOC, DESCRIPCION, TIPOPEDD)
           VALUES (NULL,'OPERA','OPERACIONES - ATC',(SELECT tipopedd FROM tipopedd WHERE abrev = 'PERCARMASTARJ'));
    end if ;
    commit; 
END;
/