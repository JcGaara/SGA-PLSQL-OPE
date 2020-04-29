CREATE OR REPLACE PROCEDURE OPERACION.P_LLENA_OTPTO_DE_CCR (a_codot IN number,as_punto in number) IS
BEGIN

   	 insert into OPERACION.otpto(codot,punto,estotpto,codinssrv)
     values (a_codot,as_punto,1,as_punto);

END;
/


