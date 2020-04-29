INSERT INTO operacion.tipopedd 
(DESCRIPCION, ABREV)
VALUES('WF Para cambios de Estado', 'WF_CHG_TAREA');

UPDATE operacion.opedd
   SET codigon = 0, abreviacion = 'Meses'
 WHERE tipopedd = (SELECT tipopedd FROM operacion.tipopedd WHERE ABREV = 'LICITACION_FECH_FIN')
   AND codigon_aux = 1;
   
UPDATE operacion.opedd
   SET codigon = 1, abreviacion = 'D�as'
 WHERE tipopedd = (SELECT tipopedd FROM operacion.tipopedd WHERE ABREV = 'LICITACION_FECH_FIN')
   AND codigon_aux = 2;
   
COMMIT;
/