CREATE OR REPLACE PROCEDURE OPERACION.P_APROBAR_OT(a_codot in number) IS

lc_proyecto char(10);
lc_numpsp solot.numpsp%type;
lc_idopc solot.idopc%type;

l_tiptrs tiptrabajo.tiptrs%type;

-- cursor solo los puntos del vtadetpto
cursor cur_puntos is
   select trssolot.numslc, trssolot.codinssrv, trssolot.NUMPTO, trssolot.FECTRS fecinisrv
   from ot, trssolot
   where trssolot.esttrs = 2 and trssolot.tipo = 1 and
		 ot.codsolot = trssolot.codsolot and ot.codot = a_codot;

cursor cur_equipos is
   select trssolot.numslc, trssolot.codinssrv, trssolot.NUMPTO, trssolot.idadd, trssolot.FECTRS fecinisrv
   from ot, trssolot
   where trssolot.esttrs = 2 and trssolot.tipo = 2 and
		 ot.codsolot = trssolot.codsolot and ot.codot = a_codot;


BEGIN

   select solot.numslc, solot.numpsp, solot.idopc into lc_proyecto, lc_numpsp, lc_idopc
   from ot, solot
   where solot.codsolot = ot.codsolot and
		 ot.codot = a_codot;

   if lc_numpsp is null then
      return;
   end if;


   -- Interface con el modelo antiguo (VTADETPTOENL) +++++++++ Hay que agregar una linea por el tema del flgpost y crear el campo +++++++++++++
   /******************************************************
   		flgpost = l_punto.flgpost,
   ******************************************************/
   for l_punto in cur_puntos loop
     update vtadetptoenl set
 	  		estist = '1',
 	  		feciniser = l_punto.fecinisrv,
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


