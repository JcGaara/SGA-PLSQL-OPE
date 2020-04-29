--Rollback Configuración
delete from operacion.opedd t
 where t.tipopedd in
       (select tipopedd
          from operacion.tipopedd
         where abrev = 'SGA_ASIGNAR_NUMERO');

delete from operacion.tipopedd
 where abrev = 'SGA_ASIGNAR_NUMERO';

COMMIT
/