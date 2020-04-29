CREATE OR REPLACE PACKAGE BODY OPERACION.PQ_3PLAY_INALAMBRICO IS

  /************************************************************************************************
  NOMBRE:     OPERACION.PQ_3PLAY_INALAMBRICO
  PROPOSITO:  Generacion de proceso de CONAX LTE

  REVISIONES:
  Version   Fecha          Autor            Solicitado por      Descripcion
  -------- ----------  ------------------   -----------------   ------------------------
  1.0    2015-09-16  Danny Sánchez/       Eustaquio Gibaja/    PQT-245308-TSK-75749 - 3Play Inalambrico
  Angel Condori        Mauro Zegarra/
  Alberto Miranda
  2.0    2015-11-27  Angel Condori        Mauro Zegarra        PQT-246956-TSK-76609
  3.0    2015-12-01  Felipe Maguiña                            PQT-247157-TSK-76711 - 3Play Inalambrico
  4.0    2015-12-15  Dorian Sucasaca/                          PQT-247649-TSK-76965
  Angel Condori
  5.0    2016-01-04  Danny Sánchez/       Alberto Miranda      SD-616407
  Angel Condori
  6.0    2016-01-06  Angel Condori        Alberto Miranda      PQT-248422-TSK-77366
  7.0    2016-01-14  Danny Sánchez/       Alberto Miranda     SGA_SD_636471_URG
  8.0    2016-03-09  Danny Sánchez/       Mauro Zegarra       SD-669218
  9.0    2016-10-10  Felipe Maguiña                            PROY 25526 -  Ciclos de Facturación
  10.0   2016-12-16  Servicio Fallas-HITSS                     SD-840898
  11.0   2017-01-19  Servicio Fallas-HITSS                     Migración WIMAX a LTE
  12.0   2016-12-26  Luis Polo B.         Karen Vasquez        SGA-SD-794552
  13.0   2017-01-19  Servicio Fallas-HITSS
  14.0   2016-11-10  Luis Guzmán          Alex Alamo        PROY-20152 3Play Inalambrico
  15.0   2016-11-10  Luis Guzmán          Fanny Najarro        INC000000774220
  16.0   2017-07-07  Dorian Sucasaca      Mauro Zegarra
  17.0   2017-08-29  juan gonzales        Luis Flores          PROY-27792
  18.0   2017-09-29  Jose Arriola         Carlos Lazarte       PROY-29955 Alineacion CONTEGO FASE 2
  19.0   2017-12-16  Jose Arriola         Carlos Lazarte       inicidencia
  20.0   2018-05-24  Cesar Najarro        Guillermo Salcedo    PROY-31812 Activacion LTE OLO
  21.0   2018-08-13  Jenny Valencia       Jose Varillas        Proy-32581 Portabilidad In
  22.0   2018-11-20  Luis Flores          Luis Flores          PROY-32581 PostVenta LTE
  23.0   2019-03-18  Luis Flores          Luis Flores          PROY-32581 PostVenta LTE
  24.0   2018-06-01  Edwin  Vasquez       Catherine Aquino     PROY-29215_IDEA-30265 Costo de Instalación para LTE en SISACT
  25.0   2019-06-03  INC000002001602      RICHARD MEDINA       CIERRE TAREA VALIDACION DE INSTALACION DE SERVICIO INALAMBRICO
  26.0   2020-02-14  APP INSTALADR        Cesar Rengifo        Validacion de Creacion de SOT por APlicativo
  /************************************************************************************************/
  PROCEDURE p_conax_alta(p_codsolot  in number,
                         p_idtareawf in number,
                         p_cod       out number,
                         p_resul     out varchar2) IS
    l_codsolot        number;
    l_numslc          varchar2(10);
    l_estsol          number(2);
    l_numregistro     VARCHAR2(30);
    l_rpta            NUMBER;
    l_resultado       VARCHAR2(200);
    l_mensaje         VARCHAR2(2000);
    l_nro_contrato    VARCHAR2(30);
    l_id_sisact       NUMBER;
    l_codigo          NUMBER;
    l_count           PLS_INTEGER;
    l_contador1       PLS_INTEGER;
    l_result_post     PLS_INTEGER;
    l_tipcambio       PLS_INTEGER := 1;
    l_serie_tarjeta   VARCHAR2(2000);
    l_serie_deco      VARCHAR2(2000);
    l_grupo           NUMBER;
    l_numserie        VARCHAR2(2000);
    l_mac             varchar2(30);
    l_cant            number(8, 2);
    l_codinssrv       number;
    l_punto           number(10);
    l_orden           number(4);
    l_codsap          varchar2(20);
    ln_deco_adicional NUMBER; --v19.0

    CURSOR equipos_conax IS
      select equ_conax.grupo grupo,
             se.numserie,
             se.mac,
             se.cantidad,
             i.codinssrv,
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
         and se.codsolot = l_codsolot
         and t.tipequ = equ_conax.tipequ;

    CURSOR equipos_conax_adicional IS
      SELECT equ_conax.grupo grupo,
             se.numserie,
             se.mac,
             se.cantidad,
             i.codinssrv,
             se.punto,
             se.orden,
             a.cod_sap
        FROM solotptoequ se,
             solot s,
             solotpto sp,
             inssrv i,
             tipequ t,
             almtabmat a,
             (SELECT a.codigon tipequ, to_number(codigoc) grupo
                FROM opedd a, tipopedd b
               WHERE a.tipopedd = b.tipopedd
                 AND b.abrev = 'TIPEQU_LTE_ADICIONAL') equ_conax
       WHERE se.codsolot = s.codsolot
         AND s.codsolot = sp.codsolot
         AND se.punto = sp.punto
         AND sp.codinssrv = i.codinssrv
         AND t.tipequ = se.tipequ
         AND a.codmat = t.codtipequ
         AND se.codsolot = l_codsolot
         AND t.tipequ = equ_conax.tipequ;
  BEGIN
    p_cod      := 0;
    p_resul    := 'OK';
    l_codsolot := p_codsolot;

    select count(1)
      into l_contador1
      from operacion.ope_envio_conax
     where codsolot = l_codsolot
       and tipo = 1;

    select s.numslc, s.estsol
      into l_numslc, l_estsol
      from solot s
     where s.codsolot = l_codsolot;

    select pq_inalambrico.f_obtener_numregistro(l_codsolot)
      into l_numregistro
      from dual;

    --ini v19.0
    ln_deco_adicional := operacion.pq_deco_adicional_lte.f_obt_tipo_deco(p_codsolot);
    if ln_deco_adicional = 0 then
      l_result_post := sales.pq_dth_postventa.f_obt_facturable_dth(l_numslc);
    end if;
    --fin v19.0
    --si es reenvio se borrar lo existente
    IF l_contador1 > 0 THEN
      p_borrar_ope_envio_conax(l_codsolot, 1);
    END IF;

    SELECT count(t.codsolot)
      INTO l_count
      FROM operacion.tarjeta_deco_asoc t
     WHERE t.codsolot = l_codsolot;

    IF l_count = 0 THEN
      p_cod   := -1;
      p_resul := 'Debe Asociar las Tarjetas y Decodificador';
      RETURN;
    END IF;

    IF ln_deco_adicional = 0 THEN
      --V19.0
      -- Si es un DTH Post Pago
      IF l_result_post = 1 THEN
        -- REGISTRO EN EL SISACT
        l_serie_deco    := '';
        l_serie_tarjeta := '';

        OPEN equipos_conax;
        LOOP
          FETCH equipos_conax
            INTO l_grupo,
                 l_numserie,
                 l_mac,
                 l_cant,
                 l_codinssrv,
                 l_punto,
                 l_orden,
                 l_codsap;
          EXIT WHEN equipos_conax%NOTFOUND;
          l_codigo := l_grupo;

          IF l_codigo = 1 THEN
            IF (l_serie_tarjeta IS NULL) OR (trim(l_serie_tarjeta) = '') THEN
              l_serie_tarjeta := trim(l_numserie);
            ELSE
              l_serie_tarjeta := l_serie_tarjeta || ',' || trim(l_numserie);
            END IF;
          ELSE
            IF l_codigo = 2 THEN
              IF (l_serie_deco IS NULL) OR (TRIM(l_serie_deco) = '') THEN
                l_serie_deco := TRIM(l_numserie);
              ELSE
                l_serie_deco := l_serie_deco || ',' || trim(l_numserie);
              END IF;
            END IF;
          END IF;
        END LOOP;
        CLOSE equipos_conax;

        p_act_reg_sisact_lte(l_numslc,
                             l_codsolot,
                             l_estsol,
                             p_idtareawf,
                             l_serie_tarjeta,
                             l_serie_deco,
                             l_rpta,
                             l_mensaje,
                             l_nro_contrato);

        IF nvl(l_rpta, 0) <> 0 THEN
          p_cod   := -1;
          p_resul := 'No se registró al SISACT, Error: ' ||
                     TO_CHAR(l_mensaje);
          RETURN;
        END IF;

        --ENVIO A CONAX DE EQUIPOS
        OPEN equipos_conax;
        LOOP
          FETCH equipos_conax
            INTO l_grupo,
                 l_numserie,
                 l_mac,
                 l_cant,
                 l_codinssrv,
                 l_punto,
                 l_orden,
                 l_codsap;
          EXIT WHEN equipos_conax%NOTFOUND;
          l_codigo := l_grupo;
          p_ins_envioconax(l_codsolot,
                           l_codinssrv,
                           l_tipcambio,
                           l_numserie,
                           l_mac,
                           null,
                           null,
                           l_codigo,
                           l_rpta,
                           l_mensaje);
          IF nvl(l_rpta, 0) <> 0 THEN
            p_cod   := -1;
            p_resul := 'No se registró envio a CONAX';
            RETURN;
          END IF;
        END LOOP;
        CLOSE equipos_conax;

        --ACTIVACION DTH
        /*operacion.pq_dth.p_crear_archivo_conax(l_numregistro,
        l_resultado,
        l_mensaje);*/ --19.0

        -- INI 19.0
        OPERACION.PKG_CONTEGO.SGASS_ALTA(l_numregistro,
                                         l_resultado,
                                         l_mensaje);
        -- FIN 19.0

        IF l_resultado = 'OK' THEN
          IF l_id_sisact IS NOT NULL THEN
            UPDATE OPE_SRV_RECARGA_CAB O
               SET O.ID_SISACT = l_id_sisact
             WHERE O.NUMSLC = l_numslc;
          END IF;
        ELSE
          UPDATE ope_srv_recarga_det
             SET mensaje = l_mensaje
           WHERE numregistro = l_numregistro
             AND tipsrv =
                 (SELECT valor FROM constante where constante = 'FAM_CABLE');
          p_cod   := -1;
          p_resul := 'Se produjo un error al Enviar Archivo de Activación a CONAX.' ||
                     l_mensaje;
        END IF;
      END IF;
      --INI V19.0
    ELSIF ln_deco_adicional = 1 THEN
      --ENVIO A CONAX DE EQUIPOS ADICIONALES
      OPEN equipos_conax_adicional;
      LOOP
        FETCH equipos_conax_adicional
          INTO l_grupo,
               l_numserie,
               l_mac,
               l_cant,
               l_codinssrv,
               l_punto,
               l_orden,
               l_codsap;
        EXIT WHEN equipos_conax_adicional%NOTFOUND;
        l_codigo := l_grupo;
        p_ins_envioconax(l_codsolot,
                         l_codinssrv,
                         l_tipcambio,
                         l_numserie,
                         l_mac,
                         null,
                         null,
                         l_codigo,
                         l_rpta,
                         l_mensaje);
        IF nvl(l_rpta, 0) <> 0 THEN
          p_cod   := -1;
          p_resul := 'No se registró envio a CONAX';
          RETURN;
        END IF;
      END LOOP;
      CLOSE equipos_conax_adicional;

      --ACTIVACION DTH
      operacion.pq_dth.p_crear_archivo_conax(l_numregistro,
                                             l_resultado,
                                             l_mensaje);

      OPERACION.PKG_CONTEGO.SGASS_ALTA(l_numregistro,
                                       l_resultado,
                                       l_mensaje);
      IF l_resultado = 'OK' THEN
        IF l_id_sisact IS NOT NULL THEN
          UPDATE OPE_SRV_RECARGA_CAB O
             SET O.ID_SISACT = l_id_sisact
           WHERE O.NUMSLC = l_numslc;
        END IF;
      ELSE
        UPDATE ope_srv_recarga_det
           SET mensaje = l_mensaje
         WHERE numregistro = l_numregistro
           AND tipsrv =
               (SELECT valor FROM constante where constante = 'FAM_CABLE');
        p_cod   := -1;
        p_resul := 'Se produjo un error al Enviar Archivo de Activación a CONAX.' ||
                   l_mensaje;
      END IF;
    END IF;
    --FIN V19.0
  EXCEPTION
    WHEN OTHERS THEN
      p_cod   := -1;
      p_resul := 'Error en la Activación de Servicios: ' || sqlerrm;

  END;

  /************************************************************************************************/

  PROCEDURE p_conax_baja_ds(p_codsolot operacion.solot.codsolot%TYPE,
                            p_resul    OUT VARCHAR2) IS
    l_codsolot    operacion.solot.codsolot%TYPE;
    l_numslc      operacion.solot.numslc%TYPE;
    l_estsol      operacion.solot.estsol%TYPE;
    l_numregistro VARCHAR2(30);
    l_rpta        NUMBER;
    l_resultado   VARCHAR2(200);
    l_mensaje     VARCHAR2(2000);
    l_codigo      NUMBER;
    l_contador1   PLS_INTEGER;
    l_tipcambio   PLS_INTEGER := 2;
    l_grupo       NUMBER;
    l_numserie    VARCHAR2(2000);
    l_mac         OPERACION.solotptoequ.MAC%TYPE;
    l_cant        OPERACION.solotptoequ.CANTIDAD%TYPE;
    l_codinssrv   OPERACION.inssrv.CODINSSRV%TYPE;
    l_punto       OPERACION.solotptoequ.PUNTO%TYPE;
    l_orden       OPERACION.solotptoequ.ORDEN%TYPE;
    l_codsap      PRODUCCION.Almtabmat.COD_SAP%TYPE;

    CURSOR equipos_conax IS
      select equ_conax.grupo codigo,
             se.numserie     numserie,
             se.mac          mac,
             se.cantidad     cantidad,
             i.codinssrv,
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
         and t.tipequ = equ_conax.tipequ
         and se.codsolot =
             (select codsolot
                from ope_srv_recarga_cab
               where numregistro = (select pq_inalambrico.f_obtener_numregistro(l_codsolot)
                                      from dual))
         and se.estado = 4;

  BEGIN
    l_codsolot := p_codsolot;

    select s.numslc, s.estsol
      into l_numslc, l_estsol
      from solot s
     where s.codsolot = l_codsolot;

    select count(1)
      into l_contador1
      from operacion.ope_envio_conax
     where codsolot = l_codsolot
       and tipo = 2;

    select pq_inalambrico.f_obtener_numregistro(l_codsolot)
      into l_numregistro
      from dual;

    --si es reenvio se borrar lo existente
    IF l_contador1 > 0 THEN
      p_borrar_ope_envio_conax(l_codsolot, 2);
    END IF;

    -- ENVIO A CONAX DE BAJAS
    OPEN equipos_conax;
    LOOP
      FETCH equipos_conax
        INTO l_grupo,
             l_numserie,
             l_mac,
             l_cant,
             l_codinssrv,
             l_punto,
             l_orden,
             l_codsap;
      EXIT WHEN equipos_conax%NOTFOUND;
      l_codigo := l_grupo;

      IF l_codigo = 1 THEN
        IF l_numserie IS NOT NULL THEN
          p_ins_envioconax(l_codsolot,
                           l_codinssrv,
                           l_tipcambio,
                           l_numserie,
                           null,
                           null,
                           null,
                           l_codigo,
                           l_rpta,
                           l_mensaje);
          IF nvl(l_rpta, 0) <> 0 THEN
            p_resul := 'No se registro envio a CONAX';
            RETURN;
          END IF;
        ELSE
          p_resul := 'Debe ingresar el Número de Serie de la tarjeta a desactivar ';
          RETURN;
        END IF;
      END IF;
    END LOOP;
    CLOSE equipos_conax;

    --DESACTIVACION DTH
    OPERACION.PQ_DTH.p_baja_serviciodthxcliente(l_numregistro,
                                                null,
                                                null,
                                                l_resultado,
                                                l_mensaje);

    IF l_resultado = 'OK' THEN
      p_resul := 'OK';
      COMMIT;
    ELSE
      UPDATE ope_srv_recarga_det
         SET mensaje = l_mensaje
       WHERE numregistro = l_numregistro
         AND tipsrv =
             (SELECT valor FROM constante where constante = 'FAM_CABLE');
      p_resul := 'Se produjo un error al Enviar Archivo de Activación a CONAX.';
      COMMIT;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      p_resul := 'ERROR EN P_CONAX_DS: ' || TO_CHAR(l_codsolot);
  END;
  --------------------------------------------------------------------------------
  procedure p_cerrar_val_instalador_lte(a_idtareawf in number,
                                        a_idwf      in number,
                                        a_tarea     in number,
                                        a_tareadef  in number) is
    ln_codsolot   solot.codsolot%type;
    ln_validacion number;
    ln_countpv    number;
  begin
    select codsolot into ln_codsolot from wf where idwf = a_idwf;

    -- INI 21.0 ALTA POR PORT-OUT NO VALIDA INSTALADOR
    IF OPERACION.PKG_PORTABILIDAD.SGAFUN_PORTOUT_ES_ALTA(LN_CODSOLOT) > 0 THEN
      OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(A_IDTAREAWF,
                                       4,
                                       4,
                                       NULL,
                                       SYSDATE,
                                       SYSDATE);
      RETURN;
    END IF;
    -- FIN 21.0

    select count(*)
      into ln_countpv
      from solot s, vtatabslcfac v
     where s.codsolot = ln_codsolot
       and s.numslc = v.numslc
       and sales.pq_dth_postventa.f_obt_facturable_dth(s.numslc) = 1;

    if ln_countpv > 0 then
      select count(*)
        into ln_validacion
        from operacion.ope_val_instalador_dth_rel r
       where r.codsolot = ln_codsolot
         and r.idtareawf = a_idtareawf;

      if ln_validacion = 0 then
        raise_application_error(-20500, 'No se ha Asignado Instalador.');
      end if;
    end if;
  end;
  ---------------------------------------------------------------------------------------------------------------------

  PROCEDURE p_registra_deco_lte(p_cod_id    in varchar2,
                                p_seriedeco in varchar2,
                                p_serietarj in varchar2,
                                p_tipequipo in varchar2,
                                p_tipdeco   in varchar2,
                                p_resultado out integer,
                                p_msgerr    out varchar2) IS
  BEGIN

    tim.pp021_venta_lte.sp_registra_deco_lte@DBL_BSCS_BF(P_COD_ID,
                                                         P_SERIEDECO,
                                                         P_SERIETARJ,
                                                         P_TIPEQUIPO,
                                                         P_TIPDECO,
                                                         P_RESULTADO,
                                                         P_MSGERR);

  END;
  ---------------------------------------------------------------------------------------------------------------------
  procedure p_estado_prov_inst(p_co_id     in integer,
                               p_resultado out integer,
                               p_msgerr    out varchar2) is
  begin

    TIM.PP021_VENTA_LTE.SP_ESTADO_PROV_INST@DBL_BSCS_BF(p_co_id,
                                                        p_resultado,
                                                        p_msgerr);

    --ini 14.00
  exception
    when others then
      p_resultado := -1;
      p_msgerr    := 'Error al consultar el estado de IL';
      --fin 14.00
  end;
  ---------------------------------------------------------------------------------------------------------------------

  PROCEDURE p_generar_inst_venta(p_co_id         in integer,
                                 p_msisdn        in varchar2, -- Nro Telefonico
                                 p_imsi          in varchar2, -- Nro Serie
                                 p_sot           in number,
                                 p_tipequipo     in varchar2,
                                 p_modequipo     in varchar2,
                                 p_fecproceso    in date,
                                 p_request_padre out number,
                                 p_request_tv    out number,
                                 p_resultado     out integer,
                                 p_msgerr        out varchar2) IS
    --Inicio Se agrega por falla INC000001107710
    V_REQUEST       TIM.LTE_CONTROL_PROV.REQUEST@DBL_BSCS_BF%TYPE;
    V_REQUEST_PADRE TIM.LTE_CONTROL_PROV.REQUEST_PADRE@DBL_BSCS_BF%TYPE;
    V_CUSTOMER_ID   TIM.LTE_CONTROL_PROV.CUSTOMER_ID@DBL_BSCS_BF%TYPE;
    p_co_id_sgass   INTEGER;
    p_tip_serv      VARCHAR2(10);
    p_codigo_resp   NUMBER;
    p_mensaje_resp  VARCHAR2(200);
    -- ini 26.0
    v_tip_aplicativo VARCHAR2(20);
    N_VALIDA         INTEGER := 0;  
    -- FIN 26.0
    --Fin Se agrega por falla INC000001107710
  BEGIN
    --Inicio Se agrega por falla INC000001107710
    sgass_srv_cnt(p_sot,
                  p_co_id_sgass,
                  p_tip_serv,
                  p_codigo_resp,
                  p_mensaje_resp);
                  
     -- INI 26.0
       SELECT COUNT(*)
         INTO N_VALIDA
         FROM OPERACION.SGAT_CONTROL_APP
        WHERE CONTROLN_CODSOLOT = p_sot;
       
        IF N_VALIDA = 0 THEN
          v_tip_aplicativo := 'SGA';
        ELSE
          v_tip_aplicativo := 'APP Instalador';
        END IF;
       -- FIN 26.00                       
                  
    --Si solo tiene INT la SOT
    IF p_tip_serv = 'IT' THEN
      BEGIN
        P_RESULTADO := -1;
        P_MSGERR    := 'FAVOR DE EJECUTAR NUEVAMENTE EL PROCESO';

        -- Obtenemos el customer_id
        SELECT CA.CUSTOMER_ID
          INTO V_CUSTOMER_ID
          FROM CURR_CO_STATUS@DBL_BSCS_BF CCS, CONTRACT_ALL@DBL_BSCS_BF CA
         WHERE CCS.CO_ID = P_CO_ID
           AND CCS.CO_ID = CA.CO_ID;

        SELECT TIM.LTE_PADRE_PROV_SEQNO.NEXTVAL@DBL_BSCS_BF
          INTO V_REQUEST_PADRE
          FROM DUAL;

        --CREAR SECUENCIAL PARA EL NVO REQUEST
        SELECT TIM.LTE_PROV_SEQNO.NEXTVAL@DBL_BSCS_BF
          INTO V_REQUEST
          FROM DUAL;

        /* REQUEST ACTIVACION TEL */
        P_REQUEST_PADRE := V_REQUEST_PADRE;

        INSERT INTO TIM.LTE_CONTROL_PROV@DBL_BSCS_BF
          (REQUEST,
           request_padre,
           ACTION_ID,
           PRIORITY,
           CO_ID,
           CUSTOMER_ID,
           INSERT_DATE,
           action_date,
           STATUS,
           SOT,
           TIPO_PROD,
           MSISDN_OLD,
           IMSI_OLD,
           ltev_usucreacion,
           lted_fecha_creacion,
           ltev_usumodificacion,
           lted_fechamodificacion)
        VALUES
          (V_REQUEST,
           V_REQUEST_PADRE,
           1,
           1,
           P_CO_ID,
           V_CUSTOMER_ID,
           SYSDATE,
           SYSDATE,
           '2',
           P_SOT,
           'INT',
           P_MSISDN,
           P_IMSI,
           v_tip_aplicativo,  -- 26.0,
           SYSDATE,
           v_tip_aplicativo,  -- 26.0,
           SYSDATE);

        P_RESULTADO := 0;
        P_MSGERR    := 'PROCESO SATISFACTORIO';
      EXCEPTION
        WHEN OTHERS THEN
          P_RESULTADO := -99;
          P_MSGERR    := 'ERROR: ' || TO_CHAR(SQLCODE) || ' ' || SQLERRM;
      END;
    ELSE
      --Fin Se agrega por falla INC000001107710
      --Para los demas 2Play y 3Play
      tim.pp021_venta_lte.sp_generar_inst_venta@DBL_BSCS_BF(p_co_id,
                                                            p_msisdn,
                                                            p_imsi,
                                                            p_sot,
                                                            p_tipequipo,
                                                            p_modequipo,
                                                            p_fecproceso,
                                                            p_request_padre,
                                                            p_request_tv,
                                                            p_resultado,
                                                            p_msgerr);
    END IF;
  END;
  ---------------------------------------------------------------------------------------------------------------------

  PROCEDURE p_inicia_fact(P_CO_ID      IN INTEGER,
                          P_FECPROCESO IN DATE,
                          P_RESULTADO  OUT INTEGER,
                          P_MSGERR     OUT VARCHAR2) IS
  BEGIN

    sales.p_inicia_fact_lte(p_co_id, p_fecproceso, p_resultado, p_msgerr); -- 11.0

  END;

  ---------------------------------------------------------------------------------------------------------------------
  procedure p_insert_numtel(p_nro_tlf   in varchar2,
                            p_simcard   in varchar2,
                            p_codinssrv in number,
                            p_estnumtel in number,
                            p_tipnumtel in number,
                            p_codnumtel out number,
                            p_cod       out number,
                            p_mensaje   out varchar2) is
  begin
    p_cod     := 0;
    p_mensaje := 'Exito';

    insert into telefonia.numtel
      (estnumtel,
       tipnumtel,
       numero,
       fecasg,
       fecusu,
       codusu,
       codinssrv,
       simcard)
    values
      (p_estnumtel,
       p_tipnumtel,
       p_nro_tlf,
       sysdate,
       sysdate,
       user,
       p_codinssrv,
       p_simcard)
    returning codnumtel into p_codnumtel;
  exception
    when others then
      p_cod     := -1;
      p_mensaje := 'Error al Asociar Numero : ' || sqlerrm;
  end;

  ---------------------------------------------------------------------------------------------------------------------
  procedure p_insert_rsv_numtel(p_codnumtel in number,
                                p_codinssrv in number,
                                p_valido    in number,
                                p_estnumtel in number,
                                p_codcli    in varchar2,
                                p_cod       out number,
                                p_mensaje   out varchar2) is
  begin
    p_cod     := 0;
    p_mensaje := 'Exito';

    insert into telefonia.reservatel
      (codnumtel,
       numslc,
       numpto,
       valido,
       estnumtel,
       fecinires,
       codusures,
       codcli)
    values
      (p_codnumtel,
       (select i.numslc
          from operacion.insprd i
         where i.codinssrv = p_codinssrv
           and i.flgprinc = 1),
       (select i.numpto
          from operacion.insprd i
         where i.codinssrv = p_codinssrv
           and i.flgprinc = 1),
       0,
       p_estnumtel,
       sysdate,
       user, --3.0
       p_codcli);
  exception
    when others then
      p_cod     := -1;
      p_mensaje := 'Error al Asociar Numero : ' || sqlerrm;
  end;

  -------------------------------------------------------------------------------------------------------------------------------
  PROCEDURE p_actualizar_cnt_bscs(a_idtareawf in number,
                                  a_idwf      in number,
                                  a_tarea     in number,
                                  a_tareadef  in number) is
    n_cod_id    number;
    n_cont      number;
    ln_resp     NUMERIC := 0;
    lv_mensaje  VARCHAR2(3000);
    ln_resp1    NUMERIC := 0;
    lv_mensaje1 VARCHAR2(3000);
    lv_idtrs    varchar2(30);
    ln_codsolot number;
    ln_cod1     number;
    lv_resul    varchar2(4000);
    lv_resul1   varchar2(4000);
    ln_cod2     number;
    lv_codcli   solot.codcli%type;
    ln_val_wimax_lte number;
    p_cod       number;
    p_mensaje   varchar2(4000);
    ln_tmcode         NUMBER;
    ln_smcode         NUMBER;
    ln_cod_id         NUMBER;
    ln_custumer_id    NUMBER;

  BEGIN
    SELECT w.codsolot into ln_codsolot from wf w where w.idwf = a_idwf;
    SELECT count(a.cod_id)
      into n_cont
      FROM operacion.solot a
     WHERE a.codsolot = ln_codsolot;

    IF n_cont > 0 THEN
      SELECT a.cod_id
        into n_cod_id
        FROM operacion.solot a
       WHERE a.codsolot =
             (SELECT w.codsolot from wf w where w.idwf = a_idwf);

      -- inc000002095333
      if tim.pp021_venta_lte.f_estado_co_id@dbl_bscs_bf(n_cod_id) = 'ax' then

      --ini 15.0
         select s.codcli
            into lv_codcli
            from solot s
           where s.codsolot = ln_codsolot;

         ln_val_wimax_lte := operacion.pq_sga_wimax_lte.f_val_cli_wimax(lv_codcli);

         select s.cod_id,
               s.customer_id
          into ln_cod_id, ln_custumer_id
          from solotptoequ se,
               solot s,
               solotpto sp,
               inssrv i,
               tipequ t,
               almtabmat a,
               (select a.codigon tipequ, codigoc grupo
                  from opedd a, tipopedd b
                 where a.tipopedd = b.tipopedd
                   and b.abrev = 'TIPEQU_LTE_TLF') equ_conax
         where se.codsolot = s.codsolot
           and s.codsolot = sp.codsolot
           and se.punto = sp.punto
           and sp.codinssrv = i.codinssrv
           and t.tipequ = se.tipequ
           and a.codmat = t.codtipequ
           and se.codsolot = ln_codsolot
           and t.tipequ = equ_conax.tipequ
           and equ_conax.grupo = '3';

         ln_tmcode := tim.pp021_venta_lte.f_get_plan@dbl_bscs_bf(ln_cod_id);
         ln_smcode := tim.pp021_venta_lte.f_get_serv_tel@dbl_bscs_bf(ln_cod_id);

            if ln_val_wimax_lte = 0 then
              p_log_3playi(ln_codsolot,
                           'operacion.pkg_cambio_ciclo_fact.sgasu_camb_ciclo_fact',
                           'INICIO',
                           'Validación de Servicios Inalámbricos pre',
                           ln_cod1,
                           lv_resul);
              --Cambio de ciclo de facturacion
              operacion.pkg_cambio_ciclo_fact.sgasu_camb_ciclo_fact(ln_codsolot,
                                                                    p_cod,
                                                                    p_mensaje);
              p_log_3playi(ln_codsolot,
                           'operacion.pkg_cambio_ciclo_fact.sgasu_camb_ciclo_fact',
                           p_mensaje,
                           'Validación de Servicios Inalámbricos pre',
                           ln_cod1,
                           lv_resul);

            end if;

            --si nuestra error en cambio de ciclo: error -99
            if p_cod = -99 and ln_val_wimax_lte = 0 then
              sgasu_serv_x_cliente(ln_codsolot,
                                   'JN',
                                   p_mensaje,
                                   'ERRO',
                                   ln_cod1,
                                   lv_resul);
            else
              --fin 15.0
              p_log_3playi(ln_codsolot,
                           'p_provision_janus',
                           'INICIO',
                           'Validación de Servicios Inalámbricos pre',
                           ln_cod1,
                           lv_resul);

              p_provision_janus(ln_cod_id,
                                ln_custumer_id,
                                ln_tmcode,
                                ln_smcode,
                                'A',
                                p_cod,
                                p_mensaje);

              p_log_3playi(ln_codsolot,
                           'p_provision_janus',
                           p_mensaje,
                           'Validación de Servicios Inalámbricos pre',
                           ln_cod1,
                           lv_resul);

              if p_cod = 0 then
                sgasu_serv_x_cliente(ln_codsolot,
                                     'JN',
                                     null,
                                     'EPLA',
                                     ln_cod1,
                                     lv_resul);
              else
                sgasu_serv_x_cliente(ln_codsolot,
                                     'JN',
                                     p_mensaje,
                                     'ERRO',
                                     ln_cod1,
                                     lv_resul);
              end if;
            end if; --15.00
      else
        p_mensaje := 'No se realizó Cambio de Ciclo, estado CO_ID incorrecto';
        p_log_3playi(ln_codsolot,
                           'operacion.pkg_cambio_ciclo_fact.sgasu_camb_ciclo_fact',
                           p_mensaje,
                           'Validación de Servicios Inalámbricos pre',
                           ln_cod1,
                           lv_resul);
      end if;
      -- fin inc000002095333

      p_log_3playi(ln_codsolot,
                   'webservice.pq_datos_webservice.actualizar_contrato',
                   'INICIO',
                   'Validación de Servicios Inalámbricos pre',
                   ln_cod1,
                   lv_resul); -- 8.0

      webservice.pq_datos_webservice.actualizar_contrato(n_cod_id,
                                                         '2', -- Estado: Activo
                                                         '1', -- Razon: Activacion
                                                         lv_idtrs, -- Id. de Transaccion a devolver
                                                         ln_resp,
                                                         lv_mensaje);
      p_reg_cbscs_lte(ln_codsolot, lv_idtrs, ln_resp1, lv_mensaje1); --7.0

      p_log_3playi(ln_codsolot,
                   'webservice.pq_datos_webservice.actualizar_contrato',
                   lv_mensaje,
                   'Validación de Servicios Inalámbricos pre',
                   ln_cod1,
                   lv_resul); -- 8.0

      IF ln_resp <> 0 THEN
        raise_application_error(-20500, lv_mensaje);
      END IF;
      --ini lbando
      p_gen_change_cycle(n_cod_id, 'USRSGA', ln_cod2, lv_resul1);

      if ln_cod2 <> 0 then
        p_log_3playi(ln_codsolot,
                     'operacion.pq_3play_inalambrico.p_reg_cbscs_lte',
                     lv_resul1,
                     'Validación de Servicios Inalámbricos pre',
                     ln_cod2,
                     lv_resul1); -- 9.0
      end if;
      --fin lbando
    ELSE
      raise_application_error(-20500,
                              'La SOT no tiene asociado un Contrato en BSCS.');
    END IF;

  EXCEPTION
    when others then
      raise_application_error(-20001,
                              'Error al actualizar Contrato bscs : ' ||
                              sqlerrm);
  END;

  -------------------------------------------------------------------------------------------------------------------------------
  PROCEDURE p_validar_servicio_3playi(a_idtareawf in number,
                                      a_idwf      in number,
                                      a_tarea     in number,
                                      a_tareadef  in number) is
    ln_cod_id      number;
    ln_sot         number;
    ln_estsol      solot.estsol%type;
    ln_codinssrv   number;
    n_cont         number;
    ln_codnumtel   NUMBER;
    ln_request     NUMBER;
    lv_simcard     varchar2(25); -- 5.0
    lv_numtel      varchar2(20);
    ln_resp        NUMERIC := 0;
    lv_mensaje     VARCHAR2(3000);
    lv_idtrs       varchar2(30);
    ln_cod1        number;
    lv_resul       varchar2(4000);
    lv_estbscs     VARCHAR2(100); -- 8.0
    ln_tiempo      number; --8.0
    lv_status_prv  integer;
    lv_rpta        varchar2(1000);
    ln_estado_cnto integer; -- INC000000990787
    --Ini 21.0
    L_CONTRATO_ACTIVO INTEGER;
    L_NUMSEC          NUMBER(20);
    L_RESPUESTA       VARCHAR(100);
    --Fin 21.0
    -- Ini 24.0
     l_cod_id       VARCHAR2(50);
     l_customer_id  VARCHAR2(50);
     ln_resp_cci    NUMBER;
     lc_mensaje_cci  VARCHAR2(3000);
     ln_activa_cci  NUMBER;
    -- fin 24.0
    -- Ini 4.0
    cursor c_pid is
      select sp.pid from operacion.solotpto sp where sp.codsolot = ln_sot;
    -- Fin 4.0
    cursor c_inssrv is
      select i.codinssrv, i.tipsrv
        from operacion.inssrv i
       where i.codinssrv in (SELECT sp.codinssrv
                               FROM operacion.solotpto sp
                              where sp.codsolot = ln_sot);
    cursor c_equ_bscs is
      select a.nro_serie_deco,
             a.nro_serie_tarjeta,
             a.tipo_equipo,
             a.modelo_equipo
        from (select distinct asoc.nro_serie_deco,
                              asoc.nro_serie_tarjeta,
                              (select distinct nvl(crm.abreviacion, '')
                                 from sales.crmdd crm
                                where se.tipequ = to_number(crm.codigon)) tipo_equipo,
                              (select distinct nvl(crm.descripcion, '')
                                 from sales.crmdd crm
                                where se.tipequ = to_number(crm.codigon)) modelo_equipo
                from operacion.tarjeta_deco_asoc asoc,
                     operacion.solotptoequ       se,
                     operacion.tipequ            tieq
               where asoc.codsolot = se.codsolot
                 and se.mac = asoc.nro_serie_deco
                 and se.tipequ = to_number(tieq.tipequ)
                 and (se.tipequ) in
                     (select crm.codigon
                        from sales.crmdd crm
                       where crm.tipcrmdd in
                             (select TIP.TIPCRMDD
                                from SALES.TIPCRMDD TIP
                               where tip.abrev = 'DTHPOSTEQU'))
                 and asoc.codsolot = ln_sot) a;
    cursor c_solotpequ is
      select spe.numserie
        from operacion.solotptoequ spe
       where spe.codsolot = ln_sot
         and spe.numserie is not null;
    -- INI 11.0
    cursor c_solot(an_codsolot_baja number) is
      select c.idtareawf, c.mottarchg, c.idwf, c.tarea, c.tareadef
        from solot a, wf b, tareawf c
       where a.codsolot = b.codsolot
         and b.idwf = c.idwf
         and b.valido = 1
         and a.estsol = 17
         and c.esttarea = 1
         and a.codsolot = an_codsolot_baja
         and rownum = 1;

    ln_val_baj_wimax  number;
    ln_flag_wimax     number;
    ln_sot_baja_wimax number;

    ln_flag_act_fact_bscs number;
    ln_tipo_liberacion    number;
    ln_val_fact_wimax     number;
    ln_tiptra_new_wimax   number;
    cursor c_inssrv_baja(an_codsolot_baja number) is
      select i.codinssrv, i.numero
        from operacion.inssrv i
       where i.codinssrv in
             (SELECT sp.codinssrv
                FROM operacion.solotpto sp
               where sp.codsolot = an_codsolot_baja)
         and i.tipinssrv = 3;
  BEGIN

    SELECT s.codsolot,
           operacion.pq_sga_wimax_lte.f_val_cli_wimax(s.codcli),
           operacion.pq_sga_wimax_lte.f_obtiene_sot_cli_wimax(s.codcli),
           operacion.pq_sga_wimax_lte.f_obt_act_fact_sga_bscs(s.codsolot)
      INTO ln_sot, ln_flag_wimax, ln_sot_baja_wimax, ln_flag_act_fact_bscs
      FROM wf f, solot s
     WHERE f.codsolot = s.codsolot
       and f.valido = 1
       and idwf = a_idwf;

    SELECT count(1)
      INTO n_cont
      FROM operacion.inssrv i
     WHERE i.codinssrv in (SELECT sp.codinssrv
                             FROM operacion.solotpto sp
                            where sp.codsolot = ln_sot);
    -- FIN 11.0

    IF n_cont > 0 THEN
      select CASE
               WHEN (sysdate > FECFINSYS + (5 / (24 * 60))) THEN
                1
               ELSE
                0
             END
        INTO ln_tiempo
        from opewf.tareawf a
       where a.idwf = a_idwf
         and a.tareadef =
             (select TAREADEF b
                from opewf.tareawfcpy a
               where a.idwf = a_idwf
                 and descripcion = 'Activacion de Servicios Inalambricos');

      IF ln_tiempo = 0 THEN
        raise_application_error(-20500,
                                'Para cerrar la validación se requiere esperar por lo menos 5 minutos luego del cierre de la activación');
      END IF;

      SELECT a.cod_id, a.estsol
        into ln_cod_id, ln_estsol
        FROM operacion.solot a
       WHERE a.codsolot = ln_sot;

      /* Ini 8.0*/

      p_log_3playi(ln_sot,
                   'tim.pp021_venta_lte.F_ESTADO_CO_ID@dbl_bscs_bf',
                   'INICIO',
                   'Cierre de Validación de Servicios Inalámbricos Post',
                   ln_cod1,
                   lv_resul);

      lv_estbscs := tim.pp021_venta_lte.f_estado_co_id@dbl_bscs_bf(ln_cod_id);

      p_log_3playi(ln_sot,
                   'tim.pp021_venta_lte.F_ESTADO_CO_ID@dbl_bscs_bf',
                   lv_estbscs,
                   'Cierre de Validación de Servicios Inalámbricos Post',
                   ln_cod1,
                   lv_resul);

      IF lv_estbscs <> 'ax' and ln_flag_act_fact_bscs = 0 THEN
        raise_application_error(-20500,
                                'El estado del contrato no se encuentra en activo con pendiente : ' ||
                                lv_estbscs);
      END IF;

      if ln_flag_act_fact_bscs = 0 then
        -- Iniciar la Facturacion
        p_log_3playi(ln_sot,
                     'P_INICIA_FACT tim.pp021_venta_lte.sp_inicia_fact',
                     'INICIO',
                     'Cierre de Validación de Servicios Inalámbricos Post',
                     ln_cod1,
                     lv_resul);

        operacion.pq_3play_inalambrico.P_INICIA_FACT(ln_cod_id,
                                                     SYSDATE,
                                                     ln_resp,
                                                     lv_mensaje);

        p_log_3playi(ln_sot,
                     'P_INICIA_FACT tim.pp021_venta_lte.sp_inicia_fact',
                     lv_mensaje,
                     'Cierre de Validación de Servicios Inalámbricos Post',
                     ln_cod1,
                     lv_resul);

        -- Si hay un error en el Inicio de Facturacion
        IF ln_resp <> 0 THEN
          raise_application_error(-20500,
                                  'tim.pp021_venta_lte.sp_inicia_fact: ' ||
                                  lv_mensaje);
        END IF;
        /* Fin 8.0*/
        -- Validación de la provision de Cambio de Ciclo - LBando
        lv_status_prv := tim.pp021_venta_lte.fn_valida_provision@dbl_bscs_bf(ln_cod_id,
                                                                             13);
        p_log_3playi(ln_sot,
                     ' tim.tim_pp021_venta_lte.fn_valida_provision@dbl_bscs_bf',
                     'Consulta OK',
                     'Validación del estado de provisión del ciclo de facturación',
                     ln_cod1,
                     lv_resul);

        if lv_status_prv <> 7 then
          select case lv_status_prv
                   when 2 then
                    'La provisión de cambio de ciclo no fue iniciada.'
                   when 11 then
                    'La provision de cambio cuenta con un error.'
                   else
                    'La provisión no fue finalizada, cuenta con un estado igual a ' ||
                    lv_status_prv
                 end
            into lv_rpta
            from dual;

          p_log_3playi(ln_sot,
                       ' tim.tim_pp021_venta_lte.fn_valida_provision@dbl_bscs_bf',
                       'ERROR',
                       'Validación del estado de provisión del ciclo de facturación',
                       ln_cod1,
                       lv_rpta);
        end if;
        -- fin de validación

      else
        ln_tipo_liberacion := operacion.pq_anulacion_bscs.f_config_bscs('ANUL_SOT');

        operacion.pq_sga_bscs.p_anula_contrato_bscs_lte(ln_cod_id,
                                                        ln_tipo_liberacion,
                                                        ln_resp,
                                                        lv_mensaje);

        p_log_3playi(ln_sot,
                     'P_ANULA_CONTRATO_BSCS_LTE',
                     lv_mensaje,
                     'Cierre de Validación de Servicios Inalámbricos Post',
                     ln_cod1,
                     lv_resul);

      end if;
      -- Ini 4.0
      -- Actualizar Insprd de SGA
      for cx in c_pid loop
        update operacion.insprd set estinsprd = 1 where pid = cx.pid;
      end loop;
      -- Fin 4.0
      -- Actualizar Servicios de SGA

      if ln_flag_act_fact_bscs = 0 then
        for c1 in c_inssrv loop

          UPDATE operacion.inssrv
             SET estinssrv = 1
           where codinssrv = c1.codinssrv;
          if c1.tipsrv = '0062' then
            SELECT request
              INTO ln_request
              FROM OPERACION.OPE_SRV_RECARGA_DET
             WHERE tipsrv = '0062'
               AND numregistro = (select t.numregistro
                                    from OPERACION.OPE_SRV_RECARGA_CAB t
                                   where t.codsolot = ln_sot);
            -- Actualizar Request de TV
            p_log_3playi(ln_sot,
                         'p_upd_pend_req tim.pp021_venta_lte.sp_upd_pend_req',
                         'INICIO',
                         'Cierre de Validación de Servicios Inalámbricos Post',
                         ln_cod1,
                         lv_resul); -- 8.0

            p_upd_pend_req(ln_request,
                           '100',
                           0,
                           NULL,
                           NULL,
                           ln_resp,
                           lv_mensaje);

            p_log_3playi(ln_sot,
                         'p_upd_pend_req tim.pp021_venta_lte.sp_upd_pend_req',
                         lv_mensaje,
                         'Cierre de Validación de Servicios Inalámbricos Post',
                         ln_cod1,
                         lv_resul); -- 8.0

            -- Insertar Equipos a BSCS
            for c1 in c_equ_bscs loop
              p_log_3playi(ln_sot,
                           'p_registra_deco_lte tim.pp021_venta_lte.sp_registra_deco_lte',
                           'INICIO',
                           'Cierre de Validación de Servicios Inalámbricos Post',
                           ln_cod1,
                           lv_resul); -- 8.0

              p_registra_deco_lte(ln_cod_id,
                                  c1.nro_serie_deco,
                                  c1.nro_serie_tarjeta,
                                  c1.tipo_equipo,
                                  c1.modelo_equipo,
                                  ln_resp,
                                  lv_mensaje);

              p_log_3playi(ln_sot,
                           'p_registra_deco_lte tim.pp021_venta_lte.sp_registra_deco_lte',
                           lv_mensaje,
                           'Cierre de Validación de Servicios Inalámbricos Post',
                           ln_cod1,
                           lv_resul); -- 8.0

              IF ln_resp <> 0 THEN
                raise_application_error(-20500,
                                        'tim.pp021_venta_lte.sp_registra_deco_lte: ' ||
                                        lv_mensaje);
              END IF;
            end loop;
            IF ln_resp <> 0 THEN
              raise_application_error(-20500, lv_mensaje);
            END IF;
          end if;
          -- Ini 5.0
          if c1.tipsrv = '0004' then
            -- Actualizar Estados de Numeros Telefonicos
            select distinct n.numero, r.codnumtel, n.simcard
              INTO lv_numtel, ln_codnumtel, lv_simcard
              FROM telefonia.reservatel r, telefonia.numtel n
             WHERE r.codnumtel = n.codnumtel
               AND r.numslc = (SELECT sp.numslc
                                 FROM operacion.solot sp
                                where sp.codsolot = ln_sot);
            -- Actualizar estado de numero en Sans a Asignado
            p_log_3playi(ln_sot,
                         'webservice.PQ_DATOS_WEBSERVICE.cambiar_status_sans',
                         'INICIO',
                         'Cierre de Validación de Servicios Inalámbricos Post',
                         ln_cod1,
                         lv_resul); -- 8.0

            webservice.PQ_DATOS_WEBSERVICE.cambiar_status_sans(lpad(lv_numtel,
                                                                    15,
                                                                    '0'),
                                                               '016',
                                                               ln_resp,
                                                               lv_mensaje);

            p_log_3playi(ln_sot,
                         'webservice.PQ_DATOS_WEBSERVICE.cambiar_status_sans',
                         lv_mensaje,
                         'Cierre de Validación de Servicios Inalámbricos Post',
                         ln_cod1,
                         lv_resul); -- 8.0

            IF ln_resp <> 0 THEN
              raise_application_error(-20500,
                                      'webservice.PQ_DATOS_WEBSERVICE.cambiar_status_sans: ' ||
                                      lv_mensaje);
            END IF;
            -- Actualizacion de numtel
            UPDATE telefonia.numtel
               SET ESTNUMTEL = 2, codinssrv = c1.codinssrv -- 11.0
             where numero = lv_numtel;
            -- Actualizacion de reservatel
            UPDATE telefonia.reservatel
               SET ESTNUMTEL = 2
             where codnumtel = ln_codnumtel;
            -- Actualizacion de SimCard y numero en inssrv
            update operacion.inssrv
               set numero = lv_numtel, simcard = lv_simcard
             where codinssrv = c1.codinssrv;
          end if;
          -- Fin 5.0
        end loop;
      end if;

      -- Actualizar Los numeros de Serie de los Equipos
      for c1 in c_solotpequ loop
        update operacion.tabequipo_material tm
           set estado = 1
         where trim(tm.numero_serie) = trim(c1.numserie);
      end loop;
      -- Ini 7.0
      -- Verificando el Estado de SOT para cambiar a Atendido
      if ln_estsol <> 29 then
        -- 8.0
        operacion.pq_solot.p_chg_estado_solot(ln_sot, 29, ln_estsol, null);
      end if;
      -- Fin 7.0
      -- INI 11.0
      -- Atencion de la SOT de baja Wimax para baja la facturacion en el SGA
      ln_val_baj_wimax := operacion.pq_sga_bscs.f_get_obtiene_param_lte('LTE_WIMAX_MIGRA');

      if ln_val_baj_wimax = 1 and ln_flag_act_fact_bscs = 0 then
        if ln_flag_wimax != 0 and ln_sot_baja_wimax != 0 then

          FOR r_solot IN c_solot(ln_sot_baja_wimax) LOOP
            BEGIN
              operacion.pq_solot.p_activacion_automatica(r_solot.idtareawf,
                                                         r_solot.idwf,
                                                         r_solot.tarea,
                                                         r_solot.tareadef);
            end;
          end loop;
        end if;
      end if;
      -- FIN 11.0

      ln_val_fact_wimax := operacion.pq_sga_bscs.f_get_obtiene_param_lte('LTE_WIMAX_FACT_SGA');

      if ln_flag_act_fact_bscs = 1 and ln_val_fact_wimax = 1 then
        if ln_flag_wimax != 0 and ln_sot_baja_wimax != 0 then
          operacion.pq_solot.p_chg_estado_solot(ln_sot_baja_wimax,
                                                13,
                                                ln_estsol,
                                                'SOT Anulada por Migracion WIMAX-LTE, servicio Facturara en SGA');

          for c in c_inssrv_baja(ln_sot_baja_wimax) loop

            update numtel n set n.estnumtel = 2 where n.numero = c.numero;

          end loop;
        end if;

        -- Se obtiene el nuevo TIPTRA que se le va asignar a la SOT de LTE
        ln_tiptra_new_wimax := operacion.pq_sga_bscs.f_get_obtiene_param_lte('LTE_WIMAX_TIPTRA_NEW');

        update solot ss
           set ss.tiptra = ln_tiptra_new_wimax
         where ss.codsolot = ln_sot;

      end if;
      -- ini INC000000990787
      ln_estado_cnto := operacion.pq_sga_iw.f_val_status_contrato(ln_cod_id);
      if not (ln_estado_cnto = 4 or ln_estado_cnto = 5) then
        -- estado contrato <> desactivado
        update tim.lte_control_prov@DBL_BSCS_BF
           set status = 2
         where action_id = 13
           and co_id = ln_cod_id;
      end if;
      -- fin INC000000990787
      p_log_3playi(ln_sot,
                   'p_validar_servicio_3playi',
                   'OK',
                   'Cierre de Validación de Servicios Inalámbricos Post',
                   ln_cod1,
                   lv_resul); -- 8.0

      --Ini 21.0 Validamos contrato activo
      BEGIN
        SELECT CA1.CO_ID
          INTO L_CONTRATO_ACTIVO
          FROM CONTRACT_ALL@DBL_BSCS_BF     CA1,
               CONTRACT_HISTORY@DBL_BSCS_BF CH1,
               CUSTOMER_ALL@DBL_BSCS_BF     CC1
         WHERE CA1.CO_ID = CH1.CO_ID
           AND CA1.CUSTOMER_ID = CC1.CUSTOMER_ID
           AND CA1.TMCODE IN (1817)
           AND CH1.CH_SEQNO = (SELECT MAX(CH_SEQNO)
                                 FROM CONTRACT_HISTORY@DBL_BSCS_BF
                                WHERE CO_ID = CH1.CO_ID)
           AND CH1.CH_STATUS IN ('a')
           AND CH1.CH_PENDING IS NULL
           AND CA1.CO_ID = ln_cod_id;
      EXCEPTION
        WHEN OTHERS THEN
          L_RESPUESTA := 'Contrato : ' || ln_cod_id || ' no esta activo.';
          INSERT INTO TAREAWFSEG
            (IDTAREAWF, OBSERVACION)
          VALUES
            (A_IDTAREAWF, L_RESPUESTA);
          raise_application_error(-20001,
                                  'Error al validar servicio 3play inalámbrico  : No se encuentra contrato Activo');
      END;

      L_RESPUESTA := 'Activación completa del Contrato : ' || ln_cod_id || '.';

      INSERT INTO TAREAWFSEG
        (IDTAREAWF, OBSERVACION)
      VALUES
        (A_IDTAREAWF, L_NUMSEC || ': ' || L_RESPUESTA);
      --Fin 21.0

      -- ini 24.0
    select t.codigon
      into ln_activa_cci
      from opedd t
     where t.tipopedd =
           (select t.tipopedd from tipopedd t where t.abrev = 'PAR_VAL_CCI')
       and t.abreviacion = 'FLAG_CCI'
       AND t.codigon_aux = 1;

    if ln_activa_cci = 1 then
      BEGIN

        SALES.PKG_VALIDACION_CCI.SGASP_VALIDACCION_CCI(ln_sot,
                                                       ln_resp_cci,
                                                       lc_mensaje_cci);

        if lc_mensaje_cci is not null then
          ln_resp_cci := TRIM(SALES.PKG_VALIDACION_CCI.SGAFUN_ATRIBUTO_XML(lc_mensaje_cci,
                                                                               'codRespuesta'));

          lc_mensaje_cci := TRIM(SALES.PKG_VALIDACION_CCI.SGAFUN_ATRIBUTO_XML(lc_mensaje_cci,
                                                                                  'msjRespuesta'));
          if ln_resp_cci <> 0 then
              l_cod_id := SALES.PKG_VALIDACION_CCI.SGAFUN_GET_DATOS_SOT(ln_sot,'CODID');
              l_customer_id := SALES.PKG_VALIDACION_CCI.SGAFUN_GET_DATOS_SOT(ln_sot,'CUSTOMERID');

              lc_mensaje_cci:= 'VALIDACION_CCI, ERROR : '||lc_mensaje_cci;

              insert into HISTORICO.SGAT_REGVALCCI(codsolot, codid, customerid, observacion, reintentos )
              values(ln_sot, l_cod_id, l_customer_id, lc_mensaje_cci, 1);
              commit;

          end if;

        end if;
      EXCEPTION
        WHEN OTHERS THEN
           lc_mensaje_cci := 'VALIDACION_CCI, ERROR : ' || sqlcode || ' ' || sqlerrm;

           insert into HISTORICO.SGAT_REGVALCCI(codsolot, observacion, reintentos )
           values(ln_sot, lc_mensaje_cci, 1);

           commit;

      END;
    end if;
      -- fin 24.0

      -- ini 23.0
      begin
        operacion.pq_3play_inalambrico.sgai_carga_resumen_equ(ln_sot, ln_cod1, lv_resul);
      exception
        when others then
          null;
      end;
      -- fin 23.0
    ELSE
      raise_application_error(-20001,
                              'Error al validar servicio 3play inalámbrico  : Se debe de tener Servicios Asociados');
    END IF;

  EXCEPTION
    --INICIO 25.0
    when too_many_rows then
      lv_mensaje := sqlcode || ' -- ' || sqlerrm;
      p_log_3playi(ln_sot,
                   'p_validar_servicio_3playi',
                   lv_mensaje,
                   'Cierre de Validación de Servicios Inalámbricos Post',
                   ln_cod1,
                   lv_resul);
      raise_application_error(-20500, 'La SOT ' || ln_sot || ' tiene asociado mas de una Reserva de Telefonia');
    --FIN 25.0

    when others then
      lv_mensaje := sqlerrm;
      p_log_3playi(ln_sot,
                   'p_validar_servicio_3playi',
                   lv_mensaje,
                   'Cierre de Validación de Servicios Inalámbricos Post',
                   ln_cod1,
                   lv_resul); -- 8.0
      raise_application_error(-20001,
                              'Error al validar servicio 3play inalámbrico : ' ||
                              sqlerrm);
  END;

  -------------------------------------------------------------------------------------------------------------------------------
  PROCEDURE p_upd_pend_req(p_request    IN NUMBER,
                           p_estado     IN VARCHAR2,
                           p_errcode    IN INTEGER,
                           p_errmsg     IN VARCHAR2,
                           p_nrorequest IN NUMBER,
                           p_resul      OUT NUMBER,
                           p_mensaje    OUT VARCHAR2) is
  BEGIN
    tim.pp021_venta_lte.sp_upd_pend_req@DBL_BSCS_BF(p_request,
                                                    p_estado,
                                                    p_errcode,
                                                    p_errmsg,

                                                    p_nrorequest,
                                                    p_resul,
                                                    p_mensaje);
  EXCEPTION
    when others then
      raise_application_error(-20001,
                              'Error en p_upd_pend_req  : ' || sqlerrm);
  END;

  -------------------------------------------------------------------------------------------------------------------------------
  PROCEDURE p_anula_sot_lte(p_codsolot in number, p_resul out varchar2) IS
    n_cont     number;
    lv_numero  varchar2(20);
    n_cod_id   number;
    ln_resp    NUMERIC := 0;
    lv_mensaje VARCHAR2(3000);
  BEGIN
    SELECT count(i.codinssrv)
      INTO n_cont
      FROM operacion.inssrv i
     WHERE i.tipsrv = '0062'
       AND i.codinssrv in (SELECT sp.codinssrv
                             FROM operacion.solotpto sp
                            where sp.codsolot = p_codsolot);

    IF n_cont > 0 THEN
      P_CONAX_BAJA_DS(p_codsolot, lv_mensaje);
      IF lv_mensaje <> 'OK' THEN
        raise_application_error(-20500, lv_mensaje);
      END IF;

      UPDATE operacion.inssrv
         SET ESTINSSRV = 3
       WHERE tipsrv = '0062'
         AND codinssrv in (SELECT sp.codinssrv
                             FROM operacion.solotpto sp
                            where sp.codsolot = p_codsolot);
    END IF;

    SELECT count(i.codinssrv)
      INTO n_cont
      FROM operacion.inssrv i
     WHERE i.tipsrv in ('0004', '0006')
       AND i.codinssrv in (SELECT sp.codinssrv
                             FROM operacion.solotpto sp
                            where sp.codsolot = p_codsolot);

    IF n_cont > 0 THEN
      SELECT s.cod_id
        INTO n_cod_id
        FROM operacion.solot s
       where s.codsolot = p_codsolot;

      TIM.PP021_VENTA_LTE.SP_CORTE_TOTAL_LTE@DBL_BSCS_BF(n_cod_id,
                                                         'SUSP_APC',
                                                         NULL,
                                                         USER,
                                                         ln_resp,
                                                         lv_mensaje);
      IF lv_mensaje <> '0' THEN
        raise_application_error(-20500, lv_mensaje);
      END IF;
      SELECT count(i.codinssrv)
        INTO n_cont
        FROM operacion.inssrv i
       WHERE i.tipsrv in ('0004')
         AND i.codinssrv in
             (SELECT sp.codinssrv
                FROM operacion.solotpto sp
               where sp.codsolot = p_codsolot);
      if n_cont > 0 then
        -- Consultar Numero telefonico
        SELECT i.numero
          INTO lv_numero
          FROM operacion.inssrv i
         WHERE i.tipsrv in ('0004')
           AND i.codinssrv in
               (SELECT sp.codinssrv
                  FROM operacion.solotpto sp
                 where sp.codsolot = p_codsolot);
        -- Actualizar estado de numero en Sans a Asignado
        webservice.PQ_DATOS_WEBSERVICE.cambiar_status_sans(lpad(lv_numero,
                                                                15,
                                                                '0'),
                                                           '006',
                                                           ln_resp,
                                                           lv_mensaje);
        IF ln_resp <> 0 THEN
          raise_application_error(-20500, lv_mensaje);
        END IF;
      end if;
      UPDATE operacion.inssrv
         SET ESTINSSRV = 3
       WHERE tipsrv in ('0004', '0006')
         AND codinssrv in (SELECT sp.codinssrv
                             FROM operacion.solotpto sp
                            where sp.codsolot = p_codsolot);
    END IF;
  EXCEPTION
    when others then
      raise_application_error(-20001,
                              'Error en P_ANULA_SOT_LTE : ' || sqlerrm);
  END;

  -------------------------------------------------------------------------------------------------------------------------------
  PROCEDURE p_nrotelefonico_lte(p_numtel    in varchar2,
                                p_numserie  in varchar2,
                                p_codinssrv in number,
                                p_codcli    in varchar2,
                                p_resul     OUT NUMBER,
                                p_mensaje   OUT varchar2) IS
    ln_codnumtel  number;
    ln_val_num    number;
    ln_val_num1   number;
    ln_contar     number; --5.0
    ln_estnumtel  telefonia.numtel.estnumtel%type; -- 3.0
    ln_resp       number := 0;
    lv_mensaje    VARCHAR2(3000);
    ln_flag_wimax number; --11.0
  BEGIN
    ln_contar := 0; --5.0
    -- ini 3.0
    select count(1)
      into ln_val_num
      from telefonia.numtel nt
     where nt.numero = p_numtel;

    -- ini 11.0
    ln_flag_wimax := operacion.pq_sga_wimax_lte.f_val_cli_wimax(p_codcli);

    if ln_flag_wimax > 0 then
      if ln_val_num = 0 then
        p_insert_numtel(p_numtel,
                        p_numserie,
                        null,
                        6,
                        1,
                        ln_codnumtel,
                        ln_resp,
                        lv_mensaje);
        if ln_resp <> 0 then
          raise_application_error(-20500, lv_mensaje);
        end if;
      else
        --<13.0 Ini>
        select nt.codnumtel
          into ln_codnumtel
          from telefonia.numtel nt
         where nt.numero = p_numtel;
        --<13.0 Fin>
        -- Cambiamos el numero a estado reserva sistemas
        update telefonia.numtel nt
           set nt.estnumtel = 6, nt.simcard = p_numserie
         where nt.Numero = p_numtel;
      end if;

      -- Validar que no exista en Reservatel para mismo cliente y proyecto de la SOT
      select count(1)
        into ln_val_num
        from telefonia.numtel nt, telefonia.reservatel rt
       where nt.codnumtel = rt.codnumtel
         and nt.numero = p_numtel
         and rt.numslc in (select i.numslc
                             from operacion.insprd i
                            where i.codinssrv = p_codinssrv
                              and i.flgprinc = 1);

      if ln_val_num > 0 then
        p_update_rsv_numtel(ln_codnumtel,
                            p_codinssrv,
                            0,
                            6,
                            p_codcli,
                            ln_resp,
                            lv_mensaje);
      else
        p_insert_rsv_numtel(ln_codnumtel,
                            p_codinssrv,
                            0,
                            6,
                            p_codcli,
                            ln_resp,
                            lv_mensaje);
      end if;
    else
      -- Fin 11.0

      select count(1)
        into ln_val_num1
        from telefonia.numtel nt
       where nt.codinssrv = p_codinssrv
         and nt.estnumtel in (1, 6); --7.0

      --valida existencia en Numtel
      IF ln_val_num1 = 1 THEN
        --4.0  -- 7.0
        /*       select nt.estnumtel
        into ln_estnumtel
        from telefonia.numtel nt
        where nt.numero = p_numtel;*/
        -- ini 5.0

        select count(s.codsolot)
          into ln_contar
          from operacion.solot       s,
               operacion.solotptoequ se,
               operacion.inssrv      i
         where s.codsolot = se.codsolot
           and s.numslc = i.numslc
           and i.codinssrv = p_codinssrv
           and se.mac = (select nt.numero
                           from telefonia.numtel nt
                          where nt.numero = p_numtel
                            and nt.estnumtel = 6);
        -- fin 5.0
        --valida estado del número, solo
        -- if ln_estnumtel = 1 then
        -- Ini 4.0
        --Consultar Codnumtel para insertar a Reservatel

        IF ln_val_num = 1 THEN
          select codnumtel
            into ln_codnumtel
            from telefonia.numtel t
           where t.numero = p_numtel;
        ELSE
          select codnumtel
            into ln_codnumtel
            from telefonia.numtel t
           where t.codinssrv = p_codinssrv;
        END IF;
        -- Fin 4.0
        --actualiza en Numtel
        p_update_numtel( --p_numtel,--4.0
                        p_numserie,
                        p_codinssrv,
                        6,
                        1,
                        ln_codnumtel, --4.0
                        ln_resp,
                        lv_mensaje);
        IF ln_resp <> 0 THEN
          raise_application_error(-20500, lv_mensaje);
        END IF;
        --else
        --Si se encuentra el número en NUMTEL y no está en la SOT como reservado me da error
        /*  IF ln_contar = 0 THEN -- 5.0
        ln_resp    := -1;
        lv_mensaje := 'El numero ya se encuentra registrado';
        raise_application_error(-20500, lv_mensaje);
        END IF; */ -- 5.0
        --end if;

      else
        IF ln_val_num = 0 THEN
          --inserta en Numtel
          p_insert_numtel(p_numtel,
                          p_numserie,
                          p_codinssrv,
                          6,
                          1,
                          ln_codnumtel,
                          ln_resp,
                          lv_mensaje);
          IF ln_resp <> 0 THEN
            raise_application_error(-20500, lv_mensaje);
          END IF;
        ELSE
          -- Ini 7.0
          select nt.estnumtel
            into ln_estnumtel
            from telefonia.numtel nt
           where nt.numero = p_numtel;

          IF ln_estnumtel = 1 OR ln_estnumtel = 2 OR ln_estnumtel = 6 THEN
            --17.0
            select codnumtel
              into ln_codnumtel
              from telefonia.numtel t
             where t.numero = p_numtel;

            p_update_numtel(p_numserie,
                            p_codinssrv,
                            6,
                            1,
                            ln_codnumtel,
                            ln_resp,
                            lv_mensaje);

            IF ln_resp <> 0 THEN
              raise_application_error(-20500, lv_mensaje);
            END IF;
            -- Ini 7.0
          ELSE
            ln_resp    := -1;
            lv_mensaje := 'El numero ya se encuentra registrado';
            raise_application_error(-20500, lv_mensaje);
          END IF;
        END IF;
      end if;
      -- Validar que no exista en Reservatel
      select count(1)
        into ln_val_num
        from telefonia.numtel nt, telefonia.reservatel rt
       where nt.codnumtel = rt.codnumtel
         and nt.numero = p_numtel;
      if ln_val_num > 0 then
        p_update_rsv_numtel(ln_codnumtel,
                            p_codinssrv,
                            0,
                            6,
                            p_codcli,
                            ln_resp,
                            lv_mensaje);
      else
        p_insert_rsv_numtel(ln_codnumtel,
                            p_codinssrv,
                            0,
                            6,
                            p_codcli,
                            ln_resp,
                            lv_mensaje);
      end if;
      IF ln_resp <> 0 THEN
        raise_application_error(-20500, lv_mensaje);
      END IF;
    END IF; -- 11.0
    -- fin 3.0
    -- Cambia estado en Sans
    webservice.PQ_DATOS_WEBSERVICE.cambiar_status_sans(lpad(p_numtel,
                                                            15,
                                                            0),
                                                       '011',
                                                       ln_resp,
                                                       lv_mensaje);
    IF ln_resp <> 0 THEN
      raise_application_error(-20500, lv_mensaje);
    END IF;

  EXCEPTION
    when others then
      raise_application_error(-20001,
                              'Error en P_NROTELEFONICO_LTE : ' || sqlerrm);
  END;

  -------------------------------------------------------------------------------------------------------------------------------
  procedure p_consulta_nro_tlf(p_numserie    in varchar2,
                               p_codsolot    in number,
                               p_nro_tlf     out varchar2,
                               p_cod_mensaje out number,
                               p_mensaje     out varchar2) is
    lv_codubi varchar2(10);
    lv_cdln   varchar2(10);
  begin
    -- Consultar Numero telefonico en Sans
    webservice.PQ_DATOS_WEBSERVICE.numero_telefonico_sans(p_numserie,
                                                          p_nro_tlf,
                                                          p_cod_mensaje,
                                                          p_mensaje);
    if p_cod_mensaje < 0 then
      return;
    end if;

    if p_nro_tlf = '0' then
      p_cod_mensaje := '-96';
      p_mensaje     := 'No se encontro numero telefonico';
      return;
    end if;
    -- Validar numero telefonico en base a la ubicacion del Cliente
    -- Consultar Ubicacion del cliente
    begin
      select s.codubi
        into lv_codubi
        from operacion.solot s
       where s.codsolot = p_codsolot;
    exception
      when NO_DATA_FOUND then
        p_cod_mensaje := '-97';
        p_mensaje     := 'No se encontro la Ubicacion del cliente';
        return;
    end;
    -- Consultar Codigo de Larga Distancia Nacional
    begin
      select cdln.codigoc
        into lv_cdln
        from marketing.vtatabdst vtd,
             (select o.codigoc, o.codigon
                from operacion.opedd o
               where o.tipopedd = (select tp.tipopedd
                                     from operacion.tipopedd tp
                                    where tp.abrev = 'CLDN')) cdln
       where vtd.codubi = lv_codubi
         and trim(vtd.codpai) = '51'
         and to_number(trim(vtd.codest)) = cdln.codigon;
    exception
      when NO_DATA_FOUND then
        p_cod_mensaje := '-98';
        p_mensaje     := 'No se encontro el Codigo de Larga Distancia Nacional';
        return;
    end;

    if lpad(p_nro_tlf, length(lv_cdln)) <> lv_cdln then
      p_cod_mensaje := '-99';
      p_mensaje     := 'El SimCard tiene un Codigo diferente a la Ubicacion del Cliente';
      return;
    end if;
  EXCEPTION
    when others then
      raise_application_error(-20002,
                              'Error en Consultar Numero Telefonico : ' ||
                              sqlerrm);
  end;

  -------------------------------------------------------------------------------------------------------------------------------
  procedure p_borrar_ope_envio_conax(p_codsolot in number,
                                     p_tipo     in number) is
    pragma autonomous_transaction;
  BEGIN
    DELETE FROM operacion.ope_envio_conax
     WHERE codsolot = p_codsolot
       AND tipo = p_tipo;
    COMMIT;
  EXCEPTION
    when others then
      raise_application_error(-20002,
                              'Error en p_borrar_ope_envio_conax : ' ||
                              sqlerrm);
  END;

  procedure p_act_reg_sisact_lte(an_numslc       solot.numslc%type,
                                 an_codsolot     in number,
                                 an_estsol       solot.estsol%type,
                                 a_idtareawf     in number,
                                 ac_num_serie_t  in varchar2,
                                 ac_num_serie_d  in varchar2,
                                 an_resp         out number,
                                 ac_mensaje      out varchar2,
                                 ac_nro_contrato out varchar2) is
    ln_numsec          varchar2(20);
    C_TARJETA          T_CURSOR;
    lv_tarjetas        varchar2(1000);
    lv_tarjet          varchar2(1000);
    lv_deco            varchar2(1000);
    lc_bouquets        varchar2(1000);
    ln_cod_contratista contrata.codcon%type;
    lc_contratista     contrata.nombre%type;
    ln_estsol          estsol.estsol%type;
    lc_descripcion     tipestsol.descripcion%type;
    ln_estado          number;
    lv_nombre          varchar2(30);
    lv_rpc             varchar2(15);
    lv_numdoc          varchar2(30);
    ln_id_sisat        number;
    ln_resul_inst      number;
    lc_msj_result      varchar2(30);
    lc_envio           varchar2(1000);
    ls_nro_contrato    varchar2(500);
    lv_resp_actDTH     varchar2(500);
    ln_valida_reg      number;
    lc_mensajen        varchar2(1000);
    ln_id_sisact       number;
    lv_serie_deco      varchar2(1000);
    lv_serie_tarjeta   varchar2(1000);
    ln_valida          number;

    cursor cur_env(a_codsolot solot.codsolot%type) is
      select (a.nro_serie_deco || ',' || a.nro_serie_tarjeta || ',' ||
             a.tipo_equipo) trama,
             a.nro_serie_deco,
             a.nro_serie_tarjeta
        from (select distinct asoc.nro_serie_deco,
                              asoc.nro_serie_tarjeta,
                              (select distinct nvl(crm.abreviacion, '')
                                 from sales.crmdd crm
                                where se.tipequ = to_number(crm.codigon)) tipo_equipo
                from operacion.tarjeta_deco_asoc asoc,
                     solotptoequ                 se,
                     tipequ                      tieq
               where asoc.codsolot = se.codsolot
                 and se.mac = asoc.nro_serie_deco
                 and se.tipequ = to_number(tieq.tipequ)
                 and (se.tipequ) in
                     (select crm.codigon
                        from sales.crmdd crm
                       where crm.tipcrmdd in
                             (select TIP.TIPCRMDD
                                from SALES.TIPCRMDD TIP
                               where tip.abrev = 'DTHPOSTEQU'))
                 and asoc.codsolot = an_codsolot) a;

    cursor cur_tarj(a_numslc vtatabslcfac.numslc%type) IS
      select t.codigo_ext
        from vtadetptoenl v, tystabsrv t
       where v.numslc = a_numslc
         and v.codsrv = t.codsrv
         and t.codigo_ext is not null;

  BEGIN
    --Numero de Secuencia de SISACT
    begin
      select distinct i.numsec
        into ln_numsec
        from inssrv i
       where i.numslc = an_numslc;
    exception
      when no_data_found then
        an_resp    := -99;
        ac_mensaje := 'No se encontro el Numero de Secuencia para el proyecto' ||
                      ln_numsec;
        return;
    end;

    --Lista de Bouquets
    lc_bouquets := null;
    for lt1 in cur_tarj(an_numslc) loop
      begin
        if lc_bouquets is null then
          lc_bouquets := lt1.codigo_ext;
        else
          lc_bouquets := lc_bouquets || ',' || lt1.codigo_ext;
        end if;

      exception
        when no_data_found then
          an_resp    := -99;
          ac_mensaje := 'No se encontro el Bouquets asociados al proyecto' ||
                        ln_numsec;
          return;
      end;
    end loop;

    -- Nombre del Contratista
    begin
      select c.codcon, c.nombre
        into ln_cod_contratista, lc_contratista
        from agendamiento a, contrata c
       where a.codsolot = an_codsolot
         and a.codcon = c.codcon(+);
    exception
      when no_data_found then
        an_resp    := -99;
        ac_mensaje := 'No se encontro Contratista asociados al proyecto' ||
                      ln_numsec;
        return;
    end;
    -- Lista de tarjetas
    lv_tarjetas := null;
    begin

      select count(*)
        into ln_valida
        from operacion.tarjeta_deco_asoc asoc, solotptoequ se, tipequ tieq
       where asoc.codsolot = se.codsolot
         and se.mac = asoc.nro_serie_deco
         and se.tipequ = to_number(tieq.tipequ)
         and (se.tipequ) in
             (select crm.codigon
                from sales.crmdd crm
               where crm.tipcrmdd in
                     (select TIP.TIPCRMDD
                        from SALES.TIPCRMDD TIP
                       where tip.abrev = 'DTHPOSTEQU'))
         and asoc.codsolot = an_codsolot;
      if ln_valida = 0 then
        an_resp    := -99;
        ac_mensaje := 'Requiere asociar los equipos';
        RETURN;
      end if;

      for lc1 in cur_env(an_codsolot) loop
        if lv_tarjetas is null then
          lv_tarjetas      := lc1.trama;
          lv_serie_deco    := lc1.nro_serie_deco;
          lv_serie_tarjeta := lc1.nro_serie_tarjeta;
        else
          lv_tarjetas      := lv_tarjetas || ';' || lc1.trama;
          lv_serie_deco    := lv_serie_deco || ',' || lc1.nro_serie_deco;
          lv_serie_tarjeta := lv_serie_tarjeta || ',' ||
                              lc1.nro_serie_tarjeta;
        end if;

      end loop;

    exception
      when too_many_rows then
        an_resp    := -99;
        ac_mensaje := 'Se encontraron mas valores de lo esperado' ||
                      ln_numsec;
        return;
      when no_data_found then
        an_resp    := -99;
        ac_mensaje := 'No se encontro Tarjetas/Series asociados al proyecto' ||
                      ln_numsec;
        return;
    end;
    -- Nombre del instalador
    begin
      sales.pq_dth_postventa.p_con_instalador(an_codsolot,
                                              a_idtareawf,
                                              ln_estado,
                                              lv_nombre,
                                              lv_rpc,
                                              lv_numdoc);
    exception
      when no_data_found then
        an_resp    := -99;
        ac_mensaje := 'No se encontro Tarjetas/Series asociados al proyecto' ||
                      ln_numsec;
        return;
    end;
    -- Estado de la Instalacion
    begin
      select count(e.estsol), t.descripcion
        into ln_estsol, lc_descripcion
        from estsol e, tipestsol t
       where e.tipestsol = t.tipestsol
         and e.estsol = an_estsol
         and t.tipestsol in (5, 7)
       group by t.descripcion;

      if ln_estsol is null then
        ln_estsol := 0;
      end if;

      If ln_estsol > 0 then
        ln_resul_inst := ln_estsol;
        lc_msj_result := lc_descripcion;
      else
        ln_resul_inst := 0;
        lc_msj_result := '';
      end if;
    exception
      when no_data_found then
        ln_resul_inst := 0;
        lc_msj_result := '';
        null;
    end;

    begin

      INSERT INTO operacion.ope_srv_reginst_sisact
        (numsec,
         codsolot,
         fecregistro,
         bouquets,
         usuario,
         codcon,
         contratista,
         instalador,
         estsol,
         estado_sot,
         tarjeta_serie,
         deco_serie)
      VALUES
        (ln_numsec,
         an_codsolot,
         SYSDATE,
         lc_bouquets,
         USER,
         ln_cod_contratista,
         lc_contratista,
         lv_nombre,
         ln_resul_inst,
         lc_msj_result,
         lv_serie_tarjeta,
         lv_serie_deco)
      returning ID_SISACT into ln_id_sisat;
    exception
      WHEN OTHERS THEN
        an_resp    := -99;
        ac_mensaje := 'ERROR AL INSERTAR REGISTRO REGINST';
        RETURN;
    end;
    --Validar registro SISACT
    select count(1)
      into ln_valida_reg
      from ope_srv_recarga_cab
     where (flg_envio_sisact is null or flg_envio_sisact <> 0)
       and codsolot = an_codsolot
       and numslc = an_numslc;

    if ln_valida_reg = 1 then
      /**************************************/
      --Envio del procedimiento registro de Instalacion SISACT
      /**************************************/
      BEGIN
        UPDATE OPE_SRV_RECARGA_CAB O
           SET O.FLG_ENVIO_SISACT = 1,
               nro_contrato       = ls_nro_contrato,
               id_sisact          = ln_id_sisat
         WHERE O.NUMSLC = an_numslc;
      exception
        when no_data_found then
          an_resp    := -99;
          ac_mensaje := 'No se Realizo el registro de Instalacion en SISACT ' ||
                        ln_numsec;
      end;
    end if;
  end;

  procedure p_act_tareawfseg(p_idtareawf in number, p_mensaje in varchar2) is
    pragma autonomous_transaction;
  begin
    insert into tareawfseg
      (idtareawf, observacion)
    values
      (p_idtareawf, p_mensaje);
    commit;
  end;
  procedure p_cons_serv_lte_bscs(a_codsolot  in number,
                                 o_resultado out T_CURSOR) is
    V_CURSOR T_CURSOR;
    ln_co_id number;
  begin
    begin
      select s.cod_id
        into ln_co_id
        from operacion.solot s
       where s.codsolot = a_codsolot;
    exception
      when no_data_found then
        ln_co_id := 0;
    end;
    OPEN V_CURSOR FOR
      select distinct lic.customer_id,
                      lic.co_id,
                      mp.des,
                      licl.cod_plan,
                      pss.status,
                      ca.billcycle
        from tim.lte_info_comercial@DBL_BSCS_BF licl,
             tim.lte_info_com_det@DBL_BSCS_BF   lic,
             mpusntab@DBL_BSCS_BF               mp,
             pr_serv_status_hist@DBL_BSCS_BF    pss,
             sysadm.customer_all@DBL_BSCS_BF    ca
       where licl.co_id = lic.co_id
         and lic.sncode = mp.sncode
         and pss.co_id = lic.co_id
         and ca.customer_id = licl.customer_id
         and pss.request_id = (select max(request_id)
                                 from pr_serv_status_hist@DBL_BSCS_BF
                                where co_id = lic.co_id)
         and lic.co_id = ln_co_id;
    o_resultado := V_CURSOR;
  end;

  procedure p_cons_equ_lte_bscs(a_codsolot  in number,
                                o_resultado out T_CURSOR) is
    V_CURSOR T_CURSOR;
    ln_co_id number;
  begin
    begin
      select s.cod_id
        into ln_co_id
        from operacion.solot s
       where s.codsolot = a_codsolot;
    exception
      when no_data_found then
        ln_co_id := 0;
    end;
    OPEN V_CURSOR FOR
      select distinct lic.customer_id,
                      lic.co_id,
                      lic.producto,
                      (select t.descripcion
                         from operacion.tipequ t
                        where t.tipequ = to_number(lic.tipo_equipo))
        from tim.lte_info_comercial@DBL_BSCS_BF licl,
             tim.lte_info_com_det@DBL_BSCS_BF   lic
       where licl.co_id = lic.co_id
         and lic.co_id = ln_co_id;
    o_resultado := V_CURSOR;
  end;

  procedure p_ins_envioconax(an_codsolot    in number,
                             an_codinssrv   in number,
                             an_tipo        in number,
                             ac_serie       in char,
                             ac_unitaddress in char,
                             ac_bouquet     in char,
                             an_numtrans    in number,
                             an_codigo      in number,
                             an_cod         out number,
                             ac_mensaje     out varchar2) is
    lc_numregistro  varchar2(10);
    lc_numslc       varchar2(10);
    lc_codsrv       char(4);
    ln_codinssrv    number;
    ln_codsolot_max solot.codsolot%type; --22.0
    ln_cod_id       solot.cod_id%type; --22.0
  begin
    an_cod     := 0;
    ac_mensaje := 'Exito';

    --Ini 22.0
    select s.cod_id
      into ln_cod_id
      from solot s
     where s.codsolot = an_codsolot;

    ln_codsolot_max := operacion.pq_sga_iw.f_max_sot_x_cod_id(ln_cod_id);

    if ln_codsolot_max = 0 then
      ln_codsolot_max := an_codsolot;
    end if;
    --Fin 22.0
    begin
      -- OBTENER CODINSSRV
      ln_codinssrv := an_codinssrv;
      --Registro de DTH en nueva estructura de multiples servicios recargables
      select r.numregistro
        into lc_numregistro
        from ope_srv_recarga_cab r, ope_srv_recarga_det i
       where r.numregistro = i.numregistro
         and i.codinssrv = ln_codinssrv
         and r.codsolot = ln_codsolot_max --22.0
         and r.estado not in (4); --diferente de cancelado

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
        an_cod     := -1;
        ac_mensaje := 'Error: ' || sqlerrm;
    end;
  end;

  PROCEDURE p_provision_lte(p_codsolot       IN NUMBER,
                            p_idtareawf      IN NUMBER,
                            p_co_id          IN NUMBER,
                            p_tipo_operacion in varchar2, --14.00
                            p_cod            OUT NUMBER,
                            p_mensaje        OUT VARCHAR2) is
    ln_val_ns        number;
    ln_val_tlf_int   number;
    ln_val_cable     number;
    lv_tip_equ       varchar2(50);
    lv_mdl_equ       varchar2(50);
    lv_msisdn        varchar2(15);
    lv_iccid         varchar2(20);
    ln_request_tv    number;
    ln_request_padre number;
    ln_cod1          number;
    lv_resul         varchar2(4000);
    -- INI 11.0
    ln_val_wimax_lte number;
    lv_codcli        solot.codcli%type;
    ln_codsolot_wix  solot.codsolot%type;
    -- FIN 11.0
    ln_deco_adicional NUMBER; --12.0
    ln_tmcode         NUMBER; --14.0
    ln_smcode         NUMBER; --14.0
    ln_cod_id         NUMBER; --14.0
    ln_custumer_id    NUMBER; --14.0
    ln_log_id         NUMBER; --14.0

    ln_prueba number;

    ln_cant_dig_chip number;
    -- ini 26.0
    N_VALIDA         INTEGER := 0;  
    -- fin 26.0

  begin

    ln_cant_dig_chip := OPERACION.PQ_SGA_JANUS.F_GET_CONSTANTE_CONF('CANDIGCHIPLTE');

    if ln_cant_dig_chip = -10 then
      ln_cant_dig_chip := 19; -- Solo por contingencia
    end if;

    -- Validando si se ingresaron Numeros de Series
    select count(1)
      into ln_val_ns
      from solotptoequ se,
           solot s,
           solotpto sp,
           inssrv i,
           tipequ t,
           almtabmat a,
           (select a.codigon tipequ, codigoc grupo
              from opedd a, tipopedd b
             where a.tipopedd = b.tipopedd
               and b.abrev = 'TIPEQU_LTE_TLF') equ_conax
     where se.codsolot = s.codsolot
       and s.codsolot = sp.codsolot
       and se.punto = sp.punto
       and sp.codinssrv = i.codinssrv
       and t.tipequ = se.tipequ
       and a.codmat = t.codtipequ
       and se.codsolot = p_codsolot
       and trim(se.numserie) is null
       and t.tipequ = equ_conax.tipequ;
    if ln_val_ns > 0 then
      p_cod     := -97;
      p_mensaje := 'Hay equipos que le falta asignar Numero de Serie LTE - TLF, no se pudo provisionar los servicios'; --15.00
      sgasu_serv_x_cliente(p_codsolot,
                           'TP',
                           p_mensaje,
                           'ERRO',
                           ln_cod1,
                           lv_resul); --14.00
      return;
    end if;

    --ini 14.00
    -- Validando si se ingresaron Numeros de Series para DTH
    select count(1)
      into ln_val_ns
      from solotptoequ se,
           solot s,
           solotpto sp,
           inssrv i,
           tipequ t,
           almtabmat a,
           (select a.codigon tipequ, codigoc grupo
              from opedd a, tipopedd b
             where a.tipopedd = b.tipopedd
               and b.abrev = 'TIPEQU_DTH_CONAX') equ_conax
     where se.codsolot = s.codsolot
       and s.codsolot = sp.codsolot
       and se.punto = sp.punto
       and sp.codinssrv = i.codinssrv
       and t.tipequ = se.tipequ
       and a.codmat = t.codtipequ
       and se.codsolot = p_codsolot
       and trim(se.numserie) is null
       and t.tipequ = equ_conax.tipequ;
    if ln_val_ns > 0 then
      p_cod     := -97;
      p_mensaje := 'Hay equipos que le falta asignar Numero de Serie - DTH, no se pudo provisionar los servicios'; --15.00
      sgasu_serv_x_cliente(p_codsolot,
                           'TP',
                           p_mensaje,
                           'ERRO',
                           ln_cod1,
                           lv_resul);
      return;
    end if;
    --fin 14.0

    -- Validando si hay Servicio de telefonia o internet
    select count(1)
      into ln_val_tlf_int
      from operacion.inssrv i
     where i.codinssrv in (select sp.codinssrv
                             from operacion.solotpto sp
                            where sp.codsolot = p_codsolot)
       and i.tipsrv in ('0006', '0004');
    -- Validando si hay Servicio de Cable
    select count(1)
      into ln_val_cable
      from operacion.inssrv i
     where i.codinssrv in (select sp.codinssrv
                             from operacion.solotpto sp
                            where sp.codsolot = p_codsolot)
       and i.tipsrv in ('0062');

    if ln_val_tlf_int + ln_val_cable = 0 then
      p_cod     := -98;
      p_mensaje := 'No hay Servicios para Activar';
      sgasu_serv_x_cliente(p_codsolot,
                           'TP',
                           p_mensaje,
                           'ERRO',
                           ln_cod1,
                           lv_resul); --14.00
      return;
    end if;
    ln_deco_adicional := operacion.pq_deco_adicional_lte.f_obt_tipo_deco(p_codsolot); --V19.0
    if ln_val_cable > 0 and
       (p_tipo_operacion = 'TP' or p_tipo_operacion = 'CX' or
       p_tipo_operacion = 'CI') then
      --14.0
      -- Ejecutando la Provision de Cable

      p_log_3playi(p_codsolot,
                   'p_conax_alta',
                   'INICIO',
                   'Activación de Servicios Inalámbricos',
                   ln_cod1,
                   lv_resul); -- 8.0
      p_conax_alta(p_codsolot, p_idtareawf, p_cod, p_mensaje);
      --ini 14.00
      --ini v19.0
      IF ln_deco_adicional = 0 THEN
        if p_cod < 0 then
          sgasu_serv_x_cliente(p_codsolot,
                               'CX',
                               p_mensaje,
                               'ERRO',
                               ln_cod1,
                               lv_resul);
        else
          sgasu_serv_x_cliente(p_codsolot,
                               'CX',
                               null,
                               'EPLA',
                               ln_cod1,
                               lv_resul);
        end if;
      END IF;
      --fin v19.0
      --fin 14.00
      p_log_3playi(p_codsolot,
                   'p_conax_alta',
                   p_mensaje,
                   'Activación de Servicios Inalámbricos',
                   ln_cod1,
                   lv_resul); -- 8.0
    end if;
    -- Estableciendo los valores de Telefonia e Internet si se encuentran
    if ln_val_tlf_int > 0 and
       (p_tipo_operacion = 'TP' or p_tipo_operacion = 'IL' or
       p_tipo_operacion = 'IJ' or p_tipo_operacion = 'CI') then
      --14.00
      -- ini 4.0
      select valor
        into lv_tip_equ
        from constante
       where constante = 'PROV_TIP_EQU';
      select valor
        into lv_mdl_equ
        from constante
       where constante = 'PROV_MOD_EQU';

      -- fin 4.0
      -- Tomando ICCID y MSISDN
      select rpad(se.numserie, ln_cant_dig_chip),
             se.mac,
             s.cod_id,
             s.customer_id
        into lv_iccid, lv_msisdn, ln_cod_id, ln_custumer_id
        from solotptoequ se,
             solot s,
             solotpto sp,
             inssrv i,
             tipequ t,
             almtabmat a,
             (select a.codigon tipequ, codigoc grupo
                from opedd a, tipopedd b
               where a.tipopedd = b.tipopedd
                 and b.abrev = 'TIPEQU_LTE_TLF') equ_conax
       where se.codsolot = s.codsolot
         and s.codsolot = sp.codsolot
         and se.punto = sp.punto
         and sp.codinssrv = i.codinssrv
         and t.tipequ = se.tipequ
         and a.codmat = t.codtipequ
         and se.codsolot = p_codsolot
         and t.tipequ = equ_conax.tipequ
         and equ_conax.grupo = '3';

    end if;

    -- ini 4.0
    if operacion.pq_siac_cambio_plan_lte.fnc_valida_cp_lte(p_codsolot) = 1 then
      -- Cambio de Plan
      p_log_3playi(p_codsolot,
                   'p_generar_inst_cp tim.pp004_siac_lte.sp_cambio_plan_prov',
                   'INICIO',
                   'Activación de Servicios Inalámbricos',
                   ln_cod1,
                   lv_resul); -- 8.0

      p_generar_inst_cp(p_co_id,
                        p_codsolot,
                        lv_tip_equ,
                        lv_mdl_equ,
                        p_cod,
                        p_mensaje);

      p_log_3playi(p_codsolot,
                   'p_generar_inst_cp tim.pp004_siac_lte.sp_cambio_plan_prov',
                   p_mensaje,
                   'Activación de Servicios Inalámbricos',
                   ln_cod1,
                   lv_resul); -- 8.0

      select max(request_padre)
        into ln_request_padre
        from tim.lte_control_prov@dbl_bscs_bf
       where co_id = p_co_id;

      select max(request)
        into ln_request_tv
        from tim.lte_control_prov@dbl_bscs_bf
       where co_id = p_co_id
         and tipo_prod = 'TV';
    else
      -- Venta Nueva
      IF ln_deco_adicional = 0 and
         (p_tipo_operacion = 'TP' or p_tipo_operacion = 'IL' or
         p_tipo_operacion = 'IJ' or p_tipo_operacion = 'CI') THEN
        --14.00
        p_log_3playi(p_codsolot,
                     'p_generar_inst_venta tim.pp021_venta_lte.sp_generar_inst_venta',
                     'INICIO',
                     'Activación de Servicios Inalámbricos',
                     ln_cod1,
                     lv_resul); -- 8.0

        -- INI 11.0 (Cambiar el nombre del Paquete)
        operacion.pq_sga_bscs.p_reg_nro_lte_bscs(lv_msisdn,
                                                 p_cod,
                                                 p_mensaje);

        p_log_3playi(p_codsolot,
                     'OPERACION.PQ_SGA_BSCS.P_REG_NRO_LTE_BSCS',
                     p_mensaje,
                     'Registro de la linea Telefonica LTE en BSCS',
                     ln_cod1,
                     lv_resul);

        select s.codcli,
               operacion.pq_sga_wimax_lte.f_obtiene_sot_cli_wimax(s.codcli)
          into lv_codcli, ln_codsolot_wix
          from solot s
         where s.codsolot = p_codsolot;

        ln_val_wimax_lte := operacion.pq_sga_wimax_lte.f_val_cli_wimax(lv_codcli);

        if ln_val_wimax_lte > 0 then
          if ln_codsolot_wix = 0 then
            p_log_3playi(p_codsolot,
                         'OPERACION.PQ_SGA_IW.P_ACTUALIZA_CICLO_BSCS',
                         'No existe SOT de Baja por Migración de WIMAX',
                         'Cambio de Ciclo en BSCS WIMAX - LTE',
                         ln_cod1,
                         lv_resul);
          else
            operacion.pq_sga_iw.p_actualiza_ciclo_bscs(p_codsolot,
                                                       p_co_id,
                                                       ln_codsolot_wix,
                                                       p_cod,
                                                       p_mensaje);
            p_log_3playi(p_codsolot,
                         'OPERACION.PQ_SGA_IW.P_ACTUALIZA_CICLO_BSCS',
                         p_mensaje,
                         'Cambio de Ciclo en BSCS WIMAX - LTE',
                         ln_cod1,
                         lv_resul);
          end if;
        end if;

        -- FIN 11.0

        p_generar_inst_venta(p_co_id,
                             lv_msisdn,
                             lv_iccid,
                             p_codsolot,
                             lv_tip_equ,
                             lv_mdl_equ,
                             sysdate,
                             ln_request_padre,
                             ln_request_tv,
                             p_cod,
                             p_mensaje);

        --ini 14.00
        if p_cod = 0 then
          sgasu_serv_x_cliente(p_codsolot,
                               'IL',
                               null,
                               'EPLA',
                               ln_cod1,
                               lv_resul);
        else
          sgasu_serv_x_cliente(p_codsolot,
                               'IL',
                               p_mensaje,
                               'ERRO',
                               ln_cod1,
                               lv_resul);
        end if;
        --fin 14.00

        p_log_3playi(p_codsolot,
                     'p_generar_inst_venta tim.pp021_venta_lte.sp_generar_inst_venta',
                     p_mensaje,
                     'Activación de Servicios Inalámbricos',
                     ln_cod1,
                     lv_resul); -- 8.0

        --ini 14.00
        IF p_tipo_operacion = 'TP' or p_tipo_operacion = 'IJ' THEN
          ln_tmcode := tim.pp021_venta_lte.f_get_plan@dbl_bscs_bf(ln_cod_id);
          ln_smcode := tim.pp021_venta_lte.f_get_serv_tel@dbl_bscs_bf(ln_cod_id);

          if p_cod <> 0 then
            sgasu_serv_x_cliente(p_codsolot,
                                 'JN',
                                 'Error en IL no se puede continuar con la provisión de JANUS',
                                 'ERRO',
                                 ln_cod1,
                                 lv_resul);
            RETURN;
          end if;

          --Se implemementa un timer debido que el proceso de IL demora en procesar, una vez provisionado continua con JANUS.
          --La primera vez espera 5 seg y la segunda 60 Seg. en caso que la primera vez continuara en pendiente
          commit;
          
          --ini 26.0
        SELECT COUNT(*)
          INTO N_VALIDA
          FROM OPERACION.SGAT_CONTROL_APP
         WHERE CONTROLN_CODSOLOT = p_codsolot;
         --fin 26.0
         
          IF N_VALIDA = 0 THEN --26.0
            
          dbms_lock.sleep(30);
          p_estado_prov_inst(ln_cod_id, p_cod, p_mensaje);

          if p_cod = -3 then
            dbms_lock.sleep(60);
            p_estado_prov_inst(ln_cod_id, p_cod, p_mensaje);
          end if;
          
          end if; --26.0
          
          -- Si no se encuentra Provisionada
          IF p_cod <> 0 THEN
            sgasu_serv_x_cliente(p_codsolot,
                                 'JN',
                                 'Error en IL(Demora en la provisión) no se puede continuar con la provisión de JANUS' ||
                                 ln_prueba,
                                 'ERRO',
                                 ln_cod1,
                                 lv_resul);
            RETURN;
          END IF;

        END IF;
        --fin 14.00

      END IF; --12.0
    end if;
    -- fin 4.0
    IF ln_deco_adicional = 0 THEN
      --12.0
      IF p_cod < 0 THEN
        RETURN;
      END IF;

      --ini 15.00
      if ln_request_tv is null then
        select max(request)
          into ln_request_tv
          from tim.lte_control_prov@dbl_bscs_bf
         where co_id = p_co_id
           and tipo_prod = 'TV'
           and action_id = 1;
      end if;
      --fin 15.00

      UPDATE operacion.ope_srv_recarga_det
         SET request = ln_request_tv
       WHERE tipsrv = (SELECT c.valor
                         FROM operacion.constante c
                        WHERE c.constante = 'FAM_CABLE')
         AND numregistro = (SELECT t.numregistro
                              FROM operacion.ope_srv_recarga_cab t
                             WHERE t.codsolot = p_codsolot);

      --ini 15.00
      if ln_request_padre is null then
        select max(request_padre)
          into ln_request_padre
          from tim.lte_control_prov@dbl_bscs_bf
         where co_id = p_co_id
           and action_id = 1;
      end if;
      --fin 15.00

      UPDATE operacion.ope_srv_recarga_det
         SET request_padre = ln_request_padre
       WHERE numregistro = (SELECT t.numregistro
                              FROM operacion.ope_srv_recarga_cab t
                             WHERE t.codsolot = p_codsolot);

      p_log_3playi(p_codsolot,
                   'p_provision_lte',
                   'OK',
                   'Activación de Servicios Inalámbricos',
                   ln_cod1,
                   lv_resul);

    END IF; --12.0
  EXCEPTION
    when others then
      p_cod     := -99;
      p_mensaje := sqlerrm;
      p_log_3playi(p_codsolot,
                   'p_provision_lte',
                   p_mensaje,
                   'Activación de Servicios Inalámbricos',
                   ln_cod1,
                   lv_resul); -- 8.0
  end;

  procedure p_reg_cbscs_lte(p_codsolot in number,
                            p_idtrs    in number,
                            p_cod      out number,
                            p_mensaje  out varchar2) is
    pragma autonomous_transaction;
  begin
    p_cod     := 0;
    p_mensaje := 'Exito';
    insert into operacion.control_contrato_bscs_lte
      (codsolot, idtransaccion)
    values
      (p_codsolot, p_idtrs);
    commit;
  exception
    when others then
      p_cod     := -1;
      p_mensaje := 'Error al registrar en Control de Contrato LTE';
  end;
  -- Ini 2.0
  procedure p_cnsl_tlf_cpe(p_co_id     in number,
                           p_tlf_val   out number,
                           p_serie_cpe out varchar2,
                           p_cod       out number,
                           p_mensaje   out varchar2) is
    ln_codsolot number;
    ln_equipo   number; -- 4.0
  begin
    p_cod     := 0;
    p_mensaje := 'Exito';
    -- Consultando SOT de Instalacion
    begin
      p_tlf_val   := -1;
      p_serie_cpe := 0;
      --Obtener la Maxima SOT por Contrato de Venta/Cambio Plan/Cambio de Equipo
      select nvl(max(s.codsolot), 0)
        into ln_codsolot
        from solot s
       where s.cod_id = p_co_id
       and s.tiptra in (SELECT O.CODIGON
                        FROM TIPOPEDD T, OPEDD O
                        WHERE T.ABREV = 'LTE_CNS_TLF_CPE'
                        AND T.TIPOPEDD = O.TIPOPEDD
                        AND O.ABREVIACION = 'TIPTRA')
       and s.estsol in (SELECT O.CODIGON
                        FROM TIPOPEDD T, OPEDD O
                        WHERE T.ABREV = 'LTE_CNS_TLF_CPE'
                        AND T.TIPOPEDD = O.TIPOPEDD
                        AND O.ABREVIACION = 'ESTSOL');

      if ln_codsolot = 0 then --OLO
         p_tlf_val   := -1;
         p_serie_cpe := 0;
      end if;

    exception
      when no_data_found then
        -- Proyecto 31812 OLO LTE
        p_tlf_val   := -1;
        p_serie_cpe := 0;
        -- Proyecto 31812 OLO LTE
    end;

    if ln_codsolot is not null then
      -- Consultar si el servicio es de tipo de telefonia
      select count(1)
        into p_tlf_val
        from operacion.inssrv i
       where i.codinssrv in
             (select sp.codinssrv
                from solotpto sp
               where sp.codsolot = ln_codsolot)
         and i.tipsrv = (select valor
                           from constante
                          where trim(constante) = 'FAM_TELEF');

       --1play
       if p_tlf_val = 0 then
          select count(1)
          into p_tlf_val
          from operacion.inssrv i
         where i.codinssrv in
               (select sp.codinssrv
                  from solotpto sp
                 where sp.codsolot = ln_codsolot)
           and i.tipsrv = (select valor
                             from constante
                            where trim(constante) = 'FAM_INTERNET');
       end if;

      select valor
        into ln_equipo
        from constante
       where constante = 'TIPO_EQUIPO_LTE'; -- 4.0

      if p_tlf_val > 0 then
        -- Consultar el numero de Serie del Overall del CPE
        begin
      select spe.numserie
        into p_serie_cpe
        from operacion.solotptoequ spe
       where spe.tipequ= ln_equipo  -- 4.0
         and spe.codsolot = ln_codsolot
         and spe.estado in (15, 4); -- Aplica para Cambio de Plan y Cambio de Equipo LTE (15: Refrescar / 4: Instalar)
      exception
      when no_data_found then
        -- En el caso no exista sigue el mismo flujo para Alta y Porta LTE
        begin
        select spe.numserie
          into p_serie_cpe
          from operacion.solotptoequ spe
         where spe.tipequ= ln_equipo  -- 4.0
           and spe.codsolot = ln_codsolot;
        exception
        when others then
          p_cod:=-2;
          p_mensaje:='No se encontro Numero de Serie del CPE';
        end;
      when others then
        p_cod:=-2;
        p_mensaje:='No se encontro Numero de Serie del CPE';
      end;
      end if;
    end if;
  exception
    when others then
      p_cod     := -1;
      p_mensaje := 'Error en el Proceso consultar el numero de serie del CPE';
  end;
  -- Fin 2.0
  ---------------------------------------------------------------------------------------------------------------------
  -- ini 3.0
  procedure p_update_numtel( --p_nro_tlf   in varchar2, --4.0
                            p_simcard   in varchar2,
                            p_codinssrv in number,
                            p_estnumtel in number,
                            p_tipnumtel in number,
                            p_codnumtel in number,
                            p_cod       out number,
                            p_mensaje   out varchar2) is
  begin
    p_cod     := 0;
    p_mensaje := 'Exito';

    update telefonia.numtel nt
       set nt.estnumtel = p_estnumtel,
           nt.tipnumtel = p_tipnumtel,
           --        nt.numero    = p_nro_tlf, --4.0
           nt.fecasg    = sysdate,
           nt.fecusu    = sysdate,
           nt.codusu    = user,
           nt.codinssrv = p_codinssrv,
           nt.simcard   = p_simcard
     where nt.codnumtel = p_codnumtel;
  exception
    when others then
      p_cod     := -1;
      p_mensaje := 'Error al Asociar Numero : ' || sqlerrm;
  end;

  ---------------------------------------------------------------------------------------------------------------------
  procedure p_update_rsv_numtel(p_codnumtel in number,
                                p_codinssrv in number,
                                p_valido    in number,
                                p_estnumtel in number,
                                p_codcli    in varchar2,
                                p_cod       out number,
                                p_mensaje   out varchar2) is
  begin
    p_cod     := 0;
    p_mensaje := 'Exito';

    update telefonia.reservatel rt
       set rt.numslc   =
           (select i.numslc
              from operacion.insprd i
             where i.codinssrv = p_codinssrv
               and i.flgprinc = 1),
           rt.numpto   =
           (select i.numpto
              from operacion.insprd i
             where i.codinssrv = p_codinssrv
               and i.flgprinc = 1),
           rt.valido    = 0,
           rt.estnumtel = p_estnumtel,
           rt.fecinires = sysdate,
           rt.codusures = user,
           rt.codcli    = p_codcli
     where rt.codnumtel = p_codnumtel;

  exception
    when others then
      p_cod     := -1;
      p_mensaje := 'Error al Asociar Numero : ' || sqlerrm;
  end;
  -- fin 3.0
  -- ini 4.0
  procedure p_generar_inst_cp(p_coid    in integer,
                              p_solot   in operacion.solot.codsolot%type,
                              p_tip_equ in varchar2,
                              p_mod_equ in varchar2,
                              p_res     out integer,
                              p_msg     out varchar2) is

    l_idx         integer;
    l_password    varchar2(100);
    l_userid      varchar2(100);
    l_origen_prov integer;
    l_srv_cp      tim.pp004_siac_lte.t_lista_cp@dbl_bscs_bf;

    cursor servicios is
      select t.*
        from sales.sisact_postventa_det_serv_lte t
       where t.codsolot = p_solot
         and t.flag_accion in ('B', 'M', 'A');
  begin
    l_idx := 0;
    for srv_cp in servicios loop
      l_idx := l_idx + 1;
      l_srv_cp(l_idx).sncode := to_number(srv_cp.sncode);
      l_srv_cp(l_idx).estado := srv_cp.flag_accion;
    end loop;

    l_password    := null;
    l_userid      := user;
    l_origen_prov := 0;

    tim.pp004_siac_lte.sp_cambio_plan_prov@dbl_bscs_bf(p_coid,
                                                       l_srv_cp,
                                                       p_tip_equ,
                                                       p_mod_equ,
                                                       l_password,
                                                       l_userid,
                                                       l_origen_prov,
                                                       p_res,
                                                       p_msg);
  end;
  -- fin 4.0
  ---------------------------------------------------------------------------------------------------------------------
  -- Ini 5.0
  procedure p_consult_cod_presec(p_idoperador in number,
                                 p_cod_presec out number,
                                 p_cod        out number,
                                 p_msj        out varchar2) --6.0
   is
  begin
    p_cod := 0;
    p_msj := 'Exito';
    select to_number(o.idoperadorfco) --6.0
      into p_cod_presec
      from billcolper.operador o
     where o.idoperador = p_idoperador;
  exception
    when others then
      p_cod := -1;
      p_msj := 'Error al consultar el codigo de preseleccion';
  end;
  -- Fin 5.0
  ---------------------------------------------------------------------------------------------------------------------
  -- Ini 7.0
  ---------------------------------------------------------------------------------------------------------------------

  procedure p_provision_janus(p_cod_id      in number,
                              p_customer_id in number,
                              p_tmcode      in number,
                              p_sncode      in number,
                              p_accion      in varchar2,
                              p_resultado   out integer,
                              p_msgerr      out varchar2) is
  begin
    tim.pp001_pkg_prov_janus.sp_prov_nro_lte@DBL_BSCS_BF(p_cod_id,
                                                         p_customer_id,
                                                         p_tmcode,
                                                         p_sncode,
                                                         p_accion,
                                                         p_resultado,
                                                         p_msgerr);
  end;
  ---------------------------------------------------------------------------------------------------------------------

  PROCEDURE p_activacion_servicio_3play(a_idtareawf IN NUMBER,
                                        a_idwf      IN NUMBER,
                                        a_tarea     IN NUMBER,
                                        a_tareadef  IN NUMBER) IS

    PRAGMA AUTONOMOUS_TRANSACTION;

    ln_codsolot    solot.codsolot%TYPE;
    ln_cod_id      NUMBER;
    ln_custumer_id NUMBER;
    ln_count       NUMBER;
    ln_request     NUMBER;
    ln_tmcode      NUMBER;
    ln_smcode      NUMBER; -- 8.0
    ln_resp        INTEGER := 0;
    lv_mensaje     VARCHAR2(3000);
    ln_cod1        NUMBER;
    lv_resp        varchar(1000);
    lv_resul       VARCHAR2(4000);
    ls_numreg      VARCHAR2(10);
    --Ini 10.0
    l_msisdn        varchar2(15);
    l_iccid         varchar2(20);
    l_request_padre number;
    l_request_tv    number;
    --Fin 10.0
    -- INI 11.0
    ln_flag_wimax number;
    le_error exception; --14.00

    ln_cant_dig_chip number;
    ln_arch_env      number; --V19.0
  BEGIN

    ln_cant_dig_chip := OPERACION.PQ_SGA_JANUS.F_GET_CONSTANTE_CONF('CANDIGCHIPLTE');

    if ln_cant_dig_chip = -10 then
      ln_cant_dig_chip := 19; -- Solo por contingencia
    end if;

    --ini 15.00
    SELECT s.codsolot
      INTO ln_codsolot
      FROM wf f, solot s
     WHERE f.codsolot = s.codsolot
       and f.valido = 1
       and idwf = a_idwf;
    --fin 15.00

    SELECT COUNT(codsolot)
      INTO ln_count
      FROM operacion.solot s, operacion.inssrv i
     WHERE s.numslc = i.numslc
       AND i.tipsrv = '0062'
       AND codsolot = ln_codsolot;

    SELECT s.cod_id, s.customer_id
      INTO ln_cod_id, ln_custumer_id
      FROM operacion.solot s
     WHERE s.codsolot = ln_codsolot;

    p_log_3playi(ln_codsolot,
                 'p_activacion_servicio_3play',
                 'INICIO',
                 'Cierre de Activación de Servicios Inalámbricos',
                 ln_cod1,
                 lv_resul); --15.00

    IF ln_count > 0 THEN
      --<ini 8.0>
      operacion.pq_dth.p_get_numregistro(ln_codsolot, ls_numreg);

      p_log_3playi(ln_codsolot,
                   'operacion.pq_dth.p_proc_recu_filesxcli',
                   'INICIO',
                   'Cierre de Activación de Servicios Inalámbricos',
                   ln_cod1,
                   lv_resul);

      --INI V19.0
      select count(*)
        into ln_arch_env
        from operacion.reg_archivos_enviados
       where estado = 1
         and numregins = ls_numreg
         and fecenv is not null;

      if ln_arch_env = 0 then
        OPERACION.PKG_CONTEGO.SGASS_VALIDARALTA(ls_numreg,
                                                lv_resp,
                                                lv_mensaje); --V18.0
      else
        operacion.pq_dth.p_proc_recu_filesxcli(ls_numreg,
                                               9,
                                               lv_resp,
                                               lv_mensaje); -- le envío 9 porque ese estado no existe y no se quiere qe se actualice nada
      end if;
      --FIN V19.0

      p_log_3playi(ln_codsolot,
                   'operacion.pq_dth.p_proc_recu_filesxcli',
                   lv_mensaje,
                   'Cierre de Activación de Servicios Inalámbricos',
                   ln_cod1,
                   lv_resul);

      IF lv_resp <> 'OK' THEN
        raise_application_error(-20500,
                                'operacion.pq_dth.p_proc_recu_filesxcli: ' ||
                                lv_mensaje);
      END IF;
      --<fin 8.0>

    END IF;

    SELECT COUNT(codsolot)
      INTO ln_count
      FROM operacion.solot s, operacion.inssrv i
     WHERE s.numslc = i.numslc
       AND i.tipsrv = '0004'
       AND codsolot = ln_codsolot; --8.0

    IF ln_count > 0 THEN
      --8.0
      ln_tmcode := tim.pp021_venta_lte.f_get_plan@dbl_bscs_bf(ln_cod_id);
      ln_smcode := tim.pp021_venta_lte.f_get_serv_tel@dbl_bscs_bf(ln_cod_id); --8.0
      -- Validar Estado de Provision

      p_log_3playi(ln_codsolot,
                   'p_estado_prov_inst tim.pp021_venta_lte.sp_estado_prov_inst',
                   'INICIO',
                   'Cierre de Activación de Servicios Inalámbricos',
                   ln_cod1,
                   lv_resul); -- 8.0

      p_estado_prov_inst(ln_cod_id, ln_resp, lv_mensaje);
      -- Si no se encuentra Provisionado

      p_log_3playi(ln_codsolot,
                   'p_estado_prov_inst tim.pp021_venta_lte.sp_estado_prov_inst',
                   lv_mensaje,
                   'Cierre de Activación de Servicios Inalámbricos',
                   ln_cod1,
                   lv_resul); -- 8.0

      IF ln_resp <> 0 THEN
        raise_application_error(-20500,
                                'TIM.PP021_VENTA_LTE.SP_ESTADO_PROV_INST : ' ||
                                lv_mensaje);
      END IF;

      --Ini 10.0
      select rpad(se.numserie, ln_cant_dig_chip), se.mac
        into l_iccid, l_msisdn
        from solotptoequ se,
             solot s,
             solotpto sp,
             inssrv i,
             tipequ t,
             almtabmat a,
             (select a.codigon tipequ, codigoc grupo
                from opedd a, tipopedd b
               where a.tipopedd = b.tipopedd
                 and b.abrev = 'TIPEQU_LTE_TLF') equ_conax
       where se.codsolot = s.codsolot
         and s.codsolot = sp.codsolot
         and se.punto = sp.punto
         and sp.codinssrv = i.codinssrv
         and t.tipequ = se.tipequ
         and a.codmat = t.codtipequ
         and se.codsolot = ln_codsolot
         and t.tipequ = equ_conax.tipequ
         and equ_conax.grupo = '3';

      p_log_3playi(ln_codsolot,
                   'tim.pp021_venta_lte.sp_inst_msisdn_iccid',
                   'INICIO',
                   'Reintento de Asignación de número real',
                   ln_cod1,
                   lv_resul);

      TIM.PP021_VENTA_LTE.SP_INST_MSISDN_ICCID@DBL_BSCS_BF(ln_cod_id,
                                                           l_msisdn,
                                                           l_iccid,
                                                           ln_codsolot,
                                                           l_request_padre,
                                                           l_request_tv,
                                                           ln_resp,
                                                           lv_mensaje);

      p_log_3playi(ln_codsolot,
                   'tim.pp021_venta_lte.sp_inst_msisdn_iccid',
                   lv_mensaje,
                   'Reintento de Asignación de número real',
                   ln_cod1,
                   lv_resul);

      if ln_resp <> 0 then
        raise_application_error(-20500,
                                'TIM.PP021_VENTA_LTE.SP_INST_MSISDN_ICCID: ' ||
                                lv_mensaje);
      end if;
      --Fin 10.0

    END IF; --8.0

    -- ini 14.00
    p_log_3playi(ln_codsolot,
                 'Valida Provision de Servicios',
                 'INICIO',
                 'Cierre de Activación de Servicios Inalámbricos',
                 ln_cod1,
                 lv_resul); --15.00

    --ini 15.00
    --Se actualiza el estado de la provision en el caso que algun servicio se quedo Enviando a Plataforma.
    select count(1)
      into ln_count
      from operacion.psgat_estservicio e
     where e.essen_cod_solot = ln_codsolot
       and e.essev_estado = 'EPLA'
       and e.essev_cod_operacion = 'CX';

    if ln_count > 0 then
      sgass_conci_srv(ln_codsolot, 'CX', ln_cod1, lv_resul);
    end if;

    select count(1)
      into ln_count
      from operacion.psgat_estservicio e
     where e.essen_cod_solot = ln_codsolot
       and e.essev_estado = 'EPLA'
       and e.essev_cod_operacion = 'IL';

    if ln_count > 0 then
      sgass_conci_srv(ln_codsolot, 'IL', ln_cod1, lv_resul);
    end if;

    select count(1)
      into ln_count
      from operacion.psgat_estservicio e
     where e.essen_cod_solot = ln_codsolot
       and e.essev_estado = 'EPLA'
       and e.essev_cod_operacion = 'JN';

    if ln_count > 0 then
      sgass_conci_srv(ln_codsolot, 'JN', ln_cod1, lv_resul);
    end if;
    -- fin 15.00

    select count(1)
      into ln_count
      from operacion.psgat_estservicio e
     where e.essen_cod_solot = ln_codsolot
       and e.essev_estado <> 'PROV'
       and e.essev_cod_operacion <> 'JN';

    if ln_count > 0 then
      p_log_3playi(ln_codsolot,
                   'Valida Provision de Servicios',
                   'Algunos servicios no se encuentran provisionados',
                   'Cierre de Activación de Servicios Inalámbricos',
                   ln_cod1,
                   lv_resul); --15.00
      raise le_error;
    end if;
    --  fin 14.00

    p_log_3playi(ln_codsolot,
                 'p_activacion_servicio_3play',
                 'OK',
                 'Cierre de Activación de Servicios Inalámbricos',
                 ln_cod1,
                 lv_resul); -- 8.0
    COMMIT;
  EXCEPTION
    --ini 14.00
    WHEN le_error THEN
      lv_mensaje := SQLERRM;
      p_log_3playi(ln_codsolot,
                   'p_activacion_servicio_3play',
                   lv_mensaje,
                   'Cierre de Activación de Servicios Inalámbricos',
                   ln_cod1,
                   lv_resul);
      rollback;
      raise_application_error(-20500,
                              'Para cerrar la activacion se requiere provisionar todos los servicios');
      --fin 14.00
    WHEN OTHERS THEN
      lv_mensaje := SQLERRM;
      p_log_3playi(ln_codsolot,
                   'p_activacion_servicio_3play',
                   lv_mensaje,
                   'Cierre de Activación de Servicios Inalámbricos',
                   ln_cod1,
                   lv_resul); -- 8.0
      rollback;
      raise_application_error(-20001,
                              'Error al activar servicio 3play inalámbrico  : ' ||
                              SQLERRM);
  END;
  -- Fin 7.0

  --<ini 8.0>
  /************************************************************************************************/
  PROCEDURE p_log_3playi(p_codsolot IN NUMBER,
                         p_nomproc  IN VARCHAR2,
                         p_mensaje  IN VARCHAR2,
                         p_tarea    IN VARCHAR2,
                         p_cod      OUT NUMBER,
                         p_resul    OUT VARCHAR2) IS
    pragma autonomous_transaction;
  BEGIN
    p_cod   := 0;
    p_resul := 'Exito';

    INSERT INTO historico.log_proceso_3play
      (nom_proceso, des_mensaje, codsolot, tarea)
    VALUES
      (p_nomproc, p_mensaje, p_codsolot, p_tarea);

    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      p_cod   := -1;
      p_resul := 'Error al Insertar log : ' || SQLERRM;
  END;
  /************************************************************************************************/
  --<fin 8.0>
  --Ini 10.0
  --------------------------------------------------------------------------------
  procedure p_val_reg_msisdn(p_codsolot  in integer,
                             p_resultado out integer,
                             p_msgerr    out varchar2) is
    l_codid number;

  begin
    select t.cod_id
      into l_codid
      from operacion.solot t
     where t.codsolot = p_codsolot;

    TIM.PP021_VENTA_LTE.SP_VAL_REG_MSISDN@DBL_BSCS_BF(l_codid,
                                                      p_resultado,
                                                      p_msgerr);
  end;
  --Fin 10.0
  --<ini 12.0>
  /************************************************************************************************/
  PROCEDURE p_conax_alta_deco(p_codsolot  IN NUMBER,
                              p_idtareawf IN NUMBER,
                              p_cod       OUT NUMBER,
                              p_resul     OUT VARCHAR2) IS
    l_codsolot      NUMBER;
    l_numslc        VARCHAR2(10);
    l_estsol        NUMBER(2);
    l_numregistro   VARCHAR2(30);
    l_rpta          NUMBER;
    l_resultado     VARCHAR2(200);
    l_mensaje       VARCHAR2(2000);
    l_nro_contrato  VARCHAR2(30);
    l_id_sisact     NUMBER;
    l_codigo        NUMBER;
    l_count         PLS_INTEGER;
    l_contador1     PLS_INTEGER;
    l_result_post   PLS_INTEGER;
    l_tipcambio     PLS_INTEGER := 1;
    l_serie_tarjeta VARCHAR2(2000);
    l_serie_deco    VARCHAR2(2000);
    l_grupo         NUMBER;
    l_numserie      VARCHAR2(2000);
    l_mac           VARCHAR2(30);
    l_cant          NUMBER(8, 2);
    l_codinssrv     NUMBER;
    l_punto         NUMBER(10);
    l_orden         NUMBER(4);
    l_codsap        VARCHAR2(20);
    ln_tiptra       NUMBER; --8.0
    ln_codigon      NUMBER; --8.0

    CURSOR equipos_conax IS
      SELECT equ_conax.grupo grupo,
             se.numserie,
             se.mac,
             se.cantidad,
             i.codinssrv,
             se.punto,
             se.orden,
             a.cod_sap
        FROM solotptoequ se,
             solot s,
             solotpto sp,
             inssrv i,
             tipequ t,
             almtabmat a,
             (SELECT a.codigon tipequ, to_number(codigoc) grupo
                FROM opedd a, tipopedd b
               WHERE a.tipopedd = b.tipopedd
                 AND b.abrev = 'TIPEQU_LTE_ADICIONAL') equ_conax
       WHERE se.codsolot = s.codsolot
         AND s.codsolot = sp.codsolot
         AND se.punto = sp.punto
         AND sp.codinssrv = i.codinssrv
         AND t.tipequ = se.tipequ
         AND a.codmat = t.codtipequ
         AND se.codsolot = l_codsolot
         AND t.tipequ = equ_conax.tipequ;

  BEGIN
    p_cod      := 0;
    p_resul    := 'OK';
    l_codsolot := p_codsolot;

    SELECT COUNT(1)
      INTO l_contador1
      FROM operacion.ope_envio_conax
     WHERE codsolot = l_codsolot
       AND tipo = 1;

    SELECT s.numslc, s.estsol
      INTO l_numslc, l_estsol
      FROM solot s
     WHERE s.codsolot = l_codsolot;

    SELECT pq_inalambrico.f_obtener_numregistro(l_codsolot)
      INTO l_numregistro
      FROM dual;

    --si es reenvio se borrar lo existente
    IF l_contador1 > 0 THEN
      p_borrar_ope_envio_conax(l_codsolot, 1);
    END IF;

    SELECT COUNT(t.codsolot)
      INTO l_count
      FROM operacion.tarjeta_deco_asoc t
     WHERE t.codsolot = l_codsolot;

    IF l_count = 0 THEN
      p_cod   := -1;
      p_resul := 'Debe Asociar las Tarjetas y Decodificador';
      RETURN;
    END IF;

    --ENVIO A CONAX DE EQUIPOS
    OPEN equipos_conax;
    LOOP
      FETCH equipos_conax
        INTO l_grupo,
             l_numserie,
             l_mac,
             l_cant,
             l_codinssrv,
             l_punto,
             l_orden,
             l_codsap;
      EXIT WHEN equipos_conax%NOTFOUND;
      l_codigo := l_grupo;
      p_ins_envioconax(l_codsolot,
                       l_codinssrv,
                       l_tipcambio,
                       l_numserie,
                       l_mac,
                       NULL,
                       NULL,
                       l_codigo,
                       l_rpta,
                       l_mensaje);
      IF nvl(l_rpta, 0) <> 0 THEN
        p_cod   := -1;
        p_resul := 'No se registro envio a CONAX';
        RETURN;
      END IF;
    END LOOP;
    CLOSE equipos_conax;

    --ACTIVACION DTH
    operacion.pq_dth.p_crear_archivo_conax(l_numregistro,
                                           l_resultado,
                                           l_mensaje);

    IF l_resultado = 'OK' THEN
      IF l_id_sisact IS NOT NULL THEN
        UPDATE ope_srv_recarga_cab o
           SET o.id_sisact = l_id_sisact
         WHERE o.numslc = l_numslc;
      END IF;
    ELSE
      UPDATE ope_srv_recarga_det
         SET mensaje = l_mensaje
       WHERE numregistro = l_numregistro
         AND tipsrv =
             (SELECT valor FROM constante WHERE constante = 'FAM_CABLE');
      p_cod   := -1;
      p_resul := 'Se produjo un error al Enviar Archivo de Activación a CONAX.';
    END IF;

  EXCEPTION
    WHEN OTHERS THEN
      p_cod   := -1;
      p_resul := 'Error en la Activacion de Servicios: ' || SQLERRM;

  END;
  /* **********************************************************************************************/
  PROCEDURE p_validar_servicio_deco_adc(a_idtareawf IN NUMBER,
                                        a_idwf      IN NUMBER,
                                        a_tarea     IN NUMBER,
                                        a_tareadef  IN NUMBER) IS
    ln_cod_id           NUMBER;
    ln_sot              NUMBER;
    ln_estsol           solot.estsol%TYPE;
    ln_estsolact        solot.estsol%TYPE;
    ln_codinssrv        NUMBER;
    n_cont              NUMBER;
    ln_codnumtel        NUMBER;
    ln_request          NUMBER;
    lv_simcard          VARCHAR2(25);
    lv_numtel           VARCHAR2(20);
    ln_resp             NUMERIC := 0;
    lv_mensaje          VARCHAR2(3000);
    lv_idtrs            VARCHAR2(30);
    ln_cod1             NUMBER;
    lv_resul            VARCHAR2(4000);
    lv_estbscs          VARCHAR2(100);
    ln_deco_adicional   NUMBER;
    ln_cargo_inst       NUMBER;
    lv_codigo_occ_bscs  NUMBER;
    ln_customerid       NUMBER;
    av_trama            CLOB;
    ln_idinteraccion    NUMBER;
    ln_cargo_fijo       NUMBER;
    lv_occ_bscs         INTEGER;
    ln_cargo_recurrente VARCHAR2(50);
    ln_val_cnr          number;

    CURSOR c_servicios_deco IS
      SELECT t.*
        FROM sales.sisact_postventa_det_serv_hfc t
       WHERE t.idinteraccion = ln_idinteraccion
         AND t.dscequ IS NOT NULL;

    CURSOR c_tipequ_deco IS
      SELECT d.codigon
        FROM tipopedd c, opedd d
       WHERE c.abrev = 'TIPEQU_DECO_LTE'
         AND d.tipopedd = (SELECT x.tipopedd
                             FROM tipopedd x
                            WHERE x.abrev = 'TIPEQU_DECO_LTE');

    CURSOR c_pid IS
      select ip.pid
        from operacion.insprd ip
       where ip.pid in (SELECT sp.pid
                          FROM operacion.solotpto sp
                         WHERE sp.codsolot = ln_sot)
         and ip.flgprinc = 0
      minus
      -- Cursor de Equipos para Costos Recurrente en BSCS
      select i.pid
        from operacion.solotpto   sp,
             operacion.insprd     i,
             operacion.equcomxope eco
       where sp.pid = i.pid
         and i.flgprinc = 0
         and i.codequcom = eco.codequcom
         and eco.tipequ in
             (SELECT crm.codigon
                FROM sales.crmdd crm
               WHERE crm.tipcrmdd IN
                     (SELECT tip.tipcrmdd
                        FROM sales.tipcrmdd tip
                       WHERE tip.abrev = 'DTHPOSTEQU'))
         and sp.codsolot = ln_sot;

    CURSOR c_inssrv IS
      SELECT i.codinssrv, i.tipsrv
        FROM operacion.inssrv i
       WHERE i.codinssrv IN (SELECT sp.codinssrv
                               FROM operacion.solotpto sp
                              WHERE sp.codsolot = ln_sot);
    CURSOR c_equ_bscs IS
      SELECT a.nro_serie_deco,
             a.nro_serie_tarjeta,
             a.tipo_equipo,
             a.modelo_equipo
        FROM (SELECT DISTINCT asoc.nro_serie_deco,
                              asoc.nro_serie_tarjeta,
                              (SELECT DISTINCT nvl(crm.abreviacion, '')
                                 FROM sales.crmdd crm
                                WHERE se.tipequ = to_number(crm.codigon)) tipo_equipo,
                              (SELECT DISTINCT nvl(crm.descripcion, '')
                                 FROM sales.crmdd crm
                                WHERE se.tipequ = to_number(crm.codigon)) modelo_equipo
                FROM operacion.tarjeta_deco_asoc asoc,
                     operacion.solotptoequ       se,
                     operacion.tipequ            tieq
               WHERE asoc.codsolot = se.codsolot
                 AND se.mac = asoc.nro_serie_deco
                 AND se.tipequ = to_number(tieq.tipequ)
                 AND (se.tipequ) IN
                     (SELECT crm.codigon
                        FROM sales.crmdd crm
                       WHERE crm.tipcrmdd IN
                             (SELECT tip.tipcrmdd
                                FROM sales.tipcrmdd tip
                               WHERE tip.abrev = 'DTHPOSTEQU'))
                 AND asoc.codsolot = ln_sot) a;
    CURSOR c_solotpequ IS
      SELECT spe.numserie
        FROM operacion.solotptoequ spe
       WHERE spe.codsolot = ln_sot
         AND spe.numserie IS NOT NULL;

    cursor c_val_cr_bscs is
      select i.pid,
             i.estinsprd,
             eco.tipequ,
             (select spds.sncode
                from sales.sisact_postventa_det_serv_hfc spds
               where spds.tipequ = eco.tipequ
                 and spds.idinteraccion =
                     (select spl.idinteraccion
                        from sales.siac_postventa_lte spl
                       where spl.codsolot = sp.codsolot)) sncode
        from operacion.solotpto   sp,
             operacion.insprd     i,
             operacion.equcomxope eco
       where sp.pid = i.pid
         and i.codequcom = eco.codequcom
         and i.flgprinc = 0
         and eco.tipequ in
             (SELECT crm.codigon
                FROM sales.crmdd crm
               WHERE crm.tipcrmdd IN
                     (SELECT tip.tipcrmdd
                        FROM sales.tipcrmdd tip
                       WHERE tip.abrev = 'DTHPOSTEQU'))
         and sp.codsolot = ln_sot;

    -- Ini 16.0
    cursor c_reg_servicio is
      select spds.sncode
        from sales.sisact_postventa_det_serv_hfc spds
       where spds.idinteraccion =
             (select spl.idinteraccion
                from sales.siac_postventa_lte spl
               where spl.codsolot = ln_sot)
         and spds.tipequ in
             (SELECT crm.codigon
                FROM sales.crmdd crm
               WHERE crm.tipcrmdd IN
                     (SELECT tip.tipcrmdd
                        FROM sales.tipcrmdd tip
                       WHERE tip.abrev = 'DTHPOSTEQU'));

    cursor c_reg_pid_serv is
      select i.pid
        from operacion.solotpto   sp,
             operacion.insprd     i,
             operacion.equcomxope eco
       where sp.pid = i.pid
         and i.codequcom = eco.codequcom
         and i.flgprinc = 0
         and i.estinsprd <> 1
         and eco.tipequ in
             (SELECT crm.codigon
                FROM sales.crmdd crm
               WHERE crm.tipcrmdd IN
                     (SELECT tip.tipcrmdd
                        FROM sales.tipcrmdd tip
                       WHERE tip.abrev = 'DTHPOSTEQU'))
         and sp.codsolot = ln_sot;
    -- Fin 16.0

  BEGIN

    SELECT w.codsolot INTO ln_sot FROM wf w WHERE w.idwf = a_idwf;

    SELECT COUNT(1)
      INTO n_cont
      FROM operacion.inssrv i
     WHERE i.codinssrv IN (SELECT sp.codinssrv
                             FROM operacion.solotpto sp
                            WHERE sp.codsolot = ln_sot);

    IF n_cont > 0 THEN
      SELECT a.cod_id, a.customer_id, a.estsol, a.cargo
        INTO ln_cod_id, ln_customerid, ln_estsol, ln_cargo_inst
        FROM operacion.solot a
       WHERE a.codsolot = ln_sot;

      -- Actualizar Insprd de SGA
      FOR cx IN c_pid LOOP
        UPDATE operacion.insprd SET estinsprd = 1 WHERE pid = cx.pid;
      END LOOP;

      -- Actualizar Servicios de SGA
      FOR c1 IN c_inssrv LOOP

        UPDATE operacion.inssrv
           SET estinssrv = 1
         WHERE codinssrv = c1.codinssrv;

        IF c1.tipsrv = '0062' THEN

          -- Insertar Equipos a BSCS
          FOR c1 IN c_equ_bscs LOOP
            p_registra_deco_lte(ln_cod_id,
                                c1.nro_serie_deco,
                                c1.nro_serie_tarjeta,
                                c1.tipo_equipo,
                                c1.modelo_equipo,
                                ln_resp,
                                lv_mensaje);

            IF ln_resp <> 0 THEN
              raise_application_error(-20500,
                                      'tim.pp021_venta_lte.sp_registra_deco_lte: ' ||
                                      lv_mensaje);
            END IF;
          END LOOP;

        END IF;

      END LOOP;
      -- Actualizar Los numeros de Serie de los Equipos
      FOR c1 IN c_solotpequ LOOP
        UPDATE operacion.tabequipo_material tm
           SET estado = 1
         WHERE TRIM(tm.numero_serie) = TRIM(c1.numserie);
      END LOOP;

      -- INI 16.0
      BEGIN
        SELECT S.IDINTERACCION
          INTO LN_IDINTERACCION
          FROM SALES.SIAC_POSTVENTA_LTE S
         WHERE S.CODSOLOT = LN_SOT;

        -- Registro Cargo Recurrente de Deco Adicional
        FOR C_VAL_BSCS IN C_VAL_CR_BSCS LOOP
          IF C_VAL_BSCS.ESTINSPRD <> 1 THEN
            LV_OCC_BSCS         := TO_NUMBER(C_VAL_BSCS.SNCODE);
            LN_CARGO_RECURRENTE := TIM.TFUN003_REGISTER_SERVICE@DBL_BSCS_BF(LN_COD_ID,
                                                                            NULL,
                                                                            NULL,
                                                                            LV_OCC_BSCS,
                                                                            '1');
            IF LN_CARGO_RECURRENTE = '0' THEN
              -- ACTUALIZAR PID PRINCIPAL PARA SABER SI SE ENVIO A BSCS  EL CARGO RECURRENTE
              P_ACT_PID_X_BSCS(C_VAL_BSCS.PID, LN_RESP, LV_MENSAJE);
            ELSE
              P_LOG_3PLAYI(LN_SOT,
                           'TIM.TFUN003_REGISTER_SERVICE@DBL_BSCS_BF',
                           'ERROR CARGO RECURRENTE',
                           'VALIDACION SERVICIOS DECO ADICIONAL',
                           LN_RESP,
                           LN_CARGO_RECURRENTE);
              EXIT;
            END IF;
          END IF;
        END LOOP;
      EXCEPTION
        WHEN OTHERS THEN
          BEGIN
            FOR C_REG_SERV IN C_REG_SERVICIO LOOP
              LV_OCC_BSCS := TO_NUMBER(C_REG_SERV.SNCODE);
              -- Registra Servicios en BSCS
              LN_CARGO_RECURRENTE := TIM.TFUN003_REGISTER_SERVICE@DBL_BSCS_BF(LN_COD_ID,
                                                                              NULL,
                                                                              NULL,
                                                                              LV_OCC_BSCS,
                                                                              '1');
              IF LN_CARGO_RECURRENTE <> '0' THEN
                -- Registra Error
                P_LOG_3PLAYI(LN_SOT,
                             'TIM.TFUN003_REGISTER_SERVICE@DBL_BSCS_BF',
                             'ERROR CARGO RECURRENTE',
                             'VALIDACION SERVICIOS DECO ADICIONAL',
                             LN_RESP,
                             LN_CARGO_RECURRENTE);
                EXIT;
              END IF;
            END LOOP;
            -- Actualiza Instancias de Producto
            FOR C_REG_PID IN C_REG_PID_SERV LOOP
              P_ACT_PID_X_BSCS(C_REG_PID.PID, LN_RESP, LV_MENSAJE);
            END LOOP;
          EXCEPTION
            WHEN OTHERS THEN
              -- Registra Error
              P_LOG_3PLAYI(LN_SOT,
                           'TIM.TFUN003_REGISTER_SERVICE@DBL_BSCS_BF',
                           'ERROR CARGO RECURRENTE',
                           'VALIDACION SERVICIOS DECO ADICIONAL',
                           LN_RESP,
                           LN_CARGO_RECURRENTE);
          END;
      END;
      -- FIN 16.0

      -- Verificando el Estado de SOT para cambiar a Atendido
      IF ln_estsol <> 29 THEN
        operacion.pq_solot.p_chg_estado_solot(ln_sot, 29);
      END IF;

      SELECT s.estsol
        INTO ln_estsolact
        FROM solot s
       WHERE s.codsolot = ln_sot;

      --REGISTRO OCC INSTALACION - Cargo no Recurrente
      IF ln_estsolact = 29 THEN
        IF ln_cargo_inst IS NOT NULL THEN
          IF ln_cargo_inst > 0 THEN
            select count(1)
              into ln_val_cnr
              from operacion.insprd ip
             where ip.pid in (select pid
                                from operacion.solotpto sp
                               where sp.codsolot = ln_sot)
               and ip.estinsprd = 1
               and ip.flgprinc = 1;
            if ln_val_cnr = 0 then
              -- INI 16.0
              BEGIN
                -- Consultar el Codigo de OCC de BSCS enviado por SIAC
                SELECT spl.codigo_occ
                  INTO lv_codigo_occ_bscs
                  FROM sales.siac_postventa_lte spl
                 WHERE spl.codsolot = ln_sot;
                -- Invocacion de Web Service de OCC
                sales.pq_siac_postventa_lte.p_insert_occ(ln_customerid,
                                                         ln_sot,
                                                         lv_codigo_occ_bscs,
                                                         '1',
                                                         ln_cargo_inst,
                                                         av_trama,
                                                         ln_resp,
                                                         lv_mensaje);

                if ln_resp = 1 then
                  select ip.pid
                    into ln_val_cnr
                    from operacion.insprd ip
                   where ip.pid in (select pid
                                      from operacion.solotpto sp
                                     where sp.codsolot = ln_sot)
                     and ip.flgprinc = 1;
                  -- Actualizar Pid(s) para saber si se envio a BSCS el cargo no recurrente
                  p_act_pid_x_bscs(ln_val_cnr, ln_resp, lv_mensaje);
                else
                  P_LOG_3PLAYI(LN_SOT,
                               'TIM.TFUN003_REGISTER_SERVICE@DBL_BSCS_BF',
                               'ERROR WEB SERVICE OCC',
                               'VALIDACION SERVICIOS DECO ADICIONAL',
                               LN_RESP,
                               LV_MENSAJE);
                end if;

              EXCEPTION
                WHEN OTHERS THEN
                  P_LOG_3PLAYI(LN_SOT,
                               'TIM.TFUN003_REGISTER_SERVICE@DBL_BSCS_BF',
                               'ERROR WEB SERVICE OCC',
                               'VALIDACION SERVICIOS DECO ADICIONAL',
                               LN_RESP,
                               LV_MENSAJE);
              END;
              -- FIN 16.0
            end if;
          END IF;
        END IF;
      END IF;
    ELSE
      raise_application_error(-20001,
                              'Error al validar servicio Deco adicional  : Se debe de tener Servicios Asociados');
    END IF;

    p_log_3playi(ln_sot,
                 'p_validar_servicio_deco_adc',
                 'OK',
                 'Cierre de Validación de Servicios Inalámbricos Post',
                 ln_cod1,
                 lv_resul);

  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      lv_mensaje := SQLERRM;
      p_log_3playi(ln_sot,
                   'p_validar_servicio_deco_adc',
                   lv_mensaje,
                   'Cierre de Validación de Servicios Inalámbricos Post',
                   ln_cod1,
                   lv_resul);
      raise_application_error(-20001,
                              'Error al validar servicio Deco adicional  : ' ||
                              SQLERRM);
  END;
  PROCEDURE p_act_pid_x_bscs(p_pid     in number,
                             p_cod     out number,
                             p_mensaje out varchar2) IS
    PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    P_COD     := 0;
    P_MENSAJE := 'Exito';
    update operacion.insprd ip set estinsprd = 1 where ip.pid = p_pid;
    commit;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      P_COD     := -1;
      P_MENSAJE := SQLERRM;
  END;
  /************************************************************************************************/
  --<fin 12.0>
  -- Ini 14.0
  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        21/11/2016  Luis Guzmán      Validación de Servicios Contratados
  ******************************************************************************/
  PROCEDURE sgass_srv_cnt(p_codsolot     IN NUMBER,
                          p_cod_id       OUT VARCHAR2,
                          p_tip_serv     OUT VARCHAR2,
                          p_codigo_resp  OUT NUMBER,
                          p_mensaje_resp OUT VARCHAR2)

   IS

    ln_count_cb NUMBER;
    ln_count_te NUMBER;
    ln_count_it NUMBER;

  BEGIN

    p_codigo_resp := 1;

    --VALIDACION DE CONTRATO
    BEGIN
      select s.cod_id
        into p_cod_id
        from operacion.solot s
       where s.codsolot = p_codsolot;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        p_cod_id := null;
    END;

    IF p_cod_id IS NULL THEN
      p_mensaje_resp := 'No tiene contratado asociado';
      RETURN;
    END IF;

    --VALIDACION DEL LOS SERVICIOS CONTRATADOS - CABLE
    select count(1)
      into ln_count_cb
      from operacion.inssrv i
     where i.codinssrv in (select sp.codinssrv
                             from operacion.solotpto sp
                            where sp.codsolot = p_codsolot)
       and i.tipsrv IN (select c.valor
                          from operacion.constante c
                         where constante in ('FAM_CABLE'));

    --VALIDACION DEL LOS SERVICIOS CONTRATADOS - TELEFONIA
    select count(1)
      into ln_count_te
      from operacion.inssrv i
     where i.codinssrv in (select sp.codinssrv
                             from operacion.solotpto sp
                            where sp.codsolot = p_codsolot)
       and i.tipsrv IN (select c.valor
                          from operacion.constante c
                         where constante in ('FAM_TELEF'));

    --VALIDACION DEL LOS SERVICIOS CONTRATADOS - INTERNET
    select count(1)
      into ln_count_it
      from operacion.inssrv i
     where i.codinssrv in (select sp.codinssrv
                             from operacion.solotpto sp
                            where sp.codsolot = p_codsolot)
       and i.tipsrv IN (select c.valor
                          from operacion.constante c
                         where constante in ('FAM_INTERNET'));

    IF ln_count_cb > 0 AND ln_count_te > 0 AND ln_count_it > 0 THEN
      p_tip_serv := 'TP'; --AMBOS SERVICIOS (CABLE, TELEFONIA Y INTERNET)
    ELSIF ln_count_cb > 0 AND ln_count_it > 0 THEN
      p_tip_serv := 'CI'; --SOLO CABLE Y INTERNET
    ELSIF ln_count_cb > 0 AND ln_count_te > 0 THEN
      p_tip_serv := 'CT'; --SOLO CABLE Y TELEFONO INTERNET
    ELSIF ln_count_te > 0 AND ln_count_it > 0 THEN
      p_tip_serv := 'TI'; --SOLO TELEFONO Y/O INTERNET
    ELSIF ln_count_cb > 0 THEN
      p_tip_serv := 'CB'; --SOLO CABLE
    ELSIF ln_count_te > 0 THEN
      p_tip_serv := 'TE'; --SOLO TELEFONO
    ELSIF ln_count_it > 0 THEN
      p_tip_serv := 'IT'; --SOLO INTERNET
    ELSE
      p_tip_serv     := null;
      p_mensaje_resp := 'No tiene ningun servicio contratado';
    END IF;

    IF p_tip_serv IS NULL AND p_cod_id IS NULL THEN
      p_codigo_resp  := -1;
      p_mensaje_resp := 'No cuenta con contrato asociado y tampoco con algún con servicio';
    END IF;

  END;
  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        21/11/2016  Luis Guzmán      Insercion en la tabla PSGAT_ESTSERVICIO
  ******************************************************************************/
  PROCEDURE sgasi_serv_x_cliente(p_codsolot       IN NUMBER,
                                 p_tipo_operacion IN VARCHAR2,
                                 p_codigo_resp    OUT NUMBER,
                                 p_mensaje_resp   OUT VARCHAR2) IS
    pragma autonomous_transaction;

    ln_customer_id number;
    ln_cod_id      number;
    lv_codcli      char(8);
    lv_descrip     varchar2(100);
    ln_tiempo_act  number;
    ln_tiempo_ree  number;
    ln_numero_ree  number;
    ln_count       number;

  BEGIN

    p_codigo_resp := 1;

    BEGIN
      select s.customer_id, s.cod_id, s.codcli
        into ln_customer_id, ln_cod_id, lv_codcli
        from operacion.solot s
       where s.codsolot = p_codsolot;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        p_codigo_resp  := -1;
        p_mensaje_resp := 'No existe la SOT';
        RETURN;
    END;

    IF ln_customer_id IS NULL THEN
      p_codigo_resp  := -1;
      p_mensaje_resp := 'No existe datos de la Customer ID';
      RETURN;
    END IF;

    IF ln_cod_id IS NULL THEN
      p_codigo_resp  := -1;
      p_mensaje_resp := 'No existe datos de la COD ID';
      RETURN;
    END IF;

    IF lv_codcli IS NULL THEN
      p_codigo_resp  := -1;
      p_mensaje_resp := 'No existe datos de la Cod. Cliente';
      RETURN;
    END IF;

    BEGIN
      select b.descripcion
        into lv_descrip
        from tipopedd a, opedd b
       where a.tipopedd = b.tipopedd
         and a.abrev = 'EST_GEST_PROV'
         and b.abreviacion = 'NPRV';
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        p_codigo_resp  := -1;
        p_mensaje_resp := 'No existe el estado en la tabla de parametros';
        RETURN;
    END;

    sgass_parametros('CONFG_TIP_PROV',
                     ln_tiempo_act,
                     ln_tiempo_ree,
                     ln_numero_ree,
                     p_codigo_resp,
                     p_mensaje_resp);

    IF p_codigo_resp = -1 THEN
      RETURN;
    END IF;

    IF p_tipo_operacion = 'TP' OR p_tipo_operacion = 'CX' OR
       p_tipo_operacion = 'CI' THEN

      select count(1)
        into ln_count
        from operacion.psgat_estservicio e
       where e.essen_cod_solot = p_codsolot
         and e.essev_cod_operacion = 'CX';

      IF ln_count = 0 THEN
        insert into operacion.psgat_estservicio
          (essev_cod_operacion,
           essen_cod_solot,
           essev_customer_id,
           essen_co_id,
           essen_cod_cli,
           essev_mensaje,
           essev_descripcion,
           essev_operacion,
           essev_estado,
           essen_n_reenvio,
           essen_n_reenvio_max)
        values
          ('CX',
           p_codsolot,
           ln_customer_id,
           ln_cod_id,
           lv_codcli,
           null,
           'Proceso de Conax',
           lv_descrip,
           'NPRV',
           0,
           ln_numero_ree);

        sgasi_logaprov(p_codsolot,
                       'NPRV',
                       'CX',
                       'INS',
                       null,
                       p_codigo_resp,
                       p_mensaje_resp); --15.0
      END IF;

    END IF;

    IF p_tipo_operacion = 'TP' OR p_tipo_operacion = 'IJ' OR
       p_tipo_operacion = 'CI' OR p_tipo_operacion = 'IL' THEN

      select count(1)
        into ln_count
        from operacion.psgat_estservicio e
       where e.essen_cod_solot = p_codsolot
         and e.essev_cod_operacion = 'IL';

      IF ln_count = 0 THEN
        insert into operacion.psgat_estservicio
          (essev_cod_operacion,
           essen_cod_solot,
           essev_customer_id,
           essen_co_id,
           essen_cod_cli,
           essev_mensaje,
           essev_descripcion,
           essev_operacion,
           essev_estado,
           essen_n_reenvio,
           essen_n_reenvio_max)
        values
          ('IL',
           p_codsolot,
           ln_customer_id,
           ln_cod_id,
           lv_codcli,
           null,
           'Proceso de IL',
           lv_descrip,
           'NPRV',
           0,
           ln_numero_ree);

        sgasi_logaprov(p_codsolot,
                       'NPRV',
                       'IL',
                       'INS',
                       null,
                       p_codigo_resp,
                       p_mensaje_resp); --15.0

      END IF;

      IF p_tipo_operacion <> 'IL' THEN

        select count(1)
          into ln_count
          from operacion.psgat_estservicio e
         where e.essen_cod_solot = p_codsolot
           and e.essev_cod_operacion = 'JN';

        IF ln_count = 0 THEN
          insert into operacion.psgat_estservicio
            (essev_cod_operacion,
             essen_cod_solot,
             essev_customer_id,
             essen_co_id,
             essen_cod_cli,
             essev_mensaje,
             essev_descripcion,
             essev_operacion,
             essev_estado,
             essen_n_reenvio,
             essen_n_reenvio_max)
          values
            ('JN',
             p_codsolot,
             ln_customer_id,
             ln_cod_id,
             lv_codcli,
             null,
             'Proceso de Janus',
             lv_descrip,
             'NPRV',
             0,
             ln_numero_ree);

          sgasi_logaprov(p_codsolot,
                         'NPRV',
                         'JN',
                         'INS',
                         null,
                         p_codigo_resp,
                         p_mensaje_resp); --15.0

        END IF;
      END IF;

    END IF;

    COMMIT;

  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      p_codigo_resp  := -1;
      p_mensaje_resp := 'Error al update operacion.psgat_estservicio: ' ||
                        SQLERRM;

  END;

  /***********************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        21/11/2016  Luis Guzmán      Actulizacion en la tabla PSGAT_ESTSERVICIO
  ***********************************************************************************/
  PROCEDURE sgasu_serv_x_cliente(p_codsolot       IN NUMBER,
                                 p_tipo_operacion IN VARCHAR2,
                                 p_mensaje        IN VARCHAR2,
                                 p_estado         IN VARCHAR2,
                                 p_codigo_resp    OUT NUMBER,
                                 p_mensaje_resp   OUT VARCHAR2) IS
    pragma autonomous_transaction;

    ln_customer_id number;
    ln_cod_id      number;
    lv_codcli      char(8);
    lv_descrip     varchar2(100);
    ln_reg_log_act number;

  BEGIN

    p_codigo_resp  := 1;
    ln_reg_log_act := 0;

    BEGIN
      select b.descripcion
        into lv_descrip
        from tipopedd a, opedd b
       where a.tipopedd = b.tipopedd
         and a.abrev = 'EST_GEST_PROV'
         and b.abreviacion = p_estado;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        p_codigo_resp  := -1;
        p_mensaje_resp := 'No existe el estado en la tabla de parametros';
        RETURN;
    END;

    IF p_tipo_operacion = 'TP' THEN
      update operacion.psgat_estservicio se
         set se.essev_estado    = p_estado,
             se.essev_mensaje   = p_mensaje,
             se.essev_operacion = lv_descrip
       where se.essen_cod_solot = p_codsolot;

      sgasi_logaprov(p_codsolot,
                     p_estado,
                     'TP',
                     'UPD',
                     p_mensaje,
                     p_codigo_resp,
                     p_mensaje_resp); --15.0

    ELSE

      select count(1)
        into ln_reg_log_act
        from operacion.sgat_logaprovlte lg
       where lg.logan_codsolot = p_codsolot
         and lg.logav_tipo_trans = p_tipo_operacion
         and lg.logav_est_log = '1';

      IF ln_reg_log_act = 0 THEN

        update operacion.psgat_estservicio se
           set se.essev_estado        = p_estado,
               se.essev_mensaje       = p_mensaje,
               se.essev_operacion     = lv_descrip,
               se.essen_n_reenvio     = decode(p_estado,
                                               'NPRV1',
                                               0,
                                               se.essen_n_reenvio + 1),
               se.essed_ult_fec_reenv = sysdate
         where se.essen_cod_solot = p_codsolot
           and se.essev_cod_operacion = p_tipo_operacion;

        sgasi_logaprov(p_codsolot,
                       p_estado,
                       p_tipo_operacion,
                       'INS',
                       p_mensaje,
                       p_codigo_resp,
                       p_mensaje_resp); --15.0

      ELSE

        update operacion.psgat_estservicio se
           set se.essev_estado    = p_estado,
               se.essev_mensaje   = p_mensaje,
               se.essev_operacion = lv_descrip
         where se.essen_cod_solot = p_codsolot
           and se.essev_cod_operacion = p_tipo_operacion;

        sgasi_logaprov(p_codsolot,
                       p_estado,
                       p_tipo_operacion,
                       'UPD',
                       p_mensaje,
                       p_codigo_resp,
                       p_mensaje_resp); --15.0

      END IF;
    END IF;

    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      p_codigo_resp  := -1;
      p_mensaje_resp := 'Error al update operacion.psgat_estservicio: ' ||
                        SQLERRM;

  END;

  /*********************************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        21/11/2016  Luis Guzmán      Valida el estado actual de la provision DTH-IL-JANUS
  *********************************************************************************************/
  PROCEDURE sgass_conci_srv(p_codsolot       IN NUMBER,
                            p_tipo_operacion IN VARCHAR2,
                            p_codigo_resp    OUT NUMBER,
                            p_mensaje_resp   OUT VARCHAR2) IS

    ln_count       NUMBER;
    ln_count_tot   NUMBER;
    ln_estado      NUMBER;
    lv_mensaje     VARCHAR2(100);
    lv_cod_msj     VARCHAR2(20);
    ln_cod_msj     NUMBER;
    ln_cod_id      NUMBER;
    lv_numregistro CHAR(10);
    ln_est_janus   VARCHAR2(10);

  BEGIN
    p_codigo_resp := 1;
    ln_estado     := 0;

    CASE p_tipo_operacion
      WHEN 'CX' THEN
        select os.numregistro
          into lv_numregistro
          from operacion.ope_srv_recarga_cab os
         where os.codsolot = p_codsolot;

        OPERACION.PKG_CONTEGO.SGASS_VALIDARALTA(lv_numregistro,
                                                lv_cod_msj,
                                                p_mensaje_resp); --v18.0

        IF lv_cod_msj <> 'OK' THEN
          p_codigo_resp := -1;
          sgasu_serv_x_cliente(p_codsolot,
                               p_tipo_operacion,
                               p_mensaje_resp,
                               'ERRO',
                               p_codigo_resp,
                               p_mensaje_resp);
          RETURN;
        END IF;

        --v18.0
        SELECT count(*)
          INTO ln_count_tot
          FROM operacion.sgat_trxcontego a
         WHERE a.trxn_codsolot = p_codsolot;

        --v18.0
        SELECT count(*)
          INTO ln_count
          FROM operacion.sgat_trxcontego a
         WHERE a.trxc_estado IN (4, 5)
           AND a.trxn_codsolot = p_codsolot;

        IF ln_count > 0 THEN
          ln_estado  := 2;
          lv_mensaje := 'Algunos Bucket no fueron procesados correctamente';
        ELSE
          --v18.0
          SELECT count(*)
            INTO ln_count
            FROM operacion.sgat_trxcontego a
           WHERE a.trxc_estado = 3
             AND a.trxn_codsolot = p_codsolot;

          IF ln_count = ln_count_tot THEN
            ln_estado  := 1;
            lv_mensaje := 'Los Bucket fueron procesados correctamente';
          END IF;
        END IF;

      WHEN 'IL' THEN
        select s.cod_id
          into ln_cod_id
          from operacion.solot s
         where s.codsolot = p_codsolot;

        p_estado_prov_inst(ln_cod_id, ln_cod_msj, p_mensaje_resp);
        --( 0 = Proceso Satisfactorio, -1 = Error o Cancelado, -2 = No Existe, -3 = Pendiente)

        IF ln_cod_msj = 0 THEN
          ln_estado := 1;
        ELSIF ln_cod_msj = -1 or ln_cod_msj = -2 THEN
          --15.00
          ln_estado := 2;
        END IF;

      WHEN 'JN' THEN
        select s.cod_id
          into ln_cod_id
          from operacion.solot s
         where s.codsolot = p_codsolot;

        sgass_estado_prov_janus(ln_cod_id,
                                p_codigo_resp,
                                p_mensaje_resp,
                                ln_est_janus);
        --(2 = ESTADO POR PROCESAR , 3 = INCONSISTENCIA, 4 = EN PROCESO DE PROVISION,  5 = PROVISION EXITOSA, 6 = ERROR DE PROVISIÓN, -99=NO EXISTE REGISTRO)

        IF p_codigo_resp <> 0 THEN
          sgasu_serv_x_cliente(p_codsolot,
                               p_tipo_operacion,
                               p_mensaje_resp,
                               'ERRO',
                               p_codigo_resp,
                               p_mensaje_resp);
          RETURN;
        END IF;

        IF ln_est_janus = 5 THEN
          ln_estado := 1;
        ELSIF ln_est_janus = 3 OR ln_est_janus = 6 OR ln_est_janus = -99 THEN
          ln_estado := 2;
        ELSE
          ln_estado := 3;
        END IF;

        lv_mensaje := p_mensaje_resp;

    END CASE;

    --PROCESO DE ACTUALIZACION DE ESTADOS
    CASE ln_estado
      WHEN 1 THEN
        sgasu_serv_x_cliente(p_codsolot,
                             p_tipo_operacion,
                             null,
                             'PROV',
                             p_codigo_resp,
                             p_mensaje_resp);
      WHEN 2 THEN
        sgasu_serv_x_cliente(p_codsolot,
                             p_tipo_operacion,
                             lv_mensaje,
                             'ERRO',
                             p_codigo_resp,
                             p_mensaje_resp);
      WHEN 3 THEN
        sgasu_serv_x_cliente(p_codsolot,
                             p_tipo_operacion,
                             lv_mensaje,
                             'EPLA',
                             p_codigo_resp,
                             p_mensaje_resp);
      ELSE
        p_codigo_resp := 1;
        RETURN;
    END CASE;
  END;

  /*********************************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        21/11/2016  Luis Guzmán      Recupera parametros de los tiempo y numero de reenvio
  *********************************************************************************************/
  PROCEDURE sgass_parametros(p_parametro    IN VARCHAR2,
                             p_tiempo_act   OUT NUMBER,
                             p_tiempo_reen  OUT NUMBER,
                             p_num_reenvio  OUT NUMBER,
                             p_codigo_resp  OUT NUMBER,
                             p_mensaje_resp OUT VARCHAR2) IS

    ln_tiempo   NUMBER;
    lv_segundos VARCHAR2(10);

  BEGIN

    p_codigo_resp := 1;

    --CONSULTA DE TIEMPO DE ACTULIZACION DE LOS ESTADOS
    IF p_parametro = 'CONFG_TIP_PROV' THEN
      BEGIN
        select b.codigon, b.codigoc
          into ln_tiempo, lv_segundos
          from tipopedd a, opedd b
         where a.tipopedd = b.tipopedd
           and a.abrev = p_parametro
           and b.abreviacion = 'ACTEST';
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          p_codigo_resp  := -1;
          p_mensaje_resp := 'No existe configuración del tiempo de actualización de estados';
          RETURN;
      END;

      IF UPPER(lv_segundos) = 'MIN' THEN
        p_tiempo_act := ln_tiempo * 60;
      ELSIF UPPER(lv_segundos) = 'SEG' THEN
        p_tiempo_act := ln_tiempo;
      ELSE
        p_codigo_resp  := -1;
        p_mensaje_resp := 'No esta configurado el tipo de tiempo, solo se acepta(MIN - SEG)';
        RETURN;
      END IF;

      IF ln_tiempo IS NULL THEN
        p_codigo_resp  := -1;
        p_mensaje_resp := 'No esta configurado el tiempo de actualización';
        RETURN;
      END IF;
    ELSE
      p_tiempo_act := 0;
    END IF;

    --CONSULTA DE TIEMPO DE LOS REENVIOS
    BEGIN
      select b.codigon, b.codigoc
        into ln_tiempo, lv_segundos
        from tipopedd a, opedd b
       where a.tipopedd = b.tipopedd
         and a.abrev = p_parametro
         and b.abreviacion = 'TIEREE';
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        p_codigo_resp  := -1;
        p_mensaje_resp := 'No existe configuración del tiempo de reenvio';
        RETURN;
    END;

    IF UPPER(lv_segundos) = 'MIN' THEN
      p_tiempo_reen := ln_tiempo * 60;
    ELSIF UPPER(lv_segundos) = 'SEG' THEN
      p_tiempo_reen := ln_tiempo;
    ELSE
      p_codigo_resp  := -1;
      p_mensaje_resp := 'No esta configurado el tipo de tiempo, solo se acepta(MIN - SEG)';
      RETURN;
    END IF;

    IF ln_tiempo IS NULL THEN
      p_codigo_resp  := -1;
      p_mensaje_resp := 'No esta configurado el tiempo de reenvio';
      RETURN;
    END IF;

    --CONSULTA DE NUMERO DE REENVIOS
    BEGIN
      select b.codigon
        into p_num_reenvio
        from tipopedd a, opedd b
       where a.tipopedd = b.tipopedd
         and a.abrev = p_parametro
         and b.abreviacion = 'NUMREE';
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        p_codigo_resp  := -1;
        p_mensaje_resp := 'No existe configuración del numero de reenvio';
        RETURN;
    END;

    IF p_num_reenvio IS NULL THEN
      p_codigo_resp  := -1;
      p_mensaje_resp := 'No esta configurado el numero de reenvio';
      RETURN;
    END IF;
  END;

  /*********************************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        21/11/2016  Luis Guzmán      Inserta y actualiza la tabla SGAT_LOGAPROVLTE
  *********************************************************************************************/
  PROCEDURE sgasi_logaprov(p_codsolot     IN NUMBER,
                           p_estado       IN VARCHAR2,
                           p_tipo_trans   IN VARCHAR2,
                           p_accion       IN VARCHAR2,
                           p_mensaje_log  IN VARCHAR2, --15.0
                           p_codigo_resp  OUT NUMBER,
                           p_mensaje_resp OUT VARCHAR2) IS
    pragma autonomous_transaction;

    ln_log_id  NUMBER;
    ln_co_id   NUMBER;
    ln_est_sot NUMBER(2);
    lv_descrip VARCHAR2(100);

  BEGIN
    p_codigo_resp := 1;

    BEGIN
      select b.descripcion
        into lv_descrip
        from tipopedd a, opedd b
       where a.tipopedd = b.tipopedd
         and a.abrev = 'EST_GEST_PROV'
         and b.abreviacion = p_estado;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        p_codigo_resp  := -1;
        p_mensaje_resp := 'No existe el estado en la tabla de parametros';
        RETURN;
    END;

    IF p_accion = 'INS' THEN

      select operacion.psgaseq_logaprovlte.nextval
        into ln_log_id
        from dual;

      select s.cod_id, s.estsol
        into ln_co_id, ln_est_sot
        from operacion.solot s
       where s.codsolot = p_codsolot;

      insert into operacion.sgat_logaprovlte
        (logan_id,
         logan_cod_id,
         logad_fecha_reg,
         logav_estado,
         logan_estado_solot,
         logan_codsolot,
         logav_descripcion,
         logav_tipo_trans,
         logav_est_log,
         logav_mensaje) --15.0
      values
        (ln_log_id,
         ln_co_id,
         sysdate,
         p_estado,
         ln_est_sot,
         p_codsolot,
         lv_descrip,
         p_tipo_trans,
         1,
         p_mensaje_log); --15.0

    ELSIF p_accion = 'UPD' THEN

      update operacion.sgat_logaprovlte lg
         set lg.logad_fecha_ejec   = sysdate,
             lg.logav_estado       = p_estado,
             lg.logav_descripcion  = lv_descrip,
             lg.logav_usuario_modi = user,
             lg.logad_fecha_modi   = DECODE(p_estado,
                                            'PROV',
                                            sysdate,
                                            'ERRO',
                                            sysdate,
                                            NULL),
             lg.logav_est_log      = DECODE(p_estado,
                                            'PROV',
                                            0,
                                            'ERRO',
                                            0,
                                            1),
             lg.logav_mensaje      = p_mensaje_log --15.00
       where lg.logan_codsolot = p_codsolot
         and lg.logav_tipo_trans LIKE
             DECODE(p_tipo_trans, 'TP', '%', p_tipo_trans)
         and lg.logav_est_log = 1;

    END IF;

    COMMIT;

  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      p_codigo_resp  := -1;
      p_mensaje_resp := 'Error al registrar operacion.sgat_logaprovlte: ' ||
                        SQLERRM;
  END;

  /*********************************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        21/11/2016  Luis Guzmán      Validamos serie del Deco y Tarjeta SIM
  *********************************************************************************************/
  PROCEDURE sgass_validar_deco_tar(p_codsolot     IN NUMBER,
                                   p_numserie     IN VARCHAR2,
                                   p_tipequ       IN NUMBER,
                                   p_codigo_resp  OUT NUMBER,
                                   p_mensaje_resp OUT VARCHAR2)

   IS

    ln_count NUMBER;

  BEGIN
    p_codigo_resp := 1;

    --VALIDAMOS QUE LA SERIE NO SE ENCUENTRE EN OTRA SOT
    select count(1)
      into ln_count
      from operacion.solot s, operacion.solotptoequ se
     where se.codsolot = s.codsolot
       and s.codsolot not in (p_codsolot)
       and se.numserie in (p_numserie)
       and se.tipequ = p_tipequ
       and s.estsol not in
           (select es.estsol from estsol es where tipestsol = 5);

    IF ln_count > 0 THEN
      p_codigo_resp  := -1;
      p_mensaje_resp := 'La serie ' || p_numserie ||
                        ' se encuentra registrada en otra SOT';
    END IF;

    --VALIDAMOS LA ASOCIACION DE LA SERIE DEL DECO
    select count(1)
      into ln_count
      from operacion.tarjeta_deco_asoc da
     where da.codsolot = p_codsolot
       and da.nro_serie_deco = p_numserie;

    IF ln_count > 1 THEN
      p_codigo_resp  := -1;
      p_mensaje_resp := 'La serie ' || p_numserie ||
                        ' ya se encuentra duplicada con otra tarjeta';
    END IF;

    --VALIDAMOS LA ASOCIACION DE LA SERIE DE LA TARJETA
    select count(1)
      into ln_count
      from operacion.tarjeta_deco_asoc da
     where da.codsolot = p_codsolot
       and da.nro_serie_tarjeta = p_numserie;

    IF ln_count > 1 THEN
      p_codigo_resp  := -1;
      p_mensaje_resp := 'La serie ' || p_numserie ||
                        ' ya se encuentra duplicada con otro decodificador';
    END IF;

    p_codigo_resp  := 1;
    p_mensaje_resp := '';

  END;

  /*********************************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        21/11/2016  Luis Guzmán      Validamos Numero de telefono
  *********************************************************************************************/
  PROCEDURE sgass_vali_telefono(p_codsolot      IN NUMBER,
                                p_num_serie_tel IN VARCHAR2,
                                p_tipequ        IN NUMBER,
                                p_tipope        IN VARCHAR2,
                                p_codigo_resp   OUT NUMBER,
                                p_mensaje_resp  OUT VARCHAR2) IS

    ln_count NUMBER;

  BEGIN

    p_codigo_resp := 1;

    IF p_tipope = 'NSERIE' THEN
      --VALIDAMOS QUE LA SERIE NO SE ENCUENTRE EN OTRA SOT
      select count(1)
        into ln_count
        from operacion.solot s, operacion.solotptoequ se
       where se.codsolot = s.codsolot
         and s.codsolot not in (p_codsolot)
         and se.numserie = p_num_serie_tel
         and se.tipequ = p_tipequ
         and s.estsol not in
             (select es.estsol from estsol es where tipestsol = 5);

      IF ln_count > 0 THEN
        p_codigo_resp  := -1;
        p_mensaje_resp := 'ERROR: Número de serie ya se encuentra registrado';
      END IF;

    ELSIF p_tipope = 'NTELF' THEN
      --VALIDAMOS QUE EL NUMERO SE ENCUENTRE DISPONIBLE
      select count(1)
        into ln_count
        from telefonia.numtel nt
       where nt.numero = p_num_serie_tel
         and nt.estnumtel <> 1;

      IF ln_count > 0 THEN
        p_codigo_resp  := -1;
        p_mensaje_resp := 'ERROR: Número Telefonico ya se encuentra registrado';
      END IF;

      --VALIDAMOS QUE NO EXISTA RESERVAS
      select count(1)
        into ln_count
        from telefonia.reservatel rt
       where rt.codnumtel in (select nt.codnumtel
                                from telefonia.numtel nt
                               where nt.numero = p_num_serie_tel
                                 and nt.estnumtel = 1);

      IF ln_count > 0 THEN
        p_codigo_resp  := -1;
        p_mensaje_resp := 'ERROR: Número Telefonico ya se encuentra registrado';
      END IF;
    END IF;

    p_codigo_resp  := 1;
    p_mensaje_resp := '';

  END;

  /*********************************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        21/11/2016  Luis Guzmán      Validamos el SIMCARD y CPE
  *********************************************************************************************/
  PROCEDURE sgass_equi_instan(p_codsolot     IN NUMBER,
                              p_num_serie    IN VARCHAR2,
                              p_tipequ       IN NUMBER,
                              p_codigo_resp  OUT NUMBER,
                              p_mensaje_resp OUT VARCHAR2) IS

    ln_count NUMBER;

  BEGIN
    p_codigo_resp := 1;

    --VALIDAMOS QUE LA SERIE NO SE ENCUENTRE EN OTRA SOT
    select count(1)
      into ln_count
      from operacion.solot s, operacion.solotptoequ se
     where se.codsolot = s.codsolot
       and s.codsolot not in (p_codsolot)
       and se.numserie in (p_num_serie)
       and se.tipequ = p_tipequ
       and s.estsol not in
           (select es.estsol from estsol es where tipestsol = 5);

    IF ln_count > 0 THEN
      p_codigo_resp  := -1;
      p_mensaje_resp := 'La serie ' || p_num_serie ||
                        ' se encuentra registrada en otra SOT';
    END IF;
    --ini 15.00
    p_codigo_resp  := 1;
    p_mensaje_resp := '';
    --fin 15.00
  END;

  /*********************************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        29/11/2016  Luis Guzmán      Valida el estado de Janus
  *********************************************************************************************/
  PROCEDURE sgass_estado_prov_janus(p_co_id        IN NUMBER,
                                    p_codigo_resp  OUT INTEGER,
                                    p_mensaje_resp OUT VARCHAR2,
                                    p_est_janus    OUT VARCHAR2) IS
  BEGIN

    p_codigo_resp := 0;

    TIM.PP021_VENTA_LTE.BSCSSS_CONS_APROVJA@DBL_BSCS_BF(p_co_id,
                                                        p_mensaje_resp,
                                                        p_est_janus);
  EXCEPTION
    WHEN OTHERS THEN
      p_codigo_resp  := -1;
      p_mensaje_resp := 'Error al consultar el estado de JANUS';

  END;

  /*********************************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        30/11/2016  Luis Guzmán      Recupera el Valor con el que se creo la particion (Fecha)
  *********************************************************************************************/
  FUNCTION sgafun_recupera_date_part(p_owner     IN VARCHAR2,
                                     p_tabla     IN VARCHAR2,
                                     p_particion IN VARCHAR2) RETURN DATE IS
    lv_date   VARCHAR2(200);
    ld_date   DATE;
    lv_cadena VARCHAR2(500);

  BEGIN

    SELECT high_value
      INTO lv_date
      FROM dba_tab_partitions a
     WHERE table_owner = upper(p_owner)
       AND table_name = upper(p_tabla)
       AND partition_name = upper(p_particion);

    lv_cadena := 'select ' || lv_date || ' from dual';

    EXECUTE IMMEDIATE lv_cadena
      INTO ld_date;

    RETURN ld_date;

  END;

  /*********************************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        30/11/2016  Luis Guzmán      Genera query con la UNION de los select de las particiones
  *********************************************************************************************/
  FUNCTION sgafun_genera_query_part(p_fecini     IN VARCHAR2,
                                    p_fecfin     IN VARCHAR2,
                                    p_owner      IN VARCHAR2,
                                    p_tabla_name IN VARCHAR2) RETURN VARCHAR2 IS

    lv_fecactual    VARCHAR2(20);
    lv_fecparticion VARCHAR2(20);
    lv_fecfin       VARCHAR2(20);
    lv_cadena       VARCHAR2(4000);
    ln_min_pos      NUMBER;
    ln_max_pos      NUMBER;

  BEGIN

    SELECT MIN(partition_position)
      INTO ln_min_pos
      FROM dba_tab_partitions
     WHERE table_owner = p_owner
       AND table_name = p_tabla_name
       AND sgafun_recupera_date_part(table_owner,
                                     table_name,
                                     partition_name) - 1 >=
           to_date(p_fecini, 'DD/MM/YYYY');

    SELECT MIN(partition_position)
      INTO ln_max_pos
      FROM dba_tab_partitions
     WHERE table_owner = p_owner
       AND table_name = p_tabla_name
       AND sgafun_recupera_date_part(table_owner,
                                     table_name,
                                     partition_name) - 1 >=
           to_date(p_fecfin, 'DD/MM/YYYY');

    lv_cadena := '';

    FOR cur_par IN (SELECT partition_name
                      FROM dba_tab_partitions
                     WHERE table_owner = p_owner
                       AND table_name = p_tabla_name
                       AND partition_position BETWEEN ln_min_pos AND
                           ln_max_pos
                     ORDER BY partition_position) LOOP

      lv_cadena := lv_cadena || 'SELECT * FROM ' || p_owner || '.' ||
                   p_tabla_name || ' PARTITION(' || cur_par.partition_name ||
                   ') UNION ALL ';

    END LOOP;

    SELECT SUBSTR(lv_cadena, 1, INSTR(lv_cadena, 'UNION ALL ', -1, 1) - 1)
      INTO lv_cadena
      FROM dual;

    RETURN lv_cadena;

  END;

  /*********************************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        30/11/2016  Luis Guzmán      Reporte de Trazbilidad de Log de Provisiones
  *********************************************************************************************/
  PROCEDURE sgass_logaprov(p_codsolot IN NUMBER,
                           p_co_id    IN NUMBER,
                           p_estado   IN VARCHAR2,
                           p_fecini   IN VARCHAR2,
                           p_fecfin   IN VARCHAR2,
                           p_cursor   OUT t_cursor) IS

    lv_fecini      VARCHAR2(20);
    lv_fecfin      VARCHAR2(20);
    ld_fecini      DATE;
    lv_logaprovlte VARCHAR2(6000);
    lv_consulta    VARCHAR2(6000);
    lv_co_id       VARCHAR2(20);
    lv_codsolot    VARCHAR2(20);
    lv_estado      VARCHAR2(3);

  BEGIN

    if p_fecini = '01/01/1900' then
      SELECT MIN(lg.logad_fecha_reg)
        INTO ld_fecini
        FROM operacion.sgat_logaprovlte lg;
      lv_fecini := to_char(ld_fecini, 'DD/MM/YYYY');
    else
      lv_fecini := p_fecini;
    end if;

    if p_fecfin = '01/01/1900' then
      lv_fecfin := to_char(sysdate, 'DD/MM/YYYY');
    else
      lv_fecfin := p_fecfin;
    end if;

    if p_co_id = 0 then
      lv_co_id := '%';
    else
      lv_co_id := p_co_id;
    end if;

    if p_codsolot = 0 then
      lv_codsolot := '%';
    else
      lv_codsolot := p_codsolot;
    end if;

    if p_estado = '%' then
      lv_estado := '%';
    else
      lv_estado := p_estado;
    end if;

    lv_logaprovlte := sgafun_genera_query_part(lv_fecini,
                                               lv_fecfin,
                                               'OPERACION',
                                               'SGAT_LOGAPROVLTE');

    if lv_fecini = lv_fecfin Then

      lv_consulta := 'select lg.logan_cod_id, ' ||
                     'lg.logad_fecha_reg as fec_inicio, ' ||
                     'lg.logad_fecha_ejec as fec_fin, ' ||
                     'lg.logav_estado, ' || '(select es.descripcion ' ||
                     'from operacion.estsol es ' ||
                     'where es.estsol = lg.logan_estado_solot) as estado_sot, ' ||
                     'lg.logan_codsolot, ' || 'lg.logav_descripcion, ' ||
                     'decode(lg.logav_tipo_trans,' || '''CX''' || ',' ||
                     '''CONAX''' || ',' || '''JN''' || ',' || '''JANUS''' ||
                     ',lg.logav_tipo_trans) as tipo_trans, ' ||
                     'lg.logav_usuario_crea ' || 'from (' || lv_logaprovlte ||
                     ') lg ' || 'where lg.logan_cod_id like ''' || lv_co_id || '''' ||
                     'and lg.logan_codsolot like  ''' || lv_codsolot || '''' ||
                     'and lg.logan_estado_solot like  ''' || lv_estado || '''' ||
                     'and to_char(lg.logad_fecha_reg,''DD/MM/YYYY'') = ''' ||
                     lv_fecini || '''';

    else

      lv_consulta := 'select lg.logan_cod_id, ' ||
                     'lg.logad_fecha_reg as fec_inicio, ' ||
                     'lg.logad_fecha_ejec as fec_fin, ' ||
                     'lg.logav_estado, ' || '(select es.descripcion ' ||
                     'from operacion.estsol es ' ||
                     'where es.estsol = lg.logan_estado_solot) as estado_sot, ' ||
                     'lg.logan_codsolot, ' || 'lg.logav_descripcion, ' ||
                     'decode(lg.logav_tipo_trans,' || '''CX''' || ',' ||
                     '''CONAX''' || ',' || '''JN''' || ',' || '''JANUS''' ||
                     ',lg.logav_tipo_trans) as tipo_trans, ' ||
                     'lg.logav_usuario_crea ' || 'from (' || lv_logaprovlte ||
                     ') lg ' || 'where lg.logan_cod_id like ''' || lv_co_id || '''' ||
                     'and lg.logan_codsolot like  ''' || lv_codsolot || '''' ||
                     'and lg.logan_estado_solot like  ''' || lv_estado || '''' ||
                     'and to_date(lg.logad_fecha_reg) between (''' ||
                     lv_fecini || ''') and (''' || lv_fecfin || ''')';
    end if;

    open p_cursor for lv_consulta;

  EXCEPTION
    when others then
      open p_cursor for
        select null logan_cod_id,
               null fec_inicio,
               null fec_fin,
               null logav_estado,
               null estado_sot,
               null logan_codsolot,
               null logav_descripcion,
               null tipo_trans
          from dual
         where 0 = 1;
  END;
  /*********************************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        30/11/2016  Luis Guzmán      Reenvio de Provision IL
  *********************************************************************************************/
  PROCEDURE sgasi_reenvio_provision_il(p_codsolot     NUMBER,
                                       p_codigo_resp  OUT INTEGER,
                                       p_mensaje_resp OUT VARCHAR2) IS

    lv_msisdn        VARCHAR2(15);
    lv_iccid         VARCHAR2(20);
    ln_cod_id        NUMBER;
    ln_custumer_id   NUMBER;
    ln_request_tv    number;
    ln_request_padre number;
    ln_cod_resul     number;
    lv_resul         varchar2(4000);
    ln_cant_dig_chip number;

  BEGIN

    ln_cant_dig_chip := OPERACION.PQ_SGA_JANUS.F_GET_CONSTANTE_CONF('CANDIGCHIPLTE');

    if ln_cant_dig_chip = -10 then
      ln_cant_dig_chip := 19; -- Solo por contingencia
    end if;

    p_codigo_resp := 1; --15.00

    -- Tomando ICCID y MSISDN
    select rpad(se.numserie, ln_cant_dig_chip),
           se.mac,
           s.cod_id,
           s.customer_id
      into lv_iccid, lv_msisdn, ln_cod_id, ln_custumer_id
      from solotptoequ se,
           solot s,
           solotpto sp,
           inssrv i,
           tipequ t,
           almtabmat a,
           (select a.codigon tipequ, codigoc grupo
              from opedd a, tipopedd b
             where a.tipopedd = b.tipopedd
               and b.abrev = 'TIPEQU_LTE_TLF') equ_conax
     where se.codsolot = s.codsolot
       and s.codsolot = sp.codsolot
       and se.punto = sp.punto
       and sp.codinssrv = i.codinssrv
       and t.tipequ = se.tipequ
       and a.codmat = t.codtipequ
       and se.codsolot = p_codsolot
       and t.tipequ = equ_conax.tipequ
       and equ_conax.grupo = '3';

    --ini 15.0
    p_log_3playi(p_codsolot,
                 'sgasi_reenvio_provision_il',
                 'INICIO',
                 'Reenvio de Servicios Inalámbricos',
                 ln_cod_resul,
                 lv_resul);

    p_log_3playi(p_codsolot,
                 'pq_sga_bscs.p_reg_nro_lte_bscs',
                 'INICIO',
                 'Reenvio de Servicios Inalámbricos',
                 ln_cod_resul,
                 lv_resul);

    operacion.pq_sga_bscs.p_reg_nro_lte_bscs(lv_msisdn,
                                             p_codigo_resp,
                                             p_mensaje_resp);

    p_log_3playi(p_codsolot,
                 'pq_sga_bscs.p_reg_nro_lte_bscs',
                 p_mensaje_resp,
                 'Reenvio de Servicios Inalámbricos',
                 ln_cod_resul,
                 lv_resul);

    p_log_3playi(p_codsolot,
                 'TIM.pp021_venta_lte.SP_INST_MSISDN_ICCID',
                 'INICIO',
                 'Reenvio de Servicios Inalámbricos',
                 ln_cod_resul,
                 lv_resul);
    --fin 15.0

    TIM.pp021_venta_lte.SP_INST_MSISDN_ICCID@DBL_BSCS_BF(ln_cod_id,
                                                         lv_msisdn,
                                                         lv_iccid,
                                                         p_codsolot,
                                                         ln_request_padre,
                                                         ln_request_tv,
                                                         p_codigo_resp,
                                                         p_mensaje_resp);

    p_log_3playi(p_codsolot,
                 'TIM.pp021_venta_lte.SP_INST_MSISDN_ICCID',
                 p_mensaje_resp,
                 'Reenvio de Servicios Inalámbricos',
                 ln_cod_resul,
                 lv_resul); --15.00

    --ini 15.00
    UPDATE operacion.ope_srv_recarga_det
       SET request = ln_request_tv
     WHERE tipsrv = (SELECT c.valor
                       FROM operacion.constante c
                      WHERE c.constante = 'FAM_CABLE')
       AND numregistro = (SELECT t.numregistro
                            FROM operacion.ope_srv_recarga_cab t
                           WHERE t.codsolot = p_codsolot);

    UPDATE operacion.ope_srv_recarga_det
       SET request_padre = ln_request_padre
     WHERE numregistro = (SELECT t.numregistro
                            FROM operacion.ope_srv_recarga_cab t
                           WHERE t.codsolot = p_codsolot);
    --fin 15.00

    if p_codigo_resp <> 0 then
      sgasu_serv_x_cliente(p_codsolot,
                           'IL',
                           p_mensaje_resp,
                           'ERRO',
                           p_codigo_resp,
                           p_mensaje_resp);
    else
      sgasu_serv_x_cliente(p_codsolot,
                           'IL',
                           null,
                           'EPLA',
                           p_codigo_resp,
                           p_mensaje_resp); --15.00
    end if;

    --ini 15.00
    p_log_3playi(p_codsolot,
                 'sgasi_reenvio_provision_il',
                 p_mensaje_resp,
                 'Reenvio de Servicios Inalámbricos',
                 ln_cod_resul,
                 lv_resul);
    --fin 15.00

  EXCEPTION
    WHEN OTHERS THEN
      p_codigo_resp  := -1;
      p_mensaje_resp := 'ERROR: ' || TO_CHAR(SQLCODE) || ' ' || SQLERRM;

  END;

  -- Fin 14.0

  procedure p_gen_change_cycle(p_co_id in integer,
                               p_user  in varchar2,
                               p_resp  out integer,
                               p_msgr  out varchar2) is

    v_result integer;
    v_msgr   varchar2(300);
  begin
    p_resp := 0;
    p_msgr := 'Process started.';

    --execute the process en DB BSCS
    tim.pp021_venta_lte.bscssi_cambio_ciclo_lte@dbl_bscs_bf(p_co_id,
                                                            p_user,
                                                            v_result,
                                                            v_msgr);

    if v_result <> 0 then
      p_resp := v_result;
      p_msgr := 'RESPONSE DB BSCS = [' || v_msgr || ']';
      return;
    end if;

    p_msgr := 'Ok';
  exception
    when others then
      p_resp := -99;
      p_msgr := 'Ocurrió un error al ejecutar el cambio de ciclo en BSCS.' ||
                sqlerrm;
  end;
  /************************************************************************************************/
  /******************************************************************
  '* Nombre SP : SGAI_CARGA_RESUMEN_EQU
  '* Propósito : Funcionalidad para actualizar equipos de servicios Fija
  '* Input : SOT de Alta
  '* Output : <PO_ERROR> - <PO_MENSAJE>
  '* Creado por :
  '* Fec Creación : 18/03/2019
  '* Fec Actualización :
  '*****************************************************************/
   procedure sgai_carga_resumen_equ(an_codsolot in solot.codsolot%type,
                                    an_error    out number,
                                    av_error    out varchar2) is

     lr_equipo operacion.sgat_equipo_servicio_fija%rowtype;

     cursor c_equipos is
       select distinct s.cod_id,
                       s.customer_id,
                       s.codcli,
                       s.codsolot,
                       se.numserie,
                       se.mac,
                       'LTE' tecnologia,
                       i.codinssrv,
                       i.tipsrv,
                       se.codequcom,
                       se.tipequ,
                       t.tipo,
                       t.codtipequ,
                       'ACTIVO' Estado
         from solotptoequ se,
              solot s,
              solotpto sp,
              inssrv i,
              tipequ t,
              almtabmat a,
              (select a.codigon tipequ, to_number(codigoc) grupo
                 from opedd a, tipopedd b
                where a.tipopedd = b.tipopedd
                  and b.abrev in ('TIPEQU_DTH_CONAX', 'TIPEQU_LTE_TLF')) equ_conax
        where se.codsolot = s.codsolot
          and s.codsolot = sp.codsolot
          and se.punto = sp.punto
          and sp.codinssrv = i.codinssrv
          and t.tipequ = se.tipequ
          and a.codmat = t.codtipequ
          and se.codsolot IN (an_codsolot)
          and t.tipequ = equ_conax.tipequ;
   begin
     an_error := 0;
     av_error := 'Ok';

     for equ in c_equipos loop

       lr_equipo.sgan_co_id         := equ.cod_id;
       lr_equipo.sgan_customer_id   := equ.customer_id;
       lr_equipo.sgav_codcli        := equ.codcli;
       lr_equipo.sgan_codsolot      := equ.codsolot;
       lr_equipo.sgan_codsolot_b_ce := null;
       lr_equipo.sgav_numeroserie   := equ.numserie;
       lr_equipo.sgav_imei_esn_ua   := equ.mac;
       lr_equipo.sgav_tecnologia    := equ.tecnologia;
       lr_equipo.sgan_codinssrv     := equ.codinssrv;
       lr_equipo.sgan_pid           := null;
       lr_equipo.sgav_tipsrv        := equ.tipsrv;
       lr_equipo.sgav_codequcom     := equ.codequcom;
       lr_equipo.sgan_tipequ        := equ.tipequ;
       lr_equipo.sgav_tipo_equipo   := equ.tipo;
       lr_equipo.sgav_codtipequ     := equ.codtipequ;
       lr_equipo.sgav_estado        := equ.estado;
       lr_equipo.sgav_usureg        := user;
       lr_equipo.sgad_fecreg        := sysdate;

       operacion.pq_siac_cambio_plan_lte.sgasi_inserta_equipo_fija(lr_equipo,
                                                                   an_error,
                                                                   av_error);
     end loop;

   exception
     when others then
       an_error := -99;
       av_error := 'Ocurrió un error al ejecutar la carga de Equipos.' ||
                   sqlerrm;
   end;
END;
/