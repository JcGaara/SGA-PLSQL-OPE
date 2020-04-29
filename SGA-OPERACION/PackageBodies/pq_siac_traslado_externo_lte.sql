CREATE OR REPLACE PACKAGE BODY OPERACION.pq_siac_traslado_externo_lte IS
  /************************************************************************************************
  NOMBRE:     OPERACION.PQ_POSTVENTA_UNIFICADA
  PROPOSITO:  Generacion de Post Venta Automatica LTE - traslado Externo

  REVISIONES:
   Version   Fecha          Autor            Solicitado por      Descripcion
   -------- ----------  ------------------   -----------------   ------------------------
   1.0      20/10/2015   José Ruiz C.        Hector Huaman       Generar Traslado Externo LTE
   2.0      22/03/2016   Angel Condori       Karen Vasquez       SGA-SD-742716
   3.0      02/03/2017   Danny Sánchez       Mauro Zegarra       SGA-INC000000726842
   4.0      17/08/2018   Hitss                                   PROY-31513-TOA
  /************************************************************************************************/

  procedure execute_main(p_post_venta sales.pq_siac_postventa_lte.postventa_in_type) is
    l_codsucins         vtasuccli.codsuc%type;
    l_codsucfac         vtasuccli.codsuc%type;
    l_post_venta        sales.pq_siac_postventa_lte.postventa_in_type;
    l_numregistro       regvtamentab.numregistro%type;
    l_idpaq             paquete_venta.idpaq%type;
	-- Ini 2.0
	/*
    l_tipsrv            vtatabslcfac.tipsrv%type;
    l_validate_tipo_red number(2);
	*/
	-- Fin 2.0
    l_numslc            vtatabslcfac.numslc%type;
    l_resultado         control_mensaje.mensaje%type;
    l_codsolot          solot.codsolot%type;
    l_codcli            vtatabcli.codcli%type;
    l_numslc_old        vtatabslcfac.numslc%type;
    l_codcnt            vtatabcntcli.codcnt%type;
    l_idprocess         sales.siac_postventa_lte.id_siac_postventa_lte%type;
    l_customerid        sales.siac_postventa_lte.customer_id%type;
    l_cargo             sales.siac_postventa_lte.cargo%type;
    -- Ini 2.0
	l_cod_id            sales.siac_postventa_lte.cod_id%type;
	l_codmotot          sales.siac_postventa_lte.codmotot%type;
	l_fecprog           sales.siac_postventa_lte.fecprog%type;
	l_franja            sales.siac_postventa_lte.franja%type;
	l_franja_hor        sales.siac_postventa_lte.franja_hor%type;
	-- l_monto             number;
    -- Fin 2.0
    av_trama            clob;
    an_res_cod          number;
    av_res_desc         varchar2(100);

    ln_areasol          number;

    -- Ini 4.0
    vidconsulta         varchar2(20);
    vobs                varchar2(4000);
    vcount              number;
    V_IDCONSULTA        number(30);
    -- Fin 4.0

  begin
    --guardar
    validar_datos(p_post_venta);

    l_post_venta := (p_post_venta);
    -- Ini 2.0
	l_customerid := p_post_venta.customer_id;
	l_cargo      := p_post_venta.cargo;
	l_cod_id     := p_post_venta.cod_id;
	l_codmotot   := p_post_venta.codmotot;
	l_fecprog    := p_post_venta.fec_prog;
    -- Fin 2.0
    l_codcli     := pq_siac_postventa.get_codcli(l_post_venta.customer_id);
    l_numslc_old := pq_siac_postventa.get_numslc(l_post_venta.cod_id, l_codcli);
    l_codcnt     := pq_siac_postventa.get_contacto(l_codcli);
    -- l_tipsrv     := operacion.pq_siac_traslado_externo.get_tipsrv(l_numslc_old); -- 2.0
    l_idpaq      := operacion.pq_siac_traslado_externo.get_idpaq(l_numslc_old);

    set_vtasuccli(l_post_venta, l_codsucins, l_codsucfac);
    -- Ini 2.0
	/*
    l_validate_tipo_red := sales.f_valida_tipo_red(l_codsucins,
                                                   l_idpaq,
                                                   l_tipsrv,
                                                   0);
    if l_validate_tipo_red = 0 then
      raise_application_error(-20000, 'La sucursal no tiene cobertura');
    end if;
	*/
    -- Fin 2.0
    l_numregistro := set_regvtamentab(l_numslc_old,
                                      l_codcli,
                                      l_codsucins,
                                      l_codcnt,
                                      l_post_venta);


    operacion.pq_siac_traslado_externo.p_load_paquete(l_idpaq,
                                                      l_numregistro,
                                                      l_codsucins,
                                                      l_numslc_old);

    --generar
    l_numslc := operacion.pq_siac_traslado_externo.generate_sef(l_numregistro);

    sales.pq_proyecto_paquete.p_genera_ptoenl_adicionales(l_numregistro,
                                                          l_numslc);
    operacion.pq_siac_traslado_externo.set_numslc_new(l_numregistro, l_numslc);
    set_vtatabprecon(l_post_venta, l_codsucins, l_numslc);
    sales.pq_proyecto_paquete.p_load_instancia_adicional(l_numslc);

    commit;

    sales.pq_proyecto.p_validar_tiposolucion(l_numslc);
    l_resultado := pq_valida_proyecto.f_valida_checkproy(l_numslc);

    if l_resultado <> 'OK' then
      raise_application_error(-20000, 'Error en generación de SOT');
    end if;

    --INI 4.0
    BEGIN
      SELECT INSTR(l_post_venta.observacion, '|',1,1)
        INTO VCOUNT
        FROM DUAL;
      IF VCOUNT > 0 THEN

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
    END;
    --Fin 4.0

    l_resultado := pq_valida_proyecto.f_proyecto_preventa(l_numslc);
    if l_resultado = 0 then
      raise_application_error(-20000,
                              'PROYECTO NO CUMPLE CON LOS REQUISITOS PARA APROBACION AUTOMATICA');
    end if;

    select s.codsolot into l_codsolot from solot s where s.numslc = l_numslc;

    l_idprocess := get_idprocess(p_post_venta.codintercaso);

    update sales.siac_postventa_lte --insercion de la solot a la tabla de transaacciones del SIAC
       set codsolot = l_codsolot
     where id_siac_postventa_lte = l_idprocess;
	-- Ini 2.0
	select franja, franja_hor
	  into l_franja, l_franja_hor
	  from sales.siac_postventa_lte
	 where codsolot = l_codsolot;

	if length(trim(l_franja_hor)) > 0 then
	   l_franja := l_franja_hor;
	end if;

        begin
          ln_areasol := OPERACION.PQ_SGA_JANUS.F_GET_CONSTANTE_CONF('CAREASOLLTE');
        exception
          when others then
            ln_areasol := 325;
        end;

	Update operacion.solot
	   set cod_id      = l_cod_id,
               customer_id = l_customerid,
               cargo       = l_cargo,
               codmotot    = l_codmotot,
               feccom      = l_fecprog,
               areasol     = ln_areasol
	 where codsolot    = l_codsolot;

	update agendamiento
       set fecagenda = to_date(l_fecprog || ' ' || l_franja_hor, 'dd/mm/yy hh24:mi')
	 where codsolot = l_codsolot;
	/*
	select s.customer_id, s.cargo
	  into l_customerid, l_cargo
	  from solot s
	 where s.codsolot = l_codsolot;
	*/
    -- Fin 2.0

    set_instancias(l_post_venta.codintercaso,
                   'PROYECTO DE POSTVENTA',
                   l_numslc);
    set_instancias(l_post_venta.codintercaso, 'SOT', l_codsolot);
    commit;
  end;

 /*********************************************************************
   FUNCION: Valida datos para Traslado Externo
   PARAMETROS:
      Entrada:
        - p_customer_id: codigo del cliente desde sisact
        - av_cod_id :codigo id
      Salida:
        - ac_equ_cur: grilla de los equipos
        - an_resultado : resultado
        - av_mensaje : mensaje del resultado
  *********************************************************************/

  procedure validar_datos(p_post_venta sales.pq_siac_postventa_lte.postventa_in_type) is
    l_count_customer pls_integer;
    l_count_ubigeo   pls_integer;
  begin

    if not operacion.pq_siac_traslado_externo.existe_cod_id(p_post_venta.cod_id) then
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

    if l_count_customer = 0 then
      raise_application_error(-20000,
                              'No existe customer_id asociado al codcli');
    end if;

    if l_count_ubigeo = 0 then
      raise_application_error(-20000, 'No existe codubigeo');
    end if;

  end;
