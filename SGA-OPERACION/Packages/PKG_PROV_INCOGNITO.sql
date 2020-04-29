CREATE OR REPLACE PACKAGE OPERACION.PKG_PROV_INCOGNITO IS
  /****************************************************************************************
     REVISIONES:
     Version    Fecha        Autor           Solicitado por          Descripcion
     --------   ------       -------         ---------------         ------------
  1.0        23/05/2019   Steve Panduro                           Provision INCOGNITO
  1.1        23/06/2019  Freddy Dick                              Provision INCOGNITO
                         Salazar Valverde.
  1.2        18/09/2019  FTTH/HFC                                 Provision Incognito
  1.3        30/09/2019  FTTH
  1.4        30/09/2019  MASIVO HFC
  1.5        03/10/2019  Janpierre Benito
  1.6        18/10/2019  Janpierre Benito
  1.7        22/11/2019  Freddy Salazar
  1.8        27/02/2020  Steve Panduro                            OTT
  1.9       03/04/2020  Steve Panduro                            MEJORA OTT
     /****************************************************************************************/

  v_nombre_package constant varchar2(40) := 'OPERACION.PKG_PROV_INCOGNITO';

  n_intentos_token constant number := 3;
  v_DURACION_TOKEN constant constante.CONSTANTE%type := 'DURACION_TOKEN';
  v_authorization constant varchar2(40) := 'authorization';
  v_token_0       constant varchar2(10) := '0';
  v_token_neg_1       constant varchar2(10) := '-1';
  v_token_neg_2       constant varchar2(10) := '-2';

  v_nombre_sp_ActivarInternet            constant varchar2(40) := 'SGASS_ACTIVAR_INTERNET';
  v_nombre_sp_ActivarInternetAdi         constant varchar2(40) := 'SGASS_ACTIVAR_INTERNET_ADIC';
  v_nombre_sp_ActivarTelefonia           constant varchar2(40) := 'SGASS_ACTIVAR_TELEFONIA';
  v_nombre_sp_ActivarTv                  constant varchar2(40) := 'SGASS_ACTIVAR_TV';
  v_nombre_sp_ActivarTvAdic              constant varchar2(40) := 'SGASS_ACTIVAR_TV_ADIC';
  v_nombre_sp_InitReboot                 constant varchar2(40) := 'SGASS_INIT_REBOOT';
  v_nombre_sp_RefreshSTB                 constant varchar2(40) := 'SGASS_REFRESH_STB';
  v_nombre_sp_Suspension                 constant varchar2(40) := 'SGASS_SUSPENSION';
  v_nombre_sp_Reconexion                 constant varchar2(40) := 'SGASS_RECONEXION';
  v_nombre_sp_Desactivacion              constant varchar2(40) := 'SGASS_DESACTIVACION';
  v_nombre_sp_CrearCliente               constant varchar2(40) := 'SGASS_CREAR_CLIENTE';
  v_nombre_sp_ObtenerCliente             constant varchar2(40) := 'SGASS_OBTENER_CLIENTE';
  v_nombre_sp_EliminarCliente            constant varchar2(40) := 'SGASS_ELIMINAR_CLIENTE';
  v_nombre_sp_CambioPlan                 constant varchar2(40) := 'SGASS_CAMBIO_PLAN';
  v_nombre_sp_CambioEquipoTlf            constant varchar2(40) := 'SGASS_CAMBIO_EQUIPO_TELEFONIA';
  v_nombre_sp_CambioEquipoInt            constant varchar2(40) := 'SGASS_CAMBIO_EQUIPO_INTERNET';
  v_nombre_sp_CambioEquipoTv             constant varchar2(40) := 'SGASS_CAMBIO_EQUIPO_TV';
  v_nombre_sp_CambioAtributo             constant varchar2(40) := 'SGASS_CAMBIO_ATRIBUTO';
  v_nombre_sp_Autenticacion              constant varchar2(40) := 'SGASS_AUTENTICACION';
  v_nombre_sp_CambioTitularidad          constant varchar2(40) := 'SGASS_CAMBIO_TITULARIDAD';
  v_nombre_sp_CambioEquipoONT            constant varchar2(40) := 'SGASS_CAMBIO_EQUIPO_ONT'; --1.3 INICIATIVA 128
  v_nombre_sp_PREREG_DATOS_CCL           constant varchar2(40) := 'SGASS_PREREG_DATOS_CCL'; --1.8

  v_idlista_SERVICE_ID                   constant number := 92;
  v_idlista_CUSTOMER_ID                  constant number := 91;
  v_idlista_serviceType                  constant number := 93;
  v_idlista_MacAddress_CM                constant number := 94;
  v_idlista_Model_CM                     constant number := 104;
  v_idlista_MacAddress_MTA               constant number := 96;
  v_idlista_Model_MTA                    constant number := 97;
  v_idlista_serialNumber_STB             constant number := 110;
  v_idlista_Model_STB                    constant number := 112;
  v_idlista_HOST_UNIT_ADDRESS            constant number := 111;
  v_idlista_SerieONT                     constant number := 123; --1.3 INICIATIVA 128
  v_idlista_ModeloONT                    constant number := 124; --1.3 INICIATIVA 128

  --Configurar data de produccion LUEGO DE CONFIGURAR VOD
  v_idlista_CAS_PRODUCT_ID               constant number := 127;
  v_idlista_Phone_Num               constant number := 98;
  v_idlista_est                     constant number := 128;


  v_estado_activo                   constant number := 1;
  v_estado_suspendido               constant number := 2;

  v_cabe_docu                        constant varchar2(20) := 'ALTA_PROV';
  v_docu_inter                      constant varchar2(20) := 'INTERNET';
  v_docu_telef                      constant varchar2(20) := 'TELEFONIA';
  v_docu_tv                         constant varchar2(20) := 'CABLE';


  v_autenticacion constant varchar2(20) := 'Autentificacion';
  v_crearcuenta   constant varchar2(20) := 'Crear Cuenta';
  v_cambiotitular constant varchar2(20) := 'change_ownership';

  lv_get_account  constant varchar2(20) := 'get_account';
  v_init          constant varchar2(20) := 'init_equipo';
  v_reboot        constant varchar2(20) := 'reboot_equipo';
  v_refresh       constant varchar2(20) := 'refresh_equipo';

  v_SP_ACTIVAR_INTERNET    constant varchar2(20) := 'get_account';

  n_susp_no_parcial        constant number := 0;

  n_conv_minutos constant number := 1440;
  n_CERO         constant number := 0;
  n_UNO          constant number := 1;

  n_exito_CERO   constant number := 0;
  n_exito_200    constant number := 200;
  n_exito_201    constant number := 201;

  n_error_501    constant number := 501;

  n_error_f1     constant number := 1;
  n_error_f2     constant number := 2;
  n_error_f3     constant number := 3;
  n_error_f4     constant number := 4;
  n_error_f5     constant number := 5;

  n_error_t1     constant number := -1;--Error tÃ©cnico genÃ©rico en SP principal
  n_error_t2     constant number := -2;--Error tÃ©cnico genÃ©rico en SP consumido
  n_error_t3     constant number := -3;--Error por disponibilidad WS
  n_error_t4     constant number := -4;--Error por timeout WS

  v_tipsrv_INT   constant tystipsrv.tipsrv%type := '0006';
  v_tipsrv_TLF   constant tystipsrv.tipsrv%type := '0004';
  v_tipsrv_TV    constant tystipsrv.tipsrv%type := '0062';

  v_opedet_tipo_JSON      constant operacion.ope_det_xml.tipo%type := 4;

  v_esc_customer          constant sgacrm.ft_tiptra_escenario.escenario%type := 1;
  v_esc_servicio          constant sgacrm.ft_tiptra_escenario.escenario%type := 2;
  v_esc_dispositivo       constant sgacrm.ft_tiptra_escenario.escenario%type := 3;
  v_esc_adicional         constant sgacrm.ft_tiptra_escenario.escenario%type := 4;
  v_esc_adic_2            constant sgacrm.ft_tiptra_escenario.escenario%type := 5;
  v_esc_adic_3            constant sgacrm.ft_tiptra_escenario.escenario%type := 6;
  v_esc_customer_voip    constant sgacrm.ft_tiptra_escenario.escenario%type := 7;
  v_esc_customer_all_srv constant sgacrm.ft_tiptra_escenario.escenario%type := 8;

  v_tipsrv_TODO              constant sgacrm.ft_tiptra_escenario.tipsrv%type := 'TODO';
  v_tipsrv_PARC              constant sgacrm.ft_tiptra_escenario.tipsrv%type := 'PARC';

  v_num_trama_no_vod      constant sgacrm.ft_tiptra_escenario.escenario%type := 5;

  --Constante para SP_VALIDA_PARAMETRO
  v_SERIAL_NUMBER_STB                constant varchar2(20) := 'SERIAL_NUMBER_STB';
  v_UA_DECO                          constant varchar2(20) := 'UA_DECO';
  v_MAC_CM                           constant varchar2(20) := 'MAC_CM';
  v_MAC_MTA                          constant varchar2(20) := 'MAC_MTA';
  v_MODEL_CM                         constant varchar2(20) := 'MODEL_CM';
  v_MODEL_MTA                        constant varchar2(20) := 'MODEL_MTA';
  v_MODEL_STB                        constant varchar2(20) := 'MODEL_STB';
  v_TIPO_EQU_PROV                    constant varchar2(20) := 'TIPO_EQU_PROV';

