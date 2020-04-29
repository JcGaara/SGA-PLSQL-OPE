CREATE OR REPLACE PACKAGE BODY OPERACION.pq_revision_bouquets_dth IS
  /***********************************************************************
  REVISIONES:
   Versión     Fecha         Autor              Solicitado por             Descripcion
  ---------  -----------   ----------------     -----------------    ----------------------------------
     1.0      01/09/2014   Emma Guzman A.     Susana Ramos          PROY-6124-IDEA-5627 - Revisión Bouquets DTH
     2.0      07/07/2015   Emma Guzman A.     Susana Ramos          SD-380045
     3.0      22/07/2015   Emma Guzman A.     Susana Ramos
  ************************************************************************/
FUNCTION f_habilita_carga_masiva RETURN NUMBER IS
    -- Declaracion de variables locales
    a_rpta number;
    l_maestro number;
  BEGIN
      a_rpta := 0;
      select count(*) into l_maestro from ituser where usuario = USER;
      if l_maestro = 0 then
            select count(*) into l_maestro  from SEGUSUOPC ou join SEGTABOPC o on OU.CODOPC = O.CODOPC
            where OU.CODUSU =  USER AND O.CODMOD  IN (select rpad(CODIGOC,15,' ') from opedd c WHERE TIPOPEDD IN (SELECT tipopedd FROM tipopedd WHERE abrev = 'PERCARMASTARJ'));
            if l_maestro = 0 then
                select count(*) into l_maestro from segtabper g join segperopc a on g.codper = a.codper
                join segusuper c on a.codper = c.codper join segtabopc o on a.codopc = o.codopc
                join usuarioope u on c.codusu = u.usuario where u.usuario =  USER  AND
                O.CODMOD  IN (select rpad(CODIGOC,15,' ') from opedd c WHERE TIPOPEDD IN (SELECT tipopedd FROM tipopedd WHERE abrev = 'PERCARMASTARJ'));
                if l_maestro = 0 then
                   a_rpta := 1;
                end if ;
            end if ;
      end if ;
      RETURN a_rpta;
  END;


  FUNCTION f_obtiene_cant_tarjeta RETURN NUMBER IS
    l_return NUMBER;
  BEGIN
    SELECT codigon
      INTO l_return
      FROM opedd
     WHERE tipopedd = (SELECT tipopedd
                         FROM tipopedd
                        WHERE abrev = 'BOUQUET_DTH_PARAMETROS')
       AND codigoc = 'CANT_TARJETAS';

    l_return := nvl(l_return, 6);
    RETURN l_return;
  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$PLSQL_UNIT || '.F_OBTIENE_CANT_TARJETA: ' ||
                              SQLERRM);
  END;
  /* **********************************************************************************************/


FUNCTION f_obtiene_cantmin_tarjeta RETURN NUMBER IS
    l_return NUMBER;
  BEGIN
    SELECT codigon
      INTO l_return
      FROM opedd
     WHERE tipopedd = (SELECT tipopedd
                         FROM tipopedd
                        WHERE abrev = 'BOUQUET_DTH_PARAMETROS')
       AND codigoc = 'CANTMIN_TARJ';

    l_return := nvl(l_return, 6);
    RETURN l_return;
  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$PLSQL_UNIT || '.F_OBTIENE_CANTMIN_TARJETA: ' ||
                              SQLERRM);
  END;
  /* **********************************************************************************************/
  PROCEDURE p_obtener_bouquet(a_tarjeta       IN VARCHAR2,
                              a_paquete       OUT VARCHAR2,
                              a_bouquet       OUT VARCHAR2,
                              a_bouquet_conax OUT VARCHAR2,
                              a_estado        OUT VARCHAR2,
                              a_fecha_reg     OUT DATE,
                              a_fecha_mod     OUT DATE) IS
    -- Declaracion de variables locales
    l_count number;
  BEGIN
  select count(* ) into l_count from ( SELECT pv.desc_operativa a_paquete,
                   REPLACE(t.codigo_ext, ',', ', ') a_bouquet,
                   det.cod_bouquet a_bouquet_conax,
                   es.descripcion a_estado,
                   det.fecreg a_fecha_reg,
                   det.fecmod a_fecha_mod
               FROM ope_srv_recarga_cab cab
      JOIN paquete_venta pv
        ON cab.idpaq = pv.idpaq
      JOIN solotptoequ s
        ON cab.codsolot = s.codsolot
      JOIN inssrv i
        ON cab.numslc = i.numslc
      JOIN tystabsrv t
        ON i.codsrv = t.codsrv
      JOIN vtatabcli cl
        ON cab.codcli = cl.codcli
      LEFT JOIN atccorp.atc_file_bouquet_dth_det det
        ON s.numserie = det.cod_tarjeta
      LEFT JOIN atccorp.atc_file_bouquet_dth_cab cab
        ON cab.id_file_bouquet_cab = det.id_file_bouquet_cab
      LEFT JOIN opedd es
        ON es.codigon = cab.estado_cab
       AND es.tipopedd IN
           (SELECT tipopedd FROM tipopedd WHERE abrev = 'BOUQUET_DTH_ESTADO')
     WHERE cab.estado <> '04'
       AND s.numserie = a_tarjeta
       AND rownum = 1 ) lista;

       if l_count > 0 then
            SELECT pv.desc_operativa,
                   REPLACE(t.codigo_ext, ',', ', '),
                   det.cod_bouquet,
                   es.descripcion,
                   det.fecreg,
                   det.fecmod
              INTO a_paquete,
                   a_bouquet,
                   a_bouquet_conax,
                   a_estado,
                   a_fecha_reg,
                   a_fecha_mod
              FROM ope_srv_recarga_cab cab
              JOIN paquete_venta pv
                ON cab.idpaq = pv.idpaq
              JOIN solotptoequ s
                ON cab.codsolot = s.codsolot
              JOIN inssrv i
                ON cab.numslc = i.numslc
              JOIN tystabsrv t
                ON i.codsrv = t.codsrv
              JOIN vtatabcli cl
                ON cab.codcli = cl.codcli
              LEFT JOIN atccorp.atc_file_bouquet_dth_det det
                ON s.numserie = det.cod_tarjeta
              LEFT JOIN atccorp.atc_file_bouquet_dth_cab cab
                ON cab.id_file_bouquet_cab = det.id_file_bouquet_cab
              LEFT JOIN opedd es
                ON es.codigon = cab.estado_cab
               AND es.tipopedd IN
                   (SELECT tipopedd FROM tipopedd WHERE abrev = 'BOUQUET_DTH_ESTADO')
             WHERE cab.estado <> '04'
               AND s.numserie = a_tarjeta
               AND rownum = 1;
       else
             a_paquete := null;
                   a_bouquet:= null;
                   a_bouquet_conax := null;
                   a_estado:= null;
                   a_fecha_reg:= null;
                   a_fecha_mod:= null ;
       end if ;

  END;

  PROCEDURE p_obtener_id(a_tipo IN CHAR, aln_rpta OUT NUMBER) IS
    -- Declaracion de variables locales
  BEGIN
    aln_rpta := 0;
    IF a_tipo = 'C' THEN
      SELECT atccorp.sq_atc_consulta_bouquet.currval
        INTO aln_rpta
        FROM dual;
    END IF;
    IF a_tipo = 'B' THEN
      SELECT atccorp.sq_atc_file_bouquet_dth_cab.currval
        INTO aln_rpta
        FROM dual;
    END IF;

  END;

  PROCEDURE p_verifica_tarjeta(ac_serie IN CHAR,
                               aln_rpta OUT NUMBER,
                               als_rpta OUT VARCHAR2) IS
    v_cant_serie NUMBER;
    -- Declaracion de variables locales
  BEGIN
    aln_rpta := 0;
    als_rpta := 'Exito';

    SELECT COUNT(d.cod_tarjeta)
      INTO v_cant_serie
         FROM atccorp.atc_file_bouquet_dth_det d
      join atccorp.atc_file_bouquet_dth_cab c on D.ID_FILE_BOUQUET_CAB = C.ID_FILE_BOUQUET_CAB
      join atccorp.ATC_CONSULTA_BOUQUET co on C.ID_CONS_BOUQUET = CO.ID_CONS_BOUQUET
     WHERE CO.ESTADO <> 7 and d.cod_tarjeta = ac_serie;

    IF v_cant_serie > 0 THEN
      aln_rpta := 1;
      als_rpta := 'La Tarjeta '||ac_serie||' tiene una Consulta Pendiente. Debe desmarcarla para continuar';
    END IF;

  END;

  FUNCTION f_obtiene_mensaje(p_mensaje opedd.codigoc%TYPE) RETURN VARCHAR IS
    ls_mensaje opedd.descripcion%TYPE;
  BEGIN
    SELECT descripcion
      INTO ls_mensaje
      FROM opedd
     WHERE tipopedd =
           (SELECT tipopedd FROM tipopedd WHERE abrev = 'BOUQUET_DTH_MSG')
       AND codigoc = p_mensaje;
    RETURN ls_mensaje;
  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$PLSQL_UNIT || '.F_OBTIENE_MENSAJE(' ||
                              p_mensaje || '): ' || SQLERRM);
  END;

  FUNCTION f_obtiene_parametro_ftp(p_parametro opedd.codigoc%TYPE)
    RETURN VARCHAR IS
    l_des_parametro opedd.descripcion%TYPE;
  BEGIN
    SELECT descripcion
      INTO l_des_parametro
      FROM opedd
     WHERE tipopedd =
           (SELECT tipopedd FROM tipopedd WHERE abrev = 'BOUQUET_DTH_FTP')
       AND codigoc = p_parametro;
    RETURN l_des_parametro;

  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$PLSQL_UNIT || '.F_OBTIENE_PARAMETRO_FTP(' ||
                              p_parametro || '): ' || SQLERRM);
  END;

  PROCEDURE p_set_configuracion IS

  BEGIN
