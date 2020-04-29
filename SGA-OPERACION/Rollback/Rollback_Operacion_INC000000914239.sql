--Rollback Configuración
delete from operacion.opedd t
 where t.tipopedd in
       (select tipopedd
          from operacion.tipopedd
         where abrev = 'LIST_STATEMENT');

delete from operacion.tipopedd
 where abrev = 'LIST_STATEMENT';

COMMIT;