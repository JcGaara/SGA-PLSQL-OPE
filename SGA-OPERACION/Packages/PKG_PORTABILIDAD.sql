CREATE OR REPLACE PACKAGE OPERACION.PKG_PORTABILIDAD IS
  /************************************************************************************
    PROPOSITO:
    
    REVISIONES:
      VERSION  FECHA       AUTOR            SOLICITADO POR      DESCRIPCION
      -------  -----       -----            --------------      -----------
      1.0      2014-05-29  JENNY VALENCIA   JOSE VARILLAS     PORTABILIDAD NUMERICA
      2.0      2018-12-03  HITSS                              PORTABILIDAD NUMERICA
  /***********************************************************************************/
  TYPE NUMERO_TYPE IS RECORD(
    NUMERO VARCHAR2(10));

  TYPE NUMEROS_TYPE IS TABLE OF NUMERO_TYPE INDEX BY PLS_INTEGER;
  C_EST_APROB_PORTOUT CONSTANT NUMERIC := 0;
  C_EST_ERROR_PORTOUT CONSTANT NUMERIC := -1;
  C_EST_SOT_BAJA_GEN  CONSTANT NUMERIC := 1;
  C_EST_SOT_ALTA_GEN  CONSTANT NUMERIC := 2;
  C_EST_SOT_CERRADA   CONSTANT NUMERIC := 3;
  /************************************************************************************************************
  * NOMBRE SP            : P_PORTIN_VALID_MATERIAL
  * PROPOSITO            : VALIDA EXISTENCIA DE CODIGO DE MATERIAL
  * INPUT                : AV_CODMAT CODIGO DE MATERIAL
  * OUTPUT               : AN_MSJ    MENSAJE DE VALIDACION
  * CREACION             : 20/07/2018 JOSE VARILLAS
  '********************************************************************************************/
  PROCEDURE SGASS_PORTIN_VALID_MATERIAL(PI_CODMAT IN VARCHAR2,
                                        PO_MSJ    OUT NUMBER);
  /*******************************************************************************************
  * NOMBRE SP            : P_PORTIN_ASOC_LINEA
  * PROPOSITO            : ASOCIA LINEA A SIMCARDS (SERIE Y CODIGO DE MATERIAL)
  * INPUT                : PI_NSOT    NUMERO DE SOT
                           PI_VLINEA  NUMERO TELEFONICO
                           PI_VSERIE  SERIE DE EQUIPO
                           PI_VCODMAT CODIGO DE MATERIAL
  * OUTPUT               : PO_NMSJ    RESULTADO DE VALIDACION
                           PO_VMSJ    MENSAJE DE VALIDACION
  * CREACION             : 20/07/2018 JOSE VARILLAS
  '********************************************************************************************/
  PROCEDURE SGASU_PORTIN_ASOC_LINEA(PI_NSOT    IN NUMBER,
                                    PI_VLINEA  IN VARCHAR2,
                                    PI_VSERIE  IN VARCHAR2,
                                    PI_VCODMAT IN VARCHAR2,
                                    PO_NMSJ    OUT NUMBER,
                                    PO_VMSJ    OUT VARCHAR2);
  /*******************************************************************************************
  * NOMBRE FUN           : F_OBT_EST_SOL_PORTA
  * PROPOSITO            : FUNCION PARA OBTENER LA ESTADO DE LA SOT DE PORTA
  * INPUT                : PI_NUMSEC    NUMERO DE SEC DE LA SOT
  * CREACION             : 20/07/2018 JOSE VARILLAS
  '********************************************************************************************/
  FUNCTION SGAFUN_OBT_EST_SOL_PORTA(PI_NUMSEC IN NUMBER) RETURN VARCHAR2;
  /*******************************************************************************************
  * NOMBRE FUN           : F_OBT_FECH_SOL_PORTA
  * PROPOSITO            : FUNCION PARA OBTENER LA FECHA DE LA SOT DE PORTA
  * INPUT                : PI_NUMSEC    NUMERO DE SEC DE LA SOT
  * CREACION             : 20/07/2018 JOSE VARILLAS
  '********************************************************************************************/
  FUNCTION SGAFUN_OBT_FECH_SOL_PORTA(PI_NUMSEC IN NUMBER) RETURN VARCHAR2;
  /*******************************************************************************************
  * NOMBRE SP            : SGASS_VALID_PORT_FECH
  * PROPOSITO            : DETALLE DE LISTADO DE SOTS PENDIENTES DE PORTABILIDAD
  * OUTPUT               : PO_CURSOR    CURSOR DE SOTS PENDIENTES DE PORTABILIDAD
  * CREACION             : 20/07/2018 JOSE VARILLAS
  '********************************************************************************************/
  PROCEDURE SGASS_VALID_PORT_FECH(PO_CURSOR OUT SYS_REFCURSOR);
  /*******************************************************************************************
  * NOMBRE SP            : SGASS_VALID_PEND_PORTA
  * PROPOSITO            : LISTAR SOTS PENDIENTES DE PORTABILIDAD
  * OUTPUT               : PO_CURSOR    CURSOR DE SOTS PENDIENTES DE PORTABILIDAD
  * CREACION             : 20/07/2018 JOSE VARILLAS
  '********************************************************************************************/
  PROCEDURE SGASS_VALID_PEND_PORTA(PO_CURSOR OUT SYS_REFCURSOR);
  /***********************************************************************
  * NOMBRE SP            : P_PORTIN_CHG_EST_SOT
  * PROPOSITO            : CAMBIO DE ESTADO SOT Y CIERRA TAREA ACTUAL
  * INPUT                : PI_IDTAREAWF  ID TAREA WORKFLOW SOT
                           PI_IDWF       ID WORKFLOW SOT
                           PI_TAREA      NUMERO DE TAREA WORKFLOW
                           PI_TAREADEF   NUMERO DE TAREADEF
  * CREACION             : 03/08/2018 JENY VALENCIA
  '***********************************************************************/
  PROCEDURE SGASU_PORTIN_CHG_EST_SOT(PI_IDTAREAWF IN NUMBER,
                                     PI_IDWF      IN NUMBER,
                                     PI_TAREA     IN NUMBER,
                                     PI_TAREADEF  IN NUMBER);
  /***********************************************************************************
  * NOMBRE SP            : P_VAL_PROC_PORTIN
  * PROPOSITO            : VALIDA ESTADO DE PORTABILIDAD IN
  * INPUT                : PI_NUMSEC             NUMERO DE SOLICITUD DE EVALUACION
                                                CREDITICIA
                           PI_SOT                NUMERO DE SOT
                           PI_NRO_SOL_PORTA      NUMERO DE SOLICITUD DE PORTABILIDAD
                           PI_SOPOC_ESTA_PROCESO
                           PI_ESTADO
  * OUTPUT               : PO_ERR                CODIGO DE ERROR
                           PO_MSJ                MENSAJE DE ERROR
  * CREACION             : 20/07/2018 JOSE VARILLAS
  '**********************************************************************************/
  PROCEDURE SGASS_VAL_PROC_PORTIN(PI_NUMSEC             IN NUMBER,
                                  PI_SOT                IN NUMBER,
                                  PI_NRO_SOL_PORTA      IN NUMBER,
                                  PI_SOPOC_ESTA_PROCESO IN VARCHAR2,
                                  PI_ESTADO             IN VARCHAR2,
                                  PO_ERR                OUT NUMBER,
                                  PO_MSJ                OUT VARCHAR2);
  /************************************************************************************************************
  * NOMBRE SP            : SGASI_PORTOUT_SOT_ALTA
  * PROPOSITO            : GENERA SOT DE ALTA PORTOUT PARA HFC O LTE
  * INPUT                : PI_CUSTOMERID  CODIGO DE USUARIO BSCS
                           PI_CODID       CODIGO DE CONTRATO BSCS
                           PI_TECN        TECNOLOGIA HFC O LTE
  * OUTPUT               : PO_SOT_ALTA    CURSOR CON LOS SIGUIENTE CAMPOS:
                                          * SOT_ALTA    NUMERO DE SOT GENERADA
                           PO_ERR         CODIGO DE ERROR
                           PO_MSJ          MENSAJE DE ERROR
  * CREACION             : 28/08/2018 JOSE VARILLAS
  '***********************************************************************************************************/
  PROCEDURE SGASI_PORTOUT_SOT_ALTA(PI_CUSTOMERID IN NUMBER,
                                   PI_CODID_OLD  IN NUMBER,
                                   PI_TECN       IN VARCHAR2,
                                   PO_ERR        OUT NUMBER,
                                   PO_MSJ        OUT VARCHAR2);
  /* **********************************************************************************************************
  * NOMBRE SP            : SGASI_PORTOUT_SOT_BAJA 
  * PROPOSITO            : GENERAR SOT BAJA
  * INPUT                : PI_CO_ID       CODIGO DE CONTRATO
                           PI_TECN        TIPO DE TECNOLOGIA (HFC,LTE)
                           PI_NUMERO      NUMERO PORTOUT
  * OUTPUT               : PO_RESULTADO   RESULTADO
                           PO_MENSAJE     MENSAJE DE VALIDACION             
  * CREACION             : 03/08/2018     JENY VALENCIA
    ACTUALIZACION        : 17/09/2018     JENY VALENCIA
  '**********************************************************************************************************/
  PROCEDURE SGASI_PORTOUT_SOT_BAJA(PI_CO_ID     OPERACION.SOLOT.COD_ID%TYPE,
                                   PI_TECN      VARCHAR2,
                                   PI_NUMERO    NUMBER,
                                   PO_RESULTADO OUT NUMBER,
                                   PO_MENSAJE   OUT VARCHAR2);
  /***********************************************************************************************************
  * NOMBRE SP            : SGASI_PORTOUT_SOT
  * PROPOSITO            : INSERTA SOT
  * INPUT                : PI_CODCLI   CODIGO DE CLIENTE
                           PI_TIPTRA   TIPO DE TRABAJO
                           PI_TIPSRV   TIPO DE SERVICIO
                           PI_MOTIVO   CODIGO DE MOTIVO
                           PI_AREASOL  AREA
  * OUTPUT               : PO_CODSOLOT CODIGO DE SOT
  * CREACION             : 03/08/2018 JENY VALENCIA
  '************************************************************************************************************/
  PROCEDURE SGASI_PORTOUT_SOT(PI_CODCLI      IN OPERACION.SOLOT.CODCLI%TYPE,
                              PI_TIPTRA      IN OPERACION.SOLOT.TIPTRA%TYPE,
                              PI_TIPSRV      IN OPERACION.SOLOT.TIPSRV%TYPE,
                              PI_MOTIVO      IN OPERACION.SOLOT.CODMOTOT%TYPE,
                              PI_AREASOL     IN OPERACION.SOLOT.AREASOL%TYPE,
                              PI_COD_ID      IN OPERACION.SOLOT.COD_ID%TYPE,
                              PI_CUSTOMER_ID IN OPERACION.SOLOT.CUSTOMER_ID%TYPE,
                              PO_CODSOLOT    OUT NUMBER);
  /*************************************************************************
  * Nombre SP            : SGASI_PORTOUT_SOLOTPTO
  * Proposito            : Inserta SOLOTPTO
  * Input                : PI_CODSOLOT  Codigo de SOT
                           PI_COD_ID    Codigo de Contrato
  * Output               : 
  * Creacion             : 03/08/2018 Jeny Valencia
  '*************************************************************************/
  PROCEDURE SGASI_PORTOUT_SOLOTPTO(PI_CODSOLOT       IN SOLOT.CODSOLOT%TYPE,
                                   PI_CODSOLOT_ORI   IN SOLOT.CODSOLOT%TYPE) ;
  /************************************************************************************************************
  * NOMBRE SP            : SGASI_PORTOUT_CARGA
  * PROPOSITO            : REGISTRA Y EVALUA NUMEROS PORT OUT RECIBIDOS MEDIANTE
                           PI_TRAMA_LINEA.
  * INPUT                : PI_TRAMA_LINEA NUMEROS PORT OUT CONCATENADOS MEDIANTE "|".
  * OUTPUT               : PO_TRAMA_EVAL  CURSOR CON LOS SIGUIENTE CAMPOS:
                                          * COD_ID      CODIGO DE CONTRATO
                                          * NUMERO      NUMERO PORTOUT
                                          * TECN        TECNOLOGIA
                                          * ESTADO      RESULTADO EVALUACION.
                                          * OBSERVACION DETALLE DE EVALUCION.
  * CREACION             : 31/07/2018 JENY VALENCIA
  * ACTUALIZACION        : 03/08/2018 JOSE VARILLAS
                         : 18/09/2018 JENY VALENCIA
  '***********************************************************************************************************/
  PROCEDURE SGASI_PORTOUT_CARGA(PI_TRAMA_LINEA IN VARCHAR2,
                                PO_TRAMA_EVAL  OUT SYS_REFCURSOR);
  /********************************************************************************
  * Nombre P            : SGAFUN_CARGAR_ARRAY
  * Proposito            : Inserta los numeros concatenados en una tabla temporal.
  * Input                : PI_STRING Numeros Port Out concatenados mediante "|".
  * Output               : NUMEROS_TYPE  Tabla con los siguientes campos:
                                          * Numero      Numero PortOut
  * Creacion             : 31/07/2018 Jeny Valencia
  '********************************************************************************/
  FUNCTION SGAFUN_CARGAR_ARRAY(PI_STRING VARCHAR2) RETURN NUMEROS_TYPE;
  /*********************************************************************************
  * Nombre SP            : SGASS_VALIDA_NUM_PORT
  * Proposito            : Valida lineas Port Out
  * Input                : PI_NUM          Numero Port Out
  * Output               : PO_SOT          Numero de SOT
                           PO_CODID        Codigo de Contrato
                           PO_TECNOLOGIA   Tipo de Tecnologia ( HFC, LTE )
                           PO_CODERR       Codigo de Error
                           PO_MSJERR       Mensaje de Error
  * Creacion             : 31/07/2018 Jeny Valencia
  * Actualizacion        : 03/08/2018 Jose Varillas
  '*********************************************************************************/
  PROCEDURE SGASS_VALIDA_NUM_PORT(PI_NUM         IN VARCHAR2,
                                  PO_SOT         OUT NUMBER,
                                  PO_CODID       OUT NUMBER,
                                  PO_TECNOLOGIA  OUT VARCHAR2,
                                  PO_CUSTOMER_ID OUT NUMBER,
                                  PO_CODERR      OUT NUMBER,
                                  PO_MSJERR      OUT VARCHAR2);
  /*************************************************************************************************************
  * NOMBRE SP            : SGASU_PORTOUT_CIERRE
  * PROPOSITO            : CIERRE DE SOT DE BAJA PENDIENTES SEGUN SALES.INT_PORTABILIDAD
  * INPUT                : 
  * OUTPUT               : PO_CURSOR    CURSOR CON LOS SIGUIENTES CAMPOS:
                                       SOT_BAJA    : NUMERO DE SOT DE BAJA
                                       COD_ID      : CODIGO DE CONTRATO
                                       NUMERO      : NUMERO DE LINEA
                                       ESTADO      : ESTADO DE SOLICITUD PORT OUT
                                       OBSERVACION : OBSERVACION DE PORT OUT
                           PO_CODERROR  CODIGO DE ERROR
                           PO_MSJERROR  MENSAJE DE ERROR
  * CREACION             : 03/08/2018 JOSE VARILLAS
  '************************************************************************************************************/
  PROCEDURE SGASU_PORTOUT_CIERRE_SOT(PO_CODERROR OUT NUMBER,
                                     PO_MSJERROR OUT VARCHAR2);
  /************************************************************************************************************
  * NOMBRE SP            : SGASU_PORTOUT_CIERRE_TAREA
  * PROPOSITO            : CIERRE DE SOT DE BAJA PENDIENTES SEGUN SALES.INT_PORTABILIDAD
  * INPUT                : 
  * OUTPUT               : PO_CURSOR    CURSOR CON LOS SIGUIENTES CAMPOS:
                                       SOT_BAJA    : NUMERO DE SOT DE BAJA
                                       COD_ID      : CODIGO DE CONTRATO
                                       NUMERO      : NUMERO DE LINEA
                                       ESTADO      : ESTADO DE SOLICITUD PORT OUT
                                       OBSERVACION : OBSERVACION DE PORT OUT
                           PO_CODERROR  CODIGO DE ERROR
                           PO_MSJERROR  MENSAJE DE ERROR
  * CREACION             : 03/08/2018 JOSE VARILLAS
  '************************************************************************************************************/
  PROCEDURE SGASU_PORTOUT_CIERRE_TAREA(PI_CODSOLOT IN OPERACION.SOLOT.CODSOLOT%TYPE,
                                       PO_CODERROR OUT NUMBER,
                                       PO_MSJERROR OUT VARCHAR2);
  /*************************************************************************************************************
  * NOMBRE SP            : SGASU_WF_ACT_DES_JANUS
  * PROPOSITO            : DESACTIVA LINEA JANUS
  * INPUT                : PI_IDTAREAWF  ID TAREA WORKFLOW SOT
                           PI_IDWF       ID WORKFLOW SOT    
                           PI_TAREA      NUMERO DE TAREA WORKFLOW
                           PI_TAREADEF   NUMERO DE TAREADEF 
  * OUTPUT               : 
  * CREACION             : 03/08/2018 JOSE VARILLAS
  '************************************************************************************************************/
  PROCEDURE SGASU_WF_ACT_DES_JANUS(PI_IDTAREAWF IN NUMBER,
                                   PI_IDWF      IN NUMBER,
                                   PI_TAREA     IN NUMBER,
                                   PI_TAREADEF  IN NUMBER);
  /************************************************************************************************************
  * NOMBRE SP            : SGASU_PORTOUT_DESH_NUM
  * PROPOSITO            : DESHABILITA NUMERO POR OUT ACTUALIZANDO ESTADO EN NUMTEL
  * INPUT                : PI_CODSOLOT  NUMERO DE SOT
  * OUTPUT               : PO_RESULTADO RESULTADO
                           PO_MENSAJE   MENSAJE     
  * CREACION             : 08/08/2018 JENY VALENCIA
  '***********************************************************************************************************/
  PROCEDURE SGASU_PORTOUT_DESH_NUM(PI_CODSOLOT  IN NUMBER,
                                   PO_RESULTADO OUT NUMBER,
                                   PO_MENSAJE   OUT VARCHAR2);
  /***********************************************************************************************************
  * NOMBRE SP            : SGASU_WF_ACT_DES_IL
  * PROPOSITO            : INSERTA SOLICITUD DE DESACTIVACION IL.
  * INPUT                : PI_IDTAREAWF  ID TAREA WORKFLOW SOT
                           PI_IDWF       ID WORKFLOW SOT    
                           PI_TAREA      NUMERO DE TAREA WORKFLOW
                           PI_TAREADEF   NUMERO DE TAREADEF 
  * CREACION             : 02/08/2018 JOSE VARILLAS
  '*********************************************************************************************************/
  PROCEDURE SGASU_WF_ACT_DES_IL(PI_IDTAREAWF IN NUMBER,
                                PI_IDWF      IN NUMBER,
                                PI_TAREA     IN NUMBER,
                                PI_TAREADEF  IN NUMBER);
  /********************************************************************************************************
  * NOMBRE SP            : SGASU_WF_VALIDA_DESINS
  * PROPOSITO            : VALIDA DESISTALACION DE LINEAS PORT OUT
  * INPUT                : PI_IDTAREAWF  ID TAREA WORKFLOW SOT
                           PI_IDWF       ID WORKFLOW SOT    
                           PI_TAREA      NUMERO DE TAREA WORKFLOW
                           PI_TAREADEF   NUMERO DE TAREADEF 
  * OUTPUT               : 
  * CREACION             : 03/08/2018 JOSE VARILLAS
  '*********************************************************************************************************/
  PROCEDURE SGASU_WF_VALIDA_DESINS(PI_IDTAREAWF IN NUMBER,
                                   PI_IDWF      IN NUMBER,
                                   PI_TAREA     IN NUMBER,
                                   PI_TAREADEF  IN NUMBER);
  /***********************************************************************************************************
  * NOMBRE SP            : SGASU_PORTOUT_DES_CONT
  * PROPOSITO            : DESACTIVAR CONTRATO REGISTRADO EN SISACT
  * INPUT                : PI_CODSOLOT  NUMERO DE SOT
  * OUTPUT               : PO_RESULTADO RESULTADO
                           PO_MENSAJE   MENSAJE      
  * CREACION             : 08/08/2018 JENY VALENCIA
  '***********************************************************************************************************/
  PROCEDURE SGASU_PORTOUT_DES_CONT(PI_CODSOLOT  IN NUMBER,
                                   PO_RESULTADO OUT NUMBER,
                                   PO_MENSAJE   OUT NUMBER);
  /************************************************************************************************************
  * NOMBRE SP            : SGASS_PORTOUT_PARM_COID
  * PROPOSITO            : LISTAR PARAMETROS PARA LA GENERACION DE CONTRATO SEGUN EQUIVALENCIA BSCS
  * OUTPUT               : PO_TRAMA_EVAL   CURSOR CON LOS DATOS EQUIVALENTES.
  * CREACION             : 08/08/2018 JENY VALENCIA
  '************************************************************************************************************/
  PROCEDURE SGASS_PORTOUT_PARM_COID(PO_TRAMA_EVAL OUT SYS_REFCURSOR
                                   ,PO_RESULTADO  OUT NUMBER
                                   ,PO_MENSAJE    OUT VARCHAR2);
  /************************************************************************************************************
  * NOMBRE SP            : SGASU_ACT_EQU_LTE
  * PROPOSITO            : LISTAR PARAMETROS PARA LA GENERACION DE CONTRATO
  * OUTPUT               : CURSOR QUE DEVUELVE PARAMETROS POR CARGA                  
  * CREACION             : 08/08/2018 JENY VALENCIA
  '**********************************************************************************************************/
  PROCEDURE SGASU_ACT_EQU_LTE(PI_IDTAREAWF IN NUMBER,
                              PI_IDWF      IN NUMBER,
                              PI_TAREA     IN NUMBER,
                              PI_TAREADEF  IN NUMBER);
  /********************************************************************************************************
  * NOMBRE SP            : SGASS_CONSULTA_SINGLES
  * PROPOSITO            : LISTAR SOT DE ALTA           
  * OUTPUT               : PO_TRAMA_EVAL   CURSOR CON LOS SIGUIENTE CAMPOS:
                                           * SOT_ALTA SOT GENERADA
                                           * PLAN,        NOMBRE DE PLAN
                                           * TIPSRV       TIPO DE SERVICIO
                                           * NUMERO       NUMERO DE LINEA
                                           * ESTADO       ESTADO
                                           * OBSERVACION  OBSERVACION
  * CREACION             : 18/09/2018 JOSE VARILLAS
  '********************************************************************************************************/
  PROCEDURE SGASS_CONSULTA_SINGLES(PO_TRAMA_EVAL OUT SYS_REFCURSOR);
  /**********************************************************************************************************
  * NOMBRE FUNCION       : SGAFUN_CAMPO_ARRAY
  * PROPOSITO            : DEVUELVE CAMPO ESPECIFICO SEGUN TRAMA INGRESADA.
  * INPUT                : PI_STRING   TRAMA.
                           PI_TRAMA_ID ID DE TRAMA.
                           PI_COLUMN   ID DE COLUMNA.
  * OUTPUT               :                            
  * CREACION             : 31/07/2018 JENY VALENCIA
  '***********************************************************************************************************/
  FUNCTION SGAFUN_CAMPO_ARRAY(PI_STRING   VARCHAR2,
                              PI_TRAMA_ID NUMBER,
                              PI_COLUMN   VARCHAR2) RETURN VARCHAR2;
  /************************************************************************************************************
  * NOMBRE P             : SGASU_PORTOUT_INTPORT
  * PROPOSITO            : ACTUALIZA SOT DE ALTA EN INT_PORTABILIDAD_DET
  * INPUT                : PI_SOT_ORI   : SOT ORIGEN
                           PI_SOT_ALTA  : SOT ALTA
  * OUTPUT               : 
  * CREACION             : 31/07/2018 JENY VALENCIA
  '************************************************************************************************************/
  PROCEDURE SGASU_PORTOUT_INTPORT(PI_SOT_ORI NUMBER, PI_SOT_ALTA NUMBER);
  /************************************************************************************************************
  * NOMBRE SP            : SGAFUN_PORTOUT_ES_ALTA
  * PROPOSITO            : VALIDA SOT DE ALTA
  * INPUT                : PI_CODSOLOT         NUMERO DE SOT
  * OUTPUT               : 
  * CREACION             : 13/08/2018 JENY VALENCIA
  '**********************************************************************************************************/
  FUNCTION SGAFUN_PORTOUT_ES_ALTA(PI_CODSOLOT IN SOLOT.CODSOLOT%TYPE)
    RETURN NUMBER;
  /******************.****************************************************************************************
  * NOMBRE SP            : SGAFUN_PORTOUT_ES_VTAALT
  * PROPOSITO            : VALIDA VENTA PORT OUT ALTA
  * INPUT                : PI_NUMSLC        
  * OUTPUT               : 
  * CREACION             : 13/08/2018 JENY VALENCIA
  '**********************************************************************************************************/
  FUNCTION SGAFUN_PORTOUT_ES_VTAALT(PI_NUMSLC IN VARCHAR2) RETURN BOOLEAN;
  /**********************************************************************************************************
  * NOMBRE SP            : ES_PORTABILIDAD_SOT
  * PROPOSITO            : VALIDA SOT PORTABILIDAD
  * INPUT                : P_CODSOLOT         NUMERO DE SOT
  * OUTPUT               : A_NUMERO_PORTABLE  Numero Portable  
  * CREACION             : 13/08/2018 JENY VALENCIA
  '**********************************************************************************************************/
  PROCEDURE ES_PORTABILIDAD_SOT(P_CODSOLOT        SOLOT.CODSOLOT%TYPE,
                                A_NUMERO_PORTABLE OUT NUMBER);
  /**********************************************************************************************************
  * NOMBRE SP            : SGASU_PORTOUT_SET_CONTR
  * PROPOSITO            : ACTUALIZA CONTRATO GENERADO EN SOT ORIGEN
  * INPUT                : PI_PROCESO_ID      ID PROCESO                        
  * OUTPUT               : 
  * CREACION             : 16/08/2018 JENY VALENCIA
  '********************************************************************************************************/
 PROCEDURE SGASU_PORTOUT_SET_CONTR(PO_RESULTADO OUT NUMERIC,
                                    PO_MENSAJE   OUT VARCHAR2);
  /*********************************************************************************************************
  * NOMBRE SP            : SGASS_SOT_ALTA_MASIVA
  * PROPOSITO            : 
  * OUTPUT               : PO_RESULTADO  Resultado
                           PO_MENSAJE    Mensaje de respuesta
  * CREACION             : 18/09/2018 JOSE VARILLAS
  '********************************************************************************************************/
  PROCEDURE SGASS_SOT_ALTA_MASIVA(PO_RESULTADO OUT NUMBER,
                                  PO_MENSAJE   OUT VARCHAR2);
  /********************************************************************************************************
  * Nombre SP            : SGASU_WF_ACT_DES_IC
  * Proposito            : Desactiva Numero IW
  * Input                : PI_NUMERO    Numero de Linea
                           PI_COD_ID    Codigo de Contrato
                           PI_CODSOLOT  Numero de SOT
  * Output               : PO_COD_RPT   Codigo de Validacion
                           PO_RPT       Mensaje de Validacion
  * Creacion             : 03/08/2018 Jose Varillas
  '******************************************************************************************************/      
  PROCEDURE SGASU_WF_ACT_DES_IC(PI_IDTAREAWF IN NUMBER,
                                PI_IDWF      IN NUMBER,
                                PI_TAREA     IN NUMBER,
                                PI_TAREADEF  IN NUMBER);
                                 
  /**********************************************************************************************************
  * NOMBRE SP            : SGASU_ACT_EQU_HFC
  * PROPOSITO            : ACTUALIZA EQUIPOS HFC
  * OUTPUT               : CURSOR QUE DEVUELVE PARAMETROS POR CARGA                  
  * CREACION             : 08/08/2018 JENY VALENCIA
  '*********************************************************************************************************/
  PROCEDURE SGASU_ACT_EQU_HFC(PI_IDTAREAWF IN NUMBER,
                              PI_IDWF      IN NUMBER,
                              PI_TAREA     IN NUMBER,
                              PI_TAREADEF  IN NUMBER);
   /**********************************************************************************************************
  * NOMBRE SP            : SGASS_PORTIN_VALID_NUMSEC
  * PROPOSITO            : VALIDA REGISTRO DE NUMSEC EN SOT
  * OUTPUT               :         
  * CREACION             : 08/08/2018 JENY VALENCIA
  '*********************************************************************************************************/                                   
  PROCEDURE SGASS_PORTIN_VALID_NUMSEC(PI_NSOT    IN NUMBER,
                                    PO_NUMSEC OUT NUMBER,
                                    PO_NMSJ    OUT NUMBER,
                                    PO_VMSJ    OUT VARCHAR2);  
 /**********************************************************************************************************
  * NOMBRE SP            : SGASU_PORTOUT_SERV_BSCS
  * PROPOSITO            : ASIGNA CODIGOS DE SERVICIO BSCS
  * OUTPUT               :               
  * CREACION             : 08/08/2018 JENY VALENCIA
  '*********************************************************************************************************/
  PROCEDURE SGASU_PORTOUT_SERV_BSCS(PI_PROCESO_ID  NUMBER,
                                   PI_CO_ID        NUMBER,
                                   PO_RESULTADO    OUT NUMBER,
                                   PO_MENSAJE      OUT VARCHAR2);
    
  /**********************************************************************************************************
  * NOMBRE SP            : SGASU_PORTOUT_DECO_BSCS
  * PROPOSITO            : ASIGNA SERVICIO BSCS DECO
  * OUTPUT               :         
  * CREACION             : 15/10/2018 JENY VALENCIA
  '*********************************************************************************************************/  
  PROCEDURE SGASU_PORTOUT_DECO_BSCS(PI_PROCESO_ID  OPERACION.SOLOT.COD_ID%TYPE,
                                   PI_CO_ID        NUMBER,
                                   PO_RESULTADO    OUT NUMBER,
                                   PO_MENSAJE      OUT VARCHAR2);   
  /**********************************************************************************************************
  * NOMBRE SP            : SGASU_PORTOUT_BSCS_ALT
  * PROPOSITO            : ASIGNA SERVICIO BSCS ALTERNATIVO
  * OUTPUT               :         
  * CREACION             : 15/10/2018 JENY VALENCIA
  '*********************************************************************************************************/                                                  
  PROCEDURE SGASU_PORTOUT_BSCS_ALT(PI_CODSRV       IN  VARCHAR2,
                                   PI_DSCSRV       IN  VARCHAR2,
                                   PI_TIPO         IN  VARCHAR2,
                                   PO_SNCODE       OUT NUMBER,
                                   PO_SPCODE       OUT NUMBER,
                                   PO_TMCODE       OUT NUMBER,
                                   PO_RESULTADO    OUT NUMBER,
                                   PO_MENSAJE      OUT VARCHAR2) ;        
  /**********************************************************************************************************
  * NOMBRE SP            : SGASI_GENERA_LOG
  * PROPOSITO            : GENERA LOG
  * OUTPUT               :         
  * CREACION             : 15/10/2018 JENY VALENCIA
  '*********************************************************************************************************/   
  PROCEDURE SGASI_GENERA_LOG(PI_PARAMETROS   IN VARCHAR2,
                      PI_SUBPROCESO  IN VARCHAR2,
                      PI_MSGCODE     IN NUMBER,
                      PI_MENSAJE     IN VARCHAR2);       
                      
  --2.0 Ini
  PROCEDURE SGASS_VAL_CONTRATO_FIJA(PI_CODSOLOT  IN operacion.solot.codsolot%TYPE, 
                                    PO_RESULTADO OUT NUMBER,
                                    PO_MENSAJE   OUT VARCHAR2);     
  --2.0 Fin                                 
END;
/