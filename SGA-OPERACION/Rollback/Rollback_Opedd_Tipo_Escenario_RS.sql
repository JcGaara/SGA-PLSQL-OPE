
update operacion.opedd set codigon = 7 where tipopedd = (select tipopedd from tipopedd where abrev = 'TIPESCPARCTOTAL') and codigoc = '3';

delete from opedd where codigoc = '6' and tipopedd = (select tipopedd from tipopedd where abrev = 'TIPESCPARCTOTAL');

delete from opedd where codigoc = '7' and tipopedd = (select tipopedd from tipopedd where abrev = 'TIPESCPARCTOTAL');  
commit;
--BLOQ_COB -  SUSP_COB

update collections.cxc_transaccionescorte
set EVENTO_COB ='DESB_COB'
where  idtrancorte = 6;

update collections.cxc_transaccionescorte
set EVENTO_COB ='RCNX_COB'
where  idtrancorte = 7;

commit;
/