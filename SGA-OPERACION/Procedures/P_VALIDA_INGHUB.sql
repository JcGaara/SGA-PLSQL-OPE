CREATE OR REPLACE PROCEDURE OPERACION.P_VALIDA_INGHUB(p_codpvc in varchar2,
                                                      p_codest in varchar2,
                                                      p_coddst in varchar2,
                                                      p_salida out number) IS
BEGIN
  SELECT COUNT(1)
    INTO p_salida
    FROM V_UBICACIONES T
   WHERE T.CODPAI = 51
     AND T.codest = p_codest
     AND T.codpvc = p_codpvc
     AND T.coddst = p_coddst;
END;
/