/*********************************************************************
   FUNCION: inserta datos para la tabla VTASUBCLI para Traslado Externo
   PARAMETROS:
      Entrada:
        - p_customer_id: codigo del cliente desde sisact
        - av_cod_id :codigo id
      Salida:
        - ac_equ_cur: grilla de los equipos
        - an_resultado : resultado
        - av_mensaje : mensaje del resultado
  *********************************************************************/

PROCEDURE set_vtasuccli(p_post_venta sales.pq_siac_postventa_lte.postventa_in_type,
                          p_codsucins  OUT vtasuccli.codsuc%TYPE,
                          p_codsucfac  OUT vtasuccli.codsuc%TYPE) IS
    l_vtasuccli  vtasuccli%ROWTYPE;
    l_idinmueble inmueble.idinmueble%TYPE;
    l_tipsuc     vtatipsuc.tipsuc%TYPE;
    inmueble_rec inmueble%ROWTYPE;
    l_idhub      vtasuccli.idhub%TYPE;
    l_idcmts     vtasuccli.idcmts%TYPE;
    l_codcli     vtatabcli.codcli%TYPE;

  begin

    set_inmueble(p_post_venta, l_idinmueble);

    l_codcli                  := operacion.pq_siac_postventa.get_codcli(p_post_venta.customer_id);
    l_tipsuc                  := operacion.pq_siac_traslado_externo.get_tipsuc_ins(l_codcli);
    l_vtasuccli.codcli        := l_codcli;
    l_vtasuccli.tipsuc        := l_tipsuc;
    l_vtasuccli.nomsuc        := 'SUCURSAL - ' || operacion.pq_siac_traslado_externo.get_dsctipsuc(l_tipsuc);
    l_vtasuccli.idinmueble    := l_idinmueble;
    inmueble_rec              := operacion.pq_siac_traslado_externo.get_inmueble(l_idinmueble);
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
    l_vtasuccli.geocodzona    := operacion.pq_siac_traslado_externo.get_geocodzona(l_vtasuccli.ubisuc);
    l_vtasuccli.geocodmanzana := operacion.pq_siac_traslado_externo.get_geocodmanzana(l_vtasuccli.ubisuc,
                                                   l_vtasuccli.geocodzona);
    l_vtasuccli.idtipurb      := p_post_venta.tipourbanizacion;
    l_vtasuccli.ubigeo2       :=p_post_venta.ubigeo2;
    l_vtasuccli.flgact        := 0;

    l_vtasuccli.idhub  := l_idhub;
    l_vtasuccli.idcmts := l_idcmts;
    l_vtasuccli.codedi := NULL;
    p_codsucins        := insert_vtasuccli(l_vtasuccli);

    set_instancias(p_post_venta.codintercaso, 'SUCURSAL INSTALACION', p_codsucins);

    IF operacion.pq_siac_traslado_externo.validate_sucfac(l_codcli) = 1 THEN
      set_inmueble(p_post_venta, l_idinmueble);
      l_tipsuc                  := '0005';
      l_vtasuccli.codcli        := l_codcli;
      l_vtasuccli.tipsuc        := l_tipsuc;
      l_vtasuccli.nomsuc        := 'SUCURSAL - ' || operacion.pq_siac_traslado_externo.get_dsctipsuc(l_tipsuc);
      l_vtasuccli.idinmueble    := l_idinmueble;
      inmueble_rec              := operacion.pq_siac_traslado_externo.get_inmueble(l_idinmueble);
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
      l_vtasuccli.geocodzona    := operacion.pq_siac_traslado_externo.get_geocodzona(l_vtasuccli.ubisuc);
      l_vtasuccli.geocodmanzana := operacion.pq_siac_traslado_externo.get_geocodmanzana(l_vtasuccli.ubisuc,
                                                     l_vtasuccli.geocodzona);
      l_vtasuccli.flgact        := 0;
      p_codsucfac               := insert_vtasuccli(l_vtasuccli);
      set_instancias(p_post_venta.codintercaso, 'SUCURSAL FACTURACION', p_codsucins);

    END IF;

  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$PLSQL_UNIT || '.SET_VTASUCCLI: ' ||
                              'Error al registrar sucursal del cliente' ||
                              SQLERRM);
  END;

