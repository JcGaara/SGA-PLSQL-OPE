
/*1.- Scrip de Regularizacion - Actualizacion de Campo Numero con la SEC*/
update inssrv
   set numsec = numero
 where numsec is null
   and numslc in
       (select numslc
          from solot
         where estsol = 17
           and numslc in
               (select numslc from vtatabslcfac where idsolucion = 120));
/               
/*2.- Grant*/

grant execute on SALES.PQ_INT_SISACT_CONSULTA to USRSISACT;
/