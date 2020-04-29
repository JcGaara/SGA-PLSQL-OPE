--Rollback Configuración
delete from operacion.opedd t
 where t.tipopedd in
       (select tipopedd
          from operacion.tipopedd
         where abrev = 'CODSRV_TYSTABSRV');

delete from operacion.tipopedd
 where abrev = 'CODSRV_TYSTABSRV';

COMMIT
/