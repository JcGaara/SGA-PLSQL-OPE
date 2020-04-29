CREATE OR REPLACE PACKAGE BODY OPERACION.PKG_SGA_WA IS
/*******************************************************************************************************
  NOMBRE:       OPERACION.PKG_SGA_WA
  PROPOSITO:    Paquete de objetos
  REVISIONES:
  Version    Fecha       Autor            Solicitado por    Descripcion
  ---------  ----------  ---------------  --------------    -----------------------------------------
   1.0       11/10/2017  Servicio Fallas-HITSS      INC000000892040
/*******************************************************************************************************/
  PROCEDURE P_ANULA_SOTS_RECHAZADAS is
    ------------------
    -- 1.1 Las SOTs con estado RECHAZADA que tengan una antigüedad mayor o igual que n días.
    -- 1.2 Las SOTs con estado RECHAZADA, que tengan una SOT posterior a ésta con estado ATENDIDA o CERRADA
    -- con el mismo TIPTRA (Tipo de trabajo) y CUSTOMER (Cliente) que la SOT rechazada.
    ------------------
    l_cont            number;
    ln_val_tipser     number;
    an_error          number;
    av_error          varchar2(4000);
    ln_val_co_id_cust number;

    type curtype      is ref cursor;
    type c_reg is record (
      codsolot        number(8),
      cod_id          number,
      estsol          number(2),
      tiptra          number(4),
      customer_id     number);

    c_query           varchar2(5000);
    c_cursor          curtype;
    c                 c_reg;

    ln_contador       number;

    ls_buffer         varchar2(100);
    ln_buffer         number;

  begin

    ls_buffer := OPERACION.PQ_SGA_JANUS.F_GET_CONSTANTE_CONF('SGA_WA_RECHAZAD');
    ln_buffer := to_number(  ls_buffer ) ;
    dbms_output.enable(ln_buffer);     --  setea el buffer

    ln_contador   := 0;
    l_cont        := 0;
    c_query       := F_RETORNA_SELECT(1);

    dbms_output.put_line('SOTs RECHAZADA n dias:');

    open c_cursor for c_query ;    --  C_RECHAZADAS loop
    loop
      fetch c_cursor into c;
      exit when c_cursor%NOTFOUND;

      begin
        l_cont      := l_cont + 1;
        ln_contador := ln_contador +1;

      -- genera log
      dbms_output.put_line(to_char(ln_contador,'999,999') || ' '||to_char(c.codsolot));

           UPDATE OPERACION.AGENDAMIENTO A
        SET A.FLG_ORDEN_ADC = 0
      WHERE A.CODSOLOT = C.CODSOLOT;

      ln_val_tipser := operacion.pq_sga_iw.f_val_tipo_serv_sot(c.codsolot);

      if ln_val_tipser = 3 then
        -- Solo HFC Sisact
        if c.tiptra != 427 and c.tiptra != 695 then

          -- Validamos Contrato BSCS
          p_anula_contrato_bscs(c.cod_id, c.codsolot, an_error, av_error);

          if an_error in (1, 2) then
            -- Activo y facturando en BSCS
            -- Enviamos Baja a JANUS
            p_baja_janus_anu(c.codsolot, an_error, av_error);

            -- Rechazamos la SOT para que el proceso de Marco lo atienda en IW y luego lo anule en su proceso
            operacion.pq_solot.p_chg_estado_solot(c.codsolot,
                                                  20,
                                                  c.estsol,
                                                  'Pre-Anulado por Sistemas por exceso de días. COD_ID :' ||
                                                  c.cod_id);
          end if;

        elsif c.tiptra = 427 OR c.tiptra = 695 then
          -- Para Cambio de Plan

          -- Validamos que el customer no tenga ningun otro contrato Activo
          ln_val_co_id_cust := operacion.pq_sga_iw.f_val_baja_co_id_customer_id(c.customer_id,
                                                                                c.cod_id);

          if ln_val_co_id_cust = 0 then
            -- Validamos Contrato BSCS
            p_anula_contrato_bscs(c.cod_id, c.codsolot, an_error, av_error);

            if an_error in (1, 2) then
              -- Activo y facturando en BSCS
              -- Enviamos Baja a JANUS
              p_baja_janus_anu(c.codsolot, an_error, av_error);

              -- Rechazamos la SOT para que el proceso de Marco lo atienda en IW y luego lo anule en su proceso
              operacion.pq_solot.p_chg_estado_solot(c.codsolot,
                                                    20,
                                                    c.estsol,
                                                    'Pre-Anulado por Sistemas por exceso de días. COD_ID :' ||
                                                    c.cod_id);
            end if;

          elsif ln_val_co_id_cust > 0 then
            -- Tiene al menos un contrato Activo el customer_id, Anulamos la SOT y anulamos venta en BSCS (Sin enviar nada IW y JANUS)

            -- Validamos Contrato BSCS
            p_anula_contrato_bscs(c.cod_id, c.codsolot, an_error, av_error);

            if an_error in (1, 2) then

              operacion.pq_solot.p_chg_estado_solot(c.codsolot,
                                                    13,
                                                    c.estsol,
                                                    'Se Anula SOT por exceso de días. COD_ID : ' ||
                                                    c.cod_id);
            end if;
          end if;

        end if;
      end if;

      if l_cont = 500 then
        commit;
        l_cont := 0;
      end if;
     exception
      when others then
        dbms_output.put_line('ERROR : ' || c.codsolot || ' - Mensaje: ' || sqlerrm);
      end;
    end loop;
    close c_cursor;
    commit;
  end;
  -----------------------------------------------------------------------------------
  PROCEDURE P_ANULA_SOTS_APROBADAS is
    ------------------
    -- 2. Las SOTs con estado APROBADA que tengan una antigüedad de ¿n¿ días y no tenga COD_ID ni CUSTOMER_ID
    ------------------
    type curtype       is ref cursor;
    type c_reg is record (
      codsolot         NUMBER(8),
      estsol           NUMBER(2));

    c_cursor          curtype;
    c_query           varchar2(5000);
    c                 c_reg;
    l_cont            number;
    ln_contador       number;

    ls_buffer         varchar2(100);
    ln_buffer         number;

    begin

      ls_buffer := OPERACION.PQ_SGA_JANUS.F_GET_CONSTANTE_CONF('SGA_WA_RECHAZAD');
      ln_buffer := to_number(  ls_buffer ) ;
      dbms_output.enable(ln_buffer);   --  setea el buffer

      l_cont        := 0;
      ln_contador   := 0 ;

      c_query := F_RETORNA_SELECT(2) ;

      dbms_output.put_line('SOTs APROBADA n dias sin COD_ID, CUSTOMER_ID, SOTs que se anularon:');

      open c_cursor for c_query ;    --  C_APROBADAS loop
      loop
        fetch c_cursor into c;
        exit when c_cursor%NOTFOUND;

        begin
          l_cont      := l_cont + 1;
          ln_contador := ln_contador +1;

          -- gener log
          dbms_output.put_line(to_char(ln_contador,'999,999') || ' '||to_char(c.codsolot));
          pq_solot.p_chg_estado_solot(c.codsolot, 13, c.estsol, 'SOT Anulada');

          if l_cont = 500 then
            commit;
            l_cont := 0;
          end if;
          exception
          when others then
            dbms_output.put_line('ERROR : ' || c.codsolot || ' - Mensaje: ' || sqlerrm);
          end;
      end loop;
    close c_cursor;
    commit;
  end;
  -----------------------------------------------------------------------------------
  procedure p_anula_contrato_bscs(an_cod_id    solot.cod_id%type,
                                  an_codsolot  solot.codsolot%type,
                                  an_resultado out number,
                                  av_msg       out varchar2) is

    ln_estado_bscs     number;
    ln_tipo_liberacion number;

  begin

    ln_tipo_liberacion := operacion.pq_anulacion_bscs.f_config_bscs('ANUL_SOT');

    ln_estado_bscs := operacion.PKG_SGA_WA.f_validar_estado_contrato(an_cod_id);

    if ln_estado_bscs = 0 then
      -- ONHOLD, Activo con pendiente
      /*tim.tim111_pkg_acciones.sp_anula_contrato_bscs@dbl_bscs_bf(an_cod_id,
                                                                 ln_tipo_liberacion,
                                                                 an_resultado,
                                                                 av_msg);*/
      operacion.pq_anulacion_bscs.p_anula_bscs(an_cod_id,
                                                                 ln_tipo_liberacion,
                                                                 an_resultado,
                                                                 av_msg);

      dbms_output.put_line(av_msg);
      if an_resultado = 0 then
        an_resultado := 1;
        dbms_output.put_line('Codsolot : ' || an_codsolot ||
                             ' Se desactivo el contrato : ' || an_cod_id);
      end if;

    elsif ln_estado_bscs in (4, 5) then
      -- Desactivo y Desactivo con pendiente
      an_resultado := 2;
      av_msg       := 'El contrato : ' || an_cod_id ||
                      ' se encuentra desactivo en BSCS';
      dbms_output.put_line('Codsolot : ' || an_codsolot || ' - ' || av_msg);

    elsif ln_estado_bscs in (1, 2, 3) then
      -- Contrato Activo, Suspendido y suspendido sin pendiente
      -- Desactivamos el Contrato o generamos SOT de Baja(Por validar con Melvin).
      an_resultado := -1;
      av_msg       := 'Contrato Activo o Suspendido';
      dbms_output.put_line('Codsolot : ' || an_codsolot || ', COD_ID:' ||
                           an_cod_id || ', Estado :' || ln_estado_bscs);

    end if;

  exception
    when others then
      an_resultado := -1;
      raise_application_error(-20000,
                              $$plsql_unit ||
                              'ERROR procedimiento p_anula_contrato_bscs ' ||
                              sqlerrm);
  end;
  -----------------------------------------------------------------------------------
  procedure p_baja_janus_anu(an_codsolot in number,
                             an_error    out number,
                             av_error    out varchar2) is

    ln_cod_id    solot.cod_id%type;
    lv_codcli    solot.codcli%type;
    ln_customer  solot.customer_id%type;
    lv_numero    inssrv.numero%type;
    ln_codinssrv inssrv.codinssrv%type;
    ln_error     number;
    lv_error     varchar2(4000);
    ln_contador  number;

  begin
    -- Programamos la Baja de la Linea a JANUS.
    operacion.pq_sga_iw.p_cons_numtelefonico_sot(an_codsolot,
                                                 lv_numero,
                                                 lv_codcli,
                                                 ln_cod_id,
                                                 ln_customer,
                                                 ln_codinssrv,
                                                 ln_error,
                                                 lv_error);

    if ln_error = 1 and lv_numero is not null then
      -- No volver a reenviar tramas a JANUS
      select count(1)
        into ln_contador
        from operacion.prov_sga_janus j
       where j.codsolot = an_codsolot
         and j.tipo = 'BAJANUMERO'
         and j.estado = 0;

      if ln_contador = 0 then
        operacion.pq_sga_janus.p_insertxacc_prov_sga_janus(2,
                                                           an_codsolot,
                                                           ln_cod_id,
                                                           ln_customer,
                                                           to_char(ln_customer),
                                                           lv_numero,
                                                           an_error,
                                                           av_error);
      end if;
    end if;

  exception
    when others then
      -- rollback;
      an_error := -1;
      raise_application_error(-20000,
                              $$plsql_unit ||
                              'ERROR procedimiento p_baja_janus_anu ' ||
                              sqlerrm);
  end;
  -----------------------------------------------------------------------------------
  FUNCTION F_RETORNA_SELECT ( P_SELECT NUMBER ) return VARCHAR2 is

  ls_where_1 varchar2(4000);
  ls_where_2 varchar2(4000);
  ls_select varchar2(5000);

  begin
    if P_SELECT = 1 then
        select SENTENCIA into ls_where_1 from operacion.OPE_CONFIG_ACCION_JANUS where TIP_SVR = 'RECHAZADAS_1_WHERE';
        ls_select := ' select s.codsolot, s.cod_id, s.estsol, s.tiptra, s.customer_id
        from solot s, estsol e ' || ls_where_1 ;

        select SENTENCIA into ls_where_2 from operacion.OPE_CONFIG_ACCION_JANUS where TIP_SVR = 'RECHAZADAS_2_WHERE';
        ls_select :=  ls_select ||' UNION select s.codsolot, s.cod_id, s.estsol, s.tiptra, s.customer_id
        from solot s, estsol e ' || ls_where_2 || ' order by codsolot, cod_id, estsol, tiptra, customer_id ';

    elsif P_SELECT = 2 then
          select SENTENCIA into ls_where_1 from operacion.OPE_CONFIG_ACCION_JANUS where TIP_SVR = 'APROBADAS_WHERE';
          ls_select := ' select s.codsolot, s.estsol
        from solot s ' || ls_where_1 ;
    else
      ls_select:='';
    end if;
    return ls_select;
  end ;

  function f_validar_estado_contrato(an_co_id number) return number is
    lv_ch_status varchar2(1);
    lv_ch_pending varchar2(1);
    ln_return number;
  begin
     select c.ch_status, c.ch_pending
     into lv_ch_status, lv_ch_pending
     from contract_history@Dbl_Bscs_Bf c
     where c.co_id = an_co_id
           and c.ch_seqno = (select max(cc.ch_seqno) from contract_history@Dbl_Bscs_Bf cc
                            where cc.co_id = c.co_id);
     ln_return := OPERACION.PQ_SGA_IW.F_RETORNA_SELECT_STATUS(lv_ch_status,lv_ch_pending);
     -- ln_res_estatus:
     -- 0: Onhold y Activo con pendiente
     -- 1: Activo y sin pendiente
     -- 2: Suspendido y sin pendiente
     -- 3: Suspendido y con pendiente
     -- 4: Contrato Desactivo y sin pendiente
     -- 5: Contrato Desactivo y con pendiente
     return ln_return;
  end;


  procedure P_ASIG_BONO_FIJA_FULL_CLARO (MENSAJE OUT VARCHAR2) IS

  CURSOR C_SERV_SISACT IS
      SELECT X.*
        FROM (SELECT R.COD_ID,
                     R.CUSTOMER_ID,
                     R.SNCODE_ACTUAL SNCODE_ACTUAL,
                     SN.DES SNCODE_DES_ACTUAL,
                     (SELECT DISTINCT B.CODSRV
                        FROM SALES.SERVICIO_SISACT               B,
                             USRPVU.SISACT_AP_SERVICIO@DBL_PVUDB A,
                             SOLOT                               S,
                             TIPTRABAJO                          T,
                             INSPRD                              I
                       WHERE B.IDSERVICIO_SISACT = A.SERVV_CODIGO
                         AND A.SERVV_ID_BSCS = TO_CHAR(R.SNCODE_ACTUAL)
                         AND B.CODSRV = I.CODSRV
                         AND S.COD_ID = R.COD_ID
                         AND S.TIPTRA = T.TIPTRA
                         AND T.TIPTRS = 1
                         AND T.TIPTRA IN
                             (658, 676, 695, 678, 814, 693, 427, 412) --ALTAS Y CAMBIO
                         AND I.ESTINSPRD IN (1, 2, 4) --PIDS ACTIVOS
                         AND S.NUMSLC = I.NUMSLC
                         AND I.CODEQUCOM IS NULL) COD_SRV_INICIAL,
                     R.CODSRV_OLD,
                     R.TIPO_SERVICIO,
                     R.TIPO_PRODUCTO,
                    R.FLG_PROCESA,
                     R.ROWID ROW_ID,
                     R.SNCODE_NEW,
                     R.CF_ACTUAL
                FROM SALES.MIGRA_UPGRADE_MASIVO R, MPUSNTAB@DBL_BSCS_BF SN
               WHERE R.SNCODE_ACTUAL = SN.SNCODE
              ) X
       WHERE X.SNCODE_ACTUAL IS NOT NULL
         AND X.FLG_PROCESA = 3
         AND NVL(X.CF_ACTUAL, 0) = 0  --<2.0>
       ORDER BY X.TIPO_SERVICIO;

    CURSOR SERVICIOS IS
      SELECT R.COD_ID,
             R.SNCODE_NEW,
             R.CODSRV_OLD,
             R.ROWID ROW_ID,
             (SELECT B.CODSRV
                FROM SALES.SERVICIO_SISACT               B,
                     USRPVU.SISACT_AP_SERVICIO@DBL_PVUDB A
               WHERE B.IDSERVICIO_SISACT = A.SERVV_CODIGO
                 AND A.SERVV_ID_BSCS = R.SNCODE_NEW) CODSRV
        FROM SALES.MIGRA_UPGRADE_MASIVO R
       WHERE R.SNCODE_NEW IS NOT NULL
         AND R.FLG_PROCESA = 3
         AND NVL(R.CF_ACTUAL, 0) = 0;--<2.0>

      CURSOR C_PIDS IS
        SELECT COD_ID,
             CUSTOMER_ID,
             TIPO_SERVICIO,
             TIPO_PRODUCTO,
             SERVICIO,
             CODSRV_OLD,
             SNCODE_ACTUAL,
             CODSRV_NEW,
             SNCODE_NEW,
             CF_NEW,
             (SELECT I.PID
                FROM SOLOT S, TIPTRABAJO T, INSPRD I
               WHERE S.TIPTRA = T.TIPTRA
                 AND T.TIPTRS = 1
                 AND S.NUMSLC = I.NUMSLC
                 AND T.TIPTRA IN (658, 676, 695, 814, 678, 693, 427, 412) --ALTAS Y CAMBI
                 AND I.ESTINSPRD IN (1, 2, 4) --PIDS ACTIVOS
                 AND I.CODEQUCOM IS NULL
                 AND S.COD_ID = U.COD_ID
                 AND I.CODSRV = U.CODSRV_OLD
                 AND ROWNUM = 1) PID_OLD,
             U.ROWID ROW_ID
        FROM SALES.MIGRA_UPGRADE_MASIVO U
       WHERE FLG_PROCESA = 0
         AND CODSRV_OLD IS NOT NULL
         AND NVL(CF_ACTUAL, 0) = 0;--<2.0>

    CURSOR C_SEQ IS
      SELECT S.ROWID ROW_ID
        FROM SALES.MIGRA_UPGRADE_MASIVO S
       WHERE TRUNC(FECUSU) = TRUNC(SYSDATE) --LSC
         AND FLG_PROCESA = 0
         AND S.SEQ IS NULL
         AND NVL(CF_ACTUAL, 0) = 0 ;--<2.0>
    V_AUX INTEGER;

    CURSOR X_ IS
      SELECT S.CODSOLOT, S.COD_ID
        FROM SOLOT S
       WHERE S.CODSOLOT IN
             (SELECT DISTINCT R.CODSOLOT_UP
                FROM SALES.MIGRA_UPGRADE_MASIVO R
               WHERE TRUNC(FECUSU) = TRUNC(SYSDATE)
                 AND NVL(CF_ACTUAL, 0) = 0)--<2.0>
         AND S.ESTSOL IN (10);

    X NUMBER;
    Y VARCHAR2(500);

    CURSOR ABC IS
      SELECT *
        FROM INT_TRANSACCIONESXSOLOT
       WHERE CODSOLOT IN (SELECT CODSOLOT
                            FROM SOLOT
                             WHERE TIPTRA = 814
                             AND FECUSU > TRUNC(SYSDATE) - 1)
                             AND ESTADO = 0;

     CURSOR C_PIDS_1 IS
       SELECT DISTINCT T.PID_OLD
         FROM SALES.MIGRA_UPGRADE_MASIVO T
        WHERE T.FECUSU > TRUNC(SYSDATE)
          AND T.FLG_PROCESA=1
          AND NVL(CF_ACTUAL, 0) = 0  AND CODSOLOT_UP>0;--<2.0>

    --Ini 2.0
      --0.1 - Se revisa si el cod_id, tiene servicios activos
     CURSOR C_ACTIVOS IS
      SELECT U.COD_ID, U.CUSTOMER_ID, COUNT(DISTINCT(I.CODINSSRV)) AS CANT, U.ROWID
          FROM SALES.MIGRA_UPGRADE_MASIVO U, SOLOT S, SOLOTPTO PT, INSSRV I
        WHERE U.COD_ID = S.COD_ID
          AND PT.CODSOLOT = S.CODSOLOT
          AND S.COD_ID = U.COD_ID
          AND I.CODINSSRV = PT.CODINSSRV
          AND I.ESTINSSRV=1
          AND S.ESTSOL IN (12, 29)
          AND I.TIPSRV = '0006'
          AND U.FLG_PROCESA = 3
          AND NVL(CF_ACTUAL, 0) = 0 --ACTIVACION
          AND TRUNC(U.FECUSU) = TRUNC(SYSDATE)
        GROUP BY U.COD_ID, U.CUSTOMER_ID, U.ROWID;
    --Fin 2.0
   K_ID INTEGER;

