create or replace package operacion.pq_deco_adicional_lte is
 /*******************************************************************************
  PROPOSITO: Incluir el registro de una solicitud de orden trabajo que contemple un
             nuevo tipo y flujo de trabajo para la atención de instalación de
             decodificadores adicionales que solicite el cliente.

  Version  Fecha       Autor             Solicitado por     Descripcion
  -------  ----------  ----------------  ----------------   -----------
  1.0      2014-10-09  Edwin Vasquez     Hector Huaman      Deco Adicional
  2.0      2014-11-07  Edwin Vasquez     Hector Huaman      Deco Adicional servicios
  3.0      2015-01-22  Freddy Gonzales   Hector Huaman      Registrar datos en la tabla sales.int_negocio_instancia
  4.0      2015-10-29  Luis Polo         Hector Huaman      PROY-LTE
  5.0      2015-11-24  Alfonso Muñante                     SD-438726 Deco Adicional
  6.0      2015-12-31  Emma Guzman       Emma Guzman         SD-616407
  7.0      2016-05-30  Luis Polo B.      Karen Vasquez      SGA-SD-794552
  8.0      2017-03-02  Danny Sánchez     Mauro Zegarra      SGA-INC000000726842
  9.0      2018-05-24  Marleny Teque     Justiniano Condori [IDEA-40758/PROY-32581-Postventa LTE/HFC] - [Deco Adicional]
 10.0      2018-08-01  Marleny Teque     Justiniano Condori [IDEA-40758/PROY-32581-Postventa LTE/HFC] - [Deco Adicional]
                       Abel Ojeda
 11.0      2018-10-03  Marleny Teque     Luis Flores        [IDEA-40758/PROY-32581-Postventa LTE/HFC] - [Deco Adicional]
 12.0      2018-11-08  Marleny Teque     Luis Flores        [IDEA-40758/PROY-32581-Postventa LTE/HFC] - [Deco Adicional]
 13.0      2018-10-22  Marleny Teque     Luis Flores        [IDEA-40758/PROY-32581-Postventa LTE/HFC] - [Deco Adicional]
 14.0      2018-11-07  Marleny Teque     Luis Flores        [IDEA-40758/PROY-32581-Postventa LTE/HFC] - [Deco Adicional]
 15.0      2018-11-15  Luis Flores       Luis Flores        [IDEA-40758/PROY-32581-Postventa LTE/HFC] - [Deco Adicional]
 16.0      2018-11-28  Marleny Teque     Luis Flores        [IDEA-40758/PROY-32581-Postventa LTE/HFC] - [Deco Adicional]
 17.0      2018-12-03  Marleny Teque     Luis Flores        [IDEA-40758/PROY-32581-Postventa LTE/HFC] - [Deco Adicional]
 18.0      2019-01-28  Jose Arriola      Luis Flores        [IDEA-40758/PROY-32581-Postventa LTE/HFC] - [Deco Adicional]
 19.0      2019-03-05  Abel Ojeda        Luis Flores        [IDEA-40758/PROY-32581-Postventa LTE/HFC] - [Deco Adicional]
 20.0      2019-03-18  Abel Ojeda        Luis Flores        [IDEA-40758/PROY-32581-Postventa LTE/HFC] - [Deco Adicional]
 21.0      2019-03-25  Abel Ojeda        Luis Flores        [IDEA-40758/PROY-32581-Postventa LTE/HFC] - [Deco Adicional]
  *******************************************************************************/
  type detalle_idlinea_type is record(
    flgprincipal detalle_paquete.flgprincipal%type,
    idproducto   detalle_paquete.idproducto%type,
    codsrv       linea_paquete.codsrv%type,
    codequcom    linea_paquete.codequcom%type,
    idprecio     define_precio.idprecio%type,
    cantidad     linea_paquete.cantidad%type,
    moneda_id    define_precio.moneda_id%type,
    idpaq        detalle_paquete.idpaq%type,
    iddet        detalle_paquete.iddet%type,
    paquete      detalle_paquete.paquete%type,
    banwid       tystabsrv.banwid%type);

  type detalle_vtadetptoenl_type is record(
    descpto     vtadetptoenl.descpto%type,
    dirpto      vtadetptoenl.dirpto%type,
    ubipto      vtadetptoenl.ubipto%type,
    codsuc      vtadetptoenl.codsuc%type,
    codinssrv   vtadetptoenl.codinssrv%type,
    estcts      vtadetptoenl.estcts%type,
    tipsrv      solot.tipsrv%type,
    codcli      solot.codcli%type,
    cantidad    vtadetptoenl.cantidad%type,
    areasol     solot.areasol%type,
    customer_id solot.customer_id%type,
    iddet       detalle_paquete.iddet%type,
    idpaq       paquete_venta.idpaq%type,
  idsolucion  vtatabslcfac.idsolucion%TYPE,  --6.00
    flgsrv_pri  vtadetptoenl.flgsrv_pri%TYPE); --6.00
    C_BAJA        CONSTANT CHAR(1) := 'B';  --9.00
    -- Ini 10.00
    C_ACTION_BAJA  CONSTANT NUMBER := 105;
    C_ACTION_ACTIVACION  CONSTANT NUMBER := 103;
    C_ACTION_ALTA        CONSTANT NUMBER := 101;
    C_BAJA_EQU           CONSTANT NUMBER := 12;
    C_ALTA_EQU           CONSTANT NUMBER := 4;
    C_TIPEQU_TARJ        CONSTANT NUMBER := 7242;
    C_PROV_OK            CONSTANT CHAR(1) := '3';
    C_GENERADO           CONSTANT CHAR(1) := '1';
    C_ENVIADO            CONSTANT CHAR(1) := '2';
    C_TIP_BOUQUET_BAJA   CONSTANT VARCHAR(4) := 'BAJA';
    C_ALTA               CONSTANT CHAR(1) := 'A';
    C_DESACTIVO          CONSTANT CHAR(1) := '0';
    C_ACTIVADO           CONSTANT CHAR(1) := '1';
    C_TIP_BOUQUET_ALTA   CONSTANT VARCHAR(4) := 'ALTA';
    C_MSG_CANCELADO      CONSTANT VARCHAR2(35) := 'CANCELADO A PETICION DEL USUARIO';
    C_PROV_CANCELADO     CONSTANT CHAR(1) := '6';
    C_SP_REGCONTEGO      CONSTANT VARCHAR2(20) := 'SGASI_REGCONTEGOHIST';
    -- Fin 10.00
  function deco_adicional(p_idprocess     siac_postventa_proceso.idprocess%type,
                          p_idinteraccion sales.sisact_postventa_det_serv_hfc.idinteraccion%type,
                          p_cod_id        sales.sot_sisact.cod_id%type,
                          p_cargo         solot.cargo%type)
    return solot.codsolot%type;

  procedure validar_equipo_servicio(p_idinteraccion sales.sisact_postventa_det_serv_hfc.idinteraccion%type);

  function es_servicio_alquiler(p_idgrupo           sales.grupo_sisact.idgrupo_sisact%type,
                                p_idgrupo_principal sales.grupo_sisact.idgrupo_sisact%type)
    return boolean;

  function es_servicio_principal(p_idgrupo sales.grupo_sisact.idgrupo_sisact%type)
    return boolean;

  function es_servicio_comodato(p_idgrupo           sales.grupo_sisact.idgrupo_sisact%type,
                                p_idgrupo_principal sales.grupo_sisact.idgrupo_sisact%type)
    return boolean;

  function es_servicio_adicional(p_idgrupo sales.grupo_sisact.idgrupo_sisact%type)
    return boolean;

  function grupo_servicios(p_tip_servicio opedd.abreviacion%type,
                           p_cod_servicio sales.grupo_sisact.idgrupo_sisact%type)
    return boolean;

  function registrar_venta(p_idprocess     siac_postventa_proceso.idprocess%type,
                           p_idinteraccion sales.sisact_postventa_det_serv_hfc.idinteraccion%type,
                           p_cod_id        sales.sot_sisact.cod_id%type)
    return vtatabslcfac.numslc%type;

  procedure crear_srv_instalacion(p_numslc               vtatabslcfac.numslc%type,
                                  p_detalle_vtadetptoenl detalle_vtadetptoenl_type);

  function crea_instalacion return boolean;

  procedure registrar_insprd(p_cod_id sales.sot_sisact.cod_id%type,
                             p_numslc vtatabslcfac.numslc%type);

  function registrar_solot(p_idprocess siac_postventa_proceso.idprocess%type,
                           p_cod_id    sales.sot_sisact.cod_id%type,
                           p_numslc    vtatabslcfac.numslc%type,
                           p_cargo     solot.cargo%type)
    return solot.codsolot%type;

  procedure registrar_solotpto(p_cod_id   sales.sot_sisact.cod_id%type,
                               p_numslc   solot.numslc%type,
                               p_codsolot solot.codsolot%type,
                               p_idinteraccion       sales.sisact_postventa_det_serv_lte.idinteraccion%type,  --11.0
                               p_accion   varchar2);  --11.0

  function get_codmotot return opedd.codigon%type;

  function get_wfdef return number;

  function get_parametro_deco(p_abreviacion opedd.abreviacion%type,
                              p_codigon_aux opedd.codigon_aux%type)
    return varchar2;

  function get_codinssrv(p_cod_id sales.sot_sisact.cod_id%type)
    return inssrv.codinssrv%type;

  function existe_equipo(p_idgrupo sales.equipo_sisact.grupo%type,
                         p_tipequ  sales.equipo_sisact.tipequ%type)
    return boolean;

  function existe_servicio(p_servicio sales.servicio_sisact.idservicio_sisact%type)
    return boolean;

  procedure crear_idlinea_equipo(p_comodato sales.pq_comodato_sisact_lte.comodato_type, -- 6.0
                                 p_idlinea  out sales.linea_paquete.idlinea%type);

  procedure crear_idlinea_servicio(p_servicio sales.pq_servicio_sisact_lte.servicio_type, -- 6.0
                                   p_idlinea  out linea_paquete.idlinea%type,
                                   p_codsrv   out tystabsrv.codsrv%type);

  function ubicar_idlinea_equipo(p_tipequ  sales.sisact_postventa_det_serv_hfc.tipequ%type,
                                 p_idgrupo sales.sisact_postventa_det_serv_hfc.idgrupo%type)
    return linea_paquete.idlinea%type;

  function ubicar_idlinea_servicio(p_servicio sales.servicio_sisact.idservicio_sisact%type)
    return linea_paquete.idlinea%type;

  function detalle_idlinea(p_idlinea linea_paquete.idlinea%type)
    return detalle_idlinea_type;

  function detalle_vtadetptoenl_alta(p_cod_id sales.sot_sisact.cod_id%type)
    return detalle_vtadetptoenl_type;

  function ubicar_servicio_instalacion return tystabsrv%rowtype;

  function get_codsrv return tystabsrv.codsrv%type;  --6.0

  function detalle_idlinea_instalacion(p_idlinea linea_paquete.idlinea%type)
    return detalle_idlinea_type;

  procedure aplicar_cambio(p_val_err varchar2);

  FUNCTION f_get_tiptra(p_idprocess IN NUMBER) RETURN NUMBER; --4.0

  FUNCTION f_get_wfdef_adc RETURN NUMBER; --4.0

    --<ini 6.0>
  FUNCTION get_wfdef_adi RETURN NUMBER;

  FUNCTION es_servicio_adicional_lte(p_idgrupo sales.grupo_sisact.idgrupo_sisact%TYPE)
    RETURN BOOLEAN;

  FUNCTION grupo_servicios_lte(p_tip_servicio opedd.abreviacion%TYPE,
                               p_cod_servicio sales.grupo_sisact.idgrupo_sisact%TYPE)
    RETURN BOOLEAN;

  FUNCTION es_servicio_comodato_lte(p_idgrupo           sales.grupo_sisact.idgrupo_sisact%TYPE,
                                    p_idgrupo_principal sales.grupo_sisact.idgrupo_sisact%TYPE)
    RETURN BOOLEAN;

  FUNCTION es_servicio_alquiler_lte(p_idgrupo           sales.grupo_sisact.idgrupo_sisact%TYPE,
                                    p_idgrupo_principal sales.grupo_sisact.idgrupo_sisact%TYPE)
    RETURN BOOLEAN;

  FUNCTION existe_servicio_lte(p_servicio sales.servicio_sisact.idservicio_sisact%TYPE)
    RETURN BOOLEAN;

  FUNCTION es_servicio_principal_lte(p_idgrupo sales.grupo_sisact.idgrupo_sisact%TYPE)
    RETURN BOOLEAN;

  FUNCTION ubicar_idlinea_servicio_lte(p_servicio sales.servicio_sisact.idservicio_sisact%TYPE)
    RETURN linea_paquete.idlinea%TYPE;

  FUNCTION detalle_idlinea_lte(p_idlinea linea_paquete.idlinea%TYPE)
    RETURN detalle_idlinea_type;

  FUNCTION get_parametro_deco_lte(p_abreviacion opedd.abreviacion%TYPE,
                                  p_codigon_aux opedd.codigon_aux%TYPE)
    RETURN VARCHAR2;

  FUNCTION f_valida_deco_lte(ln_codsolot operacion.solot.codsolot%TYPE)
    RETURN NUMBER;

  PROCEDURE p_gen_detalle_sot(p_solot         operacion.solot.codsolot%TYPE,
                              p_idinteraccion sales.sisact_postventa_det_serv_hfc.idinteraccion%TYPE,
                              an_resultado    OUT NUMBER,
                              av_mensaje      OUT VARCHAR2);

  FUNCTION f_obt_tipo_deco(p_codsolot solot.codsolot%TYPE) RETURN NUMBER;

  FUNCTION f_obt_data_numslc_ori(l_codsolot solot.codsolot%TYPE)
    RETURN VARCHAR2;

  FUNCTION f_obt_data_vta_ori(l_codsolot solot.codsolot%TYPE) RETURN VARCHAR2;

  FUNCTION f_max_sot_x_cod_id(an_cod_id NUMBER) RETURN NUMBER;
  PROCEDURE p_tipo_deco_lte(p_tipequ    IN NUMBER,
                            p_tipo_deco OUT VARCHAR2,
                            p_cod       OUT NUMBER,
                            p_mensaje   OUT VARCHAR2);
  --<fin 6.0>
  --<Ini 9.0>
  FUNCTION SGAFUN_DECO_ADIC(PI_ID_PROCESS     siac_postventa_proceso.idprocess%TYPE,
                            PI_TIPTRA         NUMBER,
                            PI_ID_INTERACCION sales.sisact_postventa_det_serv_lte.idinteraccion%TYPE,
                            PI_COD_ID         sales.sot_sisact.cod_id%TYPE,
                            PI_CUSTOMER_ID    NUMBER,
                            PI_CARGO          solot.cargo%TYPE)
  RETURN solot.codsolot%type;

  FUNCTION SGAFUN_REGISTRAR_VENTA(PI_IDPROCESS      siac_postventa_proceso.idprocess%type,
                                PI_ID_INTERACCION sales.sisact_postventa_det_serv_lte.idinteraccion%type,
                                PI_COD_ID          sales.sot_sisact.cod_id%type)
    RETURN vtatabslcfac.numslc%type;

  FUNCTION SGAFUN_UBICAR_IDLINEA_EQUIPO(PI_TIPEQU  sales.sisact_postventa_det_serv_lte.tipequ%type,
                                        PI_IDGRUPO sales.sisact_postventa_det_serv_lte.idgrupo%type)
    RETURN linea_paquete.idlinea%type;

  PROCEDURE SGASI_VALID_EQU_SERV(PI_ID_INTERACCION sales.sisact_postventa_det_serv_lte.idinteraccion%type);

  PROCEDURE SGASU_GEN_DETALLE_SOT(PI_SOLOT         operacion.solot.codsolot%TYPE,
                                PI_IDINTERACCION sales.sisact_postventa_det_serv_lte.idinteraccion%TYPE,
                                PI_TIPTRA        operacion.solot.tiptra%TYPE, --11.0
                                PO_RESULTADO    OUT NUMBER,
                                PO_MENSAJE      OUT VARCHAR2);

  PROCEDURE SGASD_ELIMINA_DECO_LTE(PI_IDINTERACCION SALES.SISACT_POSTVENTA_DET_SERV_LTE.IDINTERACCION%TYPE,
                                 PI_ACTION        SALES.SISACT_POSTVENTA_DET_SERV_LTE.FLAG_ACCION%TYPE,
                                 PO_RESULTADO     OUT NUMBER,
                                 PO_MENSAJE       OUT VARCHAR2);

  PROCEDURE SGASU_BAJA_EQUIPOS(PI_CODSOLOT   IN operacion.solot.codsolot%TYPE,
                               PI_ACCION     IN CHAR,
                               PI_ASOC       IN sales.sisact_postventa_det_serv_lte.asoc%type,
                               PO_RESULTADO  OUT NUMBER,
                               PO_MENSAJE    OUT VARCHAR2);

  PROCEDURE SGASU_VALIDA_DES_DECO(PI_IDTAREAWF IN NUMBER,
                                  PI_IDWF      IN NUMBER,
                                  PI_TAREA     IN NUMBER,
                                  PI_TAREADEF  IN NUMBER);

  procedure sgass_matriz_decos(po_cantidad out number,
                               po_matriz out sys_refcursor,
                               po_mensaje out varchar2,
                               po_cod_error out number,
                               po_msg_error out varchar2);
  --<fin 9.0>
  --<Ini 10.0>
  procedure SGASS_LISTA_DECOS_DESINS(PI_CODSOLOT    IN SOLOT.CODSOLOT%TYPE,
                                     PO_LISTA       OUT SYS_REFCURSOR);

  PROCEDURE SGASU_BAJA_DECO_CONTEGO(PI_CODSOLOT   IN SOLOT.CODSOLOT%TYPE,
                                    PI_SERIE_TARJ IN OPERACION.TABEQUIPO_MATERIAL.NUMERO_SERIE%TYPE,
                                    PO_RESPUESTA   IN OUT VARCHAR2,
                                    PO_MENSAJE     IN OUT VARCHAR2);

  PROCEDURE SGASU_DESACTIVARBOUQUET_CTG(PI_CODSOLOT   IN SOLOT.CODSOLOT%TYPE,
                                    PI_SERIE_TARJ IN OPERACION.TABEQUIPO_MATERIAL.NUMERO_SERIE%TYPE,
                                    PO_RESPUESTA   IN OUT VARCHAR2,
                                    PO_MENSAJE     IN OUT VARCHAR2);

  PROCEDURE SGASU_BAJA_SOLOTPTOEQU(PI_CODSOLOT   IN operacion.solot.codsolot%TYPE,
                                   PI_ACCION     IN CHAR,
                                   PI_ASOC       IN sales.sisact_postventa_det_serv_lte.asoc%type,
                                   PI_ID_ACT     IN NUMBER,
                                   PO_RESULTADO  OUT NUMBER,
                                   PO_MENSAJE    OUT VARCHAR2);

  FUNCTION SGAFUN_OBT_BOUQUET(PI_COD_ID         NUMBER,
                              PI_CUSTOMER_ID    NUMBER) RETURN VARCHAR2;

  PROCEDURE SGASS_LISTA_EQUIPO_CONAX_LTE (PI_CODSOLOT    IN SOLOT.CODSOLOT%TYPE,
                                          PO_LISTA       OUT SYS_REFCURSOR);

  PROCEDURE SGASS_LISTA_TARJETA_DECO_ASOC (PI_CODSOLOT   IN SOLOT.CODSOLOT%TYPE,
                                          PO_LISTA       OUT SYS_REFCURSOR);

  PROCEDURE SGASU_VALIDACION_MIXTO(PI_IDTAREAWF IN NUMBER,
                                     PI_IDWF      IN NUMBER,
                                     PI_TAREA     IN NUMBER,
                                     PI_TAREADEF  IN NUMBER);

  PROCEDURE SGASI_INSERT_TARJ_DECO_ASOC (PI_CODSOLOT    IN SOLOT.CODSOLOT%TYPE,
                                         PI_IDDECO      IN NUMBER,
                                         PI_MAC         IN VARCHAR2,
                                         PI_IDTARJETA   IN NUMBER,
                                         PI_NUMSERIE    IN VARCHAR2);

  PROCEDURE SGASU_SERIE_SOLOTPTOEQU (PI_CODSOLOT IN SOLOT.CODSOLOT%TYPE,
                                     PI_PUNTO    IN NUMBER,
                                     PI_ORDEN    IN NUMBER,
                                     PI_NUMSERIE IN VARCHAR2,
                                     PI_MAC      IN VARCHAR2);

  PROCEDURE SGASU_VALIDA_INST_DECO(PI_CODSOLOT   IN operacion.solot.codsolot%TYPE,
                                   PO_RESULTADO  OUT NUMBER,
                                   PO_MENSAJE    OUT VARCHAR2);

  PROCEDURE SGASI_ALTA_MIXTO(PI_NUMREGISTRO OPERACION.OPE_SRV_RECARGA_CAB.NUMREGISTRO%TYPE,
                             PO_RESPUESTA   IN OUT VARCHAR2,
                             PO_MENSAJE     IN OUT VARCHAR2);

  PROCEDURE SGASI_ACTIVARBOUQUET(PI_NUMREGISTRO OPERACION.OPE_SRV_RECARGA_CAB.NUMREGISTRO%TYPE,
                                 PI_CODSOLOT    OPERACION.SOLOT.CODSOLOT%TYPE,
                                 PI_NUMSERIE    OPERACION.SOLOTPTOEQU.NUMSERIE%TYPE DEFAULT NULL, --12.0
                                 PO_RESPUESTA   IN OUT VARCHAR2,
                                 PO_MENSAJE     IN OUT VARCHAR2);

  PROCEDURE SGASS_ESTADO_SOLOT_CONTEGO(PI_CODSOLOT    IN SOLOT.CODSOLOT%TYPE,
                                       PI_NUM_SERIE   IN VARCHAR2,
                                       PO_LISTA       OUT SYS_REFCURSOR);

  function SGASI_REGISTRAR_VENTA_MIXTO(PI_IDPROCESS      siac_postventa_proceso.idprocess%type,
                                PI_ID_INTERACCION sales.sisact_postventa_det_serv_lte.idinteraccion%type,
                                PI_COD_ID          sales.sot_sisact.cod_id%type)
     RETURN vtatabslcfac.numslc%type;

  PROCEDURE SGASS_DATOSXSOLOT(K_CODSOLOT IN OPERACION.SOLOT.CODSOLOT%TYPE,
                              K_DATOS    OUT SYS_REFCURSOR);

  PROCEDURE SGASI_ALTA_MIXTO_ACTION(PI_NUMREGISTRO OPERACION.OPE_SRV_RECARGA_CAB.NUMREGISTRO%TYPE,
                                    PI_ACTION      IN NUMBER,
                                    PI_NUMSERIE    IN VARCHAR2,
                                    PO_RESPUESTA   IN OUT VARCHAR2,
                                    PO_MENSAJE     IN OUT VARCHAR2);

  FUNCTION SGAFUN_VALIDA_SOT(PI_CODSOLOT OPERACION.SGAT_TRXCONTEGO.TRXN_CODSOLOT%TYPE,
                             PI_SERIE    OPERACION.SGAT_TRXCONTEGO.TRXV_SERIE_TARJETA%TYPE)
    RETURN NUMBER;

  PROCEDURE SGASI_REGCONTEGOHIST(PI_CODSOLOT  IN OPERACION.SGAT_TRXCONTEGO.TRXN_CODSOLOT%TYPE,
                                 PI_SERIE IN OPERACION.SGAT_TRXCONTEGO.TRXV_SERIE_TARJETA%TYPE,
                                 PO_RESPUESTA OUT NUMBER);

  PROCEDURE sgasi_valida_dec_adc(pi_idtareawf IN NUMBER,
                                 pi_idwf      IN NUMBER,
                                 pi_tarea     IN NUMBER,
                                 pi_tareadef  IN NUMBER);
