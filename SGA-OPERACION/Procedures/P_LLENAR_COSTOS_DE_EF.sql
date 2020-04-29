CREATE OR REPLACE PROCEDURE OPERACION.P_LLENAR_COSTOS_DE_EF(an_codsolot SOLOTPTOETA.codsolot%type)
IS

/******************************************************************************
Fecha        Autor           Descripcion
----------  ---------------  ------------------------
30/03/2005 CARMEN QUILCA	 Procedimiento para insertar en las tablas solotptoetaact
                                         	  			 y solotptoetamat con los datos de las tablas
                                                   efptoetaact y efptoetamat respectivamente...
31/03/2005 CARMEN QUILCA	 Se agrega la funcionalidad para insertar los datos
                              		   		  			 de la efptoeta a la tabla solotptoeta....
24/04/2007 LISSETH OBREGON Se modifica para que se jalen las etapas de planta externa...
                                                     Ya que se debe utilizar más esta opción por lo de sap..

/****************************************************************************** */
l_orden number;
l_punto number;
l_codeta SOLOTPTOETA.codeta%type;
lv_valido                                  varchar2(1);
lv_error                                    varchar2(100);


--cursor para la tabla solotptoeta
--LOA 25/04/2007 modificación, se van a jalar las etapas del usuario, que sean utilizadas por
--Planta externa y las etapas de mano de obra.., solo las etapas que estén activas...
cursor cur_eta is
select solotpto.codsolot,
	         solotpto.punto,
	         efptoeta.codeta
from solot,
	       solotpto,
      	 efptoeta,
      	 preusufas,
         etapa
where efptoeta.codef = solot.numslc
	  and efptoeta.punto = solotpto.efpto
	  and solot.codsolot = solotpto.codsolot
	  and preusufas.codeta = efptoeta.codeta
	  and preusufas.codfas = 1 --etapa diseño
  	and preusufas.codusu = upper(user)
	  and solotpto.codsolot = an_codsolot
	  and efptoeta.codeta not in (select codeta from solotptoeta where codsolot = an_codsolot)
    and etapa.codeta = preusufas.codeta
    and etapa.area_eta in ( 'E')
    and etapa.estado = 1
    ;

--cursor para la tabla solotptoetaact
cursor cur_act is
select solotptoeta.codsolot,
	   solotptoeta.punto,
	   solotptoeta.orden,
	   efptoetaact.codact,
	   efptoetaact.cantidad,
	   efptoetaact.costo,
	   efptoetaact.observacion,
	   efptoetaact.moneda_id,
	   efptoetaact.codprec
from solot,
	 solotpto,
	 solotptoeta,
	 efptoetaact,
	 preusufas
where efptoetaact.codef = solot.numslc
	  and efptoetaact.punto = solotpto.efpto
	  and efptoetaact.codeta = solotptoeta.codeta
	  and solot.codsolot = solotpto.codsolot
	  and solotpto.codsolot = solotptoeta.codsolot
	  and solotpto.punto = solotptoeta.punto
	  and preusufas.codeta = solotptoeta.codeta
	  and preusufas.codfas = 1 --etapa diseño
  	  and preusufas.codusu = upper(user)
	  and solotptoeta.codsolot = an_codsolot
	  and solotptoeta.punto = l_punto
	  and solotptoeta.codeta = l_codeta;

--cursor para la tabla solotptoetamat
cursor cur_mat is
select solotptoeta.codsolot,
	   solotptoeta.punto,
	   solotptoeta.orden,
	   efptoetamat.codmat,
	   efptoetamat.cantidad,
	   efptoetamat.costo
from solot,
	 solotpto,
	 solotptoeta,
	 efptoetamat,
	 preusufas
where efptoetamat.codef = solot.numslc
	  and efptoetamat.punto = solotpto.efpto
	  and efptoetamat.codeta = solotptoeta.codeta
	  and solot.codsolot = solotpto.codsolot
	  and solotpto.codsolot = solotptoeta.codsolot
	  and solotpto.punto = solotptoeta.punto
	  and preusufas.codeta = solotptoeta.codeta
	  and preusufas.codfas = 1 --etapa diseño
 	  and preusufas.codusu = upper(user)
	  and solotptoeta.codsolot = an_codsolot
	  and solotptoeta.punto = l_punto
	  and solotptoeta.codeta = l_codeta;

BEGIN
--para insertar en la tabla solotptoeta...las etapas
   for l in cur_eta loop

   	     l_codeta := l.codeta;
	       l_punto := l.punto;

   	    select nvl(max(orden),0)
        into l_orden
        from solotptoeta
	      where codsolot = an_codsolot
        and punto = l_punto;

   	   l_orden := l_orden + 1;

   	   insert into solotptoeta
       (codsolot,
        punto,
        orden,
        codeta)
	     values
       (an_codsolot,
        l_punto,
        l_orden,
        l_codeta);

	   --para insertar en la tabla solotptoetaact..las actividades....
	   for lact in cur_act loop

	   	   insert into solotptoetaact
         (codsolot,
          punto,
          orden,
          codact,
          candis,
          cosdis,
		      moneda_id,
          codprecdis)
		    values
         (an_codsolot,
          l_punto,
          lact.orden,
          lact.codact,
          lact.cantidad,
          lact.costo,
		      lact.moneda_id,
          lact.codprec);

	   end loop;

	   --para insertar en la tabla solotptoetamat..los materiales....
	   for lmat in cur_mat loop
		   insert into solotptoetamat
          (codsolot,
           punto,
           orden,
           codmat,
           candis,
           cosdis)
		   values
          (an_codsolot,
           l_punto,
           lmat.orden,
           lmat.codmat,
		       lmat.cantidad,
           lmat.costo);
	   end loop;

   end loop;

   ---Completo los elementos peps en el formulario de SOTs...
     financial.PQ_Z_MM_PEP_MISC.Sp_Popula_Peps_MatPE
                                        (an_codsolot,
                                         null,
                                         lv_valido,
                                         lv_error
                                         ) ;

END ;
/