/*********************************************************************
   FUNCION: inserta datos para la tabla VTASUBCLI DEL Inmueble
   PARAMETROS:
      Entrada:
        - p_customer_id: codigo del cliente desde sisact
        - av_cod_id :codigo id
      Salida:
        - ac_equ_cur: grilla de los equipos
        - an_resultado : resultado
        - av_mensaje : mensaje del resultado
  *********************************************************************/

PROCEDURE set_inmueble(p_post_venta sales.pq_siac_postventa_lte.postventa_in_type,
                         p_idinmueble OUT inmueble.idinmueble%TYPE) IS
    inmueble_rec inmueble%ROWTYPE;
    l_codubigeo  marketing.vtatabdst.ubigeo%TYPE;

  BEGIN

    inmueble_rec.tipviap    := p_post_venta.tipovia;
    inmueble_rec.nomvia     := p_post_venta.nombrevia;
    inmueble_rec.numvia     := p_post_venta.numerovia;
    inmueble_rec.nomurb     := p_post_venta.nombreurbanizacion;
    inmueble_rec.manzana    := p_post_venta.manzana;
    inmueble_rec.lote       := p_post_venta.lote;
    l_codubigeo             := TRIM(p_post_venta.codubigeo);
    inmueble_rec.codubi     := operacion.pq_siac_traslado_externo.get_codubi(l_codubigeo);
    inmueble_rec.referencia := p_post_venta.referencia;
    p_idinmueble            := insert_inmueble(inmueble_rec);

  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$PLSQL_UNIT || '.SET_INMUEBLE: ' ||
                              'Error al registrar inmueble del cliente' ||
                              SQLERRM); --3.0
  END;


  /*********************************************************************
   FUNCION:inserta datos en la vtasubcli
   PARAMETROS:
      Entrada:
        - p_customer_id: codigo del cliente desde sisact
        - av_cod_id :codigo id
      Salida:
        - ac_equ_cur: grilla de los equipos
        - an_resultado : resultado
        - av_mensaje : mensaje del resultado
  *********************************************************************/

