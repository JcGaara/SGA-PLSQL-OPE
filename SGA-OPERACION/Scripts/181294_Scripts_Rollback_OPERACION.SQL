

delete from opedd 
 where tipopedd in (select tipopedd from  tipopedd where upper(descripcion) like '%OP-ASIG FLUJO AUTOMATICOS%') 
   and codigon  in ( select wfdef from wfdef where descripcion like '%HFC - CAMBIO DE TITULARIDAD%' );
commit;

delete  from opedd 
 where tipopedd in (select tipopedd from  tipopedd where upper(descripcion) like '%OP-ASIG FLUJO AUTOMATICOS%') 
   and codigon  in ( select wfdef from wfdef where descripcion like '%HFC - CAMBIO NUMERO%' );
commit;