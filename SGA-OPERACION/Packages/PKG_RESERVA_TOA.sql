CREATE OR REPLACE PACKAGE OPERACION.PKG_RESERVA_TOA IS
  /****************************************************************
  '* Nombre Package : OPERACION.PKG_RESERVA_TOA
  '* Propósito : FUNCIONALIDAD PARA EFECTUAR LAS RESERVAS EN TOA
  '* Input : --
  '* Output : --
  '* Creado por : Equipo de proyecto TOA
  '* Féc. Creación : 18/09/2018
  '* Féc. Actualización : --
     Ver        Date        Author              Solicitado por       Descripcion
     ---------  ----------  ------------------- ----------------   ------------------------------------
  '****************************************************************/
  CV_DESC_TIEMPO_RESERVA   CONSTANT VARCHAR(30) := 'PARAMETRO TIEMPO MAX RESERVA';
  CV_ABRV_TIEMPO_RESERVA   CONSTANT VARCHAR(30) := 'PAR_TIEMPO_RES';
  CN_ABRV_ESTADO_RESERVADO CONSTANT NUMBER := 1;

  /**************************************************
  '* Nombre SP : SGASI_HIS_RESER_TOA
  '* Propósito : Registrar las ordenes reservadas en TOA.
  '* Input: <pi_nro_orden>           - Nro Orden
  '* Input: <pi_id_consulta>         - ID Consulta
  '* Input: <pi_franja>              - Franja Horaria
  '* Input: <pi_dia_reserva>         - Dia de reserva
  '* Input: <pi_id_bucket>           - Id Bucket
  '* Input: <pi_cod_zona>            - ID Zona
  '* Input: <pi_cod_plano>           - ID Plano o Ubigeo
  '* Input: <pi_tipo_orden>          - Tipo de orden
  '* Input: <pi_sub_tipo_orden>      - Sub tipo de orden
  '* Output: <po_msj_result>         - mensaje de respuesta
  '* Output: <po_cod_result>         - codigo de respuesta
  '* Creado por : Equipo de proyecto Equipo de TOA
  '* Fec Creación : 18/09/2018
  '* Fec Actualización : -
  *********************************************/
  procedure SGASI_HIS_RESER_TOA(pi_nro_orden      VARCHAR2,
                                pi_id_consulta    NUMBER,
                                pi_franja         VARCHAR2,
                                pi_dia_reserva    date,
                                pi_id_bucket      VARCHAR2,
                                pi_cod_zona       VARCHAR2,
                                pi_cod_plano      VARCHAR2,
                                pi_tipo_orden     VARCHAR2,
                                pi_sub_tipo_orden VARCHAR2,
                                po_cod_result     OUT NUMBER,
                                po_msj_result     OUT VARCHAR2,
                                po_nro_orden      OUT VARCHAR2);

  /**************************************************
  '* Nombre SP : SGASU_UD_RESER_TOA
  '* Propósito : Actualizar el historial de reservas TOA.
  '* Input: <pi_nro_orden>           - Nro Orden
  '* Input: <pi_value>               - Valor a modificar
  '* Input: <pi_tipo_transaccion>    - Tipo de transaccion
  '* Output: <po_msj_result>         - mensaje de respuesta
  '* Output: <po_cod_result>         - codigo de respuesta
  '* Creado por : Equipo de proyecto Equipo de TOA
  '* Fec Creación : 18/09/2018
  '* Fec Actualización : -
  *********************************************/
  procedure SGASU_UD_RESER_TOA(pi_nro_orden        VARCHAR2,
                               pi_value            VARCHAR2,
                               pi_tipo_transaccion NUMBER,
                               po_cod_result       OUT NUMBER,
                               po_msj_result       OUT VARCHAR2);

  /**************************************************
  '* Nombre SP : SGASS_GET_FLAG_VAL
  '* Propósito : Validar el flag de reserva para TOA.
  '* Input: <pi_tiptra>              - Codigo tipo trabajo
  '* Input: <pi_tipsrv>              - Codigo tipo servicio
  '* Output: <po_flag_result>        - Flag de resultado para reservas
  '* Output: <po_msj_result>         - mensaje de respuesta
  '* Output: <po_cod_result>         - codigo de respuesta
  '* Creado por : Equipo de proyecto Equipo de TOA
  '* Fec Creación : 21/09/2018
  '* Fec Actualización : -
  *********************************************/
  procedure SGASS_GET_FLAG_VAL(pi_tiptra      IN operacion.matriz_tystipsrv_tiptra_adc.tiptra%TYPE,
                               pi_tipsrv      IN operacion.matriz_tystipsrv_tiptra_adc.tipsrv%TYPE,
                               po_flag_result OUT operacion.matriz_tystipsrv_tiptra_adc.FLAG_RESERVA%TYPE,
                               po_cod_result  OUT NUMBER,
                               po_msj_result  OUT VARCHAR2);

  /**************************************************
  '* Nombre SP : SGASS_FLAG_VAL_X_AGEN
  '* Propósito : Validar el flag de reserva para TOA con el id de agenda.
  '* Input: <pi_idagenda>              - Id de agenda
  '* Output: <po_cod_result>           - codigo de respuesta
  '* Creado por : Equipo de proyecto Equipo de TOA
  '* Fec Creación : 26/09/2018
  '* Fec Actualización : -
  *********************************************/
  procedure SGASS_FLAG_VAL_X_AGEN(pi_idagenda   IN agendamiento.idagenda%TYPE,
                                  po_cod_result OUT NUMBER);

  procedure SGASS_RESERVAS_A_CANC(PO_CURSOR     OUT sys_refcursor,
                                  po_cod_result OUT NUMBER,
                                  po_msj_result OUT VARCHAR2);

