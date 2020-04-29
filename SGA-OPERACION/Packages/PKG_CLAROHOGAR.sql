create or replace package operacion.PKG_CLAROHOGAR is

  lv_registra_usuario_cab       constant varchar2(20) := 'registra_usuario_cab';
  lv_registra_usuario_det       constant varchar2(20) := 'registra_usuario_det';
  pn_idenvio                    number;

/*
****************************************************************
* Nombre SP : CLRHSS_DIRECCION_INSTAL
* Propósito : El SP permite traer las direccion de instalacion relacionado
               a su contrato de acuerdo a las diferentes sucursales que tenga
               el cliente
* Input :  PI_NRO_DOCUMENTO  - Numero de documento de identidad del cliente
           PI_TIPO_DOCUMENTO - Tipo de documento asociado al cliente.
* Output : PO_CURSOR    - Listado de direcciones
           PO_RESULTADO - Codigo resultado
           PO_MSGERR    - Mensaje resultado
* Creado por : Obed Ortiz Navarrete
* Fec Creación : 14/01/2019
* Fec Actualización : --
****************************************************************
*/

 PROCEDURE CLRHSS_DIRECCION_INSTAL( PI_NRO_DOCUMENTO  IN  VARCHAR2,
                                      PI_TIPO_DOCUMENTO  IN  VARCHAR2,
                                      PO_CURSOR   OUT SYS_REFCURSOR,
                                      PO_RESULTADO    OUT INTEGER,
                                      PO_MSGERR       OUT VARCHAR2);

/*
****************************************************************'
* Nombre SP : CLRHSS_CONTRATA
* Propósito : El SP permite traer el nombre de las contratas a partir de los ID
* Input :  PI_ID_CONTRATA        - Id de la contrata
* Output : PO_NOM_CONTRATA       - Nombre asignado a la contrata
           PO_RESULTADO          - Codigo resultado
           PO_MSGERR             - Mensaje resultado
* Creado por : Obed Ortiz Navarrete
* Fec Creación : 21/01/2019
* Fec Actualización : --
****************************************************************
*/

 PROCEDURE CLRHSS_CONTRATA( PI_ID_CONTRATA  IN  INTEGER,
                                      PO_NOM_CONTRATA       OUT VARCHAR2,
                                      PO_RESULTADO          OUT INTEGER,
                                      PO_MSGERR             OUT VARCHAR2);

/*
****************************************************************
* Nombre SP : CLRHSS_TIPO_SUBTIPO_OT
* Propósito : El SP permite traer el nombre del tipo y subtipo de Orden
* Input :  PI_COD_TIPO_ORDEN       - Codigo concatenado del tipo de Orden
           PI_COD_SUBTIPO_ORDEN    - Codigo concatenado del subtipo de Orden
* Output : PO_CURSOR_TIP_ORDEN     - Listado de nombres del tipo de Orden
           PO_CURSOR_SUBTIP_ORDEN  - listado de nombres del subtipo de Orden
           PO_RESULTADO            - Codigo resultado
           PO_MSGERR               - Mensaje resultado
* Creado por : Obed Ortiz Navarrete
* Fec Creación : 21/01/2019
* Fec Actualización : --
****************************************************************
*/

 PROCEDURE CLRHSS_TIPO_SUBTIPO_OT( PI_COD_TIPO_ORDEN     IN  VARCHAR2,
                                      PI_COD_SUBTIPO_ORDEN  IN  VARCHAR2,
                                      PO_CURSOR_TIP_ORDEN    OUT SYS_REFCURSOR,
                                      PO_CURSOR_SUBTIP_ORDEN OUT SYS_REFCURSOR,
                                      PO_RESULTADO          OUT INTEGER,
                                      PO_MSGERR             OUT VARCHAR2);


