CREATE OR REPLACE FUNCTION OPERACION.F_GET_ASIGNACION_SID (a_sid in number) RETURN varchar2 IS
tmpVar varchar2(4000);

BEGIN


   RETURN RED.f_obtener_asignacion(A_SID);

   EXCEPTION
     WHEN OTHERS THEN
       return Null;

END;
/


