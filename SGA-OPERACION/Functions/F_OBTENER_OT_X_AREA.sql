CREATE OR REPLACE FUNCTION OPERACION.F_OBTENER_OT_X_AREA(idsolot in number, dpt in varchar2)
RETURN NUMBER IS
       result number;
BEGIN
     SELECT F_GET_OT_X_SOL_AREA(idsolot, dpt) INTO result FROM DUAL;
     RETURN result;
END;
/


