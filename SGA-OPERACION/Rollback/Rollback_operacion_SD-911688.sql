/*Actualizacion del campo codigon*/
update operacion.opedd p 
set p.codigon = NULL
where p.abreviacion = 'parametro_input'
and p.codigon_aux = '1';

commit;

/*Eliminacion de nuevo material en la tabla opedd*/
delete from operacion.opedd p
 where p.abreviacion = 'parametro_input'
   and p.codigon_aux = '3'
   and p.codigon = '1'
   and p.tipopedd in (select tipopedd
                        from operacion.tipopedd
                       where abrev = 'datos_param_sans');
            
commit;      


-- Actualizacion de tarea WF                     
update opewf.tareawfdef
   set tipo = 2
 where wfdef in
       (select wfdef
          from cusbra.br_sel_wf
         where tiptra in (select o.codigon
                            from operacion.tipopedd t, operacion.opedd o
                           where t.tipopedd = o.tipopedd
                             and t.abrev = 'TIP_TRA_CSR'
                             and o.codigoc = 'OAC'));
commit;

-- Actualizacion de Definicion de tareas
update opewf.tareadef
   set tipo = 2
 where tareadef in
       (select tareadef
          from opewf.tareawfdef
         where wfdef in
               (select wfdef
                  from cusbra.br_sel_wf
                 where tiptra in
                       (select o.codigon
                          from operacion.tipopedd t, operacion.opedd o
                         where t.tipopedd = o.tipopedd
                           and t.abrev = 'TIP_TRA_CSR'
                           and o.codigoc = 'OAC')));
commit;