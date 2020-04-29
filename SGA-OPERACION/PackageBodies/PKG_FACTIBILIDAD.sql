CREATE OR REPLACE PACKAGE BODY OPERACION.PKG_FACTIBILIDAD IS

  PROCEDURE SGASS_SM_GET_CID(K_CODDIRECCION    MARKETING.SGAT_DIRGEOREF_SW.DGRN_CODDIRECCION%TYPE,
                             K_CODSUBDIRECCION MARKETING.SGAT_DIRGEOREF_SW.DGRN_CODSUBDIRECCION%TYPE,
                             K_CID             OUT SYS_REFCURSOR,
                             K_CODIGO          OUT PLS_INTEGER,
                             K_MENSAJE         OUT VARCHAR2) IS
  
	/****************************************************************
	* Nombre sp         : sgass_sm_get_cid
	* Proposito         : Obtener los cids de acuerdo a las direcciones y subdirecciones de smallword.
	* Input             : <parametro> - descripcion de los parametros
	* Output            : <descripcion de la salida>
	* Creado por        : Andrés arias
	* Modificado por    : Andrés arias
	* Fec creacion      : 08/05/2019 15:21:00
	* Fec actualizacion : 05/11/2019 10:19:00
	****************************************************************/
  
    CURSOR CUR_CID IS
      SELECT CID, CODCLI FROM OPERACION.INSSRV;
    TYPE T_CID IS TABLE OF CUR_CID%ROWTYPE;
  
    V_CID_T    T_CID;
  
    V_SQL      VARCHAR2(1000);
    V_SQL2     VARCHAR2(100);
    V_MENSAJE  VARCHAR2(1000);
  
  BEGIN
    IF (K_CODDIRECCION IS NULL OR K_CODDIRECCION = 0) THEN
      K_CODIGO  := 1;
      K_MENSAJE := 'ERROR EN CODDIRECCION, DEBE DE INGRESAR UN VALOR.';
      RETURN;
    END IF;
  
    V_SQL := 'SELECT DISTINCT I.CID, I.CODCLI
                 FROM OPERACION.INSSRV I
					  INNER JOIN MARKETING.VTASUCCLI S
                   ON I.CODCLI = S.CODCLI
                      AND I.CODSUC = S.CODSUC
                 INNER JOIN MARKETING.INMUEBLE D
					    ON S.IDINMUEBLE = D.IDINMUEBLE
                 WHERE D.INMUN_CODDIRECCION = ' || K_CODDIRECCION;
 
    IF K_CODSUBDIRECCION IS NOT NULL THEN
      V_SQL2 := ' AND D.INMUN_CODSUBDIRECCION = ' || K_CODSUBDIRECCION;
      V_SQL  := V_SQL || V_SQL2;
    END IF;
  
    EXECUTE IMMEDIATE V_SQL BULK COLLECT
      INTO V_CID_T;
  
    IF V_CID_T.COUNT < 1 THEN
      K_CODIGO  := 2;
      K_MENSAJE := 'NO EXISTEN CIDs ASOCIADAS A DIRECCION.';
    
      OPEN K_CID FOR 'SELECT NULL FROM DUAL';
      RETURN;
    END IF;
  
    K_CODIGO  := 0;
    K_MENSAJE := 'CIDs OBTENIDOS CORRECTAMENTE.';
  
    OPEN K_CID FOR V_SQL;
  
  EXCEPTION
    WHEN OTHERS THEN
      K_CODIGO  := -20000;
      V_MENSAJE := ' SQLCODE: ' || TO_CHAR(SQLCODE) || ' - SQLERRM: ' || SQLERRM;
      K_MENSAJE := 'SGASS_SM_GET_CID.' || V_MENSAJE;    
  END;

  /*
  '****************************************************************
  '* Nombre sp              :  SGASS_TRAZA_FACT
  '* Proposito              :  Obtener los registos a factibilizar.
  '* Input                  :  PI_ESTADO         - Estado a buscar
  '* Output                 :  PO_CURSOR         - Cursor de registros a factibilizar
  '*                           PO_CODERROR       - Mensaje de Respuesta
  '*                           PO_MSGERR         - Codigo de Respuesta
  '* Creado por             :  Cesar Nicho
  '* Modificado por         :  Andrés Arias
  '* Fec. Creacion          :  21/05/2019
  '* Fec. Actualizacion     :  05/11/2019 17:32:00
  '****************************************************************
  */
  PROCEDURE SGASS_TRAZA_FACT(PI_ESTADO   IN VARCHAR2,
                             PO_CURSOR   OUT SYS_REFCURSOR,
                             PO_CODERROR OUT NUMBER,
                             PO_MSGERR   OUT VARCHAR2) IS
    V_ERROR EXCEPTION;
    V_CODERROR   NUMBER;
    V_MSGERR     VARCHAR(200);
  
  BEGIN
    IF PI_ESTADO IS NULL THEN
      V_CODERROR := -1;
      V_MSGERR   := 'PARAMETROS OBLIGATORIOS';
      RAISE V_ERROR;
    END IF;
  
    OPEN PO_CURSOR FOR
      SELECT TF.TRFAN_IDTRAZA,
             TF.TRFAV_NOMBAPP,
             TF.TRFAV_CODPROYECTO,
             TF.TRFAV_CODSUCURSAL,
             TF.TRFAV_CODUBIGEO,
             TF.TRFAV_NROVIA,
             (SELECT DATORELA1 
					  FROM MARKETING.PERTBEX02 T
					 WHERE CDTABL = 'TV'
						AND CDARGU = TF.TRFAV_CODTIPOVIA) TRFAV_CODTIPOVIA,
             TF.TRFAV_NOMBREVIA,
             TF.TRFAV_USUREG,
             TO_CHAR(TF.TRFAD_FECHAREG, 'YYYYMMDDHH24MISS') FECHA_UTC_CHAR,
             TF.TRFAV_ESTADO,
             TF.TRFAV_MZNA,
             TF.TRFAV_LOTE,
             TF.TRFAV_SUBLOTE
        FROM OPERACION.SGAT_TRAZA_FACT TF
       WHERE TF.TRFAV_ESTADO IN (PI_ESTADO);
  
    PO_CODERROR := 0;
    PO_MSGERR   := 'PROCESO EXITOSO';
  
  EXCEPTION
    WHEN V_ERROR THEN
      PO_CODERROR := V_CODERROR;
      PO_MSGERR   := 'ERROR:' || SQLCODE || ': ' || SQLERRM || V_MSGERR || ', SGASS_TRAZA_FACT';
    WHEN OTHERS THEN
      PO_CODERROR := -2;
      PO_MSGERR   := 'ERROR:' || SQLCODE || ': ' || SQLERRM || ', SGASS_TRAZA_FACT';
   
  END;

  /*
  '****************************************************************
  '* Nombre sp              :  SGASU_TRAZA_FACT
  '* Proposito              :  Actualizar la trazabilidad del registro de factibilidad.
  '* Input                  :  PI_IDTRAZA        - Id de trazabilidad a actualizar
                               PI_CODPROYECTO    - Codigo de proyecto o SEF
                               PI_CODSUCURSAL    - Codigo de Sucursarl
                               PI_ESTADO         - Estado a actualizar
                               PI_TRAMAINPUT     - Trama Input de la actividad
                               PI_TRAMAOUTPUT    - Trama Output de la actividad
                               PI_ACTIVIDAD      - Actividad donde sucedio el error
                               PI_DESCRIPCION    - Descripcion
                               PI_USUARIO        - Usuario que ejecuta
  '* Output                 :  PO_CODERROR       - Mensaje de Respuesta
  '*                           PO_MSGERR         - Codigo de Respuesta
  '* Creado por             :  Cesar Nicho
  '* Fec. Creacion          :  21/05/2019
  '* Fec. Actualizacion     :
  '****************************************************************
  */
  PROCEDURE SGASU_TRAZA_FACT(PI_IDTRAZA     IN NUMBER,
                             PI_CODPROYECTO IN VARCHAR2,
                             PI_CODSUCURSAL IN VARCHAR2,
                             PI_ESTADO      IN NUMBER,
                             PI_TRAMAINPUT  IN CLOB,
                             PI_TRAMAOUTPUT IN CLOB,
                             PI_ACTIVIDAD   IN VARCHAR2,
                             PI_DESCRIPCION IN VARCHAR2,
                             PI_USUARIO     IN VARCHAR,
                             PO_CODERROR    OUT NUMBER,
                             PO_MSGERR      OUT VARCHAR) IS
    V_ERROR EXCEPTION;
    V_CODERROR NUMBER;
    V_MSGERR   VARCHAR(200);
    V_FECHA    DATE;
  BEGIN
    IF PI_IDTRAZA IS NULL OR PI_CODPROYECTO IS NULL OR
       PI_CODSUCURSAL IS NULL OR PI_ESTADO IS NULL OR PI_USUARIO IS NULL THEN
      V_CODERROR := -1;
      V_MSGERR   := 'PARAMETROS OBLIGATORIOS';
      RAISE V_ERROR;
    END IF;
  
    V_FECHA := SYSDATE;
    UPDATE OPERACION.SGAT_TRAZA_FACT ST
       SET ST.TRFAV_ESTADO   = PI_ESTADO,
           ST.TRFAD_FECHCACT = V_FECHA,
           ST.TRFAV_USUACT   = PI_USUARIO
     WHERE ST.TRFAN_IDTRAZA = PI_IDTRAZA
       AND ST.TRFAV_CODPROYECTO = PI_CODPROYECTO
       AND ST.TRFAV_CODSUCURSAL = PI_CODSUCURSAL;
  
    INSERT INTO OPERACION.SGAT_TRAZA_DET_FACT
      (TRFAN_IDTRAZA,
       TDFAC_TRAMAINPUT,
       TDFAC_TRAMAOUTPUT,
       TDFAV_ESTADO,
       TDFAV_ACTIVIDAD,
       TDFAV_DESCRIPCION,
       TRFAD_FECACT,
       TRFAV_USUACT)
    VALUES
      (PI_IDTRAZA,
       PI_TRAMAINPUT,
       PI_TRAMAOUTPUT,
       PI_ESTADO,
       PI_ACTIVIDAD,
       PI_DESCRIPCION,
       V_FECHA,
       PI_USUARIO);
  
    PO_CODERROR := 0;
    PO_MSGERR   := 'PROCESO EXITOSO';
  
  EXCEPTION
    WHEN V_ERROR THEN
      PO_CODERROR := V_CODERROR;
      PO_MSGERR   := 'ERROR:' || SQLCODE || ': ' || SQLERRM || V_MSGERR ||
                     ', SGASU_TRAZA_FACT';
    WHEN OTHERS THEN
      PO_CODERROR := -2;
      PO_MSGERR   := 'ERROR:' || SQLCODE || ': ' || SQLERRM ||
                     ', SGASU_TRAZA_FACT';
  END;

  /*
  '****************************************************************
  '* Nombre sp              :  SGASI_TRAZA_FACT
  '* Proposito              :  Registra los datos necesarios para factibilizar
  '* Input                  :  PI_CODEF        - Codigo de EF
  '* Output                 :  Ninguno
  '*                           
  '* Creado por             :  Cesar Nicho
  '* Fec. Creacion          :  21/05/2019
  '* Fec. Actualizacion     :
  '****************************************************************
  */
  PROCEDURE SGASI_TRAZA_FACT(PI_CODEF OPERACION.EF.CODEF%TYPE) IS
	  
	  ln_codigo_respuesta  number; 
	  lv_mensaje_respuesta varchar2(4000);
	  ln_trfan_idtraza     number;
	  lcb_tramainput       clob;
	  lcb_tramaoutput      clob;
	  ln_codigoDireccion   NUMBER;
	  ln_codigoSubDireccion NUMBER;
	  li_estado            PLS_INTEGER;
	  lv_mensaje           varchar2(100);
	  lv_escenario         VARCHAR2(10) := 'DNG';

  CURSOR c_oportunidad IS
    SELECT DISTINCT 'PORTCORP'   nombapp,
                    ef.numslc    numslc,
                    vsuc.codsuc  codsuc,
                    vtat.ubigeo  ubigeo,
                    vsuc.numvia  numvia,
                    vsuc.tipviap tipviap,
                    vsuc.nomvia  nombrevia,
                    vsuc.manzana manzana,
                    vsuc.lote    lote,
                    0            estado
      FROM marketing.vtasuccli vsuc
     INNER JOIN marketing.vtatabdst vtat
        ON vsuc.ubisuc = vtat.codubi
     INNER JOIN operacion.ef ef
        ON vsuc.codcli = ef.codcli
     INNER JOIN operacion.efpto det
        ON ef.codef = det.codef
       AND vsuc.codsuc = det.codsuc
     WHERE ef.codef = PI_CODEF
       and SGAFUN_TIPO_PROY(ef.numslc) = 1;

  BEGIN
    FOR r_oportunidad IN c_oportunidad LOOP
      INSERT INTO operacion.sgat_traza_fact
        (trfav_nombapp,
         trfav_codproyecto,
         trfav_codsucursal,
         trfav_codubigeo,
         trfav_nrovia,
         trfav_codtipovia,
         trfav_nombrevia,
         trfav_mzna,
         trfav_lote,
         trfav_estado)
        VALUES
        (r_oportunidad.nombapp,
         r_oportunidad.numslc,
         r_oportunidad.codsuc,
         r_oportunidad.ubigeo,
         r_oportunidad.numvia,
         r_oportunidad.tipviap,
         r_oportunidad.nombrevia,
         r_oportunidad.manzana,
         r_oportunidad.lote,
         r_oportunidad.estado
        );

     SELECT operacion.sgaseq_traza_fact.currval INTO ln_trfan_idtraza FROM dual;
      
     INSERT INTO operacion.sgat_traza_det_fact
        (trfan_idtraza,
         tdfav_estado,
         tdfav_descripcion,    
         trfad_fechareg,
         trfav_usureg)
     VALUES
        (ln_trfan_idtraza,
         0,
         'Obtener valores de tabla',
         SYSDATE,
         USER);

		begin    
			select i.inmun_coddireccion, i.inmun_codsubdireccion
			  into ln_codigoDireccion, ln_codigoSubDireccion
			  from marketing.vtasuccli v
			 inner join marketing.inmueble i
				 on v.idinmueble = i.idinmueble
			 where v.codsuc = r_oportunidad.codsuc;
	   exception
			when no_data_found then
			 ln_codigoDireccion := NULL;
			 ln_codigoSubDireccion := NULL;
		end;

	  IF ln_codigoDireccion IS NOT NULL AND ln_codigoSubDireccion IS NOT NULL THEN	  
		  BEGIN
			  operacion.pkg_gestion_recursos.sgass_bss_gestionsefgis(r_oportunidad.numslc,
														r_oportunidad.codsuc,
														ln_trfan_idtraza,
														lcb_tramainput,
														lcb_tramaoutput,                                    
														ln_codigo_respuesta, 
														lv_mensaje_respuesta);

			 IF dbms_lob.instr(UPPER(lcb_tramaoutput), 'ERROR 404') >= 1 THEN
				 li_estado  := 99;
				 lv_mensaje := 'Error 404 - No se envio a Factibilizar al MDB';
          ELSE
				 IF ln_codigo_respuesta = 0 THEN
					 li_estado  := 1;
					 lv_mensaje := 'Enviado a Factibilizar por el MDB';
				 ELSE
					 li_estado  := 99;
					 lv_mensaje := 'Error al enviar a Factibilizar al MDB';
				 END IF;						  
		    END IF;
				 
		  EXCEPTION
			 WHEN OTHERS THEN
				 li_estado  := 99;
				 lv_mensaje := 'Error de exception al enviar a Factibilizar al MDB';
				 dbms_output.put_line(TO_CHAR(SQLCODE) || 'msg:' || SQLERRM);      
		  END;
	  ELSE
		 operacion.pkg_ef_costeo.SGASU_ACT_EF(r_oportunidad.numslc, r_oportunidad.codsuc, NULL, lv_escenario, NULL, NULL, NULL, NULL, NULL, NULL, NULL, ln_codigo_respuesta, lv_mensaje_respuesta);
		 
		 li_estado  := 99;
		 lv_mensaje := 'Error en SEF. Sucursal no esta Georeferenciada. ACTUALIZACION CORRECTA. ' || lv_escenario;		  
	  END IF;                                     

	  SGASU_TRAZA_FACT(ln_trfan_idtraza, r_oportunidad.numslc, r_oportunidad.codsuc, li_estado, lcb_tramainput, lcb_tramaoutput, 'Validar Parametros', lv_mensaje, USER, ln_codigo_respuesta, lv_mensaje_respuesta); 	  
    END LOOP;

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
--       DBMS_OUTPUT.PUT_LINE('6.-' || ln_codigo_respuesta || '-' || lv_mensaje_respuesta);
       dbms_output.put_line(TO_CHAR(SQLCODE) || 'msg:' || SQLERRM);      
    WHEN OTHERS THEN
