CREATE OR REPLACE PACKAGE BODY OPERACION.PQ_IW_SGA_BSCS IS
  /*******************************************************************************************************
   NOMBRE:       OPERACION.PQ_IW_SGA_BSCS
   PROPOSITO:    Paquete de objetos necesarios para la Conexion del SGA - BSCS
   REVISIONES:
   Version    Fecha       Autor            Solicitado por    Descripcion
   ---------  ----------  ---------------  --------------    -----------------------------------------
    1.0       09/08/2013  Edilberto Astulle                  PQT-159305-TSK-30818
    2.0       11/11/2013  Edilberto Astulle                  PQT-159305-TSK-30818
    3.0       26/12/2013  Edilberto Astulle                  SD-909038
    4.0       19/04/2014  Edilberto Astulle                  SD_1064022
    5.0       19/05/2014  Edilberto Astulle                  PROY-12361 IDEA-15479 Eliminacion y creacion de reserva y más
    6.0       16/06/2014  Edilberto Astulle                  SD_1126603
    7.0       23/06/2014  Edilberto Astulle                  SD-1137139
    8.0       07/07/2014  Edilberto Astulle                  SD_1126041
    9.0       20/07/2014  Edilberto Astulle                  SD_1158229
    10.0      30/07/2014  Edilberto Astulle                  SD-1172651
    11.0       06/08/2014  Edilberto Astulle     SD_ 7956
    12.0       16/08/2014  Edilberto Astulle     SD-1173230 Problemas para cambio de fecha de compromiso
    13.0       20/08/2014  Edilberto Astulle     SDM_43533
    14.0       13/09/2014  Edilberto Astulle     SD_1169600
    15.0       23/09/2014  Edilberto Astulle     SD_39941 RV Accesos SGA Inventario de site
    16.0       09/10/2014  Dorian Sucasaca       PQT-215228-TSK-60071 Envío de Comandos de SGA a SSW Nortel e IMS
    17.0       04/11/2014  Edilberto Astulle     SD_39941 RV Accesos SGA Inventario de site
    18.0       13/11/2014  Dorian Sucasaca       SD_129848
    19.0       01/12/2014  Edilberto Astulle     SD_120302 Problemas en actualizacion masiva Agenda workflow SGA - Sot de baja HFC
    20.0       15/12/2014  Edilberto Astulle     SD_167445 Deco Pendiente SIAC HFC
    21.0       15/01/2015  Miriam Mandujano      SD_199141 SOT 17267599 - JEYMI BRIGITH CASTILLO LAZO
    22.0       17/04/2015  Michael Boza          SD_288299 Cliente Servicio fijo
  23.0     15/06/2015  Angelo Angulo
    24.0       04/08/2015                        SD-399889 Se debe consumir directamente a la funcion publica F_GET_NUMERO_TEL_ITW
    25.0       04/11/2015  Alfonso Muñante       SD-438726 Se regulariza en bscs la reserva hfc y el registro de servicios
    25.0       29/12/2015  Alfonso Muñante       SD-534868
    26.0       29/12/2015  Alfonso Muñante       SGA-SD-534868-1
    27.0       01/04/2016                        SD-642508 Cambio de Plan
    28.0       20/07/2016  Dorian Sucasaca       SD_795618
    29.0       20/02/2017  Servicio Fallas-HITSS INC000000677790 Reservas duplicadas
    30.0       18/07/2017  Felipe Maguiña        PROY-27792
    31.0       23/04/2019  Serv. Fallas          INC000001471706
	32.0       08/01/2020  Nilton Paredes   Lizbeth Portella INICIATIVA-195 IDEA-141141 - Nuevas Funcionalidades II
 *******************************************************************************************************/
  procedure p_gen_reserva_iw(a_idtareawf in number,
                             a_idwf      in number,
                             a_tarea     in number,
                             a_tareadef  in number,
                             a_envio     number default 0) is
    --4.0

    v_codcli           solot.codcli%type;
    n_codsolot         solot.codsolot%type;
    n_id_estado        number;
    n_sid_internet     number;
    n_pid_internet     number;
    n_sid_telefonia    number;
    n_pid_telefonia    number;
    v_pid_telefonia_ep varchar2(30);
    n_sid_cable        number;
    n_pid_cable        number;
    n_pid_cable_e      number;
    v_codact           varchar2(32);
    n_indicador        number;
    n_cuenta_stb       number;
    n_cod_id           number;
    v_mensaje          varchar2(4000);
    v_codsuc           vtasuccli.codsuc%type;
    v_idcmts           ope_cmts.desccmts%type;
    n_cmts             number;
    n_hub              number;
    v_nombre_hub       intraway.ope_hub.nombre%type;
    v_abrevhub         intraway.ope_hub.abrevhub%type; --6.0
    v_nodo             marketing.vtasuccli.idplano%type;
    n_error            number;
    v_cod_ext_cm       tystabsrv.codigo_ext%type;
    n_cant_internet    number;
    error_general exception;
    v_homeexchangecrmid varchar2(100);
    n_puerto            number;
    v_tipsrv            varchar2(6);
    n_cantdet           number;
    v_pid_tel_car       varchar2(20);
    v_cod_ext_stb       tystabsrv.codigo_ext%type;
    v_numslc            vtatabslcfac.numslc%type;
    v_channelmap        varchar2(100);
    v_configcrmid       varchar2(100);
    v_sendtocontroler   varchar2(30);
    n_cont_vod          number;
    v_pid_stb_fac       varchar2(100);
    n_cuenta            number;
    n_cantidad_stb      number;
    n_customer_id       number; --4.0
    n_cont_trs          number; --6.0
    n_cont_val          number; --9.0
    n_val_wf            number; --13.0
    n_wfdef             number; --13.0
    n_tiptra            number; --13.0
    n_codsolot_origen   number; --17.0
    n_codsolot_cur      number; --17.0
    n_tiptra_dec_adi    operacion.solot.tiptra%type;
    l_valdcodact        number;
    n_tiptra_CP         number;

    cursor c_stb is --Cable
      select a.pid, a.punto, p.cantidad, a.codinssrv sid, c.dscsrv
        from solotpto a, tystabsrv c, tystipsrv d, insprd p
       where a.codsrvnue = c.codsrv
         and c.tipsrv = d.tipsrv
         and a.pid = p.pid
         and a.codinssrv = n_sid_cable
         and p.codequcom is not null
         and a.codsolot = n_codsolot;

    cursor c_lineatel is --Telefonia
      select a.pid, b.numero, p.codsrv, b.codinssrv
        from solotpto a, inssrv b, insprd p
       where a.codinssrv = b.codinssrv
         and b.codinssrv = p.codinssrv
         and a.codsolot = n_codsolot
         and p.flgprinc = 1
         and a.pid = p.pid
         and b.tipsrv = fnd_tipsrv_tel;

    cursor c_complemento(an_codinssrv number) is --
      select a.pid,
             a.pid_old,
             a.codinssrv,
             operacion.pq_promo3play.f_promo3play_srvprom(n_codsolot,
                                                          v_codcli,
                                                          c.codsrv,
                                                          3) codigo_ext
        from solotpto a, tystabsrv c, insprd p
       where a.codinssrv = an_codinssrv --n_codsolot  17.0
         and a.codsrvnue = c.codsrv
         and c.tipsrv = v_tipsrv
         and a.pid = p.pid
         and p.flgprinc = 0
         and c.codigo_ext is not null
         and p.codequcom is null
         and p.estinsprd <> 3;
  begin
    --ACTIVA CODIGO ACTIVACIÿN
    begin
      select codigon_aux
        into l_valdcodact
        from opedd
       where tipopedd = 1716
         and codigoc = '99';
    exception
      when others then
        l_valdcodact := 0;
    end;
    --14.0
    select count(1)
      into n_cont_val
      from opedd a, tipopedd b
     where a.tipopedd = b.tipopedd
       and b.abrev = 'VALCARDATHFCBSCS';

    select a.codsolot,
           b.codcli,
           b.cod_id,
           b.numslc,
           b.customer_id,
           a.wfdef,
           b.tiptra --13.0
      into n_codsolot,
           v_codcli,
           n_cod_id,
           v_numslc,
           n_customer_id,
           n_wfdef,
           n_tiptra --13.0
      from wf a, solot b
     where a.idwf = a_idwf
       and a.codsolot = b.codsolot;
    n_codsolot_cur := n_codsolot; --17.0

    if n_customer_id is null then
      --13.0
      p_reg_log(v_codcli,
                n_customer_id,
                null,
                n_codsolot,
                null,
                null,
                null,
                n_cod_id,
                'SOT sin Customer_id.');
      return;
    end if;

    --    insert into intraway.agendamiento_int(codsolot, codcli, est_envio, mensaje) 17.0
    --    values(n_codsolot, v_codcli, 0, 'Capturado p_sot_agendada');  17.0
    select min(c.codsuc)
      into v_codsuc
      from vtadetptoenl c
     where c.numslc = v_numslc;

    begin
      --Asignar Nro Telefonico   13.0
      select count(1)
        into n_val_wf
        from opedd a, tipopedd b
       where a.tipopedd = b.tipopedd
         and b.abrev = 'SIGNUMTELSISACT'
         and a.codigon = n_wfdef
         and a.codigon_aux = n_tiptra;
      if n_val_wf = 1 then
        p_asignar_numero(n_codsolot, null, v_mensaje, n_error);
        if n_error < 0 then
          v_mensaje := 'Asigna Número: ' || v_mensaje;
          raise error_general;
        end if;
      end if;
    end;

    begin
      select x.desccmts,
             decode(s.idcmts, null, v.idcmts, s.idcmts),
             decode(h.idhub, null, 0, h.idhub),
             h.nombre,
             s.idplano,
             h.abrevhub --6.0
        into v_idcmts, n_cmts, n_hub, v_nombre_hub, v_nodo, v_abrevhub --6.0
        from vtasuccli s, ope_hub h, vtatabgeoref v, ope_cmts x
       where s.idhub = h.idhub
         and s.codsuc = v_codsuc
         and s.idplano = v.idplano(+)
         and s.ubisuc = v.codubi(+)
         and s.idcmts = x.idcmts
         and h.idhub = x.idhub;
    exception
      when no_data_found then
        v_mensaje := 'p_gen_cod_activacion, SOT: ' || n_codsolot ||
                     '. El servicio no tiene HUB /CMTS  .' || sqlerrm;
    end;

    if n_hub = 0 and n_cmts = 0 then
      v_mensaje := 'p_gen_cod_activacion No tiene HUB/CMTS Valido';
      raise error_general;
    end if;

    begin
      --INTERNET Obtener el PID y ServicePackage
      select a.pid, a.codinssrv, a.cantidad
        into n_pid_internet, n_sid_internet, n_cant_internet
        from solotpto a, tystabsrv b, insprd p
       where a.codsolot = n_codsolot
         and a.codsrvnue = b.codsrv
         and a.pid = p.pid
         and a.codinssrv = p.codinssrv
         and b.tipsrv = fnd_tipsrv_int
         and p.flgprinc = 1;
    exception
      when others then
        n_pid_internet := 0;
        n_sid_internet := 0;
    end;

    begin
      --TELEFONIA Obtener el PID
      select a.pid, a.codinssrv
        into n_pid_telefonia, n_sid_telefonia
        from solotpto a, tystabsrv b, insprd p, producto r
       where a.codsolot = n_codsolot
         and a.codsrvnue = b.codsrv
         and a.pid = p.pid
         and a.codinssrv = p.codinssrv
         and b.tipsrv = fnd_tipsrv_tel
         and p.flgprinc = 1
         and rownum = 1
         and b.idproducto = r.idproducto
         and r.idtipinstserv = 3;
    exception
      when others then
        n_pid_telefonia := 0;
        n_sid_telefonia := 0;
    end;

    n_id_estado := 1; --Crear
    -- Reserva de Espacio para CM:

    if n_sid_internet > 0 then
      --Internet
      v_cod_ext_cm := 'InfinitumVoz';
      if l_valdcodact = 1 then
        v_codact := f_obt_codact(n_id_estado,
                                 v_codcli,
                                 n_pid_internet,
                                 fnd_idinterface_cm,
                                 n_codsolot,
                                 1 || lpad(n_codsolot, 8, 0));
      else
        v_codact := null;
      end if;

      n_cant_internet := 2;

      begin
        --CM
        if n_tiptra = 693 then
          -- Traslado Externo
          p_replica(v_codcli,
                    n_codsolot,
                    n_pid_internet,
                    n_sid_internet,
                    n_cod_id,
                    v_codact,
                    fnd_idinterface_cm,
                    v_mensaje,
                    n_error);
        else
          p_interface_cm(v_codcli,
                         n_pid_internet,
                         n_cod_id,
                         n_codsolot,
                         n_sid_internet,
                         v_cod_ext_cm,
                         v_codact,
                         n_cant_internet,
                         v_nombre_hub,
                         v_nodo,
                         v_mensaje,
                         n_error); --2.0
        end if;

        if n_error <> 0 then
          v_mensaje := 'p_interface_cm : ' || v_mensaje;
          raise error_general;
        end if;
      end;
    end if;

    if n_sid_telefonia > 0 then
      --Telefonia
      if n_sid_internet = 0 then
        --Servicio Solo Telefonia tambien incluir reserva de Internet  6.0
        v_cod_ext_cm := null; --6.0
        --Inicio 14.0
        if n_cont_val = 0 then
          n_pid_internet := n_pid_telefonia - 1;
        else
          select a.pid
            into n_pid_internet
            from solotpto a, tystabsrv b, insprd p
           where a.codsolot = n_codsolot
             and a.codsrvnue = b.codsrv
             and a.pid = p.pid
             and a.codinssrv = p.codinssrv
             and b.tipsrv = fnd_tipsrv_tel
             and p.flgprinc = 0
             and rownum = 1;
        end if;
        --Fin 14.0
        if l_valdcodact = 1 then
          v_codact := f_obt_codact(n_id_estado,
                                   v_codcli,
                                   n_pid_internet,
                                   fnd_idinterface_cm,
                                   n_codsolot,
                                   1 || lpad(n_codsolot, 8, 0));
        else
          v_codact := null;
        end if;

        n_cant_internet := 2;

        begin
          --CM
          if n_tiptra = 693 then
            -- Traslado Externo
            p_replica(v_codcli,
                      n_codsolot,
                      n_pid_internet, --pid
                      n_sid_telefonia,
                      n_cod_id,
                      v_codact,
                      fnd_idinterface_cm,
                      v_mensaje,
                      n_error);
          else
            p_interface_cm(v_codcli,
                           n_pid_internet,
                           n_cod_id,
                           n_codsolot,
                           n_sid_telefonia,
                           v_cod_ext_cm,
                           v_codact,
                           n_cant_internet,
                           v_nombre_hub,
                           v_nodo,
                           v_mensaje,
                           n_error);
          end if;

          if n_error <> 0 then
            v_mensaje := 'p_interface_cm : ' || v_mensaje;
            raise error_general;
          end if;
        end;
      end if;

      v_codact := f_obt_codact(n_id_estado,
                               v_codcli,
                               n_pid_telefonia,
                               fnd_idinterface_mta,
                               n_codsolot,
                               2 || lpad(n_codsolot, 8, 0));
      begin
        --MTA
        if n_tiptra = 693 then
          -- Traslado Externo
          p_replica(v_codcli,
                    n_codsolot,
                    n_pid_telefonia, --pid
                    n_sid_telefonia,
                    n_cod_id,
                    v_codact,
                    fnd_idinterface_mta,
                    v_mensaje,
                    n_error);
        else
          p_interface_mta(v_codcli,
                          n_pid_telefonia,
                          n_pid_internet,
                          n_cod_id,
                          n_codsolot,
                          n_sid_telefonia,
                          v_idcmts,
                          v_codact,
                          v_mensaje,
                          n_error);
        end if;

        if n_error <> 0 then
          v_mensaje := 'p_interface_mta : ' || v_mensaje;
          raise error_general;
        end if;

        n_puerto := 1;

        for lc_lineatel in c_lineatel
        loop
          v_homeexchangecrmid := f_get_ncos(n_codsolot, lc_lineatel.codsrv, 3);
          begin
            --EP
            --Inicio 14.0
            if n_cont_val = 0 then
              v_pid_telefonia_ep := n_pid_telefonia || n_puerto;
              v_pid_telefonia_ep := n_pid_telefonia + 1;
            else
              select a.pid
                into v_pid_telefonia_ep
                from solotpto a, tystabsrv b, insprd p
               where a.codsolot = n_codsolot
                 and a.codsrvnue = b.codsrv
                 and a.pid = p.pid
                 and a.codinssrv = p.codinssrv
                 and b.tipsrv = fnd_tipsrv_equ
                 and p.flgprinc = 0
                 and p.codinssrv = n_sid_telefonia
                 and rownum = 1;
            end if;
            --Fin 14.0

            if n_tiptra = 693 then
              -- Traslado Externo
              p_replica(v_codcli,
                        n_codsolot,
                        n_pid_telefonia, --pid
                        n_sid_telefonia,
                        n_cod_id,
                        null,
                        fnd_idinterface_ep,
                        v_mensaje,
                        n_error);
            else
              p_interface_mta_ep(v_codcli,
                                 v_pid_telefonia_ep,
                                 n_pid_telefonia,
                                 n_puerto,
                                 lc_lineatel.numero,
                                 v_homeexchangecrmid,
                                 n_cod_id,
                                 n_codsolot,
                                 n_sid_telefonia,
                                 v_mensaje,
                                 n_error);
            end if;

            if n_error <> 0 then
              v_mensaje := 'p_interface_mta_ep  : ' || v_mensaje;
              raise error_general;
            end if;

            v_tipsrv  := fnd_tipsrv_tel; --Carateristicas Telefonia
            n_cantdet := 1;

            for lc_comple in c_complemento(n_sid_telefonia)
            loop
              v_pid_tel_car := v_pid_telefonia_ep || n_cantdet;
              --Inicio 9.0  14.0
              --select count(1) into n_cont_val from opedd a, tipopedd b
              --where a.tipopedd=b.tipopedd and b.abrev='VALCARDATHFCBSCS';
              --if n_cont_val=1 then
              --  v_pid_tel_car:= n_pid_telefonia || n_cantdet;
              --end if;
              --Fin 9.0  14.0
              if n_tiptra = 693 then
                -- Traslado Externo
                p_replica(v_codcli,
                          n_codsolot,
                          n_pid_telefonia, --pid
                          n_sid_telefonia,
                          n_cod_id,
                          null,
                          fnd_idinterface_cf,
                          v_mensaje,
                          n_error);
              else
                p_interface_mta_fac(v_codcli,
                                    v_pid_tel_car,
                                    v_pid_telefonia_ep,
                                    n_pid_telefonia,
                                    lc_comple.codigo_ext,
                                    n_cod_id,
                                    n_codsolot,
                                    n_sid_telefonia,
                                    v_mensaje,
                                    n_error);
              end if;

              if n_error <> 0 then
                v_mensaje := 'p_interface_mta_fac : ' || v_mensaje;
                raise error_general;
              end if;

              n_cantdet := n_cantdet + 1;
            end loop;
          end;
          n_puerto := n_puerto + 1;
        end loop;
      end;
    end if;

    begin
      -- Obtener el PID y ServicePackage
      select a.pid, a.codinssrv
        into n_pid_cable, n_sid_cable
        from solotpto a, tystabsrv c, tystipsrv d, insprd p
       where a.codsrvnue = c.codsrv
         and c.tipsrv = d.tipsrv
         and a.pid = p.pid
         and a.codinssrv = p.codinssrv
         and p.flgprinc = 1
         and d.tipsrv = fnd_tipsrv_cab
         and a.codsolot = n_codsolot;
    exception
      when others then
        n_pid_cable := 0;
        --SD925014
        begin
          select distinct a.codinssrv
            into n_sid_cable
            from solotpto a, insprd p, inssrv i
           where a.codinssrv = i.codinssrv
             and i.tipsrv = fnd_tipsrv_cab
             and a.pid = p.pid
             and a.codinssrv = p.codinssrv
             and a.codsolot = n_codsolot;
        exception
          when others then
            n_sid_cable := 0;
        end;
    end;

    n_cuenta_stb := 0;
    for lc_stb in c_stb
    loop
      --STB
      v_cod_ext_stb     := f_obt_channelmap(lc_stb.sid, 3, 1);
      v_channelmap      := f_obt_channelmap(lc_stb.sid, 3, 2);
      v_sendtocontroler := 'FALSE';
      v_configcrmid     := f_obt_hub(lc_stb.sid); --3.0 6.0
      n_indicador       := 1;
      n_cantidad_stb    := lc_stb.cantidad;
      for n_indicador in 1 .. n_cantidad_stb
      loop
        n_cuenta_stb := n_cuenta_stb + 1;
        --n_pid_cable_e :=  n_pid_cable ||  n_cuenta_stb;--SD925014
        n_pid_cable_e := lc_stb.pid || n_cuenta_stb;

        if l_valdcodact = 1 then
          v_codact := f_obt_codact(n_id_estado,
                                   v_codcli,
                                   n_pid_cable_e,
                                   2020,
                                   n_codsolot,
                                   2 || n_cuenta_stb || lpad(n_codsolot, 7, 0));
        else
          v_codact := null;
        end if;

        if n_tiptra = 693 then
          -- Traslado Externo
          p_replica(v_codcli,
                    n_codsolot,
                    lc_stb.pid, --pid
                    n_sid_cable,
                    n_cod_id,
                    null,
                    fnd_idinterface_stb,
                    v_mensaje,
                    n_error);
        else
          p_interface_stb(v_codcli,
                          n_pid_cable_e, /*n_pid_cable,*/
                          lc_stb.pid,
                          v_codact, --5.0
                          v_cod_ext_stb,
                          v_channelmap,
                          v_configcrmid,
                          n_cod_id,
                          n_codsolot,
                          n_sid_cable,
                          v_sendtocontroler,
                          v_mensaje,
                          n_error);
        end if;

        if n_error < 0 then
          v_mensaje := 'p_interface_stb : ' || v_mensaje;
          raise error_general;
        end if;

        n_cuenta := 0;
        v_tipsrv := fnd_tipsrv_cab;

        --Inicio  17.0
        begin
          select /*+rule*/
           min(a.codsolot)
            into n_codsolot_origen
            from operacion.trs_interface_iw a, solot b
           where a.codsolot = b.codsolot
             and a.codinssrv = n_sid_cable;
        exception
          when no_data_found then
            n_codsolot_origen := n_codsolot_cur;
        end;
        n_codsolot_cur := n_codsolot_origen;
        --Fin 17.0
        for lc_comple in c_complemento(n_sid_cable)
        loop
          --Carateristicas Cable
          n_cuenta      := n_cuenta + 1;
          v_pid_stb_fac := n_pid_cable_e || n_cuenta;
          select count(1)
            into n_cont_vod
            from configuracion_itw i
           where i.estado = 1
             and i.tiposervicioitw = 6
             and i.codigo_ext = lc_comple.codigo_ext;

          if n_cont_vod > 0 then
            --VOD
            if n_tiptra = 693 then
              -- Traslado Externo
              p_replica(v_codcli,
                        n_codsolot,
                        lc_comple.pid, --pid
                        n_sid_cable,
                        n_cod_id,
                        null,
                        fnd_idinterface_stb_vod,
                        v_mensaje,
                        n_error);
            else
              p_interface_stb_vod(v_codcli,
                                  v_pid_stb_fac,
                                  lc_comple.pid,
                                  n_pid_cable_e,
                                  lc_comple.codigo_ext,
                                  n_cod_id,
                                  n_codsolot,
                                  n_sid_cable,
                                  v_mensaje,
                                  n_error);
            end if;

            if n_error <> 0 then
              v_mensaje := 'p_interface_stb_vod : ' || v_mensaje;
              raise error_general;
            end if;
          else
            if n_tiptra = 693 then
              -- Traslado Externo
              p_replica(v_codcli,
                        n_codsolot,
                        lc_comple.pid, --pid
                        n_sid_cable,
                        n_cod_id,
                        null,
                        fnd_idinterface_stb_sa,
                        v_mensaje,
                        n_error);
            else
              p_interface_stb_sa(v_codcli,
                                 v_pid_stb_fac,
                                 lc_comple.pid,
                                 n_pid_cable_e,
                                 lc_comple.codigo_ext,
                                 n_cod_id,
                                 n_codsolot,
                                 n_sid_cable,
                                 v_mensaje,
                                 n_error);
            end if;

            if n_error <> 0 then
              v_mensaje := 'p_interface_stb_sa : codact ' || v_mensaje;
              raise error_general;
            end if;
          end if;
        end loop;
      end loop;
    end loop;

    begin
      --Reserva
      if a_envio = 0 then
        --4.0
        -- Ini 25.0
        select a.codigon
          into n_tiptra_dec_adi
          from opedd a, tipopedd b
         where a.tipopedd = b.tipopedd
           and b.abrev = 'HFC_SIAC_DEC_ADICIONAL'
           and a.abreviacion = 'TIPTRA';
         
        select a.codigon
          into n_tiptra_CP
          from opedd a, tipopedd b
         where a.tipopedd = b.tipopedd
           and b.abrev = 'TTRABCP'
           and a.abreviacion = 'TTRABCP'
		   and a.codigon_aux = 1;
      
          
      if n_tiptra <> n_tiptra_CP then
        if n_tiptra_dec_adi <> n_tiptra then
          webservice.pq_ws_hfc.p_gen_reservahfc(n_cod_id,
                                                n_codsolot, --17.0
                                                n_error,
                                                v_mensaje);
          if n_error < 0 then
            v_mensaje := 'Error Generación de Reserva: ' || v_mensaje;
            raise error_general;
          end if;
        end if;

        end if;
        -- Fin 25.0
      end if; --4.0
    end;

  exception
    when error_general then
      p_reg_log(v_codcli,
                n_customer_id,
                null,
                n_codsolot,
                null,
                n_error,
                v_mensaje,
                n_cod_id,
                'Generación Reserva'); --10.0
    when others then
      v_mensaje := sqlerrm;
      p_reg_log(v_codcli,
                n_customer_id,
                null,
                n_codsolot,
                null,
                n_error,
                v_mensaje,
                n_cod_id,
                'Generación Reserva'); --10.0
  end;

