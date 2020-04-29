CREATE OR REPLACE PACKAGE OPERACION.PKG_SICES_FAILURE IS

  TYPE SYS_REFCURSOR IS REF CURSOR;

  PROCEDURE SICESS_JANUS(PI_V_SUCURSAL     IN VARCHAR2,
                         PI_GEPACODE       IN USRSICES.SICET_GENERICPARAMETER.C_GEPACODE%TYPE,
                         PI_GEPAVALUE      IN USRSICES.SICET_GENERICPARAMETER.I_GEPAVALUE%TYPE,
                         PO_CODE_RESULT    OUT INTEGER,
                         PO_MESSAGE_RESULT OUT VARCHAR2,
                         PO_CURSOR         OUT SYS_REFCURSOR);
						 
  PROCEDURE SICESS_DETALLE_SERVICIO_SGA(PI_COD_SUCURSAL    IN VARCHAR2,
                                      PI_CUSTOMERID      IN VARCHAR2,
                                      PO_ESTADO_SERVICIO OUT VARCHAR2,
                                      PO_MOTIVO_SERVICIO OUT VARCHAR2,
                                      PO_CODERROR        OUT NUMBER,
                                      PO_DESCERROR       OUT VARCHAR2);

  /****************************************************************
  '* Nombre SP           :  SICESS_VALIDATESERVICE
  '* Proposito           :  EL SIGUIENTE SP VALIDA EL SERVICIO DE UN CLIENTE MEDIANTE REGLAS
  '* Inputs              :  PI_CUSTOMERID - Codigo del cliente
                            PI_CODID - Codigo del contrato
                            PI_CODSOLOT - Codigo de SOT  de trabajo
                            PI_TELEFONO - Numero de telefono
                            PI_CICLOOAC - Ciclo de facturacion OAC
                            PI_RULERS - Reglas a evaluar
  '* Output              :  PO_CODE_RESULT - Codigo de Resultado:
                            PO_MESSAGE_RESULT - Mensaje de Resultado.
                            PO_CURSOR_RULERS - Resultado de validacion de reglas
                              RULER - Identificador de regla
                              1  -> Planes telefonia BSCS vs Jannus
                              2  -> Planes internet/TV BSCS vs Incognito
                              3  -> Ciclo facturacion BSCS vs OAC
                              4  -> Nro telefono BSCS vs Incognito
                              5  -> MAC telefonia SGA vs Incognito
                              6  -> MAC internet SGA vs Incognito
                              7  -> NumeroSerie TV SGA vs Incognito
                              8  -> Validar NCOS3
                              RESULT
                              0  -> DESALINEADO
                              1  -> ALINEADO
                              2  -> SERVICIO NO ENCONTRADO
                              -1 -> ERROR DE ORACLE
  '* Creado por          :  Hitss
  '* Fec Creacion        :  28/01/2019
  '* Fec Actualizacion   :  28/01/2019
  '****************************************************************/
  PROCEDURE SICESS_VALIDATESERVICE(PI_CUSTOMERID     IN VARCHAR2,
                                   PI_COID           IN VARCHAR2,
                                   PI_CODSOLOT       IN OPERACION.SOLOT.CODSOLOT%TYPE,
                                   PI_TELEFONO       IN VARCHAR2,
                                   PI_CICLOOAC       IN VARCHAR2,
                                   PI_RULERS         IN VARCHAR2,
                                   PO_CODE_RESULT    OUT INTEGER,
                                   PO_MESSAGE_RESULT OUT VARCHAR2,
                                   PO_CURSOR_RULERS  OUT SYS_REFCURSOR);

  /****************************************************************
  '* Nombre SP           :  SICESS_SERVICIOSGA
  '* Proposito           :  EL SIGUIENTE SP CONSULTA EL SERVICIO DE UN CLIENTE EN SGA
  '* Inputs              :  PI_CODSOLOT - Codigo de la orden de trabajo
                            PI_INTERFASE - Interfaz del equipo (INT, TLF, CTV)
  '* Output              :  PO_CANTIDAD - Cantidad de servicios
                            PO_CODIGO_SALIDA - Codigo para validar el resultado de salida
                            PO_MENSAJE_SALIDA - Mensaje correspondiente al codigo de salida
                            PO_CURSOR_EQUIPO - Contiene el resultado de la consulta
  '* Creado por          :  Hitss
  '* Fec Creacion        :  30/01/2019
  '* Fec Actualizacion   :  30/01/2019
  '****************************************************************/
  PROCEDURE SICESS_SERVICIOSGA(PI_CODSOLOT       IN OPERACION.SOLOT.CODSOLOT%TYPE,
                               PI_INTERFASE      IN VARCHAR2,
                               PO_CANTIDAD       OUT INTEGER,
                               PO_CODE_RESULT    OUT INTEGER,
                               PO_MESSAGE_RESULT OUT VARCHAR2,
                               PO_CURSORSGA      OUT SYS_REFCURSOR);

  /* *************************************************************
  Nombre SP         : SICESS_SUBSIDIARYIFI
  Proposito         : Obtener la direccion de un servicio IFI
  Input             : PI_CUSTOMER_ID - Indica el codigo de cliente
  Output            : PO_CODIGO_SALIDA - Codigo para validar el resultado de salida
                      PO_MENSAJE_SALIDA - Mensaje correspondiente al codigo de salida
                      PO_CURSOR - Contiene el resultado de la consulta
  Creado por        : Hitss
  Fec Creacion      : 08-03-2019
  Fec Actualizacion : 08-03-2019
  ************************************************************* */
  PROCEDURE SICESS_SUBSIDIARYIFI(PI_CUSTOMER_ID    IN VARCHAR2,
                                 PO_CODIGO_SALIDA  OUT INTEGER,
                                 PO_MENSAJE_SALIDA OUT VARCHAR2,
                                 PO_CURSOR         OUT SYS_REFCURSOR);
                                                            
  /****************************************************************
  '* Nombre SP           :  SICESS_ACTIVARBOUQUET
  '* Proposito           :  EL SIGUIENTE SP REALIZA LA ACTIVACION DE BOUQUETS PARA UNA TARJETA
  '* Inputs              :  PI_CODSOLOT - Codigo de la orden de trabajo
                            PI_NUMSERIE_TARJETA - Numero de serie de la tarjeta del deco
  '* Output              :  PO_BOUQUET - Bouquets activados
                            PO_RESPUESTA - Respuesta de salida
                            PO_MENSAJE - Mensaje de salida
  '* Creado por          :  Hitss
  '* Fec Creacion        :  08/07/2019
  '* Fec Actualizacion   :  23/08/2019
  '****************************************************************/
  PROCEDURE SICESS_ACTIVARBOUQUET(PI_CODSOLOT         IN OPERACION.SOLOT.CODSOLOT%TYPE,
                                  PI_NUMSERIE_TARJETA IN OPERACION.SOLOTPTOEQU.NUMSERIE%TYPE,
                                  PO_BOUQUET          OUT OPERACION.SGAT_TRXCONTEGO.TRXV_BOUQUET%TYPE,
                                  PO_RESPUESTA        OUT VARCHAR2,
                                  PO_MENSAJE          OUT VARCHAR2);

  /****************************************************************
  '* Nombre SP           :  SICESS_PAREODECO
  '* Proposito           :  EL SIGUIENTE SP GENERA INFORMACION PARA EL PROCESO DEL PAREO
  '* Inputs              :  PI_CODSOLOT - Numero de orden de trabajo
                            PI_NRO_UA_DECO - Numero UA del decodificador
                            PI_NRO_SERIE_TARJETA - Numero de serie de la tarjeta del deco
  '* Output              :  PO_RESPUESTA - Respuesta de salida
                            PO_MENSAJE - Mensaje de salida
  '* Creado por          :  Hitss
  '* Fec Creacion        :  25/10/2019
  '* Fec Actualizacion   :  25/10/2019
  ****************************************************************/
  PROCEDURE SICESS_PAREODECO(PI_CODSOLOT          OPERACION.SOLOT.CODSOLOT%TYPE,
                             PI_NRO_UA_DECO       OPERACION.TABEQUIPO_MATERIAL.IMEI_ESN_UA%TYPE,
                             PI_NRO_SERIE_TARJETA OPERACION.TARJETA_DECO_ASOC.NRO_SERIE_TARJETA%TYPE,
                             PO_RESPUESTA         IN OUT VARCHAR2,
                             PO_MENSAJE           IN OUT VARCHAR2);

  /****************************************************************
  '* Nombre SP           :  SICESS_SERVICESGA
  '* Proposito           :  EL SIGUIENTE SP CONSULTA EL SERVICIO DE UN CLIENTE EN SGA
  '* Inputs              :  PI_NUMSLC - Código de proyecto
                            PI_CODCLI - Codigo de cliente
  '* Output              :  PO_CODIGO_SALIDA - Codigo para validar el resultado de salida
                            PO_MENSAJE_SALIDA - Mensaje correspondiente al codigo de salida
                            PO_CURSOR - Contiene el resultado de la consulta
  '* Creado por          :  Hitss
  '* Fec Creacion        :  25/02/2020
  '* Fec Actualizacion   :  25/02/2020
  '****************************************************************/
  PROCEDURE SICESS_SERVICESGA(PI_NUMSLC         IN SALES.VTATABSLCFAC.NUMSLC%TYPE,
                              PI_CODCLI         IN MARKETING.VTATABCLI.CODCLI%TYPE,
                              PO_CODE_RESULT    OUT INTEGER,
                              PO_MESSAGE_RESULT OUT VARCHAR2,
                              PO_CURSOR         OUT SYS_REFCURSOR);

  /* *************************************************************
  Nombre SP         : SICESS_ACCOUNT_SGA
  Proposito         : Obtener el estado de cuenta de un cliente/sucursal en SGA
  Input             : PI_CODCLI - Codigo de cliente
                      PI_NUMSLC - Codigo de proyecto
  Output            : PO_CODIGO_SALIDA - Codigo para validar el resultado de salida
                      PO_MENSAJE_SALIDA - Mensaje correspondiente al codigo de salida
                      PO_CURSOR_CUENTA - Contiene el resultado de la consulta
  Creado por        : Hitss
  Fec Creacion      : 02-03-2020
  Fec Actualizacion : 02-03-2020
  ************************************************************* */
  PROCEDURE SICESS_ACCOUNT_SGA(PI_CODCLI         IN MARKETING.VTATABCLI.CODCLI%TYPE,
                               PI_NUMSLC         IN OPERACION.INSSRV.NUMSLC%TYPE,
                               PO_CODIGO_SALIDA  OUT INTEGER,
                               PO_MENSAJE_SALIDA OUT VARCHAR2,
                               PO_CURSOR_CUENTA  OUT SYS_REFCURSOR);

  /* *************************************************************
  Nombre SP         : SICESS_ACCOUNT_STATUS
  Proposito         : Obtener el estado de cuenta de un cliente/sucursal en SGA
  Input             : PI_CODCLI - Codigo de cliente
                      PI_NUMSLC - Codigo de proyecto
  Output            : PO_CODIGO_SALIDA - Codigo para validar el resultado de salida
                      PO_MENSAJE_SALIDA - Mensaje correspondiente al codigo de salida
                      PO_DEUDA_VENCIDA - Monto deuda vencida
                      PO_DEUDA_NO_VENCIDA - Monto deuda no vencida
                      PO_CURSOR_CUENTA - Contiene el resultado de la consulta
  Creado por        : Hitss
  Fec Creacion      : 02-03-2020
  Fec Actualizacion : 02-03-2020
  ************************************************************* */
  PROCEDURE SICESS_ACCOUNT_STATUS(PI_CODCLI           IN MARKETING.VTATABCLI.CODCLI%TYPE,
                                  PI_NUMSLC           IN OPERACION.INSSRV.NUMSLC%TYPE,
                                  PO_CODIGO_SALIDA    OUT INTEGER,
                                  PO_MENSAJE_SALIDA   OUT VARCHAR2,
                                  PO_DEUDA_VENCIDA    OUT NUMBER,
                                  PO_DEUDA_NO_VENCIDA OUT NUMBER,
                                  PO_CURSOR_CUENTA    OUT SYS_REFCURSOR);
                                    
  /**************************************************************
  Nombre SP         : SICEFUN_GET_COIDSTATUS
  Proposito         : Obtiene el estado de un contratoi
  Input             : PI_CO_ID - Codigo de contrato
  Output            : Estado del contrato (a, s, d)
  Creado por        : HITSS
  Fec Creacion      : 28-01-2019
  Fec Actualizacion : 28-01-2019
  **************************************************************/
  FUNCTION SICEFUN_GET_COIDSTATUS(PI_CO_ID NUMBER) RETURN VARCHAR2;
  
END PKG_SICES_FAILURE;									  
/
