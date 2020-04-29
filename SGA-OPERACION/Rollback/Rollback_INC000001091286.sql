--Rollback Configuración
delete from operacion.opedd t
 where t.tipopedd in
       (select tipopedd
          from operacion.tipopedd
         where abrev = 'EST_SOT_INHAB');

delete from operacion.tipopedd
 where abrev = 'EST_SOT_INHAB';

COMMIT
/