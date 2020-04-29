CREATE OR REPLACE PACKAGE BODY OPERACION.PQ_CONT_REGULARIZACION IS

  /*******************************************************************************************************
   NOMBRE:       OPERACION.PQ_CONT_REGULARIZACION
   PROPOSITO:    Paquete de objetos necesarios para la regularizacion de equipos - contratos  BSCS-SGA
   REVISIONES:
   Version    Fecha       Autor            Solicitado por    Descripcion
   ---------  ----------  ---------------  --------------    -----------------------------------------
    1.0       28/06/2015  Angelo Angulo                      SD-318468 - Paquete creado para regularizacion de contratos generados por contingencia.
    2.0       08/07/2015  Luis Flores Osorio                 SD-412773
    3.0       09/02/2016  Carlos Terán                       SD-596715 - Se activa la facturación en SGA (Alineación)
    4.0       01/04/2016                                     SD-642508 - Cambio de Plan
    5.0       20/07/2016  Dorian Sucasaca                    SD_795618
    6.0       10/10/2016  Felipe Maguiña                     PROY 25526 -  Ciclos de Facturación
    7.0       07/12/2016  Servicio Fallas-HITSS             SD_1040408
    8.0       18/03/2017  Servicio Fallas-HITSS              INC000000728320
    9.0       11/05/2017                                     Cambio por Migracion Incognit
   10.0       28/06/2017  Servicio Fallas-HITSS              INC000000840907
   11.0       03/04/2019  Luis Flores       Luis Flores      PostVenta HFC
   12.0       11/09/2019  Steve Panduro     FTTH             FTTH
   13.0       25/09/2019  Steve Panduro     FTTH             FTTH
   14.0       12/11/2019  Cesar Rengifo     HFC              HFC APlicativo APK
   15.0       03/02/2020  Edilberto Astulle
   16.0       04/03/2020  Cesar Rengifo  Edilberto Astulle   Duplicidad de Datos Fichatecnica
   17.0       10/03/2020  Nilton Paredes                     INICIATIVA-435
  *******************************************************************************************************/

  --Regularizacion
  procedure P_REG_BSCS_IW_SGA(an_cod_id number,
                              an_error  out integer,
                              av_error  out varchar2) is

    l_ins_cm       varchar2(600);
    l_ins_mta      varchar2(600);
    l_ins_stb      varchar2(1000);
    v_tipsrv       varchar2(5);

    V_NRO number;

    v_contador       number;
    v_serial         varchar2(400);
    x                number;
    y                varchar2(3000);
    l_codsolot       number(8);
    l_customer_id    number(8);
    l_interf         number;
    l_modlo          varchar2(100);
    L_maxf           number;
    error_iw_getreport exception;
    error_general      EXCEPTION;
    l_insstb  varchar2(1000);
    n_idwf    number;
    n_conval  number;

    cursor cs_act_ctv is
      select *
        from OPERACION.TAB_EQUIPOS_IW o
       where o.interfase = 2020
         and serial_number is not null
         and codsolot = l_codsolot;

    cursor cs_activ_int_mta is
      select *
        from OPERACION.TAB_EQUIPOS_IW o
       where o.interfase in (620, 820)
         and mac_address is not null
         and codsolot = l_codsolot
       order by o.interfase asc;

  begin
    --Si CO_ID es nulo
    if an_cod_id = 0 or an_cod_id is null then
      av_error := ' No se encontro CO_ID' || av_error;
      RAISE error_general;
    end if;

    --Obtenemos SOT
    select MAX(CODSOLOT), MAX(CUSTOMER_ID)
      into l_codsolot, l_customer_id
      from SOLOT S
     WHERE s.cod_id = an_cod_id
       AND ESTSOL IN (17, 12, 29, 9)
       AND TIPTRA IN (select o.codigon
                        from tipopedd t, opedd o
                       where t.tipopedd = o.tipopedd
                         and t.abrev = 'TIPREGCONTIWSGABSCS');

    --Si no existe SOT o CUSTOMER_ID mostrar error
    if l_codsolot is null or l_customer_id is null then
      av_error := ' No se encontro SOT o CUSTOMER_ID ' || av_error;
      RAISE error_general;
    end if;

    --Revisamos si existe en provision
    select count(distinct(co_id))
      into v_contador
      from tim.pf_hfc_prov_bscs@DBL_BSCS_BF
     where co_id = an_cod_id
       and action_id in (1, 8);
    if v_contador = 0 then
      select count(distinct(co_id))
        into v_contador
        from tim.pf_hfc_prov_bscs_hist@DBL_BSCS_BF
       where co_id = an_cod_id
         and action_id in (1, 8);
      if v_contador = 0 then
        --Si no existe en provision ni en historico se envia reservas
        select idwf
          into n_idwf
          from wf
         where codsolot = l_codsolot
           AND valido = 1;
        select count(1)
          into n_conval
          from operacion.trs_interface_iw
         where codsolot = l_codsolot;
        if n_conval = 0 then
          OPERACION.PQ_IW_SGA_BSCS.p_gen_reserva_iw(null,
                                                    n_idwf,
                                                    null,
                                                    null);
        else
          select count(texto)
            into v_contador
            from operacion.log_trs_interface_iw
           where proceso = 'Respuesta Proceso Reserva'
             and error = 0
             and cod_id = an_cod_id;
          if v_contador = 0 then
            OPERACION.PQ_IW_SGA_BSCS.p_genera_reserva_iw(null,
                                                         n_idwf,
                                                         null,
                                                         null);
          end if;
        end if;
      end if;
    end if;

    --Si no llego a BSCS
    select count(texto)
      into v_contador
      from operacion.log_trs_interface_iw
     where proceso = 'Respuesta Proceso Reserva'
       and error = 0
       and cod_id = an_cod_id;
    if v_contador = 0 then
      av_error := ' Reservas no GENERADAS en BSCS: ' || av_error;
      RAISE error_general;
    else
      select count(distinct(co_id))
        into v_contador
        from tim.pf_hfc_prov_bscs@DBL_BSCS_BF
       where co_id = an_cod_id
         and action_id in (1, 8);
      if v_contador = 0 then
        select count(distinct(co_id))
          into v_contador
          from tim.pf_hfc_prov_bscs_hist@DBL_BSCS_BF
         where co_id = an_cod_id
           and action_id in (1, 8);
        if v_contador = 0 then
          av_error := ' Reservas no GENERADAS en BSCS: ' || av_error;
          RAISE error_general;
        end if;
      end if;
    end if;

    --Actualizamos las reservas a estado 5
    UPDATE tim.pf_hfc_prov_bscs@DBL_BSCS_BF
       SET ESTADO_PRV    = 5,
           FECHA_RPT_EAI = sysdate - 5 / 3600,
           ERRCODE       = 0,
           ERRMSG        = 'Operation Success'
     where co_id = an_cod_id
       and action_id in (1, 8);

    P_CONS_DET_IW(l_codsolot, an_error, av_error);

    if an_error < 0 then
      RAISE error_iw_getreport;
    end if;

    --Mandamos activacion int+mta
    l_ins_cm  := null;
    l_ins_mta := null;
    an_error  := NULL;

    for bb in cs_activ_int_mta loop
      if bb.interfase = '620' then
        l_ins_cm := bb.mac_address;
      end if;
      if bb.interfase = '820' then
        l_ins_mta := bb.mac_address || ';1;' || bb.modelo;
      end if;

      BEGIN
        if bb.interfase = 620 then
          OPERACION.PQ_IW_SGA_BSCS.p_instala_srv_iw(bb.codsolot,
                                                    l_ins_cm,
                                                    l_ins_mta,
                                                    l_ins_stb,
                                                    x,
                                                    y);

          if x < 0 then
            av_error  := ' No se envio comando de activacion en BSCS: ' || y;
            RAISE error_general;
          end if;
        elsif bb.interfase = 820 then
          OPERACION.PQ_IW_SGA_BSCS.p_instala_srv_iw(bb.codsolot,
                                                    l_ins_cm,
                                                    l_ins_mta,
                                                    l_ins_stb,
                                                    x,
                                                    y);
          if x < 0 then
            av_error  := ' No se envio comando de activacion en BSCS: ' || y;
            RAISE error_general;
          end if;
        end if;
      EXCEPTION
        WHEN OTHERS THEN
          av_error := ' No se envio comando de activacion en BSCS: ' ||
                      SQLERRM;
          RAISE error_general;
      END;
    end loop;

    --Mandamos activacion ctv
    for cc in cs_act_ctv loop
      begin
        select id_interfaz
          into l_interf
          from int_mensaje_intraway i
         where i.codsolot = cc.codsolot
           and i.id_producto = cc.id_producto
           and i.id_interfase = 2022
           and i.id_interfaz in
               (select max(id_interfaz)
                  from int_mensaje_intraway
                 where id_cliente = i.id_cliente
                   and id_producto = i.id_producto
                   and id_interfase = 2022);
        select valor_atributo
          into l_modlo
          from int_mensaje_atributo_intraway
         where nombre_atributo = 'STBTypeCRMId'
           and id_mensaje_intraway = l_interf;

        SELECT COUNT(1)
          INTO V_NRO
          FROM TIM.PF_HFC_CABLE_TV@DBL_BSCS_BF CV
         WHERE CV.ID_PRODUCTO = cc.id_producto
           AND CV.ESTADO_RECURSO = 'PI';

        IF v_nro > 0 THEN
          l_ins_stb := l_ins_stb || '|' || cc.mac_address || ';' || l_modlo || ';' ||
                       cc.unit_address || ';FALSE';
        END IF;
      exception
        when no_data_found then
          av_error := 'No se encontro registros de servicios adicionales para el IDPRODUCTO :' || cc.id_producto;
        when others then
          av_error := SQLERRM;
          RAISE error_general;
      end;
    END LOOP;

    select LENGTH(l_ins_stb) into L_maxf from dual;
    select substr(l_ins_stb, 2, L_maxf - 1) into l_insstb from dual;

    BEGIN
      if l_insstb is not null then
        OPERACION.PQ_IW_SGA_BSCS.p_instala_srv_iw(l_codsolot,
                                                  l_ins_cm,
                                                  l_ins_mta,
                                                  l_ins_stb,
                                                  x,
                                                  y);
        if x < 0 then
          av_error := ' No se envio comando de activacion en BSCS: ' || y;
          RAISE error_general;
        end if;
      end if;
    EXCEPTION
      WHEN OTHERS THEN
        av_error := ' No se envio comando de activacion en BSCS: ' ||
                    SQLERRM;
        RAISE error_general;
    END;

    --Actualizamos Activación
    UPDATE tim.pf_hfc_prov_bscs@DBL_BSCS_BF
       SET ESTADO_PRV    = 5,
           FECHA_RPT_EAI = sysdate - 5 / 3600,
           ERRCODE       = 0,
           ERRMSG        = 'Operation Success'
     where co_id = an_cod_id
       and action_id = 2;

    --Actualizamos equipos
    begin

      DECLARE
        CURSOR CS_EQUIPOS_IW IS
          SELECT COD_ID,
                 TIPO_SERVICIO,
                 ID_PRODUCTO,
                 INTERFASE,
                 MODELO,
                 UNIT_ADDRESS,
                 STBTYPECRMID,
                 CASE
                   WHEN INTERFASE <> 2020 THEN
                    MAC_ADDRESS
                   ELSE
                    SERIAL_NUMBER
                 END SERIE
            FROM OPERACION.TAB_EQUIPOS_IW
           WHERE CODSOLOT = l_codsolot
             AND ID_PRODUCTO IN
                 (SELECT iw.id_producto
                    FROM OPERACION.TRS_INTERFACE_IW iw, solot s
                   WHERE iw.id_interfase in (620, 820, 2020)
                     and s.codsolot = iw.codsolot
                     and s.CODSOLOT = l_codsolot)
           order by INTERFASE asc;
      BEGIN
        FOR C IN CS_EQUIPOS_IW LOOP
          IF c.interfase = 620 then
            v_tipsrv := 'INT';
            TIM.pp021_venta_hfc.sp_inst_equipo_ivr@DBL_BSCS_BF(an_cod_id,
                                                               v_tipsrv,
                                                               c.id_producto,
                                                               c.SERIE,
                                                               an_error,
                                                               av_error);
            if an_error < 0 then
              av_error := ' No se realizo la alineacion de equipos BSCS: ' ||
                          an_error;
              RAISE error_general;
            end if;
          elsif c.interfase = 820 then
            v_tipsrv := 'TLF';
            TIM.pp021_venta_hfc.sp_inst_equipo_ivr@DBL_BSCS_BF(an_cod_id,
                                                               v_tipsrv,
                                                               c.id_producto,
                                                               c.SERIE ||
                                                               ';1;' ||
                                                               c.modelo,
                                                               an_error,
                                                               av_error);
            if an_error < 0 then
              av_error := ' No se realizo la alineacion de equipos BSCS: ' ||
                          an_error;
              RAISE error_general;
            end if;
          else
            v_tipsrv := 'CTV';
            v_serial := c.SERIE || ';' || c.STBTYPECRMID || ';' ||
                        c.UNIT_ADDRESS || ';' || 'FALSE' || '|' || c.SERIE || ';' ||
                        c.STBTYPECRMID || ';' || c.UNIT_ADDRESS || ';' ||
                        'FALSE';
            --Alineamos en BSCS
            TIM.pp021_venta_hfc.sp_inst_equipo_ivr@DBL_BSCS_BF(an_cod_id,
                                                               v_tipsrv,
                                                               c.id_producto,
                                                               v_serial,
                                                               an_error,
                                                               av_error);
            if an_error < 0 then
              av_error := ' No se realizo la alineacion de equipos BSCS: ' ||
                          an_error;
              RAISE error_general;
            end if;
          end if;

          if an_error < 0 then
            av_error := ' Error al ejecutar alineacion de equipos BSCS: ' || y;
            RAISE error_general;

          end if;

          v_serial := null;

        END LOOP;
      END;
    end;
    av_error := 'Éxito en el Proceso';
    an_Error := 0;
    p_reg_log(l_customer_id,
              null,
              NULL,
              l_codsolot,
              null,
              an_Error,
              av_error,
              an_cod_id,
              'Regularizacion BSCS-SGA-IW');

  EXCEPTION
    WHEN error_general THEN
      an_Error := -1;
      p_reg_log(l_customer_id,
                null,
                NULL,
                l_codsolot,
                null,
                an_error,
                av_error,
                an_cod_id,
                'Regularizacion BSCS-SGA-IW');
    WHEN error_iw_getreport THEN
      av_error := 'Error al obtener la informacion de IW : ' || av_error;
      an_Error := -19;
      p_reg_log(l_customer_id,
                null,
                NULL,
                l_codsolot,
                null,
                an_Error,
                av_error,
                an_cod_id,
                'Regularizacion BSCS-SGA-IW');
    WHEN OTHERS THEN
      av_error := 'ERROR: ' || SQLERRM;
      an_Error := sqlcode;
      p_reg_log(l_customer_id,
                null,
                NULL,
                l_codsolot,
                null,
                an_Error,
                av_error,
                an_cod_id,
                'Regularizacion BSCS-SGA-IW');

  END P_REG_BSCS_IW_SGA;

  PROCEDURE P_CONSULTA_IW(a_codsolot in solot.codsolot%type,
                          a_tipo     in number,
                          a_ticket   out number,
                          an_error   out integer,
                          av_error   out varchar2) IS

    v_out            number;
    v_mens           varchar2(400);
    v_idprodpadre    number;
    v_contador       number;
    v_idventpadre    number;
    v_macadd         varchar2(400);
    v_modelmta       varchar2(400);
    v_central        varchar2(400);
    v_profile        varchar2(400);
    v_hub            varchar2(400);
    v_nodo           varchar2(400);
    v_activationcode varchar2(400);
    v_cantpcs        number;
    v_servpackname   varchar2(400);
    v_mensajesus     varchar2(400);
    v_serial         varchar2(400);
    v_unitd          varchar2(400);
    v_disab          varchar2(400);
    v_equp           varchar2(400);
    v_product        varchar2(400);
    v_channel        varchar2(400);
    l_cod_id         number(8);
    l_customer_id    number(8);
    l_id_producto    VARCHAR2(20);
    l_tip_interfase  VARCHAR2(3);
    l_id_interfase   VARCHAR2(10);
    error_iw_getreport exception;
    error_general      EXCEPTION;
    v_serialnumber   varchar2(200);
    ln_valinc        VARCHAR2(2);--number; --9.0
    lv_tn            varchar2(100); --9.0

    lv_HUB                VARCHAR2(100);---10.0
    lv_nodo               VARCHAR2(100);---10.0
    lv_MACADDRESS         VARCHAR2(100);---10.0
    lv_ACTIVATIONCODE     VARCHAR2(100);---10.0
    lv_cantpcs            VARCHAR2(100);---10.0
    lv_servicepackagename VARCHAR2(100);---10.0

    lv_ID_PRODUCTO_PADRE       VARCHAR2(100);---10.0
    LV_IDENTIFIER              VARCHAR2(100);---10.0
    LV_EQUIPMENTYPEDESCRIPTION VARCHAR2(100);---10.0
    LV_PROFILECRMID            VARCHAR2(100);---10.0

    lv_DTV_NODE        VARCHAR2(100); ---10.0
    lv_STBTYPECRMID    VARCHAR2(100); ---10.0
    lv_DISABLED        VARCHAR2(100); ---10.0
    lv_SERVICENAME     VARCHAR2(100); ---10.0
    lv_DTV_CHANNEL_MAP VARCHAR2(100); ---10.0
    lv_SERIALNUMBER    VARCHAR2(100); ---10.0
    l_iderr            number;        ---10.0
    l_mens             VARCHAR2(4000);---10.0
    cr_cursor          sys_refcursor; ---10.0

  BEGIN

    SELECT OPERACION.SQ_EQU_IW.NEXTVAL INTO a_ticket FROM DUAL;

    --Buscar por codcli o customer_id
    if a_tipo = 0 then
      select codcli, cod_id
        into l_customer_id, l_cod_id
        from solot
       where codsolot = a_codsolot;
    else
      select customer_id, cod_id
        into l_customer_id, l_cod_id
        from solot
       where codsolot = a_codsolot;
    end if;

    --INT
    SELECT count(1)
      into v_contador
      FROM OPERACION.TRS_INTERFACE_IW iw, solot s
     WHERE iw.id_interfase in (620)
       and s.codsolot = iw.codsolot
       and s.CODSOLOT = a_codsolot;

    if v_contador = 1 then
      --Obtenemos id_producto
      SELECT s.customer_id,
             iw.ID_INTERFASE,
             iw.TIP_INTERFASE,
             iw.ID_PRODUCTO
        INTO l_customer_id, l_id_interfase, l_tip_interfase, l_id_producto
        FROM OPERACION.TRS_INTERFACE_IW iw, solot s
       WHERE iw.id_interfase in (620)
         and s.codsolot = iw.codsolot
         and s.CODSOLOT = a_codsolot;

      --Obtenemos datos de IW
      --9.0 Ini
     -- intraway.pq_migracion_iw.P_VALIDAR_SUC_INC(a_codsolot,ln_valinc);
      INTRAWAY.PKG_INCOGNITO.P_CONSLT_ORIGENBD(TO_CHAR(l_customer_id),a_codsolot,'CM',ln_valinc);

      if ln_valinc = 'IC' Then

        /*INI 10.0*/
        intraway.pq_migrasac.P_TRAE_DOCSISEQUIPO(l_customer_id,
                                                 v_out,
                                                 v_mens,
                                                 cr_cursor);

        loop
          fetch cr_cursor
            into lv_HUB,
                 lv_nodo,
                 lv_MACADDRESS,
                 lv_ACTIVATIONCODE,
                 lv_cantpcs,
                 lv_servicepackagename,
                 lv_serialnumber;
          exit when cr_cursor%notfound;

          insert into OPERACION.TAB_EQUIPOS_IW2
            (id_ticket,
             codsolot,
             customer_id,
             cod_id,
             ID_PRODUCTO,
             tipo_servicio,
             interfase,
             MAC_ADDRESS,
             PROFILE_CRM,
             serial_number)
          values
            (a_ticket,
             a_codsolot,
             l_customer_id,
             l_cod_id,
             l_id_producto,
             'INT',
             '620',
             lv_MACADDRESS,
             lv_servicepackagename,
             lv_serialnumber);

        end loop;
        /*FIN 10.0*/
      Else
        Intraway.Pq_Consultaitw.p_int_consultacm(l_customer_id,
                                                 l_id_producto,
                                                 0,
                                                 v_out,
                                                 v_mens,
                                                 v_hub,
                                                 v_nodo,
                                                 v_macadd,
                                                 v_activationcode,
                                                 v_cantpcs,
                                                 v_servpackname,
                                                 v_mensajesus,
                                                 v_serialnumber);
      --9.0 Fin
      if v_macadd is null then
        av_error := ' INT: MAC_ADDRESS nulo o vacio ' || av_error;
      else
        insert into OPERACION.TAB_EQUIPOS_IW2
          (ID_TICKET,
           codsolot,
           customer_id,
           cod_id,
           ID_PRODUCTO,
           tipo_servicio,
           interfase,
           MAC_ADDRESS,
           PROFILE_CRM,
           SERIAL_NUMBER)
        values
          (a_ticket,
           a_codsolot,
           l_customer_id,
           l_cod_id,
           l_id_producto,
           ln_valinc||'INT',
           '620',
           v_macadd,
           v_servpackname,
           v_serialnumber);
      end if;
      End If;

    end if;

    --TLF
    SELECT count(1)
      into v_contador
      FROM OPERACION.TRS_INTERFACE_IW iw, solot s
     WHERE iw.id_interfase in (820)
       and s.codsolot = iw.codsolot
       and s.CODSOLOT = a_codsolot;

    if v_contador = 1 then
      --Obtenemos id_producto
      SELECT s.customer_id,
             iw.ID_INTERFASE,
             iw.TIP_INTERFASE,
             iw.ID_PRODUCTO
        INTO l_customer_id, l_id_interfase, l_tip_interfase, l_id_producto
        FROM OPERACION.TRS_INTERFACE_IW iw, solot s
       WHERE iw.id_interfase in (820)
         and s.codsolot = iw.codsolot
         and s.CODSOLOT = a_codsolot;
      --9.0 Ini
      --intraway.pq_migracion_iw.P_VALIDAR_SUC_INC(a_codsolot,ln_valinc);
      INTRAWAY.PKG_INCOGNITO.P_CONSLT_ORIGENBD(TO_CHAR(l_customer_id),a_codsolot,'CM',ln_valinc);

      if ln_valinc = 'IC' Then

       /*INI 10.0*/
       intraway.pq_migrasac.P_TRAE_VOICEBEQUIPO(l_customer_id,
                                                v_out,
                                                v_mens,
                                                cr_cursor);

        loop
          fetch cr_cursor
            into lv_ID_PRODUCTO_PADRE,
                 LV_IDENTIFIER,
                 LV_EQUIPMENTYPEDESCRIPTION,
                 LV_PROFILECRMID;
          exit when cr_cursor%notfound;

          insert into OPERACION.TAB_EQUIPOS_IW2
            (id_ticket,
             codsolot,
             customer_id,
             cod_id,
             ID_PRODUCTO,
             tipo_servicio,
             interfase,
             MAC_ADDRESS,
             MODELO,
             PROFILE_CRM,
             serial_number)
          values
            (a_ticket,
             a_codsolot,
             l_customer_id,
             l_cod_id,
             l_id_producto,
             'TLF',
             '820',
             LV_IDENTIFIER,
             LV_EQUIPMENTYPEDESCRIPTION,
             LV_PROFILECRMID,
             LV_IDENTIFIER);

        end loop;
        /*FIN 10.0*/
      Else
        Intraway.Pq_Consultaitw.p_int_consultamta(l_customer_id,
                                                  l_id_producto,
                                                  0,
                                                  v_out,
                                                  v_mens,
                                                  v_idprodpadre,
                                                  v_idventpadre,
                                                  v_macadd,
                                                  v_modelmta,
                                                  v_profile,
                                                  v_activationcode,
                                                  v_central);

      --9.0 Fin
      if v_macadd is null then
        av_error := ' TLF: MAC_ADDRESS nulo o vacio ' || av_error;
      else
        insert into OPERACION.TAB_EQUIPOS_IW2
          (id_ticket,
           codsolot,
           customer_id,
           cod_id,
           ID_PRODUCTO,
           tipo_servicio,
           interfase,
           MAC_ADDRESS,
           MODELO,
           PROFILE_CRM)
        values
          (a_ticket,
           a_codsolot,
           l_customer_id,
           l_cod_id,
           l_id_producto,
           ln_valinc||'TLF',
           '820',
           v_macadd,
           v_modelmta,
           v_profile);
      end if;
      End If;

    end if;

    --CTV
    SELECT count(1)
      into v_contador
      FROM OPERACION.TRS_INTERFACE_IW iw, solot s
     WHERE iw.id_interfase in (2020)
       and s.codsolot = iw.codsolot
       and s.CODSOLOT = a_codsolot;

    if v_contador > 0 then
      declare
        cursor equipos_ctv is
          SELECT s.customer_id,
                 iw.ID_INTERFASE,
                 iw.TIP_INTERFASE,
                 iw.ID_PRODUCTO
            FROM OPERACION.TRS_INTERFACE_IW iw, solot s
           WHERE iw.id_interfase in (2020)
             and s.codsolot = iw.codsolot
             and s.CODSOLOT = a_codsolot;
      begin
        for c in equipos_ctv loop
          --9.0 Ini
          --intraway.pq_migracion_iw.P_VALIDAR_SUC_INC(a_codsolot,ln_valinc);
          INTRAWAY.PKG_INCOGNITO.P_CONSLT_ORIGENBD(TO_CHAR(C.customer_id),a_codsolot,'TV',ln_valinc);

          if ln_valinc = 'IC' Then


            /*INI 10.0*/
            intraway.pq_migrasac.p_trae_dtv(c.customer_id,
                                            c.id_producto,
                                            l_iderr,
                                            l_mens,
                                            cr_cursor);


            loop
              fetch cr_cursor
                into v_activationcode,
                     lv_SERIALNUMBER,
                     lv_DTV_NODE,
                     lv_STBTYPECRMID,
                     lv_DISABLED,
                     lv_SERVICENAME,
                     lv_DTV_CHANNEL_MAP;
              exit when cr_cursor%notfound;


              insert into OPERACION.TAB_EQUIPOS_IW2
                (id_ticket,
                 codsolot,
                 customer_id,
                 cod_id,
                 ID_PRODUCTO,
                 tipo_servicio,
                 interfase,
                 SERIAL_NUMBER,
                 UNIT_ADDRESS,
                 STBTYPECRMID,
                 PROFILE_CRM)
              values
                (a_ticket,
                 a_codsolot,
                 c.customer_id,
                 l_cod_id,
                 c.id_producto,
                 'CTV',
                 '2020',
                 lv_serialnumber,
                 v_activationcode,
                 lv_DTV_CHANNEL_MAP,
                 lv_STBTYPECRMID);

            end loop;
            /*FIN 10.0*/

          Else
            Intraway.Pq_Consultaitw.p_int_consultatv(c.customer_id,
                                                     c.id_producto,
                                                     0,
                                                     v_out,
                                                     v_mens,
                                                     v_serial,
                                                     v_unitd,
                                                     v_disab,
                                                     v_equp,
                                                     v_hub,
                                                     v_product,
                                                     v_channel);
          --9.0 Fin
          if v_serial is null then
            av_error := ' CTV: SERIAL nulo o vacio ' || av_error;
          else

            insert into OPERACION.TAB_EQUIPOS_IW2
              (id_ticket,
               codsolot,
               customer_id,
               cod_id,
               ID_PRODUCTO,
               tipo_servicio,
               interfase,
               SERIAL_NUMBER,
               UNIT_ADDRESS,
               STBTYPECRMID,
               PROFILE_CRM)
            values
              (a_ticket,
               a_codsolot,
               c.customer_id,
               l_cod_id,
               c.id_producto,
               ln_valinc||'CTV',
               '2020',
               v_serial,
               v_unitd,
               v_equp,
               v_hub);
          end if;
          End If;

        end loop;
      end;
    end if;
  EXCEPTION
    WHEN OTHERS THEN
      av_error := 'Error al obtener la informacion de IW  : ' || SQLERRM;
      an_Error := sqlcode;
      a_ticket := -1;
  END;

  PROCEDURE P_CONS_DET_IW(a_codsolot in solot.codsolot%type,
                          an_error   out integer,
                          av_error   out varchar2) IS

    v_out            number;
    v_mens           varchar2(400);
    v_idprodpadre    number;
    v_contador       number;
    v_idventpadre    number;
    v_macadd         varchar2(400);
    v_modelmta       varchar2(400);
    v_profile        varchar2(400);
    v_hub            varchar2(400);
    v_nodo           varchar2(400);
    v_activationcode varchar2(400);
    v_cantpcs        number;
    v_servpackname   varchar2(400);
    v_mensajesus     varchar2(400);
    v_central        varchar2(400);
    v_serial         varchar2(400);
    v_unitd          varchar2(400);
    v_disab          varchar2(400);
    v_equp           varchar2(400);
    v_product        varchar2(400);
    v_channel        varchar2(400);
    l_cod_id         number(8);
    l_customer_id    number(8);
    l_id_producto    VARCHAR2(20);
    l_tip_interfase  VARCHAR2(3);
    l_id_interfase   VARCHAR2(10);
    error_iw_getreport exception;
    error_general      EXCEPTION;
    v_serialnumber VARCHAR2(200);
    ln_valinc      number; --9.0
    lv_tn          varchar2(100); --9.0
    ln_valincv     varchar2(10); --9.0

    cr_cursor             sys_refcursor;
    lv_HUB                VARCHAR2(100);
    lv_nodo               VARCHAR2(100);
    lv_MACADDRESS         VARCHAR2(100);
    lv_ACTIVATIONCODE     VARCHAR2(100);
    lv_cantpcs            VARCHAR2(100);
    lv_servicepackagename VARCHAR2(100);
    lv_serialnumber       VARCHAR2(100);

    lv_ID_PRODUCTO_PADRE       VARCHAR2(100);
    LV_IDENTIFIER              VARCHAR2(100);
    LV_EQUIPMENTYPEDESCRIPTION VARCHAR2(100);
    LV_PROFILECRMID            VARCHAR2(100);

    lv_DTV_NODE        VARCHAR2(100); ---10.0
    lv_STBTYPECRMID    VARCHAR2(100); ---10.0
    lv_DISABLED        VARCHAR2(100); ---10.0
    lv_SERVICENAME     VARCHAR2(100); ---10.0
    lv_DTV_CHANNEL_MAP VARCHAR2(100); ---10.0
    l_iderr            number;        ---10.0
    l_mens             VARCHAR2(4000);---10.0
ln_tiptra          tiptrabajo.tiptra%type; --12.0
    ln_existe_hfc      number := 0; --14.0
    ln_conta_hfc       number := 0; --14.0
  BEGIN

    delete from operacion.tab_equipos_iw w where w.codsolot = a_codsolot;

    select customer_id, cod_id, tiptra --12.0
      into l_customer_id, l_cod_id, ln_tiptra --12.0
      from solot
     where codsolot = a_codsolot;

    if l_customer_id is null then
      select codcli, cod_id
        into l_customer_id, l_cod_id
        from solot
       where codsolot = a_codsolot;
    end if;

    --Si no existe CO_ID o ID_CLIENTE mostrar error
    if l_cod_id is null or l_customer_id is null then
      av_error := ' No se encontro SOT o CUSTOMER_ID ' || av_error;
      RAISE error_general;
    end if;
    -- INI 14.0
    select count(*) into ln_existe_hfc
    from   opewf.wf w,solot s
    where  w.codsolot = s.codsolot
    and    w.wfdef  in (select  o.codigon
						from TIPOPEDD t, opedd o
						where t.TIPOPEDD = o.TIPOPEDD
						and t.DESCRIPCION = 'WFNUEVOPROCESOJSON')
--1407 -- INSTALACION HFC SISACT APK
    and    s.codsolot in (a_codsolot);
    
    IF ln_existe_hfc >0 then
       ln_conta_hfc  := 1;
    else
      if ln_existe_hfc <=0 then
         ln_conta_hfc  := 0;
      end if;
    end if;
    --- FIN 14.0	
    --ini 12.0
    if ln_tiptra = 830 or ln_conta_hfc = 1 --14.0
	  then
      SGASI_TABEQU_IW(l_cod_id,
                      a_codsolot,
                      l_customer_id,
					  ln_conta_hfc,   --14.0
                      an_error,
                      av_error);
    else
      --fin 12.0
    --INT
    SELECT count(1)
      into v_contador
      FROM OPERACION.TRS_INTERFACE_IW iw, solot s
     WHERE iw.id_interfase in (620)
       and s.codsolot = iw.codsolot
       and s.CODSOLOT = a_codsolot;

    if v_contador = 1 then
      --Obtenemos id_producto
      SELECT s.customer_id,
             iw.ID_INTERFASE,
             iw.TIP_INTERFASE,
             iw.ID_PRODUCTO
        INTO l_customer_id, l_id_interfase, l_tip_interfase, l_id_producto
        FROM OPERACION.TRS_INTERFACE_IW iw, solot s
       WHERE iw.id_interfase in (620)
         and s.codsolot = iw.codsolot
         and s.CODSOLOT = a_codsolot;

      --Obtenemos datos de IW
      --9.0 Ini
      INTRAWAY.PKG_INCOGNITO.P_CONSLT_ORIGENBD(TO_CHAR(l_customer_id),
                                               a_codsolot,
                                               'CM',
                                               ln_valincv);

      if ln_valincv = 'IC' Then
        intraway.pq_migrasac.P_TRAE_DOCSISEQUIPO(l_customer_id,
                                                 v_out,
                                                 v_mens,
                                                 cr_cursor);

        loop
          fetch cr_cursor
            into lv_HUB,
                 lv_nodo,
                 lv_MACADDRESS,
                 lv_ACTIVATIONCODE,
                 lv_cantpcs,
                 lv_servicepackagename,
                 lv_serialnumber;
          exit when cr_cursor%notfound;

          insert into OPERACION.TAB_EQUIPOS_IW
            (codsolot,
             customer_id,
             cod_id,
             ID_PRODUCTO,
             tipo_servicio,
             interfase,
             MAC_ADDRESS,
             PROFILE_CRM,
             serial_number)
          values
            (a_codsolot,
             l_customer_id,
             l_cod_id,
             l_id_producto,
             'INT',
             '620',
             lv_MACADDRESS,
             lv_servicepackagename,
             lv_serialnumber);

        end loop;

      Else
        Intraway.Pq_Consultaitw.p_int_consultacm(l_customer_id,
                                                 l_id_producto,
                                                 0,
                                                 v_out,
                                                 v_mens,
                                                 v_hub,
                                                 v_nodo,
                                                 v_macadd,
                                                 v_activationcode,
                                                 v_cantpcs,
                                                 v_servpackname,
                                                 v_mensajesus,
                                                 v_serialnumber);

        --9.0 Fin
        MERGE INTO OPERACION.TAB_EQUIPOS_IW d
        USING (select a_codsolot     codsolot,
                      l_customer_id  customer_id,
                      l_cod_id       cod_id,
                      l_id_producto  id_producto,
                      v_macadd       macadd,
                      v_servpackname servpackname,
                      v_serialnumber serialnumber,
                      620
                 from dual) f
        ON (d.codsolot = f.codsolot and d.interfase = 620 and d.id_producto = f.id_producto)
        WHEN MATCHED THEN
          update set MAC_ADDRESS = f.macadd
        WHEN NOT MATCHED THEN
          insert
            (codsolot,
             customer_id,
             cod_id,
             ID_PRODUCTO,
             tipo_servicio,
             interfase,
             MAC_ADDRESS,
             PROFILE_CRM,
             serial_number)
          values
            (f.codsolot,
             f.customer_id,
             f.cod_id,
             f.id_producto,
             'INT',
             '620',
             f.macadd,
             f.servpackname,
             f.serialnumber);
      End If;

    end if;

    --TLF
    SELECT count(1)
      into v_contador
      FROM OPERACION.TRS_INTERFACE_IW iw, solot s
     WHERE iw.id_interfase in (820)
       and s.codsolot = iw.codsolot
       and s.CODSOLOT = a_codsolot;

    if v_contador = 1 then
      --Obtenemos id_producto
      SELECT s.customer_id,
             iw.ID_INTERFASE,
             iw.TIP_INTERFASE,
             iw.ID_PRODUCTO
        INTO l_customer_id, l_id_interfase, l_tip_interfase, l_id_producto
        FROM OPERACION.TRS_INTERFACE_IW iw, solot s
       WHERE iw.id_interfase in (820)
         and s.codsolot = iw.codsolot
         and s.CODSOLOT = a_codsolot;

      --9.0 Ini
      INTRAWAY.PKG_INCOGNITO.P_CONSLT_ORIGENBD(TO_CHAR(l_customer_id),
                                               a_codsolot,
                                               'CM',
                                               ln_valincv);

      if ln_valincv = 'IC' Then
        intraway.pq_migrasac.P_TRAE_VOICEBEQUIPO(l_customer_id,
                                                 v_out,
                                                 v_mens,
                                                 cr_cursor);

        loop
          fetch cr_cursor
            into lv_ID_PRODUCTO_PADRE,
                 LV_IDENTIFIER,
                 LV_EQUIPMENTYPEDESCRIPTION,
                 LV_PROFILECRMID;
          exit when cr_cursor%notfound;

          insert into OPERACION.TAB_EQUIPOS_IW
            (codsolot,
             customer_id,
             cod_id,
             ID_PRODUCTO,
             tipo_servicio,
             interfase,
             MAC_ADDRESS,
             MODELO,
             PROFILE_CRM,
             serial_number)
          values
            (a_codsolot,
             l_customer_id,
             l_cod_id,
             l_id_producto,
             'TLF',
             '820',
             LV_IDENTIFIER,
             LV_EQUIPMENTYPEDESCRIPTION,
             LV_PROFILECRMID,
             LV_IDENTIFIER);

        end loop;
	    -- 17.0 Ini
          SP_UPDATE_MODEL_EQUIP(a_codsolot,an_error,av_error);
        -- 17.0 Fin
      Else
        Intraway.Pq_Consultaitw.p_int_consultamta(l_customer_id,
                                                  l_id_producto,
                                                  0,
                                                  v_out,
                                                  v_mens,
                                                  v_idprodpadre,
                                                  v_idventpadre,
                                                  v_macadd,
                                                  v_modelmta,
                                                  v_profile,
                                                  v_activationcode,
                                                  v_central);
        MERGE INTO OPERACION.TAB_EQUIPOS_IW d
        USING (select a_codsolot    codsolot,
                      l_customer_id customer_id,
                      l_cod_id      cod_id,
                      l_id_producto id_producto,
                      v_macadd      macadd,
                      v_modelmta    modelmta,
                      v_profile     profilemta,
                      820,
                      v_central     central
                 from dual) f
        ON (d.codsolot = f.codsolot and d.interfase = 820 and d.id_producto = f.id_producto)
        WHEN MATCHED THEN
          update
             set MAC_ADDRESS = f.macadd,
                 MODELO      = f.modelmta,
                 PROFILE_CRM = f.profilemta
        WHEN NOT MATCHED THEN
          insert
            (codsolot,
             customer_id,
             cod_id,
             ID_PRODUCTO,
             tipo_servicio,
             interfase,
             MAC_ADDRESS,
             MODELO,
             PROFILE_CRM,
             serial_number)
          values
            (f.codsolot,
             f.customer_id,
             f.cod_id,
             f.id_producto,
             'TLF',
             '820',
             f.macadd,
             f.modelmta,
             f.profilemta,
             f.central);
      End If;
      --9.0 Fin

    end if;

    --CTV
    SELECT count(1)
      into v_contador
      FROM OPERACION.TRS_INTERFACE_IW iw, solot s
     WHERE iw.id_interfase in (2020)
       and s.codsolot = iw.codsolot
       and s.CODSOLOT = a_codsolot;

    if v_contador > 0 then
      declare
        cursor equipos_ctv is
          SELECT s.customer_id,
                 iw.ID_INTERFASE,
                 iw.TIP_INTERFASE,
                 iw.ID_PRODUCTO
            FROM OPERACION.TRS_INTERFACE_IW iw, solot s
           WHERE iw.id_interfase in (2020)
             and s.codsolot = iw.codsolot
             and s.CODSOLOT = a_codsolot;
      begin
        for c in equipos_ctv loop
          --9.0 Ini
          -- intraway.pq_migracion_iw.P_VALIDAR_SUC_INC(a_codsolot,ln_valinc);
          INTRAWAY.PKG_INCOGNITO.P_CONSLT_ORIGENBD(TO_CHAR(C.customer_id),
                                                   a_codsolot,
                                                   'TV',
                                                   ln_valincv);

          if ln_valincv = 'IC' Then

