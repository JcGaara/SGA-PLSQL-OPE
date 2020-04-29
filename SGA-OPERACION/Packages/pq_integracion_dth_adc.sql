create or replace package operacion.pq_integracion_dth_adc  is
  /************************************************************
  NOMBRE:     pq_integracion_dth
  PROPOSITO:  Sincronizar tareas de Post Venta realizado por el sistema SIAC

  REVISIONES:
   Ver        Fecha        Autor           Solicitado por    Descripcion
  ---------  ----------  ---------------  --------------    ----------
  1.0        17/11/2011  Joseph Asencios  Hector Huaman     REQ-161362:Creación
  2.0        29/11/2011  Roy Concepcion   Hector Huaman     REQ-161362:Generacion de SOT para los tipos de transacción.
  3.0        31/05/2012  Alex Alamo       Hector Huaman     PROY-0642- DTH Postpago
  4.0        27/07/2012  Hector Huaman    Hector Huaman     PROY-3940- DTH Postpago (Mejoras): se creo procedimiento que anula la SOT
  5.0        10/09/2012  Mauro Zegarra    Christian Riquelme REQ-163185 Homologacion de Objetos para una incidencia SD 269175.
  6.0        07/12/2012  Juan Ortiz       Elver Ramirez      REQ-163669
  7.0        22/08/2013  Mauro Zegarra    Guillermo Salcedo  REQ-164606: Error al generar sot de instalacion de deco adicional
  8.0        31/10/2013  Fernando Pacheco Guillermo Salcedo  
  9.0        02/10/2015  Justiniano Condori Eustaquio Gibaja 3 PLAY INALAMBRICO
  10.0       21/11/2015  Angel Condori    Alberto Miranda    Alineacion a Produccion
  11.0       26/11/2015  Luis Romero      Paul Moya          PROY-17652 IDEA-22491 - ETAdirect
 *************************************************************/
    --Estados SOT
  cn_sot_gen         constant solot.estsol%type := 10; --Generada
  cn_solot_tipo      constant solotpto.tipo%type := 1;
  cn_solot_estado    constant solotpto.estado%type := 1;
  cn_solot_visible   constant solotpto.visible %type := 1;
  cv_traslado_externo varchar2(2):= 'TE';
  cv_traslado_interno varchar2(2):= 'TI';
  cv_mantenimiento    varchar2(2):= 'M';
  TYPE gc_salida is REF CURSOR;
  cn_anulado          constant number := 13;--4.0
  flag_eta            varchar2(3);

procedure p_centro_poblado(ac_ubigeo        in varchar2,
                           ao_cursor        out SYS_REFCURSOR,
                           an_codigo_error  out number,
                           ac_mensaje_error out varchar2);

procedure p_cobertura(an_idpoblado     in number,
                      an_valido        out number,
                      an_codigo_error  out number,
                      ac_mensaje_error out varchar2);

procedure p_consulta_solot(an_codsolot      in number,
                           ao_cursor        out SYS_REFCURSOR,
                           an_codigo_error  out number,
                           ac_mensaje_error out varchar2);

procedure p_consulta_tareas(an_codsolot      in number,
                            ao_cursor        out SYS_REFCURSOR,
                            an_codigo_error  out number,
                            ac_mensaje_error out varchar2);

  procedure p_ejecuta_transaccion_dth(av_tipo_trans in varchar2,
                                      an_cod_clarify in number,
                                      av_num_sec in varchar2,
                                      av_tipo_via in varchar2,
                                      av_nom_via  in varchar2,
                                      an_num_via  in number,
                                      an_tip_urb  in number,
                                      av_manzana  in varchar2,
                                      av_lote     in varchar2,
                                      av_ubigeo   in varchar2,
                                      av_referencia in varchar2,
                                      av_observacion in varchar2,
                                      ad_fec_prog in date,
                                      an_codsolot out number,
                                      av_error   out varchar2);

function f_obt_tip_transaccion(av_tip_tran varchar2) return number;

function f_obt_tip_transaccion_ti_dth return number;

function f_obt_tip_transaccion_te_dth return number;

function f_obt_tip_transaccion_m_dth return number;

function f_obt_area_sol_dth return number;

function f_obt_motivo_dth return number;

procedure p_obt_valor_nomsuc(av_nomsuc out varchar2, av_salida out varchar2);

procedure p_obt_valor_direccionsuc(av_dirsuc out varchar2, av_salida out varchar2);

PROCEDURE P_INS_INMUEBLE_DTH(AV_TIPVIAP IN varchar2,
                         AV_NOMVIA IN varchar2,
                         AV_NUMVIA IN varchar2,
                         AV_NOMURB IN varchar2,
                         AV_LOTE IN varchar2,
                         AV_MANZANA IN varchar2,
                         AV_REFERENCIA IN varchar2,
                         AV_CODUBI IN varchar2,
                         AN_IDINMUEBLE OUT INMUEBLE.IDINMUEBLE%TYPE);

procedure p_ins_sucurxcliente_dth( av_cod_cli  in varchar2,
                                    av_tipo_via in varchar2,
                                    av_nom_via  in varchar2,
                                    an_num_via  in number,
                                    an_tip_urb  in number,
                                    av_manzana  in varchar2,
                                    av_lote     in varchar2,
                                    av_ubigeo   in varchar2,
                                    av_referencia in varchar2,
                                    AC_CODSUC OUT VTASUCCLI.CODSUC%TYPE,
                                    vv_salida   out varchar2);

    /*Procedimiento que genera una SOT según el tipo de transacción*/
procedure p_crea_sot_postventa_post(ac_numregistro in varchar2,
                                 an_tip_trabajo      in number,
                                 ac_observacion      in varchar2,
                                 ac_tipo_traslado    in varchar2,
                                 ac_codubi           in varchar2,
                                 an_cod_clarify      in number,
                                 ad_fec_prog         in date,
                                 an_codsolot         out number,
                                 an_retorna          out number,
                                 ac_mensaje          out varchar2);
procedure p_validamaterial       (n_opcion           in number,
                                 ac_NumSerieDeco    in varchar2,
                                 ac_NumSerieTarjeta in varchar2,
                                 ac_salida          out gc_salida,
                                 ac_resultado       out varchar2,
                                 ac_mensaje         out varchar2);

--<4.0
procedure p_chg_solot(ln_numsec      in number,
                      ls_observacion in varchar2,
                      ln_estsol      in number,
                      an_codigo_error out number,
                      ac_mensaje_error out varchar2);
--4.0>
--Ini 6.0
procedure p_consulta_cambio_estado(n_codsolot   number,
                                   ac_salida    OUT SYS_REFCURSOR,
                                   ac_resultado out varchar2,
                                   ac_mensaje   out varchar2);
--Fin 6.0
-- Ini 9.0
procedure p_centro_poblado_lte(ac_ubigeo        in varchar2,
                                 ac_cobertura_dth in number,
                                 ac_cobertura_lte in number,
                                 ao_cursor        out SYS_REFCURSOR,
                                 an_codigo_error  out number,
                                 ac_mensaje_error out varchar2);
-- Fin 9.0
end pq_integracion_dth_adc;
/