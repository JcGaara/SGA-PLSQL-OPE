CREATE OR REPLACE PACKAGE BODY OPERACION.PQ_SGA_TH IS
  /*******************************************************************************************************
    NOMBRE:       OPERACION.PQ_SGA_TH
    PROPOSITO:
    REVISIONES:
    Version    Fecha       Autor            Solicitado por    Descripcion
    ---------  ----------  ---------------  --------------    -----------------------------------------
     1.0       26/02/2016  Carlos Ter?n G.  Karen Velezmoro   SD-SGA-652670
     2.0       21/03/2016  Carlos Ter?n G.  Karen Velezmoro   SD-SGA-652670_1
     3.0       28/06/2017  Juan Gonzales    Alfredo Yi        PROY-27792
     4.0       09/07/2017
     5.0       09/11/2018  Alvaro Peña Gamarra  FTTH              PROY 33535
  *******************************************************************************************************/

  PROCEDURE p_asgWfBSCSSIAC_ln(an_tiptransacion number default null) IS
    ln_hilos NUMBER;
    ln_idproceso  NUMBER;
    lv_username   VARCHAR2(100);
    lv_password   VARCHAR2(100);
    lv_url        VARCHAR2(200);
    lv_nsp        VARCHAR2(100) := 'OPERACION.' || $$plsql_unit || '.p_asgWfBSCSSIAC_bl';
    ltb_typ_reg_transaccion_sga typ_reg_transaccion_sga; --2.0
    ltb_typ_LOG_ERROR_TRANSAC_SGA typ_LOG_ERROR_TRANSACCION_SGA;  --2.0
    lv_p_name     VARCHAR2(50) := 'Asigna WFBSCS SIAC'; --2.0
    lv_sp_name    VARCHAR2(50) := 'p_asgWfBSCSSIAC_ln';  --2.0

  BEGIN

    SELECT operacion.sq_thidproceso.nextval
      INTO ln_idproceso
      FROM dual;


    -- Ini 2.0 Insertar cabecera Log
    ltb_typ_reg_transaccion_sga(1).proceso_descripcion := lv_p_name;
    ltb_typ_reg_transaccion_sga(1).procedure_descripcion := lv_sp_name;
    ltb_typ_reg_transaccion_sga(1).cantidad_registros := 0;
    ltb_typ_reg_transaccion_sga(1).registros_correctos := 0;
    ltb_typ_reg_transaccion_sga(1).registros_incorrectos := 0;

    p_regLogSGA(ln_idproceso , ltb_typ_reg_transaccion_sga, ltb_typ_LOG_ERROR_TRANSAC_SGA);

    -- Obtener datos iniciales
    ln_hilos    := TO_NUMBER(f_getConstante('OPTHFCNUM'));
    lv_username := f_getConstante('OPTHFCUSER');
    lv_password := f_getConstante('OPTHFCPWD');
    lv_url      := f_getConstante('OPTHFCURL');
    -- Fin 2.0

    -- Cargar datos
    INSERT /*+ append */
    INTO OPERACION.THCODSOLOT
      (idproceso, codsolot, id_tarea, estado)
      SELECT ln_idproceso, q.codsolot, rownum, 0
       FROM (SELECT codsolot
             FROM solot s
             WHERE EXISTS (SELECT 1
                            FROM opedd o, tipopedd t
                            WHERE o.tipopedd = t.tipopedd
                            AND t.abrev = 'ASIGNARWFBSCS'
                            AND o.codigon_aux = an_tiptransacion
                            AND o.codigon = s.tiptra)
             AND s.estsol = 11
             AND NOT EXISTS ( SELECT 1
                               FROM wf f
                               WHERE f.codsolot = s.codsolot
                               AND f.valido = 1)) q;
    COMMIT;

    --Agrupar los hilos
    UPDATE /*+ parallel(b,4)*/ OPERACION.THCODSOLOT b
     SET b.id_tarea = decode(MOD(b.id_tarea, ln_hilos),
                               0,
                               ln_hilos,
                               MOD(b.id_tarea, ln_hilos))
     WHERE b.idproceso = ln_idproceso;

    COMMIT;

    --Ejecutamos los Hilos
    p_ThreadRun(lv_username, lv_password, lv_url, lv_nsp, ln_idproceso,  ln_hilos );  --2.0

    COMMIT;

  END;

  PROCEDURE p_asgWfBSCSSIAC_bl(an_idproceso NUMBER, an_idtarea NUMBER) IS
   CURSOR c_g IS
      SELECT t.codsolot
      FROM OPERACION.THCODSOLOT t
      WHERE t.idproceso = an_idproceso
      AND t.id_tarea = an_idtarea;

    TYPE tb IS TABLE OF c_g%rowtype INDEX BY BINARY_INTEGER;
    ltb tb;
    le_error     EXCEPTION;
    ln_limit_in  NUMBER := 1000;
    ln_cntrec    NUMBER := 0;
    ln_cnterr    NUMBER := 0;
    ln_cntok     NUMBEr := 0;
    ltb_typ_reg_transaccion_sga typ_reg_transaccion_sga; --2.0
    ltb_typ_LOG_ERROR_TRANSAC_SGA typ_LOG_ERROR_TRANSACCION_SGA; --2.0
    ln_wfdef     NUMBER;

  BEGIN

    -- Obtenet el limite para bulk collect
    SELECT d.codigon
      INTO ln_limit_in
      FROM tipopedd c, opedd d
      WHERE c.abrev = 'PRC_HFC_BULKCOLLECT_LIMIT'
      AND c.tipopedd = d.tipopedd
      AND d.abreviacion = 'p_asigna_wfbscs_siac';

    OPEN c_g;

    LOOP
      FETCH c_g BULK COLLECT INTO ltb limit ln_limit_in;

        FOR c_t IN 1 .. ltb.COUNT LOOP

          BEGIN

             ln_cntrec := ln_cntrec + 1 ; -- Contador de registros

             ln_wfdef := cusbra.f_br_sel_wf(ltb(c_t).codsolot);

             -- actualizar estado del registro
             p_updThcodsolot( an_idproceso, an_idtarea, ltb(c_t).codsolot); --2.0

            IF ln_wfdef IS NOT NULL THEN

               pq_solot.p_asig_wf(ltb(c_t).codsolot, ln_wfdef);

               ln_cntok := ln_cntok + 1;

            ELSE
               ln_cntok := ln_cntok + 1;

            END IF;

          COMMIT;
          -- Ini 2.0
          EXCEPTION
            WHEN no_data_found THEN
                 rollback;--3.0
                 ln_cnterr := ln_cnterr + 1;
                 ltb_typ_LOG_ERROR_TRANSAC_SGA(ln_cnterr).codsolot := ltb(c_t).codsolot;
                 ltb_typ_LOG_ERROR_TRANSAC_SGA(ln_cnterr).observacion:= $$plsql_unit || ': ' || 'cusbra.f_br_sel_wf : ' || sqlcode || '- ' || sqlerrm;
            WHEN OTHERS THEN
                 rollback;--3.0
                 ln_cnterr := ln_cnterr + 1;
                 ltb_typ_LOG_ERROR_TRANSAC_SGA(ln_cnterr).codsolot := ltb(c_t).codsolot;
                 ltb_typ_LOG_ERROR_TRANSAC_SGA(ln_cnterr).observacion:= $$plsql_unit || ': PQ_SOLOT.p_asig_wf : ' || sqlcode || '- ' || sqlerrm;
           -- Fin 2.0
          END;

        END LOOP;

        EXIT WHEN c_g%notfound;

    END LOOP;

    CLOSE c_g;

    -- Ini 2.0 Insertar el LOG
    ltb_typ_reg_transaccion_sga(1).cantidad_registros := ln_cntrec;
    ltb_typ_reg_transaccion_sga(1).registros_correctos := ln_cntok;
    ltb_typ_reg_transaccion_sga(1).registros_incorrectos := ln_cnterr;

    p_regLogSGA( an_idproceso, ltb_typ_reg_transaccion_sga, ltb_typ_LOG_ERROR_TRANSAC_SGA);
    -- Fin 2.0
  END;

  PROCEDURE p_genSOTBajaOAC_ln IS
    ln_hilos NUMBER;
    ln_idproceso  NUMBER;
    lv_username   varchar2(100);
    lv_password   varchar2(100);
    lv_url        varchar2(200);
    lv_nsp        VARCHAR2(100) := 'OPERACION.' || $$plsql_unit || '.p_genSOTBajaOAC_bl';
    ltb_typ_reg_transaccion_sga typ_reg_transaccion_sga; --2.0
    ltb_typ_LOG_ERROR_TRANSAC_SGA typ_LOG_ERROR_TRANSACCION_SGA;  --2.0
    lv_p_name     VARCHAR2(50) := 'Genera SOT Baja OAC'; --2.0
    lv_sp_name    VARCHAR2(50) := 'p_genSOTBajaOAC_ln'; --2.0

  BEGIN

    SELECT operacion.sq_thidproceso.nextval
          INTO ln_idproceso
          FROM dual;

    -- Ini 2.0 Insertar Log cabecera
    ltb_typ_reg_transaccion_sga(1).proceso_descripcion := lv_p_name;
    ltb_typ_reg_transaccion_sga(1).procedure_descripcion := lv_sp_name;
    ltb_typ_reg_transaccion_sga(1).cantidad_registros := 0;
    ltb_typ_reg_transaccion_sga(1).registros_correctos := 0;
    ltb_typ_reg_transaccion_sga(1).registros_incorrectos := 0;

    p_regLogSGA(ln_idproceso , ltb_typ_reg_transaccion_sga, ltb_typ_LOG_ERROR_TRANSAC_SGA);

    -- Obtener datos iniciales
    ln_hilos    := TO_NUMBER(f_getConstante('OPTHFCNUM'));
    lv_username := f_getConstante('OPTHFCUSER');
    lv_password := f_getConstante('OPTHFCPWD');
    lv_url      := f_getConstante('OPTHFCURL');
    -- Fin 2.0
    -- Cargar datos
    INSERT /*+ append */
    INTO OPERACION.THCUSTOMERID
      (idproceso, customer_id, id_tarea, estado)
      SELECT ln_idproceso, q.customer_id, rownum, 0
       FROM (SELECT t.customer_id
             FROM tim.pf_hfc_prov_bscs@dbl_bscs_bf t,
                  contract_history@dbl_bscs_bf ch,
                  (SELECT o.codigoc as userlastmod
                        FROM tipopedd t, opedd o
                       WHERE t.tipopedd = o.tipopedd
                         AND t.abrev = 'USERCOB') reg
             WHERE t.co_id = ch.co_id
             AND t.action_id = 9
             AND t.estado_prv=5
             AND t.fecha_rpt_eai IS NULL
             AND ch.userlastmod = reg.userlastmod
             AND ch.ch_seqno = (SELECT MAX(c.ch_seqno)
                                       FROM contract_history@dbl_bscs_bf c
                                       WHERE c.co_id = ch.co_id)
             GROUP BY t.customer_id) q;

    COMMIT;

    --Agrupar los hilos
    UPDATE /*+ parallel(b,4)*/ OPERACION.THCUSTOMERID b
     SET b.id_tarea = decode(MOD(b.id_tarea, ln_hilos),
                               0,
                               ln_hilos,
                               MOD(b.id_tarea, ln_hilos))
     WHERE b.idproceso = ln_idproceso;

    COMMIT;

    -- Ejecutar los hilos
    p_ThreadRun(lv_username, lv_password, lv_url, lv_nsp, ln_idproceso,  ln_hilos ); --2.0

    COMMIT;

  END;

  PROCEDURE p_genSOTBajaOAC_bl(an_idproceso NUMBER, an_idtarea NUMBER) IS
    CURSOR c_g IS
      SELECT t.co_id, t.customer_id
         FROM tim.pf_hfc_prov_bscs@dbl_bscs_bf t,
              contract_history@dbl_bscs_bf ch,
              (SELECT o.codigoc as userlastmod
                        FROM tipopedd t, opedd o
                       WHERE t.tipopedd = o.tipopedd
                         AND t.abrev = 'USERCOB') reg --2.0
         WHERE t.co_id = ch.co_id
         AND t.action_id = 9
         AND t.estado_prv=5
         AND t.fecha_rpt_eai IS NULL
         AND ch.ch_seqno = (SELECT MAX(c.ch_seqno)
                                   FROM contract_history@dbl_bscs_bf c
                                   WHERE c.co_id = ch.co_id)
         AND ch.userlastmod = reg.userlastmod --2.0
         AND EXISTS (SELECT 1
                      FROM OPERACION.THCUSTOMERID g
                      WHERE g.idproceso = an_idproceso
                      AND g.id_tarea = an_idtarea
                      and g.customer_id = t.customer_id)
         GROUP BY t.co_id, t.customer_id;

  TYPE tb IS TABLE OF c_g%rowtype INDEX BY BINARY_INTEGER;
  ltb tb;
  le_error EXCEPTION;
  ln_limit_in      NUMBER := 1000;
  ln_cntrec        NUMBER := 0;
  ln_cnterr        NUMBER := 0;
  ln_cntok         NUMBER := 0;
  ltb_typ_reg_transaccion_sga typ_reg_transaccion_sga; --2.0
  ltb_typ_LOG_ERROR_TRANSAC_SGA typ_LOG_ERROR_TRANSACCION_SGA;  --2.0
  ln_estadoprv     NUMBER;
  ln_sot_maxima    NUMBER;
  v_est_servicio   NUMBER;
  v_tiene_cp       NUMBER;
  ln_coderror      NUMBER;
  lv_msgerror      VARCHAR2(4000);
  le_pq            EXCEPTION;
  lv_sp_name       VARCHAR2(50) := 'p_genSOTBajaOAC_bl';   --2.0
    lc_tiptec      opedd.codigoc%type; -- 5.0
    an_idtrancorte  number; -- 5.0
    an_idgrupocorte number; -- 5.0
  
  BEGIN
    -- Obtenet el limite para bulk collect
    SELECT d.codigon
      INTO ln_limit_in
      FROM tipopedd c, opedd d
      WHERE c.abrev = 'PRC_HFC_BULKCOLLECT_LIMIT'
      AND c.tipopedd = d.tipopedd
      AND d.abreviacion = 'p_genera_sot_baja_oac';

    SELECT to_number(c.valor)
         INTO ln_estadoprv
         FROM constante c
         WHERE c.constante = 'ESTPRV_BSCS';

    OPEN c_g;

    LOOP
      FETCH c_g BULK COLLECT INTO ltb limit ln_limit_in;

        FOR c_t IN 1 .. ltb.COUNT LOOP

            ln_cntrec := ln_cntrec + 1 ;

            -- Cambiar estado del registro
            p_updThcustomerId( an_idproceso, an_idtarea, ltb(c_t).customer_id ); --2.0

            SELECT NVL(max(s.codsolot), 0)
              INTO ln_sot_maxima
             FROM solot s,
                  solotpto pto,
                  inssrv ins
             WHERE s.codsolot = pto.codsolot
             AND ins.codinssrv = pto.codinssrv
             AND ins.estinssrv IN (1, 2, 3)
             AND s.estsol in (12, 29)
             AND EXISTS (SELECT 1
                         FROM tipopedd t,
                              opedd o
                          WHERE t.tipopedd = o.tipopedd
                          AND t.abrev = 'TIPREGCONTIWSGABSCS'
                          AND o.codigon = s.tiptra)
             AND s.cod_id = ltb(c_t).co_id; --2.0

            BEGIN

                v_tiene_cp := OPERACION.PQ_SGA_IW.f_val_cambioplan_cod_id_old(ltb(c_t).co_id,ltb(c_t).customer_id);

               SELECT nvl(MAX(ins.estinssrv), 0)
                     INTO v_est_servicio
                     FROM solot s,
                          solotpto pto,
                          inssrv ins
                     WHERE s.codsolot = pto.codsolot
                     AND pto.codinssrv = ins.codinssrv
                     AND ins.estinssrv IN (1, 2,3)
                     AND s.estsol IN (12, 29)
                     AND s.codsolot = ln_sot_maxima;

 -- Ini 5.0
          ln_coderror := 0;      
          
           select a.abreviacion
             into lc_tiptec
             from opedd a
            inner join tipopedd b
               on a.tipopedd = b.tipopedd
              and b.abrev = 'TIPREGCONTIWSGABSCS'
            inner join solot c
               on c.tiptra = a.codigon
            where c.codsolot = ln_sot_maxima;
           

          BEGIN
            select cxc.idtrancorte, cxc.idgrupocorte
              into an_idtrancorte, an_idgrupocorte
              from tipopedd tip
             inner join opedd ope
                on tip.tipopedd = ope.tipopedd
               and tip.abrev = 'BAJAXTIPTRA'
             inner join cxc_transxgrupocorte cxc
                on ope.codigon_aux = cxc.idtragrucorte
             where ope.codigoc = lc_tiptec;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              ln_coderror := -1;
              lv_msgerror := 'No existe configuracion de baja para el tipo de tecnologia ' ||
                             lc_tiptec;
            WHEN OTHERS THEN
              ln_coderror := -2;
              lv_msgerror := 'Error en la ejecucion al obtener el tipo de tecnologia';
          END;
        
          IF ln_coderror <> 0 THEN
            RAISE le_pq;
          END IF;
          -- Fin 5.0 

              IF v_est_servicio = 3 AND v_tiene_cp =0 THEN

                 UPDATE inssrv ins
                        SET ins.estinssrv = 1, ins.fecfin = null
                        WHERE EXISTS ( SELECT codinssrv
                                                 FROM solotpto
                                                 WHERE codsolot = ln_sot_maxima
                                                 AND codinssrv = ins.codinssrv );

                UPDATE insprd ins
                       SET ins.estinsprd = 1, ins.fecfin = null
                       WHERE EXISTS (SELECT codinssrv
                                               FROM solotpto
                                               WHERE codinssrv = ins.codinssrv
                                               AND codsolot=ln_sot_maxima);

                UPDATE tim.pf_hfc_prov_bscs@dbl_bscs_bf t
                       SET t.estado_prv = ln_estadoprv
                       WHERE t.co_id = ltb(c_t).co_id;
          
            operacion.pq_sga_iw.p_genera_sot_oac(ltb(c_t).co_id,
                                                 an_idtrancorte, --4 / 5.0
                                                 an_idgrupocorte, --56 / 5.0
                                                 ln_coderror,
                                                 lv_msgerror);
          
                IF ln_coderror <> 0 THEN
                  RAISE le_pq;
                END IF;

              ELSIF v_est_servicio <> 0 THEN

                  UPDATE tim.pf_hfc_prov_bscs@dbl_bscs_bf t
                         SET t.estado_prv = ln_estadoprv
                         WHERE t.co_id = ltb(c_t).co_id;
          
            operacion.pq_sga_iw.p_genera_sot_oac(ltb(c_t).co_id,
                                                 an_idtrancorte, -- 4
                                                 an_idgrupocorte, --56
                                                 ln_coderror,
                                                 lv_msgerror);
          
                  IF ln_coderror <> 0 THEN
                     RAISE le_pq;
                  END IF;

              END IF;

              ln_cntok := ln_cntok + 1;

              COMMIT; --2.0
            -- Ini 2.0
            EXCEPTION

              WHEN le_pq THEN
                ln_cnterr := ln_cnterr + 1;
                ltb_typ_LOG_ERROR_TRANSAC_SGA(ln_cnterr).co_id:= ltb(c_t).co_id;
                ltb_typ_LOG_ERROR_TRANSAC_SGA(ln_cnterr).customer_id:= ltb(c_t).customer_id;
                ltb_typ_LOG_ERROR_TRANSAC_SGA(ln_cnterr).observacion:= 'PQ_SGA_IW.p_genera_sot_oac : ' || ln_coderror || '- ' || lv_msgerror;

              WHEN OTHERS THEN
                ln_cnterr := ln_cnterr + 1;
                ltb_typ_LOG_ERROR_TRANSAC_SGA(ln_cnterr).co_id:= ltb(c_t).co_id;
                ltb_typ_LOG_ERROR_TRANSAC_SGA(ln_cnterr).customer_id:= ltb(c_t).customer_id;
                ltb_typ_LOG_ERROR_TRANSAC_SGA(ln_cnterr).observacion:= $$plsql_unit || '.' || lv_sp_name || ' : ' || sqlcode || '- ' || sqlerrm;
            -- Fin 2.0
            END;

        END LOOP;

        EXIT WHEN c_g%notfound;

    END LOOP;

    CLOSE c_g;

    -- Ini 2.0 Insertar el LOG
    ltb_typ_reg_transaccion_sga(1).cantidad_registros := ln_cntrec;
    ltb_typ_reg_transaccion_sga(1).registros_correctos := ln_cntok;
    ltb_typ_reg_transaccion_sga(1).registros_incorrectos := ln_cnterr;

    p_regLogSGA( an_idproceso, ltb_typ_reg_transaccion_sga, ltb_typ_LOG_ERROR_TRANSAC_SGA);
    -- Fin 2.0
  END;

  PROCEDURE p_genSOTSuspOAC_ln IS
    ln_hilos     NUMBER;
    ln_idproceso NUMBER;
    lv_username  varchar2(100);
    lv_password  varchar2(100);
    lv_url       varchar2(200);
    lv_nsp       VARCHAR2(100) := 'OPERACION.' || $$plsql_unit ||
                                  '.p_genSOTSuspOAC_bl';
    ltb_typ_reg_transaccion_sga typ_reg_transaccion_sga; --2.0
    ltb_typ_LOG_ERROR_TRANSAC_SGA typ_LOG_ERROR_TRANSACCION_SGA; --2.0
    lv_p_name     VARCHAR2(50) := 'Genera SOT Susp OAC'; --2.0
    lv_sp_name    VARCHAR2(50) := 'p_genSOTSuspOAC_ln'; --2.0

  BEGIN

    SELECT operacion.sq_thidproceso.nextval
           INTO ln_idproceso
           FROM dual;

    -- Ini 2.0 Insertar Log cabecera
    ltb_typ_reg_transaccion_sga(1).proceso_descripcion := lv_p_name;
    ltb_typ_reg_transaccion_sga(1).procedure_descripcion := lv_sp_name;
    ltb_typ_reg_transaccion_sga(1).cantidad_registros := 0;
    ltb_typ_reg_transaccion_sga(1).registros_correctos := 0;
    ltb_typ_reg_transaccion_sga(1).registros_incorrectos := 0;

    p_regLogSGA(ln_idproceso , ltb_typ_reg_transaccion_sga, ltb_typ_LOG_ERROR_TRANSAC_SGA);

    -- Obtener datos iniciales
    ln_hilos    := TO_NUMBER(f_getConstante('OPTHFCNUM'));
    lv_username := f_getConstante('OPTHFCUSER');
    lv_password := f_getConstante('OPTHFCPWD');
    lv_url      := f_getConstante('OPTHFCURL');
    -- Fin 2.0
    -- Cargar datos
    INSERT /*+ append */
    INTO OPERACION.THCUSTOMERID
      (idproceso, customer_id, id_tarea, estado)
      SELECT ln_idproceso, q.customer_id, rownum, 0
        FROM (SELECT /*+ parallel(t,3)*/
               t.customer_id
                FROM tim.pf_hfc_prov_bscs@dbl_bscs_bf t,
                     contract_history@dbl_bscs_bf ch,
                     (SELECT o.codigoc as userlastmod
                        FROM tipopedd t, opedd o
                       WHERE t.tipopedd = o.tipopedd
                         AND t.abrev = 'USERCOB') reg
               WHERE t.co_id = ch.co_id
                 AND t.action_id = 5
                 AND t.estado_prv = 5
                 AND t.fecha_rpt_eai IS NULL
                 AND ch.userlastmod = reg.userlastmod
                 AND ch.ch_seqno = (SELECT MAX(c.ch_seqno)
                                      FROM contract_history@dbl_bscs_bf c
                                     WHERE c.co_id = ch.co_id)
               GROUP BY t.customer_id) q;

    COMMIT;

    --Agrupar los hilos
    UPDATE /*+ parallel(b,4)*/ OPERACION.THCUSTOMERID b
       SET b.id_tarea = decode(MOD(b.id_tarea, ln_hilos),
                               0,
                               ln_hilos,
                               MOD(b.id_tarea, ln_hilos))
     WHERE b.idproceso = ln_idproceso;

    COMMIT;

    -- Ejecutar los hilos
    p_ThreadRun(lv_username,
                        lv_password,
                        lv_url,
                        lv_nsp,
                        ln_idproceso,
                        ln_hilos); --2.0

    COMMIT;

  END;

  PROCEDURE p_genSOTSuspOAC_bl(an_idproceso NUMBER, an_idtarea NUMBER) IS
    CURSOR c_g IS
      SELECT /*+ parallel(t,3)*/
       t.co_id, t.customer_id
        FROM tim.pf_hfc_prov_bscs@dbl_bscs_bf t,
             contract_history@dbl_bscs_bf ch,
             (SELECT o.codigoc as userlastmod
                FROM tipopedd t, opedd o
               WHERE t.tipopedd = o.tipopedd
                 AND t.abrev = 'USERCOB') reg
       WHERE t.co_id = ch.co_id
         AND t.action_id = 5
         AND t.estado_prv = 5
         AND t.fecha_rpt_eai IS NULL
         AND ch.userlastmod = reg.userlastmod
         AND ch.ch_seqno = (SELECT MAX(c.ch_seqno)
                              FROM contract_history@dbl_bscs_bf c
                             WHERE c.co_id = ch.co_id)
         AND EXISTS (SELECT 1
                FROM OPERACION.THCUSTOMERID g
               WHERE g.idproceso = an_idproceso
                 AND g.id_tarea = an_idtarea
                 and g.customer_id = t.customer_id)
       GROUP BY t.co_id, t.customer_id;

    TYPE tb IS TABLE OF c_g%rowtype INDEX BY BINARY_INTEGER;
    ltb tb;
    le_error EXCEPTION;
    ln_limit_in                   NUMBER := 1000;
    ln_cntrec                     NUMBER := 0;
    ln_cnterr                     NUMBER := 0;
    ln_cntok                      NUMBER := 0;
    ltb_typ_reg_transaccion_sga   typ_reg_transaccion_sga; --2.0
    ltb_typ_LOG_ERROR_TRANSAC_SGA typ_LOG_ERROR_TRANSACCION_SGA; --2.0
    ln_estadoprv                  NUMBER;
    ln_coderror                   NUMBER;
    lv_msgerror                   VARCHAR2(4000);
    le_pq                         EXCEPTION;
    lv_sp_name                    VARCHAR2(50) := 'p_genSOTSuspOAC_bl';  --2.0
    ln_codsolot     solot.codsolot%type; -- 5.0
    lc_tiptec       opedd.codigoc%type; -- 5.0
    an_idtrancorte  number; -- 5.0
    an_idgrupocorte number; -- 5.0
  
  BEGIN
    -- Obtenet el limite para bulk collect
    SELECT d.codigon
           INTO ln_limit_in
    FROM tipopedd c, opedd d
    WHERE c.abrev = 'PRC_HFC_BULKCOLLECT_LIMIT'
    AND c.tipopedd = d.tipopedd
    AND d.abreviacion = 'p_genera_sot_suspension_oac';

    SELECT to_number(c.valor)
      INTO ln_estadoprv
      FROM constante c
     WHERE c.constante = 'ESTPRV_BSCS';

    OPEN c_g;

    LOOP
      FETCH c_g BULK COLLECT
        INTO ltb limit ln_limit_in;

      FOR c_t IN 1 .. ltb.COUNT LOOP

        ln_cntrec := ln_cntrec + 1;

        -- Fecha de proceso
        p_updThcustomerId( an_idproceso, an_idtarea, ltb(c_t).customer_id ); --2.0

        BEGIN

          UPDATE tim.pf_hfc_prov_bscs@dbl_bscs_bf t
             SET t.estado_prv = ln_estadoprv
           WHERE t.co_id = ltb(c_t).co_id;

         -- Ini 5.0 
          ln_coderror := 0;
          ln_codsolot := OPERACION.PQ_SGA_IW.f_max_sot_x_cod_id(ltb(c_t)
                                                                .co_id);     
           
          select a.abreviacion into lc_tiptec
            from opedd a
           inner join tipopedd b
              on a.tipopedd = b.tipopedd
             and b.abrev = 'TIPREGCONTIWSGABSCS'
           inner join solot c
              on c.tiptra = a.codigon
           where c.codsolot = ln_codsolot;

          BEGIN
            select cxc.idtrancorte, cxc.idgrupocorte
              into an_idtrancorte, an_idgrupocorte
              from tipopedd tip
             inner join opedd ope
                on tip.tipopedd = ope.tipopedd
               and tip.abrev = 'SUSXTIPTRA'
             inner join cxc_transxgrupocorte cxc
                on ope.codigon_aux = cxc.idtragrucorte
             where ope.codigoc = lc_tiptec;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              ln_coderror := -1;
              lv_msgerror := 'No existe configuracion de suspension para el tipo de tecnologia ' ||
                             lc_tiptec;
            WHEN OTHERS THEN
              ln_coderror := -2;
              lv_msgerror := 'Error en la ejecucion al obtener el tipo de tecnologia';
          END;

          IF ln_coderror <> 0 THEN
            RAISE le_pq;
          END IF;

          -- Fin 5.0

          OPERACION.PQ_SGA_IW.p_genera_sot_oac(ltb(c_t).co_id,
                                               an_idtrancorte,--2 / 5.0
                                               an_idgrupocorte, --56 / 5.0
                                               ln_coderror,
                                               lv_msgerror);

          IF ln_coderror <> 0 THEN
            RAISE le_pq;
          END IF;

          ln_cntok := ln_cntok + 1;

          COMMIT;   --2.0
        -- Ini 2.0
        EXCEPTION

          WHEN le_pq THEN
            ln_cnterr := ln_cnterr + 1;
            ltb_typ_LOG_ERROR_TRANSAC_SGA(ln_cnterr).co_id := ltb(c_t).co_id;
            ltb_typ_LOG_ERROR_TRANSAC_SGA(ln_cnterr).customer_id := ltb(c_t)
                                                                    .customer_id;
            ltb_typ_LOG_ERROR_TRANSAC_SGA(ln_cnterr).observacion := 'PQ_SGA_IW.p_genera_sot_oac : ' ||
                                                                    ln_coderror || '- ' ||
                                                                    lv_msgerror;

          WHEN OTHERS THEN
            ln_cnterr := ln_cnterr + 1;
            ltb_typ_LOG_ERROR_TRANSAC_SGA(ln_cnterr).co_id := ltb(c_t).co_id;
            ltb_typ_LOG_ERROR_TRANSAC_SGA(ln_cnterr).customer_id := ltb(c_t)
                                                                    .customer_id;
            ltb_typ_LOG_ERROR_TRANSAC_SGA(ln_cnterr).observacion := $$plsql_unit ||
                                                                    '.' || lv_sp_name || ' : ' ||
                                                                    sqlcode || '- ' ||
                                                                    sqlerrm;
        -- Fin 2.0
        END;

      END LOOP;

      EXIT WHEN c_g%notfound;

    END LOOP;

    CLOSE c_g;

    -- Ini 2.0 Insertar el LOG
    ltb_typ_reg_transaccion_sga(1).cantidad_registros := ln_cntrec;
    ltb_typ_reg_transaccion_sga(1).registros_correctos := ln_cntok;
    ltb_typ_reg_transaccion_sga(1).registros_incorrectos := ln_cnterr;

    p_regLogSGA( an_idproceso, ltb_typ_reg_transaccion_sga, ltb_typ_LOG_ERROR_TRANSAC_SGA);
    -- Fin 2.0
  END;

