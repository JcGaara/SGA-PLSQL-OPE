CREATE OR REPLACE PROCEDURE OPERACION.P_DEL_OTPTO(an_CODOT OTPTO.CODOT%type, a_punto in number) IS
BEGIN

   delete OTPTOetaINF where CODOT = an_CODOT and punto = a_punto;
   delete OTPTOetaact where CODOT = an_CODOT and punto = a_punto;
   delete OTPTOetamat where CODOT = an_CODOT and punto = a_punto;
   delete OTPTOetafor where CODOT = an_CODOT and punto = a_punto;
   delete OTPTOequCMP where CODOT = an_CODOT and punto = a_punto;
   delete OTPTOequ where CODOT = an_CODOT and punto = a_punto;
   delete OTPTOeta where CODOT = an_CODOT and punto = a_punto;
   delete OTPTO where CODOT = an_CODOT and punto = a_punto;

END;
/


