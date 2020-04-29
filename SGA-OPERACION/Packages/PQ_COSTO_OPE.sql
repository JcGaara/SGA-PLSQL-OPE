CREATE OR REPLACE PACKAGE OPERACION.PQ_COSTO_OPE IS
  /******************************************************************************
     NAME:       Pq_Costo_Ope
     PURPOSE:

     REVISIONS:
     Ver        Date        Author           Solicitado por     Description
     ---------  ----------  ---------------  ----------------   ------------------------------------

      1        13/03/2009  Hector Arturo                        REQ 86835 :se creo el procedmiento P_CARGAR_INFO_EQU_INTRAWAY que Cargar equipos a SGA de Intraway
      2        14/04/2009  Hector Arturo                        REQ 85887 :se crearon los siguientes procedmientos:
                                                                    P_Valorizar_liquidacion:Procedimientos para atender proyectos Generacion de PEDIDO ASOCIADO SOT-ETAPA
                                                                    P_importar_sot_etapa:Procedimiento para importar SOT-Etapa en SOLOTPTOETA, actualiza el IDLIQ para maestros
                                                                    P_importar_sot_etapa_liq:Procedimiento para importar SOT-Etapa en SOLOTPTOETA, actualiza el IDLIQ para maestros
      3        17/04/2009  Joseph Asencios                      REQ 87333: se creo el procedimiento P_ACT_MAESTRO_SERIES_MAC1
                                                                que actualiza de forma masiva los UnitAddress de los equipos de Intraway.
      4        24/04/2009  Hector Huaman                        REQ  89517 :se crearon los siguientes procedmientos:
                                                                     p_cargar_formula_act_mat:Procedimiento que permite cargar la informacion de actividades a la Sot Basado en formulas definidas, la formula se selecciona automatica en base al tipo de trabajo de la sot
                                                                     p_pre_liquidar_act_mat:Procedimiento que permite liquidar las lineas de control de costos por etapa, antes de liquidar las lineas se verifica que el servicio de la sot se encuentre activay que se haya registrado el Cintillo
                                                                     p_liquidar_act_mat:Se valida las actividades preliquidades y luego de la verificaciones se procede a Liquidar
      5        30/04/2009  Hector Huaman                        REQ  90344 :se creo el procedimiento p_llenar_actxcontrataxprec, que carga en la tabla actxcontrataxprec por actividad, todas las contratas con un preciario determinado

      6        21/05/2009  Hector Huaman                        REQ 93022: Se creo el procedimiento P_act_maestro_Series_sap, ctualizar bd de series en  base a SAP de manera automatica

      7        03/06/2009  Edilbeto Astulle                     REQ 85252: Se creó los procedimientos p_despacho_equ_mat y p_genera_pep_presupuesto

      8        11/06/2009  Hector Huaman                        REQ 94109: Se modifico el procedimiento p_importar_sot_etapa, se cambio los argumentos de entrada

      9        18/08/2009  Hector Huaman                        REQ 99445: se creo la funcion  f_verificar_almacen_equ para que se valide el equipo, que pertenezca almacen de la contrata asignada
                                                                1 : Valido
                                                                0 : Serie Nula
                                                               -1 : No Serie no Pertenece a Almacen
     10        18/08/2009  Hector Huaman                       REQ 101132: se creo el procedimiento p_cargar_info_equ_cdma_gsm y se modifico el procedimiento p_cargar_info_equ_dth para la carga de equipos.
     11        14/10/2009  Jimmy Farfán                        REQ 104404: Tareas de GIS para Inventario de Planos.
                                                               Se añadió los procedures p_genera_plano_gis y
                                                               p_elimina_plano_gis.
     12        20/10/2009  Jimmy Farfán                        REQ 106310: Procedure p_cargar_info_equ_dth. También se va a descargar el
                                                               campo solotptoequ.codequcom.

     13        03/12/2009  Joseph Asencios                     REQ 111840: Se modificó el procedimiento p_cargar_info_equ_intraway.

     14        06/01/2010  Alfonso Pérez                       REQ 110530: Se agrego logica para mostrar comentario.

     15        23/11/2009  Jimmy Farfán                        REQ 97766: Se creó p_cargar_equ_cdma_gsm para el WF de GSM (wfdef=855), se configura
                                                                   como proceso pre de la tarea Asignación de Número Telefónico.
                                                                   En caso haya 0 registros en la tabla operacion.solotptoequ,
                                                                   se inserta un registro.
     16.0      04/02/2010  Antonio Lagos                       REQ 106908: bundle DTH+CDMA
     17.0      29/04/2010  Marcos Echevarria                   REQ-123713: en  P_act_maestro_Series_mac1 se agrego mac2 y mac3 para su actualizacion
     18.0      29/04/2010  Marcos Echevarria Edilberto Astulle REQ-123713: se optimiza p_cargar_info_equ_intraway para que siemrep se extraiga info de MAESTRO_SERIES_EQU
     19.0      02/08/2010  Mariela Aguirre   Rolando Martinez  REQ-135892: Correcciones a querys
     20.0      27/08/2010  Alexander Yong    Marco De La Cruz  REQ-134351: Problema con la carga de equipos
     21.0      22/09/2010  Edson Caqui       Cesar Rosciano    Req.143672 - Validacion de servicios activos
     22.0      09/11/2010  Antonio Lagos     Edilberto Astulle REQ-134845:Guardar sot que ejecutó la recuperación
     23.0      16/03/2011  Antonio Lagos     Zulma Quispe      REQ-148648: Requerimiento para Instalar más de 01 línea telefónica por equipo eMTA
     24.0      20/06/2011  Fernando Canaval  Edilberto Astulle REQ-159925: Registra mas de un equipo con mismo numero de Serie a la SOT
     25.0      04/07/2011  Fernando Canaval  Edilberto Astulle REQ-160072: Habilitar Acceso para Cierre de Tareas de Liquidacion de Materiales HFC al Liquidar SOT.
     26.0      13/07/2011  Fernando Canaval  Edilberto Astulle REQ-160184: Asignar Agenda en Proceso de Descarga de Equipos de IW.
     27.0      07/09/2011  Fernando Canaval  Edilberto Astulle REQ-160913: Interface SGA SAP.
     28.0      29/08/2011  Alexander Yong    Edilberto Astulle REQ-160185: SOTs Baja 3Play
     29.0      15/12/2011  Carlos Lazarte    Edilberto Astulle REQ-160183: Mantenimiento de Liquidacion MO
     30.0      15/12/2011  Edilberto Astulle Edilberto Astulle SD_697392
     31.0      19/06/2013  Miriam Mandujano  Jose Velarde Actualizacion del despacho del material (webservices)
	 32.0      23.04.2015  Ricardo Crisostomo SINERGIA SGA-SAP
	 33.0      27.09.2015  Edilberto Astulle SD-479472
	 34.0      21.02.2019  LQ                SHELLs PARA LIMFTPV02
 /*********************************************************************************************************************/
  -- Para obtener ciertos datos especificos con respecto a costos
  /*********************************************************************************************************************/
  function f_sum_actxpuntoxetapa(a_codsolot in number,
                                 a_punto    in number,
                                 a_etapa    in number,
                                 a_moneda   in number,
                                 a_permiso  in number,
                                 a_fase     in number,
                                 a_area     in number default null)
    return number;
  function f_sum_matxpuntoxetapa(a_codsolot in number,
                                 a_punto    in number,
                                 a_etapa    in number,
                                 a_moneda   in number,
                                 a_fase     in number,
                                 a_area     in number default null)
    return number;
  function f_sum_metrosxetapa(a_codsolot in number,
                              a_punto    in number,
                              a_etapa    in number) return number;
  function f_sum_actxpunto(a_codsolot in number,
                           a_punto    in number,
                           a_moneda   in number,
                           a_permiso  in number,
                           a_fase     in number,
                           a_area     in number default null) return number;
  function f_sum_matxpunto(a_codsolot in number,
                           a_punto    in number,
                           a_moneda   in number,
                           a_fase     in number,
                           a_area     in number default null) return number;
  function f_sum_matxsolot(a_codsolot in number,
                           a_moneda   in number,
                           a_fase     in number,
                           a_area     in number default null) return number;
  function f_sum_actxsolot(a_codsolot in number,
                           a_moneda   in number,
                           a_permiso  in number,
                           a_fase     in number,
                           a_area     in number default null) return number;
  function f_sum_materialxef(a_codsolot in number) return number;
  function f_sum_actividadxef(a_codsolot in number,
                              a_moneda   in number,
                              a_permiso  in number) return number;
  function f_sum_actxpuntoxorden(a_codsolot in number,
                                 a_punto    in number,
                                 a_orden    in number,
                                 a_moneda   in number,
                                 a_permiso  in number,
                                 a_fase     in number,
                                 a_area     in number default null)
    return number;
  function f_sum_matxpuntoxorden(a_codsolot in number,
                                 a_punto    in number,
                                 a_orden    in number,
                                 a_moneda   in number,
                                 a_fase     in number,
                                 a_area     in number default null)
    return number;

  procedure p_llena_presupuesto_de_solot(a_codsolot solot.codsolot%type);
  procedure P_PRE_ACT_MATERIAL(a_codsolot solot.codsolot%type);
  procedure P_OF_ACT_MATERIAL(a_codsolot solot.codsolot%type);
  PROCEDURE P_act_maestro_Series_equ(n_idalm out number);

  procedure p_cargar_inf_formula(a_codsolot solot.codsolot%type);
  procedure p_depurar_materiales(a_codsolot solot.codsolot%type);
  procedure p_liquidar_materiales(a_codsolot solot.codsolot%type);

  procedure p_reg_equipos_stb_emta(a_fecha date);

  procedure p_reg_equipos_router(a_codsolot solot.codsolot%type,
                                 a_punto    solotpto.punto%type,
                                 a_nroserie solotptoequ.numserie%type,
                                 a_cod_sap  almtabmat.cod_sap%type);
  --ini 23.0
  --procedure p_cargar_info_equ_intraway(a_codsolot in number);
  procedure p_cargar_info_equ_intraway(a_codsolot in number,a_idagenda number default null);
  --fin 23.0
  /*<10.0 procedure p_cargar_info_equ_dth(a_codsolot solot.codsolot%type);*/
  procedure p_cargar_info_equ_dth(a_idtareawf in number,
                                  a_idwf      in number,
                                  a_tarea     in number,
                                  a_tareadef  in number); --10.0>
  procedure P_valorizar_liquidacion(n_idliq    number,
                                    n_codsolot number,
                                    n_punto    number,
                                    n_orden    number);

  PROCEDURE p_importar_sot_etapa(n_idliq    number,
                                 n_codsolot number,
                                 n_punto    number,
                                 n_orden    number);

  procedure p_importar_sot_etapa_liq(n_idliq number, n_codsolot number);

  procedure P_act_maestro_Series_mac1(n_idalm out number);

  procedure p_cargar_formula_act_mat(a_codsolot solot.codsolot%type,
                                     a_punto    solotpto.punto%type);

  procedure p_pre_liquidar_act_mat(a_codsolot solot.codsolot%type,
                                   a_punto    solotpto.punto%type);

  procedure p_liquidar_act_mat(a_codsolot solot.codsolot%type);

  procedure p_llenar_actxcontrataxprec(a_codact  in number,
                                       a_codprec in number);

  PROCEDURE P_act_maestro_Series_sap;

  PROCEDURE p_despacho_equ_mat(a_tipproyecto number,
                               a_Fecini      date,
                               a_Fecfin      date);

  PROCEDURE p_genera_pep_presupuesto(a_tipproyecto number,
                                     a_Fecini      date,
                                     a_Fecfin      date);

  function f_verificar_almacen_equ(a_codsolot in number,
                                   a_punto    in number,
                                   a_nroserie in varchar2,
                                   a_cod_sap  in varchar2) return number;

  procedure p_cargar_info_equ_cdma_gsm(a_idtareawf in number,
                                       a_idwf      in number,
                                       a_tarea     in number,
                                       a_tareadef  in number);
  PROCEDURE p_genera_plano_gis(a_codsolot  number,
                               a_punto     number,
                               a_orden     number,
                               a_idtareawf number);

  PROCEDURE p_elimina_plano_gis(a_idplano number);

  PROCEDURE p_cargar_equ_cdma_gsm(a_idtareawf IN NUMBER,
                                  a_idwf      IN NUMBER,
                                  a_tarea     IN NUMBER,
                                  a_tareadef  IN NUMBER); -- 15.0
  --< 34.0 Agrega Ejecucion de Equipos PROY-LIMFTPV02 >
  PROCEDURE SGASS_PROCESO_EQUIPOS ;
  PROCEDURE SGASS_PROCESO_MATERIALES (V_CODSAP  AGENLIQ.SGAT_RESUMENEQUIMAT.COD_SAP%TYPE,
                                      V_CENTRO  AGENLIQ.SGAT_RESUMENEQUIMAT.CENTRO%TYPE,
                                      V_ALMACEN AGENLIQ.SGAT_RESUMENEQUIMAT.ALMACEN%TYPE,
                                      --V_CANTIDAD AGENLIQ.SGAT_RESUMENEQUIMAT.REQUN_CANTIDAD%TYPE,
                                      V_CANTIDAD VARCHAR2,
                                      V_UNIMED   AGENLIQ.SGAT_RESUMENEQUIMAT.REQUV_UNIMED%TYPE,
                                      V_VALOR    AGENLIQ.SGAT_RESUMENEQUIMAT.CODVALOR%TYPE,
                                      V_ERROR    OUT NUMBER,
                                      V_MSJ      OUT VARCHAR2);
  PROCEDURE SGASS_LISTA_OC   (PI_PARAM     IN VARCHAR2,
                              PO_DATO      OUT SYS_REFCURSOR,
                              PO_COD_ERROR OUT NUMBER,
                              PO_DES_ERROR OUT VARCHAR2);
  PROCEDURE SGASS_COMPLETA_OC (PI_PARAM     IN NUMBER,
                               PI_ID        IN AGENLIQ.SGAT_DOC_LIQUIDA_OC.DLOCN_IDDOCLIQOC%TYPE,
                               PI_CONTRATO  IN AGENLIQ.SGAT_DOC_LIQUIDA_OC.DLOCV_CONTR_MARCO%TYPE,
                               PI_CODMAT    IN AGENLIQ.SGAT_DOC_LIQUIDA_OC.DLOCV_COD_MATERIAL%TYPE,
                               PI_ITEM      IN AGENLIQ.SGAT_DOC_LIQUIDA_OC.DLOCN_POSICION_CONTR%TYPE,
                               PO_COD_ERROR OUT NUMBER,
                               PO_DES_ERROR OUT VARCHAR2);                              
  --<34.0 FIN >                                      
END;
/