CREATE OR REPLACE PACKAGE OPERACION.pq_3play_inalambrico IS
  /************************************************************************************************
  NOMBRE:     OPERACION.PQ_3PLAY_INALAMBRICO
  PROPOSITO:  Generacion de proceso de CONAX LTE

  REVISIONES:
   Version   Fecha          Autor            Solicitado por      Descripcion
   -------- ----------  ------------------   -----------------   ------------------------
     1.0    2015-09-16  Danny Sánchez/       Eustaquio Gibaja/    PQT-245308-TSK-75749 - 3Play Inalambrico
                        Angel Condori        Mauro Zegarra/
                                             Alberto Miranda
     2.0    2015-11-27  Angel Condori        Mauro Zegarra        PQT-246956-TSK-76609
     3.0    2015-12-01  Felipe Maguiña                            PQT-247157-TSK-76711 - 3Play Inalambrico
     4.0    2015-12-15  Dorian Sucasaca/                          PQT-247649-TSK-76965
                        Angel Condori
     5.0    2016-01-04  Danny Sánchez/       Alberto Miranda      SD-616407
                        Angel Condori
     6.0    2016-01-06  Angel Condori        Alberto Miranda      PQT-248422-TSK-77366
     7.0    2016-01-14  Danny Sánchez/       Alberto Miranda    SGA_SD_636471_URG
     8.0    2016-03-09  Danny Sánchez        Mauro Zegarra     SD-669218
     9.0    2016-12-16  Servicio Fallas-HITSS                     SD-840898
     10.0   2016-12-26  Luis Polo B.         Karen Vaquez         SGA-SD-794552
	   11.0   2017-01-19  Servicio Fallas-HITSS
	   14.0   2016-11-10  Luis Guzmán          Alex Alamo			PROY-20152 3Play Inalambrico
	   15.0   2016-11-10  Luis Guzmán          Fanny Najarro        INC000000774220
	18.0   2017-09-29  Jose Arriola         Carlos Lazarte       PROY-29955 Alineacion CONTEGO FASE 2
	19.0   2019-03-18  Luis Flores          Luis Flores          PROY-32581 PostVenta LTE
  /************************************************************************************************/
  TYPE t_cursor IS REF CURSOR;
  PROCEDURE p_conax_alta(p_codsolot  IN NUMBER,
                         p_idtareawf IN NUMBER,
                         p_cod       OUT NUMBER,
                         p_resul     OUT VARCHAR2);

  PROCEDURE p_conax_baja_ds(p_codsolot operacion.solot.codsolot%TYPE,
                            p_resul    OUT VARCHAR2);

  PROCEDURE p_cerrar_val_instalador_lte(a_idtareawf IN NUMBER,
                                        a_idwf      IN NUMBER,
                                        a_tarea     IN NUMBER,
                                        a_tareadef  IN NUMBER);

  PROCEDURE p_registra_deco_lte(p_cod_id    IN VARCHAR2,
                                p_seriedeco IN VARCHAR2,
                                p_serietarj IN VARCHAR2,
                                p_tipequipo IN VARCHAR2,
                                p_tipdeco   IN VARCHAR2,
                                p_resultado OUT INTEGER,
                                p_msgerr    OUT VARCHAR2);

  PROCEDURE p_estado_prov_inst(p_co_id     IN INTEGER,
                               p_resultado OUT INTEGER,
                               p_msgerr    OUT VARCHAR2);

  PROCEDURE p_generar_inst_venta(p_co_id         IN INTEGER,
                                 p_msisdn        IN VARCHAR2,
                                 p_imsi          IN VARCHAR2,
                                 p_sot           IN NUMBER,
                                 p_tipequipo     IN VARCHAR2,
                                 p_modequipo     IN VARCHAR2,
                                 p_fecproceso    IN DATE,
                                 p_request_padre OUT NUMBER,
                                 p_request_tv    OUT NUMBER,
                                 p_resultado     OUT INTEGER,
                                 p_msgerr        OUT VARCHAR2);

  PROCEDURE p_inicia_fact(p_co_id      IN INTEGER,
                          p_fecproceso IN DATE,
                          p_resultado  OUT INTEGER,
                          p_msgerr     OUT VARCHAR2);

  PROCEDURE p_insert_numtel(p_nro_tlf   IN VARCHAR2,
                            p_simcard   IN VARCHAR2,
                            p_codinssrv IN NUMBER,
                            p_estnumtel IN NUMBER,
                            p_tipnumtel IN NUMBER,
                            p_codnumtel OUT NUMBER,
                            p_cod       OUT NUMBER,
                            p_mensaje   OUT VARCHAR2);

  PROCEDURE p_insert_rsv_numtel(p_codnumtel IN NUMBER,
                                p_codinssrv IN NUMBER,
                                p_valido    IN NUMBER,
                                p_estnumtel IN NUMBER,
                                p_codcli    IN VARCHAR2,
                                p_cod       OUT NUMBER,
                                p_mensaje   OUT VARCHAR2);

  PROCEDURE p_actualizar_cnt_bscs(a_idtareawf IN NUMBER,
                                  a_idwf      IN NUMBER,
                                  a_tarea     IN NUMBER,
                                  a_tareadef  IN NUMBER);

  PROCEDURE p_validar_servicio_3playi(a_idtareawf IN NUMBER,
                                      a_idwf      IN NUMBER,
                                      a_tarea     IN NUMBER,
                                      a_tareadef  IN NUMBER);

  PROCEDURE p_upd_pend_req(p_request    IN NUMBER,
                           p_estado     IN VARCHAR2,
                           p_errcode    IN INTEGER,
                           p_errmsg     IN VARCHAR2,
                           p_nrorequest IN NUMBER,
                           p_resul      OUT NUMBER,
                           p_mensaje    OUT VARCHAR2);

  PROCEDURE p_anula_sot_lte(p_codsolot IN NUMBER, p_resul OUT VARCHAR2);

  PROCEDURE p_nrotelefonico_lte(p_numtel    VARCHAR2,
                                p_numserie  VARCHAR2,
                                p_codinssrv NUMBER,
                                p_codcli    VARCHAR2,
                                p_resul     OUT NUMBER,
                                p_mensaje   OUT VARCHAR2);

  PROCEDURE p_consulta_nro_tlf(p_numserie    IN VARCHAR2,
                               p_codsolot    IN NUMBER,
                               p_nro_tlf     OUT VARCHAR2,
                               p_cod_mensaje OUT NUMBER,
                               p_mensaje     OUT VARCHAR2);

  PROCEDURE p_borrar_ope_envio_conax(p_codsolot IN NUMBER,
                                     p_tipo     IN NUMBER);

  PROCEDURE p_act_reg_sisact_lte(an_numslc       solot.numslc%TYPE,
                                 an_codsolot     IN NUMBER,
                                 an_estsol       solot.estsol%TYPE,
                                 a_idtareawf     IN NUMBER,
                                 ac_num_serie_t  IN VARCHAR2,
                                 ac_num_serie_d  IN VARCHAR2,
                                 an_resp         OUT NUMBER,
                                 ac_mensaje      OUT VARCHAR2,
                                 ac_nro_contrato OUT VARCHAR2);

  PROCEDURE p_act_tareawfseg(p_idtareawf IN NUMBER, p_mensaje IN VARCHAR2);

  PROCEDURE p_cons_serv_lte_bscs(a_codsolot  IN NUMBER,
                                 o_resultado OUT t_cursor);
  PROCEDURE p_cons_equ_lte_bscs(a_codsolot  IN NUMBER,
                                o_resultado OUT t_cursor);

  PROCEDURE p_ins_envioconax(an_codsolot    IN NUMBER,
                             an_codinssrv   IN NUMBER,
                             an_tipo        IN NUMBER,
                             ac_serie       IN CHAR,
                             ac_unitaddress IN CHAR,
                             ac_bouquet     IN CHAR,
                             an_numtrans    IN NUMBER,
                             an_codigo      IN NUMBER,
                             an_cod         OUT NUMBER,
                             ac_mensaje     OUT VARCHAR2);

  PROCEDURE p_provision_lte(p_codsolot  IN NUMBER,
                            p_idtareawf IN NUMBER,
                            p_co_id     IN NUMBER,
                            p_tipo_operacion in varchar2, --14.00
                            p_cod       OUT NUMBER,
                            p_mensaje   OUT VARCHAR2);

  PROCEDURE p_reg_cbscs_lte(p_codsolot IN NUMBER,
                            p_idtrs    IN NUMBER,
                            p_cod      OUT NUMBER,
                            p_mensaje  OUT VARCHAR2);
  -- Ini 2.0
  PROCEDURE p_cnsl_tlf_cpe(p_co_id     IN NUMBER,
                           p_tlf_val   OUT NUMBER,
                           p_serie_cpe OUT VARCHAR2,
                           p_cod       OUT NUMBER,
                           p_mensaje   OUT VARCHAR2);
  -- Fin 2.0
  -- ini 3.0
  PROCEDURE p_update_numtel( --p_nro_tlf   in varchar2, --4.0
                            p_simcard   IN VARCHAR2,
                            p_codinssrv IN NUMBER,
                            p_estnumtel IN NUMBER,
                            p_tipnumtel IN NUMBER,
                            p_codnumtel IN NUMBER,
                            p_cod       OUT NUMBER,
                            p_mensaje   OUT VARCHAR2);

  PROCEDURE p_update_rsv_numtel(p_codnumtel IN NUMBER,
                                p_codinssrv IN NUMBER,
                                p_valido    IN NUMBER,
                                p_estnumtel IN NUMBER,
                                p_codcli    IN VARCHAR2,
                                p_cod       OUT NUMBER,
                                p_mensaje   OUT VARCHAR2);
  -- fin 3.0
  -- ini 4.0
  PROCEDURE p_generar_inst_cp(p_coid    IN INTEGER,
                              p_solot   IN operacion.solot.codsolot%TYPE,
                              p_tip_equ IN VARCHAR2,
                              p_mod_equ IN VARCHAR2,
                              p_res     OUT INTEGER,
                              p_msg     OUT VARCHAR2);
  -- fin 4.0
  -- Ini 5.0
  PROCEDURE p_consult_cod_presec(p_idoperador IN NUMBER,
                                 p_cod_presec OUT NUMBER,
                                 p_cod        OUT NUMBER,
                                 p_msj        OUT VARCHAR2); --6.0
  -- Fin 5.0

  -- Ini 7.0

  PROCEDURE p_provision_janus(p_cod_id      IN NUMBER,
                              p_customer_id IN NUMBER,
                              p_tmcode      IN NUMBER,
                              p_sncode      IN NUMBER,
                              p_accion      IN VARCHAR2,
                              p_resultado   OUT INTEGER,
                              p_msgerr      OUT VARCHAR2);

  PROCEDURE p_activacion_servicio_3play(a_idtareawf IN NUMBER,
                                        a_idwf      IN NUMBER,
                                        a_tarea     IN NUMBER,
                                        a_tareadef  IN NUMBER);
  -- Fin 7.0
  -- Ini 8.0
  PROCEDURE p_log_3playi(p_codsolot IN NUMBER,
                         p_nomproc  IN VARCHAR2,
                         p_mensaje  IN VARCHAR2,
                         p_tarea    IN VARCHAR2,
                         p_cod      OUT NUMBER,
                         p_resul    OUT VARCHAR2);
  -- Fin 8.0
  --Ini 9.0
  --------------------------------------------------------------------------------
  procedure p_val_reg_msisdn(p_codsolot  in integer,
                             p_resultado out integer,
                             p_msgerr    out varchar2);
  --Fin 9.0
  --Ini 10.0
  PROCEDURE p_conax_alta_deco(p_codsolot  IN NUMBER,
                              p_idtareawf IN NUMBER,
                              p_cod       OUT NUMBER,
                              p_resul     OUT VARCHAR2);

  PROCEDURE p_validar_servicio_deco_adc(a_idtareawf IN NUMBER,
                                        a_idwf      IN NUMBER,
                                        a_tarea     IN NUMBER,
                                        a_tareadef  IN NUMBER);

  PROCEDURE p_act_pid_x_bscs (p_pid in number,
                                 p_cod out number,
                                 p_mensaje out varchar2);
  -- Fin 10.0
  -- Ini 14.0

  PROCEDURE sgass_srv_cnt (p_codsolot          IN NUMBER,
                           p_cod_id            OUT VARCHAR2,
                           p_tip_serv          OUT VARCHAR2,
                           p_codigo_resp       OUT NUMBER,
                           p_mensaje_resp      OUT VARCHAR2);


  PROCEDURE sgasi_serv_x_cliente (p_codsolot          IN NUMBER,
                                  p_tipo_operacion    IN VARCHAR2,
                                  p_codigo_resp       OUT NUMBER,
                                  p_mensaje_resp      OUT VARCHAR2);


  PROCEDURE sgasu_serv_x_cliente (p_codsolot          IN NUMBER,
                                  p_tipo_operacion    IN VARCHAR2,
                                  p_mensaje           IN VARCHAR2,
                                  p_estado            IN VARCHAR2,
                                  p_codigo_resp       OUT NUMBER,
                                  p_mensaje_resp      OUT VARCHAR2);


  PROCEDURE sgass_conci_srv (p_codsolot          IN NUMBER,
                             p_tipo_operacion    IN VARCHAR2,
                             p_codigo_resp       OUT NUMBER,
                             p_mensaje_resp      OUT VARCHAR2) ;


  PROCEDURE sgass_parametros (p_parametro     IN VARCHAR2,
                              p_tiempo_act    OUT NUMBER,
                              p_tiempo_reen   OUT NUMBER,
                              p_num_reenvio   OUT NUMBER,
                              p_codigo_resp   OUT NUMBER,
                              p_mensaje_resp  OUT VARCHAR2);


  PROCEDURE sgasi_logaprov (p_codsolot      IN NUMBER,
                            p_estado        IN VARCHAR2,
                            p_tipo_trans    IN VARCHAR2,
                            p_accion	      IN VARCHAR2,
                            p_mensaje_log   IN VARCHAR2, -- 15.0
                            p_codigo_resp   OUT NUMBER,
                            p_mensaje_resp  OUT VARCHAR2);

  PROCEDURE sgass_validar_deco_tar (p_codsolot      IN NUMBER,
                                    p_numserie      IN VARCHAR2,
                                    p_tipequ        IN NUMBER,
                                    p_codigo_resp   OUT NUMBER,
                                    p_mensaje_resp  OUT VARCHAR2);


  PROCEDURE sgass_vali_telefono (p_codsolot      IN NUMBER,
                                 p_num_serie_tel IN VARCHAR2,
                                 p_tipequ        IN NUMBER,
                                 p_tipope        IN VARCHAR2,
                                 p_codigo_resp   OUT NUMBER,
                                 p_mensaje_resp  OUT VARCHAR2);


  PROCEDURE sgass_equi_instan (p_codsolot      IN NUMBER,
                               p_num_serie     IN VARCHAR2,
                               p_tipequ        IN NUMBER,
                               p_codigo_resp   OUT NUMBER,
                               p_mensaje_resp  OUT VARCHAR2);


  PROCEDURE sgass_estado_prov_janus(p_co_id        IN NUMBER,
                                    p_codigo_resp  OUT INTEGER,
                                    p_mensaje_resp OUT VARCHAR2,
                                    p_est_janus    OUT VARCHAR2);


  FUNCTION sgafun_recupera_date_part(p_owner   IN VARCHAR2,
                                    p_tabla     IN VARCHAR2,
                                    p_particion IN VARCHAR2) RETURN DATE;


   FUNCTION sgafun_genera_query_part(p_fecini     IN VARCHAR2,
                                     p_fecfin     IN VARCHAR2,
                                     p_owner      IN VARCHAR2,
                                     p_tabla_name IN VARCHAR2) RETURN VARCHAR2;


  PROCEDURE sgass_logaprov(p_codsolot IN NUMBER,
                           p_co_id    IN NUMBER,
                           p_estado   IN VARCHAR2,
                           p_fecini   IN VARCHAR2,
                           p_fecfin   IN VARCHAR2,
                           p_cursor   OUT t_cursor);


  procedure sgasi_reenvio_provision_il(p_codsolot NUMBER,
                                       p_codigo_resp  OUT INTEGER,
                                       p_mensaje_resp OUT VARCHAR2);

  -- Fin 14.0
  procedure p_gen_change_cycle(p_co_id in integer, p_user in varchar2, p_resp out integer, p_msgr out varchar2);  
  
  --INI 19.0
  procedure sgai_carga_resumen_equ(an_codsolot in solot.codsolot%type,
                                   an_error    out number,
                                   av_error    out varchar2);
  --FIN 19.0
END;
/