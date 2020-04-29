create or replace procedure operacion.sgass_val_orden_visit_cp(an_cod_id          in number,
                                                               an_customer_id     in number,
                                                               an_tmcode          in number,
                                                               an_cod_plan_sisact in number,
                                                               av_trama           in varchar2,
                                                               an_flg_visita      out number,
                                                               an_codmotot        out number,
                                                               an_error           out number,
                                                               av_error           out varchar2) is

  ln_val_contrato_hfc NUMBER;
  ln_val_contrato_lte NUMBER;
  error_tipo_contrato EXCEPTION;
  error_motot_visita  EXCEPTION;
  lv_tipo        VARCHAR2(20) := NULL;
  lv_abrev_motot operacion.opedd.abreviacion%TYPE;
  ln_codsolot    operacion.solot.codsolot%TYPE;
  error_no_sot EXCEPTION;
  ln_val_ctv_old NUMBER;
  ln_val_ctv_new NUMBER;
  ln_val_int_old NUMBER;
  ln_val_int_new NUMBER;
  ln_val_tlf_old NUMBER;
  ln_val_tlf_new NUMBER;
  ln_total_old   number;
  ln_total_new   number;
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

  lr_tabla operacion.sga_visita_tecnica_siac%rowtype;

  ln_cont NUMBER;
  TYPE servicio_type IS RECORD(
    tmcode          varchar2(50),
    codplansisact   varchar2(50),
    cod_serv_sisact VARCHAR2(50),
    sncode          VARCHAR2(50),
    cod_grupo_serv  VARCHAR2(50),
    codtipequ       VARCHAR2(50),
    tipequ          VARCHAR2(50),
    idequipo        VARCHAR2(50),
    cantidad_equ    VARCHAR2(50),
    tipo_srv        VARCHAR2(50));

  TYPE servicios_type IS TABLE OF servicio_type INDEX BY PLS_INTEGER;

  arr_areglo servicios_type;

  cursor c_serv_v is
    select v.cod_serv_sisact, v.idequipo, v.cantidad_equ
      from operacion.sga_visita_tecnica_siac v
     where v.co_id = an_cod_id
       and v.tipo_srv = 'INT';
  --Ini 2.0
  function f_obt_codequcom(av_tipequ varchar2) return varchar2 is
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

  FUNCTION f_val_cfg_val(av_param varchar2) RETURN NUMBER IS
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

  function f_val_cfg_codequcom(av_codequcom_new varchar2,
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
  FUNCTION f_val_tipsrv_old(an_codsolot operacion.solot.codsolot%TYPE,
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
       AND operacion.pq_conciliacion_hfc.f_get_no_es_srv_principal(i.tipsrv,
                                                                   t.idproducto,
                                                                   p.flgprinc) = 1
       AND i.tipsrv = av_tipsrv;
  
    RETURN ln_return;
  exception
    when others then
      RETURN 0;
  END;

  FUNCTION f_val_tipsrv_new(av_cod_id operacion.sga_visita_tecnica_siac.co_id%TYPE,
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
  
    /*    SELECT COUNT(DISTINCT t.tipsrv)
          INTO ln_return
          FROM sales.servicio_sisact s,
               tystabsrv t,
               (select o.codigon, o.codigon_aux
                  from tipopedd t, opedd o
                 where t.tipopedd = o.tipopedd
                   and t.abrev = 'IDPRODUCTOCONTINGENCIA') xx
         WHERE s.codsrv = t.codsrv
           and xx.codigon = t.idproducto
           AND s.idservicio_sisact = TRIM(av_co_ser)
           AND t.tipsrv = av_tipsrv;
    */
    RETURN ln_return;
  exception
    when others then
      RETURN 0;
  END;

  FUNCTION count_rows(p_string VARCHAR2) RETURN NUMBER IS
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
                              '.count_rows(p_string => trama) ' || SQLERRM);
  END;

  FUNCTION fn_divide_cadena(p_cadena IN OUT VARCHAR2) RETURN VARCHAR2 IS
  
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

  function f_get_codmotot_visit(av_tipo varchar2, av_visita varchar2)
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
  
  end;

  procedure p_insert_log_post_siac(an_cod_id      operacion.postventasiac_log.co_id%type,
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
              FROM solot s, solotpto sp, insprd ip, inssrv iv
             WHERE s.codsolot = sp.codsolot
               AND sp.codinssrv = iv.codinssrv
               AND ip.codinssrv = iv.codinssrv
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
             vtaequcom eq
       WHERE nvl(X.codequcom, 'X') != 'X'
         and eq.codequcom = x.codequcom
       group by eq.tip_eq, eq.codequcom;
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
             vtaequcom eq
       WHERE nvl(X.codequcom, 'X') != 'X'
         and eq.codequcom = x.codequcom
       group by eq.tip_eq;
  
    cursor c_equ_pvu is
      select mat.matv_tipo_material tipo_equipo,
             sum(v.cantidad_equ) cantidad
        from operacion.sga_visita_tecnica_siac   v,
             USRPVU.SISACT_AP_MATERIAL@DBL_PVUDB mat
       where mat.matv_codigo = v.idequipo
         and v.co_id = av_cod_id
         and V.TIPO_SRV = 'CTV'
       group by mat.matv_tipo_material;
  
    ln_cont_equ_old number;
    ln_cont_equ_new number;
  BEGIN
    ln_cont_equ_old := 0;
    --Ini 2.0
    lv_val_cfg := f_val_cfg_val('CVEC_CTV');
  
    if lv_val_cfg = 1 then
      FOR xx IN C_EQU_SGA_CP LOOP
        ln_cont_equ_old := ln_cont_equ_old + 1;
      
        ln_cont_equ_new := 0;
      
        for c in c_equ_pvu loop
          ln_cont_equ_new := ln_cont_equ_new + 1;
        
          IF xx.tip_eq = c.tipo_equipo THEN
            IF xx.cantidad = c.cantidad THEN
              if f_val_cfg_codequcom(f_obt_codequcom(c.tipo_equipo),
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
        ln_cont_equ_old := ln_cont_equ_old + 1;
      
        ln_cont_equ_new := 0;
      
        for c in c_equ_pvu loop
          ln_cont_equ_new := ln_cont_equ_new + 1;
        
          IF x.tip_eq = c.tipo_equipo THEN
            IF x.cantidad = c.cantidad THEN
              lv_val_tipequ := 0;
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
    end if; --2.0
  EXCEPTION
    WHEN OTHERS THEN
      RETURN 1;
  END;

  FUNCTION SGAFUN_VAL_INTERNET_EQ(AN_CODSOLOT   OPERACION.SOLOT.CODSOLOT%TYPE,
                                  AV_CODSRV_PVU VARCHAR2,
                                  AV_IDEQUIPO   VARCHAR2,
                                  AN_CO_ID      NUMBER) RETURN NUMBER IS
  
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
  BEGIN
  
    LV_VEL_CONF := OPERACION.PQ_SGA_JANUS.F_GET_CONSTANTE_CONF('CVELINT_VISITEC');
    --Ini 2.0
    lv_val_cfg := f_val_cfg_val('CVEC_INT');
  
    if lv_val_cfg = 1 then
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
           AND TE.TIPO = 'EMTA'
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
    
      LV_CODEQUCOM_NEW := F_OBT_CODEQUCOM(LV_TIPEQU);
    
      IF LV_CODEQUCOM_NEW = LV_CODEQUCOM THEN
        -- Si son iguales 
        RETURN 0;
      END IF;
    
      IF F_VAL_CFG_CODEQUCOM(LV_CODEQUCOM_NEW, LV_CODEQUCOM) = 1 THEN
        RETURN 1;
      ELSE
        RETURN 0;
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
           AND TE.TIPO = 'EMTA'
           AND V.TIP_EQ IS NOT NULL;
      EXCEPTION
        WHEN OTHERS THEN
          RAISE EXC_INTERNET;
      END;
    
      SELECT MAT.MATV_TIPO_MATERIAL
        INTO LN_TIPO_MAT
        FROM USRPVU.SISACT_AP_MATERIAL@DBL_PVUDB MAT
       WHERE MAT.MATV_CODIGO = AV_IDEQUIPO;
    
      SELECT S.SERVV_CAPACIDAD
        INTO LN_VELOCIDAD
        FROM USRPVU.SISACT_AP_SERVICIO@DBL_PVUDB S
       WHERE S.SERVV_CODIGO = AV_CODSRV_PVU;
    
      IF LN_TIPO_MAT_ANT <> LN_TIPO_MAT THEN
        RETURN 1;
      END IF;
    
      IF LN_TIPO_MAT_ANT <> 'DOCSIS3' AND LN_VELOCIDAD >= LV_VEL_CONF THEN
        RETURN 1;
      ELSE
        RETURN 0;
      END IF;
    End if; --2.0
  EXCEPTION
    WHEN EXC_CODEQUCOM_NEW THEN
      RAISE_APPLICATION_ERROR(-20001,
                              'No se encuentra el equipo de Internet para el contrato ' ||
                              AN_CO_ID);
    WHEN EXC_INTERNET THEN
      RAISE_APPLICATION_ERROR(-20001,
                              'La SOT ' || AN_CODSOLOT ||
                              ' del cliente no tiene equipos de Internet');
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20001,
                              'Ocurrio un error al validar la velocidad y tipo de equipos para servicio de INTERNET');
  END;

  FUNCTION F_GET_NOMBRE_EQU(AV_CODEQUCOOM VTAEQUCOM.CODEQUCOM%TYPE)
    RETURN VTAEQUCOM.DSCEQU%TYPE IS
    LV_DESCEQU VTAEQUCOM.DSCEQU%TYPE;
  BEGIN
    SELECT V.DSCEQU
      INTO LV_DESCEQU
      FROM VTAEQUCOM V
     WHERE V.CODEQUCOM = AV_CODEQUCOOM;
    RETURN LV_DESCEQU;
  END;

  FUNCTION SGAFUN_GET_INST_DESIN(AN_CODSOLOT OPERACION.SOLOT.CODSOLOT%TYPE,
                                 AV_COD_ID   OPERACION.SGA_VISITA_TECNICA_SIAC.CO_ID%TYPE)
    RETURN VARCHAR2 IS
  
    --INI 2.0    
    CURSOR C_EQU_SGA_CP IS
      SELECT EQ.TIP_EQ, EQ.CODEQUCOM, SUM(X.CANTIDAD) CANTIDAD
        FROM (SELECT DISTINCT IP.PID, IP.CODEQUCOM, IP.CANTIDAD
                FROM SOLOT S, SOLOTPTO SP, INSPRD IP, INSSRV IV
               WHERE S.CODSOLOT = SP.CODSOLOT
                 AND SP.CODINSSRV = IV.CODINSSRV
                 AND IP.CODINSSRV = IV.CODINSSRV
                 AND S.CODSOLOT = AN_CODSOLOT
                 AND IV.TIPSRV IN ('0062')
                 AND IP.ESTINSPRD IN (1, 2)) X,
             VTAEQUCOM EQ
       WHERE NVL(X.CODEQUCOM, 'X') != 'X'
         AND EQ.CODEQUCOM = X.CODEQUCOM
       GROUP BY EQ.TIP_EQ, EQ.CODEQUCOM
       ORDER BY EQ.TIP_EQ;
  
    CURSOR C_EQU_PVU IS
      SELECT MAT.MATV_TIPO_MATERIAL TIPO_EQUIPO,
             MAT.TIPEQU,
             SUM(V.CANTIDAD_EQU) CANTIDAD
        FROM OPERACION.SGA_VISITA_TECNICA_SIAC   V,
             USRPVU.SISACT_AP_MATERIAL@DBL_PVUDB MAT
       WHERE MAT.MATV_CODIGO = V.IDEQUIPO
         AND V.CO_ID = AV_COD_ID
         AND V.TIPO_SRV = 'CTV'
       GROUP BY MAT.MATV_TIPO_MATERIAL, MAT.TIPEQU
       ORDER BY MAT.MATV_TIPO_MATERIAL;
  
    LV_CODEQUCOM_OLD VTAEQUCOM.CODEQUCOM%TYPE;
    LV_CODEQUCOM_NEW VTAEQUCOM.CODEQUCOM%TYPE;
    LV_TIPEQU        OPERACION.TIPEQU.TIPEQU%TYPE;
    EXC_INTERNET      EXCEPTION;
    EXC_CODEQUCOM_NEW EXCEPTION;
    LV_INSTALAR    VARCHAR2(4000);
    LV_DESINSTALAR VARCHAR2(4000);
    LV_CADENA      VARCHAR2(4000);
    LN_GET_CTV_OLD NUMBER;
    LN_GET_INT_OLD NUMBER;
    LN_GET_CTV_NEW NUMBER;
    LN_GET_INT_NEW NUMBER;
    Resta_Cant     NUMBER;
    L_CADENA       VARCHAR(100);
    L_CADENA2      VARCHAR(100);
    FLG_IGUAL      NUMBER;
  BEGIN
  
    LN_GET_CTV_OLD := F_VAL_TIPSRV_OLD(AN_CODSOLOT, '0062'); -- CTV;
    LN_GET_INT_OLD := F_VAL_TIPSRV_OLD(AN_CODSOLOT, '0006'); -- INT;
  
    LN_GET_CTV_NEW := F_VAL_TIPSRV_NEW(AV_COD_ID, '0062'); -- CTV;
    LN_GET_INT_NEW := F_VAL_TIPSRV_NEW(AV_COD_ID, '0006'); -- INT;
  
    IF LN_GET_INT_OLD > 0 AND LN_GET_INT_NEW > 0 THEN
      BEGIN
        SELECT DISTINCT V.CODEQUCOM
          INTO LV_CODEQUCOM_OLD
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
           AND TE.TIPO = 'EMTA'
           AND V.TIP_EQ IS NOT NULL;
      EXCEPTION
        WHEN OTHERS THEN
          RAISE EXC_INTERNET;
      END;
    
      BEGIN
        SELECT S.TIPEQU
          INTO LV_TIPEQU
          FROM OPERACION.SGA_VISITA_TECNICA_SIAC S
         WHERE S.CO_ID = av_cod_id
           AND S.TIPO_SRV = 'INT';
      EXCEPTION
        WHEN OTHERS THEN
          RAISE EXC_CODEQUCOM_NEW;
      END;
    
      LV_CODEQUCOM_NEW := F_OBT_CODEQUCOM(LV_TIPEQU);
    
      IF F_VAL_CFG_CODEQUCOM(LV_CODEQUCOM_NEW, LV_CODEQUCOM_OLD) = 1 AND
         LV_CODEQUCOM_NEW != LV_CODEQUCOM_OLD THEN
        LV_INSTALAR    := F_GET_NOMBRE_EQU(LV_CODEQUCOM_NEW);
        LV_DESINSTALAR := F_GET_NOMBRE_EQU(LV_CODEQUCOM_OLD);
      END IF;
    END IF;
  
    -- Instalar Decos NEW - OLD ----
    L_CADENA  := '';
    L_CADENA2 := '';
    FLG_IGUAL := 0;
    IF LN_GET_CTV_NEW > 0 THEN
      FOR C IN C_EQU_PVU LOOP
        LV_CODEQUCOM_NEW := F_OBT_CODEQUCOM(C.TIPEQU);
        FOR X IN C_EQU_SGA_CP LOOP
          IF C.TIPO_EQUIPO = X.TIP_EQ THEN
          
            IF C.CANTIDAD > X.CANTIDAD THEN
              --VALIDAR CANTIDADES DE DECOS PARA SABER QUE SE INSTALA
              Resta_Cant := C.CANTIDAD - X.CANTIDAD;
              L_CADENA2  := L_CADENA2 || ' + ' || Resta_Cant || ' ' ||
                            F_GET_NOMBRE_EQU(LV_CODEQUCOM_NEW);
            END IF;
          
            FLG_IGUAL := 1;
          
          END IF;
        
        END LOOP;
      
        IF FLG_IGUAL = 1 THEN
          L_CADENA := L_CADENA;
        ELSE
          L_CADENA := L_CADENA || ' + ' || C.CANTIDAD || ' ' ||
                      F_GET_NOMBRE_EQU(LV_CODEQUCOM_NEW);
        END IF;
        FLG_IGUAL := 0;
      END LOOP;
    
      LV_INSTALAR := LV_INSTALAR || L_CADENA || L_CADENA2;
    
    END IF;
  
    -- Desintalar Decos OLD - NEW ----
    L_CADENA  := '';
    L_CADENA2 := '';
    FLG_IGUAL := 0;
  
    IF LN_GET_CTV_OLD > 0 THEN
      FOR C IN C_EQU_SGA_CP LOOP
        FOR X IN C_EQU_PVU LOOP
          IF C.TIP_EQ = X.TIPO_EQUIPO THEN
            IF C.CANTIDAD > X.CANTIDAD THEN
              --VALIDAR CANTIDADES DE DECOS PARA SABER QUE SE INSTALA
              Resta_Cant := C.CANTIDAD - X.CANTIDAD;
              L_CADENA2  := L_CADENA2 || ' + ' || Resta_Cant || ' ' ||
                            F_GET_NOMBRE_EQU(C.CODEQUCOM);
            
            END IF;
          
            FLG_IGUAL := 1;
          
          END IF;
        END LOOP;
      
        IF FLG_IGUAL = 1 THEN
          L_CADENA := L_CADENA;
        ELSE
          L_CADENA := L_CADENA || ' + ' || C.CANTIDAD || ' ' ||
                      F_GET_NOMBRE_EQU(C.CODEQUCOM);
        END IF;
        FLG_IGUAL := 0;
      
      END LOOP;
    
      LV_DESINSTALAR := LV_DESINSTALAR || L_CADENA || L_CADENA2;
    
    END IF;
  
    ----------------------------------    
    /*
    IF LN_GET_CTV_OLD > 0 AND LN_GET_CTV_NEW > 0 THEN
      FOR X IN C_EQU_SGA_CP LOOP
        FOR C IN C_EQU_PVU LOOP
          IF X.TIP_EQ = C.TIPO_EQUIPO THEN
            IF X.CANTIDAD != C.CANTIDAD THEN
              LV_INSTALAR := LV_INSTALAR;
              -- VALIDAR CANTIDADES DE DECOS PARA SABER QUE SE RETIRA Y QUE SE INSTALA
            END IF;
          END IF;
        END LOOP;
      END LOOP;
    ELSIF LN_GET_CTV_OLD = 0 AND LN_GET_CTV_NEW > 0 THEN
      LV_CODEQUCOM_NEW := NULL;
      FOR C IN C_EQU_PVU LOOP
        LV_CODEQUCOM_NEW := F_OBT_CODEQUCOM(C.TIPEQU);
        LV_INSTALAR      := LV_INSTALAR || ' ' || C.CANTIDAD || ' ' ||
                            F_GET_NOMBRE_EQU(LV_CODEQUCOM_NEW);
      END LOOP;
      
    ELSIF LN_GET_CTV_OLD > 0 AND LN_GET_CTV_NEW = 0 THEN
      FOR X IN C_EQU_SGA_CP LOOP
        LV_DESINSTALAR := LV_DESINSTALAR || ' ' || X.CANTIDAD || ' ' ||
                          F_GET_NOMBRE_EQU(X.CODEQUCOM);
      END LOOP;
      
    END IF;*/
  
    LV_CADENA := 'RETIRAR: ' || LV_DESINSTALAR || '; ' || chr(13) ||
                 'INSTALAR: ' || LV_INSTALAR;
  
    RETURN LV_CADENA;
  
  EXCEPTION
    WHEN OTHERS THEN
      RETURN NULL;
  END;
BEGIN

  delete from operacion.sga_visita_tecnica_siac v
   where v.co_id = an_cod_id;
  commit;

  an_flg_visita := 1; -- Todo se inicializa como Visita Tecnica
  an_codmotot   := NULL;
  an_error      := 0;
  av_error      := 'OK';

  ln_val_ctv_old := 0;
  ln_val_int_old := 0;
  ln_val_tlf_old := 0;
  ln_cont        := 0;
  ln_val_ctv_new := 0;
  ln_val_int_new := 0;
  ln_val_tlf_new := 0;
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
  END IF;

  IF ln_val_contrato_lte != 0 THEN
    lv_tipo        := 'LTE';
    lv_abrev_motot := 'LTE_CON_VISTA';
  END IF;

  -- Cargamos temporalmente el Array
  l_rows    := count_rows(av_trama) - 1;
  l_string  := replace(av_trama, ' ', '');
  l_pointer := 1;
  ln_cont   := 1;

  /*=====================================================================*/
  -- Solo para pruebas (Despues Quitar)
  p_insert_log_post_siac(an_cod_id,
                         an_customer_id,
                         'SGASS_VAL_ORDEN_VISIT_CP',
                         'TRAMA:(' || l_string || ')');

  /*=====================================================================*/

  lr_tabla.co_id         := an_cod_id;
  lr_tabla.customer_id   := an_customer_id;
  lr_tabla.tmcode        := an_tmcode;
  lr_tabla.codplansisact := an_cod_plan_sisact;

  FOR idx IN 1 .. l_rows LOOP
  
    l_delimiter := instr(l_string, ';', 1, idx);
    l_record    := substr(l_string, l_pointer, l_delimiter - l_pointer);
  
    /* arr_areglo(ln_cont).tmcode := an_tmcode;
    arr_areglo(ln_cont).codplansisact := an_cod_plan_sisact;
    arr_areglo(ln_cont).cod_serv_sisact := fn_divide_cadena(l_record);
    arr_areglo(ln_cont).sncode := fn_divide_cadena(l_record);
    arr_areglo(ln_cont).cod_grupo_serv := fn_divide_cadena(l_record);
    arr_areglo(ln_cont).codtipequ := fn_divide_cadena(l_record);
    arr_areglo(ln_cont).tipequ := fn_divide_cadena(l_record);
    arr_areglo(ln_cont).idequipo := fn_divide_cadena(l_record);
    arr_areglo(ln_cont).cantidad_equ := fn_divide_cadena(l_record);
    arr_areglo(ln_cont).tipo_srv := fn_divide_cadena(l_record);*/
  
    lr_tabla.cod_serv_sisact := fn_divide_cadena(l_record);
    lr_tabla.sncode          := fn_divide_cadena(l_record);
    lr_tabla.cod_grupo_serv  := fn_divide_cadena(l_record);
    lr_tabla.codtipequ       := fn_divide_cadena(l_record);
    lr_tabla.tipequ          := fn_divide_cadena(l_record);
    lr_tabla.idequipo        := fn_divide_cadena(l_record);
    lr_tabla.cantidad_equ    := fn_divide_cadena(l_record);
    lr_tabla.tipo_srv        := fn_divide_cadena(l_record);
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

  ln_val_ctv_old := f_val_tipsrv_old(ln_codsolot, '0062'); -- CTV;
  ln_val_int_old := f_val_tipsrv_old(ln_codsolot, '0006'); -- INT;
  ln_val_tlf_old := f_val_tipsrv_old(ln_codsolot, '0004'); -- TLF;

  --Cantidad de Equipos Serv Anterior
  ln_cnt_ctv_old := sgafun_val_cantequ(ln_codsolot, '0062');

  -- Cantidad de Equipos Serv Nuevo
  ln_cnt_ctv_new := sgafun_val_cantequ_new(an_cod_id);

  ln_val_ctv_new := f_val_tipsrv_new(an_cod_id, '0062'); -- CTV;
  ln_val_int_new := f_val_tipsrv_new(an_cod_id, '0006'); -- INT;
  ln_val_tlf_new := f_val_tipsrv_new(an_cod_id, '0004'); -- TLF;
  ln_val_tip_equ := sgafun_val_tipdeco(ln_codsolot, an_cod_id);

  FOR idx IN c_serv_v LOOP
    ln_val_vel_int := sgafun_val_internet_eq(ln_codsolot,
                                             idx.cod_serv_sisact,
                                             idx.idequipo,
                                             an_cod_id);
  END LOOP;

  ln_total_old := ln_val_ctv_old + ln_val_int_old + ln_val_tlf_old;
  ln_total_new := ln_val_ctv_new + ln_val_int_new + ln_val_tlf_new;

  p_insert_log_post_siac(an_cod_id,
                         an_customer_id,
                         'SGASS_VAL_ORDEN_VISIT_CP',
                         'Primero = lv_abrev_motot : ' || lv_abrev_motot ||
                         ' - an_flg_visita : ' || an_flg_visita ||
                         ' - lv_tipo : ' || lv_tipo);

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
      if ln_val_ctv_new > 0 and ln_val_tlf_new > 0 then
      
        -- Validar si se cambio de Deco (Aumento o Reducio)
        if ln_cnt_ctv_old <> ln_cnt_ctv_new or ln_val_tip_equ > 0 then
          an_flg_visita := 1;
        else
          an_flg_visita := 0; -- No Aplica
        end if;
      
        goto salto;
      
      end if;
    
      -- CTV + INT + TLF > CTV + INT
      if ln_val_ctv_new > 0 and ln_val_int_new > 0 then
        an_flg_visita := 0;
        -- Validar si el Equipo de TLF es Recuperable
      
        -- Validar si se cambio de Deco (Aumento o Reducio)
        if ln_cnt_ctv_old <> ln_cnt_ctv_new or ln_val_tip_equ > 0 then
          an_flg_visita := 1;
        else
          -- No Aplica
          an_flg_visita := 0;
        end if;
      
        goto salto;
      end if;
    
      -- CTV + INT + TLF > INT + TLF
      if ln_val_int_new > 0 and ln_val_tlf_new > 0 then
        -- Validar si el Equipo de TV es Recuperable
        if sgafun_val_recuperable(ln_codsolot, '0062') = 1 then
          an_flg_visita := 1;
        else
          an_flg_visita := 0;
        end if;
        goto salto;
      end if;
    
      if ln_val_ctv_new > 0 then
        -- Validar si el Equipo de INT es Recuperable
        if sgafun_val_recuperable(ln_codsolot, '0006') = 1 then
          an_flg_visita := 1;
        else
          an_flg_visita := 0;
        end if;
        goto salto;
      end if;
    
      if ln_val_int_new > 0 then
        -- Validar si el Equipo de TV es Recuperable
        if sgafun_val_recuperable(ln_codsolot, '0062') = 1 then
          an_flg_visita := 1;
        else
          an_flg_visita := 0;
        end if;
        goto salto;
      end if;
    
      if ln_val_tlf_new != 0 then
        -- Validar si el Equipo de TV o INT es Recuperable
        if sgafun_val_recuperable(ln_codsolot, '0062') = 1 or
           sgafun_val_recuperable(ln_codsolot, '0006') = 1 then
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
    if ln_val_ctv_old > 0 and ln_val_int_old > 0 then
      if ln_val_tlf_new > 0 or ln_val_int_new > 0 then
        -- Validar si el Equipo de TV es Recuperable
        if sgafun_val_recuperable(ln_codsolot, '0062') = 1 then
          an_flg_visita := 1;
        else
          an_flg_visita := 0;
        end if;
        goto salto;
      end if;
    
      if ln_val_ctv_new > 0 then
        -- Validar si el Equipo de INT es Recuperable
        if sgafun_val_recuperable(ln_codsolot, '0006') = 1 then
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
    if ln_val_ctv_old > 0 and ln_val_tlf_old > 0 then
    
      if ln_val_tlf_new != 0 or ln_val_int_new != 0 then
        -- Validar si el Equipo de TV es Recuperable
        if sgafun_val_recuperable(ln_codsolot, '0062') = 1 then
          an_flg_visita := 1;
        else
          an_flg_visita := 0;
        end if;
        goto salto;
      end if;
    
      if ln_val_ctv_new != 0 then
        -- Validar si el Equipo de TLF es Recuperable
        if sgafun_val_recuperable(ln_codsolot, '0004') = 1 then
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
    if ln_val_int_old != 0 and ln_val_tlf_old != 0 then
    
      if ln_val_ctv_new != 0 then
        -- Validar si el Equipo de INT es Recuperable
        if sgafun_val_recuperable(ln_codsolot, '0006') = 1 then
          an_flg_visita := 1;
        else
          an_flg_visita := 0;
        end if;
        goto salto;
      end if;
    
      if ln_val_int_new != 0 then
        -- Validar si el Equipo de TLF es Recuperable
        if sgafun_val_recuperable(ln_codsolot, '0004') = 1 then
          an_flg_visita := 1;
        else
          an_flg_visita := 0;
        end if;
        goto salto;
      end if;
    
      if ln_val_tlf_new != 0 then
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
  
    if (ln_val_ctv_new > 0 and ln_val_int_new > 0) and
       (ln_val_ctv_old > 0 and ln_val_int_old > 0) then
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
  
    if (ln_val_ctv_new > 0 and ln_val_tlf_new > 0) and
       (ln_val_ctv_old > 0 and ln_val_tlf_old > 0) then
      -- Validar Cantidad de Deco y Tipo de Deco
      if ln_cnt_ctv_old <> ln_cnt_ctv_new or ln_val_tip_equ > 0 then
        an_flg_visita := 1;
      else
        an_flg_visita := 0;
      end if;
      goto salto;
    end if;
  
    if (ln_val_int_new > 0 and ln_val_tlf_new > 0) and
       (ln_val_int_old > 0 and ln_val_tlf_old > 0) then
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
    if ln_val_int_new > 0 and ln_val_int_new = ln_val_int_old then
      -- Validar Velocidad de INT
      if ln_val_vel_int > 0 then
        an_flg_visita := 1;
      else
        an_flg_visita := 0;
      end if;
      --an_flg_visita := 1;
      goto salto;
    end if;
  
    if ln_val_tlf_new > 0 and ln_val_tlf_new = ln_val_tlf_old then
      -- No Aplica Visita
      an_flg_visita := 0;
      goto salto;
    end if;
  
    if ln_val_ctv_new > 0 and ln_val_ctv_new = ln_val_ctv_old then
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
    an_codmotot := f_get_codmotot_visit(lv_tipo, lv_abrev_motot);
  EXCEPTION
    WHEN OTHERS THEN
      RAISE error_motot_visita;
  END;

  if an_flg_visita != 0 then
    LV_ANOTACION := SGAFUN_GET_INST_DESIN(ln_codsolot, an_cod_id);
    -- Crear un funcion que devuelva que equipos se instalan y que se desintalan
    p_insert_log_post_siac(an_cod_id,
                           an_customer_id,
                           'ANOTACION_ORDEN_VISIT_CP',
                           LV_ANOTACION);
  end if;

  p_insert_log_post_siac(an_cod_id,
                         an_customer_id,
                         'SGASS_VAL_ORDEN_VISIT_CP',
                         'Ultimo = lv_abrev_motot : ' || lv_abrev_motot ||
                         ' - an_flg_visita : ' || an_flg_visita ||
                         ' - lv_tipo : ' || lv_tipo);

EXCEPTION
  WHEN error_no_sot THEN
    an_flg_visita := 1;
    an_error      := -1;
    an_codmotot   := f_get_codmotot_visit(lv_tipo, lv_abrev_motot);
    av_error      := 'Error : No existe SOT de Alta asociado al contrato : ' ||
                     an_cod_id;
    p_insert_log_post_siac(an_cod_id,
                           an_customer_id,
                           'SGASS_VAL_ORDEN_VISIT_CP',
                           'TRAMA:(' || replace(av_trama || ';', ' ', '') || ')' ||
                           av_error);
  
  WHEN error_motot_visita THEN
    an_flg_visita := 1;
    an_error      := -1;
    av_error      := 'Error : No existe un motivo configurado para ' ||
                     lv_tipo || '(Parametro = ' || lv_abrev_motot || ')';
    p_insert_log_post_siac(an_cod_id,
                           an_customer_id,
                           'SGASS_VAL_ORDEN_VISIT_CP',
                           'TRAMA:(' || replace(av_trama || ';', ' ', '') || ')' ||
                           av_error);
  
  WHEN error_tipo_contrato THEN
    an_flg_visita := 1;
    an_error      := -2;
    av_error      := 'Error : El contrato ' || an_cod_id ||
                     ' no es HFC o LTE';
    p_insert_log_post_siac(an_cod_id,
                           an_customer_id,
                           'SGASS_VAL_ORDEN_VISIT_CP',
                           'TRAMA:(' || replace(av_trama || ';', ' ', '') || ')' ||
                           av_error);
  
  WHEN OTHERS THEN
    an_flg_visita := 1;
    an_codmotot   := f_get_codmotot_visit(lv_tipo, lv_abrev_motot);
    an_error      := -99;
    av_error      := 'Error : ' || SQLCODE || ' ' || SQLERRM || ' Linea (' ||
                     dbms_utility.format_error_backtrace || ')';
    p_insert_log_post_siac(an_cod_id,
                           an_customer_id,
                           'SGASS_VAL_ORDEN_VISIT_CP',
                           substr('TRAMA:(' ||
                                  replace(av_trama || ';', ' ', '') || ')' ||
                                  av_error,
                                  1,
                                  4000));
END;
/