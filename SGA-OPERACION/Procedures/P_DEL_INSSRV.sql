CREATE OR REPLACE PROCEDURE OPERACION.P_DEL_INSSRV ( a_sid in number, a_nuevo in number default null ) IS

BEGIN

	delete inssrv_his where codinssrv = a_sid;
	delete trssolot where codinssrv = a_sid;
	delete solotpto where codinssrv = a_sid;
	delete otpto where codinssrv = a_sid;
   update vtadetptoenl set numckt = a_nuevo where numckt = a_sid;
   update efpto set codinssrv = a_nuevo where codinssrv = a_sid;
	update INSSRVXINSSRV set codinssrv_padre = a_nuevo where codinssrv_padre = a_sid;

	delete inssrv where codinssrv = a_sid;


END;
/


