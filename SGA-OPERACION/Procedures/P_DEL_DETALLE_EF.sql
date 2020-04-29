CREATE OR REPLACE PROCEDURE OPERACION.P_DEL_DETALLE_EF(an_codEF EFpto.codEF%type) IS
BEGIN

   delete EFptoetaDAT where codEF = an_codEF;
   delete EFptoetaINF where codEF = an_codEF;
   delete EFptoetaact where codEF = an_codEF;
   delete EFptoetamat where codEF = an_codEF;
   delete EFptoetafor where codEF = an_codEF;
   delete EFptoequcmp where codEF = an_codEF;
   delete EFptoequCMP where codEF = an_codEF;
   delete EFptoequ where codEF = an_codEF;
   delete EFptoeta where codEF = an_codEF;
   delete EFpto where codEF = an_codEF;

END;
/


