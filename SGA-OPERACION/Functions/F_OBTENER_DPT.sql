CREATE OR REPLACE FUNCTION OPERACION.F_OBTENER_DPT(dpt in varchar2)
RETURN VARCHAR2 IS
       result varchar2(20);
       query_str varchar2(1000);
BEGIN
     query_str := 'SELECT DESCABR FROM AREAOPE WHERE CODDPT = '||dpt;
     EXECUTE IMMEDIATE query_str
     INTO result;
     RETURN result;
END;
/