--    g_host                    := f_obtiene_parametro_ftp('HOST');
--    g_puerto                  := f_obtiene_parametro_ftp('PUERTO');
--    g_usuario                 := f_obtiene_parametro_ftp('USUARIO');
--    g_pass                    := f_obtiene_parametro_ftp('PASWORD');
--    g_directorio_local        := f_obtiene_parametro_ftp('RUTA_LOCAL');
--    g_directorio_remoto_envio := f_obtiene_parametro_ftp('RUTA_ENVIO');
--    g_directorio_remoto_ok    := f_obtiene_parametro_ftp('RUTA_OK');
--    g_directorio_remoto_error := f_obtiene_parametro_ftp('RUTA_ERROR');

    g_host                    := operacion.pq_dth.f_obt_parametro_d('PARAM_DTH','HOST');
    g_puerto                  := operacion.pq_dth.f_obt_parametro_d('PARAM_DTH','PUERTO');
    g_usuario                 := operacion.pq_dth.f_obt_parametro_d('PARAM_DTH','USUARIO');
    g_pass                    := operacion.pq_dth.f_obt_parametro_d('PARAM_DTH','CLAVE');
    g_directorio_local        := operacion.pq_dth.f_obt_parametro_d('PARAM_DTH','DirectorioLocal');
    g_directorio_remoto_envio := operacion.pq_dth.f_obt_parametro_d('PARAM_DTH','Dir.remoto.Req');
    g_directorio_remoto_ok    := operacion.pq_dth.f_obt_parametro_d('PARAM_DTH','Dir.remoto.Ok');
    g_directorio_remoto_error := operacion.pq_dth.f_obt_parametro_d('PARAM_DTH','Dir.remoto.Error');
    g_rut_kh                  := operacion.pq_dth.f_obt_parametro_d('PARAM_DTH','RUT_KH');
    g_rut_idrsa               := operacion.pq_dth.f_obt_parametro_d('PARAM_DTH','IDRSA');
    g_cant_tarj := f_obtiene_cant_tarjeta();
  END;

  FUNCTION f_obtiene_maximo_envios RETURN NUMBER IS
    l_return NUMBER;
  BEGIN
    SELECT codigon
      INTO l_return
      FROM opedd
     WHERE tipopedd = (SELECT tipopedd
                         FROM tipopedd
                        WHERE abrev = 'BOUQUET_DTH_PARAMETROS')
       AND codigoc = 'MAXIMO_ENVIOS';

    l_return := nvl(l_return, 6);
    RETURN l_return;
  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$PLSQL_UNIT || '.F_OBTIENE_MAXIMO_ENVIOS: ' ||
                              SQLERRM);
  END;

  FUNCTION f_valida_tarjeta(p_cod_tarjeta atccorp.atc_file_bouquet_dth_det.cod_tarjeta%TYPE)
    RETURN NUMBER IS

    l_valor  INTEGER;
    l_return NUMBER;
  BEGIN
    --- SE VALIDA TARJETA
    l_return := 0;

    Select count(1) INTO l_valor
      from dual
      where exists (select 1
                  from OPERACION.TABEQUIPO_MATERIAL TEM
                 where TEM.TIPO = 1 AND TEM.NUMERO_SERIE =  p_cod_tarjeta );


    IF l_valor = 0 THEN
      l_return := -1;
    ELSIF length(p_cod_tarjeta) <> 11 THEN
      l_return := 1;
    ELSIF substr(p_cod_tarjeta, 1, 2) <> '01' THEN
      l_return := 2;
    ELSIF instr(p_cod_tarjeta, ' ', 1) <> 0 THEN
      l_return := 3;
    END IF;
    RETURN l_return;
  END;

  FUNCTION f_genera_codigo_trx RETURN NUMBER IS
    l_rango_inicio  NUMBER;
    l_rango_fin     NUMBER;
    l_nuevo_cod_trx NUMBER;
  BEGIN

    SELECT to_number(substr(TRIM(descripcion),
                            1,
                            instr(TRIM(descripcion), '-') - 1)) AS rang1,
           to_number(substr(TRIM(descripcion),
                            instr(TRIM(descripcion), '-') + 1,
                            length(TRIM(descripcion)) -
                            instr(TRIM(descripcion), '-'))) AS rang2
      INTO l_rango_inicio, l_rango_fin
      FROM opedd
     WHERE tipopedd = (SELECT tipopedd
                         FROM tipopedd
                        WHERE abrev = 'BOUQUET_DTH_PARAMETROS')
       AND codigoc = 'RANGO_CICLICO';

    SELECT CASE
             WHEN nvl(MAX(cod_transaccion_cab), l_rango_inicio) =
                  l_rango_fin THEN
              l_rango_inicio
             ELSE
              nvl(MAX(cod_transaccion_cab), l_rango_inicio - 1) + 1
           END
      INTO l_nuevo_cod_trx
      FROM atccorp.atc_file_bouquet_dth_cab;

    RETURN l_nuevo_cod_trx;
  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$PLSQL_UNIT || '.P_GENERA_CODIGO_TRX: ' ||
                              SQLERRM);

  END;

procedure p_verificar_archivo_ftp(pHost          in varchar2,
                              pPuerto        in varchar2,
                              pUsuario       in varchar2,
                              pPass          in varchar2,
                              pDirecarch     in varchar2,
                              p_resultado_ftp   OUT number) IS
 pvrf     operacion.ftp.t_string_table;
l_conn   UTL_TCP.connection;
respuesta varchar2(50);
begin
    if pPuerto = '21' then
      l_conn := operacion.ftp.login(pHost, pPuerto, pUsuario, pPass);
      operacion.ftp.ascii(p_conn => l_conn);
      operacion.ftp.nlst(p_conn => l_conn,
                         p_dir  => pDirecarch,
                         p_list => pvrf);
      operacion.ftp.logout(l_conn);
      utl_tcp.close_all_connections;
       if pvrf.count>0 then
         p_resultado_ftp := 1;
       else
         p_resultado_ftp:= 0;
       end if ;
    elsif pPuerto=22 then
        respuesta:=operacion.sftp.verifArchivo(pUsuario,pPass,pHost,pPuerto,g_rut_kh,pDirecarch);
        if respuesta = 'Ok' then
         p_resultado_ftp := 1;
       else
         p_resultado_ftp:= 0;
       end if ;
    end if;
end;

  PROCEDURE p_eliminar_archivo_ftp(p_archivoremoto VARCHAR,
                                   p_resultado_ftp IN OUT VARCHAR,
                                   p_mensaje_ftp   IN OUT VARCHAR) IS

l_conn UTL_TCP.connection;
  BEGIN
    p_set_configuracion;

     if g_puerto=21 then
      l_conn := ftp.login(g_host, g_puerto, g_usuario, g_pass);
      ftp.ascii(p_conn => l_conn);
      ftp.delete(p_conn => l_conn, p_file => p_archivoremoto);
      ftp.logout(l_conn);
      utl_tcp.close_all_connections;
      p_resultado_ftp := 'OK';
    elsif g_puerto=22 then
      p_resultado_ftp:=operacion.sftp.eliminArchivo(g_usuario,g_pass,g_host,g_puerto,g_rut_kh,p_archivoremoto);
    end if;


  EXCEPTION
    WHEN OTHERS THEN
      p_resultado_ftp := 'ERROR';
      p_mensaje_ftp   := 'Error al eliminar archivo. ' || SQLCODE || ' ' ||
                         SQLERRM;
  END;


  FUNCTION f_get_estado(p_estado operacion.opedd.descripcion%TYPE)
    RETURN operacion.opedd.codigon%TYPE IS

    l_codest operacion.opedd.codigon%TYPE;

  BEGIN
    SELECT aep.codigon
      INTO l_codest
      FROM opedd aep
     WHERE aep.descripcion = upper(p_estado)
       AND aep.tipopedd =
           (SELECT tipopedd FROM tipopedd WHERE abrev = 'BOUQUET_DTH_ESTADO');

    RETURN l_codest;

  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$PLSQL_UNIT || '.F_GET_ESTADO: ' || SQLERRM);
  END;

  PROCEDURE p_guardar_file_dth(pr_atc_file_bouquet_dth atccorp.atc_file_bouquet_dth_cab%ROWTYPE) IS
    PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    UPDATE atccorp.atc_file_bouquet_dth_cab
       SET cod_transaccion_cab = pr_atc_file_bouquet_dth.cod_transaccion_cab,
           filename_cab        = pr_atc_file_bouquet_dth.filename_cab,
           estado_cab        = 2,
           reintento_cab       = pr_atc_file_bouquet_dth.reintento_cab,
           usuenv              = pr_atc_file_bouquet_dth.usuenv,
           fecenv              = pr_atc_file_bouquet_dth.fecenv
     WHERE id_file_bouquet_cab =
           pr_atc_file_bouquet_dth.id_file_bouquet_cab;
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$PLSQL_UNIT || '.P_GUARDAR_FILE_DTH: ' ||
                              SQLERRM);
  END;

