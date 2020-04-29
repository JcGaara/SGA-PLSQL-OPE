CREATE OR REPLACE PROCEDURE OPERACION.P_LLENAR_CONT_X_ACT (a_codact in number )IS

BEGIN

	insert into actxcontrata ( codact, codcon )
   select a_codact, codcon from contrata
   minus
   select codact, codcon from actxcontrata where codact = a_codact;

END;
/


