CREATE OR REPLACE PACKAGE OPERACION.PQ_DTH_INTERFAZ is

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
                                   pArchivoRemoto in varchar2);

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
                                    pArchivoRemoto in varchar2);

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
                            p_mensaje   IN OUT VARCHAR2);

  /***********************************************************************
    -- Procedimiento: Escribe Linea en Archivo
    -- Parametros:
       -- p_text_io: Parametro de salida de conexion con el archivo
       -- p_texto: Cadena o linea que será impresa en el archivo
       -- p_salto: '0': Sin salto de línea     '1': Con salto de linea
  ************************************************************************/

  PROCEDURE p_escribe_linea(p_text_io IN UTL_FILE.FILE_TYPE,
                            p_texto   IN varchar2,
                            p_salto   IN char);

  /***********************************************************************
    -- Procedimiento: Cerrar un fichero ubicado en el servidor
    -- Parametros:
       -- p_text_io: Parametro de salida de conexion con el archivo
  ************************************************************************/

  PROCEDURE p_cerrar_archivo(p_text_io in out UTL_FILE.FILE_TYPE);

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
                                pTimetowait    number);
                                
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
                                     pArchivoRemoto in varchar2);

  function f_mover_archivo(p_ruta_inicial varchar2, p_ruta_final varchar2)
    return number;

end PQ_DTH_INTERFAZ;
/