BEGIN
---limpieza upgrdae
DECLARE

  CURSOR CUR IS
    SELECT S.CODSOLOT, S.ESTSOL
      FROM SOLOT S
     WHERE S.TIPTRA = 814
       AND S.ESTSOL IN (10, 11);
BEGIN
    DELETE FROM SALES.MIGRA_UPGRADE_MASIVO;
    commit;
  FOR C IN CUR LOOP
    BEGIN
      OPERACION.PQ_SOLOT.P_CHG_ESTADO_SOLOT(C.CODSOLOT,
                                            13,
                                            C.ESTSOL,
                                            'SOT SIN COI_ID');
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    COMMIT;
  END LOOP;
END;



BEGIN
  SELECT MAX(NVL(M.FLG_CAMBIOPREC,'0')) + 1 INTO K_ID  FROM SALES.MIGRA_UPGRADE_MASIVO M 
   WHERE NVL(CF_ACTUAL, 0) = 0;

 
INSERT INTO SALES.MIGRA_UPGRADE_MASIVO
                                 (COD_ID,
                                  CUSTOMER_ID,
                                  SNCODE_ACTUAL, --SNCODE
                                  SNCODE_NEW, --SNCODE
                                  TIPO_PRODUCTO,
                                  TIPO_SERVICIO,
                                  FLG_PROCESA,
                                  FLG_FACTURAR,
                                  CF_NEW,
                                  FLG_CAMBIOPREC) --<2.0>  -- REINTENTOS
  SELECT DISTINCT BC.CO_ID,
             BDC.CUSTOMER_ID,
             BE.SN_VAL COD_SRV_INICIAL,
             BC.SNCODE COD_SRV_NUEVO,
             'INTERNET' AS TIPO_PRODUCTO,
             'CORE' AS TIPO_SERVICIO,
             3,
             1,
             ROUND(SYSDATE - BC.FEC_ESTADO,2),  --<2.0>
             K_ID
        FROM TIM.PP_BONOS_CONTRATO@DBL_BSCS_BF BC,
             TIM.PP_BONOS_EQUIV@DBL_BSCS_BF    BE,
             TIM.BSCT_D_FULL_CLARO@DBL_BSCS_BF BDC
       WHERE BC.BONO_ID = BE.BONO_ID
         AND BC.CO_ID = BDC.CO_ID
         AND BC.TIPO_BONO = 'FF'
         AND BC.ESTADO_BONO = 'A'
         AND TIM.TFUN015_ESTADO_SERVICIO@DBL_BSCS_BF(BDC.CO_ID, BE.SN_VAL) = 'A'
         AND BDC.ESTADO = 'E'
         --AND BC.OBSERVACION  NOT IN ('WA FIJA A+','WA FIJA A++');
         --AND (BC.SNCODE <> BDC.SNCODE_VIG OR NVL(SNCODE_VIG,0) = 0); --Fin 2.0
         AND (NVL(BC.SNCODE,0) <> NVL(BDC.SNCODE_VIG,0) OR NVL(SNCODE_VIG,0) = 0);


  --Ini 2.0
  --0.1- SI EL COD_ID NO TIENE SERVICIOS ACTIVOS SE SETEA EL FLG_PROCESA = 1.
  FOR CA IN C_ACTIVOS LOOP
    IF CA.CANT = 0 THEN

      UPDATE SALES.MIGRA_UPGRADE_MASIVO M
         SET M.FLG_PROCESA = 5,
             M.SERVICIO   = SUBSTR('No tiene serv. Activos, el COD_ID: ' || CA.COD_ID,
                               1,
                               50)
       WHERE ROWID = CA.ROWID;

    END IF;
    IF CA.CANT > 1 THEN
      UPDATE SALES.MIGRA_UPGRADE_MASIVO
         SET FLG_PROCESA = 5,
             SERVICIO = SUBSTR('Tiene mas de un Servivio Activo de Internet, el COD_ID: ' || CA.COD_ID,
                               1,
                               50)
       WHERE ROWID = CA.ROWID;
    END IF;
  END LOOP;
  --Fin 2.0

  FOR REG IN C_SERV_SISACT LOOP
    UPDATE SALES.MIGRA_UPGRADE_MASIVO
       SET CODSRV_OLD = REG.COD_SRV_INICIAL,
           SERVICIO   = SUBSTR(REG.SNCODE_DES_ACTUAL || ' | ' ||
                               REG.SNCODE_DES_ACTUAL,
                               1,
                               50)
     WHERE ROWID = REG.ROW_ID;
  END LOOP;

  FOR I IN SERVICIOS LOOP
    UPDATE SALES.MIGRA_UPGRADE_MASIVO
       SET CODSRV_NEW = I.CODSRV
     WHERE ROWID = I.ROW_ID;
  END LOOP;

  --3.INSERTAR TABLA PIVOT DE SGA
  UPDATE SALES.MIGRA_UPGRADE_MASIVO
     SET FLG_PROCESA = 0
   WHERE FLG_PROCESA = 3
     AND NVL(CF_ACTUAL, 0) = 0 ;--<2.0>

  FOR REG IN C_PIDS LOOP
    UPDATE SALES.MIGRA_UPGRADE_MASIVO
       SET PID_OLD = REG.PID_OLD
     WHERE ROWID = REG.ROW_ID;
  END LOOP;

  V_AUX := 0;
  FOR REG IN C_SEQ LOOP
    UPDATE SALES.MIGRA_UPGRADE_MASIVO
       SET SEQ = V_AUX + 1
     WHERE ROWID = REG.ROW_ID;
    V_AUX := V_AUX + 1;
  END LOOP;

  OPERACION.PQ_UPGRADE_SERVICIO_MAS.P_JOB_GENERA_SOT;

  FOR A IN X_ LOOP
    PQ_SOLOT.P_ASIG_WF(A.CODSOLOT, 1332);
  END LOOP;

  OPERACION.PQ_UPGRADE_SERVICIO_MAS.P_JOB_ATIENDE_SOT_UP;

  FOR BB IN ABC LOOP
    SOPFIJA.P_INT_REGXLOTE(BB.ID_LOTE, X, Y);
    IF X = 1 THEN
      UPDATE INT_MENSAJE_INTRAWAY
         SET ESTADO = 'PROCESO'
       WHERE ID_LOTE = BB.ID_LOTE
         AND CODSOLOT = BB.CODSOLOT;
      UPDATE INT_TRANSACCIONESXSOLOT
         SET ESTADO = 2
       WHERE ID_LOTE = BB.ID_LOTE
         AND CODSOLOT = BB.CODSOLOT;
    END IF;
  END LOOP;

  OPERACION.PQ_UPGRADE_SERVICIO_MAS.P_JOB_ATIENDE_SOT_UP;
  OPERACION.PQ_UPGRADE_SERVICIO_MAS.P_JOB_ATIENDE_SOT_UP;

  OPERACION.PQ_UPGRADE_SERVICIO_MAS.P_JOB_ATIENDE_SOT_UP;
  OPERACION.PQ_UPGRADE_SERVICIO_MAS.P_JOB_ATIENDE_SOT_UP;

  UPDATE SOLOT S
     SET S.OBSERVACION = 'Activación Bono Full Claro'
   WHERE S.CODSOLOT IN (SELECT T.CODSOLOT_UP
                          FROM SALES.MIGRA_UPGRADE_MASIVO T
                         WHERE T.FECUSU > TRUNC(SYSDATE)
                           AND NVL(CF_ACTUAL, 0) = 0);--<2.0>

  FOR C_PID IN C_PIDS_1 LOOP
    UPDATE INSPRD P
       SET P.ESTINSPRD = 3, P.FECFIN = SYSDATE
     WHERE P.PID = C_PID.PID_OLD;
  END LOOP;

  INSERT INTO SALES.SGAT_MIGRA_UPGRADE_MASIVO_HIST(SGAN_COD_ID,
                                                   SGAN_CUSTOMER_ID,
                                                   SGAN_CODSOLOT,
                                                   SGAV_SERVICIO,
                                                   SGAV_CODSRV_OLD,
                                                   SGAV_CODSRV_NEW,
                                                   SGAN_FLG_PROCESA,
                                                   SGAD_FEC_REG,
                                                   SGAV_USU_REG,
                                                   SGAN_SNCODE_ACT,
                                                   SGAN_SNCODE_NEW,
                                                   SGAN_PID_OLD,
                                                   SGAN_PID_NEW,
                                                   SGAN_FLG_FACTURAR,
                                                   SGAN_CODSOLOT_UP,
                                                   SGAN_CF_ACTUAL,
                                                   SGAN_CF_NEW,
                                                   SGAN_FLG_CAMBPREC,
                                                   SGAV_TIP_SERVICIO,
                                                   SGAV_TIP_PRODUCTO,
                                                   SGAN_FLG_PROC_JANUS)
                                                   SELECT COD_ID,
                                                          CUSTOMER_ID,
                                                          CODSOLOT,
                                                          SERVICIO,
                                                          CODSRV_OLD,
                                                          CODSRV_NEW,
                                                          FLG_PROCESA,
                                                          FECUSU,
                                                          CODUSU,
                                                          SNCODE_ACTUAL,
                                                          SNCODE_NEW,
                                                          PID_OLD,
                                                          PID_NEW,
                                                          FLG_FACTURAR,
                                                          CODSOLOT_UP,
                                                          CF_ACTUAL,
                                                          CF_NEW,
                                                          FLG_CAMBIOPREC,
                                                          TIPO_SERVICIO,
                                                          TIPO_PRODUCTO,
                                                          FLG_PROCESA_JANUS
                                                     FROM SALES.MIGRA_UPGRADE_MASIVO;

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    MENSAJE := '98';
    DBMS_OUTPUT.PUT_LINE('ERROR : ' || SQLERRM);
    ROLLBACK;