--       DBMS_OUTPUT.PUT_LINE('7.-' || ln_codigo_respuesta || '-' || lv_mensaje_respuesta);
       dbms_output.put_line(TO_CHAR(SQLCODE) || 'msg:' || SQLERRM);      
  END;

  /****************************************************************
  * Nombre FUN : SGAFUN_TIPO_PROY
  * Propósito : Filtrar tipos de proyectos en base a configuracion de 
  *             Tipo de servicio , Producto y Tipo de trabajo
  * Output : 1 - existe conf.; 0 - no existe conf.; 99 - error BD
  * Creado por : GLOBAL HITS
  * Fec Creación : 17/09/2019
  * Fec Actualización : 17/09/2019
  *****************************************************************/
  FUNCTION SGAFUN_TIPO_PROY(PI_NUMSLC IN VARCHAR2) RETURN NUMBER IS
  
    cursor cur_01 is
      select C.CODIGOC, C.ABREVIACION
        from OPEDD c
       INNER JOIN TIPOPEDD t
          on c.tipopedd = t.tipopedd
       where t.abrev = 'TIPO_SEF_COSTEO'
         and c.abreviacion like 'TIPSRV_%'
       order by C.ABREVIACION;
  
    cursor cur_02(ai_abrev opedd.abreviacion%type) is
      select c.codigon
        from OPEDD c
       INNER JOIN TIPOPEDD t
          on c.tipopedd = t.tipopedd
       where t.abrev = 'TIPO_SEF_COSTEO'
         and c.abreviacion like 'PROD_' || ai_abrev || '%';
  
    cursor cur_03 is
      select c.codigon
        from OPEDD c
       INNER JOIN TIPOPEDD t
          on c.tipopedd = t.tipopedd
       where t.abrev = 'TIPO_SEF_COSTEO'
         and c.abreviacion like 'TIPTRA_%';
  
    V_SQL_STMT         VARCHAR(20500);
    ln_num_query       number := 0;
    lv_and_01          varchar(1000) := ' ';
    lv_and_02          varchar(1000) := ' ';
    lv_and_03          varchar(1000) := ' ';
    lv_and_04          varchar(1000) := ' ';
    lv_and_05          varchar(1000) := ' ';
    ln_pos_01          number(3) := 0;
    ln_pos_02          number(3) := 0;
    lv_tipsrv          varchar(30) := ' ';
    lv_condicion       varchar(5000) := ' ';
    lv_condicion_02    varchar(5000) := ' ';
    lv_condicion_final varchar(5000) := ' ';
    ld_existe_tipsrv   boolean := false;
    ld_existe_prod     boolean := false;
    ld_existe_tiptra   boolean := false;
  
  BEGIN
    V_SQL_STMT := V_SQL_STMT || ' select count(distinct sef.numslc) ';
    V_SQL_STMT := V_SQL_STMT || ' from vtatabslcfac sef ';
    V_SQL_STMT := V_SQL_STMT || ' inner join vtadetptoenl sefd ';
    V_SQL_STMT := V_SQL_STMT || ' on sef.numslc = sefd.numslc ';
    V_SQL_STMT := V_SQL_STMT || ' where sef.numslc = :a1 ';
  
    lv_condicion_final := ' ';
    lv_condicion       := ' ';
  
    /*************************************/
    /*01.CONDICIONES DE TIPO DE SERVICIO*/
    /*************************************/
    --Abrimos parentesis para las condiciones
    lv_and_01        := lv_and_01 || ' and (';
    ld_existe_tipsrv := false;
    for l_cur01 in cur_01 loop
      ld_existe_tipsrv := true;
      ---Capturamos pos de 1er underline
      ln_pos_01 := instr(l_cur01.abreviacion, '_');
      ---Capturamos pos de 2do underline
      ln_pos_02 := instr(l_cur01.abreviacion, '_', 1, 2);
      ---Capturamos descripcion del tipo de servicio 
      ---en base a posicion de 1er y 2do underline
      lv_tipsrv := substr(l_cur01.abreviacion,
                          (ln_pos_01 + 1),
                          (ln_pos_02 - 1) - ln_pos_01);
      ---Limpiamos los valores dentro del bucle                    
      lv_and_02 := ' ';
      ---Concatenamos los codigos de tipo de servicio
      lv_and_02 := lv_and_02 || '''' || l_cur01.codigoc || '''' || ',';
      ---Limpiamos los valores dentro del bucle   
      lv_and_03      := ' ';
      ld_existe_prod := false;
      for l_cur02 in cur_02(lv_tipsrv) loop
        ld_existe_prod := true;
        ---Concatenamos los codigos de producto si existen
        lv_and_03 := lv_and_03 || to_char(l_cur02.codigon) || ',';
      end loop;
      ---Borramos la ultima coma de la cadena
      lv_and_02 := rtrim(lv_and_02, ',');
      ---Borramos la ultima coma de la cadena
      lv_and_03 := rtrim(lv_and_03, ',');
    
      if ld_existe_prod then
        ---Existen productos configurados
        lv_condicion := '(sef.tipsrv in (' || lv_and_02 || ')' ||
                        'and sefd.idproducto in (' || lv_and_03 || ')' || ')' ||
                        ' or';
      else
        ---No existen productos configurados
        lv_condicion := '(sef.tipsrv in (' || lv_and_02 || ')' || ')' ||
                        ' or';
      end if;
      ---Concatenamos las condiciones para para tipo de servicio
      lv_condicion_final := lv_condicion_final || lv_condicion;
    end loop;
    ---Borramos el ultimo OR de la cadena
    lv_condicion_final := rtrim(lv_condicion_final, 'or');
    if ld_existe_tipsrv then
      ---Cerramos parentesis para las condiciones si existen servicios conf.
      lv_and_01 := lv_and_01 || ' ' || lv_condicion_final || ')';
    else
      ---Limpiamos la variable si no existen tipos de servicios conf.
      lv_and_01 := ' ';
    end if;
  
    /***********************************/
    /*02.CONDICIONES DE TIPO DE TRABAJO*/
    /***********************************/
    lv_and_04        := lv_and_04 || ' and (';
    ld_existe_tiptra := false;
    for l_cur03 in cur_03 loop
      ld_existe_tiptra := true;
      lv_and_05        := lv_and_05 || to_char(l_cur03.codigon) || ',';
    end loop;
    ---Borramos la ultima coma de la cadena
    lv_and_05 := rtrim(lv_and_05, ',');
    if ld_existe_tiptra then
      ---Concatemamos si existe tiptra si esta conf.
      lv_condicion_02 := 'sefd.tiptra in (' || lv_and_05 || ')';
    else
      ---Limpiamos variables si no existe conf. de tiptra
      lv_condicion_02 := ' ';
      lv_and_04       := ' ';
    end if;
    if ld_existe_tiptra then
      ---Cerramos parentesis para las condiciones si existe tiptra
      lv_and_04 := lv_and_04 || ' ' || lv_condicion_02 || ')';
    end if;
  
    --Query para ejecutar
    V_SQL_STMT := V_SQL_STMT || lv_and_01 || lv_and_04;
  
    --Test salida resultado
    --dbms_output.put_line(V_SQL_STMT);
  
    EXECUTE IMMEDIATE V_SQL_STMT
      INTO ln_num_query
      USING PI_NUMSLC;
  
    RETURN ln_num_query;
  
  EXCEPTION
    WHEN OTHERS THEN
      ln_num_query := 99;
      RETURN ln_num_query;
  END;

  FUNCTION SGAFUN_OBTENER_UBIGEO(PV_CODUBI CHAR,PN_CODVAL NUMBER) RETURN CHAR 
  IS
   LV_CODVAL CHAR(6);
   LC_CODUBI CHAR(6);
  BEGIN
      SELECT DST.UBIGEO INTO LC_CODUBI FROM MARKETING.VTATABDST DST WHERE DST.CODUBI=PV_CODUBI;
      IF LC_CODUBI IS NOT NULL THEN
        IF PN_CODVAL=1 THEN
            LV_CODVAL:=SUBSTR(LC_CODUBI,1,2);
        END IF;
        IF PN_CODVAL=2 THEN
            LV_CODVAL:=SUBSTR(LC_CODUBI,1,4);
        END IF;
        IF PN_CODVAL=3 THEN
            LV_CODVAL:=LC_CODUBI;
        END IF;      
      ELSE
          LV_CODVAL:=NULL;
      END IF;
      RETURN (LV_CODVAL);
  END;

END PKG_FACTIBILIDAD;
/