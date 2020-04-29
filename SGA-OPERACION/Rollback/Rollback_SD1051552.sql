--Rollback Configuración
delete from operacion.opedd t
 where t.tipopedd in
       (select tipopedd
          from operacion.tipopedd
         where abrev = 'ESTD_EF_IMPR_OC');

delete from operacion.tipopedd
 where abrev = 'ESTD_EF_IMPR_OC';

COMMIT;