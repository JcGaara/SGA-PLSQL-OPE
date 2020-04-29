CREATE OR REPLACE PROCEDURE OPERACION.p_lee_linea(p_text_io IN UTL_FILE.FILE_TYPE,
                            p_texto   OUT varchar2) is
  BEGIN

    UTL_FILE.GET_LINE(p_text_io, p_texto);


  END p_lee_linea;
/


