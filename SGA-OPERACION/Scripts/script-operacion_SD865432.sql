/*creamos la cabecera en el TIPOPEDD*/
insert into tipopedd (DESCRIPCION, ABREV)
values ('CARACTERES ESPECIALES', 'CARACTER_ESPECIAL_EXP_DAT');

commit;

/*creamos los parametros en la OPEDD*/
insert into opedd
  (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values
  ('!"#$%&/\()',
   null,
   'Caracteres Especiales',
   'ORIGEN_EXP_DATOS',
   (select tipopedd
      from tipopedd
     where abrev = 'CARACTER_ESPECIAL_EXP_DAT'),
   0); 


insert into opedd
  (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values
  ('||||||||||',
   null,
   'Caracteres Especiales',
   'DESTINO_EXP_DATOS',
   (select tipopedd
      from tipopedd
     where abrev = 'CARACTER_ESPECIAL_EXP_DAT'),
   0); 

commit;   
/