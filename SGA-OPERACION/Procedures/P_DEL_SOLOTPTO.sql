CREATE OR REPLACE PROCEDURE OPERACION.P_DEL_solOTPTO(an_CODSOLOT SOLOTPTO.CODSOLOT%type, a_punto in number) IS
BEGIN

   delete SOLOTPTO where CODSOLOT = an_CODSOLOT and punto = a_punto;
   P_DEL_preubi ( an_CODSOLOT, a_punto );

END;
/


