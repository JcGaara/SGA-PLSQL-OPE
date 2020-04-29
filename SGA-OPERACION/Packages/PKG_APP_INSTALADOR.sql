CREATE OR REPLACE PACKAGE OPERACION.PKG_APP_INSTALADOR IS

  v_idlista_SERVICE_ID              constant number := 92;
  v_idlista_CUSTOMER_ID             constant number := 91;
  v_idlista_serviceType             constant number := 93;
  v_idlista_MacAddress_CM           constant number := 94;
  v_idlista_MacAddress_MTA          constant number := 96;
  v_idlista_Model_MTA               constant number := 97;
  v_idlista_Phone_Num               constant number := 98;
  v_idlista_Model_CM                constant number := 104;
  v_idlista_serialNumber_STB        constant number := 110;
  v_idlista_Model_STB               constant number := 112;
  v_idlista_HOST_UNIT_ADDRESS       constant number := 111;
  v_idlista_est                     constant number := 127;
  v_cabe_docu_HFC                   constant varchar2(20) := 'ALTA_PROV';
  v_docu_inter                      constant varchar2(20) := 'INTERNET';
  v_docu_telef                      constant varchar2(20) := 'TELEFONIA';
  v_docu_tv                         constant varchar2(20) := 'CABLE';
  v_estnumtel_Dispo                 constant number := 2;
  v_Cod_Resp_Cero                   constant number := 0;
  v_Cod_Resp_Uno                    constant number := 1;
  v_Cod_Resp_Dos                    constant number := 2;
  av_Mensaje_OK                     constant varchar2(20) := 'Exito';
  v_No_Activo                       constant number := 0;
  v_Activo                          constant number := 1;
  v_Tiptra_Alta                     constant number := 658;
  n_exito_CERO                      constant number := 0;--Para el Segundo Pase
  n_exito_201                       constant number := 201;
  n_action_add_INTER                CONSTANT NUMBER := 1;
  n_action_add_TELEF                CONSTANT NUMBER := 2;
  n_action_add_SERV_CABLE           CONSTANT NUMBER := 3;
  n_action_add_CABLE                CONSTANT NUMBER := 12;
  n_action_les_INTER                CONSTANT NUMBER := 4;
  n_action_les_TELEF                CONSTANT NUMBER := 5;
  n_action_les_SERV_CABLE           CONSTANT NUMBER := 6;
  n_action_les_CABLE                CONSTANT NUMBER := 13;
  v_tipsrv_INT constant tystipsrv.tipsrv%type := '0006';
  v_tipsrv_TLF constant tystipsrv.tipsrv%type := '0004';
  v_tipsrv_TV  constant tystipsrv.tipsrv%type := '0062';


  cc_tipsrv_cable     inssrv.tipsrv%type := '0062';
  cc_tipsrv_internet  inssrv.tipsrv%type := '0006';
  cc_tipsrv_telefonia inssrv.tipsrv%type := '0004';


/*Cursor Generico
*/
TYPE T_CURSOR is REF CURSOR;

/*
****************************************************************'
* Nombre PACKAGE : OPERACION.PKG_APP_INSTALADOR
* Propósito : El Package agrupa las funcionalidades necesarias para el APP Instalador.
* Input :  -
* Output : -           
* Creado por : Obed Ortiz Navarrete
* Fec Creación : 21/03/2019
* Fec Actualización : 06/05/2019
* Versión      Fecha       Autor            Solicitado por                   Descripción
* ---------  ----------  ---------------    ------------------               ------------------------------------------
*  1.0        06-05-2019  Abel Ojeda        Equipo BackEnd App Instalador    Implementación para activar equipos en incognito y janus
****************************************************************
*/

/*
****************************************************************'
* Nombre SP : CLRHSS_VALIDA_RESERVA
* Propósito : El SP permite traer la lista de reservas asignadas a una SOT para ser validadas
              con INCOGNITO.
* Input :  PI_NRO_SOT   - Numero de SOT
* Output : PO_CURSOR    - Listado de direcciones
           PO_ID_CLI    - Id cliente con el que sera validado
           PO_TIP_CLI   - Validar si es un cliente BSSC o SGA
           PO_RESULTADO - Codigo resultado
           PO_MSGERR    - Mensaje resultado
* Creado por : Obed Ortiz Navarrete
* Fec Creación : 21/03/2019
* Fec Actualización : --
****************************************************************
*/

PROCEDURE CLRHSS_VALIDA_RESERVA(PI_NRO_SOT   IN NUMBER,
                                PO_CURSOR    OUT SYS_REFCURSOR,
                                PO_ID_CLI    OUT VARCHAR2,
                                PO_TIP_CLI   OUT NUMBER,
                                PO_RESULTADO OUT INTEGER,
                                PO_MSGERR    OUT VARCHAR2);

/*
****************************************************************'
* Nombre SP : CLRHSI_REGIS_RESERVA
* Propósito : El SP permite relanzar las reservas
* Input :  PI_NRO_SOT   - Numero de SOT
* Output : PO_ID_CLI    - Id cliente con el que sera validado
           PO_RESULTADO - Codigo resultado
           PO_MSGERR    - Mensaje resultado
* Creado por : Obed Ortiz Navarrete
* Fec Creación : 01/04/2019
* Fec Actualización : --
****************************************************************
*/

PROCEDURE CLRHSI_REGIS_RESERVA(PI_NRO_SOT   IN NUMBER,
                               PO_ID_CLI    OUT VARCHAR2,
                               PO_RESULTADO OUT INTEGER,
                               PO_MSGERR    OUT VARCHAR2);

/*
****************************************************************'
* Nombre SP : CLRHSS_EQUI_INSTALA
* Propósito : El SP permite listar los equipos a instalar.
* Input :  PI_NRO_SOT   - Numero de SOT.
* Output : PO_CURSOR    - Cursor que lista los equipos a instalar.
           PO_RESULTADO - Codigo resultado.
           PO_MSGERR    - Mensaje resultado.
* Creado por : Obed Ortiz Navarrete 
* Fec Creación : 04/04/2019
* Fec Actualización : 13/06/2019
****************************************************************
*/

PROCEDURE CLRHSS_EQUI_INSTALA(PI_NRO_SOT   IN NUMBER,
                              PO_CURSOR    OUT SYS_REFCURSOR,
                              PO_RESULTADO OUT INTEGER,
                              PO_MSGERR    OUT VARCHAR2);
                               
                         

