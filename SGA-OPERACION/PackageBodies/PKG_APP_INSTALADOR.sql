CREATE OR REPLACE PACKAGE BODY OPERACION.PKG_APP_INSTALADOR IS

  /*
  ****************************************************************'
  * Nombre PACKAGE : OPERACION.PKG_APP_INSTALADOR
  * Propósito : El Package agrupa las funcionalidades necesarias para el APP Instalador.
  * Input :  -
  * Output : -           
  * Creado por : Obed Ortiz Navarrete
  * Fec Creación : 21/03/2019
  * Fec Actualización : 06/05/2019
  * Versión      Fecha       Autor            Solicitado por                   Descripción
  * ---------  ----------  ---------------    ------------------               ------------------------------------------
  *  1.0        15-05-2019  Abel Ojeda        Equipo BackEnd App Instalador    Implementación para activar equipos en incognito y janus
  ****************************************************************
  */

  /*
  ****************************************************************'
  * Nombre SP : CLRHSS_VALIDA_RESERVA
  * Propósito : El SP permite traer la lista de reservas asignadas a una SOT para ser validadas
                con INCOGNITO.
  * Input :  PI_NRO_SOT   - Numero de SOT
  * Output : PO_CURSOR    - Listado de direcciones
             PO_ID_CLI    - Id cliente con el que sera validado
             PO_TIP_CLI   - Validar si es un cliente BSSC o SGA
             PO_RESULTADO - Codigo resultado
             PO_MSGERR    - Mensaje resultado
  * Creado por : Obed Ortiz Navarrete
  * Fec Creación : 21/03/2019
  * Fec Actualización : --
  ****************************************************************
  */

  PROCEDURE CLRHSS_VALIDA_RESERVA(PI_NRO_SOT   IN NUMBER,
                                  PO_CURSOR    OUT SYS_REFCURSOR,
                                  PO_ID_CLI    OUT VARCHAR2,
                                  PO_TIP_CLI   OUT NUMBER,
                                  PO_RESULTADO OUT INTEGER,
                                  PO_MSGERR    OUT VARCHAR2) IS
    V_CUSTOMER_ID VARCHAR2(20);
    V_COD_CLI     VARCHAR2(20);
  BEGIN
  
    BEGIN
      SELECT S.CUSTOMER_ID, S.CODCLI
        INTO V_CUSTOMER_ID, V_COD_CLI
        FROM OPERACION.SOLOT S
       WHERE S.CODSOLOT = PI_NRO_SOT;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        PO_RESULTADO := -1;
        PO_MSGERR    := 'CLIENTE NO ENCONTRADO';
        OPEN PO_CURSOR FOR
          SELECT '' ID_PRODUCTO, '' TIP_INTERFASE FROM DUAL WHERE 1 = 2;
        RETURN;
    END;
  
    IF V_CUSTOMER_ID IS NULL AND V_COD_CLI IS NULL THEN
      PO_ID_CLI    := '';
      PO_TIP_CLI   := -1;
      PO_RESULTADO := -1;
      PO_MSGERR    := 'CLIENTE NO ENCONTRADO';
      OPEN PO_CURSOR FOR
        SELECT '' ID_PRODUCTO, '' TIP_INTERFASE FROM DUAL WHERE 1 = 2;
      RETURN;
    ELSIF V_CUSTOMER_ID IS NULL THEN
      PO_ID_CLI  := V_COD_CLI;
      PO_TIP_CLI := 2;
    ELSE
      PO_ID_CLI  := V_CUSTOMER_ID;
      PO_TIP_CLI := 1;
    END IF;
  
    OPEN PO_CURSOR FOR
      SELECT TI.ID_PRODUCTO, TI.TIP_INTERFASE
        FROM OPERACION.TRS_INTERFACE_IW TI
       WHERE TI.CODSOLOT = PI_NRO_SOT
         AND TI.ID_INTERFASE != 830;
  
    PO_RESULTADO := 0;
    PO_MSGERR    := 'CONSULTA SATISFACTORIA';
  
  EXCEPTION
    WHEN OTHERS THEN
      OPEN PO_CURSOR FOR
        SELECT '' ID_PRODUCTO, '' TIP_INTERFASE FROM DUAL WHERE 1 = 2;
    
      PO_RESULTADO := -99;
      PO_MSGERR    := 'ERROR: ' || TO_CHAR(SQLCODE) || ' ' || SQLERRM;
  END;

  /*
  ****************************************************************'
  * Nombre SP : CLRHSI_REGIS_RESERVA
  * Propósito : El SP permite relanzar las reservas
  * Input :  PI_NRO_SOT   - Numero de SOT
  * Output : PO_ID_CLI    - Id cliente con el que sera validado
             PO_RESULTADO - Codigo resultado
             PO_MSGERR    - Mensaje resultado
  * Creado por : Obed Ortiz Navarrete
  * Fec Creación : 01/04/2019
  * Fec Actualización : --
  ****************************************************************
  */

  PROCEDURE CLRHSI_REGIS_RESERVA(PI_NRO_SOT   IN NUMBER,
                                 PO_ID_CLI    OUT VARCHAR2,
                                 PO_RESULTADO OUT INTEGER,
                                 PO_MSGERR    OUT VARCHAR2) IS
    V_CUSTOMER_ID VARCHAR2(20);
    V_COD_CLI     VARCHAR2(20);
    V_MENSAJE     VARCHAR2(20);
    V_CODIGO      NUMBER;
    V_ID_CLI      VARCHAR2(20);
  BEGIN
  
    BEGIN
      SELECT S.CUSTOMER_ID, S.CODCLI
        INTO V_CUSTOMER_ID, V_COD_CLI
        FROM OPERACION.SOLOT S
       WHERE S.CODSOLOT = PI_NRO_SOT;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        PO_RESULTADO := -1;
        PO_MSGERR    := 'CLIENTE NO ENCONTRADO';
        RETURN;
    END;
  
    IF V_CUSTOMER_ID IS NULL AND V_COD_CLI IS NULL THEN
      V_ID_CLI     := '';
      PO_RESULTADO := -1;
      PO_MSGERR    := 'CLIENTE NO ENCONTRADO';
      RETURN;
    ELSIF V_CUSTOMER_ID IS NULL THEN
      V_ID_CLI := V_COD_CLI;
    ELSE
      V_ID_CLI := V_CUSTOMER_ID;
    END IF;
  
    PO_ID_CLI := V_ID_CLI;
  
    BEGIN
      INTRAWAY.PQ_CONT_HFCBSCS.p_int_baja_hfcsisact(PI_NRO_SOT,
                                                    1,
                                                    V_MENSAJE,
                                                    V_CODIGO);
    EXCEPTION
      WHEN OTHERS THEN
        PO_RESULTADO := V_CODIGO;
        PO_MSGERR    := V_MENSAJE;
        RETURN;
    END;
  
    IF V_CODIGO = 0 THEN
      INTRAWAY.PQ_CONT_HFCBSCS.p_int_genreserva(V_ID_CLI,
                                                PI_NRO_SOT,
                                                1,
                                                V_CODIGO,
                                                V_MENSAJE);
      IF V_CODIGO = 0 THEN
        PO_RESULTADO := 0;
        PO_MSGERR    := 'EXITO';
      ELSE
        PO_RESULTADO := -97;
        PO_MSGERR    := 'No se genero las reservas';
      END IF;
    ELSE
      PO_RESULTADO := V_CODIGO;
      PO_MSGERR    := 'No se pudo realizar la baja de reservas';
      RETURN;
    END IF;
  
  EXCEPTION
    WHEN OTHERS THEN
      PO_RESULTADO := -99;
      PO_MSGERR    := 'ERROR: ' || TO_CHAR(SQLCODE) || ' ' || SQLERRM;
  END;

  /*
  ****************************************************************'
  * Nombre SP : CLRHSS_EQUI_INSTALA
  * Propósito : El SP permite listar los equipos a instalar.
  * Input :  PI_NRO_SOT   - Numero de SOT.
  * Output : PO_CURSOR    - Cursor que lista los equipos a instalar.
             PO_RESULTADO - Codigo resultado.
             PO_MSGERR    - Mensaje resultado.
  * Creado por : Obed Ortiz Navarrete
  * Fec Creación : 04/04/2019
  * Fec Actualización : 13/06/2019
  ****************************************************************
  */

  PROCEDURE CLRHSS_EQUI_INSTALA(PI_NRO_SOT   IN NUMBER,
                                PO_CURSOR    OUT SYS_REFCURSOR,
                                PO_RESULTADO OUT INTEGER,
                                PO_MSGERR    OUT VARCHAR2) IS
    V_CODSOLOT VARCHAR2(20);
  
  BEGIN
  
    SELECT s.codsolot
      INTO V_CODSOLOT
      FROM operacion.solot s
     WHERE s.codsolot = PI_NRO_SOT;
  
    OPEN PO_CURSOR FOR
    -- internet
      SELECT DISTINCT te.tipo        descripcion,
                      i.id_interfase interfase,
                      i.idtrs        idtrs,
                      i.mac_address  identificador
        FROM (SELECT DISTINCT ip.pid,
                              ip.codequcom,
                              ip.cantidad,
                              ip.estinsprd,
                              iv.tipsrv,
                              sp.codinssrv
                FROM solot s, solotpto sp, insprd ip, inssrv iv
               WHERE s.codsolot = sp.codsolot
                 AND sp.codinssrv = iv.codinssrv
                 AND ip.codinssrv = iv.codinssrv
                 AND s.codsolot = PI_NRO_SOT
                 AND ip.estinsprd in (1, 2, 4)) x
       INNER JOIN vtaequcom eq
          ON x.codequcom = eq.codequcom
       INNER join equcomxope v
          ON eq.codequcom = v.codequcom
       INNER JOIN tipequ te
          ON v.codtipequ = te.codtipequ
        LEFT JOIN operacion.trs_interface_iw i
          ON x.codinssrv = i.codinssrv
         AND i.id_interfase in (620, 820)
       WHERE nvl(x.codequcom, 'x') != 'x'
         AND te.tipo in ('EMTA', 'TELEFONO')
      
      union all
      
      -- cable
      SELECT DISTINCT eq.tip_eq      descripcion,
                      i.id_interfase interfase,
                      i.idtrs        idtrs,
                      i.mac_address  identificador
        FROM (SELECT DISTINCT ip.pid,
                              ip.codequcom,
                              ip.cantidad,
                              ip.estinsprd,
                              iv.tipsrv,
                              sp.codinssrv
                FROM solot s, solotpto sp, insprd ip, inssrv iv
               WHERE s.codsolot = sp.codsolot
                 AND sp.codinssrv = iv.codinssrv
                 AND ip.codinssrv = iv.codinssrv
                 AND s.codsolot = PI_NRO_SOT
                 AND ip.estinsprd in (1, 2, 4)) x
       INNER JOIN vtaequcom eq
          ON x.codequcom = eq.codequcom
       INNER JOIN equcomxope v
          ON eq.codequcom = v.codequcom
       INNER JOIN tipequ te
          ON v.codtipequ = te.codtipequ
        LEFT JOIN operacion.trs_interface_iw i
          ON x.codinssrv = i.codinssrv
         AND i.id_interfase in (2020)
       WHERE nvl(x.codequcom, 'x') != 'x'
         AND te.tipo = 'DECODIFICADOR';
  
    PO_RESULTADO := 0;
    PO_MSGERR    := 'CONSULTA SATISFACTORIA';
  
  EXCEPTION
  
    WHEN NO_DATA_FOUND THEN
      OPEN PO_CURSOR FOR
        SELECT '' descripcion, '' interfase, '' idtrs, '' identificador
          FROM dual
         WHERE 1 = 2;
      PO_RESULTADO := -1;
      PO_MSGERR    := 'SOT NO EXISTE';
    
    WHEN OTHERS THEN
      OPEN PO_CURSOR FOR
        SELECT '' descripcion, '' interfase, '' idtrs, '' identificador
          FROM dual
         WHERE 1 = 2;
    
      PO_RESULTADO := -99;
      PO_MSGERR    := 'ERROR: ' || TO_CHAR(SQLCODE) || ' ' || SQLERRM;
    
  END CLRHSS_EQUI_INSTALA;

  /*
  ****************************************************************'
  * Nombre SP : CLRHSI_ACTIVA_SERVICIO
  * Propósito : El SP activar equipos en Incognito.
  * Input :  PI_NRO_SOT        - Numero de SOT.
             PI_INTERFASE      - Interfase para incognito (620,820,2020).
             PI_IDTRS          - Idtrs de la tabla OPERACION.TRS_INTERFACE_IW.
             PI_MAC_ADDRESS    - Mac Address.
             PI_UNIT_ADDRESS   - Unit Address.
             PI_MODELO         - Modelo DECO.
  * Output : PO_RESULTADO      - Codigo resultado.
             PO_MSGERR         - Mensaje resultado.
             PO_ERROR          - Codigo de error.
  * Creado por : Abel Ojeda 
  * Fec Creación : 13/05/2019
  * Fec Actualización : 13/06/2019
  ****************************************************************
  */


  PROCEDURE CLRHSI_ACTIVA_SERVICIO(PI_NRO_SOT      IN NUMBER,
                                   PI_INTERFASE    IN NUMBER,
                                   PI_IDTRS        IN NUMBER,
                                   PI_MAC_ADDRESS  IN VARCHAR2,
                                   PI_UNIT_ADDRESS IN VARCHAR2,
                                   PI_MODELO       IN VARCHAR2,
                                   PO_RESULTADO    OUT VARCHAR2,
                                   PO_MSGERR       OUT VARCHAR2,
                                   PO_ERROR        OUT NUMBER) IS
  
    CURSOR cm is
      SELECT i.id_producto,
             i.id_producto_padre,
             i.id_interfase,
             PI_MODELO MODELO,
             PI_MAC_ADDRESS MAC_ADDRESS,
             i.codsolot,
             i.cod_id,
             PI_UNIT_ADDRESS UNIT_ADDRESS,
             i.idtrs,
             i.codinssrv,
             i.pidsga,
             (SELECT d.valor
                FROM operacion.trs_interface_iw_det d
               WHERE d.idtrs = i.idtrs
                 AND d.atributo = 'activationCode') as activationcode,
             (SELECT d.valor
                FROM operacion.trs_interface_iw_det d
               WHERE d.idtrs = i.idtrs
                 AND d.atributo = 'defaultProductCRMId') as productcrmid,
             (SELECT d.valor
                FROM operacion.trs_interface_iw_det d
               WHERE d.idtrs = i.idtrs
                 AND d.atributo = 'channelMapCRMId') as channelmap,
             (SELECT d.valor
                FROM operacion.trs_interface_iw_det d
               WHERE d.idtrs = i.idtrs
                 AND d.atributo = 'defaultConfigCRMId') as configcrmid
        FROM operacion.trs_interface_iw i
       WHERE i.codsolot = PI_NRO_SOT
         AND i.id_interfase = PI_INTERFASE
         AND i.idtrs = PI_IDTRS;
  
    CURSOR info IS
      SELECT DISTINCT a.customer_id,
                      a.cod_id,
                      a.codcli,
                      a.tiptra,
                      a.cod_id_old
        FROM solot a
       WHERE a.codsolot = PI_NRO_SOT;
  
    cv_customer_id solot.customer_id%TYPE;
    cn_cod_id      solot.cod_id%TYPE;
    cv_codcli      solot.codcli%TYPE;
    cn_tiptra      solot.tiptra%TYPE;
    cn_cod_id_old  solot.cod_id_old%TYPE;
    excep_agen EXCEPTION;
    cn_valida NUMBER;
  
  BEGIN
  
    FOR d IN info LOOP
      cv_customer_id := to_char(d.customer_id);
      cn_cod_id      := d.cod_id;
      cv_codcli      := d.codcli;
      cn_tiptra      := d.tiptra;
      cn_cod_id_old  := d.cod_id_old;
    END LOOP;
  
    --Validando SOT
    SELECT operacion.pq_sga_iw.f_valida_envio_res_act_iw(PI_NRO_SOT)
      INTO cn_valida
      FROM dual;
  
    IF cn_valida = 1 THEN
      PO_ERROR     := -1;
      PO_RESULTADO := 'FAIL';
      PO_MSGERR    := 'No se puede enviar la Activacion a IW cuando la SOT esta en estado Rechazado o Anulado';
      RETURN;
    END IF;
  
    --- Activacion 
    FOR c IN cm LOOP
      -- Activacion internet 
      IF c.id_interfase = '620' THEN
      
        intraway.pq_cont_hfcbscs.p_cont_actcm(1,
                                              cv_customer_id,
                                              c.id_producto,
                                              3,
                                              PI_NRO_SOT,
                                              c.mac_address,
                                              PO_RESULTADO,
                                              PO_MSGERR,
                                              PO_ERROR);
      
        If PO_ERROR = 0 THEN
          COMMIT;
        ELSE
          ROLLBACK;
          RAISE excep_agen;
        END IF;
      
      END IF;
      -- Activacion telefonia
      IF c.id_interfase = '820' THEN
      
        intraway.pq_cont_hfcbscs.p_cont_actmta(2,
                                               cv_customer_id,
                                               c.id_producto,
                                               c.id_producto_padre,
                                               3,
                                               PI_NRO_SOT,
                                               c.mac_address,
                                               1,
                                               c.modelo,
                                               PO_RESULTADO,
                                               PO_MSGERR,
                                               PO_ERROR);
        IF PO_ERROR = 0 THEN
          COMMIT;
        ELSE
          ROLLBACK;
          RAISE excep_agen;
        END IF;
      
      End If;
      -- Activacion de cable
      IF c.id_interfase = '2020' THEN
      
        intraway.pq_cont_hfcbscs.p_cont_actstb(1,
                                               cv_customer_id,
                                               c.id_producto,
                                               c.mac_address,
                                               c.unit_address,
                                               'FALSE',
                                               3,
                                               PI_NRO_SOT,
                                               c.modelo,
                                               PO_RESULTADO,
                                               PO_MSGERR,
                                               PO_ERROR);
      
        IF PO_ERROR = 0 THEN        
          COMMIT;                   
          ELSE
            ROLLBACK;
            RAISE excep_agen;
        END IF;
        
        END IF;
          
    END LOOP;
  
    --Actualizando MAC en la tabla trs_interfase
    IF PO_ERROR = 0 THEN
      operacion.pkg_app_instalador.clrhsu_interf_iw(PI_NRO_SOT,
                                                    PI_INTERFASE,
                                                    PI_IDTRS,
                                                    PI_MAC_ADDRESS,
                                                    PI_UNIT_ADDRESS,
                                                    PI_MODELO,
                                                    PO_RESULTADO,
                                                    PO_MSGERR,
                                                    PO_ERROR);
    
      IF PO_ERROR = 0 THEN
        COMMIT;
      ELSE
        ROLLBACK;
      END IF;
      -- Provision en Janus para telefonia
      FOR c IN cm LOOP
        IF c.id_interfase = '820' THEN
          operacion.pq_cont_regularizacion.p_altanumero_janus_bscs(pi_nro_sot,
                                                                   po_error,
                                                                   po_msgerr);
          IF PO_ERROR <> 1 THEN
            ROLLBACK;
          ELSE
            COMMIT;
          END IF;
        END IF;
		
		--- Actualizando tablas para cable 
		IF c.id_interfase = '2020' THEN
          intraway.pq_cont_hfcbscs.p_cont_creastb(2,
                                                  cv_customer_id,
                                                  c.id_producto,
                                                  TO_NUMBER(c.pidsga),
                                                  c.activationcode,
                                                  c.productcrmid,
                                                  c.channelmap,
                                                  c.configcrmid,
                                                  'TRUE',
                                                  3,
                                                  PI_NRO_SOT,
                                                  c.codinssrv,
                                                  PO_RESULTADO,
                                                  PO_MSGERR,
                                                  PO_ERROR);		  
          IF PO_ERROR <> 0 THEN
            ROLLBACK;
          ELSE
            COMMIT;
          END IF;
        END IF;	
      END LOOP;
      PO_ERROR  := 0;
      PO_MSGERR := 'CONSULTA SATISFACTORIA';
    END IF;
    --
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      PO_RESULTADO := 'FAIL';
      PO_MSGERR    := 'SIN DATOS PARA ACTIVAR';
      PO_ERROR     := -2;
    WHEN excep_agen THEN
      PO_RESULTADO := 'FAIL';
	    PO_MSGERR    := 'ERROR EN LA ACTIVACION DEL EQUIPO';
      PO_ERROR     := -1;
    WHEN OTHERS THEN
      ROLLBACK;
      PO_RESULTADO := 'FAIL';
      PO_MSGERR    := sqlerrm;
      PO_ERROR     := sqlcode;
    
  END;

  /*
  ****************************************************************'
  * Nombre SP : CLRHSU_INTERF_IW
  * Propósito : El SP actualiza Mac Address, Unit Address y Modelo en la tabla
                OPERACION.TRS_INTERFACE_IW.
  * Input :  PI_NRO_SOT        - Numero de SOT.
             PI_INTERFASE      - Interfase para incognito (620,820,2020).
             PI_IDTRS          - Idtrs de la tabla OPERACION.TRS_INTERFACE_IW.
             PI_MAC_ADDRESS    - Mac Address.
             PI_UNIT_ADDRESS   - Unit Address.
             PI_MODELO         - Modelo DECO.
  * Output : PO_RESULTADO      - Codigo resultado  .         
             PO_MSGERR         - Mensaje resultado.
             PO_ERROR          - Codigo de error.
  * Creado por : Abel Ojeda
  * Fec Creación : 13/05/2019
  * Fec Actualización : --
  ****************************************************************
  */

 PROCEDURE CLRHSU_INTERF_IW(PI_NRO_SOT      IN NUMBER,
                             PI_INTERFASE    IN NUMBER,
                             PI_IDTRS        IN NUMBER,
                             PI_MACADDRESS   IN VARCHAR2,
                             PI_UNIT_ADDRESS IN VARCHAR2,
                             PI_MODELO       IN VARCHAR2,
                             PO_RESULTADO    OUT VARCHAR2,
                             PO_MSGERR       OUT VARCHAR2,
                             PO_ERROR        OUT NUMBER) IS
    CN_ROWAFFECTED NUMBER;
  BEGIN
  
    CN_ROWAFFECTED := 0;
  
    IF PI_INTERFASE = 620 THEN
      UPDATE OPERACION.TRS_INTERFACE_IW
         SET MAC_ADDRESS = PI_MACADDRESS, MODELO = PI_MODELO
       WHERE IDTRS = PI_IDTRS
         AND CODSOLOT = PI_NRO_SOT;
      CN_ROWAFFECTED := sql%rowcount;
    END IF;
    IF PI_INTERFASE = 820 THEN
      UPDATE OPERACION.TRS_INTERFACE_IW
         SET MAC_ADDRESS = PI_MACADDRESS, MODELO = PI_MODELO
       WHERE IDTRS = PI_IDTRS
         AND CODSOLOT = PI_NRO_SOT;
      CN_ROWAFFECTED := sql%rowcount;
    END IF;
    IF PI_INTERFASE = 2020 THEN
      UPDATE OPERACION.TRS_INTERFACE_IW
         SET MAC_ADDRESS  = PI_MACADDRESS,
             UNIT_ADDRESS = PI_UNIT_ADDRESS,
             MODELO       = PI_MODELO
       WHERE IDTRS = PI_IDTRS
         AND CODSOLOT = PI_NRO_SOT;
      CN_ROWAFFECTED := sql%rowcount;
    END IF;
    IF CN_ROWAFFECTED > 0 THEN
      PO_ERROR     := 0;
      PO_MSGERR    := 'ACTUALIZACION CORRECTA';
      PO_RESULTADO := 'OK';
    ELSE
      PO_ERROR     := 1;
      PO_MSGERR    := 'DATA NO ENCONTRADA PARA ACTUALIZAR';
      PO_RESULTADO := 'OK';
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      PO_RESULTADO := 'FAIL';
      PO_MSGERR    := 'ERROR AL ACTUALIZAR DATOS';
      PO_ERROR     := -1;
    
  END;

  /*
  ****************************************************************'
  * Nombre SP : CLRHSS_CONSULTA_EQUIPO
  * Propósito : El SP permite obtener el customer_id, identificador,
             interfase, modelo, id_producto asignadas a una SOT para 
             ser validadas con INCOGNITO.
  * Input :  PI_NRO_SOT   - Numero de SOT
  * Output : PO_CURSOR    - Listado de parametros
             PO_RESULTADO - Codigo resultado
             PO_MSGERR    - Mensaje resultado
  * Creado por : Emiliano Espinoza
  * Fec Creación : 16/05/2019
  * Fec Actualización : 13/06/2019
  ****************************************************************
  */
  PROCEDURE CLRHSS_CONSULTA_EQUIPO(PI_NRO_SOT   IN NUMBER,
                                   PO_CURSOR    OUT SYS_REFCURSOR,
                                   PO_RESULTADO OUT INTEGER,
                                   PO_MSGERR    OUT VARCHAR2) IS
    v_customer_id VARCHAR2(20);
    v_cod_cli     VARCHAR2(20);
  BEGIN
  
    BEGIN
      SELECT s.customer_id, s.codcli
        INTO v_customer_id, v_cod_cli
        FROM operacion.solot s
       WHERE s.codsolot = PI_NRO_SOT;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        PO_RESULTADO := -1;
        PO_MSGERR    := 'CLIENTE NO ENCONTRADO';
        OPEN PO_CURSOR FOR
          SELECT '' customer_id,
                 '' identificador,
                 '' interfase,
                 '' modelo,
                 '' id_producto
            FROM DUAL
           WHERE 1 = 2;
        RETURN;
    END;
  
    OPEN PO_CURSOR FOR
      SELECT s.customer_id,
             iw.mac_address  identificador,
             iw.id_interfase interfase,
             iw.modelo,
             iw.id_producto
        FROM operacion.trs_interface_iw iw, solot s
       WHERE iw.cod_id = s.cod_id
         AND s.codsolot = PI_NRO_SOT
         AND iw.id_interfase in ('2020', '820', '620');
  
    PO_RESULTADO := 0;
    PO_MSGERR    := 'CONSULTA SATISFACTORIA';
  
  EXCEPTION
    WHEN OTHERS THEN
      OPEN PO_CURSOR FOR
        SELECT '' customer_id,
               '' identificador,
               '' interfase,
               '' modelo,
               '' id_producto
          FROM DUAL
         WHERE 1 = 2;
    
      PO_RESULTADO := -99;
      PO_MSGERR    := 'ERROR: ' || TO_CHAR(SQLCODE) || ' ' || SQLERRM;
  END;

  /*
  ****************************************************************'
  * Nombre SP : CLRHSS_CONSULTA_DATOS_SOT
  * Propósito : El SP permite traer el flag de portabilidad, plan contratado y listar los numeros del cliente.
  * Input :  PI_NRO_SOT   - Numero de SOT
  * Output : PO_FLG_PORTABLE - Flag de portabilidad
             PO_PLAN         - Plan contratado
             PO_CURSOR       - Listado de numeros del cliente
             PO_RESULTADO    - Codigo resultado
             PO_MSGERR       - Mensaje resultado
  * Creado por : Hitss
  * Fec Creación : 28/05/2019
  * Fec Actualización : --
  ****************************************************************
  */

  PROCEDURE CLRHSS_CONSULTA_DATOS_SOT(PI_NRO_SOT        IN NUMBER,
                                      PO_FLG_PORTABLE   OUT INTEGER,
                                      PO_PLAN           OUT VARCHAR2,
                                      PO_CURSOR         OUT SYS_REFCURSOR,
                                      PO_CODIGO_CLIENTE OUT VARCHAR2,
                                      PO_DESCRIPCION    OUT VARCHAR2,
									  PO_COD_ESCENARIO  OUT VARCHAR2,
                                      PO_ESCENARIO      OUT VARCHAR2,
									  PO_COD_TECNOLOGIA OUT VARCHAR2,
                                      PO_TECNOLOGIA     OUT VARCHAR2,
                                      PO_RESULTADO      OUT INTEGER,
                                      PO_MSGERR         OUT VARCHAR2) IS
  
    V_CODCLI  VARCHAR(10);
    V_CUSCODE VARCHAR(10);
    V_TIPTRA VARCHAR(10);
    V_CODRSP VARCHAR(1);
    V_MENSAJE VARCHAR(200);
    V_COD_ES VARCHAR(10);

  BEGIN
  
    -- FLAG DE PORTABILIDAD
    SELECT count(1)
      INTO PO_FLG_PORTABLE
      FROM sales.vtatabslcfac vta
     INNER JOIN operacion.solot s
        ON s.numslc = vta.numslc
       AND s.codsolot = PI_NRO_SOT
	   WHERE vta.flg_portable = 1;
       
    --  NUMERO DEL CLIENTE
    OPEN PO_CURSOR FOR
      SELECT DISTINCT med.numcomcli
        FROM marketing.vtatabmedcom tab
       INNER JOIN marketing.vtamedcomcli med
          ON med.idmedcom = tab.idmedcom
       INNER JOIN operacion.solot s
          ON s.codcli = med.codcli
       WHERE s.codsolot = PI_NRO_SOT
         AND tab.medcom LIKE 'TELEFONO%';

    -- PLAN CONTRATADO
    PO_PLAN := operacion.pkg_app_instalador.clrhfs_plan_contratado(PI_NRO_SOT);
  
    -- OBTENER CODIGO DE CLIENTE Y TIPTRA
    select customer_id, codcli, tiptra
      INTO V_CUSCODE, V_CODCLI, V_TIPTRA
      from SOLOT
     where codsolot = PI_NRO_SOT;
  
    IF V_CUSCODE IS NULL THEN
      PO_CODIGO_CLIENTE := V_CODCLI;
    ELSE
      PO_CODIGO_CLIENTE := V_CUSCODE;
    END IF;
    
    operacion.pkg_prov_incognito.P_TIPTRA(V_TIPTRA,PO_DESCRIPCION,PO_COD_ESCENARIO,PO_ESCENARIO,PO_COD_TECNOLOGIA,PO_TECNOLOGIA,V_CODRSP,V_MENSAJE);

    IF V_CODRSP<>'0' THEN
      PO_DESCRIPCION:='';
	    PO_COD_ESCENARIO:='';
      PO_ESCENARIO:='';
	    PO_COD_TECNOLOGIA:='';
      PO_TECNOLOGIA:='';
    END IF;

    PO_RESULTADO := 0;
    PO_MSGERR    := 'CONSULTA SATISFACTORIA';
  exception
    when others then
      PO_RESULTADO := 1;
      PO_MSGERR    := 'ERROR AL CONSULTAR';
  END CLRHSS_CONSULTA_DATOS_SOT;


  /*
  ****************************************************************'
  * Nombre FN : CLRHFS_PLAN_CONTRATADO
  * Propósito : La FN permite obtener el plan contrado (1,2,3 Play).
  * Input :  PI_NRO_SOT   - Numero de SOT
  * Output : v_plan_c     - Plan contratado
  * Creado por : Hitss
  * Fec Creación : 02/07/2019
  * Fec Actualización : --
  ****************************************************************
  */  
  
  FUNCTION CLRHFS_PLAN_CONTRATADO(PI_NRO_SOT IN operacion.solotpto.codsolot%TYPE)
    return VARCHAR2 is
    v_plan_c   VARCHAR2(20);
    v_sucursal operacion.inssrv.codsuc%TYPE;
    v_cliente  operacion.inssrv.codcli%TYPE;
    v_count    INTEGER;
  BEGIN
  
    SELECT COUNT(1)
      INTO v_count
      from operacion.solotpto pto
     where pto.codsolot = PI_NRO_SOT;
  
    IF v_count > 0 THEN
      SELECT DISTINCT ins.codcli, ins.codsuc
        INTO v_cliente, v_sucursal
        FROM operacion.solot s
       INNER JOIN operacion.solotpto pto
          ON S.codsolot = pto.codsolot
         AND S.codsolot = PI_NRO_SOT
       INNER JOIN operacion.inssrv ins
          ON pto.codinssrv = ins.codinssrv;
    
      SELECT DECODE(COUNT(DISTINCT TIPSRV),
                    1,
                    '1 PLAY',
                    2,
                    '2 PLAY',
                    3,
                    '3 PLAY')
        INTO v_plan_c
        FROM operacion.inssrv
       WHERE codcli = v_cliente
         and codsuc = v_sucursal
         and tipsrv in ('0004', '0006', '0062')
         and estinssrv in (1, 2, 4);
    
      IF v_plan_c IS NULL THEN
        v_plan_c := 'SIN INFORMACION';
      END IF;
    
    ELSE
      v_plan_c := 'SIN INFORMACION';
    
    END IF;
  
    RETURN v_plan_c;
  
  END CLRHFS_PLAN_CONTRATADO;

  /*
  ****************************************************************'
  * Nombre SP : CLRHSS_VALIDAR_DECO
  * Propósito : El SP permite validar el tipo de plan contratado respecto al decodeficador.
  * Input :  PI_TIPODECO   - TIPO DEL DECODEFICADOR
         PI_MODELO - MODELO DEL DECODEFICADOR
  * Output : PO_CURSOR    - Listado de parametros
             PO_RESULTADO - Codigo resultado
             PO_MSGERR    - Mensaje resultado
  * Creado por : Emiliano Espinoza
  * Fec Creación : 19/06/2019
  * Fec Actualización :
  ****************************************************************
  */
  PROCEDURE CLRHSS_VALIDAR_DECO(PI_TIPODECO  IN VARCHAR2,
                                PI_MODELO    IN VARCHAR2,
                                PO_RESULTADO OUT INTEGER,
                                PO_MSGERR    OUT VARCHAR2) IS
    V_TIP_EQ       VARCHAR2(20);
    V_MODELOEQUITW VARCHAR2(20);
  BEGIN
  
    BEGIN
      SELECT DISTINCT EQUIPO.TIP_EQ, EQUIPO.MODELOEQUITW
        INTO V_TIP_EQ, V_MODELOEQUITW
        FROM VTAEQUCOM EQUIPO
       WHERE EQUIPO.TIP_EQ IS NOT NULL
         AND EQUIPO.MODELOEQUITW IS NOT NULL
         AND EQUIPO.FLG_SISACT_SGA = 1
         AND EQUIPO.TIP_EQ = PI_TIPODECO
         AND EQUIPO.MODELOEQUITW = PI_MODELO;
    
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        PO_RESULTADO := 1;
        PO_MSGERR    := 'Equipo no edecuado para el tipo de contratación';
        RETURN;
    END;
  
    PO_RESULTADO := 0;
    PO_MSGERR    := 'Validación correcta';
  
  EXCEPTION
    WHEN OTHERS THEN
      PO_RESULTADO := -99;
      PO_MSGERR    := 'ERROR: ' || TO_CHAR(SQLCODE) || ' ' || SQLERRM;
  END;

  /*
  ****************************************************************'
  * Nombre SP : CLRHSI_GUARDA_COORDENADAS
  * Propósito : El SP permite guardar las coordenas x e y en SGA.
  * Input :  PI_NRO_SOT   - Numero de SOT
             PI_COORDX    - Coordenada X
             PI_COORDY    - Coordenada Y
  * Output : PO_RESULTADO - Codigo resultado
             PO_MSGERR    - Mensaje resultado
  * Creado por : Hitss
  * Fec Creación : 21/06/2019
  * Fec Actualización : 
  ****************************************************************
  */
  PROCEDURE CLRHSI_GUARDA_COORDENADAS(PI_NRO_SOT   IN operacion.agendamiento.codsolot%TYPE,
                                      PI_COORDX    IN marketing.vtasuccli.coordx_eta%TYPE,
                                      PI_COORDY    IN marketing.vtasuccli.coordy_eta%TYPE,
                                      PO_RESULTADO OUT INTEGER,
                                      PO_MSGERR    OUT VARCHAR2) IS
  
    v_sucursal marketing.vtasuccli.codsuc%TYPE;
    v_cliente  marketing.vtasuccli.codcli%TYPE;
  
  BEGIN
    SELECT distinct codsuc, codcli
      INTO v_sucursal, v_cliente
      FROM operacion.agendamiento
     WHERE codsolot = PI_NRO_SOT;
  
    operacion.pkg_app_instalador.clrhsi_actualiza_xy(v_cliente,
                                                     v_sucursal,
                                                     PI_COORDX,
                                                     PI_COORDY,
                                                     PO_RESULTADO,
                                                     PO_MSGERR);
  
    IF PO_RESULTADO = 0 THEN
      COMMIT;
    ELSE
      ROLLBACK;
      PO_RESULTADO := PO_RESULTADO;
      PO_MSGERR    := PO_MSGERR;
    END IF;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      PO_RESULTADO := -1;
      PO_MSGERR    := 'SOT NO ENCONTRADA';
    WHEN OTHERS THEN
      PO_RESULTADO := -99;
      PO_MSGERR    := 'ERROR: ' || TO_CHAR(SQLCODE) || ' ' || SQLERRM;
    
  END CLRHSI_GUARDA_COORDENADAS;

  /*
  ****************************************************************'
  * Nombre FN : CLRHSI_ACTUALIZA_XY
  * Propósito : El SP permite guardar las coordenas X e Y en las 
                tablas vtasuccli y vtatabcli_his.
  * Input :  PI_CODCLI  - Codigo del cliente (codcli)
             PI_CODSUC  - Codigo de la sucursal (codsuc)
             PI_COORDX  - Coordenada X
             PI_COORDY  - Coordenada Y
  * Output : PO_RESULTADO - Codigo resultado
             PO_MSGERR    - Mensaje resultado
  * Creado por : Hitss
  * Fec Creación : 02/07/2019
  * Fec Actualización : --
  ****************************************************************
  */  

  PROCEDURE CLRHSI_ACTUALIZA_XY(PI_CODCLI    IN marketing.vtasuccli.codcli%TYPE,
                                PI_CODSUC    IN marketing.vtasuccli.codsuc%TYPE,
                                PI_COORDX    IN marketing.vtasuccli.coordx_eta%TYPE,
                                PI_COORDY    IN marketing.vtasuccli.coordy_eta%TYPE,
                                PO_RESULTADO OUT INTEGER,
                                PO_MSGERR    OUT VARCHAR2) IS
  
    v_coordx_eta marketing.vtasuccli.coordx_eta%TYPE;
    v_coordy_eta marketing.vtasuccli.coordy_eta%TYPE;
    ERR_VTASUCCLI EXCEPTION;
  
  BEGIN
    UPDATE marketing.vtasuccli
       SET coordx_eta = PI_COORDX, coordy_eta = PI_COORDY
     WHERE codsuc = PI_CODSUC
       AND codcli = PI_CODCLI
    RETURNING coordx_eta, coordy_eta INTO v_coordx_eta, v_coordy_eta;
  
    IF SQL%ROWCOUNT = 0 THEN
      RAISE ERR_VTASUCCLI;
    END IF;
  
    INSERT INTO operacion.vtatabcli_his
      (codcli, codsuc, coordx, coordy)
    VALUES
      (PI_CODCLI, PI_CODSUC, PI_COORDX, PI_COORDY);
  
    PO_RESULTADO := 0;
    PO_MSGERR    := 'CONSULTA SATISFACTORIA';
  
  EXCEPTION
    WHEN ERR_VTASUCCLI THEN
      PO_RESULTADO := -1;
      PO_MSGERR    := 'ERROR AL REALIZAR EL UPDATE EN LA TABLA VTASUCCLI';
    WHEN OTHERS THEN
      PO_RESULTADO := -99;
      PO_MSGERR    := 'ERROR: ' || TO_CHAR(SQLCODE) || ' ' || SQLERRM;
    
  END CLRHSI_ACTUALIZA_XY;