END;

END;

PROCEDURE P_REPO_BONO_FIJA_FULL_CLARO (K_REPORTE_FIJAS OUT SYS_REFCURSOR,
                                 K_COD_RES OUT INTEGER,
                                 K_MENSAJE OUT VARCHAR2) IS

BEGIN

      OPEN K_REPORTE_FIJAS FOR
           SELECT
           U.COD_ID,
           U.CUSTOMER_ID,
           U.FECUSU,
           U.CODSOLOT_UP,
           U.CODSRV_OLD,
           (SELECT DSCSRV FROM TYSTABSRV TY WHERE TY.CODSRV = U.CODSRV_OLD) AS CODSRV_OLD,
           U.CODSRV_NEW,(SELECT DSCSRV FROM TYSTABSRV TY WHERE TY.CODSRV = U.CODSRV_NEW) AS CODSRV_NEW
               FROM SALES.MIGRA_UPGRADE_MASIVO U
               WHERE TRUNC(U.FECUSU) = TRUNC(SYSDATE)
                 AND U.FLG_PROCESA = 1     --<2.0>
                 AND NVL(CF_ACTUAL, 0) = 0 --<2.0>
               ORDER BY COD_ID;


          EXCEPTION
               WHEN OTHERS THEN
                 K_COD_RES := 99;
                 K_MENSAJE := SUBSTR('ERROR : '|| sqlerrm,1,250);
  END;
  -----------------------------------------------------------------------------------

