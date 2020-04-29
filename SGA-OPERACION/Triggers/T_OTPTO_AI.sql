CREATE OR REPLACE TRIGGER OPERACION.T_OTPTO_AI
AFTER insert ON otpto
FOR EACH ROW
declare
	l_sol ot.codsolot%type;
   l_cont number;

BEGIN
   select ot.codsolot into l_sol from ot where codot = :new.codot;

   select count(*) into l_cont from solotpto where codsolot = l_sol and punto = :new.punto;

   if l_cont = 0 then
	  insert into solotpto ( CODSOLOT, PUNTO, CODSRVNUE, BWNUE, CODSRVANT, BWANT)
	  	values (l_sol, :new.PUNTO, :new.CODSRVNUE, :new.BWNUE, :new.CODSRVANT, :new.BWANT);

	  update solotpto
	  	 set (codinssrv, descripcion, direccion, cid) = (select codinssrv, descripcion, direccion, cid
		 	 from inssrv where codinssrv = :new.codinssrv)
		 where codsolot = l_sol and
		 	   punto = :new.punto;

   end if;
END;
/



