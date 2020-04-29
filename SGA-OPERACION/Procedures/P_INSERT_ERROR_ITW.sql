CREATE OR REPLACE PROCEDURE OPERACION.p_insert_error_itw (p_codsolot number,p_nomproced varchar2) is
BEGIN
      insert into ope_error_itw (codsolot,NOMPROCED,CODUSU,FECUSU)
      values(p_codsolot,p_nomproced,user,sysdate);
      commit;

  exception
    WHEN OTHERS THEN
      NULL;
end;
/


