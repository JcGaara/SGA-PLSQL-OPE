create or replace package body operacion.PKG_SGA_ALINEACION_HFC is
  /****************************************************************************************************
     NOMBRE:        PKG_SGA_ALINEACION_HFC
     DESCRIPCION:   Manejo de SOLOT y Servicios HFC

     Ver        Date        Author              Solicitado por       Descripcion
     ---------  ----------  ------------------- ----------------   ------------------------------------
     1.0        27/04/2017  Danny Sánchez         Sergio Atoche      PROY 28710
     2.0        22/06/2017  Danny Sánchez         Sergio Atoche      PROY 28710
  ****************************************************************************************************/

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        27/04/2017  Danny Sánchez    Alinea los contratos de HFC
  ******************************************************************************/
  PROCEDURE SGASU_ALINEAR_CONTRATO(p_estbscs varchar2,
    p_cod_id operacion.solot.cod_id%type, p_resp OUT number, p_mensaje OUT varchar2)
    IS

    ln_codsolot  number;
    ln_estsol    number(2);
    ln_estsolnew number(2);
    ln_estsrvnew number(2);
    ln_dias      number(8);
    ln_sotant    number;
  ln_estsotfin number(2); --2.0

    PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    p_resp := 1;
    p_mensaje :=  'OK';
    SGASS_DATOS_SOT(p_cod_id, p_estbscs, ln_codsolot, ln_estsol, ln_estsolnew, ln_estsrvnew, ln_dias, ln_sotant);

    IF ln_estsolnew = 0 and ln_estsrvnew = 0 THEN
      IF ln_dias > 0 THEN
        p_resp := 2;
        p_mensaje := 'La SOT del Contrato se encuentra Rechazada menos de 30 días';
      ELSE
        p_resp := 0;
        p_mensaje := 'No entra en el proceso de SGA';--2.0
      END IF;
      ROLLBACK;
      RETURN;
    ELSE
      IF ln_estsol <> ln_estsolnew THEN
        IF  ln_estsolnew = 12 THEN
          SGASU_CERRAR_SOT(ln_codsolot);
        ELSIF ln_estsolnew = 13 THEN
          SGASU_ANULAR_SOT(ln_codsolot);
        END IF;
      END IF;
      
      IF ln_estsrvnew <> 0 THEN
        IF ln_sotant = 0 THEN
          SGASU_ALINEAR_SERVICIOS(ln_codsolot, ln_estsrvnew);
        ELSE
          SGASU_ALINEAR_SERVICIOS(ln_sotant, ln_estsrvnew);
        END IF;
      END IF;
    --Ini 2.0
    SELECT estsol INTO ln_estsotfin
    FROM SOLOT
    WHERE CODSOLOT = ln_codsolot;
    
    p_mensaje := p_mensaje || ', SOT: ' || ln_codsolot || ', ESTADO: ' || ln_estsotfin;
    --Fin 2.0
      COMMIT;
    END IF;

  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      p_resp := -99;
      p_mensaje := 'Error: ' || sqlerrm;
      RETURN;
  END;

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        28/04/2017  Danny Sánchez      Alineacion de servicios
  ******************************************************************************/
  PROCEDURE SGASU_ALINEAR_SERVICIOS(p_codsolot operacion.solot.codsolot%type,
    p_estado number) is

  BEGIN
    UPDATE INSPRD
    SET estinsprd = p_estado
    WHERE PID IN (SELECT i.PID
    FROM INSPRD i, (select distinct a.codinssrv FROM SOLOTPTO a
         WHERE a.CODSOLOT = p_codsolot) s
    WHERE S.CODINSSRV = i.CODINSSRV AND
      i.estinsprd <> p_estado);

    UPDATE INSSRV
    SET estinssrv = p_estado
    WHERE codinssrv IN (SELECT i.codinssrv
    FROM INSSRV i, (select distinct a.codinssrv FROM SOLOTPTO a
         WHERE a.CODSOLOT = p_codsolot) s
    WHERE S.CODINSSRV = i.CODINSSRV AND
      i.estinssrv <> p_estado);

  END;

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        02/05/2017  Danny Sánchez    Obtener datos de la Ultima SOT
  ******************************************************************************/
  PROCEDURE SGASS_DATOS_SOT(p_co_id operacion.solot.cod_id%type,
    p_estbscs varchar2, p_codsolot OUT number, p_estsol OUT number,
    p_estsolnew OUT number, p_estsrvnew OUT number, 
    p_dias OUT number, p_sotant OUT number)is

    ln_tipestsol number(2);
    ln_tiptra    number(4);
    ln_dias      number(8);
    ln_count     number(8);
    ln_tiptraant    number(4);

  BEGIN
    p_estsolnew := 0;
    p_estsrvnew := 0;
    p_dias := 0;
    p_sotant := 0;

    SELECT a.codsolot, a.estsol, a.tiptra, e1.tipestsol, trunc(sysdate - a.fecultest) as dias
      INTO p_codsolot, p_estsol, ln_tiptra, ln_tipestsol, ln_dias
      FROM SOLOT a, estsol e1
      where a.estsol = e1.estsol and
         a.codsolot  =(SELECT max(s.codsolot)
          FROM solot s, estsol e, tiptrabajo t
          WHERE s.estsol = e.estsol AND
          s.tiptra = t.tiptra and t.tiptrs in (1,3,4,5) AND
          s.cod_id = p_co_id); --2.0

    IF p_estsol = 29 THEN
      BEGIN
        SELECT a.COVSV_ESTSOLNEW, a.COVSV_ESTSRVNEW, a.COVSV_DIAS
        INTO p_estsolnew, p_estsrvnew, p_dias
        FROM OPERACION.SGAS_CONF_VALIDASOT A
        WHERE a.COVSV_ESTBSCS = p_estbscs AND a.COVSV_TIPTRA = ln_tiptra AND
        a.COVSV_TIPESTSOL = ln_tipestsol and a.COVSV_ESTSOL = 29 and a.COVSV_ESTADO = 1;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
        RETURN;
      END;
    ELSE
      BEGIN
        SELECT a.COVSV_ESTSOLNEW, a.COVSV_ESTSRVNEW, a.COVSV_DIAS
        INTO p_estsolnew, p_estsrvnew, p_dias
        FROM OPERACION.SGAS_CONF_VALIDASOT A
        WHERE a.COVSV_ESTBSCS = p_estbscs AND a.COVSV_TIPTRA = ln_tiptra AND
        a.COVSV_TIPESTSOL = ln_tipestsol and nvl(a.COVSV_ESTSOL, 0) <> 29 and a.COVSV_ESTADO = 1;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
        RETURN;
      END;
    END IF;

    IF p_estsolnew = 13 AND p_estbscs <> 'h' THEN  --2.0
      BEGIN
        -- Ini 2.0
        IF p_estsolnew = p_estsol THEN
          SGASU_ALINEAR_SERVICIOS(p_codsolot, 3);
        END IF;
        -- Fin 2.0
        
        SELECT count (a.codsolot)
        INTO ln_count
        FROM SOLOT a
        where a.codsolot  = (SELECT max(s.codsolot)
          FROM solot s, estsol e, tiptrabajo t
          WHERE s.estsol = e.estsol AND (e.estsol = 29 OR e.tipestsol = 4) AND
          s.codsolot <> p_codsolot and s.tiptra = t.tiptra and t.tiptrs in (1,3,4,5) AND
          s.cod_id = p_co_id); --2.0
        
        IF ln_count > 0 THEN
          SELECT a.codsolot, a.tiptra
          INTO p_sotant, ln_tiptraant
          FROM SOLOT a
          where a.codsolot  = (SELECT max(s.codsolot)
            FROM solot s, estsol e, tiptrabajo t
            WHERE s.estsol = e.estsol AND (e.estsol = 29 OR e.tipestsol = 4) AND
            s.codsolot <> p_codsolot and s.tiptra = t.tiptra and t.tiptrs in (1,3,4,5) AND
            s.cod_id = p_co_id); -- 2.0

          SELECT a.COVSV_ESTSRVNEW
            INTO p_estsrvnew
            FROM OPERACION.SGAS_CONF_VALIDASOT A
            WHERE a.COVSV_ESTBSCS = 'g' AND a.COVSV_TIPTRA = ln_tiptraant AND
            a.COVSV_ESTADO = 1;
        ELSE          --2.0
          p_estsrvnew := 0;   --2.0
        END IF;
      END;
    END IF;

    IF ln_dias < p_dias THEN
      p_estsolnew := 0;
      p_estsrvnew := 0;
    END IF;
  END;

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        28/04/2017  Jorge Rivas      Cerrar SOT
  ******************************************************************************/
  PROCEDURE SGASU_CERRAR_SOT(p_codsolot operacion.solot.codsolot%type)is

  w_exec    varchar2(3000);
  ll_cont   number(8);  --2.0
  ll_wfdef  number(8);  --2.0
  
  cursor cur is
    select decode(e.tareadef,
                  779,
                  null,
                  299,
                  'operacion.p_ejecuta_activ_desactiv(' || w.codsolot || ', 299, sysdate);',
                  'opewf.pq_wf.p_chg_status_tareawf(' || f.idtareawf || ',4,' || decode(e.tareadef, 667, 8, 668, 8, 4) || ',null,sysdate,sysdate);') sentencia
      from wf w, tareawf f, tareadef e, esttarea t, solot s
     where w.idwf = f.idwf
       and f.tareadef = e.tareadef
       and f.esttarea = t.esttarea
       and w.codsolot = s.codsolot
       and w.codsolot = p_codsolot;
  begin