/*
****************************************************************'
* Nombre SP : CLRHSI_ACTIVA_SERVICIO
* Propósito : El SP activar equipos en Incognito.
* Input :  PI_NRO_SOT        - Numero de SOT.
           PI_INTERFASE      - Interfase para incognito (620,820,2020).
           PI_IDTRS          - Idtrs de la tabla OPERACION.TRS_INTERFACE_IW.
           PI_MAC_ADDRESS    - Mac Address.
           PI_UNIT_ADDRESS   - Unit Address.
           PI_MODELO         - Modelo DECO.
* Output : PO_RESULTADO      - Codigo resultado.
           PO_MSGERR         - Mensaje resultado.
           PO_ERROR          - Codigo de error.
* Creado por : Abel Ojeda 
* Fec Creación : 13/05/2019
* Fec Actualización : 13/06/2019
****************************************************************
*/
                                  
PROCEDURE CLRHSI_ACTIVA_SERVICIO(PI_NRO_SOT      IN NUMBER,
                                 PI_INTERFASE    IN NUMBER,
                                 PI_IDTRS        IN NUMBER,
                                 PI_MAC_ADDRESS  IN VARCHAR2,
                                 PI_UNIT_ADDRESS IN VARCHAR2,
                                 PI_MODELO       IN VARCHAR2,
                                 PO_RESULTADO    OUT VARCHAR2,
                                 PO_MSGERR       OUT VARCHAR2,
                                 PO_ERROR        OUT NUMBER);
/*
****************************************************************'
* Nombre SP : CLRHSU_INTERF_IW
* Propósito : El SP actualiza Mac Address, Unit Address y Modelo en la tabla
              OPERACION.TRS_INTERFACE_IW.
* Input :  PI_NRO_SOT        - Numero de SOT.
           PI_INTERFASE      - Interfase para incognito (620,820,2020).
           PI_IDTRS          - Idtrs de la tabla OPERACION.TRS_INTERFACE_IW.
           PI_MAC_ADDRESS    - Mac Address.
           PI_UNIT_ADDRESS   - Unit Address.
           PI_MODELO         - Modelo DECO.
* Output : PO_RESULTADO      - Codigo resultado  .         
           PO_MSGERR         - Mensaje resultado.
           PO_ERROR          - Codigo de error.
* Creado por : Abel Ojeda
* Fec Creación : 13/05/2019
* Fec Actualización : --
****************************************************************
*/                                     
                                   
PROCEDURE CLRHSU_INTERF_IW(PI_NRO_SOT      IN NUMBER,
                           PI_INTERFASE    IN NUMBER,
                           PI_IDTRS        IN NUMBER,
                           PI_MACADDRESS   IN VARCHAR2,
                           PI_UNIT_ADDRESS IN VARCHAR2,
                           PI_MODELO       IN VARCHAR2,
                           PO_RESULTADO    OUT VARCHAR2,
                           PO_MSGERR       OUT VARCHAR2,
                           PO_ERROR        OUT NUMBER);
/*
****************************************************************'
* Nombre SP : CLRHSS_CONSULTA_EQUIPO
* Propósito : El SP permite obtener el customer_id, identificador,
           interfase, modelo, id_producto asignadas a una SOT para 
           ser validadas con INCOGNITO.
* Input :  PI_NRO_SOT   - Numero de SOT
* Output : PO_CURSOR    - Listado de parametros
           PO_RESULTADO - Codigo resultado
           PO_MSGERR    - Mensaje resultado
* Creado por : Emiliano Espinoza 
* Fec Creación : 16/05/2019
* Fec Actualización : 13/06/2019
****************************************************************
*/                                     
PROCEDURE CLRHSS_CONSULTA_EQUIPO(PI_NRO_SOT   IN NUMBER,
                                 PO_CURSOR    OUT SYS_REFCURSOR,
                                 PO_RESULTADO OUT INTEGER,
                                 PO_MSGERR    OUT VARCHAR2);

/*
****************************************************************'
* Nombre SP : CLRHSS_CONSULTA_DATOS_SOT
* Propósito : El SP permite traer el flag de portabilidad, plan contratado y listar los numeros del cliente.
* Input :  PI_NRO_SOT   - Numero de SOT
* Output : PO_FLG_PORTABLE - Flag de portabilidad
           PO_PLAN         - Plan contratado
           PO_CURSOR       - Listado de numeros del cliente
           PO_RESULTADO    - Codigo resultado
           PO_MSGERR       - Mensaje resultado
* Creado por : Hitss
* Fec Creación : 28/05/2019
* Fec Actualización : --
****************************************************************
*/

PROCEDURE CLRHSS_CONSULTA_DATOS_SOT(PI_NRO_SOT      IN NUMBER,
                                    PO_FLG_PORTABLE OUT INTEGER,
                                    PO_PLAN         OUT VARCHAR2,
                                    PO_CURSOR       OUT SYS_REFCURSOR,
									PO_CODIGO_CLIENTE OUT VARCHAR2,
									PO_DESCRIPCION    OUT VARCHAR2,
									PO_COD_ESCENARIO  OUT VARCHAR2,
                                    PO_ESCENARIO      OUT VARCHAR2,
									PO_COD_TECNOLOGIA OUT VARCHAR2,
                                    PO_TECNOLOGIA     OUT VARCHAR2,
                                    PO_RESULTADO    OUT INTEGER,
                                    PO_MSGERR       OUT VARCHAR2);
  /*
****************************************************************'
* Nombre FN : CLRHFS_PLAN_CONTRATADO
* Propósito : La FN permite obtener el plan contrado (1,2,3 Play).
* Input :  PI_NRO_SOT   - Numero de SOT
* Output : v_plan_c     - Plan contratado
* Creado por : Hitss
* Fec Creación : 02/07/2019
* Fec Actualización : --
****************************************************************
*/  

FUNCTION CLRHFS_PLAN_CONTRATADO(PI_NRO_SOT IN operacion.solotpto.codsolot%TYPE)return VARCHAR2;  
  
  /*
****************************************************************'
* Nombre SP : CLRHSS_VALIDAR_DECO
* Propósito : El SP permite validar el tipo de plan contratado respecto al decodeficador.
* Input :  PI_TIPODECO   - TIPO DEL DECODEFICADOR
		   PI_MODELO - MODELO DEL DECODEFICADOR
* Output : PO_CURSOR    - Listado de parametros
           PO_RESULTADO - Codigo resultado
           PO_MSGERR    - Mensaje resultado
* Creado por : Emiliano Espinoza
* Fec Creación : 19/06/2019
* Fec Actualización :
****************************************************************
*/
PROCEDURE CLRHSS_VALIDAR_DECO(PI_TIPODECO  IN VARCHAR2,
                              PI_MODELO    IN VARCHAR2,
                              PO_RESULTADO OUT INTEGER,
                              PO_MSGERR    OUT VARCHAR2);