FUNCTION f_obt_codact(p_a_id_estado    in number,
        p_id_cliente     in varchar2,
        p_id_producto    in varchar2,
        p_id_interfase   in varchar2,
        p_codsolot       in varchar2,
        p_activationcode in varchar2)
return varchar2 is
    lv_codact INT_SERVICIO_INTRAWAY.ID_ACTIVACION%type;
    lv_actcode_return INT_SERVICIO_INTRAWAY.ID_ACTIVACION%type;
    ll_existe         integer;
    ll_contcodact     integer;
    v_flg_auto        varchar2(1);
  begin
    ll_existe := 0;
    if p_a_id_estado = 1 then
      lv_actcode_return := 0;
      BEGIN
        select id_activacion into lv_actcode_return
        from INTRAWAY.INT_CODIGO_ACTIVACION
        where id_producto = p_id_producto and id_interfase = p_id_interfase
        and id_cliente = p_id_cliente and rownum = 1;
      EXCEPTION
        WHEN OTHERS THEN
          lv_actcode_return := 0;
      END;
      IF lv_actcode_return = 0 THEN
        BEGIN
          SELECT c.valor INTO v_flg_auto
          FROM CONSTANTE C
          WHERE C.CONSTANTE = 'ITW_AUTO_CODACT';
        EXCEPTION
          WHEN OTHERS THEN
            v_flg_auto := 0;
        END;
        IF v_flg_auto = '1' THEN
          WHILE ll_existe = 0 LOOP
            SELECT LPAD(trunc(ABS(dbms_random.value(0, 99999))), 5, '0') ||
                   LPAD(trunc(ABS(dbms_random.value(0, 99999))), 5, '0') ||
                   round(dbms_random.value(0, 1), 0)
            into lv_codact FROM dual;
            select count(1) into ll_contcodact
            from INT_SERVICIO_INTRAWAY
            where id_activacion = lv_codact;
            if ll_contcodact = 0 then
              lv_actcode_return := lv_codact;
              ll_existe         := 1;
            else
              ll_existe := 0;
            end if;
          END LOOP;
        ELSE
          lv_codact := p_activationcode;
        END IF;
        --Insertar en la tabla Codigo Activacion
        INSERT INTO INTRAWAY.INT_CODIGO_ACTIVACION
          (id_activacion,
           id_interfase,
           id_cliente,
           id_producto,
           id_venta,
           codsolot,
           fecha_creacion,
           fecha_modificacion)
        VALUES
          (lv_codact,
           p_id_interfase,
           p_id_cliente,
           p_id_producto,
           0,
           p_codsolot,
           sysdate,
           null);
        lv_actcode_return := lv_codact;
      END IF;
    elsif p_a_id_estado=2 then--5.0
      WHILE ll_existe = 0 LOOP
        SELECT LPAD(trunc(ABS(dbms_random.value(0, 99999))), 5, '0') ||
               LPAD(trunc(ABS(dbms_random.value(0, 99999))), 5, '0') ||
               round(dbms_random.value(0, 1), 0)
        into lv_codact FROM dual;
        select count(1) into ll_contcodact
        from INT_SERVICIO_INTRAWAY
        where id_activacion = lv_codact;
        if ll_contcodact = 0 then
          lv_actcode_return := lv_codact;
          ll_existe         := 1;
        else
          ll_existe := 0;
        end if;
      END LOOP;
      INSERT INTO INTRAWAY.INT_CODIGO_ACTIVACION(id_activacion,id_interfase,id_cliente,
        id_producto,id_venta,codsolot,fecha_creacion,fecha_modificacion)
      VALUES(lv_codact,p_id_interfase,p_id_cliente,p_id_producto,0,p_codsolot,sysdate,null);

    end if;
    return lv_actcode_return;
  end;

  function f_obt_arr_pip(a_idtrs in number)
    return  varchar2 is
    v_list varchar2(4000);
  cursor c_arreglo is
    select valor
    from OPERACION.TRS_INTERFACE_IW_DET
    where idtrs=a_idtrs order by orden ;
  begin
    v_list:='';
    for lc_arr in c_arreglo loop
        v_list:=v_list||'|'||NVL(lc_arr.valor,'');
    end loop;
    return substr(v_list,2);
  end;

  procedure p_reg_variable(a_idtrs number,a_parametro varchar2,
  a_valor varchar2,a_interface number) is
    pragma autonomous_transaction;
  begin
    INSERT INTO OPERACION.TRS_INTERFACE_IW_DET
    (IDTRS, atributo, valor,orden)
    SELECT a_idtrs,a_parametro,a_valor ,orden
    FROM OPERACION.INT_PARAMETRO
    WHERE id_interface = a_interface AND ORDEN IS NOT NULL
    and id_parametro=a_parametro;
    commit;
  end;

  procedure p_genera_reserva_iw(a_idtareawf in number,
     a_idwf      in number,
     a_tarea     in number,
     a_tareadef  in number) is

  n_codsolot  solot.codsolot%type;
  n_coid number;
  n_error number;
  v_mensaje varchar2(400);
  error_general exception;
  n_contrs number;

  BEGIN
    select a.codsolot,b.cod_id
    into n_codsolot,n_coid
    from wf a, solot b
    where a.idwf=a_idwf and a.codsolot=b.codsolot;
    select count(1) into n_contrs from OPERACION.TRS_INTERFACE_IW
    where codsolot=n_codsolot;
    if n_contrs=0 then
      v_mensaje := 'No existen parametros para enviar a IW, por favor generar información';
      RAISE error_general;
    end if;

    WEBSERVICE.PQ_WS_HFC.P_GEN_RESERVAHFC(n_coid,n_codsolot,n_error,v_mensaje);--17.0
    IF n_error < 0 THEN
      v_mensaje := 'Error Generación de Reserva: ' || v_mensaje;
      RAISE error_general;
    END IF;
  EXCEPTION
    WHEN error_general THEN
      p_reg_log(null,null,NULL,n_codsolot,null,n_error,v_mensaje,n_coid,'Generación Reserva');--10.0
    WHEN OTHERS THEN
      v_mensaje   := SQLERRM;
      p_reg_log(null,null,NULL,n_codsolot,null,n_error,v_mensaje,n_coid,'Generación Reserva');--10.0
  End;

  procedure p_inicio_fact(a_idtareawf in number,
       a_idwf      in number,
       a_tarea     in number,
       a_tareadef  in number) is

  n_codsolot  solot.codsolot%type;
  n_coid number;
  n_customer_id number;
  n_error number;
  v_mensaje varchar2(400);
  error_general EXCEPTION;
  n_tiptra      number;--21.0
  n_tipotrabasf number;--21.0

  BEGIN
    select a.codsolot,b.cod_id,b.customer_id,b.tiptra into n_codsolot,n_coid,n_customer_id,n_tiptra --21.0
    from wf a, solot b
    where a.codsolot= b.codsolot and a.idwf = a_idwf;
    --12.0
    pq_solot.p_activacion_automatica(a_idtareawf,a_idwf,a_tarea,a_tareadef);----15.0

    --Generacion de transacciones de SOTs
    update insprd set estinsprd = 1--13.0
    where pid in (select pid from insprd where codinssrv in (select codinssrv from solotpto where codsolot= n_codsolot));
    update inssrv set estinssrv = 1,
    fecini = sysdate
    where codinssrv in (select codinssrv from solotpto where codsolot= n_codsolot);

    --inicio 21.0
     SELECT  COUNT(1)
     INTO    n_tipotrabasf
     FROM    OPERACION.OPEDD
     WHERE   TIPOPEDD = (SELECT TIPOPEDD
                         FROM   OPERACION.TIPOPEDD
                         WHERE  ABREV = 'TIPTRASFAC')
     AND     CODIGON  =  n_tiptra;

    if n_tipotrabasf = 0 then
    --fin 21.0
      p_reg_log(null,n_customer_id,null,n_codsolot,null,null,null,n_coid,'Inicio Facturación');
      WEBSERVICE.PQ_WS_HFC.P_INICIO_FACT(n_codsolot,n_coid,n_error,v_mensaje);
      IF n_error < 0 THEN
        v_mensaje := 'Error Inicio Facturación: ' || v_mensaje;
        RAISE error_general;
      END IF;
    end if;-- 21.0

/*    TIM.PP021_VENTA_HFC.SP_inicio_Fact@DBL_BSCS_BF( n_coid,n_error,v_mensaje);
    IF n_error < 0 THEN
      v_mensaje := 'Error Inicio de Facturación: ' || v_mensaje;
      RAISE error_general;
    END IF;*/

  EXCEPTION
    WHEN error_general THEN
      p_reg_log(null,n_customer_id,NULL,n_codsolot,null,n_error,v_mensaje,n_coid,'Inicio Facturación');--12.0
      raise_application_error(-20001, v_mensaje);
    WHEN OTHERS THEN
      v_mensaje   := SQLERRM;
      p_reg_log(null,n_customer_id,NULL,n_codsolot,null,n_error,v_mensaje,n_coid,'Inicio Facturación');--12.0
      raise_application_error(-20001, v_mensaje);
  End;

  procedure p_instala_srv_iw(an_codsolot in number,
       av_valores_int in varchar2,
       av_valores_tel in varchar2,
       av_valores_cab in varchar2,
       an_error out number,
       av_error out varchar2) is
    n_coid number;
    n_customer_id number;
    n_resultado number;
    v_mensaje varchar2(400);
    error_general EXCEPTION;
  BEGIN
    select  b.cod_id,b.customer_id into n_coid,n_customer_id
    from  solot b
    where codsolot= an_codsolot;

    p_reg_log(null,n_customer_id,NULL,an_codsolot,FND_IDINTERFACE_CM,null,av_valores_int,n_coid,'Instalación Servicio');--10.0
    p_reg_log(null,n_customer_id,NULL,an_codsolot,FND_IDINTERFACE_MTA,null,av_valores_tel,n_coid,'Instalación Servicio');--10.0
    p_reg_log(null,n_customer_id,NULL,an_codsolot,FND_IDINTERFACE_STB,null,av_valores_cab,n_coid,'Instalación Servicio');--10.0

    TIM.PP021_VENTA_HFC.SP_GENERAR_INST_VENTA@DBL_BSCS_BF( n_coid,
       av_valores_int,av_valores_tel,av_valores_cab,
       n_resultado,v_mensaje);
    if n_resultado<0 then
      RAISE error_general;
    end if;
   EXCEPTION
     when error_general  then
       an_Error:=n_resultado;
       av_error:=v_mensaje;
       p_reg_log(null,n_customer_id,NULL,an_codsolot,null,an_Error,av_error,n_coid,'Instalación Servicio');--10.0
       raise_application_error(-20001, av_error);
     WHEN OTHERS THEN
       av_error:='Error Activar Servicios : ' || sqlerrm;
       an_Error:=sqlcode;
       p_reg_log(null,n_customer_id,NULL,an_codsolot,null,an_Error,av_error,n_coid,'Instalación Servicio');--10.0
       raise_application_error(-20001,av_error);
  End;

  FUNCTION F_GET_NCOS(a_codsolot in solot.codsolot%type,
                      a_codsrv   in tystabsrv.codsrv%type,
                      a_opcion   in number) return varchar2 is
    l_valida_ncos number;
    l_cod_ext varchar2(300);
    l_codsolot_bloqueo solot.codsolot%type;
    l_cod_ext_bloqueo  varchar2(200);
    l_lineacontrol number;
    ln_central number;

  BEGIN
    select count(*)
      into l_lineacontrol
      from tystabsrv
     where codsrv = a_codsrv
       and flag_lc = 1;
    --Validacion  wue no es linea control

    select count(ip.pid) into ln_central
    from solotpto sp, tystabsrv t, inssrv i, insprd ip
    where sp.codsolot = a_codsolot and i.codinssrv = sp.codinssrv
    and ip.codinssrv = i.codinssrv and t.codsrv = i.codsrv
    and ip.codsrv in (select valor from constante where constante = 'CVIRTUAL_SRV');

    --Obtengo la SOT de bloqueo
    if a_opcion not in (5, 7, 8, 9) and l_lineacontrol = 0 then
      begin
        select max(s.codsolot) into l_codsolot_bloqueo
        from solotpto s, solot p
        where s.ncos_new is not null
        and s.codinssrv in (select codinssrv from solotpto where codsolot = a_codsolot)
        and s.codsolot = p.codsolot and p.estsol in (12, 29)
        and s.codsrvnue = a_codsrv;
      exception
        when no_data_found then
          l_codsolot_bloqueo := NULL;
      end;
    else
      l_codsolot_bloqueo := NULL;
      l_cod_ext_bloqueo  := NULL;
    end if;
    if l_codsolot_bloqueo is not null then
      begin
        select s.ncos_new
          into l_cod_ext_bloqueo
          from solotpto s
         where s.codsrvnue = a_codsrv
           and s.codsolot = l_codsolot_bloqueo
           and rownum = 1;
      exception
        when others then
          l_cod_ext_bloqueo := '';
      end;
    end if;

    if l_cod_ext_bloqueo is null then
      select count(*)  into l_valida_ncos
      from configuracion_itw   c,
      configxservicio_itw s, configxproceso_itw  p
      where c.idconfigitw = s.idconfigitw and s.codsrv = a_codsrv
      and c.tiposervicioitw = 1 and c.idconfigitw = p.idconfigitw
      and p.proceso = a_opcion;
      if l_valida_ncos > 0 then
        if a_opcion <> 19 then
          if a_opcion = 6 then
            BEGIN
              select decode(ln_central, 0, n.codigo_ext, n.codext_centrex) --<36.0>
              into l_cod_ext
              from configuracion_itw   c,configxservicio_itw s,
              ncosxdepartamento   n, configxproceso_itw  p,
              TYSTABSRV T
              where c.idconfigitw = s.idconfigitw
              and s.codsrv = a_codsrv
              AND C.IDCONFIGITW = TO_NUMBER(T.CODIGO_EXT)
              AND T.CODSRV = S.CODSRV and c.idconfigitw = p.idconfigitw
              and p.proceso = a_opcion and n.idncos = c.idncos
              and trim(n.codest) in
                (select distinct v.codest
                from solotpto p, v_ubicaciones v
                where p.codsolot = a_codsolot
                and v.codubi = p.codubi);
            EXCEPTION
              WHEN OTHERS THEN
                l_cod_ext := '';
            END;
          else
            BEGIN
              select decode(ln_central, 0, n.codigo_ext, n.codext_centrex) --<36.0>
                into l_cod_ext
                from configuracion_itw   c,
                     configxservicio_itw s,
                     ncosxdepartamento   n,
                     configxproceso_itw  p
               where c.idconfigitw = s.idconfigitw
                 and s.codsrv = a_codsrv
                 and c.idconfigitw = p.idconfigitw
                 and p.proceso = a_opcion
                 and n.idncos = c.idncos
                 and trim(n.codest) in
                     (select distinct v.codest
                        from solotpto p, v_ubicaciones v
                       where p.codsolot = a_codsolot
                         and v.codubi = p.codubi);
            EXCEPTION
              WHEN OTHERS THEN
                l_cod_ext := 'XX';
            END;
          end if;
        else
          BEGIN
            select decode(ln_central, 0, n.codigo_ext, n.codext_centrex) --<36.0>
              into l_cod_ext
              from configuracion_itw   c,
                   configxservicio_itw s,
                   ncosxdepartamento   n,
                   configxproceso_itw  p
             where c.idconfigitw = s.idconfigitw
               and s.codsrv = a_codsrv
               and c.idconfigitw = p.idconfigitw
               and p.proceso = a_opcion
               and (c.tipo <> 'B' or c.tipo is null)
               and n.idncos = c.idncos
               and trim(n.codest) in
                   (select distinct v.codest
                      from solotpto p, v_ubicaciones v
                     where p.codsolot = a_codsolot
                       and v.codubi = p.codubi);
          EXCEPTION
            WHEN OTHERS THEN
              l_cod_ext := '';
          END;
        end if;

      else
        if a_opcion <> 19 then
          BEGIN
            select c.codigo_ext
              into l_cod_ext
              from configuracion_itw   c,
                   configxservicio_itw s,
                   configxproceso_itw  p
             where c.idconfigitw = s.idconfigitw
               and s.codsrv = a_codsrv
               and (c.tipo <> 'B' or c.tipo is null)
               and c.idconfigitw = p.idconfigitw
               and p.proceso = a_opcion;
          EXCEPTION
            WHEN OTHERS THEN
              l_cod_ext := '';
          END;

        else
          BEGIN
            select c.codigo_ext
              into l_cod_ext
              from configuracion_itw   c,
                   configxservicio_itw s,
                   configxproceso_itw  p
             where c.idconfigitw = s.idconfigitw
               and s.codsrv = a_codsrv
               and c.idconfigitw = p.idconfigitw
               and p.proceso = a_opcion;
          EXCEPTION
            WHEN OTHERS THEN
              l_cod_ext := '';
          END;

        end if;
      end if;

      Return l_cod_ext;
    else
      Return l_cod_ext_bloqueo;
    end if;

  END;


  function f_obt_channelmap(a_codinssrv in inssrv.codinssrv%type,
                            a_opcion    in number,
                            a_tipo      in number) return varchar2 is
    lv_result    varchar2(100);
    v_codigo_ext varchar2(100);
    v_channelmap varchar2(100);
  begin
    begin
      select w.codigo_ext, o.codigoc channelmap
        into v_codigo_ext, v_channelmap
        from inssrv             i,
             configuracion_itw  w,
             tystabsrv          r,
             configxproceso_itw n,
             OPEDD              o
       where i.codsrv = r.codsrv
         and r.codigo_ext = w.idconfigitw
         and w.idconfigitw = n.idconfigitw
         and o.codigon = w.tiposervicioitw
         and o.tipopedd = 209
         and n.proceso = a_opcion
         and w.estado = 1
         and n.estado = 1
         and i.codinssrv = a_codinssrv;
    exception
      when others then
        if a_tipo = 2 then
          lv_result := 'BASICO';
        else
          lv_result := 'PRIME_DIGITAL';
        end if;
    end;
    if a_tipo = 1 then
      --Devuelve Codigo Externo
      lv_result := v_codigo_ext;
    elsif a_tipo = 2 then
      --Devuelve ChannelMap
      lv_result := v_channelmap;
    end if;
    return lv_result;
  end;


