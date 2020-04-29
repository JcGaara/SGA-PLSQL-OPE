insert into operacion.tipopedd (DESCRIPCION, ABREV)
values ('Config-Val-Equcom-CP', 'CVE_CP');

insert into operacion.opedd
  (codigon, DESCRIPCION, ABREVIACION, TIPOPEDD)
values
  (1,
   'Cambio de Validacion de Equipo Comercial',
   'CVEC',
   (select tipopedd from operacion.tipopedd where abrev = 'CVE_CP'));
commit;