/******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        20/05/2019  Luigi Sipion     Desactivacion de Bonos
  ******************************************************************************/
  PROCEDURE PSGASS_DESACTIVA_BONO  (K_COD_RES OUT INTEGER,
                                    K_MENSAJE OUT VARCHAR2) IS
    --1.- ACTUALIZAR CODSRV OLD EN TABLA PIVOT DE BSCS
     CURSOR C_SERV_SISACT IS
      SELECT X.*
        FROM (SELECT R.COD_ID,
                     R.CUSTOMER_ID,
                     R.SNCODE_ACTUAL SNCODE_ACTUAL,
                     SN.DES SNCODE_DES_ACTUAL,
                     (SELECT  DISTINCT B.CODSRV
                        FROM SALES.SERVICIO_SISACT               B,
                             USRPVU.SISACT_AP_SERVICIO@DBL_PVUDB           A,
                             SOLOT                               S,
                             TIPTRABAJO                          T,
                             INSPRD                              I
                       WHERE B.IDSERVICIO_SISACT = A.SERVV_CODIGO
                         AND A.SERVV_ID_BSCS = TO_CHAR (R.SNCODE_ACTUAL)
                         AND B.CODSRV = I.CODSRV
                         AND S.COD_ID = R.COD_ID
                         AND S.TIPTRA = T.TIPTRA
                         AND T.TIPTRS = 1
                         AND T.TIPTRA IN (658, 676, 695, 678, 814, 693, 427, 412)
                          AND I.ESTINSPRD IN  (1, 2, 4)
                         AND S.NUMSLC = I.NUMSLC
                         AND I.CODEQUCOM IS NULL) COD_SRV_INICIAL,
                     R.CODSRV_OLD,
                     R.TIPO_SERVICIO,
                     R.TIPO_PRODUCTO,
                     R.FLG_PROCESA,
                     R.ROWID ROW_ID,
                     R.SNCODE_NEW,
                     R.FECUSU,
                     R.CF_ACTUAL
                FROM SALES.MIGRA_UPGRADE_MASIVO R, MPUSNTAB@DBL_BSCS_BF SN
               WHERE R.SNCODE_ACTUAL = SN.SNCODE
              ) X
       WHERE X.SNCODE_ACTUAL IS NOT NULL
         AND X.FLG_PROCESA = 3 AND X.CF_ACTUAL = 1
       ORDER BY X.TIPO_SERVICIO;
    --2.- ACTUALIZAR CODSRV NEW EN TABLA PIVOT DE BSCS
     CURSOR SERVICIOS IS
      SELECT R.COD_ID,
             R.SNCODE_NEW,
             R.CODSRV_OLD,
             R.ROWID ROW_ID,
             (SELECT  DISTINCT B.CODSRV
                          FROM SALES.SERVICIO_SISACT               B,
                               USRPVU.SISACT_AP_SERVICIO@DBL_PVUDB           A,
                               SOLOT                               S,
                               TIPTRABAJO                          T,
                               INSPRD                              I
                         WHERE B.IDSERVICIO_SISACT = A.SERVV_CODIGO
                           AND A.SERVV_ID_BSCS = TO_CHAR (R.SNCODE_NEW)
                           AND B.CODSRV = I.CODSRV
                           AND S.COD_ID = R.COD_ID
                           AND S.TIPTRA = T.TIPTRA
                           AND T.TIPTRS = 1
                           AND T.TIPTRA IN
                               (658, 676, 695, 678, 814, 693, 427, 412)
                            AND I.ESTINSPRD IN (3)
                           AND S.NUMSLC = I.NUMSLC
                           AND I.CODEQUCOM IS NULL) CODSRV,
             R.CF_ACTUAL
        FROM SALES.MIGRA_UPGRADE_MASIVO R
       WHERE R.SNCODE_NEW IS NOT NULL
         AND R.FLG_PROCESA = 3 AND R.CF_ACTUAL = 1;

   --5.- ACTUALIZAR SEQUENCE EN TABLA PIVOT DE SGA
    CURSOR C_SEQ IS
      SELECT S.ROWID ROW_ID
        FROM SALES.MIGRA_UPGRADE_MASIVO S
       WHERE TRUNC(FECUSU) = TRUNC(SYSDATE)
         AND FLG_PROCESA = 0 AND S.CF_ACTUAL = 1
         AND S.SEQ IS NULL;
    V_AUX INTEGER;

  CURSOR X_ IS
      SELECT S.CODSOLOT, S.COD_ID
        FROM SOLOT S
       WHERE S.CODSOLOT IN
             (SELECT DISTINCT R.CODSOLOT_UP
                FROM SALES.MIGRA_UPGRADE_MASIVO R
               WHERE TRUNC(FECUSU) = TRUNC(SYSDATE)
                 AND CF_ACTUAL = 1)--<2.0>
         AND S.ESTSOL IN (10);
   --10.0 Generar y enviar tramas a Incognito
    X NUMBER;
    Y VARCHAR2(500);
    CURSOR ABC IS
      SELECT *
        FROM INT_TRANSACCIONESXSOLOT
       WHERE CODSOLOT IN (SELECT CODSOLOT
                            FROM SOLOT
                             WHERE TIPTRA = 814
                             AND FECUSU > TRUNC(SYSDATE) - 1)
                             AND ESTADO = 0;

     CURSOR C_PIDS_1 IS
       SELECT DISTINCT T.PID_OLD
         FROM SALES.MIGRA_UPGRADE_MASIVO T
        WHERE T.FECUSU > TRUNC(SYSDATE) AND T.CF_ACTUAL = 1
          AND T.FLG_PROCESA=1 AND  CODSOLOT_UP>0;

    --0.- Obtiene los registros a desactivar
    K_COUNT NUMBER;
    K_SNCODE_VIG NUMBER;
    K_FECHA_ACT DATE;
    K_COD    NUMBER;

    --0.1 - Se revisa si el cod_id, tiene servicios activos
      CURSOR C_ACTIVOS IS
       SELECT U.COD_ID, U.CUSTOMER_ID, COUNT(DISTINCT(I.CODINSSRV)) AS CANT, U.ROWID
          FROM SALES.MIGRA_UPGRADE_MASIVO U, SOLOT S, SOLOTPTO PT, INSSRV I
        WHERE U.COD_ID = S.COD_ID
          AND PT.CODSOLOT = S.CODSOLOT
          AND S.COD_ID = U.COD_ID
          AND I.CODINSSRV = PT.CODINSSRV
          AND I.ESTINSSRV=1
          AND S.ESTSOL IN (12, 29)
          AND I.TIPSRV = '0006'
          AND U.FLG_PROCESA = 3
          AND U.CF_ACTUAL = 1
          AND TRUNC(U.FECUSU) = TRUNC(SYSDATE)
        GROUP BY U.COD_ID, U.CUSTOMER_ID, U.ROWID;



BEGIN
---limpieza upgrdae
DECLARE

  CURSOR CUR IS
    SELECT S.CODSOLOT, S.ESTSOL
      FROM SOLOT S
     WHERE S.TIPTRA = 814
       AND S.ESTSOL IN (10, 11);
BEGIN
    DELETE FROM SALES.MIGRA_UPGRADE_MASIVO;
    commit;
  FOR C IN CUR LOOP
    BEGIN
      OPERACION.PQ_SOLOT.P_CHG_ESTADO_SOLOT(C.CODSOLOT,
                                            13,
                                            C.ESTSOL,
                                            'SOT SIN COI_ID');
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    COMMIT;
  END LOOP;