/*
****************************************************************'
* Nombre SP : CLRHSI_GUARDA_COORDENADAS
* Propósito : El SP permite guardar las coordenas x e y en SGA.
* Input :  PI_NRO_SOT   - Numero de SOT
           PI_COORDX    - Coordenada X
           PI_COORDY    - Coordenada Y
* Output : PO_RESULTADO - Codigo resultado
           PO_MSGERR    - Mensaje resultado
* Creado por : Hitss
* Fec Creación : 21/06/2019
* Fec Actualización : 
****************************************************************
*/ 

PROCEDURE CLRHSI_GUARDA_COORDENADAS(PI_NRO_SOT   IN operacion.agendamiento.codsolot%TYPE,
                                    PI_COORDX    IN marketing.vtasuccli.coordx_eta%TYPE,
                                    PI_COORDY    IN marketing.vtasuccli.coordy_eta%TYPE,
                                    PO_RESULTADO OUT INTEGER,
                                    PO_MSGERR    OUT VARCHAR2);

/*
****************************************************************'
* Nombre FN : CLRHSI_ACTUALIZA_XY
* Propósito : El SP permite guardar las coordenas X e Y en las 
              tablas vtasuccli y vtatabcli_his.
* Input :  PI_CODCLI  - Codigo del cliente (codcli)
           PI_CODSUC  - Codigo de la sucursal (codsuc)
           PI_COORDX  - Coordenada X
           PI_COORDY  - Coordenada Y
* Output : PO_RESULTADO - Codigo resultado
           PO_MSGERR    - Mensaje resultado
* Creado por : Hitss
* Fec Creación : 02/07/2019
* Fec Actualización : --
****************************************************************
*/ 

PROCEDURE CLRHSI_ACTUALIZA_XY(PI_CODCLI    IN marketing.vtasuccli.codcli%TYPE,
                              PI_CODSUC    IN marketing.vtasuccli.codsuc%TYPE,
                              PI_COORDX    IN marketing.vtasuccli.coordx_eta%TYPE,
                              PI_COORDY    IN marketing.vtasuccli.coordy_eta%TYPE,
                              PO_RESULTADO OUT INTEGER,
                              PO_MSGERR    OUT VARCHAR2);



 /*
  ****************************************************************'
  * Nombre SP : CLRHSS_STATUS_CONNECTIVITY
  * Propósito : El SP permite obtener los estados de conectividad de los servicios internet,cable y telefonia de manera masiva y estado de conectividad del EMTA del cliente.
  * Input :  AN_CODCLI   - Numero de SOT
  * Output : AN_ICO_TEL    - 1 Operativo Telefono 0 lo contrario
             AN_ICO_CAB    - 1 Operativo Cable 0 lo contrario
             AN_ICO_INT    - 1 Operativo Internet 0 lo contrario
             AN_STA_AVERIA - Retorna el estado de la averia masiva 4 Error, 1 Correcto,2 Posible Averia, 3 Recien salido de Vaeria masiva
             PO_RESULTADO - Codigo resultado
             PO_MSGERR    - Mensaje resultado
  * Creado por : Alex Salome
  * Fec Creación : 06/09/2019
  * Fec Actualización : --
  ****************************************************************
  */

PROCEDURE CLRHSS_STATUS_CONNECTIVITY(PI_CODSOT   IN NUMBER,
                                       PO_STATUS_SERVICES  OUT T_CURSOR,
                                       PO_RESULTADO OUT NUMBER,
                                       PO_MSGERR    OUT VARCHAR2);
									   

  /*
  ****************************************************************'
  * Nombre SP : CLRHSS_CONSULTA_CINTILLO
  * Propósito : El SP permite obtener el cintillo para HFC. Obtiene 
              cintillo, fat y borne para FTTH.
  * Input :  PI_NRO_SOT   - Numero de SOT
             PI_CODCLI    - Codigo de cliente
  * Output : PO_CINTILLO  - HFC: Cintillo / FTTH: Cintillo
             PO_BORNE     - FTTH: Borne
             PO_FAT       - FTTH: FAT
             PO_RESULTADO - Codigo resultado
             PO_MSGERR    - Mensaje resultado
  * Creado por : Anthony Moreno
  * Fec Creación : 12/09/2019
  * Fec Actualización : 15/01/2020
  ****************************************************************
  */
  
PROCEDURE CLRHSS_CONSULTA_CINTILLO(PI_NRO_SOT      IN NUMBER,
                                   PI_CODCLI       IN VARCHAR2,
                                   PO_CINTILLO     OUT VARCHAR2,
                                   PO_BORNE        OUT VARCHAR2,
                                   PO_FAT          OUT VARCHAR2,
                                   PO_RESULTADO    OUT INTEGER,
                                   PO_MSGERR       OUT VARCHAR2);

/*
  ****************************************************************'
  * Nombre SP : CLRHSU_ACTUALIZA_CINTILLO
  * Propósito : El SP permite actualizar el cintillo para HFC.
               Actualiza cintillo fat y borne para FTTH.
  * Input :  PI_NRO_SOT   - Numero de SOT
             PI_CODCLI    - Codigo de cliente
             PI_CINTILLO  - Cintillo hfc/ftth
             PI_BORNE     - FTTH: Borne
             PI_FAT       - FTTH: FAT
  * Output : PO_RESULTADO - Codigo resultado
             PO_MSGERR    - Mensaje resultado
  * Creado por : Anthony Moreno
  * Fec Creación : 12/09/2019
  * Fec Actualización : 15/01/2020
  ****************************************************************
  */

PROCEDURE CLRHSU_ACTUALIZA_CINTILLO(PI_NRO_SOT      IN NUMBER,
                                    PI_CODCLI       IN VARCHAR2,
                                    PI_CINTILLO     IN VARCHAR2,
                                    PI_BORNE        IN VARCHAR2,
                                    PI_FAT          IN VARCHAR2,
                                    PO_RESULTADO    OUT INTEGER,
                                    PO_MSGERR       OUT VARCHAR2);


   /*
  ****************************************************************'
  * Nombre SP : CLRHSS_VISITA_TECNICA
  * Propósito : El SP permite consultas las visitas tecnicas.
  * Input :  PI_NRO_SOT - Numero de SOT
             PI_CANT_DIAS - Cantidad de dias             
  * Output : PO_CURSOR  - Cursor de visitas tecnicas
             PO_RESULTADO - Codigo de respuesta
             PO_MSGERR    - Mensaje de respuesta
  * Creado por : Jefferson Ore
  * Fec Creación : 24/09/2019
  * Fec Actualización : --
  ****************************************************************
  */