procedure p_enviar_archivo_ascii(pHost          in varchar2,
                                 pPuerto        in varchar2,
                                 pUsuario       in varchar2,
                                 pPass          in varchar2,
                                 pDirectorio    in varchar2,
                                 pArchivoLocal  in varchar2,
                                 pArchivoRemoto in varchar2,
                                 respuesta      out varchar2) is
l_conn       UTL_TCP.connection;
archivolocal varchar2(500);
begin
   p_set_configuracion;
  if pPuerto = '21' then
    l_conn := ftp.login(pHost, pPuerto, pUsuario, pPass);
    ftp.ascii(p_conn => l_conn);
    ftp.put(p_conn      => l_conn,
            p_from_dir  => pDirectorio,
            p_from_file => pArchivoLocal,
            p_to_file   => pArchivoRemoto);
    ftp.logout(l_conn);
    utl_tcp.close_all_connections;
  elsif pPuerto = '22' then
    archivolocal := pDirectorio || '/' || pArchivoLocal;
    respuesta    := operacion.sftp.enviarArchivo(pUsuario,
                                                 pPass,
                                                 pHost,
                                                 pPuerto,
                                                 g_rut_kh,
                                                 archivolocal,
                                                 pArchivoRemoto);
  end if;
exception when others then raise_application_error(-20080, sqlerrm);
end ;

procedure p_ren_archivo_ascii(pHost          in varchar2,
                              pPuerto        in varchar2,
                              pUsuario       in varchar2,
                              pPass          in varchar2,
                              pArchivoLocal  in varchar2,
                              pArchivoRemoto in varchar2,
                              respuesta      out varchar2)
is
l_conn   UTL_TCP.connection;
begin
   p_set_configuracion;
      if pPuerto=21 then
         l_conn := operacion.ftp.login(pHost, pPuerto, pUsuario, pPass);
         operacion.ftp.ascii(p_conn => l_conn);
         operacion.ftp.rename(p_conn  => l_conn,
                              p_from  => pArchivoLocal,
                              p_to    => pArchivoRemoto);
         operacion.ftp.logout(l_conn);
         utl_tcp.close_all_connections;
         respuesta:='Ok';
      elsif pPuerto=22 then
        respuesta:=operacion.sftp.renomArchivo(pUsuario,pPass,pHost,pPuerto,g_rut_kh,pArchivoLocal,pArchivoRemoto);
      end if;
exception when others then raise_application_error(-20080, sqlerrm);
end ;

  PROCEDURE p_enviar_conax(p_id_correlativo atccorp.atc_file_bouquet_dth_cab.id_file_bouquet_cab%TYPE,
                           p_resultado      IN OUT NUMBER,
                           p_mensaje        IN OUT VARCHAR2) IS
    lr_atc_file_bouquet_dth atccorp.atc_file_bouquet_dth_cab%ROWTYPE;
    l_file_bouquet          utl_file.file_type;
    l_resultado             NUMBER;
    l_mensaje               VARCHAR(1000);
    l_resultado_ftp         VARCHAR(8);
    l_mensaje_ftp           VARCHAR(1000);
    l_archivo_remoto        VARCHAR(1000);
    ln_cont                 NUMBER;
    ls_cant                 VARCHAR(6);
    ll_rpta_val             NUMBER;
    l_cod_tarjeta           varchar2(50);
    respuestenv varchar2(1000);
    respustaren varchar2(1000);
    l_resp number;
    CURSOR c_tarjetas IS
      SELECT *
        FROM atccorp.atc_file_bouquet_dth_det
       WHERE id_file_bouquet_cab = p_id_correlativo
       ORDER BY cod_tarjeta;

  BEGIN
    l_resultado := 0;
    l_mensaje   := f_obtiene_mensaje('ENVIO_FTP_OK');
    p_set_configuracion;

    SELECT *
      INTO lr_atc_file_bouquet_dth
      FROM atccorp.atc_file_bouquet_dth_cab
     WHERE id_file_bouquet_cab = p_id_correlativo;

    IF lr_atc_file_bouquet_dth.reintento_cab >= f_obtiene_maximo_envios() THEN
      l_resultado := -1;
      l_mensaje   := f_obtiene_mensaje('SUPERO_ENVIOS');
      GOTO salto;
    END IF;
    --
    IF lr_atc_file_bouquet_dth.cod_transaccion_cab IS NULL THEN
      lr_atc_file_bouquet_dth.cod_transaccion_cab := f_genera_codigo_trx();
    END IF;

    lr_atc_file_bouquet_dth.filename_cab := 'sc' || lr_atc_file_bouquet_dth.cod_transaccion_cab || '.tmp';
    --verificar archivo en directorio ok
    l_archivo_remoto := REPLACE(g_directorio_remoto_ok || '/' || replace(lr_atc_file_bouquet_dth.filename_cab,'.emm','.tmp'), '//', '/');

   p_verificar_archivo_ftp(g_host, g_puerto, g_usuario, g_pass,l_archivo_remoto, l_resp);
    IF l_resp > 0 THEN
      p_eliminar_archivo_ftp(l_archivo_remoto, l_resultado_ftp, l_mensaje_ftp);
    END IF;

     l_archivo_remoto := REPLACE(g_directorio_remoto_error || '/' ||  replace(lr_atc_file_bouquet_dth.filename_cab,'.emm','.tmp'), '//',  '/');
     p_verificar_archivo_ftp(g_host, g_puerto, g_usuario, g_pass,l_archivo_remoto, l_resp);
    IF l_resp > 0 THEN
      p_eliminar_archivo_ftp(l_archivo_remoto, l_resultado_ftp, l_mensaje_ftp);
    END IF;

    -- CONTAR CUANTAS TARJETAS
    ln_cont := 0;
    FOR c_tar IN c_tarjetas LOOP
      select ltrim(rtrim(c_tar.cod_tarjeta)) into l_cod_tarjeta from dual;
      ll_rpta_val := f_valida_tarjeta(l_cod_tarjeta);
      IF ll_rpta_val = 0 THEN
        ln_cont   := ln_cont + 1;
        l_mensaje := '';
      ELSIF ll_rpta_val = -1 THEN
        l_mensaje := f_obtiene_mensaje('NO_EXISTE_TARJETA');
      ELSIF ll_rpta_val = 1 THEN
        l_mensaje := f_obtiene_mensaje('FMT_NRO_CARAC');
      ELSIF ll_rpta_val = 2 THEN
        l_mensaje := f_obtiene_mensaje('FMT_TARJ_01');
      ELSIF ll_rpta_val = 3 THEN
        l_mensaje := f_obtiene_mensaje('FMT_ESP_VACIO');
      END IF;

      IF ll_rpta_val <> 0 THEN
        --l_mensaje <> '' then
        UPDATE atccorp.atc_file_bouquet_dth_det d SET d.observacion = l_mensaje  WHERE d.id_file_bouquet_cab = c_tar.id_file_bouquet_cab  AND d.id_file_bouquet_det = c_tar.id_file_bouquet_det;
      END IF;
    END LOOP;
    commit;
    SELECT lpad((to_char(ln_cont)), 6, '0') INTO ls_cant FROM dual;

   if ln_cont > 0 then

            --crear archivo
            operacion.pq_dth_interfaz.p_abrir_archivo(l_file_bouquet, g_directorio_local,  lr_atc_file_bouquet_dth.filename_cab, 'W',  l_resultado_ftp,  l_mensaje_ftp);
            IF l_resultado_ftp <> 'OK' THEN
              l_resultado := -1;
              l_mensaje   := l_mensaje_ftp;
              GOTO salto;
            END IF;

       --escribir linea
        operacion.pq_dth_interfaz.p_escribe_linea(l_file_bouquet, 'U', '1');
        operacion.pq_dth_interfaz.p_escribe_linea(l_file_bouquet,  lr_atc_file_bouquet_dth.cod_transaccion_cab,  '1');
        operacion.pq_dth_interfaz.p_escribe_linea(l_file_bouquet, 'U', '1');
        operacion.pq_dth_interfaz.p_escribe_linea(l_file_bouquet, 'U', '1');
        operacion.pq_dth_interfaz.p_escribe_linea(l_file_bouquet, 'U', '1');
        operacion.pq_dth_interfaz.p_escribe_linea(l_file_bouquet, 'U', '1');
        operacion.pq_dth_interfaz.p_escribe_linea(l_file_bouquet, 'EMM', '1');
        operacion.pq_dth_interfaz.p_escribe_linea(l_file_bouquet, 'U', '1');

        operacion.pq_dth_interfaz.p_escribe_linea(l_file_bouquet, ls_cant, '1');

        -- SACAR TODAS LAS TARJETAS

        FOR c_tar IN c_tarjetas LOOP
          IF c_tar.observacion IS NULL THEN
            operacion.pq_dth_interfaz.p_escribe_linea(l_file_bouquet, c_tar.cod_tarjeta, '1');
          END IF;
        END LOOP;

        operacion.pq_dth_interfaz.p_escribe_linea(l_file_bouquet, 'ZZZ', '1');
        --cerrar archivo
        operacion.pq_dth_interfaz.p_cerrar_archivo(l_file_bouquet);


        --enviar archivo
        BEGIN
          l_archivo_remoto := REPLACE(g_directorio_remoto_envio || '/' ||  lr_atc_file_bouquet_dth.filename_cab,  '//',  '/');
          p_enviar_archivo_ascii(g_host,
                                 g_puerto,
                                 g_usuario,
                                 g_pass,
                                 g_directorio_local,
                                 lr_atc_file_bouquet_dth.filename_cab,
                                 l_archivo_remoto ,
                                 respuestenv);
            -- renombrar
         p_ren_archivo_ascii(g_host,
                                                        g_puerto,
                                                        g_usuario,
                                                        g_pass,
                                                        l_archivo_remoto,
                                                        replace(l_archivo_remoto,'.tmp','.emm'),
                                                        respustaren);

          lr_atc_file_bouquet_dth.usuenv     := USER;
          lr_atc_file_bouquet_dth.fecenv     := SYSDATE;
          lr_atc_file_bouquet_dth.filename_cab := replace(lr_atc_file_bouquet_dth.filename_cab,'.tmp','.emm');
          lr_atc_file_bouquet_dth.estado_cab := f_get_estado('ENVIADO');
        EXCEPTION
          WHEN OTHERS THEN
            lr_atc_file_bouquet_dth.estado_cab := f_get_estado('ERROR');
            l_resultado                        := -1;
            l_mensaje                          := f_obtiene_mensaje('ENVIO_FTP_ERROR');
        END;

        lr_atc_file_bouquet_dth.reintento_cab := nvl(lr_atc_file_bouquet_dth.reintento_cab,
                                                     0) + 1;

        p_guardar_file_dth(lr_atc_file_bouquet_dth);
    end if ;
    <<salto>>
    p_resultado := l_resultado;
    p_mensaje   := l_mensaje;

  EXCEPTION
    WHEN OTHERS THEN
      p_resultado := -1;
      p_mensaje   := f_obtiene_mensaje('ENVIO_FTP_ERROR');
      p_mensaje   := p_mensaje || ':Error BD: ' || SQLCODE || ' ' ||
                     SQLERRM;
  END;

  PROCEDURE p_crear_ftp_masiva(id_proceso  IN NUMBER,
                                  p_resultado IN OUT NUMBER,
                                  p_mensaje   IN OUT VARCHAR2) IS
    total             NUMBER;
    p_text_io         utl_file.file_type;
    l_nom_arch        VARCHAR2(30);
    l_result number;
    l_resultado        VARCHAR2(100);
    l_mensaje         VARCHAR2(1000);

    CURSOR c_tarjeta IS
      SELECT cod_tarjeta FROM atccorp.atc_tarjetas_aux d
                       WHERE d.id_cons_bouquet = id_proceso
                       ORDER BY d.cod_tarjeta ASC;

  BEGIN
    l_resultado := 0;
    l_mensaje   := f_obtiene_mensaje('CREA_FTP_OK');
    p_set_configuracion;

    SELECT COUNT(cod_tarjeta)
      INTO total
      FROM atccorp.atc_tarjetas_aux d
     WHERE d.id_cons_bouquet = id_proceso;

     if total < 1 then
          l_result := -1;
          l_mensaje   := 'No hay Datos de tarjetas para la consulta generada :' || to_char(id_proceso) ;
         GOTO salto;
     end if;
      --Declarando nombre
      l_nom_arch := 'sc' || to_char(id_proceso) || '.tmp';

      --Abrir el Archivo
      operacion.pq_dth_interfaz.p_abrir_archivo(p_text_io,
                                                g_directorio_local,
                                                l_nom_arch,
                                                'W',
                                                l_resultado,
                                                l_mensaje);

      --Escribir en Archivo
      FOR c2 IN c_tarjeta LOOP
            operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,   c2.cod_tarjeta,  '1');
      END LOOP;

      --Cerrar el archivo
      operacion.pq_dth_interfaz.p_cerrar_archivo(p_text_io);


        BEGIN
            update  atccorp.ATC_CONSULTA_BOUQUET set  ARCHIVO = l_nom_arch WHERE id_cons_bouquet = id_proceso;
      EXCEPTION
        WHEN OTHERS THEN
              l_result := -1;
              l_mensaje   := 'Error Actualizando Archivo en Consulta en BD: ' || SQLCODE || ' ' ||
                     SQLERRM;
                     GOTO salto;
      END;

