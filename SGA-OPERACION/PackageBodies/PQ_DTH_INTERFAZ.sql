CREATE OR REPLACE PACKAGE BODY OPERACION.PQ_DTH_INTERFAZ is

  /***********************************************************************
    -- Procedimiento: Envia un fichero via FTP a un servidor remoto
    -- Parametros:
       -- pHost: Nombre o ip del servidor remoto
       -- pPuerto: Puerto utilizado para la conexion ftp. Generalmente 21
       -- pUsuario: Nombre de usuario de conexion FTP
       -- pPass: Password usado para la conexion
       -- pDirectorio: Ruta absoluta del servidor de la BD en donde esta el file
       -- pArchivoLocal: Nombre del fichero que residira en el servidor local
       -- pArchivoRemoto: Ruta y nombre absoluto del archivo que recidirá en
          el servidor remoto.
  ************************************************************************/

  procedure p_enviar_archivo_ascii(pHost          in varchar2,
                                   pPuerto        in varchar2,
                                   pUsuario       in varchar2,
                                   pPass          in varchar2,
                                   pDirectorio    in varchar2,
                                   pArchivoLocal  in varchar2,
                                   pArchivoRemoto in varchar2) is
    l_conn   UTL_TCP.connection;
    l_result varchar2(2000);
  begin
    if pPuerto = '21' then
      l_conn := ftp.login(pHost, pPuerto, pUsuario, pPass);
      ftp.ascii(p_conn => l_conn);
      ftp.put(p_conn      => l_conn,
              p_from_dir  => pDirectorio,
              p_from_file => pArchivoLocal,
              p_to_file   => pArchivoRemoto);
      ftp.logout(l_conn);
      utl_tcp.close_all_connections;
    elsif pPuerto = '22' then
      l_result := ftp.send_file_scp(pHost,
                                    pUsuario,
                                    pPass,
                                    pDirectorio,
                                    pArchivoLocal,
                                    pArchivoRemoto);
      if substr(l_result,0,2) <> 'OK' then
         raise_application_error(-2000,l_result);
      end if;
    end if;
  end p_enviar_archivo_ascii;

  /***********************************************************************
    -- Procedimiento: Recibe un fichero via FTP desde un servidor remoto
    -- Parametros:
       -- pHost: Nombre o ip del servidor remoto
       -- pPuerto: Puerto utilizado para la conexion ftp. Generalmente 21
       -- pUsuario: Nombre de usuario de conexion FTP
       -- pPass: Password usado para la conexion
       -- pDirectorio: Ruta absoluta del servidor de la BD en donde estara el file
       -- pArchivoLocal: Nombre del fichero que residira en el servidor local
       -- pArchivoRemoto: Ruta y nombre absoluto del archivo que recidirá en
          el servidor remoto.
  ************************************************************************/

  procedure p_recibir_archivo_ascii(pHost          in varchar2,
                                    pPuerto        in varchar2,
                                    pUsuario       in varchar2,
                                    pPass          in varchar2,
                                    pDirectorio    in varchar2,
                                    pArchivoLocal  in varchar2,
                                    pArchivoRemoto in varchar2) is
    l_conn UTL_TCP.connection;
    l_result varchar2(2000);
  begin
    if pPuerto = '21' then
      l_conn := ftp.login(pHost, pPuerto, pUsuario, pPass);
      ftp.ascii(p_conn => l_conn);
      ftp.get(p_conn      => l_conn,
              p_from_file => pArchivoRemoto,
              p_to_dir    => pDirectorio,
              p_to_file   => pArchivoLocal);
      ftp.logout(l_conn);
      utl_tcp.close_all_connections;
    elsif pPuerto = '22' then
      l_result := ftp.get_file_scp(pHost,
                                   pUsuario,
                                   pPass,
                                   pDirectorio,
                                   pArchivoLocal,
                                   pArchivoRemoto);
      if substr(l_result,0,2) <> 'OK' then
         raise_application_error(-2000,l_result);
      end if;
    end if;
  end p_recibir_archivo_ascii;

  /***********************************************************************
    -- Procedimiento: Abre un fichero ubicado en el servidor
    -- Parametros:
       -- p_text_io: Parametro de salida de conexion con el archivo
       -- p_ruta: Ruta de ubicacion del archivo en el servidor
                  (debe estar en el UTL_FILE_DIR)
       -- p_nombre: Nombre de archivo (Case sensitive)
       -- p_acceso: Forma de acceso al archivo. Ejm: 'r' (lectura)
  ************************************************************************/

  PROCEDURE p_abrir_archivo(p_text_io   in out UTL_FILE.FILE_TYPE,
                            p_ruta      IN VARCHAR2,
                            p_nombre    IN VARCHAR2,
                            p_acceso    IN VARCHAR2,
                            p_resultado IN OUT VARCHAR2,
                            p_mensaje   IN OUT VARCHAR2) is
  BEGIN
    p_text_io   := UTL_FILE.FOPEN(p_ruta, p_nombre, p_acceso);
    p_resultado := 'OK';
  EXCEPTION
    WHEN OTHERS THEN
      p_resultado := 'ERROR';
      p_mensaje   := 'Error al abrir archivo. ' || SQLCODE || ' ' ||
                     SQLERRM;
  END p_abrir_archivo;

  /***********************************************************************
    -- Procedimiento: Escribe Linea en Archivo
    -- Parametros:
       -- p_text_io: Parametro de salida de conexion con el archivo
       -- p_texto: Cadena o linea que será impresa en el archivo
       -- p_salto: '0': Sin salto de línea     '1': Con salto de linea
  ************************************************************************/

  PROCEDURE p_escribe_linea(p_text_io IN UTL_FILE.FILE_TYPE,
                            p_texto   IN varchar2,
                            p_salto   IN char) is
    s_texto varchar2(6000) := p_texto;
  BEGIN

    if p_salto = '1' then
      s_texto := s_texto || chr(13);
    end if;
    UTL_FILE.PUT_LINE(p_text_io, s_texto);

  END p_escribe_linea;

  /***********************************************************************
    -- Procedimiento: Cerrar un fichero ubicado en el servidor
    -- Parametros:
       -- p_text_io: Parametro de salida de conexion con el archivo
  ************************************************************************/

  PROCEDURE p_cerrar_archivo(p_text_io in out UTL_FILE.FILE_TYPE) is
  BEGIN
    IF UTL_FILE.IS_OPEN(p_text_io) then
      UTL_FILE.FCLOSE(p_text_io);
    END IF;
  END p_cerrar_archivo;

  /***********************************************************************
    -- Funcion: Mueve un archivo
    -- Parametros:
       -- p_ruta_inicial: Ruta absoluta del archivo
       -- p_ruta_final:   Ruta absoluta en donde quedará el archivo
    -- Salida:
       -- 1: Exito, 0: Fracaso
  ************************************************************************/

  PROCEDURE p_env_proc_rec_file(pHost          in varchar2,
                                pPuerto        in varchar2,
                                pUsuario       in varchar2,
                                pPass          in varchar2,
                                pDirectorio    in varchar2,
                                pArchivoLocal  in varchar2,
                                pArchivoRemoto in varchar2,
                                pTimetowait    number) is

  begin

    p_enviar_archivo_ascii(pHost,
                           pPuerto,
                           pUsuario,
                           pPass,
                           pDirectorio,
                           pArchivoLocal,
                           pArchivoRemoto);
    --sys.dbms_lock.sleep(pTimetowait);
    --sys.DBMS_LOCK.sleep(seconds => pTimetowait );
    p_recibir_archivo_ascii(pHost,
                            pPuerto,
                            pUsuario,
                            pPass,
                            pDirectorio,
                            pArchivoLocal,
                            pArchivoRemoto);

  end p_env_proc_rec_file;
  
  /***********************************************************************
    -- Procedimiento: Recibe un fichero via FTP desde un servidor remoto
    -- Parametros:
       -- pHost: Nombre o ip del servidor remoto
       -- pPuerto: Puerto utilizado para la conexion ftp. Generalmente 21
       -- pUsuario: Nombre de usuario de conexion FTP
       -- pPass: Password usado para la conexion
       -- pDirectorio: Ruta absoluta del servidor de la BD en donde estara el file
       -- pArchivoLocal: Nombre del fichero que residira en el servidor local
       -- pArchivoRemoto: Ruta y nombre absoluto del archivo que recidirá en
          el servidor remoto.
  ************************************************************************/

  procedure p_eliminar_archivo_ascii(pHost          in varchar2,
                                     pPuerto        in varchar2,
                                     pUsuario       in varchar2,
                                     pPass          in varchar2,
                                     pArchivoRemoto in varchar2) is
    l_conn UTL_TCP.connection;
    l_result varchar2(2000);
    l_knowhost varchar2(100);
  begin
    if pPuerto = '21' then
      l_conn := ftp.login(pHost, pPuerto, pUsuario, pPass);
      ftp.ascii(p_conn => l_conn);
      ftp.delete(p_conn => l_conn, p_file => pArchivoRemoto);
      ftp.logout(l_conn);
      utl_tcp.close_all_connections;
    elsif pPuerto = '22' then
      l_knowhost := operacion.pq_dth.f_obt_parametro_d('PARAM_DTH','RUT_KH');
      l_result   :=operacion.sftp.eliminArchivo(pUsuario,
                                                pPass,
                                                pHost,
                                                pPuerto,
                                                l_knowhost,
                                                pArchivoRemoto);
      if substr(l_result,0,2) <> 'OK' then
         raise_application_error(-2000,l_result);
      end if;
    end if;
  end p_eliminar_archivo_ascii;

  function f_mover_archivo(p_ruta_inicial varchar2, p_ruta_final varchar2)
    return number is
    language java name 'com.creo.util.Shell.renameTo(java.lang.String,java.lang.String) return java.lang.int';

end PQ_DTH_INTERFAZ;
/
