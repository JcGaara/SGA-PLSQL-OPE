-- Portabilidad Validacion
-- Agregar detalle de parametros
insert into opedd
  (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values
  (null,
   null,
   1,
   'Liberar Numero en SGA',
   'liberar_num_sga',
   (select t.tipopedd from tipopedd t where t.abrev = 'portabilidad_validacion'),
   null);

commit;
