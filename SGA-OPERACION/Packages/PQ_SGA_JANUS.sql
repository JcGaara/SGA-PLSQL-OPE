CREATE OR REPLACE PACKAGE OPERACION.PQ_SGA_JANUS IS

  /*******************************************************************************************************
   NOMBRE:       OPERACION.PQ_SGA_JANUS
   PROPOSITO:    Paquete de objetos necesarios para la Conexion del SGA - JANUS
   REVISIONES:
   Version    Fecha       Autor            Solicitado por    Descripcion
  ---------  ----------  ---------------  --------------    -----------------------------------------
    1.0       04/11/2015                   00
    2.0       14/12/2015 Luis Flores                        SGA-SD-560640
    3.0       28/04/2016                                    SD-642508-1 Cambio de Plan Fase II
    4.0       01/07/2016                                    SGA_SD-767463 Se asignan bolsas en Janus de clientes anteriores
    6.0       28/11/2016  Luis Flores                       PROY-20828.SGA Mejora Provision HFC
    7.0       25/01/2017  Servicio Fallas-HITSS             INC000000638618 Mejora Provision LTE
    9.0       06/04/2017  Luis Guzman      Fanny Najarro    PROY-20152 3Play Inalambrico -
   11.0       12/05/2017  Luis Guzmán      Fanny Najarro    INC000000774220
   12.0       11/07/2017  Jose Varillas    Tito Huertas     PROY 27792
   13.0       07/02/2019  Abel Ojeda       Luis Flores      Provision para JANUS generado por Cambio de Plan CE
  *******************************************************************************************************/
  cn_estcerrado      constant number := 4;
  cn_estnointerviene constant number := 8;
  cv_telefonia       constant char(4) := '0004'; --13.0

  procedure p_insert_prov_sga_janus(an_nsecuencia number,
                                    an_accion number,
                                    an_codsolot number,
                                    an_cod_id number,
                                    an_customer_id number,
                                    av_customer_idjanus varchar2,
                                    av_numero varchar2,
                                    av_tipo varchar2,
                                    an_coderror out number,
                                    av_msgerror out varchar2);

  procedure p_insertxacc_prov_sga_janus(an_naccion number,
                                        an_codsolot number,
                                        an_cod_id number,
                                        an_customer_id number,
                                        av_customer_idjanus varchar2,
                                        av_numero varchar2,
                                        an_coderror out number,
                                        av_msgerror out varchar2);

  procedure p_update_prov_sga_janus(an_idprov number,
                                    an_estado number,
                                    an_nerror number,
                                    av_merror varchar2,
                                    an_coderror out number,
                                    av_msgerror out varchar2);

  procedure p_cons_linea_janus(av_numero      in varchar2,
                               an_tipo        in number,
                               an_out         out number,
                               av_mensaje     out varchar2,
                               av_customer_id out varchar2,
                               an_codplan     out number,
                               av_producto    out varchar2,
                               ad_fecini      out date,
                               av_estado      out varchar2,
                               av_ciclo       out varchar2);

  procedure p_baja_janus(an_codsolot solot.codsolot%type, an_error out number , av_error out varchar2);

  procedure p_libera_janusxsot(a_idtareawf in number,
                               a_idwf      in number,
                               a_tarea     in number,
                               a_tareadef  in number);

  procedure p_insert_prov_bscs_janus(an_actionid number,
                                     an_priority number,
                                     an_customerid number,
                                     an_cod_id number,
                                     av_estadoprv varchar2,
                                     an_tarea number,
                                     av_trama varchar2,
                                     an_ordid      out number,--7.0
                                     an_error out number,
                                     av_msgerror out varchar2);

  procedure p_insert_prov_ctrl_janus(an_actionid number,
                                     an_priority number,
                                     av_customerid varchar2,
                                     an_cod_id number,
                                     av_estadoprv varchar2,
                                     av_trama varchar2,
                                     an_error out number,
                                     av_msgerror out varchar2);

 procedure p_envia_baja_numero_janus(an_tipo number,
                                      av_numero varchar2,
                                      an_co_id number,
                                      av_customer varchar2,
                                      an_error out number,
                                      av_error out varchar2);

 procedure p_envia_baja_cliente_janus(an_tipo number,
                                      an_co_id number,
                                      av_customer varchar2,
                                      an_error out number,
                                      av_error out varchar2);

 function f_val_prov_janus_pend(an_cod_id number) return number;

 procedure p_validacion_pre_janus;

 procedure p_job_alinea_janus;

 procedure p_job_cierra_tarea_janus;

 procedure p_valida_linea_bscs_sga(an_codsolot in number,
                                    av_tipo     in varchar2,
                                    an_error    out number,
                                    av_error    out varchar2);

 procedure p_valida_linea_iw_sga(av_numero  in inssrv.numero%type,
                                 an_cliente in solot.customer_id%type,
                                 an_error   out number,
                                 av_error   out varchar2);

 function f_val_exis_linea_janus(av_numero  in varchar2) return number;

 procedure p_baja_janus_pre_ce_sga(a_idtareawf in number,
                                       a_idwf      in number,
                                       a_tarea     in number,
                                       a_tareadef  in number);

 function f_get_plataforma_origen(an_codsolot solot.codsolot%type) return varchar2;

 function f_val_es_tlf_janus(an_codsolot solot.codsolot%type) return number;

 function f_val_es_tlf_tellin(an_codsolot solot.codsolot%type) return number;

 function f_val_es_tlf_abierta(an_codsolot solot.codsolot%type) return number;

 procedure p_bajalinea_janus_ce(an_codsolot number,
                                      av_numero   varchar2,
                                      an_error    out integer,
                                      av_error    out varchar2);

  function f_obt_cant_linea_ce(an_codsolot number) return number;

  --Funcion que valida si la SOT tiene el servicio de telefonia asociado
  function f_val_serv_tlf_sot(an_codsolot number) return number;

  --Procedimiento de alta de numero en Janus
  procedure p_altanumero_janus(an_codsolot number,
                               an_error    out integer,
                               av_error    out varchar2);

  procedure p_altanumero_janus_sga_ce(an_codsolot number,
                                      av_numero   varchar2,
                                      an_error    out integer,
                                      av_error    out varchar2);

  function f_retorna_trama_alta_ce(an_codsolot number,
                                   av_numslc   varchar2,
                                   an_codinssrv number,
                                   av_numero    varchar2)
    return varchar2;

  procedure p_retorna_datos_cliente_ce(an_codsolot number,
                                       av_codcli out varchar2,
                                       av_numslc out varchar2,
                                       an_planbase out number,
                                       an_planopcion out number,
                                       av_tipdide out varchar2,
                                       av_ntdide out varchar2,
                                       av_apellidos out varchar2,
                                       av_nomcli out varchar2,
                                       av_ruc out varchar2,
                                       av_razon out varchar2,
                                       av_tlf1 out varchar2,
                                       av_tlf2 out varchar2,
                                       an_error out number,
                                       av_error out varchar2);

  procedure p_retorna_datos_sucursal_ce(av_numslc varchar2,
                                       av_dirsuc out varchar2,
                                       av_referencia out varchar2,
                                       av_nomdst out varchar2,
                                       av_nompvc out varchar2,
                                       av_nomest out varchar2,
                                       an_error out number,
                                       av_error out varchar2);

  procedure p_altanumero_janus_sga(an_codsolot number,
                                   an_error    out integer,
                                   av_error    out varchar2);

  function f_get_ciclo_codinssrv(l_numero    numtel.numero%type,
                                 l_codinssrv insprd.codinssrv%type)
    return varchar2;

  procedure p_altanumero_janus_bscs(an_codsolot number,
                                    an_error    out integer,
                                    av_error    out varchar2);

  function f_get_constante_conf(av_constante char) return number;

  procedure p_ejecuta_transaccion_janus(a_idtareawf in number,
                                       a_idwf      in number,
                                       a_tarea     in number,
                                       a_tareadef  in number);
  procedure p_baja_linea_janus_lte(an_codsolot number,
                                   an_error    out number,
                                   av_error    out varchar2);--7.0

  procedure p_alta_numero_janus_lte(an_codsolot number,
                                    an_error    out number,
                                    av_error    out varchar2);--7.0

  function f_get_external_janus_numero(av_numero varchar2) return varchar2;--7.0

  procedure p_reg_log(ac_codcli      OPERACION.SOLOT.CODCLI%type,
                      an_customer_id number,
                      an_idtrs       number,
                      an_codsolot    number,
                      an_idinterface number,
                      an_error       number,
                      av_texto       varchar2,
                      an_cod_id      number default 0,
                      av_proceso     varchar default '');

  procedure p_relanza_co_id_bscs_lte(an_codsolot number,
                                an_error    out number,
                                av_error    out varchar2);--7.0
    procedure p_cont_reproceso(an_cod_id number,
                             an_error  out integer,
                             av_error  out varchar2);--7.0
 procedure p_cont_reproceso_ce(an_cod_id number,
                             an_error  out integer,
                             av_error  out varchar2);--7.0
  procedure p_reproceso_janusxsot(an_codsolot number,
                                 an_error    out number,
                                 av_error    out varchar2);--7.0
 function f_val_status_contrato_Bscs(an_co_id number) return varchar2;--7.0

 function f_val_prov_janus_pend_alta(an_cod_id number) return number; -- 9.0

 procedure p_cons_existe_linea_janus(av_numero      in varchar2,
                                     an_error       out number,
                                     av_mensaje     out varchar2); --11.00

  -- ini 12.0
  procedure p_cambio_plan_janus_hfc(an_codsolot operacion.solot.codsolot%type,
                                    an_error    out number,
                                    av_error    out varchar2);

  procedure p_eje_tarea_cambio_plan(a_idtareawf in number,
                                    a_idwf      in number,
                                    a_tarea     in number,
                                    a_tareadef  in number);
  -- fin12.0

  procedure sp_prov_adic_janus(p_co_id       in integer,
                               p_customer_id in integer,
                               p_tmcode      in integer,
                               p_sncode      in integer,
                               p_accion      in varchar2,
                               p_resultado   out integer,
                               p_msgerr      out varchar2,
                               p_ordid       out number);

 PROCEDURE SGASI_BAJA_JANUS_TLFCLI(AV_NUMERO   IN INSSRV.NUMERO%TYPE,
                                 AN_CUSTOMER IN SOLOT.CUSTOMER_ID%TYPE,
                                 AN_COD_ID   IN SOLOT.COD_ID%TYPE,
                                 AN_ERROR    OUT NUMBER,
                                 AV_ERROR    OUT VARCHAR2);

--Ini 13.0
  PROCEDURE sgasi_bajalta_janus_ce(a_idtareawf IN NUMBER,
                                  a_idwf      IN NUMBER,
                                  a_tarea     IN NUMBER,
                                  a_tareadef  IN NUMBER);


--Fin 13.0
END PQ_SGA_JANUS;
/