--     BORRAMOS TARJETAS DE LA TABLA TEMPORAL
      BEGIN
            delete atccorp.atc_tarjetas_aux d  WHERE d.id_cons_bouquet = id_proceso;
      EXCEPTION
        WHEN OTHERS THEN
              l_result := -1;
              l_mensaje   := 'Error Eliminando datos de tarjetas TMP en BD: ' || SQLCODE || ' ' ||
                     SQLERRM;
                     GOTO salto;
      END;
    <<salto>>
    l_mensaje := replace (l_mensaje , 'archivo ', 'archivo '|| l_nom_arch|| ' ');

    p_resultado := l_result;
    p_mensaje   := l_mensaje;

  EXCEPTION
   WHEN OTHERS THEN
      p_resultado := -1;
      p_mensaje   := f_obtiene_mensaje('ENVIO_FTP_ERROR');
      p_mensaje   := p_mensaje || ':Error BD: ' || SQLCODE || ' ' ||
                     SQLERRM;
  END;


 PROCEDURE p_enviar_conax_masiva IS
    i                 NUMBER;
    p_text_io         utl_file.file_type;
    l_nom_arch        VARCHAR2(30);
    vuelta            NUMBER;
    l_total_tarj_arch NUMBER;
    residuo           NUMBER;
    l_cant_tarj       NUMBER;
    l_total_tarj      NUMBER;
    ln_cab number;
    ls_tarjeta varchar2(50);
   p_resultado  NUMBER;
    p_mensaje    VARCHAR2(1000);
    l_observacion varchar2(100);
    CURSOR c_tarjeta(x_proc number, x NUMBER, cant NUMBER) IS
      SELECT cod_tarjeta
        FROM (SELECT cod_tarjeta, rownum rnum
                FROM (SELECT (d.cod_tarjeta) cod_tarjeta
                        FROM atccorp.atc_tarjetas_aux d
                       WHERE d.id_cons_bouquet = x_proc
                       ORDER BY d.cod_tarjeta ASC) a
               WHERE rownum <= (x * cant) + cant)
       WHERE rnum > (x * cant);

CURSOR c_cons is select id_cons_bouquet from atccorp.atc_consulta_bouquet where ESTADO = 3 and TIPO_CONSULTA = 'CARGA MASIVA' order by id_cons_bouquet asc ;

  BEGIN
    p_set_configuracion;

    l_cant_tarj := g_cant_tarj;
    FOR c1 IN c_cons LOOP
        l_nom_arch := 'sc'||to_char(c1.id_cons_bouquet)||'.tmp';
         begin
           p_text_io   := UTL_FILE.FOPEN(g_directorio_local, l_nom_arch, 'R'); --pruebas

            LOOP
                BEGIN
                    utl_file.get_line(p_text_io, ls_tarjeta);
                    ls_tarjeta := REPLACE(REPLACE(REPLACE(ls_tarjeta,CHR(10),'') ,CHR(13),'') ,'  ','');
                    insert into atccorp.atc_tarjetas_aux  values(ls_tarjeta,c1.id_cons_bouquet );
                EXCEPTION
                    WHEN OTHERS THEN
                    EXIT;
                END;
            END LOOP;
            UTL_FILE.FCLOSE(p_text_io);

            select count(cod_tarjeta) into l_total_tarj_arch from atccorp.atc_tarjetas_aux  where id_cons_bouquet = c1.id_cons_bouquet ;
           l_total_tarj := l_cant_tarj;
            IF l_total_tarj_arch > l_cant_tarj THEN
              SELECT MOD(l_total_tarj_arch, l_cant_tarj) INTO residuo FROM dummy_ope;
              vuelta       := trunc(l_total_tarj_arch / l_cant_tarj);
              IF residuo > 0 THEN
                vuelta       := trunc(l_total_tarj_arch / l_cant_tarj) + 1;
              END IF;
            ELSE
              vuelta       := 1;
            END IF;

            FOR i IN 0 .. vuelta - 1 LOOP
                    if i = vuelta - 1 and  residuo > 0 THEN
                        l_total_tarj := residuo;
                    end if ;
    --             Guardamos los datos del archivo en la base de datos -- CABECERA
                     BEGIN
                        insert into atccorp.atc_file_bouquet_dth_cab (ID_FILE_BOUQUET_CAB, COD_TRANSACCION_CAB , FILENAME_CAB, ESTADO_CAB, REINTENTO_CAB, ID_CONS_BOUQUET, USUREG, FECREG )-- ,  USUENV, FECENV, USUMOD, FECMOD  )
                        values(null, null, null, 1,0,c1.id_cons_bouquet,user, sysdate);
                        OPERACION.PQ_REVISION_BOUQUETS_DTH.P_obtener_id('B',ln_cab );
                    END;
                    --             Guardamos los datos del archivo en la base de datos -- DETALLE
                    ls_tarjeta := '';
                      FOR c2 IN c_tarjeta(c1.id_cons_bouquet,i, l_cant_tarj) LOOP
                            ls_tarjeta := REPLACE(REPLACE(REPLACE(c2.cod_tarjeta,CHR(10),'') ,CHR(13),'') ,'  ','');
                            p_verifica_tarjeta(ls_tarjeta,p_resultado,p_mensaje );
                            if p_resultado <> 0 then
                                l_observacion :=  substr(p_mensaje,1,100);
