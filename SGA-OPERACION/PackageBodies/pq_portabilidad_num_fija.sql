CREATE OR REPLACE PACKAGE BODY OPERACION.pq_portabilidad_num_fija IS
  /******************************************************************************
    PROPOSITO:

    REVISIONES:
      Version  Fecha       Autor            Solicitado por      Descripcion
      -------  -----       -----            --------------      -----------
      1.0      2014-05-29  Mauro Zegarra    Alberto Miranda     Portabilidad Numerica
                           José Ruiz
      2.0      2014-08-10  José Ruiz        Alberto Miranda     Consulta previa Portabilidad Numerica
      3.0      2014-08-17  José Ruiz        Alberto Miranda     Flujo Credito Manual y Automatico
      4.0      2014-09-08  José Ruiz        Alberto Miranda     Flujo Telefonia Fija (Primarias, Analogicas)
      5.0      2014-09-17  José Ruiz        Alberto Miranda     Validacion Lineas Primarias Generar SEC
      6.0      2014-09-22  José Ruiz        Alberto Miranda     Actulizacion de Portabilidad cuando es mas de 100 lineas
      7.0      2014-10-10  José Ruiz/
                           Freddy Gonzales  Alberto Miranda     Validar registro activo del cliente en el proceso de portabilidad.
      8.0      2014-11-20  Edwin Vasquez    Alberto Miranda     Mejoras Portabilidad CE - Validacion de estado donde se encuentra la SOT
                           Freddy Gonzales                      Mejoras Portabilidad CE - Validacion de numeros rechazados al generar SOT.
      9.0      2014-12-12  Freddy Gonzales  Alberto Miranda     Validar numero telefonico al generar la SOT.
     10.0      2015-03-12  Jose Ruiz        Alberto Miranda     Mejoras Portabilidad TF- Agregar servicio Analog Corporativo y Troncal SIP
     11.0      2016-08-16  Alfonso Muñante  Jessica Villena     Portabilidad de telefonia fija - PORTOUT.
     12.0      2016-11-03  Dorian Sucasaca  Alexander Carnero   Portabilidad Corporativa
     13.0      2017-08-08  Alejandro Milla  Richard Medina      Problemas la generación SOT de Portabilidad, por la dependencia con LDN
     14.0      2017-09-18  Alejandro Milla  Juan Cuya           Error al generar PORT OUT LINEA FIJA     
  /* ****************************************************************************/
  --Capturar el Tipo de servicio para portabilidad (0004, 0044, 0058, 0056, 0073)
  FUNCTION f_captura_servicio(p_tipsrv tystipsrv.tipsrv%TYPE) RETURN NUMBER IS
    l_count PLS_INTEGER;

  BEGIN
    SELECT COUNT(*)
      INTO l_count
      FROM tipopedd c, opedd d
     WHERE c.abrev = 'PORTABILIDAD'
       AND c.tipopedd = d.tipopedd
       AND d.codigoc = p_tipsrv;

    RETURN l_count;
  END;
  /* ****************************************************************************/
  FUNCTION f_validalongen_num(as_numero IN VARCHAR2) RETURN CHAR IS
    lc_rst  CHAR;
    ll_long NUMBER;
  BEGIN

    BEGIN
      SELECT length(as_numero) INTO ll_long FROM dual;
    EXCEPTION
      WHEN no_data_found THEN
        ll_long := 0;
      WHEN OTHERS THEN
        ll_long := 0;
    END;

    IF ll_long = 8 THEN
      lc_rst := 1;
    ELSE
      lc_rst := 0;
    END IF;

    RETURN lc_rst;

  END f_validalongen_num;

  FUNCTION f_validalong_num(as_numero IN VARCHAR2,
                            as_numslc vtatabslcfac.numslc%TYPE) RETURN CHAR IS

    lv_val_longitud CHAR(1);
    lc_rst          CHAR;
    lv_cod          VARCHAR2(2);
    lv_codi         VARCHAR2(2);
    ll_codi         NUMBER;
    ll_long         NUMBER;
    ll_count_cod    NUMBER;
    lv_codigo       VARCHAR2(4);
    l_tipsrv        vtatabslcfac.tipsrv%TYPE; --jr
    l_cod_depart    produccion.plan_numeracion_converter.codigo%TYPE;
    l_cod_dep       NUMBER;

  BEGIN

    SELECT tipsrv INTO l_tipsrv FROM vtatabslcfac WHERE numslc = as_numslc; --11 jr

    l_cod_depart := get_codigo_departamento(as_numslc, l_tipsrv);

    lv_val_longitud := f_validalongen_num(as_numero);

    SELECT substr(l_cod_depart, 1, 1) INTO l_cod_dep FROM dual;

    IF lv_val_longitud = '1' THEN

      SELECT substr(as_numero, 1, 1) INTO lv_cod FROM dual;

      IF lv_cod = '1' THEN

        SELECT length(as_numero) - 1 INTO ll_long FROM dual;

        IF ll_long = 7 AND (to_number(lv_cod) = l_cod_dep) THEN
          IF (l_tipsrv = get_servicio_especial('SERVICIO 0800')) OR
             (l_tipsrv = get_servicio_especial('SERVICIO 0801')) THEN
            lc_rst := 0;
          ELSE
            lc_rst := 1;
          END IF;
        ELSE
          lc_rst := 0;
        END IF;
      ELSE
        SELECT substr(as_numero, 1, 2) INTO lv_cod FROM dual;

        IF lv_cod = '80' THEN

          SELECT substr(as_numero, 1, 3) INTO lv_codigo FROM dual;

          IF l_tipsrv = get_servicio_especial('SERVICIO 0800') THEN
            IF lv_codigo = '800' THEN
              lc_rst := 1;
            ELSE
              lc_rst := 0;
            END IF;
          ELSE
            IF l_tipsrv = get_servicio_especial('SERVICIO 0801') THEN
              IF lv_codigo = '801' THEN
                lc_rst := 1;
              ELSE
                lc_rst := 0;
              END IF;
            ELSE
              lc_rst := 0;
            END IF;
          END IF;

        ELSIF lv_cod != '1' AND lv_cod != '0' THEN

          SELECT length(as_numero) - 2 INTO ll_long FROM dual;

          IF ll_long = 6 THEN

            SELECT substr(as_numero, 1, 2) INTO lv_codi FROM dual;
            ll_codi := to_number(lv_codi);

            SELECT COUNT(1)
              INTO ll_count_cod
              FROM produccion.plan_numeracion_converter
             WHERE codigo = ll_codi;

            IF (ll_count_cod = 1) AND (ll_codi = l_cod_depart) THEN
              IF (l_tipsrv = get_servicio_especial('SERVICIO 0800')) OR
                 (l_tipsrv = get_servicio_especial('SERVICIO 0801')) THEN
                lc_rst := 0;
              ELSE
                lc_rst := 1;
              END IF;
            ELSE
              lc_rst := 0;
            END IF;

          ELSE
            lc_rst := 0;
          END IF;

        END IF;
      END IF;
    ELSE
      lc_rst := 0;
    END IF;

    RETURN lc_rst;

  END f_validalong_num;

  FUNCTION f_consulta_ws_sec RETURN VARCHAR2 IS
    req       UTL_HTTP.req := NULL;
    resp_http UTL_HTTP.resp := NULL;
    respVal   CLOB;
    reqXML    VARCHAR2(32760);
    dato      CLOB;
    dato1     CLOB;
  BEGIN

    /*Generamos la petición Http */
    req := UTL_HTTP.begin_request('http://172.19.74.68:8909/AuditoriaWS/EbsAuditoria', --URL DESTINO
                                  'POST'); --METODO POST
    UTL_HTTP.set_body_charset('UTF-8');
    UTL_HTTP.set_body_charset(req, 'UTF-8');
    /* MENSAJE SOAP  */
    reqXML := '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://pe/com/claro/esb/services/auditoria/ws" xmlns:acc="http://pe/com/claro/esb/services/auditoria/schemas/accesos/Acceso.xsd">
   <soapenv:Header/>
   <soapenv:Body>
      <ws:leerDatosEmpleado>
         <acc:DatosEmpleadoRequest>
            <acc:login>T12640</acc:login>
         </acc:DatosEmpleadoRequest>
      </ws:leerDatosEmpleado>
   </soapenv:Body>
