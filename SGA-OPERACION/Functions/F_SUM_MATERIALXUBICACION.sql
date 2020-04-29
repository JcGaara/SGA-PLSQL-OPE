CREATE OR REPLACE FUNCTION OPERACION.f_sum_materialxubicacion( a_codot in number, a_codpre in number, a_idubi in number)  RETURN NUMBER IS

ls_area ot.coddpt%type;
l_costo number;
l_solot ot.codsolot%type;
l_tiptra ot.tiptra%type;
l_numslc solot.numslc%type;

BEGIN

   select rtrim(ot.coddpt), ot.codsolot, ot.tiptra, presupuesto.numslc
      into ls_area, l_solot, l_tiptra, l_numslc
      from ot, presupuesto
      where ot.codot = a_codot and ot.codsolot = presupuesto.codsolot;

   -- Costo de Materiales de MANTENIMIENTO DE PEX o de INSTALACION DE PEX
   if ls_area = '0046' or ls_area = '0042' then
      select sum(cosins * canins) into l_costo
         from preubietamat
            where codpre = a_codpre and
               idubi = a_idubi;
   --  Costo de Materiales de AUTORIZACIONES DE PEX
   elsif  ls_area = '0041' then
      select sum(cosins * canins) into l_costo
         from preubietamat
         where codpre = a_codpre and
               idubi = a_idubi and
               codeta in (22,201);--select codeta from etapa where descripcion like 'Permisos%';
   --  Costo de Materiales de PLANEAMIENTO Y DISE?O DE PEX
   elsif ls_area = '0040' then
      select sum(cosdis * candis) into l_costo
         from preubietamat
         where codpre = a_codpre and
               idubi = a_idubi;
   --  Costo de Materiales de Planta Externa por EF
   elsif  ls_area = '0031' and l_tiptra not in (2,3) and l_numslc is not null then    	  -- se actualizan datos del proyecto
/*      select sum(cospro * canpro) into l_costo
         from preubietamat
         where codpre = a_codpre and
               idubi = a_idubi;
*/      l_costo := 0;
   end if;

   return l_costo;

   EXCEPTION
      WHEN OTHERS THEN Return 0;

END;
/