END;
   BEGIN
      K_COD_RES := 0;
      K_MENSAJE := 'Proceso Ejecutado Satisfactoriamente.';

      INSERT INTO SALES.MIGRA_UPGRADE_MASIVO
                                 (COD_ID,
                                  CUSTOMER_ID,
                                  SNCODE_NEW,
                                  SNCODE_ACTUAL,
                                  TIPO_PRODUCTO,
                                  TIPO_SERVICIO,
                                  FLG_PROCESA,
                                  FLG_FACTURAR,
                                  CF_ACTUAL,
                                  CF_NEW)
  SELECT DISTINCT BC.CO_ID,
             BDC.CUSTOMER_ID,
             BE.SN_VAL COD_SRV_INICIAL,
             BC.SNCODE COD_SRV_NUEVO,
             'INTERNET' AS TIPO_PRODUCTO,
             'CORE' AS TIPO_SERVICIO,
             3  AS FLG_PROCESA,
             1  AS FLG_FACTURAR,
             1  AS CF_ACTUAL,
             ROUND(SYSDATE - BC.FEC_ESTADO,2)  --<2.0>

        FROM TIM.PP_BONOS_CONTRATO@DBL_BSCS_BF BC,
             TIM.PP_BONOS_EQUIV@DBL_BSCS_BF    BE,
             TIM.BSCT_D_FULL_CLARO@DBL_BSCS_BF BDC
       WHERE BC.BONO_ID = BE.BONO_ID
         AND BC.CO_ID = BDC.CO_ID
         AND TIM.TFUN015_ESTADO_SERVICIO@DBL_BSCS_BF(BDC.CO_ID, BE.SN_VAL) = 'D'
         AND BC.TIPO_BONO = 'FF'
         AND BC.ESTADO_BONO = 'D'
         AND BDC.ESTADO IN ('C','T')
         AND BC.SNCODE = BDC.SNCODE_VIG AND NVL(SNCODE_VIG,0) <> 0
         AND NVL(BC.SNCODE,0) = NVL(BDC.SNCODE_VIG,0) AND NVL(SNCODE_VIG,0) <> 0;

        --0.1- SI EL COD_ID NO TIENE SERVICIOS ACTIVOS SE SETEA EL FLG_PROCESA = 1.
      FOR CA IN C_ACTIVOS LOOP
        IF CA.CANT = 0 THEN
          UPDATE SALES.MIGRA_UPGRADE_MASIVO
             SET FLG_PROCESA = 5,
                 SERVICIO   = SUBSTR('No tiene serv. Activos, el COD_ID: ' || CA.COD_ID,
                                   1,
                                   50)
           WHERE ROWID = CA.ROWID;
        END IF;

        IF CA.CANT > 1 THEN
          UPDATE SALES.MIGRA_UPGRADE_MASIVO
             SET FLG_PROCESA = 5,
                 SERVICIO   = SUBSTR('Tiene mas de un Servivio Activo de Internet, el COD_ID: ' || CA.COD_ID,
                                   1,
                                   50)
           WHERE ROWID = CA.ROWID;
        END IF;
      END LOOP;

      --1.- ACTUALIZAR CODSRV OLD EN TABLA PIVOT DE BSCS
      FOR REG IN C_SERV_SISACT LOOP
        UPDATE SALES.MIGRA_UPGRADE_MASIVO
           SET CODSRV_OLD = REG.COD_SRV_INICIAL,
               SERVICIO   = SUBSTR('DESACTIVACION:' || ' | ' ||
                                 REG.SNCODE_DES_ACTUAL,
                                 1,
                                 50)
         WHERE ROWID = REG.ROW_ID;
      END LOOP;

      --2.- ACTUALIZAR CODSRV NEW EN TABLA PIVOT DE BSCS
      FOR I IN SERVICIOS LOOP
        UPDATE SALES.MIGRA_UPGRADE_MASIVO
           SET CODSRV_NEW = I.CODSRV
         WHERE ROWID = I.ROW_ID;
      END LOOP;

      --3-.INSERTAR TABLA PIVOT DE SGA
      UPDATE SALES.MIGRA_UPGRADE_MASIVO
         SET FLG_PROCESA = 0
       WHERE FLG_PROCESA = 3 AND CF_ACTUAL = 1 AND NVL(CODSRV_NEW,'-')<>'-';

       UPDATE SALES.MIGRA_UPGRADE_MASIVO
         SET FLG_PROCESA = 44, SERVICIO='No se encontro El CODSRV'
       WHERE FLG_PROCESA = 3 AND CF_ACTUAL = 1 AND NVL(CODSRV_NEW,'-')='-';

      --5.- ACTUALIZAR SEQUENCE EN TABLA PIVOT DE SGA
      V_AUX := 0;
      FOR REG IN C_SEQ LOOP
        UPDATE SALES.MIGRA_UPGRADE_MASIVO
           SET SEQ = V_AUX + 1
         WHERE ROWID = REG.ROW_ID;
        V_AUX := V_AUX + 1;
      END LOOP;

  OPERACION.PQ_UPGRADE_SERVICIO_MAS.P_JOB_GENERA_SOT_DESAC;

  FOR A IN X_ LOOP
    PQ_SOLOT.P_ASIG_WF(A.CODSOLOT, 1332);
  END LOOP;

  OPERACION.PQ_UPGRADE_SERVICIO_MAS.P_JOB_ATIENDE_SOT_UP;

      --10.0 GENERAR Y ENVIAR TRAMAS A INCOGNITO
      FOR BB IN ABC LOOP
        SOPFIJA.P_INT_REGXLOTE(BB.ID_LOTE, X, Y);
        IF X = 1 THEN
          UPDATE INT_MENSAJE_INTRAWAY
             SET ESTADO = 'PROCESO'
           WHERE ID_LOTE = BB.ID_LOTE
             AND CODSOLOT = BB.CODSOLOT;
          UPDATE INT_TRANSACCIONESXSOLOT
             SET ESTADO = 2
           WHERE ID_LOTE = BB.ID_LOTE
             AND CODSOLOT = BB.CODSOLOT;
        END IF;
      END LOOP;

      /*CERRAR TAREA JANUS Y BSCS*/
  OPERACION.PQ_UPGRADE_SERVICIO_MAS.P_JOB_ATIENDE_SOT_UP;
  OPERACION.PQ_UPGRADE_SERVICIO_MAS.P_JOB_ATIENDE_SOT_UP;

  OPERACION.PQ_UPGRADE_SERVICIO_MAS.P_JOB_ATIENDE_SOT_UP;
  OPERACION.PQ_UPGRADE_SERVICIO_MAS.P_JOB_ATIENDE_SOT_UP;


      --11.- ACTUALIZAR EL CAMPO SOLOT.OBSERVACION
      UPDATE SOLOT S
         SET S.OBSERVACION = 'Desactivación Bono Full Claro'
       WHERE S.CODSOLOT IN (SELECT T.CODSOLOT_UP
                              FROM SALES.MIGRA_UPGRADE_MASIVO T
                             WHERE T.FECUSU > TRUNC(SYSDATE)AND CF_ACTUAL = 1);
      --12.- DESACTIVAR PID_OLD
      FOR C_PID IN C_PIDS_1 LOOP
        UPDATE INSPRD P
           SET P.ESTINSPRD = 3, P.FECFIN = SYSDATE
         WHERE P.PID = C_PID.PID_OLD;
      END LOOP;

    INSERT INTO SALES.SGAT_MIGRA_UPGRADE_MASIVO_HIST(SGAN_COD_ID,
                                                   SGAN_CUSTOMER_ID,
                                                   SGAN_CODSOLOT,
                                                   SGAV_SERVICIO,
                                                   SGAV_CODSRV_OLD,
                                                   SGAV_CODSRV_NEW,
                                                   SGAN_FLG_PROCESA,
                                                   SGAD_FEC_REG,
                                                   SGAV_USU_REG,
                                                   SGAN_SNCODE_ACT,
                                                   SGAN_SNCODE_NEW,
                                                   SGAN_PID_OLD,
                                                   SGAN_PID_NEW,
                                                   SGAN_FLG_FACTURAR,
                                                   SGAN_CODSOLOT_UP,
                                                   SGAN_CF_ACTUAL,
                                                   SGAN_CF_NEW,
                                                   SGAN_FLG_CAMBPREC,
                                                   SGAV_TIP_SERVICIO,
                                                   SGAV_TIP_PRODUCTO,
                                                   SGAN_FLG_PROC_JANUS)
                                                   SELECT COD_ID,
                                                          CUSTOMER_ID,
                                                          CODSOLOT,
                                                          SERVICIO,
                                                          CODSRV_OLD,
                                                          CODSRV_NEW,
                                                          FLG_PROCESA,
                                                          FECUSU,
                                                          CODUSU,
                                                          SNCODE_ACTUAL,
                                                          SNCODE_NEW,
                                                          PID_OLD,
                                                          PID_NEW,
                                                          FLG_FACTURAR,
                                                          CODSOLOT_UP,
                                                          CF_ACTUAL,
                                                          CF_NEW,
                                                          FLG_CAMBIOPREC,
                                                          TIPO_SERVICIO,
                                                          TIPO_PRODUCTO,
                                                          FLG_PROCESA_JANUS
                                                     FROM SALES.MIGRA_UPGRADE_MASIVO;

  COMMIT;

  EXCEPTION
    WHEN OTHERS THEN
      K_MENSAJE := '98';
      DBMS_OUTPUT.PUT_LINE('ERROR : ' || SQLERRM);
      ROLLBACK;
  END;
END;

