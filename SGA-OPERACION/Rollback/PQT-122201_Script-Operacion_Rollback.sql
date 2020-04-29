-- Eliminar registros de configuraci�n de Emails para Transferencia de Bundles de Promoci�n

delete from  operacion.opedd where idopedd in (select idopedd
        from operacion.tipopedd t1, operacion.opedd t2
       where t1.tipopedd = t2.tipopedd
         and t1.abrev = 'EMAIL_TRANS_BUNDLE_PROM');


delete operacion.tipopedd where abrev='EMAIL_TRANS_BUNDLE_PROM';

commit;
