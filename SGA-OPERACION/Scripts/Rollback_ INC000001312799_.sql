--Rollback Configuración
delete from operacion.opedd t
 where t.tipopedd in
       (select tipopedd
          from operacion.tipopedd
         where abrev = 'TIPTRA_ANU_SOT');

delete from operacion.tipopedd
 where abrev = 'TIPTRA_ANU_SOT';


delete from operacion.opedd t
 where t.tipopedd in
       (select tipopedd
          from operacion.tipopedd
         where abrev = 'ESTADO_ANU_SOT');

delete from operacion.tipopedd
 where abrev = 'ESTADO_ANU_SOT';

COMMIT
/