--                                select substr(p_mensaje,1,100) into l_observacion from dual;
                            else
                                l_observacion := null;
                            end if ;
                          insert into atccorp.atc_file_bouquet_dth_det (ID_FILE_BOUQUET_DET,ID_FILE_BOUQUET_CAB,COD_TARJETA,OBSERVACION, USUREG,FECREG)
                          values(null,ln_cab,ls_tarjeta , l_observacion, user, sysdate);
                      END LOOP;
                      commit;
                          p_enviar_conax(ln_cab, p_resultado , p_mensaje );
             END LOOP;
        -- BORRAMOS TARJETAS DE LA TABLA TEMPORAL
                delete atccorp.atc_tarjetas_aux d  WHERE d.id_cons_bouquet = c1.id_cons_bouquet;
                commit;

            update atccorp.atc_consulta_bouquet set ESTADO = 2 , NUMARCH = vuelta where id_cons_bouquet= c1.id_cons_bouquet;

            UTL_FILE.fremove(g_directorio_local, l_nom_arch);

            commit;

        exception
          when utl_file.invalid_operation then
            dbms_output.put_line (  'Error: ' ||g_directorio_local ||'-'||l_nom_arch ||' No existe');
        end;

    END LOOP;
     commit;
    dbms_output.put_line (  'Proceso Exitoso ');
  END;

  PROCEDURE p_enviar_conax_aut IS

     l_file_bouquet          utl_file.file_type;
    l_resp number ;
   l_archivo_remoto varchar2(1000);
    ls_nombre varchar(50);
    l_transac number;
    l_estado number;
    l_resultado_ftp varchar2(100);
    ln_cont number;
    l_mensaje varchar2(1000);
    l_mensaje_ftp varchar2(1000);
    ll_rpta_val number;
    respuestenv varchar2(1000);
    respustaren varchar2(1000);
    ls_cant                 VARCHAR(6);
        CURSOR c_tarjetas (cab number)IS
      SELECT *
        FROM atccorp.atc_file_bouquet_dth_det
       WHERE id_file_bouquet_cab = cab
       ORDER BY cod_tarjeta;

CURSOR c_cons is select ID_FILE_BOUQUET_CAB,COD_TRANSACCION_CAB, FILENAME_CAB from atccorp.atc_file_bouquet_dth_cab
where ESTADO_CAB in (1,4) and REINTENTO_CAB < 6  order by ID_FILE_BOUQUET_CAB asc ;

  BEGIN
    p_set_configuracion;

    FOR c1 IN c_cons LOOP
         IF c1.COD_TRANSACCION_CAB  IS NULL THEN
            l_transac  := f_genera_codigo_trx();
            ls_nombre := 'sc' || l_transac || '.tmp';
         else
            ls_nombre :=  c1.FILENAME_CAB;
        END IF;
        --verificar archivo en directorio ok
        l_archivo_remoto := REPLACE(g_directorio_remoto_ok || '/' || replace(ls_nombre,'.emm','.tmp'), '//', '/');
       p_verificar_archivo_ftp(g_host, g_puerto, g_usuario, g_pass,l_archivo_remoto, l_resp);
        IF l_resp > 0 THEN
          p_eliminar_archivo_ftp(l_archivo_remoto, l_resultado_ftp, l_mensaje_ftp);
        END IF;
        -- verificar archivo en directorio error
         l_archivo_remoto := REPLACE(g_directorio_remoto_error || '/' ||  replace(ls_nombre,'.emm','.tmp'), '//',  '/');
         p_verificar_archivo_ftp(g_host, g_puerto, g_usuario, g_pass,l_archivo_remoto, l_resp);
        IF l_resp > 0 THEN
          p_eliminar_archivo_ftp(l_archivo_remoto, l_resultado_ftp, l_mensaje_ftp);
--           dbms_output.put_line (  'Error: al enviar archivo a conax : ' ||l_mensaje_ftp||SQLERRM );
        END IF;

        -- CONTAR CUANTAS TARJETAS
        ln_cont := 0;
        FOR c_tar IN c_tarjetas(c1.ID_FILE_BOUQUET_CAB) LOOP
          ll_rpta_val := f_valida_tarjeta(c_tar.cod_tarjeta);
          IF ll_rpta_val = 0 THEN
            ln_cont   := ln_cont + 1;
            l_mensaje := '';
          ELSIF ll_rpta_val = -1 THEN
            l_mensaje := f_obtiene_mensaje('NO_EXISTE_TARJETA');
          ELSIF ll_rpta_val = 1 THEN
            l_mensaje := f_obtiene_mensaje('FMT_NRO_CARAC');
          ELSIF ll_rpta_val = 2 THEN
            l_mensaje := f_obtiene_mensaje('FMT_TARJ_01');
          ELSIF ll_rpta_val = 3 THEN
            l_mensaje := f_obtiene_mensaje('FMT_ESP_VACIO');
          END IF;
          IF ll_rpta_val <> 0 THEN
            --l_mensaje <> '' then
                begin
                    UPDATE atccorp.atc_file_bouquet_dth_det d SET d.observacion = l_mensaje  WHERE d.id_file_bouquet_cab = c_tar.id_file_bouquet_cab  AND d.id_file_bouquet_det = c_tar.id_file_bouquet_det;
                exception
                     WHEN OTHERS THEN
                     dbms_output.put_line (  'Error: actualizando observacion de tarjeta: ' ||c_tar.cod_tarjeta ||SQLERRM );
                end;
           else
                begin
                    UPDATE atccorp.atc_file_bouquet_dth_det d SET d.observacion = null  WHERE d.id_file_bouquet_cab = c_tar.id_file_bouquet_cab  AND d.id_file_bouquet_det = c_tar.id_file_bouquet_det;
                exception
                     WHEN OTHERS THEN
                     dbms_output.put_line (  'Error: actualizando observacion de tarjeta: ' ||c_tar.cod_tarjeta ||SQLERRM );
                end;
          END IF;
        END LOOP;
        commit;
        SELECT lpad((to_char(ln_cont)), 6, '0') INTO ls_cant FROM dual;

           if ln_cont > 0 then

                    --crear archivo
                    operacion.pq_dth_interfaz.p_abrir_archivo(l_file_bouquet, g_directorio_local, ls_nombre, 'W',  l_resultado_ftp,  l_mensaje_ftp);
                    IF l_resultado_ftp <> 'OK' THEN
                      l_mensaje   := l_mensaje_ftp;
                        dbms_output.put_line (  'Error: al enviar archivo a conax : ' ||l_mensaje||SQLERRM );
                    END IF;

               --escribir linea
                operacion.pq_dth_interfaz.p_escribe_linea(l_file_bouquet, 'U', '1');
                operacion.pq_dth_interfaz.p_escribe_linea(l_file_bouquet,  to_char(l_transac),  '1');
                operacion.pq_dth_interfaz.p_escribe_linea(l_file_bouquet, 'U', '1');
                operacion.pq_dth_interfaz.p_escribe_linea(l_file_bouquet, 'U', '1');
                operacion.pq_dth_interfaz.p_escribe_linea(l_file_bouquet, 'U', '1');
                operacion.pq_dth_interfaz.p_escribe_linea(l_file_bouquet, 'U', '1');
                operacion.pq_dth_interfaz.p_escribe_linea(l_file_bouquet, 'EMM', '1');
                operacion.pq_dth_interfaz.p_escribe_linea(l_file_bouquet, 'U', '1');

                operacion.pq_dth_interfaz.p_escribe_linea(l_file_bouquet, ls_cant, '1');

                -- SACAR TODAS LAS TARJETAS

                FOR c_tar IN c_tarjetas (c1.ID_FILE_BOUQUET_CAB) LOOP
                  IF c_tar.observacion IS NULL THEN
                    operacion.pq_dth_interfaz.p_escribe_linea(l_file_bouquet, c_tar.cod_tarjeta, '1');
                  END IF;
                END LOOP;

                operacion.pq_dth_interfaz.p_escribe_linea(l_file_bouquet, 'ZZZ', '1');
                --cerrar archivo
                operacion.pq_dth_interfaz.p_cerrar_archivo(l_file_bouquet);


                --enviar archivo
                BEGIN
                  l_archivo_remoto := REPLACE(g_directorio_remoto_envio || '/' || ls_nombre,  '//',  '/');
                  p_enviar_archivo_ascii(g_host,
                                 g_puerto,
                                 g_usuario,
                                 g_pass,
                                 g_directorio_local,
                                 ls_nombre,
                                 l_archivo_remoto , --g_directorio_local||replace(ls_nombre,'.emm','.tmp'),
                                 respuestenv);
               -- renombrar
                p_ren_archivo_ascii(g_host,
                                                        g_puerto,
                                                        g_usuario,
                                                        g_pass,
                                                        l_archivo_remoto,
                                                        replace(l_archivo_remoto,'.tmp','.emm'),
                                                        respustaren);

                  l_estado := f_get_estado('ENVIADO');
                EXCEPTION
                  WHEN OTHERS THEN
                   l_estado := f_get_estado('ERROR');
                    l_mensaje                          := f_obtiene_mensaje('ENVIO_FTP_ERROR');
                      dbms_output.put_line (  'Error: al enviar archivo a conax : ' ||l_mensaje||SQLERRM );
                END;

                begin
                  update atccorp.atc_file_bouquet_dth_cab set ESTADO_CAB = l_estado,  FILENAME_CAB = replace(ls_nombre,'.tmp','.emm'), COD_TRANSACCION_CAB = l_transac, REINTENTO_CAB = nvl(REINTENTO_CAB,0)+1,
                  usuenv = USER, fecenv = SYSDATE         where ID_FILE_BOUQUET_CAB = c1.ID_FILE_BOUQUET_CAB;
                exception
                     WHEN OTHERS THEN
                     dbms_output.put_line (  'Error: actualizando atc_file_bouquet_dth_cab : ' ||ls_nombre ||SQLERRM );
           end;
            end if ;

    END LOOP;
    commit;
    dbms_output.put_line (  'Proceso Exitoso ');
  END;

   PROCEDURE p_reenviar_conax ( p_id_correlativo atccorp.atc_file_bouquet_dth_cab.ID_CONS_BOUQUET%TYPE,
                           p_resultado      IN OUT NUMBER,
                           p_mensaje        IN OUT VARCHAR2
  )IS

     l_file_bouquet          utl_file.file_type;
    l_resp number ;
   l_archivo_remoto varchar2(1000);
    ls_nombre varchar(50);
    l_transac number;
    l_estado number;
    l_resultado             NUMBER;
    l_resultado_ftp varchar2(100);
    ln_cont number;
    l_mensaje varchar2(1000);
    l_mensajet varchar2(1000);
    l_mensaje_ftp varchar2(1000);
    ll_rpta_val number;
    respuestenv varchar2(1000);
    respustaren   varchar2(1000);
    ls_cant                 VARCHAR(6);
        CURSOR c_tarjetas (cab number)IS
      SELECT *
        FROM atccorp.atc_file_bouquet_dth_det
       WHERE id_file_bouquet_cab = cab
       ORDER BY cod_tarjeta;

        CURSOR c_cons is select ID_FILE_BOUQUET_CAB,COD_TRANSACCION_CAB, FILENAME_CAB from atccorp.atc_file_bouquet_dth_cab
        where ESTADO_CAB in (2,4) and REINTENTO_CAB < 6  and ID_CONS_BOUQUET = p_id_correlativo order by ID_FILE_BOUQUET_CAB asc ;

  BEGIN
    l_resultado := 0;
    l_mensaje   := f_obtiene_mensaje('ENVIO_FTP_OK');
    p_set_configuracion;

    FOR c1 IN c_cons LOOP
         IF c1.COD_TRANSACCION_CAB  IS NULL THEN
            l_transac  := f_genera_codigo_trx();
            ls_nombre := 'sc' || l_transac || '.tmp';
         else
            l_transac := c1.COD_TRANSACCION_CAB;
            ls_nombre :=  c1.FILENAME_CAB;
        END IF;
        --verificar archivo en directorio ok
        l_archivo_remoto := REPLACE(g_directorio_remoto_ok || '/' || replace(ls_nombre,'.emm','.tmp'), '//', '/');
       p_verificar_archivo_ftp(g_host, g_puerto, g_usuario, g_pass,l_archivo_remoto, l_resp);
        IF l_resp > 0 THEN
          p_eliminar_archivo_ftp(l_archivo_remoto, l_resultado_ftp, l_mensaje_ftp);
        END IF;
         --verificar archivo en directorio error
         l_archivo_remoto := REPLACE(g_directorio_remoto_error || '/' ||  replace(ls_nombre,'.emm','.tmp'), '//',  '/');
         p_verificar_archivo_ftp(g_host, g_puerto, g_usuario, g_pass,l_archivo_remoto, l_resp);
        IF l_resp > 0 THEN
          p_eliminar_archivo_ftp(l_archivo_remoto, l_resultado_ftp, l_mensaje_ftp);