/******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        20/05/2019  Luigi Sipion     Reporte de Bonos
                                           K_REPORTE --> Codigo del Reporte a ejecutar
                                           1 : reporte de activaciones procesadas en el dia.
                                           2 : reporte de desactivaciones procesadas en el dia.
                                           3 : reporte de los reintentos, para las activaciones.
                                           4 : reporte de activaciones procesadas en el dia.
                                           5 : reporte de desactivaciones procesadas en el dia.
  ******************************************************************************/
 PROCEDURE PSGASS_LISTAR_BONOS_ACTDES(K_REPORTE           INTEGER,
                                      K_REPORTE_FIJAS OUT SYS_REFCURSOR,
                                      K_COD_RES       OUT INTEGER,
                                      K_MENSAJE       OUT VARCHAR2) IS

 BEGIN
  K_COD_RES := 0;
  K_MENSAJE := 'Proceso Ejecutado Satisfactoriamente.';
  CASE K_REPORTE
    WHEN 1 THEN  --1 : reporte de activaciones procesadas en el dia.
      BEGIN
        OPEN K_REPORTE_FIJAS FOR
      SELECT U.SGAN_COD_ID AS COD_ID,
             U.SGAN_CUSTOMER_ID AS CUSTOMER_ID,
             U.SGAD_FEC_REG AS FECUSU,
             U.SGAN_CODSOLOT_UP AS CODSOLOT_UP,
             U.SGAV_CODSRV_OLD AS CODSRV_OLD,
             (SELECT DSCSRV FROM TYSTABSRV TY WHERE TY.CODSRV = U.SGAV_CODSRV_OLD) AS CODSRV_OLD_DET,
             U.SGAV_CODSRV_NEW AS CODSRV_NEW,
             (SELECT DSCSRV FROM TYSTABSRV TY WHERE TY.CODSRV = U.SGAV_CODSRV_NEW) AS CODSRV_NEW_DET
        FROM SALES.SGAT_MIGRA_UPGRADE_MASIVO_HIST U
       WHERE TRUNC(SGAD_FEC_REG) = TRUNC(SYSDATE)
         AND U.SGAN_FLG_PROCESA = 1
         AND NVL(SGAN_CF_ACTUAL, 0) = 0
      ORDER BY SGAN_COD_ID;

          EXCEPTION
               WHEN OTHERS THEN
                 K_COD_RES := 99;
                 K_MENSAJE := SUBSTR('ERROR : '|| SQLERRM,1,250);
     END;
    WHEN 2 THEN   --2 : reporte de desactivaciones procesadas en el dia.
      BEGIN
          OPEN K_REPORTE_FIJAS FOR
        SELECT U.SGAN_COD_ID AS COD_ID,
               U.SGAN_CUSTOMER_ID AS CUSTOMER_ID,
               U.SGAD_FEC_REG AS FECUSU,
               U.SGAN_CODSOLOT_UP AS CODSOLOT_UP,
               U.SGAV_CODSRV_OLD AS CODSRV_OLD,
               (SELECT DSCSRV FROM TYSTABSRV TY WHERE TY.CODSRV = U.SGAV_CODSRV_OLD) AS CODSRV_OLD_DET,
               U.SGAV_CODSRV_NEW AS CODSRV_NEW,
               (SELECT DSCSRV FROM TYSTABSRV TY WHERE TY.CODSRV = U.SGAV_CODSRV_NEW) AS CODSRV_NEW_DET
          FROM SALES.SGAT_MIGRA_UPGRADE_MASIVO_HIST U
         WHERE TRUNC(SGAD_FEC_REG) = TRUNC(SYSDATE)
           AND U.SGAN_FLG_PROCESA = 1
           AND SGAN_CF_ACTUAL     = 1
           AND SUBSTR(SGAV_SERVICIO,1,34) <> 'No tiene serv. Activos, el COD_ID:'
        ORDER BY SGAN_COD_ID;

          EXCEPTION
               WHEN OTHERS THEN
                 K_COD_RES := 99;
                 K_MENSAJE := SUBSTR('ERROR : '|| SQLERRM,1,250);
     END;
    WHEN 3 THEN  --3 : reporte de los reintentos, para las activaciones
      BEGIN
        OPEN K_REPORTE_FIJAS FOR
      SELECT U.SGAN_COD_ID AS COD_ID,
             U.SGAN_CUSTOMER_ID AS CUSTOMER_ID,
             U.SGAD_FEC_REG AS FECUSU,
             U.SGAN_CODSOLOT_UP AS CODSOLOT_UP,
             U.SGAV_CODSRV_OLD AS CODSRV_OLD,
             (SELECT DSCSRV FROM TYSTABSRV TY WHERE TY.CODSRV = U.SGAV_CODSRV_OLD) AS CODSRV_OLD_DET,
             U.SGAV_CODSRV_NEW AS CODSRV_NEW,
             (SELECT DSCSRV FROM TYSTABSRV TY WHERE TY.CODSRV = U.SGAV_CODSRV_NEW) AS CODSRV_NEW_DET
        FROM SALES.SGAT_MIGRA_UPGRADE_MASIVO_HIST U
       WHERE TRUNC(SGAD_FEC_REG) = TRUNC(SYSDATE)
         AND U.SGAN_FLG_PROCESA<>1
         AND NVL(SGAN_CF_ACTUAL,0)=0
         AND SGAN_CF_NEW>=14
      ORDER BY SGAN_COD_ID;

          EXCEPTION
               WHEN OTHERS THEN
                 K_COD_RES := 99;
                 K_MENSAJE := SUBSTR('ERROR : '|| SQLERRM,1,250);
     END;
     WHEN 4 THEN  --4 : reporte de activaciones procesadas en el dia.
      BEGIN
        OPEN K_REPORTE_FIJAS FOR
      SELECT U.SGAN_COD_ID AS COD_ID,
             'A'
        FROM SALES.SGAT_MIGRA_UPGRADE_MASIVO_HIST U
       WHERE TRUNC(SGAD_FEC_REG) >= TRUNC(SYSDATE-1)
         AND U.SGAN_FLG_PROCESA = 1
         AND NVL(SGAN_CF_ACTUAL, 0) = 0
      ORDER BY SGAN_COD_ID;

          EXCEPTION
               WHEN OTHERS THEN
                 K_COD_RES := 99;
                 K_MENSAJE := SUBSTR('ERROR : '|| SQLERRM,1,250);
     END;
     WHEN 5 THEN   --5 : reporte de desactivaciones procesadas en el dia.
      BEGIN
          OPEN K_REPORTE_FIJAS FOR
        SELECT U.SGAN_COD_ID AS COD_ID,
               'D'
          FROM SALES.SGAT_MIGRA_UPGRADE_MASIVO_HIST U
         WHERE TRUNC(SGAD_FEC_REG) = TRUNC(SYSDATE)
           AND U.SGAN_FLG_PROCESA = 1
           AND SGAN_CF_ACTUAL = 1
           AND SUBSTR(SGAV_SERVICIO,1,34) <> 'No tiene serv. Activos, el COD_ID:'
        ORDER BY SGAN_COD_ID;

          EXCEPTION
               WHEN OTHERS THEN
                 K_COD_RES := 99;
                 K_MENSAJE := SUBSTR('ERROR : '|| SQLERRM,1,250);
     END;


    ELSE
                 K_COD_RES := -1;
                 K_MENSAJE := SUBSTR('ERROR : '|| 'EL PARAMETRO INGRESADO, '||K_REPORTE|| 'NO ESTA CONFIGURADO PARA EJECUTAR EL REPORTE',1,250);
   END CASE;
  END;

  PROCEDURE P_REPO_CONTROL (K_REPORTE_CAB OUT SYS_REFCURSOR,
                            K_REPORTE_DET OUT SYS_REFCURSOR,
                            K_COD_RES OUT INTEGER,
                            K_MENSAJE OUT VARCHAR2) 
                            IS
    K_COUNT_S               PLS_INTEGER;
    K_COUNT_B               PLS_INTEGER;
    K_COUNT_T               PLS_INTEGER;
    K_COUNT_D               PLS_INTEGER;
    K_DSCSRV                TYSTABSRV.DSCSRV%TYPE;
    K_BONO_DES              VARCHAR2(300); 
    K_MESACONTROL_ID        INTEGER;
    K_SECUENCIA             INTEGER; 
    K_AUX                   INTEGER;  
    K_ID                    INTEGER;    
    K_TOTAL                 INTEGER; 
    K_COD_ID                OPERACION.LOG_TRS_INTERFACE_IW.COD_ID%TYPE;
    K_PROCESO               OPERACION.LOG_TRS_INTERFACE_IW.PROCESO%TYPE;
    K_TEXTO                 OPERACION.LOG_TRS_INTERFACE_IW.TEXTO%TYPE;       
    K_CODCLI                OPERACION.LOG_TRS_INTERFACE_IW.CODCLI%TYPE := '000111333';
    K_PROCESS               OPERACION.LOG_TRS_INTERFACE_IW.PROCESO%TYPE;
    K_CUSTOMER              OPERACION.LOG_TRS_INTERFACE_IW.CUSTOMER_ID%TYPE;
    K_SNCODE_OLD            SALES.SGAT_MIGRA_UPGRADE_MASIVO_HIST.SGAN_SNCODE_ACT%TYPE;
    K_SNCODE_NEW            SALES.SGAT_MIGRA_UPGRADE_MASIVO_HIST.SGAN_SNCODE_NEW%TYPE;
    K_CODSRV_OLD            SALES.SGAT_MIGRA_UPGRADE_MASIVO_HIST.SGAV_CODSRV_OLD%TYPE;
    K_CODSRV_NEW            SALES.SGAT_MIGRA_UPGRADE_MASIVO_HIST.SGAV_CODSRV_NEW%TYPE;
   
    --1. Cursor para obtener los cod_id no se activaron por no contar con quivalente en codsrv
    CURSOR C_CODSRV IS
       SELECT SGAN_COD_ID,
           SGAN_CUSTOMER_ID,
           SGAN_CODSOLOT,
           SGAV_SERVICIO,
           SGAV_CODSRV_OLD,
           SGAV_CODSRV_NEW,
           SGAN_FLG_PROCESA,
           SGAD_FEC_REG,
           SGAV_USU_REG,
           SGAN_SNCODE_ACT,
           SGAN_SNCODE_NEW,
           SGAN_PID_OLD,
           SGAN_PID_NEW,
           SGAN_FLG_FACTURAR,
           SGAN_CODSOLOT_UP,
           SGAN_CF_ACTUAL,
           SGAN_CF_NEW,
           SGAN_FLG_CAMBPREC,
           SGAV_TIP_SERVICIO,
           SGAV_TIP_PRODUCTO,
           SGAN_FLG_PROC_JANUS,
           SGAC_ID_PROYECTO FROM SALES.SGAT_MIGRA_UPGRADE_MASIVO_HIST
        WHERE TRUNC(SGAD_FEC_REG) = TRUNC(SYSDATE)
          AND SGAN_FLG_PROCESA IN (3, 0) AND NVL(SGAN_CF_ACTUAL, 0) = 0 AND SGAN_FLG_CAMBPREC = K_ID
          AND SGAV_CODSRV_NEW IS NULL AND SGAV_CODSRV_OLD IS NULL
          AND SGAN_COD_ID NOT IN 
           (SELECT MECDI_CO_ID FROM SALES.SGAT_MESA_CONTROL_DET D WHERE D.MECDI_MESACONTROL_ID = K_MESACONTROL_ID);
           
    --2. Cursor para obtener los registros con problemas en el servicio de internet
    CURSOR C_FLGPROCESA_5 IS 
    SELECT SGAN_COD_ID,
           SGAN_CUSTOMER_ID,
           SGAN_CODSOLOT,
           SGAV_SERVICIO,
           SGAV_CODSRV_OLD,
           SGAV_CODSRV_NEW,
           SGAN_FLG_PROCESA,
           SGAD_FEC_REG,
           SGAV_USU_REG,
           SGAN_SNCODE_ACT,
           SGAN_SNCODE_NEW,
           SGAN_PID_OLD,
           SGAN_PID_NEW,
           SGAN_FLG_FACTURAR,
           SGAN_CODSOLOT_UP,
           SGAN_CF_ACTUAL,
           SGAN_CF_NEW,
           SGAN_FLG_CAMBPREC,
           SGAV_TIP_SERVICIO,
           SGAV_TIP_PRODUCTO,
           SGAN_FLG_PROC_JANUS,
           SGAC_ID_PROYECTO
        FROM SALES.SGAT_MIGRA_UPGRADE_MASIVO_HIST T
       WHERE TRUNC(T.SGAD_FEC_REG) = TRUNC(SYSDATE)
         AND T.SGAN_FLG_PROCESA = 5  AND NVL(T.SGAN_CF_ACTUAL, 0) = 0
         AND T.SGAN_FLG_CAMBPREC = K_ID
         AND T.SGAN_COD_ID NOT IN 
           (SELECT MECDI_CO_ID FROM SALES.SGAT_MESA_CONTROL_DET D WHERE D.MECDI_MESACONTROL_ID = K_MESACONTROL_ID);
         
    --3. Cursor para obtener los que fallaron en al gun procedimiento de la activacion
    CURSOR C_LOG(V_ID NUMBER) IS
      SELECT DISTINCT cod_id FROM OPERACION.LOG_TRS_INTERFACE_IW 
       WHERE PROCESO IN
                      (SELECT D.DESCRIPCION FROM OPERACION.PARAMETRO_DET_ADC D, OPERACION.PARAMETRO_CAB_ADC C
                        WHERE D.ID_PARAMETRO = C.ID_PARAMETRO AND C.ABREVIATURA = 'FLAG_CTRL_BONOS' AND D.ESTADO = 1)                        
        AND NOT ( PROCESO = K_PROCESS
                   AND NVL(ERROR,0) = 0 AND NVL(TEXTO,'.')IN ('','.') )
        AND NVL(ERROR,0) <> 1  AND IDTRS = V_ID 
        AND TRUNC(FECUSU) = TRUNC(SYSDATE)
        AND CODCLI = K_CODCLI;
     
    --4. Cursor para comparar sga con bscs el campo des.  
    CURSOR C_FLGPROCESA IS   
      SELECT SGAN_COD_ID,
           SGAN_CUSTOMER_ID,
           SGAN_CODSOLOT,
           SGAV_SERVICIO,
           SGAV_CODSRV_OLD,
           SGAV_CODSRV_NEW,
           SGAN_FLG_PROCESA,
           SGAD_FEC_REG,
           SGAV_USU_REG,
           SGAN_SNCODE_ACT,
           SGAN_SNCODE_NEW,
           SGAN_PID_OLD,
           SGAN_PID_NEW,
           SGAN_FLG_FACTURAR,
           SGAN_CODSOLOT_UP,
           SGAN_CF_ACTUAL,
           SGAN_CF_NEW,
           SGAN_FLG_CAMBPREC,
           SGAV_TIP_SERVICIO,
           SGAV_TIP_PRODUCTO,
           SGAN_FLG_PROC_JANUS,
           SGAC_ID_PROYECTO FROM SALES.SGAT_MIGRA_UPGRADE_MASIVO_HIST T
       WHERE TRUNC(T.SGAD_FEC_REG)  = TRUNC(SYSDATE) 
        AND T.SGAN_FLG_PROCESA    = 1  AND NVL(SGAN_CF_ACTUAL, 0) = 0 AND T.SGAN_FLG_CAMBPREC = K_ID  
        AND T.SGAN_COD_ID NOT IN 
           (SELECT MECDI_CO_ID FROM SALES.SGAT_MESA_CONTROL_DET D WHERE D.MECDI_MESACONTROL_ID = K_MESACONTROL_ID);  

    --5. Cursor para obtener los registros guardados en la tabla de control
    CURSOR C_SEQ IS
      SELECT D.ROWID ROW_ID  FROM SALES.SGAT_MESA_CONTROL_DET D  
      WHERE TRUNC(D.MECDD_FEC_REGISTRO) = TRUNC(SYSDATE) AND D.MECDI_MESACONTROL_ID=K_MESACONTROL_ID
      AND D.MECDI_SECUENCIA IS NULL
      ORDER BY D.MECDD_FEC_REGISTRO;    
           
    BEGIN
       
      K_COD_RES := 0;
      K_MENSAJE := 'Proceso Ejecutado Satisfactoriamente.'; 
      K_PROCESS := 'SGASS_CIERRE_TAREA-HFC - Upgrade SGA';
      
      SELECT NVL(MAX(M.SGAN_FLG_CAMBPREC),0)  INTO K_ID FROM SALES.SGAT_MIGRA_UPGRADE_MASIVO_HIST M
       WHERE NVL(SGAN_CF_ACTUAL, 0) = 0 AND TRUNC(M.SGAD_FEC_REG) = TRUNC(SYSDATE);
       
      SELECT COUNT(*) INTO K_TOTAL FROM SALES.SGAT_MIGRA_UPGRADE_MASIVO_HIST M
       WHERE NVL(SGAN_CF_ACTUAL, 0) = 0 AND TRUNC(M.SGAD_FEC_REG) = TRUNC(SYSDATE) AND M.SGAN_FLG_CAMBPREC = K_ID;

      --Insertamos Cabecera
      INSERT INTO SALES.SGAT_MESA_CONTROL(MECOI_MESACONTROL_ID,MECOV_PROCESO,MECOV_DESC_PROC,MECOD_FECHA_CONTROL,MECOI_CANT_REG_TOTAL)
      VALUES (SALES.SGASEQ_MESACONTROL.NEXTVAL,'ABFCM','Control de Activación del Bono Full Claro - Cliente Masivo',trunc(sysdate),K_TOTAL);
      COMMIT;

      SELECT MAX(NVL(MECOI_MESACONTROL_ID,0)) INTO K_MESACONTROL_ID 
        FROM SALES.SGAT_MESA_CONTROL M;        
      --1. Valida aquellos co_id sin activar que no tienen equivalentes en SGA  
      FOR CSRV IN C_CODSRV LOOP
        
        INSERT INTO SALES.SGAT_MESA_CONTROL_DET(MECDI_MESACONTROL_ID,                                                 
                                                MECDI_CO_ID,
                                                MECDI_CUSTOMER_ID,
                                                MECDI_SNCODE_OLD,
                                                MECDV_CODSRV_OLD,
                                                MECDI_SNCODE_NEW,
                                                MECDV_CODSRV_NEW,
                                                MECDD_FEC_REGISTRO,
                                                MECDV_TIPO_PROC,
                                                MECDV_OBSERVACION) 
                                          VALUES
                                               (K_MESACONTROL_ID,                                                  
                                                CSRV.SGAN_COD_ID,
                                                CSRV.SGAN_CUSTOMER_ID,
                                                CSRV.SGAN_SNCODE_ACT,
                                                CSRV.SGAV_CODSRV_OLD,
                                                CSRV.SGAN_SNCODE_NEW,
                                                CSRV.SGAV_CODSRV_NEW,
                                                SYSDATE,
                                                'ABFCM',
                                                'No cuenta con CODSRV equivalente para SGA');
        
      END LOOP;
      
      --2. Valida los que tienen problemas con el servicio de internet
      FOR C_FLG_5 IN C_FLGPROCESA_5 LOOP

        INSERT INTO SALES.SGAT_MESA_CONTROL_DET(MECDI_MESACONTROL_ID,                                                 
                                                MECDI_CO_ID,
                                                MECDI_CUSTOMER_ID,
                                                MECDI_SNCODE_OLD,
                                                MECDV_CODSRV_OLD,
                                                MECDI_SNCODE_NEW,
                                                MECDV_CODSRV_NEW,
                                                MECDD_FEC_REGISTRO,
                                                MECDV_TIPO_PROC,
                                                MECDV_OBSERVACION) 
                                          VALUES
                                               (K_MESACONTROL_ID,                                                  
                                                C_FLG_5.SGAN_COD_ID,
                                                C_FLG_5.SGAN_CUSTOMER_ID,
                                                C_FLG_5.SGAN_SNCODE_ACT,
                                                C_FLG_5.SGAV_CODSRV_OLD,
                                                C_FLG_5.SGAN_SNCODE_NEW,
                                                C_FLG_5.SGAV_CODSRV_NEW,
                                                SYSDATE,
                                                'ABFCM',
                                                C_FLG_5.SGAV_SERVICIO);
      END LOOP;
        
      --3. Valida aquellos bonos que cayeron en alguna parte del proceso de activacion
      FOR LOG IN C_LOG(K_ID) LOOP
         K_COD_ID:= NULL; K_CUSTOMER:= NULL; K_PROCESO:= NULL; K_TEXTO:=  NULL;
         K_SNCODE_OLD:= NULL; K_SNCODE_NEW:= NULL; K_CODSRV_NEW:= NULL; K_CODSRV_OLD:= NULL;  
         SELECT I.COD_ID, I.CUSTOMER_ID, I.PROCESO, I.TEXTO, H.SGAN_SNCODE_ACT,H.SGAV_CODSRV_OLD, H.SGAN_SNCODE_NEW, H.SGAV_CODSRV_NEW 
           INTO K_COD_ID,K_CUSTOMER,K_PROCESO,K_TEXTO, K_SNCODE_OLD, K_CODSRV_OLD, K_SNCODE_NEW, K_CODSRV_NEW 
           FROM OPERACION.LOG_TRS_INTERFACE_IW I LEFT JOIN SALES.SGAT_MIGRA_UPGRADE_MASIVO_HIST H ON I.Cod_Id = H.SGAN_COD_ID
          WHERE PROCESO IN 
                (SELECT D.DESCRIPCION FROM OPERACION.PARAMETRO_DET_ADC D, OPERACION.PARAMETRO_CAB_ADC C
                  WHERE D.ID_PARAMETRO = C.ID_PARAMETRO AND C.ABREVIATURA = 'FLAG_CTRL_BONOS' AND D.ESTADO = 1)  
            AND NOT ( PROCESO = K_PROCESS AND NVL(ERROR,0)=0 AND NVL(TEXTO,'.')IN ('','.') )
            AND NVL(ERROR,0) <> 1  AND IDTRS = K_ID
            AND CODCLI = K_CODCLI
            AND COD_ID IN LOG.COD_ID
            AND ROWNUM = 1
          ORDER BY IDLOG ASC;   
        
         INSERT INTO SALES.SGAT_MESA_CONTROL_DET(MECDI_MESACONTROL_ID,
                                                 MECDI_CO_ID,
                                                 MECDI_CUSTOMER_ID,
                                                 mecdi_sncode_old,
                                                 mecdv_codsrv_old,
                                                 mecdi_sncode_new,
                                                 mecdv_codsrv_new,    
                                                 MECDD_FEC_REGISTRO,
                                                 MECDV_TIPO_PROC,
                                                 MECDV_OBSERVACION)  
                                          VALUES(K_MESACONTROL_ID,
                                                 K_COD_ID,
                                                 K_CUSTOMER,
                                                 K_SNCODE_OLD,
                                                 K_CODSRV_OLD,
                                                 K_SNCODE_NEW,
                                                 K_CODSRV_NEW,
                                                 SYSDATE,
                                                 'ABFCM',
                                                 K_PROCESO || ' ==> ' || K_TEXTO);
      END LOOP;
        
      --4. Compara que el bono del SGA sea el mismo del BSCS configurado
      FOR C_FLG IN C_FLGPROCESA LOOP
        
        --Descripcion del bono del SGA
        SELECT COUNT(1) INTO K_COUNT_S FROM SALES.TYSTABSRV WHERE CODSRV =C_FLG.SGAV_CODSRV_NEW;
        IF K_COUNT_S > 0 THEN 
          SELECT NVL(TRIM(DSCSRV),'.') INTO K_DSCSRV FROM SALES.TYSTABSRV WHERE CODSRV =C_FLG.SGAV_CODSRV_NEW;
        ELSE 
          K_DSCSRV := '.';
        END IF; 
        --Descripcion del bono del BSCS 
        SELECT COUNT(1) INTO K_COUNT_B FROM TIM.PP_BONOS_DEFINICION@DBL_BSCS_BF WHERE SNCODE=C_FLG.SGAN_SNCODE_NEW; 
        IF K_COUNT_B > 0 THEN
          SELECT NVL(TRIM(BONO_DES),'.') INTO K_BONO_DES FROM TIM.PP_BONOS_DEFINICION@DBL_BSCS_BF
          WHERE SNCODE=C_FLG.SGAN_SNCODE_NEW; 
        ELSE
          K_BONO_DES:='.';
        END IF; 
        --Compara que el bono del SGA sea el mismo del BSCS
        IF K_DSCSRV <> K_BONO_DES AND K_DSCSRV<>'.'  THEN 
          INSERT INTO SALES.SGAT_MESA_CONTROL_DET(MECDI_MESACONTROL_ID,
                                                  MECDI_CO_ID,
                                                  MECDI_CUSTOMER_ID,
                                                  MECDI_SNCODE_NEW,
                                                  MECDV_CODSRV_NEW,
                                                  MECDD_FEC_REGISTRO,
                                                  MECDV_TIPO_PROC,
                                                  MECDV_OBSERVACION)  
                                           VALUES(K_MESACONTROL_ID,
                                                  C_FLG.SGAN_COD_ID,
                                                  C_FLG.SGAN_CUSTOMER_ID,
                                                  C_FLG.SGAN_SNCODE_NEW,
                                                  C_FLG.SGAV_CODSRV_NEW,
                                                  SYSDATE,
                                                  'ABFCM',
                                                  'La descripcion de BONOS SGA y BSCS son diferentes');
        END IF;  
      END LOOP;
      
      --5. Coloca la secuencia de errores (SGAT_MESA_CONTROL_DET)
      K_AUX := 0; 
      FOR REG IN C_SEQ LOOP
        UPDATE SALES.SGAT_MESA_CONTROL_DET
           SET MECDI_SECUENCIA = K_AUX + 1
         WHERE ROWID = REG.ROW_ID;
         K_AUX := K_AUX + 1;
      END LOOP;
       
      --Cantidad de registros no procesados de la tabla: SGAT_MESA_CONTROL_DET 
      SELECT COUNT(1) INTO K_COUNT_T FROM SALES.SGAT_MESA_CONTROL_DET D
      WHERE TRUNC(D.MECDD_FEC_REGISTRO) = TRUNC(SYSDATE)  AND D.MECDI_MESACONTROL_ID = K_MESACONTROL_ID;
        
      IF K_COUNT_T >0 THEN
        UPDATE SALES.SGAT_MESA_CONTROL 
           SET MECOI_CANT_REG_ERRADOS = K_COUNT_T, 
               MECOD_FEC_FIN_CON = SYSDATE
         WHERE TRUNC(MECOD_FECHA_CONTROL) = TRUNC(SYSDATE) 
           AND MECOI_MESACONTROL_ID = K_MESACONTROL_ID;  
        COMMIT;
      ELSE
        K_COD_RES := 1;
        K_MENSAJE := 'No se encontraron errores en la activaciones de hoy.'; 
        ROLLBACK;
      END IF; 
      
      OPEN K_REPORTE_CAB FOR
        SELECT C.MECOI_MESACONTROL_ID,C.MECOV_DESC_PROC,C.MECOD_FECHA_CONTROL,C.MECOD_FEC_INI_CON,
          C.MECOD_FEC_FIN_CON,C.MECOI_CANT_REG_ERRADOS,C.MECOV_OBSERVACION
        FROM SALES.SGAT_MESA_CONTROL C
        WHERE C.MECOI_MESACONTROL_ID = K_MESACONTROL_ID;
        
      OPEN K_REPORTE_DET FOR
        SELECT D.MECDI_MESACONTROL_ID,D.MECDI_SECUENCIA,D.MECDI_CO_ID,D.MECDI_CUSTOMER_ID,D.MECDI_SNCODE_OLD,D.MECDV_CODSRV_OLD,
          D.MECDI_SNCODE_NEW,D.MECDV_CODSRV_NEW,D.MECDD_FEC_REGISTRO,D.MECDV_ESTADO_REG,D.MECDV_OBSERVACION
        FROM SALES.SGAT_MESA_CONTROL_DET D
        WHERE D.MECDI_MESACONTROL_ID = K_MESACONTROL_ID;
    
    EXCEPTION   
      WHEN OTHERS THEN
        K_COD_RES := 99;
        K_MENSAJE := SUBSTR('ERROR : '|| sqlerrm,1,250); 
    END;
