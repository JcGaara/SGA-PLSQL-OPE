 update ope_plantillasot
   set tiptra =
	   (select tiptra
		  from operacion.tiptrabajo t
		 where t.descripcion = 'FTTH/SIAC - RECONEXION DE CORTE DEL SERVICIO')
 where trim(descripcion) = 'FTTH - BSCS- RECONEXION CFP';


 update ope_plantillasot
   set tiptra =
       (select tiptra
          from operacion.tiptrabajo t
         where t.descripcion = 'FTTH/SIAC - CORTE DEL SERVICIO') 
 where trim(descripcion) = 'FTTH - BSCS- CORTE';

 
commit;
 /
