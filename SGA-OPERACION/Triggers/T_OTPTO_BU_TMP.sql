CREATE OR REPLACE TRIGGER OPERACION.T_OTPTO_BU_TMP
 BEFORE UPDATE ON otpto
FOR EACH ROW
declare
l_sid number;
BEGIN

	IF NOT UPDATING('CODINSSRV') THEN
   	begin
	  		select codinssrv into l_sid from inssrv where codinssrv = :new.punto;
        	:new.codinssrv := :new.punto;
      exception-- Si fall entonces codinssrv es nulo
      	when others then
         	null;
      end;
   END IF;

END;
/