PROCEDURE CLRHSS_VISITA_TECNICA(PI_NRO_SOT     IN NUMBER,                                    
                                   PI_CANT_DIAS   IN NUMBER,
                                   PO_CURSOR      OUT SYS_REFCURSOR,
                                   PO_RESULTADO   OUT INTEGER,
                                   PO_MSGERR      OUT VARCHAR2);

PROCEDURE CLRHSS_CONSULTA_MANT_PROBLEMA(PI_NRO_SOT        IN NUMBER,
                                      PO_DES_PRO      OUT VARCHAR2,
                                      PO_RESULTADO      OUT INTEGER,
                                      PO_MSGERR         OUT VARCHAR2);
									  

 /*
****************************************************************'
* Nombre SP : SP_ACTUALIZAR_CONTADOR
* Propósito : SP QUE ACTUALIZA EL TOTAL DE EQUIPOS INSTALADOS / DESINSTALADOS
* Input :  v_codsolot           - CODIGO SOLOT
* Input :  v_iddet              - ID DEL DETALLE DE RECETA
* Input :  v_accion             - ACCION A REALIZA -> 0 = ACTIVAR / 1 = DESACTIVAR
* Input :  v_serviceid          - NUMERO TELEFONICO
* Output : an_Codigo_Resp       - CODIGO DE RESULTADO ->0 = EXITO / 1 = ERROR 
           av_Mensaje_Resp      - MENSAJE DE RESULTADO -> EXITO / ERROR 
* CREACDO POR : 
* FEC CREACION : 05/08/2019
* FEC ACTUALIZACION : --
****************************************************************
*/    

PROCEDURE SP_ACTUALIZAR_CONTADOR(v_codsolot        VARCHAR2,
                                   v_iddet           NUMBER,                                                                      
                                   v_accion          NUMBER,
                                   v_serviceid       VARCHAR2,
                                   an_Codigo_Resp    OUT NUMBER,
                                   av_Mensaje_Resp   OUT VARCHAR2);

/*
****************************************************************'
* Nombre SP : SP_ACTUALIZA_DETALLE_CONTADOR
* Propósito : SP QUE ACTUALIZA EL DETALLE DE LOS EQUIPOS INSTALADOS / DESINSTALADOS
* Input :   v_codsolot           - CODIGO SOLOT
			v_iddet              - ID DEL DETALLE DE RECETA
			v_codaction          - CODIGO DE ACCION
			v_estado_ficha       - ESTADO DE LA FICHA -> 0 = INACTIVO / 1= ACTIVO
* Output :  an_Codigo_Resp       - CODIGO DE RESULTADO ->0 = EXITO / 1 = ERROR 
            av_Mensaje_Resp      - MENSAJE DE RESULTADO -> EXITO / ERROR 
* CREADO POR : 
* FEC CREACION : 05/08/2019
* FEC ACTUALIZACION : --
****************************************************************
*/ 
  
  PROCEDURE SP_ACTUALIZA_DETALLE_CONTADOR(v_codsolot        VARCHAR2,
                                       v_iddet              NUMBER,
                                       v_codaction          NUMBER,                                                                   
                                       v_estado_ficha       NUMBER,--1(Activo),0(Inactivo)
                                       an_Codigo_Resp      OUT NUMBER,
                                       av_Mensaje_Resp     OUT VARCHAR2);
								   
 /*
****************************************************************'
* Nombre SP : SP_ALINEAR_SERVICIOS
* Propósito : SP QUE ALINEA LOS SERVICIOS LUEGO DE PROCEDER CON LA  INSTALACION / DESINSTALACION DE LOS EQUIPOS
* Input :   an_codsolot          - CODIGO SOLOT
			an_customer_id       - ID DEL CLIENTE
* Output :  an_Codigo_Resp       - CODIGO DE RESULTADO ->0 = EXITO / 1 = ERROR 
			av_Mensaje_Resp      - MENSAJE DE RESULTADO -> EXITO / ERROR 
* CREACDO POR : 
* FEC CREACION : 05/08/2019
* FEC ACTUALIZACION : --
****************************************************************
*/ 
  
procedure SP_ALINEAR_SERVICIOS(an_codsolot           solot.codsolot%type,
                                 an_customer_id        varchar2,
                                 an_Codigo_Resp        out number,
                                 av_Mensaje_Resp       out varchar2);
								 
 /*
****************************************************************'
* Nombre SP : P_ACTUALIZA_ESTADO_DETPROVCP
* Propósito : SP QUE ACTULICE EL ESTADO DE LA TABLA DETALLE CAMBIO DE PLAN
* Input :   an_iddet          - CODIGO SOLOT
			av_service_id       - ID DEL CLIENTE
			an_estado
* CREADO POR : 
* FEC CREACION : 05/08/2019
* FEC ACTUALIZACION : --
****************************************************************
*/ 
 
procedure P_ACTUALIZA_ESTADO_DETPROVCP(an_iddet           number,
                                         av_service_id      varchar2,
                                         an_estado          number);

/*
 ****************************************************************'
* Nombre SP : CLRHSI_REGIS_AGENDA
* Propósito : El SP permite insertar en la tabla agendamientochgest en 
			  caso de activacion de equipos (altas) y cambio de equipo 
			  registrando la MAC, Modelo, Serie, UA del equipo.
* Input :  PI_IDAGENDA		- Numero idagenda
           PI_TIPO          - Tipo 1:Instalacion / 2:Cambio de Equipo
		   PI_OBSERVACION	- Campo observacion
* Output : PO_RESULTADO 	- Codigo resultado
           PO_MSGERR   		- Mensaje resultado
* Creado por : Wendy Tamayo
* Fec Creación : 28/11/2019
* Fec Actualización : --
****************************************************************
*/ 

PROCEDURE CLRHSI_REGIS_AGENDA 	(PI_IDAGENDA     IN NUMBER,
                                 PI_TIPO         IN NUMBER,
                                 PI_OBSERVACION  IN VARCHAR2,
                                 PO_RESULTADO    OUT INTEGER,
                                 PO_MSGERR       OUT VARCHAR2);


/*
 ****************************************************************'
* Nombre SP : CLRHSS_MOT_SOLUCION
* Propósito : Permite traer la lista de soluciones para ser 
		      seleccionado por el tecnico a traves de la app 
			  instalador, para el flujo de Mantenimiento. 
* Input:   PI_IDAGENDA    - Numero de id agenda
* Output : PO_CURSOR      - Lista de Motivos
		   PO_RESULTADO   - Codigo resultado
           PO_MSGERR   	  - Mensaje resultado
* Creado por : Wendy Tamayo
* Fec Creación : 26/11/2019
* Fec Actualización : --
****************************************************************
*/ 

