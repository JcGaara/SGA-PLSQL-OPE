CREATE OR REPLACE PROCEDURE OPERACION.P_DEL_DETALLE_OT(an_codot otpto.codot%type) IS
BEGIN

   delete otptoetaact where codot = an_codot;
   delete otptoetaper where codot = an_codot;
   delete otptoetamat where codot = an_codot;
   delete otptoetafor where codot = an_codot;
   delete otptoetacon where codot = an_codot;
   delete otptoequcmp where codot = an_codot;
   delete otptoequ where codot = an_codot;
   delete otptoeta where codot = an_codot;
   delete otpto where codot = an_codot;

END;
/


