insert into opedd
  (idopedd, codigoc, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
values
  ((select max(operacion.opedd.idopedd) + 1 from operacion.opedd), null, 427,
   'tipo de trabajo ', 'COD_TIPTRA',
   (select tipopedd from tipopedd where abrev = 'PUN_ANEX_TIP'), null);

commit;

