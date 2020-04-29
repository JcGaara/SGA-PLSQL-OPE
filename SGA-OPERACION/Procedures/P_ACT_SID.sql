CREATE OR REPLACE PROCEDURE OPERACION.P_ACT_SID ( a_pry in number, a_pto in number, a_sid in number ) IS
tmpVar NUMBER;

BEGIN

	update vtadetptoenl set numckt = a_sid where numslc = a_pry and numpto = a_pto ;
	update efpto set codinssrv = a_sid where codef = a_pry and punto = a_pto ;

END P_ACT_SID;
/


