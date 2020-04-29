CREATE OR REPLACE PACKAGE OPERACION.PQ_SIAC_CAMBIO_PLAN_LTE IS

  /**********************************************************************************************************************************
  NOMBRE:     OPERACION.PQ_SIAC_CAMBIO_PLAN_LTE
  PROPOSITO:  GENERACION DE CAMBIO DE PLAN LTE

  REVISIONES:
   VERSION   FECHA          AUTOR                  SOLICITADO POR             DESCRIPCION
   -------- ----------  ------------------------   ------------------------   -------------------------------------------------------
   1.0      21/10/2015  Dorian Sucasaca            Hector Huaman              PROY-20152: IDEA-24390 Proyecto LTE - 3Play inalámbrico
   2.0      15/12/2015  Dorian Sucasaca            Hector Huaman              PQT-247649-TSK-76965
   3.0      01/06/2017  Dorian Sucasaca
   4.0      21/06/2017  Luis Guzman                Tito Huerta                PROY-27792 IDEA-34954 - Proyecto LTE
   5.0      03/07/2018  Luis Flores                Luis Flores                [IDEA-40758/PROY-32581-Postventa LTE/HFC [Cambio Plan]
   6.0      13/08/2018  Yajaira Gastaniadui        Luis Flores                [IDEA-40758/PROY-32581-Postventa LTE/HFC [Cambio Plan]
   7.0      06/12/2018  Luis Flores                Luis Flores                [IDEA-40758/PROY-32581-Postventa LTE/HFC] - [Cambio Plan]
   8.0      12/03/2019  Luis Flores                Luis Flores                [IDEA-40758/PROY-32581-Postventa LTE/HFC] - [Cambio Plan]
   9.0      18/03/2019  Luis Flores                Luis Flores                [IDEA-40758/PROY-32581-Postventa LTE/HFC] - [Cambio Plan]
/***********************************************************************************************************************************/


  G_COD_ID       OPERACION.SOLOT.COD_ID%TYPE;
  G_CUSTOMERID   SALES.SOT_SIAC.CUSTOMER_ID%TYPE; -- 3.0
  G_PROCESO      VARCHAR2(100); -- 3.0
  G_NUMSLC_OLD   VTATABSLCFAC.NUMSLC%TYPE;
  G_NUMREGISTRO  REGVTAMENTAB.NUMREGISTRO%TYPE;
  G_NUMSLC_NEW   VTATABSLCFAC.NUMSLC%TYPE;
  G_IDPROCESS    SIAC_POSTVENTA_PROCESO.IDPROCESS%TYPE;
  G_CODSOLOT     OPERACION.SOLOT.CODSOLOT%TYPE; -- 3.0
  G_CODSOLOT_OLD OPERACION.SOLOT.CODSOLOT%TYPE; -- 3.0
  G_ACTIVO              CONSTANT INSSRV.ESTINSSRV%TYPE := 1;
  G_SUSPENDIDO          CONSTANT INSSRV.ESTINSSRV%TYPE := 2;
  G_PENDIENTE_X_ACTIVAR CONSTANT INSSRV.ESTINSSRV%TYPE := 4;
  G_GRUPO_INTERNET      CONSTANT SALES.SISACT_POSTVENTA_DET_SERV_LTE.IDGRUPO%TYPE := '201';
  G_GRUPO_TELEFONIA     CONSTANT SALES.SISACT_POSTVENTA_DET_SERV_LTE.IDGRUPO%TYPE := '200';
  G_GRUPO_TV            CONSTANT SALES.SISACT_POSTVENTA_DET_SERV_LTE.IDGRUPO%TYPE := '203';
  C_SNCODE_TELFIJ_LTE CONSTANT INTEGER := 600;

  G_MSJ_ERR VARCHAR2(4000);
  G_VIS_TEC VARCHAR2(1);

  TYPE IDLINEA_TYPE IS RECORD(
    IDLINEA            SALES.LINEA_PAQUETE.IDLINEA%TYPE,
    SERVICIO_SGA       SALES.TYSTABSRV.CODSRV%TYPE,
    IDDET              SALES.LINEA_PAQUETE.IDDET%TYPE,
    CANTIDAD_INSTANCIA SALES.VTADETPTOENL.CANTIDAD%TYPE,
    TIPEQU             OPERACION.TIPEQU.TIPEQU%TYPE,
    CODTIPEQU          OPERACION.EQUCOMXOPE.CODTIPEQU%TYPE,
    CANTIDAD           SALES.VTADETPTOENL.CANTIDAD%TYPE,
    STATUS             VARCHAR2(30));

  TYPE IDLINEAS_TYPE IS TABLE OF IDLINEA_TYPE INDEX BY PLS_INTEGER;

  TYPE SERVICIO_TYPE IS RECORD(
    SERVICIO           SALES.SERVICIO_SISACT.IDSERVICIO_SISACT%TYPE,
    IDGRUPO_PRINCIPAL  SALES.GRUPO_SISACT_LTE.IDGRUPO_SISACT%TYPE,
    IDGRUPO            SALES.GRUPO_SISACT_LTE.IDGRUPO_SISACT%TYPE,
    CANTIDAD_INSTANCIA SALES.VTADETPTOENL.CANTIDAD%TYPE,
    DSCSRV             SALES.TYSTABSRV.DSCSRV%TYPE,
    BANDWID            SALES.TYSTABSRV.BANWID%TYPE,
    FLAG_LC            SALES.TYSTABSRV.FLAG_LC%TYPE,
    CANTIDAD_IDLINEA   NUMBER := 1,
    TIPEQU             OPERACION.TIPEQU.TIPEQU%TYPE,
    CODTIPEQU          OPERACION.EQUCOMXOPE.CODTIPEQU%TYPE,
    CANTIDAD           SALES.VTADETPTOENL.CANTIDAD%TYPE,
    DSCEQU             SALES.VTAEQUCOM.DSCEQU%TYPE,
    CODIGO_EXT         VARCHAR2(50),
    SNCODE             SALES.SISACT_POSTVENTA_DET_SERV_LTE.SNCODE%TYPE,
    FLAG_ACCION        SALES.SISACT_POSTVENTA_DET_SERV_LTE.FLAG_ACCION%TYPE);

  TYPE SERVICIOS_TYPE IS TABLE OF SERVICIO_TYPE INDEX BY PLS_INTEGER;

  TYPE PRECON_TYPE IS RECORD(
    OBSAPROFE VTATABPRECON.OBSAPROFE%TYPE,
    CARTA     VTATABPRECON.CARTA%TYPE,
    CARRIER   VTATABPRECON.CARRIER%TYPE,
    PRESUSC   VTATABPRECON.PRESUSC%TYPE,
    PUBLICAR  VTATABPRECON.PUBLICAR%TYPE);

  TYPE SERVICE_TYPE IS RECORD(
    IDLINEA  LINEA_PAQUETE.IDLINEA%TYPE,
    CODSRV   LINEA_PAQUETE.CODSRV%TYPE,
    IDDET    LINEA_PAQUETE.IDDET%TYPE,
    CANTIDAD NUMBER,
    TIPO     NUMBER);

  TYPE SERVICES_TYPE IS TABLE OF SERVICE_TYPE INDEX BY PLS_INTEGER;

  TYPE DETALLE_SERVICIO_TYPE IS RECORD(
    FLGPRINCIPAL DETALLE_PAQUETE.FLGPRINCIPAL%TYPE,
    IDPRODUCTO   DETALLE_PAQUETE.IDPRODUCTO%TYPE,
    CODSRV       LINEA_PAQUETE.CODSRV%TYPE,
    CODEQUCOM    LINEA_PAQUETE.CODEQUCOM%TYPE,
    IDPRECIO     DEFINE_PRECIO.IDPRECIO%TYPE,
    CANTIDAD     LINEA_PAQUETE.CANTIDAD%TYPE,
    MONEDA_ID    DEFINE_PRECIO.MONEDA_ID%TYPE,
    IDPAQ        DETALLE_PAQUETE.IDPAQ%TYPE,
    IDDET        DETALLE_PAQUETE.IDDET%TYPE,
    PAQUETE      DETALLE_PAQUETE.PAQUETE%TYPE,
    BANWID       TYSTABSRV.BANWID%TYPE);

  TYPE gc_lista IS REF CURSOR;

  PROCEDURE EXECUTE_MAIN(P_IDPROCESS  SIAC_POSTVENTA_PROCESO.IDPROCESS%TYPE,
                         P_CUSTOMERID OPERACION.SOLOT.CUSTOMER_ID%TYPE,
                         P_ID         SALES.SISACT_POSTVENTA_DET_SERV_LTE.IDINTERACCION%TYPE,
                         P_COD_ID     SALES.SOT_SISACT.COD_ID%TYPE,
                         P_PRECON     PRECON_TYPE);

  PROCEDURE SP_CREATE_REGVTAMENTAB(P_COD_ID OPERACION.SOLOT.COD_ID%TYPE);

  PROCEDURE SP_SET_INSTANCE(P_TIPO_INSTANCIA OPERACION.SIAC_INSTANCIA.TIPO_INSTANCIA%TYPE,
                            P_INSTANCIA      OPERACION.SIAC_INSTANCIA.INSTANCIA%TYPE);

  PROCEDURE SP_SET_SOLOT(P_CUSTOMERID OPERACION.SOLOT.CUSTOMER_ID%TYPE,
                         P_SOLOT      OPERACION.SOLOT.CODSOLOT%TYPE);

  PROCEDURE SP_SET_BOUQUET(P_SERVICIOS   SERVICIOS_TYPE,
                           P_IDLINEA_VTA OUT SALES.PQ_INT_SISACT_SGA_LTE.IDLINEAS_TYPE);

  PROCEDURE SP_SET_DET_SERV_LTE(P_ID    SALES.SISACT_POSTVENTA_DET_SERV_LTE.IDINTERACCION%TYPE,
                                P_SOLOT OPERACION.SOLOT.CODSOLOT%TYPE);

  PROCEDURE SP_CREATE_SALES_DETAIL(P_SERVICES SERVICES_TYPE);

  PROCEDURE SP_CREATE_REGDETPTOENLCAMBIO(P_IDSECUENCIA INSTANCIA_PAQUETE_CAMBIO.IDSECUENCIA%TYPE,
                                         P_IDLINEA     LINEA_PAQUETE.IDLINEA%TYPE,
                                         P_CANTIDAD    SALES.VTADETPTOENL.CANTIDAD%TYPE,
                                         P_TIPO        NUMBER,
                                         P_PUNTO       VTADETPTOENL.NUMPTO%TYPE,
                                         P_IDINSXPAQ   REGDETPTOENLCAMBIO.IDINSXPAQ%TYPE);

  PROCEDURE SP_GENERAR_SEF(P_NUMREGISTRO REGVTAMENTAB.NUMREGISTRO%TYPE);

  PROCEDURE SP_GENERAR_PTOENL_CAMBIO(P_NUMREGISTRO REGVTAMENTAB.NUMREGISTRO%TYPE,
                                     P_NUMSLC      VTATABSLCFAC.NUMSLC%TYPE,
                                     P_PRECON_TYPE PRECON_TYPE);

  PROCEDURE SP_ACTUALIZAR_PTO_PRI_CAMBIO(P_NUMREGISTRO REGVTAMENTAB.NUMREGISTRO%TYPE);

  PROCEDURE SP_LOAD_DETALLE_CAMBIO(P_NUMREGISTRO REGVTAMENTAB.NUMREGISTRO%TYPE,
                                   P_NUMSLC      VTATABSLCFAC.NUMSLC%TYPE);

  PROCEDURE SP_ACTUALIZAR_GRUPO_CAMBIO(P_NUMSLC VTATABSLCFAC.NUMSLC%TYPE);

  PROCEDURE SP_GENERAR_DES_CAMBIO(P_NUMREGISTRO REGVTAMENTAB.NUMREGISTRO%TYPE,
                                  P_NUMSLC      VTATABSLCFAC.NUMSLC%TYPE,
                                  P_PRECON_TYPE PRECON_TYPE);

  PROCEDURE SP_UPDATE_NUMSLC_NEW;

  PROCEDURE SP_LOAD_INSTANCIA_CAMBIO(P_NUMSLC VTATABSLCFAC.NUMSLC%TYPE);

  PROCEDURE SP_CREATE_VTATABPRECON(P_NUMSLC VTATABSLCFAC.NUMSLC%TYPE,
                                   P_PRECON PRECON_TYPE);

  PROCEDURE SP_VALIDAR_TIPOSOLUCION(P_PARAMETRO VARCHAR2);

  PROCEDURE SP_INSERT_SERVICIOS(P_SERVICIOS SERVICIOS_TYPE,
                                P_IDLINEA   OUT IDLINEAS_TYPE);

  PROCEDURE ACTUALIZA_CO_ID(G_NUMSLC_NEW VTATABSLCFAC.NUMSLC%TYPE,
                            P_COD_ID     INSSRV.CO_ID%TYPE);

  PROCEDURE SP_ASIGNAR_PLATAFORMA(P_NUMSLC  VTATABSLCFAC.NUMSLC%TYPE,
                                  P_RETORNA OUT NUMBER,
                                  P_TEXTO   OUT VARCHAR2);

  FUNCTION FNC_VALIDAR_CHECKPROY(P_NUMSLC VTATABSLCFAC.NUMSLC%TYPE)
    RETURN VARCHAR2;

  FUNCTION FNC_PROYECTO_PREVENTA(P_NUMSLC VTATABSLCFAC.NUMSLC%TYPE)
    RETURN NUMBER;

  FUNCTION FNC_INSERT_REGVTAMENTAB(P_REGMEN REGVTAMENTAB%ROWTYPE)
    RETURN REGVTAMENTAB.NUMREGISTRO%TYPE;

  FUNCTION FNC_GET_SERVICES(P_SERVICIOS SERVICIOS_TYPE) RETURN SERVICES_TYPE;

  FUNCTION FNC_FILL_NEW_SERVICES(P_SERVICES      SERVICES_TYPE,
                                 P_NEW_SERVICIOS SERVICIOS_TYPE)
    RETURN SERVICES_TYPE;

  FUNCTION FNC_GET_LINEA(P_SERVICIO SERVICIO_TYPE)
    RETURN SALES.LINEA_PAQUETE.IDLINEA%TYPE;

  FUNCTION FNC_GET_IDLINEA_EQUIPO(P_TIPEQU  TIPEQU.TIPEQU%TYPE,
                                  P_IDGRUPO SALES.GRUPO_SISACT_LTE.IDGRUPO_SISACT%TYPE)
    RETURN LINEA_PAQUETE.IDLINEA%TYPE;

  FUNCTION FNC_GET_IDLINEA_SERVICE(P_SERVICEID_SISACT SALES.SERVICIO_SISACT.IDSERVICIO_SISACT%TYPE)
    RETURN LINEA_PAQUETE.IDLINEA%TYPE;

  FUNCTION FNC_GET_CODSRV(P_SERVICIO SERVICIO_TYPE)
    RETURN SALES.LINEA_PAQUETE.CODSRV%TYPE;

  FUNCTION FNC_GET_CODSRV_EQUIPO(P_TIPEQU  TIPEQU.TIPEQU%TYPE,
                                 P_IDGRUPO SALES.GRUPO_SISACT_LTE.IDGRUPO_SISACT%TYPE)
    RETURN LINEA_PAQUETE.CODSRV%TYPE;

  FUNCTION FNC_GET_CODSRV_SERVICE(P_SERVICEID_SISACT SALES.SERVICIO_SISACT.IDSERVICIO_SISACT%TYPE)
    RETURN LINEA_PAQUETE.CODSRV%TYPE;

  FUNCTION FNC_GET_IDDET(P_SERVICIO SERVICIO_TYPE)
    RETURN SALES.LINEA_PAQUETE.IDDET%TYPE;

  FUNCTION FNC_GET_IDDET_EQUIPO(P_TIPEQU  TIPEQU.TIPEQU%TYPE,
                                P_IDGRUPO SALES.GRUPO_SISACT_LTE.IDGRUPO_SISACT%TYPE)
    RETURN LINEA_PAQUETE.IDDET%TYPE;

  FUNCTION FNC_GET_IDDET_SERVICE(P_SERVICEID_SISACT SALES.SERVICIO_SISACT.IDSERVICIO_SISACT%TYPE)
    RETURN LINEA_PAQUETE.IDDET%TYPE;

  FUNCTION FNC_GET_IDDET_SGA(P_IDLINEA SALES.LINEA_PAQUETE.IDLINEA%TYPE)
    RETURN LINEA_PAQUETE.IDDET%TYPE;

  FUNCTION FNC_GET_ACCION_CP(P_ACCION OPERACION.INSPRD.CODSRV%TYPE,
                             P_TIPO   VARCHAR2) RETURN NUMBER;

  FUNCTION FNC_GET_INSSRV(P_COD_ID OPERACION.SOLOT.COD_ID%TYPE)
    RETURN INSSRV%ROWTYPE;

  FUNCTION FNC_EXISTE_TRASLADO(P_COD_ID OPERACION.SOLOT.COD_ID%TYPE)
    RETURN BOOLEAN;

  FUNCTION FNC_GET_DATOS_TRASLADO(P_COD_ID OPERACION.SOLOT.COD_ID%TYPE)
    RETURN INSSRV%ROWTYPE;

  FUNCTION FNC_GET_CNTCLI(P_COD_ID OPERACION.SOLOT.COD_ID%TYPE)
    RETURN VTATABCNTCLI%ROWTYPE;

  FUNCTION FNC_GET_SLCFAC(P_COD_ID OPERACION.SOLOT.COD_ID%TYPE)
    RETURN VTATABSLCFAC%ROWTYPE;

  FUNCTION FNC_GET_CODSOLOT RETURN SOLOT.CODSOLOT%TYPE;

  FUNCTION FNC_CREATE_INST_PAQ_CAMBIO(P_IDINSXPAQ   REGDETPTOENLCAMBIO.IDINSXPAQ%TYPE,
                                      P_IDLINEA     LINEA_PAQUETE.IDLINEA%TYPE,
                                      P_NUMREGISTRO REGVTAMENTAB.NUMREGISTRO%TYPE,
                                      P_CODSUC      VTASUCCLI.CODSUC%TYPE)
    RETURN INSTANCIA_PAQUETE_CAMBIO.IDSECUENCIA%TYPE;

  FUNCTION FNC_GET_DETALLE_SERVICIO(P_IDLINEA LINEA_PAQUETE.IDLINEA%TYPE)
    RETURN DETALLE_SERVICIO_TYPE;

  FUNCTION FNC_GET_IMPUESTO(P_IDIMPUESTO IMPUESTO.IDIMPUESTO%TYPE)
    RETURN NUMBER;

  FUNCTION FNC_GET_CODINSSRV_CP(P_CODSRV OPERACION.INSPRD.CODSRV%TYPE,
                                P_IDDET  OPERACION.INSPRD.IDDET%TYPE)
    RETURN OPERACION.INSPRD.CODINSSRV%TYPE;

  FUNCTION FNC_GET_PID_CP(P_CODSRV OPERACION.INSPRD.CODSRV%TYPE,
                          P_IDDET  OPERACION.INSPRD.IDDET%TYPE)
    RETURN OPERACION.INSPRD.PID%TYPE;

  FUNCTION FNC_LIST_SERVICIOS(P_SERVICES_TYPE SERVICES_TYPE) RETURN VARCHAR2;

  FUNCTION FNC_LIST_EQUIPOS(P_SERVICES_TYPE SERVICES_TYPE) RETURN VARCHAR2;

  FUNCTION FNC_GET_CODCLI RETURN VTATABCLI.CODCLI%TYPE;

  FUNCTION FNC_GET_IDINSXPAQ RETURN NUMBER;

  FUNCTION FNC_GET_SUCURSAL(P_CODSUC VTASUCCLI.CODSUC%TYPE)
    RETURN VTASUCCLI%ROWTYPE;

  FUNCTION FNC_VALIDAR_PRODUCTO_SLA(P_NUMSLC VTATABSLCFAC.NUMSLC%TYPE)
    RETURN NUMBER;

  FUNCTION FNC_SERVICIO_PRINCIPAL(P_IDGRUPO SALES.GRUPO_SISACT_LTE.IDGRUPO_SISACT%TYPE)
    RETURN BOOLEAN;

  FUNCTION FNC_SERVICIO_ADICIONAL(P_IDGRUPO SALES.GRUPO_SISACT_LTE.IDGRUPO_SISACT%TYPE)
    RETURN BOOLEAN;

  FUNCTION FNC_GET_CODSRV_COMODATO(P_IDGRUPO SALES.GRUPO_SISACT_LTE.IDGRUPO_SISACT%TYPE)
    RETURN SALES.TYSTABSRV.CODSRV%TYPE;

  FUNCTION FNC_SERVICIO_COMODATO(P_IDGRUPO           SALES.GRUPO_SISACT_LTE.IDGRUPO_SISACT%TYPE,
                                 P_IDGRUPO_PRINCIPAL SALES.GRUPO_SISACT_LTE.IDGRUPO_SISACT%TYPE)
    RETURN BOOLEAN;

  FUNCTION FNC_SERVICIO_ALQUILER(P_IDGRUPO           SALES.GRUPO_SISACT_LTE.IDGRUPO_SISACT%TYPE,
                                 P_IDGRUPO_PRINCIPAL SALES.GRUPO_SISACT_LTE.IDGRUPO_SISACT%TYPE)
    RETURN BOOLEAN;

  FUNCTION FNC_GET_AGENDA(ID_SIAC OPERACION.SIAC_POSTVENTA_PROCESO.IDPROCESS%TYPE)
    RETURN NUMBER;

  FUNCTION FNC_VALIDA_AGENDA_LTE(P_CODSOLOT OPERACION.SOLOT.CODSOLOT%TYPE)
    RETURN NUMBER;
  -- INI 2.0
  FUNCTION FNC_VALIDA_CP_LTE(P_CODSOLOT OPERACION.SOLOT.CODSOLOT%TYPE)
    RETURN NUMBER;
  -- FIN 2.0
  FUNCTION FNC_GET_DATOS_CP(P_NUMSLC OPERACION.SOLOT.NUMSLC%TYPE,
                            P_TIPEQU OPERACION.SOLOTPTOEQU.TIPEQU%TYPE,
                            P_TIPSRV SALES.TYSTABSRV.TIPSRV%TYPE,
                            P_TIPO   VARCHAR2) RETURN VARCHAR2;

  FUNCTION GET_POSTVENTA_CODSOLOT(P_IDPROCESS SIAC_POSTVENTA_PROCESO.IDPROCESS%TYPE)
    RETURN SOLOT.CODSOLOT%TYPE;
  -- Ini 3.0
  PROCEDURE SGASS_REGINSPRDBAJA(P_NUMSLC VTATABSLCFAC.NUMSLC%TYPE,
                                P_COD_ID SALES.SOT_SISACT.COD_ID%TYPE);

  PROCEDURE SGASP_REGLA_LTE(p_customer_id IN operacion.solot.customer_id%TYPE,
                            p_lista       IN OUT gc_lista,
                            p_resp        OUT NUMBER,
                            p_mens        OUT VARCHAR2);

  PROCEDURE SGASP_EQU_RECUP(p_customer_id IN operacion.solot.customer_id%TYPE,
                            p_lista       IN gc_lista,
                            p_resp        OUT NUMBER,
                            p_mens        OUT VARCHAR2);
  -- Fin 3.0
  --ini 4.0
  FUNCTION SGAFUN_VALIDA_CB_PLAN(P_CODSOLOT IN OPERACION.SOLOT.CODSOLOT%TYPE)
    RETURN NUMBER;

  FUNCTION SGAFUN_VALIDA_CB_PLAN_VISITA(P_CODSOLOT IN OPERACION.SOLOT.CODSOLOT%TYPE)
    RETURN NUMBER;

  PROCEDURE SGASI_CARGA_EQUDTH_LTE_CP(a_codsolot solot.codsolot%type);

  FUNCTION SGAFUN_GET_COD_ID_ANT(P_CUSTOMER_ID IN OPERACION.SOLOT.CUSTOMER_ID%TYPE)
    RETURN NUMBER;

  FUNCTION SGAFUN_GET_NUMERO_TELF_ACT(P_CO_ID IN OPERACION.SOLOT.COD_ID%TYPE)
    RETURN NUMBER;

  --ACTIVACION
  PROCEDURE SGASS_CONTROL_SERVICIOS(p_codsolot     IN NUMBER,
                                    p_tip_serv     OUT VARCHAR2,
                                    p_codigo_resp  OUT NUMBER,
                                    p_mensaje_resp OUT VARCHAR2);

  PROCEDURE SGASS_REGISTRO_ESTADO_LTE(p_codsolot       IN NUMBER,
                                      p_tipo_operacion IN VARCHAR2,
                                      p_codigo_resp    OUT NUMBER,
                                      p_mensaje_resp   OUT VARCHAR2);

  PROCEDURE SGASS_ACTUALIZA_ESTADO_LTE(p_codsolot       IN NUMBER,
                                       p_tipo_operacion IN VARCHAR2,
                                       p_mensaje        IN VARCHAR2,
                                       p_estado         IN VARCHAR2,
                                       p_codigo_resp    OUT NUMBER,
                                       p_mensaje_resp   OUT VARCHAR2);

  PROCEDURE SGASS_PROVISION_LTE_CP_CX(P_CODSOLOT       IN OPERACION.SOLOT.CODSOLOT%TYPE,
                                      P_IDTAREAWF      IN OPEWF.TAREAWF.IDTAREAWF%TYPE,
                                      P_TIPO_OPERACION IN VARCHAR2,
                                      P_COD            OUT NUMBER,
                                      P_MENSAJE        OUT VARCHAR2);

  PROCEDURE SGASS_PROVISION_LTE_CP_IL_JN(P_CODSOLOT       IN OPERACION.SOLOT.CODSOLOT%TYPE,
                                         P_IDTAREAWF      IN OPEWF.TAREAWF.IDTAREAWF%TYPE,
                                         P_TIPO_OPERACION IN VARCHAR2,
                                         P_COD            OUT NUMBER,
                                         P_MENSAJE        OUT VARCHAR2);

  PROCEDURE SGASS_PROVISION_LTE_CP_AUTO(P_SOLOT     OPERACION.SOLOT.CODSOLOT%TYPE,
                                        P_IDTAREAWF OPEWF.TAREAWF.IDTAREAWF%TYPE,
                                        P_COD_RESP  OUT NUMBER,
                                        P_MSJ_RESP  OUT VARCHAR2);

  PROCEDURE SGASS_ACTUALIZA_ESTADO_PROV(p_codsolot       IN NUMBER,
                                        p_tipo_operacion IN VARCHAR2,
                                        p_codigo_resp    OUT NUMBER,
                                        p_mensaje_resp   OUT VARCHAR2);

  PROCEDURE SGASS_ESTADO_PROV_IL(p_co_id        IN INTEGER,
                                 p_codigo_resp  OUT INTEGER,
                                 p_mensaje_resp OUT VARCHAR2);

  PROCEDURE SGASS_ESTADO_PROV_JN(p_co_id        IN INTEGER,
                                 p_codigo_resp  OUT INTEGER,
                                 p_mensaje_resp OUT VARCHAR2);

  PROCEDURE SGASS_PROCESA_EST_PROV(p_codsolot     IN NUMBER,
                                   p_codigo_resp  OUT INTEGER,
                                   p_mensaje_resp OUT VARCHAR2);

  PROCEDURE SGASS_VALIDA_PROV_3PLAY(a_idtareawf IN NUMBER,
                                    a_idwf      IN NUMBER,
                                    a_tarea     IN NUMBER,
                                    a_tareadef  IN NUMBER);

  PROCEDURE SGASS_ACTUALIZA_CNT_BSCS(a_idtareawf IN NUMBER,
                                     a_idwf      IN NUMBER,
                                     a_tarea     IN NUMBER,
                                     a_tareadef  IN NUMBER);

  PROCEDURE SGASS_REENVIAR_CONT_BSCS(p_codsolot     IN NUMBER,
                                     p_codigo_resp  OUT INTEGER,
                                     p_mensaje_resp OUT VARCHAR2);

  PROCEDURE SGASS_VALIDA_SERV_3PLAY(a_idtareawf in number,
                                    a_idwf      in number,
                                    a_tarea     in number,
                                    a_tareadef  in number);

  PROCEDURE SGASU_ACT_REQUEST_PEND(p_request    IN NUMBER,
                                   p_estado     IN VARCHAR2,
                                   p_errcode    IN INTEGER,
                                   p_errmsg     IN VARCHAR2,
                                   p_nrorequest IN NUMBER,
                                   p_resul      OUT NUMBER,
                                   p_mensaje    OUT VARCHAR2);

  PROCEDURE SGASU_REGISTRA_DECO_LTE(p_cod_id    in varchar2,
                                    p_seriedeco in varchar2,
                                    p_serietarj in varchar2,
                                    p_tipequipo in varchar2,
                                    p_tipdeco   in varchar2,
                                    p_resultado out integer,
                                    p_msgerr    out varchar2);

  PROCEDURE SGASU_ELIMINA_DECO_LTE(p_cod_id    in varchar2,
                                   p_seriedeco in varchar2,
                                   p_serietarj in varchar2,
                                   p_tipequipo in varchar2,
                                   p_tipdeco   in varchar2,
                                   p_resultado out integer,
                                   p_msgerr    out varchar2);

  PROCEDURE SGASS_VISITA_TECNICA(P_OPER VARCHAR2);

  PROCEDURE SGASI_CAMBIO_PLAN_JANUS(AN_CODSOLOT IN NUMBER,
                                    K_ERROR     OUT NUMBER,
                                    K_MENSAJE   OUT VARCHAR2);

  PROCEDURE SGASS_DESACTIVA_CONTRATO_BSCS(p_co_id        IN INTEGER,
                                          p_reason       IN INTEGER,
                                          p_codigo_resp  OUT INTEGER,
                                          p_mensaje_resp OUT VARCHAR2);

  PROCEDURE SGASI_INICIA_FACT(K_CODSOLOT IN NUMBER,
                              K_ERROR    OUT NUMBER,
                              K_MENSAJE  OUT VARCHAR2);

  PROCEDURE SGASI_ASIGNAR_NUMERO(k_codsolot IN NUMBER,
                                 k_numero   IN VARCHAR2,
                                 k_mensaje  IN OUT VARCHAR2,
                                 k_error    IN OUT NUMBER);

  PROCEDURE SGASS_OBTIENE_NROANT(k_codsolot IN NUMBER, k_numero OUT NUMBER);

  PROCEDURE SGASI_ASIGNA_NRO_LTE(a_idtareawf IN NUMBER,
                                 a_idwf      IN NUMBER,
                                 a_tarea     IN NUMBER,
                                 a_tareadef  IN NUMBER);

  FUNCTION SIACFUN_GET_PARAMETER(K_CAMPO VARCHAR2,
                                 K_TRAMA sales.siact_util_trama.TRAMV_TRAMA%TYPE)
    RETURN VARCHAR2;

  PROCEDURE SGASI_REG_PLAN_COMERCIAL(K_IDTAREAWF IN NUMBER,
                                     K_IDWF      IN NUMBER,
                                     K_TAREA     IN NUMBER,
                                     K_TAREADEF  IN NUMBER);

  PROCEDURE SGASU_ROLLBACK_CP(k_codsolot IN NUMBER,
                              k_error    IN OUT NUMBER,
                              k_mensaje  IN OUT VARCHAR2);

  PROCEDURE SGASP_EST_SOLOT(p_codsolot    operacion.solot.codsolot%type,
                            p_estsol      operacion.solot.estsol%type,
                            p_observacion operacion.solot.observacion%type,
                            p_resp        OUT NUMBER,
                            p_mens        OUT VARCHAR2);

  PROCEDURE SGASS_CONSULTA_EQU(av_customer_id IN VARCHAR2,
                               av_cod_id      IN VARCHAR2,
                               ac_equ_cur     OUT sales.pq_postventa_unificada.gc_salida,
                               an_resultado   OUT NUMBER,
                               av_mensaje     OUT VARCHAR2);
  --fin 4.0
  --INI 5.0
  PROCEDURE SGASU_ACT_TOPE_CONSUMO(PI_CODSOLOT IN NUMBER,
                                   PO_ERROR    OUT NUMBER,
                                   PO_MENSAJE  OUT VARCHAR2);
  --fin 5.0

  PROCEDURE SGASS_DET_EQUIPO_LTE(K_COD_ID  operacion.solot.cod_id%TYPE,
                                 K_CURSOR  OUT SYS_REFCURSOR,
                                 K_ERROR   OUT NUMBER,
                                 K_MENSAJE OUT VARCHAR2);

  FUNCTION SGAFUN_TIPSRV(PI_CODSRV OPERACION.inssrv.CODSRV%TYPE)
    RETURN VARCHAR2;

  PROCEDURE SGASI_PROV_JANUS(PI_IDTAREAWF IN NUMBER,
                             PI_IDWF      IN NUMBER,
                             PI_TAREA     IN NUMBER,
                             PI_TAREADEF  IN NUMBER);

  PROCEDURE SGASI_PROV_CONTEGO_SV(PI_CODSOLOT IN OPERACION.SOLOT.CODSOLOT%TYPE,
                                  PI_NUMSERIE IN OPERACION.SOLOTPTOEQU.NUMSERIE%TYPE,
                                  PO_ERROR    OUT NUMBER,
                                  PO_MENSAJE  OUT VARCHAR2);

  PROCEDURE SGASI_PROV_INTERNET(PI_CODSOLOT IN NUMBER,
                                PO_ERROR    OUT NUMBER,
                                PO_MENSAJE  OUT VARCHAR2);

  PROCEDURE SGASI_REG_IMSI_MSISDN(PI_CODSOLOT   IN SOLOT.CODSOLOT%TYPE,
                                  PI_COD_ID     IN SOLOT.COD_ID%TYPE,
                                  PI_COD_ID_OLD IN SOLOT.COD_ID_OLD%TYPE,
                                  PO_ERROR      OUT NUMBER,
                                  PO_MENSAJE    OUT VARCHAR2);

  PROCEDURE SGASI_INSERTA_EQUIPO_FIJA(AR_EQUIPO IN OPERACION.SGAT_EQUIPO_SERVICIO_FIJA%ROWTYPE,
                                      AN_ERROR  OUT NUMBER,
                                      AV_ERROR  OUT VARCHAR2);

  --ini 9.0
  PROCEDURE SGAI_CARGA_EQUIPO_POST(AN_CODSOLOT IN SOLOT.CODSOLOT%TYPE,
                                    AN_ERROR    OUT NUMBER,
                                    AV_ERROR    OUT VARCHAR2);
  --fin 9.0
END;
/