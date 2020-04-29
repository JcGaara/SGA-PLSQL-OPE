CREATE OR REPLACE TRIGGER OPERACION.T_SOLOTPTO_AI
AFTER INSERT
ON OPERACION.SOLOTPTO
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
declare
   l_nroserviciomt solotpto_id.nroserviciomt%type;
BEGIN

   if :new.codinssrv is not null then
 		select campo1 into l_nroserviciomt from inssrv where codinssrv = :new.codinssrv;
   end if;

	insert into solotpto_id ( codsolot, punto, nroserviciomt  ) values ( :new.codsolot , :new.punto, l_nroserviciomt  );
	P_Llena_Presu_De_Solotpto( :new.codsolot, :new.punto, :new.codinssrv, :new.CID, :new.descripcion, :new.direccion, :new.codubi);

END;
/



