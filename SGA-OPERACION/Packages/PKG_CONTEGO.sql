CREATE OR REPLACE PACKAGE OPERACION.PKG_CONTEGO IS

  C_SP_ALTA                     CONSTANT VARCHAR2(15) := 'SGASS_ALTA';
  C_SP_PAREO                    CONSTANT VARCHAR2(15) := 'SGASS_PAREO';
  C_SP_DESPAREO                 CONSTANT VARCHAR2(15) := 'SGASS_DESPAREO';
  C_SP_ACTIVAR                  CONSTANT VARCHAR2(30) := 'SGASS_ACTIVARBOUQUET';
  C_SP_ENVHIST                  CONSTANT VARCHAR2(30) := 'SGASS_ENVHISTCONTEGO';
  C_SP_WSCONTEGO                CONSTANT VARCHAR2(30) := 'SGASS_WSCONTEGO';
  C_SP_REGXML                   CONSTANT VARCHAR2(30) := 'SGASS_REGXML';
  C_SP_REGCONTEGO               CONSTANT VARCHAR2(20) := 'SGASI_REGCONTEGOHIST';
  C_SP_VALIDAALTA               CONSTANT VARCHAR2(20) := 'SGASS_VALIDARALTA';
  C_SP_VALPROVISION             CONSTANT VARCHAR2(20) := 'SGASS_VALPROVISION';
  C_SP_SGASS_CONSULTA_ERROR     CONSTANT VARCHAR2(20) := 'SGASS_CONSULTA_ERROR';
  C_SP_ACTIVARBOUQUET_MASIVO    CONSTANT VARCHAR2(50) := 'SGASS_ACTIVARBOUQUET_MASIVO';
  C_SP_DESACTIVARBOUQUET_MASIVO CONSTANT VARCHAR2(50) := 'SGASS_DESACTIVARBOUQUET_MASIVO';
  C_SP_DESACTIVAR               CONSTANT VARCHAR2(50) := 'SGASS_DESACTIVARBOUQUET';
  C_SP_DESPAREO_MASIVO          CONSTANT VARCHAR2(50) := 'SGASS_DESPAREO_MASIVO';
  C_SP_BAJA                     CONSTANT VARCHAR2(15) := 'SGASS_BAJA';
  C_SP_SUSP_LTE                 CONSTANT VARCHAR2(30) := 'SGASS_SUSPENSION_LTE';
  C_SP_SUSP_PRE                 CONSTANT VARCHAR2(30) := 'SGASS_SUSPENSION_PREPAGO';
  C_UPD_CONTEGO                 CONSTANT VARCHAR2(30) := 'SGASU_TRSCONTEGO';
  C_SP_VERIFCONTEGO             CONSTANT VARCHAR2(30) := 'SGASS_VERIFCONTEGO';
  C_SP_REENV_LT                 CONSTANT VARCHAR2(30) := 'SGASS_REENVIO_LT_CONTEGO';
  C_SP_SUSP_CANC_POS            CONSTANT VARCHAR2(30) := 'SGASS_SUSP_CANC_POSTPAGO';
  C_MSG_CANCELADO               CONSTANT VARCHAR2(35) := 'CANCELADO A PETICION DEL USUARIO';
  C_MSG_REINTENTO               CONSTANT VARCHAR2(40) := 'NUMERO DE REINTENTOS MAXIMO PERMITIDO';
  C_DTH_ACTIONS                 CONSTANT VARCHAR2(30) := 'CONF_CONTEGO_DTH_ACTIONS';
  C_TIP_BOUQUET_ALTA            CONSTANT VARCHAR(4) := 'ALTA';
  C_TIP_BOUQUET_BAJA            CONSTANT VARCHAR(4) := 'BAJA';
  C_ACTION_RECONEXION           CONSTANT NUMBER := 110;
  C_ACTION_SUSPENSION           CONSTANT NUMBER := 108;
  C_ACTION_BAJA                 CONSTANT NUMBER := 105;
  C_ACTION_ACTIVACION           CONSTANT NUMBER := 103;
  C_ACTION_ALTA                 CONSTANT NUMBER := 101;
  C_RESP_OK                     CONSTANT CHAR(2) := 'OK';
  C_DESACTIVO                   CONSTANT CHAR(1) := '0';
  C_ACTIVADO                    CONSTANT CHAR(1) := '1';
  C_GENERADO                    CONSTANT CHAR(1) := '1';
  C_GENERADO_APP                CONSTANT CHAR(1) := '7';
  C_ENVIADO                     CONSTANT CHAR(1) := '2';
  C_PROV_OK                     CONSTANT CHAR(1) := '3';
  C_PROV_ERROR                  CONSTANT CHAR(1) := '4';
  C_PROV_REPORTADO              CONSTANT CHAR(1) := '5';
  C_PROV_CANCELADO              CONSTANT CHAR(1) := '6';
  C_AUX_LOTEREV                 CONSTANT NUMBER(1) := 7;
  C_AUX_VERIFICADO              CONSTANT NUMBER(1) := 6;
  C_AUX_ENVIADA                 CONSTANT NUMBER(1) := 4;
  C_CAB_ENVIADA                 CONSTANT NUMBER(1) := 2;
  C_CAB_CANCELADA               CONSTANT NUMBER(1) := 5;
  C_CAB_OK                      CONSTANT NUMBER(1) := 3;
  C_PROC_ACTIVO                 CONSTANT CHAR(1) := 'A';
  /****************************************************************
  * Nombre Package : OPERACION.PKG_CONTEGO
  * Proposito      : Paquete con Objetos Necesarios Para la PROVISION SGA - CONTEGO
  * Fec. Creacion  :  01/08/2017

     Version    Fecha       Autor            Solicitado por    Descripcion
     ---------  ----------  ---------------  --------------    -----------------------------------------

  ****************************************************************/
  /****************************************************************
  * Nombre SP      : SGASS_ALTA
  * Proposito      : Este SP es el principal para empezar el proceso de alta.
                     Desde aqui se empezara el proceso con las validaciones y
                     registro de pareo, despareo y alta de bouquets en la tabla
                     transaccional
  * Input          : K_NUMREGISTRO - Numero de registro a procesar
  * Output         : K_RESPUESTA
                     K_MENSAJE
  * Creado por     : Jose Arriola
  * Fec. Creacion  : 01/08/2017
  * Fec. Actualizacion : --
  ****************************************************************/
  PROCEDURE SGASS_ALTA(K_NUMREGISTRO OPERACION.OPE_SRV_RECARGA_CAB.NUMREGISTRO%TYPE,
                       K_RESPUESTA   IN OUT VARCHAR2,
                       K_MENSAJE     IN OUT VARCHAR2);
  /****************************************************************
  * Nombre SP      : SGASS_PAREO
  * Proposito      : Este SP genera informacion para el proceso de
                     pareo
  * Input          : K_NUMREGISTRO - Numero de registro
                     k_CODSOLOT - SOT
  * Output         : K_RESPUESTA
                     K_MENSAJE
  * Creado por     : Jose Arriola
  * Fec. Creacion  : 01/08/2017
  * Fec. Actualizacion : --
  ****************************************************************/
  PROCEDURE SGASS_PAREO(K_NUMREGISTRO OPERACION.OPE_SRV_RECARGA_CAB.NUMREGISTRO%TYPE,
                        K_CODSOLOT    OPERACION.SOLOT.CODSOLOT%TYPE,
                        K_RESPUESTA   IN OUT VARCHAR2,
                        K_MENSAJE     IN OUT VARCHAR2);
  /****************************************************************
  * Nombre SP      : SGASS_DESPAREO
  * Proposito      : Este SP genera informacion para el proceso de
                     despareo
  * Input          : K_NUMREGISTRO
                     k_CODSOLOT
  * Output         : K_RESPUESTA
                     K_MENSAJE
  * Creado por     : Jose Arriola
  * Fec. Creacion  : 01/08/2017
  * Fec. Actualizacion : --
  ****************************************************************/
  PROCEDURE SGASS_DESPAREO(K_NUMREGISTRO OPERACION.OPE_SRV_RECARGA_CAB.NUMREGISTRO%TYPE,
                           K_CODSOLOT    OPERACION.SOLOT.CODSOLOT%TYPE, ---investigar porq antes no estaba
                           K_RESPUESTA   IN OUT VARCHAR2,
                           K_MENSAJE     IN OUT VARCHAR2);
  /****************************************************************
  * Nombre SP      : SGASS_ACTIVARBOUQUET
  * Proposito      : Este SP genera informacion para el proceso de
                     activacion
  * Input          : K_NUMREGISTRO - Numero de registro
                     k_CODSOLOT - SOT
  * Output         : K_RESPUESTA
                     K_MENSAJE
  * Creado por     : Jose Arriola
  * Fec. Creacion  : 01/08/2017
  * Fec. Actualizacion : --
  ****************************************************************/
  PROCEDURE SGASS_ACTIVARBOUQUET(K_NUMREGISTRO OPERACION.OPE_SRV_RECARGA_CAB.NUMREGISTRO%TYPE,
                                 K_CODSOLOT    OPERACION.SOLOT.CODSOLOT%TYPE,
                                 K_RESPUESTA   IN OUT VARCHAR2,
                                 K_MENSAJE     IN OUT VARCHAR2);
  /****************************************************************
  * Nombre SP      : SGASS_WSCONTEGO
  * Proposito      : Este SP genera los XML para pareo, despareo y
                     activacion segun sea el caso y las envia hacia
                     contego poniendo las transacciones en estado 2.
  * Input          : K_ESTADO - Estado de la transaccion
  * Output         : K_CURSOR
                     K_RESPUESTA
                     K_MENSAJE
  * Creado por     : Jose Arriola
  * Fec. Creacion  : 01/08/2017
  * Fec. Actualizacion : --
  ****************************************************************/
  PROCEDURE SGASS_WSCONTEGO(K_ESTADO    IN VARCHAR2,
                            K_CURSOR    OUT SYS_REFCURSOR,
                            K_RESPUESTA OUT VARCHAR2,
                            K_MENSAJE   OUT VARCHAR2);
  /****************************************************************
  * Nombre SP      : SGASI_REGCONTEGO
  * Proposito      : SP utilizado para realizar la grabacion en la
                     tabla transaccional
  * Input          : K_TRS - rowtype de SGAT_TRXCONTEGO
  * Output         : K_RESPUESTA
  * Creado por     : Jose Arriola
  * Fec. Creacion  : 01/08/2017
  * Fec. Actualizacion : --
  ****************************************************************/
  PROCEDURE SGASI_REGCONTEGO(K_TRS       IN OPERACION.SGAT_TRXCONTEGO%ROWTYPE,
                             K_RESPUESTA OUT VARCHAR2);
  /****************************************************************
  * Nombre SP      : SGASI_REGCONTEGOHIST
  * Proposito      : SP utilizado para grabar en la tabla historica y
                     eliminarlo de la transaccional
  * Input          : K_CODSOLOT - SOT
  * Output         : K_RESPUESTA
  * Creado por     : Jose Arriola
  * Fec. Creacion  : 01/08/2017
  * Fec. Actualizacion : --
  ****************************************************************/
  PROCEDURE SGASI_REGCONTEGOHIST(K_CODSOLOT  IN OPERACION.SGAT_TRXCONTEGO.TRXN_CODSOLOT%TYPE,
                                 K_RESPUESTA OUT NUMBER);
  /****************************************************************
  * Nombre SP      : SGASI_REGLOTEHIST
  * Proposito      : SP utilizado para grabar en la tabla historica y
                     eliminarlo de la transaccional
  * Input          : K_CODSOLOT - SOT
  * Output         : K_RESPUESTA
  * Creado por     : Jose Arriola
  * Fec. Creacion  : 01/08/2017
  * Fec. Actualizacion : --
  ****************************************************************/
  PROCEDURE SGASI_REGLOTEHIST(K_lote  IN OPERACION.SGAT_TRXCONTEGO.TRXN_IDLOTE%TYPE,
                                 K_RESPUESTA OUT NUMBER);
  /****************************************************************
  * Nombre SP      : SGASP_LOGERR
  * Proposito      : Todos los procesos van a tener que volcar sus errores
                     en una tabla donde se manejen los logs.
                     Este SP recibe los datos necesarios para saber que tipo
                     de error sucedi?, cuando y en que proceso y los graba en
                     la tabla OPERACION.SGAT_LOGERR
  * Input          : p_logerrv_proceso - Proceso (sp o function) en el cual ocurrio
                                         la incidencia o error.
                     p_logerrc_numregistro - numero de registro
                     p_logerrc_codsolot - SOT
                     p_logerrv_error - codigo de error
                     p_logerrv_texto - descripcion del error
  * Creado por     : Jose Arriola
  * Fec. Creacion  : 01/08/2017
  * Fec. Actualizacion : --
  ****************************************************************/
  PROCEDURE SGASP_LOGERR(p_logerrv_proceso     operacion.sgat_logerr.logerrv_proceso%type,
                         p_logerrc_numregistro operacion.sgat_logerr.logerrc_numregistro%type,
                         p_logerrc_codsolot    operacion.sgat_logerr.logerrc_codsolot%type,
                         p_logerrv_error       operacion.sgat_logerr.logerrv_error%type,
                         p_logerrv_texto       operacion.sgat_logerr.logerrv_texto%type);
  /****************************************************************
  * Nombre SP      : SGASU_TRSCONTEGO
  * Proposito      : Un servicio atomico se encargara de invocar el SP
                     que traera la respuesta de contego y actualizara
                     el estado de la tabla transaccional.
                     Dichos errores se traduciran y se actualizaran los
                     estados y la descripcion del mismo.
  * Input          : K_IDTRANSACCION - Identificador princial de la tabla
                                       transaccional SGAT_TRXCONTEGO
                     K_ESTADO - Estado de la transaccion
  * Output         : K_RESPUESTA
                     K_MENSAJE
  * Creado por     : Jose Arriola
  * Fec. Creacion  : 01/08/2017
  * Fec. Actualizacion : --
  ****************************************************************/
  PROCEDURE SGASU_TRSCONTEGO(K_IDTRANSACCION OPERACION.SGAT_TRXCONTEGO.TRXN_IDTRANSACCION%TYPE,
                             K_ESTADO        VARCHAR2,
                             K_MSJCONTEGO    VARCHAR2,
                             K_RESPUESTA     OUT NUMBER,
                             K_MENSAJE       OUT VARCHAR2);
  /****************************************************************
  * Nombre SP      : SGASS_ENVHISTCONTEGO
  * Proposito      : Un JAR se encargara de invocar al sp, el mismo que
                     se encarga de trasladar todos los registros procesados
                     correctamente (Estado 3) de la tabla transaccional
                     hasta la tabla historica
  * Output         : k_RESPUESTA
                     k_MENSAJE
  * Creado por     : Jose Arriola
  * Fec. Creacion  : 01/08/2017
  * Fec. Actualizacion : --
  ****************************************************************/
  PROCEDURE SGASS_ENVHISTCONTEGO(K_RESPUESTA OUT NUMBER,
                                 K_MENSAJE   OUT VARCHAR2);
  /****************************************************************
  * Nombre SP      : SGASS_VALIDARALTA
  * Proposito      : Este SP se encargara de validar si se realizo la
                     activacion para ello consulta el estado de las
                     transacciones en la tabla OPERACION.SGAT_TRXCONTEGO
                     o la tabla HISTORICO.SGAT_TRXCONTEGO_HIST.
                     Para ello se buscara todos los estados de la SOT y
                     se mostrara cuales son y se modificara la tabla de provision
  * Input          : K_NUMREGISTRO - Numero de registro
  * Output         : k_RESPUESTA
                     k_MENSAJE
  * Creado por     : Jose Arriola
  * Fec. Creacion  : 01/08/2017
  * Fec. Actualizacion : --
  ****************************************************************/
  PROCEDURE SGASS_VALIDARALTA(K_NUMREGISTRO OPERACION.OPE_SRV_RECARGA_CAB.NUMREGISTRO%TYPE,
                              K_RESPUESTA   IN OUT VARCHAR2,
                              K_MENSAJE     IN OUT VARCHAR2);
  PROCEDURE SGASP_UPD_EST_CONTEGO(K_IDTRANSACCION OPERACION.SGAT_TRXCONTEGO.TRXN_IDTRANSACCION%TYPE,
                                  K_ESTADO        VARCHAR2,
                                  K_MSJCONTEGO    VARCHAR2 default null,
                                  K_RESPUESTA     OUT NUMBER,
                                  K_MENSAJE       OUT VARCHAR2);

  PROCEDURE SGASS_BAJA(K_NUMREGISTRO OPERACION.OPE_SRV_RECARGA_CAB.NUMREGISTRO%TYPE,
                       K_RESPUESTA   IN OUT VARCHAR2,
                       K_MENSAJE     IN OUT VARCHAR2);

  PROCEDURE SGASS_VALPROVISION(K_CODSOLOT  OPERACION.SGAT_TRXCONTEGO.TRXN_CODSOLOT%TYPE,
                               K_RESPUESTA IN OUT VARCHAR2,
                               K_MENSAJE   IN OUT VARCHAR2);

  PROCEDURE SGASS_ACTIVARBOUQUET_MASIVO(K_NUMREGISTRO OPERACION.OPE_SRV_RECARGA_CAB.NUMREGISTRO%TYPE,
                                        K_BOUQUET     OPERACION.SGAT_TRXCONTEGO.TRXV_BOUQUET%TYPE,
                                        K_FECINI      VARCHAR2,
                                        K_FECFIN      VARCHAR2,
                                        K_IDENVIO     NUMBER,
                                        K_RESPUESTA   IN OUT VARCHAR2,
                                        K_MENSAJE     IN OUT VARCHAR2);

  PROCEDURE SGASS_DESACTIVARBOUQUET_MASIVO(K_NUMREGISTRO OPERACION.OPE_SRV_RECARGA_CAB.NUMREGISTRO%TYPE,
                                           K_BOUQUET     OPERACION.SGAT_TRXCONTEGO.TRXV_BOUQUET%TYPE,
                                           K_FECINI      VARCHAR2,
                                           K_FECFIN      VARCHAR2,
                                           K_IDENVIO     NUMBER,
                                           K_RESPUESTA   IN OUT VARCHAR2,
                                           K_MENSAJE     IN OUT VARCHAR2);

  PROCEDURE SGASS_DESPAREO_MASIVO(K_NUMREGISTRO OPERACION.OPE_SRV_RECARGA_CAB.NUMREGISTRO%TYPE,
                                  K_IDENVIO     NUMBER,
                                  K_RESPUESTA   IN OUT VARCHAR2,
                                  K_MENSAJE     IN OUT VARCHAR2);

  PROCEDURE SGASS_REENVIO_LT_CONTEGO(K_LOTE_NEW  OPERACION.SGAT_TRXCONTEGO.TRXN_IDLOTE%TYPE,
                                     K_LOTE_ANT  OPERACION.SGAT_TRXCONTEGO.TRXN_IDLOTE%TYPE,
                                     K_RESPUESTA OUT VARCHAR2,
                                     K_MENSAJE   OUT VARCHAR2);

  PROCEDURE SGASS_CONSULTA_ERROR(K_NUMREGISTRO OPERACION.OPE_SRV_RECARGA_CAB.NUMREGISTRO%TYPE,
                                 K_MENSAJE     IN OUT OPERACION.SGAT_TRXCONTEGO.TRXV_MSJ_ERR%TYPE);

  PROCEDURE SGASS_DESACTIVARBOUQUET(k_NUMREGISTRO OPERACION.OPE_SRV_RECARGA_CAB.NUMREGISTRO%TYPE,
                                    k_CODSOLOT    OPERACION.SOLOT.CODSOLOT%TYPE,
                                    K_RESPUESTA   IN OUT VARCHAR2,
                                    k_MENSAJE     IN OUT VARCHAR2);

  PROCEDURE SGASS_SUSPENSION_LTE(K_LOTE      OPERACION.SGAT_TRXCONTEGO.TRXN_IDLOTE%TYPE,
                                 K_RESPUESTA IN OUT VARCHAR2,
                                 k_MENSAJE   IN OUT VARCHAR2);
  PROCEDURE SGASS_RECONEXION_LTE(K_LOTE      OPERACION.SGAT_TRXCONTEGO.TRXN_IDLOTE%TYPE,
                                 K_RESPUESTA IN OUT VARCHAR2,
                                 k_MENSAJE   IN OUT VARCHAR2);
  PROCEDURE SGASS_SUSP_CANC_POSTPAGO(K_LOTE      OPERACION.SGAT_TRXCONTEGO.TRXN_IDLOTE%TYPE,
                                     K_RESPUESTA IN OUT VARCHAR2,
                                     k_MENSAJE   IN OUT VARCHAR2);
  PROCEDURE SGASS_RECONEXION_POSTPAGO(K_LOTE      OPERACION.SGAT_TRXCONTEGO.TRXN_IDLOTE%TYPE,
                                      K_RESPUESTA IN OUT VARCHAR2,
                                      k_MENSAJE   IN OUT VARCHAR2);
  PROCEDURE SGASS_SUSPENSION_PREPAGO(K_LOTE      OPERACION.SGAT_TRXCONTEGO.TRXN_IDLOTE%TYPE,
                                     K_RESPUESTA IN OUT VARCHAR2,
                                     k_MENSAJE   IN OUT VARCHAR2);
  PROCEDURE SGASS_CANCELACION_PREPAGO(K_LOTE      OPERACION.SGAT_TRXCONTEGO.TRXN_IDLOTE%TYPE,
                                      K_RESPUESTA IN OUT VARCHAR2,
                                      k_MENSAJE   IN OUT VARCHAR2);
  PROCEDURE SGASS_RECONEXION_PREPAGO(K_LOTE      OPERACION.SGAT_TRXCONTEGO.TRXN_IDLOTE%TYPE,
                                     K_RESPUESTA IN OUT VARCHAR2,
                                     k_MENSAJE   IN OUT VARCHAR2);
  PROCEDURE SGASS_VERIFCONTEGO(K_RESPUESTA IN OUT VARCHAR2,
                               k_MENSAJE   IN OUT VARCHAR2);
  /****************************************************************
  * Nombre FUN     : SGAFUN_OBT_BOUQUET
  * Proposito      : Esta funcion se encarga de generar y devolver
                     los bouquets PRINCIPAL, ADICIONAL y PROMOCION
                     concatenados y separados por coma.
  * Output         : Bouquets concatenados por coma.
  * Creado por     : Jose Arriola
  * Fec. Creacion  : 01/08/2017
  * Fec. Actualizacion : --
  ****************************************************************/
  FUNCTION SGAFUN_OBT_BOUQUET(k_NUMREGISTRO in OPERACION.OPE_SRV_RECARGA_CAB.NUMREGISTRO%TYPE,
                              K_NUMSLC      in VARCHAR2,
                              K_TIPO        IN VARCHAR2) RETURN VARCHAR2;
  /****************************************************************
  * Nombre FUN     : SGAFUN_VALIDA_PAREO
  * Proposito      : Esta funcion se encarga de validar si se va
                     ejecutar el proceso de pareo.
  * Output         : LN_PAREO - Si es pareo retorna su numserie
  * Creado por     : Jose Arriola
  * Fec. Creacion  : 01/08/2017
  * Fec. Actualizacion : --
  ****************************************************************/
  FUNCTION SGAFUN_VALIDA_PAREO(K_CODSOLOT OPERACION.SOLOT.CODSOLOT%TYPE)
    RETURN NUMBER;
  /****************************************************************
  * Nombre FUN     : SGAFUN_VALIDA_DESPAREO
  * Proposito      : Esta funcion se encarga de validar si se va
                     ejecutar el proceso de despareo.
  * Output         : LN_DESPAREO - Si es despareo retorna su numserie
  * Creado por     : Jose Arriola
  * Fec. Creacion  : 01/08/2017
  * Fec. Actualizacion : --
  ****************************************************************/
  FUNCTION SGAFUN_VALIDA_DESPAREO(K_CODSOLOT OPERACION.SOLOT.CODSOLOT%TYPE)
    RETURN NUMBER;
  /****************************************************************
  * Nombre FUN     : SGAFUN_PARAM_CONTEGO
  * Proposito      : Esta funcion se encarga de buscar y obtener los
                     valores en la tabla de par?metros OPERACION.OPEDD
                     y OPERACION.TIPOPEDD
  * Output         : LS_PARAMC - retorna el valor del parametro
  * Creado por     : Jose Arriola
  * Fec. Creacion  : 01/08/2017
  * Fec. Actualizacion : --
  ****************************************************************/
  FUNCTION SGAFUN_PARAM_CONTEGO(P_TIPO   IN VARCHAR2,
                                P_CAMPO  IN VARCHAR2,
                                P_DESC   IN VARCHAR2,
                                P_TIPVAR IN VARCHAR2) RETURN VARCHAR2;
  /****************************************************************
  * Nombre FUN     : SGAFUN_OBT_NUMSLC
  * Proposito      : Esta funcion se encarga de obtener el numero de
                     proyecto generado a traves del numero de registro
                     desde la tabla OPERACION.OPE_SRV_RECARGA_CAB
  * Output         : V_NUMSLC - Numero de proyecto generado
  * Creado por     : Jose Arriola
  * Fec. Creacion  : 01/08/2017
  * Fec. Actualizacion : --
  ****************************************************************/
  FUNCTION SGAFUN_OBT_NUMSLC(K_NUMREGISTRO OPERACION.OPE_SRV_RECARGA_CAB.NUMREGISTRO%TYPE)
    RETURN VARCHAR2;
  /****************************************************************
  * Nombre FUN     : SGAFUN_VALIDA_SOT
  * Proposito      : Esta funcion la utiliza el procedimiento principal
                     de alta que verifica que la linea no se encuentre
                     registrada en la transaccional con estado 1 o en el
                     historico con estado 3, se encarga de cancelar la SOT
                     y a traves del procedimiento SGASI_REGCONTEGOHIST
                     registrarla en el historico y eliminarla de la transaccional
  * Output         : k_RESPUESTA - Retorna 0 si es correcto o -1/-2 si es
                     incorrecto
  * Creado por     : Jose Arriola
  * Fec. Creacion  : 01/08/2017
  * Fec. Actualizacion : --
  ****************************************************************/
  FUNCTION SGAFUN_VALIDA_SOT(k_CODSOLOT OPERACION.SGAT_TRXCONTEGO.TRXN_CODSOLOT%TYPE)
    RETURN NUMBER;
  /****************************************************************
  * Nombre FUN     : SGAFUN_OBT_MSJ
  * Proposito      : Funcion la cual se encarga de obtener la descripcion
                     de los estados.
  * Output         : Descripcion del estado ingresado.
  * Creado por     : Jose Arriola
  * Fec. Creacion  : 01/08/2017
  * Fec. Actualizacion : --
  ****************************************************************/
  FUNCTION SGAFUN_OBT_MSJ(K_ESTADO OPERACION.SGAT_TRXCONTEGO.TRXC_ESTADO%TYPE)
    RETURN VARCHAR2;

  FUNCTION SGAFUN_UPD_STATUS(K_ESTADO OPERACION.SGAT_TRXCONTEGO.TRXC_ESTADO%TYPE)
    RETURN NUMBER;

    FUNCTION SGAFUN_VALIDA_LOTE(K_LOTE OPERACION.SGAT_TRXCONTEGO.TRXN_IDLOTE%TYPE)
    RETURN NUMBER;
  /****************************************************************
    * Nombre FUN     : SGAFUN_ES_PAREO
    * Proposito      : Funcion la cual se encarga de valida si corresponde PAREO o DESPAREO
    * Output         : PAREO / DESPAREO
    * Creado por     : Lidia Quispe
    * Fec. Creacion  : 14/08/2018
    * Fec. Actualizacion : --
    ****************************************************************/
    FUNCTION  SGAFUN_ES_PAREO(V_NUMSERIE OPERACION.SOLOTPTOEQU.NUMSERIE%TYPE)
    RETURN VARCHAR2;

    /****************************************************************
    * Nombre FUN     : SGASS_DECOS_CONTEGO_CP
    * Proposito      : Proceso que realiza la Baja, Alta o Refresco de Canales para el CP LTE
    * Output         :
    * Creado por     : Lidia Quispe
    * Fec. Creacion  : 14/08/2018
    * Fec. Actualizacion : --
    ****************************************************************/
    PROCEDURE SGASS_DECOS_CONTEGO_CP (V_NUMREGISTRO IN OPERACION.OPE_SRV_RECARGA_CAB.NUMREGISTRO%TYPE,
                                      V_CODSOLOT    IN  OPERACION.SOLOT.CODSOLOT%TYPE,
                                      V_RES_ERROR   OUT VARCHAR2,
                                      V_MSJ_ERROR   OUT VARCHAR2);
                                      
      /****************************************************************
    * Nombre SP      : SGASS_WSCONTEGO_APP
    * Proposito      : Este SP genera los XML para pareo, despareo y
                       activacion segun sea el caso y las envia hacia
                       contego, para las sots del app servicio tecnico.
    * Input          : K_CODSOLOT - Numero de SOT
                       K_ESTADO   - Estado de la transaccion
    * Output         : K_CURSOR
                       K_RESPUESTA
                       K_MENSAJE
    * Creado por     : Wendy Tamayo
    * Fec. Creacion  : 26/02/2020
    * Fec. Actualizacion : --
    ****************************************************************/
    PROCEDURE SGASS_WSCONTEGO_APP(K_CODSOLOT  IN NUMBER,
                                  K_ESTADO    IN VARCHAR2,
                                  K_CURSOR    OUT SYS_REFCURSOR,
                                  K_RESPUESTA OUT VARCHAR2,
                                  K_MENSAJE   OUT VARCHAR2);                                    
                                        
  -- FIN
END PKG_CONTEGO;
/
