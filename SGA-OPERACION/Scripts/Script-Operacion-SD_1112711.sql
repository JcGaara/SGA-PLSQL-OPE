--INSERT 
   INSERT INTO OPERACION.OPEDD( codigon, descripcion, tipopedd, abreviacion)
   VALUES (200,'LONGITUD DEL DATO DIRSUC', (SELECT a.tipopedd FROM operacion.tipopedd a WHERE upper(a.abrev) = 'PLAT_JANUS'),'DIRSUC');
   
   INSERT INTO OPERACION.OPEDD( codigon, descripcion, tipopedd, abreviacion)
   VALUES (200,'LONGITUD DEL DATO REFERENCIA', (SELECT a.tipopedd FROM operacion.tipopedd a WHERE upper(a.abrev) = 'PLAT_JANUS'),'REFERENCIA');

COMMIT;
