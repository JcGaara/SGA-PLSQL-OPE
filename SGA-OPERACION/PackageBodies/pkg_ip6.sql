create or replace package body operacion.pkg_ip6 as
  /****************************************************************************
   Nombre Package    : pkg_ip6
   Proposito         : Realizar el subneteo de ipv6
   REVISIONES:
   Ver  Fecha        Autor              Solicitado por     Descripcion
   ---  -----------  -----------------  -----------------  ----------------------------------------
   1.0  28/11/217                                          PROY-26959 - IDEA-34740 - Habilitación de módulos para recursos IPV6
  ****************************************************************************/  
  --------------------------------------------------------------------------------
  procedure sgasi_ins_clasec_ip6(k_tipo_lan_wan_lb   char,
                                 k_mascara           number,
                                 k_ipv6              varchar2,
                                 k_codequipo         number,
                                 k_codprd            number,
                                 k_mascara_final_wan number) is
    /*
    ****************************************************************
    * Nombre SP         : SGASI_INS_CLASEC_IP6
    * Propósito         : Subneteo IPV6
    * Input             : k_tipo_lan_wan_lb   --> Tipo
                          k_mascara           --> Mascara
                          k_ipv6              --> IPV6
                          k_codequipo         --> Codigo Equipo
                          k_codprd            --> Codigo Producto
                          k_mascara_final_wan --> Mascara Final
    * Output            : 
    * Creado por        : 
    * Fec Creación      : 28/11/2017
    * Fec Actualización : N/A
    ****************************************************************
    */
    v_ipc6v_numero1 varchar2(4);
    v_ipc6v_numero2 varchar2(4);
    v_ipc6v_numero3 varchar2(4);
    v_ipc6v_numero4 varchar2(4);
    v_ipc6v_numero5 varchar2(4);
    v_ipc6v_numero6 varchar2(4);
    v_ipc6v_numero7 varchar2(4);
    v_ipc6v_numero8 varchar2(4);
    v_ipc6n_id      number(10, 0);
    --declaración de variables para loopback
    v_lo_posi_fija_ini_32          number(3, 0);
    v_lo_posi_ini_semi_variable_32 number;
    v_lo_cantidad_rangos           number;
    v_lo_num_letras_a_extraer_32   number(3, 0);
    v_lo_letra_sustraida_hex       char(16);
    v_lo_letra_binario             varchar2(16);
    v_lo_1era_posicion_fija_4_bit  number(3, 0);
    v_lo_parte_fija_inicial_4_bit  varchar2(16);
    v_lo_inicial_binario           char(16);
    v_lo_inicial_decimal           number;
    v_lo_incremento_en_decimal   number(4, 0);
    v_lo_ipc6n_id                number(10, 0);
    v_lo_letra_retornar_decimal  number := 0;
    v_lo_letra_retornar_hex      char(12);
    v_lo_ipv6_siguiente          varchar2(32);
    v_lo_ipc6v_numero1_siguiente varchar2(4);
    v_lo_ipc6v_numero2_siguiente varchar2(4);
    v_lo_ipc6v_numero3_siguiente varchar2(4);
    v_lo_ipc6v_numero4_siguiente varchar2(4);
    v_lo_ipc6v_numero5_siguiente varchar2(4);
    v_lo_ipc6v_numero6_siguiente varchar2(4);
    v_lo_ipc6v_numero7_siguiente varchar2(4);
    v_lo_ipc6v_numero8_siguiente varchar2(4);

  begin
    insert into trafficview.sgat_clasec6
      (clc6v_clasec,
       clc6n_estado,
       clc6v_codusu,
       clc6d_fecusu,
       clc6n_codequipo,
       clc6n_codprd,
       clc6n_prefijo)
    values
      (sgasfun_ponerdospuntos(k_ipv6),
       0,
       user,
       sysdate,
       k_codequipo,
       k_codprd,
       k_mascara);

    select substr(k_ipv6, 1, 4),
           substr(k_ipv6, 5, 4),
           substr(k_ipv6, 9, 4),
           substr(k_ipv6, 13, 4),
           substr(k_ipv6, 17, 4),
           substr(k_ipv6, 21, 4),
           substr(k_ipv6, 25, 4),
           substr(k_ipv6, 29, 4)
      into v_ipc6v_numero1,
           v_ipc6v_numero2,
           v_ipc6v_numero3,
           v_ipc6v_numero4,
           v_ipc6v_numero5,
           v_ipc6v_numero6,
           v_ipc6v_numero7,
           v_ipc6v_numero8
      from dual;

    select operacion.sq_sgat_ipxclasec6.nextval into v_ipc6n_id from dual;

    if k_tipo_lan_wan_lb = 'L' then
      --L (lan)    
      insert into trafficview.sgat_ipxclasec6
        (ipc6n_id,
         ipc6n_id_padre,
         ipc6v_clasec,
         ipc6v_numero,
         ipc6n_prefijo,
         ipc6c_tipo,
         ipc6v_codusu,
         clc6v_fecusu,
         ipc6v_codusumod,
         ipc6v_fecusumod,
         ipc6n_codequipo,
         ipc6n_codprd,
         ipc6v_numero1,
         ipc6v_numero2,
         ipc6v_numero3,
         ipc6v_numero4,
         ipc6v_numero5,
         ipc6v_numero6,
         ipc6v_numero7,
         ipc6v_numero8,
         ipc6v_estado)
      values
        (v_ipc6n_id,
         v_ipc6n_id,
         sgasfun_ponerdospuntos(k_ipv6),
         '0000',
         k_mascara,
         'L',
         user,
         sysdate,
         user,
         sysdate,
         k_codequipo,
         k_codprd,
         v_ipc6v_numero1,
         v_ipc6v_numero2,
         v_ipc6v_numero3,
         v_ipc6v_numero4,
         v_ipc6v_numero5,
         v_ipc6v_numero6,
         v_ipc6v_numero7,
         v_ipc6v_numero8,
         'L');
    
      if sgasfun_lan_num_rangos_genera(k_mascara) = 16 then
        sgasi_lan_genera16rangos(k_mascara,
                                 k_ipv6,
                                 v_ipc6n_id,
                                 k_codequipo,
                                 k_codprd);
      end if;
    
      if sgasfun_lan_num_rangos_genera(k_mascara) < 16 then
        sgasi_lan_genera_rangosmenor16(k_mascara,
                                       k_ipv6,
                                       v_ipc6n_id,
                                       k_codequipo,
                                       k_codprd);
      end if;
    end if;

    if k_tipo_lan_wan_lb = 'W' then
      --W (Wan)    
      insert into trafficview.sgat_ipxclasec6
        (ipc6n_id,
         ipc6n_id_padre,
         ipc6v_clasec,
         ipc6v_numero,
         ipc6n_prefijo,
         ipc6c_tipo,
         ipc6v_codusu,
         clc6v_fecusu,
         ipc6v_codusumod,
         ipc6v_fecusumod,
         ipc6n_codequipo,
         ipc6n_codprd,
         ipc6v_numero1,
         ipc6v_numero2,
         ipc6v_numero3,
         ipc6v_numero4,
         ipc6v_numero5,
         ipc6v_numero6,
         ipc6v_numero7,
         ipc6v_numero8,
         ipc6v_estado)
      values
        (v_ipc6n_id,
         v_ipc6n_id,
         sgasfun_ponerdospuntos(k_ipv6),
         v_ipc6v_numero8,
         k_mascara,
         'W',
         user,
         sysdate,
         user,
         sysdate,
         k_codequipo,
         k_codprd,
         v_ipc6v_numero1,
         v_ipc6v_numero2,
         v_ipc6v_numero3,
         v_ipc6v_numero4,
         v_ipc6v_numero5,
         v_ipc6v_numero6,
         v_ipc6v_numero7,
         v_ipc6v_numero8,
         'L');
    
      sgasi_wan_genera(k_mascara,
                       k_ipv6,
                       v_ipc6n_id,
                       k_codequipo,
                       k_codprd,
                       k_mascara_final_wan);
    end if;

    if k_tipo_lan_wan_lb = 'LO' then
      --LO (LoopBack)
      insert into trafficview.sgat_ipxclasec6
        (ipc6n_id,
         ipc6n_id_padre,
         ipc6v_clasec,
         ipc6v_numero,
         ipc6n_prefijo,
         ipc6c_tipo,
         ipc6v_codusu,
         clc6v_fecusu,
         ipc6v_codusumod,
         ipc6v_fecusumod,
         ipc6n_codequipo,
         ipc6n_codprd,
         ipc6v_numero1,
         ipc6v_numero2,
         ipc6v_numero3,
         ipc6v_numero4,
         ipc6v_numero5,
         ipc6v_numero6,
         ipc6v_numero7,
         ipc6v_numero8,
         ipc6v_estado)
      values
        (v_ipc6n_id,
         v_ipc6n_id,
         sgasfun_ponerdospuntos(k_ipv6),
         '0000',
         k_mascara,
         'LO',
         user,
         sysdate,
         user,
         sysdate,
         k_codequipo,
         k_codprd,
         v_ipc6v_numero1,
         v_ipc6v_numero2,
         v_ipc6v_numero3,
         v_ipc6v_numero4,
         v_ipc6v_numero5,
         v_ipc6v_numero6,
         v_ipc6v_numero7,
         v_ipc6v_numero8,
         'L');
    
      v_lo_cantidad_rangos := power(2, (128 - k_mascara));
    
      v_lo_posi_fija_ini_32          := sgasfun_lan_posicion_fija32(k_mascara);
      v_lo_posi_ini_semi_variable_32 := ceil((k_mascara + 1) / 4);
    
      v_lo_num_letras_a_extraer_32 := 32 - v_lo_posi_ini_semi_variable_32 + 1;
    
      v_lo_letra_sustraida_hex := substr(k_ipv6,
                                         v_lo_posi_ini_semi_variable_32,
                                         v_lo_num_letras_a_extraer_32);
    
      v_lo_letra_binario := null;
    
      for i in 1 .. v_lo_num_letras_a_extraer_32 loop
        case trim(substr(v_lo_letra_sustraida_hex, i, 1))
          when '0' then
            v_lo_letra_binario := trim(v_lo_letra_binario || '0000');
          when '1' then
            v_lo_letra_binario := trim(v_lo_letra_binario || '0001');
          when '2' then
            v_lo_letra_binario := trim(v_lo_letra_binario || '0010');
          when '3' then
            v_lo_letra_binario := trim(v_lo_letra_binario || '0011');
          when '4' then
            v_lo_letra_binario := trim(v_lo_letra_binario || '0100');
          when '5' then
            v_lo_letra_binario := trim(v_lo_letra_binario || '0101');
          when '6' then
            v_lo_letra_binario := trim(v_lo_letra_binario || '0110');
          when '7' then
            v_lo_letra_binario := trim(v_lo_letra_binario || '0111');
          when '8' then
            v_lo_letra_binario := trim(v_lo_letra_binario || '1000');
          when '9' then
            v_lo_letra_binario := trim(v_lo_letra_binario || '1001');
          when 'A' then
            v_lo_letra_binario := trim(v_lo_letra_binario || '1010');
          when 'B' then
            v_lo_letra_binario := trim(v_lo_letra_binario || '1011');
          when 'C' then
            v_lo_letra_binario := trim(v_lo_letra_binario || '1100');
          when 'D' then
            v_lo_letra_binario := trim(v_lo_letra_binario || '1101');
          when 'E' then
            v_lo_letra_binario := trim(v_lo_letra_binario || '1110');
          when 'F' then
            v_lo_letra_binario := trim(v_lo_letra_binario || '1111');
        end case;
      
      end loop;
    
      v_lo_1era_posicion_fija_4_bit := mod(k_mascara, 4);
    
      if v_lo_1era_posicion_fija_4_bit >= 1 then
        v_lo_parte_fija_inicial_4_bit := substr(v_lo_letra_binario,
                                                1,
                                                v_lo_1era_posicion_fija_4_bit);
      
        v_lo_inicial_binario := rpad(v_lo_parte_fija_inicial_4_bit,
                                     (4 * v_lo_num_letras_a_extraer_32),
                                     '0'); --cuando sea de varios hextetos será 8 (para dos hextetos),12(para 3 hextetos)
      
      end if;
    
      if v_lo_1era_posicion_fija_4_bit = 0 then
        v_lo_inicial_binario := rpad('0', (4 * v_lo_num_letras_a_extraer_32), '0'); --cuando sea de varios hextetos será 8 (para dos hextetos),12(para 3 hextetos)
      end if;
    
      v_lo_inicial_decimal := sgasfun_binario_a_decimal(v_lo_inicial_binario);
    
      v_lo_incremento_en_decimal := 1;
     
      for i in 1 .. v_lo_cantidad_rangos loop
      
        select operacion.sq_sgat_ipxclasec6.nextval into v_lo_ipc6n_id from dual;
      
        v_lo_letra_retornar_decimal := v_lo_inicial_decimal +
                                       ((i - 1) * v_lo_incremento_en_decimal);
      
        v_lo_letra_retornar_hex := trim(to_char(v_lo_letra_retornar_decimal,
                                                'XXXX')); --Convertir de decimal a hexadecimal
      
        v_lo_letra_retornar_hex := lpad(trim(v_lo_letra_retornar_hex),
                                        v_lo_num_letras_a_extraer_32,
                                        '0'); --completa con ceros a la izquierda de ser necesario
      
        select trim(concat(substr(k_ipv6, 1, v_lo_posi_fija_ini_32),
                           v_lo_letra_retornar_hex))
          into v_lo_ipv6_siguiente
          from dual;
      
        select substr(v_lo_ipv6_siguiente, 1, 4),
               substr(v_lo_ipv6_siguiente, 5, 4),
               substr(v_lo_ipv6_siguiente, 9, 4),
               substr(v_lo_ipv6_siguiente, 13, 4),
               substr(v_lo_ipv6_siguiente, 17, 4),
               substr(v_lo_ipv6_siguiente, 21, 4),
               substr(v_lo_ipv6_siguiente, 25, 4),
               substr(v_lo_ipv6_siguiente, 29, 4)
          into v_lo_ipc6v_numero1_siguiente,
               v_lo_ipc6v_numero2_siguiente,
               v_lo_ipc6v_numero3_siguiente,
               v_lo_ipc6v_numero4_siguiente,
               v_lo_ipc6v_numero5_siguiente,
               v_lo_ipc6v_numero6_siguiente,
               v_lo_ipc6v_numero7_siguiente,
               v_lo_ipc6v_numero8_siguiente
          from dual;
      
        insert into trafficview.sgat_ipxclasec6
          (ipc6n_id,
           ipc6n_id_padre,
           ipc6v_clasec,
           ipc6v_numero,
           ipc6n_prefijo,
           ipc6c_tipo,
           ipc6v_codusu,
           clc6v_fecusu,
           ipc6v_codusumod,
           ipc6v_fecusumod,
           ipc6n_codequipo,
           ipc6n_codprd,
           ipc6v_numero1,
           ipc6v_numero2,
           ipc6v_numero3,
           ipc6v_numero4,
           ipc6v_numero5,
           ipc6v_numero6,
           ipc6v_numero7,
           ipc6v_numero8,
           ipc6v_estado)
        values
          (v_lo_ipc6n_id,
           v_ipc6n_id,
           sgasfun_ponerdospuntos(v_lo_ipv6_siguiente),
           v_lo_ipc6v_numero8_siguiente,
           k_mascara,
           'LO',
           user,
           sysdate,
           user,
           sysdate,
           k_codequipo,
           k_codprd,
           v_lo_ipc6v_numero1_siguiente,
           v_lo_ipc6v_numero2_siguiente,
           v_lo_ipc6v_numero3_siguiente,
           v_lo_ipc6v_numero4_siguiente,
           v_lo_ipc6v_numero5_siguiente,
           v_lo_ipc6v_numero6_siguiente,
           v_lo_ipc6v_numero7_siguiente,
           v_lo_ipc6v_numero8_siguiente,
           'L');
      
      end loop;
    end if;
  end;
  --------------------------------------------------------------------------------
  procedure sgasi_lan_genera_rangosmenor16(k_mascara_ingresada_por_usua number,
                                           k_ipv6                       varchar2,
                                           k_lan_ipc6n_id_padre         number,
                                           k_codequipo                  number,
                                           k_codprd                     number) is
    /*
    ****************************************************************
    * Nombre SP         : SGASI_LAN_GENERA_RANGOSMENOR16
    * Propósito         : Genera Rango
    * Input             : k_mascara_ingresada_por_usua   --> Mascara Ingresada
                          k_ipv6                         --> IPV6
                          k_lan_ipc6n_id_padre           --> Mascara padre
                          k_codequipo                    --> Codigo Equipo
                          k_codprd                       --> Codigo Producto
    * Output            : 
    * Creado por        : 
    * Fec Creación      : 28/11/2017
    * Fec Actualización : N/A
    ****************************************************************
    */
    v_lan_ipc6n_id             number(10, 0);
    v_posicion_fija            number;
    v_ipv6_siguiente           char(32);
    v_ipc6v_numero1_siguiente  varchar2(4);
    v_ipc6v_numero2_siguiente  varchar2(4);
    v_ipc6v_numero3_siguiente  varchar2(4);
    v_ipc6v_numero4_siguiente  varchar2(4);
    v_ipc6v_numero5_siguiente  varchar2(4);
    v_ipc6v_numero6_siguiente  varchar2(4);
    v_ipc6v_numero7_siguiente  varchar2(4);
    v_ipc6v_numero8_siguiente  varchar2(4);
    v_mascara_siguiente        number(3, 0);
    v_letra_a_insertar         char(1);
    v_rango_maximo_lan         number;
    v_incremento_dec_sig_malla number;

  begin
    select codigon
      into v_rango_maximo_lan
      from operacion.opedd
     where abreviacion = trim('RANGO_LAN');

    if (k_mascara_ingresada_por_usua < v_rango_maximo_lan) then
    
      v_posicion_fija     := sgasfun_lan_posicion_fija32(k_mascara_ingresada_por_usua);
      v_mascara_siguiente := sgasfun_siguiente_multiplo_4(k_mascara_ingresada_por_usua);
    
      v_incremento_dec_sig_malla := 1;
    
      for i in 1 .. sgasfun_lan_num_rangos_genera(k_mascara_ingresada_por_usua) loop      
        select operacion.sq_sgat_ipxclasec6.nextval
          into v_lan_ipc6n_id
          from dual;
      
        v_letra_a_insertar := sgasfun_lan_letra_sub_red_i(i,
                                                          k_mascara_ingresada_por_usua,
                                                          k_ipv6,
                                                          v_posicion_fija);
      
        v_ipv6_siguiente := rpad(concat(substr(k_ipv6, 1, v_posicion_fija),
                                        v_letra_a_insertar),
                                 32,
                                 '0');
      
        select substr(v_ipv6_siguiente, 1, 4),
               substr(v_ipv6_siguiente, 5, 4),
               substr(v_ipv6_siguiente, 9, 4),
               substr(v_ipv6_siguiente, 13, 4),
               substr(v_ipv6_siguiente, 17, 4),
               substr(v_ipv6_siguiente, 21, 4),
               substr(v_ipv6_siguiente, 25, 4),
               substr(v_ipv6_siguiente, 29, 4)
          into v_ipc6v_numero1_siguiente,
               v_ipc6v_numero2_siguiente,
               v_ipc6v_numero3_siguiente,
               v_ipc6v_numero4_siguiente,
               v_ipc6v_numero5_siguiente,
               v_ipc6v_numero6_siguiente,
               v_ipc6v_numero7_siguiente,
               v_ipc6v_numero8_siguiente
          from dual;
      
        insert into trafficview.sgat_ipxclasec6
          (ipc6n_id,
           ipc6n_id_padre,
           ipc6v_clasec,
           ipc6v_numero,
           ipc6n_prefijo,
           ipc6c_tipo,
           ipc6v_codusu,
           clc6v_fecusu,
           ipc6v_codusumod,
           ipc6v_fecusumod,
           ipc6n_codequipo,
           ipc6n_codprd,
           ipc6v_numero1,
           ipc6v_numero2,
           ipc6v_numero3,
           ipc6v_numero4,
           ipc6v_numero5,
           ipc6v_numero6,
           ipc6v_numero7,
           ipc6v_numero8,
           ipc6v_estado)
        values
          (v_lan_ipc6n_id,
           k_lan_ipc6n_id_padre,
           sgasfun_ponerdospuntos(v_ipv6_siguiente),
           '0000',
           v_mascara_siguiente,
           'L',
           user,
           sysdate,
           user,
           sysdate,
           k_codequipo,
           k_codprd,
           v_ipc6v_numero1_siguiente,
           v_ipc6v_numero2_siguiente,
           v_ipc6v_numero3_siguiente,
           v_ipc6v_numero4_siguiente,
           v_ipc6v_numero5_siguiente,
           v_ipc6v_numero6_siguiente,
           v_ipc6v_numero7_siguiente,
           v_ipc6v_numero8_siguiente,
           'L');
      
        if v_incremento_dec_sig_malla = 1 then
          sgasi_lan_genera16rangos(v_mascara_siguiente,
                                   v_ipv6_siguiente,
                                   v_lan_ipc6n_id,
                                   k_codequipo,
                                   k_codprd);
        end if;
      
        if v_incremento_dec_sig_malla > 1 then
          sgasi_l_gene_ran_menor_16_sig(v_mascara_siguiente,
                                        v_ipv6_siguiente,
                                        v_lan_ipc6n_id,
                                        k_codequipo,
                                        k_codprd,
                                        v_posicion_fija,
                                        v_incremento_dec_sig_malla);
        end if;      
      end loop;    
    end if;
  end;
  --------------------------------------------------------------------------------
  procedure sgasi_l_gene_ran_menor_16_sig(k_mascara                  number,
                                          k_ipv6                     varchar2,
                                          k_lan_ipc6n_id_padre       number,
                                          k_codequipo                number,
                                          k_codprd                   number,
                                          k_posicion_fija            number,
                                          k_incremento_dec_malla_ant number) is
    /*
    ****************************************************************
    * Nombre SP         : SGASI_L_GENE_RAN_MENOR_16_SIG
    * Propósito         : Genera Rango menor 16
    * Input             : k_mascara                  --> Mascara Ingresada
                          k_ipv6                     --> IPV6
                          k_lan_ipc6n_id_padre       --> Mascara padre
                          k_codequipo                --> Codigo Equipo
                          k_codprd                   --> Codigo Producto
                          k_posicion_fija            --> Posicion Fija
                          k_incremento_dec_malla_ant --> Incremento de Malla
    * Output            : 
    * Creado por        : 
    * Fec Creación      : 28/11/2017
    * Fec Actualización : N/A
    ****************************************************************
    */
    v_lan_ipc6n_id                number(10, 0);
    v_ipv6_siguiente              char(32);
    v_ipc6v_numero1_siguiente     varchar2(4);
    v_ipc6v_numero2_siguiente     varchar2(4);
    v_ipc6v_numero3_siguiente     varchar2(4);
    v_ipc6v_numero4_siguiente     varchar2(4);
    v_ipc6v_numero5_siguiente     varchar2(4);
    v_ipc6v_numero6_siguiente     varchar2(4);
    v_ipc6v_numero7_siguiente     varchar2(4);
    v_ipc6v_numero8_siguiente     varchar2(4);
    v_mascara_siguiente           number(3, 0);
    v_rango_maximo_lan            number;
    v_posicion_final_a_extraer_32 number(3, 0);
    v_cant_letras_a_extraer       number(3, 0);
    v_letras_extraidas            varchar2(16);
    v_valor_ini_dec_act           number;
    v_valor_sig_a_insertar_dec    number := 0;
    v_valor_sig_a_insertar_hex    varchar2(16);
    
  begin
    select codigon
      into v_rango_maximo_lan
      from operacion.opedd
     where abreviacion = trim('RANGO_LAN');
    
    if (k_mascara < v_rango_maximo_lan) then      
      v_mascara_siguiente := sgasfun_siguiente_multiplo_4(k_mascara);      
      v_posicion_final_a_extraer_32 := v_mascara_siguiente / 4;      
      v_cant_letras_a_extraer := v_posicion_final_a_extraer_32 -
                                 k_posicion_fija;      
      v_letras_extraidas := trim(substr(k_ipv6,
                                        k_posicion_fija + 1,
                                        v_cant_letras_a_extraer)); --+1 porque debe considerarse desde la 1° posicion variable
      v_valor_ini_dec_act := to_number(v_letras_extraidas,
                                       rpad('x', v_cant_letras_a_extraer, 'x')); --convierte V_LETRAS_EXTRAIDAS de hex a decimal
      
      for i in 1 .. 16 loop        
        v_valor_sig_a_insertar_dec := v_valor_ini_dec_act +
                                      (i - 1) * k_incremento_dec_malla_ant; --el incremento actual es lo mismo que el incremento anterior
        
        select to_char(v_valor_sig_a_insertar_dec, 'XXXXXXXXXXX')
          into v_valor_sig_a_insertar_hex
          from dual;
        
        v_valor_sig_a_insertar_hex := trim(v_valor_sig_a_insertar_hex);        
        v_valor_sig_a_insertar_hex := lpad(v_valor_sig_a_insertar_hex,
                                           v_cant_letras_a_extraer,
                                           '0');        
        v_ipv6_siguiente := rpad(concat(substr(k_ipv6, 1, k_posicion_fija),
                                        v_valor_sig_a_insertar_hex),
                                 32,
                                 '0');
        
        select substr(v_ipv6_siguiente, 1, 4),
               substr(v_ipv6_siguiente, 5, 4),
               substr(v_ipv6_siguiente, 9, 4),
               substr(v_ipv6_siguiente, 13, 4),
               substr(v_ipv6_siguiente, 17, 4),
               substr(v_ipv6_siguiente, 21, 4),
               substr(v_ipv6_siguiente, 25, 4),
               substr(v_ipv6_siguiente, 29, 4)
          into v_ipc6v_numero1_siguiente,
               v_ipc6v_numero2_siguiente,
               v_ipc6v_numero3_siguiente,
               v_ipc6v_numero4_siguiente,
               v_ipc6v_numero5_siguiente,
               v_ipc6v_numero6_siguiente,
               v_ipc6v_numero7_siguiente,
               v_ipc6v_numero8_siguiente
          from dual;
        
        select operacion.sq_sgat_ipxclasec6.nextval
          into v_lan_ipc6n_id
          from dual;
        
        insert into trafficview.sgat_ipxclasec6
          (ipc6n_id,
           ipc6n_id_padre,
           ipc6v_clasec,
           ipc6v_numero,
           ipc6n_prefijo,
           ipc6c_tipo,
           ipc6v_codusu,
           clc6v_fecusu,
           ipc6v_codusumod,
           ipc6v_fecusumod,
           ipc6n_codequipo,
           ipc6n_codprd,
           ipc6v_numero1,
           ipc6v_numero2,
           ipc6v_numero3,
           ipc6v_numero4,
           ipc6v_numero5,
           ipc6v_numero6,
           ipc6v_numero7,
           ipc6v_numero8,
           ipc6v_estado)
        values
          (v_lan_ipc6n_id,
           k_lan_ipc6n_id_padre,
           sgasfun_ponerdospuntos(v_ipv6_siguiente),
           '0000',
           v_mascara_siguiente,
           'L',
           user,
           sysdate,
           user,
           sysdate,
           k_codequipo,
           k_codprd,
           v_ipc6v_numero1_siguiente,
           v_ipc6v_numero2_siguiente,
           v_ipc6v_numero3_siguiente,
           v_ipc6v_numero4_siguiente,
           v_ipc6v_numero5_siguiente,
           v_ipc6v_numero6_siguiente,
           v_ipc6v_numero7_siguiente,
           v_ipc6v_numero8_siguiente,
           'L');
        
        sgasi_l_gene_ran_menor_16_sig(v_mascara_siguiente,
                                      v_ipv6_siguiente,
                                      v_lan_ipc6n_id,
                                      k_codequipo,
                                      k_codprd,
                                      k_posicion_fija,
                                      k_incremento_dec_malla_ant);
      end loop;
    end if;
  end;
  --------------------------------------------------------------------------------
  procedure sgasi_lan_genera16rangos(k_mascara            number,
                                     k_ipv6               varchar2,
                                     k_lan_ipc6n_id_padre number,
                                     k_codequipo          number,
                                     k_codprd             number) is
    /*
    ****************************************************************
    * Nombre SP         : SGASI_LAN_GENERA16RANGOS
    * Propósito         : Genera Rango 16
    * Input             : k_mascara                  --> Mascara Ingresada
                          k_ipv6                     --> IPV6
                          k_lan_ipc6n_id_padre       --> Mascara padre
                          k_codequipo                --> Codigo Equipo
                          k_codprd                   --> Codigo Producto
    * Output            : 
    * Creado por        : 
    * Fec Creación      : 28/11/2017
    * Fec Actualización : N/A
    ****************************************************************
    */
    n_lan_ipc6n_id            number(10, 0);
    l_posicion_fija_lan       number;
    v_ipv6_siguiente          char(32);
    v_ipc6v_numero1_siguiente varchar2(4);
    v_ipc6v_numero2_siguiente varchar2(4);
    v_ipc6v_numero3_siguiente varchar2(4);
    v_ipc6v_numero4_siguiente varchar2(4);
    v_ipc6v_numero5_siguiente varchar2(4);
    v_ipc6v_numero6_siguiente varchar2(4);
    v_ipc6v_numero7_siguiente varchar2(4);
    v_ipc6v_numero8_siguiente varchar2(4);
    n_mascara_siguiente       number(3, 0);
    v_rango_maximo_lan        number;
    
  begin    
    select codigon
      into v_rango_maximo_lan
      from operacion.opedd
     where abreviacion = trim('RANGO_LAN');
    
    if (k_mascara < v_rango_maximo_lan) then
      l_posicion_fija_lan := k_mascara / 4;
      n_mascara_siguiente := sgasfun_siguiente_multiplo_4(k_mascara);
      for i in 1 .. 16 loop
        select operacion.sq_sgat_ipxclasec6.nextval
          into n_lan_ipc6n_id
          from dual;
        case i
          when 1 then
            v_ipv6_siguiente := rpad(concat(substr(k_ipv6,1,l_posicion_fija_lan),'0'),32,'0');
          when 2 then
            v_ipv6_siguiente := rpad(concat(substr(k_ipv6,1,l_posicion_fija_lan),'1'),32,'0');
          when 3 then
            v_ipv6_siguiente := rpad(concat(substr(k_ipv6,1,l_posicion_fija_lan),'2'),32,'0');
          when 4 then
            v_ipv6_siguiente := rpad(concat(substr(k_ipv6,1,l_posicion_fija_lan),'3'),32,'0');
          when 5 then
            v_ipv6_siguiente := rpad(concat(substr(k_ipv6,1,l_posicion_fija_lan),'4'),32,'0');
          when 6 then
            v_ipv6_siguiente := rpad(concat(substr(k_ipv6,1,l_posicion_fija_lan),'5'),32,'0');
          when 7 then
            v_ipv6_siguiente := rpad(concat(substr(k_ipv6,1,l_posicion_fija_lan),'6'),32,'0');
          when 8 then
            v_ipv6_siguiente := rpad(concat(substr(k_ipv6,1,l_posicion_fija_lan),'7'),32,'0');          
          when 9 then
            v_ipv6_siguiente := rpad(concat(substr(k_ipv6,1,l_posicion_fija_lan),'8'),32,'0');
          when 10 then
            v_ipv6_siguiente := rpad(concat(substr(k_ipv6,1,l_posicion_fija_lan),'9'),32,'0');
          when 11 then
            v_ipv6_siguiente := rpad(concat(substr(k_ipv6,1,l_posicion_fija_lan),'A'),32,'0');
          when 12 then
            v_ipv6_siguiente := rpad(concat(substr(k_ipv6,1,l_posicion_fija_lan),'B'),32,'0');
          when 13 then
            v_ipv6_siguiente := rpad(concat(substr(k_ipv6,1,l_posicion_fija_lan),'C'),32,'0');
          when 14 then
            v_ipv6_siguiente := rpad(concat(substr(k_ipv6,1,l_posicion_fija_lan),'D'),32,'0');
          when 15 then
            v_ipv6_siguiente := rpad(concat(substr(k_ipv6,1,l_posicion_fija_lan),'E'),32,'0');
          when 16 then
            v_ipv6_siguiente := rpad(concat(substr(k_ipv6,1,l_posicion_fija_lan),'F'),32,'0');
        end case;
        
        select substr(v_ipv6_siguiente, 1, 4),
               substr(v_ipv6_siguiente, 5, 4),
               substr(v_ipv6_siguiente, 9, 4),
               substr(v_ipv6_siguiente, 13, 4),
               substr(v_ipv6_siguiente, 17, 4),
               substr(v_ipv6_siguiente, 21, 4),
               substr(v_ipv6_siguiente, 25, 4),
               substr(v_ipv6_siguiente, 29, 4)
          into v_ipc6v_numero1_siguiente,
               v_ipc6v_numero2_siguiente,
               v_ipc6v_numero3_siguiente,
               v_ipc6v_numero4_siguiente,
               v_ipc6v_numero5_siguiente,
               v_ipc6v_numero6_siguiente,
               v_ipc6v_numero7_siguiente,
               v_ipc6v_numero8_siguiente
          from dual;
        
        insert into trafficview.sgat_ipxclasec6
          (ipc6n_id,
           ipc6n_id_padre,
           ipc6v_clasec,
           ipc6v_numero,
           ipc6n_prefijo,
           ipc6c_tipo,
           ipc6v_codusu,
           clc6v_fecusu,
           ipc6v_codusumod,
           ipc6v_fecusumod,
           ipc6n_codequipo,
           ipc6n_codprd,
           ipc6v_numero1,
           ipc6v_numero2,
           ipc6v_numero3,
           ipc6v_numero4,
           ipc6v_numero5,
           ipc6v_numero6,
           ipc6v_numero7,
           ipc6v_numero8,
           ipc6v_estado)
        values
          (n_lan_ipc6n_id,
           k_lan_ipc6n_id_padre,
           sgasfun_ponerdospuntos(v_ipv6_siguiente),
           '0000',
           n_mascara_siguiente,
           'L',
           user,
           sysdate,
           user,
           sysdate,
           k_codequipo,
           k_codprd,
           v_ipc6v_numero1_siguiente,
           v_ipc6v_numero2_siguiente,
           v_ipc6v_numero3_siguiente,
           v_ipc6v_numero4_siguiente,
           v_ipc6v_numero5_siguiente,
           v_ipc6v_numero6_siguiente,
           v_ipc6v_numero7_siguiente,
           v_ipc6v_numero8_siguiente,
           'L');
        
        sgasi_lan_genera16rangos(n_mascara_siguiente,
                                 v_ipv6_siguiente,
                                 n_lan_ipc6n_id,
                                 k_codequipo,
                                 k_codprd);
      end loop;
    end if;
  end;
  --------------------------------------------------------------------------------
  procedure sgasi_wan_genera(k_mascara_ini_ingre_usu   number,
                             k_ipv6                    varchar2,
                             k_wan_ipc6n_id_padre      number,
                             k_codequipo               number,
                             k_codprd                  number,
                             k_mascara_final_ingre_usu in number) is
    /*
    ****************************************************************
    * Nombre SP         : SGASI_WAN_GENERA
    * Propósito         : Genera IP Wan
    * Input             : k_mascara_ini_ingre_usu    --> Mascara Inicial
                          k_ipv6                     --> IPV6
                          k_wan_ipc6n_id_padre       --> Mascara padre
                          k_codequipo                --> Codigo Equipo
                          k_codprd                   --> Codigo Producto
                          k_mascara_final_ingre_usu  --> Mascara Final
    * Output            : 
    * Creado por        : 
    * Fec Creación      : 28/11/2017
    * Fec Actualización : N/A
    ****************************************************************
    */
    v_wan_ipc6n_id               number(10, 0);
    v_posicion_fija_inicial_32   number(3, 0);
    v_num_letras_a_extraer_32    number(3, 0);
    v_letra_sustraida_hex        char(16);
    v_letra_binario              varchar2(16);
    v_posi_ini_semi_variable_32  number;
    v_posi_final_semi_variab_32  number;
    v_1era_posicion_fija_4_bit   number(3, 0);
    v_inicial_binario            char(16);
    v_inicial_decimal            number;
    v_final_decimal              number;
    v_rango_a_dividir_en_decimal number;
    v_cantidad_rangos            number;
    v_incremento_en_decimal      number(4, 0);
    v_letra_retornar_decimal     number := 0;
    v_ipv6_siguiente             varchar2(32);
    v_letra_retornar_hex         char(12);
    v_ipc6v_numero1_siguiente    varchar2(4);
    v_ipc6v_numero2_siguiente    varchar2(4);
    v_ipc6v_numero3_siguiente    varchar2(4);
    v_ipc6v_numero4_siguiente    varchar2(4);
    v_ipc6v_numero5_siguiente    varchar2(4);
    v_ipc6v_numero6_siguiente    varchar2(4);
    v_ipc6v_numero7_siguiente    varchar2(4);
    v_ipc6v_numero8_siguiente    varchar2(4);
    v_num_de_ips                 number;
    v_rango_ip_a_dividir_en_dec  number;
    v_incremento_ip_en_dec       number(4, 0);
    v_letra_retornar_dec_ip      number := 0;
    v_letra_retornar_hex_ip      char(12);
    v_ipv6_siguiente_ip          varchar2(32);
    v_wan_ipc6n_id_ip            number(10, 0);
    v_valor_ini_hex_ip           varchar2(32);
    v_valor_ini_dec_ip           number;
    v_parte_fija_inicial_4_bit   varchar2(16);
    v_mascara_ini_ingre_usu      number;
    v_rangos                     number;
  
  begin
    v_posicion_fija_inicial_32  := sgasfun_lan_posicion_fija32(k_mascara_ini_ingre_usu);
    v_posi_ini_semi_variable_32 := ceil((k_mascara_ini_ingre_usu + 1) / 4);
    v_posi_final_semi_variab_32 := ceil((k_mascara_final_ingre_usu - 1) / 4);
    v_num_letras_a_extraer_32   := v_posi_final_semi_variab_32 -
                                   v_posi_ini_semi_variable_32 + 1;

    if (k_mascara_ini_ingre_usu in (120, 121, 122, 123)) and
       (k_mascara_final_ingre_usu = 125) then
      v_num_letras_a_extraer_32 := 2;
    elsif (k_mascara_ini_ingre_usu = 124) and (k_mascara_final_ingre_usu = 125) then
      v_num_letras_a_extraer_32 := 1;  
    end if;
        
    v_letra_sustraida_hex      := substr(k_ipv6,
                                         v_posi_ini_semi_variable_32,
                                         v_num_letras_a_extraer_32);
    v_letra_binario            := null;
    v_parte_fija_inicial_4_bit := null;
  
    for i in 1 .. v_num_letras_a_extraer_32 loop
      case trim(substr(v_letra_sustraida_hex, i, 1))
        when '0' then
          v_letra_binario := trim(v_letra_binario || '0000');
        when '1' then
          v_letra_binario := trim(v_letra_binario || '0001');
        when '2' then
          v_letra_binario := trim(v_letra_binario || '0010');
        when '3' then
          v_letra_binario := trim(v_letra_binario || '0011');
        when '4' then
          v_letra_binario := trim(v_letra_binario || '0100');
        when '5' then
          v_letra_binario := trim(v_letra_binario || '0101');
        when '6' then
          v_letra_binario := trim(v_letra_binario || '0110');
        when '7' then
          v_letra_binario := trim(v_letra_binario || '0111');
        when '8' then
          v_letra_binario := trim(v_letra_binario || '1000');
        when '9' then
          v_letra_binario := trim(v_letra_binario || '1001');
        when 'A' then
          v_letra_binario := trim(v_letra_binario || '1010');
        when 'B' then
          v_letra_binario := trim(v_letra_binario || '1011');
        when 'C' then
          v_letra_binario := trim(v_letra_binario || '1100');
        when 'D' then
          v_letra_binario := trim(v_letra_binario || '1101');
        when 'E' then
          v_letra_binario := trim(v_letra_binario || '1110');
        when 'F' then
          v_letra_binario := trim(v_letra_binario || '1111');
      end case;
    end loop;
  
    v_1era_posicion_fija_4_bit := mod(k_mascara_ini_ingre_usu, 4);
  
    if v_1era_posicion_fija_4_bit >= 1 then
      v_parte_fija_inicial_4_bit := substr(v_letra_binario,
                                           1,
                                           v_1era_posicion_fija_4_bit);
    
      v_inicial_binario := rpad(v_parte_fija_inicial_4_bit,
                                (4 * v_num_letras_a_extraer_32),
                                '0');
    end if;
  
    if v_1era_posicion_fija_4_bit = 0 then
      v_inicial_binario := rpad('0', (4 * v_num_letras_a_extraer_32), '0');
    end if;
  
    v_inicial_decimal            := sgasfun_binario_a_decimal(v_inicial_binario);
    v_final_decimal              := power(16, v_num_letras_a_extraer_32);
    v_rango_a_dividir_en_decimal := v_final_decimal - v_inicial_decimal;
  
    -- cantidad de rangos a subnetear    
    v_cantidad_rangos := power(2,
                               (k_mascara_final_ingre_usu -
                               k_mascara_ini_ingre_usu));

    if k_mascara_final_ingre_usu = 126 then
      v_incremento_en_decimal := 4;
    elsif k_mascara_ini_ingre_usu > 120 and (k_mascara_final_ingre_usu < 125) then
      v_mascara_ini_ingre_usu := 120;
      v_rangos                := power(2,
                                       (k_mascara_final_ingre_usu -
                                       v_mascara_ini_ingre_usu));
      v_incremento_en_decimal := 16 / v_rangos;
    elsif k_mascara_ini_ingre_usu > 120 and k_mascara_final_ingre_usu = 125 then
      v_incremento_en_decimal := 256 / 32;
    else
      v_incremento_en_decimal := v_rango_a_dividir_en_decimal /
                                 v_cantidad_rangos;
    end if;
  
    for i in 1 .. v_cantidad_rangos loop
      select operacion.sq_sgat_ipxclasec6.nextval
        into v_wan_ipc6n_id
        from dual;
    
      v_letra_retornar_decimal := v_inicial_decimal +
                                  ((i - 1) * v_incremento_en_decimal);    
      v_letra_retornar_hex := trim(to_char(v_letra_retornar_decimal, 'XXXX'));    
      v_letra_retornar_hex := lpad(trim(v_letra_retornar_hex),
                                   v_num_letras_a_extraer_32,
                                   '0'); --completa con ceros a la izquierda de ser necesario
    
      select trim(rpad(trim(concat(substr(k_ipv6, 1, v_posicion_fija_inicial_32),
                                   v_letra_retornar_hex)),
                       32,
                       '0'))
        into v_ipv6_siguiente
        from dual;
    
      select substr(v_ipv6_siguiente, 1, 4),
             substr(v_ipv6_siguiente, 5, 4),
             substr(v_ipv6_siguiente, 9, 4),
             substr(v_ipv6_siguiente, 13, 4),
             substr(v_ipv6_siguiente, 17, 4),
             substr(v_ipv6_siguiente, 21, 4),
             substr(v_ipv6_siguiente, 25, 4),
             substr(v_ipv6_siguiente, 29, 4)
        into v_ipc6v_numero1_siguiente,
             v_ipc6v_numero2_siguiente,
             v_ipc6v_numero3_siguiente,
             v_ipc6v_numero4_siguiente,
             v_ipc6v_numero5_siguiente,
             v_ipc6v_numero6_siguiente,
             v_ipc6v_numero7_siguiente,
             v_ipc6v_numero8_siguiente
        from dual;
    
      insert into trafficview.sgat_ipxclasec6
        (ipc6n_id,
         ipc6n_id_padre,
         ipc6v_clasec,
         ipc6v_numero,
         ipc6n_prefijo,
         ipc6c_tipo,
         ipc6v_codusu,
         clc6v_fecusu,
         ipc6v_codusumod,
         ipc6v_fecusumod,
         ipc6n_codequipo,
         ipc6n_codprd,
         ipc6v_numero1,
         ipc6v_numero2,
         ipc6v_numero3,
         ipc6v_numero4,
         ipc6v_numero5,
         ipc6v_numero6,
         ipc6v_numero7,
         ipc6v_numero8,
         ipc6v_estado)
      values
        (v_wan_ipc6n_id,
         k_wan_ipc6n_id_padre,
         sgasfun_ponerdospuntos(v_ipv6_siguiente),
         v_ipc6v_numero8_siguiente,
         k_mascara_final_ingre_usu,
         'W',
         user,
         sysdate,
         user,
         sysdate,
         k_codequipo,
         k_codprd,
         v_ipc6v_numero1_siguiente,
         v_ipc6v_numero2_siguiente,
         v_ipc6v_numero3_siguiente,
         v_ipc6v_numero4_siguiente,
         v_ipc6v_numero5_siguiente,
         v_ipc6v_numero6_siguiente,
         v_ipc6v_numero7_siguiente,
         v_ipc6v_numero8_siguiente,
         'L');
    
      --inicio: genera ip segundo datawindows
      v_num_de_ips                := power(2, (128 - k_mascara_final_ingre_usu));
      v_rango_ip_a_dividir_en_dec := v_incremento_en_decimal *
                                     power(16,
                                           (32 - v_posi_final_semi_variab_32));
      v_incremento_ip_en_dec      := v_rango_ip_a_dividir_en_dec / v_num_de_ips;
    
      if (k_mascara_ini_ingre_usu in (120, 121, 122, 123, 124)) and
         (k_mascara_final_ingre_usu = 125) then
        --caso especial
        v_incremento_ip_en_dec := v_incremento_en_decimal / v_num_de_ips;
      end if;
    
      v_valor_ini_hex_ip := substr(v_ipv6_siguiente,
                                   v_posi_ini_semi_variable_32,
                                   (32 - v_posicion_fija_inicial_32));    
      v_valor_ini_dec_ip := to_number(v_valor_ini_hex_ip,
                                      rpad('x', length(v_valor_ini_hex_ip), 'x'));
    
      for j in 1 .. v_num_de_ips loop
        v_letra_retornar_dec_ip := v_valor_ini_dec_ip +
                                   ((j - 1) * v_incremento_ip_en_dec);
        v_letra_retornar_hex_ip := trim(to_char(v_letra_retornar_dec_ip, 'XXXX')); --Convertir de decimal a hexadecimal, probado cuando sea FFFF
        v_letra_retornar_hex_ip := lpad(trim(v_letra_retornar_hex_ip),
                                        (32 - v_posicion_fija_inicial_32),
                                        '0'); --completa con ceros a la izquierda de ser necesario
      
        select trim(concat(substr(k_ipv6, 1, v_posicion_fija_inicial_32),
                           v_letra_retornar_hex_ip))
          into v_ipv6_siguiente_ip
          from dual;
      
        select substr(v_ipv6_siguiente_ip, 1, 4),
               substr(v_ipv6_siguiente_ip, 5, 4),
               substr(v_ipv6_siguiente_ip, 9, 4),
               substr(v_ipv6_siguiente_ip, 13, 4),
               substr(v_ipv6_siguiente_ip, 17, 4),
               substr(v_ipv6_siguiente_ip, 21, 4),
               substr(v_ipv6_siguiente_ip, 25, 4),
               substr(v_ipv6_siguiente_ip, 29, 4)
          into v_ipc6v_numero1_siguiente,
               v_ipc6v_numero2_siguiente,
               v_ipc6v_numero3_siguiente,
               v_ipc6v_numero4_siguiente,
               v_ipc6v_numero5_siguiente,
               v_ipc6v_numero6_siguiente,
               v_ipc6v_numero7_siguiente,
               v_ipc6v_numero8_siguiente
          from dual;
      
        select operacion.sq_sgat_ipxclasec6.nextval
          into v_wan_ipc6n_id_ip
          from dual;
      
        insert into trafficview.sgat_ipxclasec6
          (ipc6n_id,
           ipc6n_id_padre,
           ipc6v_clasec,
           ipc6v_numero,
           ipc6n_prefijo,
           ipc6c_tipo,
           ipc6v_codusu,
           clc6v_fecusu,
           ipc6v_codusumod,
           ipc6v_fecusumod,
           ipc6n_codequipo,
           ipc6n_codprd,
           ipc6v_numero1,
           ipc6v_numero2,
           ipc6v_numero3,
           ipc6v_numero4,
           ipc6v_numero5,
           ipc6v_numero6,
           ipc6v_numero7,
           ipc6v_numero8,
           ipc6v_estado)
        values
          (v_wan_ipc6n_id_ip,
           v_wan_ipc6n_id,
           sgasfun_ponerdospuntos(v_ipv6_siguiente_ip),
           v_ipc6v_numero8_siguiente,
           k_mascara_final_ingre_usu,
           'W',
           user,
           sysdate,
           user,
           sysdate,
           k_codequipo,
           k_codprd,
           v_ipc6v_numero1_siguiente,
           v_ipc6v_numero2_siguiente,
           v_ipc6v_numero3_siguiente,
           v_ipc6v_numero4_siguiente,
           v_ipc6v_numero5_siguiente,
           v_ipc6v_numero6_siguiente,
           v_ipc6v_numero7_siguiente,
           v_ipc6v_numero8_siguiente,
           'L');
      end loop;
    end loop;
  end;
  --------------------------------------------------------------------------------
  procedure sgass_evaluar_generarip6(k_tipored varchar,
                                     k_mask    number,
                                     k_maskfin number,
                                     k_ipred   varchar,
                                     o_cursor  out sys_refcursor) is
    /*
    ****************************************************************
    * Nombre SP         : SGASS_EVALUAR_GENERARIP6
    * Propósito         : Evaluar generacion de IPV6
    * Input             : k_tipored --> Tipo Red
                          k_mask    --> Mascara
                          k_maskfin --> Mascara Fin
                          k_ipred   --> Ip
    * Output            : o_cursor  --> Cursor
    * Creado por        : 
    * Fec Creación      : 28/11/2017
    * Fec Actualización : N/A
    ****************************************************************
    */
    c_cmask      number(2);
    c_cregistros number(2);
    c_mask       number(10);
    c_mask1      number(10);
    c_mask2      number(10);
    v_nvipred    varchar(40);
    /*variables wan*/
    c_maskmin_w  number(10);
    c_maskmini_w number(10);
    c_maskmfin_w number(10);
    /*variables loopback*/
    c_maskmin_lo number(10);
    c_maskmax_lo number(10);
  
  begin
    v_nvipred := sgasfun_ponerdospuntos(k_ipred);
  
    if k_tipored = 'L' then
      --tipo de red lan
      /*obtenemos el valor de la maxima mascara de la tabla de parametros*/
      select count(*), codigon
        into c_cmask, c_mask
        from operacion.opedd
       where abreviacion = 'RANGO_LAN'
       group by c_mask, codigon;
    
      /*Verificamos si el ip y la mascara ya se encuentran registrados*/
      select count(*)
        into c_cregistros
        from trafficview.sgat_clasec6 tsc
       right join trafficview.sgat_ipxclasec6 tsi
          on tsi.ipc6v_clasec = tsc.clc6v_clasec
       where tsi.ipc6v_clasec = v_nvipred
         and tsi.ipc6c_tipo = k_tipored;
    
      if c_cregistros = 0 then
        if c_cmask > 0 then
          c_mask1 := c_mask - 4;
          c_mask2 := c_mask1 - 8;      
          if k_mask >= c_mask1 or k_mask <= 36 then
            open o_cursor for
              select -1 from sys.dual;
            return;
          end if;
        
          if k_mask <> c_mask1 and k_mask <> c_mask2 then
            open o_cursor for
              select 1 from sys.dual;
            return;
          end if;
        
          if k_mask = c_mask1 or k_mask = c_mask2 then
            open o_cursor for
              select 0 from sys.dual;
            return;
          end if;
        end if;
      else
        open o_cursor for
          select -2 from sys.dual;
        return;
      end if;
    
    elsif k_tipored = 'W' then
      --tipo de red wan
      /*obtenemos el valor minimo y maximo mascara de la tabla de parametros - wan*/
      select codigon
        into c_maskmin_w
        from operacion.opedd
       where ABREVIACION = 'RANGO_WAN';
    
      select codigon
        into c_maskmini_w
        from operacion.opedd
       where abreviacion = 'RANGOMAX_WAN';
    
      select codigon
        into c_maskmfin_w
        from operacion.opedd
       where abreviacion = 'RANGO_MAXWAN';
    
      /*Verificamos si el ip y la mascara ya se encuentran registrados*/
      select count(*)
        into c_cregistros
        from trafficview.sgat_clasec6 tsc
       right join trafficview.sgat_ipxclasec6 tsi
          on tsi.ipc6v_clasec = tsc.clc6v_clasec
       where tsi.ipc6v_clasec = v_nvipred
         and tsi.ipc6c_tipo = k_tipored;
    
      if c_cregistros = 0 then
        if k_mask < c_maskmin_w then
          open o_cursor for
            select -1 from sys.dual;
          return;
        elsif k_maskfin < c_maskmini_w or k_maskfin > c_maskmfin_w then
          open o_cursor for
            select -2 from sys.dual;
          return;
        elsif k_mask > k_maskfin then
          open o_cursor for
            select -3 from sys.dual;
          return;
        else
          open o_cursor for
            select 0 from sys.dual;
          return;
        end if;
      else
        open o_cursor for
          select -4 from sys.dual;
        return;
      end if;
    
    elsif k_tipored = 'LO' then
      --tipo de red loopback
      select min(codigon)
        into c_maskmin_lo
        from operacion.opedd
       where abreviacion = 'RANGO_LOOP';
    
      select max(codigon)
        into c_maskmax_lo
        from operacion.opedd
       where abreviacion = 'RANGO_LOOP';
    
      /*Verificamos si el ip y la mascara ya se encuentran registrados*/
      select count(*)
        into c_cregistros
        from trafficview.sgat_clasec6 tsc
       right join trafficview.sgat_ipxclasec6 tsi
          on tsi.ipc6v_clasec = tsc.clc6v_clasec
       where tsi.ipc6v_clasec = v_nvipred
         and tsi.ipc6c_tipo = k_tipored;
    
      if c_cregistros = 0 then
        if k_mask < c_maskmin_lo or k_mask > c_maskmax_lo then
          open o_cursor for
            select -1 from sys.dual;
          return;
        else
          open o_cursor for
            select 0 from sys.dual;
          return;
        end if;
      else
        open o_cursor for
          select -2 from sys.dual;
        return;
      end if;
    end if;
  end sgass_evaluar_generarip6;
  --------------------------------------------------------------------------------
  procedure sgass_lst_ip_mascara(k_ipred  varchar,
                                 k_equipo number,
                                 k_tipred varchar,
                                 o_cursor out sys_refcursor) is
    /*
    ****************************************************************
    * Nombre SP         : SGASS_LST_IP_MASCARA
    * Propósito         : Lista IP Mascara
    * Input             : k_ipred  --> IP
                          k_equipo --> Equipo
                          k_tipred --> Tipo Red
    * Output            : o_cursor --> Cursor
    * Creado por        : 
    * Fec Creación      : 28/11/2017
    * Fec Actualización : N/A
    ****************************************************************
    */
    v_nvipred varchar(40);
    
  begin
    if upper(k_tipred) in ('L', 'W', 'LO') then
      --RED LAN - WAN    
      if k_ipred = '0' then
        open o_cursor for
          select tip.ipc6n_id,
                 tsc.clc6v_clasec,
                 tsc.clc6n_prefijo,
                 tsc.clc6n_codprd,
                 tsc.clc6n_codequipo,
                 case tsc.clc6n_estado
                   when 0 then
                    'LIBRE'
                   when 1 then
                    'PARCIAL'
                   when 2 then
                    'TOTAL'
                 end ESTADO
            from trafficview.sgat_clasec6 tsc
            join trafficview.sgat_ipxclasec6 tip
              on tsc.clc6v_clasec = tip.ipc6v_clasec
           where tip.ipc6n_id = tip.ipc6n_id_padre
             and tip.ipc6c_tipo = k_tipred;
      else
        v_nvipred := sgasfun_buscadenapuntos(k_ipred);
        if k_ipred is not null and K_EQUIPO is not null then
          --Busqueda Por IPRED y Equipo
          open O_CURSOR for
            select distinct tip.IPC6N_ID,
                            tsc.CLC6V_CLASEC,
                            tsc.CLC6N_PREFIJO,
                            tsc.CLC6N_CODPRD,
                            tsc.CLC6N_CODEQUIPO,
                            (case tsc.CLC6N_ESTADO
                              when 0 then
                               'LIBRE'
                              when 1 then
                               'PARCIAL'
                              when 2 then
                               'TOTAL'
                            end) ESTADO
              from trafficview.sgat_clasec6 tsc
              join trafficview.sgat_ipxclasec6 tip
                on tsc.clc6v_clasec = tip.ipc6v_clasec
             where tip.ipc6n_id = tip.ipc6n_id_padre
               and tip.ipc6c_tipo = k_tipred
               and tsc.clc6v_clasec like v_nvipred
               and tsc.clc6n_codequipo = k_equipo;
        
        elsif k_ipred is null and k_equipo is not null then
          --Busqueda Por Equipo
          open o_cursor for
            select tip.ipc6n_id,
                   tsc.clc6v_clasec,
                   tsc.clc6n_prefijo,
                   tsc.clc6n_codprd,
                   tsc.clc6n_codequipo,
                   case tsc.clc6n_estado
                     when 0 then
                      'LIBRE'
                     when 1 then
                      'PARCIAL'
                     when 2 then
                      'TOTAL'
                   end estado
              from trafficview.sgat_clasec6 tsc
              join trafficview.sgat_ipxclasec6 tip
                on tsc.clc6v_clasec = tip.ipc6v_clasec
             where tip.ipc6n_id = tip.ipc6n_id_padre
               and tip.ipc6c_tipo = k_tipred
               and tsc.clc6n_codequipo = k_equipo;
        
        elsif k_ipred is not null and k_equipo is null then
          --Busqueda por IPRED
          open o_cursor for
            select tip.ipc6n_id,
                   tsc.clc6v_clasec,
                   tsc.clc6n_prefijo,
                   tsc.clc6n_codprd,
                   tsc.clc6n_codequipo,
                   case tsc.clc6n_estado
                     when 0 then
                      'LIBRE'
                     when 1 then
                      'PARCIAL'
                     when 2 then
                      'TOTAL'
                   end estado
              from trafficview.sgat_clasec6 tsc
              join trafficview.sgat_ipxclasec6 tip
                on tsc.clc6v_clasec = tip.ipc6v_clasec
             where tip.ipc6n_id = tip.ipc6n_id_padre
               and tip.ipc6c_tipo = k_tipred
               and tsc.clc6v_clasec like v_nvipred;
        end if;
      end if;
    end if;  
  end;
  --------------------------------------------------------------------------------
  procedure sgass_lst_mascaras(k_idpadre number, o_cursor out sys_refcursor) is
    /*
    ****************************************************************
    * Nombre SP         : SGASS_LST_MASCARAS
    * Propósito         : Lista Mascara
    * Input             : k_idpadre --> Id Padre
    * Output            : o_cursor  --> Cursor
    * Creado por        : 
    * Fec Creación      : 28/11/2017
    * Fec Actualización : N/A
    ****************************************************************
    */
    c_rangomax number;
    v_num      number;
  
  begin
    select codigon
      into c_rangomax
      from operacion.opedd
     where abreviacion = 'RANGO_LAN';
  
    c_rangomax := c_rangomax - 4;
  
    select count(1)
      into v_num
      from trafficview.sgat_ipxclasec6
     where ipc6n_prefijo = c_rangomax
       and ipc6n_id_padre = k_idpadre
       and ipc6n_id <> ipc6n_id_padre
       and ipc6c_tipo = 'L';
  
    if v_num > 0 then
      open o_cursor for
        select sgi.ipc6n_id,
               sgi.ipc6v_clasec,
               (case sgi.ipc6v_estado
                 when 'L' then
                  'LIBRE'
                 when 'P' then
                  'PARCIAL'
                 when 'T' then
                  'TOTAL'
                 when 'A' then
                  'ASIGNADO'
                 when 'S' then
                  'STAND BY'
                 when 'R' then
                  'RESERVADO'
               end) estado,
               sgi.ipc6n_prefijo,
               (select rip.rango
                  from trafficview.sgat_ipxclasec6 sg2
                  left join trafficview.rangosip rip
                    on rip.idrango = sg2.ipc6n_idrango
                 where sg2.ipc6n_id_padre = sgi.ipc6n_id
                   and sg2.ipc6v_estado = 'A'
                   and rownum = 1) as cliente,
               (case sgi.ipc6v_estado
                 when 'A' then
                  rip.raipv_vlan
                 else
                  ''
               end) as raipv_vlan,
               sgi.ipc6c_tipo
          from trafficview.sgat_ipxclasec6 sgi
          left join trafficview.sgat_clasec6 sgc
            on sgc.clc6v_clasec = sgi.ipc6v_clasec
          left join trafficview.rangosip rip
            on rip.idrango = sgi.ipc6n_idrango
         where sgi.ipc6n_id <> sgi.ipc6n_id_padre
           and sgi.ipc6n_id_padre = k_idpadre
         order by sgi.ipc6v_clasec asc;
    else
      open o_cursor for
        select sgi.ipc6n_id,
               sgi.ipc6v_clasec,
               (case sgi.ipc6v_estado
                 when 'L' then
                  'LIBRE'
                 when 'P' then
                  'PARCIAL'
                 when 'T' then
                  'TOTAL'
                 when 'A' then
                  'ASIGNADO'
                 when 'S' then
                  'STAND BY'
                 when 'R' then
                  'RESERVADO'
               end) estado,
               sgi.ipc6n_prefijo,
               rip.rango as cliente,
               (case sgi.ipc6v_estado
                 when 'A' then
                  rip.raipv_vlan
                 else
                  ''
               end) as raipv_vlan,
               sgi.ipc6c_tipo
          from trafficview.sgat_ipxclasec6 sgi
          left join trafficview.sgat_clasec6 sgc
            on sgc.clc6v_clasec = sgi.ipc6v_clasec
          left join trafficview.rangosip rip
            on rip.idrango = sgi.ipc6n_idrango
         where sgi.ipc6n_id <> sgi.ipc6n_id_padre
           and sgi.ipc6n_id_padre = k_idpadre
         order by sgi.ipc6v_clasec asc;
    end if;
  end;
  --------------------------------------------------------------------------------
  procedure sgass_listar_tipo_red_ln(k_mask   number,
                                     k_ipred  varchar2,
                                     o_cursor out sys_refcursor) is
    /*
    ****************************************************************
    * Nombre SP         : SGASS_LISTAR_TIPO_RED_LN
    * Propósito         : Lista Tipo de Red Lan
    * Input             : k_mask    --> Mascara
                          k_ipred   --> Ip Red
    * Output            : o_cursor  --> Cursor
    * Creado por        : 
    * Fec Creación      : 28/11/2017
    * Fec Actualización : N/A
    ****************************************************************
    */
    v_ipred_null     varchar2(50) := '';
    v_estado_null    char(1) := '';
    v_mask_null      number(3) := 0;
    c_idpadre        number(10);
    c_prefijo        number(3);
    c_clasec         varchar2(50);
    c_estado         char(1);
    c_equipo         varchar2(100);
    c_producto       varchar2(100);
    v_existe         pls_integer;
    v_ipred          varchar2(50);
    v_ipred_padre    varchar2(50);
    v_ipc6n_id       number(10);
    v_ipc6n_id_padre number(10);
    v_idpadre        number(10);

  begin
    v_ipred := k_ipred;

    select ipc6n_id_padre, ipc6n_prefijo, ipc6v_clasec, ipc6v_estado
      into c_idpadre, c_prefijo, c_clasec, c_estado
      from trafficview.sgat_ipxclasec6
     where ipc6v_clasec = v_ipred
       and ipc6n_prefijo = k_mask;

    v_idpadre := c_idpadre;

    loop
      select ipc6n_id, ipc6n_id_padre, ipc6v_clasec
        into v_ipc6n_id, v_ipc6n_id_padre, v_ipred_padre
        from trafficview.sgat_ipxclasec6 t
       where t.ipc6n_id = v_idpadre;
    
      v_idpadre     := v_ipc6n_id_padre;
      v_ipred_padre := v_ipred_padre;
    
      exit when v_ipc6n_id = v_ipc6n_id_padre;
    end loop;

    select count(1)
      into v_existe
      from trafficview.sgat_clasec6 c
     where c.CLC6V_CLASEC = v_ipred;

    if v_existe = 0 then
      c_idpadre := null;
    end if;

    select equ.descripcion, pro.descripcion
      into c_equipo, c_producto
      from trafficview.sgat_clasec6 cls
      left join metasolv.equipored equ
        on cls.clc6n_codequipo = equ.codequipo
      left join metasolv.productocorp pro
        on cls.clc6n_codprd = pro.codprd
     where clc6v_clasec = v_ipred_padre
    ;

    /*Armando el 01 Cursor*/
    declare
      cursor cursor_01 is
        select ipc6n_id, ipc6n_prefijo, ipc6v_clasec, ipc6v_estado
          from trafficview.sgat_ipxclasec6
         where ipc6n_id_padre = c_idpadre
           and ipc6n_id_padre <> ipc6n_id
        union
        select ipc6n_id, ipc6n_prefijo, ipc6v_clasec, ipc6v_estado
          from trafficview.sgat_ipxclasec6
         where ipc6v_clasec = v_ipred
           and ipc6n_prefijo = k_mask
           and ipc6n_id_padre <> ipc6n_id;
    
      /*Variables de Cursor 01 - Mascara 40*/
      c_idpadre_c1 number(10);
      c_mask_c1    number(3);
      c_ipred_c1   varchar2(50);
      c_estado_c1  char(1);
    
    begin
      open cursor_01;
      loop
        fetch cursor_01
          into c_idpadre_c1, c_mask_c1, c_ipred_c1, c_estado_c1;
        exit when cursor_01%notfound;
        /*ARMANDO EL 02 CURSOR - Mascara 44*/
        declare
          cursor cursor_02 is
            select sgi.ipc6n_id,
                   sgi.ipc6n_prefijo,
                   sgi.ipc6v_clasec,
                   sgi.ipc6v_estado,
                   rip.rango
              from trafficview.sgat_ipxclasec6 sgi
              left join trafficview.rangosip rip
                on rip.idrango = sgi.ipc6n_idrango
             where sgi.ipc6n_id_padre = c_idpadre_c1
               and sgi.ipc6n_id_padre <> sgi.ipc6n_id;
          /*Variables de Cursor 02*/
          c_idpadre_c2 number(10);
          c_mask_c2    number(3);
          c_ipred_c2   varchar2(50);
          c_estado_c2  char(1);
          c_cliente_c2 varchar(30);
        begin
          open cursor_02;
          loop
            fetch cursor_02
              into c_idpadre_c2, c_mask_c2, c_ipred_c2, c_estado_c2, c_cliente_c2;
            exit when cursor_02%notfound;
          
            if c_mask_c2 = 56 then
              /*Realizamos el Insert a la Tabla Temporal*/
              insert into trafficview.tempexporexcel_ln
                (t_mask_pri,
                 t_ipred_pri,
                 t_estado_pri,
                 t_equipo_pri,
                 t_produc_pri,
                 t_ip40,
                 t_est_ip40,
                 t_ip_m40,
                 t_ip44,
                 t_est_ip44,
                 t_ip_m44,
                 t_ip48,
                 t_est_ip48,
                 t_ip_m48,
                 t_ip52,
                 t_est_ip52,
                 t_ip_m52,
                 t_ip_cli52,
                 t_ip56,
                 t_est_ip56,
                 t_ip_m56)
              values
                (c_prefijo,
                 c_clasec,
                 c_estado,
                 c_equipo,
                 c_producto,
                 v_ipred_null,
                 v_estado_null,
                 v_mask_null,
                 v_ipred_null,
                 v_estado_null,
                 v_mask_null,
                 v_ipred_null,
                 v_estado_null,
                 v_mask_null,
                 c_ipred_c1,
                 c_estado_c1,
                 c_mask_c1,
                 c_cliente_c2,
                 c_ipred_c2,
                 c_estado_c2,
                 c_mask_c2);
            end if;
          
            /*ARMANDO EL 03 CURSOR - Mascara 48*/
            declare
              cursor cursor_03 is
                select sgi.ipc6n_id,
                       sgi.ipc6n_prefijo,
                       sgi.ipc6v_clasec,
                       sgi.ipc6v_estado,
                       rip.rango
                  from trafficview.sgat_ipxclasec6 sgi
                  left join trafficview.rangosip rip
                    on rip.idrango = sgi.ipc6n_idrango
                 where sgi.ipc6n_id_padre = c_idpadre_c2
                   and sgi.ipc6n_id_padre <> sgi.ipc6n_id;
              /*Variables de Cursor 03*/
              c_idpadre_c3 number(10);
              c_mask_c3    number(3);
              c_ipred_c3   varchar2(50);
              c_estado_c3  char(1);
              c_cliente_c3 varchar2(30);
            begin
              open cursor_03;
              loop
                fetch cursor_03
                  into c_idpadre_c3,
                       c_mask_c3,
                       c_ipred_c3,
                       c_estado_c3,
                       c_cliente_c3;
                exit when cursor_03%notfound;
              
                if c_mask_c3 = 56 then
                  /*Realizamos el Insert a la Tabla Temporal*/
                  insert into trafficview.tempexporexcel_ln
                    (t_mask_pri,
                     t_ipred_pri,
                     t_estado_pri,
                     t_equipo_pri,
                     t_produc_pri,
                     t_ip40,
                     t_est_ip40,
                     t_ip_m40,
                     t_ip44,
                     t_est_ip44,
                     t_ip_m44,
                     t_ip48,
                     t_est_ip48,
                     t_ip_m48,
                     t_ip52,
                     t_est_ip52,
                     t_ip_m52,
                     t_ip_cli52,
                     t_ip56,
                     t_est_ip56,
                     t_ip_m56)
                  values
                    (c_prefijo,
                     c_clasec,
                     c_estado,
                     c_equipo,
                     c_producto,
                     v_ipred_null,
                     v_estado_null,
                     v_mask_null,
                     v_ipred_null,
                     v_estado_null,
                     v_mask_null,
                     c_ipred_c1,
                     c_estado_c1,
                     c_mask_c1,
                     c_ipred_c2,
                     c_estado_c2,
                     c_mask_c2,
                     c_cliente_c3,
                     c_ipred_c3,
                     c_estado_c3,
                     c_mask_c3);
                end if;
              
                /*ARMANDO EL 04 CURSOR - Mascara 52*/
                declare
                  cursor cursor_04 is
                    select sgi.ipc6n_id,
                           sgi.ipc6n_prefijo,
                           sgi.ipc6v_clasec,
                           sgi.ipc6v_estado,
                           rip.rango
                      from trafficview.sgat_ipxclasec6 sgi
                      left join trafficview.rangosip rip
                        on rip.idrango = sgi.ipc6n_idrango
                     where sgi.ipc6n_id_padre = c_idpadre_c3
                       and sgi.ipc6n_id_padre <> sgi.ipc6n_id;
                  /*Variables de Cursor 04*/
                  c_idpadre_c4 number(10);
                  c_mask_c4    number(3);
                  c_ipred_c4   varchar2(50);
                  c_estado_c4  char(1);
                  c_cliente_c4 varchar2(30);
                begin
                  open cursor_04;
                  loop
                    fetch cursor_04
                      into c_idpadre_c4,
                           c_mask_c4,
                           c_ipred_c4,
                           c_estado_c4,
                           c_cliente_c4;
                    exit when cursor_04%notfound;
                  
                    if c_mask_c4 = 56 then
                      /*Realizamos el Insert a la Tabla Temporal*/
                      insert into trafficview.tempexporexcel_ln
                        (t_mask_pri,
                         t_ipred_pri,
                         t_estado_pri,
                         t_equipo_pri,
                         t_produc_pri,
                         t_ip40,
                         t_est_ip40,
                         t_ip_m40,
                         t_ip44,
                         t_est_ip44,
                         t_ip_m44,
                         t_ip48,
                         t_est_ip48,
                         t_ip_m48,
                         t_ip52,
                         t_est_ip52,
                         t_ip_m52,
                         t_ip_cli52,
                         t_ip56,
                         t_est_ip56,
                         t_ip_m56)
                      values
                        (c_prefijo,
                         c_clasec,
                         c_estado,
                         c_equipo,
                         c_producto,
                         v_ipred_null,
                         v_estado_null,
                         v_mask_null,
                         c_ipred_c1,
                         c_estado_c1,
                         c_mask_c1,
                         c_ipred_c2,
                         c_estado_c2,
                         c_mask_c2,
                         c_ipred_c3,
                         c_estado_c3,
                         c_mask_c3,
                         c_cliente_c4,
                         c_ipred_c4,
                         c_estado_c4,
                         c_mask_c4);
                    end if;
                    /*Armando el 05 Cursor - Mascara 56*/
                    declare
                      cursor cursor_05 is
                        select sgi.ipc6n_id,
                               sgi.ipc6n_prefijo,
                               sgi.ipc6v_clasec,
                               sgi.ipc6v_estado,
                               rip.rango
                          from trafficview.sgat_ipxclasec6 sgi
                          left join trafficview.rangosip rip
                            on rip.idrango = sgi.ipc6n_idrango
                         where sgi.ipc6n_id_padre = c_idpadre_c4
                           and sgi.ipc6n_id_padre <> ipc6n_id;
                      /*Variables de Cursor 05*/
                      c_idpadre_c5 number(10);
                      c_mask_c5    number(3);
                      c_ipred_c5   varchar2(50);
                      c_estado_c5  char(1);
                      c_cliente_c5 varchar2(30);
                    begin
                      open cursor_05;
                      loop
                        fetch cursor_05
                          into c_idpadre_c5,
                               c_mask_c5,
                               c_ipred_c5,
                               c_estado_c5,
                               c_cliente_c5;
                        exit when cursor_05%notfound;
                      
                        if c_mask_c5 = 56 then
                          /*realizamos el insert a la tabla temporal*/
                          insert into trafficview.tempexporexcel_ln
                            (t_mask_pri,
                             t_ipred_pri,
                             t_estado_pri,
                             t_equipo_pri,
                             t_produc_pri,
                             t_ip40,
                             t_est_ip40,
                             t_ip_m40,
                             t_ip44,
                             t_est_ip44,
                             t_ip_m44,
                             t_ip48,
                             t_est_ip48,
                             t_ip_m48,
                             t_ip52,
                             t_est_ip52,
                             t_ip_m52,
                             t_ip_cli52,
                             t_ip56,
                             t_est_ip56,
                             t_ip_m56)
                          values
                            (c_prefijo,
                             c_clasec,
                             c_estado,
                             c_equipo,
                             c_producto,
                             c_ipred_c1,
                             c_estado_c1,
                             c_mask_c1,
                             c_ipred_c2,
                             c_estado_c2,
                             c_mask_c2,
                             c_ipred_c3,
                             c_estado_c3,
                             c_mask_c3,
                             c_ipred_c4,
                             c_estado_c4,
                             c_mask_c4,
                             c_cliente_c5,
                             c_ipred_c5,
                             c_estado_c5,
                             c_mask_c5);
                        end if;
                      end loop;
                      close cursor_05;
                    end;
                  end loop;
                  close cursor_04;
                end;
              end loop;
              close cursor_03;
            end;
          end loop;
          close cursor_02;
        end;
      end loop;
      close cursor_01;
    end;

    open o_cursor for
      select 'LAN' as tipo_red,
             t_equipo_pri as equipo,
             t_produc_pri as producto,
             t_mask_pri as mascara_madre,
             t_ipred_pri as ip,
             t_estado_pri as estado,
             t_ip_m40 as mascara_40,
             t_ip40 as ipred_40,
             t_est_ip40 as estado_40,
             t_ip_m44 as mascara_44,
             t_ip44 as ipred_44,
             t_est_ip44 as estado_44,
             t_ip_m48 as mascara_48,
             t_ip48 as ipred_48,
             t_est_ip48 as estado_48,
             t_ip_m52 as mascara_52,
             t_ip52 as ipred_52,
             t_est_ip52 as estado_52,
             t_ip_cli52 as cliente,
             t_ip_m56 as mascara_56,
             t_ip56 as ipred_56,
             t_est_ip56 as estado_56
        from trafficview.tempexporexcel_ln;
  end;
  --------------------------------------------------------------------------------
 procedure sgass_listar_tipo_red_wn(k_mask   number,
                                    k_ipred  varchar2,
                                    o_cursor out sys_refcursor) is
   /*
   ****************************************************************
   * Nombre SP         : SGASS_LISTAR_TIPO_RED_WN
   * Propósito         : Lista Tipo de Red Wan
   * Input             : k_mask    --> Mascara
                         k_ipred   --> Ip Red
   * Output            : o_cursor  --> Cursor
   * Creado por        : 
   * Fec Creación      : 28/11/2017
   * Fec Actualización : N/A
   ****************************************************************
   */
   c_idpadre  number(10);
   c_prefijo  number(3);
   c_clasec   varchar2(50);
   c_estado   char(1);
   c_equipo   varchar2(100);
   c_producto varchar2(100);
 
 begin
   select ipc6n_id_padre, ipc6n_prefijo, ipc6v_clasec, ipc6v_estado
     into c_idpadre, c_prefijo, c_clasec, c_estado
     from trafficview.sgat_ipxclasec6
    where ipc6v_clasec = k_ipred
      and ipc6n_prefijo = k_mask;
 
   select equ.descripcion, pro.descripcion
     into c_equipo, c_producto
     from trafficview.sgat_clasec6 cls
     left join metasolv.equipored equ
       on cls.clc6n_codequipo = equ.codequipo
     left join metasolv.productocorp pro
       on cls.clc6n_codprd = pro.codprd
    where clc6v_clasec = k_ipred;
 
   declare
     cursor cursor_01 is
       select ipc6n_id, ipc6n_prefijo, ipc6v_clasec, ipc6v_estado
         from trafficview.sgat_ipxclasec6
        where ipc6n_id_padre = c_idpadre
          and ipc6n_id_padre <> ipc6n_id;
   
     /*variables de cursor 01 - mascara 40*/
     c_idpadre_c1 number(10);
     c_mask_c1    number(3);
     c_ipred_c1   varchar2(50);
     c_estado_c1  char(1);
   begin
     open cursor_01;
     loop
       fetch cursor_01
         into c_idpadre_c1, c_mask_c1, c_ipred_c1, c_estado_c1;
       exit when cursor_01%notfound;
       declare
         cursor cursor_02 is
           select ipx.ipc6n_id,
                  ipx.ipc6n_prefijo,
                  ipx.ipc6v_clasec,
                  ipx.ipc6v_estado,
                  (case ipx.ipc6v_estado
                    when 'A' then
                     rng.raipv_vlan
                    else
                     ''
                  end),
                  rng.rango
             from trafficview.sgat_ipxclasec6 ipx
             left join rangosip rng
               on ipx.ipc6n_idrango = rng.idrango
            where ipx.ipc6n_id_padre = c_idpadre_c1
              and ipx.ipc6n_id_padre <> ipx.ipc6n_id;
         /*Variables de Cursor 02*/
         c_idpadre_c2 number(10);
         c_mask_c2    number(3);
         c_ipred_c2   varchar2(50);
         c_estado_c2  char(1);
         c_vlan       varchar2(100);
         c_cliente    varchar2(30);
       begin
         open cursor_02;
         loop
           fetch cursor_02
             into c_idpadre_c2,
                  c_mask_c2,
                  c_ipred_c2,
                  c_estado_c2,
                  c_vlan,
                  c_cliente;
           exit when cursor_02%notfound;
           insert into trafficview.tempexporexcel_wn
             (t_mask_pri,
              t_ipred_pri,
              t_estado_pri,
              t_equipo_pri,
              t_produc_pri,
              t_mask_mip,
              t_mask_ipred,
              t_mask_est_ip,
              t_ip_red,
              t_ip_vlan,
              t_ip_cli,
              t_ip_est)
           values
             (c_prefijo,
              c_clasec,
              c_estado,
              c_equipo,
              c_producto, 
              c_mask_c1,
              c_ipred_c1,
              c_estado_c1,
              c_ipred_c2,
              c_vlan,
              c_cliente,
              c_estado_c2);
         end loop;
         close cursor_02;
       end;
     end loop;
     close cursor_01;
   end;
 
   open o_cursor for
     select 'WAN' as tipo_red,
            t_equipo_pri as equipo,
            t_produc_pri as producto,
            t_mask_pri as mascara_inicial,
            t_ipred_pri as ip_red,
            t_estado_pri as estado,
            t_mask_mip as mascara_siguiente,
            t_mask_ipred as ip_red_siguiente,
            t_mask_est_ip as estado_siguiente,
            t_ip_red as ip,
            t_ip_vlan as vlan,
            t_ip_cli as cliente,
            t_ip_est as estado_ip
       from trafficview.tempexporexcel_wn;
 end;
  --------------------------------------------------------------------------------
  procedure sgass_listar_tipo_red_lb(k_mask   number,
                                     k_ipred  varchar2,
                                     o_cursor out sys_refcursor) is
    /*
    ****************************************************************
    * Nombre SP         : SGASS_LISTAR_TIPO_RED_LB
    * Propósito         : Lista Tipo de Red Loop Back
    * Input             : k_mask    --> Mascara
                          k_ipred   --> Ip Red
    * Output            : o_cursor  --> Cursor
    * Creado por        : 
    * Fec Creación      : 28/11/2017
    * Fec Actualización : N/A
    ****************************************************************
    */
    c_idpadre  number(10);
    c_prefijo  number(3);
    c_clasec   varchar2(50);
    c_estado   char(1);
    c_equipo   varchar2(100);
    c_producto varchar2(100);
  
  begin
    select ipc6n_id_padre, ipc6n_prefijo, ipc6v_clasec, ipc6v_estado
      into c_idpadre, c_prefijo, c_clasec, c_estado
      from trafficview.sgat_ipxclasec6
     where ipc6v_clasec = k_ipred
       and ipc6n_prefijo = k_mask
       and ipc6n_id_padre = ipc6n_id;
  
    select equ.descripcion, pro.descripcion
      into c_equipo, c_producto
      from trafficview.sgat_clasec6 cls
      left join metasolv.equipored equ
        on cls.clc6n_codequipo = equ.codequipo
      left join metasolv.productocorp pro
        on cls.clc6n_codprd = pro.codprd
     where clc6v_clasec = k_ipred;
  
    insert into trafficview.tempexporexcel_lb
      (t_ip_red, t_ip_cli, t_ip_est, t_subtipo)
      select ipx.ipc6v_clasec,
             rng.rango,
             ipx.ipc6v_estado,
             ipx.ipc6c_tipo
        from trafficview.sgat_ipxclasec6 ipx
        left join rangosip rng
          on ipx.ipc6n_idrango = rng.idrango
       where ipx.ipc6n_id_padre = c_idpadre
         and ipx.ipc6n_id_padre <> ipx.ipc6n_id;
  
    update trafficview.tempexporexcel_lb
       set t_mask_pri   = c_prefijo,
           t_ipred_pri  = c_clasec,
           t_estado_pri = c_estado,
           t_equipo_pri = c_equipo,
           t_produc_pri = c_producto,
           t_subtipo    = substr(t_subtipo, 2, 1);
  
    open o_cursor for
      select 'LB' as tipo_red,
             t_equipo_pri as equipo,
             t_produc_pri as producto,
             t_mask_pri as mascara_inicial,
             t_ipred_pri as ip_red,
             t_estado_pri as estado,
             t_ip_red as ip,
             t_ip_cli as cliente,
             t_ip_est as estado_ip,
             t_subtipo as sub_tipo
        from trafficview.tempexporexcel_lb;
  end;
  --------------------------------------------------------------------------------
  procedure sgasi_asigna_ip(k_rango number) is
    /*
    ****************************************************************
    * Nombre SP         : SGASI_ASIGNA_IP
    * Propósito         : Asigna IP
    * Input             : k_rango --> Rango
    * Output            : 
    * Creado por        : 
    * Fec Creación      : 28/11/2017
    * Fec Actualización : N/A
    ****************************************************************
    */
    v_num                number;
    v_numip              number;
    c_iplan              varchar2(40);
    c_iplan_mask         varchar2(40);
    c_ipwan              varchar2(40);
    c_ipwan_mask         varchar2(40);
    c_iploopback_gestion varchar2(40);
    c_iploopback_voz     varchar2(40);
    c_iploopback_otros   varchar2(40);
    c_clasec             varchar2(40);
    c_rangomax           number;
    v_nroip              number;
    c_id                 number;
    c_idpadre            number;
    c_estado             varchar2(1);
    c_rangomaxw          number;
    c_rangomaxl          number;
    c_iplan_ant          varchar2(40);
    c_ipwan_ant          varchar2(40);
    c_iploopbg_ant       varchar2(40);
    c_iploopbv_ant       varchar2(40);
    c_iploopbo_ant       varchar2(40);
    c_cid                number;
    c_codusu             varchar2(30);
    c_fecusu             date;
    c_num                number;
    c_rango              varchar(30);
  
  begin
  
    --Actualizar en Nulo idrango los registros de IP para el rango
    v_num     := 0;
    c_idpadre := 0;
  
    /* Verifica si existen IP LAN con el rango ingresado*/
    select count(1)
      into v_num
      from trafficview.sgat_ipxclasec6
     where ipc6n_idrango = k_rango
       and ipc6c_tipo = 'L';
  
    /*Obtiene el ID PADRE DE LAN*/
    if v_num > 0 then
      select ipc6n_id_padre, ipc6v_clasec
        into c_idpadre, c_iplan_ant
        from trafficview.sgat_ipxclasec6
       where ipc6n_idrango = k_rango
         and ipc6c_tipo = 'L';
    else
      c_iplan_ant := '0';
    end if;
  
    v_num := 0;
  
    /* Verifica si existen IP WAN con el rango ingresado*/
    select count(1)
      into v_num
      from trafficview.sgat_ipxclasec6
     where ipc6n_idrango = k_rango
       and ipc6c_tipo = 'W'
       and ipc6v_estado <> 'S';
  
    /*Obtiene el ID PADRE DE WAN*/
    if v_num > 0 then
      select ipc6n_id_padre, ipc6v_clasec
        into c_idpadre, c_ipwan_ant
        from trafficview.sgat_ipxclasec6
       where ipc6n_idrango = k_rango
         and ipc6c_tipo = 'W'
         and ipc6v_estado <> 'S';
    else
      c_ipwan_ant := '0';
    end if;
  
    v_num := 0;
  
    /* Verifica si existen IP Loopback Otros con el rango ingresado*/
    select count(1)
      into v_num
      from trafficview.sgat_ipxclasec6
     where ipc6n_idrango = k_rango
       and ipc6c_tipo = 'LO';
  
    /*Obtiene el ID PADRE DE Loopback Otros*/
    if v_num > 0 then
      select ipc6n_id_padre, ipc6v_clasec
        into c_idpadre, c_iploopbo_ant
        from trafficview.sgat_ipxclasec6
       where ipc6n_idrango = k_rango
         and ipc6c_tipo = 'LO';
    else
      c_iploopbo_ant := '0';
    end if;
  
    v_num := 0;
  
    /* Verifica si existen IP Loopback Gestion con el rango ingresado*/
    select count(1)
      into v_num
      from trafficview.sgat_ipxclasec6
     where ipc6n_idrango = k_rango
       and ipc6c_tipo = 'LG';
  
    /*Obtiene el ID PADRE DE Loopback Gestion*/
    if v_num > 0 then
      select ipc6n_id_padre, ipc6v_clasec
        into c_idpadre, c_iploopbg_ant
        from trafficview.sgat_ipxclasec6
       where ipc6n_idrango = k_rango
         and ipc6c_tipo = 'LG';
    else
      c_iploopbg_ant := '0';
    end if;
  
    v_num := 0;
  
    /* Verifica si existen IP Loopback Voz con el rango ingresado*/
    select count(1)
      into v_num
      from trafficview.sgat_ipxclasec6
     where ipc6n_idrango = k_rango
       and ipc6c_tipo = 'LV';
  
    /*Obtiene el ID PADRE DE LAN*/
    if v_num > 0 then
      select ipc6n_id_padre, ipc6v_clasec
        into c_idpadre, c_iploopbv_ant
        from trafficview.sgat_ipxclasec6
       where ipc6n_idrango = k_rango
         and ipc6c_tipo = 'LV';
    else
      c_iploopbv_ant := '0';
    end if;
  
    --Obtener datos del rango
    select iplan,
           iplan_mask,
           ipwan,
           ipwan_mask,
           iploopback_gestion,
           iploopback_voz,
           iploopback_otros,
           codusu,
           fecusu,
           cid,
           rango
      into c_iplan,
           c_iplan_mask,
           c_ipwan,
           c_ipwan_mask,
           c_iploopback_gestion,
           c_iploopback_voz,
           c_iploopback_otros,
           c_codusu,
           c_fecusu,
           c_cid,
           c_rango
      from trafficview.rangosip
     where idrango = k_rango;
  
    --Obtener Rango Maximo
    select codigon
      into c_rangomax
      from operacion.opedd
     where abreviacion = 'RANGO_LAN';
  
    select codigon
      into c_rangomaxw
      from operacion.opedd
     where abreviacion = 'RANGO_MAXWAN';
  
    select max(codigon)
      into c_rangomaxl
      from operacion.opedd
     where abreviacion = 'RANGO_LOOP';
  
    /*********
      IP LAN
    *********/
    if (c_iplan_mask is not null) and (c_iplan_mask <> c_iplan_ant) then
    
      if c_iplan_ant <> '0' then
        sgasi_desasigna_ip(k_rango, 'I', 'L', c_iplan_ant);
      end if;
    
      /*Verifico si no existen IPs Asignadas de esta RED LAN, y cambio estado*/
      if c_idpadre != 0 then
        select count(1)
          into v_nroip
          from trafficview.sgat_ipxclasec6
         where ipc6n_id_padre = c_idpadre
           and ipc6v_estado = 'A'
           and ipc6c_tipo = 'L';
      
        if v_nroip = 0 then
          update trafficview.sgat_ipxclasec6
             set ipc6v_estado = 'L'
           where ipc6n_id_padre = c_idpadre
             and ipc6c_tipo = 'L';
        end if;
      
        c_idpadre := 0;
      end if;
    
      select ipc6n_id_padre
        into c_idpadre
        from trafficview.sgat_ipxclasec6
       where ipc6v_clasec = c_iplan_mask
         and ipc6n_prefijo = c_rangomax
         and ipc6c_tipo = 'L';
    
      update trafficview.sgat_ipxclasec6
         set ipc6n_idrango = k_rango, ipc6v_estado = 'A'
       where ipc6v_clasec = c_iplan_mask
         and ipc6n_id_padre = c_idpadre
         and ipc6c_tipo = 'L';
    
      update trafficview.sgat_ipxclasec6
         set ipc6v_estado = 'R'
       where ipc6n_id_padre = c_idpadre
         and ipc6c_tipo = 'L'
         and ipc6v_estado != 'A';
    
      while c_rangomax > 0 loop
      
        v_numip := 0;
      
        select count(1)
          into v_numip
          from trafficview.sgat_ipxclasec6
         where ipc6n_id_padre = c_idpadre
           and ipc6n_prefijo = c_rangomax
           and ipc6c_tipo = 'L';
      
        if v_numip > 1 then
        
          v_nroip := 0;
        
          select count(1)
            into v_nroip
            from trafficview.sgat_ipxclasec6
           where ipc6n_id_padre = c_idpadre
             and ipc6n_prefijo = c_rangomax
             and (ipc6v_estado != 'A' and ipc6v_estado != 'T')
             and ipc6c_tipo = 'L';
        
          c_id := c_idpadre;
        
          if v_nroip != 0 then
            update trafficview.sgat_ipxclasec6
               set ipc6v_estado = 'P'
             where ipc6n_id = c_id
               and ipc6c_tipo = 'L';
          else
            update trafficview.sgat_ipxclasec6
               set ipc6v_estado = 'T'
             where ipc6n_id = c_id
               and ipc6c_tipo = 'L';
          end if;
        
          select ipc6n_id_padre
            into c_idpadre
            from trafficview.sgat_ipxclasec6
           where ipc6n_id = c_id
             and ipc6c_tipo = 'L';
        
          c_rangomax := c_rangomax - 4;
        
        else
        
          select clas.clc6v_clasec, ipx.ipc6v_estado
            into c_clasec, c_estado
            from trafficview.sgat_clasec6 clas
            join trafficview.sgat_ipxclasec6 ipx
              on clas.clc6v_clasec = ipx.ipc6v_clasec
             and clas.clc6n_prefijo = ipx.ipc6n_prefijo
           where ipx.ipc6n_id = c_id
             and ipx.ipc6c_tipo = 'L';
        
          if c_estado = 'P' then
            update trafficview.sgat_clasec6
               set clc6n_estado = 1
             where clc6v_clasec = c_clasec;
          else
            update trafficview.sgat_clasec6
               set clc6n_estado = 2
             where clc6v_clasec = c_clasec;
          end if;
        
          c_rangomax := 0;
        end if;
      end loop;
    
      select count(1)
        into v_nroip
        from trafficview.sgat_desasignacion_ip
       where desav_ip = c_iplan
         and desan_cid = c_cid;
    
      if v_nroip = 0 then
        select max(desav_id) into c_num from trafficview.sgat_desasignacion_ip;
      
        if c_num is null or c_num = 0 then
          c_num := 1;
        else
          c_num := c_num + 1;
        end if;
      
        insert into trafficview.sgat_desasignacion_ip
          (desav_id,
           desav_ip,
           desav_tipo,
           desav_cliente,
           desan_cid,
           desad_fec_asigna,
           desav_usu_asigna,
           desac_estado)
        values
          (c_num, c_iplan, 'L', c_rango, c_cid, c_fecusu, c_codusu, '1');
      else
        update trafficview.sgat_desasignacion_ip
           set desad_fec_desasigna = null,
               desav_usu_desasigna = null,
               desav_cliente       = c_rango
         where desav_ip = c_iplan
           and desan_cid = c_cid;
      end if;    
    end if;
  
    /*********
      IP WAN
    *********/
    if (c_ipwan is not null) and (c_ipwan_mask <> c_ipwan_ant) then
    
      if c_ipwan_ant <> '0' then
        sgasi_desasigna_ip(k_rango, 'I', 'W', c_ipwan_ant);
      end if;
    
      select sgi1.ipc6n_id_padre, sgi1.ipc6n_prefijo
        into c_idpadre, c_rangomaxw
        from trafficview.sgat_ipxclasec6 sgi1
        join trafficview.sgat_ipxclasec6 sgi2
          on sgi1.ipc6n_id_padre = sgi2.ipc6n_id
       where sgi1.ipc6v_clasec = c_ipwan_mask
         and sgi1.ipc6n_id_padre <> sgi1.ipc6n_id
         and sgi2.ipc6n_id_padre <> sgi2.ipc6n_id
         and sgi1.ipc6c_tipo = 'W';
    
      update trafficview.sgat_ipxclasec6
         set ipc6n_idrango = k_rango, ipc6v_estado = 'A', ipc6c_tipo = 'W'
       where ipc6v_clasec = c_ipwan_mask
         and ipc6n_id_padre = c_idpadre
         and ipc6n_id_padre <> ipc6n_id;
    
      while c_rangomaxw > 0 loop
      
        v_nroip := 0;
      
        select count(1)
          into v_nroip
          from trafficview.sgat_ipxclasec6
         where ipc6n_id_padre = c_idpadre
           and ipc6n_prefijo = c_rangomaxw
           and ipc6c_tipo = 'W';
      
        if v_nroip > 1 then        
          select count(1)
            into v_nroip
            from trafficview.sgat_ipxclasec6
           where ipc6n_id_padre = c_idpadre
             and ipc6n_prefijo = c_rangomaxw
             and (ipc6v_estado = 'L' or ipc6v_estado = 'P')
             and ipc6c_tipo = 'W';
        
          c_id := c_idpadre;
        
          if v_nroip != 0 then
            update trafficview.sgat_ipxclasec6
               set ipc6v_estado = 'P'
             where ipc6n_id = c_id
               and ipc6c_tipo = 'W';
          else
            update trafficview.sgat_ipxclasec6
               set ipc6v_estado = 'T'
             where ipc6n_id = c_id
               and ipc6c_tipo = 'W';
          end if;
        
          select ipc6n_id_padre
            into c_idpadre
            from trafficview.sgat_ipxclasec6
           where ipc6n_id = c_id
             and ipc6c_tipo = 'W';
        
          if c_idpadre = c_id then
            c_rangomaxw := c_rangomaxw - 3;
          end if;
        else
        
          select clas.clc6v_clasec, ipx.ipc6v_estado
            into c_clasec, c_estado
            from trafficview.sgat_clasec6 clas
            join trafficview.sgat_ipxclasec6 ipx
              on clas.clc6v_clasec = ipx.ipc6v_clasec
             and clas.clc6n_prefijo = ipx.ipc6n_prefijo
           where ipx.ipc6n_id = c_id
             and ipx.ipc6c_tipo = 'W';
        
          if c_estado = 'P' then
            update trafficview.sgat_clasec6
               set clc6n_estado = 1
             where clc6v_clasec = c_clasec;
          else
            update trafficview.sgat_clasec6
               set clc6n_estado = 2
             where clc6v_clasec = c_clasec;
          end if;
        
          c_rangomaxw := 0;
        end if;
      end loop;
    end if;
  
    /*******************
      LOOPBACKGESTION
    *******************/
    if (c_iploopback_gestion is not null) and
       (c_iploopback_gestion <> c_iploopbg_ant) then    
      if c_iploopbg_ant <> '0' then
        sgasi_desasigna_ip(k_rango, 'I', 'LG', c_iploopbg_ant);
      end if;
    
      select ipc6n_id_padre, ipc6n_prefijo
        into c_idpadre, c_rangomaxl
        from trafficview.sgat_ipxclasec6
       where ipc6v_clasec = c_iploopback_gestion
         and ipc6n_id_padre <> ipc6n_id
         and ipc6c_tipo <> 'L'
         and ipc6c_tipo <> 'W';
    
      update trafficview.sgat_ipxclasec6
         set ipc6n_idrango = k_rango, ipc6v_estado = 'A', ipc6c_tipo = 'LG'
       where ipc6v_clasec = c_iploopback_gestion
         and ipc6n_id_padre <> ipc6n_id
         and ipc6c_tipo <> 'L'
         and ipc6c_tipo <> 'W';
    
      select count(1)
        into v_nroip
        from trafficview.sgat_ipxclasec6
       where ipc6n_id_padre = c_idpadre
         and (ipc6v_estado != 'A' and ipc6v_estado != 'T')
         and ipc6c_tipo <> 'L'
         and ipc6c_tipo <> 'W';
    
      c_id := c_idpadre;
    
      if v_nroip != 0 then
        update trafficview.sgat_ipxclasec6
           set ipc6v_estado = 'P'
         where ipc6n_id = c_id
           and ipc6c_tipo <> 'L'
           and ipc6c_tipo <> 'W';
      else
        update trafficview.sgat_ipxclasec6
           set ipc6v_estado = 'T'
         where ipc6n_id = c_id
           and ipc6c_tipo <> 'L'
           and ipc6c_tipo <> 'W';
      end if;
    
      select clas.clc6v_clasec, ipx.ipc6v_estado
        into c_clasec, c_estado
        from trafficview.sgat_clasec6 clas
        join trafficview.sgat_ipxclasec6 ipx
          on clas.clc6v_clasec = ipx.ipc6v_clasec
         and clas.clc6n_prefijo = ipx.ipc6n_prefijo
       where ipx.ipc6n_id = c_id
         and ipx.ipc6c_tipo <> 'L'
         and ipx.ipc6c_tipo <> 'W';
    
      if C_EStADO = 'P' then
        update trafficview.sgat_clasec6
           set clc6n_estado = 1
         where clc6v_clasec = c_clasec;
      else
        update trafficview.sgat_clasec6
           set clc6n_estado = 2
         where clc6v_clasec = c_clasec;
      end if;
    end if;
  
    /*******************
      LOOPBACKVOZ
    *******************/
  
    if (c_iploopback_voz is not null) and (c_iploopback_voz <> c_iploopbv_ant) then    
      if c_iploopbv_ant <> '0' then
        sgasi_desasigna_ip(k_rango, 'I', 'LV', c_iploopbv_ant);
      end if;
    
      select ipc6n_id_padre, ipc6n_prefijo
        into c_idpadre, c_rangomaxl
        from trafficview.sgat_ipxclasec6
       where ipc6v_clasec = c_iploopback_voz
         and ipc6n_id_padre <> ipc6n_id
         and ipc6c_tipo <> 'L'
         and ipc6c_tipo <> 'W';
    
      update trafficview.sgat_ipxclasec6
         set ipc6n_idrango = k_rango, ipc6v_estado = 'A', ipc6c_tipo = 'LV'
       where ipc6v_clasec = c_iploopback_voz
         and ipc6n_id_padre <> ipc6n_id
         and ipc6c_tipo <> 'L'
         and ipc6c_tipo <> 'W';
    
      select count(1)
        into v_nroip
        from trafficview.sgat_ipxclasec6
       where ipc6n_id_padre = c_idpadRE
         and (ipc6v_estado != 'A' and ipc6v_estado != 'T')
         and ipc6c_tipo <> 'L'
         and ipc6c_tipo <> 'W';
    
      c_id := c_idpadre;
    
      if v_nroip != 0 then
        update trafficview.sgat_ipxclasec6
           set ipc6v_estado = 'P'
         where ipc6n_id = c_id
           and ipc6c_tipo <> 'L'
           and ipc6c_tipo <> 'W';
      else
        update trafficview.sgat_ipxclasec6
           set ipc6v_estado = 'T'
         where ipc6n_id = c_id
           and ipc6c_tipo <> 'L'
           and ipc6c_tipo <> 'W';
      end if;
    
      select clas.clc6v_clasec, ipx.ipc6v_estado
        into c_clasec, c_estado
        from trafficview.sgat_clasec6 clas
        join trafficview.sgat_ipxclasec6 ipx
          on clas.clc6v_clasec = ipx.ipc6v_clasec
         and clas.clc6n_prefijo = ipx.ipc6n_prefijo
       where ipx.ipc6n_id = c_id
         and ipx.ipc6c_tipo <> 'L'
         and ipx.ipc6c_tipo <> 'W';
    
      if c_estado = 'P' then
        update trafficview.sgat_clasec6
           set clc6n_estado = 1
         where clc6v_clasec = c_clasec;
      else
        update trafficview.sgat_clasec6
           set clc6n_estado = 2
         where clc6v_clasec = c_clasec;
      end if;
    end if;
  
    /*******************
      LOOPBACKOTROS
    *******************/
    if (c_iploopback_otros is not null) and
       (c_iploopback_otros <> c_iploopbo_ant) then
    
      if c_iploopbo_ant <> '0' then
        sgasi_desasigna_ip(k_rango, 'I', 'LO', c_iploopbo_ant);
      end if;
    
      select ipc6n_id_padre, ipc6n_prefijo
        into c_idpadre, c_rangomaxl
        from trafficview.sgat_ipxclasec6
       where ipc6v_clasec = c_iploopback_otros
         and ipc6n_id_padre <> ipc6n_id
         and ipc6c_tipo <> 'L'
         and ipc6c_tipo <> 'W';
    
      update trafficview.sgat_ipxclasec6
         set ipc6n_idrango = K_RANGO, ipc6v_estado = 'A', ipc6c_tipo = 'LO'
       where ipc6v_clasec = c_iploopback_otros
         and ipc6n_id_padre <> ipc6n_id
         and ipc6c_tipo <> 'L'
         and ipc6c_tipo <> 'W';
    
      select count(1)
        into v_nroip
        from trafficview.sgat_ipxclasec6
       where ipc6n_id_padre = c_idpadre
         and (ipc6v_estado != 'A' and ipc6v_estado != 'T')
         and ipc6c_tipo <> 'L'
         and ipc6c_tipo <> 'W';
    
      c_id := c_idpadre;
    
      if v_nroip != 0 then
        update trafficview.sgat_ipxclasec6
           set ipc6v_estado = 'P'
         where ipc6n_id = c_id
           and ipc6c_tipo <> 'L'
           and ipc6c_tipo <> 'W';
      else
        update trafficview.sgat_ipxclasec6
           set ipc6v_estado = 'T'
         where ipc6n_id = c_id
           and ipc6c_tipo <> 'L'
           and ipc6c_tipo <> 'W';
      end if;
    
      select clas.clc6v_clasec, ipx.ipc6v_estado
        into c_clasec, c_estado
        from trafficview.sgat_clasec6 clas
        join trafficview.sgat_ipxclasec6 ipx
          on clas.clc6v_clasec = ipx.ipc6v_clasec
         and clas.clc6n_prefijo = ipx.ipc6n_prefijo
       where ipx.ipc6n_id = c_id
         and ipx.ipc6c_tipo <> 'L'
         and ipx.ipc6c_tipo <> 'W';
    
      if c_estado = 'P' then
        update trafficview.sgat_clasec6
           set clc6n_estado = 1
         where clc6v_clasec = c_clasec;
      else
        update trafficview.sgat_clasec6
           set clc6n_estado = 2
         where clc6v_clasec = c_clasec;
      end if;
    end if;
  
  end;
  --------------------------------------------------------------------------------
  procedure sgasi_desasigna_ip(k_rango   number,
                               k_tipodes char,
                               k_tipoip  varchar2,
                               k_ip      varchar2) is
    /*
    ****************************************************************
    * Nombre SP         : SGASI_DESASIGNA_IP
    * Propósito         : Desasigna IP
    * Input             : k_rango   --> Rango
                          k_tipodes --> Tipo Des
                          k_tipoip  --> Tipo Id
                          k_ip      --> Ip
    * Output            : 
    * Creado por        : 
    * Fec Creación      : 28/11/2017
    * Fec Actualización : N/A
    ****************************************************************
    */    
    v_numip              number;
    v_nroip              number;
    c_iplan              varchar2(50);
    c_iplan_mask         varchar2(50);
    c_ipwan_mask         varchar2(50);
    c_iploopback_gestion varchar2(50);
    c_iploopback_voz     varchar2(50);
    c_iploopback_otros   varchar2(50);
    c_clasec             varchar2(50);
    c_rangomax           number;
    c_id                 number;
    c_idpadre            number;
    c_rango              varchar(50);
    c_cid                number;
    c_fecusu             date;
    c_codusu             varchar2(50);
    c_fecusud            date;
    c_codusud            varchar2(50);
    c_estado             varchar2(10);
    c_rangomaxw          number;
    c_rangomaxl          number;
    c_nro                number;
    
  begin    
    c_idpadre := 0;
    
    --Obtener datos del rango
    if k_tipodes = 'D' then
      select iplan,
             iplan_mask,
             ipwan_mask,
             iploopback_gestion,
             iploopback_voz,
             iploopback_otros,
             rango,
             cid,
             fecusu,
             codusu
        into c_iplan,
             c_iplan_mask,
             c_ipwan_mask,
             c_iploopback_gestion,
             c_iploopback_voz,
             c_iploopback_otros,
             c_rango,
             c_cid,
             c_fecusu,
             c_codusu
        from trafficview.rangosip
       where idrango = k_rango;
    else
      
      select cid into c_cid from trafficview.rangosip where idrango = k_rango;
      
      case k_tipoip
        when 'L' then
          c_iplan_mask := k_ip;
        when 'W' then
          c_ipwan_mask := k_ip;
        when 'LO' then
          c_iploopback_otros := k_ip;
        when 'LG' then
          c_iploopback_gestion := k_ip;
        when 'LV' then
          c_iploopback_voz := k_ip;
      end case;
      
    end if;
    
    select sysdate into c_fecusud from dual;
    
    select user into c_codusud from dual;
    
    select count(1)
      into c_nro
      from trafficview.sgat_ipxclasec6
     where ipc6v_clasec = c_iploopback_gestion
       and ipc6n_id_padre <> ipc6n_id
       and ipc6n_idrango = k_rango;
    
    if c_nro = 0 then
      c_iploopback_gestion := null;
    end if;
    
    select count(1)
      into c_nro
      from trafficview.sgat_ipxclasec6
     where ipc6v_clasec = c_iploopback_voz
       and ipc6n_id_padre <> ipc6n_id
       and ipc6n_idrango = k_rango;
    
    if c_nro = 0 then
      c_iploopback_voz := null;
    end if;
    
    select count(1)
      into c_nro
      from trafficview.sgat_ipxclasec6
     where ipc6v_clasec = c_iploopback_otros
       and ipc6n_id_padre <> ipc6n_id
       and ipc6n_idrango = k_rango;
    
    if c_nro = 0 then
      c_iploopback_otros := null;
    end if;
    
    select count(1)
      into c_nro
      from trafficview.sgat_ipxclasec6
     where ipc6n_id_padre <> ipc6n_id
       and ipc6v_clasec = c_ipwan_mask
       and ipc6n_idrango = k_rango
       and ipc6c_tipo = 'W'
       and ipc6v_estado <> 'S';
    
    if c_nro = 0 then
      c_ipwan_mask := null;
    end if;
    
    --Obtener Rango Maximo    
    select codigon
      into c_rangomax
      from operacion.opedd
     where abreviacion = 'RANGO_LAN';
    
    /*********
      IP LAN
    *********/    
    if (c_iplan_mask is not null) and (k_tipoip = 'L' or k_tipoip = '0') then      
      select ipc6n_id_padre
        into c_idpadre
        from trafficview.sgat_ipxclasec6
       where ipc6v_clasec = c_iplan_mask
         and ipc6n_prefijo = c_rangomax
         and ipc6n_idrango = k_rango
         and ipc6c_tipo = 'L';
      
      if c_iplan is null then
        select ipc6v_clasec
          into c_iplan
          from trafficview.sgat_ipxclasec6
         where ipc6n_id = c_idpadre;
      end if;
      
      select count(1)
        into v_nroip
        from trafficview.sgat_ipxclasec6
       where ipc6n_id_padre = c_idpadre
         and ipc6v_clasec != c_iplan_mask
         and ipc6v_estado = 'A';
      
      if v_nroip = 0 then
        
        update trafficview.sgat_ipxclasec6
           set ipc6v_estado = 'L', ipc6n_idrango = null
         where ipc6n_id_padre = c_idpadre;
        
      else
        
        update trafficview.sgat_ipxclasec6
           set ipc6v_estado = 'R', ipc6n_idrango = null
         where ipc6n_idrango = k_rango
           and ipc6n_id_padre = c_idpadre;
        
      end if;
      
      while c_rangomax > 0 loop
        
        v_numip := 0;
        
        select count(1)
          into v_numip
          from trafficview.sgat_ipxclasec6
         where ipc6n_id_padre = c_idpadre
           and ipc6n_prefijo = c_rangomax
           and ipc6c_tipo = 'L';
        
        if v_numip > 1 then
          
          v_nroip := 0;
          
          select count(1)
            into v_nroip
            from trafficview.sgat_ipxclasec6
           where ipc6n_prefijo = c_rangomax
             and ipc6n_id_padre = c_idpadre
             and ipc6v_estado != 'L'
             and ipc6c_tipo = 'L';
          
          c_id := c_idpadre;
          
          if v_nroip = 0 then
            update trafficview.sgat_ipxclasec6
               set ipc6v_estado = 'L'
             where ipc6n_id = c_id
               and ipc6c_tipo = 'L';
          else
            update trafficview.sgat_ipxclasec6
               set ipc6v_estado = 'P'
             where ipc6n_id = c_id
               and ipc6c_tipo = 'L';
          end if;
          
          select ipc6n_id_padre
            into c_idpadre
            from trafficview.sgat_ipxclasec6
           where ipc6n_id = c_id
             and ipc6c_tipo = 'L';
          
          c_rangomax := c_rangomax - 4;
          
        else          
          select clas.clc6v_clasec, ipx.ipc6v_estado
            into c_clasec, c_estado
            from trafficview.sgat_clasec6 clas
            join trafficview.sgat_ipxclasec6 ipx
              on clas.clc6v_clasec = ipx.ipc6v_clasec
             and clas.clc6n_prefijo = ipx.ipc6n_prefijo
           where ipx.ipc6n_id = c_id
             and ipx.ipc6c_tipo = 'L';
          
          if C_ESTADO = 'P' then            
            update trafficview.sgat_clasec6
               set clc6n_estado = 1
             where clc6v_clasec = c_clasec;            
          else            
            update trafficview.sgat_clasec6
               set clc6n_estado = 0
             where clc6v_clasec = c_clasec;            
          end if;
          
          c_rangomax := 0;
        end if;
      end loop;
      
      if k_tipodes = 'D' then
        delete from trafficview.rangosip where idrango = k_rango;
      end if;
      
      select count(1)
        into v_nroip
        from rangosip
       where iplan = c_iplan
         and cid = c_cid;
      
      if v_nroip = 0 then        
        update trafficview.sgat_desasignacion_ip
           set desad_fec_desasigna = c_fecusud, desav_usu_desasigna = c_codusud
         where desav_ip = c_iplan
           and desan_cid = c_cid;        
      end if;      
    end if;
    
    /*********
      IP WAN
    *********/    
    if (c_ipwan_mask is not null) and (k_tipoip = 'W' or k_tipoip = '0') then      
      select ipc6n_id_padre, ipc6n_prefijo
        into c_idpadre, c_rangomaxw
        from trafficview.sgat_ipxclasec6
       where ipc6n_id_padre <> ipc6n_id
         and ipc6v_clasec = c_ipwan_mask
         and ipc6n_idrango = k_rango
         and ipc6c_tipo = 'W'
         and ipc6v_estado <> 'S';
      
      update trafficview.sgat_ipxclasec6
         set ipc6n_idrango = null, ipc6v_estado = 'L'
       where ipc6v_clasec = c_ipwan_mask
         and ipc6n_prefijo = c_rangomaxw
         and ipc6n_idrango = k_rango
         and ipc6c_tipo = 'W'
         and ipc6v_estado <> 'S';
      
      while c_rangomaxw > 0 loop
        
        v_numip := 0;
        
        select count(1)
          into v_numip
          from trafficview.sgat_ipxclasec6
         where ipc6n_id_padre = c_idpadre
           and ipc6n_prefijo = c_rangomaxw
           and ipc6c_tipo = 'W';
        
        if v_numip > 1 then
          
          v_nroip := 0;
          
          select count(1)
            into v_nroip
            from trafficview.sgat_ipxclasec6
           where ipc6n_prefijo = c_rangomaxw
             and ipc6n_id_padre = c_idpadre
             and ipc6v_estado != 'L'
             and ipc6c_tipo = 'W';
          
          c_id := c_idpadre;
          
          if v_nroip = 0 then
            update trafficview.sgat_ipxclasec6
               set ipc6v_estado = 'L'
             where ipc6n_id = c_id
               and ipc6c_tipo = 'W';
          else
            update trafficview.sgat_ipxclasec6
               set ipc6v_estado = 'P'
             where ipc6n_id = c_id
               and ipc6c_tipo = 'W';
          end if;
          
          select ipc6n_id_padre
            into c_idpadre
            from trafficview.sgat_ipxclasec6
           where ipc6n_id = c_id
             and ipc6c_tipo = 'W';
          
          if c_idpadre = c_id then
            c_rangomaxw := c_rangomaxw - 3;
          end if;
          
        else
          
          select clas.clc6v_clasec, ipx.ipc6v_estado
            into c_clasec, c_estado
            from trafficview.sgat_clasec6 clas
            join trafficview.sgat_ipxclasec6 ipx
              on clas.clc6v_clasec = ipx.ipc6v_clasec
             and clas.clc6n_prefijo = ipx.ipc6n_prefijo
           where ipx.ipc6n_id = c_id
             and ipx.ipc6c_tipo = 'W';
          
          if c_estado = 'P' then
            update trafficview.sgat_clasec6
               set clc6n_estado = 1
             where clc6v_clasec = c_clasec;
          else
            update trafficview.sgat_clasec6
               set clc6n_estado = 0
             where clc6v_clasec = c_clasec;
          end if;
          
          c_rangomaxw := 0;
        end if;
      end loop;
      
      if k_tipodes = 'D' then
        delete from trafficview.rangosip where idrango = k_rango;
      end if;
    end if;
    
    /*******************
      LOOPBACKGESTION
    *******************/    
    if (c_iploopback_gestion is not null) and
       (k_tipoip = 'LG' or k_tipoip = '0') then
      
      select ipc6n_id_padre, ipc6n_prefijo
        into c_idpadre, c_rangomaxl
        from trafficview.sgat_ipxclasec6
       where ipc6v_clasec = c_iploopback_gestion
         and ipc6n_id_padre <> ipc6n_id
         and ipc6n_idrango = k_rango
         and ipc6c_tipo = 'LG';
      
      update trafficview.sgat_ipxclasec6
         set ipc6n_idrango = null, ipc6v_estado = 'L', ipc6c_tipo = 'LO'
       where ipc6v_clasec = c_iploopback_gestion
         and ipc6n_prefijo = c_rangomaxl
         and ipc6n_id_padre <> ipc6n_id
         and ipc6n_idrango = k_rango;
      
      select count(1)
        into v_nroip
        from trafficview.sgat_ipxclasec6
       where ipc6n_id_padre = c_idpadre
         and ipc6n_id_padre <> ipc6n_id
         and ipc6v_estado != 'L';
      
      c_id := c_idpadre;
      
      if v_nroip = 0 then
        update trafficview.sgat_ipxclasec6
           set ipc6v_estado = 'L'
         where ipc6n_id = c_id;
      else
        update trafficview.sgat_ipxclasec6
           set ipc6v_estado = 'P'
         where ipc6n_id = c_id;
      end if;
      
      select clas.clc6v_clasec, ipx.ipc6v_estado
        into c_clasec, c_estado
        from trafficview.sgat_clasec6 clas
        join trafficview.sgat_ipxclasec6 ipx
          on clas.clc6v_clasec = ipx.ipc6v_clasec
         and clas.clc6n_prefijo = ipx.ipc6n_prefijo
       where ipx.ipc6n_id = c_id;
      
      if c_estado = 'P' then        
        update trafficview.sgat_clasec6
           set clc6n_estado = 1
         where clc6v_clasec = c_clasec;
        
      else
        update trafficview.sgat_clasec6
           set clc6n_estado = 0
         where clc6v_clasec = c_clasec;
      end if;
      
      if k_tipodes = 'D' then
        delete from trafficview.rangosip where idrango = k_rango;
      end if;
    end if;
    
    /*******************
      LOOPBACKVOZ
    *******************/    
    if (c_iploopback_voz is not null) and (k_tipoip = 'LV' or k_tipoip = '0') then      
      select ipc6n_id_padre, ipc6n_prefijo
        into c_idpadre, c_rangomaxl
        from trafficview.sgat_ipxclasec6
       where ipc6v_clasec = c_iploopback_voz
         and ipc6n_id_padre <> ipc6n_id
         and ipc6n_idrango = k_rango
         and ipc6c_tipo = 'LV';
      
      update trafficview.sgat_ipxclasec6
         set ipc6n_idrango = null, ipc6v_estado = 'L', ipc6c_tipo = 'LO'
       where ipc6v_clasec = c_iploopback_voz
         and ipc6n_prefijo = c_rangomaxl
         and ipc6n_id_padre <> ipc6n_id
         and ipc6n_idrango = k_rango;
      
      select count(1)
        into v_nroip
        from trafficview.sgat_ipxclasec6
       where ipc6n_id_padre = c_idpadre
         and ipc6n_id_padre <> ipc6n_id
         and ipc6v_estado != 'L';
      
      c_id := c_idpadre;
      
      if v_nroip = 0 then
        update trafficview.sgat_ipxclasec6
           set ipc6v_estado = 'L'
         where ipc6n_id = c_id;
      else
        update trafficview.sgat_ipxclasec6
           set ipc6v_estado = 'P'
         where ipc6n_id = c_id;
      end if;
      
      select clas.clc6v_clasec, ipx.ipc6v_estado
        into c_clasec, c_estado
        from trafficview.sgat_clasec6 clas
        join trafficview.sgat_ipxclasec6 ipx
          on clas.clc6v_clasec = ipx.ipc6v_clasec
         and clas.clc6n_prefijo = ipx.ipc6n_prefijo
       where ipx.ipc6n_id = c_id;
      
      if c_estado = 'P' then        
        update trafficview.sgat_clasec6
           set clc6n_estado = 1
         where clc6v_clasec = c_clasec;
        
      else
        update trafficview.sgat_clasec6
           set clc6n_estado = 0
         where clc6v_clasec = c_clasec;
      end if;
      
      if k_tipodes = 'D' then
        delete from trafficview.rangosip where idrango = k_rango;
      end if;
    end if;
    
    /*******************
      LOOPBACKOTROS
    *******************/
    if (c_iploopback_otros is not null) and (k_tipoip = 'LO' or k_tipoip = '0') then      
      select ipc6n_id_padre, ipc6n_prefijo
        into c_idpadre, c_rangomaxl
        from trafficview.sgat_ipxclasec6
       where ipc6v_clasec = c_iploopback_otros
         and ipc6n_id_padre <> ipc6n_id
         and ipc6n_idrango = k_rango
         and ipc6c_tipo = 'LO';
      
      update trafficview.sgat_ipxclasec6
         set ipc6n_idrango = null, ipc6v_estado = 'L', ipc6c_tipo = 'LO'
       where ipc6v_clasec = c_iploopback_otros
         and ipc6n_prefijo = c_rangomaxl
         and ipc6n_id_padre <> ipc6n_id
         and ipc6n_idrango = k_rango;
      
      select count(1)
        into v_nroip
        from trafficview.sgat_ipxclasec6
       where ipc6n_id_padre = c_idpadre
         and ipc6n_id_padre <> ipc6n_id
         and ipc6v_estado != 'L';
      
      c_id := c_idpadre;
      
      if v_nroip = 0 then
        update trafficview.sgat_ipxclasec6
           set ipc6v_estado = 'L'
         where ipc6n_id = c_id;
      else
        update trafficview.sgat_ipxclasec6
           set ipc6v_estado = 'P'
         where ipc6n_id = c_id;
      end if;
      
      select clas.clc6v_clasec, ipx.ipc6v_estado
        into c_clasec, c_estado
        from trafficview.sgat_clasec6 clas
        join trafficview.sgat_ipxclasec6 ipx
          on clas.clc6v_clasec = ipx.ipc6v_clasec
         and clas.clc6n_prefijo = ipx.ipc6n_prefijo
       where ipx.ipc6n_id = c_id;
      
      if c_estado = 'P' then        
        update trafficview.sgat_clasec6
           set clc6n_estado = 1
         where clc6v_clasec = c_clasec;
        
      else
        update trafficview.sgat_clasec6
           set clc6n_estado = 0
         where clc6v_clasec = c_clasec;
      end if;
      
      if k_tipodes = 'D' then
        delete from trafficview.rangosip where idrango = k_rango;
      end if;
    end if;
  end;
  --------------------------------------------------------------------------------
  procedure sgass_evaluar_ip6(k_ip  varchar2,
                              k_res out varchar2,
                              k_1   out varchar2,
                              k_2   out varchar2,
                              k_3   out varchar2,
                              k_4   out varchar2,
                              k_5   out varchar2,
                              k_6   out varchar2,
                              k_7   out varchar2,
                              k_8   out varchar2) is
    /*
    ****************************************************************
    * Nombre SP         : SGASS_EVALUAR_IP6
    * Propósito         : Evaluar IPV6
    * Input             : k_ip   --> Ip
    * Output            : k_res  --> Respuesta
                          k_1    --> Ip 1
                          k_2    --> IP 2
                          k_3    --> IP 3         
                          k_4    --> IP 4
                          k_5    --> IP 5
                          k_6    --> IP 6
                          k_7    --> IP 7
                          k_8    --> IP 8   
    * Creado por        : 
    * Fec Creación      : 28/11/2017
    * Fec Actualización : N/A
    ****************************************************************
    */
    v_pos  number;
    v_pos2 number;
    v_ip   varchar2(39);
    v_0    varchar2(4);
    v_ind number;
    v_ips varchar2(39);
    v_nro number;

  begin
    v_ip  := upper(k_ip);
    v_pos := 0;
    v_ind := length(v_ip) - length(replace(v_ip, ':'));

    /*Llena los bloques vacios*/
    if v_ind > 8 then
      k_res := 'Formato de IP Inválido';
      return;
    else
      v_ind := length(v_ip) - length(replace(v_ip, '::'));
    
      if v_ind > 2 then
        k_res := 'Formato de IP Inválido';
        return;
      end if;
    
      if v_ind = 2 then
        if substr(v_ip, -2, 2) = '::' then
          v_ind := 8 - (v_ind - 1);
          v_ip  := substr(v_ip, 1, length(v_ip) - 1);
          v_ips := '';
        
          for v_nro in 1 .. v_ind loop
            if v_nro > 1 then
              v_ips := v_ips || ':0000';
            else
              v_ips := v_ips || '0000';
            end if;
          end loop;
        
          v_ip := v_ip || v_ips;
        
        else        
          if substr(v_ip, 1, 2) = '::' then
            v_ind := 8 - (v_ind - 1);
            v_ip  := substr(v_ip, 2, length(v_ip) - 1);
          
            for v_nro in 1 .. v_ind loop
              if v_nro > 1 then
                v_ips := v_ips || ':0000';
              else
                v_ips := v_ips || '0000';
              end if;
            end loop;
          
            v_ip := v_ips || v_ip;
          else
            v_ind := 8 - v_ind;
            v_pos := instr(v_ip, '::', 1, 1);
          
            for v_nro in 1 .. v_ind loop
              if v_nro > 1 then
                v_ips := v_ips || ':0000';
              else
                v_ips := v_ips || '0000';
              end if;
            end loop;
          
            v_ip := substr(v_ip, 1, v_pos) || v_ips ||
                    substr(v_ip, - (length(v_ip) - v_pos), length(v_ip) - v_pos);
          end if;
        end if;
      end if;
    end if;

    /*Obtengo bloques de IP*/
    v_pos  := 0;
    v_pos2 := instr(v_ip, ':', 1, 1);

    if v_pos2 = 0 then
      v_pos2 := length(v_ip) + 1;
    end if;

    if v_pos = v_pos2 then
      k_res := 'Formato de IP Inválido';
      return;
    else
      k_1 := substr(v_ip, v_pos + 1, v_pos2 - v_pos - 1);
      if length(K_1) > 4 then
        k_res := 'El tamaño del primer bloque excede los 4 caracteres permitidos';
      else
        if k_1 is null then
          k_1 := '%%';
        else
          k_1 := '0000' || k_1;
          k_1 := substr(k_1, -4, 4);
          v_0 := translate(upper(k_1), '0123456789ABCDEF', '................');
          if V_0 != '....' then
            k_res := 'Formato de Hexadecimal Inválido en Primer Bloque';
            k_1   := v_0;
            return;
           end if;
        end if;
      end if;
    end if;

    v_pos  := v_pos2;
    v_pos2 := instr(v_ip, ':', 1, 2);

    if v_pos2 = 0 then
      v_pos2 := length(v_ip) + 1;
    end if;
    if v_pos = v_pos2 then
      k_2 := '%%';
    else
      k_2 := substr(v_ip, v_pos + 1, v_pos2 - v_pos - 1);
      if length(k_2) > 4 then
        k_res := 'El tamaño del segundo bloque excede los 4 caracteres permitidos';
        return;
      else
        if k_2 is null then
          k_2 := '%%';
        else
          k_2 := '0000' || k_2;
          k_2 := substr(k_2, -4, 4);
          v_0 := translate(upper(k_2), '0123456789ABCDEF', '................');
          if v_0 != '....' then
            k_res := 'Formato de Hexadecimal Inválido en Segundo Bloque';
             return;
          end if;
        end if;
      end if;
    end if;

    v_pos  := v_pos2;
    v_pos2 := instr(v_ip, ':', 1, 3);

    if v_pos2 = 0 then
      v_pos2 := length(v_ip) + 1;
    end if;

    if v_pos = v_pos2 then
      k_3 := '%%';
    else
      k_3 := substr(v_ip, v_pos + 1, v_pos2 - v_pos - 1);
    
      if length(k_3) > 4 then
        k_res := 'El tamaño del tercer bloque excede los 4 caracteres permitidos';
        return;
      else
        if k_3 is null then
          k_3 := '%%';
        else
          k_3 := '0000' || k_3;
          k_3 := substr(k_3, -4, 4);
          v_0 := translate(upper(k_3), '0123456789ABCDEF', '................');
          if v_0 != '....' then
            k_res := 'Formato de Hexadecimal Inválido en tercer Bloque';
            k_3   := v_0;
            return;
          end if;
        end if;
      end if;
    end if;

    v_pos  := v_pos2;
    v_pos2 := instr(v_ip, ':', 1, 4);

    if v_pos2 = 0 then
      v_pos2 := length(v_ip) + 1;
    end if;
    if v_pos = v_pos2 then
      k_4 := '%%';
    else
      k_4 := substr(v_ip, v_pos + 1, v_pos2 - v_pos - 1);
    
      if length(k_4) > 4 then
        k_res := 'El tamaño del cuarto bloque excede los 4 caracteres permitidos';
        return;
      else
        if k_4 is null then
          k_4 := '%%';
        else
          k_4 := '0000' || k_4;
          k_4 := substr(k_4, -4, 4);
          v_0 := translate(upper(k_4), '0123456789ABCDEF', '................');
          if v_0 != '....' then
            k_res := 'Formato de Hexadecimal Inválido en cuarto Bloque';
            k_4   := v_0;
            return;
          end if;
        end if;
      end if;
    end if;

    v_pos  := v_pos2;
    v_pos2 := instr(v_ip, ':', 1, 5);

    if v_pos2 = 0 then
      v_pos2 := length(v_ip) + 1;
    end if;
    if v_pos = v_pos2 then
      k_5 := '%%';
    else
      k_5 := substr(v_ip, v_pos + 1, v_pos2 - v_pos - 1);
      if length(k_5) > 4 then
        k_res := 'El tamaño del quinto bloque excede los 4 caracteres permitidos';
        return;
      else
        if k_5 is null then
          k_5 := '%%';
        else
          k_5 := '0000' || k_5;
          k_5 := substr(k_5, -4, 4);
          v_0 := translate(upper(k_5), '0123456789ABCDEF', '................');
          if v_0 != '....' then
            k_res := 'Formato de Hexadecimal Inválido en quinto Bloque';
            k_5   := v_0;
            return;
          end if;
        end if;
      end if;
    end if;

    v_pos  := v_pos2;
    v_pos2 := instr(v_ip, ':', 1, 6);

    if v_pos2 = 0 then
      v_pos2 := length(v_ip) + 1;
    end if;
    if v_pos = v_pos2 then
      k_6 := '%%';
    else
      k_6 := substr(v_ip, v_pos + 1, v_pos2 - v_pos - 1);
    
      if length(k_6) > 4 then
        k_res := 'El tamaño del sexto bloque excede los 4 caracteres permitidos';
        return;
      else
        if k_6 is null then
          k_6 := '%%';
        else
          k_6 := '0000' || k_6;
          k_6 := substr(k_6, -4, 4);
          v_0 := translate(upper(k_6), '0123456789ABCDEF', '................');
          if v_0 != '....' then
            k_res := 'Formato de Hexadecimal Inválido en sexto Bloque';
            k_6   := v_0;
            return;
          end if;
        end if;
      end if;
    end if;

    v_pos  := v_pos2;
    v_pos2 := instr(v_ip, ':', 1, 7);

    if v_pos2 = 0 then
      v_pos2 := length(v_ip) + 1;
    end if;

    if v_pos = v_pos2 then
      k_7 := '%%';
    else
      k_7 := substr(v_ip, v_pos + 1, v_pos2 - v_pos - 1);
    
      if length(k_7) > 4 then
        k_res := 'El tamaño del septimo bloque excede los 4 caracteres permitidos';
        return;
      else
        if k_7 is null then
          k_7 := '%%';
        else
          k_7 := '0000' || k_7;
          k_7 := substr(k_7, -4, 4);
          v_0 := translate(upper(k_7), '0123456789ABCDEF', '................');
          if v_0 != '....' then
            k_res := 'Formato de Hexadecimal Inválido en septimo Bloque';
            k_7   := v_0;
            return;
          end if;
        end if;
      end if;
    end if;

    v_pos2 := instr(v_ip, ':', 1, 7);

    if v_pos2 <> 0 then
      v_pos := instr(v_ip, ':', -1, 1);
      k_8   := substr(v_ip, v_pos + 1);
    else
      k_8 := null;
    end if;

    if length(k_8) > 4 then
      k_res := 'El tamaño del octavo bloque excede los 4 caracteres permitidos';
      return;
    else
      if k_8 is null then
        k_8 := '%%';
      else
        k_8 := '0000' || k_8;
        k_8 := substr(k_8, -4, 4);
        v_0 := translate(upper(k_8), '0123456789ABCDEF', '................');
        if v_0 != '....' then
          k_res := 'Formato de Hexadecimal Inválido en octavo Bloque';
          return;
        end if;
      end if;
    end if;

    k_res := '0';

  end;
  --------------------------------------------------------------------------------
  procedure sgasu_upd_clasec_ip6(k_idclase number,
                                 k_estado  varchar2,
                                 k_rango   number) is
    /*
    ****************************************************************
    * Nombre SP         : SGASU_UPD_CLASEC_IP6
    * Propósito         : Actualiza los Estados de IP WAN (Stand By y Libre)
    * Input             : k_idclase --> ID del IP WAN
                          k_estado  --> Estado a Actualizar (S:Stand By, L:libre)
                          k_rango   --> Rango del Cliente al que se Asocia IP.
    * Output            : 
    * Creado por        : 
    * Fec Creación      : 28/11/2017
    * Fec Actualización : N/A
    ****************************************************************
    */
    v_rango    number;
    c_idpadre  number;
    c_idpadre2 number;
    c_count    number;
    c_clasec   varchar(40);
    c_estado   varchar(2);
    
  begin    
    select ipc6n_id_padre
      into c_idpadre
      from trafficview.sgat_ipxclasec6
     where ipc6n_id = k_idclase;
    
    select ipc6n_id_padre
      into c_idpadre2
      from trafficview.sgat_ipxclasec6
     where ipc6n_id = c_idpadre;
    
    if k_estado = 'S' then
      v_rango := k_rango;
      
      update trafficview.sgat_ipxclasec6
         set ipc6v_estado = k_estado, ipc6n_idrango = v_rango
       where ipc6n_id = k_idclase;
      
      select count(1)
        into c_count
        from trafficview.sgat_ipxclasec6
       where ipc6n_id_padre = c_idpadre
         and ipc6v_estado = 'L';
      
      if c_count = 0 then
        update trafficview.sgat_ipxclasec6
           set ipc6v_estado = 'T'
         where ipc6n_id = c_idpadre;
        
        update trafficview.sgat_ipxclasec6
           set ipc6v_estado = 'T'
         where ipc6n_id = c_idpadre2;
      else        
        update trafficview.sgat_ipxclasec6
           set ipc6v_estado = 'P'
         where ipc6n_id = c_idpadre;
        
        update trafficview.sgat_ipxclasec6
           set ipc6v_estado = 'P'
         where ipc6n_id = c_idpadre2;        
      end if;
    else      
      v_rango := null;
      
      update trafficview.sgat_ipxclasec6
         set ipc6v_estado = k_estado, ipc6n_idrango = v_rango
       where ipc6n_id = k_idclase
         and ipc6v_estado = 'S';
      
      select count(1)
        into c_count
        from trafficview.sgat_ipxclasec6
       where ipc6n_id_padre = c_idpadre
         and ipc6v_estado <> 'L';
      
      if C_COUNT = 0 then        
        update trafficview.sgat_ipxclasec6
           set ipc6v_estado = 'L'
         where IPC6N_ID = C_IDPADRE;
        
        update trafficview.sgat_ipxclasec6
           set ipc6v_estado = 'L'
         where ipc6n_id = c_idpadre2;        
      else
        update trafficview.sgat_ipxclasec6
           set ipc6v_estado = 'P'
         where ipc6n_id = c_idpadre;
        
        update trafficview.sgat_ipxclasec6
           set ipc6v_estado = 'P'
         where IPC6N_ID = c_idpadre2;        
      end if;
    end if;
    
    select clas.clc6v_clasec, ipx.ipc6v_estado
      into c_clasec, c_estado
      from trafficview.sgat_clasec6 clas
      join trafficview.sgat_ipxclasec6 ipx
        on clas.clc6v_clasec = ipx.ipc6v_clasec
       and clas.clc6n_prefijo = ipx.ipc6n_prefijo
     where ipx.ipc6n_id = c_idpadre2
       and ipx.ipc6c_tipo = 'W';
    
    if c_estado = 'P' then
      update trafficview.sgat_clasec6
         set clc6n_estado = 1
       where clc6v_clasec = c_clasec;      
    else
      if c_estado = 'T' then        
        update trafficview.sgat_clasec6
           set clc6n_estado = 2
         where clc6v_clasec = c_clasec;        
      else
        update trafficview.sgat_clasec6
           set clc6n_estado = 0
         where clc6v_clasec = c_clasec;
      end if;
    end if;    
  end;
  --------------------------------------------------------------------------------
  function sgasfun_ponerdospuntos(k_ipv6 varchar2) return char is
    /*
    ****************************************************************
    * Nombre FUN        : SGASFUN_PONERDOSPUNTOS
    * Propósito         : Poner dos puntos
    * Input             : k_ipv6 --> IPV6
    * Output            : 
    * Creado por        : 
    * Fec Creación      : 28/11/2017
    * Fec Actualización : N/A
    ****************************************************************
    */
    v_retorno varchar(40);
    
  begin
    select substr(k_ipv6, 1, 4) || ':' || substr(k_ipv6, 5, 4) || ':' ||
           substr(k_ipv6, 9, 4) || ':' || substr(k_ipv6, 13, 4) || ':' ||
           substr(k_ipv6, 17, 4) || ':' || substr(k_ipv6, 21, 4) || ':' ||
           substr(k_ipv6, 25, 4) || ':' || substr(k_ipv6, 29, 4)
      into v_retorno
      from dual;
    
    return v_retorno;
  end;
  --------------------------------------------------------------------------------  
  function sgasfun_buscadenapuntos(k_ipv6 varchar2) return char is
    /*
    ****************************************************************
    * Nombre FUN        : SGASFUN_BUSCADENAPUNTOS
    * Propósito         : Buscar Cadena
    * Input             : k_ipv6 --> IPV6
    * Output            : 
    * Creado por        : 
    * Fec Creación      : 28/11/2017
    * Fec Actualización : N/A
    ****************************************************************
    */
    v_retorno     varchar(40);
    v_long_cadena number;
    v_i           integer;
    v_dato        varchar2(10);
    v_completa    integer;
  
  begin
    v_long_cadena := length(k_ipv6);
    v_i           := 1;
  
    while v_i <= v_long_cadena loop
      v_dato := substr(k_ipv6, v_i, 4);
    
      if v_i = 29 then
        if length(v_dato) = 4 then
          v_dato := v_dato;
        else
          v_dato := v_dato || '%';
        end if;
        v_completa := 1;
      else
        if length(v_dato) = 4 then
          v_dato := v_dato || ':';
        else
          v_dato := v_dato;
        end if;
        v_completa := 0;
      end if;
    
      v_retorno := v_retorno || v_dato;
    
      v_i := v_i + 4;
    end loop;
  
    if v_completa = 0 then
      v_retorno := v_retorno || '%';
    end if;
  
    return v_retorno;
  end;
  --------------------------------------------------------------------------------
  function sgasfun_lan_incremento_sub_red(k_mascara_ingre_usua number,
                                          k_ipv6               varchar2,
                                          k_posicion_fija      number)
    return number is
    /*
    ****************************************************************
    * Nombre FUN        : SGASFUN_LAN_INCREMENTO_SUB_RED
    * Propósito         : Incrementar Sub Redes Lan
    * Input             : k_mascara_ingre_usua --> Mascara Ingreso
                          k_ipv6               --> IPV6
    * Output            : 
    * Creado por        : 
    * Fec Creación      : 28/11/2017
    * Fec Actualización : N/A
    ****************************************************************
    */
    v_incremento_en_decimal       number;
    v_letra_binario               char(4);
    v_letra_hexadecimal           char(1);
    v_parte_binaria_fija_4        char(4);
    v_posicion_semi_variable      number; --semi variable, en binario existe una parte es fija y otra variable
    v_letra_inicial_dec           number; --contiene el valor decimal de la letra a analizar ej. 'c'
    v_binario_ini_4_comple_ceros  char(4); --valor binario inicial a cuatro bit completado con ceros a la derecha la parte variable
    v_mascara_en_parte_fija_4_bit number;
    v_rango_a_dividir_en_decimal  number;
    
  begin
    v_posicion_semi_variable := k_posicion_fija + 1;
    v_letra_hexadecimal      := substr(k_ipv6, v_posicion_semi_variable, 1);
    case v_letra_hexadecimal
      when '0' then
        v_letra_binario := '0000';
      when '1' then
        v_letra_binario := '0001';
      when '2' then
        v_letra_binario := '0010';
      when '3' then
        v_letra_binario := '0011';
      when '4' then
        v_letra_binario := '0100';
      when '5' then
        v_letra_binario := '0101';
      when '6' then
        v_letra_binario := '0110';
      when '7' then
        v_letra_binario := '0111';
      when '8' then
        v_letra_binario := '1000';
      when '9' then
        v_letra_binario := '1001';
      when 'A' then
        v_letra_binario := '1010';
      when 'B' then
        v_letra_binario := '1011';
      when 'C' then
        v_letra_binario := '1100';
      when 'D' then
        v_letra_binario := '1101';
      when 'E' then
        v_letra_binario := '1110';
      when 'F' then
        v_letra_binario := '1111';
    end case;
  
    v_mascara_en_parte_fija_4_bit := mod(k_mascara_ingre_usua, 4);
    v_parte_binaria_fija_4        := substr(v_letra_binario,
                                            1,
                                            v_mascara_en_parte_fija_4_bit);
    v_binario_ini_4_comple_ceros  := rpad(trim(v_parte_binaria_fija_4), 4, '0'); --autocompletar con '0' hasta que sea de 4 digitos
  
    select bin_to_num(to_number(substr(v_binario_ini_4_comple_ceros, 1, 1), '9'),
                      to_number(substr(v_binario_ini_4_comple_ceros, 2, 1), '9'),
                      to_number(substr(v_binario_ini_4_comple_ceros, 3, 1), '9'),
                      to_number(substr(v_binario_ini_4_comple_ceros, 4, 1), '9'))
      into v_letra_inicial_dec
      from dual;
  
    v_rango_a_dividir_en_decimal := 16 - v_letra_inicial_dec;
  
    v_incremento_en_decimal := v_rango_a_dividir_en_decimal /
                               sgasfun_lan_num_rangos_genera(k_mascara_ingre_usua);
  
    return v_incremento_en_decimal;
  end;
  --------------------------------------------------------------------------------
  function sgasfun_siguiente_multiplo_4(k_numero number) return integer is
    /*
    ****************************************************************
    * Nombre FUN        : SGASFUN_SIGUIENTE_MULTIPLO_4
    * Propósito         : Siguiente Multiplo
    * Input             : k_numero --> Numero
    * Output            : 
    * Creado por        : 
    * Fec Creación      : 28/11/2017
    * Fec Actualización : N/A
    ****************************************************************
    */
    v_retorno integer;
  
  begin
    if mod(k_numero, 4) = 0 then
      v_retorno := k_numero + 4;
    else
      v_retorno := k_numero + (4 - mod(k_numero, 4));
    end if;
  
    return v_retorno;
  end;
  --------------------------------------------------------------------------------
  function sgasfun_lan_num_rangos_genera(k_mascara number) return integer is
    /*
    ****************************************************************
    * Nombre FUN        : SGASFUN_LAN_NUM_RANGOS_GENERA
    * Propósito         : Genera numero de rangos
    * Input             : k_mascara --> Mascara
    * Output            : 
    * Creado por        : 
    * Fec Creación      : 28/11/2017
    * Fec Actualización : N/A
    ****************************************************************
    */
    v_retorno integer;
  
  begin
    v_retorno := power(2, (sgasfun_siguiente_multiplo_4(k_mascara) - k_mascara));
  
    return v_retorno;
  end;
  --------------------------------------------------------------------------------
  function sgasfun_lan_letra_sub_red_i(k_num_sub_red        number,
                                       k_mascara_ingre_usua number,
                                       k_ipv6               varchar2,
                                       k_posicion_fija      number)
    return char is
    /*
    ****************************************************************
    * Nombre FUN        : SGASFUN_LAN_LETRA_SUB_RED_I
    * Propósito         : Letra Sub Red Lan
    * Input             : k_num_sub_red        --> Mascara
                          k_mascara_ingre_usua --> Mascara Ingresada
                          k_ipv6               --> Ipv6
                          k_posicion_fija      --> Posicion Fija
    * Output            : 
    * Creado por        : 
    * Fec Creación      : 28/11/2017
    * Fec Actualización : N/A
    ****************************************************************
    */
    v_retorno                     char(1);
    v_letra_binario               char(4);
    v_letra_hexadecimal           char(1);
    v_parte_binaria_fija_4        char(4);
    v_posicion_semi_variable      number; --semi variable porque en binario una parte es fija y otra variable
    v_letra_inicial_dec           number; --contiene el valor decimal de la letra a analizar ej. 'c'
    v_valor_a_retornar_en_decimal number; --equivalente del valor a retornar en decimal
    v_binario_ini_4_comple_ceros  char(4); --valor binario inicial a cuatro bit completado con ceros a la derecha la parte variable
    v_mascara_en_parte_fija_4_bit number;
    v_incremento_en_decimal number;

  begin
    v_posicion_semi_variable := k_posicion_fija + 1;
    v_letra_hexadecimal      := substr(k_ipv6, v_posicion_semi_variable, 1);

    case v_letra_hexadecimal
      when '0' then
        v_letra_binario := '0000';
      when '1' then
        v_letra_binario := '0001';
      when '2' then
        v_letra_binario := '0010';
      when '3' then
        v_letra_binario := '0011';
      when '4' then
        v_letra_binario := '0100';
      when '5' then
        v_letra_binario := '0101';
      when '6' then
        v_letra_binario := '0110';
      when '7' then
        v_letra_binario := '0111';
      when '8' then
        v_letra_binario := '1000';
      when '9' then
        v_letra_binario := '1001';
      when 'A' then
        v_letra_binario := '1010';
      when 'B' then
        v_letra_binario := '1011';
      when 'C' then
        v_letra_binario := '1100';
      when 'D' then
        v_letra_binario := '1101';
      when 'E' then
        v_letra_binario := '1110';
      when 'F' then
        v_letra_binario := '1111';
    end case;

    v_mascara_en_parte_fija_4_bit := mod(k_mascara_ingre_usua, 4);
    v_parte_binaria_fija_4        := substr(v_letra_binario,
                                            1,
                                            v_mascara_en_parte_fija_4_bit);
    v_binario_ini_4_comple_ceros  := rpad(trim(v_parte_binaria_fija_4), 4, '0'); --AUTOCOMPLETAR CON '0' HASTA QUE SEA DE 4 DIGITOS

    select bin_to_num(to_number(substr(v_binario_ini_4_comple_ceros, 1, 1), '9'),
                      to_number(substr(v_binario_ini_4_comple_ceros, 2, 1), '9'),
                      to_number(substr(v_binario_ini_4_comple_ceros, 3, 1), '9'),
                      to_number(substr(v_binario_ini_4_comple_ceros, 4, 1), '9'))
      into v_letra_inicial_dec
      from dual;

    v_incremento_en_decimal := 1;

    v_valor_a_retornar_en_decimal := v_letra_inicial_dec + (v_incremento_en_decimal *
                                     (k_num_sub_red - 1));
    --CONVERTIR V_VALOR_A_RETORNAR_EN_DECIMAL A HEXADECIMAL Y RETORNAR ESTE VALOR
    select trim(to_char(v_valor_a_retornar_en_decimal, 'XXXXXX'))
      into v_retorno
      from dual;

    return v_retorno;
  end;
  --------------------------------------------------------------------------------
  function sgasfun_binario_a_decimal(k_binario char) return integer is
    /*
    ****************************************************************
    * Nombre FUN        : SGASFUN_BINARIO_A_DECIMAL
    * Propósito         : Binario a Decimal
    * Input             : k_binario --> Binario
    * Output            : 
    * Creado por        : 
    * Fec Creación      : 28/11/2017
    * Fec Actualización : N/A
    ****************************************************************
    */
    v_retorno                integer;
    v_longitud               integer;
    v_letra_binaria_numerica integer;
    v_posicion_a_sustraer    integer;
    v_i                      integer;
  
  begin
    v_retorno := 0;
  
    select length(trim(k_binario)) into v_longitud from dual;
  
    for v_i in 1 .. v_longitud loop
      v_posicion_a_sustraer    := v_longitud - (v_i - 1);
      v_letra_binaria_numerica := to_number(substr(k_binario,
                                                   v_posicion_a_sustraer,
                                                   1),
                                            9);
      v_retorno                := v_retorno + v_letra_binaria_numerica *
                                  power(2, (v_i - 1));
    end loop;
  
    return v_retorno;
  end;
  --------------------------------------------------------------------------------
  function sgasfun_lan_posicion_fija32(k_mascara_ingresada_usuario number)
    return integer is
    /*
    ****************************************************************
    * Nombre SP         : SGASFUN_LAN_POSICION_FIJA32
    * Propósito         : Posicion Fija
    * Input             : k_mascara_ingresada_usuario --> Mascara ingresada
    * Output            : 
    * Creado por        : 
    * Fec Creación      : 28/11/2017
    * Fec Actualización : N/A
    ****************************************************************
    */
    v_retorno integer;
  
  begin
    if mod(k_mascara_ingresada_usuario, 4) = 0 then
      v_retorno := k_mascara_ingresada_usuario / 4;
    else
      v_retorno := (k_mascara_ingresada_usuario -
                   mod(k_mascara_ingresada_usuario, 4)) / 4;
    end if;
  
    return v_retorno;
  end;
  --------------------------------------------------------------------------------
  function sgafun_existe_id_padre(k_idrango number)
    return number is
    /*
    ****************************************************************
    * Nombre FUN        : SGAFUN_EXISTE_ID_PADRE
    * Propósito         : Validar si existe el Id Padre
    * Input             : k_idrango --> Id Rango
    * Output            : Cantidad de registro encontrado
    * Creado por        : Freddy Gonzales
    * Fec Creación      : 17/08/2017
    * Fec Actualización : N/A
    ****************************************************************
    */
    v_ip_lan_id_padre number(10);
  
  begin
    select r.ip_lan_id_padre
      into v_ip_lan_id_padre
      from trafficview.rangosip r
     where r.idrango = k_idrango;
  
    if v_ip_lan_id_padre is null or v_ip_lan_id_padre = '' then
      return 0;
    else
      return 1;
    end if;
  
  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit ||
                              '.SGAFUN_EXISTE_ID_PADRE(pi_idrango => ' ||
                              k_idrango || ') ' || sqlerrm);
  end;
  --------------------------------------------------------------------------------
  function sgafun_valida_estado_ips(k_red        varchar2,
                                    k_ipc6c_tipo varchar2)
    return number is
    /*
    ****************************************************************
    * Nombre FUN        : SGAFUN_VALIDA_ESTADO_IPS
    * Propósito         : Validar si existe alguna Red o Sub Red en estado diferente a L (Libre)
    * Input             : k_red        --> Red
                          k_ipc6c_tipo --> Tipo
    * Output            : Cantidad de registro encontrado
    * Creado por        : Freddy Gonzales
    * Fec Creación      : 21/08/2017
    * Fec Actualización : N/A
    ****************************************************************
    */
    v_count pls_integer;
  
  begin
    select count(1)
      into v_count
      from trafficview.sgat_ipxclasec6 c
     where c.ipc6n_id_padre in
           (select c.ipc6n_id
              from trafficview.sgat_ipxclasec6 c,
                   (select tip.ipc6n_id
                      from trafficview.sgat_clasec6    tsc,
                           trafficview.sgat_ipxclasec6 tip
                     where tsc.clc6v_clasec = tip.ipc6v_clasec
                       and tip.ipc6n_id = tip.ipc6n_id_padre
                       and tip.ipc6v_clasec = k_red
                       and tip.ipc6c_tipo = k_ipc6c_tipo) Sgat_clasec6
             where c.ipc6n_id_padre = sgat_clasec6.ipc6n_id)
       and c.ipc6v_estado <> 'L';
  
    if v_count > 0 then
      return 1;
    else
      return 0;
    end if;
  
  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit ||
                              '.SGAFUN_VALIDA_ESTADO_IPS(pi_red => ' || k_red ||
                              ', pi_ipc6c_tipo => ' || k_ipc6c_tipo || ') ' ||
                              sqlerrm);
  end;
  --------------------------------------------------------------------------------
  procedure sgass_elimina_red(k_red        varchar2,
                              k_ipc6c_tipo varchar2) is
    /*
    ****************************************************************
    * Nombre SP          : SGASS_ELIMINA_RED
    * Propósito         : Elimina la Red y su Sub Redes asociadas
    * Input             : k_red        --> Red
                          k_ipc6c_tipo --> Tipo
    * Output            : 
    * Creado por        : Freddy Gonzales
    * Fec Creación      : 21/08/2017
    * Fec Actualización : N/A
    ****************************************************************
    */
  begin
    if k_ipc6c_tipo = 'L' then
    
      delete from trafficview.sgat_ipxclasec6 t
       where t.ipc6n_id_padre in
             (select t.ipc6n_id
                from trafficview.sgat_ipxclasec6 t
               where t.ipc6n_id_padre in
                     (select t.ipc6n_id
                        from trafficview.sgat_ipxclasec6 t
                       where t.ipc6n_id_padre in
                             (select t.ipc6n_id
                                from trafficview.sgat_ipxclasec6 t
                               where t.ipc6n_id_padre in
                                     (select t.ipc6n_id
                                        from trafficview.sgat_ipxclasec6 t
                                       where t.ipc6n_id_padre =
                                             (select t.ipc6n_id
                                                from trafficview.sgat_ipxclasec6 t
                                               where t.ipc6v_clasec = k_red
                                                 and t.ipc6c_tipo = k_ipc6c_tipo
                                                 and t.ipc6n_id = t.ipc6n_id_padre)
                                         and t.ipc6n_id <> t.ipc6n_id_padre))));
    
      delete from trafficview.sgat_ipxclasec6 t
       where t.ipc6n_id_padre in
             (select t.ipc6n_id
                from trafficview.sgat_ipxclasec6 t
               where t.ipc6n_id_padre in
                     (select t.ipc6n_id
                        from trafficview.sgat_ipxclasec6 t
                       where t.ipc6n_id_padre in
                             (select t.ipc6n_id
                                from trafficview.sgat_ipxclasec6 t
                               where t.ipc6n_id_padre =
                                     (select t.ipc6n_id
                                        from trafficview.sgat_ipxclasec6 t
                                       where t.ipc6v_clasec = k_red
                                         and t.ipc6c_tipo = k_ipc6c_tipo
                                         and t.ipc6n_id = t.ipc6n_id_padre)
                                 and t.ipc6n_id <> t.ipc6n_id_padre)));
    
      delete from trafficview.sgat_ipxclasec6 t
       where t.ipc6n_id_padre in
             (select t.ipc6n_id
                from trafficview.sgat_ipxclasec6 t
               where t.ipc6n_id_padre in
                     (select t.ipc6n_id
                        from trafficview.sgat_ipxclasec6 t
                       where t.ipc6n_id_padre =
                             (select t.ipc6n_id
                                from trafficview.sgat_ipxclasec6 t
                               where t.ipc6v_clasec = k_red
                                 and t.ipc6c_tipo = k_ipc6c_tipo
                                 and t.ipc6n_id = t.ipc6n_id_padre)
                         and t.ipc6n_id <> t.ipc6n_id_padre));
    
      delete from trafficview.sgat_ipxclasec6 t
       where t.ipc6n_id_padre in
             (select t.ipc6n_id
                from trafficview.sgat_ipxclasec6 t
               where t.ipc6n_id_padre =
                     (select t.ipc6n_id
                        from trafficview.sgat_ipxclasec6 t
                       where t.ipc6v_clasec = k_red
                         and t.ipc6c_tipo = k_ipc6c_tipo
                         and t.ipc6n_id = t.ipc6n_id_padre)
                 and t.ipc6n_id <> t.ipc6n_id_padre);
    
      delete from trafficview.sgat_ipxclasec6 t
       where t.ipc6n_id_padre =
             (select t.ipc6n_id
                from trafficview.sgat_ipxclasec6 t
               where t.ipc6v_clasec = k_red
                 and t.ipc6c_tipo = k_ipc6c_tipo
                 and t.ipc6n_id = t.ipc6n_id_padre)
         and t.ipc6n_id <> t.ipc6n_id_padre;
    
      delete from trafficview.sgat_ipxclasec6 t
       where t.ipc6n_id = (select t.ipc6n_id
                             from trafficview.sgat_ipxclasec6 t
                            where t.ipc6v_clasec = k_red
                              and t.ipc6c_tipo = k_ipc6c_tipo
                              and t.ipc6n_id = t.ipc6n_id_padre);
    
      delete from trafficview.sgat_ipxclasec6 t
       where t.ipc6v_clasec = k_red
         and t.ipc6c_tipo = k_ipc6c_tipo;
    
    else
      delete from trafficview.sgat_ipxclasec6 c
       where c.ipc6n_id_padre in
             (select c.ipc6n_id
                from trafficview.sgat_ipxclasec6 c,
                     (select tip.ipc6n_id
                        from trafficview.sgat_clasec6    tsc,
                             trafficview.sgat_ipxclasec6 tip
                       where tsc.clc6v_clasec = tip.ipc6v_clasec
                         and tip.ipc6n_id = tip.ipc6n_id_padre
                         and tip.ipc6v_clasec = k_red
                         and tip.ipc6c_tipo = k_ipc6c_tipo) Sgat_clasec6
               where c.ipc6n_id_padre = sgat_clasec6.ipc6n_id);
    end if;
  
    delete from trafficview.sgat_clasec6 c where c.clc6v_clasec = k_red;
  
  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit || '.SGASS_ELIMINA_RED(k_red => ' ||
                              k_red || ', k_ipc6c_tipo => ' || k_ipc6c_tipo || ') ' ||
                              sqlerrm);
  end;
  --------------------------------------------------------------------------------
END PKG_IP6;
/