</soapenv:Envelope>';

    /*EL CONTENIDO QUE ENVIAMOS ES XML: */
    UTL_HTTP.set_header(req, 'Content-Type', 'text/xml');
    /*ESTABLECEMOS EL SOAPACTION A INVOCAR: */
    UTL_HTTP.set_header(req, 'SOAPAction', '');
    /*INDICAMOS EN EL HEADER EL TAMAÑO DEL MENSAJE ENVIADO: */
    UTL_HTTP.set_header(req, 'Content-Length', LENGTH(reqxml));
    /*Escrimos la solicitud */
    UTL_HTTP.write_text(req, reqxml);
    /*OBTENEMOS LA RESPUESTA */
    resp_http := UTL_HTTP.get_response(req);
    /*CARGAMOS EN LA VARIABLE RESPVAL LA DEVOLUCIÓN DEL SERVIDOR */
    UTL_HTTP.read_text(resp_http, respVal);
    /*Mostramos el resultado devuelto por el servidor */
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(respVal));
    /*FINALIZAMOS LA CONEXIÓN HTTP */
    UTL_HTTP.end_response(resp_http);

    dato1 := '<env:Envelope xmlns:env="http://schemas.xmlsoap.org/soap/envelope/">';
    dato1 := dato1 || '    <env:Header/> <env:Body>';

    dato := REPLACE(respVal, dato1, '');

    dato := REPLACE(dato, '<?xml version="1.0" encoding="UTF-8"?>', '');
    /*
          dato:= replace(dato,'<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header xmlns:env1="http://claro.com.pe/eai/bs/xsd/postventa/EnvioSms" xmlns:env="http://pe/com/claro/eai/ws/postventa/enviosms"/>','');
          dato:= replace(dato,'<soapenv:Body xmlns:env1="http://claro.com.pe/eai/bs/xsd/postventa/EnvioSms" xmlns:env="http://pe/com/claro/eai/ws/postventa/enviosms"><env:enviarSmsResponse><env1:EnvioSMSResponse><env1:idTransaccion>','');
          dato:= replace(dato,ln_num,'');
          dato:= replace(dato,'</env1:idTransaccion><env1:codigoError>','');
          dato:= replace(dato,'</env1:codigoError><env1:mensajeError/></env1:EnvioSMSResponse></env:enviarSmsResponse></soapenv:Body></soapenv:Envelope>','');
    */
    RETURN dato;
  EXCEPTION
    WHEN UTL_HTTP.end_of_body THEN
      UTL_HTTP.end_response(resp_http);
      DBMS_OUTPUT.PUT_LINE('EXCEPCION UTL_HTTP.end_of_body ');

  END f_consulta_ws_sec;

  FUNCTION f_portabmensaje(codigo sales.portabmsg.cod_msg%TYPE)
    RETURN VARCHAR2 IS

    lv_descripcion sales.portabmsg.descripcion%TYPE;

  BEGIN
    BEGIN
      SELECT descripcion
        INTO lv_descripcion
        FROM sales.portabmsg
       WHERE cod_msg = codigo;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        lv_descripcion := '';

      WHEN OTHERS THEN
        lv_descripcion := '';

    END;

    RETURN lv_descripcion;

  END f_portabmensaje;

  PROCEDURE p_valida_num_fijo(as_numero    IN VARCHAR2,
                              as_documento IN VARCHAR2,
                              an_resultado OUT NUMBER,
                              av_mensaje   OUT VARCHAR2) IS

    ln_validacion_numero NUMBER;
    ln_existe            NUMBER;
    ln_pertenencia       NUMBER;
    ln_susppago          NUMBER;
    ln_suspension        NUMBER;
    ln_cantidad          NUMBER;
    ls_codcli            VARCHAR2(15);
    ln_estado            NUMBER;

  BEGIN

    --1.1 valida longitud de numero telefonico
    ln_validacion_numero := to_number(operacion.pq_portabilidad_num_fija.f_validalongen_num(as_numero));
    IF ln_validacion_numero = 0 THEN
      ln_validacion_numero := 1; --error
      av_mensaje           := f_portabmensaje(ln_validacion_numero);
      an_resultado         := ln_validacion_numero;

      RETURN;
    ELSE
      ln_validacion_numero := -1; --correcto
    END IF;

    --------------------------------
    --1.2 valida existencia de numero
    BEGIN
      SELECT nvl(COUNT(*), 0)
        INTO ln_cantidad
        FROM numtel n
       WHERE n.numero = as_numero;

      IF ln_cantidad = 0 THEN
        ln_existe    := 1; --error
        av_mensaje   := f_portabmensaje(ln_existe);
        an_resultado := ln_existe;

        RETURN;
      ELSE
        ln_existe := -1; --correcto
      END IF;

    EXCEPTION
      WHEN no_data_found THEN
        an_resultado := 1;
        av_mensaje   := f_portabmensaje(an_resultado);
        RETURN;
      WHEN OTHERS THEN
        an_resultado := 1;
        av_mensaje   := f_portabmensaje(an_resultado);
        RETURN;

    END;

    --2. se valida si el documento pertenece a un cliente
    BEGIN
      SELECT codcli
        INTO ls_codcli
        FROM vtatabcli v
       WHERE v.ntdide = as_documento
         AND v.idestado = 1; --7.0

      IF ls_codcli IS NULL THEN
        an_resultado := 2;
        av_mensaje   := f_portabmensaje(an_resultado);
        RETURN;
      END IF;

    EXCEPTION
      WHEN no_data_found THEN
        --ls_codcli := '0';
        an_resultado := 2;
        av_mensaje   := f_portabmensaje(an_resultado);
        RETURN;
      WHEN OTHERS THEN
        --ls_codcli := '0';
        an_resultado := 2;
        av_mensaje   := f_portabmensaje(an_resultado);
        RETURN;
    END;
    ---------------------------------------

    --3. se valida si el numero telefonico pertenece al cliente.
    ln_cantidad := 0;

    BEGIN
      SELECT nvl(COUNT(*), 0)
        INTO ln_cantidad
        FROM inssrv i --, vtatabcli vt
       WHERE --i.codcli = vt.codcli and
       i.codcli = ls_codcli
       AND i.tipinssrv = 3
       AND i.numero = as_numero

       -- ini 13.0
       and i.tipsrv not in ( select o.CODIGOC
                               from tipopedd t, opedd o
                              where t.abrev       = 'PORTABILIDAD_NUM_FIJA'
                                and t.tipopedd    =  o.tipopedd
                                and o.abreviacion = 'VALIDA_NUM_FIJO_LDN' ) ;
       -- fin 13.0

      ---       AND i.estinssrv = 1; --- Validar por JR

      IF ln_cantidad > 0 THEN
        ln_pertenencia := -1; --correcto
      ELSE
        ln_pertenencia := 2; --error
        av_mensaje     := f_portabmensaje(ln_pertenencia);
        an_resultado   := ln_pertenencia;

        RETURN;
      END IF;

    EXCEPTION
      WHEN no_data_found THEN
        an_resultado := 2;
        av_mensaje   := f_portabmensaje(an_resultado);
        RETURN;
      WHEN OTHERS THEN
        an_resultado := 2;
        av_mensaje   := f_portabmensaje(an_resultado);
        RETURN;
    END;
    ----------------------------------------------

    --4. validar si el numero telefonico esta suspendido por falta de pago.
    BEGIN
      SELECT i.estinssrv
        INTO ln_estado
        FROM inssrv i --, vtatabcli vt
       WHERE --i.codcli = vt.codcli and
       i.codcli = ls_codcli
       AND i.tipinssrv = 3
       AND i.numero = as_numero
       AND i.estinssrv = 2; --- Validar por JR--cliente esta suspendido
      --  agregar funcion de de Operaciones

      IF ln_estado = 2 THEN
        TELEFONIA.PQ_PORTABILIDAD.p_valida_cliente_srv(as_numero,
                                                       an_resultado,
                                                       av_mensaje);
        IF an_resultado = 1 THEN
          ln_susppago  := 4; --suspension por falta de Pago
          av_mensaje   := f_portabmensaje(ln_susppago);
          an_resultado := ln_susppago;
        ELSE
          ln_susppago  := 3; --suspension por otro motivo
          av_mensaje   := f_portabmensaje(ln_susppago);
          an_resultado := ln_susppago;
        END IF;
      END IF;

      IF ln_estado = 2 THEN
        ln_suspension := 3; ----error
        av_mensaje    := f_portabmensaje(ln_suspension);
        an_resultado  := ln_suspension;

        RETURN;
      ELSE
        ln_susppago   := -1; --correcto
        ln_suspension := -1; --correcto
      END IF;
      --  END IF;

    EXCEPTION
      WHEN no_data_found THEN
        an_resultado := 0;
        av_mensaje   := f_portabmensaje(an_resultado);
        RETURN;
      WHEN OTHERS THEN
        an_resultado := 4;
        av_mensaje   := f_portabmensaje(an_resultado);
        RETURN;
    END;

    an_resultado := 0;
    av_mensaje   := f_portabmensaje(an_resultado);

  END p_valida_num_fijo;

  FUNCTION f_razon_soc(as_numslc IN VARCHAR2) RETURN VARCHAR2 IS

    lv_cliente VARCHAR2(200);

  BEGIN

    BEGIN
      SELECT vc.nomcli
        INTO lv_cliente
        FROM sales.vtatabslcfac vf
       INNER JOIN vtatabcli vc
          ON vc.codcli = vf.codcli
       WHERE vf.numslc = as_numslc;
    EXCEPTION
      WHEN no_data_found THEN
        lv_cliente := '';
      WHEN OTHERS THEN
        lv_cliente := '';
    END;

    RETURN lv_cliente;

  END f_razon_soc;

  FUNCTION f_tipo_doccli(as_numslc IN VARCHAR2) RETURN CHAR IS

    lv_tipo_doccli CHAR(3);

  BEGIN

    BEGIN
      SELECT vc.tipdide
        INTO lv_tipo_doccli
        FROM sales.vtatabslcfac vf
       INNER JOIN vtatabcli vc
          ON vc.codcli = vf.codcli
       WHERE vf.numslc = as_numslc;
    EXCEPTION
      WHEN no_data_found THEN
        lv_tipo_doccli := '';
      WHEN OTHERS THEN
        lv_tipo_doccli := '';
    END;

    RETURN lv_tipo_doccli;

  END f_tipo_doccli;

  FUNCTION f_num_doccli(as_numslc IN VARCHAR2) RETURN VARCHAR2 IS

    lv_num_doccli VARCHAR2(15);

  BEGIN

    BEGIN
      SELECT vc.ntdide
        INTO lv_num_doccli
        FROM sales.vtatabslcfac vf
       INNER JOIN vtatabcli vc
          ON vc.codcli = vf.codcli
       WHERE vf.numslc = as_numslc;
    EXCEPTION
      WHEN no_data_found THEN
        lv_num_doccli := '';
      WHEN OTHERS THEN
        lv_num_doccli := '';
    END;

    RETURN lv_num_doccli;

  END f_num_doccli;

  PROCEDURE p_insert_sga(as_numproy    IN VARCHAR2,
                         an_idoperador IN NUMBER,
                         as_tram_num   IN VARCHAR2,
                         as_modalidad  IN VARCHAR2,
                         an_resultado  OUT NUMBER,
                         av_mensaje    OUT VARCHAR2) IS
    ln_countnum  NUMBER;
    ln_cant_tram NUMBER;
    ls_numero    numtel.numero%TYPE;
    l_duplicados pls_integer;
    p_msj        varchar2(400);
  BEGIN
    an_resultado := 0;
    av_mensaje   := 'Exito';

    validar_trama_numeros(as_tram_num, p_msj, l_duplicados);

    if l_duplicados = 1 then
      an_resultado := 1;
      av_mensaje   := 'El siguiente número ' || p_msj ||
                      ' esta duplicado en el TXT.';
    else

      SELECT COUNT(*)
        INTO ln_countnum
        FROM sales.porta_num_fijos
       WHERE numslc = as_numproy;

      IF ln_countnum = 0 THEN
        INSERT INTO sales.porta_num_fijos
          (numslc, flg_est, modalidad, idoperador)
        VALUES
          (as_numproy, '1', as_modalidad, an_idoperador);

        --Cantidad de Numeros a Para Consultar
        ln_cant_tram := f_split(as_tram_num, '|', 0);

        FOR i IN 1 .. ln_cant_tram LOOP
          --Capturar el número en Bucle
          ls_numero := f_split(as_tram_num, '|', i);
          --Insertar el proyecto y el número en bucle
          INSERT INTO sales.numeroxporta_num_fijos
            (numslc, numero, flg_est)
          VALUES
            (as_numproy, ls_numero, '1');
        END LOOP;
        COMMIT;

      ELSE
        an_resultado := 1;
        av_mensaje   := 'El Número ya está registrado';
      END IF;
    end if;

  END p_insert_sga;

  PROCEDURE p_update_sga(as_numproy           IN VARCHAR2,
                         as_tram_num          IN VARCHAR2,
                         an_numsec            IN NUMBER,
                         an_num_documento     IN NUMBER,
                         as_tipo_portabilidad IN VARCHAR2,
                         an_resultado         OUT NUMBER,
                         av_mensaje           OUT VARCHAR2) IS

    ln_cant_tram     NUMBER;
    ln_numero        NUMBER;
    lv_valor_tram    VARCHAR2(32767);
    lv_valor_dettram VARCHAR2(32767);

    TYPE t_cabe IS TABLE OF VARCHAR2(1000) INDEX BY BINARY_INTEGER;
    vcamp t_cabe;

  BEGIN

    an_resultado := 0;
    av_mensaje   := 'Exito';

    UPDATE sales.porta_num_fijos
       SET numsec = an_numsec, num_documento = an_num_documento
     WHERE numslc = as_numproy
       AND flg_est = '1';
    --COMMIT; 6.0

    --Cantidad de Tramas a Para Consultar
    ln_cant_tram := f_split(as_tram_num, '|', 0);

    FOR i IN 1 .. ln_cant_tram LOOP
      --Capturar el número en Bucle
      lv_valor_tram := f_split(as_tram_num, '|', i);
      --Insertar el proyecto y el número en bucle

      ln_numero := f_split(lv_valor_tram, ';', 0);

      FOR j IN 1 .. ln_numero LOOP
        lv_valor_dettram := f_split(lv_valor_tram, ';', j);
        vcamp(j) := lv_valor_dettram;
      END LOOP;

      IF as_tipo_portabilidad = 'CP' THEN

        UPDATE sales.numeroxporta_num_fijos
           SET num_consul_previa     = vcamp(2),
               rechazo_consul_previa = vcamp(3),
               cod_mensaje           = vcamp(4),
               deuda                 = vcamp(5),
               fec_venc_fact         = vcamp(6),
               tipo_moneda           = vcamp(7),
               --flg_est               = vcamp(8),
               pksolporta           = vcamp(8),
               identificadormensaje = vcamp(9),
               tproc_codigo         = vcamp(10)
         WHERE numslc = as_numproy
           AND numero = vcamp(1);

      ELSIF as_tipo_portabilidad = 'SP' THEN

        UPDATE sales.numeroxporta_num_fijos
           SET numero_solicitud  = vcamp(2),
               rechazo_solicitud = vcamp(3),
               cod_mensaje       = vcamp(4),
               deuda             = vcamp(5),
               fec_venc_fact     = vcamp(6),
               tipo_moneda       = vcamp(7),
               --flg_est               = vcamp(8),
               pksolporta           = vcamp(8),
               identificadormensaje = vcamp(9),
               tproc_codigo         = vcamp(10)
         WHERE numslc = as_numproy
           AND numero = vcamp(1);

      END IF;

    END LOOP;
    -- COMMIT; 6.0

  END;
  /*****************************************************************************/
  procedure p_envia_consulta_previa(p_numslc    vtatabslcfac.numslc%type,
                                    p_numeros   varchar2,
                                    p_cant_num  number,
                                    p_resultado out number,
                                    p_mensaje   out varchar2,
                                    p_sec       out number) is
    numproy          vtatabslcfac.numslc%type;
    tipdoc           varchar2(2);
    numdoc           vtatabcli.ntdide%type;
    nombrecli        vtatabcli.nomcli%type;
    descriesgo       varchar2(20);
    codigored        varchar2(20);
    tipoprod         varchar2(20);
    cantlineas       number;
    mail             vtatabcli.mail%type;
    l_tipsrv         vtatabslcfac.tipsrv%type;
    l_idproducto     producto.idproducto%type;
    operador         sales.porta_num_fijos.idoperador%type;
    modalidad        sales.porta_num_fijos.modalidad%type;
    telefcontacto    vtatabcli.telefono1%type;
    l_srv_sicact     number(1);
    l_numero_validar varchar2(20);
    l_msg_sot        varchar2(100);
    l_msg_porta      varchar2(1000);
    l_user           varchar2(30);

  begin
    p_resultado := 0;
    p_mensaje   := 'Error';

    select v.tipsrv
      into l_tipsrv
      from vtatabslcfac v
     where v.numslc = p_numslc;

    l_idproducto := get_servicio_producto(p_numslc, l_tipsrv);

    l_srv_sicact := get_srv_sisact(l_tipsrv, l_idproducto);
    l_user       := sales.pq_portabilidad_validacion.get_user();

    select distinct f.numslc,
                    (select lpad(vta.tip_dide, 2, '00')
                       from marketing.vtatipdid vta
                      where vta.tipdide = v.tipdide),
                    v.ntdide,
                    substr(v.nomcli, 1, 40),
                    'tipo de riesgo',
                    l_user,
                    --  'E77281',
                    '02',
                    p_cant_num,
                    v.mail,
                    pf.idoperador,
                    pf.modalidad,
                    f_valida_num_telef_contacto(p_numslc)
      into numproy,
           tipdoc,
           numdoc,
           nombrecli,
           descriesgo,
           codigored,
           tipoprod,
           cantlineas,
           mail,
           operador,
           modalidad,
           telefcontacto
      from SALES.VTATABSLCFAC f
     inner join vtatabcli v
        on v.codcli = f.codcli
     inner join sales.porta_num_fijos pf
        on pf.numslc = f.numslc
     where f.numslc = p_numslc;

    enviar_consulta(p_resultado,
                    p_mensaje,
                    p_sec,
                    numproy,
                    tipdoc,
                    numdoc,
                    nombrecli,
                    descriesgo,
                    codigored,
                    tipoprod,
                    cantlineas,
                    mail,
                    l_srv_sicact,
                    operador,
                    modalidad,
                    telefcontacto,
                    p_numeros);
    commit;

    if p_resultado <> 1 then
      if p_resultado = 25 then
        l_numero_validar := trim(substr(p_mensaje,
                                        instr(p_mensaje, ':', -1, 1) + 1,
                                        20));

        if l_numero_validar is not null then
          sales.pq_portabilidad_validacion.validar(l_numero_validar,
                                                   l_msg_sot,
                                                   l_msg_porta);
          p_mensaje := p_mensaje || l_msg_porta;
        end if;
      end if;

      delete sales.numeroxporta_num_fijos where numslc = p_numslc;
      delete sales.porta_num_fijos where numslc = p_numslc;
      commit;
    end if;

  exception
    when others then
      p_resultado := 0;
      p_mensaje   := 'ERROR ORACLE: ' || TO_CHAR(sqlcode) || '-' || sqlerrm;
      delete sales.numeroxporta_num_fijos where numslc = p_numslc;
      delete sales.porta_num_fijos where numslc = p_numslc;
      commit;
  end;
  --------------------------------------------------------------------------------
  procedure enviar_consulta(p_resultado     out number,
                            p_mensaje       out varchar2,
                            p_sec           out number,
                            p_numslc        char,
                            p_tipdoc        char,
                            p_numdoc        char,
                            p_nombrecli     varchar2,
                            p_descriesgo    varchar2,
                            p_codigored     char,
                            p_tipoprod      char,
                            p_cantlineas    number,
                            p_mail          varchar2,
                            p_srv_sicact    char,
                            p_operador      varchar2,
                            p_modalidad     varchar2,
                            p_telefcontacto varchar2,
                            p_numeros       varchar2) is
    l_str varchar2(32767);

  begin
    l_str := 'begin ';
    l_str := l_str ||
             sales.pq_portabilidad_validacion.get_dblink('consulta_previa');
    l_str := l_str || '(:1, :2, :3, :4, :5, :6, :7, :8, :9, ';
    l_str := l_str || ':10, :11, :12, :13, :14, :15, :16, :17); ';
    l_str := l_str || 'end;';

    execute immediate l_str
      using out p_resultado, out p_mensaje, out p_sec, p_numslc, p_tipdoc, p_numdoc, p_nombrecli, p_descriesgo, p_codigored, p_tipoprod, p_cantlineas, p_mail, p_srv_sicact, p_operador, p_modalidad, p_telefcontacto, p_numeros;

  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit || '.enviar_consulta() ' ||
                              sqlerrm);
  end;
  --------------------------------------------------------------------------------
  FUNCTION get_srv_sisact(p_tipsrv     vtatabslcfac.tipsrv%TYPE,
                          p_idproducto producto.idproducto%TYPE)
    RETURN NUMBER IS
    l_srv_sicact NUMBER(2);

  BEGIN
    if p_tipsrv = '0044' or p_tipsrv = '0056' then
      SELECT d.codigon
        INTO l_srv_sicact
        FROM tipopedd c, opedd d
       WHERE c.abrev = 'PORTABILIDAD'
         AND c.tipopedd = d.tipopedd
         and d.codigon_aux = 1 --5.0
         AND d.codigoc = p_tipsrv;

      RETURN l_srv_sicact;
    else
      SELECT d.codigon
        INTO l_srv_sicact
        FROM tipopedd c, opedd d
       WHERE c.abrev = 'PORTABILIDAD'
         AND c.tipopedd = d.tipopedd
         AND d.codigoc = p_tipsrv;
    end if;
    RETURN l_srv_sicact;

  EXCEPTION
    --coso 0004: fija analogico, fija primario
    WHEN TOO_MANY_ROWS THEN
      SELECT d.codigon
        INTO l_srv_sicact
        FROM tipopedd c, opedd d
       WHERE c.abrev = 'PORTABILIDAD'
         AND c.tipopedd = d.tipopedd
         AND d.abreviacion IN ('PRIMARIO', 'ANALOGICO')
         AND d.codigoc = p_tipsrv
         AND d.codigon_aux = p_idproducto;

      RETURN l_srv_sicact;
  END;
  /* ****************************************************************************/
  FUNCTION f_split(p_cadena VARCHAR2, p_separador VARCHAR2, p_pos NUMBER)
    RETURN VARCHAR2 --split_tbl pipelined
   IS
    l_idx   PLS_INTEGER;
    l_list  VARCHAR2(32767) := p_cadena;
    l_list2 VARCHAR2(32767);
    l_cont  NUMBER := 0;
  BEGIN
    IF p_cadena IS NULL OR p_separador IS NULL OR p_pos IS NULL THEN
      RETURN 'DEBE INGRESAR TODOS LOS CAMPOS';
    END IF;
    LOOP
      l_idx := instr(l_list, p_separador);
      IF l_idx > 0 THEN
        l_cont  := l_cont + 1;
        l_list2 := '';
        l_list2 := substr(l_list, 1, l_idx - 1);
        l_list  := substr(l_list, l_idx + length(p_separador));
        IF l_cont = p_pos AND p_pos > 0 THEN
          RETURN l_list2;
          EXIT;
        END IF;
      END IF;
      IF p_pos > 0 THEN
        IF instr(l_list, p_separador) = 0 THEN
          IF l_cont = p_pos - 1 THEN
            RETURN l_list;
            EXIT;
          ELSIF p_pos - 1 > l_cont THEN
            RETURN '';
            EXIT;
          END IF;
        END IF;
      ELSE
        IF instr(l_list, p_separador) = 0 THEN
          RETURN l_cont + 1;
        END IF;

      END IF;
    END LOOP;
  END;
  /* ****************************************************************************/
  procedure p_insert_numtel_reservatel(as_numproy vtatabslcfac.numslc%type,
                                       as_numero  numtel.numero%type) is
    l_codcli    vtatabcli.codcli%type;
    l_codnumtel numtel.codnumtel%type;
    ln_val_port number;   -- 12.0 Port Corporativa
  begin
    select codcli
      into l_codcli
      from vtatabslcfac
     where numslc = as_numproy;

    /*Inicio Port Corporativa  12.0*/
    select count(1)
      into ln_val_port
      from telefonia.porta_f_abdcp p
     where p.numero_tel   = as_numero
       and p.flag_portout = 1;

    if ln_val_port = 1 then
      update telefonia.porta_f_abdcp p
         set p.flag_portout = 0
       where p.numero_tel   = as_numero;
    end if ;
    /*Fin Port Corporativa 12.0*/

    if esta_registrado_numtel(as_numero) then
      update_numtel(as_numero, l_codnumtel);
    else
      insert_numtel(as_numero, l_codnumtel);
    end if;

    if esta_registrado_reservatel(l_codnumtel) then
      update_reservatel(l_codnumtel, as_numproy, l_codcli);
    else
      insert_reservatel(l_codnumtel, as_numproy, l_codcli);
    end if;

    commit;

  exception
    when others then
      RAISE_APPLICATION_ERROR(-20000,
                              $$plsql_unit ||
                              '.P_INSERT_NUMTEL_RESERVATEL: ' || sqlerrm);
      rollback;
  end;
  --------------------------------------------------------------------------------
  function esta_registrado_numtel(p_numero numtel.numero%type) return boolean is
    l_count pls_integer;

  begin
    select count(*) into l_count from numtel t where t.numero = p_numero;

    return l_count > 0;
  end;
  --------------------------------------------------------------------------------
  procedure update_numtel(p_numero    numtel.numero%type,
                          p_codnumtel out numtel.codnumtel%type) is

  begin
    update numtel t
       set t.estnumtel = 2 --Asignado
     where t.numero = p_numero
    returning codnumtel into p_codnumtel;
  end;
  --------------------------------------------------------------------------------
  procedure insert_numtel(p_numero    numtel.numero%type,
                          p_codnumtel out numtel.codnumtel%type) is
    l_numtel numtel%rowtype;

  begin
    l_numtel.estnumtel    := 2; --Asignado
    l_numtel.tipnumtel    := 1; --Normal
    l_numtel.numero       := p_numero;
    l_numtel.fecusu       := sysdate;
    l_numtel.codusu       := user;
    l_numtel.fecusumod    := sysdate;
    l_numtel.codusumod    := user;
    l_numtel.publicar     := 0;
    l_numtel.flg_portable := 1;

    insert into numtel
    values l_numtel
    returning codnumtel into p_codnumtel;

  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit || '.INSERT_NUMTEL(): ' ||
                              sqlerrm);
  end;
  --------------------------------------------------------------------------------
  function esta_registrado_reservatel(p_codnumtel reservatel.codnumtel%type)
    return boolean is

    l_count pls_integer;

  begin
    select count(*)
      into l_count
      from reservatel r
     where r.codnumtel = p_codnumtel;

    return l_count > 0;
  end;
  --------------------------------------------------------------------------------
  procedure update_reservatel(p_codnumtel reservatel.codnumtel%type,
                              p_numslc    vtatabslcfac.numslc%type,
                              p_codcli    vtatabslcfac.codcli%type) is
    lv_numpto varchar2(10);

  begin
    lv_numpto := f_busca_numpto(p_numslc);
    update reservatel
       set estnumtel = 5,
           numslc    = p_numslc,
           codcli    = p_codcli,
           numpto    = lv_numpto
     where codnumtel = p_codnumtel;
  end;
  --------------------------------------------------------------------------------
  procedure insert_reservatel(p_codnumtel reservatel.codnumtel%type,
                              p_numslc    vtatabslcfac.numslc%type,
                              p_codcli    vtatabslcfac.codcli%type) is
    l_reservatel reservatel%rowtype;
    lv_numpto    varchar2(10);

  begin
    lv_numpto              := f_busca_numpto(p_numslc);
    l_reservatel.codnumtel := p_codnumtel;
    l_reservatel.numslc    := p_numslc;
    l_reservatel.numpto    := lv_numpto;
    l_reservatel.valido    := 1;
    l_reservatel.estnumtel := 5; --Reserva Temporal
    l_reservatel.codcli    := p_codcli;
    l_reservatel.fecinires := sysdate;
    l_reservatel.codusures := user;
    l_reservatel.publicar  := 0;

    insert into reservatel values l_reservatel;

  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit || '.INSERT_RESERVATEL(): ' ||
                              sqlerrm);
  end;
  --------------------------------------------------------------------------------
  FUNCTION f_busca_numpto(as_numslc IN VARCHAR2) RETURN VARCHAR2 IS
    ls_numpto vtadetptoenl.numpto%TYPE;
    ln_numpto NUMBER;

    CURSOR CUR_NUMPTO IS
      SELECT a.numpto numpto, a.cantidad cantidad
        FROM vtadetptoenl a, tystabsrv b, producto c, vtatabslcfac e
       WHERE a.codsrv = b.codsrv
         AND b.idproducto = c.idproducto
         AND a.numslc = e.numslc
         AND a.numslc = as_numslc
         AND c.idtipinstserv = 3
         AND a.flgsrv_pri = 1
       ORDER BY a.numpto;
  BEGIN

    FOR C IN CUR_NUMPTO LOOP
      ls_numpto := c.numpto;

      SELECT COUNT(1)
        INTO ln_numpto
        FROM reservatel
       WHERE numslc = as_numslc
         AND numpto = ls_numpto;

      IF ln_numpto <= 0 THEN
        EXIT;
      ELSE
        IF ln_numpto < c.cantidad THEN
          EXIT;
        END IF;
      END IF;

    END LOOP;

    RETURN ls_numpto;
  END;
  /* ****************************************************************************/

  procedure p_elimina_detalle_sef(as_numslc        varchar2,
                                  p_num_rechazados number default null)

   is
    ln_num_solicitud     number;
    ln_cantidad_detalle  number;
    ln_diferencia_lineas number;
    ls_mayor             varchar2(1);
    ln_cant_adicionales  number;
    ln_maximo_reg        number;
    ls_numpto            vtadetptoenl.numpto%type;
    ln_total_restar      number;

  begin

    /* se saca la cantidad de numeros ingresada en la tabla de portabilidad*/
    select count(num_consul_previa)
      into ln_num_solicitud
      from sales.numeroxporta_num_fijos
     where numslc = as_numslc
       and trim(rechazo_consul_previa) is null;

    /*se saca la cantida de registros de la tabla detalle */
    select nvl(sum(a.cantidad), 0)
      into ln_cantidad_detalle
      from vtadetptoenl a, tystabsrv b, producto c
     where a.codsrv = b.codsrv
       and b.idproducto = c.idproducto
       and a.numslc = as_numslc
       and c.idtipinstserv = 3;

    if p_num_rechazados > 0 then
      ln_num_solicitud := ln_num_solicitud + p_num_rechazados;
    end if;

    -- //si los datos son diferentes se procede a eliminar un registro o quitar un valor a la cantidad del detalle.
    if ln_num_solicitud <> ln_cantidad_detalle then

      --//se saca la diferencia entre el detalle del proyecto y los numero a insertar en la sot./*****/
      ln_diferencia_lineas := ln_cantidad_detalle - ln_num_solicitud;

      ls_mayor := 'S';
      loop
        exit when ls_mayor = 'N';
        --//Se valida si hay numeros adicionales
        select count(*)
          into ln_cant_adicionales
          from vtadetptoenl a, tystabsrv b, producto c
         where a.codsrv = b.codsrv
           and b.idproducto = c.idproducto
           and a.numslc = as_numslc
           and c.idtipinstserv = 3
           and a.flgsrv_pri = 0;

        if ln_cant_adicionales > 0 then
          --//si tiene numeros adicionales
          select max(a.cantidad)
            into ln_maximo_reg
            from vtadetptoenl a, tystabsrv b, producto c
           where a.codsrv = b.codsrv
             and b.idproducto = c.idproducto
             and a.numslc = as_numslc
             and c.idtipinstserv = 3
             and a.flgsrv_pri = 0;

          select max(a.numpto)
            into ls_numpto
            from vtadetptoenl a, tystabsrv b, producto c
           where a.codsrv = b.codsrv
             and b.idproducto = c.idproducto
             and a.numslc = as_numslc
             and c.idtipinstserv = 3
             and a.flgsrv_pri = 0
             and a.cantidad = ln_maximo_reg;

          if ln_maximo_reg > ln_diferencia_lineas then
            --//cuando es mayor
            ls_mayor        := 'N';
            ln_total_restar := ln_maximo_reg - ln_diferencia_lineas;
            update vtadetptoenl
               set cantidad = ln_total_restar
             where numslc = as_numslc
               and numpto = ls_numpto;
            commit;

          elsif ln_maximo_reg = ln_diferencia_lineas then
            --//cuando es igual
            delete vtadetptoenl -- //aqui va el delete
             where numslc = as_numslc
               and numpto = ls_numpto;
            commit;

            select nvl(sum(a.cantidad), 0)
              into ln_cantidad_detalle
              from vtadetptoenl a, tystabsrv b, producto c
             where a.codsrv = b.codsrv
               and b.idproducto = c.idproducto
               and a.numslc = as_numslc
               and c.idtipinstserv = 3;

            ln_diferencia_lineas := ln_cantidad_detalle - ln_num_solicitud;

          else
            -- //Delete vtadetptoenl --//aqui va el otro delete y falta las lineas que sobran
            delete vtadetptoenl --//aqui va el delete
             where numslc = as_numslc
               and numpto = ls_numpto;
            commit;

            select nvl(sum(a.cantidad), 0)
              into ln_cantidad_detalle
              from vtadetptoenl a, tystabsrv b, producto c
             where a.codsrv = b.codsrv
               and b.idproducto = c.idproducto
               and a.numslc = as_numslc
               and c.idtipinstserv = 3;

            ln_diferencia_lineas := ln_cantidad_detalle - ln_num_solicitud;

          end if;
          commit;
        else
          select max(a.cantidad)
            into ln_maximo_reg
            from vtadetptoenl a, tystabsrv b, producto c
           where a.codsrv = b.codsrv
             and b.idproducto = c.idproducto
             and a.numslc = as_numslc
             and c.idtipinstserv = 3
             and a.flgsrv_pri = 1;

          select max(a.numpto) --//a.iddet //para sacar el iddet (id detalle) del maximo
            into ls_numpto
            from vtadetptoenl a, tystabsrv b, producto c
           where a.codsrv = b.codsrv
             and b.idproducto = c.idproducto
             and a.numslc = as_numslc
             and c.idtipinstserv = 3
             and a.flgsrv_pri = 1
             and a.cantidad = ln_maximo_reg;

          if ln_maximo_reg > ln_diferencia_lineas then
            --//cuando es mayor
            ls_mayor        := 'N';
            ln_total_restar := ln_maximo_reg - ln_diferencia_lineas;
            update vtadetptoenl
               set cantidad = ln_total_restar
             where numslc = as_numslc
               and numpto = ls_numpto;
            commit;

          elsif ln_maximo_reg = ln_diferencia_lineas then
            --//cuando es igual
            delete vtadetptoenl --aqui va el delete
             where numslc = as_numslc
               and numpto = ls_numpto;
            commit;

            select nvl(sum(a.cantidad), 0)
              into ln_cantidad_detalle
              from vtadetptoenl a, tystabsrv b, producto c
             where a.codsrv = b.codsrv
               and b.idproducto = c.idproducto
               and a.numslc = as_numslc
               and c.idtipinstserv = 3;

            ln_diferencia_lineas := ln_cantidad_detalle - ln_num_solicitud;

          else

            delete vtadetptoenl --//aqui va el delete
             where numslc = as_numslc
               and numpto = ls_numpto;
            commit;

            select nvl(sum(a.cantidad), 0)
              into ln_cantidad_detalle
              from vtadetptoenl a, tystabsrv b, producto c
             where a.codsrv = b.codsrv
               and b.idproducto = c.idproducto
               and a.numslc = as_numslc
               and c.idtipinstserv = 3;

            ln_diferencia_lineas := ln_cantidad_detalle - ln_num_solicitud;

          end if;
        end if;
      end loop;
    end if;
  exception
    when others then
      RAISE_APPLICATION_ERROR(-20000,
                              $$plsql_unit || '.P_ELIMINA_DETALLE_SEF: ' ||
                              sqlerrm);
  end;

  /* ***************************************************************************/
  PROCEDURE portabilidad(p_numslc    vtatabslcfac.numslc%TYPE,
                         p_msg_sot   OUT VARCHAR2,
                         p_msg_porta OUT VARCHAR2) IS
    l_tipsrv sales.vtatabslcfac.tipsrv%TYPE;
  BEGIN
    /**************************FIJA****************/
    --capturamos el tipo de servicio
    select tipsrv into l_tipsrv from vtatabslcfac where numslc = p_numslc;

    IF es_fija_o_especial(l_tipsrv) THEN
      --portabilidad_fija(p_numslc, p_msg_sot, p_msg_porta);
      p_msg_sot   := 'CONTINUAR';
      p_msg_porta := 'CONTINUAR';
    ELSE
      --FIJA
      IF es_credito_manual(p_numslc) THEN
        credito_manual(p_numslc, p_msg_sot, p_msg_porta);
      ELSE
        credito_automatico(p_numslc, p_msg_sot, p_msg_porta);
      END IF;
    END IF; -- FIJA

  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.PORTABILIDAD: ' || SQLERRM);
  END;
  /* ***************************************************************************/
  FUNCTION es_credito_manual(p_numslc vtatabslcfac.numslc%TYPE)
    RETURN BOOLEAN IS
    l_flgcredito vtatabmotivo_venta.flg_creditos%TYPE;

  BEGIN
    SELECT b.flg_creditos
      INTO l_flgcredito
      FROM vtatabprecon a, vtatabmotivo_venta b
     WHERE a.codmotivo_tf = b.codmotivo
       AND a.numslc = p_numslc;

    IF l_flgcredito = 0 THEN
      RETURN TRUE;
    ELSIF l_flgcredito = 1 THEN
      RETURN FALSE;
    END IF;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.ES_CREDITO_MANUAL: ' ||
                              SQLERRM);
  END;
  /* ***************************************************************************/
  PROCEDURE credito_manual(p_numslc    vtatabslcfac.numslc%TYPE,
                           p_msg_sot   OUT VARCHAR2,
                           p_msg_porta OUT VARCHAR2) IS
  BEGIN
    IF NOT esta_registrado(p_numslc) THEN
      crear_cxcpspchq_pendiente(p_numslc);
      p_msg_sot   := 'DETENER';
      p_msg_porta := 'En el modulo de Creditos se encuentra Pendiente';
    END IF;

    IF NOT esta_aprobado(p_numslc) THEN
      p_msg_sot   := 'DETENER';
      p_msg_porta := 'En el modulo de Creditos no se encuentra Aprobado';
      RETURN;
    END IF;

    credito_comun(p_numslc, p_msg_sot, p_msg_porta);
  END;
  /* ***************************************************************************/
  PROCEDURE credito_automatico(p_numslc    vtatabslcfac.numslc%TYPE,
                               p_msg_sot   OUT VARCHAR2,
                               p_msg_porta OUT VARCHAR2) IS
  BEGIN
    p_valida_aprob_creditos(p_numslc);
    credito_comun(p_numslc, p_msg_sot, p_msg_porta);
  END;

  --------------------------------------------------------------------------------
  function tiene_respuesta(p_numslc         vtatabslcfac.numslc%type,
                           p_num_rechazados number default null)
    return boolean is
    l_count pls_integer;

  begin
    --numeros no rechazados
    --para validar que haya una respuesta de Solicitud de Portabilidad para los numeros enviados.
    select count(t.num_consul_previa)
      into l_count
      from sales.numeroxporta_num_fijos t
     where numslc = p_numslc
       and trim(rechazo_consul_previa) is null;

    if p_num_rechazados > 0 then
      l_count := l_count + p_num_rechazados;
    end if;

    return l_count > 0;
  end;
  --------------------------------------------------------------------------------
  FUNCTION tiene_sec(p_numslc vtatabslcfac.numslc%TYPE) RETURN BOOLEAN IS
    l_count PLS_INTEGER;

  BEGIN
    --se verifica que tenga datos de portabilidad
    SELECT COUNT(*)
      INTO l_count
      FROM sales.porta_num_fijos t
     WHERE t.numslc = p_numslc;

    RETURN l_count > 0;
  END;
  /* ***************************************************************************/
  PROCEDURE crear_cxcpspchq_pendiente(p_numslc vtatabslcfac.numslc%TYPE) IS
  BEGIN
    p_valida_aprob_creditos(p_numslc);
    update_cxcpspchq(p_numslc);
  END;
  /* ***************************************************************************/
  PROCEDURE update_cxcpspchq(p_numslc vtatabslcfac.numslc%TYPE) IS
  BEGIN
    UPDATE cxcpspchq
       SET estapr = 'P', obscre = 'Proyecto Pendiente'
     WHERE numslc = p_numslc;

    COMMIT;
  END;
  --------------------------------------------------------------------------------
  procedure credito_comun(p_numslc    vtatabslcfac.numslc%type,
                          p_msg_sot   out varchar2,
                          p_msg_porta out varchar2) is

    p_num_rechazados number := 0;
    l_retorno        number := 0;
    l_msg_sot        varchar2(100);
    l_msg_porta      varchar2(1000);
    num_reg          number := 0;  ---12.0

  begin
    if not tiene_sec(p_numslc) then
      p_msg_sot   := 'DETENER';
      p_msg_porta := 'Favor de Proceder a Generar la SEC';
      return;
    end if;

    -- ini 12.0
    select count(*)
      into num_reg
      from sales.numeroxporta_num_fijos
     where numslc = p_numslc;
    -- Fin 12.0

    if tiene_rechazo(p_numslc) and num_reg =  1 then -- 12.0 Portabilidad Corporativa
      if sales.pq_portabilidad_validacion.es_ce_hfc(p_numslc) then
        l_retorno := verifica_rechazo_autorizados(p_numslc,
                                                  p_num_rechazados);
        /*****
          1  Rechazos sin Autorizacion.
          0  Rechazos Autorizados.
         -1 Servicio Configurado y Rechazos con Autorizacion pero Usuario no Configurado.
        *****/
        if l_retorno = -1 then
          p_msg_sot   := 'DETENER';
          p_msg_porta := 'El usuario: ' || user ||
                         ' no esta configurado para generar SOT con rechazos autorizados.';
          return;
        end if;

        if l_retorno = 1 then
          p_msg_sot   := 'DETENER';
          p_msg_porta := 'Existen numeros rechazados por el ABDCP. No se podra generar la SOT.';
          return;
        end if;

        if l_retorno = 0 then
          if not estan_todos_rechazados_auto(p_numslc, p_num_rechazados) then
            p_msg_sot   := 'DETENER';
            p_msg_porta := 'Existen numeros rechazados por el ABDCP no autorizados. ' ||
                           'No se podra generar la SOT.';
            return;
          end if;
        end if;
      else
        if estan_todos_rechazados(p_numslc) then
          p_msg_sot   := 'DETENER';
          p_msg_porta := 'Todos los numeros han sido rechazados por el ABDCP';
          return;
        ELSE
          p_msg_sot   := 'DETENER';
          p_msg_porta := 'Existen numeros rechazados por el ABDCP. No se podra generar la SOT';
          RETURN;
        end if;
      end if;
    end if;
    -- Inicio 12.0 Portabilidad Corporativa