/*
  ****************************************************************'
  * Nombre SP : CLRHSS_STATUS_CONNECTIVITY
  * Propósito : El SP permite obtener los estados de conectividad de los servicios internet,cable y telefonia de manera masiva y estado de conectividad del EMTA del cliente.
  * Input :  AN_CODCLI   - Numero de SOT
  * Output : AN_ICO_TEL    - 1 Operativo Telefono 0 lo contrario
             AN_ICO_CAB    - 1 Operativo Cable 0 lo contrario
             AN_ICO_INT    - 1 Operativo Internet 0 lo contrario
             AN_STA_AVERIA - Retorna el estado de la averia masiva 4 Error, 1 Correcto,2 Posible Averia, 3 Recien salido de Vaeria masiva
             PO_RESULTADO - Codigo resultado
             PO_MSGERR    - Mensaje resultado
  * Creado por : Alex Salome
  * Fec Creación : 09/09/2019
  * Fec Actualización : --
  ****************************************************************
  */

  PROCEDURE CLRHSS_STATUS_CONNECTIVITY(PI_CODSOT   IN NUMBER,
                                       PO_STATUS_SERVICES  OUT T_CURSOR,
                                       PO_RESULTADO OUT NUMBER,
                                       PO_MSGERR    OUT VARCHAR2) IS

    V_IDPLANO      VARCHAR2(100);
    V_NOT_FOUND_IDPLANO EXCEPTION; 
           
  BEGIN
  
   SELECT DISTINCT  v.idplano INTO V_IDPLANO FROM solotpto sp, inssrv i, vtasuccli v
    WHERE sp.codsolot=PI_CODSOT
    AND sp.codinssrv=i.codinssrv
    AND i.codsuc=v.codsuc;
  
     IF V_IDPLANO IS NULL THEN
       RAISE V_NOT_FOUND_IDPLANO;
     END IF;
  
  OPEN PO_STATUS_SERVICES FOR 
  SELECT DISTINCT F.V_FAILSERVICE,F.V_FAILDETAIL,F.I_FAILWORKTYPE,F.I_FAILSTATE,D_FAILINIDAT,D_FAILFINDAT
    FROM USRSICES.SICET_FAILURELOCATION L,USRSICES.SICET_FAILURE F
   WHERE L.I_FAILID = F.I_FAILID
     AND L.V_FALOIDPLAN LIKE V_IDPLANO
     AND F.I_FAILSTATE = 1 AND F.I_FAILWORKTYPE IN (1,4, 5, 6) 
     AND (F.D_FAILFINDAT IS NULL OR F.D_FAILFINDAT < SYSDATE );
       
   PO_RESULTADO := 0;
   PO_MSGERR    := 'CONSULTA SATISFACTORIA';
    
  EXCEPTION
     WHEN V_NOT_FOUND_IDPLANO THEN
      PO_RESULTADO := -1;
      PO_MSGERR    := 'NO TIENE ID DE PLANO ';
    WHEN NO_DATA_FOUND THEN
      PO_RESULTADO := -1;
      PO_MSGERR    := 'NO EXISTE DATA PARA EL IDSOT: ' || PI_CODSOT;
    WHEN OTHERS THEN
      PO_RESULTADO := -1;
      PO_MSGERR    := 'ERROR : ' || TO_CHAR(SQLCODE) || ' ' || SQLERRM;
      
  END;
  
  /*
  ****************************************************************'
  * Nombre SP : CLRHSS_CONSULTA_CINTILLO
  * Propósito : El SP permite obtener el cintillo para HFC. Obtiene 
              cintillo, fat y borne para FTTH.
  * Input :  PI_NRO_SOT   - Numero de SOT
             PI_CODCLI    - Codigo de cliente
  * Output : PO_CINTILLO  - HFC: Cintillo / FTTH: Cintillo
             PO_BORNE     - FTTH: Borne
             PO_FAT       - FTTH: FAT
             PO_RESULTADO - Codigo resultado
             PO_MSGERR    - Mensaje resultado
  * Creado por : Anthony Moreno
  * Fec Creación : 12/09/2019
  * Fec Actualización : 15/01/2020
  ****************************************************************
  */
  
