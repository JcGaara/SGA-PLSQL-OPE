CREATE OR REPLACE PROCEDURE OPERACION.p_llena_otpto_de_solotpto_all (a_codsolot in number) IS

cursor cur_ot is
select codot from ot where codsolot = a_codsolot;

l_codpre number;
l_flg number(1);

BEGIN

   -- Comentado por CC - 08-08-03
   --select PQ_CONSTANTES.F_GET_CFG_WF into l_flg from dual;
   l_flg := 0;
   if l_flg = 0 then
   	for lc1 in cur_ot loop
      	p_llena_otpto_de_solotpto(lc1.codot);
      end loop;
   end if;
   --LA INSERCION EN LA TABLA PRESUPUESTO YA NO SE PRODUCE AQUI, EXISTE UN TRIGGER PARA ESTO
   /*BEGIN
      SELECT codpre INTO l_codpre FROM PRESUPUESTO WHERE codsolot = a_codsolot;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       l_codpre := NULL;
   END ;

   if l_codpre is not null then -- Existe una OT para PEX
	   P_LLENA_PRESUPUESTO_DE_SOL(a_codsolot);
   end if;*/



END;
/