--CONSTANTES APP INSTALADOR

  v_estnumtel_Dispo                 constant number := 2;
  v_Cod_Resp_Cero                   constant number := 0;
  v_Cod_Resp_Uno                    constant number := 1;
  v_Cod_Resp_Dos                    constant number := 2;
  av_Mensaje_OK                     constant varchar2(20) := 'Exito';
  v_No_Activo                       constant number := 0;
  v_idlista_PASSWORD                constant number := 125;

  type t_cursor is ref cursor;
--ini 1.4
  v_prov_masiva_shell          constant varchar2(20) := 'PROV_MASIVA_SHELL';
  v_abreviatura_registros      constant varchar2(20) := 'CANT_REG_SHELL';
  v_abreviatura_hilos          constant varchar2(20) := 'CANT_HILOS_SHELL';
--fin 1.4


  procedure SGASS_ACTIVAR_INTERNET(an_codsolot         operacion.solot.codsolot%type,
                                   av_customerid       varchar2,
                                   av_serviceid        SGACRM.ft_instdocumento.VALORTXT%type,
                                   av_Mac_SerialNumber varchar2, --MAC MTA  - HFC / SERIE ONT -  FTTH
                                   av_Modelo           varchar2, --MODELO MTA  HFC / MODELO ONT - FTTH
                                   av_token            varchar2 default null,
                                   an_Codigo_Resp      out number,
                                   av_Mensaje_Resp     out varchar2);

  procedure SGASS_ACTIVAR_INTERNET_ADIC(an_codsolot     operacion.solot.codsolot%type,
                                        av_customerid   varchar2,
                                        av_serviceid    SGACRM.ft_instdocumento.VALORTXT%type,
                                        av_token        varchar2 default null,
                                        an_Codigo_Resp  out number,
                                        av_Mensaje_Resp out varchar2);

  procedure SGASS_ACTIVAR_TELEFONIA(an_codsolot         operacion.solot.codsolot%type,
                                    av_customerid       varchar2,
                                    av_serviceid        SGACRM.ft_instdocumento.VALORTXT%type,
                                    av_Mac_SerialNumber varchar2, --MAC MTA  - HFC / SERIE ONT -  FTTH
                                    av_Modelo           varchar2, --MODELO MTA  HFC / MODELO ONT - FTTH
                                    av_MacAddress_CM    varchar2, --HFC
                                    av_serialNumber_CM  varchar2, --HFC
                                    av_token            varchar2 default null,
                                    an_Codigo_Resp      out number,
                                    av_Mensaje_Resp     out varchar2);

  procedure SGASS_ACTIVAR_TV(an_codsolot         operacion.solot.codsolot%type,
                             av_customerid       varchar2,
                             av_serviceid        SGACRM.ft_instdocumento.VALORTXT%type,
                             av_serialNumber_STB varchar2,
                             av_Model_STB        varchar2,
                             av_unitAddress      varchar2,
                             av_token            varchar2 default null,
                             an_Codigo_Resp      out number,
                             av_Mensaje_Resp     out varchar2);

  procedure SGASS_ACTIVAR_TV_ADIC(an_codsolot     operacion.solot.codsolot%type,
                                  av_customerid   varchar2,
                                  av_serviceid    SGACRM.ft_instdocumento.VALORTXT%type,
                                  av_token        varchar2 default null,
                                  an_Codigo_Resp  out number,
                                  av_Mensaje_Resp out varchar2);

  procedure SGASS_INIT_REBOOT(av_customerid   varchar2,
                              av_serviceid    SGACRM.ft_instdocumento.VALORTXT%type,
                              av_token        varchar2 default null,
                              an_Codigo_Resp  out number,
                              av_Mensaje_Resp out varchar2);

  procedure SGASS_REFRESH_STB(av_customerid   varchar2,
                              av_serviceid    SGACRM.ft_instdocumento.VALORTXT%type,
                              av_token        varchar2 default null,
                              an_Codigo_Resp  out number,
                              av_Mensaje_Resp out varchar2);

  procedure SGASS_SUSPENSION(an_codsolot     operacion.solot.codsolot%type,
                             av_customerid   varchar2,
                             av_serviceid    SGACRM.ft_instdocumento.VALORTXT%type,
                             av_tipo_sus     number,
                             av_parcial      number default n_susp_no_parcial,

                             av_token        varchar2 default null,
                             an_Codigo_Resp  out number,
                             av_Mensaje_Resp out varchar2);
  procedure SGASS_RECONEXION(an_codsolot     operacion.solot.codsolot%type,
                             av_customerid   varchar2,
                             av_serviceid    SGACRM.ft_instdocumento.VALORTXT%type,
                             av_tipo_rec     number,
                             av_parcial      number default n_susp_no_parcial,
                             av_token        varchar2 default null,
                             an_Codigo_Resp  out number,
                             av_Mensaje_Resp out varchar2);
  procedure SGASS_DESACTIVACION(an_codsolot     operacion.solot.codsolot%type,
                                av_customerid   varchar2,
                                av_serviceid    SGACRM.ft_instdocumento.VALORTXT%type,
                                av_tipo_des     varchar2,
                                av_token        varchar2 default null,
                                an_Codigo_Resp  out number,
                                av_Mensaje_Resp out varchar2);

  procedure SGASS_CREAR_CLIENTE(an_codsolot     operacion.solot.codsolot%type,
                                av_customerid   varchar2,
                                av_token        varchar2 default null,
                                an_Codigo_Resp  out number,
                                av_Mensaje_Resp out varchar2);

  procedure SGASS_OBTENER_CLIENTE(av_customerid   varchar2,
                                  av_token        varchar2 default null,
                                  lv_json         out clob,
                                  an_Codigo_Resp  out number,
                                  av_Mensaje_Resp out varchar2);

  procedure SGASS_CAMBIO_PLAN(an_codsolot     operacion.solot.codsolot%type,
                              av_customerid   varchar2,
                              av_serviceid    SGACRM.ft_instdocumento.VALORTXT%type,
                              av_servicetype  varchar2,
                              av_token        varchar2 default null,
                              an_Codigo_Resp  out number,
                              av_Mensaje_Resp out varchar2);

  procedure SGASS_ELIMINAR_CLIENTE(an_codsolot     operacion.solot.codsolot%type,
                                   av_customerid   varchar2,
                                   av_token        varchar2 default null,
                                   an_Codigo_Resp  out number,
                                   av_Mensaje_Resp out varchar2);

  procedure SGASS_CAMBIO_EQUIPO_TELEFONIA(an_codsolot       operacion.solot.codsolot%type,
                                          av_customerid     varchar2,
                                          av_serviceid      SGACRM.ft_instdocumento.VALORTXT%type,
                                          av_MacAddress_MTA varchar2,
                                          av_Model_MTA      varchar2,
                                          av_MacAddress_CM  varchar2,
                                          av_Model_CM       varchar2,
                                          av_token          varchar2 default null,
                                          an_Codigo_Resp    out number,
                                          av_Mensaje_Resp   out varchar2);

  procedure SGASS_CAMBIO_EQUIPO_INTERNET(an_codsolot   operacion.solot.codsolot%type,
                                         av_customerid varchar2,
                                         av_serviceid  SGACRM.ft_instdocumento.VALORTXT%type,
                                         av_MacAddress   varchar2,
                                         av_Model        varchar2,
                                         av_token        varchar2 default null,
                                         an_Codigo_Resp  out number,
                                         av_Mensaje_Resp out varchar2);

  procedure SGASS_CAMBIO_EQUIPO_TV(an_codsolot         operacion.solot.codsolot%type,
                                   av_customerid       varchar2,
                                   av_serviceid        SGACRM.ft_instdocumento.VALORTXT%type,
                                   av_serialNumber_STB varchar2,
                                   av_Model_STB        varchar2,
                                   av_unitAddress      varchar2,
                                   av_token            varchar2 default null,
                                   an_Codigo_Resp      out number,
                                   av_Mensaje_Resp     out varchar2);

  procedure SGASS_CAMBIO_ATRIBUTO(an_codsolot     operacion.solot.codsolot%type,
                                        av_customerid   varchar2,
                                        av_serviceid    SGACRM.ft_instdocumento.VALORTXT%type,
                                        av_atributo     varchar2,
                                        av_valor        varchar2,
                                        av_token        varchar2 default null,
                                        an_Codigo_Resp  out number,
                                        av_Mensaje_Resp out varchar2);

  function SGASS_AUTENTICACION return varchar2;

  PROCEDURE SGASS_CAMBIO_TITULARIDAD(an_codsolot        operacion.solot.codsolot%type,
                                     av_old_customer_id varchar2,
                                     av_customerid      varchar2,
                                     av_token           VARCHAR2 DEFAULT NULL,
                                     an_codigo_resp     OUT NUMBER,
                                     av_mensaje_resp    OUT VARCHAR2);

  procedure SP_ACTUALIZA_INSTDOCUMENTO(av_idlista  SGACRM.ft_instdocumento.IDLISTA%type,
                                    an_idficha  SGACRM.ft_instdocumento.IDFICHA%type,
                                    av_valor    SGACRM.ft_instdocumento.VALORTXT%type,
                                    ln_insidcom SGACRM.ft_instdocumento.INSIDCOM%type,
                                    an_Codigo   out number,
                                    av_Mensaje  out varchar2);

  function F_OBTIENE_VALOR(av_idlista  SGACRM.ft_instdocumento.idlista%type,
                         an_idficha  SGACRM.ft_instdocumento.IDFICHA%type,
                         ln_insidcom SGACRM.ft_instdocumento.INSIDCOM%type)
    return varchar2;

  procedure SP_OBTIENE_FICHA_SOT(an_codsolot        operacion.solot.CODSOLOT%type,
                                 av_serviceid        SGACRM.ft_instdocumento.VALORTXT%type,
                                 an_idficha          out SGACRM.ft_instdocumento.IDFICHA%type,
                                 an_idcomponente     out SGACRM.ft_instdocumento.IDCOMPONENTE%type,
                                 an_insidcom         out SGACRM.ft_instdocumento.INSIDCOM%type,
                                 an_Codigo           out number,
                                 av_Mensaje          out varchar2);

   procedure SP_OBTIENE_FICHA_TOTAL(an_customer_id      varchar2,
                                   av_serviceid        SGACRM.ft_instdocumento.VALORTXT%type,
                                   an_idficha          out SGACRM.ft_instdocumento.IDFICHA%type,
                                   an_idcomponente     out SGACRM.ft_instdocumento.IDCOMPONENTE%type,
                                   an_insidcom         out SGACRM.ft_instdocumento.INSIDCOM%type,
                                   an_Codigo           out number,
                                   av_Mensaje          out varchar2);

   procedure SP_OBTIENE_FICHA_ACTIVA(an_customer_id    varchar2,
                                   av_serviceid       SGACRM.ft_instdocumento.VALORTXT%type,
                                   an_idficha         out SGACRM.ft_instdocumento.IDFICHA%type,
                                   an_idcomponente    out SGACRM.ft_instdocumento.IDCOMPONENTE%type,
                                   an_insidcom        out SGACRM.ft_instdocumento.INSIDCOM%type,
                                   an_Codigo          out number,
                                   av_Mensaje         out varchar2);

   procedure SP_OBTIENE_FICHA_NO_SID(an_codsolot        operacion.solot.CODSOLOT%type,
                                     av_valor            SGACRM.ft_instdocumento.VALORTXT%type,
                                     av_serviceid        SGACRM.ft_instdocumento.VALORTXT%type,
                                     an_idficha          out SGACRM.ft_instdocumento.IDFICHA%type,
                                     an_idcomponente     out SGACRM.ft_instdocumento.IDCOMPONENTE%type,
                                     an_insidcom         out SGACRM.ft_instdocumento.INSIDCOM%type,
                                     an_Codigo           out number,
                                     av_Mensaje          out varchar2);

  procedure SP_GENERA_TRAMA(an_idficha  SGACRM.ft_instdocumento.IDFICHA%type,
                         an_insidcom SGACRM.ft_instdocumento.INSIDCOM%type,
                         av_token    varchar2 default null,
                         av_trama    out varchar2,
                         an_Codigo   out number,
                         av_Mensaje  out varchar2);

  procedure SP_GENERA_TRAMA_ADIC(an_idficha  SGACRM.ft_instdocumento.IDFICHA%type,
                              an_insidcom SGACRM.ft_instdocumento.INSIDCOM%type,
                              av_token    varchar2 default null,
                              av_trama    out varchar2,
                              an_Codigo   out number,
                              av_Mensaje  out varchar2);

  procedure SP_INSERTA_CLIENTE_INCOGNITO(av_customerid varchar2,
                                      av_nomcli     varchar2,
                                      av_estado     char);

  procedure SP_ACTUALIZA_CLIENTE_INCOGNITO(av_customerid varchar2,
                                        av_estado     char);

  procedure SP_ACTUALIZA_INSTDOC_TEL(ln_idficha        SGACRM.ft_instdocumento.IDFICHA%type,
                                  av_MacAddress_MTA SGACRM.ft_instdocumento.VALORTXT%type,
                                  av_Model_MTA      SGACRM.ft_instdocumento.VALORTXT%type,
                                  av_MacAddress_CM  SGACRM.ft_instdocumento.VALORTXT%type,
                                  av_Model_CM       SGACRM.ft_instdocumento.VALORTXT%type,
								  av_tecnologia VARCHAR2);

  procedure SP_ACTUALIZA_INSTDOC_INT(ln_idficha    SGACRM.ft_instdocumento.IDFICHA%type,
                                  av_MacAddress SGACRM.ft_instdocumento.VALORTXT%type,
                                  av_Model      SGACRM.ft_instdocumento.VALORTXT%type,
								  av_tecnologia VARCHAR2);

  procedure SP_ACTUALIZA_INSTDOC_TV(ln_idficha          SGACRM.ft_instdocumento.IDFICHA%type,
                                 av_serialNumber_STB SGACRM.ft_instdocumento.VALORTXT%type,
                                 av_Model_STB        SGACRM.ft_instdocumento.VALORTXT%type,
                                 av_unitAddress      SGACRM.ft_instdocumento.VALORTXT%type);

  function F_OBTIENE_TIPTRA(an_codsolot operacion.solot.codsolot%type)
    return number;

  procedure SP_OBTIENE_PROGRAMA(an_tiptra   tiptrabajo.tiptra%type,
                             av_tipsrv   tystipsrv.tipsrv%type,
                             an_tipo     number,
                             av_programa out operacion.Ope_Cab_Xml.programa%type,
                             an_Codigo   out number,
                             av_Mensaje  out varchar2);

  function F_ELIMINA_TRAMA_N(av_trama varchar2, an_n number) return varchar2;



  function OBTIENE_VALOR(av_etiqueta SGACRM.ft_instdocumento.VALORTXT%type,
                           an_idficha  SGACRM.ft_instdocumento.IDFICHA%type,
                           ln_insidcom     SGACRM.ft_instdocumento.INSIDCOM%type)
      return varchar2;

  procedure SP_ACTUALIZA_ESTADO_EQUIPO(av_id_dispositivo varchar2,
                                         av_estado     number);

  procedure P_TIPTRA(an_tiptra          in number,
                     av_descripcion     out varchar2,
                     an_escenario       out number,
                     av_escenario       out varchar2,
                     an_tecnologia      out number,
                     av_tecnologia      out varchar2,
                     an_Codigo_Resp     out number,
                     av_Mensaje_Resp    out varchar2);

  --INICIO APP INSTALADOR



   procedure P_OBTENER_INFO_EQUIPO(av_dni                 in varchar2,
                                    av_tipo                in produccion.almtabmat.tipo_equ_prov%type,
                                    o_resultado            out t_cursor,
                                    an_Codigo_Resp         out number,
                                    av_Mensaje_Resp        out varchar2);

    procedure P_LISTA_EQUIPOS( an_codsolot                   in  solotpto.codsolot%type,
                                ac_cursor_equipos            out SYS_REFCURSOR,
                                an_Codigo_Resp               out number,
                                av_Mensaje_Resp              out varchar2);

    procedure  P_VALIDA_EQUIPO_ASIGNADO(av_id_dispositivo                        varchar2,
                                      av_dni                        varchar2,
                                      an_Codigo_Resp                out number,
                                      av_Mensaje_Resp               out varchar2);



    procedure  P_VALIDA_EQUIPO_TIPO(av_id_dispositivo           in varchar2,
                                      av_tipo                       in varchar2,
                                      av_valor1                     out varchar2,
                                      av_valor2                     out varchar2,
                                      av_valor3                     out varchar2,
                                      av_valor4                     out varchar2,
                                      an_Codigo_Resp                out number,
                                      av_Mensaje_Resp               out varchar2);

    procedure P_ACTUALIZA_EQUIPO_FT (v_serviceid       FT_INSTDOCUMENTO.Valortxt%type,
                                v_idficha         FT_INSTDOCUMENTO.Idficha%type,
                                v_valor1          FT_INSTDOCUMENTO.Valortxt%type,
                                v_valor2          FT_INSTDOCUMENTO.Valortxt%type,
                                v_valor3          FT_INSTDOCUMENTO.Valortxt%type,
                                v_valor4          FT_INSTDOCUMENTO.Valortxt%type,
                                an_Codigo_Resp        OUT NUMBER,
                                av_Mensaje_Resp        OUT VARCHAR2);


    PROCEDURE P_CREA_FICHA_SOT(an_codsolot in number,
                               an_Codigo_Resp                out number,
                               av_Mensaje_Resp               out varchar2
                                );

    PROCEDURE P_CREA_CLIENTE_INCOG(an_codsolot                   in number,
                                   an_Codigo_Resp                out number,
                                   av_Mensaje_Resp               out varchar2);

    PROCEDURE P_ELIMINA_FICHA_SOT (
       a_codsolot in number,
       an_Codigo_Resp                out number,
       av_Mensaje_Resp               out varchar2
       );


    PROCEDURE P_VALIDA_FICHA_SOT (
       a_codsolot in number,
       an_Codigo_Resp                out number,
       av_Mensaje_Resp               out varchar2
       );

    PROCEDURE P_RELANZA_FICHA_SOT (
       a_codsolot in number,
       an_Codigo_Resp                out number,
       av_Mensaje_Resp               out varchar2
       );

    PROCEDURE P_ASIGNAR_NUMEROS(a_codsolot in number,
                                 v_num_tel                     out TELEFONIA.NUMTEL.NUMERO%type,
                                 an_Codigo_Resp                out number,
                                 av_Mensaje_Resp               out varchar2);
    PROCEDURE P_CAMBIA_EST_ASIG_NUMTEL(p_numslc IN VARCHAR2,
                                      v_num_tel                     OUT TELEFONIA.NUMTEL.NUMERO%type,
                                      an_Codigo_Resp                OUT NUMBER,
                                      av_Mensaje_Resp               OUT VARCHAR2);


     PROCEDURE P_ACTUALIZA_NUMTEL_FICHA(ln_idficha    SGACRM.ft_instdocumento.IDFICHA%type,
                                      av_Phone_Number SGACRM.ft_instdocumento.VALORTXT%type,
                                      an_Codigo_Resp                out number,
                                      av_Mensaje_Resp               out varchar2);

    procedure P_REGISTRA_LOG_APK(av_tipo   OPERACION.REG_LOG_APK.TIPO%type,
                          av_cod_resp    OPERACION.REG_LOG_APK.COD_RESP%type,
                          av_msg_resp    OPERACION.REG_LOG_APK.MSG_RESP%type,
                          av_param_envio OPERACION.REG_LOG_APK.PARAM_ENVIO%type);


    procedure P_ACTUALIZA_LOG_APK(av_cod_resp    OPERACION.REG_LOG_APK.COD_RESP%type,
                          av_msg_resp    OPERACION.REG_LOG_APK.MSG_RESP%type);





  FUNCTION F_OBT_TIPO_EQUIPO(v_IDFICHA       sgacrm.ft_instdocumento.idficha%type)
      return varchar2;

    FUNCTION F_OBT_PARAM_OPEDD(v_CABE_ABREV       tipopedd.abrev%type,
                             v_DETA_ABREV       opedd.ABREVIACION%type,
							 v_tecnologia       opedd.CODIGOC%type)
    RETURN VARCHAR2;

    --FIN APP INSTALADOR
    --Ini 1.2
  procedure SP_SUSPENSION_RECONEXION_PROV(a_idtareawf in number,
                                          a_idwf      in number,
                                          a_tarea     in number,
                                          a_tareadef  in number);

  procedure SP_UPDATE_ESTADO_OAC(a_idtareawf in number,
                                 a_idwf      in number,
                                 a_tarea     in number,
                                 a_tareadef  in number);

  procedure SP_SUSPENSION_RECONEXION_BSCS(a_idtareawf in number,
                                          a_idwf      in number,
                                          a_tarea     in number,
                                          a_tareadef  in number);

  procedure SP_SUSPENSION_RECONEXION_SGA(a_idtareawf in number,
                                         a_idwf      in number,
                                         a_tarea     in number,
                                         a_tareadef  in number);


  procedure SP_REG_LOG_PROVISION(an_idoac       number,
                                 an_customer_id number,
                                an_codsolot    number,
                                 an_co_id       number,
                                an_proceso     varchar2,
                                an_codigo      number,
                                as_mensaje     varchar2);
  --Fin 1.2