/*
****************************************************************
* Nombre SP : CLRHSS_VISITA_CLIENTE
* Propósito : El SP permite traer las visitas pendientes del cliente generadas
              en el SGA.
* Input  :  PI_CUSTOMER_ID        - CUSTOMER_ID
* Output :  PO_CURSOR_LIS_ORDEN   - Cursor del listado de Ordenes pendientes
            PO_RESULTADO          - Codigo resultado
            PO_MSGERR             - Mensaje resultado
* Creado por : Obed Ortiz Navarrete
* Fec Creación : 04/02/2019
* Fec Actualización : --
****************************************************************
*/

 PROCEDURE CLRHSS_VISITA_CLIENTE(
                                      PI_CUSTOMER_ID        IN  VARCHAR2,
                                      PO_CURSOR_LIS_ORDEN   OUT SYS_REFCURSOR,
                                      PO_CURSOR_FRANJA_HO   OUT SYS_REFCURSOR,
                                      PO_RESULTADO          OUT INTEGER,
                                      PO_MSGERR             OUT VARCHAR2);

 /*
****************************************************************
* Nombre SP : CLRHSS_DATOS_CAPACIDAD
* Propósito : El SP permite traer las visitas pendientes del cliente generadas
              en el SGA.
* Input  :  PI_ID_AGENDA          - Id agenda de la orden
* Output :  PO_CURSOR             - Cursor del listado los datos de capacidad
            PO_RESULTADO          - Codigo resultado
            PO_MSGERR             - Mensaje resultado
* Creado por : Obed Ortiz Navarrete
* Fec Creación : 18/02/2019
* Fec Actualización : --
****************************************************************
*/

 PROCEDURE CLRHSS_DATOS_CAPACIDAD(
                                      PI_ID_AGENDA          IN  VARCHAR2,
                                      PO_CURSOR             OUT SYS_REFCURSOR,
                                      PO_RESULTADO          OUT INTEGER,
                                      PO_MSGERR             OUT VARCHAR2);


/*
****************************************************************
* Nombre SP : CLRHSI_REAGENDAMIENTO
* Propósito : El SP reagendar las visitas tecnicas asignadas al cliente
* Input  :  PI_ID_AGENDA          - Id agenda de la orden
            PI_FECHA_AGENDA       - Fecha de nueva agenda
            PI_FRANJA             - Nueva franja horaria
            PI_ID_BUCKET          - Id de contrata seleccionada
* Output :  PO_RESULTADO          - Codigo resultado
            PO_MSGERR             - Mensaje resultado
            PO_HORA_INI           - Hora inicio de la nueva agenda
            PO_HORA_FIN           - Hora final de la nueva agenda
* Creado por : Obed Ortiz Navarrete
* Fec Creación : 18/02/2019
* Fec Actualización : --
****************************************************************
*/

 PROCEDURE CLRHSI_REAGENDAMIENTO(
                                      PI_ID_AGENDA          IN  VARCHAR2,
                                      PI_FECHA_AGENDA       IN  DATE,
                                      PI_FRANJA             IN  VARCHAR2,
                                      PI_ID_BUCKET          IN  VARCHAR2,
                                      PO_RESULTADO          OUT INTEGER,
                                      PO_MSGERR             OUT VARCHAR2,
                                      PO_HORA_INI           OUT VARCHAR2,
                                      PO_HORA_FIN           OUT VARCHAR2);

/*
****************************************************************'
* Nombre SP : CLRHSI_CANCELA_ORDEN
* Propósito : El SP cancela las visitas tecnicas asignadas al cliente
* Input  :  PI_ID_AGENDA          - Id agenda de la orden
            PI_ID_MOTIVO          - Id motivo de cancelacion
* Output :  PO_RESULTADO          - Codigo resultado
            PO_MSGERR             - Mensaje resultado
* Creado por : Obed Ortiz Navarrete
* Fec Creación : 06/03/2019
* Fec Actualización : --
****************************************************************
*/


