 

insert into operacion.opedd
  (codigoc, codigon, tipopedd)
values
  ('V',
   830,
   (select tipopedd from tipopedd where abrev = 'TIPTRASISACTVP'));

commit;
/