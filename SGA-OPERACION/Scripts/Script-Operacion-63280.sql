INSERT INTO operacion.tipopedd (
  tipopedd,
  descripcion,
  abrev )
VALUES (
  (select max(tipopedd) + 1 
     from operacion.tipopedd),
  'Incidencias Padre Hijas',
  'INCIDENCIA_PADRE_HIJA');
COMMIT;

INSERT INTO operacion.opedd ( 
  idopedd,
  codigoc, 
  codigon, 
  descripcion, 
  abreviacion, 
  tipopedd, 
  codigon_aux)
VALUES (
  (select max(operacion.opedd.idopedd) + 1 from operacion.opedd),
  NULL,
  180,
  'Dias Transc',
  'Cantidad de dias transcurridos',
  (SELECT tipopedd from tipopedd where abrev = 'INCIDENCIA_PADRE_HIJA'),
  NULL);

COMMIT;

