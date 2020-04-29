CREATE OR REPLACE FUNCTION OPERACION.F_GET_NUM_PUNTOS_EF(a_codef in number) RETURN NUMBER IS
tmpVar NUMBER;
BEGIN
--   select count(*) into tmpvar from efpto where codef = a_codef ;
   select count(*) into tmpvar from efpto where codef = a_codef and pop is not null;

   RETURN tmpVar;
END;
/