/*      if not tiene_respuesta(p_numslc, p_num_rechazados) then
      p_msg_sot   := 'DETENER';
      p_msg_porta := 'El Proyecto es de Portabilidad y necesita tener ' ||
                     'la respuesta del ABDCP de los números a Portar';
      return;
      end if;*/
    -- Fin 12.0 Portabilidad Corporativa
    if sales.pq_portabilidad_validacion.es_ce_hfc(p_numslc) then
      if tiene_numero_asignado(p_numslc, l_msg_sot, l_msg_porta) then
        p_msg_sot   := l_msg_sot;
        p_msg_porta := 'TELEFONO YA REGISTRADO ' || l_msg_porta;
        return;
      end if;
    end if;

    --p_elimina_detalle_sef(p_numslc, p_num_rechazados);

    if p_num_rechazados > 0 then
      reservar_numeros_con_rechazos(p_numslc);
    else
      reservar_numeros(p_numslc);
    end if;

    p_msg_sot   := 'CONTINUAR';
    p_msg_porta := 'CONTINUAR';
  end;
  --------------------------------------------------------------------------------
  function verifica_rechazo_autorizados(p_numslc              vtatabslcfac.numslc%type,
                                        p_cant_num_rechazados out number)
    return number is
  begin

    if not tiene_rechazos_autorizados(p_numslc, p_cant_num_rechazados) then
      p_cant_num_rechazados := 0;
      return 1;
    end if;

    if not esta_registrado_usuario then
      return - 1;
    end if;

    return 0;

  end;
  --------------------------------------------------------------------------------
  function tiene_rechazos_autorizados(p_numslc         vtatabslcfac.numslc%type,
                                      p_num_rechazados out number)
    return boolean is
  begin

    select count(1)
      into p_num_rechazados
      from sales.numeroxporta_num_fijos n
     where n.numslc = p_numslc
       and exists (select 1
              from tipopedd t, opedd d
             where t.tipopedd = d.tipopedd
               and t.abrev = 'PORTABILIDAD_MSG_CP'
               and codigon_aux = 1 --Habilita codigo con rechazo autorizado
               and d.abreviacion = n.rechazo_consul_previa)
       and exists (select 1
              from tipopedd t, opedd d
             where t.tipopedd = d.tipopedd
               and t.abrev = 'PORTABILIDAD_MSG'
               and codigon_aux = 1 --Habilita mensaje autorizado
               and d.abreviacion = n.cod_mensaje);

    return p_num_rechazados > 0;
  end;
  --------------------------------------------------------------------------------
  function esta_registrado_usuario return boolean is
    l_count number;
  begin
    select count(1)
      into l_count
      from tipopedd t, opedd d
     where t.tipopedd = d.tipopedd
       and t.abrev = 'PORTABILIDAD_USERS_AUTO'
       and d.abreviacion = user;

    return l_count > 0;
  end;
  --------------------------------------------------------------------------------
  function estan_todos_rechazados_auto(p_numslc              vtatabslcfac.numslc%type,
                                       p_num_rechazados_auto number)
    return boolean is

    l_rechazos pls_integer;
  begin

    select count(t.rechazo_consul_previa)
      into l_rechazos
      from sales.numeroxporta_num_fijos t
     where t.numslc = p_numslc
       and trim(t.rechazo_consul_previa) is not null;

    if p_num_rechazados_auto < l_rechazos then
      return false; -- Existen rechazos no autorizados
    end if;

    return true;
  end;
  --------------------------------------------------------------------------------
  function estan_todos_rechazados(p_numslc vtatabslcfac.numslc%type)
    return boolean is

    l_consulta pls_integer;
    l_rechazo  pls_integer;

  begin
    select count(t.num_consul_previa)
      into l_consulta
      from sales.numeroxporta_num_fijos t
     where t.numslc = p_numslc
       and t.num_consul_previa is not null;

    select count(t.rechazo_consul_previa)
      into l_rechazo
      from sales.numeroxporta_num_fijos t
     where t.numslc = p_numslc
       and trim(t.rechazo_consul_previa) is not null;

    if l_consulta > 0 then
      if l_consulta = l_rechazo then
        return true; --todos han sido rechazados
      end if;
    end if;

    return false;
  end;
  --------------------------------------------------------------------------------
  function tiene_numero_asignado(p_numslc    vtatabslcfac.numslc%type,
                                 p_msg_solot out varchar2,
                                 p_msg_porta out varchar2) return boolean is
    cursor numeros is
      select n.numero
        from sales.numeroxporta_num_fijos n
       where n.numslc = p_numslc;
  begin
    for num in numeros loop
      sales.pq_portabilidad_validacion.validar(num.numero,
                                               p_msg_solot,
                                               p_msg_porta);
      if p_msg_solot = 'DETENER' then
        return true;
      end if;
    end loop;

    return false;

  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit ||
                              '.tiene_numero_asignado(p_numslc => ' ||
                              p_numslc || sqlerrm);

  end;
  --------------------------------------------------------------------------------
  procedure reservar_numeros_con_rechazos(p_numslc vtatabslcfac.numslc%type) is

    cursor c_num_porta is
      select n.numero
        from sales.numeroxporta_num_fijos n
       where n.numslc = p_numslc
         and trim(rechazo_consul_previa) is null
      union
      select n.numero
        from sales.numeroxporta_num_fijos n
       where n.numslc = p_numslc
         and exists (select 1
                from tipopedd t, opedd d
               where t.tipopedd = d.tipopedd
                 and t.abrev = 'PORTABILIDAD_MSG_CP'
                 and codigon_aux = 1 --Habilita codigo rechazo autorizado
                 and d.abreviacion = n.rechazo_consul_previa)
         and exists (select 1
                from tipopedd t, opedd d
               where t.tipopedd = d.tipopedd
                 and t.abrev = 'PORTABILIDAD_MSG'
                 and codigon_aux = 1 --Habilita codigo rechazo autorizado
                 and d.abreviacion = n.cod_mensaje);
  begin
    for r_num_porta in c_num_porta loop
      p_insert_numtel_reservatel(p_numslc, r_num_porta.numero);
    end loop;

  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit ||
                              '.RESERVAR_NUMEROS_CON_RECHAZOS: ' || sqlerrm);
  end;
  --------------------------------------------------------------------------------
  PROCEDURE reservar_numeros(p_numslc vtatabslcfac.numslc%TYPE) IS

    CURSOR c_num_porta IS
      SELECT numero
        FROM sales.numeroxporta_num_fijos
       WHERE numslc = p_numslc
         AND TRIM(rechazo_consul_previa) IS NULL;

  BEGIN
    FOR r_num_porta IN c_num_porta LOOP
      p_insert_numtel_reservatel(p_numslc, r_num_porta.numero);
    END LOOP;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.RESERVAR_NUMEROS: ' ||
                              SQLERRM);
  END;
  /* ***************************************************************************/
  FUNCTION esta_aprobado(p_numslc vtatabslcfac.numslc%TYPE) RETURN BOOLEAN IS
    l_estapr cxcpspchq.estapr%TYPE;

  BEGIN
    SELECT t.estapr
      INTO l_estapr
      FROM cxcpspchq t
     WHERE t.numslc = p_numslc;

    IF l_estapr = 'A' THEN
      RETURN TRUE;
    ELSE
      RETURN FALSE;
    END IF;
  END;
  /* ***************************************************************************/
  FUNCTION esta_registrado(p_numslc vtatabslcfac.numslc%TYPE) RETURN BOOLEAN IS
    l_count PLS_INTEGER;

  BEGIN
    SELECT COUNT(*)
      INTO l_count
      FROM cxcpspchq t
     WHERE t.numslc = p_numslc;

    RETURN l_count > 0;
  END;
  /* ***************************************************************************/
  PROCEDURE credito_comun_fija(p_numslc    vtatabslcfac.numslc%TYPE,
                               p_msg_sot   OUT VARCHAR2,
                               p_msg_porta OUT VARCHAR2) IS
    ls_estsolfac     sales.vtatabslcfac.estsolfac%TYPE;
    li_estef         operacion.ef.estef%TYPE;
    li_analisis_rent operacion.ar.estar%TYPE;
  BEGIN
    BEGIN
      select estsolfac
        into ls_estsolfac
        from vtatabslcfac
       where numslc = p_numslc;

      IF ls_estsolfac <> '03' THEN
        --Verificamos que el proyecto este Aprobado por Gerencia Comercial
        p_msg_sot   := 'DETENER';
        p_msg_porta := 'Generar la Aprobación por Gerencia Comercial';
        RETURN;
      END IF;
    EXCEPTION
      WHEN OTHERS THEN
        p_msg_sot   := 'DETENER';
        p_msg_porta := 'Generar la Aprobación por Gerencia Comercial';
        RETURN;
    END;
    BEGIN
      select estef into li_estef from ef where numslc = p_numslc;

      IF li_estef <> 2 THEN
        --Verificamos que el proyecto tenga estudio de factibilidad
        p_msg_sot   := 'DETENER';
        p_msg_porta := 'Falta el Estudio de Factibilidad';
        RETURN;
      END IF;
    EXCEPTION
      WHEN OTHERS THEN
        p_msg_sot   := 'DETENER';
        p_msg_porta := 'Falta el Estudio de Factibilidad';
        RETURN;
    END;

    BEGIN
      select estar
        into li_analisis_rent
        from ar
       where codef = (select codef from ef where numslc = p_numslc);

      IF li_analisis_rent <> 3 THEN
        --se verifica la Aprobación del Analisis de Rentabilidad
        p_msg_sot   := 'DETENER';
        p_msg_porta := 'Falta la Aprobación del Analisis de Rentabilidad';
        RETURN;
      END IF;

    EXCEPTION
      WHEN OTHERS THEN
        p_msg_sot   := 'DETENER';
        p_msg_porta := 'Falta la Aprobación del Analisis de Rentabilidad';
        RETURN;
    END;

    IF NOT tiene_sec(p_numslc) THEN
      p_msg_sot   := 'DETENER';
      p_msg_porta := 'Favor de Proceder a Generar la SEC';
      RETURN;
    END IF;

    IF tiene_rechazo(p_numslc) THEN
      p_msg_sot   := 'DETENER';
      p_msg_porta := 'Todos los numeros han sido rechazados por el ABDCP';
      RETURN;
    END IF;

    IF NOT tiene_respuesta(p_numslc) THEN
      p_msg_sot   := 'DETENER';
      p_msg_porta := 'El Proyecto es de Portabilidad y necesita tener ' ||
                     'la respuesta del ABDCP de los números a Portar';
      RETURN;
    END IF;

    p_msg_sot   := 'CONTINUAR';
    p_msg_porta := 'CONTINUAR';
  END;

  /* ***************************************************************************/
  PROCEDURE portabilidad_fija(p_numslc    vtatabslcfac.numslc%TYPE,
                              p_msg_sot   OUT VARCHAR2,
                              p_msg_porta OUT VARCHAR2) IS
    ls_estsolfac sales.vtatabslcfac.estsolfac%TYPE;

  BEGIN
    BEGIN
      select estsolfac
        into ls_estsolfac
        from vtatabslcfac
       where numslc = p_numslc;

      IF ls_estsolfac <> '03' THEN
        --Verificamos que el proyecto este Aprobado por Gerencia Comercial
        p_msg_sot   := 'DETENER';
        p_msg_porta := 'Generar la Aprobación por Gerencia Comercial';
        RETURN;
      END IF;

    EXCEPTION
      WHEN OTHERS THEN
        p_msg_sot   := 'DETENER';
        p_msg_porta := 'Generar la Aprobación por Gerencia Comercial';
        RETURN;
    END;

    IF NOT esta_aprobado(p_numslc) THEN
      p_msg_sot   := 'DETENER';
      p_msg_porta := 'En el modulo de Creditos no se encuentra Aprobado';
      RETURN;
    ELSE
      --VALIDACIONES DE PORTABILIDAD
      credito_comun_fija(p_numslc, p_msg_sot, p_msg_porta);
      --p_msg_sot   := 'CONTINUAR';
      --p_msg_porta := 'CONTINUAR';
    END IF;

    --  End if;

  END;
  /* ***************************************************************************/
  PROCEDURE portabilidad_fija_contrato(p_numslc    vtatabslcfac.numslc%TYPE,
                                       p_msg_sot   OUT VARCHAR2,
                                       p_msg_porta OUT VARCHAR2) IS
  BEGIN

    /*IF NOT esta_registrado(p_numslc) THEN
       l_mensaje := sales.pq_valida_proyecto.f_valida_checkproy(p_numslc);

    END IF;*/
    --   if l_mensaje= 'OK' then
    credito_comun(p_numslc, p_msg_sot, p_msg_porta);

    /* IF NOT esta_aprobado(p_numslc) THEN
                    p_msg_sot   := 'DETENER';
                    p_msg_porta := 'En el modulo de Creditos no se encuentra Aprobado';
                    RETURN;
               ELSE
                --VALIDACIONES DE PORTABILIDAD
                  credito_comun_fija(p_numslc, p_msg_sot, p_msg_porta);
                   --p_msg_sot   := 'CONTINUAR';
                    --p_msg_porta := 'CONTINUAR';
             END IF;

           --  End if;

    */
  end;
  FUNCTION es_fija_o_especial(p_tipsrv vtatabslcfac.tipsrv%TYPE)
    RETURN BOOLEAN IS
    l_count PLS_INTEGER;

  BEGIN
    SELECT COUNT(*)
      INTO l_count
      FROM tipopedd c, opedd d
     WHERE c.abrev = 'PORTABILIDAD'
       AND c.tipopedd = d.tipopedd
       AND d.abreviacion = 'FIJA_Y_ESPECIAL'
       AND d.codigoc = p_tipsrv;

    RETURN l_count > 0;
  END;
  --------------------------------------------------------------------------------
  function tiene_rechazo(p_numslc vtatabslcfac.numslc%type) return boolean is
    l_rechazo pls_integer;

  begin
    select count(t.rechazo_consul_previa)
      into l_rechazo
      from sales.numeroxporta_num_fijos t
     where t.numslc = p_numslc
       and trim(t.rechazo_consul_previa) is not null;

    return l_rechazo > 0;

  end;
  --------------------------------------------------------------------------------

  PROCEDURE p_actualiza_codigo_mensaje(p_numslc    vtatabslcfac.numslc%TYPE,
                                       p_resultado OUT NUMBER,
                                       p_mensaje   OUT VARCHAR2) is
    CURSOR c_num_porta(l_numslc vtatabslcfac.numslc%TYPE) IS
      SELECT COD_MENSAJE, NUMERO
        FROM sales.numeroxporta_num_fijos
       WHERE numslc = l_numslc
         AND COD_MENSAJE IS NOT NULL;

    l_mensaje     sales.numeroxporta_num_fijos.COD_MENSAJE%TYPE;
    l_descripcion sales.numeroxporta_num_fijos.MENSAJE_DESCRIPCION%TYPE;

  begin
    FOR r_num_porta IN c_num_porta(p_numslc) LOOP
      l_mensaje := r_num_porta.cod_mensaje;

      BEGIN

        SELECT D.DESCRIPCION
          INTO l_descripcion
          FROM tipopedd c, opedd d
         WHERE c.abrev = 'PORTABILIDAD_MSG'
           AND c.tipopedd = d.tipopedd
           AND d.abreviacion = l_mensaje;

        update sales.numeroxporta_num_fijos
           set MENSAJE_DESCRIPCION = l_descripcion
         where NUMSLC = p_numslc
           and NUMERO = r_num_porta.numero;

      EXCEPTION
        WHEN OTHERS THEN
          p_resultado := '-1';
          p_mensaje   := p_mensaje || ',' || l_mensaje;
      END;

    END LOOP;
    COMMIT;

    if p_mensaje is not null then
      p_mensaje := substr(p_mensaje, 2);
      p_mensaje := 'No se encuentra descripción del Código_Mensaje de SISACT: ' ||
                   p_mensaje;
    else
      p_resultado := '0';
      p_mensaje   := '';
    end if;

  end;
  /**********************************************************************************/
  FUNCTION obtiene_cant_lineas_det(p_numslc vtatabslcfac.numslc%TYPE)
    RETURN NUMBER IS
    l_count         PLS_INTEGER;
    ln_cantidad_num PLS_INTEGER;
    l_servicio      sales.vtatabslcfac.tipsrv%TYPE;

  BEGIN
    select v.tipsrv
      into l_servicio
      from vtatabslcfac v
     WHERE v.numslc = p_numslc;

    if l_servicio = '0004' then
      select count(*)
        into l_count
        from vtadetptoenl d
       where d.idproducto = 501
         and numslc = p_numslc;

      IF l_count = 1 then
        select nvl(sum(a.cantidad), 0)
          into ln_cantidad_num
          from vtadetptoenl a, tystabsrv b, producto c
         where a.codsrv = b.codsrv
           and b.idproducto = c.idproducto
           and a.numslc = p_numslc
           and c.idtipinstserv = 3
           and b.idtipoenlace = 8;
      else
        select nvl(sum(a.cantidad), 0)
          into ln_cantidad_num
          from vtadetptoenl a, tystabsrv b, producto c
         where a.codsrv = b.codsrv
           and b.idproducto = c.idproducto
           and a.numslc = p_numslc
           and c.idtipinstserv = 3;
      end if;
    else
      select nvl(sum(a.cantidad), 0)
        into ln_cantidad_num
        from vtadetptoenl a, tystabsrv b, producto c
       where a.codsrv = b.codsrv
         and b.idproducto = c.idproducto
         and a.numslc = p_numslc
         and c.idtipinstserv = 3;

    end if;

    RETURN ln_cantidad_num;

  END;

  --7.0
  /**********************************************************************************/
  FUNCTION f_valida_num_telef_contacto(p_numslc vtatabslcfac.numslc%TYPE)

   RETURN VARCHAR2 IS

    l_num_telefono vtamedcomcnt.numcom%type := NULL;
    l_codcnt       vtadetcntslc.codcnt%type;

    CURSOR cur_contacto IS
      SELECT dc.codcnt FROM vtadetcntslc dc WHERE dc.numslc = p_numslc;

  BEGIN
    FOR c IN cur_contacto LOOP
      BEGIN
        l_codcnt := c.codcnt;
        /*Valida si el dato ingresado en el campo NumCom es Numerico*/
        SELECT v.numcom
          INTO l_num_telefono
          FROM vtadetcntslc c, vtamedcomcnt v
         WHERE c.codcnt = v.codcnt
           AND c.numslc = p_numslc
           AND v.codcnt = l_codcnt
           AND v.numcom IS NOT NULL
		   AND TRANSLATE(v.numcom, 'T 0123456789', 'T') IS NULL 
           AND v.fecusu =
               (SELECT MAX(v.fecusu)
                  FROM vtadetcntslc c, vtamedcomcnt v
                 WHERE c.codcnt = v.codcnt
                   AND c.numslc = p_numslc
                   AND v.codcnt = l_codcnt
                   AND TRANSLATE(v.numcom, 'T 0123456789', 'T') IS NULL)
           AND ROWNUM = 1;

        IF l_num_telefono IS NOT NULL THEN
          EXIT;
        END IF;

      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          l_num_telefono := NULL;
      END;
    END LOOP;
    RETURN l_num_telefono;
  END f_valida_num_telef_contacto;
  /**********************************************************************************/
  FUNCTION get_servicio_especial(p_abreviacion opedd.abreviacion%TYPE)
    RETURN VARCHAR2 IS
    l_servicio opedd.codigoc%TYPE;

  BEGIN
    SELECT codigoc
      INTO l_servicio
      FROM opedd d, tipopedd t
     WHERE d.tipopedd = t.tipopedd
       AND t.abrev = 'PORTABILIDAD'
       AND abreviacion = p_abreviacion
       AND codigon_aux = 1;

    RETURN l_servicio;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || 'get_servicio_especial: ' ||
                              SQLERRM);

  END;
  /**********************************************************************************/

  FUNCTION get_servicio_producto(p_numslc vtatabslcfac.numslc%TYPE,
                                 p_tipsrv vtatabslcfac.tipsrv%TYPE)
    RETURN NUMBER IS

    l_idproducto vtadetptoenl.idproducto%TYPE;
  BEGIN
    IF p_tipsrv = '0004' THEN
      BEGIN
        SELECT DISTINCT d.idproducto
          INTO l_idproducto
          FROM vtatabslcfac c, vtadetptoenl d
         WHERE c.numslc = d.numslc
           AND d.idproducto = (SELECT codigon
                                 FROM opedd d, tipopedd t
                                WHERE d.tipopedd = t.tipopedd
                                  AND t.abrev = 'PORTABILIDAD_SERVICIOS'
                                  AND abreviacion = 'PRIMARIO'
                                  AND codigon_aux = 1)
           AND d.numslc = p_numslc;

      EXCEPTION
        WHEN no_data_found THEN
          l_idproducto := 0;
      END;

      IF l_idproducto IS NULL OR l_idproducto = 0 THEN
        BEGIN
          SELECT DISTINCT d.idproducto
            INTO l_idproducto
            FROM vtadetptoenl d, vtatabslcfac c
           WHERE c.numslc = d.numslc
             AND d.idproducto = (SELECT codigon
                                   FROM opedd d, tipopedd t
                                  WHERE d.tipopedd = t.tipopedd
                                    AND t.abrev = 'PORTABILIDAD_SERVICIOS'
                                    AND abreviacion = 'ANALOGICO'
                                    AND codigon_aux = 1)
             AND d.numslc = p_numslc;

        EXCEPTION
          WHEN no_data_found THEN
            l_idproducto := 0;
        END;
      END IF;

      IF l_idproducto IS NULL OR l_idproducto = 0 THEN
        BEGIN
          SELECT DISTINCT d.idproducto
            INTO l_idproducto
            FROM vtadetptoenl d, vtatabslcfac c
           WHERE c.numslc = d.numslc
             AND d.idproducto = (SELECT codigon
                                   FROM opedd d, tipopedd t
                                  WHERE d.tipopedd = t.tipopedd
                                    AND t.abrev = 'PORTABILIDAD_SERVICIOS'
                                    AND abreviacion = 'CORPORATIVO'
                                    AND codigon_aux = 1)
             AND d.numslc = p_numslc;

        EXCEPTION
          WHEN no_data_found THEN
            l_idproducto := 0;
        END;
      END IF;
      IF l_idproducto IS NULL OR l_idproducto = 0 THEN
        BEGIN
          SELECT DISTINCT d.idproducto
            INTO l_idproducto
            FROM vtadetptoenl d, vtatabslcfac c
           WHERE c.numslc = d.numslc
             AND d.idproducto = (SELECT codigon
                                   FROM opedd d, tipopedd t
                                  WHERE d.tipopedd = t.tipopedd
                                    AND t.abrev = 'PORTABILIDAD_SERVICIOS'
                                    AND abreviacion = 'VIRTUALES'
                                    AND codigon_aux = 1)
             AND d.numslc = p_numslc;

        EXCEPTION
          WHEN no_data_found THEN
            l_idproducto := 0;
        END;
      END IF;

    ELSE
      SELECT DISTINCT p.idproducto
        INTO l_idproducto
        FROM vtatabslcfac c, vtadetptoenl d, producto p
       WHERE c.numslc = p_numslc
         AND c.numslc = d.numslc
         AND d.idproducto = p.idproducto
         AND p.idtipinstserv = 3;
    END IF;
    RETURN l_idproducto;
  END;
  /**********************************************************************************/

  FUNCTION get_codigo_departamento(p_numslc vtatabslcfac.numslc%TYPE,
                                   p_tipsrv vtatabslcfac.tipsrv%TYPE)
    RETURN NUMBER IS
    l_idproducto producto.idproducto%TYPE;
    l_cod_depart produccion.plan_numeracion_converter.codigo%TYPE;
  BEGIN
    l_idproducto := get_servicio_producto(p_numslc, p_tipsrv);

    SELECT DISTINCT c.codigo
      INTO l_cod_depart
      FROM produccion.plan_numeracion_converter c, v_ubicaciones v
     WHERE c.ciudad = v.nomest
       AND v.nomest =
           (SELECT u.nomest
              FROM v_ubicaciones u
             WHERE u.codubi = (SELECT v.ubipto
                                 FROM sales.vtadetptoenl v
                                WHERE v.numslc = p_numslc
                                  AND idproducto = l_idproducto));

    RETURN l_cod_depart;
  END;

  /**********************************************************************************/
  procedure validar_trama_numeros(as_tram_num varchar2,
                                  p_msj       out varchar2,
                                  p_resultado out number)

   is
    ln_cant_tram number;
    ls_numero    numtel.numero%type;
    ls_numero2   numtel.numero%type;
    ln_encuentra number;

  begin
    p_resultado  := 0;
    ln_cant_tram := f_split(as_tram_num, '|', 0);

    if ln_cant_tram > 1 then

      for i in 1 .. ln_cant_tram - 1 loop
        ls_numero := f_split(as_tram_num, '|', i);

        for j in i + 1 .. ln_cant_tram loop
          if p_resultado = 0 then
            ls_numero2 := f_split(as_tram_num, '|', j);

            if ls_numero = ls_numero2 then
              p_resultado := 1;
              p_msj       := ls_numero;
            end if;
          end if;
        end loop;
      end loop;
    end if;
  end;

  /**********************************************************************************/

  /****************************************************************
  '* Nombre SP : SIACSS_DATOS_SRV_INST_CLIENTE
  '* Propósito : Explicar en forma detallada
  '* Input : <P_NUM_DOC> - Numero de Documento de identidad
  '* Input : <P_TIPO_NUM_DOC> - Tipo de Documento de identidad
  '* Input : <P_LINEA> - Número de la línea
  '* Output : <RETORNA UN CURSOR  CON LOS SIGUIENTES CAMPOS:
  '*CÓDIGO DE CLIENTE
  '*NOMBRE DEL CLIENTE
  '*APELLIDO MATERNO DEL CLIENTE
  '*APELLIDO PATERNO DEL CLIENTE
  '*TIPO DE DOCUMENTO
  '*NÚMERO DE DOCUMENTO
  '*NÚMERO TELEFÓNICO
  '*FECHA DE ACTIVACIÓN
  '*CÓDIGO DE SERVICIO
  '*TIPO DE SERVICIO
  '*CÓDIGO DE INSTALACION
  '*ESTADO DE LA INSTALACIÓN>
  '* Output : <P_CODIGO_RESPUESTA> - INDICA SI EL PROCEDURE TERMINÓ EXITOSAMENTE O NO
  '* Output : <P_MENSAJE_RESPUESTA> - INDICA LA DESCRIPCIÓN DEL CÓDIGO DE RESPUESTA
  '* Creado por : Cesar Villegas
  '* Fec Creación : 17/03/2016
  '* Fec Actualización : 23/03/2016
  '****************************************************************/

  PROCEDURE SIACSS_DATOS_SRV_INST_CLIENTE(P_NUM_DOC           IN VARCHAR2,
                                          P_TIPO_NUM_DOC      IN VARCHAR2,
                                          P_LINEA             IN VARCHAR2,
                                          P_CUR_DATOS_SALIDA  OUT SYS_REFCURSOR,
                                          P_CODIGO_RESPUESTA  OUT NUMBER,
                                          P_MENSAJE_RESPUESTA OUT VARCHAR2)
                                          
   IS
    CONT_CUR     INTEGER;
    tipo_num_doc VARCHAR2(5);