/*            -- if ln_valinc = 1 Then
            intraway.pq_migracion_iw.P_TRAE_DTV_MAC(l_customer_id,
                                                    l_id_producto,
                                                    v_out,
                                                    v_mens,
                                                    v_serial,
                                                    v_unitd,
                                                    v_equp,
                                                    v_hub);*/
            /*INI 10.0*/
            intraway.pq_migrasac.p_trae_dtv(c.customer_id,
                                            c.id_producto,
                                            l_iderr,
                                            l_mens,
                                            cr_cursor);


            loop
              fetch cr_cursor
                into v_activationcode,
                     lv_SERIALNUMBER,
                     lv_DTV_NODE,
                     lv_STBTYPECRMID,
                     lv_DISABLED,
                     lv_SERVICENAME,
                     lv_DTV_CHANNEL_MAP;
              exit when cr_cursor%notfound;


              insert into OPERACION.TAB_EQUIPOS_IW
                (codsolot,
                 customer_id,
                 cod_id,
                 ID_PRODUCTO,
                 tipo_servicio,
                 interfase,
                 SERIAL_NUMBER,
                 UNIT_ADDRESS,
                 STBTYPECRMID,
                 PROFILE_CRM)
              values
                (a_codsolot,
                 c.customer_id,
                 l_cod_id,
                 c.id_producto,
                 'CTV',
                 '2020',
                 lv_serialnumber,
                 v_activationcode,
                 lv_DTV_CHANNEL_MAP,
                 lv_STBTYPECRMID);

            end loop;
            /*FIN 10.0*/
          Else
            Intraway.Pq_Consultaitw.p_int_consultatv(c.customer_id,
                                                     c.id_producto,
                                                     0,
                                                     v_out,
                                                     v_mens,
                                                     v_serial,
                                                     v_unitd,
                                                     v_disab,
                                                     v_equp,
                                                     v_hub,
                                                     v_product,
                                                     v_channel);

          --9.0 Fin
          MERGE INTO OPERACION.TAB_EQUIPOS_IW d
          USING (select a_codsolot    codsolot,
                        c.customer_id customer_id,
                        l_cod_id      cod_id,
                        c.id_producto id_producto,
                        v_serial      serial,
                        v_unitd       unitd,
                        v_equp        equp,
                        v_hub         hub,
                        2020
                   from dual) f
          ON (d.codsolot = f.codsolot and d.interfase = 2020 and d.id_producto = c.id_producto)
          WHEN MATCHED THEN
            update
               set SERIAL_NUMBER = f.serial,
                   UNIT_ADDRESS  = f.unitd,
                   STBTYPECRMID  = f.equp,
                   PROFILE_CRM   = f.hub
          WHEN NOT MATCHED THEN
          --Insertamos
            insert
              (codsolot,
               customer_id,
               cod_id,
               ID_PRODUCTO,
               tipo_servicio,
               interfase,
               SERIAL_NUMBER,
               UNIT_ADDRESS,
               STBTYPECRMID,
               PROFILE_CRM)
            values
              (f.codsolot,
               f.customer_id,
               f.cod_id,
               f.id_producto,
               'CTV',
               '2020',
               f.serial,
               f.unitd,
               f.equp,
               f.hub);

          End If;

        end loop;
      end;
    end if;
    end if; --ini 12.0
    av_error := 'Éxito en el Proceso';
    an_Error := 0;
  EXCEPTION
    WHEN error_general THEN
      av_error := 'Error al obtener la informacion de IW ' || ' ' ||
                  av_error;
      an_Error := an_error;
    WHEN error_iw_getreport THEN
      av_error := 'Error al obtener la informacion de IW : ' || av_error;
      an_Error := -19;
    WHEN OTHERS THEN
      av_error := 'Error al obtener la informacion de IW  : ' ||
                  SQLERRM || ' Linea : ('||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||')'; -- LFO
      an_Error := sqlcode;
  END P_CONS_DET_IW;

