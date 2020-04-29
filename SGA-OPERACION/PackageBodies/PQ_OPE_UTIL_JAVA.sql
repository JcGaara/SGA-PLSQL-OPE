CREATE OR REPLACE PACKAGE BODY OPERACION.PQ_OPE_UTIL_JAVA IS
/*********************************************************************************************
      NOMBRE:           PQ_OPE_UTIL_JAVA
      PROPOSITO:        Funcionalidad de mover archivo.
      PROGRAMADO EN JOB:  NO
      REVISIONES:
      Ver     Fecha       Autor             Solicitado por        Descripcion
      ------  ----------  ---------------   -----------------     -----------------------------------
      1.0     30/11/2011  Ivan Untiveros   Guillermo Salcedo      REQ-161004 Sincronizacion WEBUNI
  ********************************************************************************************/
PROCEDURE p_graba_log(pn_idint NUMBER,
                      pn_idlote NUMBER,
                      pn_linea NUMBER,
                      ps_mensaje VARCHAR2,
											ps_oraerror VARCHAR2) IS
  PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
  INSERT INTO COLLECTIONS.cxcintlogpagtel(idint,idlote,linea,mensaje,oraerror)
	VALUES(pn_idint,pn_idlote,pn_linea,ps_mensaje,ps_oraerror);
  COMMIT;
END;

function mover_archivo(p_ruta_inicial varchar2, p_ruta_final varchar2) return number is
	language java name 'com.creo.sga.pt.Shell.renameTo(java.lang.String,java.lang.String) return java.lang.int';

function cargar_archivo_ftp(ps_ftp_file varchar2, ps_local_file varchar2) return NUMBER IS
	language java name 'com.creo.sga.pt.FileUpload.upload(java.lang.String,java.lang.String) return java.lang.int';

function descargar_archivo_ftp(ps_ftp_file varchar2, ps_local_file varchar2) return NUMBER IS
	language java name 'com.creo.sga.pt.FileUpload.download(java.lang.String,java.lang.String) return java.lang.int';

  /***********************************************************************
    -- Procedimiento: Parte una cadena por un separador y devuelve un arreglo
    -- Parametros:
       -- p_linea: Cadena a ser dividida
       -- p_vars: Arreglo con cada uno de los elementos
       -- p_separador: Caracter separador
  ************************************************************************/

  procedure prc_dividir_linea(p_linea     in varchar2,
                              p_vars      in out DBMS_SQL.varchar2s,
                              p_separador char) is

    l_str long default p_linea || p_separador;
    l_n   number;

  begin

    loop
      l_n := instr(l_str, p_separador);
      exit when(nvl(l_n, 0) = 0);
      p_vars(p_vars.count) := ltrim(rtrim(substr(l_str, 1, l_n - 1)));
      l_str := substr(l_str, l_n + 1);
    end loop;

  end prc_dividir_linea;

function crea_directorio(p_ruta_direc varchar2)  return number is
	language java name 'com.creo.sga.pt.Shell.mkdir(java.lang.String) return java.lang.int';

function existe_directorio(p_ruta_direc varchar2)  return number is
	language java name 'com.creo.sga.pt.Shell.isDirectory(java.lang.String) return java.lang.int';

function elimina_archivo(p_ruta_direc varchar2) return number is  
  language java name 'com.creo.sga.pt.Shell.delete(java.lang.String) return java.lang.int';


END PQ_OPE_UTIL_JAVA;
/