-- Ini 2.0
    select count(f.idwf)
      into ll_cont
      from wf f
     where f.codsolot = p_codsolot
     and f.valido = 1;
    
    IF ll_cont = 0 THEN
      BEGIN
        SELECT CUSBRA.F_BR_SEL_WF(p_codsolot) INTO ll_wfdef FROM DUAL;
      
        pq_solot.p_asig_wf(p_codsolot, ll_wfdef);
      END;
    END IF;
-- Fin 2.0
    for c in cur loop
      w_exec := c.sentencia;
      if w_exec is not null then
        begin
      w_exec := 'declare begin ' || w_exec || ' end;';
          execute immediate w_exec;
        end;
      end if;
    end loop;
  end;

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        28/04/2017  Jorge Rivas      Anular SOT
  ******************************************************************************/
  PROCEDURE SGASU_ANULAR_SOT(p_codsolot operacion.solot.codsolot%type) is

    ln_estsol operacion.solot.estsol%type;

  BEGIN
    select s.estsol
      INTO ln_estsol
      from solot s
     where s.codsolot = p_codsolot;

    operacion.pq_solot.p_chg_estado_solot(p_codsolot,
                                            13,
                                            ln_estsol,
                                            'SOT Anulada');
  END;

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        02/05/2017  Danny Sánchez    Listar de EAI
  ******************************************************************************/
  PROCEDURE SGASU_CONTRATOS_ERR_EAI(p_resultado OUT t_cursor) is
    V_CURSOR T_CURSOR;
  
  ln_dias number; -- 2.0

  BEGIN
  SELECT B.CODIGON INTO ln_dias FROM operacion.opedd B
  WHERE B.ABREVIACION = 'DIAS_ALI_EAI'; -- 2.0
  
    OPEN V_CURSOR FOR
    SELECT a.co_id, a.servi_cod, a.servd_fecha_reg, a.SERVC_ESTADO
      FROM USRACT.postt_servicioprog_fija@DBL_TIMEAI a,
      contract_all@dbl_bscs_bf ca
      WHERE a.servi_cod in (18,3) and a.SERVC_ESTADO in (2,4,5)
     and a.co_id = ca.co_id and ca.plcode = 1000 and ca.sccode = 6
     and trunc(a.servd_fechaprog) >= trunc(sysdate - ln_dias)
     and trunc(a.servd_fechaprog) <= trunc(sysdate); -- 2.0

    p_resultado := V_CURSOR;

  END;

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        02/05/2017  Danny Sánchez    Listar de BSCS
  ******************************************************************************/
  PROCEDURE SGASS_CONTRATOS_ERR_BSCS(p_resultado OUT t_cursor) is
    V_CURSOR T_CURSOR;

  ln_dias number; --2.0

  BEGIN
  SELECT B.CODIGON INTO ln_dias FROM operacion.opedd B
  WHERE B.ABREVIACION = 'DIAS_ALI_BSCS'; --2.0
  
    OPEN V_CURSOR FOR
   SELECT ca.co_id, ca.customer_id
      from contract_history@dbl_bscs_bf z, contract_all@dbl_bscs_bf ca, rateplan@dbl_bscs_bf r
      where z.co_id = ca.co_id and ca.tmcode = r.tmcode and z.ch_pending = 'X'  and z.ch_status in ('a', 's', 'd')
      and ca.plcode = 1000 and ca.sccode = 6 and z.ch_seqno <> 2 and z.userlastmod = 'USROAC'
      and trunc(z.ch_validfrom) >= trunc(sysdate - ln_dias) AND trunc(z.ch_validfrom) < trunc(sysdate); --2.0

    p_resultado := V_CURSOR;

  END;

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        02/05/2017  Danny Sánchez    Cambiar estado en EAI
  ******************************************************************************/
  PROCEDURE SGASU_ESTADO_PGR_EAI(p_co_id number, p_servi_cod number,
    p_fecha_reg date, p_estado number, p_mensaje varchar2, p_result OUT VARCHAR2) is

  PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    p_result := 'OK';
    UPDATE USRACT.postt_servicioprog_fija@DBL_TIMEAI   --@dbl_sga_timdev1
    SET SERVC_ESTADO = p_estado, SERVV_MEN_ERROR = p_mensaje 
    WHERE co_id = p_co_id
        and servi_cod = p_servi_cod
        and servd_fecha_reg = p_fecha_reg;

    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      p_result := 'ERROR';
  END;

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        02/05/2017  Danny Sánchez    Desactivar contrato en HFC
  ******************************************************************************/
  PROCEDURE SGASU_DESACTIVAR_CONTRATO(p_co_id number, p_servi_cod number,
    p_fecha_reg date, p_resp OUT number) IS
    ln_bscs      number;
    ln_codsolot  number;
    ln_sotant    number;
    ln_estsol    number(2);
    ln_estsolnew number(2);
    ln_estsrvnew number(2);
    ln_dias      number(8);
    ln_error     number;
    lv_error     varchar2(500);
    lv_mensaje   varchar2(500);
    lv_resp      varchar2(500);

    PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    p_resp := 0;
    ln_bscs := TIM.TIM171_PKG_ALINEAC_HFC.BSCSFUN_CONTRACTHIST@DBL_BSCS_BF(p_co_id); --Procedimiento BSCS devuelve 0/1

    IF ln_bscs = 0 THEN
      ROLLBACK;
      RETURN;
    ELSE
      BEGIN
       SGASS_DATOS_SOT(p_co_id, 'h', ln_codsolot, ln_estsol, ln_estsolnew, ln_estsrvnew, ln_dias, ln_sotant);
      END;
    END IF;

    IF ln_estsolnew = 0 and ln_estsrvnew = 0 and ln_dias = 0 THEN
      ROLLBACK;
      RETURN;
    ELSE
      p_resp := 1;
      IF ln_estsolnew = 0 and ln_estsrvnew = 0 and ln_dias > 0 THEN
        lv_mensaje:= 'NO SE REALIZO LA DESACTIVACION DEL CONTRATO DEBIDO A QUE AUN NO HA TRANSCURRIDO LOS 30 DIAS DE RECHAZO';
        SGASU_ESTADO_PGR_EAI(p_co_id, p_servi_cod, p_fecha_reg, 5, lv_mensaje, lv_resp);
      ELSE
        IF ln_estsol <> ln_estsolnew THEN
          IF ln_estsolnew = 13 THEN
            SGASU_ANULAR_SOT(ln_codsolot);
          END IF;
        END IF;
        tim.tim111_pkg_acciones.sp_anula_contrato_bscs@DBL_BSCS_BF(p_co_id, 31, ln_error, lv_error);
        lv_mensaje:= 'SE REALIZO LA DESACTIVACION DEL CONTRATO POR TENER UNA SOT CON MAS DE 30 DIAS DE RECHAZO O ANULADA';
        SGASU_ESTADO_PGR_EAI(p_co_id, p_servi_cod, p_fecha_reg, 5, lv_mensaje, lv_resp);
      END IF;
    END IF;

    COMMIT;

  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      p_resp := -99;
      RETURN;
  END;

