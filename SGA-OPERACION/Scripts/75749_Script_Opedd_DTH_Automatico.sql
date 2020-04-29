       insert into operacion.opedd
         (codigon, descripcion, abreviacion, tipopedd, codigon_aux)
       values
         ((select idsolucion from sales.soluciones s where s.solucion ='3PLAY INALAMBRICO'),
           '3PLAY INALAMBRICO','DTH_AUTOMATICO',1096,0);
	   commit;