--<fin 10.0>
--<Ini 12.0>
  PROCEDURE SGASU_ACTUALIZAR_PID(PI_CODSOLOT   IN operacion.solot.codsolot%TYPE,
                                 PI_TIPTRS     IN operacion.solotpto.tiptrs%type,
                                 PI_ESTADO     IN operacion.insprd.estinsprd%type,
                                 PO_RESULTADO  OUT NUMBER,
                                 PO_MENSAJE    OUT VARCHAR2);
                                 
  PROCEDURE SGASI_REGISTRAR_CARGO_REC_DECO(PI_CODSOLOT  IN operacion.solot.codsolot%TYPE,
                                           PO_RESULTADO OUT NUMBER,
                                           PO_MENSAJE   OUT VARCHAR2);

  FUNCTION SGAFUN_OBT_BOUQUET_ACT(PI_COD_ID operacion.solot.cod_id%type)
    RETURN VARCHAR2;
--<fin 12.0>
--<Ini 21.0>
  PROCEDURE SGASS_EQUIPOXPUNTOXSOT(PI_CODSOLOT   IN operacion.solot.codsolot%TYPE,
                                   PI_CODIGO     IN NUMBER,
                                   PI_NUMSERIE   IN VARCHAR2,                                  
                                   PO_CURSOR     OUT SYS_REFCURSOR);
  
--<fin 21.0>
end;
/