PROCEDURE CLRHSS_CONSULTA_CINTILLO(PI_NRO_SOT      IN NUMBER,
                                   PI_CODCLI       IN VARCHAR2,
                                   PO_CINTILLO     OUT VARCHAR2, -- cintillo hfc/ftth
                                   PO_BORNE        OUT VARCHAR2, -- borne ftth
                                   PO_FAT          OUT VARCHAR2, -- tap ftth
                                   PO_RESULTADO    OUT INTEGER,
                                   PO_MSGERR       OUT VARCHAR2)IS
  V_CINTILLO VARCHAR(15);
  V_CODCLI   VARCHAR(15);
  V_TECNOLOGIA NUMBER;
  V_TIPTRA NUMBER;
  V_TAP VARCHAR(15);
  V_BORNE VARCHAR(15);
  V_EXISTE NUMBER;
  BEGIN
    V_CINTILLO:='';
	  V_TAP:='';
    V_BORNE:='';
    
	IF PI_CODCLI IS NULL OR PI_CODCLI = '' THEN
		SELECT CODCLI INTO V_CODCLI FROM SOLOT
		WHERE CODSOLOT = PI_NRO_SOT;
	ELSE
		V_CODCLI := PI_CODCLI;
	END IF;
  
  SELECT TIPTRA INTO V_TIPTRA FROM SOLOT WHERE CODSOLOT = PI_NRO_SOT;
  
   SELECT to_number(b.descripcion)
     INTO V_TECNOLOGIA
     FROM tipopedd a, opedd b, tiptrabajo c
    WHERE a.tipopedd = b.tipopedd
      AND b.codigon = c.tiptra
      AND a.abrev = 'ESCXTIPTRAXTECNOLOGIA'
      AND c.tiptra = V_TIPTRA;
      
    IF V_TECNOLOGIA = 1 or V_TECNOLOGIA = 2 THEN --CONSULTA CINTILLO HFC
    
      SELECT DISTINCT a.cintillo
       INTO V_CINTILLO
       FROM operacion.agendamiento a
      WHERE a.codsolot = PI_NRO_SOT
        AND a.codcli = V_CODCLI;

      IF V_CINTILLO IS NULL THEN
        PO_CINTILLO:='';
      ELSE
        PO_CINTILLO := V_CINTILLO;
      END IF;
      
    END IF;
    
    IF  V_TECNOLOGIA = 2 THEN --CONSULTA TAP Y BORNE FTTH
    
    SELECT count(d.codcli)
       INTO V_EXISTE
       FROM solot a, solotpto b, inssrv c, vtasuccli d
     WHERE a.codsolot = b.codsolot
       AND b.codinssrv = c.codinssrv
       AND c.codsuc = d.codsuc
       AND d.codcli = V_CODCLI
       AND a.codsolot = PI_NRO_SOT;
    
    IF V_EXISTE > 0 THEN
      SELECT DISTINCT  d.tap, d.borne_ftth
       INTO V_TAP, V_BORNE
       FROM solot a, solotpto b, inssrv c, vtasuccli d
     WHERE a.codsolot = b.codsolot
       AND b.codinssrv = c.codinssrv
       AND c.codsuc = d.codsuc
       AND d.codcli = V_CODCLI
       AND a.codsolot = PI_NRO_SOT;
    ELSE
      V_TAP := NULL;
      V_BORNE := NULL;
    END IF;
    
      IF V_TAP IS NULL THEN
        PO_FAT:='';
      ELSE
        PO_FAT := V_TAP; 
      END IF;
      
      IF V_BORNE IS NULL THEN
        PO_BORNE :='';
      ELSE
        PO_BORNE :=V_BORNE;
      END IF;
   
    END IF;
    
    PO_RESULTADO := 0;
    PO_MSGERR    := 'CONSULTA SATISFACTORIA';
    
  exception
    when others then
      PO_RESULTADO := 1;
      PO_MSGERR    := 'ERROR AL CONSULTAR';
      
END CLRHSS_CONSULTA_CINTILLO;

/*
  ****************************************************************'
  * Nombre SP : CLRHSU_ACTUALIZA_CINTILLO
  * Propósito : El SP permite actualizar el cintillo para HFC.
               Actualiza cintillo fat y borne para FTTH.
  * Input :  PI_NRO_SOT   - Numero de SOT
             PI_CODCLI    - Codigo de cliente
             PI_CINTILLO  - Cintillo hfc/ftth
             PI_BORNE     - FTTH: Borne
             PI_FAT       - FTTH: FAT
  * Output : PO_RESULTADO - Codigo resultado
             PO_MSGERR    - Mensaje resultado
  * Creado por : Anthony Moreno
  * Fec Creación : 12/09/2019
  * Fec Actualización : 15/01/2020
  ****************************************************************
  */
 
PROCEDURE CLRHSU_ACTUALIZA_CINTILLO(  PI_NRO_SOT      IN NUMBER,
                                      PI_CODCLI       IN VARCHAR2, 
                                      PI_CINTILLO     IN VARCHAR2, -- cintillo hfc / ftth 
                                      PI_BORNE        IN VARCHAR2, -- borne ftth 
                                      PI_FAT          IN VARCHAR2, -- tap ftth 
                                      PO_RESULTADO    OUT INTEGER,
                                      PO_MSGERR       OUT VARCHAR2)IS
  V_CINTILLO VARCHAR(15);
  V_CODCLI   VARCHAR(15);
  V_TECNOLOGIA NUMBER; 
  V_TIPTRA NUMBER; 
  V_CODSUC NUMBER; 
  V_EXISTE NUMBER;
  
  BEGIN

    PO_RESULTADO := 1;
    PO_MSGERR    := 'ERROR AL ACTUALIZAR';
    
    SELECT CODCLI INTO V_CODCLI FROM SOLOT
    WHERE CODSOLOT = PI_NRO_SOT;
    
    SELECT TIPTRA INTO V_TIPTRA FROM SOLOT WHERE CODSOLOT = PI_NRO_SOT;
    
    SELECT to_number(b.descripcion)
       INTO V_TECNOLOGIA
       FROM tipopedd a, opedd b, tiptrabajo c
      WHERE a.tipopedd = b.tipopedd
        AND b.codigon = c.tiptra
        AND a.abrev = 'ESCXTIPTRAXTECNOLOGIA'
        AND c.tiptra = V_TIPTRA;

    IF V_TECNOLOGIA = 1 or V_TECNOLOGIA =2 THEN 
      
      -- Validar si existe sot y cliente
      SELECT count(1) INTO V_CINTILLO
      FROM operacion.agendamiento a
      WHERE a.codsolot=PI_NRO_SOT
      AND a.codcli=V_CODCLI;

      IF V_CINTILLO = 0 THEN
        PO_RESULTADO := 3;
        PO_MSGERR    := 'NUMERO SOT O CODIGO CLIENTE NO EXISTEN';
        RETURN;
      END IF;
    
      -- ACTUALIZAR CINTILLO HFC / FTTH
        UPDATE operacion.agendamiento a
        SET a.cintillo = PI_CINTILLO
        WHERE a.codsolot = PI_NRO_SOT and a.codcli = V_CODCLI;
      
       PO_RESULTADO := 0;
       PO_MSGERR    := 'SE ACTUALIZO CON EXITO';
       
     END IF;
     
     IF  V_TECNOLOGIA = 2 THEN 
       
     -- VALIDAR EXISTE SUCURSAL CLIENTE
      SELECT count(d.codcli)
       INTO V_EXISTE
       FROM solot a, solotpto b, inssrv c, vtasuccli d
     WHERE a.codsolot = b.codsolot
       AND b.codinssrv = c.codinssrv
       AND c.codsuc = d.codsuc
       AND d.codcli = V_CODCLI
       AND a.codsolot = PI_NRO_SOT;
       
       IF V_EXISTE > 0 THEN
         
          -- HALLAR CODSUC
        SELECT DISTINCT d.CODSUC
         INTO V_CODSUC
         FROM solot a, solotpto b, inssrv c, vtasuccli d
       WHERE a.codsolot = b.codsolot
         AND b.codinssrv = c.codinssrv
         AND c.codsuc = d.codsuc
         AND d.codcli = V_CODCLI
         AND a.codsolot = PI_NRO_SOT;
       
          -- ACTUALIZAR FAT Y BORNE FTTH
          UPDATE VTASUCCLI
          SET TAP = PI_FAT , BORNE_FTTH = PI_BORNE
          WHERE codcli = V_CODCLI
          AND CODSUC=V_CODSUC;
          
          PO_RESULTADO := 0;
          PO_MSGERR    := 'SE ACTUALIZO CON EXITO';
          
        END IF;
       END IF;
    
  exception
    when others then
      PO_RESULTADO := 1;
      PO_MSGERR    := 'ERROR AL ACTUALIZAR';
      
 END CLRHSU_ACTUALIZA_CINTILLO;
 
 
  /*
  ****************************************************************'
  * Nombre SP : CLRHSS_VISITA_TECNICA
  * Propósito : El SP permite consultas las visitas tecnicas.
  * Input :  PI_NRO_SOT - Numero de SOT
             PI_CANT_DIAS - Cantidad de dias             
  * Output : PO_CURSOR  - Cursor de visitas tecnicas
             PO_RESULTADO - Codigo de respuesta
             PO_MSGERR    - Mensaje de respuesta
  * Creado por : Jefferson Ore
  * Fec Creación : 24/09/2019
  * Fec Actualización : --
  ****************************************************************
  */  
  PROCEDURE CLRHSS_VISITA_TECNICA(PI_NRO_SOT     IN NUMBER,                                    
                                   PI_CANT_DIAS   IN NUMBER,
                                   PO_CURSOR      OUT SYS_REFCURSOR,
                                   PO_RESULTADO   OUT INTEGER,
                                   PO_MSGERR      OUT VARCHAR2) IS
    lv_cliente    operacion.agendamiento.codcli%type;
    lv_sucursal   operacion.agendamiento.codsuc%type;
   BEGIN
     PO_RESULTADO := 0;
     PO_MSGERR    := 'OPERACION EXITOSA';
     BEGIN
       select distinct codcli, codsuc
        into lv_cliente, lv_sucursal 
        from operacion.agendamiento
       where codsolot = PI_NRO_SOT;
       EXCEPTION
      WHEN NO_DATA_FOUND THEN
        PO_RESULTADO := -1;
        PO_MSGERR    := '[OPERACION.PKG_APP_INSTALADOR.CLRHSS_VISITA_TECNICA] SOT NO EXISTE';
     END;
     
     OPEN PO_CURSOR FOR
     SELECT distinct s.codsolot,       
       to_char(s.fecini,'DD/MM/YYYY') fecha_inicio,               
       to_char(s.fecfin,'DD/MM/YYYY') fecha_fin,
       tt.descripcion,
       M.DESCRIPCION MOT_GENERACION,     
       NVL(SE.descripcion,EST.DESCRIPCION) MOT_SOLUCION
      FROM operacion.solot s
      INNER JOIN operacion.tiptrabajo tt
        ON s.tiptra = tt.tiptra
        AND s.CODCLI=lv_cliente--codigo de cliente
        AND S.TIPTRA IN (407,480,489,610,671,770)
        AND S.ESTSOL IN (12,17,29)
      INNER JOIN estsol e
        ON s.estsol = e.estsol
      INNER JOIN operacion.solotpto pto
        ON s.codsolot = pto.codsolot
      INNER JOIN operacion.inssrv ins
        ON pto.codinssrv = ins.codinssrv
        AND ins.codsuc = lv_sucursal--codigo de sucursal
      INNER JOIN operacion.agendamiento  AG
        ON s.codsolot = AG.codsolot 
      INNER JOIN operacion.estagenda EST
        ON AG.ESTAGE = EST.ESTAGE
      LEFT JOIN OPERACION.MOTOT M
       ON S.CODMOTOT = M.CODMOTOT
      LEFT JOIN (SELECT se.codincidence, ms.descripcion
                  FROM incidence_sequence se
                 INNER JOIN mot_solucion ms
                    ON se.codmot_solucion = ms.codmot_solucion) SE
       ON S.recosi = se.codincidence
       WHERE s.fecini >= sysdate - PI_CANT_DIAS
       and s.fecini <= sysdate;  
    EXCEPTION          
    WHEN OTHERS THEN
      PO_RESULTADO := -99;
      PO_MSGERR    := '[OPERACION.PKG_APP_INSTALADOR.CLRHSS_VISITA_TECNICA] - ERROR: ' || TO_CHAR(SQLCODE) || ' ' || SQLERRM;     
   END ; 

PROCEDURE CLRHSS_CONSULTA_MANT_PROBLEMA(PI_NRO_SOT        IN NUMBER,
                                      PO_DES_PRO      OUT VARCHAR2,
                                      PO_RESULTADO      OUT INTEGER,
                                      PO_MSGERR         OUT VARCHAR2) IS
  BEGIN
        select m.descripcion INTO PO_DES_PRO from solot s
        left join operacion.motot m on s.codmotot = m.codmotot
        where s.codsolot = PI_NRO_SOT;
    PO_RESULTADO := 0;
    PO_MSGERR    := 'CONSULTA SATISFACTORIA';
  exception
    when others then
      PO_RESULTADO := 1;
      PO_MSGERR    := 'ERROR AL CONSULTAR';
