CREATE OR REPLACE FUNCTION OPERACION.F_CANT_MAT_SOLIC (
a_codot otptoetamat.codot%type,
a_punto otptoetamat.punto%type,
a_codeta otptoetamat.codeta%type,
a_codmat otptoetamat.codmat%type,
a_opcion number )  RETURN NUMBER IS


tmpVar NUMBER;
tmpVar_ped NUMBER;

BEGIN

   if a_opcion in  ( 0, 1) then
      select sum(b.canate), sum(b.canped) into tmpvar, tmpvar_ped from slcpedmatcab a, slcpedmatdet b  where a.nroped = b.nroped and
      a.ordtra = a_codot and b.codmat = a_codmat and a.codinssrv = a_punto;

      if a_opcion = 0 then
         RETURN tmpVar;
      else
         RETURN tmpVar_ped;
      end if;
   elsif  a_opcion in  ( 2, 3) then  -- 2 y 3 muestran lo pedido total por ot
      select sum(b.canate), sum(b.canped) into tmpvar, tmpvar_ped from slcpedmatcab a, slcpedmatdet b  where a.nroped = b.nroped and
      a.ordtra = a_codot and b.codmat = a_codmat;

      if a_opcion = 2 then
         RETURN tmpVar;
      else
         RETURN tmpVar_ped;
      end if;
   else
      select sum(salfis) into tmpvar from  almmatalm where codmat = a_codmat;
      RETURN tmpVar;
   end if;

   return null;
   EXCEPTION
     WHEN OTHERS THEN
       return Null;

END F_CANT_MAT_SOLIC;
/


