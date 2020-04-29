 update ope_plantillasot
   set tiptra =
       (select tiptra
          from operacion.tiptrabajo t
         where t.descripcion = 'FTTH/SIAC - SUSPENSION DEL SERVICIO')
 where descripcion = 'FTTH - BSCS- CORTE';

update ope_plantillasot
   set tiptra =
       (select tiptra
          from operacion.tiptrabajo t
         where t.descripcion = 'FTTH/SIAC - RECONEXION DEL SERVICIO')
 where descripcion = 'FTTH - BSCS- RECONEXION CFP';
 
 commit;
 /