END CLRHSS_CONSULTA_MANT_PROBLEMA;


 /*
****************************************************************'
* Nombre SP : SP_ACTUALIZAR_CONTADOR
* Propósito : SP QUE ACTUALIZA EL TOTAL DE EQUIPOS INSTALADOS / DESINSTALADOS
* Input :  v_codsolot           - CODIGO SOLOT
* Input :  v_iddet              - ID DEL DETALLE DE RECETA
* Input :  v_accion             - ACCION A REALIZA -> 0 = ACTIVAR / 1 = DESACTIVAR
* Input :  v_serviceid          - NUMERO TELEFONICO
* Output : an_Codigo_Resp       - CODIGO DE RESULTADO ->0 = EXITO / 1 = ERROR 
           av_Mensaje_Resp      - MENSAJE DE RESULTADO -> EXITO / ERROR 
* CREACDO POR : 
* FEC CREACION : 05/08/2019
* FEC ACTUALIZACION : --
****************************************************************
*/    
 
  PROCEDURE SP_ACTUALIZAR_CONTADOR(v_codsolot        VARCHAR2,
                                   v_iddet           NUMBER,                                                                      
                                   v_accion          NUMBER,
                                   v_serviceid       VARCHAR2,
                                   an_Codigo_Resp    OUT NUMBER,
                                   av_Mensaje_Resp   OUT VARCHAR2) IS
  v_cero                    NUMBER:=0;
  v_cant_total              NUMBER;
  v_cant_efect              NUMBER;
  v_contador                NUMBER;
  v_codaction               NUMBER;
  e_error                   EXCEPTION;
  e_error1                  EXCEPTION;
  v_param                   CLOB;
  v_estado_ficha            INTEGER:=0;
  v_escenario               VARCHAR2(50);
  v_customer_id             NUMBER;

  BEGIN

    v_param:='{v_codsolot: '|| v_codsolot  || ' ,v_iddet ' || v_iddet || ' ,v_accion ' || v_accion || ' ,v_serviceid ' || v_serviceid || ' }';--REGLOG - PARAMETROS DE ENTRADA DEL SP 
    
    SELECT codaction, cant_total, cant_efec INTO v_codaction, v_cant_total, v_cant_efect FROM operacion.detcp 
    WHERE codsolot = v_codsolot AND iddet = v_iddet;
    
    SELECT customer_id INTO v_customer_id FROM solot where codsolot=v_codsolot;
    
    IF v_cant_total > v_cero THEN 
        IF v_codaction IN (4,5,6,13) AND v_accion = 1 THEN--quitar y desactivar (internet, telefonia,tv)
          v_escenario:= ' - QUITAR-DESACTIVAR'; -- PARA EL LOG 
          v_contador := v_cant_efect + 1;
            
          IF v_contador >= v_cero AND v_contador <= v_cant_total THEN
            UPDATE operacion.detcp SET cant_efec = v_contador WHERE codsolot = v_codsolot AND iddet = v_iddet;
          ELSE
            RAISE e_error1;
          END IF;

          --Validacion de total y contador para actualizar detalle
          IF v_cant_total = v_contador THEN
             UPDATE operacion.detcp SET idestado = 1 WHERE codsolot = v_codsolot AND iddet = v_iddet;
             v_estado_ficha:=v_No_Activo;--v_Activo;

             SP_ACTUALIZA_DETALLE_CONTADOR(v_codsolot,v_iddet,v_codaction,v_estado_ficha,an_Codigo_Resp,av_Mensaje_Resp);
             --LLAMAR A LOS SP DE ALINEACION Y ACTUALIZAR_NUEVAS_FICHAS
             SP_ALINEAR_SERVICIOS(v_codsolot,v_customer_id,an_Codigo_Resp,av_Mensaje_Resp);
              
             operacion.pq_reglas_cp.SGASU_ACTUALIZA_FICHA_CABLE(v_codsolot,an_Codigo_Resp,av_Mensaje_Resp);
           
           END IF;
           
       ELSIF v_codaction IN (4,5,6,13) AND v_accion = v_cero THEN --quitar y activar (internet, telefonia,tv) 
            v_escenario:= ' - QUITAR-ACTIVAR';  -- PARA EL LOG 
            v_contador := v_cant_efect - 1;
            IF v_contador >= v_cero AND v_contador <= v_cant_total THEN
                UPDATE operacion.detcp SET cant_efec = v_contador, idestado = 4 
                WHERE codsolot = v_codsolot AND iddet = v_iddet;
            ELSE
                an_Codigo_Resp  := -2;
                av_Mensaje_Resp := 'No está dentro de los límites';
              RAISE e_error1;
            END IF; 
              
       ELSIF v_codaction in (1,2,3,12) AND v_accion = 1 THEN --Agregar y desactivar (internet, telefonia,tv)
           v_escenario:= ' - AGREGAR-DESACTIVAR';-- PARA EL LOG 
           IF v_cant_efect > v_cero THEN  
              v_contador :=  v_cant_efect - 1;      
              IF v_contador >= v_cero AND v_contador <= v_cant_total THEN
                UPDATE operacion.detcp SET cant_efec = v_contador,idestado = 4 WHERE codsolot = v_codsolot AND iddet = v_iddet;
                UPDATE operacion.detprovcp SET estado = 4 WHERE iddet = v_iddet AND service_id_new =v_serviceid;
              ELSE
                  an_Codigo_Resp  := -4;
                  av_Mensaje_Resp := 'No está dentro de los límites';
                RAISE e_error1;
              END IF;
              /*IF v_contador = v_cant_total THEN
                UPDATE operacion.detcp SET idestado = 1 WHERE codsolot = v_codsolot AND iddet = v_iddet;
              END IF;*/
           END IF;
       ELSIF v_codaction in (1,2,3,12) AND v_accion = v_cero THEN --Agregar y activar (internet, telefonia,tv)
           v_escenario:= ' - AGREGAR-ACTIVAR';-- PARA EL LOG 
           v_contador := v_cant_efect + 1;
           IF v_contador >= v_cero AND v_contador <= v_cant_total THEN
              UPDATE operacion.detcp SET cant_efec = v_contador WHERE codsolot = v_codsolot AND iddet = v_iddet;
              UPDATE operacion.detprovcp SET estado = 1 WHERE iddet = v_iddet AND service_id_new =v_serviceid;
           ELSE
              an_Codigo_Resp  := -5;
              av_Mensaje_Resp := 'NO ESTA DENTRO DE LOS LIMITES';
              RAISE e_error1;
           END IF; 
           IF v_contador = v_contador THEN
             UPDATE operacion.detcp SET idestado = 1 WHERE codsolot = v_codsolot AND iddet = v_iddet;
             v_estado_ficha:=v_Activo;

             SP_ACTUALIZA_DETALLE_CONTADOR(v_codsolot,v_iddet,v_codaction,v_estado_ficha,an_Codigo_Resp,av_Mensaje_Resp);
             --LLAMAR A LOS SP DE ALINEACION Y ACTUALIZAR_NUEVAS_FICHAS
             SP_ALINEAR_SERVICIOS(v_codsolot,v_customer_id,an_Codigo_Resp,av_Mensaje_Resp);
             operacion.pq_reglas_cp.SGASU_ACTUALIZA_FICHA_CABLE(v_codsolot,an_Codigo_Resp,av_Mensaje_Resp);
           END IF; 
       END IF;
        
     ELSE
       RAISE e_error1;
     END IF;
     OPERACION.PKG_PROV_INCOGNITO.P_REGISTRA_LOG_APK('SP_ACTUALIZAR_CONTADOR'||v_escenario,an_Codigo_Resp,av_Mensaje_Resp,v_param);--REGISTRA_LOG

  EXCEPTION
    WHEN e_error THEN
      /*an_Codigo_Resp  := -1;
      av_Mensaje_Resp := 'ERROR EN [SP_OBTIENE_FICHA_TOTAL]';*/NULL;
    WHEN e_error1 THEN
      an_Codigo_Resp  := -1;
      av_Mensaje_Resp := 'El contador es diferente al Total';
    WHEN OTHERS THEN
      an_Codigo_Resp  := -2;
      av_Mensaje_Resp := SQLERRM;
      OPERACION.PKG_PROV_INCOGNITO.P_REGISTRA_LOG_APK('SP_ACTUALIZAR_CONTADOR'||v_escenario,an_Codigo_Resp,av_Mensaje_Resp,v_param);--REGISTRA_LOG
  END;
  
     /*
****************************************************************'
* Nombre SP : SP_ACTUALIZA_DETALLE_CONTADOR
* Propósito : SP QUE ACTUALIZA EL DETALLE DE LOS EQUIPOS INSTALADOS / DESINSTALADOS
* Input :   v_codsolot           - CODIGO SOLOT
			v_iddet              - ID DEL DETALLE DE RECETA
			v_codaction          - CODIGO DE ACCION
			v_estado_ficha       - ESTADO DE LA FICHA -> 0 = INACTIVO / 1= ACTIVO
* Output :  an_Codigo_Resp       - CODIGO DE RESULTADO ->0 = EXITO / 1 = ERROR 
            av_Mensaje_Resp      - MENSAJE DE RESULTADO -> EXITO / ERROR 
* CREADO POR : 
* FEC CREACION : 05/08/2019
* FEC ACTUALIZACION : --
****************************************************************
*/ 
  
  PROCEDURE SP_ACTUALIZA_DETALLE_CONTADOR(v_codsolot        VARCHAR2,
                                       v_iddet              NUMBER,
                                       v_codaction          NUMBER,                                                                   
                                       v_estado_ficha       NUMBER,--1(Activo),0(Inactivo)
                                       an_Codigo_Resp      OUT NUMBER,
                                       av_Mensaje_Resp     OUT VARCHAR2) IS
  
    CURSOR c_detprovcp IS
            SELECT idseq,CODACTION FROM operacion.detprovcp 
            WHERE iddet = v_iddet AND codaction IN(1,2,3,4,5,6);
    v_TipEquProv             VARCHAR2(50);
    v_AbrevDocu              VARCHAR2(20);
    v_numb                   NUMBER:=0;
    v_numb_v2                NUMBER:=0;
    e_error                  EXCEPTION;
    e_error1                 EXCEPTION;
    v_codsolot_pto           NUMBER;
    v_param                  CLOB;
    v_idficha_desact         FT_INSTDOCUMENTO.IDFICHA%TYPE;
    v_iddoc_des              FT_INSTDOCUMENTO.IDDOCUMENTO%TYPE;
    TYPE c_list              IS VARRAY (15) of FT_INSTDOCUMENTO.IDFICHA%type; 
    arr_idficha_desact       c_list := c_list();
    TYPE tyCur               IS TABLE OF c_detprovcp%ROWTYPE;
    tbCur                    tyCur;
    v_SERVICE_TYPE_OLD       operacion.detprovcp.service_type_old%TYPE;
    v_SERVICE_ID_OLD         operacion.detprovcp.service_id_old%TYPE;
    CURSOR c_idficha_desactivos IS 
         SELECT OPERACION.PKG_PROV_INCOGNITO.F_OBT_TIPO_EQUIPO(a.codigo1) AS tipoequprov,
         IDFICHA,ORDEN, IDDOCUMENTO,IDTABLA, IDLISTA, ETIQUETA, VALORTXT,INSIDCOM  FROM FT_INSTDOCUMENTO a 
         WHERE a.idlista=128/*v_idlista_est*/ AND iddocumento in /*(10,11,12)*/ (
               SELECT CODIGON  FROM tipopedd a,opedd  b 
               WHERE a.TIPOPEDD=b.Tipopedd AND a.abrev=v_cabe_docu_HFC AND b.ABREVIACION = (v_AbrevDocu)
               )
         AND valortxt=v_estado_ficha AND
         a.CODIGO1 IN (SELECT s.PID FROM SOLOTPTO s WHERE s.CODSOLOT=v_codsolot) 
         ORDER BY 1,3;
    
                                   
   BEGIN
     
      v_param:='{v_codsolot: '|| v_codsolot  || ' ,v_iddet ' || v_iddet || ' ,v_codaction ' || v_codaction || ' ,v_codaction ' || v_codaction || ' }';--REGLOG - PARAMETROS DE ENTRADA DEL SP 
  
      SELECT NVL(c.tipo_equ_prov,'EMTA') INTO v_TipEquProv  FROM OPERACION.DETCP c WHERE c.iddet=v_iddet;
      v_TipEquProv:='-';
            
      IF v_codaction=4 OR v_codaction=1 THEN
        v_AbrevDocu:=v_docu_inter;
      ELSIF v_codaction=5 OR v_codaction=2 THEN
        v_AbrevDocu:=v_docu_telef;
      ELSIF v_codaction=6 OR v_codaction=13 OR v_codaction=3 OR v_codaction=12 THEN
        v_AbrevDocu:=v_docu_tv;
      END IF;
  
      FOR C_eq IN c_idficha_desactivos LOOP
          IF C_eq.tipoequprov = v_TipEquProv THEN
            v_numb := v_numb + 1;
            arr_idficha_desact.extend; 
            arr_idficha_desact(v_numb)  := C_eq.IDFICHA;
            --arr_iddocu_desact(v_numb)  := C_eq.IDDOCUMENTO;
            dbms_output.put_line(' Equipmentid('||C_eq.IDFICHA ||'):'||arr_idficha_desact(v_numb) || ' -- ' || C_eq.tipoequprov|| ' -- ' || C_eq.VALORTXT|| ' -- ' || C_eq.IDDOCUMENTO|| ' -- ' || C_eq.INSIDCOM);  
          ELSE
            dbms_output.put_line(' EMTA'); 
          END IF; 
       END LOOP;
                
       OPEN c_detprovcp;
            FETCH c_detprovcp BULK COLLECT INTO tbcur;
       CLOSE c_detprovcp;
                
       IF tbcur.count<>v_numb THEN
          v_numb_v2:=tbcur.count;
          dbms_output.put_line(' LOS TOTALES NO COINCIDEN.');
          RAISE e_error1;
       END IF;
                
       FOR i IN c_detprovcp LOOP
          v_numb_v2 := v_numb_v2 + 1;
          --dbms_output.put_line(' NUM'||v_numb_v2 || ' - ' || arr_idficha_desact(v_numb_v2));
          v_idficha_desact := arr_idficha_desact(v_numb_v2);
                                         
          SELECT DISTINCT IDDOCUMENTO INTO v_iddoc_des FROM FT_INSTDOCUMENTO WHERE 
          IDFICHA=v_idficha_desact AND IDDOCUMENTO IN (
                   SELECT CODIGON  FROM tipopedd a,opedd  b WHERE a.TIPOPEDD=b.Tipopedd 
                   AND a.abrev=v_cabe_docu_HFC AND b.ABREVIACION IN (v_docu_inter,v_docu_telef,v_docu_tv)
          );
                                         
          SELECT valortxt,codigo1 INTO v_SERVICE_TYPE_OLD,v_codsolot_pto FROM FT_INSTDOCUMENTO 
          WHERE iddocumento=v_iddoc_des AND idlista=v_idlista_serviceType AND IDFICHA=v_idficha_desact;
                                         
          SELECT valortxt INTO v_SERVICE_ID_OLD FROM FT_INSTDOCUMENTO 
          WHERE iddocumento=v_iddoc_des AND idlista=v_idlista_SERVICE_ID AND IDFICHA=v_idficha_desact;
                                         
          UPDATE operacion.detprovcp SET FICHA_ORIGEN = v_idficha_desact WHERE iddet = v_iddet AND idseq = i.idseq;
          UPDATE operacion.detprovcp SET SERVICE_ID_OLD = v_SERVICE_ID_OLD WHERE iddet = v_iddet AND idseq = i.idseq;
          UPDATE operacion.detprovcp SET SERVICE_TYPE_OLD = v_SERVICE_TYPE_OLD WHERE iddet = v_iddet AND idseq = i.idseq;
          UPDATE operacion.detprovcp SET CODSOLOT_OLD = v_codsolot_pto WHERE iddet = v_iddet AND idseq = i.idseq;
          UPDATE operacion.detprovcp SET estado = v_Activo WHERE iddet = v_iddet AND idseq = i.idseq;
                            
       END LOOP;
       
       an_Codigo_Resp  := n_exito_CERO;
       av_Mensaje_Resp := av_Mensaje_OK;
       OPERACION.PKG_PROV_INCOGNITO.P_REGISTRA_LOG_APK('SP_ACTUALIZAR_DETALLE_CONTADOR',an_Codigo_Resp,av_Mensaje_Resp,v_param);--REGISTRA_LOG
   
    EXCEPTION
      WHEN e_error THEN
        an_Codigo_Resp  := -1;
        av_Mensaje_Resp := 'ERROR EN [SP_OBTIENE_FICHA_TOTAL';
        OPERACION.PKG_PROV_INCOGNITO.P_REGISTRA_LOG_APK('SP_ACTUALIZAR_DETALLE_CONTADOR',an_Codigo_Resp,av_Mensaje_Resp,v_param);--REGISTRA_LOG
      WHEN e_error1 THEN
        an_Codigo_Resp  := -1;
        av_Mensaje_Resp := 'El contador es diferente al Total';
        OPERACION.PKG_PROV_INCOGNITO.P_REGISTRA_LOG_APK('SP_ACTUALIZAR_DETALLE_CONTADOR',an_Codigo_Resp,av_Mensaje_Resp,v_param);--REGISTRA_LOG
      WHEN OTHERS THEN
          an_Codigo_Resp  := -2;
          av_Mensaje_Resp := SQLERRM;
          OPERACION.PKG_PROV_INCOGNITO.P_REGISTRA_LOG_APK('SP_ACTUALIZAR_DETALLE_CONTADOR',an_Codigo_Resp,av_Mensaje_Resp,v_param);--REGISTRA_LOG
  END;      
  
    /*
****************************************************************'
* Nombre SP : SP_ALINEAR_SERVICIOS
* Propósito : SP QUE ALINEA LOS SERVICIOS LUEGO DE PROCEDER CON LA  INSTALACION / DESINSTALACION DE LOS EQUIPOS
* Input :   an_codsolot          - CODIGO SOLOT
			an_customer_id       - ID DEL CLIENTE
* Output :  an_Codigo_Resp       - CODIGO DE RESULTADO ->0 = EXITO / 1 = ERROR 
			av_Mensaje_Resp      - MENSAJE DE RESULTADO -> EXITO / ERROR 
* CREACDO POR : 
* FEC CREACION : 05/08/2019
* FEC ACTUALIZACION : --
****************************************************************
*/ 
  
procedure SP_ALINEAR_SERVICIOS(an_codsolot           solot.codsolot%type,
                                 an_customer_id        varchar2,
                                 an_Codigo_Resp        out number,
                                 av_Mensaje_Resp       out varchar2) is
    cursor cur_servicios is
      select dpc.iddet, dpc.codaction,dpc.customer_id,
             dpc.codsolot_old, dpc.service_type_old, dpc.service_id_old, dpc.ficha_origen,
             dpc.codsolot_new, dpc.service_type_new, dpc.service_id_new, dpc.ficha_destino,
             dpc.sp_a_consumir
      from  operacion.detcp dc, OPERACION.DETPROVCP dpc
      where dc.iddet = dpc.iddet
      and   dc.codsolot = an_codsolot
      and   dpc.estado = 4 ;--estado no activo
  begin
    for cur_s in cur_servicios loop
      if cur_s.codaction = 14 then--Agregar Paquete Cable
        PKG_PROV_INCOGNITO.SGASS_ACTIVAR_TV_ADIC(cur_s.codsolot_new,
                              an_customer_id,
                              cur_s.service_id_new,
                              null,
                              an_Codigo_Resp,
                              av_Mensaje_Resp);
        if an_Codigo_Resp = n_exito_201 then
           P_ACTUALIZA_ESTADO_DETPROVCP(cur_s.iddet,cur_s.service_id_new,1);
        end if;
      elsif cur_s.codaction in(15,18) then--Quitar Paquete Cable
                                          --Quitar Servicio Adicional Internet
        PKG_PROV_INCOGNITO.SGASS_DESACTIVACION(cur_s.codsolot_old,
                            an_customer_id,
                            cur_s.service_id_old,
                            2,--desactivar servicio
                            null,
                            an_Codigo_Resp,
                            av_Mensaje_Resp);
        if an_Codigo_Resp = n_exito_201 then
           P_ACTUALIZA_ESTADO_DETPROVCP(cur_s.iddet,cur_s.service_id_old,1);
        end if;
      elsif cur_s.codaction in(7,11) then--Cambiar Velocidad Internet
                                         --Cambiar Plan de Canales Cable
        PKG_PROV_INCOGNITO.SGASS_CAMBIO_PLAN(cur_s.codsolot_new,
                          an_customer_id,
                          cur_s.service_id_new,
                          cur_s.service_type_new,
                          null,
                          an_Codigo_Resp,
                          av_Mensaje_Resp);
        if an_Codigo_Resp = n_exito_201 then
           P_ACTUALIZA_ESTADO_DETPROVCP(cur_s.iddet,cur_s.service_id_new,1);
        end if;
      elsif cur_s.codaction = 17 then--Agregar Servicio Adicional Internet
        PKG_PROV_INCOGNITO.SGASS_ACTIVAR_INTERNET_ADIC(cur_s.codsolot_new,
                                    an_customer_id,
                                    cur_s.service_id_new,
                                    null,
                                    an_Codigo_Resp,
                                    av_Mensaje_Resp);
        if an_Codigo_Resp = n_exito_201 then
           P_ACTUALIZA_ESTADO_DETPROVCP(cur_s.iddet,cur_s.service_id_new,1);
        end if;
      end if;
    end loop;
  end;

    /*
****************************************************************'
* Nombre SP : P_ACTUALIZA_ESTADO_DETPROVCP
* Propósito : SP QUE ACTULICE EL ESTADO DE LA TABLA DETALLE CAMBIO DE PLAN
* Input :   an_iddet          - CODIGO SOLOT
			av_service_id       - ID DEL CLIENTE
			an_estado
* CREADO POR : 
* FEC CREACION : 05/08/2019
* FEC ACTUALIZACION : --
****************************************************************
*/ 
 
procedure P_ACTUALIZA_ESTADO_DETPROVCP(an_iddet           number,
                                         av_service_id      varchar2,
                                         an_estado          number) IS
    PRAGMA AUTONOMOUS_TRANSACTION;
  begin
  
    update OPERACION.DETPROVCP
    set    estado = an_estado
    where  iddet = an_iddet
    and    (service_id_new = av_service_id
           or service_id_old = av_service_id);
    commit;
  
  end;   

								 
/*
 ****************************************************************'
* Nombre SP : CLRHSI_REGIS_AGENDA
* Propósito : El SP permite insertar en la tabla agendamientochgest en 
			  caso de activacion de equipos (altas) y cambio de equipo 
			  registrando la MAC, Modelo, Serie, UA del equipo.
* Input :  PI_NRO_SOT		  - Numero idagenda
           PI_TIPO        - Tipo 1:Instalacion / 2:Cambio de Equipo
		       PI_OBSERVACION	- Campo observacion
* Output : PO_RESULTADO 	- Codigo resultado
           PO_MSGERR   		- Mensaje resultado
* Creado por : Wendy Tamayo
* Fec Creación : 28/11/2019
* Fec Actualización : --
****************************************************************
*/ 

PROCEDURE CLRHSI_REGIS_AGENDA 	(PI_IDAGENDA     IN NUMBER,
                                 PI_TIPO         IN NUMBER,                
                                 PI_OBSERVACION  IN VARCHAR2,
                                 PO_RESULTADO    OUT INTEGER,
                                 PO_MSGERR       OUT VARCHAR2) IS			

V_TIPO NUMBER :=1;
V_ESTADO NUMBER :=108;
V_OBSERVACION operacion.agendamientochgest.observacion%type;
V_DATO VARCHAR2(400);
V_LETRA VARCHAR2(1);
V_POSICION NUMBER;
V_OBS VARCHAR2(400);
v_idestado_adc number:=2;
V_FECHAEJECUTADO DATE:=SYSDATE;

Cursor C_PARAMETRO is
  SELECT d.descripcion
    FROM tipopedd c, opedd d
  WHERE c.tipopedd = d.tipopedd
    AND C.abrev = 'APPI'
    AND d.codigon_aux = PI_TIPO;

