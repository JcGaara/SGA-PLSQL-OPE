--Rollback Configuración
delete from operacion.opedd t
 where t.tipopedd in
       (select tipopedd
          from operacion.tipopedd
         where abrev = 'CARACT_ESPEC_TRAMA');

delete from operacion.tipopedd
 where abrev = 'CARACT_ESPEC_TRAMA';

COMMIT;