CREATE OR REPLACE PROCEDURE OPERACION.P_ACTUALIZA_MATERIAL(a_codot in number, a_codinssrv in number, a_codeta in number) IS
l_codpre number;
l_idubi number;

cursor cur_mat is
	select sum(b.canped) canped ,sum(b.canate) canate ,b.codmat codmat from slcpedmatcab a,slcpedmatdet b
	where a.ordtra = a_codot and
		  a.codinssrv = a_codinssrv and
		  a.codeta = a_codeta and
		  a.nroped = b.nroped
	group by codmat  ;


BEGIN

/* No hace nada Dropearla */
null;

/*
	 select codpre into l_codpre from presupuesto,ot
	 where presupuesto.codsolot = ot.codsolot and
	  	   ot.codot = a_codot;


	update preubietamat p set (canins_sol , canins_ate ) = (
  	select sum(b.canped) ,sum(b.canate) from slcpedmatcab a,slcpedmatdet b
	where a.ordtra = a_codot and
		  p.idubi = a.idubi and
		  p.codeta = a.codeta and
        p.codmat = b.codmat and
		  a.nroped = b.nroped )
   where p.codpre = l_codpre;
*/
/*

	 select idubi into l_idubi from preubi
	 where preubi.codinssrv = a_codinssrv and
	 	   preubi.codpre = l_codpre;

	 for lc1 in cur_mat loop
	 	update preubietamat set canins_sol = lc1.canped, canins_ate = lc1.canate
		where codpre = l_codpre and
			  idubi = l_idubi and
			  codeta = a_codeta and
			  codmat = lc1.codmat;
	 end loop 	;
*/
EXCEPTION
     WHEN OTHERS THEN
       RAISE_APPLICATION_ERROR (-20500,'No se pudo actualizar datos de almacen');

END;
/