FUNCTION f_obt_cod_ext_int(an_codsolot in solot.codsolot%type,
                  ac_codsrv in tystabsrv.codsrv%type,
                  an_proceso  number ) RETURN VARCHAR2
IS
ls_codigo_ext TYSTABSRV.CODIGO_EXT%TYPE;
ls_cod_ext TYSTABSRV.CODIGO_EXT%TYPE;
l_tiposervicio configuracion_itw.tiposervicioitw%type;

BEGIN
  select t.tiposervicioitw, t.codigo_ext into
  l_tiposervicio,ls_cod_ext
  from configuracion_itw t, configxservicio_itw c, configxproceso_itw p
  where codsrv =ac_codsrv and c.idconfigitw = c.idconfigitw
  and p.idconfigitw = c.idconfigitw and t.idconfigitw = c.idconfigitw
  and p.proceso = an_proceso;
  IF l_tiposervicio=1 THEN
    BEGIN
      select n.codigo_ext into ls_codigo_ext
      from configuracion_itw   c,configxproceso_itw  p,
      ncosxdepartamento  n,configxservicio_itw s,
      solotpto   t, vtatabdst v
       where c.idconfigitw = p.idconfigitw
         and p.proceso = an_proceso
         and c.idconfigitw = s.idconfigitw
         and s.codsrv =ac_codsrv
         and s.codsrv=t.codsrvnue
         and c.idncos = n.idncos
         and t.codubi = v.codubi
         and t.codsolot =an_codsolot
         and v.codest = trim(n.codest);
    EXCEPTION
      WHEN OTHERS THEN
        ls_codigo_ext:='InfinitumVoz';
    END;
  ELSE
      ls_codigo_ext:=ls_cod_ext ;
  END IF;
  RETURN ls_codigo_ext;
  EXCEPTION
    WHEN OTHERS THEN
      SELECT T.CODIGO_EXT INTO ls_codigo_ext
      FROM TYSTABSRV T WHERE T.CODSRV = ac_codsrv;
      RETURN ls_codigo_ext;
END;

--3.0
function f_obt_hub(a_codinssrv in inssrv.codinssrv%type)
    return varchar2 is

  l_plano vtatabgeoref.idplano%type;
  l_abrev ope_hub.abrevhub%type;
  l_hub ope_hub.abrevhub%type;
  l_SEC    NUMBER;
  begin
     BEGIN
       select l.idplano
         into l_plano
         from inssrv i, vtasuccli l
        where i.codsuc = l.codsuc
          and i.codinssrv = a_codinssrv;

        select distinct o.abrevhub
          into l_abrev
          from vtatabgeoref v, ope_hub o
         where v.idhub = o.idhub
           and o.estado = 1
           and v.estado = 1
           and v.idplano =l_plano;
           l_SEC := 1;
       EXCEPTION
         WHEN OTHERS THEN
           l_SEC := 0;
        END;
        IF l_SEC = 1 THEN
          l_hub := l_abrev;
        else
          l_hub := 'VES_DSP';
        end if;
        RETURN l_hub;

end;
--3.0
FUNCTION f_retorno_idiscpe( a_codigo_ext  IN configuracion_itw.codigo_ext%TYPE )
   RETURN VARCHAR2 IS
    v_idiscpe     configuracion_itw.idispcrm%TYPE;
  begin
    select  idispcrm
      into  v_idiscpe
      from  configuracion_itw
     where  codigo_ext = a_codigo_ext;
     return v_idiscpe;
  exception
     when no_data_found then
       select  idispcrm
         into  v_idiscpe
         from  configuracion_itw
        where  codigo_extnb = a_codigo_ext;
        return v_idiscpe;
end;

--29.0 INI
PROCEDURE p_insert_trs_interface_iw
  (a_fila_trs operacion.trs_interface_iw%rowtype)
  IS
  v_contador number;
  pragma autonomous_transaction;
  BEGIN
    -- se valida que no exista el id producto para la misma SOT

    SELECT count(1)
    INTO v_contador
    FROM OPERACION.TRS_INTERFACE_IW a
    WHERE a.codsolot = a_fila_trs.codsolot
    and a.id_producto = a_fila_trs.id_producto
    and a.id_producto_padre = a_fila_trs.id_producto_padre;

    IF v_contador = 0 THEN

      BEGIN
        -- En el caso no exista se insertara
        INSERT INTO OPERACION.TRS_INTERFACE_IW
        (IDTRS, --1
         id_interfase,--2
         tip_interfase,--3
         codcli,--4
         id_servicio,--5
         id_producto,--6
         id_producto_padre, --7
         id_servicio_padre, --8
         codsolot, --9
         pidsga, --10
         codinssrv, --11
         valores, --12
         COD_ID, --13
         codigo_ext, --14
         codactivacion, --15
         estado --16
         )
        VALUES
        (a_fila_trs.idtrs, --1
         a_fila_trs.id_interfase, --2
         a_fila_trs.tip_interfase, --3
         a_fila_trs.codcli, --4
         a_fila_trs.id_servicio, --5
         a_fila_trs.id_producto, --6
         a_fila_trs.id_producto_padre, --7
         a_fila_trs.id_servicio_padre, --8
         a_fila_trs.codsolot, --9
         a_fila_trs.pidsga, --10
         a_fila_trs.codinssrv, --11
         a_fila_trs.valores, --12
         a_fila_trs.cod_id, --13
         a_fila_trs.codigo_ext, -- 14
         a_fila_trs.codactivacion, --15
         a_fila_trs.estado --16
         );
    END;
    ELSE
      -- en el caso exista se actualizara informacion en la tabla

      UPDATE OPERACION.TRS_INTERFACE_IW
      SET id_interfase = a_fila_trs.id_interfase,
          tip_interfase = a_fila_trs.tip_interfase,
          codcli = a_fila_trs.codcli,
          id_servicio = a_fila_trs.id_servicio,
          id_producto_padre = a_fila_trs.id_producto_padre,
          id_servicio_padre = a_fila_trs.id_servicio_padre,
          pidsga = a_fila_trs.pidsga,
          codinssrv = a_fila_trs.codinssrv,
          valores = a_fila_trs.valores,
          COD_ID = a_fila_trs.cod_id,
          codigo_ext = a_fila_trs.codigo_ext,
          codactivacion = a_fila_trs.codactivacion,
          estado = a_fila_trs.estado
      WHERE
        codsolot = a_fila_trs.codsolot and
        id_producto = a_fila_trs.id_producto and
    id_producto_padre = a_fila_trs.id_producto_padre;

    END IF;
     commit;

 EXCEPTION
   When others then
     rollback;
 END;
--29.0 FIN

  PROCEDURE p_interface_cm(a_codcli  IN VARCHAR2,
      a_pid_internet IN NUMBER,
      a_cod_id in number,
      a_codsolot  IN solot.codsolot%TYPE,
      a_codinssrv  IN inssrv.codinssrv%TYPE,
      a_cod_ext  IN tystabsrv.codigo_ext%TYPE,
      a_codact  IN VARCHAR2,
      a_cantcpe  IN NUMBER,
      a_hub      IN intraway.ope_hub.nombre%TYPE DEFAULT NULL,
      a_nodo     IN marketing.vtasuccli.idplano%TYPE DEFAULT NULL,
      o_mensaje  IN OUT VARCHAR2,
      o_error    IN OUT NUMBER)
  iS
  BEGIN
    DECLARE
      v_interface  int_interface.id_interface%TYPE;
      v_servicio  VARCHAR2(2);
      v_cod_ext  int_servicio_intraway.codigo_ext%TYPE;
      n_IDTRS NUMBER;
      v_valores varchar2(400);
      v_mensaje varchar2(400);
      n_error number;
      error_general EXCEPTION;
      v_codsrv operacion.inssrv.codsrv%TYPE;
      ld_fec_exp_codact date;
      v_cod_cpe    configuracion_itw.idispcrm%TYPE;
      v_fila_interface operacion.trs_interface_iw%ROWTYPE; --29.0

    BEGIN
      v_interface := FND_IDINTERFACE_CM;
      v_servicio := FND_IDSERVICIO_CM;
      select codsrv into v_codsrv from inssrv where codinssrv=a_codinssrv;
      SELECT OPERACION.SQ_TRS_INTERFACE_IW.nextval INTO n_IDTRS FROM dual;
      --Variables
      if a_cod_ext is null then--6.0 Solo Telefonia
        v_cod_ext :='InfinitumVoz';
      else
        v_cod_ext := f_obt_cod_ext_int(a_codsolot, v_codsrv, 3);
      end if;
      p_reg_variable(n_idtrs,'ActivationCode',a_codact,v_interface);
      p_reg_variable(n_idtrs,'ServicePackageCRMID',v_cod_ext,v_interface);
      p_reg_variable(n_idtrs,'Hub',a_hub,v_interface);
      p_reg_variable(n_idtrs,'Nodo',a_nodo,v_interface);
      p_reg_variable(n_idtrs,'CantCPE',a_cantcpe,v_interface);
      v_cod_cpe := f_retorno_idiscpe(v_cod_ext);--3.0
      p_reg_variable(n_idtrs,'idISPCRM',v_cod_cpe,v_interface);--3.0
--      p_reg_variable(n_idtrs,'FIXED_IP_MAX',1,v_interface); 3.0
      SELECT sysdate + id_valor into ld_fec_exp_codact FROM OPERACION.INT_PARAMETRO
      WHERE id_interface = 620
      and id_parametro='ACTIVATION_CODE_EXPIRATION_DATE';
      p_reg_variable(n_idtrs,'ACTIVATION_CODE_EXPIRATION_DATE',TO_CHAR(ld_fec_exp_codact,'MM/dd/yyyy HH:mm'),v_interface);

      --Constantes
      for c_cte in (SELECT id_parametro,id_valor
        FROM OPERACION.INT_PARAMETRO
        WHERE id_interface = v_interface
        and orden is not null and tipo=1) loop
        p_reg_variable(n_idtrs,c_cte.id_parametro,c_cte.id_valor,v_interface);
      end loop;

      begin --CM
        v_valores:= f_obt_arr_pip(n_IDTRS);
        --29.0 INI
        v_fila_interface.idtrs := n_IDTRS;
        v_fila_interface.id_interfase := v_interface;
        v_fila_interface.codigo_ext := a_cod_ext;
        v_fila_interface.CODCLI := a_codcli;
        v_fila_interface.id_servicio := v_servicio;
        v_fila_interface.id_producto := a_pid_internet;
        v_fila_interface.id_producto_padre := 0;
        v_fila_interface.id_servicio_padre := 0;
        v_fila_interface.codsolot := a_codsolot;
        v_fila_interface.pidsga := a_pid_internet;
        v_fila_interface.codinssrv := a_codinssrv;
        v_fila_interface.CODACTIVACION := a_codact;
        v_fila_interface.cod_id := a_cod_id;
        v_fila_interface.VALORES := v_valores;
        v_fila_interface.TIP_INTERFASE := 'INT';

        p_insert_trs_interface_iw (v_fila_interface);

        --29.0 FIN
      end;
    EXCEPTION
      WHEN error_general THEN
        o_mensaje := v_mensaje;
        o_error := n_error;
        IF o_mensaje IS NOT NULL THEN
          p_reg_log(a_codcli,null,n_IDTRS,a_codsolot,v_interface,
          o_error,o_mensaje);
        END IF;
      WHEN OTHERS THEN
        o_mensaje := '. p_interface_cm :' || SQLERRM;
        o_error := SQLCODE;
        IF o_mensaje IS NOT NULL THEN
          p_reg_log(a_codcli,null,n_IDTRS,a_codsolot,v_interface,
          o_error,o_mensaje);
        END IF;
    END;
  END p_interface_cm;

      PROCEDURE p_interface_mta(a_codcli   IN vtatabcli.codcli%TYPE,
      a_pid_telefonia  IN NUMBER,
      a_pid_internet IN NUMBER,
      a_cod_id in number,
      a_codsolot       IN solot.codsolot%TYPE,
      a_codinssrv      IN inssrv.codinssrv%TYPE,
      a_profilecrmid   IN VARCHAR2, --CMTS
      a_codact  IN VARCHAR2,
      o_mensaje        IN OUT VARCHAR2,
      o_error          IN OUT NUMBER)
   IS
      v_cms            varchar2(100);  -- <16.0>
      v_isp            varchar2(100);  -- <16.0>
      v_fila_interface operacion.trs_interface_iw%ROWTYPE; --29.0

   BEGIN
    DECLARE
      n_IDTRS number;
      v_interface      int_interface.id_interface%TYPE;
      v_servicio       VARCHAR2(2);
      v_servicio_padre VARCHAR2(2);
      v_valores varchar2(400);
      v_mensaje varchar2(400);
      error_general EXCEPTION;
      n_error number;
    BEGIN
      v_interface := FND_IDINTERFACE_MTA;
      v_servicio := FND_IDSERVICIO_MTA;
      v_servicio_padre := FND_IDSERVICIO_CM;

      SELECT OPERACION.SQ_TRS_INTERFACE_IW.nextval INTO n_IDTRS FROM dual;
      v_cms := intraway.pq_intraway.f_softswitch(a_pid_telefonia, 1, v_interface, 'CmsCrmId' );         --<18.0> // --<16.0>
      v_isp := intraway.pq_intraway.f_softswitch(a_pid_telefonia, 1, v_interface, 'ispMTACrmId' );      --<18.0> // --<16.0>
      --Variables
      p_reg_variable(n_idtrs,'ActivationCode',a_codact,v_interface);
      p_reg_variable(n_idtrs,'ProfileCrmId',a_profilecrmid,v_interface);
      p_reg_variable(n_idtrs,'CmsCrmId',v_cms,v_interface);       --<16.0>
      p_reg_variable(n_idtrs,'ispMTACrmId',v_isp,v_interface);    --<16.0>
      --Constantes
      for c_cte in (SELECT id_parametro,id_valor
        FROM OPERACION.INT_PARAMETRO
        WHERE id_interface = v_interface
        and orden is not null and tipo=1
        and id_parametro not in ('CmsCrmId','ispMTACrmId') --<16.0>
                    ) loop
        p_reg_variable(n_idtrs,c_cte.id_parametro,c_cte.id_valor,v_interface);
      end loop;

      begin --MTA
        v_valores:= f_obt_arr_pip(n_IDTRS);

        --29.0 INI
        v_fila_interface.idtrs := n_IDTRS;
        v_fila_interface.id_interfase := v_interface;
        v_fila_interface.tip_interfase := 'TLF';
        v_fila_interface.codigo_ext := a_profilecrmid;
        v_fila_interface.codcli := a_codcli;
        v_fila_interface.id_servicio := v_servicio;
        v_fila_interface.id_producto := a_pid_telefonia;
        v_fila_interface.id_producto_padre := a_pid_internet;
        v_fila_interface.id_servicio_padre := v_servicio_padre;
        v_fila_interface.codsolot := a_codsolot;
        v_fila_interface.pidsga := a_pid_telefonia;
        v_fila_interface.codinssrv := a_codinssrv;
        v_fila_interface.codactivacion := a_codact;
        v_fila_interface.valores := v_valores;
        v_fila_interface.Cod_Id := a_cod_id;


        p_insert_trs_interface_iw(v_fila_interface);

        --29.0 FIN
      end;

    EXCEPTION
      WHEN error_general THEN
        o_mensaje := v_mensaje;
        o_error := n_error;
        IF n_error < 0 THEN
          p_reg_log(a_codcli,null,n_IDTRS,a_codsolot,v_interface,
          o_error,o_mensaje);
        END IF;
      WHEN OTHERS THEN
        o_mensaje := 'p_interface_mta :' || SQLERRM;
        o_error := SQLCODE;
        IF o_mensaje IS NOT NULL THEN
          p_reg_log(a_codcli,null,n_IDTRS,a_codsolot,v_interface,
          o_error,o_mensaje);
        END IF;
    END;
  END p_interface_mta;

  PROCEDURE p_interface_mta_ep(a_codcli   IN vtatabcli.codcli%TYPE,
      a_id_producto        IN NUMBER,
      a_producto_padre    IN NUMBER,
      a_nroendpoint       IN NUMBER,
      a_nrotelefono       IN numtel.numero%TYPE,
      a_homeexchangecrmid IN VARCHAR2,
      a_cod_id in number,
      a_codsolot          IN solot.codsolot%TYPE,
      a_codinssrv         IN inssrv.codinssrv%TYPE,
      o_mensaje           IN OUT VARCHAR2,
      o_error             IN OUT NUMBER)
   IS
   v_cms            varchar2(100);  -- <16.0>
   v_fila_interface operacion.trs_interface_iw%ROWTYPE; --29.0

  BEGIN
    DECLARE
      n_IDTRS number;
      v_interface      int_interface.id_interface%TYPE;
      v_servicio       VARCHAR2(2);
      v_servicio_padre VARCHAR2(2);
      v_valores varchar2(400);
      error_general EXCEPTION;
      n_error number;
      v_mensaje varchar2(400);
    BEGIN
      v_interface := FND_IDINTERFACE_EP;
      v_servicio  := FND_IDSERVICIO_EP;
      v_servicio_padre := FND_IDSERVICIO_MTA;

      SELECT OPERACION.SQ_TRS_INTERFACE_IW.nextval INTO n_IDTRS FROM dual;
      v_cms := intraway.pq_intraway.f_softswitch(a_producto_padre, 1, v_interface, 'CmsCrmId' );   --<18.0> // --<16.0>
      --Variables
      p_reg_variable(n_idtrs,'HomeExchangeCrmId',a_homeexchangecrmid,v_interface);
      p_reg_variable(n_idtrs,'EndPointNumber',a_nroendpoint,v_interface);
      p_reg_variable(n_idtrs,'TN',a_nrotelefono,v_interface);
      p_reg_variable(n_idtrs,'CmsCrmId',v_cms,v_interface);       --<16.0>
     --Constantes
      for c_cte in (SELECT id_parametro,id_valor
        FROM OPERACION.INT_PARAMETRO
        WHERE id_interface = v_interface
        and orden is not null and tipo=1
        and id_parametro not in ('CmsCrmId') --<16.0>
                ) loop
        p_reg_variable(n_idtrs,c_cte.id_parametro,c_cte.id_valor,v_interface);
      end loop;

      begin --MTA
        v_valores:= f_obt_arr_pip(n_IDTRS);
        --29.0 INI
        v_fila_interface.idtrs := n_IDTRS;
        v_fila_interface.id_interfase:= v_interface;
        v_fila_interface.tip_interfase := 'TEP';
        v_fila_interface.codcli:= a_codcli;
        v_fila_interface.id_servicio := v_servicio;
        v_fila_interface.id_producto := a_id_producto;
        v_fila_interface.id_producto_padre := a_producto_padre;
        v_fila_interface.id_servicio_padre := v_servicio_padre;
        v_fila_interface.codsolot := a_codsolot;
        v_fila_interface.pidsga := a_producto_padre;
        v_fila_interface.codinssrv := a_codinssrv;
        v_fila_interface.valores := v_valores;
        v_fila_interface.cod_id := a_cod_id;


        p_insert_trs_interface_iw(v_fila_interface);

        --29.0 FIN
      end;

    EXCEPTION
      WHEN error_general THEN
        o_mensaje := v_mensaje;
        o_error := n_error;
        IF n_error < 0 THEN
          p_reg_log(a_codcli,null,n_IDTRS,a_codsolot,v_interface,
          o_error,o_mensaje);
        END IF;
      WHEN OTHERS THEN
        o_mensaje := 'p_interface_mta_ep :' || SQLERRM;
        o_error := SQLCODE;
        IF o_mensaje IS NOT NULL THEN
          p_reg_log(a_codcli,null,n_IDTRS,a_codsolot,v_interface,
          o_error,o_mensaje);
        END IF;
    END;
  END p_interface_mta_ep;

  PROCEDURE p_interface_mta_fac(a_codcli IN vtatabcli.codcli%TYPE,
      a_id_producto        IN NUMBER,
      a_producto_padre    IN NUMBER,
      a_pid_telefonia  IN NUMBER,
      a_codigo_ext IN tystabsrv.codigo_ext%TYPE,
      a_cod_id in number,
      a_codsolot IN solot.codsolot%TYPE,
      a_codinssrv  IN int_servicio_intraway.codinssrv%TYPE,
      o_mensaje   IN OUT VARCHAR2,
      o_error  IN OUT NUMBER)
   IS
    v_fila_interface operacion.trs_interface_iw%ROWTYPE; --29.0
  BEGIN
    DECLARE
      n_IDTRS number;
      v_interface      int_interface.id_interface%TYPE;
      v_servicio       VARCHAR2(2);
      v_servicio_padre VARCHAR2(2);
      v_valores varchar2(400);
      error_general EXCEPTION;
      n_error number;
      v_mensaje varchar2(400);
    BEGIN
      v_interface  := FND_IDINTERFACE_CF;
      v_servicio := FND_IDSERVICIO_CF;
      v_servicio_padre := FND_IDSERVICIO_EP;

      SELECT OPERACION.SQ_TRS_INTERFACE_IW.nextval INTO n_IDTRS FROM dual;

      --Variables
      p_reg_variable(n_idtrs,'FeatureCrmId',a_codigo_ext,v_interface);
