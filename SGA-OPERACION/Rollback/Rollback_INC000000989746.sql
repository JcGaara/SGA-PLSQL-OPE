--Rollback Configuración
delete from operacion.opedd t
 where t.tipopedd in
       (select tipopedd
          from operacion.tipopedd
         where abrev = 'EST_CAMB_PLAN');

delete from operacion.tipopedd
 where abrev = 'EST_CAMB_PLAN';

COMMIT
/