PROCEDURE CLRHSI_CANCELA_ORDEN(
                                      PI_ID_AGENDA          IN  NUMBER,
                                      PI_ID_MOTIVO          IN  NUMBER,
                                      PO_RESULTADO          OUT INTEGER,
                                      PO_MSGERR             OUT VARCHAR2);

 /*
****************************************************************'
* Nombre SP : CLRHSS_MOTIVO_CANCELA
* Propósito : El SP permite traer los motivos de cancelacion para las ordenes agendadas
* Input  :
* Output :  PO_CURSOR             - Cursor del listado los datos de capacidad
            PO_RESULTADO          - Codigo resultado
            PO_MSGERR             - Mensaje resultado
* Creado por : Obed Ortiz Navarrete
* Fec Creación : 18/02/2019
* Fec Actualización : --
****************************************************************
*/

 PROCEDURE CLRHSS_MOTIVO_CANCELA(
                                      PO_CURSOR             OUT SYS_REFCURSOR,
                                      PO_RESULTADO          OUT INTEGER,
                                      PO_MSGERR             OUT VARCHAR2);

 /*
****************************************************************'
* Nombre SP : CLRHSI_CAMBIO_AGENDA
* Propósito : El SP permite cambio de estados para la agenda.
* Input  :  PI_idagenda           - Id Agenda
            PI_estagenda          - Estado de la nueva agenda
            PI_estagenda_old      - Estados de la antigua agenda
            PI_observacion        - Observacion
            PI_mot_solucion       - Motivo Solucion
            PI_fecha              - Fecha de cambio
            PI_cadena_mots        - Varios motivos de solucion
            PI_estado_adc         - Estado ADC de la agenda
            PI_ticket_remedy      - Ticket Remedi
* Output :
* Creado por : Obed Ortiz Navarrete
* Fec Creación : 18/03/2019
* Fec Actualización : --
****************************************************************
*/
procedure CLRHSI_CAMBIO_AGENDA(PI_idagenda      in number,
                                   PI_estagenda     in number,
                                   PI_estagenda_old in number default null,
                                   PI_observacion   in varchar2 default null,
                                   PI_mot_solucion  in number default null,
                                   PI_fecha         in date default sysdate,
                                   PI_cadena_mots   in varchar2 default null,
                                   PI_estado_adc   in number default null,
                                   PI_ticket_remedy in varchar2 default null);

 /*
****************************************************************'
* Nombre SP : CLRHSI_CANCELA_ORDEN
* Propósito : El SP permite cambio de estados para la agenda.
* Input  :  PI_idagenda           - Id Agenda
            PI_estagenda          - Estado de la nueva agenda
            PI_tipo               - Tipo de agenda
            PI_observacion        - Observacion
            PI_mot_solucion       - Motivo Solucion
            PI_fecha              - Fecha de cambio
* Output :
* Creado por : Obed Ortiz Navarrete
* Fec Creación : 18/03/2019
* Fec Actualización : --
****************************************************************
*/

procedure CLRHSI_CANCELA_ORDEN_SGA (PI_idagenda     in number,
                                    PI_estagenda    in number,
                                    PI_tipo         in number,
                                    PI_observacion  in varchar2,
                                    PI_mot_solucion in number default null,
                                    PI_fecha        in date default sysdate);

 /*
****************************************************************'
* Nombre SP : CLRHSI_CANCELA_AGENDA
* Propósito : El SP permite cambio de estados para la agenda.
* Input  :  PI_codsolot           - Codigo se solot.
            PI_idagenda           - Id Agenda
            PI_estagenda          - Estado de la nueva agenda
            PI_observacion        - Observacion
* Output :  PO_iderror            - Id Error del SP
            PO_mensajeerror       - Mensaje Error del SP
* Creado por : Obed Ortiz Navarrete
* Fec Creación : 18/03/2019
* Fec Actualización : --
****************************************************************
*/

PROCEDURE CLRHSI_CANCELA_AGENDA(PI_codsolot     IN operacion.agendamiento.codsolot%TYPE,
                             PI_idagenda     IN operacion.agendamiento.idagenda%TYPE,
                             PI_estagenda    IN NUMBER,
                             PI_observacion  IN operacion.cambio_estado_ot_adc.motivo%TYPE,
                             PO_iderror      OUT NUMERIC,
                             PO_mensajeerror OUT VARCHAR2);


/*
****************************************************************'
* Nombre SP : CLRHSI_REAGENDA_TOA
* Propósito : El SP reagendar las visitas tecnicas asignadas al cliente
* Input  :  PI_ID_AGENDA          - Id agenda de la orden
            PI_FECHA_AGENDA       - Fecha de nueva agenda
            PI_FRANJA             - Nueva franja horaria
* Output :  PO_RESULTADO          - Codigo resultado
            PO_MSGERR             - Mensaje resultado
* Creado por : Obed Ortiz Navarrete
* Fec Creación : 18/02/2019
* Fec Actualización : --
****************************************************************
*/

 PROCEDURE CLRHSI_REAGENDA_TOA(
                                      PI_ID_AGENDA          IN  VARCHAR2,
                                      PI_FECHA_AGENDA       IN  DATE,
                                      PI_FRANJA             IN  VARCHAR2,
                                      PO_RESULTADO          OUT INTEGER,
                                      PO_MSGERR             OUT VARCHAR2);

