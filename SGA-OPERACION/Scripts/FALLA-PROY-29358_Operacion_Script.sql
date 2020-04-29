insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('UTC-5', null, 'ZONA HORARIA', 'ZONA_HORARIA', (SELECT tipopedd FROM operacion.tipopedd WHERE abrev='REQ_RED_MOVIL'));
  
COMMIT;
/
