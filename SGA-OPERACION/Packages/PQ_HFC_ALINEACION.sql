CREATE OR REPLACE PACKAGE OPERACION.PQ_HFC_ALINEACION IS

  /*******************************************************************************************************
   NOMBRE:       OPERACION.PQ_HFC_ALINEACION
   PROPOSITO:    Paquete de objetos necesarios para realizar alineación SGA - IW - BSCS - JANUS
   REVISIONES:
   Version    Fecha       Autor            Solicitado por    Descripcion
  ---------  ----------  ---------------  --------------    -----------------------------------------
    1.0       04/11/2015                   00
    2.0       28/04/2016                                    SD-642508-1 Cambio de Plan Fase II
    3.0       07/12/2016  Servicio Fallas-HITSS		     SD_1040408
*/
  type rCursor is ref cursor;

  function f_valida_sga_xservicio(an_numero in varchar2,
                                  an_cod_id in number,
                                  an_valores_iw in varchar2,
                                  an_tservicio in varchar2,
                                  an_tatributo in varchar2) return number;

  function f_valida_bscs_xservicio(an_numero in varchar2,
                                   an_cod_id IN number,
                                   an_valores_iw in varchar2,
                                   an_tservicio in varchar2) return number;

  procedure p_valida_tlf_iw(an_numero IN VARCHAR2,
                            an_cod_id IN number,
                            tipo_linea IN NUMBER,
                            an_out     out number,
                            av_mensaje out varchar2);

  PROCEDURE p_regulariza_numero(an_cod_id IN number,
                                 an_numero IN VARCHAR2,
                                 lv_tn_bscs IN VARCHAR2,
                                 tipo_linea IN NUMBER,
                                 an_error OUT INTEGER,
                                 av_error OUT VARCHAR2);

  procedure p_alinea_numero_bscs_sga(an_cod_id IN number,
                                     an_numero_sga IN VARCHAR2,
                                     lv_tn_bscs IN VARCHAR2,
                                     an_error OUT INTEGER,
                                     av_error OUT VARCHAR2);

  procedure p_update_bscs(an_cod_id IN number,
                          an_numero_sga IN VARCHAR2,
                          an_error OUT INTEGER,
                          av_error OUT VARCHAR2);

  procedure p_reg_numero_noalineado(an_numero IN VARCHAR2,
                                      an_cod_id IN number,
                                      an_tservicio varchar2,
                                      an_tipo_noalineado IN VARCHAR2,
                                      an_observacion IN VARCHAR2,
                                      an_error OUT INTEGER,
                                      av_error OUT VARCHAR2);

  PROCEDURE p_cargar_bscs_tabhfc;

  PROCEDURE p_carga_db_hfc ;

  PROCEDURE p_cargar_dbjanus_payer;

  PROCEDURE p_cargar_dbjanus_conex(an_error OUT INTEGER,
                                   av_error OUT VARCHAR2);

  PROCEDURE p_carga_db_janus_ptariffs(an_error OUT INTEGER,
                                      av_error OUT VARCHAR2);

  procedure p_proceso_alineacion_masiva (cResultado out rCursor);

END PQ_HFC_ALINEACION;
/