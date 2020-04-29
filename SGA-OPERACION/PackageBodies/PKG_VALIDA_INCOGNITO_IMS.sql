create or replace package body operacion.PKG_VALIDA_INCOGNITO_IMS IS
  /****************************************************************************************
   NOMBRE:      OPERACION.PKG_VALIDA_INCOGNITO_IMS
   PROPOSITO:   AUTOMATIZACION

     Ver        Fecha        Autor             Solicitado por    Descripcion
   ---------  ----------  ----------------  ----------------  ------------------------
   1.0        24/09/2018    Hitss
  *****************************************************************************************/

  /******************************************************************************
  PROCEDURE inserta a las tablas temporales
  ******************************************************************************/
  PROCEDURE SP_INGRESA_DATA_TEMP (ln_error out number,
                                  lv_error out varchar2) is
  
  BEGIN
  
    DELETE FROM OPERACION.T_DATA_INCOGNITO;

    dbms_output.put_line('Ejecutando SP_DATA_TEMP_INCOGNITO ...');
    INTRAWAY.SP_DATA_TEMP_INCOGNITO(ln_error, lv_error);
    if ln_error = -1 then
      dbms_output.put_line('SP_DATA_TEMP_INCOGNITO, error: ' || lv_error);
      goto fin;
    end if;

   COMMIT;

    <<fin>>
    null;
  END;




 -- reportes

  /******************************************************************************
   -- Si la MAC no existe en incognito
  ******************************************************************************/
  PROCEDURE SP_NO_MAC_INCOGNITO(av_salida out sys_refcursor,
                                an_error  OUT NUMBER,
                                av_error  OUT VARCHAR2) IS
  BEGIN
    an_error := 0;
    open av_salida for

       SELECT I.LINEA || '|' || I.MAC || chr(10) || CHR(13)
          FROM OPERACION.T_DATA_INCOGNITO INC
         INNER JOIN (SELECT SUBSTR(LINEA, 3) LINEA,
                            UPPER(SUBSTR(MAC, INSTR(MAC, '-') + 1, 12)) MAC
                       FROM OPERACION.T_DATA_IMS) I
            ON INC.LINEA = I.LINEA
           AND I.MAC <> INC.MAC;

  EXCEPTION
    WHEN OTHERS THEN
      an_error := -1;
      av_error := sqlerrm;
  END;



  /******************************************************************************
   Si la linea no aparece en INCOGNITO, se dara de baja en IMS
  ******************************************************************************/
PROCEDURE SP_NO_LINEA_INCOGNITO(av_salida out sys_refcursor,
                                an_error  OUT NUMBER,
                                av_error  OUT VARCHAR2) IS

BEGIN
  an_error := 0;
    open av_salida for

    SELECT I.LINEA || '|' || I.MAC || chr(10) || CHR(13)
      FROM OPERACION.T_DATA_INCOGNITO INC
     RIGHT JOIN (SELECT SUBSTR(LINEA, 3) LINEA,
                        UPPER(SUBSTR(MAC, INSTR(MAC, '-') + 1, 12)) MAC
                   FROM OPERACION.T_DATA_IMS) I
        ON INC.LINEA = I.LINEA
     WHERE INC.LINEA IS NULL;

 EXCEPTION
    WHEN OTHERS THEN
      an_error := -1;
      av_error := sqlerrm;
END;


end PKG_VALIDA_INCOGNITO_IMS;
/

