
insert into operacion.opedd
  (codigoc, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
values
  ('FTTH',
   (select idsolucion from soluciones where solucion = 'FTTH SISACT-SGA'),
   'FTTH SISACT-SGA',
   'FTTH',
   (select tipopedd from tipopedd where abrev = 'SOLUCION_SISACT'),
   1);

insert into tipopedd
  (descripcion, abrev)
values
  ('Paquetes Masivos Fija', 'PAQ_MASIVO_FIJA');

insert into opedd
  (codigoc, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
values
  ((select tipsrv from tystipsrv where dsctipsrv = 'Paquetes Masivos'),
   5,
   'Paquetes Masivos HFC',
   'PAQ_MASIVO_HFC',
   (select tipopedd from tipopedd where abrev = 'PAQ_MASIVO_FIJA'),
   1);

insert into opedd
  (codigoc, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
values
  ((select tipsrv from tystipsrv where dsctipsrv = 'Paquetes Masivos FTTH'),
   9,
   'Paquetes Masivos FTTH',
   'PAQ_MASIVO_FTTH',
   (select tipopedd from tipopedd where abrev = 'PAQ_MASIVO_FIJA'),
   5);

COMMIT;
/