Procedure CLRHSS_MOT_SOLUCION(PI_IDAGENDA     IN NUMBER,
                              PO_CURSOR       OUT T_CURSOR,
                              PO_RESULTADO    OUT INTEGER,
                              PO_MSGERR       OUT VARCHAR2);


/*
 ****************************************************************'
* Nombre SP : CLRHSU_GUARDAR_MOTSOLUCION
* Propósito : Permite guardar el motivo solucion por el tecnico 
              a traves de la app instalador, para el flujo de 
              Mantenimiento. 
* Input:   PI_IDAGENDA    - Numero de id agenda
           PI_MOT_SOL     - codigo de motivo solucion
           PI_OBSERVACION - campo observacion           
* Output : PO_RESULTADO   - Codigo resultado
           PO_MSGERR   	  - Mensaje resultado
* Creado por : Wendy Tamayo
* Fec Creación : 29/11/2019
* Fec Actualización : --
****************************************************************
*/ 

Procedure CLRHSU_GUARDAR_MOTSOLUCION (PI_IDAGENDA     IN NUMBER,
                                      PI_MOT_SOL      IN NUMBER,
                                      PI_OBSERVACION  IN VARCHAR2,
                                      PO_RESULTADO    OUT INTEGER,
                                      PO_MSGERR       OUT VARCHAR2);

/*
 ****************************************************************'
* Nombre SP : SP_APP_LOG_AUDIT
* Propósito : Permite guardar las transacciones de error del app instalador, 
			        Auditoria
* Input:   p_evento     - Transacción que se realiza, breve descripcion
           p_codusu     - codigo de usuario (DNI del tecnico)
           p_nomusu     - Nombre del usuario (tecnico)
           p_url	      - url del servicio ejecutado   
           p_variable   - Variables, codigos del body  
           p_msgrpta    - Mensaje de Respuesta: ERRORES   
* Output : PO_RESULTADO - Codigo resultado
           PO_MSGERR   	- Mensaje resultado
* Creado por : Cesar Rengifo
* Fec Creación : 23/12/2019
* Fec Actualización : --
****************************************************************
*/

PROCEDURE SP_APP_LOG_AUDIT(p_evento      IN AUDITORIA.APP_LOG_AUDIT.logv_evento%type,
                           p_codusu      IN AUDITORIA.APP_LOG_AUDIT.logv_codusu%type,
                           p_nomusu      IN AUDITORIA.APP_LOG_AUDIT.logv_nomusu%type,
                           p_url         IN AUDITORIA.APP_LOG_AUDIT.logv_url%type,
                           p_variable    IN AUDITORIA.APP_LOG_AUDIT.logc_variable%type,
                           p_msgrpta     IN AUDITORIA.APP_LOG_AUDIT.logv_msgrpta%type,
                           PO_RESULTADO  OUT INTEGER,
                           PO_MSGERR     OUT VARCHAR2);                                      

/*
 ****************************************************************'
* Nombre SP : CLRHSS_ESTADO_ADCTOA
* Propósito : Permite traer la lista de estados para el cierre 
		          de la orden de trabajo Iniciada en el TOA
* Output : PO_CURSOR      - Lista de Estado
		       PO_RESULTADO 	- Codigo resultado
           PO_MSGERR   		- Mensaje resultado
* Creado por : Cesar Rengifo
* Fec Creación : 08/01/2020
* Fec Actualización : --
****************************************************************
*/ 

Procedure CLRHSS_ESTADO_ADCTOA(PO_CURSOR       OUT T_CURSOR,
                               PO_RESULTADO    OUT INTEGER,
                               PO_MSGERR       OUT VARCHAR2);



/*
 ****************************************************************'
* Nombre SP : CLRHSS_RAZON_ADCTOA
* Propósito : Permite traer la lista de razones de quiebre, para 
              ser elegido por el tecnico para el cierre de la orden
* Input:   PI_NRO_SOT      - Numero de SOT
           PI_IDESTADO_ADC - Codigo de estado de cierre de TOA                           
* Output : PO_CURSOR       - Lista de Razones de quiebre TOA
		       PO_RESULTADO 	 - Codigo resultado
           PO_MSGERR   		 - Mensaje resultado
* Creado por : Cesar Rengifo
* Fec Creación : 08/01/2020
* Fec Actualización : --
****************************************************************
*/ 

Procedure CLRHSS_RAZON_ADCTOA(PI_NRO_SOT      IN NUMBER,
                               PI_IDESTADO_ADC IN NUMBER,                             
                               PO_CURSOR       OUT T_CURSOR,
                               PO_RESULTADO    OUT INTEGER,
                               PO_MSGERR       OUT VARCHAR2);
							   
/*
 ****************************************************************'
* Nombre SP : CLRHSI_REG_CODIVR
* Propósito : Permite Grabar Codigo IVR en el SGA
* Input:   PI_IDAGENDA    - Id Agenda
           PI_CODIVR      - Codigo IVR
* Output : PO_RESULTADO 	- Codigo resultado
           PO_MSGERR   		- Mensaje resultado
* Creado por : Cesar REngifo
* Fec Creación : 23/01/2020
* Fec Actualización : --
****************************************************************
*/                                  
    
PROCEDURE CLRHSI_REG_CODIVR  (PI_IDAGENDA     IN NUMBER,
                              PI_CODIVR       IN NUMBER,
                              PO_RESULTADO    OUT INTEGER,
                              PO_MSGERR       OUT VARCHAR2);							   

/*
 ****************************************************************'
* Nombre SP : CLRHSI_IMAGEN_APROB
* Propósito : Insertar los escenarios a ejecutar, para la gestion
              fotografica, App Servicio Tecnico, en estado pendiente.
* Input:    PI_CODSOLOT        - Numero de SOT   
            PI_IDAGENDA        - Id Agenda
            PI_DNITECNICO      - Dni de tecnico
            PI_CODCONTRATA     - Codigo de contrata
            PI_IDACTIVIDAD     - Codigo de Trabajo a Realizar
            PI_IDSERVICIO      - Codigo de Servicio
            PI_CANTIATENCION   - Cantidad Total de equipos a instalar
            PI_IDESCENARIO     - Codigo de Escenario de Trabajo a Realizar  
            PI_COD_FOTO        - Codigo de foto a tomar      
* Output :  PO_RESULTADO       - Codigo resultado
            PO_MSGERR          - Mensaje resultado
* Creado por : Cesar Rengifo
* Fec Creación : 10/01/2020
* Fec Actualización : --
****************************************************************
*/                                  
    