--INI 1.3
  procedure SGASS_CAMBIO_EQUIPO_ONT(an_codsolot     operacion.solot.codsolot%type,
                                    av_customerid   varchar2,
                                    av_serviceid    SGACRM.ft_instdocumento.VALORTXT%type,
                                    av_NewSerieONT  varchar2,
                                    av_NewModeloONT varchar2,
                                    av_token        varchar2 default null,
                                    an_Codigo_Resp  out number,
                                    av_Mensaje_Resp out varchar2);
--Fin 1.3
--Ini 1.4
  PROCEDURE p_obtiene_info(av_transaction    IN VARCHAR2,
                           cursor_log         out SYS_REFCURSOR,
                           lv_token           out varchar2,
                           lv_cant_hilos      out number,
                           n_error            out number);

  PROCEDURE  p_actualiza_logws(av_transaction     IN VARCHAR2,
                              av_idenvio          IN NUMBER,
                              av_resp_xml         IN CLOB,
                              av_resultado        IN NUMBER,
                              av_Codigo_Repws     OUT NUMBER,
                              av_Mensaje_Repws    OUT VARCHAR2);
--Fin 1.4
  procedure P_ACTUALIZA_FICHA_JSON(ln_codsolot in number,
                                   ln_idficha  in SGACRM.ft_instdocumento.IDFICHA%type);

