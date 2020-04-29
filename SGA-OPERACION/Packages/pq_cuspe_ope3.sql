CREATE OR REPLACE PACKAGE OPERACION.PQ_CUSPE_OPE3 IS
  /*********************************************************************************************************
  NOMBRE:     PQ_CUSPE_OPE3
  PROPOSITO:  Manejo de la Liberación de Recursos Wimax y HFC Claro Empresas
  PROGRAMADO EN JOB:  SI
  Nota : Los siguientes procedimientos se copiaron de OPERACION.pq_cuspe_ope2 y se les aumentó
         al final del nombre "_wimax" (a la mayoria de ellos):
  
         p_int_iw_solot_anuladas
         p_anula_sot_inst_shell_wimax
         p_libera_reserva_shell_wimax
         p_libera_numero_shell_wimax

  REVISIONES:
  Version      Fecha        Autor              Descripcisn
  ---------  ----------  ---------------       ------------------------
  1.0        10/06/2013  Ronald Ramirez        PROY-8175 - Liberación de Recursos Wimax y HFC Claro Empresas
  **********************************************************************************************************/

  -- Declaraciones Globales
  TYPE CUR_SEC IS REF CURSOR;
  
  procedure p_int_iw_solot_anuladas(p_codsolot in solot.codsolot%type);

/*****************************************************************************/
  procedure p_anula_sot_inst_shell_wimax;

  procedure p_libera_reserva_shell_wimax(a_codsolot   in solot.codsolot%type,
                                         a_enviar_itw in number default 0,
                                         o_mensaje    out varchar2,
                                         o_error      out number);

  procedure p_libera_numero_shell_wimax(a_codsolot in number,
                                        o_mensaje  out varchar2,
                                        o_error    out number);

  procedure p_trs_baja_anulacion_ejecutar( ad_fecha  in varchar2,
                                           o_mensaje out varchar2,
                                           o_error   out number);

  procedure p_trs_baja_anulacion_insertar( a_codsolot in number,
                                           a_codcli   in varchar2,
                                           a_tipsrv   in varchar2,
                                           o_mensaje  out varchar2,
                                           o_error    out number);

  procedure p_trs_baja_anulacion_anular( a_codsolot in number,
                                         a_observa  in varchar2,
                                         o_mensaje  out varchar2,
                                         o_error    out number);

  procedure p_trs_baja_anulacion_update( a_codsolot in number,
                                         ad_fecprog in date,
                                         o_mensaje  out varchar2,
                                         o_error    out number);

  procedure p_obt_parametro_sot_wimax(ac_transaccion     in varchar2,
                                      an_wfdef_asigna    out number,
                                      an_tiptra_asigna   out number,
                                      an_area_asigna     out number,
                                      an_codmotot_asigna out number,
                                      av_observacion_sot out varchar2,
                                      o_resultado        out number,
                                      o_mensaje          out varchar2);

  procedure p_crea_sot_baja_wimax( av_trans       in atccorp.atc_parametro_sot.transaccion%type,
                                   an_codsolot_i  in number,
                                   an_codsolot_b  out number,
                                   o_resultado    out number,
                                   o_mensaje      out varchar2);

  procedure p_trs_baja_anulacion_enviar( ad_fecha  in varchar2,
                                         o_mensaje out varchar2,
                                         o_error   out number, 
                                         ac_salida OUT CUR_SEC);
/*****************************************************************************/

END;
/