PROCEDURE PSGASS_SGAT_MESA_CONTROL(PI_F_INI                       IN VARCHAR2,
                                    PI_F_FIN                       IN VARCHAR2,
                                    PO_CURSO_SGAT_MESA_CONTROL    OUT SYS_REFCURSOR,
                                    PO_CURSO_SGAT_MESA_CONTROL_DET OUT SYS_REFCURSOR,
                                    PO_CODERROR                    OUT NUMBER,
                                    PO_MSJERROR                    OUT VARCHAR2)
   IS
   BEGIN
    PO_CODERROR := '0';
    PO_MSJERROR := 'PROCESO EXITOSO';  
    
    IF (PI_F_INI IS NULL OR PI_F_INI='') OR (PI_F_FIN IS NULL OR PI_F_FIN='')  THEN
      PO_CODERROR := '-1';
      PO_MSJERROR := 'INGRESAR RANGO DE FECHAS EN LOS PARAMETROS PI_F_INI Y PI_F_FIN';
    END IF;
   
     OPEN PO_CURSO_SGAT_MESA_CONTROL FOR
     select MECOI_MESACONTROL_ID,
       MECOV_PROCESO,
       MECOV_DESC_PROC,
       MECOD_FECHA_CONTROL,
       MECOD_FEC_INI_CON,
       MECOD_FEC_FIN_CON,
       MECOI_CANT_REG_TOTAL,
       MECOI_CANT_REG_ERRADOS,
       MECOV_OBSERVACION
  from SALES.SGAT_MESA_CONTROL MC
 WHERE to_char(TRUNC(MC.MECOD_FECHA_CONTROL),'DD/MM/YYYY') BETWEEN to_char(PI_F_INI) 
 AND to_char(PI_F_FIN);
 
 OPEN PO_CURSO_SGAT_MESA_CONTROL_DET FOR
 select MECDI_MESACONTROL_ID,
       MECDI_SECUENCIA,
       MECDI_CO_ID,
       MECDI_CUSTOMER_ID,
       MECDI_SNCODE_OLD,
       MECDV_CODSRV_OLD,
       MECDI_SNCODE_NEW,
       MECDV_CODSRV_NEW,
       MECDV_LINEA,
       MECDV_CID,
       MECDD_FEC_REGISTRO,
       MECDV_TIPO_PROC,
       MECDV_ESTADO_REG,
       MECDV_OBSERVACION
  from SALES.SGAT_MESA_CONTROL_DET MCD
 WHERE EXISTS
 (select 1
          from SALES.SGAT_MESA_CONTROL MC
         WHERE to_char(TRUNC(MC.MECOD_FECHA_CONTROL),'DD/MM/YYYY') BETWEEN to_char(PI_F_INI) AND
              to_char(PI_F_FIN)
           AND MC.MECOI_MESACONTROL_ID = MCD.MECDI_MESACONTROL_ID);


     EXCEPTION
    WHEN OTHERS THEN
      PO_CODERROR := '1';
      PO_MSJERROR := 'ERROR DE ORACLE.' || SQLERRM;
   END;                                    
end PKG_SGA_WA;
/
