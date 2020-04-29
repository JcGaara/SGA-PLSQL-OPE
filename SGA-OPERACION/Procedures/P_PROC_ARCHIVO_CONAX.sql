CREATE OR REPLACE PROCEDURE OPERACION.p_proc_archivo_conax(
                            p_ruta      IN VARCHAR2,
                            p_nombre    IN VARCHAR2,
                            p_acceso    IN VARCHAR2,
                            p_estado    IN BOOLEAN,
                            p_file_errors IN VARCHAR2,
                            p_resultado IN OUT VARCHAR2,
                            p_mensaje   IN OUT VARCHAR2
                            ) is

  p_text_io                 UTL_FILE.FILE_TYPE;
  p_texto                   VARCHAR2(100);
  check_eof                 BOOLEAN;
  ls_result1                VARCHAR2(300);
  ls_result2                VARCHAR2(300);
  ls_result3                VARCHAR2(300);
  ls_nombre                 VARCHAR2(300);
  i                         int;
 /* p_buscar_archivo          int;
  l_buscar_archivo          int;*/
  type t_errores is table of varchar2 (200)
  index by binary_integer;
  p_errores t_errores;


  BEGIN
       i := 0;
       ls_nombre := p_nombre;
       IF (p_estado) THEN
          p_resultado:='OK';
       ELSE
           BEGIN
           --ABRIR ARCHIVO
           operacion.PQ_DTH_INTERFAZ.p_abrir_archivo(p_text_io,p_ruta,p_file_errors,p_acceso,p_resultado,p_mensaje);

           --LEER ARCHIVO
           LOOP
               BEGIN
                    i := i + 1;
                    operacion.p_lee_linea(p_text_io, p_texto);

                    select OPERACION.F_CB_subcadena2(p_texto , 1) Into ls_result3  from dual;

                    ls_result1:= Substr(ls_result3,1,length(ls_result3)-1);

                    IF  TRIM(ls_nombre) = TRIM(ls_result1) THEN
                        operacion.p_lee_linea(p_text_io, p_texto);
                        select OPERACION.F_CB_subcadena2(p_texto , 1) Into ls_result1  from dual;
                        select OPERACION.F_CB_subcadena2(p_texto , 2) Into ls_result2  from dual;

                        IF TRIM(ls_result1) = 'ERR_CAMODE' OR TRIM(ls_result1) = 'ERR_TRANSNUM' OR TRIM(ls_result1) = 'ERR_PRODUCT' OR TRIM(ls_result1) = 'ERR_DATES'   OR TRIM(ls_result1) = 'ERR_PRIORITY'   OR TRIM(ls_result1) = 'ERR_NUMOFCARDS'   OR TRIM(ls_result1) = 'ERR_CARDNUM'   OR TRIM(ls_result1) = 'ERR_ENDREQ' THEN

                          CASE  ls_result1
                             WHEN 'ERR_CAMODE'           THEN p_errores(i):= 'Tipo de Requerimiento no soportado. Error en linea: ' || ls_result2;
                             WHEN 'ERR_TRANSNUM'         THEN p_errores(i):= 'El N° Registro indicado en el archivo no coincide con el número de transacción en el nombre del Archivo. Error en linea: ' || ls_result2;
                             WHEN 'ERR_PRODUCT'          THEN p_errores(i):= 'Producto no identificado por el SMS. Error en linea: ' || ls_result2;
                             WHEN 'ERR_DATES'            THEN p_errores(i):= 'Periodo de suscripción ilegal. Error en linea: ' || ls_result2;
                             WHEN 'ERR_PRIORITY'         THEN p_errores(i):= 'Prioridad de transacción invalida. Error en linea: ' || ls_result2;
                             WHEN 'ERR_NUMOFCARDS'       THEN p_errores(i):= 'Número de tarjetas registaradas no coincide con la cantidad listada en el archivo. Error en linea: ' || ls_result2;
                             WHEN 'ERR_CARDNUM'          THEN p_errores(i):= 'Número de tarjeta no registrada para el SMS. Error en linea: ' || ls_result2;
                             WHEN 'ERR_ENDREQ'           THEN p_errores(i):= 'El fin del archivo es diferente de ZZZ. Error en linea: ' || ls_result2;
                             ELSE p_errores(i):= 'Otro error no definido';
                          END CASE;
                          p_mensaje := p_mensaje || '' || p_errores(i) || chr(13) || chr(10);
                          p_resultado:='ERROR4';
                          check_eof := TRUE;
                        END IF;

                    END IF;

               EXCEPTION
               WHEN NO_DATA_FOUND THEN
                    check_eof := TRUE;
               END;

               IF (check_eof) THEN
                  EXIT;
               END IF;

           END LOOP;

           EXCEPTION
           WHEN OTHERS THEN
           p_resultado := 'ERROR5';
           p_mensaje   := 'Error al leer archivo. ' || SQLCODE || ' ' ||
                     SQLERRM;

           END;
       END IF;

  END p_proc_archivo_conax;
/