PROCEDURE CLRHSI_IMAGEN_APROB(PI_CODSOLOT       IN OPERACION.SOLOT.CODSOLOT%TYPE,
                              PI_IDAGENDA      IN OPERACION.AGENDAMIENTO.IDAGENDA%TYPE,
                              PI_DNITECNICO     IN AGENLIQ.SGAT_AGENDA.AGENC_DNITECNICO%TYPE,
                              PI_CODCONTRATA    IN OPERACION.CONTRATA.CODCON%TYPE,
                              PI_IDACTIVIDAD    IN NUMBER,
							  PI_IDSERVICIO     IN NUMBER,
							  PI_CANTIATENCION  IN NUMBER,
						      PI_IDESCENARIO    IN NUMBER,
                              PI_COD_FOTO       IN VARCHAR2,
                              PO_RESULTADO     OUT INTEGER,
                              PO_MSGERR        OUT VARCHAR2);   							  
							  
/*
 ****************************************************************'
* Nombre SP : CLRHSS_REPORTE_FOTO
* Propósito : Consulta del reporte fotografico por idagenda, mostrara 
              la lista de fotos pendientes a tomar por el tecnico.
* Input:   PI_IDAGENDA    - Id Agenda
* Output : PO_CURSOR      - Lista reporte
           PO_RESULTADO 	- Codigo resultado
           PO_MSGERR   		- Mensaje resultado
* Creado por : Wendy Tamayo
* Fec Creación : 29/01/2020
* Fec Actualización : --
****************************************************************
*/     

PROCEDURE CLRHSS_REPORTE_FOTO (PI_IDAGENDA     IN NUMBER,
                               PO_CURSOR       OUT T_CURSOR,                
                               PO_RESULTADO    OUT INTEGER,
                               PO_MSGERR       OUT VARCHAR2);

/*
 ****************************************************************'
* Nombre SP : CLRHSS_FOTOS_ENV
* Propósito : Consulta del reporte fotografico, mostrara las fotos 
              tomadas por el tecnico por el App Servicio Tecnico.
* Input:   PI_IDAGENDA    - Id Agenda
* Output : PO_CURSOR      - Lista reporte
		   PO_RESULTADO   - Codigo resultado
           PO_MSGERR   	  - Mensaje resultado
* Creado por : Wendy Tamayo
* Fec Creación : 31/01/2020
* Fec Actualización : --
****************************************************************
*/  

PROCEDURE CLRHSS_FOTOS_ENV   	(PI_IDAGENDA     IN NUMBER,
                               PO_CURSOR       OUT T_CURSOR,                
                               PO_RESULTADO    OUT INTEGER,
                               PO_MSGERR       OUT VARCHAR2);
 

/*
 ****************************************************************'
* Nombre SP : CLRHSU_ACT_REPORT_FOTO
* Propósito : Actualizar reporte fotografico, insertar imagen tomada
              por el tecnico, cambio de estado en proceso de atencion.
* Input:   PI_IDAGENDA    - Id Agenda
           PI_IDREPORTE   - Id del reporte
           PI_DES_IMG     - Descripcion nombre foto
           PI_IMAGEN      - Imagen tomada por el App             
* Output : PO_RESULTADO 	- Codigo resultado
           PO_MSGERR   		- Mensaje resultado
* Creado por : Wendy Tamayo
* Fec Creación : 29/01/2020
* Fec Actualización : --
****************************************************************
*/   

PROCEDURE CLRHSU_ACT_REPORT_FOTO (PI_IDAGENDA     IN NUMBER,
                               PI_IDREPORTE    IN NUMBER,
                               PI_DES_IMG      IN VARCHAR2,
                               PI_IMAGEN       IN BLOB,      
                               PO_RESULTADO    OUT INTEGER,
                               PO_MSGERR       OUT VARCHAR2); 


/*
 ****************************************************************'
* Nombre SP : CLRHSS_LOGIN_TECNICO
* Propósito : Datos del tecnico para atencion de SOT para 
              tecnologia LTE Y DTH.
* Input:   PI_DNI         - Id Agenda
* Output:  PO_CURSOR      - Datos del tecnico
           PO_RESULTADO 	- Codigo resultado
           PO_MSGERR   		- Mensaje resultado
* Creado por: Wendy Tamayo
* Fec Creación: 07/02/2020
* Fec Actualización : --
****************************************************************
*/

PROCEDURE CLRHSS_LOGIN_TECNICO (PI_DNI          IN VARCHAR2,
                               PO_CURSOR       OUT T_CURSOR,                
                               PO_RESULTADO    OUT INTEGER,
                               PO_MSGERR       OUT VARCHAR2);
/*
 ****************************************************************'
* Nombre SP : CLRHSS_LISTA_SOT
* Propósito : Lista de SOTs asociadas a un tecnico para la 
              tecnologia LTE y DTH.
* Input:   PI_DNI         - Id Agenda
* Output:  PO_CURSOR      - Lista Sots por atender
           PO_RESULTADO 	- Codigo resultado
           PO_MSGERR   		- Mensaje resultado
* Creado por : Wendy Tamayo
* Fec Creación : 07/02/2020
* Fec Actualización : --
****************************************************************
*/   

PROCEDURE CLRHSS_LISTA_SOT (PI_DNI          IN VARCHAR2,
                               PO_CURSOR       OUT T_CURSOR,                
                               PO_RESULTADO    OUT INTEGER,
                               PO_MSGERR       OUT VARCHAR2);

/*
 ****************************************************************'
* Nombre SP : CLRHSU_INICIAR_SOT
* Propósito : Inicia SOT, cambia de estado a Ejecucion para 
              tecnologia LTE y DTH.
* Input:   PI_NRO_SOT     - Numero de SOT
* Output:  PO_RESULTADO 	- Codigo resultado
           PO_MSGERR   		- Mensaje resultado
* Creado por : Wendy Tamayo
* Fec Creación : 10/02/2020
* Fec Actualización : --
****************************************************************
*/ 

PROCEDURE CLRHSU_INICIAR_SOT ( PI_NRO_SOT      IN NUMBER,
                               PO_RESULTADO    OUT INTEGER,
                               PO_MSGERR       OUT VARCHAR2);
                               
                               
/*
 ****************************************************************'
* Nombre SP : CLRHSS_LISTA_TELEFINTERNET_LTE
* Propósito : Lista de Telefonia/Cable asociadas a una SOTs para la 
              tecnologia LTE y DTH.
* Input:   PI_NRO_SOT     -  Nro SOT
* Output:  PO_CURSOR      - Lista de Telefonia/Cable
           PO_RESULTADO 	- Codigo resultado
           PO_MSGERR   		- Mensaje resultado
* Creado por : Cesar Rengifo
* Fec Creación : 13/02/2020
* Fec Actualización : --
****************************************************************
*/    

