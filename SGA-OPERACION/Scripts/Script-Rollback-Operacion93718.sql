-- Eliminar detalle de parametros
delete from operacion.opedd 
 where tipopedd = 
          (select operacion.tipopedd.tipopedd
             from operacion.tipopedd
            where abrev = 'PLAT_JANUS_CE')
   and abreviacion = 'CICLO';
   
commit;