--           dbms_output.put_line (  'Error: al enviar archivo a conax : ' ||l_mensaje_ftp||SQLERRM );
        END IF;

        -- CONTAR CUANTAS TARJETAS
        ln_cont := 0;
        FOR c_tar IN c_tarjetas(c1.ID_FILE_BOUQUET_CAB) LOOP
          ll_rpta_val := f_valida_tarjeta(c_tar.cod_tarjeta);
          IF ll_rpta_val = 0 THEN
            ln_cont   := ln_cont + 1;
            l_mensajet := '';
          ELSIF ll_rpta_val = -1 THEN
            l_mensajet := f_obtiene_mensaje('NO_EXISTE_TARJETA');
          ELSIF ll_rpta_val = 1 THEN
            l_mensajet := f_obtiene_mensaje('FMT_NRO_CARAC');
          ELSIF ll_rpta_val = 2 THEN
            l_mensajet := f_obtiene_mensaje('FMT_TARJ_01');
          ELSIF ll_rpta_val = 3 THEN
            l_mensajet := f_obtiene_mensaje('FMT_ESP_VACIO');
          END IF;
                IF ll_rpta_val <> 0 THEN
            --l_mensaje <> '' then
                    UPDATE atccorp.atc_file_bouquet_dth_det d SET d.observacion = l_mensajet  WHERE d.id_file_bouquet_cab = c_tar.id_file_bouquet_cab  AND d.id_file_bouquet_det = c_tar.id_file_bouquet_det;
              END IF;
        END LOOP;
        commit;
        SELECT lpad((to_char(ln_cont)), 6, '0') INTO ls_cant FROM dual;

           if ln_cont > 0 then

                    --crear archivo
                    operacion.pq_dth_interfaz.p_abrir_archivo(l_file_bouquet, g_directorio_local, ls_nombre, 'W',  l_resultado_ftp,  l_mensaje_ftp);
                    IF l_resultado_ftp <> 'OK' THEN
                        l_resultado                        := -1;
                        l_mensaje                          := l_mensaje_ftp;
                    END IF;

               --escribir linea
                operacion.pq_dth_interfaz.p_escribe_linea(l_file_bouquet, 'U', '1');
                operacion.pq_dth_interfaz.p_escribe_linea(l_file_bouquet,  to_char(l_transac),  '1');
                operacion.pq_dth_interfaz.p_escribe_linea(l_file_bouquet, 'U', '1');
                operacion.pq_dth_interfaz.p_escribe_linea(l_file_bouquet, 'U', '1');
                operacion.pq_dth_interfaz.p_escribe_linea(l_file_bouquet, 'U', '1');
                operacion.pq_dth_interfaz.p_escribe_linea(l_file_bouquet, 'U', '1');
                operacion.pq_dth_interfaz.p_escribe_linea(l_file_bouquet, 'EMM', '1');
                operacion.pq_dth_interfaz.p_escribe_linea(l_file_bouquet, 'U', '1');

                operacion.pq_dth_interfaz.p_escribe_linea(l_file_bouquet, ls_cant, '1');

                -- SACAR TODAS LAS TARJETAS

                FOR c_tar IN c_tarjetas (c1.ID_FILE_BOUQUET_CAB) LOOP
                  IF c_tar.observacion IS NULL THEN
                    operacion.pq_dth_interfaz.p_escribe_linea(l_file_bouquet, c_tar.cod_tarjeta, '1');
                  END IF;
                END LOOP;

                operacion.pq_dth_interfaz.p_escribe_linea(l_file_bouquet, 'ZZZ', '1');
                --cerrar archivo
                operacion.pq_dth_interfaz.p_cerrar_archivo(l_file_bouquet);


                --enviar archivo
                BEGIN
                     l_archivo_remoto := REPLACE(g_directorio_remoto_envio || '/' || ls_nombre,  '//',  '/');
                      p_enviar_archivo_ascii(g_host,
                                     g_puerto,
                                     g_usuario,
                                     g_pass,
                                     g_directorio_local,
                                     ls_nombre,
                                     l_archivo_remoto ,
                                 respuestenv);
                   -- renombrar
                    p_ren_archivo_ascii(g_host,
                                                            g_puerto,
                                                            g_usuario,
                                                            g_pass,
                                                            l_archivo_remoto,
                                                            replace(l_archivo_remoto,'.tmp','.emm'),
                                                            respustaren);

                  l_estado := f_get_estado('ENVIADO');
                EXCEPTION
                  WHEN OTHERS THEN
                   l_estado := f_get_estado('ERROR');
                    l_resultado                        := -1;
                    l_mensaje                          := f_obtiene_mensaje('ENVIO_FTP_ERROR');
                END;

                begin
                  update atccorp.atc_file_bouquet_dth_cab set ESTADO_CAB = l_estado,  FILENAME_CAB = replace(ls_nombre,'.tmp','.emm'), COD_TRANSACCION_CAB = l_transac, REINTENTO_CAB = nvl(REINTENTO_CAB,0)+1,
                  usuenv = USER, fecenv = SYSDATE         where ID_FILE_BOUQUET_CAB = c1.ID_FILE_BOUQUET_CAB;
                exception
                     WHEN OTHERS THEN
                        l_resultado                        := -1;
                        l_mensaje                          := f_obtiene_mensaje('ENVIO_FTP_ERROR');
           end;
            end if ;

    END LOOP;
    commit;
    <<salto>>
    p_resultado := l_resultado;
    p_mensaje   := l_mensaje;

  EXCEPTION
    WHEN OTHERS THEN
      p_resultado := -1;
      p_mensaje   := f_obtiene_mensaje('ENVIO_FTP_ERROR');
      p_mensaje   := p_mensaje || ':Error BD: ' || SQLCODE || ' ' ||
                     SQLERRM;
  END;

   PROCEDURE p_actualizar_de_conax IS
  l_resp number ;
   l_stado_arch number;
   l_archivo_remoto varchar2(1000);
   l_resultado_ftp VARCHAR2(1000);
    l_mensaje_ftp VARCHAR2(1000);
    ls_rpta  VARCHAR2(1000);
    CURSOR c_tarj(cab number)is
        select id_file_bouquet_det, cod_tarjeta  from atccorp.atc_file_bouquet_dth_det where id_file_bouquet_cab = cab order by cod_tarjeta asc;

