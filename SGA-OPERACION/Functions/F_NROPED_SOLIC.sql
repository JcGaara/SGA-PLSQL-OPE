CREATE OR REPLACE FUNCTION OPERACION.F_NROPED_SOLIC (
a_codot otptoetamat.codot%type,
a_punto otptoetamat.punto%type,
a_codeta otptoetamat.codeta%type,
a_codmat otptoetamat.codmat%type )  RETURN varchar2 IS

tmpVar varchar2(200);

cursor c is
  select a.nroped from slcpedmatcab a, slcpedmatdet b  where a.nroped = b.nroped and
      a.ordtra = a_codot and b.codmat = a_codmat and a.codinssrv = a_punto;

BEGIN

   for lc in c loop
      tmpvar := tmpvar ||' '|| lc.nroped;
   end loop;

   RETURN tmpVar;

   EXCEPTION
     WHEN OTHERS THEN
       return Null;

END;
/


