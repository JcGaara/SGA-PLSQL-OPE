delete 
from opedd
 where tipopedd =
       (select MAX(tipopedd)
          from tipopedd
         where upper(abrev) = 'BSCS_CONTRATO')
 and CODIGON in (1494,1495,1497,1492);

commit;