CURSOR c_cons is select id_cons_bouquet, ID_FILE_BOUQUET_CAB, FILENAME_CAB from atccorp.atc_file_bouquet_dth_cab where ESTADO_CAB = 2 order by COD_TRANSACCION_CAB  ;

  BEGIN
    p_set_configuracion;

    FOR c1 IN c_cons LOOP

         l_archivo_remoto := REPLACE(g_directorio_remoto_ok || '/' || replace(c1.FILENAME_CAB,'.tmp','.emm'), '//',  '/');
        p_verificar_archivo_ftp(g_host, g_puerto,  g_usuario, g_pass,l_archivo_remoto, l_resp);
        IF l_resp > 0 THEN
          -- RECIBIR ARCHIVO
          operacion.pq_dth_interfaz.p_recibir_archivo_ascii (g_host, g_puerto, g_usuario, g_rut_idrsa, g_directorio_local,replace(c1.FILENAME_CAB,'.tmp','.emm'), l_archivo_remoto );

          -- VALIDAR ARCHIVO
          ls_rpta := f_valida_xml(g_directorio_local, replace(c1.FILENAME_CAB,'.tmp','.emm') );
          if ls_rpta <> 'EXITO' THEN
             -- ACTUALIZAR ESTADO DE ARCHIVO
              update   atccorp.atc_file_bouquet_dth_cab set ESTADO_CAB = 4 where ID_FILE_BOUQUET_CAB = c1.ID_FILE_BOUQUET_CAB ;
              -- ACTUALIZAR ESTADO DE CONSULTA
              update atccorp.ATC_CONSULTA_BOUQUET set ESTADO = 6 where id_cons_bouquet = c1.id_cons_bouquet;
          else

            -- ACTUALIZAR ESTADO DE ARCHIVO
            update   atccorp.atc_file_bouquet_dth_cab set ESTADO_CAB = 5 where ID_FILE_BOUQUET_CAB = c1.ID_FILE_BOUQUET_CAB ;
            -- LEER BOUQUET DE ARCHIVO Y ACTUALIZAR EN DETALLE X TARJETAS
             FOR c2 IN c_tarj(c1.ID_FILE_BOUQUET_CAB) LOOP
                    select  f_obtiene_cod_bouquet(g_directorio_local, replace(c1.FILENAME_CAB,'.tmp','.emm') , c2.cod_tarjeta) into ls_rpta from dual;
                    update atccorp.atc_file_bouquet_dth_det  set COD_BOUQUET = ls_rpta where id_file_bouquet_det = c2.id_file_bouquet_det;
             END LOOP;
             -- VERIFICAR ESTADO DE ARCHIVOS EN CONSULTA
            select count(*) into l_stado_arch from atccorp.atc_file_bouquet_dth_cab  where id_cons_bouquet = c1.id_cons_bouquet and ESTADO_CAB <> 5;
            -- ACTUALIZAR ESTADO DE CONSULTA
             if l_stado_arch > 0 then
                 update atccorp.ATC_CONSULTA_BOUQUET set ESTADO = 6 where id_cons_bouquet = c1.id_cons_bouquet;
             else
                 update atccorp.ATC_CONSULTA_BOUQUET set ESTADO = 7 where id_cons_bouquet = c1.id_cons_bouquet;
             end if ;
          end if ;
          --ELIMINAR ARCHIVO DE CONAX
          p_eliminar_archivo_ftp(l_archivo_remoto, l_resultado_ftp,  l_mensaje_ftp);
        END IF;
        commit;

         l_archivo_remoto := REPLACE(g_directorio_remoto_error || '/' || replace(c1.FILENAME_CAB,'.tmp','.emm'), '//',  '/');
         p_verificar_archivo_ftp(g_host, g_puerto, g_usuario,  g_pass, l_archivo_remoto,   l_resp);
        IF l_resp > 0 THEN
             -- ACTUALIZAR ESTADO DE ARCHIVO
                update   atccorp.atc_file_bouquet_dth_cab set ESTADO_CAB = 4 where ID_FILE_BOUQUET_CAB = c1.ID_FILE_BOUQUET_CAB ;
                -- ACTUALIZAR ESTADO DE CONSULTA
                 update atccorp.ATC_CONSULTA_BOUQUET set ESTADO = 6 where id_cons_bouquet = c1.id_cons_bouquet;
                --ELIMINAR ARCHIVO DE CONAX
                p_eliminar_archivo_ftp(l_archivo_remoto, l_resultado_ftp,  l_mensaje_ftp);
        END IF;
    END LOOP;
     commit;
    dbms_output.put_line (  'Proceso Exitoso ');
  END;

  PROCEDURE p_actualizar_de_conax_uni( p_id_correlativo atccorp.atc_file_bouquet_dth_cab.ID_CONS_BOUQUET%TYPE,
                           p_resultado      IN OUT NUMBER,
                           p_mensaje        IN OUT VARCHAR2
  ) IS
  l_resp number ;
   l_stado_arch number;
   l_archivo_remoto varchar2(1000);
    l_resultado_ftp VARCHAR2(1000);
    l_mensaje_ftp VARCHAR2(1000);
    ls_rpta  VARCHAR2(1000);
    l_resultado NUMBER;
    l_mensaje VARCHAR2(1000);
    CURSOR c_tarj(cab number)is
        select id_file_bouquet_det, cod_tarjeta  from atccorp.atc_file_bouquet_dth_det where id_file_bouquet_cab = cab order by cod_tarjeta asc;

