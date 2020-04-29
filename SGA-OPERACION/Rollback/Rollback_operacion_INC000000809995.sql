/*Eliminimos registro  "Telmex Negocio - Pymes ne HFC" en opedd*/

delete from opedd 
 where TIPOPEDD = ( select d.tipopedd from operacion.tipopedd d where d.abrev = 'CAMP_PORT_CORP' )
   and CODIGON = 60 ;
   
commit;
/