/******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        03/05/2017  Conrad Agüero    Obtener Tickler Siac
  ******************************************************************************/
  PROCEDURE SGASS_TICKLER_SIAC(p_cod_id number, p_servi_cod number,
    p_fecha_reg date, p_result OUT VARCHAR2, p_mensaje OUT VARCHAR2 ) is

    lv_xml varchar2(32767);
    v_xml  varchar2(32767);

  BEGIN
    select
      (to_char(substr(a.SERVV_XMLENTRADA@DBL_TIMEAI, 1, 4000)) || case
      when length(a.SERVV_XMLENTRADA@DBL_TIMEAI) > 4000 and length(a.SERVV_XMLENTRADA@DBL_TIMEAI) <= 8000 then
      nvl( to_char(substr(a.SERVV_XMLENTRADA@DBL_TIMEAI, 4001,  8000)),'') end || case
      when length(a.SERVV_XMLENTRADA@DBL_TIMEAI) > 8000 and length(a.SERVV_XMLENTRADA@DBL_TIMEAI) <= 12000 then
      nvl(to_char(substr(a.SERVV_XMLENTRADA@DBL_TIMEAI, 8001,  12000)),'')
      end ) into lv_xml
      from USRACT.postt_servicioprog_fija@DBL_TIMEAI a
        WHERE a.co_id = p_cod_id
        and a.servi_cod = p_servi_cod
        and a.servd_fecha_reg = p_fecha_reg;

    v_xml := operacion.pq_sga_iw.f_retorna_xml_recorta(lv_xml);
    p_result := webservice.pq_ws_sga_iw.f_get_atributo(v_xml,'ticklerCode');
    p_mensaje := 'OK';

  EXCEPTION
     when others then
       p_mensaje := 'Error en SGASS_TICKLER_SIAC --> Nro:' || to_char(SQLCODE) || ' Msg:' || SQLERRM;
  END;

