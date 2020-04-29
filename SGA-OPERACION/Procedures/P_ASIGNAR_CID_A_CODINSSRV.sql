CREATE OR REPLACE PROCEDURE OPERACION.P_ASIGNAR_CID_A_CODINSSRV (A_CID IN NUMBER, A_CODINSSRV in number ) IS
BEGIN

   if a_cid is not null then
   	update inssrv set cid = a_cid where codinssrv = A_CODINSSRV;

      UPDATE SOLOTPTO SET cid = a_cid where codinssrv = A_CODINSSRV AND CID IS NULL;

      UPDATE preubi SET cid = a_cid where codinssrv = A_CODINSSRV AND CID IS NULL;
   end if;

END;
/


