CREATE OR REPLACE PACKAGE operacion.pkg_visita_sga_ce IS
  /****************************************************************
  '* Nombre Package : OPERACION.PKG_VISITA_SGA_CE
  '* Propósito : Agrupar funcionalidades para los procesos de
  Postventa CE
  '* Input : --
  '* Output : --
  '* Creado por : Equipo de proyecto TOA
  '* Fec. Creacion : 24/07/2018
  '* Fec. Actualizacion : 02/08/2018
  Ver        Date        Author              Solicitado por       Descripcion
  ---------  ----------  ------------------- ----------------   ------------------------------------
  1.0        04/09/2018  Obed Ortiz                               PROY-32581 - Actualizar Observacion_2 TOA
  2.0        25/10/2018  Jose Arriola        Juan Cuya            PROY-32581_SGA12
  3.0        22/11/2018  Equipo TOA          Juan Cuya            PROY-32581_SGA13
  4.0        28/11/2018  Equipo TOA          Juan Cuya            PROY-32581_SGA15
  5.0        07/12/2018  Equipo TOA          Juan Cuya            PROY-32581_SGA16
  6.0        15/01/2019  Abel Ojeda          Luis Flores          PROY-32581_SGA20
  '****************************************************************/

  cn_opcion             CONSTANT NUMBER := 14;
  cv_internet           CONSTANT CHAR(4) := '0006';
  cv_telefonia          CONSTANT CHAR(4) := '0004';
  cv_cable              CONSTANT CHAR(4) := '0062';
  cn_idinterfase_cm     CONSTANT NUMBER := 620;
  cn_idinterfase_mta    CONSTANT NUMBER := 820;
  cn_idinterfase_ep     CONSTANT NUMBER := 824;
  cn_idinterfase_fac    CONSTANT NUMBER := 830;
  cn_idinterfase_stb    CONSTANT NUMBER := 2020;
  cn_idinterfase_canal  CONSTANT NUMBER := 2030;
  cn_idinterfase_vod    CONSTANT NUMBER := 2050;
  cv_desc_trx_postv     CONSTANT VARCHAR(30) := 'HFC CE Transacciones Postventa';
  cv_abrv_trx_postv     CONSTANT VARCHAR(30) := 'CEHFCPOST';
  cv_var_env_proy_nuevo CONSTANT VARCHAR(1) := 'T';
  cv_var_eq_bam         CONSTANT VARCHAR(30) := 'EQUIPOS BAM';
  cn_estado_activo      CONSTANT NUMBER := 1; --3.0
  cv_tabla_zona         CONSTANT VARCHAR2(40) := 'zona_adc'; --3.0
  cv_tabla_planozona    CONSTANT VARCHAR2(40) := 'vtatabgeoref'; --3.0
  TYPE gc_salida IS REF CURSOR;
  CV_ABUSCAR            CONSTANT VARCHAR2(1) := '_'; --6.0
  CV_AREEMPLAZAR        CONSTANT VARCHAR2(1) := ' '; --6.0

  TYPE valores_srv IS RECORD(
    ln_val_ctv_old NUMBER,
    ln_val_int_old NUMBER,
    ln_val_tlf_old NUMBER,
    ln_val_ctv_new NUMBER,
    ln_val_int_new NUMBER,
    ln_val_tlf_new NUMBER,
    ln_des_ctv_old VARCHAR2(300), ---Sprint 7 TOA
    ln_des_int_old VARCHAR2(300),
    ln_des_tlf_old VARCHAR2(300),
    ln_des_ctv_new VARCHAR2(300),
    ln_des_int_new VARCHAR2(300),
    ln_des_tlf_new VARCHAR2(300));
  PROCEDURE sgass_orden_visita(pi_tipo_trx   VARCHAR2,
                               pi_codcli     VARCHAR2,
                               pi_numslc_old VARCHAR2,
                               pi_numslc_new VARCHAR2,
                               pi_codsuc     VARCHAR2,
                               po_flg_visita OUT NUMBER,
                               po_codmotot   OUT NUMBER,
                               po_errorc     OUT NUMBER,
                               po_errorm     OUT VARCHAR2,
                               po_anotacion  OUT VARCHAR2,
                               po_subtipo    OUT VARCHAR2,
                               po_tipo       OUT VARCHAR2);

  FUNCTION sgafun_val_cfg_codequcom(pi_codequcom_new VARCHAR2,
                                    pi_codequcom_old VARCHAR2) RETURN NUMBER;

  FUNCTION sgafun_val_tipsrv_old(pi_numslc_old  sales.vtadetptoenl.numslc%TYPE,
                                 pi_tipservicio operacion.sga_visita_tecnica_ce.tipservicio%TYPE)
    RETURN NUMBER;

  FUNCTION sgafun_val_tipsrv_new(pi_numslc_new  sales.vtadetptoenl.numslc%TYPE,
                                 pi_tipservicio operacion.sga_visita_tecnica_ce.tipservicio%TYPE)
    RETURN NUMBER;

  FUNCTION sgafun_get_codmotot_visit(pi_tipo VARCHAR2, pi_visita VARCHAR2)
    RETURN NUMBER;

  PROCEDURE sgasi_log_post_ce(pi_postv_numslc   operacion.sgat_postventasce_log.postv_numslc%TYPE,
                              pi_postv_codcli   operacion.sgat_postventasce_log.postv_codcli%TYPE,
                              pi_postv_proceso  operacion.sgat_postventasce_log.postv_proceso%TYPE,
                              pi_postv_msgerror operacion.sgat_postventasce_log.postv_msgerror%TYPE);

  FUNCTION sgafun_val_cantequ_old(pi_numslc_old  operacion.sga_visita_tecnica_ce.numslc_old%TYPE,
                                  pi_tipservicio operacion.sga_visita_tecnica_ce.tipservicio%TYPE)
    RETURN NUMBER;

  FUNCTION sgafun_val_cantequ_new(pi_numslc_new  operacion.sga_visita_tecnica_ce.numslc_new%TYPE,
                                  pi_tipservicio operacion.sga_visita_tecnica_ce.tipservicio%TYPE)
    RETURN NUMBER;

  FUNCTION sgafun_val_recuperable(pi_codsolot operacion.solot.codsolot%TYPE,
                                  pi_tipsrv   tystipsrv.tipsrv%TYPE)
    RETURN NUMBER;

  FUNCTION sgafun_val_tipdeco(pi_numslc_old  operacion.sga_visita_tecnica_ce.numslc_old%TYPE,
                              pi_numslc_new  operacion.sga_visita_tecnica_ce.numslc_new%TYPE,
                              pi_tipservicio operacion.sga_visita_tecnica_ce.tipservicio%TYPE)
    RETURN NUMBER;

  PROCEDURE sgass_get_val_internet_eq(pi_numslc_old  operacion.sga_visita_tecnica_ce.numslc_old%TYPE,
                                      pi_numslc_new  operacion.sga_visita_tecnica_ce.numslc_new%TYPE,
                                      pi_tipservicio operacion.sga_visita_tecnica_ce.tipservicio%TYPE,
                                      po_flag        OUT NUMBER,
                                      po_errorc      OUT NUMBER,
                                      po_errorm      OUT VARCHAR2);

  FUNCTION sgafun_get_nombre_equ(pi_codequcom vtaequcom.codequcom%TYPE)
    RETURN vtaequcom.dscequ%TYPE;

  FUNCTION sgafun_format_vacio(pi_cad VARCHAR2) RETURN VARCHAR2;

  FUNCTION sgafun_get_codequ_old(pi_numslc operacion.sga_visita_tecnica_ce.numslc_old%TYPE)
    RETURN VARCHAR2;

  FUNCTION sgafun_get_codequ_new(pi_numslc operacion.sga_visita_tecnica_ce.numslc_new%TYPE)
    RETURN VARCHAR2;

  FUNCTION sgafun_inicia_valores(pi_numslc_old IN operacion.sga_visita_tecnica_ce.numslc_old%TYPE,
                                 pi_numslc_new IN operacion.sga_visita_tecnica_ce.numslc_new%TYPE)
    RETURN valores_srv;

  FUNCTION sgafun_get_inst_desin(pi_numslc_old operacion.sga_visita_tecnica_ce.numslc_old%TYPE,
                                 pi_numslc_new operacion.sga_visita_tecnica_ce.numslc_new%TYPE)
    RETURN VARCHAR2;

  FUNCTION sgafun_get_subtipo(pi_numslc_old operacion.sga_visita_tecnica_ce.numslc_old%TYPE,
                              pi_numslc_new operacion.sga_visita_tecnica_ce.numslc_new%TYPE,
                              pi_tiptra     operacion.tiptrabajo.tiptra%TYPE)
    RETURN VARCHAR2;

  FUNCTION sgafun_get_tiptra_pv_sef(pi_numslc sales.vtatabslcfac.numslc%TYPE)
    RETURN NUMBER;

  PROCEDURE sgass_get_subtipord_ce(pi_id_tiporden   IN operacion.tipo_orden_adc.id_tipo_orden%TYPE,
                                   pi_cod_subtipord IN operacion.subtipo_orden_adc.cod_subtipo_orden%TYPE,
                                   po_cursor        OUT gc_salida);
  --INI 1.0
  PROCEDURE sgass_product_internet(pi_codsrv IN sales.tystabsrv.codsrv%TYPE,
                                   pi_dscsrv IN sales.tystabsrv.dscsrv%TYPE,
                                   po_cursor OUT gc_salida);

  PROCEDURE sgasu_banwid_internet(pi_codsrv     IN sales.tystabsrv.codsrv%TYPE,
                                  pi_codigo_ext IN sales.tystabsrv.codigo_ext%TYPE,
                                  pi_banwid     IN sales.tystabsrv.banwid%TYPE,
                                  po_resultado  OUT INTEGER);

  PROCEDURE sgasu_orden_toa(pi_codsolot    operacion.solot.codsolot%TYPE,
                            pi_observacion VARCHAR2,
                            po_mensaje_res OUT VARCHAR2,
                            po_codigo_res  OUT NUMBER);

  FUNCTION sgafun_consult_cambplan(pi_codect IN VARCHAR2) RETURN INTEGER;

  FUNCTION sgafun_agente_agendam(pi_codect IN VARCHAR2) RETURN VARCHAR2;

  FUNCTION sgafun_tipserv_agendam(pi_codect IN VARCHAR2) RETURN INTEGER;

  FUNCTION sgafun_tipo_tecnologia(pi_codsolot solot.codsolot%TYPE,
                                  po_error_n  OUT NUMBER,
                                  po_error_v  OUT VARCHAR2) RETURN VARCHAR2;

  --ini v2.0
  FUNCTION sgafun_tiptrab_agendam(pi_tiptra IN NUMBER) RETURN INTEGER;

  PROCEDURE sgass_zonaplano_x_sot(pi_codsolot   operacion.solot.codsolot%TYPE,
                                  po_centrop    OUT marketing.vtasuccli.ubigeo2%TYPE,
                                  po_idplano    OUT marketing.vtasuccli.idplano%TYPE,
                                  po_tecnologia OUT VARCHAR2,
                                  po_error_n    OUT NUMBER,
                                  po_error_v    OUT VARCHAR2);

  PROCEDURE sgass_valflujozona_adc(pi_origen  IN VARCHAR2,
                                   pi_idplano IN marketing.vtatabgeoref.idplano%TYPE,
                                   pi_tiptra  IN operacion.matriz_tystipsrv_tiptra_adc.tiptra%TYPE,
                                   pi_tipsrv  IN operacion.matriz_tystipsrv_tiptra_adc.tipsrv%TYPE,
                                   po_codzona OUT operacion.zona_adc.codzona%TYPE,
                                   po_indica  OUT NUMBER);

  PROCEDURE sgasi_asigna_workflow(pi_codsolot solot.codsolot%TYPE,
                                  po_error_n  OUT NUMBER,
                                  po_error_v  OUT VARCHAR2);

  PROCEDURE sgass_buscar_cliente(pi_codcli IN VARCHAR2,
                                 pi_nombre IN VARCHAR2,
                                 po_cursor OUT gc_salida);

  PROCEDURE sgass_datos_complement(pi_codsolot solot.codsolot%TYPE,
                                   po_codcli   OUT VARCHAR2,
                                   po_codsuc   OUT VARCHAR2,
                                   po_numslc   OUT VARCHAR2);

  PROCEDURE sgass_idconsulta_xsot(pi_codsolot solot.codsolot%TYPE,
                                  po_cursor   OUT gc_salida);
  --FIN v2.0

  -- INI v3.0
  PROCEDURE sgass_tipo_orden_adc(pi_flg_tipo   NUMBER,
                                 pi_flg_indica NUMBER,
                                 po_cursor     OUT gc_salida);

  PROCEDURE sgasi_sgat_import_cab(pi_root_file_name IN VARCHAR2,
                                  pi_tabla          IN VARCHAR2,
                                  pi_observacion    IN VARCHAR2,
                                  pi_idcab          OUT NUMBER);

  PROCEDURE SGASI_SGAT_IMPORT_DET (pi_idcab IN NUMBER,
                                    pi_idplano IN VARCHAR2,
                                    pi_codubi IN VARCHAR2,
                                    pi_codzona IN VARCHAR2,
                                    pi_flg_adc IN NUMBER,
                                    pi_descripcion IN VARCHAR2,
                                    pi_servicio IN VARCHAR2,
                                    pi_estado IN VARCHAR2,
                                    pi_idzona IN NUMBER);

  PROCEDURE sgasi_zona_adc_georef(pi_idcab IN NUMBER, pi_tabla IN VARCHAR2);

  PROCEDURE sgass_sgat_import_cab(pi_idcab  IN NUMBER,
                                  pi_fecini IN VARCHAR2,
                                  pi_fecfin IN VARCHAR2,
                                  po_cursor OUT gc_salida);

  PROCEDURE sgass_sgat_import_det(pi_idcab  IN NUMBER,
                                  po_cursor OUT gc_salida);

  FUNCTION sgafun_codsrv_ptoadic(pi_codsrv IN VARCHAR2) RETURN INTEGER;

  FUNCTION sgafun_tiptra_codigon(pi_abreviacion IN VARCHAR2) RETURN INTEGER;

-- FIN v3.0

-- INI v4.0
  FUNCTION SGAFUN_GET_TASKPREDIAG   (pi_tarea IN NUMBER)
    RETURN INTEGER;
-- FIN v4.0
END pkg_visita_sga_ce;
/