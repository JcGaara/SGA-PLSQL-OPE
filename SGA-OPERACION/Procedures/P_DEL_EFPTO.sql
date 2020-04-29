CREATE OR REPLACE PROCEDURE OPERACION.P_DEL_EFPTO(an_codEF EFpto.codEF%type, a_punto in number) IS
BEGIN

   delete EFptomet where codEF = an_codEF and punto = a_punto;
   delete EFptoetaDAT where codEF = an_codEF and punto = a_punto;
   delete EFptoetaINF where codEF = an_codEF and punto = a_punto;
   delete EFptoetaact where codEF = an_codEF and punto = a_punto;
   delete EFptoetamat where codEF = an_codEF and punto = a_punto;
   delete EFptoetafor where codEF = an_codEF and punto = a_punto;
   delete EFptoequcmp where codEF = an_codEF and punto = a_punto;
   delete EFptoequCMP where codEF = an_codEF and punto = a_punto;
   delete EFptoequ where codEF = an_codEF and punto = a_punto;
   delete EFptoeta where codEF = an_codEF and punto = a_punto;
   delete EFpto where codEF = an_codEF and punto = a_punto;

END;
/


