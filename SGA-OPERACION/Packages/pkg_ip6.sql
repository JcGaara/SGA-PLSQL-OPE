create or replace package operacion.pkg_ip6 is
  /****************************************************************************
   Nombre Package    : pkg_ip6
   Proposito         : Realizar el subneteo de ipv6
   REVISIONES:
   Ver  Fecha        Autor              Solicitado por     Descripcion
   ---  -----------  -----------------  -----------------  ----------------------------------------
   1.0  28/11/217                                          PROY-26959 - IDEA-34740 - Habilitación de módulos para recursos IPV6
  ****************************************************************************/
  procedure sgasi_ins_clasec_ip6(k_tipo_lan_wan_lb   char,
                                 k_mascara           number,
                                 k_ipv6              varchar2,
                                 k_codequipo         number,
                                 k_codprd            number,
                                 k_mascara_final_wan number);

  procedure sgasi_lan_genera_rangosmenor16(k_mascara_ingresada_por_usua number,
                                           k_ipv6                       varchar2,
                                           k_lan_ipc6n_id_padre         number,
                                           k_codequipo                  number,
                                           k_codprd                     number);

  procedure sgasi_l_gene_ran_menor_16_sig(k_mascara                  number,
                                          k_ipv6                     varchar2,
                                          k_lan_ipc6n_id_padre       number,
                                          k_codequipo                number,
                                          k_codprd                   number,
                                          k_posicion_fija            number,
                                          k_incremento_dec_malla_ant number);

  procedure sgasi_lan_genera16rangos(k_mascara            number,
                                     k_ipv6               varchar2,
                                     k_lan_ipc6n_id_padre number,
                                     k_codequipo          number,
                                     k_codprd             number);

  procedure sgasi_wan_genera(k_mascara_ini_ingre_usu   number,
                             k_ipv6                    varchar2,
                             k_wan_ipc6n_id_padre      number,
                             k_codequipo               number,
                             k_codprd                  number,
                             k_mascara_final_ingre_usu in number);

  procedure sgass_evaluar_generarip6(k_tipored varchar,
                                     k_mask    number,
                                     k_maskfin number,
                                     k_ipred   varchar,
                                     o_cursor  out sys_refcursor);

  procedure sgass_lst_ip_mascara(k_ipred  varchar,
                                 k_equipo number,
                                 k_tipred varchar,
                                 o_cursor out sys_refcursor);

  procedure sgass_lst_mascaras(k_idpadre number, o_cursor out sys_refcursor);

  procedure sgass_listar_tipo_red_ln(k_mask   number,
                                     k_ipred  varchar2,
                                     o_cursor out sys_refcursor);

  procedure sgass_listar_tipo_red_wn(k_mask   number,
                                     k_ipred  varchar2,
                                     o_cursor out sys_refcursor);

  procedure sgass_listar_tipo_red_lb(k_mask   number,
                                     k_ipred  varchar2,
                                     o_cursor out sys_refcursor);

  procedure sgasi_asigna_ip(k_rango number);

  procedure sgasi_desasigna_ip(k_rango   number,
                               k_tipodes char,
                               k_tipoip  varchar2,
                               k_ip      varchar2);

  procedure sgass_evaluar_ip6(k_ip  varchar2,
                              k_res out varchar2,
                              k_1   out varchar2,
                              k_2   out varchar2,
                              k_3   out varchar2,
                              k_4   out varchar2,
                              k_5   out varchar2,
                              k_6   out varchar2,
                              k_7   out varchar2,
                              k_8   out varchar2);

  procedure sgasu_upd_clasec_ip6(k_idclase number,
                                 k_estado  varchar2,
                                 k_rango   number);

  function sgasfun_ponerdospuntos(k_ipv6 varchar2) return char;

  function sgasfun_buscadenapuntos(k_ipv6 varchar2) return char;

  function sgasfun_lan_incremento_sub_red(k_mascara_ingre_usua number,
                                          k_ipv6               varchar2,
                                          k_posicion_fija      number)
    return number;

  function sgasfun_siguiente_multiplo_4(k_numero number) return integer;

  function sgasfun_lan_num_rangos_genera(k_mascara number) return integer;

  function sgasfun_lan_letra_sub_red_i(k_num_sub_red        number,
                                       k_mascara_ingre_usua number,
                                       k_ipv6               varchar2,
                                       k_posicion_fija      number)
    return char;

  function sgasfun_binario_a_decimal(k_binario char) return integer;

  function sgasfun_lan_posicion_fija32(k_mascara_ingresada_usuario number)
    return integer;

  function sgafun_existe_id_padre(k_idrango number)
    return number;

  function sgafun_valida_estado_ips(k_red        varchar2,
                                    k_ipc6c_tipo varchar2)
    return number;

  procedure sgass_elimina_red(k_red        varchar2,
                              k_ipc6c_tipo varchar2);

end;
/
