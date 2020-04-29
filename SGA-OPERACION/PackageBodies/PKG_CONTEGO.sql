CREATE OR REPLACE PACKAGE BODY OPERACION.PKG_CONTEGO IS
  /****************************************************************
  * Nombre Package : OPERACION.PKG_CONTEGO
  * Proposito      : Paquete con Objetos Necesarios Para la PROVISION SGA - CONTEGO
  * Fec. Creacion  : 01/08/2017

     Version    Fecha       Autor            Solicitado por    Descripcion
     ---------  ----------  ---------------  --------------    -----------------------------------------
     1.0        01/08/2017  Jose Arriola
     2.0        30/05/2018  Marleny Teque   Justiniano Condori PROY-32581-Postventa LTE/HFC] - [Deco Adicional]
   3.0        22/11/2018  Luis Flores    Luis Flores       PROY-32581-Postventa LTE/HFC] - [Cambio de Plan LTE]
   4.0        06/12/2018  Marleny Teque  Luis Flores       PROY-32581-Postventa LTE/HFC] - [Cambio de Plan LTE]
   5.0        11/02/2019  Luis Flores    Luis Flores       PROY-32581-Postventa LTE/HFC] - [Cambio de Plan LTE]
   6.0        26/02/2019  Wendy Tamayo   Francisco Chavez  IDEA-43979-APP SERVICIO TÉCNICO - [Activacion LTE]
  ****************************************************************/
  /****************************************************************
  * Nombre SP      : SGASS_ALTA
  * Proposito      : Este SP es el principal para empezar el proceso de alta.
                     Desde aqui se empezara el proceso con las validaciones y
                     registro de pareo, despareo y alta de bouquets en la tabla
                     transaccional
  * Input          : K_NUMREGISTRO - Numero de registro a procesar
  * Output         : K_RESPUESTA
                     K_MENSAJE
  * Creado por     : Jose Arriola
  * Fec. Creacion  : 01/08/2017
  * Fec. Actualizacion : --
  ****************************************************************/
  PROCEDURE SGASS_ALTA(K_NUMREGISTRO OPERACION.OPE_SRV_RECARGA_CAB.NUMREGISTRO%TYPE,
                       K_RESPUESTA   IN OUT VARCHAR2,
                       K_MENSAJE     IN OUT VARCHAR2) IS

    V_CODSOLOT OPERACION.SOLOT.CODSOLOT%TYPE;
    V_REG_DECO NUMBER;
    V_RESP     VARCHAR2(10);
    V_MSJ      VARCHAR2(1000);
    EX_ERROR EXCEPTION;

    CURSOR C_SOT_REEMPLAZO IS
      SELECT DISTINCT S.TRXN_CODSOLOT, S.TRXC_ESTADO
        FROM OPERACION.SGAT_TRXCONTEGO S
       WHERE S.TRXN_CODSOLOT = V_CODSOLOT
         AND S.TRXN_ACTION_ID IN (C_ACTION_ALTA, C_ACTION_ACTIVACION)
      UNION ALL
      SELECT DISTINCT H.TRXN_CODSOLOT, H.TRXC_ESTADO
        FROM OPERACION.SGAT_TRXCONTEGO_HIST H
       WHERE H.TRXC_ESTADO = C_PROV_OK
         AND H.TRXN_CODSOLOT = V_CODSOLOT
         AND H.TRXN_ACTION_ID IN (C_ACTION_ALTA, C_ACTION_ACTIVACION)
       ORDER BY 2 DESC;

  BEGIN
    k_RESPUESTA := 'OK';
    k_MENSAJE   := 'PROCESO TERMINADO SATISFACTORIAMENTE';
    -- BLOQUE CONSULTAS
    BEGIN
      SELECT CODSOLOT
        INTO V_CODSOLOT
        FROM OPERACION.OPE_SRV_RECARGA_CAB
       WHERE NUMREGISTRO = k_NUMREGISTRO;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        k_RESPUESTA := 'ERROR';
        k_MENSAJE   := 'ERROR: NO SE ENCUENTRA EL SOT ASOCIADO AL NUMREGISTRO EN LA TABLA OPERACION.OPE_SRV_RECARGA_CAB';
        RAISE EX_ERROR;
    END;

    /*Verificamos que la linea no se encuentre registrada en la transaccional con estado 1 o en
    el historico con estado 3*/
    FOR C_SOT IN C_SOT_REEMPLAZO LOOP
      IF (C_SOT.TRXC_ESTADO = C_GENERADO) THEN
          k_RESPUESTA := 'PENDIENTE';
          k_MENSAJE   := 'PENDIENTE: EN ESPERA DE ENVIO A CONTEGO.';
          RAISE EX_ERROR;
      ELSIF (C_SOT.TRXC_ESTADO = C_PROV_OK) THEN
        k_RESPUESTA := 'OK';
        k_MENSAJE   := 'PROVISIONADO: SE EJECUTO CORRECTAMENTE.';
        RAISE EX_ERROR;
      ELSIF (C_SOT.TRXC_ESTADO = C_ENVIADO) THEN
        k_RESPUESTA := 'PENDIENTE';
        k_MENSAJE   := 'PENDIENTE: EN ESPERA DE RESPUESTA DE CONTEGO.';
        RAISE EX_ERROR;
      ELSE
        DELETE OPERACION.SGAT_TRXCONTEGO S WHERE s.trxn_codsolot = V_CODSOLOT;

        EXIT;
      END IF;
    END LOOP;

    SELECT COUNT(*)
      INTO V_REG_DECO
      FROM OPERACION.TARJETA_DECO_ASOC T
     WHERE CODSOLOT = V_CODSOLOT;

    IF V_REG_DECO = 0 THEN
      k_RESPUESTA := 'ERROR';
      k_MENSAJE   := 'ERROR: NO SE ASOCIO TARJETA CON DECODIFICADOR';
      RAISE EX_ERROR;
    END IF;

    --IF OPERACION.PQ_DECO_ADICIONAL_LTE.F_OBT_TIPO_DECO(V_CODSOLOT) = C_DESACTIVO THEN  --2.0
    IF SGAFUN_VALIDA_PAREO(V_CODSOLOT) > 0 THEN
      SGASS_PAREO(k_NUMREGISTRO, V_CODSOLOT, V_RESP, V_MSJ);
      IF V_RESP = 'ERROR' THEN
        k_RESPUESTA := V_RESP;
        k_MENSAJE   := V_MSJ;
        RAISE EX_ERROR;
      END IF;
    END IF;

    IF SGAFUN_VALIDA_DESPAREO(V_CODSOLOT) > 0 THEN
      SGASS_DESPAREO(k_NUMREGISTRO, V_CODSOLOT, V_RESP, V_MSJ);
      IF V_RESP = 'ERROR' THEN
        k_RESPUESTA := V_RESP;
        k_MENSAJE   := V_MSJ;
        RAISE EX_ERROR;
      END IF;
    END IF;
    IF (SGAFUN_VALIDA_PAREO(V_CODSOLOT) = 0) AND
       (SGAFUN_VALIDA_DESPAREO(V_CODSOLOT) = 0) THEN
      k_RESPUESTA := 'ERROR';
      k_MENSAJE   := 'ERROR PAREO/DESPAREO: NO SE ENCONTRO INFORMACION EN LA TABLA DE ASOCIACION';
      RAISE EX_ERROR;
    END IF;
    --END IF; --2.0

    SGASS_ACTIVARBOUQUET(k_NUMREGISTRO, V_CODSOLOT, V_RESP, V_MSJ);
    IF V_RESP = 'ERROR' THEN
      k_RESPUESTA := V_RESP;
      k_MENSAJE   := V_MSJ;
      RAISE EX_ERROR;
    END IF;
  EXCEPTION
    WHEN EX_ERROR THEN
      SGASP_LOGERR(C_SP_ALTA,k_NUMREGISTRO,V_CODSOLOT,k_RESPUESTA,k_MENSAJE);




      ROLLBACK;
    WHEN OTHERS THEN
      k_RESPUESTA := 'ERROR';
      k_MENSAJE   := 'ERROR: ' || SQLCODE || ' ' || SQLERRM || ' ' ||
                     DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      SGASP_LOGERR(C_SP_ALTA,k_NUMREGISTRO,V_CODSOLOT,k_RESPUESTA,k_MENSAJE);




      ROLLBACK;
  END;
  /****************************************************************
  * Nombre SP      : SGASS_PAREO
  * Proposito      : Este SP genera informacion para el proceso de
                     pareo
  * Input          : K_NUMREGISTRO - Numero de registro
                     k_CODSOLOT - SOT
  * Output         : K_RESPUESTA
                     K_MENSAJE
  * Creado por     : Jose Arriola
  * Fec. Creacion  : 01/08/2017
  * Fec. Actualizacion : --
  ****************************************************************/
  PROCEDURE SGASS_PAREO(k_NUMREGISTRO OPERACION.OPE_SRV_RECARGA_CAB.NUMREGISTRO%TYPE,
                        k_CODSOLOT    OPERACION.SOLOT.CODSOLOT%TYPE,
                        K_RESPUESTA   IN OUT VARCHAR2,
                        k_MENSAJE     IN OUT VARCHAR2) IS

    V_CONTEGO OPERACION.SGAT_TRXCONTEGO%ROWTYPE;
    V_NUMSLC  OPERACION.SOLOT.NUMSLC%TYPE;
    V_BOUQUET VARCHAR2(10000);
    EX_ERROR EXCEPTION;
    V_NUMREGISTRO OPERACION.OPE_SRV_RECARGA_CAB.NUMREGISTRO%TYPE := k_NUMREGISTRO; --2.0

    CURSOR C_EQUIPOS_TARJETAS IS
      SELECT T.NRO_SERIE_DECO, T.NRO_SERIE_TARJETA
        FROM SOLOTPTOEQU SE, OPERACION.TARJETA_DECO_ASOC T
       WHERE T.CODSOLOT = k_CODSOLOT
         AND T.CODSOLOT = SE.CODSOLOT
         AND SE.MAC = T.NRO_SERIE_DECO
         AND (SELECT COUNT(*)
                FROM OPEDD A, TIPOPEDD B
               WHERE A.TIPOPEDD = B.TIPOPEDD
                 AND B.ABREV = 'PREFIJO_DECO'
                 AND INSTR(UPPER(SE.NUMSERIE), UPPER(TRIM(A.CODIGOC))) = 1) > 0;
  BEGIN
    k_RESPUESTA := 'OK';
    k_MENSAJE   := 'PROCESO TERMINADO SATISFACTORIAMENTE';

    -- ini 2.0
    --V_NUMSLC := SGAFUN_OBT_NUMSLC(k_NUMREGISTRO);
    IF OPERACION.PQ_DECO_ADICIONAL_LTE.F_OBT_TIPO_DECO(k_CODSOLOT) =
       C_DESACTIVO THEN
      V_NUMSLC := SGAFUN_OBT_NUMSLC(V_NUMREGISTRO);
    ELSIF OPERACION.PQ_DECO_ADICIONAL_LTE.F_OBT_TIPO_DECO(k_CODSOLOT) =
          C_ACTIVADO THEN
      V_NUMSLC      := OPERACION.PQ_DECO_ADICIONAL_LTE.F_OBT_DATA_NUMSLC_ORI(k_CODSOLOT);
      V_NUMREGISTRO := OPERACION.PQ_DECO_ADICIONAL_LTE.F_OBT_DATA_VTA_ORI(k_CODSOLOT);
    END IF;
    -- fin 2.0
    IF V_NUMSLC IS NULL THEN
      k_RESPUESTA := 'ERROR';
      k_MENSAJE   := 'ERROR: NO SE ENCUENTRA EL NUMERO DE PROYECTO EN LA TABLA OPERACION.OPE_SRV_RECARGA_CAB';
      RAISE EX_ERROR;
    END IF;

    --V_BOUQUET := SGAFUN_OBT_BOUQUET(k_NUMREGISTRO,V_NUMSLC,C_TIP_BOUQUET_ALTA); --2.0
    V_BOUQUET := SGAFUN_OBT_BOUQUET(V_NUMREGISTRO,V_NUMSLC,C_TIP_BOUQUET_ALTA); --2.0


    IF V_BOUQUET IS NULL THEN
      k_RESPUESTA := 'ERROR';
      k_MENSAJE   := 'ERROR: NO SE ENCUENTRA LOS BOUQUETS PARA REALIZAR LA ACTIVACION';
      RAISE EX_ERROR;
    END IF;

    FOR C_PAREO IN C_EQUIPOS_TARJETAS LOOP
      V_CONTEGO.TRXN_CODSOLOT      := k_CODSOLOT;
      V_CONTEGO.TRXN_ACTION_ID     := SGAFUN_PARAM_CONTEGO('CONF_CONTEGO_ACT','CONF_ACT','PAREO-CONTEGO','N');



      V_CONTEGO.TRXV_TIPO          := 'PAREO';
      V_CONTEGO.TRXV_BOUQUET       := V_BOUQUET;
      V_CONTEGO.TRXV_SERIE_TARJETA := C_PAREO.NRO_SERIE_TARJETA;
      V_CONTEGO.TRXV_SERIE_DECO    := C_PAREO.NRO_SERIE_DECO;
      V_CONTEGO.TRXN_PRIORIDAD     := SGAFUN_PARAM_CONTEGO('CONF_CONTEGO_ACT','CONF_ACT','PAREO-CONTEGO','AU');



      SGASI_REGCONTEGO(V_CONTEGO, k_RESPUESTA);
      IF k_RESPUESTA = 'ERROR' THEN
        k_MENSAJE := 'ERROR: AL GRABAR LAS TRANSACCIONES DE PAREO EN LA TABLA OPERACION.SGAT_TRXCONTEGO.';
        EXIT;
      END IF;
    END LOOP;
  EXCEPTION
    WHEN EX_ERROR then
      --SGASP_LOGERR(C_SP_PAREO,k_NUMREGISTRO,k_CODSOLOT,k_RESPUESTA,k_MENSAJE);  --2.0
      SGASP_LOGERR(C_SP_PAREO,V_NUMREGISTRO,k_CODSOLOT,k_RESPUESTA,k_MENSAJE); --2.0




    WHEN OTHERS THEN
      k_RESPUESTA := 'ERROR';
      k_MENSAJE   := 'ERROR: AL GRABAR LAS TRANSACIONES DE PAREO ' ||
                     SQLCODE || ' ' || SQLERRM || ' ' ||
                     DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      --SGASP_LOGERR(C_SP_PAREO,k_NUMREGISTRO,k_CODSOLOT,k_RESPUESTA,k_MENSAJE);  --2.0
      SGASP_LOGERR(C_SP_PAREO,V_NUMREGISTRO,k_CODSOLOT,k_RESPUESTA,k_MENSAJE); --2.0




  END;
  /****************************************************************
  * Nombre SP      : SGASS_DESPAREO
  * Proposito      : Este SP genera informacion para el proceso de
                     despareo
  * Input          : K_NUMREGISTRO - Numero de registro
                     k_CODSOLOT - SOT
  * Output         : K_RESPUESTA
                     K_MENSAJE
  * Creado por     : Jose Arriola
  * Fec. Creacion  : 01/08/2017
  * Fec. Actualizacion : --
  ****************************************************************/
  PROCEDURE SGASS_DESPAREO(k_NUMREGISTRO OPERACION.OPE_SRV_RECARGA_CAB.NUMREGISTRO%TYPE,
                           k_CODSOLOT    OPERACION.SOLOT.CODSOLOT%TYPE,
                           K_RESPUESTA   IN OUT VARCHAR2,
                           k_MENSAJE     IN OUT VARCHAR2) IS

    V_CONTEGO OPERACION.SGAT_TRXCONTEGO%ROWTYPE;
    V_NUMSLC  OPERACION.SOLOT.NUMSLC%TYPE;
    V_BOUQUET VARCHAR2(10000);
    EX_ERROR EXCEPTION;
    V_NUMREGISTRO OPERACION.OPE_SRV_RECARGA_CAB.NUMREGISTRO%TYPE := k_NUMREGISTRO;  --2.0

    CURSOR C_EQUIPOS_TARJETAS IS
      SELECT T.NRO_SERIE_DECO, T.NRO_SERIE_TARJETA
        FROM SOLOTPTOEQU SE, OPERACION.TARJETA_DECO_ASOC T
       WHERE T.CODSOLOT = k_CODSOLOT
         AND T.CODSOLOT = SE.CODSOLOT
         AND SE.MAC = T.NRO_SERIE_DECO
         AND (SELECT COUNT(*)
                FROM OPEDD A, TIPOPEDD B
               WHERE A.TIPOPEDD = B.TIPOPEDD
                 AND B.ABREV = 'PREFIJO_DECO'
                 AND INSTR(UPPER(SE.NUMSERIE), UPPER(TRIM(A.CODIGOC))) = 1) = 0;
  BEGIN
    k_RESPUESTA := 'OK';
    k_MENSAJE   := 'PROCESO TERMINADO SATISFACTORIAMENTE';

     --ini 2.0
   --V_NUMSLC := SGAFUN_OBT_NUMSLC(k_NUMREGISTRO);
    IF OPERACION.PQ_DECO_ADICIONAL_LTE.F_OBT_TIPO_DECO(k_CODSOLOT) =
       C_DESACTIVO THEN
      V_NUMSLC := SGAFUN_OBT_NUMSLC(V_NUMREGISTRO);
    ELSIF OPERACION.PQ_DECO_ADICIONAL_LTE.F_OBT_TIPO_DECO(k_CODSOLOT) =
          C_ACTIVADO THEN
      V_NUMSLC      := OPERACION.PQ_DECO_ADICIONAL_LTE.F_OBT_DATA_NUMSLC_ORI(k_CODSOLOT);
      V_NUMREGISTRO := OPERACION.PQ_DECO_ADICIONAL_LTE.F_OBT_DATA_VTA_ORI(k_CODSOLOT);
    END IF;
    --fin 2.0
    IF V_NUMSLC IS NULL THEN
      k_RESPUESTA := 'ERROR';
      k_MENSAJE   := 'ERROR: NO SE ENCUENTRA EL NUMERO DE PROYECTO EN LA TABLA OPERACION.OPE_SRV_RECARGA_CAB';
      RAISE EX_ERROR;
    END IF;

    --V_BOUQUET := SGAFUN_OBT_BOUQUET(k_NUMREGISTRO,V_NUMSLC,C_TIP_BOUQUET_ALTA);  -- 2.0
    V_BOUQUET := SGAFUN_OBT_BOUQUET(V_NUMREGISTRO,V_NUMSLC,C_TIP_BOUQUET_ALTA); -- 2.0


    IF V_BOUQUET IS NULL THEN
      k_RESPUESTA := 'ERROR';
      k_MENSAJE   := 'ERROR: NO SE ENCUENTRA LOS BOUQUETS PARA REALIZAR LA ACTIVACION';
      RAISE EX_ERROR;
    END IF;

    FOR C_DESPAREO IN C_EQUIPOS_TARJETAS LOOP
      V_CONTEGO.TRXN_CODSOLOT      := k_CODSOLOT;
      V_CONTEGO.TRXN_ACTION_ID     := SGAFUN_PARAM_CONTEGO('CONF_CONTEGO_ACT',
                                                           'CONF_ACT',
                                                           'DESPAREO-CONTEGO',
                                                           'N');
      V_CONTEGO.TRXV_TIPO          := 'DESPAREO';
      V_CONTEGO.TRXV_BOUQUET       := V_BOUQUET;
      V_CONTEGO.TRXV_SERIE_TARJETA := C_DESPAREO.NRO_SERIE_TARJETA;
      V_CONTEGO.TRXV_SERIE_DECO    := C_DESPAREO.NRO_SERIE_DECO;
      V_CONTEGO.TRXN_PRIORIDAD     := SGAFUN_PARAM_CONTEGO('CONF_CONTEGO_ACT',
                                                           'CONF_ACT',
                                                           'DESPAREO-CONTEGO',
                                                           'AU');
      SGASI_REGCONTEGO(V_CONTEGO, k_RESPUESTA);
      IF k_RESPUESTA = 'ERROR' THEN
        k_MENSAJE := 'ERROR: AL GRABAR LAS TRANSACCIONES DE DESPAREO EN LA TABLA OPERACION.SGAT_TRXCONTEGO.';
        EXIT;
      END IF;
    END LOOP;
  EXCEPTION
    WHEN EX_ERROR then
      SGASP_LOGERR(C_SP_DESPAREO,
                 --k_NUMREGISTRO, --2.0
                   V_NUMREGISTRO, --2.0
                   k_CODSOLOT,
                   k_RESPUESTA,
                   k_MENSAJE);
    WHEN OTHERS THEN
      k_RESPUESTA := 'ERROR';
      k_MENSAJE   := 'ERROR: AL GRABAR LAS TRANSACIONES DE DESPAREO' ||
                     SQLCODE || ' ' || SQLERRM || ' ' ||
                     DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      SGASP_LOGERR(C_SP_DESPAREO,
                   --k_NUMREGISTRO,  --2.0
            V_NUMREGISTRO, --2.0
                   k_CODSOLOT,
                   k_RESPUESTA,
                   k_MENSAJE);
  END;
  /****************************************************************
  * Nombre SP      : SGASS_ACTIVARBOUQUET
  * Proposito      : Este SP genera informacion para el proceso de
                     activacion
  * Input          : K_NUMREGISTRO - Numero de registro
                     k_CODSOLOT - SOT
  * Output         : K_RESPUESTA
                     K_MENSAJE
  * Creado por     : Jose Arriola
  * Fec. Creacion  : 01/08/2017
  * Fec. Actualizacion : --
  ****************************************************************/
  PROCEDURE SGASS_ACTIVARBOUQUET(k_NUMREGISTRO OPERACION.OPE_SRV_RECARGA_CAB.NUMREGISTRO%TYPE,
                                 k_CODSOLOT    OPERACION.SOLOT.CODSOLOT%TYPE,
                                 K_RESPUESTA   IN OUT VARCHAR2,
                                 k_MENSAJE     IN OUT VARCHAR2) IS

    V_CONTEGO     OPERACION.SGAT_TRXCONTEGO%ROWTYPE;
    V_NUMSLC      OPERACION.SOLOT.NUMSLC%TYPE;
    V_NUMREGISTRO OPERACION.OPE_SRV_RECARGA_CAB.NUMREGISTRO%TYPE := k_NUMREGISTRO;
    V_BOUQUET     OPERACION.SGAT_TRXCONTEGO.TRXV_BOUQUET%TYPE;
    EX_ERROR EXCEPTION;

    CURSOR C_TARJETAS IS
      SELECT DISTINCT NUMSERIE
        FROM SOLOTPTOEQU
       WHERE CODSOLOT = k_CODSOLOT
         AND TIPEQU IN (SELECT A.CODIGON TIPEQUOPE
                          FROM OPEDD A, TIPOPEDD B
                         WHERE A.TIPOPEDD = B.TIPOPEDD
                           AND B.ABREV = 'TIPEQU_DTH_CONAX'
                           AND CODIGOC = '1')
       ORDER BY NUMSERIE;
  BEGIN
    k_RESPUESTA := 'OK';
    k_MENSAJE   := 'PROCESO TERMINADO SATISFACTORIAMENTE';

    IF OPERACION.PQ_DECO_ADICIONAL_LTE.F_OBT_TIPO_DECO(k_CODSOLOT) =
       C_DESACTIVO THEN
      V_NUMSLC := SGAFUN_OBT_NUMSLC(V_NUMREGISTRO);
    ELSIF OPERACION.PQ_DECO_ADICIONAL_LTE.F_OBT_TIPO_DECO(k_CODSOLOT) =
          C_ACTIVADO THEN
      V_NUMSLC      := OPERACION.PQ_DECO_ADICIONAL_LTE.F_OBT_DATA_NUMSLC_ORI(k_CODSOLOT);
      V_NUMREGISTRO := OPERACION.PQ_DECO_ADICIONAL_LTE.F_OBT_DATA_VTA_ORI(k_CODSOLOT);
    END IF;
    IF V_NUMSLC IS NULL THEN
      k_RESPUESTA := 'ERROR';
      k_MENSAJE   := 'ERROR: NO SE ENCUENTRA EL NUMERO DE PROYECTO EN LA TABLA OPERACION.OPE_SRV_RECARGA_CAB';
      RAISE EX_ERROR;
    END IF;

    V_BOUQUET := SGAFUN_OBT_BOUQUET(V_NUMREGISTRO,V_NUMSLC,C_TIP_BOUQUET_ALTA);




    IF V_BOUQUET IS NULL THEN
      k_RESPUESTA := 'ERROR';
      k_MENSAJE   := 'ERROR: NO SE ENCUENTRA LOS BOUQUETS PARA REALIZAR LA ACTIVACION';
      RAISE EX_ERROR;
    END IF;

    FOR C_ACTIVAR IN C_TARJETAS LOOP
      V_CONTEGO.TRXN_CODSOLOT      := k_CODSOLOT;
      V_CONTEGO.TRXN_ACTION_ID     := SGAFUN_PARAM_CONTEGO('CONF_CONTEGO_ACT',
                                                           'CONF_ACT',
                                                           'ALTA-CONTEGO',
                                                           'N');
      V_CONTEGO.TRXV_SERIE_TARJETA := C_ACTIVAR.NUMSERIE;
      V_CONTEGO.TRXV_BOUQUET       := V_BOUQUET;
      V_CONTEGO.TRXN_PRIORIDAD     := SGAFUN_PARAM_CONTEGO('CONF_CONTEGO_ACT',
                                                           'CONF_ACT',
                                                           'ALTA-CONTEGO',
                                                           'AU');
      SGASI_REGCONTEGO(V_CONTEGO, k_RESPUESTA);
      IF k_RESPUESTA = 'ERROR' THEN
        k_MENSAJE := 'ERROR: AL GRABAR LAS TRANSACCIONES DE ACTIVACION EN LA TABLA OPERACION.SGAT_TRXCONTEGO.';
        EXIT;
      END IF;
    END LOOP;
  EXCEPTION
    WHEN EX_ERROR then
      SGASP_LOGERR(C_SP_ACTIVAR,V_NUMREGISTRO,k_CODSOLOT,k_RESPUESTA,k_MENSAJE);



    WHEN OTHERS THEN
      k_RESPUESTA := 'ERROR';
      k_MENSAJE   := 'ERROR: AL GRABAR LAS TRANSACIONES DE ACTIVACION' ||
                     SQLCODE || ' ' || SQLERRM || ' ' ||
                     DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      SGASP_LOGERR(C_SP_ACTIVAR,V_NUMREGISTRO,k_CODSOLOT,k_RESPUESTA,k_MENSAJE);




  END;
  /****************************************************************
  * Nombre SP      : SGASS_WSCONTEGO
  * Proposito      : Este SP genera los XML para pareo, despareo y
                     activacion segun sea el caso y las envia hacia
                     contego poniendo las transacciones en estado 2.
  * Input          : K_ESTADO - Estado de la transaccion
  * Output         : K_CURSOR
                     K_RESPUESTA
                     K_MENSAJE
  * Creado por     : Jose Arriola
  * Fec. Creacion  : 01/08/2017
  * Fec. Actualizacion : --
  ****************************************************************/
  PROCEDURE SGASS_WSCONTEGO(K_ESTADO    IN VARCHAR2,
                            K_CURSOR    OUT SYS_REFCURSOR,
                            K_RESPUESTA OUT VARCHAR2,
                            K_MENSAJE   OUT VARCHAR2) IS

    V_CODSOLOT            NUMBER;
    V_REINTENTOSC         NUMBER;
    v_sgaseq_transcontego NUMBER;
    EX_ERROR EXCEPTION;
    V_FECFIN DATE;
    LC_FECFIN_ROTACION  VARCHAR2(12);

    CURSOR C_TRANS_CONTEGO IS
      SELECT TRX.TRXN_IDTRANSACCION,
             TRX.TRXN_CODSOLOT,
             TRX.TRXC_REINTENTOS,
             TRX.TRXN_ACTION_ID
        FROM OPERACION.SGAT_TRXCONTEGO TRX
       WHERE TRX.TRXC_ESTADO = K_ESTADO
       ORDER BY TRX.TRXN_IDTRANSACCION ASC;
  BEGIN
    V_CODSOLOT  := NULL;
    k_RESPUESTA := '0';
    k_MENSAJE   := 'PROCESO TERMINADO SATISFACTORIAMENTE';
    K_CURSOR    := NULL;

    --Actualizamos la fecha de rotacion si ya llegamos a la fecha configurada
    SELECT TO_CHAR(C.VALOR)
      INTO LC_FECFIN_ROTACION
      FROM CONSTANTE C
     WHERE C.CONSTANTE = 'DTHROTACION';

    IF (TO_CHAR(TRUNC(SYSDATE), 'DD/MM/YYYY') = LC_FECFIN_ROTACION) THEN
      SELECT ADD_MONTHS(LC_FECFIN_ROTACION, 12)
        INTO LC_FECFIN_ROTACION
        FROM DUAL;

      UPDATE CONSTANTE
         SET VALOR = LC_FECFIN_ROTACION
       WHERE CONSTANTE = 'DTHROTACION';
      COMMIT;
    END IF;
    -- Fin actualizacion de fecha de rotacion







    SELECT to_date(C.VALOR, 'DD/MM/YYYY')
      INTO V_FECFIN
      FROM CONSTANTE C
     WHERE C.CONSTANTE = 'DTHROTACION';
    -- Validamos que ingrese estados 1 o 4
    IF K_ESTADO NOT IN (C_GENERADO, C_PROV_ERROR) OR K_ESTADO IS NULL THEN
      k_RESPUESTA := '-1';
      k_MENSAJE   := 'ERROR: EL ESTADO INGRESADO DEBE SER generado(1) o error(4).';
      RAISE EX_ERROR;
    END IF;
    --Cargamos desde constantes BD el numero de reintentos permitido
    BEGIN
      SELECT VALOR
        INTO V_REINTENTOSC
        FROM OPERACION.CONSTANTE
       WHERE CONSTANTE = 'CONTEGO_REINTEN';
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        k_RESPUESTA := '-1';
        k_MENSAJE   := 'ERROR: NO SE ENCUENTRAN CONFIGURADOS LOS REINTENTOS EN LA TABLA OPERACION.CONSTANTE';
        RAISE EX_ERROR;
    END;
    FOR C_TRANS IN C_TRANS_CONTEGO LOOP
      V_CODSOLOT := C_TRANS.TRXN_CODSOLOT;
      -- Valida reintentos, si es mayor al numero de reintentos configurados cambia a estado 5
      IF K_ESTADO = C_PROV_ERROR AND
         C_TRANS.TRXC_REINTENTOS >= V_REINTENTOSC THEN
        BEGIN
          UPDATE OPERACION.SGAT_TRXCONTEGO S
             SET S.TRXC_ESTADO  = C_PROV_REPORTADO,
                 S.TRXV_MSJ_ERR = C_MSG_REINTENTO
           WHERE S.TRXN_IDTRANSACCION = C_TRANS.TRXN_IDTRANSACCION;
        EXCEPTION
          WHEN OTHERS THEN
            k_RESPUESTA := '-1';
            k_MENSAJE   := 'ERROR: ' || SQLCODE || ' ' || SQLERRM || ' ' ||
                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
            RAISE EX_ERROR;
        END;
        --Si es error aumentamos en 1 el conteo de reintentos
      ELSIF K_ESTADO = C_PROV_ERROR THEN
        BEGIN
          UPDATE OPERACION.SGAT_TRXCONTEGO S
             SET S.TRXC_REINTENTOS = S.TRXC_REINTENTOS + 1
           WHERE S.TRXN_IDTRANSACCION = C_TRANS.TRXN_IDTRANSACCION;
        EXCEPTION
          WHEN OTHERS THEN
            k_RESPUESTA := '-1';
            k_MENSAJE   := 'ERROR: ' || SQLCODE || ' ' || SQLERRM || ' ' ||
                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
            RAISE EX_ERROR;
        END;
        -- Si es generado por primera vez le asignamos una fecha y cambiamos de estado a enviado
      ELSIF K_ESTADO = C_GENERADO THEN
        BEGIN
          UPDATE OPERACION.SGAT_TRXCONTEGO A
             SET A.TRXD_FECINI = TRUNC(SYSDATE, 'MONTH'),
                 A.TRXD_FECFIN = V_FECFIN
           WHERE A.TRXN_IDTRANSACCION = C_TRANS.TRXN_IDTRANSACCION;
        EXCEPTION
          WHEN OTHERS THEN
            k_RESPUESTA := '-1';
            k_MENSAJE   := 'ERROR: ' || SQLCODE || ' ' || SQLERRM || ' ' ||
                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
            RAISE EX_ERROR;
        END;
      END IF;
    END LOOP;
    --Fin Valida reintentos

    --Enviaremos un secuencial con el fin de tener mapeado el lote que enviamos a IL
    SELECT OPERACION.SGASEQ_TRANSCONTEGO.NEXTVAL
      INTO V_SGASEQ_TRANSCONTEGO
      FROM DUAL;

    -- Inicio Enviar Cursor
    OPEN K_CURSOR FOR
      SELECT TRX.TRXN_IDTRANSACCION,
             TRX.TRXN_ACTION_ID,
             TRX.TRXV_TIPO,
             TRX.TRXV_SERIE_TARJETA,
             TRX.TRXV_SERIE_DECO,
             TRX.TRXV_BOUQUET,
             TO_CHAR(TRX.TRXD_FECINI, 'YYYY-MM-DD') TRXD_FECINI,
             TO_CHAR(TRX.TRXD_FECFIN, 'YYYY-MM-DD') TRXD_FECFIN,
             V_SGASEQ_TRANSCONTEGO TRANSCONTEGO
        FROM OPERACION.SGAT_TRXCONTEGO TRX
       WHERE TRX.TRXC_ESTADO = K_ESTADO
       ORDER BY TRX.TRXN_IDTRANSACCION, TRX.TRXN_PRIORIDAD ASC;
    -- Fin Enviar Cursor
    -- Despues de que el cursor recogio la data cambiamos a estado enviado
    IF K_ESTADO = C_GENERADO THEN
      FOR I IN C_TRANS_CONTEGO LOOP
        BEGIN
          UPDATE OPERACION.SGAT_TRXCONTEGO A
             SET A.TRXC_ESTADO = C_ENVIADO
           WHERE A.TRXN_IDTRANSACCION = I.TRXN_IDTRANSACCION;
        EXCEPTION
          WHEN OTHERS THEN
            k_RESPUESTA := '-1';
            k_MENSAJE   := 'ERROR: ' || SQLCODE || ' ' || SQLERRM || ' ' ||
                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
            RAISE EX_ERROR;
        END;
      END LOOP;
    END IF;
    COMMIT;
  EXCEPTION
    WHEN EX_ERROR THEN
      SGASP_LOGERR(C_SP_WSCONTEGO,
                   null,
                   V_CODSOLOT,
                   k_RESPUESTA,
                   k_MENSAJE);
      ROLLBACK;
    WHEN OTHERS THEN
      k_RESPUESTA := '-1';
      k_MENSAJE   := 'ERROR: ' || SQLCODE || ' ' || SQLERRM || ' ' ||
                     DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      SGASP_LOGERR(C_SP_WSCONTEGO,
                   null,
                   V_CODSOLOT,
                   k_RESPUESTA,
                   k_MENSAJE);
      ROLLBACK;
  END;
  /****************************************************************
  * Nombre SP      : SGASI_REGCONTEGO
  * Proposito      : SP utilizado para realizar la grabacion en la
                     tabla transaccional
  * Input          : K_TRS - rowtype de SGAT_TRXCONTEGO
  * Output         : K_RESPUESTA
  * Creado por     : Jose Arriola
  * Fec. Creacion  : 01/08/2017
  * Fec. Actualizacion : 26/02/2020
  ****************************************************************/
  PROCEDURE SGASI_REGCONTEGO(K_TRS       IN OPERACION.SGAT_TRXCONTEGO%ROWTYPE,
                             K_RESPUESTA OUT VARCHAR2) IS
    V_CONTEGO OPERACION.SGAT_TRXCONTEGO%ROWTYPE;
    V_EXISTE NUMBER:=0; --6.0
  BEGIN
    K_RESPUESTA := 'OK';

    V_CONTEGO.TRXN_CODSOLOT      := K_TRS.TRXN_CODSOLOT;
    V_CONTEGO.TRXN_ACTION_ID     := K_TRS.TRXN_ACTION_ID;
    V_CONTEGO.TRXV_TIPO          := K_TRS.TRXV_TIPO;
    V_CONTEGO.TRXV_SERIE_TARJETA := K_TRS.TRXV_SERIE_TARJETA;
    V_CONTEGO.TRXV_SERIE_DECO    := K_TRS.TRXV_SERIE_DECO;
    V_CONTEGO.TRXV_BOUQUET       := K_TRS.TRXV_BOUQUET;
    V_CONTEGO.TRXN_PRIORIDAD     := K_TRS.TRXN_PRIORIDAD;
    V_CONTEGO.TRXN_IDLOTE        := K_TRS.TRXN_IDLOTE;
    V_CONTEGO.TRXN_IDSOL         := K_TRS.TRXN_IDSOL;
    
     -- ini 6.0
    SELECT COUNT(*)
      INTO V_EXISTE
      FROM OPERACION.SGAT_CONTROL_APP
     WHERE CONTROLN_CODSOLOT = V_CONTEGO.TRXN_CODSOLOT;
    
    IF V_EXISTE > 0 THEN
       V_CONTEGO.TRXC_ESTADO := C_GENERADO_APP;
       ELSE 
       V_CONTEGO.TRXC_ESTADO := C_GENERADO;
    END IF;
    -- fin 6.0
    
    V_CONTEGO.TRXV_CODUSU        := USER;
    V_CONTEGO.TRXD_FECUSU        := SYSDATE;
    V_CONTEGO.TRXC_REINTENTOS    := 0;

    INSERT INTO OPERACION.SGAT_TRXCONTEGO VALUES V_CONTEGO;
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.put_line('ERROR: ' || SQLCODE || ' ' || SQLERRM || ' ' ||
                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
      K_RESPUESTA := 'ERROR';
      SGASP_LOGERR('SGASI_REGCONTEGO',NULL,K_TRS.TRXN_CODSOLOT,k_RESPUESTA,SQLERRM);




  END;
  /****************************************************************
  * Nombre SP      : SGASI_REGCONTEGOHIST
  * Proposito      : SP utilizado para grabar en la tabla historica y
                     eliminarlo de la transaccional
  * Input          : K_CODSOLOT - SOT
  * Output         : K_RESPUESTA
  * Creado por     : Jose Arriola
  * Fec. Creacion  : 01/08/2017
  * Fec. Actualizacion : --
  ****************************************************************/
  PROCEDURE SGASI_REGCONTEGOHIST(K_CODSOLOT  IN OPERACION.SGAT_TRXCONTEGO.TRXN_CODSOLOT%TYPE,
                                 K_RESPUESTA OUT NUMBER) IS
  BEGIN
    k_RESPUESTA := 0;

    BEGIN
      INSERT INTO OPERACION.SGAT_TRXCONTEGO_HIST
        (TRXN_IDTRANSACCION,
         TRXN_CODSOLOT,
         TRXN_ACTION_ID,
         TRXV_TIPO,
         TRXV_SERIE_TARJETA,
         TRXV_SERIE_DECO,
         TRXV_BOUQUET,
         TRXC_ESTADO,
         TRXV_MSJ_ERR,
         TRXN_IDLOTE,
         TRXN_PRIORIDAD,
         TRXN_IDSOL,
         TRXD_FECUSU,
         TRXV_CODUSU,
         TRXD_FECMOD,
         TRXV_USUMOD)
        SELECT A.TRXN_IDTRANSACCION,
               A.TRXN_CODSOLOT,
               A.TRXN_ACTION_ID,
               A.TRXV_TIPO,
               A.TRXV_SERIE_TARJETA,
               A.TRXV_SERIE_DECO,
               A.TRXV_BOUQUET,
               A.TRXC_ESTADO,
               A.TRXV_MSJ_ERR,
               A.TRXN_IDLOTE,
               A.TRXN_PRIORIDAD,
               A.TRXN_IDSOL,
               A.TRXD_FECUSU,
               A.TRXV_CODUSU,
               SYSDATE,
               USER
          FROM OPERACION.SGAT_TRXCONTEGO A
         WHERE A.TRXN_CODSOLOT = K_CODSOLOT;
    EXCEPTION
      WHEN OTHERS THEN
        k_RESPUESTA := -1;
        SGASP_LOGERR(C_SP_REGCONTEGO,null,K_CODSOLOT,k_RESPUESTA,sqlerrm);




        RETURN;
    END;

    DELETE FROM OPERACION.SGAT_TRXCONTEGO B
     WHERE B.TRXN_CODSOLOT = K_CODSOLOT;
  EXCEPTION
    WHEN OTHERS THEN
      K_RESPUESTA := -2;
      SGASP_LOGERR(C_SP_REGCONTEGO, null, K_CODSOLOT, K_RESPUESTA, sqlerrm);
      RETURN;
  END;
  /****************************************************************
  * Nombre SP      : SGASI_REGLOTEHIST
  * Proposito      : SP utilizado para grabar en la tabla historica y
                     eliminarlo de la transaccional
  * Input          : K_CODSOLOT - SOT
  * Output         : K_RESPUESTA
  * Creado por     : Jose Arriola
  * Fec. Creacion  : 01/08/2017
  * Fec. Actualizacion : --
  ****************************************************************/
  PROCEDURE SGASI_REGLOTEHIST(K_LOTE      IN OPERACION.SGAT_TRXCONTEGO.TRXN_IDLOTE%TYPE,
                              K_RESPUESTA OUT NUMBER) IS
    v_idtransaccion varchar2(50);
    v_codsolot      varchar2(50);
    CURSOR C_REGISTRO_LOTE IS
      SELECT A.TRXN_IDTRANSACCION,
             A.TRXN_CODSOLOT,
             A.TRXN_ACTION_ID,
             A.TRXV_TIPO,
             A.TRXV_SERIE_TARJETA,
             A.TRXV_SERIE_DECO,
             A.TRXV_BOUQUET,
             A.TRXC_ESTADO,
             A.TRXV_MSJ_ERR,
             A.TRXN_IDLOTE,
             A.TRXN_PRIORIDAD,
             A.TRXN_IDSOL,
             A.TRXD_FECUSU,
             A.TRXV_CODUSU
        FROM OPERACION.SGAT_TRXCONTEGO A
       WHERE A.TRXN_IDLOTE = K_LOTE
       ORDER BY A.TRXN_IDTRANSACCION ASC;
  BEGIN
    k_RESPUESTA := 0;

    FOR I IN C_REGISTRO_LOTE LOOP
      v_idtransaccion := i.trxn_idtransaccion;
      v_codsolot := i.trxn_codsolot;
      BEGIN
        INSERT INTO OPERACION.SGAT_TRXCONTEGO_HIST
          (TRXN_IDTRANSACCION,
           TRXN_CODSOLOT,
           TRXN_ACTION_ID,
           TRXV_TIPO,
           TRXV_SERIE_TARJETA,
           TRXV_SERIE_DECO,
           TRXV_BOUQUET,
           TRXC_ESTADO,
           TRXV_MSJ_ERR,
           TRXN_IDLOTE,
           TRXN_PRIORIDAD,
           TRXN_IDSOL,
           TRXD_FECUSU,
           TRXV_CODUSU,
           TRXD_FECMOD,
           TRXV_USUMOD)
          SELECT v_idtransaccion,
                 v_codsolot,
                 I.TRXN_ACTION_ID,
                 I.TRXV_TIPO,
                 I.TRXV_SERIE_TARJETA,
                 I.TRXV_SERIE_DECO,
                 I.TRXV_BOUQUET,
                 I.TRXC_ESTADO,
                 I.TRXV_MSJ_ERR,
                 I.TRXN_IDLOTE,
                 I.TRXN_PRIORIDAD,
                 I.TRXN_IDSOL,
                 I.TRXD_FECUSU,
                 I.TRXV_CODUSU,
                 SYSDATE,
                 USER
            FROM OPERACION.SGAT_TRXCONTEGO A
           WHERE A.TRXN_IDTRANSACCION = v_idtransaccion;
      EXCEPTION
        WHEN OTHERS THEN
          k_RESPUESTA := -1;
          SGASP_LOGERR(C_SP_REGCONTEGO,
                       v_idtransaccion,
                       v_codsolot,
                       k_RESPUESTA,
                       sqlerrm);
          RETURN;
      END;

      DELETE FROM OPERACION.SGAT_TRXCONTEGO B
       WHERE B.TRXN_IDTRANSACCION = v_idtransaccion;
    END LOOP;

  EXCEPTION
    WHEN OTHERS THEN
      K_RESPUESTA := -2;
      SGASP_LOGERR(C_SP_REGCONTEGO,
                   v_idtransaccion,
                   v_codsolot,
                   K_RESPUESTA,
                   sqlerrm);
      RETURN;
  END;
  /****************************************************************
  * Nombre SP      : SGASP_LOGERR
  * Proposito      : Todos los procesos van a tener que volcar sus errores
                     en una tabla donde se manejen los logs.
                     Este SP recibe los datos necesarios para saber que tipo
                     de error sucedi?, cuando y en que proceso y los graba en
                     la tabla OPERACION.SGAT_LOGERR
  * Input          : p_logerrv_proceso - Proceso (sp o function) en el cual ocurrio
                                         la incidencia o error.
                     p_logerrc_numregistro - numero de registro
                     p_logerrc_codsolot - SOT
                     p_logerrv_error - codigo de error
                     p_logerrv_texto - descripcion del error
  * Creado por     : Jose Arriola
  * Fec. Creacion  : 01/08/2017
  * Fec. Actualizacion : --
  ****************************************************************/
  PROCEDURE SGASP_LOGERR(p_logerrv_proceso     operacion.sgat_logerr.logerrv_proceso%type,
                         p_logerrc_numregistro operacion.sgat_logerr.logerrc_numregistro%type,
                         p_logerrc_codsolot    operacion.sgat_logerr.logerrc_codsolot%type,
                         p_logerrv_error       operacion.sgat_logerr.logerrv_error%type,
                         p_logerrv_texto       operacion.sgat_logerr.logerrv_texto%type) is
    pragma autonomous_transaction;
  begin
    insert into OPERACION.SGAT_LOGERR
      (logerrv_proceso,
       logerrc_numregistro,
       logerrc_codsolot,
       logerrv_error,
       logerrv_texto)
    values
      (p_logerrv_proceso,
       p_logerrc_numregistro,
       p_logerrc_codsolot,
       p_logerrv_error,
       p_logerrv_texto);
    commit;
  end SGASP_LOGERR;
  /****************************************************************
  * Nombre SP      : SGASU_TRSCONTEGO
  * Proposito      : Un servicio atomico se encargara de invocar el SP
                     que traera la respuesta de contego y actualizara
                     el estado de la tabla transaccional.
                     Dichos errores se traduciran y se actualizaran los
                     estados y la descripcion del mismo.
  * Input          : K_IDTRANSACCION - Identificador princial de la tabla
                                       transaccional SGAT_TRXCONTEGO
                     K_ESTADO - Estado de la transaccion
  * Output         : K_RESPUESTA
                     K_MENSAJE
  * Creado por     : Jose Arriola
  * Fec. Creacion  : 01/08/2017
  * Fec. Actualizacion : --
  ****************************************************************/
  PROCEDURE SGASU_TRSCONTEGO(K_IDTRANSACCION OPERACION.SGAT_TRXCONTEGO.TRXN_IDTRANSACCION%TYPE,
                             K_ESTADO        VARCHAR2,
                             K_MSJCONTEGO    VARCHAR2,
                             K_RESPUESTA     OUT NUMBER,
                             K_MENSAJE       OUT VARCHAR2) IS
    V_SOT CHAR(15);
    EX_ERROR EXCEPTION;
    V_LOTE  OPERACION.SGAT_TRXCONTEGO.TRXN_IDLOTE%TYPE;
    V_IDSOL OPERACION.SGAT_TRXCONTEGO.TRXN_IDSOL%TYPE;
    --  operacion.sgat_logerr.logerrv_proceso%type,
  BEGIN
    BEGIN
      SELECT C.TRXN_IDLOTE, C.TRXN_IDSOL
        INTO V_LOTE, V_IDSOL
        FROM OPERACION.SGAT_TRXCONTEGO C
       WHERE C.TRXN_IDTRANSACCION = K_IDTRANSACCION
         AND C.TRXN_IDLOTE IS NOT NULL;

      IF K_ESTADO = C_PROV_OK THEN
        BEGIN
          UPDATE OPERACION.OPE_TVSAT_LOTE_SLTD_AUX L
             SET L.ESTADO = C_AUX_ENVIADA
           WHERE L.IDLOTE = V_LOTE
             AND L.ESTADO <> C_AUX_ENVIADA;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
        BEGIN
          UPDATE OPERACION.OPE_TVSAT_SLTD_CAB SC
             SET SC.ESTADO = C_CAB_ENVIADA
           WHERE SC.IDSOL = V_IDSOL
             AND SC.ESTADO <> C_CAB_ENVIADA;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
        BEGIN
          UPDATE OPERACION.OPE_TVSAT_ARCHIVO_CAB AC
             SET AC.ESTADO = C_CAB_ENVIADA
           WHERE AC.IDLOTE = V_LOTE
             AND AC.ESTADO <> C_CAB_ENVIADA;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
      ELSIF K_ESTADO = C_PROV_ERROR THEN
        BEGIN
          UPDATE OPERACION.OPE_TVSAT_LOTE_SLTD_AUX L
             SET L.ESTADO = C_AUX_ENVIADA
           WHERE L.IDLOTE = V_LOTE
             AND L.ESTADO <> C_AUX_ENVIADA;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
        BEGIN
          UPDATE OPERACION.OPE_TVSAT_SLTD_CAB SC
             SET SC.ESTADO = C_AUX_ENVIADA
           WHERE SC.IDSOL = V_IDSOL
             AND SC.ESTADO <> C_AUX_ENVIADA;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
        BEGIN
          UPDATE OPERACION.OPE_TVSAT_ARCHIVO_CAB AC
             SET AC.ESTADO = C_AUX_ENVIADA
           WHERE AC.IDLOTE = V_LOTE
             AND AC.ESTADO <> C_AUX_ENVIADA;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
      END IF;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        NULL;
    END;
    SGASP_UPD_EST_CONTEGO(K_IDTRANSACCION,
                          K_ESTADO,
                          K_MSJCONTEGO,
                          K_RESPUESTA,
                          K_MENSAJE);
    COMMIT;
  EXCEPTION
    WHEN EX_ERROR THEN
      SGASP_LOGERR(C_UPD_CONTEGO, NULL, V_SOT, k_RESPUESTA, k_MENSAJE);
    WHEN OTHERS THEN
      K_RESPUESTA := -1;
      K_MENSAJE   := SQLCODE || ' ' || SQLERRM;
      SGASP_LOGERR(C_UPD_CONTEGO, null, V_SOT, K_RESPUESTA, K_MENSAJE);
      ROLLBACK;
  END;
  /****************************************************************
  * Nombre SP      : SGASS_ENVHISTCONTEGO
  * Proposito      : Un JAR se encargara de invocar al sp, el mismo que
                     se encarga de trasladar todos los registros procesados
                     correctamente (Estado 3) de la tabla transaccional
                     hasta la tabla historica
  * Output         : k_RESPUESTA
                     k_MENSAJE
  * Creado por     : Jose Arriola
  * Fec. Creacion  : 01/08/2017
  * Fec. Actualizacion : --
  ****************************************************************/
  PROCEDURE SGASS_ENVHISTCONTEGO(k_RESPUESTA OUT NUMBER,
                                 k_MENSAJE   OUT VARCHAR2) IS

    V_SOT     VARCHAR2(30);
    V_SOT_ANT VARCHAR2(30) := ' ';
    V_EST     NUMBER;
    V_EST_ANT NUMBER;
    COUNTER   NUMBER := 0;
    COUNTERT  NUMBER := 0;
    EX_ERROR EXCEPTION;

    CURSOR C_SOT_ESTADO_ALTA IS
      SELECT DISTINCT C.TRXN_CODSOLOT SOT, C.TRXC_ESTADO
        FROM OPERACION.SGAT_TRXCONTEGO C
       WHERE C.TRXN_ACTION_ID IN (C_ACTION_ALTA, C_ACTION_ACTIVACION)
       ORDER BY 1;

    CURSOR C_SOT_ESTADO_OTH IS
      SELECT C.TRXN_IDTRANSACCION
        FROM OPERACION.SGAT_TRXCONTEGO C
       WHERE C.TRXN_ACTION_ID NOT IN (C_ACTION_ALTA, C_ACTION_ACTIVACION)
         AND C.TRXC_ESTADO = C_PROV_OK;

  BEGIN
    k_RESPUESTA := 0;
    k_MENSAJE   := 'PROCESO TERMINADO SATISFACTORIAMENTE';
    SELECT COUNT(1)
      INTO COUNTERT
      from (SELECT DISTINCT C.TRXN_CODSOLOT, C.TRXC_ESTADO
              FROM OPERACION.SGAT_TRXCONTEGO C
             WHERE C.TRXN_ACTION_ID IN (C_ACTION_ALTA, C_ACTION_ACTIVACION));

    FOR C_TAR IN C_SOT_ESTADO_ALTA LOOP
      V_SOT := C_TAR.SOT;
      V_EST := C_TAR.TRXC_ESTADO;
      IF V_SOT <> V_SOT_ANT THEN
        IF COUNTER = COUNTERT - 1 THEN
          IF V_EST = C_PROV_OK THEN
            SGASI_REGCONTEGOHIST(V_SOT, k_RESPUESTA);
          END IF;
        ELSIF COUNTER > 0 AND V_EST_ANT = C_PROV_OK THEN
          SGASI_REGCONTEGOHIST(V_SOT_ANT, k_RESPUESTA);
        END IF;
        V_SOT_ANT := V_SOT;
        V_EST_ANT := V_EST;

        IF k_RESPUESTA = -1 THEN
          k_MENSAJE := 'EX_ERROR: NO SE PUDO REALIZAR LA TRANSACCION EN LA TABLA OPERACION.OPERACION.SGAT_TRXCONTEGOHIST';
          RAISE EX_ERROR;
        ELSIF k_RESPUESTA = -2 THEN
          k_MENSAJE := 'EX_ERROR: NO SE PUDO REALIZAR LA TRANSACCION EN LA TABLA OPERACION.OPERACION.SGAT_TRXCONTEGO';
          RAISE EX_ERROR;
        END IF;
      ELSE
        V_EST_ANT := '';
      END IF;
      COUNTER := COUNTER + 1;
    END LOOP;

    FOR C_TRANSACTION IN C_SOT_ESTADO_OTH LOOP
      BEGIN
        INSERT INTO OPERACION.SGAT_TRXCONTEGO_HIST
          (TRXN_IDTRANSACCION,
           TRXN_CODSOLOT,
           TRXN_ACTION_ID,
           TRXV_TIPO,
           TRXV_SERIE_TARJETA,
           TRXV_SERIE_DECO,
           TRXV_BOUQUET,
           TRXC_ESTADO,
           TRXV_MSJ_ERR,
           TRXN_IDLOTE,
           TRXN_PRIORIDAD,
           TRXN_IDSOL,
           TRXD_FECUSU,
           TRXV_CODUSU,
           TRXD_FECMOD,
           TRXV_USUMOD)
          SELECT A.TRXN_IDTRANSACCION,
                 A.TRXN_CODSOLOT,
                 A.TRXN_ACTION_ID,
                 A.TRXV_TIPO,
                 A.TRXV_SERIE_TARJETA,
                 A.TRXV_SERIE_DECO,
                 A.TRXV_BOUQUET,
                 A.TRXC_ESTADO,
                 A.TRXV_MSJ_ERR,
                 A.TRXN_IDLOTE,
                 A.TRXN_PRIORIDAD,
                 A.TRXN_IDSOL,
                 A.TRXD_FECUSU,
                 A.TRXV_CODUSU,
                 SYSDATE,
                 USER
            FROM OPERACION.SGAT_TRXCONTEGO A
           WHERE A.TRXN_IDTRANSACCION = C_TRANSACTION.TRXN_IDTRANSACCION;

        DELETE FROM OPERACION.SGAT_TRXCONTEGO B
         WHERE B.TRXN_IDTRANSACCION = C_TRANSACTION.TRXN_IDTRANSACCION;
      EXCEPTION
        WHEN EX_ERROR THEN
          SGASP_LOGERR(C_SP_ENVHIST, null, V_SOT, k_RESPUESTA, k_MENSAJE);
        WHEN OTHERS THEN
          K_RESPUESTA := -1;
          SGASP_LOGERR(C_SP_ENVHIST, null, V_SOT, K_RESPUESTA, sqlerrm);
          RETURN;
      END;
    END LOOP;
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      k_RESPUESTA := -1;
      k_MENSAJE   := 'EX_ERROR: ' || sqlcode || ' ' || sqlerrm;
      SGASP_LOGERR(C_SP_ENVHIST, NULL, V_SOT, k_RESPUESTA, k_MENSAJE);
  END;
  /****************************************************************
  * Nombre SP      : SGASS_VALIDARALTA
  * Proposito      : Este SP se encargara de validar si se realizo la
                     activacion para ello consulta el estado de las
                     transacciones en la tabla OPERACION.SGAT_TRXCONTEGO
                     o la tabla HISTORICO.SGAT_TRXCONTEGO_HIST.
                     Para ello se buscara todos los estados de la SOT y
                     se mostrara cuales son y se modificara la tabla de provision
  * Input          : K_NUMREGISTRO - Numero de registro
  * Output         : k_RESPUESTA
                     k_MENSAJE
  * Creado por     : Jose Arriola
  * Fec. Creacion  : 01/08/2017
  * Fec. Actualizacion : --
  ****************************************************************/
  PROCEDURE SGASS_VALIDARALTA(K_NUMREGISTRO OPERACION.OPE_SRV_RECARGA_CAB.NUMREGISTRO%TYPE,
                              K_RESPUESTA   IN OUT VARCHAR2,
                              K_MENSAJE     IN OUT VARCHAR2) IS
    EX_ERROR EXCEPTION;
    V_CODSOLOT CHAR(15);
    V_CANTREG  NUMBER;
    V_OK       BOOLEAN := FALSE;
    V_ACTION   VARCHAR(50);
    CURSOR C_EST IS
      SELECT S.TRXV_SERIE_TARJETA, S.TRXC_ESTADO, S.TRXN_ACTION_ID
        FROM OPERACION.SGAT_TRXCONTEGO S
       WHERE S.TRXN_CODSOLOT = V_CODSOLOT
         AND S.TRXC_ESTADO <> C_PROV_CANCELADO
      UNION ALL
      SELECT SH.TRXV_SERIE_TARJETA, SH.TRXC_ESTADO, SH.TRXN_ACTION_ID
        FROM OPERACION.SGAT_TRXCONTEGO_HIST SH
       WHERE SH.TRXN_CODSOLOT = V_CODSOLOT
         AND SH.TRXC_ESTADO <> C_PROV_CANCELADO
       ORDER BY 1 DESC;
  BEGIN
    k_RESPUESTA := 'OK';
    K_MENSAJE   := '';
    V_CANTREG   := 0;
    BEGIN
      SELECT CODSOLOT
        INTO V_CODSOLOT
        FROM OPERACION.OPE_SRV_RECARGA_CAB
       WHERE NUMREGISTRO = k_NUMREGISTRO;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        k_RESPUESTA := 'ERROR';
        k_MENSAJE   := 'ERROR: NO SE ENCUENTRA EL SOT ASOCIADO AL NUMREGISTRO EN LA TABLA OPERACION.OPE_SRV_RECARGA_CAB';
        RAISE EX_ERROR;
    END;

    FOR I IN C_EST LOOP
      IF I.TRXC_ESTADO = 3 THEN
        V_OK := TRUE;
      END IF;

      CASE
        WHEN I.TRXN_ACTION_ID = 101 THEN V_ACTION := 'ALTA DE EQUIPO';
        WHEN I.TRXN_ACTION_ID = 103 THEN V_ACTION := 'ACTIVACION DE BOUQUETS';
        WHEN I.TRXN_ACTION_ID = 105 THEN V_ACTION := 'DESACTIVACION DE BOUQUETS';
        WHEN I.TRXN_ACTION_ID = 108 THEN V_ACTION := 'SUSPENSION DE EQUIPO';
        WHEN I.TRXN_ACTION_ID = 110 THEN V_ACTION := 'RECONEXION DE EQUIPO';





      END CASE;

      K_MENSAJE := K_MENSAJE || I.TRXV_SERIE_TARJETA || ' - ' || SGAFUN_OBT_MSJ(I.TRXC_ESTADO) || ' - ' || V_ACTION || CHR(13);


      V_CANTREG := V_CANTREG + 1;
      END LOOP;

    IF NOT V_OK AND V_CANTREG > 0 THEN
      K_RESPUESTA := 'ERROR';
    END IF;

    IF V_CANTREG = 0 THEN
      K_RESPUESTA := 'ERROR';
    END IF;

  EXCEPTION
    WHEN EX_ERROR THEN
      SGASP_LOGERR(C_SP_VALIDAALTA,k_NUMREGISTRO,V_CODSOLOT,k_RESPUESTA,k_MENSAJE);




    WHEN OTHERS THEN
      k_RESPUESTA := 'ERROR1';
      k_MENSAJE   := 'ERROR: ' || SQLCODE || ' ' || SQLERRM || ' ' ||
                     DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      SGASP_LOGERR(C_SP_VALIDAALTA,k_NUMREGISTRO,V_CODSOLOT,k_RESPUESTA,k_MENSAJE);




      ROLLBACK;
  END;
  PROCEDURE SGASP_UPD_EST_CONTEGO(K_IDTRANSACCION OPERACION.SGAT_TRXCONTEGO.TRXN_IDTRANSACCION%TYPE,
                                  K_ESTADO        VARCHAR2,
                                  K_MSJCONTEGO    VARCHAR2 default null,
                                  K_RESPUESTA     OUT NUMBER,
                                  K_MENSAJE       OUT VARCHAR2

                                  ) IS
    V_SOT CHAR(15);
    EX_ERROR EXCEPTION;
  BEGIN
    k_RESPUESTA := 0;
    k_MENSAJE   := 'PROCESO TERMINADO SATISFACTORIAMENTE';
    BEGIN
      SELECT A.TRXN_CODSOLOT
        INTO V_SOT
        FROM OPERACION.SGAT_TRXCONTEGO A
       WHERE A.TRXN_IDTRANSACCION = K_IDTRANSACCION;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        k_RESPUESTA := -1;
        k_MENSAJE   := 'ERROR: NO SE ENCUENTRA EL SOT ASOCIADO A LA TRANSACCION EN LA TABLA OPERACION.SGAT_TRXCONTEGO';
        RAISE EX_ERROR;
    END;

    UPDATE OPERACION.SGAT_TRXCONTEGO S
       SET S.TRXC_ESTADO = K_ESTADO, S.TRXV_IDCONTEGO = K_MSJCONTEGO
     WHERE S.TRXN_IDTRANSACCION = K_IDTRANSACCION;

  EXCEPTION
    WHEN EX_ERROR THEN
      SGASP_LOGERR(C_UPD_CONTEGO, NULL, V_SOT, k_RESPUESTA, k_MENSAJE);
    WHEN OTHERS THEN
      K_RESPUESTA := -1;
      K_MENSAJE   := SQLCODE || ' ' || SQLERRM;
      SGASP_LOGERR(C_UPD_CONTEGO, null, V_SOT, K_RESPUESTA, K_MENSAJE);
      ROLLBACK;
  END;

  PROCEDURE SGASS_BAJA(K_NUMREGISTRO OPERACION.OPE_SRV_RECARGA_CAB.NUMREGISTRO%TYPE,
                       K_RESPUESTA   IN OUT VARCHAR2,
                       K_MENSAJE     IN OUT VARCHAR2) IS

    V_CODSOLOT OPERACION.SOLOT.CODSOLOT%TYPE;
    V_REG_DECO NUMBER;
    V_RESP     VARCHAR2(10);
    V_MSJ      VARCHAR2(1000);
    EX_ERROR EXCEPTION;

    CURSOR C_SOT_REEMPLAZO IS
      SELECT DISTINCT S.TRXN_CODSOLOT, S.TRXC_ESTADO
        FROM OPERACION.SGAT_TRXCONTEGO S
       WHERE S.TRXN_CODSOLOT = V_CODSOLOT
         AND S.TRXN_ACTION_ID = C_ACTION_BAJA
      UNION ALL
      SELECT DISTINCT H.TRXN_CODSOLOT, H.TRXC_ESTADO
        FROM OPERACION.SGAT_TRXCONTEGO_HIST H
       WHERE H.TRXC_ESTADO = C_PROV_OK
         AND H.TRXN_CODSOLOT = V_CODSOLOT
         AND H.TRXV_TIPO = C_ACTION_BAJA
       ORDER BY 2 DESC;
  BEGIN
    k_RESPUESTA := 'OK';
    k_MENSAJE   := 'PROCESO TERMINADO SATISFACTORIAMENTE';
    -- BLOQUE CONSULTAS
    BEGIN
      SELECT CODSOLOT
        INTO V_CODSOLOT
        FROM OPERACION.OPE_SRV_RECARGA_CAB
       WHERE NUMREGISTRO = k_NUMREGISTRO;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        k_RESPUESTA := 'ERROR';
        k_MENSAJE   := 'ERROR: NO SE ENCUENTRA EL SOT ASOCIADO AL NUMREGISTRO EN LA TABLA OPERACION.OPE_SRV_RECARGA_CAB';
        RAISE EX_ERROR;
    END;

    /*Verificamos que la linea no se encuentre registrada en la transaccional con estado 1 o en
    el historico con estado 3*/
    FOR C_SOT IN C_SOT_REEMPLAZO LOOP
      IF (C_SOT.TRXC_ESTADO = C_GENERADO) THEN
        IF SGAFUN_VALIDA_SOT(C_SOT.TRXN_CODSOLOT) = -1 THEN
          k_RESPUESTA := 'ERROR';
          k_MENSAJE   := 'ERROR: OCURRIO UN ERROR EL TRATAR DE ACTUALIZAR TABLA TRANSACCIONAL/HISTORICA';
          RAISE EX_ERROR;
        END IF;
      ELSIF (C_SOT.TRXC_ESTADO = C_PROV_OK) AND
            C_SOT_REEMPLAZO%ROWCOUNT = 1 THEN
        k_RESPUESTA := 'OK';
        k_MENSAJE   := 'PROVISIONADO: SE EJECUTO CORRECTAMENTE.';
        RAISE EX_ERROR;
      ELSIF (C_SOT.TRXC_ESTADO = C_ENVIADO) AND
            C_SOT_REEMPLAZO%ROWCOUNT = 1 THEN
        k_RESPUESTA := 'PENDIENTE';
        k_MENSAJE   := 'PENDIENTE: EN ESPERA DE RESPUESTA DE CONTEGO.';
        RAISE EX_ERROR;
      ELSE
        k_RESPUESTA := 'ERROR';
        k_MENSAJE   := 'ERROR: SE ENCONTRO ERRORES AL REALIZAR LA PROVISION EN CONTEGO.';
        RAISE EX_ERROR;
      END IF;
    END LOOP;
    --FIN VALIDACION
    --Ini 2.0
    /*
    SELECT COUNT(*)
      INTO V_REG_DECO
      FROM OPERACION.TARJETA_DECO_ASOC T
     WHERE CODSOLOT = V_CODSOLOT;

    IF V_REG_DECO = 0 THEN
      k_RESPUESTA := 'ERROR';
      k_MENSAJE   := 'ERROR: NO SE ASOCIO TARJETA CON DECODIFICADOR';
      RAISE EX_ERROR;
    END IF;*/
    --Fin 2.0

    SGASS_DESACTIVARBOUQUET(k_NUMREGISTRO, V_CODSOLOT, V_RESP, V_MSJ);
    IF V_RESP = 'ERROR' THEN
      k_RESPUESTA := V_RESP;
      k_MENSAJE   := V_MSJ;
      RAISE EX_ERROR;
    END IF;
  EXCEPTION
    WHEN EX_ERROR THEN
      SGASP_LOGERR(C_SP_BAJA,k_NUMREGISTRO,V_CODSOLOT,k_RESPUESTA,k_MENSAJE);




      ROLLBACK;
    WHEN OTHERS THEN
      k_RESPUESTA := 'ERROR';
      k_MENSAJE   := 'ERROR: ' || SQLCODE || ' ' || SQLERRM || ' ' ||
                     DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      SGASP_LOGERR(C_SP_BAJA,k_NUMREGISTRO,V_CODSOLOT,k_RESPUESTA,k_MENSAJE);




      ROLLBACK;
  END;

  PROCEDURE SGASS_VALPROVISION(K_CODSOLOT  OPERACION.SGAT_TRXCONTEGO.TRXN_CODSOLOT%TYPE,
                               K_RESPUESTA IN OUT VARCHAR2,
                               K_MENSAJE   IN OUT VARCHAR2) IS
    EX_ERROR EXCEPTION;
    V_NUMREGISTRO CHAR(15);
    V_ESTADO      VARCHAR2(50);
    V_COUNT       NUMBER := 0;
    V_CANTREG     NUMBER;
    CURSOR C_EST IS
      SELECT DISTINCT S.TRXC_ESTADO
        FROM OPERACION.SGAT_TRXCONTEGO S
       WHERE S.TRXN_CODSOLOT = K_CODSOLOT
         AND S.TRXC_ESTADO <> C_PROV_CANCELADO
      union all
      SELECT DISTINCT SH.TRXC_ESTADO
        FROM OPERACION.SGAT_TRXCONTEGO_HIST SH
       WHERE SH.TRXN_CODSOLOT = K_CODSOLOT
         AND SH.TRXC_ESTADO <> C_PROV_CANCELADO
       ORDER BY 1 DESC;
  BEGIN
    k_RESPUESTA := 'OK';

    SELECT COUNT(1)
      INTO V_CANTREG
      FROM (SELECT DISTINCT S.TRXC_ESTADO
              FROM OPERACION.SGAT_TRXCONTEGO S
             WHERE S.TRXN_CODSOLOT = K_CODSOLOT
               AND S.TRXC_ESTADO <> C_PROV_CANCELADO
            union all
            SELECT DISTINCT SH.TRXC_ESTADO
              FROM OPERACION.SGAT_TRXCONTEGO_HIST SH
             WHERE SH.TRXN_CODSOLOT = K_CODSOLOT
               AND SH.TRXC_ESTADO <> C_PROV_CANCELADO);

    FOR I IN C_EST LOOP
      IF V_CANTREG = 1 AND I.TRXC_ESTADO = C_PROV_OK THEN
        k_RESPUESTA := 'OK';
        k_MENSAJE   := 'EL REGISTRO FUE PROVISIONADO CORRECTAMENTE';
      ELSIF V_CANTREG = 1 AND I.TRXC_ESTADO = C_GENERADO THEN
        k_MENSAJE := 'EL REGISTRO ESTA GENERADO A LA ESPERA DE SU ENVIO';
      ELSIF V_CANTREG = 1 AND I.TRXC_ESTADO = C_ENVIADO THEN
        k_MENSAJE := 'EL REGISTRO ESTA EN PROCESO DE PROVISION';
      ELSIF V_CANTREG = 1 AND
            I.TRXC_ESTADO IN (C_PROV_ERROR, C_PROV_REPORTADO) THEN
        k_RESPUESTA := 'ERROR';
        k_MENSAJE   := 'EL REGISTRO FUE PROVISIONADO CON ERRORES';
      ELSIF I.TRXC_ESTADO IN (C_PROV_ERROR, C_PROV_REPORTADO) THEN
        k_RESPUESTA := 'ERROR';
      END IF;
      IF V_CANTREG > 1 THEN
        IF V_COUNT = 0 THEN
          V_ESTADO := SGAFUN_OBT_MSJ(I.TRXC_ESTADO) || '(' || I.TRXC_ESTADO || ')';
        ELSE
          V_ESTADO := V_ESTADO || ', ' || SGAFUN_OBT_MSJ(I.TRXC_ESTADO) || '(' ||
                      I.TRXC_ESTADO || ')';
        END IF;
        k_MENSAJE := 'EL NUMREGISTRO INGRESADO TIENE LOS SIGUIENTES ESTADOS: ' ||
                     V_ESTADO;
      END IF;
      V_COUNT := V_COUNT + 1;
    END LOOP;
    IF V_COUNT = 0 THEN
      k_RESPUESTA := 'ERROR';
      k_MENSAJE   := 'ERROR: EL NUMREGISTRO NO SE ENCUENTRA REGISTRADO EN LA TABLA OPERACION.SGAT_TRXCONTEGO';
      RAISE EX_ERROR;
    END IF;

  EXCEPTION
    WHEN EX_ERROR THEN
      SGASP_LOGERR(C_SP_VALPROVISION,
                   V_NUMREGISTRO,
                   K_CODSOLOT,
                   k_RESPUESTA,
                   k_MENSAJE);
    WHEN OTHERS THEN
      k_RESPUESTA := 'ERROR1';
      k_MENSAJE   := 'ERROR: ' || SQLCODE || ' ' || SQLERRM || ' ' ||
                     DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      SGASP_LOGERR(C_SP_VALPROVISION,
                   V_NUMREGISTRO,
                   K_CODSOLOT,
                   k_RESPUESTA,
                   k_MENSAJE);
      ROLLBACK;
  END;

  PROCEDURE SGASS_ACTIVARBOUQUET_MASIVO(K_NUMREGISTRO OPERACION.OPE_SRV_RECARGA_CAB.NUMREGISTRO%TYPE,
                                        K_BOUQUET     OPERACION.SGAT_TRXCONTEGO.TRXV_BOUQUET%TYPE,
                                        K_FECINI      VARCHAR2,
                                        K_FECFIN      VARCHAR2,
                                        K_IDENVIO     NUMBER,
                                        K_RESPUESTA   IN OUT VARCHAR2,
                                        K_MENSAJE     IN OUT VARCHAR2) IS
    V_CODSOLOT OPERACION.SOLOT.CODSOLOT%TYPE;
    EX_ERROR EXCEPTION;
    V_CONTEGO OPERACION.SGAT_TRXCONTEGO%ROWTYPE;

    CURSOR C_TARJETAS IS
      SELECT DISTINCT IDTARJETA, CODSOLOT
        FROM OPERACION.TMP_TARJETAS
       WHERE FLG_INCLUIDO = 1
         AND IDENVIO = K_IDENVIO
       ORDER BY IDTARJETA ASC;

  BEGIN
    K_RESPUESTA := 'OK';
    K_MENSAJE   := 'PROCESO TERMINADO SATISFACTORIAMENTE';

    IF K_BOUQUET IS NULL THEN
      k_RESPUESTA := 'ERROR';
      k_MENSAJE   := 'ERROR: NO SE ENCUENTRA LOS BOUQUETS PARA REALIZAR LA ACTIVACION';
      RAISE EX_ERROR;
    END IF;

    FOR C_ACTIVAR IN C_TARJETAS LOOP
      IF C_ACTIVAR.IDTARJETA IS NULL THEN
        k_RESPUESTA := 'ERROR';
        k_MENSAJE   := 'ERROR: NO SE ASOCIO TARJETA CON SOT';
        RAISE EX_ERROR;
      END IF;
      V_CONTEGO.TRXN_CODSOLOT      := C_ACTIVAR.CODSOLOT;
      V_CONTEGO.TRXN_ACTION_ID     := SGAFUN_PARAM_CONTEGO('CONF_CONTEGO_ACT',
                                                           'CONF_ACT',
                                                           'ALTA-CONTEGO',
                                                           'N');
      V_CONTEGO.TRXV_SERIE_TARJETA := C_ACTIVAR.IDTARJETA;
      V_CONTEGO.TRXV_BOUQUET       := K_BOUQUET;
      V_CONTEGO.TRXD_FECINI        := TO_DATE(K_FECINI, 'YYYYMMDDHH24MI');
      V_CONTEGO.TRXD_FECFIN        := TO_DATE(K_FECFIN, 'YYYYMMDDHH24MI');
      V_CONTEGO.TRXN_PRIORIDAD     := SGAFUN_PARAM_CONTEGO('CONF_CONTEGO_ACT',
                                                           'CONF_ACT',
                                                           'ALTA-CONTEGO',
                                                           'AU');
      SGASI_REGCONTEGO(V_CONTEGO, k_RESPUESTA);
      IF k_RESPUESTA = 'ERROR' THEN
        k_MENSAJE := 'ERROR: AL GRABAR LAS TRANSACCIONES DE ACTIVACION EN LA TABLA OPERACION.SGAT_TRXCONTEGO.';
        EXIT;
      END IF;
    END LOOP;
  EXCEPTION
    WHEN EX_ERROR then
      SGASP_LOGERR(C_SP_ACTIVARBOUQUET_MASIVO,
                   k_NUMREGISTRO,
                   V_CODSOLOT,
                   k_RESPUESTA,
                   k_MENSAJE);
    WHEN OTHERS THEN
      k_RESPUESTA := 'ERROR';
      k_MENSAJE   := 'ERROR: AL GRABAR LAS TRANSACIONES DE ACTIVACION' ||
                     SQLCODE || ' ' || SQLERRM || ' ' ||
                     DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      SGASP_LOGERR(C_SP_ACTIVARBOUQUET_MASIVO,
                   k_NUMREGISTRO,
                   V_CODSOLOT,
                   k_RESPUESTA,
                   k_MENSAJE);
  END;

  PROCEDURE SGASS_DESACTIVARBOUQUET_MASIVO(K_NUMREGISTRO OPERACION.OPE_SRV_RECARGA_CAB.NUMREGISTRO%TYPE,
                                           K_BOUQUET     OPERACION.SGAT_TRXCONTEGO.TRXV_BOUQUET%TYPE,
                                           K_FECINI      VARCHAR2,
                                           K_FECFIN      VARCHAR2,
                                           K_IDENVIO     NUMBER,
                                           K_RESPUESTA   IN OUT VARCHAR2,
                                           K_MENSAJE     IN OUT VARCHAR2) IS
    V_CODSOLOT OPERACION.SOLOT.CODSOLOT%TYPE;
    EX_ERROR EXCEPTION;
    V_CONTEGO OPERACION.SGAT_TRXCONTEGO%ROWTYPE;

    CURSOR C_TARJETAS IS
      SELECT DISTINCT IDTARJETA, CODSOLOT
        FROM OPERACION.TMP_TARJETAS
       WHERE FLG_INCLUIDO = 1
         AND IDENVIO = K_IDENVIO
       ORDER BY IDTARJETA ASC;

  BEGIN
    K_RESPUESTA := 'OK';
    K_MENSAJE   := 'PROCESO TERMINADO SATISFACTORIAMENTE';

    IF K_BOUQUET IS NULL THEN
      k_RESPUESTA := 'ERROR';
      k_MENSAJE   := 'ERROR: NO SE ENCUENTRA LOS BOUQUETS PARA REALIZAR LA ACTIVACION';
      RAISE EX_ERROR;
    END IF;

    FOR C_DESACTIVAR IN C_TARJETAS LOOP
      V_CONTEGO.TRXN_CODSOLOT      := C_DESACTIVAR.CODSOLOT;
      V_CONTEGO.TRXN_ACTION_ID     := SGAFUN_PARAM_CONTEGO('CONF_CONTEGO_ACT',
                                                           'CONF_ACT',
                                                           'BAJA-CONTEGO',
                                                           'N');
      V_CONTEGO.TRXV_SERIE_TARJETA := C_DESACTIVAR.IDTARJETA;
      V_CONTEGO.TRXV_BOUQUET       := K_BOUQUET;
      V_CONTEGO.TRXD_FECINI        := TO_DATE(K_FECINI, 'YYYYMMDDHH24MI');
      V_CONTEGO.TRXD_FECFIN        := TO_DATE(K_FECFIN, 'YYYYMMDDHH24MI');
      V_CONTEGO.TRXN_PRIORIDAD     := SGAFUN_PARAM_CONTEGO('CONF_CONTEGO_ACT',
                                                           'CONF_ACT',
                                                           'BAJA-CONTEGO',
                                                           'AU');
      SGASI_REGCONTEGO(V_CONTEGO, k_RESPUESTA);
      IF k_RESPUESTA = 'ERROR' THEN
        k_MENSAJE := 'ERROR: AL GRABAR LAS TRANSACCIONES DE ACTIVACION EN LA TABLA OPERACION.SGAT_TRXCONTEGO.';
        EXIT;
      END IF;
    END LOOP;
  EXCEPTION
    WHEN EX_ERROR then
      SGASP_LOGERR(C_SP_DESACTIVARBOUQUET_MASIVO,
                   k_NUMREGISTRO,
                   V_CODSOLOT,
                   k_RESPUESTA,
                   k_MENSAJE);
    WHEN OTHERS THEN
      k_RESPUESTA := 'ERROR';
      k_MENSAJE   := 'ERROR: AL GRABAR LAS TRANSACIONES DE ACTIVACION' ||
                     SQLCODE || ' ' || SQLERRM || ' ' ||
                     DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      SGASP_LOGERR(C_SP_DESACTIVARBOUQUET_MASIVO,
                   k_NUMREGISTRO,
                   V_CODSOLOT,
                   k_RESPUESTA,
                   k_MENSAJE);
  END;

  PROCEDURE SGASS_DESPAREO_MASIVO(K_NUMREGISTRO OPERACION.OPE_SRV_RECARGA_CAB.NUMREGISTRO%TYPE,
                                  K_IDENVIO     NUMBER,
                                  K_RESPUESTA   IN OUT VARCHAR2,
                                  K_MENSAJE     IN OUT VARCHAR2) IS
    V_CODSOLOT OPERACION.SOLOT.CODSOLOT%TYPE;
    EX_ERROR EXCEPTION;
    V_CONTEGO  OPERACION.SGAT_TRXCONTEGO%ROWTYPE;
    V_CONTADOR NUMBER := 0;

    CURSOR C_EQUIPOS_TARJETAS IS
      SELECT T.NRO_SERIE_DECO, T.NRO_SERIE_TARJETA, T.CODSOLOT
        FROM OPERACION.TARJETA_DECO_ASOC T
       WHERE T.NRO_SERIE_DECO IN
             (SELECT UNITADDRESS
                FROM OPERACION.TMP_DECOS
               WHERE FLG_INCLUIDO = 1
                 AND IDENVIO = K_IDENVIO);
  BEGIN
    k_RESPUESTA := 'OK';
    k_MENSAJE   := 'PROCESO TERMINADO SATISFACTORIAMENTE';

    BEGIN
      SELECT CODSOLOT
        INTO V_CODSOLOT
        FROM OPERACION.OPE_SRV_RECARGA_CAB
       WHERE NUMREGISTRO = K_NUMREGISTRO;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        NULL;
    END;

    FOR C_DESPAREO IN C_EQUIPOS_TARJETAS LOOP
      V_CONTEGO.TRXN_CODSOLOT      := C_DESPAREO.CODSOLOT;
      V_CONTEGO.TRXN_ACTION_ID     := SGAFUN_PARAM_CONTEGO('CONF_CONTEGO_ACT',
                                                           'CONF_ACT',
                                                           'DESPAREO-CONTEGO',
                                                           'N');
      V_CONTEGO.TRXV_TIPO          := 'DESPAREO';
      V_CONTEGO.TRXV_SERIE_TARJETA := C_DESPAREO.NRO_SERIE_TARJETA;
      V_CONTEGO.TRXV_SERIE_DECO    := C_DESPAREO.NRO_SERIE_DECO;
      V_CONTEGO.TRXN_PRIORIDAD     := SGAFUN_PARAM_CONTEGO('CONF_CONTEGO_ACT',
                                                           'CONF_ACT',
                                                           'DESPAREO-CONTEGO',
                                                           'AU');
      SGASI_REGCONTEGO(V_CONTEGO, k_RESPUESTA);
      IF k_RESPUESTA = 'ERROR' THEN
        k_MENSAJE := 'ERROR: AL GRABAR LAS TRANSACCIONES DE DESPAREO EN LA TABLA OPERACION.SGAT_TRXCONTEGO.';
        EXIT;
      END IF;
      V_CONTADOR := V_CONTADOR + 1;
    END LOOP;

    IF V_CONTADOR = 0 THEN
      k_RESPUESTA := 'ERROR';
      k_MENSAJE   := 'ERROR: NO SE ENCUENTRA NINGUN DECODIFICADOR ASOCIADO AL NUMREGISTRO/IDENVIO';
      RAISE EX_ERROR;
    END IF;

  EXCEPTION
    WHEN EX_ERROR THEN
      SGASP_LOGERR(C_SP_SGASS_CONSULTA_ERROR,
                   k_NUMREGISTRO,
                   V_CODSOLOT,
                   k_RESPUESTA,
                   k_MENSAJE);
    WHEN OTHERS THEN
      k_RESPUESTA := 'ERROR';
      k_MENSAJE   := 'ERROR: AL GRABAR LAS TRANSACIONES DE DESPAREO' ||
                     SQLCODE || ' ' || SQLERRM || ' ' ||
                     DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      SGASP_LOGERR(C_SP_DESPAREO_MASIVO,
                   k_NUMREGISTRO,
                   V_CODSOLOT,
                   k_RESPUESTA,
                   k_MENSAJE);
  END;

  PROCEDURE SGASS_REENVIO_LT_CONTEGO(K_LOTE_NEW  OPERACION.SGAT_TRXCONTEGO.TRXN_IDLOTE%TYPE,
                                     K_LOTE_ANT  OPERACION.SGAT_TRXCONTEGO.TRXN_IDLOTE%TYPE,
                                     K_RESPUESTA OUT VARCHAR2,
                                     K_MENSAJE   OUT VARCHAR2) IS
    EX_ERROR EXCEPTION;
    V_CODSOLOT CHAR(15);
    V_CONTEGO  OPERACION.SGAT_TRXCONTEGO%ROWTYPE;
    V_ACTION   OPERACION.SGAT_TRXCONTEGO.TRXN_ACTION_ID%TYPE;

    CURSOR C_LOTE_TARJETAS IS
      SELECT A.CODSOLOT,
             A.IDSOL,
             B.SERIE,
             to_char(listagg(to_number(C.BOUQUETE),',') within
                     group(order by C.BOUQUETE)) BOUQUETS
        FROM OPERACION.OPE_TVSAT_SLTD_CAB          A,
             OPERACION.OPE_TVSAT_SLTD_DET          B,
             OPERACION.OPE_TVSAT_SLTD_BOUQUETE_DET C,
             OPERACION.SOLOT                       D
       WHERE A.IDSOL = B.IDSOL
         AND B.IDSOL = C.IDSOL
         AND B.SERIE = C.SERIE
         AND A.IDLOTE = K_LOTE_NEW
         AND D.CODSOLOT(+) = A.CODSOLOT
       GROUP BY A.CODSOLOT, A.IDSOL, B.SERIE
       ORDER BY A.CODSOLOT;

  BEGIN
    k_RESPUESTA := 'OK';
    k_MENSAJE   := 'PROCESO TERMINADO SATISFACTORIAMENTE';

    IF K_LOTE_NEW IS NOT NULL THEN
      FOR C_LOTE IN C_LOTE_TARJETAS LOOP
        BEGIN
          SELECT A.TRXN_ACTION_ID
            INTO V_ACTION
            FROM OPERACION.SGAT_TRXCONTEGO A
           WHERE A.TRXN_IDLOTE = K_LOTE_ANT
             AND trim(A.TRXV_SERIE_TARJETA) = trim(C_LOTE.SERIE);
        EXCEPTION
          WHEN no_data_found THEN
            k_RESPUESTA := 'ERROR';
            k_MENSAJE   := 'ERROR: OCURRIO UN ERROR AL MOMENTO DE OBTENER EL ACTION_ID DEL LOTE: ' ||
                           K_LOTE_ANT || ' ' || C_LOTE.SERIE || ' ' ||
                           SQLERRM;
            RAISE EX_ERROR;
          WHEN others THEN
            k_RESPUESTA := 'ERROR';
            k_MENSAJE   := 'ERROR: OCURRIO UN ERROR AL MOMENTO DE OBTENER EL ACTION_ID DEL LOTE: ' ||
                           K_LOTE_ANT || ' ' || C_LOTE.SERIE || ' ' ||
                           SQLERRM;
            RAISE EX_ERROR;
        END;
        V_CODSOLOT                   := C_LOTE.CODSOLOT;
        V_CONTEGO.TRXN_CODSOLOT      := V_CODSOLOT;
        V_CONTEGO.TRXN_ACTION_ID     := V_ACTION;
        V_CONTEGO.TRXV_SERIE_TARJETA := C_LOTE.SERIE;
        V_CONTEGO.TRXV_BOUQUET       := C_LOTE.BOUQUETS;
        V_CONTEGO.TRXN_IDLOTE        := K_LOTE_NEW;
        V_CONTEGO.TRXN_PRIORIDAD     := SGAFUN_PARAM_CONTEGO('CONF_CONTEGO_ACT','CONF_ACT','SUSPENSION-CONTEGO','AU');



        V_CONTEGO.TRXN_IDSOL         := C_LOTE.IDSOL;
        SGASI_REGCONTEGO(V_CONTEGO, k_RESPUESTA);
        IF k_RESPUESTA = 'ERROR' THEN
          k_MENSAJE := 'ERROR: AL GRABAR LAS TRANSACCIONES DE REENVIO EN LA TABLA OPERACION.SGAT_TRXCONTEGO.';
          EXIT;
        END IF;
      END LOOP;
      IF SGAFUN_VALIDA_LOTE(K_LOTE_ANT) <> 0 THEN
        k_RESPUESTA := 'ERROR';
        k_MENSAJE   := 'ERROR: OCURRIO UN ERROR AL TRATAR DE ACTUALIZAR TABLA TRANSACCIONAL/HISTORICA';
        RAISE EX_ERROR;
      END IF;
    ELSE
      BEGIN
        UPDATE OPERACION.SGAT_TRXCONTEGO TRX
           SET TRX.TRXC_ESTADO = C_ENVIADO
         WHERE TRX.TRXN_IDLOTE = K_LOTE_ANT;
      EXCEPTION
        WHEN others THEN
          k_RESPUESTA := 'ERROR';
          k_MENSAJE   := SQLCODE || ' ' || SQLERRM || ' ' ||
                         DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      END;
    END IF;
  EXCEPTION
    WHEN EX_ERROR THEN
      SGASP_LOGERR(C_SP_REENV_LT, null, V_CODSOLOT, k_RESPUESTA, k_MENSAJE);
      ROLLBACK;
  END;

  PROCEDURE SGASS_CONSULTA_ERROR(K_NUMREGISTRO OPERACION.OPE_SRV_RECARGA_CAB.NUMREGISTRO%TYPE,
                                 K_MENSAJE     IN OUT OPERACION.SGAT_TRXCONTEGO.TRXV_MSJ_ERR%TYPE) IS
    EX_ERROR EXCEPTION;
    V_CODSOLOT  CHAR(15);
    k_RESPUESTA VARCHAR2(20);

    CURSOR C_MSG IS
      SELECT S.TRXV_MSJ_ERR
        FROM OPERACION.SGAT_TRXCONTEGO S
       WHERE S.TRXN_CODSOLOT = V_CODSOLOT
      UNION ALL
      SELECT SH.TRXV_MSJ_ERR
        FROM OPERACION.SGAT_TRXCONTEGO_HIST SH
       WHERE SH.TRXN_CODSOLOT = V_CODSOLOT
       ORDER BY 1 DESC;
  BEGIN
    k_RESPUESTA := 'OK';
    BEGIN
      SELECT CODSOLOT
        INTO V_CODSOLOT
        FROM OPERACION.OPE_SRV_RECARGA_CAB
       WHERE NUMREGISTRO = K_NUMREGISTRO;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        k_RESPUESTA := 'ERROR';
        K_MENSAJE   := 'ERROR: NO SE ENCUENTRA EL SOT ASOCIADO AL NUMREGISTRO EN LA TABLA OPERACION.OPE_SRV_RECARGA_CAB';
        RAISE EX_ERROR;
    END;
    FOR C IN C_MSG LOOP
      K_MENSAJE := K_MENSAJE || C.TRXV_MSJ_ERR;
    END LOOP;

  EXCEPTION
    WHEN EX_ERROR THEN
      SGASP_LOGERR(C_SP_SGASS_CONSULTA_ERROR,k_NUMREGISTRO,V_CODSOLOT,k_RESPUESTA,k_MENSAJE);




    WHEN OTHERS THEN
      k_RESPUESTA := 'ERROR1';
      k_MENSAJE   := 'ERROR: ' || SQLCODE || ' ' || SQLERRM || ' ' ||
                     DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      SGASP_LOGERR(C_SP_SGASS_CONSULTA_ERROR,k_NUMREGISTRO,V_CODSOLOT,k_RESPUESTA,k_MENSAJE);




      ROLLBACK;
  END;

  PROCEDURE SGASS_DESACTIVARBOUQUET(k_NUMREGISTRO OPERACION.OPE_SRV_RECARGA_CAB.NUMREGISTRO%TYPE,
                                    k_CODSOLOT    OPERACION.SOLOT.CODSOLOT%TYPE,
                                    K_RESPUESTA   IN OUT VARCHAR2,
                                    k_MENSAJE     IN OUT VARCHAR2) IS

    V_CONTEGO OPERACION.SGAT_TRXCONTEGO%ROWTYPE;
    V_NUMSLC  OPERACION.SOLOT.NUMSLC%TYPE;
    V_BOUQUET OPERACION.SGAT_TRXCONTEGO.TRXV_BOUQUET%TYPE;
    EX_ERROR EXCEPTION;

    CURSOR C_TARJETAS IS
      SELECT DISTINCT NUMSERIE
        FROM OPERACION.SOLOTPTOEQU
       WHERE CODSOLOT = k_CODSOLOT
         AND TIPEQU IN (SELECT A.CODIGON TIPEQUOPE
                          FROM OPERACION.OPEDD A, OPERACION.TIPOPEDD B
                         WHERE A.TIPOPEDD = B.TIPOPEDD
                           AND B.ABREV = 'TIPEQU_DTH_CONAX'
                           AND CODIGOC = '1')
       ORDER BY NUMSERIE;

  BEGIN
    k_RESPUESTA := 'OK';
    k_MENSAJE   := 'PROCESO TERMINADO SATISFACTORIAMENTE';
    V_NUMSLC    := SGAFUN_OBT_NUMSLC(k_NUMREGISTRO);
    IF V_NUMSLC IS NULL THEN
      k_RESPUESTA := 'ERROR';
      k_MENSAJE   := 'ERROR: NO SE ENCUENTRA EL NUMERO DE PROYECTO EN LA TABLA OPERACION.OPE_SRV_RECARGA_CAB';
      RAISE EX_ERROR;
    END IF;

    V_BOUQUET := SGAFUN_OBT_BOUQUET(k_NUMREGISTRO,V_NUMSLC,C_TIP_BOUQUET_BAJA);




    FOR C_DESACTIVAR IN C_TARJETAS LOOP
      V_CONTEGO.TRXN_CODSOLOT      := k_CODSOLOT;
      V_CONTEGO.TRXN_ACTION_ID     := SGAFUN_PARAM_CONTEGO('CONF_CONTEGO_ACT',
                                                           'CONF_ACT',
                                                           'BAJA-CONTEGO',
                                                           'N');
      V_CONTEGO.TRXV_SERIE_TARJETA := C_DESACTIVAR.NUMSERIE;
      V_CONTEGO.TRXV_BOUQUET       := V_BOUQUET;
      V_CONTEGO.TRXN_PRIORIDAD     := SGAFUN_PARAM_CONTEGO('CONF_CONTEGO_ACT',
                                                           'CONF_ACT',
                                                           'BAJA-CONTEGO',
                                                           'AU');
      SGASI_REGCONTEGO(V_CONTEGO, k_RESPUESTA);
      IF k_RESPUESTA = 'ERROR' THEN
        k_MENSAJE := 'ERROR: AL GRABAR LAS TRANSACCIONES DE ACTIVACION EN LA TABLA OPERACION.SGAT_TRXCONTEGO.';
        EXIT;
      END IF;
    END LOOP;
  EXCEPTION
    WHEN EX_ERROR then
      SGASP_LOGERR(C_SP_DESACTIVAR,
                   k_NUMREGISTRO,
                   k_CODSOLOT,
                   k_RESPUESTA,
                   k_MENSAJE);
    WHEN OTHERS THEN
      k_RESPUESTA := 'ERROR';
      k_MENSAJE   := 'ERROR: AL GRABAR LAS TRANSACIONES DE ACTIVACION' ||
                     SQLCODE || ' ' || SQLERRM || ' ' ||
                     DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      SGASP_LOGERR(C_SP_DESACTIVAR,
                   k_NUMREGISTRO,
                   k_CODSOLOT,
                   k_RESPUESTA,
                   k_MENSAJE);
  END;

  PROCEDURE SGASS_SUSPENSION_LTE(K_LOTE      OPERACION.SGAT_TRXCONTEGO.TRXN_IDLOTE%TYPE,
                                 K_RESPUESTA IN OUT VARCHAR2,
                                 k_MENSAJE   IN OUT VARCHAR2) IS

    V_CONTEGO  OPERACION.SGAT_TRXCONTEGO%ROWTYPE;
    V_CODSOLOT OPERACION.SGAT_TRXCONTEGO.TRXN_CODSOLOT%TYPE;
    EX_ERROR EXCEPTION;
    V_ACTION OPERACION.SGAT_TRXCONTEGO.TRXN_ACTION_ID%TYPE;

    CURSOR C_LOTE_TARJETAS IS
      select a.codsolot,
             a.idsol,
             d.tiptra,
             a.tiposolicitud,
             b.serie,
             to_char(listagg(to_number(c.bouquete),',') within
                     group(order by c.bouquete)) bouquets
        from operacion.ope_tvsat_sltd_cab          a,
             operacion.ope_tvsat_sltd_det          b,
             operacion.ope_tvsat_sltd_bouquete_det c,
             operacion.solot                       d
       where a.idsol = b.idsol
         and b.idsol = c.idsol
         and b.serie = c.serie
         and a.idlote = K_LOTE
         and d.codsolot(+) = a.codsolot
       group by a.codsolot, a.idsol, d.tiptra, a.tiposolicitud, b.serie
       order by a.codsolot;

  BEGIN
    k_RESPUESTA := 'OK';
    k_MENSAJE   := 'PROCESO TERMINADO SATISFACTORIAMENTE';

    FOR C_LOTE IN C_LOTE_TARJETAS LOOP
      V_CODSOLOT := C_LOTE.CODSOLOT;
      V_ACTION   := NVL(OPERACION.PKG_CONTEGO.SGAFUN_PARAM_CONTEGO('CONF_CONTEGO_TIPTRA_ACTIONID',
                                                                   C_LOTE.TIPOSOLICITUD,
                                                                   C_LOTE.TIPTRA,
                                                                   'A'),
                        C_ACTION_SUSPENSION);

      IF V_ACTION IS NULL THEN
        k_RESPUESTA := 'ERROR';
        k_MENSAJE   := 'ERROR: AL TRATAR DE INGRESAR EL ACTION. VERIFICAR EL TIPO DE TRABAJO/SOLICITUD. LOTE ' ||
                       K_LOTE;
        RAISE EX_ERROR;
      ELSE
        V_CONTEGO.TRXN_CODSOLOT      := C_LOTE.CODSOLOT;
        V_CONTEGO.TRXN_ACTION_ID     := V_ACTION;
        V_CONTEGO.TRXV_SERIE_TARJETA := C_LOTE.SERIE;
        V_CONTEGO.TRXV_BOUQUET       := C_LOTE.BOUQUETS;
        V_CONTEGO.TRXN_IDLOTE        := K_LOTE;
        V_CONTEGO.TRXN_PRIORIDAD     := SGAFUN_PARAM_CONTEGO('CONF_CONTEGO_ACT',
                                                             'CONF_ACT',
                                                             'SUSPENSION-CONTEGO',
                                                             'AU');
        V_CONTEGO.TRXN_IDSOL         := C_LOTE.IDSOL;
        SGASI_REGCONTEGO(V_CONTEGO, k_RESPUESTA);
        IF k_RESPUESTA = 'ERROR' THEN
          k_MENSAJE := 'ERROR: AL GRABAR LAS TRANSACCIONES DE PAREO EN LA TABLA OPERACION.SGAT_TRXCONTEGO.';
          EXIT;
        END IF;
      END IF;
    END LOOP;
  EXCEPTION
    WHEN EX_ERROR THEN
      SGASP_LOGERR(C_SP_SUSP_LTE, null, V_CODSOLOT, k_RESPUESTA, k_MENSAJE);
    WHEN OTHERS THEN
      k_RESPUESTA := 'ERROR';
      k_MENSAJE   := 'ERROR: AL GRABAR LAS TRANSACIONES DE PAREO ' ||
                     SQLCODE || ' ' || SQLERRM || ' ' ||
                     DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      SGASP_LOGERR(C_SP_SUSP_LTE, null, V_CODSOLOT, k_RESPUESTA, k_MENSAJE);
  END;
  PROCEDURE SGASS_RECONEXION_LTE(K_LOTE      OPERACION.SGAT_TRXCONTEGO.TRXN_IDLOTE%TYPE,
                                 K_RESPUESTA IN OUT VARCHAR2,
                                 k_MENSAJE   IN OUT VARCHAR2) IS

    V_CONTEGO  OPERACION.SGAT_TRXCONTEGO%ROWTYPE;
    V_CODSOLOT OPERACION.SGAT_TRXCONTEGO.TRXN_CODSOLOT%TYPE;
    V_ACTION   OPERACION.SGAT_TRXCONTEGO.TRXN_ACTION_ID%TYPE;

    CURSOR C_LOTE_TARJETAS IS
      select a.codsolot,
             a.idsol,
             d.tiptra,
             a.tiposolicitud,
             b.serie,
             a.flg_recarga,
             to_char(listagg(to_number(c.bouquete),',') within
                     group(order by c.bouquete)) bouquets
        from operacion.ope_tvsat_sltd_cab          a,
             operacion.ope_tvsat_sltd_det          b,
             operacion.ope_tvsat_sltd_bouquete_det c,
             operacion.solot                       d
       where a.idsol = b.idsol
         and b.idsol = c.idsol
         and b.serie = c.serie
         and a.idlote = K_LOTE
         and d.codsolot(+) = a.codsolot
       group by a.codsolot,a.idsol,d.tiptra,a.tiposolicitud,b.serie,a.flg_recarga




       order by a.codsolot;

  BEGIN
    k_RESPUESTA := 'OK';
    k_MENSAJE   := 'PROCESO TERMINADO SATISFACTORIAMENTE';

    FOR C_LOTE IN C_LOTE_TARJETAS LOOP
      V_ACTION := NVL(OPERACION.PKG_CONTEGO.SGAFUN_PARAM_CONTEGO('CONF_CONTEGO_TIPTRA_ACTIONID',
                                                                 C_LOTE.TIPOSOLICITUD,
                                                                 C_LOTE.TIPTRA,
                                                                 'A'),
                      C_ACTION_RECONEXION);

      V_CONTEGO.TRXN_CODSOLOT      := C_LOTE.CODSOLOT;
      V_CONTEGO.TRXN_ACTION_ID     := V_ACTION;
      V_CONTEGO.TRXV_SERIE_TARJETA := C_LOTE.SERIE;
      V_CONTEGO.TRXV_BOUQUET       := C_LOTE.BOUQUETS;
      V_CONTEGO.TRXN_IDLOTE        := K_LOTE;
      V_CONTEGO.TRXN_PRIORIDAD     := SGAFUN_PARAM_CONTEGO('CONF_CONTEGO_ACT',
                                                           'CONF_ACT',
                                                           'RECONEXION-CONTEGO',
                                                           'AU');
      V_CONTEGO.TRXN_IDSOL         := C_LOTE.IDSOL;
      SGASI_REGCONTEGO(V_CONTEGO, k_RESPUESTA);
      IF k_RESPUESTA = 'ERROR' THEN
        k_MENSAJE := 'ERROR: AL GRABAR LAS TRANSACCIONES DE PAREO EN LA TABLA OPERACION.SGAT_TRXCONTEGO.';
        EXIT;
      END IF;
    END LOOP;
  EXCEPTION
    WHEN OTHERS THEN
      k_RESPUESTA := 'ERROR';
      k_MENSAJE   := 'ERROR: AL GRABAR LAS TRANSACIONES DE PAREO ' ||
                     SQLCODE || ' ' || SQLERRM || ' ' ||
                     DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      SGASP_LOGERR(C_SP_SUSP_LTE, null, V_CODSOLOT, k_RESPUESTA, k_MENSAJE);
  END;

  PROCEDURE SGASS_SUSP_CANC_POSTPAGO(K_LOTE      OPERACION.SGAT_TRXCONTEGO.TRXN_IDLOTE%TYPE,
                                     K_RESPUESTA IN OUT VARCHAR2,
                                     k_MENSAJE   IN OUT VARCHAR2) IS

    V_CONTEGO  OPERACION.SGAT_TRXCONTEGO%ROWTYPE;
    V_CODSOLOT OPERACION.SGAT_TRXCONTEGO.TRXN_CODSOLOT%TYPE;
    EX_ERROR EXCEPTION;
    V_ACTION OPERACION.SGAT_TRXCONTEGO.TRXN_ACTION_ID%TYPE;

    CURSOR C_LOTE_TARJETAS IS
      select a.codsolot,
             a.idsol,
             a.tiposolicitud,
             b.serie,
             b.action_id,
             to_char(listagg(to_number(c.bouquete),',') within
                     group(order by c.bouquete)) bouquets
        from operacion.ope_tvsat_sltd_cab          a,
             operacion.ope_tvsat_sltd_det          b,
             operacion.ope_tvsat_sltd_bouquete_det c
       where a.idsol = b.idsol
         and b.idsol = c.idsol
         and b.serie = c.serie
         and a.idlote = K_LOTE
       group by a.codsolot, a.idsol, a.tiposolicitud, b.serie, b.action_id
       order by a.codsolot;

  BEGIN
    k_RESPUESTA := 'OK';
    k_MENSAJE   := 'PROCESO TERMINADO SATISFACTORIAMENTE';

    FOR C_LOTE IN C_LOTE_TARJETAS LOOP
      BEGIN
        SELECT TO_NUMBER(CODIGOC)
          INTO V_ACTION
          FROM OPEDD
         WHERE TIPOPEDD IN
               (SELECT TIPOPEDD FROM TIPOPEDD WHERE ABREV = C_DTH_ACTIONS)
           AND CODIGON = C_LOTE.ACTION_ID;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          V_ACTION := C_ACTION_SUSPENSION;
        WHEN OTHERS THEN
          V_ACTION := C_ACTION_SUSPENSION;
      END;
      V_CODSOLOT                   := C_LOTE.CODSOLOT;
      V_CONTEGO.TRXN_CODSOLOT      := C_LOTE.CODSOLOT;
      V_CONTEGO.TRXN_ACTION_ID     := V_ACTION;
      V_CONTEGO.TRXV_SERIE_TARJETA := C_LOTE.SERIE;
      V_CONTEGO.TRXV_BOUQUET       := C_LOTE.BOUQUETS;
      V_CONTEGO.TRXN_IDLOTE        := K_LOTE;
      V_CONTEGO.TRXN_PRIORIDAD     := SGAFUN_PARAM_CONTEGO('CONF_CONTEGO_ACT',
                                                           'CONF_ACT',
                                                           'SUSPENSION-CONTEGO',
                                                           'AU');
      V_CONTEGO.TRXN_IDSOL         := C_LOTE.IDSOL;
      SGASI_REGCONTEGO(V_CONTEGO, k_RESPUESTA);
      IF k_RESPUESTA = 'ERROR' THEN
        k_MENSAJE := 'ERROR: AL GRABAR LAS TRANSACCIONES DE SUSPENSION/CANCELACION EN LA TABLA OPERACION.SGAT_TRXCONTEGO.';
        EXIT;
      END IF;
    END LOOP;
  EXCEPTION
    WHEN EX_ERROR THEN
      SGASP_LOGERR(C_SP_SUSP_CANC_POS,
                   null,
                   V_CODSOLOT,
                   k_RESPUESTA,
                   k_MENSAJE);
    WHEN OTHERS THEN
      k_RESPUESTA := 'ERROR';
      k_MENSAJE   := 'ERROR: AL GRABAR LAS TRANSACIONES DE PAREO ' ||
                     SQLCODE || ' ' || SQLERRM || ' ' ||
                     DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      SGASP_LOGERR(C_SP_SUSP_LTE, null, V_CODSOLOT, k_RESPUESTA, k_MENSAJE);
  END;
  PROCEDURE SGASS_RECONEXION_POSTPAGO(K_LOTE      OPERACION.SGAT_TRXCONTEGO.TRXN_IDLOTE%TYPE,
                                      K_RESPUESTA IN OUT VARCHAR2,
                                      k_MENSAJE   IN OUT VARCHAR2) IS
    V_CONTEGO  OPERACION.SGAT_TRXCONTEGO%ROWTYPE;
    V_CODSOLOT OPERACION.SGAT_TRXCONTEGO.TRXN_CODSOLOT%TYPE;
    EX_ERROR EXCEPTION;
    V_ACTION OPERACION.SGAT_TRXCONTEGO.TRXN_ACTION_ID%TYPE;

    CURSOR C_LOTE_TARJETAS IS
      select a.codsolot,
             a.idsol,
             a.tiposolicitud,
             b.serie,
             b.action_id,
             to_char(listagg(to_number(c.bouquete),',') within
                     group(order by c.bouquete)) bouquets
        from operacion.ope_tvsat_sltd_cab          a,
             operacion.ope_tvsat_sltd_det          b,
             operacion.ope_tvsat_sltd_bouquete_det c
       where a.idsol = b.idsol
         and b.idsol = c.idsol
         and b.serie = c.serie
         and a.idlote = K_LOTE
       group by a.codsolot, a.idsol, a.tiposolicitud, b.serie, b.action_id
       order by a.codsolot;

  BEGIN
    k_RESPUESTA := 'OK';
    k_MENSAJE   := 'PROCESO TERMINADO SATISFACTORIAMENTE';

    FOR C_LOTE IN C_LOTE_TARJETAS LOOP
      BEGIN
        SELECT TO_NUMBER(CODIGOC)
          INTO V_ACTION
          FROM OPEDD
         WHERE TIPOPEDD IN
               (SELECT TIPOPEDD FROM TIPOPEDD WHERE ABREV = C_DTH_ACTIONS)
           AND CODIGON = C_LOTE.ACTION_ID;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          V_ACTION := C_ACTION_RECONEXION;
        WHEN OTHERS THEN
          V_ACTION := C_ACTION_RECONEXION;
      END;
      V_CONTEGO.TRXN_CODSOLOT      := C_LOTE.CODSOLOT;
      V_CONTEGO.TRXN_ACTION_ID     := V_ACTION;
      V_CONTEGO.TRXV_SERIE_TARJETA := C_LOTE.SERIE;
      V_CONTEGO.TRXV_BOUQUET       := C_LOTE.BOUQUETS;
      V_CONTEGO.TRXN_IDLOTE        := K_LOTE;
      V_CONTEGO.TRXN_PRIORIDAD     := SGAFUN_PARAM_CONTEGO('CONF_CONTEGO_ACT',
                                                           'CONF_ACT',
                                                           'RECONEXION-CONTEGO',
                                                           'AU');
      V_CONTEGO.TRXN_IDSOL         := C_LOTE.IDSOL;
      SGASI_REGCONTEGO(V_CONTEGO, k_RESPUESTA);
      IF k_RESPUESTA = 'ERROR' THEN
        k_MENSAJE := 'ERROR: AL GRABAR LAS TRANSACCIONES DE RECONEXION EN LA TABLA OPERACION.SGAT_TRXCONTEGO.';
        EXIT;
      END IF;
    END LOOP;
  EXCEPTION
    WHEN OTHERS THEN
      k_RESPUESTA := 'ERROR';
      k_MENSAJE   := 'ERROR: AL GRABAR LAS TRANSACIONES DE RECONEXION ' ||
                     SQLCODE || ' ' || SQLERRM || ' ' ||
                     DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      SGASP_LOGERR(C_SP_SUSP_LTE, null, V_CODSOLOT, k_RESPUESTA, k_MENSAJE);
  END;

  PROCEDURE SGASS_SUSPENSION_PREPAGO(K_LOTE      OPERACION.SGAT_TRXCONTEGO.TRXN_IDLOTE%TYPE,
                                     K_RESPUESTA IN OUT VARCHAR2,
                                     k_MENSAJE   IN OUT VARCHAR2) IS

    V_CONTEGO  OPERACION.SGAT_TRXCONTEGO%ROWTYPE;
    V_CODSOLOT OPERACION.SGAT_TRXCONTEGO.TRXN_CODSOLOT%TYPE;
    V_ACTION   OPERACION.SGAT_TRXCONTEGO.TRXN_ACTION_ID%TYPE;
    EX_ERROR EXCEPTION;

    CURSOR C_LOTE_TARJETAS IS
      select a.codsolot,
             a.idsol,
             d.tiptra,
             a.tiposolicitud,
             b.serie,
             to_char(listagg(to_number(c.bouquete),',') within
                     group(order by c.bouquete)) bouquets
        from operacion.ope_tvsat_sltd_cab          a,
             operacion.ope_tvsat_sltd_det          b,
             operacion.ope_tvsat_sltd_bouquete_det c,
             operacion.solot                       d
       where a.idsol = b.idsol
         and b.idsol = c.idsol
         and b.serie = c.serie
         and a.idlote = K_LOTE
         and d.codsolot(+) = a.codsolot
       group by a.codsolot, a.idsol, d.tiptra, a.tiposolicitud, b.serie
       order by a.codsolot;

  BEGIN
    k_RESPUESTA := 'OK';
    k_MENSAJE   := 'PROCESO TERMINADO SATISFACTORIAMENTE';

    FOR C_LOTE IN C_LOTE_TARJETAS LOOP
      V_CODSOLOT := C_LOTE.CODSOLOT;
      V_ACTION   := NVL(OPERACION.PKG_CONTEGO.SGAFUN_PARAM_CONTEGO('CONF_CONTEGO_TIPTRA_ACTIONID',
                                                                   C_LOTE.TIPOSOLICITUD,
                                                                   C_LOTE.TIPTRA,
                                                                   'A'),
                        C_ACTION_SUSPENSION);

      IF V_ACTION IS NULL THEN
        k_RESPUESTA := 'ERROR';
        k_MENSAJE   := 'ERROR: AL TRATAR DE INGRESAR EL ACTION. VERIFICAR EL TIPO DE TRABAJO/SOLICITUD. LOTE ' || K_LOTE;
        RAISE EX_ERROR;

      ELSE
        V_CONTEGO.TRXN_CODSOLOT      := V_CODSOLOT;
        V_CONTEGO.TRXN_ACTION_ID     := V_ACTION;
        V_CONTEGO.TRXV_SERIE_TARJETA := C_LOTE.SERIE;
        V_CONTEGO.TRXV_BOUQUET       := C_LOTE.BOUQUETS;
        V_CONTEGO.TRXN_IDLOTE        := K_LOTE;
        V_CONTEGO.TRXN_PRIORIDAD     := SGAFUN_PARAM_CONTEGO('CONF_CONTEGO_ACT',
                                                             'CONF_ACT',
                                                             'SUSPENSION-CONTEGO',
                                                             'AU');
        V_CONTEGO.TRXN_IDSOL         := C_LOTE.IDSOL;
        SGASI_REGCONTEGO(V_CONTEGO, k_RESPUESTA);
        IF k_RESPUESTA = 'ERROR' THEN
          k_MENSAJE := 'ERROR: AL GRABAR LAS TRANSACCIONES DE SUSPENSION/CANCELACION EN LA TABLA OPERACION.SGAT_TRXCONTEGO.';
          EXIT;
        END IF;
      END IF;
    END LOOP;
  EXCEPTION
    WHEN EX_ERROR THEN
      SGASP_LOGERR(C_SP_SUSP_PRE, NULL, V_CODSOLOT, k_RESPUESTA, k_MENSAJE);
    WHEN OTHERS THEN
      k_RESPUESTA := 'ERROR';
      k_MENSAJE   := 'ERROR: AL GRABAR LAS TRANSACIONES DE SUSPENSION/CANCELACION ' ||
                     SQLCODE || ' ' || SQLERRM || ' ' ||
                     DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      SGASP_LOGERR(C_SP_SUSP_LTE, null, V_CODSOLOT, k_RESPUESTA, k_MENSAJE);
  END;
  PROCEDURE SGASS_CANCELACION_PREPAGO(K_LOTE      OPERACION.SGAT_TRXCONTEGO.TRXN_IDLOTE%TYPE,
                                      K_RESPUESTA IN OUT VARCHAR2,
                                      k_MENSAJE   IN OUT VARCHAR2) IS

    V_CONTEGO  OPERACION.SGAT_TRXCONTEGO%ROWTYPE;
    V_CODSOLOT OPERACION.SGAT_TRXCONTEGO.TRXN_CODSOLOT%TYPE;

    CURSOR C_LOTE_TARJETAS IS
      select a.codsolot,
             a.idsol,
             d.tiptra,
             a.tiposolicitud,
             b.serie,
             a.flg_recarga,
             to_char(listagg(to_number(c.bouquete),',') within
                     group(order by c.bouquete)) bouquets
        from operacion.ope_tvsat_sltd_cab          a,
             operacion.ope_tvsat_sltd_det          b,
             operacion.ope_tvsat_sltd_bouquete_det c,
             operacion.solot                       d
       where a.idsol = b.idsol
         and b.idsol = c.idsol
         and b.serie = c.serie
         and a.idlote = K_LOTE
         and d.codsolot(+) = a.codsolot
       group by a.codsolot,
                a.idsol,
                d.tiptra,
                a.tiposolicitud,
                b.serie,
                a.flg_recarga
       order by a.codsolot;

  BEGIN
    k_RESPUESTA := 'OK';
    k_MENSAJE   := 'PROCESO TERMINADO SATISFACTORIAMENTE';

    FOR C_LOTE IN C_LOTE_TARJETAS LOOP
      V_CONTEGO.TRXN_CODSOLOT      := C_LOTE.CODSOLOT;
      V_CONTEGO.TRXN_ACTION_ID     := NVL(OPERACION.PKG_CONTEGO.SGAFUN_PARAM_CONTEGO('CONF_CONTEGO_TIPTRA_ACTIONID',
                                                                                     C_LOTE.TIPOSOLICITUD,
                                                                                     C_LOTE.TIPTRA,
                                                                                     'A'),
                                          C_ACTION_SUSPENSION);
      V_CONTEGO.TRXV_SERIE_TARJETA := C_LOTE.SERIE;
      V_CONTEGO.TRXV_BOUQUET       := C_LOTE.BOUQUETS;
      V_CONTEGO.TRXN_IDLOTE        := K_LOTE;
      V_CONTEGO.TRXN_PRIORIDAD     := SGAFUN_PARAM_CONTEGO('CONF_CONTEGO_ACT',
                                                           'CONF_ACT',
                                                           'BAJA-CONTEGO',
                                                           'AU');
      V_CONTEGO.TRXN_IDSOL         := C_LOTE.IDSOL;
      SGASI_REGCONTEGO(V_CONTEGO, k_RESPUESTA);
      IF k_RESPUESTA = 'ERROR' THEN
        k_MENSAJE := 'ERROR: AL GRABAR LAS TRANSACCIONES DE CANCELACION EN LA TABLA OPERACION.SGAT_TRXCONTEGO.';
        EXIT;
      END IF;
    END LOOP;
  EXCEPTION
    WHEN OTHERS THEN
      k_RESPUESTA := 'ERROR';
      k_MENSAJE   := 'ERROR: AL GRABAR LAS TRANSACIONES DE CANCELACION ' ||
                     SQLCODE || ' ' || SQLERRM || ' ' ||
                     DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      SGASP_LOGERR(C_SP_SUSP_LTE, null, V_CODSOLOT, k_RESPUESTA, k_MENSAJE);
  END;
  PROCEDURE SGASS_RECONEXION_PREPAGO(K_LOTE      OPERACION.SGAT_TRXCONTEGO.TRXN_IDLOTE%TYPE,
                                     K_RESPUESTA IN OUT VARCHAR2,
                                     k_MENSAJE   IN OUT VARCHAR2) IS
    V_CONTEGO  OPERACION.SGAT_TRXCONTEGO%ROWTYPE;
    V_CODSOLOT OPERACION.SGAT_TRXCONTEGO.TRXN_CODSOLOT%TYPE;

    CURSOR C_LOTE_TARJETAS IS
      select a.codsolot,
             a.idsol,
             d.tiptra,
             a.tiposolicitud,
             b.serie,
             to_char(listagg(to_number(c.bouquete),',') within
                     group(order by c.bouquete)) bouquets
        from operacion.ope_tvsat_sltd_cab          a,
             operacion.ope_tvsat_sltd_det          b,
             operacion.ope_tvsat_sltd_bouquete_det c,
             operacion.solot                       d
       where a.idsol = b.idsol
         and b.idsol = c.idsol
         and b.serie = c.serie
         and a.idlote = K_LOTE
         and d.codsolot(+) = a.codsolot
       group by a.codsolot, a.idsol, d.tiptra, a.tiposolicitud, b.serie
       order by a.codsolot;

  BEGIN
    k_RESPUESTA := 'OK';
    k_MENSAJE   := 'PROCESO TERMINADO SATISFACTORIAMENTE';

    FOR C_LOTE IN C_LOTE_TARJETAS LOOP
      V_CONTEGO.TRXN_CODSOLOT      := C_LOTE.CODSOLOT;
      V_CONTEGO.TRXN_ACTION_ID     := NVL(OPERACION.PKG_CONTEGO.SGAFUN_PARAM_CONTEGO('CONF_CONTEGO_TIPTRA_ACTIONID',
                                                                                     C_LOTE.TIPOSOLICITUD,
                                                                                     C_LOTE.TIPTRA,
                                                                                     'A'),
                                          C_ACTION_RECONEXION);
      V_CONTEGO.TRXV_SERIE_TARJETA := C_LOTE.SERIE;
      V_CONTEGO.TRXV_BOUQUET       := C_LOTE.BOUQUETS;
      V_CONTEGO.TRXN_IDLOTE        := K_LOTE;
      V_CONTEGO.TRXN_PRIORIDAD     := SGAFUN_PARAM_CONTEGO('CONF_CONTEGO_ACT',
                                                           'CONF_ACT',
                                                           'RECONEXION-CONTEGO',
                                                           'AU');
      V_CONTEGO.TRXN_IDSOL         := C_LOTE.IDSOL;
      SGASI_REGCONTEGO(V_CONTEGO, k_RESPUESTA);
      IF k_RESPUESTA = 'ERROR' THEN
        k_MENSAJE := 'ERROR: AL GRABAR LAS TRANSACCIONES DE RECONEXION EN LA TABLA OPERACION.SGAT_TRXCONTEGO.';
        EXIT;
      END IF;
    END LOOP;
  EXCEPTION
    WHEN OTHERS THEN
      k_RESPUESTA := 'ERROR';
      k_MENSAJE   := 'ERROR: AL GRABAR LAS TRANSACIONES DE RECONEXION ' ||
                     SQLCODE || ' ' || SQLERRM || ' ' ||
                     DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      SGASP_LOGERR('SGASS_RECONEXION_PREPAGO',
                   null,
                   V_CODSOLOT,
                   k_RESPUESTA,
                   k_MENSAJE);
  END;

  PROCEDURE SGASS_VERIFCONTEGO(K_RESPUESTA IN OUT VARCHAR2,
                               k_MENSAJE   IN OUT VARCHAR2) IS

    V_CODSOLOT VARCHAR2(30);
    V_EST      NUMBER;
    V_ERROR    NUMBER;
    EX_ERROR EXCEPTION;

    CURSOR C_VALIDA_SOLICITUD IS
      SELECT S.TRXN_CODSOLOT, S.TRXC_ESTADO, S.TRXN_IDSOL
        FROM OPERACION.SGAT_TRXCONTEGO S, OPERACION.OPE_TVSAT_SLTD_CAB CAB
       WHERE S.TRXN_IDSOL = CAB.IDSOL
         AND S.TRXN_IDLOTE IS NOT NULL
         AND S.TRXC_ESTADO <> C_PROV_REPORTADO
         AND CAB.ESTADO NOT IN (C_CAB_OK, C_CAB_CANCELADA)
      UNION ALL
      SELECT H.TRXN_CODSOLOT, H.TRXC_ESTADO, H.TRXN_IDSOL
        FROM OPERACION.SGAT_TRXCONTEGO_HIST H,
             OPERACION.OPE_TVSAT_SLTD_CAB   CAB
       WHERE H.TRXN_IDSOL = CAB.IDSOL
         AND H.TRXC_ESTADO = C_PROV_OK
         AND CAB.ESTADO NOT IN (C_CAB_OK, C_CAB_CANCELADA)
         AND H.TRXN_IDLOTE IS NOT NULL;

    CURSOR C_VALIDA_LOTE IS
      SELECT LOTE
        FROM (select TRXN_IDLOTE LOTE, COUNT(1) CONTADOR
                FROM (SELECT S.TRXN_IDLOTE, S.TRXC_ESTADO
                        FROM OPERACION.SGAT_TRXCONTEGO         S,
                             OPERACION.OPE_TVSAT_LOTE_SLTD_AUX AUX
                       WHERE S.TRXN_IDLOTE IS NOT NULL
                         AND S.TRXN_IDLOTE = AUX.IDLOTE
                         AND S.TRXC_ESTADO <> C_PROV_REPORTADO
                         AND AUX.ESTADO <> C_AUX_VERIFICADO
                       GROUP BY S.TRXN_IDLOTE, S.TRXC_ESTADO
                      UNION ALL
                      SELECT H.TRXN_IDLOTE, H.TRXC_ESTADO
                        FROM OPERACION.SGAT_TRXCONTEGO_HIST    H,
                             OPERACION.OPE_TVSAT_LOTE_SLTD_AUX AUX
                       WHERE H.TRXN_IDLOTE IS NOT NULL
                         AND H.TRXN_IDLOTE = AUX.IDLOTE
                         AND AUX.ESTADO <> C_AUX_VERIFICADO
                         AND H.TRXC_ESTADO IN (C_PROV_OK)
                       GROUP BY H.TRXN_IDLOTE, H.TRXC_ESTADO)
               GROUP BY TRXN_IDLOTE)
       WHERE CONTADOR = 1;
    CURSOR C_LOTE_REVISION IS
      SELECT LOTE
        FROM (select TRXN_IDLOTE LOTE, COUNT(1) CONTADOR
                FROM (SELECT S.TRXN_IDLOTE, S.TRXC_ESTADO
                        FROM OPERACION.SGAT_TRXCONTEGO         S,
                             OPERACION.OPE_TVSAT_LOTE_SLTD_AUX AUX
                       WHERE S.TRXN_IDLOTE IS NOT NULL
                         AND S.TRXN_IDLOTE = AUX.IDLOTE
                         AND S.TRXC_ESTADO <> C_PROV_REPORTADO
                         AND AUX.ESTADO <> C_AUX_VERIFICADO
                       GROUP BY S.TRXN_IDLOTE, S.TRXC_ESTADO
                      UNION ALL
                      SELECT H.TRXN_IDLOTE, H.TRXC_ESTADO
                        FROM OPERACION.SGAT_TRXCONTEGO_HIST    H,
                             OPERACION.OPE_TVSAT_LOTE_SLTD_AUX AUX
                       WHERE H.TRXN_IDLOTE IS NOT NULL
                         AND H.TRXN_IDLOTE = AUX.IDLOTE
                         AND AUX.ESTADO <> C_AUX_VERIFICADO
                         AND H.TRXC_ESTADO IN (C_PROV_OK)
                       GROUP BY H.TRXN_IDLOTE, H.TRXC_ESTADO)
               GROUP BY TRXN_IDLOTE)
       WHERE CONTADOR > 1;
  BEGIN
    k_RESPUESTA := 'OK';
    k_MENSAJE   := 'PROCESO TERMINADO SATISFACTORIAMENTE';
    --Actualiza estado del lote en la tabla OPERACION.OPE_TVSAT_SLTD_CAB
    FOR I IN C_VALIDA_SOLICITUD LOOP
      OPERACION.PQ_OPE_INTERFAZ_TVSAT.P_ACTUALIZA_DATOS_SOLICITUD(I.TRXN_IDSOL,
                                                                  I.TRXC_ESTADO,
                                                                  NULL,
                                                                  V_ERROR);
      IF V_ERROR IS NOT NULL THEN
        K_RESPUESTA := 'ERROR';
        K_MENSAJE   := V_ERROR;
        RAISE EX_ERROR;
      END IF;
    END LOOP;
    /*Actualiza estado del lote en la tabla OPERACION.OPE_TVSAT_LOTE_SLTD_AUX todos los estados
    unicos, es decir, cuando una sot tiene un solo estado*/
    FOR I IN C_VALIDA_LOTE LOOP
      SELECT DISTINCT ESTADO
        INTO V_EST
        FROM (SELECT S.TRXC_ESTADO ESTADO
                FROM OPERACION.SGAT_TRXCONTEGO S
               WHERE S.TRXN_IDLOTE = I.LOTE
                 AND S.TRXC_ESTADO <> C_PROV_REPORTADO
              UNION ALL
              SELECT H.TRXC_ESTADO
                FROM OPERACION.SGAT_TRXCONTEGO_HIST H
               WHERE H.TRXN_IDLOTE = I.LOTE
                 AND H.TRXC_ESTADO IN (C_PROV_OK));
      BEGIN
        UPDATE OPERACION.OPE_TVSAT_LOTE_SLTD_AUX AUX
           SET AUX.ESTADO = SGAFUN_UPD_STATUS(V_EST)
         WHERE AUX.IDLOTE = I.LOTE;
      EXCEPTION
        WHEN OTHERS THEN
          K_RESPUESTA := 'ERROR';
          K_MENSAJE   := SQLCODE || ' ' || SQLERRM || ' ' ||
                         DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
          RAISE EX_ERROR;
      END;
    END LOOP;
    /*Actualiza estado del lote en la tabla OPERACION.OPE_TVSAT_LOTE_SLTD_AUX todos los estados
    diferentes, es decir, cuando una sot tiene mas de un estado. Cuando ocurre esto pasa a estado
    en revision = 7 */
    FOR I IN C_LOTE_REVISION LOOP
      BEGIN
        UPDATE OPERACION.OPE_TVSAT_LOTE_SLTD_AUX AUX
           SET AUX.ESTADO = C_AUX_LOTEREV
         WHERE AUX.IDLOTE = I.LOTE;
      EXCEPTION
        WHEN OTHERS THEN
          K_RESPUESTA := 'ERROR';
          K_MENSAJE   := SQLCODE || ' ' || SQLERRM || ' ' ||
                         DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
          RAISE EX_ERROR;
      END;
    END LOOP;
  EXCEPTION
    WHEN EX_ERROR THEN
      SGASP_LOGERR(C_SP_VERIFCONTEGO,NULL,V_CODSOLOT,k_RESPUESTA,k_MENSAJE);




      ROLLBACK;
  END;
  /****************************************************************
  * Nombre FUN     : SGAFUN_OBT_BOUQUET
  * Proposito      : Esta funcion se encarga de generar y devolver
                     los bouquets PRINCIPAL, ADICIONAL y PROMOCION
                     concatenados y separados por coma.
  * Output         : Bouquets concatenados por coma.
  * Creado por     : Jose Arriola
  * Fec. Creacion  : 01/08/2017
  * Fec. Actualizacion : --
  ****************************************************************/
  FUNCTION SGAFUN_OBT_BOUQUET(k_NUMREGISTRO in OPERACION.OPE_SRV_RECARGA_CAB.NUMREGISTRO%TYPE,
                              K_NUMSLC      in VARCHAR2,
                              K_TIPO        IN VARCHAR2) RETURN VARCHAR2 IS

    LN_COUNTER    NUMBER;
    LN_BOUQUET    VARCHAR2(500) := NULL;
    LN_BOUQUET2   VARCHAR2(500) := NULL;
    V_LARGO       NUMBER;
    V_NUMBOUQUETS NUMBER;
    V_CANAL       VARCHAR2(8);
    FLG_CNR       NUMBER;

    CURSOR C_CODIGOS_EXT_VENTAS IS
      SELECT TRIM(PQ_OPE_BOUQUET.F_CONCA_BOUQUET_C(R.IDGRUPO)) CODIGO_EXT,
             R.IDGRUPO,
             PQ_VTA_PAQUETE_RECARGA.F_GET_PID(k_NUMREGISTRO, V.IDDET) PID,
             T.CODSRV,
             DECODE(V.FLGSRV_PRI, 1, 'PRINCIPAL', 'ADICIONAL') CLASE,
             V.IDDET
        FROM VTADETPTOENL V, TYSTABSRV T, TYS_TABSRVXBOUQUET_REL R
       WHERE V.NUMSLC = K_NUMSLC
         AND V.CODSRV = T.CODSRV
         AND T.CODSRV = R.CODSRV
         AND R.ESTBOU = 1
         AND R.STSRVB = 1
      UNION ALL
      SELECT DISTINCT B.DESCRIPCION,
                      GB.IDGRUPO,
                      NULL PID,
                      PV.CODSRV,
                      'PROMOCION' CLASE,
                      NULL IDDET
        FROM FAC_PROM_DETALLE_VENTA_MAE PV,
             OPE_GRUPO_BOUQUET_DET      GB,
             OPE_BOUQUET_MAE            B
       WHERE PV.NUMSLC = K_NUMSLC
         AND PV.IDGRUPO = GB.IDGRUPO
         AND GB.CODBOUQUET = B.CODBOUQUET
         AND GB.FLG_ACTIVO = 1
         AND B.FLG_ACTIVO = 1
         AND B.DESCRIPCION IS NOT NULL;

    cursor C_BOUQUET_ADIC_BAJA is
      select CODSRV, bouquets
        from bouquetxreginsdth
       where tipo = 0
         and estado = 1
         and numregistro = k_NUMREGISTRO
       group by numregistro, CODSRV, bouquets;

  BEGIN
    LN_COUNTER := 0;

    DELETE OPERACION.BOUQUETXREGINSDTH WHERE NUMREGISTRO = K_NUMREGISTRO;

    IF K_TIPO = C_TIP_BOUQUET_ALTA THEN
      FOR C_COD_EXT_V IN C_CODIGOS_EXT_VENTAS LOOP
        IF LN_COUNTER = 0 THEN
          LN_BOUQUET := TRIM(C_COD_EXT_V.CODIGO_EXT);
        ELSE
          LN_BOUQUET := LN_BOUQUET || ',' || TRIM(C_COD_EXT_V.CODIGO_EXT);
        END IF;
        LN_COUNTER    := LN_COUNTER + 1;
        V_LARGO       := LENGTH(LN_BOUQUET);
        V_NUMBOUQUETS := (V_LARGO + 1) / 4;
        FOR I IN 1 .. V_NUMBOUQUETS LOOP
          V_CANAL := LPAD(OPERACION.F_CB_SUBCADENA2(trim(LN_BOUQUET), I),8,'0');


        END LOOP;

        IF C_COD_EXT_V.CLASE = 'PRINCIPAL' THEN
          FLG_CNR := 1;
        ELSIF C_COD_EXT_V.CLASE = 'ADICIONAL' THEN
          FLG_CNR := PQ_VTA_PAQUETE_RECARGA.F_IS_CNR(K_NUMSLC,
                                                     C_COD_EXT_V.IDDET);
          IF PQ_VTA_PAQUETE_RECARGA.F_IS_CNR(K_NUMSLC, C_COD_EXT_V.IDDET) = 1 THEN
            FLG_CNR := 3;
          ELSE
            FLG_CNR := 0;
          END IF;
        END IF;
        INSERT INTO OPERACION.BOUQUETXREGINSDTH
          (NUMREGISTRO, CODSRV, BOUQUETS, TIPO, ESTADO, IDGRUPO, PID)
        VALUES
          (k_NUMREGISTRO,
           C_COD_EXT_V.CODSRV,
           C_COD_EXT_V.CODIGO_EXT,
           FLG_CNR,
           1,
           C_COD_EXT_V.IDGRUPO,
           C_COD_EXT_V.PID);
      END LOOP;
    ELSIF K_TIPO = C_TIP_BOUQUET_BAJA THEN

      FOR A IN C_BOUQUET_ADIC_BAJA LOOP
        IF C_BOUQUET_ADIC_BAJA%ROWCOUNT = 1 THEN
          LN_BOUQUET := A.BOUQUETS;
        ELSIF C_BOUQUET_ADIC_BAJA%ROWCOUNT > 1 THEN
          LN_BOUQUET := LN_BOUQUET || ',' || A.BOUQUETS;
        END IF;

        BEGIN
          UPDATE BOUQUETXREGINSDTH
             SET ESTADO = C_DESACTIVO, FECULTENV = SYSDATE
           WHERE NUMREGISTRO = k_NUMREGISTRO
             AND CODSRV = A.CODSRV
             AND TIPO = C_DESACTIVO;
          COMMIT;
        EXCEPTION
          WHEN OTHERS THEN
            ROLLBACK;
        END;
      END LOOP;

      SELECT to_char(listagg(CODBOUQUET,',') within group(order by CODBOUQUET)) BOUQUETS

        INTO LN_BOUQUET2
        FROM OPE_BOUQUET_MAE
       WHERE FLG_ACTIVO = 1
       ORDER BY CODBOUQUET ASC;

      IF LN_BOUQUET IS NULL THEN
        LN_BOUQUET := LN_BOUQUET2;
      ELSE
        LN_BOUQUET := LN_BOUQUET || ',' || LN_BOUQUET2;
      END IF;

    END IF;
    RETURN LN_BOUQUET;
  EXCEPTION
    WHEN OTHERS THEN
      SGASP_LOGERR('SGAFUN_OBT_BOUQUET',
                   K_NUMREGISTRO,
                   NULL,
                   'ERROR',
                   SQLERRM || ' ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
      ROLLBACK;
      RETURN NULL;
  END;
  /****************************************************************
  * Nombre FUN     : SGAFUN_VALIDA_PAREO
  * Proposito      : Esta funcion se encarga de validar si se va
                     ejecutar el proceso de pareo.
  * Output         : LN_PAREO - Si es pareo retorna su numserie
  * Creado por     : Jose Arriola
  * Fec. Creacion  : 01/08/2017
  * Fec. Actualizacion : --
  ****************************************************************/
  FUNCTION SGAFUN_VALIDA_PAREO(k_CODSOLOT OPERACION.SOLOT.CODSOLOT%TYPE)
    RETURN NUMBER IS
    LN_PAREO NUMBER;
  BEGIN
    SELECT COUNT(DISTINCT SE.NUMSERIE)
      INTO LN_PAREO
      FROM SOLOTPTOEQU SE, OPERACION.TARJETA_DECO_ASOC T
     WHERE T.CODSOLOT = k_CODSOLOT
       AND T.CODSOLOT = SE.CODSOLOT
       AND SE.MAC = T.NRO_SERIE_DECO
       AND (SELECT COUNT(*)
              FROM OPEDD A, TIPOPEDD B
             WHERE A.TIPOPEDD = B.TIPOPEDD
               AND B.ABREV = 'PREFIJO_DECO'
               AND INSTR(UPPER(SE.NUMSERIE), UPPER(TRIM(A.CODIGOC))) = 1) > 0;
    RETURN LN_PAREO;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN 0;
    WHEN OTHERS THEN
      RETURN 0;
  END;
  /****************************************************************
  * Nombre FUN     : SGAFUN_VALIDA_DESPAREO
  * Proposito      : Esta funcion se encarga de validar si se va
                     ejecutar el proceso de despareo.
  * Output         : LN_DESPAREO - Si es despareo retorna su numserie
  * Creado por     : Jose Arriola
  * Fec. Creacion  : 01/08/2017
  * Fec. Actualizacion : --
  ****************************************************************/
  FUNCTION SGAFUN_VALIDA_DESPAREO(k_CODSOLOT OPERACION.SOLOT.CODSOLOT%TYPE)
    RETURN NUMBER IS
    LN_DESPAREO NUMBER;
  BEGIN
    SELECT COUNT(DISTINCT SE.NUMSERIE)
      INTO LN_DESPAREO
      FROM SOLOTPTOEQU SE, OPERACION.TARJETA_DECO_ASOC T
     WHERE T.CODSOLOT = k_CODSOLOT
       AND T.CODSOLOT = SE.CODSOLOT
       AND SE.MAC = T.NRO_SERIE_DECO
       AND (SELECT COUNT(*)
              FROM OPEDD A, TIPOPEDD B
             WHERE A.TIPOPEDD = B.TIPOPEDD
               AND B.ABREV = 'PREFIJO_DECO'
               AND INSTR(UPPER(SE.NUMSERIE), UPPER(TRIM(A.CODIGOC))) = 1) = 0;
    RETURN LN_DESPAREO;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN 0;
    WHEN OTHERS THEN
      RETURN 0;
  END;
  /****************************************************************
  * Nombre FUN     : SGAFUN_PARAM_CONTEGO
  * Proposito      : Esta funcion se encarga de buscar y obtener los
                     valores en la tabla de par?metros OPERACION.OPEDD
                     y OPERACION.TIPOPEDD
  * Output         : LS_PARAMC - retorna el valor del parametro
  * Creado por     : Jose Arriola
  * Fec. Creacion  : 01/08/2017
  * Fec. Actualizacion : --
  ****************************************************************/
  FUNCTION SGAFUN_PARAM_CONTEGO(P_TIPO   IN VARCHAR2,
                                P_CAMPO  IN VARCHAR2,
                                P_DESC   IN VARCHAR2,
                                P_TIPVAR IN VARCHAR2) RETURN VARCHAR2 IS
    LS_PARAMC VARCHAR2(200);
    LS_PARAMN NUMBER;
  BEGIN
    IF P_TIPVAR = 'C' THEN

      SELECT CODIGOC
        INTO LS_PARAMC
        FROM OPERACION.OPEDD
       WHERE TIPOPEDD = (SELECT TIPOPEDD
                           FROM OPERACION.TIPOPEDD
                          WHERE TRIM(ABREV) = TRIM(P_TIPO))
         AND DESCRIPCION = TRIM(P_DESC)
         AND ABREVIACION = TRIM(P_CAMPO);

      RETURN LS_PARAMC;

    ELSIF P_TIPVAR = 'N' THEN

      SELECT CODIGON
        INTO LS_PARAMN
        FROM OPERACION.OPEDD
       WHERE TIPOPEDD = (SELECT TIPOPEDD
                           FROM OPERACION.TIPOPEDD
                          WHERE TRIM(ABREV) = TRIM(P_TIPO))
         AND DESCRIPCION = TRIM(P_DESC)
         AND ABREVIACION = TRIM(P_CAMPO);

      LS_PARAMC := TO_CHAR(LS_PARAMN);
      RETURN LS_PARAMC;
    ELSIF P_TIPVAR = 'AU' THEN

      SELECT CODIGON_AUX
        INTO LS_PARAMN
        FROM OPERACION.OPEDD
       WHERE TIPOPEDD = (SELECT TIPOPEDD
                           FROM OPERACION.TIPOPEDD
                          WHERE TRIM(ABREV) = TRIM(P_TIPO))
         AND DESCRIPCION = TRIM(P_DESC)
         AND ABREVIACION = TRIM(P_CAMPO);

      LS_PARAMC := TO_CHAR(LS_PARAMN);
      RETURN LS_PARAMC;

    ELSIF P_TIPVAR = 'A' THEN
      BEGIN
        SELECT CODIGON_AUX
          INTO LS_PARAMN
          FROM OPERACION.OPEDD
         WHERE TIPOPEDD = (SELECT TIPOPEDD
                             FROM OPERACION.TIPOPEDD
                            WHERE TRIM(ABREV) = TRIM(P_TIPO))
           AND CODIGON = TRIM(P_DESC);
      EXCEPTION
        WHEN OTHERS THEN
          SELECT CODIGON_AUX
            INTO LS_PARAMN
            FROM OPERACION.OPEDD
           WHERE TIPOPEDD = (SELECT TIPOPEDD
                               FROM OPERACION.TIPOPEDD
                              WHERE TRIM(ABREV) = TRIM(P_TIPO))
             AND CODIGON = TRIM(P_DESC)
             AND ROWNUM = 1;
      END;
      RETURN LS_PARAMN;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN NULL;
  END;
  /****************************************************************
  * Nombre FUN     : SGAFUN_OBT_NUMSLC
  * Proposito      : Esta funcion se encarga de obtener el numero de
                     proyecto generado a traves del numero de registro
                     desde la tabla OPERACION.OPE_SRV_RECARGA_CAB
  * Output         : V_NUMSLC - Numero de proyecto generado
  * Creado por     : Jose Arriola
  * Fec. Creacion  : 01/08/2017
  * Fec. Actualizacion : --
  ****************************************************************/
  FUNCTION SGAFUN_OBT_NUMSLC(k_NUMREGISTRO OPERACION.OPE_SRV_RECARGA_CAB.NUMREGISTRO%TYPE)
    RETURN VARCHAR2 IS
    V_NUMSLC OPERACION.SOLOT.NUMSLC%TYPE;
  BEGIN
    SELECT NUMSLC
      INTO V_NUMSLC
      FROM OPERACION.OPE_SRV_RECARGA_CAB
     WHERE NUMREGISTRO = k_NUMREGISTRO;
    RETURN V_NUMSLC;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN NULL;
  END;
  /****************************************************************
  * Nombre FUN     : SGAFUN_VALIDA_SOT
  * Proposito      : Esta funcion la utiliza el procedimiento principal
                     de alta que verifica que la linea no se encuentre
                     registrada en la transaccional con estado 1 o en el
                     historico con estado 3, se encarga de cancelar la SOT
                     y a traves del procedimiento SGASI_REGCONTEGOHIST
                     registrarla en el historico y eliminarla de la transaccional
  * Output         : k_RESPUESTA - Retorna 0 si es correcto o -1/-2 si es
                     incorrecto
  * Creado por     : Jose Arriola
  * Fec. Creacion  : 01/08/2017
  * Fec. Actualizacion : --
  ****************************************************************/
  FUNCTION SGAFUN_VALIDA_SOT(k_CODSOLOT OPERACION.SGAT_TRXCONTEGO.TRXN_CODSOLOT%TYPE)
    RETURN NUMBER IS
    k_RESPUESTA NUMBER;
  BEGIN
    UPDATE OPERACION.SGAT_TRXCONTEGO TRX
       SET TRX.TRXC_ESTADO  = C_PROV_CANCELADO,
           TRX.TRXV_MSJ_ERR = C_MSG_CANCELADO
     WHERE TRX.TRXN_CODSOLOT = k_CODSOLOT;
    SGASI_REGCONTEGOHIST(k_CODSOLOT, k_RESPUESTA);
    RETURN k_RESPUESTA;
  EXCEPTION
    WHEN OTHERS THEN
      SGASP_LOGERR('SGAFUN_VALIDA_SOT',
                   NULL,
                   k_CODSOLOT,
                   SQLCODE,
                   SQLERRM || ' ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
      RETURN - 1;
  END;
  /****************************************************************
  * Nombre FUN     : SGAFUN_OBT_MSJ
  * Proposito      : Funcion la cual se encarga de obtener la descripcion
                     de los estados.
  * Output         : Descripcion del estado ingresado.
  * Creado por     : Jose Arriola
  * Fec. Creacion  : 01/08/2017
  * Fec. Actualizacion : --
  ****************************************************************/
  FUNCTION SGAFUN_OBT_MSJ(K_ESTADO OPERACION.SGAT_TRXCONTEGO.TRXC_ESTADO%TYPE)
    RETURN VARCHAR2 IS
  BEGIN
    CASE
      WHEN K_ESTADO = C_GENERADO THEN RETURN 'GENERADO';
      WHEN K_ESTADO = C_ENVIADO THEN RETURN 'ENVIADO';
      WHEN K_ESTADO = C_PROV_OK THEN RETURN 'PROCESADO';
      WHEN K_ESTADO = C_PROV_ERROR THEN RETURN 'ERROR';
      WHEN K_ESTADO = C_PROV_REPORTADO THEN RETURN 'ERROR PENDIENTE REVISION';
      WHEN K_ESTADO = C_PROV_CANCELADO THEN RETURN 'CANCELADO';







    END CASE;
  EXCEPTION
    WHEN CASE_NOT_FOUND THEN
      RETURN NULL;
  END;

  FUNCTION SGAFUN_UPD_STATUS(K_ESTADO OPERACION.SGAT_TRXCONTEGO.TRXC_ESTADO%TYPE)
    RETURN NUMBER IS
  BEGIN
    -- EQUIVALENCIA ENTRE TABLA TRANSACCIONAL CON OPE_TVSAT_LOTE_SLTD_AUX
    CASE
      WHEN K_ESTADO = C_GENERADO THEN RETURN 3;
      WHEN K_ESTADO = C_ENVIADO THEN RETURN 4;
      WHEN K_ESTADO = C_PROV_OK THEN RETURN 6;
      WHEN K_ESTADO = C_PROV_ERROR THEN RETURN 8;




    END CASE;
  EXCEPTION
    WHEN CASE_NOT_FOUND THEN
      RETURN 0;
  END;
  FUNCTION SGAFUN_VALIDA_LOTE(K_LOTE OPERACION.SGAT_TRXCONTEGO.TRXN_IDLOTE%TYPE)
    RETURN NUMBER IS
    k_RESPUESTA NUMBER;
  BEGIN
    UPDATE OPERACION.SGAT_TRXCONTEGO TRX
       SET TRX.TRXC_ESTADO  = C_PROV_CANCELADO,
           TRX.TRXV_MSJ_ERR = C_MSG_CANCELADO
     WHERE TRX.TRXN_IDLOTE = K_LOTE;
    SGASI_REGLOTEHIST(K_LOTE, k_RESPUESTA);
    RETURN k_RESPUESTA;
  EXCEPTION
    WHEN OTHERS THEN
      SGASP_LOGERR('SGAFUN_VALIDA_LOTE',
                   NULL,
                   NULL,
                   SQLCODE,
                   SQLERRM || ' ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
      RETURN - 1;
  END;

  /****************************************************************
  * Nombre FUN     : SGAFUN_ES_PAREO
  * Proposito      : Funcion la cual se encarga de valida si corresponde PAREO o DESPAREO
  * Output         : PAREO / DESPAREO
  * Creado por     : Lidia Quispe
  * Fec. Creacion  : 14/08/2018
  * Fec. Actualizacion : --
  ****************************************************************/
  FUNCTION SGAFUN_ES_PAREO(V_NUMSERIE OPERACION.SOLOTPTOEQU.NUMSERIE%TYPE)
    RETURN VARCHAR2 IS
    V_VALOR_PAREO NUMBER;
  BEGIN
    SELECT COUNT(*)
      INTO V_VALOR_PAREO
      FROM OPEDD A, TIPOPEDD B
     WHERE A.TIPOPEDD = B.TIPOPEDD
       AND B.ABREV = 'PREFIJO_DECO'
       AND INSTR(UPPER(V_NUMSERIE), UPPER(TRIM(A.CODIGOC))) = 1;

    IF NVL(V_VALOR_PAREO, 0) = 0 THEN
      RETURN 'DESPAREO';
    ELSE
      RETURN 'PAREO';
    END IF;
  END;

  /****************************************************************
  * Nombre FUN     : SGASS_DECOS_CONTEGO_CP
  * Proposito      : Proceso que realiza la Baja, Alta o Refresco de Canales para el CP LTE
  * Output         :
  * Creado por     : Lidia Quispe
  * Fec. Creacion  : 14/08/2018
  * Fec. Actualizacion : --
  ****************************************************************/
  PROCEDURE SGASS_DECOS_CONTEGO_CP(V_NUMREGISTRO IN OPERACION.OPE_SRV_RECARGA_CAB.NUMREGISTRO%TYPE,
                                   V_CODSOLOT    IN OPERACION.SOLOT.CODSOLOT%TYPE,
                                   V_RES_ERROR   OUT VARCHAR2,
                                   V_MSJ_ERROR   OUT VARCHAR2) IS

    CURSOR C_DECOS(V_ESTADO NUMBER) IS
      SELECT SE.NUMSERIE,
             SE.MAC,
             SE.CODEQUCOM,
             T.NRO_SERIE_DECO,
             T.NRO_SERIE_TARJETA
        FROM SOLOTPTOEQU SE,
             TIPEQU TE,
             OPERACION.TARJETA_DECO_ASOC T,
             (SELECT A.CODIGON TIPEQU, CODIGOC GRUPO
                FROM OPEDD A, TIPOPEDD B
               WHERE A.TIPOPEDD = B.TIPOPEDD
                 AND B.ABREV IN ('TIPEQU_DTH_CONAX')) EQU_CONAX
       WHERE SE.CODSOLOT = V_CODSOLOT
         AND TE.TIPEQU = SE.TIPEQU
         AND TRIM(EQU_CONAX.GRUPO) = '2'
         AND TE.TIPEQU = EQU_CONAX.TIPEQU
         AND T.CODSOLOT = SE.CODSOLOT
         AND SE.MAC = T.NRO_SERIE_DECO
         AND SE.ESTADO = V_ESTADO;

    CURSOR DECO_BAJA(V_ESTADO NUMBER) IS
      SELECT DISTINCT NUMSERIE
        FROM OPERACION.SOLOTPTOEQU
       WHERE CODSOLOT = V_CODSOLOT
         AND TIPEQU IN (SELECT A.CODIGON TIPEQUOPE
                          FROM OPERACION.OPEDD A, OPERACION.TIPOPEDD B
                         WHERE A.TIPOPEDD = B.TIPOPEDD
                           AND B.ABREV = 'TIPEQU_DTH_CONAX'
                           AND CODIGOC = '1')
         AND ESTADO = V_ESTADO;

    CURSOR C_SOT_REEMPLAZO IS
      SELECT DISTINCT S.TRXN_CODSOLOT, S.TRXC_ESTADO
        FROM OPERACION.SGAT_TRXCONTEGO S
       WHERE S.TRXN_CODSOLOT = V_CODSOLOT
         AND S.TRXN_ACTION_ID IN (C_ACTION_ALTA, C_ACTION_ACTIVACION)
      UNION ALL
      SELECT DISTINCT H.TRXN_CODSOLOT, H.TRXC_ESTADO
        FROM OPERACION.SGAT_TRXCONTEGO_HIST H
       WHERE H.TRXC_ESTADO = C_PROV_OK
         AND H.TRXN_CODSOLOT = V_CODSOLOT
         AND H.TRXN_ACTION_ID IN (C_ACTION_ALTA, C_ACTION_ACTIVACION)
       ORDER BY 2 DESC;

    N_ERROR NUMBER;
    V_ERROR VARCHAR2(4000);
    EX_ERROR EXCEPTION;
    V_REG_DECO      NUMBER;
    V_CONTEGO       OPERACION.SGAT_TRXCONTEGO%ROWTYPE;
    V_NUMSLC        OPERACION.SOLOT.NUMSLC%TYPE;
    V_BOUQUET       VARCHAR2(10000);
    LN_COD_ID       NUMBER;
    LN_CODSOLOT_MAX NUMBER;
    LN_COD_OLD      NUMBER; --4.0
    ln_valctv_old   number; --5.0
    ln_valctv_new   number; --5.0
  BEGIN
    V_RES_ERROR := 'OK';
    V_MSJ_ERROR := 'PROCESO CORRECTO';

    /*Verificamos que la linea no se encuentre registrada en la transaccional con estado 1 o en
    el historico con estado 3*/
    FOR C_SOT IN C_SOT_REEMPLAZO LOOP
      IF (C_SOT.TRXC_ESTADO = C_GENERADO) THEN
        V_RES_ERROR := 'PENDIENTE';
        V_MSJ_ERROR := 'PENDIENTE: EN ESPERA DE ENVIO A CONTEGO.';
        RAISE EX_ERROR;
      ELSIF (C_SOT.TRXC_ESTADO = C_PROV_OK) THEN
        V_RES_ERROR := 'OK';
        V_MSJ_ERROR := 'PROVISIONADO: SE EJECUTO CORRECTAMENTE.';
        RAISE EX_ERROR;
      ELSIF (C_SOT.TRXC_ESTADO = C_ENVIADO) THEN
        V_RES_ERROR := 'PENDIENTE';
        V_MSJ_ERROR := 'PENDIENTE: EN ESPERA DE RESPUESTA DE CONTEGO.';
        RAISE EX_ERROR;
      ELSE
        DELETE OPERACION.SGAT_TRXCONTEGO S
         WHERE S.TRXN_CODSOLOT = V_CODSOLOT;
        EXIT;
      END IF;
    END LOOP;

    --Ini 3.0
    SELECT S.COD_ID, S.NUMSLC, S.COD_ID_OLD --4.0
      INTO LN_COD_ID, V_NUMSLC, LN_COD_OLD --4.0
      FROM SOLOT S
     WHERE S.CODSOLOT = V_CODSOLOT;

    LN_CODSOLOT_MAX := OPERACION.PQ_SGA_IW.F_MAX_SOT_X_COD_ID(LN_COD_OLD); --5.0

    ln_valctv_old := OPERACION.PQ_VISITA_SGA_SIAC.SGAFUN_val_tipsrv_old(LN_CODSOLOT_MAX,
                                                                        '0062'); --5.0
    ln_valctv_new := OPERACION.PQ_VISITA_SGA_SIAC.SGAFUN_val_tipsrv_old(V_CODSOLOT,
                                                                        '0062'); --5.0

    --ini 5.0
    if ln_valctv_new > 0 then
      SELECT COUNT(*)
        INTO V_REG_DECO
        FROM OPERACION.TARJETA_DECO_ASOC T
       WHERE CODSOLOT = V_CODSOLOT;

      IF V_REG_DECO = 0 THEN
        V_RES_ERROR := 'ERROR';
        V_MSJ_ERROR := 'ERROR: LA SOT ' || V_CODSOLOT ||
                       ' NO TIENE RGISTROS EN TBL OPERACION.TARJETA_DECO_ASOC';
        RAISE EX_ERROR;
      END IF;

      V_BOUQUET := PKG_CONTEGO.SGAFUN_OBT_BOUQUET(V_NUMREGISTRO,
                                                  V_NUMSLC,
                                                  C_TIP_BOUQUET_ALTA); --2.0
      IF V_BOUQUET IS NULL THEN
        V_RES_ERROR := 'ERROR';
        V_MSJ_ERROR := 'ERROR: NO SE ENCUENTRA LOS BOUQUETS PARA REALIZAR LA ACTIVACION';
        RAISE EX_ERROR;
      END IF;

    end if;
    --fin 5.0

    IF LN_CODSOLOT_MAX != 0 THEN
      SELECT SS.NUMSLC
        INTO V_NUMSLC
        FROM SOLOT SS
       WHERE SS.CODSOLOT = LN_CODSOLOT_MAX;
    END IF;
    --Fin 3.0

    IF V_NUMSLC IS NULL THEN
      V_RES_ERROR := 'ERROR';
      V_MSJ_ERROR := 'ERROR: NO SE ENCUENTRA EL NUMERO DE PROYECTO EN LA TABLA OPERACION.OPE_SRV_RECARGA_CAB';
      RAISE EX_ERROR;
    END IF;
    --  4 : INSTALAR
    -- 12 : RETIRAR
    -- 15 : REFRESCAR
    FOR C_LINE IN C_DECOS(4) LOOP
      V_CONTEGO.TRXV_TIPO := PKG_CONTEGO.SGAFUN_ES_PAREO(C_LINE.NUMSERIE);
      IF V_CONTEGO.TRXV_TIPO = 'PAREO' THEN
        V_CONTEGO.TRXN_ACTION_ID := PKG_CONTEGO.SGAFUN_PARAM_CONTEGO('CONF_CONTEGO_ACT',
                                                                     'CONF_ACT',
                                                                     'PAREO-CONTEGO',
                                                                     'N');
        V_CONTEGO.TRXN_PRIORIDAD := PKG_CONTEGO.SGAFUN_PARAM_CONTEGO('CONF_CONTEGO_ACT',
                                                                     'CONF_ACT',
                                                                     'PAREO-CONTEGO',
                                                                     'AU');
      ELSIF V_CONTEGO.TRXV_TIPO = 'DESPAREO' THEN
        V_CONTEGO.TRXN_ACTION_ID := PKG_CONTEGO.SGAFUN_PARAM_CONTEGO('CONF_CONTEGO_ACT',
                                                                     'CONF_ACT',
                                                                     'DESPAREO-CONTEGO',
                                                                     'N');
        V_CONTEGO.TRXN_PRIORIDAD := PKG_CONTEGO.SGAFUN_PARAM_CONTEGO('CONF_CONTEGO_ACT',
                                                                     'CONF_ACT',
                                                                     'DESPAREO-CONTEGO',
                                                                     'AU');
      END IF;

      V_CONTEGO.TRXN_CODSOLOT      := V_CODSOLOT;
      V_CONTEGO.TRXV_BOUQUET       := V_BOUQUET;
      V_CONTEGO.TRXV_SERIE_TARJETA := C_LINE.NRO_SERIE_TARJETA;
      V_CONTEGO.TRXV_SERIE_DECO    := C_LINE.NRO_SERIE_DECO;
      -- Registro la Asociaciÿ³n 101
      PKG_CONTEGO.SGASI_REGCONTEGO(V_CONTEGO, V_RES_ERROR);

      IF V_RES_ERROR = 'ERROR' THEN
        V_MSJ_ERROR := 'ERROR: AL GRABAR LAS TRANSACCIONES DE PAREO EN LA TABLA OPERACION.SGAT_TRXCONTEGO.';
        EXIT;
      END IF;

      -- Registro la Activaciÿ³n 103
      V_CONTEGO.TRXV_TIPO       := NULL;
      V_CONTEGO.TRXV_SERIE_DECO := NULL; --4.0
      V_CONTEGO.TRXN_ACTION_ID  := PKG_CONTEGO.SGAFUN_PARAM_CONTEGO('CONF_CONTEGO_ACT',
                                                                    'CONF_ACT',
                                                                    'ALTA-CONTEGO',
                                                                    'N');
      V_CONTEGO.TRXN_PRIORIDAD  := PKG_CONTEGO.SGAFUN_PARAM_CONTEGO('CONF_CONTEGO_ACT',
                                                                    'CONF_ACT',
                                                                    'ALTA-CONTEGO',
                                                                    'AU');
      PKG_CONTEGO.SGASI_REGCONTEGO(V_CONTEGO, V_RES_ERROR);
      IF V_RES_ERROR = 'ERROR' THEN
        V_MSJ_ERROR := 'ERROR: AL GRABAR LAS TRANSACCIONES DE ACTIVACION EN LA TABLA OPERACION.SGAT_TRXCONTEGO.';
        EXIT;
      END IF;
    END LOOP;

    -- EQUIPOS A RETIRAR
    --4.0 Ini
    IF LN_COD_OLD IS NULL OR LN_COD_OLD = 0 THEN
      V_RES_ERROR := 'ERROR';
      V_MSJ_ERROR := 'ERROR AL OBTENER CONTRATO';
      PKG_CONTEGO.SGASP_LOGERR('SGASS_DECOS_CONTEGO_CP',
                               NULL,
                               V_CODSOLOT,
                               V_RES_ERROR,
                               V_MSJ_ERROR);
      RAISE EX_ERROR;
    END IF;

    IF ln_valctv_old > 0 THEN
      --5.0 En el caso tenga Equipos Anteriores
      V_BOUQUET := OPERACION.PQ_DECO_ADICIONAL_LTE.SGAFUN_OBT_BOUQUET_ACT(LN_COD_OLD);
      --4.0 Fin

      FOR C_RET IN DECO_BAJA(12) LOOP
        V_CONTEGO.TRXN_CODSOLOT      := V_CODSOLOT;
        V_CONTEGO.TRXN_ACTION_ID     := PKG_CONTEGO.SGAFUN_PARAM_CONTEGO('CONF_CONTEGO_ACT',
                                                                         'CONF_ACT',
                                                                         'BAJA-CONTEGO',
                                                                         'N');
        V_CONTEGO.TRXV_SERIE_TARJETA := C_RET.NUMSERIE;
        V_CONTEGO.TRXV_SERIE_DECO    := NULL;
        V_CONTEGO.TRXV_BOUQUET       := V_BOUQUET;
        V_CONTEGO.TRXN_PRIORIDAD     := PKG_CONTEGO.SGAFUN_PARAM_CONTEGO('CONF_CONTEGO_ACT',
                                                                         'CONF_ACT',
                                                                         'BAJA-CONTEGO',
                                                                         'AU');
        PKG_CONTEGO.SGASI_REGCONTEGO(V_CONTEGO, V_RES_ERROR);
        IF V_RES_ERROR = 'ERROR' THEN
          V_MSJ_ERROR := 'ERROR: AL GRABAR LAS TRANSACCIONES DE ACTIVACION EN LA TABLA OPERACION.SGAT_TRXCONTEGO.';
          EXIT;
        END IF;
      END LOOP;
    END IF; --5.0

    -- 15 refrescar
    FOR C_REF IN C_DECOS(15) LOOP
      OPERACION.PQ_SIAC_CAMBIO_PLAN_LTE.SGASI_PROV_CONTEGO_SV(V_CODSOLOT,
                                                              C_REF.NRO_SERIE_TARJETA,
                                                              N_ERROR,
                                                              V_ERROR);
      IF N_ERROR <> 0 THEN
        V_RES_ERROR := 'ERROR';
        V_MSJ_ERROR := 'ERROR: AL EJECUTAR PQ_SIAC_CAMBIO_PLAN_LTE.SGASI_PROV_CONTEGO_SV';
        EXIT;
      END IF;
    END LOOP;

  EXCEPTION
    WHEN EX_ERROR THEN
      V_RES_ERROR := V_RES_ERROR;
      V_MSJ_ERROR := V_MSJ_ERROR;
    WHEN OTHERS THEN
      V_RES_ERROR := 'ERROR';
      V_MSJ_ERROR := 'ERROR PKG_CONTEGO.SGASS_DECOS_CONTEGO_CP ' || sqlerrm ||
                     ' - Linea(' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ')';
  END;
  
   -- ini 6.0
  /****************************************************************
  * Nombre SP      : SGASS_WSCONTEGO_APP
  * Proposito      : Este SP genera los XML para pareo, despareo y
                     activacion segun sea el caso y las envia hacia
                     contego, para las sots del app servicio tecnico.
  * Input          : K_CODSOLOT - Numero de SOT
                     K_ESTADO   - Estado de la transaccion
  * Output         : K_CURSOR
                     K_RESPUESTA
                     K_MENSAJE
  * Creado por     : Wendy Tamayo
  * Fec. Creacion  : 26/02/2020
  * Fec. Actualizacion : --
  ****************************************************************/
PROCEDURE SGASS_WSCONTEGO_APP(K_CODSOLOT  IN NUMBER,
                              K_ESTADO    IN VARCHAR2,
                              K_CURSOR    OUT SYS_REFCURSOR,
                              K_RESPUESTA OUT VARCHAR2,
                              K_MENSAJE   OUT VARCHAR2) IS

    V_CODSOLOT            NUMBER;
    V_REINTENTOSC         NUMBER;
    v_sgaseq_transcontego NUMBER;
    EX_ERROR EXCEPTION;
    V_FECFIN DATE;
    LC_FECFIN_ROTACION   VARCHAR2(12);

    CURSOR C_TRANS_CONTEGO IS
      SELECT TRX.TRXN_IDTRANSACCION,
             TRX.TRXN_CODSOLOT,
             TRX.TRXC_REINTENTOS,
             TRX.TRXN_ACTION_ID
        FROM OPERACION.SGAT_TRXCONTEGO TRX
       WHERE TRX.TRXC_ESTADO = K_ESTADO
         AND TRX.TRXN_CODSOLOT = K_CODSOLOT
       ORDER BY TRX.TRXN_IDTRANSACCION ASC;
  BEGIN
    V_CODSOLOT  := NULL;
    k_RESPUESTA := '0';
    k_MENSAJE   := 'PROCESO TERMINADO SATISFACTORIAMENTE';
    K_CURSOR    := NULL;

    --Actualizamos la fecha de rotacion si ya llegamos a la fecha configurada
  SELECT TO_CHAR(C.VALOR)
    INTO LC_FECFIN_ROTACION
    FROM CONSTANTE C
   WHERE C.CONSTANTE = 'DTHROTACION';

  IF (TO_CHAR(TRUNC(SYSDATE), 'DD/MM/YYYY') = LC_FECFIN_ROTACION) THEN
    SELECT ADD_MONTHS(LC_FECFIN_ROTACION, 12)
      INTO LC_FECFIN_ROTACION
      FROM DUAL;

    UPDATE CONSTANTE
       SET VALOR = LC_FECFIN_ROTACION
     WHERE CONSTANTE = 'DTHROTACION';
    COMMIT;
  END IF;
  -- Fin actualizacion de fecha de rotacion

    SELECT to_date(C.VALOR, 'DD/MM/YYYY')
      INTO V_FECFIN
      FROM CONSTANTE C
     WHERE C.CONSTANTE = 'DTHROTACION';
    -- Validamos que ingrese estados 1 o 4
    IF K_ESTADO NOT IN (C_GENERADO_APP, C_PROV_ERROR) OR K_ESTADO IS NULL THEN
      k_RESPUESTA := '-1';
      k_MENSAJE   := 'ERROR: EL ESTADO INGRESADO DEBE SER generado(1) o error(4).';
      RAISE EX_ERROR;
    END IF;
    --Cargamos desde constantes BD el numero de reintentos permitido
    BEGIN
      SELECT VALOR
        INTO V_REINTENTOSC
        FROM OPERACION.CONSTANTE
       WHERE CONSTANTE = 'CONTEGO_REINTEN';
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        k_RESPUESTA := '-1';
        k_MENSAJE   := 'ERROR: NO SE ENCUENTRAN CONFIGURADOS LOS REINTENTOS EN LA TABLA OPERACION.CONSTANTE';
        RAISE EX_ERROR;
    END;
    FOR C_TRANS IN C_TRANS_CONTEGO LOOP
      V_CODSOLOT := C_TRANS.TRXN_CODSOLOT;
      -- Valida reintentos, si es mayor al numero de reintentos configurados cambia a estado 5
      IF K_ESTADO = C_PROV_ERROR AND
         C_TRANS.TRXC_REINTENTOS >= V_REINTENTOSC THEN
        BEGIN
          UPDATE OPERACION.SGAT_TRXCONTEGO S
             SET S.TRXC_ESTADO  = C_PROV_REPORTADO,
                 S.TRXV_MSJ_ERR = C_MSG_REINTENTO
           WHERE S.TRXN_IDTRANSACCION = C_TRANS.TRXN_IDTRANSACCION
             AND S.TRXN_CODSOLOT = K_CODSOLOT;
        EXCEPTION
          WHEN OTHERS THEN
            k_RESPUESTA := '-1';
            k_MENSAJE   := 'ERROR: ' || SQLCODE || ' ' || SQLERRM || ' ' ||
                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
            RAISE EX_ERROR;
        END;
        --Si es error aumentamos en 1 el conteo de reintentos
      ELSIF K_ESTADO = C_PROV_ERROR THEN
        BEGIN
          UPDATE OPERACION.SGAT_TRXCONTEGO S
             SET S.TRXC_REINTENTOS = S.TRXC_REINTENTOS + 1
           WHERE S.TRXN_IDTRANSACCION = C_TRANS.TRXN_IDTRANSACCION
             AND S.TRXN_CODSOLOT = K_CODSOLOT;
        EXCEPTION
          WHEN OTHERS THEN
            k_RESPUESTA := '-1';
            k_MENSAJE   := 'ERROR: ' || SQLCODE || ' ' || SQLERRM || ' ' ||
                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
            RAISE EX_ERROR;
        END;
        -- Si es generado por primera vez le asignamos una fecha y cambiamos de estado a enviado
      ELSIF K_ESTADO = C_GENERADO_APP THEN
        BEGIN
          UPDATE OPERACION.SGAT_TRXCONTEGO A
             SET A.TRXD_FECINI = TRUNC(SYSDATE, 'MONTH'),
                 A.TRXD_FECFIN = V_FECFIN
           WHERE A.TRXN_IDTRANSACCION = C_TRANS.TRXN_IDTRANSACCION
             AND A.TRXN_CODSOLOT = K_CODSOLOT;
        EXCEPTION
          WHEN OTHERS THEN
            k_RESPUESTA := '-1';
            k_MENSAJE   := 'ERROR: ' || SQLCODE || ' ' || SQLERRM || ' ' ||
                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
            RAISE EX_ERROR;
        END;
      END IF;
    END LOOP;
    --Fin Valida reintentos

    --Enviaremos un secuencial con el fin de tener mapeado el lote que enviamos a IL
    SELECT OPERACION.SGASEQ_TRANSCONTEGO.NEXTVAL
      INTO V_SGASEQ_TRANSCONTEGO
      FROM DUAL;

    -- Inicio Enviar Cursor
    OPEN K_CURSOR FOR
      SELECT TRX.TRXN_IDTRANSACCION,
             TRX.TRXN_ACTION_ID,
             TRX.TRXV_TIPO,
             TRX.TRXV_SERIE_TARJETA,
             TRX.TRXV_SERIE_DECO,
             TRX.TRXV_BOUQUET,
             TO_CHAR(TRX.TRXD_FECINI, 'YYYY-MM-DD') TRXD_FECINI,
             TO_CHAR(TRX.TRXD_FECFIN, 'YYYY-MM-DD') TRXD_FECFIN,
             V_SGASEQ_TRANSCONTEGO TRANSCONTEGO
        FROM OPERACION.SGAT_TRXCONTEGO TRX
       WHERE TRX.TRXC_ESTADO = K_ESTADO
         AND TRX.TRXN_CODSOLOT = K_CODSOLOT
       ORDER BY TRX.TRXN_IDTRANSACCION, TRX.TRXN_PRIORIDAD ASC;
    -- Fin Enviar Cursor
    -- Despues de que el cursor recogio la data cambiamos a estado enviado
    IF K_ESTADO = C_GENERADO_APP THEN
      FOR I IN C_TRANS_CONTEGO LOOP
        BEGIN
          UPDATE OPERACION.SGAT_TRXCONTEGO A
             SET A.TRXC_ESTADO = C_ENVIADO
           WHERE A.TRXN_IDTRANSACCION = I.TRXN_IDTRANSACCION
             AND A.TRXN_CODSOLOT = K_CODSOLOT;
        EXCEPTION
          WHEN OTHERS THEN
            k_RESPUESTA := '-1';
            k_MENSAJE   := 'ERROR: ' || SQLCODE || ' ' || SQLERRM || ' ' ||
                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
            RAISE EX_ERROR;
        END;
      END LOOP;
    END IF;
    COMMIT;
  EXCEPTION
    WHEN EX_ERROR THEN
      SGASP_LOGERR(C_SP_WSCONTEGO,null,V_CODSOLOT,k_RESPUESTA,k_MENSAJE);
      ROLLBACK;
    WHEN OTHERS THEN
      k_RESPUESTA := '-1';
      k_MENSAJE   := 'ERROR: ' || SQLCODE || ' ' || SQLERRM || ' ' ||
                     DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      SGASP_LOGERR(C_SP_WSCONTEGO,null,V_CODSOLOT,k_RESPUESTA,k_MENSAJE);
      ROLLBACK;
  END SGASS_WSCONTEGO_APP;
  -- fin 6.0
  
END PKG_CONTEGO;
/