PROCEDURE CLRHSS_LISTA_TELEFINTERNET_LTE (PI_NRO_SOT      IN OPERACION.SOLOT.CODSOLOT%TYPE,
                                      PO_CURSOR       OUT T_CURSOR,                
                                      PO_RESULTADO    OUT INTEGER,
                                      PO_MSGERR       OUT VARCHAR2);                                                                                                                                        

/*
 ****************************************************************'
* Nombre SP : CLRHSS_LISTA_COMPONENTE_DTHLTE
* Propósito : Lista de Antenas y SIM CARD asociadas a una SOTs para la 
              tecnologia LTE y DTH.
* Input:   PI_TIPO        - Tipo 
* Output:  PO_CURSOR      - Lista de Series por Tipo
           PO_RESULTADO 	- Codigo resultado
           PO_MSGERR   		- Mensaje resultado
* Creado por : Cesar Rengifo
* Fec Creación : 18/02/2020
* Fec Actualización : --
****************************************************************
*/    

PROCEDURE CLRHSS_LISTA_COMPONENTE_DTHLTE (PI_TIPO         IN NUMBER,
                                      PO_CURSOR       OUT T_CURSOR,                
                                      PO_RESULTADO    OUT INTEGER,
                                      PO_MSGERR       OUT VARCHAR2);  
                                      
/*
 ****************************************************************'
* Nombre SP : CLRHSS_LISTA_CABLE_DTH
* Propósito : Lista de Tarjetas y Decos asociadas a una SOTs para la 
              tecnologia DTH.
* Input:   PI_NRO_SOT     -  Nro SOT
* Output:  PO_CURSOR      - Lista de Tarjetas y Decos
           PO_RESULTADO 	- Codigo resultado
           PO_MSGERR   		- Mensaje resultado
* Creado por : Cesar Rengifo
* Fec Creación : 19/02/2020
* Fec Actualización : --
****************************************************************
*/    

PROCEDURE CLRHSS_LISTA_CABLE_DTH (PI_NRO_SOT      IN OPERACION.SOLOT.CODSOLOT%TYPE,
                                  PO_CURSOR       OUT T_CURSOR,                
                                  PO_RESULTADO    OUT INTEGER,
                                  PO_MSGERR       OUT VARCHAR2);  
								  
/*
 ****************************************************************'
* Nombre SP : CLRHSI_ASOCIAR_DTH
* Propósito : Permite grabar la Asociacion entre la Tarjeta y el 
              Deco para Cable.
* Input:    PI_CODSOLOT           - Numero de SOT  
            PI_IDDET_DECO         - Id Detalle Deco
            PI_NRO_SERIE_DECO     - mac del decodificador
            PI_IDDET_TARJETA      - Id Detalle Tarjeta
            PI_NRO_SERIE_TARJETA  - nro. serie de la tarjeta
* Output :  PO_RESULTADO          - Codigo resultado
            PO_MSGERR             - Mensaje resultado
* Creado por : Cesar Rengifo
* Fec Creación : 12/02/2020
* Fec Actualización : --
****************************************************************
*/                               
    
PROCEDURE  CLRHSI_ASOCIAR_DTH(PI_CODSOLOT          IN OPERACION.SOLOT.CODSOLOT%TYPE,
                                         PI_IDDET_DECO        IN OPERACION.TARJETA_DECO_ASOC.IDDET_DECO%TYPE,
                                         PI_NRO_SERIE_DECO    IN OPERACION.TARJETA_DECO_ASOC.NRO_SERIE_DECO%TYPE,
                                         PI_IDDET_TARJETA     IN OPERACION.TARJETA_DECO_ASOC.IDDET_TARJETA%TYPE,
                                         PI_NRO_SERIE_TARJETA IN OPERACION.TARJETA_DECO_ASOC.NRO_SERIE_TARJETA%TYPE,
                                         PO_RESULTADO         OUT INTEGER,
                                         PO_MSGERR            OUT VARCHAR2);   
                                         
/*
 ****************************************************************'
* Nombre SP : CLRHSI_DESASOCIAR_DTH
* Propósito : Eliminar la Asociacion de Tarjeta con Deco de una SOTs  
              para la tecnologia LTE y DTH.
* Input:   PI_NRO_SOT     -  Nro SOT
* Output:  PO_RESULTADO 	- Codigo resultado
           PO_MSGERR   		- Mensaje resultado
* Creado por : Cesar Rengifo
* Fec Creación : 11/02/2020
* Fec Actualización : --
****************************************************************
*/    

PROCEDURE CLRHSI_DESASOCIAR_DTH(PI_NRO_SOT      IN OPERACION.SOLOT.CODSOLOT%TYPE,
                                  PO_RESULTADO    OUT INTEGER,
                                  PO_MSGERR       OUT VARCHAR2);   								  

/*
 ****************************************************************'
* Nombre SP : CLRHSS_DESPAREODECO
* Propósito : Eliminar la Asociacion de Tarjeta con Deco de una SOTs  
              para la tecnologia DTH.
* Input:  PI_CODSOLOT          - Codigo de la solicitud de orden de trabajo
          PI_NRO_UA_DECO       - unidad direcccion del deco
          PI_NRO_SERIE_TARJETA - nro. serie de la tarjeta
* Output: PO_RESPUESTA    	   - Codigo resultado
          PO_MENSAJE   		   	 - Mensaje resultado
* Creado por : 
* Fec Creación : 24/02/2020
* Fec Actualización : --
****************************************************************
*/  
PROCEDURE CLRHSS_DESPAREODECO(PI_CODSOLOT          OPERACION.SOLOT.CODSOLOT%TYPE,
                              PI_NRO_UA_DECO       OPERACION.TABEQUIPO_MATERIAL.IMEI_ESN_UA%TYPE,
                              PI_NRO_SERIE_TARJETA OPERACION.TARJETA_DECO_ASOC.NRO_SERIE_TARJETA%TYPE,
                              PO_RESPUESTA         IN OUT VARCHAR2,
                              PO_MENSAJE           IN OUT VARCHAR2);
                                                         
