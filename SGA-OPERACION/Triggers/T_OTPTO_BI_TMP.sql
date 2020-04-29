CREATE OR REPLACE TRIGGER OPERACION.T_OTPTO_Bi_TMP
 BEFORE INSERT ON otpto
FOR EACH ROW
declare
l_sid number;
BEGIN

   if :new.codinssrv is null then
   	begin
	  		select codinssrv into l_sid from inssrv where codinssrv = :new.punto;
        	:new.codinssrv := :new.punto;
      exception-- Si fall entonces codinssrv es nulo
      	when others then
         	null;
      end;

   end if;

END;
/



