--Rollback Configuración
delete from operacion.opedd t
 where t.tipopedd in
       (select tipopedd
          from operacion.tipopedd
         where abrev = 'OPC_ORD_VISITA');

delete from operacion.tipopedd
 where abrev = 'OPC_ORD_VISITA';

COMMIT;