/****************************************************************
  '* Nombre SP:  CLRHSS_DESACTIVARBOUQUET
  '* Proposito:  EL SIGUIENTE SP REALIZA LA DESACTIVACION DE BOUQUETS PARA 
                 UNA TARJETA
  '* Inputs: PI_CODSOLOT - Codigo de la orden de trabajo
             PI_NUMSERIE_TARJETA - Numero de serie de la tarjeta del deco
  '* Output: PO_BOUQUET - Bouquets desactivados
             PO_RESPUESTA - Respuesta de salida
             PO_MENSAJE - Mensaje de salida
  '* Creado por:  HITSS
  '* Fec Creacion:  24/02/2020
  '****************************************************************/
  PROCEDURE CLRHSS_DESACTIVARBOUQUET(PI_CODSOLOT         IN OPERACION.SOLOT.CODSOLOT%TYPE,
                                     PI_NUMSERIE_TARJETA IN OPERACION.SOLOTPTOEQU.NUMSERIE%TYPE,
                                     PO_BOUQUET          OUT OPERACION.SGAT_TRXCONTEGO.TRXV_BOUQUET%TYPE,
                                     PO_RESPUESTA        OUT VARCHAR2,
                                     PO_MENSAJE          OUT VARCHAR2);
									 
/*
****************************************************************'
* Nombre SP : CLRHSU_NUM_SERIE_DTH 
* Propósito : Actualizacion del numero de serie de equipo, para 
              la validacion con el inventario para la tecnologia DTH
* Input:   PI_NRO_SOT     - Nro SOT
           PI_NRO_SERIE   - Nro Serie equipo
           PUNTO          - Nro de punto
           PI_ORDEN       - Nro de orden
           PI_TIPEQU      - Tipo de equipo
* Output:  PO_RESULTADO      - Codigo resultado
           PO_MSGERR         - Mensaje resultado
* Creado por : Wendy Tamayo
* Fec Creación : 26/02/2020
* Fec Actualización : --
****************************************************************
*/    

PROCEDURE CLRHSU_NUM_SERIE_DTH(PI_NRO_SOT   IN OPERACION.SOLOT.CODSOLOT%TYPE,
                               PI_NRO_SERIE IN OPERACION.SOLOTPTOEQU.NUMSERIE%TYPE,
                               PI_PUNTO     IN OPERACION.SOLOTPTOEQU.PUNTO%TYPE,
                               PI_ORDEN     IN OPERACION.SOLOTPTOEQU.ORDEN%TYPE,
                               PI_TIPEQU    IN OPERACION.SOLOTPTOEQU.TIPEQU%TYPE,
                               PO_RESULTADO OUT INTEGER,
                               PO_MSGERR    OUT VARCHAR2);
/*
 ****************************************************************'
* Nombre SP : CLRHSI_CIERRE_VALIDACION
* Propósito : Cierre de tareas y validacion de servicios LTE
* Input:   PI_NRO_SOT     -  Nro SOT
* Output:  PO_RESULTADO 	- Codigo resultado
           PO_MSGERR   		- Mensaje resultado
* Creado por : Cesar Rengifo
* Fec Creación : 26/02/2020
* Fec Actualización : --
****************************************************************
*/    

PROCEDURE CLRHSI_CIERRE_VALIDACION(PI_NRO_SOT   IN OPERACION.SOLOT.CODSOLOT%TYPE,
                                     PO_RESULTADO OUT INTEGER,
                                     PO_MSGERR    OUT VARCHAR2);  
                                     

                                     
/****************************************************************
  '* Nombre SP           :  CLRHSS_PROVISIONAR_LTE
  '* Proposito           :  EL SIGUIENTE SP REALIZA LA PROVISION DE LTE
  '* Inputs              :  PI_CODSOLOT - Codigo de la orden de trabajo
                            P_CO_ID - Codigo del contrato del cliente
  '* Output              :  PO_RESPUESTA - Respuesta de salida
                            PO_MENSAJE - Mensaje de salida
  '* Creado por          :  HITSS
  '* Fec Creacion        :  02/03/2020
  '****************************************************************/
 PROCEDURE CLRHSS_PROVISIONAR_LTE(P_CODSOLOT         IN OPERACION.SOLOT.CODSOLOT%TYPE,
                                  P_CO_ID            IN NUMBER,
                                  PO_RESPUESTA       OUT NUMBER,
                                  PO_MENSAJE         OUT VARCHAR2);                                                                  
 
 /*
****************************************************************'
* Nombre SP : CLRHSU_BAJA_DECO_LTE
* Propósito : Baja de Deco de alquiler -  LTE
* Input:   PI_IDAGENDA      - Id Agenda
           PI_DNI_TECNICO   - DNI del tecnico
           PI_NUMSERIE_DECO - Numero de serie Deco
           PI_NUMSERIE_TARJ - Numero tarjeta Deco
* Output:  PO_RESULTADO     - Codigo resultado
           PO_MSGERR        - Mensaje resultado
* Creado por : Wendy Tamayo
* Fec Creación :06/03/2020
* Fec Actualización : --
****************************************************************
*/

PROCEDURE CLRHSU_BAJA_DECO_LTE(PI_IDAGENDA      IN OPERACION.AGENDAMIENTO.IDAGENDA%TYPE,
                               PI_DNI_TECNICO   IN VARCHAR2,
                               PI_NUMSERIE_DECO IN operacion.tabequipo_material.numero_serie%TYPE,
                               PI_NUMSERIE_TARJ IN operacion.tabequipo_material.numero_serie%TYPE,
                               PO_RESULTADO     OUT INTEGER,
                               PO_MSGERR        OUT VARCHAR2);
                               
/*
 ****************************************************************'
* Nombre SP : CLRHSS_LISTA_AGENDA_CHESTADO
* Propósito : Lista de Agendas asociadas a una SOTs para la 
              su cambio de estado
* Input:   PI_NRO_SOT     -  Nro SOT
* Output:  PO_CURSOR      - Lista de Estados de Agendas
           PO_RESULTADO 	- Codigo resultado
           PO_MSGERR   		- Mensaje resultado
* Creado por : Cesar Rengifo
* Fec Creación : 09/03/2020
* Fec Actualización : --
****************************************************************
*/    

PROCEDURE CLRHSS_LISTA_AGENDA_CHESTADO (PI_NRO_SOT      IN OPERACION.SOLOT.CODSOLOT%TYPE,
                                        PO_CURSOR       OUT T_CURSOR,                
                                        PO_RESULTADO    OUT INTEGER,
                                        PO_MSGERR       OUT VARCHAR2);
										
										/*
 ****************************************************************'
* Nombre F : F_OBTENER_TECNICO
* Propósito : Muestra Nombre del Tecnico
* Input:   A_DNITECNICO   -  Nro DNI Tecnico
* Output:  LS_NOMBRE      - Nombre del Tecnico
* Creado por : Cesar Rengifo
* Fec Creación : 31/03/2020
* Fec Actualización : --
****************************************************************
*/                                        
FUNCTION F_OBTENER_TECNICO(a_dnitecnico in varchar2) return varchar2;  
							   
END;
/