procedure P_ACTIVARFACTURACION(an_cod_id number,
                                 an_error  out integer,
                                 av_error  out varchar2) IS

    V_CH_STATUS   VARCHAR2(5);
    V_CONTADOR    NUMBER;
    l_codsolot    number(8);
    l_customer_id number(8);
    a_idwf        number;
    a_idtareawf   number;
    a_tareadef    number;
    a_tarea       number;
    error_iw_getreport exception;
    error_general      EXCEPTION;
    v_flag number;

  BEGIN
    v_flag := 0;
    --Obtener SOT
    SP_BUSCA_CODSOLT_CUST(an_cod_id,l_codsolot,l_customer_id,an_error,av_error);

    --Si no existe SOT o CUSTOMER_ID mostrar error
    IF l_codsolot IS NULL or l_customer_id IS NULL then
      av_error := ' No se encontro SOT o CUSTOMER_ID ' || av_error;
      RAISE error_general;
    END IF;

    --Validar si contrato no esta activo
    SELECT C.CH_STATUS
      INTO V_CH_STATUS
      FROM CONTRACT_HISTORY@DBL_BSCS_BF C
     WHERE C.CO_ID = an_cod_id
       AND C.CH_SEQNO = (SELECT MAX(CH_SEQNO) FROM CONTRACT_HISTORY@DBL_BSCS_BF
                          WHERE CO_ID = an_cod_id AND CH_PENDING IS NULL);

    IF upper(V_CH_STATUS) = 'O' then
      --Validar si cuenta con datos en provision
        IF F_VAL_REGISTRO_BSCS(an_cod_id,'REGULAR') = 0 THEN
          av_error := 'Servicio no se encuentra provisionado';
          RAISE error_general;
        ELSE
            IF F_VAL_REGISTRO_BSCS(an_cod_id,'BAJA_BSCS') = 0 THEN
              av_error := 'No se encuentra comando de activacion';
              RAISE error_general;
            ELSE
              --Validar si equipos se encuentra regularizado
              --VALIDAR LOS SERVICIOS DE LA SOT
              declare
               CURSOR servicios IS
                    SELECT tip_interfase,id_interfase FROM OPERACION.TRS_INTERFACE_IW
                    WHERE codsolot = l_codsolot
                    AND id_interfase IN (SELECT o.codigon FROM operacion.opedd o WHERE o.abreviacion='SERV')
                    GROUP BY tip_interfase,id_interfase;
               begin
                 for c_serv in servicios loop
                    IF F_VALIDAR_SERVICIOS(l_codsolot,c_serv.id_interfase) > 0 THEN
                        v_flag := 0;
                    ELSE
                        v_flag   := 1;
                        av_error := 'Equipo ' || c_serv.tip_interfase || ' no se encuentra activo';
                        RAISE error_general;
                    END IF;
                 end loop;
               end;
            END IF;
        END IF;

      if v_flag = 0 then
        select w.idwf, f.idtareawf, f.tareadef, f.tarea
          into a_idwf, a_idtareawf, a_tareadef, a_tarea
          from solot s, tareawf f, wf w
         where w.idwf = f.idwf
           and s.codsolot = w.codsolot
           and w.codsolot = l_codsolot
           and f.tareadef = 1020
           and w.valido = 1;

        begin
          OPERACION.PQ_IW_SGA_BSCS.p_inicio_fact(a_idtareawf,
                                                 a_idwf,
                                                 a_tarea,
                                                 a_tareadef);
        end;

        av_error := 'Éxito en el proceso';
        an_Error := 0;

        p_reg_log(an_cod_id,
                  NULL,
                  NULL,
                  NULL,
                  NULL,
                  an_error,
                  av_error,
                  an_cod_id,
                  'Inicio de Facturacion BSCS');

      END IF;
    -- ini 5.0
    ELSif upper(V_CH_STATUS) = 'A' then
      av_error := 'Contrato ya se encuentra Activo';
      an_Error := 0;

      p_reg_log(an_cod_id,
                  NULL,
                  NULL,
                  NULL,
                  NULL,
                  an_error,
                  av_error,
                  an_cod_id,
                  'Inicio de Facturacion BSCS');

      begin
        select w.idwf, f.idtareawf, f.tareadef, f.tarea
            into a_idwf, a_idtareawf, a_tareadef, a_tarea
            from solot s, tareawf f, wf w
           where w.idwf = f.idwf
             and s.codsolot = w.codsolot
             and w.codsolot = l_codsolot
             and f.tareadef = 1020
             and w.valido = 1;

          begin
            OPERACION.PQ_IW_SGA_BSCS.p_inicio_fact(a_idtareawf,
                                                   a_idwf,
                                                   a_tarea,
                                                   a_tareadef);
          end;

          av_error := 'Éxito en el proceso';
          an_Error := 0;

       exception
         when others then
           av_error := 'Éxito en el proceso - Servicios Activos';
           an_Error := 0;
       end;


        p_reg_log(an_cod_id,
                  NULL,
                  NULL,
                  NULL,
                  NULL,
                  an_error,
                  av_error,
                  an_cod_id,
                  'Inicio de Facturacion BSCS');
    END IF;
    -- fin 5.0
  EXCEPTION
    WHEN error_general THEN
      an_Error := -1;

      p_reg_log(l_customer_id,
                null,
                NULL,
                l_codsolot,
                null,
                an_error,
                av_error,
                an_cod_id,
                'Inicio Facturacion BSCS-SGA-IW');
    WHEN error_iw_getreport THEN
      av_error := 'Error al obtener la informacion de IW : ' || av_error;
      an_Error := -19;
      p_reg_log(l_customer_id,
                null,
                NULL,
                l_codsolot,
                null,
                an_Error,
                av_error,
                an_cod_id,
                'Inicio Facturacion  BSCS-SGA-IW');
    WHEN OTHERS THEN
      av_error := 'ERROR: ' || SQLERRM  ||
                  ' Linea : ('||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||')'; --LFO
      an_Error := sqlcode;
      p_reg_log(l_customer_id,
                null,
                NULL,
                l_codsolot,
                null,
                an_Error,
                av_error,
                an_cod_id,
                'Inicio Facturacion  BSCS-SGA-IW');

  END P_ACTIVARFACTURACION;

  PROCEDURE P_CARGA_SERVICIOS_HFC IS
    l_var1 number;
    l_var2 number;
    l_var3 number;
    v_unico number;
    l_sql   varchar2(100);

    cursor cur1 is
      select distinct i.codcli,
                      i.tipsrv,
                      i.codsrv,
                      t.dscsrv servicio,
                      i.tipinssrv,
                      t.idproducto,
                      t.codigo_ext,
                      i.codinssrv,
                      i.estinssrv,
                      i.numero,
                      i.numsec,
                      (select q.plan
                         from tystabsrv ty, plan_redint q
                        where ty.codsrv = i.codsrv
                          and ty.idplan = q.idplan) codplan_b,
                      (select q.plan_opcional
                         from tystabsrv ty, plan_redint q
                        where ty.codsrv = i.codsrv
                          and ty.idplan = q.idplan) codplan_o,
                      decode(t.codigo_ext,
                             '87',
                             'JANUS',
                             '20',
                             'ABIERTO',
                             21,
                             'TELLIN',
                             null) plataforma,
                           nvl((select o.codigon_aux
                              from tipopedd t, opedd o
                              where t.tipopedd =  o.tipopedd
                              and t.abrev = 'IDPRODTLFCARGAMASIVA'
                              and o.codigon = p.idproducto), 0) flg_sistema
        from inssrv i, tystabsrv t, producto p
       where i.codsrv = t.codsrv
         and t.idproducto = p.idproducto
         and i.tipinssrv = 3
         and p.idproducto in (select o.codigon
                              from tipopedd t, opedd o
                              where t.tipopedd =  o.tipopedd
                              and t.abrev = 'IDPRODTLFCARGAMASIVA');

    cursor cur2 is
      select a.numero, count(*)
        from operacion.tab_servicios_hfc a
       where a.numero is not null
       group by a.numero
      having count(*) = 1;

    cursor cur3 is
      select a.numero, count(*)
        from operacion.tab_servicios_hfc a
       where a.numero is not null
       group by a.numero
      having count(*) > 1;

    cursor cur3a(p_numero in operacion.inssrv.numero%type) is
      select a.estinssrv,
             max(a.codinssrv) codinssrv,
             decode(a.estinssrv, 1, 1, 2, 2, 4, 3, 3, 4) orden
        from operacion.tab_servicios_hfc a
       where a.numero = p_numero
       group by a.estinssrv
       order by orden;

    cursor cur5 is
      select i.codinssrv,
             max(s.codsolot) codsolot,
             count(distinct s.codsolot) cant_sot
        from operacion.tab_servicios_hfc a,
             solot                       s,
             solotpto                    sp,
             tiptrabajo                  t,
             inssrv                      i
       where a.codinssrv = sp.codinssrv
         and sp.codinssrv = i.codinssrv
         and i.tipinssrv = 3
         and sp.codsolot = s.codsolot
         and s.tiptra = t.tiptra
         and t.tiptra not in (select o.codigon from tipopedd t, opedd o
                              where t.tipopedd =  o.tipopedd
                              and t.abrev = 'TIPTRATLFCARGAMASIVA')
         and t.tiptrs = 1
         and a.flg_unico = 1
       group by i.codinssrv;

    cursor cur6(p_codsolot in operacion.solot.codsolot%type) is
      select s.estsol,
             s.customer_id,
             s.cod_id,
             s.cod_id_old,
             s.tiptra,
             s.fecultest
        from solot s, tiptrabajo t
       where s.codsolot = p_codsolot
         and s.tiptra = t.tiptra;

  BEGIN

    l_var1 := 0;
    l_var2 := 0;
    l_var3 := 0;

    l_sql := 'truncate table operacion.tab_servicios_hfc';
    execute immediate l_sql;
    commit;

    for c1 in cur1 loop

      insert into operacion.tab_servicios_hfc
        (codcli,
         tipsrv,
         codsrv,
         servicio,
         tipinssrv,
         idproducto,
         codigo_ext,
         codinssrv,
         estinssrv,
         numero,
         numsec,
         codplan_b,
         codplan_o,
         plataforma,
         flg_sistema)
      values
        (c1.codcli,
         c1.tipsrv,
         c1.codsrv,
         c1.servicio,
         c1.tipinssrv,
         c1.idproducto,
         c1.codigo_ext,
         c1.codinssrv,
         c1.estinssrv,
         c1.numero,
         c1.numsec,
         c1.codplan_b,
         c1.codplan_o,
         c1.plataforma,
         c1.flg_sistema);

      l_var1 := l_var1 + 1;

      if l_var1 = 1000 then
        l_var1 := 0;
        commit;
      end if;
    end loop;
    commit;

    for c2 in cur2 loop

      update operacion.tab_servicios_hfc b
         set b.flg_unico = 1
       where b.numero = c2.numero;

      l_var2 := l_var2 + 1;

      if l_var2 = 1000 then
        l_var2 := 0;
        commit;
      end if;
    end loop;
    commit;

    for c3 in cur3 loop
      v_unico := 0;

      for c3a in cur3a(c3.numero) loop

        if c3a.estinssrv = 1 and v_unico = 0 then
          update operacion.tab_servicios_hfc b
             set b.flg_unico = 1
           where b.codinssrv = c3a.codinssrv;
          v_unico := 1;
          commit;
        end if;
        if c3a.estinssrv = 2 and v_unico = 0 then
          update operacion.tab_servicios_hfc b
             set b.flg_unico = 1
           where b.codinssrv = c3a.codinssrv;
          v_unico := 1;
          commit;
        end if;
        if c3a.estinssrv = 4 and v_unico = 0 then
          update operacion.tab_servicios_hfc b
             set b.flg_unico = 1
           where b.codinssrv = c3a.codinssrv;
          v_unico := 1;
          commit;
        end if;
        if c3a.estinssrv = 3 and v_unico = 0 then
          update operacion.tab_servicios_hfc b
             set b.flg_unico = 1
           where b.codinssrv = c3a.codinssrv;
          v_unico := 1;
          commit;
        end if;
      end loop;

      l_var3 := l_var3 + 1;

      if l_var3 = 200 then
        l_var3 := 0;
        commit;
      end if;
    end loop;
    commit;

    -- bucle que recorre todas las instancias
    for c5 in cur5 loop

      -- bucle que recorre cada instancia del servicio
      for c6 in cur6(c5.codsolot) loop

        update operacion.tab_servicios_hfc b
           set b.codsolot    = c5.codsolot,
               b.num_sot     = c5.cant_sot,
               b.estsol      = c6.estsol,
               b.co_id       = c6.cod_id,
               b.co_id_old   = c6.cod_id_old,
               b.tiptra      = c6.tiptra,
               b.customer_id = c6.customer_id,
               b.fecultest   = c6.fecultest
         where b.codinssrv = c5.codinssrv
           and b.flg_unico = 1;
        commit;

      end loop;
      commit;
    end loop;
    commit;
  END P_CARGA_SERVICIOS_HFC;

  PROCEDURE P_CARGA_EQUIPOS_HFC IS
    l_sql  varchar2(100);
    cursor cur8 is
      select p.co_id,
             p.seqno,
             p.id_producto,
             p.id_producto_padre,
             p.estado_recurso,
             p.mac_address
        from tim.Pf_Hfc_Internet@DBL_BSCS_BF p;

    cursor cur9 is
      select p.co_id,
             p.seqno,
             p.id_producto,
             p.id_producto_padre,
             p.estado_recurso,
             p.mac_address,
             p.mta_model_crm_id
        from tim.Pf_Hfc_Telefonia@DBL_BSCS_BF p;

    cursor cur10 is
      select p.co_id,
             p.seqno,
             p.id_producto,
             p.id_producto_padre,
             p.estado_recurso,
             p.serial_number,
             p.stb_type_crm_id,
             p.unit_address,
             p.send_to_ctlr
        from tim.Pf_Hfc_Cable_Tv@DBL_BSCS_BF p;

    cursor cur11 is
      select iw.codsolot,
             iw.cod_id,
             iw.idtrs,
             iw.tip_interfase,
             iw.modelo,
             iw.mac_address,
             iw.unit_address,
             iw.codigo_ext,
             iw.id_producto_padre,
             iw.id_producto
        from OPERACION.TRS_INTERFACE_IW iw
       where iw.id_interfase in (620, 820, 2020)
       order by iw.codsolot;

    cursor cur12 is
      select iw.codsolot,
             iw.codinssrv,
             iw.id_interfase,
             iw.modelo,
             iw.macaddress,
             iw.serialnumber,
             iw.codigo_ext,
             iw.id_producto_padre,
             iw.id_producto,
             iw.estado
        from INTRAWAY.INT_SERVICIO_INTRAWAY iw
       where iw.id_interfase in (620, 820, 2020)
       order by iw.codsolot;

  BEGIN

    l_sql := 'truncate table OPERACION.tab_equipos_sga_bscs';
    execute immediate l_sql;
    commit;

    COMMIT;
    --Traer Datos BSCS
    for c8 in cur8 loop
      insert into operacion.tab_equipos_sga_bscs
        (co_id,
         tipo_serv,
         seqno,
         id_producto,
         id_producto_padre,
         estado,
         CAMPO01,
         PLATAFORMA)
      VALUES
        (c8.co_id,
         'INT',
         c8.seqno,
         c8.id_producto,
         c8.id_producto_padre,
         c8.estado_recurso,
         c8.mac_address,
         'BSCS');
    end loop;

    COMMIT;

    For c9 in cur9 loop
      insert into operacion.tab_equipos_sga_bscs
        (co_id,
         tipo_serv,
         seqno,
         id_producto,
         id_producto_padre,
         estado,
         CAMPO01,
         CAMPO02,
         PLATAFORMA)
      VALUES
        (c9.co_id,
         'TLF',
         c9.seqno,
         c9.id_producto,
         c9.id_producto_padre,
         c9.estado_recurso,
         c9.mac_address,
         c9.mta_model_crm_id,
         'BSCS');
    end loop;

    COMMIT;

    for c10 in cur10 loop
      insert into OPERACION.tab_equipos_sga_bscs
        (co_id,
         tipo_serv,
         seqno,
         id_producto,
         id_producto_padre,
         estado,
         CAMPO01,
         CAMPO02,
         CAMPO03,
         CAMPO04,
         PLATAFORMA)
      VALUES
        (c10.co_id,
         'CTV',
         c10.seqno,
         c10.id_producto,
         c10.id_producto_padre,
         c10.estado_recurso,
         c10.serial_number,
         c10.stb_type_crm_id,
         c10.unit_address,
         c10.send_to_ctlr,
         'BSCS');
    end loop;

    COMMIT;

    --Traer Datos SGA
    for c11 in cur11 loop
      insert into OPERACION.tab_equipos_sga_bscs
        (codsolot,
         co_id,
         tipo_serv,
         seqno,
         id_producto,
         id_producto_padre,
         estado,
         CAMPO01,
         CAMPO02,
         CAMPO03,
         CAMPO04,
         PLATAFORMA)
      VALUES
        (c11.codsolot,
         c11.cod_id,
         c11.tip_interfase,
         c11.idtrs,
         c11.id_producto,
         c11.id_producto_padre,
         null,
         c11.mac_address,
         c11.modelo,
         c11.unit_address,
         c11.codigo_ext,
         'SGA');
    end loop;
    COMMIT;

    --Traer Datos SGA puro
    for c12 in cur12 loop
      if c12.id_interfase <> 2020 then
        insert into OPERACION.tab_equipos_sga_bscs
          (codsolot,
           co_id,
           tipo_serv,
           seqno,
           id_producto,
           id_producto_padre,
           estado,
           CAMPO01,
           CAMPO02,
           CAMPO03,
           CAMPO04,
           PLATAFORMA)
        VALUES
          (c12.codsolot,
           c12.codinssrv,
           c12.id_interfase,
           NULL,
           c12.id_producto,
           c12.id_producto_padre,
           c12.estado,
           c12.macaddress,
           c12.modelo,
           null,
           c12.codigo_ext,
           'SGA');
      else
        insert into OPERACION.tab_equipos_sga_bscs
          (codsolot,
           co_id,
           tipo_serv,
           seqno,
           id_producto,
           id_producto_padre,
           estado,
           CAMPO01,
           CAMPO02,
           CAMPO03,
           CAMPO04,
           PLATAFORMA)
        VALUES
          (c12.codsolot,
           c12.codinssrv,
           c12.id_interfase,
           NULL,
           c12.id_producto,
           c12.id_producto_padre,
           c12.estado,
           c12.serialnumber,
           c12.modelo,
           null,
           c12.codigo_ext,
           'SGA');
      end if;
    end loop;

    COMMIT;

  END P_CARGA_EQUIPOS_HFC;

  PROCEDURE P_CARGA_MASIVA_BSCS IS
  l_var1       number;
    l_sql       varchar2(100);
    v_unico     number;
    v_unico1    number;
    v_codinssrv number;
    v_numero    varchar(20);
    cod_plan    number;
    desc_plan   varchar2(200);
    v_tieneint  number;
    v_tienetlf  number;
    v_tienectv  number;
    VSQL varchar2(4000);


    c_cursor t_cursor;

    co_id number;
    customer_id number;
    ciclo varchar2(10);
    ch_status varchar2(20);
    ch_pending varchar2(20);
    dn_num varchar2(20);
    codplan number;
    flg_es_alta number;
    flg_csc number;
    ch_validfrom date;

    cursor cur2 is
      select a.co_id, max(s.codsolot) codsolot, count(1) cant_sot
        from operacion.tab_contract_bscs a, solot s, tiptrabajo t
       where a.co_id = s.cod_id
         and s.tiptra = t.tiptra
         and t.tiptrs = 1
         and t.tiptra not in (SELECT o.codigon FROM operacion.opedd o WHERE o.abreviacion='TIPTRA_SGA')
       group by a.co_id;

    cursor cur3(p_codsolot in operacion.solot.codsolot%type) is
      select distinct s.codcli,
                      i.estinssrv,
                      s.estsol,
                      s.cod_id_old,
                      s.customer_id,
                      s.tiptra,
                      trunc(s.fecultest) fecultest,
                      i.tipinssrv
        from solot s, solotpto sp, inssrv i
       where s.codsolot = sp.codsolot
         and sp.codinssrv = i.codinssrv
         and s.codsolot = p_codsolot
       order by i.tipinssrv desc;

    -- Ini 2.0
    cursor cur4 is
      select a.dn_num, count(1)
        from operacion.tab_contract_bscs a
       where a.dn_num is not null
       group by a.dn_num
      having count(1) = 1;

    cursor cur5 is
      select a.dn_num, count(1)
        from operacion.tab_contract_bscs a
       where a.dn_num is not null
       group by a.dn_num
      having count(1) > 1;

    cursor cur5a(p_dn_num in operacion.tab_contract_bscs.dn_num%type) is
      select a.ch_status,
             max(a.co_id) co_id,
             decode(a.ch_status, 'a', 1, 's', 2, 'o', 3, 'd', 4) orden
        from operacion.tab_contract_bscs a
       where a.dn_num = p_dn_num
       group by a.ch_status
       order by orden asc;

    cursor cur6 is
      SELECT DISTINCT NUM03 FROM OPERACION.TAB_CONTRACT_BSCS;

  BEGIN

    l_var1:=0;

    /*CARGA DE BSCS*/
    VSQL:='select c.co_id,
             c.customer_id,
             cu.billcycle ciclo,
             a.ch_status,
             a.ch_pending,
             a.ch_validfrom,
             (select n.dn_num
                from contr_services_cap@dbl_bscs_bf csc,
                     directory_number@dbl_bscs_bf   n
               where csc.dn_id = n.dn_id
                 and csc.cs_activ_date =
                     (select max(b.cs_activ_date)
                        from contr_services_cap@dbl_bscs_bf b
                       where b.co_id = csc.co_id) --2.0
                 and csc.co_id = c.co_id
                 and rownum = 1) dn_num,
             (select x.codplan
                from (select h.cod_prod1 sncode,
                             h.param1 codplan,
                            ''B'' tipoplan
                        from tim.pf_hfc_parametros@dbl_bscs_bf h
                       where h.campo = ''SERV_TELEFONIA'') x,
                     mpusntab@dbl_bscs_bf sn,

                     profile_service@dbl_bscs_bf ps
               where ps.sncode = sn.sncode
                 and sn.sncode = x.sncode
                 and ps.co_id = c.co_id
                 and rownum = 1) codplan,
             -- ini 2.0
             case
               when (select count(1)
                       from contract_history@DBL_BSCS_BF r
                      where r.co_id = a.co_id
                        and r.ch_status = ''a'') = 0 then
                1
               when ((select count(1)
                        from contract_history@DBL_BSCS_BF r
                       where r.co_id = a.co_id
                         and r.ch_status = ''a'') = 1 and
                    decode(a.ch_status, ''s'', 0, ''d'', 0, 1) = 1) then
                1
               else
                0
             end flg_es_alta,
             (select count(1)
                from contr_services_cap@dbl_bscs_bf csc,
                     directory_number@dbl_bscs_bf   n
               where csc.dn_id = n.dn_id
                 and csc.cs_activ_date =
                     (select max(b.cs_activ_date)
                        from contr_services_cap@dbl_bscs_bf b
                       where b.co_id = csc.co_id)
                 and csc.co_id = c.co_id) flg_csc
      -- Fin 2.0
        from contract_all@dbl_bscs_bf     c,
             contract_history@dbl_bscs_bf a,
             customer_all@dbl_bscs_bf     cu
       where c.sccode = 6
         and c.co_id = a.co_id
         and c.customer_id = cu.customer_id
         and a.ch_seqno = (select max(b.ch_seqno) from contract_history@dbl_bscs_bf b where b.co_id = a.co_id)
         and c.co_id NOT IN (SELECT th.co_id FROM operacion.tab_contract_bscs_HISTORY th WHERE th.tipo_opera=''CNF'')'  ;

    --TRUNCAR LA TABLA
    l_sql := 'truncate table operacion.tab_contract_bscs';
    execute immediate l_sql;
    commit;


    OPEN c_cursor for VSQL;
    loop
    fetch c_cursor into co_id,customer_id,ciclo,ch_status,ch_pending,ch_validfrom,dn_num,codplan,flg_es_alta,flg_csc;
    exit when
    c_cursor%notfound;

        insert into operacion.tab_contract_bscs
                  (co_id,
                   customer_id,
                   ciclo,
                   ch_status,
                   ch_pending,
                   dn_num,
                   codplan,
                   num10,
                   num09,
                   ch_validfrom)
                values
                  (co_id,
                   customer_id,
                   ciclo,
                   ch_status,
                   ch_pending,
                   dn_num,
                   codplan,
                   flg_es_alta,
                   flg_csc,
                   ch_validfrom); -- 2.0


                l_var1 := l_var1 + 1;

                if l_var1 = 1000 then
                  l_var1 := 0;
                  commit;
                end if;

    end loop;
    close c_cursor;

    -- bucle que recorre todas las instancias
    for c2 in cur2 loop
      v_unico     := 0;
      v_numero    := null;
      v_codinssrv := null;

      --Consulta PLAN BSCS
      BEGIN
        SELECT DISTINCT RP.DES, RP.TMCODE
          INTO DESC_PLAN, COD_PLAN
          FROM RATEPLAN@DBL_BSCS_BF RP, CONTRACT_ALL@DBL_BSCS_BF CA
         WHERE CA.SCCODE = 6
           AND CA.CO_ID = C2.CO_ID
           AND CA.TMCODE = RP.TMCODE;
      EXCEPTION
        WHEN OTHERS THEN
          DESC_PLAN := '';
          COD_PLAN  := 0;
      END;

      for c3 in cur3(c2.codsolot) loop

        if c3.tipinssrv = 3 and v_unico = 0 then
          select distinct i.codinssrv, i.numero
            into v_codinssrv, v_numero
            from solot s, solotpto sp, inssrv i
           where s.codsolot = sp.codsolot
             and sp.codinssrv = i.codinssrv
             and s.codsolot = c2.codsolot
             and i.tipinssrv = 3;

          update operacion.tab_contract_bscs b
             set b.codsolot    = c2.codsolot,
                 b.num01       = c2.cant_sot,
                 b.estsol      = c3.estsol,
                 b.co_id_old   = c3.cod_id_old,
                 b.customer_id = c3.customer_id,
                 b.var01       = c3.tiptra,
                 b.fecultest   = c3.fecultest,
                 b.codinssrv   = v_codinssrv,
                 b.estinssrv   = c3.estinssrv,
                 b.codcli      = c3.codcli,
                 b.numero      = v_numero,
                 b.num08       = 1, --2.0,
                 b.num03       = cod_plan,
                 b.var03       = desc_plan
           where b.co_id = c2.co_id;
          commit;
          v_unico := 1;
        end if;
        if c3.tipinssrv = 1 and v_unico = 0 then

          select distinct i.codinssrv, i.numero
            into v_codinssrv, v_numero
            from solot s, solotpto sp, inssrv i
           where s.codsolot = sp.codsolot
             and sp.codinssrv = i.codinssrv
             and s.codsolot = c2.codsolot
             and i.tipinssrv = 1
             and rownum = 1;

          update operacion.tab_contract_bscs b
             set b.codsolot    = c2.codsolot,
                 b.num01       = c2.cant_sot,
                 b.estsol      = c3.estsol,
                 b.co_id_old   = c3.cod_id_old,
                 b.customer_id = c3.customer_id,
                 b.var01       = c3.tiptra,
                 b.fecultest   = c3.fecultest,
                 b.codinssrv   = v_codinssrv,
                 b.estinssrv   = c3.estinssrv,
                 b.codcli      = c3.codcli,
                 b.numero      = v_numero,
                 b.num08       = 0,
                 b.num03       = cod_plan,
                 b.var03       = desc_plan
           where b.co_id = c2.co_id;
          commit;
          v_unico := 1;
        end if;

      end loop;
      commit;
    end loop;
    commit;

    -- Ini 2.0
    for c4 in cur4 loop
      update operacion.tab_contract_bscs b
         set b.flg_unico = 1
       where b.dn_num = c4.dn_num;
    end loop;
    commit;

    for c5 in cur5 loop
      v_unico1 := 0;

      for c5a in cur5a(c5.dn_num) loop
        if c5a.ch_status = 'a' and v_unico1 = 0 then
          update operacion.tab_contract_bscs b
             set b.flg_unico = 1
           where b.co_id = c5a.co_id;
          v_unico1 := 1;
        end if;
        if c5a.ch_status = 's' and v_unico1 = 0 then
          update operacion.tab_contract_bscs b
             set b.flg_unico = 1
           where b.co_id = c5a.co_id;
          v_unico1 := 1;
        end if;
        if c5a.ch_status = 'o' and v_unico1 = 0 then
          update operacion.tab_contract_bscs b
             set b.flg_unico = 1
           where b.co_id = c5a.co_id;
          v_unico1 := 1;
        end if;
        if c5a.ch_status = 'd' and v_unico1 = 0 then
          update operacion.tab_contract_bscs b
             set b.flg_unico = 1
           where b.co_id = c5a.co_id;
          v_unico1 := 1;
        end if;
        commit;
      end loop;
    end loop;
    commit;

    for c6 in cur6 loop

      select count(1)
        into v_tieneint
        from tipopedd t, opedd o
       where t.tipopedd = o.tipopedd
         and t.abrev = 'PLANBSCSINT'
         and o.codigon = c6.num03;

      select count(1)
        into v_tienetlf
        from tipopedd t, opedd o
       where t.tipopedd = o.tipopedd
         and t.abrev = 'PLANBSCSTLF'
         and o.codigon = c6.num03;

      select count(1)
        into v_tienectv
        from tipopedd t, opedd o
       where t.tipopedd = o.tipopedd
         and t.abrev = 'PLANBSCSCTV'
         and o.codigon = c6.num03;

      update operacion.tab_contract_bscs
         set num04 = v_tieneint, num05 = v_tienetlf, num06 = v_tienectv
       where num03 = c6.num03;
    end loop;

    commit;

  END P_CARGA_MASIVA_BSCS;

  PROCEDURE SP_CARGA_MASIVA_HISTORICO
  is
  l_var2 number;

  an_error number;
  av_error VARCHAR(200);

  begin
   declare
    VSQL VARCHAR(3000);
     CONDICION VARCHAR(200);
    c_cursor t_cursor;
    fila tab_contract_bscs%ROWTYPE;
   begin
    /*OBTENER LA CONDICION DESDE PARAMETROS*/
    SELECT F.OBS INTO CONDICION FROM OPERACION.CONSTANTE F WHERE F.CONSTANTE='CONDICION_BSCS';

    VSQL:='SELECT a.* FROM operacion.tab_contract_bscs a, estsol e
           WHERE a.estsol = e.estsol ' || CONDICION || ' AND NOT EXISTS
           (SELECT h.co_id FROM operacion.tab_contract_bscs_history h WHERE h.co_id=a.co_id)';

     OPEN c_cursor for VSQL;
      loop
      fetch c_cursor into fila;
      exit when c_cursor%notfound;

           insert into operacion.tab_contract_bscs_history
                      (TIPO_OPERA,
                       FECH_OPERA,
                       CUSTOMER_ID,
                       CODSOLOT,
                       CO_ID,
                       CO_ID_OLD,
                       CODCLI,
                       NUMERO,
                       ESTSOL,
                       CICLO,
                       CODPLAN,
                       DN_NUM,
                       CODINSSRV,
                       CH_STATUS,
                       CH_PENDING,
                       ESTINSSRV,
                       FECULTEST,
                       FLG_UNICO,
                       DESCRIPCION,
                       OBSERVACION,
                       TRANSACCION,
                       NUM01,
                       NUM02,
                       NUM03,
                       NUM04,
                       NUM05,
                       NUM06,
                       NUM07,
                       NUM08,
                       NUM09,
                       NUM10,
                       VAR01,
                       VAR02,
                       VAR03,
                       VAR04,
                       VAR05,
                       VAR06,
                       VAR07,
                       VAR08,
                       VAR09,
                       VAR10,
                       VAR11,
                       VAR12,
                       CODUSU,
                       FECUSU)
                    values
                      ('CNF',
                       sysdate(),
                       fila.CUSTOMER_ID,
                       fila.CODSOLOT,
                       fila.CO_ID,
                       fila.CO_ID_OLD,
                       fila.CODCLI,
                       fila.NUMERO,
                       fila.ESTSOL,
                       fila.CICLO,
                       fila.CODPLAN,
                       fila.DN_NUM,
                       fila.CODINSSRV,
                       fila.CH_STATUS,
                       fila.CH_PENDING,
                       fila.ESTINSSRV,
                       fila.FECULTEST,
                       fila.FLG_UNICO,
                       fila.DESCRIPCION,
                       fila.OBSERVACION,
                       fila.TRANSACCION,
                       fila.NUM01,
                       fila.NUM02,
                       fila.NUM03,
                       fila.NUM04,
                       fila.NUM05,
                       fila.NUM06,
                       fila.NUM07,
                       fila.NUM08,
                       fila.NUM09,
                       fila.NUM10,
                       fila.VAR01,
                       fila.VAR02,
                       fila.VAR03,
                       fila.VAR04,
                       fila.VAR05,
                       fila.VAR06,
                       fila.VAR07,
                       fila.VAR08,
                       fila.VAR09,
                       fila.VAR10,
                       fila.VAR11,
                       fila.VAR12,
                       fila.CODUSU,
                       fila.FECUSU);

                    l_var2 := l_var2 + 1;

                    if l_var2 = 1000 then
                      l_var2 := 0;
                      commit;
                    end if;

      end loop;
      close c_cursor;
       end;
    ---Eliminación de historico de Carga Masiva
    operacion.PQ_CONT_REGULARIZACION.SP_DELETE_HISTORICO('HISTCMASIVO',an_error,av_error);

  END SP_CARGA_MASIVA_HISTORICO;

  PROCEDURE P_HISTORIAL_CONTRATO(a_cod_id in number,

                                 o_resultado out T_CURSOR) IS
    V_CURSOR T_CURSOR;
  BEGIN
    OPEN V_CURSOR FOR
      SELECT CO_ID,
             CH_SEQNO,
             CH_STATUS,
             CH_VALIDFROM,
             CH_PENDING,
             ENTDATE,
             USERLASTMOD,
             REQUEST,
             RS_DESC
        FROM CONTRACT_HISTORY@DBL_BSCS_BF C,
             REASONSTATUS_ALL@DBL_BSCS_BF RA
       WHERE C.CH_REASON = RA.RS_ID
         AND C.CO_ID = a_cod_id;

    o_resultado := V_CURSOR;

  END P_HISTORIAL_CONTRATO;

  procedure P_REG_LOG(ac_codcli      OPERACION.SOLOT.CODCLI%type,
                      an_customer_id number,
                      an_idtrs       number,
                      an_codsolot    number,
                      an_idinterface number,
                      an_error       number,
                      av_texto       varchar2,
                      an_cod_id      number default 0,
                      av_proceso     varchar default '') is
    pragma autonomous_transaction;
  begin
    insert into OPERACION.LOG_TRS_INTERFACE_IW
      (CODCLI,
       IDTRS,
       CODSOLOT,
       IDINTERFACE,
       ERROR,
       TEXTO,
       CUSTOMER_ID,
       COD_ID,
       PROCESO)
    values
      (ac_codcli,
       an_idtrs,
       an_codsolot,
       an_idinterface,
       an_error,
       av_texto,
       an_customer_id,
       an_cod_id,
       av_proceso);
    commit;
  end P_REG_LOG;

  function F_CONS_NUMERO_BSCS(t_numero number) return varchar2 is
    l_macr varchar2(10);
  BEGIN

    select co.customer_id
      into l_macr
      from directory_number@DBL_BSCS_BF   dn,
           contr_services_cap@DBL_BSCS_BF cp,
           contract_all@DBL_BSCS_BF       co,
           curr_co_status@DBL_BSCS_BF     ch
     where dn.dn_num in (t_numero)
       and cp.dn_id = dn.dn_id
       and co.co_id = cp.co_id
       and ch.CH_STATUS not in ('d')
       and ch.co_id = co.co_id;

    return l_macr;

  exception
    when others then
      l_macr := null;
      return l_macr;
  END;

  function F_CONS_NUMERO_BSCS_CO_ID(co_id number) return varchar2 is
    l_macr varchar2(100);
  BEGIN
    select dn_num
      into l_macr
      from directory_number@DBL_BSCS_BF   dn,
           contr_services_cap@DBL_BSCS_BF cp
     where cp.co_id = co_id
       and dn.dn_id = cp.dn_id;

    return l_macr;
  END;

  function f_macroestado(l_estsol in number) return varchar2 is
    l_macr varchar2(50);
  begin

    select macro_estado
      into l_macr
      from (select estsol, 'Rechazada' macro_estado
              from estsol
             where tipestsol = 7
            union
            select estsol, 'Anulada' macro_estado
              from estsol
             where tipestsol = 5
            union
            select estsol, 'Cerrada' macro_estado
              from estsol
             where tipestsol = 4
            union
            select estsol, 'Cerrada' macro_estado
              from estsol
             where estsol = 29
            union
            select estsol, 'En Ejecución' macro_estado
              from estsol
             where estsol in (17, 64, 65, 66, 67, 68, 69, 82, 11, 9)
            union
            select estsol, 'Rechazada' macro_estado
              from estsol
             where tipestsol = 3
            union
            select estsol, 'Anulada' macro_estado
              from estsol
             where estsol = 22)
     where estsol = l_estsol;
    return l_macr;
  exception
    when others then

      select t.descripcion
        into l_macr
        from estsol e, tipestsol t
       where e.tipestsol = t.tipestsol
         and e.estsol = l_estsol;
      return l_macr;
  end;

  function f_val_pendiente_provision(an_cod_id number) return number is
    ln_pendiente_provision number;
  begin

    select count(distinct(co_id))
      into ln_pendiente_provision
      from tim.pf_hfc_prov_bscs@dbl_bscs_bf c
     where c.co_id = an_cod_id
       and c.action_id in (1, 2, 8);

    return ln_pendiente_provision;
  end;

  function f_val_contrato_activo(an_cod_id number) return number is
    ln_contrato_act number;
  begin
    select count(1)
      into ln_contrato_act
      from contract_history@dbl_bscs_bf c
     where c.ch_seqno = (select max(d.ch_seqno)
                           from contract_history@dbl_bscs_bf d
                          where d.ch_status = 'a'
                            and d.ch_pending is null
                            and d.co_id = c.co_id)
       and c.co_id = an_cod_id;

    return ln_contrato_act;
  end;

  function f_val_tipo_servicio_bscs(sncode number) return varchar2 is
    ln_contador number;
    lv_sncode   varchar2(20);
  begin
    lv_sncode := to_char(sncode);

    SELECT count(1)
      into ln_contador
      FROM ATCPARAMETER A
     WHERE A.CODPARAMETER = 'TLFBSCS_SERV'
       AND substr(A.VALUE, instr(A.VALUE, lv_sncode), length(lv_sncode)) =
           lv_sncode;

    if ln_contador = 1 then
      return 'TLF';
    end if;

    SELECT count(1)
      into ln_contador
      FROM ATCPARAMETER A
     WHERE A.CODPARAMETER = 'INTBSCS_SERV'
       AND substr(A.VALUE, instr(A.VALUE, lv_sncode), length(lv_sncode)) =
           lv_sncode;

    if ln_contador = 1 then
      return 'INT';
    end if;

    SELECT count(1)
      into ln_contador
      FROM ATCPARAMETER A
     WHERE A.CODPARAMETER = 'CTVBSCS_SERV'
       AND substr(A.VALUE, instr(A.VALUE, lv_sncode), length(lv_sncode)) =
           lv_sncode;

    if ln_contador = 1 then
      return 'CTV';
    end if;

    return null;
  end;

  procedure p_chg_est_tareawf(an_codsolot number,
                              an_error    out integer,
                              av_error    out varchar2) is
    ln_contar    number;
    ll_idtareawf number;
    ldt_fecini   date;
    ldt_fecfin   date;
  begin
    ldt_fecfin := null;
    ldt_fecini := null;

    select count(1)
      into ln_contar
      from solot s
     where s.codsolot = an_codsolot
       and s.estsol = 17
       and s.tiptra in (select o.codigon
                          from tipopedd t, opedd o
                         where t.tipopedd = o.tipopedd
                           and t.abrev = 'TIPREGCONTIWSGABSCS');

    if ln_contar > 0 then

      select count(tareawf.idtareawf)
        into ln_contar
        from tareawf, wf, wfdef
       where tareawf.idwf = wf.idwf
         and wfdef.wfdef = wf.wfdef
         and wf.codsolot = an_codsolot
         and tareawf.tareadef = 299
         and tareawf.esttarea = 1
         and wf.valido = 1;

      if ln_contar > 0 then

        select tareawf.idtareawf
          into ll_idtareawf
          from tareawf, wf, wfdef
         where tareawf.idwf = wf.idwf
           and wfdef.wfdef = wf.wfdef
           and wf.codsolot = an_codsolot
           and tareawf.tareadef = 299
           and tareawf.esttarea = 1
           and wf.valido = 1;

        PQ_WF.P_CHG_STATUS_TAREAWF(ll_idtareawf,
                                   2,
                                   23,
                                   0,
                                   ldt_fecini,
                                   ldt_fecfin);
      end if;
    end if;

    an_error := 0;
    av_error := 'Exito en el Cambio de Estado a la Tarea';

  exception
    when others then
      an_error := -1;
      av_error := 'ERROR en el Cambio de Estado a la Tarea : ' ||
                  to_char(sqlerrm);
  end;

  -- Procedimiento de baja de la linea telefonica en el janus.
  procedure p_bajanumero_janus(an_codsolot number,
                               an_error    out integer,
                               av_error    out varchar2) is
    ln_tiposerv number;
    ln_servtelefonia number;
  begin

    ln_servtelefonia := f_val_serv_tlf_sot(an_codsolot);
    if ln_servtelefonia = 1 then
      ln_tiposerv := operacion.pq_sga_iw.f_val_tipo_serv_sot(an_codsolot);

      if ln_tiposerv = 1 then -- HFC CE
            p_bajanumero_janus_sga_ce(an_codsolot, null,an_error,av_error);
      elsif ln_tiposerv = 2 then -- HFC SGA
            p_bajanumero_janus_sga(an_codsolot,an_error,av_error);
      elsif ln_tiposerv = 3 then -- HFC SISACT
            p_bajanumero_janus_bscs(an_codsolot,an_error,av_error);
      end if;
    else
      an_error := -1;
      av_error := 'La SOT no tiene el servicio de telefonia';
    end if;

  exception
    when others then
      an_error := -1;
      av_error := 'ERROR al enviar la baja del numero de Janus : ' ||
                  to_char(sqlerrm);
  end p_bajanumero_janus;

  -- Procedimiento de baja del cliente en janus
  procedure p_bajacliente_janus(an_codsolot number,
                                an_error    out integer,
                                av_error    out varchar2) is
    ln_tiposerv number;
    ln_servtelefonia number;

  begin
    ln_servtelefonia := f_val_serv_tlf_sot(an_codsolot);

    if ln_servtelefonia = 1 then
      ln_tiposerv := operacion.pq_sga_iw.f_val_tipo_serv_sot(an_codsolot);

      if ln_tiposerv = 1 then -- HFC CE
            p_bajacliente_janus_sga_ce(an_codsolot,an_error,av_error);
      elsif ln_tiposerv = 2 then -- HFC SGA
            p_bajacliente_janus_sga(an_codsolot,an_error,av_error);
      elsif ln_tiposerv = 3 then -- HFC SISACT
            p_bajacliente_janus_bscs(an_codsolot,an_error,av_error);
      end if;
    else
      an_error := -1;
      av_error := 'La SOT no tiene el servicio de telefonia';
    end if;

  exception
    when others then
      an_error := -1;
      av_error := 'ERROR al enviar la baja del cliente de Janus : ' ||
                  to_char(sqlerrm);
  end p_bajacliente_janus;

  --Procedimiento de alta de numero en Janus
  procedure p_altanumero_janus(an_codsolot number,
                               an_error    out integer,
                               av_error    out varchar2) is
    ln_tiposerv number;
    ln_servtelefonia number;
  begin

    ln_servtelefonia := f_val_serv_tlf_sot(an_codsolot);
    if ln_servtelefonia = 1 then

      ln_tiposerv := operacion.pq_sga_iw.f_val_tipo_serv_sot(an_codsolot);
      if ln_tiposerv = 1 then -- HFC CE
            p_altanumero_janus_sga_ce(an_codsolot,null,an_error,av_error);
      elsif ln_tiposerv = 2 then -- HFC SGA
            p_altanumero_janus_sga(an_codsolot,an_error,av_error);
      elsif ln_tiposerv = 3 then -- HFC SISACT
            p_altanumero_janus_bscs(an_codsolot,an_error,av_error);
      end if;
    else
      an_error := -1;
      av_error := 'La SOT no tiene el servicio de telefonia';
    end if;

  exception
    when others then
      an_error := -1;
      av_error := 'ERROR al enviar la provision del numero de Janus : ' ||
                  to_char(sqlerrm);
  end p_altanumero_janus;

  -- Funcion que valida si existe pendientes en la provision de baja para llanos
  function f_val_prov_janus_pend(an_cod_id number) return number is
    ln_janus_act number;
  begin
    select count(1)
      into ln_janus_act
      from dual
     where exists (select 1 from tim.rp_prov_bscs_janus@dbl_bscs_bf pj
                    where pj.co_id = an_cod_id)
         or exists (select 1 from tim.rp_prov_ctrl_janus@dbl_bscs_bf pj
                    where pj.estado_prv <> 5
                    and pj.co_id = an_cod_id) ;

    return ln_janus_act;
  end;

  -- Funcion para validar si se activa o desactiva los botones de llanos en la ventana de contigencia SGA
  function f_val_accion_janus_boton(an_codsolot number, av_accion varchar2)
    return number is
    ln_valida number;
    -- Ini 2.0
    ln_janus_act number;
    ln_cod_id    number;
    ln_valreg    number;

  begin

    ln_valida := 0;
    select s.cod_id
      into ln_cod_id
      from solot s
     where s.codsolot = an_codsolot;
    -- Fin 2.0
    select count(1)
      into ln_valreg
      from operacion.janus_solot_seg al
     where al.codsolot = an_codsolot
       and trim(al.accion) = trim(av_accion);

    -- Ini 2.0
    select count(1)
      into ln_janus_act
      from tim.rp_prov_bscs_janus_hist@dbl_bscs_bf pj
     where pj.action_id = 1
       and pj.co_id = ln_cod_id;

    if av_accion = 'BAJALINEAJANUS' then
      if ln_janus_act > 0 and ln_valreg = 0 then
        ln_valida := 0;
        return ln_valida;
      else
        ln_valida := 1;
        return ln_valida;
      end if;
    end if;

    if av_accion = 'BAJACLIENTEJANUS' then
      if ln_janus_act > 0 and ln_valreg = 0 then
        ln_valida := 0;
        return ln_valida;
      else
        ln_valida := 1;
        return ln_valida;
      end if;
    end if;

    if av_accion = 'ALTALINEAJANUS' then
      if ln_janus_act = 0 and ln_valreg = 0 then
        ln_valida := 0;
        return ln_valida;
      else
        ln_valida := 1;
        return ln_valida;
      end if;
    end if;
    -- Fin 2.0
    return ln_valida;
  end;

  -- Ini 2.0
  function f_valida_linea_bscs_janus(an_codsolot number) return varchar2 is

    lv_numero  varchar2(20);
    lv_mensaje varchar2(500);

    ln_cod_id           number;
    ln_customer_id_bscs number;
    ln_co_id_bscs       number;
    lv_numero_bscs      varchar2(70);
    lv_codplan_bscs     varchar2(10);
    lv_ciclo_bscsc      varchar2(2);

    ln_out_janus         number;
    lv_mensaje_janus     varchar2(500);
    lv_customer_id_janus varchar2(20);
    ln_codplan_janus     number;
    lv_producto_janus    varchar2(100);
    ld_fecini_janus      date;
    lv_estado_janus      varchar2(20);
    lv_ciclo_janus       varchar2(5);

    lv_codcli varchar2(8);
    ln_customer number;
    ln_codinssrv number;
    an_error number;
    av_error varchar2(4000);
  begin
    lv_mensaje := 'OK';

    operacion.pq_sga_iw.p_cons_numtelefonico_sot(an_codsolot,
                             lv_numero,
                             lv_codcli,
                             ln_cod_id,
                             ln_customer,
                             ln_codinssrv,
                             an_error,
                             av_error);

    if an_error = 1 then
      -- Consulta la informacion en BSCS
      select distinct p.customer_id,
                      p.co_id,
                      tim.tfun051_get_dnnum_from_coid@DBL_BSCS_BF(p.co_id) tn,
                      serv.codplan,
                      cu.billcycle
        into ln_customer_id_bscs,
             ln_co_id_bscs,
             lv_numero_bscs,
             lv_codplan_bscs,
             lv_ciclo_bscsc
        from CONTRACT_all@DBL_BSCS_BF p,
             CUSTOMER_ALL@DBL_BSCS_BF cu,
             (select ssh.co_id,
                     plj.param1 codplan,
                     rp.des desc_plan,
                     OPERACION.PQ_CONT_REGULARIZACION.f_val_tipo_servicio_bscs(ssh.sncode) Tipo_Servicio
                from pr_serv_status_hist@DBL_BSCS_BF   ssh,
                     mpusntab@DBL_BSCS_BF              sn,
                     contract_all@DBL_BSCS_BF          ca,
                     rateplan@DBL_BSCS_BF              rp,
                     tim.pf_hfc_parametros@DBL_BSCS_BF plj
               where ssh.sncode = sn.sncode
                 and ssh.status = 'A'
                 and ssh.co_id = ca.co_id
                 and ca.sccode = 6
                 and ca.tmcode = rp.tmcode
                 and ssh.sncode = plj.cod_prod1
                 and plj.campo = 'SERV_TELEFONIA'
                 and sn.sncode not in (select o.codigon
                                       from tipopedd t, opedd o
                                       where t.tipopedd =  o.tipopedd
                                       and t.abrev = 'SNCODENOHFC_BSCS')) serv
       where p.sccode = 6
         and p.co_id = serv.co_id
         and cu.customer_id = p.customer_id
         and serv.Tipo_Servicio = 'TLF'
         and p.co_id = ln_cod_id;

      -- Consulta la Informacion en Janus
      operacion.pq_sga_iw.p_cons_linea_janus(lv_numero,
                         ln_out_janus,
                         lv_mensaje_janus,
                         lv_customer_id_janus,
                         ln_codplan_janus,
                         lv_producto_janus,
                         ld_fecini_janus,
                         lv_estado_janus,
                         lv_ciclo_janus);

      if ln_out_janus = 1 then

        if to_number(lv_customer_id_janus) != ln_customer_id_bscs then
          lv_mensaje := 'Customer ID son diferentes en BSCS y JANUS';
          return lv_mensaje;
        end if;

        if ln_codplan_janus != to_number(lv_codplan_bscs) then
          lv_mensaje := 'Los Planes son diferentes en BSCS y JANUS';
          return lv_mensaje;
        end if;

        if trim(lv_ciclo_janus) != trim(lv_ciclo_bscsc) then
          lv_mensaje := 'El ciclo son diferentes en BSCS y JANUS';
          return lv_mensaje;
        end if;

        if trim(lv_numero_bscs) != trim(lv_numero) then
          lv_mensaje := 'El Numero telefonico es diferente en BSCS y JANUS';
          return lv_mensaje;
        end if;

      else
        lv_mensaje := lv_mensaje_janus;
        return lv_mensaje;
      end if;
    end if;

    return lv_mensaje;

  exception
    when others then
      lv_mensaje := 'ERROR al validar linea BSCS y JANUS: ' || sqlerrm;
      return lv_mensaje;
  end;

  procedure p_anula_masivo(o_resultado OUT T_CURSOR) IS
    an_error            NUMBER;
    av_error            VARCHAR2(400);
    v_anular            NUMBER;
    v_sh_status      VARCHAR2(5);
    v_contador          NUMBER;
    l_tipo_al        NUMBER;
    l_msg            VARCHAR2(4000);
    l_res_alinea     NUMBER;
    l_alinea_bscs_iw NUMBER;

    CURSOR listasot IS
      SELECT s.codsolot,
             s.cod_id,
             s.cod_id_old,
             s.estsol,
             e.tipestsol,
             e.descripcion,
             s.tiptra,
             t.descripcion tipotrabajo,
             e.descripcion estadosolicitud,
             s.fecultest,
             (trunc(sysdate) - trunc(s.fecultest)) dias_trans
        FROM solot s, estsol e, tiptrabajo t
        WHERE s.estsol = e.estsol
         AND s.tiptra = t.tiptra
         AND e.tipestsol = 7
         AND e.estsol NOT IN (SELECT o.codigon FROM operacion.opedd o WHERE o.abreviacion='CONS_ESTSOL')
         AND cod_id IS NOT NULL
         AND s.tiptra IN (SELECT o.codigon FROM operacion.opedd o WHERE o.abreviacion='TIPTRA_SOLOT')
         AND s.estsol NOT IN 22
         AND (trunc(sysdate) - trunc(s.fecultest)) > 29
         ;
  BEGIN

    FOR rsot IN listasot LOOP
      BEGIN

        v_anular := 1;

        SELECT ch_status INTO v_sh_status
        FROM sysadm.curr_co_status@DBL_BSCS_BF
        WHERE co_id = rsot.cod_id;

        IF rsot.ESTSOL <> 13 AND rsot.DIAS_TRANS > 29 AND upper(v_sh_status) IN ('O', 'D') THEN
          --Validamos si existe en IW
          P_CONS_DET_IW(rsot.codsolot, an_error, av_error);


          --Validamos si tiene internet activo
          SELECT COUNT(1) INTO v_contador
          FROM operacion.tab_equipos_iw iw
          WHERE iw.mac_address IS NOT NULL AND iw.codsolot = rsot.codsolot AND interfase = 620;

          IF v_contador > 0 THEN
            v_anular    := 0;
            OPERACION.PQ_CONT_REGULARIZACION.SP_INSERT_SOTANULA(0,TO_CHAR(rsot.codsolot),' - INT ACTIVO IW ',an_error,av_error);

          ELSE
            --Validamos si tiene telefonia activo
            SELECT COUNT(1)
              INTO v_contador
              FROM operacion.tab_equipos_iw iw
            WHERE iw.mac_address IS NOT NULL
               AND iw.codsolot = rsot.codsolot AND interfase = 820;

            IF v_contador > 0 THEN
              v_anular    := 0;
              OPERACION.PQ_CONT_REGULARIZACION.SP_INSERT_SOTANULA(0,TO_CHAR(rsot.codsolot),' - TLF ACTIVO IW ',an_error,av_error);

            ELSE
              --Validamos si tiene cable activo
              SELECT COUNT(1)
                INTO v_contador
                FROM operacion.tab_equipos_iw iw
               WHERE iw.mac_address IS NOT NULL
                 AND iw.codsolot = rsot.codsolot
                 AND interfase = 2020;
              IF v_contador > 0 THEN
                v_anular    := 0;
                OPERACION.PQ_CONT_REGULARIZACION.SP_INSERT_SOTANULA(0,TO_CHAR(rsot.codsolot),' - CTV ACTIVO IW ',an_error,av_error);

              ELSE
                v_anular := 1;
              END IF;
            END IF;
          END IF;

        ELSE
          IF upper(v_sh_status) IN ('A', 'S') THEN
            OPERACION.PQ_CONT_REGULARIZACION.SP_INSERT_SOTANULA(0,TO_CHAR(rsot.codsolot),' - Contrato Activo/Suspendido ',an_error,av_error);

          ELSE
            OPERACION.PQ_CONT_REGULARIZACION.SP_INSERT_SOTANULA(0,TO_CHAR(rsot.codsolot),' - Revisar',an_error,av_error);

          END IF;

          v_anular := 0;
        END IF;

        IF v_anular = 1 THEN

          operacion.pq_solot.p_chg_estado_solot(rsot.codsolot,
                                                    13,
                                                    rsot.estsol,
                                                    'Se anula por exceso de días.  CO_ID :' ||
                                                    rsot.cod_id);

          OPERACION.PQ_CONT_REGULARIZACION.SP_INSERT_SOTANULA(1,TO_CHAR(rsot.codsolot),'',an_error,av_error);

        END IF;

      EXCEPTION
        WHEN OTHERS THEN
          OPERACION.PQ_CONT_REGULARIZACION.SP_INSERT_SOTANULA(0,TO_CHAR(rsot.codsolot),' - Revisar',an_error,av_error);

      END;
    END LOOP;


    OPEN o_resultado FOR
      SELECT (ESTADO||'|'||CODSOLOT||'|'||OBSERVACION) FROM operacion.TAB_SOTANULADA;

      DELETE FROM operacion.TAB_SOTANULADA;
      commit;



  END P_ANULA_MASIVO;

  procedure p_valida_linea_bscs(av_numero  in varchar2,
                                an_out     out number,
                                av_mensaje out varchar2) is
    l_cont    number;
    v_numeron number;
  begin
    v_numeron := to_number(av_numero);
    --1 Nro Esta Asiganado Error -- 0 Nro Libre en Plataforma
    select count(1)
      into l_cont
      from dual
     where Exists
     (select 1
              from directory_number@DBL_BSCS_BF   dn,
                   contr_services_cap@DBL_BSCS_BF csc,
                   contract_history@DBL_BSCS_BF   ch
             where dn.dn_id = csc.dn_id
               and csc.co_id = ch.co_id
               and ch.ch_seqno = (select max(chh.ch_seqno)
                                    from contract_history@DBL_BSCS_BF chh
                                   where chh.co_id = ch.co_id)
               and ch.ch_status != 'd'
               and dn.dn_num = v_numeron);
    an_out := l_cont;
    if an_out = 0 then
      av_mensaje := 'Validación BSCS(p_valida_linea_bscs)-OK';
    else
      av_mensaje := 'El Nro Se encuentra Asignado en BSCS';
    end if;
  exception
    when others then
      an_out     := 1;
      av_mensaje := 'Error Proceso de Validación BSCS(p_valida_linea_bscs)';
  end;

  procedure p_valida_linea_iw(av_numero  in varchar2,
                              an_out     out number,
                              av_mensaje out varchar2) is
    l_out               number;
    l_mensaje           varchar2(200);
    l_clientecrm        varchar2(200);
    l_idproducto        number;
    l_idproductopadre   number;
    l_idventa           number;
    l_idventapadre      number;
    l_endpointn         number;
    l_homeexchangename  varchar2(200);
    l_homeexchangecrmid varchar2(200);
    l_fechaActivacion   date;
    l_out1              number;
    l_mensaje1           varchar2(200);
    l_clientecrm1        varchar2(200);

  begin
    intraway.pq_consultaitw.p_int_consultatn(av_numero,
                                             l_out,
                                             l_mensaje,
                                             l_clientecrm,
                                             l_idproducto,
                                             l_idproductopadre,
                                             l_idventa,
                                             l_idventapadre,
                                             l_endpointn,
                                             l_homeexchangename,
                                             l_homeexchangecrmid,
                                             l_fechaactivacion);


       intraway.pq_migrasac.p_trae_numtelf (av_numero,
                                            l_out1,
                                            l_mensaje1,
                                            l_clientecrm1);


       if l_out1 = 0 and l_mensaje1 = 'Sin Servicio' then
          --1 Nro Esta Asiganado Error -- 0 Nro Libre en Plataforma
          if l_out = 0 and l_mensaje = 'Sin Servicio' then
            an_out     := 0;
            av_mensaje := 'Validación IWAY/IC(p_valida_linea_iw)-OK';
          else
            an_out     := 1;
            av_mensaje := 'El Nro Se encuentra Asignado en IWAY';
          end if;
       else
           an_out     := 1;
           av_mensaje := 'El Nro Se encuentra Asignado en IC';
       end if;

  exception
    when others then
      an_out     := 1;
      av_mensaje := 'Error Proceso de Validación BSCS(p_valida_linea_iw)';
  end;

  procedure p_valida_linea_janus(av_numero  in varchar2,
                                 an_out     out number,
                                 av_mensaje out varchar2) is
    l_cont number;
  begin
    --1 Nro Esta Asiganado Error -- 0 Nro Libre en Plataforma
    select count(1)
      into l_cont
      from dual
     where exists (select 1
              from janus_prod_pe.connections@DBL_JANUS c
             where c.connection_id_v = av_numero);
    an_out := l_cont;
    if an_out = 0 then
      av_mensaje := 'Validación JANUS(p_valida_linea_janus)-OK';
    else
      av_mensaje := 'El Nro Se encuentra Asignado en IWAY';
    end if;
  exception
    when others then
      an_out     := 1;
      av_mensaje := 'Error Proceso de Validación BSCS(p_valida_linea_janus)';
  end;

  procedure p_valida_linea(av_numero  in varchar2,
                           an_out     out number,
                           av_mensaje out varchar2) is
    l_valida   number;
    ln_out     number;
    lv_mensaje varchar2(500);
  begin
    --1 Proceso satisfactorio --0 proceso errado
    ln_out := 1;
    p_valida_linea_bscs(av_numero, l_valida, lv_mensaje);
    if l_valida <> 0 then
      ln_out     := 0;
      av_mensaje := av_mensaje || lv_mensaje || ' |';
    end if;
    p_valida_linea_iw(av_numero, l_valida, lv_mensaje);
    if l_valida <> 0 then
      ln_out     := 0;
      av_mensaje := av_mensaje || lv_mensaje || ' |';
    end if;
    p_valida_linea_janus(av_numero, l_valida, lv_mensaje);
    if l_valida <> 0 then
      ln_out     := 0;
      av_mensaje := av_mensaje || lv_mensaje || ' |';
    end if;
    an_out := ln_out;
    if an_out = 0 then
      av_mensaje := av_mensaje;
    else
      av_mensaje := 'OK';
    end if;
  exception
    when others then
      an_out     := 0;
      av_mensaje := 'Error Proceso de Validación General(p_valida_linea)';
  end;
  -- Fin 2.0
  procedure p_cont_reproceso(an_cod_id number,
                             an_error  out integer,
                             av_error  out varchar2) is
  BEGIN

    update tim.rp_prov_bscs_janus@DBL_BSCS_BF p
       set p.tarea = 4, p.intentos = 5, p.estado_prv = 2
     where p.action_id = 1
       and p.estado_prv = '6'
       and upper(trim(p.errmsg)) = trim('PAYER ALREADY EXISTS')
       and p.co_id = an_cod_id;

    update tim.rp_prov_bscs_janus@DBL_BSCS_BF p
       set p.intentos = 0, p.estado_prv = 2
     where p.action_id = 1
       and p.estado_prv = '6'
       and upper(trim(p.errmsg)) = trim('CONNECTION NOT FOUND')
       and p.co_id = an_cod_id;

    update tim.rp_prov_bscs_janus@DBL_BSCS_BF p
       set p.tarea = 5, p.intentos = 5, p.estado_prv = 2
     where p.action_id = 1
       and p.estado_prv = '6'
       and upper(trim(p.errmsg)) =
           trim('SPEND GROUP DETAILS ALREADY EXISTS')
       and p.co_id = an_cod_id;

    update tim.rp_prov_bscs_janus@DBL_BSCS_BF p
       set p.estado_prv = 5
     where p.action_id = 2
       and p.estado_prv = '6'
       and upper(trim(p.errmsg)) =
           trim('BOTH OLD AND NEW PAYER STATUS ARE SAME')
       and p.co_id = an_cod_id;

    update tim.rp_prov_bscs_janus@DBL_BSCS_BF p
       set p.estado_prv = 5
     where p.action_id = 2
       and p.estado_prv = '6'
       and upper(trim(p.errmsg)) = trim('PAYER NOT FOUND')
       and p.co_id = an_cod_id;

    update tim.rp_prov_bscs_janus@DBL_BSCS_BF p
       set p.intentos = 0, p.estado_prv = 2
     where p.action_id = 505
       and p.estado_prv = '6'
       and upper(trim(p.errmsg)) = trim('CONNECTION NOT FOUND')
       and p.co_id = an_cod_id;

    update tim.rp_prov_bscs_janus@DBL_BSCS_BF p
       set p.estado_prv = 5
     where p.action_id = 505
       and p.estado_prv = '6'
       and upper(trim(p.errmsg)) =
           trim('GIVEN MINIMUM BALANCE IS SAME AS PREVIOUS MINIMUM BALANCE. ')
       and p.co_id = an_cod_id;

    update tim.rp_prov_bscs_janus@DBL_BSCS_BF p
       set p.estado_prv = 5
     where p.action_id = 505
       and p.estado_prv = '6'
       and upper(trim(p.errmsg)) = trim('CONNECTION NOT FOUND')
       and p.co_id = an_cod_id;

    update tim.rp_prov_bscs_janus@DBL_BSCS_BF p
       set p.estado_prv = 5
     where p.action_id = 505
       and p.estado_prv = '6'
       and upper(trim(p.errmsg)) = trim('CONNECTION ALREADY TERMINATED')
       and p.co_id = an_cod_id;

    update tim.rp_prov_bscs_janus@DBL_BSCS_BF p
       set p.estado_prv = 5
     where p.action_id = 500
       and p.estado_prv = '6'
       and p.co_id = an_cod_id;

    update tim.rp_prov_bscs_janus@DBL_BSCS_BF p
       set p.estado_prv = 5
     where p.action_id = 509
       and p.estado_prv = '6'
       and p.co_id = an_cod_id;

    update tim.rp_prov_bscs_janus@DBL_BSCS_BF p
       set p.estado_prv = 5
     where p.estado_prv = '6'
       and p.action_id = 3
       and upper(trim(p.errmsg)) =
           trim('BOTH OLD AND NEW PAYER STATUS ARE SAME')
       and p.co_id = an_cod_id;

    update tim.rp_prov_bscs_janus@DBL_BSCS_BF p
       set p.estado_prv = 5
     where p.estado_prv = '6'
       and p.action_id = 3
       and upper(trim(p.errmsg)) = trim('PAYER NOT FOUND')
       and p.co_id = an_cod_id;

    update tim.rp_prov_bscs_janus@DBL_BSCS_BF p
       set p.estado_prv = 2,
           p.intentos   = 1,
           p.errcode    = null,
           p.errmsg     = null
     where p.estado_prv = '6'
       and p.action_id = 3
       and upper(trim(p.errmsg)) =
           trim('OCURRIO UNA EXCEPCIÓN AL INVOCAR EL SERVICIO - CHANGEPAYERSTATUS')
       and p.co_id = an_cod_id;

    update tim.rp_prov_bscs_janus@DBL_BSCS_BF p
       set estado_prv = 5
     where p.estado_prv = '6'
       and p.action_id = 4
       and upper(trim(p.errmsg)) = trim('PAYER NOT FOUND')
       and p.co_id = an_cod_id;

    update tim.rp_prov_bscs_janus@DBL_BSCS_BF p
       set estado_prv = 5
     where p.estado_prv = '6'
       and p.action_id = 4
       and upper(trim(p.errmsg)) =
           trim('BOTH OLD AND NEW PAYER STATUS ARE SAME')
       and p.co_id = an_cod_id;

    an_error := 0;
    av_error := 'Éxito en el proceso';
    p_reg_log(null,
              null,
              NULL,
              null,
              null,
              an_Error,
              av_error,
              an_cod_id,
              'Reproceso JANUS');
  EXCEPTION
    WHEN OTHERS THEN
      an_error := -1;
      av_error := 'Ocurrio un error al reprocesar JANUS';
      p_reg_log(null,
                null,
                NULL,
                null,
                null,
                an_Error,
                av_error,
                an_cod_id,
                'Reproceso JANUS');
  END p_cont_reproceso;

function f_get_ciclo_codinssrv(l_numero    numtel.numero%type,
                               l_codinssrv insprd.codinssrv%type)
  return varchar2 is

  l_cicfac   number;
  l_maxsec   number;
  l_ciclo    varchar2(100);
  l_cons     number;
  l_desciclo ciclo.descripcion%type;

