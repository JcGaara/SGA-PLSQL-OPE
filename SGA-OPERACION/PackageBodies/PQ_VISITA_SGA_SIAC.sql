CREATE OR REPLACE PACKAGE BODY OPERACION.PQ_VISITA_SGA_SIAC IS
   /***********************************************************************************************
   Paquete    :    PQ_VISITA_SGA_SIAC
   Descripcion:    agrupar las funciones que determinan la visita, anotacion y subOrden
   Ver        Date        Author              Solicitado por       Descripcion
   1.0      18/09/2018  Obed Ortiz            Juan Cuya            PROY-32581-TOA Nueva regla de validacion de flag de visita
   2.0      25/10/2018  Proyecto TOA          Juan Cuya            PROY-32581_SGA12
   3.0      14/11/2018  Marleny Teque         Luis FLores          PROY-32581_SGA12
   4.0      22/11/2018  Luis FLores           Luis FLores          PROY-32581_SGA14
   5.0      16/01/2019  Abel Ojeda            Luis FLores          PROY-32581_SGA20
   6.0      22/01/2019  Abel Ojeda            Luis FLores          PROY-32581_SGA21
   7.0      09/04/2019  Luis Flores           Luis FLores          INC000001416203
   ---------  ----------  ------------------- ----------------   ------------------------------------
   ***********************************************************************************************/

  function SGAFUN_obt_codequcom(av_tipequ varchar2) return varchar2 is
    lv_return varchar2(4);
  begin
    select distinct lp.codequcom
      into lv_return
      from usrpvu.sisact_ap_material@dbl_pvudb sam,
           sales.equipo_sisact                 es,
           sales.linea_paquete                 lp
     where sam.tipequ = av_tipequ
       and sam.tipequ = es.tipequ
       and es.idlinea = lp.idlinea
     and rownum < 2;

    return lv_return;
  exception
    when others then
      return null;
  end;

  FUNCTION SGAFUN_val_cfg_val(av_param varchar2) RETURN NUMBER IS
    ln_return NUMBER;
  BEGIN
    select o.codigon
      into ln_return
      from operacion.opedd o
     where o.tipopedd =
           (select tipopedd from operacion.tipopedd where abrev = 'CVE_CP')
       and o.abreviacion = av_param;

    RETURN ln_return;
  exception
    when others then
      RETURN 0;
  END;

  --Ini 2.0
  function SGAFUN_val_cfg_codequcom(av_codequcom_new varchar2,
                                    av_codequcom_old varchar2) return number is
    ln_return number;
  begin
    select cec.flag_aplica
      into ln_return
      from operacion.config_equcom_cp cec
     where cec.codequcom_new = av_codequcom_new
       and cec.codequcom_old = av_codequcom_old;

    return ln_return;
  exception
    when no_data_found then
      return 1;
    when others then
      return 1;
  end;
  --Fin 2.0
  FUNCTION SGAFUN_val_tipsrv_old(an_codsolot operacion.solot.codsolot%TYPE,
                                 av_tipsrv   tystipsrv.tipsrv%TYPE) RETURN NUMBER IS
    ln_return NUMBER;
  BEGIN
    SELECT COUNT(DISTINCT i.tipsrv)
      INTO ln_return
      FROM solot s, solotpto pto, inssrv i, insprd p, tystabsrv t
     WHERE s.codsolot = pto.codsolot
       AND pto.codinssrv = i.codinssrv
       AND i.codinssrv = p.codinssrv
       AND p.codsrv = t.codsrv
       AND s.codsolot = an_codsolot
       AND i.tipsrv = av_tipsrv;

    RETURN ln_return;
  exception
    when others then
      RETURN 0;
  END;

  FUNCTION SGAFUN_val_tipsrv_new(av_cod_id operacion.sga_visita_tecnica_siac.co_id%TYPE,
                            av_tipsrv sales.tystabsrv.tipsrv%type)
    RETURN NUMBER IS
    ln_return NUMBER;
  BEGIN

    SELECT COUNT(DISTINCT t.tipsrv)
      INTO ln_return
      FROM sales.servicio_sisact s,
           tystabsrv t,
           (select o.codigon, o.codigon_aux
              from tipopedd t, opedd o
             where t.tipopedd = o.tipopedd
               and t.abrev = 'IDPRODUCTOCONTINGENCIA') xx,
           operacion.sga_visita_tecnica_siac ser
     WHERE s.codsrv = t.codsrv
       and xx.codigon = t.idproducto
       AND s.idservicio_sisact = TRIM(ser.cod_serv_sisact)
       and ser.co_id = av_cod_id
       AND t.tipsrv = av_tipsrv;

    RETURN ln_return;
  exception
    when others then
      RETURN 0;
  END;

  FUNCTION SGAFUN_count_rows(p_string VARCHAR2) RETURN NUMBER IS
    l_count  NUMBER := 0;
    l_value  VARCHAR2(1);
    l_length NUMBER;

  BEGIN
    l_length := length(p_string);
    FOR idx IN 1 .. l_length LOOP
      l_value := substr(p_string, idx, 1);
      IF l_value = ';' THEN
        l_count := l_count + 1;
      END IF;
    END LOOP;

    RETURN l_count + 1;

  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$PLSQL_UNIT ||
                              '.SGAFUN_count_rows(p_string => trama) ' || SQLERRM);
  END;

  FUNCTION SGAFUN_divide_cadena(p_cadena IN OUT VARCHAR2) RETURN VARCHAR2 IS

    v_longitud INTEGER;
    v_valor    VARCHAR2(100);

  BEGIN

    SELECT decode(instr(p_cadena, '|', 1, 1),
                  0,
                  length(p_cadena),
                  instr(p_cadena, '|', 1, 1) - 1)
      INTO v_longitud
      FROM dual;

    SELECT substr(p_cadena, 1, v_longitud),
           substr(p_cadena, v_longitud + 2)
      INTO v_valor, p_cadena
      FROM dual;

    RETURN v_valor;
  END;

  function SGAFUN_get_codmotot_visit(av_tipo varchar2, av_visita varchar2)
    return number is

    ln_codmotot number;

  begin

    SELECT o.codigon
      INTO ln_codmotot
      FROM operacion.opedd o, tipopedd t
     WHERE o.tipopedd = t.tipopedd
       AND t.abrev = 'TIPO_MOT_HFC_LTE_VIS'
       AND o.codigoc = av_tipo
       AND o.abreviacion = av_visita;

    return ln_codmotot;
  exception
    when others then
      return null;
  end;

  procedure SGASI_log_post_siac(an_cod_id      operacion.postventasiac_log.co_id%type,
                                       an_customer_id operacion.postventasiac_log.customer_id%type,
                                       av_proceso     operacion.postventasiac_log.proceso%type,
                                       av_msgerror    operacion.postventasiac_log.msgerror%type) is
    pragma autonomous_transaction;
  begin
    insert into operacion.postventasiac_log
      (co_id, customer_id, proceso, msgerror)
    values
      (an_cod_id, an_customer_id, av_proceso, av_msgerror);
    commit;
  exception
    when others then
      rollback;
  end;

  FUNCTION sgafun_val_cantequ(an_codsolot operacion.solot.codsolot%TYPE,
                              av_tipsrv   tystipsrv.tipsrv%TYPE)
    RETURN NUMBER IS
    ln_count NUMBER;
  BEGIN
    --cantidad decos SGA
    SELECT sum(x.cantidad)
      INTO ln_count
      FROM (SELECT distinct ip.pid, ip.codequcom, ip.cantidad
              FROM solot s, solotpto sp, insprd ip, inssrv iv, vtaequcom vt
             WHERE s.codsolot = sp.codsolot
               AND sp.codinssrv = iv.codinssrv
               AND ip.codinssrv = iv.codinssrv
               AND vt.codequcom = ip.codequcom
               and vt.tip_eq not in
                   (select codigoc
                      from operacion.opedd o
                     where o.tipopedd =
                           (select tipopedd
                              from operacion.tipopedd
                             where abrev = 'CVE_CP')
                       and abreviacion = 'NO_EQU') --7.0
               AND s.codsolot = an_codsolot
               AND iv.tipsrv IN (av_tipsrv)
               AND ip.estinsprd IN (1, 2)) X
     WHERE nvl(X.codequcom, 'X') != 'X';
  
    RETURN ln_count;
  
  EXCEPTION
    WHEN OTHERS THEN
      RETURN 0;
  END;

  FUNCTION sgafun_val_cantequ_new(av_cod_id operacion.sga_visita_tecnica_siac.co_id%type)
    RETURN NUMBER IS
    ln_count NUMBER;
  BEGIN
    select sum(v.cantidad_equ)
      INTO ln_count
      from operacion.sga_visita_tecnica_siac   v,
           USRPVU.SISACT_AP_MATERIAL@DBL_PVUDB mat
     where mat.matv_codigo = v.idequipo
       and v.co_id = av_cod_id
       and V.TIPO_SRV = 'CTV';

    RETURN ln_count;

  EXCEPTION
    WHEN OTHERS THEN
      RETURN 0;
  END;

  function sgafun_val_recuperable(an_codsolot operacion.solot.codsolot%type,
                                  av_tipsrv   tystipsrv.tipsrv%type)
    return number is

    ln_val_recuperable number;

    cursor c_equ_sga is
      select distinct eq.tip_eq, eq.flg_recuperable
        from (select distinct ip.pid, ip.codequcom, ip.cantidad
                from solot s, solotpto sp, insprd ip, inssrv iv
               where s.codsolot = sp.codsolot
                 and sp.codinssrv = iv.codinssrv
                 and ip.codinssrv = iv.codinssrv
                 and s.codsolot = an_codsolot
                 and iv.tipsrv = av_tipsrv
                 and ip.estinsprd IN (1, 2)) X,
             vtaequcom eq
       where nvl(x.codequcom, 'X') != 'X'
         and eq.codequcom = x.codequcom;
  begin

    ln_val_recuperable := 0;

    for r in c_equ_sga loop
      if r.flg_recuperable = 'SI' then
        ln_val_recuperable := ln_val_recuperable + 1;
      end if;
    end loop;

    if ln_val_recuperable > 0 then
      return 1;
    else
      return 0;
    end if;
  end;

  FUNCTION sgafun_val_tipdeco(an_codsolot operacion.solot.codsolot%TYPE,
                              av_cod_id   operacion.sga_visita_tecnica_siac.co_id%type)
    RETURN NUMBER IS
    lv_val_tipequ NUMBER;
    --Ini 2.0
    lv_val_cfg number;

    CURSOR C_EQU_SGA_CP IS
      SELECT eq.tip_eq, eq.codequcom, sum(x.cantidad) cantidad
        FROM (SELECT distinct ip.pid, IP.codequcom, ip.cantidad
                FROM solot s, solotpto sp, insprd ip, inssrv iv
               WHERE s.codsolot = sp.codsolot
                 AND sp.codinssrv = iv.codinssrv
                 AND ip.codinssrv = iv.codinssrv
                 AND s.codsolot = an_codsolot
                 AND iv.tipsrv IN ('0062')
                 AND ip.estinsprd IN (1, 2)) X,
             vtaequcom eq,
             EQUCOMXOPE v,
             TIPEQU TE
       WHERE nvl(X.codequcom, 'X') != 'X'
         AND X.CODEQUCOM = eq.CODEQUCOM
         AND eq.CODEQUCOM = v.CODEQUCOM
         AND v.CODTIPEQU = TE.CODTIPEQU
         and TE.TIPO = 'DECODIFICADOR'
       group by eq.tip_eq, eq.codequcom;

    cursor c_equ_pvu_cp is
      select x.tip_eq, x.codequcom_new, sum(x.cantidad) cantidad
        from (select t.tip_eq,
                     operacion.pq_visita_sga_siac.SGAFUN_obt_codequcom(o.tipequ) codequcom_new,
                     o.cantidad_equ cantidad
                from operacion.sga_visita_tecnica_siac o, vtaequcom t
               where t.codequcom =
                     operacion.pq_visita_sga_siac.SGAFUN_obt_codequcom(o.tipequ)
                 and o.co_id = av_cod_id
                 and o.tipo_srv = 'CTV') x
       group by x.tip_eq, x.codequcom_new;

    --Fin 2.0
    CURSOR C_EQU_SGA IS
      SELECT eq.tip_eq, sum(x.cantidad) cantidad
        FROM (SELECT distinct ip.pid, IP.codequcom, ip.cantidad
                FROM solot s, solotpto sp, insprd ip, inssrv iv
               WHERE s.codsolot = sp.codsolot
                 AND sp.codinssrv = iv.codinssrv
                 AND ip.codinssrv = iv.codinssrv
                 AND s.codsolot = an_codsolot
                 AND iv.tipsrv IN ('0062')
                 AND ip.estinsprd IN (1, 2)) X,
             vtaequcom eq,
             EQUCOMXOPE V,
             TIPEQU TE
       WHERE nvl(X.codequcom, 'X') != 'X'
         and eq.codequcom = x.codequcom
         AND eq.CODEQUCOM = V.CODEQUCOM
         AND V.CODTIPEQU = TE.CODTIPEQU
         and TE.TIPO = 'DECODIFICADOR'
       group by eq.tip_eq
       order by eq.tip_eq desc;

    cursor c_equ_pvu is
      select t.tip_eq, sum(o.cantidad_equ) cantidad
        from operacion.sga_visita_tecnica_siac o, vtaequcom t
       where t.codequcom =
             operacion.pq_visita_sga_siac.SGAFUN_obt_codequcom(o.tipequ)
         and o.co_id = av_cod_id
         and o.tipo_srv = 'CTV'
       group by t.tip_eq
       order by t.tip_eq desc;

    ln_cont_equ_old number;
    ln_cont_equ_new number;
    AV_ERROR        operacion.postventasiac_log.msgerror%type;

  BEGIN
    ln_cont_equ_old := 0;
    --Ini 2.0
    lv_val_cfg := operacion.pq_visita_sga_siac.SGAFUN_val_cfg_val('CVEC_CTV');

    if lv_val_cfg = 1 then
      FOR xx IN C_EQU_SGA_CP LOOP
        ln_cont_equ_old := ln_cont_equ_old + xx.cantidad;

        ln_cont_equ_new := 0;

        for c in c_equ_pvu_cp loop
          ln_cont_equ_new := ln_cont_equ_new + c.cantidad;

          IF xx.tip_eq = c.tip_eq THEN
            IF xx.cantidad = c.cantidad THEN

              if operacion.pq_visita_sga_siac.SGAFUN_val_cfg_codequcom(c.codequcom_new,
                                                                       xx.codequcom) = 1 then
                lv_val_tipequ := 1;
              else
                lv_val_tipequ := 0;
              end if;

            else
              lv_val_tipequ := 1;
            END IF;
          END IF;

        end loop;

      END LOOP;

      if ln_cont_equ_new = ln_cont_equ_old and lv_val_tipequ = 0 then
        RETURN 0;
      else
        RETURN 1;
      end if;

    else
      --Fin 2.0
      FOR x IN C_EQU_SGA LOOP
        ln_cont_equ_old := ln_cont_equ_old + x.cantidad;

        ln_cont_equ_new := 0;

        for c in c_equ_pvu loop

          ln_cont_equ_new := ln_cont_equ_new + c.cantidad;

          IF x.tip_eq = c.tip_eq THEN
            IF x.cantidad = c.cantidad THEN
              lv_val_tipequ := 0;
            else
              lv_val_tipequ := 1;
            END IF;
          END IF;
        end loop;
      END LOOP;

      if ln_cont_equ_new = ln_cont_equ_old and lv_val_tipequ = 0 then
        return 0;
      else
        return 1;
      end if;
    end if; --2.0

  EXCEPTION
    WHEN OTHERS THEN
      AV_ERROR := 'ERROR : ' || sqlerrm ||
                  'Ocurrio un error al validar los Tipos de Decos: Linea (' ||
                  DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ')';
      OPERACION.PQ_VISITA_SGA_SIAC.SGASI_log_post_siac(av_cod_id,
                                                       0,
                                                       'SGASS_ORDEN_VISITA',
                                                       AV_ERROR);

      RETURN 1;
  END;

  PROCEDURE SGASS_GET_VAL_INTERNET_EQ(AN_CODSOLOT   OPERACION.SOLOT.CODSOLOT%TYPE,
                                      AV_CODSRV_PVU VARCHAR2,
                                      AV_IDEQUIPO   VARCHAR2,
                                      AN_CO_ID      NUMBER,
                                      AN_FLAG       OUT NUMBER,
                                      AN_ERROR      OUT NUMBER,
                                      AV_ERROR      OUT VARCHAR2) IS

    LN_TIPO_MAT     VARCHAR2(50);
    LN_VELOCIDAD    NUMBER;
    LN_TIPO_MAT_ANT SALES.VTAEQUCOM.TIP_EQ%TYPE;
    LV_VEL_CONF     NUMBER;
    EXC_INTERNET      EXCEPTION;
    EXC_CODEQUCOM_NEW EXCEPTION;
    lv_val_cfg       number; --2.0
    LV_CODEQUCOM     SALES.VTAEQUCOM.CODEQUCOM%TYPE;
    LV_CODEQUCOM_NEW SALES.VTAEQUCOM.CODEQUCOM%TYPE;
    LV_TIPEQU        OPERACION.TIPEQU.TIPEQU%TYPE;
    EXC_VEL_ACT EXCEPTION; --1.0
    EXC_VEL_NEW EXCEPTION; --1.0
    LN_VELOCIDAD_ACT NUMBER; --1.0
    LN_CONVERT_MB_KB NUMBER; --1.0
    EXC_CONVERT_MB EXCEPTION; --1.0
  BEGIN

    LV_VEL_CONF := OPERACION.PQ_SGA_JANUS.F_GET_CONSTANTE_CONF('CVELINT_VISITEC');
    --Ini 2.0
    lv_val_cfg := OPERACION.PQ_VISITA_SGA_SIAC.SGAFUN_val_cfg_val('CVEC_INT');
    AN_ERROR   := 0;
    AV_ERROR   := 'OK';

    if lv_val_cfg = 1 then
      BEGIN
        --Ini 1.0
        select distinct a.banwid
        into ln_velocidad_act
        from inssrv i, tystabsrv a, insprd ip
       where a.codsrv = ip.codsrv
         and i.codinssrv = ip.codinssrv
         and i.codinssrv in (select distinct s.codinssrv
                               from solotpto s
                              where s.codsolot = an_codsolot)
         and ip.flgprinc = 1
         and a.tipsrv = '0006'
         and ip.estinsprd in (1, 2);

      EXCEPTION
        WHEN OTHERS THEN
          RAISE EXC_VEL_ACT;
      END;

      BEGIN
        select distinct ser.banwid
           into ln_velocidad
           from sales.servicio_sisact ss, tystabsrv ser
          where ss.codsrv = ser.codsrv
            and ss.idservicio_sisact = av_codsrv_pvu;
      EXCEPTION
        WHEN OTHERS THEN
          RAISE EXC_VEL_NEW;
      END;

      IF LN_VELOCIDAD <= LN_VELOCIDAD_ACT THEN
        AN_FLAG := 0;
        return;
        --Fin 1.0
      ELSE
        BEGIN
          SELECT DISTINCT V.CODEQUCOM
            INTO LV_CODEQUCOM
            FROM (SELECT DISTINCT IP.PID, IP.CODEQUCOM, IP.CANTIDAD
                    FROM SOLOT S, SOLOTPTO SP, INSPRD IP, INSSRV IV
                   WHERE S.CODSOLOT = SP.CODSOLOT
                     AND SP.CODINSSRV = IV.CODINSSRV
                     AND IP.CODINSSRV = IV.CODINSSRV
                     AND S.CODSOLOT = AN_CODSOLOT) X,
                 VTAEQUCOM V,
                 EQUCOMXOPE EQ,
                 TIPEQU TE
           WHERE NVL(X.CODEQUCOM, 'X') != 'X'
             AND X.CODEQUCOM = V.CODEQUCOM
             AND V.CODEQUCOM = EQ.CODEQUCOM
             AND EQ.CODTIPEQU = TE.CODTIPEQU
             AND TE.TIPO IN ('EMTA', 'CPE')
             AND V.TIP_EQ IS NOT NULL;
        EXCEPTION
          WHEN OTHERS THEN
            RAISE EXC_INTERNET;
        END;

        BEGIN
          SELECT S.TIPEQU
            INTO LV_TIPEQU
            FROM OPERACION.SGA_VISITA_TECNICA_SIAC S
           WHERE S.CO_ID = AN_CO_ID
             AND S.IDEQUIPO = AV_IDEQUIPO
             AND S.TIPO_SRV = 'INT';
        EXCEPTION
          WHEN OTHERS THEN
            RAISE EXC_CODEQUCOM_NEW;
        END;

        LV_CODEQUCOM_NEW := OPERACION.PQ_VISITA_SGA_SIAC.SGAFUN_OBT_CODEQUCOM(LV_TIPEQU);

        IF LV_CODEQUCOM_NEW = LV_CODEQUCOM THEN
          -- Si son iguales
          AN_FLAG := 0;
          return;
        END IF;

        IF OPERACION.PQ_VISITA_SGA_SIAC.SGAFUN_val_cfg_codequcom(LV_CODEQUCOM_NEW, LV_CODEQUCOM) = 1 THEN
          AN_FLAG := 1;
          return;
        ELSE
          AN_FLAG := 0;
          return;
        END IF;
      END IF;
    else
      --Fin 2.0
      BEGIN
        SELECT DISTINCT V.TIP_EQ
          INTO LN_TIPO_MAT_ANT
          FROM (SELECT DISTINCT IP.PID, IP.CODEQUCOM, IP.CANTIDAD
                  FROM SOLOT S, SOLOTPTO SP, INSPRD IP, INSSRV IV
                 WHERE S.CODSOLOT = SP.CODSOLOT
                   AND SP.CODINSSRV = IV.CODINSSRV
                   AND IP.CODINSSRV = IV.CODINSSRV
                   AND S.CODSOLOT = AN_CODSOLOT) X,
               VTAEQUCOM V,
               EQUCOMXOPE EQ,
               TIPEQU TE
         WHERE NVL(X.CODEQUCOM, 'X') != 'X'
           AND X.CODEQUCOM = V.CODEQUCOM
           AND V.CODEQUCOM = EQ.CODEQUCOM
           AND EQ.CODTIPEQU = TE.CODTIPEQU
           AND TE.TIPO IN ('EMTA', 'CPE')
           AND V.TIP_EQ IS NOT NULL;
      EXCEPTION
        WHEN OTHERS THEN
          RAISE EXC_INTERNET;
      END;

      SELECT MAT.MATV_TIPO_MATERIAL
        INTO LN_TIPO_MAT
        FROM USRPVU.SISACT_AP_MATERIAL@DBL_PVUDB MAT
       WHERE MAT.MATV_CODIGO = AV_IDEQUIPO;

     select distinct ser.banwid
           into ln_velocidad
           from sales.servicio_sisact ss, tystabsrv ser
          where ss.codsrv = ser.codsrv
            and ss.idservicio_sisact = av_codsrv_pvu;

      --3.0 Ini
      LN_CONVERT_MB_KB := SGAFUN_CONVERT_MB_KB('CON_MB_KB');

      IF LN_CONVERT_MB_KB = 0 OR LN_CONVERT_MB_KB IS NULL THEN
          RAISE EXC_CONVERT_MB;
      END IF;
      --3.0 Fin

      LN_VELOCIDAD := LN_VELOCIDAD / LN_CONVERT_MB_KB;

      IF LN_TIPO_MAT_ANT <> LN_TIPO_MAT THEN
        AN_FLAG := 1;
        return;
      END IF;

      IF LN_TIPO_MAT_ANT <> 'DOCSIS3' AND LN_VELOCIDAD >= LV_VEL_CONF THEN
        AN_FLAG := 1;
        return;
      ELSE
        AN_FLAG := 0;
        return;
      END IF;
    End if; --2.0
  EXCEPTION
    WHEN EXC_CODEQUCOM_NEW THEN
      AN_FLAG  := -1;
      AN_ERROR := -1;
      AV_ERROR := 'No se encuentra el equipo de Internet para el contrato ' ||
                  AN_CO_ID;
    WHEN EXC_INTERNET THEN
      AN_FLAG  := -1;
      AN_ERROR := -1;
      AV_ERROR := 'La SOT ' || AN_CODSOLOT ||
                  ' del cliente no tiene equipos de Internet';
    WHEN EXC_VEL_NEW THEN
      AN_FLAG  := -1;
      AN_ERROR := -1;
      AV_ERROR := 'El servicio ' || AV_CODSRV_PVU ||
                  ' no esta correctamente configurado en PVUDB';
    WHEN EXC_VEL_ACT THEN
      AN_FLAG  := -1;
      AN_ERROR := -1;
      AV_ERROR := 'La SOT ' || AN_CODSOLOT ||
                  ' no tiene servicio de Internet Activo/Suspendido';
    WHEN EXC_CONVERT_MB THEN
      AN_FLAG  := -1;
      AN_ERROR := -1;
      AV_ERROR := 'No esta configurado el Valor de conversión de Velocidad de INTERNET';
    WHEN OTHERS THEN
      AN_FLAG  := -1;
      AN_ERROR := -1;
      AV_ERROR := 'Ocurrio un error al validar la velocidad y tipo de equipos para servicio de INTERNET :: Linea (' ||
                  DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ')';
  END;
  -- Anotaciones
  FUNCTION SGAFUN_GET_NOMBRE_EQU(AV_CODEQUCOOM VTAEQUCOM.CODEQUCOM%TYPE)
    RETURN VTAEQUCOM.DSCEQU%TYPE IS
    LV_DESCEQU VTAEQUCOM.DSCEQU%TYPE;
  BEGIN
    SELECT V.DSCEQU
      INTO LV_DESCEQU
      FROM VTAEQUCOM V
     WHERE V.CODEQUCOM = AV_CODEQUCOOM;
    RETURN LV_DESCEQU;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN NULL;
  END;

  FUNCTION SGAFUN_FORMAT_VACIO(LV_CAD VARCHAR2)
    RETURN VARCHAR2 IS
  BEGIN
    IF LENGTH(LV_CAD)>0 THEN
      RETURN LV_CAD || ' + ' ;
    ELSE
      RETURN LV_CAD;
    END IF;
  END ;

  FUNCTION SGAFUN_GET_CODEQU_OLD (AN_CODSOLOT OPERACION.SOLOT.CODSOLOT%TYPE)
     RETURN VARCHAR2 IS
     LV_CODEQUCOM_OLD VTAEQUCOM.CODEQUCOM%TYPE;
   BEGIN
        SELECT DISTINCT V.CODEQUCOM INTO LV_CODEQUCOM_OLD
          FROM (SELECT DISTINCT IP.PID, IP.CODEQUCOM, IP.CANTIDAD
                  FROM SOLOT S, SOLOTPTO SP, INSPRD IP, INSSRV IV
                 WHERE S.CODSOLOT = SP.CODSOLOT
                   AND SP.CODINSSRV = IV.CODINSSRV
                   AND IP.CODINSSRV = IV.CODINSSRV
                   AND S.CODSOLOT = AN_CODSOLOT) X,
               VTAEQUCOM V,
               EQUCOMXOPE EQ,
               TIPEQU TE
         WHERE NVL(X.CODEQUCOM, 'X') != 'X'
           AND X.CODEQUCOM = V.CODEQUCOM
           AND V.CODEQUCOM = EQ.CODEQUCOM
           AND EQ.CODTIPEQU = TE.CODTIPEQU
           AND TE.TIPO IN ('EMTA', 'CPE')
           AND V.TIP_EQ IS NOT NULL;

           RETURN LV_CODEQUCOM_OLD;
   EXCEPTION
      WHEN OTHERS THEN
        RETURN NULL;
   END;

   FUNCTION SGAFUN_GET_CODEQU_NEW (av_cod_id OPERACION.SOLOT.COD_ID%TYPE)
     RETURN VARCHAR2 IS
   LV_TIPEQU        OPERACION.TIPEQU.TIPEQU%TYPE;
   BEGIN
      SELECT S.TIPEQU INTO LV_TIPEQU
        FROM OPERACION.SGA_VISITA_TECNICA_SIAC S, TIPEQU T
       WHERE S.CO_ID = av_cod_id
         AND S.TIPEQU = T.TIPEQU
         AND S.TIPO_SRV = 'INT'
         AND T.TIPO != 'SMART CARD';

        RETURN SGAFUN_OBT_CODEQUCOM(NVL(TO_CHAR(LV_TIPEQU),'X')); --6.0

   EXCEPTION
     WHEN OTHERS THEN
       RETURN NULL;
   END;

  function SGAFUN_INICIA_VALORES (AN_CODSOLOT   in OPERACION.SOLOT.CODSOLOT%TYPE,
                                  AV_COD_ID     in OPERACION.SGA_VISITA_TECNICA_SIAC.CO_ID%TYPE)
                                  RETURN  VALORES_SRV IS
  servicios_Val VALORES_SRV;
  BEGIN
    servicios_Val.ln_val_ctv_old := SGAFUN_val_tipsrv_old(AN_CODSOLOT, CV_CABLE); -- CTV;
    servicios_Val.LN_VAL_INT_OLD := SGAFUN_val_tipsrv_old(AN_CODSOLOT, CV_INTERNET); -- INT;
    servicios_Val.LN_VAL_TLF_OLD := SGAFUN_val_tipsrv_old(AN_CODSOLOT, CV_TELEFONIA); -- TLF;

    servicios_Val.LN_VAL_CTV_NEW := SGAFUN_val_tipsrv_new(AV_COD_ID, CV_CABLE); -- CTV;
    servicios_Val.LN_VAL_INT_NEW := SGAFUN_val_tipsrv_new(AV_COD_ID, CV_INTERNET); -- INT;
    servicios_Val.LN_VAL_TLF_NEW := SGAFUN_val_tipsrv_new(AV_COD_ID, CV_TELEFONIA); -- TLF;
  --ini v2.0
    servicios_Val.ln_des_ctv_old := SGAFUN_des_tipsrv_old(AN_CODSOLOT, CV_CABLE); -- CTV;
    servicios_Val.LN_DES_INT_OLD := SGAFUN_des_tipsrv_old(AN_CODSOLOT, CV_INTERNET); -- INT;
    servicios_Val.LN_DES_TLF_OLD := SGAFUN_des_tipsrv_old(AN_CODSOLOT, CV_TELEFONIA); -- TLF;

    servicios_Val.LN_DES_CTV_NEW := SGAFUN_des_tipsrv_new(AV_COD_ID, CV_CABLE); -- CTV;
    servicios_Val.LN_DES_INT_NEW := SGAFUN_des_tipsrv_new(AV_COD_ID, CV_INTERNET); -- INT;
    servicios_Val.LN_DES_TLF_NEW := SGAFUN_des_tipsrv_new(AV_COD_ID, CV_TELEFONIA); -- TLF;
  --fin v2.0
  return  servicios_Val ;
  END;

  FUNCTION SGAFUN_GET_INST_DESIN(AN_CODSOLOT OPERACION.SOLOT.CODSOLOT%TYPE,
                                 AV_COD_ID   OPERACION.SGA_VISITA_TECNICA_SIAC.CO_ID%TYPE)
    RETURN VARCHAR2 IS
    --ini v2.0
    ln_val_vel_int number;
    an_error       number;
    av_error       varchar2(4000);  --4.0
    error_general EXCEPTION;
    --fin v2.0
    --INI 2.0
    CURSOR C_EQU_SGA_CP IS
      SELECT eq.tip_eq, sum(x.cantidad) cantidad
        FROM (SELECT distinct ip.pid, IP.codequcom, ip.cantidad
                FROM solot s, solotpto sp, insprd ip, inssrv iv
               WHERE s.codsolot = sp.codsolot
                 AND sp.codinssrv = iv.codinssrv
                 AND ip.codinssrv = iv.codinssrv
                 AND s.codsolot = an_codsolot
                 AND iv.tipsrv IN ('0062')
                 AND ip.estinsprd IN (1, 2)) X,
             vtaequcom eq,
             EQUCOMXOPE v,
             TIPEQU TE
       WHERE nvl(X.codequcom, 'X') != 'X'
         AND X.CODEQUCOM = eq.CODEQUCOM
         AND eq.CODEQUCOM = v.CODEQUCOM
         AND v.CODTIPEQU = TE.CODTIPEQU
         and TE.TIPO = 'DECODIFICADOR'
       group by eq.tip_eq
       order by eq.tip_eq;

    CURSOR C_EQU_PVU IS
    --4.0 Ini
      select x.tip_eq TIP_EQ_NEW, sum(x.cantidad) cantidad
        from (select t.tip_eq,
                     operacion.pq_visita_sga_siac.SGAFUN_obt_codequcom(o.tipequ) codequcom_new,
                     o.cantidad_equ cantidad
                from operacion.sga_visita_tecnica_siac o, vtaequcom t
               where t.codequcom =
                     operacion.pq_visita_sga_siac.SGAFUN_obt_codequcom(o.tipequ)
                 and o.co_id = AV_COD_ID
                 and o.tipo_srv = 'CTV') x
       group by x.tip_eq;
    --4.0 Fin

    --ini v2.0
    cursor c_serv_v is
      select v.cod_serv_sisact, v.idequipo, v.cantidad_equ
        from operacion.sga_visita_tecnica_siac v
       where v.co_id = AV_COD_ID
         and v.tipo_srv = 'INT';
    --fin v2.0
    LV_CODEQUCOM_OLD VTAEQUCOM.CODEQUCOM%TYPE;
    LV_CODEQUCOM_NEW VTAEQUCOM.CODEQUCOM%TYPE;
    EXC_INTERNET      EXCEPTION;
    EXC_CODEQUCOM_NEW EXCEPTION;
    LV_INSTALAR    VARCHAR2(4000);
    LV_DESINSTALAR VARCHAR2(4000);
    LV_CADENA      VARCHAR2(4000);
    L_CADENA       VARCHAR(4000);  --4.0
    L_CADENA2      VARCHAR(4000);  --4.0
    FLG_IGUAL      NUMBER;
    LN_SERVICIOS VALORES_SRV;
    -- ini v2.0
    LV_UPGRADE       VARCHAR2(4000);
    LV_DOWNGRADE     VARCHAR2(4000);
    LV_SERVICIOS     VARCHAR2(4000);
    LV_UPGRADE_CAD   VARCHAR2(4000);
    LV_DOWNGRADE_CAD VARCHAR2(4000);
    -- fin v2.0
    ln_flag_visit_tec NUMBER;  --4.0
    ln_val_contrato_hfc NUMBER; --6.0
  BEGIN
    -- EVALUO LOS EQUIPOS
    LN_SERVICIOS := SGAFUN_INICIA_VALORES(AN_CODSOLOT, AV_COD_ID);

    --Ini 6.0
    --Se valida si es HFC
    SELECT COUNT(1)
    INTO ln_val_contrato_hfc
    FROM contract_all@dbl_bscs_bf cc
    WHERE cc.co_id = AV_COD_ID
    AND cc.sccode = 6;
    --Fin 6.0

    -- Evaluo Internet
    if LN_SERVICIOS.LN_VAL_INT_NEW > 0 and LN_SERVICIOS.LN_VAL_INT_OLD = 0
      and LN_SERVICIOS.LN_VAL_TLF_OLD = 0 then
      LV_INSTALAR := SGAFUN_GET_NOMBRE_EQU(SGAFUN_GET_CODEQU_NEW(AV_COD_ID));
    elsif LN_SERVICIOS.LN_VAL_INT_NEW = 0 and LN_SERVICIOS.LN_VAL_INT_OLD > 0
      and LN_SERVICIOS.LN_VAL_TLF_NEW = 0 then
      LV_DESINSTALAR := SGAFUN_GET_NOMBRE_EQU(SGAFUN_GET_CODEQU_OLD(AN_CODSOLOT));
    ELSIF LN_SERVICIOS.LN_VAL_INT_NEW > 0 AND LN_SERVICIOS.LN_VAL_INT_OLD > 0 THEN
      --4.0 Ini
      --Validamos Visita Tecnica Matriz
      ln_flag_visit_tec := operacion.pq_sga_janus.f_get_constante_conf('VAL_VISITA_TEC');

      IF ln_flag_visit_tec > 0 AND ln_val_contrato_hfc > 0 THEN  --Flag General ViTec --6.0
          ln_val_vel_int := SGAFUN_VAL_VISITA_TEC(AV_COD_ID,AN_CODSOLOT);
          IF ln_val_vel_int > 0 THEN --Aplica Visita Tecnica
             LV_INSTALAR    := SGAFUN_GET_NOMBRE_EQU(SGAFUN_GET_CODEQU_NEW(AV_COD_ID));
             LV_DESINSTALAR := SGAFUN_GET_NOMBRE_EQU(SGAFUN_GET_CODEQU_OLD(AN_CODSOLOT));
          END IF;
          IF ln_val_vel_int = 2 THEN
              SGASI_log_post_siac(AV_COD_ID, AN_CODSOLOT, 'SGAFUN_GET_INST_DESIN', 'VALIDACION DE VISITA TECNICA');
          END IF;
      ELSE
      --4.0 Fin
          LV_CODEQUCOM_OLD := SGAFUN_GET_CODEQU_OLD(AN_CODSOLOT);
          LV_CODEQUCOM_NEW := SGAFUN_GET_CODEQU_NEW(AV_COD_ID);

          IF SGAFUN_val_cfg_codequcom(NVL(LV_CODEQUCOM_NEW,'X'), NVL(LV_CODEQUCOM_OLD,'X')) = 1 AND
             LV_CODEQUCOM_NEW != LV_CODEQUCOM_OLD THEN
              LV_INSTALAR    := SGAFUN_GET_NOMBRE_EQU(SGAFUN_GET_CODEQU_NEW(AV_COD_ID));
              LV_DESINSTALAR := SGAFUN_GET_NOMBRE_EQU(SGAFUN_GET_CODEQU_OLD(AN_CODSOLOT));
          END IF;
      END IF;  --4.0
    END IF;

    -- Instalar Decos NEW - OLD ----
    L_CADENA  := '';
    L_CADENA2 := '';
    FLG_IGUAL := 0;
    IF LN_SERVICIOS.LN_VAL_CTV_NEW > 0 THEN
      FOR C IN C_EQU_PVU LOOP
        FOR X IN C_EQU_SGA_CP LOOP
          IF C.TIP_EQ_NEW = X.TIP_EQ THEN  --4.0
            IF (C.CANTIDAD - X.CANTIDAD) > 0 THEN
              --VALIDAR CANTIDADES DE DECOS PARA SABER QUE SE INSTALA
              L_CADENA2 := SGAFUN_FORMAT_VACIO(L_CADENA2)||(C.CANTIDAD - X.CANTIDAD)
         || ' ' ||SGAFUN_CHANGE_CADENA(C.TIP_EQ_NEW,CV_ABUSCAR,CV_AREEMPLAZAR); --5.0
            END IF;
            FLG_IGUAL := 1;
          END IF;
        END LOOP;

        IF FLG_IGUAL != 1 THEN
          L_CADENA := SGAFUN_FORMAT_VACIO(L_CADENA)|| C.CANTIDAD || ' ' ||SGAFUN_CHANGE_CADENA(C.TIP_EQ_NEW,CV_ABUSCAR,CV_AREEMPLAZAR); --5.0
        END IF;
        FLG_IGUAL := 0;
      END LOOP;

      LV_INSTALAR := SGAFUN_FORMAT_VACIO(LV_INSTALAR) || L_CADENA || L_CADENA2;
    END IF;

    -- Desintalar Decos OLD - NEW ----
    L_CADENA  := '';
    L_CADENA2 := '';
    FLG_IGUAL := 0;

    IF LN_SERVICIOS.LN_VAL_CTV_OLD > 0 THEN
      FOR C IN C_EQU_SGA_CP LOOP
        FOR X IN C_EQU_PVU LOOP
          IF C.TIP_EQ = X.TIP_EQ_NEW THEN  --4.0
            IF (C.CANTIDAD - X.CANTIDAD) > 0 THEN
              -- VALIDAR CANTIDADES DE DECOS PARA SABER QUE SE DESINSTALA
              L_CADENA2 := SGAFUN_FORMAT_VACIO(L_CADENA2)||(C.CANTIDAD - X.CANTIDAD)
                           || ' ' ||SGAFUN_CHANGE_CADENA(C.TIP_EQ,CV_ABUSCAR,CV_AREEMPLAZAR); --5.0
            END IF;
            FLG_IGUAL := 1;
          END IF;
        END LOOP;

        IF FLG_IGUAL != 1 THEN
          L_CADENA := SGAFUN_FORMAT_VACIO(L_CADENA) || C.CANTIDAD || ' ' ||SGAFUN_CHANGE_CADENA(C.TIP_EQ,CV_ABUSCAR,CV_AREEMPLAZAR); --5.0
        END IF;
        FLG_IGUAL := 0;
      END LOOP;
      LV_DESINSTALAR := SGAFUN_FORMAT_VACIO(LV_DESINSTALAR) || L_CADENA || L_CADENA2;
    END IF;

    IF LENGTH(LV_DESINSTALAR) > 0 THEN
      LV_DESINSTALAR := 'RETIRAR: ' || LV_DESINSTALAR || '; ' || chr(13);
    END IF;
    IF LENGTH(LV_INSTALAR) > 0 THEN
      LV_INSTALAR := 'INSTALAR: ' || LV_INSTALAR || '; ' || chr(13);
    END IF;
    LV_CADENA := LV_DESINSTALAR || LV_INSTALAR;

    IF LN_SERVICIOS.LN_VAL_INT_NEW > 0 AND LN_SERVICIOS.LN_VAL_INT_OLD > 0 THEN
      -- ini v2.0
      FOR idx IN c_serv_v LOOP
        SGASS_EVAL_INTERNET(AN_CODSOLOT,
                            idx.cod_serv_sisact,
                            ln_val_vel_int,
                            an_error,
                            av_error);
        if an_error != 0 then
          raise error_general;
        end if;

        IF ln_val_vel_int > 0 THEN
          LV_UPGRADE := 'UPGRADE: ' || TO_CHAR(LN_SERVICIOS.LN_DES_INT_OLD) ||  --4.0
                        ' - A - ' || TO_CHAR(LN_SERVICIOS.LN_DES_INT_NEW) || '; ' ||  --4.0
                        chr(13);
        ELSE
          LV_DOWNGRADE := 'DOWNGRADE: ' || TO_CHAR(LN_SERVICIOS.LN_DES_INT_OLD) ||  --4.0
                          ' - A - ' || TO_CHAR(LN_SERVICIOS.LN_DES_INT_NEW) || '; ' ||  --4.0
                          chr(13);
        END IF;
        LV_UPGRADE_CAD   := LV_UPGRADE_CAD || LV_UPGRADE;  --4.0
        LV_DOWNGRADE_CAD := LV_DOWNGRADE_CAD || LV_DOWNGRADE;  --4.0
      END LOOP;
    END IF;

    LV_SERVICIOS := LV_UPGRADE_CAD || LV_DOWNGRADE_CAD;

    LV_CADENA := LV_DESINSTALAR || LV_INSTALAR || LV_SERVICIOS;
    -- fin v2.0

    RETURN LV_CADENA;

  EXCEPTION
    WHEN error_general THEN
      av_error := 'ERROR : '|| av_error;
      OPERACION.PQ_VISITA_SGA_SIAC.SGASI_log_post_siac(AV_COD_ID,
                                                       AN_CODSOLOT,
                                                       'SGAFUN_GET_INST_DESIN',
                                                       av_error);
    WHEN OTHERS THEN
      --4.0 Ini
      av_error := 'Error : ' || SQLCODE || ' ' || SQLERRM || ' Linea (' ||
                  dbms_utility.format_error_backtrace || ')';

      OPERACION.PQ_VISITA_SGA_SIAC.SGASI_log_post_siac(AV_COD_ID,
                                                       AN_CODSOLOT,
                                                       'SGAFUN_GET_INST_DESIN',
                                                       av_error);
      --4.0 Fin
      RETURN NULL;
  END;
  -- funcion obtener subtipo orden ---
  FUNCTION SGAFUN_GET_SUBTIPO(AN_CODSOLOT OPERACION.SOLOT.CODSOLOT%TYPE,
                              AV_COD_ID   OPERACION.SGA_VISITA_TECNICA_SIAC.CO_ID%TYPE,
                              LN_TIPTRA   operacion.tiptrabajo.tiptra%type)
    RETURN VARCHAR2 IS

    EXC_INTERNET      EXCEPTION;
    EXC_CODEQUCOM_NEW EXCEPTION;
    LV_TMP                VARCHAR2(4000);
    ln_gcnt_ctv_old    NUMBER;
    ln_gcnt_ctv_new    NUMBER;
    LN_SRV            VALORES_SRV;
    LV_CODEQUCOM_OLD VTAEQUCOM.CODEQUCOM%TYPE;
    LV_CODEQUCOM_NEW VTAEQUCOM.CODEQUCOM%TYPE;
    LV_RETIRA_DECO        VARCHAR2(100) := 'RDECO'; --'RETIRAR DECOS';
    LV_INSTALA_M2_DECO    VARCHAR2(100) := 'IM2D'; --'INSTALAR MAYOR A 02 DECOS';
    LV_INSTALA_H2_DECO    VARCHAR2(100) := 'IH2D'; --'INSTALAR HASTA 02 DECOS';
    LV_RETIRA_TELEFONIA   VARCHAR2(100) := 'RTLF'; --'RETIRAR TELEFONIA';
    LV_INSTALA_TELEFONIA  VARCHAR2(100) := 'ITLF'; --'INSTALAR TELEFONIA';
    LV_RETIRA_INTERNET    VARCHAR2(100) := 'RINT'; --'RETIRAR INTERNET';
    LV_INSTALA_INTERNET   VARCHAR2(100) := 'IINT'; --'INSTALAR INTERNET';
    LV_CEMTA              VARCHAR2(100) := 'CEMTA'; --'CAMBIO EMTA';
    LV_UNION              VARCHAR2(10)  := '_';  --' + ';
    LV_CADENA_DECO_INS    VARCHAR2(100);
    LV_CADENA_DECO_DES    VARCHAR2(100);
    LV_CADENA_DECO        VARCHAR2(100);
    LV_CADENA_INT         VARCHAR2(100);
    LV_CADENA_TLF         VARCHAR2(100);
    LV_SUBTIPO            VARCHAR2(1000);
    CNT_EQU_INSTALA       NUMBER;
    ERROR_SUBTIPO         EXCEPTION;

    CURSOR C_SUBTIPO is
    SELECT COD_SUBTIPO_ORDEN FROM OPERACION.SUBTIPO_ORDEN_ADC
     where id_tipo_orden = (select id_tipo_orden from tiptrabajo
                              where tiptra = LN_TIPTRA)
       and upper(trim(cod_alterno)) like '%'||LV_CADENA_INT||'%'
    union
    select COD_SUBTIPO_ORDEN from OPERACION.SUBTIPO_ORDEN_ADC
     where id_tipo_orden = (select id_tipo_orden from tiptrabajo
                              where tiptra = LN_TIPTRA)
       and upper(trim(cod_alterno)) like '%'||LV_CADENA_DECO||'%';

    CURSOR C_EQU_RETIRA IS
      SELECT eq.tip_eq TIPO_EQUIPO, sum(x.cantidad) cantidad
        FROM (SELECT distinct ip.pid, IP.codequcom, ip.cantidad
                FROM solot s, solotpto sp, insprd ip, inssrv iv
               WHERE s.codsolot = sp.codsolot
                 AND sp.codinssrv = iv.codinssrv
                 AND ip.codinssrv = iv.codinssrv
                 AND s.codsolot = an_codsolot
                 AND iv.tipsrv IN ('0062')
                 AND ip.estinsprd IN (1, 2)) X,
             vtaequcom eq,
             EQUCOMXOPE v,
             TIPEQU TE
       WHERE nvl(X.codequcom, 'X') != 'X'
         AND X.CODEQUCOM = eq.CODEQUCOM
         AND eq.CODEQUCOM = v.CODEQUCOM
         AND v.CODTIPEQU = TE.CODTIPEQU
         and TE.TIPO = 'DECODIFICADOR'
       group by eq.tip_eq
      MINUS
      SELECT X.TIP_EQ TIPO_EQUIPO, SUM(X.CANTIDAD) CANTIDAD
         FROM (select DISTINCT EQ.TIP_EQ, SV.CANTIDAD_EQU AS CANTIDAD
                 from OPERACION.SGA_VISITA_TECNICA_SIAC SV,
                      TIPEQU                            TE,
                      vtaequcom                         eq,
                      EQUCOMXOPE                        v
                WHERE TE.TIPEQU = SV.TIPEQU
                  AND TRIM(TE.CODTIPEQU) = SV.CODTIPEQU
                  AND SV.CO_ID = AV_COD_ID
                  AND eq.CODEQUCOM = v.CODEQUCOM
                  AND v.CODTIPEQU = TE.CODTIPEQU
                  AND V.TIPEQU = SV.TIPEQU
                  and TE.TIPO = 'DECODIFICADOR') X
        group by X.TIP_EQ;

   CURSOR C_EQU_INSTALA IS
      SELECT X.TIP_EQ TIPO_EQUIPO, SUM(X.CANTIDAD) CANTIDAD
         FROM (select DISTINCT EQ.TIP_EQ, SV.CANTIDAD_EQU AS CANTIDAD
                 from OPERACION.SGA_VISITA_TECNICA_SIAC SV,
                      TIPEQU                            TE,
                      vtaequcom                         eq,
                      EQUCOMXOPE                        v
                WHERE TE.TIPEQU = SV.TIPEQU
                  AND TRIM(TE.CODTIPEQU) = SV.CODTIPEQU
                  AND SV.CO_ID = AV_COD_ID
                  AND eq.CODEQUCOM = v.CODEQUCOM
                  AND v.CODTIPEQU = TE.CODTIPEQU
                  AND V.TIPEQU = SV.TIPEQU
                  and TE.TIPO = 'DECODIFICADOR') X
        group by X.TIP_EQ
      MINUS
      SELECT eq.tip_eq, sum(x.cantidad) cantidad
        FROM (SELECT distinct ip.pid, IP.codequcom, ip.cantidad
                FROM solot s, solotpto sp, insprd ip, inssrv iv
               WHERE s.codsolot = sp.codsolot
                 AND sp.codinssrv = iv.codinssrv
                 AND ip.codinssrv = iv.codinssrv
                 AND s.codsolot = an_codsolot
                 AND iv.tipsrv IN ('0062')
                 AND ip.estinsprd IN (1, 2)) X,
             vtaequcom eq,
             EQUCOMXOPE v,
             TIPEQU TE
       WHERE nvl(X.codequcom, 'X') != 'X'
         AND X.CODEQUCOM = eq.CODEQUCOM
         AND eq.CODEQUCOM = v.CODEQUCOM
         AND v.CODTIPEQU = TE.CODTIPEQU
         and TE.TIPO = 'DECODIFICADOR'
       group by eq.tip_eq ;

    BEGIN
    -- INICIO VALORES SERVICIOS
    -- LN_SRV := SGAFUN_INICIA_VALORES(An_codsolot,aV_cod_id);
    LN_SRV.ln_val_ctv_old := operacion.pq_visita_sga_siac.SGAFUN_val_tipsrv_old(AN_CODSOLOT, CV_CABLE); -- CTV;
    LN_SRV.LN_VAL_INT_OLD := operacion.pq_visita_sga_siac.SGAFUN_val_tipsrv_old(AN_CODSOLOT, CV_INTERNET); -- INT;
    LN_SRV.LN_VAL_TLF_OLD := operacion.pq_visita_sga_siac.SGAFUN_val_tipsrv_old(AN_CODSOLOT, CV_TELEFONIA); -- TLF;

    LN_SRV.LN_VAL_CTV_NEW := operacion.pq_visita_sga_siac.SGAFUN_val_tipsrv_new(AV_COD_ID, CV_CABLE); -- CTV;
    LN_SRV.LN_VAL_INT_NEW := operacion.pq_visita_sga_siac.SGAFUN_val_tipsrv_new(AV_COD_ID, CV_INTERNET); -- INT;
    LN_SRV.LN_VAL_TLF_NEW := operacion.pq_visita_sga_siac.SGAFUN_val_tipsrv_new(AV_COD_ID, CV_TELEFONIA); -- TLF;

     -- INI INT
    IF LN_SRV.LN_val_int_new > 0 AND LN_SRV.LN_val_int_old = 0 and LN_SRV.LN_VAL_TLF_OLD = 0 THEN
       LV_CADENA_INT := LV_INSTALA_INTERNET;
    ELSIF LN_SRV.LN_val_int_new = 0 AND LN_SRV.LN_val_int_old > 0 AND LN_SRV.LN_VAL_TLF_NEW = 0 THEN
       LV_CADENA_INT := LV_RETIRA_INTERNET;
    ELSIF LN_SRV.LN_val_int_new > 0 AND LN_SRV.LN_val_int_old > 0 THEN
     -- TIENE SRV INTERNET, VALIDO SI CAMBIA EMTA
       LV_CODEQUCOM_OLD := operacion.pq_visita_sga_siac.SGAFUN_GET_CODEQU_OLD(AN_CODSOLOT);

     select distinct lp.codequcom
       into LV_CODEQUCOM_NEW
       from sales.equipo_sisact es, sales.linea_paquete lp
      where exists (SELECT S.TIPEQU
               FROM OPERACION.SGA_VISITA_TECNICA_SIAC S, TIPEQU T
              WHERE S.CO_ID = AV_COD_ID
                AND S.TIPEQU = T.TIPEQU
                AND S.TIPO_SRV = 'INT'
                AND T.TIPO != 'SMART CARD'
                AND S.TIPEQU = ES.TIPEQU)
        and es.idlinea = lp.idlinea
        and rownum < 2;

      IF operacion.pq_visita_sga_siac.SGAFUN_val_cfg_codequcom(NVL(LV_CODEQUCOM_NEW,'X'), NVL(LV_CODEQUCOM_OLD,'X')) = 1 AND
          LV_CODEQUCOM_NEW != LV_CODEQUCOM_OLD THEN
          LV_CADENA_INT := LV_CEMTA;
      END IF;
      END IF;
     -- FIN INT

    -- INI TLF
    IF LN_SRV.LN_VAL_TLF_NEW > 0 AND LN_SRV.LN_VAL_TLF_OLD = 0 THEN
       LV_CADENA_TLF := LV_INSTALA_TELEFONIA;
    ELSIF LN_SRV.LN_VAL_TLF_NEW = 0 AND LN_SRV.LN_VAL_TLF_OLD > 0 THEN
       LV_CADENA_TLF := LV_RETIRA_TELEFONIA;
    END IF;
    -- FIN TLF

    -- Cantidad de Equipos Serv Anterior CTV
    SELECT sum(x.cantidad)
      INTO ln_gcnt_ctv_old
      FROM (SELECT distinct ip.pid, ip.codequcom, ip.cantidad
              FROM solot s, solotpto sp, insprd ip, inssrv iv
             WHERE s.codsolot = sp.codsolot
               AND sp.codinssrv = iv.codinssrv
               AND ip.codinssrv = iv.codinssrv
               AND s.codsolot = An_codsolot
               AND iv.tipsrv IN ('0062')
               AND ip.estinsprd IN (1, 2)) X
     WHERE nvl(X.codequcom, 'X') != 'X';

   -- Cantidad de Equipos Serv Nuevo
    ln_gcnt_ctv_new := operacion.pq_visita_sga_siac.sgafun_val_cantequ_new(av_cod_id);

    -- INI DECO
    -- SRV NEW NO TIENE SRV OLD TIENE -> RETIRO NO COMPARO CANTIDAD
    IF LN_SRV.LN_val_ctv_old > 0 and LN_SRV.LN_val_ctv_new = 0 THEN
       LV_Cadena_deco := LV_RETIRA_DECO;
    ELSIF LN_SRV.LN_val_ctv_old = 0 and LN_SRV.LN_val_ctv_new > 0 THEN
       IF (nvl(ln_gcnt_ctv_new,0)) > 2 THEN
           LV_Cadena_deco := LV_INSTALA_M2_DECO;
       ELSE
           LV_Cadena_deco := LV_INSTALA_H2_DECO;
       END IF;
    ELSIF LN_SRV.LN_val_ctv_old > 0 and LN_SRV.LN_val_ctv_new > 0 THEN
      -- Armando CADENA DECOS INSTALA
      CNT_EQU_INSTALA :=0;
      FOR C IN C_EQU_INSTALA LOOP
        CNT_EQU_INSTALA := CNT_EQU_INSTALA + C.CANTIDAD;
      END LOOP;

      IF (nvl(CNT_EQU_INSTALA,0)) > 2 THEN
         LV_CADENA_DECO_INS := LV_INSTALA_M2_DECO;
        ELSE
         LV_CADENA_DECO_INS := LV_INSTALA_H2_DECO;
        END IF;

      FOR R IN C_EQU_RETIRA LOOP
        IF (nvl(R.CANTIDAD,0)) > 0 THEN
           LV_CADENA_DECO_DES := LV_RETIRA_DECO;
    END IF;
      END LOOP;

      IF NVL(LV_CADENA_DECO_INS,'X')!='X' THEN
        IF NVL(LV_CADENA_DECO_DES,'X')!='X' THEN
          LV_CADENA_DECO := LV_CADENA_DECO_INS||LV_UNION||LV_CADENA_DECO_DES;
      ELSE
          LV_CADENA_DECO := LV_CADENA_DECO_INS;
        END IF;
        END IF;
      END IF;
    -- FIN DECO
    -- ARMANDO LA DESCRIPCION
    IF NVL(LV_CADENA_DECO,'X')!='X' THEN
      IF NVL(LV_CADENA_INT,'X')!='X'THEN
        IF NVL(LV_CADENA_TLF,'X')!='X' THEN
          LV_TMP := LV_CADENA_DECO||LV_UNION||LV_CADENA_INT||LV_UNION||LV_CADENA_TLF;
        ELSE
          LV_TMP := LV_CADENA_DECO||LV_UNION||LV_CADENA_INT;
        END IF;
      ELSE
        LV_TMP := LV_CADENA_DECO;
      END IF;
      END IF;
    -- Crear un funcion que devuelva EL SUBTIPO ORDEN
    SGASI_log_post_siac(AV_COD_ID, NULL, 'SUBTIPO_ALTERNO_VISIT_CP', LV_TMP);
    -----
    BEGIN
      select COD_SUBTIPO_ORDEN INTO LV_SUBTIPO
        from OPERACION.SUBTIPO_ORDEN_ADC
       WHERE COD_ALTERNO = LV_TMP
         AND ID_TIPO_ORDEN = ( SELECT ID_TIPO_ORDEN FROM TIPTRABAJO
                                    WHERE TIPTRA = ln_tiptra );
  EXCEPTION
      when no_data_found then
        for reg in c_subtipo loop
          if nvl(LV_SUBTIPO,'X')!='X' then
             LV_SUBTIPO :=LV_SUBTIPO||'|'||reg.COD_SUBTIPO_ORDEN;
          else
             LV_SUBTIPO := reg.COD_SUBTIPO_ORDEN;
          end if;
        end loop;
      when others then
         LV_SUBTIPO := '';
    END ;
    RETURN   LV_SUBTIPO ;
  END;
  -----------------------------------------------------------
  -- PROCEDIMIENTO P/ LOGICA PRINCIPAL VISITA
  -----------------------------------------------------------
  procedure SGASS_ORDEN_VISITA(an_cod_id          in number,
                               an_customer_id     in number,
                               an_tmcode          in number,
                               an_cod_plan_sisact in number,
                               av_trama           in varchar2,
                               an_flg_visita      out number,
                               an_codmotot        out number,
                               an_error           out number,
                               av_error           out varchar2,
                               av_anotacion       out varchar2,
                               av_subtipo         out varchar2) is
    ln_val_contrato_hfc NUMBER;
    ln_val_contrato_lte NUMBER;
    error_tipo_contrato EXCEPTION;
    error_motot_visita  EXCEPTION;
    error_general       EXCEPTION;
    lv_tipo        VARCHAR2(20) := NULL;
    lv_abrev_motot operacion.opedd.abreviacion%TYPE;
    ln_codsolot    operacion.solot.codsolot%TYPE;
    error_no_sot EXCEPTION;
    ln_serv valores_srv;

    ln_total_old number;
    ln_total_new number;
    --
    ln_cnt_ctv_old number;
    ln_cnt_ctv_new number;
    ln_val_tip_equ number;
    ln_val_vel_int number;

    l_rows       NUMBER;
    l_delimiter  NUMBER;
    l_pointer    NUMBER;
    l_record     VARCHAR2(32767);
    l_string     VARCHAR2(32767);
    LV_ANOTACION VARCHAR2(4000);
    ln_tiptra    operacion.tiptrabajo.tiptra%type;
  ln_flag_visit_tec NUMBER;  --3.0

    lr_tabla operacion.sga_visita_tecnica_siac%rowtype;

    ln_cont            NUMBER;
    lv_cod_serv_sisact operacion.sga_visita_tecnica_siac.cod_serv_sisact%type;
    lv_idequipo        operacion.sga_visita_tecnica_siac.idequipo%type;

  BEGIN

    delete from operacion.sga_visita_tecnica_siac v
     where v.co_id = an_cod_id;
    commit;

    an_flg_visita := 1; -- Todo se inicializa como Visita Tecnica
    an_codmotot   := NULL;
    an_error      := 0;
    av_error      := 'OK';

    ln_serv.ln_val_ctv_old := 0;
    ln_serv.ln_val_int_old := 0;
    ln_serv.ln_val_tlf_old := 0;
    ln_cont                := 0;
    ln_serv.ln_val_ctv_new := 0;
    ln_serv.ln_val_int_new := 0;
    ln_serv.ln_val_tlf_new := 0;
    --
    ln_cnt_ctv_old := 0;
    ln_cnt_ctv_new := 0;
    ln_val_tip_equ := 0;
    ln_val_vel_int := 0;

    -- Validamos el Tipo de contrato
    SELECT COUNT(1)
      INTO ln_val_contrato_hfc
      FROM contract_all@dbl_bscs_bf cc
     WHERE cc.co_id = an_cod_id
       AND cc.sccode = 6;

    SELECT COUNT(1)
      INTO ln_val_contrato_lte
      FROM contract_all@dbl_bscs_bf cc
     WHERE cc.co_id = an_cod_id
       AND cc.sccode = 1
       AND cc.tmcode IN (SELECT x.valor1
                           FROM tim.tim_parametros@dbl_bscs_bf x
                          WHERE x.campo = 'PLAN_LTE');

    IF ln_val_contrato_hfc = 0 AND ln_val_contrato_lte = 0 THEN
      RAISE error_tipo_contrato;
    END IF;

    IF ln_val_contrato_hfc != 0 THEN
      lv_tipo        := 'HFC';
      lv_abrev_motot := 'HFC_CON_VISTA';

      select a.codigon
        into ln_tiptra
        from opedd a, tipopedd b
       where a.tipopedd = b.tipopedd
         and b.abrev in ('TIPTRA_HFC_LTE_CP')
         and a.abreviacion in ('HFC_SIAC_CPLAN');

    END IF;

    IF ln_val_contrato_lte != 0 THEN
      lv_tipo        := 'LTE';
      lv_abrev_motot := 'LTE_CON_VISTA';

      select a.codigon
        into ln_tiptra
        from opedd a, tipopedd b
       where a.tipopedd = b.tipopedd
         and b.abrev in ('TIPTRA_HFC_LTE_CP')
         and a.abreviacion in ('LTE_SIAC_CPLAN');

    END IF;

    -- Cargamos temporalmente el Array
    l_rows    := SGAFUN_count_rows(av_trama) - 1;
    l_string  := replace(av_trama, ' ', '');
    l_pointer := 1;
    ln_cont   := 1;

    /*=====================================================================*/
    -- Solo para pruebas (Despues Quitar)
    OPERACION.PQ_VISITA_SGA_SIAC.SGASI_log_post_siac(an_cod_id,
                                                     an_customer_id,
                                                     'SGASS_ORDEN_VISITA',
                                                     'TRAMA:(' || l_string || ')');

    /*=====================================================================*/

    lr_tabla.co_id         := an_cod_id;
    lr_tabla.customer_id   := an_customer_id;
    lr_tabla.tmcode        := an_tmcode;
    lr_tabla.codplansisact := an_cod_plan_sisact;

    FOR idx IN 1 .. l_rows LOOP

      l_delimiter := instr(l_string, ';', 1, idx);
      l_record    := substr(l_string, l_pointer, l_delimiter - l_pointer);

      lr_tabla.cod_serv_sisact := SGAFUN_divide_cadena(l_record);
      lr_tabla.sncode          := SGAFUN_divide_cadena(l_record);
      lr_tabla.cod_grupo_serv  := SGAFUN_divide_cadena(l_record);
      lr_tabla.codtipequ       := SGAFUN_divide_cadena(l_record);
      lr_tabla.tipequ          := SGAFUN_divide_cadena(l_record);
      lr_tabla.idequipo        := SGAFUN_divide_cadena(l_record);
      lr_tabla.cantidad_equ    := SGAFUN_divide_cadena(l_record);
      lr_tabla.tipo_srv        := SGAFUN_divide_cadena(l_record);
      lr_tabla.usureg          := user;
      lr_tabla.fecreg          := sysdate;
      lr_tabla.ipaplicacion    := SYS_CONTEXT('USERENV', 'IP_ADDRESS');
      lr_tabla.pcaplicacion    := SYS_CONTEXT('USERENV', 'TERMINAL');

      insert into operacion.sga_visita_tecnica_siac values lr_tabla;
      commit;

      ln_cont := ln_cont + 1;

      l_pointer := l_delimiter + 1;

    END LOOP;

    -- Proceso de validacion de los servicios
    ln_codsolot := operacion.pq_sga_iw.f_max_sot_x_cod_id(an_cod_id);

    IF ln_codsolot = 0 THEN
      RAISE error_no_sot;
    END IF;

    ln_serv := OPERACION.PQ_VISITA_SGA_SIAC.SGAFUN_INICIA_VALORES(ln_codsolot,
                                                                  an_cod_id);
    --Cantidad de Equipos Serv Anterior
    ln_cnt_ctv_old := OPERACION.PQ_VISITA_SGA_SIAC.sgafun_val_cantequ(ln_codsolot,
                                                                      '0062');

    -- Cantidad de Equipos Serv Nuevo
    ln_cnt_ctv_new := OPERACION.PQ_VISITA_SGA_SIAC.sgafun_val_cantequ_new(an_cod_id);

    ln_val_tip_equ := OPERACION.PQ_VISITA_SGA_SIAC.sgafun_val_tipdeco(ln_codsolot,
                                                                      an_cod_id);

    IF LN_SERV.ln_val_int_old != 0 and ln_serv.ln_val_int_new != 0 then
      --3.0 Ini
      --Validamos Visita Tecnica
      ln_flag_visit_tec := operacion.pq_sga_janus.f_get_constante_conf('VAL_VISITA_TEC');

      IF ln_flag_visit_tec  = 1 AND ln_val_contrato_hfc > 0 THEN --5.0
          ln_val_vel_int := SGAFUN_VAL_VISITA_TEC(an_cod_id,ln_codsolot);

          IF ln_val_vel_int = 2 THEN
              SGASI_log_post_siac(an_cod_id, an_customer_id, 'SGAFUN_VAL_VISITA_TEC', 'ERROR AL VALIDAR VISITA TECNICA');
          END IF;
      ELSE
      --3.0 Fin

           select distinct v.cod_serv_sisact, v.idequipo
            into lv_cod_serv_sisact, lv_idequipo
            from operacion.sga_visita_tecnica_siac v, tipequ t
           where v.co_id = an_cod_id
            and v.tipequ = t.tipequ
            and v.tipo_srv = 'INT'
            and t.tipo != 'SMART CARD';

          operacion.pq_visita_sga_siac.sgass_get_val_internet_eq(ln_codsolot,
                                                                lv_cod_serv_sisact,
                                                                lv_idequipo,
                                                                an_cod_id,
                                                                ln_val_vel_int,
                                                                an_error,
                                                                av_error);
        if an_error != 0 then
          raise error_general;
        end if;

      END IF; --3.0
    end if;

    ln_total_old := ln_serv.ln_val_ctv_old + ln_serv.ln_val_int_old +
                    ln_serv.ln_val_tlf_old;
    ln_total_new := ln_serv.ln_val_ctv_new + ln_serv.ln_val_int_new +
                    ln_serv.ln_val_tlf_new;

    OPERACION.PQ_VISITA_SGA_SIAC.SGASI_log_post_siac(an_cod_id,
                                                     an_customer_id,
                                                     'SGASS_ORDEN_VISITA',
                                                     'Primero = lv_abrev_motot : ' ||
                                                     lv_abrev_motot ||
                                                     ' - an_flg_visita : ' ||
                                                     an_flg_visita ||
                                                     ' - lv_tipo : ' ||
                                                     lv_tipo);

    -- Validacion Cantidad de Servicios principales mayor a la cantidad de servicios principales de la SOT anterior
    -- CTV < CTV + INT                              --> Si Aplica
    -- CTV < CTV + TLF                              --> Si Aplica
    -- CTV < CTV + TLF + INT                        --> Si Aplica
    -- INT < INT + TLF                              --> Si Aplica
    -- INT < INT + TLF + CTV                        --> Si Aplica
    -- INT < INT + CTV                              --> Si Aplica
    -- INT + TLF < INT + CTV + TLF                  --> Si Aplica
    -- INT + CTV < INT + CTV + TLF                  --> Si Aplica
    -- CTV + TLF < INT + CTV + TLF                  --> Si Aplica
    if ln_total_old < ln_total_new then

      an_flg_visita := 1;
      goto salto;

      -- CTV + INT + TLF > CTV + TLF                  --> No Aplica (Solo se Desahabilita el INT en IC)
      --:: Aplica en el caso de aumento de Deco u cambio
      -- CTV + INT + TLF > CTV + INT                  --> Si Aplica (Siempre y cuando el equipo de TLF sea recuperable)
      --:: Aplica en el caso de aumento de Deco u cambio
      -- CTV + INT + TLF > INT + TLF                  --> Si Aplica (Valida si el equipo de TV es recuperable)
      -- CTV + INT + TLF > CTV                        --> Si Aplica (Valida si el equipo de INT es recuperable)
      --:: Aplica en el caso de aumento de Deco u cambio
      -- CTV + INT + TLF > INT                        --> Si Aplica (Valida si el equipo de TV es recuperable)
      -- CTV + INT + TLF > TLF                        --> Si Aplica (Valida si el equipo de TV es recuperable)
      -- CTV + INT > TLF                              --> Si Aplica (Valida si el equipo de TV es recuperable)
      -- CTV + INT > INT                              --> Si Aplica (Valida si el equipo de TV es recuperable)
      -- CTV + INT > CTV                              --> Si Aplica (Valida si el equipo de INT es recuperable)
      -- CTV + TLF > TLF                              --> Si Aplica (Valida si el equipo de TV es recuperable)
      -- CTV + TLF > INT                              --> Si Aplica (Valida si el equipo de TV es recuperable)
      -- CTV + TLF > CTV                              --> Si Aplica (Valida si el equipo de TLF es recuperable)
      -- INT + TLF > CTV                              --> Si Aplica (Valida si el equipo de INT es recuperable)
      -- INT + TLF > INT                              --> Si Aplica (Valida si el equipo de TLF es recuperable)
      -- INT + TLF > TLF                              --> No Aplica

    elsif ln_total_old > ln_total_new then

      if ln_total_old >= 3 then

        -- CTV + INT + TLF > CTV + TLF
        if ln_serv.ln_val_ctv_new > 0 and ln_serv.ln_val_tlf_new > 0 then
          -- Validar si se cambio de Deco (Aumento o Reducio)
          if ln_cnt_ctv_old <> ln_cnt_ctv_new or ln_val_tip_equ > 0 then
            an_flg_visita := 1;
          else
            an_flg_visita := 0; -- No Aplica
          end if;

          goto salto;

        end if;

        -- CTV + INT + TLF > CTV + INT
        if ln_serv.ln_val_ctv_new > 0 and ln_serv.ln_val_int_new > 0 then
          an_flg_visita := 0;
          -- Validar si el Equipo de TLF es Recuperable

          -- Validar si se cambio de Deco (Aumento o Reducio)
          if ln_cnt_ctv_old <> ln_cnt_ctv_new or ln_val_tip_equ > 0 then
            an_flg_visita := 1;
            --Z291018
          elsif ln_cnt_ctv_old = ln_cnt_ctv_new and ln_val_tip_equ = 0 and
                ln_serv.ln_val_tlf_old = 1 then
            if OPERACION.PQ_VISITA_SGA_SIAC.sgafun_val_recuperable(ln_codsolot,
                                                                   '0004') = 1 then
              an_flg_visita := 1;
            else
              an_flg_visita := 0;
            end if;
          else
            -- No Aplica
            an_flg_visita := 0;
          end if;

          goto salto;
        end if;

        -- CTV + INT + TLF > INT + TLF
        if ln_serv.ln_val_int_new > 0 and ln_serv.ln_val_tlf_new > 0 then
          -- Validar si el Equipo de TV es Recuperable
          if OPERACION.PQ_VISITA_SGA_SIAC.sgafun_val_recuperable(ln_codsolot,
                                                                 '0062') = 1 then
            an_flg_visita := 1;
          else
            an_flg_visita := 0;
          end if;
          goto salto;
        end if;

        if ln_serv.ln_val_ctv_new > 0 then
          -- Validar si el Equipo de INT es Recuperable
          if OPERACION.PQ_VISITA_SGA_SIAC.sgafun_val_recuperable(ln_codsolot,
                                                                 '0006') = 1 then
            an_flg_visita := 1;
          else
            an_flg_visita := 0;
          end if;
          goto salto;
        end if;

        if ln_serv.ln_val_int_new > 0 then
          -- Validar si el Equipo de TV es Recuperable
          if OPERACION.PQ_VISITA_SGA_SIAC.sgafun_val_recuperable(ln_codsolot,
                                                                 '0062') = 1 then
            an_flg_visita := 1;
          else
            an_flg_visita := 0;
          end if;
          goto salto;
        end if;

        if ln_serv.ln_val_tlf_new != 0 then
          -- Validar si el Equipo de TV o INT es Recuperable
          if OPERACION.PQ_VISITA_SGA_SIAC.sgafun_val_recuperable(ln_codsolot,
                                                                 '0062') = 1 or
             OPERACION.PQ_VISITA_SGA_SIAC.sgafun_val_recuperable(ln_codsolot,
                                                                 '0006') = 1 then
            an_flg_visita := 1;
          else
            an_flg_visita := 0;
          end if;
          goto salto;

        end if;

      end if;

      -- CTV + INT > TLF                              --> Si Aplica (Valida si el equipo de TV es recuperable)
      -- CTV + INT > INT                              --> Si Aplica (Valida si el equipo de TV es recuperable)
      -- CTV + INT > CTV                              --> Si Aplica (Valida si el equipo de INT es recuperable)
      if ln_serv.ln_val_ctv_old > 0 and ln_serv.ln_val_int_old > 0 then
        if ln_serv.ln_val_tlf_new > 0 or ln_serv.ln_val_int_new > 0 then
          -- Validar si el Equipo de TV es Recuperable
          if OPERACION.PQ_VISITA_SGA_SIAC.sgafun_val_recuperable(ln_codsolot,
                                                                 '0062') = 1 then
            an_flg_visita := 1;
          else
            an_flg_visita := 0;
          end if;
          goto salto;
        end if;

        if ln_serv.ln_val_ctv_new > 0 then
          -- Validar si el Equipo de INT es Recuperable
          if OPERACION.PQ_VISITA_SGA_SIAC.sgafun_val_recuperable(ln_codsolot,
                                                                 '0006') = 1 then
            an_flg_visita := 1;
          else
            an_flg_visita := 0;
          end if;
          goto salto;
        end if;

      end if;

      -- CTV + TLF > TLF                              --> Si Aplica (Valida si el equipo de TV es recuperable)
      -- CTV + TLF > INT                              --> Si Aplica (Valida si el equipo de TV es recuperable)
      -- CTV + TLF > CTV                              --> Si Aplica (Valida si el equipo de TLF es recuperable)
      if ln_serv.ln_val_ctv_old > 0 and ln_serv.ln_val_tlf_old > 0 then

        if ln_serv.ln_val_tlf_new != 0 or ln_serv.ln_val_int_new != 0 then
          -- Validar si el Equipo de TV es Recuperable
          if OPERACION.PQ_VISITA_SGA_SIAC.sgafun_val_recuperable(ln_codsolot,
                                                                 '0062') = 1 then
            an_flg_visita := 1;
          else
            an_flg_visita := 0;
          end if;
          goto salto;
        end if;

        if ln_serv.ln_val_ctv_new != 0 then
          -- Validar si el Equipo de TLF es Recuperable
          if OPERACION.PQ_VISITA_SGA_SIAC.sgafun_val_recuperable(ln_codsolot,
                                                                 '0004') = 1 then
            an_flg_visita := 1;
          else
            an_flg_visita := 0;
          end if;
          goto salto;
        end if;

      end if;

      -- INT + TLF > CTV                              --> Si Aplica (Valida si el equipo de INT es recuperable)
      -- INT + TLF > INT                              --> Si Aplica (Valida si el equipo de TLF es recuperable)
      -- INT + TLF > TLF                              --> No Aplica
      if ln_serv.ln_val_int_old != 0 and ln_serv.ln_val_tlf_old != 0 then

        if ln_serv.ln_val_ctv_new != 0 then
          -- Validar si el Equipo de INT es Recuperable
          if OPERACION.PQ_VISITA_SGA_SIAC.sgafun_val_recuperable(ln_codsolot,
                                                                 '0006') = 1 then
            an_flg_visita := 1;
          else
            an_flg_visita := 0;
          end if;
          goto salto;
        end if;

        if ln_serv.ln_val_int_new != 0 then
          -- Validar si el Equipo de TLF es Recuperable
          if OPERACION.PQ_VISITA_SGA_SIAC.sgafun_val_recuperable(ln_codsolot,
                                                                 '0004') = 1 then
            an_flg_visita := 1;
          else
            an_flg_visita := 0;
          end if;

          goto salto;
        end if;

        if ln_serv.ln_val_tlf_new != 0 then
          an_flg_visita := 0;
          goto salto;
        end if;

      end if;

      -- CTV + INT + TLF = CTV_NEW + INT_NEW + TLF_NEW  -- Validar Equipos y Velocidad de EMTA
      -- CTV + INT = CTV_NEW + INT_NEW
      -- CTV + TLF = CTV_NEW + TLF_NEW
      -- INT + TLF = INT_NEW + TLF_NEW
      -- INT = INT_NEW
      -- CTV = CTV_NEW
      -- TLF = TLF_NEW
      -- Servicios Iguales
      --3PLAY
    elsif ln_total_old = ln_total_new and ln_total_old = 3 then
      -- Validar Velocidad de INT
      if ln_val_vel_int > 0 then
        an_flg_visita := 1;
      elsif ln_cnt_ctv_old <> ln_cnt_ctv_new or ln_val_tip_equ > 0 then
        -- Validar Cantidad de Deco y Tipo de Deco
        an_flg_visita := 1;
      else
        an_flg_visita := 0;
      end if;
      --an_flg_visita := 1;
      goto salto;
      --2PLAY
    elsif ln_total_old = ln_total_new and ln_total_old = 2 then

      if (ln_serv.ln_val_ctv_new > 0 and ln_serv.ln_val_int_new > 0) and
         (ln_serv.ln_val_ctv_old > 0 and ln_serv.ln_val_int_old > 0) then
        -- Validar Velocidad de INT
        if ln_val_vel_int > 0 then
          an_flg_visita := 1;
        elsif ln_cnt_ctv_old <> ln_cnt_ctv_new or ln_val_tip_equ > 0 then
          -- Validar Cantidad de Deco y Tipo de Deco
          an_flg_visita := 1;
        else
          an_flg_visita := 0;
        end if;
        --an_flg_visita := 1;
        goto salto;
      end if;

      if (ln_serv.ln_val_ctv_new > 0 and ln_serv.ln_val_tlf_new > 0) and
         (ln_serv.ln_val_ctv_old > 0 and ln_serv.ln_val_tlf_old > 0) then
        -- Validar Cantidad de Deco y Tipo de Deco
        if ln_cnt_ctv_old <> ln_cnt_ctv_new or ln_val_tip_equ > 0 then
          an_flg_visita := 1;
        else
          an_flg_visita := 0;
        end if;
        goto salto;
      end if;

      if (ln_serv.ln_val_int_new > 0 and ln_serv.ln_val_tlf_new > 0) and
         (ln_serv.ln_val_int_old > 0 and ln_serv.ln_val_tlf_old > 0) then
        -- Validar Velocidad de INT
        if ln_val_vel_int > 0 then
          an_flg_visita := 1;
        else
          an_flg_visita := 0;
        end if;
        goto salto;
      end if;

      --1PLAY
    elsif ln_total_old = ln_total_new and ln_total_old = 1 then
      if ln_serv.ln_val_int_new > 0 and
         ln_serv.ln_val_int_new = ln_serv.ln_val_int_old then
        -- Validar Velocidad de INT
        if ln_val_vel_int > 0 then
          an_flg_visita := 1;
        else
          an_flg_visita := 0;
        end if;
        goto salto;
      end if;

      if ln_serv.ln_val_tlf_new > 0 and
         ln_serv.ln_val_tlf_new = ln_serv.ln_val_tlf_old then
        -- No Aplica Visita
        an_flg_visita := 0;
        goto salto;
      end if;

      if ln_serv.ln_val_ctv_new > 0 and
         ln_serv.ln_val_ctv_new = ln_serv.ln_val_ctv_old then
        -- Validar Cantidad de Deco y Tipo de Deco
        if ln_cnt_ctv_old <> ln_cnt_ctv_new or ln_val_tip_equ > 0 then
          an_flg_visita := 1;
        else
          an_flg_visita := 0;
        end if;
        goto salto;
      end if;
    end if;

    <<salto>>
    IF an_flg_visita != 0 THEN
      IF ln_val_contrato_hfc != 0 THEN
        lv_abrev_motot := 'HFC_CON_VISTA';
      ELSIF ln_val_contrato_lte != 0 THEN
        lv_abrev_motot := 'LTE_CON_VISTA';
      END IF;
    ELSIF nvl(an_flg_visita, 0) = 0 THEN
      IF ln_val_contrato_hfc != 0 THEN
        lv_abrev_motot := 'HFC_SI_VISTA';
      ELSIF ln_val_contrato_lte != 0 THEN
        lv_abrev_motot := 'LTE_SI_VISTA';
      END IF;
    END IF;

    BEGIN
      an_codmotot := OPERACION.PQ_VISITA_SGA_SIAC.SGAFUN_get_codmotot_visit(lv_tipo,
                                                                            lv_abrev_motot);
    EXCEPTION
      WHEN OTHERS THEN
        RAISE error_motot_visita;
    END;

    if an_flg_visita != 0 then
      --- Funcion para anotacion y subtipo Aplica Visita --------
      AV_SUBTIPO   := OPERACION.PQ_VISITA_SGA_SIAC.SGAFUN_GET_SUBTIPO(ln_codsolot,
                                                                      an_cod_id,
                                                                      LN_TIPTRA);
      av_anotacion := OPERACION.PQ_VISITA_SGA_SIAC.SGAFUN_GET_INST_DESIN(ln_codsolot,
                                                                         an_cod_id);
      -----------------------------------------------------------
      LV_ANOTACION := av_anotacion || ' - SUBTIPO_ORDEN:' || AV_SUBTIPO;

      -- Crear un funcion que devuelva que equipos se instalan y que se desintalan
      OPERACION.PQ_VISITA_SGA_SIAC.SGASI_log_post_siac(an_cod_id,
                                                       an_customer_id,
                                                       'ANOTACION_ORDEN_VISIT_CP',
                                                       LV_ANOTACION);
    end if;

    COMMIT;

  EXCEPTION
    WHEN error_no_sot THEN
      rollback;
      an_flg_visita := 1;
      an_error      := -1;
      an_codmotot   := OPERACION.PQ_VISITA_SGA_SIAC.SGAFUN_get_codmotot_visit(lv_tipo,
                                                                              lv_abrev_motot);
      av_error      := 'Error : No existe SOT de Alta asociado al contrato : ' ||
                       an_cod_id;
      OPERACION.PQ_VISITA_SGA_SIAC.SGASI_log_post_siac(an_cod_id,
                                                       an_customer_id,
                                                       'SGASS_ORDEN_VISITA',
                                                       'TRAMA:(' ||
                                                       replace(av_trama || ';',
                                                               ' ',
                                                               '') || ')' ||
                                                       av_error);

    WHEN error_motot_visita THEN
      rollback;
      an_flg_visita := 1;
      an_error      := -1;
      av_error      := 'Error : No existe un motivo configurado para ' ||
                       lv_tipo || '(Parametro = ' || lv_abrev_motot || ')';
      SGASI_log_post_siac(an_cod_id,
                          an_customer_id,
                          'SGASS_ORDEN_VISITA',
                          'TRAMA:(' || replace(av_trama || ';', ' ', '') || ')' ||
                          av_error);

    WHEN error_tipo_contrato THEN
      rollback;
      an_flg_visita := 1;
      an_error      := -2;
      an_codmotot   := null;
      av_error      := 'Error : El contrato ' || an_cod_id ||
                       ' no es HFC o LTE';
      OPERACION.PQ_VISITA_SGA_SIAC.SGASI_log_post_siac(an_cod_id,
                                                       an_customer_id,
                                                       'SGASS_ORDEN_VISITA',
                                                       'TRAMA:(' ||
                                                       replace(av_trama || ';',
                                                               ' ',
                                                               '') || ')' ||
                                                       av_error);

    when error_general then
      rollback;
      an_flg_visita := 1;
      an_codmotot   := OPERACION.PQ_VISITA_SGA_SIAC.SGAFUN_get_codmotot_visit(lv_tipo,
                                                                              lv_abrev_motot);
      OPERACION.PQ_VISITA_SGA_SIAC.SGASI_log_post_siac(an_cod_id,
                                                       an_customer_id,
                                                       'SGASS_ORDEN_VISITA',
                                                       av_error);
    WHEN OTHERS THEN
      rollback;
      an_flg_visita := 1;
      an_codmotot   := OPERACION.PQ_VISITA_SGA_SIAC.SGAFUN_get_codmotot_visit(lv_tipo,
                                                                              lv_abrev_motot);
      an_error      := -99;
      av_error      := 'Error : ' || SQLCODE || ' ' || SQLERRM || ' Linea (' ||
                       dbms_utility.format_error_backtrace || ')';

      OPERACION.PQ_VISITA_SGA_SIAC.SGASI_log_post_siac(an_cod_id,
                                                       an_customer_id,
                                                       'SGASS_ORDEN_VISITA',
                                                       substr('TRAMA:(' ||
                                                              replace(av_trama || ';',
                                                                      ' ',
                                                                      '') || ')' ||
                                                              av_error,
                                                              1,
                                                              4000));
  END;
 /************************************************************************************************/
 /**********************************************************************************************
 * PROY-32581.CAMBIO_PLAN
 */
  FUNCTION SGAFUN_GET_TIPO_TEC (pi_cod_id operacion.solot.cod_id%type) RETURN VARCHAR2 IS

  ln_val_contrato_hfc number;
  ln_val_contrato_lte number;
  lv_tipo             VARCHAR2(5);
  error_tipo_contrato exception;
  BEGIN
      -- Validamos el Tipo de contrato
      SELECT COUNT(1) INTO ln_val_contrato_hfc
        FROM contract_all@dbl_bscs_bf cc
       WHERE cc.co_id = pi_cod_id
         AND cc.sccode = 6;

      SELECT COUNT(1) INTO ln_val_contrato_lte
        FROM contract_all@dbl_bscs_bf cc
       WHERE cc.co_id = pi_cod_id
         AND cc.sccode = 1
         AND cc.tmcode IN (SELECT x.valor1 FROM tim.tim_parametros@dbl_bscs_bf x
                            WHERE x.campo = 'PLAN_LTE');

      IF ln_val_contrato_hfc = 0 AND ln_val_contrato_lte = 0 THEN
        RAISE error_tipo_contrato;
      END IF;

      IF ln_val_contrato_hfc != 0 THEN
        lv_tipo        := 'HFC';
      END IF;

      IF ln_val_contrato_lte != 0 THEN
        lv_tipo        := 'LTE';
      END IF;
  RETURN lv_tipo;
  EXCEPTION
    WHEN error_tipo_contrato THEN
      RETURN 'NDEF';
    WHEN OTHERS THEN
      RETURN 'NDEF';
  END;

 PROCEDURE SGASS_PROC_SRV_COMPARA(K_IDTAREAWF IN NUMBER,
                                  K_IDWF      IN NUMBER,
                                  K_TAREA     IN NUMBER,
                                  K_TAREADEF  IN NUMBER) IS
   /****************************************************************
   * Nombre SP : SGASS_PROC_SRV_COMPARA
   * Propósito : Realiza la diferencia de equipos antes y despues segun el tipo de transaccion
   * Input  : K_IDTAREAWF - Id. tarea del workflow
              K_IDWF      - Id. de workflow
              K_TAREA     - Id. tarea
              K_TAREADEF  - Id. definicion de la tarea
   * Output :  -
   * Creado por : -
   * Fec Creación : 11/06/2018
   * Fec Actualización :
   ****************************************************************/
   V_CODSOLOT_OLD operacion.solot.codsolot%TYPE;
   V_CODSOLOT_NEW operacion.solot.codsolot%TYPE;
   V_COD_ID_OLD   operacion.solot.cod_id%TYPE;
   V_COD_ID_NEW   operacion.solot.cod_id%TYPE;
   V_CUSTOMER_ID  operacion.solot.customer_id%TYPE;
   V_CODCLI       operacion.solot.codcli%type;
   V_MSJ_ERR      VARCHAR2(4000);
   v_error EXCEPTION;
   lr_tabla_srv     OPERACION.SGAT_VISITA_PROTOTYPE%rowtype;
   LN_GET_CTV_OLD   NUMBER;
   LN_GET_CTV_NEW   NUMBER;
   LN_GET_INT_NEW   NUMBER;
   LN_GET_INT_OLD   NUMBER;
   LN_GET_TLF_OLD   NUMBER;
   LN_GET_TLF_NEW   NUMBER;
   LV_CODEQUCOM_OLD VTAEQUCOM.CODEQUCOM%TYPE;
   LV_CODEQUCOM_NEW VTAEQUCOM.CODEQUCOM%TYPE;
   tipo_trabajo     operacion.tiptrabajo.tiptra%type;
   FLG_IGUAL        NUMBER;
   LV_TIP_EQ        sales.vtaequcom.tip_eq%type;
   
   ln_flag_insta    number:= 0; --7.0
   
   ln_flag_cp number;
   -- CURSOR PARA LOS TIPOS DE DECOS  EQ.codequcom,
   CURSOR C_DECO_SGA_NEW(CODSOLOT_1 NUMBER) IS
     SELECT eq.tip_eq, sum(x.cantidad) cantidad
        FROM (SELECT distinct ip.pid, IP.codequcom, ip.cantidad
                FROM solot s, solotpto sp, insprd ip, inssrv iv
               WHERE s.codsolot = sp.codsolot
                 AND sp.codinssrv = iv.codinssrv
                 AND ip.codinssrv = iv.codinssrv
                 AND s.codsolot = CODSOLOT_1
                 AND iv.tipsrv IN ('0062')) X,
             vtaequcom eq,
             EQUCOMXOPE V,
             TIPEQU TE
       WHERE nvl(X.codequcom, 'X') != 'X'
         and eq.codequcom = x.codequcom
         AND eq.CODEQUCOM = V.CODEQUCOM
         AND V.CODTIPEQU = TE.CODTIPEQU
         and TE.TIPO = 'DECODIFICADOR'
       group by eq.tip_eq
       order by eq.tip_eq desc;

   --DECOS OLD LOS ESTADOS DEBEN ESTAR EN 1 Y 2  EQ.codequcom,
   CURSOR C_DECO_SGA_OLD(CODSOLOT_2 NUMBER) IS
    SELECT eq.tip_eq, sum(x.cantidad) cantidad
        FROM (SELECT distinct ip.pid, IP.codequcom, ip.cantidad
                FROM solot s, solotpto sp, insprd ip, inssrv iv
               WHERE s.codsolot = sp.codsolot
                 AND sp.codinssrv = iv.codinssrv
                 AND ip.codinssrv = iv.codinssrv
                 AND s.codsolot = CODSOLOT_2
                 AND iv.tipsrv IN ('0062')
                 AND ip.estinsprd IN (1, 2)) X,
             vtaequcom eq,
             EQUCOMXOPE V,
             TIPEQU TE
       WHERE nvl(X.codequcom, 'X') != 'X'
         and eq.codequcom = x.codequcom
         AND eq.CODEQUCOM = V.CODEQUCOM
         AND V.CODTIPEQU = TE.CODTIPEQU
         and TE.TIPO = 'DECODIFICADOR'
       group by eq.tip_eq
       order by eq.tip_eq desc;

   CURSOR C_EQU_SGA_CTV(lln_codsolot_new number, lvv_tipo_equ varchar2) IS
     select distinct x.codinssrv,
                     x.codsrv,
                     x.pid,
                     x.iddet,
                     x.cantidad,
                     x.tipsrv,
                     eq.tip_eq,
                     eq.codequcom,
                     eq.dscequ,
                     te.tipo,
                     te.codtipequ,
                     te.tipequ
       from (select distinct s.codsolot,
                             ip.pid,
                             ip.codequcom,
                             ip.cantidad,
                             ip.iddet,
                             iv.tipsrv,
                             iv.codsrv,
                             iv.codinssrv
               from solot s, solotpto sp, insprd ip, inssrv iv
              where s.codsolot = sp.codsolot
                and sp.codinssrv = iv.codinssrv
                and ip.codinssrv = iv.codinssrv
                and s.codsolot in (lln_codsolot_new)
                AND iv.tipsrv IN ('0062')) X,
            vtaequcom eq,
            EQUCOMXOPE v,
            TIPEQU TE
      WHERE nvl(X.codequcom, 'X') != 'X'
        AND X.CODEQUCOM = eq.CODEQUCOM
        AND eq.CODEQUCOM = v.CODEQUCOM
        AND v.CODTIPEQU = TE.CODTIPEQU
        AND (eq.tip_eq = lvv_tipo_equ OR lvv_tipo_equ = 'TODOS')
        and TE.TIPO in ('DECODIFICADOR');

   CURSOR C_EQU_SGA_CTV_OLD(lln_codsolot number, lvv_tipo_equ varchar2) IS
     select distinct x.codinssrv,
                     x.codsrv,
                     x.pid,
                     x.iddet,
                     x.cantidad,
                     x.tipsrv,
                     eq.tip_eq,
                     eq.codequcom,
                     eq.dscequ,
                     te.tipo,
                     te.codtipequ,
                     te.tipequ
       from (select distinct s.codsolot,
                             ip.pid,
                             ip.codequcom,
                             ip.cantidad,
                             ip.iddet,
                             iv.tipsrv,
                             iv.codsrv,
                             iv.codinssrv
               from solot s, solotpto sp, insprd ip, inssrv iv
              where s.codsolot = sp.codsolot
                and sp.codinssrv = iv.codinssrv
                and ip.codinssrv = iv.codinssrv
                and s.codsolot in (lln_codsolot)
                AND ip.estinsprd IN (1, 2)
                AND iv.tipsrv IN ('0062')) X,
            vtaequcom eq,
            EQUCOMXOPE v,
            TIPEQU TE
      WHERE nvl(X.codequcom, 'X') != 'X'
        AND X.CODEQUCOM = eq.CODEQUCOM
        AND eq.CODEQUCOM = v.CODEQUCOM
        AND v.CODTIPEQU = TE.CODTIPEQU
        AND (eq.tip_eq = lvv_tipo_equ OR lvv_tipo_equ = 'TODOS')
        and TE.TIPO in ('DECODIFICADOR');

   CURSOR C_EQU_SGA_INT(ln_codsolot NUMBER) IS
     select distinct x.codinssrv,
                     x.codsrv,
                     x.pid,
                     x.iddet,
                     x.cantidad,
                     x.tipsrv,
                     eq.tip_eq,
                     eq.codequcom,
                     eq.dscequ,
                     te.tipo,
                     te.codtipequ,
                     te.tipequ
       from (select distinct s.codsolot,
                             ip.pid,
                             ip.codequcom,
                             ip.cantidad,
                             ip.iddet,
                             iv.tipsrv,
                             iv.codsrv,
                             iv.codinssrv
               from solot s, solotpto sp, insprd ip, inssrv iv
              where s.codsolot = sp.codsolot
                and sp.codinssrv = iv.codinssrv
                and ip.codinssrv = iv.codinssrv
                and s.codsolot in (ln_codsolot)
                AND iv.tipsrv IN ('0006')) X,
            vtaequcom eq,
            EQUCOMXOPE v,
            TIPEQU TE
      WHERE nvl(X.codequcom, 'X') != 'X'
        AND X.CODEQUCOM = eq.CODEQUCOM
        AND eq.CODEQUCOM = v.CODEQUCOM
        AND v.CODTIPEQU = TE.CODTIPEQU
        and TE.TIPO in ('EMTA', 'CPE', 'SMART CARD');
 BEGIN

   SELECT s.cod_id_old,
          s.codsolot,
          s.codcli,
          cod_id,
          s.tiptra,
          operacion.pq_sga_iw.f_max_sot_x_cod_id(s.cod_id_old),
          s.customer_id
     INTO V_COD_ID_OLD,
          V_CODSOLOT_NEW,
          V_CODCLI,
          V_COD_ID_NEW,
          tipo_trabajo,
          V_CODSOLOT_OLD,
          V_CUSTOMER_ID
     FROM solot s, wf w
    WHERE s.codsolot = w.codsolot
      and w.idwf = K_IDWF
      AND w.valido = 1;

   ln_flag_cp := operacion.pq_sga_bscs.f_get_is_cp_hfc(V_CODSOLOT_NEW);

   IF ln_flag_cp > 0 THEN
     IF NVL(V_CODSOLOT_OLD, 0) = 0 THEN
       V_CODSOLOT_OLD := 0;
     END IF;

     delete from OPERACION.SGAT_VISITA_PROTOTYPE
      where codsolot_new = V_CODSOLOT_NEW;
     commit;

     IF V_CODSOLOT_OLD <> 0 THEN
       -- Inicia Proceso de Comparacion
       LN_GET_CTV_OLD := SGAFUN_VAL_TIPSRV_OLD(V_CODSOLOT_OLD, '0062'); -- CTV;
       LN_GET_INT_OLD := SGAFUN_VAL_TIPSRV_OLD(V_CODSOLOT_OLD, '0006'); -- INT;
       LN_GET_TLF_OLD := SGAFUN_VAL_TIPSRV_OLD(V_CODSOLOT_OLD, '0004'); -- TLF;

       LN_GET_CTV_NEW := SGAFUN_VAL_TIPSRV_OLD(V_CODSOLOT_NEW, '0062'); -- CTV;
       LN_GET_INT_NEW := SGAFUN_VAL_TIPSRV_OLD(V_CODSOLOT_NEW, '0006'); -- INT;
       LN_GET_TLF_NEW := SGAFUN_VAL_TIPSRV_OLD(V_CODSOLOT_NEW, '0004'); -- TLF;

       -- Valores Generales
       lr_tabla_srv.co_id            := V_COD_ID_NEW;
       lr_tabla_srv.customer_id      := V_CUSTOMER_ID;
       lr_tabla_srv.cod_cli          := V_CODCLI;
       lr_tabla_srv.codsolot_new     := V_CODSOLOT_NEW;
       lr_tabla_srv.codsolot_old     := V_CODSOLOT_OLD;
       lr_tabla_srv.tipo_transaccion := SGAFUN_GET_TIPO_TEC(V_COD_ID_NEW);
       -- EVALUO INTERNET
       if LN_GET_INT_NEW > 0 and LN_GET_INT_OLD = 0 and LN_GET_TLF_OLD = 0 then
         lr_tabla_srv.tipo_accion := 'Instalar';
         lr_tabla_srv.Accion      := 4;

         FOR C_FILA IN C_EQU_SGA_INT(V_CODSOLOT_NEW) LOOP
           lr_tabla_srv.pid          := C_FILA.pid;
           lr_tabla_srv.codsrv       := C_FILA.codsrv;
           lr_tabla_srv.codinssrv    := C_FILA.codinssrv;
           lr_tabla_srv.codequcom    := C_FILA.codequcom;
           lr_tabla_srv.tipequ       := C_FILA.tipequ;
           lr_tabla_srv.cantidad_equ := C_FILA.cantidad;
           lr_tabla_srv.tipo_srv     := C_FILA.tipsrv;
           lr_tabla_srv.iddet        := C_FILA.IDDET;
           lr_tabla_srv.Codtipequ    := C_FILA.CODTIPEQU;
           lr_tabla_srv.tip_eq       := C_FILA.tip_eq;

           INSERT INTO OPERACION.SGAT_VISITA_PROTOTYPE values lr_tabla_srv;
         END LOOP;

       elsif LN_GET_INT_NEW = 0 and LN_GET_INT_OLD > 0 and
             LN_GET_TLF_NEW = 0 then

         lr_tabla_srv.tipo_accion := 'Retirar';
         lr_tabla_srv.Accion      := 12;

         FOR C_FILA IN C_EQU_SGA_INT(V_CODSOLOT_OLD) LOOP
           lr_tabla_srv.pid          := C_FILA.pid;
           lr_tabla_srv.codsrv       := C_FILA.codsrv;
           lr_tabla_srv.codinssrv    := C_FILA.codinssrv;
           lr_tabla_srv.codequcom    := C_FILA.codequcom;
           lr_tabla_srv.tipequ       := C_FILA.tipequ;
           lr_tabla_srv.cantidad_equ := C_FILA.cantidad;
           lr_tabla_srv.tipo_srv     := C_FILA.tipsrv;
           lr_tabla_srv.iddet        := C_FILA.IDDET;
           lr_tabla_srv.Codtipequ    := C_FILA.CODTIPEQU;
           lr_tabla_srv.tip_eq       := C_FILA.tip_eq;
           INSERT INTO OPERACION.SGAT_VISITA_PROTOTYPE values lr_tabla_srv;

         END LOOP;

       ELSIF LN_GET_INT_NEW > 0 AND LN_GET_INT_OLD > 0 THEN

         LV_CODEQUCOM_OLD := SGAFUN_GET_CODEQU_OLD(V_CODSOLOT_OLD);
         LV_CODEQUCOM_NEW := SGAFUN_GET_CODEQU_OLD(V_CODSOLOT_NEW);

         IF SGAFUN_val_cfg_codequcom(NVL(LV_CODEQUCOM_NEW, 'X'),
                                     NVL(LV_CODEQUCOM_OLD, 'X')) = 1 AND

            LV_CODEQUCOM_NEW != LV_CODEQUCOM_OLD THEN
           -- Retiro el equipo anterior
           FOR C_FILA IN C_EQU_SGA_INT(V_CODSOLOT_OLD) LOOP
             lr_tabla_srv.tipo_accion  := 'Retirar';
             lr_tabla_srv.Accion       := 12;
             lr_tabla_srv.pid          := C_FILA.pid;
             lr_tabla_srv.codsrv       := C_FILA.codsrv;
             lr_tabla_srv.codinssrv    := C_FILA.codinssrv;
             lr_tabla_srv.codequcom    := C_FILA.codequcom;
             lr_tabla_srv.tipequ       := C_FILA.tipequ;
             lr_tabla_srv.cantidad_equ := C_FILA.cantidad;
             lr_tabla_srv.tipo_srv     := C_FILA.tipsrv;
             lr_tabla_srv.iddet        := C_FILA.IDDET;
             lr_tabla_srv.Codtipequ    := C_FILA.CODTIPEQU;
             lr_tabla_srv.tip_eq       := C_FILA.tip_eq;
             INSERT INTO OPERACION.SGAT_VISITA_PROTOTYPE
             values lr_tabla_srv;
           END LOOP;
           -- Instalo el nuevo equipo
           lr_tabla_srv.tipo_accion := 'Instalar';
           lr_tabla_srv.Accion      := 4;
         ELSE
           -- Mantiene el equipo que existe
           lr_tabla_srv.tipo_accion := 'Refrescar';
           lr_tabla_srv.Accion      := 15;
         END IF;

         FOR C_FILA IN C_EQU_SGA_INT(V_CODSOLOT_NEW) LOOP
           lr_tabla_srv.pid          := C_FILA.pid;
           lr_tabla_srv.codsrv       := C_FILA.codsrv;
           lr_tabla_srv.codinssrv    := C_FILA.codinssrv;
           lr_tabla_srv.codequcom    := C_FILA.codequcom;
           lr_tabla_srv.tipequ       := C_FILA.tipequ;
           lr_tabla_srv.cantidad_equ := C_FILA.cantidad;
           lr_tabla_srv.tipo_srv     := C_FILA.tipsrv;
           lr_tabla_srv.iddet        := C_FILA.IDDET;
           lr_tabla_srv.Codtipequ    := C_FILA.CODTIPEQU;
           lr_tabla_srv.tip_eq       := C_FILA.tip_eq;
           INSERT INTO OPERACION.SGAT_VISITA_PROTOTYPE values lr_tabla_srv;
         END LOOP;
       END IF;

       -- Equipos CTV
       IF LN_GET_CTV_NEW > 0 THEN
         FOR FILA IN C_DECO_SGA_NEW(V_CODSOLOT_NEW) LOOP
           IF LN_GET_CTV_OLD > 0 THEN
             FOR X IN C_DECO_SGA_OLD(V_CODSOLOT_OLD) LOOP

               IF FILA.tip_eq = X.tip_eq THEN

                 LV_TIP_EQ := X.TIP_EQ;

                 IF (FILA.CANTIDAD = X.CANTIDAD) THEN
                   -- Decos y Cantidades =s Refresco considerando EQ de SOT_NEW
                   lr_tabla_srv.tipo_accion := 'Refrescar';
                   lr_tabla_srv.Accion      := 15;
                   FOR C_FILA IN C_EQU_SGA_CTV(V_CODSOLOT_NEW, LV_TIP_EQ) LOOP
                     lr_tabla_srv.pid          := C_FILA.pid;
                     lr_tabla_srv.codsrv       := C_FILA.codsrv;
                     lr_tabla_srv.codinssrv    := C_FILA.codinssrv;
                     lr_tabla_srv.codequcom    := C_FILA.codequcom;
                     lr_tabla_srv.tipequ       := C_FILA.tipequ;
                     lr_tabla_srv.cantidad_equ := C_FILA.cantidad;
                     lr_tabla_srv.tipo_srv     := C_FILA.tipsrv;
                     lr_tabla_srv.iddet        := c_fila.iddet;
                     lr_tabla_srv.codtipequ    := c_fila.codtipequ;
                     lr_tabla_srv.tip_eq       := C_FILA.tip_eq;
                     INSERT INTO OPERACION.SGAT_VISITA_PROTOTYPE
                     values lr_tabla_srv;
                   END LOOP;
                 ELSE
                   IF (nvl(FILA.CANTIDAD, 0) > nvl(X.CANTIDAD, 0)) THEN
                     FLG_IGUAL := 1;
                     FOR C_FILA IN C_EQU_SGA_CTV(V_CODSOLOT_NEW, LV_TIP_EQ) LOOP
                       FLG_IGUAL                 := FLG_IGUAL + 1;
                       lr_tabla_srv.pid          := C_FILA.pid;
                       lr_tabla_srv.codsrv       := C_FILA.codsrv;
                       lr_tabla_srv.codinssrv    := C_FILA.codinssrv;
                       lr_tabla_srv.codequcom    := C_FILA.codequcom;
                       lr_tabla_srv.tipequ       := C_FILA.tipequ;
                       lr_tabla_srv.cantidad_equ := C_FILA.cantidad;
                       lr_tabla_srv.tipo_srv     := C_FILA.tipsrv;
                       lr_tabla_srv.iddet        := c_fila.iddet;
                       lr_tabla_srv.codtipequ    := c_fila.codtipequ;
                       lr_tabla_srv.tip_eq       := C_FILA.tip_eq;
                       IF FLG_IGUAL <=
                          (nvl(FILA.CANTIDAD, 0) - nvl(X.CANTIDAD, 0)) THEN
                         lr_tabla_srv.tipo_accion := 'Instalar';
                         lr_tabla_srv.Accion      := 4;
                       else
                         lr_tabla_srv.tipo_accion := 'Refrescar';
                         lr_tabla_srv.Accion      := 15;
                       END IF;

                       INSERT INTO OPERACION.SGAT_VISITA_PROTOTYPE
                       values lr_tabla_srv;

                     END LOOP;
                   ELSE
                     FLG_IGUAL := 1;
                     FOR X IN C_EQU_SGA_CTV_OLD(V_CODSOLOT_OLD, LV_TIP_EQ) LOOP
                       lr_tabla_srv.pid          := X.pid;
                       lr_tabla_srv.codsrv       := X.codsrv;
                       lr_tabla_srv.codinssrv    := X.codinssrv;
                       lr_tabla_srv.codequcom    := X.codequcom;
                       lr_tabla_srv.tipequ       := X.tipequ;
                       lr_tabla_srv.cantidad_equ := X.cantidad;
                       lr_tabla_srv.tipo_srv     := X.tipsrv;
                       lr_tabla_srv.iddet        := X.iddet;
                       lr_tabla_srv.codtipequ    := X.codtipequ;
                       lr_tabla_srv.tip_eq       := x.tip_eq;
                       IF FLG_IGUAL <=
                          (nvl(X.CANTIDAD, 0) - nvl(FILA.CANTIDAD, 0)) THEN
                         lr_tabla_srv.tipo_accion := 'Retirar';
                         lr_tabla_srv.Accion      := 15;
                         /*else
                         lr_tabla_srv.tipo_accion := 'Refrescar';*/
                       END IF;
                       INSERT INTO OPERACION.SGAT_VISITA_PROTOTYPE
                       values lr_tabla_srv;
                       FLG_IGUAL := FLG_IGUAL + 1;
                     END LOOP;
                   END IF;
                 END IF;
                 --
               ELSIF FILA.TIP_EQ != X.TIP_EQ THEN
                 -- EQUIPOS A RETIRAR
                 LV_TIP_EQ := X.tip_eq;

                 FOR C_FILA IN C_EQU_SGA_CTV_OLD(V_CODSOLOT_OLD, LV_TIP_EQ) LOOP

                   lr_tabla_srv.tipo_accion  := 'Retirar';
                   lr_tabla_srv.accion       := 12;
                   lr_tabla_srv.pid          := C_FILA.pid;
                   lr_tabla_srv.codsrv       := C_FILA.codsrv;
                   lr_tabla_srv.codinssrv    := C_FILA.codinssrv;
                   lr_tabla_srv.codequcom    := C_FILA.codequcom;
                   lr_tabla_srv.tipequ       := C_FILA.tipequ;
                   lr_tabla_srv.cantidad_equ := C_FILA.cantidad;
                   lr_tabla_srv.tipo_srv     := C_FILA.tipsrv;
                   lr_tabla_srv.iddet        := c_fila.iddet;
                   lr_tabla_srv.codtipequ    := c_fila.codtipequ;
                   lr_tabla_srv.tip_eq       := C_FILA.tip_eq;

                   INSERT INTO OPERACION.SGAT_VISITA_PROTOTYPE
                   values lr_tabla_srv;
                 END LOOP;
                 -- EQUIPOS A INSTALAR
                 LV_TIP_EQ := FILA.TIP_EQ;

                 FOR C_FILA IN C_EQU_SGA_CTV(V_CODSOLOT_NEW, LV_TIP_EQ) LOOP
                   lr_tabla_srv.tipo_accion  := 'Instalar';
                   lr_tabla_srv.accion       := 4;
                   lr_tabla_srv.pid          := C_FILA.pid;
                   lr_tabla_srv.codsrv       := C_FILA.codsrv;
                   lr_tabla_srv.codinssrv    := C_FILA.codinssrv;
                   lr_tabla_srv.codequcom    := C_FILA.codequcom;
                   lr_tabla_srv.tipequ       := C_FILA.tipequ;
                   lr_tabla_srv.cantidad_equ := C_FILA.cantidad;
                   lr_tabla_srv.tipo_srv     := C_FILA.tipsrv;
                   lr_tabla_srv.iddet        := c_fila.iddet;
                   lr_tabla_srv.codtipequ    := c_fila.codtipequ;
                   lr_tabla_srv.tip_eq       := C_FILA.tip_eq;

                   INSERT INTO OPERACION.SGAT_VISITA_PROTOTYPE
                   values lr_tabla_srv;
                 END LOOP;
               END IF;
             END LOOP;
           ELSE
             --ini 7.0
             if ln_flag_insta = 0 then
               
               lr_tabla_srv.tipo_accion := 'Instalar';
               lr_tabla_srv.accion      := 4;
               
               FOR C_FILA IN C_EQU_SGA_CTV(V_CODSOLOT_NEW, 'TODOS') LOOP
                 lr_tabla_srv.pid          := C_FILA.pid;
                 lr_tabla_srv.codsrv       := C_FILA.codsrv;
                 lr_tabla_srv.codinssrv    := C_FILA.codinssrv;
                 lr_tabla_srv.codequcom    := C_FILA.codequcom;
                 lr_tabla_srv.tipequ       := C_FILA.tipequ;
                 lr_tabla_srv.cantidad_equ := C_FILA.cantidad;
                 lr_tabla_srv.tipo_srv     := C_FILA.tipsrv;
                 lr_tabla_srv.iddet        := c_fila.iddet;
                 lr_tabla_srv.codtipequ    := c_fila.codtipequ;
                 lr_tabla_srv.tip_eq       := C_FILA.tip_eq;

                 INSERT INTO OPERACION.SGAT_VISITA_PROTOTYPE values lr_tabla_srv;
               END LOOP;
               
               ln_flag_insta := 1;
               
             end if;
             --fin 7.0
             
           END IF;
           
         END LOOP;
         
       ELSE
         IF LN_GET_CTV_OLD > 0 THEN
           FOR C_FILA IN C_EQU_SGA_CTV_OLD(V_CODSOLOT_OLD, 'TODOS') LOOP
             lr_tabla_srv.tipo_accion  := 'Retirar';
             lr_tabla_srv.accion       := 12;
             lr_tabla_srv.pid          := C_FILA.pid;
             lr_tabla_srv.codsrv       := C_FILA.codsrv;
             lr_tabla_srv.codinssrv    := C_FILA.codinssrv;
             lr_tabla_srv.codequcom    := C_FILA.codequcom;
             lr_tabla_srv.tipequ       := C_FILA.tipequ;
             lr_tabla_srv.cantidad_equ := C_FILA.cantidad;
             lr_tabla_srv.tipo_srv     := C_FILA.tipsrv;
             lr_tabla_srv.iddet        := c_fila.iddet;
             lr_tabla_srv.codtipequ    := c_fila.codtipequ;
             lr_tabla_srv.tip_eq       := C_FILA.tip_eq;
             INSERT INTO OPERACION.SGAT_VISITA_PROTOTYPE
             values lr_tabla_srv;
           END LOOP;
         END IF;
       END IF;

     END IF;
   END IF;
 EXCEPTION
   WHEN OTHERS THEN
     V_MSJ_ERR := 'ERROR : ' || $$PLSQL_UNIT || '.' ||
                  'SGASS_PROC_SRV_COMPARA, ' || CHR(13) || ' CODSOLOT_NEW: ' ||
                  TO_CHAR(V_CODSOLOT_NEW) || CHR(13) || ' K_IDTAREAWF: '||
                  K_IDTAREAWF || CHR(13) || ' K_TAREADEF: '||
                  K_TAREADEF || CHR(13) || ' K_TAREA: '||
                  K_TAREA || CHR(13) ||' CODIGO DE ERROR: ' ||
                  TO_CHAR(SQLCODE) || CHR(13) || 'MENSAJE DE ERROR: ' ||
                  TO_CHAR(SQLERRM);
     RAISE_APPLICATION_ERROR(-20000,
                             V_MSJ_ERR || CHR(13) || ' TRAZA DE ERROR:   ' ||
                             DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
 END;

--ini v2.0
  /****************************************************************
  * Nombre SP : SGAFUN_des_tipsrv_new
  * Propósito : Obtiene las descripciones de los servicios nuevos
  * Input  : av_cod_id      - Id. CoId.
             av_tipsrv      - Id. de Tipo de Servicio

  * Output :  -
  * Creado por : -
  * Fec Creación : 11/09/2018
  * Fec Actualización :
  ****************************************************************/
    FUNCTION SGAFUN_des_tipsrv_new(av_cod_id operacion.sga_visita_tecnica_siac.co_id%TYPE,
                                   av_tipsrv sales.tystabsrv.tipsrv%type)
    RETURN VARCHAR2 IS
    ln_return VARCHAR2(300);
  BEGIN

    SELECT t.dscsrv
      INTO ln_return
      FROM sales.servicio_sisact s,
           tystabsrv t,
           (select o.codigon, o.codigon_aux
              from tipopedd t, opedd o
             where t.tipopedd = o.tipopedd
               and t.abrev = 'IDPRODUCTOCONTINGENCIA') xx,
           operacion.sga_visita_tecnica_siac ser
     WHERE s.codsrv = t.codsrv
       and xx.codigon = t.idproducto
       AND s.idservicio_sisact = TRIM(ser.cod_serv_sisact)
       and ser.co_id = av_cod_id
       AND t.tipsrv = av_tipsrv
       GROUP BY t.dscsrv;

    RETURN ln_return;
  exception
    when others then
      RETURN 0;
  END;

  /****************************************************************
  * Nombre SP : SGAFUN_des_tipsrv_old
  * Propósito : Obtiene las descripciones de los servicios old
  * Input  : an_codsolot      - Id. Solot
             av_tipsrv      - Id. de Tipo de Servicio

  * Output :  -
  * Creado por : -
  * Fec Creación : 11/09/2018
  * Fec Actualización :
  ****************************************************************/
  FUNCTION SGAFUN_des_tipsrv_old(an_codsolot operacion.solot.codsolot%TYPE,
                                 av_tipsrv   tystipsrv.tipsrv%TYPE) RETURN VARCHAR2 IS
    ln_return VARCHAR2(300);
  BEGIN

    --4.0 Ini
    SELECT DISTINCT T.DSCSRV INTO ln_return
       FROM solotpto  pto,
            inssrv    i,
            tystabsrv t
      WHERE pto.codinssrv = i.codinssrv
        AND i.codsrv = t.codsrv
        AND pto.codsolot =  an_codsolot
       AND i.tipsrv = av_tipsrv;

    --4.0 Fin

    RETURN ln_return;
  exception
    when others then
      RETURN 0;
  END;

  /****************************************************************
  * Nombre SP : SGASS_EVAL_INTERNET
  * Propósito : Obtiene las descripciones de los servicios old
  * Input  : an_codsolot      - Id. Solot
             AV_CODSRV_PVU    - Cod Servicio PVU
             AN_FLAG          - Flag de salida

  * Output :  -
  * Creado por : -
  * Fec Creación : 11/09/2018
  * Fec Actualización :
  ****************************************************************/
  PROCEDURE SGASS_EVAL_INTERNET(AN_CODSOLOT   OPERACION.SOLOT.CODSOLOT%TYPE,
                                AV_CODSRV_PVU VARCHAR2,
                                AN_FLAG       OUT NUMBER,
                                AN_ERROR      OUT NUMBER,
                                AV_ERROR      OUT VARCHAR2) IS

    LN_VELOCIDAD NUMBER;
    EXC_VEL_ACT EXCEPTION; --1.0
    EXC_VEL_NEW EXCEPTION; --1.0
    LN_VELOCIDAD_ACT NUMBER; --1.0
  BEGIN

    AN_ERROR := 0;
    AV_ERROR := 'OK';

    BEGIN
      select distinct a.banwid
        into ln_velocidad_act
        from inssrv i, tystabsrv a, insprd ip
       where a.codsrv = ip.codsrv
         and i.codinssrv = ip.codinssrv
         and i.codinssrv in
             (select distinct s.codinssrv
                from solotpto s
               where s.codsolot = an_codsolot)
         and ip.flgprinc = 1
         and a.tipsrv = '0006'
         and ip.estinsprd in (1, 2);

    EXCEPTION
      WHEN OTHERS THEN
        RAISE EXC_VEL_ACT;
    END;
    BEGIN
      select distinct ser.banwid
        into ln_velocidad
        from sales.servicio_sisact ss, tystabsrv ser
       where ss.codsrv = ser.codsrv
         and ss.idservicio_sisact = av_codsrv_pvu;
    EXCEPTION
      WHEN OTHERS THEN
        RAISE EXC_VEL_NEW;
    END;

    IF LN_VELOCIDAD <= LN_VELOCIDAD_ACT THEN
      AN_FLAG := 0; ---Downgrade
      return;
    ELSE
      AN_FLAG := 1; ---Upgrade
      return;
    END IF;
  EXCEPTION
    WHEN EXC_VEL_NEW THEN
      AN_FLAG  := -1;
      AN_ERROR := -1;
      AV_ERROR := 'El servicio ' || AV_CODSRV_PVU ||
                  ' no esta correctamente configurado en PVUDB';
    WHEN EXC_VEL_ACT THEN
      AN_FLAG  := -1;
      AN_ERROR := -1;
      AV_ERROR := 'La SOT ' || AN_CODSOLOT ||
                  ' no tiene servicio de Internet Activo/Suspendido';
    WHEN OTHERS THEN
      AN_FLAG  := -1;
      AN_ERROR := -1;
      AV_ERROR := 'Ocurrio un error al validar la velocidad y tipo de equipos para servicio de INTERNET';
  END;
--fin v2.0
--3.0 Ini
FUNCTION SGAFUN_CONVERT_MB_KB(PI_ABREV operacion.tipopedd.abrev%type)
  RETURN NUMBER IS
  LN_CONVERT_MB_KB NUMBER := 0;
BEGIN
  SELECT OP.CODIGON
    INTO LN_CONVERT_MB_KB
    FROM operacion.tipopedd tp, operacion.opedd op
   WHERE tp.tipopedd = op.tipopedd
     AND tp.descripcion = 'Conversion de MB a KB'
     AND tp.abrev = PI_ABREV
     AND op.descripcion = 'Valor de equivalencia en Kb'
     AND op.abreviacion = 'Valor Kb';

  RETURN LN_CONVERT_MB_KB;
exception
  when others then
    RETURN 0;
END;
FUNCTION SGAFUN_VAL_VISITA_TEC(PI_COD_ID OPERACION.SOLOT.COD_ID%TYPE,
                               PI_CODSOLOT OPERACION.SOLOT.CODSOLOT%TYPE)
    RETURN NUMBER IS
    LN_FLAG NUMBER;
    LN_PORTADORA NUMBER;
    LN_CONVERT_MB_KB NUMBER := 0;
    LN_VELOCIDAD SALES.TYSTABSRV.BANWID%TYPE;
  BEGIN
    LN_CONVERT_MB_KB := SGAFUN_CONVERT_MB_KB('CON_MB_KB');

    --Obtener la Velocidad del Nuevo Plan
    select distinct ser.banwid
      into LN_VELOCIDAD
      from sales.servicio_sisact             ss,
           tystabsrv                         ser,
           operacion.sga_visita_tecnica_siac vt
     where ss.codsrv = ser.codsrv
       and ss.idservicio_sisact = vt.cod_serv_sisact
       and vt.tipo_srv = 'INT'
       and vt.co_id = PI_COD_ID;

    LN_VELOCIDAD := LN_VELOCIDAD/LN_CONVERT_MB_KB;

    --Obtener el ID de Portadora
    SELECT DISTINCT V.SGAN_ID_PORTADORA
           INTO LN_PORTADORA
           FROM (SELECT DISTINCT IP.PID, IP.CODEQUCOM, IP.CANTIDAD
                   FROM SOLOT S, SOLOTPTO SP, INSPRD IP, INSSRV IV
                  WHERE S.CODSOLOT = SP.CODSOLOT
                    AND SP.CODINSSRV = IV.CODINSSRV
                    AND IP.CODINSSRV = IV.CODINSSRV
                    AND S.CODSOLOT = PI_CODSOLOT) X, -- SOT Actual
                VTAEQUCOM V,
                EQUCOMXOPE EQ,
                TIPEQU TE
          WHERE NVL(X.CODEQUCOM, 'X') != 'X'
            AND X.CODEQUCOM = V.CODEQUCOM
            AND V.CODEQUCOM = EQ.CODEQUCOM
            AND EQ.CODTIPEQU = TE.CODTIPEQU
            AND TE.TIPO IN ('EMTA', 'CPE')
            AND V.TIP_EQ IS NOT NULL;

   LN_FLAG := SGAFUN_VAL_MATRIZ_CP(LN_VELOCIDAD,LN_PORTADORA);

   RETURN LN_FLAG;

  EXCEPTION
    WHEN OTHERS THEN
      LN_FLAG := 2;
      RETURN LN_FLAG;
  END;

  FUNCTION SGAFUN_VAL_MATRIZ_CP(PI_VELOCIDAD SALES.TYSTABSRV.BANWID%TYPE,
                                PI_PORTADORA SALES.SGAT_PORTADORA.SGAN_ID_PORTADORA%TYPE)
    RETURN NUMBER IS
    LN_FLAG NUMBER := 0;
  BEGIN

    --Obtener Flag de Visita Tecnica 0:No Aplica 1:Aplica 2:Error
    select SGAN_FLAG_VISITA
      INTO LN_FLAG
      from SALES.SGAT_MATRIZ_VT_CP
     where SGAN_IDPORTADORA = PI_PORTADORA
       AND PI_VELOCIDAD BETWEEN SGAN_VELOC_MIN AND SGAN_VELOC_MAX;

    RETURN LN_FLAG;
  EXCEPTION
    WHEN OTHERS THEN
      LN_FLAG := 2;
      RETURN LN_FLAG;
  END;
--3.0 Fin
--5.0 Ini
FUNCTION SGAFUN_CHANGE_CADENA(PI_CADENA VARCHAR2,
                              PI_A_BUSCAR VARCHAR2,
                              PI_A_CAMBIAR VARCHAR2)
    RETURN VARCHAR2 IS
  BEGIN
    IF LENGTH(PI_CADENA) > 0 THEN
      IF INSTR(PI_CADENA,PI_A_BUSCAR,1) > 0 THEN
        RETURN TRIM(REPLACE(PI_CADENA,PI_A_BUSCAR,PI_A_CAMBIAR));
      ELSE
        RETURN PI_CADENA;
      END IF;
    ELSE
      RETURN '';
    END IF;
  END ;
--5.0 Fin
END;
/