CREATE OR REPLACE FUNCTION OPERACION.F_GET_CLAVE_FACTURAPEX RETURN NUMBER IS
tmpVar NUMBER;

BEGIN
	SELECT SQ_FACTURAPEX_ID.NEXTVAL INTO tmpVar FROM dual;

   RETURN tmpVar;
END;
/

