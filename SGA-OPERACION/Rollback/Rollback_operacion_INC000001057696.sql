--Rollback Configuración
delete from operacion.constante t where t.constante = 'ERR_GEN_SOT_TOA';

delete from operacion.opedd t
 where t.tipopedd in
       (select tipopedd
          from operacion.tipopedd
         where abrev = 'ESTSRVSGA');

delete from operacion.tipopedd
 where abrev = 'ESTSRVSGA';

COMMIT;
/