FUNCTION insert_vtasuccli(p_vtasuccli vtasuccli%ROWTYPE)
    RETURN vtasuccli.codsuc%TYPE IS
    l_codsuc vtasuccli.codsuc%TYPE;
  BEGIN

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
       flgact,
       idhub,
       idcmts,
       codedi,
       ubigeo2)
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
       p_vtasuccli.flgact,
       p_vtasuccli.idhub,
       p_vtasuccli.idcmts,
       p_vtasuccli.codedi,
       p_vtasuccli.ubigeo2)
    RETURNING codsuc INTO l_codsuc;
    RETURN l_codsuc;

  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$PLSQL_UNIT || '.INSERT_VTASUCCLI: ' ||
                              'Error al insertar sucursal de cliente' ||
                              SQLERRM);
  END;

/*********************************************************************
   FUNCION: setea las instancias.
   PARAMETROS:
      Entrada:
        - p_customer_id: codigo del cliente desde sisact
        - av_cod_id :codigo id
      Salida:
        - ac_equ_cur: grilla de los equipos
        - an_resultado : resultado
        - av_mensaje : mensaje del resultado
  *********************************************************************/

PROCEDURE set_instancias(p_cod_intercaso  sales.siac_postventa_lte.cod_intercaso%TYPE, --4.0
                           p_tipo_instancia operacion.siac_instancia.tipo_instancia%TYPE,
                           p_instancia      operacion.siac_instancia.instancia%TYPE) IS

    l_idprocess sales.siac_postventa_lte.id_siac_postventa_lte%TYPE;
  BEGIN

    l_idprocess := get_idprocess(p_cod_intercaso);


    INSERT INTO operacion.siac_instancia
      (idprocess, tipo_postventa, tipo_instancia, instancia, FLG_TECN) -- 3.0
    VALUES
      (l_idprocess,
       'TRASLADO EXTERNO LTE',
       p_tipo_instancia,
       p_instancia, 1); -- 3.0

  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$PLSQL_UNIT || '.SET_INSTANCIAS: ' ||
                              'Error al insertar instancias generadas' ||
                              SQLERRM); --3.0
  END;