--      p_reg_variable(n_idtrs,'SendToController',a_nroendpoint,v_interface);
     --Constantes
      for c_cte in (SELECT id_parametro,id_valor
        FROM OPERACION.INT_PARAMETRO
        WHERE id_interface = v_interface
        and orden is not null and tipo=1) loop
        p_reg_variable(n_idtrs,c_cte.id_parametro,c_cte.id_valor,v_interface);
      end loop;

      begin --MTA
        v_valores:= f_obt_arr_pip(n_IDTRS);
        --29.0 INI
        v_fila_interface.idtrs := n_IDTRS;
        v_fila_interface.id_interfase:= v_interface;
        v_fila_interface.tip_interfase := 'ATE';
        v_fila_interface.codcli:= a_codcli;
        v_fila_interface.id_servicio := v_servicio;
        v_fila_interface.id_producto := a_id_producto;
        v_fila_interface.id_producto_padre := a_producto_padre;
        v_fila_interface.id_servicio_padre := v_servicio_padre;
        v_fila_interface.codsolot := a_codsolot;
        v_fila_interface.pidsga := a_pid_telefonia;
        v_fila_interface.codinssrv := a_codinssrv;
        v_fila_interface.valores := v_valores;
        v_fila_interface.cod_id := a_cod_id;

        p_insert_trs_interface_iw(v_fila_interface);

        --29.0 FIN
      end;

    EXCEPTION
      WHEN error_general THEN
        o_mensaje := v_mensaje;
        o_error := n_error;
        IF n_error < 0 THEN
          p_reg_log(a_codcli,null,n_IDTRS,a_codsolot,v_interface,
          o_error,o_mensaje);
        END IF;
      WHEN OTHERS THEN
        o_mensaje := 'p_interface_mta_fac :' || SQLERRM;
        o_error := SQLCODE;
        IF o_mensaje IS NOT NULL THEN
          p_reg_log(a_codcli,null,n_IDTRS,a_codsolot,v_interface,
          o_error,o_mensaje);
        END IF;
    END;
  END p_interface_mta_fac;

  PROCEDURE p_interface_stb(a_codcli IN vtatabcli.codcli%TYPE,
       a_pid_stb IN NUMBER,
       a_pid_cab IN NUMBER,
       a_codact  IN VARCHAR2,
       a_codigo_ext  IN VARCHAR2,
       a_channelmap      IN VARCHAR2,
       a_configcrmid     IN VARCHAR2,
       a_cod_id in number,
       a_codsolot        IN solot.codsolot%TYPE,
      a_codinssrv       IN inssrv.codinssrv%TYPE,
       a_sendtocontroler IN VARCHAR2,
       o_mensaje         IN OUT VARCHAR2,
       o_error           IN OUT NUMBER) IS

  v_fila_interface operacion.trs_interface_iw%ROWTYPE; --29.0

  BEGIN

    DECLARE
      n_IDTRS number;
      v_interface      int_interface.id_interface%TYPE;
      v_servicio       VARCHAR2(2);
      v_valores varchar2(400);
      error_general EXCEPTION;
      n_error number;
      v_mensaje varchar2(400);
    BEGIN
      v_interface := FND_IDINTERFACE_STB;
      v_servicio := FND_IDSERVICIO_STB;

      SELECT OPERACION.SQ_TRS_INTERFACE_IW.nextval INTO n_IDTRS FROM dual;
      --Variables
      p_reg_variable(n_idtrs,'activationCode',a_codact,v_interface);
      p_reg_variable(n_idtrs,'defaultProductCRMId',a_codigo_ext,v_interface);
      p_reg_variable(n_idtrs,'channelMapCRMId',a_channelmap,v_interface);
      p_reg_variable(n_idtrs,'defaultConfigCRMId',a_configcrmid,v_interface);
      p_reg_variable(n_idtrs,'sendToController',a_sendtocontroler,v_interface);
     --Constantes
      for c_cte in (SELECT id_parametro,id_valor
        FROM OPERACION.INT_PARAMETRO
        WHERE id_interface = v_interface
        and orden is not null and tipo=1) loop
        p_reg_variable(n_idtrs,c_cte.id_parametro,c_cte.id_valor,v_interface);
      end loop;

      begin --MTA
        v_valores:= f_obt_arr_pip(n_IDTRS);
        --29.0 INI
        v_fila_interface.idtrs := n_IDTRS;
        v_fila_interface.id_interfase:= v_interface;
        v_fila_interface.codcli := a_codcli;
        v_fila_interface.tip_interfase := 'CTV';
        v_fila_interface.id_servicio := v_servicio;
        v_fila_interface.id_producto := a_pid_stb;
        v_fila_interface.id_producto_padre := 0;
        v_fila_interface.id_servicio_padre := 0;
        v_fila_interface.codigo_ext := a_codigo_ext;
        v_fila_interface.codsolot := a_codsolot;
        v_fila_interface.codactivacion := a_codact;
        v_fila_interface.pidsga := a_pid_cab;
        v_fila_interface.codinssrv := a_codinssrv;
        v_fila_interface.valores := v_valores;
        v_fila_interface.cod_id := a_cod_id;


        p_insert_trs_interface_iw(v_fila_interface);

        --29.0 FIN
      end;

    EXCEPTION
      WHEN error_general THEN
        o_mensaje := v_mensaje;
        o_error := n_error;
        IF n_error < 0 THEN
          p_reg_log(a_codcli,null,n_IDTRS,a_codsolot,v_interface,
          o_error,o_mensaje);
        END IF;
      WHEN OTHERS THEN
        o_mensaje := 'p_interface_stb :' || SQLERRM;
        o_error := SQLCODE;
        IF o_mensaje IS NOT NULL THEN
          p_reg_log(a_codcli,null,n_IDTRS,a_codsolot,v_interface,
          o_error,o_mensaje);
        END IF;
    END;
  END p_interface_stb;

  PROCEDURE p_interface_stb_vod(a_codcli IN VARCHAR2,
       a_pid_stb_fac IN NUMBER,
       a_pid_stb IN NUMBER,
       a_pid_cable IN NUMBER,
       a_codigo_ext  IN tystabsrv.codigo_ext%TYPE,
       a_cod_id in number,
       a_codsolot IN solot.codsolot%TYPE,
       a_codinssrv IN int_servicio_intraway.codinssrv%TYPE,
       o_mensaje IN OUT VARCHAR2,
       o_error IN OUT NUMBER) IS
       v_fila_interface operacion.trs_interface_iw%ROWTYPE; --29.0

  BEGIN
    DECLARE
      n_IDTRS number;
      v_interface         int_interface.id_interface%TYPE;
      v_servicio          VARCHAR2(2);
      v_servicio_padre    VARCHAR2(2);
      v_valores varchar2(400);
      error_general EXCEPTION;
      n_error number;
      v_mensaje varchar2(400);
    BEGIN
      v_interface      := FND_IDINTERFACE_STB_VOD;
      v_servicio       := FND_IDSERVICIO_STB_VOD;
      v_servicio_padre := FND_IDSERVICIO_STB;

      SELECT OPERACION.SQ_TRS_INTERFACE_IW.nextval INTO n_IDTRS FROM dual;

      --Variables
      p_reg_variable(n_idtrs,'VODProfileCRMId',a_codigo_ext,v_interface);
     --Constantes
      for c_cte in (SELECT id_parametro,id_valor
        FROM OPERACION.INT_PARAMETRO
        WHERE id_interface = v_interface
        and orden is not null and tipo=1) loop
        p_reg_variable(n_idtrs,c_cte.id_parametro,c_cte.id_valor,v_interface);
      end loop;

      begin --MTA
        begin
        v_valores:= f_obt_arr_pip(n_IDTRS);
        --29.0 INI
        v_fila_interface.idtrs := n_IDTRS;
        v_fila_interface.id_interfase:= v_interface;
        v_fila_interface.codcli := a_codcli;
        v_fila_interface.id_servicio := v_servicio;
        v_fila_interface.id_producto := a_pid_stb_fac;
        v_fila_interface.id_producto_padre := a_pid_cable;
        v_fila_interface.tip_interfase := 'VOD';
        v_fila_interface.id_servicio_padre := v_servicio_padre;
        v_fila_interface.codsolot := a_codsolot;
        v_fila_interface.pidsga := a_pid_stb;
        v_fila_interface.codinssrv := a_codinssrv;
        v_fila_interface.valores := v_valores;
        v_fila_interface.cod_id := a_cod_id;


        p_insert_trs_interface_iw (v_fila_interface);

        --29.0 FIN
        EXCEPTION
          when others then
            raise_application_error(-20001,sqlerrm);
        end;
      end;

    EXCEPTION
      WHEN error_general THEN
        o_mensaje := v_mensaje;
        o_error := n_error;
        IF n_error < 0 THEN
          p_reg_log(a_codcli,null,n_IDTRS,a_codsolot,v_interface,
          o_error,o_mensaje);
        END IF;
      WHEN OTHERS THEN
        o_mensaje := 'p_interface_stb_vod :' || SQLERRM;
        o_error := SQLCODE;
        IF o_mensaje IS NOT NULL THEN
          p_reg_log(a_codcli,null,n_IDTRS,a_codsolot,v_interface,
          o_error,o_mensaje);
        END IF;
    END;
  END p_interface_stb_vod;

  PROCEDURE p_interface_stb_sa(a_codcli IN vtatabcli.codcli%TYPE,
      a_pid_stb_fac IN NUMBER,
      a_pid_stb IN NUMBER,
      a_pid_cable IN NUMBER,
      a_codigo_ext IN tystabsrv.codigo_ext%TYPE,
      a_cod_id in number,
      a_codsolot        IN solot.codsolot%TYPE,
      a_codinssrv       IN int_servicio_intraway.codinssrv%TYPE,
      o_mensaje         IN OUT VARCHAR2,
      o_error           IN OUT NUMBER) IS
   v_fila_interface operacion.trs_interface_iw%ROWTYPE; --29.0

  BEGIN
    DECLARE
      n_IDTRS    NUMBER;
      v_interface      int_interface.id_interface%TYPE;
      v_servicio       VARCHAR2(2);
      v_servicio_padre VARCHAR2(2);
      v_valores varchar2(400);
      error_general EXCEPTION;
      n_error number;
      v_mensaje varchar2(400);
    BEGIN
      v_interface  := FND_IDINTERFACE_STB_SA;
      v_servicio       := FND_IDSERVICIO_STB_SA;
      v_servicio_padre := FND_IDSERVICIO_STB;

      SELECT OPERACION.SQ_TRS_INTERFACE_IW.nextval INTO n_IDTRS FROM dual;
    --Variables
      p_reg_variable(n_idtrs,'productCRMId',a_codigo_ext,v_interface);
      begin --
        v_valores:= f_obt_arr_pip(n_IDTRS);
        --29.0 INI
        v_fila_interface.idtrs := n_IDTRS;
        v_fila_interface.id_interfase:= v_interface;
        v_fila_interface.codcli := a_codcli;
        v_fila_interface.id_servicio := v_servicio;
        v_fila_interface.id_producto := a_pid_stb_fac;
        v_fila_interface.id_producto_padre := a_pid_cable;
        v_fila_interface.tip_interfase := 'ATV';
        v_fila_interface.id_servicio_padre := v_servicio_padre;
        v_fila_interface.codsolot := a_codsolot;
        v_fila_interface.pidsga := a_pid_stb;
        v_fila_interface.codinssrv := a_codinssrv;
        v_fila_interface.valores := v_valores;
        v_fila_interface.cod_id := a_cod_id;


        p_insert_trs_interface_iw (v_fila_interface);

        --29.0 FIN
      end;
    EXCEPTION
      WHEN error_general THEN
        o_mensaje := v_mensaje;
        o_error := n_error;
        IF n_error < 0 THEN
          p_reg_log(a_codcli,null,n_IDTRS,a_codsolot,v_interface,
          o_error,o_mensaje);
        END IF;
      WHEN OTHERS THEN
        o_mensaje := 'p_interface_stb_sa :' || SQLERRM;
        o_error := SQLCODE;
        IF o_mensaje IS NOT NULL THEN
          p_reg_log(a_codcli,null,n_IDTRS,a_codsolot,v_interface,
          o_error,o_mensaje);
        END IF;
    END;

  END p_interface_stb_sa;

  PROCEDURE p_interface_stb_manto(a_codcli IN vtatabcli.codcli%TYPE,
        a_id_producto IN int_servicio_intraway.id_producto%TYPE DEFAULT '0',
        a_cod_id in number,
        a_codsolot    IN solot.codsolot%TYPE DEFAULT '0',
        a_codinssrv   IN inssrv.codinssrv%TYPE DEFAULT '0',
        a_comando     IN VARCHAR2,
        o_mensaje     IN OUT VARCHAR2,
        o_error       IN OUT NUMBER)
   IS
   v_fila_interface operacion.trs_interface_iw%ROWTYPE; --29.0

  BEGIN
    DECLARE
      n_IDTRS NUMBER;
      v_interface    int_interface.id_interface%TYPE;
      v_servicio     VARCHAR2(2);
      v_pidactual NUMBER;

    BEGIN
      v_interface := FND_IDINTERFACE_STB_MTO;
      v_servicio := FND_IDSERVICIO_STB;

      SELECT OPERACION.SQ_TRS_INTERFACE_IW.nextval INTO n_IDTRS FROM dual;
      --29.0 INI
      v_fila_interface.idtrs := n_IDTRS;
      v_fila_interface.id_interfase := v_interface;
      v_fila_interface.codcli := 1;
      v_fila_interface.id_servicio := a_codcli;
      v_fila_interface.id_producto := v_servicio;
      v_fila_interface.id_producto_padre :=a_id_producto;
      v_fila_interface.id_servicio_padre := 0;
      v_fila_interface.estado := 0;
      v_fila_interface.codsolot := a_codsolot;
      v_fila_interface.pidsga := v_pidactual;
      v_fila_interface.codinssrv :=a_codinssrv;
      v_fila_interface.cod_id :=a_cod_id;


      p_insert_trs_interface_iw (v_fila_interface);

      --29.0 FIN
      INSERT INTO OPERACION.TRS_INTERFACE_IW_DET
      (IDTRS, atributo, valor)
      VALUES (n_IDTRS,'command',a_comando);

    EXCEPTION
      WHEN OTHERS THEN
        o_mensaje := 'p_interface_stb_manto :' || SQLERRM;
        o_error := SQLCODE;
        IF o_mensaje IS NOT NULL THEN
          p_reg_log(a_codcli,null,n_IDTRS,a_codsolot,v_interface,
          o_error,o_mensaje);
        END IF;
    END;
  END p_interface_stb_manto;

  procedure p_reg_log(ac_codcli OPERACION.SOLOT.CODCLI%type,an_customer_id number,
      an_idtrs number,an_codsolot number,an_idinterface number,
      an_error number, av_texto varchar2,an_cod_id number default 0,av_proceso varchar default '') is--10.0
      pragma autonomous_transaction;
  begin
    insert into OPERACION.LOG_TRS_INTERFACE_IW(CODCLI,
    IDTRS,CODSOLOT,IDINTERFACE,ERROR,TEXTO,CUSTOMER_ID,COD_ID,PROCESO)--10.0
    values(ac_codcli,an_idtrs,an_codsolot,an_idinterface,an_error,
    av_texto,an_customer_id,an_cod_id,av_proceso);--10.0
    commit;
  end;
--13.0
PROCEDURE p_asignar_numero(a_codsolot in number,a_numero in varchar2,o_mensaje IN OUT VARCHAR2,o_error IN OUT NUMBER) IS

  v_flg_verifica number;
  error_general EXCEPTION;
  n_error number;
  v_numslc vtadetptoenl.numslc%TYPE;
  n_codnumtel numtel.codnumtel%TYPE;
  n_codinssrv inssrv.codinssrv%TYPE;
  v_codcli solot.codcli%TYPE;
  n_cod_id solot.cod_id%TYPE;
  n_idtrs OPERACION.TRS_INTERFACE_IW.IDTRS%TYPE;
  v_mensaje varchar2(1000);
  v_numero varchar2(30);
  n_estinssrv number;
  n_zona number;
  n_estsol number;
  n_contval number;
  v_contnum number;
  n_val_num number;
  n_contador number;
  LN_CONTADOR number;




  cursor c_tel is
      select a.numslc,a.numpto,a.ubipto,a.codsuc,e.codcli,e.idsolucion
      from vtadetptoenl a,tystabsrv b,producto c,vtatabslcfac e
      where a.codsrv = b.codsrv and b.idproducto = c.idproducto
        and a.numslc = e.numslc and a.numslc = v_numslc
        and c.idtipinstserv = 3 and a.flgsrv_pri = 1
      order by a.numpto;

  ln_nocontienenumero number; --23.0