BEGIN

     For c1 in C_PARAMETRO loop
     
       V_DATO     := c1.descripcion;
       V_LETRA    := SUBSTR(V_DATO, 1, 1);
       V_POSICION := INSTR(PI_OBSERVACION, ';');
     
       if PI_TIPO = 1 then
    
         IF V_LETRA = 'A' THEN
           V_OBSERVACION := V_OBSERVACION || c1.descripcion ||
                            PI_OBSERVACION || CHR(13);
         ELSE
           V_OBSERVACION := V_OBSERVACION || c1.descripcion || CHR(13);
         end if;
       ELSE
       
         IF V_LETRA = 'R' THEN
           V_OBS         := SUBSTR(PI_OBSERVACION, 1, V_POSICION - 1);
           V_OBSERVACION := V_OBSERVACION || c1.descripcion || V_OBS ||
                            CHR(13);
         
         ELSE
           IF V_LETRA = 'A' THEN
             V_OBS         := SUBSTR(PI_OBSERVACION, V_POSICION + 1, 100);
             V_OBSERVACION := V_OBSERVACION || c1.descripcion || V_OBS ||
                              CHR(13);
           
           ELSE
             V_OBSERVACION := V_OBSERVACION || c1.descripcion || CHR(13);
           end if;
         end if;
       end if;
       
      end loop;
      
      Begin
        
        INSERT INTO AGENDAMIENTOCHGEST
            (idagenda,
             tipo,
             estado,
             observacion,
             FECHAEJECUTADO,
             idestado_adc) 
          VALUES
            (PI_IDAGENDA,
             V_TIPO,
             V_ESTADO,
             V_OBSERVACION, 
             V_FECHAEJECUTADO,
             v_idestado_adc); 
             
            PO_RESULTADO := 0;
            PO_MSGERR  := 'OPERACION EXITOSA';
      EXCEPTION  
         WHEN OTHERS THEN  
              PO_RESULTADO := 1;
              PO_MSGERR := $$plsql_unit || '.' || 'CLRHSI_REGIS_AGENDA: ' || sqlerrm ||
                      ' - Linea ('|| dbms_utility.format_error_backtrace ||')';
              RAISE_APPLICATION_ERROR(-20000, 
                                $$PLSQL_UNIT || '.' || 'CLRHSI_REGIS_AGENDA' || SQLERRM); 
      END;         
  
exception
    when others then
      PO_RESULTADO := 1;
      PO_MSGERR    := 'ERROR NO EXISTE INFORMACION';
      
  END CLRHSI_REGIS_AGENDA;

/*
 ****************************************************************'
* Nombre SP : CLRHSS_MOT_SOLUCION
* Propósito : Permite traer la lista de soluciones para ser 
		          seleccionado por el tecnico a traves de la app 
			        instalador, para el flujo de Mantenimiento. 
* Input:   PI_IDAGENDA    - Numero de id agenda
* Output : PO_CURSOR      - Lista de Motivos
		   PO_RESULTADO   - Codigo resultado
           PO_MSGERR   	  - Mensaje resultado
* Creado por : Wendy Tamayo
* Fec Creación : 26/11/2019
* Fec Actualización : --
****************************************************************
*/ 

Procedure CLRHSS_MOT_SOLUCION(PI_IDAGENDA     IN NUMBER,
                              PO_CURSOR       OUT T_CURSOR,
                              PO_RESULTADO    OUT INTEGER,
                              PO_MSGERR       OUT VARCHAR2) IS

v_tiptra    NUMBER;
v_codsolot  operacion.solot.codsolot%type;

BEGIN
  select codsolot
  into v_codsolot
  from agendamiento
  where idagenda = PI_IDAGENDA;
  
  SELECT TIPTRA
  INTO v_tiptra
   FROM SOLOT
   WHERE CODSOLOT=v_codsolot;
  
  
  OPEN PO_CURSOR FOR
        select mt.codmot_solucion, mt.descripcion
        from mot_solucion                 mt,
             mot_solucionxtiptra          st,
             operacion.mot_solucion_grupo mg,
             usuarioope                   usr
      where mt.codmot_solucion = st.codmot_solucion
         and mt.codmot_grupo = mg.codmot_grupo
         and ((usr.codcon is null) or
             (((usr.codcon is not null and st.aplica_contrata = 1) and
             (not
              (select area from agendamiento where idagenda = PI_IDAGENDA) = 343)) or
             ((usr.codcon is not null and st.aplica_pext = 1) and
             ((select area from agendamiento where idagenda = PI_IDAGENDA) = 343))))
         and usr.usuario = user
         AND mt.codmot_grupo IS NOT NULL
		 and mt.estado = 1
         and st.tiptra  = v_tiptra       
       order by mt.descripcion;
 
      PO_RESULTADO := 0;
      PO_MSGERR  := 'OPERACION EXITOSA';
  
  exception
    when others then
      PO_RESULTADO := 1;
      PO_MSGERR    := 'ERROR AL CONSULTAR';
      
END CLRHSS_MOT_SOLUCION;
 
/*
 ****************************************************************'
* Nombre SP : CLRHSU_GUARDAR_MOTSOLUCION
* Propósito : Permite guardar el motivo solucion por el tecnico 
              a traves de la app instalador, para el flujo de 
              Mantenimiento. 
* Input:   PI_IDAGENDA    - Numero de id agenda
           PI_MOT_SOL     - codigo de motivo solucion
           PI_OBSERVACION - campo observacion           
* Output : PO_RESULTADO 	- Codigo resultado
           PO_MSGERR   		- Mensaje resultado
* Creado por : Wendy Tamayo
* Fec Creación : 29/11/2019
* Fec Actualización : --
****************************************************************
*/ 

Procedure CLRHSU_GUARDAR_MOTSOLUCION (PI_IDAGENDA     IN NUMBER,
                                     	PI_MOT_SOL      IN NUMBER,
                                      PI_OBSERVACION  IN VARCHAR2,
                                      PO_RESULTADO    OUT INTEGER,
                                      PO_MSGERR       OUT VARCHAR2) is 
 

  v_estagenda_old NUMBER; 
  v_estagenda number:=86; 
  v_cadena_mot varchar2(400);  
  v_fecha date:= SYSDATE ;  
  ls_username varchar2(50);
  v_insercion varchar2(10);
  v_msg_text  varchar2(100);  
                         
BEGIN

  SELECT ESTAGE
    INTO v_estagenda_old
    FROM AGENDAMIENTO
   WHERE IDAGENDA = PI_IDAGENDA;

   v_cadena_mot := TO_CHAR(PI_MOT_SOL) || ',N,N,N,N,N,N,N';
     
   OPERACION.PQ_AGENDAMIENTO.P_CHG_EST_AGENDAMIENTO (PI_IDAGENDA,
                                                     v_estagenda,
                                                     v_estagenda_old,
                                                     PI_OBSERVACION,
                                                     PI_MOT_SOL,
                                                     v_fecha,
                                                     v_cadena_mot); 
                                                   
         
   SELECT SYS_CONTEXT ('USERENV', 'OS_USER') into ls_username FROM dual;
   
	 OPERACION.PQ_AGENDAMIENTO.SGASS_ACT_ESTDO_RECL(PI_IDAGENDA, 
                                                  ls_username,
                                                  v_estagenda_old,
                                                  v_estagenda,
                                                  v_insercion,
                                                  v_msg_text);
                                                  
                                                
   PO_RESULTADO := 0;
   PO_MSGERR  := 'OPERACION EXITOSA';
  exception
    when others then
      PO_RESULTADO := 1;
      PO_MSGERR    := 'ERROR AL GUARDAR';  

END CLRHSU_GUARDAR_MOTSOLUCION;

/*
 ****************************************************************'
* Nombre SP : SP_APP_LOG_AUDIT
* Propósito : Permite guardar las transacciones de error del app instalador, 
			        Auditoria
* Input:   p_evento     - Transacción que se realiza, breve descripcion
           p_codusu     - codigo de usuario (DNI del tecnico)
           p_nomusu     - Nombre del usuario (tecnico)
           p_url	    - url del servicio ejecutado   
           p_variable   - Variables, codigos del body  
           p_msgrpta    - Mensaje de Respuesta: ERRORES   
* Output : PO_RESULTADO - Codigo resultado
           PO_MSGERR   	- Mensaje resultado
* Creado por : Cesar Rengifo
* Fec Creación : 23/12/2019
* Fec Actualización : --
****************************************************************
*/

 PROCEDURE SP_APP_LOG_AUDIT(p_evento      IN AUDITORIA.APP_LOG_AUDIT.logv_evento%type,
                            p_codusu      IN AUDITORIA.APP_LOG_AUDIT.logv_codusu%type,
                            p_nomusu      IN AUDITORIA.APP_LOG_AUDIT.logv_nomusu%type,
                            p_url         IN AUDITORIA.APP_LOG_AUDIT.logv_url%type,
                            p_variable    IN AUDITORIA.APP_LOG_AUDIT.logc_variable%type,
                            p_msgrpta     IN AUDITORIA.APP_LOG_AUDIT.logv_msgrpta%type,
                            PO_RESULTADO  OUT INTEGER,
                            PO_MSGERR     OUT VARCHAR2 ) is
    
  l_log AUDITORIA.APP_LOG_AUDIT%ROWTYPE;
  
  BEGIN
    
    l_log.logv_evento      := p_evento;
    l_log.logv_codusu      := p_codusu;
    l_log.logv_nomusu      := p_nomusu;
    l_log.logv_origenip    := SYS_CONTEXT('USERENV', 'IP_ADDRESS');
    l_log.logv_origenhost  := SYS_CONTEXT('USERENV', 'HOST');
    l_log.logv_sousu       := SYS_CONTEXT('USERENV', 'OS_USER');
    l_log.logd_fecusu      := SYSDATE;
    l_log.logv_destinoip   := '';
    l_log.logv_destinohost := SYS_CONTEXT('USERENV', 'SERVER_HOST');
    l_log.logv_modulo      := 'APP INSTALADOR';
    l_log.logv_url         := p_url;
    l_log.logc_variable    := p_variable;
    l_log.logv_msgrpta     := p_msgrpta;
    
    INSERT INTO AUDITORIA.APP_LOG_AUDIT VALUES l_log; 

     PO_RESULTADO := 0;
     PO_MSGERR  := 'OPERACION EXITOSA';
            
    EXCEPTION
    WHEN OTHERS THEN
    ROLLBACK;
    PO_RESULTADO := 1;
    PO_MSGERR := $$plsql_unit || '.' || 'SP_APP_LOG_AUDIT: ' || sqlerrm ||
                ' - Linea ('|| dbms_utility.format_error_backtrace ||')';
    RAISE_APPLICATION_ERROR(-20000, 
                     $$PLSQL_UNIT || '.' || 'SP_APP_LOG_AUDIT' || SQLERRM); 
                
END SP_APP_LOG_AUDIT;         

/*
 ****************************************************************'
* Nombre SP : CLRHSS_ESTADO_ADCTOA
* Propósito : Permite traer la lista de estados para el cierre 
		          de la orden de trabajo Iniciada en el TOA
* Output : PO_CURSOR      - Lista de Estado
		       PO_RESULTADO 	- Codigo resultado
           PO_MSGERR   		- Mensaje resultado
* Creado por : Cesar Rengifo
* Fec Creación : 08/01/2020
* Fec Actualización : --
****************************************************************
*/ 

Procedure CLRHSS_ESTADO_ADCTOA(PO_CURSOR       OUT T_CURSOR,
                              PO_RESULTADO    OUT INTEGER,
                              PO_MSGERR       OUT VARCHAR2) IS
 

BEGIN
  
  OPEN PO_CURSOR FOR
       SELECT ID_ESTADO,DESC_CORTA
       FROM OPERACION.ESTADO_ADC 
        WHERE ESTADO = 1  AND 
        ID_ESTADO  NOT IN (1,2,6);

      PO_RESULTADO := 0;
      PO_MSGERR  := 'OPERACION EXITOSA';
  
  exception
    when others then
      PO_RESULTADO := 1;
      PO_MSGERR    := 'ERROR AL CONSULTAR';
      
END CLRHSS_ESTADO_ADCTOA; 

/*
 ****************************************************************'
* Nombre SP : CLRHSS_RAZON_ADCTOA
* Propósito : Permite traer la lista de razones de quiebre, para 
              ser elegido por el tecnico para el cierre de la orden
* Input:   PI_NRO_SOT      - Numero de SOT
           PI_IDESTADO_ADC - Codigo de estado de cierre de TOA                           
* Output : PO_CURSOR       - Lista de Razones de quiebre TOA
		       PO_RESULTADO 	 - Codigo resultado
           PO_MSGERR   		 - Mensaje resultado
* Creado por : Cesar Rengifo
* Fec Creación : 08/01/2020
* Fec Actualización : --
****************************************************************
*/ 

Procedure CLRHSS_RAZON_ADCTOA(PI_NRO_SOT      IN NUMBER,
                              PI_IDESTADO_ADC IN NUMBER,
                              PO_CURSOR       OUT T_CURSOR,
                              PO_RESULTADO    OUT INTEGER,
                              PO_MSGERR       OUT VARCHAR2) IS
                              
  v_id_tipo_orden NUMBER;

BEGIN
   
   SELECT t.id_tipo_orden
     INTO v_id_tipo_orden
     FROM TIPTRABAJO t, SOLOT s
    WHERE t.tiptra = s.tiptra
      and s.codsolot = PI_NRO_SOT;

  OPEN PO_CURSOR FOR
    select m.idmotivo_sga_destino,
           decode(m.idmotivo_sga_destino,0,'TODOS',
                  (select mte.descripcion
                     from operacion.mot_solucion mte
                    where m.idmotivo_sga_destino = mte.codmot_solucion(+))) as dmotivo_eta,
           (select NVL(tod.cod_tipo_orden, 0)
              from operacion.tipo_orden_adc tod
             where m.id_tipo_orden = tod.id_tipo_orden(+)) as cod_tipo_orden
      from operacion.estado_motivo_sga_adc    m,
           operacion.TIPO_ORDEN_ADC t
     WHERE m.id_tipo_orden = t.id_tipo_orden
       AND t.flg_tipo = 1 -- 1 MAsivo
       AND m.estado = 1 -- 1 Activo  0 Inactivo 
       AND m.idestado_adc_destino = PI_IDESTADO_ADC -- codigo de cierre
       AND m.id_tipo_orden = v_id_tipo_orden; -- tipo de orden por tipo de trabajo

  PO_RESULTADO := 0;
  PO_MSGERR    := 'OPERACION EXITOSA';

exception
  when others then
    PO_RESULTADO := 1;
    PO_MSGERR    := 'ERROR AL CONSULTAR';
  
END CLRHSS_RAZON_ADCTOA;

/*
 ****************************************************************'
* Nombre SP : CLRHSI_REG_CODIVR
* Propósito : Permite Grabar Codigo IVR en el SGA
* Input:   PI_IDAGENDA    - Id Agenda
           PI_CODIVR      - Codigo IVR
* Output : PO_RESULTADO 	- Codigo resultado
           PO_MSGERR   		- Mensaje resultado
* Creado por : Cesar REngifo
* Fec Creación : 23/01/2020
* Fec Actualización : --
****************************************************************
*/                                
PROCEDURE CLRHSI_REG_CODIVR  (PI_IDAGENDA     IN NUMBER,
                              PI_CODIVR       IN NUMBER,
                              PO_RESULTADO    OUT INTEGER,
                              PO_MSGERR       OUT VARCHAR2) IS
                              
V_TIPO NUMBER   := 1;
V_ESTADO NUMBER := 13; --- Pendiente de validar
V_OBSERVACION   varchar2(100) := 'REGISTRO DE Nº IVR : ' || PI_CODIVR;
V_FECHAEJECUTADO DATE:=SYSDATE;
v_estagenda NUMBER:=86; -- Atendido - No validado (agenda)
v_estagenda_old NUMBER  ;

Begin
select estage
  into v_estagenda_old
  from agendamiento
 where idagenda = PI_IDAGENDA;

  INSERT INTO AGENDAMIENTOCHGEST
    (idagenda, tipo, estado, observacion, FECHAEJECUTADO)
  VALUES
    (PI_IDAGENDA,
     V_TIPO,
     V_ESTADO,
     V_OBSERVACION,
     V_FECHAEJECUTADO);

     OPERACION.PQ_AGENDAMIENTO.P_CHG_EST_AGENDAMIENTO (PI_IDAGENDA,
                                                       v_estagenda,
                                                       v_estagenda_old,
                                                       V_OBSERVACION,
                                                       0,
                                                       V_FECHAEJECUTADO,
                                                       '');  
                                                       
  PO_RESULTADO := 0;
  PO_MSGERR    := 'OPERACION EXITOSA';
EXCEPTION
  WHEN OTHERS THEN
    PO_RESULTADO := 1;
    PO_MSGERR    := $$plsql_unit || '.' || 'CLRHSI_REG_CODIVR: ' || sqlerrm ||
                    ' - Linea (' || dbms_utility.format_error_backtrace || ')';
    RAISE_APPLICATION_ERROR(-20000,
                            $$PLSQL_UNIT || '.' || 'CLRHSI_REG_CODIVR' ||
                            SQLERRM);
END CLRHSI_REG_CODIVR;

/*
 ****************************************************************'
* Nombre SP : CLRHSI_IMAGEN_APROB
* Propósito : Insertar los escenarios a ejecutar, para la gestion
              fotografica, App Servicio Tecnico, en estado pendiente.
* Input:    PI_CODSOLOT        - Numero de SOT  
            PI_IDAGENDA        - Id Agenda 
            PI_DNITECNICO      - Dni de tecnico
            PI_CODCONTRATA     - Codigo de contrata
            PI_IDACTIVIDAD     - Codigo de Trabajo a Realizar
            PI_IDSERVICIO      - Codigo de Servicio
            PI_CANTIATENCION   - Cantidad Total de equipos a instalar
            PI_IDESCENARIO     - Codigo de Escenario de Trabajo a Realizar  
            PI_COD_FOTO        - Codigo de foto a tomar      
* Output :  PO_RESULTADO       - Codigo resultado
            PO_MSGERR          - Mensaje resultado
* Creado por : Cesar Rengifo
* Fec Creación : 10/01/2020
* Fec Actualización : --
****************************************************************
*/                               
    
PROCEDURE CLRHSI_IMAGEN_APROB(PI_CODSOLOT      IN OPERACION.SOLOT.CODSOLOT%TYPE,
                              PI_IDAGENDA      IN OPERACION.AGENDAMIENTO.IDAGENDA%TYPE,
                              PI_DNITECNICO    IN AGENLIQ.SGAT_AGENDA.AGENC_DNITECNICO%TYPE,
                              PI_CODCONTRATA   IN OPERACION.CONTRATA.CODCON%TYPE,
                              PI_IDACTIVIDAD   IN NUMBER,
                              PI_IDSERVICIO    IN NUMBER,
                              PI_CANTIATENCION IN NUMBER,
                              PI_IDESCENARIO   IN NUMBER,
                              PI_COD_FOTO      IN VARCHAR2,
                              PO_RESULTADO     OUT INTEGER,
                              PO_MSGERR        OUT VARCHAR2) IS

  V_FECHAEJECUTADO DATE := SYSDATE;
  ERR_APINTIMAGEN EXCEPTION;
  v_idestadoimagen number:=5; --estado pendiente
BEGIN
  
  INSERT INTO OPERACION.SGAT_APINT_IMAGEN
    (apintn_codsolot,
     apintn_idagenda,
     apintd_fecha,
     apintv_dnitecnico,
     apintn_codcontrata,
     apintn_idactividades,
     apintn_codservicio,
     apintn_cantiatencion,
     apintv_idescenario,
     apintv_cod_tipo_foto,
     apintn_idestadoimagen,
     apintc_tipoimagen,
     apintd_fecre,
     apintv_usucre)
  VALUES
    (PI_CODSOLOT,
    PI_IDAGENDA,
     V_FECHAEJECUTADO,
     PI_DNITECNICO,
     PI_CODCONTRATA,
     PI_IDACTIVIDAD,
     PI_IDSERVICIO,
     PI_CANTIATENCION,
     PI_IDESCENARIO,
     PI_COD_FOTO,
     v_idestadoimagen,
     'F',
     SYSDATE,
     'APPINT');

  PO_RESULTADO := 0;
  PO_MSGERR    := 'INSERCION SATISFACTORIA';

EXCEPTION
  WHEN ERR_APINTIMAGEN THEN
    PO_RESULTADO := -1;
    PO_MSGERR    := 'ERROR AL REALIZAR LA INSERCION A LA TABLA SGAT_APINT_IMAGEN';
  WHEN OTHERS THEN
    PO_RESULTADO := -99;
    PO_MSGERR    := 'ERROR: ' || TO_CHAR(SQLCODE) || ' ' || SQLERRM;
  