-- 14.0 Ini    
    ln_co_id     number;
    ld_fecini    date;
-- 14.0 Fin    
  BEGIN
    IF (P_NUM_DOC IS NULL) or (P_TIPO_NUM_DOC IS NULL) or (P_LINEA IS NULL) THEN
      P_CODIGO_RESPUESTA  := 1;
      P_MENSAJE_RESPUESTA := 'No se permiten parametros vacios';
    ELSE
      IF P_TIPO_NUM_DOC = '01' THEN
        tipo_num_doc := '002';
      ELSIF P_TIPO_NUM_DOC = '02' THEN
        tipo_num_doc := '004';
      ELSIF P_TIPO_NUM_DOC = '03' THEN
        tipo_num_doc := '001';
      ELSIF P_TIPO_NUM_DOC = '04' THEN
        tipo_num_doc := '006';
      ELSIF P_TIPO_NUM_DOC = '05' THEN
        tipo_num_doc := '005';
      END IF;
-- 14.0 Ini
      ln_co_id := F_COD_ID_X_NUM_TELEFONO(P_LINEA);  -- determina si proviene BSCS

      if ln_co_id > 0 then
         /* ************************* caso tiene co_id en BSCS */
         select ch.ch_validfrom
           into ld_fecini
           from contract_history@DBL_BSCS_BF ch 
          where ch.ch_seqno  = 2
            and ch.ch_status = 'a'
            and ch.co_id     = ln_co_id;
         

         OPEN P_CUR_DATOS_SALIDA FOR
          select codcli,
                 nomcli,
                 apepat,
                 apmat,
                 tipdide,
                 ntdide,
                 numero,
                 fechaIni,
                 codsrv,
                 tipsrv,
                 codinssrv,
                 estinssrv
            from (select v.codcli,
                         v.nomcli,
                         v.apepat,
                         v.apmat,
                         v.tipdide,
                         v.ntdide,
                         i.numero,
                         nvl(i.fecini, ld_fecini) as fechaIni,
                         i.codsrv,
                         i.tipsrv,
                         i.codinssrv,
                         i.estinssrv
                    from inssrv            i,
                         numtel            n,
                         vtatabcli         v
                   where i.numero = n.numero
                     and v.codcli = i.codcli
                     and v.tipdide = tipo_num_doc
                     and v.ntdide = P_NUM_DOC
                     and i.numero = P_LINEA
                     and nvl(i.fecini, ld_fecini) is not null
                   order by fechaIni desc
                   )
           where rownum = 1;

          --validar cursor vacío
          select COUNT(1)
            INTO CONT_CUR
            from inssrv i, numtel n, vtatabcli v
           where i.numero = n.numero
             and v.codcli = i.codcli
             and v.tipdide = tipo_num_doc
             and v.ntdide = P_NUM_DOC
             and i.numero = P_LINEA
             and nvl(i.fecini, ld_fecini) is not null;
      else
         /* ************************* SGA */
         OPEN P_CUR_DATOS_SALIDA FOR
          select codcli,
                 nomcli,
                 apepat,
                 apmat,
                 tipdide,
                 ntdide,
                 numero,
                 fechaIni,
                 codsrv,
                 tipsrv,
                 codinssrv,
                 estinssrv
            from (select v.codcli,
                         v.nomcli,
                         v.apepat,
                         v.apmat,
                         v.tipdide,
                         v.ntdide,
                         i.numero,
                         nvl(i.fecini, ins.fecini) as fechaIni,
                         i.codsrv,
                         i.tipsrv,
                         i.codinssrv,
                         i.estinssrv
                    from inssrv            i,
                         numtel            n,
                         vtatabcli         v,
                         instanciaservicio ins
                   where i.numero = n.numero
                     and v.codcli = i.codcli
                     and ins.codcli = i.codcli(+)
                     and i.codinssrv(+) = ins.codinssrv
                     and v.tipdide = tipo_num_doc
                     and v.ntdide = P_NUM_DOC
                     and i.numero = P_LINEA
                     and nvl(i.fecini, ins.fecini) is not null
                   order by fechaIni desc)
           where rownum = 1;

          --validar cursor vacío
          select COUNT(1)
            INTO CONT_CUR
            from inssrv i, numtel n, vtatabcli v, instanciaservicio ins
           where i.numero = n.numero
             and v.codcli = i.codcli
             and ins.codcli = i.codcli(+)
             and i.codinssrv(+) = ins.codinssrv
             and v.tipdide = tipo_num_doc
             and v.ntdide = P_NUM_DOC
             and i.numero = P_LINEA
             and nvl(i.fecini, ins.fecini) is not null;
      END IF;
