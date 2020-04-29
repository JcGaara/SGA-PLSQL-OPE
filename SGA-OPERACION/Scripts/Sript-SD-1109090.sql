--SCRIPT INSTALAR

-- add tipos y estado metodo ws
INSERT INTO OPERACION.OPEDD
  (codigoc, codigon, descripcion, tipopedd, abreviacion)
VALUES
  ('WS',  1,
   'http://claro.com.pe/eai/ebs/ws/dsEjecutaAccionesFija/ejecutarAccionesFija/',
   (SELECT a.tipopedd FROM operacion.tipopedd a  WHERE upper(a.abrev) = 'PLAT_JANUS'), 'URL_JANUS_METODO');

--add campo para xml de envío
ALTER TABLE OPERACION.INT_TELEFONIA_LOG ADD WS_XML VARCHAR2(4000);
COMMENT ON COLUMN OPERACION.INT_TELEFONIA_LOG.WS_XML
  IS 'XML DE ENVIO WS';
  
COMMIT;