CURSOR c_cons is select id_cons_bouquet, ID_FILE_BOUQUET_CAB, FILENAME_CAB from atccorp.atc_file_bouquet_dth_cab where ID_CONS_BOUQUET = p_id_correlativo and ESTADO_CAB <>  5 order by COD_TRANSACCION_CAB ;

  BEGIN
    l_resultado := 0;
    l_mensaje   := f_obtiene_mensaje('ACTUALIZAR_FTP_OK');
    p_set_configuracion;
    FOR c1 IN c_cons LOOP
         l_archivo_remoto := REPLACE(g_directorio_remoto_ok || '/' || replace(c1.FILENAME_CAB,'.tmp','.emm') , '//',  '/');
        p_verificar_archivo_ftp(g_host, g_puerto,  g_usuario, g_pass,l_archivo_remoto, l_resp);
        IF l_resp > 0 THEN
          -- RECIBIR ARCHIVO
            operacion.pq_dth_interfaz.p_recibir_archivo_ascii (g_host, g_puerto, g_usuario, g_rut_idrsa, g_directorio_local,replace(c1.FILENAME_CAB,'.tmp','.emm'), l_archivo_remoto );

           -- VALIDAR ARCHIVO
            ls_rpta := f_valida_xml(g_directorio_local, replace(c1.FILENAME_CAB,'.tmp','.emm') );
            if ls_rpta <> 'EXITO' THEN
               -- ACTUALIZAR ESTADO DE ARCHIVO
                update   atccorp.atc_file_bouquet_dth_cab set ESTADO_CAB = 4 where ID_FILE_BOUQUET_CAB = c1.ID_FILE_BOUQUET_CAB ;
                -- ACTUALIZAR ESTADO DE CONSULTA
                update atccorp.ATC_CONSULTA_BOUQUET set ESTADO = 6 where id_cons_bouquet = c1.id_cons_bouquet;
            else
                -- ACTUALIZAR ESTADO DE ARCHIVO
                update   atccorp.atc_file_bouquet_dth_cab set ESTADO_CAB = 5 where ID_FILE_BOUQUET_CAB = c1.ID_FILE_BOUQUET_CAB ;
                -- LEER BOUQUET DE ARCHIVO Y ACTUALIZAR EN DETALLE X TARJETAS
                FOR c2 IN c_tarj(c1.ID_FILE_BOUQUET_CAB) LOOP
                        select  f_obtiene_cod_bouquet(g_directorio_local, replace(c1.FILENAME_CAB,'.tmp','.emm') , c2.cod_tarjeta) into ls_rpta from dual;
                        update atccorp.atc_file_bouquet_dth_det  set COD_BOUQUET = ls_rpta where id_file_bouquet_det = c2.id_file_bouquet_det;
                 END LOOP;
              -- VERIFICAR ESTADO DE ARCHIVOS EN CONSULTA
                select count(*) into l_stado_arch from atccorp.atc_file_bouquet_dth_cab  where id_cons_bouquet = c1.id_cons_bouquet and ESTADO_CAB <> 5;
              -- ACTUALIZAR ESTADO DE CONSULTA
                 if l_stado_arch > 0 then
                     update atccorp.ATC_CONSULTA_BOUQUET set ESTADO = 6 where id_cons_bouquet = c1.id_cons_bouquet;
                 else
                     update atccorp.ATC_CONSULTA_BOUQUET set ESTADO = 7 where id_cons_bouquet = c1.id_cons_bouquet;
                 end if ;
            END IF ;
            --ELIMINAR ARCHIVO DE CONAX
            p_eliminar_archivo_ftp(l_archivo_remoto, l_resultado_ftp,  l_mensaje_ftp);
        END IF;
        commit;

         l_archivo_remoto := REPLACE(g_directorio_remoto_error || '/' || replace(c1.FILENAME_CAB,'.tmp','.emm'), '//',  '/');
         p_verificar_archivo_ftp(g_host, g_puerto, g_usuario,  g_pass, l_archivo_remoto,   l_resp);
        IF l_resp > 0 THEN
                -- ACTUALIZAR ESTADO DE ARCHIVO
                update   atccorp.atc_file_bouquet_dth_cab set ESTADO_CAB = 4 where ID_FILE_BOUQUET_CAB = c1.ID_FILE_BOUQUET_CAB ;
                -- ACTUALIZAR ESTADO DE CONSULTA
                 update atccorp.ATC_CONSULTA_BOUQUET set ESTADO = 6 where id_cons_bouquet = c1.id_cons_bouquet;
                --ELIMINAR ARCHIVO DE CONAX
                p_eliminar_archivo_ftp(l_archivo_remoto, l_resultado_ftp,  l_mensaje_ftp);
        END IF;
    END LOOP;
     commit;
      <<salto>>
    p_resultado := l_resultado;
    p_mensaje   := l_mensaje;
  EXCEPTION
  WHEN OTHERS THEN
      p_resultado := -1;
      p_mensaje   := f_obtiene_mensaje('ACTUALIZAR_FTP_ERROR');
      p_mensaje   := p_mensaje || ':Error BD: ' || SQLCODE || ' ' ||
                     SQLERRM;
  END;
  FUNCTION f_obtiene_cod_bouquet(p_directorio  VARCHAR2,
                                 p_archivo     VARCHAR2,
                                 p_cod_tarjeta atccorp.atc_file_bouquet_dth_det.cod_tarjeta%TYPE)
    RETURN VARCHAR IS
    l_archivo           utl_file.file_type;
    l_linea             VARCHAR2(4000);
    l_cod_bouquet       VARCHAR2(10);
    l_cod_bouquet_total VARCHAR2(1000);
    l_xml_inicio        VARCHAR2(100);
    c_xml_inicio    CONSTANT VARCHAR2(100) := 'cardNo=""';
    c_xml_fin       CONSTANT VARCHAR2(100) := '/AuthorisationStatus';
    c_parametro_xml CONSTANT VARCHAR2(100) := 'id="';
    l_encontrado   NUMBER(1);
    l_linea_valida NUMBER;
  BEGIN
    l_xml_inicio := REPLACE(c_xml_inicio, '""', '"' || p_cod_tarjeta || '"');
    l_xml_inicio := TRIM(l_xml_inicio);
    l_encontrado := 0;
    l_archivo    := utl_file.fopen(p_directorio, p_archivo, 'R');
    -- Leemos cada una de las líneas del archivo y la retornamos
    LOOP
      BEGIN
        utl_file.get_line(l_archivo, l_linea);
        l_linea        := REPLACE(REPLACE(TRIM(l_linea), '<', ''), '>', '');
        l_linea_valida := instr(l_linea, l_xml_inicio);
        IF l_linea_valida > 0 THEN
          l_encontrado := 1;
        END IF;
        IF l_encontrado = 1 THEN
          SELECT instr(l_linea, c_parametro_xml)
            INTO l_linea_valida
            FROM dual;
          IF l_linea_valida > 0 THEN
            SELECT substr(l_linea,
                          instr(l_linea, c_parametro_xml) +
                          length(c_parametro_xml),
                          instr(l_linea,
                                '"',
                                instr(l_linea, c_parametro_xml, 1) +
                                length(c_parametro_xml)) -
                          (instr(l_linea, c_parametro_xml) +
                           length(c_parametro_xml)))
              INTO l_cod_bouquet
              FROM dual;
            IF l_cod_bouquet_total IS NULL THEN
              l_cod_bouquet_total := l_cod_bouquet;
            ELSE
              l_cod_bouquet_total := l_cod_bouquet_total || ',' ||
                                     l_cod_bouquet;
            END IF;
          END IF;
          l_linea_valida := instr(l_linea, c_xml_fin);
          IF l_linea_valida > 0 THEN
            EXIT;
          END IF;
        END IF;
      EXCEPTION
        WHEN no_data_found THEN
          EXIT;
      END;

      --Pipe row (l_Linea);
    END LOOP;

    utl_file.fclose(l_archivo);
    RETURN l_cod_bouquet_total;
  END;

  FUNCTION f_valida_xml(p_directorio  VARCHAR2,
                                 p_archivo     VARCHAR2)
    RETURN VARCHAR IS
    l_archivo           utl_file.file_type;
    l_linea             VARCHAR2(4000);
    --l_cod_bouquet       VARCHAR2(10);
    l_cod_bouquet_total VARCHAR2(1000);
   -- l_xml_inicio        VARCHAR2(100);

    c_xml_ini       CONSTANT VARCHAR2(100) := '<AuthorisationStatuses>'  ;
    c_xml_fin       CONSTANT VARCHAR2(100) := '</AuthorisationStatuses>';

    c_xml_ini_t       CONSTANT VARCHAR2(100) := '<AuthorisationStatus '   ;
    c_xml_fin_t       CONSTANT VARCHAR2(100) := '</AuthorisationStatus>';

    c_xml_ini_p       CONSTANT VARCHAR2(100) := '<Product'    ;
    c_xml_fin_p       CONSTANT VARCHAR2(100) := '</Product';

    l_encontrado_i   NUMBER;
    l_encontrado_t   NUMBER;
    l_encontrado_p   NUMBER;
    l_encontrado_if   NUMBER;
    l_encontrado_tf   NUMBER;
    l_encontrado_pf   NUMBER;

    l_linea_valida NUMBER;
  BEGIN

    l_encontrado_i := 0;
    l_encontrado_t := 0;
    l_encontrado_p := 0;
    l_encontrado_if := 0;
    l_encontrado_tf := 0;
    l_encontrado_pf := 0;

    l_archivo    := utl_file.fopen(p_directorio, p_archivo, 'R');
    -- Leemos cada una de las líneas del archivo y CONTAMOS
    LOOP
      BEGIN
        utl_file.get_line(l_archivo, l_linea);
        l_linea        := TRIM(l_linea) ;

        -- INICIO DE CUERPO
        l_linea_valida := instr(l_linea, c_xml_ini);
        IF l_linea_valida > 0 THEN
          l_encontrado_i := l_encontrado_i + 1;
        END IF;

     --   FIN DE CUERPO
        l_linea_valida := instr(l_linea, c_xml_fin);
        IF l_linea_valida > 0 THEN
          l_encontrado_if := l_encontrado_if + 1;
        END IF;

       --  INICIO DE TARJETA
        l_linea_valida := instr(l_linea, c_xml_ini_t);
        IF l_linea_valida > 0 THEN
          l_encontrado_t := l_encontrado_t + 1;
        END IF;

       -- FIN DE TARJETA
        l_linea_valida := instr(l_linea, c_xml_fin_t);
        IF l_linea_valida > 0 THEN
          l_encontrado_tf := l_encontrado_tf + 1;
        END IF;

       -- INICIO DE PRODUCTO
        l_linea_valida := instr(l_linea, c_xml_ini_p);
        IF l_linea_valida > 0 THEN
          l_encontrado_p := l_encontrado_p + 1;
        END IF;

        -- FIN DE PRODUCTO
        l_linea_valida := instr(l_linea, c_xml_fin_p);
        IF l_linea_valida > 0 THEN
          l_encontrado_pf := l_encontrado_pf + 1;
        END IF;
     EXCEPTION
        WHEN no_data_found THEN
          EXIT;
      END;
    END LOOP;
     l_cod_bouquet_total := 'EXITO';
     if l_encontrado_i <> l_encontrado_if then
          l_cod_bouquet_total := ' Archivo Con Error en Apertura y Cierre Etiqueta - cuerpo';
     else
          if l_encontrado_t <> l_encontrado_tf then
              l_cod_bouquet_total := ' Archivo Con Error en Apertura y Cierre Etiqueta - Tarjeta';
          else
              if l_encontrado_p <> l_encontrado_pf then
                 l_cod_bouquet_total := ' Archivo Con Error en Apertura y Cierre Etiqueta - Bouquet';
              end if ;
          end if ;
      end if ;
--
--     DBMS_OUTPUT.PUT_LINE ('l_encontrado_i:' || l_encontrado_i);
--     DBMS_OUTPUT.PUT_LINE ('l_cod_bouquet_total:' || l_cod_bouquet_total);
    utl_file.fclose(l_archivo);
    RETURN l_cod_bouquet_total;
  END;
 end;
/