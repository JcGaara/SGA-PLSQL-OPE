CREATE OR REPLACE PACKAGE BODY OPERACION.pq_cambio_plan_ce IS
  /************************************************************************************************
  NOMBRE:     OPERACION.PQ_CAMBIO_PLAN_CE
  PROPOSITO:  Generacion de asignacion de numero de Cambio de Plan
  
  REVISIONES:
   Version   Fecha          Autor            Solicitado por      Descripcion
   -------- ----------  ------------------   -----------------   ------------------------
   1.0      13/01/2014  Juan Pablo Ramos     Giovanni Vasquez    PROY-17292 Cambio Plan CE en HFC.
  /************************************************************************************************/
  cv_telefonia    CONSTANT CHAR(4) := '0004';
  cn_asinado      CONSTANT NUMBER := 2;
  cn_reserva_temp CONSTANT NUMBER := 5;
  cn_en_ejecucion CONSTANT tareawf.tipesttar%type := 2;
  cn_con_errores  CONSTANT tareawf.esttarea%type := 19;
  PROCEDURE p_asigna_numero_wf(an_idtareawf IN NUMBER,
                               an_idwf      IN NUMBER,
                               an_tarea     IN NUMBER,
                               an_tareadef  IN NUMBER) IS
    ln_codsolot solot.codsolot%TYPE;
  BEGIN
    -- OBTENER SOT DE CAMBIO PLAN
    ln_codsolot := f_obtiene_sot(an_idwf);
    -- VALIDAR SI EXISTE SERVICIO TELEFONIA
    IF NOT f_existe_telefonia(ln_codsolot) THEN
      RETURN;
    END IF;
    -- RESERVA NUMERO TEFONICO    
    p_reserva_numero(an_idtareawf, ln_codsolot);
    -- ASIGNAR NUMERO TEFONICO    
    p_asigna_numero(an_idtareawf, ln_codsolot);
  EXCEPTION
    WHEN OTHERS THEN
      -- REGISTRO ERROR
      p_registro_error(an_idtareawf, SQLERRM);
  END;
  /* **********************************************************************************************/
  PROCEDURE p_reserva_numero(an_idtareawf IN NUMBER,
                             an_codsolot  IN solot.codsolot%TYPE) IS
    ln_codzona   NUMBER;
    ln_resultado NUMBER;
    ln_codnumtel numtel.codnumtel%TYPE;
    lv_numero    numtel.numero%TYPE;
    lv_email     VARCHAR2(100);
    lv_mensaje   VARCHAR2(3000);
    R_ERROR EXCEPTION;
    -- CURSOR TELEFONIA SIN NUMERO
    CURSOR c_serv_telefonia IS
      SELECT p.pid, s.numslc, p.numpto, a.codubi, i.codcli
        FROM solot     s,
             solotpto  a,
             insprd    p,
             inssrv    i,
             tystabsrv b,
             producto  r
       WHERE s.codsolot = an_codsolot
         AND a.codsolot = s.codsolot
         AND a.codsrvnue = b.codsrv
         AND p.pid = a.pid
         AND p.codinssrv = a.codinssrv
         AND p.flgprinc = 1
         AND i.codinssrv = p.codinssrv
         AND i.numero IS NULL
         AND b.tipsrv = cv_telefonia
         AND b.idproducto = r.idproducto
         AND r.idtipinstserv = 3
       ORDER BY p.numpto;
  BEGIN
    -- OBTENER ZONA 3PLAY AUTOMATICO
    ln_codzona := f_obtiene_zona_aut();
    FOR reg IN c_serv_telefonia LOOP
      -- VALIDAR SI EXISTE RESERVA NUMERO
      IF f_existe_reserva_num(reg.pid) THEN
        RETURN;
      END IF;
      LOOP
        -- OBTENER NUMERO NUEVO
        lv_numero := f_get_numero_tel_itw(ln_codzona, reg.codubi);
        -- OBTENER CODIGO NUMERO TELEFONICO
        ln_codnumtel := f_obtiene_codnumtel(lv_numero);
        IF lv_numero IS NULL OR lv_numero = '0' THEN
          lv_mensaje := 'Falta de disponibilidad de numero.';
          RAISE R_ERROR;
        END IF;
        -- VALIDAR NUMERO NO ACTIVO EN INTRAWAY
        --intraway.pq_consultaitw.p_int_consultatn(lv_numero);
        -- VALIDAR NUMERO NO ACTIVO PARA OTRO CLIENTE
        operacion.pq_cuspe_ope2.p_valida_numtel(lv_numero,
                                                reg.codcli,
                                                ln_resultado,
                                                lv_mensaje);
        IF ln_resultado < 0 THEN
          -- ASIGNAR NUMERO TELEFONICO
          p_update_estnumtel(ln_codnumtel, cn_asinado);
          lv_mensaje := 'Se cambio a estado Asignado al numero telefonico ' ||
                        lv_numero ||
                        ' ya que servicio se encuentra activo, hacer seguimiento. ' ||
                        lv_mensaje;
          SELECT d.descripcion
            INTO lv_email
            FROM tipopedd m, opedd d
           WHERE m.tipopedd = d.tipopedd
             AND m.abrev = 'EMAIL_PLAT_FIJA';
          INSERT INTO opewf.cola_send_mail_job
            (nombre, subject, destino, cuerpo, flg_env)
          VALUES
            ('SGA-SoportealNegocio',
             'Asignacion de Numero Telefonico para Paquetes Intraway',
             lv_email,
             lv_mensaje,
             '0');
          -- CREAR SEGUIMIENTO DE TAREA
          p_crea_tareawfseg(an_idtareawf, lv_mensaje);
        ELSE
          EXIT;
        END IF;
      END LOOP;
      -- REGISTRAR RESERVA DE NUMERO TELEFONICO
      INSERT INTO reservatel
        (codnumtel, numslc, numpto, valido, codcli, estnumtel, publicar)
      VALUES
        (ln_codnumtel,
         reg.numslc,
         reg.numpto,
         1,
         reg.codcli,
         cn_reserva_temp,
         0);
      -- RESERVAR NUMERO TELEFONICO
      p_update_estnumtel(ln_codnumtel, cn_reserva_temp);
    END LOOP;
  EXCEPTION
    WHEN R_ERROR THEN
      raise_application_error(-20000,
                              $$PLSQL_UNIT ||
                              '.P_RESERVA_NUMERO(an_idtareawf => ' ||
                              an_idtareawf || 'an_codsolot => ' ||
                              an_codsolot || ') ' || lv_mensaje);
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$PLSQL_UNIT ||
                              '.P_RESERVA_NUMERO(an_idtareawf => ' ||
                              an_idtareawf || ', an_codsolot => ' ||
                              an_codsolot || ') ' || SQLERRM);
    
  END;
  /* **********************************************************************************************/
  PROCEDURE p_asigna_numero(an_idtareawf IN NUMBER,
                            an_codsolot  IN solot.codsolot%TYPE) IS
    ln_cabecera       NUMBER;
    ln_codcab         NUMBER;
    ln_codgrupo       NUMBER;
    ln_codnumtel      NUMBER;
    ln_orden          NUMBER;
    i                 NUMBER;
    ln_codinssrv      inssrv.codinssrv%TYPE;
    ln_codinssrv_prin inssrv.codinssrv%TYPE;
    lv_numero         numtel.numero%TYPE;
    lv_numslc         vtatabslcfac.numslc%TYPE;
    lb_vacio          BOOLEAN;
    lv_delim          VARCHAR2(10);
    lv_mensaje        VARCHAR2(3000);
    -- CURSOR RESERVA NUMEROS
    CURSOR c_reserva_numeros(av_numslc IN VARCHAR2) IS
      SELECT r.idseq, r.codnumtel, r.numpto, n.numero, r.publicar
        FROM reservatel r, numtel n
       WHERE r.numslc = av_numslc
         AND r.codnumtel = n.codnumtel
         AND n.codinssrv IS NULL
         AND r.valido = 1
       ORDER BY r.idseq;
  BEGIN
    i        := 1;
    lb_vacio := FALSE;
    lv_delim := ',';
    -- OBTENER NUMERO DE PROYECTO
    lv_numslc := f_obtiene_numslc(an_codsolot);
    -- VALIDAR SI EXISTE NUMEROS RESERVADOS
    IF NOT f_existe_reserva(lv_numslc) THEN
      RETURN;
    END IF;
    FOR reg IN c_reserva_numeros(lv_numslc) LOOP
      -- VALIDAR SI EXISTE NUMERO ASIGNADO
      IF f_existe_numero_asig(reg.codnumtel) THEN
        RETURN;
      END IF;
      -- OBTENER CODIGO DE INSTANCIA DE SERVICIO
      ln_codinssrv := f_obtiene_codinssrv(lv_numslc, reg.numpto);
      -- ACTUALIZA NUMERO TELEFONICO
      UPDATE numtel
         SET codinssrv = ln_codinssrv,
             estnumtel = cn_asinado,
             publicar  = reg.publicar
       WHERE codnumtel = reg.codnumtel;
      -- ACTUALIZAR NUMERO EN INSTANCIA DE SERVICIO
      UPDATE inssrv SET numero = reg.numero WHERE codinssrv = ln_codinssrv;
      -- ACTUALIZAR RESERVA TELEFONICA
      UPDATE reservatel SET valido = 1 WHERE idseq = reg.idseq;
      lv_mensaje := lv_mensaje || reg.numero || ',';
    END LOOP;
    -- OBTENER SERVICIO TELEFONIA PRINCIPAL
    p_obtiene_linea_prin(an_codsolot, ln_codinssrv_prin);
    -- OBTENER NUMERO TELEFONIA PRINCIPAL
    lv_numero := f_obtiene_sid_numero(ln_codinssrv_prin);
    -- OBTENER CODNUMTEL PRINCIPAL
    ln_cabecera := f_obtiene_codnumtel(lv_numero);
    -- OBTENER CODIGO HUNTING
    ln_codcab := f_obtiene_hunting(ln_cabecera);
    IF ln_codcab = 0 THEN
      -- CREAR HUNTING
      pq_telefonia.p_crear_hunting(ln_cabecera, ln_codcab);
    END IF;
    -- OBTENER CODIGO GRUPO TELEFONICO
    ln_codgrupo := f_obtiene_grupotel(ln_cabecera, ln_codcab);
    IF ln_codgrupo > 0 THEN
      -- CREAR NUMERO POR GRUPO TELEFONICO
      WHILE NOT lb_vacio LOOP
        -- OBTENER NUMERO DE LISTA DE NUMEROS ASIGNADOS
        lv_numero := f_obtiene_valor_lista(lv_mensaje, i, lv_delim);
        IF lv_numero IS NULL THEN
          lb_vacio := TRUE;
        END IF;
        IF NOT lb_vacio THEN
          -- OBTENER CODIGO NUMERO TELEFONICO
          ln_codnumtel := f_obtiene_codnumtel(lv_numero);
          IF ln_cabecera <> ln_codnumtel THEN
            -- CREAR GRUPO TELEFONICO
            pq_telefonia.p_crear_numxgrupotel(ln_codnumtel,
                                              ln_codcab,
                                              ln_codgrupo,
                                              ln_orden);
          END IF;
          i := i + 1;
        END IF;
      END LOOP;
    END IF;
    lv_mensaje := SUBSTR(lv_mensaje, 1, LENGTH(lv_mensaje) - 1);
    lv_mensaje := 'Se asigno automaticamente los numeros: ' || lv_mensaje;
    -- CREAR SEGUIMIENTO DE TAREA
    p_crea_tareawfseg(an_idtareawf, lv_mensaje);
  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$PLSQL_UNIT ||
                              '.P_ASIGNA_NUMERO(an_idtareawf => ' ||
                              an_idtareawf || ', an_codsolot => ' ||
                              an_codsolot || ') ' || SQLERRM);
    
  END;
  /* **********************************************************************************************/
  PROCEDURE p_registro_error(an_idtareawf IN tareawf.idtareawf%TYPE,
                             av_mensaje   IN VARCHAR2) IS
    lv_mensaje VARCHAR2(4000);
  BEGIN
    -- FORMATEAR MENSAJE
    lv_mensaje := f_formato_msg(av_mensaje);
    -- CAMBIAR ESTADO DE TAREA - CON ERROR
    p_con_error(an_idtareawf);
    COMMIT;
    raise_application_error(-20000, lv_mensaje);
  END;
  /****************************************************************************/
  PROCEDURE p_crea_tareawfseg(an_idtareawf IN tareawf.idtareawf%TYPE,
                              av_mensaje   IN tareawfseg.observacion%TYPE) IS
  BEGIN
    INSERT INTO tareawfseg
      (idtareawf, observacion, fecusu, codusu, flag)
    VALUES
      (an_idtareawf, av_mensaje, SYSDATE, USER, 1);
  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$PLSQL_UNIT ||
                              '.P_CREA_TAREAWFSEG(an_idtareawf => ' ||
                              an_idtareawf || ', av_mensaje => ' ||
                              av_mensaje || ') ' || SQLERRM);
  END;
  /* ***************************************************************************/
  PROCEDURE p_con_error(an_idtareawf IN NUMBER) IS
  BEGIN
    opewf.pq_wf.p_chg_status_tareawf(an_idtareawf,
                                     cn_en_ejecucion,
                                     cn_con_errores,
                                     0,
                                     SYSDATE,
                                     SYSDATE);
  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$PLSQL_UNIT ||
                              '.P_CON_ERROR(an_idtareawf => ' ||
                              an_idtareawf || ') ' || SQLERRM);
  END;
  /* ***************************************************************************/
  PROCEDURE p_update_estnumtel(an_codnumtel IN numtel.codnumtel%TYPE,
                               an_estnumtel IN numtel.estnumtel%TYPE) IS
  BEGIN
    -- ACTUALIZAR ESTADO NUMERO
    UPDATE numtel
       SET estnumtel = an_estnumtel
     WHERE codnumtel = an_codnumtel;
  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$PLSQL_UNIT ||
                              '.P_UPDATE_ESTNUMTEL(an_codnumtel => ' ||
                              an_codnumtel || ', an_estnumtel => ' ||
                              an_estnumtel || ') ' || SQLERRM);
  END;
  /* ***************************************************************************/
  PROCEDURE p_obtiene_linea_prin(an_codsolot  IN solot.codsolot%TYPE,
                                 an_codinssrv OUT inssrv.codinssrv%TYPE) IS
    ln_cantidad  NUMBER;
    ln_mayor     NUMBER;
    ln_codinssrv inssrv.codinssrv%TYPE;
    CURSOR c_serv_telefonia IS
      SELECT p.codinssrv, p.codsrv
        FROM solotpto a, insprd p, tystabsrv b, producto r
       WHERE a.codsolot = an_codsolot
         AND a.codsrvnue = b.codsrv
         AND a.pid = p.pid
         AND a.codinssrv = p.codinssrv
         AND b.tipsrv = cv_telefonia
         AND p.flgprinc = 1
         AND b.idproducto = r.idproducto
         AND r.idtipinstserv = 3;
  BEGIN
    -- OBTENER SERVICIO TELEFONIA PRINCIPAL
    SELECT p.codinssrv
      INTO ln_codinssrv
      FROM solotpto a, insprd p, tystabsrv b, detalle_paquete c, producto r
     WHERE a.codsolot = an_codsolot
       AND a.codsrvnue = b.codsrv
       AND a.pid = p.pid
       AND a.codinssrv = p.codinssrv
       AND b.tipsrv = cv_telefonia
       AND p.flgprinc = 1
       AND p.iddet = c.iddet
       AND b.idproducto = r.idproducto
       AND r.idtipinstserv = 3
       AND c.flg_opcional = 0;
    an_codinssrv := ln_codinssrv;
  EXCEPTION
    WHEN OTHERS THEN
      BEGIN
        ln_mayor := 0;
        -- OBTENER SERVICIO TELEFONIA PRINCIPAL
        FOR reg IN c_serv_telefonia LOOP
          SELECT COUNT(*)
            INTO ln_cantidad
            FROM solotpto a, insprd p
           WHERE a.codsolot = an_codsolot
             AND p.codinssrv = reg.codinssrv
             AND a.pid = p.pid
             AND a.codinssrv = p.codinssrv;
          IF ln_cantidad > ln_mayor THEN
            ln_mayor     := ln_cantidad;
            ln_codinssrv := reg.codinssrv;
          END IF;
        END LOOP;
        IF ln_mayor > 0 THEN
          an_codinssrv := ln_codinssrv;
        END IF;
      EXCEPTION
        WHEN OTHERS THEN
          raise_application_error(-20000,
                                  $$PLSQL_UNIT ||
                                  '.P_OBTIENE_LINEA_PRIN(an_codsolot => ' ||
                                  an_codsolot || ') ' || SQLERRM);
      END;
  END;
  /* **********************************************************************************************/
  FUNCTION f_existe_telefonia(an_codsolot IN solot.codsolot%TYPE)
    RETURN BOOLEAN IS
    ln_cantidad NUMBER;
  BEGIN
    -- VALIDAR SI EXISTE SERVICIO TELEFONIA
    SELECT COUNT(*)
      INTO ln_cantidad
      FROM solotpto a, insprd p, tystabsrv b, producto r
     WHERE a.codsolot = an_codsolot
       AND a.codsrvnue = b.codsrv
       AND a.pid = p.pid
       AND a.codinssrv = p.codinssrv
       AND b.tipsrv = cv_telefonia
       AND p.flgprinc = 1
       AND b.idproducto = r.idproducto
       AND r.idtipinstserv = 3;
    IF ln_cantidad > 0 THEN
      RETURN TRUE;
    ELSE
      RETURN FALSE;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN FALSE;
  END;
  /* ***************************************************************************/
  FUNCTION f_existe_reserva(av_numslc vtatabslcfac.numslc%TYPE)
    RETURN BOOLEAN IS
    ln_cantidad NUMBER;
  BEGIN
    -- VALIDAR SI EXISTE NUMEROS RESERVADOS
    SELECT COUNT(*)
      INTO ln_cantidad
      FROM reservatel r, numtel n
     WHERE r.numslc = av_numslc
       AND r.codnumtel = n.codnumtel
       AND n.codinssrv IS NULL
       AND r.valido = 1;
    IF ln_cantidad > 0 THEN
      RETURN TRUE;
    ELSE
      RETURN FALSE;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN FALSE;
  END;
  /* **********************************************************************************************/
  FUNCTION f_existe_reserva_num(an_pid IN solotpto.pid%TYPE) RETURN BOOLEAN IS
    ln_cantidad NUMBER;
  BEGIN
    SELECT COUNT(*)
      INTO ln_cantidad
      FROM insprd p, reservatel r
     WHERE p.pid = an_pid
       AND r.numslc = p.numslc
       AND r.numpto = p.numpto
       AND r.valido = 1;
    IF ln_cantidad > 0 THEN
      RETURN TRUE;
    ELSE
      RETURN FALSE;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN FALSE;
  END;
  /* **********************************************************************************************/
  FUNCTION f_existe_numero_asig(an_codnumtel IN numtel.codnumtel%TYPE)
    RETURN BOOLEAN IS
    ln_cantidad NUMBER;
  BEGIN
    SELECT COUNT(*)
      INTO ln_cantidad
      FROM numtel
     WHERE codnumtel = an_codnumtel
       AND codinssrv > 0;
    IF ln_cantidad > 0 THEN
      RETURN TRUE;
    ELSE
      RETURN FALSE;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN FALSE;
  END;
  /* **********************************************************************************************/
  FUNCTION f_formato_msg(av_mensaje IN VARCHAR2) RETURN VARCHAR2 IS
    lv_mensaje VARCHAR2(4000);
  BEGIN
    lv_mensaje := REPLACE(av_mensaje, 'ORA-20000: ', chr(13) || '>>');
    lv_mensaje := LTRIM(lv_mensaje, chr(13));
  
    RETURN lv_mensaje;
  END;
  /* **********************************************************************************************/
  FUNCTION f_obtiene_codnumtel(av_numero IN numtel.numero%TYPE)
    RETURN numtel.codnumtel%TYPE IS
    ln_codnumtel numtel.codnumtel%TYPE;
  BEGIN
    -- OBTENER CODIGO DE NUMERO TELEFONICO
    SELECT codnumtel
      INTO ln_codnumtel
      FROM numtel
     WHERE numero = av_numero;
    RETURN ln_codnumtel;
  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$PLSQL_UNIT ||
                              '.F_OBTIENE_CODNUMTEL(av_numero => ' ||
                              av_numero || ') ' || SQLERRM);
  END;
  /* **********************************************************************************************/
  FUNCTION f_obtiene_codinssrv(av_numslc IN vtatabslcfac.numslc%TYPE,
                               av_numpto IN inssrv.numpto%TYPE)
    RETURN inssrv.codinssrv%TYPE IS
    ln_codinssrv inssrv.codinssrv%TYPE;
  BEGIN
    -- OBTENER CODIGO DE INSTANCIA DE SERVICIO
    SELECT codinssrv
      INTO ln_codinssrv
      FROM inssrv
     WHERE tipinssrv = 3
       AND numero IS NULL
       AND codinssrv IN (SELECT p.codinssrv
                           FROM insprd p
                          WHERE p.numslc = av_numslc
                            AND p.numpto = av_numpto
                            AND p.flgprinc = 1);
    RETURN ln_codinssrv;
  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$PLSQL_UNIT ||
                              '.F_OBTIENE_CODINSSRV(av_numslc => ' ||
                              av_numslc || ', av_numpto => ' || av_numpto || ') ' ||
                              SQLERRM);
  END;
  /* **********************************************************************************************/
  FUNCTION f_obtiene_grupotel(an_codnumtel IN NUMBER, an_codcab IN NUMBER)
    RETURN NUMBER IS
    ln_codgrupo NUMBER;
  BEGIN
    -- OBTENER CODIGO GRUPO TELEFONICO
    SELECT NVL(MAX(codgrupo), 0)
      INTO ln_codgrupo
      FROM grupotel
     WHERE codcab = an_codcab
       AND codnumtel = an_codnumtel;
    RETURN ln_codgrupo;
  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$PLSQL_UNIT ||
                              '.F_OBTIENE_GRUPOTEL(an_codnumtel => ' ||
                              an_codnumtel || ', an_codcab => ' ||
                              an_codcab || ') ' || SQLERRM);
  END;
  /* **********************************************************************************************/
  FUNCTION f_obtiene_hunting(an_codnumtel IN NUMBER) RETURN NUMBER IS
    ln_codcab NUMBER;
  BEGIN
    -- OBTENER CODIGO HUNTING
    SELECT NVL(MAX(h.codcab), 0)
      INTO ln_codcab
      FROM hunting h, grupotel g, numxgrupotel n
     WHERE h.codnumtel = an_codnumtel
       AND g.codcab = h.codcab
       AND g.codnumtel = h.codnumtel
       AND n.codcab = g.codcab
       AND n.codnumtel = g.codnumtel
       AND n.codgrupo = g.codgrupo
       AND n.estado = 1;
    RETURN ln_codcab;
  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$PLSQL_UNIT ||
                              '.F_OBTIENE_HUNTING(an_codnumtel => ' ||
                              an_codnumtel || ') ' || SQLERRM);
  END;
  /* **********************************************************************************************/
  FUNCTION f_obtiene_numslc(an_codsolot IN solot.codsolot%TYPE)
    RETURN vtatabslcfac.numslc%TYPE IS
    lv_numslc vtatabslcfac.numslc%TYPE;
  BEGIN
    -- OBTENER NUMERO DE PROYECTO
    SELECT numslc INTO lv_numslc FROM solot WHERE codsolot = an_codsolot;
    RETURN lv_numslc;
  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$PLSQL_UNIT ||
                              '.F_OBTIENE_NUMSLC(an_codsolot => ' ||
                              an_codsolot || ') ' || SQLERRM);
  END;
  /* **********************************************************************************************/
  FUNCTION f_obtiene_sid_numero(an_codinssrv IN inssrv.codinssrv%TYPE)
    RETURN numtel.numero%TYPE IS
    lv_numero numtel.numero%TYPE;
  BEGIN
    -- OBTENER NUMERO DE INSTANCIA DE SERVICIO
    SELECT numero
      INTO lv_numero
      FROM inssrv
     WHERE codinssrv = an_codinssrv;
    RETURN lv_numero;
  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$PLSQL_UNIT ||
                              '.F_OBTIENE_SID_NUMERO(an_codinssrv => ' ||
                              an_codinssrv || ') ' || SQLERRM);
  END;
  /* **********************************************************************************************/
  FUNCTION f_obtiene_sot(an_idwf IN NUMBER) RETURN solot.codsolot%TYPE IS
    ln_codsolot solot.codsolot%TYPE;
  BEGIN
    -- OBTENER SOT DE CAMBIO PLAN
    SELECT codsolot INTO ln_codsolot FROM wf WHERE idwf = an_idwf;
  
    RETURN ln_codsolot;
  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$PLSQL_UNIT || '.F_OBTIENE_SOT(an_idwf => ' ||
                              an_idwf || ') ' || SQLERRM);
  END;
  /* **********************************************************************************************/
  FUNCTION f_obtiene_valor_lista(av_lista  VARCHAR2,
                                 an_indice NUMBER,
                                 ac_delim  VARCHAR2) RETURN VARCHAR2 IS
    lv_valor  VARCHAR2(100);
    start_pos NUMBER;
    end_pos   NUMBER;
    delim     VARCHAR2(10);
  BEGIN
    delim := ac_delim;
  
    IF an_indice = 1 THEN
      start_pos := 1;
    ELSE
      start_pos := instr(av_lista, delim, 1, an_indice - 1);
      IF start_pos = 0 THEN
        lv_valor := NULL;
        RETURN lv_valor;
      ELSE
        start_pos := start_pos + length(delim);
      END IF;
    END IF;
  
    end_pos := instr(av_lista, delim, start_pos, 1);
  
    IF end_pos = 0 THEN
      lv_valor := substr(av_lista, start_pos);
      RETURN lv_valor;
    ELSE
      lv_valor := substr(av_lista, start_pos, end_pos - start_pos);
      RETURN lv_valor;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      lv_valor := NULL;
      RETURN lv_valor;
  END;
  /* **********************************************************************************************/
  FUNCTION f_obtiene_zona_aut RETURN NUMBER IS
    ln_codzona NUMBER;
  BEGIN
    -- OBTENER ZONA 3PLAY AUTOMATICO
    SELECT to_number(valor)
      INTO ln_codzona
      FROM constante
     WHERE TRIM(constante) = 'ZONA3PLAY_AUT';
    RETURN ln_codzona;
  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$PLSQL_UNIT || '.F_OBTIENE_ZONA_AUT() ' ||
                              SQLERRM);
  END;
END;
/