BEGIN
  select estsol,codcli,numslc,cod_id
   into n_estsol,v_codcli,v_numslc,n_cod_id
   from solot where codsolot=a_codsolot;

   if a_numero is null then
    select to_number(valor)
    into n_zona
    from constante where trim(constante) = 'ZONA3PLAY_AUT';

    FOR c_t IN c_tel LOOP
      v_flg_verifica := 0;

      -- INI 23.0
      SELECT count(codinssrv)
      into ln_nocontienenumero
      FROM inssrv WHERE tipinssrv = 3 AND numero IS NULL
      AND numslc = v_numslc AND numpto = c_t.numpto;

begin
      if ln_nocontienenumero > 0 then
      --FIN 23.0

        select codigoc
         into n_val_num
        from opedd a, tipopedd b
        where a.tipopedd = b.tipopedd
        and b.abrev = 'SGA_ASIGNAR_NUMERO';


        if   n_val_num = '1' then

           LN_CONTADOR := 0;
      LOOP
        LN_CONTADOR := LN_CONTADOR + 1;
        SELECT F_GET_NUMERO_TEL_ITW(N_ZONA, C_T.UBIPTO)
          INTO V_NUMERO
          FROM DUMMY_OPE;
        IF V_NUMERO IS NULL OR V_NUMERO = '0' THEN
          V_MENSAJE := 'No existe numero telefonico disponible.';
          N_ERROR   := -1;
          RAISE ERROR_GENERAL;
        END IF;
          --Identificar SID y numtel
        SELECT codinssrv into n_codinssrv
        FROM inssrv WHERE tipinssrv = 3 AND numero IS NULL AND numslc = v_numslc AND numpto = c_t.numpto AND rownum = 1;
        select codnumtel into n_codnumtel from numtel where numero=v_numero;
        --Actualizar valores en SID y numtel
        BEGIN
          update inssrv set numero = v_numero
          where codinssrv = n_codinssrv;
          UPDATE NUMTEL set CODINSSRV = n_codinssrv,estnumtel=2
          where numero =v_numero;
          COMMIT;
        END;
        INSERT INTO reservatel(codnumtel,numslc,numpto,valido,estnumtel,codcli,publicar)
        VALUES(n_codnumtel,c_t.numslc,c_t.numpto, 1, 2, c_t.codcli, 0);

        select count (1)
         into v_contnum
        from contr_services_cap@Dbl_Bscs_Bf a,
           directory_number@Dbl_Bscs_Bf   c,
           curr_co_status@dbl_bscs_bf     d
        where c.dn_num = v_numero
        and a.dn_id = c.dn_id
        and a.co_id = d.co_id
        and d.ch_status in ('a', 's');

        IF v_contnum = 0 THEN
          LN_CONTADOR := 3;

        END IF;
       EXIT WHEN LN_CONTADOR = 3;
      END LOOP;

 else
      SELECT F_GET_NUMERO_TEL_ITW(N_ZONA, C_T.UBIPTO)
        INTO V_NUMERO
        FROM DUMMY_OPE;
      IF V_NUMERO IS NULL OR V_NUMERO = '0' THEN
        V_MENSAJE := 'No existe numero telefonico disponible.';
        N_ERROR   := -1;
        RAISE ERROR_GENERAL;
      END IF;


        --Identificar SID y numtel
        SELECT codinssrv into n_codinssrv
        FROM inssrv WHERE tipinssrv = 3 AND numero IS NULL AND numslc = v_numslc AND numpto = c_t.numpto AND rownum = 1;
        select codnumtel into n_codnumtel from numtel where numero=v_numero;

        --Actualizar valores en SID y numtel
        BEGIN --23.0
          update inssrv set numero = v_numero
          where codinssrv = n_codinssrv;
          UPDATE NUMTEL set CODINSSRV = n_codinssrv,estnumtel=2
          where numero =v_numero;
          COMMIT; --23.0
        END; --23.0
        INSERT INTO reservatel(codnumtel,numslc,numpto,valido,estnumtel,codcli,publicar)
        VALUES(n_codnumtel,c_t.numslc,c_t.numpto, 1, 2, c_t.codcli, 0);
 end if;

      end if; -- 23.0

end;

    END LOOP;


  else
    select a.estinssrv,a.codinssrv  into n_estinssrv, n_codinssrv
    from inssrv a, solotpto b, insprd c
    where a.codinssrv=b.codinssrv and b.codsolot=a_codsolot
      and b.pid=c.pid  and tipinssrv=3 and c.flgprinc=1;

    if n_estsol=17 and n_estinssrv=4 then
      select codnumtel into n_codnumtel from numtel where numero=a_numero;
      delete from reservatel where codcli = v_codcli and numslc = v_numslc;
      update inssrv set numero = a_numero
      where codinssrv = n_codinssrv;
      update numtel set estnumtel=2, codinssrv = n_codinssrv, fecasg = sysdate
      where codnumtel = n_codnumtel;
      INSERT INTO reservatel(codnumtel,numslc,numpto,valido,estnumtel,codcli,publicar)
      VALUES(n_codnumtel,v_numslc,'00002', 1, 2, v_codcli, 0);
      --Asignar parametros para BSCS
      if n_cod_id is not null then
        select count(1) into n_contval from OPERACION.TRS_INTERFACE_IW where cod_id=n_cod_id and tip_interfase='TEP';
        if n_contval= 1 then
          select idtrs into n_idtrs from OPERACION.TRS_INTERFACE_IW where cod_id=n_cod_id and tip_interfase='TEP';
          UPDATE OPERACION.TRS_INTERFACE_IW_DET SET VALOR= a_numero where IDTRS=n_idtrs AND atributo='TN';
          UPDATE OPERACION.TRS_INTERFACE_IW SET VALORES= OPERACION.PQ_IW_SGA_BSCS.f_obt_arr_pip(n_idtrs) where IDTRS=n_idtrs;
        end if;
      end if;
    else
      raise error_general;
      v_mensaje:='Validar si la SOT se encuentra en Ejecucion o el Estado del Servicio es invalido.';
      n_error:=-2;
    end if;
  end if;
  o_error := 0;

EXCEPTION
  WHEN error_general THEN
    o_mensaje := v_mensaje;
    o_error := n_error;
    IF n_error < 0 THEN
          p_reg_log(v_codcli,null,n_idtrs,a_codsolot,null,o_error,o_mensaje,n_cod_id,'Asignar Número Telefónico');
    END IF;
  WHEN OTHERS THEN
        o_mensaje := 'Asignar_Número Telefónico:' || SQLERRM;
    o_error := SQLCODE;
    IF o_error <0 THEN
          p_reg_log(v_codcli,null,n_idtrs,a_codsolot,null,o_error,o_mensaje,n_cod_id,'Asignar Número Telefónico');
    END IF;
END p_asignar_numero;

function f_sot_desde_sisact(an_codsolot operacion.solot.codsolot%TYPE,an_codigo number default 0)
    return number is
    n_cont_inst number;
    n_cont_cp number;
    n_flag_ven_sql number;
    v_ven_sql varchar2(4000);
    n_retorno number;
  begin
    --Inicio 10.0
/*    SELECT t.idinstancia  INTO l_codsolot
       FROM sales.int_negocio_instancia t, solot s
     WHERE t.idinstancia = an_codsolot and s.codsolot=t.idinstancia
       AND t.instancia = 'SOT' and s.customer_id is not null;*/
    if an_codigo>0 then --PBD Actualizada
      select flag_ven_sql,ven_sql into n_flag_ven_sql,v_ven_sql from inv_ventana where idventana=an_codigo;
    end if;
    if (an_codigo=0) or (an_codigo>0 and n_flag_ven_sql=0) then --(PBD No actualizada) o (PBD Actualizada con el flag inactivo)
      SELECT count(1) INTO n_cont_inst
      FROM sales.int_negocio_instancia i,vtatabslcfac f, solot s
      where i.instancia = 'PROYECTO DE VENTA' and i.idinstancia= f.numslc
      and f.numslc = s.numslc and f.idsolucion = 182 and s.codsolot=  an_codsolot;
      SELECT count(1) INTO n_cont_cp
      FROM operacion.siac_instancia i, solot s
      where i.Tipo_Postventa in (select b.descripcion from tipopedd a, opedd b
      where a.tipopedd=b.tipopedd and a.abrev='OPEGENRESSIAC' and b.codigon_aux=1) AND I.TIPO_INSTANCIA='SOT'
      and i.instancia=s.codsolot and i.instancia= an_codsolot;
      if n_cont_cp>0 or n_cont_inst>0 then
        RETURN 1;--SISACT
      else
        return 0;--SGA
      end if;
    elsif an_codigo>0 and n_flag_ven_sql=1 then--PBD Actualizada
      BEGIN
        EXECUTE IMMEDIATE v_ven_sql
          INTO n_retorno
          USING an_codsolot;
        return n_retorno;--Variable
      EXCEPTION
      WHEN OTHERS THEN
        return 0;--SGA
      END;
    else
        return 0;--SGA
    end if;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN 0;--SGA
  end;
  --Fin 10.0

  --Inicio 5.0
  procedure p_instala_srv_adic(an_codsolot in number,av_valores_cab in varchar2,
       an_error out number,av_error out varchar2) is
    n_coid number;
    n_customer_id number;
    n_resultado number;
    v_mensaje varchar2(400);
    error_general EXCEPTION;
  BEGIN
    select  b.cod_id,b.customer_id into n_coid,n_customer_id
    from  solot b
    where codsolot= an_codsolot;
    if av_valores_cab is not null then
      p_reg_log(null,n_customer_id,NULL,an_codsolot,FND_IDINTERFACE_STB,null,av_valores_cab);
    end if;
    --TIM.PKG_CATALOGO_SERVICIOS.REG_SERV_HFC@DBL_BSCS_BF( n_coid, null,
--       v_tiporeg,null,n_idproducto,av_valores_cab,user,n_resultado,v_mensaje);
    if n_resultado<0 then
      RAISE error_general;
    end if;
   EXCEPTION
     when error_general  then
       an_Error:=n_resultado;
       av_error:=v_mensaje;
       p_reg_log(null,n_customer_id,NULL,an_codsolot,null,an_Error,av_error);
       raise_application_error(-20001, av_error);
     WHEN OTHERS THEN
       av_error:='Error Servicios Adicionales: ' || sqlerrm;
       an_Error:=sqlcode;
       p_reg_log(null,n_customer_id,NULL,an_codsolot,null,an_Error,av_error);
       raise_application_error(-20001,av_error);
  End;

procedure p_alinear_res_bscs(an_codsolot in number, an_error out integer, av_error out varchar2)
 IS
  n_cod_id integer;
  n_customer_id integer;--10.0
  error_general EXCEPTION;
  n_error integer;
  v_error varchar2(200);
  n_cont number;
  ARR_AREGLO TIM.PP021_VENTA_HFC.ARR_SERV_HFC2@DBL_BSCS_BF;

CURSOR cur_srv IS
  select tip_interfase,id_producto,id_producto_padre,valores from OPERACION.TRS_INTERFACE_IW WHERE COD_ID=n_cod_id;
  BEGIN
    --10.0
    select cod_id,customer_id into n_cod_id,n_customer_id from solot where codsolot=an_codsolot;
    if n_customer_id is null then
      n_error:=-3;
      v_error:='La SOT no tiene asignado Customer_id favor reportar el caso a ATU.';
      RAISE error_general;
    end if;
    --10.0
    n_cont:=1;
    for c_s in cur_srv loop
      ARR_AREGLO(n_cont).tipo_serv:=c_s.tip_interfase;
      ARR_AREGLO(n_cont).prod_id:=c_s.id_producto;
      ARR_AREGLO(n_cont).prod_id_padre:=c_s.id_producto_padre;
      ARR_AREGLO(n_cont).valores:=c_s.valores;
      n_cont:=n_cont+1;
      p_reg_log(null,null,NULL,an_codsolot,null,0,c_s.valores,n_cod_id,'Alinear Información BSCS');--10.0
    end loop;
    TIM.PP021_VENTA_HFC.SP_RECREAR_RESERVA@DBL_BSCS_BF(n_cod_id,ARR_AREGLO,an_codsolot,n_error,v_error);    if n_error<0 then
      RAISE error_general;
    end if;
  EXCEPTION
    WHEN error_general THEN
      an_Error:=n_error ;
      av_error:='Error SGA-BSCS: ' || v_error;--10.0
      p_reg_log(null,null,NULL,an_codsolot,null,an_error,av_error,n_cod_id,'Alinear Información BSCS');--10.0
      raise_application_error(-20001, av_error);
    WHEN OTHERS THEN
      av_error:= 'Error Alinear Reserva : ' || SQLERRM;
      an_error:=sqlcode;
      p_reg_log(null,null,NULL,an_codsolot,null,an_error,av_error,n_cod_id,'Alinear Información BSCS');--10.0
      raise_application_error(-20001, av_error);
END;

procedure p_regenera_prov_res(an_codsolot in number,an_error out integer,av_error out varchar2)
 IS
  n_cod_id integer;
  error_general EXCEPTION;
  n_error integer;
  v_error varchar2(200);
  n_cont_trs number;--10.0
  n_customer_id number;--10.0
  n_idtrs number;--10.0
  BEGIN
    --Inicio 10.0
    select cod_id,customer_id into n_cod_id,n_customer_id from solot where codsolot=an_codsolot;
    if n_customer_id is null then
      n_error:=-3;
      v_error:='La SOT no tiene asignado Customer_id favor reportar el caso a ATU.';
      RAISE error_general;
    end if;
    select count(1) into n_cont_trs from operacion.trs_interface_iw where codsolot=an_codsolot;
    if n_cont_trs = 0 then
      n_error:=-2;
      v_error:='Opción invalida. Actualmente no tiene ninguna reserva generada.';
      RAISE error_general;
    end if;
    p_reg_log(null,null,null,an_codsolot,null,0,'Regenera Reserva CO_ID: ' || to_char(n_cod_id),n_cod_id,'Regenera Reserva');
    begin
      select a.idtrs into n_idtrs from OPERACION.TRS_INTERFACE_IW a where a.codsolot= an_codsolot and tip_interfase='INT' and rownum=1;
      p_actualiza_valores(n_idtrs,'ACTIVATION_CODE_EXPIRATION_DATE',null,n_error,v_error);--10 Refrescar el codigo de activacion
      if n_error<0 then
        RAISE error_general;
      end if;
    exception
      when no_data_found then
        n_idtrs := null;
    end;
    commit;
    --Fin 10.0

    TIM.PP021_VENTA_HFC.SP_RESERVA_SERV@DBL_BSCS_BF(n_cod_id,null,n_error,v_error);
    if n_error<0 then
      RAISE error_general;
    end if;
  EXCEPTION
    WHEN error_general THEN
      an_Error:=n_error;
      av_error:='Error Procedimiento Regenera Provisión : ' ||v_error ||' - '|| to_char(n_idtrs);
      p_reg_log(null,null,NULL,an_codsolot,null,an_error,av_error,n_cod_id,'Regenera Reserva');--10
      raise_application_error(-20001, av_error);
    WHEN OTHERS THEN
      av_error:= 'Error Regenera Provisión BSCS : ' || SQLERRM;
      an_error:=sqlcode;
      p_reg_log(null,null,NULL,an_codsolot,null,an_error,av_error,n_cod_id,'Regenera Reserva');--10
      raise_application_error(-20001, av_error);
END;


procedure p_relanzar_inst(an_codsolot in number,an_idtrs in number, av_tip_interfase in varchar2,av_valores in varchar2,
     an_error out integer,av_error out varchar2)
 IS
  n_cod_id number;
  error_general EXCEPTION;
  n_error integer;
  v_error varchar2(200);
  n_customer_id number;--12.0
  v_valores varchar2(200);--13.0
  n_idproducto number;--13.0
  v_tip_interfase operacion.trs_interface_iw.tip_interfase%type;--13.0
  v_codcli operacion.solot.codcli%type;--13.0
  n_id_interfase number;--13.0
  BEGIN
    select cod_id,customer_id,codcli into n_cod_id,n_customer_id,v_codcli from solot where codsolot=an_codsolot;
    --15.0
    update operacion.trs_interface_iw
    set modelo= (SELECT v.modeloequitw FROM insprd p,  vtaequcom v
    WHERE p.pid =operacion.trs_interface_iw.pidsga AND p.codequcom = v.codequcom
    AND p.codequcom is not null)
    where  tip_interfase='CTV' and codsolot=an_codsolot and modelo is null;

    select id_interfase,id_producto,
    decode(tip_interfase,'INT',mac_address,'TLF',mac_address||'|1|'|| modelo,
    'CTV',mac_address||'|'|| modelo ||'|'||unit_address||'|FALSE'),tip_interfase--ini 20.0
    into n_id_interfase,n_idproducto,v_valores,v_tip_interfase--fin 20.0
    from operacion.trs_interface_iw where idtrs=an_idtrs;--13.0

    p_reg_log(v_codcli,n_customer_id,an_idtrs,an_codsolot,n_id_interfase,null,v_valores,n_cod_id,'Relanzar Instalación');--13.0
    TIM.PP021_VENTA_HFC.SP_RELANZA_INSTALACION@DBL_BSCS_BF(n_cod_id,v_tip_interfase,n_idproducto,v_valores,n_error,v_error);--13.0
    if n_error<0 then
      RAISE error_general;
    end if;
  EXCEPTION
    WHEN error_general THEN
      an_Error:=n_error;
      av_error:='Error Relanzar Instalación validar SGA: ' ||v_error;--15.0
      p_reg_log(null,n_customer_id,NULL,an_codsolot,null,an_error,av_error,n_cod_id,'Relanzar Instalación');--12.0
      raise_application_error(-20001, av_error);
    WHEN OTHERS THEN
      av_error:= 'Error Instalar Nuevamente : ' || SQLERRM;
      an_error:=sqlcode;
      p_reg_log(null,n_customer_id,NULL,an_codsolot,null,an_error,av_error,n_cod_id,'Relanzar Instalación');--12.0
      raise_application_error(-20001, av_error);
END;

procedure p_gen_cargo_traslado(a_idtareawf in number,a_idwf in number,
     a_tarea in number,a_tareadef in number) is

  n_codsolot  solot.codsolot%type;
  v_codocc OPERACION.opedd.codigoc%type;
  n_customer_id number;
  n_numcuo number;
  n_tiptra number;
  n_monto decimal(10,2);
  n_error number;
  v_error varchar2(300);
  error_general exception;
  BEGIN
    select a.codsolot,b.customer_id,b.tiptra,b.cargo
    into n_codsolot,n_customer_id, n_tiptra,n_monto
    from wf a, solot b
    where a.idwf=a_idwf and a.codsolot=b.codsolot;
    if n_customer_id is null then
       p_reg_log(null,null,NULL,n_codsolot,null,-1,'La SOT no tiene Customer_id.');
    end if;
    begin
      select a.codigoc,a.codigon into v_codocc,n_numcuo from opedd a, tipopedd b
      where a.tipopedd=b.tipopedd
      and b.abrev='TIPOCARGOTRASLADOBSCS' and a.codigon=n_tiptra;
    exception
      when no_data_found then
        v_codocc := '2091';
        n_numcuo := '1';
    end;
    p_reg_log(null,n_customer_id,null,n_codsolot,null,0,v_codocc);
    if n_monto>0 then
      TIM.PP005_SIAC_TRX.SP_INSERT_OCC@DBL_BSCS_BF(n_customer_id,v_codocc,to_char(sysdate,'yyyymmdd'),n_numcuo,n_monto,'SGA',n_error);
      if n_error<0 then
        RAISE error_general;
      end if;
    end if;
  EXCEPTION
    WHEN error_general THEN
      v_error:='Error al generar OCC en BSCS';
      p_reg_log(null,null,NULL,n_codsolot,null,n_error,v_error);
      raise_application_error(-20001, v_error);
    WHEN OTHERS THEN
      v_error:= 'Error Generar Cargo : ' || SQLERRM;
      n_error:=sqlcode;
      p_reg_log(null,null,NULL,n_codsolot,null,n_error,v_error);
      raise_application_error(-20001, v_error);
