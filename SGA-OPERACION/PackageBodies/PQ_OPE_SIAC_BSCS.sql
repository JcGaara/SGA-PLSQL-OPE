CREATE OR REPLACE PACKAGE BODY OPERACION.PQ_OPE_SIAC_BSCS AS
  /* **********************************************************************************************
  NOMBRE:     PQ_OPE_BSCS
  PROPOSITO:  Interface SIAC_OPERACION BSCS
  PROGRAMADO EN JOB:  NO

  REVISIONES:
  Version      Fecha        Autor            Solicitado Por      Descripcion
  ---------  ----------  -----------------   ----------------    ------------------------
  1.0        20/05/2014  Carlos Chamache     Hector Huaman       REQ 164992  Proyecto EVUFC - Traslado Externo
  /* **********************************************************************************************/
  PROCEDURE enviar_direccion_bscs(p_idtareawf NUMBER,
                                  p_idwf      NUMBER,
                                  p_tarea     NUMBER,
                                  p_tareadef  NUMBER) IS
    C_ESTTAREA_CON_ERROR CONSTANT esttarea.esttarea%TYPE := 19;
    l_tipesttar    esttarea.tipesttar%TYPE;
    l_error_fact   NUMBER;
    l_error_inst   NUMBER;
    l_mensaje_fact VARCHAR2(1000);
    l_mensaje_inst VARCHAR2(1000);
    l_codsolot     solot.codsolot%type;
    l_valido       number;
    /* *********************************/
    PROCEDURE validar_resultado(p_error_fact NUMBER, p_error_inst NUMBER) IS
    BEGIN
      IF p_error_fact != 0 AND p_error_inst != 0 THEN
        RAISE_APPLICATION_ERROR(-20500,
                                'Actualización información BSCS: Error al enviar Dirección de Instalación y Facturación');
      END IF;

      IF p_error_fact != 0 THEN
        RAISE_APPLICATION_ERROR(-20500,
                                'Actualización información BSCS: Error al enviar Dirección de Facturación');
      END IF;

      IF p_error_inst != 0 THEN
        RAISE_APPLICATION_ERROR(-20500,
                                'Actualización información BSCS: Error al enviar Dirección de Instalación');
      END IF;
    END;
    /* *********************************/
  BEGIN
  --Validacion
   select codsolot into l_codsolot from wf where idwf = p_idwf;

   select  count(*) into l_valido from solot s where s.codsolot=l_codsolot and s.customer_id is not null and s.cod_id is not null;

   if l_valido > 0 then

    enviar_dir_instalacion(p_idtareawf, p_idwf, l_error_inst, l_mensaje_inst);

    enviar_dir_facturacion(p_idtareawf, p_idwf, l_error_fact, l_mensaje_fact);

    validar_resultado(l_error_fact, l_error_inst);

 --COMMIT;
    else
  --No interviene
      OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(p_idtareawf,
                                       4,
                                       8,
                                       0,
                                       SYSDATE,
                                       SYSDATE);

    end if;
  EXCEPTION
    WHEN OTHERS THEN
      l_tipesttar := obtener_tipesttar(C_ESTTAREA_CON_ERROR);

      OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(p_idtareawf,
                                       l_tipesttar,
                                       C_ESTTAREA_CON_ERROR,
                                       0,
                                       SYSDATE,
                                       SYSDATE);

      COMMIT;

      RAISE;
  END;
  /* **********************************************************************************************/
  PROCEDURE enviar_dir_instalacion(p_idtareawf NUMBER,
                                   p_idwf      NUMBER,
                                   p_error     OUT NUMBER,
                                   p_mensaje   OUT VARCHAR2) IS
    C_TIPO CONSTANT VARCHAR2(1000) := 'DIRECCION_INSTALACION';
    l_result                VARCHAR2(1000);
    l_tareawfseg            tareawfseg%ROWTYPE;
    l_int_send_dir_bscs_log operacion.int_send_dir_bscs_log%ROWTYPE;
    l_dir_inst              enviar_direccion_type;

  BEGIN
    p_error    := 0;
    p_mensaje  := 'OK';
    l_dir_inst := obtener_dir_instalacion(p_idwf);

    tim.pp004_siac_hfc.sp_chg_direccion_instal@DBL_BSCS_BF(l_dir_inst.customer_id,

                                                           SUBSTR(l_dir_inst.dirsuc,1,40),
                                                           l_dir_inst.idplano,
                                                           l_dir_inst.ubigeo,
                                                           l_dir_inst.referencia,
                                                           l_result);

    l_tareawfseg := llenar_tareawfseg(p_idtareawf, C_TIPO, to_number(l_result));

    insertar_tareawfseg(l_tareawfseg);
    --commit;
    validar_rpta_dir_envio(l_result, C_TIPO);

    l_int_send_dir_bscs_log := llenar_int_send_dir_bscs_log(C_TIPO,
                                                            p_idtareawf,
                                                            l_dir_inst,
                                                            l_result,
                                                            p_mensaje);

    insertar_int_send_dir_bscs_log(l_int_send_dir_bscs_log);

  EXCEPTION
    WHEN OTHERS THEN
      p_error   := -1;
      p_mensaje := SQLERRM;

      l_int_send_dir_bscs_log := llenar_int_send_dir_bscs_log(C_TIPO,
                                                              p_idtareawf,
                                                              l_dir_inst,
                                                              l_result,
                                                              p_mensaje);
      insertar_int_send_dir_bscs_log(l_int_send_dir_bscs_log);
  END;
  /* **********************************************************************************************/
  PROCEDURE enviar_dir_facturacion(p_idtareawf NUMBER,
                                   p_idwf      NUMBER,
                                   p_error     OUT NUMBER,
                                   p_mensaje   OUT VARCHAR2) IS
    C_TIPO CONSTANT VARCHAR2(1000) := 'DIRECCION_FACTURACION';
    l_int_send_dir_bscs_log operacion.int_send_dir_bscs_log%ROWTYPE;
    l_xml                   VARCHAR2(32767);
    l_xml_rpta              VARCHAR2(32767);
    l_url                   VARCHAR2(2000);
    l_result                VARCHAR2(32767);
    l_tareawfseg            tareawfseg%ROWTYPE;
    l_dir_fact              enviar_direccion_type;
    /* *********************************/
    FUNCTION get_xml(p_dir_fact enviar_direccion_type) RETURN VARCHAR2 IS
    BEGIN
      RETURN '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://pe/com/claro/siacpostpago/ws" xmlns:bscs="http://claro.com/SIACPostpago/bscs_cambioDireccionPostal_request.xsd">
         <soapenv:Header/>
         <soapenv:Body>
            <ws:cambioDireccionPostal>
               <bscs:bscs_cambioDireccionPostal_request>
                  <bscs:p_CustomerID>' || p_dir_fact.customer_id || '</bscs:p_CustomerID>
                  <!--Optional:-->
                  <bscs:p_Direccion>' || SUBSTR(p_dir_fact.dirsuc,1,40) || '</bscs:p_Direccion>
                  <!--Optional:-->
                  <bscs:p_NotasDireccion>' || p_dir_fact.referencia || '</bscs:p_NotasDireccion>
                  <!--Optional:-->
                  <bscs:p_Distrito>' || p_dir_fact.nomdst || '</bscs:p_Distrito>
                  <!--Optional:-->
                  <bscs:p_Provincia>' || p_dir_fact.nompvc || '</bscs:p_Provincia>
                  <!--Optional:-->
                  <bscs:p_CodigoPostal>' || p_dir_fact.codpos || '</bscs:p_CodigoPostal>
                  <!--Optional:-->
                  <bscs:p_Departamento>' || p_dir_fact.nomest || '</bscs:p_Departamento>
                  <!--Optional:-->
                  <bscs:p_Pais>' || p_dir_fact.nompai || '</bscs:p_Pais>
               </bscs:bscs_cambioDireccionPostal_request>
            </ws:cambioDireccionPostal>
         </soapenv:Body>
      </soapenv:Envelope>';
    END;
    /* *********************************/
  BEGIN
    p_error    := 0;
    p_mensaje  := 'OK';
    l_dir_fact := obtener_dir_facturacion(p_idwf);
    l_url      := 'http://172.19.74.202:8909/SIACPostpagoWS/SIACPostpagoTxWS?WSDL';
    l_xml      := get_xml(l_dir_fact);
    l_xml_rpta := llamar_webservice(l_xml, l_url);
    l_result   := extraer_ws_atributo(l_xml_rpta, 'p_result');

    l_tareawfseg := llenar_tareawfseg(p_idtareawf, C_TIPO, to_number(l_result));

    insertar_tareawfseg(l_tareawfseg);

    validar_rpta_dir_envio(l_result, C_TIPO);

    l_int_send_dir_bscs_log := llenar_int_send_dir_bscs_log(C_TIPO,
                                                            p_idtareawf,
                                                            l_dir_fact,
                                                            l_result,
                                                            p_mensaje);

    insertar_int_send_dir_bscs_log(l_int_send_dir_bscs_log);

  EXCEPTION
    WHEN OTHERS THEN
      p_error   := -1;
      p_mensaje := SQLERRM;

      l_int_send_dir_bscs_log := llenar_int_send_dir_bscs_log(C_TIPO,
                                                              p_idtareawf,
                                                              l_dir_fact,
                                                              l_result,
                                                              p_mensaje);
      insertar_int_send_dir_bscs_log(l_int_send_dir_bscs_log);
  END;
  /* **********************************************************************************************/
  FUNCTION obtener_dir_instalacion(p_idwf NUMBER) RETURN enviar_direccion_type IS
    l_idprocess operacion.siac_instancia.idprocess%TYPE;
    l_dir_inst  enviar_direccion_type;
    l_solot     solot%ROWTYPE;

  BEGIN
    BEGIN

      l_solot             := obtener_solot(p_idwf);
      l_dir_inst.codsolot := l_solot.codsolot;

      l_idprocess := obtener_idprocess(l_solot.codsolot);

      IF l_idprocess IS NOT NULL THEN

        BEGIN
          l_dir_inst.codsuc := obtener_instancia_siac(l_idprocess,
                                                      'SUCURSAL INSTALACION');

          IF l_dir_inst.codsuc IS NOT NULL THEN

            SELECT vs.codcli, vs.dirsuc, vs.idplano, dst.ubigeo, vs.referencia
              INTO l_dir_inst.codcli,
                   l_dir_inst.dirsuc,
                   l_dir_inst.idplano,
                   l_dir_inst.ubigeo,
                   l_dir_inst.referencia
              FROM vtasuccli vs, vtatabdst dst
             WHERE vs.codsuc = l_dir_inst.codsuc
               AND vs.ubisuc = dst.codubi;

          END IF;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            l_dir_inst.codsuc := NULL;
        END;
      END IF;

      IF l_dir_inst.codsuc IS NULL THEN
        SELECT DISTINCT so.codcli,
                        vs.dirsuc,
                        vs.idplano,
                        dst.ubigeo,
                        vs.referencia
          INTO l_dir_inst.codcli,
               l_dir_inst.dirsuc,
               l_dir_inst.idplano,
               l_dir_inst.ubigeo,
               l_dir_inst.referencia
          FROM solot         so,
               vtadetptoenl  vd,
               vtasuccli     vs,
               v_ubicaciones vu,
               vtatabdst     dst
         WHERE so.codsolot = l_dir_inst.codsolot
           AND so.numslc = vd.numslc
           AND vd.codsuc = vs.codsuc
           AND vs.ubisuc = vu.codubi
           AND vu.codubi = dst.codubi
           AND vu.coddst = dst.coddst;
      END IF;
    EXCEPTION
      WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20500,
                                $$PLSQL_UNIT ||
                                '.send_dir_instalacion - get_datos: ' ||
                                SQLERRM);
    END;

    l_dir_inst.customer_id := obtener_customer_id(l_dir_inst.codcli);

    RETURN l_dir_inst;
  END;
  /* **********************************************************************************************/
  FUNCTION obtener_dir_facturacion(p_idwf NUMBER) RETURN enviar_direccion_type IS
    l_idprocess        operacion.siac_instancia.idprocess%TYPE;
    l_persona_juridica BOOLEAN := FALSE;
    l_dir_fact         enviar_direccion_type;
    l_solot            solot%ROWTYPE;

  BEGIN
    BEGIN
      l_solot             := obtener_solot(p_idwf);
      l_dir_fact.codsolot := l_solot.codsolot;

      IF operacion.pq_siac_traslado_externo.validate_sucfac(l_solot.codcli) = 1 THEN
        l_persona_juridica := TRUE;
      END IF;

      l_idprocess := obtener_idprocess(l_solot.codsolot);

      IF l_idprocess IS NOT NULL THEN

        BEGIN
          IF l_persona_juridica THEN
            l_dir_fact.codsuc := obtener_instancia_siac(l_idprocess,
                                                        'SUCURSAL FACTURACION');
          ELSE
            l_dir_fact.codsuc := obtener_instancia_siac(l_idprocess,
                                                        'SUCURSAL INSTALACION');
          END IF;

          IF l_dir_fact.codsuc IS NOT NULL THEN
            SELECT vs.codcli,
                   vs.dirsuc,
                   vs.referencia,
                   vu.nomdst,
                   vu.nompvc,
                   vu.codpos,
                   vu.nomest,
                   vu.nompai
              INTO l_dir_fact.codcli,
                   l_dir_fact.dirsuc,
                   l_dir_fact.referencia,
                   l_dir_fact.nomdst,
                   l_dir_fact.nompvc,
                   l_dir_fact.codpos,
                   l_dir_fact.nomest,
                   l_dir_fact.nompai
              FROM vtasuccli vs, vtatabdst dst, v_ubicaciones vu
             WHERE vs.codsuc = l_dir_fact.codsuc
               AND vs.ubisuc = dst.codubi
               AND vs.ubisuc = vu.codubi;
          END IF;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            l_dir_fact.codsuc := NULL;
        END;
      END IF;

      IF l_dir_fact.codsuc IS NULL AND NOT l_persona_juridica THEN
        SELECT DISTINCT vs.codcli,
                        vs.dirsuc,
                        vs.referencia,
                        vu.nomdst,
                        vu.nompvc,
                        vu.codpos,
                        vu.nomest,
                        vu.nompai
          INTO l_dir_fact.codcli,
               l_dir_fact.dirsuc,
               l_dir_fact.referencia,
               l_dir_fact.nomdst,
               l_dir_fact.nompvc,
               l_dir_fact.codpos,
               l_dir_fact.nomest,
               l_dir_fact.nompai
          FROM solot so, vtadetptoenl vd, vtasuccli vs, v_ubicaciones vu
         WHERE so.codsolot = l_solot.codsolot
           AND so.numslc = vd.numslc
           AND vd.codsuc = vs.codsuc
           AND vs.ubisuc = vu.codubi;

      END IF;
    EXCEPTION
      WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20500,
                                $$PLSQL_UNIT ||
                                '.send_ws_dir_facturacion - get_datos: ' ||
                                SQLERRM);
    END;

    l_dir_fact.customer_id := obtener_customer_id(l_dir_fact.codcli);

    RETURN l_dir_fact;
  END;
  /* **********************************************************************************************/
  FUNCTION obtener_instancia_siac(p_idprocess      operacion.siac_instancia.idprocess%TYPE,
                                  p_tipo_instancia operacion.siac_instancia.tipo_instancia%TYPE)
    RETURN operacion.siac_instancia.instancia%TYPE IS
    l_instancia operacion.siac_instancia.instancia%TYPE;
    l_count     PLS_INTEGER;

  BEGIN
    SELECT COUNT(*)
      INTO l_count
      FROM operacion.siac_instancia i
     WHERE i.idprocess = p_idprocess
       AND i.tipo_instancia = p_tipo_instancia;

    IF l_count > 0 THEN
      SELECT i.instancia
        INTO l_instancia
        FROM operacion.siac_instancia i
       WHERE i.idprocess = p_idprocess
         AND i.tipo_instancia = p_tipo_instancia;

      RETURN l_instancia;
    END IF;

    RETURN NULL;
  END;
  /* **********************************************************************************************/
  FUNCTION obtener_idprocess(p_codsolot solot.codsolot%TYPE)
    RETURN operacion.siac_instancia.idprocess%TYPE IS
    l_idprocess operacion.siac_instancia.idprocess%TYPE;
    l_count     PLS_INTEGER;

  BEGIN
    SELECT COUNT(*)
      INTO l_count
      FROM operacion.siac_instancia i
     WHERE i.instancia = p_codsolot
       AND i.tipo_instancia = 'SOT';

    IF l_count > 0 THEN
      SELECT i.idprocess
        INTO l_idprocess
        FROM operacion.siac_instancia i
       WHERE i.instancia = p_codsolot
         AND i.tipo_instancia = 'SOT';

      RETURN l_idprocess;
    END IF;

    RETURN NULL;
  END;
  /* **********************************************************************************************/
  FUNCTION llenar_tareawfseg(pp_idtareawf  NUMBER,
                             p_observacion tareawfseg.observacion%TYPE,
                             p_idobserv    tareawfseg.idobserv%TYPE)
    RETURN tareawfseg%ROWTYPE IS
    l_tareawfseg tareawfseg%ROWTYPE;

  BEGIN
    l_tareawfseg.idtareawf   := pp_idtareawf;
    l_tareawfseg.observacion := p_observacion;
    l_tareawfseg.idobserv    := p_idobserv;

    RETURN l_tareawfseg;
  END;
  /* **********************************************************************************************/
  PROCEDURE insertar_tareawfseg(p_tareawfseg tareawfseg%ROWTYPE) IS
  BEGIN
    INSERT INTO tareawfseg VALUES p_tareawfseg;
  END;
  /* **********************************************************************************************/
  FUNCTION llenar_int_send_dir_bscs_log(p_tipo       VARCHAR2,
                                        pp_idtareawf NUMBER,
                                        p_direccion  enviar_direccion_type,
                                        p_result     VARCHAR2,
                                        pp_mensaje   VARCHAR2)
    RETURN operacion.int_send_dir_bscs_log%ROWTYPE IS
    ll_int_send_dir_bscs_log operacion.int_send_dir_bscs_log%ROWTYPE;

  BEGIN
    ll_int_send_dir_bscs_log.Idtareawf      := pp_idtareawf;
    ll_int_send_dir_bscs_log.codsolot       := p_direccion.codsolot;
    ll_int_send_dir_bscs_log.codcli         := p_direccion.codcli;
    ll_int_send_dir_bscs_log.codsuc         := p_direccion.codsuc;
    ll_int_send_dir_bscs_log.tipo_instancia := p_tipo;
    ll_int_send_dir_bscs_log.resultado      := p_result;
    ll_int_send_dir_bscs_log.mensaje        := pp_mensaje;
    ll_int_send_dir_bscs_log.customer_id    := p_direccion.customer_id;
    ll_int_send_dir_bscs_log.referencia     := p_direccion.referencia;
    ll_int_send_dir_bscs_log.dirsuc         := p_direccion.dirsuc;
    --INSTALACION
    ll_int_send_dir_bscs_log.idplano := p_direccion.idplano;
    ll_int_send_dir_bscs_log.ubigeo  := p_direccion.ubigeo;
    --FACTURACION
    ll_int_send_dir_bscs_log.nomdst := p_direccion.nomdst;
    ll_int_send_dir_bscs_log.nompvc := p_direccion.nompvc;
    ll_int_send_dir_bscs_log.codpos := p_direccion.codpos;
    ll_int_send_dir_bscs_log.nomest := p_direccion.nomest;
    ll_int_send_dir_bscs_log.nompai := p_direccion.nompai;

    RETURN ll_int_send_dir_bscs_log;
  END;
  /* **********************************************************************************************/
  PROCEDURE insertar_int_send_dir_bscs_log(p_int_send_dir_bscs_log operacion.int_send_dir_bscs_log%ROWTYPE) IS
  BEGIN
    INSERT INTO operacion.int_send_dir_bscs_log VALUES p_int_send_dir_bscs_log;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20500,
                              $$PLSQL_UNIT ||
                              '.send_dir_facturacion - insert_int_send_dir_bscs_log: ' ||
                              SQLERRM);
  END;
  /* **********************************************************************************************/
  PROCEDURE validar_rpta_dir_envio(p_result VARCHAR2, p_tipo VARCHAR2) IS
  BEGIN
    IF p_result != '0' and p_tipo='DIRECCION_INSTALACION' THEN
      RAISE_APPLICATION_ERROR(-20500, 'No se actualizó ' || p_tipo);
    elsif p_result != '1' and p_tipo='DIRECCION_FACTURACION' THEN
      RAISE_APPLICATION_ERROR(-20500, 'No se actualizó ' || p_tipo);
    END IF;
  END;
  /* **********************************************************************************************/
  FUNCTION obtener_solot(p_idwf NUMBER) RETURN solot%ROWTYPE IS
    l_solot solot%ROWTYPE;

  BEGIN
    SELECT s.*
      INTO l_solot
      FROM wf, solot s
     WHERE wf.idwf = p_idwf
       AND wf.codsolot = s.codsolot;

    RETURN l_solot;
  END;
  /* **********************************************************************************************/
  FUNCTION obtener_customer_id(p_codcli sales.vtatabslcfac.codcli%TYPE)
    RETURN sales.cliente_sisact.customer_id%TYPE IS
    l_customer_id sales.cliente_sisact.customer_id%TYPE;
    l_error EXCEPTION;

  BEGIN
    SELECT MAX(c.customer_id)
      INTO l_customer_id
      FROM sales.cliente_sisact c
     WHERE c.codcli = p_codcli;

    IF l_customer_id IS NULL THEN
      RAISE l_error;
    END IF;

    RETURN l_customer_id;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20500,
                              'El cliente SGA"' || p_codcli ||
                              '" no presenta registro en SISACT ');
  END;
  /* **********************************************************************************************/
  FUNCTION obtener_tipesttar(p_esttarea esttarea.esttarea%TYPE)
    RETURN esttarea.tipesttar%TYPE IS
    l_tipesttar esttarea.tipesttar%TYPE;

  BEGIN
    SELECT e.tipesttar
      INTO l_tipesttar
      FROM esttarea e
     WHERE e.esttarea = p_esttarea;

    RETURN l_tipesttar;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20500,
                              $$PLSQL_UNIT || '.GET_TIPESTTAR: ' || SQLERRM);
  END;
  /* **********************************************************************************************/
  FUNCTION llamar_webservice(p_xml VARCHAR2, p_url VARCHAR2) RETURN VARCHAR2 IS
    l_data     VARCHAR2(32767);
    l_request  utl_http.req;
    l_response utl_http.resp;

  BEGIN
    l_request := UTL_HTTP.BEGIN_REQUEST(p_url, 'POST', 'HTTP/1.1');
    UTL_HTTP.SET_HEADER(l_request, 'Content-Type', 'text/xml');
    UTL_HTTP.SET_HEADER(l_request, 'Content-Length', LENGTH(p_xml));
    UTL_HTTP.WRITE_TEXT(l_request, p_xml);
    l_response := UTL_HTTP.GET_RESPONSE(l_request);
    UTL_HTTP.READ_TEXT(l_response, l_data);
    UTL_HTTP.END_RESPONSE(l_response);

    RETURN l_data;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.CALL_WEBSERVICE: ' || SQLERRM);
  END;
  /* **********************************************************************************************/
  FUNCTION extraer_ws_atributo(p_xml VARCHAR2, p_atributo VARCHAR2)
    RETURN VARCHAR2 IS
    l_xml VARCHAR2(32767);

  BEGIN
    l_xml := p_xml;

    IF INSTR(l_xml, p_atributo) > 0 OR INSTR(l_xml, p_atributo) IS NOT NULL THEN
      l_xml := SUBSTR(l_xml, INSTR(l_xml, p_atributo) + LENGTH(p_atributo) + 1);
      l_xml := SUBSTR(l_xml, 1, INSTR(l_xml, '<') - 1);

      RETURN l_xml;

    ELSE
      RETURN 'ERROR_EXTRACT_WEBSERVICE_ATRIBUTO :' || p_atributo;

    END IF;
  END;
  /* **********************************************************************************************/
  PROCEDURE error_por_envio_direccion(p_idtareawf_padre IN NUMBER, p_result OUT NUMBER) IS
    l_wf        wf%ROWTYPE;
    l_idtareawf tareawfcpy.idtareawf%TYPE;
    l_count     PLS_INTEGER;

  BEGIN
    SELECT wf.*
      INTO l_wf
      FROM tareawfcpy t, wf
     WHERE t.idtareawf = p_idtareawf_padre
       AND t.idwf = wf.idwf;

   -- IF intraway.pq_intraway.es_tras_ext_hfc_siac(l_wf.codsolot) THEN

      SELECT t.idtareawf
        INTO l_idtareawf
        FROM tareawfcpy t
       WHERE t.idwf = l_wf.idwf
         AND t.descripcion = 'Actualización información BSCS';

      SELECT COUNT(*)
        INTO l_count
        FROM operacion.int_send_dir_bscs_log s
       WHERE s.idtareawf = l_idtareawf
         AND s.mensaje != 'OK';

      IF l_count > 0 THEN
        p_result := 1;
      END IF;

  --  ELSE
  --    p_result := 0;
  --  END IF;
  END;
  /* **********************************************************************************************/
END PQ_OPE_SIAC_BSCS;
/