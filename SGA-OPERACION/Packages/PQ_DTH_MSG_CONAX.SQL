CREATE OR REPLACE PACKAGE OPERACION.PQ_DTH_MSG_CONAX AS

  /***********************************************************************
  REVISIONES:
   Versión     Fecha         Autor              Solicitado por             Descripcion
  ---------  -----------   ----------------     -----------------    ----------------------------------
     1.0      06/03/2015   Antonio Astete       Henry Quispe         PROY-15263 Envío mensaje CONAX
     2.0      21/05/2015   Antonio Astete       Henry Quispe         SD-337043  Envío mensaje CONAX
  ************************************************************************/
  TYPE V_NUMTARJETA IS TABLE OF VARCHAR2(1000) INDEX BY BINARY_INTEGER;

  TYPE V_NTARJETA IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;

  /*CONSTANTES*/
  G_HOST                    VARCHAR2(1000);
  G_PUERTO                  VARCHAR2(1000);
  G_USUARIO                 VARCHAR2(1000);
  G_PASS                    VARCHAR2(1000);
  G_PASS2                   VARCHAR2(1000);
  G_DIRECTORIO_LOCAL        VARCHAR2(1000);
  G_DIRECTORIO_REMOTO_ENVIO VARCHAR2(1000);
  G_DIRECTORIO_REMOTO_OK    VARCHAR2(1000);
  G_DIRECTORIO_REMOTO_ERROR VARCHAR2(1000);

  PDIRECTORIO  CONSTANT VARCHAR2(50) := OPERACION.PQ_DTH.F_OBT_PARAMETRO_D('PARAM_DTH',
                                                                           'DirectorioLocal');
  PRUTKNOWHOST CONSTANT VARCHAR2(100) := OPERACION.PQ_DTH.F_OBT_PARAMETRO_D('PARAM_DTH',
                                                                            'RUT_KH');

  /************************************************************************************************
  *Tipo               : funcion
  *Descripción        : conversion de Binario a Decimal
  *Autor              : Antonio Astete
  *Proyecto o REQ     : PQT-208477-TSK-56543 Envío mensaje CONAX
  *Fecha de Creación  : 06/03/2015
  ************************************************************************************************/
  FUNCTION F_BIN2DEC(BINVAL IN CHAR) RETURN NUMBER;

  /************************************************************************************************
  *Tipo               : funcion
  *Descripción        : conversion de Decimal a binario
  *Autor              : Antonio Astete
  *Proyecto o REQ     : PQT-208477-TSK-56543 Envío mensaje CONAX
  *Fecha de Creación  : 06/03/2015
  ************************************************************************************************/
  FUNCTION F_DEC2BIN(N IN NUMBER) RETURN VARCHAR2;

  /************************************************************************************************
  *Tipo               : funcion
  *Descripción        : Conversion de Decimal a Hexadecimal
  *Autor              : Antonio Astete
  *Proyecto o REQ     : PQT-208477-TSK-56543 Envío mensaje CONAX
  *Fecha de Creación  : 06/03/2015
  ************************************************************************************************/
  FUNCTION F_DEC2HEX(N IN NUMBER) RETURN VARCHAR2;

  /************************************************************************************************
  *Tipo               : funcion
  *Descripción        : Conversion a Hexadecimal
  *Autor              : Antonio Astete
  *Proyecto o REQ     : PQT-208477-TSK-56543 Envío mensaje CONAX
  *Fecha de Creación  : 06/03/2015
  ************************************************************************************************/
  FUNCTION F_HEXADECIMAL(L_MENSAJE OPERACION.MENSAJE_DTH_CAB.MENSAJE%TYPE)
    RETURN VARCHAR;

  /************************************************************************************************
  *Tipo               : funcion
  *Descripción        : Obtiene configuraciones Establecidas en tipos y estados
  *Autor              : Antonio Astete
  *Proyecto o REQ     : PQT-208477-TSK-56543 Envío mensaje CONAX
  *Fecha de Creación  : 06/03/2015
  ************************************************************************************************/
  FUNCTION F_OBTIENE_PARAMETRO_ANHOS(P_PARAMETRO OPEDD.CODIGOC%TYPE)
    RETURN VARCHAR;

  /************************************************************************************************
  *Tipo               : funcion
  *Descripción        : Obtiene configuraciones del FTP Establecidas en tipos y estados
  *Autor              : Antonio Astete
  *Proyecto o REQ     : PQT-208477-TSK-56543 Envío mensaje CONAX
  *Fecha de Creación  : 06/03/2015
  ************************************************************************************************/
  FUNCTION F_OBTIENE_PARAMETRO_FTP(P_PARAMETRO OPEDD.CODIGOC%TYPE)
    RETURN VARCHAR;

  /************************************************************************************************
  *Tipo               : funcion
  *Descripción        : Validacion de las Tarjetas Ingresadas en el Archivo Plano o Por medio de Consultas
  *Autor              : Antonio Astete
  *Proyecto o REQ     : PQT-208477-TSK-56543 Envío mensaje CONAX
  *Fecha de Creación  : 06/03/2015
  ************************************************************************************************/
  FUNCTION F_VALIDA_TARJETA(P_COD_TARJETA OPERACION.MENSAJE_DTH_DET.CODTARJ%TYPE)
    RETURN NUMBER;

  /************************************************************************************************
  *Tipo               : funcion
  *Descripción        : Obtiene el Maximo numero de envios Registardo en tipos y estados
  *Autor              : Antonio Astete
  *Proyecto o REQ     : PQT-208477-TSK-56543 Envío mensaje CONAX
  *Fecha de Creación  : 06/03/2015
  ************************************************************************************************/
  FUNCTION F_OBTIENE_MAXIMO_ENVIOS RETURN NUMBER;

  /************************************************************************************************
  *Tipo               : Procedimiento
  *Descripción        : Registra Cabecera del Mensaje
  *Autor              : Antonio Astete
  *Proyecto o REQ     : PQT-208477-TSK-56543 Envío mensaje CONAX
  *Fecha de Creación  : 06/03/2015
  ************************************************************************************************/
  PROCEDURE P_REG_CAB_MSG(L_DESCRIPCION    IN VARCHAR2,
                          L_MENSAJE        IN VARCHAR2,
                          L_TIPOMENSAJE    IN NUMBER,
                          L_DURACION       IN NUMBER,
                          L_NUMREPETIC     IN NUMBER,
                          L_INTERVAREPETIC IN NUMBER,
                          L_FECHAINI       IN DATE,
                          L_HORAINI        IN DATE,
                          L_RESP           OUT NUMBER,
                          L_IDARCH         OUT NUMBER);

  /************************************************************************************************
  *Tipo               : Procedimiento
  *Descripción        : Registra Detalle del Mensaje
  *Autor              : Antonio Astete
  *Proyecto o REQ     : PQT-208477-TSK-56543 Envío mensaje CONAX
  *Fecha de Creación  : 06/03/2015
  ************************************************************************************************/
  PROCEDURE P_REG_DET_MSG(ID_PROC    IN NUMBER,
                          NUMTARJETA IN V_NUMTARJETA,
                          TOTAL      IN NUMBER);

  /************************************************************************************************
  *Tipo               : Procedimiento
  *Descripción        : Recupera configuraciones del DTH
  *Autor              : Antonio Astete
  *Proyecto o REQ     : PQT-208477-TSK-56543 Envío mensaje CONAX
  *Fecha de Creación  : 06/03/2015
  ************************************************************************************************/
  PROCEDURE P_SET_CONFIGURACION;

  /************************************************************************************************
  *Tipo               : Procedimiento
  *Descripción        : Creacion del Archivo para el envio a Conax
  *Autor              : Antonio Astete
  *Proyecto o REQ     : PQT-208477-TSK-56543 Envío mensaje CONAX
  *Fecha de Creación  : 06/03/2015
  ************************************************************************************************/
  PROCEDURE P_ENVIA_CONAX(ID_PROCESO IN NUMBER);

  /************************************************************************************************
  *Tipo               : Procedimiento
  *Descripción        : elimina el Archivo FTP que se creo en el Servidor
  *Autor              : Antonio Astete
  *Proyecto o REQ     : PQT-208477-TSK-56543 Envío mensaje CONAX
  *Fecha de Creación  : 06/03/2015
  ************************************************************************************************/
  PROCEDURE P_ELIMINAR_ARCHIVO_FTP(PHOST           IN VARCHAR2,
                                   PPUERTO         IN VARCHAR2,
                                   PUSUARIO        IN VARCHAR2,
                                   PPASS           IN VARCHAR2,
                                   P_ARCHIVOREMOTO IN VARCHAR2,
                                   P_RESULTADO_FTP IN OUT VARCHAR,
                                   P_MENSAJE_FTP   IN OUT VARCHAR);

  /************************************************************************************************
  *Tipo               : Procedimiento
  *Descripción        : Lectura de un cursor para la Ejecucion del Envio de Conax
  *Autor              : Antonio Astete
  *Proyecto o REQ     : PQT-208477-TSK-56543 Envío mensaje CONAX
  *Fecha de Creación  : 06/03/2015
  ************************************************************************************************/
  PROCEDURE P_CANT_ID_ARCHIVOS;

  /************************************************************************************************
  *Tipo               : Procedimiento
  *Descripción        : Almacena en el Servidor los archivos mayores a 1000 registros
  *Autor              : Antonio Astete
  *Proyecto o REQ     : PQT-208477-TSK-56543 Envío mensaje CONAX
  *Fecha de Creación  : 06/03/2015
  ************************************************************************************************/
  PROCEDURE P_ALMACENAR_ARCHIVO(ID_PROC    IN NUMBER,
                                NUMTARJETA IN V_NUMTARJETA,
                                TOTAL      IN NUMBER);

  /************************************************************************************************
  *Tipo               : Procedimiento
  *Descripción        : Genera el detalle del Mensaje Para los Archivos en estado Carga Pendiente en el Servidor
  *Autor              : Antonio Astete
  *Proyecto o REQ     : PQT-208477-TSK-56543 Envío mensaje CONAX
  *Fecha de Creación  : 06/03/2015
  ************************************************************************************************/
  PROCEDURE P_SHELL_INSERCION;

  /************************************************************************************************
  *Tipo               : Procedimiento
  *Descripción        : Genera el detalle del Mensaje Para los Archivos en estado Pendiente de Envio en el Servidor
  *Autor              : Antonio Astete
  *Proyecto o REQ     : PQT-208477-TSK-56543 Envío mensaje CONAX
  *Fecha de Creación  : 06/03/2015
  ************************************************************************************************/
  PROCEDURE P_SHELL_SEGUNDA_INSERCION;

  /************************************************************************************************
  *Tipo               : Procedimiento
  *Descripción        : Lectura de cursor de los Registros en Proceso Para su Actualiacion de Estado
  *Autor              : Antonio Astete
  *Proyecto o REQ     : PQT-208477-TSK-56543 Envío mensaje CONAX
  *Fecha de Creación  : 06/03/2015
  ************************************************************************************************/
  PROCEDURE P_FILE_ENVIADO_ACTUALIZA;

  /************************************************************************************************
  *Tipo               : Procedimiento
  *Descripción        : Actualiza el estado de la cabecera del Mensaje
  *Autor              : Antonio Astete
  *Proyecto o REQ     : PQT-208477-TSK-56543 Envío mensaje CONAX
  *Fecha de Creación  : 06/03/2015
  ************************************************************************************************/
  PROCEDURE P_ACTUALIZA_ESTADO_FILE(P_ID_CORRELATIVO IN OPERACION.TAB_ARCH_MSG_DTH.ID_ARCHIVO%TYPE);

  /************************************************************************************************
  *Tipo               : Procedimiento
  *Descripción        : Reenvia los Archivos, de acuerdo al valor establecido en Configuraciones de Tipos y estados.
  *Autor              : Antonio Astete
  *Proyecto o REQ     : PQT-208477-TSK-56543 Envío mensaje CONAX
  *Fecha de Creación  : 06/03/2015
  ************************************************************************************************/
  PROCEDURE P_ENVIAR_FILE_REENVIO(P_ID_CORRELATIVO IN OPERACION.TAB_ARCH_MSG_DTH.ID_ARCHIVO%TYPE,
                                  P_COD_FILE       IN OPERACION.TAB_ARCH_MSG_DTH.COD_FILE%TYPE);

  /************************************************************************************************
  *Tipo               : Procedimiento
  *Descripción        : Instruccion que realiza el Reenvio Manual desde el SGA
  *Autor              : Antonio Astete
  *Proyecto o REQ     : PQT-208477-TSK-56543 Envío mensaje CONAX
  *Fecha de Creación  : 06/03/2015
  ************************************************************************************************/
  PROCEDURE P_REENVIO_MANUAL(IDARCHIVORE IN V_NTARJETA);

  /************************************************************************************************
  *Tipo               : Funcion
  *Descripción        : Devuelve un listado de registros al SGA
  *Autor              : Antonio Astete
  *Proyecto o REQ     : PQT-208477-TSK-56543 Envío mensaje CONAX
  *Fecha de Creación  : 06/03/2015
  ************************************************************************************************/
  FUNCTION F_LISTAR_SOLICITUD_CAB_HIST RETURN TY_IENVDTH_TBL
    PIPELINED;

  /************************************************************************************************
  *Tipo               : Procedimiento
  *Descripción        : Realiza en Reenvio de Archivos al Servidor.
  *Autor              : Antonio Astete
  *Proyecto o REQ     : PQT-208477-TSK-56543 Envío mensaje CONAX
  *Fecha de Creación  : 06/03/2015
  ************************************************************************************************/
  PROCEDURE P_ACTUALIZA_ESTADO_FILE_MANUAL(P_ID_CORRELATIVO IN OPERACION.TAB_ARCH_MSG_DTH.ID_ARCHIVO%TYPE);

  /************************************************************************************************
  *Tipo               : Procedimiento
  *Descripción        : Ejecuta la Actualizacion de la Cabecera del Mensaje
  *Autor              : Antonio Astete
  *Proyecto o REQ     : PQT-208477-TSK-56543 Envío mensaje CONAX
  *Fecha de Creación  : 06/03/2015
  ************************************************************************************************/
  PROCEDURE P_BOTON_ENVIAR(IDARCHIVO IN V_NTARJETA);

  /************************************************************************************************
  *Tipo               : Funcion 
  *Descripción        : Realiza la Busqueda de SOT en el SGA. retorna los numeros de tarjetas asociados
                        a la SOT.
  *Autor              : Antonio Astete
  *Proyecto o REQ     : PQT-208477-TSK-56543 Envío mensaje CONAX
  *Fecha de Creación  : 06/03/2015
  ************************************************************************************************/
  FUNCTION F_FIND_SOT(P_CODSOLOT OPE_SRV_RECARGA_CAB.CODSOLOT%TYPE)
    RETURN VTATABCLI.CODCLI%TYPE;

  /************************************************************************************************
  *Tipo               : Funcion 
  *Descripción        : Realiza la Busqueda de Servicio en el SGA. retorna los numeros de tarjetas 
                        asociados al servicio.
  *Autor              : Antonio Astete
  *Proyecto o REQ     : PQT-208477-TSK-56543 Envío mensaje CONAX
  *Fecha de Creación  : 06/03/2015
  ************************************************************************************************/
  FUNCTION F_FIND_SERVICIO(P_NRO_SERVICIO NUMBER) RETURN NUMBER;

  /************************************************************************************************
  *Tipo               : Funcion 
  *Descripción        : Realiza la Busqueda de Clientes en el SGA.
  *Autor              : Antonio Astete
  *Proyecto o REQ     : PQT-208477-TSK-56543 Envío mensaje CONAX
  *Fecha de Creación  : 06/03/2015
  ************************************************************************************************/
  FUNCTION F_FIND_CLIENTE(P_TIPO_PAREO VARCHAR2,
                          P_CODCLI     VTATABCLI.CODCLI%TYPE)
    RETURN VTATABCLI.NOMCLI%TYPE;

  /************************************************************************************************
  *Tipo               : Funcion 
  *Descripción        : Realiza la Busqueda de las tarjetas asociadas al cliente
  *Autor              : Antonio Astete
  *Proyecto o REQ     : PQT-208477-TSK-56543 Envío mensaje CONAX
  *Fecha de Creación  : 06/03/2015
  ************************************************************************************************/
  FUNCTION F_LISTAR_TARJETAXCLIENTE(P_TIPO_PAREO  VARCHAR2,
                                    P_TIPO_FILTRO INTEGER,
                                    P_CODCLI      VTATABCLI.CODCLI%TYPE,
                                    P_DNI         OPE_SRV_RECARGA_CAB.CODIGO_RECARGA%TYPE,
                                    P_CODSOLOT    OPE_SRV_RECARGA_CAB.CODSOLOT%TYPE)
    RETURN TARJETA_CLIENTE_DTH_TBL
    PIPELINED;

  /************************************************************************************************
  *Tipo               : Funcion 
  *Descripción        : Devuelve un listado de Clientes al SGA.
  *Autor              : Antonio Astete
  *Proyecto o REQ     : PQT-208477-TSK-56543 Envío mensaje CONAX
  *Fecha de Creación  : 06/03/2015
  ************************************************************************************************/
  FUNCTION F_LISTADO_CLIENTE(P_TIPO_PAREO VARCHAR2,
                             P_NOMCLI     VTATABCLI.NOMCLI%TYPE)
    RETURN CLIENTE_DTH_TBL
    PIPELINED;

  /************************************************************************************************
  *Tipo               : Funcion 
  *Descripción        : Verifica la conectividad
  *Autor              : Antonio Astete
  *Proyecto o REQ     : PQT-208477-TSK-56543 Envío mensaje CONAX
  *Fecha de Creación  : 06/03/2015
  ************************************************************************************************/
  PROCEDURE P_VRF_ARCHIVO_ASCII(PHOST      IN VARCHAR2,
                                PPUERTO    IN VARCHAR2,
                                PUSUARIO   IN VARCHAR2,
                                PPASS      IN VARCHAR2,
                                PDIRECARCH IN VARCHAR2,
                                RESPUESTA  OUT VARCHAR2);

  /************************************************************************************************
  *Tipo               : Funcion 
  *Descripción        : Agrupa los archivos de mas de mil registros en grupos de 4000 reg.
  *Autor              : Antonio Astete
  *Proyecto o REQ     : PQT-208477-TSK-56543 Envío mensaje CONAX
  *Fecha de Creación  : 06/03/2015
  ************************************************************************************************/
  PROCEDURE P_TARJETAS(ID_PROCESO IN NUMBER);

  /************************************************************************************************
  *Tipo               : Funcion 
  *Descripción        : Registra los Errores presentados durante el proceso de Envio a Conax
  *Autor              : Antonio Astete
  *Proyecto o REQ     : PQT-208477-TSK-56543 Envío mensaje CONAX
  *Fecha de Creación  : 06/03/2015
  ************************************************************************************************/
  PROCEDURE P_LOG_ERROR(AN_ARCH   IN NUMBER,
                        AN_PROC   IN VARCHAR2,
                        AN_CODERR IN NUMBER,
                        AN_MSJERR IN VARCHAR2);
END PQ_DTH_MSG_CONAX;
/