/*
****************************************************************'
* Nombre SP : CLRHSI_CANCELA_TOA
* Propósito : El SP cancela las visitas tecnicas asignadas al cliente
* Input  :  PI_ID_AGENDA          - Id agenda de la orden
            PI_ID_MOTIVO          - Id motivo de cancelacion
* Output :  PO_RESULTADO          - Codigo resultado
            PO_MSGERR             - Mensaje resultado
* Creado por : Obed Ortiz Navarrete
* Fec Creación : 06/03/2019
* Fec Actualización : --
****************************************************************
*/

 PROCEDURE CLRHSI_CANCELA_TOA(
                                      PI_ID_AGENDA          IN  NUMBER,
                                      PI_ID_MOTIVO          IN  NUMBER,
                                      PO_RESULTADO          OUT INTEGER,
                                      PO_MSGERR             OUT VARCHAR2);

 /*
****************************************************************'
* Nombre SP : CLRHSS_SUBSIDIARYDET_DTH
* Propósito : El obtiene la sot de un producto dth postpago bajo el contrato
* Input  :  PI_CODSOLOT           - Codigo de SOT
* Output :  PO_CODIGO_SALIDA      - Codigo resultado
            PO_MENSAJE_SALIDA     - Mensaje resultado
            PO_CURSOR_SUCURSALES  - Cursor del listado de direccion de instalaccion
* Creado por : Jefferson Ore
* Fec Creación : 20/06/2019
* Fec Actualización : --
****************************************************************
*/
PROCEDURE CLRHSS_SUBSIDIARYDET_DTH (PI_CODSOLOT          IN  NUMBER,
                                     PO_CODIGO_SALIDA     OUT INTEGER,
                                     PO_MENSAJE_SALIDA    OUT VARCHAR2,
                                     PO_CURSOR_SUCURSALES OUT SYS_REFCURSOR);

 /*
****************************************************************'
* Nombre SP : CLRHSS_TRMODELO
* Propósito : El SP permite obtener el grupo, estado y la banda de un modelo CM
* Input :  PI_TRV_MODELO   - Modelo del CM
* Output : PO_TRV_GRUPO    - Grupo de modelos de CM
           PO_TRV_ESTADO   - Codigo resultado
           PO_TRV_BANDA    - Banda
           PO_RESULTADO    - Codigo resultado
           PO_MSGERR       - Mensaje resultado
* Creado por : Hitss
* Fec Creación : 25/07/2019
* Fec Actualización : --
****************************************************************
*/

 PROCEDURE CLRHSS_TRMODELO(PI_TRV_MODELO IN VARCHAR2,
                           PO_TRV_GRUPO  OUT VARCHAR2,
                           PO_TRV_ESTADO OUT VARCHAR2,
                           PO_TRV_BANDA  OUT VARCHAR2,
                           PO_RESULTADO  OUT INTEGER,
                           PO_MSGERR     OUT VARCHAR2);
/*
****************************************************************'
* Nombre SP : SP_REGISTRAR_NOCLIENTE
* Propósito : El SP permite enviar el JSON con los datos del usuario al servicio de APP Claro Hogar.
* Input :  a_idtareawf   - Id de la Tarea del Workflow
           a_idwf        - Id del WorkFlow
           a_tarea       - Tarea
           a_tareadef    - Definición de la tarea
* Output : --
* Creado por : Romario Medina
* Fec Creación : 11/09/2019
* Fec Actualización : --
****************************************************************
*/

 PROCEDURE SP_REGISTRAR_NOCLIENTE(a_idtareawf in number default null,
                                  a_idwf      in number,
                                  a_tarea     in number default null,
                                  a_tareadef  in number default null);

 PROCEDURE P_REG_XML(a_xml CLOB,
                     a_campo varchar2,
                     a_query varchar2,
                     a_tipo in number default null,
                     a_xml_out in out CLOB,
                     a_par1 in varchar2 default null,
                     a_par2 in varchar2 default null);

 FUNCTION F_CLOB_REPLACE (p_clob IN CLOB,
                          p_what IN VARCHAR2,
                          p_with IN VARCHAR2) RETURN CLOB;

 PROCEDURE P_CALL_WEBSERVICE(ac_payload       in CLOB,
                             ac_target_url    in varchar2,
                             v_metodo         in varchar2,
                             lc_soap_response out CLOB,
                             v_output         out CLOB,
                             status           out number,
                             error            out varchar2);

 FUNCTION F_OBTENER_TAG(av_tag VARCHAR2,
                        av_trama CLOB) RETURN VARCHAR2;

END;
/