End;

procedure  p_consulta_estado_prov(an_codsolot in number,av_proceso in varchar2,an_error out integer,av_error out varchar2) is
  n_customer_id number;
  n_cod_id number;
  n_error number;
  v_error varchar2(4000);--13.0
  v_trama varchar2(4000);
  error_general exception;
  n_cont number;
  v_cadena varchar2(4000);
  n_idproducto number;
  v_tip_interface  varchar2(30);
  v_estado_iw OPERACION.TRS_INTERFACE_IW.ESTADO_IW%type;
  v_estado_bscs OPERACION.TRS_INTERFACE_IW.ESTADO_BSCS%type;
  v_trs_prov_bscs OPERACION.TRS_INTERFACE_IW.TRS_PROV_BSCS%type;
  v_valores varchar2(4000);
  BEGIN
    update OPERACION.TRS_INTERFACE_IW set TRS_PROV_BSCS=null,ESTADO_BSCS=null,ESTADO_IW=null
    where codsolot=an_codsolot;
    select customer_id,cod_id into n_customer_id, n_cod_id
    from solot where codsolot=an_codsolot;

    TIM.PP021_VENTA_HFC.SP_ESTADO_PROV@DBL_BSCS_BF(n_cod_id,v_trama,n_error,v_error);
    if v_trama is null or v_trama='' then--6.0
      return;
    end if;
    if n_error<0 then
      RAISE error_general;
    end if;
    n_cont:=1;
    v_cadena := f_cadena(v_trama,chr(38),n_cont);
    while (v_cadena is not null) loop
      begin
        v_tip_interface:= f_cadena(v_cadena,chr(47),2);
        n_idproducto:= to_number(f_cadena(v_cadena,chr(47),3));
        if not v_tip_interface='CLI' then
          v_trs_prov_bscs:=trim(f_cadena(v_cadena,chr(47),1));
          v_estado_bscs:= f_cadena(v_cadena,chr(47),4);
          v_estado_iw:= f_cadena(v_cadena,chr(47),5);
          v_valores:= f_cadena(v_cadena,chr(47),6);
          update OPERACION.TRS_INTERFACE_IW set TRS_PROV_BSCS=v_trs_prov_bscs,ESTADO_BSCS=v_estado_bscs,ESTADO_IW=v_estado_iw
          where codsolot=an_codsolot and ID_PRODUCTO=n_idproducto
          and TIP_INTERFASE=v_tip_interface and v_trs_prov_bscs=av_proceso;
          p_reg_log(null,n_idproducto,null,an_codsolot,null,null,v_valores);
        end if;
        n_cont:=n_cont+1;
        v_cadena := f_cadena(v_trama,chr(38),n_cont);
      end;
    end loop;
  EXCEPTION
    WHEN error_general THEN
      av_error:='Error al consultar BSCS:' || v_error ;
      an_error:=n_error;
      p_reg_log(null,null,NULL,an_codsolot,null,n_error,av_error);
      raise_application_error(-20001, av_error);
    WHEN OTHERS THEN
      av_error:= 'Error consultar BSCS : ' || SQLERRM;
      an_error:=sqlcode;
      p_reg_log(null,null,NULL,an_codsolot,null,an_error,av_error);
      raise_application_error(-20001, av_error);
End;

procedure  p_consulta_estado_prov2(an_codsolot in number,av_proceso in varchar2,an_error out integer,av_error out varchar2) is
--13.0
BEGIN
  null;
End;

procedure  p_consulta_estado_prov3(an_codsolot in number,av_trama out varchar2,an_error out integer,av_error out varchar2) is
  n_customer_id number;
  n_cod_id number;
  n_error number;
  v_error varchar2(4000);--13.0
  error_general exception;
  BEGIN
    select customer_id,cod_id into n_customer_id, n_cod_id
    from solot where codsolot=an_codsolot;

    TIM.PP021_VENTA_HFC.SP_ESTADO_PROV@DBL_BSCS_BF(n_cod_id,av_trama,n_error,v_error);
    if av_trama is null or av_trama='' then--14.0
      return;
    end if;
    if n_error<0 then
      RAISE error_general;
    end if;
  EXCEPTION
    WHEN error_general THEN
      av_error:='Error al consultar BSCS :' || v_error ;--13.0
      an_error:=n_error;
      p_reg_log(null,null,NULL,an_codsolot,null,n_error,av_error);
      raise_application_error(-20001, av_error);
    WHEN OTHERS THEN
      av_error:= 'Error consultar BSCS : ' || SQLERRM;
      an_error:=sqlcode;
      p_reg_log(null,null,NULL,an_codsolot,null,an_error,av_error);
      raise_application_error(-20001, av_error);
End;
--6.0
procedure  p_consulta_estado_prov4(an_codsolot in number,av_action_id in varchar2,an_id_producto in number,av_tipo_srv in varchar2, av_trama out varchar2,an_error out integer,av_error out varchar2) is
  n_customer_id number;
  n_cod_id number;
  n_error number;
  v_error varchar2(4000);--13.0
  error_general exception;
  BEGIN
    select customer_id,cod_id into n_customer_id, n_cod_id
    from solot where codsolot=an_codsolot;

    TIM.PP021_VENTA_HFC.SP_ESTADO_PROV_HFC@DBL_BSCS_BF(n_cod_id,av_action_id,an_id_producto,av_tipo_srv,av_trama,n_error,v_error);
    if av_trama is null or av_trama='' then--14.0
      return;
    end if;
    if n_error<0 then
      RAISE error_general;
    end if;
  EXCEPTION
    WHEN error_general THEN
      av_error:='Error al_consultar BSCS:' || v_error ;--13.0
      an_error:=n_error;
      p_reg_log(null,null,NULL,an_codsolot,null,n_error,av_error);
      raise_application_error(-20001, av_error);
    WHEN OTHERS THEN
      av_error:= 'Error consultar BSCS : ' || SQLERRM;
      an_error:=sqlcode;
      p_reg_log(null,null,NULL,an_codsolot,null,an_error,av_error);
      raise_application_error(-20001, av_error);
End;
--Inicio 7.0
procedure  p_gen_reserva_shell(an_error out integer,av_error out varchar2) is
  n_customer_id number;
  n_idwf number;
  n_cod_id number;
  n_error number;
  n_cont_trs number;
  v_error varchar2(300);
  n_seq number;
  error_general exception;
  cursor c_sot is
  select a.codsolot,a.cod_id,b.idwf from solot a,wf b
  where a.codsolot=b.codsolot and b.valido=1
  and a.estsol in (select o.codigon from operacion.opedd o where o.tipopedd=1244) and a.cod_id is not null and a.tiptra=658;
  Cursor cur_email is
  SELECT a.DESCRIPCION email
   FROM  opedd A, TIPOPEDD B where A.tipopedd =B.TIPOPEDD
   and B.ABREV='OPECORRIWRESACT';
BEGIN
  for c_s in c_sot loop
    select count(1) into n_cont_trs from  operacion.trs_interface_iw--6.0
    where codsolot =c_s.codsolot;
    if n_cont_trs=0 then
      p_gen_reserva_iw(null,c_s.idwf,null,null);--reserva
      begin  --Activacion Contrato
        WEBSERVICE.PQ_WS_HFC.P_ACT_CONTRATO(c_s.cod_id,n_error,v_error);
        IF n_error < 0 THEN
          v_error := 'Error Activación Contrato CO_ID  ' || to_char(c_s.cod_id) || ' : ' ||v_error;
          RAISE error_general;
          for c_e in cur_email loop
            --Logica para poder registrar los correos enviados.
            select SQ_COLA_SEND_MAIL_JOB.nextval into n_seq from DUMMY_OPWF;
            insert into cola_send_mail_job(idmail,nombre,subject,destino,cuerpo,flg_env)
            values (n_seq,'CLARO-SGA','ValidacionGeneracionReserva',c_e.email,v_error ,'0');
          end loop;
        END IF;
      end;
      if n_error<0 then
        RAISE error_general;
      end if;
    end if;
  end loop;
End;

procedure  p_act_bscs_ivr(an_codsolot in number,an_error out integer,av_error out varchar2) is
  n_customer_id number;
  n_cod_id number;
  n_error_iw number;
  v_error_iw varchar2(300);
  n_error number;
  v_error varchar2(300);
  v_nroserie varchar2(300);
  v_report varchar2(400);
  v_tipsrv varchar2(10);
  n_id_producto number;
  error_general exception;
  error_iw_getreport exception;
  n_idtransaccion number;
  n_cont_tel number;--10.0
  n_cont_ctv  number;
  BEGIN
    select customer_id,cod_id into n_customer_id, n_cod_id
    from solot where codsolot=an_codsolot;
    p_reg_log(null,n_customer_id,null,an_codsolot,null,null,null,n_cod_id,'Actualiza BSCS IVR');--10.0
    --Obtener informacion del IW
    operacion.pq_iw_ope.P_INF_IW_SGA(an_codsolot,to_char(n_customer_id),2,n_error_iw,v_error_iw);
    commit;
    select max(idtransaccion) into n_idtransaccion from operacion.Trs_Ws_Sga where codsolot=an_codsolot;
    select reportobjoutput into v_report from operacion.trs_ws_sga where idtransaccion=n_idtransaccion;
    if v_report is null then
      raise error_iw_getreport;
    end if;
    --INT
    select idproducto,macaddress,'INT' into n_id_producto,v_nroserie,v_tipsrv
    from operacion.iw_docsis where idtransaccion=n_idtransaccion;
    TIM.pp021_venta_hfc.sp_inst_equipo_ivr@DBL_BSCS_BF(n_cod_id,v_tipsrv,n_id_producto,v_nroserie,n_error,v_error);
    if n_error<0 then
      v_error:=v_tipsrv||' INT: '||v_error;--10.0
      RAISE error_general;
    end if;
    --TLF
    select count(1) into n_cont_tel from operacion.iw_packetcable where idtransaccion=n_idtransaccion;--10.0
    if n_cont_tel=1 then--10.0
      select idproducto,macaddress||';1;'||mtamodel,'TLF' into n_id_producto,v_nroserie,v_tipsrv
      from operacion.iw_packetcable where idtransaccion=n_idtransaccion;
      TIM.pp021_venta_hfc.sp_inst_equipo_ivr@DBL_BSCS_BF(n_cod_id,v_tipsrv,n_id_producto,v_nroserie,n_error,v_error);
      if n_error<0 then
        v_error:=v_tipsrv||' TLF: '||v_error;--10.0
        RAISE error_general;
      end if;
    end if;
  -- INI 23.0
    --CTV
    select count(1) into n_cont_ctv from operacion.iw_dac where idtransaccion = n_idtransaccion;
    if n_cont_ctv > 0 then
      declare
      cursor equipos_ctv is
      select idproducto,
      serialnumber ||';'||convertertype ||';'|| UNITADDRESS ||';'|| 'FALSE' || '|' ||
      serialnumber ||';'||convertertype ||';'|| UNITADDRESS ||';'|| 'FALSE' nroserie  /*into n_id_producto,v_nroserie,v_tipsrv*/
      from operacion.iw_dac where idtransaccion=n_idtransaccion;
      begin
        for c in equipos_ctv loop
           TIM.pp021_venta_hfc.sp_inst_equipo_ivr@DBL_BSCS_BF(n_cod_id,'CTV',c.idproducto,c.nroserie,n_error,v_error);
           if n_error<0 then
              v_error:=v_tipsrv||' CTV: '||v_error;
              RAISE error_general;
           end if;
        end loop;
      end;
    end if;
  -- FIN 23.0
  EXCEPTION
    WHEN error_general THEN
      av_error:='Error al actualizar la informacion en BSCS.' ||' '|| v_error;
      an_Error:=n_error;
      p_reg_log(n_customer_id,null,NULL,an_codsolot,null,n_error,av_error,n_cod_id,'Actualiza BSCS IVR');--10.0
--      raise_application_error(-20001, av_error);  19.0
    WHEN error_iw_getreport THEN
      av_error:='Error al obtener la informacion del GetReport : ' ||v_error_iw;
      an_Error:=-19;
      p_reg_log(n_customer_id,null,NULL,an_codsolot,null,n_error_iw,av_error,n_cod_id,'Actualiza BSCS IVR');--10.0
--      raise_application_error(-20001, av_error);  19.0
    WHEN OTHERS THEN
      av_error:= 'Error actualizar la informacion en BSCS : ' || SQLERRM;
      an_Error:=sqlcode;
      p_reg_log(n_customer_id,null,NULL,an_codsolot,null,an_Error,av_error,n_cod_id,'Actualiza BSCS IVR');--10.0
--      raise_application_error(-20001, av_error);  19.0
End;





procedure  p_manto_stb_mat(an_codsolot in number,an_id_producto in number,av_comando in varchar2,an_error out integer,av_error out varchar2) is
  n_customer_id number;
  n_cod_id number;
  n_error number;
  v_error varchar2(300);
  error_general exception;
  BEGIN
    select customer_id,cod_id into n_customer_id, n_cod_id
    from solot where codsolot=an_codsolot;
    TIM.pp021_venta_hfc.sp_mtnto_deco_mta@DBL_BSCS_BF(n_cod_id,an_id_producto,av_comando,n_error,v_error);
    if n_error<0 then
      RAISE error_general;
    end if;
  EXCEPTION
    WHEN error_general THEN
      av_error:='Error al enviar el comando de mantenimiento.' ||' '|| v_error;
      an_Error:=n_error;
      p_reg_log(n_customer_id,null,NULL,an_codsolot,null,n_error,av_error);
      raise_application_error(-20001, av_error);
    WHEN OTHERS THEN
      av_error:= 'Error envio comando de Mantenimiento : ' || SQLERRM;
      an_Error:=sqlcode;
      p_reg_log(n_customer_id,null,NULL,an_codsolot,null,an_Error,av_error);
      raise_application_error(-20001, av_error);
End;

procedure  p_actualiza_valores(an_idtrs in number,av_atributo in varchar2,av_valor in varchar2,an_error out integer,av_error out varchar2) is
  n_customer_id number;
  v_valores varchar2(400);
  v_valor varchar2(400);
  n_codsolot number;
  v_codcli varchar(10);
  n_id_producto number;
  n_id_interfase number;
  v_activationcode INT_SERVICIO_INTRAWAY.ID_ACTIVACION%type;
  BEGIN
    select codsolot into n_codsolot from OPERACION.TRS_INTERFACE_IW where idtrs= an_idtrs;--10.0
    if upper(av_atributo) ='ACTIVATIONCODE' then
      select a.codsolot,a.codcli,a.id_producto,a.id_interfase,b.valor
      into n_codsolot,v_codcli,n_id_producto,n_id_interfase,v_activationcode
      from OPERACION.TRS_INTERFACE_IW a,OPERACION.TRS_INTERFACE_IW_det b
      where a.idtrs=b.idtrs and a.idtrs =an_idtrs and b.atributo = av_atributo;
      v_valor:=f_obt_codact(2,v_codcli,n_id_producto,n_id_interfase,n_codsolot,v_activationcode);
    elsif upper(av_atributo) ='ACTIVATION_CODE_EXPIRATION_DATE' then--10.0
      SELECT TO_CHAR(sysdate + id_valor,'MM/dd/yyyy HH:mm') into v_valor FROM OPERACION.INT_PARAMETRO
      WHERE id_interface = 620
      and id_parametro=upper(av_atributo);
    elsif upper(av_atributo) ='TN' then
      select c.numero into v_valor
      from solotpto a, solot b, inssrv c
      where a.codsolot=b.codsolot and b.codsolot= n_codsolot and a.codinssrv=c.codinssrv and c.tipinssrv=3 and rownum=1;
    else
      v_valor:=av_valor;
    end if;
    update TRS_INTERFACE_IW_DET set valor= v_valor where idtrs=an_idtrs and atributo=av_atributo;
    v_valores:= f_obt_arr_pip(an_idtrs);
    update TRS_INTERFACE_IW set valores= v_valores where idtrs=an_idtrs;
  EXCEPTION
    WHEN OTHERS THEN
      av_error:= 'Error actualizar información de SGA: ' || SQLERRM;
      an_Error:=sqlcode;
      p_reg_log(n_customer_id,null,an_idtrs,null,null,an_Error,av_error,null,'Actualiza Valores');--10.0
      raise_application_error(-20001, av_error);
End;

function f_cadena(ac_cadena in varchar2,an_caracter in varchar2, an_posicion in number)
    return varchar2 is
  -- Ini 32.0
  ls_original  varchar2(32000);
  ls_subcadena varchar2(32000);
  -- Fin 32.0
  li_longitud number;
  j           number;
  p           number;
  li_cont          number;
  li_size_caracter number;
  n_pos number;
  begin
     ls_original := ac_cadena;
     p           := an_posicion;
     j           := 1;
     n_pos :=0;
     li_size_caracter := length(an_caracter);
     li_longitud := length(ls_original);
     FOR li_cont IN 1..li_longitud LOOP
         IF (substr(ls_original,li_cont,li_size_caracter)<> an_caracter) THEN
            IF j = p THEN
              if n_pos=0 then
                ls_subcadena := substr(ls_original,1,li_cont);
              else
                ls_subcadena := substr(ls_original,n_pos + li_size_caracter,li_cont-n_pos+1-li_size_caracter);
              end if;
            END IF;
         ELSE
            n_pos:=li_cont;
            j := j +1;
         END IF;
     END LOOP;
     return ls_subcadena;
  end;

--Fin 5.0
--Inicio 8.0
procedure P_act_info_sga_bscs(an_customer_id in number,an_cod_id in number,an_cod_err_bscs in number,av_error in varchar2,an_cod_error out number,av_msg_error out varchar2) is
BEGIN
  p_reg_log(null,an_customer_id,null,null,null,an_cod_err_bscs,av_error,an_cod_id,'Respuesta Proceso Reserva');--10.0
  an_cod_error:= 0;
  av_msg_error:='Exito';
End;
--12.0
procedure P_desactivacion_contrato(an_cod_id in number) is
  n_request_id number;
  n_reason number;
  v_username varchar2(30);
BEGIN
  select VALOR INTO n_reason from constante where constante='REASON';
  select VALOR INTO v_username from constante where constante='USERSIACP';
  TIM111_PKG_ACCIONES.SP_CONTRACT_DEACTIVATION@DBL_BSCS_BF(an_cod_id,n_reason,v_username,n_request_id);
  p_reg_log(null,null,n_request_id,null,null,n_reason,v_username,an_cod_id,'Desactivar Contrato');
End;

procedure P_eliminar_reserva(an_cod_id in number,av_tiposerv in varchar2,an_idproducto in number,an_error out number,av_error out varchar2) is
  n_error number;
  v_error varchar2(400);
  error_general EXCEPTION;
BEGIN
  p_reg_log(null,null,NULL,null,null,an_idproducto,av_tiposerv,an_cod_id,'Eliminar Reserva');
  TIM.PP021_VENTA_HFC.SP_BORRA_RESERVA@DBL_BSCS_BF(an_cod_id,av_tiposerv,an_idproducto,an_error,av_error);
  IF n_error < 0 THEN
    RAISE error_general;
  END IF;
  EXCEPTION
    WHEN error_general THEN
      av_error := v_error;
      an_Error:=n_error;
      p_reg_log(null,null,NULL,null,null,an_error,av_error,an_cod_id,'Eliminar Reserva');
      raise_application_error(-20001, av_error);
    WHEN OTHERS THEN
      av_error:= 'Error Eliminar Reserva: ' || SQLERRM;
      an_Error:=sqlcode;
      p_reg_log(null,null,NULL,null,null,an_Error,av_error,an_cod_id,'Eliminar Reserva');
      raise_application_error(-20001, av_error);
End;


procedure P_liberar_reserva(an_cod_id in number,av_tiposerv in varchar2,an_idproducto in number,an_error out number,av_error out varchar2) is
  n_error number;
  v_error varchar2(400);
  error_general EXCEPTION;
