delete from operacion.opedd t
 where t.tipopedd in
       (select tipopedd
          from operacion.tipopedd
         where abrev = 'SRV_DUPLICID');

delete from operacion.tipopedd
 where abrev = 'SRV_DUPLICID';

COMMIT
/  