delete from operacion.opedd p
 where p.tipopedd = (select t.tipopedd
                       from operacion.tipopedd t
                      where t.abrev = 'migracion_plano');

delete from operacion.tipopedd t where t.abrev = 'migracion_plano';

update opewf.tareadef t set t.pos_proc = null where t.tareadef in (1023, 756);

commit;
