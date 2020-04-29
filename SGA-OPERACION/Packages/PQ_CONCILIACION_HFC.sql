CREATE OR REPLACE PACKAGE OPERACION.PQ_CONCILIACION_HFC IS
  /*******************************************************************************************************
    NOMBRE:       OPERACION.PQ_CONCILIACION_HFC
    PROPOSITO:
    REVISIONES:
    Version    Fecha       Autor            Solicitado por    Descripcion
    ---------  ----------  ---------------  --------------    -----------------------------------------
     1.0       01/03/2017  Luis Flores      Luis Flores       Conciliación
  *******************************************************************************************************/

  PROCEDURE p_hfc_venta_ln;

  PROCEDURE p_hfc_venta_bl(an_idproceso NUMBER, an_idtarea NUMBER);

  PROCEDURE p_hfc_instalacion_ln;

  PROCEDURE p_hfc_instalacion_bl(an_idproceso NUMBER,
                                     an_idtarea   NUMBER);

  PROCEDURE p_hfc_facturacion_ln;

  PROCEDURE p_hfc_facturacion_bl(an_idproceso NUMBER,
                                      an_idtarea   NUMBER);

  PROCEDURE p_hfc_equipos_bscs_bl(an_idproceso NUMBER, an_idtarea NUMBER);

  PROCEDURE p_hfc_equipos_sga_bl(an_idproceso NUMBER, an_idtarea NUMBER);

  PROCEDURE p_ThreadRun(av_username  VARCHAR2,
                        av_password  VARCHAR2,
                        av_url       VARCHAR2,
                        av_nsp       VARCHAR2,
                        an_idproceso NUMBER,
                        an_hilos     IN NUMBER);

  FUNCTION f_obt_ncossac(L_NUMERO IN VARCHAR2) RETURN VARCHAR2;

  FUNCTION f_getConstante(av_constante operacion.constante.constante%TYPE)
    RETURN VARCHAR2;

  function fn_divide_cadena(p_cadena in out varchar2) return varchar2;

  function f_get_es_idproducto_sisact(an_idproducto number) return varchar2;

  function f_get_no_es_srv_principal(av_tipsrv     varchar2,
                                     an_idproducto number,
                                     an_flprinc    number) return number;

  function f_get_desc_tiposerv(av_tiposrv varchar2) return varchar2;

  PROCEDURE p_hfc_update_bscs_bl(an_idproceso NUMBER, an_idtarea NUMBER);

  PROCEDURE p_hfc_upd_th_bscs_bl;

  PROCEDURE p_hfc_janus_ln;

  PROCEDURE p_hfc_janus_bl(an_idproceso NUMBER, an_idtarea NUMBER);

  procedure p_insert_log_conci_hfc(lt_conci_hfc historico.log_conciliacion_hfc%rowtype);

  procedure p_datos_clientes(v_data_n1 number,v_data_v1 varchar2,nflag number , u_datos_consulta in out sys_refcursor);

  procedure p_datos_bscs(v_data_n1 number,v_data_v1 varchar2,nflag number , u_datos_consulta in out sys_refcursor);

  procedure p_datos_sga(v_data_n1 number,v_data_v1 varchar2,nflag number , u_datos_consulta in out sys_refcursor);

  procedure p_conciliacion_consul_01(v_data_n1 number,v_data_v1 varchar2,nflag number , u_datos_consulta in out sys_refcursor);

  procedure p_conciliacion_consul_02(v_data_n1 number,v_data_v1 varchar2,nflag number , u_datos_consulta in out sys_refcursor);

  procedure p_conciliacion_consul_03(v_data_n1 number,v_data_v1 varchar2,nflag number , u_datos_consulta in out sys_refcursor);

  procedure p_conciliacion_consul_04(v_data_n1 number,v_data_v1 varchar2,nflag number , u_datos_consulta in out sys_refcursor);

  procedure p_conciliacion_consul_05(v_data_n1 number,v_data_v1 varchar2,nflag number , u_datos_consulta in out sys_refcursor);

  procedure p_conciliacion_consul_06(v_data_n1 number,v_data_v1 varchar2,nflag number , u_datos_consulta in out sys_refcursor);

  procedure p_carga_provision;
END;
/