-- 14.0 Fin      
      IF CONT_CUR > 0 THEN
        
        P_CODIGO_RESPUESTA  := 0;
        P_MENSAJE_RESPUESTA := 'OK';
      ELSE
        P_CODIGO_RESPUESTA  := 1;
        P_MENSAJE_RESPUESTA := 'Cursor Vacío.';
      END IF;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      P_CODIGO_RESPUESTA  := -1;
      P_MENSAJE_RESPUESTA := ('Error:' || to_char(SQLCODE) || 'Msg:' ||
                             SQLERRM);
  END SIACSS_DATOS_SRV_INST_CLIENTE;
-- 14.0 Ini
/*****************************************************************************************/
  function F_COD_ID_X_NUM_TELEFONO(p_num_telefono varchar2) return number is
    ln_cod_id number;
  begin
    select cod_id 
      into ln_cod_id 
      from solot 
     where codsolot = (
          select max(s.codsolot)
            from solot s, 
                 inssrv ins,
                 solotpto p
           where s.codsolot = p.codsolot
             and ins.estinssrv in (1, 2)
             and p.codinssrv = ins.codinssrv
             and exists (select 1
                           from tipopedd t, opedd o
                          where t.tipopedd    = o.tipopedd
                            and t.abrev       = 'CONFSERVADICIONAL'
                            and o.abreviacion = 'ESTSOL_MAXALTA'
                            and o.codigon     = s.estsol)
             and exists (select 1
                           from tipopedd t, opedd o
                          where t.tipopedd = o.tipopedd
                            and t.abrev    = 'TIPREGCONTIWSGABSCS'
                            and o.codigon  = s.tiptra)
              and ins.numero = p_num_telefono );
    return ln_cod_id;
  exception
    when others then
      return 0;
  end;
