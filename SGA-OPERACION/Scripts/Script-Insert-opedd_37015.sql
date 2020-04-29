--ASOCIATED_INCIDENCE_CNOC asociado para iterrupcion de una derivación

INSERT INTO operacion.opedd ( 
  idopedd,
  codigoc, 
  codigon, 
  descripcion, 
  abreviacion, 
  tipopedd, 
  codigon_aux)
VALUES (
  (select max(operacion.opedd.idopedd) + 1
     from operacion.opedd),
  null,
  1,
  'TELMEX - CORTE',
  null,
  (select operacion.tipopedd.tipopedd 
     from operacion.tipopedd
    where abrev = 'ASOCIATED_INCIDENCE_CNOC'),
  NULL);

INSERT INTO operacion.opedd ( 
  idopedd,
  codigoc, 
  codigon, 
  descripcion, 
  abreviacion, 
  tipopedd, 
  codigon_aux)
VALUES (
  (select max(operacion.opedd.idopedd) + 1
     from operacion.opedd),
  null,
  2,
  'CLIENTE',
  null,
  (select operacion.tipopedd.tipopedd 
     from operacion.tipopedd
    where abrev = 'ASOCIATED_INCIDENCE_CNOC'),
  NULL);
  
  INSERT INTO operacion.opedd ( 
  idopedd,
  codigoc, 
  codigon, 
  descripcion, 
  abreviacion, 
  tipopedd, 
  codigon_aux)
VALUES (
  (select max(operacion.opedd.idopedd) + 1
     from operacion.opedd),
  null,
  6,
  'TELMEX - DEGRADACION',
  null,
  (select operacion.tipopedd.tipopedd 
     from operacion.tipopedd
    where abrev = 'ASOCIATED_INCIDENCE_CNOC'),
  NULL);
  
   INSERT INTO operacion.opedd ( 
  idopedd,
  codigoc, 
  codigon, 
  descripcion, 
  abreviacion, 
  tipopedd, 
  codigon_aux)
VALUES (
  (select max(operacion.opedd.idopedd) + 1
     from operacion.opedd),
  null,
  17,
  'TERCEROS - CORTE',
  null,
  (select operacion.tipopedd.tipopedd 
     from operacion.tipopedd
    where abrev = 'ASOCIATED_INCIDENCE_CNOC'),
  NULL);
  
   INSERT INTO operacion.opedd ( 
  idopedd,
  codigoc, 
  codigon, 
  descripcion, 
  abreviacion, 
  tipopedd, 
  codigon_aux)
VALUES (
  (select max(operacion.opedd.idopedd) + 1
     from operacion.opedd),
  null,
  18,
  'TERCEROS - DEGRADACION',
  null,
  (select operacion.tipopedd.tipopedd 
     from operacion.tipopedd
    where abrev = 'ASOCIATED_INCIDENCE_CNOC'),
  NULL);


--ASOCIATED_INC_INTER_CNOC asociado para iterrupcion en solucionado de una Pausa

INSERT INTO operacion.opedd ( 
  idopedd,
  codigoc, 
  codigon, 
  descripcion, 
  abreviacion, 
  tipopedd, 
  codigon_aux)
VALUES (
  (select max(operacion.opedd.idopedd) + 1
     from operacion.opedd),
  null,
  2,
  'CLIENTE',
  null,
  (select operacion.tipopedd.tipopedd 
     from operacion.tipopedd
    where abrev = 'ASOCIATED_INC_INTER_CNOC'),
  NULL);
  
  INSERT INTO operacion.opedd ( 
  idopedd,
  codigoc, 
  codigon, 
  descripcion, 
  abreviacion, 
  tipopedd, 
  codigon_aux)
VALUES (
  (select max(operacion.opedd.idopedd) + 1
     from operacion.opedd),
  null,
  5,
  'PROVEEDOR',
  null,
  (select operacion.tipopedd.tipopedd 
     from operacion.tipopedd
    where abrev = 'ASOCIATED_INC_INTER_CNOC'),
  NULL);


 INSERT INTO operacion.opedd ( 
  idopedd,
  codigoc, 
  codigon, 
  descripcion, 
  abreviacion, 
  tipopedd, 
  codigon_aux)
VALUES (
  (select max(operacion.opedd.idopedd) + 1
     from operacion.opedd),
  null,
  10,
  'Mantenimiento de PI',
  null,
  (select operacion.tipopedd.tipopedd 
     from operacion.tipopedd
    where abrev = 'ASOCIATED_INC_INTER_CNOC'),
  NULL);
  
  INSERT INTO operacion.opedd ( 
  idopedd,
  codigoc, 
  codigon, 
  descripcion, 
  abreviacion, 
  tipopedd, 
  codigon_aux)
VALUES (
  (select max(operacion.opedd.idopedd) + 1
     from operacion.opedd),
  null,
  11,
  'Mantenimiento de PEX',
  null,
  (select operacion.tipopedd.tipopedd 
     from operacion.tipopedd
    where abrev = 'ASOCIATED_INC_INTER_CNOC'),
  NULL);
  
    INSERT INTO operacion.opedd ( 
  idopedd,
  codigoc, 
  codigon, 
  descripcion, 
  abreviacion, 
  tipopedd, 
  codigon_aux)
VALUES (
  (select max(operacion.opedd.idopedd) + 1
     from operacion.opedd),
  null,
  15,
  'Redes',
  null,
  (select operacion.tipopedd.tipopedd 
     from operacion.tipopedd
    where abrev = 'ASOCIATED_INC_INTER_CNOC'),
  NULL);
 COMMIT;