-- Ini 1.7
  FUNCTION f_obtener_tag(av_tag   VARCHAR2,
                         n_tag    number default 1,
                         av_trama CLOB,
                         v_inicio varchar2,
                         n_inicio number default 1,
                         v_fin    varchar2,
                         n_fin    number default 1) RETURN clob;

  procedure p_insertar_equipos(n_codsolot      number,
                               codigo          in varchar2,
                               an_codigo_resp  out number,
                               av_mensaje_resp out varchar2);
-- Fin 1.7

-- ini 1.8
  PROCEDURE SGASS_PREREG_DATOS_CCL(AN_CODSOLOT     OPERACION.SOLOT.CODSOLOT%TYPE,
                                   AN_CUSTOMERID   OPERACION.solot.customer_id%type,--1.9
                                   AV_SERVICEID    SGACRM.FT_INSTDOCUMENTO.VALORTXT%TYPE,
                                   AN_CODIGO_RESP  OUT NUMBER,
                                   AV_MENSAJE_RESP OUT VARCHAR2);

  PROCEDURE SGASS_PREREGISTRO_DATOS_CCL(A_IDTAREAWF IN NUMBER,
                                        A_IDWF      IN NUMBER,
                                        A_TAREA     IN NUMBER,
                                        A_TAREADEF  IN NUMBER);
                                        
  FUNCTION SGAFUN_VALIDA_EQUIPO(AN_CODSOLOT OPERACION.SOLOT.CODSOLOT%TYPE)
   RETURN BOOLEAN;
--fin 1.8								   							   
end PKG_PROV_INCOGNITO;
/