BEGIN
  p_reg_log(null,null,NULL,null,null,an_idproducto,av_tiposerv,an_cod_id,'Liberar Reserva');
  TIM.PP021_VENTA_HFC.SP_LIBERA_RESERVA@DBL_BSCS_BF(an_cod_id,av_tiposerv,an_idproducto,n_error,v_error);
  IF n_error < 0 THEN
    v_error := 'Error Liberar Reserva: ' || v_error;
    RAISE error_general;
  END IF;
  EXCEPTION
    WHEN error_general THEN
      an_Error:=n_error;
      av_error := v_error;
      p_reg_log(null,null,NULL,null,null,an_error,av_error,an_cod_id,'Liberar Reserva');
      raise_application_error(-20001, av_error);
    WHEN OTHERS THEN
      av_error:= 'Error Liberar Reserva: ' || SQLERRM;
      an_Error:=sqlcode;
      p_reg_log(null,null,NULL,null,null,an_Error,av_error,an_cod_id,'Liberar Reserva');
      raise_application_error(-20001, av_error);
End;
--14.0
procedure P_asig_numero_porta(a_idtareawf in number,
     a_idwf      in number,
     a_tarea     in number,
     a_tareadef  in number) is
  n_error number;
  v_error varchar2(400);
  error_general EXCEPTION;
v_mensaje varchar2(300);
n_valtel number;
n_idwf number;
n_codsolot number;
cursor c_s is
select a.codsolot,b.codnumtel,c.numero,a.estsol from solot a,  reservatel b,numtel c
where a.numslc=b.numslc and b.codnumtel=c.codnumtel and a.codsolot=n_codsolot;
begin
  select codsolot into n_codsolot from wf where idwf=a_idwf;
  for c_a in c_s loop
    insert into tareawfseg(idtareawf,observacion)
    values(a_idtareawf,'Se asigna el número : '||  c_a.numero);
    CUSPER.PQ_PROCESO_NINTEX.p_asig_numtel(c_a.codsolot, c_a.numero, v_mensaje);
  end loop;
end;
--15.0
procedure p_cambio_estado_sot(a_idtareawf in number,a_idwf in number,


a_tarea in number,a_tareadef in number,a_tipesttar in number,a_esttarea in number,


a_mottarchg in number,a_fecini in date,a_fecfin in date)  is


l_cont number;
l_codsolot solot.codsolot%type;
n_estsol number;
n_estsol_old number;
n_tiptra number;
v_tipsrv varchar2(4);--17.0
l_porta      number; --<28.0>

BEGIN
  if a_tipesttar = 4 then
    select codsolot into l_codsolot from wf where idwf = a_idwf;
    -- ini 28.0
    select count(1)
      into l_porta
      from solot s, vtatabslcfac f
     where s.numslc = f.numslc
       and f.flg_portable = 1
       and s.codsolot = l_codsolot;
    -- fin 28.0
    select tiptra,estsol,tipsrv into n_tiptra,n_estsol_old,v_tipsrv from solot where codsolot=l_codsolot;--17.0
    -- ini 28.0
    if l_porta = 1 then
      select count(1)
      into l_cont
      from opedd a, tipopedd b
       where a.tipopedd = b.tipopedd
       and a.codigoc = v_tipsrv --17.0
       and b.abrev = 'OPECTRLCAMESTSOT'
       and a.codigon = n_tiptra;
      if l_cont = 1 then
        select a.codigon_aux
          into n_estsol
          from opedd a, tipopedd b
         where a.tipopedd = b.tipopedd
           and b.abrev = 'OPECTRLCAMESTSOT'
           and a.codigoc = v_tipsrv --17.0
           and a.codigon = n_tiptra;

        pq_solot.p_chg_estado_solot(l_codsolot,
                      n_estsol,
                      n_estsol_old,
                      'Cambio estado Automatico.');
      end if;
    end if;
    -- fin 28.0
  end if;
end;
--Inicio 19.0
procedure p_inst_equipo_ivr(an_codsolot in number,av_tiposerv in varchar2,an_idproducto in number,av_nroserie in varchar2, an_error out number,av_error out varchar2) is
  n_error number;
  v_error varchar2(400);
  n_cod_id number;
  error_general EXCEPTION;
BEGIN
  select cod_id into n_cod_id from solot where codsolot=an_codsolot;
  p_reg_log(null,null,NULL,null,null,an_idproducto,av_tiposerv,n_cod_id,'Actualiza BSCS IVR');
  TIM.pp021_venta_hfc.sp_inst_equipo_ivr@DBL_BSCS_BF(n_cod_id,av_tiposerv,an_idproducto,av_nroserie,n_error,v_error);
  IF n_error < 0 THEN
    RAISE error_general;
  END IF;
  EXCEPTION
    WHEN error_general THEN
      av_error:='Error al actualizar la informacion en BSCS.' ||' '|| v_error;
      an_Error:=n_error;
      p_reg_log(null,null,NULL,an_codsolot,null,n_error,av_error,n_cod_id,'Actualiza BSCS IVR');
    WHEN OTHERS THEN
      av_error:= 'Error actualizar la informacion en BSCS : ' || SQLERRM;
      an_Error:=sqlcode;
      p_reg_log(null,null,NULL,an_codsolot,null,an_Error,av_error,n_cod_id,'Actualiza BSCS IVR');
End;

procedure p_gen_cambio_direccion_iw(an_codsolot in number)
/*'**************************************************************************************************************
Nombre SP : p_gen_cambio_direccion_iw
Propósito : Invoca la tarea Gestión de Recursos IW para que el usuario realice el cambio de dirección en la plataforma IW
Input : an_codsolot   - Código de la SOT
'*************************************************************************************************************'*/
IS
  l_sotorigen solot.codsolot%type;
  L_CENT               NUMBER;
  l_mensj              VARCHAR2(1000);
  v_error              VARCHAR2(1000);
  L_PLANO              VTASUCCLI.IDPLANO%TYPE;
  l_nomhub             ope_hub.nombre%type;
  l_desccmts           ope_cmts.desccmts%type;
  l_abrebhub           ope_hub.abrevhub%type;
  v_id_interfaz         number;
  v_id_lote             number;
  a_id_estado           varchar2(1);-- :='2';
  a_proceso             number;-- := 17;
  v_cabecera_xml        int_interface.cabecera_xml%type;
  v_asincrono           int_interface.asincrono%type;
  v_transaccion         int_interface.transaccion%type;
  l_activationcode      operacion.trs_interface_iw_det.valor%type;
  l_Serv                operacion.trs_interface_iw_det.valor%type;
  l_cantpcs             operacion.trs_interface_iw_det.valor%type;
  l_idispcrm            operacion.trs_interface_iw_det.valor%type;
  l_CmsCrmId            operacion.trs_interface_iw_det.valor%type;
  l_ispMTACrmId         operacion.trs_interface_iw_det.valor%type;
  l_Provisioning        operacion.trs_interface_iw_det.valor%type;
  l_defaultProductCRMId operacion.trs_interface_iw_det.valor%type;
  l_channelMapCRMId     operacion.trs_interface_iw_det.valor%type;
  varx varchar2(3000);
  vary varchar2(3000);
  --------------------------------------------
  ln_tiptra   NUMBER;
  ln_estsol12 NUMBER;
  ln_estsol29 NUMBER;
  ls_empresa  VARCHAR2(3);
  ln_tipo     NUMBER;
  --------------------------------------------
  CURSOR c_cliente is
  select codcli, codsolot, customer_id
  from   operacion.solot
  where  codsolot = an_codsolot;
  CURSOR c_trs_int is
  select id_interfase, idtrs, id_producto, pidsga, codinssrv,id_producto_padre
  from   operacion.trs_interface_iw
  where  codsolot = l_sotorigen;
  CURSOR c_msg is
  select codsolot, id_interfase, id_estado, id_producto, id_lote
  from   int_mensaje_intraway
  where  id_error is null
  and    codsolot = an_codsolot;
BEGIN
--VARIABLES CONSTANTES--------
select tipopedd into ln_tipo from operacion.tipopedd where abrev='TRASEXT';
select codigon into a_proceso from opedd a where abreviacion ='PROCESO' and tipopedd=ln_tipo;--17
select codigon into ln_tiptra from opedd a where abreviacion ='TIPTRA' and tipopedd=ln_tipo;--658
select codigon into ln_estsol12 from opedd a where abreviacion ='ESTSOL12' and tipopedd=ln_tipo;
select codigon into ln_estsol29 from opedd a where abreviacion ='ESTSOL29' and tipopedd=ln_tipo;
select codigoc into a_id_estado from opedd a where abreviacion ='ESTADO' and tipopedd=ln_tipo;--2
select codigoc into ls_empresa from opedd a where abreviacion ='EMPRESA' and tipopedd=ln_tipo;--121
  FOR c_cli in c_cliente LOOP
    BEGIN
      L_CENT  := 0;
      l_mensj := NULL;
      BEGIN
        select distinct l.codsolot into l_sotorigen
        from   operacion.solotpto so, operacion.solotpto ol, operacion.solot l
        where  so.codinssrv_tra = ol.codinssrv and    ol.codsolot      = l.codsolot
        and l.tiptra = ln_tiptra and l.estsol in (ln_estsol12,ln_estsol29) and l.codcli =c_cli.codcli
        and so.codsolot = c_cli.codsolot;
        L_CENT  := 1;
        EXCEPTION
        WHEN TOO_MANY_ROWS THEN
             l_mensj := 'MAS DE UNA SOT DE INSTALACIÓN : '||c_cli.codsolot;
             L_CENT  := 0;
        WHEN NO_DATA_FOUND THEN
             l_mensj := 'SIN SOT DE INSTALACIÓN : '||c_cli.codsolot;
             L_CENT  := 0;
        END;
        IF L_CENT = 1 THEN
          BEGIN
            SELECT DISTINCT C.IDPLANO INTO   L_PLANO
            FROM   operacion.SOLOTPTO P, operacion.INSSRV V,marketing.VTASUCCLI C
            WHERE  P.CODINSSRV = V.CODINSSRV AND    V.CODSUC    = C.CODSUC
            AND    P.CODSOLOT  = c_cli.codsolot;
            SELECT  b.nombre, o.desccmts, b.abrevhub INTO    l_nomhub, l_desccmts, l_abrebhub
            FROM    marketing.vtatabgeoref f, intraway.ope_hub b, intraway.ope_cmts o
            WHERE   f.idhub   = b.idhub AND     f.idcmts  = o.idcmts
            AND     f.idhub   = o.idhub AND     f.estado  = 1 AND     f.idplano = L_PLANO;
            L_CENT := 1;
          EXCEPTION
            WHEN others THEN
              v_error := sqlerrm;
              l_mensj := 'ERROR CON LA CONFIGURACION DEL PLANO. SOT: |'||c_cli.codsolot||'|'||v_error;
              L_CENT  := 0;
          END;
          IF L_CENT = 1 THEN
            FOR c_trs IN c_trs_int LOOP
              BEGIN -- INICIO DE FOR 2
                IF c_trs.ID_INTERFASE = FND_IDINTERFACE_CM THEN --620
                  select valor into l_activationcode from operacion.trs_interface_iw_det where idtrs = c_trs.idtrs and atributo = 'ActivationCode';
                  select valor into l_Serv           from operacion.trs_interface_iw_det where idtrs = c_trs.idtrs and atributo = 'ServicePackageCRMID';
                  select valor into l_cantpcs        from operacion.trs_interface_iw_det where idtrs = c_trs.idtrs and atributo = 'CantCPE';
                  select valor into l_idispcrm       from operacion.trs_interface_iw_det where idtrs = c_trs.idtrs and atributo = 'idISPCRM';
                  /****************************************************************************************************************/
                  select id_interfaz_intraway_s.nextval,int_lote_proceso_itw.nextval into v_id_interfaz,v_id_lote from dual;
                  select cabecera_xml, asincrono, transaccion into v_cabecera_xml, v_asincrono, v_transaccion
                  from   intraway.int_interface where  id_interface = FND_IDINTERFACE_CM;--620
                  insert into int_mensaje_intraway(id_interfaz,id_sistema,id_conexion,id_empresa,id_interfase,id_estado,id_cliente,
                  id_servicio,id_producto,id_venta,id_producto_padre,id_promotor_padre,id_servicio_padre,id_venta_padre,cabecera_xml,
                  asincrono,id_lote,desc_lote,transaccion,estado,mensaje,fecha_creacion,creado_por,proceso,codsolot,pidsga,codinssrv)
                  values(v_id_interfaz,1,0,ls_empresa,FND_IDINTERFACE_CM,a_id_estado,c_cli.CUSTOMER_ID,1,c_trs.ID_PRODUCTO,0,0,0,0,0,v_cabecera_xml,
                  v_asincrono,v_id_lote,null,v_transaccion,'CARGADO',null,sysdate,user,a_proceso,c_cli.codsolot,c_trs.pidsga,c_trs.codinssrv);
                  insert into int_mensaje_atributo_intraway(id_mensaje_intraway,nombre_atributo,valor_atributo)values(v_id_interfaz,'ActivationCode',l_activationcode);
                  insert into int_mensaje_atributo_intraway(id_mensaje_intraway,nombre_atributo,valor_atributo)values(v_id_interfaz,'ServicePackageCRMID',l_Serv);
                  insert into int_mensaje_atributo_intraway(id_mensaje_intraway,nombre_atributo,valor_atributo)values(v_id_interfaz,'CantCPE',l_cantpcs);
                  insert into int_mensaje_atributo_intraway(id_mensaje_intraway,nombre_atributo,valor_atributo)values(v_id_interfaz,'idISPCRM',l_idispcrm);
                  insert into int_mensaje_atributo_intraway(id_mensaje_intraway,nombre_atributo,valor_atributo)values(v_id_interfaz,'Hub',l_nomhub);
                  insert into int_mensaje_atributo_intraway(id_mensaje_intraway,nombre_atributo,valor_atributo)values(v_id_interfaz,'Nodo',L_PLANO);

                  insert into int_mensaje_atributo_intraway(id_mensaje_intraway, nombre_atributo, valor_atributo)
                  select v_id_interfaz, id_parametro, id_valor from   int_interface_parametro
                  where  id_interface = FND_IDINTERFACE_CM;
                ELSIF c_trs.ID_INTERFASE = FND_IDINTERFACE_MTA THEN
                  select valor into l_activationcode from operacion.trs_interface_iw_det where idtrs = c_trs.idtrs and atributo = 'ActivationCode';
                  select valor into l_CmsCrmId       from operacion.trs_interface_iw_det where idtrs = c_trs.idtrs and atributo = 'CmsCrmId';
                  select valor into l_Provisioning   from operacion.trs_interface_iw_det where idtrs = c_trs.idtrs and atributo = 'Provisioning';
                  select valor into l_ispMTACrmId    from operacion.trs_interface_iw_det where idtrs = c_trs.idtrs and atributo = 'ispMTACrmId';

                  select id_interfaz_intraway_s.nextval,int_lote_proceso_itw.nextval into v_id_interfaz,v_id_lote from dual;
                  select cabecera_xml, asincrono, transaccion into v_cabecera_xml, v_asincrono, v_transaccion
                  from   intraway.int_interface where  id_interface = FND_IDINTERFACE_MTA;--820

                  insert into int_mensaje_intraway(id_interfaz,id_sistema,id_conexion,id_empresa,id_interfase,id_estado,id_cliente,id_servicio,
                  id_producto,id_venta,id_producto_padre,id_promotor_padre,id_servicio_padre,id_venta_padre,cabecera_xml,asincrono,id_lote,
                  desc_lote,transaccion,estado,mensaje,fecha_creacion,creado_por,proceso,codsolot,pidsga)
                  values(v_id_interfaz,1,0,ls_empresa,FND_IDINTERFACE_MTA,a_id_estado,c_cli.CUSTOMER_ID,'20',c_trs.ID_PRODUCTO,0,c_trs.id_producto_padre,
                  0,1,0,v_cabecera_xml,v_asincrono,v_id_lote,null,v_transaccion,'CARGADO',null,sysdate,user,a_proceso,c_cli.codsolot,c_trs.pidsga);

                  insert into int_mensaje_atributo_intraway(id_mensaje_intraway,nombre_atributo,valor_atributo) values(v_id_interfaz,'ActivationCode',l_activationcode);
                  insert into int_mensaje_atributo_intraway(id_mensaje_intraway,nombre_atributo,valor_atributo) values(v_id_interfaz,'ProfileCrmId',l_desccmts);
                  insert into int_mensaje_atributo_intraway(id_mensaje_intraway,nombre_atributo,valor_atributo) values(v_id_interfaz,'CmsCrmId',l_CmsCrmId);
                  insert into int_mensaje_atributo_intraway(id_mensaje_intraway,nombre_atributo,valor_atributo) values(v_id_interfaz,'Hostname',null);
                  insert into int_mensaje_atributo_intraway(id_mensaje_intraway,nombre_atributo,valor_atributo) values(v_id_interfaz,'ProductName',null);
                  insert into int_mensaje_atributo_intraway(id_mensaje_intraway,nombre_atributo,valor_atributo) values(v_id_interfaz,'Provisioning',l_Provisioning);
                  insert into int_mensaje_atributo_intraway(id_mensaje_intraway,nombre_atributo,valor_atributo) values(v_id_interfaz,'ispMTACrmId',l_ispMTACrmId);
                  insert into int_mensaje_atributo_intraway(id_mensaje_intraway,nombre_atributo,valor_atributo) values(v_id_interfaz,'SendToController','FALSE');
                ELSIF c_trs.ID_INTERFASE = FND_IDINTERFACE_STB THEN--2020
                  select valor into l_activationcode      from operacion.trs_interface_iw_det where idtrs = c_trs.idtrs and atributo = 'activationCode';
                  select valor into l_defaultProductCRMId from operacion.trs_interface_iw_det where idtrs = c_trs.idtrs and atributo = 'defaultProductCRMId';
                  select valor into l_channelMapCRMId     from operacion.trs_interface_iw_det where idtrs = c_trs.idtrs and atributo = 'channelMapCRMId';

                  select int_lote_proceso_itw.nextval,id_interfaz_intraway_s.nextval into v_id_lote,v_id_interfaz from dual;
                  select cabecera_xml, asincrono, transaccion into v_cabecera_xml, v_asincrono, v_transaccion
                  from   intraway.int_interface
                  where  id_interface = FND_IDINTERFACE_STB;--2020

                  insert into int_mensaje_intraway(id_interfaz,id_sistema,id_conexion,id_empresa,id_interfase,id_estado,id_cliente,
                  id_servicio,id_producto,id_venta,id_producto_padre,id_promotor_padre,id_servicio_padre,id_venta_padre,cabecera_xml,asincrono,id_lote,
                  desc_lote,transaccion,estado,mensaje,fecha_creacion,creado_por,proceso,codsolot,pidsga,codinssrv)
                  values(v_id_interfaz,1,0,ls_empresa,FND_IDINTERFACE_STB,a_id_estado,c_cli.CUSTOMER_ID,50,c_trs.ID_PRODUCTO,0,0,0,0,0,v_cabecera_xml,v_asincrono,v_id_lote,
                  null,v_transaccion,'CARGADO',null,sysdate,user,a_proceso,c_cli.codsolot,c_trs.pidsga,c_trs.codinssrv);

                  insert into int_mensaje_atributo_intraway (id_mensaje_intraway,nombre_atributo,valor_atributo)values (v_id_interfaz,'activationCode',l_activationcode);
                  insert into int_mensaje_atributo_intraway (id_mensaje_intraway,nombre_atributo,valor_atributo)values (v_id_interfaz,'defaultProductCRMId',l_defaultProductCRMId);
                  insert into int_mensaje_atributo_intraway (id_mensaje_intraway,nombre_atributo,valor_atributo)values (v_id_interfaz,'channelMapCRMId',l_channelMapCRMId);
                  insert into int_mensaje_atributo_intraway (id_mensaje_intraway,nombre_atributo,valor_atributo)values (v_id_interfaz,'sendToController', 'FALSE');
                  insert into int_mensaje_atributo_intraway (id_mensaje_intraway,nombre_atributo,valor_atributo)values (v_id_interfaz,'defaultConfigCRMId', l_abrebhub); --Cambio
                  insert into int_mensaje_atributo_intraway (id_mensaje_intraway,nombre_atributo,valor_atributo)
                  select v_id_interfaz, id_parametro, id_valor from   int_interface_parametro
                  where  id_interface = FND_IDINTERFACE_STB;--2020
                END IF;
              EXCEPTION
                 WHEN others THEN
                   v_error := sqlerrm;
              END;
              END LOOP;
           END IF;
        END IF;
    END;
    commit;
    END LOOP;
    FOR c_m in c_msg LOOP
        PQ_INT_PROCESO_INTRAWAY.procesa_interfaz('SGA',c_m.id_lote,varx,vary);
    END LOOP;