/******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  2.0        21/06/2017  Danny Sánchez    Procesos de BSCS para alineación
  ******************************************************************************/
  PROCEDURE SGASU_ALINEAR_CONTRATO_BSCS(PI_CO_ID IN NUMBER, PI_TIPO_ACCION IN VARCHAR2, PO_COD_RPTA OUT NUMBER, PO_MSJ_RPTA OUT VARCHAR2) IS
  BEGIN
  TIM.TIM171_PKG_ALINEAC_HFC.BSCSSU_ALINEAC_CONTRATO_HFC@DBL_BSCS_BF (PI_CO_ID, PI_TIPO_ACCION, PO_COD_RPTA, PO_MSJ_RPTA);
  END;
  
  PROCEDURE SGASU_ESTADO_CONTRATO_BSCS(PI_COD_ID IN NUMBER, PI_CH_STATUS OUT VARCHAR2,
    PO_COD_RPTA OUT NUMBER, PO_MSJ_RPTA OUT VARCHAR2) IS
  BEGIN
  TIM.TIM171_PKG_ALINEAC_HFC.BSCSSS_ESTADO_CONTRATO_HFC@DBL_BSCS_BF(PI_COD_ID, PI_CH_STATUS,
      PO_COD_RPTA, PO_MSJ_RPTA);
  END;

  FUNCTION SGAFUN_CONTRACTHIST(PI_CO_ID IN NUMBER) RETURN NUMBER IS
  ll_contrac  number;
  BEGIN
    ll_contrac := TIM.TIM171_PKG_ALINEAC_HFC.BSCSFUN_CONTRACTHIST@DBL_BSCS_BF(PI_CO_ID);
  RETURN ll_contrac;
  END;
  
end PKG_SGA_ALINEACION_HFC;
/