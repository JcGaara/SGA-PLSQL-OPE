/*Actualizacion del campo codigon*/
update operacion.opedd p 
set p.codigon = '1'
where p.abreviacion = 'parametro_input'
and p.codigon_aux = '1';

commit;

/*Insercion de nuevo material en la tabla opedd*/
insert into operacion.opedd
  (codigoc, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
values
  ('000000000004037161',
   '1',
   'material',
   'parametro_input',
   (select tipopedd from operacion.tipopedd where abrev = 'datos_param_sans'),
   '3');
            
commit;       

-- Actualizacion de tarea WF                     
update opewf.tareawfdef
   set tipo = 0
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
   set tipo = 0
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