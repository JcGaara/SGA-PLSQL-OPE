CREATE OR REPLACE PACKAGE OPERACION.pq_portabilidad_num_fija IS
  /******************************************************************************
    PROPOSITO:

    REVISIONES:
      Version  Fecha       Autor            Solicitado por      Descripcion
      -------  -----       -----            --------------      -----------
      1.0      2014-05-29  Mauro Zegarra    Alberto Miranda     Portabilidad Numerica
                           José Ruiz
      2.0      2014-08-10  José Ruiz        Alberto Miranda     Consulta previa Portabilidad Numerica
      3.0      2014-08-17  José Ruiz        Alberto Miranda     Flujo Credito Manual y Automatico
      4.0      2014-09-08  José Ruiz        Alberto Miranda     Flujo Telefonia Fija (Primarias, Analogicas)
      5.0      2014-09-17  José Ruiz        Alberto Miranda     Validacion Lineas Primarias Generar SEC
      6.0      2014-09-22  José Ruiz        Alberto Miranda     Actulizacion de Porta cuando es mas de 100 lineas
      7.0      2014-10-10  José Ruiz/
                           Freddy Gonzales  Alberto Miranda     Validar registro activo del cliente en el proceso de portabilidad.
      8.0      2014-11-20  Edwin Vasquez    Alberto Miranda     Mejoras Portabilidad CE - Validacion de estado donde se encuentra la SOT
                           Freddy Gonzales                      Mejoras Portabilidad CE - Validacion de numeros rechazados al generar SOT.
      9.0      2014-12-12  Freddy Gonzales  Alberto Miranda     Validar numero telefonico al generar la SOT.
     10.0      2015-03-12  Jose Ruiz        Alberto Miranda     Mejoras Portabilidad TF- Agregar servicio Analog Corporativo y Troncal SIP
     11.0      2016-08-16  Alfonso Muñante  Jessica Villena     Portabilidad de telefonia fija - PORTOUT.
     12.0      2016-11-03  Dorian Sucasaca  Alexander Carnero   Portabilidad Corporativa
     13.0      2017-08-08  Alejandro Milla  Richard Medina      Problemas la generación SOT de Portabilidad, por la dependencia con LDN
     14.0      2017-09-18  Alejandro Milla  Juan Cuya           Error al generar PORT OUT LINEA FIJA
  /* ****************************************************************************/
  FUNCTION f_captura_servicio(p_tipsrv tystipsrv.tipsrv%TYPE) RETURN NUMBER;

  FUNCTION f_validalongen_num(as_numero IN VARCHAR2) RETURN CHAR;

  FUNCTION f_validalong_num(as_numero IN VARCHAR2,
                            as_numslc vtatabslcfac.numslc%TYPE) RETURN CHAR;

  FUNCTION f_consulta_ws_sec RETURN VARCHAR2;

  FUNCTION f_portabmensaje(codigo sales.portabmsg.cod_msg%TYPE)
    RETURN VARCHAR2;

  PROCEDURE p_valida_num_fijo(as_numero    IN VARCHAR2,
                              as_documento IN VARCHAR2,
                              an_resultado OUT NUMBER,
                              av_mensaje   OUT VARCHAR2);

  FUNCTION f_razon_soc(as_numslc IN VARCHAR2) RETURN VARCHAR2;

  FUNCTION f_tipo_doccli(as_numslc IN VARCHAR2) RETURN CHAR;

  FUNCTION f_num_doccli(as_numslc IN VARCHAR2) RETURN VARCHAR2;

  PROCEDURE p_insert_sga(as_numproy    IN VARCHAR2,
                         an_idoperador IN NUMBER,
                         as_tram_num   IN VARCHAR2,
                         as_modalidad  IN VARCHAR2,
                         an_resultado  OUT NUMBER,
                         av_mensaje    OUT VARCHAR2);

  PROCEDURE p_update_sga(as_numproy           IN VARCHAR2,
                         as_tram_num          IN VARCHAR2,
                         an_numsec            IN NUMBER,
                         an_num_documento     IN NUMBER,
                         as_tipo_portabilidad IN VARCHAR2,
                         an_resultado         OUT NUMBER,
                         av_mensaje           OUT VARCHAR2);

  PROCEDURE p_envia_consulta_previa(p_numslc    vtatabslcfac.numslc%TYPE,
                                    p_numeros   VARCHAR2,
                                    p_cant_num  NUMBER,
                                    p_resultado OUT NUMBER,
                                    p_mensaje   OUT VARCHAR2,
                                    p_sec       OUT NUMBER);

  procedure enviar_consulta(p_resultado     out number,
                            p_mensaje       out varchar2,
                            p_sec           out number,
                            p_numslc        char,
                            p_tipdoc        char,
                            p_numdoc        char,
                            p_nombrecli     varchar2,
                            p_descriesgo    varchar2,
                            p_codigored     char,
                            p_tipoprod      char,
                            p_cantlineas    number,
                            p_mail          varchar2,
                            p_srv_sicact    char,
                            p_operador      varchar2,
                            p_modalidad     varchar2,
                            p_telefcontacto varchar2,
                            p_numeros       varchar2);

  FUNCTION get_srv_sisact(p_tipsrv     vtatabslcfac.tipsrv%TYPE,
                          p_idproducto producto.idproducto%TYPE)
    RETURN NUMBER;

  FUNCTION f_split(p_cadena VARCHAR2, p_separador VARCHAR2, p_pos NUMBER)
    RETURN VARCHAR2;

  PROCEDURE p_insert_numtel_reservatel(as_numproy vtatabslcfac.numslc%TYPE,
                                       as_numero  numtel.numero%TYPE);

  function esta_registrado_numtel(p_numero numtel.numero%type) return boolean;

  procedure update_numtel(p_numero    numtel.numero%type,
                          p_codnumtel out numtel.codnumtel%type);

  procedure insert_numtel(p_numero    numtel.numero%type,
                          p_codnumtel out numtel.codnumtel%type);

  function esta_registrado_reservatel(p_codnumtel reservatel.codnumtel%type)
    return boolean;

  procedure update_reservatel(p_codnumtel reservatel.codnumtel%type,
                              p_numslc    vtatabslcfac.numslc%type,
                              p_codcli    vtatabslcfac.codcli%type);

  procedure insert_reservatel(p_codnumtel reservatel.codnumtel%type,
                              p_numslc    vtatabslcfac.numslc%type,
                              p_codcli    vtatabslcfac.codcli%type);

  FUNCTION f_busca_numpto(as_numslc IN VARCHAR2) RETURN VARCHAR2;

  procedure p_elimina_detalle_sef(as_numslc        varchar2,
                                  p_num_rechazados number default null);

  PROCEDURE portabilidad(p_numslc    vtatabslcfac.numslc%TYPE,
                         p_msg_sot   OUT VARCHAR2,
                         p_msg_porta OUT VARCHAR2);

  FUNCTION es_credito_manual(p_numslc vtatabslcfac.numslc%TYPE)
    RETURN BOOLEAN;

  PROCEDURE credito_manual(p_numslc    vtatabslcfac.numslc%TYPE,
                           p_msg_sot   OUT VARCHAR2,
                           p_msg_porta OUT VARCHAR2);

  PROCEDURE credito_automatico(p_numslc    vtatabslcfac.numslc%TYPE,
                               p_msg_sot   OUT VARCHAR2,
                               p_msg_porta OUT VARCHAR2);

  function tiene_respuesta(p_numslc         vtatabslcfac.numslc%type,
                           p_num_rechazados number default null)
    return boolean;

  FUNCTION tiene_sec(p_numslc vtatabslcfac.numslc%TYPE) RETURN BOOLEAN;

  PROCEDURE crear_cxcpspchq_pendiente(p_numslc vtatabslcfac.numslc%TYPE);

  PROCEDURE update_cxcpspchq(p_numslc vtatabslcfac.numslc%TYPE);

  PROCEDURE credito_comun(p_numslc    vtatabslcfac.numslc%TYPE,
                          p_msg_sot   OUT VARCHAR2,
                          p_msg_porta OUT VARCHAR2);

  function verifica_rechazo_autorizados(p_numslc              vtatabslcfac.numslc%type,
                                        p_cant_num_rechazados out number)
    return number;

  function tiene_rechazos_autorizados(p_numslc         vtatabslcfac.numslc%type,
                                      p_num_rechazados out number)
    return boolean;

  function esta_registrado_usuario return boolean;

  function estan_todos_rechazados_auto(p_numslc              vtatabslcfac.numslc%type,
                                       p_num_rechazados_auto number)
    return boolean;

  function estan_todos_rechazados(p_numslc vtatabslcfac.numslc%type)
    return boolean;

  function tiene_numero_asignado(p_numslc    vtatabslcfac.numslc%type,
                                 p_msg_solot out varchar2,
                                 p_msg_porta out varchar2) return boolean;

  procedure reservar_numeros_con_rechazos(p_numslc vtatabslcfac.numslc%type);

  PROCEDURE reservar_numeros(p_numslc vtatabslcfac.numslc%TYPE);

  FUNCTION esta_aprobado(p_numslc vtatabslcfac.numslc%TYPE) RETURN BOOLEAN;

  FUNCTION esta_registrado(p_numslc vtatabslcfac.numslc%TYPE) RETURN BOOLEAN;
  PROCEDURE credito_comun_fija(p_numslc    vtatabslcfac.numslc%TYPE,
                               p_msg_sot   OUT VARCHAR2,
                               p_msg_porta OUT VARCHAR2);
  PROCEDURE portabilidad_fija(p_numslc    vtatabslcfac.numslc%TYPE,
                              p_msg_sot   OUT VARCHAR2,
                              p_msg_porta OUT VARCHAR2);

  PROCEDURE portabilidad_fija_contrato(p_numslc    vtatabslcfac.numslc%TYPE,
                                       p_msg_sot   OUT VARCHAR2,
                                       p_msg_porta OUT VARCHAR2);

  FUNCTION es_fija_o_especial(p_tipsrv vtatabslcfac.tipsrv%TYPE)
    RETURN BOOLEAN;
  FUNCTION tiene_rechazo(p_numslc vtatabslcfac.numslc%TYPE) RETURN BOOLEAN;

  PROCEDURE p_actualiza_codigo_mensaje(p_numslc    vtatabslcfac.numslc%TYPE,
                                       p_resultado OUT NUMBER,
                                       p_mensaje   OUT VARCHAR2);

  FUNCTION obtiene_cant_lineas_det(p_numslc vtatabslcfac.numslc%TYPE)
    RETURN NUMBER;

  -- 7.0
  FUNCTION f_valida_num_telef_contacto(p_numslc vtatabslcfac.numslc%TYPE)
    RETURN VARCHAR2;
  FUNCTION get_servicio_especial(p_abreviacion opedd.abreviacion%TYPE)
    return varchar2;

  FUNCTION get_servicio_producto(p_numslc vtatabslcfac.numslc%TYPE,
                                 p_tipsrv vtatabslcfac.tipsrv%TYPE)
    return number;
  FUNCTION get_codigo_departamento(p_numslc vtatabslcfac.numslc%TYPE,
                                   p_tipsrv vtatabslcfac.tipsrv%TYPE)
    return number;

  procedure validar_trama_numeros(as_tram_num varchar2,
                                  p_msj       out varchar2,
                                  p_resultado out number);

  PROCEDURE SIACSS_DATOS_SRV_INST_CLIENTE(P_NUM_DOC           IN VARCHAR2,
                                          P_TIPO_NUM_DOC      IN VARCHAR2,
                                          P_LINEA             IN VARCHAR2,
                                          P_CUR_DATOS_SALIDA  OUT SYS_REFCURSOR,
                                          P_CODIGO_RESPUESTA  OUT NUMBER,
                                          P_MENSAJE_RESPUESTA OUT VARCHAR2);

  Procedure SP_MOD_SERV_SIN_REQUEST (P_CO_ID     IN  INTEGER,
                                     P_SNCODE    IN  INTEGER,
                                     P_ACCION    IN  VARCHAR2,
                                     P_RESULTADO OUT INTEGER,
                                     P_MSG_ERR   OUT VARCHAR2);

  -- Ini 12.0
  PROCEDURE SGASS_CONS_CANTCP
  /****************************************************************
  * Nombre SP : SGASS_CONS_CANTCP
  * Propósito :
  * Input     : P_NUMSEC: NUMERO DE SEC
  * Output    : P_RESULTADO: 0= OK <> 0= ERROR
                P_MENSAJE: Mensaje de Operacion
  * Creado por : Dorian Sucasaca
  * Fec Creación : 03/11/2016
  * Fec Actualización : --/--/----
  '****************************************************************/
                              ( P_NUMSEC    IN  INTEGER,
                                P_RESULTADO OUT INTEGER,
                                P_MENSAJE   OUT VARCHAR2);

  PROCEDURE SGASS_ACT_INFO_PORT
  /****************************************************************
  * Nombre SP : SGASS_ACT_INFO_PORT
  * Propósito :
  * Input     : K_NUMSEC: NUMERO DE SEC
  * Output    : K_RESULTADO: 0= OK <> 0= ERROR
                K_MENSAJE: Mensaje de Operacion
  * Creado por : Dorian Sucasaca
  * Fec Creación : 03/11/2016
  * Fec Actualización : --/--/----
  '****************************************************************/
                                ( K_NUMSEC    IN  INTEGER,
                                  K_RESULTADO OUT INTEGER,
                                  K_MENSAJE   OUT VARCHAR2);


  PROCEDURE SGASS_ANULA_SEC_PORT
  /****************************************************************
  * Nombre SP : SGASS_ANULA_SEC_PORT
  * Propósito : Anula la SEC de portabilidad.
  * Input     : P_NUMSEC: NUMERO DE SEC
  * Output    : P_RESULTADO: 0= OK <> 0= ERROR
                P_MENSAJE: Mensaje de Operacion
  * Creado por : Dorian Sucasaca
  * Fec Creación : 03/11/2016
  * Fec Actualización : --/--/----
  '****************************************************************/
                                 ( P_NUMSEC    IN  INTEGER,
                                   P_RESULTADO OUT INTEGER,
                                   P_MENSAJE   OUT VARCHAR2);

  PROCEDURE SGASS_CP_WS
  /****************************************************************
  * Nombre SP : SGASS_CP_WS
  * Propósito : Consulta al servicio EnvioPortaws
  * Input     : P_XML: XML de Consulta Previa
                P_URL: URL de Servicio
  * Output    : P_RESPUESTA: Respuesta del Servicio
                P_MENSAJE: Mensaje de Servicio
  * Creado por : Dorian Sucasaca
  * Fec Creación : 03/11/2016
  * Fec Actualización : --/--/----
  '****************************************************************/
                        ( P_XML       CLOB,
                          P_URL       VARCHAR2,
                          P_RESULTADO OUT INTEGER,
                          P_MENSAJE   OUT VARCHAR2);

  FUNCTION SGASS_OBTENER_TAG
 /****************************************************************
  * Nombre SP : SGASS_OBTENER_TAG
  * Propósito :
  * Input     : AV_TAG: Campo de Respuesta
                AV_TRAMA: Trama de Respuesta
  * Output    : Valor de Respuesta
  * Creado por : Dorian Sucasaca
  * Fec Creación : 03/11/2016
  * Fec Actualización : --/--/----
  '****************************************************************/
                                (AV_TAG VARCHAR2, AV_TRAMA CLOB) RETURN VARCHAR2;

  PROCEDURE SGASS_CONSULTAPREVIA
  /****************************************************************
  * Nombre SP : SGASS_CONSULTAPREVIA
  * Propósito :
  * Input     : P_NUMSEC: NUMERO DE SEC
                P_NUMERO: NUMERO DE TELEFONA A CP
  * Output    : P_RESULTADO: 0= OK <> 0= ERROR
                P_MENSAJE: Mensaje de Operacion
  * Creado por : Dorian Sucasaca
  * Fec Creación : 03/11/2016
  * Fec Actualización : --/--/----
  '****************************************************************/
                                 ( P_NUMSEC    IN  INTEGER,
                                   P_NUMERO    IN  VARCHAR2,
                                   P_RESULTADO OUT INTEGER,
                                   P_MENSAJE   OUT VARCHAR2);

  FUNCTION SGASS_RESPUESTA_PVU
 /****************************************************************
  * Nombre SP : SGASS_RESPUESTA_PVU
  * Propósito :
  * Input     : PK_SOLPORTA: ID numero
  * Output    : MENSAJE DE RESPUESTA.
  * Creado por : Dorian Sucasaca
  * Fec Creación : 16/12/2016
  * Fec Actualización : --/--/----
  '****************************************************************/
                                (PK_SOLPORTA IN NUMBER) RETURN VARCHAR2;
  -- Fin 12.0
  -- Ini 14.0
    FUNCTION F_COD_ID_X_NUM_TELEFONO
/****************************************************************
  * Nombre SP : F_COD_ID_X_NUM_TELEFONO
  * Propósito :
  * Input     : P_NUM_TELEFONO: numero telefonico
  * Output    : co_id, si no encuentra: 0
  * Creado por : Alejandro Milla
  * Fec Creación : 18/09/2017
  * Fec Actualización : --/--/----
  '****************************************************************/
                                (P_NUM_TELEFONO VARCHAR2) RETURN NUMBER;
  -- Fin 14.0

END;
/
