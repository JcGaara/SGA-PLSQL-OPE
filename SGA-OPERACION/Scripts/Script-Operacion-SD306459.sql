-- Portabilidad Validacion
-- Agregar detalle de parametros
insert into opedd
  (idopedd, codigoc, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
values
  (null,
   null,
   1,
   'Permite eliminar el detalle de la venta de un proyecto portable',
   'eliminar_detalle_porta',
   (select t.tipopedd from tipopedd t where t.abrev = 'portabilidad_validacion'),
   null);

insert into opedd
  (idopedd, codigoc, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
values
  (null,
   null,
   1,
   'Permite Validar si ha generado SEC',
   'validar_generar_sec',
   (select t.tipopedd from tipopedd t where t.abrev = 'portabilidad_validacion'),
   null);

commit;
