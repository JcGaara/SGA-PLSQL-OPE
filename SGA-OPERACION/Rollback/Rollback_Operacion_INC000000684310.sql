--Eliminamos las constantes
delete operacion.constante t
 where t.constante in ('PLCODE_LTE',
                       'HLCODE_LTE',
                       'HMCODE_LTE',
                       'DN_TYPE_LTE',
                       'LTE_WIMAX_MIGRA');

-- Eliminamos los registros en la OPEDD					   
delete opedd
 where tipopedd = (select c.TIPOPEDD
                     from tipopedd c
                    where abrev = 'IDPRODUCTOCONTINGENCIA')
   and codigon_aux = '4';


delete opedd
 where tipopedd =
       (select c.TIPOPEDD from tipopedd c where abrev = 'PARBAJAWIMAX');

-- Eliminamos el registro en la TIPOPEDD
delete tipopedd where abrev = 'PARBAJAWIMAX';	   

commit;