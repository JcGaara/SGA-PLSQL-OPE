CREATE OR REPLACE PACKAGE OPERACION.PQ_OPE_UTIL_JAVA IS

  /*********************************************************************************************
      NOMBRE:           PQ_OPE_UTIL_JAVA
      PROPOSITO:        Funcionalidad de mover archivo.
      PROGRAMADO EN JOB:  NO
      REVISIONES:
      Ver     Fecha       Autor             Solicitado por        Descripcion
      ------  ----------  ---------------   -----------------     -----------------------------------
      1.0     30/11/2011  Ivan Untiveros   Guillermo Salcedo      REQ-161004 Sincronizacion WEBUNI
  ********************************************************************************************/

  /*******************************************************
  Constantes de resultado de procesos
  ********************************************************/
  FND_ESTADO_ERROR constant varchar2(10)   := 'ERROR';
	FND_ESTADO_OK    constant varchar2(10)   := 'OK';

/****************************************************************
Graba en la tabla log de la tabla de interface de paginas telmex
pn_idint: Identificador de la interface
pn_lote:  lote de carga
linea:    numero de la linea del archivo que lanzo el error
ps_mensaje: Descripcion del error

*****************************************************************/
PROCEDURE p_graba_log(pn_idint NUMBER,
                      pn_idlote NUMBER,
                      pn_linea NUMBER,
                      ps_mensaje VARCHAR2,
											ps_oraerror VARCHAR2);

/**********************************
Mueve un archivo
***********************************/
function mover_archivo(p_ruta_inicial varchar2, p_ruta_final varchar2) return number;

/**********************************
Carga un archivo a un servidor ftp
***********************************/
function cargar_archivo_ftp(ps_ftp_file varchar2, ps_local_file varchar2) return number;

/***************************************
Descarga un archivo de un servidor ftp
****************************************/
function descargar_archivo_ftp(ps_ftp_file varchar2, ps_local_file varchar2) return number;

  /***********************************************************************
    -- Procedimiento: Parte una cadena por un separador y devuelve un arreglo
    -- Parametros:
       -- p_linea: Cadena a ser dividida
       -- p_vars: Arreglo con cada uno de los elementos
       -- p_separador: Caracter separador
  ************************************************************************/

  procedure prc_dividir_linea(p_linea     in varchar2,
                              p_vars      in out DBMS_SQL.varchar2s,
                              p_separador char);

/**********************************
Crea Directorio
***********************************/

  function crea_directorio(p_ruta_direc varchar2) return number;
  
/**********************************
Comprueba la existencia de un Directorio
***********************************/  
  function existe_directorio(p_ruta_direc varchar2) return number;
  
/**********************************
Elimina archivo
***********************************/  
  function elimina_archivo(p_ruta_direc varchar2) return number;  

END PQ_OPE_UTIL_JAVA;
/
