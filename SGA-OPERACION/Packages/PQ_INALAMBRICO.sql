CREATE OR REPLACE PACKAGE OPERACION.PQ_INALAMBRICO IS

  /*******************************************************************************
     NOMBRE:       PQ_INALAMBRICO
     PROPOSITO:

     REVISIONES:
     Ver        Fecha        Autor           Solicitado por Descripcion
     ---------  ----------  ---------------  --------------  ----------------------

      1.0       01/02/2010  Antonio Lagos                    REQ 106908, DTH + CDMA
      2.0       24/03/2010  Antonio Lagos                    REQ 119998, DTH + CDMA, recarga y reconexion
      3.0       22/02/2010  Antonio Lagos    Juan Gallegos   REQ 126937, DTH + CDMA, nuevo campo configurable de
                                                             valor de recarga enviada a OCS
      4.0       16/06/2010  Antonio Lagos    Juan Gallegos   REQ 119999, DTH + CDMA, baja y corte
      5.0       28/05/2010  Vicky Sánchez    Juan Gallegos   Se cambia la forma de obtener el idrecarga en la funcion f_obtener_idrecarga
                                                             y en el proc. p_pos_actualizar recarga se agregó logica para insertar tablas intermedias con INT
      6.0       16/09/2010  Antonio Lagos    Juan Gallegos   REQ.142338, Migracion DTH
      7.0       30/09/2010  Antonio Lagos    Jose Ramos      REQ.144641 correccion en carga de actividades en baja
      8.0       01/10/2010  Joseph Asencios  Juan Gallegos   REQ Migración CDMA
      9.0       05/10/2010  Antonio Lagos    Jose Ramos      REQ.145222 alta baja DTH
      10.0      12/10/2010  Joseph Asencios  Jose Ramos      REQ 145745: Se modifica proc. p_pos_actualizar_recarga para eliminar registro
                                                             de la tabla reginsdth_web cuando se realice una baja.
      11.0      18/10/2010  Joseph Asencios  Manuel Gallegos REQ-145961: Se modificó el proc p_pos_actualizar_recarga
                                                             para actualizar la SOT al estado Atendida.
      12.0      15/10/2010  Alfonso Perez    Yuri Lingán     Se aplica promociones de canales adicionales y fecha de vigencia <Proyecto DTH Venta Nueva>
                                                             REQ 140740
      13.0      26/10/2010  Joseph Asencios  Manuel Gallegos REQ-136578: Creación de función f_obt_tipo_srv_rec que determina si un servicio es DTH/CDMA/BUMDLE
      14.0      15/10/2010  Yuri Lingán      José Ramos      Se migra la tabla bouquetxreginsdth a rec_bouquetxreginsdth_cab
                                                             REQ 148666
      15.0      23/12/2010  Alfonso Pérez    José Ramos      REQ 152200 Error en el caculo de las fechas de vigencia cuando tiene un corte en proceso
      16.0      11/01/2011  Alfonso Pérez    José Ramos      REQ 158549 retornar a la version 14.0
      17.0      17/03/2011  Ronal C.         Melvin Balcazar Proyecto Suma de Cargos
                                                             p_pos_actualizar_recarga() se agrega PQ_PAQUETE_RECARGA.P_INS_SERVICIO(), campos IDGRUPO y PID
      18.0      19/09/2011  Ivan Untiveros   Guillermo Salcedo  REQ-161004 Sincronizacion WEBUNI : FR-10
      19.0      20/12/2011  Carlos Lazarte   Edilberto Astulle  RQM 160993: PQT-40103-TSK-2475 PROY-1508 CIERRE MASIVO DE BAJAS DTH
      20.0      07/11/2011  Widmer Quispe                      Sincronización 11/05/2012 -  REQ 161199 - DTH Post Venta Sincronizacion
      21.0      11/11/2011  Mauro Zegarra   Guillermo Salcedo  Sincronización 11/05/2012 -  REQ-161199 RF-07
      22.0      14/08/2012  Mauro Zegarra   Hector Huaman     SD-243176: Mejoras DTH Postpago
      23.0      12/11/2012  Cristiam Vega   Hector Huaman      Proy - 5731 Se modifico para invocar el web service de envio a BSCS, y actualizacion de las serie de trajetas y decos en sisact
      24.0      27/11/2012  Hector Huaman                      SD-368769 Mejoras DTH Postpago
      25.0      27/11/2012  Hector Huaman                      SD-385969 Mejoras DTH Postpago
      26.0      14/03/2013  Juan C. Ortiz    Hector Huaman     Req 163947 - Diferencia archivos de señal DTH (SGA)
      27.0      15/04/2013  Dorian Sucasaca Francisco Lucar   Req-164175: Activación y desactivación de Servicios DTH
      28.0      25/06/2013  Fernando Pacheco Hector Huaman    REQ-164289 Mejora activaciones DTH - SGA - BSCS
      29.0      28/08/2013  Hector Huaman                     SD-744299 Problemas para Consultas de Tarjetas
      30.0      01/09/2014  Angel Condori    Manuel Gallegos  PROY-12688:Ventas Convergentes
      31.0      09/08/2014  Michael Boza       Alicia Peña   Req: PROY-14342-IDEA-12729-Mejorar Proceso de Suspensión DTH
	  32.0      30/09/2015  Emma Guzman                       PROY-20152
      33.0      15/12/2015  Dorian Sucasaca                   PQT-247649-TSK-76965
      34.0      30/05/2016  Luis Polo B.     Karen Vasquez    SGA-SD-794552
      35.0      01/07/2017  Luis Guzman      Tito Huera       PROY-27792 IDEA-34954 - Proyecto LTE
      36.0      01/06/2018  Marleny Teque/   Justiniano Condori PROY-32581-Postventa LTE/HFC
                            Jose Antonio
      37.0      26/07/2018  Marleny Teque/   Justiniano Condori PROY-32581-Postventa LTE/HFC
  *********************************************************************/

  --<2.0
  cn_esttarea_ejecucion CONSTANT esttarea.esttarea%TYPE := 2; --en ejecucion
  cn_esttarea_cerrado   CONSTANT esttarea.esttarea%TYPE := 4; --cerrado
  cn_esttarea_error     CONSTANT esttarea.esttarea%TYPE := 19; --error
  cn_esttarea_new       CONSTANT esttarea.esttarea%TYPE := 1; --generado

  OPE_OCS_REC_VIR constant varchar2(10) := '43'; -- recarga virtual
  TIPO_PARAM_DEF  constant varchar2(10) := '3'; --tipo de parametro por defecto
  --2.0>
  --<4.0
  PLAT_OCS         constant varchar2(5) := '5'; --plataforma OCS
  OPE_OCS_CONSULTA constant varchar2(10) := '7'; --consulta de informacion de cuenta OCS
  PAQ_INALAMBRICO  constant char(4) := '0077'; --id de paquete inalambrico
  --4.0>
  C_BAJA           constant char(1) := 'B'; -- 36.0
  C_ALTA           constant char(1) := 'A'; -- 36.0

  PROCEDURE p_cargar_datos_inalambrico(a_idtareawf IN NUMBER,
                                       a_idwf      IN NUMBER,
                                       a_tarea     IN NUMBER,
                                       a_tareadef  IN NUMBER);

  PROCEDURE p_cerrar_datos_inalambrico(a_idtareawf IN NUMBER,
                                       a_idwf      IN NUMBER,
                                       a_tarea     IN NUMBER,
                                       a_tareadef  IN NUMBER);

  procedure p_cargar_equ_dth(a_idtareawf in number,
                             a_idwf      in number,
                             a_tarea     in number,
                             a_tareadef  in number);

  function f_obtener_idpaq(a_codsolot solot.codsolot%type) return number;

  function f_obtener_numregistro(a_codsolot solot.codsolot%type)
    return varchar2;

  function f_valida_transaccion_conax(a_codsolot solot.codsolot%type)
    return number;

  PROCEDURE p_cerrar_transaccion_conax(a_idtareawf IN NUMBER,
                                       a_idwf      IN NUMBER,
                                       a_tarea     IN NUMBER,
                                       a_tareadef  IN NUMBER);

  procedure p_cargar_recarga(a_codsolot solot.codsolot%type);

  procedure p_liquidacion_aut(a_idtareawf in number,
                              a_idwf      in number,
                              a_tarea     in number,
                              a_tareadef  in number);

  procedure p_activar_recarga(a_idtareawf in number,
                              a_idwf      in number,
                              a_tarea     in number,
                              a_tareadef  in number);

  --<2.0

  function f_obtener_estado_serv(a_numregistro varchar2) return varchar2;

  --actualizacion de vigencia en SGA
  --ini 6.0
  --PROCEDURE p_pos_actualiza_vigencia(a_idtareawf IN NUMBER,
  PROCEDURE p_pos_validacion(a_idtareawf IN NUMBER,
                             --fin 6.0
                             a_idwf     in number,
                             a_tarea    in number,
                             a_tareadef in number);

  --actualizacion de vigencia en SGA
  --<4.0
  /*procedure p_pre_actualiza_vigencia(a_idtareawf in number,
  a_idwf      in number,
  a_tarea     in number,
  a_tareadef  in number);*/
  --4.0>

  --recarga de saldo y actualizacion de vigencia en OCS
  PROCEDURE p_chg_recarga_cdma(a_idtareawf in number,
                               a_idwf      in number,
                               a_tarea     in number,
                               a_tareadef  in number,
                               a_tipesttar in number,
                               a_esttarea  in number,
                               a_mottarchg in number,
                               a_fecini    in date,
                               a_fecfin    in date);

  --recarga de saldo y actualizacion de vigencia en OCS
  procedure p_pre_recarga_cdma(a_idtareawf in number,
                               a_idwf      in number,
                               a_tarea     in number,
                               a_tareadef  in number);
  --Ini 5.0
  procedure p_obtener_monto_srv(an_tipo        number,
                                ac_numregistro varchar2,
                                an_idrecarga   vtatabrecarga.idrecarga%type,
                                an_codinssrv   number,
                                an_monto_srv   out number,
                                an_cod_error   out number,
                                ac_des_error   out varchar2);
  function f_obt_monto_recargaxpaquete(an_idrecarga vtatabrecargaxpaquete.idrecarga%type,
                                       an_idpaq     vtatabrecargaxpaquete.idpaq%type)
    return vtatabrecargaxpaquete.monto%type;
  --Fin 5.0
  --procedure p_obtener_monto_srv(a_numregistro varchar2,a_monto number,a_codinssrv number,a_monto_srv out number, a_idrecarga out number); --3.0
  procedure p_obtener_monto_srv(a_tipo        number,
                                a_numregistro varchar2,
                                a_monto       number,
                                a_codinssrv   number,
                                a_monto_srv   out number,
                                a_idrecarga   out number); --3.0
  function f_obtener_idrecarga(a_idcupon number) return number;

  --se envia reconexion hacia conax
  PROCEDURE p_chg_reconexion_conax(a_idtareawf in number,
                                   a_idwf      in number,
                                   a_tarea     in number,
                                   a_tareadef  in number,
                                   a_tipesttar in number,
                                   a_esttarea  in number,
                                   a_mottarchg in number,
                                   a_fecini    in date,
                                   a_fecfin    in date);

  --se envia reconexion hacia conax
  procedure p_pre_reconexion_conax(a_idtareawf in number,
                                   a_idwf      in number,
                                   a_tarea     in number,
                                   a_tareadef  in number);

  PROCEDURE p_pos_actualizar_recarga(a_idtareawf IN NUMBER,
                                     a_idwf      IN NUMBER,
                                     a_tarea     IN NUMBER,
                                     a_tareadef  IN NUMBER);

  --<4.0
  /*PROCEDURE p_pre_actualizar_recarga(a_idtareawf IN NUMBER,
  a_idwf      IN NUMBER,
  a_tarea     IN NUMBER,
  a_tareadef  IN NUMBER);*/
  --4.0>
  --2.0>
  --<4.0
  --se envia corte hacia conax
  PROCEDURE p_chg_corte_conax(a_idtareawf in number,
                              a_idwf      in number,
                              a_tarea     in number,
                              a_tareadef  in number,
                              a_tipesttar in number,
                              a_esttarea  in number,
                              a_mottarchg in number,
                              a_fecini    in date,
                              a_fecfin    in date);
  --se envia corte hacia conax
  procedure p_pre_corte_conax(a_idtareawf in number,
                              a_idwf      in number,
                              a_tarea     in number,
                              a_tareadef  in number);

  --Verifica estado y fechas de vigencia en OCS
  procedure p_pos_verificacion_ocs(a_idtareawf in number,
                                   a_idwf      IN NUMBER,
                                   a_tarea     IN NUMBER,
                                   a_tareadef  IN NUMBER);

  --verifica que la SOT tenga asociada una agenda
  PROCEDURE p_pos_agendamiento(a_idtareawf in number,
                               a_idwf      IN NUMBER,
                               a_tarea     IN NUMBER,
                               a_tareadef  IN NUMBER);
  --4.0>
  -- ini 6.0
  function f_obtener_tipbqd(a_numregistro ope_srv_recarga_cab.numregistro%type)
    return number;
  -- fin 6.0

  --ini 8.0
  procedure p_cargar_equ_cdma(a_idtareawf in number,
                              a_idwf      in number,
                              a_tarea     in number,
                              a_tareadef  in number);
  --fin 8.0

  --ini 13.0
  function f_obt_tipo_srv_rec(a_numregistro ope_srv_recarga_cab.numregistro%type)
    return number;
  --fin 13.0

  --ini 19.0
  procedure p_chg_desactivar_conax_dth(a_idtareawf in number,
                                       a_idwf      in number,
                                       a_tarea     in number,
                                       a_tareadef  in number,
                                       a_tipesttar in number,
                                       a_esttarea  in number,
                                       a_mottarchg in number,
                                       a_fecini    in date,
                                       a_fecfin    in date);
  --fin 19.0
  --ini 28.0
  procedure p_act_estado_equ(a_codsolot solot.codsolot%type);
  --<29.0
  /*PROCEDURE p_consulta_dth(pv_numero_serie in varchar2,
                           pn_tipo         in number,
                           pv_nomcli       out marketing.vtatabcli.nomcli%type,
                           pv_estado       out varchar2,
                           pv_codresp      out varchar2,
                           pv_mesresp      out varchar2);*/
 --29.0>
  --fin 28.0

--INI 32.0
   PROCEDURE p_cargar_datos_inalambrico_lte(a_idtareawf IN NUMBER,
                                            a_idwf      IN NUMBER,
                                            a_tarea     IN NUMBER,
                                            a_tareadef  IN NUMBER);
   procedure p_cargar_equ_dth_lte(a_idtareawf in number,
                                  a_idwf      in number,
                                  a_tarea     in number,
                                  a_tareadef  in number);

   PROCEDURE p_cerrar_datos_inalambrico_lte(a_idtareawf IN NUMBER,
                                            a_idwf      IN NUMBER,
                                            a_tarea     IN NUMBER,
                                            a_tareadef  IN NUMBER);

   PROCEDURE p_pos_agendamiento_lte(a_idtareawf in number,
                                    a_idwf      IN NUMBER,
                                    a_tarea     IN NUMBER,
                                    a_tareadef  IN NUMBER);
--FIN 32.0
-- ini 34.0
   PROCEDURE p_cargar_equ_dth_lte_deco(a_idtareawf IN NUMBER,
  	  								   a_idwf      IN NUMBER,
									   a_tarea     IN NUMBER,
									   a_tareadef  IN NUMBER);
--fin 34.0


	PROCEDURE sp_cambio_estado_sot(p_idtareawf tareawf.idtareawf%TYPE,
								   p_idwf      tareawf.idwf%TYPE,
								   p_tarea     tareawf.tarea%TYPE,
								   p_tareadef  tareawf.tareadef%TYPE);
	--36.0 Ini
	PROCEDURE SGASI_CARGA_EQU_DESDECO(PI_CODSOLOT IN NUMBER,
										  PO_COD      OUT NUMBER,
										  PO_MSG      OUT VARCHAR2);
	PROCEDURE SGASI_CARGAR_RECARGA(PI_IDTAREAWF IN NUMBER,
								   PI_IDWF      IN NUMBER,
								   PI_TAREA     IN NUMBER,
								   PI_TAREADEF  IN NUMBER);

    PROCEDURE SGASI_SINCR_CAMBIOEQU(PI_CODSOLOT IN NUMBER,
									PO_COD      OUT NUMBER,
									PO_MSG      OUT VARCHAR2);
	--36.0 Fin
	--37.0 Ini
	PROCEDURE SGASI_CARGA_EQU_MIX_DECO(PI_CODSOLOT IN NUMBER,
									   PO_COD      OUT NUMBER,
									   PO_MSG      OUT VARCHAR2);
	--37.0 Fin
END;
/