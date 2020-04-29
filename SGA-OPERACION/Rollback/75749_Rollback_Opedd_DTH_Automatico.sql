delete from operacion.opedd 
 where codigon=(select idsolucion from sales.soluciones s where s.solucion ='3PLAY INALAMBRICO')    
   and abreviacion='DTH_AUTOMATICO' 
   and tipopedd=(select TIPOPEDD from tipopedd where abrev='DTH_AUTOMATICO');
commit;