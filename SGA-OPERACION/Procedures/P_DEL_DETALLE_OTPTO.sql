CREATE OR REPLACE PROCEDURE OPERACION.P_DEL_DETALLE_OTpto(an_codot otpto.codot%type, an_punto otpto.punto%type) IS
BEGIN

   delete otptoetaact where codot = an_codot and punto = an_punto;
   delete otptoetaper where codot = an_codot and punto = an_punto;
   delete otptoetamat where codot = an_codot and punto = an_punto;
   delete otptoetafor where codot = an_codot and punto = an_punto;
   delete otptoetacon where codot = an_codot and punto = an_punto;
   delete otptoequcmp where codot = an_codot and punto = an_punto;
   delete otptoequ where codot = an_codot and punto = an_punto;
   delete otptoeta where codot = an_codot and punto = an_punto;
   delete otpto where codot = an_codot and punto = an_punto;

END;
/