/*********************************************************************
   FUNCION: Inserta datos en la tabla de venta menor.
   PARAMETROS:
      Entrada:
        - p_customer_id: codigo del cliente desde sisact
        - av_cod_id :codigo id
      Salida:
        - ac_equ_cur: grilla de los equipos
        - an_resultado : resultado
        - av_mensaje : mensaje del resultado
  *********************************************************************/
  FUNCTION set_regvtamentab(p_numslc_origen sales.vtatabslcfac.numslc%TYPE,
                            p_codcli        marketing.vtatabcli.codcli%TYPE,
                            p_codsuc_new    marketing.vtasuccli.codsuc%TYPE,
                            p_codcnt_new    marketing.vtatabcntcli.codcnt%TYPE,
                            p_post_venta    sales.pq_siac_postventa_lte.postventa_in_type)
   RETURN sales.regvtamentab.numregistro%TYPE IS

    c_vendedor_sisact_sga sales.vtatabect.codect%TYPE := '00035885';
    l_codsuc_origen       marketing.vtasuccli.codsuc%TYPE;
    l_sucursal_new        marketing.vtasuccli%ROWTYPE;
    l_sucursal_old        marketing.vtasuccli%ROWTYPE;
    l_contacto_new        marketing.vtatabcntcli%ROWTYPE;
    l_idpaq               sales.paquete_venta.idpaq%TYPE;
    l_proyecto            sales.vtatabslcfac%ROWTYPE;
    l_numregistro         sales.regvtamentab.numregistro%TYPE;

  BEGIN
    l_codsuc_origen := operacion.pq_siac_traslado_externo.get_sucursal(p_numslc_origen);
    l_idpaq         := operacion.pq_siac_traslado_externo.get_idpaq(p_numslc_origen);
    l_sucursal_old  := operacion.pq_siac_traslado_externo.get_registro_sucursal(l_codsuc_origen);
    l_sucursal_new  := operacion.pq_siac_traslado_externo.get_registro_sucursal(p_codsuc_new);
    l_contacto_new  := operacion.pq_siac_traslado_externo.get_registro_contacto(p_codcnt_new);
    l_proyecto      := operacion.pq_siac_traslado_externo.get_registro_proyecto(p_numslc_origen);

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
    set_instancias(p_post_venta.codintercaso, 'NUMREGISTRO', l_numregistro);

  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$PLSQL_UNIT || '.SET_REGVTAMENTAB: ' ||
                              'Error al insertar cabecera de traslado externo' ||
                              SQLERRM);

  END;

/*********************************************************************
   FUNCION: Inserta datos DEL INMUEBLE
   PARAMETROS:
      Entrada:
        - p_customer_id: codigo del cliente desde sisact
        - av_cod_id :codigo id
      Salida:
        - ac_equ_cur: grilla de los equipos
        - an_resultado : resultado
        - av_mensaje : mensaje del resultado
  *********************************************************************/