END CLRHSI_IMAGEN_APROB;


/*
 ****************************************************************'
* Nombre SP : CLRHSS_REPORTE_FOTO
* Propósito : Consulta del reporte fotografico por idagenda, mostrara 
              la lista de fotos pendientes a tomar por el tecnico.
* Input:   PI_IDAGENDA    - Id Agenda
* Output : PO_CURSOR      - Lista reporte
           PO_RESULTADO 	- Codigo resultado
           PO_MSGERR   		- Mensaje resultado
* Creado por : Wendy Tamayo
* Fec Creación : 29/01/2020
* Fec Actualización : --
****************************************************************
*/     

PROCEDURE CLRHSS_REPORTE_FOTO (PI_IDAGENDA     IN NUMBER,
                               PO_CURSOR       OUT T_CURSOR,                
                               PO_RESULTADO    OUT INTEGER,
                               PO_MSGERR       OUT VARCHAR2) is
 
v_flag_carga  number:=0;   
                         
begin
                                                              
 OPEN PO_CURSOR for
   SELECT A.APINTN_IDIMAGEN,
          B.FOTOB_IMG,
          A.APINTV_COD_TIPO_FOTO,
          B.FOTOV_DESC_MATRIZ
     FROM OPERACION.SGAT_APINT_IMAGEN A
    INNER JOIN OPERACION.SGAT_MATRIZ_FOTO B
       ON (A.APINTV_COD_TIPO_FOTO = B.FOTOV_COD_MATRIZ)
    WHERE A.APINTN_FLAG_CARGA = v_flag_carga
      AND A.APINTN_IDAGENDA = PI_IDAGENDA;

   PO_RESULTADO := 0;
   PO_MSGERR    := 'OPERACION EXITOSA';

exception
  when others then
    PO_RESULTADO := 1;
    PO_MSGERR    := 'ERROR AL CONSULTAR REPORTE FOTOGRAFICO';   
    
END CLRHSS_REPORTE_FOTO; 
/*
 ****************************************************************'
* Nombre SP : CLRHSS_FOTOS_ENV
* Propósito : Consulta del reporte fotografico, mostrara las fotos 
              tomadas por el tecnico por el App Servicio Tecnico.
* Input:   PI_IDAGENDA    - Id Agenda
* Output : PO_CURSOR      - Lista reporte
		   PO_RESULTADO   - Codigo resultado
           PO_MSGERR   	  - Mensaje resultado
* Creado por : Wendy Tamayo
* Fec Creación : 31/01/2020
* Fec Actualización : --
****************************************************************
*/   

PROCEDURE CLRHSS_FOTOS_ENV (PI_IDAGENDA     IN NUMBER,
                               PO_CURSOR       OUT T_CURSOR,                
                               PO_RESULTADO    OUT INTEGER,
                               PO_MSGERR       OUT VARCHAR2) is

v_flag_carga  number:=1;  
v_idestadoimagen number:=3; --estado en proceso     
                          
begin
  
   OPEN PO_CURSOR for
      SELECT  A.APINTN_IDIMAGEN, 
              A.APINTB_IMG_1, 
            A.APINTV_COD_TIPO_FOTO
      FROM OPERACION.SGAT_APINT_IMAGEN A
     INNER JOIN OPERACION.SGAT_MATRIZ_FOTO B
        ON (A.APINTV_COD_TIPO_FOTO = B.FOTOV_COD_MATRIZ)
     WHERE  APINTN_IDESTADOIMAGEN = v_idestadoimagen
       AND A.APINTN_FLAG_CARGA = v_flag_carga
       AND A.APINTN_IDAGENDA = PI_IDAGENDA;
      
   PO_RESULTADO := 0;
   PO_MSGERR    := 'OPERACION EXITOSA';

exception
  when others then
    PO_RESULTADO := 1;
    PO_MSGERR    := 'ERROR AL CONSULTAR';   
    
END CLRHSS_FOTOS_ENV;  

/*
 ****************************************************************'
* Nombre SP : CLRHSU_ACT_REPORT_FOTO
* Propósito : Actualizar reporte fotografico, insertar imagen tomada
              por el tecnico, cambio de estado en proceso de atencion.
* Input:   PI_IDAGENDA    - Id Agenda
           PI_IDREPORTE   - Id del reporte
           PI_DES_IMG     - Descripcion nombre foto
           PI_IMAGEN      - Imagen tomada por el App             
* Output : PO_RESULTADO 	- Codigo resultado
           PO_MSGERR   		- Mensaje resultado
* Creado por : Wendy Tamayo
* Fec Creación : 29/01/2020
* Fec Actualización : --
****************************************************************
*/    

PROCEDURE CLRHSU_ACT_REPORT_FOTO (PI_IDAGENDA     IN NUMBER,
                                	 PI_IDREPORTE    IN NUMBER,
                                   PI_DES_IMG      IN VARCHAR2,
                                   PI_IMAGEN       IN BLOB,      
                                   PO_RESULTADO    OUT INTEGER,
                                   PO_MSGERR       OUT VARCHAR2) is               

v_idestadoimagen number:=3; --estado en proceso     
v_flag_carga number:=1;

begin
   
   UPDATE OPERACION.SGAT_APINT_IMAGEN
      SET APINTV_DESC_IMG_1 = PI_DES_IMG,
          APINTB_IMG_1      = PI_IMAGEN,
          APINTN_FLAG_CARGA = v_flag_carga,
          APINTN_IDESTADOIMAGEN = v_idestadoimagen
    WHERE APINTN_IDIMAGEN = PI_IDREPORTE
      AND APINTN_IDAGENDA = PI_IDAGENDA;
                                                       
   PO_RESULTADO := 0;
   PO_MSGERR    := 'OPERACION EXITOSA';

exception
  when others then
    PO_RESULTADO := 1;
    PO_MSGERR    := 'ERROR AL ACTUALIZAR REPORTE FOTOGRAFICO';   
    
END CLRHSU_ACT_REPORT_FOTO;  

/*
 ****************************************************************'
* Nombre SP : CLRHSS_LOGIN_TECNICO
* Propósito : Datos del tecnico para atencion de SOT para 
              tecnologia LTE Y DTH.
* Input:   PI_DNI         - Id Agenda
* Output:  PO_CURSOR      - Datos del tecnico
           PO_RESULTADO 	- Codigo resultado
           PO_MSGERR   		- Mensaje resultado
* Creado por: Wendy Tamayo
* Fec Creación: 07/02/2020
* Fec Actualización : --
****************************************************************
*/   

PROCEDURE CLRHSS_LOGIN_TECNICO (PI_DNI          IN VARCHAR2,
                                PO_CURSOR       OUT T_CURSOR,                
                                PO_RESULTADO    OUT INTEGER,
                                PO_MSGERR       OUT VARCHAR2) is

V_EXISTE NUMBER :=0;

BEGIN
  
SELECT COUNT(*)
  INTO V_EXISTE
  FROM pvt.tabusuario@dbl_pvtdb t
 where T.INSTALACION = 1
   AND T.ESTADO = 1
   AND T.ACTIVO = 'ACTIVO'
   AND T.NUMDOC = PI_DNI;
      
  if V_EXISTE > 0 then

   OPEN PO_CURSOR for
   select t.idusuario,
          t.tipdoc,
          t.numdoc,
          t.nombre,
          t.contrata,
          t.tel_rpc,
          t.activo
     from pvt.tabusuario@dbl_pvtdb t
    where T.INSTALACION = 1
      AND T.ESTADO = 1
      AND T.ACTIVO = 'ACTIVO'
      AND T.NUMDOC=PI_DNI;
      
       PO_RESULTADO := 0;
       PO_MSGERR    := 'OPERACION EXITOSA';
     
   else
      PO_RESULTADO := 2;
      PO_MSGERR    := 'NO EXISTE TECNICO';	
      
   end if;
  
exception
  when others then
    PO_RESULTADO := 1;
    PO_MSGERR    := 'ERROR AL CONSULTAR';   
    
END CLRHSS_LOGIN_TECNICO;  
                               	                             	
/*
 ****************************************************************'
* Nombre SP : CLRHSS_LISTA_SOT
* Propósito : Lista de SOTs asociadas a un tecnico para la 
              tecnologia LTE y DTH.
* Input:   PI_DNI           - Id Agenda
* Output:  PO_CURSOR        - Lista Sots por atender
           PO_RESULTADO 	- Codigo resultado
           PO_MSGERR   		- Mensaje resultado
* Creado por : Wendy Tamayo
* Fec Creación : 11/02/2020
* Fec Actualización : 07/04/2020
****************************************************************
*/   

PROCEDURE CLRHSS_LISTA_SOT(PI_DNI       IN VARCHAR2,
                           PO_CURSOR    OUT T_CURSOR,
                           PO_RESULTADO OUT INTEGER,
                           PO_MSGERR    OUT VARCHAR2) is

  v_cantidad  number := 0;
  v_tarea_def number := 801; --tarea: Inalambrico - Registro de datos

BEGIN

  -- validar si existen sots
  select count(distinct s.codsolot)
    into v_cantidad
    from agendamiento             a,
         pvt.tabusuario@dbl_pvtdb t,
         solot                    s
   where a.codsolot = s.codsolot
     and t.numdoc = a.dni_tecnico
     and a.fecagenda > TO_CHAR(SysDate, 'DD/MM/YYYY')
     and a.dni_tecnico = PI_DNI;

  if v_cantidad > 0 then
  
    open po_cursor for
      select distinct PI_DNI dni_tecnico,
                      s.codsolot Sot,
                      (select t.idtareawf
                         from tareawf t
                        where t.tareadef = v_tarea_def
                          and t.idwf in
                              (select w.idwf
                                 from wf w
                                where w.codsolot = s.codsolot)) idtareawf,
                      s.estsol codestado,
                      (select e.descripcion
                         from estsol e
                        where e.estsol = s.estsol) estado,
                      s.tiptra tipoTrabajo,
                      s.customer_id customerId,
                      s.cod_id contratoId,
                      vu.NOMEST departamento,
                      vu.NOMPVC provincia,
                      vu.NOMDST distrito,
                      s.direccion,
                      v.telefono1 contactoCliente,
                      v.nomcli nombreCliente,
                      vt.idplano "IdPlano",
                      vt.coordx_eta latitud,
                      vt.coordy_eta longitud,
                      operacion.pkg_app_instalador.CLRHFS_PLAN_CONTRATADO(s.codsolot) as planContratado,
                      s.codcli codCliente,
                      t.descripcion descripcion,
                      ts.DSCSRV servicioDescripcion,
                      ISO.tipsrv,
                      b.codigon_aux codigoEscenario,
                      b.abreviacion escenario,
                      to_number(b.descripcion) codigoTecnologia,
                      b.codigoc tecnologia,
                      '30' segundosTracking,
                      '300' radio
        from solot                   s,
             pvt.tabusuario@dbl_pvtdb usu,
             agendamiento            ag,
             vtatabcli                v,
             vtasuccli               vt,
             tiptrabajo               t,
             INSSRV                 ISO,
             TYSTABSRV               TS,
             V_UBICACIONES          VU,
             tipopedd                 a,
             opedd                    b,
             solotpto               pto
       where s.codsolot     = ag.codsolot
         and s.codsolot     = pto.codsolot
         and pto.codinssrv  = iso.codinssrv
         and usu.numdoc     = ag.dni_tecnico
         and v.codcli       = s.codcli
         and ts.CODSRV      = ISO.CODSRV
         and V.CODUBI       = VU.CODUBI
         and a.tipopedd     = b.tipopedd
         and b.codigon      = t.tiptra
         and s.tiptra       = t.tiptra
         and a.abrev        = 'ESCXTIPTRAXTECNOLOGIA'
         and iso.codsuc     = vt.codsuc
		 and ag.fecagenda   > TO_CHAR(SysDate, 'DD/MM/YYYY')
         and ag.dni_tecnico = PI_DNI;
  
    PO_RESULTADO := 0;
    PO_MSGERR    := 'OPERACION EXITOSA';
  
  else
  
    PO_RESULTADO := 2;
    PO_MSGERR    := 'NO EXISTE SOT ASOCIADA AL TECNICO';
  
  end if;

exception
  when others then
    PO_RESULTADO := 1;
    PO_MSGERR    := 'ERROR AL CONSULTAR';
  
END CLRHSS_LISTA_SOT;
								
/*
 ****************************************************************'
* Nombre SP : CLRHSU_INICIAR_SOT
* Propósito : Inicia SOT, cambia de estado a Ejecucion para 
              tecnologia LTE y DTH.
* Input:   PI_NRO_SOT     - Numero de SOT
* Output:  PO_RESULTADO 	- Codigo resultado
           PO_MSGERR   		- Mensaje resultado
* Creado por : Wendy Tamayo
* Fec Creación : 10/02/2020
* Fec Actualización : --
****************************************************************
*/   

PROCEDURE CLRHSU_INICIAR_SOT ( PI_NRO_SOT      IN NUMBER,
                               PO_RESULTADO    OUT INTEGER,
                               PO_MSGERR       OUT VARCHAR2) IS

v_estado number:=17; -- en ejecucion
         
BEGIN
   
   UPDATE SOLOT
   SET ESTSOL = v_estado
   WHERE CODSOLOT = PI_NRO_SOT;     
   
   INSERT INTO OPERACION.SGAT_CONTROL_APP (CONTROLN_CODSOLOT,CONTROLV_USUREG,CONTROLD_FECREG)
   VALUES (PI_NRO_SOT, 'APP_INSTALADOR' ,SYSDATE); 
                                                                  
   PO_RESULTADO := 0;
   PO_MSGERR    := 'OPERACION EXITOSA';

exception
  when others then
    PO_RESULTADO := 1;
    PO_MSGERR    := 'ERROR AL CONSULTAR';  

END CLRHSU_INICIAR_SOT;

/*
 ****************************************************************'
* Nombre SP : CLRHSS_LISTA_TELEFINTERNET_LTE
* Propósito : Lista de Telefonia/Cable asociadas a una SOTs para la 
              tecnologia LTE y DTH.
* Input:   PI_NRO_SOT     -  Nro SOT
* Output:  PO_CURSOR      - Lista de Telefonia/Cable
           PO_RESULTADO 	- Codigo resultado
           PO_MSGERR   		- Mensaje resultado
* Creado por : Cesar Rengifo
* Fec Creación : 13/02/2020
* Fec Actualización : --
****************************************************************
*/    

PROCEDURE CLRHSS_LISTA_TELEFINTERNET_LTE (PI_NRO_SOT      IN OPERACION.SOLOT.CODSOLOT%TYPE,
                                      PO_CURSOR       OUT T_CURSOR,                
                                      PO_RESULTADO    OUT INTEGER,
                                      PO_MSGERR       OUT VARCHAR2)IS

BEGIN

  OPEN PO_CURSOR for
    select equ_conax.grupo codigo,
           t.descripcion,
           se.numserie,
           se.mac,
           se.cantidad,
           i.codinssrv,
           se.codsolot,
           se.punto,
           se.orden,
           a.cod_sap,
           s.codcli,
           se.tipequ
      from solotptoequ se,
           solot s,
           solotpto sp,
           inssrv i,
           tipequ t,
           almtabmat a,
           (select a.codigon tipequ, to_number(codigoc) grupo
              from opedd a, tipopedd b
             where a.tipopedd = b.tipopedd
               and b.abrev = 'TIPEQU_LTE_TLF') equ_conax
     where se.codsolot = s.codsolot
       and s.codsolot = sp.codsolot
       and se.punto = sp.punto
       and sp.codinssrv = i.codinssrv
       and t.tipequ = se.tipequ
       and a.codmat = t.codtipequ
       and se.codsolot = PI_NRO_SOT
       and t.tipequ = equ_conax.tipequ;
       
       PO_RESULTADO := 0;
       PO_MSGERR    := 'OPERACION EXITOSA';
EXCEPTION
  when others then
    PO_RESULTADO := -1;
    PO_MSGERR    :=  'ERROR: ' || TO_CHAR(SQLCODE) || ' ' || SQLERRM;
  
END CLRHSS_LISTA_TELEFINTERNET_LTE;

/*
 ****************************************************************'
* Nombre SP : CLRHSS_LISTA_COMPONENTE_DTHLTE
* Propósito : Lista de Antenas y SIM CARD asociadas a una SOTs para la 
              tecnologia LTE y DTH.
* Input:   PI_TIPO        - Tipo 
* Output:  PO_CURSOR      - Lista de Series por Tipo
           PO_RESULTADO 	- Codigo resultado
           PO_MSGERR   		- Mensaje resultado
* Creado por : Cesar Rengifo
* Fec Creación : 18/02/2020
* Fec Actualización : --
****************************************************************
*/    

PROCEDURE CLRHSS_LISTA_COMPONENTE_DTHLTE (PI_TIPO         IN NUMBER,
                                      PO_CURSOR       OUT T_CURSOR,                
                                      PO_RESULTADO    OUT INTEGER,
                                      PO_MSGERR       OUT VARCHAR2)IS

BEGIN

  OPEN PO_CURSOR for
      select numero_serie, imei_esn_ua, tipo
        from operacion.tabequipo_material
       where tipo = PI_TIPO
         and estado = 0;
         
       PO_RESULTADO := 0;
       PO_MSGERR    := 'OPERACION EXITOSA';
EXCEPTION
  when others then
    PO_RESULTADO := -1;
    PO_MSGERR    :=  'ERROR: ' || TO_CHAR(SQLCODE) || ' ' || SQLERRM;
  
END CLRHSS_LISTA_COMPONENTE_DTHLTE;   

/*
 ****************************************************************'
* Nombre SP : CLRHSS_LISTA_CABLE_DTH
* Propósito : Lista de Tarjetas y Decos asociadas a una SOTs para la 
              tecnologia DTH.
* Input:   PI_NRO_SOT     -  Nro SOT
* Output:  PO_CURSOR      - Lista de Tarjetas y Decos
           PO_RESULTADO 	- Codigo resultado
           PO_MSGERR   		- Mensaje resultado
* Creado por : Cesar Rengifo
* Fec Creación : 19/02/2020
* Fec Actualización : --
****************************************************************
*/    

PROCEDURE CLRHSS_LISTA_CABLE_DTH (PI_NRO_SOT      IN OPERACION.SOLOT.CODSOLOT%TYPE,
                                  PO_CURSOR       OUT T_CURSOR,                
                                  PO_RESULTADO    OUT INTEGER,
                                  PO_MSGERR       OUT VARCHAR2)IS

BEGIN

  OPEN PO_CURSOR for
  select s.codsolot,equ_conax.grupo codigo,t.descripcion, se.numserie, se.mac, se.cantidad, 0 sel, i.codinssrv, se.codsolot, se.punto, se.orden,a.cod_sap, se.tipequ
        from   solotptoequ se, solot s, solotpto sp, inssrv i, tipequ t, almtabmat a,
         (select a.codigon tipequ,to_number(codigoc) grupo 
          from opedd a,tipopedd b 
          where a.tipopedd = b.tipopedd
          and b.abrev = 'TIPEQU_DTH_CONAX') equ_conax
        where  se.codsolot  = s.codsolot
        and    s.codsolot   = sp.codsolot
        and    se.punto     = sp.punto
        and    sp.codinssrv = i.codinssrv
        and    t.tipequ     = se.tipequ
        and    a.codmat     = t.codtipequ
        and    t.tipequ = equ_conax.tipequ
        and    se.codsolot  = PI_NRO_SOT;
        
      PO_RESULTADO := 0;
      PO_MSGERR    := 'OPERACION EXITOSA';
EXCEPTION
  when others then
    PO_RESULTADO := -1;
    PO_MSGERR    :=  'ERROR: ' || TO_CHAR(SQLCODE) || ' ' || SQLERRM;
  
END CLRHSS_LISTA_CABLE_DTH;  

/*
 ****************************************************************'
* Nombre SP : CLRHSI_ASOCIAR_DTH
* Propósito : Permite grabar la Asociacion entre la Tarjeta y el 
              Deco para Cable.
* Input:    PI_CODSOLOT           - Numero de SOT  
            PI_IDDET_DECO         - Id Detalle Deco
            PI_NRO_SERIE_DECO     - mac del decodificador
            PI_IDDET_TARJETA      - Id Detalle Tarjeta
            PI_NRO_SERIE_TARJETA  - nro. serie de la tarjeta
* Output :  PO_RESULTADO          - Codigo resultado
            PO_MSGERR             - Mensaje resultado
* Creado por : Cesar Rengifo
* Fec Creación : 12/02/2020
* Fec Actualización : --
****************************************************************
*/                               
    
