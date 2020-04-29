insert into OPERACION.OPEDD
  (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, tipopedd , CODIGON_AUX)
values
  ('LTE', 744,'3', 'INSTALACION', (select t.tipopedd from tipopedd t where t.abrev = 'ESCXTIPTRAXTECNOLOGIA'),1);
  
insert into OPERACION.OPEDD
  (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, tipopedd , CODIGON_AUX)
values
  ('DTH', 485,'4', 'INSTALACION', (select t.tipopedd from tipopedd t where t.abrev = 'ESCXTIPTRAXTECNOLOGIA'),1);

/