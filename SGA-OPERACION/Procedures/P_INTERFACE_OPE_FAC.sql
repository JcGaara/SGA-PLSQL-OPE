CREATE OR REPLACE PROCEDURE OPERACION.P_INTERFACE_OPE_FAC(
a_codsolot in number
) IS
/*******************************************************************************
Interface con el modulo de Facturacion Antiguo
Nuevo Operaciones contra el Facturacion de Datos
- Actualiza el VTADETPTOENL
*******************************************************************************/

lc_proyecto char(10);
lc_numpsp solot.numpsp%type;
lc_idopc solot.idopc%type;

l_tiptrs tiptrabajo.tiptrs%type;

-- cursor solo los puntos del vtadetpto
cursor cur_puntos is
   select t.numslc, t.codinssrv, t.NUMPTO, t.FECTRS fecinisrv, t.FLGPOST
   from trssolot t
   where t.esttrs = 2 and t.tipo = 1 and
		 t.codsolot = a_codsolot;

cursor cur_equipos is
   select t.numslc, t.codinssrv, t.NUMPTO, t.idadd, t.FECTRS fecinisrv, t.FLGPOST
   from trssolot t
   where t.esttrs = 2 and t.tipo = 2 and
		 t.codsolot = a_codsolot;


BEGIN

   select solot.numslc, solot.numpsp, solot.idopc into lc_proyecto, lc_numpsp, lc_idopc
   from solot
   where solot.codsolot = a_codsolot;

   if lc_numpsp is null then
      return;
   end if;

   -- Interface con el modelo antiguo (VTADETPTOENL)
   for l_punto in cur_puntos loop
     update vtadetptoenl set
 	  		estist = '1',
 	  		feciniser = l_punto.fecinisrv,
         flgpost = l_punto.flgpost,
 	  		feciniequ = l_punto.fecinisrv
 	  where numslc = l_punto.numslc and
           numpto = l_punto.numpto;
     -- actualiza la programacion
      update facprgfac set
 	  		feciniser = l_punto.fecinisrv
 	    where numslc = l_punto.numslc and
           numpto = l_punto.numpto and
           tipdet='A';

   end loop;

   -- Interface con el modelo antiguo EQUIPOS
   for l_equ in cur_equipos loop
     update vtadetslcfacequ set
 	  		feciniser = l_equ.fecinisrv
 	  where numslc = l_equ.numslc and
           idadd  = l_equ.idadd and
           numpto = l_equ.numpto;
   end loop;


    -- actualiza la fecha de inicio del servicio en la oferta comercial.
   update vtatabpspcli set
   fecinisrv = (select min(feciniser)
			from vtadetptoenl
			where vtadetptoenl.numslc = vtatabpspcli.numslc and
				vtadetptoenl.estist = '1' )
   where vtatabpspcli.numpsp = lc_numpsp and
         vtatabpspcli.idopc = lc_idopc and
         vtatabpspcli.numslc = lc_proyecto ;

   -- actualiza la fecha tentativa de inicio de facturacion y Termino de facturacion.
   update vtatabpspcli set
   fecinifac = fecinisrv,
   fecvenfac = (fecinisrv + ( 365 * (durcon / 12)))
   where vtatabpspcli.numpsp = lc_numpsp and
         vtatabpspcli.idopc = lc_idopc and
         vtatabpspcli.numslc = lc_proyecto and
   	   fecinisrv is not null  and ( fecinifac is null or  fecinifac < fecinisrv ) ;



END;
/


