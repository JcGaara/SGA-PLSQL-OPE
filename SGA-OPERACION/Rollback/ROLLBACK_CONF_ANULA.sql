delete from operacion.constante c
where c.constante = 'CAMBIOSANULASOT';
 
delete from operacion.opedd t
 where t.tipopedd in
       (select tipopedd
          from operacion.tipopedd
         where abrev = 'ESTANULASOT');
         
delete from operacion.opedd t
 where t.tipopedd in
       (select tipopedd
          from operacion.tipopedd
         where abrev = 'TTRAANULA');

delete from operacion.tipopedd
 where abrev = 'ESTANULASOT';

delete from operacion.tipopedd
 where abrev = 'TTRAANULA';

COMMIT
/


