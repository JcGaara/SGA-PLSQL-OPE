DELETE 
 from OPERACION.tiproy_sinergia_pep where id_seq_pad in ( select id_seq from OPERACION.tiproy_sinergia_pep where  TIPROY = 'FUS'  and descripcion = 'INFRAESTRUCTURA FTTH') ;
 
DELETE 
from OPERACION.tiproy_sinergia_pep where  TIPROY = 'FUS' and descripcion = 'INFRAESTRUCTURA FTTH';

DELETE  
from  OPERACION.TIPROY_SINERGIA where TIPROY = 'FUS' ;
commit;
/