FUNCTION insert_inmueble(p_inmueble marketing.inmueble%ROWTYPE)
    RETURN marketing.inmueble.idinmueble%TYPE IS
    l_idinmueble inmueble.idinmueble%TYPE;

  BEGIN
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
    RETURN l_idinmueble;

  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$PLSQL_UNIT || '.INSERT_INMUEBLE: ' ||
                              'Error al insertar inmueble de cliente' ||
                              SQLERRM);
  END;
-------------------------------------------------------------------


FUNCTION get_postventa_codsolot(p_idprocess sales.siac_postventa_lte.id_siac_postventa_lte%TYPE)
    RETURN solot.codsolot%TYPE IS

    l_codsolot solot.codsolot%TYPE;

  BEGIN

    SELECT a.instancia
      INTO l_codsolot
      FROM operacion.siac_instancia a
     WHERE a.idprocess = p_idprocess
       AND a.Tipo_Instancia = 'SOT'
	   AND a.FLG_TECN = 1; -- 3.0

    RETURN l_codsolot;

  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$PLSQL_UNIT || '.GET_POSTVENTA_CODSOLOT: ' ||
                              'Error al obtener SOT de traslado externo' ||
                              SQLERRM);
  END;

-------------------------------------------------------------------

  procedure set_vtatabprecon(p_post_venta sales.pq_siac_postventa_lte.postventa_in_type,
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

  FUNCTION get_idprocess(p_cod_intercaso sales.siac_postventa_lte.cod_intercaso%TYPE)
    RETURN sales.siac_postventa_lte.id_siac_postventa_lte%TYPE IS
    l_idprocess sales.siac_postventa_lte.id_siac_postventa_lte%TYPE;
  BEGIN
    SELECT MAX(id_siac_postventa_lte)
      INTO l_idprocess
      FROM sales.siac_postventa_lte a
     WHERE a.cod_intercaso = p_cod_intercaso;
    RETURN l_idprocess;

  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$PLSQL_UNIT || '.GET_IDPROCESS: ' || 'Error al obtener idprocess' || SQLERRM);
  END;

   --------------------------------------------------------------------------------
  procedure p_actualizar_dir_instalacion(p_idtareawf tareawf.idtareawf%type,
                                         p_idwf      tareawf.idwf%type,
                                         p_tarea     tareawf.tarea%type,
                                         p_tareadef  tareawf.tareadef%type) -- 2.0
                                         -- p_resultado out integer) is --2.0
  is
    l_codsolot    solot.codsolot%type;
    l_flag_fact   sales.siac_postventa_lte.flag_act_dir_fact%type;
    l_customer_id sales.siac_postventa_lte.customer_id%type;
    l_ubigeo      sales.siac_postventa_lte.ubigeo%type;
    l_numslc      vtatabslcfac.numslc%type;
    l_direccion   inssrv.direccion%type;
	p_resultado   control_mensaje.mensaje%type;					-- 2.0
	l_referencia  sales.siac_postventa_lte.referencia%type;		-- 2.0
  begin
    select t.codsolot into l_codsolot from wf t where t.idwf = p_idwf;
    select s.flag_act_dir_fact
      into l_flag_fact
      from sales.siac_postventa_lte s
     where s.codsolot = l_codsolot;
    select t.numslc into l_numslc from solot t where t.codsolot = l_codsolot;
    select substr(direccion,1,40) -- 2.0
      into l_direccion
      from inssrv s
     where s.numslc = l_numslc
       and rownum < 2;

	select s.customer_id, s.ubigeo, substr(s.referencia,1,40) --2.0
	  into l_customer_id, l_ubigeo, l_referencia --2.0
	  from sales.siac_postventa_lte s
	 where s.codsolot = l_codsolot;

    tim.pp004_siac_hfc.sp_chg_direccion_instal@DBL_BSCS_BF(to_number(l_customer_id), --2.0
                                                           l_direccion,
                                                           null, --p_codigo_plano,
                                                           l_ubigeo,
                                                           l_referencia, -- null, --p_notas_direccion -- 2.0
                                                           p_resultado);
  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit || '.p_actualizar_dir_instalacion(' ||
                              sqlerrm);



  end;

  END;
/