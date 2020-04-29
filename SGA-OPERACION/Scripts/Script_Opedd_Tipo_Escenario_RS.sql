
update operacion.opedd set codigon = 1 where tipopedd = (select tipopedd from tipopedd where abrev = 'TIPESCPARCTOTAL');

insert into opedd
  (codigoc, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
values
  ('6',
   1,
   'Tipo de Escenario Prov Incognito: CustomerID(1) o ServicesID(2) -Total (0) o Parcial(1)',
   'TIPESCPARCTOTAL',
   (select tipopedd from tipopedd where abrev = 'TIPESCPARCTOTAL'),
   1);
   
insert into opedd
  (codigoc, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
values
  ('7',
   1,
   'Tipo de Escenario Prov Incognito: CustomerID(1) o ServicesID(2) -Total (0) o Parcial(1)',
   'TIPESCPARCTOTAL',
   (select tipopedd from tipopedd where abrev = 'TIPESCPARCTOTAL'),
   1);   

commit;
--BLOQ_COB -  SUSP_COB

update collections.cxc_transaccionescorte
set EVENTO_COB ='BLOQ_COB'
where  idtrancorte = 6;

update collections.cxc_transaccionescorte
set EVENTO_COB ='SUSP_COB'
where  idtrancorte = 7;

commit;

/