PROCEDURE CLRHSI_ASOCIAR_DTH(PI_CODSOLOT          IN OPERACION.SOLOT.CODSOLOT%TYPE,
                           PI_IDDET_DECO        IN OPERACION.TARJETA_DECO_ASOC.IDDET_DECO%TYPE,
                           PI_NRO_SERIE_DECO    IN OPERACION.TARJETA_DECO_ASOC.NRO_SERIE_DECO%TYPE,
                           PI_IDDET_TARJETA     IN OPERACION.TARJETA_DECO_ASOC.IDDET_TARJETA%TYPE,
                           PI_NRO_SERIE_TARJETA IN OPERACION.TARJETA_DECO_ASOC.NRO_SERIE_TARJETA%TYPE,
                           PO_RESULTADO         OUT INTEGER,
                           PO_MSGERR            OUT VARCHAR2) IS
  ERR_ASOCIAR_TARJEDECO_CABLE EXCEPTION;
BEGIN

  INSERT INTO OPERACION.TARJETA_DECO_ASOC
    (CODSOLOT,
     IDDET_DECO,
     NRO_SERIE_DECO,
     IDDET_TARJETA,
     NRO_SERIE_TARJETA)
  VALUES
    (PI_CODSOLOT,
     PI_IDDET_DECO,
     PI_NRO_SERIE_DECO,
     PI_IDDET_TARJETA,
     PI_NRO_SERIE_TARJETA);

  PO_RESULTADO := 0;
  PO_MSGERR    := 'INSERCION SATISFACTORIA';

EXCEPTION
  WHEN ERR_ASOCIAR_TARJEDECO_CABLE THEN
    PO_RESULTADO := -1;
    PO_MSGERR    := 'ERROR AL REALIZAR LA INSERCION A LA TABLA OPERACION.TARJETA_DECO_ASOC';
  WHEN OTHERS THEN
    PO_RESULTADO := -99;
    PO_MSGERR    := 'ERROR: ' || TO_CHAR(SQLCODE) || ' ' || SQLERRM;
  
END CLRHSI_ASOCIAR_DTH;

/*
 ****************************************************************'
* Nombre SP : CLRHSI_DESASOCIAR_DTH
* Propósito : Eliminar la Asociacion de Tarjeta con Deco de una SOTs  
              para la tecnologia DTH.
* Input:   PI_NRO_SOT     -  Nro SOT
* Output:  PO_RESULTADO 	- Codigo resultado
           PO_MSGERR   		- Mensaje resultado
* Creado por : Cesar Rengifo
* Fec Creación : 11/02/2020
* Fec Actualización : --
****************************************************************
*/    
PROCEDURE CLRHSI_DESASOCIAR_DTH(PI_NRO_SOT   IN OPERACION.SOLOT.CODSOLOT%TYPE,
                              PO_RESULTADO OUT INTEGER,
                              PO_MSGERR    OUT VARCHAR2) IS

  V_ERROR VARCHAR2(300);
  N_ERROR NUMBER := 0;

  cursor cur_asociado is
    SELECT T.ID_ASOC
      FROM OPERACION.TARJETA_DECO_ASOC T
     WHERE T.CODSOLOT = PI_NRO_SOT;

BEGIN

  for c_e in cur_asociado loop
    if c_e.ID_ASOC is not null then
      SALES.PQ_DTH_POSTVENTA.P_ELIM_REG_ASOC(c_e.ID_ASOC, N_ERROR, V_ERROR);
    end if;
  end loop;

  PO_RESULTADO := 0;
  PO_MSGERR    := 'OPERACION EXITOSA';
exception
  when others then
    PO_RESULTADO := -1;
    PO_MSGERR    := 'ERROR: ' || TO_CHAR(SQLCODE) || ' ' || SQLERRM;
  
END CLRHSI_DESASOCIAR_DTH;

/*
 ****************************************************************'
* Nombre SP : CLRHSS_DESPAREODECO
* Propósito : Eliminar la Asociacion de Tarjeta con Deco de una SOTs  
              para la tecnologia DTH.
* Input:  PI_CODSOLOT          - Codigo de la solicitud de orden de trabajo
          PI_NRO_UA_DECO       - unidad direcccion del deco
          PI_NRO_SERIE_TARJETA - nro. serie de la tarjeta
* Output: PO_RESPUESTA    	   - Codigo resultado
          PO_MENSAJE   		   	 - Mensaje resultado
* Creado por : 
* Fec Creación : 24/02/2020
* Fec Actualización : 09/03/2020
****************************************************************
*/  
PROCEDURE CLRHSS_DESPAREODECO(PI_CODSOLOT          OPERACION.SOLOT.CODSOLOT%TYPE,
                             PI_NRO_UA_DECO       OPERACION.TABEQUIPO_MATERIAL.IMEI_ESN_UA%TYPE,
                             PI_NRO_SERIE_TARJETA OPERACION.TARJETA_DECO_ASOC.NRO_SERIE_TARJETA%TYPE,
                             PO_RESPUESTA         IN OUT VARCHAR2,
                             PO_MENSAJE           IN OUT VARCHAR2) IS
    V_CONTEGO     OPERACION.SGAT_TRXCONTEGO%ROWTYPE;
    V_COD_ID      OPERACION.SOLOT.COD_ID%TYPE;
    V_BOUQUET     OPERACION.SGAT_TRXCONTEGO.TRXV_BOUQUET%TYPE;
    V_NRO_UA_DECO OPERACION.TABEQUIPO_MATERIAL.IMEI_ESN_UA%TYPE;
    WE_ERROR EXCEPTION;
  BEGIN
    BEGIN
      SELECT S.COD_ID INTO V_COD_ID FROM OPERACION.SOLOT S WHERE S.CODSOLOT = PI_CODSOLOT;
    EXCEPTION
      WHEN OTHERS THEN
        PO_RESPUESTA := 'ERROR';
        PO_MENSAJE   := 'ERROR: NO SE ENCUENTRA LA ORDEN DE TRABAJO (SOT)';
        RAISE WE_ERROR;
    END;
    IF V_COD_ID IS NULL THEN
      V_COD_ID := OPERACION.PKG_CAMBIO_CICLO_FACT.F_OTIENE_COD_ID(PI_CODSOLOT);
      IF V_COD_ID IS NULL THEN
        PO_RESPUESTA := 'ERROR';
        PO_MENSAJE   := 'ERROR: NO SE ENCUENTRA EL CONTRATO PARA OBTENER LOS BOUQUETS';
        RAISE WE_ERROR;
      END IF;
    END IF;
    BEGIN
      SELECT M.IMEI_ESN_UA
        INTO V_NRO_UA_DECO
        FROM OPERACION.TABEQUIPO_MATERIAL M
       WHERE M.IMEI_ESN_UA = PI_NRO_UA_DECO
         AND (SELECT COUNT(1)
                FROM OPERACION.OPEDD A, OPERACION.TIPOPEDD B
               WHERE A.TIPOPEDD = B.TIPOPEDD
                 AND B.ABREV = 'PREFIJO_DECO'
                 AND INSTR(UPPER(M.NUMERO_SERIE), UPPER(TRIM(A.CODIGOC))) = 1) > 0;
    EXCEPTION
      WHEN OTHERS THEN
        PO_RESPUESTA := 'ERROR';
        PO_MENSAJE   := 'ERROR: PREFIJO DEL NUMERO DE SERIE DEL DECODIFICADOR NO ES SOPORTADO';
        RAISE WE_ERROR;
    END;
    V_BOUQUET := OPERACION.PQ_DECO_ADICIONAL_LTE.SGAFUN_OBT_BOUQUET_ACT(V_COD_ID);
    IF V_BOUQUET IS NULL THEN
      PO_RESPUESTA := 'ERROR';
      PO_MENSAJE   := 'ERROR: NO SE ENCUENTRA LOS BOUQUETS PARA REALIZAR LA ACTIVACION';
      RAISE WE_ERROR;
    END IF;
    V_CONTEGO.TRXN_CODSOLOT      := PI_CODSOLOT;
    V_CONTEGO.TRXN_ACTION_ID     := OPERACION.PKG_CONTEGO.SGAFUN_PARAM_CONTEGO('CONF_CONTEGO_ACT',
                                                                               'CONF_ACT',
                                                                               'DESPAREO-CONTEGO',
                                                                               'N');
    V_CONTEGO.TRXV_TIPO          := 'DESPAREO';
    V_CONTEGO.TRXV_BOUQUET       := V_BOUQUET;
    V_CONTEGO.TRXV_SERIE_TARJETA := PI_NRO_SERIE_TARJETA;
    V_CONTEGO.TRXV_SERIE_DECO    := V_NRO_UA_DECO;
    V_CONTEGO.TRXN_PRIORIDAD     := OPERACION.PKG_CONTEGO.SGAFUN_PARAM_CONTEGO('CONF_CONTEGO_ACT',
                                                                               'CONF_ACT',
                                                                               'DESPAREO-CONTEGO',
                                                                               'AU');
    OPERACION.PKG_CONTEGO.SGASI_REGCONTEGO(V_CONTEGO, PO_RESPUESTA);
    IF PO_RESPUESTA = 'ERROR' THEN
      PO_MENSAJE := 'ERROR: AL GRABAR LAS TRANSACCIONES DE DESPAREO EN LA TABLA OPERACION.SGAT_TRXCONTEGO.';
      RAISE WE_ERROR;
    ELSE
      PO_RESPUESTA := 'OK';
      PO_MENSAJE   := 'PROCESO TERMINADO SATISFACTORIAMENTE';
      COMMIT;
    END IF;
  EXCEPTION
    WHEN WE_ERROR THEN
      OPERACION.PKG_CONTEGO.SGASP_LOGERR('CLRHSS_DESPAREODECO', '', PI_CODSOLOT, PO_RESPUESTA, PO_MENSAJE);
      ROLLBACK;
    WHEN OTHERS THEN
      PO_RESPUESTA := 'ERROR';
      PO_MENSAJE   := 'ERROR: AL GRABAR LAS TRANSACIONES DE DESPAREO ' || SQLCODE || ' ' || SQLERRM || ' ' ||
                      DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      OPERACION.PKG_CONTEGO.SGASP_LOGERR('CLRHSS_DESPAREODECO', '', PI_CODSOLOT, PO_RESPUESTA, PO_MENSAJE);
      ROLLBACK;
  END;

/****************************************************************
  '* Nombre SP:  CLRHSS_DESACTIVARBOUQUET
  '* Proposito:  EL SIGUIENTE SP REALIZA LA DESACTIVACION DE BOUQUETS PARA 
                 UNA TARJETA
  '* Inputs: PI_CODSOLOT - Codigo de la orden de trabajo
             PI_NUMSERIE_TARJETA - Numero de serie de la tarjeta del deco
  '* Output: PO_BOUQUET - Bouquets desactivados
             PO_RESPUESTA - Respuesta de salida
             PO_MENSAJE - Mensaje de salida
  '* Creado por:  HITSS
  '* Fec Creacion:  24/02/2020
  '****************************************************************/
  PROCEDURE CLRHSS_DESACTIVARBOUQUET(PI_CODSOLOT         IN OPERACION.SOLOT.CODSOLOT%TYPE,
									 PI_NUMSERIE_TARJETA IN OPERACION.SOLOTPTOEQU.NUMSERIE%TYPE,
									 PO_BOUQUET          OUT OPERACION.SGAT_TRXCONTEGO.TRXV_BOUQUET%TYPE,
									 PO_RESPUESTA        OUT VARCHAR2,
									 PO_MENSAJE          OUT VARCHAR2) IS
    V_CONTEGO  OPERACION.SGAT_TRXCONTEGO%ROWTYPE;
    V_COD_ID   OPERACION.SOLOT.COD_ID%TYPE;
    V_BOUQUET  OPERACION.SGAT_TRXCONTEGO.TRXV_BOUQUET%TYPE;
    V_NUMSERIE OPERACION.SOLOTPTOEQU.NUMSERIE%TYPE;
    WE_ERROR EXCEPTION;
  BEGIN
    BEGIN
      SELECT S.COD_ID INTO V_COD_ID FROM OPERACION.SOLOT S WHERE S.CODSOLOT = PI_CODSOLOT;
    EXCEPTION
      WHEN OTHERS THEN
        PO_RESPUESTA := 'ERROR';
        PO_MENSAJE   := 'ERROR: NO SE ENCUENTRA LA ORDEN DE TRABAJO (SOT)';
        RAISE WE_ERROR;
    END;
    IF V_COD_ID IS NULL THEN
      V_COD_ID := OPERACION.PKG_CAMBIO_CICLO_FACT.F_OTIENE_COD_ID(PI_CODSOLOT);
      IF V_COD_ID IS NULL THEN
        PO_RESPUESTA := 'ERROR';
        PO_MENSAJE   := 'ERROR: NO SE ENCUENTRA EL CONTRATO PARA OBTENER LOS BOUQUETS';
        RAISE WE_ERROR;
      END IF;
    END IF;
    BEGIN
      SELECT DISTINCT NUMSERIE
        INTO V_NUMSERIE
        FROM OPERACION.SOLOTPTOEQU
       WHERE CODSOLOT = PI_CODSOLOT
         AND NUMSERIE = PI_NUMSERIE_TARJETA
         AND TIPEQU IN (SELECT A.CODIGON TIPEQUOPE
                          FROM OPERACION.OPEDD A, OPERACION.TIPOPEDD B
                         WHERE A.TIPOPEDD = B.TIPOPEDD
                           AND B.ABREV = 'TIPEQU_DTH_CONAX'
                           AND CODIGOC = '1');
    EXCEPTION
      WHEN OTHERS THEN
        PO_RESPUESTA := 'ERROR';
        PO_MENSAJE   := 'ERROR: SOLO SE SOPORTA TIPO DE TARJETA: SMART CARD CONAX';
        RAISE WE_ERROR;
    END;
    V_BOUQUET := OPERACION.PQ_DECO_ADICIONAL_LTE.SGAFUN_OBT_BOUQUET_ACT(V_COD_ID);
    IF V_BOUQUET IS NULL THEN
      PO_RESPUESTA := 'ERROR';
      PO_MENSAJE   := 'ERROR: NO SE ENCUENTRA LOS BOUQUETS PARA REALIZAR LA DESACTIVACION';
      RAISE WE_ERROR;
    END IF;
    V_CONTEGO.TRXN_CODSOLOT      := PI_CODSOLOT;
    V_CONTEGO.TRXN_ACTION_ID     := OPERACION.PKG_CONTEGO.SGAFUN_PARAM_CONTEGO('CONF_CONTEGO_ACT',
                                                                               'CONF_ACT',
                                                                               'BAJA-CONTEGO',
                                                                               'N');
    V_CONTEGO.TRXV_SERIE_TARJETA := V_NUMSERIE;
    V_CONTEGO.TRXV_BOUQUET       := V_BOUQUET;
    V_CONTEGO.TRXN_PRIORIDAD     := OPERACION.PKG_CONTEGO.SGAFUN_PARAM_CONTEGO('CONF_CONTEGO_ACT',
                                                                               'CONF_ACT',
                                                                               'BAJA-CONTEGO',
                                                                               'AU');
    OPERACION.PKG_CONTEGO.SGASI_REGCONTEGO(V_CONTEGO, PO_RESPUESTA);
    IF PO_RESPUESTA = 'ERROR' THEN
      PO_MENSAJE := 'ERROR: AL GRABAR LA TRANSACCION DE DESACTIVACION EN LA TABLA OPERACION.SGAT_TRXCONTEGO.';
      RAISE WE_ERROR;
    ELSE
      PO_RESPUESTA := 'OK';
      PO_MENSAJE   := 'PROCESO TERMINADO SATISFACTORIAMENTE';
      PO_BOUQUET := V_BOUQUET;
      COMMIT;
    END IF;
  EXCEPTION
    WHEN WE_ERROR THEN
      OPERACION.PKG_CONTEGO.SGASP_LOGERR('CLRHSS_DESACTIVARBOUQUET', '', PI_CODSOLOT, PO_RESPUESTA, PO_MENSAJE);
      ROLLBACK;
    WHEN OTHERS THEN
      PO_RESPUESTA := 'ERROR';
      PO_MENSAJE   := 'ERROR: AL GRABAR LAS TRANSACIONES DE DESACTIVACION' || SQLCODE || ' ' || SQLERRM || ' ' ||
                      DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      OPERACION.PKG_CONTEGO.SGASP_LOGERR('CLRHSS_DESACTIVARBOUQUET', '', PI_CODSOLOT, PO_RESPUESTA, PO_MENSAJE);
      ROLLBACK;
  END CLRHSS_DESACTIVARBOUQUET;
  
  /*
****************************************************************'
* Nombre SP : CLRHSU_NUM_SERIE_DTH 
* Propósito : Actualizacion del numero de serie de equipo, para 
              la validacion con el inventario para la tecnologia DTH
* Input:   PI_NRO_SOT     - Nro SOT
           PI_NRO_SERIE   - Nro Serie equipo
           PUNTO          - Nro de punto
           PI_ORDEN       - Nro de orden
           PI_TIPEQU      - Tipo de equipo
* Output:  PO_RESULTADO      - Codigo resultado
           PO_MSGERR         - Mensaje resultado
* Creado por : Wendy Tamayo
* Fec Creación : 26/02/2020
* Fec Actualización : --
****************************************************************
*/    

PROCEDURE CLRHSU_NUM_SERIE_DTH(PI_NRO_SOT   IN OPERACION.SOLOT.CODSOLOT%TYPE,
                               PI_NRO_SERIE IN OPERACION.SOLOTPTOEQU.NUMSERIE%TYPE,
                               PI_PUNTO     IN OPERACION.SOLOTPTOEQU.PUNTO%TYPE,
                               PI_ORDEN     IN OPERACION.SOLOTPTOEQU.ORDEN%TYPE,
                               PI_TIPEQU    IN OPERACION.SOLOTPTOEQU.TIPEQU%TYPE,
                               PO_RESULTADO OUT INTEGER,
                               PO_MSGERR    OUT VARCHAR2) IS
BEGIN
  
  IF (LENGTH (PI_NRO_SERIE) > 0 ) THEN                              

  UPDATE OPERACION.SOLOTPTOEQU
     SET NUMSERIE = PI_NRO_SERIE
   WHERE PUNTO = PI_PUNTO
     AND ORDEN = PI_ORDEN
     AND TIPEQU = PI_TIPEQU
     AND CODSOLOT = PI_NRO_SOT;
     
     ELSE
         PO_RESULTADO := 2;
         PO_MSGERR    := 'INGRESAR NUMERO DE SERIE';
   END IF;
        
  PO_RESULTADO := 0;
  PO_MSGERR    := 'OPERACION EXITOSA';

exception
  when others then
    PO_RESULTADO := 1;
    PO_MSGERR    := 'ERROR AL CONSULTAR';
  
END CLRHSU_NUM_SERIE_DTH;

/*
 ****************************************************************'
* Nombre SP : CLRHSI_CIERRE_VALIDACION
* Propósito : Cierre de tareas y validacion de servicios LTE
* Input:   PI_NRO_SOT     -  Nro SOT
* Output:  PO_RESULTADO 	- Codigo resultado
           PO_MSGERR   		- Mensaje resultado
* Creado por : Cesar Rengifo
* Fec Creación : 26/02/2020
* Fec Actualización : --
****************************************************************
*/    

PROCEDURE CLRHSI_CIERRE_VALIDACION(PI_NRO_SOT   IN OPERACION.SOLOT.CODSOLOT%TYPE,
                                     PO_RESULTADO OUT INTEGER,
                                     PO_MSGERR    OUT VARCHAR2)IS
                                     
  V_ERROR VARCHAR2(300);
  N_TIPTRA    OPERACION.SOLOT.TIPTRA%TYPE;
  N_idtareawf opewf.tareawfcpy.idtareawf%TYPE;
  N_idwf      opewf.tareawfcpy.idwf%TYPE;
  N_tarea     opewf.tareawfcpy.tarea%TYPE;
  N_tareadef  opewf.tareawfcpy.tareadef%TYPE;
  V_SP1 opewf.tareawfcpy.pre_proc%type;
  V_SP2 opewf.tareawfcpy.pos_proc%type;
  error_general      EXCEPTION;
  N_ERROR NUMBER := 0;
  
   CURSOR CS_CONF_WF IS
      SELECT D.PARDV_VALOR1, D.PARDV_VALOR2
        FROM AGENLIQ.SGAT_PARAMETRODET D
       WHERE D.PARDV_ABREVIATURA = 'Cierre_val_WF_APP'
         AND D.PARDN_VALORN1 = N_TIPTRA
         AND D.PARDN_ESTADO = 1
       ORDER BY D.PARDN_ORDEN ASC;
       
