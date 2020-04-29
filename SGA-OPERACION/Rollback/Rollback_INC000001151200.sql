--Rollback Configuración
delete from operacion.opedd t
 where t.tipopedd in
       (select tipopedd
          from operacion.tipopedd
         where abrev = 'MSJ_SERIE_NC');

delete from operacion.tipopedd
 where abrev = 'MSJ_SERIE_NC';

COMMIT
/