END;

procedure p_gen_traslado_extHFC(an_codsolot in number,an_customerid in number,av_notasdireccion in varchar2,
av_codigo_plano in varchar2,av_direccion in varchar2,av_ubigeo in varchar2,an_error in out number,av_error in out varchar2) is
/*'**********************************************************************************************************
Nombre SP : p_gen_traslado_extHFC
Propósito : Actualiza la direccion de facturación y de traslado de los sistemas de IW y BSCS.
Input : an_codsolot        - Código de la SOT
        an_customerid      - Equivalente del código de cliente en BCCS
        av_codigo_plano    - Codigo de Plano
        av_direccion       - Direccion de facturación
        av_ubigeo          - Código de Ubigeo
        an_error           - codigo de error
        av_error         - mensajes de error
'*************************************************************************************************************'*/
  n_resultado number;
BEGIN
--Actualiza la direccion del esquema IW
  BEGIN
      p_gen_cambio_direccion_iw( an_codsolot);
  EXCEPTION
  WHEN NO_DATA_FOUND THEN
    av_error := 'OPERACION.OPESI_GEN_CAMBIO_DIRECCION_IW - PARAMETROS:'|| TO_CHAR(an_codsolot)||','||TO_CHAR(an_customerid) ||' ERROR:'||SQLERRM;
    an_error   := SQLCODE;
    p_reg_log(null,an_customerid,null,an_codsolot,null,an_error,av_error,null,'Traslado Externo HFC');
  WHEN OTHERS THEN
    av_error := 'OPERACION.OPESI_GEN_CAMBIO_DIRECCION_IW - PARAMETROS:'|| TO_CHAR(an_codsolot)||','||TO_CHAR(an_customerid) ||' ERROR:'||SQLERRM;
    an_error   := SQLCODE;
    p_reg_log(null,an_customerid,null,an_codsolot,null,an_error,av_error,null,'Traslado Externo HFC');
  END;
  BEGIN
     TIM.PP004_SIAC_HFC.SP_CHG_DIRECCION_INSTAL@DBL_BSCS_BF(an_customerid,av_direccion,av_codigo_plano,av_ubigeo,av_notasdireccion,n_resultado );
  EXCEPTION
  WHEN NO_DATA_FOUND THEN
    av_error := 'TIM.PP004_SIAC_HFC.SP_CHG_DIRECCION_INSTAL@DBL_BSCS_BF - PARAMETROS:' ||TO_CHAR(an_customerid)||','||av_direccion||','||av_codigo_plano||','||av_ubigeo||','||av_notasdireccion||','||TO_CHAR(n_resultado) || ' ERROR:'||SQLERRM;
    an_error   := SQLCODE;
    p_reg_log(null,an_customerid,null,an_codsolot,null,an_error,av_error,null,'Traslado Externo HFC');
  WHEN OTHERS THEN
    av_error := 'TIM.PP004_SIAC_HFC.SP_CHG_DIRECCION_INSTAL@DBL_BSCS_BF - PARAMETROS:' ||TO_CHAR(an_customerid)||','||av_direccion||','||av_codigo_plano||','||av_ubigeo||','||av_notasdireccion||','||TO_CHAR(n_resultado) || ' ERROR:'||SQLERRM;
    an_error   := SQLCODE;
    p_reg_log(null,an_customerid,null,an_codsolot,null,an_error,av_error,null,'Traslado Externo HFC');
  END;
  /*DATOS DE ENTRADA:
  P_CUSTOMER_ID      NUMERIC                     Obtenido de request (codigoContrato)
  P_DIRECCION       VARCHAR2                     Obtenido de request (direccion)
  P_CODIGO_PLANO    VARCHAR2(IDPLANO DE solopto) Obtenido de request (codigoPlano)
  P_UBIGEO          VARCHAR2                     Obtenido del request (ubigeo)
  P_NOTAS_DIRECCION VARCHAR2                     Obtenido de request (notaDireccion)*/

--Actualiza la direccion de facturacion del esquema BSCS
  BEGIN
    WEBSERVICE.PQ_WS_HFC.P_TRASLADO_EXT_WS(an_customerid,av_notasdireccion,av_ubigeo,av_direccion,an_error,av_error);
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
    av_error := 'bscs_cambioDireccionPostal_request.xsd - PARAMETROS:'|| to_char(an_customerid)||','||av_notasdireccion||','|| av_ubigeo||','||av_direccion||','||' ERROR:'|| SQLERRM;
    an_error   := SQLCODE;
    p_reg_log(null,an_customerid,null,an_codsolot,null,an_error,av_error,null,'Traslado Externo HFC');
    WHEN OTHERS THEN
    av_error := 'bscs_cambioDireccionPostal_request.xsd - PARAMETROS:'|| to_char(an_customerid)||','||av_notasdireccion||','|| av_ubigeo||','||av_direccion||','||' ERROR:'|| SQLERRM;
    an_error   := SQLCODE;
    p_reg_log(null,an_customerid,null,an_codsolot,null,an_error,av_error,null,'Traslado Externo HFC');
  END;
END;
--fin 19.0
--ini 25.0
procedure p_reg_rsv_dec_adic(a_idtareawf in number,
                                       a_idwf      in number,
                                       a_tarea     in number,
                                       a_tareadef  in number) is

  n_codsolot         solot.codsolot%type;
  n_customer_id      number;
  n_co_id            INTEGER;
  n_codigo_occ       number;
  n_nro_cuotas       number;
  n_monto_occ        number;
  v_remark           VARCHAR2(2000);
  v_sncode           VARCHAR2(100);
  v_spcode           VARCHAR2(100);
  v_cf_serv          VARCHAR2(100);
  n_cod_error        NUMBER;
  v_des_error        VARCHAR2(2000);
  n_cod_error_occ    NUMBER;
  error_general      EXCEPTION;
  ARR_AREGLO         TIM.PP021_VENTA_HFC.ARR_SERV_HFC2@DBL_BSCS_BF;
  n_cont             NUMBER;
  lv_monto_occ       varchar2(20);
  v_codusu           solot.codusu%type;
  l_count            number;
  c_flag_occ         NUMBER; --30.0

CURSOR cur_srv IS
  select ti.mac_address || '|' || ti.modelo || '|' || ti.unit_address || '|' ||'FALSE' as nro_ctv,
                 ti.id_producto,
                 ti.id_producto_padre,
                 ti.tip_interfase
            from operacion.trs_interface_iw ti
           where ti.id_interfase in (620, 2020)
             and ti.codsolot = n_codsolot;


BEGIN
  /*Obtiene valores de la solot*/
  select a.codsolot, b.customer_id, cod_id
    into n_codsolot, n_customer_id, n_co_id
    from wf a, solot b
   where a.codsolot = b.codsolot
     and a.idwf = a_idwf
     and valido = 1;
  /*valores que vienen desde SIAC*/
  select rtrim(xmlagg(xmlelement(n, prueba.sncode || '|')).extract('//text()'), '|'),
         rtrim(xmlagg(xmlelement(n, prueba.spcode || '|')).extract('//text()'), '|'),
         rtrim(xmlagg(xmlelement(n, prueba.cargofijo || '|')).extract('//text()'), '|')
    into v_sncode, v_spcode, v_cf_serv
    from (select s.sncode as sncode,
                 s.spcode as spcode,
                 trim(to_char(s.cargofijo, '999999999.99')) as cargofijo
            from sales.sisact_postventa_det_serv_hfc s
           where s.codsolot = n_codsolot
             and s.idgrupo_principal = '003'
             and s.sncode is not null) prueba;



     select codusu
       into v_codusu
       from solot
      where codsolot = n_codsolot;

     SELECT COUNT(1)
       into l_count
       from tipopedd c, opedd d
      where c.abrev = 'USR_SOAP_DECO'
        and c.tipopedd = d.tipopedd
        and d.abreviacion = 'USR_DECO'
        AND D.CODIGOC = V_CODUSU
        and d.codigon_aux = 1;

    IF substr(v_codusu, -3, length(v_codusu)) = '_DB' or l_count > 0 THEN
      p_reg_log(null,n_customer_id,null,n_codsolot,null,-1,'SOT GENERADO POR EL PROCESO DE WORKAROUND',n_co_id,'GENERACION DE SOT POR WORKAROUND');
      RETURN;
    END IF;


  /*Valores Parametrizados - los de facturacion*/
   select a.codigon
   into n_codigo_occ
   from opedd a, tipopedd b
  where a.tipopedd = b.tipopedd
    and b.abrev = 'HFC_SIAC_DEC_ADICIONAL'
    and a.abreviacion = 'COD_OCC';

  select a.codigon
   into n_nro_cuotas
   from opedd a, tipopedd b
  where a.tipopedd = b.tipopedd
    and b.abrev = 'HFC_SIAC_DEC_ADICIONAL'
    and a.abreviacion = 'NUM_CUOTAS';

  select a.codigoc
   into lv_monto_occ
   from opedd a, tipopedd b
  where a.tipopedd = b.tipopedd
    and b.abrev = 'HFC_SIAC_DEC_ADICIONAL'
    and a.abreviacion = 'MONT_OCC';

  n_monto_occ   := to_number(trim(replace(lv_monto_occ,'.',',')));

  select valor into v_remark from constante where constante = 'REMARK_OCC';

  /*Valores para mandar a IW*/

  n_cont:=1;
    for c_s in cur_srv loop
      ARR_AREGLO(n_cont).tipo_serv:=c_s.tip_interfase;
      ARR_AREGLO(n_cont).prod_id:=c_s.id_producto;
      ARR_AREGLO(n_cont).prod_id_padre:=c_s.id_producto_padre;
      ARR_AREGLO(n_cont).valores:=c_s.nro_ctv;
      n_cont:=n_cont+1;
    end loop;
  /*Procedimiento para la reserva y activacion del deco adicional*/
  TIM.tim111_pkg_acciones_sga.SP_RESERVAR_DECO_ADI_HFC@DBL_BSCS_BF(n_co_id,
                                                                   v_sncode,
                                                                   v_spcode,
                                                                   v_cf_serv,
                                                                   ARR_AREGLO,
                                                                   n_cod_error,
                                                                   v_des_error);

  IF n_cod_error < 0 THEN
    v_des_error := 'Error al Reservar o Activar el Deco Adicional: ' || v_des_error;
    RAISE error_general;
  END IF;

  /*Iniciamos la facturacion*/
  WEBSERVICE.PQ_WS_HFC.P_INICIO_FACT(n_codsolot,n_co_id,n_cod_error,v_des_error);
  IF n_cod_error < 0 THEN
    v_des_error := 'Error Inicio Facturación: ' || v_des_error;
    RAISE error_general;
  END IF;

  --INI 30.0
  BEGIN
    SELECT h.shfcv_flag_cobro_occ
      INTO c_flag_occ
      FROM operacion.shfct_det_tras_ext h, solot s
     WHERE h.shfcn_codsolot = s.codsolot
       AND h.shfcn_codsolot = n_codsolot;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      c_flag_occ := 0;
  END;

  IF c_flag_occ = 0 THEN
    -- ACTUALIZAR
    UPDATE OPERACION.SHFCT_DET_TRAS_EXT
       SET SHFCV_CODOCC         = n_codigo_occ,
           SHFCV_NUMERO_CUOTA   = n_nro_cuotas,
           SHFCV_MONTO          = n_monto_occ,
           SHFCV_APLICACION     = 'HFCPOST',
           SHFCV_USUARIO_ACT    = USER,
           SHFCV_FECHA_ACT      = SYSDATE
     WHERE SHFCN_CODSOLOT = n_codsolot;

    /*Procedimiento para el registro del OCC*/
    TIM.PP005_SIAC_TRX.SP_INSERT_OCC@DBL_BSCS_BF(n_customer_id,
                                                 n_codigo_occ,
                                                 to_char(SYSDATE,
                                                         'YYYYMMDD'),
                                                 n_nro_cuotas,
                                                 n_monto_occ,
                                                 v_remark,
                                                 n_cod_error_occ);

    IF n_cod_error_occ < 0 THEN
      v_des_error := 'Error al Activar el Deco Adicional: ' || v_des_error;
      RAISE error_general;
    END IF;
  END IF;
  --FIN 30.0

EXCEPTION
  WHEN error_general THEN
    raise_application_error(-20001, v_des_error);
    rollback;
  WHEN OTHERS THEN
    v_des_error := SQLERRM;
    raise_application_error(-20001, v_des_error);
    rollback;
End;
-- fin 25.0
  --Ini 31.0
  procedure p_replica(a_codcli    vtatabcli.codcli%type,
                      a_codsolot  solot.codsolot%type,
                      a_pid       number,
                      a_codinssrv inssrv.codinssrv%type,
                      a_cod_id    number,
                      a_codact    varchar2,
                      a_interface number,
                      o_mensaje   out varchar2,
                      o_error     out number) is
    v_codsolot_old solot.codsolot%type;
    v_old_idtrs    operacion.trs_interface_iw.idtrs%type;
    v_new_idtrs    operacion.trs_interface_iw.idtrs%type;

  begin
    --Obtener ultima SOT de alta
    v_codsolot_old := operacion.pq_sga_iw.f_max_sot_x_cod_id(a_cod_id);

    --Obtiene idtrs de SOT anterior
    select t.idtrs
      into v_old_idtrs
      from operacion.trs_interface_iw t
     where t.codsolot = v_codsolot_old
       and t.id_interfase = a_interface;

    select operacion.sq_trs_interface_iw.nextval into v_new_idtrs from dual;

    p_replica_interface_iw_det(v_new_idtrs,
                               v_old_idtrs,
                               a_codact,
                               a_interface,
                               o_mensaje,
                               o_error);

    p_replica_interface_iw(v_new_idtrs,
                           v_old_idtrs,
                           a_codcli,
                           a_pid,
                           a_codsolot,
                           a_codinssrv,
                           a_cod_id,
                           a_interface,
                           a_codact,
                           o_mensaje,
                           o_error);

    if o_mensaje is not null then
      p_reg_log(a_codcli,
                null,
                v_new_idtrs,
                a_codsolot,
                a_interface,
                o_error,
                o_mensaje);
    end if;
  end;

  procedure p_replica_interface_iw_det(a_idtrs_new number,
                                       a_idtrs_old number,
                                       a_codact    varchar2,
                                       a_interface number,
                                       o_mensaje   out varchar2,
                                       o_error     out number) is
    pragma autonomous_transaction;

    ld_fec_exp_codact date;
    v_param1          varchar2(400);
    v_param2          varchar2(400);
    v_param3          varchar2(400);

  begin
    v_param1 := 'ActivationCode';
    v_param2 := 'ACTIVATION_CODE_EXPIRATION_DATE';
    v_param3 := 'activationCode';

    case a_interface
      when 620 then
        insert into operacion.trs_interface_iw_det
          (idtrs, atributo, valor, orden)
          select a_idtrs_new, d.atributo, d.valor, d.orden
            from operacion.trs_interface_iw_det d, operacion.trs_interface_iw c
           where d.idtrs = c.idtrs
             and d.idtrs = a_idtrs_old
             and c.id_interfase = a_interface
             and d.atributo not in (v_param1, v_param2);

        p_reg_variable(a_idtrs_new, v_param1, a_codact, a_interface);

        select to_char(sysdate + id_valor, 'MM/dd/yyyy HH:mm')
          into ld_fec_exp_codact
          from operacion.int_parametro
         where id_interface = 620
           and id_parametro = v_param1;

        p_reg_variable(a_idtrs_new, v_param2, ld_fec_exp_codact, a_interface);

      when 820 then
        insert into operacion.trs_interface_iw_det
          (idtrs, atributo, valor, orden)
          select a_idtrs_new, d.atributo, d.valor, d.orden
            from operacion.trs_interface_iw_det d, operacion.trs_interface_iw c
           where d.idtrs = c.idtrs
             and d.idtrs = a_idtrs_old
             and c.id_interfase = a_interface
             and d.atributo not in (v_param1);

        p_reg_variable(a_idtrs_new, v_param1, a_codact, a_interface);

      when 824 then
        insert into operacion.trs_interface_iw_det
          (idtrs, atributo, valor, orden)
          select a_idtrs_new, d.atributo, d.valor, d.orden
            from operacion.trs_interface_iw_det d, operacion.trs_interface_iw c
           where d.idtrs = c.idtrs
             and d.idtrs = a_idtrs_old
             and c.id_interfase = a_interface;

      when 830 then
        insert into operacion.trs_interface_iw_det
          (idtrs, atributo, valor, orden)
          select a_idtrs_new, d.atributo, d.valor, d.orden
            from operacion.trs_interface_iw_det d, operacion.trs_interface_iw c
           where d.idtrs = c.idtrs
             and d.idtrs = a_idtrs_old
             and c.id_interfase = a_interface;

      when 2020 then
        insert into operacion.trs_interface_iw_det
          (idtrs, atributo, valor, orden)
          select a_idtrs_new, d.atributo, d.valor, d.orden
            from operacion.trs_interface_iw_det d, operacion.trs_interface_iw c
           where d.idtrs = c.idtrs
             and d.idtrs = a_idtrs_old
             and c.id_interfase = a_interface
             and d.atributo not in (v_param3);

        p_reg_variable(a_idtrs_new, v_param3, a_codact, a_interface);

      when 2025 then
        insert into operacion.trs_interface_iw_det
          (idtrs, atributo, valor, orden)
          select a_idtrs_new, d.atributo, d.valor, d.orden
            from operacion.trs_interface_iw_det d, operacion.trs_interface_iw c
           where d.idtrs = c.idtrs
             and d.idtrs = a_idtrs_old
             and c.id_interfase = a_interface;

      when 2030 then
        insert into operacion.trs_interface_iw_det
          (idtrs, atributo, valor, orden)
          select a_idtrs_new, d.atributo, d.valor, d.orden
            from operacion.trs_interface_iw_det d, operacion.trs_interface_iw c
           where d.idtrs = c.idtrs
             and d.idtrs = a_idtrs_old
             and c.id_interfase = a_interface;

      when 2050 then
        insert into operacion.trs_interface_iw_det
          (idtrs, atributo, valor, orden)
          select a_idtrs_new, d.atributo, d.valor, d.orden
            from operacion.trs_interface_iw_det d, operacion.trs_interface_iw c
           where d.idtrs = c.idtrs
             and d.idtrs = a_idtrs_old
             and c.id_interfase = a_interface;
    end case;
    commit;

  exception
    when others then
      o_mensaje := '. p_replica_interface_iw_det :' || sqlerrm;
      o_error   := sqlcode;
  end;

  procedure p_replica_interface_iw(a_idtrs_new number,
                                   a_idtrs_old number,
                                   a_codcli    varchar2,
                                   a_pid       number,
                                   a_codsolot  solot.codsolot%type,
                                   a_codinssrv inssrv.codinssrv%type,
                                   a_cod_id    number,
                                   a_interface number,
                                   a_codact    varchar2,
                                   o_mensaje   out varchar2,
                                   o_error     out number) is
    v_valores varchar2(400);
    error_general exception;
    v_fila_interface operacion.trs_interface_iw%rowtype;

  begin
    v_valores := f_obt_arr_pip(a_idtrs_new);

    select tip_interfase,
           id_interfase,
           codigo_ext,
           id_producto,
           id_producto_padre,
           id_servicio_padre,
           id_servicio
      into v_fila_interface.tip_interfase,
           v_fila_interface.id_interfase,
           v_fila_interface.codigo_ext,
           v_fila_interface.id_producto,
           v_fila_interface.id_producto_padre,
           v_fila_interface.id_servicio_padre,
           v_fila_interface.id_servicio
      from operacion.trs_interface_iw
     where idtrs = a_idtrs_old
       and id_interfase = a_interface;

    v_fila_interface.idtrs         := a_idtrs_new;
    v_fila_interface.valores       := v_valores;
    v_fila_interface.codsolot      := a_codsolot;
    v_fila_interface.codinssrv     := a_codinssrv;
    v_fila_interface.codactivacion := a_codact;
    v_fila_interface.cod_id        := a_cod_id;
    v_fila_interface.codcli        := a_codcli;
    v_fila_interface.pidsga        := a_pid;

    p_insert_trs_interface_iw(v_fila_interface);

  exception
    when others then
      o_mensaje := '. p_replica_interface_iw :' || sqlerrm;
      o_error   := sqlcode;
  end;

END PQ_IW_SGA_BSCS;
/