BEGIN

  SELECT TIPTRA
    INTO N_TIPTRA
    FROM OPERACION.SOLOT
   WHERE CODSOLOT = PI_NRO_SOT;

  FOR C IN CS_CONF_WF LOOP
    begin
      V_SP1 := c.PARDV_VALOR1;
      V_SP2 := c.PARDV_VALOR2;
    
      select wfc.idtareawf, wfc.idwf, wfc.tarea, wft.tareadef
        into N_idtareawf, N_idwf, N_tarea, N_tareadef
        from opewf.wf         wf,
             opewf.tareawfcpy wfc,
             opewf.wfdef      wfd,
             opewf.tareadef   wft,
             opewf.tareawfdef twf,
             operacion.solot  s
       where wf.idwf = wfc.idwf
         and wfd.wfdef = wf.wfdef
         and wft.tareadef = wfc.tareadef
         and twf.tarea = wfc.tarea
         and wf.codsolot = s.codsolot
         and (wfc.pre_proc = C.PARDV_VALOR1 or
             wfc.pos_proc = C.PARDV_VALOR2)
         and wf.codsolot = PI_NRO_SOT;
    
      IF LENGTH(C.PARDV_VALOR1) > 0 then
        dbms_output.put_line(PI_NRO_SOT ||'Ejecutando V_SP1||');
        dbms_output.put_line(V_SP1||'('||N_idtareawf||','||N_idwf||','||N_tarea||','||N_tareadef||')');
        EXECUTE IMMEDIATE 'BEGIN ' || V_SP1 || '(' || N_idtareawf || ',' ||
                          N_idwf || ',' || N_tarea || ',' || N_tareadef || ')' ||
                          '; END;';
      END IF;
      IF LENGTH(C.PARDV_VALOR2) > 0 then
        dbms_output.put_line(V_SP2 ||'Ejecutando V_SP2||');
        dbms_output.put_line(V_SP2||'('||N_idtareawf||','||N_idwf||','||N_tarea||','||N_tareadef||')');
        EXECUTE IMMEDIATE 'BEGIN ' || V_SP2 || '(' || N_idtareawf || ',' ||
                          N_idwf || ',' || N_tarea || ',' || N_tareadef || ')' ||
                          '; END;';
      END IF;
    EXCEPTION
      WHEN OTHERS THEN
        PO_RESULTADO := 1;
        PO_MSGERR := ' Configuracion No Existe ' ;
    END;
  end loop;

  PO_RESULTADO := 0;
  PO_MSGERR    := 'OPERACION EXITOSA';
exception
  when others then
    PO_RESULTADO := 1;
    PO_MSGERR    := 'ERROR: ' || TO_CHAR(SQLCODE) || ' ' || SQLERRM;
END CLRHSI_CIERRE_VALIDACION;   

/****************************************************************
  '* Nombre SP           :  CLRHSS_PROVISIONAR_LTE
  '* Proposito           :  EL SIGUIENTE SP REALIZA LA PROVISION DE LTE
  '* Inputs              :  PI_CODSOLOT - Codigo de la orden de trabajo
                            P_CO_ID - Codigo del contrato del cliente
  '* Output              :  PO_RESPUESTA - Respuesta de salida
                            PO_MENSAJE - Mensaje de salida
  '* Creado por          :  HITSS
  '* Fec Creacion        :  02/03/2020
  '****************************************************************/
PROCEDURE CLRHSS_PROVISIONAR_LTE(P_CODSOLOT         IN OPERACION.SOLOT.CODSOLOT%TYPE,
									P_CO_ID            IN NUMBER,
									PO_RESPUESTA       OUT NUMBER,
									PO_MENSAJE         OUT VARCHAR2) IS
    lv_tip_equ       varchar2(50);
    lv_mdl_equ       varchar2(50);
    lv_msisdn        varchar2(15);
    lv_iccid         varchar2(20);
    ln_deco_adicional NUMBER;
    ln_cod_id         NUMBER;
    ln_custumer_id    NUMBER;
    ln_cant_dig_chip  number;
	V_REQUEST       TIM.LTE_CONTROL_PROV.REQUEST@DBL_BSCS_BF%TYPE;
    V_REQUEST_PADRE TIM.LTE_CONTROL_PROV.REQUEST_PADRE@DBL_BSCS_BF%TYPE;
    V_CUSTOMER_ID   TIM.LTE_CONTROL_PROV.CUSTOMER_ID@DBL_BSCS_BF%TYPE;
	p_co_id_sgass   INTEGER;
    p_tip_serv      VARCHAR2(10);
	p_cod           NUMBER;
    p_mensaje       VARCHAR2(500);
	ln_request_tv    number;
    ln_request_padre number;
    WE_ERROR EXCEPTION;
  BEGIN
    PO_RESPUESTA := -1;
    PO_MENSAJE    := 'FAVOR DE EJECUTAR NUEVAMENTE EL PROCESO';
   
	ln_cant_dig_chip := OPERACION.PQ_SGA_JANUS.F_GET_CONSTANTE_CONF('CANDIGCHIPLTE');
	
	if ln_cant_dig_chip = -10 then
      ln_cant_dig_chip := 19; -- Solo por contingencia
    end if;

	BEGIN
      select valor
        into lv_tip_equ
        from constante
       where constante = 'PROV_TIP_EQU';
      select valor
        into lv_mdl_equ
        from constante
       where constante = 'PROV_MOD_EQU';
    EXCEPTION
      WHEN OTHERS THEN
        PO_RESPUESTA := -1;
        PO_MENSAJE   := 'ERROR: NO SE ENCUENTRA EL TIPO DE EQUIPO';
        RAISE WE_ERROR;
    END;
    -- Tomando ICCID y MSISDN
    BEGIN
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
	 EXCEPTION
      WHEN OTHERS THEN
        PO_RESPUESTA := -1;
        PO_MENSAJE   := 'ERROR: NO SE ENCUENTRO DATOS DE ICCID y MSISDN';
        RAISE WE_ERROR;
    END;
    
	ln_deco_adicional := operacion.pq_deco_adicional_lte.f_obt_tipo_deco(p_codsolot);	 
	
  IF ln_deco_adicional = 0 then
	-- Venta Nueva
        -- Registro de la linea Telefonica LTE en BSCS
        operacion.pq_sga_bscs.p_reg_nro_lte_bscs(lv_msisdn,p_cod,p_mensaje);

	end if;	
    --Validación de Servicios Contratados
	      operacion.PQ_3PLAY_INALAMBRICO.sgass_srv_cnt(p_codsolot,
											     p_co_id_sgass,
											     p_tip_serv,
											     p_cod,
											     p_mensaje);

	--Si solo tiene INT la SOT
    IF p_tip_serv = 'IT' THEN
		BEGIN
        --CREAR SECUENCIAL PARA EL REQUEST PADRE
        SELECT TIM.LTE_PADRE_PROV_SEQNO.NEXTVAL@DBL_BSCS_BF
          INTO V_REQUEST_PADRE
          FROM DUAL;

        --CREAR SECUENCIAL PARA EL NVO REQUEST
        SELECT TIM.LTE_PROV_SEQNO.NEXTVAL@DBL_BSCS_BF
          INTO V_REQUEST
          FROM DUAL;
          
        -- Obtenemos el customer_id
        SELECT CA.CUSTOMER_ID
          INTO V_CUSTOMER_ID
          FROM CURR_CO_STATUS@DBL_BSCS_BF CCS, CONTRACT_ALL@DBL_BSCS_BF CA
         WHERE CCS.CO_ID = P_CO_ID
           AND CCS.CO_ID = CA.CO_ID;

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
           p_codsolot,
           'INT',
           lv_msisdn,
           lv_iccid,
           'APP Instalador',
           SYSDATE,
           'APP Instalador',
           SYSDATE);

        PO_RESPUESTA := 0;
        PO_MENSAJE    := 'PROCESO SATISFACTORIO';
      EXCEPTION
        WHEN OTHERS THEN
          PO_RESPUESTA := -99;
          PO_MENSAJE    := 'ERROR: ' || TO_CHAR(SQLCODE) || ' ' || SQLERRM;
          RAISE WE_ERROR;
      END;
	  
	ELSE
	  --Para los demas 2Play y 3Play
      tim.pp021_venta_lte.sp_generar_inst_venta_app@DBL_BSCS_BF(p_co_id,
                                                            lv_msisdn,
                                                            lv_iccid,
                                                            p_codsolot,
                                                            lv_tip_equ,
                                                            lv_mdl_equ,
                                                            sysdate,
                                                            ln_request_padre,
                                                            ln_request_tv,
                                                            PO_RESPUESTA,
                                                            PO_MENSAJE);

	END IF;

	IF PO_RESPUESTA <> '0' THEN
		RAISE WE_ERROR;
	END IF;
  
  EXCEPTION
    WHEN WE_ERROR THEN
      PO_MENSAJE   := PO_MENSAJE || SQLCODE || ' ' || SQLERRM || ' ' ||
                      DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
    WHEN OTHERS THEN
      PO_RESPUESTA := -1;
      PO_MENSAJE   := 'ERROR: AL GRABAR LAS TRANSACIONES ' || SQLCODE || ' ' || SQLERRM || ' ' ||
                      DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
  END CLRHSS_PROVISIONAR_LTE;
 /*
****************************************************************'
* Nombre SP : CLRHSU_BAJA_DECO_LTE
* Propósito : Baja de Deco de alquiler -  LTE
* Input:   PI_IDAGENDA      - Id Agenda
           PI_DNI_TECNICO   - DNI del tecnico
           PI_NUMSERIE_DECO - Numero de serie Deco
           PI_NUMSERIE_TARJ - Numero tarjeta Deco
* Output:  PO_RESULTADO     - Codigo resultado
           PO_MSGERR        - Mensaje resultado
* Creado por : Wendy Tamayo
* Fec Creación :06/03/2020
* Fec Actualización : --
****************************************************************
*/

PROCEDURE CLRHSU_BAJA_DECO_LTE(PI_IDAGENDA      IN OPERACION.AGENDAMIENTO.IDAGENDA%TYPE,
                               PI_DNI_TECNICO   IN VARCHAR2,
                               PI_NUMSERIE_DECO IN operacion.tabequipo_material.numero_serie%TYPE,
                               PI_NUMSERIE_TARJ IN operacion.tabequipo_material.numero_serie%TYPE,
                               PO_RESULTADO     OUT INTEGER,
                               PO_MSGERR        OUT VARCHAR2) IS

  v_idwf           opewf.wf.idwf%type;
  v_codcon         number;
  v_codsolot       OPERACION.SOLOT.CODSOLOT%TYPE;
  av_obs           agendamientochgest.observacion%type;
  v_tipo           operacion.ope_envio_conax.tipo%type := 2;
  v_codigo         operacion.ope_envio_conax.codigo%type := 1;
  v_unitaddress    operacion.ope_envio_conax.unitaddress%type;
  v_bouquet        operacion.ope_envio_conax.bouquet%type;
  v_numtrans       operacion.ope_envio_conax.numtrans%type;
  v_codinssrv      operacion.ope_envio_conax.CODINSSRV%type;
  po_respuesta     varchar2(100);
  v_tecnico        varchar2(1000);
  v_observacion    operacion.agendamientochgest.observacion%type;
  v_desc_tiptra    operacion.tiptrabajo.descripcion%type;
  v_idtareawf_deco number;
  v_tareadef_deco  number := 10225;
  WE_ERROR EXCEPTION;

BEGIN

  BEGIN
    --SOT, idwf y descripcion del tipo de trabajo
    select s.codsolot, w.idwf, t.descripcion
      into v_codsolot, v_idwf, v_desc_tiptra
      from solot s, agendamiento a, wf w, tiptrabajo t
     where s.codsolot = a.codsolot
       and s.codsolot = w.codsolot
       and s.tiptra = t.tiptra
       and a.idagenda = PI_IDAGENDA;
  
  EXCEPTION
    WHEN OTHERS THEN
      PO_RESULTADO := -1;
      PO_MSGERR    := 'ERROR: NO SE ENCUENTRA CODIGO DE SOT E IDWF';
      RAISE WE_ERROR;
  END;

  /*1. Validacion del tecnico activo, no es necesario esta validacion ya que el
  tecnico se logea por el app y solo podra ingresar si su usuario esta activo.*/

  --2. actualizamos la contrata 
  select t.codcon, t.nombre
    into v_codcon, v_tecnico
    from pvt.tabusuario@dbl_pvtdb t
   where t.NUMDOC = PI_DNI_TECNICO;

  OPERACION.PQ_AGENDAMIENTO.p_asig_contrata(PI_IDAGENDA, v_codcon, av_obs);

  --3. envio a conax: TARJETA 

  operacion.pq_dth.p_ins_envioconax(v_codsolot,
									v_codinssrv,
                                    v_tipo,
                                    PI_NUMSERIE_TARJ,
                                    v_unitaddress,
                                    v_bouquet,
                                    v_numtrans,
                                    v_codigo);
  --4. envio a conax: DECO

  select imei_esn_ua
    into v_unitaddress
    from operacion.tabequipo_material
   where numero_serie = PI_NUMSERIE_DECO;

  operacion.pq_dth.p_ins_envioconax(v_codsolot,
                                    v_codinssrv,
                                    v_tipo,
                                    PI_NUMSERIE_DECO,
                                    v_unitaddress,
                                    v_bouquet,
                                    v_numtrans,
                                    v_codigo);

  --5. Desactivacion tarjeta
  operacion.pq_deco_adicional_lte.SGASU_BAJA_DECO_CONTEGO(v_codsolot,
                                                          PI_NUMSERIE_TARJ,
                                                          po_respuesta,
                                                          PO_MSGERR);
  --6. Desactivacion Deco        
  operacion.pq_deco_adicional_lte.SGASU_BAJA_DECO_CONTEGO(v_codsolot,
                                                          PI_NUMSERIE_DECO,
                                                          po_respuesta,
                                                          PO_MSGERR);

  if (po_respuesta = 'OK') then
  
    --7. Ingreso de plantilla
    v_observacion := 'TIPO DE SOLICITUD: POSTVENTA INALAMBRICO: ' ||
                     CHR(13) || 'TIPO DE TRABAJO: ' || v_desc_tiptra ||
                     CHR(13) || 'SERIE DEL DECODIFICADOR QUE RETIRA: ' ||
                     PI_NUMSERIE_DECO || CHR(13) || 'TARJETA QUE RETIRA: ' ||
                     PI_NUMSERIE_TARJ || CHR(13) || 'ESTADO: ATENDIDO' ||
                     CHR(13) || 'SUBESTADO: ATENDIDA' || CHR(13) ||
                     'TECNICO: ' || v_tecnico || CHR(13) || 'DNI TECNICO: ' ||
                     PI_DNI_TECNICO || CHR(13) ||
                     'OBSERVACIONES: REALIZADO POR APP SERVICIO TECNICO';
  
    select t.idtareawf
      into v_idtareawf_deco
      from tareawf t
     where t.tareadef = v_tareadef_deco
       and t.idwf = v_idwf;
  
    insert into OPEWF.TAREAWFSEG
      (IDTAREAWF, OBSERVACION)
    values
      (v_idtareawf_deco, v_observacion);
  
    commit;
  
    PO_RESULTADO := 0;
    PO_MSGERR    := 'OPERACION EXITOSA';
  
  else
  
    PO_RESULTADO := 2;
    PO_MSGERR    := 'ERROR AL DESACTIVAR DECO';
  
  end if;

exception

  WHEN WE_ERROR THEN
    PO_MSGERR := PO_RESULTADO || SQLCODE || ' ' || SQLERRM || ' ' ||
                 DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
  when others then
    PO_RESULTADO := 1;
    PO_MSGERR    := 'ERROR EN EL FLUJO DE LA BAJA';
  
END CLRHSU_BAJA_DECO_LTE;
  
/*
 ****************************************************************'
* Nombre SP : CLRHSS_LISTA_AGENDA_CHESTADO
* Propósito : Lista de Agendas asociadas a una SOTs para la 
              su cambio de estado
* Input:   PI_NRO_SOT     -  Nro SOT
* Output:  PO_CURSOR      - Lista de Estados de Agendas
           PO_RESULTADO 	- Codigo resultado
           PO_MSGERR   		- Mensaje resultado
* Creado por : Cesar Rengifo
* Fec Creación : 09/03/2020
* Fec Actualización : --
****************************************************************
*/    

PROCEDURE CLRHSS_LISTA_AGENDA_CHESTADO (PI_NRO_SOT      IN OPERACION.SOLOT.CODSOLOT%TYPE,
                                        PO_CURSOR       OUT T_CURSOR,                
                                        PO_RESULTADO    OUT INTEGER,
                                        PO_MSGERR       OUT VARCHAR2) IS

N_IDAGENDA  OPERACION.AGENDAMIENTO.IDAGENDA%TYPE;
N_TIPTRA    OPERACION.SOLOT.TIPTRA%TYPE;

BEGIN

  SELECT A.IDAGENDA, S.TIPTRA
    INTO N_IDAGENDA, N_TIPTRA
    FROM AGENDAMIENTO A, SOLOT S
   WHERE S.CODSOLOT = A.CODSOLOT
     AND S.CODSOLOT = PI_NRO_SOT;

  OPEN PO_CURSOR FOR
    SELECT DISTINCT E1.ESTAGE,
                    AGE.IDAGENDA,
                    SEC.TIPO,
                    E1.DESCRIPCION,
                    E1.ESTFINAL,
                    0 SEL
      FROM ESTAGENDA                          E1,
           OPERACION.SECUENCIA_ESTADOS_AGENDA SEC,
           USUARIOOPE                         USR,
           AGENDAMIENTO                       AGE
     WHERE E1.ESTAGE        = SEC.ESTAGENDAFIN
       AND AGE.TIPO         = SEC.TIPO
       AND SEC.ESTAGENDAINI = AGE.ESTAGE
       AND SEC.TIPTRA       = N_TIPTRA
       AND AGE.IDAGENDA     = N_IDAGENDA
       AND ((USR.CODCON IS NULL) OR
           (USR.CODCON IS NOT NULL AND SEC.APLICA_CONTRATA = 1))
       AND USR.USUARIO = USER
       AND SEC.TIPO = AGE.TIPO;

  PO_RESULTADO := 0;
  PO_MSGERR    := 'OPERACION EXITOSA';

EXCEPTION
  WHEN OTHERS THEN
    PO_RESULTADO := 1;
    PO_MSGERR    := 'ERROR AL CONSULTAR';
  
END CLRHSS_LISTA_AGENDA_CHESTADO;

/*
 ****************************************************************'
* Nombre F : F_OBTENER_TECNICO
* Propósito : Muestra Nombre del Tecnico
* Input:   A_DNITECNICO   -  Nro DNI Tecnico
* Output:  LS_NOMBRE      - Nombre del Tecnico
* Creado por : Cesar Rengifo
* Fec Creación : 31/03/2020
* Fec Actualización : --
****************************************************************
*/    
FUNCTION F_OBTENER_TECNICO(A_DNITECNICO VARCHAR2) RETURN VARCHAR2 IS
LS_NOMBRE VARCHAR2(60);
LN_COUNT       NUMBER;

BEGIN

  SELECT COUNT(*)
    INTO LN_COUNT
    FROM PVT.TABUSUARIO@DBL_PVTDB T
   WHERE T.INSTALACION = 1
     AND T.ESTADO = 1
     AND T.ACTIVO = 'ACTIVO'
     AND T.NUMDOC = A_DNITECNICO;

  IF LN_COUNT > 0 THEN
    SELECT T.NOMBRE
      INTO LS_NOMBRE
      FROM PVT.TABUSUARIO@DBL_PVTDB T
     WHERE T.INSTALACION = 1
       AND T.ESTADO = 1
       AND T.ACTIVO = 'ACTIVO'
       AND T.NUMDOC = A_DNITECNICO;
  ELSE
      LS_NOMBRE :='No Existe DNI Registrado';
  END IF;

  RETURN LS_NOMBRE;

END F_OBTENER_TECNICO;

END;
/