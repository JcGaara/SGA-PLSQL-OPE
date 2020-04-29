-- Portabilidad Servicios
-- Agregar detalle de parametros
insert into opedd
  (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values
  (null,
   '0004',
   758,
   'ANALOGICO CORPORATIVO',
   'CORPORATIVO',
   (select t.tipopedd from tipopedd t where t.abrev = 'PORTABILIDAD_SERVICIOS'),
   1);

commit;
