CREATE OR REPLACE PACKAGE BODY OPERACION.pq_adm_cuadrilla IS
  /****************************************************************************************************
     NOMBRE:        PQ_ADM_CUADRILLA
     DESCRIPCION:   Manejo de las customizaciones proyecto administracion manejo de cuadrillas.

     Ver        Date        Author              	Solicitado por       Descripcion
     ---------  ----------  ------------------- 	----------------   	------------------------------------
     1.0        08/05/2015  Jorge Rivas/        	Nalda Arotinco     	PQT-235788-TSK-70790 - Administracion
                            Steve Panduro/                         		de Cuadrillas.
                            Justiniano Condori
     2.0        25/02/2016  Steve Panduro       	Nalda Arotinco     	SD-690390
     3.0        12/04/2016  Jorge Rivas         	Nalda Arotinco     	SD-744023
     4.0        10/05/2016  Juan Gonzales       	Nalda Arotinco     	SGA-SD-788452
     5.0        11/02/2016  Emma Guzman         	Lizbeth Portella   	PROY- 22818 -IDEA-28605 Administraci?n y manejo de cuadrillas  - TOA Fase 2 Claro Empresas
     6.0        07/06/2016  Juan Gonzales       	Nalda Arotinco     	SD-820645
     7.0        15/06/2016  Juan Gonzales       	Nalda Arotinco     	SD-833131
     8.0        24/06/2016  Juan Gonzales       	Lizbeth Portella   	SD-837900 - Activacion de Equipos ETA
     9.0        13/07/2016  Felipe Magui?a      	Lizbeth Portella   	SD-861542
    10.0        08/08/2016  Justiniano Condori  	Lizbeth Portella   	PROY-22818-IDEA-28605 Administraci?n y manejo de cuadrillas  - TOA
    11.0        01/09/2016  Justiniano Condori  	Lizbeth Portella   	SD-861528
    12.0        12/09/2016  Justiniano Condori  	Lizbeth Portella
    13.0        07/12/2016  Juan Gonzales       	Lizbeth Portella   	PROY-22818.SD1025748
    14.0        16/09/2016  Luis Guzman         	Lizbeth Portella   	PROY-25148-IDEA-32224
    15.0        20/02/2017  HITSS               	HITSS              	SD_INC000000710996
    16.0        13/03/2017  HITSS               	HITSS              	SD_INC000000737351
    17.0        06/04/2017  Edwin Vasquez       	Lizbeth Portella   	PROY-25148 IDEA-32224 - Mejoras en los SIACs para TOA y Reclamos
    18.0        26/06/2017  Edwin Vasquez       	Lizbeth Portella   	PROY-25148 INC000000845147 - Mejoras en los SIACs para TOA y Reclamos
    19.0        14/07/2017  Servicio Fallas-HITSS                  		INC000000823426
    20.0        07/07/2017  Edwin Vasquez       	Lizbeth Portella   	PROY-22818 INC000000858490 - Mejoras en los SIACs para TOA y Reclamos
    21.0        29/09/2017  Servicio Fallas-HITSS                  		INC000000919982
    22.0        12/02/2018  Servicio Fallas-HITSS                  		INC000001057696
    23.0        12/09/2017  Luigi Sipion        	Nalda Arotico      	PROY-40032-IDEA-40030 Adap. SGA Gestor de Agendamiento/Liquidaciones para integrar con FullStack
    24.0        21/09/2018  Gino Guti?rrez      	Lizbeth Portella   	PROY-26249 Adaptaciones Legados TI para Proceso MWF AdmCuadrillas
    25.0        05/11/2018  Servicio Fallas-HITSS                  		INC
    26.0        28/11/2018  Obed Ortiz                             		PROY-32581 Adaptaciones para agendamiento LTE
    27.0        29/11/2018  HITSS                                  		PROY-40032 ONE ticket remedy
    28.0        17/01/2019  Abel Ojeda           	Luis Flores       	PROY-32581 Estado de subtipos de orden
    29.0        28/02/2019  Steve Panduro                          		PROY-140139 IDEA-140301 | Integraci?n de la red FTTH a los sistemas de Claro
    30.0        13/11/2019  Steve Panduro        						          TRASLADO EXTERNO  / INTERNO FTTH
    31.0        26/12/2019  Romario Medina       	Lizbeth Portella  	INICIATIVA-195 IDEA-141141 - Nuevas Funcionalidades II
    32.0        08/01/2020  Nilton Paredes       	Lizbeth Portella  	INICIATIVA-195 IDEA-141141 - Nuevas Funcionalidades II
	33.0        06/01/2020  Jorge Benites        	Lizbeth Portella  	INICIATIVA-195.SGA_2.AG IDEA-141141 - Nuevas Funcionalidades II
	34.0        06/02/2020  Lizbeth Portella        Lizbeth Portella  	INICIATIVA-435.SGA.AG - Nuevas Funcionalidades II
	35.0        06/03/2020  Lizbeth Portella        Lizbeth Portella  	INICIATIVA-435.SGA.AG - Nuevas Funcionalidades II RESERVA TOA
	36.0        03/04/2020  Lizbeth Portella        Lizbeth Portella  	INICIATIVA-516.SGA.AG - Nuevas Funcionalidades II RESERVA TOA
  ****************************************************************************************************/

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        08/05/2015  Jorge Rivas      Actualiza categoria del cliente VIP
  ******************************************************************************/
  PROCEDURE p_actualiza_indicadorvip(as_customercode IN customer_atention.customercode%TYPE,
                                     an_iderror      OUT NUMERIC,
                                     as_mensajeerror OUT VARCHAR2) IS
  BEGIN
    BEGIN
      UPDATE customer_atention
         SET codcategory =
             (SELECT d.codigon
                FROM operacion.parametro_det_adc d,
                     operacion.parametro_cab_adc c
               WHERE d.estado = 1
                 AND d.abreviatura = 'VIP'
                 AND d.id_parametro = c.id_parametro
                 AND c.estado = 1
                 AND c.abreviatura = 'CATEGORIA_CLIENTE')
       WHERE customercode = as_customercode;

      UPDATE vtatabcli SET flgvip = 1 WHERE codcli = as_customercode;

      an_iderror      := 0;
      as_mensajeerror := NULL;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        an_iderror      := 1;
        as_mensajeerror := '[pq_adm_cuadrilla.p_actualiza_indicadorvip] Cliente no existe';

      WHEN OTHERS THEN
        an_iderror      := -1;
        as_mensajeerror := '[pq_adm_cuadrilla.p_actualiza_indicadorvip] Se genero el error: ' ||
                           sqlerrm || '.';
    END;
  END p_actualiza_indicadorvip;

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        08/05/2015  Jorge Rivas      Valida si el cliente es VIP
  ******************************************************************************/
  FUNCTION f_valida_cliente_vip(as_customercode IN customer_atention.customercode%TYPE)
    RETURN NUMBER IS
    ln_codcategory customer_atention.codcategory%TYPE;
    ln_codigon     operacion.parametro_det_adc.codigon%TYPE;
  BEGIN
    BEGIN
      ln_codcategory := 0;
      BEGIN
        SELECT d.codigon
          INTO ln_codigon
          FROM operacion.parametro_det_adc d, operacion.parametro_cab_adc c
         WHERE d.estado = 1
           AND d.abreviatura = 'VIP'
           AND d.id_parametro = c.id_parametro
           AND c.estado = 1
           AND c.abreviatura = 'CATEGORIA_CLIENTE';
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          RETURN - 1;
      END;

      SELECT codcategory
        INTO ln_codcategory
        FROM customer_atention
       WHERE customercode = as_customercode;

      IF nvl(ln_codcategory, -1) <> ln_codigon THEN
        ln_codcategory := 0;
        RETURN ln_codcategory;
      END IF;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        ln_codcategory := 0;
        RETURN ln_codcategory;
    END;

    RETURN 1;
  END f_valida_cliente_vip;

  /******************************************************************************
  Ver        Date        Author              Description
  ---------  ----------  ------------------  ------------------------------------
  1.0        22/05/2015  Jorge Rivas         Valida si la SOLOT tiene flujo adc
  2.0        dd/mm/yyyy  Programador         Valida la existencia en la matriz
  3.0        01/09/2016  Justiniano Condori  Modificacion de Flujo
  ******************************************************************************/
  PROCEDURE p_valida_flujo_adc(an_idagenda     IN agendamiento.idagenda%TYPE,
                               an_flag_aplica  OUT NUMERIC,
                               an_iderror      OUT NUMERIC,
                               as_mensajeerror OUT VARCHAR2) IS
    lv_subtipo     operacion.subtipo_orden_adc.cod_subtipo_orden%type;
    ln_tiptra      operacion.solot.tiptra%TYPE;
    ln_tipsrv      operacion.solot.tipsrv%TYPE;
    lv_codplano    operacion.parametro_vta_pvta_adc.plano%TYPE;
    lv_idpoblado   operacion.parametro_vta_pvta_adc.idpoblado%TYPE;
    lv_zona        operacion.zona_adc.codzona%type;
    lv_bucket      operacion.parametro_vta_pvta_adc.idbucket%type;
    ln_tecnico     operacion.parametro_vta_pvta_adc.dni_tecnico%type;
    ld_fecha       operacion.parametro_vta_pvta_adc.fecha_progra%type;
    lv_franja      operacion.parametro_vta_pvta_adc.franja%type;
    ln_pp          operacion.parametro_vta_pvta_adc.flg_puerta%type;
    ln_rtn         NUMBER;
    lv_tipo_agenda varchar2(30);
    ln_codmotot    number;
    ln_existe      number; --2.0
    e_error EXCEPTION;
  BEGIN
    an_flag_aplica := 0;

    -- 2.0 ini --  sino estan activas las configuraciones no aplicar --
    begin
    select 1 into ln_existe
     from   agendamiento a,
         solot s
    where a.idagenda = an_idagenda --s.codsolot = a.codsolot and
         and a.codsolot = s.codsolot
         and  exists (select * from operacion.matriz_tystipsrv_tiptra_adc ts where ts.tiptra = s.tiptra and ts.estado = 1 and ts.tipsrv = s.tipsrv);
    exception
      WHEN NO_DATA_FOUND THEN
        ln_existe := 0;
    end;

    if ln_existe = 0 then
       an_flag_aplica := 0;
       RETURN;
    end if;
    -- 2.0 fin --

    p_obtiene_valores_adc(an_idagenda,
                          lv_codplano,
                          lv_idpoblado,
                          lv_subtipo,
                          ln_tiptra,
                          ln_tipsrv,
                          lv_bucket,
                          ln_tecnico,
                          ld_fecha,
                          lv_franja,
                          ln_pp,
                          lv_zona,
                          an_iderror,
                          as_mensajeerror);
    -- Buscando el tipo de Agenda
    begin
      select a.tipo
        into lv_tipo_agenda
        from operacion.agendamiento a
       where a.idagenda = an_idagenda;
    exception
      WHEN NO_DATA_FOUND THEN
        lv_tipo_agenda := '';
    end;
    -- Buscando el Motivo de la SOT
    begin
      select s.codmotot
        into ln_codmotot
        from operacion.solot s
       where s.codsolot = (select a.codsolot
                             from operacion.agendamiento a
                            where a.idagenda = an_idagenda);
    exception
      WHEN NO_DATA_FOUND THEN
        ln_codmotot := 0;
    end;

    -- validar flujo --
    p_valida_flujo_mot_adc('O',
                           lv_codplano,
                           lv_idpoblado,
                           ln_tiptra,
                           ln_tipsrv,
                           lv_tipo_agenda,
                           ln_codmotot,
                           lv_zona,
                           ln_rtn);
    -- Ini 3.0
    if ln_rtn = 2 then
      ln_rtn := 1;
    end if;
    -- Fin 3.0
    IF ln_rtn = -1 THEN
      as_mensajeerror := '[operacion.pq_adm_cuadrilla.p_valida_flujo_adc] - Codigo de plano <' ||
                         nvl(lv_codplano, 'NULL') || '>, no existe';
      RAISE e_error;
    END IF;

    IF ln_rtn = -2 THEN
      as_mensajeerror := '[operacion.pq_adm_cuadrilla.p_valida_flujo_adc] - Codigo de centro poblado <' ||
                         nvl(lv_idpoblado, 'NULL') || '>, no existe';
      RAISE e_error;
    END IF;

    IF ln_rtn = -3 THEN
      as_mensajeerror := '[operacion.pq_adm_cuadrilla.p_valida_flujo_adc] - Codigo de plano y centro poblado no pueden ser nulos';
      RAISE e_error;
    END IF;

    IF ln_rtn = -4 THEN
      an_flag_aplica  := 1;
      an_iderror      := ln_rtn;
      as_mensajeerror := '[operacion.pq_adm_cuadrilla.p_valida_flujo_adc] - Aplica Flujo ETA pero Zona no fue configurada.';
      return;
    END IF;

    an_flag_aplica  := ln_rtn;
    an_iderror      := 0;
    as_mensajeerror := NULL;

  EXCEPTION
    WHEN e_error THEN
      an_iderror     := 0;
      an_flag_aplica := 0;

    WHEN OTHERS THEN
      an_iderror      := -1;
      an_flag_aplica  := 0;
      as_mensajeerror := '[operacion.pq_adm_cuadrilla.p_valida_flujo_adc] - Se genero el error: ' ||
                         sqlerrm || '.';
  END p_valida_flujo_adc;

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        22/05/2015  Jorge Rivas      Actualiza las coordenas X, Y de la sucursal
  ******************************************************************************/
  PROCEDURE p_actualiza_xy_adc(av_codcli       IN marketing.vtasuccli.codcli%TYPE,
                               av_codsuc       IN marketing.vtasuccli.codsuc%TYPE,
                               av_coordx       IN marketing.vtasuccli.coordx_eta%TYPE,
                               av_coordy       IN marketing.vtasuccli.coordy_eta%TYPE,
                               an_iderror      OUT NUMERIC,
                               as_mensajeerror OUT VARCHAR2) IS
    e_error EXCEPTION;
  BEGIN
    BEGIN

      IF av_coordx IS NULL THEN
        as_mensajeerror := 'Coordenada X es NULL';
        RAISE e_error;
      END IF;

      IF av_coordy IS NULL THEN
        as_mensajeerror := 'Coordenada Y es NULL';
        RAISE e_error;
      END IF;

      UPDATE marketing.vtasuccli
         SET coordx_eta = av_coordx, coordy_eta = av_coordy
       WHERE codsuc = av_codsuc
         AND codcli = av_codcli;

      INSERT INTO operacion.vtatabcli_his
        (codcli, codsuc, coordx, coordy)
      VALUES
        (av_codcli, av_codsuc, av_coordx, av_coordy);

      an_iderror      := 0;
      as_mensajeerror := NULL;

    EXCEPTION
      WHEN e_error THEN
        an_iderror := -1;

      WHEN NO_DATA_FOUND THEN
        an_iderror      := -2;
        as_mensajeerror := '[operacion.pq_adm_cuadrilla.p_actualiza_xy_adc] Codigo de cliente ' ||
                           av_codcli || ' no existe';
      WHEN OTHERS THEN
        an_iderror      := -3;
        as_mensajeerror := '[operacion.pq_adm_cuadrilla.p_actualiza_xy_adc] Se genero el error: ' ||
                           sqlerrm || '.';
    END;
  END p_actualiza_xy_adc;

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        22/05/2015  Jorge Rivas      Retorna las coordenas X, Y de la sucursal
  ******************************************************************************/
  PROCEDURE p_retorna_agendamiento_xy(an_idagenda     IN operacion.agendamiento.idagenda%TYPE,
                                      av_coordx       OUT marketing.vtasuccli.coordx_eta%TYPE,
                                      av_coordy       OUT marketing.vtasuccli.coordy_eta%TYPE,
                                      an_iderror      OUT NUMERIC,
                                      as_mensajeerror OUT VARCHAR2) IS
  BEGIN
    BEGIN
      SELECT v.coordx_eta, v.coordy_eta
        INTO av_coordx, av_coordy
        FROM marketing.vtasuccli v, operacion.agendamiento a
       WHERE v.codsuc = a.codsuc
         AND v.codcli = a.codcli
         AND a.idagenda = an_idagenda;

      an_iderror      := 1;
      as_mensajeerror := NULL;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        an_iderror      := 0;
        as_mensajeerror := '[operacion.pq_adm_cuadrilla.p_retorna_agendamiento_xy] Agendamiento no existe';

      WHEN OTHERS THEN
        an_iderror      := -1;
        as_mensajeerror := '[operacion.pq_adm_cuadrilla.p_retorna_agendamiento_xy] Se genero el error: ' ||
                           sqlerrm || '.';
    END;
  END p_retorna_agendamiento_xy;

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        22/05/2015  Jorge Rivas      Generacion de trama para cancelacion de agenda
  ******************************************************************************/
  PROCEDURE p_gen_trama_cancela_agenda(an_idagenda     IN operacion.agendamiento.idagenda%TYPE,
                                       av_trama        OUT CLOB,
                                       an_iderror      OUT NUMERIC,
                                       as_mensajeerror OUT VARCHAR2) IS

    ln_idagenda    operacion.agendamiento.idagenda%TYPE;
    lv_delimitador VARCHAR2(1) := '|';
    lv_auditoria   VARCHAR2(100);
    lv_ip          VARCHAR2(20);
    lv_fecha       VARCHAR2(20);
    lv_user        VARCHAR2(50) := USER;
    lv_nro_toa     VARCHAR2(30); --INI 33.0
    ln_codsolot    NUMBER(8); --INI 33.0
    ln_tot_nro_toa NUMBER(8); --INI 33.0
  BEGIN
    BEGIN
      SELECT idagenda,codsolot--INI 33.0
        INTO ln_idagenda,ln_codsolot--INI 33.0
        FROM operacion.agendamiento
       WHERE idagenda = an_idagenda;
      
      --INI 33.0
      lv_nro_toa:= to_char(ln_idagenda);
      SELECT COUNT(DISTINCT RESTV_NRO_ORDEN ) INTO ln_tot_nro_toa  FROM OPERACION.SGAT_RESERVA_TOA 
      WHERE restn_nro_solot=ln_codsolot AND RESTN_ESTADO = 2;
      IF ln_tot_nro_toa=1 THEN
        SELECT DISTINCT RESTV_NRO_ORDEN 
        INTO lv_nro_toa
        FROM OPERACION.SGAT_RESERVA_TOA 
        WHERE restn_nro_solot=ln_codsolot AND RESTN_ESTADO = 2;
      END IF;
      --FIN  33.0                         
      
      SELECT sys_context('userenv', 'ip_address') into lv_ip from dual;
      SELECT to_char(sysdate, 'YYYYMMDDHH24MI') into lv_fecha from dual;

      lv_auditoria := lv_fecha || lv_delimitador || lv_ip || lv_delimitador ||
                      lv_aplicacion || lv_delimitador || lv_user ||
                      lv_delimitador;

      av_trama := 'incremental' || lv_delimitador || 'appt_number' ||
                  lv_delimitador || 'invsn' || lv_delimitador ||
                  'cancel_appointment' || lv_delimitador ||
                  lv_nro_toa;--33.0

      av_trama        := lv_auditoria || av_trama;
      an_iderror      := 1;
      as_mensajeerror := NULL;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        an_iderror      := 0;
        as_mensajeerror := '[operacion.pq_adm_cuadrilla.p_gen_trama_cancela_agenda] Agendamiento no existe';

      WHEN OTHERS THEN
        an_iderror      := -1;
        as_mensajeerror := '[operacion.pq_adm_cuadrilla.p_gen_trama_cancela_agenda] No se pudo generar la trama de bajas error: ' ||
                           sqlerrm || '.';
    END;
  END p_gen_trama_cancela_agenda;

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        22/05/2015  Jorge Rivas      Lista los servicios por agenda
  2.0        11/02/2016   Emma Guzman     Agregar datos
  ******************************************************************************/
  PROCEDURE p_lista_servicios_agenda(an_idagenda IN agendamiento.idagenda%TYPE,
                                     av_trama    OUT CLOB) IS
    an_tipo         number; --2.0
    an_iderror      NUMERIC; --2.0
    as_mensajeerror VARCHAR2(200); --2.0
    ln_codsolot operacion.solot.codsolot%type; --2.0

    CURSOR cur IS
      SELECT solotpto.pid,
             inssrv.numero,
             tipinssrv.descripcion tipo_servicio,
             tystabsrv.dscsrv ||
             replace(replace(replace(decode(vtaequcom.dscequ,
                                            NULL,
                                            '',
                                            '-' || vtaequcom.dscequ),
                                     ';',
                                     ' '),
                             '/',
                             ' '),
                     '',
                     ' ') servicio,
             insprd.flgprinc flag_principal,
             solotpto.cantidad,--ini 2.0
             decode(an_tipo, 1, NULL, 2, inssrv.cid, null) CID, -- CID
             decode(an_tipo, 1, NULL, 2, inssrv.codinssrv, null) SID, --SID
             decode(an_tipo,
                    1,
                    NULL,
                    2,
                    null,
                    null) INTER, -- CODIGO ACTIVACION INTER
             decode(an_tipo,
                    1,
                    NULL,
                    2,
                    null,
                    null) TELEF -- CODIGO ACTIVACION TELEF -- fin 2.0
        FROM tipinssrv,
             inssrv,
             vtaequcom,
             insprd,
             tystabsrv,
             vtatabslcfac,
             solotpto,
             solot,
             agendamiento
       WHERE tipinssrv.tipinssrv = inssrv.tipinssrv
         AND (inssrv.codinssrv(+) = solotpto.codinssrv)
         AND (vtaequcom.codequcom(+) = insprd.codequcom)
         AND (insprd.pid(+) = solotpto.pid)
         AND (tystabsrv.codsrv(+) = solotpto.codsrvnue)
         AND vtatabslcfac.numslc(+) = solot.numslc
         AND (solotpto.codsolot = solot.codsolot)
         AND solot.codsolot = agendamiento.codsolot
         AND agendamiento.idagenda = an_idagenda;

    ls_body CLOB;
    ls_item CLOB;
    ls_serv CLOB;
  BEGIN
    --ini 2.0
    -- Buscando la SOT
    select a.codsolot
      into ln_codsolot
      from operacion.agendamiento a
     where a.idagenda = an_idagenda;
    -- Evaluar SOT
    p_tipo_x_tiposerv(ln_codsolot, an_tipo, an_iderror, as_mensajeerror);

    if an_tipo = 0 then
      raise_application_error(-20001,
                              'OPERACION.pq_adm_cuadrilla.p_lista_servicios_agenda - ' ||
                              to_char(an_iderror) || '-' || as_mensajeerror);
    end if;
    -- FIN 2.0
    FOR reg IN cur LOOP
      ls_item := NULL;
      ls_item := f_Obtener_XML(ls_item,
                               'Services_ToInstall',
                               '@Pid',
                               reg.PID);
      ls_item := f_Obtener_XML(ls_item,
                               'Services_ToInstall',
                               '@NroServicio',
                               reg.NUMERO);
      ls_item := f_Obtener_XML(ls_item,
                               'Services_ToInstall',
                               '@Tipo',
                               reg.TIPO_SERVICIO);
      ls_item := f_Obtener_XML(ls_item,
                               'Services_ToInstall',
                               '@Servicio',
                               f_reemplazar_Caracter(reg.SERVICIO));
      ls_item := f_Obtener_XML(ls_item,
                               'Services_ToInstall',
                               '@IPPrincipal',
                               reg.FLAG_PRINCIPAL);
      ls_item := f_Obtener_XML(ls_item,
                               'Services_ToInstall',
                               '@Cantidad',
                               reg.CANTIDAD);--ini 2.0
      ls_item := f_Obtener_XML(ls_item,
                               'Services_ToInstall',
                               '@cid',
                               reg.cid);
      ls_item := f_Obtener_XML(ls_item,
                               'Services_ToInstall',
                               '@sid',
                               reg.sid);
      ls_item := f_Obtener_XML(ls_item,
                               'Services_ToInstall',
                               '@actint',
                               reg.INTER);
      ls_item := f_Obtener_XML(ls_item,
                               'Services_ToInstall',
                               '@acttel',
                               reg.TELEF); -- fin 2.0
      ls_serv := ls_serv || ls_item;
    END LOOP;
    ls_body  := NULL;
    ls_body  := f_Obtener_XML(ls_body,
                              'XAServices_ToInstall',
                              '@ServiceToInstall',
                              ls_serv);
    av_trama := ls_body;
  END p_lista_servicios_agenda;

  /******************************************************************************
  Ver        Date        Author              Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        02/06/2015  Jorge Rivas         Ejecuta el WS de cancelacion de agenda
  2.0        02/06/2015  Steve Panduro       Claro Empresa ETA Fase 2
  3.0        04/10/2016  Justiniano Condori  PROY-22818-IDEA-28605 Sol.Cambio Inv.
  *********************************************************************************/
  PROCEDURE p_cancela_agenda(an_codsolot     IN operacion.agendamiento.codsolot%TYPE,
                             an_idagenda     IN operacion.agendamiento.idagenda%TYPE,
                             an_estagenda    IN NUMBER,
                             av_observacion  IN operacion.cambio_estado_ot_adc.motivo%TYPE,
                             an_iderror      OUT NUMERIC,
                             av_mensajeerror OUT VARCHAR2) IS
    lv_trama         CLOB;
    lv_servicio      VARCHAR2(20) := 'cancelarOrdenSGA_ADC';
    Pv_xml           CLOB;
    Pv_Mensaje_Repws VARCHAR2(3000);
    Pn_Codigo_Respws VARCHAR2(3000);
    e_error    EXCEPTION;
    e_error_ws EXCEPTION;
    ln_codsolot   operacion.agendamiento.codsolot%TYPE;
    ld_tipo_orden operacion.tipo_orden_adc.id_tipo_orden%type;
    ln_origen     NUMBER;
    ln_id_estado  NUMBER;
    lv_process    VARCHAR2(50);
    an_tipo       number; --2.0
    lv_nro_toa    varchar2(30); -- 33.0
    ln_tot_nro_toa NUMBER(8); --33.0
    ln_cod_rpta    number(1); -- 33.0  
    lv_msj_rpt     VARCHAR(200);--33.0
    ln_flg_reserva  number(1); -- 33.0
    
  BEGIN
    an_iderror      := 1;
    av_mensajeerror := NULL;
    ln_codsolot     := an_codsolot;

    IF ln_codsolot IS NULL OR ln_codsolot = 0 THEN
      lv_process := 'Cancelacion de Agenda';
      BEGIN
        SELECT codsolot
          INTO ln_codsolot
          FROM operacion.agendamiento
         WHERE idagenda = an_idagenda
           and rownum = 1;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          an_iderror      := 0;
          av_mensajeerror := '[operacion.pq_adm_cuadrilla.p_cancela_agenda] Agenda no existe';
          RAISE e_error;

      END;

      --ini 2.0
      p_tipo_serv_x_agenda(an_idagenda,
                           an_tipo,
                           an_iderror,
                           av_mensajeerror);
      if an_tipo = 0 then
        RAISE e_error;
      END if;
      --fin 2.0
      BEGIN
        if an_tipo = 1 then --2.0
          select t.id_tipo_orden
            into ld_tipo_orden
            from operacion.tiptrabajo t
           where t.tiptra in (SELECT s.tiptra
                                FROM operacion.solot s
                               WHERE codsolot = ln_codsolot);
        --ini 2.0
        else
          select t.id_tipo_orden_ce
            into ld_tipo_orden
            from operacion.tiptrabajo t
           where t.tiptra in (SELECT s.tiptra
                                FROM operacion.solot s
                               WHERE codsolot = ln_codsolot);
        end if;
        --fin 2.0
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          an_iderror      := 0;
          av_mensajeerror := '[operacion.pq_adm_cuadrilla.p_cancela_agenda] Tipo de Trabajo no existe';
          RAISE e_error;
      END;

      if ld_tipo_orden is null then
        an_iderror      := 0;
        av_mensajeerror := '[operacion.pq_adm_cuadrilla.p_cancela_agenda] Tipo de Orden no esta Configurada.';
        RAISE e_error;
      end if;
    ELSE
      lv_process  := 'Anulacion de SOLOT';
      ln_codsolot := an_codsolot;
    END IF;

    p_gen_trama_cancela_agenda(an_idagenda,
                               lv_trama,
                               an_iderror,
                               av_mensajeerror);

    IF an_iderror <> 1 THEN
      RAISE e_error;
    END IF;

    webservice.pq_obtiene_envia_trama_adc.P_WS_Consulta(ln_codsolot,
                                                        an_idagenda,
                                                        lv_servicio,
                                                        lv_trama,
                                                        Pv_xml,
                                                        Pv_Mensaje_Repws,
                                                        Pn_Codigo_Respws);
    IF Pn_Codigo_Respws <> '0' THEN
      p_insertar_log_error_ws_adc(lv_process,
                                  an_idagenda,
                                  Pn_Codigo_Respws,
                                  Pv_Mensaje_Repws);
      av_mensajeerror := Pv_Mensaje_Repws;
      RAISE e_error_ws;
    END IF;

    --- obtener simil --
    ln_id_estado := f_retorna_estado_ETA_SGA(lv_aplicacion,
                                             ld_tipo_orden, --
                                             an_estagenda,
                                             0,
                                             ln_origen);

    p_insert_ot_adc(ln_codsolot,
                    lv_aplicacion,
                    an_idagenda,
                    ln_id_estado,
                    av_observacion);
--INI 33.0
  --ini 35.0
  -- OPERACION.PKG_RESERVA_TOA.SGASS_FLAG_VAL_X_AGEN(an_idagenda, ln_flg_reserva);

  -- if ln_flg_reserva = 1 then
--fin 35.0  
         SELECT COUNT(DISTINCT RESTV_NRO_ORDEN ) 
         INTO ln_tot_nro_toa 
         FROM OPERACION.SGAT_RESERVA_TOA 
         WHERE restn_nro_solot=an_codsolot AND RESTN_ESTADO = 2;
        
      IF ln_tot_nro_toa=1 THEN
        
        SELECT DISTINCT RESTV_NRO_ORDEN 
        INTO lv_nro_toa
        FROM OPERACION.SGAT_RESERVA_TOA 
        WHERE restn_nro_solot=an_codsolot AND RESTN_ESTADO = 2;
      
         UPDATE OPERACION.SGAT_RESERVA_TOA
         SET RESTN_ESTADO = 3,
             RESTV_usumod = user,
             RESTD_fecmod = sysdate
         WHERE RESTV_NRO_ORDEN = lv_nro_toa
         AND RESTN_ESTADO = 2;
         
           IF ln_cod_rpta = -1 THEN
                       av_mensajeerror := '[operacion.pq_adm_cuadrilla.p_cancela_agenda] Se presentaron errores al actualizar el estado por la cancelacion en SGA';
                       p_insertar_log_error_ws_adc('p_cancela_agenda',
                                  an_idagenda,
                                  ln_cod_rpta,
                                  av_mensajeerror);
            END IF;      
      END IF;
--  END IF; --35.0 
	--FIN 33.0
    --Ini 3.0
    -- Se cambia el agendamiento a estado cancelado
    p_cancelar_agendaxsot(an_codsolot,
                          an_iderror,
                          av_mensajeerror);
    if an_iderror<>1 then
      return;
    end if;
    --Fin 3.0

    an_iderror      := 1;
    av_mensajeerror := NULL;
  EXCEPTION
    WHEN e_error_ws THEN
      an_iderror := -99;

    WHEN e_error THEN
      an_iderror := 0;

    WHEN OTHERS THEN
      an_iderror      := -1;
      av_mensajeerror := '[operacion.pq_adm_cuadrilla.p_cancela_agenda] Se genero el error: ' ||
                         sqlerrm || '.';
  END p_cancela_agenda;

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        03/06/2015  Jorge Rivas      Cancelacion de agendas por SOT
  2.0        19/05/2016   HITSS           PROY- 22818 -IDEA-28605
  ******************************************************************************/
  PROCEDURE p_cancela_orden(an_codsot       IN operacion.agendamiento.codsolot%TYPE,
                            an_estagenda    IN NUMBER,
                            an_iderror      OUT NUMERIC,
                            av_mensajeerror OUT VARCHAR2) IS
    CURSOR c_agenda IS
      SELECT a.idagenda, a.estage
        FROM operacion.agendamiento a
       WHERE a.codsolot = an_codsot;

    e_error    EXCEPTION;
    e_error_ws EXCEPTION;
    ln_flag_aplica NUMBER := 1;
    ln_codigon     operacion.parametro_det_adc.codigon%TYPE;
    V_CONSCAMBIO  NUMBER;
    V_ESTANULA    NUMBER;

  BEGIN
    an_iderror      := 1;
    av_mensajeerror := NULL;
    BEGIN
      SELECT d.codigon
        INTO ln_codigon
        FROM operacion.parametro_det_adc d, operacion.parametro_cab_adc c
       WHERE d.estado = 1
         AND d.abreviatura = 'CANCELADO'
         AND d.id_parametro = c.id_parametro
         AND c.estado = 1
         AND c.abreviatura = 'CANCELACION_AGENDA';
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        av_mensajeerror := '[operacion.pq_adm_cuadrilla.p_cancela_orden]  Estado de cancelacion no esta configurado en la tabla de parametros';
        p_insertar_log_error_ws_adc('Anulacion de SOLOT',
                                    an_codsot,
                                    an_iderror,
                                    av_mensajeerror);
        RAISE e_error;
    END;

      SELECT C.VALOR
        INTO V_CONSCAMBIO
        FROM operacion.CONSTANTE C
       WHERE C.CONSTANTE = 'CAMBIOSANULASOT';

      IF V_CONSCAMBIO = 1 THEN

         SELECT COUNT(1)
          INTO V_ESTANULA
           FROM OPERACION.AGENDAMIENTO A
          INNER JOIN OPERACION.AGENDAMIENTOCHGEST AC
             ON A.IDAGENDA = AC.IDAGENDA
          INNER JOIN OPERACION.SOLOT S
            ON S.CODSOLOT = A.CODSOLOT
          WHERE A.CODSOLOT = AN_CODSOT
            AND S.TIPTRA IN (SELECT CODIGON
                               FROM OPERACION.OPEDD
                              WHERE ABREVIACION = 'TTRAANULA')
            AND ((AC.IDESTADO_ADC IN
                (SELECT CODIGON
                     FROM OPERACION.OPEDD
                    WHERE ABREVIACION = 'ESTANULASOT')) OR
                AC.IDESTADO_ADC IS NULL);

        IF V_ESTANULA > 0 THEN

          UPDATE operacion.agendamiento a
             SET a.flg_orden_adc = 0
           WHERE a.codsolot = an_codsot;

        END IF;

      END IF;


    FOR r_agenda IN c_agenda LOOP
      ln_flag_aplica := f_obtiene_flag_orden_adc(r_agenda.idagenda);
      IF ln_flag_aplica = 1 THEN
        IF r_agenda.estage<> 5 then--2.0
              p_cancela_agenda(an_codsot,
                               r_agenda.idagenda,
                               ln_codigon,
                               NULL,
                               an_iderror,
                               av_mensajeerror);
            IF an_iderror = -99 THEN
              RAISE e_error_ws;
            ELSE
              IF an_iderror <> 1 THEN
                RAISE e_error;
              END IF;
            END IF;
        END IF;
      END IF;
    END LOOP;
  EXCEPTION
    WHEN e_error_ws THEN
      an_iderror := an_iderror;

    WHEN e_error THEN
      an_iderror := 0;

    WHEN OTHERS THEN
      an_iderror      := -1;
      av_mensajeerror := '[operacion.pq_adm_cuadrilla.p_cancela_orden] Se genero el error: ' ||
                         sqlerrm || '.';
  END p_cancela_orden;

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        08/06/2015  Jorge Rivas      Asignacion de contrata
  2.0        11/05/2016  Juan Gonzales    Asignacion de contrata para ejecucion desde
                                          el aplicativo ETADirect
  3.0        13/06/2016  Juan Gonzales    Relanzar la orden al momento de asignar la contrata desde ETADirect.
  5.0        12/07/2016  Felipe Magui?a   SD-861542 relanzar orden
  6.0        09/11/2016  Justiniano       Corregir plano
  ******************************************************************************/
  PROCEDURE p_asignacontrata_adc(an_agenda       operacion.agendamiento.idagenda%TYPE,
                                 av_subto        VARCHAR2,
                                 av_idbucket     VARCHAR2,
                                 av_codcon       VARCHAR2,
                                 an_iderror      OUT NUMBER,
                                 av_mensajeerror OUT VARCHAR2) IS
  --ini 3.0
  e_error             exception;
  an_sot              solot.codsolot%type;
  d_fecha             date;
  av_bucket            agendamiento.idbucket%type;
  av_franja_horaria    operacion.franja_horaria.codigo%type;
  av_zona              operacion.zona_adc.codzona%type;
  av_plano             agendamiento.idplano%type;
  an_tipo_orden        operacion.tipo_orden_adc.cod_tipo_orden%type;
  an_subtipo_orden     operacion.subtipo_orden_adc.cod_subtipo_orden%type;
  av_error             varchar2(10);
  an_flag              number;
  lv_plano             marketing.vtatabgeoref.idplano%TYPE; --6.0
  lv_zona              operacion.zona_adc.codzona%TYPE;--6.0

  --fin 3.0
  an_flag_relanzar     number;--5.0
  BEGIN
    -- ini 4.0
    p_asignacontrata_st (an_agenda,av_subto,av_idbucket,av_codcon,an_iderror,av_mensajeerror);
    --ini 3.0
    if an_iderror <> 0 then
       raise e_error;
    end if;

    BEGIN
      SELECT D.CODIGON
        INTO AN_FLAG
        FROM OPERACION.PARAMETRO_DET_ADC D, OPERACION.PARAMETRO_CAB_ADC C
       WHERE D.ESTADO = 1
         AND D.ID_PARAMETRO = C.ID_PARAMETRO
         AND C.ESTADO = 1
         AND C.ABREVIATURA = 'VALIDA_ORDEN_ADC';

    EXCEPTION
    WHEN NO_DATA_FOUND THEN
         an_flag := 0;
    END;
    -- Ini 5.0
      BEGIN
      SELECT a.flg_relanzar
        INTO AN_FLAG_RELANZAR
        FROM OPERACION.AGENDAMIENTO a
       WHERE a.idagenda=an_agenda;

    EXCEPTION
    WHEN NO_DATA_FOUND THEN
         an_flag_relanzar := 0;
    END;
    -- Fin 5.0
    if SGAFUN_TECNO_PERMITIDA(an_agenda) then -- Ini 18.0
    if an_flag = 1 then
    if AN_FLAG_RELANZAR = 0 then -- 5.0
    p_obtener_prog_agenda (an_agenda,
                           an_sot,
                           d_fecha,
                           av_bucket,
                           av_franja_horaria,
                           av_zona,
                           av_plano,
                           an_tipo_orden,
                           an_subtipo_orden,
                           an_iderror,
                           av_mensajeerror);

    if an_iderror <> 0 then
       raise e_error;
    end if;
  --<6.0>
   -- Procedimiento para Sacar la Zona
     p_retornar_zona_plano(av_plano,
                            null,
                            lv_plano,
                            lv_zona,
                            an_iderror,
                            av_mensajeerror);
  --</6.0>
    p_crear_orden_adc_pr(an_agenda,
                         an_sot,
                         d_fecha,
                         av_bucket,
                         av_franja_horaria,
                         av_zona,
                         lv_plano,--.6.0
                         an_tipo_orden,
                         an_subtipo_orden,
                         av_error,
                         av_mensajeerror);

    if av_error <> '0' then
           if av_error = 'X' then
              an_iderror :=-1;
       else
              an_iderror := av_error;
       end if;
       raise e_error;
    end if;
    -- Ini 5.0
     UPDATE operacion.agendamiento a
       SET a.flg_relanzar = 1
     WHERE a.idagenda = an_agenda;
    end if;
    -- Fin 5.0
    end if;
    end if; -- fin 18.0
    commit;

  EXCEPTION
    WHEN e_error then
         p_insertar_log_error_ws_adc('Asigna Contrata',
                                     an_agenda,
                                     an_iderror,
                                     av_mensajeerror);

         rollback;
    --fin 3.0
    WHEN OTHERS THEN
      an_iderror      := -1;
      av_mensajeerror := '[operacion.pq_adm_cuadrilla.p_asignacontrata_adc] Se genero el error: ' ||
                         sqlerrm || '.';
      rollback;
   --fin 4.0
  END;
  /******************************************************************************
  Ver        Date        Author           Descripcion
  ---------  ----------  ---------------  ------------------------------------
  1.0        11/06/2015  Jorge Rivas      Devuelve la estructura XML de un metodo de la tabla
                                          operacion.ope_cab_xml
  ******************************************************************************/
  FUNCTION f_obtener_xml(ab_xml     CLOB,
                         av_metodo  VARCHAR2,
                         av_origen  VARCHAR2,
                         av_destino VARCHAR2) RETURN CLOB IS
    lb_xml CLOB;
  BEGIN
    IF ab_xml IS NULL THEN
      SELECT XML
        INTO lb_xml
        FROM operacion.ope_cab_xml
       WHERE metodo = av_metodo;
    ELSE
      lb_xml := ab_xml;
    END IF;

    lb_xml := REPLACE(lb_xml, av_origen, av_destino);
    RETURN lb_xml;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN NULL;
  END f_obtener_xml;

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        09/06/2015  Jorge Rivas      Retorna zona si plano o centro poblado tiene flujo adc
  2.0        08/08/2016  Justiniano       Se consulta el parametro de obligatoriedad de agendamiento por
                         Condori          interface
  ******************************************************************************/
  PROCEDURE p_valida_flujo_zona_adc(as_origen  IN varchar2,
                                    av_idplano IN marketing.vtatabgeoref.idplano%TYPE,
                                    av_ubigeo  IN VARCHAR2,
                                    an_tiptra  IN operacion.matriz_tystipsrv_tiptra_adc.tiptra%TYPE,
                                    an_tipsrv  IN operacion.matriz_tystipsrv_tiptra_adc.tipsrv%TYPE,
                                    as_codzona OUT operacion.zona_adc.codzona%TYPE,
                                    an_indica  OUT NUMBER) IS
    ln_flg_adc   NUMBER;
    ln_indicador NUMBER;
    ln_idzona    NUMBER;
    ln_flg_zona  NUMBER;
    ls_codzona   operacion.zona_adc.codzona%TYPE;
    ln_flg_aobliga number; -- 2.0
  BEGIN
    an_indica := 0;

    -- validar plano / centro poblado --
    IF av_idplano IS NOT NULL THEN
      BEGIN
        SELECT DISTINCT flg_adc, idzona
          INTO ln_flg_adc, ln_idzona
          FROM marketing.vtatabgeoref
         WHERE idplano = av_idplano;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          an_indica  := -1;
          as_codzona := NULL;
          -- Plano enviado no existe
          RETURN;
      END;
    ELSE
      IF av_ubigeo IS NOT NULL THEN
        BEGIN

          SELECT flag_adc, idzona
            INTO ln_flg_adc, ln_idzona
            FROM pvt.tabpoblado@dbl_pvtdb
           WHERE idubigeo || codclasificacion = av_ubigeo;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            an_indica  := -2;
            as_codzona := NULL;
            -- centro poblado no existe
            return;
        END;
      else
        -- Debe enviarse plano o centro poblado
        an_indica  := -3;
        as_codzona := NULL;
        return;
      end if;
    end if;

    if nvl(ln_flg_adc, 0) = '1' then
      -- validar zona --
      BEGIN
        SELECT codzona, z.estado
          INTO ls_codzona, ln_flg_zona
          FROM operacion.zona_adc z
         WHERE idzona = ln_idzona;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          -- zona configurada no existe --
          an_indica  := -4;
          as_codzona := NULL;
          RETURN;
      END;
      -- zona desactivada --
      if ln_flg_zona = 0 then
        as_codzona := ls_codzona;
        an_indica  := 0;
        return;
      end if;
    else
      as_codzona := NULL;
      an_indica  := 0;
      return;
    end if;

    IF an_tiptra IS NULL THEN
      -- tipo de trabajo es nulo
      as_codzona := NULL;
      an_indica  := -5;
      return;
    END IF;

    IF an_tipsrv IS NULL THEN
      -- codigo de tipo de servicio es nulo
      as_codzona := NULL;
      an_indica  := -6;
      return;
    END IF;

    if as_origen IS NULL THEN
      -- origen es nulo
      as_codzona := NULL;
      an_indica  := -7;
      return;
    END IF;

    -- V : Modulo de Ventas / P : Modulo de Post-Venta / O : Modulo de Operaciones --
    BEGIN
      SELECT distinct decode(as_origen,
                             'V',
                             d.con_cap_v,
                             'P',
                             d.con_cap_p,
                             'O',
                             d.con_cap_o), --2.0
             d.flgaobliga --2.0
        INTO ln_indicador,ln_flg_aobliga --2.0
        FROM operacion.matriz_tystipsrv_tiptra_adc D
       WHERE tipsrv = an_tipsrv
         AND tiptra = an_tiptra
         and estado = 1;

    -- Ini 2.0
    if ln_indicador=0 and ln_flg_aobliga=0 then
      ln_indicador:=0;
    elsif ln_indicador=1 and ln_flg_aobliga=0 then
      ln_indicador:=1;
    elsif ln_indicador=1 and ln_flg_aobliga=1 then
      ln_indicador:=2;
    end if;
    -- Fin 2.0
      as_codzona := ls_codzona;
      an_indica  := ln_indicador;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        as_codzona := NULL;
        an_indica  := 0;
    END;

  END p_valida_flujo_zona_adc;
 /******************************************************************************
    Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        14/08/2015  Nalda Arotinco   Valida el flujo por motivo
  2.0        08/08/2016  Justiniano       Obligacion de Agendamiento
                         Condori
  ******************************************************************************/
  PROCEDURE p_valida_flujo_mot_adc(as_origen   IN VARCHAR2,
                                   av_idplano  IN marketing.vtatabgeoref.idplano%TYPE,
                                   av_ubigeo   IN VARCHAR2,
                                   an_tiptra   IN operacion.matriz_tystipsrv_tiptra_adc.tiptra%TYPE,
                                   an_tipsrv   IN operacion.matriz_tystipsrv_tiptra_adc.tipsrv%TYPE,
                                   as_tipagen  IN operacion.matriz_tystipsrv_tiptra_adc.tipo_agenda%type,
                                   as_codmotot IN operacion.matriz_tiptratipsrvmot_adc.id_motivo%type,
                                   as_codzona  OUT operacion.zona_adc.codzona%type,
                                   an_indica   OUT NUMBER) IS
    ln_val_todos  number;
    ln_val_motivo number := 0;
    ln_idmatriz   operacion.matriz_tystipsrv_tiptra_adc.id_matriz%type;
    ls_tipoagenda operacion.matriz_tystipsrv_tiptra_adc.tipo_agenda%type;
    ln_val_agenda number := 0;
  begin

    p_valida_flujo_zona_adc(as_origen,
                            av_idplano,
                            av_ubigeo,
                            an_tiptra,
                            an_tipsrv,
                            as_codzona,
                            an_indica);

    if an_indica > 0 then --2.0
      -- VALIDAR POR TIPO DE AGENDA --
      begin
        SELECT 0
          INTO ln_val_agenda
          FROM OPERACION.MATRIZ_TYSTIPSRV_TIPTRA_ADC t
         WHERE t.tipsrv = an_tipsrv
           AND t.tiptra = an_tiptra
           and t.tipo_agenda = lv_todos
           AND t.estado = 1
           AND ROWNUM = 1;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          ln_val_motivo := 0;
          ln_val_agenda := 1;
        WHEN OTHERS THEN
          ln_val_motivo := 0;
          ln_val_agenda := 1;
      END;

      IF ln_val_agenda IS NULL then
        ln_val_agenda := 1;
      end if;

      if ln_val_motivo > 0 then
        ls_tipoagenda := lv_todos;
      else
        IF as_tipagen IS NULL THEN
          ls_tipoagenda := lv_todos;
        ELSE
          ls_tipoagenda := as_tipagen;
        END IF;
      end if;

      begin
        SELECT DISTINCT t.id_matriz, t.VALIDA_MOT, 1
          INTO ln_idmatriz, ln_val_motivo, ln_val_todos
          FROM OPERACION.MATRIZ_TYSTIPSRV_TIPTRA_ADC t
         WHERE t.tipsrv = an_tipsrv
           AND t.tiptra = an_tiptra
           and (t.tipo_agenda = ls_tipoagenda)
           AND t.estado = 1;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          ln_val_motivo := 0;
          ln_idmatriz   := NULL;
        WHEN DUP_VAL_ON_INDEX THEN
          ln_val_motivo := 0;
          ln_idmatriz   := NULL;
        WHEN OTHERS THEN
          ln_val_motivo := 0;
          ln_idmatriz   := NULL;
      END;

      if ln_val_motivo = 0 then
        if ln_val_agenda = 1 AND ln_idmatriz IS NULL then
          an_indica := 0;
        end if;
      else
        if ln_val_motivo = 1 then
          IF not as_codmotot is null THEN
            BEGIN
              select 1
                into an_indica
                from operacion.matriz_tiptratipsrvmot_adc dd
               where dd.id_matriz = ln_idmatriz
                 and dd.id_motivo = as_codmotot
                 and dd.estado = 1;

            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                an_indica := 0;
              WHEN DUP_VAL_ON_INDEX THEN
                an_indica := 0;

              WHEN OTHERS THEN
                an_indica := 0;
            END;
          ELSE
            an_indica := 0;
          END IF;
        end if;
      end if;
    end if;
  end;
  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        08/05/2015  Jorge Rivas      Devuelve una tabla con los codigos de subtipo de orden
  ******************************************************************************/
  PROCEDURE p_consulta_subtipord(av_cod_tipo_orden IN operacion.tipo_orden_adc.cod_tipo_orden%TYPE,
                                 p_cursor          OUT gc_salida) IS
  BEGIN
    OPEN p_cursor FOR
      SELECT s.cod_subtipo_orden,
             s.descripcion,
             s.id_work_skill,
             s.grado_dificultad,
             s.tiempo_min
        FROM operacion.subtipo_orden_adc s, operacion.tipo_orden_adc t
       WHERE s.estado = 1
         AND s.id_tipo_orden = t.id_tipo_orden
         AND t.cod_tipo_orden = av_cod_tipo_orden;
    RETURN;
  END p_consulta_subtipord;

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        21/05/2015  Jorge Rivas      Retorna la zona y plano
  ******************************************************************************/
  PROCEDURE p_retornar_zona_plano(av_idplano      IN marketing.vtatabgeoref.idplano%TYPE,
                                  av_ubigeo2      IN VARCHAR2,
                                  av_plano        OUT marketing.vtatabgeoref.idplano%TYPE,
                                  av_codzona      OUT operacion.zona_adc.codzona%TYPE,
                                  an_iderror      OUT NUMBER,
                                  av_mensajeerror OUT VARCHAR2) IS
    ln_idzona  marketing.vtatabgeoref.idzona%TYPE;
    ln_flg_adc number(1);
    e_error EXCEPTION;
    ln_valor number; --22.0
  BEGIN
    av_plano        := NULL;
    av_codzona      := NULL;
    an_iderror      := 0;
    av_mensajeerror := NULL;

    -- HFC
    IF av_idplano IS NOT NULL THEN
      BEGIN
         --Ini 22.0
         select t.valor
           into ln_valor
           from operacion.constante t
          where t.constante = 'ERR_GEN_SOT_TOA';

         if ln_valor = 1 then
            select distinct lpad(v.idplano, 10, '0'),
                            v.idzona,
                            v.flg_adc
              into av_plano,
                   ln_idzona,
                   ln_flg_adc
              from marketing.vtatabgeoref v
             where v.idplano = trim(av_idplano)
               and v.flg_adc = 1
               and v.estado = 1
               and exists
             (select 1 from operacion.zona_adc z where z.idzona = v.idzona);
         else
            SELECT DISTINCT lpad(idplano, 10, '0'), idzona, flg_adc
              INTO av_plano, ln_idzona, ln_flg_adc
              FROM marketing.vtatabgeoref
             WHERE idplano = trim (av_idplano);

            IF ln_idzona IS NULL and ln_flg_adc = 1 THEN
              av_mensajeerror := '[operacion.pq_adm_cuadrilla.p_retornar_zona_plano] La zona no se encuentra configurada en la tabla marketing.vtatabgeoref';
              RAISE e_error;
            END IF;
         end if;
         --Fin 22.0

        IF ln_flg_adc = 1 THEN
          BEGIN
            SELECT codzona
              INTO av_codzona
              FROM operacion.zona_adc
             WHERE idzona = ln_idzona;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              av_mensajeerror := '[operacion.pq_adm_cuadrilla.p_retornar_zona_plano] La zona no se encuentra configurada en la tabla zona_adc';
              RAISE e_error;
          END;
        END IF;

      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          av_mensajeerror := '[operacion.pq_adm_cuadrilla.p_retornar_zona_plano] La zona no se encuentra configurada en la tabla planos';
          RAISE e_error;

        WHEN DUP_VAL_ON_INDEX THEN
          av_mensajeerror := '[operacion.pq_adm_cuadrilla.p_retornar_zona_plano] Existen mas de un plano en diferentes ubigeo';
          RAISE e_error;
      END;

      -- DTH
    ELSE
      IF av_ubigeo2 IS NOT NULL THEN
        BEGIN

          SELECT idpoblado, flag_adc, idzona
            INTO av_plano, ln_flg_adc, ln_idzona
            FROM pvt.tabpoblado@dbl_pvtdb
           WHERE idubigeo || codclasificacion = av_ubigeo2;

          IF ln_idzona IS NULL and ln_flg_adc = 1 THEN
            av_mensajeerror := '[operacion.pq_adm_cuadrilla.p_retornar_zona_plano] La zona no se encuentra configurada en la tabla Tabpoblado(WEBUNI)';
            RAISE e_error;
          END IF;

          IF ln_flg_adc = 1 then
            BEGIN
              SELECT codzona
                INTO av_codzona
                FROM operacion.zona_adc
               WHERE idzona = ln_idzona;
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                av_mensajeerror := '[operacion.pq_adm_cuadrilla.p_retornar_zona_plano] La zona no se encuentra configurada en la tabla zona_adc';
                RAISE e_error;
            END;
          END IF;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            av_mensajeerror := '[operacion.pq_adm_cuadrilla.p_retornar_zona_plano] El centro poblado ' ||
                               av_ubigeo2 || ' no existe';
            RAISE e_error;
        END;
      ELSE
        av_mensajeerror := '[operacion.pq_adm_cuadrilla.p_retornar_zona_plano] El ubigeo y centro poblado no pueden ser nulos';
        RAISE e_error;
      END IF;
    END IF;

  EXCEPTION
    WHEN e_error THEN
      an_iderror := 1;

    WHEN OTHERS THEN
      an_iderror      := -1;
      av_mensajeerror := '[operacion.pq_adm_cuadrilla.p_retornar_zona_plano] Se genero error: ' ||
                         sqlerrm || '.';

  END p_retornar_zona_plano;

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        16/06/2015  Jorge Rivas      inserta log de errores
  ******************************************************************************/
  PROCEDURE p_insertar_log_error_ws_adc(av_tipo_trs     operacion.log_error_ws_adc.tipo_trs%TYPE,
                                        av_idagenda     operacion.log_error_ws_adc.idagenda%TYPE,
                                        av_iderror      operacion.log_error_ws_adc.iderror%TYPE,
                                        av_mensajeerror operacion.log_error_ws_adc.mensajeerror%TYPE) IS
    PRAGMA AUTONOMOUS_TRANSACTION;
    lv_ip operacion.log_error_ws_adc.ip%TYPE;
  BEGIN
    SELECT sys_context('userenv', 'ip_address') INTO lv_ip FROM dual;

    INSERT INTO operacion.log_error_ws_adc
      (tipo_trs, idagenda, iderror, mensajeerror, ip, feccrea, usucrea)
    VALUES
      (av_tipo_trs,
       av_idagenda,
       av_iderror,
       av_mensajeerror,
       lv_ip,
       SYSDATE,
       USER);
    COMMIT;
  END p_insertar_log_error_ws_adc;

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        17/06/2015  Jorge Rivas      obtiene tag desde la trama ingresada
  ******************************************************************************/
  FUNCTION f_obtener_tag(av_tag VARCHAR2, av_trama CLOB) RETURN VARCHAR2 IS
    lv_rpta CLOB;
    lv_retn VARCHAR2(1000);
  BEGIN
    IF INSTR(av_trama, av_tag) = 0 THEN
      RETURN '';
    END IF;

    lv_rpta := SUBSTR(av_trama, INSTR(av_trama, av_tag), LENGTH(av_trama));
    lv_rpta := SUBSTR(lv_rpta, INSTR(lv_rpta, '>') + 1, LENGTH(lv_rpta));
    lv_rpta := TRIM(SUBSTR(lv_rpta, 1, INSTR(lv_rpta, '<') - 1));
    lv_retn := lv_rpta;

    RETURN lv_retn;
  END f_obtener_tag;

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        17/06/2015  Jorge Rivas      Genera OT ADC
  ******************************************************************************/
  PROCEDURE p_genera_ot_adc(an_codsolot     IN operacion.agendamiento.codsolot%TYPE,
                            an_idagenda     IN operacion.agendamiento.idagenda%TYPE,
                            an_iderror      OUT NUMBER,
                            av_mensajeerror OUT VARCHAR2) IS
    lv_iderror VARCHAR2(10);
	ls_idbucket        varchar2(100);--35.0
    ln_idsubtipo       number(10);--35.0
    ls_codigosubtipo   varchar2(10);--35.0
    an_id_error        NUMBER;--35.0
    av_mensaje_error   VARCHAR2(300);--35.0
    ln_nro_toa         number;--35.0
  BEGIN
    an_iderror      := 0;
    av_mensajeerror := NULL;

    p_crear_ot_wf(an_idagenda, lv_iderror, av_mensajeerror);

    an_iderror := to_number(lv_iderror);
	
	 --ini 35.0  
 if an_iderror=0 or an_iderror=-1000  then
        select count (restv_nro_orden)
          into ln_nro_toa
          from OPERACION.SGAT_RESERVA_TOA
         where RESTN_NRO_SOLOT = an_codsolot
           AND RESTN_ESTADO = 2; 
             if ln_nro_toa = 1 then 
                    begin 
                          select idbucket, id_subtipo_orden
                          into ls_idbucket, ln_idsubtipo 
                           from  operacion.agendamiento 
                           where idagenda=an_idagenda;
                       
                      EXCEPTION
                      WHEN NO_DATA_FOUND THEN
                        an_iderror      := -1;
                        av_mensajeerror := '[operacion.pq_adm_cuadrilla.p_genera_ot_adc] no existe bucket o subtipo';
                        END;
                      begin
                      select cod_subtipo_orden
                        into ls_codigosubtipo
                        from operacion.subtipo_orden_adc
                       where id_subtipo_orden = ln_idsubtipo
                          and estado = 1;
                     EXCEPTION
                      WHEN NO_DATA_FOUND THEN
                        an_iderror      := -1;
                        av_mensajeerror := '[operacion.pq_adm_cuadrilla.p_genera_ot_adc] no existe bucket o subtipo';
                        END;
                        
                  OPERACION.PQ_ADM_CUADRILLA.P_ASIGNACONTRATA_ST (an_idagenda,ls_codigosubtipo,ls_idbucket,null,an_id_error,av_mensaje_error);
				  commit;
            end if;
 end if;  
  --fin 35.0  
  END p_genera_ot_adc;

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        25/06/2015  Jorge Rivas      Obtiene el flag de generacion de orden ADC
  ******************************************************************************/
  FUNCTION f_obtiene_flag_orden_adc(an_idagenda IN operacion.agendamiento.idagenda%TYPE)
    RETURN NUMBER IS
    ln_flg_orden_adc NUMBER;
  BEGIN
    SELECT nvl(flg_orden_adc, 0)
      INTO ln_flg_orden_adc
      FROM operacion.agendamiento
     WHERE idagenda = an_idagenda;

    RETURN ln_flg_orden_adc;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN 0;
  END;

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        30/07/2015  Jorge Rivas      Genera trama de capacidad desde una solot
  2.0        02/03/2016  Juan Gonzales    tipo de orden CE
  3.0        11/08/2016  Justiniano       Cambio en la validacion de servicio
                         Condori
  ******************************************************************************/
  PROCEDURE p_gen_trama_capacidad_solot(an_codsolot          operacion.solot.codsolot%type,
                                        av_cod_subtipo_orden operacion.subtipo_orden_adc.cod_subtipo_orden%type,
                                        ad_fecha             DATE,
                                        av_trama             OUT CLOB,
                                        Pv_xml               OUT CLOB,
                                        Pv_Mensaje_Repws     OUT VARCHAR2,
                                        Pn_Codigo_Respws     OUT NUMBER) is

    ln_dias                  number;
    lv_delimitador           varchar2(1) := '|';
    lv_separador             varchar2(1) := ';';
    lv_time_slot             varchar2(10) := '';
    lv_calculate_duration    varchar2(5);
    lv_calculate_travel_time varchar2(5);
    lv_calcule_work_skill    varchar2(5);
    lv_by_work_zone          varchar2(5);
    lv_cod_work_skill        operacion.work_skill_adc.cod_work_skill%type;
    lv_auditoria             varchar2(100);
    lv_ip                    varchar2(20);
    lv_fecha                 varchar2(20);
    lv_user                  varchar2(50) := user;
    lv_servicio              varchar2(100) := 'consultaCapacidadSGA';
    lv_plano                 marketing.vtatabgeoref.idplano%TYPE;
    lv_codzona               operacion.zona_adc.codzona%TYPE;
    lv_cod_tipo_orden        operacion.tipo_orden_adc.cod_tipo_orden%TYPE;
    lv_idplano               operacion.parametro_vta_pvta_adc.plano%TYPE;
    lv_centrop               operacion.parametro_vta_pvta_adc.idpoblado%TYPE;
    ln_tiptra                operacion.solot.tiptra%TYPE;
    lv_bucket                operacion.parametro_vta_pvta_adc.idbucket%TYPE;
    lv_codsuc                operacion.inssrv.codsuc%TYPE;
    e_error EXCEPTION;
    an_tipo                  number;--2.0
    lv_tecnologia            VARCHAR2(10); -- jorge
    --Inicio 23.0
    ln_activacion_campos     number;
    ln_activacion_flag_vip   number;
    ln_flag_vip_default      number;
    ln_flag_zona             operacion.zona_adc.flag_zona%type;
    ln_flag_vip              operacion.tipo_orden_adc.flg_cuota_vip%type;
    --Fin 23.0
  BEGIN
    BEGIN
      -- delete operacion.tmp_capacidad where id_agenda = an_idagenda;
      p_elimna_tmp_capacidad_solot(an_codsolot,
                                   Pn_Codigo_Respws,
                                   Pv_Mensaje_Repws);

      IF Pn_Codigo_Respws = -1 THEN
        RAISE e_error;
      END IF;

      IF ad_fecha IS NULL THEN
        Pv_Mensaje_Repws := '[operacion.pq_adm_cuadrilla.p_gen_trama_capacidad_solot] La Fecha a consultar no es Valida';
        RAISE e_error;
      END IF;

      SELECT sys_context('userenv', 'ip_address') into lv_ip from dual;
      SELECT to_char(sysdate, 'YYYYMMDDHH24MI') into lv_fecha from dual;

      lv_auditoria := lv_fecha || lv_delimitador || lv_ip || lv_delimitador ||
                      lv_aplicacion || lv_delimitador || lv_user ||
                      lv_delimitador;

      ln_dias := f_obtiene_cant_dias(Pn_Codigo_Respws, Pv_Mensaje_Repws);

      IF ln_dias = 0 THEN
        RAISE e_error;
      END IF;

      lv_calculate_duration := f_obtiene_calculate_duration(Pn_Codigo_Respws,
                                                            Pv_Mensaje_Repws);

      IF lv_calculate_duration IS NULL OR lv_calculate_duration = '' THEN
        RAISE e_error;
      END IF;

      lv_calculate_travel_time := f_obtiene_calculate_travel(Pn_Codigo_Respws,
                                                             Pv_Mensaje_Repws);

      IF lv_calculate_travel_time IS NULL OR lv_calculate_travel_time = '' THEN
        RAISE e_error;
      END IF;

      lv_calcule_work_skill := f_obtiene_calcule_work_skill(Pn_Codigo_Respws,
                                                            Pv_Mensaje_Repws);

      IF lv_calcule_work_skill IS NULL OR lv_calcule_work_skill = '' THEN
        RAISE e_error;
      END IF;

      lv_by_work_zone := f_obtiene_by_work_zone(Pn_Codigo_Respws,
                                                Pv_Mensaje_Repws);

      IF lv_by_work_zone IS NULL OR lv_by_work_zone = '' THEN
        RAISE e_error;
      END IF;

      av_trama := to_char(ad_fecha, 'YYYY-MM-DD');

      FOR i IN 1 .. ln_dias LOOP
        av_trama := av_trama || lv_separador ||
                    to_char((ad_fecha + i), 'YYYY-MM-DD');
      END LOOP;

      BEGIN
        SELECT tiptra
          INTO ln_tiptra
          FROM solot s
         WHERE codsolot = an_codsolot;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          Pv_Mensaje_Repws := '[operacion.pq_adm_cuadrilla.p_gen_trama_capacidad_solot] Codigo de solicitud trabajo no existe en SOLOT <' ||
                              an_codsolot || '>';
          RAISE e_error;
      END;

      IF ln_tiptra IS NULL OR ln_tiptra = 0 THEN
        Pv_Mensaje_Repws := '[operacion.pq_adm_cuadrilla.p_gen_trama_capacidad_solot] Codigo de tipo trabajo es nulo en SOLOT <' ||
                            an_codsolot || '>';
        RAISE e_error;
      END IF;

      -- ini 2.0
      p_obtener_zona_plano( an_codsolot,
                            lv_centrop,
                            lv_idplano,
                            lv_tecnologia,
                            Pn_Codigo_Respws,
                            Pv_Mensaje_Repws
                          );
      -- fin 2.0

      lv_bucket := null; -- se setea en nulo
      p_retornar_zona_plano(lv_idplano,
                            lv_centrop,
                            lv_plano,
                            lv_codzona,
                            Pn_Codigo_Respws,
                            Pv_Mensaje_Repws);

      -- Ini 2.0
      p_tipo_x_tiposerv(an_codsolot, an_tipo, Pn_Codigo_Respws, Pv_Mensaje_Repws);
      if an_tipo = 0 then
      RAISE e_error;
      END if;
      if  an_tipo = 2 then
          lv_cod_tipo_orden := f_obtiene_tipoorden_ce(ln_tiptra,
                                                      Pn_Codigo_Respws,
                                                      Pv_Mensaje_Repws);
      else
      -- Fin 2.0
         lv_cod_tipo_orden := f_obtiene_tipoorden(ln_tiptra,
                                                  --an_codsolot, 2.0 emma
                                                  Pn_Codigo_Respws,
                                                  Pv_Mensaje_Repws);
      end if;--2.0
      IF lv_cod_tipo_orden IS NULL OR lv_cod_tipo_orden = '' THEN
        RAISE e_error;
      END IF;

      lv_cod_work_skill := f_obtiene_work_skill(av_cod_subtipo_orden,
                                                Pn_Codigo_Respws,
                                                Pv_Mensaje_Repws);
      IF lv_cod_work_skill IS NULL OR lv_cod_work_skill = '' THEN
        RAISE e_error;
      END IF;

      av_trama := av_trama || lv_delimitador || lv_bucket || lv_delimitador; -- bucket
      av_trama := av_trama || lv_calculate_duration || lv_delimitador; -- calculate_duration
      av_trama := av_trama || lv_calculate_travel_time || lv_delimitador; -- calculate_travel_time
      av_trama := av_trama || lv_calcule_work_skill || lv_delimitador; -- calculate_work_skill
      av_trama := av_trama || lv_by_work_zone || lv_delimitador; --determine_location_by_work_zone
      av_trama := av_trama || lv_time_slot || lv_delimitador; -- time_slot

      IF lv_calcule_work_skill = 'false' THEN
        av_trama := av_trama || lv_cod_work_skill; -- work_skill
      END IF;

      IF lv_by_work_zone = 'true' THEN
        IF lv_codzona is null or lv_codzona = '' THEN
          Pv_Mensaje_Repws := '[operacion.pq_adm_cuadrilla.p_gen_trama_capacidad_solot] La Zona a Consultar es Nula Por favor Verificar';
          RAISE e_error;
        END IF;

        IF lv_plano IS NULL OR lv_plano = '' THEN
          Pv_Mensaje_Repws := '[operacion.pq_adm_cuadrilla.p_gen_trama_capacidad_solot] El Plano a Consultar es Nulo Por favor Verificar';
          RAISE e_error;
        END IF;

        av_trama := av_trama || lv_delimitador || 'XA_Zone=' || lv_codzona ||
                    lv_separador; --name , value
        av_trama := av_trama || 'XA_Map=' || lv_plano; --name , value
      END IF;

      IF lv_calcule_work_skill = 'true' THEN
        IF lv_by_work_zone = 'true' THEN
          av_trama := av_trama || lv_separador;
        END IF;
        av_trama := av_trama || 'XA_WorkOrderSubtype=' ||
                    av_cod_subtipo_orden; --name , value
      END IF;

      --Inicio 23.0
      ln_activacion_campos := SGAFUN_OBTIENE_VALOR_CAMPO('activar_campos_consulta_capac',
                                                          Pn_Codigo_Respws,
                                                          Pv_Mensaje_Repws);

      IF ln_activacion_campos = 1 THEN   --Activacion de nuevos campos (Zona Compleja/Flag Vip)
        --Zona compleja
        ln_flag_zona  := SGAFUN_OBTIENE_ZONA_COMPLEJA(lv_codzona,
                                                 Pn_Codigo_Respws,
                                                 Pv_Mensaje_Repws);
        IF ln_flag_zona is null or ln_flag_zona = '' THEN
          RAISE e_error;
        END IF;

        av_trama := av_trama || lv_separador || 'XA_Zone_Complex=' || ln_flag_zona;
        --Obtener Flag Vip
        ln_activacion_flag_vip := SGAFUN_OBTIENE_VALOR_CAMPO('activar_flag_vip',
        Pn_Codigo_Respws,
                                                        Pv_Mensaje_Repws);
        IF ln_activacion_flag_vip is null or ln_activacion_flag_vip = '' THEN
          RAISE e_error;
        END IF;

        IF ln_activacion_flag_vip = 0 THEN  -- 0=desactivado , damos por defecto el 2=f_obtiene_flag_vip_default
            ln_flag_vip_default :=  SGAFUN_OBTIENE_VALOR_CAMPO('flag_vip_default',Pn_Codigo_Respws,Pv_Mensaje_Repws);
            av_trama := av_trama || lv_separador || 'XA_VIP_Flag =' || ln_flag_vip_default ;
        ELSE
           ln_flag_vip:= SGAFUN_OBTIENE_FLAG_VIP_ORD(av_cod_subtipo_orden,
                                                      Pn_Codigo_Respws,
                                                      pv_Mensaje_Repws);
            IF ln_flag_vip is null or ln_flag_vip = '' THEN
              RAISE e_error;
            END IF;
            av_trama := av_trama || lv_separador || 'XA_VIP_Flag=' || ln_flag_vip;
        END IF;
      END IF;
      --Fin 23.0

      av_trama := trim(lv_auditoria || av_trama);

      webservice.pq_obtiene_envia_trama_adc.P_WS_Consulta(an_codsolot,
                                                          NULL,
                                                          lv_servicio,
                                                          av_trama,
                                                          Pv_xml,
                                                          Pv_Mensaje_Repws,
                                                          Pn_Codigo_Respws);
    -- Ini 3.0
    Pv_Mensaje_Repws:=nvl(f_consulta_msj_x_msj(Pv_Mensaje_Repws),Pv_Mensaje_Repws);
    -- Fin 3.0
    EXCEPTION
      WHEN e_error THEN
        Pn_Codigo_Respws := -1;
        webservice.pq_obtiene_envia_trama_adc.p_inserta_transaccion_ws_adc(an_codsolot,
                                                                           NULL,
                                                                           lv_servicio,
                                                                           Pv_xml,
                                                                           Pv_xml,
                                                                           Pn_Codigo_Respws,
                                                                           Pv_Mensaje_Repws);
      WHEN OTHERS THEN
        Pn_Codigo_Respws := -1;
        Pv_Mensaje_Repws := Pv_Mensaje_Repws ||
                            '[operacion.pq_adm_cuadrilla.p_gen_trama_capacidad_solot] No se pudo Generar la Trama de Capacidad : ' ||
                            SQLERRM;
        webservice.pq_obtiene_envia_trama_adc.p_inserta_transaccion_ws_adc(an_codsolot,
                                                                           NULL,
                                                                           lv_servicio,
                                                                           Pv_xml,
                                                                           Pv_xml,
                                                                           Pn_Codigo_Respws,
                                                                           Pv_Mensaje_Repws);
    END;
  END;

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        31/07/2015  Jorge Rivas      Elimina datos en la tabla de capacidad desde una solot
  ******************************************************************************/
  PROCEDURE p_elimna_tmp_capacidad_solot(an_codsolot operacion.solot.codsolot%TYPE,
                                         an_error    OUT NUMBEr,
                                         av_error    OUT VARCHAR2) IS

  BEGIN
    an_error := 0;
    av_error := '';
    delete operacion.tmp_capacidad where codsolot = an_codsolot;
  EXCEPTION
    WHEN OTHERS THEN
      an_error := -1;
      av_error := '[operacion.pq_adm_cuadrilla.p_elimna_tmp_capacidad_solot] No se pudo Eliminar en la tabla tmp_capacidad ' ||
                  SQLERRM;
  END;

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        07/08/2015  Jorge Rivas      Insertar a la tabla operacion.parametro_vta_pvta_adc
  ******************************************************************************/
  PROCEDURE p_insertar_parm_vta_pvta_adc(an_codsolot         operacion.solot.codsolot%type,
                                         an_id_subtipo_orden operacion.subtipo_orden_adc.id_subtipo_orden%TYPE,
                                         ad_fecha            DATE,
                                         av_cod_franja       operacion.franja_horaria.codigo%TYPE,
                                         av_bucket           operacion.parametro_vta_pvta_adc.idbucket%TYPE,
                                         Pn_Codigo_Respws    OUT NUMBER,
                                         Pv_Mensaje_Repws    OUT VARCHAR2) IS
    lv_codsuc            operacion.inssrv.codsuc%TYPE;
    lv_centrop           marketing.vtasuccli.ubigeo2%TYPE;
    lv_idplano           marketing.vtasuccli.idplano%TYPE;  -- 2.0
    lv_tipo_tecnologia   VARCHAR2(10);                      -- 2.0
    lv_cod_subtipo_orden operacion.subtipo_orden_adc.cod_subtipo_orden%TYPE;
    e_error EXCEPTION;
  BEGIN
    Pn_Codigo_Respws := 0;
    Pv_Mensaje_Repws := '';

    SELECT DISTINCT i.codsuc
      INTO lv_codsuc
      FROM operacion.inssrv i
      JOIN operacion.solotpto p
        ON i.codinssrv = p.codinssrv
     WHERE p.codsolot = an_codsolot;

    IF lv_codsuc IS NULL OR lv_codsuc = '' THEN
      Pv_Mensaje_Repws := '[operacion.pq_adm_cuadrilla.p_insertar_parm_vta_pvta_adc] Codigo de sucursal a consultar es nulo, SOLOT <' ||
                          an_codsolot || '> por favor verificar';
      RAISE e_error;
    END IF;

    BEGIN
      SELECT ubigeo2, idplano      -- 2.0
        INTO lv_centrop, lv_idplano   -- 2.0
        FROM marketing.vtasuccli
       WHERE codsuc = lv_codsuc;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        Pv_Mensaje_Repws := '[operacion.pq_adm_cuadrilla.p_insertar_parm_vta_pvta_adc] Codigo de sucursal <' ||
                            lv_codsuc || '> no existe, por favor verificar';
        RAISE e_error;
    END;

  -- 2.0 INI
    lv_tipo_tecnologia := f_obtiene_tipo_tecnologia(an_codsolot, Pn_Codigo_Respws, Pv_Mensaje_Repws);
    IF Pn_Codigo_Respws <> 0 THEN
       RAISE e_error;
    END IF;

    IF lv_tipo_tecnologia = 'DTH' OR lv_tipo_tecnologia = 'LTE' THEN
    IF lv_centrop IS NULL OR lv_centrop = '' THEN
      Pv_Mensaje_Repws := '[operacion.pq_adm_cuadrilla.p_insertar_parm_vta_pvta_adc] Codigo de centro Poblado a consultar es nulo, por favor verificar';
      RAISE e_error;
    END IF;
        lv_idplano := NULL;
    ELSE
        IF lv_idplano IS NULL OR lv_idplano = '' THEN
          Pv_Mensaje_Repws := '[operacion.pq_adm_cuadrilla.p_insertar_parm_vta_pvta_adc] Codigo de centro Poblado a consultar es nulo, por favor verificar';
          RAISE e_error;
        END IF;
        lv_centrop := NULL;
    END IF;
  -- 2.0 FIN

    BEGIN
      SELECT cod_subtipo_orden
        INTO lv_cod_subtipo_orden
        FROM operacion.subtipo_orden_adc
       WHERE id_subtipo_orden = an_id_subtipo_orden;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        Pv_Mensaje_Repws := '[operacion.pq_adm_cuadrilla.p_insertar_parm_vta_pvta_adc] Codigo de subtipo de orden <' ||
                            an_id_subtipo_orden ||
                            '>, no existe, por favor verificar';
        RAISE e_error;
    END;

    IF lv_cod_subtipo_orden IS NULL OR lv_cod_subtipo_orden = '' THEN
      Pv_Mensaje_Repws := '[operacion.pq_adm_cuadrilla.p_insertar_parm_vta_pvta_adc] Codigo de subtipo de orden a consultar es nulo, por favor verificar';
      RAISE e_error;
    END IF;

    INSERT INTO operacion.parametro_vta_pvta_adc
      (codsolot, plano, idpoblado, subtipo_orden, fecha_progra, franja, idbucket)
    VALUES
      (an_codsolot,
       lv_idplano, -- 2.0
       lv_centrop,
       lv_cod_subtipo_orden,
       ad_fecha,
       av_cod_franja,
       av_bucket);
  EXCEPTION
    WHEN e_error THEN
      Pn_Codigo_Respws := -1;
      --INI 2.0
    WHEN dup_val_on_index THEN
      BEGIN
        UPDATE operacion.parametro_vta_pvta_adc
           SET idpoblado     = lv_centrop,
               subtipo_orden = lv_cod_subtipo_orden,
               fecha_progra  = ad_fecha,
               franja        = av_cod_franja,
               idbucket      = av_bucket
         WHERE codsolot = an_codsolot;
      EXCEPTION
        WHEN OTHERS THEN
          pn_codigo_respws := -1;
          pv_mensaje_repws := '[operacion.pq_adm_cuadrilla.p_insertar_parm_vta_pvta_adc] No se pudo actualizar la tabla operacion.parametro_vta_pvta_adc: ' ||
                              SQLERRM;
      END;
      --FIN 2.0
    WHEN OTHERS THEN
      Pn_Codigo_Respws := -1;
      Pv_Mensaje_Repws := '[operacion.pq_adm_cuadrilla.p_insertar_parm_vta_pvta_adc] No se pudo insertar en la tabla operacion.parametro_vta_pvta_adc: ' ||
                          SQLERRM;
  END;

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        06/08/2015  Jorge Rivas      Retorna la fecha maxima de la tabla temporal por solot
  ******************************************************************************/
  FUNCTION f_obtiene_max_fech_solot(an_codsolot operacion.solot.codsolot%type,
                                    ad_fecha    agendamiento.fecagenda%type)
    RETURN NUMBER IS
    n_retorna number;
  BEGIN

    n_retorna := 0;
    BEGIN

      select count(*)
        into n_retorna
        from (SELECT MAX(to_date(substr(tp.fecha, 1, 10), 'YYYY/MM/DD')) maxima,
                     min(to_date(substr(tp.fecha, 1, 10), 'YYYY/MM/DD')) minima
                FROM operacion.tmp_capacidad tp
               where codsolot = an_codsolot) tmp
       where ad_fecha between tmp.minima and tmp.maxima;

    EXCEPTION
      WHEN no_data_found THEN
        n_retorna := 0;
    END;

    RETURN n_retorna;
  END;

  /******************************************************************************
  Ver           Date          Author                   Descripcion
  ---------  ----------  ------------------ ----------------------------------------
  1.0        07/08/2014  Jorge Rivas        Retorna 1 si el cliente es corporativo
  ******************************************************************************/
  FUNCTION f_obtiene_tipo_cliente(av_codcli vtatabcli.codcli%TYPE)
    RETURN NUMBER IS
    lv_tipper vtatabcli.tipper%TYPE;
    ln_count  NUMBER;
  BEGIN
    BEGIN
      SELECT tipper INTO lv_tipper FROM vtatabcli WHERE codcli = av_codcli;
    EXCEPTION
      WHEN no_data_found THEN
        RETURN 0;
    END;

    BEGIN
      SELECT COUNT(nvl(d.codigoc, 0))
        INTO ln_count
        FROM operacion.parametro_det_adc d, operacion.parametro_cab_adc c
       WHERE d.estado = 1
         AND d.codigoc = lv_tipper
         AND d.id_parametro = c.id_parametro
         AND c.estado = 1
         AND c.abreviatura = 'DTH_CLIENTE_CORPORATIVO';
    EXCEPTION
      WHEN no_data_found THEN
        RETURN 0;
    END;

    IF ln_count > 0 THEN
      RETURN 1;
    ELSE
      RETURN 0;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN 0;
  END;

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        08/10/2015  Jorge Rivas      Devuelve una tabla con los codigos de subtipo de orden
  ******************************************************************************/
  PROCEDURE p_obtiene_subtipord(av_cod_tipo_orden IN operacion.tipo_orden_adc.cod_tipo_orden%TYPE,
                                an_servicio       IN operacion.subtipo_orden_adc.servicio%TYPE,
                                an_decos          IN operacion.subtipo_orden_adc.decos%TYPE,
                                p_cursor          OUT gc_salida) IS
  BEGIN
    OPEN p_cursor FOR
      SELECT s.id_subtipo_orden,
             s.descripcion,
             s.cod_subtipo_orden,
             s.id_work_skill,
             s.grado_dificultad,
             s.tiempo_min
        FROM operacion.subtipo_orden_adc s, operacion.tipo_orden_adc t
       WHERE s.decos = an_decos
         AND s.servicio = an_servicio
         AND s.estado = 1
         AND s.id_tipo_orden = t.id_tipo_orden
         AND t.cod_tipo_orden = av_cod_tipo_orden;
    RETURN;
  END p_obtiene_subtipord;

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        09/10/2015  Jorge Rivas      Devuelve parametros para tipo de orden HFCI
  ******************************************************************************/
  PROCEDURE p_obtener_parametros_HFCI(an_codsolot       IN operacion.solot.codsolot%TYPE,
                                      av_cod_tipo_orden OUT operacion.tipo_orden_adc.cod_tipo_orden%TYPE,
                                      an_servicio       OUT INTEGER,
                                      an_decos          OUT INTEGER) IS
    wv_servicio    VARCHAR(100);
    wv_abreviatura VARCHAR(100);
    wn_decos       INTEGER;
    wn_codigo_serv INTEGER;
    wn_codigo_deco INTEGER;

    CURSOR c_ IS
      SELECT DISTINCT pto.codsolot,
                      decode(i.estinssrv,
                             1,
                             'Activo',
                             2,
                             'Suspendido',
                             3,
                             'Cancelado',
                             4,
                             'Sin Activar') est_servicio,
                      CASE
                        WHEN i.tipinssrv = 3 THEN
                         'TLF'
                        WHEN i.tipinssrv = 1 AND
                             (nvl(i.bw, 0) = 0 OR i.bw = 1) THEN
                         'CTV'
                        WHEN i.tipinssrv = 1 AND i.bw > 100 THEN
                         'INT'
                      END servicio
        FROM inssrv i, solotpto pto, solot st, insprd p, tystabsrv s
       WHERE i.codinssrv = pto.codinssrv
         AND p.codinssrv = i.codinssrv
         AND s.codsrv = i.codsrv
         AND st.codsolot = pto.codsolot
         AND pto.codsolot = an_codsolot
       ORDER BY servicio;
  BEGIN
    BEGIN
      SELECT o.cod_tipo_orden
        INTO av_cod_tipo_orden
        FROM operacion.tipo_orden_adc o,
             operacion.tiptrabajo     t,
             operacion.solot          s
       WHERE o.tipo_tecnologia = 'HFC'
         AND o.id_tipo_orden = t.id_tipo_orden
         AND t.tiptra = s.tiptra
         AND s.codsolot = an_codsolot;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN;
    END;

    FOR r_ IN c_ LOOP
      IF r_.servicio IS NOT NULL THEN
        wv_servicio := wv_servicio || '-' || r_.servicio;
      END IF;
    END LOOP;
    IF wv_servicio IS NOT NULL THEN
      wv_servicio := SUBSTR(wv_servicio, 2, LENGTH(wv_servicio));
    ELSE
      RETURN;
    END IF;

    BEGIN
      SELECT SUM(p.cantidad)
        INTO wn_decos
        FROM tipequ t, solotptoequ s, solotpto p, solot o
       WHERE t.tipo = 'DECODIFICADOR'
         AND t.tipequ = s.tipequ
         AND s.punto = p.punto
         AND (s.idspcab IS NULL OR s.idspcab = 0)
         AND s.codsolot = p.codsolot
         AND p.codsolot = o.codsolot
         AND o.codsolot = an_codsolot;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        wn_decos := 0;
    END;

    BEGIN
      SELECT d.codigon
        INTO wn_codigo_serv
        FROM operacion.parametro_det_adc d, operacion.parametro_cab_adc c
       WHERE d.abreviatura = wv_servicio
         AND d.estado = 1
         AND d.id_parametro = c.id_parametro
         AND c.estado = 1
         AND c.abreviatura = 'HFC_ORDEN_SERVICIOS';
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        wn_codigo_serv := NULL;
    END;

    IF nvl(wn_decos, 0) <= 2 THEN
      wv_abreviatura := 'MENOR_IGUAL_2';
    ELSE
      wv_abreviatura := 'MAYOR_2';
    END IF;

    BEGIN
      SELECT d.codigon
        INTO wn_codigo_deco
        FROM operacion.parametro_det_adc d, operacion.parametro_cab_adc c
       WHERE d.abreviatura = wv_abreviatura
         AND d.estado = 1
         AND d.id_parametro = c.id_parametro
         AND c.estado = 1
         AND c.abreviatura = 'HFCI_ORDEN_DECOS';
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        wn_codigo_deco := 0;
    END;

    an_servicio := wn_codigo_serv;
    an_decos    := wn_codigo_deco;
  END p_obtener_parametros_HFCI;

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        06/11/2015  Jorge Rivas      Devuelve datos de parametro_vta_pvta_adc
  ******************************************************************************/
  PROCEDURE p_obtener_param_vta_pvta_adc(an_codsolot       IN operacion.solot.codsolot%TYPE,
                                         av_subtipo_orden  OUT operacion.parametro_vta_pvta_adc.subtipo_orden%TYPE,
                                         av_plano          OUT operacion.parametro_vta_pvta_adc.plano%TYPE,
                                         adt_fecha_progra  OUT operacion.parametro_vta_pvta_adc.fecha_progra%TYPE,
                                         av_franja         OUT operacion.parametro_vta_pvta_adc.franja%TYPE,
                                         an_fila           OUT INTEGER,
                                         av_cod_tipo_orden OUT operacion.tipo_orden_adc.cod_tipo_orden%TYPE,
                                         an_tiptra         OUT operacion.solot.tiptra%TYPE,
                                         an_flag           OUT INTEGER) IS
  BEGIN
    SELECT subtipo_orden,
           plano,
           fecha_progra,
           a.franja,
           fila,
           (SELECT aa.cod_tipo_orden
              FROM operacion.tipo_orden_adc    aa,
                   operacion.subtipo_orden_adc bb
             WHERE aa.id_tipo_orden = bb.id_tipo_orden
               AND bb.cod_subtipo_orden = subtipo_orden) id_tipo_orden,
           (SELECT tiptra FROM operacion.solot WHERE codsolot = a.codsolot) tiptra
      INTO av_subtipo_orden,
           av_plano,
           adt_fecha_progra,
           av_franja,
           an_fila,
           av_cod_tipo_orden,
           an_tiptra
      FROM operacion.parametro_vta_pvta_adc a,
           (SELECT d.abreviacion AS franja, ROWNUM fila
              FROM tipopedd c, opedd d
             WHERE c.abrev = 'etadirect'
               AND c.tipopedd = d.tipopedd
               AND d.descripcion = 'Franja Horaria') b
     WHERE b.franja = a.franja
       AND a.codsolot = an_codsolot;

    an_flag := 1;
  EXCEPTION
    WHEN no_data_found THEN
      an_flag := 0;
  END p_obtener_param_vta_pvta_adc;

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        11/01/2016  Jorge Rivas      Consulta capacidad desde una incidencia
  ******************************************************************************/
   PROCEDURE p_consulta_capacidad_incid_sga(an_codincidence      operacion.transaccion_ws_adc.codincidence%TYPE DEFAULT NULL,
                                            an_tiptra            operacion.tiptrabajo.tiptra%TYPE DEFAULT NULL,
                                            av_cod_subtipo_orden operacion.subtipo_orden_adc.cod_subtipo_orden%type,
                                            av_plano             marketing.vtatabgeoref.idplano%TYPE,
                                            p_fecha              DATE, -- Fecha de Consulta de Capacidad
                                            p_id_msj_err         OUT number,
                                            p_desc_msj_err       OUT VARCHAR2) IS
    v_trama CLOB;
    v_xml   CLOB;
  BEGIN
      p_gen_trama_capacidad_incid(an_codincidence,
                                  an_tiptra,
                                  av_cod_subtipo_orden,
                                  av_plano,
                                  p_fecha,
                                  v_trama,
                                  v_xml,
                                  p_desc_msj_err,
                                  p_id_msj_err);
  EXCEPTION
    WHEN OTHERS THEN
      p_id_msj_err   := -1;
      p_desc_msj_err := '[operacion.pq_adm_cuadrilla.p_consulta_capacidad_incid_sga] No se pudo Generar la Trama de Capacidad : ' ||
                        SQLERRM;
  END;

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        11/01/2016  Jorge Rivas      Genera trama de capacidad para incidencia
  2.0        11/08/2016  Justiniano       Cambio en la validacion de servicio
                         Condori
  ******************************************************************************/
  PROCEDURE p_gen_trama_capacidad_incid(an_codincidence       operacion.transaccion_ws_adc.codincidence%TYPE,
                                        an_tiptra             operacion.tiptrabajo.tiptra%TYPE,
                                        av_cod_subtipo_orden  operacion.subtipo_orden_adc.cod_subtipo_orden%TYPE,
                                        av_plano              marketing.vtatabgeoref.idplano%TYPE,
                                        ad_fecha              date,
                                        av_trama              out clob,
                                        Pv_xml                out clob,
                                        Pv_Mensaje_Repws      out varchar2,
                                        Pn_Codigo_Respws      Out number) is

      ln_dias                  number;
      lv_delimitador           varchar2(1) := '|';
      lv_separador             varchar2(1) := ';';
      lv_time_slot             varchar2(10) := '';
      lv_calculate_duration    varchar2(5);
      lv_calculate_travel_time varchar2(5);
      lv_calcule_work_skill    varchar2(5);
      lv_by_work_zone          varchar2(5);
      lv_cod_work_skill        operacion.work_skill_adc.cod_work_skill%type;
      lv_auditoria             varchar2(100);
      lv_ip                    varchar2(20);
      lv_fecha                 varchar2(20);
      lv_user                  varchar2(50) := user;
      lv_servicio              varchar2(100) := 'consultaCapacidadSGA';
      lv_plano                 marketing.vtatabgeoref.idplano%TYPE;
      lv_codzona               operacion.zona_adc.codzona%TYPE;
      lv_cod_tipo_orden        operacion.tipo_orden_adc.cod_tipo_orden%type;
      lv_idplano               operacion.parametro_vta_pvta_adc.plano%TYPE;
      lv_centrop               operacion.parametro_vta_pvta_adc.idpoblado%TYPE;
      lv_subtipo               operacion.parametro_vta_pvta_adc.subtipo_orden%type;
      ln_tiptra                operacion.solot.tiptra%type;
      lv_tipsrv                operacion.solot.tipsrv%type;
      lv_bucket                operacion.parametro_vta_pvta_adc.idbucket%TYPE;
      ln_dnitec                operacion.parametro_vta_pvta_adc.dni_tecnico%type;
      ld_fecha                 operacion.parametro_vta_pvta_adc.fecha_progra%type;
      lv_franja                operacion.parametro_vta_pvta_adc.franja%type;
      lv_indpp                 operacion.parametro_vta_pvta_adc.flg_puerta%type;
      lv_zona                  operacion.zona_adc.codzona%type;
      lv_tipo_tecnologia       operacion.tipo_orden_adc.tipo_tecnologia%TYPE;
      lv_aplicacion            VARCHAR2(20) := 'SGA';
      an_iderror               NUMBER;
      as_mensajeerror          VARCHAR(300);
      ln_codsuc                NUMBER;
      e_error exception;
      ll_flg_tipo_adc number;
      --Inicio 23.0
      ln_activacion_campos     number;
      ln_activacion_flag_vip   number;
      ln_flag_vip_default      number;
      ln_flag_zona             operacion.zona_adc.flag_zona%type;
      ln_flag_vip              operacion.tipo_orden_adc.flg_cuota_vip%type;
      --Fin 23.0
   BEGIN
      BEGIN
        DELETE operacion.tmp_capacidad WHERE codincidence = an_codincidence;

        ln_tiptra := an_tiptra;

        IF Pn_Codigo_Respws = -1 THEN
          raise e_error;
        END IF;

        IF ad_fecha is null THEN
          Pv_Mensaje_Repws := '[operacion.pq_adm_cuadrilla.p_gen_trama_capacidad] La Fecha a consultar No es Valida';
          raise e_error;
        END IF;

        lv_ip    := sys_context('userenv', 'ip_address');
        lv_fecha := to_char(SYSDATE, 'YYYYMMDDHH24MI');

        lv_auditoria := lv_fecha || lv_delimitador || lv_ip || lv_delimitador ||
                        lv_aplicacion || lv_delimitador || lv_user ||
                        lv_delimitador;

        ln_dias := operacion.pq_adm_cuadrilla.f_obtiene_cant_dias(Pn_Codigo_Respws, Pv_Mensaje_Repws);

        IF ln_dias = 0 THEN
          RAISE e_error;
        END IF;

        lv_calculate_duration := operacion.pq_adm_cuadrilla.f_obtiene_calculate_duration(Pn_Codigo_Respws,Pv_Mensaje_Repws);

        IF lv_calculate_duration is null or lv_calculate_duration = '' THEN
          RAISE e_error;
        END IF;

        lv_calculate_travel_time := operacion.pq_adm_cuadrilla.f_obtiene_calculate_travel(Pn_Codigo_Respws,Pv_Mensaje_Repws);

        IF lv_calculate_travel_time is null or lv_calculate_travel_time = '' THEN
          RAISE e_error;
        END IF;

        lv_calcule_work_skill := operacion.pq_adm_cuadrilla.f_obtiene_calcule_work_skill(Pn_Codigo_Respws,Pv_Mensaje_Repws);

        IF lv_calcule_work_skill is null or lv_calcule_work_skill = '' THEN
          RAISE e_error;
        END IF;

        lv_by_work_zone := operacion.pq_adm_cuadrilla.f_obtiene_by_work_zone(Pn_Codigo_Respws,Pv_Mensaje_Repws);

        IF lv_by_work_zone is null or lv_by_work_zone = '' THEN
          RAISE e_error;
        END IF;

        av_trama := to_char(ad_fecha, 'YYYY-MM-DD');

        --fecha
        FOR i IN 1 .. ln_dias LOOP
          av_trama := av_trama || lv_separador || to_char((ad_fecha + i), 'YYYY-MM-DD');
        END LOOP;

        SELECT DISTINCT v.ubigeo2 centrop, v.idplano --, v.codsuc
          INTO lv_centrop, lv_idplano
          FROM customerxincidence c, incidence ic, inssrv i, vtasuccli v
         WHERE c.codincidence     = ic.codincidence
           AND ic.codincidence    = an_codincidence
           AND c.servicenumber    = i.codinssrv
           AND i.codsuc           = v.codsuc(+);

        SELECT o.tipo_tecnologia
          INTO lv_tipo_tecnologia
          FROM operacion.tiptrabajo t, operacion.tipo_orden_adc o
         WHERE t.tiptra = ln_tiptra
           AND t.id_tipo_orden = o.id_tipo_orden(+);

        IF lv_tipo_tecnologia = 'DTH' THEN
          lv_idplano := NULL;
          IF lv_centrop IS NULL THEN
            an_iderror      := -1;
            as_mensajeerror := '[operacion.pq_adm_cuadrilla.p_obtiene_valores_adc] No se encontro Sucursal del cliente (Centro Poblado)  - Codigo de Sucursal  <' ||
                               ln_codsuc || '>, no existe en vtasuccli.';
            RAISE e_error;
          END IF;
        ELSE
          lv_centrop := NULL;
          IF lv_idplano IS NULL THEN
            an_iderror      := -1;
            as_mensajeerror := '[operacion.pq_adm_cuadrilla.p_obtiene_valores_adc] No se encontro Sucursal del cliente (Plano) Codigo de Sucursal  <' ||
                               ln_codsuc || '>, no existe en vtasuccli.';
            RETURN;
          END IF;
        END IF;


        --ETA FASE 3
        IF lv_tipo_tecnologia != 'DTH' THEN
          IF av_plano IS NOT NULL THEN
             lv_idplano := nvl(av_plano, lv_idplano );
          END IF;
        END IF;
        --ETA FASE 3

        lv_bucket := NULL; -- se setea en nulo
        operacion.pq_adm_cuadrilla.p_retornar_zona_plano(lv_idplano,
                              lv_centrop,
                              lv_plano,
                              lv_codzona,
                              Pn_Codigo_Respws,
                              Pv_Mensaje_Repws);

        ll_flg_tipo_adc := OPERACION.pq_adm_cuadrilla.f_tipo_x_titra_incid(ln_tiptra,an_codincidence);
        if ll_flg_tipo_adc = 2 then
          lv_cod_tipo_orden := operacion.pq_adm_cuadrilla.f_obtiene_tipoorden_ce(ln_tiptra,
                                                   Pn_Codigo_Respws,
                                                   Pv_Mensaje_Repws);
        else
          lv_cod_tipo_orden := operacion.pq_adm_cuadrilla.f_obtiene_tipoorden(ln_tiptra,
                                                 Pn_Codigo_Respws,
                                                 Pv_Mensaje_Repws);
       end if;

        IF lv_cod_tipo_orden IS NULL OR lv_cod_tipo_orden = '' THEN
          RAISE e_error;
        END IF;

        lv_cod_work_skill := operacion.pq_adm_cuadrilla.f_obtiene_work_skill(av_cod_subtipo_orden,
                                                  Pn_Codigo_Respws,
                                                  Pv_Mensaje_Repws);

        IF av_cod_subtipo_orden IS NULL OR av_cod_subtipo_orden = '' THEN
          Pn_Codigo_Respws := -1;
          Pv_Mensaje_Repws := '[operacion.pq_adm_cuadrilla.p_gen_trama_capacidad] No se pudo recuperar el SubTipo de Orden para la Agenda '; -- ||
                              --an_idagenda;
          RAISE e_error;
        END IF;

        IF lv_cod_work_skill IS NULL OR lv_cod_work_skill = '' THEN
          RAISE e_error;
        END IF;

        av_trama := av_trama || lv_delimitador || lv_bucket || lv_delimitador; -- bucket
        av_trama := av_trama || lv_calculate_duration || lv_delimitador; -- calculate_duration
        av_trama := av_trama || lv_calculate_travel_time || lv_delimitador; -- calculate_travel_time
        av_trama := av_trama || lv_calcule_work_skill || lv_delimitador; -- calculate_work_skill
        av_trama := av_trama || lv_by_work_zone || lv_delimitador; --determine_location_by_work_zone
        av_trama := av_trama || lv_time_slot || lv_delimitador; -- time_slot

        IF lv_calcule_work_skill = 'false' THEN
          av_trama := av_trama || lv_cod_work_skill; -- work_skill
        END IF;

        IF lv_by_work_zone = 'true' THEN
          IF lv_codzona IS NULL OR lv_codzona = '' THEN
            Pn_Codigo_Respws := -1;
            Pv_Mensaje_Repws := '[operacion.pq_adm_cuadrilla.p_gen_trama_capacidad] La Zona a Consultar es Nula Por favor Verificar';
            RAISE e_error;
          END IF;

          IF lv_plano IS NULL OR lv_plano = '' THEN
            Pn_Codigo_Respws := -1;
            Pv_Mensaje_Repws := '[operacion.pq_adm_cuadrilla.p_gen_trama_capacidad] El Plano a Consultar es Nulo Por favor Verificar';
            RAISE e_error;
          END IF;

          av_trama := av_trama || lv_delimitador || 'XA_Zone=' || lv_codzona || lv_separador; --name , value
          av_trama := av_trama || 'XA_Map=' || lv_plano; --name , value
        END IF;

        IF lv_calcule_work_skill = 'true' THEN
          IF lv_by_work_zone = 'true' THEN
            av_trama := av_trama || lv_separador;
          END IF;
          av_trama := av_trama || 'XA_WorkOrderSubtype=' || av_cod_subtipo_orden; --name , value
        END IF;

        --Inicio 23.0
        ln_activacion_campos := SGAFUN_OBTIENE_VALOR_CAMPO('activar_campos_consulta_capac',
                                                            Pn_Codigo_Respws,
                                                            Pv_Mensaje_Repws);

        IF ln_activacion_campos = 1 THEN   --Activacion de nuevos campos (Zona Compleja/Flag Vip)
          --Zona compleja
          ln_flag_zona  := SGAFUN_OBTIENE_ZONA_COMPLEJA(lv_codzona,
                                                   Pn_Codigo_Respws,
                                                   Pv_Mensaje_Repws);
          IF ln_flag_zona is null or ln_flag_zona = '' THEN
            RAISE e_error;
          END IF;

          av_trama := av_trama || lv_separador || 'XA_Zone_Complex=' || ln_flag_zona;
          --Obtener Flag Vip
          ln_activacion_flag_vip := SGAFUN_OBTIENE_VALOR_CAMPO('activar_flag_vip',
          Pn_Codigo_Respws,
                                                          Pv_Mensaje_Repws);
          IF ln_activacion_flag_vip is null or ln_activacion_flag_vip = '' THEN
            RAISE e_error;
          END IF;

          IF ln_activacion_flag_vip = 0 THEN  -- 0=desactivado , damos por defecto el 2=f_obtiene_flag_vip_default
              ln_flag_vip_default :=  SGAFUN_OBTIENE_VALOR_CAMPO('flag_vip_default',Pn_Codigo_Respws,Pv_Mensaje_Repws);
              av_trama := av_trama || lv_separador || 'XA_VIP_Flag =' || ln_flag_vip_default ;
          ELSE
             ln_flag_vip:= SGAFUN_OBTIENE_FLAG_VIP_ORD(av_cod_subtipo_orden,
                                                        Pn_Codigo_Respws,
                                                        pv_Mensaje_Repws);
              IF ln_flag_vip is null or ln_flag_vip = '' THEN
                RAISE e_error;
              END IF;
              av_trama := av_trama || lv_separador || 'XA_VIP_Flag=' || ln_flag_vip;
          END IF;
        END IF;
        --Fin 23.0
        av_trama := TRIM(lv_auditoria || av_trama);
        webservice.PQ_OBTIENE_ENVIA_TRAMA_ADC.p_ws_consulta_inc(NULL,
                                                            NULL,
                                                            lv_servicio,
                                                            av_trama,
                                                            Pv_xml,
                                                            Pv_Mensaje_Repws,
                                                            Pn_Codigo_Respws,
                                                            an_codincidence);
        -- Ini 2.0
        Pv_Mensaje_Repws:=nvl(f_consulta_msj_x_msj(Pv_Mensaje_Repws),Pv_Mensaje_Repws);
        -- Fin 2.0

      EXCEPTION
        WHEN e_error THEN
          Pn_Codigo_Respws := -1;
          webservice.PQ_OBTIENE_ENVIA_TRAMA_ADC.p_insert_transc_ws_adc_inc(NULL,
                                                                             NULL,
                                                                             lv_servicio,
                                                                             Pv_xml,
                                                                             Pv_xml,
                                                                             Pn_Codigo_Respws,
                                                                             Pv_Mensaje_Repws,
                                                                             an_codincidence);
        WHEN OTHERS THEN
          Pn_Codigo_Respws := -1;
          Pv_Mensaje_Repws := Pv_Mensaje_Repws ||
                              '[operacion.pq_adm_cuadrilla.p_gen_trama_capacidad] No se pudo Generar la Trama de Capacidad : ' ||
                              SQLERRM;
          webservice.PQ_OBTIENE_ENVIA_TRAMA_ADC.p_insert_transc_ws_adc_inc(NULL,
                                                                             NULL,
                                                                             lv_servicio,
                                                                             Pv_xml,
                                                                             Pv_xml,
                                                                             Pn_Codigo_Respws,
                                                                             Pv_Mensaje_Repws,
                                                                             an_codincidence);
      END;
  END;

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        24/01/2016  Jorge Rivas      Obtiene configuracion de parametros de incidencia
  ******************************************************************************/
  FUNCTION f_obtener_matriz_incidence_adc(an_codsubtype        operacion.matriz_incidence_adc.codsubtype%TYPE,
                                          an_codchannel        operacion.matriz_incidence_adc.codchannel%TYPE,
                                          an_codtypeservice    operacion.matriz_incidence_adc.codtypeservice%TYPE,
                                          an_codcase           operacion.matriz_incidence_adc.codcase%TYPE)
  RETURN NUMBER IS
  ln_count                NUMBER(8);
  lb_1                    BOOLEAN;
  lb_2                    BOOLEAN;
  lb_3                    BOOLEAN;
  lb_4                    BOOLEAN;
  BEGIN

  SELECT COUNT(*) INTO ln_count
    FROM operacion.matriz_incidence_adc
   WHERE estado = 1
     AND codsubtype       = an_codsubtype
     AND codchannel       = an_codchannel
     AND codtypeservice   = an_codtypeservice
     AND codcase          = an_codcase;

  IF ln_count > 0 THEN
    RETURN ln_count;
  ELSE
    ln_count := 0;
    FOR c IN  (SELECT codsubtype,
                      codchannel,
                      codtypeservice,
                      codcase
                 FROM operacion.matriz_incidence_adc
                WHERE estado = 1
              )
    LOOP
      lb_1 := (c.codsubtype IS NULL)        OR (c.codsubtype IS NOT NULL        AND c.codsubtype = an_codsubtype);
      lb_2 := (c.codchannel IS NULL)        OR (c.codchannel IS NOT NULL        AND c.codchannel = an_codchannel);
      lb_3 := (c.codtypeservice IS NULL)    OR (c.codtypeservice IS NOT NULL    AND c.codtypeservice = an_codtypeservice);
      lb_4 := (c.codcase IS NULL)           OR (c.codcase IS NOT NULL           AND c.codcase = an_codcase);

      IF lb_1 AND lb_2 AND lb_3 AND lb_4 THEN
         ln_count := 1;
         EXIT;
      END IF;
    END LOOP;
    RETURN ln_count;
  END IF;
  END;

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        25/01/2016  Jorge Rivas      Insertar en la tabla parametro_incidence_adc
  ******************************************************************************/
  PROCEDURE p_insertar_parm_incidence_adc(an_codincidence         operacion.parametro_incidence_adc.codincidence%type,
                                          av_subtipo_orden        operacion.parametro_incidence_adc.subtipo_orden%TYPE,
                                          ad_fecha_programacion   operacion.parametro_incidence_adc.fecha_programacion%TYPE,
                                          av_franja               operacion.parametro_incidence_adc.franja%TYPE,
                                          av_idbucket             operacion.parametro_incidence_adc.idbucket%TYPE,
                                          av_idplano              operacion.parametro_incidence_adc.plano%TYPE,
                                          p_resultado    OUT NUMBER,
                                          p_mensaje      OUT VARCHAR2) IS
  lv_ip     VARCHAR2(30);
  BEGIN
    SELECT sys_context('userenv', 'ip_address') INTO lv_ip FROM dual;

    DELETE FROM operacion.parametro_incidence_adc
     WHERE codincidence = an_codincidence;

    INSERT INTO operacion.parametro_incidence_adc
    (codincidence, plano, subtipo_orden, fecha_programacion, franja, idbucket, ipcre )
    VALUES
    (an_codincidence, av_idplano, av_subtipo_orden, ad_fecha_programacion, av_franja, av_idbucket, lv_ip );

    p_resultado := 1;
    p_mensaje   := '';
  EXCEPTION
      WHEN OTHERS THEN
        p_resultado := -1;
        p_mensaje   := substr('[operacion.pq_adm_cuadrilla.p_insertar_parametro_incidence_adc] Se genero el error: ' ||
                        ' idplano ('|| av_idplano ||'), idbucket ('||av_idbucket ||'), franja('||
                        av_franja ||'), subtipo_orden('||av_subtipo_orden ||')- Linea('|| dbms_utility.format_error_backtrace ||')' ||SQLERRM , 1, 2000);
        p_insertar_log_error_ws_adc('PARAMETRO_INCIDENCE_ADC',
                                    an_codincidence,
                                    p_resultado,
                                    p_mensaje);
  END;

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        26/01/2016  Jorge Rivas      Insertar en la tabla parm_vta_pvta_adc desde una incidencia
  ******************************************************************************/
  PROCEDURE p_insertar_vta_pvta_adc_inc(an_codincidence operacion.parametro_incidence_adc.codincidence%type,
                                        an_codsolot     operacion.solot.codsolot%TYPE,
                                        p_resultado     OUT NUMBER,
                                        p_mensaje       OUT VARCHAR2) IS

  lv_subtipo_orden        operacion.parametro_incidence_adc.subtipo_orden%TYPE;
  ld_fecha_programacion   operacion.parametro_incidence_adc.fecha_programacion%TYPE;
  lv_franja               operacion.parametro_incidence_adc.franja%TYPE;
  lv_idbucket             operacion.parametro_incidence_adc.idbucket%TYPE;
  ln_id_subtipo_orden     operacion.subtipo_orden_adc.id_subtipo_orden%TYPE;
  lv_codsuc               operacion.inssrv.codsuc%TYPE;
  lv_tipo_tecnologia      operacion.tipo_orden_adc.tipo_tecnologia%TYPE;
  lv_plano                operacion.parametro_incidence_adc.plano%TYPE;
  lv_idplano              operacion.parametro_incidence_adc.plano%TYPE;
  lv_centrop              marketing.vtasuccli.ubigeo2%TYPE;
  e_error                 EXCEPTION;
  BEGIN
    BEGIN
      SELECT subtipo_orden, fecha_programacion, franja, idbucket, plano
        INTO lv_subtipo_orden, ld_fecha_programacion, lv_franja, lv_idbucket, lv_plano
        FROM operacion.parametro_incidence_adc
       WHERE codincidence = an_codincidence;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        -- ini 21.0
        p_resultado := -10;
        p_mensaje := '[operacion.pq_adm_cuadrilla.p_insertar_vta_pvta_adc_inc] No existen registros en la tabla PARAMETRO_INCIDENCE_ADC para la Incidence : '||an_codincidence;
        p_insertar_log_error_ws_adc('Disponibilidad Capacidad',
                                  an_codincidence,
                                  p_resultado,
                                  p_mensaje);
        RETURN;
      WHEN OTHERS THEN
        p_resultado := -10;
        p_mensaje := substr('[operacion.pq_adm_cuadrilla.p_insertar_vta_pvta_adc_inc] ' || SQLERRM, 1, 2000);
        p_insertar_log_error_ws_adc('Disponibilidad Capacidad',
                                  an_codincidence,
                                  p_resultado,
                                  p_mensaje);
        RETURN;
        --fin 21.0
    END;

    BEGIN
      select codsuc
        INTO lv_codsuc from (SELECT i.codsuc
        FROM inssrv i, customerxincidence c, incidence ic
       WHERE c.servicenumber = i.codinssrv
         AND c.codincidence  = ic.codincidence
         and c.customercode = i.codcli
         AND ic.codincidence = an_codincidence
          order by  i.numslc desc)
          where rownum = 1;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
      p_mensaje := '[operacion.pq_adm_cuadrilla.p_insertar_vta_pvta_adc_inc] Codigo de sucursal no existe, SOT <' ||
                          an_codsolot || '>, por favor verificar';
      RAISE e_error;
    END;

    IF lv_codsuc IS NULL OR lv_codsuc = '' THEN
      p_mensaje := '[operacion.pq_adm_cuadrilla.p_insertar_vta_pvta_adc_inc] Codigo de sucursal a consultar es nulo, SOLOT <' ||
                          an_codsolot || '>, por favor verificar';
      RAISE e_error;
    END IF;

    BEGIN
      SELECT ubigeo2, idplano
        INTO lv_centrop, lv_idplano
        FROM marketing.vtasuccli v, operacion.solot s
       WHERE v.codsuc   = lv_codsuc
         AND v.codcli   = s.codcli
         AND s.codsolot = an_codsolot;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        p_mensaje := '[operacion.pq_adm_cuadrilla.p_insertar_vta_pvta_adc_inc] Codigo de sucursal <' ||
                            lv_codsuc || '>, no existe, por favor verificar';
        RAISE e_error;
    END;

    lv_tipo_tecnologia := f_obtiene_tipo_tecnologia(an_codsolot, p_resultado, p_mensaje);
    IF p_resultado <> 0 THEN
       RAISE e_error;
    END IF;

    IF lv_tipo_tecnologia = 'DTH' THEN
        IF lv_centrop IS NULL OR lv_centrop = '' THEN
          p_mensaje := '[operacion.pq_adm_cuadrilla.p_insertar_vta_pvta_adc_inc] Codigo de centro Poblado a consultar es nulo, por favor verificar';
          RAISE e_error;
        END IF;
        lv_plano := NULL;
    ELSE
        lv_plano := nvl(lv_plano,lv_idplano);
        IF lv_plano IS NULL OR lv_plano = '' THEN
          p_mensaje := '[operacion.pq_adm_cuadrilla.p_insertar_vta_pvta_adc_inc] Codigo de plano a consultar es nulo, por favor verificar';
          RAISE e_error;
        END IF;
        lv_centrop := NULL;
    END IF;

    BEGIN
      SELECT id_subtipo_orden
        INTO ln_id_subtipo_orden
        FROM operacion.subtipo_orden_adc
       WHERE cod_subtipo_orden = lv_subtipo_orden;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
      p_mensaje := '[operacion.pq_adm_cuadrilla.p_insertar_vta_pvta_adc_inc] Codigo subtipo orden <' ||
                          lv_subtipo_orden || '> no existe, por favor verificar';
      RAISE e_error;
    END;

    BEGIN
      INSERT INTO operacion.parametro_vta_pvta_adc
        (codsolot, plano, idpoblado, subtipo_orden, fecha_progra, franja, idbucket)
      VALUES
        (an_codsolot,
         lv_plano,
         lv_centrop,
         lv_subtipo_orden,
         ld_fecha_programacion,
         lv_franja,
         lv_idbucket);
    EXCEPTION
      WHEN dup_val_on_index THEN
          UPDATE operacion.parametro_vta_pvta_adc
             SET idpoblado     = lv_centrop,
                 subtipo_orden = lv_subtipo_orden,
                 fecha_progra  = ld_fecha_programacion,
                 franja        = lv_franja,
                 idbucket      = lv_idbucket
           WHERE codsolot = an_codsolot;
      WHEN OTHERS THEN
          p_mensaje := '[operacion.pq_adm_cuadrilla.p_insertar_parm_vta_pvta_adc] No se pudo actualizar la tabla operacion.parametro_vta_pvta_adc: ' ||
                              SQLERRM;
          RAISE e_error;
    END;

    p_resultado := 1;
    p_mensaje   := '';
  EXCEPTION
      WHEN e_error THEN
        p_resultado := -1;
        raise_application_error(-20500, p_mensaje);

      WHEN OTHERS THEN
        p_resultado := -2;
        p_mensaje   := '[operacion.pq_adm_cuadrilla.p_insertar_vta_pvta_adc_inc] Se genero el error: ' ||
                       SQLERRM || '.';
        raise_application_error(-20500, p_mensaje);
  END;

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        03/01/2016  Jorge Rivas      Obtiene tipo de tecnologia para masivo
  ******************************************************************************/
  
  FUNCTION f_obtener_tipo_tecnologia(an_tiptra tiptrabajo.tiptra%TYPE)
    RETURN VARCHAR2 IS
  lv_tecnol operacion.tipo_orden_adc.tipo_tecnologia%TYPE;
  BEGIN
    BEGIN
      SELECT c.tipo_tecnologia
        INTO lv_tecnol
        FROM tiptrabajo b, operacion.tipo_orden_adc c
       WHERE b.id_tipo_orden = c.id_tipo_orden
         AND c.estado = 1
         AND b.tiptra = an_tiptra;

    EXCEPTION
      WHEN no_data_found THEN
           RETURN '';
    END;
    RETURN lv_tecnol;
  END;

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        19/12/2019  Romario Medina      Obtiene tipo de tecnologia en Claro empresas
  ******************************************************************************/
  --Ini 31.0  
  FUNCTION f_obtener_tipo_tecnologia_CE(an_tiptra tiptrabajo.tiptra%TYPE)
    RETURN VARCHAR2 IS
  lv_tecnol operacion.tipo_orden_adc.tipo_tecnologia%TYPE;
  BEGIN
    BEGIN
      SELECT c.tipo_tecnologia
        INTO lv_tecnol
        FROM tiptrabajo b, operacion.tipo_orden_adc c
       WHERE b.id_tipo_orden_ce = c.id_tipo_orden
         AND c.estado = 1
         AND b.tiptra = an_tiptra;

    EXCEPTION
      WHEN no_data_found THEN
           RETURN '';
    END;
    RETURN lv_tecnol;
  END;
  --Fin 31.0
  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        12/01/2016  Jorge Rivas      Obtiene tipo de tecnologia
  ******************************************************************************/
  PROCEDURE p_obtener_zona_plano
  ( an_codsolot operacion.solot.codsolot%TYPE,
    av_centrop    OUT marketing.vtasuccli.ubigeo2%TYPE,
    av_idplano    OUT marketing.vtasuccli.idplano%TYPE,
    av_tecnologia OUT VARCHAR2,
    an_error      OUT NUMBER,
    av_error      OUT VARCHAR2
  ) IS
    e_error EXCEPTION;

    CURSOR c_ IS
    SELECT DISTINCT v.ubigeo2 centrop, v.idplano
      FROM operacion.inssrv i, marketing.vtasuccli v, solotpto p, operacion.solot s
     WHERE i.codinssrv = p.codinssrv
       AND i.codcli    = v.codcli
       AND i.codsuc    = v.codsuc
       AND v.codcli    = s.codcli
       AND p.codsolot  = s.codsolot
       AND s.codsolot  = an_codsolot;
  BEGIN
    BEGIN
      av_tecnologia := f_obtiene_tipo_tecnologia(an_codsolot, an_error, av_error);

      FOR r_ IN c_ LOOP
        IF r_.centrop IS NOT NULL OR r_.idplano IS NOT NULL  THEN
          av_centrop := r_.centrop;
          av_idplano := r_.idplano;
          IF av_tecnologia = 'DTH' THEN
              IF av_centrop IS NULL OR av_centrop = '' THEN
                av_error := '[operacion.pq_adm_cuadrilla.p_obtener_zona_plano] Codigo de centro Poblado a consultar es nulo, por favor verificar';
                RAISE e_error;
              END IF;
              av_idplano := NULL;
              EXIT;
          ELSE
              IF av_idplano IS NULL OR av_idplano = '' THEN
                av_error := '[operacion.pq_adm_cuadrilla.p_obtener_zona_plano] Codigo de plano a consultar es nulo, por favor verificar';
                RAISE e_error;
              END IF;
              av_centrop := NULL;
              EXIT;
          END IF;
        END IF;
      END LOOP;
    EXCEPTION
        WHEN e_error THEN
          an_error := -1;

        WHEN OTHERS THEN
          an_error := -2;
          av_error := '[operacion.pq_adm_cuadrilla.p_obtener_zona_plano] Se genero el error: ' ||
                         SQLERRM || '.';
     END;
  END;
  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  2.0        26/02/2016  Jorge Rivas      Valida la disponibilidad de capacidad en ETA
  ******************************************************************************/
  PROCEDURE p_validar_disponibildad(
    an_idagenda  agendamiento.idagenda%TYPE,
    av_mensaje   OUT VARCHAR2,
    an_resultado Out NUMBER
  ) IS
  ln_codsolot          solot.codsolot%TYPE;
  lv_cod_subtipo_orden operacion.subtipo_orden_adc.cod_subtipo_orden%TYPE;
  lv_plano             operacion.parametro_vta_pvta_adc.plano%TYPE;
  lv_idpoblado         operacion.parametro_vta_pvta_adc.idpoblado%TYPE;
  lv_subtipo_orden     operacion.parametro_vta_pvta_adc.subtipo_orden%TYPE;
  ld_fecha_progra      operacion.parametro_vta_pvta_adc.fecha_progra%TYPE;
  lv_franja            operacion.parametro_vta_pvta_adc.franja%TYPE;
  lv_idbucket          operacion.parametro_vta_pvta_adc.idbucket%TYPE;
  lv_trama             CLOB;
  Pv_xml               CLOB;
  ln_disp              NUMBER;
  ln_limite            NUMBER;
  ln_disponible        NUMBER;
  ex_other             EXCEPTION;
  ex_no_data_found     EXCEPTION;
  BEGIN
    av_mensaje   := NULL;
    an_resultado := 1;
    BEGIN
      SELECT d.codigon
        INTO ln_disp
        FROM operacion.parametro_det_adc d, operacion.parametro_cab_adc c
       WHERE d.abreviatura = 'FLG_ORDEN_OT'
         AND d.id_parametro = c.id_parametro
         AND c.abreviatura = 'DISPONIBILIDAD_CAPACIDAD'
         AND d.estado = 1
         AND c.estado = 1;

      an_resultado := ln_disp;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        an_resultado := 0;
        RETURN;
      WHEN OTHERS THEN
        an_resultado := -96;
        RAISE ex_other;
    END;

    IF ln_disp = 0 THEN
       an_resultado := 0;
       RETURN;
    END IF;

    BEGIN
      SELECT p.codsolot, p.plano, p.idpoblado, p.subtipo_orden, p.fecha_progra, p.franja, p.idbucket
        INTO ln_codsolot, lv_plano, lv_idpoblado, lv_subtipo_orden, ld_fecha_progra, lv_franja, lv_idbucket
        FROM operacion.parametro_vta_pvta_adc p, operacion.agendamiento a
       WHERE p.codsolot = a.codsolot
         AND a.idagenda = an_idagenda;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        av_mensaje   := '[operacion.pq_adm_cuadrilla.p_validar_disponibildad] No existen datos en [operacion.parametro_vta_pvta_adc] para la agenda <'||an_idagenda||'>';
        RAISE ex_no_data_found;
      WHEN OTHERS THEN
        an_resultado := -2;
        RAISE ex_other;
    END;

    p_gen_trama_capacidad(ln_codsolot,
                          an_idagenda,
                          lv_subtipo_orden,
                          ld_fecha_progra,
                          lv_trama,
                          Pv_xml,
                          av_mensaje,
                          an_resultado);

    IF an_resultado < 0 THEN
       p_insertar_log_error_ws_adc('Disponibilidad Capacidad',
                                   an_idagenda,
                                   an_resultado,
                                   av_mensaje);
       RETURN;
    END IF;

    BEGIN
      SELECT operacion.pq_adm_cuadrilla.f_obtiene_disp_max AS limite,
             nvl(cap.disponible, 0) disponible
        INTO ln_limite, ln_disponible
        FROM operacion.franja_horaria f,
             (SELECT tp.espaciotiempo idfranja,
                     nvl(tp.disponible, 0) AS disponible,
                     tp.ubicacion AS ubicacion
                FROM operacion.tmp_capacidad tp
               WHERE to_date(substr(tp.fecha, 1, 10), 'YYYY/MM/DD') = ld_fecha_progra
                 AND tp.ubicacion = lv_idbucket
                 AND id_agenda = an_idagenda) cap
       WHERE f.codigo = lv_franja
         AND f.flg_ap_ctr = 1
         AND f.codigo = cap.idfranja;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        av_mensaje   := '[operacion.pq_adm_cuadrilla.p_validar_disponibildad] No existe capacidad para la agenda <'||an_idagenda||'>';
        RAISE ex_no_data_found;
      WHEN OTHERS THEN
        an_resultado := -96;
        RAISE ex_other;
    END;

    IF ln_disponible <= ln_limite THEN
      av_mensaje   := '[operacion.pq_adm_cuadrilla.p_validar_disponibildad] '||chr(13)||
                      'No se gener? la orden, debido a que el bucket no tiene cuota disponible.'||chr(13)||
                      'Franja: '||lv_franja||', '||chr(13)||
                      'Bucket: '||lv_idbucket||', '||chr(13)||
                      'Fecha: '||to_char(ld_fecha_progra,'dd/mm/yyyy')||'.';
      RAISE ex_no_data_found;
    END IF;

    av_mensaje   := NULL;
    an_resultado := 1;
  EXCEPTION
    WHEN ex_no_data_found THEN
      an_resultado := -96;

      UPDATE operacion.agendamiento a
         SET a.fecagenda        = NULL,
             a.idbucket         = NULL,
             a.rpt_adc          = NULL,
             a.id_subtipo_orden = NULL,
             a.flg_orden_adc    = NULL
       WHERE a.idagenda = an_idagenda;

      p_insertar_log_error_ws_adc('Disponibilidad Capacidad',
                                  an_idagenda,
                                  an_resultado,
                                  av_mensaje);
    WHEN ex_other THEN
      av_mensaje := '[operacion.pq_adm_cuadrilla.p_validar_disponibildad] Error al validar disponibilidad '||SQLERRM;
      p_insertar_log_error_ws_adc('Disponibilidad Capacidad',
                                  an_idagenda,
                                  an_resultado,
                                  av_mensaje);
  END p_validar_disponibildad;

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  3.0        08/05/2015  Jorge Rivas      Devuelve una tabla con los codigos de Centro Poblado (WEBUNI)
  4.0        14/05/2018  LQ               PROY-31513 TOA
  ******************************************************************************/
  PROCEDURE p_consulta_centro_poblado(pi_idpoblado         in string,
                                      pi_idubigeo          in string,
                                      pi_codclasificacion  in string,
                                      pi_clasificacion     in string,
                                      pi_codcategoria      in string,
                                      pi_categoria         in string,
                                      pi_idzona            in string,
                                      pi_descripcion       IN string,
                                      pi_flag_adc          IN string,
                                      pi_cobertura         IN string,
                                      pi_cobertura_lte     IN string,
                                      p_cursor            OUT gc_salida) IS
  BEGIN
    OPEN p_cursor FOR
    SELECT t.idpoblado, t.idubigeo, t.codclasificacion, t.clasificacion, t.codcategoria,
           t.categoria, t.idzona as idzona, za.descripcion as zona_des,
           t.flag_adc as flg_adc, t.cobertura, t.cobertura_lte
      FROM pvt.tabpoblado@dbl_pvtdb t,
           operacion.zona_adc za
      where t.idzona = za.idzona
        and t.idubigeo like ''||'%'||nvl(pi_idubigeo,''||'%'||'')
        and t.codclasificacion like ''||'%'||nvl(pi_codclasificacion,''||'%'||'')
        and t.clasificacion like ''||'%'||nvl(pi_clasificacion,''||'%'||'')||''||'%'||''
        and t.codcategoria like ''||'%'||nvl(pi_codcategoria,''||'%'||'')
        and t.categoria like ''||'%'||nvl(pi_categoria,''||'%'||'')||''||'%'||''
        and za.descripcion like ''||'%'||nvl(pi_descripcion,''||'%'||'')||''||'%'||''
        and trim(t.idzona) like nvl(pi_idzona,''||'%'||'')
        and trim(t.cobertura) like nvl(pi_cobertura,''||'%'||'')
        and trim(t.idpoblado) like nvl(pi_idpoblado,''||'%'||'')
        and trim(t.cobertura_lte) like nvl(pi_cobertura_lte,''||'%'||'')
        and trim(t.flag_adc) like nvl(pi_flag_adc,''||'%'||'');
    RETURN;
  END p_consulta_centro_poblado;

/******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  3.0        07/10/2016  Jorge Rivas      Devuelve tipo de orden y subtipo de orden
  ******************************************************************************/
  PROCEDURE SGASS_OBTDATOS_ORDEN
  (p_numslc             IN  sales.vtadetptoenl.numslc%TYPE,
   p_tiptra             OUT operacion.tiptrabajo.tiptra%TYPE,
   p_id_tipo_orden      OUT operacion.subtipo_orden_adc.id_tipo_orden%TYPE,
   p_cod_tipo_orden     OUT operacion.tipo_orden_adc.cod_tipo_orden%TYPE,
   p_id_subtipo_orden   OUT operacion.subtipo_orden_adc.id_subtipo_orden%TYPE,
   p_cod_subtipo_orden  OUT operacion.subtipo_orden_adc.cod_subtipo_orden%TYPE,
   p_resultado          OUT INTEGER,
   p_mensaje            OUT VARCHAR2) IS

  av_numslc             sales.vtadetptoenl.numslc%TYPE;
  wv_servicio           VARCHAR(100);
  wn_codigo_serv        INTEGER;
  wn_decos              INTEGER;
  wv_abreviatura        sales.crmdd.abreviacion%TYPE;
  wn_codigo_deco        INTEGER;
  wn_codigon            sales.crmdd.codigon%TYPE;
  wv_codigoc            sales.crmdd.codigoc%TYPE;
  wv_tipo_trabajo       sales.crmdd.abreviacion%TYPE;
  wv_id_subtipo_orden   operacion.subtipo_orden_adc.id_subtipo_orden%TYPE;
  wv_cod_subtipo_orden  operacion.subtipo_orden_adc.cod_subtipo_orden%TYPE;
  wn_tiptra             operacion.tiptrabajo.tiptra%TYPE;
  wn_id_tipo_orden      operacion.subtipo_orden_adc.id_tipo_orden%TYPE;
  wv_cod_tipo_orden     operacion.tipo_orden_adc.cod_tipo_orden%TYPE;

  CURSOR c_ IS
  SELECT DISTINCT t.tipsrv, d.descripcion servicio
    FROM crmdd d, tipcrmdd c, sales.tystabsrv t, sales.vtadetptoenl v
   WHERE t.tipsrv   = d.codigoc
     AND d.abreviacion = 'SERVICIO'
     AND d.tipcrmdd = c.tipcrmdd
     AND c.abrev    = 'PARM_ETA'
     AND t.codsrv   = v.codsrv
     AND v.numslc   = av_numslc
  ORDER BY 2;

  BEGIN
    p_resultado := 0;
    av_numslc := p_numslc;

    --Obtiene el Tipo de tecnologia por tipo de solucion
    BEGIN
      SELECT d.codigon, d.codigoc
        INTO wn_codigon, wv_codigoc
        FROM crmdd d, tipcrmdd c
       WHERE d.codigon IN
             ( SELECT a.idsolucion
                 FROM sales.vtatabslcfac a
                WHERE a.numslc= av_numslc
             )
         AND d.abreviacion IN ('ID_SOL_ETA','ID_SOL_ETA_HFC')
         AND d.tipcrmdd = c.tipcrmdd
         AND c.abrev    = 'PARM_ETA';
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        p_mensaje := 'Verificar configuracion de tipo de tecnologia';
        RETURN;
    END;
    --dbms_output.put_line(wv_codigoc);

    IF wv_codigoc = 'HFC' THEN
      --Obtener servicios para HFC
      FOR r_ IN c_ LOOP
        IF r_.servicio IS NOT NULL THEN
          wv_servicio := wv_servicio || '-' || r_.servicio;
        END IF;
      END LOOP;

      IF wv_servicio IS NOT NULL THEN
         wv_servicio := SUBSTR(wv_servicio, 2, LENGTH(wv_servicio));
      END IF;

      BEGIN
        SELECT d.codigon
          INTO wn_codigo_serv
          FROM operacion.parametro_det_adc d, operacion.parametro_cab_adc c
         WHERE d.abreviatura = wv_servicio
           AND d.estado = 1
           AND d.id_parametro = c.id_parametro
           AND c.estado = 1
           AND c.abreviatura = 'HFC_ORDEN_SERVICIOS';
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          p_mensaje := 'Verificar configuracion de servicios';
          wn_codigo_serv := 0;
      END;
      wv_tipo_trabajo := 'TIP_TRA_HFC';
    ELSE

      wv_tipo_trabajo := 'TIP_TRA_DTH';
    END IF;

    IF wv_codigoc = 'DTH' THEN
      BEGIN
        --DTH Total e Decos
         SELECT SUM(cantidad)
           INTO wn_decos
           FROM vtadetptoenl vtp
          WHERE vtp.numslc = av_numslc
            AND vtp.codequcom IN
                (SELECT codequcom
                   FROM operacion.equcomxope
                  WHERE tipequ IN (SELECT codigon
                                     FROM operacion.opedd d, operacion.tipopedd a
                                    WHERE d.descripcion = 'Tarjeta'
                                      AND d.tipopedd = a.tipopedd
                                      AND a.abrev = 'TIPEQU_DTH_CONAX'));
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          p_mensaje := 'Proyecto '||av_numslc||', sin total de decos DTH';
          RETURN;
      END;
    ELSE
      BEGIN
        --HFC Total e Decos
          SELECT SUM(cantidad)
            INTO wn_decos
            FROM vtadetptoenl vtp
           WHERE vtp.numslc = av_numslc
             AND vtp.codequcom IN
                 (SELECT codequcom
                    FROM operacion.equcomxope
                   WHERE tipequ IN (SELECT d.codigon
                                      FROM operacion.parametro_det_adc d,
                                           operacion.parametro_cab_adc c
                                     WHERE d.estado = '1'
                                       AND d.id_parametro = c.id_parametro
                                       AND c.estado = '1'
                                       AND c.abreviatura = 'DECOS_HFC'));
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          p_mensaje := 'Proyecto '||av_numslc||', sin total de decos HFC';
          RETURN;
      END;
    END IF;

    IF nvl(wn_decos, 0) <= 2 THEN
      wv_abreviatura := 'MENOR_IGUAL_2';
    ELSE
      wv_abreviatura := 'MAYOR_2';
    END IF;

    --Obtiene codigo de MENOR_IGUAL_2 / MAYOR_2
    BEGIN
      SELECT d.codigon
        INTO wn_codigo_deco
        FROM operacion.parametro_det_adc d, operacion.parametro_cab_adc c
       WHERE d.abreviatura = wv_abreviatura
         AND d.estado = 1
         AND d.id_parametro = c.id_parametro
         AND c.estado = 1
         AND c.abreviatura = 'HFCI_ORDEN_DECOS';
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        p_mensaje := 'Verificar configuracion de decos';
        wn_codigo_deco := 0;
        RETURN;
    END;

    --Obtiene el tipo de trabajo segun el tipo de tecnologia
    BEGIN
      SELECT d.codigon
        INTO p_tiptra
        FROM crmdd d, tipcrmdd c
       WHERE d.abreviacion = wv_tipo_trabajo
         AND d.tipcrmdd = c.tipcrmdd
         AND c.abrev = 'PARM_ETA';
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
      p_mensaje := 'Verificar configuracion de tipo de trabajo';
      RETURN;
    END;

    IF wv_codigoc = 'HFC' THEN
      BEGIN
        --HFC obtiene tipo y subtipo de orden
        SELECT s.id_subtipo_orden, s.cod_subtipo_orden, s.id_tipo_orden, o.cod_tipo_orden
          INTO P_id_subtipo_orden, P_cod_subtipo_orden, p_id_tipo_orden, p_cod_tipo_orden
          FROM operacion.subtipo_orden_adc s, operacion.tipo_orden_adc o, operacion.tiptrabajo t
         WHERE s.servicio      = wn_codigo_serv
           AND s.decos         = wn_codigo_deco
           AND s.id_tipo_orden = o.id_tipo_orden
           AND o.id_tipo_orden = t.id_tipo_orden
           AND t.tiptra        = p_tiptra;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          p_mensaje := 'Proyecto '||av_numslc||', HFC - sin tipo y subtipo de orden';
        RETURN;
      END;
    ELSE

      BEGIN
        --DTH obtiene tipo y subtipo de orden
        SELECT s.id_subtipo_orden, s.cod_subtipo_orden, s.id_tipo_orden, o.cod_tipo_orden
          INTO p_id_subtipo_orden, p_cod_subtipo_orden, p_id_tipo_orden, p_cod_tipo_orden
          FROM operacion.subtipo_orden_adc s, operacion.tipo_orden_adc o, operacion.tiptrabajo t
         WHERE s.decos         = wn_codigo_deco
           AND s.id_tipo_orden = o.id_tipo_orden
           AND o.id_tipo_orden = t.id_tipo_orden
           AND t.tiptra        = p_tiptra;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
        p_mensaje := 'Proyecto '||av_numslc||', DTH - sin tipo y subtipo de orden';
        RETURN;
      END;
    END IF;
    p_resultado := 1;

  EXCEPTION
    WHEN OTHERS THEN
      p_resultado := -1;
      p_mensaje   := '[operacion.pq_adm_cuadrilla.p_obtener_datos_orden] Se genero el error: ' ||
                     SQLERRM || '.';
  END;

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  3.0        13/10/2016  Jorge Rivas      Devuelve 1 si la solucion es tipo de cliente nuevo
  ******************************************************************************/
  FUNCTION SGAFUN_SOLCLIENTE_NUEVO(p_id_solucion IN sales.vtatabslcfac.idsolucion%TYPE)
  RETURN NUMBER IS
  wn_count INTEGER;
  BEGIN
      SELECT COUNT(1)
        INTO wn_count
        FROM crmdd d, tipcrmdd c
       WHERE d.codigon  = p_id_solucion
         AND d.abreviacion IN ('ID_SOL_ETA','ID_SOL_ETA_HFC')
         AND d.tipcrmdd = c.tipcrmdd
         AND c.abrev    = 'PARM_ETA';

      IF wn_count > 0 then
        RETURN 1;
      ELSE
        RETURN 0;
      END IF;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN 0;
    WHEN OTHERS THEN
      RETURN -1;
  END;


/******************************************************************************
  Ver           Date          Author                   Descripcion
  ---------  ----------  ------------------ ----------------------------------------
  1.0        25/05/2014  Justiniano Condori Cancelar las agendas asociadas a una SOT
  2.0        04/10/2016  Justiniano Condori
  ******************************************************************************/
  PROCEDURE p_cancelar_agendaxsot(p_sot       IN NUMBER,
                                  p_resultado OUT NUMBER, --2.0
                                  p_mensaje   OUT VARCHAR2) IS
    CURSOR c_agenda IS
      SELECT a.idagenda, a.estage
        FROM operacion.agendamiento a
       WHERE a.codsolot = p_sot;
  BEGIN
    FOR c1 IN c_agenda LOOP
      operacion.pq_agendamiento.p_chg_est_agendamiento(c1.idagenda,
                                                       5,
                                                       c1.estage,
                                                       'Cancelado por Anulacion de SOT: ' ||
                                                       p_sot);
    END LOOP;
    p_resultado := 1; --2.0
    p_mensaje   := 'Ok';
  EXCEPTION
    WHEN OTHERS THEN
      p_resultado := -1; --2.0
      p_mensaje   := '[operacion.pq_adm_cuadrilla.p_cancelar_agendaxsot] Se genero el error: ' ||
                     SQLERRM || '.';
      raise_application_error(p_resultado, p_mensaje);
  END;
  /******************************************************************************
  Ver           Date          Author                   Descripcion
  ---------  ----------  ------------------ ----------------------------------------
  1.0        26/05/2014                     Cargar Combo Tipo Trabajo
  ******************************************************************************/
  PROCEDURE p_lista_trabajo(p_cursor OUT gc_salida) IS
  BEGIN
    OPEN p_cursor FOR
      SELECT tiptra, descripcion FROM operacion.tiptrabajo ORDER BY tiptra;
  END p_lista_trabajo;
  /*Steve ini*/
  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        14/05/2015  Steve P.      Elimina Reg. Tabla tmp_capacidad
  ******************************************************************************/
  procedure p_elimna_tmp_capacidad(an_idagenda agendamiento.idagenda%type,
                                   an_error    out number,
                                   av_error    out varchar2) is
  begin
    an_error := 0;
    av_error := '';
    delete operacion.tmp_capacidad where id_agenda = an_idagenda;
  exception
    when others then
      an_error := -1;
      av_error := '[operacion.pq_adm_cuadrilla.p_elimna_tmp_capacidad] No se pudo Eliminar en la tabla tmp_capacidad ' ||
                  sqlerrm;
  end;

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        14/05/2015  Steve P.      Actualiza en la tabla trs_interface_iw para activacion equipos HFC
  ******************************************************************************/
  procedure p_actualiza_trs_interface_iw(an_idtrs  operacion.trs_interface_iw.idtrs%type,
                                         av_modelo operacion.trs_interface_iw.modelo%type,
                                         av_mac    operacion.trs_interface_iw.mac_address%type,
                                         av_ua     operacion.trs_interface_iw.unit_address%type,
                                         an_error  out number,
                                         av_error  out varchar2) is

  begin
    an_error := 0;
    av_error := '';

    update OPERACION.TRS_INTERFACE_IW
       set modelo = av_modelo, mac_address = av_mac, unit_address = av_ua
     where idtrs = an_idtrs;
  exception
    when others then

      av_error := '[operacion.pq_adm_cuadrilla.p_actualiza_trs_interface_iw] No se pudo Actualizar en la tabla TRS_INTERFACE_IW ' ||
                  sqlerrm;

  end;

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        14/05/2015  Steve P.     obtiene codigo de solot x id agenda
  ******************************************************************************/
  function f_obtiene_codsolotxagenda(an_idagenda agendamiento.idagenda%type)
    return number is

    ln_codsolot solot.codsolot%type;

  begin
    begin
      select codsolot
        into ln_codsolot
        from agendamiento
       where idagenda = an_idagenda;
    EXCEPTION
      WHEN no_data_found THEN
        ln_codsolot := 0;
    END;
    return ln_codsolot;
  end;

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        28/05/2015  Steve P.      OBTIENE DATOS IW PARA INSTALACION DE HFC
  ******************************************************************************/
  function f_datos_iw(av_cadena varchar2) return IW_SGA_BSCS is

    ISB IW_SGA_BSCS;

  begin
    ISB.lv_tip_interface := OPERACION.PQ_IW_SGA_BSCS.f_cadena(av_cadena,
                                                              '/',
                                                              2);
    ISB.ln_idproducto    := OPERACION.PQ_IW_SGA_BSCS.f_cadena(av_cadena,
                                                              '/',
                                                              3);
    ISB.lv_trs_prov_bscs := OPERACION.PQ_IW_SGA_BSCS.f_cadena(av_cadena,
                                                              '/',
                                                              1);
    ISB.lv_estado_bscs   := OPERACION.PQ_IW_SGA_BSCS.f_cadena(av_cadena,
                                                              '/',
                                                              4);
    ISB.lv_estado_iw     := OPERACION.PQ_IW_SGA_BSCS.f_cadena(av_cadena,
                                                              '/',
                                                              5);
    return ISB;

  end;

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        14/05/2015  Steve P.      Ontiene tipo de tecnologia
  2.0        29/02/2015  Juan G.       Tipo de Tecnologia para CE
  ******************************************************************************/
  function f_obtiene_tipo_tecnologia(an_codsolot solot.codsolot%type,
                                     an_error    out number,
                                     av_error    out varchar2)
    return varchar2 is

    lv_tecnol operacion.tipo_orden_adc.tipo_tecnologia%type;
    -- ini 2.0
    lv_tipsrv solot.tipsrv%type;
    ln_tipo   number;
    -- Fin 2.0
  begin
    an_error := 0;
    av_error := '';
        -- ini 2.0
    SELECT s.tipsrv
      INTO lv_tipsrv
      FROM solot s
     WHERE s.codsolot = an_codsolot;

    ln_tipo := f_tipo_x_tiposerv(lv_tipsrv);

    if ln_tipo = 2 then
      BEGIN
        select c.tipo_tecnologia
          into lv_tecnol
          from solot a, tiptrabajo b, operacion.tipo_orden_adc c
         where a.tiptra = b.tiptra
           and b.id_tipo_orden_ce = c.id_tipo_orden
           and a.codsolot = an_codsolot
           and c.estado = 1;

      EXCEPTION
        WHEN no_data_found THEN
          lv_tecnol := '';
          an_error  := -1;
          av_error  := '[operacion.pq_adm_cuadrilla.f_obtiene_tipo_tecnologia] La Configuracion de TIPO TECNOLOGIA CE No Existe ';
      END;
    ELSIF ln_tipo = 1 then
      --fin 2.0
      begin
        select c.tipo_tecnologia
          into lv_tecnol
          from solot a, tiptrabajo b, operacion.tipo_orden_adc c
         where a.tiptra = b.tiptra
           and b.id_tipo_orden = c.id_tipo_orden
           and a.codsolot = an_codsolot
           and c.estado = 1;

      EXCEPTION
        WHEN no_data_found THEN
          lv_tecnol := '';
          an_error  := -1;
          av_error  := '[operacion.pq_adm_cuadrilla.f_obtiene_tipo_tecnologia] La Configuracion de TIPO TECNOLOGIA No Existe ';
      END;
    END IF; -- 2.0
    return lv_tecnol;
  end;

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        14/05/2015  Steve P.         Instala Equipo HFC
  2.0        10/05/2016  Juan Gonzales    Incidencia SGA-SD-788452
  3.0        07/06/2016  Juan Gonzales    Incidencia SD-820645
  ******************************************************************************/
  procedure p_instala_equipo_HFC(an_idagenda   agendamiento.idagenda%type,
                                 av_modelo     operacion.trs_interface_iw.modelo%type,
                                 av_mac        operacion.trs_interface_iw.mac_address%type, --telefonia
                                 av_mta_mac_cm operacion.trs_interface_iw.mac_address%type, --internet
                                 av_invsn      operacion.trs_interface_iw.mac_address%type, --tv
                                 av_ua         operacion.trs_interface_iw.unit_address%type,
                                 av_categoria  operacion.inventario_em_adc.categoria%type,
                                 an_error      out number,
                                 av_error      out varchar2) is

    -- Ini 32.0
	av_trama            varchar2(32000);
    lv_cadena           varchar2(32000);
	-- Fin 32.0
    ln_cont             number;
    an_codsolot         solot.codsolot%type;
    ISB                 IW_SGA_BSCS;
    lv_emta             operacion.inventario_em_adc.categoria%type;
    lv_box              operacion.inventario_em_adc.categoria%type;
    ln_idestado         number := 1;
    ln_proceso          number := 3;
    lv_customer_id      solot.customer_id%type;
    lv_resultado        varchar2(4000);
    ln_cantidad         number := 1;
    lv_sendtocontroller varchar2(5) := 'TRUE';
    lv_proceso          varchar2(50); --4.0

    e_error exception;
  -- Ini 3.0
    c_id_telefono       constant varchar2(10) := '820';
    c_id_TV             constant varchar2(10) := '2020';
    c_id_internet       constant varchar2(10) := '620';

    CURSOR c_srv IS
     select codsolot,
            tr.id_interfase,
            tr.idtrs,
            tr.id_producto,
            tr.id_producto_padre
       from operacion.trs_interface_iw tr
      where codsolot = an_codsolot
        and ((lv_emta = av_categoria AND ID_INTERFASE = c_id_internet and
            tr.mac_address is null and rownum = 1) or
            (lv_box = av_categoria AND ID_INTERFASE = c_id_TV and
            tr.mac_address is null and rownum = 1))
     union
     select codsolot,
            tr.id_interfase,
            tr.idtrs,
            tr.id_producto,
            tr.id_producto_padre
       from operacion.trs_interface_iw tr
      where codsolot = an_codsolot
        and ((lv_emta = av_categoria AND ID_INTERFASE = c_id_telefono and
            tr.mac_address is null and rownum = 1) or
            (lv_box = av_categoria AND ID_INTERFASE = c_id_TV and
            tr.mac_address is null and rownum = 1));
     -- Fin 3.0

  begin
    an_error := 0;
    av_error := '';
  ln_cont := 0;   -- 3.0
    an_codsolot := f_obtiene_codsolotxagenda(an_idagenda);

    begin

      lv_emta := f_obtiene_cod_emta(an_error, av_error);

      if an_error = -1 then
        raise e_error;
      end if;

      lv_box := f_obtiene_cod_box(an_error, av_error);

      if an_error = -1 then
        raise e_error;
      end if;

      begin
        select customer_id
          into lv_customer_id
          from solot
         where codsolot = an_codsolot;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          lv_customer_id := '';
      end;

      if av_categoria = lv_emta then
        FOR r_srv IN c_srv LOOP
          if r_srv.id_interfase = '620' then
            --internet
            begin  -- 4.0
              intraway.pq_cont_hfcbscs.p_cont_actcm(ln_idestado,
                                                    lv_customer_id,
                                                    r_srv.id_producto,
                                                    ln_proceso,
                                                    an_codsolot,
                                                    av_mta_mac_cm,
                                                    lv_resultado,
                                                    av_error,
                                                    an_error);
            -- Ini 4.0
            exception
              when others then
                rollback;
            end;
            -- Ini 4.0

            if an_error = 0 then
              update OPERACION.TRS_INTERFACE_IW
                 set MODELO = av_modelo, MAC_ADDRESS = av_mta_mac_cm
               where idtrs = r_srv.idtrs;
               ln_cont := 1;  -- 3.0
            else --4.0
              lv_proceso:='intraway.pq_cont_hfcbscs.p_cont_actcm '; --2.0
            end if;

          elsif r_srv.id_interfase = '820' then
            --telefonia
            begin --4.0
              intraway.pq_cont_hfcbscs.P_CONT_ACTMTA(2,
                                                     lv_customer_id,
                                                     r_srv.id_producto,
                                                     r_srv.id_producto_padre,
                                                     ln_proceso,
                                                     an_codsolot,
                                                     av_mac,
                                                     ln_cantidad,
                                                     av_modelo,
                                                     lv_resultado,
                                                     av_error,
                                                     an_error);
            --Ini 4.0
            exception
              when others then
                rollback;
            end;
            --Fin 4.0

            if an_error = 0 then
              update OPERACION.TRS_INTERFACE_IW
                 set MODELO = av_modelo, MAC_ADDRESS = av_mac
               where idtrs = r_srv.idtrs;
               ln_cont := 1;  -- 3.0
            else --4.0
              lv_proceso:='intraway.pq_cont_hfcbscs.P_CONT_ACTMTA '; --2.0
            end if;
          end if;
        end loop;
      end if;

      if av_categoria = lv_box then
        FOR r_srv IN c_srv LOOP
          if r_srv.id_interfase = '2020' then
            --tv
            begin --4.0
              intraway.pq_cont_hfcbscs.P_CONT_ACTSTB(ln_idestado,
                                                     lv_customer_id,
                                                     r_srv.id_producto,
                                                     av_invsn,
                                                     av_ua,
                                                     lv_sendtocontroller,
                                                     ln_proceso,
                                                     an_codsolot,
                                                     av_modelo,
                                                     lv_resultado,
                                                     av_error,
                                                     an_error);
            -- ini 4.0
            exception
              when others then
                rollback;
            end;
            -- Fin 4.0

            if an_error = 0 then
              update OPERACION.TRS_INTERFACE_IW
                 set MODELO       = av_modelo,
                     MAC_ADDRESS  = av_invsn,
                     UNIT_ADDRESS = av_ua
               where idtrs = r_srv.idtrs;
               ln_cont := 1;  -- 3.0
             else --4.0
              lv_proceso:='intraway.pq_cont_hfcbscs.P_CONT_ACTSTB ';--2.0
            end if;
          end if;
        end loop;
      end if;

     if ln_cont = 1 then  -- 3.0
        commit;  -- 3.0
      begin  --4.0
        operacion.pq_iw_sga_bscs.p_consulta_estado_prov3(an_codsolot,
                                                     av_trama,
                                                     an_error,
                                                     av_error);
      -- ini 4.0
      exception
        when others then
          rollback;  -- 3.0
      end;

      ln_cont := 1;
      if an_error is null then
         an_error := 0;
         av_error := 'OK pq_iw_sga_bscs';
      end if;
      if  an_error = 0  then
      -- fin 4.0
       lv_cadena := OPERACION.PQ_IW_SGA_BSCS.f_cadena(av_trama, ';&',ln_cont);-- 32.0

        while (lv_cadena is not null) loop
          begin
            ISB := f_datos_iw(lv_cadena);

            update OPERACION.TRS_INTERFACE_IW
               set TRS_PROV_BSCS = ISB.lv_trs_prov_bscs,
                   ESTADO_BSCS   = ISB.lv_estado_bscs,
                   ESTADO_IW     = ISB.lv_estado_iw
             where cod_id =
                   (select cod_id from solot where codsolot = an_codsolot)
               and ID_PRODUCTO = ISB.ln_idproducto
               and TIP_INTERFASE = ISB.lv_tip_interface;

            ln_cont   := ln_cont + 1;
            lv_cadena := OPERACION.PQ_IW_SGA_BSCS.f_cadena(av_trama,
                                                           ';&',
                                                           ln_cont);-- 32.0
          end;
        end loop;
        commit;  -- 3.0
      -- ini 4.0
        av_error := '[operacion.pq_adm_cuadrilla.p_instala_equipo_HFC] Instalaci?n Exitosa';
      else
        rollback;
      end if;
      -- Fin 4.0
    else  -- 3.0
       rollback;   -- 3.0
       -- ini 4.0
       if not lv_proceso is null then
         av_error:=lv_proceso||' '||av_error;
       end if;
       if an_error is null then
         an_error := -1;  -- 3.0
       end if;
       if av_error is null then
         av_error := '[operacion.pq_adm_cuadrilla.p_instala_equipo_HFC] No se pudo Instalar Equipo fallo en proceso de activaci?n.';  -- 3.0
       end if;
       -- fin 4.0
    end if;  -- 3.0

    exception
      when others then
        an_error := -1;
        av_error := '[operacion.pq_adm_cuadrilla.p_instala_equipo_HFC] No se pudo Instalar El Servicio : ' ||
                    SQLERRM;
      rollback;  -- 3.0
    end;
  end;
  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        18/05/2015  Steve P.      Asocia  / INSTALA Equipo DTH
  ******************************************************************************/
  procedure p_asocia_tarjeta_deco_DTH(an_idagenda agendamiento.idagenda%type,
                                      av_numserie solotptoequ.numserie%type,
                                      av_mac      solotptoequ.mac%type,
                                      av_invsn    operacion.trs_interface_iw.mac_address%type,
                                      an_grupo    number,
                                      an_error    out number,
                                      av_error    out varchar2) is

    lv_numero_serie varchar2(1000);
    lv_nomcli       marketing.vtatabcli.nomcli%type;
    lv_estado       varchar2(10);
    lv_codresp      varchar2(2000);
    lv_mesresp      varchar(2000);
    ln_idtarjeta    solotptoequ.iddet%type;
    lv_mac          solotptoequ.mac%type;
    ln_iddeco       solotptoequ.iddet%type;
    ln_estado       number := 0;
    ln_cant_tarj    number;
    ln_cant_deco    number;
    ln_cant_tot     number;
    an_codsolot     solot.codsolot%type;
    lv_numserie     solotptoequ.numserie%type;
    ln_codinssrv    solotpto.codinssrv%type;

    cursor cur_tarjetas is
      select se.iddet, equ_conax.grupo, equ_conax.tipequ, sp.codinssrv
        from solotptoequ se,
             solot s,
             solotpto sp,
             inssrv i,
             tipequ t,
             almtabmat a,
             (select a.codigon tipequ, to_number(a.codigoc) grupo
                from opedd a, tipopedd b
               where a.tipopedd = b.tipopedd
                 and b.abrev = 'TIPEQU_DTH_CONAX'
                 and trim(a.codigoc) = trim(to_char(an_grupo))) equ_conax
       where se.codsolot = s.codsolot
         and s.codsolot = sp.codsolot
         and se.punto = sp.punto
         and sp.codinssrv = i.codinssrv
         and t.tipequ = se.tipequ
         and a.codmat = t.codtipequ
         and se.codsolot = an_codsolot
         and se.numserie = av_numserie
         and t.tipequ = equ_conax.tipequ
         and trim(equ_conax.grupo) = trim(to_char('1'))
         and se.iddet not in
             (select t.iddet_tarjeta
                from operacion.tarjeta_deco_asoc t
               where t.codsolot = an_codsolot);

    cursor cur_decos is
      select se.iddet, equ_conax.grupo, equ_conax.tipequ, sp.codinssrv
        from solotptoequ se,
             solot s,
             solotpto sp,
             inssrv i,
             tipequ t,
             almtabmat a,
             (select a.codigon tipequ, to_number(a.codigoc) grupo
                from opedd a, tipopedd b
               where a.tipopedd = b.tipopedd
                 and b.abrev = 'TIPEQU_DTH_CONAX'
                 and trim(a.codigoc) = trim(to_char(an_grupo))) equ_conax
       where se.codsolot = s.codsolot
         and s.codsolot = sp.codsolot
         and se.punto = sp.punto
         and sp.codinssrv = i.codinssrv
         and t.tipequ = se.tipequ
         and a.codmat = t.codtipequ
         and se.codsolot = an_codsolot
         and se.mac = av_mac
         and t.tipequ = equ_conax.tipequ
         and trim(equ_conax.grupo) = trim(to_char('2'))
         and se.iddet not in
             (select t.iddet_tarjeta
                from operacion.tarjeta_deco_asoc t
               where t.codsolot = an_codsolot);

    cursor cur_tmp is
      select numserie, grupo, iddet, mac
        from operacion.dth_preasociacion_tmp
       where codsolot = an_codsolot
         and idagenda = an_idagenda;

    e_error exception;
  begin
    an_error    := 0;
    av_error    := '';
    an_codsolot := f_obtiene_codsolotxagenda(an_idagenda);

    p_actualiza_solotptoqu_dth(an_codsolot,
                               av_numserie,
                               av_mac,
                               av_invsn,
                               an_grupo,
                               an_error,
                               av_error);

    for c_tarjetas in cur_tarjetas loop
      select count(1)
        into ln_cant_tarj
        from operacion.dth_preasociacion_tmp
       where codsolot = an_codsolot
         and idagenda = an_idagenda
         and grupo = c_tarjetas.grupo; --tarjetas

      if ln_cant_tarj = 0 then
        begin
          begin
            insert into operacion.dth_preasociacion_tmp
              (codsolot, idagenda, tipequ, numserie, mac, iddet, grupo)
            values
              (an_codsolot,
               an_idagenda,
               c_tarjetas.tipequ,
               av_numserie,
               av_mac,
               c_tarjetas.iddet, --idtarjeta
               c_tarjetas.grupo);
          exception
            when others then
              an_error := sqlcode;
              av_error := sqlerrm;
              raise e_error;
          end;

          ln_codinssrv := c_tarjetas.codinssrv;
        end;

      else
        av_error := '[operacion.pq_adm_cuadrilla.p_asocia_tarjeta_deco_DTH] Por favor Seleccione el Deco a Asociar a la tarjeta Seleccionada Anteriormente';
        raise e_error;
      end if;
    end loop;

    for c_decos in cur_decos loop
      select count(1)
        into ln_cant_deco
        from operacion.dth_preasociacion_tmp
       where codsolot = an_codsolot
         and idagenda = an_idagenda
         and grupo = c_decos.grupo; --decos

      if ln_cant_deco = 0 then
        begin
          insert into operacion.dth_preasociacion_tmp
            (codsolot, idagenda, tipequ, numserie, mac, iddet, grupo)
          values
            (an_codsolot,
             an_idagenda,
             c_decos.tipequ,
             av_numserie,
             av_mac,
             c_decos.iddet, --idtarjeta
             c_decos.grupo);

        exception
          when others then
            an_error := sqlcode;
            av_error := sqlerrm;
            raise e_error;
        end;
        ln_codinssrv := c_decos.codinssrv;
      else
        av_error := '[operacion.pq_adm_cuadrilla.p_asocia_tarjeta_deco_DTH] Por favor Seleccione la Tarjeta a Asociar al Deco Seleccionada Anteriormente';
        raise e_error;
      end if;
    end loop;

    select count(1)
      into ln_cant_tot
      from operacion.dth_preasociacion_tmp
     where codsolot = an_codsolot
       and idagenda = an_idagenda;

    if ln_cant_tot = 2 then
      for c_tmp in cur_tmp loop
        if c_tmp.grupo = 1 then
          lv_numserie     := c_tmp.numserie;
          lv_numero_serie := lv_numserie;
          ln_idtarjeta    := c_tmp.iddet;
        elsif c_tmp.grupo = 2 then
          lv_mac          := c_tmp.mac;
          lv_numero_serie := lv_mac;
          ln_iddeco       := c_tmp.iddet;
        end if;
        --consulta_dth si se encuentra en uso
        OPERACION.P_CONSULTA_DTH(lv_numero_serie,
                                 c_tmp.grupo,
                                 lv_nomcli,
                                 lv_estado,
                                 lv_codresp,
                                 lv_mesresp);

        if lv_codresp is null then
          if lv_estado = 'A' then
            ln_estado := 1;
            an_error  := -1;
            av_error  := '[operacion.pq_adm_cuadrilla.p_asocia_tarjeta_deco_DTH] Actualmente se encuentra en uso para el Cliente: ' ||
                         lv_nomcli || ' Cambiar Equipo';
            raise e_error;
          elsif lv_estado = 'R' then
            ln_estado := 2;
          end if;
        end if;
        begin
          if c_tmp.grupo = 1 then
            update operacion.tabequipo_material
               set estado = ln_estado
             where numero_serie = lv_numero_serie
               and tipo = c_tmp.grupo;
          elsif c_tmp.grupo = 2 then
            update operacion.tabequipo_material
               set estado = ln_estado
             where imei_esn_ua = lv_numero_serie
               and tipo = c_tmp.grupo;
          end if;
        end;
      end loop;

      INSERT INTO operacion.tarjeta_deco_asoc t
        (t.CODSOLOT,
         t.IDDET_DECO,
         t.NRO_SERIE_DECO,
         t.IDDET_TARJETA,
         t.NRO_SERIE_TARJETA)
      VALUES
        (an_codsolot, ln_iddeco, lv_mac, ln_idtarjeta, lv_numserie);

      p_instala_equipo_DTH(an_idagenda,
                           null, --c_tmp.numserie,
                           null, --c_tmp.mac,
                           0, --c_tmp.grupo,
                           ln_codinssrv,
                           an_error,
                           av_error);
      --   begin
      delete from operacion.dth_preasociacion_tmp
       where codsolot = an_codsolot;

    end if;
  exception
    when e_error then
      an_error := -1;
    when others then
      an_error := -1;
      av_error := '[operacion.pq_adm_cuadrilla.p_asocia_tarjeta_deco_DTH] Error p_asocia_tarjeta_deco_DTH ' ||
                  sqlerrm;
  end;

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        18/05/2015  Steve P.      Instala Equipo DTH
  ******************************************************************************/
  procedure p_instala_equipo_DTH(an_idagenda  agendamiento.idagenda%type,
                                 av_numserie  solotptoequ.numserie%type,
                                 av_mac       solotptoequ.mac%type,
                                 an_grupo     number,
                                 an_codinssrv solotpto.codinssrv%type,
                                 an_error     out number,
                                 av_error     out varchar2) is

    ln_contador      number;
    ln_postpago      number;
    lv_numslc        solot.numslc%type;
    ln_tipcambio     number := 1;
    ln_estsol        solot.estsol%type;
    lv_serie_tarjeta varchar2(2000) := '';
    lv_serie_deco    varchar2(2000) := '';
    ln_idtareawf     tareawf.idtareawf%type;
    an_resp          NUMBER;
    av_mensaje       VARCHAR2(1000);
    av_nro_contrato  VARCHAR2(1000);
    an_id_sisact     NUMBER;
    lv_numregistro   ope_srv_recarga_cab.numregistro%TYPE;
    av_resultado     varchar2(100);
    an_codsolot      solot.codsolot%type;

    cursor cur_equipos_dup_serie is
      select equ_conax.grupo, se.numserie, count(*) cantidad
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
         and se.codsolot = an_codsolot
         and trim(equ_conax.grupo) = trim(to_char('1'))
         and t.tipequ = equ_conax.tipequ having count(*) > 1
       group by equ_conax.grupo, se.numserie;

    cursor cur_mac_dup_deco is
      select equ_conax.grupo, se.mac, count(*) cantidad
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
         and se.codsolot = an_codsolot
         and trim(equ_conax.grupo) = trim(to_char('2'))
         and t.tipequ = equ_conax.tipequ having count(*) > 1
       group by equ_conax.grupo, se.mac;

    cursor cur_act_dth is
      select equ_conax.grupo codigo,
             t.descripcion,
             se.numserie,
             se.mac,
             se.cantidad,
             0               sel,
             i.codinssrv,
             se.codsolot,
             se.punto,
             se.orden,
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
         and se.codsolot = an_codsolot
         and t.tipequ = equ_conax.tipequ;

    e_error exception;
  begin
    an_error    := 0;
    av_error    := '';
    an_codsolot := f_obtiene_codsolotxagenda(an_idagenda);

    lv_numregistro := pq_inalambrico.f_obtener_numregistro(an_codsolot);

    select count(1)
      into ln_contador
      from operacion.ope_envio_conax
     where codsolot = an_codsolot
       and tipo = 1;

    select numslc, estsol
      into lv_numslc, ln_estsol
      from solot
     where codsolot = an_codsolot;

    --Valida si es un DTH PostPago
    ln_postpago := sales.pq_dth_postventa.f_obt_facturable_dth(lv_numslc);

    --si es reenvio se borrar lo existente
    if ln_contador > 0 then
      delete from operacion.ope_envio_conax
       where codsolot = an_codsolot
         and tipo = 1;
    end if;

    for c_equipos_dup in cur_equipos_dup_serie loop

      if c_equipos_dup.grupo = 1 and c_equipos_dup.cantidad > 1 then
        av_error := '[operacion.pq_adm_cuadrilla.p_instala_equipo_DTH] El Numero de Serie ' ||
                    c_equipos_dup.numserie ||
                    ' esta Duplicado en las Tarjetas';
        raise e_error;
      end if;
    end loop;

    for c_mac_dup_deco in cur_mac_dup_deco loop
      if c_mac_dup_deco.mac is not null and c_mac_dup_deco.cantidad > 1 then
        av_error := '[operacion.pq_adm_cuadrilla.p_instala_equipo_DTH] El Numero de Serie ' ||
                    c_mac_dup_deco.mac || ' esta Duplicado en los Decos';
        raise e_error;
      end if;
    end loop;

    -- ES DTH PostPago

    if ln_postpago = 1 then
      for c_act_dth in cur_act_dth loop
        if c_act_dth.codigo = 1 then
          lv_serie_tarjeta := c_act_dth.numserie;
        elsif c_act_dth.codigo = 2 then
          lv_serie_deco := c_act_dth.numserie;
        end if;
      end loop;

      select idtareawf
        into ln_idtareawf
        from tareawf twf, wf, solot s
       where twf.idwf = wf.idwf
         and wf.codsolot = s.codsolot
         and twf.tareadef = 802
         and s.codsolot = an_codsolot;

      sales.pq_dth_postventa.p_env_reg_sisact(lv_numslc,
                                              an_codsolot,
                                              ln_estsol,
                                              ln_idtareawf,
                                              lv_serie_tarjeta,
                                              lv_serie_deco,
                                              an_resp,
                                              av_mensaje,
                                              av_nro_contrato,
                                              an_id_sisact);

      if an_resp <> 0 then
        av_error := '[operacion.pq_adm_cuadrilla.p_instala_equipo_DTH] No se registro al SISACT, Error: ' ||
                    av_mensaje;
        raise e_error;
      end if;

      for c_act_dth in cur_act_dth loop
        operacion.pq_dth.p_ins_envioconax(an_codsolot,
                                          an_codinssrv,
                                          ln_tipcambio,
                                          c_act_dth.numserie,
                                          c_act_dth.mac,
                                          null,
                                          null,
                                          c_act_dth.codigo);
      end loop;

      OPERACION.PQ_DTH.p_crear_archivo_conax(lv_numregistro,
                                             av_resultado,
                                             av_mensaje);

      if av_resultado = 'OK' then
        if an_id_sisact is not null then
          UPDATE OPE_SRV_RECARGA_CAB O
             SET O.ID_SISACT = an_id_sisact
           WHERE O.NUMSLC = lv_numslc;
        end if;
        av_error := '[operacion.pq_adm_cuadrilla.p_instala_equipo_DTH] Se Registro en Sisact y se envio el archivo a CONAX correctamente.';

      else
        av_error := '[operacion.pq_adm_cuadrilla.p_instala_equipo_DTH] Se produjo un error al Enviar Archivo de Activacion a CONAX';

        update ope_srv_recarga_det
           set mensaje = av_mensaje
         where numregistro = lv_numregistro
           and tipsrv =
               (select valor from constante where constante = 'FAM_CABLE');
        raise e_error;
      end if;

    end if;

    -- No es DTH PostPago
    if ln_postpago <> 1 then
      begin
        operacion.pq_dth.p_ins_envioconax(an_codsolot,
                                          an_codinssrv,
                                          ln_tipcambio,
                                          av_numserie,
                                          av_mac,
                                          null,
                                          null,
                                          an_grupo);
      exception
        when others then
          av_error := '[operacion.pq_adm_cuadrilla.p_instala_equipo_DTH] Error al generar activacion de la tarjeta # ' ||
                      av_numserie || ' ' || sqlerrm;
          raise e_error;

      end;

      --ACTIVACION DTH
      OPERACION.PQ_DTH.p_crear_archivo_conax(lv_numregistro,
                                             av_resultado,
                                             av_mensaje);

      if av_resultado = 'OK' then
        av_error := '[operacion.pq_adm_cuadrilla.p_instala_equipo_DTH] Se Registro en Sisact y se envio el archivo a CONAX correctamente.';
      else
        av_error := '[operacion.pq_adm_cuadrilla.p_instala_equipo_DTH] Se produjo un error al Enviar Archivo de Activacion a CONAX';

        update ope_srv_recarga_det
           set mensaje = av_mensaje
         where numregistro = lv_numregistro
           and tipsrv =
               (select valor from constante where constante = 'FAM_CABLE');
        raise e_error;
      end if;
    end if;
  commit; -- 3.0
  exception
    when e_error then
      an_error := -1;
     rollback;  -- 3.0
    when others then
      an_error := -1;
      av_error := '[operacion.pq_adm_cuadrilla.p_instala_equipo_DTH] Error p_asocia_tarjeta_deco_DTH ' ||
                  sqlerrm;
    rollback;  -- 3.0
  end;
  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        21/05/2015  Steve P.      retorna tipo interfase
  ******************************************************************************/
  function f_obtiene_interfase(av_dsc   varchar2,
                               an_error out number,
                               av_error out varchar2) return varchar2 is

    lv_interfase varchar2(20);
    e_error exception;
  begin
    an_error := 0;
    av_error := '';

    begin
      SELECT d.codigoc
        into lv_interfase
        FROM operacion.parametro_det_adc d, operacion.parametro_cab_adc c
       WHERE d.abreviatura = av_dsc
         AND d.id_parametro = c.id_parametro
         AND c.abreviatura = 'TIPO_INTERFASE'
         and d.estado = 1
         and c.estado = 1;
    EXCEPTION
      WHEN no_data_found THEN
        lv_interfase := '';
        an_error     := -1;
        av_error     := '[operacion.pq_adm_cuadrilla.f_obtiene_interfase] La Interfase ' ||
                        av_dsc || ' no esta Configurada ';
    END;
    return lv_interfase;
  end;

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        21/05/2015  Steve P.      INSTALA EQUIPOS DTH / HFC
  2.0        15/05/2015  juan G.       INSTALA EQUIPOS HFC PARA CE
  ******************************************************************************/

  procedure p_instala_equipos_DTH_HFC(an_idagenda        agendamiento.idagenda%type,
                                      av_idinventario    varchar2,
                                      av_tecnol          varchar2,
                                      av_inv_description varchar2,
                                      av_modelo          operacion.trs_interface_iw.modelo%type,
                                      av_invtype_label   operacion.inventario_em_adc.idunico%type, --codigo unico
                                      av_codigosap       varchar2,
                                      av_invsn           operacion.trs_interface_iw.mac_address%type, --HFC DECO 2020 serie
                                      av_mta_mac_cm      operacion.trs_interface_iw.mac_address%type, --HFC MTA 620 --internet
                                      av_mta_mac         operacion.trs_interface_iw.mac_address%type, --HFC MTA 820 telefonia
                                      av_unit_addr       operacion.trs_interface_iw.unit_address%type,
                                      av_nro_tarjeta     operacion.trs_interface_iw.mac_address%type, --DTH TARJETA
                                      av_inddependencia  varchar2,
                                      av_observacion     varchar2,
                                      an_message_id      number,
                                      av_external_id     varchar2,
                                      an_error           out number,
                                      av_error           out varchar2) is

    lv_id_interfase operacion.trs_interface_iw.id_interfase%type;
    lv_categoria    operacion.inventario_em_adc.categoria%type;
	an_tiptra operacion.tiptrabajo.tiptra%type;
    an_tecnol          varchar2(10);
    -- lv_tip_cat
    e_error exception;
    ln_tipo number; --2.0

  begin
	an_tecnol := av_tecnol;
    an_error := 0;
    av_error := '';

    p_insertar_log_instalacion_eqp('I',
                                   an_message_id,
                                   an_idagenda,
                                   av_idinventario);

    p_tipo_serv_x_agenda(an_idagenda, ln_tipo, an_error, av_error); -- 2.0

    p_devuelve_categoria_inv(av_invtype_label,
                             ln_tipo,--2.0 <fase 2 eta>
                             lv_categoria,
                             an_error,
                             av_error);

    if an_error = -1 then
      av_error := '[operacion.pq_adm_cuadrilla.p_instala_equipos_DTH_HFC] No Existe Categoria';
      raise e_error;
    end if;
	
	--Ini 31.0
	IF av_tecnol IS NULL OR av_tecnol NOT IN ('HFC', 'DTH') THEN
      select s.tiptra into an_tiptra from agendamiento a, solot s
      where a.codsolot=s.codsolot and idagenda=an_idagenda;
     
      IF ln_tipo = 1 THEN
        an_tecnol := f_obtener_tipo_tecnologia(an_tiptra);  --Obtiene TecnologÃ­a
      ELSE
        an_tecnol := f_obtener_tipo_tecnologia_CE(an_tiptra); --Obtiene TecnologÃ­a en claro empresa
      END IF;
    END IF;
	--Fin 31.0
	
    if an_tecnol = 'HFC' then
      --ini 2.0
      if ln_tipo = 2 then
        -- CE
        p_instala_equipo_HFC_CE(an_idagenda,
                                av_modelo,
                                av_mta_mac, --telefonia
                                av_mta_mac_cm, --internet
                                av_invsn, --tv
                                av_unit_addr,
                                lv_categoria,
                                an_error,
                                av_error);
      elsif ln_tipo = 0 then
        raise e_error;
      elsif ln_tipo = 1 then
        -- Masivo
        -- fin 2.0
        p_instala_equipo_HFC(an_idagenda,
                             /*lv_id_interfase,*/
                             av_modelo,
                             av_mta_mac, --telefonia
                             av_mta_mac_cm, --internet
                             av_invsn, --tv
                             av_unit_addr,
                             lv_categoria,
                             an_error,
                             av_error);
      end if; --2.0
    elsif an_tecnol = 'DTH' then
      if lv_categoria = 'TARJETA' then
        --tarjeta
        lv_id_interfase := f_obtiene_interfase('TARJETA',
                                               an_error,
                                               av_error); --1

        if lv_id_interfase is null or lv_id_interfase = '' then
          return;
        else
          p_asocia_tarjeta_deco_DTH(an_idagenda,
                                    av_nro_tarjeta,
                                    av_unit_addr,
                                    av_invsn,
                                    to_number(lv_id_interfase),
                                    an_error,
                                    av_error);
        end if;
      elsif lv_categoria = 'SET-TOP BOX' then
        lv_id_interfase := f_obtiene_interfase('DECO', an_error, av_error); --2

        if lv_id_interfase is null or lv_id_interfase = '' then
          return;
        else
          p_asocia_tarjeta_deco_DTH(an_idagenda,
                                    av_nro_tarjeta,
                                    av_unit_addr,
                                    av_invsn,
                                    to_number(lv_id_interfase),
                                    an_error,
                                    av_error);

        END IF;
      end if;
    else
      av_error := '[operacion.pq_adm_cuadrilla.p_instala_equipos_DTH_HFC] Tecnologia No soporta Instalacion ';
      raise e_error;
    end if;

      p_insertar_log_instalacion_eqp('U',
                                     an_message_id,
                                     an_idagenda,
                                     av_idinventario);

  exception
    when e_error then
      an_error := -1;
      p_insertar_log_instalacion_eqp('U',
                                     an_message_id,
                                     an_idagenda,
                                     av_idinventario);
    when others then
      p_insertar_log_instalacion_eqp('U',
                                     an_message_id,
                                     an_idagenda,
                                     av_idinventario);
      an_error := -1;
      av_error := '[operacion.pq_adm_cuadrilla.p_instala_equipos_DTH_HFC] ' ||
                  av_error || sqlerrm;
  end;

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        21/05/2015  Steve P.      VALIDA ACTIVACION HFC
  ******************************************************************************/
  procedure p_valida_activacion_HFC(an_idagenda agendamiento.idagenda%type,
                                    an_error    out number,
                                    av_error    out varchar2) is

    an_codsolot solot.codsolot%type;
    av_trama    varchar2(4000);
    lv_cadena   varchar2(4000);
    ln_cont     number;
    ISB         IW_SGA_BSCS;
    ln_cant     number;

    e_error exception;
  begin
    an_error    := 0;
    av_error    := '';
    an_codsolot := f_obtiene_codsolotxagenda(an_idagenda);

    operacion.pq_iw_sga_bscs.p_consulta_estado_prov3(an_codsolot,
                                                     av_trama,
                                                     an_error,
                                                     av_error);
    ln_cont := 1;

    lv_cadena := OPERACION.PQ_IW_SGA_BSCS.f_cadena(av_trama, '', ln_cont);

    while (lv_cadena is not null) loop
      begin
        ISB := f_datos_iw(lv_cadena);

        select count(1)
          into ln_cant
          from OPERACION.TRS_INTERFACE_IW
         where cod_id =
               (select cod_id from solot where codsolot = an_codsolot)
           and ID_PRODUCTO = ISB.ln_idproducto
           and TIP_INTERFASE = ISB.lv_tip_interface
           and TRS_PROV_BSCS = ISB.lv_trs_prov_bscs
           and ESTADO_BSCS = ISB.lv_estado_bscs
           and ESTADO_IW = ISB.lv_estado_iw;
        if ln_cant = 0 then
          av_error := '[operacion.pq_adm_cuadrilla.p_valida_activacion_HFC] El Servicio No se encuentra instalado';
          raise e_error;
        else
          ln_cont := ln_cont + 1;

          lv_cadena := OPERACION.PQ_IW_SGA_BSCS.f_cadena(av_trama,
                                                         '',
                                                         ln_cont);
        end if;

      end;
    end loop;
  exception
    when e_error then
      an_error := -1;
    when others then
      an_error := -1;
      av_error := '[operacion.pq_adm_cuadrilla.p_valida_activacion_HFC] Error en la Validacion HFC ' ||
                  sqlerrm;
  end;

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        21/05/2015  Steve P.      VALIDA ACTIVACION DTH
  ******************************************************************************/
  procedure p_valida_activacion_DTH(an_idagenda agendamiento.idagenda%type,
                                    an_error    out number,
                                    av_error    out varchar2) is

    an_codsolot     solot.codsolot%type;
    ln_result_post  number;
    lv_numslc       solot.numslc%type;
    ln_estsol       solot.estsol%type;
    an_rpta         number;
    ac_reginsdth    reginsdth.numregistro%type;
    ln_tipcambio    number := 1;
    p_resultado     varchar2(100);
    p_mensaje       varchar2(100);
    ln_tipo         number;
    ln_cant_errores number;

  begin
    an_error    := 0;
    av_error    := '';
    an_codsolot := f_obtiene_codsolotxagenda(an_idagenda);

    ln_result_post := sales.pq_dth_postventa.f_obt_facturable_dth_sot(an_codsolot);

    -- VALIDAR SI EXISTE ENVIO CONAX
    operacion.pq_dth.p_val_envioconax(an_codsolot, an_rpta);

    IF an_rpta = 0 THEN
      av_error := '[operacion.pq_adm_cuadrilla.p_valida_activacion_DTH] Aun no se ha registrado ninguna operacion de envio';
    END IF;

    -- OBTENER NUMREGISTRO DTH
    operacion.pq_dth.p_get_numregistro(an_codsolot, ac_reginsdth);

    operacion.pq_dth.p_proc_recu_filesxcli(ac_reginsdth,
                                           ln_tipcambio,
                                           p_resultado,
                                           p_mensaje);

    if p_resultado = 'OK' then
      ln_tipo := 1;

      operacion.pq_dth.p_act_envioconax(an_codsolot, ln_tipo);

      select numslc, estsol
        into lv_numslc, ln_estsol
        from solot
       where codsolot = an_codsolot;

      IF ln_result_post = 1 THEN
        UPDATE OPE_SRV_RECARGA_CAB O
           SET O.FLAG_VERIF_CONAX = '1'
         WHERE O.NUMSLC = lv_numslc;
      END IF;
    else
      --OBTENER CANTIDAD DE ENVIOS ERRONEOS
      SELECT COUNT(*)
        INTO ln_cant_errores
        FROM operacion.reg_archivos_enviados
       WHERE numregins = ac_reginsdth
         AND estado = 3;

      -- SI EXISTE ENVIO ERRONEO
      IF ln_cant_errores > 0 THEN

        --OBTENER ERROR
        OPERACION.PQ_DTH.p_mostrar_error_dth(an_codsolot, p_mensaje);
        av_error := '[operacion.pq_adm_cuadrilla.p_valida_activacion_DTH] Se produjo un error en la operacion del servicio de Cable Satelital. ' ||
                    p_mensaje;
        ln_tipo  := 2;

        --ACTUALIZACION ESTADO
        operacion.pq_dth.p_act_envioconax(an_codsolot, ln_tipo);
      ELSE
        av_error := '[operacion.pq_adm_cuadrilla.p_valida_activacion_DTH] Por favor espere, Aun no se procesa la operacion en CONAX.';
      END IF;

    end if;
  end;
  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        21/05/2015  Steve P.      VALIDA ACTIVACION DTH / HFC
  ******************************************************************************/
  procedure p_valida_act_DTH_HFC(an_idagenda      agendamiento.idagenda%type,
                                 av_id_producto   operacion.trs_interface_iw.id_producto%type,
                                 av_tip_interfase operacion.trs_interface_iw.id_interfase%type,
                                 av_tecnol        varchar2,
                                 an_error         out number,
                                 av_error         out varchar2) is

  begin
    an_error := 0;
    av_error := '';

    if av_tecnol = 'HFC' then
      p_valida_activacion_HFC(an_idagenda, an_error, av_error);
    elsif av_tecnol = 'DTH' then
      p_valida_activacion_DTH(an_idagenda, an_error, av_error);
    end if;
    an_error := 1;
    av_error := '';
  end;

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        21/05/2015  Steve P.         obtiene categoria de CODIGO_EMTA equipo
  ******************************************************************************/
  function f_obtiene_cod_emta(an_error out number, av_error out varchar2)
    return varchar2 is

    lv_categoria operacion.inventario_em_adc.categoria%type;

  begin
    an_error := 0;
    av_error := '';
    begin
      SELECT d.codigoc
        into lv_categoria
        FROM operacion.parametro_det_adc d, operacion.parametro_cab_adc c
       WHERE d.abreviatura = 'CODIGO_EMTA'
         AND d.id_parametro = c.id_parametro
         AND c.abreviatura = 'CATEGORIA'
         and d.estado = 1
         and c.estado = 1;
    EXCEPTION
      WHEN no_data_found THEN
        lv_categoria := '';
        an_error     := -1;
        av_error     := '[operacion.pq_adm_cuadrilla.f_obtiene_cod_emta] La Configuracion de CATEGORIA para CODIGO_EMTA No existe';
    END;

    return lv_categoria;
  end;

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        21/05/2015  Steve P.         obtiene categoria de CODIGO_EMTA equipo
  ******************************************************************************/
  function f_obtiene_cod_box(an_error out number, av_error out varchar2)
    return varchar2 is

    lv_categoria operacion.inventario_em_adc.categoria%type;

  begin
    an_error := 0;
    av_error := '';
    begin
      SELECT d.codigoc
        into lv_categoria
        FROM operacion.parametro_det_adc d, operacion.parametro_cab_adc c
       WHERE d.abreviatura = 'CODIGO_SET-TOP_BOX'
         AND d.id_parametro = c.id_parametro
         AND c.abreviatura = 'CATEGORIA'
         and d.estado = 1
         and c.estado = 1;
    EXCEPTION
      WHEN no_data_found THEN
        lv_categoria := '';
        an_error     := -1;
        av_error     := '[operacion.pq_adm_cuadrilla.f_obtiene_cod_box] La Configuracion de CATEGORIA para CODIGO_SET-TOP_BOX No existe';
    END;

    return lv_categoria;
  end;

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        21/05/2015  Steve P.      retorna cantidad de dias para capacidad
  ******************************************************************************/
  function f_obtiene_cant_dias(an_error out number, av_error out varchar2)
    return number is
    ln_dias number;
    e_error exception;
  begin
    an_error := 0;
    av_error := '';
    begin
      SELECT d.codigon
        into ln_dias
        FROM operacion.parametro_det_adc d, operacion.parametro_cab_adc c
       WHERE d.abreviatura = 'CANTIDAD_DIAS'
         AND d.id_parametro = c.id_parametro
         AND c.abreviatura = 'CAPACIDAD'
         and d.estado = 1
         and c.estado = 1;
    EXCEPTION
      WHEN no_data_found THEN
        ln_dias  := 0;
        an_error := -1;
        av_error := '[operacion.pq_adm_cuadrilla.f_obtiene_cant_dias] La Cantidad de Dias a Consultar no esta Configurada ';
    END;
    return ln_dias;
  end;

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        21/05/2015  Steve P.      OBTIENE CALCULATE_DURATION
  ******************************************************************************/
  function f_obtiene_calculate_duration(an_error out number,
                                        av_error out varchar2)
    return varchar2 is
    lv_valor varchar2(5);

  begin
    an_error := 0;
    av_error := '';
    begin
      SELECT d.codigoc
        into lv_valor
        FROM operacion.parametro_det_adc d, operacion.parametro_cab_adc c
       WHERE d.abreviatura = 'CALCULATE_DURATION'
         AND d.id_parametro = c.id_parametro
         AND c.abreviatura = 'CAPACIDAD'
         and d.estado = 1
         and c.estado = 1;

    EXCEPTION
      WHEN no_data_found THEN
        lv_valor := '';
        an_error := -1;
        av_error := '[operacion.pq_adm_cuadrilla.f_obtiene_calculate_duration] La Configuracion de CALCULATE_DURATION No Existe ';
    END;
    return lv_valor;
  end;

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        21/05/2015  Steve P.        OBTIENE CALCULATE_TRAVEL_TIME
  ******************************************************************************/
  function f_obtiene_calculate_travel(an_error out number,
                                      av_error out varchar2) return varchar2 is
    lv_valor varchar2(5);

  begin
    an_error := 0;
    av_error := '';
    begin
      SELECT d.codigoc
        into lv_valor
        FROM operacion.parametro_det_adc d, operacion.parametro_cab_adc c
       WHERE d.abreviatura = 'CALCULATE_TRAVEL_TIME'
         AND d.id_parametro = c.id_parametro
         AND c.abreviatura = 'CAPACIDAD'
         and d.estado = 1
         and c.estado = 1;

    EXCEPTION
      WHEN no_data_found THEN
        lv_valor := '';
        an_error := -1;
        av_error := '[operacion.pq_adm_cuadrilla.f_obtiene_calculate_travel]  La Configuracion de CALCULATE_TRAVEL_TIME No Existe ';
    END;
    return lv_valor;
  end;

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        21/05/2015  Steve P.        OBTIENE CALCULATE_WORK_SKILL
  ******************************************************************************/
  function f_obtiene_calcule_work_skill(an_error out number,
                                        av_error out varchar2)
    return varchar2 is
    lv_valor varchar2(5);
  begin
    an_error := 0;
    av_error := '';
    begin
      SELECT d.codigoc
        into lv_valor
        FROM operacion.parametro_det_adc d, operacion.parametro_cab_adc c
       WHERE d.abreviatura = 'CALCULATE_WORK_SKILL'
         AND d.id_parametro = c.id_parametro
         AND c.abreviatura = 'CAPACIDAD'
         and d.estado = 1
         and c.estado = 1;

    EXCEPTION
      WHEN no_data_found THEN
        lv_valor := '';
        an_error := -1;
        av_error := '[operacion.pq_adm_cuadrilla.f_obtiene_calcule_work_skill] La Configuracion de CALCULATE_WORK_SKILL No Existe ';
    END;
    return lv_valor;
  end;

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        21/05/2015  Steve P.     Determina DETERMINE_LOCATION_BY_WORK_ZONA
  ******************************************************************************/
  function f_obtiene_by_work_zone(an_error out number,
                                  av_error out varchar2) return varchar2 is
    lv_valor varchar2(5);
  begin
    an_error := 0;
    av_error := '';
    begin
      SELECT d.codigoc
        into lv_valor
        FROM operacion.parametro_det_adc d, operacion.parametro_cab_adc c
       WHERE d.abreviatura = 'DETERMINE_LOCATION_BY_WORK_ZON'
         AND d.id_parametro = c.id_parametro
         AND c.abreviatura = 'CAPACIDAD'
         and d.estado = 1
         and c.estado = 1;

    EXCEPTION
      WHEN no_data_found THEN
        lv_valor := '';
        an_error := -1;
        av_error := '[operacion.pq_adm_cuadrilla.f_obtiene_by_work_zone] La Configuracion de DETERMINE_LOCATION_BY_WORK_ZON No Existe ';
    END;
    return lv_valor;
  end;

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        21/05/2015  Steve P.      Categoria work_skill
  ******************************************************************************/
  function f_obtiene_work_skill(av_cod_subtipo_orden operacion.subtipo_orden_adc.cod_subtipo_orden%type,
                                an_error             out number,
                                av_error             out varchar2)
    return varchar2 is

    lv_cod_work_skill operacion.work_skill_adc.cod_work_skill%type;

  begin
    an_error := 0;
    av_error := '';
    begin
      select cod_work_skill
        into lv_cod_work_skill
        from operacion.work_skill_adc
       where id_work_skill =
             (select id_work_skill
                from operacion.subtipo_orden_adc
               where cod_subtipo_orden = av_cod_subtipo_orden);
    EXCEPTION
      WHEN no_data_found THEN
        lv_cod_work_skill := '';
        an_error          := -1;
        av_error          := '[operacion.pq_adm_cuadrilla.f_obtiene_work_skill] La Configuracion de WORK_SKILL No Existe ';
    END;

    return lv_cod_work_skill;
  end;

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        14/05/2015  Steve P.      genera trama capacidad
  2.0        02/03/2015  Juan G.       genera trama capacidad para CE
  ******************************************************************************/
  procedure p_gen_trama_capacidad(an_codsolot          solot.codsolot%type,
                                  an_idagenda          agendamiento.idagenda%type,
                                  av_cod_subtipo_orden operacion.subtipo_orden_adc.cod_subtipo_orden%type,
                                  ad_fecha             date,
                                  av_trama             out clob,
                                  Pv_xml               out clob,
                                  Pv_Mensaje_Repws     out varchar2,
                                  Pn_Codigo_Respws     Out number) is

    ln_dias                  number;
    lv_delimitador           varchar2(1) := '|';
    lv_separador             varchar2(1) := ';';
    lv_time_slot             varchar2(10) := '';
    lv_calculate_duration    varchar2(5);
    lv_calculate_travel_time varchar2(5);
    lv_calcule_work_skill    varchar2(5);
    lv_by_work_zone          varchar2(5);
    lv_cod_work_skill        operacion.work_skill_adc.cod_work_skill%type;
    lv_auditoria             varchar2(100);
    lv_ip                    varchar2(20);
    lv_fecha                 varchar2(20);
    lv_user                  varchar2(50) := user;
    lv_servicio              varchar2(100) := 'consultaCapacidadSGA';
    lv_plano                 marketing.vtatabgeoref.idplano%TYPE;
    lv_codzona               operacion.zona_adc.codzona%TYPE;
    lv_cod_tipo_orden        operacion.tipo_orden_adc.cod_tipo_orden%type;
    lv_idplano               operacion.parametro_vta_pvta_adc.plano%TYPE;
    lv_centrop               operacion.parametro_vta_pvta_adc.idpoblado%TYPE;
    lv_subtipo               operacion.parametro_vta_pvta_adc.subtipo_orden%type;
    ln_tiptra                operacion.solot.tiptra%type;
    lv_tipsrv                operacion.solot.tipsrv%type;
    lv_bucket                operacion.parametro_vta_pvta_adc.idbucket%TYPE;
    ln_dnitec                operacion.parametro_vta_pvta_adc.dni_tecnico%type;
    ld_fecha                 operacion.parametro_vta_pvta_adc.fecha_progra%type;
    lv_franja                operacion.parametro_vta_pvta_adc.franja%type;
    lv_indpp                 operacion.parametro_vta_pvta_adc.flg_puerta%type;
    lv_zona                  operacion.zona_adc.codzona%type;
    an_tipo number;--2.0
    e_error exception;
    --Inicio 23.0
    ln_activacion_campos     number;
    ln_activacion_flag_vip   number;
    ln_flag_vip_default      number;
    ln_flag_zona             operacion.zona_adc.flag_zona%type;
    ln_flag_vip              operacion.tipo_orden_adc.flg_cuota_vip%type;
    --Fin 23.0
  begin
    begin
      p_elimna_tmp_capacidad(an_idagenda,
                             Pn_Codigo_Respws,
                             Pv_Mensaje_Repws);

      if Pn_Codigo_Respws = -1 then
        raise e_error;
      end if;

      if ad_fecha is null then
        Pv_Mensaje_Repws := '[operacion.pq_adm_cuadrilla.p_gen_trama_capacidad] La Fecha a consultar No es Valida';
        raise e_error;
      end if;

      SELECT sys_context('userenv', 'ip_address') into lv_ip from dual;
      SELECT to_char(sysdate, 'YYYYMMDDHH24MI') into lv_fecha from dual;

      lv_auditoria := lv_fecha || lv_delimitador || lv_ip || lv_delimitador ||
                      lv_aplicacion || lv_delimitador || lv_user ||
                      lv_delimitador;

      ln_dias := f_obtiene_cant_dias(Pn_Codigo_Respws, Pv_Mensaje_Repws);

      if ln_dias = 0 then
        RAISE e_error;
      end if;

      lv_calculate_duration := f_obtiene_calculate_duration(Pn_Codigo_Respws,
                                                            Pv_Mensaje_Repws);

      if lv_calculate_duration is null or lv_calculate_duration = '' then
        RAISE e_error;
      end if;

      lv_calculate_travel_time := f_obtiene_calculate_travel(Pn_Codigo_Respws,
                                                             Pv_Mensaje_Repws);

      if lv_calculate_travel_time is null or lv_calculate_travel_time = '' then
        RAISE e_error;
      end if;

      lv_calcule_work_skill := f_obtiene_calcule_work_skill(Pn_Codigo_Respws,
                                                            Pv_Mensaje_Repws);

      if lv_calcule_work_skill is null or lv_calcule_work_skill = '' then
        RAISE e_error;
      end if;

      lv_by_work_zone := f_obtiene_by_work_zone(Pn_Codigo_Respws,
                                                Pv_Mensaje_Repws);

      if lv_by_work_zone is null or lv_by_work_zone = '' then
        RAISE e_error;
      end if;

      av_trama := to_char(ad_fecha, 'YYYY-MM-DD');

      --fecha
      FOR i IN 1 .. ln_dias LOOP
        av_trama := av_trama || lv_separador ||
                    to_char((ad_fecha + i), 'YYYY-MM-DD');
      END LOOP;

      p_obtiene_valores_adc(an_idagenda,
                            lv_idplano,
                            lv_centrop,
                            lv_subtipo,
                            ln_tiptra,
                            lv_tipsrv,
                            lv_bucket,
                            ln_dnitec,
                            ld_fecha,
                            lv_franja,
                            lv_indpp,
                            lv_zona,
                            Pn_Codigo_Respws,
                            Pv_Mensaje_Repws);

      lv_bucket := null; -- se setea en nulo
      p_retornar_zona_plano(lv_idplano,
                            lv_centrop,
                            lv_plano,
                            lv_codzona,
                            Pn_Codigo_Respws,
                            Pv_Mensaje_Repws);
      -- INI 2.0
      p_tipo_x_tiposerv(an_codsolot, an_tipo, Pn_Codigo_Respws, Pv_Mensaje_Repws);
      if an_tipo = 0 then
      RAISE e_error;
      END if;
      if  an_tipo = 2 then
          lv_cod_tipo_orden := f_obtiene_tipoorden_ce(ln_tiptra,
                                                      Pn_Codigo_Respws,
                                                      Pv_Mensaje_Repws);
      else
      -- Fin 2.0
          lv_cod_tipo_orden := f_obtiene_tipoorden(ln_tiptra,
                                                   --an_codsolot, 2.0 emma
                                                   Pn_Codigo_Respws,
                                                   Pv_Mensaje_Repws);
      end if;-- 2.0

      if lv_cod_tipo_orden is null or lv_cod_tipo_orden = '' then
        RAISE e_error;
      end if;

      lv_cod_work_skill := f_obtiene_work_skill(av_cod_subtipo_orden,
                                                Pn_Codigo_Respws,
                                                Pv_Mensaje_Repws);

      if av_cod_subtipo_orden is null or av_cod_subtipo_orden = '' then
        Pn_Codigo_Respws := -1;
        Pv_Mensaje_Repws := '[operacion.pq_adm_cuadrilla.p_gen_trama_capacidad] No se pudo recuperar el SubTipo de Orden para la Agenda ' ||
                            an_idagenda;
        RAISE e_error;
      end if;

      if lv_cod_work_skill is null or lv_cod_work_skill = '' then
        RAISE e_error;
      end if;

      av_trama := av_trama || lv_delimitador || lv_bucket || lv_delimitador; -- bucket
      av_trama := av_trama || lv_calculate_duration || lv_delimitador; -- calculate_duration
      av_trama := av_trama || lv_calculate_travel_time || lv_delimitador; -- calculate_travel_time
      av_trama := av_trama || lv_calcule_work_skill || lv_delimitador; -- calculate_work_skill
      av_trama := av_trama || lv_by_work_zone || lv_delimitador; --determine_location_by_work_zone
      av_trama := av_trama || lv_time_slot || lv_delimitador; -- time_slot

      if lv_calcule_work_skill = 'false' then
        av_trama := av_trama || lv_cod_work_skill; -- work_skill
      END IF;

      if lv_by_work_zone = 'true' then
        if lv_codzona is null or lv_codzona = '' then
          Pn_Codigo_Respws := -1;
          Pv_Mensaje_Repws := '[operacion.pq_adm_cuadrilla.p_gen_trama_capacidad] La Zona a Consultar es Nula Por favor Verificar';
          RAISE e_error;
        end if;

        if lv_plano is null or lv_plano = '' then
          Pn_Codigo_Respws := -1;
          Pv_Mensaje_Repws := '[operacion.pq_adm_cuadrilla.p_gen_trama_capacidad] El Plano a Consultar es Nulo Por favor Verificar';
          RAISE e_error;
        end if;

        av_trama := av_trama || lv_delimitador || 'XA_Zone=' || lv_codzona ||
                    lv_separador; --name , value
        av_trama := av_trama || 'XA_Map=' || lv_plano; --name , value
      end if;

      if lv_calcule_work_skill = 'true' then
        if lv_by_work_zone = 'true' then
          av_trama := av_trama || lv_separador;
        end if;
        av_trama := av_trama || 'XA_WorkOrderSubtype=' ||
                    av_cod_subtipo_orden; --name , value
      end if;

       --Inicio 23.0
      ln_activacion_campos := SGAFUN_OBTIENE_VALOR_CAMPO('activar_campos_consulta_capac',
                                                          Pn_Codigo_Respws,
                                                          Pv_Mensaje_Repws);

      IF ln_activacion_campos = 1 THEN   --Activacion de nuevos campos (Zona Compleja/Flag Vip)
        --Zona compleja
        ln_flag_zona  := SGAFUN_OBTIENE_ZONA_COMPLEJA(lv_codzona,
                                                 Pn_Codigo_Respws,
                                                 Pv_Mensaje_Repws);
        IF ln_flag_zona is null or ln_flag_zona = '' THEN
          RAISE e_error;
        END IF;

        av_trama := av_trama || lv_separador || 'XA_Zone_Complex=' || ln_flag_zona;

        --Obtener Flag Vip
        ln_activacion_flag_vip := SGAFUN_OBTIENE_VALOR_CAMPO('activar_flag_vip',
        Pn_Codigo_Respws,
                                                        Pv_Mensaje_Repws);
        IF ln_activacion_flag_vip is null or ln_activacion_flag_vip = '' THEN
          RAISE e_error;
        END IF;

        IF ln_activacion_flag_vip = 0 THEN  -- 0=desactivado , damos por defecto el 2=f_obtiene_flag_vip_default
            ln_flag_vip_default :=  SGAFUN_OBTIENE_VALOR_CAMPO('flag_vip_default',Pn_Codigo_Respws,Pv_Mensaje_Repws);
            av_trama := av_trama || lv_separador || 'XA_VIP_Flag =' || ln_flag_vip_default ;
        ELSE
           ln_flag_vip:= SGAFUN_OBTIENE_FLAG_VIP_ORD(av_cod_subtipo_orden,
                                                           Pn_Codigo_Respws,
                                                           pv_Mensaje_Repws);
            IF ln_flag_vip is null or ln_flag_vip = '' THEN
              RAISE e_error;
            END IF;
            av_trama := av_trama || lv_separador || 'XA_VIP_Flag=' || ln_flag_vip;
        END IF;
      END IF;
      --Fin 23.0
      av_trama := trim(lv_auditoria || av_trama);

      webservice.PQ_OBTIENE_ENVIA_TRAMA_ADC.P_WS_Consulta(an_codsolot,
                                                          an_idagenda,
                                                          lv_servicio,
                                                          av_trama,
                                                          Pv_xml,
                                                          Pv_Mensaje_Repws,
                                                          Pn_Codigo_Respws);
    exception
      when e_error then
        Pn_Codigo_Respws := -1;

        webservice.PQ_OBTIENE_ENVIA_TRAMA_ADC.p_inserta_transaccion_ws_adc(an_codsolot,
                                                                           an_idagenda,
                                                                           lv_servicio,
                                                                           Pv_xml,
                                                                           Pv_xml,
                                                                           Pn_Codigo_Respws,
                                                                           Pv_Mensaje_Repws);
      when others then
        Pn_Codigo_Respws := -1;
        Pv_Mensaje_Repws := Pv_Mensaje_Repws ||
                            '[operacion.pq_adm_cuadrilla.p_gen_trama_capacidad] No se pudo Generar la Trama de Capacidad : ' ||
                            SQLERRM;

        webservice.PQ_OBTIENE_ENVIA_TRAMA_ADC.p_inserta_transaccion_ws_adc(an_codsolot,
                                                                           an_idagenda,
                                                                           lv_servicio,
                                                                           Pv_xml,
                                                                           Pv_xml,
                                                                           Pn_Codigo_Respws,
                                                                           Pv_Mensaje_Repws);

    end;
  end;

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        14/05/2015  Steve P.      retorna codigo de la configuracion de origen estado / motivo
  ******************************************************************************/
  function f_obtiene_origen_estado_motivo(av_tipo varchar2) return number is
    ln_tipo number;

  begin
    begin
      SELECT d.codigon
        into ln_tipo
        FROM operacion.parametro_det_adc d, operacion.parametro_cab_adc c
       WHERE d.abreviatura = av_tipo
         AND d.id_parametro = c.id_parametro
         AND c.abreviatura = 'SISTEMA'
         and d.estado = 1
         and c.estado = 1;
    EXCEPTION
      WHEN no_data_found THEN
        ln_tipo := 0;
    END;
    return ln_tipo;
  end;

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        14/05/2015  Steve P.      retorn Estado SGA/ETA
  ******************************************************************************/
  function f_retorna_estado_ETA_SGA(av_origen    varchar2, --ETA  / SGA
                                    an_tipoorden operacion.tipo_orden_adc.id_tipo_orden%type,
                                    an_estado    estagenda.estage%type,
                                    an_motivo    mot_solucionxtiptra.codmot_solucion%type,
                                    an_origen    out number) return number is

    ln_idestado number := 0;
    ln_motivo   operacion.estado_motivo_sga_adc.idmotivo_sga_origen%type;
  begin
    --otiene origen del estado motivo
    an_origen := f_obtiene_origen_estado_motivo(av_origen);

    if an_motivo is null then
      ln_motivo := 0;
    else
      ln_motivo := an_motivo;
    end if;

    if an_origen = 1 then
      --DE ETA A SGA *
      begin
        select idestado_sga_origen
          into ln_idestado
          from operacion.estado_motivo_sga_adc
         where id_tipo_orden = an_tipoorden
           and idestado_adc_destino = an_estado
           and idmotivo_sga_destino = ln_motivo;
      EXCEPTION
        WHEN no_data_found THEN
          ln_idestado := 0;
      END;
    end if;

    if an_origen = 2 then
      --SGA A ETA
      begin
        select idestado_adc_destino
          into ln_idestado
          from operacion.estado_motivo_sga_adc
         where id_tipo_orden = an_tipoorden
           and idestado_sga_origen = an_estado
           and idmotivo_sga_origen = ln_motivo;
      EXCEPTION
        WHEN no_data_found THEN
          ln_idestado := 0;
      END;
    end if;

    return ln_idestado;
  end;
  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        14/05/2015  Steve P.     actualiza estado de la agenda
  2.0        10/05/2015  juan G.      Indicencia SD  788452
  ******************************************************************************/
  procedure p_act_estado_agenda(av_origen   varchar2,
                                an_idagenda agendamiento.idagenda%type,
                                an_estado   number,
                                an_motivo   number,
                                av_ticket_remedy varchar2 default null,--27.0
                                an_error    out number,
                                av_error    out varchar2) is

    ln_estado        number;
    lv_cadena_mots   varchar2(4000) := '';
    av_observacion   varchar2(4000) := 'CAMBIO DE ESTADO ADM. CUADRILLA';
    ld_fecha         date := sysdate;
    ln_origen        number;
    ln_estagenda_old number;
    ln_codsolot      operacion.solot.codsolot%type;
    lv_motivo        operacion.mot_solucion.descripcion%type;
    ln_tipo_orden    operacion.tipo_orden_adc.id_tipo_orden%type;
    e_error exception;
    ln_tipo number; --2.0
   -- av_ticket_remedy varchar2(20):=null  ;--27.0
  begin
    an_error := 0;
    av_error := '';
    -- ini 2.0
    p_tipo_serv_x_agenda(an_idagenda, ln_tipo, an_error, av_error); -- 2.0

    if ln_tipo = 0 then
      raise e_error;
    elsif ln_tipo = 1 then
      --Masivo
      -- fin 2.0
      begin
        --otiene tipo de trabajo  --
        select t.id_tipo_orden
          into ln_tipo_orden
          from operacion.agendamiento a,
               operacion.solot        s,
               operacion.tiptrabajo   t
         where a.idagenda = an_idagenda
           and a.codsolot = s.codsolot
           and s.tiptra = t.tiptra;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          ln_tipo_orden := NULL;
        when others then
          ln_tipo_orden := NULL;
      end;
      -- ini 2.0
    elsif ln_tipo = 2 then
      -- Claro Empresa
      begin
        select t.id_tipo_orden_ce
          into ln_tipo_orden
          from operacion.agendamiento a,
               operacion.solot        s,
               operacion.tiptrabajo   t
         where a.idagenda = an_idagenda
           and a.codsolot = s.codsolot
           and s.tiptra = t.tiptra;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          ln_tipo_orden := NULL;
        when others then
          ln_tipo_orden := NULL;
      end;
    end if;
    -- Fin 2.0
    if ln_tipo_orden is null then
      an_error := -1;
      av_error := '[operacion.pq_adm_cuadrilla.p_act_estado_agenda] Tipo de Trabajo de la Agenda ' ||
                  an_idagenda || ' No tiene asociado un Tipo de Orden.';
      raise e_error;  --4.0
    end if;

    --otiene estado SGA / ETA
    begin
      ln_estado := f_retorna_estado_ETA_SGA(av_origen,
                                            ln_tipo_orden,
                                            an_estado,
                                            an_motivo,
                                            ln_origen);

      if ln_origen <> 0 then
        if ln_estado <> 0 then
          select estage, codsolot
            into ln_estagenda_old, ln_codsolot
            from operacion.agendamiento
           where idagenda = an_idagenda;

          --de ETA / SGA
          if ln_origen = 1 then
            operacion.pq_agendamiento.p_chg_est_agendamiento(an_idagenda,
                                                             ln_estado,
                                                             ln_estagenda_old,
                                                             av_observacion,
                                                             an_motivo,
                                                             ld_fecha,
                                                             lv_cadena_mots,
                                                             an_estado,
                                                             av_ticket_remedy--23.0
                                                             );
          end if;

          begin
            select descripcion
              into lv_motivo
              from operacion.mot_solucion
             where codmot_solucion = an_motivo;

          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              lv_motivo := '';
            when others then
              lv_motivo := '';
          end;

          -- Guardando el Cambio en historico
          p_insert_ot_adc(ln_codsolot,
                          lv_aplicacion,
                          an_idagenda,
                          an_estado,
                          lv_motivo);
          commit; --4.0

        else
          an_error := -3;
          av_error := '[operacion.pq_adm_cuadrilla.p_act_estado_agenda] No se Encontro la configuracion de Estado Motivo';
          rollback;--4.0
        end if;

      else
        an_error := -2;
        av_error := '[operacion.pq_adm_cuadrilla.p_act_estado_agenda] No se Encontro la configuracion de Origen ETA / SGA';
        rollback;--4.0
      end if;

    exception
      when others then
        an_error := -1;
        av_error := av_error ||
                    '[operacion.pq_adm_cuadrilla.p_act_estado_agenda] No se pudo Actualizar El Estado de la Agenda : ' ||
                    SQLERRM;
        rollback;--4.0
    end;
   -- Ini 4.0
   exception
    when e_error then
         an_error := -1;
         rollback;
   -- Fin 4.0
  end;
  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        26/05/2015                   Obtiene si la instalacion concluyo correctamente
  ******************************************************************************/
  function f_devuelve_fin_instalacion(an_message_id number) return number is

    ld_fecfin_inst LOG_INSTALACION_EQUIPOS.fecfin_inst%type;
    ln_retorna     number;
  begin
    begin
      SELECT fecfin_inst
        into ld_fecfin_inst
        from OPERACION.LOG_INSTALACION_EQUIPOS
       where message_id = an_message_id;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        ln_retorna := -1;
      when too_many_rows then
        ln_retorna := -1;
    END;

    if ln_retorna = -1 then
      return ln_retorna;
    end if;

    if ld_fecfin_inst is null then
      ln_retorna := 0;
    else
      ln_retorna := 1;
    end if;
    return ln_retorna;
  end;

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        14/05/2015  Steve P.      Ontiene tipo de trabajo
  ******************************************************************************/
  function f_obtiene_tipo_trabajo(an_codsolot solot.codsolot%type,
                                  an_error    out number,
                                  av_error    out varchar2) return number is

    ln_tiptrabajo solot.tiptra%type;

  begin
    an_error := 0;
    av_error := '';
    begin
      select tiptra
        into ln_tiptrabajo
        from solot
       where codsolot = an_codsolot;

    EXCEPTION
      WHEN no_data_found THEN
        ln_tiptrabajo := 0;
        an_error      := -1;
        av_error      := '[operacion.pq_adm_cuadrilla.f_obtiene_tipo_trabajo] No Existe El tipo de Trabajo ';
    END;
    return ln_tiptrabajo;
  end;

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        26/05/2015   Justiniano Condori consulta capacidad
  ******************************************************************************/
  PROCEDURE p_consulta_capacidad_sga(an_codsolot          solot.codsolot%type,
                                     an_idagenda          agendamiento.idagenda%type,
                                     av_cod_subtipo_orden operacion.subtipo_orden_adc.cod_subtipo_orden%type,
                                     p_fecha              DATE, -- Fecha de Consulta de Capacidad
                                     p_id_msj_err         OUT number,
                                     p_desc_msj_err       OUT VARCHAR2) IS
    v_trama CLOB;
    v_xml   CLOB;
  BEGIN

    -- Consulta de Parametros de Capacidad de Instalacion(Ventas)
    -- Consulta de Parametros de Capacidad de Mantenimiento(PostVenta)
    -- Proceso de Generacion de Trama
    IF an_idagenda IS NOT NULL THEN
      p_gen_trama_capacidad(an_codsolot,
                            an_idagenda,
                            av_cod_subtipo_orden,
                            p_fecha,
                            v_trama,
                            v_xml,
                            p_desc_msj_err,
                            p_id_msj_err);
    ELSE
      p_gen_trama_capacidad_solot(an_codsolot,
                                  av_cod_subtipo_orden,
                                  p_fecha,
                                  v_trama,
                                  v_xml,
                                  p_desc_msj_err,
                                  p_id_msj_err);
    END IF;

  EXCEPTION
    WHEN OTHERS THEN
      p_id_msj_err   := -1;
      p_desc_msj_err := '[operacion.pq_adm_cuadrilla.p_consulta_capacidad_sga] No se pudo Generar la Trama de Capacidad : ' ||
                        SQLERRM;
  END;

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        26/05/2015                    Obtiene Tipo de Orden
  ******************************************************************************/

  FUNCTION f_obtiene_tipoorden(as_tiptra tiptrabajo.tiptra%TYPE,
                               an_error  out number,
                               av_error  out varchar2) RETURN VARCHAR2 IS

    ln_tipoorden operacion.tiptrabajo.id_tipo_orden%TYPE;
    ls_tipoorden operacion.tipo_orden_adc.cod_tipo_orden%TYPE;
  BEGIN
    ls_tipoorden := '';
    BEGIN
      SELECT d.id_tipo_orden
        INTO ln_tipoorden
        FROM operacion.tiptrabajo d
       WHERE d.tiptra = as_tiptra;

    EXCEPTION
      WHEN no_data_found THEN
        ln_tipoorden := NULL;
        an_error     := -1;
        av_error     := '[operacion.pq_adm_cuadrilla.f_obtiene_tipoorden] No Existe Tipo de Trabajo ';
    END;

    IF ln_tipoorden IS NULL THEN
      RETURN ls_tipoorden;
    END IF;

    BEGIN
      SELECT c.cod_tipo_orden
        INTO ls_tipoorden
        FROM operacion.tipo_orden_adc c
       WHERE c.id_tipo_orden = ln_tipoorden;
    EXCEPTION
      WHEN no_data_found THEN
        ls_tipoorden := '';
        an_error     := -1;
        av_error     := '[operacion.pq_adm_cuadrilla.f_obtiene_tipoorden] El Tipo de Trabajo No tiene Tipo de Orden';
    END;

    RETURN ls_tipoorden;
  END;
  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        26/05/2015                   Obtiene categoria de Inventario
  2.0        01/03/2015                   Obtiene categoria de Inventario
  ******************************************************************************/
  PROCEDURE p_devuelve_categoria_inv(as_idunico      operacion.inventario_em_adc.idunico%type,
                                     an_tipo         number, --2.0 <fase 2 eta>
                                     as_categoria    out operacion.inventario_em_adc.categoria%type,
                                     an_iderror      OUT NUMERIC,
                                     as_mensajeerror OUT VARCHAR2) IS

  ls_codigo_sap_ce        operacion.inventario_em_adc.idunico%TYPE;--2.0

  begin
    an_iderror      := 0;
    as_mensajeerror := '';


 --ini 2.0
     if an_tipo = 2 then
           ls_codigo_sap_ce:=  lpad( trim(as_idunico), 18, '0') ;
            begin
          select upper(i.categoria)
            into as_categoria
            from operacion.inventario_em_adc i
           where i.idunico = ls_codigo_sap_ce
             and flg_tipo=an_tipo;
        EXCEPTION
          WHEN no_data_found THEN
            an_iderror := -1;
           END;
      else--fin 2.0
          begin
            select upper(i.categoria)
              into as_categoria
              from operacion.inventario_em_adc i
             where i.idunico = as_idunico
               and flg_tipo=an_tipo;--2.0 <fase 2 eta>
          EXCEPTION
            WHEN no_data_found THEN
              an_iderror := -1;
          END;
      end if;--2.0
  end;

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        26/05/2015                   Inserta Log Instalacion de Equipos
  ******************************************************************************/
  PROCEDURE p_insertar_log_instalacion_eqp(av_tipo         varchar2,
                                           an_message_id   number,
                                           an_idagenda     agendamiento.idagenda%type,
                                           av_idinventario varchar2) IS
    PRAGMA AUTONOMOUS_TRANSACTION;

  BEGIN

    if av_tipo = 'I' then
      insert into OPERACION.LOG_INSTALACION_EQUIPOS
        (message_id, idagenda, idinventario, fecini_inst, fecfin_inst)
      values
        (an_message_id, an_idagenda, av_idinventario, sysdate, null);

    elsif av_tipo = 'U' then
      update OPERACION.LOG_INSTALACION_EQUIPOS
         set fecfin_inst = sysdate
       where message_id = an_message_id
         and idagenda = an_idagenda;
    end if;
    COMMIT;
  END;
  /*Steve fin */
  /******************************************************************************
    Ver         Date          Author                   Descripcion
  ---------  ----------  ------------------  ------------------------------------
  1.0        04/06/2015  Justiniano Condori  Retorna Disponibilidad Maxima
  ******************************************************************************/
  FUNCTION f_obtiene_disp_max RETURN NUMBER IS
    ln_disp NUMBER;

  BEGIN
    BEGIN
      SELECT d.codigon
        INTO ln_disp
        FROM operacion.parametro_det_adc d, operacion.parametro_cab_adc c
       WHERE d.abreviatura = 'DISP_CAPC_MAX'
         AND d.id_parametro = c.id_parametro
         AND c.abreviatura = 'CAPACIDAD'
         AND d.estado = 1
         AND c.estado = 1;

    EXCEPTION
      WHEN no_data_found THEN
        ln_disp := 0;
    END;
    RETURN ln_disp;
  END;
  /******************************************************************************
    Ver         Date          Author                   Descripcion
  ---------  ----------  ------------------  ------------------------------------
  1.0        05/06/2015  Justiniano Condori  Retorna la fecha maxima de la tabla temporal
  ******************************************************************************/
  FUNCTION f_obtiene_max_fech(an_idagenda agendamiento.idagenda%type,
                              ad_fecha    agendamiento.fecagenda%type)
    RETURN NUMBER IS
    n_retorna number;
  BEGIN

    n_retorna := 0;
    BEGIN

      select count(*)
        into n_retorna
        from (SELECT MAX(to_date(substr(tp.fecha, 1, 10), 'YYYY/MM/DD')) maxima,
                     min(to_date(substr(tp.fecha, 1, 10), 'YYYY/MM/DD')) minima
                FROM operacion.tmp_capacidad tp
               where id_agenda = an_idagenda) tmp
       where ad_fecha between tmp.minima and tmp.maxima;

    EXCEPTION
      WHEN no_data_found THEN
        n_retorna := 0;
    END;

    RETURN n_retorna;
  END;
  /******************************************************************************
     Ver         Date          Author                   Descripcion
  ---------  ----------  ------------------  ------------------------------------
  1.0        05/06/2015  Justiniano Condori  Reemplaza los caracteres especiales
  ******************************************************************************/
  FUNCTION f_reemplazar_caracter(p_caracter IN CLOB) RETURN CLOB IS
    lc_retorno CLOB;
    lv_destino VARCHAR2(3000);

    cursor c_replace is
      SELECT d.codigoc
        FROM operacion.parametro_det_adc d, operacion.parametro_cab_adc c
       WHERE d.estado = 1
         AND d.abreviatura = 'ORIGENADC'
         AND d.id_parametro = c.id_parametro
         AND c.estado = 1
         AND c.abreviatura = 'CARACTERES_ESPECIALES';
  BEGIN

    SELECT d.codigoc
      INTO lv_destino
      FROM operacion.parametro_det_adc d, operacion.parametro_cab_adc c
     WHERE d.estado = 1
       AND d.abreviatura = 'DESTINO'
       AND d.id_parametro = c.id_parametro
       AND c.estado = 1
       AND c.abreviatura = 'CARACTERES_ESPECIALES';

    lc_retorno := p_caracter;

    for c in c_replace loop
      lc_retorno := replace(lc_retorno, c.codigoc, lv_destino);
    end loop;

    RETURN lc_retorno;
  END;

  /******************************************************************************
    Ver         Date          Author                   Descripcion
  ---------  ----------  ------------------  ------------------------------------
  1.0        05/06/2015  Justiniano Condori  Realiza la creacion de la trama de la
                                             orden de Trabajo Agendamiento/Reagendamiento/Puerta a Puerta/
                                             No Programada
  2.0        20/04/2015  HITSS               Etadirect fase 2
  3.0        15/06/2016  Juan Gonzales       Direccion del cliente ETA
  4.0        12/07/2016  Felipe Magui?a      SD-861542 relanzar orden
  5.0        09/12/2016  Juan Gonzales       PROY-22818.SD1025748
  6.0        26/09/2018  Obed Ortiz          A?adir el flujo para reserva de cuota TOA
  ******************************************************************************/
  procedure p_gen_trama_orden_trabajo(p_ind            in varchar2,
                                      p_idagenda       in number,
                                      p_fecha          in date, -- solo para PR y RP, caso contrario nulo
                                      p_franja_horaria in varchar2, -- solo para PR y RP, caso contrario nulo
                                      p_bucket         in varchar2, -- Si es PP sera el dni del tecnico que sera el bucket
                                      p_contacto       in varchar2, -- solo para RP, caso contrario nulo
                                      p_direccion      in varchar2, -- solo para RP, caso contrario nulo
                                      p_telefono       in varchar2, -- solo para RP, caso contrario nulo
                                      p_zona           in varchar2,
                                      p_plano          in varchar2,
                                      p_tipo_orden     in varchar2,
                                      p_subtipo_orden  in varchar2,
                                      p_observaciones  in varchar2,
                                      p_trama          out clob,
                                      p_resultado      out varchar2,
                                      p_mensaje        out varchar2) is
    lv_ip                    varchar2(20);
    lv_fecha                 varchar2(20);
    lv_auditoria             varchar2(100);
    lv_user                  varchar2(50) := user;
    lv_comando_fech          varchar2(20);
    lv_delimitador           operacion.parametro_det_adc.codigoc%type;
    lv_separador             operacion.parametro_det_adc.codigoc%type;
    lv_separador2            operacion.parametro_det_adc.codigoc%type;
    lv_separador3            operacion.parametro_det_adc.codigoc%type;
    lv_aplicacion            operacion.parametro_det_adc.codigoc%type;
    lv_modo_propiedad        operacion.parametro_det_adc.codigoc%type;
    lv_modo_proceso          operacion.parametro_det_adc.codigoc%type;
    lv_tipo_carga            operacion.parametro_det_adc.codigoc%type;
    lv_campo_clave           operacion.parametro_det_adc.codigoc%type;
    lv_campo_clave_inv       operacion.parametro_det_adc.codigoc%type;
    lv_campo_clave_inv2      operacion.parametro_det_adc.codigoc%type;
    lv_tipo_carga_inv        operacion.parametro_det_adc.codigoc%type;
    lv_tipo_comando          operacion.parametro_det_adc.codigoc%type;
    lv_bucket                operacion.parametro_det_adc.codigoc%type;
    lv_bucket_error          operacion.parametro_det_adc.codigoc%type;
    lv_tipo_zona             operacion.parametro_det_adc.codigoc%type;
    lv_recordatorio          operacion.parametro_det_adc.codigoc%type;
    lv_codigo_cliente        varchar2(8);
    lv_franja_horaria        operacion.franja_horaria.codigo%type;
    lv_nom_cliente           marketing.vtatabcli.nomcli%type;
    lv_telefono_cliente      varchar2(50);
    lv_email_cliente         varchar2(50);
    lv_direcc_cliente        operacion.inssrv.direccion%type;
    lv_ciudad_cliente        varchar2(50);
    lv_coordx                varchar2(50);
    lv_coordy                varchar2(50);
    ln_peso                  number;
    lv_codpos                varchar2(50);
    ln_tiem_trab             number;
    lv_distrito              varchar2(50);
    lv_XA_WorkOrderSubtype   operacion.parametro_det_adc.codigoc%type;
    lv_XA_Reference          operacion.parametro_det_adc.codigoc%type;
    lv_dir_referencia        marketing.vtatabcli.referencia%type;
    lv_XA_Zone               operacion.parametro_det_adc.codigoc%type;
    lv_XA_Map                operacion.parametro_det_adc.codigoc%type;
    lv_XA_Priority           operacion.parametro_det_adc.codigoc%type;
    lv_prioridad             varchar2(50);
    lv_fech_ini_sla          varchar2(20);
    lv_fech_fin_sla          varchar2(20);
    lv_XA_Contact_Name       operacion.parametro_det_adc.codigoc%type;
    lv_contacto              marketing.vtatabcli.nomcli%type;
    lv_XA_Customer_ID        operacion.parametro_det_adc.codigoc%type;
    lv_nro_doc               varchar2(15);
    lv_XA_Customer_ID_Type   operacion.parametro_det_adc.codigoc%type;
    lv_tipo_doc              varchar2(50);
    lv_XA_Province           operacion.parametro_det_adc.codigoc%type;
    lv_provincia             varchar2(50);
    lv_XA_Department         operacion.parametro_det_adc.codigoc%type;
    lv_XA_Zone_Type          operacion.parametro_det_adc.codigoc%type;
    lv_XA_Dispatch_Base      operacion.parametro_det_adc.codigoc%type;
    lv_base_despacho         varchar2(50);
    lv_XA_Services_ToInstall operacion.parametro_det_adc.codigoc%type;
    lc_servicio_x_instalar   clob;
    lv_XA_Installed_Services operacion.parametro_det_adc.codigoc%type;
    lv_servicio_instalado    varchar2(50);
    lv_XA_Activity_Notes     operacion.parametro_det_adc.codigoc%type;
    lv_observaciones_sga     operacion.solot.observacion%type;
    lv_XA_Input_Date         operacion.parametro_det_adc.codigoc%type;
    lv_fecha_reg_ord         varchar2(50);
    lv_XA_Service_History    operacion.parametro_det_adc.codigoc%type;
    lv_hist_visit            varchar2(50);
    lv_XA_VIP_Flag           operacion.parametro_det_adc.codigoc%type;
    lv_flag_vip              varchar2(1);
    lv_XA_SOT_ID             operacion.parametro_det_adc.codigoc%type;
    lv_sot                   varchar2(50);
    lv_XA_Agenda_ID          operacion.parametro_det_adc.codigoc%type;
    lv_XA_Agenda_Status      operacion.parametro_det_adc.codigoc%type;
    lv_esta_agenda           varchar2(50);
    lv_XA_Act_Ident          operacion.parametro_det_adc.codigoc%type;
    lv_identi_acc            varchar2(200);
    ln_coordx                marketing.vtasuccli.coordx_eta%type;
    ln_coordy                marketing.vtasuccli.coordy_eta%type;
    ln_zl                    number;
    ln_dias_zl               operacion.parametro_det_adc.codigon%type;
    ld_fecha_zl              date;
    l_valida_cnt             number;
    --Inicio 23.0
    v_flag_zona               number;
    v_servicio_x_instalar_c   clob;
    v_activacion_campos       number :=0;
    v_indicador_orden_completa number;
    --Fin 23.0
    ln_flg_reserva             number; --6.0
    ln_nro_orden               varchar2(50); --6.0
	ln_contador_nro            number;  --33.0
	ln_tiptrabajo             operacion.solot.tiptra%type;--36.0
	
  begin
    l_valida_cnt := 0;
   
    -- Codigo de Cliente
    begin
      select a.codcli
        into lv_codigo_cliente
        from operacion.agendamiento a
       where a.idagenda = p_idagenda;
    exception
      when NO_DATA_FOUND then
        p_resultado := '-96';
        p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo] No se encontro el codigo del cliente';
        return;
    end;
    -- Nombre Completo de Cliente
    begin
      select f_reemplazar_Caracter(v.nomcli)
        into lv_nom_cliente
        from marketing.vtatabcli v
       where v.codcli = lv_codigo_cliente;
    exception
      when NO_DATA_FOUND then
        p_resultado := '-96';
        p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo] No se encontro el Nombre Completo del Cliente';
        return;
    end;
    --Inicio 23.0
    v_activacion_campos := SGAFUN_OBTIENE_VALOR_CAMPO('activar_campos_creacion_orden',
                                                         p_resultado,
                                                         p_mensaje);
    IF v_activacion_campos = 1 THEN
      --Zona compleja
      v_flag_zona  := SGAFUN_OBTIENE_ZONA_COMPLEJA(p_zona,
                                               p_resultado,
                                               p_mensaje);
      if v_flag_zona is null or v_flag_zona = '' or p_resultado = '-1'  then
         p_resultado := '-96';
         p_mensaje   := p_mensaje;
         return;
      end if;
      --Indicador Orden Completa
      v_indicador_orden_completa := SGAFUN_OBTIENE_VALOR_CAMPO('indicar_orden_completa',
                                                              p_resultado,
                                                              p_mensaje);
      if v_indicador_orden_completa is null or v_indicador_orden_completa = '' or p_resultado = '-1'  then
         p_resultado := '-96';
         p_mensaje   := p_mensaje;
         return;
      end if;

      --Telefono Contacto
        SGASS_LISTA_SERV_CONTACTOS(lv_codigo_cliente,v_servicio_x_instalar_c);
    END IF;
    --Fin 23.0

    --obtiene tiptrabajo + paquete venta
    begin
      select '[' || st.tiptra || '] ' ||
             (select descripcion
                from operacion.tiptrabajo
               where tiptra = st.tiptra) ||
             case nvl(paq.desc_operativa, '.')
               when '.' then
                ''
               else
                ' / (' || paq.desc_operativa || ')'
             end desc_tt
        into lv_identi_acc
        from solot st, agendamiento a, paquete_Venta paq
       where st.codsolot = a.codsolot
         and a.idpaq = paq.idpaq
         and a.idagenda = p_idagenda;
    exception
      when NO_DATA_FOUND then
        p_resultado := '-96';
        p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo] No se encontro el tiptrabajo / paquete venta ';
        return;
    end;

    -- Coordenadas x,y --c
    begin
      select v.coordx_eta, v.coordy_eta
        into ln_coordx, ln_coordy
        from marketing.vtasuccli v
       where v.codsuc = (select a.codsuc
                           from operacion.agendamiento a
                          where a.idagenda = p_idagenda);
    EXCEPTION
      WHEN no_data_found THEN
        ln_coordx := null;
        ln_coordy := null;
    end;
    if ln_coordx = 0 then
      ln_coordx := null;
    end if;
    if ln_coordy = 0 then
      ln_coordy := null;
    end if;

    lv_coordx := TRANSLATE(TO_CHAR(ln_coordx), ',', '.');
    lv_coordy := TRANSLATE(TO_CHAR(ln_coordy), ',', '.');

    if p_ind = 'PR' then
      -- Modo Propiedad
      begin
        lv_modo_propiedad := GET_PARAM_C('PARAM_CRE_OT', 'MOD_PRD');
      exception
        when NO_DATA_FOUND then
          p_resultado := '-96';
          p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo] No se encontro registro de Modo de Propiedad de Programada';
          return;
      end;
      -- Contacto
      lv_contacto := lv_nom_cliente;
      -- Direccion de Cliente
      begin
        -- ini 3.0
        select d.direccion --nvl(e.dirsuc, d.direccion) -- 4.0
          into lv_direcc_cliente
        from solot a, vtatabcli b, solotpto c, inssrv d, vtasuccli e
       where a.codsolot = (select a.codsolot
                               from agendamiento a
                              where a.idagenda = p_idagenda)
         and a.codcli = b.codcli(+)
         and a.codsolot = c.codsolot(+)
         and c.codinssrv = d.codinssrv(+)
         and d.codsuc = e.codsuc(+)
         AND rownum = 1;
         --fin 3.0
      exception
        when NO_DATA_FOUND then
          p_resultado := '-96';
          p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo] No se encontro direccion de cliente de Programada';
          return;
      end;
      -- Telefono de Cliente
      begin
        select trim(vmc.numcom)--15.0
          into lv_telefono_cliente
          from marketing.vtamedcomcli vmc
          join marketing.vtatabmedcom vtm
            on vmc.idmedcom = vtm.idmedcom
           and vtm.idmedcom in (select d.codigoc
                                  from tipopedd c,
                                       opedd    d
                                 where c.tipopedd = d.tipopedd
                                   and c.abrev = 'MEDCOM_TOA'
                                   and d.codigon_aux = 1)
           and rownum = 1
           and vmc.codcli = lv_codigo_cliente;
      exception
        when NO_DATA_FOUND then
          l_valida_cnt := 1;
      end;
      -- Telefono de Contacto
      if l_valida_cnt = 1 then
        begin
          select trim(mcc.numcomcnt)
            into lv_telefono_cliente
            from marketing.vtatabcntcli cc,
                 marketing.vtamedcomcnt mcc,
                 marketing.vtatabmedcom vtm
           where mcc.codcnt = cc.codcnt
             and mcc.idmedcom = vtm.idmedcom
             and cc.codcli = lv_codigo_cliente
             and mcc.idmedcom in (select d.codigoc
                                    from tipopedd c,
                                         opedd    d
                                   where c.tipopedd = d.tipopedd
                                     and c.abrev = 'MEDCOM_TOA'
                                     and d.codigon_aux = 1)
             and rownum = 1;
        exception
          when NO_DATA_FOUND then
           -- ini 5.0
              if f_val_conf_telf_cliente(p_idagenda)>0 then
                 lv_telefono_cliente := null;
              else
           -- Fin 5.0
              p_resultado := '-96';
              p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo] No se encuentra Numero Telefonico del Cliente de Programada';
              return;
              end if; --5.0
        end;
      end if;
      -- Validando si pertenece a Zona Lejana
      ln_zl := operacion.pq_adm_cuadrilla.f_val_zonalejana(p_idagenda);
      if ln_zl = 1 then
        -- Programada con Zona Lejana
        -- Tomando dias de Zona Lejana
        begin
          ln_dias_zl := GET_PARAM_N('PARAM_CRE_OT', 'DIA_ZL');
        exception
          when NO_DATA_FOUND then
            p_resultado := '-96';
            p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo]No se encontro Dias para Programacion para Zona Lejana';
            return;
        end;

      ld_fecha_zl := sysdate + ln_dias_zl;
        -- Comando de Fecha
        lv_comando_fech := to_char(ld_fecha_zl, 'YYYY-MM-DD HH:MM');
        lv_franja_horaria:='AM1';

        -- Fecha de Inicio del SLA del SLA
        begin
        -- INI 3.0
          SELECT to_char(trunc(ld_fecha_zl, 'DD'), 'YYYY-MM-DD') || ' ' ||
                 CASE ind_merid_fi
                   WHEN 'PM' THEN
                    lpad(to_number(substr(f.franja_ini, 1, 2)) + 12, 2, '0') || ':' ||
                    substr(f.franja_ini, 4)
                   ELSE
                    lpad(to_number(substr(f.franja_ini, 1, 2)), 2, '0') || ':' ||
                    substr(f.franja_ini, 4)
                 END
            INTO lv_fech_ini_sla
            FROM operacion.franja_horaria f
           WHERE f.codigo = lv_franja_horaria
             AND f.flg_ap_ctr = 1;
       -- FIN 3.0

        exception
          when NO_DATA_FOUND then
            p_resultado := '-96';
            p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo] No se encontro registro de la Franja Horaria de Programada Zona Lejana';
            return;
        end;

        -- Fecha de Fin del SLA
        begin
          select to_char(trunc(ld_fecha_zl, 'DD'), 'YYYY-MM-DD') || ' ' ||
                 CASE IND_MERID_FF
                   WHEN 'PM' THEN
                    LPAD(TO_NUMBER(SUBSTR(f.franja_fin, 1, 2)) + 12, 2, '0') || ':' ||
                    SUBSTR(f.franja_fin, 4)
                   else
                    LPAD(TO_NUMBER(SUBSTR(f.franja_fin, 1, 2)), 2, '0') || ':' ||
                    SUBSTR(f.franja_fin, 4)
                 END
            into lv_fech_fin_sla
            from operacion.franja_horaria f
           where f.codigo = lv_franja_horaria
             and f.flg_ap_ctr = 1;
        exception
          when NO_DATA_FOUND then
            p_resultado := '-96';
            p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo] No se encontro registro de la Franja Horaria de Programada Zona Lejana';
            return;
        end;

        -- Bucket de Zona Lejana
        begin
          lv_bucket := GET_PARAM_C('PARAM_CRE_OT', 'BKT_ZL');
        exception
          when NO_DATA_FOUND then
            p_resultado := '-96';
            p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo] No se encontro Bucket de Zona Lejana';
            return;
        end;
      else
        -- Programada
        -- Comando de Fecha
        lv_comando_fech := to_char(p_fecha, 'YYYY-MM-DD HH:MM');
        -- Fecha de Inicio del SLA
        begin
        -- INI 3.0
          SELECT to_char(trunc(p_fecha, 'DD'), 'YYYY-MM-DD') || ' ' ||
                 CASE ind_merid_fi ---2.0
                   WHEN 'PM' THEN
                    lpad(to_number(substr(f.franja_ini, 1, 2)) + 12, 2, '0') || ':' ||
                    substr(f.franja_ini, 4)
                   ELSE
                    lpad(to_number(substr(f.franja_ini, 1, 2)), 2, '0') || ':' ||
                    substr(f.franja_ini, 4)
                 END
            INTO lv_fech_ini_sla
            FROM operacion.franja_horaria f
           WHERE f.codigo = p_franja_horaria
             AND f.flg_ap_ctr = 1;
       -- FIN 3.0

        exception
          when NO_DATA_FOUND then
            p_resultado := '-96';
            p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo] No se encontro registro de la Franja Horaria de Programada';
            return;
        end;

        -- Fecha Fin del SLA
        begin
          select to_char(trunc(p_fecha, 'DD'), 'YYYY-MM-DD') || ' ' ||
                 CASE IND_MERID_FF
                   WHEN 'PM' THEN
                    LPAD(TO_NUMBER(SUBSTR(f.franja_fin, 1, 2)) + 12, 2, '0') || ':' ||
                    SUBSTR(f.franja_fin, 4)
                   else
                    LPAD(TO_NUMBER(SUBSTR(f.franja_fin, 1, 2)), 2, '0') || ':' ||
                    SUBSTR(f.franja_fin, 4)
                 END
            into lv_fech_fin_sla
            from operacion.franja_horaria f
           where f.codigo = p_franja_horaria
             and f.flg_ap_ctr = 1;
        exception
          when NO_DATA_FOUND then
            p_resultado := '-96';
            p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo] No se encontro registro de la Franja Horaria de Programada';
            return;
        end;

        -- Bucket
        -- Es un parametro de entrada p_bucket
        lv_bucket := p_bucket;
        -- Franja Horaria
        lv_franja_horaria := p_franja_horaria;
      end if;
      -- Observaciones SGA
      begin
        select f_reemplazar_caracter(s.observacion)
          into lv_observaciones_sga
          from operacion.solot s
         where s.codsolot = (select a.codsolot
                               from agendamiento a
                              where a.idagenda = p_idagenda);
      exception
        when NO_DATA_FOUND then
          p_resultado := '-96';
          p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo] No se encontro el Observaciones de la SOT';
          return;
      end;
    elsif p_ind = 'RP' then
      -- ReProgramada
      -- Comando de Fecha
      lv_comando_fech := to_char(p_fecha, 'YYYY-MM-DD HH:MM');
      -- Modo Propiedad
      begin
        lv_modo_propiedad := GET_PARAM_C('PARAM_CRE_OT', 'MOD_PRD2');
      exception
        when NO_DATA_FOUND then
          p_resultado := '-96';
          p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo] No se encontro registro de Modo de Propiedad de ReProgramada';
          return;
      end;
      -- Franja Horaria
      lv_franja_horaria := p_franja_horaria;
      -- Fecha de Inicio del SLA
      begin
      -- INI 3.0
          SELECT to_char(trunc(p_fecha, 'DD'), 'YYYY-MM-DD') || ' ' ||
                 CASE ind_merid_fi--2.0
                   WHEN 'PM' THEN
                    lpad(to_number(substr(f.franja_ini, 1, 2)) + 12, 2, '0') || ':' ||
                    substr(f.franja_ini, 4)
                   ELSE
                    lpad(to_number(substr(f.franja_ini, 1, 2)), 2, '0') || ':' ||
                    substr(f.franja_ini, 4)
                 END
            INTO lv_fech_ini_sla
            FROM operacion.franja_horaria f
           WHERE f.codigo = lv_franja_horaria
             AND f.flg_ap_ctr = 1;
       -- FIN 3.0

      exception
        when NO_DATA_FOUND then
          p_resultado := '-96';
          p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo] No se encontro registro de la Franja Horaria de ReProgramada';
          return;
      end;

      --Fecha de Fin del SLA
      begin
        select to_char(trunc(p_fecha, 'DD'), 'YYYY-MM-DD') || ' ' ||
               CASE IND_MERID_FF
                 WHEN 'PM' THEN
                  LPAD(TO_NUMBER(SUBSTR(f.franja_fin, 1, 2)) + 12, 2, '0') || ':' ||
                  SUBSTR(f.franja_fin, 4)
                 else
                  LPAD(TO_NUMBER(SUBSTR(f.franja_fin, 1, 2)), 2, '0') || ':' ||
                  SUBSTR(f.franja_fin, 4)
               END
          into lv_fech_fin_sla
          from operacion.franja_horaria f
         where f.codigo = lv_franja_horaria
           and f.flg_ap_ctr = 1;
      exception
        when NO_DATA_FOUND then
          p_resultado := '-96';
          p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo] No se encontro registro de la Franja Horaria de ReProgramada';
          return;
      end;

      lv_contacto         := p_contacto;
      lv_direcc_cliente   := p_direccion;
      lv_telefono_cliente := p_telefono;
      -- Bucket
      -- Es un parametro de entrada p_bucket
      lv_bucket            := p_bucket;
      lv_observaciones_sga := p_observaciones;
    elsif p_ind = 'NP' then
      -- Modo Propiedad
      begin
        lv_modo_propiedad := GET_PARAM_C('PARAM_CRE_OT', 'MOD_PRD');
      exception
        when NO_DATA_FOUND then
          p_resultado := '-96';
          p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo] No se encontro registro de Modo de Propiedad de No Programada';
          return;
      end;
      -- Contacto
      lv_contacto := lv_nom_cliente;
      -- Direccion de Cliente
      begin
        -- ini 3.0
        select d.direccion --nvl(e.dirsuc, d.direccion) --4.0
          into lv_direcc_cliente
        from solot a, vtatabcli b, solotpto c, inssrv d, vtasuccli e
       where a.codsolot = (select a.codsolot
                               from agendamiento a
                              where a.idagenda = p_idagenda)
         and a.codcli = b.codcli(+)
         and a.codsolot = c.codsolot(+)
         and c.codinssrv = d.codinssrv(+)
         and d.codsuc = e.codsuc(+)
         AND rownum = 1;
         -- fin 3.0
      exception
        when NO_DATA_FOUND then
          p_resultado := '-96';
          p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo] No se encontro direccion de cliente de No Programada';
          return;
      end;
      -- Telefono de Cliente
      begin
        select trim(vmc.numcom)--15.0
          into lv_telefono_cliente
          from marketing.vtamedcomcli vmc
          join marketing.vtatabmedcom vtm
            on vmc.idmedcom = vtm.idmedcom
           and vtm.idmedcom in ('003', '006', '007', '016')
           and rownum = 1
           and vmc.codcli = lv_codigo_cliente;
      exception
        when NO_DATA_FOUND then
       -- ini 5.0
          if f_val_conf_telf_cliente(p_idagenda)>0 then
             lv_telefono_cliente := null;
          else
       -- Fin 5.0
          p_resultado := '-96';
          p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo] No se encuentra Numero Telefonico del Cliente de No Programada';
          return;
          end if;--5.0
      end;
      -- Validando si pertenece a Zona Lejana
      ln_zl := operacion.pq_adm_cuadrilla.f_val_zonalejana(p_idagenda);
      if ln_zl = 1 then
        -- No Programada con Zona Lejana
        -- Tomando dias de Zona Lejana
        begin
          ln_dias_zl := GET_PARAM_N('PARAM_CRE_OT', 'DIA_ZL');
        exception
          when NO_DATA_FOUND then
            p_resultado := '-96';
            p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo] No se encontro Dias para Programacion para Zona Lejana';
            return;
        end;
        -- Comando de Fecha
        lv_comando_fech := to_char(ld_fecha_zl, 'YYYY-MM-DD HH:MM');
        -- Franja Horaria de Zona Lejana
        begin
          SELECT f.codigo
            into lv_franja_horaria
            FROM operacion.franja_horaria f
           WHERE to_date(to_char(ld_fecha_zl, 'dd/mm/yyyy') || ' ' ||
                         to_char(ld_fecha_zl, 'hh:mi AM'),
                         'dd/mm/yyyy hh:mi AM') >=
                 to_date(to_char(ld_fecha_zl, 'dd/mm/yyyy') || ' ' ||
                         f.franja_ini || ' ' || f.ind_merid_fi,
                         'dd/mm/yyyy hh:mi AM')
             AND to_date(to_char(ld_fecha_zl, 'dd/mm/yyyy') || ' ' ||
                         to_char(ld_fecha_zl, 'hh:mi AM'),
                         'dd/mm/yyyy hh:mi AM') <=
                 to_date(to_char(ld_fecha_zl, 'dd/mm/yyyy') || ' ' ||
                         f.franja_fin || ' ' || f.ind_merid_ff,
                         'dd/mm/yyyy hh:mi AM')
             AND flg_ap_ctr = 1;
        exception
          when NO_DATA_FOUND then
            p_resultado := '-96';
            p_mensaje   := 'No se encontro Codigo de la Franja Horaria de Programada Zona Lejana';
            return;
        end;
        -- Fecha de Inicio del SLA
        begin
        -- INI 3.0
          SELECT to_char(trunc(p_fecha, 'DD'), 'YYYY-MM-DD') || ' ' ||
                 CASE ind_merid_fi
                   WHEN 'PM' THEN
                    lpad(to_number(substr(f.franja_ini, 1, 2)) + 12, 2, '0') || ':' ||
                    substr(f.franja_ini, 4)
                   ELSE
                    lpad(to_number(substr(f.franja_ini, 1, 2)), 2, '0') || ':' ||
                    substr(f.franja_ini, 4)
                 END
            INTO lv_fech_ini_sla
            FROM operacion.franja_horaria f
           WHERE f.codigo = lv_franja_horaria
             AND f.flg_ap_ctr = 1;
        -- FIN 3.0

        exception
          when NO_DATA_FOUND then
            p_resultado := '-96';
            p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo] No se encontro registro de la Franja Horaria de Programada Zona Lejana';
            return;
        end;

        -- Fecha de Fin del SLA
        begin
          select to_char(trunc(p_fecha, 'DD'), 'YYYY-MM-DD') || ' ' ||
                 CASE IND_MERID_FF
                   WHEN 'PM' THEN
                    LPAD(TO_NUMBER(SUBSTR(f.franja_fin, 1, 2)) + 12, 2, '0') || ':' ||
                    SUBSTR(f.franja_fin, 4)
                   else
                    LPAD(TO_NUMBER(SUBSTR(f.franja_fin, 1, 2)), 2, '0') || ':' ||
                    SUBSTR(f.franja_fin, 4)
                 END
            into lv_fech_fin_sla
            from operacion.franja_horaria f
           where f.codigo = lv_franja_horaria
             and f.flg_ap_ctr = 1;
        exception
          when NO_DATA_FOUND then
            p_resultado := '-96';
            p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo] No se encontro registro de la Franja Horaria de Programada Zona Lejana';
            return;
        end;

        -- Bucket de Zona Lejana
        begin
          lv_bucket := GET_PARAM_C('PARAM_CRE_OT', 'BKT_ZL');
        exception
          when NO_DATA_FOUND then
            p_resultado := '-96';
            p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo] No se encontro Bucket de Zona Lejana';
            return;
        end;
      else
        -- No Programada
        -- Franja Horaria - No se envia
        -- Es un parametro de entrada p_bucket
        lv_bucket := p_bucket;
      end if;
      -- Observaciones SGA
      begin
        select f_reemplazar_caracter(s.observacion)
          into lv_observaciones_sga
          from operacion.solot s
         where s.codsolot = (select a.codsolot
                               from agendamiento a
                              where a.idagenda = p_idagenda);
      exception
        when NO_DATA_FOUND then
          p_resultado := '-96';
          p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo] No se encontro el Observaciones de la SOT';
          return;
      end;
    elsif p_ind = 'PP' then
      -- Comando de Fecha
      lv_comando_fech := to_char(sysdate, 'YYYY-MM-DD HH:MM');
      -- Modo Propiedad
      begin
        lv_modo_propiedad := GET_PARAM_C('PARAM_CRE_OT', 'MOD_PRD');
      exception
        when NO_DATA_FOUND then
          p_resultado := '-96';
          p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo] No se encontro registro de Modo de Propiedad de Puerta a Puerta';
          return;
      end;
      -- Franja Horaria
      begin
        SELECT f.codigo
          into lv_franja_horaria
          FROM operacion.franja_horaria f
         WHERE to_date(to_char(SYSDATE, 'dd/mm/yyyy') || ' ' ||
                       to_char(SYSDATE, 'hh:mi AM'),
                       'dd/mm/yyyy hh:mi AM') >=
               to_date(to_char(SYSDATE, 'dd/mm/yyyy') || ' ' ||
                       f.franja_ini || ' ' || f.ind_merid_fi,
                       'dd/mm/yyyy hh:mi AM')
           AND to_date(to_char(SYSDATE, 'dd/mm/yyyy') || ' ' ||
                       to_char(SYSDATE, 'hh:mi AM'),
                       'dd/mm/yyyy hh:mi AM') <=
               to_date(to_char(SYSDATE, 'dd/mm/yyyy') || ' ' ||
                       f.franja_fin || ' ' || f.ind_merid_ff,
                       'dd/mm/yyyy hh:mi AM')
           AND flg_ap_ctr = 1;
      exception
        when NO_DATA_FOUND then
          p_resultado := '-96';
          p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo] No se encontro Codigo de la Franja Horaria de Puerta a Puerta';
          return;
      end;
      -- Fecha de Inicio del SLA
      begin
      -- INI 3.0
          SELECT to_char(trunc(sysdate, 'DD'), 'YYYY-MM-DD') || ' ' ||
                 CASE ind_merid_fi
                   WHEN 'PM' THEN
                    lpad(to_number(substr(f.franja_ini, 1, 2)) + 12, 2, '0') || ':' ||
                    substr(f.franja_ini, 4)
                   ELSE
                    lpad(to_number(substr(f.franja_ini, 1, 2)), 2, '0') || ':' ||
                    substr(f.franja_ini, 4)
                 END
            INTO lv_fech_ini_sla
            FROM operacion.franja_horaria f
           WHERE f.codigo = lv_franja_horaria
             AND f.flg_ap_ctr = 1;
      -- FIN 3.0

      exception
        when NO_DATA_FOUND then
          p_resultado := '-96';
          p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo] No se encontro registro de la Franja Horaria de Puerta a Puerta';
          return;
      end;

      --Fecha de Fin del SLA
      begin
        select to_char(trunc(sysdate, 'DD'), 'YYYY-MM-DD') || ' ' ||
               CASE IND_MERID_FF
                 WHEN 'PM' THEN
                  LPAD(TO_NUMBER(SUBSTR(f.franja_fin, 1, 2)) + 12, 2, '0') || ':' ||
                  SUBSTR(f.franja_fin, 4)
                 else
                  LPAD(TO_NUMBER(SUBSTR(f.franja_fin, 1, 2)), 2, '0') || ':' ||
                  SUBSTR(f.franja_fin, 4)
               END
          into lv_fech_fin_sla
          from operacion.franja_horaria f
         where f.codigo = lv_franja_horaria
           and f.flg_ap_ctr = 1;
      exception
        when NO_DATA_FOUND then
          p_resultado := '-96';
          p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo] No se encontro registro de la Franja Horaria de Puerta a Puerta';
          return;
      end;

      -- Contacto
      lv_contacto := lv_nom_cliente;
      -- Direccion de Cliente
      begin
        --ini 3.0
        select d.direccion --nvl(e.dirsuc, d.direccion) --4.0
          into lv_direcc_cliente
        from solot a, vtatabcli b, solotpto c, inssrv d, vtasuccli e
       where a.codsolot = (select a.codsolot
                               from agendamiento a
                              where a.idagenda = p_idagenda)
         and a.codcli = b.codcli(+)
         and a.codsolot = c.codsolot(+)
         and c.codinssrv = d.codinssrv(+)
         and d.codsuc = e.codsuc(+)
         AND rownum = 1;
         --fin 3.0
      exception
        when NO_DATA_FOUND then
          p_resultado := '-96';
          p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo] No se encontro direccion de Cliente de Puerta a Puerta';
          return;
      end;
      -- Telefono de Cliente
      begin
        select trim(vmc.numcom)--15.0
          into lv_telefono_cliente
          from marketing.vtamedcomcli vmc
          join marketing.vtatabmedcom vtm
            on vmc.idmedcom = vtm.idmedcom
           and vtm.idmedcom in ('003', '006', '007', '016')
           and rownum = 1
           and vmc.codcli = lv_codigo_cliente;
      exception
        when NO_DATA_FOUND then
       -- ini 5.0
          if f_val_conf_telf_cliente(p_idagenda)>0 then
             lv_telefono_cliente := null;
          else
       -- fin 5.0
          p_resultado := '-96';
          p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo] No se encuentra Numero Telefonico del Cliente de Puerta a Puerta';
          return;
          end if; --5.0
      end;
      -- Bucket
      -- Es un parametro de entrada p_bucket
      lv_bucket := p_bucket;
      -- Observaciones SGA
      begin
        select f_reemplazar_caracter(s.observacion)
          into lv_observaciones_sga
          from operacion.solot s
         where s.codsolot = (select a.codsolot
                               from agendamiento a
                              where a.idagenda = p_idagenda);
      exception
        when NO_DATA_FOUND then
          p_resultado := '-96';
          p_mensaje   := 'No se encontro el Observaciones de la SOT';
          return;
      end;
    else
      p_resultado := 'X';
      p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo] Debe de Enviar un Indicador de Proceso: PR(Agendamiento), RP(ReAgendamiento), NP(No Programada), PP(Puerta a Puerta)';
      return;
    end if;

    -- Direccion IP
    lv_ip := sys_context('userenv', 'ip_address');
    -- Fecha Actual
    lv_fecha := to_char(sysdate, 'YYYYMMDDHH24MI');
    -- Delimitador
    begin
      lv_delimitador := GET_PARAM_C('PARAM_CRE_OT', 'DEL_1');
    exception
      when NO_DATA_FOUND then
        p_resultado := '-96';
        p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo] No se encontro registro de Delimitador';
        return;
    end;
    -- Separador 1
    begin
      lv_separador := GET_PARAM_C('PARAM_CRE_OT', 'SEP_1');
    exception
      when NO_DATA_FOUND then
        p_resultado := '-96';
        p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo] No se encontro registro de Separador 1';
        return;
    end;
    -- Separador 2
    begin
      lv_separador2 := GET_PARAM_C('PARAM_CRE_OT', 'SEP_2');
    exception
      when NO_DATA_FOUND then
        p_resultado := '-96';
        p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo] No se encontro registro de Separador 2';
        return;
    end;
    -- Separador 3
    begin
      lv_separador3 := GET_PARAM_C('PARAM_CRE_OT', 'SEP_3');
    exception
      when NO_DATA_FOUND then
        p_resultado := '-96';
        p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo] No se encontro registro de Separador 3';
        return;
    end;
    -- Sistema
    begin
      lv_aplicacion := GET_PARAM_C('PARAM_CRE_OT', 'SIST_ENV');
    exception
      when NO_DATA_FOUND then
        p_resultado := '-96';
        p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo] No se encontro registro de Nombre de Sistema';
        return;
    end;
    -- Modo Proceso
    begin
      lv_modo_proceso := GET_PARAM_C('PARAM_CRE_OT', 'MOD_PRC');
    exception
      when NO_DATA_FOUND then
        p_resultado := '-96';
        p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo] No se encontro registro de Modo de Proceso';
        return;
    end;
    -- Tipo Carga
    begin
      lv_tipo_carga := GET_PARAM_C('PARAM_CRE_OT', 'TIP_C');
    exception
      when NO_DATA_FOUND then
        p_resultado := '-96';
        p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo] No se encontro registro de Tipo de Carga';
        return;
    end;
    -- Campo Clave
    begin
      lv_campo_clave := GET_PARAM_C('PARAM_CRE_OT', 'CMP_CLV');
    exception
      when NO_DATA_FOUND then
        p_resultado := '-96';
        p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo] No se encontro registro de Campo Clave';
        return;
    end;
    -- Campo Clave Inv. 1
    begin
      lv_campo_clave_inv := GET_PARAM_C('PARAM_CRE_OT', 'CMP_CLV_I1');
    exception
      when NO_DATA_FOUND then
        p_resultado := '-96';
        p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo] No se encontro registro de Campo Clave de Inv. 1';
        return;
    end;
    -- Campo Clave Inv. 2
    begin
      lv_campo_clave_inv2 := GET_PARAM_C('PARAM_CRE_OT', 'CMP_CLV_I2');
    exception
      when NO_DATA_FOUND then
        p_resultado := '-96';
        p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo] No se encontro registro de Campo Clave de Inv. 2';
        return;
    end;
    -- Tipo Carga Inventario
    begin
      lv_tipo_carga_inv := GET_PARAM_C('PARAM_CRE_OT', 'TIP_C_I');
    exception
      when NO_DATA_FOUND then
        p_resultado := '-96';
        p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo] No se encontro registro de Tipo de Carga de Inv.';
        return;
    end;
    -- Tipo Comando
    begin
      lv_tipo_comando := GET_PARAM_C('PARAM_CRE_OT', 'TIP_CMD');
    exception
      when NO_DATA_FOUND then
        p_resultado := '-96';
        p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo] No se encontro registro de Tipo de Comando';
        return;
    end;
    -- Bucket de Error
    begin
      lv_bucket_error := GET_PARAM_C('PARAM_CRE_OT', 'BKT_ERR');
    exception
      when NO_DATA_FOUND then
        p_resultado := '-96';
        p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo] No se encontro registro de Bucket de Error';
        return;
    end;
    -- Tipo de Zona
    begin
      lv_tipo_zona := GET_PARAM_C('PARAM_CRE_OT', 'TIP_ZON');
    exception
      when NO_DATA_FOUND then
        p_resultado := '-96';
        p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo] No se encontro registro de Tipo de Zona';
        return;
    end;
    -- Nro de Documento
    begin
      select v.ntdide
        into lv_nro_doc
        from marketing.vtatabcli v
       where v.codcli = lv_codigo_cliente;
    exception
      when NO_DATA_FOUND then
        p_resultado := '-96';
        p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo] No se encontro Nro. de Documento del Cliente';
        return;
    end;
    -- Tipo de Documento
    begin
      select vt.dscdid
        into lv_tipo_doc
        from marketing.vtatipdid vt
       where vt.tipdide =
             (select v.tipdide
                from marketing.vtatabcli v
               where v.codcli = lv_codigo_cliente);
    exception
      when NO_DATA_FOUND then
        p_resultado := '-96';
        p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo] No se encontro Tipo de Documento del Cliente';
        return;
    end;
    -- Ciudad
    begin
      select vu.nomest
        into lv_ciudad_cliente
        from v_ubicaciones vu
       where vu.codubi = (select a.codubi
                            from operacion.agendamiento a
                           where a.idagenda = p_idagenda);
    exception
      when NO_DATA_FOUND then
        p_resultado := '-96';
        p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo] No se encontro Ciudad del Cliente';
        return;
    end;
    -- Distrito
    begin
      select vu.nomdst
        into lv_distrito
        from v_ubicaciones vu
       where vu.codubi = (select a.codubi
                            from operacion.agendamiento a
                           where a.idagenda = p_idagenda);
    exception
      when NO_DATA_FOUND then
        p_resultado := '-96';
        p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo] No se encontro Distrito del Cliente';
        return;
    end;
    -- Tiempo de Recordatorio
    begin
      lv_recordatorio := GET_PARAM_C('PARAM_CRE_OT', 'AVS_TMP');
    exception
      when NO_DATA_FOUND then
        p_resultado := '-96';
        p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo] No se encontro registro de Tiempo de recordatorio';
        return;
    end;
    -- Peso
    begin
      select nvl(so.grado_dificultad, null)
        into ln_peso
        from operacion.tipo_orden_adc ta
        join operacion.subtipo_orden_adc so
          on ta.id_tipo_orden = so.id_tipo_orden
         and ta.cod_tipo_orden = p_tipo_orden
         and so.cod_subtipo_orden = p_subtipo_orden;
    exception
      when NO_DATA_FOUND then
        p_resultado := '-96';
        p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo] No se encontro registro de Peso';
        return;
    end;
    -- Tiempo de Trabajo
    begin
      select so.tiempo_min
        into ln_tiem_trab
        from operacion.tipo_orden_adc ta
        join operacion.subtipo_orden_adc so
          on ta.id_tipo_orden = so.id_tipo_orden
         and ta.cod_tipo_orden = p_tipo_orden
         and so.cod_subtipo_orden = p_subtipo_orden;
    exception
      when NO_DATA_FOUND then
        p_resultado := '-96';
        p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo] No se encontro registro de Tiempo de Trabajo';
        return;
    end;
    -- Codigo Postal
    begin
      select trim(vs.codpos)--15.0
        into lv_codpos
        from marketing.vtasuccli vs
       where vs.codsuc = (select a.codsuc
                            from operacion.agendamiento a
                           where a.idagenda = p_idagenda);
    exception
      when NO_DATA_FOUND then
        p_resultado := '-96';
        p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo] No se encontro Codigo Postal del Cliente';
        return;
    end;
    -- XA_WorkOrderSubtype
    begin
      lv_XA_WorkOrderSubtype := GET_PARAM_C('PARAM_CRE_OT', 'XWSB');
    exception
      when NO_DATA_FOUND then
        p_resultado := '-96';
        p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo] No se encontro el Campo de XA_WorkOrderSubtype';
        return;
    end;
    -- XA_Reference
    begin
      lv_XA_Reference := GET_PARAM_C('PARAM_CRE_OT', 'XRE');
    exception
      when NO_DATA_FOUND then
        p_resultado := '-96';
        p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo] No se encontro el Campo de XA_Reference';
        return;
    end;
    -- Referencia de direccion
    begin
      select v.referencia
        into lv_dir_referencia
        from marketing.vtatabcli v
       where v.codcli = lv_codigo_cliente;
    exception
      when NO_DATA_FOUND then
        p_resultado := '-96';
        p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo] No se encontro referencia de direccion del cliente';
        return;
    end;
    -- XA_Zone
    begin
      lv_XA_Zone := GET_PARAM_C('PARAM_CRE_OT', 'XZO');
    exception
      when NO_DATA_FOUND then
        p_resultado := '-96';
        p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo] No se encontro el Campo de XA_Zone';
        return;
    end;
    -- Zona, declarado como parametro de entrada
    -- XA_Map
    begin
      lv_XA_Map := GET_PARAM_C('PARAM_CRE_OT', 'XMA');
    exception
      when NO_DATA_FOUND then
        p_resultado := '-96';
        p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo] No se encontro el Campo de XA_Map';
        return;
    end;
    -- Plano, declarado como parametro de entrada
    -- XA_Priority
    begin
      lv_XA_Priority := GET_PARAM_C('PARAM_CRE_OT', 'XPRS');
    exception
      when NO_DATA_FOUND then
        p_resultado := '-96';
        p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo] No se encontro el Campo de XA_Priority';
        return;
    end;
    -- La Prioridad se establece con el Flag Vip

    -- XA_Contact_Name
    begin
      lv_XA_Contact_Name := GET_PARAM_C('PARAM_CRE_OT', 'XCN');
    exception
      when NO_DATA_FOUND then
        p_resultado := '-96';
        p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo] No se encontro el Campo de XA_Contact_Name';
        return;
    end;
    -- Contacto, sera el nombre del Cliente
    -- XA_Customer_ID
    begin
      lv_XA_Customer_ID := GET_PARAM_C('PARAM_CRE_OT', 'XCI');
    exception
      when NO_DATA_FOUND then
        p_resultado := '-96';
        p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo] No se encontro el Campo de XA_Customer_ID';
        return;
    end;
    -- XA_Customer_ID_Type
    begin
      lv_XA_Customer_ID_Type := GET_PARAM_C('PARAM_CRE_OT', 'XCIT');
    exception
      when NO_DATA_FOUND then
        p_resultado := '-96';
        p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo] No se encontro el Campo de XA_Customer_ID_Type';
        return;
    end;
    -- XA_Province
    begin
      lv_XA_Province := GET_PARAM_C('PARAM_CRE_OT', 'XPRO');
    exception
      when NO_DATA_FOUND then
        p_resultado := '-96';
        p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo] No se encontro el Campo de XA_Province';
        return;
    end;
    -- Provincia
    begin
      select vu.nompvc
        into lv_provincia
        from v_ubicaciones vu
       where vu.codubi = (select a.codubi
                            from operacion.agendamiento a
                           where a.idagenda = p_idagenda);
    exception
      when NO_DATA_FOUND then
        p_resultado := '-96';
        p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo] No se encontro la provincia del Cliente';
        return;
    end;
    -- XA_Department
    begin
      lv_XA_Department := GET_PARAM_C('PARAM_CRE_OT', 'XDE');
    exception
      when NO_DATA_FOUND then
        p_resultado := '-96';
        p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo] No se encontro el Campo de XA_Department';
        return;
    end;
    -- Ciudad y Departamento son lo mismo
    -- XA_Zone_Type
    begin
      lv_XA_Zone_Type := GET_PARAM_C('PARAM_CRE_OT', 'XZTY');
    exception
      when NO_DATA_FOUND then
        p_resultado := '-96';
        p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo] No se encontro el Campo de XA_Zone_Type';
        return;
    end;
    -- Tipo de Zona, ya se consulto en la variable lv_tipo_zona
    -- XA_Dispatch_Base
    begin
      lv_XA_Dispatch_Base := GET_PARAM_C('PARAM_CRE_OT', 'XDBA');
    exception
      when NO_DATA_FOUND then
        p_resultado := '-96';
        p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo] No se encontro el Campo de XA_Dispatch_Base';
        return;
    end;
    -- Base de Despacho - No se enviara
    -- XA_Services_ToInstall
    begin
      lv_XA_Services_ToInstall := GET_PARAM_C('PARAM_CRE_OT', 'XSTI');
    exception
      when NO_DATA_FOUND then
        p_resultado := '-96';
        p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo] No se encontro el Campo de XA_Services_ToInstall';
        return;
    end;
    -- Servicio(s) a Instalar
    operacion.pq_adm_cuadrilla.p_lista_servicios_agenda(p_idagenda,
                                                        lc_servicio_x_instalar);
    -- XA_Installed_Services
    begin
      lv_XA_Installed_Services := GET_PARAM_C('PARAM_CRE_OT', 'XISE');
    exception
      when NO_DATA_FOUND then
        p_resultado := '-96';
        p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo] No se encontro el Campo de XA_Installed_Services';
        return;
    end;
    -- XA_Activity_Notes
    begin
      lv_XA_Activity_Notes := GET_PARAM_C('PARAM_CRE_OT', 'XANO');
    exception
      when NO_DATA_FOUND then
        p_resultado := '-96';
        p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo] No se encontro el Campo de XA_Activity_Notes';
        return;
    end;
    -- XA_Input_Date
    begin
      lv_XA_Input_Date := GET_PARAM_C('PARAM_CRE_OT', 'XIDA');
    exception
      when NO_DATA_FOUND then
        p_resultado := '-96';
        p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo] No se encontro el Campo de XA_Input_Date';
        return;
    end;
    -- Fecha de Registro de la Orden
    lv_fecha_reg_ord := to_char(trunc(sysdate, 'DD'), 'DD/MM/YYYY');
    -- XA_Service_History
    begin
      lv_XA_Service_History := GET_PARAM_C('PARAM_CRE_OT', 'XSHI');
    exception
      when NO_DATA_FOUND then
        p_resultado := '-96';
        p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo] No se encontro el Campo de XA_Service_History';
        return;
    end;
    -- Historial de visitas tecnicas / servicio al cliente - No se enviara
    -- XA_VIP_Flag
    begin
      lv_XA_VIP_Flag := GET_PARAM_C('PARAM_CRE_OT', 'XVFL');
    exception
      when NO_DATA_FOUND then
        p_resultado := '-96';
        p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo] No se encontro el Campo de XA_VIP_Flag';
        return;
    end;
    -- Flag Indicador de Cliente VIP(Falta) y Prioridad
    if operacion.pq_adm_cuadrilla.f_valida_cliente_vip(lv_codigo_cliente) = 0 then
      lv_flag_vip  := '2';
      lv_prioridad := '1';
    else
      lv_flag_vip  := '1';
      lv_prioridad := '3';
    end if;
    -- XA_SOT_ID
    begin
      lv_XA_SOT_ID := GET_PARAM_C('PARAM_CRE_OT', 'XSID');
    exception
      when NO_DATA_FOUND then
        p_resultado := '-96';
        p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo] No se encontro el Campo de XA_SOT_ID';
        return;
    end;
    -- SOT
    begin
      select to_char(s.codsolot)
        into lv_sot
        from operacion.solot s
       where s.codsolot = (select a.codsolot
                             from agendamiento a
                            where a.idagenda = p_idagenda);
    exception
      when NO_DATA_FOUND then
        p_resultado := '-96';
        p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo] No se encontro registro de SOT';
        return;
    end;
    -- XA_Agenda_ID
    begin
      lv_XA_Agenda_ID := GET_PARAM_C('PARAM_CRE_OT', 'XAID');
    exception
      when NO_DATA_FOUND then
        p_resultado := '-96';
        p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo] No se encontro el Campo de XA_Agenda_ID';
        return;
    end;
    -- XA_Agenda_Status
    begin
      lv_XA_Agenda_Status := GET_PARAM_C('PARAM_CRE_OT', 'XAST');
    exception
      when NO_DATA_FOUND then
        p_resultado := '-96';
        p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo] No se encontro el Campo de XA_Agenda_Status';
        return;
    end;
    -- Estado de Agenda
    begin
      select to_char(a.estage)
        into lv_esta_agenda
        from agendamiento a
       where a.idagenda = p_idagenda;
    exception
      when NO_DATA_FOUND then
        p_resultado := '-96';
        p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo] No se encontro registro de estado de agenda';
        return;
    end;
    -- XA_Activity_Identification
    begin
      lv_XA_Act_Ident := GET_PARAM_C('PARAM_CRE_OT', 'XAIN');
    exception
      when NO_DATA_FOUND then
        p_resultado := '-96';
        p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo] No se encontro el Campo de XA_Activity_Identification';
        return;
    end;
	
	-- ini 36.0
    begin
      select a.tiptra
        into ln_tiptrabajo
        from solot  a
       where a.codsolot = lv_sot;
    exception
      when NO_DATA_FOUND then
        p_resultado := '-96';
        p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo] No se encontro registro de tipo trabajo solot';
        return;
    end;
   -- fin 36.0 
    --INI 6.0
    OPERACION.PKG_RESERVA_TOA.SGASS_FLAG_VAL_X_AGEN(p_idagenda, ln_flg_reserva);
	
   -- if ln_flg_reserva = 1 then  35.0
        --INI 33.0 
          if p_ind = 'RP' then --35.0 reprogramacion del SGA
                select count (*)
                      into ln_contador_nro
                      from OPERACION.SGAT_RESERVA_TOA a
                     where a.RESTN_NRO_SOLOT = lv_sot
                       and a.RESTN_ESTADO = 2;
                     if ln_contador_nro >0 then
                          begin
                            select distinct (a.RESTV_NRO_ORDEN)
                              into ln_nro_orden
                              from OPERACION.SGAT_RESERVA_TOA a
                             where a.RESTN_NRO_SOLOT = lv_sot
                               and a.RESTN_ESTADO = 2;--actualizada en TOA con sot
                          exception
                            when NO_DATA_FOUND then
                              p_resultado := '-96';
                              p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo] No se encontro el nro de orden de la reserva en TOA';
                              return;
                           end;
                           
                      else
                           ln_nro_orden :=to_char(p_idagenda);
                      end if;     
           else       
            select count(*)
                into ln_contador_nro
                from OPERACION.SGAT_RESERVA_TOA a
               where a.RESTN_NRO_SOLOT = lv_sot
                 and a.RESTN_ESTADO = 1;
           if ln_contador_nro>0 then --35.0 se hizo reserva se obtiene la orden
            --FIN 33.0
                   begin
                      select a.RESTV_NRO_ORDEN
                        into ln_nro_orden
                        from OPERACION.SGAT_RESERVA_TOA a
                       where a.RESTN_NRO_SOLOT = lv_sot
                         and a.RESTN_ESTADO = 1;
                    exception
                      when NO_DATA_FOUND then
                        p_resultado := '-96';
                        p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo] No se encontro el nro de orden de la reserva en TOA';
                        return;
                    end;
              else
                --INI 33.0
                      ln_nro_orden :=to_char(p_idagenda); 
             end if;       
        end if;--FIN 33.0  
   
   
    --FIN 6.0
    lv_auditoria := lv_fecha || lv_delimitador || lv_ip || lv_delimitador ||
                    lv_aplicacion || lv_delimitador || lv_user ||
                    lv_delimitador;

    --Ini 19.0
    lv_modo_propiedad        := extrae_carac_spec(lv_modo_propiedad);
    lv_modo_proceso          := extrae_carac_spec(lv_modo_proceso);
    lv_tipo_carga            := extrae_carac_spec(lv_tipo_carga);
    lv_campo_clave           := extrae_carac_spec(lv_campo_clave);
    lv_campo_clave_inv       := extrae_carac_spec(lv_campo_clave_inv);
    lv_campo_clave_inv2      := extrae_carac_spec(lv_campo_clave_inv2);
    lv_tipo_carga_inv        := extrae_carac_spec(lv_tipo_carga_inv);
    lv_tipo_comando          := extrae_carac_spec(lv_tipo_comando);
    lv_bucket                := extrae_carac_spec(lv_bucket);
    lv_bucket_error          := extrae_carac_spec(lv_bucket_error);
    lv_codigo_cliente        := extrae_carac_spec(lv_codigo_cliente);
    lv_franja_horaria        := extrae_carac_spec(lv_franja_horaria);
    lv_nom_cliente           := extrae_carac_spec(lv_nom_cliente);
    lv_telefono_cliente      := extrae_carac_spec(lv_telefono_cliente);
    lv_email_cliente         := extrae_carac_spec(lv_email_cliente);
    lv_direcc_cliente        := extrae_carac_spec(lv_direcc_cliente);
    lv_ciudad_cliente        := extrae_carac_spec(lv_ciudad_cliente);
    lv_coordy                := extrae_carac_spec(lv_coordy);
    lv_coordx                := extrae_carac_spec(lv_coordx);
    ln_peso                  := extrae_carac_spec(ln_peso);
    lv_fech_ini_sla          := extrae_carac_spec(lv_fech_ini_sla);
    lv_fech_fin_sla          := extrae_carac_spec(lv_fech_fin_sla);
    lv_codpos                := extrae_carac_spec(lv_codpos);
    lv_distrito              := extrae_carac_spec(lv_distrito);
    lv_recordatorio          := extrae_carac_spec(lv_recordatorio);
    lv_XA_WorkOrderSubtype   := extrae_carac_spec(lv_XA_WorkOrderSubtype);
    lv_XA_Reference          := extrae_carac_spec(lv_XA_Reference);
    lv_dir_referencia        := extrae_carac_spec(lv_dir_referencia);
    lv_XA_Zone               := extrae_carac_spec(lv_XA_Zone);
    lv_XA_Map                := extrae_carac_spec(lv_XA_Map);
    lv_XA_Priority           := extrae_carac_spec(lv_XA_Priority);
    lv_prioridad             := extrae_carac_spec(lv_prioridad);
    lv_XA_Contact_Name       := extrae_carac_spec(lv_XA_Contact_Name);
    lv_contacto              := extrae_carac_spec(lv_contacto);
    lv_XA_Customer_ID        := extrae_carac_spec(lv_XA_Customer_ID);
    lv_nro_doc               := extrae_carac_spec(lv_nro_doc);
    lv_XA_Customer_ID_Type   := extrae_carac_spec(lv_XA_Customer_ID_Type);
    lv_tipo_doc              := extrae_carac_spec(lv_tipo_doc);
    lv_XA_Province           := extrae_carac_spec(lv_XA_Province);
    lv_provincia             := extrae_carac_spec(lv_provincia);
    lv_XA_Department         := extrae_carac_spec(lv_XA_Department);
    lv_ciudad_cliente        := extrae_carac_spec(lv_ciudad_cliente);
    lv_XA_Zone_Type          := extrae_carac_spec(lv_XA_Zone_Type);
    lv_tipo_zona             := extrae_carac_spec(lv_tipo_zona);
    lv_XA_Dispatch_Base      := extrae_carac_spec(lv_XA_Dispatch_Base);
    lv_base_despacho         := extrae_carac_spec(lv_base_despacho);
    lv_XA_Services_ToInstall := extrae_carac_spec(lv_XA_Services_ToInstall);
    lv_XA_Installed_Services := extrae_carac_spec(lv_XA_Installed_Services);
    lv_servicio_instalado    := extrae_carac_spec(lv_servicio_instalado);
    lv_XA_Activity_Notes     := extrae_carac_spec(lv_XA_Activity_Notes);
    lv_observaciones_sga     := extrae_carac_spec(lv_observaciones_sga);
    lv_XA_Input_Date         := extrae_carac_spec(lv_XA_Input_Date);
    lv_fecha_reg_ord         := extrae_carac_spec(lv_fecha_reg_ord);
    lv_XA_Service_History    := extrae_carac_spec(lv_XA_Service_History);
    lv_hist_visit            := extrae_carac_spec(lv_hist_visit);
    lv_XA_VIP_Flag           := extrae_carac_spec(lv_XA_VIP_Flag);
    lv_flag_vip              := extrae_carac_spec(lv_flag_vip);
    lv_XA_SOT_ID             := extrae_carac_spec(lv_XA_SOT_ID);
    lv_sot                   := extrae_carac_spec(lv_sot);
    lv_XA_Agenda_ID          := extrae_carac_spec(lv_XA_Agenda_ID);
    lv_XA_Agenda_Status      := extrae_carac_spec(lv_XA_Agenda_Status);
    lv_esta_agenda           := extrae_carac_spec(lv_esta_agenda);
    lv_XA_Act_Ident          := extrae_carac_spec(lv_XA_Act_Ident);
    lv_identi_acc            := extrae_carac_spec(lv_identi_acc);
    --Fin 19.0

    ------------------------------------------------------------------------------------------------------------------------------------
    -- Creacion de Trama para WS de Gestion de Orden de Trabajo
    ------------------------------------------------------------------------------------------------------------------------------------
    -- Auditoria
    ------------------------------------------------------------------------------------------------------------------------------------
    p_trama := lv_auditoria;
    ------------------------------------------------------------------------------------------------------------------------------------
    -- Cabecera
    ------------------------------------------------------------------------------------------------------------------------------------
    p_trama := p_trama || lv_modo_propiedad || lv_delimitador; -- Modo de Carga de Propiedad
    p_trama := p_trama || lv_modo_proceso || lv_delimitador; -- Modo del Procesamiento
    p_trama := p_trama || lv_tipo_carga || lv_delimitador; -- Tipo de Carga
    p_trama := p_trama || to_char(sysdate, 'YYYY-MM-DD HH:MM') ||
               lv_delimitador; -- Fecha donde la orden debe ser cargada
    p_trama := p_trama || lv_campo_clave || lv_delimitador; -- Campo Clave de la Orden
    p_trama := p_trama || lv_campo_clave_inv || lv_separador2 ||
               lv_campo_clave_inv2 || lv_delimitador; -- Campos Clave de Inventario
    p_trama := p_trama || lv_tipo_carga_inv || lv_delimitador; -- Tipo de Carga de Inventario
    ------------------------------------------------------------------------------------------------------------------------------------
    -- Comando
    ------------------------------------------------------------------------------------------------------------------------------------
    p_trama := p_trama || lv_comando_fech || lv_delimitador; -- Fecha donde la Orden sera asignada(vacio=no programada)
    p_trama := p_trama || lv_tipo_comando || lv_delimitador; -- Tipo de Comando
    p_trama := p_trama || lv_bucket || lv_delimitador; -- Bucket
    p_trama := p_trama || lv_bucket_error || lv_delimitador; -- Bucket de Error
    ------------------------------------------------------------------------------------------------------------------------------------
    -- Asignacion
    ------------------------------------------------------------------------------------------------------------------------------------
    --INI 6.0
    --Nro de Orden
	 p_trama := p_trama || to_char(ln_nro_orden) || lv_delimitador;
	 --ini 36.0
   /* if ln_flg_reserva = 1 then   
    SELECT NVL(SUBSTR(lv_observaciones_sga,0,INSTR(lv_observaciones_sga, '~',1,1)-1), '')
         INTO lv_observaciones_sga
      FROM DUAL;
	  /* ini 35.0
    else
      p_trama := p_trama || to_char(p_idagenda) || lv_delimitador;
		*/
    --end if;
	--fin 36.0
	-- ini 36.0 
		 if ln_contador_nro>0 then
			 if (ln_tiptrabajo = 844 or ln_tiptrabajo = 770 or ln_tiptrabajo= 700 or ln_tiptrabajo=671 or ln_tiptrabajo=489 or ln_tiptrabajo=407 or ln_tiptrabajo=480)then
				  SELECT NVL(SUBSTR(lv_observaciones_sga,INSTR(lv_observaciones_sga, '~',2,1)+1), '')
					   INTO lv_observaciones_sga
				   FROM DUAL; 
			 end if;
			 if (ln_tiptrabajo = 1018 or ln_tiptrabajo = 1019 or ln_tiptrabajo =  693 or ln_tiptrabajo = 694) then
				   SELECT NVL(SUBSTR(lv_observaciones_sga,0,INSTR(lv_observaciones_sga, '~',1,1)-1), '')
					   INTO lv_observaciones_sga
					FROM DUAL;
		   end if;
			 
		 end if;    
 --fin 36.0 
	
    --FIN 6.0
    p_trama := p_trama || lv_codigo_cliente || lv_delimitador; -- Codigo de Cliente
    p_trama := p_trama || p_tipo_orden || lv_delimitador; -- Tipo de Orden de Trabajo
    p_trama := p_trama || lv_franja_horaria || lv_delimitador; -- Franja Horaria
    p_trama := p_trama || lv_nom_cliente || lv_delimitador; -- Nombre Completo del Cliente
    p_trama := p_trama || lv_telefono_cliente || lv_delimitador; -- Telefono de Cliente
    p_trama := p_trama || lv_email_cliente || lv_delimitador; -- Correo del Cliente
    p_trama := p_trama || lv_direcc_cliente || lv_delimitador; -- Direccion del Cliente
    p_trama := p_trama || lv_ciudad_cliente || lv_delimitador; -- Ciudad del Cliente
    p_trama := p_trama || lv_coordy || lv_delimitador; -- Coordenada Y(Vacio)
    p_trama := p_trama || lv_coordx || lv_delimitador; -- Coordenada X(Vacio)
    p_trama := p_trama || ln_peso || lv_delimitador; -- Prioridad(Peso)
    p_trama := p_trama || lv_fech_ini_sla || lv_delimitador; -- Fecha de Inicio del SLA
    p_trama := p_trama || lv_fech_fin_sla || lv_delimitador; -- Fecha de Fin del SLA
    p_trama := p_trama || lv_codpos || lv_delimitador; -- Codigo postal
    p_trama := p_trama || to_char(ln_tiem_trab) || lv_delimitador; -- Duracion del trabajo en minutos
    p_trama := p_trama || lv_distrito || lv_delimitador; -- Distrito
    p_trama := p_trama || lv_recordatorio || lv_delimitador; -- Tiempo de recordatorio en minutos
    ----------------------------------------------------------------------------------------------------------------
    -- Lista de propiedades adicionales
    ----------------------------------------------------------------------------------------------------------------
    p_trama := p_trama || lv_XA_WorkOrderSubtype || lv_separador3 ||
               p_subtipo_orden || lv_separador2; -- Subtipo de Orden
    p_trama := p_trama || lv_XA_Reference || lv_separador3 ||
               lv_dir_referencia || lv_separador2; -- Referencia de Direccion
    p_trama := p_trama || lv_XA_Zone || lv_separador3 || p_zona ||
               lv_separador2; -- Zona
    p_trama := p_trama || lv_XA_Map || lv_separador3 || p_plano ||
               lv_separador2; -- Plano
    p_trama := p_trama || lv_XA_Priority || lv_separador3 || lv_prioridad ||
               lv_separador2; -- Prioridad
    p_trama := p_trama || lv_XA_Contact_Name || lv_separador3 ||
               lv_contacto || lv_separador2; -- Contacto
    p_trama := p_trama || lv_XA_Customer_ID || lv_separador3 || lv_nro_doc ||
               lv_separador2; -- Nro de Documento
    p_trama := p_trama || lv_XA_Customer_ID_Type || lv_separador3 ||
               lv_tipo_doc || lv_separador2; -- Tipo de Documento
    p_trama := p_trama || lv_XA_Province || lv_separador3 || lv_provincia ||
               lv_separador2; -- Provincia
    p_trama := p_trama || lv_XA_Department || lv_separador3 ||
               lv_ciudad_cliente || lv_separador2; -- Ciudad
    p_trama := p_trama || lv_XA_Zone_Type || lv_separador3 || lv_tipo_zona ||
               lv_separador2; -- Tipo de Zona
    p_trama := p_trama || lv_XA_Dispatch_Base || lv_separador3 ||
               lv_base_despacho || lv_separador2; -- Base de Despacho
    p_trama := p_trama || lv_XA_Services_ToInstall || lv_separador3 ||
               lc_servicio_x_instalar || lv_separador2; -- Servicios para Instalar
    p_trama := p_trama || lv_XA_Installed_Services || lv_separador3 ||
               lv_servicio_instalado || lv_separador2; -- Servicios Instalados
    p_trama := p_trama || lv_XA_Activity_Notes || lv_separador3 ||
               lv_observaciones_sga || lv_separador2; -- Observaciones SGA
    p_trama := p_trama || lv_XA_Input_Date || lv_separador3 ||
               lv_fecha_reg_ord || lv_separador2; -- Fecha de Registro de Orden
    p_trama := p_trama || lv_XA_Service_History || lv_separador3 ||
               lv_hist_visit || lv_separador2; -- Historial de visitas
    p_trama := p_trama || lv_XA_VIP_Flag || lv_separador3 || lv_flag_vip ||
               lv_separador2; -- Flag Vip
    p_trama := p_trama || lv_XA_SOT_ID || lv_separador3 || lv_sot ||
               lv_separador2;
    p_trama := p_trama || lv_XA_Agenda_ID || lv_separador3 ||
               to_char(p_idagenda) || lv_separador2;
    p_trama := p_trama || lv_XA_Agenda_Status || lv_separador3 ||
               lv_esta_agenda || lv_separador2;
    --Inicio 23.0
    IF v_activacion_campos = 1 THEN
      p_trama := p_trama || lv_XA_Act_Ident || lv_separador3 ||
                 lv_identi_acc ||lv_separador2;
      p_trama := p_trama ||'XA_Validated'|| lv_separador3 ||
                 v_indicador_orden_completa || lv_separador2;  --Indicador Orden Completa
      p_trama := p_trama ||'XA_Zone_Complex'|| lv_separador3 ||
                 v_flag_zona || lv_separador2;                --Zona Compleja
      p_trama := p_trama || 'XA_Contact_Phones'|| lv_separador3
                  || v_servicio_x_instalar_c || lv_delimitador;--Numero de Contacto
    ELSE
    --Fin 23.0
    p_trama := p_trama || lv_XA_Act_Ident || lv_separador3 || lv_identi_acc ||
               lv_delimitador;
    --Inicio 23.0
    END IF ;
    --Fin 23.0
    ----------------------------------------------------------------------------------------------------------------
    -- Lista de Inventarios
    ----------------------------------------------------------------------------------------------------------------
    p_trama := p_trama || lv_delimitador;
    ----------------------------------------------------------------------------------------------------------------
    -- Inventario Requerido
    ----------------------------------------------------------------------------------------------------------------
  end;

  /******************************************************************************
     Ver         Date          Author                   Descripcion
  ---------  ----------  ------------------  ------------------------------------
   1.0       05/06/2015  Justiniano Condori  Realiza la creacion de la orden de Trabajo Programada
   2.0       26/09/2018  Obed Ortiz          A?adir el flujo para reserva de cuota TOA
  ******************************************************************************/
  procedure p_crear_orden_adc_pr(p_idagenda       in number,
                                 p_sot            in number,
                                 p_fecha          in date,
                                 p_bucket         in varchar2,
                                 p_franja_horaria in varchar2,
                                 p_zona           in varchar2,
                                 p_plano          in varchar2,
                                 p_tipo_orden     in varchar2,
                                 p_subtipo_orden  in varchar2,
                                 p_cod_rpt        out varchar2,
                                 p_msj_rpt        out varchar2) is
    lc_trama         clob;
    lv_resultado     varchar2(1000);
    lv_mensaje       varchar2(1000);
    ln_val_err_ws    number;
    lv_servicio      varchar2(50) := 'gestionarOrdenSGA_ADC';
    lv_xml           clob;
    lv_Mensaje_Repws varchar2(1000);
    ln_Codigo_Respws varchar2(1000);
    ln_crear_ot      NUMBER;         --2.0
    ln_zl            NUMBER;         --2.0
    ln_resultado     NUMBER;         --2.0
  ln_flg_reserva   NUMBER;         --2.0
  BEGIN

    -- 2.0 INI
    ln_crear_ot := 1;
    OPERACION.PKG_RESERVA_TOA.SGASS_FLAG_VAL_X_AGEN(p_idagenda, ln_flg_reserva);

    IF ln_flg_reserva = 0 THEN
    ln_zl := operacion.pq_adm_cuadrilla.f_val_zonalejana(p_idagenda);
    IF ln_zl = 0 THEN
        p_validar_disponibildad(
            p_idagenda,
            lv_mensaje,
            ln_resultado
          );

        IF ln_resultado < 0 THEN
           ln_crear_ot := 0;
           p_cod_rpt  := to_char(ln_resultado);
           p_msj_rpt  := lv_mensaje;
           RETURN;
          END IF;
       END IF;
    END IF;
    --2.0 FIN

    -- Creacion de Orden de Trabajo Programada
    p_gen_trama_orden_trabajo('PR',
                              p_idagenda,
                              p_fecha,
                              p_franja_horaria,
                              p_bucket,
                              null,
                              null,
                              null,
                              p_zona,
                              p_plano,
                              p_tipo_orden,
                              p_subtipo_orden,
                              null,
                              lc_trama,
                              lv_resultado,
                              lv_mensaje);

    -- Validando respuesta de generacion de trama
    if lv_resultado = '-96' then
      p_cod_rpt := lv_resultado;
      p_msj_rpt := lv_mensaje;
      return;
    end if;

    if lv_resultado = 'X' then
      p_cod_rpt := lv_resultado;
      p_msj_rpt := lv_mensaje;
      return;
    end if;

    -- Envio de Consulta de Orden de Trabajo Programada
    webservice.pq_obtiene_envia_trama_adc.p_ws_consulta(p_sot,
                                                        p_idagenda,
                                                        lv_servicio,
                                                        lc_trama,
                                                        lv_xml,
                                                        lv_Mensaje_Repws,
                                                        ln_Codigo_Respws);
    -- Verificando Conexion a Servicio
    select INSTR(upper(lv_xml), 'ERROR 404') into ln_val_err_ws from dual;

    if ln_val_err_ws > 0 then
      p_cod_rpt := '-99';
      p_msj_rpt := '[operacion.pq_adm_cuadrilla.p_crear_orden_adc_pr] No se encontro Servicio Web';
      return;
    end if;
    p_cod_rpt := ln_Codigo_Respws;
    p_msj_rpt := lv_Mensaje_Repws;
  end;
  /******************************************************************************
     Ver         Date          Author                   Descripcion
  ---------  ----------  ------------------  ------------------------------------
   1.0       05/06/2015  Justiniano Condori  Realiza la creacion de la orden de Trabajo No Programada
  ******************************************************************************/
  procedure p_crear_orden_adc_np(p_idagenda      in number,
                                 p_sot           in number,
                                 p_idbucket      in varchar2,
                                 p_zona          in varchar2,
                                 p_plano         in varchar2,
                                 p_tipo_orden    in varchar2,
                                 p_subtipo_orden in varchar2,
                                 p_cod_rpt       out varchar2,
                                 p_msj_rpt       out varchar2) is
    lc_trama         clob;
    lv_resultado     varchar2(1000);
    lv_mensaje       varchar2(1000);
    ln_val_err_ws    number;
    lv_servicio      varchar2(50) := 'gestionarOrdenSGA_ADC';
    lv_xml           clob;
    lv_Mensaje_Repws varchar2(1000);
    ln_Codigo_Respws varchar2(1000);
  begin
    -- Creacion de Orden de Trabajo No Programada
    p_gen_trama_orden_trabajo('NP',
                              p_idagenda,
                              null,
                              null,
                              p_idbucket,
                              null,
                              null,
                              null,
                              p_zona,
                              p_plano,
                              p_tipo_orden,
                              p_subtipo_orden,
                              null,
                              lc_trama,
                              lv_resultado,
                              lv_mensaje);
    -- Validando respuesta de generacion de trama
    if lv_resultado = '-96' then
      p_cod_rpt := lv_resultado;
      p_msj_rpt := lv_mensaje;
      return;
    end if;

    if lv_resultado = 'X' then
      p_cod_rpt := lv_resultado;
      p_msj_rpt := lv_mensaje;
      return;
    end if;
    -- Envio de Consulta de Orden de Trabajo Programada
    webservice.pq_obtiene_envia_trama_adc.p_ws_consulta(p_sot,
                                                        p_idagenda,
                                                        lv_servicio,
                                                        lc_trama,
                                                        lv_xml,
                                                        lv_Mensaje_Repws,
                                                        ln_Codigo_Respws);
    -- Verificando Conexion a Servicio
    select INSTR(upper(lv_xml), 'ERROR 404') into ln_val_err_ws from dual;

    if ln_val_err_ws > 0 then
      p_cod_rpt := '-99';
      p_msj_rpt := '[operacion.pq_adm_cuadrilla.p_crear_orden_adc_np] No se encontro Servicio Web';
      return;
    end if;
    p_cod_rpt := ln_Codigo_Respws;
    p_msj_rpt := lv_Mensaje_Repws;
  end;

  /******************************************************************************
     Ver         Date          Author                   Descripcion
  ---------  ----------  ------------------  ------------------------------------
   1.0       05/06/2015  Justiniano Condori  Realiza la creacion de la orden de Trabajo Puerta a Puerta
  ******************************************************************************/
  procedure p_crear_orden_adc_pp(p_idagenda      in number,
                                 p_sot           in number,
                                 p_dni_tecnico   in varchar2,
                                 p_zona          in varchar2,
                                 p_plano         in varchar2,
                                 p_tipo_orden    in varchar2,
                                 p_subtipo_orden in varchar2,
                                 p_cod_rpt       out varchar2,
                                 p_msj_rpt       out varchar2) is
    lc_trama         clob;
    lv_resultado     varchar2(1000);
    lv_mensaje       varchar2(1000);
    ln_val_err_ws    number;
    lv_servicio      varchar2(50) := 'gestionarOrdenSGA_ADC';
    lv_xml           clob;
    lv_Mensaje_Repws varchar2(1000);
    ln_Codigo_Respws varchar2(1000);
  begin
    -- Creacion de Orden de Trabajo Puerta a Puerta
    p_gen_trama_orden_trabajo('PP',
                              p_idagenda,
                              null,
                              null,
                              p_dni_tecnico,
                              null,
                              null,
                              null,
                              p_zona,
                              p_plano,
                              p_tipo_orden,
                              p_subtipo_orden,
                              null,
                              lc_trama,
                              lv_resultado,
                              lv_mensaje);
    -- Validando respuesta de generacion de trama
    if lv_resultado = '-96' then
      p_cod_rpt := lv_resultado;
      p_msj_rpt := lv_mensaje;
      return;
    end if;

    if lv_resultado = 'X' then
      p_cod_rpt := lv_resultado;
      p_msj_rpt := lv_mensaje;
      return;
    end if;
    -- Envio de Consulta de Orden de Trabajo Puerta a Puerta
    webservice.pq_obtiene_envia_trama_adc.p_ws_consulta(p_sot,
                                                        p_idagenda,
                                                        lv_servicio,
                                                        lc_trama,
                                                        lv_xml,
                                                        lv_Mensaje_Repws,
                                                        ln_Codigo_Respws);
    -- Verificando Conexion a Servicio
    select INSTR(upper(lv_xml), 'ERROR 404') into ln_val_err_ws from dual;
    if ln_val_err_ws > 0 then
      p_cod_rpt := '-99';
      p_msj_rpt := '[operacion.pq_adm_cuadrilla.p_crear_orden_adc_pp] No se encontro Servicio Web';
      return;
    end if;
    p_cod_rpt := ln_Codigo_Respws;
    p_msj_rpt := lv_Mensaje_Repws;
  end;

  /******************************************************************************
     Ver         Date          Author                   Descripcion
  ---------  ----------  ------------------  ------------------------------------
   1.0       05/06/2015  Justiniano Condori  Realiza la creacion de la orden de Trabajo Programada
                                             por Interface de Agendamiento/ReAgendamiento.
  ******************************************************************************/
  procedure p_crear_orden_adc_inter(p_ind            in varchar2,
                                    p_idagenda       in number,
                                    p_fecha          in date,
                                    p_contacto       in varchar2,
                                    p_direccion      in varchar2,
                                    p_telefono       in varchar2,
                                    p_bucket         in varchar2,
                                    p_franja_horaria in varchar2,
                                    p_plano          in varchar2,
                                    p_zona           in varchar2,
                                    p_tipo_orden     in varchar2,
                                    p_subtipo_orden  in varchar2,
                                    p_observaciones  in varchar2,
                                    p_cod_rpt        out varchar2,
                                    p_msj_rpt        out varchar2) is
    lc_trama            clob;
    lv_resultado        varchar2(1000);
    lv_mensaje          varchar2(1000);
    lv_servicio         varchar2(50) := 'gestionarOrdenSGA_ADC';
    lv_xml              clob;
    ln_val_err_ws       number;
    ln_id_subtipo_orden number;
    lv_Mensaje_Repws    varchar2(1000);
    lv_Codigo_Respws    varchar2(1000);
    ln_solot            number;
    lv_contacto         marketing.vtatabcli.nomcli%TYPE;
    ld_fecha_prog       date; --2.00
    ln_crear_ot         NUMBER;         --2.0
    ln_zl               NUMBER;         --2.0
    ln_resultado        NUMBER;         --2.0
    lv_bucket_error    operacion.parametro_vta_pvta_adc.idbucket%type;
    lv_bucket          operacion.parametro_vta_pvta_adc.idbucket%type;
  begin
    -- Obtener SOT
    ln_solot := f_obtiene_codsolotxagenda(p_idagenda);
    -- Id de Subtipo de Orden
    select soa.id_subtipo_orden
      into ln_id_subtipo_orden
      from operacion.subtipo_orden_adc soa
     where soa.cod_subtipo_orden = p_subtipo_orden;

    if p_ind = 'PR' then
      -- Creacion de Orden de Trabajo Programada para Agendamiento

      -- 2.0 INI
      ln_crear_ot := 1;
      ln_zl := operacion.pq_adm_cuadrilla.f_val_zonalejana(p_idagenda);
      IF ln_zl = 0 THEN
          p_validar_disponibildad(
              p_idagenda,
              lv_mensaje,
              ln_resultado
            );

          IF ln_resultado < 0 THEN
             ln_crear_ot := 0;
             p_cod_rpt  := to_char(ln_resultado);
             p_msj_rpt  := lv_mensaje;
             RETURN;
          END IF;
      END IF;
      --2.0 FIN

      p_gen_trama_orden_trabajo('PR',
                                p_idagenda,
                                p_fecha,
                                p_franja_horaria,
                                p_bucket,
                                null,
                                null,
                                null,
                                p_zona,
                                p_plano,
                                p_tipo_orden,
                                p_subtipo_orden,
                                null,
                                lc_trama,
                                lv_resultado,
                                lv_mensaje);
    elsif p_ind = 'RP' then
      -- Creacion de Orden de Trabajo Programada para ReAgendamiento
      lv_contacto := f_reemplazar_caracter(p_contacto);
      p_gen_trama_orden_trabajo('RP',
                                p_idagenda,
                                p_fecha,
                                p_franja_horaria,
                                p_bucket,
                                lv_contacto,
                                p_direccion,
                                p_telefono,
                                p_zona,
                                p_plano,
                                p_tipo_orden,
                                p_subtipo_orden,
                                p_observaciones,
                                lc_trama,
                                lv_resultado,
                                lv_mensaje);
    else
      p_cod_rpt := 'X';
      p_msj_rpt := 'Debe de Enviar un Indicador de Proceso: PR(Agendamiento) o RP(ReAgendamiento)';
      return;
    end if;

    -- Validando respuesta de generacion de trama
    if lv_resultado = '-96' then
      p_cod_rpt := lv_resultado;
      p_msj_rpt := lv_mensaje;
      update operacion.agendamiento
         set rpt_adc = 5 -- Error por Consistencia de datos
       where idagenda = p_idagenda;

      p_insertar_log_error_ws_adc('Creacion OT',
                                  p_idagenda,
                                  p_cod_rpt,
                                  p_msj_rpt);
      return;
    end if;

    if lv_resultado = 'X' then
      p_cod_rpt := lv_resultado;
      p_msj_rpt := lv_mensaje;
      return;
    end if;
    -- Envio de Consulta de Orden de Trabajo Programada
    webservice.pq_obtiene_envia_trama_adc.p_ws_consulta(ln_solot,
                                                        p_idagenda,
                                                        lv_servicio,
                                                        lc_trama,
                                                        lv_xml,
                                                        lv_Mensaje_Repws,
                                                        lv_Codigo_Respws);

    -- Verificando Conexion a Servicio
    select INSTR(upper(lv_xml), 'ERROR 404') into ln_val_err_ws from dual;

    if ln_val_err_ws > 0 then
      -- No se encontro servicio de Midleware
      p_cod_rpt := '-99';
      p_msj_rpt := 'No se encontro Servicio Web';

      update operacion.agendamiento
         set rpt_adc = 4 -- Error por Conexion
       where idagenda = p_idagenda;

      p_insertar_log_error_ws_adc('Creacion OT',
                                  p_idagenda,
                                  p_cod_rpt,
                                  p_msj_rpt);
      return;
    end if;

    p_cod_rpt := lv_Codigo_Respws;
    p_msj_rpt := lv_Mensaje_Repws;

    if p_cod_rpt = '-2' then
      -- Problema de Conexion con EtaDirect
      update operacion.agendamiento
         set rpt_adc = 4 -- Error por Conexion
       where idagenda = p_idagenda;

      p_insertar_log_error_ws_adc('Creacion OT',
                                  p_idagenda,
                                  p_cod_rpt,
                                  p_msj_rpt);
   --   return; 2.0
    elsif p_cod_rpt = '0' or p_cod_rpt = '3'  then
      -- 2.0 INICIO
      if p_cod_rpt = '3' then
        ln_resultado:=3;
        BEGIN
          SELECT d.codigoc
            INTO lv_bucket_error
            FROM operacion.parametro_det_adc d, operacion.parametro_cab_adc c
           WHERE d.abreviatura = substr(p_msj_rpt,1,5)
             AND d.id_parametro = c.id_parametro
             AND c.abreviatura = 'WARNING_BUCKET_ERROR'
             AND d.estado = 1
             AND c.estado = 1;
          lv_bucket := lv_bucket_error;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            lv_bucket:=p_bucket;
        END;
      else
          ln_resultado:=1;
          lv_bucket:=p_bucket;
      end if;

      -- SETEAR HORA
      BEGIN
      ld_fecha_prog:=p_fecha;
       select to_date(to_char(trunc(ld_fecha_prog, 'DD'), 'YYYY-MM-DD') || ' ' ||
               CASE IND_MERID_FI
                 WHEN 'PM' THEN
                  LPAD(TO_NUMBER(SUBSTR(f.franja_ini, 1, 2)) + 12, 2, '0') || ':' ||
                  SUBSTR(f.franja_ini, 4)
                 else
                  LPAD(TO_NUMBER(SUBSTR(f.franja_ini, 1, 2)), 2, '0') || ':' ||
                  SUBSTR(f.franja_ini, 4)
               END, 'YYYY-MM-DD hh24:mi:ss' )
           into ld_fecha_prog
          from operacion.franja_horaria f
         where f.codigo = p_franja_horaria
           and f.flg_ap_ctr = 1;
     exception
        when NO_DATA_FOUND then
          ld_fecha_prog:= p_fecha;
      end;

      update operacion.agendamiento
         set rpt_adc          = ln_resultado, -- Creacion de OT Programada
             idbucket         = lv_bucket,
             flg_orden_adc    = 1,
             fecagenda        = ld_fecha_prog,--p_fecha, 2.0
             id_subtipo_orden = ln_id_subtipo_orden
       where idagenda = p_idagenda;


     -- 2.0 - FIN

      if p_ind = 'PR' then
        if p_cod_rpt = '1' then-- 2.0
           p_insert_ot_adc(ln_solot,
                        lv_aplicacion,
                        p_idagenda,
                        1,
                        'Creacion de OT');
        else-- 2.0 inicio
           p_insertar_log_error_ws_adc('Creacion OT - Bucket Error',
                                      p_idagenda,
                                      p_cod_rpt,
                                      p_msj_rpt);
        end if;-- 2.0 fin
      end if;

      if p_ind = 'RP' then
        p_insert_ot_adc(ln_solot,
                        lv_aplicacion,
                        p_idagenda,
                        1,
                        'ReProgramacion de OT');
      end if;
    else

      update operacion.agendamiento
         set rpt_adc = 6 -- Error en Generacion de OT
       where idagenda = p_idagenda;

      p_insertar_log_error_ws_adc('Creacion OT',
                                  p_idagenda,
                                  lv_Codigo_Respws,
                                  lv_Mensaje_Repws);

    end if;
    p_cod_rpt := '0';-- 2.0
  end;
  /******************************************************************************
     Ver         Date          Author                   Descripcion
  ---------  ----------  ------------------  ------------------------------------
   1.0       05/06/2015  Justiniano Condori  Realiza la creacion de la orden de Trabajo en
                                             Oracle Field Service
   2.0       11/02/2016  Emma Guzman         Evalua la agenda 1 = MASIVO, 2 = CLARO EMPRESA
   3.0       26/09/2018  Obed Ortiz          A?adir el flujo para reserva de cuota TOA
  ******************************************************************************/
  procedure p_crear_ot_wf(p_idagenda  in number,
                          p_resultado out varchar2,
                          p_mensaje   out varchar2) is
    le_fech EXCEPTION;
    ln_codsolot       number;
    ln_val_param      number;
    ln_val_ot         number(1);
    lv_tecno          varchar2(10);
    ln_tecno_id_err   number;
    lv_tecno_m_err    varchar2(2000); --2.0 varchar2(100);
    lv_tipo_servicio  varchar2(30);
    ld_fecha_prog     date;
    lv_bucket         varchar2(100);
    lv_franja         varchar2(5);
    lv_plano          varchar2(20);
    lv_zona           varchar2(10);
    ln_tiptra         number(4);
    lv_tipsrv         varchar2(5);
    ln_codmotot       number(6);
    ln_val_bajxsol    number;
    ln_id_subtipOrden number;
    lv_ind            varchar2(10);
    lv_subtipOrden    varchar2(10);
    lv_tipOrden       varchar2(10);
    ln_flg_puerta     number(1);
    ln_valida_est     number(1);
    lv_tipo_agenda    varchar2(20);
    ln_error_sot      number;
    lv_error_sot      varchar2(100);
    lv_cod_rpt        varchar2(5);
    lv_msj_rpt        varchar2(1000);
    ln_zl number;
    ld_fecha_prog_ref DATE;   --2.0
    ln_crear_ot       NUMBER; --2.0
    lv_bucket_error   varchar2(100); -- 2.0
    an_tipo           number; -- 2.0
    ln_flg_reserva    number(1); -- 3.0
    ln_observacion    solot.observacion%type;-- 36.0
    ln_nro_toa        varchar2(30); -- 3.0
    ln_cod_rpta       number(1); -- 3.0
    as_mensajeerror   VARCHAR(200);--33.0
    n_num_slc         number(20); -- 33.0
    v_num_orden       varchar(30); -- 33.0
    ln_numsec         NUMBER(20);--33.0
    
  begin
    -- Tomando el valor de la existencia de orden de trabajo en EtaDirect
    select a.flg_orden_adc
      into ln_val_ot
      from operacion.agendamiento a
     where a.idagenda = p_idagenda;
    -- Si en caso tiene un orden de trabajo en EtaDirect
    if ln_val_ot = 1 then
      p_resultado := '-98';
      p_mensaje   := '[operacion.pq_adm_cuadrilla.p_crear_ot_wf] Existe una Orden de Trabajo Creada';
      raise le_fech;
    end if;
    -- Definir a que flujo ira:
    -- Buscando la SOT
    select a.codsolot
      into ln_codsolot
      from operacion.agendamiento a
     where a.idagenda = p_idagenda;
    --ini 2.0
    -- Evaluar SOT
    p_tipo_x_tiposerv(ln_codsolot, an_tipo, p_resultado, p_mensaje);
    if an_tipo = 0 then
      RAISE le_fech;
    END if;
    -- fin 2.0
    -- INI 3.0
     OPERACION.PKG_RESERVA_TOA.SGASS_FLAG_VAL_X_AGEN(p_idagenda, ln_flg_reserva);

    --35.0 if ln_flg_reserva = 1 then
      -- INI 33.0
          select s.tiptra
          into ln_tiptra
          from operacion.solot s
         where s.codsolot = ln_codsolot;
         
         if ln_tiptra= 658 or ln_tiptra=830 then 
         
              select v.numsec 
              into ln_numsec 
              from  sales.vtatabslcfac v, operacion.solot  s 
              where  s.tiptra=ln_tiptra
               and s.numslc=v.numslc
               and s.codsolot=ln_codsolot;
                          
                select count(1)
                into ln_val_param
               from OPERACION.SGAT_RESERVA_TOA 
               where restn_num_sec=ln_numsec
			   AND RESTN_ESTADO=1; -- 35.0
         
                 if ln_val_param > 0 then--35.0 genero reserva activa
				    /*ini 35.0
                      p_resultado := '-1';
                      p_mensaje   := '[operacion.pq_adm_cuadrilla.p_crear_ot_wf] No se obtuvo obtuvo numsec para actualizar reserva.';
                      update operacion.agendamiento
                         set rpt_adc   = 5, -- Error en Generacion de OT por Consistencia
                             fecagenda = null
                       where idagenda = p_idagenda;

                      p_insertar_log_error_ws_adc('Actualizacion OT',
                                                  p_idagenda,
                                                  p_resultado,
                                                  p_mensaje);
                          raise le_fech;
               else
			     fin 35.0  */
                   select distinct(restv_nro_orden )
                   into ln_nro_toa
                   from OPERACION.SGAT_RESERVA_TOA 
                   where restn_num_sec=ln_numsec 
				   AND RESTN_ESTADO=1; --34.0
                   operacion.pkg_reserva_toa.SGASU_UD_RESER_TOA(ln_nro_toa,ln_codsolot,3,ln_cod_rpta,lv_msj_rpt);
                   IF ln_cod_rpta = -1 THEN
                     as_mensajeerror := '[operacion.pq_adm_cuadrilla.p_crear_ot_wf] Se presentaron errores al actualizar la reserva al invocar el SP  operacion.pkg_reserva_toa.SGASU_UD_RESER_TOA - pi_tipo_transaccion:=3';
                     p_insertar_log_error_ws_adc('p_crear_ot_wf',
                                p_idagenda,
                                ln_cod_rpta,
                                as_mensajeerror);
                   END IF;
               end if; 
         else   
             --FIN 33.0 
             select s.observacion
               into ln_observacion
               from operacion.solot s
              where s.codsolot = ln_codsolot;
             SELECT NVL(SUBSTR(ln_observacion,INSTR(ln_observacion, '~',1,1)+1,INSTR(ln_observacion, '~',1,2) - INSTR(ln_observacion, '~',1,1) -1 ), '')
               INTO ln_nro_toa
             FROM DUAL;
             operacion.pkg_reserva_toa.SGASU_UD_RESER_TOA(ln_nro_toa,ln_codsolot,3,ln_cod_rpta,lv_msj_rpt);
             --INI 33.0
             IF ln_cod_rpta = -1 THEN
                as_mensajeerror := '[operacion.pq_adm_cuadrilla.p_crear_ot_wf] Se presentaron errores al actualizar la reserva al invocar el SP  operacion.pkg_reserva_toa.SGASU_UD_RESER_TOA - pi_tipo_transaccion:=3';
                p_insertar_log_error_ws_adc('p_crear_ot_wf',
                                p_idagenda,
                                ln_cod_rpta,
                                as_mensajeerror);
             END IF;
      --35.0   END IF;
      --FIN 33.0
     END IF;
     -- FIN 3.0
    -- Determinar tecnologia
    lv_tecno := operacion.pq_adm_cuadrilla.f_obtiene_tipo_tecnologia(ln_codsolot,
                                                                     ln_tecno_id_err,
                                                                     lv_tecno_m_err);
    -- Buscando el tipo de Servicio
    if an_tipo = 1 then
      --2.0
      select toa.tipo_servicio
        into lv_tipo_servicio
        from operacion.tipo_orden_adc toa
       where toa.id_tipo_orden =
             (select tt.id_tipo_orden
                from operacion.tiptrabajo tt
               where tt.tiptra =(select s.tiptra
                                  from operacion.solot s
                                 where s.codsolot = ln_codsolot));
    else-- ini 2.0
      select toa.tipo_servicio
        into lv_tipo_servicio
        from operacion.tipo_orden_adc toa
       where toa.id_tipo_orden =
             (select tt.id_tipo_orden_ce
                from operacion.tiptrabajo tt
               where tt.tiptra =
                     (select s.tiptra
                        from operacion.solot s
                       where s.codsolot = ln_codsolot));
    END IF; -- fin 2-0
    -- Validar que tipo de agenda
    select a.tipo
      into lv_tipo_agenda
      from operacion.agendamiento a
     where a.idagenda = p_idagenda;
    -- Consiguiendo Valores
    select s.tiptra, s.tipsrv, s.codmotot
      into ln_tiptra, lv_tipsrv, ln_codmotot
      from operacion.solot s
     where s.codsolot = ln_codsolot;
    ln_valida_est := operacion.pq_adm_cuadrilla.f_val_generacion_ot_auto(lv_tipsrv,
                                                                         ln_tiptra,
                                                                         ln_codmotot,
                                                                         lv_tipo_agenda);

    -- Si es Automatico
    if ln_valida_est = 1 then
      if lv_tipo_servicio = 'Bajas' and UPPER(lv_tipo_agenda) = 'ACOMETIDA' then
        -- Buscando los Tipo de Orden y SubTipo de Orden
        begin
          select toa.cod_tipo_orden,
                 soa.cod_subtipo_orden,
                 soa.id_subtipo_orden
            into lv_tipOrden, lv_subtipOrden, ln_id_subtipOrden
            from operacion.tipo_orden_adc toa
            join operacion.subtipo_orden_adc soa
              on toa.id_tipo_orden = soa.id_tipo_orden
           where toa.tipo_servicio = 'Bajas'
             and toa.estado = 1
             and soa.estado = 1
             and toa.tipo_tecnologia = lv_tecno
             and toa.flg_tipo = an_tipo --2.0
             and upper(soa.descripcion) like '%' || lv_tipo_agenda || '%';
        EXCEPTION
          WHEN no_data_found THEN
            lv_tipOrden       := '';
            lv_subtipOrden    := '';
            ln_id_subtipOrden := 0;
        END;

        -- Bucket de No Programada
        select pda.codigoc
          into lv_bucket
          from operacion.parametro_cab_adc pca
          join operacion.parametro_det_adc pda
            on pca.id_parametro = pda.id_parametro
           and pca.abreviatura = 'PARAM_CRE_OT'
           and pda.abreviatura = 'BKT_NPR';

        if lv_tecno = 'HFC' or lv_tecno = 'TPI' or lv_tecno = 'ANA' or lv_tecno = 'FTTH' then --29.0
          -- Plano
          select v.idplano
            into lv_plano
            from marketing.vtasuccli v
           where v.codsuc = (select a.codsuc
                               from operacion.agendamiento a
                              where a.idagenda = p_idagenda);
          -- Procedimiento para Sacar la Zona
          p_retornar_zona_plano(lv_plano,
                                null,
                                lv_plano,
                                lv_zona,
                                ln_error_sot,
                                lv_error_sot);
        elsif lv_tecno = 'DTH' OR lv_tecno = 'LTE' then --26.0
          -- Plano - Para DTH sera el IdPoblado
          select v.ubigeo2
            into lv_plano
            from marketing.vtasuccli v
           where v.codsuc = (select a.codsuc
                               from operacion.agendamiento a
                              where a.idagenda = p_idagenda);
          -- Procedimiento para Sacar la Zona
          p_retornar_zona_plano(null,
                                lv_plano,
                                lv_plano,
                                lv_zona,
                                ln_error_sot,
                                lv_error_sot);
        end if;

        p_crear_orden_adc_np(p_idagenda,
                             ln_codsolot,
                             lv_bucket,
                             lv_zona,
                             lv_plano,
                             lv_tipOrden,
                             lv_subtipOrden,
                             lv_cod_rpt,
                             lv_msj_rpt);
        lv_ind := 'NP';
      else
        select count(1)
          into ln_val_param
          from operacion.parametro_vta_pvta_adc pva
         where pva.codsolot = ln_codsolot;
        if ln_val_param = 0 then
          p_resultado := '-1';
          p_mensaje   := '[operacion.pq_adm_cuadrilla.p_crear_ot_wf] No se obtuvo los datos de Consulta de Capacidad(PostVenta/Venta), debe Generar ReAgendamiento en Control de Tareas.';
          update operacion.agendamiento
             set rpt_adc   = 5, -- Error en Generacion de OT por Consistencia
                 fecagenda = null
           where idagenda = p_idagenda;

          p_insertar_log_error_ws_adc('Creacion OT',
                                      p_idagenda,
                                      p_resultado,
                                      p_mensaje);
          raise le_fech;
        end if;
        -- Validar si es puerta a puerta
        select pva.flg_puerta
          into ln_flg_puerta
          from operacion.parametro_vta_pvta_adc pva
         where pva.codsolot = ln_codsolot;
        -- Condicion si es puerta a puerta
        if ln_flg_puerta = 1 then
          -- Bucket - sera el dni del tecnico
          select pvpa.dni_tecnico
            into lv_bucket
            from operacion.parametro_vta_pvta_adc pvpa
           where pvpa.codsolot = ln_codsolot;
          -- SubTipo de Orden
          lv_subtipOrden := f_devuelve_subtipo(ln_codsolot);
          -- Id SubTipo de Orden
          select soa.id_subtipo_orden
            into ln_id_subtipOrden
            from operacion.subtipo_orden_adc soa
           where soa.cod_subtipo_orden = lv_subtipOrden;
          -- Tipo de Orden
          select toa.cod_tipo_orden
            into lv_tipOrden
            from operacion.tipo_orden_adc toa
           where toa.id_tipo_orden =
                 (select soa.id_tipo_orden
                    from operacion.subtipo_orden_adc soa
                   where soa.cod_subtipo_orden = lv_subtipOrden);

          -- Verificando el tipo de tecnologia
          if lv_tecno = 'HFC' or lv_tecno = 'TPI' or lv_tecno = 'ANA' or lv_tecno = 'FTTH' then --29.0
            -- Consiguiendo Valores para generacion de OT
            -- Plano
            select v.idplano
              into lv_plano
              from marketing.vtasuccli v
             where v.codsuc = (select a.codsuc
                                 from operacion.agendamiento a
                                where a.idagenda = p_idagenda);
            -- Procedimiento para Sacar la Zona
            p_retornar_zona_plano(lv_plano,
                                  null,
                                  lv_plano,
                                  lv_zona,
                                  ln_error_sot,
                                  lv_error_sot);
          elsif lv_tecno = 'DTH' OR lv_tecno = 'LTE'  then --26.0
            -- Consiguiendo Valores para generacion de OTt
            -- Plano - Para DTH sera el IdPoblado
            select v.ubigeo2
              into lv_plano
              from marketing.vtasuccli v
             where v.codsuc = (select a.codsuc
                                 from operacion.agendamiento a
                                where a.idagenda = p_idagenda);
            -- Procedimiento para Sacar la Zona
            p_retornar_zona_plano(null,
                                  lv_plano,
                                  lv_plano,
                                  lv_zona,
                                  ln_error_sot,
                                  lv_error_sot);
          end if;

          p_crear_orden_adc_pp(p_idagenda,
                               ln_codsolot,
                               lv_bucket,
                               lv_zona,
                               lv_plano,
                               lv_tipOrden,
                               lv_subtipOrden,
                               lv_cod_rpt,
                               lv_msj_rpt);
          lv_ind := 'PP';
        else
          -- Consultando Campos comunes para la Generacion de OT
          -- SOT - variable ln_codsolot
          -- IDAgenda - Es parametro de entrada
          -- Fecha
          begin
            select pvpa.fecha_progra
              into ld_fecha_prog
              from operacion.parametro_vta_pvta_adc pvpa
             where pvpa.codsolot = ln_codsolot;

            if ld_fecha_prog is null then
              p_resultado := '-1';
              p_mensaje   := '[operacion.pq_adm_cuadrilla.p_crear_ot_wf] No se obtuvo la fecha de Programacion de Capacidad(PostVenta/Venta), debe Generar ReAgendamiento en Control de Tareas.';
              update operacion.agendamiento
                 set rpt_adc   = 5, -- Error en Generacion de OT por Consistencia
                     fecagenda = null
               where idagenda = p_idagenda;

              p_insertar_log_error_ws_adc('Creacion OT',
                                          p_idagenda,
                                          p_resultado,
                                          p_mensaje);
              raise le_fech;
            else
              -- Bucket
              select pvpa.idbucket
                into lv_bucket
                from operacion.parametro_vta_pvta_adc pvpa
               where pvpa.codsolot = ln_codsolot;
              -- Franja Horaria
              select pvpa.franja
                into lv_franja
                from operacion.parametro_vta_pvta_adc pvpa
               where pvpa.codsolot = ln_codsolot;
              -- SubTipo de Orden
              select pvpa.subtipo_orden
                into lv_subtipOrden
                from operacion.parametro_vta_pvta_adc pvpa
               where pvpa.codsolot = ln_codsolot;
              -- Id SubTipo de Orden
              select soa.id_subtipo_orden
                into ln_id_subtipOrden
                from operacion.subtipo_orden_adc soa
               where soa.cod_subtipo_orden = lv_subtipOrden
               and estado=1;--33.0
              -- Tipo de Orden
              select toa.cod_tipo_orden
                into lv_tipOrden
                from operacion.tipo_orden_adc toa
               where toa.id_tipo_orden =
                     (select soa.id_tipo_orden
                        from operacion.subtipo_orden_adc soa
                       where soa.cod_subtipo_orden = lv_subtipOrden
                      and estado=1);--33.0 ;
              if lv_bucket is null or lv_franja is null or
                 lv_subtipOrden is null or lv_tipOrden is null then
                p_resultado := '-1';
                p_mensaje   := '[operacion.pq_adm_cuadrilla.p_crear_ot_wf] No se obtuvo Capacidad(PostVenta/Venta), debe Generar ReAgendamiento en Control de Tareas.';
                update operacion.agendamiento
                   set rpt_adc   = 5, -- Error en Generacion de OT por Consistencia
                       fecagenda = null
                 where idagenda = p_idagenda;

                p_insertar_log_error_ws_adc('Creacion OT',
                                            p_idagenda,
                                            p_resultado,
                                            p_mensaje);
                raise le_fech;
              end if;
            end if;
          end;

          -- Verificando el tipo de tecnologia
          if lv_tecno = 'HFC' or lv_tecno = 'TPI' or lv_tecno = 'ANA' or lv_tecno = 'FTTH' then--29.0
            -- Consiguiendo Valores para generacion de OT
            -- Plano
            select v.idplano
              into lv_plano
              from marketing.vtasuccli v
             where v.codsuc = (select a.codsuc
                                 from operacion.agendamiento a
                                where a.idagenda = p_idagenda);
            -- Procedimiento para Sacar la Zona
            p_retornar_zona_plano(lv_plano,
                                  null,
                                  lv_plano,
                                  lv_zona,
                                  ln_error_sot,
                                  lv_error_sot);
          elsif lv_tecno = 'DTH' OR lv_tecno = 'LTE' then --26.0
            -- Consiguiendo Valores para generacion de OTt
            -- Plano - Para DTH sera el IdPoblado
            select v.ubigeo2
              into lv_plano
              from marketing.vtasuccli v
             where v.codsuc = (select a.codsuc
                                 from operacion.agendamiento a
                                where a.idagenda = p_idagenda);
            -- Procedimiento para Sacar la Zona
            p_retornar_zona_plano(null,
                                  lv_plano,
                                  lv_plano,
                                  lv_zona,
                                  ln_error_sot,
                                  lv_error_sot);
          end if;

          -- 2.0 INI
          -- ACTUALIZAR BUCKET SI ES ZONA LEJANA --
          ln_crear_ot := 1;
          if ln_flg_reserva = 0 then-- 3.0
          ln_zl := operacion.pq_adm_cuadrilla.f_val_zonalejana(p_idagenda);
          IF ln_zl = 0 THEN
              p_validar_disponibildad(
                  p_idagenda,
                  p_mensaje,
                  p_resultado
                );

              IF p_resultado < 0 THEN
                 ln_crear_ot := 0;
                 lv_cod_rpt  := to_char(p_resultado);
                 lv_msj_rpt  := p_mensaje;
              END IF;
          END IF;
          --2.0 FIN
          end if;-- 3.0

          IF ln_crear_ot = 1 THEN -- 2.0
          -- Creacion de Orden de Trabajo
          p_crear_orden_adc_pr(p_idagenda,
                               ln_codsolot,
                               ld_fecha_prog,
                               lv_bucket,
                               lv_franja,
                               lv_zona,
                               lv_plano,
                               lv_tipOrden,
                               lv_subtipOrden,
                               lv_cod_rpt,
                               lv_msj_rpt);

          -- ACTUALIZAR BUCKET SI ES ZONA LEJANA --
           --ln_zl := operacion.pq_adm_cuadrilla.f_val_zonalejana(p_idagenda); --2.0
           if ln_zl = 1 then
           -- Bucket de Zona Lejana
            begin
              select pda.codigoc
                into lv_bucket
                from operacion.parametro_cab_adc pca
                join operacion.parametro_det_adc pda
                  on pca.id_parametro = pda.id_parametro
                 and pca.abreviatura = 'PARAM_CRE_OT'
                 and pda.abreviatura = 'BKT_ZL';
            exception
              when NO_DATA_FOUND then
                p_resultado := '-96';
                p_mensaje   := '[operacion.pq_adm_cuadrilla.p_gen_trama_orden_trabajo] No se encontro Bucket de Zona Lejana';
                return;
            end;
           end if;
          END IF; -- 2.0
          lv_ind := 'PR';
        end if;
      end if;
    else
      --INI 2.0
       UPDATE operacion.agendamiento
          SET fecagenda = NULL
        WHERE codsolot = ln_codsolot;
      --FIN 2.0
      p_resultado := '0';
      p_mensaje   := '[operacion.pq_adm_cuadrilla.p_crear_ot_wf] No se genero OT para este caso debido a la funcion de Validacion Automatica.';
      raise le_fech;
    end if;


    -- Seccion de Errores
    if lv_cod_rpt = '-99' then
      -- Error de Conexion con Midleware
      update operacion.agendamiento
         set rpt_adc = 4 -- Error por Conexion
       where idagenda = p_idagenda;
      p_insertar_log_error_ws_adc('Creacion OT',
                                  p_idagenda,
                                  lv_cod_rpt,
                                  lv_msj_rpt);
      raise le_fech;
    elsif lv_cod_rpt = '-96' then
      update operacion.agendamiento
         set rpt_adc = 5 -- Error por Consistencia de Datos
       where idagenda = p_idagenda;
      p_insertar_log_error_ws_adc('Creacion OT',
                                  p_idagenda,
                                  lv_cod_rpt,
                                  lv_msj_rpt);
    elsif lv_cod_rpt = '-2' then
      -- Problema de Conexion con EtaDirect
      update operacion.agendamiento
         set rpt_adc = 4 -- Error por Conexion
       where idagenda = p_idagenda;

      p_insertar_log_error_ws_adc('Creacion OT',
                                  p_idagenda,
                                  lv_cod_rpt,
                                  lv_msj_rpt);
      return;
    elsif lv_cod_rpt = '0' then
      if lv_ind = 'NP' then
        update operacion.agendamiento
           set rpt_adc          = 2, -- Creacion de OT No Programada
               idbucket         = lv_bucket,
               id_subtipo_orden = ln_id_subtipOrden,
               fecagenda        = null,
               flg_orden_adc    = 1
         where idagenda = p_idagenda;
        p_insert_ot_adc(ln_codsolot,
                        lv_aplicacion,
                        p_idagenda,
                        1,
                        'Creacion de OT No Programada');
      end if;
      if lv_ind = 'PP' then
        update operacion.agendamiento
           set rpt_adc          = 1, -- Creacion de OT Programada
               flg_orden_adc    = 1,
               idbucket         = lv_bucket,
               fecagenda        = sysdate,
               id_subtipo_orden = ln_id_subtipOrden
         where idagenda = p_idagenda;
        p_insert_ot_adc(ln_codsolot,
                        lv_aplicacion,
                        p_idagenda,
                        1,
                        'Creacion de OT');
      end if;
      if lv_ind = 'PR' then
        BEGIN--2.0
        select pva.fecha_progra
          into ld_fecha_prog
          from operacion.parametro_vta_pvta_adc pva
         where pva.codsolot = ln_codsolot;

        -- 2.0 - INI - SETEAR HORA
        BEGIN
         select to_date(to_char(trunc(ld_fecha_prog, 'DD'), 'YYYY-MM-DD') || ' ' ||
                 CASE IND_MERID_FI
                   WHEN 'PM' THEN
                    LPAD(TO_NUMBER(SUBSTR(f.franja_ini, 1, 2)) + 12, 2, '0') || ':' ||
                    SUBSTR(f.franja_ini, 4)
                   else
                    LPAD(TO_NUMBER(SUBSTR(f.franja_ini, 1, 2)), 2, '0') || ':' ||
                    SUBSTR(f.franja_ini, 4)
                 END, 'YYYY-MM-DD hh24:mi:ss' )
             into ld_fecha_prog_ref
            from operacion.franja_horaria f
           where f.codigo = lv_franja
             and f.flg_ap_ctr = 1;
       exception
          when NO_DATA_FOUND then
            ld_fecha_prog_ref:= ld_fecha_prog;
        end;
        ld_fecha_prog:=  ld_fecha_prog_ref;
       exception
          when NO_DATA_FOUND then
            ld_fecha_prog:=NULL;
       END;-- 2.0 - FIN - SETEAR HORA

        update operacion.agendamiento
           set rpt_adc          = 1, -- Creacion de OT Programada
               flg_orden_adc    = 1,
               idbucket         = lv_bucket,
               fecagenda        = ld_fecha_prog,
               id_subtipo_orden = ln_id_subtipOrden
         where idagenda = p_idagenda;
        p_insert_ot_adc(ln_codsolot,
                        lv_aplicacion,
                        p_idagenda,
                        1,
                        'Creacion de OT');
      end if;
      OPERACION.PKG_RESERVA_TOA.SGASU_UD_RESER_TOA(ln_nro_toa,2,1,ln_cod_rpta,lv_msj_rpt); --3.0
      --INI 33.0
      IF ln_cod_rpta = -1 THEN
        as_mensajeerror := '[operacion.pq_adm_cuadrilla.p_crear_ot_wf] Se presentaron errores al actualizar la reserva al invocar el SP  operacion.pkg_reserva_toa.SGASU_UD_RESER_TOA - pi_tipo_transaccion:=1';
        p_insertar_log_error_ws_adc('p_crear_ot_wf',
                        p_idagenda,
                        ln_flg_reserva,
                        as_mensajeerror);
      END IF;
      --FIN 33.0
      p_resultado := '0';
      p_mensaje   := 'Todo Correcto';
      raise le_fech;
    elsif lv_cod_rpt = '3' THEN
      -- 2.0 INI
      BEGIN
        SELECT d.codigoc
          INTO lv_bucket_error
          FROM operacion.parametro_det_adc d, operacion.parametro_cab_adc c
         WHERE d.abreviatura = substr(lv_msj_rpt,1,5)
           AND d.id_parametro = c.id_parametro
           AND c.abreviatura = 'WARNING_BUCKET_ERROR'
           AND d.estado = 1
           AND c.estado = 1;
        lv_bucket := lv_bucket_error;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          NULL;
      END;

      --  SETEAR HORA
      begin
       select to_date(to_char(trunc(ld_fecha_prog, 'DD'), 'YYYY-MM-DD') || ' ' ||
               CASE IND_MERID_FI
                 WHEN 'PM' THEN
                  LPAD(TO_NUMBER(SUBSTR(f.franja_ini, 1, 2)) + 12, 2, '0') || ':' ||
                  SUBSTR(f.franja_ini, 4)
                 else
                  LPAD(TO_NUMBER(SUBSTR(f.franja_ini, 1, 2)), 2, '0') || ':' ||
                  SUBSTR(f.franja_ini, 4)
               END, 'YYYY-MM-DD hh24:mi:ss' )
           into ld_fecha_prog_ref
          from operacion.franja_horaria f
         where f.codigo = lv_franja
           and f.flg_ap_ctr = 1;
      exception
        when NO_DATA_FOUND then
          ld_fecha_prog_ref:= ld_fecha_prog;
      end;
      ld_fecha_prog:=  ld_fecha_prog_ref;
      -- 2.0 FIN

      update operacion.agendamiento
         set rpt_adc          = 3, -- Creacion de OT con Bucket de Error
             flg_orden_adc    = 1,
             idbucket         = lv_bucket,
             fecagenda        = ld_fecha_prog,
             id_subtipo_orden = ln_id_subtipOrden
       where idagenda = p_idagenda;
       -- 2.0 inicio
        p_insertar_log_error_ws_adc('Creacion OT - Bucket Error',
                                  p_idagenda,
                                  lv_cod_rpt,
                                  lv_msj_rpt);
       -- 2.0 fin
      p_insert_ot_adc(ln_codsolot,
                      lv_aplicacion,
                      p_idagenda,
                      1,
                      'Creacion de OT con Bucket de Error');
      OPERACION.PKG_RESERVA_TOA.SGASU_UD_RESER_TOA(ln_nro_toa,2,1,ln_cod_rpta,lv_msj_rpt); --3.0
      --INI 33.0
      IF ln_cod_rpta = -1 THEN
        as_mensajeerror := '[operacion.pq_adm_cuadrilla.p_crear_ot_wf] Se presentaron errores al actualizar la reserva al invocar el SP  operacion.pkg_reserva_toa.SGASU_UD_RESER_TOA - pi_tipo_transaccion:=1';
        p_insertar_log_error_ws_adc('p_crear_ot_wf',
                        p_idagenda,
                        ln_flg_reserva,
                        as_mensajeerror);
      END IF;
      --FIN 33.0
      p_resultado := '0';
      p_mensaje   := 'Todo Correcto';
      raise le_fech;
    else
      update operacion.agendamiento
         set rpt_adc          = 6, -- Error en Generacion de OT
             fecagenda        = null,
             id_subtipo_orden = ln_id_subtipOrden
       where idagenda = p_idagenda;
      p_insertar_log_error_ws_adc('Creacion OT con Errores',
                                  p_idagenda,
                                  lv_cod_rpt,
                                  lv_msj_rpt);

      p_resultado := lv_cod_rpt;
      p_mensaje   := lv_msj_rpt;
      raise le_fech;
    end if;
  exception
    when le_fech then
      p_resultado := -1000;
      p_mensaje := substr('Linea: ' ||
                         dbms_utility.format_error_backtrace || ' - MSG: '||  p_mensaje, 1 ,2000) ;
      p_insertar_log_error_ws_adc('Creacion-Seg',
                                  p_idagenda,
                                  p_resultado,
                                  p_mensaje);
      return;
    when others then
      p_resultado := '-97';
      p_mensaje   := substr(sqlerrm, 1, 2000); --2.0
      update operacion.agendamiento
         set rpt_adc          = 6, -- Error en Generacion de OT
             fecagenda        = null,
             id_subtipo_orden = ln_id_subtipOrden
       where idagenda = p_idagenda;
      p_insertar_log_error_ws_adc('Creacion OT con Errores',
                                  p_idagenda,
                                  p_resultado,
                                  p_mensaje);
      return;
  end;
  /******************************************************************************
    Ver         Date          Author                   Descripcion
  ---------  ----------  ------------------  ------------------------------------
  1.0        17/06/2015  Juan Carlos Gonzales  Retorna Estado de la matriz de mantenimiento
                                               Tipos de trabajo y Servicios
  ******************************************************************************/
  FUNCTION f_val_generacion_ot_auto(p_tipsrv OPERACION.MATRIZ_TYSTIPSRV_TIPTRA_ADC.TIPSRV%TYPE,
                                    p_tiptra OPERACION.MATRIZ_TYSTIPSRV_TIPTRA_ADC.TIPTRA%TYPE,
                                    p_motivo OPERACION.MATRIZ_TIPTRATIPSRVMOT_ADC.ID_MOTIVO%TYPE,
                                    p_agenda OPERACION.MATRIZ_TYSTIPSRV_TIPTRA_ADC.TIPO_AGENDA%TYPE)
    RETURN NUMBER IS
    ln_estado    NUMBER;
    ln_indmot    OPERACION.MATRIZ_TYSTIPSRV_TIPTRA_ADC.VALIDA_MOT%TYPE;
    ls_agenda    OPERACION.MATRIZ_TYSTIPSRV_TIPTRA_ADC.TIPO_AGENDA%TYPE;
    ln_val_todos number;
  BEGIN
    -- Validamos si el tipo de agenda es todos
    SELECT count(1)
      INTO ln_val_todos
      FROM OPERACION.MATRIZ_TYSTIPSRV_TIPTRA_ADC t
     WHERE t.tipsrv = p_tipsrv
       AND t.tiptra = p_tiptra
       and t.tipo_agenda = lv_todos
       AND t.estado = 1;

    if ln_val_todos = 1 then
      ls_agenda := lv_todos;
    else
      ls_agenda := p_agenda;
    end if;

    BEGIN
      SELECT t.valida_mot, DECODE(t.gen_ot_aut, 'A', 1, 'M', 0)
        INTO ln_indmot, ln_estado
        FROM OPERACION.MATRIZ_TYSTIPSRV_TIPTRA_ADC t
       WHERE t.tipsrv = p_tipsrv
         AND t.tiptra = p_tiptra
         AND t.tipo_agenda = ls_agenda
         AND t.estado = 1;
    EXCEPTION
      WHEN no_data_found THEN
        ln_indmot := 0;
        ln_estado := 0;
    END;

    if ln_indmot = 1 then
      BEGIN
        SELECT DECODE(d.gen_ot_aut, 'A', 1, 'M', 0)
          INTO ln_estado
          FROM OPERACION.MATRIZ_TYSTIPSRV_TIPTRA_ADC c,
               OPERACION.MATRIZ_TIPTRATIPSRVMOT_ADC  d
         WHERE c.id_matriz = d.id_matriz
           AND c.tipsrv = p_tipsrv
           AND c.tiptra = p_tiptra
           AND c.tipo_agenda = ls_agenda
           AND d.id_motivo = p_motivo
           AND c.estado = 1
           AND d.estado = 1;

      EXCEPTION
        WHEN no_data_found THEN
          ln_estado := 0;
      END;
    end if;

    RETURN ln_estado;
  END;
  /******************************************************************************
     Ver         Date          Author                   Descripcion
  ---------  ----------  ------------------  ------------------------------------
   1.0       05/06/2015                      Iniciar la orden en el SGA para actualizar Coordenada
   2.0       04/05/2016                      PQT-249355-TSK-77844
  ******************************************************************************/
  PROCEDURE p_inicia_orden_adc(an_IdAgenda     in operacion.agendamiento.idagenda%type,
                               as_idtecnico    in varchar2,
                               as_coordenadas  in varchar2,
                               an_iderror      OUT NUMERIC,
                               as_mensajeerror OUT VARCHAR2) is
    lv_cliente    operacion.agendamiento.codcli%type;
    lv_sucursal   operacion.agendamiento.codsuc%type;
    ls_coord_x    varchar2(100);
    ls_coord_y    varchar2(100);
    ln_coord_x    marketing.vtasuccli.coordx_eta%type;
    ln_coord_y    marketing.vtasuccli.coordx_eta%type;
    ln_estage     operacion.agendamiento.estage%type;
    ln_estagenew  operacion.agendamiento.estage%type := 108;
    ln_estadoeta  operacion.estado_adc.id_estado%type := 2;
    ln_codsolot   number;
    ln_estado_eta number;
    ln_tipo_orden operacion.tipo_orden_adc.id_tipo_orden%type;
    ln_origen     number;
    an_tipo       number;---<2.0>

  begin
    an_iderror      := 0;
    as_mensajeerror := '';

    BEGIN
      select codsuc, codcli, estage, codsolot
        into lv_sucursal, lv_cliente, ln_estage, ln_codsolot
        from operacion.agendamiento
       where idagenda = an_idagenda;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        an_iderror      := -1;
        as_mensajeerror := '[operacion.pq_adm_cuadrilla.p_inicia_orden_adc] No se actualizo coordenadas. Agenda no existe';
    END;

    select substr(as_coordenadas,
                  5,
                  instr(substr(as_coordenadas, 5), ',') - 1),
           substr(substr(as_coordenadas, instr(as_coordenadas, ',') + 1), 5)
      into ls_coord_x, ls_coord_y
      from dual;

    if ls_coord_x is null then
      ln_coord_x := 0;
    end if;

    if ls_coord_y is null then
      ln_coord_y := 0;

    end if;

    ln_coord_x := to_number(replace(ls_coord_x, '.', ','));
    ln_coord_y := to_number(replace(ls_coord_y, '.', ','));

    if ln_coord_x <> 0 and ln_coord_y <> 0 then
      p_actualiza_xy_adc(lv_cliente,
                         lv_sucursal,
                         ln_coord_x,
                         ln_coord_Y,
                         an_iderror,
                         as_mensajeerror);
    end if;

    begin
      select id_estado
        into ln_estado_eta
        from operacion.estado_adc
       where upper(desc_corta) = upper('INICIADO');
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        ln_estado_eta := NULL;
      when others then
        ln_estado_eta := NULL;
    end;

  ---<2.0>
     p_tipo_x_tiposerv(ln_codsolot, an_tipo, an_iderror, as_mensajeerror);
    if an_tipo = 0 then
      raise_application_error(-20001,
                              'OPERACION.pq_adm_cuadrilla.p_inicia_orden_adc - ' ||
                              to_char(an_iderror) || '-' || as_mensajeerror);
    end if;

     if  an_tipo = 2 then  --ce
              begin
                select t.id_tipo_orden_ce
                  into ln_tipo_orden
                  from operacion.agendamiento a,
                       operacion.solot        s,
                       operacion.tiptrabajo   t
                 where a.idagenda = an_idagenda
                   and a.codsolot = s.codsolot
                   and s.tiptra = t.tiptra;
              EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  ln_tipo_orden := NULL;
                when others then
                  ln_tipo_orden := NULL;
              end;
    end if;
    if  an_tipo = 1 then  --masivo
            begin
              select t.id_tipo_orden
                into ln_tipo_orden
                from operacion.agendamiento a,
                     operacion.solot        s,
                     operacion.tiptrabajo   t
               where a.idagenda = an_idagenda
                 and a.codsolot = s.codsolot
                 and s.tiptra = t.tiptra;
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                ln_tipo_orden := NULL;
              when others then
                ln_tipo_orden := NULL;
            end;
    end if;
  --</2.0>


    ln_estagenew := f_retorna_estado_ETA_SGA('ETA',
                                             ln_tipo_orden,
                                             ln_estado_eta,
                                             0,
                                             ln_origen);

    -- Cambiando Estado de la Agenda
    operacion.pq_agendamiento.p_chg_est_agendamiento(an_IdAgenda,
                                                     ln_estagenew,
                                                     ln_estage,
                                                     'Inicio de Orden de Trabajo. Tecnico DNI ' ||
                                                     as_idtecnico,
                                                     null,
                                                     sysdate,
                                                     null,
                                                     ln_estado_eta);

    -- Guardando el Cambio en historico
    p_insert_ot_adc(ln_codsolot,
                    lv_aplicacion,
                    an_IdAgenda,
                    ln_estadoeta,
                    'Inicio de Orden de Trabajo. Tecnico DNI ' ||
                    as_idtecnico);

  end;
  /******************************************************************************
    Ver         Date          Author                   Descripcion
  ---------  ----------  ------------------  ------------------------------------
  1.0        16/06/2015  Luis Polo Benites   Inserta carga de excel de inventarios
  2.0        02/03/2016  Steve Panduro       ETA FASE 2 CE
  3.0        26/09/2016  Justiniano Condori  Sol. de Cambio - Inventario
  ******************************************************************************/
  PROCEDURE p_carga_inventario_adc(ln_id_proceso       in number,--3.0
                                   ls_long_dni         in number,--3.0
                                   ls_long_serie_deco  in number,--3.0
                                   ls_long_ua_deco     in number,--3.0
                                   ls_long_serie_emta  in number,--3.0
                                   ls_long_mac_cm_emta in number,--3.0
                                   ls_long_mac_emta    in number,--3.0
                                   ls_tecnologia       IN operacion.inventario_env_adc.tecnologia%TYPE,
                                   ls_descripcion      IN operacion.inventario_env_adc.descripcion%TYPE,
                                   ls_modelo           IN operacion.inventario_env_adc.modelo%TYPE,
                                   ls_tipo_inventario  IN operacion.inventario_env_adc.tipo_inventario%TYPE,
                                   ls_codigo_sap       IN operacion.inventario_env_adc.codigo_sap%TYPE,
                                   ls_invsn            IN operacion.inventario_env_adc.invsn%TYPE,
                                   ls_mta_mac_cm       IN operacion.inventario_env_adc.mta_mac_cm%TYPE,
                                   ls_mta_mac          IN operacion.inventario_env_adc.mta_mac%TYPE,
                                   ls_unit_addr        IN operacion.inventario_env_adc.unit_addr%TYPE,
                                   ls_nro_tarjeta      IN operacion.inventario_env_adc.nro_tarjeta%TYPE,
                                   ls_inddependencia   IN operacion.inventario_env_adc.inddependencia%TYPE,
                                   ln_idrecursoext     IN operacion.inventario_env_adc.id_recurso_ext%TYPE,
                                   ls_observacion      IN operacion.inventario_env_adc.observacion%TYPE,
                                   ln_quantity         IN operacion.inventario_env_adc.quantity%TYPE,
                                   ln_fecha_inventario IN operacion.inventario_env_adc.fecha_inventario%TYPE,
                                   ln_flg_tipo         IN operacion.inventario_env_adc.flg_tipo%TYPE) IS -- 2.0 FASE 2 ETA

    LN_INVENTARIO           operacion.inventario_env_adc.id_inventario%TYPE;

  BEGIN
      --Inicio 23.0
      IF SGAFUN_VALIDA_CONFIG_PUERTO(ls_codigo_sap) = 0 then
      --Fin 23.0
         INSERT INTO operacion.inventario_env_adc
                (id_proceso, --3.0
                 id_inventario, --3.0
                 tecnologia,
                 descripcion,
                 modelo,
                 tipo_inventario,
                 codigo_sap,
                 invsn,
                 mta_mac_cm,
                 mta_mac,
                 unit_addr,
                 nro_tarjeta,
                 inddependencia,
                 id_recurso_ext,
                 observacion,
                 quantity,
                 fecha_inventario,
                 flg_carga,
                 flg_tipo) -- 2.0 ETA FASE 2
              VALUES
                (ln_id_proceso,--3.0
                 operacion.sq_inventario_env_adc.nextval,--3.0
                 ls_tecnologia,
                 ls_descripcion,
                 ls_modelo,
                 ls_tipo_inventario,
                 ls_codigo_sap,
                 ls_invsn,
                 ls_mta_mac_cm,
                 ls_mta_mac,
                 ls_unit_addr,
                 ls_nro_tarjeta,
                 ls_inddependencia,
                 ln_idrecursoext,
                 ls_observacion,
                 ln_quantity,
                 ln_fecha_inventario,
                 '1',
                 ln_flg_tipo) returning id_inventario into LN_INVENTARIO; --eta fase 2 --3.0

       --Inicio 23.0
       elsif SGAFUN_VALIDA_CONFIG_PUERTO(ls_codigo_sap) > 0 then
          FOR config IN (select '.'||id_servicio||'-'||id_abrev as config_puerto
                           from OPERACION.config_puertos
                          where IDUNICO = ls_codigo_sap
                            and estado = 1)
          loop
             INSERT INTO operacion.inventario_env_adc
                    (id_proceso,
                     id_inventario,
                     tecnologia,
                     descripcion,
                     modelo,
                     tipo_inventario,
                     codigo_sap,
                     invsn,
                     mta_mac_cm,
                     mta_mac,
                     unit_addr,
                     nro_tarjeta,
                     inddependencia,
                     id_recurso_ext,
                     observacion,
                     quantity,
                     fecha_inventario,
                     flg_carga,
                     flg_tipo,
                     flg_config_puerto)
                  VALUES
                    (ln_id_proceso,
                     operacion.sq_inventario_env_adc.nextval,
                     ls_tecnologia,
                     ls_descripcion,
                     ls_modelo,
                     ls_tipo_inventario,
                     ls_codigo_sap,
                     ls_invsn||config.config_puerto,
                     ls_mta_mac_cm,
                     ls_mta_mac,
                     ls_unit_addr,
                     ls_nro_tarjeta,
                     ls_inddependencia,
                     ln_idrecursoext,
                     ls_observacion,
                     ln_quantity,
                     ln_fecha_inventario,
                     '1',
                     ln_flg_tipo,
                     '1')returning id_inventario into LN_INVENTARIO;
           end loop;
       end if;
       --Fin 23.0

     p_validar_excl_carga_masiva(ln_id_proceso,--3.0
                                 ls_long_dni,--3.0
                                 ls_long_serie_deco,--3.0
                                 ls_long_ua_deco,--3.0
                                 ls_long_serie_emta,--3.0
                                 ls_long_mac_cm_emta,--3.0
                                 ls_long_mac_emta,--3.0
                                 LN_INVENTARIO,
                                ls_tecnologia,
                                ln_idrecursoext,
                                ln_fecha_inventario,
                                ln_flg_tipo); -- 2.0 FASE 2 ETA

  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20500,
                              '[operacion.pq_adm_cuadrilla.p_carga_inventario_adc] ' ||
                              SQLERRM);

  END;
  /******************************************************************************
    Ver         Date          Author                   Descripcion
  ---------  ----------  ------------------  ------------------------------------
  1.0        16/06/2015  Luis Polo Benites   Valida los datos ingresados a traves del excel
  2.0        20/05/2016  Juan Gonzales       Cambio en Codigos de SAP
  3.0        02/03/2016  Steve Panduro       ETA FASE 2 CE
  4.0        02/03/2016  Steve Panduro       Modificacion de descripcion
  5.0        26/09/2016  Justiniano Condori  Sol. Cambio - Inventario
  ******************************************************************************/
  PROCEDURE p_validar_excl_carga_masiva(ln_id_proceso       in number,--5.0
                                        ln_long_dni         in number,--5.0
                                        ln_long_serie_deco  in number,--5.0
                                        ln_long_ua_deco     in number,--5.0
                                        ln_long_serie_emta  in number,--5.0
                                        ln_long_mac_cm_emta in number,--5.0
                                        ln_long_mac_emta    in number,--5.0
                                        ln_idinventario     IN operacion.inventario_env_adc.id_inventario%TYPE,
                                        ls_tecnologia       IN operacion.inventario_env_adc.tecnologia%TYPE,
                                        ln_idrecursoext     IN operacion.inventario_env_adc.id_recurso_ext%TYPE,
                                        ln_fecha_inventario IN operacion.inventario_env_adc.fecha_inventario%TYPE,
                                        ln_flg_tipo         IN operacion.inventario_env_adc.flg_tipo%TYPE) -- 2.0 FASE 2 ETA

   IS
    ln_existe               number;
    ls_modelo_ce            operacion.inventario_env_adc.modelo%TYPE;--3.0
    ls_tipo_inventario_ce   operacion.inventario_env_adc.tipo_inventario%TYPE;--3.0
    ls_codigo_sap       operacion.inventario_env_adc.codigo_sap%TYPE;--2.0
    ls_letra                VARCHAR2(20); --2.0
    lv_tipo_eq              varchar2(20); --5.0
    lv_invsn                operacion.inventario_env_adc.invsn%TYPE; -- 23.0

  BEGIN
     FOR reg IN (SELECT i.id_inventario,
                        i.tecnologia,
                        i.id_recurso_ext,
                        i.fecha_inventario,
                        i.codigo_sap,
                        i.invsn,
                        i.modelo,
                        i.unit_addr,
                        i.mta_mac_cm,
                        i.mta_mac,
                        ci.archivo,
                        i.flg_config_puerto -- 23.0
                   FROM operacion.inventario_env_adc i,
                        operacion.cab_inventario_env_adc ci
                  where i.id_proceso=ci.id_proceso
                    and i.id_proceso=ln_id_proceso
                    AND i.id_inventario = ln_idinventario)
    -- Fin 5.0

     LOOP

     --Inicio 23.0
     if reg.flg_config_puerto = 1 then
        lv_invsn := substr(reg.invsn,1,instr(reg.invsn,'.',-1,1) -1);
        reg.invsn := lv_invsn;
     end if;

     --Fin 23.0
     --2.0 Inicio --
      select TRANSLATE(reg.codigo_sap, '+ -.0123456789', ' ') into ls_letra from dual;
      if ls_letra is null then
         ls_codigo_sap:= lpad( reg.codigo_sap, 18, '0') ;
      else
         ls_codigo_sap:= reg.codigo_sap;
      end if;
      --2.0 Fin --
      -- Ini 5.0
      -- Validar la Longitud del DNI
      If length(nvl(ln_idrecursoext,0)) < ln_long_dni then
         INSERT INTO operacion.inventario_env_adc_log_err
           (id_inventario,
            tecnologia,
            nom_archivo,
            id_recurso_ext,
            des_error,
            fecha_inventario,
            flg_tipo,
            id_proceso)
         VALUES
           (ln_idinventario,
            reg.tecnologia,
            reg.archivo,
            ln_idrecursoext,
            'El DNI no debe ser menor a '||ln_long_dni,
            reg.fecha_inventario,
            ln_flg_tipo,
            ln_id_proceso);

         update operacion.inventario_env_adc eq
            set eq.flg_carga = 0
          where id_inventario = reg.id_inventario;

         return;
      end if;
      -- Fin 5.0
      -- si la Tecnologia es HFC y Modelo es NULL
      IF reg.tecnologia = 'HFC' then
         -- validar serie con maestro --
          select count(*)
            into ln_existe
            from operacion.maestro_series_equ eq
           where eq.cod_sap = ls_codigo_sap --2.0
             and nroserie = reg.invsn;

        if ln_existe = 0 then
          INSERT INTO operacion.inventario_env_adc_log_err
            (id_inventario,
             tecnologia,
             nom_archivo,
             id_recurso_ext,
             des_error,
             fecha_inventario,
             id_proceso, --5.0
             flg_tipo) --3.0 FASE 2 ETA
          VALUES
            (ln_idinventario,--5.0
             reg.tecnologia,
             reg.archivo,
             reg.id_recurso_ext,
             'Serie ' || reg.invsn || ' y codigo de SAP ' || reg.codigo_sap ||
             ' no existe en tabla operacion.maestro_series_equ.',
             reg.fecha_inventario,
             ln_id_proceso, --5.0
             ln_flg_tipo); --3.0 FASE 2 ETA

          update operacion.inventario_env_adc eq
             set eq.flg_carga = 0
           where id_inventario = reg.id_inventario;

          return;
        end if;

        if reg.modelo IS NULL THEN
          INSERT INTO operacion.inventario_env_adc_log_err
            (id_inventario,
             tecnologia,
             nom_archivo,
             id_recurso_ext,
             des_error,
             fecha_inventario,
             id_proceso, --5.0
             flg_tipo) --3.0 FASE 2 ETA
          VALUES
            (ln_idinventario,--5.0
             reg.tecnologia,
             reg.archivo,
             reg.id_recurso_ext,
             'Modelo no debe ser NULL',
             reg.fecha_inventario,
             ln_id_proceso, --5.0
             ln_flg_tipo); --3.0 FASE 2 ETA

          update operacion.inventario_env_adc eq
             set eq.flg_carga = 0
           where id_inventario = reg.id_inventario;

          return;
        end if;

        -- Ini 5.0
        -- Consulta si el modelo es correcto
        select count(1)
          into ln_existe
         from operacion.parametro_cab_adc pca,
              operacion.parametro_det_adc pda
        where pca.id_parametro=pda.id_parametro
          and pca.abreviatura='VAL_EQ_ITW'
          and trim(pda.codigoc)=reg.modelo;

        if ln_existe=0 then
          INSERT INTO operacion.inventario_env_adc_log_err
            (id_inventario,
             tecnologia,
             nom_archivo,
             id_recurso_ext,
             des_error,
             fecha_inventario,
             id_proceso, --5.0
             flg_tipo)
          VALUES
            (ln_idinventario,
             reg.tecnologia,
             reg.archivo,
             reg.id_recurso_ext,
             'El Modelo '||reg.modelo||' es incorrecto',
             reg.fecha_inventario,
             ln_id_proceso, --5.0
             ln_flg_tipo);

          update operacion.inventario_env_adc eq
             set eq.flg_carga = 0
           where id_inventario = reg.id_inventario;
          return;
        end if;
        -- Valida el Tipo
        select pda.abreviatura
          into lv_tipo_eq
          from operacion.parametro_cab_adc pca,
               operacion.parametro_det_adc pda
         where pca.id_parametro = pda.id_parametro
           and pca.abreviatura = 'VAL_EQ_ITW'
           and trim(pda.codigoc) = reg.modelo;
        if lv_tipo_eq='DECO' then

          -- Valida que se requiera numero de serie y Unit Address

         if reg.unit_addr is null then
             INSERT INTO operacion.inventario_env_adc_log_err
              (id_inventario,
               tecnologia,
               nom_archivo,
               id_recurso_ext,
               des_error,
               fecha_inventario,
               id_proceso, --5.0
               flg_tipo)
             VALUES
              (ln_idinventario,
               reg.tecnologia,
               reg.archivo,
               reg.id_recurso_ext,
               'El Unit Addressno no puede ser nula',
               reg.fecha_inventario,
               ln_id_proceso, --5.0
               ln_flg_tipo);

             update operacion.inventario_env_adc eq
                set eq.flg_carga = 0
             where id_inventario = reg.id_inventario;
             return;
         elsif  reg.mta_mac_cm is not null or reg.mta_mac is not null then
              INSERT INTO operacion.inventario_env_adc_log_err
               (id_inventario,
                tecnologia,
                nom_archivo,
                id_recurso_ext,
                des_error,
                fecha_inventario,
                id_proceso, --5.0
                flg_tipo)
             VALUES
               (ln_idinventario,
                reg.tecnologia,
                reg.archivo,
                reg.id_recurso_ext,
                'Tipo de equipo Deco no debe tener MAC EMTA- Internet: ' || reg.mta_mac_cm || ' y MAC EMTA- Telefono: '|| reg.mta_mac,
                reg.fecha_inventario,
                ln_id_proceso, --5.0
                ln_flg_tipo);

             update operacion.inventario_env_adc eq
                set eq.flg_carga = 0
              where id_inventario = reg.id_inventario;
             return;
          end if;

          -- Valida Longitud de Serie
          if length(reg.invsn) < ln_long_serie_deco then
             INSERT INTO operacion.inventario_env_adc_log_err
               (id_inventario,
                tecnologia,
                nom_archivo,
                id_recurso_ext,
                des_error,
                fecha_inventario,
                id_proceso, --5.0
                flg_tipo)
             VALUES
               (ln_idinventario,
                reg.tecnologia,
                reg.archivo,
                reg.id_recurso_ext,
                'Para la Serie: ' || reg.invsn || ', la longitud es menor a la minima.',
                reg.fecha_inventario,
                ln_id_proceso, --5.0
                ln_flg_tipo);

             update operacion.inventario_env_adc eq
                set eq.flg_carga = 0
              where id_inventario = reg.id_inventario;
             return;
          end if;

          -- Valida Longitud de UA
          if length(reg.unit_addr) < ln_long_ua_deco then
             INSERT INTO operacion.inventario_env_adc_log_err
               (id_inventario,
                tecnologia,
                nom_archivo,
                id_recurso_ext,
                des_error,
                fecha_inventario,
                id_proceso, --5.0
                flg_tipo)
             VALUES
               (ln_idinventario,
                reg.tecnologia,
                reg.archivo,
                reg.id_recurso_ext,
                'Para el Unit Address: ' || reg.unit_addr || ', la longitud es menor a la minima.',
                reg.fecha_inventario,
                ln_id_proceso, --5.0
                ln_flg_tipo);

             update operacion.inventario_env_adc eq
                set eq.flg_carga = 0
              where id_inventario = reg.id_inventario;
             return;
          end if;
        end if;
        if lv_tipo_eq='EMTA' then

          --Valida numro de serie + eMTA MAC_CM + eMTA
          if  reg.unit_addr is not null then
              INSERT INTO operacion.inventario_env_adc_log_err
               (id_inventario,
                tecnologia,
                nom_archivo,
                id_recurso_ext,
                des_error,
                fecha_inventario,
                id_proceso, --5.0
                flg_tipo)
             VALUES
               (ln_idinventario,
                reg.tecnologia,
                reg.archivo,
                reg.id_recurso_ext,
                'Tipo de equipo EMTA no debe tener UA: ' || reg.unit_addr ,
                reg.fecha_inventario,
                ln_id_proceso, --5.0
                ln_flg_tipo);

             update operacion.inventario_env_adc eq
                set eq.flg_carga = 0
              where id_inventario = reg.id_inventario;
             return;
          elsif  reg.mta_mac_cm is null or reg.mta_mac is null then
              INSERT INTO operacion.inventario_env_adc_log_err
               (id_inventario,
                tecnologia,
                nom_archivo,
                id_recurso_ext,
                des_error,
                fecha_inventario,
                id_proceso, --5.0
                flg_tipo)
             VALUES
               (ln_idinventario,
                reg.tecnologia,
                reg.archivo,
                reg.id_recurso_ext,
                'Tipo MAC EMTA- Internet y MAC EMTA- Telefono no deben ser nulos',
                reg.fecha_inventario,
                ln_id_proceso, --5.0
                ln_flg_tipo);

             update operacion.inventario_env_adc eq
                set eq.flg_carga = 0
              where id_inventario = reg.id_inventario;
             return;
          end if;

          -- Valida Longitud de Serie
          if length(reg.invsn) < ln_long_serie_emta then
             INSERT INTO operacion.inventario_env_adc_log_err
               (id_inventario,
                tecnologia,
                nom_archivo,
                id_recurso_ext,
                des_error,
                fecha_inventario,
                id_proceso, --5.0
                flg_tipo)
             VALUES
               (ln_idinventario,
                reg.tecnologia,
                reg.archivo,
                reg.id_recurso_ext,
                'Para la Serie: ' || reg.invsn || ', la longitud es menor a la minima.',
                reg.fecha_inventario,
                ln_id_proceso, --5.0
                ln_flg_tipo);
             update operacion.inventario_env_adc eq
                set eq.flg_carga = 0
              where id_inventario = reg.id_inventario;
             return;
          end if;
          -- Valida Longitud de MAC1
          if length(reg.mta_mac_cm) < ln_long_mac_cm_emta then
             INSERT INTO operacion.inventario_env_adc_log_err
               (id_inventario,
                tecnologia,
                nom_archivo,
                id_recurso_ext,
                des_error,
                fecha_inventario,
                id_proceso, --5.0
                flg_tipo)
             VALUES
               (ln_idinventario,
                reg.tecnologia,
                reg.archivo,
                reg.id_recurso_ext,
                'Para el MAC: ' || reg.mta_mac_cm || ', la longitud es menor a la minima.',
                reg.fecha_inventario,
                ln_id_proceso, --5.0
                ln_flg_tipo);
             update operacion.inventario_env_adc eq
                set eq.flg_carga = 0
              where id_inventario = reg.id_inventario;
             return;
          end if;
          -- Valida Longitud de MAC2
          if length(reg.mta_mac) < ln_long_mac_emta then
             INSERT INTO operacion.inventario_env_adc_log_err
               (id_inventario,
                tecnologia,
                nom_archivo,
                id_recurso_ext,
                des_error,
                fecha_inventario,
                id_proceso, --5.0
                flg_tipo)
             VALUES
               (ln_idinventario,
                reg.tecnologia,
                reg.archivo,
                reg.id_recurso_ext,
                'Para el MAC CM: ' || reg.mta_mac || ', la longitud es menor a la minima.',
                reg.fecha_inventario,
                ln_id_proceso, --5.0
                ln_flg_tipo);
             update operacion.inventario_env_adc eq
                set eq.flg_carga = 0
              where id_inventario = reg.id_inventario;
             return;
          end if;
        end if;
      END IF;
 -- Fin 5.0
    END LOOP;
  END;
  /******************************************************************************
    Ver         Date          Author                   Descripcion
  ---------  ----------  ------------------  ------------------------------------
  1.0        16/06/2015  Luis Polo Benites   Ejecuta el WS de inventario FULL
  2.0        25/05/2016  Juan Gonzales       Carga Incremental
  3.0        03/06/2016  Juan Gonzales       Personalizado por Contrata
  4.0        03/06/2016  Juan Gonzales       Control de errores
  5.0        05/10/2016  Justiniano Condori  PROY-22818-IDEA-28605 Sol.Cambio Inv.
  ******************************************************************************/
  PROCEDURE p_ws_inventario(an_id_proceso   in number, --5.0
                            an_fecha        IN operacion.inventario_env_adc.fecha_inventario%TYPE,
                            av_servicio     varchar2,
                            an_flg_tipo     in operacion.inventario_env_adc.flg_tipo%type, -- 2.0 eta fase 2
                            av_contrata     IN operacion.inventario_env_adc.usureg%type, --3.0
                            av_accion       IN VARCHAR2,--3.0
                            an_iderror      OUT NUMERIC,
                            av_mensajeerror OUT VARCHAR2) IS
    lv_trama    CLOB;
    pv_xml      CLOB;
    lv_servicio VARCHAR2(100);
    e_error EXCEPTION;
    c_delete constant varchar2(50) := 'delete_inventory'; --3.0
    c_update constant varchar2(50) := 'update_inventory'; --3.0
    ln_val_env_ok number; --5.0
    ln_val_env_total number; --5.0
    CURSOR lcur_inv_fecha IS
      SELECT DISTINCT i.id_recurso_ext
        FROM operacion.inventario_env_adc i
     --Ini 5.0
     where i.id_proceso=an_id_proceso
       and i.flg_carga=1;
     --Fin 5.0
  BEGIN
    an_iderror      := 0;
    av_mensajeerror := '';

    IF av_servicio = 'T' then
      lv_servicio := 'cargarInventarioTotalSGA_ADC';
      -- Proceso de Generacion de Trama : modo FULL --
      p_gen_trama_inventario_full(an_fecha,
                                  av_contrata,--3.0
                                  lv_trama,
                                  an_iderror,
                                  av_mensajeerror);

      IF an_iderror <> 0 THEN
        RETURN;
      END IF;
      BEGIN --4.0
        webservice.pq_obtiene_envia_trama_adc.p_ws_consulta(0,
                                                            0,
                                                            lv_servicio,
                                                            lv_trama,
                                                            pv_xml,
                                                            av_mensajeerror,
                                                            an_iderror);
    -- ini 4.0
        if an_iderror <> 0 then
           raise e_error;
        end if;
       EXCEPTION
       WHEN OTHERS THEN
            av_mensajeerror := '[operacion.pq_adm_cuadrilla.p_ws_inventario] Se genero el error:  webservice.pq_obtiene_envia_trama_adc.p_ws_consulta,  ' ||
                               av_mensajeerror || '.';
            raise e_error;
      end;
    -- fin 4.0
      IF an_iderror = 0 THEN
        -- actualizar flag de carga
        update operacion.inventario_env_adc i
           set envio_eta = '1'
         WHERE i.fecha_inventario = an_fecha
           and (av_contrata='%' or i.usureg = av_contrata)--3.0
           and i.flg_carga = '1';--3.0
      END IF;
   -- ini 4.0
      Begin
        webservice.PQ_OBTIENE_ENVIA_TRAMA_ADC.p_inventario(an_id_proceso, --5.0
                                                           Pv_xml,
                                                           an_fecha,
                                                           null, --2.0
                                                           an_flg_tipo,
                                                           an_iderror,
                                                           av_mensajeerror);
        if an_iderror <> 0 then
           raise e_error;
        end if;
       EXCEPTION
       WHEN OTHERS THEN
            av_mensajeerror := '[operacion.pq_adm_cuadrilla.p_ws_inventario] Se genero el error: webservice.PQ_OBTIENE_ENVIA_TRAMA_ADC.p_inventario  ' ||
                              av_mensajeerror || '.';
            raise e_error;
      end;
  -- fin 4.0
    else
      lv_servicio := 'cargarInventarioIncrementalSGA_ADC';

      FOR lcur_inv IN lcur_inv_fecha LOOP
        -- Proceso de Generacion de Trama
        p_gen_trama_inventario_inc(an_id_proceso,--5.0
                                   an_fecha,
                                   lcur_inv.id_recurso_ext,
                                   av_contrata, --3.0
                                   av_accion,--3.0
                                   lv_trama,
                                   an_iderror,
                                   av_mensajeerror);

        IF an_iderror <> 0 THEN
          RETURN;
        END IF;

        BEGIN --4.0
        webservice.pq_obtiene_envia_trama_adc.p_ws_consulta_inv(an_id_proceso, --5.0
                                                            lv_servicio,
                                                            lv_trama,
                                                            pv_xml,
                                                            an_iderror, --5.0
                                                            av_mensajeerror); --5.0
       -- ini 4.0
        if an_iderror in (-1,-2) then --5.0
           raise e_error;
        -- Ini 5.0
        else
           webservice.PQ_OBTIENE_ENVIA_TRAMA_ADC.p_inventario(an_id_proceso,
                                                              Pv_xml,
                                                              an_fecha,
                                                              lcur_inv.id_recurso_ext,
                                                              an_flg_tipo,
                                                              an_iderror,
                                                              av_mensajeerror);
        -- Fin 5.0
        end if;
       EXCEPTION
       WHEN OTHERS THEN
            -- Ini 5.0
            av_mensajeerror := '   Codigo Error: '  || to_char(sqlcode)|| chr(13) ||
                               '   Mensaje Error: ' || to_char(sqlerrm)|| chr(13) ||
                               '   Linea Error: '   || dbms_utility.format_error_backtrace;
            -- Fin 5.0
            raise e_error;
       END;

      END LOOP;
      -- Ini 5.0
      select count(1)
        into ln_val_env_total
        from operacion.inventario_env_adc iea
       where iea.id_proceso=an_id_proceso;

      select count(1)
        into ln_val_env_ok
        from operacion.inventario_env_adc iea
       where iea.id_proceso=an_id_proceso
         and iea.envio_eta='1';

      if ln_val_env_ok=ln_val_env_total then
        -- Enviado Ok
          update operacion.cab_inventario_env_adc
             set estado_proceso=1
           where id_proceso=an_id_proceso;
      else
        -- Enviado con Errores
          update operacion.cab_inventario_env_adc
             set estado_proceso=2
           where id_proceso=an_id_proceso;
      end if;
      -- Fin 5.0
    end if;

  EXCEPTION
    WHEN e_error THEN
      an_iderror := -1;

    WHEN OTHERS THEN
      -- Ini 5.0
      an_iderror      := -1;
      av_mensajeerror := '   Codigo Error: '  || to_char(sqlcode)|| chr(13) ||
                         '   Mensaje Error: ' || to_char(sqlerrm)|| chr(13) ||
                         '   Linea Error: '   || dbms_utility.format_error_backtrace;
      -- Fin 5.0
  END;
  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        16/06/2015  Luis Polo Benites      Generacion de trama para inventario
  2.0        11/05/2016  juan Gonzales          Incidencia SGA-SD-788452
  3.0        03/06/2016  Juan Gonzales          Adicionar contrata
  ******************************************************************************/
  PROCEDURE p_gen_trama_inventario_full(an_fecha        IN operacion.inventario_env_adc.fecha_inventario%TYPE,
                                        av_contrata     IN operacion.inventario_env_adc.usureg%type, --3.0
                                        av_trama        OUT CLOB,
                                        an_iderror      OUT NUMERIC,
                                        as_mensajeerror OUT VARCHAR2) IS

    lv_delimitador VARCHAR2(1) := '|';
    lv_negativa    VARCHAR2(1) := '~';
    lv_puntoycom   VARCHAR2(1) := ';';
    lv_separadni   VARCHAR2(2) := '__';
    lv_auditoria   VARCHAR2(100);
    lv_ip          VARCHAR2(20);
    lv_user        VARCHAR2(50) := USER;
    lv_idrecurso   operacion.inventario_env_adc.id_recurso_ext%type;
    av_trama1      CLOB;
    av_trama2      CLOB;
    ln_inv         number;

    CURSOR reg_inv_fecha IS
      SELECT i.id_inventario,
             i.tecnologia,
             i.modelo,
             i.codigo_sap,
             i.tipo_inventario,
             i.fecha_inventario,
             i.mta_mac_cm,
             i.mta_mac,
             i.nro_tarjeta,
             i.inddependencia,
             i.observacion,
             i.quantity,
             i.descripcion,
             i.invsn,
             i.unit_addr,
             i.id_recurso_ext
        FROM operacion.inventario_env_adc i
       WHERE i.fecha_inventario = an_fecha
         and i.id_recurso_ext = lv_idrecurso
         and nvl(i.envio_eta, '0') = '0'
         AND nvl(i.flg_carga,0) = 1 --4.0
         and (av_contrata='%' or i.usureg = av_contrata)--3.0
       order by i.invsn;

    CURSOR reg_inv is
      SELECT max(i.id_recurso_ext) id_inventario
        FROM operacion.inventario_env_adc i
       WHERE i.fecha_inventario = an_fecha
          and nvl(i.envio_eta, '0') = '0'                 --3.0
          and nvl(i.flg_carga,0) = 1                      --3.0
          and (av_contrata='%' or i.usureg = av_contrata);--3.0

    CURSOR reg_inv_recurso IS
      SELECT DISTINCT i.id_recurso_ext
        FROM operacion.inventario_env_adc i
       WHERE i.fecha_inventario = an_fecha
          and nvl(i.envio_eta, '0') = '0'                 --3.0
          and nvl(i.flg_carga,0) = 1                      --3.0
          and (av_contrata='%' or i.usureg = av_contrata);--3.0

  BEGIN
    BEGIN

      SELECT sys_context('userenv', 'ip_address') INTO lv_ip FROM dual;

      lv_auditoria := lv_ip || lv_delimitador || lv_aplicacion ||
                      lv_delimitador || lv_user;

      FOR lcur_rec IN reg_inv LOOP
        av_trama := lcur_rec.id_inventario || lv_delimitador;
      END LOOP;

      av_trama1 := 'inventory_only' || lv_delimitador || 'full' ||
                   lv_delimitador || to_char(an_fecha, 'dd/mm/yyyy') ||
                   lv_delimitador || 'appt_number' || lv_delimitador ||
                   'invsn' || lv_delimitador;

      av_trama := av_trama || lv_auditoria || lv_delimitador || av_trama1;

      FOR lcur_rec IN reg_inv_recurso LOOP
        ln_inv       := 0;
        lv_idrecurso := lcur_rec.id_recurso_ext;
        av_trama     := av_trama || lv_idrecurso || lv_separadni;

        av_trama2 := '';
        FOR lcur_fecha IN reg_inv_fecha LOOP
          av_trama2 := av_trama2 || 'XI_IDINVENTARIO=' ||
                       lcur_fecha.id_inventario || lv_negativa ||
                       'XI_TECNOLOGIA=' || lcur_fecha.tecnologia ||
                       lv_negativa || 'inv_description=' ||
                       lcur_fecha.descripcion || lv_negativa ||
                       'XI_MODELO=' || lcur_fecha.modelo || lv_negativa ||
                       'invtype_label=' || lcur_fecha.tipo_inventario ||
                       lv_negativa || 'XI_CODIGOSAP=' ||
                       lcur_fecha.codigo_sap || lv_negativa || 'invsn=' ||
                       lcur_fecha.invsn || lv_negativa || 'XI_MTA_MAC_CM=' ||
                       lcur_fecha.mta_mac_cm || lv_negativa ||
                       'XI_MTA_MAC=' || lcur_fecha.mta_mac || lv_negativa ||
                       'XI_UNIT_ADDR=' || lcur_fecha.unit_addr ||
                       lv_negativa || 'XI_NRO_TARJETA=' ||
                       lcur_fecha.nro_tarjeta || lv_negativa ||
                       'XI_INDDEPENDENCIA=' || lcur_fecha.inddependencia ||
                       lv_negativa || 'XI_OBSERVACION=' ||
                       lcur_fecha.observacion || lv_negativa || 'quantity=' ||
                       lcur_fecha.quantity || lv_puntoycom;
          ln_inv    := ln_inv + 1;
        END LOOP;

        if ln_inv = 0 then
          av_trama := substr(av_trama,
                             1,
                             length(av_trama) -
                             length(lv_idrecurso || lv_separadni));
        else
          av_trama := av_trama ||
                      SUBSTR(av_trama2, 1, length(av_trama2) - 1) ||
                      lv_negativa || lv_negativa;
        end if;
      END LOOP;
      av_trama := substr(av_trama, 1, length(av_trama) - 2);

      an_iderror      := 0;
      as_mensajeerror := NULL;

    EXCEPTION
      WHEN no_data_found THEN
        an_iderror      := -1;
        as_mensajeerror := '[operacion.pq_adm_cuadrilla.p_gen_trama_inventario_full] Inventario no existe';

      WHEN OTHERS THEN
        an_iderror      := -2;
        as_mensajeerror := '[operacion.pq_adm_cuadrilla.p_gen_trama_inventario_full] No se pudo generar la trama de inventario error: ' ||
                           SQLERRM || '.';
    END;
  END;
  /******************************************************************************
  Ver        Date        Author             Description
  ---------  ----------  -----------------  -----------------------------------
  1.0        16/06/2015  Luis Polo Benites  Generacion de trama para inventario
  2.0        11/05/2016  juan Gonzales      Incidencia SGA-SD-788452
  3.0        03/06/2016  juan Gonzales      Parametro de Acci?n
  4.0        05/10/2016  Justiniano Condori Modificar el proceso de envio de trama
  ******************************************************************************/
  PROCEDURE p_gen_trama_inventario_inc(an_id_proceso    in number, --4.0
                                       an_fecha         IN operacion.inventario_env_adc.fecha_inventario%TYPE,
                                       an_idrecurso_ext IN operacion.inventario_env_adc.id_recurso_ext%TYPE,
                                       av_contrata      IN operacion.inventario_env_adc.usureg%type, --3.0
                                       av_accion        IN VARCHAR2,--3.0
                                       av_trama         OUT CLOB,
                                       an_iderror       OUT NUMERIC,
                                       as_mensajeerror  OUT VARCHAR2) IS

    lv_delimitador VARCHAR2(1) := '|';
    lv_negativa    VARCHAR2(1) := '~';
    lv_separador   VARCHAR2(1) := ';';
    lv_auditoria   VARCHAR2(100);
    lv_ip          VARCHAR2(20);
    lv_user        VARCHAR2(50) := USER;
    av_trama1      CLOB;
    av_trama2      CLOB;
    c_delete constant varchar2(50) := 'delete_inventory'; --3.0
    c_update constant varchar2(50) := 'update_inventory'; --3.0

    CURSOR reg_inv_fecha IS
      SELECT i.id_inventario,
             i.tecnologia,
             i.modelo,
             i.codigo_sap,
             i.tipo_inventario,
             i.fecha_inventario,
             i.mta_mac_cm,
             i.mta_mac,
             i.nro_tarjeta,
             i.inddependencia,
             i.observacion,
             i.quantity,
             i.descripcion,
             i.invsn,
             i.unit_addr,
             i.id_recurso_ext
        FROM operacion.inventario_env_adc i
       WHERE i.fecha_inventario = an_fecha
         and i.id_proceso=an_id_proceso --4.0
         AND i.id_recurso_ext = an_idrecurso_ext
         AND nvl(i.flg_carga,0)=1 --4.0
         AND (av_contrata='%' or i.usureg = av_contrata)--3.0
       order by i.invsn;

    CURSOR reg_inv_recurso IS
      SELECT i.id_inventario, i.tipo_inventario
        FROM operacion.inventario_env_adc i
       WHERE i.fecha_inventario = an_fecha
         AND i.id_recurso_ext = an_idrecurso_ext
         and i.id_proceso=an_id_proceso --4.0
         AND nvl(i.flg_carga,0) = 1
         AND (av_contrata='%' or i.usureg = av_contrata);
          -- fin 3.0

  BEGIN
    BEGIN

      SELECT sys_context('userenv', 'ip_address') INTO lv_ip FROM dual;

      lv_auditoria := lv_ip || lv_delimitador || lv_aplicacion ||
                      lv_delimitador || lv_user;

      FOR lcur_rec IN reg_inv_recurso LOOP
        av_trama := lcur_rec.id_inventario || lv_delimitador;
      END LOOP;

      FOR lcur_rec IN reg_inv_recurso LOOP

        av_trama1 := 'inventory_only' || lv_delimitador || 'incremental' ||
                     lv_delimitador || to_char(an_fecha, 'dd/mm/yyyy') ||
                     lv_delimitador || 'appt_number' || lv_delimitador ||
                     'invsn' || --lv_negativa || 'invtype' ||
                     lv_delimitador || to_char(an_fecha, 'yyyy-mm-dd') ||
                     lv_delimitador || av_accion || lv_delimitador || --3.0
                     an_idrecurso_ext;

      END LOOP;

      FOR lcur_fecha IN reg_inv_fecha LOOP
        av_trama2 := av_trama2 || 'XI_IDINVENTARIO=' ||
                     lcur_fecha.id_inventario || lv_negativa ||
                     'XI_TECNOLOGIA=' || lcur_fecha.tecnologia ||
                     lv_negativa || 'inv_description=' ||
                     lcur_fecha.descripcion || lv_negativa || 'XI_MODELO=' ||
                     lcur_fecha.modelo || lv_negativa || 'invtype_label=' ||
                     lcur_fecha.tipo_inventario || lv_negativa ||
                     'XI_CODIGOSAP=' || lcur_fecha.codigo_sap ||
                     lv_negativa || 'invsn=' || lcur_fecha.invsn ||
                     lv_negativa || 'XI_MTA_MAC_CM=' ||
                     lcur_fecha.mta_mac_cm || lv_negativa || 'XI_MTA_MAC=' ||
                     lcur_fecha.mta_mac || lv_negativa || 'XI_UNIT_ADDR=' ||
                     lcur_fecha.unit_addr || lv_negativa ||
                     'XI_NRO_TARJETA=' || lcur_fecha.nro_tarjeta ||
                     lv_negativa || 'XI_INDDEPENDENCIA=' ||
                     lcur_fecha.inddependencia || lv_negativa ||
                     'XI_OBSERVACION=' || lcur_fecha.observacion ||
                     lv_negativa || 'quantity=' || lcur_fecha.quantity ||
                     lv_separador;

      END LOOP;
      av_trama2 := substr(av_trama2, 1, length(av_trama2) - 1); --**** cambio

      -- revisar trama --
      av_trama := av_trama || lv_auditoria || lv_delimitador || av_trama1 ||
                  lv_delimitador || av_trama2;

      an_iderror      := 0;
      as_mensajeerror := NULL;

    EXCEPTION
      WHEN no_data_found THEN
        an_iderror      := -1;
        as_mensajeerror := '[operacion.pq_adm_cuadrilla.p_gen_trama_inventario_inc] Inventario no existe';

      WHEN OTHERS THEN
        an_iderror      := -2;
        as_mensajeerror := '[operacion.pq_adm_cuadrilla.p_gen_trama_inventario_inc] No se pudo generar la trama de inventario error: ' ||
                           SQLERRM || '.';
    END;
  END;
  /******************************************************************************
    Ver         Date          Author                   Descripcion
  ---------  ----------  ------------------  ------------------------------------
  1.0        16/06/2015  Justiniano Condori  Inserta registro en la tabla de creacion de OTs
  ******************************************************************************/
  procedure p_insert_ot_adc(p_sot      in number,
                            p_origen   in varchar2,
                            p_idagenda in number,
                            p_estado   in number,
                            p_motivo   IN operacion.cambio_estado_ot_adc.motivo%TYPE DEFAULT NULL) is
  begin
    INSERT INTO operacion.cambio_estado_ot_adc
      (codsolot, origen, idagenda, id_estado, motivo)
    VALUES
      (p_sot, p_origen, p_idagenda, p_estado, p_motivo);
  end;
  /******************************************************************************
    Ver         Date          Author                   Descripcion
  ---------  ----------  ------------------  ------------------------------------
  1.0        16/06/2015  Nalda Arotinco      Obtiene valores para la creacion de OT
  2.0        18/02/2016  Emma Guzman         Evalua la agenda 1 = MASIVO, 2 = CLARO EMPRESA
  ******************************************************************************/
  PROCEDURE p_obtiene_valores_adc(an_idagenda     IN agendamiento.idagenda%TYPE,
                                  av_idplano      out operacion.parametro_vta_pvta_adc.plano%TYPE,
                                  av_centrop      out operacion.parametro_vta_pvta_adc.idpoblado%TYPE,
                                  av_subtipo      out operacion.parametro_vta_pvta_adc.subtipo_orden%type,
                                  an_tiptra       out operacion.solot.tiptra%type,
                                  av_tipsrv       out operacion.solot.tipsrv%type,
                                  av_bucket       out operacion.parametro_vta_pvta_adc.idbucket%TYPE,
                                  an_dnitec       out operacion.parametro_vta_pvta_adc.dni_tecnico%type,
                                  ad_fecha        out operacion.parametro_vta_pvta_adc.fecha_progra%type,
                                  av_franja       out operacion.parametro_vta_pvta_adc.franja%type,
                                  av_indpp        out operacion.parametro_vta_pvta_adc.flg_puerta%type,
                                  av_zona         out operacion.zona_adc.codzona%type,
                                  an_iderror      OUT NUMERIC,
                                  as_mensajeerror OUT VARCHAR2) IS
    ln_codsuc          operacion.agendamiento.codsuc%type;
    ln_codsolot        operacion.agendamiento.codsolot%type;
    lv_tipo_tecnologia operacion.tipo_orden_adc.tipo_tecnologia%TYPE;
    lv_plano           marketing.vtatabgeoref.idplano%type;
    an_tipo            number; -- 2.0
  BEGIN

    av_idplano      := NULL;
    av_centrop      := NULL;
    av_subtipo      := NULL;
    av_bucket       := NULL;
    an_dnitec       := NULL;
    ad_fecha        := NULL;
    av_franja       := NULL;
    av_indpp        := 0;
    an_iderror      := 0;
    as_mensajeerror := '';

    -- obtener datos 1 --
    begin
      select a.codsuc, a.codsolot
        into ln_codsuc, ln_codsolot
        from agendamiento a
       where a.idagenda = an_idagenda;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        an_iderror      := -1;
        as_mensajeerror := '[operacion.pq_adm_cuadrilla.p_obtiene_valores_adc] Codigo de Agenda  <' ||
                           an_idagenda || '>, no existe en agendamiento.';
        RETURN;
        --RAISE e_error;
    END;

    -- obtener datos 2
    begin
      SELECT tiptra, s.tipsrv
        INTO an_tiptra, av_tipsrv
        FROM solot s
       WHERE codsolot = ln_codsolot;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        an_iderror      := -1;
        as_mensajeerror := '[operacion.pq_adm_cuadrilla.p_obtiene_valores_adc] Codigo de Solicitud Trabajo  <' ||
                           ln_codsolot || '>, no existe en SOLOT.';
        RETURN;
        --RAISE e_error;
    END;

    --ini 2.0
    -- Evaluar SOT
    p_tipo_x_tiposerv(ln_codsolot, an_tipo, an_iderror, as_mensajeerror);

    if an_tipo = 0 then
      RETURN;
    END if;
    -- fin 2.0

    begin

      -- validar tipo de orden
      --ini 2.0
      if an_tipo = 2 then
        SELECT o.tipo_tecnologia
          INTO lv_tipo_tecnologia
          from operacion.tiptrabajo t, operacion.tipo_orden_adc o
         where t.tiptra = an_tiptra
           and t.id_tipo_orden_ce = o.id_tipo_orden(+);
      else--fin 2.0
        SELECT o.tipo_tecnologia
          INTO lv_tipo_tecnologia
          from operacion.tiptrabajo t, operacion.tipo_orden_adc o
         where t.tiptra = an_tiptra
           and t.id_tipo_orden = o.id_tipo_orden(+);
      end if;--2.0

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        lv_tipo_tecnologia := '';
    END;

    if lv_tipo_tecnologia is null then
      lv_tipo_tecnologia := '';
    end if;

    -- obtener plano y centro poblado de sucursal --
    begin
      select idplano, ubigeo2
        into av_idplano, av_centrop
        from marketing.vtasuccli
       where codsuc = ln_codsuc;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        an_iderror      := -1;
        as_mensajeerror := '[operacion.pq_adm_cuadrilla.p_obtiene_valores_adc] No se encontro Sucursal del cliente   - Codigo de Sucursal  <' ||
                           ln_codsuc || '>, no existe en vtasuccli.';
        RETURN;
    END;

    IF lv_tipo_tecnologia = 'DTH' OR lv_tipo_tecnologia = 'LTE' then --26.0
      av_idplano := NULL;
      if av_centrop is null then
        an_iderror      := -1;
        as_mensajeerror := '[operacion.pq_adm_cuadrilla.p_obtiene_valores_adc] No se encontro Sucursal del cliente (Centro Poblado)  - Codigo de Sucursal  <' ||
                           ln_codsuc || '>, no existe en vtasuccli.';
        p_insertar_log_error_ws_adc('p_obtiene_valores_adc',
                                    an_idagenda,
                                    -1,
                                    as_mensajeerror);
        RETURN;
      end if;
    else
      av_centrop := NULL;
      if av_idplano is null then
        an_iderror      := -1;
        as_mensajeerror := '[operacion.pq_adm_cuadrilla.p_obtiene_valores_adc] No se encontro Sucursal del cliente (Plano) Codigo de Sucursal  <' ||
                           ln_codsuc || '>, no existe en vtasuccli.';
        p_insertar_log_error_ws_adc('p_obtiene_valores_adc',
                                    an_idagenda,
                                    -1,
                                    as_mensajeerror);
        RETURN;
      end if;
    end if;

    p_retornar_zona_plano(av_idplano,
                          av_centrop,
                          lv_plano,
                          av_zona,
                          an_iderror,
                          as_mensajeerror);

  -- INI 3.0
    if av_zona is null then
       an_iderror      := -1;
       as_mensajeerror := '[operacion.pq_adm_cuadrilla.p_obtiene_valores_adc] No se encontro una zona asociada al plano o centro poblado.';
        p_insertar_log_error_ws_adc('p_obtiene_valores_adc',
                                    an_idagenda,
                                    -1,
                                    as_mensajeerror);
        RETURN;
    end if;
  -- FIN 3.0
  end;
  /******************************************************************************
    Ver         Date          Author                   Descripcion
  ---------  ----------  ------------------  ------------------------------------
  1.0        16/06/2015  Justiniano Condori  Devolver el Subtipo de Orden en base a la SOT
  ******************************************************************************/
  function f_devuelve_subtipo(p_codsolot in number) return varchar2 is
    ln_cont number;
    lv_subt varchar2(10);
  begin
    select count(i.codequcom)
      into ln_cont
      from operacion.solotpto sp
      join operacion.insprd i
        on sp.pid = i.pid
     where sp.codsolot = p_codsolot
       and i.codequcom in (select pda.codigoc
                             from operacion.parametro_det_adc pda
                            where pda.id_parametro =
                                  (select id_parametro
                                     from operacion.parametro_cab_adc
                                    where abreviatura = 'PARAM_CRE_OT')
                              and abreviatura in ('DEC_DTH_A', 'DEC_DTH_H')
                              and estado = '1'); -- Decos
    if ln_cont <= 2 then
      select pda.codigoc
        into lv_subt
        from operacion.parametro_det_adc pda
       where pda.abreviatura = 'SUBOT_2D'
         and pda.id_parametro =
             (select id_parametro
                from operacion.parametro_cab_adc
               where abreviatura = 'PARAM_CRE_OT')
         and pda.estado = '1';
    else
      select pda.codigoc
        into lv_subt
        from operacion.parametro_det_adc pda
       where pda.abreviatura = 'SUBOT_3D'
         and pda.id_parametro =
             (select id_parametro
                from operacion.parametro_cab_adc
               where abreviatura = 'PARAM_CRE_OT')
         and pda.estado = '1';
    end if;
    return lv_subt;
  end;

  /******************************************************************************
    Ver         Date          Author                   Descripcion
  ---------  ----------  ------------------  ------------------------------------
  1.0        16/06/2015  Steve P.            Actualiza Tabla solotptoqu DTH
  ******************************************************************************/

  procedure p_actualiza_solotptoqu_dth(an_codsolot solot.codsolot%type,
                                       av_numserie solotptoequ.numserie%type,
                                       av_mac      solotptoequ.mac%type,
                                       av_invsn    operacion.trs_interface_iw.mac_address%type,
                                       an_grupo    number,
                                       an_error    out number,
                                       av_error    out varchar2) is

    cursor cur1 is
      select se.codsolot, se.punto, se.orden
        from solotptoequ se,
             solot s,
             solotpto sp,
             inssrv i,
             tipequ t,
             almtabmat a,
             (select a.codigon tipequ, to_number(a.codigoc) grupo
                from opedd a, tipopedd b
               where a.tipopedd = b.tipopedd
                 and b.abrev = 'TIPEQU_DTH_CONAX'
                 and to_number(a.codigoc) = an_grupo) equ_conax
       where se.codsolot = s.codsolot
         and s.codsolot = sp.codsolot
         and se.punto = sp.punto
         and sp.codinssrv = i.codinssrv
         and t.tipequ = se.tipequ
         and a.codmat = t.codtipequ
         and se.codsolot = an_codsolot
         and t.tipequ = equ_conax.tipequ
         and equ_conax.grupo = an_grupo
         and se.iddet not in
             (select t.iddet_tarjeta
                from operacion.tarjeta_deco_asoc t
               where t.codsolot = an_codsolot)
         and rownum = 1;
  begin

    for c_cur in cur1 loop
      if an_grupo = 1 then
        update solotptoequ
           set numserie = av_numserie
         where codsolot = c_cur.codsolot
           and punto = c_cur.punto
           and orden = c_cur.orden;
      elsif an_grupo = 2 then
        update solotptoequ
           set mac = av_mac, numserie = av_invsn
         where codsolot = c_cur.codsolot
           and punto = c_cur.punto
           and orden = c_cur.orden;
      end if;
    end loop;
  exception
    WHEN NO_DATA_FOUND THEN
      an_error := -1;
      av_error := '[operacion.pq_adm_cuadrilla.p_actualiza_solotptoqu_dth] Tarjeta/Deco No Existe ';
    when others then
      an_error := -1;
      av_error := '[operacion.pq_adm_cuadrilla.p_actualiza_solotptoqu_dth] Error p_asocia_tarjeta_deco_DTH ' ||
                  sqlerrm;
  end;

  /******************************************************************************
    Ver         Date          Author                   Descripcion
  ---------  ----------  ------------------  ------------------------------------
  1.0        31/07/2015  Justiniano Condori  Validar si pertenece a Zona Lejana
  ******************************************************************************/
  function f_val_zonalejana(p_idagenda in number) return number is
    ln_tiptra_sot    number;
    ln_tiptra_sot_zl number;
    lv_codsuc        varchar2(20);
    lv_flag_adc      varchar2(2);
    ln_idzona        number;
    ln_idzona_zl     number;
  begin
    -- Tomando tipo de trabajo y Sucursal
    select s.tiptra, a.codsuc
      into ln_tiptra_sot, lv_codsuc
      from operacion.solot s
      join operacion.agendamiento a
        on s.codsolot = a.codsolot
     where a.idagenda = p_idagenda;

    -- Validando tipo de trabajo de zona lejana
    select count(pda.codigon)
      into ln_tiptra_sot_zl
      from operacion.parametro_cab_adc pca
      join operacion.parametro_det_adc pda
        on pca.id_parametro = pda.id_parametro
       and pca.abreviatura = 'PARAM_CRE_OT'
       and pda.abreviatura = 'TIP_TRA_ZL'
       and pda.codigon = ln_tiptra_sot;

    if ln_tiptra_sot_zl > 0 then
      select tp.flag_adc, tp.idzona
        into lv_flag_adc, ln_idzona
        from marketing.vtasuccli vs
        join pvt.tabpoblado@dbl_pvtdb tp  --2.0
          on vs.ubigeo2 = tp.idpoblado
       where vs.codsuc = lv_codsuc;

      if lv_flag_adc = 1 then
        select za.idzona
          into ln_idzona_zl
          from operacion.zona_adc za
         where za.codzona =
               (select pda.codigoc
                  from operacion.parametro_cab_adc pca
                  join operacion.parametro_det_adc pda
                    on pca.id_parametro = pda.id_parametro
                   and pca.abreviatura = 'PARAM_CRE_OT'
                   and pda.abreviatura = 'COD_ZL')
           and za.idzona = ln_idzona;

        if ln_idzona_zl > 0 then
          return 1;
        else
          return 0;
        end if;
      else
        return 0;
      end if;
    else
      return 0;
    end if;
    return 0;
  exception
    when others then
      return 0;
  end;

  /******************************************************************************
    Ver         Date          Author                   Descripcion
  ---------  ----------  ------------------  ------------------------------------
  1.0        11/02/2016   Emma Guzman      Evalua la agenda y devuelve 1 = MASIVO, 2 = CLARO EMPRESA
  ******************************************************************************/
  PROCEDURE p_tipo_serv_x_agenda(p_idagenda      in number,
                                 an_tipo         out number,
                                 an_iderror      OUT NUMERIC,
                                 as_mensajeerror OUT VARCHAR2) is
  begin
    select t.flg_tipo
      into an_tipo
      from operacion.agendamiento a
      join operacion.SUBTIPO_ORDEN_ADC st
        on a.id_subtipo_orden = st.id_subtipo_orden
      join operacion.TIPO_ORDEN_ADC t
        on st.id_tipo_orden = t.id_tipo_orden
     where a.idagenda = p_idagenda;

  exception
    WHEN NO_DATA_FOUND THEN
      an_tipo         := 0;
      an_iderror      := -1;
      as_mensajeerror := '[operacion.pq_adm_cuadrilla.p_tipo_serv_x_agenda] Agenda no tiene Tipo ';
    when others then
      an_tipo         := 0;
      an_iderror      := -1;
      as_mensajeerror := '[operacion.pq_adm_cuadrilla.p_tipo_serv_x_agenda] Error ' ||
                         sqlerrm;
  end;
  /******************************************************************************
    Ver         Date          Author                   Descripcion
  ---------  ----------  ------------------  ------------------------------------
  1.0        11/02/2016   Emma Guzman      Evalua la SOT y devuelve 1 = MASIVO, 2 = CLARO EMPRESA
  ******************************************************************************/
  PROCEDURE p_tipo_x_tiposerv(an_codsolot     in number,
                              an_tipo         out number,
                              an_iderror      OUT NUMERIC,
                              as_mensajeerror OUT VARCHAR2) is
    ls_TIPSRV solot.tipsrv%type;
    ln_count  number;

  begin
    select TIPSRV
      into ls_TIPSRV
      from solot s
     where s.codsolot = an_codsolot;
    if ls_TIPSRV is not null then
      an_tipo := f_tipo_x_tiposerv(ls_TIPSRV);
    end if;
  exception
    WHEN NO_DATA_FOUND THEN
      an_tipo         := 0;
      an_iderror      := -1;
      as_mensajeerror := '[operacion.pq_adm_cuadrilla.p_tipo_x_tiposerv] SOT no tiene Tipo Orden definido';
    when others then
      an_tipo         := 0;
      an_iderror      := -1;
      as_mensajeerror := '[operacion.pq_adm_cuadrilla.p_tipo_x_tiposerv] Error ' ||
                         sqlerrm;
  end;
  /******************************************************************************
    Ver         Date          Author                   Descripcion
  ---------  ----------  ------------------  ------------------------------------
  1.0        18/02/2016   Emma Guzman      Valida Datos de Clro Empresa
  ******************************************************************************/
  PROCEDURE p_valida_datos_ce(an_codsolot     in number,
                              an_iderror      OUT NUMERIC,
                              as_mensajeerror OUT VARCHAR2) is
    ln_hub  number;
    ln_cmts number;
  begin

    select distinct d.idhub, d.idcmts
      into ln_hub, ln_cmts
      from solot a, solotpto b, inssrv c, vtasuccli d
     where a.codsolot = b.codsolot
       and b.codinssrv = c.codinssrv
       and c.codsuc = d.codsuc
       and a.codsolot = an_codsolot;
    if ln_hub is not null then
      if ln_cmts is not null then
        an_iderror      := 0;
        as_mensajeerror := 'Exito';
      else
        an_iderror      := -1;
        as_mensajeerror := 'La SOT no tiene asignado CMTS';
      end if;
    else
      an_iderror      := -1;
      as_mensajeerror := 'La SOT no tiene asignado HUB';
    end if;
  exception
    WHEN NO_DATA_FOUND THEN
      an_iderror      := -1;
      as_mensajeerror := '[operacion.pq_adm_cuadrilla.p_valida_datos_ce] La SOT no tiene Datos de HUB y CMTS';
    when others then
      an_iderror      := -1;
      as_mensajeerror := '[operacion.pq_adm_cuadrilla.p_valida_datos_ce] Erro en la Validacion de Datos ' ||
                         sqlerrm;
  end;

  /******************************************************************************
    Ver         Date          Author                   Descripcion
  ---------  ----------  ------------------  ------------------------------------
  1.0        22/02/2016   Emma Guzman      Valida tipo de orden de la sot
  ******************************************************************************/
  function f_valida_tipo_orden(p_codsolot in number) return number is
    an_tipo         number;
    an_iderror      numeric;
    as_mensajeerror varchar2(1000);
  begin
    p_tipo_x_tiposerv(p_codsolot, an_tipo, an_iderror, as_mensajeerror);
    return an_tipo;
  end;
  /******************************************************************************
    Ver         Date          Author                   Descripcion
  ---------  ----------  ------------------  ------------------------------------
  1.0        11/02/2016   Emma Guzman      Evalua el tipo serv y devuelve 1 = MASIVO, 2 = CLARO EMPRESA
  ******************************************************************************/
  function f_tipo_x_tiposerv(as_tipsrv in solot.tipsrv%type) return number is
    ln_count number;
    an_tipo  number;
  begin
    SELECT count(*)
      into ln_count
      FROM operacion.parametro_cab_adc c, operacion.parametro_det_adc d
     WHERE d.estado = 1
       AND upper(d.abreviatura) = upper('Claro Empresa')
       AND d.id_parametro = c.id_parametro
       AND c.estado = 1
       AND upper(c.abreviatura) = upper('TIPO_SERVICIOS')
       and d.codigoc = as_tipsrv;
    if ln_count > 0 then
      an_tipo := 2;
    else
      an_tipo := 1;
    End if;
    return an_tipo;
  end;
  /******************************************************************************
    Ver         Date          Author                   Descripcion
  ---------  ----------  ------------------  ------------------------------------
  1.0        11/02/2016   Emma Guzman      Evalua el tipo trabajo y la incidencia y devuelve 1 = MASIVO, 2 = CLARO EMPRESA
  ******************************************************************************/
  function f_tipo_x_titra_incid(an_tiptra       in solot.tiptra%type,
                                an_codincidence incidence.codincidence%type)
    return number is
    ls_TIPSRV solot.tipsrv%type;
    ln_count  number;
    an_tipo   number;
  begin
    select distinct decode(an_tiptra,
                           480,
                           i.tipsrv,
                           nvl(p.tipsrv, i.tipsrv))
      into ls_TIPSRV
      from customerxincidence c, incidence ic, inssrv i, vtatabslcfac p
     where c.codincidence = ic.codincidence
       and c.servicenumber = i.codinssrv
       and i.numslc = p.numslc(+)
       and ic.codincidence = an_codincidence;
    if ls_TIPSRV is not null then
      an_tipo := f_tipo_x_tiposerv(ls_TIPSRV);
    else
      an_tipo := 0;
    end if;
    return an_tipo;
  end;
  /******************************************************************************
  Ver        Date        Author               Description
  ---------  ----------  -------------------  ------------------------------------
  1.0        15/01/2016  Juan Gonzales        Instala Equipo CE
  2.0        17/06/2016  Juan Gonzales        Instala Equipo CE correccion instalacion decos
  3.0        15/07/2016  Felipe Magui?a       Instala Equipo CE correccion instalacion
  4.0        01/09/2016  Justiniano Condori   Instalacion de Equipos CE
  ******************************************************************************/
  procedure p_instala_equipo_hfc_ce(an_idagenda   agendamiento.idagenda%type,
                                    av_modelo     intraway.int_servicio_intraway.modelo%type,
                                    av_mac        intraway.int_servicio_intraway.macaddress%type, --telefonia
                                    av_mta_mac_cm intraway.int_servicio_intraway.macaddress%type, --internet
                                    av_invsn      intraway.int_servicio_intraway.macaddress%type, --tv
                                    av_ua         intraway.int_servicio_intraway.serialnumber%type,
                                    av_categoria  operacion.inventario_em_adc.categoria%type,
                                    an_error      out number,
                                    av_error      out varchar2) is

    an_codsolot solot.codsolot%type;
    lv_emta     operacion.inventario_em_adc.categoria%type;
    lv_box      operacion.inventario_em_adc.categoria%type;
    lv_codcli       solot.codcli%type;
    ln_tipo_comando number := 1; -- si es 1 automatico; 0 Manual
    av_resultado    varchar2(4000); --4.0
    mac             intraway.int_servicio_intraway.macaddress%type;
    e_error exception;
    --ini 2.0
    lv_proceso          varchar2(50);
    c_id_telefono       constant varchar2(10) := '820';
    c_id_TV             constant varchar2(10) := '2020';
    c_id_internet       constant varchar2(10) := '620';
    ln_proceso          number := 3; --4.0
    lv_sendtocontroller varchar2(5) := 'TRUE'; --4.0
    ln_cantidad         number := 1; --4.0
    v_out               number;
    v_mens              varchar2(400);
    v_idprodpadre       number;
    v_contador          number;
    v_idventpadre       number;
    v_macadd            varchar2(400);
    v_modelmta          varchar2(400);
    v_central           varchar2(400);
    v_profile           varchar2(400);
    v_hub               varchar2(400);
    v_nodo              varchar2(400);
    v_activationcode    varchar2(400);
    v_cantpcs           number;
    v_servpackname      varchar2(400);
    v_mensajesus        varchar2(400);
    v_serial            varchar2(400);
    v_serialnumber      varchar2(200);
    v_unitd             varchar2(400);
    v_disab             varchar2(400);
    v_equp              varchar2(400);
    v_product           varchar2(400);
    v_channel           varchar2(400);
    --fin 2.0
    lb_chksrv           boolean; -- 3.0
    CURSOR c_srv IS
    -- ini 2.0
     SELECT x.tipo_comp,
          x.id_interfase,
          x.serialnumber,
          x.id_producto,
          x.id_producto_padre,
          x.id_venta,
          x.codinssrv,
          x.envio_automatico,
          x.id_cliente
     FROM (select b.tipo_comp,
                  a.id_interfase,
                  a.serialnumber,
                  a.id_producto,
                  a.id_producto_padre,
                  a.id_venta,
                  a.codinssrv,
                  1 envio_automatico,
                  a.id_cliente
             from intraway.int_servicio_intraway a,
                  intraway.int_interface b,
                  (select x.codigon id, x.descripcion descripcion
                     from opedd x, tipopedd y
                    where x.tipopedd = y.tipopedd
                      and y.abrev = 'IWAY_TIP_COMP') tipo_componente
            where a.codsolot = an_codsolot
              and a.id_interfase = b.id_interface
              and b.flg_ges_recurso = 1
              and b.tipo_comp = tipo_componente.id
              and ((lv_emta = av_categoria AND ID_INTERFASE = c_id_internet) or
                  (lv_box = av_categoria AND ID_INTERFASE = c_id_TV))
           union
           select b.tipo_comp,
                  a.id_interfase,
                  a.serialnumber,
                  a.id_producto,
                  a.id_producto_padre,
                  a.id_venta,
                  a.codinssrv,
                  1 envio_automatico,
                  a.id_cliente
             from intraway.int_servicio_intraway a,
                  intraway.int_interface b,
                  (select x.codigon id, x.descripcion descripcion
                     from opedd x, tipopedd y
                    where x.tipopedd = y.tipopedd
                      and y.abrev = 'IWAY_TIP_COMP') tipo_componente
            where a.codsolot = an_codsolot
              and a.id_interfase = b.id_interface
              and b.flg_ges_recurso = 1
              and b.tipo_comp = tipo_componente.id
              and ((lv_emta = av_categoria AND ID_INTERFASE = c_id_telefono) or
                  (lv_box = av_categoria AND ID_INTERFASE = c_id_TV))) X
    order by decode(x.id_producto_padre,
                    0,
                    x.id_producto,
                    x.id_producto_padre) desc,
             x.id_producto_padre asc;
    -- fin 2.0

  begin
    an_error := 0;
    av_error := '';
    av_resultado := '';--2.0
    lb_chksrv := false; --3.0
    an_codsolot := f_obtiene_codsolotxagenda(an_idagenda);

    begin

      lv_emta := f_obtiene_cod_emta(an_error, av_error);

      if an_error = -1 then
        raise e_error;
      end if;

      lv_box := f_obtiene_cod_box(an_error, av_error);

      if an_error = -1 then
        raise e_error;
      end if;

      begin
        select codcli
          into lv_codcli
          from solot
         where codsolot = an_codsolot;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          lv_codcli := '';
      end;

      if av_categoria = lv_emta then
        FOR r_srv IN c_srv LOOP
          lb_chksrv := true; --3.0
          if r_srv.id_interfase = '620' then
            --internet
          -- ini 2.0
                Intraway.Pq_Consultaitw.p_int_consultacm(r_srv.id_cliente,
                                                         r_srv.id_producto,
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
            if v_out = '1' then --3.0
                 if v_macadd is null then -- no esta en intraway
                       begin
          -- fin 2.0
                          -- Ini 4.0
                          intraway.pq_cont_hfcbscs.p_cont_actcm(ln_tipo_comando,
                                                                lv_codcli,
                                                                r_srv.id_producto,
                                                                ln_proceso,
                                                                an_codsolot,
                                                                av_mta_mac_cm,
                                                                av_resultado,
                                                                av_error,
                                                                an_error);
                          -- Fin 4.0
                          -- Ini 2.0
                          exception
                            when others then
                              rollback;
                          end;
                          -- Ini 4.0
                          if an_error=0 then
                             commit;
                          else
                             lv_proceso:='INTRAWAY.PQ_CONT_HFCBSCS.P_CONT_ACTCM';
                             av_error  :='(INTRAWAY.PQ_CONT_HFCBSCS.P_CONT_ACTCM)' || chr(13) ||
                                         'Error: ' || av_error || chr(13) ||
                                         'Mensaje: ' || av_resultado;
                          end if;
                          -- Fin 4.0
                end if;
                 --fin 2.0
            -- Ini 3.0
            else
              lv_proceso := 'Intraway.Pq_Consultaitw.p_int_consultacm';
              an_error   := -1;
              av_error   := '[intraway.pq_consultaitw.p_int_consultacm] '|| v_mens;
            end if;
            -- Fin 3.0
          elsif r_srv.id_interfase = '820' then
            --telefonia
            --ini 2.0
             Intraway.Pq_Consultaitw.p_int_consultamta(r_srv.id_cliente,
                                                r_srv.id_producto,
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
            if v_out = '1' then -- 3.0
                if v_macadd is null then -- no esta en intraway

                         begin  -- fin 2.0
                         -- Ini 4.0
                         intraway.pq_cont_hfcbscs.P_CONT_ACTMTA(2,
                                                                lv_codcli,
                                                                r_srv.id_producto,
                                                                r_srv.id_producto_padre,
                                                                ln_proceso,
                                                                an_codsolot,
                                                                av_mac,
                                                                ln_cantidad,
                                                                av_modelo,
                                                                av_resultado,
                                                                av_error,
                                                                an_error);
                         -- Fin 4.0
                       -- Ini 2.0
                        exception
                          when others then
                            rollback;
                        end;
                        -- Ini 4.0
                        if an_error=0 then
                           commit;
                        else
                           lv_proceso:='INTRAWAY.PQ_CONT_HFCBSCS.P_CONT_ACTMTA';
                           av_error  :='(INTRAWAY.PQ_CONT_HFCBSCS.P_CONT_ACTMTA)' || chr(13) ||
                                         'Error: ' || av_error || chr(13) ||
                                         'Mensaje: ' || av_resultado;
                        end if;
                        -- Fin 4.0
                 end if;
            --fin  2.0
            -- Ini 3.0
            else
              lv_proceso := 'Intraway.Pq_Consultaitw.p_int_consultamta';
              an_error   := -1;
              av_error   := '[intraway.pq_consultaitw.p_int_consultamta] '|| v_mens;
            end if;
            -- Fin 3.0
          end if;
          -- Ini 3.0
          if an_error <> 0 then --4.0
            operacion.pq_adm_cuadrilla.p_insertar_log_inst_eqp_hfc(an_idagenda,
                                                                   r_srv.id_interfase,
                                                                   av_modelo,
                                                                   av_mac,
                                                                   av_invsn,
                                                                   an_error,
                                                                   av_error,
                                                                   lv_proceso);
          end if;
          -- Fin 3.0
         end loop;
      end if;

      if av_categoria = lv_box then
        FOR r_srv IN c_srv LOOP
          lb_chksrv := true; --3.0
          if r_srv.id_interfase = '2020' then
            --tv
                -- ini 2.0
                Intraway.Pq_Consultaitw.p_int_consultatv(r_srv.id_cliente,
                                                   r_srv.id_producto,
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
            if v_out = '0' then --3.0
                if v_serial is null then -- no esta en intraway

                        begin -- fin 2.0
                        -- Ini 4.0
                        intraway.pq_cont_hfcbscs.p_cont_actstb(ln_tipo_comando,
                                                               lv_codcli,
                                                               r_srv.id_producto,
                                                               av_invsn,
                                                               av_ua,
                                                               lv_sendtocontroller,
                                                               ln_proceso,
                                                               an_codsolot,
                                                               av_modelo,
                                                               av_resultado,
                                                               av_error,
                                                               an_error);
                        -- Fin 4.0
                     -- Ini 2.0
                        exception
                          when others then
                            rollback;
                        end;
                        -- Ini 4.0
                        if an_error=0 then
                           commit;
                           exit;
                        else
                           lv_proceso:='INTRAWAY.PQ_CONT_HFCBSCS.P_CONT_ACTSTB';
                           av_error  :='(INTRAWAY.PQ_CONT_HFCBSCS.P_CONT_ACTSTB)' || chr(13) ||
                                         'Error: ' || av_error || chr(13) ||
                                         'Mensaje: ' || av_resultado;
                        end if;
                        -- Fin 4.0
                   end if;
            --fin  2.0
            -- Ini 3.0
            else
              lv_proceso := 'Intraway.Pq_Consultaitw.p_int_consultatv';
              an_error   := -1;
              av_error   := '[intraway.pq_consultaitw.p_int_consultatv] '|| v_mens;
            end if;
            -- Fin 3.0
          end if;
          -- Ini 3.0
          if an_error <> 0 then --4.0
            operacion.pq_adm_cuadrilla.p_insertar_log_inst_eqp_hfc(an_idagenda,
                                                                   r_srv.id_interfase,
                                                                   av_modelo,
                                                                   av_mac,
                                                                   av_invsn,
                                                                   an_error,
                                                                   av_error,
                                                                   lv_proceso);
          end if;
          -- Fin 3.0
        end loop;
      end if;
      -- Ini 3.0
      if not lb_chksrv then
        an_error := -1;
        av_error := '[operacion.pq_adm_cuadrilla.p_instala_equipo_ce] No se pudo Instalar El Servicio : El servicio no se encuentra en Intraway';
        operacion.pq_adm_cuadrilla.p_insertar_log_inst_eqp_hfc(an_idagenda,
                                                               null,
                                                               av_modelo,
                                                               av_mac,
                                                               av_invsn,
                                                               an_error,
                                                               av_error,
                                                               'operacion.pq_adm_cuadrilla.p_instala_equipo_hfc_ce');
      end if;
      -- Fin 3.0
    exception
      when e_error then
        an_error := -1;
        av_error := '[operacion.pq_adm_cuadrilla.p_instala_equipo_ce] No se pudo realizar la operaci?n para la Mac Address: ' || mac;
      when others then
        an_error := -1;
        av_error := '[operacion.pq_adm_cuadrilla.p_instala_equipo_ce] No se pudo Instalar El Servicio : ' ||
                    SQLERRM;
    end;
  end;
  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        26/05/2015  Steve P.               Obtiene Tipo de Orden CE
  ******************************************************************************/

  FUNCTION f_obtiene_tipoorden_ce(as_tiptra tiptrabajo.tiptra%TYPE,
                                  an_error  out number,
                                  av_error  out varchar2) RETURN VARCHAR2 IS

    ln_tipoorden operacion.tiptrabajo.id_tipo_orden%TYPE;
    ls_tipoorden operacion.tipo_orden_adc.cod_tipo_orden%TYPE;
  BEGIN
    ls_tipoorden := '';
    BEGIN
      SELECT d.id_tipo_orden_ce
        INTO ln_tipoorden
        FROM operacion.tiptrabajo d
       WHERE d.tiptra = as_tiptra;

    EXCEPTION
      WHEN no_data_found THEN
        ln_tipoorden := NULL;
        an_error     := -1;
        av_error     := '[operacion.pq_adm_cuadrilla.f_obtiene_tipoorden_ce] No Existe Tipo de Trabajo ';
    END;

    IF ln_tipoorden IS NULL THEN
      RETURN ls_tipoorden;
    END IF;

    BEGIN
      SELECT c.cod_tipo_orden
        INTO ls_tipoorden
        FROM operacion.tipo_orden_adc c
       WHERE c.id_tipo_orden = ln_tipoorden;
    EXCEPTION
      WHEN no_data_found THEN
        ls_tipoorden := '';
        an_error     := -1;
        av_error     := '[operacion.pq_adm_cuadrilla.f_obtiene_tipoorden_ce] El Tipo de Trabajo No tiene Tipo de Orden';
    END;

    RETURN ls_tipoorden;
  END;

  /******************************************************************************
    Ver         Date          Author                   Descripcion
  ---------  ----------  ------------------  ------------------------------------
  1.0        11/02/2016   Steve Panduro        Obtiene Tipo de Orden x Tipo Trabajo y Tipo servicio -  CLARO EMPRESA
  ******************************************************************************/
  procedure p_tipo_serv_x_tipotrabajo(av_tipsrv     tystipsrv.tipsrv%type,
                                      an_tiptra     tiptrabajo.tiptra%type,
                                      av_tipo_orden out operacion.tipo_orden_adc.cod_tipo_orden%type,
                                      an_error      OUT NUMERIC,
                                      av_error      OUT VARCHAR2) is

    lv_codigoc operacion.parametro_det_adc.codigoc%type;
  begin
    an_error      := 0;
    av_error      := '';
    av_tipo_orden := '';
    BEGIN
      SELECT d.codigoc
        INTO lv_codigoc
        FROM operacion.parametro_cab_adc c, operacion.parametro_det_adc d
       WHERE d.estado = 1
         AND upper(d.abreviatura) = upper('Claro Empresa')
         AND d.id_parametro = c.id_parametro
         AND c.estado = 1
         AND upper(c.abreviatura) = upper('TIPO_SERVICIOS')
         AND d.codigoc = av_tipsrv;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        lv_codigoc := '';
        an_error   := -1;
        av_error   := '[operacion.pq_adm_cuadrilla.p_tipo_serv_x_tipotrabajo]  EL Tipo de Servicio no esta configurado en la tabla de parametros';
    end;

    if upper(lv_codigoc) = upper(av_tipsrv) then
      begin
        select cod_tipo_orden
          into av_tipo_orden
          from operacion.tipo_orden_adc
         where id_tipo_orden in
               (select id_tipo_orden_ce
                  from tiptrabajo
                 where tiptra = an_tiptra);
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          av_tipo_orden := '';
          an_error      := -1;
          av_error      := '[operacion.pq_adm_cuadrilla.p_tipo_serv_x_tipotrabajo]  EL Tipo de Trabajo ' ||
                           an_tiptra ||
                           ' no tiene configurado Tipo de Orden';
      end;
    else
      an_error := -1;
      av_error := '[operacion.pq_adm_cuadrilla.p_tipo_serv_x_tipotrabajo]  EL Tipo de Servicio no es Claro Empresa';
    end if;
  exception
    when others then
      lv_codigoc    := '';
      av_tipo_orden := '';
      an_error      := -1;
      av_error      := '[operacion.pq_adm_cuadrilla.p_tipo_serv_x_tipotrabajo] Error ' ||
                       sqlerrm;
  end;

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        26/05/2015  Juan Gonzales    Valida PosVenta para Claro empresa
  ******************************************************************************/

  PROCEDURE p_valida_posventa_ce(av_tipsrv in solot.tipsrv%type,
                                an_tiptra in tiptrabajo.tiptra%TYPE,
                                av_tipo_orden out operacion.tipo_orden_adc.cod_tipo_orden%type,
                                an_error      OUT NUMERIC,
                                av_error      OUT VARCHAR2) IS

    ln_cant number;

  BEGIN

    BEGIN
      SELECT count(1)
        INTO ln_cant
        FROM operacion.parametro_cab_adc c, operacion.parametro_det_adc d
       WHERE d.estado = 1
         AND upper(d.abreviatura) = upper('Claro Empresa')
         AND d.id_parametro = c.id_parametro
         AND c.estado = 1
         AND upper(c.abreviatura) = upper('SERVICIO_POSVENTA')
         AND d.codigoc = av_tipsrv
         AND d.codigon = an_tiptra;

    EXCEPTION
      WHEN OTHERS THEN
        ln_cant := 0;
        an_error   := -1;
        av_error   := '[operacion.pq_adm_cuadrilla.p_valida_posventa_ce]  EL Tipo de Servicio no esta configurado en la tabla de parametros';

    END;
    if ln_cant >0 then
       p_tipo_serv_x_tipotrabajo(av_tipsrv,an_tiptra,av_tipo_orden,an_error ,av_error);
    else
      an_error   := -1;
      av_error   := '[operacion.pq_adm_cuadrilla.p_valida_posventa_ce]  No cumple para el Flujo de ETA';
    end if;
  END;
  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        02/05/2016  Juan Gonzales    Validacion para las Bajas
  ******************************************************************************/
  procedure p_valida_fecha(p_fecha       date,
                           p_tipsvr      varchar2,
                           p_iderror     out number,
                           p_mensaje     out varchar2) is


    l_cant_dias     number;
    d_fecha_fin     date;
    v_rango         varchar2(100);
    n_flag          number;
    d_fecha_actual  date;
    n_tipo          number;
  begin
    p_iderror := 1;
    d_fecha_actual  := trunc(sysdate);
    l_cant_dias     := to_number(sales.pkg_etadirect_utl.conf('etadirect', 'dias'));
    d_fecha_fin     := trunc(d_fecha_actual) + l_cant_dias;
    v_rango         := to_char(d_fecha_actual+1, 'dd/mm/yyyy') || ' - ' ||
                       to_char(d_fecha_fin, 'dd/mm/yyyy');
    n_tipo :=f_tipo_x_tiposerv(p_tipsvr);
    if  p_fecha > d_fecha_actual and p_fecha > d_fecha_fin AND n_tipo = 1 then
      n_flag    := 0;
      p_mensaje := sales.pkg_etadirect_utl.get_mensaje_fecha_pvta(n_flag);
      p_mensaje := replace(p_mensaje, 'x', to_char(p_fecha, 'dd/mm/yyyy'));
      p_iderror := -1;
      p_mensaje := p_mensaje || ' ' ||v_rango;
    elsif p_fecha = d_fecha_actual then
      n_flag    := 2;
      p_iderror := -1;
      p_mensaje := sales.pkg_etadirect_utl.get_mensaje_fecha_pvta(n_flag);
    end if;
  exception
    when others then
      p_iderror := -1;
      raise_application_error(-20000,' OPERACION.pq_adm_cuadrilla.consultar_capacidad '||
                              $$plsql_unit ||' '|| sqlerrm);
  end;
 /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        02/05/2016  Juan Gonzales    Validacion de tipo de trabajo, servicio y motivo
  ******************************************************************************/
  procedure p_valida_motivo (p_tiptra   IN  tiptrabajo.tiptra%type,
                             p_tipsvr   IN  operacion.MATRIZ_TYSTIPSRV_TIPTRA_ADC.tipsrv%type,
                             p_codmotot IN  operacion.matriz_tiptratipsrvmot_adc.id_motivo%type,
                             p_iderror  OUT number) is

   n_cant number;
   CURSOR c_srv IS
     SELECT DISTINCT t.id_matriz, t.VALIDA_MOT
            FROM OPERACION.MATRIZ_TYSTIPSRV_TIPTRA_ADC t
           WHERE t.tipsrv = p_tipsvr
             AND t.tiptra = p_tiptra
             AND t.estado = 1;
   BEGIN
     n_cant :=0;
     FOR r_srv IN c_srv LOOP

        IF not p_codmotot is null AND r_srv.valida_mot = 1 THEN
          BEGIN
            select 1
              into p_iderror
              from operacion.matriz_tiptratipsrvmot_adc dd
             where dd.id_matriz = r_srv.id_matriz
               and dd.id_motivo = p_codmotot
               and dd.estado = 1;

            n_cant := n_cant +1;

          EXCEPTION
            WHEN NO_DATA_FOUND THEN
                 n_cant := n_cant;
          END;
        ELSIF r_srv.valida_mot = 0 then
             n_cant := n_cant +1;
        ELSE
          p_iderror := -1;
        END IF;
    end loop;
    if n_cant > 0 then
       p_iderror := 1;
    else
      p_iderror := -1;
    end if;
  exception
    when others then
      p_iderror := -1;
      raise_application_error(-20000,' OPERACION.pq_adm_cuadrilla.p_valida_motivo '||
                              $$plsql_unit ||' '|| sqlerrm);
  END;
  -- Ini 4.0
  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        11/05/2016  Juan Gonzales    Asignacion de contrata para ejecucion desde
                                          el aplicativo ETADirect
  ******************************************************************************/
  PROCEDURE p_asignacontrata_st (an_agenda       operacion.agendamiento.idagenda%TYPE,
                                 av_subto        VARCHAR2,
                                 av_idbucket     VARCHAR2,
                                 av_codcon       VARCHAR2,
                                 an_iderror      OUT NUMBER,
                                 av_mensajeerror OUT VARCHAR2) IS

    lv_codcon        operacion.agendamiento.codcon%TYPE;
    n_existe         number;
    ln_estagenda_old operacion.agendamiento.estage%type;

  BEGIN
    an_iderror      := 0;
    av_mensajeerror := NULL;

    select estage
      into ln_estagenda_old
      from operacion.agendamiento a
     where idagenda = an_agenda;

    IF av_codcon IS NULL THEN
      if av_idbucket is null then
        an_iderror      := -1;
        av_mensajeerror := '[operacion.pq_adm_cuadrilla.p_asignacontrata_adc] No se envio codigo de Bucket. Revisar Agenda ' ||
                           an_agenda || ' Subtipo ' || av_subto;
      else
        UPDATE operacion.agendamiento
           SET idbucket =  trim(av_idbucket) -- 2.0 trim(upper(av_idbucket))
         WHERE idagenda = an_agenda;

        begin
          SELECT codcon
            INTO lv_codcon
            FROM operacion.bucket_contrata_adc
           WHERE estado = '1'   -- 12.00
             AND TRIM(UPPER(idbucket)) = trim(upper(av_idbucket));
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            lv_codcon := null;
        end;

        begin
          select 1
            into n_existe
            from operacion.contrata
           where codcon = to_number(lv_codcon);
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            n_existe := 0;
        end;

        if n_existe > 0 then
          UPDATE operacion.agendamiento
             SET codcon = to_number(lv_codcon)
           WHERE idagenda = an_agenda;

          operacion.pq_agendamiento.p_asig_contrata(an_agenda,
                                                    to_number(lv_codcon),
                                                    'Asigando por proceso ETADirect.');

          -- cambiar de estado a En Agenda --
          operacion.pq_agendamiento.p_chg_est_agendamiento(an_agenda,
                                                           '16', -- En Agenda
                                                           ln_estagenda_old,
                                                           'Agendado en ETADirect',
                                                           null,
                                                           trunc(sysdate),
                                                           null);
        end if;

      end if;
    else
      if to_number(av_codcon) > 0 then
        begin
          select 1
            into n_existe
            from operacion.contrata
           where codcon = to_number(av_codcon);
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            n_existe := 0;
        end;

        if n_existe = 0 then
          an_iderror      := -1;
          av_mensajeerror := '[operacion.pq_adm_cuadrilla.p_asignacontrata_adc] Contrata no existe.';
        else
          UPDATE operacion.agendamiento
             SET codcon = to_number(av_codcon)
           WHERE idagenda = an_agenda;

          operacion.pq_agendamiento.p_asig_contrata(an_agenda,
                                                    to_number(av_codcon),
                                                    'Asigando por proceso ETADirect');
          -- cambiar de estado a En Agenda --
          operacion.pq_agendamiento.p_chg_est_agendamiento(an_agenda,
                                                           '16', -- En Agenda
                                                           ln_estagenda_old,
                                                           'Agendado en ETADirect',
                                                           null,
                                                           trunc(sysdate),
                                                           null);
        end if;
      end if;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      an_iderror      := -1;
      av_mensajeerror := '[operacion.pq_adm_cuadrilla.p_asignacontrata_st] Se genero el error: ' ||
                         sqlerrm || ' - Linea Error: ' ||
                         dbms_utility.format_error_backtrace || ' - an_agenda: ' ||
                         an_agenda || ' - av_subto : ' || av_subto ||
                         ' - av_idbucket: ' || av_idbucket || ' - av_codcon: ' ||
                         av_codcon || '.';

  END;
  -- Fin 4.0
-- ini 7.0
  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        11/05/2016  Juan Gonzales    obtener la programacion de la agenda
  ******************************************************************************/
  PROCEDURE p_obtener_prog_agenda (an_agenda        IN operacion.agendamiento.idagenda%TYPE,
                                   p_solot          OUT solot.codsolot%type,--
                                   p_fecha          OUT date,
                                   p_bucket         OUT varchar2,
                                   p_franja_horaria OUT varchar2,
                                   p_zona           OUT varchar2,
                                   p_plano          OUT varchar2,
                                   p_tipo_orden     OUT varchar2,
                                   p_subtipo_orden  OUT varchar2,
                                   p_cod_rpt        out varchar2,
                                   p_msj_rpt        out varchar2) IS

 v_fecha_franja varchar2(20);
 n_subtipo_orden number;
 e_error exception;
  BEGIN
    p_cod_rpt := 0;
    p_msj_rpt := 'OK';
    BEGIN
     SELECT a.codsolot,
            a.fecagenda,
            a.idbucket,
            a.idplano,
            a.id_subtipo_orden,
            to_char( a.fecagenda,'dd/mm/yyyy hh:mi AM')
       into p_solot, p_fecha, p_bucket, p_plano, n_subtipo_orden, v_fecha_franja
       FROM agendamiento a
      WHERE a.idagenda = an_agenda;
    EXCEPTION
       WHEN NO_DATA_FOUND THEN
            p_cod_rpt := -1;
            p_msj_rpt := 'No existe Agenda';
            raise e_error;
    END;
    if p_plano is not null then
      BEGIN
         SELECT distinct z.codzona
           into p_zona
           FROM marketing.vtatabgeoref g, operacion.zona_adc z
          WHERE g.idzona = z.idzona
            AND g.idplano = p_plano;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              p_cod_rpt := -2;
              p_msj_rpt := 'No existe  codigo de zona';
              raise e_error;
      END;
    else
      p_cod_rpt := -3;
      p_msj_rpt := 'No existe Fecha de Agenda';
      raise e_error;
    end if;

    if p_fecha IS NOT NULL then
       SELECT f.codigo
         into p_franja_horaria
         FROM operacion.franja_horaria f
        WHERE to_date(to_char(to_date(v_fecha_franja, 'DD/MM/YYYY HH:MI AM'),
                              'dd/mm/yyyy') || ' ' || f.franja_ini || ' ' ||
                      f.ind_merid_fi,
                      'dd/mm/yyyy hh:mi AM') <=
              to_date(v_fecha_franja, 'DD/MM/YYYY HH:MI AM')
          AND to_date(to_char(to_date(v_fecha_franja, 'DD/MM/YYYY HH:MI AM'),
                              'dd/mm/yyyy') || ' ' || f.franja_fin || ' ' ||
                      f.ind_merid_ff,
                      'dd/mm/yyyy hh:mi AM') >
              to_date(v_fecha_franja, 'DD/MM/YYYY HH:MI AM')
          AND f.flg_ap_ctr = 1;
    else
      p_cod_rpt := -4;
      p_msj_rpt := 'No existe Fecha de Agenda';
      raise e_error;
    end if;

    if p_bucket is null then
       p_cod_rpt := -5;
       p_msj_rpt := 'No existe Bucket';
       raise e_error;
    end if;

    if n_subtipo_orden is not null then
      BEGIN
         SELECT t.cod_tipo_orden,s.cod_subtipo_orden
           into p_tipo_orden,p_subtipo_orden
           FROM operacion.subtipo_orden_adc s , operacion.tipo_orden_adc t
          WHERE s.id_tipo_orden = t.id_tipo_orden
            AND s.id_subtipo_orden = n_subtipo_orden;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              p_cod_rpt := -6;
              p_msj_rpt := 'No existe  Tipo de Orden';
              raise e_error;
      END;
    else
      p_cod_rpt := -7;
      p_msj_rpt := 'No existe subtipo de Orden';
      raise e_error;
    end if;

  EXCEPTION
    WHEN E_ERROR THEN
         p_msj_rpt := '[operacion.pq_adm_cuadrilla.] : ' || p_msj_rpt;
    WHEN OTHERS THEN
        p_cod_rpt := -1;
        p_msj_rpt := '[operacion.pq_adm_cuadrilla.: ' ||
                      sqlerrm || '.';
  END;
-- fin 7.0
-- Ini 9.0
  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        15/07/2015  Felipe Magui?a   Inserta Log Instalacion de Equipos
  ******************************************************************************/
  procedure p_insertar_log_inst_eqp_hfc(an_idagenda     operacion.agendamiento.idagenda%TYPE,
                                        av_id_interfase varchar2,
                                        av_modelo       operacion.trs_interface_iw.modelo%type,
                                        av_mac          operacion.trs_interface_iw.mac_address%type,
                                        av_invsn        operacion.trs_interface_iw.mac_address%type,
                                        an_iderror      number,
                                        av_descripcion  varchar2,
                                        av_proceso      varchar2) is

    ln_idlog number;
  begin
    select nvl(MAX(log_id), 0) + 1
      into ln_idlog
      from operacion.log_inst_equipo_hfc;

    insert into OPERACION.LOG_INST_EQUIPO_HFC
      (LOG_ID,
       IDAGENDA,
       ID_INTERFASE,
       MODELO,
       MAC,
       INVSN,
       IDERROR,
       DESCRIPCION,
       PROCESO,
       FECUSU,
       CODUSU)
    values
      (ln_idlog,
       an_idagenda,
       av_id_interfase,
       av_modelo,
       av_mac,
       av_invsn,
       an_iderror,
       av_descripcion,
       av_proceso,
       sysdate,
       user);

  end;
-- Fin 9.0
  --Ini 10.0
  /******************************************************************************
    Ver         Fecha         Autor                   Descripcion
  ---------  ----------  ---------------  ------------------------------------
    1.0      13/08/2016  Justiniano       Consulta el mensaje configurado segun una abreviatura
                         Condori
  ******************************************************************************/
  function f_consulta_msj_x_abrev(p_abrev in varchar2)
  return varchar2
  is
  lv_mensaje varchar2(500);
  begin
  select pda.codigoc
    into lv_mensaje
    from operacion.parametro_cab_adc pca,
         operacion.parametro_det_adc pda
   where pca.id_parametro=pda.id_parametro
     and pda.abreviatura=p_abrev
     and pca.abreviatura='M_FLG_AOBLG'
     and rownum=1;
    return lv_mensaje;
  exception when others then
    return null;
  end;
  /******************************************************************************
    Ver         Fecha         Autor                   Descripcion
  ---------  ----------  ---------------  ------------------------------------
    1.0      13/08/2016  Justiniano       Consulta el mensaje configurado segun el texto
                         Condori
  ******************************************************************************/
  function f_consulta_msj_x_msj(p_msj in varchar2)
  return varchar2
  is
  lv_mensaje varchar2(500);
  begin
  select pda.codigoc
    into lv_mensaje
    from operacion.parametro_cab_adc pca,
         operacion.parametro_det_adc pda
   where pca.id_parametro=pda.id_parametro
     and p_msj like '%'||pda.descripcion||'%'
     and pca.abreviatura='M_FLG_AOBLG'
     and rownum=1;
    return lv_mensaje;
  exception when others then
    return null;
  end;
  --Fin 10.0
  --Ini fase 3
  /***********************************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        19/09/2016  Alfonso Mu?ante  Obtiene consulta historica
  *********************************************************************************************/
  PROCEDURE AGENDAMSS_CONSULTA_HIST_ETA(an_idagenda  operacion.agendamiento.idagenda%TYPE,
                                          p_agenda     OUT SYS_REFCURSOR) IS

  BEGIN
    open p_agenda for
      select idagenda,
             (d.descripcion) tipo_agenda_desc,
             a.tipo_agenda,
             a.codcli,
             e.nomcli,
             a.codcon,
             f.descripcion,
             (c.nombre) contratista,
             codsolot solot,
             numslc proyecto,
             codincidence,
             acta_instalacion,
             a.estage,
             horas,
             fecha_instalacion,
             direccion,
             codsuc,
             (b.distrito_desc) ubi_desc,
             observacion,
             a.fecagenda,
             cintillo,
             codcnt,
             nomcnt,
             instalador,
             a.supervisor,
             a.fechaagendafin,
           a.flg_adc,
           a.flg_orden_adc,
           a.idbucket
        from agendamiento        a,
             v_ubicaciones       b,
             contrata            c,
             tipo_agenda         d,
             marketing.vtatabcli e,
             estagenda           f
       where a.idagenda = an_idagenda
         and a.codubi = b.codubi(+)
         and a.codcon = c.codcon(+)
         and a.tipo_agenda = d.tipo_agenda(+)
         and a.codcli = e.codcli(+)
         and a.estage = f.estage(+);


  END;

    /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        27/09/2016  Alfonso M.      Obtiene el plano
  ******************************************************************************/
  PROCEDURE SGASS_OBTIENE_PLANO(an_tiptra     solot.tiptra%type,
                           an_codinssrv  inssrv.codinssrv%type,
                           an_plano      out vtasuccli.idplano%type,
                           an_error      out number,
                           av_error      out varchar2) is

    lv_tecnol         operacion.tipo_orden_adc.tipo_tecnologia%type;
    ls_tipo_orden     operacion.tiptrabajo.id_tipo_orden%type;
    ls_tipo_orden_ce  operacion.tiptrabajo.id_tipo_orden_ce%type;
    ln_plano          vtasuccli.idplano%type;
    e_error           exception;

  begin
    an_error := 0;
    av_error := '';

    select id_tipo_orden, id_tipo_orden_ce
      into ls_tipo_orden, ls_tipo_orden_ce
      from tiptrabajo
     where tiptra = an_tiptra;

    IF ls_tipo_orden is null then
      BEGIN
        select c.tipo_tecnologia
          into lv_tecnol
          from operacion.tipo_orden_adc c
         where c.id_tipo_orden = ls_tipo_orden_ce
           and c.estado = 1;

      EXCEPTION
        WHEN no_data_found THEN
          lv_tecnol := '';
          an_error  := -1;
          av_error  := '[operacion.pq_adm_cuadrilla.SGASS_OBTIENE_PLANO] La Configuracion de TIPO TECNOLOGIA CE No Existe ';
      END;
    ELSIF ls_tipo_orden is not null then

      begin
        select c.tipo_tecnologia
          into lv_tecnol
          from operacion.tipo_orden_adc c
         where c.id_tipo_orden = ls_tipo_orden
           and c.estado = 1;

      EXCEPTION
        WHEN no_data_found THEN
          lv_tecnol := '';
          an_error  := -1;
          av_error  := '[operacion.pq_adm_cuadrilla.SGASS_OBTIENE_PLANO] La Configuracion de TIPO TECNOLOGIA No Existe ';
      END;
    ELSE
       lv_tecnol := '';
          an_error  := -1;
          av_error  := '[operacion.pq_adm_cuadrilla.SGASS_OBTIENE_PLANO] El tipo de trabajo no tiene configurado un Tipo Orden  ';
    END IF;

    If lv_tecnol  = 'HFC' then
      BEGIN
        select v.idplano
          into an_plano
          from vtasuccli v,
               inssrv i
         where i.codsuc = v.codsuc
           and i.codcli = v.codcli
           and i.codinssrv = an_codinssrv ;

      If an_plano is null then
        raise e_error;
      End If;

      EXCEPTION
        WHEN e_error THEN
          lv_tecnol := '';
          an_error  := -1;
          av_error  := '[operacion.pq_adm_cuadrilla.SGASS_OBTIENE_PLANO] No se tiene registrado el plano ';
        WHEN no_data_found THEN
          lv_tecnol := '';
          an_error  := -1;
          av_error  := '[operacion.pq_adm_cuadrilla.SGASS_OBTIENE_PLANO] No se tiene registrado el plano ';
      END;

    Elsif lv_tecnol  = 'DTH' then
      BEGIN
        select v.ubigeo2
          into an_plano
          from vtasuccli v,
               inssrv i
         where i.codsuc = v.codsuc
           and i.codcli = v.codcli
           and i.codinssrv = an_codinssrv ;

      If an_plano is null then
        raise e_error;
      End If;

      EXCEPTION
        WHEN e_error THEN
          lv_tecnol := '';
          an_error  := -1;
          av_error  := '[operacion.pq_adm_cuadrilla.SGASS_OBTIENE_PLANO] No se tiene registrado el Centro Poblado. ';
        WHEN no_data_found THEN
          lv_tecnol := '';
          an_error  := -1;
          av_error  := '[operacion.pq_adm_cuadrilla.SGASS_OBTIENE_PLANO] No se tiene registrado el Centro Poblado. ';
      END;
    End If;
  end;

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        27/09/2016  Alfonso M.      Obtiene el tipo de tecnologia
  ******************************************************************************/
  FUNCTION SGAFUN_obtiene_tiptra(an_tiptra     solot.tiptra%type) return varchar2 is

    lv_tecnol         operacion.tipo_orden_adc.tipo_tecnologia%type;
    ls_tipo_orden     operacion.tiptrabajo.id_tipo_orden%type;
    ls_tipo_orden_ce  operacion.tiptrabajo.id_tipo_orden_ce%type;
    e_error           exception;

  begin

    select id_tipo_orden, id_tipo_orden_ce
      into ls_tipo_orden, ls_tipo_orden_ce
      from tiptrabajo
     where tiptra = an_tiptra;

    IF ls_tipo_orden is null then
      BEGIN
        select c.tipo_tecnologia
          into lv_tecnol
          from operacion.tipo_orden_adc c
         where c.id_tipo_orden = ls_tipo_orden_ce
           and c.estado = 1;

      EXCEPTION
        WHEN no_data_found THEN
          lv_tecnol := '';
          raise_application_error(-20000,
                              $$plsql_unit ||
                              '.an_tiptra(an_tiptra => ' ||
                              an_tiptra || ') ' || sqlerrm);
      END;
    ELSIF ls_tipo_orden is not null then

      begin
        select c.tipo_tecnologia
          into lv_tecnol
          from operacion.tipo_orden_adc c
         where c.id_tipo_orden = ls_tipo_orden
           and c.estado = 1;

      EXCEPTION
        WHEN no_data_found THEN
          lv_tecnol := '';
          raise_application_error(-20000,
                              $$plsql_unit ||
                              '.an_tiptra(an_tiptra => ' ||
                              an_tiptra || ') ' || sqlerrm);
      END;
    ELSE
       lv_tecnol := '';
         raise_application_error(-20000, ' El Tipo de Trabajo no cuenta con un Tipo Orden ');
    END IF;

    return lv_tecnol;
  end;

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        27/09/2016  Alfonso M.      Obtiene el centro poblado por incidencia
  ******************************************************************************/
  procedure SGASS_GET_CENT_PBL(p_incidence customerxincidence.codincidence%type,
                           p_centro out sys_refcursor) is

  ls_codsuc   marketing.vtasuccli.codsuc%type;

  begin
      open p_centro for
        select t.idpoblado,  t.nombre, vc.dirsuc
          from vtasuccli vc,
               vtatabdst vb,
               pvt.tabpoblado@dbl_pvtdb t
         where vc.ubisuc = vb.codubi
           and vb.ubigeo = t.idubigeo
           and t.cobertura = 1
           and vc.codsuc = (select iv.codsuc
                              from atccorp.customerxincidence ct, inssrv iv
                             where ct.servicenumber = iv.codinssrv
                               and ct.codincidence = p_incidence);


  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit || '.get_centro_poblado(p_incidence => ' ||
                              p_incidence || ') ' || sqlerrm);
  end;

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        27/09/2016  Alfonso M.      Actualiza datos de agendamiento
  ******************************************************************************/
  procedure SGASU_ACT_AGENDAMIENTO (p_agenda           in operacion.agendamiento.idagenda%type,
                                         p_codcon           in operacion.agendamiento.codcon%type,
                                         p_ACTA_INSTALACION in operacion.agendamiento.acta_instalacion%type,
                                         p_ESTAGE           in operacion.agendamiento.estage%type,
                                         p_FEC_INSTALACION  in operacion.agendamiento.fecha_instalacion%type,
                                         p_OBSERVACION      in operacion.agendamiento.observacion%type,
                                         p_FECAGENDA        in operacion.agendamiento.fecagenda%type,
                                         p_CINTILLO         in operacion.agendamiento.cintillo%type,
                                         p_CODCNT           in operacion.agendamiento.codcnt%type,
                                         p_NOMCNT           in operacion.agendamiento.nomcnt%type,
                                         p_INSTALADOR       in operacion.agendamiento.instalador%type,
                                         p_SUPERVISOR       in operacion.agendamiento.supervisor%type,
                                         p_FECREAGENDA      in operacion.agendamiento.fecreagenda%type) is

  begin
    update operacion.agendamiento
       set CODCON = p_codcon,
           ACTA_INSTALACION = p_ACTA_INSTALACION,
           ESTAGE = p_ESTAGE,
           FECHA_INSTALACION = p_FEC_INSTALACION,
           OBSERVACION = p_OBSERVACION,
           FECAGENDA = p_FECAGENDA,
           CINTILLO = p_CINTILLO,
           CODCNT = p_CODCNT,
           NOMCNT = p_CODCNT,
           INSTALADOR = p_INSTALADOR,
           SUPERVISOR = p_SUPERVISOR,
           FECREAGENDA = p_FECREAGENDA
     where idagenda = p_agenda;
  end;
 --FIN FASE 3
  --Ini 12.0

/***********************************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        16/09/2016  Luis Guzm?n      Insertar a la tabla operacion.sga_orden_reproceso_adc
  *********************************************************************************************/
  PROCEDURE carga_orden_reproceso(p_reproceso          NUMBER,
                                  p_cod_solot          NUMBER,
                                  p_idagenda           NUMBER,
                                  p_archivo            VARCHAR2,
                                  p_codigo_respuesta   OUT NUMBER,
                                  p_mensaje_respuesta  OUT VARCHAR2) IS

   vn_secuencia NUMBER;

  BEGIN

    p_codigo_respuesta   := 1;
    p_mensaje_respuesta := '';

    SELECT MAX(a.soran_secuencia)
      INTO vn_secuencia
      FROM operacion.sga_orden_reproceso_adc a
     WHERE a.soran_id_reproceso = p_reproceso;

    if vn_secuencia is null then
       vn_secuencia := 1;
    else
       vn_secuencia := vn_secuencia + 1;
    end if;

    INSERT INTO operacion.sga_orden_reproceso_adc
           (soran_id_reproceso, soran_secuencia, soran_id_solot, soran_archivo, soran_flag_proceso)
    VALUES
      (p_reproceso,
       vn_secuencia,
       p_cod_solot,
       p_archivo,
       0);

  EXCEPTION
    WHEN OTHERS THEN
      p_codigo_respuesta  := -1;
      p_mensaje_respuesta := '[operacion.pq_adm_cuadrilla.carga_orden_reproceso] No se pudo insertar en la tabla operacion.sga_orden_reproceso_adc: ' ||
                             SQLERRM;

      orden_registrar_log(p_reproceso,
                          p_cod_solot,
                          NULL,
                          p_mensaje_respuesta,
                          p_archivo,
                          p_codigo_respuesta,
                          p_codigo_respuesta,
                          p_mensaje_respuesta);
  END;

/***********************************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        16/09/2016  Luis Guzm?n      Insertar a la tabla operacion.sga_log_reproceso
  *********************************************************************************************/
  PROCEDURE orden_registrar_log(p_reproceso         NUMBER,
                                p_cod_solot         NUMBER,
                                p_idagenda          NUMBER,
                                p_des_error         VARCHAR2,
                                p_archivo           VARCHAR2,
                                p_cod_error         NUMBER,
                                p_codigo_respuesta  OUT NUMBER,
                                p_mensaje_respuesta OUT VARCHAR2) IS

   lv_desc      operacion.parametro_det_adc.descripcion%TYPE;
   vn_secuencia NUMBER;
   lv_flag      CHAR(1);

  BEGIN

    p_codigo_respuesta  := 1;
    p_mensaje_respuesta := '';

    SELECT MAX(a.slren_secuencia)
      INTO vn_secuencia
      FROM operacion.sga_log_reproceso a
     WHERE a.slren_id_reproceso = p_reproceso;

    if vn_secuencia is null then
       vn_secuencia := 1;
    else
       vn_secuencia := vn_secuencia + 1;
    end if;

    SELECT f_obtiene_val_par_det('MNS_REORDEN' ,p_cod_error ,3 ,'descripcion')
      INTO lv_desc
      FROM DUAL;

    IF lv_desc is null THEN
       p_codigo_respuesta  := -1;
       lv_desc             := 'Error no se pudo reprocesar la Orden';
       p_mensaje_respuesta := '[operacion.pq_adm_cuadrilla.orden_registrar_log] Mensaje para este error no esta configurado en la tabla de parametros '||
                              SQLERRM;
    END IF;

    IF p_cod_error = 1 THEN
      lv_flag := 1;
    ELSE
      lv_flag := 0;
    END IF;

    INSERT INTO operacion.sga_log_reproceso
           (slren_id_reproceso, slren_secuencia, slren_id_solot, slren_id_agenda, slrev_des_error, slrev_archivo, slrev_log_error, soran_flag_proceso)
    VALUES (p_reproceso, vn_secuencia, p_cod_solot, p_idagenda, lv_desc, p_archivo, p_des_error, lv_flag);

  EXCEPTION
    WHEN OTHERS THEN
      p_codigo_respuesta  := -1;
      p_mensaje_respuesta := '[operacion.pq_adm_cuadrilla.orden_registrar_log] No se pudo insertar en la tabla operacion.sga_log_reproceso: ' ||
                             SQLERRM;
  END;

  /***********************************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        19/09/2016  Luis Guzm?n      Reprocesa las ordenes
  *********************************************************************************************/
 PROCEDURE orden_reproceso(p_reproceso         NUMBER,
                           p_cod_solot         NUMBER,
                           p_idagenda          NUMBER,
                           p_codigo_respuesta  OUT NUMBER,
                           p_mensaje_respuesta OUT VARCHAR2) IS

   lv_cod_error  NUMBER;
   lv_mensaje_er VARCHAR2(600);
   lv_count_sot  NUMBER;
   ln_count_est  NUMBER;
   ln_count_data NUMBER;
   ln_count_age  NUMBER;
   e_error       EXCEPTION;

   CURSOR c_repro_ord IS
   SELECT t.soran_id_solot ,
          t.soran_secuencia,
          t.soran_archivo
       FROM operacion.sga_orden_reproceso_adc t
      WHERE t.soran_id_reproceso = p_reproceso
   ORDER BY t.soran_secuencia;

  BEGIN

    p_codigo_respuesta := 1;
    p_codigo_respuesta := '';

    SELECT COUNT(1)
      INTO ln_count_est
      FROM operacion.parametro_det_adc d, operacion.parametro_cab_adc c
     WHERE d.estado = 1
       AND d.id_parametro = c.id_parametro
       AND c.estado = 1
       AND c.abreviatura = 'EST_REPORDEN' ;

    IF ln_count_est = 0 THEN
        p_mensaje_respuesta := '[operacion.pq_adm_cuadrilla.p_cancela_orden_repr_ord] Estados para generar el reproceso de ordenes no esta configurado en la tabla de parametros';
        RAISE e_error;
    END IF;

    for c_cur in c_repro_ord loop

        ln_count_data := 0;

        SELECT count(1)
          INTO lv_count_sot
          FROM operacion.solot t
         WHERE t.codsolot = c_cur.soran_id_solot;

        IF lv_count_sot = 0 THEN
          p_codigo_respuesta  := -1;
          p_mensaje_respuesta := '[operacion.pq_adm_cuadrilla.orden_reprocesa] La SOT no existe';
          orden_registrar_log(p_reproceso,
                              c_cur.soran_id_solot,
                              NULL,
                              p_mensaje_respuesta,
                              c_cur.soran_archivo,
                              p_codigo_respuesta,
                              p_codigo_respuesta,
                              p_mensaje_respuesta);
        ELSE

           DECLARE CURSOR c_agenda IS
           SELECT a.idagenda, a.estage
             FROM operacion.agendamiento a
            WHERE a.codsolot = c_cur.soran_id_solot
              and nvl(a.flg_orden_adc, 0) = 1
              and a.estage in (SELECT d.codigon
                                 FROM operacion.parametro_det_adc d, operacion.parametro_cab_adc c
                                WHERE d.estado = 1
                                  AND d.id_parametro = c.id_parametro
                                  AND c.estado = 1
                                  AND c.abreviatura = 'EST_REPORDEN')
            ORDER BY a.idagenda;

            BEGIN
              FOR r_agenda IN c_agenda LOOP

                  p_cancela_orden_repr_ord(c_cur.soran_id_solot, r_agenda.idagenda, NULL, lv_cod_error, lv_mensaje_er);
                  orden_registrar_log(p_reproceso,
                                      c_cur.soran_id_solot,
                                      r_agenda.idagenda,
                                      lv_mensaje_er,
                                      c_cur.soran_archivo,
                                      lv_cod_error,
                                      p_codigo_respuesta,
                                      p_mensaje_respuesta);
                  ln_count_data := c_agenda%ROWCOUNT;

                  IF lv_cod_error = 1 THEN
                   UPDATE operacion.sga_orden_reproceso_adc a
                      SET a.soran_flag_proceso = 1
                    WHERE a.soran_id_reproceso = p_reproceso
                      AND a.soran_secuencia = c_cur.soran_secuencia ;
                  END IF;

              END LOOP;

              IF ln_count_data  = 0 THEN
                 SELECT count(1)
                   INTO ln_count_age
                   FROM operacion.agendamiento a
                  WHERE a.codsolot = c_cur.soran_id_solot
                    and nvl(a.flg_orden_adc, 0) = 1;
                IF ln_count_age = 0 THEN
                   p_mensaje_respuesta := '[operacion.pq_adm_cuadrilla.p_cancela_orden_repr_ord] La SOT no tiene agendamiento';
                   p_codigo_respuesta  := -1;
                   orden_registrar_log(p_reproceso,
                                      c_cur.soran_id_solot,
                                      null,
                                      p_mensaje_respuesta,
                                      c_cur.soran_archivo,
                                      p_codigo_respuesta,
                                      p_codigo_respuesta,
                                      p_mensaje_respuesta);

                   UPDATE operacion.sga_orden_reproceso_adc a
                      SET a.soran_flag_proceso = 0
                    WHERE a.soran_id_reproceso = p_reproceso
                      AND a.soran_secuencia = c_cur.soran_secuencia;

                ELSE
                   p_mensaje_respuesta := '[operacion.pq_adm_cuadrilla.p_cancela_orden_repr_ord] La SOT no tiene agendamiento con los estados configurados en la tabla parametros';
                   p_codigo_respuesta  := -1;
                   orden_registrar_log(p_reproceso,
                                      c_cur.soran_id_solot,
                                      null,
                                      p_mensaje_respuesta,
                                      c_cur.soran_archivo,
                                      p_codigo_respuesta,
                                      p_codigo_respuesta,
                                      p_mensaje_respuesta);

                   UPDATE operacion.sga_orden_reproceso_adc a
                      SET a.soran_flag_proceso = 0
                    WHERE a.soran_id_reproceso = p_reproceso
                      AND a.soran_secuencia = c_cur.soran_secuencia;

                END IF;
              END IF;
            END;

        END IF;
    END LOOP;

  EXCEPTION
    WHEN e_error THEN
      p_codigo_respuesta  := -100;

    WHEN OTHERS THEN
      p_codigo_respuesta  := -100;
      p_mensaje_respuesta := '[operacion.pq_adm_cuadrilla.orden_reprocesa] No se pudo reprocesar niguna orden: ' ||
                             SQLERRM;
  END;

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        19/09/2016  Luis Guzm?n    Cancelacion de agendas por SOT
  ******************************************************************************/
  PROCEDURE p_cancela_orden_repr_ord(an_codsot       IN operacion.agendamiento.codsolot%TYPE,
                                     an_idagenda     IN NUMBER,
                                     an_estagenda    IN NUMBER,
                                     an_iderror      OUT NUMERIC,
                                     av_mensajeerror OUT VARCHAR2) IS

   e_error        EXCEPTION;
   e_error_ws     EXCEPTION;
   ln_codigon     operacion.parametro_det_adc.codigon%TYPE;

  BEGIN
    an_iderror      := 1;
    av_mensajeerror := '';
    BEGIN
      SELECT d.codigon
        INTO ln_codigon
        FROM operacion.parametro_det_adc d, operacion.parametro_cab_adc c
       WHERE d.estado = 1
         AND d.abreviatura = 'CANCELADO'
         AND d.id_parametro = c.id_parametro
         AND c.estado = 1
         AND c.abreviatura = 'CANCELACION_AGENDA';
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        av_mensajeerror := '[operacion.pq_adm_cuadrilla.p_cancela_orden_repr_ord]  Estado de cancelacion no esta configurado en la tabla de parametros' ||
                           sqlerrm || '.';
        p_insertar_log_error_ws_adc('Anulacion de SOLOT',
                                    an_codsot,
                                    -1,
                                    av_mensajeerror);
        RAISE e_error;
    END;

    p_cancela_agenda(an_codsot,
                     an_idagenda,
                     ln_codigon,
                     NULL,
                     an_iderror,
                     av_mensajeerror);

    CASE
      WHEN an_iderror = 1
        THEN
          BEGIN
            UPDATE operacion.agendamiento a
               SET a.idbucket         = NULL,
                   a.flg_orden_adc    = NULL,
                   a.flg_adc          = NULL
             WHERE a.idagenda = an_idagenda
               AND a.codsolot = an_codsot;
          EXCEPTION
              WHEN OTHERS THEN
                av_mensajeerror := '[operacion.pq_adm_cuadrilla.p_cancela_orden_repr_ord] No se logro actualizar el agendamiento ' ||
                                   ' Codigo Error: '  || to_char(sqlcode) ||
                                   ' Mensaje Error: ' || to_char(sqlerrm) ;
                RAISE e_error;
          END;
      WHEN an_iderror = -99
        THEN
           RAISE e_error_ws;
      WHEN an_iderror <> 1
        THEN RAISE e_error;
    END CASE;

  EXCEPTION
    WHEN e_error_ws THEN
      an_iderror := an_iderror;

    WHEN e_error THEN
      an_iderror      := -1;

    WHEN OTHERS THEN
      an_iderror      := -1;
      av_mensajeerror := '[operacion.pq_adm_cuadrilla.p_cancela_orden_repr_ord] Se genero el error: '  ||
                         ' Codigo Error: '  || to_char(sqlcode) ||
                         ' Mensaje Error: ' || to_char(sqlerrm) ;

  END p_cancela_orden_repr_ord;

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        30/09/2016  Luis Guzm?n    Recupera valores de la tabla de parametros
  ******************************************************************************/
  FUNCTION f_obtiene_val_par_det(av_cab_abrev operacion.parametro_cab_adc.abreviatura%type,
                                 av_par_caden varchar2,
                                 an_tipo      number,
                                 av_campo     varchar2)
    return varchar2 is

    ln_codigon opedd.codigon%type;
    lv_retorno operacion.parametro_det_adc.descripcion%type;
    lv_desc    operacion.parametro_det_adc.descripcion%type;

  BEGIN

   lv_retorno := null;

   CASE an_tipo
     WHEN 1
       THEN
         SELECT DECODE(av_campo,'descripcion', d.descripcion, 'codigoc', d.codigoc), d.codigon
           INTO lv_desc, ln_codigon
           FROM operacion.parametro_det_adc d, operacion.parametro_cab_adc c
          WHERE c.abreviatura = av_cab_abrev
            AND d.id_parametro = c.id_parametro
            AND d.estado = 1
            AND c.estado = 1
            AND d.abreviatura = av_par_caden ;

     WHEN 2
       THEN
         SELECT d.descripcion, d.codigon
           INTO lv_desc, ln_codigon
           FROM operacion.parametro_det_adc d, operacion.parametro_cab_adc c
          WHERE c.abreviatura = av_cab_abrev
            AND d.id_parametro = c.id_parametro
            AND d.estado = 1
            AND c.estado = 1
            AND d.codigoc = av_par_caden ;

     WHEN 3
       THEN
         SELECT DECODE(av_campo,'descripcion', d.descripcion, 'codigoc', d.codigoc)
           INTO lv_desc
           FROM operacion.parametro_det_adc d, operacion.parametro_cab_adc c
          WHERE c.abreviatura = av_cab_abrev
            AND d.id_parametro = c.id_parametro
            AND d.estado = 1
            AND c.estado = 1
            AND TO_CHAR(d.codigon) = av_par_caden ;

   END CASE;

   CASE av_campo
     WHEN 'descripcion' THEN lv_retorno := lv_desc;
     WHEN 'codigoc'     THEN lv_retorno := lv_desc;
     WHEN 'codigon'     THEN lv_retorno := to_char(ln_codigon);
   END CASE;

   RETURN lv_retorno;

  EXCEPTION
    WHEN OTHERS THEN
      RETURN NULL;
  END;

  /*******************************************************************************************
    Ver         Fecha         Autor                   Descripcion
  ---------  ----------  --------------------  -----------------------------------------------
    1.0      12/09/2016  Justiniano Condori    Consulta el Tipo de Flag
  *******************************************************************************************/
  procedure paramss_consulta_flagtipo(p_flag_tipo out number)
  is
  begin
    select pda.codigon
      into p_flag_tipo
      from operacion.parametro_cab_adc pca,
           operacion.parametro_det_adc pda
     where pca.id_parametro=pda.id_parametro
       and pda.abreviatura='FLG_INV'
       and pca.abreviatura='CONF_INV';
  exception when others then
    p_flag_tipo:=-1 ;
  end;
  /*******************************************************************************************
    Ver         Fecha         Autor                   Descripcion
  ---------  ----------  --------------------  -----------------------------------------------
    1.0      03/10/2016  Justiniano Condori    Consulta Valores de validacion
  *******************************************************************************************/
  procedure p_param_val_inv(p_long_dni out number,
                            p_long_serie_deco out number,
                            p_long_ua_deco out number,
                            p_long_serie_emta out number,
                            p_long_mac_cm_emta out number,
                            p_long_mac_emta out number,
                            p_cod out number,
                            p_mensaje out varchar2)
  is
  begin
    p_cod:=0;
    p_mensaje:='Exito';

    -- Consultando la Longitud del DNI
         select pda.codigon
           into p_long_dni
           from operacion.parametro_cab_adc pca,
                operacion.parametro_det_adc pda
          where pca.id_parametro = pda.id_parametro
            and pca.abreviatura = 'VAL_L_INV'
            and pda.descripcion='DNI'
            and pda.abreviatura='LONG_DNI';
    -- Consultando la Longitud de Serie para Deco
         select pda.codigon
           into p_long_serie_deco
           from operacion.parametro_cab_adc pca,
                operacion.parametro_det_adc pda
          where pca.id_parametro = pda.id_parametro
            and pca.abreviatura = 'VAL_L_INV'
            and pda.descripcion='DECO'
            and pda.abreviatura='LONG_SRD';
    -- Consultando la Longitud del Unit Adress para Deco
         select pda.codigon
           into p_long_ua_deco
           from operacion.parametro_cab_adc pca,
                operacion.parametro_det_adc pda
          where pca.id_parametro = pda.id_parametro
            and pca.abreviatura = 'VAL_L_INV'
            and pda.descripcion='DECO'
            and pda.abreviatura='LONG_UA';
    -- Consultando la Longitud de Serie para EMTA
         select pda.codigon
           into p_long_serie_emta
           from operacion.parametro_cab_adc pca,
                operacion.parametro_det_adc pda
          where pca.id_parametro = pda.id_parametro
            and pca.abreviatura = 'VAL_L_INV'
            and pda.descripcion='EMTA'
            and pda.abreviatura='LONG_SRE';
    -- Consultando la Longitud de MAC_CM para EMTA
         select pda.codigon
           into p_long_mac_cm_emta
           from operacion.parametro_cab_adc pca,
                operacion.parametro_det_adc pda
          where pca.id_parametro = pda.id_parametro
            and pca.abreviatura = 'VAL_L_INV'
            and pda.descripcion='EMTA'
            and pda.abreviatura='LONG_MAC1';
    -- Consultando la Longitud de MAC para EMTA
         select pda.codigon
           into p_long_mac_emta
           from operacion.parametro_cab_adc pca,
                operacion.parametro_det_adc pda
          where pca.id_parametro = pda.id_parametro
            and pca.abreviatura = 'VAL_L_INV'
            and pda.descripcion='EMTA'
            and pda.abreviatura='LONG_MAC2';
  exception when others then
    p_cod:=-1;
    p_mensaje:='Se genero un error con los siguientes detalles:' || chr(13) ||
               ' - Codigo Error: '  || to_char(sqlcode)              || chr(13) ||
               ' - Mensaje Error: ' || to_char(sqlerrm)              || chr(13) ||
               ' - Linea Error: '   || dbms_utility.format_error_backtrace;
  end;
  /*******************************************************************************************
    Ver         Fecha         Autor                   Descripcion
  ---------  ----------  --------------------  -----------------------------------------------
    1.0      03/10/2016  Justiniano Condori    Inserta la cabecera del inventario para envio
  *******************************************************************************************/
  procedure p_insert_cab_inv_adc(p_tipo_proceso in number,
                                 p_ruta_archivo in varchar2,
                                 p_id_proceso out number,
                                 p_cod out number,
                                 p_mensaje out varchar2)
  is
  begin
    p_cod:=0;
    p_mensaje:='Exito';
    insert into operacion.cab_inventario_env_adc(id_proceso,tipo_proceso,archivo)
         values (operacion.sq_ope_cab_inv.nextval,p_tipo_proceso,p_ruta_archivo) returning id_proceso into p_id_proceso;
  exception when others then
    p_cod:=-1;
    p_mensaje:='Se genero un error con los siguientes detalles:' || chr(13) ||
               ' - Codigo Error: '  || to_char(sqlcode)              || chr(13) ||
               ' - Mensaje Error: ' || to_char(sqlerrm)              || chr(13) ||
               ' - Linea Error: '   || dbms_utility.format_error_backtrace;
  end;
  /*******************************************************************************************
    Ver         Fecha         Autor                   Descripcion
  ---------  ----------  --------------------  -----------------------------------------------
    1.0      05/10/2016  Justiniano Condori    Valida que los registros esten todos validados
  *******************************************************************************************/
  procedure p_val_proc_carga(p_id_proceso in number,
                             p_val        out number,
                             p_cod        out number,
                             p_mensaje    out varchar2)
  is
  ln_total_reg number;
  ln_val_reg number;
  begin
    p_val:=0;
    p_cod:=0;
    p_mensaje:='Exito';
    -- Validando que todos los registros esten correctamente cargados
    select count(1) into ln_total_reg from operacion.inventario_env_adc iea where iea.id_proceso=p_id_proceso;
    select count(1) into ln_val_reg from operacion.inventario_env_adc iea where iea.id_proceso=p_id_proceso and iea.flg_carga=1;
    if ln_total_reg > 0 then
       if ln_total_reg = ln_val_reg then
          p_val:=1;
       else
           p_mensaje:='Se tienen que cargar todos los equipos sin errores';
           return;
       end if;
    else
        p_mensaje:='Se tiene que cargar el Excel de Equipo(s)';
        return;
    end if;
    -- Validando si se enviaron los archivos
    select count(1)
      into ln_val_reg
      from operacion.cab_inventario_env_adc
     where id_proceso=p_id_proceso
       and estado_proceso in (1,2);
    if ln_val_reg=1 then
       p_val:=0;
       p_mensaje:='Se enviaron los archivos, realize otra carga';
       return;
    end if;
  exception when others then
    p_cod:=-1;
    p_mensaje:='Se genero un error con los siguientes detalles:' || chr(13) ||
               ' - Codigo Error: '  || to_char(sqlcode)              || chr(13) ||
               ' - Mensaje Error: ' || to_char(sqlerrm)              || chr(13) ||
               ' - Linea Error: '   || dbms_utility.format_error_backtrace;
  end;
  /*******************************************************************************************
    Ver         Fecha         Autor                   Descripcion
  ---------  ----------  --------------------  -----------------------------------------------
    1.0      18/10/2016  Justiniano Condori    Realiza el conteo de los registros que se
                                               encuentran con errores
  *******************************************************************************************/
  function f_val_elem_error(p_id_proceso in number) return number
  is
  ln_total number;
  begin
    -- Contando los registros que se encuentran con errores
    SELECT count(distinct i.id_inventario)
      into ln_total
      FROM operacion.inventario_env_adc_log_err i
     where i.id_proceso=p_id_proceso;
    return ln_total;
  exception when others then
    return 0;
  end;
  --Fin 12.0

  /*******************************************************************************************
    Ver         Fecha         Autor                   Descripcion
  ---------  ----------  --------------------  -----------------------------------------------
    1.0      07/10/2016  Juan Carlos Gonzales  Valida la configuracion del tiptra y tipsrv
                                               en la configuracion para los telefonos del cliente
  *******************************************************************************************/
  function f_val_conf_telf_cliente(p_idagenda agendamiento.idagenda%type)
    return number is
    ln_total  number;
    ln_tiptra solot.tiptra%type;
    lv_tipsrv solot.tipsrv%type;
  begin

    SELECT s.tiptra, s.tipsrv
      INTO ln_tiptra, lv_tipsrv
      FROM agendamiento a, solot s
     WHERE a.codsolot = s.codsolot
       AND a.idagenda = p_idagenda;

    SELECT count(1)
      INTO ln_total
      FROM operacion.parametro_cab_adc cab, operacion.parametro_det_adc det
     WHERE cab.id_parametro = det.id_parametro
       AND cab.abreviatura = 'TELEF_CLIENTE'
       AND det.codigoc = lv_tipsrv
       AND det.codigon = ln_tiptra
       AND cab.estado = 1
       AND det.estado = 1;

    return ln_total;
  exception
    when others then
      return 0;
  end;

  --INICIO
   /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        27/09/2016  Alfonso M.       Obtiene valores de la tabla de parametros
  ******************************************************************************/
  FUNCTION f_obtiene_valores_crmdd(p_abreviacion crmdd.abreviacion%TYPE,
                                   p_abrev       tipcrmdd.abrev%TYPE,
                                   an_tipo       NUMBER) RETURN VARCHAR2 IS
    l_codigoc opedd.codigoc%TYPE;
    l_codigon opedd.codigon%TYPE;
    l_retorno VARCHAR2(100);

  BEGIN
    IF an_tipo = 1 THEN
      SELECT codigoc
        INTO l_codigoc
        FROM sales.tipcrmdd c, sales.crmdd d
       WHERE c.abrev = p_abrev
         AND c.tipcrmdd = d.tipcrmdd
         AND d.abreviacion = p_abreviacion;

      l_retorno := l_codigoc;

    ELSIF an_tipo = 2 THEN
      SELECT codigon
        INTO l_codigon
        FROM sales.tipcrmdd c, sales.crmdd d
       WHERE c.abrev = p_abrev
         AND c.tipcrmdd = d.tipcrmdd
         AND d.abreviacion = p_abreviacion;

      l_retorno := to_char(l_codigon);

    END IF;

    RETURN l_retorno;

  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$PLSQL_UNIT ||
                              '.p_abreviacion(p_abreviacion => ' ||
                              p_abreviacion || ') ' || SQLERRM);
  END;



  PROCEDURE SIACRECSU_ACT_FLAGPRIORIZA(P_COD_SOLOT in NUMBER,
  P_FLG_PRIORIZ IN operacion.parametro_vta_pvta_adc.pvad_flag_prio%type, --  17.0
  P_FLG_SOLCLI IN  operacion.parametro_vta_pvta_adc.pvpac_flag_sol_cli%type, --  17.0
  P_CODIGO_RESPUESTA OUT NUMBER,
  P_MENSAJE_RESPUESTA OUT VARCHAR2) is
  v_cont number;
  e_error EXCEPTION;
  begin
  P_CODIGO_RESPUESTA := 0;
  P_MENSAJE_RESPUESTA := '';

    SELECT count (*) into v_cont
    FROM operacion.parametro_vta_pvta_adc p
    WHERE p.codsolot = P_COD_SOLOT;

    if v_cont <= 0 then
    P_CODIGO_RESPUESTA := 1;
    P_MENSAJE_RESPUESTA := 'No existe SOT';
    else
    update operacion.parametro_vta_pvta_adc ip
    set ip.pvad_flag_prio = P_FLG_PRIORIZ, --17.0
        ip.pvpac_flag_sol_cli = P_FLG_SOLCLI --17.0
    where ip.codsolot = P_COD_SOLOT;
    commit;

   end if;

  EXCEPTION
   when others then
     P_CODIGO_RESPUESTA := -1;
     P_MENSAJE_RESPUESTA := sqlerrm;
  end;

  PROCEDURE SGASS_VALIDA_ESTADO(P_IDAGENDA            IN NUMBER,
                              P_ESTADO              OUT VARCHAR2,
                              P_CODIGO_RESPUESTA    OUT NUMBER,
                              P_MENSAJE_RESPUESTA   OUT VARCHAR2) IS
    ws_ll_existe VARCHAR2(20);
    ws_ls_estado VARCHAR2(100);

  BEGIN
        BEGIN
          select count(*),(select a.desc_corta from operacion.estado_adc a where a.id_estado = operacion.cambio_estado_ot_adc.id_estado) as descrip
          into ws_ll_existe , ws_ls_estado
          from operacion.cambio_estado_ot_adc
          where idagenda = P_IDAGENDA
          and secuencia = (select max(secuencia)from operacion.cambio_estado_ot_adc where idagenda = P_IDAGENDA)
          and id_estado not in (SELECT d.codigon FROM operacion.parametro_det_adc d, operacion.parametro_cab_adc c
                                WHERE d.estado = 1
                                AND d.id_parametro = c.id_parametro
                                AND c.estado = 1
                                AND c.abreviatura = 'ESTADOS_REAGENDAR')
          group by operacion.cambio_estado_ot_adc.id_estado;
      EXCEPTION
          WHEN no_data_found THEN
            P_CODIGO_RESPUESTA := 1;
            P_MENSAJE_RESPUESTA := 'OK';
            RETURN;
       END;

        P_ESTADO := ws_ls_estado;
        P_CODIGO_RESPUESTA := -1;
        P_MENSAJE_RESPUESTA := 'La Orden de Trabajo no se puede Reagendar por estar en Estado ' || ws_ls_estado;

  EXCEPTION
    WHEN OTHERS THEN
      P_CODIGO_RESPUESTA := SQLCODE;
      P_MENSAJE_RESPUESTA := 'Ocurrio un error de SQL-SELECT :' || SQLERRM;
  END SGASS_VALIDA_ESTADO;


  PROCEDURE SGASS_VALIDA_SUBTIPO(P_SUBTIPO_TRAB        IN VARCHAR2,
                P_CODIGO_RESPUESTA         OUT NUMBER,
                P_MENSAJE_RESPUESTA        OUT VARCHAR2) IS
    ws_ll_cantidad VARCHAR2(20);
    ws_ls_observacion VARCHAR2(100);
  BEGIN
    BEGIN
      select count(*), descripcion into ws_ll_cantidad , ws_ls_observacion from operacion.subtipo_orden_adc
      where cod_subtipo_orden = P_SUBTIPO_TRAB and estado =0 group by descripcion;

      EXCEPTION
        WHEN no_data_found THEN
        P_CODIGO_RESPUESTA := 1;
        P_MENSAJE_RESPUESTA := 'OK';
        RETURN;
       END;

      P_CODIGO_RESPUESTA := -1;
      P_MENSAJE_RESPUESTA := 'No se puede Reagendar utilizando el Sub-tipo ' || ws_ls_observacion || ', porque se encuentra Inactivo.';

    EXCEPTION
      WHEN OTHERS THEN
        P_CODIGO_RESPUESTA := SQLCODE;
        P_MENSAJE_RESPUESTA := 'Ocurrio un error de SQL-SELECT :' || SQLERRM;
    END SGASS_VALIDA_SUBTIPO;


    PROCEDURE SGASS_VALIDA_DATOS   (P_IDAGENDA            IN NUMBER,
                  P_CUR_SALIDA          OUT SYS_REFCURSOR,
                  P_CODIGO_RESPUESTA    OUT NUMBER,
                  P_MENSAJE_RESPUESTA   OUT VARCHAR2) IS
      ln_zl            NUMBER;
    BEGIN
    /*VALIDAR ZONA LEJANA*/
    BEGIN
      ln_zl := operacion.pq_adm_cuadrilla.f_val_zonalejana(P_IDAGENDA);
      IF ln_zl > 0 THEN
        P_CODIGO_RESPUESTA := -1;
        P_MENSAJE_RESPUESTA := 'La orden no se puede reagendar por pertenecer a una zona lejana';
        return;
      end if;
    END;
    /*CAPTURAR DATOS DE AGENDAMIENTO*/
    Open P_CUR_SALIDA for
      select idagenda   Id_agenda,
      Codcon            Codcon,
      idagenda          Contacto_adc,
      direccion         Direccion,
      telefono_adc      Telefono,
      id_subtipo_orden  Id_subtipo_orden,
      observacion       Observacion,
      codcuadrilla      CodCuadrilla
      from operacion.agendamiento
      where operacion.agendamiento.idagenda = P_IDAGENDA;

     P_CODIGO_RESPUESTA := 0 ;
     P_MENSAJE_RESPUESTA := 'SE EJECUTO CORRECTAMENTE.' ;
     return;
   exception
     when others then
      P_CODIGO_RESPUESTA := SQLCODE;
      P_MENSAJE_RESPUESTA := 'Ocurrio un error de SQL-SELECT :'||SQLERRM ;
  end SGASS_VALIDA_DATOS;
  --FIN

 /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        21/02/2017  HITSS            SD_INC000000710996 Devuelve 1 si aplica TOA incidencia
  ******************************************************************************/
  FUNCTION f_obtiene_flag_toa(p_tiptra IN solot.tiptra%type,p_codtype IN incidence.codtypeservice%type )
  RETURN NUMBER IS
  wn_count  INTEGER;
  wn_obliga INTEGER;
  BEGIN
      SELECT sum(decode(nvl(con_cap_i,0),1,1,0)),
             sum(decode(nvl(flgaobliga,0),1,1,0))
        INTO wn_count, wn_obliga
        FROM operacion.matriz_tystipsrv_tiptra_adc x,
             typeservice_atention                  y
       WHERE x.estado = 1
         AND x.tiptra = p_tiptra
         AND x.tipsrv = y.codtipsrv
         AND y.codtypeservice = p_codtype;

    IF wn_count=0 AND wn_obliga=0 THEN
          RETURN 0;
    ELSIF wn_count=1 AND wn_obliga=0 THEN
       RETURN 1;
    ELSIF wn_count=1 AND wn_obliga=1 THEN
        RETURN 2;
    END IF;

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN 0;
    WHEN OTHERS THEN
      RETURN -1;
  END;

/******************************************************************************
  Ver           Date          Author                   Descripcion
  ---------  ----------  ------------------ ----------------------------------------
  1.0        21/02/2017  Katherine  Morales       Retorna estado de la franja
  ******************************************************************************/
function f_valida_hfranja(pcodigo in varchar2 )
return number
  is
   v_fecha varchar2(20);
   ini varchar2(20);
   fin varchar2(20);
   estado number;
Begin
   select LPAD(TO_NUMBER(SUBSTR((to_char(sysdate +numtodsinterval(0, 'HOUR'),'HH24:MI')),1,2)),2,'0') ||SUBSTR((to_char(sysdate + numtodsinterval(0, 'HOUR'), 'HH:MI')),4)
   into v_fecha
   from dual;

   select case ind_merid_fi
            when 'PM' then
             lpad(to_number(substr(franja_ini, 1, 2)) + 12, 2, '0') ||
             substr(franja_ini, 4)
            else
             lpad(to_number(substr(franja_ini, 1, 2)), 2, '0') ||
             substr(franja_ini, 4)
          end ini,
          case ind_merid_ff
            when 'PM' then
             lpad(to_number(substr(franja_fin, 1, 2)) + 12, 2, '0') ||
             substr(franja_fin, 4)
            else
             lpad(to_number(substr(franja_fin, 1, 2)), 2, '0') ||
             substr(franja_fin, 4)
          end fin
     into ini, fin
     from operacion.franja_horaria
    where codigo = pcodigo;
   if v_fecha >= ini or fin <= v_fecha then
     estado := 0;
   else
     estado := 1;
   end if;
return estado;
end;

  /******************************************************************************
  Ver           Date          Author                   Descripcion
  ---------  ----------  ------------------ ----------------------------------------
  1.0        13/03/2017  Jorge Rivas        Retorna regla de franja
  ******************************************************************************/
  FUNCTION f_regla_franja(p_tipmod IN varchar2,
                          p_tiptra IN solot.tiptra%type)
  RETURN VARCHAR2 IS
  wv_abreviatura  operacion.parametro_det_adc.abreviatura%type;
  BEGIN
     SELECT d.abreviatura
       INTO wv_abreviatura
       FROM operacion.parametro_det_adc d, operacion.parametro_cab_adc c
      WHERE d.codigoc = p_tipmod
        AND d.codigon = p_tiptra
        AND d.id_parametro = c.id_parametro
        AND c.abreviatura = 'REGLA_FRANJA_HORARIA';

     RETURN wv_abreviatura;

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN '';
  END;

  /******************************************************************************
  Ver           Date          Author                   Descripcion
  ---------  ----------  ------------------ ----------------------------------------
  1.0        15/03/2017  Jorge Rivas        Retorna tipo de trabajo nueva sef
  ******************************************************************************/
  FUNCTION f_obtiene_tiptra_vta_nueva_sef(p_numslc sales.vtatabslcfac.numslc%type)
  RETURN NUMBER IS
  ln_tipsrv       sales.tystipsrv.tipsrv%type;
  ln_tiptra       operacion.tiptrabajo.tiptra%type;
  ln_tipo         number;
  ln_flg_agenda   number;
  lv_tipsrv       sales.tystipsrv.tipsrv%type;
  ln_flg_cehfc_cp sales.vtatabslcfac.flg_cehfc_cp%type;
  BEGIN
    ln_tipsrv := sales.pkg_etadirect_utl.conf('etadirect', 'paquete_masivo');
    ln_tiptra := to_number(sales.pkg_etadirect_utl.conf('etadirect', 'tiptra_venta'));

    BEGIN
      SELECT tipsrv, flg_cehfc_cp, flg_agenda
        INTO lv_tipsrv, ln_flg_cehfc_cp, ln_flg_agenda
        FROM sales.vtatabslcfac
       WHERE numslc = p_numslc;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN -1;
    END;

    IF lv_tipsrv IS NULL OR lv_tipsrv = ' ' THEN
      RETURN -2;
    END IF;

    ln_tipo := operacion.pq_adm_cuadrilla.f_tipo_x_tiposerv(lv_tipsrv);

    IF ln_tipo = 2 THEN
      --si es tipo servicio Claro Empresa
      IF ln_flg_agenda = 1 THEN
        BEGIN
          SELECT d.codigon
            INTO ln_tiptra
            FROM operacion.parametro_cab_adc c,
                 operacion.parametro_det_adc d
           WHERE d.id_parametro = c.id_parametro
             AND c.estado = 1
             AND d.estado = 1
             AND upper(c.abreviatura) = upper('TIPO_TRABAJO')
             AND d.codigoc = to_char(ln_flg_cehfc_cp);
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            RETURN -3;
        END;
      END IF;
    END IF;

    RETURN ln_tiptra;
  END;

 /******************************************************************************
  Ver           Date          Author                   Descripcion
  ---------  ----------  ------------------ ----------------------------------------
  1.0        15/03/2017  Katherine Morales R        Retorna Cantidad Franjas
  ******************************************************************************/
  FUNCTION f_obtiene_cant_franja
    return number is
       ln_franja number;
    e_error exception;
  begin
    begin
      SELECT d.codigon
        into ln_franja
        FROM operacion.parametro_det_adc d, operacion.parametro_cab_adc c
       WHERE d.abreviatura = 'CAN_FRA'
         AND d.id_parametro = c.id_parametro
         AND c.abreviatura = 'VAL_FRA'
         and d.estado = 1
         and c.estado = 1;
    EXCEPTION
      WHEN no_data_found THEN
        ln_franja  := 0;
    END;
    return ln_franja;
  end;

 /****************************************************************************** -- 18.0 Ini
  Ver           Date          Author                   Descripcion
  ---------  ----------  ------------------ ----------------------------------------
  1.0        26/06/2017  Edwin Vasquez C        retorna tecnologia permitida relanzar agendamiento
  ******************************************************************************/
  FUNCTION sgafun_tecno_permitida(pi_idagenda agendamiento.idagenda%TYPE)
    RETURN BOOLEAN IS

    lv_codsolot       solot.codsolot%TYPE;
    ln_error          NUMBER;
    lv_mensaje        VARCHAR2(4000);
    lv_tecnologia_sot operacion.tipo_orden_adc.tipo_tecnologia%TYPE;
    ln_existe         NUMBER;

  BEGIN
    ln_existe := 0;

    BEGIN
      SELECT a.codsolot
      INTO lv_codsolot
      FROM operacion.agendamiento a
      WHERE a.idagenda = pi_idagenda;
    EXCEPTION
      WHEN OTHERS THEN
        RETURN ln_existe > 0;
    END;

    lv_tecnologia_sot := f_obtiene_tipo_tecnologia(lv_codsolot,
                                                   ln_error,
                                                   lv_mensaje);
    IF ln_error <> 0 THEN
      RETURN ln_existe > 0;
    END IF;

    SELECT COUNT(1)
    INTO ln_existe
    FROM operacion.parametro_det_adc d, operacion.parametro_cab_adc c
    WHERE d.estado = 1
    AND d.abreviatura = 'TECNO_PERMITIDA'
    AND d.id_parametro = c.id_parametro
    AND c.estado = 1
    AND c.abreviatura = 'TECNO_RELAN_PROG'
    AND d.codigoc = lv_tecnologia_sot;

    RETURN ln_existe > 0;

  END; -- 18.0 fin
  -- Ini 19.0
  --------------------------------------------------------------------------------
  function extrae_carac_spec(p_dato varchar2) return varchar2 is
    l_dato varchar2(4000);

    cursor cur_caract is
      select d.codigoc
        from tipopedd c,
             opedd    d
       where c.abrev = 'CARACT_ESPEC_TRAMA'
         and c.tipopedd = d.tipopedd
         and d.abreviacion = 'caract_espec'
         and d.codigon_aux = 1;
  begin
    l_dato := p_dato;

    for caract in cur_caract
    loop
      l_dato := replace(l_dato, caract.codigoc, '');
    end loop;

    return l_dato;
  end;
  -- Fin 19.0
  -- Ini 20.0
    /******************************************************************************
  Ver           Date          Author                   Descripcion
  ---------  ----------  ------------------ ----------------------------------------
  1.0        06/07/2017  Edwin Vasquez C        retorna la franja actual segun fecha del sistema
  ******************************************************************************/
   FUNCTION sgafun_obt_franja_actual RETURN VARCHAR2 is
     l_fecha_franja  VARCHAR2(20);
     l_codigo_franja operacion.franja_horaria.codigo%TYPE;

   BEGIN

     l_fecha_franja := to_char(SYSDATE, 'dd/mm/yyyy hh:mi AM');

     BEGIN
       SELECT f.codigo
       INTO l_codigo_franja
       FROM operacion.franja_horaria f
       WHERE to_date(to_char(to_date(l_fecha_franja, 'DD/MM/YYYY HH:MI AM'),
                             'dd/mm/yyyy') || ' ' || f.franja_ini || ' ' ||
                     f.ind_merid_fi,
                     'dd/mm/yyyy hh:mi AM') <=
             to_date(l_fecha_franja, 'DD/MM/YYYY HH:MI AM')
       AND to_date(to_char(to_date(l_fecha_franja, 'DD/MM/YYYY HH:MI AM'),
                          'dd/mm/yyyy') || ' ' || f.franja_fin || ' ' ||
                  f.ind_merid_ff,
                  'dd/mm/yyyy hh:mi AM') >
             to_date(l_fecha_franja, 'DD/MM/YYYY HH:MI AM')
       AND f.flg_ap_ctr = 1
       AND f.codigo NOT IN (SELECT d.codigoc
                           FROM tipopedd c, opedd d
                           WHERE c.abrev = 'etadirect'
                           AND c.tipopedd = d.tipopedd
                           AND d.abreviacion = 'Time_slot_franja'
                           AND d.codigon_aux = 1);
     EXCEPTION
       WHEN OTHERS THEN
         raise_application_error(-20500,
                                 'Error - No se ha identifica franja horaria para el dia  ' ||
                                 l_fecha_franja || SQLERRM);
     END;

     RETURN l_codigo_franja;

   END;
   --fin 20.0
  --Ini 21.0
  --------------------------------------------------------------------------------
  procedure valida_medcom_toa(p_codincidence incidence.codincidence%type,
                              p_resultado    out number,
                              p_mensaje      out varchar2) is
    l_tlf_cli    varchar2(50);
    l_codcli     varchar2(8);
    l_valida_cnt number;

  begin
    p_resultado  := 1;
    p_mensaje    := 'OK';
    l_valida_cnt := 0;

    select t.customercode
      into l_codcli
      from customerxincidence t
     where t.codincidence = p_codincidence;

    begin
      select trim(vmc.numcom)
        into l_tlf_cli
        from marketing.vtamedcomcli vmc,
             marketing.vtatabmedcom vtm
       where vmc.idmedcom = vtm.idmedcom
         and vtm.idmedcom in (select d.codigoc
                                from tipopedd c,
                                     opedd    d
                               where c.tipopedd = d.tipopedd
                                 and c.abrev = 'MEDCOM_TOA'
                                 and d.codigon_aux = 1)
         and rownum = 1
         and vmc.codcli = l_codcli;
    exception
      when NO_DATA_FOUND then
        l_valida_cnt := 1;
    end;

    if l_valida_cnt = 1 then
      select trim(mcc.numcomcnt)
        into l_tlf_cli
        from marketing.vtatabcntcli cc,
             marketing.vtamedcomcnt mcc,
             marketing.vtatabmedcom vtm
       where mcc.codcnt = cc.codcnt
         and mcc.idmedcom = vtm.idmedcom
         and cc.codcli = l_codcli
         and mcc.idmedcom in (select d.codigoc
                                from tipopedd c,
                                     opedd    d
                               where c.tipopedd = d.tipopedd
                                 and c.abrev = 'MEDCOM_TOA'
                                 and d.codigon_aux = 1)
         and rownum = 1;
    end if;

  exception
    when NO_DATA_FOUND then
      p_resultado := 0;
      p_mensaje   := 'Cliente no cuenta con un n?mero de contacto ingresado, ' ||
                     'por favor actualizar la informaci?n para generar la orden de mantenimiento';
  end;
  --Fin 21.0
  ----------------------
  --INICIO PROY-31513 TOA
  ----------------------
  procedure SGASS_OBT_PARAMETROS(pi_idparametro number,
                                 po_dato        out sys_refcursor,
                                 po_cod_error   out number,
                                 po_des_error   out varchar2) is
    v_error1 exception;
    v_idparametro number;

    begin

     if pi_idparametro is null then
      raise v_error1;
    else
      v_idparametro := pi_idparametro;
    end if;

   open po_dato for
      select PDA.ID_PARAMETRO,
             PDA.CODIGOC,
             PDA.CODIGON,
             PDA.DESCRIPCION as deta_desc,
             PDA.ABREVIATURA as deta_abrev,
             PDA.ESTADO      as deta_estado,
             PDA.ID_DETALLE,
             PCA.DESCRIPCION  as cab_desc,
             PCA.ABREVIATURA  as cab_abrev,
             PCA.ESTADO       as cab_estado
      from OPERACION.PARAMETRO_DET_ADC PDA,
        OPERACION.PARAMETRO_CAB_ADC PCA
       where PDA.ID_PARAMETRO=v_idparametro
       and PDA.ID_PARAMETRO=PCA.ID_PARAMETRO;

    po_cod_error := 0;
    po_des_error := 'Operaci?n Exitosa';

  exception
    when v_error1 then
      open po_dato for
        select null from dual;
      po_cod_error := 2;
      po_des_error := 'FALTAN PARAMETROS';
    when others then
      open po_dato for
        select null from dual;
      po_cod_error := '-1';
      po_des_error := 'ERROR: ' || sqlerrm;
  end;
  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        06/05/2018  --      Devuelve datos de parametro_vta_pvta_adc
  ******************************************************************************/
  PROCEDURE SGASS_LISTA_vta_pvta_adc(an_codsolot    IN operacion.solot.codsolot%TYPE,
                                     po_dato        out sys_refcursor,
                                     po_cod_error   out number,
                                     po_des_error   out varchar2) IS
  v_error1 exception;

  BEGIN
     if an_codsolot is null then
      raise v_error1;
    end if;

    open po_dato for
    SELECT a.idpoblado,subtipo_orden,
           plano,
           fecha_progra,
           a.franja,
           fila,
           (SELECT aa.cod_tipo_orden
              FROM operacion.tipo_orden_adc    aa,
                   operacion.subtipo_orden_adc bb
             WHERE aa.id_tipo_orden = bb.id_tipo_orden
               AND bb.cod_subtipo_orden = subtipo_orden) id_tipo_orden,
           (SELECT tiptra FROM operacion.solot WHERE codsolot = a.codsolot) tiptra
      FROM operacion.parametro_vta_pvta_adc a,
           (SELECT d.abreviacion AS franja, ROWNUM fila
              FROM tipopedd c, opedd d
             WHERE c.abrev = 'etadirect'
               AND c.tipopedd = d.tipopedd
               AND d.descripcion = 'Franja Horaria') b
     WHERE b.franja = a.franja
       AND a.codsolot = an_codsolot;

      po_cod_error := 0;
      po_des_error := 'Operaci?n Exitosa';

  exception
    when v_error1 then
      open po_dato for
        select null from dual;
      po_cod_error := 2;
      po_des_error := 'FALTAN PARAMETROS';
    when others then
      open po_dato for
        select null from dual;
      po_cod_error := '-1';
      po_des_error := 'ERROR: ' || sqlerrm;
  end;
  --------------------------------------
  PROCEDURE SGASS_SUBTIPO_TRABAJO (vIdtiptra      NUMBER,
                                   po_dato        out sys_refcursor,
                                   po_cod_error   out number,
                                   po_des_error   out varchar2) IS
    v_error1      exception;
    vCodTipoOrden varchar2(10);
    nError        number;
    vError        varchar2(10);
  begin
    if vIdtiptra is null then
      raise v_error1;
    end if;
    vCodTipoOrden := operacion.pq_adm_cuadrilla.f_obtiene_tipoorden(vIdtiptra,nError,vError);

    open po_dato for
      SELECT CAB.ID_TIPO_ORDEN,CAB.COD_TIPO_ORDEN,CAB.DESCRIPCION AS CAB_DESC, CAB.TIPO_TECNOLOGIA,
             CAB.ESTADO,CAB.TIPO_SERVICIO,CAB.FLG_TIPO,DET.ID_SUBTIPO_ORDEN, DET.COD_SUBTIPO_ORDEN,
             DET.DESCRIPCION AS DET_DES,DET.TIEMPO_MIN, DET.ID_WORK_SKILL,DET.GRADO_DIFICULTAD, DET.ID_TIPO_ORDEN,
             DET.ESTADO, DET.SERVICIO, DET.DECOS, DET.LINEAS
        FROM OPERACION.TIPO_ORDEN_ADC CAB, OPERACION.SUBTIPO_ORDEN_ADC DET
       WHERE CAB.id_tipo_orden = DET.id_tipo_orden
   AND DET.ESTADO = 1 --28.0
         AND CAB.COD_TIPO_ORDEN = vCodTipoOrden;

    po_cod_error := 0;
    po_des_error := 'Operaci?n Exitosa';

  exception
    when v_error1 then
      open po_dato for
        select null from dual;
      po_cod_error := 2;
      po_des_error := 'FALTAN PARAMETROS';
    when others then
      open po_dato for
        select null from dual;
      po_cod_error := '-1';
      po_des_error := 'ERROR: ' || sqlerrm;
  end;

  PROCEDURE SGASS_SUBTIPO_ORDEN (ln_cod_id        OPERACION.SOLOT.COD_ID%TYPE,
                                 LN_TIPTRA        OPERACION.TIPTRABAJO.TIPTRA%TYPE,
                                 LV_SUBTIPO_ORDEN  out varchar2,
                                 po_cod_error      out number,
                                 po_des_error      out varchar2) IS


  LV_SUBTIPO_ALTER VARCHAR2(100);
  LV_TIPO_TRABAJO OPERACION.TIPTRABAJO.DESCRIPCION%TYPE;
  -----
  ln_val_ctv_old NUMBER;
  ln_val_int_old NUMBER;
  ln_val_tlf_old NUMBER;
  -----
  ln_cnt_ctv_old number;
  AN_CODSOLOT      OPERACION.SOLOT.CODSOLOT%TYPE;
  LV_TIPOSRV       varchar2(20);
  LN_CNT_SUBTIPO   NUMBER;
  BEGIN
    AN_CODSOLOT := operacion.pq_sga_iw.f_max_sot_x_cod_id(ln_cod_id);

    -- EVALUO LOS EQUIPOS
    ln_val_ctv_old := OPERACION.PQ_VISITA_SGA_SIAC.SGAFUN_val_tipsrv_old(An_codsolot, '0062'); -- CTV;
    ln_val_int_old := OPERACION.PQ_VISITA_SGA_SIAC.SGAFUN_val_tipsrv_old(An_codsolot, '0006'); -- INT;
    ln_val_tlf_old := OPERACION.PQ_VISITA_SGA_SIAC.SGAFUN_val_tipsrv_old(An_codsolot, '0004'); -- TLF;

    -- Cantidad de Equipos Serv Anterior CTV
    ln_cnt_ctv_old := OPERACION.PQ_VISITA_SGA_SIAC.sgafun_val_cantequ(An_codsolot, '0062');

    SELECT COUNT(1) INTO LN_CNT_SUBTIPO
    FROM OPERACION.SUBTIPO_ORDEN_ADC
       WHERE ID_TIPO_ORDEN = ( SELECT ID_TIPO_ORDEN FROM TIPTRABAJO
                                WHERE TIPTRA = LN_TIPTRA )
        AND ESTADO = 1;
    -- ENSAMBLANDO EL CODIGO X TIPTRA
    IF LN_CNT_SUBTIPO = 1 THEN
      SELECT COD_SUBTIPO_ORDEN INTO LV_SUBTIPO_ORDEN
        FROM OPERACION.SUBTIPO_ORDEN_ADC
       WHERE ID_TIPO_ORDEN = ( SELECT ID_TIPO_ORDEN FROM TIPTRABAJO
                                WHERE TIPTRA = LN_TIPTRA )
        AND ESTADO = 1;                
    ELSE
      select trim(t.descripcion) INTO LV_TIPO_TRABAJO
       from operacion.tiptrabajo t
      where t.tiptra in ( select d.codigon from opedd d, tipopedd t
                          where d.tipopedd = t.tipopedd
                            and t.abrev IN ('TIPO_TRANS_SIAC', 'TIPO_TRANS_SIAC_LTE')
                        )
        AND t.tiptra = LN_TIPTRA
        AND ROWNUM = 1;
        -- para produccion ln_tiptra = 694
        IF LV_TIPO_TRABAJO = 'HFC/SIAC - TRASLADO INTERNO' THEN
           IF ln_val_ctv_old > 0 AND ln_val_tlf_old = 0 AND ln_val_int_old = 0 THEN
             LV_SUBTIPO_ALTER := 'TIDECO';
           ELSIF ln_val_ctv_old = 0 AND (ln_val_tlf_old > 0 OR ln_val_int_old > 0) THEN
             LV_SUBTIPO_ALTER := 'TIMTA';
           ELSE
             LV_SUBTIPO_ALTER := 'X';
           END IF;
        -- TIPTRA TRASLADO EXTERNO --
        -- para produccion ln_tiptra = 693   412
        ELSIF LV_TIPO_TRABAJO = 'WLL/SIAC - TRASLADO INTERNO' THEN
           IF ln_val_ctv_old > 0 AND ln_val_tlf_old = 0 AND ln_val_int_old = 0 THEN
             LV_SUBTIPO_ALTER := 'TIDTH';
           ELSIF ln_val_ctv_old = 0 AND (ln_val_tlf_old > 0 OR ln_val_int_old > 0) THEN
             LV_SUBTIPO_ALTER := 'TILTE';
           ELSE
             LV_SUBTIPO_ALTER := 'X';
           END IF;
        ELSIF LV_TIPO_TRABAJO = 'WLL/SIAC - TRASLADO EXTERNO'   THEN
           LV_TIPOSRV := TRIM(TO_CHAR(ln_val_ctv_old))||TRIM(TO_CHAR(ln_val_tlf_old))||TRIM(TO_CHAR(ln_val_int_old));
           IF LV_TIPOSRV IN ('100','010','001') THEN
             IF ln_val_int_old > 0 THEN
               LV_SUBTIPO_ALTER := 'TE1PINT';
             ELSE
               IF ln_cnt_ctv_old > 2 THEN
                 LV_SUBTIPO_ALTER := 'TE1PM2D';
               ELSE
                 LV_SUBTIPO_ALTER := 'TE1PH2D';
               END IF;
             END IF;
           ELSIF LV_TIPOSRV IN ('110','011','101') THEN
             IF ln_val_ctv_old = 0 AND ln_val_tlf_old > 0 AND ln_val_int_old > 0 THEN
                LV_SUBTIPO_ALTER := 'TE2PINTTLF';
             ELSE
                IF ln_cnt_ctv_old > 2 THEN
                  IF ln_val_tlf_old > 0 THEN
                     LV_SUBTIPO_ALTER := 'TE2PM2DTLF';
                  ELSIF ln_val_int_old > 0 THEN
                     LV_SUBTIPO_ALTER := 'TE2PM2DINT';
                  END IF;
                ELSE
                  IF ln_val_tlf_old > 0 THEN
                     LV_SUBTIPO_ALTER := 'TE2PH2DTLF';
                  ELSIF ln_val_int_old > 0 THEN
                     LV_SUBTIPO_ALTER := 'TE2PH2DINT';
                  END IF;
                END IF;
             END IF;
           ELSE
              LV_SUBTIPO_ALTER := 'TE3P';
           END IF;
        ELSIF LV_TIPO_TRABAJO = 'HFC/SIAC - TRASLADO EXTERNO' OR LV_TIPO_TRABAJO = 'FTTH/SIAC - TRASLADO EXTERNO' THEN --30.0
           LV_TIPOSRV := TRIM(TO_CHAR(ln_val_ctv_old))||TRIM(TO_CHAR(ln_val_tlf_old))||TRIM(TO_CHAR(ln_val_int_old));
           IF LV_TIPOSRV IN ('100','010','001') THEN
             IF ln_val_int_old > 0 THEN
               LV_SUBTIPO_ALTER := 'TE1PINT';
             ELSIF ln_val_tlf_old > 0 THEN
               LV_SUBTIPO_ALTER := 'TE1PTLF';
             ELSE
               IF ln_cnt_ctv_old > 2 THEN
                 LV_SUBTIPO_ALTER := 'TE1PM2D';
               ELSE
                 LV_SUBTIPO_ALTER := 'TE1PH2D';
               END IF;
             END IF;
           ELSIF LV_TIPOSRV IN ('110','011','101') THEN
             IF ln_val_ctv_old = 0 AND ln_val_tlf_old > 0 AND ln_val_int_old > 0 THEN
                LV_SUBTIPO_ALTER := 'TE2PINTTLF';
             ELSE
                IF ln_cnt_ctv_old > 2 THEN
                  IF ln_val_tlf_old > 0 THEN
                     LV_SUBTIPO_ALTER := 'TE2PM2DTLF';
                  ELSIF ln_val_int_old > 0 THEN
                     LV_SUBTIPO_ALTER := 'TE2PM2DINT';
                  END IF;
                ELSE
                  IF ln_val_tlf_old > 0 THEN
                     LV_SUBTIPO_ALTER := 'TE2PH2DTLF';
                  ELSIF ln_val_int_old > 0 THEN
                     LV_SUBTIPO_ALTER := 'TE2PH2DINT';
                  END IF;
                END IF;
             END IF;
           ELSE
              IF ln_cnt_ctv_old > 2 THEN
                LV_SUBTIPO_ALTER := 'TE3PM2D';
              ELSE
                LV_SUBTIPO_ALTER := 'TE3PH2D';
              END IF;
           END IF;
        ELSIF LV_TIPO_TRABAJO = 'HFC/SIAC - PUNTO ADICIONAL'  OR LV_TIPO_TRABAJO = 'FTTH/SIAC - PUNTO ADICIONAL' THEN --30.0
           IF ln_val_tlf_old > 0 AND ln_val_int_old = 0 THEN
             LV_SUBTIPO_ALTER := 'PATLF';
           ELSIF ln_val_tlf_old = 0 AND ln_val_int_old > 0 THEN
             LV_SUBTIPO_ALTER := 'PAINT';
           ELSE
             LV_SUBTIPO_ALTER := 'X';
           END IF;
 --INI 30.0
         ELSIF LV_TIPO_TRABAJO = 'FTTH/SIAC - TRASLADO INTERNO' THEN
           IF ln_val_ctv_old > 0 AND ln_val_tlf_old = 0 AND ln_val_int_old = 0 THEN
             LV_SUBTIPO_ALTER := 'TIDECO';
           ELSIF ln_val_ctv_old = 0 AND (ln_val_tlf_old > 0 OR ln_val_int_old > 0) THEN
             LV_SUBTIPO_ALTER := 'TIONT';
           ELSE
             LV_SUBTIPO_ALTER := 'X';
           END IF;  
           --FIN 30.0
        END IF;

        IF NVL(LV_SUBTIPO_ALTER,'X') <> 'X' THEN
          SELECT COD_SUBTIPO_ORDEN INTO LV_SUBTIPO_ORDEN
            FROM OPERACION.SUBTIPO_ORDEN_ADC
           WHERE COD_ALTERNO = LV_SUBTIPO_ALTER
             AND ID_TIPO_ORDEN = ( SELECT ID_TIPO_ORDEN FROM TIPTRABAJO
                                    WHERE TIPTRA = LN_TIPTRA )
             AND ROWNUM = 1 ;
        ELSE
          LV_SUBTIPO_ORDEN := 'NDEF';
        END IF;
    END IF;
    po_cod_error := 0;
    po_des_error := 'Operaci?n Exitosa';
  EXCEPTION
    WHEN OTHERS THEN
      po_cod_error := -1;
      po_des_error := 'ERROR: ' || sqlerrm;
  END;

    /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  3.0        08/05/2018  -      Actualiza la tabla pvt.tabpoblado (WEBUNI)
                                campos:
  ******************************************************************************/
  PROCEDURE SGASU_ACTUALIZA_CAMPOS   (ln_idpoblado      number,
                                      LN_IDZONA         OPERACION.ZONA_ADC.IDZONA%TYPE,
                                      LN_COBERTURA      NUMBER,
                                      LN_COBERTURA_LTE  NUMBER,
                                      LN_FLAG_ADC       NUMBER,
                                      po_cod_error      out number,
                                      po_des_error      out varchar2) IS
  V_DYNAMIC_UPDATE VARCHAR2(1000);
  V_WHERE          VARCHAR2(100);
  ERR_EXCEPTION    EXCEPTION;
  BEGIN
    IF ln_idpoblado IS NULL THEN
      RAISE ERR_EXCEPTION;
    END IF;
    V_DYNAMIC_UPDATE :='UPDATE pvt.tabpoblado@dbl_pvtdb SET idpoblado=idpoblado';
    V_WHERE :=' WHERE IDPOBLADO='''||LN_IDPOBLADO||'''';

    IF LN_IDZONA IS NOT NULL THEN
       V_DYNAMIC_UPDATE := V_DYNAMIC_UPDATE||', IDZONA = ' ||LN_IDZONA ;
    END IF;
    IF LN_FLAG_ADC IS NOT NULL THEN
       V_DYNAMIC_UPDATE := V_DYNAMIC_UPDATE||', flag_Adc = ' ||LN_FLAG_ADC ;
    END IF;
    IF LN_COBERTURA IS NOT NULL THEN
       V_DYNAMIC_UPDATE := V_DYNAMIC_UPDATE||', COBERTURA = ' ||LN_COBERTURA ;
    END IF;
    IF LN_COBERTURA_LTE IS NOT NULL THEN
       V_DYNAMIC_UPDATE := V_DYNAMIC_UPDATE||', COBERTURA_LTE = ' ||LN_COBERTURA_LTE ;
    END IF;

    V_DYNAMIC_UPDATE := V_DYNAMIC_UPDATE||V_WHERE;
    EXECUTE IMMEDIATE V_DYNAMIC_UPDATE;
    po_cod_error :=0;
    po_des_error :='OK';
  EXCEPTION
    WHEN ERR_EXCEPTION THEN
      po_cod_error :=-2;
      po_des_error :='Error: el idpoblado no puede ser nulo';
    WHEN OTHERS THEN
      po_cod_error :=-1;
      po_des_error :='Error: '||V_DYNAMIC_UPDATE||'-' ||sqlerrm;
  END;
  --FIN PROY-31513
PROCEDURE SGASU_parm_vta_pvta_adc(inCODSOLOT      in OPERACION.SOLOT.CODSOLOT%TYPE,
                                     inPLANO         in varchar2,
                                     inIDPOBLADO     in varchar2,
                                     inSUBTIPO_ORDEN in varchar2,
                                     inFECHA_PROGRA  in date,
                                     inFRANJA        in varchar2,
                                     inIDBUCKET      in varchar2,
                                     ouCOD_ERR       out varchar2,
                                     ouMSG_ERR       out varchar2) IS
  BEGIN
    ouCOD_ERR := '0';
    ouMSG_ERR := 'OK';

    if inCODSOLOT is null or length(trim(inCODSOLOT)) = 0 then
      ouCOD_ERR := '1';
      ouMSG_ERR := 'Debe ingresar CODSOLOT';
      return;
    end if;

    if (inPLANO is null or length(trim(inPLANO)) = 0) and
       (inIDPOBLADO is null or length(trim(inIDPOBLADO)) = 0) then
      ouCOD_ERR := '1';
      ouMSG_ERR := 'Debe ingresar PLANO y/o IDPOBLADO';
      return;
    end if;

    if inPLANO is null or length(trim(inPLANO)) = 0 and inIDPOBLADO is not null then
      UPDATE operacion.parametro_vta_pvta_adc
      SET idpoblado = inIDPOBLADO,
      subtipo_orden = inSUBTIPO_ORDEN,
      fecha_progra  = inFECHA_PROGRA,
      franja        = inFRANJA,
      idbucket      = inIDBUCKET
      WHERE codsolot = inCODSOLOT;
    end if;

    if inIDPOBLADO is null or
       length(trim(inIDPOBLADO)) = 0 and inPLANO is not null then
      UPDATE operacion.parametro_vta_pvta_adc
      SET plano = inPLANO,
      subtipo_orden = inSUBTIPO_ORDEN,
      fecha_progra  = inFECHA_PROGRA,
      franja        = inFRANJA,
      idbucket      = inIDBUCKET
      WHERE codsolot = inCODSOLOT;
    end if;

  exception
    when others then
      ouCOD_ERR := '-1';
      ouMSG_ERR := SUBSTR('ERROR : ' || sqlerrm, 1, 250);
      rollback;
  END;

  --Inicio 23.0
  /*****************************************************************
  * Nombre            : SGAFUN_OBTIENE_VALOR_CAMPO
  * Prop?sito         : Obtener el codigo de la tabla parametros, en base a
                        la descripcion enviada
  * Input             : K_DESCRIPCION       --> Descripcion para la tabla parametros
  * Output            : K_NUMERO_ERROR      --> Codigo de Error
                        K_DESCRIPCION_ERROR --> Descripcion del Error
  * Creado por        : PROY-40032
  * Fec Creaci?n      : 20/08/2018
  * Fec Actualizaci?n : N/A
  *****************************************************************/
  function SGAFUN_OBTIENE_VALOR_CAMPO(K_DESCRIPCION       in varchar2,
                                      K_NUMERO_ERROR      out number,
                                      K_DESCRIPCION_ERROR out varchar2)
    return number is

    V_CODIGON operacion.parametro_det_adc.codigon%type;
  begin

    K_NUMERO_ERROR      := 0;
    K_DESCRIPCION_ERROR := '';
    begin
      select d.codigon
        into V_CODIGON
        from operacion.parametro_det_adc d, operacion.parametro_cab_adc c
       where d.abreviatura = K_DESCRIPCION
         and d.id_parametro = c.id_parametro
         and c.abreviatura = 'integrar_fullstack'
         and d.estado = 1
         and c.estado = 1;

    exception
      when no_data_found then
        V_CODIGON           := null;
        K_NUMERO_ERROR      := -1;
        K_DESCRIPCION_ERROR := '[OPERACION.PQ_ADM_CUADRILLA.SGAFUN_OBTIENE_FLAG_VIP_ORD] la configuracion de ' ||
                               K_DESCRIPCION || ', No existe';
    end;
    return V_CODIGON;
  END;
  /*****************************************************************
  * Nombre            : SGAFUN_OBTIENE_FLAG_VIP_ORD
  * Prop?sito         : Obtiene el indicador del cliente de la tbl tipo_orden_adc
                        1 = VIP
                        2 = No VIP(defecto)
  * Input             : K_CODIGON           --> Codigo de orden
  * Output            : K_NUMERO_ERROR      --> Codigo de Error
                        K_DESCRIPCION_ERROR --> Descripcion del Error
  * Creado por        : PROY-40032
  * Fec Creaci?n      : 20/08/2018
  * Fec Actualizaci?n : N/A
  *****************************************************************/
  function SGAFUN_OBTIENE_FLAG_VIP_ORD(K_COD_SUBTIPO_ORDEN operacion.subtipo_orden_adc.cod_subtipo_orden%type,
                                       K_NUMERO_ERROR      out number,
                                       K_DESCRIPCION_ERROR out varchar2)
    return number is
    V_FLAG_VIP operacion.tipo_orden_adc.flg_cuota_vip%type;

  begin
    K_NUMERO_ERROR      := 0;
    K_DESCRIPCION_ERROR := '';
    begin
      select flg_cuota_vip
        into V_FLAG_VIP
        from operacion.tipo_orden_adc a
       where a.id_tipo_orden =
             (select c.id_tipo_orden
                from operacion.subtipo_orden_adc c
               where cod_subtipo_orden = K_COD_SUBTIPO_ORDEN);

    exception
      when no_data_found then
        V_FLAG_VIP          := null;
        K_NUMERO_ERROR      := -1;
        K_DESCRIPCION_ERROR := '[OPERACION.PQ_ADM_CUADRILLA.SGAFUN_OBTIENE_FLAG_VIP_ORD] la cuota VIP de la tabla tipo_orden_adc, no exite ';
    end;
    return V_FLAG_VIP;
  end;
  /*****************************************************************
  * Nombre            : SGAFUN_OBTIENE_ZONA_COMPLEJA
  * Prop?sito         : Obtiene la zona compleja de la tabla operacion.zona_adc
                        1 : No compleja
                        2 : Compleja
  * Input             : K_CODZONAS          --> Codigo de zonas
  * Output            : K_NUMERO_ERROR      --> Codigo de Error
                        K_DESCRIPCION_ERROR --> Descripcion del Error
  * Creado por        : PROY-40032
  * Fec Creaci?n      : 20/08/2018
  * Fec Actualizaci?n : N/A
  *****************************************************************/
  function SGAFUN_OBTIENE_ZONA_COMPLEJA(K_CODZONA           operacion.zona_adc.codzona%type,
                                        K_NUMERO_ERROR      out number,
                                        K_DESCRIPCION_ERROR out varchar2)
    return number is

    V_FLAG_ZONA operacion.zona_adc.flag_zona%type;
  begin
    K_NUMERO_ERROR      := 0;
    K_DESCRIPCION_ERROR := '';
    begin

      select case
               when nvl(flag_zona, 1) = 2 then
                flag_zona
               else
                1
             end zona
        into V_FLAG_ZONA
        from operacion.zona_adc
       where codzona = K_CODZONA;
      return V_FLAG_ZONA;

    exception
      when no_data_found then
        V_FLAG_ZONA         := null;
        K_NUMERO_ERROR      := -1;
        K_DESCRIPCION_ERROR := '[OPERACION.PQ_ADM_CUADRILLA..SGAFUN_OBTIENE_ZONA_COMPLEJA] La Configuracion flag_zona, en la tabla ZONA_ADC, No Existe ';
    end;
    return V_FLAG_ZONA;
  end;
  /*****************************************************************
  * Nombre            : SGASS_LISTA_SERV_CONTACTOS
  * Prop?sito         : Obtiene la lista los contactos del cliente
  * Input             : K_CODZONAS      --> Codigo de zonas
  * Output            : K_NUMERO_ERROR   --> Codigo de Error
                        K_DESCRIPCION_ERROR--> Descripcion del Error
  * Creado por        : PROY-40032
  * Fec Creaci?n      : 20/08/2018
  * Fec Actualizaci?n : N/A
  *****************************************************************/
  procedure SGASS_LISTA_SERV_CONTACTOS(K_CODIGO_CLIENTE in agendamiento.codcli%type,
                                       K_TRAMA          out clob) is
    V_IDERROR      numeric;
    V_MENSAJEERROR varchar2(200);
    V_CANT         number := 0;
    V_CANT_CONT    number;

    cursor cur is
      select case
               when mcc.idmedcom in (select d.codigoc
                                       from operacion.parametro_det_adc d,
                                            operacion.parametro_cab_adc c
                                      where d.abreviatura = 'telefonos_contacto'
                                        and d.id_parametro = c.id_parametro
                                        and c.abreviatura = 'integrar_fullstack'
                                        and d.estado = 1
                                        and c.estado = 1
                                        and d.codigon = 1) then
                'Celular'
               when mcc.idmedcom in (select d.codigoc
                                       from operacion.parametro_det_adc d,
                                            operacion.parametro_cab_adc c
                                      where d.abreviatura = 'telefonos_contacto'
                                        and d.id_parametro = c.id_parametro
                                        and c.abreviatura = 'integrar_fullstack'
                                        and d.estado = 1
                                        and c.estado = 1
                                        and d.codigon = 2) then
                'Fijo'
             end idmedcom,
             mcc.numcomcnt
        from marketing.vtatabcntcli cc,
             marketing.vtamedcomcnt mcc,
             marketing.vtatabmedcom vtm
       where mcc.codcnt = cc.codcnt
         and mcc.idmedcom = vtm.idmedcom
         and cc.codcli = K_CODIGO_CLIENTE
         and mcc.idmedcom in
             (select d.codigoc
                from operacion.parametro_det_adc d, operacion.parametro_cab_adc c
               where d.abreviatura = 'telefonos_contacto'
                 and d.id_parametro = c.id_parametro
                 and c.abreviatura = 'integrar_fullstack'
                 and d.estado = 1
                 and c.estado = 1);
    V_BODY clob;
    V_ITEM clob;
    V_SERV clob;
  begin
    V_CANT_CONT := SGAFUN_OBTIENE_VALOR_CAMPO('cantidad_contactos',
                                              V_IDERROR,
                                              V_MENSAJEERROR);

    if V_MENSAJEERROR <> 0 then
      raise_application_error(16,
                              'OPERACION.pq_adm_cuadrilla.p_lista_servicios_contactos - ' ||
                              to_char(V_IDERROR) || '-' || V_MENSAJEERROR);
    end if;

    for reg in cur loop
      if reg.numcomcnt is not null then
        V_CANT := V_CANT + 1; --contador para el numero de contactos
        if V_CANT <= V_CANT_CONT then
          --Maximo numero de contactos 5
          V_ITEM := null;
          V_ITEM := f_Obtener_XML(V_ITEM,
                                  'Services_ToInstall_Cont',
                                  '@Telefono',
                                  reg.idmedcom);
          V_ITEM := f_Obtener_XML(V_ITEM,
                                  'Services_ToInstall_Cont',
                                  '@NroTelefono',
                                  reg.numcomcnt);
          if V_SERV is null then
            V_SERV := V_SERV || V_ITEM;
          else
            --Salto de linea a partir del 2do telefono
            V_SERV := V_SERV || chr(13) || '      ' || V_ITEM;
          end if;

        end if;
      end if;
    end loop;
    V_BODY  := null;
    V_BODY  := f_Obtener_XML(V_BODY,
                             'XAServices_ToInstall_Cont',
                             '@ServiceToInstall',
                             V_SERV);
    K_TRAMA := V_BODY;
  end SGASS_LISTA_SERV_CONTACTOS;
  /*****************************************************************
  * Nombre            : SGAFUN_VALIDA_CONFIG_PUERTO
  * Prop?sito         : Validar si se ha realizado la configuraci?n por puerto
  * Input             : K_CODIGO_SAP       --> Codigo SAP
  * Output            :
  * Creado por        : PROY-40032
  * Fec Creaci?n      : 20/08/2018
  * Fec Actualizaci?n : N/A
  *****************************************************************/
  function SGAFUN_VALIDA_CONFIG_PUERTO(K_CODIGO_SAP in operacion.inventario_env_adc.codigo_sap%type)

   return number is
    lv_count pls_integer;

  begin

    select count(1)
      into lv_count
      from OPERACION.config_puertos
     where IDUNICO = K_CODIGO_SAP
       and estado = 1;

    return lv_count;

  exception
    when no_data_found then
      raise_application_error(-20000,
                              $$plsql_unit ||
                              '.SGAFUN_VALIDA_CONFIG_PUERTO(K_CODIGO_SAP => ' ||
                              K_CODIGO_SAP || ') ' || sqlerrm);

  end;
/*****************************************************************
  * Nombre            : SGASS_TRAMA_INVENTARIO_DEL_ALL
  * Prop?sito         : Genera la Trama, con los registros a eliminar

  * Input             : k_id_proceso    --> Codigo de proceso
  * Output            : k_iderror       --> Codigo de Error
                        k_mensaje_error --> Descripcion del Error
  * Creado por        : PROY-40032
  * Fec Creaci?n      : 17/09/2018
  * Fec Actualizaci?n : N/A
   *****************************************************************/
  procedure SGASS_TRAMA_INVENTARIO_DEL_ALL(k_id_proceso    in number,
                                           k_fecha         in operacion.inventario_env_adc.fecha_inventario%type,
                                           k_flg_tipo      in operacion.inventario_env_adc.flg_tipo%type,
                                           k_contrata      in operacion.inventario_env_adc.usureg%type,
                                           k_accion        in varchar2,
                                           k_iderror       out numeric,
                                           k_mensaje_error out varchar2) is
    v_delimitador    varchar2(1) := '|';
    v_negativa       varchar2(1) := '~';
    v_separador      varchar2(1) := ';';
    v_auditoria      varchar2(100);
    v_ip             varchar2(20);
    v_user           varchar2(50) := user;
    v_id_recurso_ext operacion.inventario_env_adc.id_recurso_ext%type;
    v_servicio       varchar2(100);
    v_count          pls_integer;
    v_trama          clob;
    v_trama1         clob;
    v_trama2         clob;
    v_xml            clob;
    v_error_excep    exception;
    v_delete         constant varchar2(50) := 'delete_inventory';
    v_id_proceso     number  :=0;
    v_count_nom      pls_integer;
    v_observacion    operacion.inventario_env_adc.observacion%type;

  begin
   --Obtenemos la Observacion del inventario
    select observacion
      into v_observacion
      from operacion.inventario_env_adc t
     where t.id_proceso = k_id_proceso
       and rownum=1 ;
   --Obtenemos todos los procesos con la misma observacion
   declare
    cursor cur_id_proceso is
    select distinct(t2.id_proceso)
      from operacion.inventario_env_adc t2,
           (select substr(a.archivo, (instr(a.archivo, '\', -1, 1)+1), length (a.archivo)) nom_archivo,
                   a.id_proceso
              from operacion.cab_inventario_env_adc a
             where a.id_proceso < k_id_proceso) inv_2
     where t2.id_proceso=inv_2.id_proceso
       and t2.envio_eta        = 1
       and t2.fecha_inventario = k_fecha
       and t2.flg_del          = 0
       and rownum              = 1
       --and t2.observacion      = v_observacion;
       and inv_2.nom_archivo in
                                (select
                                        distinct (select substr(a.archivo, (instr(a.archivo, '\', -1, 1)+1), length (a.archivo))
                                                    from operacion.cab_inventario_env_adc a
                                                   where a.id_proceso=t.id_proceso) nom_archivo2
                                   from operacion.inventario_env_adc t
                                  where t.id_proceso=k_id_proceso)
      order by t2.id_proceso desc;

    --Obtiene a los tecnicos por proceso
    cursor lcur_inv_tecnico (v_id_proceso in operacion.inventario_env_adc.id_proceso%type) is
    select distinct i.id_recurso_ext
      from operacion.inventario_env_adc i
     where i.id_proceso = v_id_proceso
       and i.flg_carga  = 1;

      begin
        --Obtiene el max id de proceso en base al nombre del archivo cargado
        select max(t2.id_proceso)
          into v_id_proceso
          from operacion.inventario_env_adc t2,
               (select substr(a.archivo, (instr(a.archivo, '\', -1, 1)+1), length (a.archivo)) nom_archivo,
                       a.id_proceso
                  from operacion.cab_inventario_env_adc a
                 where a.id_proceso<k_id_proceso) inv_2
         where t2.id_proceso=inv_2.id_proceso
           and t2.envio_eta        = 1
           and t2.fecha_inventario = k_fecha
           and inv_2.nom_archivo in
                                    (select
                                            distinct (select substr(a.archivo, (instr(a.archivo, '\', -1, 1)+1), length (a.archivo))
                                                        from operacion.cab_inventario_env_adc a
                                                       where a.id_proceso=t.id_proceso) nom_archivo2
                                       from operacion.inventario_env_adc t
                                      where t.id_proceso=k_id_proceso);
        --Recorremos los procesos
        if v_id_proceso >0 then
        FOR lcur_id_proceso in cur_id_proceso LOOP
          FOR lcur_inv IN lcur_inv_tecnico (lcur_id_proceso.id_proceso) LOOP
           declare
            cursor cur_serv_del is
            select i.id_inventario,
                   i.tecnologia,
                   i.modelo,
                   i.codigo_sap,
                   i.tipo_inventario,
                   i.fecha_inventario,
                   i.mta_mac_cm,
                   i.mta_mac,
                   i.nro_tarjeta,
                   i.inddependencia,
                   i.observacion,
                   i.quantity,
                   i.descripcion,
                   i.invsn,
                   i.unit_addr,
                   i.id_recurso_ext
              from OPERACION.inventario_env_adc i
             where i.id_proceso        = lcur_id_proceso.id_proceso
               and i.id_recurso_ext    = lcur_inv.id_recurso_ext
               and nvl(i.flg_carga, 0) = 1
             order by i.invsn;

            cursor reg_inv_recurso is
            select i.id_inventario, i.tipo_inventario, i.id_recurso_ext
              from OPERACION.inventario_env_adc i
             where i.fecha_inventario = k_fecha
               and i.id_recurso_ext   = lcur_inv.id_recurso_ext
               and i.id_proceso       = lcur_id_proceso.id_proceso
               and nvl(i.flg_carga, 0)= 1
               and (k_contrata        = '%' or i.usureg = k_contrata);

            begin

            k_iderror       := 0;
            k_mensaje_error := null;

            select sys_context('userenv', 'ip_address') into v_ip from dual;

            v_auditoria := v_ip || v_delimitador || lv_aplicacion || v_delimitador ||
                           v_user;

            for lcur_rec in reg_inv_recurso loop
              v_trama          := lcur_rec.id_inventario || v_delimitador;
              v_id_recurso_ext := lcur_rec.id_inventario;
            end loop;

            for lcur_rec in reg_inv_recurso loop
              v_trama1 := 'inventory_only' || v_delimitador || 'incremental' ||
                          v_delimitador || to_char(k_fecha, 'dd/mm/yyyy') ||
                          v_delimitador || 'appt_number' || v_delimitador || 'invsn' ||
                          v_delimitador || to_char(k_fecha, 'yyyy-mm-dd') ||
                          v_delimitador || k_accion || v_delimitador ||
                          lcur_rec.id_recurso_ext;
            end loop;
            v_trama2 :='';
            FOR lcur_del IN cur_serv_del LOOP
                    v_trama2 := v_trama2 || 'XI_IDINVENTARIO=' ||
                          lcur_del.id_inventario || v_negativa ||
                          'XI_TECNOLOGIA=' || lcur_del.tecnologia || v_negativa ||
                          'inv_description=' || lcur_del.descripcion ||
                          v_negativa || 'XI_MODELO=' || lcur_del.modelo ||
                          v_negativa || 'invtype_label=' ||
                          lcur_del.tipo_inventario || v_negativa ||
                          'XI_CODIGOSAP=' || lcur_del.codigo_sap || v_negativa ||
                          'invsn=' || lcur_del.invsn || v_negativa ||
                          'XI_MTA_MAC_CM=' || lcur_del.mta_mac_cm || v_negativa ||
                          'XI_MTA_MAC=' || lcur_del.mta_mac || v_negativa ||
                          'XI_UNIT_ADDR=' || lcur_del.unit_addr || v_negativa ||
                          'XI_NRO_TARJETA=' || lcur_del.nro_tarjeta || v_negativa ||
                          'XI_INDDEPENDENCIA=' || lcur_del.inddependencia ||
                          v_negativa || 'XI_OBSERVACION=' || lcur_del.observacion ||
                          v_negativa || 'quantity=' || lcur_del.quantity ||
                          v_separador;
            END LOOP;

            v_trama2 := substr(v_trama2, 1, length(v_trama2) - 1);

            if v_trama2 is not null then
              v_trama := v_trama || v_auditoria || v_delimitador || v_trama1 ||
                         v_delimitador || v_trama2;

              v_servicio := 'cargarInventarioIncrementalSGA_ADC';

              begin
                webservice.pq_obtiene_envia_trama_adc.p_ws_consulta_inv(k_id_proceso,
                                                                        v_servicio,
                                                                        v_trama,
                                                                        v_xml,
                                                                        k_iderror,
                                                                        k_mensaje_error);

                if k_iderror in (-1, -2) then
                  raise v_error_excep;
                else
                  webservice.PQ_OBTIENE_ENVIA_TRAMA_ADC.p_inventario(k_id_proceso,
                                                                     v_xml,
                                                                     k_fecha,
                                                                     v_id_recurso_ext,
                                                                     k_flg_tipo,
                                                                     k_iderror,
                                                                     k_mensaje_error);
                end if;
              exception
                when others then
                  k_mensaje_error := '   Codigo Error: ' || to_char(sqlcode) || chr(13) ||
                                     '   Mensaje Error: ' || to_char(sqlerrm) || chr(13) ||
                                     '   Linea Error: ' ||
                                     dbms_utility.format_error_backtrace;
                  raise v_error_excep;
              end;
              else
                  k_iderror       := null;
            end if;
          exception
            when v_error_excep then
              K_iderror := -1;
            when no_data_found then
              k_iderror       := -1;
              k_mensaje_error := '[operacion.pq_adm_cuadrilla.p_gen_trama_inventario_inc] Inventario no existe';
            when others then
              k_iderror       := -2;
              k_mensaje_error := '[operacion.pq_adm_cuadrilla.p_gen_trama_inventario_inc] No se pudo generar la trama de inventario error: ' ||
                                 sqlerrm || '.';
         end;
      END LOOP;
    END LOOP;
   end if;
   --Si No hay error, actualizamos el flg_del a 1
   if k_iderror=0 then
     for lcur_proceso_act in cur_id_proceso loop
         update operacion.inventario_env_adc set flg_del=1 where id_proceso=lcur_proceso_act.id_proceso ;
     end loop;
   end if;
  end;
 end;
 --Fin 23.0
 --Ini 24.0
  procedure SP_VALIDA_EXISTE_SOT(IDORDER      in AGENLIQ.SGAT_AGENDA.AGENN_IDPEDIDO%type,
                                 CODRESPUESTA out number,
                                 DESCRIPCION  out varchar2) is
  /*****************************************************************
  * Nombre            : SP_VALIDA_EXISTE_SOT
  * Prop?sito         : alidar en la tabla:operacion.agendamiento, que existe registro donde idorder es campo idagenda
  * Input             : IDORDER       --> Codigo Order
  * Output            : CODRESPUESTA  --> Codigo Respuesta
                        DESCRIPCION   --> Descripcion
  * Creado por        : PROY-40032
  * Fec Creaci?n      : 20/08/2018
  * Fec Actualizaci?n : N/A
  *****************************************************************/
    NUMORDER number;
  begin
    NUMORDER := 0;
    if IDORDER is not null then
      select count(1)
        into NUMORDER
        from OPERACION.AGENDAMIENTO T
       where T.IDAGENDA = IDORDER
         and FLG_ORDEN_ADC = 1;
      if NUMORDER > 0 then
        CODRESPUESTA := 1;
        DESCRIPCION  := 'EXISTE';
      else
        CODRESPUESTA := 2;
        DESCRIPCION  := 'NO EXISTE';
      end if;
    end if;
  exception
    when others then
      DBMS_OUTPUT.PUT_LINE(IDORDER);
      DBMS_OUTPUT.PUT_LINE('ERROR ' || sqlcode || ': ' ||
                           SUBSTR(sqlerrm, 1, 255));
  end SP_VALIDA_EXISTE_SOT;
 --Fin 24.0
 --------------------------------------------------------------------------------
 --Ini 25.0
  FUNCTION GET_PARAM_C(P_ABREV1 VARCHAR2, P_ABREV2 VARCHAR2) RETURN VARCHAR2 IS
    L_VALOR OPERACION.PARAMETRO_DET_ADC.CODIGOC%TYPE;
  
  BEGIN
    SELECT D.CODIGOC
      INTO L_VALOR
      FROM OPERACION.PARAMETRO_DET_ADC D,
           OPERACION.PARAMETRO_CAB_ADC C
     WHERE C.ID_PARAMETRO = D.ID_PARAMETRO
       AND C.ABREVIATURA = P_ABREV1
       AND D.ABREVIATURA = P_ABREV2;
  
    RETURN L_VALOR;
  END;
  --------------------------------------------------------------------------------
  FUNCTION GET_PARAM_N(P_ABREV1 VARCHAR2, P_ABREV2 VARCHAR2) RETURN NUMBER IS
    L_VALOR OPERACION.PARAMETRO_DET_ADC.CODIGON%TYPE;
  
  BEGIN
    SELECT D.CODIGON
      INTO L_VALOR
      FROM OPERACION.PARAMETRO_DET_ADC D,
           OPERACION.PARAMETRO_CAB_ADC C
     WHERE C.ID_PARAMETRO = D.ID_PARAMETRO
       AND C.ABREVIATURA = P_ABREV1
       AND D.ABREVIATURA = P_ABREV2;
  
    RETURN L_VALOR;
  END;
 --Fin 25.0
END;
/