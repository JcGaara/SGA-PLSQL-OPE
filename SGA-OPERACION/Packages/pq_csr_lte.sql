CREATE OR REPLACE PACKAGE OPERACION.pq_csr_lte IS

  /************************************************************************************************
  NOMBRE:     1.  OPERACION.PQ_CSR_LTE
  PROPOSITO:  PAquete para Generacion de SOT / Cierre de SOT de Corte Suspension y Reconexion segun REQUEST de la BSCS

  REVISIONES:
   Version   Fecha          Autor            Solicitado por      Descripcion
   -------- ----------  ------------------   -----------------   ------------------------
   1.0      15/10/2015   Emma Guzman         Guillermo Salcedo   PAquete para Generacion de SOT / Cierre de SOT de Corte Suspension y Reconexion segun REQUEST de la BSCS
                         Justiniano Condori
   2.0      10/06/2016   Dorian Sucasaca/    Eustaquio Gibaja /  SGA-SD-794552
                         Justiniano Condori  Mauro Zegarra /
                                             Karen Vasquez
   3.0      19/08/2016   Dorian Sucasaca                         PROY-20152 IDEA-24390 Proyecto LTE - 3Play inalámbrico- SD-911688
   4.0      18/10/2016   Dorian Sucasaca     Alex Alamo          SD_931807
   5.0      09/11/2016   Dorian Sucasaca     Mauro Zegarra       STR.FALLA.PROY-20152.SD794552-SGA
   6.0      09/11/2016   Justiniano Condori  Mauro Zegarra       PROY-20152 Proyecto LTE - 3Play inalámbrico-Servicios Adicionales TV
   7.0      06/04/2017   Justiniano Condori  Fanny Najarro       STR.SOL.PROY-20152.SGA_1
   8.0      08/05/2017   Luis Guzmán  		 Fanny Najarro       INC000000774220
   12.0     05/10/2017   Jose Arriola        Carlos Lazarte      PROY-25599 Alineacion contego Fase II
  /************************************************************************************************/

  TYPE gc_salida IS REF CURSOR;
  -- Ini 2.0
  fnd_provision_dth constant varchar(10) := 'TV';
  fnd_provision_lte constant varchar(10) := 'TEL+INT';
  fnd_est_sot_gen   constant number(2) := 10;
  fnd_est_sot_eje   constant number(2) := 17;
  fnd_tel           constant varchar(4) := '0004';
  ln_log operacion.logrqt_csr_lte%rowtype;
  -- fin 2.0
  -- ini 4.0
  fnd_provision_int         constant varchar(10) := 'INTERNET';
  fnd_provision_tel         constant varchar(10) := 'TELEFONIA';
  fnd_est_sot_cer           constant number(2) := 12;
  fnd_estado_pend_ejecucion constant number(2) := 1;
  fnd_estado_lotizado       constant number(2) := 2;
  fnd_estado_conf_ok        constant number(2) := 3;
  fnd_estado_conf_err       constant number(2) := 4;
  fnd_estado_relotizar      constant number(2) := 7;
  -- fin 4.0
  FND_MSJ_PROVISION_OK      CONSTANT VARCHAR2(50)   := 'EL REGISTRO FUE PROVISIONADO CORRECTAMENTE';-- V12.0

  FUNCTION f_obtiene_sot(av_cod_id IN VARCHAR2) RETURN NUMBER;

  PROCEDURE p_genera_sot(an_resultado OUT NUMBER, av_mensaje OUT VARCHAR2);

  PROCEDURE p_cerrar_sot(an_resultado OUT NUMBER, av_mensaje OUT VARCHAR2);

  PROCEDURE p_insert_sot(v_codcli   IN solot.codcli%TYPE,
                         v_tiptra   IN solot.tiptra%TYPE,
                         v_tipsrv   IN solot.tipsrv%TYPE,
                         v_motivo   IN solot.codmotot%TYPE,
                         v_areasol  IN solot.areasol%TYPE,
                         a_codsolot OUT NUMBER);

  PROCEDURE p_insert_solotpto(an_codsolot IN solot.codsolot%TYPE,
                              an_cod_id   IN solot.cod_id%TYPE);-- 5.0

  PROCEDURE p_bouquets_lineal(in_bouquet  IN VARCHAR2,
                              out_bouquet OUT dbms_utility.uncl_array);

  PROCEDURE p_actualiza_desactiva(p_idtareawf tareawf.idtareawf%TYPE,
                                  p_idwf      tareawf.idwf%TYPE,
                                  p_tarea     tareawf.tarea%TYPE,
                                  p_tareadef  tareawf.tareadef%TYPE);

  PROCEDURE p_actualiza_activa(p_idtareawf tareawf.idtareawf%TYPE,
                               p_idwf      tareawf.idwf%TYPE,
                               p_tarea     tareawf.tarea%TYPE,
                               p_tareadef  tareawf.tareadef%TYPE);
  -- ini 2.0
  /*  PROCEDURE p_insert_serv_ad(av_cod_id   IN solot.codcli%TYPE,
  an_codsolot     IN solot.codsolot%TYPE,
  a_idserv    in sales.servicio_sisact.idservicio_sisact%type);*/
  -- fin 2.0
  -- ini 2.0
  procedure p_genera_sot_adi(an_request   in number,
                             an_sot       out number,
                             an_resultado out number,
                             av_mensaje   out varchar2);

  procedure p_gen_archivo_conax_post(ac_tiposolicitud operacion.tab_rec_csr_lte_cab.tiposolicitud%type);

  procedure p_genera_archivo_lote(an_tipo      in number,
                                  an_idlote    in operacion.tab_rec_csr_lte_cab.idlote%type,
                                  ac_resultado in out varchar2,
                                  ac_mensaje   in out varchar2);

  procedure p_genera_archivo_conax(an_tipo      in number,
                                   an_idlote    in operacion.tab_rec_csr_lte_cab.idlote%type,
                                   ac_bouquet   in operacion.tab_rec_csr_lte_det.bouquet%type,
                                   ac_resultado in out varchar2,
                                   ac_mensaje   in out varchar2);

  procedure p_envio_archivo_lote(an_idlote    in operacion.ope_lte_archivo_det.idlote%type,
                                 ac_resultado in out varchar2,
                                 ac_mensaje   in out varchar2);

  procedure p_envio_archivo_conax(an_idlote    in operacion.ope_lte_lote_sltd_aux.idlote%type,
                                  ac_bouquet   in operacion.ope_lte_archivo_cab.bouquet%type,
                                  ac_resultado in out varchar2,
                                  ac_mensaje   in out varchar2);

  function f_obtiene_codsrv(av_id_servicio in varchar2) return varchar2;

  function f_sot_equipo(av_cod_id in varchar2) return varchar2;

  procedure p_reg_log(p_log operacion.logrqt_csr_lte%rowtype);

  procedure p_valida_cancelacion_srv(p_idtareawf in opewf.tareawf.idtareawf%type,
                                     p_idwf      in opewf.tareawf.idwf%type,
                                     p_tarea     in opewf.tareawf.tarea%type,
                                     p_tareadef  in opewf.tareawf.tareadef%type);

  procedure p_libera_numeros(p_solot     in operacion.solot.codsolot%type,
                             p_respuesta out number,
                             p_mensaje   out varchar2);

  procedure p_libera_equipos(p_solot     in operacion.solot.codsolot%type,
                             p_respuesta out number,
                             p_mensaje   out varchar2);

  procedure p_actualiza_provision_bscs(an_solot   in operacion.solot.codsolot%type,
                                       an_request in number,
                                       an_mensaje in varchar2, -- 3.0
                                       an_estado  in number,
                                       an_opcion  in number);

  procedure p_consultar_conax(p_solot     in operacion.solot.codsolot%type,
                              p_respuesta out number,
                              p_mensaje   out varchar2);

  procedure p_verificar_conax(p_solot     in operacion.solot.codsolot%type,
                              p_respuesta out number,
                              p_mensaje   out varchar2);

  procedure p_actualiza_sot(p_sot         in operacion.solot.codsolot%type,
                            p_cod_id      in operacion.solot.codsolot%type,
                            p_customer_id in operacion.solot.codsolot%type);

  -- fin 2.0
  -- Ini 4.0
  /****************************************************************
  '* Nombre SP :            SP_SNCODE_LINEAL
  '* Propósito :            Descomponer los Datos de los Canales en un Array
  '* Input :                Sncode(Canales)
  '* Output :               Array
  '* Creado por :           Dorian Sucasaca
  '* Fec Creación :         17/10/2016
  '* Fec Actualización :    17/10/2016
  '****************************************************************/
  procedure sp_sncode_lineal(in_sncode  in varchar2,
                             out_sncode out dbms_utility.uncl_array);

  /****************************************************************
  '* Nombre SP :            sp_valida_trama_dth
  '* Propósito :            SP que valida la trama de TV al Activarse la Tarea
  '* Input :                a_idtareawf: ID de la tarea.
                            a_idwf:      ID de la instancia de workflow.
                            a_tarea:     ID de la tarea para una definición de wf.
                            a_tareadef:  Tipo de Tarea.
  '* Output :               --
  '* Creado por :           Dorian Sucasaca
  '* Fec Creación :         17/10/2016
  '* Fec Actualización :    17/10/2016
  '****************************************************************/
  procedure sp_valida_trama_dth(a_idtareawf in number,
                                a_idwf      in number,
                                a_tarea     in number,
                                a_tareadef  in number);

  /****************************************************************
  '* Nombre SP :            sp_valida_trama_il_janus
  '* Propósito :            SP que valida la trama de TEL-INT al Activarse la Tarea
  '* Input :                a_idtareawf: ID de la tarea.
                            a_idwf:      ID de la instancia de workflow.
                            a_tarea:     ID de la tarea para una definición de wf.
                            a_tareadef:  Tipo de Tarea.
  '* Output :               --
  '* Creado por :           Dorian Sucasaca
  '* Fec Creación :         17/10/2016
  '* Fec Actualización :    17/10/2016
  '****************************************************************/
  procedure sp_valida_trama_il_janus(a_idtareawf in number,
                                     a_idwf      in number,
                                     a_tarea     in number,
                                     a_tareadef  in number);

  /****************************************************************
  '* Nombre SP :            sp_valida_prov_il
  '* Propósito :            SP que valida la Provision de IL
  '* Input :                a_idtareawf: ID de la tarea.
                            a_idwf:      ID de la instancia de workflow.
                            a_tarea:     ID de la tarea para una definición de wf.
                            a_tareadef:  Tipo de Tarea.
  '* Output :               --
  '* Creado por :           Dorian Sucasaca
  '* Fec Creación :         17/10/2016
  '* Fec Actualización :    17/10/2016
  '****************************************************************/
  procedure sp_valida_prov_il(a_idtareawf in number,
                              a_idwf      in number,
                              a_tarea     in number,
                              a_tareadef  in number);

  /****************************************************************
  '* Nombre SP :            p_valida_prov_dth
  '* Propósito :            SP que valida la Provision de Conax
  '* Input :                a_idtareawf: ID de la tarea.
                            a_idwf:      ID de la instancia de workflow.
                            a_tarea:     ID de la tarea para una definición de wf.
                            a_tareadef:  Tipo de Tarea.
  '* Output :               --
  '* Creado por :           Dorian Sucasaca
  '* Fec Creación :         17/10/2016
  '* Fec Actualización :    17/10/2016
  '****************************************************************/
  procedure sp_valida_prov_dth(a_idtareawf in number,
                               a_idwf      in number,
                               a_tarea     in number,
                               a_tareadef  in number);

  /****************************************************************
  '* Nombre SP :            sp_valida_prov_janus
  '* Propósito :            SP que valida la Provision de JANUS
  '* Input :                a_idtareawf: ID de la tarea.
                            a_idwf:      ID de la instancia de workflow.
                            a_tarea:     ID de la tarea para una definición de wf.
                            a_tareadef:  Tipo de Tarea.
  '* Output :               --
  '* Creado por :           Dorian Sucasaca
  '* Fec Creación :         17/10/2016
  '* Fec Actualización :    17/10/2016
  '****************************************************************/
  procedure sp_valida_prov_janus(a_idtareawf in number,
                                 a_idwf      in number,
                                 a_tarea     in number,
                                 a_tareadef  in number);

  /****************************************************************
  '* Nombre SP :            sp_actualizar_servicios
  '* Propósito :            SP Actuliza las Instancia de Servicio y Producto del SGA
  '* Input :                an_sot:      codigo de la SOLOT
  '* Output :               an_resultado:codigo de respuesta 0:OK -1: Error
                            an_mensaje:  mensaje de Respuesta
  '* Creado por :           Dorian Sucasaca
  '* Fec Creación :         17/10/2016
  '* Fec Actualización :    17/10/2016
  '****************************************************************/
  procedure sp_actualizar_servicios(an_sot       in operacion.solot.codsolot%type,
                                    an_resultado out number,
                                    an_mensaje   out varchar2);

  /****************************************************************
  '* Nombre SP :            sp_gen_bou_bscs
  '* Propósito :            SP extrae los Bouquet del BSCS
  '* Input :                an_coid:      Contrato
                            an_sot:       Codigo de SOLOT
                            an_tipequ:    Tipo de Equipo
                            an_log:       Datos del LOG
                            an_tipo:      Tipo de Operacion
  '* Output :               an_resultado:codigo de respuesta 0:OK -1: Error
                            an_mensaje:  mensaje de Respuesta
  '* Creado por :           Dorian Sucasaca
  '* Fec Creación :         17/10/2016
  '* Fec Actualización :    17/10/2016
  '****************************************************************/
  procedure sp_gen_bou_bscs(an_coid      in operacion.solot.cod_id%type,
                            an_sot       in operacion.solot.codsolot%type,
                            an_tipequ    in operacion.solotptoequ.tipequ%type,
                            an_log       in operacion.logrqt_csr_lte%rowtype,
                            an_tipo      in varchar2,
                            an_tiposol   in varchar2, --6.0
                            an_resultado out number,
                            an_mensaje   out varchar2);

  /****************************************************************
  '* Nombre SP :            p_gen_bou_sga
  '* Propósito :            SP extrae los Bouquet del SGA
  '* Input :                an_coid:      Contrato
                            an_sot:       Codigo de SOLOT
                            an_tipequ:    Tipo de Equipo
                            an_log:       Datos del LOG
                            an_tipo:      Tipo de Operacion
  '* Output :               an_resultado:codigo de respuesta 0:OK -1: Error
                            an_mensaje:  mensaje de Respuesta
  '* Creado por :           Dorian Sucasaca
  '* Fec Creación :         17/10/2016
  '* Fec Actualización :    17/10/2016
  '****************************************************************/
  procedure sp_gen_bou_sga(an_coid      in operacion.solot.cod_id%type,
                           an_sot       in operacion.solot.codsolot%type,
                           an_tipequ    in operacion.solotptoequ.tipequ%type,
                           an_log       in operacion.logrqt_csr_lte%rowtype,
                           an_tipo      in varchar2,
                           an_tiposol   in varchar2, --6.0
                           an_resultado out number,
                           an_mensaje   out varchar2);
  -- Fin 4.0
  -- Ini 6.0
  function f_consul_codinssrv(p_tipo in varchar2,
                              p_sot in number)
  return number;
  
  procedure p_valida_act_des_srv_ad(a_idtareawf in number,
                                    a_idwf      in number,
                                    a_tarea     in number,
                                    a_tareadef  in number);
  -- Fin 6.0
 --ini 11.0
  function f_obtener_codsrv(a_SNCODE integer)

  return varchar2;
 --fin 11.0
  /****************************************************************
  '* Nombre SP :            sp_atender_sot_baja
  '* Propósito :            Atender SOT de BAJA LTE luego de activarse la tarea de "Liquidaciones Equ y MO"
  '* Input :                p_idtareawf:      idtareawf
                            p_idwf:           idwf
                            p_tarea:          tarea
                            p_tareadef:       tareadef
  '* Creado por :           Carlos Chamache
  '* Fec Creación :         30/10/2017
  '* Fec Actualización :    30/10/2017
  '****************************************************************/
  PROCEDURE sp_atender_sot_baja(p_idtareawf tareawf.idtareawf%TYPE,
                                p_idwf      tareawf.idwf%TYPE,
                                p_tarea     tareawf.tarea%TYPE,
                                p_tareadef  tareawf.tareadef%TYPE); 
  procedure sp_baja_sans (p_idtareawf tareawf.idtareawf%TYPE,
                                p_idwf      tareawf.idwf%TYPE,
                                p_tarea     tareawf.tarea%TYPE,
                                p_tareadef  tareawf.tareadef%TYPE);
END;
/