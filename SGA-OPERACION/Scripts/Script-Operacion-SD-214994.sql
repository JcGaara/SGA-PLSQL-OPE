-- Habilitar Funcionalidad
-- Creacion de Cabecera
insert into tipopedd
  (TIPOPEDD, DESCRIPCION, ABREV)
values
  (null, 'Habilitacion SOT TPI', 'habilita_sot_tpi');

-- Creacion de Detalle
insert into opedd
  (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values
  (null,
   null,
   1,
   'Validar si existe SOT',
   'validar_sot',
   (select t.tipopedd from tipopedd t where t.abrev = 'habilita_sot_tpi'),
   null);

insert into opedd
  (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values
  (null,
   null,
   1,
   'Desactivar boton grabar',
   'desactivar_boton_grabar',
   (select t.tipopedd from tipopedd t where t.abrev = 'habilita_sot_tpi'),
   null);

commit;
