create or replace package body operacion.pq_dth as
  /**************************************************************
  NOMBRE:     PQ_DTH
  PROPOSITO:  Realiza las activaciones, cortes, reconexiones del servicio de cable satelital.

  PROGRAMADO EN JOB:  NO

  REVISIONES:
     Ver        Fecha        Autor           Solicitado por    Descripcion
  ---------  ----------  ---------------  --------------    ----------
  2.0        12/03/2009  Joseph Asencios                    REQ-84614 Se creó el procedimiento p_reconexion_adic_dth
                                                            para que realice el envio de bouquets adicionales.
                                                            REQ-84619 Se modificó el procedimiento p_corte_dth para que envie
                                                            al Conax a desactivar los bouquets adicionales.
                                                            REQ-84608 Se modificó el procedimiento p_crear_archivo_conax
                                                            para que contemple el envio de bouquets adicionales
                                                            para ventas que hayan elegido bouquets adicionales.
                                                            REQ-84620 Se modificó el procedimiento p_baja_serviciodthxcliente
                                                            para que contemple el envio de solicitud de corte de señal de los
                                                            bouquets adicionales para el proceso de baja definitiva.
  3.0        10/08/2009  Hector Huaman M.                   REQ-99646: se comento la condicion de la recarga(se evaluara en el trigger)
  4.0        18/08/2009  Joseph Asencios                    REQ-99155: Se agregó las funciones F_GENERA_CODIGO_RECARGA y F_VALIDA_CODIGO_RECARGA
  5.0        02/09/2009  Joseph Asencios                    REQ-100186: Reestructuración de procedimientos para seguir los flujos definidos.
  6.0        24/09/2009  Joseph Asencios                    REQ-102462: Se creó la función f_get_clave_dth.
  7.0        16/10/2009  Jimmy Farfán                       REQ-104367: Se modificó el formato de fechas de envío.
  8.0        30/12/2009  José  Robles                       REQ-113186: Corregir proceso de Conciliacion Interconexion del BCP
  9.0        03/02/2010  Antonio Lagos                      REQ-106908 DTH+CDMA,uso de nuevas estructuras en vez de reginsdth,
                                                            sincronizado con cambio de plan
  10.0       24/03/2010  Antonio Lagos                      REQ-119998 DTH+CDMA,actualizacion de estado en recargaxinssrv
  11.0       19/04/2010  Joseph Asencios                    REQ-106641: Se creó los procedimientos p_carga_msgs_decos, p_pre_cargar_sid, p_carga_archivo_bouquet, p_actualiza_bouquet_masivo y p_envia_mensaje_deco_dth
  12.0       08/06/2010  Antonio Lagos                      REQ-119999 DTH+CDMA,actualizacion de desactivacion y corte de servicio en DTH
                                                            por nuevas estructuras
  13.0       19/06/2010  Antonio Lagos                      REQ-136809:correccion en asignacion de tarjetas
  14.0       13/09/2010  Joseph Asencios                    REQ-142589: Ampliación de campo codigo_ext(Bouquet)
  15.0       15/09/2010  Antonio Lagos                      REQ.142338, Migracion DTH
  16.0       01/30/2010  Antonio Lagos                      REQ.144751, activacion DTH
  17.0       05/10/2010  Antonio Lagos                      REQ.145222, activacion, baja DTH
  18.0       15/10/2010  Joseph Asencios                    REQ-145961: Modificación de función f_valida_codigo_recarga
  19.0       25/11/2010  Yuri Lingán                        REQ-150183: Proy Mejora Promociones DTH
  20.0       17/06/2010  Widmer Quispe    Edilberto Astulle Req: 123054 y 123052 Asignación de plataformas y etiquetas en los cptoxfac
  21.0       14/03/2011  Ronal Corilloclla                  Proy: Suma de Cargos DTH
                                                            Consideramos IDGRUPO y PID para guardarlo en bouquetxreginsdth.
                                                            p_gen_factura_recarga() Modificado
                                                            p_crear_archivo_conax() se depuro logica cuando numslc is null
  22.0       12/07/2011  Widmer Quispe   Jose Ramos         Asiganacion del maximo de instxproducto a las facturas que se generan por recargas
  23.0      16/11/2011   Joseph Asencios  Guillermo Salcedo REQ-161368: Ya no se requiere enviar el archivo de despareo al CONAX.
  24.0      31/01/2012   Keila Carpio     Edilberto Astulle REQ 159864  Problema con registro y activaciones de Tarjetas:
                                                            Ya no se requiere recibir una cadena, sino el idgrupo para selección de Bouquets.
  25.0      24/11/2011   Mauro Zegarra                      Sincronizacion 11/05/2012 - REQ-161199: Validación de equipos
  26.0      18/07/2011   Hector Huaman                      SD-117369 Corregir envio de bouquets
  27.0      11/10/2011   Hector Huaman                      SD-267367 Modificación del procedimiento p_baja_serviciodthxcliente
  28.0      06/11/2012   Carlos Lazarte   Tommy Arakaki     Req: 163468, Corte de señal automática
  29.0      06/12/2012   Alex Alamo       Hector Huaman     SD-380686 Enviar Archivo de Pareo/Despareo
  30.0      22/02/2013   Juan C. Ortiz    Hector Huaman     Req 163947 - Diferencia archivos de señal DTH (SGA)
  31.0      10/04/2013   Hector Huaman                      SD_551325 Mejora en el PPV
  32.0      08/05/2013   Fernando Pacheco Hector Huaman     Req 164271 - Cambio de Directorio Claro TV SAT
  33.0      06/08/2013   Dorian Sucasaca  Arturo Saavedra   Req: 164536 Servicio de TV satelital empresas tiene problemas (67 Funciona, 119 No Funciona).
  34.0      31/10/2013   Carlos Chamache  Guillermo Salcedo Req_164526 - Pareo y Despareo de archivos DTH Prepago
  35.0      01/12/2014   Jorge Armas      Manuel Gallegos   PROY-17565 - Aprovisionamiento DTH Prepago - INTRAWAY
  36.0      04/08/2014   Ronald Ramirez,   Alicia Peña      Req: PROY-14342-IDEA-12729
                         Michael Boza
  37.0      06/03/2015   Angel Condori    Manuel Gallegos   PROY-17565-  Aprovisionamiento DTH Prepago - INTRAWAY
  38.0      24/05/2015  Edilberto Astulle                  SD-307352    Problemas con el SGA
  39.0      30/05/2016   Luis Polo B.     Karen Vasquez     SGA-SD-794552
  40.0    04/01/2018   Jose Arriola    Carlos Lazarte  INC000001017267
  ***********************************************************/
  function f_verifica_condicion_recarga(p_numregistro in varchar2)
    return number is
    ls_result   number;
    ln_cantidad number;
  begin
    ls_result := 0;
    select count(*)
      into ln_cantidad
      from reginsdth r, vtasuccli s
     where r.codsuc = s.codsuc
       and r.codcli = s.codcli
       and s.ubisuc in (select codubi
                          from v_ubicaciones
                         where codpai = 51
                           and codest = 1)
       and r.numregistro = p_numregistro;
    if ln_cantidad > 0 then
      ls_result := 1;
    end if;
    return ls_result;
  end;

  function f_genera_codigo_recarga(p_numregistro   in varchar2,
                                   p_digitoinicial int,
                                   ndigitos        int) return varchar2 is
    ls_codigo_recarga varchar2(15);
    /*lr_reginsdth reginsdth%rowtype;*/
    ln_secuencial number(14);
    ls_tipdoc     char(3);
    ls_numdoc     varchar2(15);
    -- ini 15.0
    ln_tipbqd ope_srv_recarga_cab.tipbqd%type;
    ln_numero numtel.numero%type;
    -- fin 15.0

  begin
    -- ini 15.0
    ln_tipbqd := 0;
    -- fin 15.0

    /*select * into lr_reginsdth from reginsdth where numregistro = p_numregistro; */
   -- Ini 36.0
   if f_valida_estado(p_numregistro) > 0  then
      ls_codigo_recarga := '0';
   else
   -- Fin 36.0
    --<9.0
    begin
      --ini 15.0
      /*select b.tipdide, b.ntdide
          into ls_tipdoc, ls_numdoc
          from reginsdth a, vtatabcli b
         where a.numregistro = p_numregistro
           and a.codcli = b.codcli;
      exception
        when no_data_found then*/
      --fin 15.0
      select b.tipdide,
             b.ntdide
             -- ini 15.0
            ,
             a.tipbqd
      -- fin 15.0
        into ls_tipdoc,
             ls_numdoc
             -- ini 15.0
            ,
             ln_tipbqd
      -- fin 15.0
      --from recargaproyectocliente a, vtatabcli b --11.0
        from ope_srv_recarga_cab a, vtatabcli b --12.0
       where a.numregistro = p_numregistro
         and a.codcli = b.codcli;

      -- ini 15.0
      begin
        select c.numero
          into ln_numero
          from ope_srv_recarga_det a, inssrv b, numtel c
         where a.numregistro = p_numregistro
           and a.tipsrv =
               (select valor from constante where constante = 'FAM_TELEF')
           and a.codinssrv = b.codinssrv
           and b.codinssrv = c.codinssrv;
      exception
        when no_data_found then
          ln_numero := null;
      end;
      -- fin 15.0

    end;
    --9.0>
    -- ini 15.0
    if ln_tipbqd = 4 or ln_tipbqd = 0 then
      -- fin 15.0
      if ls_tipdoc = '002' then
        select f_valida_codigo_recarga(p_numregistro, ls_numdoc, 9, 7)
          into ls_codigo_recarga
          from dummy_ope;
      else
        select operacion.sq_codigo_recarga.nextval
          into ln_secuencial
          from dummy_ope;
        select f_valida_codigo_recarga(p_numregistro,
                                       p_digitoinicial ||
                                       lpad(ln_secuencial, ndigitos, 0),
                                       p_digitoinicial,
                                       ndigitos)
          into ls_codigo_recarga
          from dummy_ope;
      end if;
      -- ini 15.0
    elsif ln_tipbqd = 2 then
      ls_codigo_recarga := ln_numero;
    end if;
    -- fin 15.0
   end if; -- 36.0
    return ls_codigo_recarga;
  end;

  function f_valida_codigo_recarga(p_numregistro    in varchar2,
                                   p_codigo_recarga in varchar2,
                                   p_digitoinicial  int,
                                   ndigitos         int) return varchar2 is
    ls_codigo_recarga varchar2(15);
    ln_flag_existe    number; -- 0:No existe código de recarga, 1:Código de recarga existente
    --ini 15.0
    --ln_Cantidad       number;
    --fin 15.0
    ln_cantidad2  number; --9.0
    ln_num        number; --9.0
    ln_secuencial number(14);
    --lr_reginsdth reginsdth%rowtype; --9.0
    ls_codigo_recarga_ini varchar2(15); --9.0
  begin
    ln_flag_existe    := 1;
    ls_codigo_recarga := p_codigo_recarga;

    --<9.0
    --select * into lr_reginsdth from reginsdth where numregistro = p_numregistro;
    begin
      --ini 15.0
      /*select codigo_recarga
          into ls_codigo_recarga_ini
          from reginsdth
         where numregistro = p_numregistro;
      exception
        when no_data_found then*/
      --fin 15.0
      select codigo_recarga
        into ls_codigo_recarga_ini
      --from recargaproyectocliente --12.0
        from ope_srv_recarga_cab --12.0
       where numregistro = p_numregistro;
    end;
    --9.0>
    while ln_flag_existe = 1 loop
      --ini 15.0
      /*select count(*)
       into ln_Cantidad
       from reginsdth
      where estado not in
            (select codestdth from estregdth where tipoestado = 3)
        and codigo_recarga = ls_codigo_recarga;*/
      --fin 15.0
      --<9.0
      --ini 18.0
      /*select count(*)
        into ln_cantidad2
      --from recargaproyectocliente --12.0
        from ope_srv_recarga_cab --12.0
      --where estado not in --12.0
      --      (select codestdth from estregdth where tipoestado = 3) --12.0
       where estado not in ('04') --12.0
         and codigo_recarga = ls_codigo_recarga;*/

      select count(1)
        into ln_cantidad2
        from ope_srv_recarga_cab a, solot b, estsol c
       where a.codsolot = b.codsolot
         and b.estsol = c.estsol
         and c.tipestsol not in (5, 7)
         and a.estado not in ('04')
         and a.codigo_recarga = ls_codigo_recarga;

      --fin 18.0
      --ini 15.0
      --ln_num := ln_Cantidad + ln_Cantidad2;
      ln_num := ln_cantidad2;
      --fin 15.0
      --if ln_Cantidad > 0 then
      if ln_num > 0 then
        if ls_codigo_recarga_ini is not null then
          --ls_codigo_recarga := lr_reginsdth.codigo_recarga;
          ls_codigo_recarga := ls_codigo_recarga_ini;
          --9.0>
          ln_flag_existe := 0;
        else
          select operacion.sq_codigo_recarga.nextval
            into ln_secuencial
            from dummy_ope;
          ls_codigo_recarga := p_digitoinicial ||
                               lpad(ln_secuencial, ndigitos, 0);
        end if;
      else
        ln_flag_existe := 0;
      end if;
    end loop;
   -- Fin 25.0
    return TRIM(ls_codigo_recarga);
   -- Fin 25.0
  end;
  --<REQ ID=102462>
  function f_get_clave_dth return varchar2 is
    ls_clave   varchar2(10);
    id         number(15);
    idchecksum number(15);
  begin
    select operacion.sq_reginsdth.nextval into id from dummy_ope;
    idchecksum := operacion.pq_lcheck.f_checksum(id);
    ls_clave   := lpad(idchecksum, 10, '0');
    return ls_clave;
  end;
  --</REQ>
  procedure p_crear_archivo_conax(
                                  --<REQ ID=100186 OBSERVACION=SE COMENTA EL USO DE PARAMETROS QUE YA NO VAN A SER USADAS>
                                  /*                          p_idpaq     IN NUMBER,
                                                                                                                                                                    p_fecini    IN VARCHAR2,
                                                                                                                                                                    p_fecfin    IN VARCHAR2,*/
                                  --</REQ>
                                  p_numregistro in varchar2,
                                  --<REQ ID=100186 OBSERVACION=SE COMENTA EL USO DE PARAMETROS QUE YA NO VAN A SER USADAS>
                                  /*                            p_idtarjeta IN VARCHAR2,
                                                                                                                                                                    p_unitaddres IN VARCHAR2,*/
                                  --</REQ>
                                  p_resultado in out varchar2,
                                  p_mensaje   in out varchar2) is

    p_text_io         utl_file.file_type;
    p_nombre          varchar2(15);
    l_cantidad1       number;
    l_numtransacconax number(15);
    s_numconax        varchar2(6);

    parchivolocalenv   varchar2(30);
    --ini 14.0
    /*s_bouquets         VARCHAR2(100);*/
    s_bouquets tystabsrv.codigo_ext%type;
    --fin 14.0
    s_numslc       char(10);
    n_largo        number;
    numbouquets    number;
    canttarjetas   number;
    s_canttarjetas char(6);
    --<REQ ID=100186>
    p_fecini varchar2(12);
    p_fecfin varchar2(12);
  lc_fecfin_rotacion varchar2(12);--38.0
    p_idpaq  number;
    -- Ini 29.0
    ln_pareo     number;
    ln_despareo  number;
    l_solot_deco number; --34.0
    ls_resultado varchar2(5);
    ls_mensaje   varchar2(6000);
    error_asociado exception;
    -- Fin 29.0
    ln_obt_tp number; --30.0
    --</REQ>
    --ini 17.0
    ln_codsolot solot.codsolot%type;
    connex_i    operacion.conex_intraway; --37.0
    ln_deco_adicional NUMBER; --39.0
    l_numregistro     VARCHAR2(30); --39.0
    l_numslc          VARCHAR2(10); --39.0
    --fin 17.0
    --21.0 Comentamos cursor q no se usa c_codigo_ext
    --Cursor de Codigos Externos(Códigos de Bouquets) de la Configuración del paquete.
    /*cursor c_codigo_ext is
    select distinct tystabsrv.codigo_ext, tystabsrv.codsrv
      from paquete_venta,
           detalle_paquete,
           linea_paquete,
           producto,
           tystabsrv
     where paquete_venta.idpaq = p_idpaq
       and paquete_venta.idpaq = detalle_paquete.idpaq
       and detalle_paquete.iddet = linea_paquete.iddet
       and detalle_paquete.idproducto = producto.idproducto
       and detalle_paquete.flgestado = 1
       and linea_paquete.flgestado = 1
       and producto.tipsrv = '0062'
       and --cable
           linea_paquete.codsrv = tystabsrv.codsrv
       and tystabsrv.codigo_ext is not null;*/

    --<En proceso REQ 84608>
    --Cursor de Codigos Externos: Tipo de Venta Normal(Proyecto Generado)
    --Servicio Principal
    cursor c_codigos_ext_ventas_princ is
    --21.0: select t.codigo_ext, t.codsrv, 'PRINCIPAL' clase /*19.0: Se agrega Clase*/
      select trim(PQ_OPE_BOUQUET.F_CONCA_BOUQUET_C(R.IDGRUPO)) codigo_ext,
             r.idgrupo,
             PQ_VTA_PAQUETE_RECARGA.F_GET_PID(p_numregistro, V.IDDET) PID,
             t.codsrv,
             'PRINCIPAL' clase /*19.0: Se agrega Clase*/
        from vtadetptoenl v, tystabsrv t, tys_tabsrvxbouquet_rel r
       where v.numslc = s_numslc
         and v.flgsrv_pri = 1
         and v.codsrv = t.codsrv
         and t.codsrv = r.codsrv
         and r.estbou = 1
         and r.stsrvb = 1
      -- ini 19.0
      -- Cursor de Bouquets promocionales
      union all
      select distinct b.descripcion,
                      gb.idgrupo,
                      null pid,
                      pv.codsrv,
                      'PROMOCION' clase
        from fac_prom_detalle_venta_mae pv,
             ope_grupo_bouquet_det      gb,
             ope_bouquet_mae            b
       where pv.numslc = s_numslc
         and pv.idgrupo = gb.idgrupo
         and gb.codbouquet = b.codbouquet
         and gb.flg_activo = 1
         and b.flg_activo = 1
         and b.descripcion is not null;
    -- fin 19.0

  --<ini 39.0>
    CURSOR c_bouquet_princ_deco_adicional IS

      SELECT TRIM(pq_ope_bouquet.f_conca_bouquet_c(r.idgrupo)) codigo_ext,
             r.idgrupo,
             pq_vta_paquete_recarga.f_get_pid(l_numregistro, v.iddet) pid,
             t.codsrv,
             'PRINCIPAL' clase
        FROM vtadetptoenl v, tystabsrv t, tys_tabsrvxbouquet_rel r
       WHERE v.numslc = l_numslc
         AND v.flgsrv_pri = 1
         AND v.codsrv = t.codsrv
         AND t.codsrv = r.codsrv
         AND r.estbou = 1
         AND r.stsrvb = 1

      -- Cursor de Bouquets promocionales
      UNION ALL
      SELECT DISTINCT b.descripcion,
                      gb.idgrupo,
                      NULL pid,
                      pv.codsrv,
                      'PROMOCION' clase
        FROM fac_prom_detalle_venta_mae pv,
             ope_grupo_bouquet_det      gb,
             ope_bouquet_mae            b
       WHERE pv.numslc = l_numslc
         AND pv.idgrupo = gb.idgrupo
         AND gb.codbouquet = b.codbouquet
         AND gb.flg_activo = 1
         AND b.flg_activo = 1
         AND b.descripcion IS NOT NULL;

    CURSOR c_bouquet_adic_deco_adicional IS
      SELECT TRIM(pq_ope_bouquet.f_conca_bouquet_c(r.idgrupo)) codigo_ext,
             r.idgrupo,
             pq_vta_paquete_recarga.f_get_pid(l_numregistro, v.iddet) pid,
             t.codsrv,
             pq_vta_paquete_recarga.f_is_cnr(s_numslc, v.iddet) flg_cnr
        FROM vtadetptoenl v, tystabsrv t, tys_tabsrvxbouquet_rel r
       WHERE v.numslc = l_numslc
         AND v.flgsrv_pri = 0
         AND v.codsrv = t.codsrv
         AND t.codsrv = r.codsrv
         AND r.estbou = 1
         AND r.stsrvb = 1;
    --<fin 39.0>

    --Servicios Adicionales
    --21.0:  Consideramos tabla TYS_TABSRVBOUQUET_REL
    --       Agregamos 3 campos IDGRUPO, PID
    cursor c_codigos_ext_ventas_adic is
      select TRIM(PQ_OPE_BOUQUET.F_CONCA_BOUQUET_C(R.IDGRUPO)) codigo_ext,
             r.idgrupo,
             PQ_VTA_PAQUETE_RECARGA.F_GET_PID(p_numregistro, V.IDDET) PID,
             t.codsrv,
             PQ_VTA_PAQUETE_RECARGA.F_IS_CNR(s_numslc, V.IDDET) FLG_CNR
        from vtadetptoenl v, tystabsrv t, tys_tabsrvxbouquet_rel r
       where v.numslc = s_numslc
         and v.flgsrv_pri = 0
         and v.codsrv = t.codsrv
         and t.codsrv = r.codsrv
         and r.estbou = 1
         and r.stsrvb = 1;

    --Cursor de Codigos Externos: Tipo de Venta Puerta a Puerta
    --Servicio Principal
    --21.0:  Comentamos cursores c_codigo_ext_puerta_princ y c_codigo_ext_puerta_adic
    /*cursor c_codigo_ext_puerta_princ is
      select distinct tystabsrv.codigo_ext,
                      tystabsrv.codsrv,
                      detalle_paquete.flgprincipal
        from paquete_venta,
             detalle_paquete,
             linea_paquete,
             producto,
             tystabsrv
       where paquete_venta.idpaq = p_idpaq
         and paquete_venta.idpaq = detalle_paquete.idpaq
         and detalle_paquete.iddet = linea_paquete.iddet
         and detalle_paquete.idproducto = producto.idproducto
         and detalle_paquete.flgestado = 1
         and linea_paquete.flgestado = 1
         and detalle_paquete.flg_opcional = 0
         and producto.tipsrv = '0062'
         and --cable
             linea_paquete.codsrv = tystabsrv.codsrv
         and tystabsrv.codigo_ext is not null;

    --Servicios Adicionales
    cursor c_codigo_ext_puerta_adic is
      select r.codsrv, t.codigo_ext
        from reg_serv_adi_dth r, tystabsrv t
       where r.codsrv = t.codsrv
         and r.numregistro = p_numregistro;
    */
    --</En proceso REQ 84608>

    --cursor de series de tarjetas
    cursor c_tarjetas is
    --ini 17.0
    /*select serie
            from operacion.equiposdth
           where numregistro = p_numregistro
             and grupoequ = 1
           order by serie;*/
      select numserie serie
        from solotptoequ
       where codsolot = ln_codsolot
         and tipequ in (select a.codigon tipequope
                          from opedd a, tipopedd b
                         where a.tipopedd = b.tipopedd
                           and b.abrev = 'TIPEQU_DTH_CONAX'
                           and codigoc = '1') --tarjeta
       order by numserie;
    --fin 17.0
    --cursor de unitaddress de decodificadores

    cursor c_unitaddress is
    --ini 17.0
    /*select unitaddress
            from operacion.equiposdth
           where numregistro = p_numregistro
             and grupoequ = 2
           order by unitaddress;*/

      select mac unitaddress
        from solotptoequ
       where codsolot = ln_codsolot
         and tipequ in (select a.codigon tipequope
                          from opedd a, tipopedd b
                         where a.tipopedd = b.tipopedd
                           and b.abrev = 'TIPEQU_DTH_CONAX'
                           and codigoc = '2') --deco
       order by mac;
    --fin 17.0
    s_codext  varchar2(8);
    ln_is_cnr number; --21.0 Vendido como Cargo No Recurrente
    ln_tipo   number; --21.0
  begin
    connex_i    := operacion.pq_dth.f_crea_conexion_intraway; --37.0

    p_resultado := 'OK';

    --<REQ ID=100186>
    --<7.0 REQ-104367>
    select to_char(trunc(new_time(sysdate, 'EST', 'GMT'), 'MM'), 'yyyymmdd') ||
           '0000'
      into p_fecini
      from dummy_ope;
--ini 38.0
   /* select to_char(trunc(last_day(new_time(sysdate, 'EST', 'GMT'))),
                   'yyyymmdd') || '0000'
      into p_fecfin
      from dummy_ope;*/

     select TO_CHAR(c.Valor)
  INTO lc_fecfin_rotacion

  from constante c WHERE C.CONSTANTE='DTHROTACION';

   select
    to_char(trunc(new_time(lc_fecfin_rotacion, 'EST', 'GMT')),
                         'yyyymmdd') || '0000' into p_fecfin from dual;


  if(to_char(trunc(sysdate), 'DD/MM/YYYY')=lc_fecfin_rotacion) then
    select add_months(lc_fecfin_rotacion,12)
    into lc_fecfin_rotacion from dual;

    update constante set valor=lc_fecfin_rotacion
    WHERE CONSTANTE='DTHROTACION';
    commit;

   select
    to_char(trunc(new_time(lc_fecfin_rotacion, 'EST', 'GMT')),
                         'yyyymmdd') || '0000' into p_fecfin from dual;

  end if;--fin 38.0

    --</7.0 REQ-104367>
    --</REQ>

    --<En proceso REQ 84608>
    --ini 17.0
    /*select numslc, idpaq
    into s_numslc, p_idpaq
    from reginsdth*/
    select numslc, idpaq, codsolot
      into s_numslc, p_idpaq, ln_codsolot
      from ope_srv_recarga_cab
    --fin 17.0
     where numregistro = p_numregistro; -- REQ 100186: Se agregó el IDPAQ

    delete operacion.bouquetxreginsdth where numregistro = p_numregistro;
    --</En proceso REQ 84608>

    select count(*)
      into l_cantidad1
      from operacion.reg_archivos_enviados
     where numregins = p_numregistro;

    if l_cantidad1 > 0 then
      delete operacion.reg_archivos_enviados
       where numregins = p_numregistro;

      commit;
    end if;

    --<REQ 93175
    --select max(to_number(LASTNUMREGENV)) into l_numconaxdespareo from  operacion.LOG_REG_ARCHIVOS_ENVIADOS;
    --REQ 93175>

    --ini 23.0 Se comenta proceso de generación y envío de archivos al CONAX
  /*
      select operacion.sq_filename_arch_env.nextval
        into l_numconaxdespareo
        from dummy_ope;

      --<REQ 93175
      \* if l_numconaxdespareo is null then
         l_numconaxdespareo := 0 ;
      end if;

      if l_numconaxdespareo = 999999 then
         l_numconaxdespareo := 0 ;
      end if;

      l_numconaxdespareo := l_numconaxdespareo + 1;*\
      --REQ 93175>

      s_numconaxdespareo := lpad(l_numconaxdespareo, 6, '0');
      p_despareo         := 'gp' || s_numconaxdespareo || '.emm';

      --1.CREACION DE ARCHIVO DE DESPAREO DEL EQUIPO

      --ABRE EL ARCHIVO
      operacion.pq_dth_interfaz.p_abrir_archivo(p_text_io_des,
                                                pdirectorio,
                                                p_despareo,
                                                'W',
                                                p_resultado,
                                                p_mensaje);
      --ESCRIBE EN EL ARCHIVO
      operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des, '01', '1');
      operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des,
                                                s_numconaxdespareo,
                                                '1');
      operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des,
                                                '00001001',
                                                '1');
      operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des, 'U', '1');
      operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des, 'U', '1');
      operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des, 'U', '1');
      operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des, 'U', '1');
      operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des, 'U', '1');
      operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des, 'EMM', '1');

      --contador de decodificadores
      --ini 17.0
      \*select count(unitaddress)
       into cantdecos
       from operacion.equiposdth
      where numregistro = p_numregistro
        and grupoequ = 2;*\
      select count(1)
        into cantdecos
        from solotptoequ
       where codsolot = ln_codsolot
         and tipequ in (select a.codigon tipequope
                          from opedd a, tipopedd b
                         where a.tipopedd = b.tipopedd
                           and b.abrev = 'TIPEQU_DTH_CONAX'
                           and codigoc = '2');
      --fin 17.0
      s_candecos := lpad(cantdecos, 6, '0');

      operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des,
                                                s_candecos,
                                                '1');

      for c_ua in c_unitaddress loop
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des,
                                                  trim(c_ua.unitaddress),
                                                  '1');
      end loop;

      operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des, 'ZZZ', '1');
      --CIERRA EL ARCHIVO DE DESPAREO
      operacion.pq_dth_interfaz.p_cerrar_archivo(p_text_io_des);

      --ENVIO DE ARCHIVO DE DESPAREO
      pdespareoenv := p_despareo;
      operacion.pq_dth_interfaz.p_enviar_archivo_ascii(phost,
                                                       ppuerto,
                                                       pusuario,
                                                       ppass,
                                                       pdirectorio,
                                                       pdespareoenv,
                                                       parchivoremotoreq);

      begin

        select operacion.sq_numtrans.nextval
          into l_numtransacconax
          from dummy_ope;

        insert into operacion.log_reg_archivos_enviados
          (numregenv,
           numregins,
           filename,
           lastnumregenv,
           tipo_proceso,
           numtrans)
        values
          (s_numconaxdespareo,
           p_numregistro,
           p_despareo,
           s_numconaxdespareo,
           'D',
           l_numtransacconax);

        insert into operacion.reg_archivos_enviados
          (numregenv,
           numregins,
           filename,
           estado,
           lastnumregenv,
           tipo_proceso,
           numtrans)
        values
          (s_numconaxdespareo,
           p_numregistro,
           p_despareo,
           1,
           s_numconaxdespareo,
           'D',
           l_numtransacconax);

        commit;
      exception
        when others then
          rollback;
      end;*/
    --fin 23.0

    --21.0 Depurado cuando numslc is null
    if s_numslc is null then
      p_resultado := 'ERROR';
      p_mensaje   := 'Error al consultar numslc nulo.';
      return;
    end if;
--ini 34.0
/*
-- Ini 29.0
-- Si es DTH
    ln_dth := sales.pq_dth_postventa.f_obt_facturable_dth(s_numslc);

    IF ln_dth = 1 THEN

        select count(*)
            into ln_pareo
            from   (select (INSTR((select se.numserie  from solotptoequ se where se.codsolot = ln_codsolot and se.mac =t.nro_serie_deco), 'TMX')) flg_pareo
              from operacion.tarjeta_deco_asoc t
              where t.codsolot = ln_codsolot) pareo
            where pareo.flg_pareo = 1;

        if ln_pareo >0 then
            p_enviar_pareo_DTH(p_numregistro,ln_codsolot,ln_pareo,ls_resultado,ls_mensaje);

           if ls_resultado <> 'OK' then
               raise error_asociado;
            end if;
        end if;

        select count(*)
            into ln_despareo
            from   (select (INSTR((select se.numserie  from solotptoequ se where se.codsolot = ln_codsolot and se.mac =t.nro_serie_deco), 'TMX')) flg_pareo
              from operacion.tarjeta_deco_asoc t
              where t.codsolot = ln_codsolot) despareo
            where despareo.flg_pareo = 0;

        if ln_despareo >0 then
            p_enviar_despareo_DTH(p_numregistro,ln_codsolot,ln_despareo,ls_resultado,ls_mensaje);

            if ls_resultado <> 'OK' then
               raise error_asociado;
            end if;

        end if;

        if ln_pareo = 0 and ln_despareo = 0 then
                ls_mensaje:= 'No se encontro informacion en la Tabla de Asociación';
                 RAISE error_asociado;
        end if;

    end if;
-- Fin 29.0
*/

    SELECT COUNT(*) into l_solot_deco FROM operacion.tarjeta_deco_asoc t WHERE codsolot = ln_codsolot;
    --si codsolot NO esta asociado al tarjeta/decodificador
    IF l_solot_deco = 0 THEN
      ls_mensaje:= 'No se asoció Tarjeta con Decodificador';
      RAISE error_asociado;
    END IF;

    --si codsolot ESTA asociado al decodificador
    IF l_solot_deco > 0 THEN

      SELECT COUNT (DISTINCT se.numserie) INTO ln_pareo
        FROM solotptoequ se, operacion.tarjeta_deco_asoc t
       WHERE t.codsolot = ln_codsolot
         AND t.codsolot = se.codsolot
         AND se.mac = t.nro_serie_deco
         AND(-- cuenta si la nomenclatura numserie<tarjeta_deco_asoc> ESTA incluido en codigoc<tipos y estados>
                SELECT COUNT(*)
                 FROM opedd a, tipopedd b
                WHERE a.tipopedd = b.tipopedd
                 AND b.abrev = 'PREFIJO_DECO'
                 AND INSTR(UPPER(se.numserie), UPPER(TRIM(a.codigoc)))=1
             ) > 0;


      IF ln_pareo > 0 THEN
      p_enviar_pareo_DTH(p_numregistro,ln_codsolot,ln_pareo,ls_resultado,ls_mensaje);
      IF ls_resultado <> 'OK' THEN
         RAISE error_asociado;
      END IF;
    END IF;

    SELECT COUNT (DISTINCT se.numserie) into ln_despareo
     FROM solotptoequ se, operacion.tarjeta_deco_asoc t
    WHERE t.codsolot = ln_codsolot
     AND t.codsolot = se.codsolot
     AND se.mac = t.nro_serie_deco
     AND(-- cuenta si la nomenclatura numserie<tarjeta_deco_asoc> NO ESTA incluido en codigoc<tipos y estados>
            SELECT COUNT(*)
             FROM opedd a, tipopedd b
            WHERE a.tipopedd = b.tipopedd
             AND b.abrev = 'PREFIJO_DECO'
             AND INSTR(UPPER(se.numserie), UPPER(TRIM(a.codigoc)))=1
         ) = 0;

    IF ln_despareo >0 THEN
        p_enviar_despareo_DTH(p_numregistro,ln_codsolot,ln_despareo,ls_resultado,ls_mensaje);
        IF ls_resultado <> 'OK' THEN
           RAISE error_asociado;
        END IF;
    END IF;

    IF ln_pareo = 0 AND ln_despareo = 0 THEN
      ls_mensaje:= 'No se encontro informacion en la Tabla de Asociación';
      RAISE error_asociado;
    END IF;
   END IF;

--fin 34.0
    --if s_numslc is not null then

  --<ini 39.0>
  ln_deco_adicional := operacion.pq_deco_adicional_lte.f_obt_tipo_deco(ln_codsolot);

  IF ln_deco_adicional = 1 THEN
    l_numregistro := operacion.pq_deco_adicional_lte.f_obt_data_vta_ori(ln_codsolot);
    l_numslc      := operacion.pq_deco_adicional_lte.f_obt_data_numslc_ori(ln_codsolot);
  END IF;
  --<fin 39.0>

  IF ln_deco_adicional = 0 THEN  -- 39.0

    for c_cod_ext_vp in c_codigos_ext_ventas_princ loop

      s_bouquets  := trim(c_cod_ext_vp.codigo_ext);
      n_largo     := length(s_bouquets);
      numbouquets := (n_largo + 1) / 4;

      for i in 1 .. numbouquets loop
      s_codext := lpad(operacion.f_cb_subcadena2(s_bouquets, i), 8, '0');

      --<REQ 93175
      --select max(to_number(LASTNUMREGENV)) into l_numconax from  operacion.LOG_reg_archivos_enviados;
      --REQ 93175>

      --ini 30.0
      ln_obt_tp := f_obt_tipo_pago(p_numregistro, null);

      if ln_obt_tp = 2 then
        p_resultado := 'ERROR';
        p_mensaje   := 'Error al consultar numslc nulo.';
        return;
      else
         if ln_obt_tp = 1 then
          /*Post Pago*/
          p_nombre:=f_genera_nombre_archivo(ln_obt_tp,'ps');
          --s_numconax := lpad(substr(p_nombre,4,5), 6, '0');
          s_numconax := lpad(substr(p_nombre,3,8), 6, '0');--31.0
         else
          /*Pre Pago*/
          p_nombre:=f_genera_nombre_archivo(ln_obt_tp,'ps');
          --s_numconax := lpad(substr(p_nombre,4,5), 6, '0');
          s_numconax := lpad(substr(p_nombre,3,8), 6, '0');--31.0
         end if;
      end if;
      --fin 30.0
      /*        select operacion.sq_filename_arch_env.nextval
            into l_numconax
            from dummy_ope;*/



      --<REQ 93175
      /*if l_numconax is null then
         l_numconax := 0 ;
      end if;

      if l_numconax = 999999 then
         l_numconax := 0 ;
      end if;

      l_numconax := l_numconax + 1;*/
      --REQ 93175>

  /*        s_numconax := lpad(l_numconax, 6, '0');
      p_nombre   := 'ps' || s_numconax || '.emm';*/

      -- 2.CREACION DE ARCHIVO DE SOLICITUD DE ACTIVACION DE CABLE SATELITAL

      --ABRE EL ARCHIVO
      operacion.pq_dth_interfaz.p_abrir_archivo(p_text_io,
                            connex_i.pdirectorioLocal, -- 37.0
                            p_nombre,
                            'W',
                            p_resultado,
                            p_mensaje);
      --ESCRIBE EN EL ARCHIVO
      operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');
      operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                            s_numconax,
                            '1');
      operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, s_codext, '1');
      operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, p_fecini, '1');
      operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, p_fecfin, '1');
      operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');
      operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'EMM', '1');
      operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');

      --contador de tarjetas
      --ini 17.0
      /*select count(serie)
       into canttarjetas
       from operacion.equiposdth
      where numregistro = p_numregistro
        and grupoequ = 1;*/
      select count(1)
        into canttarjetas
        from solotptoequ
       where codsolot = ln_codsolot
         and tipequ in (select a.codigon tipequope
                from opedd a, tipopedd b
                 where a.tipopedd = b.tipopedd
                 and b.abrev = 'TIPEQU_DTH_CONAX'
                 and codigoc = '1');
      --fin 17.0
      s_canttarjetas := lpad(canttarjetas, 6, '0');

      operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                            s_canttarjetas,
                            '1');

      for c_cards in c_tarjetas loop
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                            trim(c_cards.serie),
                            '1');
      end loop;

      operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'ZZZ', '1');
      --CIERRA EL ARCHIVO DE ACTIVACIÓN
      operacion.pq_dth_interfaz.p_cerrar_archivo(p_text_io);

      begin

        begin
        select operacion.sq_numtrans.nextval
          into l_numtransacconax
          from dummy_ope;

        insert into operacion.log_reg_archivos_enviados
          (numregenv,
           numregins,
           filename,
           lastnumregenv,
           codigo_ext,
           tipo_proceso,
           numtrans)
        values
          (s_numconax,
           p_numregistro,
           p_nombre,
           s_numconax,
           s_codext,
           'A',
           l_numtransacconax);

        insert into operacion.reg_archivos_enviados
          (numregenv,
           numregins,
           filename,
           estado,
           lastnumregenv,
           codigo_ext,
           tipo_proceso,
           numtrans)
        values
          (s_numconax,
           p_numregistro,
           p_nombre,
           1,
           s_numconax,
           s_codext,
           'A',
           l_numtransacconax);

        commit;
        exception
        when others then
          rollback;
        end;

      exception
        when others then
        p_resultado := 'ERROR1';

      end;
      end loop;

      if c_cod_ext_vp.clase = 'PRINCIPAL' then
      -- 19.0
      --21.0: Guardamos nuevos campos IDGRUPO y PID
      begin
        insert into operacion.bouquetxreginsdth
        (numregistro,
         codsrv,
         bouquets,
         tipo,
         estado,
         idgrupo,
         pid --<21.0>
         )
        values
        (p_numregistro,
         c_cod_ext_vp.codsrv,
         c_cod_ext_vp.codigo_ext,
         1,
         1,
         c_cod_ext_vp.idgrupo, --<21.0>
         c_cod_ext_vp.pid --<21.0>
         );
        commit;
      exception
        when others then
        rollback;
      end;
      end if; -- 19.0
    end loop;

    for c_cod_ext_va in c_codigos_ext_ventas_adic loop

      s_bouquets  := trim(c_cod_ext_va.codigo_ext);
      n_largo     := length(s_bouquets);
      numbouquets := (n_largo + 1) / 4;

      for i in 1 .. numbouquets loop
      s_codext := lpad(operacion.f_cb_subcadena2(s_bouquets, i), 8, '0');

      --<REQ 93175
      --select max(to_number(LASTNUMREGENV)) into l_numconax from  operacion.LOG_reg_archivos_enviados;
      --REQ 93175>

      --ini 30.0
      ln_obt_tp := f_obt_tipo_pago(p_numregistro, null);

      if ln_obt_tp = 2 then
        p_resultado := 'ERROR';
        p_mensaje   := 'Error al consultar numslc nulo.';
        return;
      else
         if ln_obt_tp = 1 then
          /*Post Pago*/
          p_nombre:=f_genera_nombre_archivo(ln_obt_tp,'ps');
          --s_numconax:=lpad(substr(p_nombre,4,5),6,'0');
          s_numconax:=lpad(substr(p_nombre,3,8),6,'0');--31.0
         else
          /*Pre Pago*/
          p_nombre:=f_genera_nombre_archivo(ln_obt_tp,'ps');
          --s_numconax:=lpad(substr(p_nombre,4,5),6,'0');
          s_numconax:=lpad(substr(p_nombre,3,8),6,'0');--31.0
         end if;
      end if;
      --fin 30.0

  /*        select operacion.sq_filename_arch_env.nextval
        into l_numconax
        from dummy_ope;*/

      --<REQ 93175
      /* if l_numconax is null then
         l_numconax := 0 ;
      end if;

      if l_numconax = 999999 then
         l_numconax := 0 ;
      end if;

      l_numconax := l_numconax + 1;*/
      --REQ 93175>

  /*        s_numconax := lpad(l_numconax, 6, '0');
      p_nombre   := 'ps' || s_numconax || '.emm';*/

      -- 2.CREACION DE ARCHIVO DE SOLICITUD DE ACTIVACION DE CABLE SATELITAL

      --ABRE EL ARCHIVO
      operacion.pq_dth_interfaz.p_abrir_archivo(p_text_io,
                            connex_i.pdirectorioLocal, --37.0
                            p_nombre,
                            'W',
                            p_resultado,
                            p_mensaje);
      --ESCRIBE EN EL ARCHIVO
      operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');
      operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                            s_numconax,
                            '1');
      operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, s_codext, '1');
      operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, p_fecini, '1');
      operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, p_fecfin, '1');
      operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');
      operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'EMM', '1');
      operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');

      --contador de tarjetas
      --ini 17.0
      /*select count(serie)
       into canttarjetas
       from operacion.equiposdth
      where numregistro = p_numregistro
        and grupoequ = 1;*/
      select count(1)
        into canttarjetas
        from solotptoequ
       where codsolot = ln_codsolot
         and tipequ in (select a.codigon tipequope
                from opedd a, tipopedd b
                 where a.tipopedd = b.tipopedd
                 and b.abrev = 'TIPEQU_DTH_CONAX'
                 and codigoc = '1');
      --fin 17.0
      s_canttarjetas := lpad(canttarjetas, 6, '0');

      operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                            s_canttarjetas,
                            '1');

      for c_cards in c_tarjetas loop
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                            trim(c_cards.serie),
                            '1');
      end loop;

      operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'ZZZ', '1');
      --CIERRA EL ARCHIVO DE ACTIVACIÓN
      operacion.pq_dth_interfaz.p_cerrar_archivo(p_text_io);

      begin

        begin
        select operacion.sq_numtrans.nextval
          into l_numtransacconax
          from dummy_ope;

        insert into operacion.log_reg_archivos_enviados
          (numregenv,
           numregins,
           filename,
           lastnumregenv,
           codigo_ext,
           tipo_proceso,
           numtrans)
        values
          (s_numconax,
           p_numregistro,
           p_nombre,
           s_numconax,
           s_codext,
           'A',
           l_numtransacconax);

        insert into operacion.reg_archivos_enviados
          (numregenv,
           numregins,
           filename,
           estado,
           lastnumregenv,
           codigo_ext,
           tipo_proceso,
           numtrans)
        values
          (s_numconax,
           p_numregistro,
           p_nombre,
           1,
           s_numconax,
           s_codext,
           'A',
           l_numtransacconax);

        commit;
        exception
        when others then
          rollback;
        end;

      exception
        when others then
        p_resultado := 'ERROR1';

      end;
      end loop;
      begin
      --21.0: Guardamos nuevos campos IDGRUPO y PID
      --      Dependiendo del flg_cnr registramos el tipo de bouquetsxreginsdth
      --      Tipo 0: Servicios Adicionales
      --      Tipo 3: Servicios Adicionales del tipo CNR
      ln_is_cnr := c_cod_ext_va.FLG_CNR;
      If ln_is_cnr = 1 Then
        ln_tipo := 3;
      Else
        ln_tipo := 0;
      End If;

      insert into operacion.bouquetxreginsdth
        (numregistro, codsrv, bouquets, tipo, estado, idgrupo, pid)
      values
        (p_numregistro,
         c_cod_ext_va.codsrv,
         c_cod_ext_va.codigo_ext,
         ln_tipo,
         1,
         c_cod_ext_va.idgrupo,
         c_cod_ext_va.pid);
      commit;
      exception
      when others then
        rollback;
      end;
    end loop;

  else
    -- ini 39.9
        FOR c_cod_ext_vp IN c_bouquet_princ_deco_adicional LOOP

          s_bouquets  := TRIM(c_cod_ext_vp.codigo_ext);
          n_largo     := length(s_bouquets);
          numbouquets := (n_largo + 1) / 4;

          FOR i IN 1 .. numbouquets LOOP
            s_codext := lpad(operacion.f_cb_subcadena2(s_bouquets, i),
                             8,
                             '0');

            ln_obt_tp := f_obt_tipo_pago(p_numregistro, NULL);

            IF ln_obt_tp = 2 THEN
              p_resultado := 'ERROR';
              p_mensaje   := 'Error al consultar numslc nulo.';
              RETURN;

            ELSE
              IF ln_obt_tp = 1 THEN
                /*Post Pago*/

                p_nombre   := f_genera_nombre_archivo(ln_obt_tp, 'ps');
                s_numconax := lpad(substr(p_nombre, 3, 8), 6, '0');
              ELSE
                /*Pre Pago*/
                p_nombre   := f_genera_nombre_archivo(ln_obt_tp, 'ps');
                s_numconax := lpad(substr(p_nombre, 3, 8), 6, '0');
              END IF;
            END IF;

            -- 2.CREACION DE ARCHIVO DE SOLICITUD DE ACTIVACION DE CABLE SATELITAL

            --ABRE EL ARCHIVO
            operacion.pq_dth_interfaz.p_abrir_archivo(p_text_io,
                                                      connex_i.pdirectoriolocal,
                                                      p_nombre,
                                                      'W',
                                                      p_resultado,
                                                      p_mensaje);
            --ESCRIBE EN EL ARCHIVO
            operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');
            operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                      s_numconax,
                                                      '1');
            operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                      s_codext,
                                                      '1');
            operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                      p_fecini,
                                                      '1');
            operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                      p_fecfin,
                                                      '1');
            operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');
            operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                      'EMM',
                                                      '1');
            operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');

            --contador de tarjetas

            SELECT COUNT(1)
              INTO canttarjetas
              FROM solotptoequ
             WHERE codsolot = ln_codsolot
               AND tipequ IN (SELECT a.codigon tipequope
                                FROM opedd a, tipopedd b
                               WHERE a.tipopedd = b.tipopedd
                                 AND b.abrev = 'TIPEQU_DTH_CONAX'
                                 AND codigoc = '1');

            s_canttarjetas := lpad(canttarjetas, 6, '0');

            operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                      s_canttarjetas,
                                                      '1');

            FOR c_cards IN c_tarjetas LOOP
              operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                        TRIM(c_cards.serie),
                                                        '1');
            END LOOP;

            operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                      'ZZZ',
                                                      '1');
            --CIERRA EL ARCHIVO DE ACTIVACION
            operacion.pq_dth_interfaz.p_cerrar_archivo(p_text_io);

            BEGIN

              --ENVIO DE ARCHIVO DE ACTIVACION CONAX
              parchivolocalenv := p_nombre;

              BEGIN
                SELECT operacion.sq_numtrans.nextval
                  INTO l_numtransacconax
                  FROM dummy_ope;

                INSERT INTO operacion.log_reg_archivos_enviados
                  (numregenv,
                   numregins,
                   filename,
                   lastnumregenv,
                   codigo_ext,
                   tipo_proceso,
                   numtrans)
                VALUES
                  (s_numconax,
                   p_numregistro,
                   p_nombre,
                   s_numconax,
                   s_codext,
                   'A',
                   l_numtransacconax);

                INSERT INTO operacion.reg_archivos_enviados
                  (numregenv,
                   numregins,
                   filename,
                   estado,
                   lastnumregenv,
                   codigo_ext,
                   tipo_proceso,
                   numtrans)
                VALUES
                  (s_numconax,
                   p_numregistro,
                   p_nombre,
                   1,
                   s_numconax,
                   s_codext,
                   'A',
                   l_numtransacconax);

                COMMIT;
              EXCEPTION
                WHEN OTHERS THEN
                  ROLLBACK;
              END;

            EXCEPTION
              WHEN OTHERS THEN
                p_resultado := 'ERROR1';

            END;
          END LOOP;

          IF c_cod_ext_vp.clase = 'PRINCIPAL' THEN

            BEGIN
              INSERT INTO operacion.bouquetxreginsdth
                (numregistro, codsrv, bouquets, tipo, estado, idgrupo, pid)
              VALUES
                (p_numregistro,
                 c_cod_ext_vp.codsrv,
                 c_cod_ext_vp.codigo_ext,
                 1,
                 1,
                 c_cod_ext_vp.idgrupo,
                 c_cod_ext_vp.pid);
              COMMIT;
            EXCEPTION
              WHEN OTHERS THEN
                ROLLBACK;
            END;
          END IF;
        END LOOP;

    FOR c_cod_ext_va IN c_bouquet_adic_deco_adicional LOOP

          s_bouquets  := TRIM(c_cod_ext_va.codigo_ext);
          n_largo     := length(s_bouquets);
          numbouquets := (n_largo + 1) / 4;

          FOR i IN 1 .. numbouquets LOOP
            s_codext := lpad(operacion.f_cb_subcadena2(s_bouquets, i),
                             8,
                             '0');

            --<REQ 93175
            --select max(to_number(LASTNUMREGENV)) into l_numconax from  operacion.LOG_reg_archivos_enviados;
            --REQ 93175>

            --ini 30.0
            ln_obt_tp := f_obt_tipo_pago(p_numregistro, NULL);

            IF ln_obt_tp = 2 THEN
              p_resultado := 'ERROR';
              p_mensaje   := 'Error al consultar numslc nulo.';
              RETURN;
            ELSE
              IF ln_obt_tp = 1 THEN
                /*Post Pago*/
                p_nombre := f_genera_nombre_archivo(ln_obt_tp, 'ps');
                --s_numconax:=lpad(substr(p_nombre,4,5),6,'0');
                s_numconax := lpad(substr(p_nombre, 3, 8), 6, '0'); --31.0
              ELSE
                /*Pre Pago*/
                p_nombre := f_genera_nombre_archivo(ln_obt_tp, 'ps');
                --s_numconax:=lpad(substr(p_nombre,4,5),6,'0');
                s_numconax := lpad(substr(p_nombre, 3, 8), 6, '0'); --31.0
              END IF;
            END IF;
            --fin 30.0

            /*        select operacion.sq_filename_arch_env.nextval
            into l_numconax
            from dummy_ope;*/

            --<REQ 93175
            /* if l_numconax is null then
               l_numconax := 0 ;
            end if;

            if l_numconax = 999999 then
               l_numconax := 0 ;
            end if;

            l_numconax := l_numconax + 1;*/
            --REQ 93175>

            /*        s_numconax := lpad(l_numconax, 6, '0');
            p_nombre   := 'ps' || s_numconax || '.emm';*/

            -- 2.CREACION DE ARCHIVO DE SOLICITUD DE ACTIVACION DE CABLE SATELITAL

            --ABRE EL ARCHIVO
            operacion.pq_dth_interfaz.p_abrir_archivo(p_text_io,
                                                      connex_i.pdirectoriolocal, --37.0
                                                      p_nombre,
                                                      'W',
                                                      p_resultado,
                                                      p_mensaje);
            --ESCRIBE EN EL ARCHIVO
            operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');
            operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                      s_numconax,
                                                      '1');
            operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                      s_codext,
                                                      '1');
            operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                      p_fecini,
                                                      '1');
            operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                      p_fecfin,
                                                      '1');
            operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');
            operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                      'EMM',
                                                      '1');
            operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');

            --contador de tarjetas
            --ini 17.0
            /*select count(serie)
             into canttarjetas
             from operacion.equiposdth
            where numregistro = p_numregistro
              and grupoequ = 1;*/
            SELECT COUNT(1)
              INTO canttarjetas
              FROM solotptoequ
             WHERE codsolot = ln_codsolot
               AND tipequ IN (SELECT a.codigon tipequope
                                FROM opedd a, tipopedd b
                               WHERE a.tipopedd = b.tipopedd
                                 AND b.abrev = 'TIPEQU_DTH_CONAX'
                                 AND codigoc = '1');
            --fin 17.0
            s_canttarjetas := lpad(canttarjetas, 6, '0');

            operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                      s_canttarjetas,

                                                      '1');

            FOR c_cards IN c_tarjetas LOOP

              operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                        TRIM(c_cards.serie),
                                                        '1');
            END LOOP;

            operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                      'ZZZ',
                                                      '1');
            --CIERRA EL ARCHIVO DE ACTIVACION

            operacion.pq_dth_interfaz.p_cerrar_archivo(p_text_io);

            BEGIN

              --ENVIO DE ARCHIVO DE ACTIVACION CONAX
              parchivolocalenv := p_nombre;


              BEGIN
                SELECT operacion.sq_numtrans.nextval
                  INTO l_numtransacconax
                  FROM dummy_ope;

                INSERT INTO operacion.log_reg_archivos_enviados
                  (numregenv,
                   numregins,
                   filename,
                   lastnumregenv,
                   codigo_ext,
                   tipo_proceso,
                   numtrans)
                VALUES
                  (s_numconax,
                   p_numregistro,
                   p_nombre,
                   s_numconax,
                   s_codext,
                   'A',
                   l_numtransacconax);

                INSERT INTO operacion.reg_archivos_enviados
                  (numregenv,
                   numregins,
                   filename,
                   estado,

                   lastnumregenv,
                   codigo_ext,
                   tipo_proceso,
                   numtrans)
                VALUES

                  (s_numconax,
                   p_numregistro,
                   p_nombre,
                   1,

                   s_numconax,
                   s_codext,
                   'A',

                   l_numtransacconax);

                COMMIT;
              EXCEPTION
                WHEN OTHERS THEN
                  ROLLBACK;
              END;

            EXCEPTION
              WHEN OTHERS THEN
                p_resultado := 'ERROR1';

            END;
          END LOOP;
          BEGIN
            --21.0: Guardamos nuevos campos IDGRUPO y PID
            --      Dependiendo del flg_cnr registramos el tipo de bouquetsxreginsdth
            --      Tipo 0: Servicios Adicionales
            --      Tipo 3: Servicios Adicionales del tipo CNR
            ln_is_cnr := c_cod_ext_va.flg_cnr;
            IF ln_is_cnr = 1 THEN
              ln_tipo := 3;
            ELSE
              ln_tipo := 0;
            END IF;

            INSERT INTO operacion.bouquetxreginsdth
              (numregistro, codsrv, bouquets, tipo, estado, idgrupo, pid)
            VALUES
              (p_numregistro,
               c_cod_ext_va.codsrv,
               c_cod_ext_va.codigo_ext,
               ln_tipo,
               1,
               c_cod_ext_va.idgrupo,
               c_cod_ext_va.pid);
            COMMIT;
          EXCEPTION
            WHEN OTHERS THEN
              ROLLBACK;

          END;
        END LOOP;
    -- fin 39.0
  end if;
    --else
    --21.0 se comenta el for c_cod_ext_pp
    /*for c_cod_ext_pp in c_codigo_ext_puerta_princ loop

      s_bouquets  := trim(c_cod_ext_pp.codigo_ext);
      n_largo     := length(s_bouquets);
      numbouquets := (n_largo + 1) / 4;

      for i in 1 .. numbouquets loop
        s_codext := lpad(operacion.f_cb_subcadena2(s_bouquets, i), 8, '0');

        --<REQ 93175
        --select max(to_number(LASTNUMREGENV)) into l_numconax from  operacion.LOG_reg_archivos_enviados;
        --REQ 93175>

        select operacion.sq_filename_arch_env.nextval
          into l_numconax
          from dummy_ope; --REQ 93175

        --<REQ 93175
        \* if l_numconax is null then
           l_numconax := 0 ;
        end if;

        if l_numconax = 999999 then
           l_numconax := 0 ;
        end if;

        l_numconax := l_numconax + 1;*\
        --REQ 93175>

        s_numconax := lpad(l_numconax, 6, '0');
        p_nombre   := 'ps' || s_numconax || '.emm';

        -- 2.CREACION DE ARCHIVO DE SOLICITUD DE ACTIVACION DE CABLE SATELITAL

        --ABRE EL ARCHIVO
        operacion.pq_dth_interfaz.p_abrir_archivo(p_text_io,
                                                  pdirectorio,
                                                  p_nombre,
                                                  'W',
                                                  p_resultado,
                                                  p_mensaje);
        --ESCRIBE EN EL ARCHIVO
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                  s_numconax,
                                                  '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                  s_codext,
                                                  '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                  p_fecini,
                                                  '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                  p_fecfin,
                                                  '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'EMM', '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');

        --contador de tarjetas
        --ini 17.0
        \*select count(serie)
          into canttarjetas
          from operacion.equiposdth
         where numregistro = p_numregistro
           and grupoequ = 1;*\
        select count(1) into canttarjetas
        from solotptoequ
        where codsolot = ln_codsolot
        and tipequ in (select a.codigon tipequope
                      from opedd a, tipopedd b
                     where a.tipopedd = b.tipopedd
                       and b.abrev = 'TIPEQU_DTH_CONAX'
                       and codigoc = '1');
        --fin 17.0
        s_canttarjetas := lpad(canttarjetas, 6, '0');

        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                  s_canttarjetas,
                                                  '1');

        for c_cards in c_tarjetas loop
          operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                    trim(c_cards.serie),
                                                    '1');
        end loop;

        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'ZZZ', '1');
        --CIERRA EL ARCHIVO DE ACTIVACIÓN
        operacion.pq_dth_interfaz.p_cerrar_archivo(p_text_io);

        begin

          --ENVIO DE ARCHIVO DE ACTIVACION CONAX
          parchivolocalenv := p_nombre;
          operacion.pq_dth_interfaz.p_enviar_archivo_ascii(phost,
                                                           ppuerto,
                                                           pusuario,
                                                           ppass,
                                                           pdirectorio,
                                                           parchivolocalenv,
                                                           parchivoremotoreq);

          begin
            select operacion.sq_numtrans.nextval
              into l_numtransacconax
              from dummy_ope;

            insert into operacion.log_reg_archivos_enviados
              (numregenv,
               numregins,
               filename,
               lastnumregenv,
               codigo_ext,
               tipo_proceso,
               numtrans)
            values
              (s_numconax,
               p_numregistro,
               p_nombre,
               s_numconax,
               s_codext,
               'A',
               l_numtransacconax);

            insert into operacion.reg_archivos_enviados
              (numregenv,
               numregins,
               filename,
               estado,
               lastnumregenv,
               codigo_ext,
               tipo_proceso,
               numtrans)
            values
              (s_numconax,
               p_numregistro,
               p_nombre,
               1,
               s_numconax,
               s_codext,
               'A',
               l_numtransacconax);

            commit;
          exception
            when others then
              rollback;
          end;

        exception
          when others then
            p_resultado := 'ERROR1';

        end;
      end loop;
      begin

        insert into operacion.bouquetxreginsdth
          (numregistro, codsrv, bouquets, tipo, estado)
        values
          (p_numregistro,
           c_cod_ext_pp.codsrv,
           c_cod_ext_pp.codigo_ext,
           c_cod_ext_pp.flgprincipal,
           1);
        commit;
      exception
        when others then
          rollback;
      end;
    end loop;*/
    --21.0 se comenta for c_cod_ext_pa
    /*for c_cod_ext_pa in c_codigo_ext_puerta_adic loop

      s_bouquets  := trim(c_cod_ext_pa.codigo_ext);
      n_largo     := length(s_bouquets);
      numbouquets := (n_largo + 1) / 4;

      for i in 1 .. numbouquets loop
        s_codext := lpad(operacion.f_cb_subcadena2(s_bouquets, i), 8, '0');

        --<REQ 93175
        --select max(to_number(LASTNUMREGENV)) into l_numconax from  operacion.LOG_reg_archivos_enviados;
        --REQ 93175>

        select operacion.sq_filename_arch_env.nextval
          into l_numconax
          from dummy_ope; --REQ 93175

        --<REQ 93175
        \* if l_numconax is null then
           l_numconax := 0 ;
        end if;

        if l_numconax = 999999 then
           l_numconax := 0 ;
        end if;

        l_numconax := l_numconax + 1;*\
        --REQ 93175>

        s_numconax := lpad(l_numconax, 6, '0');
        p_nombre   := 'ps' || s_numconax || '.emm';

        -- 2.CREACION DE ARCHIVO DE SOLICITUD DE ACTIVACION DE CABLE SATELITAL

        --ABRE EL ARCHIVO
        operacion.pq_dth_interfaz.p_abrir_archivo(p_text_io,
                                                  pdirectorio,
                                                  p_nombre,
                                                  'W',
                                                  p_resultado,
                                                  p_mensaje);
        --ESCRIBE EN EL ARCHIVO
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                  s_numconax,
                                                  '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                  s_codext,
                                                  '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                  p_fecini,
                                                  '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                  p_fecfin,
                                                  '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'EMM', '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');

        --contador de tarjetas
        --ini 17.0
        \*select count(serie)
          into canttarjetas
          from operacion.equiposdth
         where numregistro = p_numregistro
           and grupoequ = 1;*\
        select count(1) into canttarjetas
        from solotptoequ
        where codsolot = ln_codsolot
        and tipequ in (select a.codigon tipequope
                      from opedd a, tipopedd b
                     where a.tipopedd = b.tipopedd
                       and b.abrev = 'TIPEQU_DTH_CONAX'
                       and codigoc = '1');
        --17.0
        s_canttarjetas := lpad(canttarjetas, 6, '0');

        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                  s_canttarjetas,
                                                  '1');

        for c_cards in c_tarjetas loop
          operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                    trim(c_cards.serie),
                                                    '1');
        end loop;

        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'ZZZ', '1');
        --CIERRA EL ARCHIVO DE ACTIVACIÓN
        operacion.pq_dth_interfaz.p_cerrar_archivo(p_text_io);

        begin

          --ENVIO DE ARCHIVO DE ACTIVACION CONAX
          parchivolocalenv := p_nombre;
          operacion.pq_dth_interfaz.p_enviar_archivo_ascii(phost,
                                                           ppuerto,
                                                           pusuario,
                                                           ppass,
                                                           pdirectorio,
                                                           parchivolocalenv,
                                                           parchivoremotoreq);

          begin
            select operacion.sq_numtrans.nextval
              into l_numtransacconax
              from dummy_ope;

            insert into operacion.log_reg_archivos_enviados
              (numregenv,
               numregins,
               filename,
               lastnumregenv,
               codigo_ext,
               tipo_proceso,
               numtrans)
            values
              (s_numconax,
               p_numregistro,
               p_nombre,
               s_numconax,
               s_codext,
               'A',
               l_numtransacconax);

            insert into operacion.reg_archivos_enviados
              (numregenv,
               numregins,
               filename,
               estado,
               lastnumregenv,
               codigo_ext,
               tipo_proceso,
               numtrans)
            values
              (s_numconax,
               p_numregistro,
               p_nombre,
               1,
               s_numconax,
               s_codext,
               'A',
               l_numtransacconax);

            commit;
          exception
            when others then
              rollback;
          end;

        exception
          when others then
            p_resultado := 'ERROR1';

        end;
      end loop;
      begin
        insert into operacion.bouquetxreginsdth
          (numregistro, codsrv, bouquets, tipo, estado)
        values
          (p_numregistro,
           c_cod_ext_pa.codsrv,
           c_cod_ext_pa.codigo_ext,
           0,
           1);
        commit;
      exception
        when others then
          rollback;
      end;
    end loop;*/

    --end if;

  exception
    --Ini 29.0
    when error_asociado then

      p_resultado := 'ERROR';
      p_mensaje   := 'Error procesa Pareo/Despareo. ' || ls_mensaje|| ' ' || sqlcode || ' ' ||
                     sqlerrm;
    --Fin 29.0
    when others then
      p_resultado := 'ERROR';
      p_mensaje   := 'Error al abrir archivo. ' || sqlcode || ' ' ||
                     sqlerrm;
  end p_crear_archivo_conax;

  procedure p_proc_recu_filesxcli(p_numregistro in varchar2,
                                  p_tipo        in int,
                                  p_resultado   in out varchar2,
                                  p_mensaje     in out varchar2) is

    i                      int;
    check_ok               boolean;
    check_err              boolean;
    p_estado               boolean;
    file_error_copiado     boolean;
    parchivoremotook       varchar2(50);
    parchivoremotoerror    varchar2(50);
    parchivolocalrec       varchar2(50);
    pidtarjeta             varchar2(32);
    --p_errors_local         varchar2(50); --37.0
    --p_errors_remoto        varchar2(50); --37.0
    ln_estado_inst         number;
    l_canfileenv           number;
    l_canfileenv_noproc    number;
    l_canfileenv_con_error number;
    --ini 15.0
    --ln_num_reginsdth       number; --9.0
    --fin 15.0

    connex_i operacion.conex_intraway; --37.0

    cursor c_filenameenv is
      select *
        from operacion.reg_archivos_enviados
       where estado = 1
         and numregins = p_numregistro
         and fecenv is not null;

  begin
    -- Ini 37.0
    connex_i :=operacion.pq_dth.f_crea_conexion_intraway;
    /*
    p_errors_local     := 'errors.txt';
    p_errors_remoto    := 'autreq/err/errors.txt';
    */
    -- Fin 37.0
    file_error_copiado := false;
    p_resultado        := 'OK';
    i                  := 0;

    --ini 15.0
    /*select count(1) --<11.0>
     into ln_num_reginsdth --9.0
     from reginsdth
    where numregistro = p_numregistro; --9.0*/
    --fin 15.0
    select count(1) --<11.0>
      into l_canfileenv
      from operacion.reg_archivos_enviados
     where estado = 1
       and numregins = p_numregistro
       and fecenv is not null;

    for c_fileenv in c_filenameenv loop
      -- Ini 37.0

      parchivoremotook    := connex_i.parchivoremotook  || c_fileenv.filename;
      parchivoremotoerror := connex_i.parchivoremotoerror || c_fileenv.filename;
      -- Fin 37.0
      parchivolocalrec    := c_fileenv.filename;
      p_mensaje           := '';

      begin
        loop
          i         := i + 1;
          check_ok  := false;
          check_err := false;

          begin
            operacion.pq_dth_interfaz.p_recibir_archivo_ascii(connex_i.phost, --37.0
                                                              connex_i.ppuerto, --37.0
                                                              connex_i.pusuario, --37.0
                                                              connex_i.ppass, --37.0
                                                              connex_i.pdirectorioLocal, --37.0
                                                              parchivolocalrec,
                                                              parchivoremotook);
            check_ok := true;
            p_estado := true;

          exception
            when others then
              p_resultado := 'ERROR2';
              check_ok    := false;
              p_estado    := false;

          end;

          if (check_ok) then
            exit;
          end if;

          begin
            operacion.pq_dth_interfaz.p_recibir_archivo_ascii(connex_i.phost, --37.0
                                                              connex_i.ppuerto, --37.0
                                                              connex_i.pusuario, --37.0
                                                              connex_i.ppass, --37.0
                                                              connex_i.pdirectorioLocal, --37.0
                                                              parchivolocalrec,
                                                              parchivoremotoerror);

            if not file_error_copiado then
              operacion.pq_dth_interfaz.p_recibir_archivo_ascii(connex_i.phost, --37.0
                                                                connex_i.ppuerto, --37.0
                                                                connex_i.pusuario, --37.0
                                                                connex_i.ppass, --37.0
                                                                connex_i.pdirectorioLocal, --37.0
                                                                connex_i.p_errors_local, --37.0
                                                                connex_i.p_errors_remoto); --37.0
              file_error_copiado := true;
            end if;

            check_err := true;
            p_estado  := false;

          exception
            when others then
              p_resultado := 'ERROR3';
              check_err   := false;
              p_estado    := true;

          end;

          if (check_err) then
            exit;
          end if;

          if i > 1 then
            exit;
          end if;
        end loop;

        begin
          operacion.p_proc_archivo_conax(connex_i.pdirectorioLocal, --37.0
                                         parchivolocalrec,
                                         'R',
                                         p_estado,
                                         connex_i.p_errors_local, --37.0
                                         p_resultado,
                                         p_mensaje);

          if (check_ok) then
            begin
              update operacion.reg_archivos_enviados
                 set estado = 2
               where numtrans = c_fileenv.numtrans;
              commit;
            exception
              when others then
                rollback;
            end;
          end if;

          if (check_err) then
            begin
              update operacion.reg_archivos_enviados
                 set estado = 3, observacion = p_mensaje
               where numtrans = c_fileenv.numtrans;
              commit;
            exception
              when others then
                rollback;
            end;
          end if;

        exception
          when others then
            p_resultado := 'ERROR4';

        end;

      end;
    end loop;

    select count(1) --<11.0>
      into l_canfileenv_noproc
      from operacion.reg_archivos_enviados
     where estado = 1
       and numregins = p_numregistro
       and fecenv is not null;

    select count(1) --<11.0>
      into l_canfileenv_con_error
      from operacion.reg_archivos_enviados
     where estado = 3
       and numregins = p_numregistro
       and fecenv is not null;

    if l_canfileenv_noproc = l_canfileenv and l_canfileenv > 0 then
      --<11.0
      --p_resultado := 'ERROR';
      p_resultado := 'NO_PROCESADO';
      --11.0>
    else

      select operacion.f_verifica_estado_ser_conax(p_numregistro)
        into ln_estado_inst
        from dummy_ope;

      if ln_estado_inst = 1 then
        begin

          if p_tipo = 1 then
            --tipo 1:Verificación de Solicitud de Activación
            --ini 15.0
            /*if ln_num_reginsdth > 0 then
              --9.0
              update OPERACION.REGINSDTH
                 set ESTADO = '02', FECACTCONAX = SYSDATE
               where NUMREGISTRO = p_numregistro;
              --<9.0
            else*/
            --fin 15.0
            --update recargaxinssrv --12.0
            update ope_srv_recarga_det --12.0
               set fecact = sysdate, estado = '02' --10.0
             where numregistro = p_numregistro
               and tipsrv = (select valor
                               from constante
                              where constante = 'FAM_CABLE');
            --ini 15.0
            --end if;
            --fin 15.0
            --9.0>

            -- LOGICA PARA REGISTROS DE LIMA
            /*<3.0 IF F_VERIFICA_CONDICION_RECARGA(p_numregistro) = 1 THEN
               update OPERACION.REGINSDTH
                 set flg_recarga = 1
               where NUMREGISTRO = p_numregistro;
            END IF;3.0>*/

          elsif p_tipo = 2 then
            --tipo 2:Verificación de Solicitud de Desactivación
            --ini 15.0
            /*if ln_num_reginsdth > 0 then
              --9.0
              update OPERACION.REGINSDTH
                 set ESTADO       = ESTADO_OBJETIVO, --<REQ ID=100186 OBSERVACION=SE ACTUALIZA EL ESTADO DEL REGISTRO CON EL VALOR DEL ESTADO OBJETIVO/>
                     fecbajaconax = SYSDATE
               where NUMREGISTRO = p_numregistro;
              --<9.0
            else*/
            --fin 15.0
            --update recargaxinssrv --12.0
            update ope_srv_recarga_det --12.0
               set fecbaja = sysdate
             where numregistro = p_numregistro
               and tipsrv = (select valor
                               from constante
                              where constante = 'FAM_CABLE');
            --ini 15.0
            --end if;
            --fin 15.0
            --9.0>

          elsif p_tipo = 3 then
            --tipo 3:Verificación de Solicitud de Corte
            --ini 15.0
            /*if ln_num_reginsdth > 0 then
              --9.0
              update OPERACION.REGINSDTH
                 set ESTADO = '16'
               where NUMREGISTRO = p_numregistro;
            --<10.0
            else*/
            --fin 15.0
            --update RECARGAXINSSRV --12.0
            update ope_srv_recarga_det --12.0
               set estado = '16'
             where numregistro = p_numregistro
               and tipsrv = (select valor
                               from constante
                              where constante = 'FAM_CABLE');
            --10.0>
            --ini 15.0
            --end if; --9.0
            --fin 15.0
          elsif p_tipo = 4 then
            --tipo 4:Verificación de Solicitud de Reconexión
            --ini 15.0
            /*if ln_num_reginsdth > 0 then
              --9.0
              update OPERACION.REGINSDTH
                 set ESTADO = '17'
               where NUMREGISTRO = p_numregistro;
            --<10.0
            else*/
            --fin 15.0
            --update RECARGAXINSSRV --12.0
            update ope_srv_recarga_det --12.0
               set estado = '17'
             where numregistro = p_numregistro
               and tipsrv = (select valor
                               from constante
                              where constante = 'FAM_CABLE');
            --10.0>
            --ini 15.0
            --end if; --9.0
            --fin 15.0

            --<REQ ID=100186 OBSERVACION=SE COMENTA ESTA CONDICIÓN, POR ESTAR CONTEMPLADA EN EL TIPO = 2>
            /*elsif p_tipo = 5  then   --tipo 5:Verificación de Solicitud de Corte Total del Servicio
            update OPERACION.REGINSDTH
            set ESTADO = '18'
            where NUMREGISTRO = p_numregistro;*/
            --</REQ>
            --<11.0
          elsif p_tipo = 0 then
            update ope_programa_mensaje_tv_det
               set estado = 3
             where numregins = p_numregistro;
            --11.0>
          end if;

          commit;

        exception
          when others then
            rollback;
        end;
        p_resultado := 'OK';

      else
        --<REQ ID=100186 OBSERVACION=SE COMENTA ESTA CONDICIÓN>
        /*if l_canfileenv_con_error > 0 then
          begin
          if p_tipo = 1 then
             update OPERACION.REGINSDTH
             set ESTADO = '03'
             where NUMREGISTRO = p_numregistro;
          else
             update OPERACION.REGINSDTH
             set ESTADO = '06'
             where NUMREGISTRO = p_numregistro;
          end if;

          commit;
          Exception
            when others then
            rollback;
          end;
          p_resultado:='ERROR';
        else*/
        --</REQ>
        --<11.0
        if p_tipo = 0 then
          update ope_programa_mensaje_tv_det
             set estado = 4
           where numregins = p_numregistro;
          commit;
        end if;
        --11.0>

        p_resultado := 'ERROR';
        /*end if;*/ --<REQ ID=100186 OBSERVACION=SE COMENTA/>
        --</REQ>
      end if;
    end if;

  end p_proc_recu_filesxcli;

  procedure p_baja_serviciodthxcliente(
                                       --<REQ ID=100186 OBSERVACION=SE COMENTA EL USO DE PARAMETROS>
                                       /*p_idpaq     IN NUMBER,
                                                                                                                                                                                        p_fecini    IN VARCHAR2,
                                                                                                                                                                                        p_fecfin    IN VARCHAR2,*/
                                       --</REQ>
                                       p_numregistro in varchar2,
                                       --<REQ ID=100186 OBSERVACION=SE AGREGÓ PARAMETROS>
                                       p_estadoini in varchar2,
                                       p_estadofin in varchar2,
                                       --</REQ>
                                       --<REQ ID=100186 OBSERVACION=SE COMENTA EL USO DE PARAMETRO DE ESTE PARAMETRO>
                                       /*p_idtarjeta IN VARCHAR2,*/
                                       --</REQ>
                                       p_resultado in out varchar2,
                                       p_mensaje   in out varchar2) is

    p_text_io         utl_file.file_type;
    p_nombre          varchar2(15);
    l_cantidad1       number;
    l_numtransacconax number(15);
    s_numconax        varchar2(6);
    parchivolocalenv  varchar2(30);
    --ini 14.0
    /*s_bouquets         VARCHAR2(100);*/
    s_bouquets tystabsrv.codigo_ext%type;
    --fin 14.0
    n_largo        number;
    numbouquets    number;
    canttarjetas   number;
    s_canttarjetas char(6);
    --<REQ ID=100186>
    p_fecini varchar2(12);
    p_fecfin varchar2(12);
  lc_fecfin_rotacion varchar2(12);--38.0
    p_idpaq  number;
    --</REQ>
    --ini 17.0
    ln_codsolot solot.codsolot%type;
    --fin 17.0
    connex_i operacion.conex_intraway;  --37.0

    --Cursor de Códigos Externos(Bouquets)
    cursor c_codigo_ext is
      --select distinct tystabsrv.codigo_ext -- 21.0 se comenta
      select distinct trim(PQ_OPE_BOUQUET.f_conca_bouquet_srv(tystabsrv.codsrv)) codigo_ext --21.0 se agrega
        from paquete_venta,
             detalle_paquete,
             linea_paquete,
             producto,
             tystabsrv
       where paquete_venta.idpaq = p_idpaq
         and paquete_venta.idpaq = detalle_paquete.idpaq
         and detalle_paquete.iddet = linea_paquete.iddet
         and detalle_paquete.idproducto = producto.idproducto
         and detalle_paquete.flgestado = 1
         and linea_paquete.flgestado = 1
         and detalle_paquete.flgprincipal = 1
         and producto.tipsrv = '0062'
         and --cable
             linea_paquete.codsrv = tystabsrv.codsrv
            --and tystabsrv.codigo_ext is not null;-- 21.0 se comenta
         and PQ_OPE_BOUQUET.f_conca_bouquet_srv(tystabsrv.codsrv) is not null; --21.0 se agrega
    --<REQ>
    --<27.0
    cursor c_bouquet_baja is
      select idbouquet,
             codbouquet
        from ope_bouquet_mae
       where flg_activo=1
       order by codbouquet asc;
    --27.0>

    --Cursor de Bouquets Adicionales
    cursor c_codigo_ext_bouquet_adic is
      select bouquets, codsrv
        from bouquetxreginsdth
       where tipo = 0
         and estado = 1
         and numregistro = p_numregistro;

    --</REQ>

    --cursor de series de tarjetas
    cursor c_tarjetas is
    --ini 17.0
    /*select serie
            from operacion.equiposdth
           where numregistro = p_numregistro
             and grupoequ = 1
           order by serie;*/
      select numserie serie
        from solotptoequ
       where codsolot = ln_codsolot
         and tipequ in (select a.codigon tipequope
                          from opedd a, tipopedd b
                         where a.tipopedd = b.tipopedd
                           and b.abrev = 'TIPEQU_DTH_CONAX'
                           and codigoc = '1') --tarjeta
       order by numserie;
    --17.0

    s_codext varchar2(10);

  begin

    p_resultado := 'OK';
    connex_i :=operacion.pq_dth.f_crea_conexion_intraway;  --37.0

    --<REQ ID=100186>
    --ini 17.0
    /*select idpaq
    into p_idpaq
    from reginsdth*/
    select idpaq, codsolot
      into p_idpaq, ln_codsolot
      from ope_srv_recarga_cab
    --fin 17.0
     where numregistro = p_numregistro;
    --<7.0 REQ-104367>
    select to_char(trunc(new_time(sysdate, 'EST', 'GMT'), 'MM'), 'yyyymmdd') ||
           '0000'
      into p_fecini
      from dummy_ope;
--ini 38.0
    /*select to_char(trunc(last_day(new_time(sysdate, 'EST', 'GMT'))),
                   'yyyymmdd') || '0000'
      into p_fecfin
      from dummy_ope;*/

    select TO_CHAR(c.Valor)
  INTO lc_fecfin_rotacion

  from constante c WHERE C.CONSTANTE='DTHROTACION';

   select
    to_char(trunc(new_time(lc_fecfin_rotacion, 'EST', 'GMT')),
                         'yyyymmdd') || '0000' into p_fecfin from dual;


  if(to_char(trunc(sysdate), 'DD/MM/YYYY')=lc_fecfin_rotacion) then
    select add_months(lc_fecfin_rotacion,12)
    into lc_fecfin_rotacion from dual;

    update constante set valor=lc_fecfin_rotacion
    WHERE CONSTANTE='DTHROTACION';
    commit;

   select
    to_char(trunc(new_time(lc_fecfin_rotacion, 'EST', 'GMT')),
                         'yyyymmdd') || '0000' into p_fecfin from dual;

  end if;
--fin 38.0


    --</7.0 REQ-104367>
    --</REQ>
    select count(*)
      into l_cantidad1
      from operacion.reg_archivos_enviados
     where numregins = p_numregistro;

    if l_cantidad1 > 0 then
      delete operacion.reg_archivos_enviados
       where numregins = p_numregistro;

      commit;
    end if;
    --<27.0
    for c_cod_ext in c_bouquet_baja loop
     --for c_cod_ext in c_codigo_ext loop
     -- s_bouquets  := trim(c_cod_ext.codigo_ext);
     -- n_largo     := length(s_bouquets);
     -- numbouquets := (n_largo + 1) / 4;

      --for i in 1 .. numbouquets loop
        --s_codext := lpad(operacion.f_cb_subcadena2(s_bouquets, i), 8, '0');
        s_codext :=c_cod_ext.codbouquet;
        --27.0>
        --<REQ 93175
        --select max(to_number(LASTNUMREGENV)) into l_numconax from  operacion.LOG_reg_archivos_enviados;
        --REQ 93175>

        --<Ini 30.0
        p_nombre:=f_genera_nombre_archivo(0,'cs');
        --s_numconax:=lpad(substr(p_nombre,4,5),6,'0');
        s_numconax:=lpad(substr(p_nombre,3,8),6,'0');--31.0
        --Fin30.0>

        /* select operacion.sq_filename_arch_env.nextval
           into l_numconax
           from dummy_ope;*/

        --<REQ 93175
        /*if l_numconax is null then
           l_numconax := 0 ;
        end if;

        if l_numconax = 999999 then
           l_numconax := 0 ;
        end if;

        l_numconax := l_numconax + 1;*/
        --REQ 93175>

       /* s_numconax := lpad(l_numconax, 6, '0');
        p_nombre   := 'cs' || s_numconax || '.emm';*/

        --CREACION DE ARCHIVO DE SOLICITUD DE BAJA DEL SERVICIO DE CABLE SATELITAL

        --ABRE EL ARCHIVO
        operacion.pq_dth_interfaz.p_abrir_archivo(p_text_io,
                                                  connex_i.pdirectorioLocal, --37.0
                                                  p_nombre,
                                                  'W',
                                                  p_resultado,
                                                  p_mensaje);
        --ESCRIBE EN EL ARCHIVO
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                  s_numconax,
                                                  '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, s_codext, '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, p_fecini, '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, p_fecfin, '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'EMM', '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');

        --contador de tarjetas
        --ini 17.0
        /*select count(serie)
         into canttarjetas
         from operacion.equiposdth
        where numregistro = p_numregistro
          and grupoequ = 1;*/
        select count(1)
          into canttarjetas
          from solotptoequ
         where codsolot = ln_codsolot
           and tipequ in (select a.codigon tipequope
                            from opedd a, tipopedd b
                           where a.tipopedd = b.tipopedd
                             and b.abrev = 'TIPEQU_DTH_CONAX'
                             and codigoc = '1');
        --fin 17.0

        s_canttarjetas := lpad(canttarjetas, 6, '0');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                  s_canttarjetas,
                                                  '1');

        for c_cards in c_tarjetas loop
          operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                    trim(c_cards.serie),
                                                    '1');
        end loop;

        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'ZZZ', '1');
        --CIERRA EL ARCHIVO DE BAJA DEL SERVICIO DE CABLE SATELITAL
        operacion.pq_dth_interfaz.p_cerrar_archivo(p_text_io);

        begin
          begin
            select operacion.sq_numtrans.nextval
              into l_numtransacconax
              from dummy_ope;

            insert into operacion.log_reg_archivos_enviados
              (numregenv,
               numregins,
               filename,
               lastnumregenv,
               codigo_ext,
               tipo_proceso,
               numtrans)
            values
              (s_numconax,
               p_numregistro,
               p_nombre,
               s_numconax,
               s_codext,
               'B',
               l_numtransacconax);

            insert into operacion.reg_archivos_enviados
              (numregenv,
               numregins,
               filename,
               estado,
               lastnumregenv,
               codigo_ext,
               tipo_proceso,
               numtrans)
            values
              (s_numconax,
               p_numregistro,
               p_nombre,
               1,
               s_numconax,
               s_codext,
               'B',
               l_numtransacconax);

            commit;
          exception
            when others then
              rollback;
          end;

        exception
          when others then
            p_resultado := 'ERROR1';

        end;
      --end loop;--27.0

    end loop;

    for c_cod_ext_ba in c_codigo_ext_bouquet_adic loop
      s_bouquets  := trim(c_cod_ext_ba.bouquets);
      n_largo     := length(s_bouquets);
      numbouquets := (n_largo + 1) / 4;

      for i in 1 .. numbouquets loop
        s_codext := lpad(operacion.f_cb_subcadena2(s_bouquets, i), 8, '0');

        --<REQ 93175
        --select max(to_number(LASTNUMREGENV)) into l_numconax from  operacion.LOG_reg_archivos_enviados;
        --REQ 93175>

        --ini 30.0
        p_nombre:=f_genera_nombre_archivo(0,'cs');
        --s_numconax:=lpad(substr(p_nombre,4,5),6,'0');
        s_numconax:=lpad(substr(p_nombre,3,8),6,'0');--31.0
       --fin 30.0

        --<REQ 93175
        /*if l_numconax is null then
           l_numconax := 0 ;
        end if;

        if l_numconax = 999999 then
           l_numconax := 0 ;
        end if;

        l_numconax := l_numconax + 1;*/
        --REQ 93175>

        /*s_numconax := lpad(l_numconax, 6, '0');
        p_nombre   := 'cs' || s_numconax || '.emm';*/

        --CREACION DE ARCHIVO DE SOLICITUD DE BAJA DEL SERVICIO DE CABLE SATELITAL

        --ABRE EL ARCHIVO
        operacion.pq_dth_interfaz.p_abrir_archivo(p_text_io,
                                                  connex_i.pdirectorioLocal, --37.0
                                                  p_nombre,
                                                  'W',
                                                  p_resultado,
                                                  p_mensaje);
        --ESCRIBE EN EL ARCHIVO
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                  s_numconax,
                                                  '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, s_codext, '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, p_fecini, '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, p_fecfin, '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'EMM', '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');

        --contador de tarjetas
        --ini 17.0
        /*select count(serie)
         into canttarjetas
         from operacion.equiposdth
        where numregistro = p_numregistro
          and grupoequ = 1;*/
        select count(1)
          into canttarjetas
          from solotptoequ
         where codsolot = ln_codsolot
           and tipequ in (select a.codigon tipequope
                            from opedd a, tipopedd b
                           where a.tipopedd = b.tipopedd
                             and b.abrev = 'TIPEQU_DTH_CONAX'
                             and codigoc = '1');
        --fin 17.0
        s_canttarjetas := lpad(canttarjetas, 6, '0');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                  s_canttarjetas,
                                                  '1');

        for c_cards in c_tarjetas loop
          operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                    trim(c_cards.serie),
                                                    '1');
        end loop;

        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'ZZZ', '1');
        --CIERRA EL ARCHIVO DE BAJA DEL SERVICIO DE CABLE SATELITAL
        operacion.pq_dth_interfaz.p_cerrar_archivo(p_text_io);

        begin
          begin
            select operacion.sq_numtrans.nextval
              into l_numtransacconax
              from dummy_ope;

            insert into operacion.log_reg_archivos_enviados
              (numregenv,
               numregins,
               filename,
               lastnumregenv,
               codigo_ext,
               tipo_proceso,
               numtrans)
            values
              (s_numconax,
               p_numregistro,
               p_nombre,
               s_numconax,
               s_codext,
               'B',
               l_numtransacconax);

            insert into operacion.reg_archivos_enviados
              (numregenv,
               numregins,
               filename,
               estado,
               lastnumregenv,
               codigo_ext,
               tipo_proceso,
               numtrans)
            values
              (s_numconax,
               p_numregistro,
               p_nombre,
               1,
               s_numconax,
               s_codext,
               'B',
               l_numtransacconax);

            commit;
          exception
            when others then
              rollback;
          end;

        exception
          when others then
            p_resultado := 'ERROR1';

        end;
      end loop;

      begin
        update bouquetxreginsdth
           set estado = 0, fecultenv = sysdate
         where numregistro = p_numregistro
           and codsrv = c_cod_ext_ba.codsrv
           and tipo = 0;
        commit;
      exception
        when others then
          rollback;
      end;

    end loop;
    --ini 17.0
    /*begin
      update operacion.reginsdth
         set estado = p_estadoini, estado_objetivo = p_estadofin -- <REQ ID=100186 OBSERVACION = SE ACTUALIZA LOS ESTADOS CON LOS PARAMETROS DE ENTRADA />
       where numregistro = p_numregistro;

      commit;
    exception
      when others then
        rollback;
    end;*/
    --fin 17.0
  exception
    when others then
      p_resultado := 'ERROR';
      p_mensaje   := 'Error al abrir archivo. ' || sqlcode || ' ' ||
                     sqlerrm;
  end p_baja_serviciodthxcliente;

  procedure p_enviar_despareo(p_numregistro in varchar2,
                              --<REQ ID=100186 OBSERVACION=SE COMENTA EL USO DE PARAMETRO QUE NO VA A SER USADA>
                              /*p_unitaddres IN VARCHAR2,*/
                              --</REQ>
                              p_resultado in out varchar2,
                              p_mensaje   in out varchar2) is

    p_text_io_des      utl_file.file_type;
    p_despareo         varchar2(15);
    l_cantidad1        number;
    l_numtransacconax  number(15);
    s_numconaxdespareo varchar2(6);
    pdespareoenv       varchar2(30);
    --<REQ ID = 100186>
    cantdecos  number;
    s_candecos char(6);
    connex_i operacion.conex_intraway;  --37.0

    --cursor de unitaddress de decodificadores
    cursor c_unitaddress is
      select unitaddress
        from operacion.equiposdth
       where numregistro = p_numregistro
         and grupoequ = 2
       order by unitaddress;
    --</REQ>

  begin
    connex_i :=operacion.pq_dth.f_crea_conexion_intraway;  --37.0

    p_resultado := 'OK';

    select count(*)
      into l_cantidad1
      from operacion.reg_archivos_enviados
     where numregins = p_numregistro;

    if l_cantidad1 > 0 then
      delete operacion.reg_archivos_enviados
       where numregins = p_numregistro;
      commit;
    end if;

    --Cambios para la generación de un solo archivo de despareo.

    --<REQ 93175
    --select max(to_number(LASTNUMREGENV)) into l_numconaxdespareo from  operacion.LOG_REG_ARCHIVOS_ENVIADOS;
    --REQ 93175>

        --ini 30.0
        /*Pre Pago*/
        p_despareo:=f_genera_nombre_archivo(0,'gp');
        --s_numconaxdespareo:=lpad(substr(p_despareo,4,5),6,'0');
        s_numconaxdespareo:=lpad(substr(p_despareo,3,8),6,'0');--31.0
       --fin 30.0
        /*     select operacion.sq_filename_arch_env.nextval
                into l_numconaxdespareo
                from dummy_ope;*/

    --<REQ 93175
    /*  if l_numconaxdespareo is null then
       l_numconaxdespareo := 0 ;
    end if;

    if l_numconaxdespareo = 999999 then
       l_numconaxdespareo := 0 ;
    end if;

    l_numconaxdespareo := l_numconaxdespareo + 1;*/
    --REQ 93175>

   /* s_numconaxdespareo := lpad(l_numconaxdespareo, 6, '0');
    p_despareo         := 'gp' || s_numconaxdespareo || '.emm';*/

    --1.CREACION DE ARCHIVO DE DESPAREO DEL EQUIPO

    --ABRE EL ARCHIVO
    operacion.pq_dth_interfaz.p_abrir_archivo(p_text_io_des,
                                              connex_i.pdirectorioLocal, --37.0
                                              p_despareo,
                                              'W',
                                              p_resultado,
                                              p_mensaje);
    --ESCRIBE EN EL ARCHIVO
    operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des, '01', '1');
    operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des,
                                              s_numconaxdespareo,
                                              '1');
    operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des,
                                              '00001001',
                                              '1');
    operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des, 'U', '1');
    operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des, 'U', '1');
    operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des, 'U', '1');
    operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des, 'U', '1');
    operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des, 'U', '1');
    operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des, 'EMM', '1');

    --<REQ ID = 100186>
    --contador de decodificadores
    select count(unitaddress)
      into cantdecos
      from operacion.equiposdth
     where numregistro = p_numregistro
       and grupoequ = 2;

    s_candecos := lpad(cantdecos, 6, '0');

    operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des,
                                              s_candecos,
                                              '1');

    for c_ua in c_unitaddress loop
      operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des,
                                                trim(c_ua.unitaddress),
                                                '1');
    end loop;
    --</REQ>
    operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des, 'ZZZ', '1');
    --CIERRA EL ARCHIVO DE DESPAREO
    operacion.pq_dth_interfaz.p_cerrar_archivo(p_text_io_des);

    --ENVIO DE ARCHIVO DE DESPAREO
    pdespareoenv := p_despareo;
    operacion.pq_dth_interfaz.p_enviar_archivo_ascii(connex_i.phost, --37.0
                                                     connex_i.ppuerto, --37.0
                                                     connex_i.pusuario, --37.0
                                                     connex_i.ppass, --37.0
                                                     connex_i.pdirectorioLocal, --37.0
                                                     p_despareo,
                                                     connex_i.parchivoremotoreq); --37.0

    begin

      select operacion.sq_numtrans.nextval
        into l_numtransacconax
        from dummy_ope;
      --<REQ ID = 100186>
      insert into operacion.log_reg_archivos_enviados
        (numregenv,
         numregins,
         filename,
         lastnumregenv /*,unitaddress*/,
         tipo_proceso,
         numtrans)
      values
        (s_numconaxdespareo,
         p_numregistro,
         p_despareo,
         s_numconaxdespareo,
         'D',
         l_numtransacconax);

      insert into operacion.reg_archivos_enviados
        (numregenv,
         numregins,
         filename,
         estado,
         lastnumregenv /*,unitaddress*/,
         tipo_proceso,
         numtrans)
      values
        (s_numconaxdespareo,
         p_numregistro,
         p_despareo,
         1,
         s_numconaxdespareo,
         'D',
         l_numtransacconax);
      --</REQ>
      commit;
    exception
      when others then
        rollback;
    end;

  exception
    when others then
      p_resultado := 'ERROR';
      p_mensaje   := 'Error Despareo ' || sqlcode || ' ' || sqlerrm;
  end p_enviar_despareo;

  procedure p_verifica_despareo(p_numregistro in varchar2,
                                p_resultado   in out varchar2,
                                p_mensaje     in out varchar2) is

    i                      int;
    check_ok               boolean;
    check_err              boolean;
    p_estado               boolean;
    file_error_copiado     boolean;
    parchivoremotook       varchar2(50);
    parchivoremotoerror    varchar2(50);
    parchivolocalrec       varchar2(50);
    --p_errors_local         varchar2(50); 37.0
    --p_errors_remoto        varchar2(50); 37.0
    ln_estado_inst         number;
    l_canfileenv           number;
    l_canfileenv_noproc    number;
    l_canfileenv_con_error number;
    --<REQ ID='100186'>
    ls_estadofin varchar2(5);
    --</REQ>
    connex_i operacion.conex_intraway;  --37.0

    cursor c_filenameenv is
      select *
        from operacion.reg_archivos_enviados
       where estado = 1
         and numregins = p_numregistro
         and fecenv is not null;

  begin

    --p_errors_local     := 'errors.txt';          37.0
    --p_errors_remoto    := 'aut/err/errors.txt';  37.0
    connex_i :=operacion.pq_dth.f_crea_conexion_intraway;  --37.0
    file_error_copiado := false;
    p_resultado        := 'OK';
    i                  := 0;

    select count(*)
      into l_canfileenv
      from operacion.reg_archivos_enviados
     where estado = 1
       and numregins = p_numregistro
       and fecenv is not null;

    --<REQ ID=100186>
    select estadofin
      into ls_estadofin
      from flujoestdth
     where estadoini =
           (select estado from reginsdth where numregistro = p_numregistro)
       and activo = 1;
    --</REQ>

    for c_fileenv in c_filenameenv loop
      -- Ini 37.0

      parchivoremotook := connex_i.parchivoremotook || c_fileenv.filename;
      parchivoremotoerror := connex_i.parchivoremotoerror || c_fileenv.filename;
      -- Fin 37.0
      parchivolocalrec    := c_fileenv.filename;
      p_mensaje           := '';

      begin
        loop
          i         := i + 1;
          check_ok  := false;
          check_err := false;

          begin
            operacion.pq_dth_interfaz.p_recibir_archivo_ascii(connex_i.phost, --37.0
                                                              connex_i.ppuerto, --37.0
                                                              connex_i.pusuario, --37.0
                                                              connex_i.ppass, --37.0
                                                              connex_i.pdirectorioLocal, --37.0
                                                              parchivolocalrec,
                                                              parchivoremotook);
            check_ok := true;
            p_estado := true;

          exception
            when others then
              p_resultado := 'ERROR2';
              check_ok    := false;
              p_estado    := false;

          end;

          if (check_ok) then
            exit;
          end if;

          begin
            operacion.pq_dth_interfaz.p_recibir_archivo_ascii(connex_i.phost, --37.0
                                                              connex_i.ppuerto, --37.0
                                                              connex_i.pusuario, --37.0
                                                              connex_i.ppass, --37.0
                                                              connex_i.pdirectorioLocal, --37.0
                                                              parchivolocalrec,
                                                              parchivoremotoerror);

            if not file_error_copiado then
              operacion.pq_dth_interfaz.p_recibir_archivo_ascii(connex_i.phost, --37.0
                                                                connex_i.ppuerto, --37.0
                                                                connex_i.pusuario, --37.0
                                                                connex_i.ppass, --37.0
                                                                connex_i.pdirectorioLocal, --37.0
                                                                connex_i.p_errors_local, --37.0
                                                                connex_i.p_errors_remoto); --37.0
              file_error_copiado := true;
            end if;

            check_err := true;
            p_estado  := false;

          exception
            when others then
              p_resultado := 'ERROR3';
              check_err   := false;
              p_estado    := true;

          end;

          if (check_err) then
            exit;
          end if;

          if i > 1 then
            exit;
          end if;
        end loop;

        begin
          operacion.p_proc_archivo_conax(connex_i.pdirectorioLocal, --37.0
                                         parchivolocalrec,
                                         'R',
                                         p_estado,
                                         connex_i.p_errors_local, --37.0
                                         p_resultado,
                                         p_mensaje);

          if (check_ok) then
            begin
              update operacion.reg_archivos_enviados
                 set estado = 2
               where numtrans = c_fileenv.numtrans;
              commit;
            exception
              when others then
                rollback;
            end;
          end if;
          if (check_err) then
            begin
              update operacion.reg_archivos_enviados
                 set estado = 3, observacion = p_mensaje
               where numtrans = c_fileenv.numtrans;
              commit;
            exception
              when others then
                rollback;
            end;
          end if;
        exception
          when others then
            p_resultado := 'ERROR4';
        end;

      end;
    end loop;

    select count(*)
      into l_canfileenv_noproc
      from operacion.reg_archivos_enviados
     where estado = 1
       and numregins = p_numregistro
       and fecenv is not null;

    select count(*)
      into l_canfileenv_con_error
      from operacion.reg_archivos_enviados
     where estado = 3
       and numregins = p_numregistro
       and fecenv is not null;

    if l_canfileenv_noproc = l_canfileenv and l_canfileenv > 0 then
      p_resultado := 'ERROR';
    else

      select operacion.f_verifica_estado_ser_conax(p_numregistro)
        into ln_estado_inst
        from dummy_ope;

      if ln_estado_inst = 1 then
        begin
          update operacion.reginsdth
             set estado = ls_estadofin --<REQ ID=100186/>
           where numregistro = p_numregistro;
          commit;

        exception
          when others then
            rollback;
        end;
        p_resultado := 'OK';
      else
        --<REQ ID=100186 OBSERVACION=SE COMENTA>
        /*if l_canfileenv_con_error > 0 then
            begin
               update OPERACION.REGINSDTH
               set ESTADO = '11'
               where NUMREGISTRO = p_numregistro;

            commit;
            Exception
              when others then
              rollback;
            end;
            p_resultado:='ERROR';
        else*/
        --</REQ>
        p_resultado := 'ERROR';
        /*end if;*/ --<REQ ID=100186 OBSERVACION=SE COMENTA />
      end if;
    end if;

  end p_verifica_despareo;

  procedure p_mostrar_error_dth(p_numregistro in varchar2,
                                p_mensaje     in out varchar2) is

    p_errors_total varchar2(2000);

    cursor c_filenameenv is
      select *
        from operacion.reg_archivos_enviados
       where numregins = p_numregistro
         and estado = 3;

  begin

    p_errors_total := '';

    for c_fileenv in c_filenameenv loop
      p_errors_total := p_errors_total || c_fileenv.observacion;
    end loop;
    p_mensaje := p_errors_total;
  end p_mostrar_error_dth;

  procedure p_activa_bouquet_masivo2(p_numregistro in varchar2,
                                     p_bouquets    in varchar2,
                                     p_fecini      in varchar2,
                                     p_fecfin      in varchar2,
                                     p_idenvio     in number,
                                     p_resultado   in out varchar2,
                                     p_mensaje     in out varchar2) is

    p_text_io  utl_file.file_type;
    --Ini 30
    p_nombre   varchar2(15);
    s_numconax  varchar2(6);
    --Fin 30
    /* l_cantidad1         NUMBER;*/
    l_numtransacconax number(15);
    parchivolocalenv  varchar2(30);
    --ini 14.0
    /*s_bouquets         VARCHAR2(500);*/
    s_bouquets tystabsrv.codigo_ext%type;
    --fin 14.0
    n_largo     number;
    numbouquets number;
    s_codext    varchar2(8);
    pidtarjeta  varchar2(11);
    lcantidad   number(15);
    pcantidad   varchar2(5);
    l_cantidad1 number;
    connex_i operacion.conex_intraway;  --37.0

    cursor c_tarjetas is
      select distinct idtarjeta
        from operacion.tmp_tarjetas
       where flg_incluido = 1
         and idenvio = p_idenvio
         and upper(codusu) = upper(user)
       order by idtarjeta asc;

  lc_fecfin_rotacion varchar2(12); -- 38.0
  lc_fecfin varchar2(12); -- 38.0
  begin
    connex_i :=operacion.pq_dth.f_crea_conexion_intraway;  --37.0

    p_resultado := 'OK';

  -- ini 38.0
  lc_fecfin := p_fecfin;
    select TO_CHAR(c.Valor)
      INTO lc_fecfin_rotacion
      from constante c
     WHERE C.CONSTANTE = 'DTHROTACION';

    select to_char(trunc(new_time(lc_fecfin_rotacion, 'EST', 'GMT')),
                   'yyyymmdd') || '0000'
      into lc_fecfin
      from dual;

    if (to_char(trunc(sysdate), 'DD/MM/YYYY') = lc_fecfin_rotacion) then
      select add_months(lc_fecfin_rotacion, 12)
        into lc_fecfin_rotacion
        from dual;

      update constante
         set valor = lc_fecfin_rotacion
       WHERE CONSTANTE = 'DTHROTACION';
      commit;

      select to_char(trunc(new_time(lc_fecfin_rotacion, 'EST', 'GMT')),
                     'yyyymmdd') || '0000'
        into lc_fecfin

        from dual;
    end if;
    -- fin 38.0

    select count(*)
      into l_cantidad1
      from operacion.reg_archivos_enviados
     where numregins = p_numregistro;

    if l_cantidad1 > 0 then
      delete operacion.reg_archivos_enviados
       where numregins = p_numregistro;
      commit;
    end if;

    s_bouquets  := trim(p_bouquets);
    n_largo     := length(s_bouquets);
    numbouquets := (n_largo + 1) / 4;

    select count(distinct(idtarjeta))
      into lcantidad
      from operacion.tmp_tarjetas
     where flg_incluido = 1
       and idenvio = p_idenvio
       and upper(codusu) = upper(user);

    pcantidad := lpad(lcantidad, 5, '0');

    if lcantidad > 0 and lcantidad is not null then

      for i in 1 .. numbouquets loop
        s_codext := lpad(operacion.f_cb_subcadena2(s_bouquets, i), 8, '0');

        --<REQ 93175
        --select max(to_number(LASTNUMREGENV)) into l_numconax from  operacion.LOG_reg_archivos_enviados;
        --REQ 93175>

       --ini 30.0
        /*Pre Pago*/
        p_nombre:= f_genera_nombre_archivo(0,'ps');
        --s_numconax:=lpad(substr(p_nombre,4,5),6,'0');
        s_numconax:=lpad(substr(p_nombre,3,8),6,'0');--31.0
       --fin 30.0
        /*        select operacion.sq_filename_arch_env.nextval
                  into l_numconax
                  from dummy_ope;*/
        --<REQ 93175
        /*if l_numconax is null then
           l_numconax := 0 ;
        end if;

        if l_numconax = 999999 then
           l_numconax := 0 ;
        end if;

        l_numconax := l_numconax + 1;*/
        --REQ 93175>

        /*s_numconax := lpad(l_numconax, 6, '0');
        p_nombre   := 'ps' || s_numconax || '.emm';*/

        -- 1.CREACION DE ARCHIVO DE SOLICITUD DE ACTIVACION DE CABLE SATELITAL

        --ABRE EL ARCHIVO
        operacion.pq_dth_interfaz.p_abrir_archivo(p_text_io,
                                                  connex_i.pdirectorioLocal, --37.0
                                                  p_nombre,
                                                  'W',
                                                  p_resultado,
                                                  p_mensaje);
        --ESCRIBE EN EL ARCHIVO
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                  s_numconax,
                                                  '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, s_codext, '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, p_fecini, '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, lc_fecfin, '1');--38.0
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'EMM', '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                  pcantidad,
                                                  '1');
        for r_cursor in c_tarjetas loop
          pidtarjeta := r_cursor.idtarjeta;
          --ESCRIBE LOS NUMEROS DE LAS TARJETAS A ACTIVAR
          operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                    pidtarjeta,
                                                    '1');
        end loop;
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'ZZZ', '1');
        --CIERRA EL ARCHIVO DE ACTIVACIÓN
        operacion.pq_dth_interfaz.p_cerrar_archivo(p_text_io);

        begin

          --ENVIO DE ARCHIVO DE ACTIVACION CONAX
          --connex_i :=operacion.pq_dth.f_crea_conexion_intraway;
          parchivolocalenv := p_nombre;
          operacion.pq_dth_interfaz.p_enviar_archivo_ascii(connex_i.phost, --37.0
                                                           connex_i.ppuerto, --37.0
                                                           connex_i.pusuario, --37.0
                                                           connex_i.ppass, --37.0
                                                           connex_i.pdirectorioLocal, --37.0
                                                           parchivolocalenv,
                                                           connex_i.parchivoremotoreq); --37.0

          begin
            select operacion.sq_numtrans.nextval
              into l_numtransacconax
              from dummy_ope;

            insert into operacion.log_reg_archivos_enviados
              (numregenv,
               numregins,
               filename,
               lastnumregenv,
               codigo_ext,
               tipo_proceso,
               numtrans)
            values
              (s_numconax,
               p_numregistro,
               p_nombre,
               s_numconax,
               s_codext,
               'A',
               l_numtransacconax);

            insert into operacion.reg_archivos_enviados
              (numregenv,
               numregins,
               filename,
               estado,
               lastnumregenv,
               codigo_ext,
               tipo_proceso,
               numtrans)
            values
              (s_numconax,
               p_numregistro,
               p_nombre,
               1,
               s_numconax,
               s_codext,
               'A',
               l_numtransacconax);

            commit;
          exception
            when others then
              rollback;
          end;

        exception
          when others then
            p_resultado := 'ERROR1';

        end;
      end loop;
    end if;

  exception
    when others then
      p_resultado := 'ERROR';
      p_mensaje   := 'Error al crear archivo. ' || sqlcode || ' ' ||
                     sqlerrm;
  end p_activa_bouquet_masivo2;

  procedure p_desactiva_bouquet_masivo2(p_numregistro in varchar2,
                                        p_bouquets    in varchar2,
                                        p_fecini      in varchar2,
                                        p_fecfin      in varchar2,
                                        p_idenvio     in number,
                                        p_resultado   in out varchar2,
                                        p_mensaje     in out varchar2) is

    p_text_io         utl_file.file_type;
    l_numtransacconax number(15);
    n_largo           number;
    numbouquets       number;
    lcantidad         number(15);
    s_numconax        varchar2(6);
    parchivolocalenv  varchar2(30);
    --ini 14.0
    /*s_bouquets         VARCHAR2(500);*/
    s_bouquets tystabsrv.codigo_ext%type;
    --fin 14.0
    p_nombre    varchar2(15);
    pcantidad   varchar2(5);
    s_codext    varchar2(10);
    pidtarjeta  varchar2(11);
    l_cantidad1 number;
    connex_i operacion.conex_intraway;  --37.0

    cursor c_tarjetas is
      select distinct idtarjeta
        from operacion.tmp_tarjetas
       where flg_incluido = 1
         and idenvio = p_idenvio
         and upper(codusu) = upper(user)
       order by idtarjeta asc;

  begin
    connex_i :=operacion.pq_dth.f_crea_conexion_intraway;  --37.0

    p_resultado := 'OK';

    select count(*)
      into l_cantidad1
      from operacion.reg_archivos_enviados
     where numregins = p_numregistro;

    if l_cantidad1 > 0 then
      delete operacion.reg_archivos_enviados
       where numregins = p_numregistro;

      commit;
    end if;

    s_bouquets  := trim(p_bouquets);
    n_largo     := length(s_bouquets);
    numbouquets := (n_largo + 1) / 4;

    select count(distinct(idtarjeta))
      into lcantidad
      from operacion.tmp_tarjetas
     where flg_incluido = 1
       and idenvio = p_idenvio
       and upper(codusu) = upper(user);

    pcantidad := lpad(lcantidad, 5, '0');

    if lcantidad > 0 and lcantidad is not null then
      for i in 1 .. numbouquets loop
        s_codext := lpad(operacion.f_cb_subcadena2(s_bouquets, i), 8, '0');

        --<REQ 93175
        --select max(to_number(LASTNUMREGENV)) into l_numconax from  operacion.LOG_reg_archivos_enviados;
        --REQ 93175>

        --ini 30.0
        p_nombre:=f_genera_nombre_archivo(0,'cs');
        --s_numconax:=lpad(substr(p_nombre,4,5),6,'0');
        s_numconax:=lpad(substr(p_nombre,3,8),6,'0');--31.0

       --fin 30.0
        /*        select operacion.sq_filename_arch_env.nextval
                  into l_numconax
                  from dummy_ope;*/
        --<REQ 93175
        /*if l_numconax is null then
           l_numconax := 0 ;
        end if;

        if l_numconax = 999999 then
           l_numconax := 0 ;
        end if;

        l_numconax := l_numconax + 1;*/
        --REQ 93175>

        /*s_numconax := lpad(l_numconax, 6, '0');
        p_nombre   := 'cs' || s_numconax || '.emm';*/

        --CREACION DE ARCHIVO DE SOLICITUD DE BAJA DEL SERVICIO DE CABLE SATELITAL

        --ABRE EL ARCHIVO
        operacion.pq_dth_interfaz.p_abrir_archivo(p_text_io,
                                                  connex_i.pdirectorioLocal, --37.0
                                                  p_nombre,
                                                  'W',
                                                  p_resultado,
                                                  p_mensaje);
        --ESCRIBE EN EL ARCHIVO
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                  s_numconax,
                                                  '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, s_codext, '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, p_fecini, '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, p_fecfin, '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'EMM', '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                  pcantidad,
                                                  '1');
        for r_cursor in c_tarjetas loop
          pidtarjeta := r_cursor.idtarjeta;
          --ESCRIBE LOS NUMEROS DE LAS TARJETAS A DESACTIVAR
          operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                    pidtarjeta,
                                                    '1');
        end loop;
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'ZZZ', '1');
        --CIERRA EL ARCHIVO DE BAJA DEL SERVICIO DE CABLE SATELITAL
        operacion.pq_dth_interfaz.p_cerrar_archivo(p_text_io);

        begin

          --ENVIO DE ARCHIVO DE BAJA SERVICIO CABLE SATELITAL
          parchivolocalenv := p_nombre;
          operacion.pq_dth_interfaz.p_enviar_archivo_ascii(connex_i.phost, --37.0
                                                           connex_i.ppuerto, --37.0
                                                           connex_i.pusuario, --37.0
                                                           connex_i.ppass, --37.0
                                                           connex_i.pdirectorioLocal, --37.0
                                                           parchivolocalenv,
                                                           connex_i.parchivoremotoreq); --37.0

          begin
            select operacion.sq_numtrans.nextval
              into l_numtransacconax
              from dummy_ope;

            insert into operacion.log_reg_archivos_enviados
              (numregenv,
               numregins,
               filename,
               lastnumregenv,
               codigo_ext,
               tipo_proceso,
               numtrans)
            values
              (s_numconax,
               p_numregistro,
               p_nombre,
               s_numconax,
               s_codext,
               'B',
               l_numtransacconax);

            insert into operacion.reg_archivos_enviados
              (numregenv,
               numregins,
               filename,
               estado,
               lastnumregenv,
               codigo_ext,
               tipo_proceso,
               numtrans)
            values
              (s_numconax,
               p_numregistro,
               p_nombre,
               1,
               s_numconax,
               s_codext,
               'B',
               l_numtransacconax);

            commit;
          exception
            when others then
              rollback;
          end;

        exception
          when others then
            p_resultado := 'ERROR1';
        end;

      end loop;
    end if;
  exception
    when others then
      p_resultado := 'ERROR';
      p_mensaje   := 'Error al abrir archivo. ' || sqlcode || ' ' ||
                     sqlerrm;
  end p_desactiva_bouquet_masivo2;

  procedure p_sol_despareo_masivo(p_numregistro in varchar2,
                                  p_idenvio     in number,
                                  p_resultado   in out varchar2,
                                  p_mensaje     in out varchar2) is

    p_text_io_des      utl_file.file_type;
    p_despareo         varchar2(15);
    s_numconaxdespareo varchar2(6);
    pdespareoenv       varchar2(30);
    s_candecos         char(6);
    l_cantidad1        number;
    l_numtransacconax  number(15);
    lcantidad          number(15);
    cantdecos          number;
    connex_i operacion.conex_intraway;  --37.0

    --cursor de unitaddress de decodificadores

    cursor c_unitaddress is
      select distinct unitaddress
        from operacion.tmp_decos
       where flg_incluido = 1
         and idenvio = p_idenvio
         and upper(codusu) = upper(user)
       order by unitaddress asc;

  begin
    connex_i :=operacion.pq_dth.f_crea_conexion_intraway;  --37.0

    p_resultado := 'OK';

    select count(*)
      into l_cantidad1
      from operacion.reg_archivos_enviados
     where numregins = p_numregistro;

    if l_cantidad1 > 0 then
      delete operacion.reg_archivos_enviados
       where numregins = p_numregistro;
      commit;
    end if;

    --Cambios para la generación de un solo archivo de despareo.

    --<REQ 93175
    --select max(to_number(LASTNUMREGENV)) into l_numconaxdespareo from  operacion.LOG_REG_ARCHIVOS_ENVIADOS;
    --REQ 93175>

        --ini 30.0
          p_despareo:=f_genera_nombre_archivo(0,'gp');
          --s_numconaxdespareo:=lpad(substr(p_despareo,4,5),6,'0');
          s_numconaxdespareo:=lpad(substr(p_despareo,3,8),6,'0');--31.0
        /*    select operacion.sq_filename_arch_env.nextval
      into l_numconaxdespareo
      from dummy_ope;*/

       --fin 30.0

    --<REQ 93175
    /*  if l_numconaxdespareo is null then
       l_numconaxdespareo := 0 ;
    end if;

    if l_numconaxdespareo = 999999 then
       l_numconaxdespareo := 0 ;
    end if;

    l_numconaxdespareo := l_numconaxdespareo + 1;*/
    --REQ 93175>

   /* s_numconaxdespareo := lpad(l_numconaxdespareo, 6, '0');
    p_despareo         := 'gp' || s_numconaxdespareo || '.emm';*/

    --1.CREACION DE ARCHIVO DE DESPAREO DEL EQUIPO

    --ABRE EL ARCHIVO

    operacion.pq_dth_interfaz.p_abrir_archivo(p_text_io_des,
                                              connex_i.pdirectorioLocal, --37.0
                                              p_despareo,
                                              'W',
                                              p_resultado,
                                              p_mensaje);
    --ESCRIBE EN EL ARCHIVO
    operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des, '01', '1');
    operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des,
                                              s_numconaxdespareo,
                                              '1');
    operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des,
                                              '00001001',
                                              '1');
    operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des, 'U', '1');
    operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des, 'U', '1');
    operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des, 'U', '1');
    operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des, 'U', '1');
    operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des, 'U', '1');
    operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des, 'EMM', '1');

    --contador de decodificadores

    select count(distinct(unitaddress))
      into lcantidad
      from operacion.tmp_decos
     where flg_incluido = 1
       and idenvio = p_idenvio
       and upper(codusu) = upper(user);

    s_candecos := lpad(lcantidad, 6, '0');
    operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des,
                                              s_candecos,
                                              '1');

    for c_ua in c_unitaddress loop
      operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des,
                                                trim(c_ua.unitaddress),
                                                '1');
    end loop;

    operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des, 'ZZZ', '1');
    --CIERRA EL ARCHIVO DE DESPAREO
    operacion.pq_dth_interfaz.p_cerrar_archivo(p_text_io_des);

    --ENVIO DE ARCHIVO DE DESPAREO
    pdespareoenv := p_despareo;
    operacion.pq_dth_interfaz.p_enviar_archivo_ascii(connex_i.phost, --37.0
                                                     connex_i.ppuerto, --37.0
                                                     connex_i.pusuario, --37.0
                                                     connex_i.ppass, --37.0
                                                     connex_i.pdirectorioLocal, --37.0
                                                     pdespareoenv,
                                                     connex_i.parchivoremotoreq); --37.0

    begin

      select operacion.sq_numtrans.nextval
        into l_numtransacconax
        from dummy_ope;

      insert into operacion.log_reg_archivos_enviados
        (numregenv,
         numregins,
         filename,
         lastnumregenv,
         tipo_proceso,
         numtrans)
      values
        (s_numconaxdespareo,
         p_numregistro,
         p_despareo,
         s_numconaxdespareo,
         'D',
         l_numtransacconax);

      insert into operacion.reg_archivos_enviados
        (numregenv,
         numregins,
         filename,
         estado,
         lastnumregenv,
         tipo_proceso,
         numtrans)
      values
        (s_numconaxdespareo,
         p_numregistro,
         p_despareo,
         1,
         s_numconaxdespareo,
         'D',
         l_numtransacconax);

      commit;
    exception
      when others then
        rollback;
    end;

  exception
    when others then
      p_resultado := 'ERROR';
      p_mensaje   := 'Error Despareo ' || sqlcode || ' ' || sqlerrm;
  end p_sol_despareo_masivo;

procedure p_corte_dth(p_pid       in number,
                        p_resultado in out varchar2,
                        p_mensaje   in out varchar2) is

    p_text_io         utl_file.file_type;
    n_largo           number;
    numbouquets       number;
    l_cantidad1       number;
    l_numtransacconax number(15);
    p_idpaq           number;
    p_numregistro     varchar2(10);
    p_fecini          varchar2(12);
    p_fecfin          varchar2(12);
    s_numconax        varchar2(6);
    lc_fecfin_rotacion varchar2(12);--38.0
    parchivolocalenv  varchar2(30);
    p_nombre          varchar2(15);
    --ini 14.0
    /*s_bouquets         VARCHAR2(100);*/
    s_bouquets tystabsrv.codigo_ext%type;
    --fin 14.0
    canttarjetas       number;
    s_canttarjetas     char(6);
    l_cont_numregistro number;
    --ini 15.0
    --ln_num_reginsdth number; --12.0
    --fin 15.0
    ln_codsolot_ori solot.codsolot%type; --12.0
    connex_i operacion.conex_intraway;  --37.0
    --ini v40.0
    ls_bouquetContego     varchar2(700):=null;
    ls_serieContego       varchar2(30);
    ln_contadorContego    number:=0;
    ln_actionContego      number:=108;
    lo_contego            OPERACION.SGAT_TRXCONTEGO%ROWTYPE;
    k_respuesta           varchar2(30);
    --fin v40.0

    --cursor de codigos externos
    cursor c_codigo_ext is
      --select distinct tystabsrv.codigo_ext
        select distinct trim(PQ_OPE_BOUQUET.f_conca_bouquet_srv(linea_paquete.codsrv))codigo_ext --26.0
        from paquete_venta,
             detalle_paquete,
             linea_paquete,
             producto,
             tystabsrv
       where paquete_venta.idpaq = p_idpaq
         and paquete_venta.idpaq = detalle_paquete.idpaq
         and detalle_paquete.iddet = linea_paquete.iddet
         and detalle_paquete.idproducto = producto.idproducto
         and detalle_paquete.flgestado = 1
         and linea_paquete.flgestado = 1
         and detalle_paquete.flgprincipal = 1
            --and producto.tipsrv = '0062' --12.0
         and producto.tipsrv =
             (select valor from constante where constante = 'FAM_CABLE') --12.0
         and linea_paquete.codsrv = tystabsrv.codsrv
         and tystabsrv.codigo_ext is not null;

    --<REQ>
    --Cursor de Bouquets Adicionales
    cursor c_codigo_ext_bouquet_adic is
      select bouquets, codsrv
        from bouquetxreginsdth
       where tipo = 0
         and estado = 1
         and numregistro = p_numregistro;

    --ini v40.0
    cursor c_bouq_baja_contego is
       select distinct trim(PQ_OPE_BOUQUET.f_conca_bouquet_srv(linea_paquete.codsrv))codigo_ext
        from paquete_venta,
             detalle_paquete,
             linea_paquete,
             producto,
             tystabsrv
       where paquete_venta.idpaq = p_idpaq
         and paquete_venta.idpaq = detalle_paquete.idpaq
         and detalle_paquete.iddet = linea_paquete.iddet
         and detalle_paquete.idproducto = producto.idproducto
         and detalle_paquete.flgestado = 1
         and linea_paquete.flgestado = 1
         and detalle_paquete.flgprincipal = 1
         and producto.tipsrv =
             (select valor from constante where constante = 'FAM_CABLE')
         and linea_paquete.codsrv = tystabsrv.codsrv
         and tystabsrv.codigo_ext is not null
       union all
         select bouquets
          from bouquetxreginsdth
         where tipo = 0
           and estado = 1
           and numregistro = p_numregistro;
    --fin v40.0

    --</REQ>

    --cursor de series de tarjetas
    cursor c_tarjetas is
    --16.0
    /*select serie
            from operacion.equiposdth
           where numregistro = p_numregistro
             and grupoequ = 1
          --<12.0
          union*/
    --16.0
      select a.numserie serie
        from solotptoequ a, --tipequdth b --12.0
             --<12.0
             (select a.codigon tipequope, codigoc grupoequ
                from opedd a, tipopedd b
               where a.tipopedd = b.tipopedd
                 and b.abrev = 'TIPEQU_DTH_CONAX') b
      --12.0>
       where a.codsolot = ln_codsolot_ori
         and a.tipequ = b.tipequope
            --and grupoequ = 1 --12.0
         and b.grupoequ = '1' --12.0
       order by serie asc;
    --12.0>

    s_codext varchar2(10);

  begin
    connex_i :=operacion.pq_dth.f_crea_conexion_intraway;  --37.0

    p_resultado        := 'OK';
    l_cont_numregistro := 0;

    --<12.0
    --ini 15.0
    /*select count(1) into ln_num_reginsdth
    from reginsdth where pid = p_pid;*/
    --fin 15.0
    --12.0>

    --<7.0 REQ-104367>
    select to_char(trunc(new_time(sysdate, 'EST', 'GMT'), 'MM'), 'yyyymmdd') ||
           '0000'
      into p_fecini
      from dummy_ope;--ini 38.0
   /* select to_char(trunc(last_day(new_time(sysdate, 'EST', 'GMT'))),
                   'yyyymmdd') || '0000'
      into p_fecfin
      from dummy_ope;*/

     select TO_CHAR(c.Valor)
  INTO lc_fecfin_rotacion

  from constante c WHERE C.CONSTANTE='DTHROTACION';

   select
    to_char(trunc(new_time(lc_fecfin_rotacion, 'EST', 'GMT')),
                         'yyyymmdd') || '0000' into p_fecfin from dual;


  if(to_char(trunc(sysdate), 'DD/MM/YYYY')=lc_fecfin_rotacion) then
    select add_months(lc_fecfin_rotacion,12)
    into lc_fecfin_rotacion from dual;

    update constante set valor=lc_fecfin_rotacion
    WHERE CONSTANTE='DTHROTACION';
    commit;

   select
    to_char(trunc(new_time(lc_fecfin_rotacion, 'EST', 'GMT')),
                         'yyyymmdd') || '0000' into p_fecfin from dual;

  end if;--38.0
    --</7.0 REQ-104367>
    --ini 15.0
    /*if ln_num_reginsdth > 0 then --12.0
      select count(numregistro)
        into l_cont_numregistro
        from operacion.reginsdth
       where pid = p_pid
         and estado in ('07', '17');
    --<12.0
    else*/
    --fin 15.0
    select count(a.numregistro)
      into l_cont_numregistro
      from ope_srv_recarga_cab a, ope_srv_recarga_det b
     where a.numregistro = b.numregistro
       and b.pid = p_pid
       and a.estado in ('02'); --activo
    --ini 15.0
    --end if;
    --fin 15.0
    --12.0>

    if l_cont_numregistro > 1 then
      --ini 15.0
      /*if ln_num_reginsdth > 0 then --12.0
        select max(numregistro)
          into p_numregistro
          from operacion.reginsdth
         where pid = p_pid
           and estado in ('07', '17');
        select idpaq
          into p_idpaq
          from operacion.reginsdth
         where pid = p_pid
           and numregistro = p_numregistro;
      --<12.0
      else*/
      --fin 15.0
      select max(a.numregistro)
        into p_numregistro
        from ope_srv_recarga_cab a, ope_srv_recarga_det b
       where a.numregistro = b.numregistro
         and b.pid = p_pid
         and a.estado in ('02'); --activo
      select idpaq
        into p_idpaq
        from ope_srv_recarga_cab
       where numregistro = p_numregistro;
      --ini 15.0
      --end if;
      --fin 15.0
      --12.0>
    end if;

    if l_cont_numregistro = 1 then
      --ini 15.0
      /*if ln_num_reginsdth > 0 then --12.0
        select numregistro, idpaq
          into p_numregistro, p_idpaq
          from operacion.reginsdth
         where pid = p_pid
           and estado in ('07', '17');
      --<12.0
      else*/
      --fin 15.0
      select a.numregistro, idpaq
        into p_numregistro, p_idpaq
        from ope_srv_recarga_cab a, ope_srv_recarga_det b
       where a.numregistro = b.numregistro
         and b.pid = p_pid
         and a.estado in ('02'); --activo
      --ini 15.0
      --end if;
      --fin 15.0
      --12.0>
    end if;

    --<12.0
    --ini 15.0
    --if ln_num_reginsdth = 0 then
    --fin 15.0
    --se obtiene la SOT origen
    select codsolot
      into ln_codsolot_ori
      from ope_srv_recarga_cab
     where numregistro = p_numregistro;
    --ini 15.0
    --end if;
    --fin 15.0
    --12.0>

    select count(*)
      into l_cantidad1
      from operacion.reg_archivos_enviados
     where numregins = p_numregistro;

    if l_cantidad1 > 0 then
      delete operacion.reg_archivos_enviados
       where numregins = p_numregistro;

      commit;
    end if;

    --ini v40.0
    for c_bouq in c_bouq_baja_contego loop
      if ln_contadorContego = 0 then
        ls_bouquetContego := c_bouq.codigo_ext;
      else
        if ls_bouquetContego is null then
          ls_bouquetContego := c_bouq.codigo_ext;
        end if;
        ls_bouquetContego := ls_bouquetContego ||','|| c_bouq.codigo_ext;
      end if;
      ln_contadorContego := ln_contadorContego+1;
    end loop;

    for c_tarj in c_tarjetas loop
      lo_contego.trxn_action_id := ln_actionContego;
      lo_contego.trxv_serie_tarjeta := c_tarj.serie;
      lo_contego.trxv_bouquet := ls_bouquetContego;
      lo_contego.trxn_prioridad     := operacion.pkg_contego.sgafun_param_contego('CONF_CONTEGO_ACT','CONF_ACT','RECONEXION-CONTEGO','AU');
        if ls_bouquetContego is not null then
          operacion.pkg_contego.sgasi_regcontego(lo_contego, k_respuesta);
        end if;
    end loop;
    --fin v40.0

    for c_cod_ext in c_codigo_ext loop
      s_bouquets  := trim(c_cod_ext.codigo_ext);
      n_largo     := length(s_bouquets);
      numbouquets := (n_largo + 1) / 4;

      for i in 1 .. numbouquets loop
        s_codext := lpad(operacion.f_cb_subcadena2(s_bouquets, i), 8, '0');

        --<REQ 93175
        --select max(to_number(LASTNUMREGENV)) into l_numconax from  operacion.LOG_reg_archivos_enviados;
        --REQ 93175>

        --ini 30.0
        p_nombre:=f_genera_nombre_archivo(0,'cs');
        --s_numconax:=lpad(substr(p_nombre,4,5),6,'0');
        s_numconax:=lpad(substr(p_nombre,3,8),6,'0');--31.0
        --fin 30.0
        /*        select operacion.sq_filename_arch_env.nextval
                  into l_numconax
                  from dummy_ope;*/
        --<REQ 93175
        /*   if l_numconax is null then
           l_numconax := 0 ;
        end if;
        if l_numconax = 999999 then
           l_numconax := 0 ;
        end if;

        l_numconax := l_numconax + 1;*/
        --REQ 93175>

     /*   s_numconax := lpad(l_numconax, 6, '0');
        p_nombre   := 'cs' || s_numconax || '.emm';*/

        --CREACION DE ARCHIVO DE SOLICITUD DE BAJA DEL SERVICIO DE CABLE SATELITAL

        --ABRE EL ARCHIVO
        operacion.pq_dth_interfaz.p_abrir_archivo(p_text_io,
                                                  connex_i.pdirectorioLocal, --37.0
                                                  p_nombre,
                                                  'W',
                                                  p_resultado,
                                                  p_mensaje);
        --ESCRIBE EN EL ARCHIVO
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                  s_numconax,
                                                  '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, s_codext, '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, p_fecini, '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, p_fecfin, '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'EMM', '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');
        --ini 15.0
        /*if ln_num_reginsdth > 0 then --12.0
          --contador de tarjetas
          select count(serie)
            into canttarjetas
            from operacion.equiposdth
           where numregistro = p_numregistro
             and grupoequ = 1;
        --<12.0
        else*/
        --fin 15.0
        select count(a.numserie)
          into canttarjetas
          from operacion.solotptoequ a, --tipequdth b --12.0
               --<12.0
               (select a.codigon tipequope, codigoc grupoequ
                  from opedd a, tipopedd b
                 where a.tipopedd = b.tipopedd
                   and b.abrev = 'TIPEQU_DTH_CONAX') b
        --12.0>
         where a.codsolot = ln_codsolot_ori
           and a.tipequ = b.tipequope
              --and  b.grupoequ = 1; --12.0
           and b.grupoequ = '1'; --12.0
        --ini 15.0
        --end if;
        --fin 15.0
        --12.0>

        s_canttarjetas := lpad(canttarjetas, 6, '0');

        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                  s_canttarjetas,
                                                  '1');

        for c_cards in c_tarjetas loop
          operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                    trim(c_cards.serie),
                                                    '1');
        end loop;

        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'ZZZ', '1');
        --CIERRA EL ARCHIVO DE BAJA DEL SERVICIO DE CABLE SATELITAL
        operacion.pq_dth_interfaz.p_cerrar_archivo(p_text_io);
          begin
            select operacion.sq_numtrans.nextval
              into l_numtransacconax
              from dummy_ope;

            insert into operacion.log_reg_archivos_enviados
              (numregenv,
               numregins,
               filename,
               lastnumregenv,
               codigo_ext,
               tipo_proceso,
               numtrans)
            values
              (s_numconax,
               p_numregistro,
               p_nombre,
               s_numconax,
               s_codext,
               'B',
               l_numtransacconax);

            insert into operacion.reg_archivos_enviados
              (numregenv,
               numregins,
               filename,
               estado,
               lastnumregenv,
               codigo_ext,
               tipo_proceso,
               numtrans)
            values
              (s_numconax,
               p_numregistro,
               p_nombre,
               1,
               s_numconax,
               s_codext,
               'B',
               l_numtransacconax);

            commit;
          exception
            when others then
              rollback;
          end;
      end loop;

    end loop;

    for c_cod_ext_ba in c_codigo_ext_bouquet_adic loop
      s_bouquets  := trim(c_cod_ext_ba.bouquets);
      n_largo     := length(s_bouquets);
      numbouquets := (n_largo + 1) / 4;

      for i in 1 .. numbouquets loop
        s_codext := lpad(operacion.f_cb_subcadena2(s_bouquets, i), 8, '0');

        --<REQ 93175
        --select max(to_number(LASTNUMREGENV)) into l_numconax from  operacion.log_reg_archivos_enviados;
        --REQ 93175>

        --ini 30.0
        p_nombre:=f_genera_nombre_archivo(0,'cs');
        --s_numconax:=lpad(substr(p_nombre,4,5),6,'0');
        s_numconax:=lpad(substr(p_nombre,3,8),6,'0');--31.0
        --fin 30.0
        /*        select operacion.sq_filename_arch_env.nextval
                  into l_numconax
                  from dummy_ope;*/

        --<REQ 93175
        /*  if l_numconax is null then
           l_numconax := 0 ;
        end if;

        if l_numconax = 999999 then
           l_numconax := 0 ;
        end if;

        l_numconax := l_numconax + 1;*/
        --REQ 93175>

    /*    s_numconax := lpad(l_numconax, 6, '0');
        p_nombre   := 'cs' || s_numconax || '.emm';*/

        --CREACION DE ARCHIVO DE SOLICITUD DE BAJA DEL SERVICIO DE CABLE SATELITAL

        --ABRE EL ARCHIVO
        operacion.pq_dth_interfaz.p_abrir_archivo(p_text_io,
                                                  connex_i.pdirectorioLocal, --37.0
                                                  p_nombre,
                                                  'W',
                                                  p_resultado,
                                                  p_mensaje);
        --ESCRIBE EN EL ARCHIVO
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                  s_numconax,
                                                  '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, s_codext, '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, p_fecini, '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, p_fecfin, '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'EMM', '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');

        --contador de tarjetas
        --ini 15.0
        /*if ln_num_reginsdth > 0 then --12.0
          select count(serie)
            into canttarjetas
            from operacion.equiposdth
           where numregistro = p_numregistro
             and grupoequ = 1;
        --<12.0
        else*/
        --fin 15.0
        select count(a.numserie)
          into canttarjetas
          from operacion.solotptoequ a, --tipequdth b --12.0
               --<12.0
               (select a.codigon tipequope, codigoc grupoequ
                  from opedd a, tipopedd b
                 where a.tipopedd = b.tipopedd
                   and b.abrev = 'TIPEQU_DTH_CONAX') b
        --12.0>
         where a.codsolot = ln_codsolot_ori
           and a.tipequ = b.tipequope
              --and  b.grupoequ = 1; --12.0
           and b.grupoequ = '1'; --12.0
        --ini 15.0
        --end if;
        --fin 15.0
        --12.0>

        s_canttarjetas := lpad(canttarjetas, 6, '0');

        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                  s_canttarjetas,
                                                  '1');

        for c_cards in c_tarjetas loop
          operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                    trim(c_cards.serie),
                                                    '1');
        end loop;

        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'ZZZ', '1');
        --CIERRA EL ARCHIVO DE BAJA DEL SERVICIO DE CABLE SATELITAL
        operacion.pq_dth_interfaz.p_cerrar_archivo(p_text_io);
          begin
            select operacion.sq_numtrans.nextval
              into l_numtransacconax
              from dummy_ope;

            insert into operacion.log_reg_archivos_enviados
              (numregenv,
               numregins,
               filename,
               lastnumregenv,
               codigo_ext,
               tipo_proceso,
               numtrans)
            values
              (s_numconax,
               p_numregistro,
               p_nombre,
               s_numconax,
               s_codext,
               'B',
               l_numtransacconax);

            insert into operacion.reg_archivos_enviados
              (numregenv,
               numregins,
               filename,
               estado,
               lastnumregenv,
               codigo_ext,
               tipo_proceso,
               numtrans)
            values
              (s_numconax,
               p_numregistro,
               p_nombre,
               1,
               s_numconax,
               s_codext,
               'B',
               l_numtransacconax);

            commit;
          exception
            when others then
              rollback;
          end;
      end loop;

      begin
        update bouquetxreginsdth
           set estado = 0, fecultenv = sysdate
         where numregistro = p_numregistro
           and codsrv = c_cod_ext_ba.codsrv
           and tipo = 0;
        commit;
      exception
        when others then
          rollback;
      end;

    end loop;

    begin
      --ini 15.0
      /*if ln_num_reginsdth > 0 then --12.0
        update operacion.reginsdth
           set estado = '13'
         where numregistro = p_numregistro;
      --<12.0
      else*/
      --fin 15.0
      update ope_srv_recarga_det
         set estado = '13'
       where numregistro = p_numregistro
         and pid = p_pid;
      --ini 15.0
      --end if;
      --fin 15.0
      --12.0>
      commit;
    exception
      when others then
        rollback;
    end;

  exception
    when others then
      p_resultado := 'ERROR';
      p_mensaje   := 'Error al crear archivo. ' || sqlcode || ' ' ||
                     sqlerrm;
  end p_corte_dth;

procedure p_reconexion_dth(p_pid       in number,
                             p_resultado in out varchar2,
                             p_mensaje   in out varchar2) is

    p_text_io         utl_file.file_type;
    p_numregistro     varchar2(10);
    --Ini 30
    p_nombre          varchar2(15);
    --Fin 30
    p_fecini          varchar2(12);
    p_fecfin          varchar2(12);
  lc_fecfin_rotacion varchar2(12);--38.0
    p_idpaq           number;

    l_cantidad1       number;
    l_numtransacconax number(15);
    s_numconax        varchar2(6);
    --parchivolocalenv  varchar2(30);
    --ini 14.0
    /*s_bouquets         VARCHAR2(100);*/
    s_bouquets tystabsrv.codigo_ext%type;
    --fin 14.0
    n_largo            number;
    numbouquets        number;
    canttarjetas       number;
    s_canttarjetas     char(6);
    l_cont_numregistro number;

    --ini 15.0
    --ln_num_reginsdth number; --10.0
    --fin 15.0
    ln_codsolot_ori solot.codsolot%type; --10.0
    p_error varchar2(500);
    connex_i operacion.conex_intraway;  --37.0
     --<36.0
    ls_mensaje_error      varchar2(4000);
    ls_asunto             varchar2(300);
    ln_codinssrv          inssrv.codinssrv%type;
    ln_pid                insprd.pid%type;
    --36.0>
    --ini v40.0
    ls_bouquetContego     varchar2(700):=null;
    ls_serieContego       varchar2(30);
    ln_contadorContego    number:=0;
    ln_actionContego      number:=110;
    lo_contego            OPERACION.SGAT_TRXCONTEGO%ROWTYPE;
    k_respuesta           varchar2(30);
    --fin v40.0

    --cursor de codigos externos
    cursor c_codigo_ext is
      ---select distinct tystabsrv.codigo_ext
      select distinct trim(PQ_OPE_BOUQUET.f_conca_bouquet_srv(linea_paquete.codsrv))codigo_ext --26.0
        from paquete_venta,
             detalle_paquete,
             linea_paquete,
             producto,
             tystabsrv
       where paquete_venta.idpaq = p_idpaq
         and paquete_venta.idpaq = detalle_paquete.idpaq
         and detalle_paquete.iddet = linea_paquete.iddet
         and detalle_paquete.idproducto = producto.idproducto
         and detalle_paquete.flgestado = 1
         and linea_paquete.flgestado = 1
         and detalle_paquete.flgprincipal = 1
            --and producto.tipsrv = '0062' --10.0
         and producto.tipsrv =
             (select valor from constante where constante = 'FAM_CABLE') --10.0
         and linea_paquete.codsrv = tystabsrv.codsrv;
         --and tystabsrv.codigo_ext is not null; 26.0

    cursor c_bouquet_contego is
      select distinct trim(PQ_OPE_BOUQUET.f_conca_bouquet_srv(linea_paquete.codsrv))codigo_ext
        from paquete_venta,
             detalle_paquete,
             linea_paquete,
             producto,
             tystabsrv
       where paquete_venta.idpaq = p_idpaq
         and paquete_venta.idpaq = detalle_paquete.idpaq
         and detalle_paquete.iddet = linea_paquete.iddet
         and detalle_paquete.idproducto = producto.idproducto
         and detalle_paquete.flgestado = 1
         and linea_paquete.flgestado = 1
         and detalle_paquete.flgprincipal = 1
         and producto.tipsrv =
             (select valor from constante where constante = 'FAM_CABLE')
         and linea_paquete.codsrv = tystabsrv.codsrv
         order by 1 desc;

    --cursor de series de tarjetas
    cursor c_tarjetas is
    --ini 16.0
    /*select serie
            from operacion.equiposdth
           where numregistro = p_numregistro
             and grupoequ = 1
          --<10.0
          union*/
    --fin 16.0
      select a.numserie serie
        from solotptoequ a, --tipequdth b --12.0
             --<12.0
             (select a.codigon tipequope, codigoc grupoequ
                from opedd a, tipopedd b
               where a.tipopedd = b.tipopedd
                 and b.abrev = 'TIPEQU_DTH_CONAX') b
      --12.0
       where a.codsolot = ln_codsolot_ori
         and a.tipequ = b.tipequope
            --and grupoequ = 1 --12.0
         and grupoequ = '1' --12.0
       order by serie asc;
    --10.0>

    s_codext varchar2(8);

  begin
    connex_i :=operacion.pq_dth.f_crea_conexion_intraway;  --37.0
    --<10.0
    --ini 15.0
    /*select count(1) into ln_num_reginsdth
    from reginsdth where pid = p_pid;*/
    --fin 15.0

    ln_codsolot_ori := null;
    --10.0>

    p_resultado        := 'OK';
    l_cont_numregistro := 0;
    --<7.0 REQ-104367>
    select to_char(trunc(new_time(sysdate, 'EST', 'GMT'), 'MM'), 'yyyymmdd') ||
           '0000'
      into p_fecini
      from dummy_ope;
--ini 38.0
   /* select to_char(trunc(last_day(new_time(sysdate, 'EST', 'GMT'))),
                   'yyyymmdd') || '0000'
      into p_fecfin
      from dummy_ope;
    */

 select TO_CHAR(c.Valor)
  INTO lc_fecfin_rotacion

  from constante c WHERE C.CONSTANTE='DTHROTACION';

   select
    to_char(trunc(new_time(lc_fecfin_rotacion, 'EST', 'GMT')),
                         'yyyymmdd') || '0000' into p_fecfin from dual;


  if(to_char(trunc(sysdate), 'DD/MM/YYYY')=lc_fecfin_rotacion) then
    select add_months(lc_fecfin_rotacion,12)
    into lc_fecfin_rotacion from dual;

    update constante set valor=lc_fecfin_rotacion
    WHERE CONSTANTE='DTHROTACION';
    commit;

   select
    to_char(trunc(new_time(lc_fecfin_rotacion, 'EST', 'GMT')),
                         'yyyymmdd') || '0000' into p_fecfin from dual;

  end if;

--fin 38.0

    --</7.0 REQ-104367>
    --ini 15.0
    /*if ln_num_reginsdth > 0 then --10.0
      select count(numregistro)
        into l_cont_numregistro
        from operacion.reginsdth
       where pid = p_pid
         and estado in ('16');
    --<10.0
    else*/
    --fin 15.0
    select count(a.numregistro)
      into l_cont_numregistro
    --from recargaproyectocliente a, recargaxinssrv b --12.0
      from ope_srv_recarga_cab a, ope_srv_recarga_det b --12.0
     where a.numregistro = b.numregistro
       and b.pid = p_pid
       and a.estado in ('03'); --suspendido
    --ini 15.0
    --end if;
    --fin 15.0
    --10.0>

    if l_cont_numregistro > 1 then
      --ini 15.0
      /*if ln_num_reginsdth > 0 then --10.0
        select max(numregistro)
          into p_numregistro
          from operacion.reginsdth
         where pid = p_pid
           and estado in ('16');
        select idpaq
          into p_idpaq
          from operacion.reginsdth
         where pid = p_pid
           and numregistro = p_numregistro;
      --<10.0
      else*/
      --fin 15.0
      select max(a.numregistro)
        into p_numregistro
      --from recargaproyectocliente a, recargaxinssrv b --12.0
        from ope_srv_recarga_cab a, ope_srv_recarga_det b --12.0
       where a.numregistro = b.numregistro
         and b.pid = p_pid
         and a.estado in ('03');
      select idpaq
        into p_idpaq
      --from recargaproyectocliente --12.0
        from ope_srv_recarga_cab --12.0
       where numregistro = p_numregistro;
      --ini 15.0
      --end if;
      --fin 15.0
      --10.0>
    end if;

    if l_cont_numregistro = 1 then
      --ini 15.0
      /*if ln_num_reginsdth > 0 then --10.0
        select numregistro, idpaq
          into p_numregistro, p_idpaq
          from operacion.reginsdth
         where pid = p_pid
           and estado in ('16');
      --<10.0
      else*/
      --fin 15.0
      select a.numregistro, idpaq
        into p_numregistro, p_idpaq
      --from recargaproyectocliente a, recargaxinssrv b --12.0
        from ope_srv_recarga_cab a, ope_srv_recarga_det b --12.0
       where a.numregistro = b.numregistro
         and b.pid = p_pid
         and a.estado in ('03');
      --ini 15.0
      --end if;
      --fin 15.0
      --10.0>
    end if;

    --<10.0
    --ini 15.0
    --if ln_num_reginsdth = 0 then
    --fin 15.0
    --se obtiene la SOT origen
    select codsolot
      into ln_codsolot_ori
    --from recargaproyectocliente --12.0
      from ope_srv_recarga_cab --12.0
     where numregistro = p_numregistro;
    --ini 15.0
    --end if;
    --fin 15.0
    --10.0>

    select count(*)
      into l_cantidad1
      from operacion.reg_archivos_enviados
     where numregins = p_numregistro;

    if l_cantidad1 > 0 then
      delete operacion.reg_archivos_enviados
       where numregins = p_numregistro;
      commit;
    end if;
    --ini v40.0
    for c_bouq in c_bouquet_contego loop
      if ln_contadorContego = 0 then
        ls_bouquetContego := c_bouq.codigo_ext;
      else
        if ls_bouquetContego is null then
          ls_bouquetContego := c_bouq.codigo_ext;
        end if;
        ls_bouquetContego := ls_bouquetContego ||','|| c_bouq.codigo_ext;
      end if;
      ln_contadorContego := ln_contadorContego+1;
    end loop;
    for c_tarj in c_tarjetas loop
      lo_contego.trxn_action_id := ln_actionContego;
      lo_contego.trxv_serie_tarjeta := c_tarj.serie;
      lo_contego.trxv_bouquet := ls_bouquetContego;
      lo_contego.trxn_prioridad     := operacion.pkg_contego.sgafun_param_contego('CONF_CONTEGO_ACT','CONF_ACT','RECONEXION-CONTEGO','AU');
        if ls_bouquetContego is not null then
          operacion.pkg_contego.sgasi_regcontego(lo_contego, k_respuesta);
        end if;
    end loop;
    --fin v40.0
    for c_cod_ext in c_codigo_ext loop
      s_bouquets  := trim(c_cod_ext.codigo_ext);
      n_largo     := length(s_bouquets);
      numbouquets := (n_largo + 1) / 4;

      for i in 1 .. numbouquets loop
        s_codext := lpad(operacion.f_cb_subcadena2(s_bouquets, i), 8, '0');

        --<REQ 93175
        --select max(to_number(LASTNUMREGENV)) into l_numconax from  operacion.log_reg_archivos_enviados;
        --REQ 93175>

        --ini 30.0
        /*Pre Pago*/
         p_nombre:=f_genera_nombre_archivo(0,'ps');
         --s_numconax:=lpad(substr(p_nombre,4,5),6,'0');
         s_numconax:=lpad(substr(p_nombre,3,8),6,'0');--31.0
        --fin 30.0

        /*        select operacion.sq_filename_arch_env.nextval
                  into l_numconax
                  from dummy_ope;*/
        --<REQ 93175
        /*  if l_numconax is null then
           l_numconax := 0 ;
        end if;

        if l_numconax = 999999 then
           l_numconax := 0 ;
        end if;

        l_numconax := l_numconax + 1;*/
        --REQ 93175>

  /*      s_numconax := lpad(l_numconax, 6, '0');
        p_nombre   := 'ps' || s_numconax || '.emm';*/

        -- 2.CREACION DE ARCHIVO DE SOLICITUD DE ACTIVACION DE CABLE SATELITAL

        --ABRE EL ARCHIVO
        operacion.pq_dth_interfaz.p_abrir_archivo(p_text_io,
                                                  connex_i.pdirectorioLocal, --37.0
                                                  p_nombre,
                                                  'W',
                                                  p_resultado,
                                                  p_mensaje);
        --ESCRIBE EN EL ARCHIVO
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                  s_numconax,
                                                  '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, s_codext, '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, p_fecini, '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, p_fecfin, '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'EMM', '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');

        --contador de tarjetas
        --ini 15.0
        /*if ln_num_reginsdth > 0 then --10.0
          select count(serie)
            into canttarjetas
            from operacion.equiposdth
           where numregistro = p_numregistro
             and grupoequ = 1;
        --<10.0
        else*/
        --fin 15.0
        select count(a.numserie)
          into canttarjetas
          from operacion.solotptoequ a, --tipequdth b --12.0
               --<12.0
               (select a.codigon tipequope, codigoc grupoequ
                  from opedd a, tipopedd b
                 where a.tipopedd = b.tipopedd
                   and b.abrev = 'TIPEQU_DTH_CONAX') b
        --12.0>
         where a.codsolot = ln_codsolot_ori
           and a.tipequ = b.tipequope
              --and  b.grupoequ = 1; --12.0
           and b.grupoequ = '1'; --12.0
        --ini 15.0
        --end if;
        --fin 15.0
        --10.0>

        s_canttarjetas := lpad(canttarjetas, 6, '0');

        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                  s_canttarjetas,
                                                  '1');

        for c_cards in c_tarjetas loop
          operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                    trim(c_cards.serie),
                                                    '1');
        end loop;

        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'ZZZ', '1');
        --CIERRA EL ARCHIVO DE ACTIVACION
        operacion.pq_dth_interfaz.p_cerrar_archivo(p_text_io);

          begin
            select operacion.sq_numtrans.nextval
              into l_numtransacconax
              from dummy_ope;

            insert into operacion.log_reg_archivos_enviados
              (numregenv,
               numregins,
               filename,
               lastnumregenv,
               codigo_ext,
               tipo_proceso,
               numtrans)
            values
              (s_numconax,
               p_numregistro,
               p_nombre,
               s_numconax,
               s_codext,
               'A',
               l_numtransacconax);

            insert into operacion.reg_archivos_enviados
              (numregenv,
               numregins,
               filename,
               estado,
               lastnumregenv,
               codigo_ext,
               tipo_proceso,
               numtrans)
            values
              (s_numconax,
               p_numregistro,
               p_nombre,
               1,
               s_numconax,
               s_codext,
               'A',
               l_numtransacconax);

            commit;
          exception
            when others then
            --<36.0
            -- rollback;
             ls_mensaje_error :=ls_mensaje_error||'**Error:'||sqlerrm||'/'||to_char(sysdate,'dd/mm/yyyy hh:mm:ss')||trim(p_numregistro)||'/'||trim(s_codext)||'/'||trim(l_numtransacconax)||'/'||to_char(1);
             --ls_asunto         := 'Error en insercion de Registros de Envio' ;
             --p_envia_correo_dth(ls_asunto,ls_mensaje_error);
          end;
      end loop;

    end loop;

    --<36.0
   if  ls_mensaje_error is not null then
        opewf.pq_send_mail_job.p_send_mail('Error en insercion de Registros de Envio','Reconexion DTH',ls_mensaje_error);
   end if;
    --36.0>

    begin
      --ini 15.0
      /*if ln_num_reginsdth > 0 then --10.0
        update operacion.reginsdth
           set estado = '14'
         where numregistro = p_numregistro;
      --<10.0
      else*/
      --fin 15.0
      --update recargaxinssrv --12.0
      update ope_srv_recarga_det --12.0
         set estado = '14'
       where numregistro = p_numregistro
         and tipsrv =
             (select valor from constante where constante = 'FAM_CABLE');
      --ini 15.0
      --end if;
      --fin 15.0
      --10.0>
      --<36.0
      -- Obtener el valor de los campos PID y CODINSSRV
      begin
        select d.codinssrv, d.pid
          into ln_codinssrv, ln_pid
          from ope_srv_recarga_det d
         where d.numregistro = p_numregistro;
      exception
        when others then
          ls_mensaje_error := 'Error: ' || sqlerrm || '/' || to_char(sysdate,'dd/mm/yyyy hh:mm:ss') || trim(p_numregistro) || '/' || to_char(1);
          ls_asunto        := 'Error en obtencion de datos.' ;
          p_envia_correo_dth( ls_asunto, ls_mensaje_error);
      end;

      -- Actualizar el campo ESTINSSRV de la Tabla INSSRV
      begin
        update inssrv
           set estinssrv = 1
         where codinssrv = ln_codinssrv;
      exception
        when others then
          ls_mensaje_error := 'Error: ' || sqlerrm || '/' || to_char(sysdate,'dd/mm/yyyy hh:mm:ss') || trim(p_numregistro) || '/' || to_char(1);
          ls_asunto        := 'Error en actualizacion en tabla INSSRV.' ;
          p_envia_correo_dth( ls_asunto, ls_mensaje_error);
      end;

      -- Actualizar el campo ESTINSPRD de la Tabla INSPRD
      begin
        update insprd
           set estinsprd = 1
         where pid = ln_pid;
      exception
        when others then
          ls_mensaje_error := 'Error: ' || sqlerrm || '/' || to_char(sysdate,'dd/mm/yyyy hh:mm:ss') || trim(p_numregistro) || '/' || to_char(1);
          ls_asunto        := 'Error en actualizacion en tabla INSPRD.' ;
          p_envia_correo_dth( ls_asunto, ls_mensaje_error);
      end;
      --36.0>
      commit;
    exception
      when others then
        rollback;
    end;

  exception
    when others then

      p_resultado := 'ERROR';
      p_mensaje   := 'Error al crear archivo. ' || sqlcode || ' ' ||
                     sqlerrm;
  end p_reconexion_dth;

procedure p_reconexion_adic_dth(p_numregistro in varchar2,
                                    p_resultado   in out varchar2,
                                    p_mensaje     in out varchar2) is

      p_text_io         utl_file.file_type;
      p_nombre          varchar2(15);
      p_fecini          varchar2(12);
    lc_fecfin_rotacion varchar2(12);--38.0
      p_fecfin          varchar2(12);

      l_cantidad1       number;
      l_numtransacconax number(15);
      s_numconax        varchar2(6);
      parchivolocalenv  varchar2(30);
      --ini 14.0
      /*s_bouquets         VARCHAR2(100);*/
      s_bouquets tystabsrv.codigo_ext%type;
      --fin 14.0
      n_largo        number;
      numbouquets    number;
      canttarjetas   number;
      s_canttarjetas char(6);
      --ini v40.0
      ls_bouquetContego     varchar2(700):=null;
      ls_serieContego       varchar2(30);
      ln_contadorContego    number:=0;
      ln_actionContego      number:=110;
      lo_contego            OPERACION.SGAT_TRXCONTEGO%ROWTYPE;
      k_respuesta           varchar2(30);
      --fin v40.0

      --ini 15.0
      --ln_num_reginsdth number; --10.0
      --fin 15.0
      ln_codsolot_ori solot.codsolot%type; --10.0
      connex_i operacion.conex_intraway;  --37.0

      --Cursor de Bouquets Adicionales
      cursor c_codigo_ext_adic is
        --select b.codsrv, b.bouquets, t.codigo_ext
         select b.codsrv, b.bouquets,trim(PQ_OPE_BOUQUET.f_conca_bouquet_srv(t.codsrv))codigo_ext -- 26.0
          from bouquetxreginsdth b, tystabsrv t
         where b.codsrv = t.codsrv
           and b.tipo = 0
           --and b.estado = 0
           and b.estado in(0,1) --26.0
           and b.numregistro = p_numregistro;

      cursor c_bouq_adic_contego is
         select trim(PQ_OPE_BOUQUET.f_conca_bouquet_srv(t.codsrv))codigo_ext
          from bouquetxreginsdth b, tystabsrv t
         where b.codsrv = t.codsrv
           and b.tipo = 0
           and b.estado in(0,1)
           and b.numregistro = p_numregistro;

      --cursor de series de tarjetas
      cursor c_tarjetas is
      --ini 16.0
      /*select serie
              from operacion.equiposdth
             where numregistro = p_numregistro
               and grupoequ = 1
            --<10.0
            union*/
      --fin 16.0
        select a.numserie serie
          from solotptoequ a, --tipequdth b --12.0
               --<12.0
               (select a.codigon tipequope, codigoc grupoequ
                  from opedd a, tipopedd b
                 where a.tipopedd = b.tipopedd
                   and b.abrev = 'TIPEQU_DTH_CONAX') b
        --12.0>
         where a.codsolot = ln_codsolot_ori
           and a.tipequ = b.tipequope
              --and grupoequ = 1 --12.0
           and b.grupoequ = '1' --12.0
         order by serie asc;
      --10.0>;

      s_codext varchar2(8);

    begin

      --<10.0
      --ini 15.0
      /* select count(1) into ln_num_reginsdth
      from reginsdth where numregistro = p_numregistro;*/
      --fin 15.0
      ln_codsolot_ori := null;
      --ini 15.0
      --if ln_num_reginsdth = 0 then
      --fin 15.0
      --se obtiene la SOT origen
      select codsolot
        into ln_codsolot_ori
      --from recargaproyectocliente --12.0
        from ope_srv_recarga_cab --12.0
       where numregistro = p_numregistro;
      --ini 15.0
      --end if;
      --fin 15.0
      --10.0>
      connex_i :=operacion.pq_dth.f_crea_conexion_intraway;  --37.0

      p_resultado := 'OK';
      --<7.0 REQ-104367>
      select to_char(trunc(new_time(sysdate, 'EST', 'GMT'), 'MM'), 'yyyymmdd') ||
             '0000'
        into p_fecini
        from dummy_ope;--ini 38.0
     /* select to_char(trunc(last_day(new_time(sysdate, 'EST', 'GMT'))),
                     'yyyymmdd') || '0000'
        into p_fecfin
        from dummy_ope;
      */

   select TO_CHAR(c.Valor)
    INTO lc_fecfin_rotacion

    from constante c WHERE C.CONSTANTE='DTHROTACION';

     select
      to_char(trunc(new_time(lc_fecfin_rotacion, 'EST', 'GMT')),
                           'yyyymmdd') || '0000' into p_fecfin from dual;


    if(to_char(trunc(sysdate), 'DD/MM/YYYY')=lc_fecfin_rotacion) then
      select add_months(lc_fecfin_rotacion,12)
      into lc_fecfin_rotacion from dual;

      update constante set valor=lc_fecfin_rotacion
      WHERE CONSTANTE='DTHROTACION';
      commit;

     select
      to_char(trunc(new_time(lc_fecfin_rotacion, 'EST', 'GMT')),
                           'yyyymmdd') || '0000' into p_fecfin from dual;

    end if;--fin 38.0
      --</7.0 REQ-104367>

      select count(*)
        into l_cantidad1
        from operacion.reg_archivos_enviados
       where numregins = p_numregistro;

      if l_cantidad1 > 0 then
        delete operacion.reg_archivos_enviados
         where numregins = p_numregistro;
        commit;
      end if;
      --ini v40.0
      for c_bouq in c_bouq_adic_contego loop
        if ln_contadorContego = 0 then
          ls_bouquetContego := c_bouq.codigo_ext;
        else
          if ls_bouquetContego is null then
            ls_bouquetContego := c_bouq.codigo_ext;
          end if;
          ls_bouquetContego := ls_bouquetContego ||','|| c_bouq.codigo_ext;
        end if;
        ln_contadorContego := ln_contadorContego+1;
      end loop;
    for c_tarj in c_tarjetas loop
      lo_contego.trxn_action_id := ln_actionContego;
      lo_contego.trxv_serie_tarjeta := c_tarj.serie;
      lo_contego.trxv_bouquet := ls_bouquetContego;
      lo_contego.trxn_prioridad     := operacion.pkg_contego.sgafun_param_contego('CONF_CONTEGO_ACT','CONF_ACT','RECONEXION-CONTEGO','AU');
        if ls_bouquetContego is not null then
          operacion.pkg_contego.sgasi_regcontego(lo_contego, k_respuesta);
        end if;
    end loop;
      --fin v40.0

      for c_cod_ext in c_codigo_ext_adic loop
        s_bouquets  := trim(c_cod_ext.codigo_ext);
        n_largo     := length(s_bouquets);
        numbouquets := (n_largo + 1) / 4;

        for i in 1 .. numbouquets loop
          s_codext := lpad(operacion.f_cb_subcadena2(s_bouquets, i), 8, '0');

          --<REQ 93175
          --select max(to_number(LASTNUMREGENV)) into l_numconax from  operacion.log_reg_archivos_enviados;
          --REQ 93175>

          --ini 30.0
          /*Pre Pago*/
          p_nombre:=f_genera_nombre_archivo(0,'ps');
          --s_numconax:=lpad(substr(p_nombre,4,5),6,'0');
          s_numconax:=lpad(substr(p_nombre,3,8),6,'0');--31.0
         --fin 30.0
          /*        select operacion.sq_filename_arch_env.nextval
                    into l_numconax
                    from dummy_ope;*/

          --<REQ 93175
          /*  if l_numconax is null then
             l_numconax := 0 ;
          end if;

          if l_numconax = 999999 then
             l_numconax := 0 ;
          end if;

          l_numconax := l_numconax + 1;*/
          --REQ 93175>

     /*     s_numconax := lpad(l_numconax, 6, '0');
          p_nombre   := 'ps' || s_numconax || '.emm';*/

          -- 2.CREACION DE ARCHIVO DE SOLICITUD DE ACTIVACION DE CABLE SATELITAL

          --ABRE EL ARCHIVO
          operacion.pq_dth_interfaz.p_abrir_archivo(p_text_io,
                                                    connex_i.pdirectorioLocal, --37.0
                                                    p_nombre,
                                                    'W',
                                                    p_resultado,
                                                    p_mensaje);
          --ESCRIBE EN EL ARCHIVO
          operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');
          operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                    s_numconax,
                                                    '1');
          operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, s_codext, '1');
          operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, p_fecini, '1');
          operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, p_fecfin, '1');
          operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');
          operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'EMM', '1');
          operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');

          --contador de tarjetas
          --ini 15.0
          /*if ln_num_reginsdth > 0 then --12.0
            select count(serie)
              into canttarjetas
              from operacion.equiposdth
             where numregistro = p_numregistro
               and grupoequ = 1;
          --<12.0
          else*/
          --fin 15.0
          select count(a.numserie)
            into canttarjetas
            from operacion.solotptoequ a,
                 (select a.codigon tipequope, codigoc grupoequ
                    from opedd a, tipopedd b
                   where a.tipopedd = b.tipopedd
                     and b.abrev = 'TIPEQU_DTH_CONAX') b
           where a.codsolot = ln_codsolot_ori
             and a.tipequ = b.tipequope
             and b.grupoequ = '1';
          --ini 15.0
          --end if;
          --fin 15.0
          --12.0>

          s_canttarjetas := lpad(canttarjetas, 6, '0');

          operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                    s_canttarjetas,
                                                    '1');

          for c_cards in c_tarjetas loop
            operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                      trim(c_cards.serie),
                                                      '1');
          end loop;

          operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'ZZZ', '1');
          --CIERRA EL ARCHIVO DE ACTIVACION
          operacion.pq_dth_interfaz.p_cerrar_archivo(p_text_io);
            begin
              select operacion.sq_numtrans.nextval
                into l_numtransacconax
                from dummy_ope;

              insert into operacion.log_reg_archivos_enviados
                (numregenv,
                 numregins,
                 filename,
                 lastnumregenv,
                 codigo_ext,
                 tipo_proceso,
                 numtrans)
              values
                (s_numconax,
                 p_numregistro,
                 p_nombre,
                 s_numconax,
                 s_codext,
                 'A',
                 l_numtransacconax);

              insert into operacion.reg_archivos_enviados
                (numregenv,
                 numregins,
                 filename,
                 estado,
                 lastnumregenv,
                 codigo_ext,
                 tipo_proceso,
                 numtrans)
              values
                (s_numconax,
                 p_numregistro,
                 p_nombre,
                 1,
                 s_numconax,
                 s_codext,
                 'A',
                 l_numtransacconax);

              commit;
            exception
              when others then
                rollback;
            end;
        end loop;

        begin
          update bouquetxreginsdth
             set estado    = 1,
                 bouquets  = c_cod_ext.codigo_ext,
                 fecultenv = sysdate
           where tipo = 0
             and codsrv = c_cod_ext.codsrv
             and numregistro = p_numregistro;

          commit;
        exception
          when others then
            rollback;
        end;

      end loop;

    exception
      when others then
        p_resultado := 'ERROR';
        p_mensaje   := 'Error al crear archivo. ' || sqlcode || ' ' ||
                       sqlerrm;
    end p_reconexion_adic_dth;

  --<req id='113186'>
  procedure p_gen_factura_recarga(ac_codcli     in cxctabfac.codcli%type,
                                  ac_numreg     in reginsdth.numregistro%type,
                                  ac_sersut     in cxctabfac.sersut%type,
                                  ac_numsut     in cxctabfac.numsut%type,
                                  ad_feccargo   in date,
                                  an_monto      in cxctabfac.sldact%type,
                                  ad_desde      in date,
                                  ad_hasta      in date,
                                  an_idinstprod in number,
                                  an_idbilfac   out number,
                                  an_error      out number,
                                  ac_mensaje    out varchar2) is

    lv_ntdide_comp   varchar2(15);
    lc_codsuc        char(10);
    lc_flgtipocambio char(1);
    ln_cndpag        number;
    moneda_base      number;
    ln_idseccnr      number;
    ln_idseccpto     number;
    item             number;
    ln_subtotal      number;
    ln_impuestos     number;
    ln_total_fac     number;
    ln_tot_cargos    number;
    ln_monto         number;
    lr_bilfac        bilfac%rowtype;
    --ini 15.0
    --ln_idinsprod     number;
    ls_codcli        tabgrupo.codcli%type;
    ln_idtipfac      tabgrupo.idtipfac%type;
    ln_grupo         tabgrupo.grupo%type;
    ls_numslc        vtatabslcfac.numslc%type;
    ln_num_rec       number;
    ln_monto_srv     number;
    ln_idrecarga     number;
    lc_codigorecarga ope_srv_recarga_cab.codigo_recarga%type;
    ln_idvigencia    number; --21.0
    ln_monto_ori     number; --21.0
    lv_codsrv        tystabsrv.codsrv%type; --21.0

    cursor c_conceptos(a_numregistro varchar2, a_idrecarga number) is
      select d.idcpto,
             d.dsccpto,
             f.monto,
             b.codinssrv,
             f.descripcion,
             decode(f.tipvigencia, 1, 'Días', 2, 'Meses') tipvigencia,
             f.vigencia,
             (select max(idinstprod) --22.0
                from instxproducto
               where pid = b.pid) idinstprod,
             g.idcnr,
             e.monto montoserv
        from ope_srv_recarga_cab     a,
             ope_srv_recarga_det     b,
             tystabsrv               c,
             conceptofac             d,
             vta_det_recarga_paq_mae e,
             vtatabrecarga           f,
             tabcnr                  g
       where a.numregistro = a_numregistro
         and a.numregistro = b.numregistro
         and b.codsrv = c.codsrv
         and c.idcptocnr = d.idcpto
         and d.idcpto = g.idcpto
         and a.idpaq = e.idpaq
         and c.codsrv = e.codsrv
         and e.idrecarga = f.idrecarga
         and e.idrecarga = a_idrecarga
         and e.estado = 1;
    --fin 15.0

    --21.0
    cursor c_conceptos_sdc(a_numregistro varchar2, a_idvigencia number) is
      select t.*
        from (select con.idcpto,
                     con.dsccpto,
                     pq_VTA_paquete_RECARGA.F_GET_MONTO_RECARGA(a_numregistro,
                                                                a_idvigencia) monto, --Monto total
                     det.codinssrv,
                     null descripcion,
                     pq_vta_vigencia.F_GET_TIPVIGENCIA(a_idvigencia) tipvigencia,
                     pq_vta_vigencia.F_GET_VIGENCIA(a_idvigencia) vigencia,
                     (select max(idinstprod) --22.0
                        from instxproducto
                       where pid = det.pid) idinstprod,
                     g.idcnr,
                     det.iddet,
                     pq_VTA_paquete_RECARGA.F_GET_MONTO_RECARGA_IDDET(a_numregistro,
                                                                      det.iddet,
                                                                      a_idvigencia) montoserv --Monto por Servicio
                from v_ope_srv_recarga_prd det, --solo los de estado 1 y 2
                     tystabsrv             srv,
                     conceptofac           con,
                     tabcnr                g
               where det.numregistro = a_numregistro
                 and det.codsrv = srv.codsrv
                 and srv.idcptocnr = con.idcpto
                 and con.idcpto = g.idcpto) t
       where t.montoserv > 0; --Requerido para evitar los Cargos No Recurrentes

    cursor c_cnr(pidbilfac number) is
      select t.idcpto, x.*/*<20.0 nvl(x.idplataforma,t.idplataforma) idplatabcnr 20.0>*/ --21.0
        from cnr x, tabcnr t
       where x.idcnr = t.idcnr
         and x.idbilfac = pidbilfac;

  begin

    begin

      an_error               := 0;
      lc_flgtipocambio       := f_parametrosfac(80);
      moneda_base            := f_parametrosfac(130);
      lr_bilfac.idcon        := 99999999;
      lr_bilfac.tipfac       := 1;
      lr_bilfac.numser       := ac_sersut;
      lr_bilfac.numsut       := ac_numsut;
      lr_bilfac.grupo        := 10;
      lr_bilfac.tipo_doc_fac := 'D/A';
      lr_bilfac.moneda       := moneda_base;

      select min(idimpuesto)
        into lr_bilfac.idimpuesto
        from impuesto
       where esdefault = 1;

      select porcentaje
        into lr_bilfac.alicuota
        from impuesto
       where idimpuesto = lr_bilfac.idimpuesto;

      if lc_flgtipocambio = 'S' then
        lr_bilfac.tipocambio := f_tipocambio(sysdate(), 'V');
      else
        lr_bilfac.tipocambio := 1;
      end if;

      lr_bilfac.tipocambioorigen := lr_bilfac.tipocambio;

      select a.codcli,
             a.nomcli,
             a.tipdide,
             a.ntdide,
             pq_billing.f_obtiene_direccion(a.dircli, a.codubi),
             pq_billing.f_obtiene_direccion(a.dircli, a.codubi),
             a.idjurisdiccion,
             a.nomvia,
             a.numvia,
             a.tipviap,
             trim(lpad(a.interior, 40, ' ')) interior,
             a.ie,
             a.im,
             a.nomurb,
             nvl(a.ntdide_comp, ''),
             to_number(codubi),
             to_number(codubi),
             diaspago
        into lr_bilfac.codcli,
             lr_bilfac.nomcli,
             lr_bilfac.tipo_doc_ide,
             lr_bilfac.nro_doc_ide,
             lr_bilfac.dircli,
             lr_bilfac.dirfac,
             lr_bilfac.idjurisdiccion,
             lr_bilfac.nomvia,
             lr_bilfac.numvia,
             lr_bilfac.tipvia,
             lr_bilfac.interior,
             lr_bilfac.nro_doc_ide2,
             lr_bilfac.nro_doc_ide3,
             lr_bilfac.nomurb,
             lv_ntdide_comp,
             lr_bilfac.codubi,
             lr_bilfac.codubifac,
             ln_cndpag
        from vtatabcli a
       where a.codcli = ac_codcli;

      begin
        --ini 15.0
        select count(1)
          into ln_num_rec
          from ope_srv_recarga_cab
         where numregistro = ac_numreg;

        if ln_num_rec > 0 then
          --se obtiene proyecto de venta inicial
          select numslc, codigo_recarga
            into ls_numslc, lc_codigorecarga
            from ope_srv_recarga_cab
           where numregistro = ac_numreg;

          select distinct codcli, idtipfac_ini, grupo_ini
            into ls_codcli, ln_idtipfac, ln_grupo
            from inssrv
           where numslc = ls_numslc;

          --se busca servicio principal registrado en la tabgrupo
          select idisprincipal
            into lr_bilfac.idisprincipal
            from tabgrupo
           where codcli = ls_codcli
             and idtipfac = ln_idtipfac
             and grupo = ln_grupo;

          --se obtiene el nomabr del servicio principal
          select nomabr
            into lr_bilfac.nomabr
            from instanciaservicio
           where idinstserv = lr_bilfac.idisprincipal;
        else
          --fin 15.0
          select idinstserv, nomabr
            into lr_bilfac.idisprincipal, lr_bilfac.nomabr
            from instanciaservicio
           where codinssrv in (select codinssrv
                                 from reginsdth
                                where numregistro = ac_numreg);
          --ini 15.0
        end if;
        --fin 15.0
      exception
        when others then
          lr_bilfac.idisprincipal := null;
          lr_bilfac.nomabr        := null;
      end;

      --Buscar si documento existe
      select sq_idbilfac.nextval into lr_bilfac.idbilfac from dummy_ope;

      insert into bilfac
        (idbilfac,
         codcli,
         cicfac,
         idcon,
         tipfac,
         grupo,
         estfac,
         idisprincipal,
         nomcli,
         observ,
         tipo_doc_ide,
         nro_doc_ide,
         grp_cliente,
         codect,
         tot_cargos,
         tot_moras,
         tot_descuento,
         sub_total,
         impuestos,
         tot_cargyabo,
         total_fac,
         saldo_fac,
         retefuente,
         reteiva,
         reteica,
         saldo_ant,
         abonos,
         fact_actual,
         nuevo_saldo,
         tipo_contrato,
         nro_contrato,
         tipo_fac,
         tipo_doc_fac,
         numser,
         numsut,
         fecini,
         fecfin,
         fecemi,
         fecven,
         feccan,
         flag_carcta,
         moneda,
         dircli,
         dirfac,
         codubifac,
         idjurisdiccion,
         montonoafecto,
         montoapagar,
         tipocambio,
         tipocambioorigen,
         flgcartera,
         flgconta,
         flghotbill,
         tottlf,
         flgimpresion,
         pago_adel,
         idfaccxc,
         numpag,
         idfacade,
         financiacion,
         cuotames,
         totcuotasmescli,
         totfinancpendcli,
         total_fco,
         total_igv_fco,
         subtotal_fco,
         flgfco,
         total_propio,
         total_igv_propio,
         subtotal_propio,
         simbolo_barras,
         idmonedaimpresion,
         flgestadocuenta,
         saldo_dolares,
         codigo_barras,
         idimpuesto,
         tot_bonos,
         tot_bonos_perdidos,
         tot_financmescli,
         alicuota,
         nomreceptor,
         nro_doc_ide2,
         nro_doc_ide3,
         nomvia,
         numvia,
         interior,
         nomurb,
         idbilfacorig,
         tot_ajustefac,
         codubi,
         tot_multas,
         tipvia,
         codsucfac,
         numboleto,
         numano,
         nummes,
         idformapago,
         nomabr,
         idbilfacpadre,
         idoperador,
         idclasedoc,
         codusu,
         fecusu,
         hashcode,
         flgabono)
      values
        (lr_bilfac.idbilfac,
         ac_codcli, --CODCLI
         0, -- Cicfac
         lr_bilfac.idcon,
         lr_bilfac.tipfac,
         lr_bilfac.grupo,
         '01',
         lr_bilfac.idisprincipal, --IDISPRINCIPAL
         lr_bilfac.nomcli,
         '', --OBSERV
         lr_bilfac.tipo_doc_ide,
         lr_bilfac.nro_doc_ide,
         null, --GRP_CLIENTE
         null, --CODECT
         0, -- TOT_CARGOS
         0, -- TOT_MORAS
         0, -- TOT_DESCUENTO
         0, -- SUB_TOTAL
         0, -- IMPUESTOS
         0, -- TOT_CARGYABO
         0, --TOTAL_FAC
         0, --SALDO_FAC
         0, --RETEFUENTE
         0, --RETEIVA
         0, --RETEICA
         0, --SALDO_ANT
         0, --ABONOS
         0, --FACT_ACTUAL
         0, --NUEVO_SALDO
         null, --TIPO_CONTRATO
         null, --NRO_CONTRATO
         lr_bilfac.tipfac, --TIPO_FAC
         lr_bilfac.tipo_doc_fac,
         ac_sersut, --NUMSER
         ac_numsut, --NUMSUT
         null, --FECINI
         null, --FECFIN
         trunc(sysdate), --FECEMI
         trunc(sysdate) + ln_cndpag, --FECVEN
         null, --FECCAN
         '0', --FLAG_CARCTA
         lr_bilfac.moneda, --MONEDA
         lr_bilfac.dircli, --DIRCLI
         lr_bilfac.dircli, --DIRFAC
         lr_bilfac.codubi, --CODUBIFAC
         lr_bilfac.idjurisdiccion,
         0, --MONTONOAFECTO
         0, --MONTOAPAGAR
         lr_bilfac.tipocambio,
         lr_bilfac.tipocambioorigen,
         0, --FLGCARTERA
         0, --FLGCONTA
         1, --FLGHOTBILL
         0, --TOTTLF
         0, --FLGIMPRESION
         0, --PAGO_ADEL
         null, --IDFACCXC
         1, --NUMPAG
         null, --IDFACADE
         0, --FINANCIACION
         0, --CUOTAMES
         0, --TOTCUOTASMESCLI
         0, --TOTFINANCPENDCLI
         0, --TOTAL_FCO
         0, --TOTAL_IGV_FCO
         0, --SUBTOTAL_FCO
         0, --FLGFCO
         0, --TOTAL_PROPIO
         0, --TOTAL_IGV_PROPIO
         0, --SUBTOTAL_PROPIO
         null, --SIMBOLO_BARRAS
         1, --IDMONEDAIMPRESION
         1, --FLGESTADOCUENTA
         0, --SALDO_DOLARES
         null, --CODIGO_BARRAS
         lr_bilfac.idimpuesto,
         0, --TOT_BONOS
         0, --TOT_BONOS_PERDIDOS
         0, --TOT_FINANCMESCLI
         lr_bilfac.alicuota,
         null, --NOMRECEPTOR
         lv_ntdide_comp,
         lr_bilfac.nro_doc_ide3,
         lr_bilfac.nomvia,
         lr_bilfac.numvia,
         lr_bilfac.interior,
         lr_bilfac.nomurb,
         null, --IDBILFACORIG
         0, --TOT_AJUSTEFAC
         lr_bilfac.codubi,
         0, --TOT_MULTAS
         lr_bilfac.tipvia,
         lc_codsuc,
         null, --NUMBOLETO
         to_char(sysdate, 'yyyy'), --NUMANO
         to_char(sysdate, 'mm'), --NUMMES
         1, --IDFORMAPAGO
         lr_bilfac.nomabr, --NOMABR
         lr_bilfac.idbilfac, --IDBILFACPADRE
         null, --IDOPERADOR,
         1, --IDCLASEDOC
         user, --CODUSU
         sysdate, --FECUSU
         null,
         1); -- FLAGABONO

      ln_monto := round(f_resta_impuesto(an_monto, lr_bilfac.idimpuesto), 4);

      --ini 15.0
      if ln_num_rec > 0 then

        --se obtiene el id de la recarga
        select idrecarga, idvigencia, monto_ori --<21.0>
          into ln_idrecarga, ln_idvigencia, ln_monto_ori --<21.0>
          from cxctabfac_web
         where codcli = lc_codigorecarga
           and sersut = ac_sersut
           and numsut = ac_numsut;

        --21.0 Suma de Cargos
        If ln_idrecarga is null then
          for r_conceptos in c_conceptos_sdc(ac_numreg, ln_idvigencia) loop
            --se prorratea el monto para el servicio si hay promociones
            ln_monto_srv := an_monto * nvl(r_conceptos.montoserv, an_monto) /
                            nvl(r_conceptos.monto, an_monto);
            --se resta el impuesto al monto del servicio
            ln_monto := round(f_resta_impuesto(ln_monto_srv,
                                               lr_bilfac.idimpuesto),
                              4);

            ln_idseccnr := pq_cnr.f_set_val_libre(r_conceptos.idcnr, --idcnr
                                                  lr_bilfac.codcli, --codcli
                                                  lr_bilfac.codcli, --IDCOD
                                                  1, --nivel
                                                  ad_feccargo, -- Fecha del cargo
                                                  cn_cntcupon, -- cantidad
                                                  ln_monto, --monto para el servicio
                                                  lr_bilfac.moneda, -- Precio unitario
                                                  r_conceptos.idinstprod,
                                                  ad_desde,
                                                  ad_hasta);

            update cnr
               set idbilfac = lr_bilfac.idbilfac,
                   idcon    = lr_bilfac.idcon,
                   idtipfac = lr_bilfac.tipfac,
                   estado   = 5
             where idseccnr = ln_idseccnr;

          end loop;

        else
          --21.0 Paquetes sin suma de cargo
          for r_conceptos in c_conceptos(ac_numreg, ln_idrecarga) loop
            --se prorratea el monto para el servicio si hay promociones
            ln_monto_srv := an_monto * nvl(r_conceptos.montoserv, an_monto) /
                            nvl(r_conceptos.monto, an_monto);
            --se resta el impuesto al monto del servicio
            ln_monto := round(f_resta_impuesto(ln_monto_srv,
                                               lr_bilfac.idimpuesto),
                              4);

            ln_idseccnr := pq_cnr.f_set_val_libre(r_conceptos.idcnr, --idcnr
                                                  lr_bilfac.codcli, --codcli
                                                  lr_bilfac.codcli, --IDCOD
                                                  1, --nivel
                                                  ad_feccargo, -- Fecha del cargo
                                                  cn_cntcupon, -- cantidad
                                                  ln_monto, --monto para el servicio
                                                  lr_bilfac.moneda, -- Precio unitario
                                                  r_conceptos.idinstprod,
                                                  ad_desde,
                                                  ad_hasta);

            update cnr
               set idbilfac = lr_bilfac.idbilfac,
                   idcon    = lr_bilfac.idcon,
                   idtipfac = lr_bilfac.tipfac,
                   estado   = 5
             where idseccnr = ln_idseccnr;

          end loop;
        end if;
      else
        --fin 15.0
        ln_idseccnr := pq_cnr.f_set_val_libre(f_parametrosfac(720), --idcnr number,
                                              lr_bilfac.codcli, --codcli
                                              lr_bilfac.codcli, --IDCOD
                                              1, --nivel
                                              ad_feccargo, -- Fecha del cargo
                                              cn_cntcupon, -- cantidad
                                              ln_monto,
                                              lr_bilfac.moneda, -- Precio unitario
                                              an_idinstprod,
                                              ad_desde,
                                              ad_hasta);

        update cnr
           set idbilfac = lr_bilfac.idbilfac,
               idcon    = lr_bilfac.idcon,
               idtipfac = lr_bilfac.tipfac,
               estado   = 5
         where idseccnr = ln_idseccnr;
        --ini 15.0
      end if;
      --fin 15.0
      item          := 1;
      ln_tot_cargos := 0;

      for r_cnr in c_cnr(lr_bilfac.idbilfac) loop
        select sq_idseccpto.nextval into ln_idseccpto from dummy_ope;

        insert into cptoxfac
          (idseccpto,
           idbilfac,
           ordsec,
           subordsec,
           idcpto,
           dsccpto,
           muestramonto,
           muestractd1,
           muestractd2,
           sangria,
           nuevalinea,
           nivelagrup,
           nvalinxgrupo,
           requieredetalle,
           tarifa,
           cantidad,
           valcpto,
           idproducto,
           idtipfac,
           idcon,
           idmoneda,
           muestratarifa,
           codsrv, --<21.0>
           idplataforma --<21.0>
           )
        values
          (ln_idseccpto,
           lr_bilfac.idbilfac,
           item,
           1,
           r_cnr.idcpto,
           (select dsccpto from conceptofac where idcpto = r_cnr.idcpto), --(r_cnr.dscconcepto,
           1,
           1,
           0,
           0,
           0,
           0,
           0,
           0,
           r_cnr.tarifa,
           r_cnr.cantidad,
           r_cnr.monto,
           r_cnr.idproducto,
           lr_bilfac.tipfac,
           lr_bilfac.idcon,
           lr_bilfac.moneda,
           1,
           nvl(r_cnr.codsrv,lv_codsrv), --<21.0>
           nvl(r_cnr.idplataforma,pq_sicorp.f_plataforma_default(nvl(r_cnr.codsrv,lv_codsrv)))--<21.0>
           );

        update cnr
           set idseccpto = ln_idseccpto
         where idseccnr = r_cnr.idseccnr;

        ln_tot_cargos := ln_tot_cargos + r_cnr.monto;
        item          := item + 1;

      end loop;

      ln_subtotal  := round(ln_tot_cargos, 4);
      ln_impuestos := round(lr_bilfac.alicuota * round(ln_tot_cargos, 4) / 100,
                            4);
      ln_total_fac := ln_impuestos + ln_subtotal;

      update bilfac b
         set tot_cargos  = ln_tot_cargos,
             sub_total   = ln_subtotal,
             impuestos   = ln_impuestos,
             total_fac   = ln_total_fac,
             saldo_fac   = ln_total_fac,
             fact_actual = ln_total_fac,
             nuevo_saldo = ln_total_fac,
             montoapagar = ln_total_fac
       where idbilfac = lr_bilfac.idbilfac;

      update bilfac b
         set estfac = '02'
       where idbilfac = lr_bilfac.idbilfac;

      an_idbilfac := lr_bilfac.idbilfac;
    exception
      when others then
        an_error   := 1;
        ac_mensaje := sqlerrm;
    end;

  end;

  --</req id='113186'>

  --<9.0
  procedure p_activacion_dth(an_codsolot in solot.codsolot%type,
                             an_rpta     out number,
                             ac_mensaje  out char) is

    lc_resultado        varchar2(10);
    lc_fecini           varchar2(12);
    lc_fecfin           varchar2(12);
  lc_fecfin_rotacion varchar2(12);--38.0
    --Ini 30
    lc_despareo         varchar2(15);
    lc_numconaxdespareo varchar2(6);
    --Fin 30
    lc_mensaje          varchar2(4000);
    lc_despareoenv      varchar2(30);
    --ini 14.0
    /*lc_bouquets         varchar2(100);*/
    lc_bouquets tystabsrv.codigo_ext%type;
    --fin 14.0
    lc_codext          varchar2(8);
    lc_nombre          varchar2(15);
    lc_archivolocalenv varchar2(30);
    lc_cntdeco         char(6);
    lc_numconax        char(6);
    lc_cnttarjeta      char(6);
    ln_cantidad        number;
    ln_idpaq           number;
    ln_cntdeco         number;
    ln_numtransacconax number;
    ln_largo           number;
    ln_numbouquets     number;
    ln_cnttarjeta      number;
    ln_rpta            number;
    ln_cntdif          number;
    lr_reginsdth       reginsdth%rowtype;
    lc_numregistro     reginsdth.numregistro%type;
    lc_numslc          vtatabslcfac.numslc%type;
    p_text_io          utl_file.file_type;
    p_text_io_des      utl_file.file_type;
    ln_cntdeco_ant     number;
    ln_cnttarjeta_ant  number;
    error_activacion exception;
    --ini 16.0
    error_crear_archivo_despareo exception;
    error_escribir_arch_despareo exception;
    error_envio_archivo_despareo exception;
    error_crear_archivo exception;
    error_escribir_archivo exception;
    error_envio_archivo exception;
    error_crear_archivo_adic exception;
    error_escribir_archivo_adic exception;
    error_envio_archivo_adic exception;
    error_registro exception;
    error_numregitro exception;
    error_numslc exception;
    ln_tipo_error varchar2(100);
    ln_obt_tp      number;  --30.0
    connex_i operacion.conex_intraway;  --37.0

    --fin 16.0
    --Cursor de Codigos Externos(Códigos de Bouquets) de la Configuración del paquete.
    cursor c_codigo_ext is
      select distinct tystabsrv.codigo_ext, tystabsrv.codsrv
        from paquete_venta,
             detalle_paquete,
             linea_paquete,
             producto,
             tystabsrv
       where paquete_venta.idpaq = ln_idpaq
         and paquete_venta.idpaq = detalle_paquete.idpaq
         and detalle_paquete.iddet = linea_paquete.iddet
         and detalle_paquete.idproducto = producto.idproducto
         and detalle_paquete.flgestado = 1
         and linea_paquete.flgestado = 1
            --and producto.tipsrv = '0062'
         and producto.tipsrv =
             (select valor from constante where constante = 'FAM_CABLE')
         and linea_paquete.codsrv = tystabsrv.codsrv
         and tystabsrv.codigo_ext is not null;

    --Servicio Principal
    cursor c_codigos_ext_ventas_princ is
      select t.codigo_ext, t.codsrv
        from vtadetptoenl v, tystabsrv t
       where v.numslc = lc_numslc
         and v.flgsrv_pri = 1
         and v.codsrv = t.codsrv
         and t.tipsrv =
             (select valor from constante where constante = 'FAM_CABLE')
         and t.codigo_ext is not null;

    --Servicios Adicionales
    cursor c_codigos_ext_ventas_adic is
      select t.codigo_ext, t.codsrv
        from vtadetptoenl v, tystabsrv t
       where v.numslc = lc_numslc
         and v.flgsrv_pri = 0
         and v.codsrv = t.codsrv
         and t.tipsrv =
             (select valor from constante where constante = 'FAM_CABLE')
         and t.codigo_ext is not null;

    --Cursor de Decodificadores para el despareo
    cursor c_unitaddress is
      select unitaddress
        from operacion.ope_envio_conax
       where codsolot = an_codsolot
         and unitaddress is not null
         and codigo = 2 --13.0 --tipo decodificador
         and estado = 0;

    --Cursor de Tarjetas
    cursor c_tarjetas is
      select serie
        from operacion.ope_envio_conax
       where codsolot = an_codsolot
         and serie is not null
         and codigo = 1 --13.0 --tipo tarjeta
         and estado = 0;

  begin
    connex_i :=operacion.pq_dth.f_crea_conexion_intraway;  --37.0

    lc_resultado := 'OK';
    --ini 16.0
    an_rpta := 1;
    --fin 16.0
    select to_char(trunc(new_time(sysdate, 'EST', 'GMT'), 'MM'), 'yyyymmdd') ||
           '0000'
      into lc_fecini
      from dummy_ope;
--ini 38.0
   /* select to_char(trunc(last_day(new_time(sysdate, 'EST', 'GMT'))),
                   'yyyymmdd') || '0000'
      into p_fecfin
      from dummy_ope;
    */

 select TO_CHAR(c.Valor)
  INTO lc_fecfin_rotacion

  from constante c WHERE C.CONSTANTE='DTHROTACION';

   select
    to_char(trunc(new_time(lc_fecfin_rotacion, 'EST', 'GMT')),
                         'yyyymmdd') || '0000' into lc_fecfin from dual;


  if(to_char(trunc(sysdate), 'DD/MM/YYYY')=lc_fecfin_rotacion) then
    select add_months(lc_fecfin_rotacion,12)
    into lc_fecfin_rotacion from dual;

    update constante set valor=lc_fecfin_rotacion
    WHERE CONSTANTE='DTHROTACION';
    commit;

   select
    to_char(trunc(new_time(lc_fecfin_rotacion, 'EST', 'GMT')),
                         'yyyymmdd') || '0000' into lc_fecfin from dual;

  end if;--fin 38.0

    -- VALIDAR QUE NUMSERIE O UNITADDRESS NO SEAN NULOS
    --ini 15.0
    /*p_val_datos_dth(an_codsolot, ln_rpta);

    if ln_rpta = 0 then
      ac_mensaje := 'Error: Se debe ingresar # de Serie y Unitaddress de los equipos actuales';
      raise error_activacion;
    end if;*/
    --fin 15.0
    -- OBTIENER NUMREGISTRO DE LA TABLA REGINSDTH

    p_get_numregistro(an_codsolot, lc_numregistro);
    --ini 16.0
    if lc_numregistro is null then
      raise error_numregitro;
    end if;
    --fin 16.0
    -- VALIDAR SI ES ALTA, BAJA O NINGUNO
    --ini 15.0
    --p_valtipo_cambio_conax(an_codsolot, ln_rpta, ln_cntdif, lc_mensaje);
    --fin 15.0
    -- ELIMINAR BOUQUETS
    delete operacion.bouquetxreginsdth where numregistro = lc_numregistro;

    -- ELIMINAR REGISTROS DE ENVIO SI EXISTEN
    select count(*)
      into ln_cantidad
      from operacion.reg_archivos_enviados
     where numregins = lc_numregistro;
    if ln_cantidad > 0 then
      delete operacion.reg_archivos_enviados
       where numregins = lc_numregistro;
    end if;

    -- SI EXISTE UNA DIFERENCIA EN LA CANTIDAD DE EQUIPOS
    --ini 15.0
    --if ln_cntdif > 0 then
    --fin 15.0
    -- OBTENER PROYECTO
    select numslc into lc_numslc from solot where codsolot = an_codsolot;
    --ini 16.0
    if lc_numslc is null then
      raise error_numslc;
    end if;
    --fin 16.0
    -- OBTENER PAQUETE
    select distinct idpaq
      into ln_idpaq
      from vtadetptoenl
     where numslc = lc_numslc;

    --ini 16.0
    -- OBTENER NUMREGISTRO DTH
    /*p_get_numregistro(an_codsolot, lc_numregistro);*/
    --fin 16.0
    -- 1.CREACION DE ARCHIVO DE DESPAREO DEL EQUIPO

    --ini 30.0
      lc_despareo:= f_genera_nombre_archivo(0,'gp');
    --fin 30.0
      --lc_numconaxdespareo:=lpad(substr(lc_despareo, 4, 5),6,'0');
      lc_numconaxdespareo:=lpad(substr(lc_despareo, 3, 8),6,'0');--31.0
        /*     select operacion.sq_filename_arch_env.nextval
      into lc_numconaxdespareo
      from dummy_ope;*/
/*    lc_numconaxdespareo := lpad(lc_numconaxdespareo, 6, '0');
    lc_despareo         := 'gp' || lc_numconaxdespareo || '.emm';*/


    --ABRE EL ARCHIVO
    operacion.pq_dth_interfaz.p_abrir_archivo(p_text_io_des,
                                              connex_i.pdirectorioLocal, --37.0
                                              lc_despareo,
                                              'W',
                                              lc_resultado,
                                              lc_mensaje);

    --ini 16.0
    if lc_resultado <> 'OK' then
      raise error_crear_archivo_despareo;
    end if;

    begin
      --fin 16.0
      --ESCRIBE EN EL ARCHIVO
      operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des, '01', '1');
      operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des,
                                                lc_numconaxdespareo,
                                                '1');
      operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des,
                                                '00001001',
                                                '1');
      operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des, 'U', '1');
      operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des, 'U', '1');
      operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des, 'U', '1');
      operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des, 'U', '1');
      operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des, 'U', '1');
      operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des, 'EMM', '1');

      select nvl(sum(a.cantidad), 0)
        into ln_cntdeco_ant
        from solotptoequ a,
             solot       b,
             solotpto    d,
             tipequ      f,
             almtabmat   g,
             tiptrabajo  h,
             inssrv      i,
             --<12.0
             --tipequdth   t
             (select a.codigon tipequope, codigoc grupoequ
                from opedd a, tipopedd b
               where a.tipopedd = b.tipopedd
                 and b.abrev = 'TIPEQU_DTH_CONAX') t
      --12.0>
       where a.codsolot = b.codsolot
         and a.codsolot = d.codsolot
         and i.codinssrv = d.codinssrv
         and a.punto = d.punto
         and a.tipequ = f.tipequ
         and f.codtipequ = g.codmat
         and b.tiptra = h.tiptra
         and not d.codsolot = an_codsolot
         and i.codinssrv in (select distinct codinssrv
                               from solotpto
                              where codsolot = an_codsolot)
         and i.tipsrv =
             (select valor from constante where constante = 'FAM_CABLE')
         and t.tipequope = a.tipequ --12.0
            --and a.codequcom = t.codequcom  --12.0
            --and t.grupoequ = 2; --Grupo Decodificadores --12.0
         and t.grupoequ = '2'; --Grupo Decodificadores --12.0

      select nvl(sum(a.cantidad), 0)
        into ln_cntdeco
        from solotptoequ a,
             solot       b,
             solotpto    d,
             tipequ      f,
             almtabmat   g,
             tiptrabajo  h,
             inssrv      i,
             --<12.0
             --tipequdth   t
             (select a.codigon tipequope, codigoc grupoequ
                from opedd a, tipopedd b
               where a.tipopedd = b.tipopedd
                 and b.abrev = 'TIPEQU_DTH_CONAX') t
      --12.0>
       where a.codsolot = b.codsolot
         and a.codsolot = d.codsolot
         and i.codinssrv = d.codinssrv
         and a.punto = d.punto
         and a.tipequ = f.tipequ
         and f.codtipequ = g.codmat
         and b.tiptra = h.tiptra
         and d.codsolot = an_codsolot
         and i.codinssrv in (select distinct codinssrv
                               from solotpto
                              where codsolot = an_codsolot)
         and i.tipsrv =
             (select valor from constante where constante = 'FAM_CABLE')
         and t.tipequope = a.tipequ --12.0
            --and a.codequcom = t.codequcom --12.0
            --and t.grupoequ = 2; --Grupo Decodificadores --12.0
         and t.grupoequ = '2'; --Grupo Decodificadores --12.0

      lc_cntdeco := lpad(ln_cntdeco - ln_cntdeco_ant, 6, '0');

      operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des,
                                                lc_cntdeco,
                                                '1');

      for c_ua in c_unitaddress loop
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des,
                                                  trim(c_ua.unitaddress),
                                                  '1');
      end loop;

      operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des, 'ZZZ', '1');

      --CIERRA EL ARCHIVO DE DESPAREO
      operacion.pq_dth_interfaz.p_cerrar_archivo(p_text_io_des);
      --ini 16.0
    exception
      when others then
        raise error_escribir_arch_despareo;
    end;
    --fin 16.0

    --ENVIO DE ARCHIVO DE DESPAREO
    lc_despareoenv := lc_despareo;
    --ini 16.0
    begin
      --fin 16.0
      operacion.pq_dth_interfaz.p_enviar_archivo_ascii(connex_i.phost, --37.0
                                                       connex_i.ppuerto, --37.0
                                                       connex_i.pusuario, --37.0
                                                       connex_i.ppass, --37.0
                                                       connex_i.pdirectorioLocal, --37.0
                                                       lc_despareoenv,
                                                       connex_i.parchivoremotoreq); --37.0
      --ini 16.0
    exception
      when others then
        raise error_envio_archivo_despareo;
    end;
    --fin 16.0

    begin
      select operacion.sq_numtrans.nextval
        into ln_numtransacconax
        from dummy_ope;

      -- REGISTRO DE ENVIO
      insert into operacion.log_reg_archivos_enviados
        (numregenv,
         numregins,
         filename,
         lastnumregenv,
         tipo_proceso,
         numtrans)
      values
        (lc_numconaxdespareo,
         lc_numregistro,
         lc_despareo,
         lc_numconaxdespareo,
         'D',
         ln_numtransacconax);

      insert into operacion.reg_archivos_enviados
        (numregenv,
         numregins,
         filename,
         estado,
         lastnumregenv,
         tipo_proceso,
         numtrans)
      values
        (lc_numconaxdespareo,
         lc_numregistro,
         lc_despareo,
         1,
         lc_numconaxdespareo,
         'D',
         ln_numtransacconax);

    exception
      when others then
        --ini 16.0
        /*ac_mensaje := 'Error al registrar archivos a enviar';
        raise error_activacion;*/
        ln_tipo_error := 1;
        raise error_registro;
        --fin 16.0
        rollback;
    end;

    --Envio de Bouquets para nuevas tarjetas
    for c_cod_ext_vp in c_codigos_ext_ventas_princ loop
      lc_bouquets    := trim(c_cod_ext_vp.codigo_ext);
      ln_largo       := length(lc_bouquets);
      ln_numbouquets := (ln_largo + 1) / 4;

      for i in 1 .. ln_numbouquets loop
        lc_codext := lpad(operacion.f_cb_subcadena2(lc_bouquets, i), 8, '0');

      --ini 30.0
        lc_nombre:= f_genera_nombre_archivo(0,'ps');
        --lc_numconax:=lpad(substr(lc_nombre,4,5),6,'0');
        lc_numconax:=lpad(substr(lc_nombre,3,8),6,'0');--31.0
       --fin 30.0

        /*select operacion.sq_filename_arch_env.nextval
          into ln_numconax
          from dummy_ope;*/

/*        lc_numconax := lpad(ln_numconax, 6, '0');
        lc_nombre   := 'ps' || lc_numconax || '.emm';*/

        -- 2.CREACION DE ARCHIVO DE SOLICITUD DE ACTIVACION DE CABLE SATELITAL

        --ABRE EL ARCHIVO
        operacion.pq_dth_interfaz.p_abrir_archivo(p_text_io,
                                                  connex_i.pdirectorioLocal,
                                                  lc_nombre,
                                                  'W',
                                                  lc_resultado,
                                                  lc_mensaje);
        --ini 16.0
        if lc_resultado <> 'OK' then
          raise error_crear_archivo;
        end if;

        begin
          --fin 16.0
          --ESCRIBE EN EL ARCHIVO
          operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');
          operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                    lc_numconax,
                                                    '1');
          operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                    lc_codext,
                                                    '1');
          operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                    lc_fecini,
                                                    '1');
          operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                    lc_fecfin,
                                                    '1');
          operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');
          operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'EMM', '1');
          operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');

          --contador de tarjetas
          select nvl(sum(a.cantidad), 0)
            into ln_cnttarjeta_ant
            from solotptoequ a,
                 solot       b,
                 solotpto    d,
                 tipequ      f,
                 almtabmat   g,
                 tiptrabajo  h,
                 inssrv      i,
                 --<12.0
                 --tipequdth   t
                 (select a.codigon tipequope, codigoc grupoequ
                    from opedd a, tipopedd b
                   where a.tipopedd = b.tipopedd
                     and b.abrev = 'TIPEQU_DTH_CONAX') t
          --12.0>
           where a.codsolot = b.codsolot
             and a.codsolot = d.codsolot
             and i.codinssrv = d.codinssrv
             and a.punto = d.punto
             and a.tipequ = f.tipequ
             and f.codtipequ = g.codmat
             and b.tiptra = h.tiptra
             and not d.codsolot = an_codsolot
             and i.codinssrv in
                 (select distinct codinssrv
                    from solotpto
                   where codsolot = an_codsolot)
             and i.tipsrv =
                 (select valor from constante where constante = 'FAM_CABLE')
             and t.tipequope = a.tipequ --12.0
                --and a.codequcom = t.codequcom --12.0
                --and t.grupoequ = 1; --Grupo Tarjetas --12.0
             and t.grupoequ = '1'; --Grupo Tarjetas --12.0

          select nvl(sum(a.cantidad), 0)
            into ln_cnttarjeta
            from solotptoequ a,
                 solot       b,
                 solotpto    d,
                 tipequ      f,
                 almtabmat   g,
                 tiptrabajo  h,
                 inssrv      i,
                 --<12.0
                 --tipequdth   t
                 (select a.codigon tipequope, codigoc grupoequ
                    from opedd a, tipopedd b
                   where a.tipopedd = b.tipopedd
                     and b.abrev = 'TIPEQU_DTH_CONAX') t
          --12.0>
           where a.codsolot = b.codsolot
             and a.codsolot = d.codsolot
             and i.codinssrv = d.codinssrv
             and a.punto = d.punto
             and a.tipequ = f.tipequ
             and f.codtipequ = g.codmat
             and b.tiptra = h.tiptra
             and d.codsolot = an_codsolot
             and i.codinssrv in
                 (select distinct codinssrv
                    from solotpto
                   where codsolot = an_codsolot)
             and i.tipsrv =
                 (select valor from constante where constante = 'FAM_CABLE')
             and t.tipequope = a.tipequ --12.0
                --and a.codequcom = t.codequcom --12.0
                --and t.grupoequ = 1; --Grupo Tarjetas --12.0
             and t.grupoequ = '1'; --Grupo Tarjetas --12.0

          lc_cnttarjeta := lpad(ln_cnttarjeta - ln_cnttarjeta_ant, 6, '0');

          operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                    lc_cnttarjeta,
                                                    '1');

          for c_cards in c_tarjetas loop
            operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                      trim(c_cards.serie),
                                                      '1');
          end loop;

          operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'ZZZ', '1');

          --CIERRA EL ARCHIVO DE ACTIVACIÓN
          operacion.pq_dth_interfaz.p_cerrar_archivo(p_text_io);

          --ini 16.0
        exception
          when others then
            raise error_escribir_archivo;
        end;
        --fin 16.0

        begin
          --ENVIO DE ARCHIVO DE ACTIVACION CONAX
          lc_archivolocalenv := lc_nombre;

          operacion.pq_dth_interfaz.p_enviar_archivo_ascii(connex_i.phost, --37.0
                                                           connex_i.ppuerto, --37.0
                                                           connex_i.pusuario, --37.0
                                                           connex_i.ppass, --37.0
                                                           connex_i.pdirectorioLocal, --37.0
                                                           lc_archivolocalenv,
                                                           connex_i.parchivoremotoreq); --37.0

        exception
          when others then
            lc_resultado := 'ERROR1';
            raise error_envio_archivo;
        end;

        begin

          select operacion.sq_numtrans.nextval
            into ln_numtransacconax
            from dummy_ope;

          -- REGISTRO DE ENVIO
          insert into operacion.log_reg_archivos_enviados
            (numregenv,
             numregins,
             filename,
             lastnumregenv,
             codigo_ext,
             tipo_proceso,
             numtrans)
          values
            (lc_numconax,
             lc_numregistro,
             lc_nombre,
             lc_numconax,
             lc_codext,
             'A',
             ln_numtransacconax);

          insert into operacion.reg_archivos_enviados
            (numregenv,
             numregins,
             filename,
             estado,
             lastnumregenv,
             codigo_ext,
             tipo_proceso,
             numtrans)
          values
            (lc_numconax,
             lc_numregistro,
             lc_nombre,
             1,
             lc_numconax,
             lc_codext,
             'A',
             ln_numtransacconax);

        exception
          when others then
            rollback;
            --ini 16.0
            /*ac_mensaje := 'Error al registrar archivos a enviar';
            raise error_activacion;*/
            --fin 16.0
            ln_tipo_error := 2;
            raise error_registro;
        end;
        --ini 16.0
      /*exception
                  when others then
                    lc_resultado := 'ERROR1';
                    raise error_activacion;
                end;*/
      --fin 16.0
      end loop;

      begin
        -- REGISTRAR BOUQUETS
        insert into operacion.bouquetxreginsdth
          (numregistro, codsrv, bouquets, tipo, estado)
        values
          (lc_numregistro,
           c_cod_ext_vp.codsrv,
           c_cod_ext_vp.codigo_ext,
           1,
           1);

      exception
        when others then
          rollback;
          --ini 16.0
          /*ac_mensaje := 'Error al registrar los bouquets';
          raise error_activacion;*/
          ln_tipo_error := 3;
          raise error_registro;
          --fin 16.0
      end;
      an_rpta := 1;

    end loop;

    for c_cod_ext_va in c_codigos_ext_ventas_adic loop

      lc_bouquets    := trim(c_cod_ext_va.codigo_ext);
      ln_largo       := length(lc_bouquets);
      ln_numbouquets := (ln_largo + 1) / 4;

      for i in 1 .. ln_numbouquets loop
        lc_codext := lpad(operacion.f_cb_subcadena2(lc_bouquets, i), 8, '0');

        --ini 30.0
        ln_obt_tp := f_obt_tipo_pago(null, an_codsolot);

        if ln_obt_tp = 2 then
            ac_mensaje   := 'Error al consultar numslc nulo.';
            return;
        end if;

        lc_nombre:= f_genera_nombre_archivo(ln_obt_tp,'ps');
        --lc_numconax:=lpad(substr(lc_nombre,4,5),6,'0');
        lc_numconax:=lpad(substr(lc_nombre,3,8),6,'0');--31.0

        --fin 30.0
        /*select operacion.sq_filename_arch_env.nextval
          into ln_numconax
          from dummy_ope;*/



        /*lc_numconax := lpad(ln_numconax, 6, '0');
        lc_nombre   := 'ps' || lc_numconax || '.emm';*/

        -- 2.CREACION DE ARCHIVO DE SOLICITUD DE ACTIVACION DE CABLE SATELITAL

        --ABRE EL ARCHIVO
        operacion.pq_dth_interfaz.p_abrir_archivo(p_text_io,
                                                  connex_i.pdirectorioLocal, --37.0
                                                  lc_nombre,
                                                  'W',
                                                  lc_resultado,
                                                  lc_mensaje);

        --ini 16.0
        if lc_resultado <> 'OK' then
          raise error_crear_archivo_adic;
        end if;
        --fin 16.0

        --ini 16.0
        begin
          --ESCRIBE EN EL ARCHIVO
          operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');
          operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                    lc_numconax,
                                                    '1');
          operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                    lc_codext,
                                                    '1');
          operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                    lc_fecini,
                                                    '1');
          operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                    lc_fecfin,
                                                    '1');
          operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');
          operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'EMM', '1');
          operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');

          --contador de tarjetas
          --16.0
          --select sum(a.cantidad)
          select nvl(sum(a.cantidad), 0)
          --16.0
            into ln_cnttarjeta
            from solotptoequ a,
                 solot       b,
                 solotpto    d,
                 tipequ      f,
                 almtabmat   g,
                 tiptrabajo  h,
                 inssrv      i,
                 --<12.0
                 --tipequdth   t
                 (select a.codigon tipequope, codigoc grupoequ
                    from opedd a, tipopedd b
                   where a.tipopedd = b.tipopedd
                     and b.abrev = 'TIPEQU_DTH_CONAX') t
          --12.0>
           where a.codsolot = b.codsolot
             and a.codsolot = d.codsolot
             and i.codinssrv = d.codinssrv
             and a.punto = d.punto
             and a.tipequ = f.tipequ
             and f.codtipequ = g.codmat
             and b.tiptra = h.tiptra
                --ini 16.0
                --and not d.codsolot = an_codsolot
             and d.codsolot = an_codsolot
                --fin 16.0
             and i.codinssrv in
                 (select distinct codinssrv
                    from solotpto
                   where codsolot = an_codsolot)
             and i.tipsrv =
                 (select valor from constante where constante = 'FAM_CABLE')
             and t.tipequope = a.tipequ
                --and t.grupoequ = 1; --Grupo Tarjetas --12.0
             and t.grupoequ = '1'; --Grupo Tarjetas --12.0

          lc_cnttarjeta := lpad(ln_cnttarjeta, 6, '0');

          operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                    lc_cnttarjeta,
                                                    '1');

          for c_cards in c_tarjetas loop
            operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                      trim(c_cards.serie),
                                                      '1');
          end loop;

          operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'ZZZ', '1');

          --CIERRA EL ARCHIVO DE ACTIVACIÓN
          operacion.pq_dth_interfaz.p_cerrar_archivo(p_text_io);

          --ini 16.0
        exception
          when others then
            raise error_escribir_archivo_adic;
        end;
        --fin 16.0
        --ini 16.0
        begin
          --fin 16.0
          --ENVIO DE ARCHIVO DE ACTIVACION CONAX
          lc_archivolocalenv := lc_nombre;

          operacion.pq_dth_interfaz.p_enviar_archivo_ascii(connex_i.phost, --37.0
                                                           connex_i.ppuerto, --37.0
                                                           connex_i.pusuario, --37.0
                                                           connex_i.ppass, --37.0
                                                           connex_i.pdirectorioLocal, --37.0
                                                           lc_archivolocalenv,
                                                           connex_i.parchivoremotoreq); --37.0
          --ini 16.0
        exception
          when others then
            --ini 16.0
            /*ac_mensaje := 'Error al registrar archivos a enviar';*/
            --fin 16.0
            raise error_envio_archivo_adic;
        end;
        --fin 16.0
        begin
          select operacion.sq_numtrans.nextval
            into ln_numtransacconax
            from dummy_ope;

          -- REGISTRO DE ENVIO
          insert into operacion.log_reg_archivos_enviados
            (numregenv,
             numregins,
             filename,
             lastnumregenv,
             codigo_ext,
             tipo_proceso,
             numtrans)
          values
            (lc_numconax,
             lc_numregistro,
             lc_nombre,
             lc_numconax,
             lc_codext,
             'A',
             ln_numtransacconax);

          insert into operacion.reg_archivos_enviados
            (numregenv,
             numregins,
             filename,
             estado,
             lastnumregenv,
             codigo_ext,
             tipo_proceso,
             numtrans)
          values
            (lc_numconax,
             lc_numregistro,
             lc_nombre,
             1,
             lc_numconax,
             lc_codext,
             'A',
             ln_numtransacconax);
        exception
          when others then
            rollback;
            --ini 16.0
            /*ac_mensaje := 'Error al registrar archivos a enviar';*/
            ln_tipo_error := 4;
            raise error_registro;
            --fin 16.0
        end;
        --ini 16.0
      /*exception
                  when others then
                    ac_mensaje := 'Error al registrar archivos a enviar';
                    raise error_activacion;
                end;*/
      --fin 16.0
      end loop;

      begin

        -- REGISTRAR BOUQUETS
        insert into operacion.bouquetxreginsdth
          (numregistro, codsrv, bouquets, tipo, estado)
        values
          (lc_numregistro,
           c_cod_ext_va.codsrv,
           c_cod_ext_va.codigo_ext,
           0,
           1);

      exception
        when others then
          rollback;
          --ini 16.0
          /*ac_mensaje := 'Error al registrar los bouquets';*/
          ln_tipo_error := 5;
          raise error_registro;
          --fin 16.0
      end;
      an_rpta := 1;
    end loop;
    --ini 15.0
    --end if;
    --fin 15.0
    --Verificar Bouquets
    --p_verificar_bouquets(an_codsolot, ln_cntdif, an_rpta);--12.0, no requerido

    commit;
  exception
    --ini 16.0
    /*when error_activacion then
    rollback;
    an_rpta := 0;
    commit;*/
    when error_registro then
      rollback;
      an_rpta := 0;

      if ln_tipo_error = 1 then
        ac_mensaje := 'Error al registrar archivo de despareo enviado al CONAX.';
      elsif ln_tipo_error = 2 then
        ac_mensaje := 'Error al registrar archivos de activación enviados al CONAX';
      elsif ln_tipo_error = 3 then
        ac_mensaje := 'Error al registrar los bouquets enviados al CONAX';
      elsif ln_tipo_error = 4 then
        ac_mensaje := 'Error al registrar archivos de activación adicionales enviados al CONAX.';
      elsif ln_tipo_error = 5 then
        ac_mensaje := 'Error al registrar los bouquets adicionales enviados al CONAX.';
      end if;
      commit;
    when error_crear_archivo_despareo then
      rollback;
      ac_mensaje := 'Error al crear archivo de despareo.';
      an_rpta    := 0;
    when error_escribir_arch_despareo then
      rollback;
      ac_mensaje := 'Error al generar archivo de despareo.';
      an_rpta    := 0;
    when error_envio_archivo_despareo then
      rollback;
      ac_mensaje := 'Error al enviar archivo de despareo.';
      an_rpta    := 0;
    when error_crear_archivo then
      rollback;
      ac_mensaje := 'Error al crear archivo de activación.';
      an_rpta    := 0;
    when error_escribir_archivo then
      rollback;
      ac_mensaje := 'Error al generar archivo de activación.';
      an_rpta    := 0;
    when error_envio_archivo then
      rollback;
      ac_mensaje := 'Error al enviar archivo de activación.';
      an_rpta    := 0;
    when error_crear_archivo_adic then
      rollback;
      ac_mensaje := 'Error al crear archivo adicional de activación.';
      an_rpta    := 0;
    when error_escribir_archivo_adic then
      rollback;
      ac_mensaje := 'Error al generar archivo adicional de activación.';
      an_rpta    := 0;
    when error_envio_archivo_adic then
      rollback;
      ac_mensaje := 'Error al enviar archivo adicional de activación.';
      an_rpta    := 0;
    when error_numregitro then
      rollback;
      ac_mensaje := 'Error al obtener el número de registro.';
      an_rpta    := 0;
    when error_numslc then
      rollback;
      ac_mensaje := 'Error al obtener el proyecto.';
      an_rpta    := 0;
      --fin 16.0
    when others then
      rollback;
      an_rpta := 0;
      --ini 16.0
    /*commit;*/
    --fin 16.0
  end;

  procedure p_verificar_bouquets(an_codsolot in solot.codsolot%type,
                                 an_cntdif   in number,
                                 an_rpta     out number) is

    lc_bouquets_ant    varchar2(1000);
    lc_bouquets_act    varchar2(1000);
    lc_bouquet         varchar2(10);
    lc_codext          varchar2(8);
    lc_resultado       varchar2(10);
    lc_numconax        varchar2(6);
    lc_nombre          varchar2(15);
    lc_mensaje         varchar2(4000);
    lc_fecini          varchar2(12);
    lc_fecfin          varchar2(12);
  lc_fecfin_rotacion varchar2(12);--38.0
    lc_archivolocalenv varchar2(30);
    lc_cnttarjeta      char(6);
    lc_codsrv          char(4);
    ln_verificador     number;
    ln_largo           number;
    ln_numbouquets     number;
    ln_rpta            number;
    ln_cnttarjeta      number;
    ln_numconax        number;
    ln_numtransacconax number;
    ln_codinssrv       number;
    ln_tipo            number;
    ln_contador        number;
    lc_numslc_ant      vtatabslcfac.numslc%type;
    lc_numslc_act      vtatabslcfac.numslc%type;
    lc_numregistro     reginsdth.numregistro%type;
    lc_estado_ini      reginsdth.estado%type;
    lc_estado_fin      reginsdth.estado%type;
    p_text_io          utl_file.file_type;
    p_text_io_des      utl_file.file_type;
    connex_i operacion.conex_intraway;  --37.0
    --ini 15.0
    --ln_num_reginsdth   number;
    --fin 15.0

    --Servicios Principales
    cursor c_bouquets_principal(lc_numslc in vtatabslcfac.numslc%type) is
      select t.codigo_ext, t.codsrv
        from vtadetptoenl v, tystabsrv t
       where v.numslc = lc_numslc
         and v.flgsrv_pri = 1
         and v.codsrv = t.codsrv
         and t.tipsrv =
             (select valor from constante where constante = 'FAM_CABLE')
         and t.codigo_ext is not null;

    --Servicios Adicionales
    cursor c_bouquets_adic(lc_numslc in vtatabslcfac.numslc%type) is
      select t.codigo_ext, t.codsrv
        from vtadetptoenl v, tystabsrv t
       where v.numslc = lc_numslc
         and v.flgsrv_pri = 0
         and v.codsrv = t.codsrv
         and t.tipsrv =
             (select valor from constante where constante = 'FAM_CABLE')
         and t.codigo_ext is not null;

    --Tarjetas Actuales
    cursor c_tarjetas is
      select a.numserie serie
        from solotptoequ a,
             solot       b,
             solotpto    d,
             tipequ      f,
             almtabmat   g,
             tiptrabajo  h,
             inssrv      i,
             --<12.0
             --tipequdth   t
             (select a.codigon tipequope, codigoc grupoequ
                from opedd a, tipopedd b
               where a.tipopedd = b.tipopedd
                 and b.abrev = 'TIPEQU_DTH_CONAX') t
      --12.0>
       where a.codsolot = b.codsolot
         and a.codsolot = d.codsolot
         and i.codinssrv = d.codinssrv
         and a.punto = d.punto
         and a.tipequ = f.tipequ
         and f.codtipequ = g.codmat
         and b.tiptra = h.tiptra
         and not d.codsolot = an_codsolot
         and i.codinssrv in (select distinct codinssrv
                               from solotpto
                              where codsolot = an_codsolot)
         and t.tipequope = a.tipequ --12.0
            --and a.codequcom = t.codequcom --12.0
            --and t.grupoequ = 1 --12.0
         and t.grupoequ = '1' --12.0
         and a.numserie not in
             (select serie
                from operacion.ope_envio_conax
               where codsolot = an_codsolot);

    --Registro Bouquets Activacion
    cursor c_bouquets_actv is
      select t.codsrv codsrv, v.flgsrv_pri tipo, t.codigo_ext bouquets
        into lc_codsrv, ln_tipo, lc_bouquets_act
        from vtadetptoenl v, tystabsrv t
       where v.numslc = lc_numslc_act
         and v.codsrv = t.codsrv
         and t.tipsrv =
             (select valor from constante where constante = 'FAM_CABLE')
         and t.codsrv in (select codsrv
                            from operacion.ope_envio_conax
                           where codsolot = an_codsolot
                             and tipo = 3)
         and t.codigo_ext is not null;

    --Registro Bouquets Desactivacion
    cursor c_bouquets_dsctv is
      select t.codsrv codsrv, v.flgsrv_pri tipo, t.codigo_ext bouquets
        into lc_codsrv, ln_tipo, lc_bouquets_act
        from vtadetptoenl v, tystabsrv t
       where v.numslc = lc_numslc_act
         and v.flgsrv_pri = 0
         and v.codsrv = t.codsrv
         and t.tipsrv =
             (select valor from constante where constante = 'FAM_CABLE')
         and t.codsrv in (select codsrv
                            from operacion.ope_envio_conax
                           where codsolot = an_codsolot
                             and tipo = 4)
         and t.codigo_ext is not null;

  begin
    connex_i :=operacion.pq_dth.f_crea_conexion_intraway;  --37.0

    select to_char(trunc(new_time(sysdate, 'EST', 'GMT'), 'MM'), 'yyyymmdd') ||
           '0000'
      into lc_fecini
      from dummy_ope;
--ini 38.0
    /* select to_char(trunc(last_day(new_time(sysdate, 'EST', 'GMT'))),
                   'yyyymmdd') || '0000'
      into p_fecfin
      from dummy_ope;
    */

 select TO_CHAR(c.Valor)
  INTO lc_fecfin_rotacion

  from constante c WHERE C.CONSTANTE='DTHROTACION';

   select
    to_char(trunc(new_time(lc_fecfin_rotacion, 'EST', 'GMT')),
                         'yyyymmdd') || '0000' into lc_fecfin from dual;


  if(to_char(trunc(sysdate), 'DD/MM/YYYY')=lc_fecfin_rotacion) then
    select add_months(lc_fecfin_rotacion,12)
    into lc_fecfin_rotacion from dual;

    update constante set valor=lc_fecfin_rotacion
    WHERE CONSTANTE='DTHROTACION';
    commit;

   select
    to_char(trunc(new_time(lc_fecfin_rotacion, 'EST', 'GMT')),
                         'yyyymmdd') || '0000' into lc_fecfin from dual;

  end if;
--fin 38.0
    select numslc
      into lc_numslc_act
      from solot
     where codsolot = an_codsolot;
    --ini 15.0
    /*select count(*)
     into ln_num_reginsdth
     from reginsdth
    where codsolot = an_codsolot;*/
    --fin 15.0
    begin
      select numslc_ori
        into lc_numslc_ant
        from regvtamentab
       where numslc = lc_numslc_act;
    exception
      when no_data_found then
        lc_numslc_ant := null;
    end;

    --Obtener Registro de Cliente DTH
    p_get_numregistro(an_codsolot, lc_numregistro);
    --ini 15.0
    /*if ln_num_reginsdth > 0 then
      select estado, codinssrv
        into lc_estado_ini, ln_codinssrv
        from reginsdth
       where numregistro = lc_numregistro;
    else*/
    --fin 15.0
    select r.estado, codinssrv
      into lc_estado_ini, ln_codinssrv
    --from recargaproyectocliente r, recargaxinssrv a --12.0
      from ope_srv_recarga_cab r, ope_srv_recarga_det a --12.0
     where r.numregistro = a.numregistro
       and r.numregistro = lc_numregistro
       and a.tipsrv =
           (select valor from constante where constante = 'FAM_CABLE');
    --ini 15.0
    --end if;
    --fin 15.0

    --contador de tarjetas
    select nvl(sum(a.cantidad), 0)
      into ln_cnttarjeta
      from solotptoequ a,
           solot       b,
           solotpto    d,
           tipequ      f,
           almtabmat   g,
           tiptrabajo  h,
           inssrv      i,
           --<12.0
           --tipequdth   t
           (select a.codigon tipequope, codigoc grupoequ
              from opedd a, tipopedd b
             where a.tipopedd = b.tipopedd
               and b.abrev = 'TIPEQU_DTH_CONAX') t
    --12.0>
     where a.codsolot = b.codsolot
       and a.codsolot = d.codsolot
       and i.codinssrv = d.codinssrv
       and a.punto = d.punto
       and a.tipequ = f.tipequ
       and f.codtipequ = g.codmat
       and b.tiptra = h.tiptra
       and not d.codsolot = an_codsolot
       and i.codinssrv in (select distinct codinssrv
                             from solotpto
                            where codsolot = an_codsolot)
       and t.tipequope = a.tipequ --12.0
          --and a.codequcom = t.codequcom --12.0
          --and t.grupoequ = 1; --Grupo Tarjetas --12.0
       and t.grupoequ = '1'; --Grupo Tarjetas --12.0

    lc_bouquets_ant := '';
    lc_bouquets_act := '';

    --Contador Registro
    select count(*)
      into ln_contador
      from operacion.ope_envio_conax
     where codsolot = an_codsolot
       and tipo = 3;

    -- ELIMINAR REGISTRO DE ENVIO CONAX
    if ln_contador > 0 then
      delete operacion.ope_envio_conax
       where codsolot = an_codsolot
         and tipo = 3;
    end if;

    --Nuevos Bouquets Principales
    for c_princ in c_bouquets_principal(lc_numslc_act) loop
      if c_bouquets_principal%rowcount > 1 then
        lc_bouquets_act := trim(lc_bouquets_act) || ',' ||
                           trim(c_princ.codigo_ext);
      else
        lc_bouquets_act := trim(c_princ.codigo_ext);
      end if;
      lc_codsrv := c_princ.codsrv;
    end loop;

    --Antiguos Bouquets Principales
    for c_princ in c_bouquets_principal(lc_numslc_ant) loop
      if c_bouquets_principal%rowcount > 1 then
        lc_bouquets_ant := trim(lc_bouquets_ant) || ',' ||
                           trim(c_princ.codigo_ext);
      else
        lc_bouquets_ant := trim(c_princ.codigo_ext);
      end if;
    end loop;

    --Activacion de Bouquets
    ln_largo       := length(lc_bouquets_act);
    ln_numbouquets := nvl((ln_largo + 1), 0) / 4;
    lc_bouquet     := '';

    for i in 1 .. ln_numbouquets loop

      lc_bouquet := operacion.f_cb_subcadena2(lc_bouquets_act, i);

      select instrb(nvl(lc_bouquets_ant, '   '), lc_bouquet, 1, 1)
        into ln_verificador
        from dummy_ope;

      if ln_verificador = 0 then
        --Enviar nuevo bouquets para tarjetas antiguas
        lc_codext := lpad(lc_bouquet, 8, '0');

       --ini 30.0
       lc_nombre:=f_genera_nombre_archivo(0,'ps');
       --lc_numconax:=lpad(substr(lc_nombre,4,5),6,'0');
       lc_numconax:=lpad(substr(lc_nombre,3,8),6,'0');--31.0
       --fin 30.0

        /*select operacion.sq_filename_arch_env.nextval
          into ln_numconax
          from dummy_ope;*/

       /* lc_numconax := lpad(ln_numconax, 6, '0');
        lc_nombre   := 'ps' || lc_numconax || '.emm';*/

        --ABRE EL ARCHIVO
        operacion.pq_dth_interfaz.p_abrir_archivo(p_text_io,
                                                  connex_i.pdirectorioLocal, --37.0
                                                  lc_nombre,
                                                  'W',
                                                  lc_resultado,
                                                  lc_mensaje);
        --ESCRIBE EN EL ARCHIVO
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                  lc_numconax,
                                                  '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                  lc_codext,
                                                  '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                  lc_fecini,
                                                  '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                  lc_fecfin,
                                                  '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'EMM', '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');

        lc_cnttarjeta := lpad(ln_cnttarjeta, 6, '0');

        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                  lc_cnttarjeta,
                                                  '1');

        for c_cards in c_tarjetas loop
          operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                    trim(c_cards.serie),
                                                    '1');
        end loop;

        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'ZZZ', '1');

        --CIERRA EL ARCHIVO DE ACTIVACIÓN
        operacion.pq_dth_interfaz.p_cerrar_archivo(p_text_io);

        begin

          --ENVIO DE ARCHIVO DE ACTIVACION CONAX
          lc_archivolocalenv := lc_nombre;
          operacion.pq_dth_interfaz.p_enviar_archivo_ascii(connex_i.phost, --37.0
                                                           connex_i.ppuerto, --37.0
                                                           connex_i.pusuario, --37.0
                                                           connex_i.ppass, --37.0
                                                           connex_i.pdirectorioLocal, --37.0
                                                           lc_archivolocalenv,
                                                           connex_i.parchivoremotoreq); --37.0

          begin
            select operacion.sq_numtrans.nextval
              into ln_numtransacconax
              from dummy_ope;

            -- REGISTRO DE ENVIO
            insert into operacion.log_reg_archivos_enviados
              (numregenv,
               numregins,
               filename,
               lastnumregenv,
               codigo_ext,
               tipo_proceso,
               numtrans)
            values
              (lc_numconax,
               lc_numregistro,
               lc_nombre,
               lc_numconax,
               lc_codext,
               'A',
               ln_numtransacconax);

            insert into operacion.reg_archivos_enviados
              (numregenv,
               numregins,
               filename,
               estado,
               lastnumregenv,
               codigo_ext,
               tipo_proceso,
               numtrans)
            values
              (lc_numconax,
               lc_numregistro,
               lc_nombre,
               1,
               lc_numconax,
               lc_codext,
               'A',
               ln_numtransacconax);

            p_ins_envioconax(an_codsolot,
                             ln_codinssrv,
                             3,
                             null,
                             null,
                             lc_bouquet,
                             ln_numtransacconax,
                             null);

          exception
            when others then
              rollback;
          end;

        exception
          when others then
            lc_resultado := 'ERROR1';
        end;

      end if;

    end loop;

    --Cargar Nuevos Bouquets Adicionales
    lc_bouquets_act := '';
    for c_adic in c_bouquets_adic(lc_numslc_act) loop
      if c_bouquets_adic%rowcount > 1 then
        lc_bouquets_act := trim(lc_bouquets_act) || ',' ||
                           trim(c_adic.codigo_ext);
      else
        lc_bouquets_act := trim(c_adic.codigo_ext);
      end if;
    end loop;

    lc_bouquets_ant := '';
    for c_adic in c_bouquets_adic(lc_numslc_ant) loop
      if c_bouquets_adic%rowcount > 1 then
        lc_bouquets_ant := trim(lc_bouquets_ant) || ',' ||
                           trim(c_adic.codigo_ext);
      else
        lc_bouquets_ant := trim(c_adic.codigo_ext);
      end if;
    end loop;

    ln_largo       := length(lc_bouquets_act);
    ln_numbouquets := nvl((ln_largo + 1), 0) / 4;
    lc_bouquet     := '';

    for i in 1 .. ln_numbouquets loop
      lc_bouquet := operacion.f_cb_subcadena2(lc_bouquets_act, i);

      select instrb(nvl(lc_bouquets_ant, '   '), lc_bouquet, 1, 1)
        into ln_verificador
        from dummy_ope;

      if ln_verificador = 0 then
        --Enviar nuevo bouquets para tarjetas antiguas
        lc_codext := lpad(lc_bouquet, 8, '0');
      --ini 30.0
     /*Pre Pago*/
       lc_nombre:=f_genera_nombre_archivo(0,'ps');
       --lc_numconax:=lpad(substr(lc_nombre,4,5),6,'0');
       lc_numconax:=lpad(substr(lc_nombre,3,8),6,'0');--31.0
       --fin 30.0

/*        lc_numconax := lpad(ln_numconax, 6, '0');
        lc_nombre   := 'ps' || lc_numconax || '.emm';*/

        --ABRE EL ARCHIVO
        operacion.pq_dth_interfaz.p_abrir_archivo(p_text_io,
                                                  connex_i.pdirectorioLocal, --37.0
                                                  lc_nombre,
                                                  'W',
                                                  lc_resultado,
                                                  lc_mensaje);
        --ESCRIBE EN EL ARCHIVO
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                  lc_numconax,
                                                  '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                  lc_codext,
                                                  '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                  lc_fecini,
                                                  '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                  lc_fecfin,
                                                  '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'EMM', '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');

        lc_cnttarjeta := lpad(ln_cnttarjeta, 6, '0');

        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                  lc_cnttarjeta,
                                                  '1');

        for c_cards in c_tarjetas loop
          operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                    trim(c_cards.serie),
                                                    '1');
        end loop;

        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'ZZZ', '1');

        --CIERRA EL ARCHIVO DE ACTIVACIÓN
        operacion.pq_dth_interfaz.p_cerrar_archivo(p_text_io);

        begin
          --ENVIO DE ARCHIVO DE ACTIVACION CONAX
          lc_archivolocalenv := lc_nombre;
          operacion.pq_dth_interfaz.p_enviar_archivo_ascii(connex_i.phost, --37.0
                                                           connex_i.ppuerto, --37.0
                                                           connex_i.pusuario, --37.0
                                                           connex_i.ppass, --37.0
                                                           connex_i.pdirectorioLocal, --37.0
                                                           lc_archivolocalenv,
                                                           connex_i.parchivoremotoreq); --37.0

          begin
            select operacion.sq_numtrans.nextval
              into ln_numtransacconax
              from dummy_ope;

            -- REGISTRO DE ENVIO
            insert into operacion.log_reg_archivos_enviados
              (numregenv,
               numregins,
               filename,
               lastnumregenv,
               codigo_ext,
               tipo_proceso,
               numtrans)
            values
              (lc_numconax,
               lc_numregistro,
               lc_nombre,
               lc_numconax,
               lc_codext,
               'A',
               ln_numtransacconax);

            insert into operacion.reg_archivos_enviados
              (numregenv,
               numregins,
               filename,
               estado,
               lastnumregenv,
               codigo_ext,
               tipo_proceso,
               numtrans)
            values
              (lc_numconax,
               lc_numregistro,
               lc_nombre,
               1,
               lc_numconax,
               lc_codext,
               'A',
               ln_numtransacconax);

            p_ins_envioconax(an_codsolot,
                             ln_codinssrv,
                             3,
                             null,
                             null,
                             lc_bouquet,
                             ln_numtransacconax,
                             null);
          exception
            when others then
              rollback;
          end;

        exception
          when others then
            lc_resultado := 'ERROR1';
        end;

      end if;

    end loop;

    if an_cntdif = 0 then
      begin
        for c_bqt in c_bouquets_actv loop

          -- REGISTRAR BOUQUETS
          insert into operacion.bouquetxreginsdth
            (numregistro, codsrv, bouquets, tipo, estado)
          values
            (lc_numregistro, c_bqt.codsrv, c_bqt.bouquets, c_bqt.tipo, 1);

        end loop;
      exception
        when others then
          rollback;
          lc_mensaje := 'Error al registrar los bouquets';
      end;
    end if;

    --Desactivación de Bouquets

    select count(*)
      into ln_contador
      from operacion.ope_envio_conax
     where codsolot = an_codsolot
       and tipo = 4;

    -- ELIMINAR REGISTRO DE ENVIO CONAX
    if ln_contador > 0 then
      delete operacion.ope_envio_conax
       where codsolot = an_codsolot
         and tipo = 4;
    end if;

    --Bouquets Principales
    --Nuevos Bouquets Principales

    lc_bouquets_act := '';
    for c_princ in c_bouquets_principal(lc_numslc_act) loop
      if c_bouquets_principal%rowcount > 1 then
        lc_bouquets_act := trim(lc_bouquets_act) || ',' ||
                           trim(c_princ.codigo_ext);
      else
        lc_bouquets_act := trim(c_princ.codigo_ext);
      end if;
    end loop;

    lc_bouquets_ant := '';
    --Antiguos Bouquets Principales
    for c_princ in c_bouquets_principal(lc_numslc_ant) loop
      if c_bouquets_principal%rowcount > 1 then
        lc_bouquets_ant := trim(lc_bouquets_ant) || ',' ||
                           trim(c_princ.codigo_ext);
      else
        lc_bouquets_ant := trim(c_princ.codigo_ext);
      end if;
    end loop;

    ln_largo       := length(lc_bouquets_ant);
    ln_numbouquets := nvl((ln_largo + 1), 0) / 4;
    lc_bouquet     := '';

    for i in 1 .. ln_numbouquets loop
      lc_bouquet := operacion.f_cb_subcadena2(lc_bouquets_ant, i);

      select instrb(nvl(lc_bouquets_act, '   '), lc_bouquet, 1, 1)
        into ln_verificador
        from dummy_ope;

      if ln_verificador = 0 then

        select operacion.sq_filename_arch_env.nextval
          into ln_numconax
          from dummy_ope;

        lc_codext   := lpad(lc_bouquet, 8, '0');
        --Ini 30
        lc_nombre:=f_genera_nombre_archivo(0,'cs');
        lc_numconax:=lpad(substr(lc_nombre,4,5),6,'0');
        --Fin 30
        --ABRE EL ARCHIVO
        operacion.pq_dth_interfaz.p_abrir_archivo(p_text_io,
                                                  connex_i.pdirectorioLocal, --37.0
                                                  lc_nombre,
                                                  'W',
                                                  lc_resultado,
                                                  lc_mensaje);
        --ESCRIBE EN EL ARCHIVO
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                  lc_numconax,
                                                  '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                  lc_codext,
                                                  '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                  lc_fecini,
                                                  '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                  lc_fecfin,
                                                  '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'EMM', '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');

        for c_cards in c_tarjetas loop
          operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                    trim(c_cards.serie),
                                                    '1');
        end loop;

        lc_cnttarjeta := lpad(ln_cnttarjeta, 6, '0');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                  lc_cnttarjeta,
                                                  '1');

        for c_cards in c_tarjetas loop
          operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                    trim(c_cards.serie),
                                                    '1');
        end loop;

        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'ZZZ', '1');
        --CIERRA EL ARCHIVO DE BAJA DEL SERVICIO DE CABLE SATELITAL
        operacion.pq_dth_interfaz.p_cerrar_archivo(p_text_io);

        begin

          --ENVIO DE ARCHIVO DE BAJA SERVICIO CABLE SATELITAL
          lc_archivolocalenv := lc_nombre;
          operacion.pq_dth_interfaz.p_enviar_archivo_ascii(connex_i.phost, --37.0
                                                           connex_i.ppuerto, --37.0
                                                           connex_i.pusuario, --37.0
                                                           connex_i.ppass, --37.0
                                                           connex_i.pdirectorioLocal, --37.0
                                                           lc_archivolocalenv,
                                                           connex_i.parchivoremotoreq); --37.0

          begin
            select operacion.sq_numtrans.nextval
              into ln_numtransacconax
              from dummy_ope;

            -- REGISTRO DE ENVIO
            insert into operacion.log_reg_archivos_enviados
              (numregenv,
               numregins,
               filename,
               lastnumregenv,
               codigo_ext,
               tipo_proceso,
               numtrans)
            values
              (lc_numconax,
               lc_numregistro,
               lc_nombre,
               lc_numconax,
               lc_codext,
               'B',
               ln_numtransacconax);

            insert into operacion.reg_archivos_enviados
              (numregenv,
               numregins,
               filename,
               estado,
               lastnumregenv,
               codigo_ext,
               tipo_proceso,
               numtrans)
            values
              (lc_numconax,
               lc_numregistro,
               lc_nombre,
               1,
               lc_numconax,
               lc_codext,
               'B',
               ln_numtransacconax);

            p_ins_envioconax(an_codsolot,
                             ln_codinssrv,
                             4,
                             null,
                             null,
                             lc_bouquet,
                             ln_numtransacconax,
                             null);
          exception
            when others then
              rollback;
          end;

        exception
          when others then
            lc_resultado := 'ERROR1';
        end;

      end if;

    end loop;

    --Cargar Bouquets Adicionales

    lc_bouquets_act := '';
    for c_adic in c_bouquets_adic(lc_numslc_act) loop
      if c_bouquets_adic%rowcount > 1 then
        lc_bouquets_act := trim(lc_bouquets_act) || ',' ||
                           trim(c_adic.codigo_ext);
      else
        lc_bouquets_act := trim(c_adic.codigo_ext);
      end if;
    end loop;

    lc_bouquets_ant := '';
    for c_adic in c_bouquets_adic(lc_numslc_ant) loop
      if c_bouquets_adic%rowcount > 1 then
        lc_bouquets_ant := trim(lc_bouquets_ant) || ',' ||
                           trim(c_adic.codigo_ext);
      else
        lc_bouquets_ant := trim(c_adic.codigo_ext);
      end if;
    end loop;

    ln_largo       := length(lc_bouquets_ant);
    ln_numbouquets := nvl((ln_largo + 1), 0) / 4;
    lc_bouquet     := '';

    for i in 1 .. ln_numbouquets loop
      lc_bouquet := operacion.f_cb_subcadena2(lc_bouquets_ant, i);

      select instrb(nvl(lc_bouquets_act, '   '), lc_codext, 1, 1)
        into ln_verificador
        from dummy_ope;

      if ln_verificador = 0 then
        lc_codext := lpad(lc_bouquet, 8, '0');

/*        select operacion.sq_filename_arch_env.nextval
          into ln_numconax
          from dummy_ope;*/

        lc_nombre:=f_genera_nombre_archivo(0,'cs');
        lc_numconax:=lpad(substr(lc_nombre,4,5),6,'0');
/*        lc_numconax := lpad(ln_numconax, 6, '0');
        lc_nombre   := 'cs' || lc_numconax || '.emm';*/

        --ABRE EL ARCHIVO
        operacion.pq_dth_interfaz.p_abrir_archivo(p_text_io,
                                                  connex_i.pdirectorioLocal, --37.0
                                                  lc_nombre,
                                                  'W',
                                                  lc_resultado,
                                                  lc_mensaje);
        --ESCRIBE EN EL ARCHIVO
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                  lc_numconax,
                                                  '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                  lc_codext,
                                                  '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                  lc_fecini,
                                                  '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                  lc_fecfin,
                                                  '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'EMM', '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');

        for c_cards in c_tarjetas loop
          operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                    trim(c_cards.serie),
                                                    '1');
        end loop;

        lc_cnttarjeta := lpad(ln_cnttarjeta, 6, '0');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                  lc_cnttarjeta,
                                                  '1');

        for c_cards in c_tarjetas loop
          operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                    trim(c_cards.serie),
                                                    '1');
        end loop;

        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'ZZZ', '1');

        --CIERRA EL ARCHIVO DE BAJA DEL SERVICIO DE CABLE SATELITAL
        operacion.pq_dth_interfaz.p_cerrar_archivo(p_text_io);

        begin

          --ENVIO DE ARCHIVO DE BAJA SERVICIO CABLE SATELITAL
          lc_archivolocalenv := lc_nombre;
          operacion.pq_dth_interfaz.p_enviar_archivo_ascii(connex_i.phost, --37.0
                                                           connex_i.ppuerto, --37.0
                                                           connex_i.pusuario, --37.0
                                                           connex_i.ppass, --37.0
                                                           connex_i.pdirectorioLocal, --37.0
                                                           lc_archivolocalenv,
                                                           connex_i.parchivoremotoreq); --37.0

          begin
            select operacion.sq_numtrans.nextval
              into ln_numtransacconax
              from dummy_ope;

            -- REGISTRO DE ENVIO
            insert into operacion.log_reg_archivos_enviados
              (numregenv,
               numregins,
               filename,
               lastnumregenv,
               codigo_ext,
               tipo_proceso,
               numtrans)
            values
              (lc_numconax,
               lc_numregistro,
               lc_nombre,
               lc_numconax,
               lc_codext,
               'B',
               ln_numtransacconax);

            insert into operacion.reg_archivos_enviados
              (numregenv,
               numregins,
               filename,
               estado,
               lastnumregenv,
               codigo_ext,
               tipo_proceso,
               numtrans)
            values
              (lc_numconax,
               lc_numregistro,
               lc_nombre,
               1,
               lc_numconax,
               lc_codext,
               'B',
               ln_numtransacconax);

            p_ins_envioconax(an_codsolot,
                             ln_codinssrv,
                             4,
                             null,
                             null,
                             lc_bouquet,
                             ln_numtransacconax,
                             null);

          exception
            when others then
              rollback;
          end;

        exception
          when others then
            lc_resultado := 'ERROR1';
        end;

      end if;

    end loop;

    if an_cntdif = 0 then
      begin
        for c_bqt in c_bouquets_dsctv loop

          -- ACTUALIZAR BOUQUETS
          update bouquetxreginsdth
             set estado = 0, fecultenv = sysdate
           where numregistro = lc_numregistro
             and codsrv = c_bqt.codsrv
             and tipo = 0;

        end loop;

      exception
        when others then
          rollback;
          lc_mensaje := 'Error al registrar los bouquets';
      end;
    end if;

  end;

  procedure p_desactivacion_dth(an_codsolot  in solot.codsolot%type,
                                an_codinssrv in reginsdth.codinssrv%type,
                                ac_rpta      out varchar2,
                                ac_mensaje   out varchar2) is

    lc_fecini          varchar2(12);
    lc_fecfin          varchar2(12);
  lc_fecfin_rotacion varchar2(12);--38.0
    ln_cantidad        number;
    lc_numregistro     reginsdth.numregistro%type;
    p_text_io          utl_file.file_type;
    lc_mensaje         varchar2(4000);
    lc_bouquets        varchar2(100);
    ln_largo           number;
    ln_numbouquets     number;
    lc_codext          varchar2(10);
    lc_numconax        varchar2(6);
    lc_nombre          varchar2(15);
    ln_numtransacconax number;
    ln_canttarjetas    number;
    lc_canttarjetas    varchar2(6);
    ln_idpaq           reginsdth.idpaq%type;
    lc_estado_fin      char(2);
    lc_estado_ini      char(2);
    ln_rpta            number;
    ln_cntdif          number;
    lc_archivolocalenv varchar2(30);
    --ini 15.0
    --ln_num_reginsdth  reginsdth.numregistro%type; --12.0
    --fin 15.0
    connex_i operacion.conex_intraway;  --37.0

    --Cursor de Códigos Externos(Bouquets)
    cursor c_codigo_ext is
      select distinct tystabsrv.codigo_ext
        from paquete_venta,
             detalle_paquete,
             linea_paquete,
             producto,
             tystabsrv
       where paquete_venta.idpaq = ln_idpaq
         and paquete_venta.idpaq = detalle_paquete.idpaq
         and detalle_paquete.iddet = linea_paquete.iddet
         and detalle_paquete.idproducto = producto.idproducto
         and detalle_paquete.flgestado = 1
         and linea_paquete.flgestado = 1
         and detalle_paquete.flgprincipal = 1
            --and producto.tipsrv = '0062' --cable --12.0
         and producto.tipsrv =
             (select valor from constante where constante = 'FAM_CABLE') --12.0
         and linea_paquete.codsrv = tystabsrv.codsrv
         and tystabsrv.codigo_ext is not null;

    --Cursor de Bouquets Adicionales
    cursor c_codigo_ext_bouquet_adic is
      select bouquets, codsrv
        from bouquetxreginsdth
       where tipo = 0
         and estado = 1
         and numregistro = lc_numregistro;

    cursor c_tarjetas is
      select serie
        from operacion.ope_envio_conax
       where codsolot = an_codsolot
         and codinssrv = an_codinssrv
         and codigo = 1 --13.0 --tipo tarjeta
         and estado = 0;

  begin
    connex_i :=operacion.pq_dth.f_crea_conexion_intraway;  --37.0

    ac_rpta       := 'OK';
    lc_estado_fin := '04';

    select to_char(trunc(new_time(sysdate, 'EST', 'GMT'), 'MM'), 'yyyymmdd') ||
           '0000'
      into lc_fecini
      from dummy_ope;

--ini 38.0

  /* select to_char(trunc(last_day(new_time(sysdate, 'EST', 'GMT'))),
                   'yyyymmdd') || '0000'
      into p_fecfin
      from dummy_ope;
    */

 select TO_CHAR(c.Valor)
  INTO lc_fecfin_rotacion

  from constante c WHERE C.CONSTANTE='DTHROTACION';

   select
    to_char(trunc(new_time(lc_fecfin_rotacion, 'EST', 'GMT')),
                         'yyyymmdd') || '0000' into lc_fecfin from dual;


  if(to_char(trunc(sysdate), 'DD/MM/YYYY')=lc_fecfin_rotacion) then
    select add_months(lc_fecfin_rotacion,12)
    into lc_fecfin_rotacion from dual;

    update constante set valor=lc_fecfin_rotacion
    WHERE CONSTANTE='DTHROTACION';
    commit;

   select
    to_char(trunc(new_time(lc_fecfin_rotacion, 'EST', 'GMT')),
                         'yyyymmdd') || '0000' into lc_fecfin from dual;

  end if;
--fin 38.0
    begin

      --Obtener Registro de Cliente DTH
      p_get_numregistro(an_codsolot, lc_numregistro);

      --<12.0
      --ini 15.0
      /*select count(1) into ln_num_reginsdth
      from reginsdth where numregistro = lc_numregistro;*/
      --fin 15.0
      --12.0>

      p_valtipo_cambio_conax(an_codsolot, ln_rpta, ln_cntdif, lc_mensaje);
      --ini 15.0
      /*if ln_num_reginsdth > 0 then --12.0
        select idpaq, estado
          into ln_idpaq, lc_estado_ini
          from reginsdth
         where numregistro = lc_numregistro;
      --<12.0
      else*/
      --fin 15.0
      select idpaq, estado
        into ln_idpaq, lc_estado_ini
        from ope_srv_recarga_cab
       where numregistro = lc_numregistro;
      --ini 15.0
      --end if;
      --fin 15.0
      --12.0>

      --Cantidad de Archivos Enviados
      select count(*)
        into ln_cantidad
        from operacion.reg_archivos_enviados
       where numregins = lc_numregistro;

      -- ELIMINAR REGISTRO DE ENVIO
      if ln_cantidad > 0 then
        delete operacion.reg_archivos_enviados
         where numregins = lc_numregistro;
      end if;

      for c_cod_ext in c_codigo_ext loop
        lc_bouquets    := trim(c_cod_ext.codigo_ext);
        ln_largo       := length(lc_bouquets);
        ln_numbouquets := (ln_largo + 1) / 4;

        for i in 1 .. ln_numbouquets loop
          lc_codext := lpad(operacion.f_cb_subcadena2(lc_bouquets, i),
                            8,
                            '0');
        --ini 30.0
         lc_nombre:=f_genera_nombre_archivo(0,'cs');
         --lc_numconax:=lpad(substr(lc_nombre,4,5),6,'0');
         lc_numconax:=lpad(substr(lc_nombre,3,8),6,'0');--31.0
        --fin 30.0

        /*select operacion.sq_filename_arch_env.nextval
          into ln_numconax
          from dummy_ope;*/


          /*lc_numconax := lpad(ln_numconax, 6, '0');
          lc_nombre   := 'cs' || lc_numconax || '.emm';*/

          --ABRE EL ARCHIVO
          operacion.pq_dth_interfaz.p_abrir_archivo(p_text_io,
                                                    connex_i.pdirectorioLocal, --37.0
                                                    lc_nombre,
                                                    'W',
                                                    ac_rpta,
                                                    lc_mensaje);
          --ESCRIBE EN EL ARCHIVO
          operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');
          operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                    lc_numconax,
                                                    '1');
          operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                    lc_codext,
                                                    '1');
          operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                    lc_fecini,
                                                    '1');
          operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                    lc_fecfin,
                                                    '1');
          operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');
          operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'EMM', '1');
          operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');

          -- # Tarjetas enviadas
          select count(serie)
            into ln_canttarjetas
            from operacion.ope_envio_conax
           where codsolot = an_codsolot
             and codinssrv = an_codinssrv
             and estado = 0;

          lc_canttarjetas := lpad(ln_canttarjetas, 6, '0');
          operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                    lc_canttarjetas,
                                                    '1');

          for c_cards in c_tarjetas loop
            operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                      trim(c_cards.serie),
                                                      '1');
          end loop;

          operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'ZZZ', '1');

          --CIERRA EL ARCHIVO DE BAJA DEL SERVICIO DE CABLE SATELITAL
          operacion.pq_dth_interfaz.p_cerrar_archivo(p_text_io);

          begin

            --ENVIO DE ARCHIVO DE BAJA SERVICIO CABLE SATELITAL
            lc_archivolocalenv := lc_nombre;
            operacion.pq_dth_interfaz.p_enviar_archivo_ascii(connex_i.phost, --37.0
                                                             connex_i.ppuerto, --37.0
                                                             connex_i.pusuario, --37.0
                                                             connex_i.ppass, --37.0
                                                             connex_i.pdirectorioLocal, --37.0
                                                             lc_archivolocalenv,
                                                             connex_i.parchivoremotoreq); --37.0

            begin
              select operacion.sq_numtrans.nextval
                into ln_numtransacconax
                from dummy_ope;

              -- REGISTRO DE ENVIO
              insert into operacion.log_reg_archivos_enviados
                (numregenv,
                 numregins,
                 filename,
                 lastnumregenv,
                 codigo_ext,
                 tipo_proceso,
                 numtrans)
              values
                (lc_numconax,
                 lc_numregistro,
                 lc_nombre,
                 lc_numconax,
                 lc_codext,
                 'B',
                 ln_numtransacconax);

              insert into operacion.reg_archivos_enviados
                (numregenv,
                 numregins,
                 filename,
                 estado,
                 lastnumregenv,
                 codigo_ext,
                 tipo_proceso,
                 numtrans)
              values
                (lc_numconax,
                 lc_numregistro,
                 lc_nombre,
                 1,
                 lc_numconax,
                 lc_codext,
                 'B',
                 ln_numtransacconax);

            exception
              when others then
                rollback;
            end;

          exception
            when others then
              ac_rpta := 'ERROR1';
          end;
        end loop;

      end loop;

      for c_cod_ext_ba in c_codigo_ext_bouquet_adic loop
        lc_bouquets    := trim(c_cod_ext_ba.bouquets);
        ln_largo       := length(lc_bouquets);
        ln_numbouquets := (ln_largo + 1) / 4;

        for i in 1 .. ln_numbouquets loop
          lc_codext := lpad(operacion.f_cb_subcadena2(lc_bouquets, i),
                            8,
                            '0');

        --ini 30.0
          lc_nombre:=f_genera_nombre_archivo(0,'cs');
          --lc_numconax:=lpad(substr(lc_nombre,4,5),6,'0');
          lc_numconax:=lpad(substr(lc_nombre,3,8),6,'0');--31.0
        --fin 30.0

        /*select operacion.sq_filename_arch_env.nextval
          into ln_numconax
          from dummy_ope;*/

       --fin 30.0

          /*lc_numconax := lpad(ln_numconax, 6, '0');
          lc_nombre   := 'cs' || lc_numconax || '.emm';*/

          --CREACION DE ARCHIVO DE SOLICITUD DE BAJA DEL SERVICIO DE CABLE SATELITAL

          --ABRE EL ARCHIVO
          operacion.pq_dth_interfaz.p_abrir_archivo(p_text_io,
                                                    connex_i.pdirectorioLocal, --37.0
                                                    lc_nombre,
                                                    'W',
                                                    ac_rpta,
                                                    lc_mensaje);
          --ESCRIBE EN EL ARCHIVO
          operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');
          operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                    lc_numconax,
                                                    '1');
          operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                    lc_codext,
                                                    '1');
          operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                    lc_fecini,
                                                    '1');
          operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                    lc_fecfin,
                                                    '1');
          operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');
          operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'EMM', '1');
          operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');

          -- # Tarjetas enviadas
          select count(serie)
            into ln_canttarjetas
            from operacion.ope_envio_conax
           where codsolot = an_codsolot
             and codinssrv = an_codinssrv
             and estado = 0;

          lc_canttarjetas := lpad(ln_canttarjetas, 6, '0');
          operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                    lc_canttarjetas,
                                                    '1');

          for c_cards in c_tarjetas loop
            operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                      trim(c_cards.serie),
                                                      '1');
          end loop;

          operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'ZZZ', '1');

          --CIERRA EL ARCHIVO DE BAJA DEL SERVICIO DE CABLE SATELITAL
          operacion.pq_dth_interfaz.p_cerrar_archivo(p_text_io);

          begin

            --ENVIO DE ARCHIVO DE BAJA SERVICIO CABLE SATELITAL
            lc_archivolocalenv := lc_nombre;
            operacion.pq_dth_interfaz.p_enviar_archivo_ascii(connex_i.phost, --37.0
                                                             connex_i.ppuerto, --37.0
                                                             connex_i.pusuario, --37.0
                                                             connex_i.ppass, --37.0
                                                             connex_i.pdirectorioLocal, --37.0
                                                             lc_archivolocalenv,
                                                             connex_i.parchivoremotoreq); --37.0

            begin
              select operacion.sq_numtrans.nextval
                into ln_numtransacconax
                from dummy_ope;

              -- REGISTRO DE ENVIO
              insert into operacion.log_reg_archivos_enviados
                (numregenv,
                 numregins,
                 filename,
                 lastnumregenv,
                 codigo_ext,
                 tipo_proceso,
                 numtrans)
              values
                (lc_numconax,
                 lc_numregistro,
                 lc_nombre,
                 lc_numconax,
                 lc_codext,
                 'B',
                 ln_numtransacconax);

              insert into operacion.reg_archivos_enviados
                (numregenv,
                 numregins,
                 filename,
                 estado,
                 lastnumregenv,
                 codigo_ext,
                 tipo_proceso,
                 numtrans)
              values
                (lc_numconax,
                 lc_numregistro,
                 lc_nombre,
                 1,
                 lc_numconax,
                 lc_codext,
                 'B',
                 ln_numtransacconax);

            exception
              when others then
                rollback;
            end;

          exception
            when others then
              ac_rpta := 'ERROR1';
          end;
        end loop;

        -- ACTUALIZAR BOUQUETS
        update bouquetxreginsdth
           set estado = 0, fecultenv = sysdate
         where numregistro = lc_numregistro
           and codsrv = c_cod_ext_ba.codsrv
           and tipo = 0;

      end loop;

      --Verificar Bouquets
      --p_verificar_bouquets(an_codsolot, ln_cntdif, ln_rpta);--12.0, no requerido

    exception
      when others then
        rollback;
        ac_rpta := 'ERROR1';
    end;

    commit;

  end;

  procedure p_valtipo_cambio_conax(an_codsolot in solot.codsolot%type,
                                   an_rpta     out number,
                                   an_cntdif   out number,
                                   ac_mensaje  out char) is

    ln_cntdeco_act number;
    ln_cntdeco_ant number;
    lc_numslc_act  vtatabslcfac.numslc%type;
    lc_numslc_ant  vtatabslcfac.numslc%type;

  begin

    begin

      --Proyecto Actual
      select numslc
        into lc_numslc_act
        from solot
       where codsolot = an_codsolot;

      /*--no se utiliza
      --Proyecto Anterior
      select numslc_ori
        into lc_numslc_ant
        from regvtamentab
       where numslc = lc_numslc_act;
      */

      --Cantidad de Tarjetas
      --select sum(a.cantidad)
      select nvl(sum(a.cantidad), 0)
        into ln_cntdeco_ant
        from solotptoequ a,
             solot       b,
             solotpto    d,
             tipequ      f,
             almtabmat   g,
             tiptrabajo  h,
             inssrv      i,
             --tipequdth   t --12.0
             --<12.0
             (select a.codigon tipequope, codigoc grupoequ
                from opedd a, tipopedd b
               where a.tipopedd = b.tipopedd
                 and b.abrev = 'TIPEQU_DTH_CONAX') t
      --12.0>
       where a.codsolot = b.codsolot
         and a.codsolot = d.codsolot
         and i.codinssrv = d.codinssrv
         and a.punto = d.punto
         and a.tipequ = f.tipequ
         and f.codtipequ = g.codmat
         and b.tiptra = h.tiptra
         and not d.codsolot = an_codsolot
         and i.codinssrv in (select distinct codinssrv
                               from solotpto
                              where codsolot = an_codsolot)
         and t.tipequope = a.tipequ
            --and t.grupoequ = 1; --Grupo Tarjetas --12.0
         and t.grupoequ = '1'; --Grupo Tarjetas --12.0

      --Cantidad de Tarjetas Cambio
      --select sum(l.cantidad) --12.0
      select nvl(sum(l.cantidad), 0) --12.0
        into ln_cntdeco_act
        from linea_paquete l, vtaequcom v, tipequdth t
       where l.iddet in
             (select iddet
                from detalle_paquete
               where iddet in (select v.iddet
                                 from vtadetptoenl v
                                where numslc = lc_numslc_act))
         and l.codequcom = v.codequcom
         and v.codequcom = t.codequcom
         and t.grupoequ = 1; --Grupo Tarjetas

      --if ln_cntdeco_ant > 0 and ln_cntdeco_act > 0 then
      --if ln_cntdeco_ant >= 0 and ln_cntdeco_act > 0 then  --12.0
      if ln_cntdeco_ant >= 0 and ln_cntdeco_act >= 0 then
        --12.0

        if ln_cntdeco_act > ln_cntdeco_ant then
          an_rpta   := 1; --Alta
          an_cntdif := ln_cntdeco_act - ln_cntdeco_ant;
        end if;

        if ln_cntdeco_ant > ln_cntdeco_act then
          an_rpta   := 2; --Baja
          an_cntdif := ln_cntdeco_ant - ln_cntdeco_act;
        end if;

        if ln_cntdeco_act = ln_cntdeco_ant then
          p_val_bouquets(an_codsolot, an_rpta);
          an_cntdif := 0;
        end if;

      else
        an_rpta := 0;
      end if;

    exception
      when others then
        an_rpta := 0;
    end;

  end;

  procedure p_get_numregistro(an_codsolot  in solot.codsolot%type,
                              ac_reginsdth out reginsdth.numregistro%type) is
    lr_venta_des vtatabslcfac%rowtype;
    ln_codinssrv inssrv.codinssrv%type;
    lc_error     varchar2(4000);
    ln_num       number;
  begin

    begin
      --Instancia de Servicio
      /*select distinct codinssrv
       into ln_codinssrv
       from solotpto
      where codsolot = an_codsolot;*/
      select distinct a.codinssrv
        into ln_codinssrv
        from solotpto a, inssrv b
       where a.codinssrv = b.codinssrv
         and codsolot = an_codsolot
         and b.tipsrv =
             (select valor from constante where constante = 'FAM_CABLE');
      --ini 15.0
      /* select count(*)
        into ln_num
        from reginsdth r
       where r.codinssrv = ln_codinssrv;
      if ln_num = 0 then*/
      --fin 15.0
      --Registro de DTH en nueva estructura de multiples servicios recargables
      select r.numregistro
        into ac_reginsdth
      --from recargaproyectocliente r, recargaxinssrv i, estregdth e --12.0
        from ope_srv_recarga_cab r, ope_srv_recarga_det i --12.0
       where r.numregistro = i.numregistro
         and i.codinssrv = ln_codinssrv
            --and r.estado = e.codestdth --12.0
            --and nvl(e.tipoestado, 3) <> 3;--12.0
         and r.estado not in (4); --12.0 --diferente de cancelado
      --ini 15.0
      /*else
        --Registro de DTH
        select r.numregistro
          into ac_reginsdth
          from reginsdth r, estregdth e
         where r.codinssrv = ln_codinssrv
           and r.estado = e.codestdth
           and nvl(e.tipoestado, 3) <> 3;
      end if;*/
      --fin 15.0
    exception
      when others then
        lc_error := sqlerrm;
        null;
    end;
  end;

  procedure p_ins_envioconax(an_codsolot    in solot.codsolot%type,
                             an_codinssrv   in reginsdth.codinssrv%type,
                             an_tipo        in number,
                             ac_serie       in char,
                             ac_unitaddress in char,
                             ac_bouquet     in char,
                             an_numtrans    in number,
                             an_codigo      in number) is

    lc_numregistro reginsdth.numregistro%type;
    lc_numslc      vtatabslcfac.numslc%type;
    lc_codsrv      char(4);
    ln_codinssrv   number;
    ln_num         number;
  begin

    begin

      -- OBTENER CODINSSRV
      if an_codinssrv is null then
        select distinct codinssrv
          into ln_codinssrv
          from solotpto
         where codsolot = an_codsolot;
      else
        ln_codinssrv := an_codinssrv;
      end if;
      --ini 15.0
      /*select count(*)
        into ln_num
        from reginsdth r
       where r.codinssrv = ln_codinssrv;
      if ln_num = 0 then*/
      --fin 15.0
      --Registro de DTH en nueva estructura de multiples servicios recargables
      select r.numregistro
        into lc_numregistro
      --from recargaproyectocliente r, recargaxinssrv i, estregdth e --12.0
        from ope_srv_recarga_cab r, ope_srv_recarga_det i --12.0
       where r.numregistro = i.numregistro
         and i.codinssrv = ln_codinssrv
            --and r.estado = e.codestdth --12.0
            --and nvl(e.tipoestado, 3) <> 3; --12.0
         and r.estado not in (4); --12.0 --diferente de cancelado
      --ini 15.0
      /*else
        -- OBTENER NUMREGISTRO DTH
        select r.numregistro
          into lc_numregistro
          from reginsdth r, estregdth e
         where r.codinssrv = ln_codinssrv
           and r.estado = e.codestdth
           and nvl(e.tipoestado, 3) <> 3;
      end if;*/
      --fin 15.0
      -- OBTENER NUMERO DE PROYECTO Y CODSRV
      if an_tipo in (3, 4) then

        select numslc
          into lc_numslc
          from solot
         where codsolot = an_codsolot;

        select t.codsrv
          into lc_codsrv
          from vtadetptoenl v, tystabsrv t
         where v.numslc = lc_numslc
           and v.codsrv = t.codsrv
           and t.codigo_ext is not null
           and instrb(t.codigo_ext, ac_bouquet, 1, 1) > 0;

      end if;

      -- REGISTRO DE ENVIO A CONAX
      insert into operacion.ope_envio_conax
        (codsolot,
         codinssrv,
         serie,
         unitaddress,
         bouquet,
         codsrv,
         numregistro,
         tipo,
         estado,
         numtrans,
         codigo)
      values
        (an_codsolot,
         ln_codinssrv,
         ac_serie,
         ac_unitaddress,
         ac_bouquet,
         lc_codsrv,
         lc_numregistro,
         an_tipo,
         0,
         an_numtrans,
         an_codigo);

    exception

      when others then
        rollback;

    end;

    commit;

  end;

  procedure p_val_envioconax(an_codsolot in solot.codsolot%type,
                             an_rpta     out number) is
  begin

    select count(*)
      into an_rpta
      from operacion.ope_envio_conax
     where codsolot = an_codsolot;

  end;

  procedure p_act_envioconax(an_codsolot in solot.codsolot%type,
                             an_estado   in number) is
  begin

    -- ACTUALIZAR ESTADO DE ENVIO CONAX
    update operacion.ope_envio_conax
       set estado = an_estado
     where codsolot = an_codsolot;

    commit;
  end;

  -- VALIDA QUE NUMSERIE O UNITADDRESS NO SEAN NULOS
  -- 1: DATOS VALIDOS
  -- 0: ALGUN DATO NULO
  procedure p_val_datos_dth(an_codsolot in solot.codsolot%type,
                            an_rpta     out number) is

    cursor c_val_datos is
      select trim(a.numserie) numserie,
             trim(a.mac) unitaddress,
             t.grupoequ tipo
        from solotptoequ a,
             solot       b,
             solotpto    d,
             tipequ      f,
             almtabmat   g,
             tiptrabajo  h,
             inssrv      i,
             --<12.0
             --tipequdth   t
             (select a.codigon tipequope, codigoc grupoequ
                from opedd a, tipopedd b
               where a.tipopedd = b.tipopedd
                 and b.abrev = 'TIPEQU_DTH_CONAX') t
      --12.0>
       where a.codsolot = b.codsolot
         and a.codsolot = d.codsolot
         and i.codinssrv = d.codinssrv
         and a.punto = d.punto
         and a.tipequ = f.tipequ
         and f.codtipequ = g.codmat
         and b.tiptra = h.tiptra
         and not d.codsolot = an_codsolot
         and i.codinssrv in (select distinct codinssrv
                               from solotpto
                              where codsolot = an_codsolot)
         and i.tipsrv =
             (select valor from constante where constante = 'FAM_CABLE')
         and t.tipequope = a.tipequ
            --and t.grupoequ in (1, 2); --12.0
         and t.grupoequ in ('1', '2'); --12.0

  begin

    an_rpta := 1;

    for c_val in c_val_datos loop
      if c_val.tipo = 1 then
        if c_val.numserie is null or nvl(c_val.numserie, '') = '' then
          an_rpta := 0;
          exit;
        end if;
      else
        if c_val.unitaddress is null or nvl(c_val.unitaddress, '') = '' then
          an_rpta := 0;
          exit;
        end if;
      end if;
    end loop;

  end;

  procedure p_val_bouquets(an_codsolot in solot.codsolot%type,
                           an_rpta     out number) is

    ln_rpta         number;
    lc_numslc_act   vtatabslcfac.numslc%type;
    lc_numslc_ant   vtatabslcfac.numslc%type;
    lc_bouquets_ant varchar2(1000);
    lc_bouquets_act varchar2(1000);
    ln_largo        number;
    ln_numbouquets  number;
    lc_codext       varchar2(8);
    ln_verificador  number;
    error_validacion exception;

    --Servicios Principales
    cursor c_bouquets_principal(lc_numslc in vtatabslcfac.numslc%type) is
      select t.codigo_ext, t.codsrv
        from vtadetptoenl v, tystabsrv t
       where v.numslc = lc_numslc
         and v.flgsrv_pri = 1
         and v.codsrv = t.codsrv
         and t.codigo_ext is not null;

    --Servicios Adicionales
    cursor c_bouquets_adic(lc_numslc in vtatabslcfac.numslc%type) is
      select t.codigo_ext, t.codsrv
        from vtadetptoenl v, tystabsrv t
       where v.numslc = lc_numslc
         and v.flgsrv_pri = 0
         and v.codsrv = t.codsrv
         and t.codigo_ext is not null;

  begin

    select numslc
      into lc_numslc_act
      from solot
     where codsolot = an_codsolot;

    select numslc_ori
      into lc_numslc_ant
      from regvtamentab
     where numslc = lc_numslc_act;

    lc_bouquets_ant := '';

    begin

      --Bouquets Principales Anteriores
      for c_princ in c_bouquets_principal(lc_numslc_ant) loop
        if c_bouquets_principal%rowcount > 1 then
          lc_bouquets_ant := trim(lc_bouquets_ant) || ',' ||
                             trim(c_princ.codigo_ext);
        else
          lc_bouquets_ant := trim(c_princ.codigo_ext);
        end if;
      end loop;

      --Bouquets Adicionales Anteriores
      for c_adic in c_bouquets_adic(lc_numslc_ant) loop
        lc_bouquets_ant := trim(lc_bouquets_ant) || ',' ||
                           trim(c_adic.codigo_ext);
      end loop;

      --Bouquets Principales Actuales
      for c_princ in c_bouquets_principal(lc_numslc_act) loop
        if c_bouquets_principal%rowcount > 1 then
          lc_bouquets_act := trim(lc_bouquets_act) || ',' ||
                             trim(c_princ.codigo_ext);
        else
          lc_bouquets_act := trim(c_princ.codigo_ext);
        end if;
      end loop;

      --Bouquets Adicionales Actuales
      for c_adic in c_bouquets_adic(lc_numslc_act) loop
        lc_bouquets_act := trim(lc_bouquets_act) || ',' ||
                           trim(c_adic.codigo_ext);
      end loop;

      ln_largo       := length(lc_bouquets_act);
      ln_numbouquets := (ln_largo + 1) / 4;

      for i in 1 .. ln_numbouquets loop
        lc_codext := operacion.f_cb_subcadena2(lc_bouquets_act, i);

        select instrb(lc_bouquets_ant, lc_codext, 1, 1)
          into ln_verificador
          from dummy_ope;

        if ln_verificador = 0 then
          --Enviar Nuevo(s) Bouquet(s)
          ln_rpta := 1;
          raise error_validacion;
        end if;

      end loop;

      ln_largo       := length(lc_bouquets_ant);
      ln_numbouquets := (ln_largo + 1) / 4;

      for i in 1 .. ln_numbouquets loop
        lc_codext := operacion.f_cb_subcadena2(lc_bouquets_ant, i);

        select instrb(lc_bouquets_act, lc_codext, 1, 1)
          into ln_verificador
          from dummy_ope;

        if ln_verificador = 0 then
          --Dar de Baja Bouquet(s)
          ln_rpta := 2;
          raise error_validacion;
        end if;

      end loop;

    exception
      when error_validacion then
        an_rpta := ln_rpta;
      when others then
        an_rpta := 3;
    end;

  end;

  procedure p_cal_prorrateo(an_codsolot   in number,
                            ac_numslc_ant in vtatabslcfac.numslc%type,
                            ac_numslc_nue in vtatabslcfac.numslc%type,
                            an_rpta       out number,
                            ac_mensaje    out varchar2) is
    ln_idpaq_ant number;
    ln_idpaq_nue number;

    lr_dth        reginsdth%rowtype;
    ln_dias       number;
    ln_monpaqant  number;
    ln_monxdiaant number;
    ln_monpaqnue  number;
    ln_monxdianue number;
    ld_fecini     date;
    ld_fecfin     date;
    ln_diascons   number; --Días consumidos
    ln_diaspro    number; --Días prorrateados (Dias con el nuevo plan)
    ln_flgsisant  number; --Flag Sistema Facturacion Anterior
    ln_flgsisnue  number; --Flag Nuevo Sistema Facturacion

  begin

    --Obtener Registro de DTH

    begin
      select flg_recarga
        into ln_flgsisant
        from vtatabprecon
       where numslc = ac_numslc_ant;

      select flg_recarga
        into ln_flgsisnue
        from vtatabprecon
       where numslc = ac_numslc_nue;

    exception
      when others then
        an_rpta    := 0;
        ac_mensaje := 'Error al obtener Sistema de Facturacion';
    end;

    p_get_numregistro(an_codsolot, lr_dth.numregistro);

    if ln_flgsisant is null or ln_flgsisnue is null then
      an_rpta    := 0;
      ac_mensaje := 'Favor de ingresar el anterior y/o nuevo sistema de facturación.';
    end if;

    --Validar si se mantiene en el Sistema de Recargas
    if ln_flgsisant = cn_sisrec and ln_flgsisnue = cn_sisrec then
      begin
        select distinct idpaq
          into ln_idpaq_nue
          from vtadetptoenl
         where numslc = ac_numslc_nue;

      exception
        when no_data_found then
          an_rpta    := 0;
          ac_mensaje := 'No se encontro paquete asociado.';
        when too_many_rows then
          an_rpta    := 0;
          ac_mensaje := 'Existe mas de un (1) paquete asociado a la venta.';
        when others then
          an_rpta    := 0;
          ac_mensaje := 'Error al obtener paquete asociado.';
      end;

      select monto, (hasta - desde) dias, desde, hasta
        into ln_monpaqant, ln_dias, ld_fecini, ld_fecfin
        from cuponpago_dth
       where idcupon = (select max(idcupon)
                          from cuponpago_dth
                         where numregistro = lr_dth.numregistro);

      --Monto por Día con el Plan Anterior
      ln_monxdiaant := round(ln_monpaqant / ln_dias, 0);

      select b.monto
        into ln_monpaqnue
        from vtatabrecargaxpaquete a, vtatabrecarga b
       where a.idrecarga = b.idrecarga
         and a.estado = 1
         and b.vigencia = ln_dias
         and a.idpaq = ln_idpaq_nue;

      --Monto por Día con el Plan Actual
      ln_monxdianue := round(ln_monpaqnue / ln_dias, 0);

      --Días Consumidos al día de hoy
      ln_diascons := sysdate - ld_fecini;

      if ln_diascons < 0 then
        raise_application_error(-20500,
                                'PQ_DTH.p_cal_prorrateo: ' ||
                                'Favor de regularizar las fechas de inicio y fin de vigencia para calcular el prorrateo. ');
      end if;

      --Cálculo de días de prorrateo
      ln_diaspro := (ln_monpaqant - (ln_diascons * ln_monxdiaant)) /
                    ln_monxdianue;

      --Actualizar Registro de DTH
      update reginsdth
         set idpaq = ln_idpaq_nue, fecfinvig = sysdate + ln_diaspro
       where numregistro = lr_dth.numregistro;

    end if;

    --Validar si se cambia de Sistema de Recargas a Sistema de Facturacion
    if ln_flgsisant = cn_sisfac and ln_flgsisnue = cn_sisrec then

      begin
        select distinct idpaq
          into ln_idpaq_nue
          from vtadetptoenl
         where numslc = ac_numslc_nue;

        select distinct idpaq
          into ln_idpaq_ant
          from vtadetptoenl
         where numslc = ac_numslc_ant;

      exception
        when no_data_found then
          an_rpta    := 0;
          ac_mensaje := 'No se encontro paquete asociado.';
        when too_many_rows then
          an_rpta    := 0;
          ac_mensaje := 'Existe mas de un (1) paquete asociado a la venta.';
        when others then
          an_rpta    := 0;
          ac_mensaje := 'Error al obtener paquete asociado.';
      end;

      ln_dias := 30; --Se asume facturación a 30 días

      --Fecha Inicio de Vigencia
      select fecinivig
        into ld_fecini
        from reginsdth
       where numregistro = lr_dth.numregistro;

      if ld_fecini is null then
        ac_mensaje := 'Error al obtener fecha de inicio del registro';
        an_rpta    := 0;
        return;
      end if;

      --Obtener Monto a Pagar por Paquete Anterior
      select b.monto
        into ln_monpaqant
        from vtatabrecargaxpaquete a, vtatabrecarga b
       where a.idrecarga = b.idrecarga
         and a.estado = 1
         and b.vigencia = ln_dias
         and a.idpaq = ln_idpaq_ant;

      --Monto por Día con el Plan Anterior
      ln_monxdiaant := ln_monpaqant / ln_dias;

      --Obtener Monto a Pagar por Nuevo Paquete
      select b.monto
        into ln_monpaqnue
        from vtatabrecargaxpaquete a, vtatabrecarga b
       where a.idrecarga = b.idrecarga
         and a.estado = 1
         and b.vigencia = ln_dias
         and a.idpaq = ln_idpaq_nue;

      --Monto por Día con el Plan Actual
      ln_monxdianue := ln_monpaqnue / ln_dias;

      --Días Consumidos al día de hoy
      ln_diascons := sysdate - ld_fecini;

      if ln_diascons < 0 then
        raise_application_error(-20500,
                                'PQ_DTH.p_cal_prorrateo: ' ||
                                'Favor de regularizar las fechas de inicio y fin de vigencia para calcular el prorrateo. ');
      end if;

      --Cálculo de días de prorrateo
      ln_diaspro := (ln_monpaqant - (ln_diascons * ln_monxdiaant)) /
                    ln_monxdianue;

      ld_fecfin := sysdate + ln_diaspro;

      --Actualizar Registro de DTH
      update reginsdth
         set idpaq     = ln_idpaq_nue,
             fecfinvig = ld_fecfin,
             fecalerta = ld_fecfin - 3,
             feccorte  = ld_fecfin + 1
       where numregistro = lr_dth.numregistro;

    end if;

    if ln_flgsisant = cn_sisfac and ln_flgsisnue = cn_sisfac then
      ac_mensaje := 'No es posible calcular prorrateo. Cambio en sistema de facturación no soportado.';
      an_rpta    := 0;
      return;
    end if;

    if ln_flgsisant = cn_sisrec and ln_flgsisnue = cn_sisfac then
      ac_mensaje := 'No es posible calcular prorrateo. Cambio en sistema de facturación no soportado.';
      an_rpta    := 0;
      return;
    end if;

    --Actualizar Registro para Recarga Virtual (Tablas Intermedias)
    begin
      update reginsdth_web
         set idpaq = ln_idpaq_nue, fecfinvig = sysdate + ln_diaspro
       where numregistro = lr_dth.numregistro;
    exception
      when others then
        null;
    end;

  end;

  --<10.0
  procedure p_cargar_equ_dth_cambio_plan(a_idtareawf in number,
                                         a_idwf      in number,
                                         a_tarea     in number,
                                         a_tareadef  in number) is

    l_punto_ori number;
    l_punto_des number;

    lc_numregistro reginsdth.numregistro%type;
    ln_codinssrv   number;

    ln_codsolot     solot.codsolot%type;
    lc_ventaori     vtatabslcfac.numslc%type;
    lc_ventades     vtatabslcfac.numslc%type;
    ln_rpta         number;
    ln_cntdif       number;
    lc_mensaje      varchar2(4000);
    ln_punto        number;
    lc_observacion  varchar2(200);
    ln_orden        number;
    ln_grupo        number;
    ln_cntdeco      number;
    ln_cnttarj      number;
    ln_estado       number;
    ln_contador     number;
    ln_codsolot_ori solot.codsolot%type;
    ln_equori       number;
    ln_formula      number;

    --Equipos en el Plan Origen
    cursor cur_equ_ori is
      select a.cod_sap,
             a.desmat,
             s.codequcom codigo,
             s.cantidad,
             s.tipequ,
             t.costo costo,
             o.codigon codeta,
             s.numserie,
             s.mac,
             td.grupoequ grupo
        from solotptoequ s,
             tipequdth   td,
             equcomxope  e,
             almtabmat   a,
             opedd       o,
             tipequ      t
       where s.codequcom = td.codequcom
         and td.grupoequ in (1, 2)
         and e.codequcom = s.codequcom
         and a.codmat = e.codtipequ
         and o.tipopedd = 197
         and o.abreviacion = 'DTH'
         and trim(o.codigoc) = trim(a.cod_sap)
         and t.codtipequ = e.codtipequ
         and s.codsolot = ln_codsolot_ori;

    --Equipos en el Plan de Destino
    cursor cur_equ_des is
      select d.cod_sap,
             d.desmat,
             a.codigo,
             a.cant cantidad,
             c.tipequ,
             t.costo costo,
             o.codigon codeta
        from (select codequcom codigo, cantidad cant
                from vtadetptoenl
               where numslc = lc_ventades
                 and codequcom is not null) a,
             equcomxope c,
             almtabmat d,
             vtaequcom v,
             opedd o,
             tipequ t
       where c.codequcom = a.codigo
         and c.codtipequ = d.codmat
         and v.codequcom = c.codequcom
         and o.tipopedd = 197
         and o.abreviacion = 'DTH'
         and trim(o.codigoc) = trim(d.cod_sap)
         and t.codtipequ = c.codtipequ
         and c.codequcom in
             (select codequcom from tipequdth where grupoequ in (1, 2));

    --Materiales iguales en Cambio de Plan 1-1; 1-2; 2-2; 2-1.. etc
    cursor cur_mat_igual is
      select a.cod_sap,
             a.desmat,
             a.codigo,
             abs(a.cantidad - b.cantidad) cantidad,
             a.cantidad cntcp,
             b.cantidad cntori,
             a.tipequ,
             a.costo,
             a.codeta
        from (select d.cod_sap,
                     d.desmat,
                     a.codigo,
                     c.tipequ,
                     t.costo costo,
                     o.codigon codeta,
                     sum(a.cant) cantidad
                from (select codequcom codigo, cantidad cant
                        from vtadetptoenl
                       where numslc = lc_ventades
                         and codequcom is not null) a,
                     equcomxope c,
                     almtabmat d,
                     vtaequcom v,
                     opedd o,
                     tipequ t
               where c.codequcom = a.codigo
                 and c.codtipequ = d.codmat
                 and v.codequcom = c.codequcom
                 and o.tipopedd = 197
                 and o.abreviacion = 'DTH'
                 and trim(o.codigoc) = trim(d.cod_sap)
                 and t.codtipequ = c.codtipequ
                 and v.codequcom not in
                     (select codequcom
                        from tipequdth
                       where grupoequ in (1, 2))
               group by d.cod_sap,
                        d.desmat,
                        a.codigo,
                        a.cant,
                        c.tipequ,
                        t.costo,
                        o.codigon) a,
             (select d.cod_sap,
                     d.desmat,
                     a.codigo,
                     c.tipequ,
                     t.costo costo,
                     o.codigon codeta,
                     sum(a.cant) cantidad
                from (select codequcom codigo, cantidad cant
                        from vtadetptoenl
                       where numslc = lc_ventaori
                         and codequcom is not null) a,
                     equcomxope c,
                     almtabmat d,
                     vtaequcom v,
                     opedd o,
                     tipequ t
               where c.codequcom = a.codigo
                 and c.codtipequ = d.codmat
                 and v.codequcom = c.codequcom
                 and o.tipopedd = 197
                 and o.abreviacion = 'DTH'
                 and trim(o.codigoc) = trim(d.cod_sap)
                 and t.codtipequ = c.codtipequ
                 and v.codequcom not in
                     (select codequcom
                        from tipequdth
                       where grupoequ in (1, 2))
               group by d.cod_sap,
                        d.desmat,
                        a.codigo,
                        a.cant,
                        c.tipequ,
                        t.costo,
                        o.codigon) b
       where a.cod_sap = b.cod_sap;

    --Materiales adicionales en un cambio de plan 1 a 2
    cursor cur_mat_adic is
      select a.cod_sap,
             a.desmat,
             a.codigo,
             a.cantidad,
             a.tipequ,
             a.costo,
             a.codeta
        from (select d.cod_sap,
                     d.desmat,
                     a.codigo,
                     c.tipequ,
                     t.costo costo,
                     o.codigon codeta,
                     sum(a.cant) cantidad
                from (select codequcom codigo, cantidad cant
                        from vtadetptoenl
                       where numslc = lc_ventades
                         and codequcom is not null) a,
                     equcomxope c,
                     almtabmat d,
                     vtaequcom v,
                     opedd o,
                     tipequ t
               where c.codequcom = a.codigo
                 and c.codtipequ = d.codmat
                 and v.codequcom = c.codequcom
                 and o.tipopedd = 197
                 and o.abreviacion = 'DTH'
                 and trim(o.codigoc) = trim(d.cod_sap)
                 and t.codtipequ = c.codtipequ
                 and v.codequcom not in
                     (select codequcom
                        from tipequdth
                       where grupoequ in (1, 2))
               group by d.cod_sap,
                        d.desmat,
                        a.codigo,
                        a.cant,
                        c.tipequ,
                        t.costo,
                        o.codigon) a
       where a.cod_sap not in (select d.cod_sap
                                 from (select codequcom codigo, cantidad cant
                                         from vtadetptoenl
                                        where numslc = lc_ventaori
                                          and codequcom is not null) a,
                                      equcomxope c,
                                      almtabmat d,
                                      vtaequcom v,
                                      opedd o,
                                      tipequ t
                                where c.codequcom = a.codigo
                                  and c.codtipequ = d.codmat
                                  and v.codequcom = c.codequcom
                                  and o.tipopedd = 197
                                  and o.abreviacion = 'DTH'
                                  and trim(o.codigoc) = trim(d.cod_sap)
                                  and t.codtipequ = c.codtipequ
                                  and v.codequcom not in
                                      (select codequcom
                                         from tipequdth
                                        where grupoequ in (1, 2))
                                group by d.cod_sap,
                                         d.desmat,
                                         a.codigo,
                                         a.cant,
                                         c.tipequ,
                                         t.costo,
                                         o.codigon);

    --Equipos y Materiales del Cambio de Plan
    cursor cur_equ_cp is
      select d.cod_sap,
             d.desmat,
             a.codigo,
             a.cant cantidad,
             c.tipequ,
             t.costo costo,
             o.codigon codeta
        from (select codequcom codigo, cantidad cant
                from vtadetptoenl
               where numslc = lc_ventades
                 and codequcom is not null) a,
             equcomxope c,
             almtabmat d,
             vtaequcom v,
             opedd o,
             tipequ t
       where c.codequcom = a.codigo
         and c.codtipequ = d.codmat
         and v.codequcom = c.codequcom
         and o.tipopedd = 197
         and o.abreviacion = 'DTH'
         and trim(o.codigoc) = trim(d.cod_sap)
         and t.codtipequ = c.codtipequ;

    --Equipos y Materiales en el Plan de Origen
    cursor cur_equ_ins is
      select d.cod_sap,
             d.desmat,
             a.codequcom,
             a.cantidad cantidad,
             c.tipequ,
             t.costo costo,
             o.codigon codeta,
             a.numserie,
             a.mac
        from solotptoequ a,
             equcomxope  c,
             almtabmat   d,
             vtaequcom   v,
             opedd       o,
             tipequ      t
       where c.codequcom = a.codequcom
         and c.codtipequ = d.codmat
         and v.codequcom = c.codequcom
         and o.tipopedd = 197
         and o.abreviacion = 'DTH'
         and trim(o.codigoc) = trim(d.cod_sap)
         and t.codtipequ = c.codtipequ
         and a.codsolot = ln_codsolot_ori;

  begin

    lc_observacion := '';
    ln_cntdeco     := 0; --Cantidad de Equipos (Deco)
    ln_cnttarj     := 0; --Cantidad de Equipos (Tarjeta)
    ln_estado      := 4; --Instalado
    ln_equori      := 0; --Contador de Equipos Originales

    select codsolot into ln_codsolot from wf where idwf = a_idwf;

    select distinct s.codsolot
      into ln_codsolot_ori
      from solot s
     where s.numslc in (select regvtamentab.numslc_ori
                          from regvtamentab, solot
                         where regvtamentab.numslc = solot.numslc
                           and solot.codsolot = ln_codsolot);

    select numslc
      into lc_ventaori
      from solot
     where codsolot = ln_codsolot_ori;

    select numslc into lc_ventades from solot where codsolot = ln_codsolot;

    select distinct codinssrv
      into ln_codinssrv
      from solotpto
     where codsolot = ln_codsolot;

    p_get_numregistro(ln_codsolot, lc_numregistro);
    p_valtipo_cambio_conax(ln_codsolot, ln_rpta, ln_cntdif, lc_mensaje);

    select nvl(max(orden), 0) + 1
      into ln_orden
      from solotptoequ
     where codsolot = ln_codsolot
       and punto = ln_punto;

    --Verificar el Punto de la SOT a la que se asignará el equipo
    if ln_punto is null then
      operacion.p_get_punto_princ_solot(ln_codsolot,
                                        ln_punto,
                                        l_punto_ori,
                                        l_punto_des);
    end if;

    --Obtener Codigo de Fórmula
    select codfor
      into ln_formula
      from tiptrabajoxfor
     where tiptra = (select tiptra from solot where codsolot = ln_codsolot);

    select count(1)
      into ln_contador
      from solotptoequ
     where codsolot = ln_codsolot;

    if ln_contador = 0 then

      --Ingresar Equipos si ampliación de plan contiene 1 o más decos
      if ln_rpta = 1 and ln_cntdif > 0 then

        --Insertar Equipos Originales
        for c_equ in cur_equ_ori loop

          lc_observacion := '';
          ln_estado      := 4;
          ln_equori      := cur_equ_ori%rowcount;

          if c_equ.grupo = 1 then

            if c_equ.numserie is null then
              raise_application_error(-20500,
                                      'PQ_DTH.p_carga_equ_dth_cambio_plan: ' ||
                                      'Favor de ingresar número(s) de serie(s) en la instalación original. ');
            end if;

            select count(1)
              into ln_contador
              from maestro_series_equ m
             where trim(m.nroserie) = trim(c_equ.numserie)
               and trim(m.cod_sap) = trim(c_equ.cod_sap);

            if ln_contador = 0 then
              ln_estado      := 9;
              lc_observacion := lc_observacion || 'Falta Serie en BD.';
              p_envia_correo_de_texto_att('Registrar Equipos DTH',
                                          'DL - PE - Carga Equipos Intraway SGA',
                                          lc_observacion);
            end if;

          end if;

          if c_equ.grupo = 2 then

            if c_equ.mac is null then
              raise_application_error(-20500,
                                      'PQ_DTH.p_carga_equ_dth_cambio_plan: ' ||
                                      'Favor de ingresar número(s) de unitaddress en la instalación original. ');
            end if;

          end if;

          select nvl(max(orden), 0) + 1
            into ln_orden
            from solotptoequ
           where codsolot = ln_codsolot
             and punto = ln_punto;

          -- REGISTRO DE EQUIP0S
          insert into solotptoequ
            (codsolot,
             punto,
             orden,
             tipequ,
             cantidad,
             tipprp,
             costo,
             numserie,
             flgsol,
             flgreq,
             codeta,
             tran_solmat,
             observacion,
             fecfdis,
             estado,
             mac,
             codequcom,
             instalado)
          values
            (ln_codsolot,
             ln_punto,
             ln_orden,
             c_equ.tipequ,
             c_equ.cantidad,
             0,
             nvl(c_equ.costo, 0),
             c_equ.numserie,
             1,
             0,
             c_equ.codeta,
             null,
             lc_observacion || 'ITTELMEX-EQU-DTH',
             sysdate,
             ln_estado,
             c_equ.mac,
             c_equ.codigo,
             1);

        end loop;

        if ln_equori = 0 then
          raise_application_error(-20500,
                                  'PQ_DTH.p_carga_equ_dth_cambio_plan: ' ||
                                  'Favor de ingresar datos de equipos faltantes en la SOT Original. ');
        end if;

        ln_contador := 0;

        --Insertar Materiales (Equipos Nuevos y Materiales)
        for c_mat in cur_mat_igual loop

          if nvl(c_mat.codeta, 0) > 0 then

            select nvl(max(orden), 0) + 1
              into ln_orden
              from solotptoequ
             where codsolot = ln_codsolot
               and punto = ln_punto;

            if c_mat.cantidad = 0 then

              ln_estado := 4;

              -- REGISTRO DE EQUIPOS
              insert into solotptoequ
                (codsolot,
                 punto,
                 orden,
                 tipequ,
                 cantidad,
                 tipprp,
                 costo,
                 numserie,
                 flgsol,
                 flgreq,
                 codeta,
                 tran_solmat,
                 observacion,
                 fecfdis,
                 estado,
                 mac,
                 codequcom,
                 instalado)
              values
                (ln_codsolot,
                 ln_punto,
                 ln_orden,
                 c_mat.tipequ,
                 c_mat.cntcp,
                 0,
                 nvl(c_mat.costo, 0),
                 null,
                 1,
                 0,
                 c_mat.codeta,
                 null,
                 lc_observacion || 'ITTELMEX-EQU-DTH',
                 sysdate,
                 ln_estado,
                 null,
                 c_mat.codigo,
                 1);

            else

              ln_estado := 2;

              select count(1)
                into ln_contador
                from matetapaxfor a, almtabmat b
               where a.codfor = ln_formula
                 and a.codmat = b.codmat
                 and b.cod_sap = c_mat.cod_sap
                 and a.recuperable = 1;

              if ln_contador > 0 then

                -- REGISTRO DE EQUIPOS
                insert into solotptoequ
                  (codsolot,
                   punto,
                   orden,
                   tipequ,
                   cantidad,
                   tipprp,
                   costo,
                   numserie,
                   flgsol,
                   flgreq,
                   codeta,
                   tran_solmat,
                   observacion,
                   fecfdis,
                   estado,
                   mac,
                   codequcom)
                values
                  (ln_codsolot,
                   ln_punto,
                   ln_orden,
                   c_mat.tipequ,
                   c_mat.cantidad,
                   0,
                   nvl(c_mat.costo, 0),
                   null,
                   1,
                   0,
                   c_mat.codeta,
                   null,
                   lc_observacion || 'ITTELMEX-EQU-DTH',
                   sysdate,
                   ln_estado,
                   null,
                   c_mat.codigo);
              else
                -- REGISTRO DE EQUIPOS
                insert into solotptoequ
                  (codsolot,
                   punto,
                   orden,
                   tipequ,
                   cantidad,
                   tipprp,
                   costo,
                   numserie,
                   flgsol,
                   flgreq,
                   codeta,
                   tran_solmat,
                   observacion,
                   fecfdis,
                   estado,
                   mac,
                   codequcom)
                values
                  (ln_codsolot,
                   ln_punto,
                   ln_orden,
                   c_mat.tipequ,
                   c_mat.cntcp,
                   0,
                   nvl(c_mat.costo, 0),
                   null,
                   1,
                   0,
                   c_mat.codeta,
                   null,
                   lc_observacion || 'ITTELMEX-EQU-DTH',
                   sysdate,
                   ln_estado,
                   null,
                   c_mat.codigo);
              end if;
            end if;

          end if;

        end loop;

        --Equipos del Cambio de Plan
        for c_equ in cur_equ_des loop

          ln_estado := 2;
          begin
            select grupoequ
              into ln_grupo
              from tipequdth
             where codequcom = c_equ.codigo;
          exception
            when others then
              ln_grupo := 0;
          end;

          if ln_grupo = 1 then
            --Si es que el grupo fuera equipos (Tarjeta)

            if ln_cnttarj < ln_cntdif then

              select nvl(max(orden), 0) + 1
                into ln_orden
                from solotptoequ
               where codsolot = ln_codsolot
                 and punto = ln_punto;

              -- REGISTRO DE EQUIPOS
              insert into solotptoequ
                (codsolot,
                 punto,
                 orden,
                 tipequ,
                 cantidad,
                 tipprp,
                 costo,
                 numserie,
                 flgsol,
                 flgreq,
                 codeta,
                 tran_solmat,
                 observacion,
                 fecfdis,
                 estado,
                 mac,
                 codequcom)
              values
                (ln_codsolot,
                 ln_punto,
                 ln_orden,
                 c_equ.tipequ,
                 c_equ.cantidad,
                 0,
                 nvl(c_equ.costo, 0),
                 null,
                 1,
                 0,
                 c_equ.codeta,
                 null,
                 lc_observacion || 'ITTELMEX-EQU-DTH',
                 sysdate,
                 ln_estado,
                 null,
                 c_equ.codigo);
            end if;

            ln_cnttarj := ln_cnttarj + 1;
          end if;

          if ln_grupo = 2 then
            --Si es que el grupo fuera equipos (Deco)

            if ln_cntdeco < ln_cntdif then

              select nvl(max(orden), 0) + 1
                into ln_orden
                from solotptoequ
               where codsolot = ln_codsolot
                 and punto = ln_punto;

              -- REGISTRO DE EQUIPOS
              insert into solotptoequ
                (codsolot,
                 punto,
                 orden,
                 tipequ,
                 cantidad,
                 tipprp,
                 costo,
                 numserie,
                 flgsol,
                 flgreq,
                 codeta,
                 tran_solmat,
                 observacion,
                 fecfdis,
                 estado,
                 mac,
                 codequcom)
              values
                (ln_codsolot,
                 ln_punto,
                 ln_orden,
                 c_equ.tipequ,
                 c_equ.cantidad,
                 0,
                 nvl(c_equ.costo, 0),
                 null,
                 1,
                 0,
                 c_equ.codeta,
                 null,
                 lc_observacion || 'ITTELMEX-EQU-DTH',
                 sysdate,
                 ln_estado,
                 null,
                 c_equ.codigo);
            end if;

            ln_cntdeco := ln_cntdeco + 1;
          end if;

        end loop;

        ln_estado := 4;
        for c_mat in cur_mat_adic loop

          select nvl(max(orden), 0) + 1
            into ln_orden
            from solotptoequ
           where codsolot = ln_codsolot
             and punto = ln_punto;

          -- REGISTRO DE EQUIPOS
          insert into solotptoequ
            (codsolot,
             punto,
             orden,
             tipequ,
             cantidad,
             tipprp,
             costo,
             numserie,
             flgsol,
             flgreq,
             codeta,
             tran_solmat,
             observacion,
             fecfdis,
             estado,
             mac,
             codequcom)
          values
            (ln_codsolot,
             ln_punto,
             ln_orden,
             c_mat.tipequ,
             c_mat.cantidad,
             0,
             nvl(c_mat.costo, 0),
             null,
             1,
             0,
             c_mat.codeta,
             null,
             lc_observacion || 'ITTELMEX-EQU-DTH',
             sysdate,
             ln_estado,
             null,
             c_mat.codigo);

        end loop;

      end if;

      if (ln_rpta = 2 and ln_cntdif > 0) then

        for c_mat in cur_equ_ins loop

          select nvl(max(orden), 0) + 1
            into ln_orden
            from solotptoequ
           where codsolot = ln_codsolot
             and punto = ln_punto;

          -- REGISTRO DE EQUIPOS
          insert into solotptoequ
            (codsolot,
             punto,
             orden,
             tipequ,
             cantidad,
             tipprp,
             costo,
             numserie,
             flgsol,
             flgreq,
             codeta,
             tran_solmat,
             observacion,
             fecfdis,
             estado,
             mac,
             codequcom)
          values
            (ln_codsolot,
             ln_punto,
             ln_orden,
             c_mat.tipequ,
             c_mat.cantidad,
             0,
             nvl(c_mat.costo, 0),
             c_mat.numserie,
             1,
             0,
             c_mat.codeta,
             null,
             lc_observacion || 'ITTELMEX-EQU-DTH',
             sysdate,
             ln_estado,
             c_mat.mac,
             c_mat.codequcom);

        end loop;

      end if;

      if ln_cntdif = 0 then

        ln_estado := 4;
        for c_mat in cur_equ_ins loop

          select nvl(max(orden), 0) + 1
            into ln_orden
            from solotptoequ
           where codsolot = ln_codsolot
             and punto = ln_punto;

          -- REGISTRO DE EQUIPOS
          insert into solotptoequ
            (codsolot,
             punto,
             orden,
             tipequ,
             cantidad,
             tipprp,
             costo,
             numserie,
             flgsol,
             flgreq,
             codeta,
             tran_solmat,
             observacion,
             fecfdis,
             estado,
             mac,
             codequcom)
          values
            (ln_codsolot,
             ln_punto,
             ln_orden,
             c_mat.tipequ,
             c_mat.cantidad,
             0,
             nvl(c_mat.costo, 0),
             c_mat.numserie,
             1,
             0,
             c_mat.codeta,
             null,
             lc_observacion || 'ITTELMEX-EQU-DTH',
             sysdate,
             ln_estado,
             c_mat.mac,
             c_mat.codequcom);

        end loop;

      end if;

    end if;

    commit;

  end;
  --10.0>

  function f_verifica_proyecto_dth(ac_numslc in vtatabslcfac.numslc%type)
    return number is
    ln_idsol number;
  begin
    begin
/*      select idsolucion
        into ln_idsol
        from vtatabslcfac
       where numslc = ac_numslc;*/

     -- ini 33  soluciones 67, 119
      select count(1)
       into ln_idsol
        from vtatabslcfac
       where numslc = ac_numslc
         and idsolucion in ( select idsolucion
                               from  soluciones
                              where  idgrupocorte in ( select idgrupocorte
                                                         from cxc_grupocorte
                                                        where idgrupocorte = 15 )) ;
      -- fin 33
      -- if ln_idsol = 67  then
      if ln_idsol = 1 then  -- 33.0
        return 1;
      else
        return 0;
      end if;

    exception
      when others then
        return 0;
    end;
  end;

  -- FUNCION QUE BUSCA OBTENER SI EL SISTEMA DE FACTURACION ES POR CICLO DE FACTURACION O RECARGA
  function f_get_sisfac(ac_numslc_ori in vtatabslcfac.numslc%type)
    return number is

    ln_codinssrv inssrv.codinssrv%type;
    ln_sisfac    number;

  begin

    begin

      -- OBTENER SISTEMA DE FACTURACION
      select flg_recarga
        into ln_sisfac
        from vtatabprecon
       where numslc = ac_numslc_ori;

      if ln_sisfac is null then

        select codinssrv
          into ln_codinssrv
          from inssrv
         where numslc = ac_numslc_ori;

        select flg_recarga
          into ln_sisfac
          from reginsdth r
         where codinssrv = ln_codinssrv
           and nvl((select tipoestado
                     from estregdth
                    where codestdth = r.estado),
                   3) <> 3;

        if ln_sisfac is null then
          return 2;
        end if;

      end if;

      return ln_sisfac;
    exception
      when others then
        return 2;
    end;

  end;
  --9.0>

  --<11.0
  procedure p_carga_msgs_decos(as_comando    ope_archivo_mensaje_tvsat_cab.comando%type,
                               an_tipo_msg   ope_archivo_mensaje_tvsat_cab.tipo_mensaje%type,
                               as_mensaje    ope_archivo_mensaje_tvsat_cab.texto%type,
                               ad_fecha_prog ope_programa_mensaje_tv_det.fecha_prog%type,
                               a_resultado   out varchar2,
                               a_idarchivo   out number) is
    cursor cur_sid is
      select a.codsolot, b.orden, b.punto, b.numserie
        from solotpto a, solotptoequ b, ope_lista_filtros_tmp c
       where a.codinssrv = c.valor
         and c.tipo = 5
         and c.usureg = user
         and b.tipequ in
             (select a.codigon
                from opedd a, tipopedd b
               where a.tipopedd = b.tipopedd
                 and b.abrev = 'TIPOEQU_TARJETA_DTH')
         and a.codsolot = b.codsolot
         and a.punto = b.punto
         and b.numserie is not null;

    ln_grupo          number;
    ln_agrupador      number;
    ln_idprogramacion number;
    ln_cont           number;
    ln_idarchivo      number;
  begin
    --Numero de tarjetas para agrupar
    select valor
      into ln_agrupador
      from constante
     where constante = 'LIM_TAR_DTH';

    select sq_ope_arch_msj_cab_idarchivo.nextval
      into ln_idarchivo
      from dual;
    --Registro de Cabecera
    insert into ope_archivo_mensaje_tvsat_cab
      (idarchivo, comando, tipo_mensaje, texto)
    values
      (ln_idarchivo, as_comando, an_tipo_msg, as_mensaje);

    ln_cont := 0;

    for c_sid in cur_sid loop
      ln_cont := ln_cont + 1;

      select mod(ln_cont, ln_agrupador)
        into ln_grupo
        from operacion.dummy_ope;

      if ln_grupo = 1 then
        --Registro de programación
        select sq_ope_programa_mensaje_det.nextval
          into ln_idprogramacion
          from operacion.dummy_ope;
        insert into ope_programa_mensaje_tv_det
          (idprogramacion, idarchivo, fecha_prog)
        values
          (ln_idprogramacion, ln_idarchivo, ad_fecha_prog);
      end if;
      --Registrar informacion de Tarjetas
      insert into ope_archivo_tarjeta_tvsat_det
        (idprogramacion, tarjeta, idarchivo)
      values
        (ln_idprogramacion, c_sid.numserie, ln_idarchivo);
    end loop;

    delete ope_lista_filtros_tmp
     where tipo = 5
       and usureg = user;

    a_resultado := 'OK';
    a_idarchivo := ln_idarchivo;
  exception
    when others then
      a_resultado := sqlerrm;
      a_idarchivo := 0;
  end;

  procedure p_pre_cargar_sid(a_sid       inssrv.codinssrv%type,
                             a_tipo      number,
                             a_resultado out varchar2) is
  begin

    insert into ope_lista_filtros_tmp (tipo, valor) values (a_tipo, a_sid);
    a_resultado := 'OK';
  exception
    when others then
      a_resultado := sqlerrm;
  end;

  procedure p_carga_archivo_bouquet(as_comando    ope_archivo_mensaje_tvsat_cab.comando%type,
                                    an_tipo_msg   ope_archivo_mensaje_tvsat_cab.tipo_mensaje%type,
                                    as_mensaje    ope_archivo_mensaje_tvsat_cab.texto%type,
                                    ad_fecha_prog ope_programa_mensaje_tv_det.fecha_prog%type,
                                    a_resultado   out varchar2,
                                    a_idarchivo   out number) is
    cursor cur_sid is
      select a.codsolot, b.orden, b.punto, b.numserie
        from solotpto a, solotptoequ b, ope_lista_filtros_tmp c
       where a.codinssrv = c.valor
         and c.tipo = 6
         and c.usureg = user
         and b.tipequ in
             (select a.codigon
                from opedd a, tipopedd b
               where a.tipopedd = b.tipopedd
                 and b.abrev = 'TIPOEQU_TARJETA_DTH')
         and a.codsolot = b.codsolot
         and a.punto = b.punto
         and b.numserie is not null;

    ln_grupo          number;
    ln_agrupador      number;
    ln_idprogramacion number;
    ln_cont           number;
    ln_idarchivo      number;
  begin
    --Numero de tarjetas para agrupar
    select valor
      into ln_agrupador
      from constante
     where constante = 'LIM_TARXBOUQUET';

    select sq_ope_arch_msj_cab_idarchivo.nextval
      into ln_idarchivo
      from dual;
    --Registro de Cabecera
    insert into ope_archivo_mensaje_tvsat_cab
      (idarchivo, comando, tipo_mensaje, texto)
    values
      (ln_idarchivo, as_comando, an_tipo_msg, as_mensaje);

    ln_cont := 0;

    for c_sid in cur_sid loop
      ln_cont := ln_cont + 1;

      select mod(ln_cont, ln_agrupador)
        into ln_grupo
        from operacion.dummy_ope;

      if ln_grupo = 1 then
        --Registro de programación
        select sq_ope_programa_mensaje_det.nextval
          into ln_idprogramacion
          from operacion.dummy_ope;
        insert into ope_programa_mensaje_tv_det
          (idprogramacion, idarchivo, fecha_prog)
        values
          (ln_idprogramacion, ln_idarchivo, nvl(ad_fecha_prog, sysdate));
      end if;
      --Registrar informacion de Tarjetas
      insert into ope_archivo_tarjeta_tvsat_det
        (idprogramacion, tarjeta, idarchivo)
      values
        (ln_idprogramacion, c_sid.numserie, ln_idarchivo);
    end loop;

    a_resultado := 'OK';
    a_idarchivo := ln_idarchivo;
  exception
    when others then
      a_resultado := sqlerrm;
      a_idarchivo := 0;
  end;

  procedure p_actualiza_bouquet_masivo(a_idarchivo      in ope_archivo_mensaje_tvsat_cab.idarchivo%type,
                                       a_idprogramacion in operacion.ope_programa_mensaje_tv_det.idprogramacion%type,
                                       a_comando        in ope_archivo_mensaje_tvsat_cab.comando%type,
                                       a_bouquet        in varchar2,
                                       a_resultado      in out varchar2,
                                       a_mensaje        in out varchar2) is

    p_text_io            utl_file.file_type;
    lc_nom_arch          varchar2(15);
    ln_num_arch          number;
    lc_num_arch          varchar2(6);
    ln_numtransacconax   number(15);
    lc_bouquet           varchar2(8);
    ln_cantidad          number(6);
    lc_cantidad          varchar2(6);
    ln_cantidad1         number(6);
    ln_cantidad2         number(6);
    lc_fecini            varchar2(12);
    lc_fecfin            varchar2(12);
  lc_fecfin_rotacion varchar2(12);--38.0
    ln_numregins         number(10);
    lc_numregins         varchar2(10);
    lc_tipo_envio        char(1);
    lc_prefijo_arch      char(2);
    error_crear_archivo     exception;
    error_escribir_archivo  exception;
    error_envio_archivo     exception;
    error_registro          exception;
    error_tarjeta           exception;
    error_actualizar_regins exception;
--    lc_directorio_local_alta_baja  varchar2(100);
--    lc_directorio_remoto_alta_baja varchar2(100);
    connex_i                operacion.conex_intraway;  --37.0

    cursor c_tarjetas is
      select distinct tarjeta
        from ope_archivo_tarjeta_tvsat_det
       where idarchivo = a_idarchivo
         and idprogramacion = a_idprogramacion
       order by tarjeta asc;

  begin
    connex_i :=operacion.pq_dth.f_crea_conexion_intraway;  --37.0

    a_resultado := 'OK';
-- Ini 37.0
/*    select valor  --pDirectorioLocal

      into lc_directorio_local_alta_baja
      from constante
     where constante = 'DIR_LOC_DTH_AYB';

    select valor
      into lc_directorio_remoto_alta_baja
      from constante
     where constante = 'DIR_REM_DTH_AYB';
*/
-- Fin 37.0
    if a_comando = 'ALTA' then
      lc_prefijo_arch := 'ps';
      lc_tipo_envio   := 'A';
    else
      lc_prefijo_arch := 'cs';
      lc_tipo_envio   := 'B';
    end if;

    select to_char(trunc(new_time(sysdate, 'EST', 'GMT'), 'MM'), 'yyyymmdd') ||
           '0000'
      into lc_fecini
      from dummy_ope;
-- ini 38.0
  /* select to_char(trunc(last_day(new_time(sysdate, 'EST', 'GMT'))),
                   'yyyymmdd') || '0000'
      into p_fecfin
      from dummy_ope;
    */

 select TO_CHAR(c.Valor)
  INTO lc_fecfin_rotacion

  from constante c WHERE C.CONSTANTE='DTHROTACION';

   select
    to_char(trunc(new_time(lc_fecfin_rotacion, 'EST', 'GMT')),
                         'yyyymmdd') || '0000' into lc_fecfin from dual;


  if(to_char(trunc(sysdate), 'DD/MM/YYYY')=lc_fecfin_rotacion) then
    select add_months(lc_fecfin_rotacion,12)
    into lc_fecfin_rotacion from dual;

    update constante set valor=lc_fecfin_rotacion
    WHERE CONSTANTE='DTHROTACION';
    commit;

   select
    to_char(trunc(new_time(lc_fecfin_rotacion, 'EST', 'GMT')),
                         'yyyymmdd') || '0000' into lc_fecfin from dual;

  end if;
--fin 38.0
    lc_bouquet := lpad(trim(a_bouquet), 8, '0');

    select count(distinct(tarjeta))
      into ln_cantidad
      from ope_archivo_tarjeta_tvsat_det
     where idarchivo = a_idarchivo
       and idprogramacion = a_idprogramacion;

    lc_cantidad := lpad(ln_cantidad, 6, '0');

    if ln_cantidad > 0 then
        --Ini 30
          lc_nom_arch:=f_genera_nombre_archivo(0,lc_prefijo_arch);
          lc_num_arch:=lpad(substr(lc_nom_arch,4,5),6,'0');
        --Fin 30
      /*select operacion.sq_filename_arch_env.nextval
        into ln_num_arch
        from dummy_ope;

      lc_num_arch := lpad(ln_num_arch, 6, '0');
      lc_nom_arch := lc_prefijo_arch || lc_num_arch || '.emm';*/

      -- 1.CREACION DE ARCHIVO DE SOLICITUD DE ACTIVACION DE CABLE SATELITAL

      --ABRE EL ARCHIVO
      operacion.pq_dth_interfaz.p_abrir_archivo(p_text_io,
                                                connex_i.pDirectorioLocal, --37.0
                                                lc_nom_arch,
                                                'W',
                                                a_resultado,
                                                a_mensaje);

      if a_resultado <> 'OK' then
        raise error_crear_archivo;
      end if;

      begin
        --ESCRIBE EN EL ARCHIVO
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                  lc_num_arch,
                                                  '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                  lc_bouquet,
                                                  '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                  lc_fecini,
                                                  '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                  lc_fecfin,
                                                  '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'EMM', '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                  lc_cantidad,
                                                  '1');

        for r_cursor in c_tarjetas loop
          --ESCRIBE LOS NUMEROS DE LAS TARJETAS A ACTIVAR
          operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                    r_cursor.tarjeta,
                                                    '1');
        end loop;
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'ZZZ', '1');
        --CIERRA EL ARCHIVO DE ACTIVACIÓN
        operacion.pq_dth_interfaz.p_cerrar_archivo(p_text_io);
      exception
        when others then
          raise error_escribir_archivo;
      end;

      --ENVIO DE ARCHIVO DE ACTIVACION CONAX
      begin
        operacion.pq_dth_interfaz.p_enviar_archivo_ascii(connex_i.phost, --37.0
                                                         connex_i.ppuerto, --37.0
                                                         connex_i.pusuario, --37.0
                                                         connex_i.ppass, --37.0
                                                         connex_i.pDirectorioLocal, --37.0
                                                         lc_nom_arch,
                                                         connex_i.pArchivoRemotoReq); --37.0

      exception
        when others then
          raise error_envio_archivo;
      end;

      select count(numregins)
        into ln_cantidad1
        from ope_programa_mensaje_tv_det
       where idprogramacion = a_idprogramacion;

      if ln_cantidad1 > 0 then
        select numregins
          into lc_numregins
          from ope_programa_mensaje_tv_det
         where idprogramacion = a_idprogramacion;

        select count(1)
          into ln_cantidad2
          from operacion.reg_archivos_enviados
         where numregins = lc_numregins;

        if ln_cantidad2 > 0 then
          delete operacion.reg_archivos_enviados
           where numregins = lc_numregins;
        end if;
      else
        select operacion.sq_reginsdth.nextval
          into ln_numregins
          from dummy_ope;

        lc_numregins := lpad(ln_numregins, 10, '0');
      end if;

      begin
        select operacion.sq_numtrans.nextval
          into ln_numtransacconax
          from dummy_ope;

        insert into operacion.log_reg_archivos_enviados
          (numregenv,
           numregins,
           filename,
           codigo_ext,
           tipo_proceso,
           numtrans)
        values
          (lc_num_arch,
           lc_numregins,
           lc_nom_arch,
           lc_bouquet,
           lc_tipo_envio,
           ln_numtransacconax);

        insert into operacion.reg_archivos_enviados
          (numregenv,
           numregins,
           filename,
           estado,
           codigo_ext,
           tipo_proceso,
           numtrans)
        values
          (lc_num_arch,
           lc_numregins,
           lc_nom_arch,
           1,
           lc_bouquet,
           lc_tipo_envio,
           ln_numtransacconax);
      exception
        when others then
          raise error_registro;
      end;
    else
      raise error_tarjeta;
    end if;
    begin
      update ope_programa_mensaje_tv_det
         set numregins = lc_numregins, estado = 2
       where idprogramacion = a_idprogramacion;
    exception
      when others then
        raise error_actualizar_regins;
    end;
    commit;
  exception
    when error_crear_archivo then
      a_resultado := 'ERROR';
      a_mensaje   := 'Error al crear archivo.';
      rollback;
    when error_escribir_archivo then
      a_resultado := 'ERROR';
      a_mensaje   := 'Error al escribir archivo.';
      rollback;
    when error_envio_archivo then
      a_resultado := 'ERROR';
      a_mensaje   := 'Error al enviar archivo a CONAX. Verificar la Conexión con CONAX.';
      rollback;
    when error_registro then
      a_resultado := 'ERROR';
      a_mensaje   := 'Error al registrar archivos a enviar.';
      rollback;
    when error_tarjeta then
      a_resultado := 'ERROR';
      a_mensaje   := 'No se puede generar archivo sin tarjetas.';
      rollback;
    when error_actualizar_regins then
      a_resultado := 'ERROR';
      a_mensaje   := 'No se pudo actualizar en la programación el campo identificador del envio.';
      rollback;
    when others then
      a_resultado := 'ERROR';
      a_mensaje   := 'Error: ' || sqlcode || ' ' || sqlerrm;
      rollback;
  end;

  procedure p_envia_mensaje_deco_dth(a_idarchivo      in ope_archivo_mensaje_tvsat_cab.idarchivo%type,
                                     a_idprogramacion in operacion.ope_programa_mensaje_tv_det.idprogramacion%type,
                                     a_resultado      in out varchar2,
                                     a_mensaje        in out varchar2) is

    p_text_io                utl_file.file_type;
    lc_nom_arch              varchar2(15);
    ln_numtransacconax       number(15);
    ln_cantidad              number(6);
    ln_cantidad1             number(6);
    ln_cantidad2             number(6);
    ln_numregins             number(10);
    lc_numregins             varchar2(10);
    lc_tipo_envio            char(1);
    -- lc_directorio_local_msn  varchar2(100);  --37.0
    -- lc_directorio_remoto_msn varchar2(100); --37.0
    lc_falta_configurar      varchar2(100);
    error_crear_archivo      exception;
    error_escribir_archivo   exception;
    error_envio_archivo      exception;
    error_registro           exception;
    error_tarjeta            exception;
    error_actualizar_regins  exception;
    error_configuracion      exception;

    connex_i operacion.conex_intraway;  --37.0

    cursor c_tarjetas is
      select distinct tarjeta
        from ope_archivo_tarjeta_tvsat_det
       where idarchivo = a_idarchivo
         and idprogramacion = a_idprogramacion
       order by tarjeta asc;

  begin
    connex_i :=operacion.pq_dth.f_crea_conexion_intraway;  --37.0

    a_resultado := 'OK';
    -- Ini 37.0
    /*

    begin
      select valor
        into lc_directorio_local_msn
        from constante
       where constante = 'DIR_LOC_DTH_MSN';
    exception
      when others then
        lc_falta_configurar := 'DIR_LOC_DTH_MSN';
        raise error_configuracion;
    end;

    begin
      select valor
        into lc_directorio_remoto_msn
        from constante
       where constante = 'DIR_REM_DTH_MSN';
    exception
      when others then
        lc_falta_configurar := 'DIR_REM_DTH_MSN';
        raise error_configuracion;
    end;
    */
    begin
      lc_nom_arch :=  operacion.pq_dth.f_obt_parametro_d('PARAM_DTH','Nom.arch.MSN');
      /*select valor
        into lc_nom_arch
        from constante
       where constante = 'NOM_ARC_DTH_MSN';*/
    exception
      when others then
        lc_falta_configurar := 'NOM_ARC_DTH_MSN';
        raise error_configuracion;
    end;
    -- Fin 37.0

    lc_tipo_envio := 'M';

    select count(distinct(tarjeta))
      into ln_cantidad
      from ope_archivo_tarjeta_tvsat_det
     where idarchivo = a_idarchivo
       and idprogramacion = a_idprogramacion;

    if ln_cantidad > 0 then
      -- 1. CREACION DE ARCHIVO DE SOLICITUD DE ACTIVACION DE CABLE SATELITAL
      --ABRE EL ARCHIVO
      operacion.pq_dth_interfaz.p_abrir_archivo(p_text_io,
                                                connex_i.pdirectorioLocal, --37.0
                                                lc_nom_arch,
                                                'W',
                                                a_resultado,
                                                a_mensaje);

      if a_resultado <> 'OK' then
        raise error_crear_archivo;
      end if;

      begin
        --2. ESCRIBIR EN EL ARCHIVO
        for r_cursor in c_tarjetas loop
          --ESCRIBE LOS NUMEROS SERIES DE LAS TARJETAS A ENVIAR MENSAJE
          operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                    r_cursor.tarjeta,
                                                    '1');
        end loop;

        --CIERRA EL ARCHIVO DE ACTIVACIÓN
        operacion.pq_dth_interfaz.p_cerrar_archivo(p_text_io);
      exception
        when others then
          raise error_escribir_archivo;
      end;

      --ENVIO DE ARCHIVO DE ACTIVACION CONAX
      begin
        operacion.pq_dth_interfaz.p_enviar_archivo_ascii(connex_i.phost, -- 37.0
                                                         connex_i.ppuerto, -- 37.0
                                                         connex_i.pusuario, -- 37.0
                                                         connex_i.ppass, -- 37.0
                                                         connex_i.pdirectorioLocal, -- 37.0
                                                         lc_nom_arch,
                                                         connex_i.pArchivoRemotoReq); -- 37.0

      exception
        when others then
          raise error_envio_archivo;
      end;

      select count(numregins)
        into ln_cantidad1
        from ope_programa_mensaje_tv_det
       where idprogramacion = a_idprogramacion;

      if ln_cantidad1 > 0 then
        select numregins
          into lc_numregins
          from ope_programa_mensaje_tv_det
         where idprogramacion = a_idprogramacion;

        select count(1)
          into ln_cantidad2
          from operacion.reg_archivos_enviados
         where numregins = lc_numregins;

        if ln_cantidad2 > 0 then
          delete operacion.reg_archivos_enviados
           where numregins = lc_numregins;
        end if;
      else
        select operacion.sq_reginsdth.nextval
          into ln_numregins
          from dummy_ope;

        lc_numregins := lpad(ln_numregins, 10, '0');
      end if;

      begin
        select operacion.sq_numtrans.nextval
          into ln_numtransacconax
          from dummy_ope;

        insert into operacion.log_reg_archivos_enviados
          (numregins, filename, tipo_proceso, numtrans)
        values
          (lc_numregins, lc_nom_arch, lc_tipo_envio, ln_numtransacconax);

        insert into operacion.reg_archivos_enviados
          (numregins, filename, estado, tipo_proceso, numtrans)
        values
          (lc_numregins, lc_nom_arch, 1, lc_tipo_envio, ln_numtransacconax);
      exception
        when others then
          raise error_registro;
      end;
    else
      raise error_tarjeta;
    end if;
    begin
      update ope_programa_mensaje_tv_det
         set numregins = lc_numregins, estado = 2
       where idprogramacion = a_idprogramacion;
    exception
      when others then
        raise error_actualizar_regins;
    end;
    commit;
  exception
    when error_configuracion then
      a_resultado := 'ERROR';
      a_mensaje   := 'Falta configurar el parámetro: ' ||
                     lc_falta_configurar ||
                     '. Por favor comunicarse con el área de Sistemas.';
      rollback;
    when error_crear_archivo then
      a_resultado := 'ERROR';
      a_mensaje   := 'Error al crear archivo.';
      rollback;
    when error_escribir_archivo then
      a_resultado := 'ERROR';
      a_mensaje   := 'Error al escribir archivo.';
      rollback;
    when error_envio_archivo then
      a_resultado := 'ERROR';
      a_mensaje   := 'Error al enviar archivo a CONAX. Verificar la Conexión con CONAX.';
      rollback;
    when error_registro then
      a_resultado := 'ERROR';
      a_mensaje   := 'Error al registrar archivos a enviar.';
      rollback;
    when error_tarjeta then
      a_resultado := 'ERROR';
      a_mensaje   := 'No se puede generar archivo sin tarjetas.';
      rollback;
    when error_actualizar_regins then
      a_resultado := 'ERROR';
      a_mensaje   := 'No se pudo actualizar en la programación el campo identificador del envio.';
      rollback;
    when others then
      a_resultado := 'ERROR';
      a_mensaje   := 'Error: ' || sqlcode || ' ' || sqlerrm;
      rollback;
  end;
  --11.0>

--24.0 Inicio
  procedure p_activa_bouquet_masivo3(p_numregistro in varchar2,
                                     p_grupo       in number, --24.0
                                     p_fecini      in varchar2,
                                     p_fecfin      in varchar2,
                                     p_idenvio     in number,
                                     p_resultado   in out varchar2,
                                     p_mensaje     in out varchar2) is
    p_text_io         utl_file.file_type;
    p_nombre          varchar2(15);
    l_numtransacconax number(15);
    s_numconax        varchar2(6);
    parchivolocalenv  varchar2(30);
    s_codext          varchar2(8);
    pidtarjeta        varchar2(11);
    lcantidad         number(15);
    pcantidad         varchar2(5);
    l_cantidad1       number;
    connex_i operacion.conex_intraway;  --37.0

    --Cursor nuevo de bouquets del grupo
    cursor c_bouquets is
      select codbouquet
        from ope_grupo_bouquet_det
       where flg_activo = 1
         and idgrupo = p_grupo
        order by codbouquet asc;
    --Cursor de tarjetas
    cursor c_tarjetas is
      select distinct idtarjeta
        from operacion.tmp_tarjetas
       where flg_incluido = 1
         and idenvio = p_idenvio
         and upper(codusu) = upper(user)
       order by idtarjeta asc;
  begin
    connex_i :=operacion.pq_dth.f_crea_conexion_intraway;  --37.0
    p_resultado := 'OK';
    --Validar archivo enviado
    select count(1)
      into l_cantidad1
      from operacion.reg_archivos_enviados
     where numregins = p_numregistro;
    if l_cantidad1 > 0 then
      delete operacion.reg_archivos_enviados
       where numregins = p_numregistro;
      commit;
    end if;
    --Validar cantidad de tarjetas
    select count(distinct(idtarjeta))
      into lcantidad
      from operacion.tmp_tarjetas
     where flg_incluido = 1
       and idenvio = p_idenvio
       and upper(codusu) = upper(user);
    pcantidad := lpad(lcantidad, 5, '0');
    if lcantidad > 0 and lcantidad is not null then
      --Lectura de los bouquets dek cursor nuevo

      for rbouquet in c_bouquets loop
        s_codext := to_char(rbouquet.codbouquet);
         --ini 30.0

        /*Pre Pago*/
        p_nombre:=f_genera_nombre_archivo(0,'ps');
        --s_numconax:=lpad(substr(p_nombre,4,5),6,'0');
        s_numconax:=lpad(substr(p_nombre,3,8),6,'0');--31.0
       --fin 30.0

        /*select operacion.sq_filename_arch_env.nextval
          into l_numconax
          from dummy_ope;
        s_numconax := lpad(l_numconax, 6, '0');
        p_nombre   := 'ps' || s_numconax || '.emm';*/

        -- 1.CREACION DE ARCHIVO DE SOLICITUD DE ACTIVACION DE CABLE SATELITAL
        --ABRE EL ARCHIVO
        operacion.pq_dth_interfaz.p_abrir_archivo(p_text_io,
                                                  connex_i.pdirectorioLocal, --37.0
                                                  p_nombre,
                                                  'W',
                                                  p_resultado,
                                                  p_mensaje);
        --ESCRIBE EN EL ARCHIVO
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                  s_numconax,
                                                  '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, s_codext, '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, p_fecini, '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, p_fecfin, '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'EMM', '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                  pcantidad,
                                                  '1');
        for r_cursor in c_tarjetas loop
          pidtarjeta := r_cursor.idtarjeta;
          --ESCRIBE LOS NUMEROS DE LAS TARJETAS A ACTIVAR
          operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                    pidtarjeta,
                                                    '1');
        end loop;
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'ZZZ', '1');
        --CIERRA EL ARCHIVO DE ACTIVACIÓN
        operacion.pq_dth_interfaz.p_cerrar_archivo(p_text_io);
        begin
          --ENVIO DE ARCHIVO DE ACTIVACION CONAX
          parchivolocalenv := p_nombre;
          operacion.pq_dth_interfaz.p_enviar_archivo_ascii(connex_i.phost, -- 37.0
                                                           connex_i.ppuerto,-- 37.0
                                                           connex_i.pusuario,-- 37.0
                                                           connex_i.ppass,-- 37.0
                                                           connex_i.pdirectorioLocal,-- 37.0
                                                           parchivolocalenv,
                                                           connex_i.parchivoremotoreq);-- 37.0

          begin
            select operacion.sq_numtrans.nextval
              into l_numtransacconax
              from dummy_ope;
            insert into operacion.log_reg_archivos_enviados
              (numregenv,
               numregins,
               filename,
               lastnumregenv,
               codigo_ext,
               tipo_proceso,
               numtrans)
            values
              (s_numconax,
               p_numregistro,
               p_nombre,
               s_numconax,
               s_codext,
               'A',
               l_numtransacconax);
            insert into operacion.reg_archivos_enviados
              (numregenv,
               numregins,
               filename,
               estado,
               lastnumregenv,
               codigo_ext,
               tipo_proceso,
               numtrans)
            values
              (s_numconax,
               p_numregistro,
               p_nombre,
               1,
               s_numconax,
               s_codext,
               'A',
               l_numtransacconax);
            commit;
          exception
            when others then
              rollback;
          end;
        exception
          when others then
            p_resultado := 'ERROR1';
        end;
      end loop;
    end if;
  exception
    when others then
      p_resultado := 'ERROR';
      p_mensaje   := 'Error al crear archivo. ' || sqlcode || ' ' ||
                     sqlerrm;
  end p_activa_bouquet_masivo3;

  procedure p_desactiva_bouquet_masivo3(p_numregistro in varchar2,
                                        p_grupo     in number,--24.0
                                        p_fecini      in varchar2,
                                        p_fecfin      in varchar2,
                                        p_idenvio     in number,
                                        p_resultado   in out varchar2,
                                        p_mensaje     in out varchar2) is
    p_text_io         utl_file.file_type;
    l_numtransacconax number(15);
    lcantidad         number(15);
    s_numconax        varchar2(6);
    parchivolocalenv  varchar2(30);
    p_nombre    varchar2(15);
    pcantidad   varchar2(5);
    s_codext    varchar2(10);
    pidtarjeta  varchar2(11);
    l_cantidad1 number;
    connex_i    operacion.conex_intraway;  --37.0

  --Cursor nuevo de bouquets del grupo
    cursor c_bouquets is
      select codbouquet
        from ope_grupo_bouquet_det
       where flg_activo = 1
         and idgrupo = p_grupo
       order by codbouquet asc;
    --Cursor de tarjetas
      cursor c_tarjetas is
      select distinct idtarjeta
        from operacion.tmp_tarjetas
       where flg_incluido = 1
         and idenvio = p_idenvio
         and upper(codusu) = upper(user)
       order by idtarjeta asc;
  begin
    connex_i :=operacion.pq_dth.f_crea_conexion_intraway;  --37.0

    p_resultado := 'OK';

    select count(*)
      into l_cantidad1
      from operacion.reg_archivos_enviados
     where numregins = p_numregistro;

    if l_cantidad1 > 0 then
      delete operacion.reg_archivos_enviados
       where numregins = p_numregistro;

      commit;
    end if;

    select count(distinct(idtarjeta))
      into lcantidad
      from operacion.tmp_tarjetas
     where flg_incluido = 1
       and idenvio = p_idenvio
       and upper(codusu) = upper(user);

    pcantidad := lpad(lcantidad, 5, '0');

    if lcantidad > 0 and lcantidad is not null then
    --Lectura de los bouquets dek cursor nuevo 24.0

    for rBouquet in c_bouquets loop
        s_codext := to_Char(rBouquet.codBouquet);
        --ini 30.0
        p_nombre:=f_genera_nombre_archivo(0,'cs');
        --s_numconax:=lpad(substr(p_nombre,4,5),6,'0');
        s_numconax:=lpad(substr(p_nombre,3,8),6,'0');--31.0
       --fin 30.0
        --CREACION DE ARCHIVO DE SOLICITUD DE BAJA DEL SERVICIO DE CABLE SATELITAL

        --ABRE EL ARCHIVO
        operacion.pq_dth_interfaz.p_abrir_archivo(p_text_io,
                                                  connex_i.pdirectorioLocal, --37.0
                                                  p_nombre,
                                                  'W',
                                                  p_resultado,
                                                  p_mensaje);

        --ESCRIBE EN EL ARCHIVO
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                  s_numconax,
                                                  '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, s_codext, '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, p_fecini, '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, p_fecfin, '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'EMM', '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                  pcantidad,
                                                  '1');
        for r_cursor in c_tarjetas loop
          pidtarjeta := r_cursor.idtarjeta;
          --ESCRIBE LOS NUMEROS DE LAS TARJETAS A DESACTIVAR
          operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                    pidtarjeta,
                                                    '1');
        end loop;
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'ZZZ', '1');
        --CIERRA EL ARCHIVO DE BAJA DEL SERVICIO DE CABLE SATELITAL
        operacion.pq_dth_interfaz.p_cerrar_archivo(p_text_io);

        begin

          --ENVIO DE ARCHIVO DE BAJA SERVICIO CABLE SATELITAL
          parchivolocalenv := p_nombre;
          operacion.pq_dth_interfaz.p_enviar_archivo_ascii(connex_i.phost, --37.0
                                                           connex_i.ppuerto, --37.0
                                                           connex_i.pusuario, --37.0
                                                           connex_i.ppass, --37.0
                                                           connex_i.pdirectorioLocal, --37.0
                                                           parchivolocalenv,
                                                           connex_i.parchivoremotoreq); --37.0

          begin
            select operacion.sq_numtrans.nextval
              into l_numtransacconax
              from dummy_ope;

            insert into operacion.log_reg_archivos_enviados
              (numregenv,
               numregins,
               filename,
               lastnumregenv,
               codigo_ext,
               tipo_proceso,
               numtrans)
            values
              (s_numconax,
               p_numregistro,
               p_nombre,
               s_numconax,
               s_codext,
               'B',
               l_numtransacconax);

            insert into operacion.reg_archivos_enviados
              (numregenv,
               numregins,
               filename,
               estado,
               lastnumregenv,
               codigo_ext,
               tipo_proceso,
               numtrans)
            values
              (s_numconax,
               p_numregistro,
               p_nombre,
               1,
               s_numconax,
               s_codext,
               'B',
               l_numtransacconax);

            commit;
          exception
            when others then
              rollback;
          end;

        exception
          when others then
            p_resultado := 'ERROR1';
        end;
      end loop;
    end if;
  exception
    when others then
      p_resultado := 'ERROR';
      p_mensaje   := 'Error al abrir archivo. ' || sqlcode || ' ' ||
                     sqlerrm;
  end p_desactiva_bouquet_masivo3;
--24.0 Fin

/* ini 25.0 */
  procedure p_val_equipos(p_codsolot solot.codsolot%type,
                          p_numser   in varchar2,
                          p_mac      in varchar2,
                          ln_mensaje in out number) is
  ln_contador  number;
  ln_contador2 number;
  ln_contador3 number;
  ln_contador4 number;

  begin
     BEGIN
     select count(1)
     into ln_contador2
     from operacion.tabequipo_material t
     where t.numero_serie = p_numser
     and t.imei_esn_ua <> p_mac;

     select count(1)
     into ln_contador3
     from operacion.tabequipo_material t
     where t.imei_esn_ua = p_mac
     and t.numero_serie <> p_numser;

       if ln_contador2 > 0 and ln_contador3 = 0 then
         ln_mensaje := 2; /* Numero de serie ya asignado*/
       end if;
       if ln_contador3 > 0 and ln_contador2 = 0 then
         ln_mensaje := 3; /* Unit address ya asignado*/
       end if;
       if ln_contador2 > 0 and ln_contador3 > 0 then
         ln_mensaje := 4; /* Numero de serie y Unit address ya asignado */
       end if;
       if ln_contador2 = 0 and ln_contador3 = 0 then
         ln_mensaje := 0; /* OK*/
       end if;

     EXCEPTION
     WHEN OTHERS THEN
      ln_mensaje := 0;
     END;



  end;
/* fiN 25.0 */
  --ini 28.0
  PROCEDURE p_desactivacion_conax(an_codsolot  IN NUMBER,
                                  an_cod_error out NUMBER,
                                  an_des_error out varchar) is

    ln_contador1 number :=0;
    ln_cant_tarj number :=0;
    ln_cant_deco number :=0;
    ls_numregistro varchar2(20);
    ls_resultado   varchar2(50);
    ls_mensaje     varchar2(200);
    ex_envio_conax         exception;
    cursor cur_desac_conax(cs_numregistro varchar2) is
      select equ_conax.grupo codigo,
             t.descripcion,
             se.numserie     numserie,
             se.mac          mac,
             se.cantidad     cantidad,
             i.codinssrv,
             se.codsolot,
             se.punto,
             se.orden,
             se.estado,
             a.cod_sap
        from solotptoequ se,
             solot s,
             solotpto sp,
             inssrv i,
             tipequ t,
             almtabmat a,
             (select a.codigon tipequ, to_number(codigoc) grupo
                from opedd a, tipopedd b
               where a.tipopedd = b.tipopedd
                 and b.abrev = 'TIPEQU_DTH_CONAX') equ_conax
       where se.codsolot = s.codsolot
         and s.codsolot = sp.codsolot
         and se.punto = sp.punto
         and sp.codinssrv = i.codinssrv
         and t.tipequ = se.tipequ
         and a.codmat = t.codtipequ
         and t.tipequ = equ_conax.tipequ
         and se.codsolot =
             (select codsolot
                from ope_srv_recarga_cab
               where numregistro = cs_numregistro)
         and se.estado = 4;
  begin

    select count(1)
      into ln_contador1
      from operacion.ope_envio_conax where codsolot = an_codsolot
       and tipo = 2;
    if ln_contador1 > 0 then
      delete from operacion.ope_envio_conax
       where codsolot = an_codsolot and tipo = 2;
      --commit;
    end if;

    select pq_inalambrico.f_obtener_numregistro(an_codsolot) into ls_numregistro from dual;

    FOR r_desc_conax IN cur_desac_conax(ls_numregistro) LOOP
      if r_desc_conax.codigo = 1 then
        ln_cant_tarj := ln_cant_tarj + 1;
      elsif r_desc_conax.codigo = 2 then
        ln_cant_deco := ln_cant_deco + 1;
      end if;
    end loop;
    if ln_cant_tarj <> ln_cant_deco then
      an_des_error := 'La cantidad de Tarjeta(s) y Decodificador(es) deben ser iguales';
      raise ex_envio_conax;
    end if;

    FOR r_desc_conax IN cur_desac_conax(ls_numregistro) LOOP
      if r_desc_conax.codigo = 1 then
        if r_desc_conax.numserie is not null then
          begin
           operacion.pq_dth.p_ins_envioconax(an_codsolot,r_desc_conax.codinssrv,2,r_desc_conax.numserie,null,null,null,r_desc_conax.codigo);
          exception
           when others then
              an_des_error := 'Error al generar desactivacion de la tarjeta # ' || r_desc_conax.numserie;
              raise ex_envio_conax;
          end;
        else
           an_des_error := 'Debe ingresar el Número de Serie de la tarjeta a desactivar';
           raise ex_envio_conax;
        end if;
      end if;
    end loop;

    operacion.pq_dth.p_baja_serviciodthxcliente(ls_numregistro,null,null,ls_resultado,ls_mensaje);
    if ls_resultado <> 'OK' then
      update ope_srv_recarga_det
        set mensaje = ls_mensaje
        where numregistro = ls_numregistro
        and tipsrv = (select valor from constante where constante = 'FAM_CABLE');
      an_des_error := 'Se produjo un error al enviar archivo a CONAX.';
      raise ex_envio_conax;
        --commit;
    end if;
  exception
    when ex_envio_conax then
      an_cod_error := -1;
  end;
  --fin 28.0
  --Ini 29.0
  procedure p_enviar_pareo_DTH(p_numregistro in operacion.reg_archivos_enviados.numregins%type,
                               p_codsolot    in solot.codsolot%type,
                               p_cant_pareo  in number,
                               p_resultado   in out varchar2,
                               p_mensaje     in out varchar2) is

    p_text_io_des     utl_file.file_type;
    p_pareo           varchar2(15);
    l_cantidad1       number;
    l_numtransacconax number(15);
    s_numconaxpareo   varchar2(6);
    p_pareoenv        varchar2(30);
    cantdecos         number;
    s_candecos        char(6);
    --Ini 30
    ln_obt_tp         number;
    --Fin 30
    connex_i operacion.conex_intraway;  --37.0
--ini 34.0
/*
    --cursor de unitaddress de decodificadores
    cursor c_equipos_tarjetas is
        select pareo.flg_pareo,
               pareo.nro_serie_deco,
               pareo.nro_serie_tarjeta
          from (select (INSTR((select se.numserie
                                from solotptoequ se
                               where se.codsolot = p_codsolot
                                 and se.mac = t.nro_serie_deco),
                              'TMX')) flg_pareo,
                       t.nro_serie_deco,
                       t.nro_serie_tarjeta
                  from operacion.tarjeta_deco_asoc t
                 where t.codsolot = p_codsolot) pareo
         where pareo.flg_pareo = 1;
*/
    --cursor de unitaddress de decodificadores
    CURSOR c_equipos_tarjetas IS
        SELECT
            t.nro_serie_deco,
            t.nro_serie_tarjeta
          FROM solotptoequ se, operacion.tarjeta_deco_asoc t
         WHERE t.codsolot = p_codsolot
           AND t.codsolot = se.codsolot
           AND se.mac = t.nro_serie_deco
           AND(-- cuenta si la nomenclatura numserie<tarjeta_deco_asoc> ESTA incluido en codigoc<tipos y estados>
                  SELECT COUNT(*)
                   FROM opedd a, tipopedd b
                  WHERE a.tipopedd = b.tipopedd
                   AND b.abrev = 'PREFIJO_DECO'
                   AND INSTR(UPPER(se.numserie), UPPER(TRIM(a.codigoc)))=1
               ) > 0;
     --fin 34.0

  begin
    connex_i :=operacion.pq_dth.f_crea_conexion_intraway;   --37.0

    p_resultado := 'OK';

  for c_et in c_equipos_tarjetas loop
    --GENERACIÓN DE UN SOLO ARCHIVO DE PAREO.

       --ini 30.0

        ln_obt_tp := f_obt_tipo_pago(p_numregistro, null);

        if ln_obt_tp = 2 then
            p_resultado := 'ERROR';
            p_mensaje   := 'Error al consultar numslc nulo.';
            return;
        else
           if ln_obt_tp = 1 then
                 /*Post Pago*/
                p_pareo:=f_genera_nombre_archivo(ln_obt_tp,'vp');
                --s_numconaxpareo:=lpad(substr(p_pareo,4,5),6,'0');
                s_numconaxpareo:=lpad(substr(p_pareo,3,8),6,'0');--31.0
           else
                 /*Pre Pago*/
                p_pareo:=f_genera_nombre_archivo(ln_obt_tp,'vp');
                --s_numconaxpareo:=lpad(substr(p_pareo,4,5),6,'0');
                s_numconaxpareo:=lpad(substr(p_pareo,3,8),6,'0');--31.0
           end if;
        end if;
       --fin 30.0
        /* select operacion.sq_filename_arch_env.nextval
          into l_numconaxpareo
          from dummy_ope;*/

/*    s_numconaxpareo := lpad(l_numconaxpareo, 6, '0');
    p_pareo         := 'vp' || s_numconaxpareo || '.emm';*/

    --1.CREACION DE ARCHIVO DE PAREO DEL EQUIPO

    --ABRE EL ARCHIVO
    operacion.pq_dth_interfaz.p_abrir_archivo(p_text_io_des,
                                              connex_i.pdirectorioLocal, --37.0
                                              p_pareo,
                                              'W',
                                              p_resultado,
                                              p_mensaje);
    --ESCRIBE EN EL ARCHIVO

    operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des, 'U', '1');
    operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des,
                                              s_numconaxpareo,
                                              '1');
    operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des,
                                              '00000001',
                                              '1');
    operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des, 'U', '1');
    operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des, 'U', '1');
    operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des, 'U', '1');
    operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des, 'EMM', '1');
    operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des, 'U', '1');

    operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des,
                                              '00002',
                                              '1');


        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des,
                                                  'S'||trim(c_et.nro_serie_tarjeta),
                                                  '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des,
                                                  'V'||trim(c_et.nro_serie_deco),
                                                  '1');



    operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des, 'ZZZ', '1');
    --CIERRA EL ARCHIVO DE PAREO
    operacion.pq_dth_interfaz.p_cerrar_archivo(p_text_io_des);

    begin

      select operacion.sq_numtrans.nextval
        into l_numtransacconax
        from dummy_ope;

      insert into operacion.log_reg_archivos_enviados
        (numregenv,
         numregins,
         filename,
         lastnumregenv,
         tipo_proceso,
         numtrans)
      values
        (s_numconaxpareo,
         p_numregistro,
         p_pareo,
         s_numconaxpareo,
         'P',
         l_numtransacconax);

      insert into operacion.reg_archivos_enviados
        (numregenv,
         numregins,
         filename,
         estado,
         lastnumregenv,
         tipo_proceso,
         numtrans)
      values
        (s_numconaxpareo,
         p_numregistro,
         p_pareo,
         1,
         s_numconaxpareo,
         'P',
         l_numtransacconax);

      commit;
    exception
      when others then
        rollback;
    end;
  end loop;
  exception
    when others then
      p_resultado := 'ERROR';
      p_mensaje   := 'Error Pareo ' || sqlcode || ' ' || sqlerrm;
  end p_enviar_pareo_DTH;

  procedure p_enviar_despareo_DTH(p_numregistro   in operacion.reg_archivos_enviados.numregins%type,
                                  p_codsolot      in solot.codsolot%type,
                                  p_cant_despareo in number,
                                  p_resultado     in out varchar2,
                                  p_mensaje       in out varchar2) is

    p_text_io_des      utl_file.file_type;
    p_despareo         varchar2(15);
    l_cantidad1        number;
    l_numtransacconax  number(15);
    s_numconaxdespareo varchar2(6);
    p_despareoenv      varchar2(30);
    cantdecos          number;
    s_candecos         char(6);
    --Ini 30
    ln_obt_tp          number;
    connex_i operacion.conex_intraway;  --37.0
    --Fin 30
--ini 34.0
/*
    --cursor de unitaddress de decodificadores
    cursor c_equipos_tarjetas is
        select despareo.flg_pareo, despareo.nro_serie_deco, despareo.nro_serie_tarjeta
          from (select (INSTR((select se.numserie
                                from solotptoequ se
                               where se.codsolot = p_codsolot
                                 and se.mac = t.nro_serie_deco),
                              'TMX')) flg_pareo,
                       t.nro_serie_deco,
                       t.nro_serie_tarjeta
                  from operacion.tarjeta_deco_asoc t
                 where t.codsolot = p_codsolot) despareo
         where despareo.flg_pareo = 0;
*/
    --cursor de unitaddress de decodificadores
    CURSOR c_equipos_tarjetas IS
    SELECT
      t.nro_serie_deco,
      t.nro_serie_tarjeta
    FROM solotptoequ se, operacion.tarjeta_deco_asoc t
    WHERE t.codsolot = p_codsolot
     AND t.codsolot = se.codsolot
     AND se.mac = t.nro_serie_deco
     AND(-- cuenta si la nomenclatura numserie<tarjeta_deco_asoc> NO ESTA incluido en codigoc<tipos y estados>
            SELECT COUNT(*)
             FROM opedd a, tipopedd b
            WHERE a.tipopedd = b.tipopedd
             AND b.abrev = 'PREFIJO_DECO'
             AND INSTR(UPPER(se.numserie), UPPER(TRIM(a.codigoc)))=1
         ) = 0;
--fin 34.0
  begin
    connex_i :=operacion.pq_dth.f_crea_conexion_intraway;  --37.0

    p_resultado := 'OK';

    --GENERACIÓN DE UN SOLO ARCHIVO DE DESPAREO.


        ln_obt_tp := f_obt_tipo_pago(p_numregistro, null);

        if ln_obt_tp = 2 then
            p_resultado := 'ERROR';
            p_mensaje   := 'Error al consultar numslc nulo.';
            return;
        else
           if ln_obt_tp = 1 then
                 /*Post Pago*/
                 p_despareo:=f_genera_nombre_archivo(ln_obt_tp,'gp');
                 --s_numconaxdespareo:=lpad(substr(p_despareo,4,5),6,'0');
                 s_numconaxdespareo:=lpad(substr(p_despareo,3,8),6,'0');--31.0
           else
                /*Pre Pago*/
                 p_despareo:=f_genera_nombre_archivo(ln_obt_tp,'gp');
                 --s_numconaxdespareo:=lpad(substr(p_despareo,4,5),6,'0');
                 s_numconaxdespareo:=lpad(substr(p_despareo,3,8),6,'0');--31.0
           end if;
        end if;

        /*select operacion.sq_filename_arch_env.nextval
          into l_numconaxdespareo
          from dummy_ope;*/

       --fin 30.0

    /*s_numconaxdespareo := lpad(l_numconaxdespareo, 6, '0');
    p_despareo         := 'gp' || s_numconaxdespareo || '.emm';*/

    --1.CREACION DE ARCHIVO DE DESPAREO DEL EQUIPO

    --ABRE EL ARCHIVO
    operacion.pq_dth_interfaz.p_abrir_archivo(p_text_io_des,
                                              connex_i.pdirectorioLocal, --37.0
                                              p_despareo,
                                              'W',
                                              p_resultado,
                                              p_mensaje);
    --ESCRIBE EN EL ARCHIVO
    operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des, '01', '1');
    operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des,
                                              s_numconaxdespareo,
                                              '1');
    operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des,
                                              '00001001',
                                              '1');
    operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des, 'U', '1');
    operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des, 'U', '1');
    operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des, 'U', '1');
    operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des, 'U', '1');
    operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des, 'U', '1');
    operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des, 'EMM', '1');

    s_candecos := lpad(p_cant_despareo, 6, '0');

    operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des,
                                              s_candecos,
                                              '1');
    for c_et in c_equipos_tarjetas loop
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des,
                                                  trim(c_et.nro_serie_deco),
                                                  '1');
    end loop;

    operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des, 'ZZZ', '1');
    --CIERRA EL ARCHIVO DE DESPAREO
    operacion.pq_dth_interfaz.p_cerrar_archivo(p_text_io_des);

    begin

      select operacion.sq_numtrans.nextval
        into l_numtransacconax
        from dummy_ope;

      insert into operacion.log_reg_archivos_enviados
        (numregenv,
         numregins,
         filename,
         lastnumregenv,
         tipo_proceso,
         numtrans)
      values
        (s_numconaxdespareo,
         p_numregistro,
         p_despareo,
         s_numconaxdespareo,
         'D',
         l_numtransacconax);

      insert into operacion.reg_archivos_enviados
        (numregenv,
         numregins,
         filename,
         estado,
         lastnumregenv,
         tipo_proceso,
         numtrans)
      values
        (s_numconaxdespareo,
         p_numregistro,
         p_despareo,
         1,
         s_numconaxdespareo,
         'D',
         l_numtransacconax);

      commit;
    exception
      when others then
        rollback;
    end;

  exception
    when others then
      p_resultado := 'ERROR';
      p_mensaje   := 'Error Despareo ' || sqlcode || ' ' || sqlerrm;
  end p_enviar_despareo_DTH;

  --<30.0 cvega
  function f_obt_tipo_pago(as_num_registro in operacion.ope_srv_recarga_cab.numregistro%type,
                          as_codsolot     in operacion.ope_srv_recarga_cab.codsolot%type )
    return number is

    ln_count        number;
    ln_dth          number;
    ls_numslc operacion.ope_srv_recarga_cab.numslc%type;

  begin

  ls_numslc := null;


  if as_codsolot is not null then

    select count(*)
    into ln_count
    from operacion.ope_srv_recarga_cab r
    where r.codsolot = as_codsolot;

    if ln_count = 0 then
       return 2;
    end if;


    select r.numslc
    into ls_numslc
    from operacion.ope_srv_recarga_cab r
    where r.codsolot = as_codsolot;

    if ls_numslc is null then
      return 2;
    end if;

    ln_dth := sales.pq_dth_postventa.f_obt_facturable_dth(ls_numslc);

    IF ln_dth = 1 THEN
       return 1;
    end if;


  else
    if as_num_registro is not null then

      select count(*)
      into ln_count
      from operacion.ope_srv_recarga_cab r
      where r.numregistro = as_num_registro;

      if ln_count = 0 then
       return 2;
      end if;

      select r.numslc
      into ls_numslc
      from operacion.ope_srv_recarga_cab r
      where r.numregistro = as_num_registro;

      if ls_numslc is null then
        return 2;
      end if;

      ln_dth := sales.pq_dth_postventa.f_obt_facturable_dth(ls_numslc);

      IF ln_dth = 1 THEN
         return 1;
      end if;

    else
      return 2;
    end if;
  end if;

  return 0;

  end;
  /*fin*/
--30.0> cvega

--Ini 30
  function f_genera_nombre_archivo(tipoplan   in number,
                                   tipoestado varchar2)
  return varchar2 is

  l_varconf number;
  l_series number;
  l_series_aux number;
  l_numconax number;
  ln_tipopedd number;
  ln_valor CONSTANT NUMBER := 99999;
  p_nombre varchar2(12);
  l_serieconf varchar2(1);
  s_numconax varchar2(5);

  Begin

    if tipoplan = 1 then
        /*Post Pago*/
        /*Cantidad de series configuradas*/
          select Count(codigon), ope.tipopedd
           into l_varconf, ln_tipopedd
            from operacion.tipopedd tip
           inner join operacion.opedd ope on tip.tipopedd = ope.tipopedd
           where tip.abrev = 'SECUENCIA_POSTPAGO' and codigon<>0
           group by ope.tipopedd;

         /*Cantidad de Series Usadas*/
         select Count(1)
          into l_series
          from operacion.tipopedd tip
         inner join operacion.opedd ope on tip.tipopedd = ope.tipopedd
         where tip.abrev = 'SECUENCIA_POSTPAGO' and ope.codigon_aux=1;

         if l_series=0 then

           Update operacion.opedd
              Set codigon_aux= 1
             Where tipopedd=ln_tipopedd and codigon=1;

            l_series:=1;
         end if;

           /*Secuencial del archivo a generar*/
            select operacion.sq_filename_arch_env_post.nextval
              into l_numconax
              from dummy_ope;

            /*Serie configurada por el Usuario*/
            select ope.codigoc
            into l_serieconf
            from operacion.tipopedd tip
            inner join operacion.opedd ope on tip.tipopedd = ope.tipopedd
            where tip.abrev = 'SECUENCIA_POSTPAGO' and ope.codigon=l_series;

          if l_series<l_varconf then
            if l_numconax=ln_valor then
               --genera el formato
               s_numconax := lpad(l_numconax, 5, '0');
               p_nombre   := tipoestado || l_serieconf || s_numconax || '.emm';
               --resetear secuencial -------------------------------
               operacion.pq_dth.p_reset_seq('operacion.sq_filename_arch_env_post');
               ------------------------------------------------------------------------
               --Si llega al valor maximo actualizo el siguiente valor configurable---
               l_series_aux:=l_series+1;
                Update operacion.opedd
                   Set codigon_aux= 1
                 Where tipopedd=ln_tipopedd and codigon=l_series_aux;
             else
                --genera el formato
                 s_numconax := lpad(l_numconax, 5, '0');
                 p_nombre   := tipoestado || l_serieconf || s_numconax || '.emm';
             end if;
           else
               if l_series=l_varconf then

                  if l_numconax=ln_valor then
                     --genera el formato
                       s_numconax := lpad(l_numconax, 5, '0');
                       p_nombre   := tipoestado || l_serieconf || s_numconax || '.emm';
                     --Actualiza todos los valores configurables para su reinicio---
                     Update operacion.opedd
                     Set codigon_aux=0
                     Where tipopedd=ln_tipopedd;
                     --Reinicia Secuencial
                     operacion.pq_dth.p_reset_seq('operacion.sq_filename_arch_env_post');
                  else
                     --genera el formato
                       s_numconax := lpad(l_numconax, 5, '0');
                       p_nombre   := tipoestado || l_serieconf || s_numconax || '.emm';
                  end if;
               end if;
           end if;

     else
        if tipoplan = 0 then
        /*Pre Pago*/
        /*Cantidad de series configuradas*/
          select Count(codigon), ope.tipopedd
           into l_varconf, ln_tipopedd
            from operacion.tipopedd tip
           inner join operacion.opedd ope on tip.tipopedd = ope.tipopedd
           where tip.abrev = 'SECUENCIA_PREPAGO' and codigon<>0
           group by ope.tipopedd;

         /*Cantidad de Series Usadas*/
         select Count(1)
          into l_series
          from operacion.tipopedd tip
         inner join operacion.opedd ope on tip.tipopedd = ope.tipopedd
         where tip.abrev = 'SECUENCIA_PREPAGO' and ope.codigon_aux=1;

         if l_series=0 then

           Update operacion.opedd
              Set codigon_aux= 1
             Where tipopedd=ln_tipopedd and codigon=1;

            l_series:=1;
         end if;

           /*Secuencial del archivo a generar*/
            select operacion.sq_filename_arch_env_pre.nextval
              into l_numconax
              from dummy_ope;

            /*Serie configurada por el Usuario*/
            select ope.codigoc
            into l_serieconf
            from operacion.tipopedd tip
            inner join operacion.opedd ope on tip.tipopedd = ope.tipopedd
            where tip.abrev = 'SECUENCIA_PREPAGO' and ope.codigon=l_series;

          if l_series<l_varconf then
            if l_numconax=ln_valor then
               --genera el formato
               s_numconax := lpad(l_numconax, 5, '0');
               p_nombre   := tipoestado || l_serieconf || s_numconax || '.emm';
               --resetear secuencial
               operacion.pq_dth.p_reset_seq('operacion.sq_filename_arch_env_pre');
               --Si llega al valor maximo actualizo el siguiente valor configurable---
               l_series_aux:=l_series+1;
                Update operacion.opedd
                   Set codigon_aux= 1
                 Where tipopedd=ln_tipopedd and codigon=l_series_aux;
             else
                --genera el formato
                 s_numconax := lpad(l_numconax, 5, '0');
                 p_nombre   := tipoestado || l_serieconf || s_numconax || '.emm';
             end if;
           else
               if l_series=l_varconf then

                  if l_numconax=ln_valor then
                     --genera el formato
                       s_numconax := lpad(l_numconax, 5, '0');
                       p_nombre   := tipoestado || l_serieconf || s_numconax || '.emm';
                     --Actualiza todos los valores configurables para su reinicio---
                     Update operacion.opedd
                     Set codigon_aux=0
                     Where tipopedd=ln_tipopedd;
                     --resetear secuencial
                     operacion.pq_dth.p_reset_seq('operacion.sq_filename_arch_env_pre');
                  else
                     --genera el formato
                       s_numconax := lpad(l_numconax, 5, '0');
                       p_nombre   := tipoestado || l_serieconf || s_numconax || '.emm';
                  end if;
               end if;
           end if;
        end if;
     end if;
  return p_nombre;
  End;

procedure p_reset_seq(p_seq_name in varchar2) is
  l_val number;
begin
  execute immediate 'select ' || p_seq_name || '.nextval from dual'
    INTO l_val;
  execute immediate 'alter sequence ' || p_seq_name || ' increment by -' ||
                    l_val || ' minvalue 0';
  execute immediate 'select ' || p_seq_name || '.nextval from dual'
    INTO l_val;
  execute immediate 'alter sequence ' || p_seq_name ||
                    ' increment by 1 minvalue 0';
end;

--Fin 30
-- Ini 35.0
/* **********************************************************************************************/
function f_obt_parametro_d(abrev_tipop varchar2, abrev varchar2)
return varchar2
is
lc_valor varchar2(100);
lc_valor_t number;
begin
  select tipopedd into lc_valor_t
    from operacion.tipopedd t
   where t.abrev=abrev_tipop;

  select descripcion
    into lc_valor
    from operacion.opedd o
   where o.tipopedd = lc_valor_t
     and o.abreviacion= abrev;

  if lc_valor is null then
    lc_valor := null;
  end if;

  return trim(lc_valor);
exception when others then raise_application_error(-20080, sqlerrm);
end;
/* **********************************************************************************************/
  function f_crea_conexion_intraway return operacion.conex_intraway is

  conex_aux operacion.conex_intraway;

  lc_host               VARCHAR2(30);
  lc_ppuerto            VARCHAR2(20);
  lc_usuario            VARCHAR2(20);
  lc_pass               VARCHAR2(50);
  lc_directorioLocal    VARCHAR2(100);
  lc_directorioLocal2    VARCHAR2(100);
  lc_ArchivoRemotoReq   VARCHAR2(100);
  lc_pArchivoLocalEnv   VARCHAR2(100);
  lc_ArchivoRemotoOK    VARCHAR2(100);
  lc_ArchivoRemotoError VARCHAR2(100);
  lc_ArchivoLocalRec    VARCHAR2(100);
  lc_errors_local       VARCHAR2(100);
  lc_errors_remoto      VARCHAR2(100);
  lc_errors_remoto2     VARCHAR2(100);

  begin

    lc_host                 := operacion.pq_dth.f_obt_parametro_d('PARAM_DTH','HOST');
    lc_ppuerto              := operacion.pq_dth.f_obt_parametro_d('PARAM_DTH','PUERTO');
    lc_usuario              := operacion.pq_dth.f_obt_parametro_d('PARAM_DTH','USUARIO');
    lc_pass                 := operacion.pq_dth.f_obt_parametro_d('PARAM_DTH','IDRSA');
    lc_directorioLocal      := operacion.pq_dth.f_obt_parametro_d('PARAM_DTH','DirectorioLocal');
    lc_directorioLocal2     := operacion.pq_dth.f_obt_parametro_d('PARAM_DTH','DirectorioLocal2');
    lc_ArchivoRemotoReq     := operacion.pq_dth.f_obt_parametro_d('PARAM_DTH','Dir.remoto.Req');
    lc_ArchivoRemotoOK      := operacion.pq_dth.f_obt_parametro_d('PARAM_DTH','Dir.remoto.Ok');
    lc_ArchivoRemotoError   := operacion.pq_dth.f_obt_parametro_d('PARAM_DTH','Dir.remoto.Error');
    lc_errors_local         := operacion.pq_dth.f_obt_parametro_d('PARAM_DTH','arch.Error');
    lc_errors_remoto        := operacion.pq_dth.f_obt_parametro_d('PARAM_DTH','Dir.arch.Error');
    lc_errors_remoto2       := operacion.pq_dth.f_obt_parametro_d('PARAM_DTH','Dir.arch.Error2');

    conex_aux := conex_intraway(lc_host,
                                lc_ppuerto,
                                lc_usuario,
                                lc_pass,
                                lc_directorioLocal,
                                lc_directorioLocal2,
                                lc_ArchivoRemotoReq,
                                lc_ArchivoRemotoOK,
                                lc_ArchivoRemotoError,
                                lc_errors_local,
                                lc_errors_remoto,
                                lc_errors_remoto2);

    return conex_aux;
  end;
-- Fin 35.0
--<36.0

 procedure p_envia_correo_dth(as_asunto varchar2, as_texto varchar2 )

   is

      cursor c_envio
      is
         select opb.codigoc
         from operacion.opedd opb
         where opb.tipopedd in (select tipopedd from tipopedd tpp where tpp.abrev = 'MAIL_DTH');
   begin

     for r_envio in c_envio
       loop
         --envio de correo
         soporte.p_envia_correo_c_attach (as_asunto,r_envio.codigoc,as_texto,null,'SGA');
      end loop;

 end p_envia_correo_dth;

 function f_valida_estado(as_numregistro   in varchar2
                                  ) return number is

  ln_estado number;

  begin

  select count(1)
  into ln_estado
  from operacion.ope_srv_recarga_cab s
  where s.numregistro = as_numregistro  and
        s.estado      = '04';


    RETURN ln_estado;
  END;
--36.0>
  --<ini 39.0>
  PROCEDURE p_crear_archivo_conax_asoc(p_numregistro IN VARCHAR2,
                                       p_solot_post  IN NUMBER,
                                       p_resultado   IN OUT VARCHAR2,
                                       p_mensaje     IN OUT VARCHAR2) IS

    p_text_io         utl_file.file_type;
    p_text_io_des     utl_file.file_type;
    p_nombre          VARCHAR2(15);
    l_cantidad1       NUMBER;
    l_numtransacconax NUMBER(15);
    s_numconax        VARCHAR2(6);

    parchivolocalenv VARCHAR2(30);
    pdespareoenv     VARCHAR2(30);
    s_bouquets       tystabsrv.codigo_ext%TYPE;

    s_numslc           CHAR(10);
    n_largo            NUMBER;
    numbouquets        NUMBER;
    cantdecos          NUMBER;
    canttarjetas       NUMBER;
    s_candecos         CHAR(6);
    s_canttarjetas     CHAR(6);
    p_fecini           VARCHAR2(12);
    p_fecfin           VARCHAR2(12);
    lc_fecfin_rotacion VARCHAR2(12);
    p_idpaq            NUMBER;
    ln_dth             NUMBER;
    ln_pareo           NUMBER;
    ln_despareo        NUMBER;
    l_solot_deco       NUMBER;
    ls_resultado       VARCHAR2(5);
    ls_mensaje         VARCHAR2(6000);
    error_asociado EXCEPTION;
    ln_obt_tp         NUMBER;
    ln_codsolot       solot.codsolot%TYPE;
    connex_i          operacion.conex_intraway;
    ln_deco_adicional NUMBER;
    l_numregistro     VARCHAR2(30);
    l_numslc          VARCHAR2(10);

    --Cursor de Codigos Externos: Tipo de Venta Normal(Proyecto Generado)
    --Servicio Principal
    CURSOR c_codigos_ext_ventas_princ IS
      SELECT TRIM(pq_ope_bouquet.f_conca_bouquet_c(r.idgrupo)) codigo_ext,
             r.idgrupo,
             pq_vta_paquete_recarga.f_get_pid(p_numregistro, v.iddet) pid,
             t.codsrv,
             'PRINCIPAL' clase
        FROM vtadetptoenl v, tystabsrv t, tys_tabsrvxbouquet_rel r
       WHERE v.numslc = s_numslc
         AND v.flgsrv_pri = 1
         AND v.codsrv = t.codsrv
         AND t.codsrv = r.codsrv
         AND r.estbou = 1
         AND r.stsrvb = 1

      -- Cursor de Bouquets promocionales
      UNION ALL
      SELECT DISTINCT b.descripcion,
                      gb.idgrupo,
                      NULL pid,
                      pv.codsrv,
                      'PROMOCION' clase
        FROM fac_prom_detalle_venta_mae pv,
             ope_grupo_bouquet_det      gb,
             ope_bouquet_mae            b
       WHERE pv.numslc = s_numslc
         AND pv.idgrupo = gb.idgrupo
         AND gb.codbouquet = b.codbouquet
         AND gb.flg_activo = 1
         AND b.flg_activo = 1
         AND b.descripcion IS NOT NULL;

    --Servicios Adicionales
    CURSOR c_codigos_ext_ventas_adic IS
      SELECT TRIM(pq_ope_bouquet.f_conca_bouquet_c(r.idgrupo)) codigo_ext,
             r.idgrupo,
             pq_vta_paquete_recarga.f_get_pid(p_numregistro, v.iddet) pid,
             t.codsrv,
             pq_vta_paquete_recarga.f_is_cnr(s_numslc, v.iddet) flg_cnr
        FROM vtadetptoenl v, tystabsrv t, tys_tabsrvxbouquet_rel r
       WHERE v.numslc = s_numslc
         AND v.flgsrv_pri = 0
         AND v.codsrv = t.codsrv
         AND t.codsrv = r.codsrv
         AND r.estbou = 1
         AND r.stsrvb = 1;

    --cursor de series de tarjetas
    CURSOR c_tarjetas IS
      SELECT numserie serie
        FROM solotptoequ
       WHERE codsolot = p_solot_post
         AND tipequ IN (SELECT a.codigon tipequope
                          FROM opedd a, tipopedd b
                         WHERE a.tipopedd = b.tipopedd
                           AND b.abrev = 'TIPEQU_DTH_CONAX'
                           AND codigoc = '1')
       ORDER BY numserie;

    --cursor de unitaddress de decodificadores

    CURSOR c_unitaddress IS
      SELECT mac unitaddress
        FROM solotptoequ
       WHERE codsolot = p_solot_post
         AND tipequ IN (SELECT a.codigon tipequope
                          FROM opedd a, tipopedd b
                         WHERE a.tipopedd = b.tipopedd
                           AND b.abrev = 'TIPEQU_DTH_CONAX'
                           AND codigoc = '2')
       ORDER BY mac;

    s_codext  VARCHAR2(8);
    ln_is_cnr NUMBER;
    ln_tipo   NUMBER;
  BEGIN
    connex_i    := operacion.pq_dth.f_crea_conexion_intraway;
    p_resultado := 'OK';

    SELECT to_char(trunc(new_time(SYSDATE, 'EST', 'GMT'), 'MM'), 'yyyymmdd') ||
           '0000'
      INTO p_fecini
      FROM dummy_ope;

    SELECT to_char(c.valor)
      INTO lc_fecfin_rotacion

      FROM constante c
     WHERE c.constante = 'DTHROTACION';

    SELECT to_char(trunc(new_time(lc_fecfin_rotacion, 'EST', 'GMT')),

                   'yyyymmdd') || '0000'
      INTO p_fecfin
      FROM dual;

    IF (to_char(trunc(SYSDATE), 'DD/MM/YYYY') = lc_fecfin_rotacion) THEN
      SELECT add_months(lc_fecfin_rotacion, 12)
        INTO lc_fecfin_rotacion
        FROM dual;

      UPDATE constante
         SET valor = lc_fecfin_rotacion
       WHERE constante = 'DTHROTACION';
      COMMIT;

      SELECT to_char(trunc(new_time(lc_fecfin_rotacion, 'EST', 'GMT')),
                     'yyyymmdd') || '0000'
        INTO p_fecfin
        FROM dual;

    END IF;

    SELECT numslc
      INTO s_numslc
      FROM ope_srv_recarga_cab
     WHERE numregistro = p_numregistro;

    DELETE operacion.bouquetxreginsdth WHERE numregistro = p_numregistro;

    SELECT COUNT(*)
      INTO l_cantidad1
      FROM operacion.reg_archivos_enviados
     WHERE numregins = p_numregistro;

    IF l_cantidad1 > 0 THEN
      DELETE operacion.reg_archivos_enviados
       WHERE numregins = p_numregistro;

      COMMIT;
    END IF;

    SELECT COUNT(*)
      INTO l_solot_deco
      FROM operacion.tarjeta_deco_asoc t
     WHERE codsolot = p_solot_post;

    IF l_solot_deco = 0 THEN
      ls_mensaje := 'No se asoció Tarjeta con Decodificador';
      RAISE error_asociado;
    END IF;

    --si codsolot ESTA asociado al decodificador
    IF l_solot_deco > 0 THEN

      SELECT COUNT(DISTINCT se.mac)
        INTO ln_pareo
        FROM solotptoequ se, operacion.tarjeta_deco_asoc t
       WHERE t.codsolot = p_solot_post
         AND t.codsolot = se.codsolot
         AND se.mac = t.nro_serie_deco;

      IF ln_pareo > 0 THEN
        p_enviar_pareo_asoc(p_numregistro,
                            p_solot_post,
                            ln_pareo,
                            ls_resultado,
                            ls_mensaje);
        IF ls_resultado <> 'OK' THEN
          RAISE error_asociado;
        END IF;
      END IF;

    END IF;

    FOR c_cod_ext_vp IN c_codigos_ext_ventas_princ LOOP

      s_bouquets  := TRIM(c_cod_ext_vp.codigo_ext);
      n_largo     := length(s_bouquets);
      numbouquets := (n_largo + 1) / 4;

      FOR i IN 1 .. numbouquets LOOP
        s_codext := lpad(operacion.f_cb_subcadena2(s_bouquets, i), 8, '0');

        ln_obt_tp  := f_obt_tipo_pago(p_numregistro, NULL);
        p_nombre   := f_genera_nombre_archivo(ln_obt_tp, 'ps');
        s_numconax := lpad(substr(p_nombre, 3, 8), 6, '0');

        -- 2.CREACION DE ARCHIVO DE SOLICITUD DE ACTIVACION DE CABLE SATELITAL

        --ABRE EL ARCHIVO
        operacion.pq_dth_interfaz.p_abrir_archivo(p_text_io,
                                                  connex_i.pdirectoriolocal,
                                                  p_nombre,
                                                  'W',
                                                  p_resultado,
                                                  p_mensaje);
        --ESCRIBE EN EL ARCHIVO
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                  s_numconax,
                                                  '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, s_codext, '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, p_fecini, '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, p_fecfin, '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'EMM', '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');

        --contador de tarjetas

        SELECT COUNT(1)
          INTO canttarjetas
          FROM solotptoequ
         WHERE codsolot = p_solot_post
           AND tipequ IN (SELECT a.codigon tipequope
                            FROM opedd a, tipopedd b
                           WHERE a.tipopedd = b.tipopedd
                             AND b.abrev = 'TIPEQU_DTH_CONAX'
                             AND codigoc = '1');

        s_canttarjetas := lpad(canttarjetas, 6, '0');

        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                  s_canttarjetas,
                                                  '1');

        FOR c_cards IN c_tarjetas LOOP
          operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                    TRIM(c_cards.serie),
                                                    '1');

        END LOOP;

        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'ZZZ', '1');

        --CIERRA EL ARCHIVO DE ACTIVACIÓN
        operacion.pq_dth_interfaz.p_cerrar_archivo(p_text_io);

        BEGIN

          --ENVIO DE ARCHIVO DE ACTIVACION CONAX
          parchivolocalenv := p_nombre;
          operacion.pq_dth_interfaz.p_enviar_archivo_ascii(connex_i.phost,
                                                           connex_i.ppuerto,
                                                           connex_i.pusuario,
                                                           connex_i.ppass,
                                                           connex_i.pdirectoriolocal,
                                                           parchivolocalenv,
                                                           connex_i.parchivoremotoreq);

          BEGIN

            SELECT operacion.sq_numtrans.nextval
              INTO l_numtransacconax
              FROM dummy_ope;

            INSERT INTO operacion.log_reg_archivos_enviados
              (numregenv,
               numregins,
               filename,
               lastnumregenv,
               codigo_ext,
               tipo_proceso,
               numtrans)
            VALUES
              (s_numconax,
               p_numregistro,
               p_nombre,
               s_numconax,
               s_codext,
               'A',
               l_numtransacconax);

            INSERT INTO operacion.reg_archivos_enviados
              (numregenv,
               numregins,
               filename,
               estado,
               lastnumregenv,
               codigo_ext,
               tipo_proceso,
               numtrans)
            VALUES
              (s_numconax,
               p_numregistro,
               p_nombre,
               1,

               s_numconax,
               s_codext,
               'A',
               l_numtransacconax);

            COMMIT;
          EXCEPTION
            WHEN OTHERS THEN
              ROLLBACK;
          END;
        EXCEPTION
          WHEN OTHERS THEN
            p_resultado := 'ERROR1';
        END;
      END LOOP;

      IF c_cod_ext_vp.clase = 'PRINCIPAL' THEN

        BEGIN

          INSERT INTO operacion.bouquetxreginsdth

            (numregistro, codsrv, bouquets, tipo, estado, idgrupo, pid)
          VALUES
            (p_numregistro,
             c_cod_ext_vp.codsrv,
             c_cod_ext_vp.codigo_ext,
             1,
             1,
             c_cod_ext_vp.idgrupo,
             c_cod_ext_vp.pid);
          COMMIT;
        EXCEPTION
          WHEN OTHERS THEN
            ROLLBACK;
        END;

      END IF;
    END LOOP;
    FOR c_cod_ext_va IN c_codigos_ext_ventas_adic LOOP
      s_bouquets  := TRIM(c_cod_ext_va.codigo_ext);
      n_largo     := length(s_bouquets);
      numbouquets := (n_largo + 1) / 4;

      FOR i IN 1 .. numbouquets LOOP
        s_codext  := lpad(operacion.f_cb_subcadena2(s_bouquets, i), 8, '0');
        ln_obt_tp := f_obt_tipo_pago(p_numregistro, NULL);

        p_nombre := f_genera_nombre_archivo(ln_obt_tp, 'ps');

        s_numconax := lpad(substr(p_nombre, 3, 8), 6, '0');

        -- 2.CREACION DE ARCHIVO DE SOLICITUD DE ACTIVACION DE CABLE SATELITAL

        --ABRE EL ARCHIVO
        operacion.pq_dth_interfaz.p_abrir_archivo(p_text_io,
                                                  connex_i.pdirectoriolocal,
                                                  p_nombre,
                                                  'W',
                                                  p_resultado,
                                                  p_mensaje);
        --ESCRIBE EN EL ARCHIVO
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                  s_numconax,
                                                  '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, s_codext, '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, p_fecini, '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, p_fecfin, '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'EMM', '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');

        --contador de tarjetas

        SELECT COUNT(1)
          INTO canttarjetas
          FROM solotptoequ
         WHERE codsolot = p_solot_post
           AND tipequ IN (SELECT a.codigon tipequope
                            FROM opedd a, tipopedd b
                           WHERE a.tipopedd = b.tipopedd
                             AND b.abrev = 'TIPEQU_DTH_CONAX'
                             AND codigoc = '1');

        s_canttarjetas := lpad(canttarjetas, 6, '0');

        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,
                                                  s_canttarjetas,
                                                  '1');

        FOR c_cards IN c_tarjetas LOOP
          operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,

                                                    TRIM(c_cards.serie),
                                                    '1');
        END LOOP;
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'ZZZ', '1');

        --CIERRA EL ARCHIVO DE ACTIVACIÓN
        operacion.pq_dth_interfaz.p_cerrar_archivo(p_text_io);

        BEGIN
          --ENVIO DE ARCHIVO DE ACTIVACION CONAX
          parchivolocalenv := p_nombre;
          operacion.pq_dth_interfaz.p_enviar_archivo_ascii(connex_i.phost,
                                                           connex_i.ppuerto,
                                                           connex_i.pusuario,
                                                           connex_i.ppass,
                                                           connex_i.pdirectoriolocal,
                                                           parchivolocalenv,
                                                           connex_i.parchivoremotoreq);

          BEGIN
            SELECT operacion.sq_numtrans.nextval
              INTO l_numtransacconax
              FROM dummy_ope;

            INSERT INTO operacion.log_reg_archivos_enviados
              (numregenv,
               numregins,
               filename,
               lastnumregenv,
               codigo_ext,
               tipo_proceso,
               numtrans)
            VALUES
              (s_numconax,
               p_numregistro,
               p_nombre,
               s_numconax,
               s_codext,
               'A',
               l_numtransacconax);

            INSERT INTO operacion.reg_archivos_enviados
              (numregenv,
               numregins,
               filename,
               estado,
               lastnumregenv,
               codigo_ext,
               tipo_proceso,
               numtrans)
            VALUES
              (s_numconax,
               p_numregistro,
               p_nombre,
               1,
               s_numconax,
               s_codext,
               'A',
               l_numtransacconax);

            COMMIT;
          EXCEPTION
            WHEN OTHERS THEN
              ROLLBACK;
          END;

        EXCEPTION
          WHEN OTHERS THEN

            p_resultado := 'ERROR1';

        END;
      END LOOP;

      BEGIN

        --      Dependiendo del flg_cnr registramos el tipo de bouquetsxreginsdth
        --      Tipo 0: Servicios Adicionales
        --      Tipo 3: Servicios Adicionales del tipo CNR
        ln_is_cnr := c_cod_ext_va.flg_cnr;
        IF ln_is_cnr = 1 THEN
          ln_tipo := 3;
        ELSE
          ln_tipo := 0;
        END IF;

        INSERT INTO operacion.bouquetxreginsdth
          (numregistro, codsrv, bouquets, tipo, estado, idgrupo, pid)
        VALUES
          (p_numregistro,
           c_cod_ext_va.codsrv,
           c_cod_ext_va.codigo_ext,
           ln_tipo,
           1,
           c_cod_ext_va.idgrupo,
           c_cod_ext_va.pid);
        COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
          ROLLBACK;
      END;
    END LOOP;

  EXCEPTION

    WHEN error_asociado THEN

      p_resultado := 'ERROR';
      p_mensaje   := 'Error procesa Pareo/Despareo. ' || ls_mensaje || ' ' ||
                     SQLCODE || ' ' || SQLERRM;

    WHEN OTHERS THEN
      p_resultado := 'ERROR';
      p_mensaje   := 'Error al abrir archivo. ' || SQLCODE || ' ' ||
                     SQLERRM;
  END;

  PROCEDURE p_enviar_pareo_asoc(p_numregistro IN operacion.reg_archivos_enviados.numregins%TYPE,
                                p_codsolot    IN solot.codsolot%TYPE,
                                p_cant_pareo  IN NUMBER,
                                p_resultado   IN OUT VARCHAR2,
                                p_mensaje     IN OUT VARCHAR2) IS

    p_text_io_des     utl_file.file_type;
    p_pareo           VARCHAR2(15);
    l_cantidad1       NUMBER;
    l_numtransacconax NUMBER(15);
    s_numconaxpareo   VARCHAR2(6);
    p_pareoenv        VARCHAR2(30);
    cantdecos         NUMBER;
    s_candecos        CHAR(6);
    ln_obt_tp         NUMBER;
    connex_i          operacion.conex_intraway;

    --cursor de unitaddress de decodificadores
    CURSOR c_equipos_tarjetas IS
      SELECT t.nro_serie_deco, t.nro_serie_tarjeta
        FROM solotptoequ se, operacion.tarjeta_deco_asoc t
       WHERE t.codsolot = p_codsolot
         AND t.codsolot = se.codsolot
         AND se.mac = t.nro_serie_deco;

  BEGIN
    connex_i := operacion.pq_dth.f_crea_conexion_intraway;

    p_resultado := 'OK';

    FOR c_et IN c_equipos_tarjetas LOOP
      --GENERACIÓN DE UN SOLO ARCHIVO DE PAREO.

      ln_obt_tp := f_obt_tipo_pago(p_numregistro, NULL);
      p_pareo   := f_genera_nombre_archivo(ln_obt_tp, 'vp');

      s_numconaxpareo := lpad(substr(p_pareo, 3, 8), 6, '0');

      --1.CREACION DE ARCHIVO DE PAREO DEL EQUIPO

      --ABRE EL ARCHIVO
      operacion.pq_dth_interfaz.p_abrir_archivo(p_text_io_des,
                                                connex_i.pdirectoriolocal,
                                                p_pareo,
                                                'W',
                                                p_resultado,
                                                p_mensaje);
      --ESCRIBE EN EL ARCHIVO

      operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des, 'U', '1');
      operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des,
                                                s_numconaxpareo,
                                                '1');
      operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des,
                                                '00000001',
                                                '1');
      operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des, 'U', '1');
      operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des, 'U', '1');
      operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des, 'U', '1');
      operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des, 'EMM', '1');
      operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des, 'U', '1');

      operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des,
                                                '00002',
                                                '1');

      operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des,
                                                'S' ||
                                                TRIM(c_et.nro_serie_tarjeta),
                                                '1');
      operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des,
                                                'V' ||
                                                TRIM(c_et.nro_serie_deco),
                                                '1');

      operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des, 'ZZZ', '1');
      --CIERRA EL ARCHIVO DE PAREO
      operacion.pq_dth_interfaz.p_cerrar_archivo(p_text_io_des);

      --ENVIO DE ARCHIVO DE PAREO
      p_pareoenv := p_pareo;
      operacion.pq_dth_interfaz.p_enviar_archivo_ascii(connex_i.phost,
                                                       connex_i.ppuerto,
                                                       connex_i.pusuario,
                                                       connex_i.ppass,
                                                       connex_i.pdirectoriolocal,
                                                       p_pareoenv,
                                                       connex_i.parchivoremotoreq);

      BEGIN

        SELECT operacion.sq_numtrans.nextval
          INTO l_numtransacconax
          FROM dummy_ope;

        INSERT INTO operacion.log_reg_archivos_enviados
          (numregenv,
           numregins,
           filename,
           lastnumregenv,
           tipo_proceso,
           numtrans)
        VALUES
          (s_numconaxpareo,
           p_numregistro,
           p_pareo,
           s_numconaxpareo,
           'P',
           l_numtransacconax);

        INSERT INTO operacion.reg_archivos_enviados
          (numregenv,
           numregins,
           filename,
           estado,
           lastnumregenv,
           tipo_proceso,
           numtrans)
        VALUES
          (s_numconaxpareo,
           p_numregistro,
           p_pareo,
           1,
           s_numconaxpareo,
           'P',
           l_numtransacconax);

        COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
          ROLLBACK;
      END;
    END LOOP;
  EXCEPTION
    WHEN OTHERS THEN
      p_resultado := 'ERROR';
      p_mensaje   := 'Error Pareo ' || SQLCODE || ' ' || SQLERRM;
  END;

  PROCEDURE p_enviar_despareo_asoc(p_numregistro   IN operacion.reg_archivos_enviados.numregins%TYPE,
                                   p_codsolot      IN solot.codsolot%TYPE,
                                   p_cant_despareo IN NUMBER,
                                   p_resultado     IN OUT VARCHAR2,
                                   p_mensaje       IN OUT VARCHAR2) IS

    p_text_io_des      utl_file.file_type;
    p_despareo         VARCHAR2(15);
    l_cantidad1        NUMBER;
    l_numtransacconax  NUMBER(15);
    s_numconaxdespareo VARCHAR2(6);
    p_despareoenv      VARCHAR2(30);
    cantdecos          NUMBER;
    s_candecos         CHAR(6);
    ln_obt_tp          NUMBER;
    connex_i           operacion.conex_intraway;

    --cursor de unitaddress de decodificadores
    CURSOR c_equipos_tarjetas IS
      SELECT t.nro_serie_deco, t.nro_serie_tarjeta
        FROM solotptoequ se, operacion.tarjeta_deco_asoc t
       WHERE t.codsolot = p_codsolot
         AND t.codsolot = se.codsolot
         AND se.mac = t.nro_serie_deco;

  BEGIN
    connex_i := operacion.pq_dth.f_crea_conexion_intraway;

    p_resultado := 'OK';

    --GENERACIÓN DE UN SOLO ARCHIVO DE DESPAREO.

    ln_obt_tp          := f_obt_tipo_pago(p_numregistro, NULL);
    p_despareo         := f_genera_nombre_archivo(ln_obt_tp, 'gp');
    s_numconaxdespareo := lpad(substr(p_despareo, 3, 8), 6, '0');

    --1.CREACION DE ARCHIVO DE DESPAREO DEL EQUIPO

    --ABRE EL ARCHIVO
    operacion.pq_dth_interfaz.p_abrir_archivo(p_text_io_des,
                                              connex_i.pdirectoriolocal,
                                              p_despareo,
                                              'W',
                                              p_resultado,
                                              p_mensaje);
    --ESCRIBE EN EL ARCHIVO
    operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des, '01', '1');
    operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des,
                                              s_numconaxdespareo,
                                              '1');
    operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des,
                                              '00001001',
                                              '1');
    operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des, 'U', '1');
    operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des, 'U', '1');
    operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des, 'U', '1');
    operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des, 'U', '1');
    operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des, 'U', '1');
    operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des, 'EMM', '1');

    s_candecos := lpad(p_cant_despareo, 6, '0');

    operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des,
                                              s_candecos,
                                              '1');
    FOR c_et IN c_equipos_tarjetas LOOP
      operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des,
                                                TRIM(c_et.nro_serie_deco),
                                                '1');
    END LOOP;

    operacion.pq_dth_interfaz.p_escribe_linea(p_text_io_des, 'ZZZ', '1');
    --CIERRA EL ARCHIVO DE DESPAREO
    operacion.pq_dth_interfaz.p_cerrar_archivo(p_text_io_des);

    --ENVIO DE ARCHIVO DE DESPAREO
    p_despareoenv := p_despareo;
    operacion.pq_dth_interfaz.p_enviar_archivo_ascii(connex_i.phost,
                                                     connex_i.ppuerto,
                                                     connex_i.pusuario,
                                                     connex_i.ppass,
                                                     connex_i.pdirectoriolocal,
                                                     p_despareoenv,
                                                     connex_i.parchivoremotoreq);

    BEGIN

      SELECT operacion.sq_numtrans.nextval
        INTO l_numtransacconax
        FROM dummy_ope;

      INSERT INTO operacion.log_reg_archivos_enviados
        (numregenv,
         numregins,
         filename,
         lastnumregenv,
         tipo_proceso,
         numtrans)
      VALUES
        (s_numconaxdespareo,
         p_numregistro,
         p_despareo,
         s_numconaxdespareo,
         'D',
         l_numtransacconax);

      INSERT INTO operacion.reg_archivos_enviados
        (numregenv,
         numregins,
         filename,
         estado,
         lastnumregenv,
         tipo_proceso,
         numtrans)
      VALUES
        (s_numconaxdespareo,
         p_numregistro,
         p_despareo,
         1,
         s_numconaxdespareo,
         'D',
         l_numtransacconax);

      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
        ROLLBACK;
    END;

  EXCEPTION
    WHEN OTHERS THEN
      p_resultado := 'ERROR';
      p_mensaje   := 'Error Despareo ' || SQLCODE || ' ' || SQLERRM;
  END;
  --<fin 39.0>
end pq_dth;
/
