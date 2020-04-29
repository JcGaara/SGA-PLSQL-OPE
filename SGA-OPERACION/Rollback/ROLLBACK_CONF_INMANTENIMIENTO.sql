delete from operacion.opedd t
 where t.tipopedd in
       (select tipopedd
          from operacion.tipopedd
         where abrev = 'VALCIERRETARMANTO');
         
delete from operacion.tipopedd
 where abrev = 'VALCIERRETARMANTO';

COMMIT
/


