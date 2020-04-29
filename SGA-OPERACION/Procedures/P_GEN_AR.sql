CREATE OR REPLACE PROCEDURE OPERACION.P_GEN_AR (a_codef number ) IS
   tmpVar NUMBER;
BEGIN

   select count(*) into tmpVar from ar where codef = a_codef ;
   if tmpvar = 0 then
      select frr into tmpVar from ef where  codef = a_codef ;
      insert into ar ( codef, estar, frr ) values ( a_codef, 1 , tmpVar );
   end if;
   update ef set req_ar = 1 where codef = a_codef ;

END;
/