-- 14.0 Fin
  /*****************************************************************************************/
  Procedure SP_MOD_SERV_SIN_REQUEST (P_CO_ID     IN  INTEGER,
                                     P_SNCODE    IN  INTEGER,
                                     P_ACCION    IN  VARCHAR2,
                                     P_RESULTADO OUT INTEGER,
                                     P_MSG_ERR   OUT VARCHAR2) is

  Begin
    /*Procedimiento para baja PORTOUT en BSCS*/
      TIM.SP_MOD_SERV_SIN_REQUEST@dbl_bscs_bf(P_CO_ID,
                                             P_SNCODE,
                                             P_ACCION,
                                             P_RESULTADO,
                                             P_MSG_ERR);

  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit || '.SP_MOD_SERV_SIN_REQUEST() ' || sqlerrm);

  End;
  -- Ini 12.0
  PROCEDURE SGASS_CONS_CANTCP
  /****************************************************************
  * Nombre SP : SGASS_CONS_CANTCP
  * Propósito :
  * Input     : P_NUMSEC: NUMERO DE SEC
  * Output    : P_RESULTADO: 0= OK <> 0= ERROR
                P_MENSAJE: Mensaje de Operacion
  * Creado por : Dorian Sucasaca
  * Fec Creación : 03/11/2016
  * Fec Actualización : --/--/----
  '****************************************************************/
                              ( P_NUMSEC    IN  INTEGER,
                                P_RESULTADO OUT INTEGER,
                                P_MENSAJE   OUT VARCHAR2) IS

    LN_CNT_CP          INTEGER;
    LN_VAL_REC         INTEGER;
    LN_VAL_REC_TO      INTEGER;
    LN_RESP_CODIGO     INTEGER;
    LN_MAX_CP          INTEGER;
    LV_EST_REC         VARCHAR2(50);
    LV_RESP_MENSAJE    VARCHAR2(1000);
    LV_RESP_MAX_CP     VARCHAR2(1000);
    LV_RESP_MAX_TO     VARCHAR2(1000);
    LV_PROYECTO        VARCHAR2(50);
    PV_CANT_REC_TO     INTEGER;
    PV_ESTA_REC_TO     VARCHAR2(50);
  BEGIN

    BEGIN
      SELECT T.NUMSLC
        INTO LV_PROYECTO
        FROM SALES.PORTA_NUM_FIJOS T
       WHERE T.NUMSEC = P_NUMSEC;
    EXCEPTION
      WHEN OTHERS THEN
        LV_PROYECTO := '';
    END;

    IF NOT(LV_PROYECTO) IS NULL THEN
      SELECT DESCRIPCION INTO LV_RESP_MAX_CP  FROM CONSTANTE WHERE CONSTANTE = 'PORT_CP_MAX_MSJ';

      LN_MAX_CP          := TELEFONIA.PQ_PORTABILIDAD.F_PARAMETROS_PORT('PORT_CP_MAX',NULL, 'V');
      PV_CANT_REC_TO     := TELEFONIA.PQ_PORTABILIDAD.F_PARAMETROS_PORT('PORT_CP_TIME_OU',NULL, 'V');
      PV_ESTA_REC_TO     := TELEFONIA.PQ_PORTABILIDAD.F_PARAMETROS_PORT('PORT_CP_REC_TO', NULL, 'V');

      USRPVU.SISACT_PKG_PORTABILIDAD_CORP.SISACTSS_CONS_CANTCP@DBL_PVUDB(LV_PROYECTO,
                                      LN_CNT_CP,
                                      LV_EST_REC,
                                     LN_RESP_CODIGO,
                                     LV_RESP_MENSAJE);
      IF LN_RESP_CODIGO = 0 THEN

        -- Consulta Rechazo 01
        BEGIN
         SELECT COUNT(1)
           INTO LN_VAL_REC
           FROM OPERACION.OPEDD D
          WHERE D.TIPOPEDD = (SELECT C.TIPOPEDD
                                FROM OPERACION.TIPOPEDD C
                               WHERE C.ABREV = 'CON_REC_VAL_PORT')
            AND D.CODIGOC = LV_EST_REC;
        EXCEPTION
          WHEN OTHERS THEN
            LN_VAL_REC:= 0;
        END;

        BEGIN
          SELECT COUNT(*)
            INTO LN_VAL_REC_TO
            FROM USRPVU.PORTT_SOLICITUDES_PORTA@DBL_PVUDB PP
           WHERE PP.PK_SOPOT_SOPON_ID IN
                 (SELECT (PP.PK_SOPOT_SOPON_ID)
                    FROM USRPVU.PORTT_SOLICITUDES_PORTA@DBL_PVUDB PP
                   WHERE PP.SOPON_SOLIN_CODIGO IN
                         (SELECT DISTINCT SOLIN_CODIGO
                            FROM USRPVU.SISACT_SOLICITUD_PORTABILIDAD@DBL_PVUDB
                           WHERE PORT_NUMERO IN
                                 (SELECT DISTINCT (A.SOPOC_INICIO_RANGO)
                                    FROM USRPVU.PORTT_SOLICITUDES_PORTA@DBL_PVUDB A,
                                         USRPVU.SISACT_SEC_DATOS@DBL_PVUDB B
                                   WHERE A.SOPON_SOLIN_CODIGO = B.SOLIN_CODIGO
                                     AND B.SOLIV_PROYECTO_SGA = LV_PROYECTO))
                     AND PP.SOPOV_MOTIVO_CP IS NOT NULL
                     AND TRUNC(PP.SOPOT_FECHA_REGISTRO) = TRUNC(SYSDATE))
            AND PP.SOPOV_MOTIVO_CP = PV_ESTA_REC_TO;
        EXCEPTION
          WHEN OTHERS THEN
            LN_VAL_REC_TO := 0;
        END;


        IF LN_VAL_REC = 1 THEN
          P_RESULTADO := 0;
          P_MENSAJE   := 'OK';
        ELSE
          IF PV_ESTA_REC_TO = LV_EST_REC THEN
            IF LN_VAL_REC_TO >= PV_CANT_REC_TO THEN
               P_RESULTADO := -1;
               P_MENSAJE   := LV_RESP_MAX_CP;
            ELSE
               P_RESULTADO := 0;
               P_MENSAJE   := 'OK';
            END IF;
          ELSE
            IF LN_CNT_CP >= LN_MAX_CP THEN
              P_RESULTADO := -1;
              P_MENSAJE   := LV_RESP_MAX_CP;
            ELSE
              P_RESULTADO := 0;
              P_MENSAJE   := LV_RESP_MAX_CP;
            END IF;
          END IF;
        END IF;

      ELSE
        P_RESULTADO := LN_RESP_CODIGO;
        P_MENSAJE   := LV_RESP_MENSAJE;
      END IF;
    ELSE
      P_RESULTADO := 0;
      P_MENSAJE   := 'OK';
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      P_RESULTADO := -1;
      P_MENSAJE   := $$PLSQL_UNIT || '.SGASS_CONS_CANTCP() ' || SQLERRM;
  END;

  PROCEDURE SGASS_ACT_INFO_PORT
  /****************************************************************
  * Nombre SP : SGASS_ACT_INFO_PORT
  * Propósito :
  * Input     : K_NUMSEC: NUMERO DE SEC
  * Output    : K_RESULTADO: 0= OK <> 0= ERROR
                K_MENSAJE: Mensaje de Operacion
  * Creado por : Dorian Sucasaca
  * Fec Creación : 03/11/2016
  * Fec Actualización : --/--/----
  '****************************************************************/
                                ( K_NUMSEC    IN  INTEGER,
                                  K_RESULTADO OUT INTEGER,
                                  K_MENSAJE   OUT VARCHAR2) IS
  BEGIN
    K_RESULTADO := 0;
    K_MENSAJE   := 'OK';

    USRPVU.SISACT_PKG_PORTABILIDAD_CORP.SP_PROC_PORTA@DBL_PVUDB(K_NUMSEC,
                                                                K_RESULTADO,
                                                                K_MENSAJE);
  EXCEPTION
    WHEN OTHERS THEN
      K_RESULTADO := -1;
      K_MENSAJE   := '[ERROR] ' || 'USRPVU.SISACT_PKG_PORTABILIDAD_CORP.SGASS_ACT_INFO_PORT@DBL_PVUDB() ' || K_MENSAJE;
  END;

  procedure SGASS_ANULA_SEC_PORT
  /****************************************************************
    * Nombre SP : SGASS_ANULA_SEC_PORT
    * Propósito : Anula la SEC de portabilidad.
    * Input     : P_NUMSEC: NUMERO DE SEC
    * Output    : P_RESULTADO: 0= OK <> 0= ERROR
                  P_MENSAJE: Mensaje de Operacion
    * Creado por : Dorian Sucasaca
    * Fec Creación : 03/11/2016
    * Fec Actualización : --/--/----
    '****************************************************************/
  (P_NUMSEC in integer, P_RESULTADO out integer, P_MENSAJE out varchar2) is
    PI_RESP     integer;
    PV_MENS     varchar2(1000);
    V_FECHAPROG date;
    V_CODSOLOT  number;
    V_ESTSOL    number;
    V_NUMPROY   varchar2(10);
  begin
    --Validar Fecha de Programacion
    USRPVU.SISACT_PKG_PORTABILIDAD_CORP.SISACTSS_CONS_FECHAPROG@DBL_PVUDB(P_NUMSEC,
                                                                          V_FECHAPROG,
                                           PI_RESP,
                                      PV_MENS);
    P_MENSAJE := PV_MENS;
    if PI_RESP = 0 then
      if V_FECHAPROG is null then
        --Anular SOT
        begin
          select T.NUMSLC
            into V_NUMPROY
            from SALES.PORTA_NUM_FIJOS T
           where T.NUMSEC = P_NUMSEC;

          select s.codsolot, s.estsol
            into V_CODSOLOT, V_ESTSOL
            from operacion.solot s
           where s.numslc = V_NUMPROY
             and s.estsol <> 13;

          operacion.pq_solot.p_chg_estado_solot(V_CODSOLOT,
                                                13,
                                                V_ESTSOL,
                                                null);

          update operacion.inssrv i
             set i.numero = null
           where i.codinssrv in (select n.codinssrv
                                   from telefonia.numtel n
                                  where n.codnumtel in (select codnumtel
                                                          from reservatel
                                                         where numslc = V_NUMPROY));

          update telefonia.numtel n
             set n.estnumtel      = 1,
                 n.codinssrv      = null,
                 n.flg_portable   = null
           where n.numero in
                 (select codnumtel from reservatel where numslc = V_NUMPROY);
        exception
          when others then
            P_RESULTADO := 0;
        end;

        --Anular SEC
        USRPVU.SISACT_PKG_PORTABILIDAD_CORP.SGASS_ANULA_SEC_PORT@DBL_PVUDB(P_NUMSEC,
                                                                           PI_RESP,
                                                                           PV_MENS);

        if PI_RESP = 0 then
          P_RESULTADO := 0;
          P_MENSAJE   := '[OK] ' || PV_MENS;
        else
          P_RESULTADO := -1;
          P_MENSAJE   := '[ERROR]: ' || 'al Eliminar los datos de la SEC, intente nuevamente' || chr(13) ||
                         'USRPVU.SISACT_PKG_PORTABILIDAD_CORP.SGASS_ANULA_SEC_PORT@DBL_PVUDB() ' || PV_MENS;
        end if;
      else
        P_RESULTADO := -1;
        select descripcion
          into P_MENSAJE
          from OPERACION.constante
         where constante = 'PORT_CP_FEC_PRG';
      end if;
    else
      P_RESULTADO := -1;
    end if;
  exception
    when others then
      P_RESULTADO := -1;
      P_MENSAJE   := '[ERROR] ' || $$PLSQL_UNIT || '.SGASS_ANULA_SEC_PORT() ' || SQLERRM;
  end;


  PROCEDURE SGASS_CP_WS
  /****************************************************************
  * Nombre SP : SGASS_CP_WS
  * Propósito : Consulta al servicio EnvioPortaws
  * Input     : P_XML: XML de Consulta Previa
                P_URL: URL de Servicio
  * Output    : P_RESPUESTA: Respuesta del Servicio
                P_MENSAJE: Mensaje de Servicio
  * Creado por : Dorian Sucasaca
  * Fec Creación : 03/11/2016
  * Fec Actualización : --/--/----
  '****************************************************************/
                        ( P_XML       CLOB,
                          P_URL       VARCHAR2,
                          P_RESULTADO OUT INTEGER,
                          P_MENSAJE   OUT VARCHAR2) IS
    UTL_REQUEST       UTL_HTTP.REQ;
    UTL_RESPONSE      UTL_HTTP.RESP;
    V_RESPUESTA CLOB;
  BEGIN
    UTL_REQUEST := UTL_HTTP.BEGIN_REQUEST(P_URL, 'POST', 'HTTP/1.1');
    UTL_HTTP.SET_HEADER(UTL_REQUEST, 'Content-Type', 'text/xml');
    UTL_HTTP.SET_HEADER(UTL_REQUEST, 'Content-Length', LENGTH(P_XML));
    UTL_HTTP.WRITE_TEXT(UTL_REQUEST, P_XML);
    UTL_RESPONSE := UTL_HTTP.GET_RESPONSE(UTL_REQUEST);
    UTL_HTTP.READ_TEXT(UTL_RESPONSE, V_RESPUESTA);
    UTL_HTTP.END_RESPONSE(UTL_RESPONSE);
    P_RESULTADO := TO_NUMBER(SGASS_OBTENER_TAG('codigoRespuesta', V_RESPUESTA));
    P_MENSAJE   := SGASS_OBTENER_TAG('mensajeRespuesta', V_RESPUESTA);
  EXCEPTION
    WHEN OTHERS THEN
      V_RESPUESTA := '';
      P_RESULTADO := -1;
      P_MENSAJE   := '[ERROR] ' || $$PLSQL_UNIT || '.SGASS_CP_WS() ' || SQLERRM;
  END;

  FUNCTION SGASS_OBTENER_TAG
  /****************************************************************
  * Nombre SP : SGASS_OBTENER_TAG
  * Propósito :
  * Input     : AV_TAG: Campo de Respuesta
                AV_TRAMA: Trama de Respuesta
  * Output    : Valor de Respuesta
  * Creado por : Dorian Sucasaca
  * Fec Creación : 03/11/2016
  * Fec Actualización : --/--/----
  '****************************************************************/
   (AV_TAG VARCHAR2, AV_TRAMA CLOB) RETURN VARCHAR2
  IS
    LV_RPTA CLOB;
    LV_RETN VARCHAR2(1000);
  BEGIN
    IF INSTR(AV_TRAMA, AV_TAG) = 0 THEN
      RETURN '';
    END IF;
    LV_RPTA := SUBSTR(AV_TRAMA, INSTR(AV_TRAMA, AV_TAG), LENGTH(AV_TRAMA));
    LV_RPTA := SUBSTR(LV_RPTA, INSTR(LV_RPTA, '>') + 1, LENGTH(LV_RPTA));
    LV_RPTA := TRIM(SUBSTR(LV_RPTA, 1, INSTR(LV_RPTA, '<') - 1));
    LV_RETN := LV_RPTA;
    RETURN LV_RETN;
  END;
  -- Fin 12.0

  PROCEDURE SGASS_CONSULTAPREVIA
  /****************************************************************
  * Nombre SP : SGASS_CONSULTAPREVIA
  * Propósito :
  * Input     : P_NUMSEC: NUMERO DE SEC
                P_NUMERO: NUMERO DE TELEFONA A CP
  * Output    : P_RESULTADO: 0= OK <> 0= ERROR
                P_MENSAJE: Mensaje de Operacion
  * Creado por : Dorian Sucasaca
  * Fec Creación : 03/11/2016
  * Fec Actualización : --/--/----
  '****************************************************************/
   ( P_NUMSEC    IN  INTEGER,
     P_NUMERO    IN  VARCHAR2,
     P_RESULTADO OUT INTEGER,
     P_MENSAJE   OUT VARCHAR2)
  IS
    PX_XML_CP           CLOB;
    PV_URL_CP           VARCHAR2(1000);
    PI_RESU_CP          INTEGER;
    PV_MENS_CP          VARCHAR(2000);
    PC_RESP_CP          CLOB;

    LN_IDTRS            NUMBER;
    LV_IPAPLICACION     VARCHAR2(100);
    LV_NOM_APLI         VARCHAR2(30);
    LV_USU_APLI         VARCHAR2(30);
    LV_NOM_PC           VARCHAR2(30);
    LV_NOM_DB           VARCHAR2(30);
    LV_IP_HOST          VARCHAR2(30);

    PV_ESTA_SS_ROLL     VARCHAR2(100);
    PV_ESTA_PSP_ROLL    VARCHAR2(100);
    PV_PROC_ROLL        VARCHAR2(100);
    PN_RESP_ROLL        NUMBER;

    LN_CONSULTA        INTEGER;
    LN_RESP_CODIGO     INTEGER;
    LV_RECHAZO         VARCHAR2(50);
    LV_RESP_MENSAJE    VARCHAR2(1000);
    LN_ID_SOPOT_SOPON_ID NUMBER(18);
  BEGIN
    -- Inicio Construir XML
    -- Para Pruebas se Utiliza el SEC 10008884
    PV_URL_CP          := TELEFONIA.PQ_PORTABILIDAD.F_PARAMETROS_PORT('PORT_CP_URL',NULL, 'V');
    PV_ESTA_SS_ROLL    := TELEFONIA.PQ_PORTABILIDAD.F_PARAMETROS_PORT('PORT_CP_EST_POR',NULL, 'V');
    PV_ESTA_PSP_ROLL   := TELEFONIA.PQ_PORTABILIDAD.F_PARAMETROS_PORT('PORT_CP_EST_CP',NULL,  'V');
    PV_PROC_ROLL       := TELEFONIA.PQ_PORTABILIDAD.F_PARAMETROS_PORT('PORT_CP_PRO_ROL',NULL, 'V');


    LV_IPAPLICACION := SYS_CONTEXT('USERENV', 'IP_ADDRESS');
    LV_NOM_PC       := SYS_CONTEXT('USERENV', 'HOST', 30);
    LV_NOM_DB       := SYS_CONTEXT('USERENV', 'DB_NAME');
    SELECT UTL_INADDR.GET_HOST_ADDRESS INTO LV_IP_HOST FROM DUAL;
    LV_NOM_APLI     := 'SGA';
    LV_USU_APLI     := USER;

    SELECT PS.PK_SOPOT_SOPON_ID
      INTO LN_ID_SOPOT_SOPON_ID
      FROM USRPVU.PORTT_SOLICITUDES_PORTA@DBL_PVUDB PS
     WHERE PS.SOPON_SOLIN_CODIGO = P_NUMSEC
       AND PS.SOPOC_INICIO_RANGO = P_NUMERO;

    SELECT WEBSERVICE.SQ_WS_RESERVAHFC.NEXTVAL INTO LN_IDTRS FROM DUMMY_OPE;

    PX_XML_CP := '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:typ="http://claro.com.pe/eai/ws/ventas/envioportaws/types" xmlns:bas="http://claro.com.pe/eai/ws/baseschema">';
    PX_XML_CP := PX_XML_CP || '<soapenv:Header/>';
    PX_XML_CP := PX_XML_CP || '<soapenv:Body>';
    PX_XML_CP := PX_XML_CP || '<typ:realizarConsultaPreviaRequest>';
    PX_XML_CP := PX_XML_CP || '<typ:auditRequest>';
    PX_XML_CP := PX_XML_CP || '<bas:idTransaccion>'||LN_IDTRS||'</bas:idTransaccion>';
    PX_XML_CP := PX_XML_CP || '<bas:ipAplicacion>' || LV_IPAPLICACION || '</bas:ipAplicacion>';
    PX_XML_CP := PX_XML_CP || '<bas:nombreAplicacion>'|| LV_NOM_APLI ||'</bas:nombreAplicacion>';
    PX_XML_CP := PX_XML_CP || '<bas:usuarioAplicacion>'|| LV_USU_APLI ||'</bas:usuarioAplicacion>';
    PX_XML_CP := PX_XML_CP || '</typ:auditRequest>';
    PX_XML_CP := PX_XML_CP || '<typ:numeroSec>'|| TRIM(P_NUMSEC) ||'</typ:numeroSec>';
    PX_XML_CP := PX_XML_CP || '<typ:flagCP>1</typ:flagCP>';
    PX_XML_CP := PX_XML_CP || '<typ:observaciones></typ:observaciones>';
    PX_XML_CP := PX_XML_CP || '<typ:id>'|| LN_ID_SOPOT_SOPON_ID ||'</typ:id>';
    PX_XML_CP := PX_XML_CP || '<typ:tipoPort>fc</typ:tipoPort>';
    PX_XML_CP := PX_XML_CP || '<typ:nombreHost>'||LV_NOM_PC||'</typ:nombreHost>';
    PX_XML_CP := PX_XML_CP || '<typ:nombreServidor>'||LV_NOM_DB||'</typ:nombreServidor>';
    PX_XML_CP := PX_XML_CP || '<typ:ipServidor>'||LV_IP_HOST||'</typ:ipServidor>';
    PX_XML_CP := PX_XML_CP || '<typ:codigoAplicacion>286</typ:codigoAplicacion>';
    PX_XML_CP := PX_XML_CP || '<typ:listaRequestOpcional>';
    PX_XML_CP := PX_XML_CP || '<!--1 or more repetitions:-->';
    PX_XML_CP := PX_XML_CP || '<bas:objetoOpcional campo="?" valor="?"/>';
    PX_XML_CP := PX_XML_CP || '</typ:listaRequestOpcional>';
    PX_XML_CP := PX_XML_CP || '</typ:realizarConsultaPreviaRequest>';
    PX_XML_CP := PX_XML_CP || '</soapenv:Body>';
    PX_XML_CP := PX_XML_CP || '</soapenv:Envelope>';
    -- Fin    Construir XML
    -- Ejecutar Servicio
    SGASS_CP_WS(PX_XML_CP,
                PV_URL_CP,
                PI_RESU_CP,
                PV_MENS_CP);

    -- Validar Respuesta del Servicio
    IF PI_RESU_CP = 0 THEN
      -- Respuesta OK
      P_RESULTADO := PI_RESU_CP;
      P_MENSAJE   := '[OK] '||PV_MENS_CP;
    ELSIF PI_RESU_CP = -1 THEN
      -- Respuesta Error BD
      P_RESULTADO := PI_RESU_CP;
      P_MENSAJE   := '[ERROR] '||PV_MENS_CP;
      -- Rollback a CP
      USRPVU.SISACT_PKG_PORTABILIDAD_CORP.SISACTSS_ROLLBACK_SEC_IN@DBL_PVUDB(P_NUMSEC,
                                                                             LN_ID_SOPOT_SOPON_ID,
                                                                             PV_ESTA_SS_ROLL,
                                                                             PV_ESTA_PSP_ROLL,
                                                                             PV_PROC_ROLL,
                                                                             PN_RESP_ROLL);
      IF PN_RESP_ROLL = 0 THEN
        P_RESULTADO := PI_RESU_CP;
        P_MENSAJE   := PV_MENS_CP ;
      ELSE
        P_RESULTADO := PN_RESP_ROLL;
        P_MENSAJE   := '[ERROR] ' || 'Respuesta Servicio = '  || TO_CHAR(PI_RESU_CP ) || ',SISACT_PKG_PORTABILIDAD_CORP.SISACTSS_ROLLBACK_SEC_IN() ' || SQLERRM;
      END IF;
    ELSIF PI_RESU_CP = 1 THEN
      -- Rollback a CP
      USRPVU.SISACT_PKG_PORTABILIDAD_CORP.SISACTSS_ROLLBACK_SEC_IN@DBL_PVUDB(P_NUMSEC,
                                                                             LN_ID_SOPOT_SOPON_ID,
                                       PV_ESTA_SS_ROLL,
                                       PV_ESTA_PSP_ROLL,
                                       PV_PROC_ROLL,
                                       PN_RESP_ROLL);
      IF PN_RESP_ROLL = 0 THEN
        P_RESULTADO := PI_RESU_CP;
        P_MENSAJE   := PV_MENS_CP;
      ELSE
        P_RESULTADO := PN_RESP_ROLL;
        P_MENSAJE   := '[ERROR] ' || 'Respuesta Servicio = '  || TO_CHAR(PI_RESU_CP ) || ',SISACT_PKG_PORTABILIDAD_CORP.SISACTSS_ROLLBACK_SEC_IN() ' || SQLERRM;
      END IF;
    ELSE
      -- Rollback a CP
      USRPVU.SISACT_PKG_PORTABILIDAD_CORP.SISACTSS_ROLLBACK_SEC_IN@DBL_PVUDB(P_NUMSEC,
                                                                             LN_ID_SOPOT_SOPON_ID,
                                                                             PV_ESTA_SS_ROLL,
                                                                             PV_ESTA_PSP_ROLL,
                                                                             PV_PROC_ROLL,
                                                                             PN_RESP_ROLL);
      IF PN_RESP_ROLL = 0 THEN
        P_RESULTADO := PI_RESU_CP;
        P_MENSAJE   := PV_MENS_CP;
      ELSE
        P_RESULTADO := PN_RESP_ROLL;
        P_MENSAJE   := '[ERROR] ' || 'Respuesta Servicio = '  || TO_CHAR(PI_RESU_CP ) || ',SISACT_PKG_PORTABILIDAD_CORP.SISACTSS_ROLLBACK_SEC_IN() ' || SQLERRM;
      END IF;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      P_RESULTADO := -1;
      P_MENSAJE   := '[ERROR] ' || $$PLSQL_UNIT || '.SGASS_CONSULTAPREVIA() ' || SQLERRM;
  END;

 FUNCTION SGASS_RESPUESTA_PVU
 /****************************************************************
  * Nombre SP : SGASS_RESPUESTA_PVU
  * Propósito :
  * Input     : PK_SOLPORTA: ID numero
  * Output    : MENSAJE DE RESPUESTA.
  * Creado por : Dorian Sucasaca
  * Fec Creación : 16/12/2016
  * Fec Actualización : --/--/----
  '****************************************************************/
    (PK_SOLPORTA IN NUMBER) RETURN VARCHAR2
  IS
    LS_MENSAJE  VARCHAR2(1000);
  BEGIN
    LS_MENSAJE := NULL;

    SELECT (SELECT PP.PARAV_DESCRIPCION
              FROM USRPVU.PORTT_PARAMETROS@DBL_PVUDB PP
             WHERE PP.PK_PARAT_PARAC_COD = PS.SOPOC_ESTA_PROCESO)
      INTO LS_MENSAJE
      FROM USRPVU.PORTT_SOLICITUDES_PORTA@DBL_PVUDB PS
     WHERE PS.PK_SOPOT_SOPON_ID = PK_SOLPORTA;
    RETURN LS_MENSAJE;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN LS_MENSAJE;
  END;
END;
/