/**************************************************
  '* Nombre SP : SGASS_GET_RESERVA
  '* Propósito : Validar si para una sec venta existe una reserva activa
  '* Input: <ps_numsec>              - numsero de sec venta
  '* Input: <pi_valor>               - valor estado
  '* Output: <po_cod_result>         - codigo de respuesta
   '* Output: <po_msj_result>        - codigo de respuesta
  '* Output: <ps_nro_Reserva>         -numero de reserva toa
   '* Creado por : iniciativa 435
  '* Fec Creación : 26/09/2018
  '* Fec Actualización : -
  *********************************************/                                 
 procedure SGASS_GET_RESERVA  (ps_numsec      IN VARCHAR2,
                               pi_valor       IN NUMBER,
                               po_cod_result  OUT NUMBER,
                               po_msj_result  OUT VARCHAR2,
                               ps_nro_reserva OUT VARCHAR2) ;

FUNCTION f_obtener_tag_ipc(av_tag VARCHAR2, av_trama CLOB) RETURN VARCHAR2;
  
  /**************************************************
  '* Nombre SP : SGASS_ENV_DUP_AGE
  '* Propósito : Controlar desalineaciones en Reserva de Agendamiento.
  '* Output: <PO_CURSOR_CAB>        - Cursor que envia cantidad de desalineaciones
  '* Output: <PO_CURSOR_DET>        - Cursor que envia detalle de desalineaciones
  '* Output: <PO_CODIGO_ERROR>         - codigo de respuesta
  '* Output: <PO_DESC_ERROR>         - mensaje de respuesta
  '* Creado por : Equipo de Fallas y Urgencias
  '* Fec Creación : 11/03/2020
  '* Fec Actualización : -
  *********************************************/
                               
 PROCEDURE SGASS_ENV_DUP_AGE(PO_CURSOR_CAB OUT SYS_REFCURSOR,
                             PO_CURSOR_DET OUT SYS_REFCURSOR,
                             PO_CODIGO_ERROR OUT NUMBER,
                             PO_DESC_ERROR OUT VARCHAR2);


END PKG_RESERVA_TOA;
/