begin

  l_cons := 0;

  begin
    select distinct cicfac
      into l_cicfac
      from instxproducto
     where pid in (select pid
                     from insprd
                    where codinssrv = l_codinssrv
                      and flgprinc = 1)
       and nomabr = l_numero;

    l_cons := 1;

  exception
    when others then
      l_cons := 0;
  end;

  if l_cons > 0 then
    begin
      select max(seccicfac)
        into l_maxsec
        from fechaxciclo
       where cicfac = l_cicfac;

      select to_char(fecini, 'dd')
        into l_ciclo
        from fechaxciclo
       where seccicfac = l_maxsec
         and cicfac = l_cicfac;

      select descripcion
        into l_desciclo
        from ciclo
       where cicfac = l_cicfac;

      return l_ciclo;

    exception
      when others then
        l_ciclo := -1;
    end;
  else
    l_ciclo := 0;
  end if;

  return l_ciclo;

end;

-- Provision de SGA Puro - Masivamente
 procedure p_altanumero_janus_sgamasiva(an_error out integer,
                                          av_error out varchar2) is

    vs_hcon      varchar2(1) := 9;
    vs_hccd      varchar2(4) := 'HCCD';
    l_trama      varchar2(4000);
    v_msgerr     varchar2(1000);
    v_respuesta  varchar2(1000);
    lv_ciclo     varchar2(10);
    ln_contciclo number;

    ln_out_janus         number;
    lv_mensaje_janus     varchar2(500);
    lv_customer_id_janus varchar2(20);
    ln_codplan_janus     number;
    lv_producto_janus    varchar2(100);
    ld_fecini_janus      date;
    lv_estado_janus      varchar2(20);
    lv_ciclo_janus       varchar2(5);

    cursor c_lineaxsot is
      select distinct h.codcli,
                      h.codinssrv,
                      h.numero,
                      decode(v.tipdide, '001', v.ntdide, null) ruc,
                      intraway.f_retorna_nomcli_itw(v.nomclires) nomclires,
                      intraway.f_retorna_nomcli_itw(v.nomclires) || ' ' ||
                      intraway.f_retorna_nomcli_itw(v.apepatcli) apepatcli,
                      v.tipdide,
                      v.ntdide,
                      intraway.f_retorna_nomcli_itw(v.nomcli) razon,
                      trim(v.telefono1) telefono1,
                      trim(v.telefono2) telefono2,
                      trim(v.mail) nomemail,
                      intraway.f_retorna_nomcli_itw(substr(v.dircli, 1, 200)) dirsuc,
                      intraway.f_retorna_nomcli_itw(substr(v.referencia,
                                                           1,
                                                           200)) referencia,
                      (select u.nomdst
                         from v_ubicaciones u, inssrv i
                        where u.codubi = i.codubi
                          and i.codinssrv = h.codinssrv) nomdst,
                      (select u.nompvc
                         from v_ubicaciones u, inssrv i
                        where u.codubi = i.codubi
                          and i.codinssrv = h.codinssrv) nompvc,
                      (select u.nomest
                         from v_ubicaciones u, inssrv i
                        where u.codubi = i.codubi
                          and i.codinssrv = h.codinssrv) nomest,
                      h.codplan_b plan_base,
                      h.codplan_o plan_opcional,
                      h.transaccion
        from operacion.tab_servicios_hfc h, marketing.vtatabcli v
       where h.codcli = v.codcli
         and h.transaccion = 'A'
         and h.estinssrv in (1, 2)
         and h.flg_unico = 1
         and h.flg_sistema = 1
         and h.plataforma = 'JANUS'
         and h.idproducto = 766;
  begin
    for bb in c_lineaxsot loop
      begin

        select to_number(c.valor)
          into ln_contciclo
          from constante c
         where c.constante = 'CCICLO_JANUS';

        if ln_contciclo = 1 then
          lv_ciclo := f_get_ciclo_codinssrv(bb.numero, bb.codinssrv);
        else
          lv_ciclo := '01';
        end if;

        operacion.pq_sga_iw.p_cons_linea_janus(bb.numero,
                           ln_out_janus,
                           lv_mensaje_janus,
                           lv_customer_id_janus,
                           ln_codplan_janus,
                           lv_producto_janus,
                           ld_fecini_janus,
                           lv_estado_janus,
                           lv_ciclo_janus);

        if ln_out_janus = 0 then
          l_trama := vs_hcon || bb.codcli || '|' || vs_hccd || bb.codcli || '|' ||
                     bb.ruc || '|' || bb.nomclires || '|' || bb.apepatcli || '|' ||
                     bb.tipdide || '|' || bb.ntdide || '|' || bb.razon || '|' ||
                     bb.telefono1 || '|' || bb.telefono2 || '|' ||
                     bb.nomemail || '|' || bb.dirsuc || '|' || bb.referencia || '|' ||
                     bb.nomdst || '|' || bb.nompvc || '|' || bb.nomest || '|' ||
                     bb.codinssrv || '|' || bb.numero || '|' || 'IMSI' ||
                     bb.numero || '|' || lv_ciclo || '|' || bb.plan_base || '|' ||
                     bb.plan_opcional;

          tim.pp001_pkg_prov_janus.SP_REG_PROV_CTRL@dbl_bscs_bf(12,
                                                                1,
                                                                l_trama,
                                                                v_respuesta,
                                                                v_msgerr);
          if v_respuesta = 0 then
            an_error := 0;
            av_error := 'Se envio la provision correctamente a Janus';
          else
            an_error := -1;
            av_error := 'Provision Janus : ' || v_msgerr;
          end if;
          --commit;
        else
          an_error := -1;
          av_error := 'La linea telefonica ya se encuentra provisionada en Janus';
        end if;

      exception
        when others then
          an_error := -1;
          av_error := 'Error : ' || sqlerrm;
      end;
    end loop;
  end;

  -- Luis Flores Osorio 09/09/2015
  --Funcion que valida si la SOT tiene el servicio de telefonia asociado
  function f_val_serv_tlf_sot(an_codsolot number) return number is
    ln_validar number;
  begin
    select count(distinct pto.codsolot)
      into ln_validar
      from solotpto pto, tystabsrv ser, producto p
     where pto.codsrvnue = ser.codsrv
       and ser.idproducto = p.idproducto
       and p.idproducto in
           (select o.codigon
              from tipopedd t, opedd o
             where t.tipopedd = o.tipopedd
               and t.abrev = 'IDPRODUCTOCONTINGENCIA'
               and o.codigoc = 'TLF')
       and pto.codsolot = an_codsolot;

    if ln_validar > 0 then
      return 1; -- Tiene telefonia
    else
      return 0; -- No tiene telefonia
    end if;

  end;

  --Insertamos en la Tabla de Seguimiento Contingencia de Janus
  procedure p_insert_janus_solot_seg(an_codsolot number,
                                     an_cod_id number,
                                     an_customerid number,
                                     av_accion varchar2,
                                     av_customerjanus varchar2,
                                     av_numero varchar2,
                                     an_error out number,
                                     av_msgerror out varchar2) is


  begin

    insert into operacion.janus_solot_seg
                (codsolot, cod_id, customer_id, accion, customer_idjanus, numero)
    values(an_codsolot, an_cod_id, an_customerid, av_accion, av_customerjanus, av_numero);

    an_error := 1;
    av_msgerror := 'OK';

  exception
    when others then
      an_error := -1;
      av_msgerror := 'Error al Insertar en la Tabla seguimiento Janus : '|| sqlerrm;

  end p_insert_janus_solot_seg;

  -- Procedimiento de baja de la linea telefonica en el janus.
  procedure p_bajanumero_janus_bscs(an_codsolot number,
                                    an_error    out integer,
                                    av_error    out varchar2) is
    ln_cod_id   number;
    lv_codcli   varchar2(8);
    ln_customer number;
    lv_trama    varchar2(20);
    lv_numero   varchar2(8);

    ln_out_janus         number;
    lv_mensaje_janus     varchar2(500);
    lv_customer_id_janus varchar2(20);
    ln_codplan_janus     number;
    lv_producto_janus    varchar2(100);
    ld_fecini_janus      date;
    lv_estado_janus      varchar2(20);
    lv_ciclo_janus       varchar2(5);
    ln_codinssrv number;
    error_general exception;

  begin

    operacion.pq_sga_iw.p_cons_numtelefonico_sot(an_codsolot,
                                                 lv_numero,
                                                 lv_codcli,
                                                 ln_cod_id,
                                                 ln_customer,
                                                 ln_codinssrv,
                                                 an_error,
                                                 av_error);

    if an_error = 1 then

      if operacion.pq_sga_iw.f_val_prov_janus_pend(ln_cod_id) = 0 then

        operacion.pq_sga_iw.p_cons_linea_janus(lv_numero,
                                               ln_out_janus,
                                               lv_mensaje_janus,
                                               lv_customer_id_janus,
                                               ln_codplan_janus,
                                               lv_producto_janus,
                                               ld_fecini_janus,
                                               lv_estado_janus,
                                               lv_ciclo_janus);

        if ln_out_janus = 1 or ln_out_janus = -2 then

          update operacion.janus_solot_seg s set s.procesado = 1
          where s.codsolot = an_codsolot
          and s.accion = 'BAJALINEAJANUS';

          lv_trama := 'IMSI' || trim(lv_numero);

          operacion.pq_sga_iw.p_insert_prov_bscs_janus(2,5,ln_customer,ln_cod_id,'2',1,lv_trama,an_error,av_error);

          p_insert_janus_solot_seg(an_codsolot, ln_cod_id,ln_customer,'BAJALINEAJANUS',
                                   lv_customer_id_janus,lv_numero,an_error,av_error);

          an_error := 1;
          av_error := 'Exito al enviar la baja del numero de Janus';

        else
          av_error := 'Error Janus : ' || lv_mensaje_janus;
          raise error_general;
        end if;

      else
        av_error := 'Existen pendientes en la provision de Janus';
        raise error_general;
      end if;

    else
        av_error := 'La SOT no tiene el servicio de Telefonia para enviar a Janus';
        raise error_general;
    end if;

  p_reg_log(null,
            null,
            NULL,
            an_codsolot,
            null,
            an_Error,
            av_error,
            ln_cod_id,
            'JANUS-Baja Numero BSCS');
  exception
    when error_general then
      an_error := -1;
    when others then
      an_error := -1;
      av_error := 'ERROR al enviar la baja del numero de Janus : ' ||
                  to_char(sqlerrm);
      p_reg_log(null,
              null,
              NULL,
              an_codsolot,
              null,
              an_error,
              av_error,
              ln_cod_id,
              'JANUS-Baja Numero BSCS');
  end p_bajanumero_janus_bscs;

  -- Procedimiento de baja del cliente en janus
  procedure p_bajacliente_janus_bscs(an_codsolot number,
                                     an_error    out integer,
                                     av_error    out varchar2) is
    ln_cod_id   number;
    ln_customer number;
    lv_numero   varchar2(20);
    lv_customer_janus varchar2(20);
    ln_valida_envio number;
    lv_codcli varchar2(8);
    ln_codinssrv number;

    error_general exception;
  begin

    operacion.pq_sga_iw.p_cons_numtelefonico_sot(an_codsolot,
                                                 lv_numero,
                                                 lv_codcli,
                                                 ln_cod_id,
                                                 ln_customer,
                                                  ln_codinssrv,
                                                 an_error,
                                                 av_error);

    if an_error = 1 then

        if operacion.pq_sga_iw.f_val_prov_janus_pend(ln_cod_id) = 0 then

          -- Obtenemos el Customer de JANUS
          lv_customer_janus := f_retorna_customerjanusxsot(an_codsolot);

          if lv_customer_janus != '00' then

             ln_valida_envio := OPERACION.PQ_SGA_IW.f_valida_prov_numero(lv_customer_janus);

             if ln_valida_envio = 1 then

                operacion.pq_sga_iw.p_insert_prov_bscs_janus(2,5,ln_customer,ln_cod_id,'2',1,lv_customer_janus,an_error,av_error);

                p_insert_janus_solot_seg(an_codsolot, ln_cod_id,ln_customer,'BAJACLIENTEJANUS',
                                     null,null,an_error,av_error);

                an_error := 1;
                av_error := 'Exito al enviar la baja del cliente de Janus';

              elsif ln_valida_envio = 2 then

                operacion.pq_sga_iw.p_insert_prov_ctrl_janus(2, 4, lv_customer_janus ,ln_codinssrv,0,lv_customer_janus,
                                                          an_error, av_error);

                p_insert_janus_solot_seg(an_codsolot, ln_codinssrv,null,'BAJACLIENTEJANUS',
                                        lv_customer_janus,lv_numero,an_error,av_error);

                an_error := 1;
                av_error := 'Exito al enviar la baja del Cliente de Janus';

              end if;

          end if;
      else
        av_error := 'Existen pendientes en la provision de Janus';
        raise error_general;
      end if;
    else
        av_error := 'La SOT no tiene el servicio de Telefonia para enviar a Janus';
        raise error_general;
    end if;

   p_reg_log(null,
            null,
            NULL,
            an_codsolot,
            null,
            an_Error,
            av_error,
            ln_cod_id,
            'JANUS-Baja Cliente BSCS');
  exception
    when error_general then
      an_error := -1;
    when others then
      an_error := -1;
      av_error := 'ERROR al enviar la baja del cliente de Janus : ' ||
                  to_char(sqlerrm);
      p_reg_log(null,
                null,
                NULL,
                an_codsolot,
                null,
                an_Error,
                av_error,
                ln_cod_id,
                'JANUS-Baja Cliente BSCS');
  end p_bajacliente_janus_bscs;

   -- Procedimiento de baja la linea y customer de Janus
  procedure p_bajatotal_janus_bscs(an_codsolot number,
                                   an_error    out integer,
                                   av_error    out varchar2) is
    ln_cod_id   number;
    lv_codcli   varchar2(8);
    ln_customer number;
    lv_trama    varchar2(20);
    lv_numero   varchar2(8);

    ln_out_janus         number;
    lv_mensaje_janus     varchar2(500);
    lv_customer_id_janus varchar2(20);
    ln_codplan_janus     number;
    lv_producto_janus    varchar2(100);
    ld_fecini_janus      date;
    lv_estado_janus      varchar2(20);
    lv_ciclo_janus       varchar2(5);

    ln_codinssrv number;
    error_general exception;
  begin

    operacion.pq_sga_iw.p_cons_numtelefonico_sot(an_codsolot,
                                                 lv_numero,
                                                 lv_codcli,
                                                 ln_cod_id,
                                                 ln_customer,
                                                 ln_codinssrv,
                                                 an_error,
                                                 av_error);

    if an_error = 1 then

      if operacion.pq_sga_iw.f_val_prov_janus_pend(ln_cod_id) = 0 then

          operacion.pq_sga_iw.p_cons_linea_janus(lv_numero,
                                                 ln_out_janus,
                                                 lv_mensaje_janus,
                                                 lv_customer_id_janus,
                                                 ln_codplan_janus,
                                                 lv_producto_janus,
                                                 ld_fecini_janus,
                                                 lv_estado_janus,
                                                 lv_ciclo_janus);

          if ln_out_janus = 1 then
            -- Baja de Linea Telefonica
            lv_trama := 'IMSI' || trim(lv_numero);

            operacion.pq_sga_iw.p_insert_prov_bscs_janus(2,5,ln_customer,ln_cod_id,'2',1,lv_trama,an_error,av_error);

            -- Baja del Cliente
            operacion.pq_sga_iw.p_insert_prov_bscs_janus(2,5,ln_customer,ln_cod_id,'2',1,lv_customer_id_janus,an_error,av_error);

            an_error := 1;
            av_error := 'Exito al enviar la baja del numero de Janus';

          elsif ln_out_janus = -2 then

            -- Baja de Linea Telefonica cuando no esta asociado a un Cliente
            lv_trama := 'IMSI' || trim(lv_numero);
            operacion.pq_sga_iw.p_insert_prov_bscs_janus(2,5,ln_customer,ln_cod_id,'2',1,lv_trama,an_error,av_error);

            an_error := 1;
            av_error := 'Exito al enviar la baja del numero de Janus';

          else
            av_error := 'Error Janus : '|| lv_mensaje_janus;
            raise error_general;
          end if;
       else
         av_error := 'Existen pendientes en la provision de Janus';
         raise error_general;
       end if;
    else
        av_error := 'La SOT no tiene el servicio de Telefonia para enviar a Janus';
        raise error_general;
    end if;

  p_reg_log(null,
            null,
            NULL,
            an_codsolot,
            null,
            an_Error,
            av_error,
            ln_cod_id,
            'JANUS-Baja Total BSCS');
  exception
    when error_general then
      an_error := -1;
    when others then
      an_error := -1;
      av_error := 'ERROR al enviar la baja del numero de Janus : ' ||
                  to_char(sqlerrm);
      p_reg_log(null,
            null,
            NULL,
            an_codsolot,
            null,
            an_Error,
            av_error,
            ln_cod_id,
            'JANUS-Baja Total BSCS');

  end p_bajatotal_janus_bscs;

  --Procedimiento de alta de numero en Janus
  procedure p_altanumero_janus_bscs(an_codsolot number,
                                    an_error    out integer,
                                    av_error    out varchar2) is
    ln_cod_id     number;
    ln_customer   number;
    v_customer_id number;
    v_tmcode      number;
    v_sncode      number;
    error_general       exception;
    error_general_log   exception;
    ln_existe_csc number;
    lv_numero     varchar2(20);
    an_error_contr number;
    av_error_contr varchar2(1000);

    ln_out_janus         number;
    lv_mensaje_janus     varchar2(500);
    lv_customer_id_janus varchar2(20);
    ln_codplan_janus     number;
    lv_producto_janus    varchar2(100);
    ld_fecini_janus      date;
    lv_estado_janus      varchar2(20);
    lv_ciclo_janus       varchar2(5);

    lv_codcli varchar2(8);
    ln_codinssrv number;
    lv_trama varchar2(400);
    ln_tn_bscs varchar2(20);
    ln_error number;
    lv_error varchar2(4000);
    -- ini 5.0
    ln_valor number;
    ln_tiptra number;

    cursor c_request(an_codid number) is
      select request
        from mdsrrtab@DBL_BSCS_BF
       where co_id = an_codid
         and request_update is null
         and status not in (9, 7)
         and action_id in (1);
    -- fin 5.0
    v_codigon number;--INC000001166050
  begin
    if f_val_tlflinea_abierta_ctrl(an_codsolot) = 0 then
      --ini 6.0
      operacion.pkg_cambio_ciclo_fact.sgasu_camb_ciclo_fact(an_codsolot,
                                                            ln_error,
                                                            lv_error);
      --fin 6.0

      an_error_contr := 0;

      operacion.pq_sga_iw.p_cons_numtelefonico_sot(an_codsolot,
                                                   lv_numero,
                                                   lv_codcli,
                                                   ln_cod_id,
                                                   ln_customer,
                                                   ln_codinssrv,
                                                   an_error,
                                                   av_error);

      if an_error = 1 then
        -- ini 5.0
        select to_number(c.valor) into ln_valor
        from constante c where c.constante = 'REGCONTR_SERCAB';

        select count(1) into ln_tiptra from solot s
        where s.codsolot = an_codsolot
          and exists (select 1
                      from tipopedd t, opedd o
                      where t.tipopedd = o.tipopedd
                      and t.abrev = 'CONFSERVADICIONAL'
                      and o.abreviacion = 'TIPTRA_CSC_CP'
                      and o.codigon = s.tiptra);

        if ln_valor = 2 and ln_tiptra = 1 then
          for c_r in c_request(ln_cod_id) loop
            contract.finish_request@dbl_bscs_bf(c_r.request);
            update mdsrrtab@dbl_bscs_bf
               set status = 7
             where request = c_r.request;
            commit;
          end loop;
        end if;
        -- fin 5.0
        -- Alineamos los numeros en el caso
        ln_tn_bscs := tim.tfun051_get_dnnum_from_coid@DBL_BSCS_BF(ln_cod_id);
        operacion.pq_hfc_alineacion.p_regulariza_numero(ln_cod_id,lv_numero,ln_tn_bscs,2,ln_error,lv_error);

        begin
            select ca.customer_id, ca.tmcode, ps.sncode
              into v_customer_id, v_tmcode, v_sncode
              from contract_all@dbl_bscs_bf          ca,
                   profile_service@dbl_bscs_bf       ps,
                   tim.pf_hfc_parametros@dbl_bscs_bf hf
             where ca.co_id = ln_cod_id
               and ca.co_id = ps.co_id
               and ps.sncode = hf.cod_prod1
               and HF.CAMPO = 'SERV_TELEFONIA';
        exception
          when too_many_rows then
             --Inicio INC000001166050
             Select t.Codigon INTO v_codigon from OPERACION.opedd t where t.abreviacion='SRV_DUPLICID';
              select ca.customer_id, ca.tmcode, ps.sncode
                into v_customer_id, v_tmcode, v_sncode
                from contract_all@dbl_bscs_bf          ca,
                     profile_service@dbl_bscs_bf       ps,
                     tim.pf_hfc_parametros@dbl_bscs_bf hf
               where ca.co_id = ln_cod_id
                 and ca.co_id = ps.co_id
                 and ps.sncode = hf.cod_prod1
                 and ps.sncode = v_codigon
                 and HF.CAMPO = 'SERV_TELEFONIA';

          when others then
            av_error := 'ERROR:'
            || sqlcode || ' ' || sqlerrm || ' (' || dbms_utility.format_error_backtrace || ')';
            raise error_general_log;
            --Fin INC000001166050
        end;

        ln_existe_csc := f_val_existe_contract_sercad(ln_cod_id);

        --Insertamos en la Contr_servicas si no existe
        if ln_existe_csc = 0 then
          begin
            operacion.pq_sga_bscs.p_reg_contr_services_cap(ln_cod_id,
                                                             lv_numero,
                                                             an_error_contr,
                                                             av_error_contr);
            commit;
          exception
            when others then
              av_error := 'Error al Registrar en la contr_services_cap : ' || sqlcode || ' ' || sqlerrm || ' (' ||
                          dbms_utility.format_error_backtrace || ')';
              raise error_general_log;
          end;
        end if;

        if an_error_contr = 1 or ln_existe_csc > 0 then

          if operacion.pq_sga_iw.f_val_prov_janus_pend(ln_cod_id) = 0 then

              operacion.pq_sga_iw.p_cons_linea_janus(lv_numero,
                                                     ln_out_janus,
                                                     lv_mensaje_janus,
                                                     lv_customer_id_janus,
                                                     ln_codplan_janus,
                                                     lv_producto_janus,
                                                     ld_fecini_janus,
                                                     lv_estado_janus,
                                                     lv_ciclo_janus);

              if ln_out_janus = 0 then
                begin
                  tim.pp001_pkg_prov_janus.sp_prov_nro_hfc@dbl_bscs_bf(ln_cod_id,
                                                                       v_customer_id,
                                                                       v_tmcode,
                                                                       v_sncode,
                                                                       'A',
                                                                       an_error,
                                                                       av_error);

                  p_insert_janus_solot_seg(an_codsolot, ln_cod_id,ln_customer,'ALTALINEAJANUS',
                                           null,null,an_error,av_error);
                exception
                  when others then
                    av_error := 'ERROR al enviar la provision del numero de Janus : ' || sqlcode || ' ' || sqlerrm || ' (' ||
                          dbms_utility.format_error_backtrace || ')';
                    raise error_general_log;
                end;

            elsif ln_out_janus = 1 then

              av_error := 'La linea telefonica ya se encuentra provisionada en Janus';
              raise error_general;

            elsif ln_out_janus = -2 then

              av_error := 'La linea telefonica ya existe en JANUS pero no se encuentra asociada a un cliente;
                           por favor derivar el caso con el area de RED para que proceda a eliminar correctamente la linea telefonica de JANUS';
              raise error_general;

            else
              av_error := 'Error Janus : ' || lv_mensaje_janus;
              raise error_general;
            end if;
          else
            av_error := 'Existen pendientes en la provision de Janus';
            raise error_general;
          end if;
        else
          --Inicio INC000001166050
          av_error := 'El numero telefonico no se puede provisionar en JANUS debido a que el contrato para este ya se encuentra desactivo';
          --Fin INC000001166050
          raise error_general;
        end if;
      end if;
    else
      av_error := 'La SOT tiene asociado un servicio de telefonia (Linea Abierta), estas no se Provisionan a JANUS';
      raise error_general;
    end if;

    an_error := 1;
    av_error := 'Exito al enviar la provision del numero de Janus';
    p_reg_log(null,
              null,
              NULL,
              an_codsolot,
              null,
              an_Error,
              av_error,
              ln_cod_id,
              'JANUS-Alta Numero BSCS');
  exception
    when error_general_log then
      an_error := -1;
      p_reg_log(null,
              null,
              NULL,
              an_codsolot,
              null,
              an_error,
              av_error,
              ln_cod_id,
              'JANUS-Alta Numero BSCS');

    when error_general then
      an_error := -1;

    when others then
      an_error := -1;
      av_error := 'ERROR al enviar la provision del numero de Janus : '
                  || sqlcode || ' ' || sqlerrm || ' (' ||
                          dbms_utility.format_error_backtrace || ')';

  end p_altanumero_janus_bscs;

  procedure p_bajanumero_janus_sga(an_codsolot number,
                                   an_error    out integer,
                                   av_error    out varchar2) is
    ln_cod_id   number;
    lv_trama    varchar2(20);
    lv_numero   varchar2(8);

    ln_out_janus         number;
    lv_mensaje_janus     varchar2(500);
    lv_customer_id_janus varchar2(20);
    ln_codplan_janus     number;
    lv_producto_janus    varchar2(100);
    ld_fecini_janus      date;
    lv_estado_janus      varchar2(20);
    lv_ciclo_janus       varchar2(5);

    ln_codinssrv number;
    lv_codcli varchar2(8);
    ln_customer number;
    error_general exception;

  begin
    -- Para este caso el Contrato es el CODINSSRV
    operacion.pq_sga_iw.p_cons_numtelefonico_sot(an_codsolot,
                                                 lv_numero,
                                                 lv_codcli,
                                                 ln_cod_id,
                                                 ln_customer,
                                                 ln_codinssrv,
                                                 an_error,
                                                 av_error);

    if an_error = 1 then

       if operacion.pq_sga_iw.f_val_prov_janus_pend(ln_codinssrv) = 0 then

          operacion.pq_sga_iw.p_cons_linea_janus(lv_numero,
                                                 ln_out_janus,
                                                 lv_mensaje_janus,
                                                 lv_customer_id_janus,
                                                 ln_codplan_janus,
                                                 lv_producto_janus,
                                                 ld_fecini_janus,
                                                 lv_estado_janus,
                                                 lv_ciclo_janus);

          if ln_out_janus = 1 or ln_out_janus = -2 then

            update operacion.janus_solot_seg s set s.procesado = 1
            where s.codsolot = an_codsolot
            and s.accion = 'BAJALINEAJANUS';

            lv_trama := 'IMSI' || trim(lv_numero);

            operacion.pq_sga_iw.p_insert_prov_ctrl_janus(2, 4, lv_customer_id_janus ,ln_codinssrv,0,lv_trama,
                                                         an_error, av_error);

            p_insert_janus_solot_seg(an_codsolot, ln_codinssrv,null,'BAJALINEAJANUS',
                                     lv_customer_id_janus,lv_numero,an_error,av_error);

            an_error := 1;
            av_error := 'Exito al enviar la baja del numero de Janus';

          else
            av_error := 'Error Janus: '|| lv_mensaje_janus;
            raise error_general;
          end if;
       else
          av_error := 'Existen pendientes en la provision de Janus';
          raise error_general;
       end if;
    else
        av_error := 'La SOT no tiene el servicio de Telefonia para enviar a Janus';
        raise error_general;
    end if;

  p_reg_log(null,
            null,
            NULL,
            an_codsolot,
            null,
            an_Error,
            av_error,
            ln_codinssrv,
            'JANUS-Baja Numero SGA');
  exception
    when error_general then
      an_error := -1;

    when others then
      an_error := -1;
      av_error := 'ERROR al enviar la baja del numero de Janus : ' ||
                  to_char(sqlerrm);
      p_reg_log(null,
            null,
            NULL,
            an_codsolot,
            null,
            an_Error,
            av_error,
            ln_codinssrv,
            'JANUS-Baja Numero SGA');

  end p_bajanumero_janus_sga;

  procedure p_bajacliente_janus_sga(an_codsolot number,
                                  an_error    out integer,
                                  av_error    out varchar2) is
    ln_cod_id   number;
    lv_numero   varchar2(8);
    lv_customer_janus varchar2(20);

    ln_codinssrv number;
    lv_codcli varchar2(8);
    ln_customer number;
    ln_valida_envio number;
    error_general exception;
  begin

    operacion.pq_sga_iw.p_cons_numtelefonico_sot(an_codsolot,
                                                 lv_numero,
                                                 lv_codcli,
                                                 ln_cod_id,
                                                 ln_customer,
                                                 ln_codinssrv,
                                                 an_error,
                                                 av_error);

    if an_error = 1 then

       if operacion.pq_sga_iw.f_val_prov_janus_pend(ln_codinssrv) = 0 then

          -- Obtenemos el Customer de JANUS
          lv_customer_janus := f_retorna_customerjanusxsot(an_codsolot);

          if lv_customer_janus != '00' then

             ln_valida_envio := OPERACION.PQ_SGA_IW.f_valida_prov_numero(lv_customer_janus);

             if ln_valida_envio = 1 then

                operacion.pq_sga_iw.p_insert_prov_bscs_janus(2,5,ln_customer,ln_codinssrv,'2',1,lv_customer_janus,an_error,av_error);

                p_insert_janus_solot_seg(an_codsolot, ln_codinssrv,ln_customer,'BAJACLIENTEJANUS',
                                     null,null,an_error,av_error);

                an_error := 1;
                av_error := 'Exito al enviar la baja del cliente de Janus';

              elsif ln_valida_envio = 2 then

                operacion.pq_sga_iw.p_insert_prov_ctrl_janus(2, 4, lv_customer_janus ,ln_codinssrv,0,lv_customer_janus,
                                                          an_error, av_error);

                p_insert_janus_solot_seg(an_codsolot, ln_codinssrv,null,'BAJACLIENTEJANUS',
                                        lv_customer_janus,lv_numero,an_error,av_error);

                an_error := 1;
                av_error := 'Exito al enviar la baja del Cliente de Janus';

              end if;

         end if;

      else
        av_error := 'Existen pendientes en la provision de Janus';
        raise error_general;
      end if;

    else
        av_error := 'La SOT no tiene el servicio de Telefonia para enviar a Janus';
        raise error_general;
    end if;

  p_reg_log(null,
            null,
            NULL,
            an_codsolot,
            null,
            an_Error,
            av_error,
            ln_codinssrv,
            'JANUS-Baja Cliente SGA');
  exception
    when error_general then
      an_error := -1;

    when others then
      an_error := -1;
      av_error := 'ERROR al enviar la baja del numero de Janus : ' ||
                  to_char(sqlerrm);
      p_reg_log(null,
            null,
            NULL,
            an_codsolot,
            null,
            an_Error,
            av_error,
            ln_codinssrv,
            'JANUS-Baja Cliente SGA');

  end p_bajacliente_janus_sga;

  procedure p_bajatotal_janus_sga(an_codsolot number,
                                   an_error    out integer,
                                   av_error    out varchar2) is
    ln_cod_id   number;
    lv_trama    varchar2(20);
    lv_numero   varchar2(8);
    ln_customer number;

    ln_out_janus         number;
    lv_mensaje_janus     varchar2(500);
    lv_customer_id_janus varchar2(20);
    ln_codplan_janus     number;
    lv_producto_janus    varchar2(100);
    ld_fecini_janus      date;
    lv_estado_janus      varchar2(20);
    lv_ciclo_janus       varchar2(5);

    ln_codinssrv number;
    lv_codcli varchar2(8);
    error_general exception;

  begin
    -- Para este caso el Contrato es el CODINSSRV
    operacion.pq_sga_iw.p_cons_numtelefonico_sot(an_codsolot,
                                                 lv_numero,
                                                 lv_codcli,
                                                 ln_cod_id,
                                                 ln_customer,
                                                 ln_codinssrv,
                                                 an_error,
                                                 av_error);

    if an_error = 1 then

      if operacion.pq_sga_iw.f_val_prov_janus_pend(ln_codinssrv) = 0 then

          operacion.pq_sga_iw.p_cons_linea_janus(lv_numero,
                                                 ln_out_janus,
                                                 lv_mensaje_janus,
                                                 lv_customer_id_janus,
                                                 ln_codplan_janus,
                                                 lv_producto_janus,
                                                 ld_fecini_janus,
                                                 lv_estado_janus,
                                                 lv_ciclo_janus);

          if ln_out_janus = 1 then

            lv_trama := 'IMSI' || trim(lv_numero);

            operacion.pq_sga_iw.p_insert_prov_ctrl_janus(2, 4, lv_customer_id_janus ,ln_codinssrv,0,lv_trama,
                                     an_error, av_error);

            operacion.pq_sga_iw.p_insert_prov_ctrl_janus(2, 4, lv_customer_id_janus ,ln_codinssrv,0,lv_customer_id_janus,
                                     an_error, av_error);
            an_error := 1;
            av_error := 'Exito al enviar la baja del numero de Janus';

          elsif ln_out_janus = -2 then

            lv_trama := 'IMSI' || trim(lv_numero);
            lv_codcli := '9'||lv_codcli;
            operacion.pq_sga_iw.p_insert_prov_ctrl_janus(2, 4, lv_codcli ,ln_codinssrv,0,lv_trama,
                                     an_error, av_error);

            an_error := 1;
            av_error := 'Exito al enviar la baja del numero de Janus';

          else
            av_error := 'Error Janus : ' || lv_mensaje_janus;
            raise error_general;
          end if;
      else
          av_error := 'Existen pendientes en la provision de Janus';
          raise error_general;
      end if;
    else
        av_error := 'La SOT no tiene el servicio de Telefonia para enviar a Janus';
        raise error_general;
    end if;

  p_reg_log(null,
            null,
            NULL,
            an_codsolot,
            null,
            an_Error,
            av_error,
            ln_codinssrv,
            'JANUS-Baja Total SGA');
  exception
    when error_general then
      an_error := -1;
    when others then
      an_error := -1;
      av_error := 'ERROR al enviar la baja del numero de Janus : ' ||
                  to_char(sqlerrm);
      p_reg_log(null,
            null,
            NULL,
            an_codsolot,
            null,
            an_Error,
            av_error,
            ln_codinssrv,
            'JANUS-Baja Total SGA');
  end p_bajatotal_janus_sga;

  procedure p_altanumero_janus_sga(an_codsolot number,
                                   an_error    out integer,
                                   av_error    out varchar2) is
  vs_hcon      varchar2(1) := 9;
  vs_hccd      varchar2(4) := 'HCCD';
  l_trama      varchar2(4000);
  v_msgerr     varchar2(1000);
  v_respuesta  varchar2(1000);
  lv_ciclo     varchar2(10);
  ln_contciclo number;

  ln_out_janus         number;
  lv_mensaje_janus     varchar2(500);
  lv_customer_id_janus varchar2(20);
  ln_codplan_janus     number;
  lv_producto_janus    varchar2(100);
  ld_fecini_janus      date;
  lv_estado_janus      varchar2(20);
  lv_ciclo_janus       varchar2(5);
  lv_trama             varchar2(400);
  lv_codcli            varchar2(20);
  error_general       exception;
  error_general_log   exception;

  cursor c_lineaxsot is
    select distinct ins.codinssrv,
                    trim(ins.numero) numero,
                    r.plan plan_actual_SGA,
                    r.plan_opcional plan_opc_actual_SGA,
                    ins.codcli,
                    decode(v.tipdide, '001', v.ntdide, null) ruc,
                    intraway.f_retorna_nomcli_itw(v.nomclires) nombre_clires,
                    intraway.f_retorna_nomcli_itw(v.nomclires) || ' ' ||
                    intraway.f_retorna_nomcli_itw(v.apepatcli) apenom_cliente,
                    v.tipdide,
                    v.ntdide,
                    intraway.f_retorna_nomcli_itw(v.nomcli) razon,
                    trim(v.telefono1) telef_1,
                    trim(v.telefono2) telef_2,
                    trim(v.mail) mail,
                    intraway.f_retorna_nomcli_itw(substr(v.dircli, 1, 200)) direc_cliente,
                    intraway.f_retorna_nomcli_itw(substr(v.referencia,
                                                         1,
                                                         200)) refere_cliente,
                    (select u.nomdst
                       from v_ubicaciones u
                      where u.codubi = ins.codubi) nomdst,
                    (select u.nompvc
                       from v_ubicaciones u
                      where u.codubi = ins.codubi) nompvc,
                    (select u.nomest
                       from v_ubicaciones u
                      where u.codubi = ins.codubi) nomest
      from solot       s,
           solotpto    pto,
           inssrv      ins,
           tystabsrv   tt,
           plan_redint r,
           vtatabcli   v
     where s.codsolot = pto.codsolot
       and tt.codsrv = ins.codsrv
       and tt.idplan = r.idplan
       and pto.codinssrv = ins.codinssrv
       and v.codcli = ins.codcli
       and ins.tipinssrv = 3
       and ins.estinssrv = 1
       and s.codsolot = an_codsolot;

  begin

    if f_val_tlflinea_abierta_ctrl(an_codsolot) = 0 then

      for bb in c_lineaxsot loop

        select to_number(c.valor)
          into ln_contciclo
          from constante c
         where c.constante = 'CCICLO_JANUS';

        if ln_contciclo = 1 then
          lv_ciclo := f_get_ciclo_codinssrv(bb.numero, bb.codinssrv);
        else
          lv_ciclo := '01';
        end if;

        if operacion.pq_sga_iw.f_val_prov_janus_pend(bb.codinssrv) = 0  then

            operacion.pq_sga_iw.p_cons_linea_janus(bb.numero,
                                                   ln_out_janus,
                                                   lv_mensaje_janus,
                                                   lv_customer_id_janus,
                                                   ln_codplan_janus,
                                                   lv_producto_janus,
                                                   ld_fecini_janus,
                                                   lv_estado_janus,
                                                   lv_ciclo_janus);

            if ln_out_janus = 0 then
              l_trama := vs_hcon || bb.codcli || '|' || vs_hccd || bb.codcli || '|' ||
                         bb.ruc || '|' || bb.nombre_clires || '|' ||
                         bb.apenom_cliente || '|' || bb.tipdide || '|' ||
                         bb.ntdide || '|' || bb.razon || '|' || bb.telef_1 || '|' ||
                         bb.telef_2 || '|' || bb.mail || '|' || bb.direc_cliente || '|' ||
                         bb.refere_cliente || '|' || bb.nomdst || '|' ||
                         bb.nompvc || '|' || bb.nomest || '|' || bb.codinssrv || '|' ||
                         bb.numero || '|' || 'IMSI' || bb.numero || '|' ||

                         lv_ciclo || '|' || bb.plan_actual_SGA || '|' ||
                         bb.plan_opc_actual_SGA;
              begin

                tim.pp001_pkg_prov_janus.SP_REG_PROV_CTRL@dbl_bscs_bf(12,
                                                                      1,
                                                                      l_trama,
                                                                      v_respuesta,
                                                                      v_msgerr);

                if v_respuesta = 0 then
                  insert into operacion.janus_solot_seg(codsolot, codcli, accion)
                  values (an_codsolot, bb.codcli, 'ALTALINEAJANUS');
                else
                  av_error := 'Provision Janus : ' || v_msgerr;
                  raise error_general_log;
                end if;

             exception
               when others then
                 av_error := 'ERROR al enviar la provision del numero de Janus : ' ||  sqlerrm ;
                 raise error_general_log;
             end;

            elsif ln_out_janus = -2 then

              av_error := 'La linea telefonica ya existe en JANUS pero no se encuentra asociada a un cliente;
                           por favor derivar el caso con el area de RED para que proceda a eliminar correctamente la linea telefonica de JANUS';
              raise error_general;

            elsif ln_out_janus = 1 then

              --an_error := -1;
              av_error := 'La linea telefonica ya se encuentra provisionada en Janus';
              raise error_general;

            else
              --an_error := -1;
              av_error := 'Error Janus : ' || lv_mensaje_janus;
              raise error_general_log;
            end if;
          else
             --an_error := -1;
             av_error := 'Existen pendientes en la provision de Janus';
             raise error_general;
          end if;
      end loop;
    else
      --an_error := -1;
      av_error := 'La SOT tiene asociado un servicio de telefonia (Linea Abierta), estas no se Provisionan a JANUS';
      raise error_general;
    end if;

    an_error := 1;
    av_error := 'Exito al enviar la provision del numero de Janus';

    p_reg_log(null,
              null,
              NULL,
              an_codsolot,
              null,
              an_Error,
              av_error,
              0,
              'JANUS-Alta Numero SGA');

  exception
    when error_general_log then
      an_error := -1;
      p_reg_log(null,
              null,
              NULL,
              an_codsolot,
              null,
              an_error,
              av_error,
              0,
              'JANUS-Alta Numero SGA');

    when error_general then
      an_error := -1;
    when others then
      an_error := -1;
      av_error := 'Error : ' || sqlerrm;
      p_reg_log(null,
              null,
              NULL,
              an_codsolot,
              null,
              an_error,
              av_error,
              0,
              'JANUS-Alta Numero SGA');

  end p_altanumero_janus_sga;

  procedure p_bajanumero_janus_sga_ce(an_codsolot number,
                                      av_numero   varchar2,
                                      an_error    out integer,
                                      av_error    out varchar2) is

  lv_trama varchar2(3000);

  cursor c_linea is
     SELECT e.codsolot, f.pid, ins.numero, f.codinssrv
        FROM tystabsrv b,
             (SELECT a.codsolot, b.codinssrv, MAX(c.pid) pid
                FROM solotpto a, inssrv b, insprd c
               WHERE a.codinssrv = b.codinssrv
                 AND b.tipinssrv = 3
                 AND b.codinssrv = c.codinssrv
                 AND c.flgprinc = 1
               GROUP BY a.codsolot, b.codinssrv) e,
             insprd f,
             inssrv ins
       WHERE f.codinssrv = e.codinssrv
         AND f.pid = e.pid
         AND f.codsrv = b.codsrv
         AND b.codsrv NOT IN
             (SELECT d.codigoc
                FROM tipopedd c, opedd d
               WHERE c.abrev = 'CFAXSERVER'
                 AND c.tipopedd = d.tipopedd
                 AND d.abreviacion = 'CFAXSERVER_SRV')
         AND e.codinssrv = ins.codinssrv
         and (ins.numero = av_numero or nvl(av_numero,'X')='X')
         and e.codsolot = an_codsolot
       ORDER BY f.pid DESC;

  ln_cantlinea number;
  ln_enviadas number;
  error_general_log   exception;

  begin
    ln_enviadas := 0;

    ln_cantlinea := f_obt_cant_linea_ce(an_codsolot);

    for c_lin in c_linea loop

      ln_enviadas := ln_enviadas + 1;

      lv_trama :=  operacion.pq_janus_ce_baja.armar_trama(c_lin.numero,c_lin.codinssrv, ln_cantlinea - ln_enviadas);

      tim.pp001_pkg_prov_janus.sp_reg_prov_ctrl_corp@dbl_bscs_bf(1000, 2, lv_trama, an_error, av_error);

      if an_error != 0 then
        av_error := 'ERROR al enviar la baja del numero ' || c_lin.numero || ' CE de Janus : ' || av_error;
        raise error_general_log;
      end if;
    end loop;

    p_insert_janus_solot_seg(an_codsolot, null, null, 'BAJALINEAJANUS', null,null,an_error,av_error);

    an_error := 1;
    av_error := 'Exito al enviar la provision de baja a Janus';

    p_reg_log(null,
              null,
              NULL,
              an_codsolot,
              null,
              an_error,
              av_error,
              0,
              'JANUS-Baja Numero SGACE');

  exception
    when error_general_log then
      an_error := -1;
      p_reg_log(null,
              null,
              NULL,
              an_codsolot,
              null,
              an_error,
              av_error,
              0,
              'JANUS-Baja Numero SGACE');
    when others then
      an_error := -1;
      av_error := 'ERROR al enviar la baja del numero CE de Janus : ' ||
                  to_char(sqlerrm);
      p_reg_log(null,
              null,
              NULL,
              an_codsolot,
              null,
              an_error,
              av_error,
              0,
              'JANUS-Baja Numero SGACE');

  end p_bajanumero_janus_sga_ce;

  procedure p_bajacliente_janus_sga_ce(an_codsolot number,
                                       an_error    out integer,
                                       av_error    out varchar2) is
  begin
      an_error := 1;
      av_error := 'Exito al enviar la baja del numero de Janus';
  exception
    when others then
      an_error := -1;
      av_error := 'ERROR al enviar la baja del numero de Janus : ' ||
                  to_char(sqlerrm);

  end p_bajacliente_janus_sga_ce;

  procedure p_altanumero_janus_sga_ce(an_codsolot number,
                                      av_numero   varchar2,
                                      an_error    out integer,
                                      av_error    out varchar2) is

    lv_trama varchar2(3000);
    ln_out_janus         number;
    lv_mensaje_janus     varchar2(500);
    lv_customer_id_janus varchar2(20);
    ln_codplan_janus     number;
    lv_producto_janus    varchar2(100);
    ld_fecini_janus      date;
    lv_estado_janus      varchar2(20);
    lv_ciclo_janus       varchar2(5);
    error_serv_pend exception;
    error_general       exception;
    error_general_log   exception;

  cursor c_linea is
     select e.numslc, e.codinssrv, trim(e.numero) numero, b.pid
        from solotpto a, insprd b, tystabsrv c, inssrv e, solot g
       where a.pid = b.pid
         and e.tipinssrv = 3
         and b.codsrv = c.codsrv
         and e.codinssrv = b.codinssrv
         and a.codsolot = g.codsolot
         and b.flgprinc = 1
         and g.codsolot = an_codsolot
         and (trim(e.numero) = av_numero or nvl(av_numero,'X')='X')
         and e.cid is not null;
  begin
    if f_val_tlflinea_abierta_ctrl(an_codsolot) = 0 then
      for c_lin in c_linea loop
        if operacion.pq_sga_iw.f_val_prov_janus_pend(c_lin.codinssrv) = 0 then
           operacion.pq_sga_iw.p_cons_linea_janus(c_lin.numero,
                                                 ln_out_janus,
                                                 lv_mensaje_janus,
                                                 lv_customer_id_janus,
                                                 ln_codplan_janus,
                                                 lv_producto_janus,
                                                 ld_fecini_janus,
                                                 lv_estado_janus,
                                                 lv_ciclo_janus);

          if ln_out_janus = 0 then

             begin
               lv_trama := f_retorna_trama_alta_ce(an_codsolot, c_lin.numslc, c_lin.codinssrv, c_lin.numero);

               tim.pp001_pkg_prov_janus.sp_reg_prov_ctrl_corp@dbl_bscs_bf(1000, 1,
                                                                                lv_trama,
                                                                                an_error,
                                                                                av_error);
               if an_error != 0 then
                  av_error := 'ERROR al enviar la provision del numero ' || c_lin.numero || ' a Janus : ' || av_error;
                  raise error_general_log;
               end if;

             exception
               when others then
                 av_error := 'ERROR al enviar la provision del numero a Janus : ' ||  sqlerrm ;
                 raise error_general_log;
             end;

             an_error := 1;
             av_error := 'Se envio la provision correctamente a Janus';

          end if;
        else
          av_error := 'Existen pendientes en la provision de Janus CE';
          raise error_general;
        end if;
      end loop;
    else
      av_error := 'La SOT tiene asociado un servicio de telefonia (Linea Abierta), estas no se Provisionan a JANUS';
      raise error_general;
    end if;

    p_insert_janus_solot_seg(an_codsolot, null, null, 'ALTALINEAJANUS', null,null,an_error,av_error);

    an_error := 1;
    av_error := 'Exito al enviar la provision del numero de Janus';

    p_reg_log(null,
              null,
              NULL,
              an_codsolot,
              null,
              an_Error,
              av_error,
              0,
              'JANUS-Alta Numero SGACE');
  exception
    when error_general then
      an_error := -1;
    when error_general_log then
      an_error := -1;
      p_reg_log(null,
              null,
              NULL,
              an_codsolot,
              null,
              an_Error,
              av_error,
              0,
              'JANUS-Alta Numero SGACE');
    when others then
      an_error := -1;
      av_error := 'Error : ' || sqlerrm;

  end p_altanumero_janus_sga_ce;

  procedure p_cons_det_iw_sga(a_codsolot in solot.codsolot%type,
                              an_error   out integer,
                              av_error   out varchar2) is
    v_out            number;
    v_mens           varchar2(400);
    v_idprodpadre    number;
    v_idventpadre    number;
    v_macadd         varchar2(400);
    v_modelmta       varchar2(400);
    v_profile        varchar2(400);
    v_hub            varchar2(400);
    v_nodo           varchar2(400);
    v_activationcode varchar2(400);
    v_cantpcs        number;
    v_servpackname   varchar2(400);
    v_mensajesus     varchar2(400);
    v_central        varchar2(400);
    v_serial         varchar2(400);
    v_unitd          varchar2(400);
    v_disab          varchar2(400);
    v_equp           varchar2(400);
    v_product        varchar2(400);
    v_channel        varchar2(400);
    l_customer_id    number(8);
    l_id_producto    varchar2(20);
    error_iw_getreport exception;
    error_general      exception;
    v_serialnumber varchar2(200);
    ln_valinc        number; --9.0
    lv_tn            varchar2(100); --9.0

    cursor c_servicio_iw_int is
       select to_number(s.codcli) customer_id,
             iw.id_interfase,
             'INT' tip_interfase,
             iw.id_producto
        from intraway.int_servicio_intraway iw, solot s
       where iw.id_interfase in (620)
         and s.codsolot = iw.codsolot
         and s.codsolot = a_codsolot;

   cursor c_servicio_iw_tlf is
      select to_number(s.codcli) customer_id,
             iw.id_interfase,
             'TLF' tip_interfase,
             iw.id_producto
        from intraway.int_servicio_intraway iw, solot s
       where iw.id_interfase in (820)
         and s.codsolot = iw.codsolot
         and s.codsolot = a_codsolot;

   cursor equipos_ctv is
          select to_number(s.codcli) codcli,
                 iw.id_interfase,
                 'CTV',
                 iw.id_producto
            from intraway.int_servicio_intraway iw, solot s
           where iw.id_interfase in (2020)
             and s.codsolot = iw.codsolot
             and s.codsolot = a_codsolot;
  begin
    --Eliminamos para volver a cargar la informacion
    delete from operacion.tab_equipos_iw w where w.codsolot = a_codsolot;

    for c_in in c_servicio_iw_int loop
      --obtenemos datos de iw
      --9.0 Ini
      intraway.pq_migracion_iw.P_VALIDAR_SUC_INC(a_codsolot,ln_valinc);

      if ln_valinc = 1 Then
        intraway.pq_migracion_iw.P_TRAE_DOCSIS_MAC(l_customer_id,
                                                   l_id_producto,
                                                   v_out,
                                                   v_mens,
                                                   v_macadd,
                                                   v_servpackname,
                                                   v_serialnumber);
      Else
        intraway.pq_consultaitw.p_int_consultacm(c_in.customer_id,
                                                 c_in.id_producto,
                                                 0,
                                                 v_out,
                                                 v_mens,
                                                 v_hub,
                                                 v_nodo,
                                                 v_macadd,
                                                 v_activationcode,
                                                 v_cantpcs,
                                                 v_servpackname,
                                                 v_mensajesus,
                                                 v_serialnumber);
      End If;
      --9.0 Fin
      merge into operacion.tab_equipos_iw d
      using (select a_codsolot     codsolot,
                    c_in.customer_id  customer_id,
                    c_in.id_producto  id_producto,
                    v_macadd       macadd,
                    v_servpackname servpackname,
                    v_serialnumber serialnumber,
                    620
               from dual) f
      on (d.codsolot = f.codsolot and d.interfase = 620 and d.id_producto = f.id_producto)
      when matched then
        update set mac_address = f.macadd
      when not matched then
        insert
          (codsolot,
           codcli,
           id_producto,
           tipo_servicio,
           interfase,
           mac_address,
           profile_crm,
           serial_number)
        values
          (f.codsolot,
           lpad(f.customer_id,8,0),
           f.id_producto,
           'INT',
           '620',
           f.macadd,
           f.servpackname,
           f.serialnumber);
    end loop;

    for c_in in c_servicio_iw_tlf loop
        --9.0 Ini
        intraway.pq_migracion_iw.P_VALIDAR_SUC_INC(a_codsolot,ln_valinc);

        if ln_valinc = 1 Then
          intraway.pq_migracion_iw.P_TRAE_VOICE_MAC(l_customer_id,
                                                    l_id_producto,
                                                    v_out,
                                                    v_mens,
                                                    v_macadd,
                                                    v_modelmta,
                                                    v_profile,
                                                    lv_tn);
        Else
          intraway.pq_consultaitw.p_int_consultamta(c_in.customer_id,
                                                    c_in.id_producto,
                                                    0,
                                                    v_out,
                                                    v_mens,
                                                    v_idprodpadre,
                                                    v_idventpadre,
                                                    v_macadd,
                                                    v_modelmta,
                                                    v_profile,
                                                    v_activationcode,
                                                    v_central);
        End IF;
        --9.0 Fin
        merge into operacion.tab_equipos_iw d
        using (select a_codsolot    codsolot,
                      l_customer_id customer_id,
                      l_id_producto id_producto,
                      v_macadd      macadd,
                      v_modelmta    modelmta,
                      v_profile     profilemta,
                      820,
                      v_central     central
                 from dual) f
        on (d.codsolot = f.codsolot and d.interfase = 820 and d.id_producto = f.id_producto)
        when matched then
          update
             set mac_address = f.macadd,
                 modelo      = f.modelmta,
                 profile_crm = f.profilemta
        when not matched then
          insert
            (codsolot,
             codcli,
             id_producto,
             tipo_servicio,
             interfase,
             mac_address,
             modelo,
             profile_crm,
             serial_number)
          values
            (f.codsolot,
             lpad(f.customer_id,8,0),
             f.id_producto,
             'TLF',
             '820',
             f.macadd,
             f.modelmta,
             f.profilemta,
             f.central);
    end loop;

    for c in equipos_ctv loop
          --9.0 Ini
          intraway.pq_migracion_iw.P_VALIDAR_SUC_INC(a_codsolot,ln_valinc);

          if ln_valinc = 1 Then
            intraway.pq_migracion_iw.P_TRAE_DTV_MAC(l_customer_id,
                                                    l_id_producto,
                                                    v_out,
                                                    v_mens,
                                                    v_serial,
                                                    v_unitd,
                                                    v_equp,
                                                    v_hub);
          Else
            intraway.pq_consultaitw.p_int_consultatv(c.codcli,
                                                     c.id_producto,
                                                     0,
                                                     v_out,
                                                     v_mens,
                                                     v_serial,
                                                     v_unitd,
                                                     v_disab,
                                                     v_equp,
                                                     v_hub,
                                                     v_product,
                                                     v_channel);
          End If;
          --9.0
          merge into operacion.tab_equipos_iw d
          using (select a_codsolot    codsolot,
                        c.codcli      customer_id,
                        c.id_producto id_producto,
                        v_serial      serial,
                        v_unitd       unitd,
                        v_equp        equp,
                        v_hub         hub,
                        2020
                   from dual) f
          on (d.codsolot = f.codsolot and d.interfase = 2020 and d.id_producto = c.id_producto)
          when matched then
            update
               set serial_number = f.serial,
                   unit_address  = f.unitd,
                   stbtypecrmid  = f.equp,
                   profile_crm   = f.hub
          when not matched then
          --insertamos
            insert
              (codsolot,
               codcli,
               id_producto,
               tipo_servicio,
               interfase,
               serial_number,
               unit_address,
               stbtypecrmid,
               profile_crm)
            values
              (f.codsolot,
               lpad(f.customer_id,8,0),
               f.id_producto,
               'CTV',
               '2020',
               f.serial,
               f.unitd,
               f.equp,
               f.hub);

    end loop;

    av_error := 'Éxito en el proceso';
    an_error := 0;

  exception
    when error_general then
      av_error := 'ERROR al obtener la informacion de iw ' || ' ' ||
                  av_error;
      an_error := an_error;
    when error_iw_getreport then
      av_error := 'ERROR al obtener la informacion de iw : ' || av_error;
      an_error := -19;
    when others then
      av_error := 'ERROR al obtener la informacion de iw  : ' || sqlerrm;
      an_error := sqlcode;
  end p_cons_det_iw_sga;

  function f_val_existe_contract_sercad(an_cod_id number) return number is
    ln_return number;
  begin

    SELECT count(CSC.CO_ID)
        into ln_return
        FROM CONTR_SERVICES_CAP@dbl_bscs_bf CSC,
             DIRECTORY_NUMBER@dbl_bscs_bf   DN
       WHERE CSC.CO_ID = an_cod_id
         AND CSC.DN_ID = DN.DN_ID
         AND CSC.CS_DEACTIV_DATE IS NULL;

    return ln_return;
  end;

  function f_retorna_customerjanusxsot(an_codsolot number) return varchar2 is

  ln_contar number;
  lv_customer_janus varchar2(20);

  begin
    select count(1) into ln_contar
    from operacion.janus_solot_seg j
    where j.codsolot = an_codsolot
    and j.accion = 'BAJALINEAJANUS'
    and j.procesado = 0
    and j.customer_idjanus is not null;

    if ln_contar = 1 then

      select j.customer_idjanus into lv_customer_janus
         from operacion.janus_solot_seg j
         where j.codsolot = an_codsolot
         and j.accion = 'BAJALINEAJANUS'
         and j.procesado = 0
         and j.customer_idjanus is not null;

         return lv_customer_janus;
    end if;

    return '00';

  end;

  procedure p_ejecutar_baja_janus_ce(an_codsolot number, an_error out number , av_error out varchar2) is

    lv_trama    varchar2(20);
    ln_out_janus         number;
    lv_mensaje_janus     varchar2(500);
    lv_customer_id_janus varchar2(20);
    ln_codplan_janus     number;
    lv_producto_janus    varchar2(100);
    ld_fecini_janus      date;
    lv_estado_janus      varchar2(20);
    lv_ciclo_janus       varchar2(5);

    ln_valida_envio number;
    ln_alinea number;
    lv_mensaje varchar2(4000);
    ln_error number;
    lv_error varchar2(4000);

    error_serv_pend exception;
    error_log exception;
    error_janus exception;
    lv_clientejanus_sga varchar2(20);
    lv_valorini_cust varchar2(10);


    cursor c_lineas is
      select e.numslc, e.codinssrv, trim(e.numero) numero, b.pid
        from solotpto a, insprd b, tystabsrv c, inssrv e, solot g
       where a.pid = b.pid
         and e.tipinssrv = 3
         and b.codsrv = c.codsrv
         and e.codinssrv = b.codinssrv
         and a.codsolot = g.codsolot
         and b.flgprinc = 1
         and g.codsolot = an_codsolot
         and e.cid is not null;
  begin

  --Envia la provision de Baja a janus cuando la SOT pasa de Rechazada a Anulada
  --Y cuando es una SOT de Baja
  if f_val_sot_recha_anula(an_codsolot) = 1 or operacion.pq_sga_iw.f_val_sotbaja_hfc(an_codsolot) = 1 then

    for c_lin in c_lineas loop

        operacion.pq_sga_iw.p_cons_linea_janus(c_lin.numero,
                                               ln_out_janus,
                                               lv_mensaje_janus,
                                               lv_customer_id_janus,
                                               ln_codplan_janus,
                                               lv_producto_janus,
                                               ld_fecini_janus,
                                               lv_estado_janus,
                                               lv_ciclo_janus);
        if ln_out_janus = 1 then

            lv_clientejanus_sga := pq_janus_ce.get_conf('P_COD_CUENTA') || c_lin.numslc;

            if lv_customer_id_janus = lv_clientejanus_sga then

                p_bajanumero_janus_sga_ce(an_codsolot, c_lin.numero, an_error, av_error);

                if an_error = -1 then
                  raise error_log;
                end if;

            end if;
        else
          raise error_janus;
        end if;
    end loop;

  else
     for c_lin in c_lineas loop

         if operacion.pq_sga_iw.f_val_prov_janus_pend(c_lin.codinssrv) = 0 then

            operacion.pq_sga_iw.p_cons_linea_janus(c_lin.numero,
                                                   ln_out_janus,
                                                   lv_mensaje_janus,
                                                   lv_customer_id_janus,
                                                   ln_codplan_janus,
                                                   lv_producto_janus,
                                                   ld_fecini_janus,
                                                   lv_estado_janus,
                                                   lv_ciclo_janus);

              if ln_out_janus = 1 then

                 ln_valida_envio := operacion.pq_sga_iw.f_valida_prov_numero(lv_customer_id_janus);
                 -- ln_valida_envio (1: BSCS, 2:SGA )

                 if ln_valida_envio = 1 then -- Enviar la Baja por BSCS

                   lv_trama := 'IMSI' || trim(c_lin.numero);

                   operacion.pq_sga_iw.p_insert_prov_bscs_janus(2,5,to_number(lv_customer_id_janus),c_lin.codinssrv,'2',1,lv_trama,ln_error,lv_error);

                   if ln_error = -1 then
                     raise error_log;
                   end if;

                   p_insert_janus_solot_seg(an_codsolot,c_lin.codinssrv,to_number(lv_customer_id_janus),'BAJALINEAJANUS',
                                            lv_customer_id_janus,c_lin.numero,an_error,av_error);


                 elsif ln_valida_envio = 2 then -- Enviar Baja por SGA

                   p_val_dato_linea_ce_janus(an_codsolot,
                                              c_lin.numero,
                                              lv_customer_id_janus,
                                              ln_codplan_janus,
                                              lv_ciclo_janus,
                                              ln_alinea,
                                              lv_mensaje);


                   select upper(substr(lv_customer_id_janus,1,1)) into lv_valorini_cust from dual;


                   if ln_alinea = 0 and lv_valorini_cust = 'P' then

                     p_bajanumero_janus_sga_ce(an_codsolot, c_lin.numero, an_error, av_error);

                     if an_error = -1 then
                        raise error_log;
                     end if;
                   end if;


                   if ln_alinea = 0 and lv_valorini_cust != 'P' then


                     lv_trama := 'IMSI' || trim(c_lin.numero);


                     operacion.pq_sga_iw.p_insert_prov_ctrl_janus(2, 4, lv_customer_id_janus,c_lin.codinssrv,
                                                                  0,lv_trama,an_error,av_error);


                     if an_error = -1 then
                        raise error_log;
                     end if;


                     p_insert_janus_solot_seg(an_codsolot,c_lin.codinssrv,to_number(lv_customer_id_janus),'BAJALINEAJANUS',
                                              lv_customer_id_janus,c_lin.numero,an_error,av_error);


                   end if;
                end if;

              elsif ln_out_janus = -2 then
                   -- Enviamos la Baja
                   p_bajanumero_janus_sga_ce(an_codsolot, c_lin.numero, an_error, av_error);

                   if an_error = -1 then
                      raise error_log;
                   end if;

              else
                raise error_janus;
              end if;
          else
            raise error_serv_pend;
          end if;
       end loop;
     end if;

  an_error := 1;
  av_error := 'Exito al enviar la baja a Janus';

  p_reg_log(null,
              null,
              NULL,
              an_codsolot,
              null,
              an_Error,
              av_error,
              0,
              'JANUS-Alta Numero SGA-CE');
  exception
    when error_log then
       an_error := -1;
       p_reg_log(null,
              null,
              NULL,
              an_codsolot,
              null,
              an_Error,
              av_error,
              0,
              'JANUS-Alta Numero SGA-CE');

    when error_serv_pend then
      an_error := -1;
      av_error := 'Existen pendientes en la provision de Janus CE';
    when error_janus then
      an_error := -1;
      av_error := 'Error Janus :' || lv_mensaje_janus;
    when others then
      an_error := -1;
      av_error := 'ERROR: P_EJECUTAR_BAJA_JANUS_CE - ' || sqlcode || ' ' || sqlerrm || ' (' ||
                          dbms_utility.format_error_backtrace || ')';

  end p_ejecutar_baja_janus_ce;

  function f_retorna_trama_alta_ce(an_codsolot number,
                                   av_numslc   varchar2,
                                   an_codinssrv number,
                                   av_numero    varchar2)
    return varchar2 is

    lv_trama   varchar2(4000);
    lv_codcli  varchar2(8);
    lv_numslc varchar2(10);
    ln_planbase  number;
    ln_planopcion  number;
    lv_tipdide  varchar2(3);
    lv_ntdide  varchar2(15);
    lv_apellidos  varchar2(80);
    lv_nomcli  varchar2(100);
    lv_ruc  varchar2(15);
    lv_razon  varchar2(200);
    lv_tlf1  varchar2(50);
    lv_tlf2  varchar2(50);
    an_error  number;
    av_error  varchar2(4000);

    av_dirsuc  varchar2(1000);
    av_referencia  varchar2(340);
    av_nomdst  varchar2(40);
    av_nompvc  varchar2(40);
    av_nomest  varchar2(40);

  begin

    p_retorna_datos_cliente_ce(an_codsolot,lv_codcli,lv_numslc,ln_planbase, ln_planopcion,lv_tipdide,lv_ntdide,
                               lv_apellidos,lv_nomcli,lv_ruc,lv_razon,lv_tlf1,lv_tlf2,an_error,av_error);

    p_retorna_datos_sucursal_ce(av_numslc,av_dirsuc,av_referencia,av_nomdst,av_nompvc,av_nomest,an_error,av_error);

    lv_trama := pq_janus_ce.get_conf('P_COD_CUENTA') || lv_numslc || '|';
    lv_trama := lv_trama || pq_janus_ce.get_conf('P_HCCD') || lv_codcli || '|';
    lv_trama := lv_trama || lv_ruc || '|';
    lv_trama := lv_trama || lv_nomcli || '|';
    lv_trama := lv_trama || lv_apellidos || '|';
    lv_trama := lv_trama || lv_tipdide || '|';
    lv_trama := lv_trama || lv_ntdide || '|';
    lv_trama := lv_trama || lv_razon || '|';
    lv_trama := lv_trama || lv_tlf1 || '|';
    lv_trama := lv_trama || lv_tlf2 || '|';
    lv_trama := lv_trama || operacion.pq_janus_ce_alta.get_nomemail(lv_codcli) || '|';
    lv_trama := lv_trama || operacion.pq_janus_ce_alta.trim_dato('DIRSUC', av_dirsuc) || '|';
    lv_trama := lv_trama || operacion.pq_janus_ce_alta.trim_dato('REFERENCIA', av_referencia) || '|';
    lv_trama := lv_trama || av_nomdst || '|';
    lv_trama := lv_trama || av_nompvc || '|';
    lv_trama := lv_trama || av_nomest || '|';
    lv_trama := lv_trama || an_codinssrv || '|';
    lv_trama := lv_trama || av_numero || '|';
    lv_trama := lv_trama || pq_janus_ce.get_conf('P_IMSI') || av_numero|| '|';
    lv_trama := lv_trama || operacion.pq_janus_ce_alta.get_ciclo() || '|';
    lv_trama := lv_trama || ln_planbase || '|';
    lv_trama := lv_trama || ln_planopcion;

    return lv_trama;

  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit || '.Trama CE: ' ||
                              sqlerrm);
  end;

  function f_obt_cant_linea_ce(an_codsolot number) return number is

    ln_cantlinea number;

  begin
    -- Cantidad de Lineas telefonicas de la SOT
    SELECT count(e.codsolot) into ln_cantlinea
        FROM tystabsrv b,
             (SELECT a.codsolot, b.codinssrv, MAX(c.pid) pid
                FROM solotpto a, inssrv b, insprd c
               WHERE a.codinssrv = b.codinssrv
                 AND b.tipinssrv = 3
                 AND b.codinssrv = c.codinssrv
                 AND c.flgprinc = 1
               GROUP BY a.codsolot, b.codinssrv) e,
             insprd f,
             inssrv ins
       WHERE f.codinssrv = e.codinssrv
         AND f.pid = e.pid
         AND f.codsrv = b.codsrv
         AND b.codsrv NOT IN
             (SELECT d.codigoc
                FROM tipopedd c, opedd d
               WHERE c.abrev = 'CFAXSERVER'
                 AND c.tipopedd = d.tipopedd
                 AND d.abreviacion = 'CFAXSERVER_SRV')
         AND e.codinssrv = ins.codinssrv
         and e.codsolot = an_codsolot
       ORDER BY f.pid DESC;

   return ln_cantlinea;

  end;

  procedure p_cont_reproceso_ce(an_cod_id number,
                             an_error  out integer,
                             av_error  out varchar2) is
  BEGIN

     update tim.rp_prov_ctrl_janus@DBL_BSCS_BF p
       set  p.estado_prv = 2, p.fecha_rpt_eai=null,p.errcode=null,p.errmsg=null
     where p.action_id = 1
       and p.estado_prv = '6'
       and upper(trim(p.errmsg)) = upper(trim('Exception al invocar WS connectionManagementServiceControl.activateSpendGroupDetails()'))
       and p.co_id =an_cod_id;


   update tim.rp_prov_ctrl_janus@DBL_BSCS_BF p
       set  p.estado_prv = 2, p.fecha_rpt_eai=null,p.errcode=null,p.errmsg=null
     where p.action_id = 1
       and p.estado_prv = '6'
       and upper(trim(p.errmsg)) = upper(trim('Exception al invocar WS PayerManagementServiceControl.getPayerDetails()'))
       and p.co_id =an_cod_id;

    update tim.rp_prov_ctrl_janus @DBL_BSCS_BF p
       set  p.estado_prv = 2, p.fecha_rpt_eai=null,p.errcode=null,p.errmsg=null
     where p.action_id = 1
       and p.estado_prv = '6'
       and upper(trim(p.errmsg)) = upper(trim('''Error al invocar el provisioningManagementServiceControl.activateSubscriber()'))
       and p.co_id =an_cod_id;

    update tim.rp_prov_ctrl_janus@DBL_BSCS_BF p
       set  p.estado_prv = 2, p.fecha_rpt_eai=null,p.errcode=null,p.errmsg=null
     where p.action_id = 1
       and p.estado_prv = '6'
       and upper(trim(p.errmsg)) = upper(trim('Exception al invocar el servicio BROKER consultaEntidad.consultarDetalleEntidad'))
       and p.co_id =an_cod_id;

       update tim.rp_prov_ctrl_janus@DBL_BSCS_BF p
       set p.estado_prv = 5
       where p.action_id = 1
       and p.estado_prv = '6'
       and upper(trim(p.errmsg)) = upper(trim('PAYER ALREADY EXISTS'))
       and p.co_id = an_cod_id;

       update tim.rp_prov_ctrl_janus@DBL_BSCS_BF p
       set p.estado_prv =2 , p.fecha_rpt_eai=null,p.errcode=null,p.errmsg=null
       where p.action_id = 509
       and p.estado_prv = '6'
       and upper(trim(p.errmsg)) = upper(trim('getBalance no retorno walledId para el tariffId indicado [10690].'))
       and p.co_id = an_cod_id;

       update tim.rp_prov_ctrl_janus@DBL_BSCS_BF p
       set p.estado_prv =2 , p.fecha_rpt_eai=null,p.errcode=null,p.errmsg=null
       where p.action_id = 509
       and p.estado_prv = '6'
       and upper(trim(p.errmsg)) = upper(trim('getBalance no retorno walledId para el tariffId indicado [10710].'))
       and p.co_id = an_cod_id;

       update tim.rp_prov_ctrl_janus@DBL_BSCS_BF p
       set p.estado_prv =2 , p.fecha_rpt_eai=null,p.errcode=null,p.errmsg=null
       where p.action_id = 509
       and p.estado_prv = '6'
       and upper(trim(p.errmsg)) = upper(trim('getBalance no retorno walledId para el tariffId indicado [10730].'))
       and p.co_id = an_cod_id;

       update tim.rp_prov_ctrl_janus@DBL_BSCS_BF p
       set p.estado_prv =2 , p.fecha_rpt_eai=null,p.errcode=null,p.errmsg=null
       where p.action_id = 509
       and p.estado_prv = '6'
       and upper(trim(p.errmsg)) = upper(trim('getBalance no retorno walledId para el tariffId indicado [11311].'))
       and p.co_id = an_cod_id;

       update tim.rp_prov_ctrl_janus@DBL_BSCS_BF p
       set p.estado_prv =2 , p.fecha_rpt_eai=null,p.errcode=null,p.errmsg=null
       where p.action_id = 509
       and p.estado_prv = '6'
       and upper(trim(p.errmsg)) = upper(trim('No se encontro: [BROKER-Consultas-Linea]'))
       and p.co_id = an_cod_id;

       update tim.rp_prov_ctrl_janus@DBL_BSCS_BF p
       set p.estado_prv =2 , p.fecha_rpt_eai=null,p.errcode=null,p.errmsg=null
       where p.action_id = 509
       and p.estado_prv = '6'
       and upper(trim(p.errmsg)) = upper(trim('No se encontro: [BROKER-Consultas-Recargas]'))
       and p.co_id = an_cod_id;

       update tim.rp_prov_ctrl_janus@DBL_BSCS_BF p
       set p.estado_prv =2 , p.fecha_rpt_eai=null,p.errcode=null,p.errmsg=null
       where p.action_id = 509
       and p.estado_prv = '6'
       and upper(trim(p.errmsg)) = upper(trim('No se encontrÃ³PayerManagement]'))
       and p.co_id = an_cod_id;

       update tim.rp_prov_ctrl_janus@DBL_BSCS_BF p
       set p.estado_prv =2 , p.fecha_rpt_eai=null,p.errcode=null,p.errmsg=null
       where p.action_id = 505
       and p.estado_prv = '6'
       and upper(trim(p.errmsg)) = upper(trim('Exception al Invocar el servicio BROKER transaccionesEntidad.actualizarSaldoMinimo'))
       and p.co_id = an_cod_id;


       update tim.rp_prov_ctrl_janus@DBL_BSCS_BF p
       set p.estado_prv =5 , p.fecha_rpt_eai=null,p.errcode=null,p.errmsg='GIVEN MINIMUM BALANCE IS SAME AS PREVIOUS MINIMUM BALANCE.'
       where p.action_id = 505
       and p.estado_prv = '6'
       and upper(trim(p.errmsg)) = upper(trim('GIVEN MINIMUM BALANCE IS SAME AS PREVIOUS MINIMUM BALANCE.'))
       and p.co_id = an_cod_id;

       update tim.rp_prov_ctrl_janus@DBL_BSCS_BF p
       set p.estado_prv =5
       where p.action_id = 500
       and p.estado_prv = '6'
       and upper(trim(p.errmsg)) = upper(trim('PAYER TARIFF IS ALREADY TERMINATED'))
       and p.co_id = an_cod_id;

       update tim.rp_prov_ctrl_janus@DBL_BSCS_BF p
       set p.estado_prv =5
       where p.action_id = 500
       and p.estado_prv = '6'
       and upper(trim(p.errmsg)) = upper(trim('La Operación getRealtionShipDetails es nula'))
       and p.co_id = an_cod_id;

       update tim.rp_prov_ctrl_janus@DBL_BSCS_BF p
       set p.estado_prv =5
       where p.action_id = 509
       and p.estado_prv = '2'
       and trim(p.errmsg) = ''
       and p.co_id = an_cod_id;

       update tim.rp_prov_ctrl_janus@DBL_BSCS_BF p
       set p.estado_prv =5
       where p.action_id = 509
       and p.estado_prv = '6'
       and upper(trim(p.errmsg)) = upper(trim('PAYER TARIFF IS ALREADY ACTIVE'))
       and p.co_id = an_cod_id;

       update tim.rp_prov_ctrl_janus@DBL_BSCS_BF p
       set p.estado_prv =5
       where p.action_id = 500
       and p.estado_prv = '6'
       and upper(trim(p.errmsg)) = upper(trim('PAYER TARIFF IS ALREADY ACTIVE'))
       and p.co_id = an_cod_id;

       update tim.rp_prov_ctrl_janus@DBL_BSCS_BF p
       set p.estado_prv =5
       where p.action_id = 500
       and p.estado_prv = '2'
       and trim(p.errmsg) = ''
       and p.co_id = an_cod_id;

       update tim.rp_prov_ctrl_janus@DBL_BSCS_BF p
       set p.estado_prv =5
       where p.action_id = 509
       and p.estado_prv = '6'
       and upper(trim(p.errmsg)) = upper(trim('succes'))
       and p.co_id = an_cod_id;

       update tim.rp_prov_ctrl_janus@DBL_BSCS_BF p
       set p.estado_prv =5
       where p.action_id = 509
       and p.estado_prv = '6'
       and upper(trim(p.errmsg)) = upper(trim('NO Todos los registros se ejecutaron con éxito'))
       and p.co_id = an_cod_id;

       update tim.rp_prov_ctrl_janus@DBL_BSCS_BF p
       set p.estado_prv =5
       where p.action_id = 500
       and p.estado_prv = '6'
       and upper(trim(p.errmsg)) = upper(trim('NO Todos los registros se ejecutaron con éxito'))
       and p.co_id = an_cod_id;

       update tim.rp_prov_ctrl_janus@DBL_BSCS_BF p
       set p.estado_prv =5
       where p.action_id = 509
       and p.estado_prv = '6'
       and upper(trim(p.errmsg)) = upper(trim('getBalance no retorno walledId para el tariffId indicado [10690].'))
       and p.co_id = an_cod_id;

       update tim.rp_prov_ctrl_janus@DBL_BSCS_BF p
       set p.estado_prv =5
       where p.action_id = 500
       and p.estado_prv = '6'
       and upper(trim(p.errmsg)) = upper(trim('getBalance no retorno walledId para el tariffId indicado [10690].'))
       and p.co_id = an_cod_id;

     update tim.rp_prov_ctrl_janus@DBL_BSCS_BF p
       set p.estado_prv =5
       where p.action_id = 509
       and p.estado_prv = '6'
       and upper(trim(p.errmsg)) = upper(trim('CONNECTION NOT FOUND'))
       and p.co_id = an_cod_id;

       update tim.rp_prov_ctrl_janus@DBL_BSCS_BF p
       set p.estado_prv =5
       where p.action_id = 2
       and p.estado_prv = '6'
       and upper(trim(p.errmsg)) = upper(trim('PAYER NOT FOUND'))
       and p.co_id = an_cod_id;

       update tim.rp_prov_ctrl_janus@DBL_BSCS_BF p
       set p.estado_prv =5
       where p.action_id = 505
       and p.estado_prv = '6'
       and upper(trim(p.errmsg)) = upper(trim('CONNECTION NOT FOUND'))
       and p.co_id = an_cod_id;

    an_error := 0;
    av_error := 'Éxito en el proceso';

    p_reg_log(null,
              null,
              NULL,
              null,
              null,
              an_Error,
              av_error,
              an_cod_id,
              'Reproceso JANUS');

  EXCEPTION
    WHEN OTHERS THEN
      an_error := -1;
      av_error := 'Ocurrio un error al reprocesar JANUS';
      p_reg_log(null,
                null,
                NULL,
                null,
                null,
                an_Error,
                av_error,
                an_cod_id,
                'Reproceso JANUS');
  END p_cont_reproceso_ce;

  procedure p_val_dato_linea_ce_janus(an_codsolot in number,
                                      av_numero in varchar2,
                                      av_customerjanus in varchar2,
                                      an_codplanjanus in number,
                                      av_ciclojanus in varchar2,
                                      an_valida out number,
                                      av_mensaje out varchar2) is
    lv_tramajanus varchar2(4000);
    lv_tramasga varchar2(4000);

    lv_numslc varchar2(10);
    ln_codinssrv number;
    ln_pid number;

    /*cursor c_linea_sga is
        select e.numslc, e.codinssrv, e.numero, b.pid
        from solotpto a, insprd b, tystabsrv c, inssrv e, solot g
       where a.pid = b.pid
         and e.tipinssrv = 3
         and b.codsrv = c.codsrv
         and e.codinssrv = b.codinssrv
         and a.codsolot = g.codsolot
         and b.flgprinc = 1
         and g.codsolot = an_codsolot
         and e.numero = av_numero
         and e.cid is not null;*/
  begin

    select e.numslc, e.codinssrv, b.pid
    into lv_numslc, ln_codinssrv, ln_pid
        from solotpto a, insprd b, tystabsrv c, inssrv e, solot g
       where a.pid = b.pid
         and e.tipinssrv = 3
         and b.codsrv = c.codsrv
         and e.codinssrv = b.codinssrv
         and a.codsolot = g.codsolot
         and b.flgprinc = 1
         and g.codsolot = an_codsolot
         and e.numero = av_numero
         and e.cid is not null;

   -- for c_linea in c_linea_sga loop

      lv_tramasga := operacion.pq_janus_ce.get_conf('P_COD_CUENTA') || lv_numslc;
      lv_tramasga := lv_tramasga || av_numero;
      lv_tramasga := lv_tramasga || to_char(p_retorna_plan_prin_ce(an_codsolot));
      lv_tramasga := lv_tramasga || trim(operacion.pq_janus_ce_alta.get_ciclo());

      lv_tramajanus := trim(av_customerjanus)||trim(av_numero)||to_char(an_codplanjanus)||trim(av_ciclojanus);

     if lv_tramasga != lv_tramajanus then
       an_valida := 0; -- Desalineado
     else
       an_valida := 1; -- Alineado
     end if;

     av_mensaje := 'OK';
    --end loop;
  exception
    when others then
      an_valida := -1;
      av_mensaje := 'ERROR al validar el numero  : ' || sqlerrm;
  end p_val_dato_linea_ce_janus;

  function p_retorna_plan_prin_ce(an_codsolot number) return number is
   ln_plan number;
  begin

    SELECT h.plan
           into ln_plan
      FROM solotpto    a,
           insprd      b,
           tystabsrv   c,
           inssrv      e,
           solot       g,
           plan_redint h
     WHERE a.pid = b.pid
       AND e.tipinssrv = 3
       AND c.idplan = h.idplan
       AND h.idtipo IN (2, 3) --control, prepago
       AND b.codsrv = c.codsrv
       AND e.codinssrv = b.codinssrv
       AND a.codsolot = g.codsolot
       and g.codsolot =  an_codsolot;

     return ln_plan;

  exception
    when others then
      return -1;
  end;

  procedure p_retorna_datos_cliente_ce(an_codsolot number,
                                       av_codcli out varchar2,
                                       av_numslc out varchar2,
                                       an_planbase out number,
                                       an_planopcion out number,
                                       av_tipdide out varchar2,
                                       av_ntdide out varchar2,
                                       av_apellidos out varchar2,
                                       av_nomcli out varchar2,
                                       av_ruc out varchar2,
                                       av_razon out varchar2,
                                       av_tlf1 out varchar2,
                                       av_tlf2 out varchar2,
                                       an_error out number,
                                       av_error out varchar2)  is

  begin

    SELECT distinct
           e.codcli,
           e.numslc,
           h.plan,
           h.plan_opcional,
           v.tipdide,
           v.ntdide,
           REPLACE(v.apepatcli, '|', ' ') || ' ' ||
           REPLACE(v.apematcli, '|', ' ') apellidos,
           REPLACE(v.nomclires, '|', ' '),
           DECODE(v.tipdide, '001', v.ntdide, NULL) AS ruc,
           REPLACE(v.nomcli, '|', ' ') AS razon,
           v.telefono1,
           v.telefono2
           into av_codcli, av_numslc, an_planbase, an_planopcion, av_tipdide,
           av_ntdide, av_apellidos, av_nomcli,
           av_ruc, av_razon,  av_tlf1, av_tlf2
      FROM solotpto    a,
           insprd      b,
           tystabsrv   c,
           inssrv      e,
           solot       g,
           vtatabcli v,
           plan_redint h
     WHERE a.pid = b.pid
       AND e.tipinssrv = 3
       AND c.idplan = h.idplan
       AND h.idtipo IN (2, 3) --control, prepago
       AND b.codsrv = c.codsrv
       AND e.codinssrv = b.codinssrv
       AND a.codsolot = g.codsolot
       and g.codcli   = v.codcli
       and g.codsolot =  an_codsolot;

       an_error := 1;
       av_error := 'OK';
  exception
    when others then
      an_error := -1;
      av_error := 'ERROR : Consulta Datos Cliente  CE - ' || sqlerrm;
  end p_retorna_datos_cliente_ce;

  procedure p_retorna_datos_sucursal_ce(av_numslc varchar2,
                                       av_dirsuc out varchar2,
                                       av_referencia out varchar2,
                                       av_nomdst out varchar2,
                                       av_nompvc out varchar2,
                                       av_nomest out varchar2,
                                       an_error out number,
                                       av_error out varchar2) is

  BEGIN
    SELECT DISTINCT REPLACE(vsuc.dirsuc, '|', ' ') dirsuc,
           REPLACE(vsuc.referencia, '|', ' ') referencia,
           vu.nomdst,
           vu.nompvc,
           vu.nomest
      INTO av_dirsuc, av_referencia, av_nomdst, av_nompvc, av_nomest
      FROM vtasuccli vsuc,
           (SELECT DISTINCT codsuc
              FROM vtadetptoenl vdet
             WHERE vdet.numslc = av_numslc
            ) vv,
           v_ubicaciones vu
     WHERE vsuc.codsuc = vv.codsuc
       AND vsuc.ubisuc = vu.codubi(+);

       an_error := 1;
       av_error := 'OK';
  exception
    when others then
      an_error := -1;
      av_error := 'ERROR : Consulta Datos Cliente  CE - ' || sqlerrm;
  end p_retorna_datos_sucursal_ce;

  -- Proceso de CP CE
  procedure p_cambio_plan_janus_ce(an_codsolot number,
                                   an_error out number,
                                   av_error out varchar2) is
    lv_numslc varchar2(10);
    ln_codplan number;
    ln_codplanopc number;
    lv_trama varchar2(4000);
    ln_idwf number;

    cursor c_lineas(p_idwf number) is

      select e.numslc, e.codinssrv, e.numero, b.pid
        from wf d, solotpto a, insprd b, tystabsrv c, inssrv e, solot g
       where d.idwf = p_idwf
         and a.codsolot = d.codsolot
         and a.pid = b.pid
         and e.tipinssrv = 3
         and b.codsrv = c.codsrv
         and e.codinssrv = b.codinssrv
         and a.codsolot = g.codsolot
         and b.flgprinc = 1
         and e.cid is not null
         and e.numero in (select e.numero
                            from wf d, solotpto a, insprd b, inssrv e
                           where d.idwf = operacion.pq_janus_ce_cambio_plan.get_idwf_origen(p_idwf)
                             and a.codsolot = d.codsolot
                             and a.pid = b.pid
                             and e.tipinssrv = 3
                             and e.codinssrv = b.codinssrv
                             and b.flgprinc = 1
                             and e.cid is not null);
  begin

    select f.idwf into ln_idwf from  wf f where f.codsolot = an_codsolot and f.valido = 1;

    lv_numslc := operacion.pq_janus_ce_cambio_plan.get_proyecto_origen(ln_idwf);

    p_retorna_plan_ce(an_codsolot, ln_codplan , ln_codplanopc);

    for c_l in c_lineas(ln_idwf) loop

      lv_trama := armar_trama_ce(c_l.numero,c_l.codinssrv, ln_codplan, ln_codplanopc);
      -- operacion.pq_janus_ce_cambio_plan.armar_trama(c_l.codinssrv, lv_numslc, ln_codplan, ln_codplanopc);
      tim.pp001_pkg_prov_janus.sp_reg_prov_ctrl_corp@dbl_bscs_bf(100000, 16, lv_trama, an_error, av_error);

    end loop;

    an_error := 1;
    av_error := 'Éxito en el Proceso de Cambio de Plan CE';
  exception
    when others then
      an_error := -1;
      av_error := 'Error Proceso Cambio Plan : ' || sqlerrm ;

  end p_cambio_plan_janus_ce;

  procedure p_retorna_plan_ce(an_codsolot number, an_codplan out number, an_codplanopc out number)
    is
  begin
    select distinct p.plan, p.plan_opcional
          into an_codplan, an_codplanopc
      from solotpto s, insprd i, inssrv e, tystabsrv t, plan_redint p
     where s.codsolot = an_codsolot
       and s.pid = i.pid
       and i.codinssrv = e.codinssrv
       and e.tipinssrv = 3
       and i.codsrv = t.codsrv
       and t.tipsrv = '0004'
       and t.idplan = p.idplan;

  end p_retorna_plan_ce;

 procedure p_reproceso_janusxsot(an_codsolot number,
                                 an_error    out number,
                                 av_error    out varchar2) is
   ln_tiposerv number;
   ln_codid    number;

   cursor c_detalle is
     select e.codinssrv
       from solotpto a, insprd b, tystabsrv c, inssrv e, solot g
      where a.pid = b.pid
        and e.tipinssrv = 3
        and b.codsrv = c.codsrv
        and e.codinssrv = b.codinssrv
        and a.codsolot = g.codsolot
        and b.flgprinc = 1
        and g.codsolot = an_codsolot
        and e.cid is not null;
 begin

   ln_tiposerv := operacion.pq_sga_iw.f_val_tipo_serv_sot(an_codsolot);

   if ln_tiposerv = 1 or ln_tiposerv = 2 then

     for c_d in c_detalle loop
       p_cont_reproceso_ce(c_d.codinssrv, an_error, av_error);
     end loop;

   elsif ln_tiposerv = 3 then

     select s.cod_id
       into ln_codid
       from solot s
      where s.codsolot = an_codsolot;

     p_cont_reproceso(ln_codid, an_error, av_error);

   end if;

   an_error := 1;
   av_error := 'Éxito en el proceso';

 exception
   when others then
     an_error := -1;
     av_error := 'Error en el Reproceso de la Provision Janus : ' || sqlerrm ;
 end;

 procedure p_regulariza_prov_bscs_pend is
 begin
  tim.pp021_venta_hfc.SP_MOV_PROV_HIST@dbl_bscs_bf;
 end;

 -- Funcion que valida si es linea abierta o control
 function f_val_tlflinea_abierta_ctrl(an_codsolot number) return number is
   ln_valida number;
 begin

   select count(distinct pto.codsolot)
     into ln_valida
     from solotpto pto, inssrv ins, tystabsrv t
    where pto.codinssrv = ins.codinssrv
      and ins.codsrv = t.codsrv
      and ins.tipinssrv = 3
      and t.idplan is null
      and t.flag_lc is null
      and intraway.pq_intraway_proceso.f_obt_codsrv_princ(ins.codinssrv) = t.codsrv
      and exists (select 1
             from tipopedd t, opedd o
            where t.tipopedd = o.tipopedd
              and t.abrev = 'IDPRODUCTOCONTINGENCIA'
              and o.codigoc = 'TLF'
              and o.codigon = t.idproducto)
      and pto.codsolot = an_codsolot;

  return ln_valida;
 end;

 function f_val_sot_recha_anula(an_codsolot number) return number is
  ln_contrechazada number;
 begin
      select count(1)
             into ln_contrechazada
         from solot s, estsol es
         where es.tipestsol = 7
         and s.estsol = es.estsol
         and s.codsolot = an_codsolot
         and s.tiptra in (select o.codigon
                      from tipopedd t, opedd o
                      where t.tipopedd = o.tipopedd
                      and t.abrev ='TIP_TRABAJO');
     return ln_contrechazada;
 end;

 PROCEDURE SP_REQUEST_BSCS_PEND(P_PROCESO   IN NUMBER,
                               P_RANGO     IN NUMBER,
                               P_RESULTADO OUT SYS_REFCURSOR) IS

  BEGIN
    IF P_PROCESO = 0 THEN
      OPEN P_RESULTADO FOR
        select ORD_ID, ACTION_ID, TIPO_PROV, CO_ID, CUSTOMER_ID,ESTADO_PRV, ERRCODE, ERRMSG, VALORES
          from tim.pf_hfc_prov_bscs@DBL_BSCS_BF t
         where t.action_id in (3)
           and t.tipo_prov in ('CTV', 'INT', 'TEP')
           and estado_prv in (2, 4, 6, 9)
           and rownum < P_RANGO
         order by ord_id;

    ELSE
      OPEN P_RESULTADO FOR
        select ORD_ID, ACTION_ID, TIPO_PROV, CO_ID, CUSTOMER_ID,ESTADO_PRV, ERRCODE, ERRMSG, VALORES
          from tim.pf_hfc_prov_bscs@DBL_BSCS_BF t
         where t.action_id in (3, 4, 5, 7)
           and t.tipo_prov in ('CTV', 'INT', 'TEP')
           and estado_prv in (2, 4, 6, 9)
           and rownum < P_RANGO
         order by ord_id;

    END IF;
  END SP_REQUEST_BSCS_PEND;

  FUNCTION ARMAR_TRAMA_CE(p_numero   varchar2,
                          p_codinssrv inssrv.codinssrv%type,
                          p_plan      plan_redint.plan%type,
                          p_plan_opc  plan_redint.plan_opcional%type) return varchar2 is

    l_trama varchar2(32767);


    ln_out          number;
    lv_mensaje      varchar2(400);
    lv_customer_id  varchar2(400);
    ln_codplan      number;
    lv_producto     varchar2(400);
    ld_fecini       date;
    lv_estado       varchar2(400);
    lv_ciclo        varchar2(400);

  BEGIN

    OPERACION.PQ_SGA_IW.P_CONS_LINEA_JANUS(p_numero,ln_out,lv_mensaje,lv_customer_id,ln_codplan,lv_producto,ld_fecini,lv_estado,lv_ciclo);

    l_trama := p_codinssrv || '|';
    l_trama := l_trama || lv_customer_id || '|';
    l_trama := l_trama || p_plan || '|';
    l_trama := l_trama || p_plan_opc;

    RETURN l_trama;

  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$plsql_unit || '.armar_trama ( p_numero =>' ||
                              p_numero || ',p_codinssrv =>' || p_codinssrv ||
                              ' ,p_plan =>' || p_plan ||
                              ' ,p_plan_opc =>' || p_plan_opc ||') ' || sqlerrm);
  END ARMAR_TRAMA_CE;

PROCEDURE SP_GENERA_RESERVA(an_cod_id IN  NUMBER,
                             an_error  OUT INTEGER,
                             av_error  OUT VARCHAR2)
  IS
      v_contador_prov           NUMBER;
      v_contador_hist           NUMBER;
      v_contador_bscs           NUMBER;
      v_contador                NUMBER;
      v_idwf                    NUMBER;
      v_conval                  NUMBER;
      v_codsolot                NUMBER(8);
      v_customer_id             NUMBER(8);
      v_estado                  VARCHAR2(20):='REGULAR';
      v_error_general           EXCEPTION;
      v_id_producto             INTEGER;
      v_id_producto_padre       INTEGER;

      V_TIPO_SERV               VARCHAR2(3);
      V_PROD_ID                 INTEGER;
      V_PROD_PADRE              INTEGER;
      V_VALORES_SERV            VARCHAR2(1000);
      V_SOT                     VARCHAR2(50);

      cursor c_servicios(P_cod_id NUMBER,P_codsolot NUMBER) is
                            SELECT a.tip_interfase,a.id_producto,a.id_producto_padre,a.valores,a.codsolot
                                     FROM operacion.trs_interface_iw a
                                           WHERE a.cod_id = an_cod_id
                                             AND a.codsolot = v_codsolot;

BEGIN

    /*Se valida si la cod_id es nula */
    IF an_cod_id = 0 or an_cod_id is null THEN
      an_error := -1; ---
      av_error := ' No se encontro CO_ID' || av_error;
      RAISE v_error_general;
    END IF;

    operacion.PQ_CONT_REGULARIZACION.SP_BUSCA_CODSOLT_CUST(an_cod_id,v_codsolot,v_customer_id,an_error,av_error);

    IF an_error = 0 THEN

         IF F_VAL_REGISTRO_BSCS(an_cod_id,v_estado) = 0 THEN
                /*Si no existe provisión ni en el historico, Se envia reservas*/
                SELECT idwf
                       INTO v_idwf
                       FROM wf
                            WHERE codsolot = v_codsolot
                            AND valido = 1;

                SELECT COUNT(1)
                       INTO v_conval
                            FROM operacion.trs_interface_iw
                                 WHERE codsolot = v_codsolot;

               IF v_conval = 0 THEN
                  OPERACION.PQ_IW_SGA_BSCS.p_gen_reserva_iw(NULL,
                                                            v_idwf,
                                                            NULL,
                                                            NULL);
               ELSE
                  SELECT COUNT(texto)
                         INTO v_contador
                              FROM operacion.log_trs_interface_iw
                                   WHERE proceso = 'Respuesta Proceso Reserva'
                                   AND error = 0
                                   AND cod_id = an_cod_id;

                  IF v_contador = 0 THEN
                   /* --- Genera la Reserva solo en BSCS --- */
                   OPERACION.PQ_IW_SGA_BSCS.p_genera_reserva_iw(NULL,
                                                                 v_idwf,
                                                                 NULL,
                                                                 NULL);

                  END IF;
                END IF;
          END IF;
    end if; -- 3.0

    /*Si no llego a BSCS*/
    SELECT COUNT(texto)
           INTO v_contador_bscs
                FROM operacion.log_trs_interface_iw
                      WHERE proceso = 'Respuesta Proceso Reserva'
                            AND error = 0
                            AND cod_id = an_cod_id;

      IF v_contador_bscs = 0 THEN
            an_error := -1;--- 0109
            av_error := ' Reserva no GENERADA en BSCS: ' || av_error;
            RAISE v_error_general;
      ELSE
             IF F_VAL_REGISTRO_BSCS(an_cod_id,v_estado) = 0 THEN
                av_error := ' Reserva no GENERADA en BSCS: ' || av_error;
                RAISE v_error_general;
             END IF;
      END IF;

    --Actualizamos las reservas a estado 5 -- Ini 3.0
    UPDATE tim.pf_hfc_prov_bscs@DBL_BSCS_BF
       SET ESTADO_PRV    = 5,
           FECHA_RPT_EAI = sysdate - 5 / 3600,
           ERRCODE       = 0,
           ERRMSG        = 'Operation Success'
     where co_id = an_cod_id
       and action_id in (1, 8); -- Fin 3.0

    av_error := 'Éxito en el Proceso';
    an_Error := 0;

    p_reg_log(v_customer_id,
              null,
              NULL,
              v_codsolot,
              null,
              an_Error,
              av_error,
              an_cod_id,
              'Regularización Reservas');



    EXCEPTION
    WHEN v_error_general THEN
      an_Error := -1;
      p_reg_log(v_customer_id,
                NULL,
                NULL,
                v_codsolot,
                NULL,
                an_error,
                av_error,
                an_cod_id,
                'Regularización Reservas');

      WHEN OTHERS THEN
          an_error := -1;
          av_error := 'Error : ' ||av_error || SQLERRM;
          p_reg_log(v_customer_id,
                     NULL,
                     NULL,
                     v_codsolot,
                     NULL,
                     an_error,
                     av_error,
                     an_cod_id,
                     'Regularización Reservas');

  END;

  PROCEDURE SP_ACTIVA_SERVICIO(an_cod_id IN  NUMBER,
                              an_error  OUT INTEGER,
                              av_error  OUT VARCHAR2)
  IS
    v_ins_cm                 VARCHAR2(600);
    v_ins_mta                VARCHAR2(600);
    v_ins_stb                VARCHAR2(1000);
    v_insstb                 VARCHAR2(1000);
    v_codigo_error           NUMBER;
    v_msj_error              VARCHAR2(400);
    v_codsolot               NUMBER(8);
    v_liberar                NUMBER;
    v_error_general          EXCEPTION;
    v_error_iw_getreport     EXCEPTION;
    v_interf                 NUMBER;
    v_modlo                  VARCHAR2(100);
    v_nro                    NUMBER;
    v_maxf                   NUMBER;
    v_customer_id            NUMBER(8);

    CURSOR cs_act_ctv IS
           SELECT o.codsolot,o.id_producto,o.mac_address,o.unit_address
                  FROM OPERACION.TAB_EQUIPOS_IW o
                       WHERE o.interfase = 2020
                       AND serial_NUMBER IS NOT NULL
                       AND codsolot = v_codsolot;

    CURSOR cs_activ_int_mta IS
           SELECT o.interfase,o.mac_address,o.modelo,o.codsolot
                  FROM OPERACION.TAB_EQUIPOS_IW o
                       WHERE o.interfase IN (620, 820)
                       AND mac_address IS NOT NULL
                       AND codsolot = v_codsolot order by o.interfase asc;

   BEGIN

    v_liberar := 0;

    SP_BUSCA_CODSOLT_CUST(an_cod_id,v_codsolot,v_customer_id,an_error,av_error);

    IF an_error = 0 THEN
          /*--- Mandamos activacion int+mta ---*/
          v_ins_cm   := NULL;
          v_ins_mta  := NULL;
          an_error   := NULL;

          FOR reg_int_mta IN cs_activ_int_mta LOOP
              IF reg_int_mta.interfase = '620' THEN
                 v_ins_cm := reg_int_mta.mac_address;
              END IF;

              IF reg_int_mta.interfase = '820' THEN
                 v_ins_mta := reg_int_mta.mac_address || ';1;' || reg_int_mta.modelo;
              END IF;

            BEGIN
               IF reg_int_mta.interfase = 620 THEN
                 ----VALIDA SI NUEVO SP HACE LO MISMO Y SOLO DEJAR LO Q NO HACE EL NUEVO SP
                  --- El sp p_instala_srv_iw internamente llama al SP_GENERAR_INST_VENTA
                  OPERACION.PQ_IW_SGA_BSCS.p_instala_srv_iw(reg_int_mta.codsolot,
                                                            v_ins_cm,
                                                            v_ins_mta,
                                                            v_ins_stb,
                                                            v_codigo_error,
                                                            v_msj_error);

                    IF v_codigo_error < 0 THEN

                      av_error  := ' No se envio comando de activacion en BSCS: ' || v_msj_error;
                      an_error := -1;
                      RAISE v_error_general;
                    END IF;

                ELSIF reg_int_mta.interfase = 820 THEN
                  OPERACION.PQ_IW_SGA_BSCS.p_instala_srv_iw(reg_int_mta.codsolot,
                                                            v_ins_cm,
                                                            v_ins_mta,
                                                            v_ins_stb,
                                                            v_codigo_error,
                                                            v_msj_error);

                  IF v_codigo_error < 0 THEN

                     av_error  := ' No se envio comando de activacion en BSCS: ' || v_msj_error;
                     an_error := -1;
                     RAISE v_error_general;

                  END IF;
                END IF;
            EXCEPTION
              WHEN OTHERS THEN
                       an_error:= -1;
                       av_error := ' No se envio comando de activacion en BSCS: ' || SQLERRM;
                       RAISE v_error_general;

                 p_reg_log(v_customer_id,
                           NULL,
                           NULL,
                           v_codsolot,
                           NULL,
                           an_error,
                           av_error,
                           an_cod_id,
                           'Regularizacion - Activa Servicios');
            END;
          END LOOP;

          /*--- Mandamos activacion ctv ---*/
          FOR reg_act_ctv IN cs_act_ctv LOOP
            BEGIN
                SELECT id_interfaz
                  INTO v_interf
                  FROM int_mensaje_intraway i
                       WHERE i.codsolot = reg_act_ctv.codsolot
                         AND i.id_producto = reg_act_ctv.id_producto
                         AND i.id_interfase = 2022
                         AND i.id_interfaz IN
                             (SELECT max(id_interfaz)
                                FROM int_mensaje_intraway
                               WHERE id_cliente = i.id_cliente
                                 AND id_producto = i.id_producto
                                 AND id_interfase = 2022);

                SELECT valor_atributo
                  INTO v_modlo
                      FROM int_mensaje_atributo_intraway
                           WHERE nombre_atributo = 'STBTypeCRMId'
                             AND id_mensaje_intraway = v_interf;

                 SELECT COUNT(1)
                   INTO v_nro
                   FROM TIM.PF_HFC_CABLE_TV@DBL_BSCS_BF CV
                  WHERE CV.ID_PRODUCTO = reg_act_ctv.id_producto
                    AND CV.ESTADO_RECURSO = 'PI';

                IF v_nro > 0 THEN
                  v_ins_stb := v_ins_stb || '|' || reg_act_ctv.mac_address || ';' || v_modlo || ';' ||
                               reg_act_ctv.unit_address || ';FALSE';
                END IF;

            EXCEPTION
              when no_data_found then
                an_error := -1;
                av_error := 'No se encontro registros de servicios adicionales para el IDPRODUCTO :' || reg_act_ctv.id_producto;
              WHEN OTHERS THEN
                an_error := -1;
                av_error := SQLERRM;
                RAISE v_error_general;
            END;
          END LOOP;

          SELECT LENGTH(v_ins_stb) INTO v_maxf FROM dual;
          SELECT substr(v_ins_stb, 2, v_maxf - 1) INTO v_insstb FROM dual;

          BEGIN
            IF v_insstb IS NOT NULL THEN
                OPERACION.PQ_IW_SGA_BSCS.p_instala_srv_iw(v_codsolot,
                                                          v_ins_cm,
                                                          v_ins_mta,
                                                          v_ins_stb,
                                                          v_codigo_error,
                                                          v_msj_error);
                  IF v_codigo_error < 0 THEN
                    an_error := -1;
                    av_error := ' No se envio comando de activacion en BSCS: ' || v_msj_error;
                    RAISE v_error_general;
                  END IF;
             END IF;

          EXCEPTION
            WHEN OTHERS THEN
              an_error := -1;
              av_error := ' No se envio comando de activacion en BSCS: ' || SQLERRM;
              RAISE v_error_general;
          END;

      --Actualizamos Activación -- Ini 3.0
      UPDATE tim.pf_hfc_prov_bscs@DBL_BSCS_BF
         SET ESTADO_PRV    = 5,
             FECHA_RPT_EAI = sysdate - 5 / 3600,
             ERRCODE       = 0,
             ERRMSG        = 'Operation Success'
       where co_id = an_cod_id
         and action_id = 2; -- Fin 3.0

      av_error := 'Éxito en el Proceso';
      an_Error := 0;
      p_reg_log(v_customer_id,
                NULL,
                NULL,
                v_codsolot,
                NULL,
                an_Error,
                av_error,
                an_cod_id,
                'Regularizacion - Activa Servicios');

  ELSE
      RAISE v_error_general;
  END IF;

  EXCEPTION
    WHEN v_error_general THEN
      an_error := -1;
      p_reg_log(v_customer_id,
                NULL,
                NULL,
                v_codsolot,
                NULL,
                an_error,
                av_error,
                an_cod_id,
                'Regularizacion - Activa Servicios');
    WHEN v_error_iw_getreport THEN
      av_error := 'Error al obtener la informacion de IW : ' || av_error;
      an_Error := -19;
      p_reg_log(v_customer_id,
                NULL,
                NULL,
                v_codsolot,
                NULL,
                an_Error,
                av_error,
                an_cod_id,
                'Regularizacion - Activa Servicios');
    WHEN OTHERS THEN
      av_error := 'ERROR: ' || SQLERRM;
      an_Error := sqlcode;
      p_reg_log(v_customer_id,
                NULL,
                NULL,
                v_codsolot,
                NULL,
                an_Error,
                av_error,
                an_cod_id,
                'Regularizacion - Activa Servicios');
    END;

    PROCEDURE SP_REGULARIZACION(an_cod_id IN NUMBER,
                                an_error  OUT INTEGER,
                                av_error  OUT VARCHAR2) IS
      v_codsolot    NUMBER(8);
      v_customer_id NUMBER(8);
      v_error_general      EXCEPTION;
      v_error_iw_getreport EXCEPTION;
      v_fecha_reg DATE;

      ln_cod_id    number;
      lv_codcli    varchar2(8);
      ln_customer  number;
      lv_numero    varchar2(8);
      ln_codinssrv number;
      ln_error     number;
      lv_error     varchar2(4000);
      ln_tn_bscs   varchar2(10);

      ln_val_cp_visita number; --LFO

	  l_cod_id_old operacion.solot.cod_id_old%TYPE;
	  ln_tiptra_cp number := 0;
    
    an_error_contr number; --11.0
    av_error_contr varchar2(4000);--11.0
    ln_existe_csc  number;--11.0
    BEGIN

      /*Se valida si la cod_id es nula */
      IF an_cod_id = 0 THEN
        av_error := ' No se encontro CO_ID' || av_error;
        RAISE v_error_general;
      END IF;

      /*Se obtiene el SOT y CUSTOMER_ID*/
      SP_BUSCA_CODSOLT_CUST(an_cod_id,
                            v_codsolot,
                            v_customer_id,
                            an_error,
                            av_error);

      operacion.pq_sga_iw.p_cons_numtelefonico_sot(v_codsolot,
                                                   lv_numero,
                                                   lv_codcli,
                                                   ln_cod_id,
                                                   ln_customer,
                                                   ln_codinssrv,
                                                   ln_error,
                                                   lv_error);

      if ln_error = 1 and lv_numero is not null then
        ln_tn_bscs := tim.tfun051_get_dnnum_from_coid@DBL_BSCS_BF(an_cod_id);
        operacion.pq_hfc_alineacion.p_regulariza_numero(an_cod_id,
                                                        lv_numero,
                                                        ln_tn_bscs,
                                                        2,
                                                        ln_error,
                                                        lv_error);
      elsif ln_error = -1 and lv_numero is null then
        -- 8.0
        -- cuando no tiene telefonia , realizara el cambio de ciclo
        operacion.pkg_cambio_ciclo_fact.sgasu_camb_ciclo_fact(v_codsolot,
                                                              ln_error,
                                                              lv_error);
      end if;
      
      --INI 11.0
      ln_existe_csc := operacion.pq_sga_bscs.f_val_existe_contract_sercad(ln_cod_id);
      --Insertamos en la Contr_servicas si no existe
      if ln_existe_csc = 0 then
        begin
          operacion.pq_sga_bscs.p_reg_contr_services_cap(ln_cod_id,
                                                         lv_numero,
                                                         an_error_contr,
                                                         av_error_contr);
          commit;
        exception
          when others then
            av_error := 'Error al Registrar en la contr_services_cap : ' ||
                        sqlcode || ' ' || sqlerrm || ' (' ||
                        dbms_utility.format_error_backtrace || ')';
        end;
      end if;
      -- FIN 11.0

      ln_val_cp_visita := operacion.pq_siac_cambio_plan.sgafun_valida_cb_plan_visita(v_codsolot); --LFO

      IF an_error = 0 THEN
        /*Ejecuta la Generación de Reserva */
        SP_GENERA_RESERVA(an_cod_id, an_error, av_error);

        IF an_error = 0 THEN

          if ln_val_cp_visita = 0 then --LFO
            P_CONS_DET_IW(v_codsolot, an_error, av_error); -- 3.0
          end if;

          IF an_error < 0 THEN
            -- 3.0
            RAISE v_error_general; -- 3.0
          END IF; -- 3.0

          /* Ejecurtar el sp de */
          SP_ACTIVA_SERVICIO(an_cod_id, an_error, av_error);

          IF an_error = 0 THEN
            /*--- Actualizamos equipos  xxx  reg Equipos----*/
            SP_ACTUALIZAR_EQUIPO(an_cod_id,
                                 v_codsolot,
                                 v_customer_id,
                                 an_error,
                                 av_error); ---Actualizar
            /*--- Actualizamos Equipos   ----*/
            IF an_error < 0 THEN
              --3.0
              RAISE v_error_general;
                       
            ELSIF an_error = 0 THEN
             
             SP_VALIDA_EQUIPO(an_cod_id,
                               v_codsolot,
                               v_customer_id,
                               an_error,
                               av_error);
            
                  IF an_error < 0 THEN
                     RAISE v_error_general;
                  END IF;
            END IF;

            P_ACTIVARFACTURACION(an_cod_id, an_error, av_error);

            IF an_error < 0 THEN
              -- 3.0
              RAISE v_error_general; -- 3.0
            END IF; -- 3.0

          ELSE
            RAISE v_error_general;
          END IF;

        END IF;

     av_error := 'Éxito en el Proceso';
     an_Error := 0;

		-- Desactivando contrato anterior
		BEGIN
		 SELECT cod_id_old
		 into l_cod_id_old
		 FROM operacion.solot
		 where codsolot = v_codsolot;
	    EXCEPTION
	     WHEN NO_DATA_FOUND THEN
			av_error := ' No se encontro CO_ID_OLD del codsolot' || v_codsolot;
			RAISE v_error_general;
	    END;

		IF an_Error = 0 THEN
		  ln_tiptra_cp := operacion.pq_sga_bscs.f_get_is_cp_hfc(v_codsolot);

		  if ln_tiptra_cp > 0 then

		      OPERACION.PQ_SGA_BSCS.p_desactiva_contrato_cplan(v_codsolot, l_cod_id_old , an_Error , av_error );

			  if an_error <> 1 then
			     raise v_error_general;
		      end if;

		  end if;

		END IF;


     av_error := 'Éxito en el Proceso';
     an_Error := 0;




        p_reg_log(v_customer_id,
                  NULL,
                  NULL,
                  v_codsolot,
                  NULL,
                  an_Error,
                  av_error,
                  an_cod_id,
                  'Regularizacion BSCS-SGA-IW');

      ELSE
        RAISE v_error_general;
      END IF;

    EXCEPTION
      WHEN v_error_general THEN
        ROLLBACK;
        an_error := -1;
        p_reg_log(v_customer_id,
                  NULL,
                  NULL,
                  v_codsolot,
                  NULL,
                  an_error,
                  av_error,
                  an_cod_id,
                  'Regularizacion BSCS-SGA-IW');

      WHEN OTHERS THEN
        ROLLBACK;
        an_error := -1;
        av_error := 'Error :' || av_error || SQLERRM ||' Linea : ('||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||')'; --LFO
        p_reg_log(v_customer_id,
                  NULL,
                  NULL,
                  v_codsolot,
                  NULL,
                  an_error,
                  av_error,
                  an_cod_id,
                  'Regularizacion BSCS-SGA-IW');

    END;

  FUNCTION F_MOSTRAR_MENSAJE(an_cod_id NUMBER,av_estado NUMBER) RETURN VARCHAR2 IS
      lv_mensaje                           VARCHAR2(200);

      v_cod_id                             NUMBER(8);
      v_ok_regularizar                     VARCHAR2(50);
      v_msj_regularizar                    VARCHAR2(200);
      v_ok_Facturar                        VARCHAR2(50);
      v_msj_Facturar                       VARCHAR2(200);
      v_ok_reserva                         VARCHAR2(50);
      v_msj_reserva                        VARCHAR2(200);
      v_msj_cliente                        VARCHAR2(200);
    BEGIN

           SELECT distinct s.cod_id,
                  (SELECT MAX(texto) FROM operacion.log_trs_INterface_iw
                                         WHERE proceso = 'Regularizacion BSCS-SGA-IW'
                                         AND error = 0
                                         AND cod_id = S.cod_id)AS OK_REGULARIZACION, --into v_ok_regularizar
                  (SELECT texto FROM operacion.log_trs_INterface_iw
                                     WHERE idlog IN (SELECT MAX(idlog)
                                                FROM operacion.log_trs_INterface_iw
                                                     WHERE proceso = 'Regularizacion BSCS-SGA-IW'
                                                     AND cod_id = s.cod_id
                                                     AND texto IS NOT NULL)) AS MSG_REGULARIZACION ,-- into v_msj_regularizar
                  (SELECT MAX(texto) FROM operacion.log_trs_INterface_iw
                                          WHERE proceso = 'Inicio de Facturacion BSCS'
                                          AND error = 0
                                          AND cod_id = S.cod_id)AS OK_FACTURACION,--  into v_ok_Facturar
                  (SELECT texto FROM operacion.log_trs_INterface_iw
                                     WHERE idlog IN
                                     (SELECT MAX(idlog) FROM operacion.log_trs_INterface_iw
                                                             WHERE proceso = 'Inicio Facturacion BSCS-SGA-IW'
                                                             AND cod_id = s.cod_id
                                                             AND texto IS NOT NULL))AS MSG_FACTURACION,---into v_msj_regularizar
                  (SELECT MAX(texto) FROM operacion.log_trs_INterface_iw
                                          WHERE proceso = 'Respuesta Proceso Reserva'
                                          AND error = 0
                                          AND cod_id = S.cod_id)AS OK_RESERVA, --into v_ok_reserva
                  (SELECT texto FROM operacion.log_trs_INterface_iw
                                     WHERE idlog IN (SELECT MAX(idlog)
                                                                    FROM operacion.log_trs_INterface_iw
                                                                          WHERE proceso = 'Respuesta Proceso Reserva'
                                                                                AND cod_id = S.cod_id
                                                                                AND texto IS NOT NULL))AS MSG_RESERVA --- into v_msj_reserva
                    INTO
                    v_cod_id,
                    v_ok_regularizar,
                    v_msj_regularizar,
                    v_ok_Facturar,
                    v_msj_Facturar,
                    v_ok_reserva,
                    v_msj_reserva
                   FROM solot s, estsol e, tiptrabajo t
                        WHERE s.estsol = e.estsol
                        AND s.tiptra = t.tiptra
                        AND s.cod_id= an_cod_id;
                        --- codsolot =an_cod_id;

     IF av_estado = 1 THEN
         IF v_ok_regularizar IS NULL THEN

             SELECT MSJ_USUARIO INTO v_msj_cliente
                                  FROM OPERACION.T_CONF_MENSAJES
                                  WHERE MSJ_TECNICO = v_msj_regularizar;
         END IF;
     END IF;

     IF av_estado = 2 THEN
         IF v_ok_Facturar IS NULL THEN
             SELECT MSJ_USUARIO INTO v_msj_cliente
                                  FROM OPERACION.T_CONF_MENSAJES
                                  WHERE MSJ_TECNICO = v_msj_Facturar;

         END IF;
     END IF;
     IF av_estado = 3 THEN
         IF v_ok_reserva IS NULL THEN
             SELECT MSJ_USUARIO INTO v_msj_cliente
                                  FROM OPERACION.T_CONF_MENSAJES
                                  WHERE MSJ_TECNICO = v_msj_reserva;
         END IF;
     END IF;

     RETURN v_msj_cliente;

    EXCEPTION
      WHEN OTHERS THEN
      v_msj_cliente := 'ERROR al capturar el mensaje : ' || SQLERRM;
      RETURN v_msj_cliente;

    END;

 PROCEDURE SP_ACTUALIZAR_EQUIPO(an_cod_id        IN  NUMBER,
                               av_codsolot      IN  NUMBER,
                               an_customerid    IN  NUMBER,
                               an_error         OUT NUMBER,
                               av_error         OUT VARCHAR)
  IS
  v_tipsrv                VARCHAR2(5);
  v_serial                VARCHAR2(400);
  v_msj_error             VARCHAR2(400);
  v_error_general         EXCEPTION;

    /*--- Actualizamos equipos  xxx  reg Equipos----*/
  BEGIN

      DECLARE
        CURSOR CS_EQUIPOS_IW IS
          SELECT COD_ID,
                 TIPO_SERVICIO,
                 ID_PRODUCTO,
                 INTERFASE,
                 MODELO,
                 UNIT_ADDRESS,
                 STBTYPECRMID,
                 CASE
                   WHEN INTERFASE <> 2020 THEN
                    MAC_ADDRESS
                   ELSE
                    SERIAL_NUMBER
                 END SERIE
            FROM OPERACION.TAB_EQUIPOS_IW
           WHERE CODSOLOT = av_codsolot
             AND ID_PRODUCTO IN
                 (SELECT iw.id_producto
                                      FROM OPERACION.TRS_INTERFACE_IW iw, solot s
                                      WHERE iw.id_interfase IN (620, 820, 2020)
                                         AND s.codsolot = iw.codsolot
                                         AND s.CODSOLOT = av_codsolot) order by interfase asc;
      BEGIN
        FOR C IN CS_EQUIPOS_IW LOOP
          IF c.interfase = 620 THEN
            v_tipsrv := 'INT';
            TIM.pp021_venta_hfc.sp_inst_equipo_ivr@DBL_BSCS_BF(an_cod_id, ---  DBL_BSCS_BF
                                                               v_tipsrv,
                                                               c.id_producto,
                                                               c.SERIE,
                                                               an_error,
                                                               av_error);
            IF an_error < 0 THEN
              av_error := ' No se realizo la alineacion de equipos BSCS: ' ||
                          an_error;
              RAISE v_error_general;
            END IF;

          ELSIF c.interfase = 820 THEN
            v_tipsrv := 'TLF';
            TIM.pp021_venta_hfc.sp_inst_equipo_ivr@DBL_BSCS_BF(an_cod_id,
                                                               v_tipsrv,
                                                               c.id_producto,
                                                               c.SERIE ||
                                                               ';1;' ||
                                                               c.modelo,
                                                               an_error,
                                                               av_error);
            IF an_error < 0 THEN
              av_error := ' No se realizo la alineacion de equipos BSCS: ' || an_error;
              RAISE v_error_general;
            END IF;

          ELSE
            v_tipsrv := 'CTV';
            v_serial := c.SERIE || ';' || c.STBTYPECRMID || ';' ||
                        c.UNIT_ADDRESS || ';' || 'FALSE' || '|' || c.SERIE || ';' ||
                        c.STBTYPECRMID || ';' || c.UNIT_ADDRESS || ';' ||
                        'FALSE';
            /*--- Alineamos en BSCS ---*/
            TIM.pp021_venta_hfc.sp_inst_equipo_ivr@DBL_BSCS_BF(an_cod_id,
                                                               v_tipsrv,
                                                               c.id_producto,
                                                               v_serial,
                                                               an_error,
                                                               av_error);
            IF an_error < 0 THEN
              av_error := ' No se realizo la alineacion de equipos BSCS: ' || an_error;
              RAISE v_error_general;
            END IF;

          END IF;

          IF an_error < 0 THEN
            av_error := ' Error al ejecutar alineacion de equipos BSCS: ' || v_msj_error;
            RAISE v_error_general;
          END IF;

          v_serial := NULL;

        END LOOP;
      END;

    av_error := 'Éxito en el Proceso';
    an_Error := 0;
    p_reg_log(an_customerid,
              null,
              NULL,
              av_codsolot,
              null,
              an_Error,
              av_error,
              an_cod_id,
              'Regularizacion - Actualizar Equipos');

  EXCEPTION
    WHEN v_error_general THEN -- Ini 3.0
      an_Error := -1;
      p_reg_log(an_customerid,
                null,
                NULL,
                av_codsolot,
                null,
                an_error,
                av_error,
                an_cod_id,
                'Regularizacion BSCS-SGA-IW'); -- Fin 3.0

    WHEN OTHERS THEN
      an_error := -1;
      av_error := 'Error '|| av_error || SQLERRM;
      p_reg_log(an_customerid,
                 NULL,
                 NULL,
                 av_codsolot,
                 NULL,
                 an_error,
                 av_error,
                 an_cod_id,
                 'Regularizacion - Actualizar Equipos');
  END;

  PROCEDURE SP_BUSCA_CODSOLT_CUST(an_cod_id             IN   NUMBER,
                                 an_codsolot           OUT  NUMBER,
                                 an_customer_id        OUT  NUMBER,
                                 an_error              OUT  VARCHAR,
                                 av_error              OUT  VARCHAR)
    IS
    v_error_general              EXCEPTION;
    v_est_solot                  VARCHAR2(20):='EST_SOLOT';
    BEGIN
          /*Se obtiene el SOT*/
          SELECT MAX(CODSOLOT)
                 INTO an_codsolot
                           FROM SOLOT S
                           WHERE s.cod_id = an_cod_id
                             AND ESTSOL IN (SELECT B.CODIGON FROM OPEDD B
                                                             WHERE B.ABREVIACION = v_est_solot)
                             AND TIPTRA IN (SELECT o.codigon
                                                  FROM tipopedd t, opedd o
                                                       WHERE t.tipopedd = o.tipopedd
                                                         AND t.abrev = 'TIPREGCONTIWSGABSCS');
          /*Se obtiene el CustomerID*/
          SELECT CUSTOMER_ID INTO an_customer_id
                           FROM SOLOT S
                           WHERE s.cod_id = an_cod_id AND s.codsolot=an_codsolot;

          /*Si no existe el SOT o CUSTORMER_ID se muestra el error*/
            IF an_codsolot IS NULL or an_customer_id IS NULL THEN
              av_error := ' No se encontro SOT o CUSTOMER_ID ' || av_error;
              RAISE v_error_general;
            END IF;

        an_error:= 0;
  EXCEPTION
    when v_error_general then --3.0
      an_error:=-1; --3.0
    WHEN OTHERS THEN
      an_error:=-1;
      av_error:=' No se encontro SOT o CUSTOMER_ID ' || SQLERRM;
   END;

   FUNCTION F_VAL_REGISTRO_BSCS(an_cod_id NUMBER, av_estado VARCHAR2) return NUMBER IS
    ln_contador NUMBER;

    v_cont_prov         NUMBER;
    v_cont_prov_hist    NUMBER;

  BEGIN
      SELECT COUNT(distinct(co_id))
        INTO v_cont_prov
        FROM tim.pf_hfc_prov_bscs@DBL_BSCS_BF
       WHERE co_id = an_cod_id
         AND action_id IN (SELECT B.CODIGON
                             FROM TIPOPEDD A, OPEDD B
                            WHERE A.TIPOPEDD = B.TIPOPEDD
                              AND B.ABREVIACION = av_estado); ---'REGULAR' 1709  -- (1,8) --3.0

      IF v_cont_prov = 0 THEN
        SELECT COUNT(distinct(co_id))
          INTO v_cont_prov_hist
          FROM tim.pf_hfc_prov_bscs_hist@DBL_BSCS_BF
         WHERE co_id = an_cod_id
           AND action_id IN (SELECT B.CODIGON
                               FROM TIPOPEDD A, OPEDD B
                              WHERE A.TIPOPEDD = B.TIPOPEDD
                                AND B.ABREVIACION = av_estado); ---'REGULAR' 1709  -- (1,8) --3.0

        IF v_cont_prov_hist = 0 THEN

          ln_contador := 0;
          --                av_error := ' Reserva no GENERADA en BSCS: ' || av_error;

        END IF;
      ELSE
        ln_contador := 1;
        --            av_error := ' Ya Existe una reserva en BSCS: ' || av_error;
      END IF;

    RETURN ln_contador;

  END;

  PROCEDURE SP_LISTA_CONSOLIDADO(AV_ESTADO IN VARCHAR2,o_resultado OUT T_CURSOR) IS
     V_CABECERA VARCHAR2(30);
     V_GROUP VARCHAR2(30);
     V_CAMPO VARCHAR2(4000);
     V_SQL VARCHAR2(9000);
   BEGIN

   IF AV_ESTADO = 'CEF' THEN  ---CONSOLIDADO POR ESTADO FINAL
      V_CABECERA:= ' est_final||''|''||';
      V_GROUP:= ' GROUP BY est_final';
      V_CAMPO:= ' case
                       when (x.estsol in (12, 29)) and
                            (x.ch_status = ''a'' or x.ch_status = ''d'' or x.ch_status = ''s'') and
                            x.ch_pending IS null then
                        ''Conforme''
                       when ((select e.tipestsol from estsol e where e.estsol = x.estsol) = 5) and
                            x.ch_status = ''d'' and x.ch_pending IS null then
                        ''Conforme''
                       when ((select e.tipestsol from estsol e where e.estsol = x.estsol) = 7 or
                            (x.estsol in (17, 19, 9, 18, 71))) and x.ch_status = ''a'' and
                            x.ch_pending IS not null then
                        ''Conforme''
                       when (x.estsol in (12, 29)) and
                            ((x.ch_status = ''a'' and x.ch_pending IS not null and
                            x.num10 = 0)) then
                        ''Conforme''
                       when (x.estsol in (12, 29)) and
                            ((x.ch_status = ''s'' and x.ch_pending IS not null)) then
                        ''Conforme''
                       when ((select e.tipestsol from estsol e where e.estsol = x.estsol) = 7 or
                            (x.estsol in (17, 19, 9, 18, 71))) and x.ch_status = ''o'' and
                            x.ch_pending IS null then
                        ''Conforme''
                       when ((select e.tipestsol from estsol e where e.estsol = x.estsol) = 7) and
                            x.ch_status = ''d'' and x.ch_pending IS null then
                        ''Regularizar TI - Anular SOT''
                       when ((select e.tipestsol from estsol e where e.estsol = x.estsol) in
                            (5, 7) or (x.estsol in (9, 17))) and
                            (x.ch_status = ''a'' or x.ch_status = ''s'') and
                            x.ch_pending IS null then
                        ''Regularizar Activaciones''
                       when ((select e.tipestsol from estsol e where e.estsol = x.estsol) = 5) and
                            ((x.ch_status = ''a'' and x.ch_pending IS not null) or
                            (x.ch_status = ''o'' and x.ch_pending IS null)) then
                        ''Regularizar TI - Anular contrato''
                       when (x.estsol in (12, 29)) and
                            ((x.ch_status = ''a'' and x.ch_pending IS not null and
                            x.num10 = 1) or (x.ch_status = ''o'' and x.ch_pending IS null)) then
                        ''Regularizar TI - Activar contrato''
                       when x.ch_status = ''d'' and x.ch_pending IS null and
                            x.codsolot IS null then
                        ''Conforme''
                       when x.ch_status = ''o'' and x.ch_pending IS null and
                            x.codsolot IS null then
                        ''Regularizar TI - Anular contrato''
                       when x.ch_status = ''a'' and x.ch_pending IS null and
                            x.codsolot IS null then
                        ''Regularizar Activaciones''
                       else
                        ''Revisar TI''
                     END est_final,';
   END IF ;

   IF AV_ESTADO = 'CDE' THEN  ---CONSOLIDADO DE ESTADO FINAL POR ESTADO DE SOT
      V_CABECERA:= 'est_final||''|''||est_sot||''|''||';
      V_GROUP:= 'GROUP BY est_final,est_sot';
      V_CAMPO:= ' case
                             when (x.estsol in (12, 29)) and
                                  (x.ch_status = ''a'' or x.ch_status = ''d'' or x.ch_status = ''s'') and
                                  x.ch_pending IS null then
                              ''Conforme''
                             when ((select e.tipestsol from estsol e where e.estsol = x.estsol) = 5) and
                                  x.ch_status = ''d'' and x.ch_pending IS null then
                              ''Conforme''
                             when ((select e.tipestsol from estsol e where e.estsol = x.estsol) = 7 or
                                  (x.estsol in (17, 19, 9, 18, 71))) and x.ch_status = ''a'' and
                                  x.ch_pending IS not null then
                              ''Conforme''
                             when (x.estsol in (12, 29)) and
                                  ((x.ch_status = ''a'' and x.ch_pending IS not null and
                                  x.num10 = 0)) then
                              ''Conforme''
                             when (x.estsol in (12, 29)) and
                                  ((x.ch_status = ''s'' and x.ch_pending IS not null)) then
                              ''Conforme''
                             when ((select e.tipestsol from estsol e where e.estsol = x.estsol) = 7 or
                                  (x.estsol in (17, 19, 9, 18, 71))) and x.ch_status = ''o'' and
                                  x.ch_pending IS null then
                              ''Conforme''
                             when ((select e.tipestsol from estsol e where e.estsol = x.estsol) = 7) and
                                  x.ch_status = ''d'' and x.ch_pending IS null then
                              ''Regularizar TI - Anular SOT''
                             when ((select e.tipestsol from estsol e where e.estsol = x.estsol) in
                                  (5, 7) or (x.estsol in (9, 17))) and
                                  (x.ch_status = ''a'' or x.ch_status = ''s'') and
                                  x.ch_pending IS null then
                              ''Regularizar Activaciones''
                             when ((select e.tipestsol from estsol e where e.estsol = x.estsol) = 5) and
                                  ((x.ch_status = ''a'' and x.ch_pending IS not null) or
                                  (x.ch_status = ''o'' and x.ch_pending IS null)) then
                              ''Regularizar TI - Anular contrato''
                             when (x.estsol in (12, 29)) and
                                  ((x.ch_status = ''a'' and x.ch_pending IS not null and
                                  x.num10 = 1) or (x.ch_status = ''o'' and x.ch_pending IS null)) then
                              ''Regularizar TI - Activar contrato''
                             when x.ch_status = ''d'' and x.ch_pending IS null and
                                  x.codsolot IS null then
                              ''Conforme''
                             when x.ch_status = ''o'' and x.ch_pending IS null and
                                  x.codsolot IS null then
                              ''Regularizar TI - Anular contrato''
                             when x.ch_status = ''a'' and x.ch_pending IS null and
                                  x.codsolot IS null then
                              ''Regularizar Activaciones''
                             else
                              ''Revisar TI''
                           END est_final,
                           (select e.descripcion from estsol e where e.estsol = x.estsol) est_sot,';

   END IF ;

   IF AV_ESTADO = 'CES' THEN  ---CONSOLIDADO POR ESTADO DE SOT
      V_CABECERA:= ' est_sot||''|''||';
      V_GROUP:= ' GROUP BY est_sot ';
      V_CAMPO:= ' (select e.descripcion from estsol e where e.estsol = x.estsol) est_sot,';
   END IF ;


      V_SQL:='SELECT ' || V_CABECERA || 'sum(a_x)||''|''||sum(a_blanco)||''|''||sum(d_x)||''|''||sum(d_blanco)||''|''||
              sum(o_x)||''|''||sum(o_blanco)||''|''||sum(s_x)||''|''||sum(s_blanco)||''|''||sum(y_x)||''|''||sum(y_blanco)
              FROM
              (select ' || V_CAMPO || '
                     case when x.ch_status=''a'' and x.ch_pending IS null then 1 else 0 END as a_blanco,
                     case when x.ch_status=''a'' and x.ch_pending IS not null then 1 else 0 END as a_x,
                     case when x.ch_status=''d'' and x.ch_pending IS null then 1 else 0 END as d_blanco,
                     case when x.ch_status=''d'' and x.ch_pending IS not null then 1 else 0 END as d_x,
                     case when x.ch_status=''o'' and x.ch_pending IS null then 1 else 0 END as o_blanco,
                     case when x.ch_status=''o'' and x.ch_pending IS not null then 1 else 0 END as o_x,
                     case when x.ch_status=''s'' and x.ch_pending IS null then 1 else 0 END as s_blanco,
                     case when x.ch_status=''s'' and x.ch_pending IS not null then 1 else 0 END as s_x,
                     case when x.ch_status=''y'' and x.ch_pending IS null then 1 else 0 END as y_blanco,
                     case when x.ch_status=''y'' and x.ch_pending IS not null then 1 else 0 END as y_x

                from operacion.tab_contract_bscs x) ' || V_GROUP || ' ORDER BY 1 ';


    OPEN o_resultado FOR
     V_SQL;

  END SP_LISTA_CONSOLIDADO;

  PROCEDURE SP_LISTA_CONTRATOS_ALINEACION(AV_ESTADO IN VARCHAR2,o_resultado OUT T_CURSOR) IS

    V_SQL VARCHAR2(9000);
  BEGIN

    IF AV_ESTADO = 'RTI' THEN
    --Revisar TI

    V_SQL:='Select t.co_id, t.co_id_old,t.customer_id,t.ciclo,t.ch_status,t.ch_pending,t.num_bscs,t.num_sga,t.cant_sot,t.codsolot,t.est_sot,t.est_sot_gen,
            t.est_final,t.tipo_sot,t.fectest,t.mesfec,t.internet_iw,t.telefonia_iw,t.cable_iw,t.numero_iw,t.codplan,t.descplan,
            t.internet_bscs,t.telefonia_bscs,t.cable_bscs,t.tiene_num_sga,t.contr_services_cap,t.fecusu
            from
            (select x.co_id,
                   x.co_id_old,
                   x.customer_id,
                   x.ciclo,
                   x.ch_status,
                   x.ch_pending,
                   x.dn_num num_bscs,
                   x.numero num_sga,
                   x.num01 cant_sot,
                   x.codsolot,
                   (select e.descripcion from estsol e where e.estsol = x.estsol) est_sot,
                   case
                     when x.estsol = 29 then
                      ''Atendida''
                     when (select d.tipestsol from estsol d where x.estsol = d.estsol) = 3 then
                      ''Rechazada''
                     when x.estsol <> 29 then
                      (select t.descripcion
                         from estsol e, tipestsol t
                        where e.estsol = x.estsol
                          and e.tipestsol = t.tipestsol)
                     when x.codsolot is null then
                      ''Sin SOT''
                     else
                      ''Revisar''
                   end est_sot_gen,
                   case
                     when (x.estsol in (12, 29)) and
                          (x.ch_status = ''a'' or x.ch_status = ''d'' or x.ch_status = ''s'') and
                          x.ch_pending is null then
                      ''Conforme''
                     when ((select e.tipestsol from estsol e where e.estsol = x.estsol) = 5) and
                          x.ch_status = ''d'' and x.ch_pending is null then
                      ''Conforme''
                     when ((select e.tipestsol from estsol e where e.estsol = x.estsol) = 7 or
                          (x.estsol in (17, 19, 9, 18, 71))) and x.ch_status = ''a'' and
                          x.ch_pending is not null then
                      ''Conforme''
                     when (x.estsol in (12, 29)) and
                          ((x.ch_status = ''a'' and x.ch_pending is not null and
                          x.num10 = 0)) then
                      ''Conforme''
                     when (x.estsol in (12, 29)) and
                          ((x.ch_status = ''s'' and x.ch_pending is not null)) then
                      ''Conforme''
                     when ((select e.tipestsol from estsol e where e.estsol = x.estsol) = 7 or
                          (x.estsol in (17, 19, 9, 18, 71))) and x.ch_status = ''o'' and
                          x.ch_pending is null then
                      ''Conforme''
                     when ((select e.tipestsol from estsol e where e.estsol = x.estsol) = 7) and
                          x.ch_status = ''d'' and x.ch_pending is null then
                      ''Regularizar TI - Anular SOT''
                     when ((select e.tipestsol from estsol e where e.estsol = x.estsol) in
                          (5, 7) or (x.estsol in (9, 17))) and
                          (x.ch_status = ''a'' or x.ch_status = ''s'') and
                          x.ch_pending is null then
                      ''Regularizar Activaciones''
                     when ((select e.tipestsol from estsol e where e.estsol = x.estsol) = 5) and
                          ((x.ch_status = ''a'' and x.ch_pending is not null) or
                          (x.ch_status = ''o'' and x.ch_pending is null)) then
                      ''Regularizar TI - Anular contrato''
                     when (x.estsol in (12, 29)) and
                          ((x.ch_status = ''a'' and x.ch_pending is not null and
                          x.num10 = 1) or (x.ch_status = ''o'' and x.ch_pending is null)) then
                      ''Regularizar TI - Activar contrato''
                     when x.ch_status = ''d'' and x.ch_pending is null and
                          x.codsolot is null then
                      ''Conforme''
                     when x.ch_status = ''o'' and x.ch_pending is null and
                          x.codsolot is null then
                      ''Regularizar TI - Anular contrato''
                     when x.ch_status = ''a'' and x.ch_pending is null and
                          x.codsolot is null then
                      ''Regularizar Activaciones''
                     else
                      ''Revisar Activaciones''
                   end est_final,
                   (select t.descripcion from tiptrabajo t where x.var01 = t.tiptra) tipo_sot,
                   trunc(x.fecultest) fectest,
                   to_char(x.fecultest,''yyyy-mm'') mesfec,
                   num02 internet_iw,
                   num03 telefonia_iw,
                   num04 cable_iw,
                   var02 numero_iw,
                   codplan,
                   var03 descplan,
                   num05 internet_bscs,
                   num06 telefonia_bscs,
                   num07 cable_bscs,
                   num08 tiene_num_sga,
                   num09 contr_services_cap,
                   x.fecusu
              from operacion.tab_contract_bscs x) t
              where t.est_final=''Revisar Activaciones''';
   ELSE

            V_SQL:='SELECT
                   x.co_id,
                   x.co_id_old,
                   x.customer_id,
                   x.ciclo,
                   x.ch_status,
                   x.ch_pending,
                   x.dn_num num_bscs,
                   x.numero num_sga,
                   x.num01 cant_sot,
                   x.codsolot,
                    (select e.descripcion from estsol e where e.estsol = x.estsol) est_sot,
                    case
                    when x.estsol = 29 then
                    ''Atendida''
                    when (select d.tipestsol from estsol d where x.estsol = d.estsol) = 3 then
                    ''Rechazada''
                    when x.estsol <> 29 then
                    (select t.descripcion from estsol e, tipestsol t where e.estsol = x.estsol and e.tipestsol = t.tipestsol)
                    when x.codsolot is null then
                    ''Sin SOT''
                    else
                    ''Revisar''
                    end est_sot_gen,
                    case
                    when (x.estsol in (12, 29)) and
                    (x.ch_status = ''a'' or x.ch_status = ''d'' or x.ch_status = ''s'') and
                    x.ch_pending is null then
                    ''Conforme''
                    when ((select e.tipestsol from estsol e where e.estsol = x.estsol) = 5) and
                    x.ch_status = ''d'' and x.ch_pending is null then
                    ''Conforme''
                    when ((select e.tipestsol from estsol e where e.estsol = x.estsol) = 7 or
                    (x.estsol in (17, 19, 9, 18, 71))) and x.ch_status = ''a'' and
                    x.ch_pending is not null then
                    ''Conforme''
                    when (x.estsol in (12, 29)) and
                    ((x.ch_status = ''a'' and x.ch_pending is not null and
                    x.num10 = 0)) then
                    ''Conforme''
                    when (x.estsol in (12, 29)) and
                    ((x.ch_status = ''s'' and x.ch_pending is not null)) then
                    ''Conforme''
                    when ((select e.tipestsol from estsol e where e.estsol = x.estsol) = 7 or
                    (x.estsol in (17, 19, 9, 18, 71))) and x.ch_status = ''o'' and
                    x.ch_pending is null then
                    ''Conforme''
                    when ((select e.tipestsol from estsol e where e.estsol = x.estsol) = 7) and
                    x.ch_status = ''d'' and x.ch_pending is null then
                    ''Regularizar TI - Anular SOT''
                    when ((select e.tipestsol from estsol e where e.estsol = x.estsol) in
                    (5, 7) or (x.estsol in (9, 17))) and
                    (x.ch_status = ''a'' or x.ch_status = ''s'') and
                    x.ch_pending is null then
                    ''Regularizar Activaciones''
                    when ((select e.tipestsol from estsol e where e.estsol = x.estsol) = 5) and
                    ((x.ch_status = ''a'' and x.ch_pending is not null) or
                    (x.ch_status = ''o'' and x.ch_pending is null)) then
                    ''Regularizar TI - Anular contrato''
                    when (x.estsol in (12, 29)) and
                    ((x.ch_status = ''a'' and x.ch_pending is not null and
                    x.num10 = 1) or (x.ch_status = ''o'' and x.ch_pending is null)) then
                    ''Regularizar TI - Activar contrato''
                    when x.ch_status = ''d'' and x.ch_pending is null and
                    x.codsolot is null then
                    ''Conforme''
                    when x.ch_status = ''o'' and x.ch_pending is null and
                    x.codsolot is null then
                    ''Regularizar TI - Anular contrato''
                    when x.ch_status = ''a'' and x.ch_pending is null and
                    x.codsolot is null then
                    ''Regularizar Activaciones''
                    else
                    ''Revisar TI''
                    end est_final,
                    (select t.descripcion from tiptrabajo t where x.var01 = t.tiptra) tipo_sot,
                    trunc(x.fecultest) fectest,
                    to_char(x.fecultest, ''yyyy-mm'') mesfec,
                    num02 internet_iw,
                    num03 telefonia_iw,
                    num04 cable_iw,
                    var02 numero_iw,
                    codplan,
                    var03 descplan,
                    num05 internet_bscs,
                    num06 telefonia_bscs,
                    num07 cable_bscs,
                    num08 tiene_num_sga,
                    num09 contr_services_cap,
                    x.fecusu
               FROM operacion.tab_contract_bscs x';

                  IF AV_ESTADO = 'RAN' THEN --ANULAR CONTRATO
                      V_SQL:=V_SQL || ' WHERE
                                        ---  ''Regularizar TI - Anular contrato''
                                        ((select e.tipestsol from estsol e where e.estsol = x.estsol) = 5) and ((x.ch_status = ''a'' and x.ch_pending IS not null) or (x.ch_status = ''o'' and x.ch_pending IS null))
                                        ---  ''Regularizar TI - Anular contrato''
                                         or
                                        ( x.ch_status = ''o'' and x.ch_pending IS null and x.codsolot IS null) ';
                  END IF;
                  IF AV_ESTADO = 'RAS' THEN --ANULAR SOT
                      V_SQL:=V_SQL || ' where
                                        --- ''Regularizar TI - Anular SOT''
                                        (((select e.tipestsol from estsol e where e.estsol = x.estsol) = 7) and x.ch_status = ''d'' and x.ch_pending IS null )';

                  END IF;
                  IF AV_ESTADO = 'REG' THEN --REGULARIZACION DE CONTRATOS
                      V_SQL:=V_SQL || ' where
                                        (x.estsol in (12, 29)) and ((x.ch_status = ''a'' and x.ch_pending IS not null and x.num10 = 1) or (x.ch_status = ''o'' and x.ch_pending IS null))';

                  END IF;
                  IF AV_ESTADO = 'RNC' THEN --RELACION NÚMERO CONTRATO
                      V_SQL:=V_SQL || ' where
                                        num09 = 0 and num08 = 1 and (ch_status = ''a'' and ch_pending IS null)';

                  END IF;
                  IF AV_ESTADO = 'RAC' THEN --RELACION ACTIVACIONES
                      V_SQL:=V_SQL || ' WHERE
                                        (((select e.tipestsol from estsol e where e.estsol = x.estsol) in (5, 7) or (x.estsol in (9, 17)))
                                          and  (x.ch_status = ''a'' or x.ch_status = ''s'') and x.ch_pending IS null)
                                        OR
                                        (x.ch_status = ''a'' and x.ch_pending IS null and  x.codsolot IS null )  ';

                  END IF;

      END IF;

     OPEN o_resultado FOR
     V_SQL;

  END SP_LISTA_CONTRATOS_ALINEACION;

  PROCEDURE SP_PROCESO_MASIVO_CONTRATOS(AN_ERROR_F OUT INTEGER,
                                       AV_ERROR_F OUT VARCHAR2) IS
     an_error NUMBER;
     av_error VARCHAR2(300);
     av_tipo  VARCHAR2(3);
     mensaje VARCHAR2(100);


  BEGIN

     update operacion.tab_contract_bscs x set x.tipocaso = CASE when ((select e.tipestsol from estsol e where e.estsol = x.estsol) = 5) and
              ((x.ch_status = 'a' and x.ch_pending IS not null) or
              (x.ch_status = 'o' and x.ch_pending IS null)) then
          1 ---'Regularizar TI - Anular contrato'
         when (x.estsol in (12, 29)) and
              ((x.ch_status = 'a' and x.ch_pending IS not null and
              x.num10 = 1) or (x.ch_status = 'o' and x.ch_pending IS null)) then
          2 ---'Regularizar TI - Activar contrato'
          when ((select e.tipestsol from estsol e where e.estsol = x.estsol) = 7) and
              x.ch_status = 'd' and x.ch_pending IS null then
          3 ---'Regularizar TI - Anular SOT'
          when x.ch_status = 'o' and x.ch_pending IS null and
              x.codsolot IS null then
          1 ---'Regularizar TI - Anular contrato'
          END;
          commit;
     --/*mensaje para anulación de SOT*/
     SELECT t.VALOR INTO mensaje FROM operacion.constante t WHERE T.CONSTANTE='MSJ_ANULA';

      declare
      cursor c_cursor is
      select x.tipocaso ,x.CUSTOMER_ID,x.CODSOLOT,x.CO_ID,x.CO_ID_OLD,x.CODCLI,x.NUMERO,x.ESTSOL,x.CICLO,x.CODPLAN,x.DN_NUM,x.CODINSSRV,x.CH_STATUS,x.CH_PENDING,
             x.ESTINSSRV,x.FECULTEST,x.FLG_UNICO,x.DESCRIPCION,x.OBSERVACION,x.TRANSACCION,x.NUM01,x.NUM02,x.NUM03,x.NUM04,x.NUM05,x.NUM06,x.NUM07,
             x.NUM08,x.NUM09,x.NUM10,x.VAR01,x.VAR02,x.VAR03,x.VAR04,x.VAR05,x.VAR06,x.VAR07,x.VAR08,x.VAR09,x.VAR10,x.VAR11,x.VAR12,x.CODUSU,x.FECUSU
      FROM operacion.tab_contract_bscs x WHERE x.tipocaso is not null;

      BEGIN
          FOR fila in c_cursor LOOP
              IF fila.tipocaso = 1 THEN
                 ---ANULAR CONTRATO(VENTA)  NUEVO SP JOEL FRANCO - HITTS
                 tim.TIM111_PKG_ACCIONES.sp_anula_contrato_bscs@DBL_BSCS_BF(fila.Co_Id,131,an_error,av_error);
                 av_tipo:='ANC';

              END IF;

              ---ANULAR SOT
              IF fila.tipocaso = 3 THEN
                 operacion.pq_solot.p_chg_estado_solot(fila.codsolot,13,fila.estsol, mensaje || fila.co_id);
                 av_tipo:='ASO';
              END IF;

              ---ACTIVAR CONTRATO(REGULARIZACIONES)
              IF fila.tipocaso = 2 THEN
                 operacion.PQ_CONT_REGULARIZACION.SP_REGULARIZACION(fila.co_id,an_error,av_error);
                 operacion.PQ_CONT_REGULARIZACION.P_ACTIVARFACTURACION(fila.co_id,an_error,av_error);

              END IF;

              ---RELACION NÚMERO-CONTRATO
              IF fila.NUM09=0 AND fila.num08=1 AND (fila.ch_status='a' and fila.ch_pending is null)  THEN
                 operacion.pq_sga_bscs.p_reg_contr_services_cap(fila.co_id,fila.numero,an_error,av_error);
                 av_tipo:='RNC';

              END IF;

              ---REGISTRO DE HISTORICO
              IF (fila.NUM09=0 AND fila.num08=1 AND (fila.ch_status='a' and fila.ch_pending is null)) OR fila.tipocaso IN (1,3) THEN
                 operacion.PQ_CONT_REGULARIZACION.SP_REGISTRAR_HISTORICO(av_tipo,fila.CUSTOMER_ID,fila.CODSOLOT,fila.CO_ID,fila.CO_ID_OLD,fila.CODCLI,fila.NUMERO,fila.ESTSOL,fila.CICLO,fila.CODPLAN,fila.DN_NUM,fila.CODINSSRV,fila.CH_STATUS,fila.CH_PENDING,fila.ESTINSSRV,fila.FECULTEST,fila.FLG_UNICO,fila.DESCRIPCION,fila.OBSERVACION,fila.TRANSACCION,fila.NUM01,fila.NUM02,fila.NUM03,fila.NUM04,fila.NUM05,fila.NUM06,fila.NUM07,fila.NUM08,fila.NUM09,fila.NUM10,fila.VAR01,fila.VAR02,fila.VAR03,fila.VAR04,fila.VAR05,fila.VAR06,fila.VAR07,fila.VAR08,fila.VAR09,fila.VAR10,fila.VAR11,fila.VAR12,fila.CODUSU,fila.FECUSU,an_error,av_error);
              END IF;

           END LOOP;
       END;


      ---Eliminación de historico de alineacion de contratos
      operacion.PQ_CONT_REGULARIZACION.SP_DELETE_HISTORICO('HISTALCONTR',an_error,av_error);

      AN_ERROR_F:= 0;
      AV_ERROR_F:= 'Proceso Masivo fue ejecutado';

  END SP_PROCESO_MASIVO_CONTRATOS;

  procedure SP_REGISTRAR_ALINEACION_JANUS(AN_ERROR  OUT INTEGER,
                                          AV_ERROR  OUT VARCHAR2)
  IS
    an_error_j number;
    av_error_j varchar2(500);

    CURSOR listacontratos IS
      SELECT x.codsolot,x.co_id,x.numero,x.customer_id FROM operacion.tab_contract_bscs x
      WHERE (x.estsol in (12, 29)) AND ((x.ch_status = 'a' AND x.ch_pending IS NULL AND x.num08 = 1))
      AND NOT EXISTS
      (SELECT distinct psj.numero FROM operacion.prov_sga_janus psj WHERE psj.numero=x.numero);

    BEGIN
         FOR registro IN listacontratos LOOP
         ---REGISTRO EN LA TABLA PARA ALINEACION JANUS MASIVO
            SP_VALIDACION_JANUS(registro.codsolot,registro.co_id,registro.numero,registro.customer_id,an_error_j,av_error_j);
            AV_ERROR:='OK';
         END LOOP;

         AN_ERROR:=0;
         AV_ERROR:='OK';

    EXCEPTION
      WHEN OTHERS THEN
      AN_ERROR := SQLCODE;
      AV_ERROR := SUBSTR(SQLERRM, 1, 250);

  END;

  procedure SP_REGISTRAR_HISTORICO(AV_TIPO_OPERA IN VARCHAR2,
                                  AN_CUSTOMER_ID IN NUMBER,
                                  AN_CODSOLOT    IN NUMBER,
                                  AN_CO_ID       IN NUMBER,
                                  AN_CO_ID_OLD   IN NUMBER,
                                  AV_CODCLI      IN VARCHAR2,
                                  AV_NUMERO      IN VARCHAR2,
                                  AN_ESTSOL      IN NUMBER,
                                  AV_CICLO       IN VARCHAR2,
                                  AN_CODPLAN     IN NUMBER,
                                  AV_DN_NUM      IN VARCHAR2,
                                  AN_CODINSSRV   IN NUMBER,
                                  AV_CH_STATUS   IN VARCHAR2,
                                  AV_CH_PENDING  IN VARCHAR2,
                                  AN_ESTINSSRV   IN NUMBER,
                                  AN_FECULTEST   IN DATE,
                                  AN_FLG_UNICO   IN NUMBER,
                                  AV_DESCRIPCION IN VARCHAR2,
                                  AV_OBSERVACION IN VARCHAR2,
                                  AV_TRANSACCION IN VARCHAR2,
                                  AN_NUM01       IN NUMBER,
                                  AN_NUM02       IN NUMBER,
                                  AN_NUM03       IN NUMBER,
                                  AN_NUM04       IN NUMBER,
                                  AN_NUM05       IN NUMBER,
                                  AN_NUM06       IN NUMBER,
                                  AN_NUM07       IN NUMBER,
                                  AN_NUM08       IN NUMBER,
                                  AN_NUM09       IN NUMBER,
                                  AN_NUM10       IN NUMBER,
                                  AV_VAR01       IN VARCHAR2,
                                  AV_VAR02       IN VARCHAR2,
                                  AV_VAR03       IN VARCHAR2,
                                  AV_VAR04       IN VARCHAR2,
                                  AV_VAR05       IN VARCHAR2,
                                  AV_VAR06       IN VARCHAR2,
                                  AV_VAR07       IN VARCHAR2,
                                  AV_VAR08       IN VARCHAR2,
                                  AV_VAR09       IN VARCHAR2,
                                  AV_VAR10       IN VARCHAR2,
                                  AV_VAR11       IN VARCHAR2,
                                  AV_VAR12       IN VARCHAR2,
                                  AV_CODUSU      IN VARCHAR2,
                                  AN_FECUSU      IN DATE,
                                  AN_ERROR  OUT INTEGER,
                                  AV_ERROR  OUT VARCHAR2)
  IS
    BEGIN

    DELETE FROM OPERACION.TAB_CONTRACT_BSCS_HISTORY WHERE CO_ID=AN_CO_ID;
    COMMIT;

    INSERT INTO OPERACION.TAB_CONTRACT_BSCS_HISTORY(TIPO_OPERA,FECH_OPERA,CUSTOMER_ID,CODSOLOT,CO_ID,CO_ID_OLD,CODCLI,NUMERO,ESTSOL,CICLO,CODPLAN,DN_NUM,CODINSSRV,CH_STATUS,CH_PENDING,ESTINSSRV,FECULTEST,FLG_UNICO,DESCRIPCION,OBSERVACION,TRANSACCION,NUM01,NUM02,NUM03,NUM04,NUM05,NUM06,NUM07,NUM08,NUM09,NUM10,VAR01,VAR02,VAR03,VAR04,VAR05,VAR06,VAR07,VAR08,VAR09,VAR10,VAR11,VAR12,CODUSU,FECUSU)
    VALUES (AV_TIPO_OPERA,sysdate,AN_CUSTOMER_ID,AN_CODSOLOT,AN_CO_ID,AN_CO_ID_OLD,AV_CODCLI,AV_NUMERO,AN_ESTSOL,AV_CICLO,AN_CODPLAN,AV_DN_NUM,AN_CODINSSRV,AV_CH_STATUS,AV_CH_PENDING,AN_ESTINSSRV,AN_FECULTEST,AN_FLG_UNICO,AV_DESCRIPCION,AV_OBSERVACION,AV_TRANSACCION,AN_NUM01,AN_NUM02,AN_NUM03,AN_NUM04,AN_NUM05,AN_NUM06,AN_NUM07,AN_NUM08,AN_NUM09,AN_NUM10,AV_VAR01,AV_VAR02,AV_VAR03,AV_VAR04,AV_VAR05,AV_VAR06,AV_VAR07,AV_VAR08,AV_VAR09,AV_VAR10,AV_VAR11,AV_VAR12,AV_CODUSU,AN_FECUSU);

    AN_ERROR := 0;
    AV_ERROR := '';
    COMMIT ;

    EXCEPTION
    WHEN OTHERS THEN
    AN_ERROR := SQLCODE;
    AV_ERROR := SUBSTR(SQLERRM, 1, 250);

   END SP_REGISTRAR_HISTORICO;

   PROCEDURE SP_DELETE_HISTORICO(   N_TIPO IN VARCHAR2,
                                 P_RESULTADO  OUT INTEGER,
                                 P_MSGERR     OUT VARCHAR2)
 IS
 Vsql varchar2(1000);
 v_dias varchar2(10);
 CONDICION varchar2(50);
 BEGIN

  --cantidad días para eliminación de histroico de proceso masivo
  SELECT o.codigon_aux INTO v_dias FROM operacion.opedd o WHERE O.ABREVIACION = N_TIPO;

  IF N_TIPO='HISTCMASIVO' THEN
     CONDICION:=' AND TIPO_OPERA = CNF';
  END IF;
  IF N_TIPO='HISTALCONTR' THEN
     CONDICION:=' AND TIPO_OPERA != CNF';
  END IF;
  ---HISTCMASIVO 60 HISTALCONTR  30

 Vsql := ' DELETE FROM OPERACION.TAB_CONTRACT_BSCS_HISTORY
            WHERE FECH_OPERA >= TRUNC(SYSDATE)-v_dias
            AND FECH_OPERA <= TRUNC(SYSDATE)' || CONDICION ;

    execute immediate Vsql;
    commit;

     P_RESULTADO := 0;
     P_MSGERR    := 'OK';
     COMMIT;

 EXCEPTION
 WHEN OTHERS THEN
      P_RESULTADO:= -1;
      P_MSGERR := SQLCODE || '-' || SQLERRM;

 END SP_DELETE_HISTORICO;

 PROCEDURE SP_OBTENER_NUMERO_SGA(an_codsolot IN NUMBER,
                               ln_numero OUT NUMBER,
                               lv_numero OUT VARCHAR2) IS
  BEGIN

      SELECT COUNT(distinct ins.numero)
        INTO ln_numero
      FROM solot s, solotpto pto, inssrv ins
      WHERE s.codsolot = pto.codsolot
      AND pto.codinssrv = ins.codinssrv
      AND ins.tipinssrv = 3
      AND ins.numero IS NOT NULL
      AND s.codsolot = an_codsolot;

    IF ln_numero = 1 then
        SELECT distinct ins.numero
          INTO lv_numero
        FROM solot s, solotpto pto, inssrv ins
        WHERE s.codsolot = pto.codsolot
        AND pto.codinssrv = ins.codinssrv
        AND ins.tipinssrv = 3
        AND ins.numero IS NOT NULL
        AND s.codsolot = an_codsolot;

    END IF;
  END;

    PROCEDURE SP_VALIDACION_JANUS(an_codsolot IN NUMBER,
                               an_cod_id IN VARCHAR2,
                               an_numero IN VARCHAR2,
                               an_customer IN NUMBER,
                               an_error_j OUT INTEGER,
                               av_error_j OUT VARCHAR2) IS
    lv_numero  VARCHAR2(20);
    ln_numero  NUMBER;

    an_out   INTEGER;
    an_error   INTEGER;
    av_error   VARCHAR2(500);
    v_error_general EXCEPTION;
    lv_tn_bscs           VARCHAR2(20);
    ln_tiposot number;

    ln_out_janus         number;
    lv_mensaje_janus     varchar2(500);
    lv_customer_id_janus varchar2(20);
    ln_codplan_janus     number;
    lv_producto_janus    varchar2(100);
    ld_fecini_janus      date;
    lv_estado_janus      varchar2(20);
    lv_ciclo_janus       varchar2(5);

    ln_alinea            number;
    lv_mensaje           varchar2(1000);

  BEGIN

    OPERACION.PQ_CONT_REGULARIZACION.SP_OBTENER_NUMERO_SGA(an_codsolot,ln_numero,lv_numero);

    IF ln_numero = 1 then
      -- VALIDACIÓN INFO BSCS CON JANUS
      lv_tn_bscs:=tim.tfun051_get_dnnum_from_coid@DBL_BSCS_BF(an_cod_id);
      ln_tiposot := operacion.pq_sga_iw.f_val_tipo_serv_sot(an_codsolot);

      ---Validar Numero BCSC es -1 y ejecutar la actualización del número contrato.
      IF lv_tn_bscs = -1 and ln_tiposot = 3 THEN
         operacion.pq_sga_bscs.p_reg_contr_services_cap(an_cod_id,an_numero,an_error,av_error);
         IF an_error != 1 THEN
            an_error_j:=an_error;
            av_error_j:=av_error;
            RAISE v_error_general;
         ELSE
            an_error_j:=0;
            av_error_j:=av_error;
            lv_tn_bscs:=tim.tfun051_get_dnnum_from_coid@DBL_BSCS_BF(an_cod_id);
         END IF;
      END IF;

      ---Comparar número BSCS - SGA
         IF lv_numero=lv_tn_bscs THEN
                 if ln_numero = 1 then
                lv_numero := '0051' || lv_numero;
         else
                lv_numero := '000000000000'; -- No tiene numero asignado en la SOT
         end if;

         /*validar si existe número en janus*/
         p_valida_linea_janus(lv_numero,an_out,av_error);

             -- Número SGA - SI existe en Janus
             IF an_out = 1 THEN
                   --Obtener datos janus
                   operacion.pq_sga_janus.p_cons_linea_janus(lv_numero,
                                                             1,
                                                             ln_out_janus,
                                                             lv_mensaje_janus,
                                                             lv_customer_id_janus,
                                                             ln_codplan_janus,
                                                             lv_producto_janus,
                                                             ld_fecini_janus,
                                                             lv_estado_janus,
                                                             lv_ciclo_janus);

                    --Validar datos Janus
                    operacion.pq_sga_iw.p_val_datos_linea_janus('BSCS',
                                            an_codsolot,
                                            an_cod_id,
                                            lv_numero,
                                            lv_customer_id_janus,
                                            ln_codplan_janus,
                                            lv_ciclo_janus,
                                            ln_alinea,
                                            lv_mensaje);


                if ln_alinea = 0 then --Número No alineado
                     -- Se programa Baja y Alta Número en Janus
                     operacion.pq_sga_janus.p_insertxacc_prov_sga_janus(3, an_codsolot,an_cod_id,an_customer,lv_customer_id_janus,lv_numero,an_error, av_error);
                     an_error_j:=an_error;
                     av_error_j:=av_error;
                 end if;

              ELSE
                  --- Número SGA - NO existe en Janus -> Se programa Alta Número en Janus
                  operacion.pq_sga_janus.p_insertxacc_prov_sga_janus(1, an_codsolot,an_cod_id,an_customer,lv_customer_id_janus,lv_numero,an_error, av_error);
                  an_error_j:=an_error;
                  av_error_j:=av_error;
             END IF ;


        END IF;

    END IF;

  EXCEPTION
    WHEN OTHERS then
      av_error_j := 'ERROR al validar linea BSCS y JANUS: ' || sqlerrm;

  END;

  PROCEDURE SP_INSERT_SOTANULA(an_estado IN NUMBER,
                             av_codsolot IN VARCHAR,
                             av_observacion IN VARCHAR,
                             an_error OUT NUMBER,
                             av_error OUT VARCHAR2) IS
BEGIN

   INSERT INTO OPERACION.TAB_SOTANULADA(ESTADO,CODSOLOT,OBSERVACION)
   VALUES (an_estado,av_codsolot,av_observacion);
    COMMIT;
     an_error:=0;
     av_error:='OK';

 EXCEPTION
   WHEN OTHERS THEN
     an_error:=-1;
     av_error := 'Error' || SQLERRM;
 END;

 FUNCTION F_VALIDAR_SERVICIOS(l_codoslot NUMBER, an_idinterface VARCHAR2) RETURN NUMBER IS
   ln_contador NUMBER;
  BEGIN
    SELECT COUNT(iw.ID_PRODUCTO) INTO ln_contador
    FROM OPERACION.TRS_INTERFACE_IW iw,
         solot                      s
     WHERE iw.id_interfase in (an_idinterface)
       AND s.codsolot = iw.codsolot
       AND s.CODSOLOT = l_codoslot;

        IF ln_contador > 0 THEN -- 3.0
           SELECT COUNT(iw.ID_PRODUCTO) INTO ln_contador
            FROM OPERACION.TRS_INTERFACE_IW iw,
                 solot                      s
             WHERE iw.id_interfase in (an_idinterface)
               AND s.codsolot = iw.codsolot
               AND s.CODSOLOT = l_codoslot
               and ((an_idinterface = 2020 and exists
                       (SELECT 1
                       FROM TIM.PF_HFC_CABLE_TV@DBL_BSCS_BF CT
                       WHERE upper(CT.ESTADO_RECURSO) = 'A'
                       and ct.id_producto =iw.ID_PRODUCTO ))

               or (an_idinterface = 820 and exists
                       (SELECT 1
                       FROM TIM.PF_HFC_TELEFONIA@DBL_BSCS_BF T
                       WHERE upper(T.ESTADO_RECURSO) = 'A'
                       and T.id_producto =iw.ID_PRODUCTO ))

               or (an_idinterface = 620 and exists
                         (SELECT 1
                         FROM TIM.Pf_Hfc_INTERNET@DBL_BSCS_BF I
                         WHERE upper(I.ESTADO_RECURSO) = 'A'
                         and I.id_producto =iw.ID_PRODUCTO )));
        ELSE
           ln_contador:=0;
        END IF;

     RETURN ln_contador;
  END;

PROCEDURE SP_VALIDA_EQUIPO(an_cod_id        IN  NUMBER,
                           av_codsolot      IN  NUMBER,
                           an_customerid    IN  NUMBER,
                           an_error         OUT NUMBER,
                           av_error         OUT VARCHAR)
  IS
  v_tipsrv                VARCHAR2(5);
 

  v_msj_error             VARCHAR2(400);
  v_error_general         EXCEPTION;

        CURSOR CS_EQUIPOS_IW IS
          SELECT COD_ID,
                 TIPO_SERVICIO,
                 INTERFASE,
                 ID_PRODUCTO
            FROM OPERACION.TAB_EQUIPOS_IW
           WHERE CODSOLOT = av_codsolot
             AND ID_PRODUCTO IN
                 (SELECT iw.id_producto
                    FROM OPERACION.TRS_INTERFACE_IW iw, solot s
                   WHERE iw.id_interfase IN (620, 820, 2020)
                     AND s.codsolot = iw.codsolot
                     AND s.CODSOLOT = av_codsolot) 
        order by interfase asc;
        
      BEGIN
        
         av_error := 'Éxito en el Proceso';
         an_Error := 0;
         
        FOR C IN CS_EQUIPOS_IW LOOP
          IF c.interfase = 620 THEN
            v_tipsrv := 'INT';
            TIM.pp021_venta_hfc.SP_VALIDA_EQUIPO_BSCS@DBL_BSCS_BF(an_cod_id, 
                                                                  v_tipsrv,
                                                                  c.id_producto,
                                                                  an_error,
                                                                  av_error);
            IF an_error < 0 THEN
              av_error := ' No se realizo la alineacion de equipos BSCS: ' || av_error;
              RAISE v_error_general;
            END IF;

          ELSIF c.interfase = 820 THEN
            v_tipsrv := 'TLF';
            TIM.pp021_venta_hfc.SP_VALIDA_EQUIPO_BSCS@DBL_BSCS_BF(an_cod_id,
                                                                  v_tipsrv,
                                                                  c.id_producto,
                                                                  an_error,
                                                                  av_error);
            IF an_error < 0 THEN
              av_error := ' No se realizo la alineacion de equipos BSCS: ' || av_error;
              RAISE v_error_general;
            END IF;

          ELSE
            v_tipsrv := 'CTV';
            
            TIM.PP021_VENTA_HFC.SP_VALIDA_EQUIPO_BSCS@DBL_BSCS_BF(an_cod_id,
                                                                  v_tipsrv,
                                                                  c.id_producto,
                                                                  an_error,
                                                                  av_error);
            IF an_error < 0 THEN
              av_error := ' No se realizo la alineacion de equipos BSCS: ' || av_error;
              RAISE v_error_general;
            END IF;

          END IF;

          IF an_error = 0 then
            
             p_reg_log(an_customerid,
              null,
              NULL,
              av_codsolot,
              null,
              an_Error,
              av_error,
              an_cod_id,
              'Regularizacion - Equipos Actualizados');
              
            ELSIF an_error < 0 THEN
            av_error := ' Error al ejecutar alineacion de equipos BSCS: ' || av_error;
            RAISE v_error_general;
          END IF;
          
        END LOOP;
     
  EXCEPTION
    WHEN v_error_general THEN 
      an_Error := -1;
      p_reg_log(an_customerid,
                null,
                NULL,
                av_codsolot,
                null,
                an_error,
                av_error,
                an_cod_id,
                'Regularizacion - Actualizar Equipos');

    WHEN OTHERS THEN
      an_error := -1;
      av_error := 'Error '|| av_error || SQLERRM;
      p_reg_log(an_customerid,
                 NULL,
                 NULL,
                 av_codsolot,
                 NULL,
                 an_error,
                 av_error,
                 an_cod_id,
                 'Regularizacion - Actualizar Equipos');
  END;

  PROCEDURE SGASI_TABEQU_IW(an_cod_id     IN NUMBER,
                            av_codsolot   IN NUMBER,
                            an_customerid IN NUMBER,
							an_conta_hfc  IN NUMBER,  --14.0
                            an_error      OUT NUMBER,
                            av_error      OUT VARCHAR) IS
    v_tipsrv VARCHAR2(5);
  
    v_msj_error VARCHAR2(400);
    v_error_general EXCEPTION;
    v_id_producto   varchar2(20);
    v_id_interfase  number;
    v_tipo_servicio varchar2(20);
    n_cantidad      number; --13.0
    n_cuenta        number; --13.0
    n_pidsga        number; --13.0
    n_cuenta1       number; --13.0
    --- ini 14.0
    o_resultado     sys_refcursor;
    lv_idficha      sgacrm.ft_instdocumento.idficha%type;
    lv_tipsrv       sgacrm.ft_instdocumento.VALORTXT%type;
    lv_MacAddress   sgacrm.ft_instdocumento.VALORTXT%type;
    lv_serialNumber sgacrm.ft_instdocumento.VALORTXT%type;
    lv_unitAddress  sgacrm.ft_instdocumento.VALORTXT%type;
    lv_Model        sgacrm.ft_instdocumento.VALORTXT%type;
    lv_serviceType  sgacrm.ft_instdocumento.VALORTXT%type;
    lv_numero       sgacrm.ft_instdocumento.VALORTXT%type;
    lv_pid          operacion.solotpto.pid%type;
    --- fin 14.0 	
  BEGIN
  
    av_error  := 'Éxito en el Proceso';
    an_Error  := 0;
    n_cuenta  := 1; --13.0
    n_cuenta1 := 1; --13.0
	-- INI 14.0
	SP_LISTA_MATERIALES(an_conta_hfc,av_codsolot,o_resultado);
    LOOP
      FETCH o_resultado
       INTO lv_idficha,
            lv_tipsrv,
            lv_MacAddress,
            lv_serialNumber,
            lv_unitAddress,
            lv_Model,
            lv_serviceType,
            lv_numero,
            lv_pid;
         EXIT WHEN o_resultado%NOTFOUND;

      if lv_tipsrv = '0004' then
        --tlf
        v_id_interfase  := 820;
        v_tipo_servicio := 'TLF';
      elsif lv_tipsrv = '0006' then
        --int
        v_id_interfase  := 620;
        v_tipo_servicio := 'INT';
      elsif lv_tipsrv = '0062' then
        --tv
        v_id_interfase  := 2020;
        v_tipo_servicio := 'CTV';
      end if;
      --ini 13.0
      SELECT count(1)
        INTO n_cantidad
        FROM OPERACION.TRS_INTERFACE_IW iw, solot s
       WHERE s.codsolot = iw.codsolot
         and s.CODSOLOT = av_codsolot
         and iw.pidsga = lv_pid
		 and iw.id_interfase in (620, 820, 2020, 2030);
    
      if n_cantidad = 0 then
        v_id_producto   := '0';
        v_id_interfase  := 0;
        v_tipo_servicio := 'INT';
      elsif n_cantidad = 1 then
        SELECT iw.ID_PRODUCTO, id_interfase, tip_interfase
          INTO v_id_producto, v_id_interfase, v_tipo_servicio
          FROM OPERACION.TRS_INTERFACE_IW iw, solot s
         WHERE s.codsolot = iw.codsolot
           and s.CODSOLOT = av_codsolot
           and iw.pidsga = lv_pid --12.0
		   and iw.id_interfase in (620, 820, 2020, 2030);
      else
        SELECT distinct iw.pidsga, id_interfase, tip_interfase
          INTO n_pidsga, v_id_interfase, v_tipo_servicio
          FROM OPERACION.TRS_INTERFACE_IW iw, solot s
         WHERE s.codsolot = iw.codsolot
           and s.CODSOLOT = av_codsolot
           and iw.pidsga = lv_pid
		   and iw.id_interfase in (620, 820, 2020, 2030);
      
        if v_id_interfase = '2020' then
          v_id_producto := to_char(n_pidsga) || to_char(n_cuenta);
          n_cuenta      := n_cuenta + 1;
        elsif v_id_interfase = '2030' then
          v_id_producto := to_char(n_pidsga) || to_char(n_cuenta) ||
                           to_char(n_cuenta1);
          n_cuenta1     := n_cuenta1 + 1;
         else
          v_id_producto := to_char(n_pidsga) || to_char(n_cuenta);
          n_cuenta      := n_cuenta + 1;
        end if;
      end if;
      --fin 13.0
    
      insert into OPERACION.TAB_EQUIPOS_IW
        (codsolot,
         customer_id,
         cod_id,
         tipo_servicio,
         interfase,
         id_producto,
         modelo,
         mac_Address,
         serial_number,
         unit_address,
         profile_crm,
         numero)
      values
        (av_codsolot,
         an_customerid,
         an_cod_id,
         v_tipo_servicio,
         v_id_interfase,
         v_id_producto,
		 -- 14.0
         lv_Model,
         lv_MacAddress,
         lv_serialNumber,
         lv_unitAddress,
         lv_serviceType,
         lv_numero); -- FIN 14.0
    
    END LOOP;
  
  EXCEPTION  
    WHEN OTHERS THEN
      an_error := -1;
      av_error := 'Error ' || av_error || SQLERRM;
      p_reg_log(an_customerid,
                NULL,
                NULL,
                av_codsolot,
                NULL,
                an_error,
                av_error,
                an_cod_id,
                'Regularizacion - Insertar Equipos');
  END;
-- INI 14.0
PROCEDURE SP_LISTA_MATERIALES(an_estado IN NUMBER,av_codsolot IN NUMBER,o_resultado OUT T_CURSOR) IS

V_SQL VARCHAR2(9000);
  BEGIN
    IF an_estado = 0 THEN
    -- FTTH
    V_SQL:='select distinct (ft.idficha),
                      iv.tipsrv,
                      (select valortxt
                         from ft_instdocumento
                        where idficha = ft.idficha
                          and idlista = 123) MacAddress,
                      (select valortxt
                         from ft_instdocumento
                        where idficha = ft.idficha
                          and idlista in (110, 123)) serialNumber,
                      (select valortxt
                         from ft_instdocumento
                        where idficha = ft.idficha
                          and idlista = 111) unitAddress,
                      (select valortxt
                         from ft_instdocumento
                        where idficha = ft.idficha
                          and idlista in (124, 112)) Model,
                      (select valortxt
                         from ft_instdocumento
                        where idficha = ft.idficha
                          and idlista = 93) serviceType,
                      (select valortxt
                         from ft_instdocumento
                        where idficha = ft.idficha
                          and idlista = 98) numero,
                          sp.pid PID --12.0
        from ft_instdocumento ft, solotpto sp, inssrv iv
       where sp.pid = ft.codigo1
         and iv.codinssrv = codigo2
         and sp.codsolot = '||av_codsolot;
   ELSE
      -- HFC
            V_SQL:='select distinct (ft.idficha),
                      iv.tipsrv,
                      (select valortxt
                         from ft_instdocumento
                        where idficha = ft.idficha
                          and idlista = 96) MacAddress,
                      (select valortxt
                         from ft_instdocumento
                        where idficha = ft.idficha
                          and idlista = 110) serialNumber,
                      (select valortxt
                         from ft_instdocumento
                        where idficha = ft.idficha
                          and idlista = 111) unitAddress,
                      (select valortxt
                         from ft_instdocumento
                        where idficha = ft.idficha
                          and idlista = 104) Model,
                      (select valortxt
                         from ft_instdocumento
                        where idficha = ft.idficha
                          and idlista = 93) serviceType,
                      (select valortxt
                         from ft_instdocumento
                        where idficha = ft.idficha
                          and idlista = 98) numero,
                          sp.pid PID --12.0
        from ft_instdocumento ft, solotpto sp, inssrv iv
       where sp.pid = ft.codigo1
         and iv.codinssrv = codigo2
         and sp.codsolot = '||av_codsolot;
  END IF;
  OPEN o_resultado FOR
  V_SQL;
END;
  -- FIN 14.0  
 --- ini 15.0
procedure sp_valida_prov_app ( a_idtareawf in number default null,
                               a_idwf      in number,
                               a_tarea     in number default null,
                               a_tareadef  in number default null,
                               an_error      OUT NUMBER,
                               av_error      OUT VARCHAR) is  
                               
v_error VARCHAR2(300); 
n_codsolot number;
n_customer_id number;  -- 16.0
n_co_id number;
n_val_int number;
n_val_tel number;
n_val_cab number;
v_mac_address_cm varchar(30);
v_mac_address_mta varchar(30);
v_unit_address varchar(30);
v_serial_number varchar(30);

cursor c_ctv is
select idficha from ft_instdocumento  where codigo3 in 
(select to_char(customer_id) from solot where codsolot= n_codsolot)
and iddocumento=12 and etiqueta='SERVICE_ID';

BEGIN
  
 select w.codsolot, s.customer_id
      into n_codsolot,n_customer_id   -- 16.0
      from opewf.wf w, operacion.solot s
	  where w.codsolot = s.codsolot
	  and w.idwf = a_idwf;


  OPERACION.PQ_IW_SGA_BSCS.p_inicio_fact(a_idtareawf, a_idwf, null, null);

  select a.codsolot, b.cod_id
    into n_codsolot, n_co_id
    from wf a, solot b
   where a.idwf = a_idwf
     and a.codsolot = b.codsolot;

  operacion.pq_sinergia.p_reg_log(to_char(n_co_id),
                                  sqlcode,
                                  v_error,
                                  null,
                                  n_codsolot,
                                  null,
                                  null,
                                  null);
  select count(1)
    into n_val_int
    from TIM.PF_HFC_INTERNET@DBL_BSCS_BF
   where co_id = n_co_id
     and estado_recurso not in ('PR');
     
  operacion.pq_sinergia.p_reg_log('HFC_BSCS1',
                                  n_val_int,
                                  v_error,
                                  null,
                                  n_codsolot,
                                  n_co_id,
                                  null,
                                  null);
  if n_val_int > 0 then
    operacion.pq_sinergia.p_reg_log('HFC_BSCS2',
                                    sqlcode,
                                    'int',
                                    null,
                                    n_codsolot,
                                    null,
                                    null,
                                    null);
    update TIM.PF_HFC_DATOS_SERV@DBL_BSCS_BF
       set estado = 'A'
     where co_id = n_co_id
       and tipo_serv in ('INT');
       
    select valortxt
      into v_mac_address_cm
      from ft_instdocumento,solotpto pto  -- Ini 16.0
       where codigo3 = to_char(n_customer_id)
       and codigo2 = pto.codinssrv
       and codigo1 = pto.pid   -- fin 16.0
       and iddocumento = 10
       and etiqueta = 'MacAddress_CM';
    update TIM.PF_HFC_INTERNET@DBL_BSCS_BF
       set mac_address    = v_mac_address_cm,
           estado_recurso = 'A',
           reserva_act    = sysdate,
           instal_act     = sysdate
     where co_id = n_co_id;
  end if;
  
  select count(1)
    into n_val_tel
    from TIM.PF_HFC_TELEFONIA@DBL_BSCS_BF
   where co_id = n_co_id
     and estado_recurso not in ('PR');
  if n_val_tel > 0 then
    operacion.pq_sinergia.p_reg_log('HFC_BSCS3',
                                    sqlcode,
                                    'tel',
                                    null,
                                    n_codsolot,
                                    null,
                                    null,
                                    null);
    update TIM.PF_HFC_DATOS_SERV@DBL_BSCS_BF
       set estado = 'A'
     where co_id = n_co_id
       and tipo_serv in ('TEP', 'TLF', 'ATE');
    select valortxt
      into v_mac_address_mta
        from ft_instdocumento,solotpto pto   -- Ini 16.0
       where codigo3 = to_char(n_customer_id)
       and codigo2 = pto.codinssrv
       and codigo1 = pto.pid  -- fin 16.0
       and iddocumento = 11
       and etiqueta = 'MacAddress_MTA';
    update TIM.PF_HFC_TELEFONIA@DBL_BSCS_BF
       set MAC_ADDRESS    = v_mac_address_mta,
           estado_recurso = 'A',
           reserva_act    = sysdate,
           instal_act     = sysdate
     where co_id = n_co_id;
  end if;
  
  select count(1)
    into n_val_cab
    from TIM.PF_HFC_CABLE_TV@DBL_BSCS_BF
   where co_id = n_co_id
     and estado_recurso not in ('PR');
  if n_val_cab > 0 then
    for c in c_ctv loop
      operacion.pq_sinergia.p_reg_log('HFC_BSCS4',
                                      sqlcode,
                                      'cab',
                                      null,
                                      n_codsolot,
                                      null,
                                      null,
                                      null);
      update TIM.PF_HFC_DATOS_SERV@DBL_BSCS_BF
         set estado = 'A'
       where co_id = n_co_id
         and tipo_serv in ('ATV', 'CTV', 'VOD');
      select valortxt
        into v_unit_address
        from ft_instdocumento,solotpto pto   --- ini 16.0
       where codigo3 = to_char(n_customer_id)
         and codigo2 = pto.codinssrv
         and codigo1 = pto.pid   -- fin 16.0
         and iddocumento = 12
         and idficha = c.idficha
         and etiqueta = 'HOST_UNIT_ADDRESS';
      select valortxt
        into v_serial_number
        from ft_instdocumento,solotpto pto	 -- Ini 16.0
       where codigo3 = to_char(n_customer_id)
         and codigo2 = pto.codinssrv
         and codigo1 = pto.pid   -- fin 16.0
         and iddocumento = 12
         and idficha = c.idficha
         and etiqueta = 'serialNumber STB';
      update TIM.PF_HFC_CABLE_TV@DBL_BSCS_BF
         set UNIT_ADDRESS   = v_unit_address,
             serial_number  = v_serial_number,
             estado_recurso = 'A',
             reserva_act    = sysdate,
             instal_act     = sysdate
       where co_id = n_co_id;
    end loop;
  end if;
  
  -- 17.0 Ini
  SP_UPDATE_MODEL_EQUIP(N_CODSOLOT, AN_ERROR, AV_ERROR);
  -- 17.0 Fin

   av_error  := 'Exito en el Proceso';
   an_Error  := 0;
exception
  when others then
    an_error := -1;    
    av_error := 'Descarga: ' || ' - ' || sqlerrm;
    operacion.pq_sinergia.p_reg_log('HFC_BSCS',
                                    sqlcode,
                                    av_error,
                                    null,
                                    n_codsolot,
                                    null,
                                    null,
                                    null);
END;
  --- FIN 15.0 
--Ini 17.0
PROCEDURE SP_UPDATE_MODEL_EQUIP(A_CODSOLOT IN SOLOT.CODSOLOT%TYPE,
							    AN_ERROR   OUT INTEGER,
							    AV_ERROR   OUT VARCHAR2) AS
V_CODEQUCOM VTAEQUCOM.CODEQUCOM%TYPE;
V_PID       INSPRD.PID%TYPE;

BEGIN

AN_ERROR := 0;
AV_ERROR := 'Éxito en el Proceso';

/*1. Obtenemos el CODEQUCOM en base al modelo del equipo (SOLO PARA INTERNET : 820)*/
BEGIN
  SELECT V.CODEQUCOM
	INTO V_CODEQUCOM
	FROM VTAEQUCOM V
   WHERE MODELOEQUITW = (SELECT DISTINCT W.MODELO
						   FROM OPERACION.TAB_EQUIPOS_IW W
						  WHERE W.CODSOLOT = A_CODSOLOT
							AND W.INTERFASE = 820
							AND W.MODELO IS NOT NULL)
	 AND ROWNUM = 1;
EXCEPTION
  WHEN OTHERS THEN
	V_CODEQUCOM := NULL;
END;

/*2. Obtenemos el PID para actualizar*/
IF V_CODEQUCOM IS NOT NULL THEN
  BEGIN
	SELECT DISTINCT I.PID
	  INTO V_PID
	  FROM INSPRD     I,
		   VTAEQUCOM  V,
		   TIPEQU     T,
		   EQUCOMXOPE X,
		   SOLOTPTO   PTO,
		   INSSRV     INS
	 WHERE I.CODEQUCOM = V.CODEQUCOM
	   AND X.CODEQUCOM = V.CODEQUCOM
	   AND T.CODTIPEQU = X.CODTIPEQU
	   AND PTO.CODINSSRV = INS.CODINSSRV
	   AND INS.CODINSSRV = I.CODINSSRV
	   AND PTO.CODSOLOT = A_CODSOLOT
	   AND T.TIPO = 'EMTA';
  EXCEPTION
	WHEN OTHERS THEN
	  V_PID := NULL;
  END;
END IF;

/*3. En base al CODEQUCOM y al PID actualizamos el nuevo CODEQUCOM*/
IF (V_CODEQUCOM IS NOT NULL AND V_PID IS NOT NULL) THEN

  BEGIN
	UPDATE INSPRD I
	   SET I.CODEQUCOM = V_CODEQUCOM
	 WHERE I.PID = V_PID
	   AND I.CODEQUCOM <> V_CODEQUCOM;
  EXCEPTION
	WHEN OTHERS THEN
	  AN_ERROR := -1;
	  AV_ERROR := 'Error al actualizar la tabla:insprd';
  END;

END IF;

EXCEPTION
WHEN OTHERS THEN
  AN_ERROR := -1;
  AV_ERROR := 'Error in sp_update_model_equip' || ' ' ||
			  TO_CHAR(SQLCODE) || ' ' || SQLERRM || ' ' || 'Linea:(' ||
			  DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ')';
END;
-- Fin 17.0   
END PQ_CONT_REGULARIZACION;
/