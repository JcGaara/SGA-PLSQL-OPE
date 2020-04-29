delete from operacion.opedd o
 where o.idopedd in
       (select idopedd from opedd where abreviacion = 'TPIGSM/codplan')

COMMIT;