insert into operacion.opedd
  (CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values
  ((select tiptra
      from operacion.tiptrabajo
     where descripcion = 'FTTH - SISACT INSTALACION PAQUETES TODO CLARO DIGITAL'),
   'VENTA SISACT FTTH',
   'SISACT_FTTH',
   (select tipopedd from tipopedd where abrev='TIPTRABAJO'));
insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null, (select tiptra from operacion.tiptrabajo where descripcion='FTTH - SISACT INSTALACION PAQUETES TODO CLARO DIGITAL'), 'FTTH - SISACT INSTALACION PAQUETES TODO CLARO DIGITAL', null, 506, null);

insert into operacion.opedd
  (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values
  (null,
   19680,
   'TERMINAL GPON HUAWEI HG8247U',
   null,
   (select tipopedd
      from operacion.tipopedd t
     where t.abrev = 'EMTA_SISACT_SGA'),
   0);

Commit;