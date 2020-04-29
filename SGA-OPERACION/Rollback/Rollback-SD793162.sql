--Rollback Configuración
delete from constante t where t.constante = 'ERR_GEN_SOT';

delete from operacion.opedd t
 where t.tipopedd in
       (select tipopedd
          from operacion.tipopedd
         where abrev in ('CONF_NUM_PORTAB', 'ESTSOTVALPORTHFC', 'VALGRUPEQDOB',
                         'VALGRUPEQNOCONFIG'));

delete from operacion.tipopedd
 where abrev in ('CONF_NUM_PORTAB', 'ESTSOTVALPORTHFC', 'VALGRUPEQDOB',
                 'VALGRUPEQNOCONFIG');

commit;