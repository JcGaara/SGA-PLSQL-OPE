CREATE OR REPLACE VIEW OPERACION.ASIG
AS 
SELECT j.descripcion nodo  , h.codigo, h.descripcion pop, f.descripcion cable, d.descripcion caja_terminal, b.estfibra,  
b.descripcion fibra, b.codelered elered_fibra, inssrv.codinssrv SID,  b.numslc, inssrv.codelered elered_sid  
   FROM inssrv,  
		eleredxelered a,  
		fibra b,  
		eleredxelered c,  
		cajter d,  
        eleredxelered e,  
		cable f,  
		eleredxelered g,  
		pop h,  
		eleredxelered i,  
		nodo j  
   WHERE  
         inssrv.codelered = a.codelered_h AND  
         b.codelered = a.codelered_p AND  
         b.codelered = c.codelered_h AND  
         d.codelered = c.codelered_p AND  
         d.codelered = e.codelered_h AND  
         f.codelered = e.codelered_p AND  
         f.codelered = g.codelered_h AND  
         h.codelered = g.codelered_p AND  
         h.codelered = i.codelered_h AND  
         j.codelered = i.codelered_p;


