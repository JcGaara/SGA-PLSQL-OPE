CREATE OR REPLACE PACKAGE BODY OPERACION.pq_siac_traslado_externo IS
  /************************************************************************************************
  NOMBRE:     OPERACION.PQ_POSTVENTA_UNIFICADA
  PROPOSITO:  Generacion de Post Venta Automatica HFC - traslado Externo

  REVISIONES:
   Version   Fecha          Autor            Solicitado por      Descripcion
   -------- ----------  ------------------   -----------------   ------------------------
   1.0      06/01/2013   Eustaquio Gibaja     Hector Huaman       Generar Traslado Externo SIAC
   2.0      09/04/2014   Carlos Chamache      Hector Huaman       Registrar observacion en solot
   3.0      24/10/2014   Eustaquio Gibaja     Hector Huaman       Validar datos de entrada.
   4.0      25/11/2014   Eustaquio Gibaja     Hector Huaman       Reemplazar variables globales por locales
   5.0      2015-03-04   Freddy Gonzales      Guillermo Salcedo   SDM 230032: Generar SOT de Translado Externo cuando el cliente viene
                                                                  anteriormente con Cambio de plan.
   6.0      2015-05-13   Freddy Gonzales      Hector Huaman       SD-298641
   7.0      22/12/2015   Fernando Loza        Karen Velezmoro     SD-560213
   8.0      2016-04-28   Diego Ramos          Paul Moya           PROY-17652 IDEA-22491 - ETAdirect.
   9.0      21/08/2017   Juan Gonzales                            PROY-27792 IDEA-34954 Requerimiento Postventa LTE
  /************************************************************************************************/
  procedure execute_main(p_post_venta operacion.pq_siac_postventa.postventa_in_type) is
    l_codsucins         vtasuccli.codsuc%type;
    l_codsucfac         vtasuccli.codsuc%type;
    l_post_venta        operacion.pq_siac_postventa.postventa_in_type;
    l_numregistro       regvtamentab.numregistro%type;
    l_idpaq             paquete_venta.idpaq%type;
    l_tipsrv            vtatabslcfac.tipsrv%type;
    l_validate_tipo_red number(2);
    l_numslc            vtatabslcfac.numslc%type;
    l_resultado         control_mensaje.mensaje%type;
    l_codsolot          solot.codsolot%type;
    l_codcli            vtatabcli.codcli%type;
    l_numslc_old        vtatabslcfac.numslc%type;
    l_codcnt            vtatabcntcli.codcnt%type;
    vidconsulta varchar2(20);
    vobs varchar2(4000);-- 9.0
    vcount number;
    V_IDCONSULTA number(30);-- 9.0

  begin
    --guardar
    validar_datos(p_post_venta);

    l_post_venta := p_post_venta;
    l_codcli     := pq_siac_postventa.get_codcli(l_post_venta.customer_id);
    l_numslc_old := pq_siac_postventa.get_numslc(l_post_venta.cod_id, l_codcli);
    l_codcnt     := pq_siac_postventa.get_contacto(l_codcli);
    l_tipsrv     := get_tipsrv(l_numslc_old);
    l_idpaq      := get_idpaq(l_numslc_old);

    set_vtasuccli(l_post_venta, l_codsucins, l_codsucfac);
    l_validate_tipo_red := sales.f_valida_tipo_red(l_codsucins,
                                                   l_idpaq,
                                                   l_tipsrv,
                                                   0);
    if l_validate_tipo_red = 0 then
      raise_application_error(-20000, 'La sucursal no tiene cobertura');
    end if;

    l_numregistro := set_regvtamentab(l_numslc_old,
                                      l_codcli,
                                      l_codsucins,
                                      l_codcnt,
                                      l_post_venta);

    p_load_paquete(l_idpaq, l_numregistro, l_codsucins, l_numslc_old);

    --generar
    l_numslc := generate_sef(l_numregistro);
    sales.pq_proyecto_paquete.p_genera_ptoenl_adicionales(l_numregistro,
                                                          l_numslc);
    set_numslc_new(l_numregistro, l_numslc);
    set_vtatabprecon(l_post_venta, l_codsucins, l_numslc);
    sales.pq_proyecto_paquete.p_load_instancia_adicional(l_numslc);

    commit;

    sales.pq_proyecto.p_validar_tiposolucion(l_numslc);
    l_resultado := pq_valida_proyecto.f_valida_checkproy(l_numslc);

    if l_resultado <> 'OK' then
      raise_application_error(-20000, $$plsql_unit || '.' || 'Error en generación de SOT' || sqlerrm );
    end if;

    BEGIN
      SELECT INSTR(l_post_venta.observacion, '|',1,1)
        INTO VCOUNT
        FROM DUAL;
      IF VCOUNT > 0 THEN
      --ini 9.0

        SELECT NVL(SUBSTR(l_post_venta.observacion,1,INSTR(l_post_venta.observacion, '|',-1,1)-1), ''),
               NVL(SUBSTR(l_post_venta.observacion,INSTR(l_post_venta.observacion, '|',-1,1)+1,LENGTH(l_post_venta.observacion)), '')
		   INTO vobs,
			    vidconsulta
          FROM DUAL;

          SELECT TO_NUMBER(TRIM(vidconsulta)) INTO V_IDCONSULTA FROM DUAL;

          IF V_IDCONSULTA IS NOT NULL THEN
             sales.pkg_etadirect.actualizar_etadirect_req(vidconsulta, l_numslc);
          END IF;
      END IF;

    EXCEPTION
      WHEN OTHERS THEN
        vidconsulta :='';
    --Fin 9.0
    END;

    l_resultado := pq_valida_proyecto.f_proyecto_preventa(l_numslc);
    if l_resultado = 0 then
      raise_application_error(-20000,
                              'PROYECTO NO CUMPLE CON LOS REQUISITOS PARA APROBACION AUTOMATICA');
    end if;

    select s.codsolot into l_codsolot from solot s where s.numslc = l_numslc;

    set_instancias(l_post_venta.codintercaso,
                   'PROYECTO DE POSTVENTA',
                   l_numslc);
    set_instancias(l_post_venta.codintercaso, 'SOT', l_codsolot);
    commit;
    --Ini 7.0
    EXCEPTION
      WHEN OTHERS THEN
       RAISE_APPLICATION_ERROR(-20000,$$plsql_unit || '.' || ' OPERACION.pq_siac_traslado_externo.execute_main: ' || sqlerrm);
    --Fin 7.0
  end;
  /***********************************************************************************************/
  PROCEDURE set_vtasuccli(p_post_venta operacion.pq_siac_postventa.postventa_in_type,
                          p_codsucins  OUT vtasuccli.codsuc%TYPE,
                          p_codsucfac  OUT vtasuccli.codsuc%TYPE) IS
    l_vtasuccli  vtasuccli%ROWTYPE;
    l_idinmueble inmueble.idinmueble%TYPE;
    l_tipsuc     vtatipsuc.tipsuc%TYPE;
    inmueble_rec inmueble%ROWTYPE;
    l_idhub      vtasuccli.idhub%TYPE;
    l_idcmts     vtasuccli.idcmts%TYPE;
    l_codcli     vtatabcli.codcli%TYPE; --4.0

  BEGIN
    --ini 3.0
    /*    EXECUTE IMMEDIATE fix_insert_rowtype('MARKETING.VTASUCCLI')
    INTO l_vtasuccli;*/
    --fin 3.0
    /* SUCURSAL DE INSTALACION */
    set_inmueble(p_post_venta, l_idinmueble);
    --ini 4.0
    --l_tipsuc                  := get_tipsuc_ins(g_codcli);
    --l_vtasuccli.codcli        := g_codcli;
    l_codcli           := pq_siac_postventa.get_codcli(p_post_venta.customer_id);
    l_tipsuc           := get_tipsuc_ins(l_codcli);
    l_vtasuccli.codcli := l_codcli;
    --fin 4.0
    l_vtasuccli.tipsuc        := l_tipsuc;
    l_vtasuccli.nomsuc        := 'SUCURSAL - ' || get_dsctipsuc(l_tipsuc);
    l_vtasuccli.idinmueble    := l_idinmueble;
    inmueble_rec              := get_inmueble(l_idinmueble);
    l_vtasuccli.tipviap       := inmueble_rec.tipviap;
    l_vtasuccli.nomvia        := inmueble_rec.nomvia;
    l_vtasuccli.numvia        := inmueble_rec.numvia;
    l_vtasuccli.nomurb        := inmueble_rec.nomurb;
    l_vtasuccli.referencia    := inmueble_rec.referencia;
    l_vtasuccli.dirsuc        := l_vtasuccli.nomvia || ' ' ||
                                 l_vtasuccli.numvia || ' URB. ' ||
                                 l_vtasuccli.nomurb || '-' ||
                                 l_vtasuccli.referencia;
    l_vtasuccli.lote          := inmueble_rec.lote;
    l_vtasuccli.manzana       := inmueble_rec.manzana;
    l_vtasuccli.ubisuc        := inmueble_rec.codubi;
    l_vtasuccli.estado        := 1;
    l_vtasuccli.codzona       := p_post_venta.codzona;
    l_vtasuccli.geocodzona    := get_geocodzona(l_vtasuccli.ubisuc);
    l_vtasuccli.geocodmanzana := get_geocodmanzana(l_vtasuccli.ubisuc,
                                                   l_vtasuccli.geocodzona);
    l_vtasuccli.idtipurb      := p_post_venta.tipourbanizacion;
    l_vtasuccli.idplano       := p_post_venta.idplano;
    l_vtasuccli.flgact        := 0;
    get_idhub_idcmts_plano(p_post_venta.idplano,
                           p_post_venta.codubigeo,
                           l_idhub,
                           l_idcmts);
    l_vtasuccli.idhub  := l_idhub;
    l_vtasuccli.idcmts := l_idcmts;
    l_vtasuccli.codedi := NULL; --p_post_venta.codedif;
    p_codsucins        := insert_vtasuccli(l_vtasuccli);
    --ini 4.0
    -- g_codsuc           := p_codsucins;
    --set_instancias('SUCURSAL INSTALACION', p_codsucins);
    set_instancias(p_post_venta.codintercaso, 'SUCURSAL INSTALACION', p_codsucins);
    --fin 4.0

    /* SUCURSAL DE FACTURACION */
    --ini 4.0
    --IF validate_sucfac(g_codcli) = 1 THEN
    IF validate_sucfac(l_codcli) = 1 THEN
      --fin 4.0
      set_inmueble(p_post_venta, l_idinmueble);
      l_tipsuc                  := '0005';
      l_vtasuccli.codcli        := l_codcli; --g_codcli;--4.0
      l_vtasuccli.tipsuc        := l_tipsuc;
      l_vtasuccli.nomsuc        := 'SUCURSAL - ' || get_dsctipsuc(l_tipsuc);
      l_vtasuccli.idinmueble    := l_idinmueble;
      inmueble_rec              := get_inmueble(l_idinmueble);
      l_vtasuccli.tipviap       := inmueble_rec.tipviap;
      l_vtasuccli.nomvia        := inmueble_rec.nomvia;
      l_vtasuccli.numvia        := inmueble_rec.numvia;
      l_vtasuccli.nomurb        := inmueble_rec.nomurb;
      l_vtasuccli.referencia    := inmueble_rec.referencia;
      l_vtasuccli.dirsuc        := l_vtasuccli.nomvia || ' ' ||
                                   l_vtasuccli.numvia || ' URB. ' ||
                                   l_vtasuccli.nomurb || '-' ||
                                   l_vtasuccli.referencia;
      l_vtasuccli.lote          := inmueble_rec.lote;
      l_vtasuccli.manzana       := inmueble_rec.manzana;
      l_vtasuccli.ubisuc        := inmueble_rec.codubi;
      l_vtasuccli.estado        := 1;
      l_vtasuccli.geocodzona    := get_geocodzona(l_vtasuccli.ubisuc);
      l_vtasuccli.geocodmanzana := get_geocodmanzana(l_vtasuccli.ubisuc,
                                                     l_vtasuccli.geocodzona);
      l_vtasuccli.flgact        := 0;
      p_codsucfac               := insert_vtasuccli(l_vtasuccli);
      --ini 4.0
      --set_instancias('SUCURSAL FACTURACION', p_codsucins);
      set_instancias(p_post_venta.codintercaso, 'SUCURSAL FACTURACION', p_codsucins);
      --fin 4.0
    END IF;

  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$PLSQL_UNIT || '.SET_VTASUCCLI: ' ||
                              'Error al registrar sucursal del cliente' ||
                              SQLERRM); --3.0
  END;
  /********************************************************************************************************************/
  FUNCTION get_inmueble(p_idinmueble marketing.inmueble.idinmueble%TYPE)
    RETURN marketing.inmueble%ROWTYPE IS
    l_inmueble inmueble%ROWTYPE;

  BEGIN
    SELECT * INTO l_inmueble FROM inmueble t WHERE t.idinmueble = p_idinmueble;
    RETURN l_inmueble;

  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$PLSQL_UNIT || '.GET_INMUEBLE: ' ||
                              'No se encontro registros del inmueble:' ||
                              to_char(p_idinmueble));
  END;
  /********************************************************************************************************************/
  PROCEDURE set_inmueble(p_post_venta operacion.pq_siac_postventa.postventa_in_type,
                         p_idinmueble OUT inmueble.idinmueble%TYPE) IS
    inmueble_rec inmueble%ROWTYPE;
    l_codubigeo  marketing.vtatabdst.ubigeo%TYPE;

  BEGIN
    -- INSTALACION / FACTURACION
    --ini 3.0
    /*    EXECUTE IMMEDIATE fix_insert_rowtype('MARKETING.INMUEBLE')
    INTO inmueble_rec;*/
    --fin 3.0
    inmueble_rec.tipviap    := p_post_venta.tipovia;
    inmueble_rec.nomvia     := p_post_venta.nombrevia;
    inmueble_rec.numvia     := p_post_venta.numerovia;
    inmueble_rec.nomurb     := p_post_venta.nombreurbanizacion;
    inmueble_rec.manzana    := p_post_venta.manzana;
    inmueble_rec.lote       := p_post_venta.lote;
    l_codubigeo             := TRIM(p_post_venta.codubigeo);
    inmueble_rec.codubi     := get_codubi(l_codubigeo);
    inmueble_rec.referencia := p_post_venta.referencia;
    inmueble_rec.idplano    := p_post_venta.idplano;
    p_idinmueble            := insert_inmueble(inmueble_rec);

  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$PLSQL_UNIT || '.SET_INMUEBLE: ' ||
                              'Error al registrar inmueble del cliente' ||
                              SQLERRM); --3.0
  END;
  /************************************************************************************************/
  FUNCTION get_codubi(p_ubigeo marketing.vtatabdst.ubigeo%TYPE)
    RETURN marketing.inmueble.codubi%TYPE IS
    l_codubi marketing.inmueble.codubi%TYPE;

  BEGIN
    SELECT t.codubi INTO l_codubi FROM vtatabdst t WHERE t.ubigeo = p_ubigeo;

    RETURN l_codubi;

  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$PLSQL_UNIT || '.GET_CODUBI: ' ||
                              'No se encontro codigo de ubicacion' || SQLERRM);
  END;
  /* **********************************************************************************************/
  FUNCTION get_tipsuc_ins(p_codcli vtatabcli.codcli%TYPE)
    RETURN vtasuccli.tipsuc%TYPE IS
    l_return vtasuccli.tipsuc%TYPE;
    l_count  PLS_INTEGER;

  BEGIN
    SELECT COUNT(1)
      INTO l_count
      FROM vtasuccli t
     WHERE t.codcli = p_codcli
       AND t.tipsuc = '0001';

    IF l_count = 0 THEN
      l_return := '0001'; --PRINCIPAL
    ELSE
      l_return := '0002'; --SECUNDARIA
    END IF;

    RETURN l_return;

  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$PLSQL_UNIT || '.GET_TIPSUC_INS: ' ||
                              'Error al consultar tipo de sucursal' || SQLERRM);
  END;
  /********************************************************************************************************************/
  FUNCTION get_dsctipsuc(p_tipsuc vtatipsuc.tipsuc%TYPE)
    RETURN vtatipsuc.dsctipsuc%TYPE IS
    l_return vtatipsuc.dsctipsuc%TYPE;

  BEGIN
    SELECT t.dsctipsuc
      INTO l_return
      FROM vtatipsuc t
     WHERE t.tipsuc = p_tipsuc;

    RETURN l_return;

  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$PLSQL_UNIT || '.GET_DSCTIPSUC: ' ||
                              'Error al consultar descripcion del tipo de sucursal' ||
                              SQLERRM);
  END;
  /********************************************************************************************************************/
  FUNCTION get_geocodzona(p_codubi vtatabdst.codubi%TYPE)
    RETURN vtasuccli.geocodzona%TYPE IS
    l_count  PLS_INTEGER;
    l_return vtasuccli.geocodzona%TYPE;

  BEGIN
    SELECT COUNT(1)
      INTO l_count
      FROM mktgeorefzona t
     WHERE t.codubi = TRIM(p_codubi)
       AND t.estado = 1;

    IF l_count = 1 THEN
      SELECT t.codzona
        INTO l_return
        FROM mktgeorefzona t
       WHERE t.codubi = TRIM(p_codubi)
         AND t.estado = 1;

    ELSIF l_count > 1 THEN
      SELECT t.codzona
        INTO l_return
        FROM mktgeorefzona t
       WHERE t.codubi = TRIM(p_codubi)
         AND t.estado = 1
         AND t.codzona = 'ND'
         AND rownum = 1;
    END IF;

    RETURN l_return;

  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$PLSQL_UNIT || '.GET_GEOCODZONA: ' ||
                              'Error al consultar zona de sucursal' || SQLERRM);
  END;
  /********************************************************************************************************************/
  FUNCTION get_geocodmanzana(p_codubi  vtatabdst.codubi%TYPE,
                             p_codzona mktgeorefzona.codzona%TYPE)
    RETURN vtasuccli.geocodmanzana%TYPE IS
    l_return vtasuccli.geocodmanzana%TYPE;
    l_count  PLS_INTEGER;

  BEGIN
    SELECT COUNT(1)
      INTO l_count
      FROM mktgeorefmanzana t
     WHERE t.codubi = TRIM(p_codubi)
       AND t.codzona = p_codzona
       AND t.estado = 1;

    IF l_count = 1 THEN
      SELECT t.codmanzana
        INTO l_return
        FROM mktgeorefmanzana t
       WHERE t.codubi = TRIM(p_codubi)
         AND t.codzona = p_codzona
         AND t.estado = 1;

    ELSIF l_count > 1 THEN
      SELECT t.codmanzana
        INTO l_return
        FROM mktgeorefmanzana t
       WHERE t.codubi = TRIM(p_codubi)
         AND t.codzona = p_codzona
         AND t.codmanzana = 'ND'
         AND t.estado = 1
         AND rownum = 1;
    END IF;

    RETURN l_return;

  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$PLSQL_UNIT || '.GET_GEOCODMANZANA: ' ||
                              'Error al  consultar manzana  de sucursal' ||
                              SQLERRM);
  END;
  /********************************************************************************************************************/
  FUNCTION get_tipper(p_tipdide marketing.vtatipdid.tipdide%TYPE)
    RETURN marketing.vtatipdid.tipper%TYPE IS

    l_return vtatipdid.tipper%TYPE;

  BEGIN
    SELECT t.tipper INTO l_return FROM vtatipdid t WHERE t.tipdide = p_tipdide;

    RETURN TRIM(l_return);

  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$PLSQL_UNIT || '.GET_TIPPER: ' ||
                              'Error al consultar tipo de persona' || SQLERRM);
  END;
  /********************************************************************************************************************/
  PROCEDURE get_idhub_idcmts_plano(p_piidplano vtasuccli.idplano%TYPE,
                                   p_codubigeo vtatabdst.ubigeo%TYPE,
                                   p_poidhub   OUT ope_hub.idhub%TYPE,
                                   p_poidcmts  OUT ope_cmts.idcmts%TYPE) IS
    l_vidhub  ope_hub.idhub%TYPE;
    l_vidcmts ope_cmts.idcmts%TYPE;
    l_codubi  vtatabdst.codubi%TYPE;

  BEGIN

    SELECT t.codubi
      INTO l_codubi
      FROM vtatabdst t
     WHERE t.ubigeo = p_codubigeo;

    SELECT d.idhub, c.idcmts
      INTO l_vidhub, l_vidcmts
      FROM vtatabgeoref a, v_ubicaciones b, ope_cmts c, ope_hub d
     WHERE a.codubi = b.codubi
       AND a.idhub = c.idhub(+)
       AND a.idcmts = c.idcmts(+)
       AND a.idhub = d.idhub(+)
       AND a.estado = 1
       AND c.estado = 1
       AND d.tipored = 2
       AND d.estado = 1
       AND a.idplano = p_piidplano
       AND a.codubi = l_codubi
     ORDER BY idplano;

    p_poidhub  := l_vidhub;
    p_poidcmts := l_vidcmts;

  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$PLSQL_UNIT || '.GET_IDHUB_IDCMTS_PLANO: ' ||
                              'Error al consultar hub' || SQLERRM);
  END;
  /********************************************************************************************************************/
  FUNCTION validate_sucfac(p_codcli marketing.vtatabcli.codcli%TYPE)
    RETURN NUMBER IS
    l_return  PLS_INTEGER;
    l_tipdide marketing.vtatabcli.tipdide%TYPE;
    l_tipper  vtatipdid.tipper%TYPE;

  BEGIN
    --TIPO DE PERSONA
    l_tipdide := get_tipdide(p_codcli);
    l_tipper  := get_tipper(l_tipdide);

    IF l_tipper = 'J' THEN
      l_return := 1;
    ELSE
      l_return := 0;
    END IF;

    RETURN l_return;

  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$PLSQL_UNIT || '.VALIDATE_SUCFAC: ' ||
                              'Error al validar tipo de sucursal' || SQLERRM);
  END;
  /* **********************************************************************************************/
  FUNCTION get_tipdide(p_codcli marketing.vtatabcli.codcli%TYPE)
    RETURN marketing.vtatabcli.tipdide%TYPE IS
    l_tipdide marketing.vtatabcli.tipdide%TYPE;

  BEGIN
    SELECT a.tipdide
      INTO l_tipdide
      FROM marketing.vtatabcli a
     WHERE a.codcli = p_codcli;
    RETURN l_tipdide;

  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$PLSQL_UNIT || '.GET_TIPDIDE: ' ||
                              'Error al consultar tipo de identidad de cliente' ||
                              SQLERRM);
  END;
  /* **********************************************************************************************/
  FUNCTION insert_inmueble(p_inmueble marketing.inmueble%ROWTYPE)
    RETURN marketing.inmueble.idinmueble%TYPE IS
    l_idinmueble inmueble.idinmueble%TYPE;

  BEGIN
    --ini 3.0
    /*    INSERT INTO inmueble
    VALUES p_inmueble
    RETURNING idinmueble INTO l_idinmueble;*/

    INSERT INTO inmueble
      (tipviap,
       nomvia,
       numvia,
       nomurb,
       manzana,
       lote,
       codubi,
       referencia,
       idplano)
    VALUES
      (p_inmueble.tipviap,
       p_inmueble.nomvia,
       p_inmueble.numvia,
       p_inmueble.nomurb,
       p_inmueble.manzana,
       p_inmueble.lote,
       p_inmueble.codubi,
       p_inmueble.referencia,
       p_inmueble.idplano)
    RETURNING idinmueble INTO l_idinmueble;
    --fin 3.0
    RETURN l_idinmueble;

  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$PLSQL_UNIT || '.INSERT_INMUEBLE: ' ||
                              'Error al insertar inmueble de cliente' ||
                              SQLERRM);
  END;
  /* **********************************************************************************************/
  PROCEDURE set_instancias(p_cod_intercaso  operacion.siac_postventa_proceso.cod_intercaso%TYPE, --4.0
                           p_tipo_instancia operacion.siac_instancia.tipo_instancia%TYPE,
                           p_instancia      operacion.siac_instancia.instancia%TYPE) IS
    -- l_post_venta_instancia operacion.siac_instancia%ROWTYPE; 3.0
    l_idprocess operacion.siac_postventa_proceso.idprocess%TYPE; --4.0
  BEGIN
    --ini 3.0
    /* EXECUTE IMMEDIATE fix_insert_rowtype('OPERACION.SIAC_INSTANCIA')
      INTO l_post_venta_instancia;
    l_post_venta_instancia.idprocess      := operacion.pq_siac_postventa.g_idprocess;
    l_post_venta_instancia.tipo_postventa := 'TRASLADO EXTERNO';
    l_post_venta_instancia.tipo_instancia := p_tipo_instancia;
    l_post_venta_instancia.instancia      := p_instancia;

    INSERT INTO operacion.siac_instancia VALUES l_post_venta_instancia;*/
    --fin 3.0
    --ini 4.0
    l_idprocess := get_idprocess(p_cod_intercaso);
    --fin 4.0

    INSERT INTO operacion.siac_instancia
      (idprocess, tipo_postventa, tipo_instancia, instancia)
    VALUES
      (l_idprocess, --operacion.pq_siac_postventa.g_idprocess, 4.0
       'TRASLADO EXTERNO',
       p_tipo_instancia,
       p_instancia);

  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$PLSQL_UNIT || '.SET_INSTANCIAS: ' ||
                              'Error al insertar instancias generadas' ||
                              SQLERRM); --3.0
  END;
  /* **********************************************************************************************/
  FUNCTION insert_vtasuccli(p_vtasuccli vtasuccli%ROWTYPE)
    RETURN vtasuccli.codsuc%TYPE IS
    l_codsuc vtasuccli.codsuc%TYPE;
  BEGIN
    --ini 3.0
    -- INSERT INTO vtasuccli VALUES p_vtasuccli RETURNING codsuc INTO l_codsuc;
    INSERT INTO vtasuccli
      (codcli,
       tipsuc,
       nomsuc,
       idinmueble,
       tipviap,
       nomvia,
       numvia,
       nomurb,
       referencia,
       dirsuc,
       lote,
       manzana,
       ubisuc,
       estado,
       codzona,
       geocodzona,
       geocodmanzana,
       idtipurb,
       idplano,
       flgact,
       idhub,
       idcmts,
       codedi)
    VALUES
      (p_vtasuccli.codcli,
       p_vtasuccli.tipsuc,
       p_vtasuccli.nomsuc,
       p_vtasuccli.idinmueble,
       p_vtasuccli.tipviap,
       p_vtasuccli.nomvia,
       p_vtasuccli.numvia,
       p_vtasuccli. nomurb,
       p_vtasuccli.referencia,
       p_vtasuccli.dirsuc,
       p_vtasuccli.lote,
       p_vtasuccli.manzana,
       p_vtasuccli.ubisuc,
       p_vtasuccli.estado,
       p_vtasuccli.codzona,
       p_vtasuccli.geocodzona,
       p_vtasuccli.geocodmanzana,
       p_vtasuccli.idtipurb,
       p_vtasuccli.idplano,
       p_vtasuccli.flgact,
       p_vtasuccli.idhub,
       p_vtasuccli.idcmts,
       p_vtasuccli.codedi)
    RETURNING codsuc INTO l_codsuc;
    -- fin 3.0
    RETURN l_codsuc;

  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$PLSQL_UNIT || '.INSERT_VTASUCCLI: ' ||
                              'Error al insertar sucursal de cliente' ||
                              SQLERRM);
  END;
  --------------------------------------------------------------------------------
  procedure set_vtatabprecon(p_post_venta operacion.pq_siac_postventa.postventa_in_type,
                             p_codsuc     vtasuccli.codsuc%type,
                             p_numslc     sales.vtatabslcfac.numslc%type) is

    c_codpai            constant vtatabprecon.codpai%type := '51';
    c_codban            constant vtatabprecon.codban%type := '007';
    c_cliente_traslados constant sales.vtatabmotivo_venta.desmotivo%type := '035';
    c_canales_agentes   constant sales.vtatabmotivo_venta.desmotivo%type := '009';
    l_codcli       vtatabcli.codcli%type;
    l_numslc_old   vtatabslcfac.numslc%type;
    l_codmotivo_tf sales.vtatabprecon.codmotivo_tf%type;

  begin
    l_codcli       := pq_siac_postventa.get_codcli(p_post_venta.customer_id);
    l_numslc_old   := operacion.pq_siac_postventa.get_numslc(p_post_venta.cod_id,
                                                             l_codcli);
    l_codmotivo_tf := get_codmotivo_tf(l_numslc_old);

    insert into vtatabprecon
      (nrodoc,
       codpai,
       numslc,
       codsucfac,
       codcli,
       fecace,
       fecrec,
       tipdoc,
       fecaplcom,
       codmodelo,
       codban,
       obsaprofe,
       codmotivo_lv,
       codmotivo_tc,
       codmotivo_tf,
       carta,
       carrier,
       presusc,
       publicar,
       codusu,
       fecusu)
    values
      (p_numslc,
       c_codpai,
       p_numslc,
       p_codsuc,
       l_codcli,
       sysdate,
       sysdate,
       '08',
       sysdate,
       0,
       c_codban,
       p_post_venta.observacion,
       c_canales_agentes,
       c_cliente_traslados,
       l_codmotivo_tf,
       p_post_venta.numcarta,
       p_post_venta.operador,
       p_post_venta.presuscrito,
       p_post_venta.publicar,
       user,
       sysdate);

  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit || '.SET_VTATABPRECON: ' ||
                              'Error al insertar contrato de cliente' ||
                              sqlerrm);
  end;
  /********************************************************************************************************************/
  FUNCTION get_codmotivo_tf(p_numslc sales.vtatabslcfac.numslc%TYPE)
    RETURN sales.vtatabprecon.codmotivo_tf%TYPE IS
    l_codmotivo_tf sales.vtatabprecon.codmotivo_tf%TYPE;

  BEGIN
    SELECT a.codmotivo_tf
      INTO l_codmotivo_tf
      FROM sales.vtatabprecon a
     WHERE a.numslc = p_numslc;
    RETURN l_codmotivo_tf;

  EXCEPTION
    WHEN no_data_found THEN
      raise_application_error(-20000,
                              $$PLSQL_UNIT || '.GET_CODMOTIVO_TF: ' ||
                              'Error al consultar tipo de facturacion del proyecto inicial del  cliente' ||
                              SQLERRM);
  END;
  /* **********************************************************************************************/
  FUNCTION set_regvtamentab(p_numslc_origen sales.vtatabslcfac.numslc%TYPE,
                            p_codcli        marketing.vtatabcli.codcli%TYPE,
                            p_codsuc_new    marketing.vtasuccli.codsuc%TYPE,
                            p_codcnt_new    marketing.vtatabcntcli.codcnt%TYPE,
                            p_post_venta    operacion.pq_siac_postventa.postventa_in_type) --<2.0>
   RETURN sales.regvtamentab.numregistro%TYPE IS
    --l_regvtamentab        sales.regvtamentab%ROWTYPE; 3.0
    c_vendedor_sisact_sga sales.vtatabect.codect%TYPE := '00035885';
    l_codsuc_origen       marketing.vtasuccli.codsuc%TYPE;
    l_sucursal_new        marketing.vtasuccli%ROWTYPE;
    l_sucursal_old        marketing.vtasuccli%ROWTYPE;
    l_contacto_new        marketing.vtatabcntcli%ROWTYPE;
    l_idpaq               sales.paquete_venta.idpaq%TYPE;
    l_proyecto            sales.vtatabslcfac%ROWTYPE;
    l_numregistro         sales.regvtamentab.numregistro%TYPE;

  BEGIN
    l_codsuc_origen := get_sucursal(p_numslc_origen);
    l_idpaq         := get_idpaq(p_numslc_origen);
    l_sucursal_old  := get_registro_sucursal(l_codsuc_origen);
    l_sucursal_new  := get_registro_sucursal(p_codsuc_new);
    l_contacto_new  := get_registro_contacto(p_codcnt_new);
    l_proyecto      := get_registro_proyecto(p_numslc_origen);
    --ini 3.0
    /*
    EXECUTE IMMEDIATE fix_insert_rowtype('SALES.REGVTAMENTAB')
      INTO l_regvtamentab;
    l_regvtamentab.codcli         := p_codcli;
    l_regvtamentab.fecpedsol      := SYSDATE;
    l_regvtamentab.codsol         := c_vendedor_sisact_sga;
    l_regvtamentab.srvpri         := 'PYMES - Servicios Complementarios';
    l_regvtamentab.codsucori      := l_codsuc_origen;
    l_regvtamentab.descptoori     := l_sucursal_old.nomsuc;
    l_regvtamentab.dirptoori      := l_sucursal_old.dirsuc;
    l_regvtamentab.ubiptoori      := l_sucursal_old.ubisuc;
    l_regvtamentab.codsucdes      := p_codsuc_new;
    l_regvtamentab.descptodes     := l_sucursal_new.nomsuc;
    l_regvtamentab.dirptodes      := l_sucursal_new.dirsuc;
    l_regvtamentab.ubiptodes      := l_sucursal_new.ubisuc;
    l_regvtamentab.codcnt         := p_codcnt_new;
    l_regvtamentab.nomcnt         := l_contacto_new.nombre;
    l_regvtamentab.tipcnt         := l_contacto_new.tipcnt;
    l_regvtamentab.idpaq          := l_idpaq;
    l_regvtamentab.codusu         := USER;
    l_regvtamentab.fecusu         := SYSDATE;
    l_regvtamentab.tipsrv         := l_proyecto.tipsrv;
    l_regvtamentab.moneda_id      := 1;
    l_regvtamentab.plazo_srv      := 11;
    l_regvtamentab.idsolucion     := l_proyecto.idsolucion;
    l_regvtamentab.idcampanha     := l_proyecto.idcampanha;
    l_regvtamentab.numslc_ori     := p_numslc_origen;
    l_regvtamentab.tipsrv_des     := l_proyecto.tipsrv;
    l_regvtamentab.idsolucion_des := l_proyecto.idsolucion;
    l_regvtamentab.idcampanha_des := l_proyecto.idcampanha;
    l_regvtamentab.obssolfac      := p_post_venta.observacion; --<2.0>

    INSERT INTO sales.regvtamentab
    VALUES l_regvtamentab
    RETURNING numregistro INTO l_numregistro;*/

    INSERT INTO sales.regvtamentab
      (codcli,
       fecpedsol,
       codsol,
       srvpri,
       codsucori,
       descptoori,
       dirptoori,
       ubiptoori,
       codsucdes,
       descptodes,
       dirptodes,
       ubiptodes,
       codcnt,
       nomcnt,
       tipcnt,
       idpaq,
       codusu,
       fecusu,
       tipsrv,
       moneda_id,
       plazo_srv,
       idsolucion,
       idcampanha,
       numslc_ori,
       tipsrv_des,
       idsolucion_des,
       idcampanha_des,
       obssolfac)
    VALUES
      (p_codcli,
       SYSDATE,
       c_vendedor_sisact_sga,
       'PYMES - Servicios Complementarios',
       l_codsuc_origen,
       l_sucursal_old.nomsuc,
       l_sucursal_old.dirsuc,
       l_sucursal_old.ubisuc,
       p_codsuc_new,
       l_sucursal_new.nomsuc,
       l_sucursal_new.dirsuc,
       l_sucursal_new.ubisuc,
       p_codcnt_new,
       l_contacto_new.nombre,
       l_contacto_new.tipcnt,
       l_idpaq,
       USER,
       SYSDATE,
       l_proyecto.tipsrv,
       1,
       11,
       l_proyecto.idsolucion,
       l_proyecto.idcampanha,
       p_numslc_origen,
       l_proyecto.tipsrv,
       l_proyecto.idsolucion,
       l_proyecto.idcampanha,
       p_post_venta.observacion)
    RETURNING numregistro INTO l_numregistro;

    RETURN l_numregistro;
    --ini 4.0
    --set_instancias('NUMREGISTRO', l_numregistro);
    set_instancias(p_post_venta.codintercaso, 'NUMREGISTRO', l_numregistro);
    --fin 4.0

  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$PLSQL_UNIT || '.SET_REGVTAMENTAB: ' ||
                              'Error al insertar cabecera de traslado externo' ||
                              SQLERRM);
      --fin 3.0
  END;
  /* **********************************************************************************************/
  FUNCTION get_sucursal(p_numslc sales.vtatabslcfac.numslc%TYPE)
    RETURN marketing.vtasuccli.codsuc%TYPE IS
    l_codect marketing.vtasuccli.codsuc%TYPE;

  BEGIN
    SELECT DISTINCT (a.codsuc)
      INTO l_codect
      FROM sales.vtadetptoenl a
     WHERE a.numslc = p_numslc;

    RETURN l_codect;

  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$PLSQL_UNIT || '.GET_SUCURSAL: ' ||
                              'Error al consultar sucursal' || SQLERRM);
  END;
  /* **********************************************************************************************/
  FUNCTION get_registro_sucursal(p_codsuc marketing.vtasuccli.codsuc%TYPE)
    RETURN marketing.vtasuccli%ROWTYPE IS
    l_vtasuccli marketing.vtasuccli%ROWTYPE;

  BEGIN
    SELECT a.* INTO l_vtasuccli FROM vtasuccli a WHERE a.codsuc = p_codsuc;
    RETURN l_vtasuccli;

  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$PLSQL_UNIT || '.GET_REGISTRO_SUCURSAL: ' ||
                              'Error al consultar registros de sucursal' ||
                              SQLERRM);
  END;
  /* **********************************************************************************************/
  FUNCTION get_registro_contacto(p_contacto marketing.vtatabcntcli.codcnt%TYPE)
    RETURN marketing.vtatabcntcli%ROWTYPE IS
    l_vtatabcntcli marketing.vtatabcntcli%ROWTYPE;

  BEGIN
    SELECT a.*
      INTO l_vtatabcntcli
      FROM marketing.vtatabcntcli a
     WHERE a.codcnt = p_contacto;

    RETURN l_vtatabcntcli;

  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$PLSQL_UNIT || '.GET_REGISTRO_CONTACTO: ' ||
                              'Error al consultar registros de contacto de cliente' ||
                              SQLERRM);
  END;
  /* **********************************************************************************************/
  FUNCTION get_idpaq(p_numslc sales.vtatabslcfac.numslc%TYPE)
    RETURN sales.paquete_venta.idpaq%TYPE IS
    l_idpaq sales.paquete_venta.idpaq%TYPE;

  BEGIN
    SELECT DISTINCT (a.idpaq)
      INTO l_idpaq
      FROM sales.vtadetptoenl a
     WHERE a.numslc = p_numslc;

    RETURN l_idpaq;

  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$PLSQL_UNIT || '.GET_REGISTRO_CONTACTO: ' ||
                              'Error al consultar registros de contacto de cliente' ||
                              SQLERRM);
  END;
  /* **********************************************************************************************/
  FUNCTION get_registro_proyecto(p_numslc sales.vtatabslcfac.numslc%TYPE)
    RETURN sales.vtatabslcfac%ROWTYPE IS
    l_proyecto vtatabslcfac%ROWTYPE;

  BEGIN
    SELECT a.*
      INTO l_proyecto
      FROM sales.vtatabslcfac a
     WHERE a.numslc = p_numslc;

    RETURN l_proyecto;

  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$PLSQL_UNIT || '.GET_REGISTRO_PROYECTO: ' ||
                              'Error al consultar registros de proyecto' ||
                              SQLERRM);
  END;
  /* **********************************************************************************************/
  PROCEDURE p_load_paquete(p_idpaq          sales.paquete_venta.idpaq%TYPE,
                           p_numregistro    sales.regvtamentab.numregistro%TYPE,
                           p_codsuc_destino marketing.vtasuccli.codsuc%TYPE,
                           p_numslc         sales.vtatabslcfac.numslc%TYPE) IS
    vins          regdetsrvmen%ROWTYPE;
    vsuc          vtasuccli%ROWTYPE;
    l_paquete     NUMBER(4);
    l_tipsrv      regvtamentab.tipsrv%TYPE;
    l_tiptra      regdetsrvmen.tiptra%TYPE;
    l_opcion      NUMBER(2) := 3;
    l_codinssrv   inssrv.codinssrv%TYPE;
    ln_porcentaje impuesto.porcentaje%TYPE;
    ln_idimpuesto impuesto.idimpuesto%TYPE;
    l_codsrv      tystabsrv.codsrv%TYPE;

    CURSOR cur_te IS
      SELECT 1 flg_adicional,
             a.iddet,
             c.idproducto,
             (SELECT z.descripcion
                FROM detalle_paquete x,  producto z
               WHERE x.idpaq = e.idpaq
                 AND x.iddet = e.iddet
                 AND x.flgprincipal = 1
                 AND x.flgestado = 1
                 AND x.idproducto = z.idproducto) principal,
             d.idgrupoproducto,
             a.codsrv,
             c.dscsrv,
             a.flgprinc flgprincipal,
             e.idpaq,
             a.codinssrv,
             e.flg_ti,
             e.flg_te,
             a.codequcom,
             1 moneda_id,
             0 montocr,
             a.cantidad,
             0 montocrxprom,
             0 cnr_srv,
             g.estcts,
             g.estcse,
             g.idprecio,
             a.pid,
             d.descripcion producto
        FROM operacion.insprd      a,
             operacion.inssrv      b,
             sales.tystabsrv       c,
             billcolper.producto   d,
             sales.detalle_paquete e,
             sales.vtadetptoenl    g
       WHERE b.codinssrv = a.codinssrv
         AND a.codsrv = c.codsrv
         AND c.codsrv = g.codsrv
         AND c.idproducto = d.idproducto
         AND d.idproducto = e.idproducto
         AND g.numpto = a.numpto
         AND b.idpaq = e.idpaq
         AND e.idpaq = g.idpaq
         AND a.iddet = e.iddet
         AND a.numslc = g.numslc
         AND a.fecfin IS NULL
         AND a.codinssrv IN
             (SELECT k.codinssrv FROM inssrv k WHERE k.numslc = p_numslc)
         AND e.idpaq = p_idpaq
      UNION ALL
      SELECT 1                 flg_adicional,
             a.iddet,
             a.idproducto,
             g.descripcion     principal,
             e.idgrupoproducto,
             b.codsrv,
             x.dscsrv,
             a.flgprincipal    flgprincipal,
             a.idpaq,
             h.codinssrv,
             a.flg_ti,
             a.flg_te,
             b.codequcom,
             c.moneda_id       moneda_id,
             0                 montocr,
             b.cantidad        cantidad,
             0                 montocrxprom,
             c.cosins          cnr_srv,
             b.estcts,
             b.estcse,
             c.idprecio,
             NULL              pid,
             e.descripcion     producto
        FROM sales.detalle_paquete a,
             sales.linea_paquete   b,
             sales.tystabsrv       x,
             sales.define_precio   c,
             sales.detalle_paquete f,
             billcolper.producto   e,
             billcolper.producto   g,
             operacion.insprd      h,
             operacion.inssrv      i
       WHERE a.iddet = b.iddet
         AND a.flgestado = b.flgestado
         AND b.flgestado = 1
         AND x.codsrv = b.codsrv
         AND b.codsrv = c.codsrv
         AND a.flg_te = 1
         AND a.paquete = f.paquete
         AND f.flgprincipal = 1
         AND f.flgestado = 1
         AND a.idpaq = f.idpaq
         AND a.idproducto = e.idproducto
         AND f.idproducto = g.idproducto
         AND f.iddet = h.iddet
         AND h.codinssrv = i.codinssrv
         AND i.idpaq = p_idpaq
         AND i.codinssrv IN
             (SELECT k.codinssrv FROM inssrv k WHERE k.numslc = p_numslc)
         AND c.plazo = 11
         AND c.tipo = 1
         AND h.fecfin IS NULL		 
		 AND A.IDDET not IN (SELECT a.iddet
        FROM operacion.insprd      a,
             operacion.inssrv      b,
             sales.tystabsrv       c,
             billcolper.producto   d,
             sales.detalle_paquete e,
             sales.vtadetptoenl    g
       WHERE b.codinssrv = a.codinssrv
         AND a.codsrv = c.codsrv
         AND c.codsrv = g.codsrv
         AND c.idproducto = d.idproducto
         AND d.idproducto = e.idproducto
         AND g.numpto = a.numpto
         AND b.idpaq = e.idpaq
         AND e.idpaq = g.idpaq
         AND a.iddet = e.iddet
         AND a.numslc = g.numslc
         AND a.fecfin IS NULL
         AND a.codinssrv IN
             (SELECT k.codinssrv FROM inssrv k WHERE k.numslc = p_numslc)
         AND e.idpaq = p_idpaq)		 
       ORDER BY principal, codinssrv DESC, producto;


  BEGIN

    SELECT a.tipsrv
      INTO l_tipsrv
      FROM regvtamentab a
     WHERE numregistro = p_numregistro;
    SELECT f_obt_tiptraxtipsrv(l_tipsrv, l_opcion) INTO l_tiptra FROM dual;
    SELECT * INTO vsuc FROM vtasuccli WHERE codsuc = p_codsuc_destino;

    l_paquete   := 0;
    l_codinssrv := 1;

    FOR c_ext IN cur_te LOOP

      SELECT banwid
        INTO vins.banwid
        FROM sales.tystabsrv
       WHERE codsrv = c_ext.codsrv;
      IF l_codinssrv <> c_ext.codinssrv THEN
        l_codinssrv := c_ext.codinssrv;
        l_paquete   := l_paquete + 1;
      END IF;

      vins.numregistro   := p_numregistro;
      vins.estcse        := c_ext.estcse;
      vins.estcts        := c_ext.estcts;
      vins.codsuc        := p_codsuc_destino;
      vins.idpaq         := c_ext.idpaq;
      vins.flgprincipal  := c_ext.flgprincipal;
      vins.codsrv        := c_ext.codsrv;
      vins.moneda_id     := c_ext.moneda_id;
      vins.idprecio      := c_ext.idprecio;
      vins.paquete       := l_paquete;
      vins.pid           := c_ext.pid;
      vins.cantidad      := c_ext.cantidad;
      vins.moneda_id     := c_ext.moneda_id;
      vins.idproducto    := c_ext.idproducto;
      vins.iddet         := c_ext.iddet;
      vins.codsuc        := vsuc.codsuc;
      vins.descpto       := vsuc.nomsuc;
      vins.dirpto        := vsuc.dirsuc;
      vins.ubipto        := vsuc.ubisuc;
      vins.fecusu        := SYSDATE;
      vins.codusu        := USER;
      vins.flgcontrol    := 0;
      ln_porcentaje      := pq_impuesto.f_obt_porcentaje_impuesto(ln_idimpuesto);
      vins.porcimp_srv   := ln_porcentaje;
      vins.porcimp_ins   := ln_porcentaje;
      vins.flgadicional  := c_ext.flg_adicional;
      vins.descsrv       := c_ext.dscsrv;
      vins.principal     := c_ext.principal;
      vins.codinssrv     := c_ext.codinssrv;
      vins.tiptra        := l_tiptra;
      vins.flg_tipo_vm   := 'TE';
      vins.prelis_ins    := 0;
      vins.desc_ins      := 0;
      vins.monto_ins     := 0;
      vins.monto_ins_imp := 0;
      vins.estcts        := 0;
      vins.prelis_srv    := 0;
      vins.desc_srv      := 0;
      vins.monto_srv     := 0;
      vins.monto_srv_imp := 0;

      IF c_ext.idgrupoproducto = 1 THEN
        vins.codequcom  := c_ext.codequcom;
        vins.prelis_srv := c_ext.montocr;
        vins.prelis_ins := c_ext.cnr_srv;
        vins.monto_srv  := c_ext.montocr;
        vins.monto_ins  := c_ext.cnr_srv;
        vins.preuni_srv := c_ext.montocr;
        vins.preuni_ins := c_ext.cnr_srv;
      ELSE
        vins.codequcom  := NULL;
        vins.prelis_srv := c_ext.montocr;
        vins.prelis_ins := c_ext.cnr_srv;
        vins.monto_srv  := c_ext.montocr;
        vins.monto_ins  := c_ext.cnr_srv;
        vins.preuni_srv := c_ext.montocr;
        vins.preuni_ins := c_ext.cnr_srv;
      END IF;

      INSERT INTO sales.regdetsrvmen VALUES vins;

    END LOOP;

    --ini 3.0
  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$PLSQL_UNIT || '.P_LOAD_PAQUETE: ' ||
                              'No se puede leer los servicios' || SQLERRM);
      --fin 3.0
  END;
  /* **********************************************************************************************/
  FUNCTION get_tipsrv(p_numslc sales.vtatabslcfac.numslc%TYPE)
    RETURN sales.vtatabslcfac.tipsrv%TYPE IS
    l_tipsrv sales.vtatabslcfac.tipsrv%TYPE;

  BEGIN
    SELECT a.tipsrv
      INTO l_tipsrv
      FROM sales.vtatabslcfac a
     WHERE a.numslc = p_numslc;

    RETURN l_tipsrv;

  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$PLSQL_UNIT || '.GET_TIPSRV: ' ||
                              'No se encuentra tipo de servicio del proyecto' ||
                              SQLERRM);
  END;
  /* **********************************************************************************************/
  -- corrige error al insertar defaults usando %ROWTYPE
  FUNCTION fix_insert_rowtype(p_schema_and_table VARCHAR2) RETURN VARCHAR2 IS
    l_default_values LONG;
    l_dot_location   PLS_INTEGER;
    l_owner          VARCHAR2(100);
    l_table          VARCHAR2(100);

    CURSOR campos IS
      SELECT t.data_default
        FROM all_tab_cols t
       WHERE t.owner = l_owner
         AND t.table_name = l_table
       ORDER BY t.internal_column_id;

  BEGIN
    l_dot_location := instr(p_schema_and_table, '.');

    l_owner := substr(p_schema_and_table, 1, l_dot_location - 1);
    l_table := substr(p_schema_and_table, l_dot_location + 1);

    FOR campo IN campos LOOP
      l_default_values := l_default_values || '' ||
                          nvl(campo.data_default, 'NULL') || ',';
    END LOOP;

    RETURN 'SELECT ' || rtrim(l_default_values, ',') || ' FROM dual';
    --Ini 7.0
    EXCEPTION
      WHEN OTHERS THEN
       RAISE_APPLICATION_ERROR(-20000,$$plsql_unit || '.' || ' OPERACION.pq_siac_traslado_externo.fix_insert_rowtype : ' || sqlerrm);
    --Fin 7.0
  END;
  /* **********************************************************************************************/
  PROCEDURE set_numslc_new(p_numregistro sales.regvtamentab.numregistro%TYPE,
                           p_numslc      sales.vtatabslcfac.numslc%TYPE) IS
  BEGIN
    UPDATE sales.regdetsrvmen
       SET numslc = p_numslc
     WHERE numregistro = p_numregistro;

    UPDATE sales.regvtamentab
       SET numslc = p_numslc
     WHERE numregistro = p_numregistro;

  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$PLSQL_UNIT || '.SET_NUMSLC_NEW: ' ||
                              'Error al actualizar proyecto en regdetsrvmen' ||
                              SQLERRM);
  END;
  /* **********************************************************************************************/
  FUNCTION generate_sef(p_numregistro sales.regvtamentab.numregistro%TYPE)
    RETURN vtadetptoenl.numslc%TYPE IS
    vproy regvtamentab%ROWTYPE;
    --p_vtatabslcfac sales.vtatabslcfac%ROWTYPE; 3.0
    p_numslc vtadetptoenl.numslc%TYPE;

  BEGIN
    SELECT * INTO vproy FROM regvtamentab WHERE numregistro = p_numregistro;
    --ini 3.0
    /*
    EXECUTE IMMEDIATE fix_insert_rowtype('SALES.VTATABSLCFAC')
      INTO p_vtatabslcfac;
    p_vtatabslcfac.codcli              := vproy.codcli;
    p_vtatabslcfac.fecpedsol           := SYSDATE;
    p_vtatabslcfac.estsolfac           := '00';
    p_vtatabslcfac.codsol              := vproy.codsol;
    p_vtatabslcfac.srvpri              := vproy.srvpri;
    p_vtatabslcfac.obssolfac           := vproy.obssolfac;
    p_vtatabslcfac.fecapr              := vproy.fecapr;
    p_vtatabslcfac.tipsrv              := vproy.tipsrv;
    p_vtatabslcfac.coddpt              := vproy.coddpt;
    p_vtatabslcfac.codsolot            := vproy.codsolot;
    p_vtatabslcfac.codsrv              := vproy.codsrv;
    p_vtatabslcfac.cliint              := vproy.cliint;
    p_vtatabslcfac.codsocio            := vproy.codsocio;
    p_vtatabslcfac.idvendea            := vproy.idvendea;
    p_vtatabslcfac.flgestcom           := 0;
    p_vtatabslcfac.codusuapr           := vproy.codusuapr;
    p_vtatabslcfac.fecestcom           := vproy.fecestcom;
    p_vtatabslcfac.flgcategoria        := vproy.flgcategoria;
    p_vtatabslcfac.moneda_id           := vproy.moneda_id;
    p_vtatabslcfac.nticket             := vproy.nticket;
    p_vtatabslcfac.plazo_srv           := vproy.plazo_srv;
    p_vtatabslcfac.on_net              := vproy.on_net;
    p_vtatabslcfac.flg_pricing         := vproy.flg_pricing;
    p_vtatabslcfac.idsolucion          := vproy.idsolucion;
    p_vtatabslcfac.area                := vproy.area;
    p_vtatabslcfac.numslc_lsg          := vproy.numslc_lsg;
    p_vtatabslcfac.idcampanha          := vproy.idcampanha;
    p_vtatabslcfac.pcflg_transferencia := vproy.pcflg_transferencia;
    p_vtatabslcfac.pcidplantilla       := vproy.pcidplantilla;
    p_vtatabslcfac.pcidproyecto        := vproy.pcidproyecto;
    p_vtatabslcfac.idprioridad         := vproy.idprioridad;

    INSERT INTO sales.vtatabslcfac
    VALUES p_vtatabslcfac
    RETURNING numslc INTO p_numslc;
    */
    --fin 3.0
    INSERT INTO sales.vtatabslcfac
      (codcli,
       fecpedsol,
       estsolfac,
       codsol,
       srvpri,
       obssolfac,
       fecapr,
       tipsrv,
       coddpt,
       codsolot,
       codsrv,
       cliint,
       codsocio,
       idvendea,
       flgestcom,
       codusuapr,
       fecestcom,
       flgcategoria,
       moneda_id,
       nticket,
       plazo_srv,
       on_net,
       flg_pricing,
       idsolucion,
       area,
       numslc_lsg,
       idcampanha,
       pcflg_transferencia,
       pcidplantilla,
       pcidproyecto,
       idprioridad)
    VALUES
      (vproy.codcli,
       SYSDATE,
       '00',
       vproy.codsol,
       vproy.srvpri,
       vproy.obssolfac,
       vproy.fecapr,
       vproy.tipsrv,
       vproy.coddpt,
       vproy.codsolot,
       vproy.codsrv,
       vproy.cliint,
       vproy.codsocio,
       vproy.idvendea,
       0,
       vproy.codusuapr,
       vproy.fecestcom,
       vproy.flgcategoria,
       vproy.moneda_id,
       vproy.nticket,
       vproy.plazo_srv,
       vproy.on_net,
       vproy.flg_pricing,
       vproy.idsolucion,
       vproy.area,
       vproy.numslc_lsg,
       vproy.idcampanha,
       vproy.pcflg_transferencia,
       vproy.pcidplantilla,
       vproy.pcidproyecto,
       vproy.idprioridad)
    RETURNING numslc INTO p_numslc;

    --g_numslc_new := p_numslc;--4.0
    RETURN p_numslc;

  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$PLSQL_UNIT || '.GENERATE_SEF: ' ||
                              'Error al generar SEF' || SQLERRM); --3.0
  END;
  --------------------------------------------------------------------------------
  procedure validar_datos(p_post_venta operacion.pq_siac_postventa.postventa_in_type) is
    l_count_customer pls_integer;
    l_count_ubigeo   pls_integer;
    l_count_codplano pls_integer;

  begin
    if not existe_cod_id(p_post_venta.cod_id) then
      raise_application_error(-20000, 'No existe cod_id asociado a la SOT');
    end if;

    select count(*)
      into l_count_customer
      from sales.cliente_sisact
     where customer_id = p_post_venta.customer_id;

    select count(*)
      into l_count_ubigeo
      from vtatabdst
     where ubigeo = p_post_venta.codubigeo;

    select count(*)
      into l_count_codplano
      from vtatabgeoref
     where idplano = p_post_venta.idplano;

    if l_count_customer = 0 then
      raise_application_error(-20000,
                              'No existe customer_id asociado al codcli');
    end if;

    if l_count_ubigeo = 0 then
      raise_application_error(-20000, 'No existe codubigeo');
    end if;

    if l_count_codplano = 0 then
      raise_application_error(-20000, 'No existe idplano');
    end if;
    --Ini 7.0
    EXCEPTION
      WHEN OTHERS THEN
       RAISE_APPLICATION_ERROR(-20000,$$plsql_unit || '.' || ' OPERACION.pq_siac_traslado_externo.validar_datos : ' || sqlerrm);
    --Fin 7.0
  end;
  /* **********************************************************************************************/
  --ini 4.0
  FUNCTION get_idprocess(p_cod_intercaso siac_postventa_proceso.cod_intercaso%TYPE)
    RETURN siac_postventa_proceso.idprocess%TYPE IS
    l_idprocess siac_postventa_proceso.idprocess%TYPE;
  BEGIN
    SELECT MAX(idprocess)
      INTO l_idprocess
      FROM siac_postventa_proceso a
     WHERE a.cod_intercaso = p_cod_intercaso;
    RETURN l_idprocess;

  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$PLSQL_UNIT || '.GET_IDPROCESS: ' || 'Error al obtener idprocess' || SQLERRM);
  END;
  /* **********************************************************************************************/
  FUNCTION get_postventa_codsolot(p_idprocess siac_postventa_proceso.idprocess%TYPE)
    RETURN solot.codsolot%TYPE IS

    l_codsolot solot.codsolot%TYPE;

  BEGIN

    SELECT a.instancia
      INTO l_codsolot
      FROM operacion.siac_instancia a
     WHERE a.idprocess = p_idprocess
       AND a.Tipo_Instancia = 'SOT';

    RETURN l_codsolot;

  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$PLSQL_UNIT || '.GET_POSTVENTA_CODSOLOT: ' ||
                              'Error al obtener SOT de traslado externo' ||
                              SQLERRM);
  END;
  /* **********************************************************************************************/
--fin 4.0
  --------------------------------------------------------------------------------
  function existe_cod_id(p_cod_id sales.sot_sisact.cod_id%type) return boolean is
    l_count pls_integer;

  begin
    -- SOTs de alta desde SISACT
    select count(*) into l_count from sales.sot_sisact where cod_id = p_cod_id;

    if l_count = 0 then
      -- SOTs de Post Venta desde SISACT
      select count(*) into l_count from sales.sot_siac where cod_id = p_cod_id;
    end if;

    return l_count > 0;

  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit || '.existe_cod_id(p_cod_id => ' ||
                              p_cod_id || ') ' || sqlerrm);
  end;
  --------------------------------------------------------------------------------
END;
/