PROCEDURE p_genSOTRecoOAC_ln IS
    ln_hilos NUMBER;
    ln_idproceso NUMBER;
    lv_username  varchar2(100);
    lv_password  varchar2(100);
    lv_url       varchar2(200);
    lv_nsp VARCHAR2(100) := 'OPERACION.' || $$plsql_unit || '.p_genSOTRecoOAC_bl';
    ltb_typ_reg_transaccion_sga typ_reg_transaccion_sga; --2.0
    ltb_typ_LOG_ERROR_TRANSAC_SGA typ_LOG_ERROR_TRANSACCION_SGA;  --2.0
    lv_p_name     VARCHAR2(50) := 'Genera SOT Reco OAC'; --2.0
    lv_sp_name    VARCHAR2(50) := 'p_genSOTRecoOAC_ln'; --2.0

  BEGIN

    SELECT operacion.sq_thidproceso.nextval
          INTO ln_idproceso
          FROM dual;

    -- Ini 2.0 Insertar Log cabecera
    ltb_typ_reg_transaccion_sga(1).proceso_descripcion := lv_p_name;
    ltb_typ_reg_transaccion_sga(1).procedure_descripcion := lv_sp_name;
    ltb_typ_reg_transaccion_sga(1).cantidad_registros := 0;
    ltb_typ_reg_transaccion_sga(1).registros_correctos := 0;
    ltb_typ_reg_transaccion_sga(1).registros_incorrectos := 0;

    p_regLogSGA(ln_idproceso , ltb_typ_reg_transaccion_sga, ltb_typ_LOG_ERROR_TRANSAC_SGA);

    -- Obtener datos iniciales
    ln_hilos    := TO_NUMBER(f_getConstante('OPTHFCNUM'));
    lv_username := f_getConstante('OPTHFCUSER');
    lv_password := f_getConstante('OPTHFCPWD');
    lv_url      := f_getConstante('OPTHFCURL');
    -- Fin 2.0
    -- Cargar datos
    INSERT /*+ append */
    INTO OPERACION.THCUSTOMERID
      (idproceso, customer_id, id_tarea, estado)
      SELECT ln_idproceso, q.customer_id, rownum, 0
       FROM (SELECT /*+ parallel(t,3)*/
                    t.customer_id
              FROM tim.pf_hfc_prov_bscs@dbl_bscs_bf t,
                   contract_history@dbl_bscs_bf ch,
                   (SELECT o.codigoc as userlastmod
                     FROM tipopedd t, opedd o
                     WHERE t.tipopedd = o.tipopedd
                     AND t.abrev = 'USERCOB') reg
              WHERE t.co_id = ch.co_id
              AND t.action_id = 3
              AND t.estado_prv = 5
              AND t.fecha_rpt_eai IS NULL
              AND ch.userlastmod = reg.userlastmod
              AND ch.ch_seqno = (SELECT MAX(c.ch_seqno)
                                  FROM contract_history@dbl_bscs_bf c
                                  WHERE c.co_id = ch.co_id)
              GROUP BY t.customer_id) q;

    COMMIT;

    --Agrupar los hilos
    UPDATE /*+ parallel(b,4)*/ OPERACION.THCUSTOMERID b
     SET b.id_tarea = decode(MOD(b.id_tarea, ln_hilos),
                               0,
                               ln_hilos,
                               MOD(b.id_tarea, ln_hilos))
     WHERE b.idproceso = ln_idproceso;

    COMMIT;

    -- Ejecutar los hilos
    p_ThreadRun(lv_username, lv_password, lv_url, lv_nsp, ln_idproceso,  ln_hilos );  --2.0

    COMMIT;

  END;

  PROCEDURE p_genSOTRecoOAC_bl(an_idproceso NUMBER,
                             an_idtarea   NUMBER) IS
    CURSOR c_g IS
      SELECT /*+ parallel(t,3)*/
            t.co_id, t.customer_id
         FROM tim.pf_hfc_prov_bscs@dbl_bscs_bf t,
              contract_history@dbl_bscs_bf ch,
              (SELECT o.codigoc as userlastmod
                FROM tipopedd t, opedd o
                WHERE t.tipopedd = o.tipopedd
                AND t.abrev = 'USERCOB') reg
         WHERE t.co_id = ch.co_id
         AND t.action_id = 3
         AND t.estado_prv = 5
         AND t.fecha_rpt_eai IS NULL
         AND ch.userlastmod = reg.userlastmod
         AND ch.ch_seqno = (SELECT MAX(c.ch_seqno)
                            FROM contract_history@dbl_bscs_bf c
                            WHERE c.co_id = ch.co_id)
         AND EXISTS (SELECT 1
                      FROM OPERACION.THCUSTOMERID g
                      WHERE g.idproceso = an_idproceso
                      AND g.id_tarea = an_idtarea
                      and g.customer_id = t.customer_id)
         GROUP BY t.co_id, t.customer_id;

  TYPE tb IS TABLE OF c_g%rowtype INDEX BY BINARY_INTEGER;
  ltb tb;
  le_error                        EXCEPTION;
  ln_limit_in                     NUMBER := 1000;
  ln_cntrec                       NUMBER := 0;
  ln_cnterr                       NUMBER := 0;
  ln_cntok                        NUMBER := 0;
  ltb_typ_reg_transaccion_sga typ_reg_transaccion_sga; --2.0
  ltb_typ_LOG_ERROR_TRANSAC_SGA typ_LOG_ERROR_TRANSACCION_SGA; --2.0
  ln_estadoprv                    NUMBER;
  ln_coderror                     NUMBER;
  lv_msgerror                     VARCHAR2(4000);
  le_pq                           EXCEPTION;
  lv_sp_name                      VARCHAR2(50) := 'p_genSOTRecoOAC_bl'; --2.0
    ln_codsolot     solot.codsolot%type; -- 5.0
    lc_tiptec       opedd.codigoc%type; -- 5.0
    an_idtrancorte  number; -- 5.0
    an_idgrupocorte number; -- 5.0
  
  BEGIN
    -- Obtenet el limite para bulk collect
    SELECT d.codigon
      INTO ln_limit_in
      FROM tipopedd c, opedd d
      WHERE c.abrev = 'PRC_HFC_BULKCOLLECT_LIMIT'
      AND c.tipopedd = d.tipopedd
      AND d.abreviacion = 'p_genera_sot_reconexion_oac';

     SELECT to_number(c.valor)
      INTO ln_estadoprv
      FROM constante c
      WHERE c.constante = 'ESTPRV_BSCS';

    OPEN c_g;

    LOOP
      FETCH c_g BULK COLLECT INTO ltb limit ln_limit_in;

        FOR c_t IN 1 .. ltb.COUNT LOOP

          ln_cntrec := ln_cntrec + 1 ;

          -- Fecha de proceso
          p_updThcustomerId( an_idproceso, an_idtarea, ltb(c_t).customer_id ); --2.0

          BEGIN

            UPDATE tim.pf_hfc_prov_bscs@dbl_bscs_bf t
               SET t.estado_prv = ln_estadoprv
               WHERE t.co_id = ltb(c_t).co_id;

 -- Ini 5.0
          ln_coderror := 0;
          ln_codsolot := OPERACION.PQ_SGA_IW.f_max_sot_x_cod_id(ltb(c_t)
                                                                .co_id);

          select a.abreviacion
            into lc_tiptec
            from opedd a
           inner join tipopedd b
              on a.tipopedd = b.tipopedd
             and b.abrev = 'TIPREGCONTIWSGABSCS'
           inner join solot c
              on c.tiptra = a.codigon
           where c.codsolot = ln_codsolot;

          BEGIN
            select cxc.idtrancorte, cxc.idgrupocorte
              into an_idtrancorte, an_idgrupocorte
              from tipopedd tip
             inner join opedd ope
                on tip.tipopedd = ope.tipopedd
               and tip.abrev = 'RECXTIPTRA'
             inner join cxc_transxgrupocorte cxc
                on ope.codigon_aux = cxc.idtragrucorte
             where ope.codigoc = lc_tiptec;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              ln_coderror := -1;
              lv_msgerror := 'No existe configuraci?n de reconexion para el tipo de tecnologia ' ||
                             lc_tiptec;
            WHEN OTHERS THEN
              ln_coderror := -2;
              lv_msgerror := 'Error en la ejecucion al obtener el tipo de tecnologia';
          END;
        
          IF ln_coderror <> 0 THEN
            RAISE le_pq;
          END IF;
        
          -- Fin 5.0 

            OPERACION.PQ_SGA_IW.p_genera_sot_oac(ltb(c_t).co_id, an_idtrancorte, an_idgrupocorte, ln_coderror, lv_msgerror); --5.0

            IF ln_coderror <> 0 THEN
               RAISE le_pq;
            END IF;

            ln_cntok := ln_cntok + 1;

            COMMIT; --2.0
          -- Ini 2.0
          EXCEPTION

            WHEN le_pq THEN
              ln_cnterr := ln_cnterr + 1;
              ltb_typ_LOG_ERROR_TRANSAC_SGA(ln_cnterr).co_id:= ltb(c_t).co_id;
              ltb_typ_LOG_ERROR_TRANSAC_SGA(ln_cnterr).customer_id:= ltb(c_t).customer_id;
              ltb_typ_LOG_ERROR_TRANSAC_SGA(ln_cnterr).observacion:= 'PQ_SGA_IW.p_genera_sot_oac : ' || ln_coderror || '- ' || lv_msgerror;

            WHEN OTHERS THEN
              ln_cnterr := ln_cnterr + 1;
              ltb_typ_LOG_ERROR_TRANSAC_SGA(ln_cnterr).co_id:= ltb(c_t).co_id;
              ltb_typ_LOG_ERROR_TRANSAC_SGA(ln_cnterr).customer_id:= ltb(c_t).customer_id;
              ltb_typ_LOG_ERROR_TRANSAC_SGA(ln_cnterr).observacion:= $$plsql_unit || '.' || lv_sp_name || ' : ' || sqlcode || '- ' || sqlerrm;
           -- Fin 2.0
          END;

        END LOOP;

        EXIT WHEN c_g%notfound;

    END LOOP;

    CLOSE c_g;

    -- Ini 2.0 Insertar el LOG
    ltb_typ_reg_transaccion_sga(1).cantidad_registros := ln_cntrec;
    ltb_typ_reg_transaccion_sga(1).registros_correctos := ln_cntok;
    ltb_typ_reg_transaccion_sga(1).registros_incorrectos := ln_cnterr;

    p_regLogSGA( an_idproceso, ltb_typ_reg_transaccion_sga, ltb_typ_LOG_ERROR_TRANSAC_SGA);
    -- Fin 2.0
  END;

  PROCEDURE p_alineaJANUS_ln IS
    ln_hilos NUMBER;
    ln_idproceso NUMBER;
    lv_username  varchar2(100);
    lv_password  varchar2(100);
    lv_url       varchar2(200);
    lv_nsp VARCHAR2(100) := 'OPERACION.' || $$plsql_unit || '.p_alineaJANUS_bl';
    ltb_typ_reg_transaccion_sga typ_reg_transaccion_sga; --2.0
    ltb_typ_LOG_ERROR_TRANSAC_SGA typ_LOG_ERROR_TRANSACCION_SGA; --2.0
    lv_p_name     VARCHAR2(50) := 'Alinea Janus'; --2.0
    lv_sp_name    VARCHAR2(50) := 'p_alineaJANUS_ln'; --2.0

  BEGIN

     -- Validamos antes del enviamos las transacciones
    OPERACION.PQ_SGA_JANUS.p_validacion_pre_janus; --2.0
    COMMIT; --2.0

    SELECT operacion.sq_thidproceso.nextval
          INTO ln_idproceso
          FROM dual;

    -- Ini 2.0 Insertar Log cabecera
    ltb_typ_reg_transaccion_sga(1).proceso_descripcion := lv_p_name;
    ltb_typ_reg_transaccion_sga(1).procedure_descripcion := lv_sp_name;
    ltb_typ_reg_transaccion_sga(1).cantidad_registros := 0;
    ltb_typ_reg_transaccion_sga(1).registros_correctos := 0;
    ltb_typ_reg_transaccion_sga(1).registros_incorrectos := 0;

    p_regLogSGA(ln_idproceso , ltb_typ_reg_transaccion_sga, ltb_typ_LOG_ERROR_TRANSAC_SGA);

    -- Obtener datos iniciales
    ln_hilos    := TO_NUMBER(f_getConstante('OPTHFCNUM'));
    lv_username := f_getConstante('OPTHFCUSER');
    lv_password := f_getConstante('OPTHFCPWD');
    lv_url      := f_getConstante('OPTHFCURL');
    -- Fin 2.0
    -- Cargar datos
    INSERT /*+ append */
    INTO OPERACION.THCODSOLOT
      (idproceso, codsolot, id_tarea, estado)
      SELECT ln_idproceso, q.codsolot, rownum, 0
       FROM (SELECT o.codsolot
               FROM operacion.prov_sga_janus o
               WHERE o.estado = 0
               AND o.codsolot IS NOT NULL
               GROUP BY o.codsolot) q;

    COMMIT;

    --Agrupar los hilos
    UPDATE /*+ parallel(b,4)*/ OPERACION.THCODSOLOT b
     SET b.id_tarea = decode(MOD(b.id_tarea, ln_hilos),
                               0,
                               ln_hilos,
                               MOD(b.id_tarea, ln_hilos))
     WHERE b.idproceso = ln_idproceso;

    COMMIT;

    -- Ejecutar los hilos
    p_ThreadRun(lv_username, lv_password, lv_url, lv_nsp, ln_idproceso,  ln_hilos ); --2.0

    COMMIT;

  END;

  PROCEDURE p_alineaJANUS_bl(an_idproceso NUMBER,
                             an_idtarea NUMBER) IS
    CURSOR c_g IS
      SELECT t.codsolot
       FROM OPERACION.THCODSOLOT t
       WHERE t.idproceso = an_idproceso
       AND t.id_tarea = an_idtarea;

    CURSOR c_sotpendiente(an_codsolot NUMBER) IS
      SELECT o.*
        FROM operacion.prov_sga_janus o
        WHERE o.estado = 0
        AND o.codsolot = an_codsolot
       ORDER BY o.nsecuencia ASC; -- 2.0
    --INI 4.0
    cursor c_tareajanus_pend is
      select s.cod_id,
             s.codsolot,
             tw.idtareawf,
             tw.mottarchg,
             f.idwf,
             tw.tarea,
             tw.tareadef,
             (select o.codigoc
                from tipopedd t, opedd o
               where t.tipopedd = o.tipopedd
                 and t.abrev = 'TAREADEF_SRB'
                 and o.abreviacion = 'TAREA_JANUS'
                 and o.codigon_aux = 1
                 and o.codigon = tw.tareadef) tipo
        from solot s, wf f, tareawf tw
       where s.codsolot = f.codsolot
         and f.idwf = tw.idwf
         and f.valido = 1
         and tw.esttarea = 1
         and exists (select o.codigoc
                from tipopedd t, opedd o
               where t.tipopedd = o.tipopedd
                 and t.abrev = 'TAREADEF_SRB'
                 and o.abreviacion = 'TAREA_JANUS'
                 and o.codigon_aux = 1
                 and o.codigon = tw.tareadef);
   -- FIN 4.0

    TYPE tb IS TABLE OF c_g%rowtype INDEX BY BINARY_INTEGER;
    ltb                           tb;
    ln_limit_in                   NUMBER := 1000;
    ln_cntrec                     NUMBER := 0;
    ln_cnterr                     NUMBER := 0;
    ln_cntok                      NUMBER := 0;
    ltb_typ_reg_transaccion_sga   typ_reg_transaccion_sga; --2.0
    ltb_typ_LOG_ERROR_TRANSAC_SGA typ_LOG_ERROR_TRANSACCION_SGA; --2.0
    lv_msgerror                   VARCHAR2(4000);
    ln_tiposot                    NUMBER;
    ln_pendiente                  NUMBER;
    an_error                      NUMBER;
    av_error                      VARCHAR2(4000);
    ln_trans_enviada              NUMBER;
    ln_trans_cerrada              NUMBER;
    cn_estcerrado CONSTANT NUMBER := 4;
    le_pq    EXCEPTION; --2.0
    le_error EXCEPTION; --2.0
    lv_sp_name       VARCHAR2(50) := 'p_alineaJANUS_bl'; --2.0
    lb_subrec        NUMBER := 0;
    ln_servtelefonia number;--4.0
    ln_valexist_linea number;--4.0
  BEGIN

    -- Obtenet el limite para bulk collect
    SELECT d.codigon
      INTO ln_limit_in
      FROM tipopedd c, opedd d
     WHERE c.abrev = 'PRC_HFC_BULKCOLLECT_LIMIT'
       AND c.tipopedd = d.tipopedd
       AND d.abreviacion = 'p_job_alinea_janus';


    OPEN c_g;

    LOOP
      FETCH c_g BULK COLLECT INTO ltb limit ln_limit_in;

      FOR c_t IN 1 .. ltb.COUNT LOOP

        BEGIN --2.0
          ln_cntrec := ln_cntrec + 1;

          ln_tiposot := operacion.pq_sga_iw.f_val_tipo_serv_sot(ltb(c_t).codsolot);

          --Fecha de proceso
          p_updThcodsolot(an_idproceso, an_idtarea, ltb(c_t).codsolot); --2.0

          lb_subrec := 0;

          FOR c_p IN c_sotpendiente(ltb(c_t).codsolot) LOOP

            BEGIN

              lb_subrec    := 1;

              ln_pendiente := OPERACION.PQ_SGA_JANUS.f_val_prov_janus_pend(c_p.cod_id);

              lv_msgerror  := ''; --2.0

              IF ln_pendiente = 0 THEN
                IF c_p.nsecuencia = 1 THEN
                  IF c_p.accion = 1 THEN
                    --Enviamos la Alta a Janus
                    --INI 4.0
                    operacion.pq_sga_janus.p_altanumero_janus(c_p.codsolot,an_error,av_error);
                    lv_msgerror := 'OPERACION.PQ_SGA_JANUS.P_ALTANUMERO_JANUS: ' ||av_error;
                    --FIN 4.0
                  ELSIF c_p.accion = 2 THEN
                    --Enviamos la Baja del Numero
                    OPERACION.PQ_SGA_JANUS.p_envia_baja_numero_janus(ln_tiposot,c_p.numero,c_p.cod_id,to_char(c_p.customer_id),an_error,av_error);
                    lv_msgerror := 'OPERACION.PQ_SGA_JANUS.p_envia_baja_numero_janus: ' ||av_error;
                  -- INI 4.0
                  ELSIF c_p.accion = 16 THEN
                    operacion.pq_sga_janus.p_cambio_plan_janus_hfc(c_p.codsolot,
                                                                   an_error,
                                                                   av_error);
                    lv_msgerror := 'OPERACION.PQ_SGA_JANUS.P_CAMBIO_PLAN_JANUS_HFC: ' ||
                                   av_error;
                 -- FIN 4.0
                  END IF;
                ELSIF c_p.nsecuencia = 2 and c_p.accion = 2 then
                  -- Enviamos Baja del Cliente
                  -- INI 4.0
                  ln_valexist_linea := operacion.pq_sga_janus.f_val_exis_linea_janus(c_p.numero); -- Validamos si la linea se elimino para enviar la baja del cliente
                  if ln_valexist_linea = 0 then
                    operacion.pq_sga_janus.p_envia_baja_cliente_janus(ln_tiposot,
                                                                      c_p.cod_id,
                                                                      to_char(c_p.customer_id),
                                                                      an_error,
                                                                      av_error);
                    lv_msgerror := 'OPERACION.PQ_SGA_JANUS.P_ENVIA_BAJA_CLIENTE_JANUS: ' ||
                                   av_error;
                  end if;
                ELSIF c_p.nsecuencia = 3 and c_p.accion = 1 then
                  -- Enviamos alta del numero
                  operacion.pq_sga_janus.p_altanumero_janus(c_p.codsolot,
                                                            an_error,
                                                            av_error);
                END IF;

                IF an_error = 1 or an_error = -10 THEN -- FIN 4.0
                  -- Se envio correctamente
                  OPERACION.PQ_SGA_JANUS.p_update_prov_sga_janus(c_p.idprov,1,an_error,av_error,an_error,av_error);
                  IF an_error <> 0 THEN--2.0
                    lv_msgerror := lv_msgerror || ' // ' ||'OPERACION.PQ_SGA_JANUS.p_update_prov_sga_janus: ' ||av_error; --2.0
                    RAISE le_pq;--2.0
                  END IF;
                ELSE
                  RAISE le_pq; --2.0

                END IF;

                ln_cntok := ln_cntok + 1; --2.0

                goto salto; --4.0

              ELSE
                -- si existe pendiente no envia nada.
                ln_cntok := ln_cntok + 1; --2.0
                goto salto; --4.0
              END IF;

            EXCEPTION
              WHEN le_pq THEN
                ln_cnterr := ln_cnterr + 1;
                ltb_typ_LOG_ERROR_TRANSAC_SGA(ln_cnterr).codsolot := ltb(c_t).codsolot; --2.0
                ltb_typ_LOG_ERROR_TRANSAC_SGA(ln_cnterr).observacion := lv_msgerror; --2.0
                GOTO salto;

              WHEN OTHERS THEN
                ln_cnterr := ln_cnterr + 1;
                ltb_typ_LOG_ERROR_TRANSAC_SGA(ln_cnterr).codsolot := ltb(c_t).codsolot; --2.0
                ltb_typ_LOG_ERROR_TRANSAC_SGA(ln_cnterr).observacion := $$plsql_unit || '.' ||lv_sp_name ||' : ' ||sqlcode || '- ' ||sqlerrm; --2.0
                GOTO salto; --2.0

            END;

          END LOOP;

          IF lb_subrec = 0 THEN
            ln_cntok := ln_cntok + 1;
          END IF;

          <<salto>>
          av_error := 1;

          COMMIT;
        -- Ini 2.0
        EXCEPTION
          WHEN OTHERS THEN
            ln_cnterr := ln_cnterr + 1;
            ltb_typ_LOG_ERROR_TRANSAC_SGA(ln_cnterr).codsolot := ltb(c_t).codsolot;
            ltb_typ_LOG_ERROR_TRANSAC_SGA(ln_cnterr).observacion := $$plsql_unit || '.' ||lv_sp_name ||' : ' ||sqlcode || '- ' ||sqlerrm;
        -- Fin 2.0
        END;

      END LOOP;

      EXIT WHEN c_g%notfound;

    END LOOP;

    close c_g; --4.0

    -- Cerrar Tareas Janus
    FOR c_t IN c_tareajanus_pend LOOP
      -- INI 4.0
      ln_servtelefonia := operacion.pq_sga_janus.f_val_serv_tlf_sot(c_t.codsolot);

      if ln_servtelefonia = 0 then
        if c_t.tipo = 'BAJA' then
          pq_wf.p_chg_status_tareawf(c_t.idtareawf,
                                     cn_estcerrado,
                                     cn_estcerrado,
                                     c_t.mottarchg,
                                     sysdate,
                                     sysdate);

          opewf.pq_wf.p_chg_status_tareawf(c_t.idtareawf,
                                           cn_estcerrado,
                                           cn_estnointerviene,
                                           0,
                                           sysdate,
                                           sysdate);
        elsif c_t.tipo = 'CPLAN' then
          opewf.pq_wf.p_chg_status_tareawf(c_t.idtareawf,
                                           cn_estcerrado,
                                           cn_estnointerviene,
                                           0,
                                           sysdate,
                                           sysdate);
        end if;

      else
      -- FIN 4.0

        SELECT COUNT(j.estado)
          INTO ln_trans_enviada
          FROM operacion.prov_sga_janus j
         WHERE j.codsolot = c_t.codsolot
           AND j.cod_id = c_t.cod_id;

        IF ln_trans_enviada > 0 THEN
          SELECT COUNT(j.estado)
            INTO ln_trans_cerrada
            FROM operacion.prov_sga_janus j
           WHERE j.codsolot = c_t.codsolot
             AND j.cod_id = c_t.cod_id
             AND j.estado = 0;

          IF ln_trans_cerrada = 0 THEN
            IF c_t.tipo = 'BAJA' THEN -- 4.0
              pq_wf.p_chg_status_tareawf(c_t.idtareawf,cn_estcerrado,cn_estcerrado,c_t.mottarchg,sysdate,sysdate);
          -- INI 4.0
              operacion.pq_sga_iw.p_update_prov_hfc_bscs(c_t.idtareawf,
                                                         c_t.idwf,
                                                         c_t.tarea,
                                                         c_t.tareadef);
            elsif c_t.tipo = 'CPLAN' then
              pq_wf.p_chg_status_tareawf(c_t.idtareawf,
                                         cn_estcerrado,
                                         cn_estcerrado,
                                         c_t.mottarchg,
                                         sysdate,
                                         sysdate);
            end if;
          end if;
        else
          if c_t.tipo = 'BAJA' then
            operacion.PQ_SGA_JANUS.p_libera_janusxsot(c_t.idtareawf, c_t.idwf, c_t.tarea, c_t.tareadef);
          END IF;
        END IF;
      END IF;

    END LOOP;
    -- FIN 4.0
    -- Ini 2.0 Insertar el LOG
    ltb_typ_reg_transaccion_sga(1).cantidad_registros := ln_cntrec;
    ltb_typ_reg_transaccion_sga(1).registros_correctos := ln_cntok;
    ltb_typ_reg_transaccion_sga(1).registros_incorrectos := ln_cnterr;

    p_regLogSGA(an_idproceso,ltb_typ_reg_transaccion_sga,ltb_typ_LOG_ERROR_TRANSAC_SGA);
    -- Fin 2.0
  END;

  -- Ini 2.0
  PROCEDURE p_ThreadRun(av_username  VARCHAR2,
                                av_password  VARCHAR2,
                                av_url       VARCHAR2,
                                av_nsp       VARCHAR2,
                                an_idproceso NUMBER,
                                an_hilos     IN NUMBER) AS

    LANGUAGE JAVA NAME 'com.creo.operacion.ProcesaGrupoHilo.procesa(java.lang.String,java.lang.String,java.lang.String,java.lang.String, long, int)';
  -- Fin 2.0
  -- Ini 2.0
  PROCEDURE p_updThcodsolot(an_idproceso NUMBER, an_idtarea NUMBER, an_codsolot NUMBER ) IS
    PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    UPDATE operacion.thcodsolot
      SET estado = 1,
          fecstart = systimestamp
      WHERE idproceso = an_idproceso
      AND id_tarea = an_idtarea
      AND codsolot = an_codsolot;

    COMMIT;

  END;
  -- Fin 2.0
  -- Ini 2.0
  PROCEDURE p_updThcustomerId(an_idproceso NUMBER, an_idtarea NUMBER, an_customer_id NUMBER ) IS
    PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    UPDATE operacion.thcustomerid
      SET estado = 1,
          fecstart = CASE WHEN fecstart IS NULL THEN systimestamp ELSE fecstart END,
          fecfinish = systimestamp
      WHERE idproceso = an_idproceso
      AND id_tarea = an_idtarea
      AND customer_id = an_customer_id;

    COMMIT;

  END;
  -- Fin 2.0
  FUNCTION f_getConstante(av_constante operacion.constante.constante%TYPE) RETURN VARCHAR2 IS
    lv_valor VARCHAR2(100);
  BEGIN
    -- Ini 2.0
    IF av_constante = 'OPTHFCPWD' THEN
       SELECT utl_raw.cast_to_varchar2(valor)
              INTO lv_valor
              FROM constante
              WHERE constante = av_constante;
    ELSE -- Fin 2.0
      SELECT valor
        INTO lv_valor
        FROM constante
       WHERE constante = av_constante;
    END IF;

    RETURN lv_valor;

  END;
  -- Ini 2.0
  PROCEDURE p_regLogSGA( an_idproceso NUMBER, atyp_reg_transaccion_sga typ_reg_transaccion_sga, atyp_LOG_ERROR_TRANSACCION_SGA typ_LOG_ERROR_TRANSACCION_SGA ) IS
    PRAGMA AUTONOMOUS_TRANSACTION;
  ln_idlog    NUMBER := 1;
  ln_contador NUMBER := 0;
  ln_cant     NUMBER; --3.0
  BEGIN
    SELECT count(*)
           INTO ln_contador
           FROM OPERACION.REG_TRANSACCION_SGA
           WHERE idproceso = an_idproceso;

    IF ln_contador > 0 THEN
        SELECT idlog
           INTO ln_idlog
           FROM OPERACION.REG_TRANSACCION_SGA
           WHERE idproceso = an_idproceso;

        UPDATE OPERACION.REG_TRANSACCION_SGA
               SET cantidad_registros = cantidad_registros + atyp_reg_transaccion_sga(1).CANTIDAD_REGISTROS,
                   registros_correctos = registros_correctos +  atyp_reg_transaccion_sga(1).REGISTROS_CORRECTOS,
                   registros_incorrectos = registros_incorrectos + atyp_reg_transaccion_sga(1).REGISTROS_INCORRECTOS
               WHERE idlog = ln_idlog;

    ELSE
        SELECT OPERACION.SQ_REG_TRANSACCION_SGA.NEXTVAL
               INTO ln_idlog
               FROM DUAL;

        INSERT INTO OPERACION.REG_TRANSACCION_SGA( IDLOG, PROCESO_DESCRIPCION, PROCEDURE_DESCRIPCION, CANTIDAD_REGISTROS, REGISTROS_CORRECTOS, registros_incorrectos, IDPROCESO)
         VALUES ( ln_idlog, atyp_reg_transaccion_sga(1).proceso_descripcion , atyp_reg_transaccion_sga(1).procedure_descripcion, atyp_reg_transaccion_sga(1).CANTIDAD_REGISTROS,
                atyp_reg_transaccion_sga(1).REGISTROS_CORRECTOS, atyp_reg_transaccion_sga(1).REGISTROS_INCORRECTOS, an_idproceso);
    END IF;

    FOR c_t IN 1 .. atyp_LOG_ERROR_TRANSACCION_SGA.COUNT LOOP

      --INI 3.0
      SELECT count(*)
        INTO ln_cant
        FROM HISTORICO.LOG_ERROR_TRANSACCION_SGA
       WHERE codsolot = atyp_LOG_ERROR_TRANSACCION_SGA(c_t).codsolot;

      IF ln_cant > 0 THEN
         UPDATE historico.log_error_transaccion_sga
            SET IDLOGCAB = ln_idlog , observacion = atyp_LOG_ERROR_TRANSACCION_SGA(c_t).observacion
          WHERE codsolot = atyp_LOG_ERROR_TRANSACCION_SGA(c_t).codsolot;
      ELSE
      --FIN 3.0
      INSERT INTO HISTORICO.LOG_ERROR_TRANSACCION_SGA ( IDLOG, IDLOGCAB, codsolot, co_id, customer_id, observacion)
             VALUES ( OPERACION.SQ_LOG_ERROR_TRANSAC_SGA.NEXTVAL, ln_idlog, atyp_LOG_ERROR_TRANSACCION_SGA(c_t).codsolot,
          atyp_LOG_ERROR_TRANSACCION_SGA(c_t).co_id, atyp_LOG_ERROR_TRANSACCION_SGA(c_t).customer_id,
          atyp_LOG_ERROR_TRANSACCION_SGA(c_t).observacion);
      END IF;--3.0
    END LOOP;

    COMMIT;

  END;
 -- Fin 2.0
 -- Ini 2.0
  PROCEDURE p_sndMail(an_idproceso NUMBER)IS
   lv_destino               VARCHAR2(500) := f_getConstante('OPTHFCMAIL');
   lv_cuerpo                opewf.cola_send_mail_job.cuerpo%TYPE;
   ln_idlog                 operacion.REG_TRANSACCION_SGA.idlog%TYPE;
   ln_idproceso             operacion.REG_TRANSACCION_SGA.idproceso%TYPE;
   lv_proceso_descripcion   operacion.REG_TRANSACCION_SGA.proceso_descripcion%TYPE;
   lv_procedure_descripcion operacion.REG_TRANSACCION_SGA.procedure_descripcion%TYPE;
   ld_fecusu                operacion.REG_TRANSACCION_SGA.fecusu%TYPE;
   ln_cantidad_registros    NUMBER;
   ln_registros_correctos   NUMBER;
   ln_registros_incorrectos NUMBER;

 BEGIN
    SELECT r.idlog,
           r.idproceso,
           r.proceso_descripcion,
           r.procedure_descripcion,
           r.fecusu,
           r.cantidad_registros,
           r.registros_correctos,
           r.registros_incorrectos
       INTO ln_idlog,
           ln_idproceso,
           lv_proceso_descripcion,
           lv_procedure_descripcion,
           ld_fecusu,
            ln_cantidad_registros,
            ln_registros_correctos,
            ln_registros_incorrectos
       FROM OPERACION.REG_TRANSACCION_SGA r
       WHERE r.idproceso = an_idproceso;

    IF ln_registros_incorrectos > 0 THEN
       lv_cuerpo := lv_cuerpo ||
                    'Se encontraron errores en la ejecucion del siguiente proceso: ' || chr(13) ||
                    '-------------------------------------------------------------' || chr(13) ||
                    ' Id Log                   : ' || ln_idlog  || chr(13) ||
                    ' Id Proceso               : ' || ln_idproceso || chr(13) ||
                    ' Nombre                   : ' || lv_proceso_descripcion || chr(13) ||
                    ' Procedimiento            : ' || lv_procedure_descripcion || chr(13) ||
                    ' Fecha de proceso         : ' || to_timestamp( ld_fecusu) || chr(13) ||
                    '-------------------------------------------------------------' || chr(13) ||
                    ' Registros Procesados     : ' || ln_cantidad_registros || chr(13) ||
                    ' Registros sin errores    : ' || ln_registros_correctos || chr(13) ||
                    ' Registros con errores    : ' || ln_registros_incorrectos || chr(13);
       PRODUCCION.P_ENVIA_CORREO_DE_TEXTO_ATT(lv_proceso_descripcion, lv_destino, lv_cuerpo);

       COMMIT;

    END IF;

 END;
 -- Fin 2.0
END;
/
