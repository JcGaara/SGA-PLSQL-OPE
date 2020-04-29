--Rollback Configuración
delete from operacion.opedd t
 where t.tipopedd in
       (select tipopedd
          from operacion.tipopedd
         where abrev = 'DECO_HD');

delete from operacion.tipopedd
 where abrev = 'DECO_HD';

COMMIT;